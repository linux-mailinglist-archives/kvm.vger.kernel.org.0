Return-Path: <kvm+bounces-5957-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A8F782918D
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 01:41:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 328B81C2525B
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 00:41:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C9BADDC4;
	Wed, 10 Jan 2024 00:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eKOR2f2l"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60BA0B663
	for <kvm@vger.kernel.org>; Wed, 10 Jan 2024 00:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-daee86e2d70so3305646276.0
        for <kvm@vger.kernel.org>; Tue, 09 Jan 2024 16:39:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704847188; x=1705451988; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=D4tvOVGYXZj07Mh3AbKScJlIRDF+gPUSkrxYwSocJBU=;
        b=eKOR2f2lty8vnakGYTNRzUplaVRRnXqedSIK3sreykitPI9o67BRVaBrxSgFLagtTX
         E7idXtH06VESju55/7pn2PyR9wabHnLKrg5hFMvFSPAUBTkBm0GI+QypdLjs+qCwUrkd
         Tr00OJcLOoRFHnPquwThbMR409+RjGDPa2clm160YkiOxvc3vjm8NNC0mPmNBFOulQpN
         pUunmH8MValLTymY4F4IUS2XDYXCzQ/GV6a4oGQ/P7ko0du8/zY5NfxmxWjypNQDV4Pf
         AxCYZDRc/nO9+8OaCOAOu+L839lOI1VXgGoH5etbh4FrviDVDQGYl4DsLckswoz7/7vG
         Y7hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704847188; x=1705451988;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D4tvOVGYXZj07Mh3AbKScJlIRDF+gPUSkrxYwSocJBU=;
        b=VSZbGCuffn/irNqG1zdpog59gbFVavIqr+hTKg9LAyRfK0sH9nKK7KMDsLRrJaMQfA
         9/h3JYGFeVAGrqz7CIXx/mDLNn2FevJzee9Lc7mkc0KcQJmWvYyXqYMX2N4D3+f2WB+1
         c99HpQw7bPYJuPqtoi5YlwPJPZjd7zFBmX+hlo1jeFacJ4XFn6qgTxC+KslwxedZukiT
         Qb6/JiCsJx0NU7yN5+7Ztc0oyHc+++pJYs69mypyLUMgKugYQTIKicZerVGN3dlXlHFk
         V+YBGR5NYijBB3LohhdAmN8LlmGdXNSrYrkqdt3XrKw/put92GK/0jP8sF0NiF8+VKz1
         LBgw==
X-Gm-Message-State: AOJu0YwG8QaYqqo+9gjA5QcddGJXxs5/i0COgRreQdipT3fCoQzXZtvM
	hpLDqmUp6KU7/dOZ8BGc1rdq/nlsvAqrGUv+fw==
X-Google-Smtp-Source: AGHT+IFuJjrM+MDgoFfdbmi17tmfVjaKhqfjfC+jS0/h9snOExZty5PrssXn0VPV/aGi9MJjghmUZutE7hA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:8749:0:b0:dbe:d426:c456 with SMTP id
 e9-20020a258749000000b00dbed426c456mr6512ybn.4.1704847188423; Tue, 09 Jan
 2024 16:39:48 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  9 Jan 2024 16:39:38 -0800
In-Reply-To: <20240110003938.490206-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240110003938.490206-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20240110003938.490206-5-seanjc@google.com>
Subject: [PATCH 4/4] KVM: Add a comment explaining the directed yield pending
 interrupt logic
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Add a comment to explain why KVM treats vCPUs with pending interrupts as
in-kernel when a vCPU wants to yield to a vCPU that was preempted while
running in kernel mode.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6326852bfb3d..4a9e7513c585 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4089,6 +4089,13 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
 				continue;
 			if (kvm_vcpu_is_blocking(vcpu) && !vcpu_dy_runnable(vcpu))
 				continue;
+
+			/*
+			 * Treat the target vCPU as being in-kernel if it has a
+			 * pending interrupt, as the vCPU trying to yield may
+			 * be spinning waiting on IPI delivery, i.e. the target
+			 * vCPU is in-kernel for the purposes of directed yield.
+			 */
 			if (READ_ONCE(vcpu->preempted) && yield_to_kernel_mode &&
 			    !kvm_arch_dy_has_pending_interrupt(vcpu) &&
 			    !kvm_arch_vcpu_preempted_in_kernel(vcpu))
-- 
2.43.0.472.g3155946c3a-goog


