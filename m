Return-Path: <kvm+bounces-69830-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6JscBU12gGkV8gIAu9opvQ
	(envelope-from <kvm+bounces-69830-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 11:02:53 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BB30BCA67D
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 11:02:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E188830292F1
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 10:02:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63F38356A27;
	Mon,  2 Feb 2026 10:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sony.com header.i=@sony.com header.b="HO7tl8SE"
X-Original-To: kvm@vger.kernel.org
Received: from jpms-ob02.noc.sony.co.jp (jpms-ob02.noc.sony.co.jp [211.125.140.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD6C2DF126;
	Mon,  2 Feb 2026 10:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.125.140.165
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770026512; cv=none; b=leoBVVay869V4Tmp7bMOSUjOUU+dStHFRoUgOdCUVsKJtrWOBGXOnGys5v0Vb9n0GpMrJNWiPHsreQgE3WPAn3PpqTEOOovTzwBnx2FY0iard9LZSlBqlhCPUaMoqf0aEAl4jVkNjm8yAMYGjjQPa4rCmO52QZ9nDUNm2KgoiI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770026512; c=relaxed/simple;
	bh=paULGXp6rwtbR4pGaBXqE9RYtLD7iRkEUs2lKCF5e4o=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=O+M7iXyB6Gt6w86xs5uk9UsO/9fo0pANAutZPbulEy4FtYnzyP0MXFICpqL7Vkbn61qf2r8uhJe0afxAs0gHLE6ORlu3hIpQZEwam2ApTc21Mrse/iRgKmfjyxZgd1A1qYLwwclyuthmN7pB+JZdOzrvw0Q1jndZtIvF2bDmpsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sony.com; spf=pass smtp.mailfrom=sony.com; dkim=pass (2048-bit key) header.d=sony.com header.i=@sony.com header.b=HO7tl8SE; arc=none smtp.client-ip=211.125.140.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sony.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sony.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=sony.com; s=s1jp; t=1770026511; x=1801562511;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=4/LXZGnNgY5t+nsrdXbfktyTBcde00tw0WwNVU5EQeQ=;
  b=HO7tl8SE03PUd0XlIchjhbyh7kJ0qcxLeKAO2qfntj28WoYLPk15KRUM
   enJd7STKWW1tmlplX7Glue6aUTu5vI2jii5OgVej/MF/8wK4wdSZ1IX03
   etdBsXzrpYZKbjC5xSMmaGua2hL1+oF0NR58a3YgvdNVsXv2C38xrKnbu
   cJnIIR2PZuhsnSC1RPBcKVPAW8p++rvb8jmug7B9dlYdVoquzVwAdo7oq
   9fVIAtEm+l17mIRb4KfGK+TFy795PToniMxYZsvqMuO2Egi4xo+uIhVf5
   y1WnL4KmuD7fmspl682xeU21RIKAqU2u9WqNLfCbhxkryK7cyvVJUR/mA
   w==;
Received: from unknown (HELO jpmta-ob1.noc.sony.co.jp) ([IPv6:2001:cf8:0:6e7::6])
  by jpms-ob02.noc.sony.co.jp with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2026 18:51:38 +0900
X-IronPort-AV: E=Sophos;i="6.21,268,1763391600"; 
   d="scan'208";a="607384935"
Received: from unknown (HELO [127.0.1.1]) ([IPv6:2001:cf8:1:573:0:dddd:6b3e:119e])
  by jpmta-ob1.noc.sony.co.jp with ESMTP; 02 Feb 2026 18:51:38 +0900
From: Shashank Balaji <shashank.mahadasyam@sony.com>
Date: Mon, 02 Feb 2026 18:51:02 +0900
Subject: [PATCH 1/3] x86/x2apic: disable x2apic on resume if the kernel
 expects so
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260202-x2apic-fix-v1-1-71c8f488a88b@sony.com>
References: <20260202-x2apic-fix-v1-0-71c8f488a88b@sony.com>
In-Reply-To: <20260202-x2apic-fix-v1-0-71c8f488a88b@sony.com>
To: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Suresh Siddha <suresh.b.siddha@intel.com>, 
 "K. Y. Srinivasan" <kys@microsoft.com>, 
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
 Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, 
 Ajay Kaher <ajay.kaher@broadcom.com>, 
 Alexey Makhalov <alexey.makhalov@broadcom.com>, 
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
 Jan Kiszka <jan.kiszka@siemens.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Vitaly Kuznetsov <vkuznets@redhat.com>, Juergen Gross <jgross@suse.com>, 
 Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org, 
 linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev, 
 jailhouse-dev@googlegroups.com, kvm@vger.kernel.org, 
 xen-devel@lists.xenproject.org, Rahul Bukte <rahul.bukte@sony.com>, 
 Shashank Balaji <shashank.mahadasyam@sony.com>, 
 Daniel Palmer <daniel.palmer@sony.com>, Tim Bird <tim.bird@sony.com>, 
 stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1476;
 i=shashank.mahadasyam@sony.com; h=from:subject:message-id;
 bh=paULGXp6rwtbR4pGaBXqE9RYtLD7iRkEUs2lKCF5e4o=;
 b=owGbwMvMwCU2bX1+URVTXyjjabUkhsyG4hUGCzw4VzFOfPGnVC7+kcNGzhiLW3NYOT9WyZ0Rv
 y9psSK2o5SFQYyLQVZMkaVUqfrX3hVBS3rOvFaEmcPKBDKEgYtTACaytoXhv9Nrfese5QfJMkqT
 Qxp2Whn+q/TjDzf7xqHB/8O9W3/eVob/iW1Xy2aecbmXM6u73+ju1V8pak2+7/wsF/ZYNW4wOtz
 NCwA=
X-Developer-Key: i=shashank.mahadasyam@sony.com; a=openpgp;
 fpr=75227BFABDA852A48CCCEB2196AF6F727A028E55
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[sony.com,none];
	R_DKIM_ALLOW(-0.20)[sony.com:s=s1jp];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[32];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[shashank.mahadasyam@sony.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69830-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[sony.com:+]
X-Rspamd-Queue-Id: BB30BCA67D
X-Rspamd-Action: no action

In lapic_resume, ensure x2apic is actually disabled when the kernel expects it
to be disabled, i.e. when x2apic_mode = 0.

x2apic_mode is set to 0 and x2apic is disabled on boot if the kernel doesn't
support irq remapping or for other reasons. On resume from s2ram
(/sys/power/mem_sleep = deep), firmware can re-enable x2apic, but the kernel
continues using the xapic interface because it didn't check to see if someone
enabled x2apic behind its back, which causes hangs. This situation happens on
defconfig + bare metal + s2ram, on which this fix has been tested.

Fixes: 6e1cb38a2aef ("x64, x2apic/intr-remap: add x2apic support, including enabling interrupt-remapping")
Cc: stable@vger.kernel.org
Co-developed-by: Rahul Bukte <rahul.bukte@sony.com>
Signed-off-by: Rahul Bukte <rahul.bukte@sony.com>
Signed-off-by: Shashank Balaji <shashank.mahadasyam@sony.com>
---
 arch/x86/kernel/apic/apic.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index d93f87f29d03..cc64d61f82cf 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -2456,6 +2456,12 @@ static void lapic_resume(void *data)
 	if (x2apic_mode) {
 		__x2apic_enable();
 	} else {
+		/*
+		 * x2apic may have been re-enabled by the
+		 * firmware on resuming from s2ram
+		 */
+		__x2apic_disable();
+
 		/*
 		 * Make sure the APICBASE points to the right address
 		 *

-- 
2.43.0


