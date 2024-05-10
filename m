Return-Path: <kvm+bounces-17158-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4ABC08C20DA
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 11:25:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7BFDF1C215DD
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 09:25:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFC7716132E;
	Fri, 10 May 2024 09:24:53 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B0D14E2D5;
	Fri, 10 May 2024 09:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715333093; cv=none; b=tYi6nAapk9OAcmEO7F2nqn4Gdb9B7bhf75dqv1xlKn9ENmtWHz1SC+R/Yx9yNl7c9KiHx8Fj0Axq7lSkIUx10jvIIuW7gmKGSWwhpWNw6Er3jrFOK+gYLMWcCXOaD2OuEzDGeznHYuTtyJJMXP6K2YGeKDpKc2c4fO3XsxWhG64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715333093; c=relaxed/simple;
	bh=IPPPpjykbtN9x08ZRo+eTV5my0h+MJzXLIVtb+chsEo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dvd1Ly4A3lWFgK/DFLgNYx9CXQF3LaXImzWNu4OGQAx5wbpVNglg9U7qHvR0Cl5XAPEMutkH+t7VPndNNb/fJyun/EI7rmcq2l0FyLaXSRQJHlii443lLZ3quzrqf9SXE3btKQeUKVx1ORo1HsdSOHn65A7tjZ2RWcQGlG/+iOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a599eedc8eeso464568366b.1;
        Fri, 10 May 2024 02:24:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715333090; x=1715937890;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZDbpDRkbSbko8yRciJ3Il22WfPCRLNyZHa1ErroF7aI=;
        b=rR2NTcIi3OUK4c77Op/a13/Qqnv5DXtdufW+YJ/kFtM28k32hfuvung7/Zu5pgS1E+
         dK5ycm+V2Oda2qkHb3duTY9VoD5L8pdCEd46k9mV+FRs4HvlnmLFUxfLknNiWC/XG6Ge
         LWzTlNmdex/bBw9zZIK2b5TDwolglNxYXAc9uR4k1OgwDd7gK788Azc3UYq6HU6EzS21
         3QxCZG4y2Orao3fphnvg90tvTcxiXu1pmhwBT+nUqaddiwOB3LstSRkC2vHsxQUKxPwV
         483cW9qmnTy2wU+DnY0x43W41AtAe2mhReTCgabnO/T4d3p5VLOogtwT3OXvk6X6aGEc
         k1LA==
X-Forwarded-Encrypted: i=1; AJvYcCWomWV25Sk0Ew4EFmrH/ZrMiftAJqnqQedZfC7Ih0maBp32j5XANPaHx8SjaPkNFKEYV9joQA+9+5r6SadJKBegr5oRBYayzf/RGOVvIwNWNOEa1Yd/6BuP9bYfdH2nnZI8dnZyFhTfBFklam+vN9vFnZp5D3gB90Nr
X-Gm-Message-State: AOJu0YyEE1FZm8ePR55Q6xXDX4ErUPL0NX0GJ5hrU+v/pAWu/t2tfKGc
	WNr8WgmoPZTpuwaQvw8cF7U4SuhusGCXOAn8lATBACdah/bMj1pf
X-Google-Smtp-Source: AGHT+IEc/PKfiUJKg1onag1vG+4wLXesYxjoHUri/YIGdHynkSyqSG7ThqKpga0fHxFOKLxBxdaRIQ==
X-Received: by 2002:a17:906:3618:b0:a59:9c14:a774 with SMTP id a640c23a62f3a-a5a2d680d90mr136109666b.74.1715333089780;
        Fri, 10 May 2024 02:24:49 -0700 (PDT)
Received: from localhost (fwdproxy-lla-009.fbsv.net. [2a03:2880:30ff:9::face:b00c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a5a17b17f37sm162865666b.224.2024.05.10.02.24.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 May 2024 02:24:49 -0700 (PDT)
From: Breno Leitao <leitao@debian.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Rik van Riel <riel@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Avi Kivity <avi@redhat.com>
Cc: rbc@meta.com,
	paulmck@kernel.org,
	stable@vger.kernel.org,
	kvm@vger.kernel.org (open list:KERNEL VIRTUAL MACHINE (KVM)),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2] KVM: Fix a data race on last_boosted_vcpu in kvm_vcpu_on_spin()
Date: Fri, 10 May 2024 02:23:52 -0700
Message-ID: <20240510092353.2261824-1-leitao@debian.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use {READ,WRITE}_ONCE() to access kvm->last_boosted_vcpu to ensure the
loads and stores are atomic.  In the extremely unlikely scenario the
compiler tears the stores, it's theoretically possible for KVM to attempt
to get a vCPU using an out-of-bounds index, e.g. if the write is split
into multiple 8-bit stores, and is paired with a 32-bit load on a VM with
257 vCPUs:

  CPU0                              CPU1
  last_boosted_vcpu = 0xff;

                                    (last_boosted_vcpu = 0x100)
                                    last_boosted_vcpu[15:8] = 0x01;
  i = (last_boosted_vcpu = 0x1ff)
                                    last_boosted_vcpu[7:0] = 0x00;

  vcpu = kvm->vcpu_array[0x1ff];

As detected by KCSAN:

  BUG: KCSAN: data-race in kvm_vcpu_on_spin [kvm] / kvm_vcpu_on_spin [kvm]

  write to 0xffffc90025a92344 of 4 bytes by task 4340 on cpu 16:
  kvm_vcpu_on_spin (arch/x86/kvm/../../../virt/kvm/kvm_main.c:4112) kvm
  handle_pause (arch/x86/kvm/vmx/vmx.c:5929) kvm_intel
  vmx_handle_exit (arch/x86/kvm/vmx/vmx.c:?
		 arch/x86/kvm/vmx/vmx.c:6606) kvm_intel
  vcpu_run (arch/x86/kvm/x86.c:11107 arch/x86/kvm/x86.c:11211) kvm
  kvm_arch_vcpu_ioctl_run (arch/x86/kvm/x86.c:?) kvm
  kvm_vcpu_ioctl (arch/x86/kvm/../../../virt/kvm/kvm_main.c:?) kvm
  __se_sys_ioctl (fs/ioctl.c:52 fs/ioctl.c:904 fs/ioctl.c:890)
  __x64_sys_ioctl (fs/ioctl.c:890)
  x64_sys_call (arch/x86/entry/syscall_64.c:33)
  do_syscall_64 (arch/x86/entry/common.c:?)
  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)

  read to 0xffffc90025a92344 of 4 bytes by task 4342 on cpu 4:
  kvm_vcpu_on_spin (arch/x86/kvm/../../../virt/kvm/kvm_main.c:4069) kvm
  handle_pause (arch/x86/kvm/vmx/vmx.c:5929) kvm_intel
  vmx_handle_exit (arch/x86/kvm/vmx/vmx.c:?
			arch/x86/kvm/vmx/vmx.c:6606) kvm_intel
  vcpu_run (arch/x86/kvm/x86.c:11107 arch/x86/kvm/x86.c:11211) kvm
  kvm_arch_vcpu_ioctl_run (arch/x86/kvm/x86.c:?) kvm
  kvm_vcpu_ioctl (arch/x86/kvm/../../../virt/kvm/kvm_main.c:?) kvm
  __se_sys_ioctl (fs/ioctl.c:52 fs/ioctl.c:904 fs/ioctl.c:890)
  __x64_sys_ioctl (fs/ioctl.c:890)
  x64_sys_call (arch/x86/entry/syscall_64.c:33)
  do_syscall_64 (arch/x86/entry/common.c:?)
  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)

  value changed: 0x00000012 -> 0x00000000

Fixes: 217ece6129f2 ("KVM: use yield_to instead of sleep in kvm_vcpu_on_spin")
Cc: stable@vger.kernel.org
Signed-off-by: Breno Leitao <leitao@debian.org>
---
Changelog:
v2: 
	* Reworded the git commit as suggested by Sean
	* Dropped the me->kvm->last_boosted_vcpu in favor of
	  kvm->last_boosted_vcpu as suggested by Sean
v1:
	* https://lore.kernel.org/all/20240509090146.146153-1-leitao@debian.org/

---
 virt/kvm/kvm_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ff0a20565f90..d9ce063c76f9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4066,12 +4066,13 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
 {
 	struct kvm *kvm = me->kvm;
 	struct kvm_vcpu *vcpu;
-	int last_boosted_vcpu = me->kvm->last_boosted_vcpu;
+	int last_boosted_vcpu;
 	unsigned long i;
 	int yielded = 0;
 	int try = 3;
 	int pass;
 
+	last_boosted_vcpu = READ_ONCE(kvm->last_boosted_vcpu);
 	kvm_vcpu_set_in_spin_loop(me, true);
 	/*
 	 * We boost the priority of a VCPU that is runnable but not
@@ -4109,7 +4110,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
 
 			yielded = kvm_vcpu_yield_to(vcpu);
 			if (yielded > 0) {
-				kvm->last_boosted_vcpu = i;
+				WRITE_ONCE(kvm->last_boosted_vcpu, i);
 				break;
 			} else if (yielded < 0) {
 				try--;
-- 
2.43.0


