Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7DA592FF4
	for <lists+kvm@lfdr.de>; Mon, 15 Aug 2022 15:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233106AbiHONcn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Aug 2022 09:32:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242981AbiHONcI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Aug 2022 09:32:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 06835175B2
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 06:32:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660570327;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Zp+SY9WJSpph5Cd4FsOVThBt8VK08HhqVJA59O9rE/U=;
        b=dPytI0Gx4DG4hpN2075itR0VyvVso7T2Z5KHgoU3Vj/73RMhpNXYRpF/01wAEQZHTFGivA
        AqUqJn6e/uOryImyaDaaZHonWCbE1Q21ocfxECo7J1mXvVT3DTgniaRzUBXxTOqkdpwTuP
        3/N6AarmcqFPFk+Lx6jDSUwx+V8HiGk=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-558-VobNp_h0Ou-VLXHENZ8KAQ-1; Mon, 15 Aug 2022 09:32:03 -0400
X-MC-Unique: VobNp_h0Ou-VLXHENZ8KAQ-1
Received: by mail-qk1-f199.google.com with SMTP id bi22-20020a05620a319600b006b92f4b2ebbso7020322qkb.22
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 06:32:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc;
        bh=Zp+SY9WJSpph5Cd4FsOVThBt8VK08HhqVJA59O9rE/U=;
        b=TEODW17MHWR6KZ2TVGhX143Wpj5edStVrT/lt9kz2U34KWiaZ/+TXQQk/Ue4bgRT8p
         zLkFlau/3nRE6ncOctztmEUbw/8O9bcVewY5x2zXsqlmx9knHw8wLxC/fnHCnPzobtOr
         4ccz3EQRVCGPBkG3GjquSnE3hmlRKiGIdS1/e/kcufAwiAr3L2hbUJMxZcHc5TEB8AGx
         xptlfvct1l+5Pk0gCbUQhdfQBOFGaXTusqbN5ENa8YbEDlwm9S7V0XtGPlL1/Lxd1eAG
         0l8rS+kF1pZcxjhL8Xh45/owfQIn7U8nxliuEq3hxlKtC2oIT2OzN3iyeDnfGtFkYeTg
         ZynQ==
X-Gm-Message-State: ACgBeo1xJ8nZ6So+wkhta0zLFWIGuVxqHJjg/NsBk/eQk/oVYgZwRcxE
        EVSaMIK68reJxRodfwIKgRvYzLr2bjjpZBXkfHH5GK7DnO5WG8eabhJHd28KKy5sTG+uNtdTpOd
        y6gETm3THdJnh
X-Received: by 2002:a05:622a:12:b0:343:7535:6981 with SMTP id x18-20020a05622a001200b0034375356981mr12072903qtw.287.1660570323013;
        Mon, 15 Aug 2022 06:32:03 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5ERgk9oEFxgGZLC7l5SFCv5qxqDmF6WvY1zcIdfJHQmpGSUEcYJAkqW+ftA9+FRSQYLWqtdQ==
X-Received: by 2002:a05:622a:12:b0:343:7535:6981 with SMTP id x18-20020a05622a001200b0034375356981mr12072887qtw.287.1660570322774;
        Mon, 15 Aug 2022 06:32:02 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id h4-20020ac81384000000b00342fb07944fsm8001736qtj.82.2022.08.15.06.32.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 06:32:02 -0700 (PDT)
Message-ID: <26f6e26110b99e0a8cace173a221694d4e94cc1c.camel@redhat.com>
Subject: Re: [PATCH v2 1/9] KVM: x86: check validity of argument to
 KVM_SET_MP_STATE
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, vkuznets@redhat.com
Date:   Mon, 15 Aug 2022 16:31:58 +0300
In-Reply-To: <20220811210605.402337-2-pbonzini@redhat.com>
References: <20220811210605.402337-1-pbonzini@redhat.com>
         <20220811210605.402337-2-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-08-11 at 17:05 -0400, Paolo Bonzini wrote:
> An invalid argument to KVM_SET_MP_STATE has no effect other than making the
> vCPU fail to run at the next KVM_RUN.  Since it is extremely unlikely that
> any userspace is relying on it, fail with -EINVAL just like for other
> architectures.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 20 +++++++++++++++++---
>  1 file changed, 17 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 132d662d9713..c44348bb6ef2 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10653,7 +10653,8 @@ static inline int vcpu_block(struct kvm_vcpu *vcpu)
>         case KVM_MP_STATE_INIT_RECEIVED:
>                 break;
>         default:
> -               return -EINTR;
> +               WARN_ON(1);

Very small nitpick: Maybe WARN_ON_ONCE after all? 
(but I don't see any way after this patch to have invalid mp_state)

> +               break;



>         }
>         return 1;
>  }
> @@ -11094,9 +11095,22 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
>  
>         vcpu_load(vcpu);
>  
> -       if (!lapic_in_kernel(vcpu) &&
> -           mp_state->mp_state != KVM_MP_STATE_RUNNABLE)
> +       switch (mp_state->mp_state) {
> +       case KVM_MP_STATE_UNINITIALIZED:
> +       case KVM_MP_STATE_HALTED:
> +       case KVM_MP_STATE_AP_RESET_HOLD:
> +       case KVM_MP_STATE_INIT_RECEIVED:
> +       case KVM_MP_STATE_SIPI_RECEIVED:
> +               if (!lapic_in_kernel(vcpu))
> +                       goto out;
> +               break;
> +
> +       case KVM_MP_STATE_RUNNABLE:
> +               break;
> +
> +       default:
>                 goto out;
> +       }
>  
>         /*
>          * KVM_MP_STATE_INIT_RECEIVED means the processor is in



Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

