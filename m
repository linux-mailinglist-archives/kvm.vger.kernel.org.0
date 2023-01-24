Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 126CA67A6C1
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 00:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234282AbjAXXQz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 18:16:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbjAXXQy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 18:16:54 -0500
Received: from mail-oa1-x2c.google.com (mail-oa1-x2c.google.com [IPv6:2001:4860:4864:20::2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D732430DE
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 15:16:52 -0800 (PST)
Received: by mail-oa1-x2c.google.com with SMTP id 586e51a60fabf-15eec491b40so19457813fac.12
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 15:16:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=O6FG0rZSsowFESqKod3eAgl51fl1/NMrQnVO/Zh39hI=;
        b=eR1U7BkGEuJ+TCHIVXpFwddImI5S3U2vXU1zewsNhfCxSMVc/26xsyZBaRgZQOW+ZL
         HnkKvbbBG+tuWBdrDCFZkTrSk2X9Y2NjywIGHOuLnidslxFJXZ5uSHs4KmPXSOuFWMsP
         ZQf//u33Y2C6UYKLift0E23EGwHm+VeUA9/cBPNor6648uC15rHXsqWmJmBnFSGW09GT
         8Y33o1T2FEGPi71gVa9fNcG7XYFOYKm9lsLUhUXnyKt7nGYWv9+s/a3SEkLUZf9AvG3+
         3hTAtup8gHP74IYXFyVCNch9uobWHS1mCZdlzaU/v93rRfn4MJuih1A9+BFpqpX3ObgE
         /jvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O6FG0rZSsowFESqKod3eAgl51fl1/NMrQnVO/Zh39hI=;
        b=Jkckbyay3lb1dc9+Ii6TkU9Z6dVt7wp2jRRl9XdlrVraBryKb0PDyu4QOljCLHyG5f
         nAaR3Mz2cYwZoQ8bNhsKpUgmKIraGzzbv/uALWutODpF2dTgcqXUDC1+2UdEYzz/bF8A
         Ik01+I72cL0SnIWLfsy9LVkztLoMSLQRROZt4UJoewjRkW6LSNZ7Sbbye7VMw2pepnml
         mmhFmsAguWtqA8ix8N+xMDz2GaoHAeFcBuGwXLQ13tZ5Jr/m3YScOZzSy+E5BL8Lv6cw
         EK4qtzXn822I2a+bfyt7Iy5NzSTLtRbvbyimP8W6QQ79MdhaCo1Hf6uCUrzrPGsxIuX/
         lc9g==
X-Gm-Message-State: AO0yUKXWWmorfJOMUoBwpKvvQBB1OCcJPspwXZnKleuPhZioV5CroCWJ
        SsMUKP9EXXSInYaVtSvPXOi+x66Qq4kGxWgyfArWFA==
X-Google-Smtp-Source: AK7set8qpmlTZgkaUMcLNSDdmgMOL4CvGDG0uVtE6IwrUSmYA+gizCDKzIty6cgsFhGPXfg7G/uh/jeVCJmdTCdbZ6M=
X-Received: by 2002:a05:6871:6ca5:b0:160:3235:9c33 with SMTP id
 zj37-20020a0568716ca500b0016032359c33mr389603oab.103.1674602211611; Tue, 24
 Jan 2023 15:16:51 -0800 (PST)
MIME-Version: 1.0
References: <20221027092036.2698180-1-pbonzini@redhat.com>
In-Reply-To: <20221027092036.2698180-1-pbonzini@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 24 Jan 2023 15:16:40 -0800
Message-ID: <CALMp9eQihPhjpoodw6ojgVh_KtvPqQ9qJ3wKWZQyVtArpGkfHA@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: x86: Do not return host topology information from KVM_GET_SUPPORTED_CPUID
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, stable@vger.kernel.org
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

On Thu, Oct 27, 2022 at 2:21 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> Passing the host topology to the guest is almost certainly wrong
> and will confuse the scheduler.  In addition, several fields of
> these CPUID leaves vary on each processor; it is simply impossible to
> return the right values from KVM_GET_SUPPORTED_CPUID in such a way that
> they can be passed to KVM_SET_CPUID2.
>
> The values that will most likely prevent confusion are all zeroes.
> Userspace will have to override it anyway if it wishes to present a
> specific topology to the guest.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  Documentation/virt/kvm/api.rst | 14 ++++++++++++++
>  arch/x86/kvm/cpuid.c           | 32 ++++++++++++++++----------------
>  2 files changed, 30 insertions(+), 16 deletions(-)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index eee9f857a986..20f4f6b302ff 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -8249,6 +8249,20 @@ CPU[EAX=1]:ECX[24] (TSC_DEADLINE) is not reported by ``KVM_GET_SUPPORTED_CPUID``
>  It can be enabled if ``KVM_CAP_TSC_DEADLINE_TIMER`` is present and the kernel
>  has enabled in-kernel emulation of the local APIC.
>
> +CPU topology
> +~~~~~~~~~~~~
> +
> +Several CPUID values include topology information for the host CPU:
> +0x0b and 0x1f for Intel systems, 0x8000001e for AMD systems.  Different
> +versions of KVM return different values for this information and userspace
> +should not rely on it.  Currently they return all zeroes.
> +
> +If userspace wishes to set up a guest topology, it should be careful that
> +the values of these three leaves differ for each CPU.  In particular,
> +the APIC ID is found in EDX for all subleaves of 0x0b and 0x1f, and in EAX
> +for 0x8000001e; the latter also encodes the core id and node id in bits
> +7:0 of EBX and ECX respectively.
> +
>  Obsolete ioctls and capabilities
>  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 0810e93cbedc..164bfb7e7a16 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -759,16 +759,22 @@ struct kvm_cpuid_array {
>         int nent;
>  };
>
> +static struct kvm_cpuid_entry2 *get_next_cpuid(struct kvm_cpuid_array *array)
> +{
> +       if (array->nent >= array->maxnent)
> +               return NULL;
> +
> +       return &array->entries[array->nent++];
> +}
> +
>  static struct kvm_cpuid_entry2 *do_host_cpuid(struct kvm_cpuid_array *array,
>                                               u32 function, u32 index)
>  {
> -       struct kvm_cpuid_entry2 *entry;
> +       struct kvm_cpuid_entry2 *entry = get_next_cpuid(array);
>
> -       if (array->nent >= array->maxnent)
> +       if (!entry)
>                 return NULL;
>
> -       entry = &array->entries[array->nent++];
> -
>         memset(entry, 0, sizeof(*entry));
>         entry->function = function;
>         entry->index = index;
> @@ -945,22 +951,13 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>                 entry->edx = edx.full;
>                 break;
>         }
> -       /*
> -        * Per Intel's SDM, the 0x1f is a superset of 0xb,
> -        * thus they can be handled by common code.
> -        */
>         case 0x1f:
>         case 0xb:
>                 /*
> -                * Populate entries until the level type (ECX[15:8]) of the
> -                * previous entry is zero.  Note, CPUID EAX.{0x1f,0xb}.0 is
> -                * the starting entry, filled by the primary do_host_cpuid().
> +                * No topology; a valid topology is indicated by the presence
> +                * of subleaf 1.
>                  */
> -               for (i = 1; entry->ecx & 0xff00; ++i) {
> -                       entry = do_host_cpuid(array, function, i);
> -                       if (!entry)
> -                               goto out;
> -               }
> +               entry->eax = entry->ebx = entry->ecx = 0;
>                 break;
>         case 0xd: {
>                 u64 permitted_xcr0 = kvm_caps.supported_xcr0 & xstate_get_guest_group_perm();
> @@ -1193,6 +1190,9 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>                 entry->ebx = entry->ecx = entry->edx = 0;
>                 break;
>         case 0x8000001e:
> +               /* Do not return host topology information.  */
> +               entry->eax = entry->ebx = entry->ecx = 0;
> +               entry->edx = 0; /* reserved */
>                 break;
>         case 0x8000001F:
>                 if (!kvm_cpu_cap_has(X86_FEATURE_SEV)) {
> --
> 2.31.1
>

This is a userspace ABI change that breaks existing hypervisors.
Please don't do this. Userspace ABIs are supposed to be inviolate.
