Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 846AC7D9188
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 10:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345512AbjJ0I3l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 04:29:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345530AbjJ0I3k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 04:29:40 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A8A1B4
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 01:29:38 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id 5b1f17b1804b1-40850b244beso13914095e9.2
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 01:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698395376; x=1699000176; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=uawWEYvnU1I7SsFfXaVgl6JK99lbvsL15u5TMr7vQn8=;
        b=kZnyDNrgUdvps3inypOlxAFYYC2FzwSE55+NstJwjaPD6CidtvXZ37kK198VCbJm3H
         PZqylqZFnyhZSCR+sR5N++fM++tgIu8N13bA0R0VUISzqcsS4McTVjKutWlxOpONcJfL
         QjW77Z5HPNoxJaMhJBL5VkZwOcJDn3hM1cB33YSEz0sxLFwNSG1T1CbcJ68d7zrxTIcL
         6HPXBvWMg/p32mLTk4gRQxXA2rpk9A2BybfrwY/qvxa+tqwyOfETGidfUwRiCYPpmsqg
         b2pdOwYtAWby58m5brbEPY7b8Ts4XXeSD/zMEvmYOPo5oJqWHz6SO4uGMBTmDxovKJMe
         2rvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698395376; x=1699000176;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uawWEYvnU1I7SsFfXaVgl6JK99lbvsL15u5TMr7vQn8=;
        b=XXW7ChiEKDN72nm3CWId1HGZVtmyRRxzRMiACIc2Q6eCEDCDc6qUJPmF4F0MNpCtAq
         zYzu4savgZG9rixf7korR0JxPd2pkFS/eR++4RVC24k4tGhriKZ6kr7Plh0peIJtFU0C
         dNpErNb0BXA0TztH/NvC93GtnuSkz6RKsSJTaR1Uk1wF+01vpiqFaZFJK5XbKPRH3gLB
         tP7gMaGcz+v8O3D5LUlNGyXc5yGYEiUL6OphKvYnQ2Ieppq8tmNswGBXOiN9EbTR8rhh
         mCiHinC/CkWZkpF0T2w10l9wo3PPRq3Wzji3XkF6Uu4xO8QF9Mwl0z0vSvKVqCr6KwOM
         VcTg==
X-Gm-Message-State: AOJu0YwOJTyjaqoeM9dRE+Yn1lNnnvXF8cUvm4FeoYddSYMZ71Bfj/tL
        ZLxY7KRGDyg3SnAOJVWlxYE=
X-Google-Smtp-Source: AGHT+IEhOFiWCBEfo+wHr0Pp7y4a5kzJHetZXB/E/pRI16RlTXShKDIVxn2mzdbzdHFgDhukzBbnCg==
X-Received: by 2002:a05:600c:1c06:b0:404:4b6f:d70d with SMTP id j6-20020a05600c1c0600b004044b6fd70dmr1726336wms.17.1698395376081;
        Fri, 27 Oct 2023 01:29:36 -0700 (PDT)
Received: from [192.168.10.177] (54-240-197-235.amazon.com. [54.240.197.235])
        by smtp.gmail.com with ESMTPSA id h9-20020a05600c314900b0040849ce7116sm4519893wmo.43.2023.10.27.01.29.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Oct 2023 01:29:35 -0700 (PDT)
Message-ID: <0aabb787-eacf-48d9-83b6-3769c7436cf9@gmail.com>
Date:   Fri, 27 Oct 2023 09:29:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH v3 18/28] hw/xen: only remove peers of PCI NICs on unplug
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
 <20231025145042.627381-19-dwmw2@infradead.org>
From:   "Durrant, Paul" <xadimgnik@gmail.com>
In-Reply-To: <20231025145042.627381-19-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/10/2023 15:50, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> When the Xen guest asks to unplug *emulated* NICs, it's kind of unhelpful
> also to unplug the peer of the *Xen* PV NIC.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>   hw/i386/xen/xen_platform.c | 9 +++++++--
>   1 file changed, 7 insertions(+), 2 deletions(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>
