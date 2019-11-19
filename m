Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54FC91019E5
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2019 08:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727431AbfKSHAY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Nov 2019 02:00:24 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:46651 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbfKSHAY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Nov 2019 02:00:24 -0500
Received: by mail-ot1-f66.google.com with SMTP id n23so16919677otr.13;
        Mon, 18 Nov 2019 23:00:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aHD4Xn5/sth3UNvyKlhGzuryCM9IkAIPjPJGPFbypFk=;
        b=FtDquBCUI4NWxzSBTO8cxkAQxGRaKjbUfY/2IeLsFtnw2h6Dn/qMmmUP9OaWmje0Na
         NVfmcpApjRmy0sGlkJZV32n3iGn1uKa4kucVCyGPPwszFs5O0sHiAuqmV7QJwKecyK0u
         +eFBAsDZpdM8FO4sT4qC30G++jTZQ3QJWsJ44sZZWBBxfzxCMe6OrZzwiYLWtERr5ldD
         bzetfc2Fqt2kUJpMw/5S5NyNOkfnRT/9o57i0swoSSt1AqLLzFdehXuLskzYZHm2yQqt
         0i79kLgbdocAj9aXxPrPpSAYFVM5ET3QYevpry7LoV0CvvlRvuJ8W2FscUAJBiTD27PF
         VKmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aHD4Xn5/sth3UNvyKlhGzuryCM9IkAIPjPJGPFbypFk=;
        b=QNL2vtbbanhO0qsTHyS/ayNGV7RmwgzKKKy5ikanpNDAZmQp5PCYP9Oy+s5PrNGfFB
         QOc3m5O4Z7Z3E213eYIHGa1BX1f9Vu7NBhViKXCNOChGZoVcABI3VrhARG+bRNvg+d4i
         8ghBunCmAw7tUfTg5aqf35J+jnQB0+C2rSmVNKsaLeszjALOAEq1+6Ql5pXZXkRF9t34
         tc02L89WnTgDGzYfFhvxYwBepQhTtq5YAhcKd79i+8xdE5UwiASq1JdDTl+yg77HjGhQ
         Qj2Iz5NxH2XBs8uXmAeB+7S+myp4fJcnlanAu9x00Ie5/3xc4jhFd7eKbGDQnbs+/w8F
         XH+g==
X-Gm-Message-State: APjAAAWXDWMGpiPs64ZlUkBaH9y29tLz5ZiI7xECy9lOsV8MTPUeh2dl
        jra/CDX9cSoUs7sGaHisztxpNxVvzKtLiO/M6GQ=
X-Google-Smtp-Source: APXvYqwYCbILBHUmk9MyTGvu1q4QNhZ8cNqLJGxRpG5F1yFtAZ6MtPf5e1phTdRmMT13KmdjtJ5SYGgKC6TwuRx1Wnk=
X-Received: by 2002:a9d:b83:: with SMTP id 3mr2468919oth.56.1574146821897;
 Mon, 18 Nov 2019 23:00:21 -0800 (PST)
MIME-Version: 1.0
References: <1571829384-5309-1-git-send-email-zhenzhong.duan@oracle.com> <1571829384-5309-2-git-send-email-zhenzhong.duan@oracle.com>
In-Reply-To: <1571829384-5309-2-git-send-email-zhenzhong.duan@oracle.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 19 Nov 2019 15:00:13 +0800
Message-ID: <CANRm+Cyr+Gg06MiE1+6g9eKTcrN=nn9mPf6=b+5xUN5_9T0v4A@mail.gmail.com>
Subject: Re: [PATCH v8 1/5] Revert "KVM: X86: Fix setup the virt_spin_lock_key
 before static key get initialized"
To:     Zhenzhong Duan <zhenzhong.duan@oracle.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Peter Zijlstra <peterz@infradead.org>, will@kernel.org,
        linux-hyperv@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        mikelley@microsoft.com, "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 23 Oct 2019 at 19:20, Zhenzhong Duan <zhenzhong.duan@oracle.com> wrote:
>
> This reverts commit 34226b6b70980a8f81fff3c09a2c889f77edeeff.
>
> Commit 8990cac6e5ea ("x86/jump_label: Initialize static branching
> early") adds jump_label_init() call in setup_arch() to make static
> keys initialized early, so we could use the original simpler code
> again.
>
> The similar change for XEN is in commit 090d54bcbc54 ("Revert
> "x86/paravirt: Set up the virt_spin_lock_key after static keys get
> initialized"")
>
> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Krcmar <rkrcmar@redhat.com>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Wanpeng Li <wanpengli@tencent.com>
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>

Reviewed-by: Wanpeng Li <wanpengli@tencent.com>

> ---
>  arch/x86/kernel/kvm.c | 12 +++---------
>  1 file changed, 3 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index e820568..3bc6a266 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -527,13 +527,6 @@ static void kvm_smp_send_call_func_ipi(const struct cpumask *mask)
>         }
>  }
>
> -static void __init kvm_smp_prepare_cpus(unsigned int max_cpus)
> -{
> -       native_smp_prepare_cpus(max_cpus);
> -       if (kvm_para_has_hint(KVM_HINTS_REALTIME))
> -               static_branch_disable(&virt_spin_lock_key);
> -}
> -
>  static void __init kvm_smp_prepare_boot_cpu(void)
>  {
>         /*
> @@ -633,7 +626,6 @@ static void __init kvm_guest_init(void)
>                 apic_set_eoi_write(kvm_guest_apic_eoi_write);
>
>  #ifdef CONFIG_SMP
> -       smp_ops.smp_prepare_cpus = kvm_smp_prepare_cpus;
>         smp_ops.smp_prepare_boot_cpu = kvm_smp_prepare_boot_cpu;
>         if (kvm_para_has_feature(KVM_FEATURE_PV_SCHED_YIELD) &&
>             !kvm_para_has_hint(KVM_HINTS_REALTIME) &&
> @@ -835,8 +827,10 @@ void __init kvm_spinlock_init(void)
>         if (!kvm_para_has_feature(KVM_FEATURE_PV_UNHALT))
>                 return;
>
> -       if (kvm_para_has_hint(KVM_HINTS_REALTIME))
> +       if (kvm_para_has_hint(KVM_HINTS_REALTIME)) {
> +               static_branch_disable(&virt_spin_lock_key);
>                 return;
> +       }
>
>         /* Don't use the pvqspinlock code if there is only 1 vCPU. */
>         if (num_possible_cpus() == 1)
> --
> 1.8.3.1
>
