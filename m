Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1E07D549A
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 17:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbjJXPC6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 11:02:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjJXPC5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 11:02:57 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D455F111
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 08:02:54 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id 2adb3069b0e04-507a29c7eefso6844926e87.1
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 08:02:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698159773; x=1698764573; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CgHp0CJaaQlW610O/NVGeBqWOSNojjcDIIfF8qOnyh8=;
        b=OCEyzaaMj4GMVXmDDJLYBvu69e7UDqHQxazhZbfLTPhRZlk5A6623hAY30Qk0vmG0t
         d5/5yvsLvuGbLBB1j6/OfGpKEo6vO5F/o/63Zt/uXcx2FLaHkryLuyFaA0J/9Gzx4DDA
         IIgbiYLi5uFmcYr32GH76p+ycCUqmXtnpFpUQbFsDGJaxZa4oRH8ZEZIKT7sbjH0I4t3
         ZrS8Y6Z3UzLcxd6JcFj8atr8PJUrOP5M+RAkNud56zeso8Jm09WY7woaBswX03S+qsfT
         YECR6/kf8cYbZOug+xPbqfaWRFdi+AkXmS1qc3b9aMlOfLUgjHb0rOrlVGW1YqB9M1/h
         0M+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698159773; x=1698764573;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CgHp0CJaaQlW610O/NVGeBqWOSNojjcDIIfF8qOnyh8=;
        b=I/c7JI+6OjVLLdKn+1+30kjaJrmd1sfKEn27Z+jzzJoTSV6975SorOqgZDl6hPhbQh
         f8h9taQdn7EEYUjzRd+0O64fSv0WOgTKSQ/5w9btwHLFlK93MmwpJ6qrj5zT0F9TVjAg
         RF3clOjlTNS6F1nGTlD6gbxEqXP7WUNJjbQS5xz/3WXw4nAqdEmMdIb6Ghw/0nsZhJgD
         vo6hsW8dirjKH/QVe4eXKSNt1PgMKzrwpzwCLA0wL71wgdsBfc3tL6Eqvnsm4l1AqeWD
         9Nc7WcqrKaD5TN/fmA20IKP9ZGnE61v8W79N3v4ixMlm4oylAoudRSaw9RffvPTzBrUV
         RiHQ==
X-Gm-Message-State: AOJu0YxPjnvkNrb9wNTEqLYIwk0yAyjT5PwMgNQDNF6vhOaxtVDhXxX1
        BIB9umSGDtGCHh0i5ZG0pXI=
X-Google-Smtp-Source: AGHT+IH9T45ADuXoRcFMFSb5Oytx69M3MV46mrRNCIVJ622Q0DyMPbV1Z877betPlfNUrQXWzUmZCw==
X-Received: by 2002:a05:6512:3b8e:b0:502:ffdf:b098 with SMTP id g14-20020a0565123b8e00b00502ffdfb098mr11070376lfv.6.1698159772803;
        Tue, 24 Oct 2023 08:02:52 -0700 (PDT)
Received: from [192.168.6.66] (54-240-197-238.amazon.com. [54.240.197.238])
        by smtp.gmail.com with ESMTPSA id f5-20020a056000128500b0031c6581d55esm10091262wrx.91.2023.10.24.08.02.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Oct 2023 08:02:52 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <bd55f12a-1a01-40fb-a61a-dd5ddbd58557@xen.org>
Date:   Tue, 24 Oct 2023 16:02:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH v2 03/24] hw/xen: select kernel mode for per-vCPU event
 channel upcall vector
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
 <20231019154020.99080-4-dwmw2@infradead.org>
Organization: Xen Project
In-Reply-To: <20231019154020.99080-4-dwmw2@infradead.org>
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

On 19/10/2023 16:39, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> A guest which has configured the per-vCPU upcall vector may set the
> HVM_PARAM_CALLBACK_IRQ param to fairly much anything other than zero.
> 
> For example, Linux v6.0+ after commit b1c3497e604 ("x86/xen: Add support
> for HVMOP_set_evtchn_upcall_vector") will just do this after setting the
> vector:
> 
>         /* Trick toolstack to think we are enlightened. */
>         if (!cpu)
>                 rc = xen_set_callback_via(1);
> 
> That's explicitly setting the delivery to GSI#1, but it's supposed to be
> overridden by the per-vCPU vector setting. This mostly works in Qemu
> *except* for the logic to enable the in-kernel handling of event channels,
> which falsely determines that the kernel cannot accelerate GSI delivery
> in this case.
> 
> Add a kvm_xen_has_vcpu_callback_vector() to report whether vCPU#0 has
> the vector set, and use that in xen_evtchn_set_callback_param() to
> enable the kernel acceleration features even when the param *appears*
> to be set to target a GSI.
> 
> Preserve the Xen behaviour that when HVM_PARAM_CALLBACK_IRQ is set to
> *zero* the event channel delivery is disabled completely. (Which is
> what that bizarre guest behaviour is working round in the first place.)
> 
> Fixes: 91cce756179 ("hw/xen: Add xen_evtchn device for event channel emulation")
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>   hw/i386/kvm/xen_evtchn.c  | 6 ++++++
>   include/sysemu/kvm_xen.h  | 1 +
>   target/i386/kvm/xen-emu.c | 7 +++++++
>   3 files changed, 14 insertions(+)
> 

Reviewed-by: Paul Durrant <paul@xen.org>

