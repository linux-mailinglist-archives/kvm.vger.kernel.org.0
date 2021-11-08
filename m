Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6AED449A2D
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 17:45:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241412AbhKHQsK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 11:48:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241423AbhKHQsD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 11:48:03 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37BB6C061224
        for <kvm@vger.kernel.org>; Mon,  8 Nov 2021 08:45:16 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id v7so45388806ybq.0
        for <kvm@vger.kernel.org>; Mon, 08 Nov 2021 08:45:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mPAAcEutuvojsmznEGPIcMSov1HqQP3aEMotZQmfTV0=;
        b=BBNJF0NDkST4Ck9ODkmhuDh67UByY0U73RcW0mYSobJ4AXtWy8j4xF3Ahwc9++ieYE
         N8dlgSvGPziE5XtQCZ8LTizbJ1JQxsKyZj+fDbBPCAhNmoT4r7x8go3QgEkakHX3JUXQ
         qV4t5gF8p+XM3GvQ8WlYkowwurRLQnbGucInw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mPAAcEutuvojsmznEGPIcMSov1HqQP3aEMotZQmfTV0=;
        b=k8avMrelwMOFCB9bIG8+8g4Hbd79JZxKW6NZWW8/amRaQOhpUXW83c4QNge6dFb/Vt
         SohwjEcLoO60uit/6ufkur3qn9Out4uS2IEIRXF/NvRdm/Vm6mw7xNL2IvTDBlP8w1h7
         mVzWpWyT8XYAGy/1jTM3xwhayXv1SMl0H6ANA2GfSWB+E/yE+WQtN1wBgq28f0qRkoGD
         rqfC4OwtlHCpm3QoxZXCn3j0dI7ADXrM50SUZX65dglOKoG6SDN2tTsXoDErzB6Iw+cd
         S/mJRJMumScyqBXa4Ss04jhHbDiltoKrUBmLMn5t5+Wkvdo6//bs8/FwbLVZTDD3l+KN
         +u2Q==
X-Gm-Message-State: AOAM530Nph4YXw8ZKqUIOBYG+66nyKiFoL11LYBEF4+XFE2eAQPWYqnP
        D0Wg7DyyQCZ4THWfLc0MSQzxvXDF9nbQYFYvsO72
X-Google-Smtp-Source: ABdhPJzNEpig30Y2lsDlqSmwcfTUZUOYSWD3xieHwsmrXwU55MJJ44mtojuPL7fqCoSUL7NfK6Ds7RxsZI3vChSEYHo=
X-Received: by 2002:a25:5f4c:: with SMTP id h12mr642296ybm.169.1636389915022;
 Mon, 08 Nov 2021 08:45:15 -0800 (PST)
MIME-Version: 1.0
References: <20211105235852.3011900-1-atish.patra@wdc.com> <20211105235852.3011900-2-atish.patra@wdc.com>
 <DF82A93F-50CD-4A68-A8A6-0056E6248172@gmx.de>
In-Reply-To: <DF82A93F-50CD-4A68-A8A6-0056E6248172@gmx.de>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Mon, 8 Nov 2021 08:45:04 -0800
Message-ID: <CAOnJCUJtDZuYAdQmXWsDUOBKJ8=hWjzTMXrFVLSAzMeRhS-9cA@mail.gmail.com>
Subject: Re: [PATCH v4 1/5] RISC-V: KVM: Mark the existing SBI implementation
 as v01
To:     Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc:     Atish Patra <atish.patra@wdc.com>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Anup Patel <anup.patel@wdc.com>, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, linux-riscv <linux-riscv@lists.infradead.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Vincent Chen <vincent.chen@sifive.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 5, 2021 at 9:28 PM Heinrich Schuchardt <xypron.glpk@gmx.de> wrote:
>
> Am 6. November 2021 00:58:48 MEZ schrieb Atish Patra <atish.patra@wdc.com>:
> >The existing SBI specification impelementation follows v0.1
> >specification. The latest specification known as v0.2 allows more
> >scalability and performance improvements.
>
> Isn't 0.3 the current SBI specification version?
>

Yes. It was a typo. I will fix it in the next version.
Thanks for catching it.

> Especially the system reset extension would be valuable for KVM.
>

Yup. I do have a patch ready for reset extension. But I did not
include that in this series
because the reset patch for the host kernel is not merged yet. I will
send it separately.

> (This is not meant to stop merging this patch series.)
>
> Best regards
>
> Heinrich
>
>
> >
> >Rename the existing implementation as v01 and provide a way to allow
> >future extensions.
> >
> >Signed-off-by: Atish Patra <atish.patra@wdc.com>
> >---
> > arch/riscv/include/asm/kvm_vcpu_sbi.h |  29 +++++
> > arch/riscv/kvm/vcpu_sbi.c             | 147 +++++++++++++++++++++-----
> > 2 files changed, 147 insertions(+), 29 deletions(-)
> > create mode 100644 arch/riscv/include/asm/kvm_vcpu_sbi.h
> >
> >diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> >new file mode 100644
> >index 000000000000..1a4cb0db2d0b
> >--- /dev/null
> >+++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> >@@ -0,0 +1,29 @@
> >+/* SPDX-License-Identifier: GPL-2.0-only */
> >+/**
> >+ * Copyright (c) 2021 Western Digital Corporation or its affiliates.
> >+ *
> >+ * Authors:
> >+ *     Atish Patra <atish.patra@wdc.com>
> >+ */
> >+
> >+#ifndef __RISCV_KVM_VCPU_SBI_H__
> >+#define __RISCV_KVM_VCPU_SBI_H__
> >+
> >+#define KVM_SBI_VERSION_MAJOR 0
> >+#define KVM_SBI_VERSION_MINOR 2
> >+
> >+struct kvm_vcpu_sbi_extension {
> >+      unsigned long extid_start;
> >+      unsigned long extid_end;
> >+      /**
> >+       * SBI extension handler. It can be defined for a given extension or group of
> >+       * extension. But it should always return linux error codes rather than SBI
> >+       * specific error codes.
> >+       */
> >+      int (*handler)(struct kvm_vcpu *vcpu, struct kvm_run *run,
> >+                     unsigned long *out_val, struct kvm_cpu_trap *utrap,
> >+                     bool *exit);
> >+};
> >+
> >+const struct kvm_vcpu_sbi_extension *kvm_vcpu_sbi_find_ext(unsigned long extid);
> >+#endif /* __RISCV_KVM_VCPU_SBI_H__ */
> >diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
> >index eb3c045edf11..05cab5f27eee 100644
> >--- a/arch/riscv/kvm/vcpu_sbi.c
> >+++ b/arch/riscv/kvm/vcpu_sbi.c
> >@@ -12,9 +12,25 @@
> > #include <asm/csr.h>
> > #include <asm/sbi.h>
> > #include <asm/kvm_vcpu_timer.h>
> >+#include <asm/kvm_vcpu_sbi.h>
> >
> >-#define SBI_VERSION_MAJOR                     0
> >-#define SBI_VERSION_MINOR                     1
> >+static int kvm_linux_err_map_sbi(int err)
> >+{
> >+      switch (err) {
> >+      case 0:
> >+              return SBI_SUCCESS;
> >+      case -EPERM:
> >+              return SBI_ERR_DENIED;
> >+      case -EINVAL:
> >+              return SBI_ERR_INVALID_PARAM;
> >+      case -EFAULT:
> >+              return SBI_ERR_INVALID_ADDRESS;
> >+      case -EOPNOTSUPP:
> >+              return SBI_ERR_NOT_SUPPORTED;
> >+      default:
> >+              return SBI_ERR_FAILURE;
> >+      };
> >+}
> >
> > static void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu,
> >                                      struct kvm_run *run)
> >@@ -72,16 +88,17 @@ static void kvm_sbi_system_shutdown(struct kvm_vcpu *vcpu,
> >       run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
> > }
> >
> >-int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >+static int kvm_sbi_ext_v01_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
> >+                                    unsigned long *out_val,
> >+                                    struct kvm_cpu_trap *utrap,
> >+                                    bool *exit)
> > {
> >       ulong hmask;
> >-      int i, ret = 1;
> >+      int i, ret = 0;
> >       u64 next_cycle;
> >       struct kvm_vcpu *rvcpu;
> >-      bool next_sepc = true;
> >       struct cpumask cm, hm;
> >       struct kvm *kvm = vcpu->kvm;
> >-      struct kvm_cpu_trap utrap = { 0 };
> >       struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
> >
> >       if (!cp)
> >@@ -95,8 +112,7 @@ int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >                * handled in kernel so we forward these to user-space
> >                */
> >               kvm_riscv_vcpu_sbi_forward(vcpu, run);
> >-              next_sepc = false;
> >-              ret = 0;
> >+              *exit = true;
> >               break;
> >       case SBI_EXT_0_1_SET_TIMER:
> > #if __riscv_xlen == 32
> >@@ -104,47 +120,42 @@ int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
> > #else
> >               next_cycle = (u64)cp->a0;
> > #endif
> >-              kvm_riscv_vcpu_timer_next_event(vcpu, next_cycle);
> >+              ret = kvm_riscv_vcpu_timer_next_event(vcpu, next_cycle);
> >               break;
> >       case SBI_EXT_0_1_CLEAR_IPI:
> >-              kvm_riscv_vcpu_unset_interrupt(vcpu, IRQ_VS_SOFT);
> >+              ret = kvm_riscv_vcpu_unset_interrupt(vcpu, IRQ_VS_SOFT);
> >               break;
> >       case SBI_EXT_0_1_SEND_IPI:
> >               if (cp->a0)
> >                       hmask = kvm_riscv_vcpu_unpriv_read(vcpu, false, cp->a0,
> >-                                                         &utrap);
> >+                                                         utrap);
> >               else
> >                       hmask = (1UL << atomic_read(&kvm->online_vcpus)) - 1;
> >-              if (utrap.scause) {
> >-                      utrap.sepc = cp->sepc;
> >-                      kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
> >-                      next_sepc = false;
> >+              if (utrap->scause)
> >                       break;
> >-              }
> >+
> >               for_each_set_bit(i, &hmask, BITS_PER_LONG) {
> >                       rvcpu = kvm_get_vcpu_by_id(vcpu->kvm, i);
> >-                      kvm_riscv_vcpu_set_interrupt(rvcpu, IRQ_VS_SOFT);
> >+                      ret = kvm_riscv_vcpu_set_interrupt(rvcpu, IRQ_VS_SOFT);
> >+                      if (ret < 0)
> >+                              break;
> >               }
> >               break;
> >       case SBI_EXT_0_1_SHUTDOWN:
> >               kvm_sbi_system_shutdown(vcpu, run, KVM_SYSTEM_EVENT_SHUTDOWN);
> >-              next_sepc = false;
> >-              ret = 0;
> >+              *exit = true;
> >               break;
> >       case SBI_EXT_0_1_REMOTE_FENCE_I:
> >       case SBI_EXT_0_1_REMOTE_SFENCE_VMA:
> >       case SBI_EXT_0_1_REMOTE_SFENCE_VMA_ASID:
> >               if (cp->a0)
> >                       hmask = kvm_riscv_vcpu_unpriv_read(vcpu, false, cp->a0,
> >-                                                         &utrap);
> >+                                                         utrap);
> >               else
> >                       hmask = (1UL << atomic_read(&kvm->online_vcpus)) - 1;
> >-              if (utrap.scause) {
> >-                      utrap.sepc = cp->sepc;
> >-                      kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
> >-                      next_sepc = false;
> >+              if (utrap->scause)
> >                       break;
> >-              }
> >+
> >               cpumask_clear(&cm);
> >               for_each_set_bit(i, &hmask, BITS_PER_LONG) {
> >                       rvcpu = kvm_get_vcpu_by_id(vcpu->kvm, i);
> >@@ -154,22 +165,100 @@ int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >               }
> >               riscv_cpuid_to_hartid_mask(&cm, &hm);
> >               if (cp->a7 == SBI_EXT_0_1_REMOTE_FENCE_I)
> >-                      sbi_remote_fence_i(cpumask_bits(&hm));
> >+                      ret = sbi_remote_fence_i(cpumask_bits(&hm));
> >               else if (cp->a7 == SBI_EXT_0_1_REMOTE_SFENCE_VMA)
> >-                      sbi_remote_hfence_vvma(cpumask_bits(&hm),
> >+                      ret = sbi_remote_hfence_vvma(cpumask_bits(&hm),
> >                                               cp->a1, cp->a2);
> >               else
> >-                      sbi_remote_hfence_vvma_asid(cpumask_bits(&hm),
> >+                      ret = sbi_remote_hfence_vvma_asid(cpumask_bits(&hm),
> >                                               cp->a1, cp->a2, cp->a3);
> >               break;
> >       default:
> >+              ret = -EINVAL;
> >+              break;
> >+      }
> >+
> >+      return ret;
> >+}
> >+
> >+const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_v01 = {
> >+      .extid_start = SBI_EXT_0_1_SET_TIMER,
> >+      .extid_end = SBI_EXT_0_1_SHUTDOWN,
> >+      .handler = kvm_sbi_ext_v01_handler,
> >+};
> >+
> >+static const struct kvm_vcpu_sbi_extension *sbi_ext[] = {
> >+      &vcpu_sbi_ext_v01,
> >+};
> >+
> >+const struct kvm_vcpu_sbi_extension *kvm_vcpu_sbi_find_ext(unsigned long extid)
> >+{
> >+      int i = 0;
> >+
> >+      for (i = 0; i < ARRAY_SIZE(sbi_ext); i++) {
> >+              if (sbi_ext[i]->extid_start <= extid &&
> >+                  sbi_ext[i]->extid_end >= extid)
> >+                      return sbi_ext[i];
> >+      }
> >+
> >+      return NULL;
> >+}
> >+
> >+int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >+{
> >+      int ret = 1;
> >+      bool next_sepc = true;
> >+      bool userspace_exit = false;
> >+      struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
> >+      const struct kvm_vcpu_sbi_extension *sbi_ext;
> >+      struct kvm_cpu_trap utrap = { 0 };
> >+      unsigned long out_val = 0;
> >+      bool ext_is_v01 = false;
> >+
> >+      if (!cp)
> >+              return -EINVAL;
> >+
> >+      sbi_ext = kvm_vcpu_sbi_find_ext(cp->a7);
> >+      if (sbi_ext && sbi_ext->handler) {
> >+              if (cp->a7 >= SBI_EXT_0_1_SET_TIMER &&
> >+                  cp->a7 <= SBI_EXT_0_1_SHUTDOWN)
> >+                      ext_is_v01 = true;
> >+              ret = sbi_ext->handler(vcpu, run, &out_val, &utrap, &userspace_exit);
> >+      } else {
> >               /* Return error for unsupported SBI calls */
> >               cp->a0 = SBI_ERR_NOT_SUPPORTED;
> >-              break;
> >+              goto ecall_done;
> >       }
> >
> >+      /* Handle special error cases i.e trap, exit or userspace forward */
> >+      if (utrap.scause) {
> >+              /* No need to increment sepc or exit ioctl loop */
> >+              ret = 1;
> >+              utrap.sepc = cp->sepc;
> >+              kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
> >+              next_sepc = false;
> >+              goto ecall_done;
> >+      }
> >+
> >+      /* Exit ioctl loop or Propagate the error code the guest */
> >+      if (userspace_exit) {
> >+              next_sepc = false;
> >+              ret = 0;
> >+      } else {
> >+              /**
> >+               * SBI extension handler always returns an Linux error code. Convert
> >+               * it to the SBI specific error code that can be propagated the SBI
> >+               * caller.
> >+               */
> >+              ret = kvm_linux_err_map_sbi(ret);
> >+              cp->a0 = ret;
> >+              ret = 1;
> >+      }
> >+ecall_done:
> >       if (next_sepc)
> >               cp->sepc += 4;
> >+      if (!ext_is_v01)
> >+              cp->a1 = out_val;
> >
> >       return ret;
> > }
>
>
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv



-- 
Regards,
Atish
