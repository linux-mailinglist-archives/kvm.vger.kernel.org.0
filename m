Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C953D7D93B9
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 11:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbjJ0Jbm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 05:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235105AbjJ0Jbk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 05:31:40 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D41751B3
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 02:31:37 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id ffacd0b85a97d-313e742a787so1071885f8f.1
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 02:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698399096; x=1699003896; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=QTs9kivD/Mfn/UAvscBipfMJBB8Bih4r6SL3tafSaEI=;
        b=NqORXLAlrTksIWulXOTlH6lXTFt5IIMNLZsv8SyjAF/cqpsKDoATZw6aoO7BQTl18P
         TFf1dbiW5j0V/Gl/SP2OuMfemWa55+e+WXDtn47nYsjZADGOvX0Lll/2RNHMFReQaAU8
         uxs8Mql6f2y5+/UiJO2qNavbI/Ld1YLfdDzUiUzmRixLTr+mMvyWqsfv2CtFSIGvp4xr
         5+VETnwxGxDt2gPRoHciDgf2x8gnKqCv+73OPQ2nNSmXlBVeak4DoZ8WVPbYoAbKYkT8
         kxM76dJIY02aILfyIWxEZci/Vut6QHVAQEs8IxMVwk09w6ebGAnIBYujMawlwhh6ycuh
         TMnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698399096; x=1699003896;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QTs9kivD/Mfn/UAvscBipfMJBB8Bih4r6SL3tafSaEI=;
        b=FuArRSLlWc0yuhE+6+ySb4/UrlQny/bFCeq7llfkGIH1FTv2odTPomgl+WPFNmGkK/
         BUCeK/Wd4DjY195rTRt/avMb+Ps5F0k7m747xcBtUfACPTXK3hkDN4SCAA8cnn6uGVWu
         GxIGGvFN8vi+Kezqf3qpWXdOU97ICuHXXQc/x7UwORJ2uqj4MMqBX2WZbe4h0V2vUt4r
         y94tKY+21XusAz6aPWzytQQYlbtoT1uwEPaxJbb2YrD3mGmIg5mGysub5BM2hNwEFpnG
         eVqDQWoQ+jugjPO36ducKNlYzmD0lT5+/L5LdJXtE62V4/XW3Cu47A7fu0wUeG+Nr8hE
         bYXA==
X-Gm-Message-State: AOJu0Yznryfjq/MoNzO87toobIKS2kaN8SQYqRIq62qDG3mmZzrcbvMk
        ut/E+pQIT3UIdvdfQBNsbAk=
X-Google-Smtp-Source: AGHT+IFMyYswcfqDBXUjHeiT0+hX+rLzRUjfI/ImjdtPGYKdKySflidFjyugVF6CSqz3WojMmjv6tQ==
X-Received: by 2002:a05:6000:80b:b0:32d:a045:cf71 with SMTP id bt11-20020a056000080b00b0032da045cf71mr3223387wrb.21.1698399095684;
        Fri, 27 Oct 2023 02:31:35 -0700 (PDT)
Received: from [192.168.10.177] (54-240-197-235.amazon.com. [54.240.197.235])
        by smtp.gmail.com with ESMTPSA id x11-20020adfffcb000000b003258934a4bcsm1356830wrs.42.2023.10.27.02.31.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Oct 2023 02:31:35 -0700 (PDT)
Message-ID: <7f5487e0-f794-4e58-8aa3-81ca3dc3f3db@gmail.com>
Date:   Fri, 27 Oct 2023 10:31:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH v3 23/28] net: report list of available models according
 to platform
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, qemu-devel@nongnu.org
Cc:     Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Paul Durrant <paul@xen.org>,
        =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Jason Wang <jasowang@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-block@nongnu.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Bernhard Beschow <shentey@gmail.com>,
        Joel Upham <jupham125@gmail.com>
References: <20231025145042.627381-1-dwmw2@infradead.org>
 <20231025145042.627381-24-dwmw2@infradead.org>
From:   "Durrant, Paul" <xadimgnik@gmail.com>
In-Reply-To: <20231025145042.627381-24-dwmw2@infradead.org>
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

On 25/10/2023 15:50, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> By noting the models for which a configuration was requested, we can give
> the user an accurate list of which NIC models were actually available on
> the platform/configuration that was otherwise chosen.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>   net/net.c | 94 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 94 insertions(+)
> 

Reviewed-by: Paul Durrant <paul@xen.org>

