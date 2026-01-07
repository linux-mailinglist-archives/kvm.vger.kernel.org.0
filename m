Return-Path: <kvm+bounces-67306-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D468D0071B
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 01:03:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AED97301F24D
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 00:02:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D69D014A91;
	Thu,  8 Jan 2026 00:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=aktech.ai header.i=@aktech.ai header.b="gBNLDn1U"
X-Original-To: kvm@vger.kernel.org
Received: from omta40.uswest2.a.cloudfilter.net (omta40.uswest2.a.cloudfilter.net [35.89.44.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E8417D2
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 00:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767830551; cv=none; b=UUb0r5fOibtIsU1jhEXWrfdI6EQmC5+RUd9xEc+kmcQI7O6yiGfdg411TBZWBjMzbAErBeWBGFTeTi+SdqmxcVQDvx82WQXxayE8s+gH6MJdEYvHJPbnCAkPW7rW/pXzxwWGzjgaAGUMivCFRMhb1iOgV4zIa75AY6i/AW81XeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767830551; c=relaxed/simple;
	bh=+w41y8Tz8w9/9/nF3eU1DZysk8XR8ErFcNeDDOt1Lrc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XMarpk/B5LpOJcY3y1Pv0MTnyeiQLmV25fjWEVgkV1NhglCm+hwqHW62HrBOrg9oJxon4L4ELm17zKogPCSIf4hjEcsBgFUxHylRhmxZRS2X1YV650/ToEmR2i6chqNVD0lrB2HOjsTA6CxtvZ9eQEq8nMxHYn41daUtB1vIOJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aktech.ai; spf=pass smtp.mailfrom=aktech.ai; dkim=pass (2048-bit key) header.d=aktech.ai header.i=@aktech.ai header.b=gBNLDn1U; arc=none smtp.client-ip=35.89.44.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aktech.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aktech.ai
Received: from eig-obgw-6005b.ext.cloudfilter.net ([10.0.30.162])
	by cmsmtp with ESMTPS
	id dbYHvlWTJaPqLddSPvYyQm; Thu, 08 Jan 2026 00:00:53 +0000
Received: from gator4203.hostgator.com ([108.167.189.28])
	by cmsmtp with ESMTPS
	id ddSNvW1kwHSQMddSOvboAK; Thu, 08 Jan 2026 00:00:52 +0000
X-Authority-Analysis: v=2.4 cv=GIQIEvNK c=1 sm=1 tr=0 ts=695ef3b4
 a=fpD4kzfX7W8RbeKAuMGPiQ==:117 a=fpD4kzfX7W8RbeKAuMGPiQ==:17
 a=vUbySO9Y5rIA:10 a=HaeQS5oA3WMA:10 a=NEAV23lmAAAA:8 a=BJ0xTQfxP1RxAdNP3ZIA:9
 a=tGAC0SnQRR4URLD-nMig:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=aktech.ai;
	s=default; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=dqJ2Bt1+she4cViQWpGTAkmj5/+WSmqyhIQIHbod5T4=; b=gBNLDn1UmlsfhqGMPGNZkVnKRT
	gStY+FSn7tDuSz1Ej6ysrf17UWaCSVMN1uAUnRsjelUdKAYpGhJ5+GDrkzouDUA6f27tcxNHI23Bm
	i/JuDaxk9yG2LYAyKCF3M+ALZoMhyQgBzHJ3lDeN1LMwqZGSYL2XpxgKAJrsWOFb3eY8IBTcTaaNI
	STwUK3y5D/9SuEXMjCAZiiynJxuMJYuPNATPieullEGRQcF7/EO7SxUyj3ah84aJ1WcUkXvTh6vHU
	BiKjwaS9FCidLeNtz69ydRpR1lSwu42QXW3U8ymlfnHUg+89QgchPhXlP6+mBOKuEdI2D+tqoJe04
	v+YAyFVA==;
Received: from fctnnbsc51w-159-2-155-244.dhcp-dynamic.fibreop.nb.bellaliant.net ([159.2.155.244]:49568 helo=owner-linux.home)
	by gator4203.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.99.1)
	(envelope-from <aidan@aktech.ai>)
	id 1vddSN-00000003d8m-1TYD;
	Wed, 07 Jan 2026 18:00:51 -0600
From: Aidan Khoury <aidan@aktech.ai>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Aidan Khoury <aidan@revers.engineering>,
	Nick Peterson <everdox@gmail.com>,
	Aidan Khoury <aidan@aktech.ai>
Subject: [PATCH v1 0/1] KVM: x86: Merge pending debug causes when vectoring #DB
Date: Wed,  7 Jan 2026 19:57:23 -0400
Message-ID: <20260107235724.28101-1-aidan@aktech.ai>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4203.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - aktech.ai
X-BWhitelist: no
X-Source-IP: 159.2.155.244
X-Source-L: No
X-Exim-ID: 1vddSN-00000003d8m-1TYD
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: fctnnbsc51w-159-2-155-244.dhcp-dynamic.fibreop.nb.bellaliant.net (owner-linux.home) [159.2.155.244]:49568
X-Source-Auth: aidan@aktech.ai
X-Email-Count: 11
X-Org: HG=hgshared;ORG=hostgator;
X-Source-Cap: YWt0ZWNoYWk7YWt0ZWNoYWk7Z2F0b3I0MjAzLmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfB/qcCCFmOq5utWG7NZLxsNKFmFeTh7MkktrIWDBt8qdaGda3RrvD7QRLcaZ6fqKIrE4qNe5p6NtGEcaqxurBLQFxSa2CiYDtMxZWTqB0pGq96vvOccS
 a45dyxaJC16cieYlsj8kd64bKsjhIJZEpLhzmTAdSa9lkaLfp8l1fY9vTe/JxJueWR/6MY0U8dcVZJV8Eu8Nm8z1wydYGZ9yaqU=

This is a single patch that fixes incorrect guest DR6 contents when KVM
vectors #DB on Intel VMX in the presence of deferred debug causes recorded
in VMCS.GUEST_PENDING_DBG_EXCEPTIONS.

See Intel SDM Vol. 3C, 27.3.1.5 Checks on Guest Non-Register State
and Intel SDM Vol. 3C, 27.7.3 Delivery of Pending Debug Exceptions after VM Entry

Intel VMX defers certain debug exception causes in the VMCS field
GUEST_PENDING_DBG_EXCEPTIONS (B0-B3, enabled breakpoint, BS, RTM). This
state is used when debug exceptions are suppressed due to interrupt
shadow (e.g. MOV SS/POP SS or STI), and the deferred causes are later
combined with other debug reasons when #DB is ultimately delivered.

KVM may vector an in-kernel #DB after a VM-exit and/or instruction
emulation. A concrete example is a guest that:

  - programs a data breakpoint (B0) on an operand used by MOV SS
  - enables single-step (RFLAGS.TF)
  - executes MOV SS (data breakpoint triggers, #DB is suppressed)
  - executes an instruction that VM-exits and is emulated (e.g. CPUID),
    or executes ICEBP/INT1 which is intercepted as #DB

On bare metal, guest DR6 reports the combined reasons (e.g. BS+B0). In
KVM/VMX, the deferred breakpoint cause is recorded in
GUEST_PENDING_DBG_EXCEPTIONS while KVM generates a #DB for single-step,
but the queued #DB payload delivered to guest DR6 can omit the pending
causes. This results in guest DR6 missing B0-B3 even though the CPU
would report them.

Fix this by merging pending causes from GUEST_PENDING_DBG_EXCEPTIONS into
the #DB payload when delivering the exception payload to guest state.
The merge is performed in kvm_deliver_exception_payload() so it applies
to both the normal injection path and the !guest_mode path where the
payload may be consumed immediately by kvm_multiple_exception().

To keep x86 core code vendor-agnostic, add an optional x86 op
get_pending_dbg_exceptions() that returns the relevant pending-debug
bits for the active vendor. VMX implements the hook by reading
VMCS.GUEST_PENDING_DBG_EXCEPTIONS and masking to architecturally defined
bits; other vendors return 0.

After this change, guests observe all accumulated #DB causes in DR6 when
#DB is vectored, matching bare-metal behavior.

Tested on Intel host with KVM/VMX enabled by running the tiny repro asm below
inside a Windows guest. On bare metal, DR6 reports both BS and B0. Under KVM/VMX
without this patch, DR6 may report BS but miss B0.

A minimal reproducer in the guest:
  - use ptrace (or veh+SetThreadContext on windows) for handling #DB traps and managing DRs
  - Prime DR0 and DR7 to a memory operand used by MOV SS (data breakpoint, enabled)
  - execute MOV SS from that memory operand (breakpoint met, delivery suppressed)
  - execute CPUID (emulated) or ICEBP/INT1 (intercepted)
  - In the #DB handler, read DR6 to observe the reported causes

```
__asm__ __volatile__(
	"pushq %%rbx\n"
	"pushfq\n"
	"orl $0x100, (%%rsp)\n"    /* set TF in saved RFLAGS on stack */
	"popfq\n"
	"movw (%0), %%ss\n"        /* load SS from probe page */
	"cpuid\n"                  /* trigger intercepting instruction (cpuid in this case) */
	"popq %%rbx\n"             /* #DB fires here with DR6 missing B0 under KVM/VMX pre-patch */
	: : "r"(&ss_probe) : "rax", "rcx", "rdx", "memory"
);
```

Reproducer PoC: https://github.com/ajkhoury/kvm-guest-anomalies

Aidan Khoury (1):
  KVM: x86: Merge pending debug causes when vectoring #DB

 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/kvm/vmx/main.c            |  9 +++++++++
 arch/x86/kvm/vmx/vmx.c             | 16 +++++++++++-----
 arch/x86/kvm/vmx/x86_ops.h         |  1 +
 arch/x86/kvm/x86.c                 | 12 ++++++++++++
 6 files changed, 35 insertions(+), 5 deletions(-)

-- 
2.43.0


