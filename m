Return-Path: <kvm+bounces-5962-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 880498291F8
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 02:17:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 99ECE1C23650
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 01:17:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 169048F6C;
	Wed, 10 Jan 2024 01:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bVwNcSjF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3EC953A6
	for <kvm@vger.kernel.org>; Wed, 10 Jan 2024 01:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dbcd9f4396eso4930489276.0
        for <kvm@vger.kernel.org>; Tue, 09 Jan 2024 17:15:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704849342; x=1705454142; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=mX9ZU+1m0BrodkWf6AaI85KgoYtkfH6tJUIjqhj930U=;
        b=bVwNcSjFESVuFpg6LAHHYMR8/QjDjseO9/eg7vjCANPhsM39d2F4XoRrZchGEyXXsq
         eRitVq25JH1M8//2lfcjGGRR+ut54DDaSn5o1oRkr5B3gV58WmNZOQNbu57im0xG65dO
         daL9+x6DLnM5iQBm+sVK6KU5seXuf4m0d5C8xLhUkh/Y60O50hF4K8mHdA/eaon4hA7S
         KaD4BAI+Jdkh0QxjfCLBnYHk7vj//7xhmG4rzYdeG/VYy+mZLtYUK4I2QoEdW9/YDPZt
         Cu+ji46c6WRpLLSs6S4CftZ73Kd/LnU0EpSa9XmPx88y8A5LwDEbhpoDV7Bo9JJlBvC9
         jlzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704849342; x=1705454142;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mX9ZU+1m0BrodkWf6AaI85KgoYtkfH6tJUIjqhj930U=;
        b=Yf3VJhHItYFpvWAB+Zjxm+cjedi95fKagpIGUJHQN/PJfu/tGIhWRnRmh/AwWzFzin
         AAyEeQEvL0ilGtPlo9GVm1HxSm9ov0mvvlZG1eCox3FeZcYW8zTUVkxrhCl3u8BEWAyr
         rJEza/fPlwnvWv2TalDH0c3KKa6NoE4lNUVJRHW+fgWAE84fWAiv/Ylo5KSaHAzlcTjQ
         00d0/xKTSSS4GOnj7FuxdtM2adRz80F5frj8TlguqE56ppQl6uz5rYoR7fSb8SQPrIuZ
         QPx3Lbu4trC19QN4us+W4ZcLQcOgSY+ghd/4cWVDyJHC09T1MQD/NkQ2gVaEgutZXEMv
         +JPw==
X-Gm-Message-State: AOJu0Yyol4lMV5P2yNfe99TGgnteA3IEM839rG43RVokOWaokkTOG1Ik
	8T2l6JfKFDlKuJ4MPvsz7E0ezIFG4vf+9U/nnA==
X-Google-Smtp-Source: AGHT+IHaLuS4kAIrF+XCH5QdXQ4OxQ6NkjBy+SO1qhpsf6OFBPVqu2gV9AfGYUTrXFQq9qb+Prlb1FHVsio=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1364:b0:dbf:2471:5341 with SMTP id
 bt4-20020a056902136400b00dbf24715341mr103599ybb.10.1704849341932; Tue, 09 Jan
 2024 17:15:41 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  9 Jan 2024 17:15:32 -0800
In-Reply-To: <20240110011533.503302-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240110011533.503302-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20240110011533.503302-4-seanjc@google.com>
Subject: [PATCH 3/4] KVM: Get reference to VM's address space in the async #PF worker
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, Xu Yilun <yilun.xu@linux.intel.com>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Get a reference to the target VM's address space in async_pf_execute()
instead of gifting a reference from kvm_setup_async_pf().  Keeping the
address space alive just to service an async #PF is counter-productive,
i.e. if the process is exiting and all vCPUs are dead, then NOT doing
get_user_pages_remote() and freeing the address space asap is desirable.

Handling the mm reference entirely within async_pf_execute() also
simplifies the async #PF flows as a whole, e.g. it's not immediately
obvious when the worker task vs. the vCPU task is responsible for putting
the gifted mm reference.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_host.h |  1 -
 virt/kvm/async_pf.c      | 32 ++++++++++++++++++--------------
 2 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7e7fd25b09b3..bbfefd7e612f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -238,7 +238,6 @@ struct kvm_async_pf {
 	struct list_head link;
 	struct list_head queue;
 	struct kvm_vcpu *vcpu;
-	struct mm_struct *mm;
 	gpa_t cr2_or_gpa;
 	unsigned long addr;
 	struct kvm_arch_async_pf arch;
diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
index d5dc50318aa6..c3f4f351a2ae 100644
--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -46,8 +46,8 @@ static void async_pf_execute(struct work_struct *work)
 {
 	struct kvm_async_pf *apf =
 		container_of(work, struct kvm_async_pf, work);
-	struct mm_struct *mm = apf->mm;
 	struct kvm_vcpu *vcpu = apf->vcpu;
+	struct mm_struct *mm = vcpu->kvm->mm;
 	unsigned long addr = apf->addr;
 	gpa_t cr2_or_gpa = apf->cr2_or_gpa;
 	int locked = 1;
@@ -56,16 +56,24 @@ static void async_pf_execute(struct work_struct *work)
 	might_sleep();
 
 	/*
-	 * This work is run asynchronously to the task which owns
-	 * mm and might be done in another context, so we must
-	 * access remotely.
+	 * Attempt to pin the VM's host address space, and simply skip gup() if
+	 * acquiring a pin fail, i.e. if the process is exiting.  Note, KVM
+	 * holds a reference to its associated mm_struct until the very end of
+	 * kvm_destroy_vm(), i.e. the struct itself won't be freed before this
+	 * work item is fully processed.
 	 */
-	mmap_read_lock(mm);
-	get_user_pages_remote(mm, addr, 1, FOLL_WRITE, NULL, &locked);
-	if (locked)
-		mmap_read_unlock(mm);
-	mmput(mm);
+	if (mmget_not_zero(mm)) {
+		mmap_read_lock(mm);
+		get_user_pages_remote(mm, addr, 1, FOLL_WRITE, NULL, &locked);
+		if (locked)
+			mmap_read_unlock(mm);
+		mmput(mm);
+	}
 
+	/*
+	 * Notify and kick the vCPU even if faulting in the page failed, e.g.
+	 * so that the vCPU can retry the fault synchronously.
+	 */
 	if (IS_ENABLED(CONFIG_KVM_ASYNC_PF_SYNC))
 		kvm_arch_async_page_present(vcpu, apf);
 
@@ -129,10 +137,8 @@ void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu)
 #ifdef CONFIG_KVM_ASYNC_PF_SYNC
 		flush_work(&work->work);
 #else
-		if (cancel_work_sync(&work->work)) {
-			mmput(work->mm);
+		if (cancel_work_sync(&work->work))
 			kmem_cache_free(async_pf_cache, work);
-		}
 #endif
 		spin_lock(&vcpu->async_pf.lock);
 	}
@@ -211,8 +217,6 @@ bool kvm_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	work->cr2_or_gpa = cr2_or_gpa;
 	work->addr = hva;
 	work->arch = *arch;
-	work->mm = current->mm;
-	mmget(work->mm);
 
 	INIT_WORK(&work->work, async_pf_execute);
 
-- 
2.43.0.472.g3155946c3a-goog


