Return-Path: <kvm+bounces-69019-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uPSlICPzc2ny0AAAu9opvQ
	(envelope-from <kvm+bounces-69019-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 23:16:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BFFE7B113
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 23:16:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C7689302172F
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 22:15:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DAC62D0C8F;
	Fri, 23 Jan 2026 22:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="w1fQTLTj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F6821ABC1
	for <kvm@vger.kernel.org>; Fri, 23 Jan 2026 22:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769206546; cv=none; b=uG4w09/Re/P819cKVeQGuArMyLmtstyznY7Qil+/d/ByHieI3Jbc5K4iCCVXP0J9M+PrDUoJ/82FoXYUMC2p1CY2R2QRok8/3J/jsqNeW92DD71FPyotu819XvqaH9j0JufgZgxW5jS9t4biOSPyevUpVHhedcgCYM0CCYFeBow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769206546; c=relaxed/simple;
	bh=mME44fj5sKRvocaLJiXWIy8v/tVDcJq4u+E+ifHxorU=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Dgnlt8HHThSocu4ebs36FY23ToNhuSNT5byF4s/SvMK1Csea/mxkWaTSdlD82e7X4xFUprv2nDcLQmAqdG70Umt8cD5e2Kbabtg7ELClxf91VvkKkBoJCCFWF1Zs3tkARh09arplyQnbanlSftVk72hnH+rPhWQ3mUGeJW+MvGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=w1fQTLTj; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c63597a63a6so846394a12.3
        for <kvm@vger.kernel.org>; Fri, 23 Jan 2026 14:15:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769206544; x=1769811344; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5YUi5HBifyma3b53VcD8N5rMKKrP+86iMqVIaX6eOVo=;
        b=w1fQTLTj4ZCbdwuZZFbSpzsI5ESV/qNHeXwHNlwgkdzRMWI0joA7jMfmL+5InF+vOl
         Joc4aZchapFBL/SJZjhtN51q+4KsgsrVrSidpbf0u7t0RLjok5Ire/DDnIhHWPJ5tcl6
         ibs+8S64LsGRs3uRnsGRQlJ3fmB1dwGcM0E9l4ysuNTM/n0LZEwqeIhiKfbgrtyo4CWg
         6PQ2XbDpkfJp+t6UX2mI8ueX3D+z6g2nbvRg63BYUhpIH4pr4ML1Hw4rrb3fAPpykgb6
         tkOnRzl310/syAeBkkuUcgzdq89m6yfZ1SjFv03azDVbfvNx6YvbDd4mP0UOT0bZWWUL
         I2mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769206544; x=1769811344;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5YUi5HBifyma3b53VcD8N5rMKKrP+86iMqVIaX6eOVo=;
        b=Ezqkk8mTPKthmxDmTEVA5Ud/t2bz+NSaD9cu1hXtK0h0zuUQtnPGzwvi+YP6/bIzxO
         yfM0cwt3px7n1hStRqvdR9/Zp/0mBWCWkN4Uqk+GZtKGHPBw+ZzdY+T4qPB/Np/qDRMk
         jsAjYYBdHBWaLVPm/zyM0doMr155mi3oMkJYZD624CyDRLTbh+6ITMynVBRLscpwnH8B
         TBpYELcXZ3cIvWFeipeOXwKecZgN6hrnxvWr/udTalzZpPD1KPtqrKdnGhxZpv9iYr9v
         ClrD3LXXfcCaOEV6McT/Ar6BnrdjnRING+1cRdYGX2ZIecpyCGwWd/rng0SWr/tzdXEV
         nk/w==
X-Gm-Message-State: AOJu0Yw7U/XtmKraAsQYYj7CxPHmibHQho+eMX0PTZc1HNrmyrct9l6g
	zRQ9G4V3b1c94LtNCdn2c+4CyhF2vxSoSR5OsMYl0cN8IOZMFFqCrZHhGVBCrdAZyk93K9+Vp5E
	mDT/W5Q==
X-Received: from pgbfe1.prod.google.com ([2002:a05:6a02:2881:b0:c0e:3bf6:b8e2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7489:b0:387:9522:b667
 with SMTP id adf61e73a8af0-38e6f828589mr4873706637.78.1769206544521; Fri, 23
 Jan 2026 14:15:44 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 23 Jan 2026 14:15:39 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260123221542.2498217-1-seanjc@google.com>
Subject: [PATCH 0/3] KVM: x86: CET vs. nVMX fix and hardening
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69019-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_SEVEN(0.00)[11];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 3BFFE7B113
X-Rspamd-Action: no action

Fix a bug where KVM will clear IBT and SHSTK bits after nested VMX MSRs
have been configured, e.g. if the kernel is built with CONFIG_X86_CET=y
but CONFIG_X86_KERNEL_IBT=n.  The late clearing results in kvm-intel.ko
refusing to load as the CPU compatible checks generate their VMCS configs
with IBT=n and SHSTK=n, ultimately causing a mismatch on the CET entry
and exit controls.

Patch 2 hardens against similar bugs in the future by added a flag and
WARNs to yell if KVM sets or clear feature flags outside of the dedicated
flow.

Patch 3 adds (very, very) long overdue printing of the mistmatching offsets
in the VMCS configs.

Sean Christopherson (3):
  KVM: x86: Finalize kvm_cpu_caps setup from {svm,vmx}_set_cpu_caps()
  KVM: x86: Harden against unexpected adjustments to kvm_cpu_caps
  KVM: VMX: Print out "bad" offsets+value on VMCS config mismatch

 arch/x86/kvm/cpuid.c   | 29 +++++++++++++++++++++++++++--
 arch/x86/kvm/cpuid.h   |  7 ++++++-
 arch/x86/kvm/svm/svm.c |  4 +++-
 arch/x86/kvm/vmx/vmx.c | 20 ++++++++++++++++++--
 arch/x86/kvm/x86.c     | 14 --------------
 arch/x86/kvm/x86.h     |  2 ++
 6 files changed, 56 insertions(+), 20 deletions(-)


base-commit: e81f7c908e1664233974b9f20beead78cde6343a
-- 
2.52.0.457.g6b5491de43-goog


