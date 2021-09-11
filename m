Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6C0E407434
	for <lists+kvm@lfdr.de>; Sat, 11 Sep 2021 02:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234957AbhIKAcB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Sep 2021 20:32:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232897AbhIKAbz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Sep 2021 20:31:55 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47EBCC061574
        for <kvm@vger.kernel.org>; Fri, 10 Sep 2021 17:30:44 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id gp20-20020a17090adf1400b00196b761920aso2556427pjb.3
        for <kvm@vger.kernel.org>; Fri, 10 Sep 2021 17:30:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=27ing1Qnle8PRaUCoUQ3evXKGddslAnOCUAVuI9LWfc=;
        b=Lmx6ffT8T3EJLe56mwkJmstO1dja3Ish2B9BRK87vd4WTq7lzuq26uZMQI0FAzUzP7
         s8A6TkQo5e4Rbj4h9WGe1SP7tpFb1CL9Sy/7ofiAZxRKSZWTjgiUZ2/+jl4oqfkgQmCu
         hW8vbV4AY7wgPUhug5A34ovNTdE7Mzt+7I/wK5HJs9XsGn9TEPJXjN0bmUag7qpJq2nu
         c+PXq8ITpxf/HB3ytaWEcv75AEul6BIGCgVOUULGNCWTmIgFLgwdVF4itghzGAo9C0gn
         Ua2bd08T7vgf7s5oc+Q6rVAoiXeXa/hgKjowNGyA7bDgFN8EpI1YCfkjrm/hv5AdN7I7
         TDUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=27ing1Qnle8PRaUCoUQ3evXKGddslAnOCUAVuI9LWfc=;
        b=taqRJN2B5zwQQvrFB59ZYU+bFx8gh5hI2eUKWtbhD7O9OYevqT2zcqD2y7co1nclLi
         +8AWw5yjeGXW1lFhFsKbdkGbBCnD4eSbWEAqtZToV4xUx0DxL80Ck+Iu2oEURcLqUGAD
         jP91bUyzqcbkf49JHwJRitjUufKvN5cNxUQ3Nh4aKHSEWaDhLmoq8LO1wMYg8dO6DwI4
         rXMvPaSePy/84IuZd7dxV5kzHTQCH+K2JVzgGqCFVS1Ek6c2H3e6pMIpdiyioHtTKCuj
         da2mvfsKeBfWlxuqUhXMI2wdozONFt8NNRn7R39h+/2IiBKilAb9Lrk8poWriR5UejzY
         rZdw==
X-Gm-Message-State: AOAM533xarxwJCRC4vrkE7icjM+o9uh2OTC6RTB+1ReRPwUt/zNvHEKI
        IlHW27RZ/oG473sshDc+n+wLSvGMufQ0kQ==
X-Google-Smtp-Source: ABdhPJwG8jlKctouxZmsbgQhfer1Z5CqRwhsuZe3C32txBAfM0YkF5mjdRcHTCti+pVLEx04cZFrRg==
X-Received: by 2002:a17:90a:1b2a:: with SMTP id q39mr265543pjq.219.1631320242881;
        Fri, 10 Sep 2021 17:30:42 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u6sm101757pgr.3.2021.09.10.17.30.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 17:30:42 -0700 (PDT)
Date:   Sat, 11 Sep 2021 00:30:38 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        Juergen Gross <jgross@suse.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH v2 0/3] kvm: x86: Set KVM_MAX_VCPUS=1024,
 KVM_SOFT_MAX_VCPUS=710
Message-ID: <YTv4rgPol5vILWay@google.com>
References: <20210903211600.2002377-1-ehabkost@redhat.com>
 <1111efc8-b32f-bd50-2c0f-4c6f506b544b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1111efc8-b32f-bd50-2c0f-4c6f506b544b@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 06, 2021, Paolo Bonzini wrote:
> On 03/09/21 23:15, Eduardo Habkost wrote:
> > - Increases KVM_MAX_VCPU_ID from 1023 to 4096.

...

> > Eduardo Habkost (3):
> >    kvm: x86: Set KVM_MAX_VCPU_ID to 4*KVM_MAX_VCPUS

...

> >    kvm: x86: Increase MAX_VCPUS to 1024
> >    kvm: x86: Increase KVM_SOFT_MAX_VCPUS to 710
> > 
> >   arch/x86/include/asm/kvm_host.h | 18 +++++++++++++++---
> >   1 file changed, 15 insertions(+), 3 deletions(-)
> > 
> 
> Queued, thanks.

Before we commit to this, can we sort out the off-by-one mess that is KVM_MAX_VCPU_ID?
As Eduardo pointed out[*], Juergen's commit 76b4f357d0e7 ("x86/kvm: fix vcpu-id
indexed array sizes") _shouldn't_ be necessary because kvm_vm_ioctl_create_vcpu()
rejects attempts to create id==KVM_MAX_VCPU_ID

	if (id >= KVM_MAX_VCPU_ID)
		return -EINVAL;

which aligns with the docs for KVM_CREATE_VCPU:

	The vcpu id is an integer in the range [0, max_vcpu_id)

but the fix is "needed" because rtc_irq_eoi_tracking_reset() does

	bitmap_zero(ioapic->rtc_status.dest_map.map, KVM_MAX_VCPU_ID + 1);

and now we have this

	DECLARE_BITMAP(map, KVM_MAX_VCPU_ID + 1);
	u8 vectors[KVM_MAX_VCPU_ID + 1];

which is wrong as well.  The "right" fix would have been to change
rtc_irq_eoi_tracking_reset(), but that looks all kinds of wrong on the surface.

Non-x86 really mucks it up because generic code does:

	#ifndef KVM_MAX_VCPU_ID
	#define KVM_MAX_VCPU_ID KVM_MAX_VCPUS
	#endif

which means pretty much everything else can create more vCPUs than vCPU IDs.

Maybe fix KVM's internal KVM_MAX_VCPU_ID so that it's incluse, and handle the
backwards compability mess in KVM_CAP_MAX_VCPU_ID?  Then have the max ID for x86
be (4*KVM_MAX_VCPUS - 1).  E.g. something like:

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e5d5c5ed7dd4..2e5c8081f72b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4061,7 +4061,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
                r = KVM_MAX_VCPUS;
                break;
        case KVM_CAP_MAX_VCPU_ID:
-               r = KVM_MAX_VCPU_ID;
+               /* KVM's ABI is stupid. */
+               r = KVM_MAX_VCPU_ID - 1;
                break;
        case KVM_CAP_PV_MMU:    /* obsolete */
                r = 0;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b50dbe269f4b..ba46c42a4a6f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3460,7 +3460,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
        struct kvm_vcpu *vcpu;
        struct page *page;

-       if (id >= KVM_MAX_VCPU_ID)
+       if (id > KVM_MAX_VCPU_ID)
                return -EINVAL;

        mutex_lock(&kvm->lock);
17:23:40 ✔ ~/go/src/kernel.org/host $ gdd
diff --git a/arch/powerpc/include/asm/kvm_book3s.h b/arch/powerpc/include/asm/kvm_book3s.h
index caaa0f592d8e..0292d8a5ce5e 100644
--- a/arch/powerpc/include/asm/kvm_book3s.h
+++ b/arch/powerpc/include/asm/kvm_book3s.h
@@ -434,7 +434,7 @@ extern int kvmppc_h_logical_ci_store(struct kvm_vcpu *vcpu);
 #define SPLIT_HACK_OFFS                        0xfb000000

 /*
- * This packs a VCPU ID from the [0..KVM_MAX_VCPU_ID) space down to the
+ * This packs a VCPU ID from the [0..KVM_MAX_VCPU_ID] space down to the
  * [0..KVM_MAX_VCPUS) space, using knowledge of the guest's core stride
  * (but not its actual threading mode, which is not available) to avoid
  * collisions.
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 9f52f282b1aa..beeebace8d1c 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -33,11 +33,11 @@

 #ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
 #include <asm/kvm_book3s_asm.h>                /* for MAX_SMT_THREADS */
-#define KVM_MAX_VCPU_ID                (MAX_SMT_THREADS * KVM_MAX_VCORES)
+#define KVM_MAX_VCPU_ID                (MAX_SMT_THREADS * KVM_MAX_VCORES) - 1
 #define KVM_MAX_NESTED_GUESTS  KVMPPC_NR_LPIDS

 #else
-#define KVM_MAX_VCPU_ID                KVM_MAX_VCPUS
+#define KVM_MAX_VCPU_ID                KVM_MAX_VCPUS - 1
 #endif /* CONFIG_KVM_BOOK3S_HV_POSSIBLE */

 #define __KVM_HAVE_ARCH_INTC_INITIALIZED
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e5d5c5ed7dd4..5c20c0bd4db6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4061,7 +4061,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
                r = KVM_MAX_VCPUS;
                break;
        case KVM_CAP_MAX_VCPU_ID:
-               r = KVM_MAX_VCPU_ID;
+               /* KVM's ABI is stupid. */
+               r = KVM_MAX_VCPU_ID + 1;
                break;
        case KVM_CAP_PV_MMU:    /* obsolete */
                r = 0;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ae7735b490b4..37ef972caf4b 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -40,7 +40,7 @@
 #include <linux/kvm_dirty_ring.h>

 #ifndef KVM_MAX_VCPU_ID
-#define KVM_MAX_VCPU_ID KVM_MAX_VCPUS
+#define KVM_MAX_VCPU_ID KVM_MAX_VCPUS - 1
 #endif

 /*
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b50dbe269f4b..ba46c42a4a6f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3460,7 +3460,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
        struct kvm_vcpu *vcpu;
        struct page *page;

-       if (id >= KVM_MAX_VCPU_ID)
+       if (id > KVM_MAX_VCPU_ID)
                return -EINVAL;

        mutex_lock(&kvm->lock);


