Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 821DF7D56A2
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 17:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343802AbjJXPhE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 11:37:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343730AbjJXPhD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 11:37:03 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEF39109
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 08:37:00 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-40836ea8cbaso34326845e9.0
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 08:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698161819; x=1698766619; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=A8ZSzBnis7KNXr8T2w9cXrHfqOor5r4c/mfSgp7VlQs=;
        b=mkXgGOoeb1x0NMlj4ZtLlGQUHLX2nLTMrWa0lQesS5U55cCSRw7nOS0xRCIo+O6+2M
         NH08ABSLOnTYjcG/XDQnUOWRiRwhWJcI4wxyKtNPlRCvwiFi9U3hUqBGfTrG3X32uLob
         AtxUXiudDRUpvXaqLteC1rnzYsY1gBwANYmdm1/m5B08aYEqgBxvzkBw2sRU6/ZN8voh
         ++VK22JYn0RvGNbCLEkj2WGVIWxYRR7IHEA3uip5aochulMkpg54x/qli2MvVKeRqkJk
         nfkdaGQWI3Mqotj2Wo69kHGlEkTw1zlmg5Qu7k7bxAxHve/rehuzDrh+iyIK+6t0ZzsN
         rqQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698161819; x=1698766619;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A8ZSzBnis7KNXr8T2w9cXrHfqOor5r4c/mfSgp7VlQs=;
        b=pRQ3KJ7ZIRGzMzT0V4S9OPvNjDbj5vmi0SM3kDYRt33sQ/14pGwfsFlsbZ06ZtWk8n
         fsH+eC9PPYAedP0kMLJLdYwypjXbX59yjNDRVlDNyzSrx/Uodleb452u1kyPIx7I09CN
         sbo6WJxDvFAeCt/CMzniNiZ+6+0eCDb1XD6HY7mFa1zODIYqP5WUYetK70qAfNFNaFUd
         HpkoOZv5Fsd+dguYzp/jLDpZJ3HjfwJGJfme5yqiLX9v88nRV+FnJPa5di0luYSTO5HO
         pZC82rXb5UVqTvyRsyLCGGYUjr6Ze+e1WtD30Wrbgv+rUppUFPrRvyr/uLng56rH4U+r
         dEcQ==
X-Gm-Message-State: AOJu0Yyvhb5Fw+4pXXC980ns/R8H1tHU2sVRyYVVowQBaHY4POEmGzXd
        U5jPewb2Ecv+KYO1vo0elg4=
X-Google-Smtp-Source: AGHT+IF1dcmYSOIBAYhyDN+rJjDUtbiR7bpGX9yxUQ7nJ0qnc13saq8mF6pQ7QGMUfeqrZmcr7qgJw==
X-Received: by 2002:a05:600c:1d19:b0:401:b2c7:349b with SMTP id l25-20020a05600c1d1900b00401b2c7349bmr9736055wms.7.1698161819005;
        Tue, 24 Oct 2023 08:36:59 -0700 (PDT)
Received: from [192.168.6.66] (54-240-197-238.amazon.com. [54.240.197.238])
        by smtp.gmail.com with ESMTPSA id x24-20020a05600c179800b0040523bef620sm785126wmo.0.2023.10.24.08.36.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Oct 2023 08:36:58 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <979ce4f2-195c-4488-869e-72c9abed1339@xen.org>
Date:   Tue, 24 Oct 2023 16:36:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH v2 10/24] hw/xen: populate store frontend nodes with
 XenStore PFN/port
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, qemu-devel@nongnu.org
Cc:     Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Cleber Rosa <crosa@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Beraldo Leal <bleal@redhat.com>, qemu-block@nongnu.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Bernhard Beschow <shentey@gmail.com>,
        Joel Upham <jupham125@gmail.com>
References: <20231019154020.99080-1-dwmw2@infradead.org>
 <20231019154020.99080-11-dwmw2@infradead.org>
Organization: Xen Project
In-Reply-To: <20231019154020.99080-11-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/10/2023 16:40, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> This is kind of redundant since without being able to get these through
> some other method (HVMOP_get_param) the guest wouldn't be able to access
> XenStore in order to find them. But Xen populates them, and it does
> allow guests to *rebind* to the event channel port after a reset.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>   hw/i386/kvm/xen_xenstore.c | 11 +++++++++++
>   1 file changed, 11 insertions(+)
> 

Reviewed-by: Paul Durrant <paul@xen.org>

