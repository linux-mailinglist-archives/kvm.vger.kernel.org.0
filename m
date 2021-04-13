Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB66B35D447
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 02:05:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344241AbhDMAFq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 20:05:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344236AbhDMAFp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 20:05:45 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E1D3C061574
        for <kvm@vger.kernel.org>; Mon, 12 Apr 2021 17:05:25 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id e186so15281498iof.7
        for <kvm@vger.kernel.org>; Mon, 12 Apr 2021 17:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0LHGvHg7f1yY9SQLZf9g/SjH/0KBxQpbACFdVuWiVJk=;
        b=gxvuj0xQRawU0ll9Tqkh3cOg5wHPF8BQC/61rs2L+QxNOC/gexHp3uUWHwnlaS3lAy
         G5yjSQypob7FWz0uBjDdFDACTJtT8TzkZLefWRVuKaqzprqrteQEkXG9Jl8WEROVlFY6
         8GctLZNamfSMeXyTXBVksS/YNiFCpm6QU50i9K2YTWKJHZYEIBZbsBDxZxILv/tdXM3H
         Af88q4IN8SMLNUQA2qUNFr5KP3OaL9elKIGJqxibX2wKghF0fN4eEK3bXfHjE3uMLids
         jceAc1vBxvuBqdcR6zV3o/IpelroKlC1ZWfcDC8WlRSJv2L7y61Jq+hx0SM07HJ1AxyC
         WoYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0LHGvHg7f1yY9SQLZf9g/SjH/0KBxQpbACFdVuWiVJk=;
        b=OT6ZdJGvXtnOJYWSq01nMQf3Ifa860zaoUl2Fkj5+raC+yGx9FK/wulc3EYE39wmxQ
         oT/aVe+nHnVglWV3hE1oBBIccuJRlEKJN4lPbe6Xr2JODEkBNgdc6R2hiWSmoAcMo1Jx
         5uItjeJ3qLcFEVEodzqnBXznoVzwPoyf/1TEAkgNd6uQr+YORSFgr9DHxzj6xDVbix0i
         eJmYU86pYaL2l5AEX9dz0jEsDtuRbyhNxlsi9AW9A/l6PomxeFZ6YzKQKKnP0hJrZ12j
         4Dn6+qpjJVuJ+ZvKhAEAe/myemT9dPRYiU0kNi7wG9E0Lz0AOVBAq963MiXxc7a+c9xs
         tLpQ==
X-Gm-Message-State: AOAM532CD4ChvvXPaEnem1zc6HPCefNo00uBWsQ54dOgwMRxeK3Dsjrv
        UwlM2RFjtWaDeKBHFeNJD9TMSeUi+eTneozWwcYzeg==
X-Google-Smtp-Source: ABdhPJxx3spGUM2ZztKR2RD9VSaY04aSFo0m7Yd5jBkSbQ3Q3AhuL1dXwhjKppb4WCQm0fu4AHHpHfw8okwUPT5De1g=
X-Received: by 2002:a02:9a0a:: with SMTP id b10mr31044347jal.132.1618272324963;
 Mon, 12 Apr 2021 17:05:24 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1618254007.git.ashish.kalra@amd.com> <93d7f2c2888315adc48905722574d89699edde33.1618254007.git.ashish.kalra@amd.com>
In-Reply-To: <93d7f2c2888315adc48905722574d89699edde33.1618254007.git.ashish.kalra@amd.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Mon, 12 Apr 2021 17:04:49 -0700
Message-ID: <CABayD+dsQwgHM5wMQrwDhyKpG1mOfqsm4XAsiaHzBOVN3Z_j8A@mail.gmail.com>
Subject: Re: [PATCH v12 08/13] KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS hypercall
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 12, 2021 at 12:45 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>
> From: Ashish Kalra <ashish.kalra@amd.com>
>
> This hypercall is used by the SEV guest to notify a change in the page
> encryption status to the hypervisor. The hypercall should be invoked
> only when the encryption attribute is changed from encrypted -> decrypted
> and vice versa. By default all guest pages are considered encrypted.
>
> The hypercall exits to userspace to manage the guest shared regions and
> integrate with the userspace VMM's migration code.
>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: x86@kernel.org
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  Documentation/virt/kvm/hypercalls.rst | 15 ++++++++++++++
>  arch/x86/include/asm/kvm_host.h       |  2 ++
>  arch/x86/kvm/svm/sev.c                |  1 +
>  arch/x86/kvm/x86.c                    | 29 +++++++++++++++++++++++++++
>  include/uapi/linux/kvm_para.h         |  1 +
>  5 files changed, 48 insertions(+)
>
> diff --git a/Documentation/virt/kvm/hypercalls.rst b/Documentation/virt/kvm/hypercalls.rst
> index ed4fddd364ea..7aff0cebab7c 100644
> --- a/Documentation/virt/kvm/hypercalls.rst
> +++ b/Documentation/virt/kvm/hypercalls.rst
> @@ -169,3 +169,18 @@ a0: destination APIC ID
>
>  :Usage example: When sending a call-function IPI-many to vCPUs, yield if
>                 any of the IPI target vCPUs was preempted.
> +
> +
> +8. KVM_HC_PAGE_ENC_STATUS
> +-------------------------
> +:Architecture: x86
> +:Status: active
> +:Purpose: Notify the encryption status changes in guest page table (SEV guest)
> +
> +a0: the guest physical address of the start page
> +a1: the number of pages
> +a2: encryption attribute
> +
> +   Where:
> +       * 1: Encryption attribute is set
> +       * 0: Encryption attribute is cleared
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 3768819693e5..42eb0fe3df5d 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1050,6 +1050,8 @@ struct kvm_arch {
>
>         bool bus_lock_detection_enabled;
>
> +       bool page_enc_hc_enable;
> +
>         /* Deflect RDMSR and WRMSR to user space when they trigger a #GP */
>         u32 user_space_msr_mask;
>         struct kvm_x86_msr_filter __rcu *msr_filter;
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index c9795a22e502..5184a0c0131a 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -197,6 +197,7 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>         sev->active = true;
>         sev->asid = asid;
>         INIT_LIST_HEAD(&sev->regions_list);
> +       kvm->arch.page_enc_hc_enable = true;
>
>         return 0;
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index f7d12fca397b..e8986478b653 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8208,6 +8208,13 @@ static void kvm_sched_yield(struct kvm *kvm, unsigned long dest_id)
>                 kvm_vcpu_yield_to(target);
>  }
>
> +static int complete_hypercall_exit(struct kvm_vcpu *vcpu)
> +{
> +       kvm_rax_write(vcpu, vcpu->run->hypercall.ret);
> +       ++vcpu->stat.hypercalls;
> +       return kvm_skip_emulated_instruction(vcpu);
> +}
> +
>  int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>  {
>         unsigned long nr, a0, a1, a2, a3, ret;
> @@ -8273,6 +8280,28 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>                 kvm_sched_yield(vcpu->kvm, a0);
>                 ret = 0;
>                 break;
> +       case KVM_HC_PAGE_ENC_STATUS: {
> +               u64 gpa = a0, npages = a1, enc = a2;
> +
> +               ret = -KVM_ENOSYS;
> +               if (!vcpu->kvm->arch.page_enc_hc_enable)
> +                       break;
> +
> +               if (!PAGE_ALIGNED(gpa) || !npages ||
> +                   gpa_to_gfn(gpa) + npages <= gpa_to_gfn(gpa)) {
> +                       ret = -EINVAL;
> +                       break;
> +               }
> +
> +               vcpu->run->exit_reason        = KVM_EXIT_HYPERCALL;
> +               vcpu->run->hypercall.nr       = KVM_HC_PAGE_ENC_STATUS;
> +               vcpu->run->hypercall.args[0]  = gpa;
> +               vcpu->run->hypercall.args[1]  = npages;
> +               vcpu->run->hypercall.args[2]  = enc;
> +               vcpu->run->hypercall.longmode = op_64_bit;
> +               vcpu->arch.complete_userspace_io = complete_hypercall_exit;
> +               return 0;
> +       }
>         default:
>                 ret = -KVM_ENOSYS;
>                 break;
> diff --git a/include/uapi/linux/kvm_para.h b/include/uapi/linux/kvm_para.h
> index 8b86609849b9..847b83b75dc8 100644
> --- a/include/uapi/linux/kvm_para.h
> +++ b/include/uapi/linux/kvm_para.h
> @@ -29,6 +29,7 @@
>  #define KVM_HC_CLOCK_PAIRING           9
>  #define KVM_HC_SEND_IPI                10
>  #define KVM_HC_SCHED_YIELD             11
> +#define KVM_HC_PAGE_ENC_STATUS         12
>
>  /*
>   * hypercalls use architecture specific
> --
> 2.17.1
>
Reviewed-by: Steve Rutherford <srutherford@google.com>
