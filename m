Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2506D7D4FDB
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 14:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232280AbjJXMfp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 08:35:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231531AbjJXMfn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 08:35:43 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02B00120
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 05:35:41 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id 5b1f17b1804b1-408002b5b9fso36448945e9.3
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 05:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698150939; x=1698755739; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Jt2cxa6ddwVCH4+7Ko2rashlvH36j0rjOEJrfGyoF5I=;
        b=RTzkQzHzPD+Xnw2VyRV3INsSpuDstSQtiBIBYpUjM1oqJirPmQ4GOQ6Nni3oTQVm/R
         2YOo4pbAZ1PP7U0dU2TxY9cWg5N4YCfaqwX5RrfstrAsS9udCosRloj7lEtm5nJbEWWJ
         evPkko//F1dqefSOaBzoR5ZhsuLxJLqlhxm+Zj32eFuXLBAM3xL+lc3dSGUPqwJoCVtq
         nfI6tXlWP6qhwIxanNN0MURJuM4H+usoRcoookr0g7QtoZ8Fcq9UKSdgfYH59a6tAXTv
         Y0OkpFs6/WKUK6ehK08j9wA9EPw+1bHaTga9sw1hH7dmP8Hy/FZu3FfULPVMKSDXl3vq
         LPew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698150939; x=1698755739;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jt2cxa6ddwVCH4+7Ko2rashlvH36j0rjOEJrfGyoF5I=;
        b=RyLnsmvm/PysF/r18jmo4JGcM6ZZOje1iNjAObLHHtTa21lDsh09f3bjWhssVWncdF
         nkbbfO8X5S7pkzUAirmn+VtA+G21uygVav1VxkLvHMiWomKTnxJOTB41tyF/ZurxG/Iv
         3f3gzniaOb7zbvt/+C5ZmjkmvR3dg90tMmnqJRMpjxKUP145VRO2IW2xWpfw2qiq7Mlc
         pxAc7kP5pZgkqLqcrTmSujRzRuT2jOvs3mn9rT+IQPVRG9ymW6FqDnr2TKC9+7/wQ47Q
         QCgEAS9uaT/vMCoyorPLV5YoH6A4/v05qhPCjXpGp8WxjdFHWGPBPoCEk7SPyk9Qgm58
         ElWA==
X-Gm-Message-State: AOJu0YyePkuQ/XrY37bst194e7Aq66AHC8Y8/QX2k0/vzMZWLSY7y/oj
        rINZQFYqJ7/U8o1L+pO79NU=
X-Google-Smtp-Source: AGHT+IHcviZwp5sEUV8HujATdN4eCJmLKJnxtVpxw/CtGmvUMvR85yAd1lcelMOmu9e8/DWbEGFBkQ==
X-Received: by 2002:a05:600c:154e:b0:405:4a78:a890 with SMTP id f14-20020a05600c154e00b004054a78a890mr9583548wmg.8.1698150939091;
        Tue, 24 Oct 2023 05:35:39 -0700 (PDT)
Received: from [192.168.6.66] (54-240-197-230.amazon.com. [54.240.197.230])
        by smtp.gmail.com with ESMTPSA id p15-20020a05600c1d8f00b00402d34ea099sm16729462wms.29.2023.10.24.05.35.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Oct 2023 05:35:38 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <84ac7780-e17a-4957-b49b-46a8307eb9da@xen.org>
Date:   Tue, 24 Oct 2023 13:35:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH 05/12] hw/xen: populate store frontend nodes with XenStore
 PFN/port
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, qemu-devel@nongnu.org
Cc:     Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-block@nongnu.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org
References: <20231016151909.22133-1-dwmw2@infradead.org>
 <20231016151909.22133-6-dwmw2@infradead.org>
Organization: Xen Project
In-Reply-To: <20231016151909.22133-6-dwmw2@infradead.org>
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

On 16/10/2023 16:19, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> This is kind of redundant since without being able to get these through
> ome other method (HVMOP_get_param) the guest wouldn't be able to access

^ typo

> XenStore in order to find them. But Xen populates them, and it does
> allow guests to *rebind* to the event channel port after a reset.
> 

... although this can also be done by querying the remote end of the 
port before reset.

> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>   hw/i386/kvm/xen_xenstore.c | 10 ++++++++++
>   1 file changed, 10 insertions(+)
> 

Reviewed-by: Paul Durrant <paul@xen.org>

