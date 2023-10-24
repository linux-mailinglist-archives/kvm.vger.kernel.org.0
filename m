Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60A007D4FBB
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 14:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231801AbjJXM3x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 08:29:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231521AbjJXM3v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 08:29:51 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EADDDA2
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 05:29:49 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id 38308e7fff4ca-2c59a4dd14cso1492251fa.2
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 05:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698150588; x=1698755388; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6W+0Okxg9I00CjQFxVnV6ntSdHCpG+SP4y3vva54Y8E=;
        b=UKHYGvG+MKj29EvBl7095qa426Xc0nDWuE8WsaJ8rbjTncNYR9apWk0DyhLsV79VBm
         2g93eYfQ8gC/aVJaKWXpRQQaCNE//ckXAAQnodnAFcgumfWBhQl8IAqyRcdtmYW2zV2a
         AjZwYe3/pHpwYD5Im5UDRTdkvFa2jqYxIxe07/3dls2wuqL7+C54DanaNgBfvsUyWpJX
         sPY8Ktxd9U1BZJXmAGrrxJR4GjKHqXB8dvtfwBp1vsIoe48qaswX1QcCMr0ilRsPZfwU
         PLvGLu+XFCUU3nuXpNbWft+dGPTuz0aHGYi9Brzq/gbPwb2mJ/K4nIIoxTQ5yAtAs6Ni
         /vXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698150588; x=1698755388;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6W+0Okxg9I00CjQFxVnV6ntSdHCpG+SP4y3vva54Y8E=;
        b=erjj6UUEJ2UVBg6NvgKQ9lrRPa5Ur/eiHkkCGTwij1V3R13Feb7E67AYCWoF7i7XPc
         dInwGt89ZVWpXLGg44pmVZgZsxxE6NjFjoMwm9rlxuK++ogjIhGgaCkJ8EyQ1pHWf2ZY
         K8KFP9bUlrhbFIVCDuip/HmALdVY4jLh7g+jv7wZIWLfBoIBQKDNxR7m+s9pxqbnhL3V
         r5Z7N4CYzPLmD9YlFvMhuL+RTuC/CtnyOkIgMeo9r22Q9p4VfiCLnzrMXNs6SReUWHuz
         8c20S30zZrKCgAC1ngFtVdzzMrZnAZ1GLJBbdLFzpLy+/ceNFYkphs2igEhb18uzl0ay
         Wojg==
X-Gm-Message-State: AOJu0YyyWPZvZtfomJ0G93YPdOmM/4QfpuznDEEIrJj3fe4hRvCLepte
        8oZORg3CWdXtuaDXIH+DnIE=
X-Google-Smtp-Source: AGHT+IHQXaOLRvR4fMkOTyZrwynUH3dk9Z2h9mBZ5MJ5cJrzsBPSIpwKJU7nccdNSAx+0KKpMf83eA==
X-Received: by 2002:a2e:3c19:0:b0:2c5:1809:69ba with SMTP id j25-20020a2e3c19000000b002c5180969bamr8123521lja.40.1698150587872;
        Tue, 24 Oct 2023 05:29:47 -0700 (PDT)
Received: from [192.168.6.66] (54-240-197-238.amazon.com. [54.240.197.238])
        by smtp.gmail.com with ESMTPSA id x22-20020a05600c189600b004083a105f27sm16404394wmp.26.2023.10.24.05.29.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Oct 2023 05:29:47 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <9eeb2cac-2f22-4e42-9765-2fd5e5a960fa@xen.org>
Date:   Tue, 24 Oct 2023 13:29:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH 02/12] hw/xen: select kernel mode for per-vCPU event
 channel upcall vector
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
 <20231016151909.22133-3-dwmw2@infradead.org>
Organization: Xen Project
In-Reply-To: <20231016151909.22133-3-dwmw2@infradead.org>
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

On 16/10/2023 16:18, David Woodhouse wrote:
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
> That's explicitly setting the delivery to GSI#, but it's supposed to be
> overridden by the per-vCPU vector setting. This mostly works in QEMU
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
> diff --git a/hw/i386/kvm/xen_evtchn.c b/hw/i386/kvm/xen_evtchn.c
> index 4df973022c..d72dca6591 100644
> --- a/hw/i386/kvm/xen_evtchn.c
> +++ b/hw/i386/kvm/xen_evtchn.c
> @@ -490,6 +490,12 @@ int xen_evtchn_set_callback_param(uint64_t param)
>           break;
>       }
>   
> +    /* If the guest has set a per-vCPU callback vector, prefer that. */
> +    if (gsi && kvm_xen_has_vcpu_callback_vector()) {
> +        in_kernel = kvm_xen_has_cap(EVTCHN_SEND);
> +        gsi = 0;
> +    }
> +

So this deals with setting the callback via after setting the upcall 
vector. What happens if the guest then disables the upcall vector (by 
setting it to zero)? Xen checks 'v->arch.hvm.evtchn_upcall_vector != 0' 
for every event delivery.

   Paul

