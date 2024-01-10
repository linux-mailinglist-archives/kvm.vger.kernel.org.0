Return-Path: <kvm+bounces-5961-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D75CE8291F6
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 02:16:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1F9CE287934
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 01:16:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F19A65664;
	Wed, 10 Jan 2024 01:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CvT+ThHt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D822D33E8
	for <kvm@vger.kernel.org>; Wed, 10 Jan 2024 01:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dbdac466edcso4079389276.2
        for <kvm@vger.kernel.org>; Tue, 09 Jan 2024 17:15:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704849340; x=1705454140; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=MSa3yAe8jPQSi96I05+ffZSVty1oHKuW7qm39NwPaMU=;
        b=CvT+ThHt67ibjlOE2BRw0lbHsson8mUEGeMIcP0Yj/cQNvpShj9Y1XoFz6Zyh2y6DP
         lbqMxyfQJYFHGB/wWkV0YCysKHAMrWWAbYSU3QiTbRVN7lvq6oLpizCEBoZi/CDzxQ/D
         XihlPvZrbxQUDHPGWKVGtRBmCpwRLZlSmv63G+s3AJ50xQyjWcRM7vJYj1sgbVm7830b
         01xc+xOa6StjjSWBT8K5GDpy0asLSTxi0+gcwAswAvuUzG7ndvRm8Ft2NU3HKrqAyY+5
         /CVjLo6Wxyw2aCnLGJCww3S3k89So9Ax2N34wdqRrgo+n7c6qfb70phCMgWH6IyN3nsV
         9J8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704849340; x=1705454140;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MSa3yAe8jPQSi96I05+ffZSVty1oHKuW7qm39NwPaMU=;
        b=NJW/ZO67jcA+Q/7iCWIIPTavDwHrOVgpEGQMnjsURGi5Mq0OHhgDQ4oT34OVTBHmeL
         7cgeNkjy54f9R+WU/3JBzsrwvhCsE6B8BAP1VJrEN+WbRr5ukCR6kNXGykVc1Tfb0rrV
         WnHmjQKvgYFNre35HXE/px+yhapJ+tDd3OaGCuujR9WxnIzZFZQRb/KlONf5OpcXGw2I
         dF4JqkGDpzp3Ao1Bzb5025nvnx/0JIzDe5wuPY4IJ8zTReC388xUBjM0Ocr6tf+BBJ7K
         dZyWQzal13kQzgiF7o20HgQYXMPKaLqhKLizE0GS4XxJ46/LmdDde4AjnO7eMMeiPA+y
         6XXA==
X-Gm-Message-State: AOJu0Yx78Dw3n45FHfYI9OTGUSCzlpeZuOkRCGWFuLE9YyiN8SUQoJ7l
	m25gaOelich6BPO8jFavCecdX/lgBYzYONEBYQ==
X-Google-Smtp-Source: AGHT+IEE0VBsviB3u2D39fkX0O0IUZsZjyJNbOn/W6XheAc3OMjvl0i9pABJ0QykPu9WmSLqGTayIjQLg8k=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:5f48:0:b0:dbd:f6e3:19a with SMTP id
 h8-20020a255f48000000b00dbdf6e3019amr10788ybm.11.1704849339880; Tue, 09 Jan
 2024 17:15:39 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  9 Jan 2024 17:15:31 -0800
In-Reply-To: <20240110011533.503302-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240110011533.503302-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20240110011533.503302-3-seanjc@google.com>
Subject: [PATCH 2/4] KVM: Put mm immediately after async #PF worker completes
 remote gup()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, Xu Yilun <yilun.xu@linux.intel.com>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Put the async #PF worker's reference to the VM's address space as soon as
the worker is done with the mm.  This will allow deferring getting a
reference to the worker itself without having to track whether or not
getting a reference succeeded.

Note, if the vCPU is still alive, there is no danger of the worker getting
stuck with tearing down the host page tables, as userspace also holds a
reference (obviously), i.e. there is no risk of delaying the page-present
notification due to triggering the slow path in mmput().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/async_pf.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
index 876927a558ad..d5dc50318aa6 100644
--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -64,6 +64,7 @@ static void async_pf_execute(struct work_struct *work)
 	get_user_pages_remote(mm, addr, 1, FOLL_WRITE, NULL, &locked);
 	if (locked)
 		mmap_read_unlock(mm);
+	mmput(mm);
 
 	if (IS_ENABLED(CONFIG_KVM_ASYNC_PF_SYNC))
 		kvm_arch_async_page_present(vcpu, apf);
@@ -85,8 +86,6 @@ static void async_pf_execute(struct work_struct *work)
 	trace_kvm_async_pf_completed(addr, cr2_or_gpa);
 
 	__kvm_vcpu_wake_up(vcpu);
-
-	mmput(mm);
 }
 
 static void kvm_flush_and_free_async_pf_work(struct kvm_async_pf *work)
-- 
2.43.0.472.g3155946c3a-goog


