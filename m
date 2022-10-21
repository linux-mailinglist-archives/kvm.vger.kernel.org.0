Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E821B6080F3
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 23:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbiJUVwg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 17:52:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiJUVwe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 17:52:34 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FE842A9346
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 14:52:33 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id c3-20020a1c3503000000b003bd21e3dd7aso6057744wma.1
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 14:52:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3fr7B7jFvvkYJk812B7ZHpOE8Kp5VoLWcYb2mrCECtA=;
        b=kVaFZV06eHLXC/zZXFnS6JH57aI50yqrG9iGtTMHItNv6MZcm8YMGTDs8fr+zxjbRS
         crCqtiCH9pwyYatDyBw87tOAaBqdyxnuA8CpPqmmbgdabdaTT2W+x3ZU8xSI/9gf1OkC
         y0FQAZ0JIzpXdT89ThEhQmqnkJOyML9tXrwRtEVMnw7qHwgp6rcwqR1idtOdgN3mUCJk
         +MnT+8PiyPmipaASeGA46Kpg5krDFiAfbZzYalnDPmW4SZXWscl8osTY9JBFaVl0wcRI
         5xI7PpbxeTRscFR9FfPOnV/M+bH93Va+lu+2Li9exT2k2m3ZrbWlV3Q3pHf8xIDm67HO
         uSTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3fr7B7jFvvkYJk812B7ZHpOE8Kp5VoLWcYb2mrCECtA=;
        b=TDKPCftc8EHxr8qBgsrnrJZwcm+nelu+qjdK/4dI4wSZT5210zQ9UtS59EBk8IZfz7
         wbl48WITUyuNpm1wn1Hq3oia+hFhqTLYyB8VG90VxbSTvTSsCVC4akCDvSjmd2xTccAm
         iynEa7bo/rVRoCRB4fk5FsO760L6+sqRvzMb1WIgpzqtiSAZaZHO5xp7YMWxizBg5PsA
         hsGhonIyWtVZkGh7GorQpFrIhyExpT3b1lVBbX8soTHPNRnt2CYmBX84c8HEQTJiUdP8
         cNY9fQY+hJYvNQaXD7eA2tCnBqmojvsadOi2M8MVSw7TNphLquwlbWLya23bJx3QRJLV
         PDzg==
X-Gm-Message-State: ACrzQf3A/FAosTTF+XQiT8OpBRxuceoVXm1/fY4nPcbYUnWHRKqgUDGO
        hiGT1cvJ+tcn4cHnzz5FDyL0hyfDkOC/r3woUx7icQ==
X-Google-Smtp-Source: AMsMyM7SnpsAuSsgopXHInPYeRxWDpGqyf+t9d27xa8PEOKgEp+HyVljAaBXIQPHLRDvror0bqkC7WllVx6n7G1JYMo=
X-Received: by 2002:a7b:c4cb:0:b0:3c6:f83e:cf79 with SMTP id
 g11-20020a7bc4cb000000b003c6f83ecf79mr14678322wmk.112.1666389151506; Fri, 21
 Oct 2022 14:52:31 -0700 (PDT)
MIME-Version: 1.0
References: <20221021185916.1494314-1-vipinsh@google.com> <Y1L9Z8RgIs8yrU6o@google.com>
In-Reply-To: <Y1L9Z8RgIs8yrU6o@google.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Fri, 21 Oct 2022 14:51:55 -0700
Message-ID: <CAHVum0eoA5j7EPmmuuUb2y7XOU1jRpFwJO90tc+QBy0JNUtBsQ@mail.gmail.com>
Subject: Re: [RFC PATCH] Add Hyperv extended hypercall support in KVM
To:     Sean Christopherson <seanjc@google.com>
Cc:     vkuznets@redhat.com, pbonzini@redhat.com, dmatlack@google.com,
        kvm@vger.kernel.org, shujunxue@google.com, terrytaehyun@google.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 21, 2022 at 1:13 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Oct 21, 2022, Vipin Sharma wrote:
> > Hyperv hypercalls above 0x8000 are called as extended hypercalls as per
> > Hyperv TLFS. Hypercall 0x8001 is used to enquire about available
> > hypercalls by guest VMs.
> >
> > Add support for HvExtCallQueryCapabilities (0x8001) and
> > HvExtCallGetBootZeroedMemory (0x8002) in KVM.
> >
> > A guest VM finds availability of HvExtCallQueryCapabilities (0x8001) by
> > using CPUID.0x40000003.EBX BIT(20). If the bit is set then the guest VM
> > make hypercall HvExtCallQueryCapabilities (0x8001) to know what all
> > extended hypercalls are supported by hypervisor.
> >
> > A userspace VMM can query capability KVM_CAP_HYPERV_EXT_CALL_QUERY to
> > know which extended hypercalls are supported in KVM. After which the
> > userspace will enable capabilities for the guest VM.
> >
> > HvExtCallQueryCapabilities (0x8001) is handled by KVM in kernel,
>
> Does this really need to be handle by KVM?  I assume this is a rare operation,
> e.g. done once during guest boot, so performance shouldn't be a concern.  To
> avoid breaking existing userspace, KVM can forward HV_EXT_CALL_GET_BOOT_ZEROED_MEMORY
> to userspace if and only if HV_ENABLE_EXTENDED_HYPERCALLS is enabled in CPUID,
> but otherwise KVM can let userspace deal with the "is this enabled" check.

There are 4 more extended hypercalls mentioned in TLFS but there is no
detail about them in the document. From the linux source code one of
the hypercall HvExtCallMemoryHeatHint (0x8003) is a repetitive call.
In the file drivers/hv/hv_balloon.c
          status = hv_do_rep_hypercall(HV_EXT_CALL_MEMORY_HEAT_HINT,
nents, 0,  hint, NULL);

This makes me a little bit wary that these hypercalls or any future
hypercalls can have high calling frequency by Windows guest. Also, it
is not clear which calls can or cannot be satisfied by userspace
alone.

So, I am not sure if the default exit to userspace for all of the
extended hypercalls will be future proof, therefore, I went with the
approach of only selectively exiting to userspace based on hypercall.

>
> Aha!  And if KVM "allows" all theoretically possible extended hypercalls, then
> KVM will never need a capability to announce "support" for a new hypercall, i.e.
> define KVM's ABI to be that KVM punts all possible extended hypercalls to userspace
> if CPUID.0x40000003.EBX BIT(20) is enabled.
>
> > whereas, HvExtCallGetBootZeroedMemory (0x8002) is passed to userspace
> > for further action.
> >
> > Change-Id: Ib3709fadbf11f91be2842c8486bcbe755e09cbea
>
> Drop gerrit's Change-Id when posting publicly.
>
> If KVM punts the support checks to userspace, then the KVM side of things is very
> minimal and future proof (unless Microsoft hoses us).  E.g. with code deduplication
> that should be moved to a prep patch:
>
> ---
>  arch/x86/kvm/hyperv.c | 43 +++++++++++++++++++++++++++----------------
>  1 file changed, 27 insertions(+), 16 deletions(-)
>
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 0adf4a437e85..f9253249de00 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -2138,6 +2138,12 @@ static void kvm_hv_hypercall_read_xmm(struct kvm_hv_hcall *hc)
>         kvm_fpu_put();
>  }
>
> +/*
> + * The TLFS carves out 64 possible extended hypercalls, numbered sequentially
> + * after the base capabilities extended hypercall.
> + */
> +#define HV_EXT_CALL_MAX (HV_EXT_CALL_QUERY_CAPABILITIES + 64)
> +
>  static bool hv_check_hypercall_access(struct kvm_vcpu_hv *hv_vcpu, u16 code)
>  {
>         if (!hv_vcpu->enforce_cpuid)
> @@ -2178,6 +2184,10 @@ static bool hv_check_hypercall_access(struct kvm_vcpu_hv *hv_vcpu, u16 code)
>         case HVCALL_SEND_IPI:
>                 return hv_vcpu->cpuid_cache.enlightenments_eax &
>                         HV_X64_CLUSTER_IPI_RECOMMENDED;
> +       case HV_EXT_CALL_QUERY_CAPABILITIES ... HV_EXT_CALL_MAX:
> +               return hv_vcpu->cpuid_cache.features_ebx &
> +                      HV_ENABLE_EXTENDED_HYPERCALLS;
> +               break;
>         default:
>                 break;
>         }
> @@ -2270,14 +2280,7 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
>                         ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
>                         break;
>                 }
> -               vcpu->run->exit_reason = KVM_EXIT_HYPERV;
> -               vcpu->run->hyperv.type = KVM_EXIT_HYPERV_HCALL;
> -               vcpu->run->hyperv.u.hcall.input = hc.param;
> -               vcpu->run->hyperv.u.hcall.params[0] = hc.ingpa;
> -               vcpu->run->hyperv.u.hcall.params[1] = hc.outgpa;
> -               vcpu->arch.complete_userspace_io =
> -                               kvm_hv_hypercall_complete_userspace;
> -               return 0;
> +               goto hypercall_userspace_exit;
>         case HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST:
>                 if (unlikely(hc.var_cnt)) {
>                         ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
> @@ -2336,15 +2339,14 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
>                         ret = HV_STATUS_OPERATION_DENIED;
>                         break;
>                 }
> -               vcpu->run->exit_reason = KVM_EXIT_HYPERV;
> -               vcpu->run->hyperv.type = KVM_EXIT_HYPERV_HCALL;
> -               vcpu->run->hyperv.u.hcall.input = hc.param;
> -               vcpu->run->hyperv.u.hcall.params[0] = hc.ingpa;
> -               vcpu->run->hyperv.u.hcall.params[1] = hc.outgpa;
> -               vcpu->arch.complete_userspace_io =
> -                               kvm_hv_hypercall_complete_userspace;
> -               return 0;
> +               goto hypercall_userspace_exit;
>         }
> +       case HV_EXT_CALL_QUERY_CAPABILITIES ... HV_EXT_CALL_MAX:
> +               if (unlikely(hc.fast)) {
> +                       ret = HV_STATUS_INVALID_PARAMETER;
> +                       break;
> +               }
> +               goto hypercall_userspace_exit;
>         default:
>                 ret = HV_STATUS_INVALID_HYPERCALL_CODE;
>                 break;
> @@ -2352,6 +2354,14 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
>
>  hypercall_complete:
>         return kvm_hv_hypercall_complete(vcpu, ret);
> +hypercall_userspace_exit:
> +       vcpu->run->exit_reason = KVM_EXIT_HYPERV;
> +       vcpu->run->hyperv.type = KVM_EXIT_HYPERV_HCALL;
> +       vcpu->run->hyperv.u.hcall.input = hc.param;
> +       vcpu->run->hyperv.u.hcall.params[0] = hc.ingpa;
> +       vcpu->run->hyperv.u.hcall.params[1] = hc.outgpa;
> +       vcpu->arch.complete_userspace_io = kvm_hv_hypercall_complete_userspace;
> +       return 0;
>  }
>
>  void kvm_hv_init_vm(struct kvm *kvm)
> @@ -2494,6 +2504,7 @@ int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
>
>                         ent->ebx |= HV_POST_MESSAGES;
>                         ent->ebx |= HV_SIGNAL_EVENTS;
> +                       ent->ebx |= HV_ENABLE_EXTENDED_HYPERCALLS;
>
>                         ent->edx |= HV_X64_HYPERCALL_XMM_INPUT_AVAILABLE;
>                         ent->edx |= HV_FEATURE_FREQUENCY_MSRS_AVAILABLE;
>
> base-commit: e18d6152ff0f41b7f01f9817372022df04e0d354
> --
>
