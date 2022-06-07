Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E92D953F825
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 10:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238173AbiFGI2I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 04:28:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238180AbiFGI2H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 04:28:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1AD7E2ED68
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 01:28:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654590485;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tokJJ7z8KnX5/xUJtCDdcremg3FcOkmF1aZGy9Uoj8o=;
        b=DYPdDtV4/Lxqf+LET/5i1e+N51G09lRe+lXmhfBXViPHDksXiRdDbpsYeCdigYIg5C9pFP
        XCAq+X7Z/jFhsCod/CgrgsxIVYQQeSXnEEX9uLj2uSyyNWvOfNLnWS48JTPaEbSAfDPx4e
        r0b6e52UUn0KbDbqj+uPoqJxm2xjzKU=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-608-xSZe2qQ-NXWTrMWkYVaVzQ-1; Tue, 07 Jun 2022 04:27:56 -0400
X-MC-Unique: xSZe2qQ-NXWTrMWkYVaVzQ-1
Received: by mail-qt1-f199.google.com with SMTP id s9-20020a05622a178900b00304e6d79297so6135071qtk.23
        for <kvm@vger.kernel.org>; Tue, 07 Jun 2022 01:27:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=tokJJ7z8KnX5/xUJtCDdcremg3FcOkmF1aZGy9Uoj8o=;
        b=QobjDtYLf7DdVBmSQrAp8ESABlrzAn6FdHeMAtn/TY5cS3jypq1kuQoPFXZFZOwTTO
         Iy7wyNldBe5wTxngPb6aAvPEOY6u3auND53QI9faDaT0swSyg3bxV1gkPWCq7t5mEhta
         o5c1jmCgTRnRQR8h3AbovbiDQ1UfSPwktsLWuvN8gsnGNw/YdaBrosq7M+4aP/caaWVM
         zPtCCzZteox9uAcYx5SyAo9zCHFJet8syWLz32yvo0DDYPQJCw37SXAWp+iGnNe34RNP
         qmnsSPXOhWMplqDK9pYGfmAnKlKIU41oiZxdINyBot/bmafcXmr6D6wRRdNx2anxWo6m
         cs/w==
X-Gm-Message-State: AOAM531ZyQzb0GtP1DHXghhfQ3LhtOMUbrwfyzIrSIjmbz6hJIk/emcU
        6uMYG2KUqa52QaUZD/UbXAuIhYvhLwFS1V2VexNP/QXUDnwSPvC9rRkHDGu+utG9vXH79wvmaMd
        KsKHR0RHbjA7c
X-Received: by 2002:a05:622a:c1:b0:304:b748:be14 with SMTP id p1-20020a05622a00c100b00304b748be14mr21644599qtw.182.1654590476163;
        Tue, 07 Jun 2022 01:27:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxYah24x0VgOYzu07uB9wF/h9PM2w8gnqiibtJ3BRf/4OuyXKuw3Fh41+pKXVewotjs0unuCQ==
X-Received: by 2002:a05:622a:c1:b0:304:b748:be14 with SMTP id p1-20020a05622a00c100b00304b748be14mr21644590qtw.182.1654590475858;
        Tue, 07 Jun 2022 01:27:55 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id bk3-20020a05620a1a0300b006a6ba92d852sm4923540qkb.83.2022.06.07.01.27.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 01:27:55 -0700 (PDT)
Message-ID: <05805d134048e7e993850eb9cf0be56a0c2ae4c6.camel@redhat.com>
Subject: Re: [PATCH] KVM: x86: SVM: fix nested PAUSE filtering when L0
 intercepts PAUSE
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Date:   Tue, 07 Jun 2022 11:27:52 +0300
In-Reply-To: <20220531175837.295988-1-pbonzini@redhat.com>
References: <20220531175837.295988-1-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-2.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-05-31 at 13:58 -0400, Paolo Bonzini wrote:
> Commit 74fd41ed16fd ("KVM: x86: nSVM: support PAUSE filtering when L0
> doesn't intercept PAUSE") introduced passthrough support for nested
> pause
> filtering, (when the host doesn't intercept PAUSE) (either disabled
> with
> kvm module param, or disabled with '-overcommit cpu-pm=on')
> 
> Before this commit, L1 KVM didn't intercept PAUSE at all; afterwards,
> the feature was exposed as supported by KVM cpuid unconditionally,
> thus
> if L1 could try to use it even when the L0 KVM can't really support
> it.
> 
> In this case the fallback caused KVM to intercept each PAUSE
> instruction;
> in some cases, such intercept can slow down the nested guest so much
> that it can fail to boot.  Instead, before the problematic commit KVM
> was already setting both thresholds to 0 in vmcb02, but after the
> first
> userspace VM exit shrink_ple_window was called and would reset the
> pause_filter_count to the default value.
> 
> To fix this, change the fallback strategy - ignore the guest
> threshold
> values, but use/update the host threshold values unless the guest
> specifically requests disabling PAUSE filtering (either simple or
> advanced).
> 
> Also fix a minor bug: on nested VM exit, when PAUSE filter counter
> were copied back to vmcb01, a dirty bit was not set.
> 
> Thanks a lot to Suravee Suthikulpanit for debugging this!
> 
> Fixes: 74fd41ed16fd ("KVM: x86: nSVM: support PAUSE filtering when L0
> doesn't intercept PAUSE")
> Reported-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> Tested-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> Co-developed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Message-Id: <20220518072709.730031-1-mlevitsk@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/svm/nested.c | 39 +++++++++++++++++++++----------------
> --
>  arch/x86/kvm/svm/svm.c    |  4 ++--
>  2 files changed, 23 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 6d0233a2469e..88da8edbe1e1 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -642,6 +642,8 @@ static void nested_vmcb02_prepare_control(struct
> vcpu_svm *svm,
>         struct kvm_vcpu *vcpu = &svm->vcpu;
>         struct vmcb *vmcb01 = svm->vmcb01.ptr;
>         struct vmcb *vmcb02 = svm->nested.vmcb02.ptr;
> +       u32 pause_count12;
> +       u32 pause_thresh12;
>  
>         /*
>          * Filled at exit: exit_code, exit_code_hi, exit_info_1,
> exit_info_2,
> @@ -721,27 +723,25 @@ static void
> nested_vmcb02_prepare_control(struct vcpu_svm *svm,
>         if (!nested_vmcb_needs_vls_intercept(svm))
>                 vmcb02->control.virt_ext |=
> VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
>  
> +       pause_count12 = svm->pause_filter_enabled ? svm-
> >nested.ctl.pause_filter_count : 0;
> +       pause_thresh12 = svm->pause_threshold_enabled ? svm-
> >nested.ctl.pause_filter_thresh : 0;
>         if (kvm_pause_in_guest(svm->vcpu.kvm)) {
> -               /* use guest values since host doesn't use them */
> -               vmcb02->control.pause_filter_count =
> -                               svm->pause_filter_enabled ?
> -                               svm->nested.ctl.pause_filter_count :
> 0;
> +               /* use guest values since host doesn't intercept
> PAUSE */
> +               vmcb02->control.pause_filter_count = pause_count12;
> +               vmcb02->control.pause_filter_thresh = pause_thresh12;
>  
> -               vmcb02->control.pause_filter_thresh =
> -                               svm->pause_threshold_enabled ?
> -                               svm->nested.ctl.pause_filter_thresh :
> 0;
> -
> -       } else if (!vmcb12_is_intercept(&svm->nested.ctl,
> INTERCEPT_PAUSE)) {
> -               /* use host values when guest doesn't use them */
> +       } else {
> +               /* start from host values otherwise */
>                 vmcb02->control.pause_filter_count = vmcb01-
> >control.pause_filter_count;
>                 vmcb02->control.pause_filter_thresh = vmcb01-
> >control.pause_filter_thresh;
> -       } else {
> -               /*
> -                * Intercept every PAUSE otherwise and
> -                * ignore both host and guest values
> -                */
> -               vmcb02->control.pause_filter_count = 0;
> -               vmcb02->control.pause_filter_thresh = 0;
> +
> +               /* ... but ensure filtering is disabled if so
> requested.  */
> +               if (vmcb12_is_intercept(&svm->nested.ctl,
> INTERCEPT_PAUSE)) {
> +                       if (!pause_count12)
> +                               vmcb02->control.pause_filter_count =
> 0;
> +                       if (!pause_thresh12)
> +                               vmcb02->control.pause_filter_thresh =
> 0;
> +               }
>         }
>  
>         nested_svm_transition_tlb_flush(vcpu);
> @@ -1003,8 +1003,11 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
>         vmcb12->control.event_inj         = svm-
> >nested.ctl.event_inj;
>         vmcb12->control.event_inj_err     = svm-
> >nested.ctl.event_inj_err;
>  
> -       if (!kvm_pause_in_guest(vcpu->kvm) && vmcb02-
> >control.pause_filter_count)
> +       if (!kvm_pause_in_guest(vcpu->kvm)) {
>                 vmcb01->control.pause_filter_count = vmcb02-
> >control.pause_filter_count;
> +               vmcb_mark_dirty(vmcb01, VMCB_INTERCEPTS);
> +
> +       }
>  
>         nested_svm_copy_common_state(svm->nested.vmcb02.ptr, svm-
> >vmcb01.ptr);
>  
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 1bd42e7dfa36..4aea82f668fb 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -956,7 +956,7 @@ static void grow_ple_window(struct kvm_vcpu
> *vcpu)
>         struct vmcb_control_area *control = &svm->vmcb->control;
>         int old = control->pause_filter_count;
>  
> -       if (kvm_pause_in_guest(vcpu->kvm) || !old)
> +       if (kvm_pause_in_guest(vcpu->kvm))
>                 return;
>  
>         control->pause_filter_count = __grow_ple_window(old,
> @@ -977,7 +977,7 @@ static void shrink_ple_window(struct kvm_vcpu
> *vcpu)
>         struct vmcb_control_area *control = &svm->vmcb->control;
>         int old = control->pause_filter_count;
>  
> -       if (kvm_pause_in_guest(vcpu->kvm) || !old)
> +       if (kvm_pause_in_guest(vcpu->kvm))
>                 return;
>  
>         control->pause_filter_count =

Thank you Paolo!

Best regards,
	Maxim Levitsky


