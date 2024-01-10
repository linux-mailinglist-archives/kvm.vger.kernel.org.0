Return-Path: <kvm+bounces-5960-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2925E8291F4
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 02:16:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 65BDE288090
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 01:16:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CCF346AD;
	Wed, 10 Jan 2024 01:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qiW5NejF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D225C15D1
	for <kvm@vger.kernel.org>; Wed, 10 Jan 2024 01:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dbf1c3816a3so1026625276.1
        for <kvm@vger.kernel.org>; Tue, 09 Jan 2024 17:15:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704849338; x=1705454138; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=XYuPpMHg4kkSf61Majt6ZB1e5OqyEZJQxirPTzJ0Fdw=;
        b=qiW5NejF4maQ9b2Dlimzdpcp53dwS+KZAernKfMXgv/Mb97qv5NqoSKLaPtniKbhcZ
         f1vvOnnK9tXYTqFpTY+gT9GQi/f6eEOTLDFcbnpNJEgF8vxFegXRrQVDv5pZ9pf8gn7Y
         TJ5D9H5Y5cTs5orpASXqH5JHTzvKGFygvxZK7hFUHuVrxc5ihEhm5sDvojOUfuGDWgpQ
         KIdVqRw6lefSGTyoJ8WokVSOKXbdH59EcN96maj8DWfkbvYPCHJfhZiPmVYMvLWchPOd
         92lKhnvqv5lfjKQ53fvwkdJPCfKEgw5rV4u2RO9dxxoi0wjzXGOuRi1b1jeAEECfXoQ7
         kuxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704849338; x=1705454138;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XYuPpMHg4kkSf61Majt6ZB1e5OqyEZJQxirPTzJ0Fdw=;
        b=AxEJhPr7Cpy8Wre2DGdZXRfV4sBYtqV4iWRfX1TFKcfw7UqRX8R4EOyNZDr8VbUtbj
         9k73qIGEeBXJOHRCkfy63b4QsHcqWUk/j11ps7cvLqCK861daAdPMujstAM2TMtFIF+x
         VDTE11ebn3uUBkKyIOQg0T4b8t1uge0RLbtxKYo29dw3g4epOu7IlT6qDhJG+P7DSpyb
         uxn0i9FZAPtHXZig8JG2/YOBKdw6dRM0fDOgQugqEfd+V4cTwpj4X+tmmJtJAzXKNGgm
         iEicgU3zEHgaqOrcKnRIa3qmF6HPVm7p9Zt4aPXDdWqi7HPgv0YWVUEw82cKpcGaHW9Z
         VnRg==
X-Gm-Message-State: AOJu0Yz997H34gP8wnErag1gHJ0kke4FcXUO52yu6VOQvUw1kLlgpduC
	/EKkN/DhWtlcJUIQqQBV5kx/ECIDmj2gUwbvSA==
X-Google-Smtp-Source: AGHT+IHPHYzTfLV1eyWciUMErntB/kDHFOk79hccdy8996kR1y9nEE7EfVhcF4BWE9mB/Y6Qjh4D0pBEn50=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:8002:0:b0:dbe:4772:395e with SMTP id
 m2-20020a258002000000b00dbe4772395emr6664ybk.5.1704849337952; Tue, 09 Jan
 2024 17:15:37 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  9 Jan 2024 17:15:30 -0800
In-Reply-To: <20240110011533.503302-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240110011533.503302-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20240110011533.503302-2-seanjc@google.com>
Subject: [PATCH 1/4] KVM: Always flush async #PF workqueue when vCPU is being destroyed
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, Xu Yilun <yilun.xu@linux.intel.com>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Always flush the per-vCPU async #PF workqueue when a vCPU is clearing its
completion queue, e.g. when a VM and all its vCPUs is being destroyed.
KVM must ensure that none of its workqueue callbacks is running when the
last reference to the KVM _module_ is put.  Gifting a reference to the
associated VM prevents the workqueue callback from dereferencing freed
vCPU/VM memory, but does not prevent the KVM module from being unloaded
before the callback completes.

Drop the misguided VM refcount gifting, as calling kvm_put_kvm() from
async_pf_execute() if kvm_put_kvm() flushes the async #PF workqueue will
result in deadlock.  async_pf_execute() can't return until kvm_put_kvm()
finishes, and kvm_put_kvm() can't return until async_pf_execute() finishes:

 WARNING: CPU: 8 PID: 251 at virt/kvm/kvm_main.c:1435 kvm_put_kvm+0x2d/0x320 [kvm]
 Modules linked in: vhost_net vhost vhost_iotlb tap kvm_intel kvm irqbypass
 CPU: 8 PID: 251 Comm: kworker/8:1 Tainted: G        W          6.6.0-rc1-e7af8d17224a-x86/gmem-vm #119
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
 Workqueue: events async_pf_execute [kvm]
 RIP: 0010:kvm_put_kvm+0x2d/0x320 [kvm]
 Call Trace:
  <TASK>
  async_pf_execute+0x198/0x260 [kvm]
  process_one_work+0x145/0x2d0
  worker_thread+0x27e/0x3a0
  kthread+0xba/0xe0
  ret_from_fork+0x2d/0x50
  ret_from_fork_asm+0x11/0x20
  </TASK>
 ---[ end trace 0000000000000000 ]---
 INFO: task kworker/8:1:251 blocked for more than 120 seconds.
       Tainted: G        W          6.6.0-rc1-e7af8d17224a-x86/gmem-vm #119
 "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
 task:kworker/8:1     state:D stack:0     pid:251   ppid:2      flags:0x00004000
 Workqueue: events async_pf_execute [kvm]
 Call Trace:
  <TASK>
  __schedule+0x33f/0xa40
  schedule+0x53/0xc0
  schedule_timeout+0x12a/0x140
  __wait_for_common+0x8d/0x1d0
  __flush_work.isra.0+0x19f/0x2c0
  kvm_clear_async_pf_completion_queue+0x129/0x190 [kvm]
  kvm_arch_destroy_vm+0x78/0x1b0 [kvm]
  kvm_put_kvm+0x1c1/0x320 [kvm]
  async_pf_execute+0x198/0x260 [kvm]
  process_one_work+0x145/0x2d0
  worker_thread+0x27e/0x3a0
  kthread+0xba/0xe0
  ret_from_fork+0x2d/0x50
  ret_from_fork_asm+0x11/0x20
  </TASK>

If kvm_clear_async_pf_completion_queue() actually flushes the workqueue,
then there's no need to gift async_pf_execute() a reference because all
invocations of async_pf_execute() will be forced to complete before the
vCPU and its VM are destroyed/freed.  And that in turn fixes the module
unloading bug as __fput() won't do module_put() on the last vCPU reference
until the vCPU has been freed, e.g. if closing the vCPU file also puts the
last reference to the KVM module.

Note that kvm_check_async_pf_completion() may also take the work item off
the completion queue and so also needs to flush the work queue, as the
work will not be seen by kvm_clear_async_pf_completion_queue().  Waiting
on the workqueue could theoretically delay a vCPU due to waiting for the
work to complete, but that's a very, very small chance, and likely a very
small delay.  kvm_arch_async_page_present_queued() unconditionally makes a
new request, i.e. will effectively delay entering the guest, so the
remaining work is really just:

        trace_kvm_async_pf_completed(addr, cr2_or_gpa);

        __kvm_vcpu_wake_up(vcpu);

        mmput(mm);

and mmput() can't drop the last reference to the page tables if the vCPU is
still alive, i.e. the vCPU won't get stuck tearing down page tables.

Add a helper to do the flushing, specifically to deal with "wakeup all"
work items, as they aren't actually work items, i.e. are never placed in a
workqueue.  Trying to flush a bogus workqueue entry rightly makes
__flush_work() complain (kudos to whoever added that sanity check).

Note, commit 5f6de5cbebee ("KVM: Prevent module exit until all VMs are
freed") *tried* to fix the module refcounting issue by having VMs grab a
reference to the module, but that only made the bug slightly harder to hit
as it gave async_pf_execute() a bit more time to complete before the KVM
module could be unloaded.

Fixes: af585b921e5d ("KVM: Halt vcpu if page it tries to access is swapped out")
Cc: stable@vger.kernel.org
Cc: David Matlack <dmatlack@google.com>
Cc: Xu Yilun <yilun.xu@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/async_pf.c | 37 ++++++++++++++++++++++++++++++++-----
 1 file changed, 32 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
index e033c79d528e..876927a558ad 100644
--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -87,7 +87,25 @@ static void async_pf_execute(struct work_struct *work)
 	__kvm_vcpu_wake_up(vcpu);
 
 	mmput(mm);
-	kvm_put_kvm(vcpu->kvm);
+}
+
+static void kvm_flush_and_free_async_pf_work(struct kvm_async_pf *work)
+{
+	/*
+	 * The async #PF is "done", but KVM must wait for the work item itself,
+	 * i.e. async_pf_execute(), to run to completion.  If KVM is a module,
+	 * KVM must ensure *no* code owned by the KVM (the module) can be run
+	 * after the last call to module_put(), i.e. after the last reference
+	 * to the last vCPU's file is put.
+	 *
+	 * Wake all events skip the queue and go straight done, i.e. don't
+	 * need to be flushed (but sanity check that the work wasn't queued).
+	 */
+	if (work->wakeup_all)
+		WARN_ON_ONCE(work->work.func);
+	else
+		flush_work(&work->work);
+	kmem_cache_free(async_pf_cache, work);
 }
 
 void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu)
@@ -114,7 +132,6 @@ void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu)
 #else
 		if (cancel_work_sync(&work->work)) {
 			mmput(work->mm);
-			kvm_put_kvm(vcpu->kvm); /* == work->vcpu->kvm */
 			kmem_cache_free(async_pf_cache, work);
 		}
 #endif
@@ -126,7 +143,18 @@ void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu)
 			list_first_entry(&vcpu->async_pf.done,
 					 typeof(*work), link);
 		list_del(&work->link);
-		kmem_cache_free(async_pf_cache, work);
+
+		spin_unlock(&vcpu->async_pf.lock);
+
+		/*
+		 * The async #PF is "done", but KVM must wait for the work item
+		 * itself, i.e. async_pf_execute(), to run to completion.  If
+		 * KVM is a module, KVM must ensure *no* code owned by the KVM
+		 * (the module) can be run after the last call to module_put(),
+		 * i.e. after the last reference to the last vCPU's file is put.
+		 */
+		kvm_flush_and_free_async_pf_work(work);
+		spin_lock(&vcpu->async_pf.lock);
 	}
 	spin_unlock(&vcpu->async_pf.lock);
 
@@ -151,7 +179,7 @@ void kvm_check_async_pf_completion(struct kvm_vcpu *vcpu)
 
 		list_del(&work->queue);
 		vcpu->async_pf.queued--;
-		kmem_cache_free(async_pf_cache, work);
+		kvm_flush_and_free_async_pf_work(work);
 	}
 }
 
@@ -186,7 +214,6 @@ bool kvm_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	work->arch = *arch;
 	work->mm = current->mm;
 	mmget(work->mm);
-	kvm_get_kvm(work->vcpu->kvm);
 
 	INIT_WORK(&work->work, async_pf_execute);
 
-- 
2.43.0.472.g3155946c3a-goog


