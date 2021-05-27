Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D43D3926A3
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 06:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234577AbhE0E6m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 00:58:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234431AbhE0E6j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 May 2021 00:58:39 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCB90C061760;
        Wed, 26 May 2021 21:57:05 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id i23-20020a9d68d70000b02902dc19ed4c15so3308588oto.0;
        Wed, 26 May 2021 21:57:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zd33jEwk8aHcS5XVZ56yw2Oa1m/r43mn4HOR1FizvXU=;
        b=S3Q3irWuVCW9yu9MDQAE7KTjnhM/caOcdVcxZmKxu/a9WxHh1BOfD970uWtTPqCQrV
         Rj3gsWRoMHvBobnlMbQnZ72NxeQ7761HUk1xPHQPwd4EUO4GuHlFpkMDjnBCyBFxn2CB
         ERnwMOp1G48Pu8Y6nKL++IroC/7XOJoUCI0U9RF/uC4k+ghA84wsIxp0u204F6biLwid
         sfI/p9qDDPAe7cD9bmPs1aT3JxF/2w/vK6pgiJFlF3YoFei4UlaWzcgQhJnJwFkCMjoq
         NzN1eORSy+VODVm72LhiDH3MRgAyZY/btEjET53xim+VaMZtYGClYdAH41XmdhEAjWJM
         YvCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zd33jEwk8aHcS5XVZ56yw2Oa1m/r43mn4HOR1FizvXU=;
        b=kbcd00dkUXUcYELmsrsGkEXZVCZtTAdc+Gwg9yANL5NWBFZ4C52UNzhI/ov24ZQVU1
         wHjq3eErHQIFi9UTkm7riM3LAFVCj/aE5o7prMtuS1PvYirVQRe3Zk2A0SUrG41pUVFc
         SoWddebKWTLSq85uWWEcnxiaMdKPSLh69yeN/bBGevuT+LkAx9F8rMpJ0tWP9LzYwODQ
         CuKod1YjTocWFodRu+glvBWGq4FFSivHf0/HdoSqcX4be0mhmW4VXnSq6EOD2tW/TnNt
         /lDIQF03htLOMfL15IXwC3BW5uDKKMeI9gnmDFKL+WsI/YeYVi3wWsa26+f2LoHHMJdl
         OKVw==
X-Gm-Message-State: AOAM533d0stulAPMGvyEOJfnQ5Fe5yvMifB9juX69j8OsEP7Uig83GcB
        BhVHeAcqCZfIpDkDFBvSLdweqkPoxjU0jQn5fD8=
X-Google-Smtp-Source: ABdhPJyqy6tKSYJTO5Q/P3AU0dl27HaGrFoIR5zhBPvAV35Y/8Rt1mNAb4MgMs8/FoG3RwsudmZ9xYXw33XpsO6chec=
X-Received: by 2002:a9d:4b0e:: with SMTP id q14mr1304495otf.254.1622091425262;
 Wed, 26 May 2021 21:57:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210527084356.12c2784f@canb.auug.org.au>
In-Reply-To: <20210527084356.12c2784f@canb.auug.org.au>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 27 May 2021 12:56:54 +0800
Message-ID: <CANRm+CyC+=hMrVJCVWZ7cTC_F3CXYKRms2xNFQCvWa5rPS3U-w@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the kvm-fixes tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 27 May 2021 at 10:50, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi all,
>
> After merging the kvm-fixes tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>
> In file included from arch/powerpc/include/asm/kvm_ppc.h:19,
>                  from arch/powerpc/include/asm/dbell.h:17,
>                  from arch/powerpc/kernel/asm-offsets.c:38:
> include/linux/kvm_host.h: In function 'kvm_vcpu_can_poll':
> include/linux/kvm_host.h:270:9: error: implicit declaration of function 'single_task_running' [-Werror=implicit-function-declaration]
>   270 |  return single_task_running() && !need_resched() && ktime_before(cur, stop);
>       |         ^~~~~~~~~~~~~~~~~~~
>
> Caused by commit
>
>   85d4c3baeb45 ("KVM: PPC: exit halt polling on need_resched()")
>
> I have used the kvm-fixes tree from next-20210524 again today.

The kvm/master is broken by several patches.

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 0f6f394..e851671 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1659,7 +1659,7 @@ struct kvm_hv_hcall {

 static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct
kvm_hv_hcall *hc, bool ex)
 {
-    int i, j;
+    int i;
     gpa_t gpa;
     struct kvm *kvm = vcpu->kvm;
     struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9d095bed..feb9611 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3604,7 +3604,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu,
struct msr_data *msr_info)
          * to ensure backwards-compatible behavior for migration.
          */
         if (msr_info->host_initiated &&
-            kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_TSC_HOST_ACCESS))
+            kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_TSC_HOST_ACCESS)) {
             offset = vcpu->arch.l1_tsc_offset;
             ratio = vcpu->arch.l1_tsc_scaling_ratio;
         } else {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 18905c9..4273e04 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -10,6 +10,7 @@
 #include <linux/spinlock.h>
 #include <linux/signal.h>
 #include <linux/sched.h>
+#include <linux/sched/stat.h>
 #include <linux/bug.h>
 #include <linux/minmax.h>
 #include <linux/mm.h>
