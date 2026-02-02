Return-Path: <kvm+bounces-69831-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MFcnJH52gGkV8gIAu9opvQ
	(envelope-from <kvm+bounces-69831-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 11:03:42 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C130CA6B1
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 11:03:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 86EB0301B17A
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 10:02:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CDC6357A20;
	Mon,  2 Feb 2026 10:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sony.com header.i=@sony.com header.b="qOdoSOrZ"
X-Original-To: kvm@vger.kernel.org
Received: from jpms-ob02.noc.sony.co.jp (jpms-ob02.noc.sony.co.jp [211.125.140.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B522E7199;
	Mon,  2 Feb 2026 10:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.125.140.165
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770026513; cv=none; b=kJPKHnt37Z7PC8gZpMH2XFGkFOycPHbVb0yScoaD7EJYlt9NiHZazounyIb6khUA/S+k6HfunaN3qpBG98hx2GVqmzVaIgp8tBUwmMIQGAms2mIXdGjisQ/zVkPkERxZ+HNlSvWkE/9gfCJ9zL63YKLHLgEHWLdkBGc+uX775PY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770026513; c=relaxed/simple;
	bh=WGBqeRf3m3q38dcFfIzoZC7KITAdIHJXG+fCWgOOD40=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=h4ijp6qKuLmIuT85QqfFjk4v9LAt5lALXCzRN+733XoQ4kTTaVwiEzvDWFJzXpdtQQYZkrghYRuFE+7LDDMoYyyCfp5vxqpRKEomey8KwBD3vkEa9Nsfu2OOFvsAqS+UOv1hZF3nhJOTR8c2XnQP2zXnhxxRqlXQ2R4Aq9xsj9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sony.com; spf=pass smtp.mailfrom=sony.com; dkim=pass (2048-bit key) header.d=sony.com header.i=@sony.com header.b=qOdoSOrZ; arc=none smtp.client-ip=211.125.140.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sony.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sony.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=sony.com; s=s1jp; t=1770026512; x=1801562512;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=GI9OPx+uxZW/9+u+5es0pePWKf46Zy6n4IWktANHhfk=;
  b=qOdoSOrZXi0wHLZUVdrfEx7GyMo+iJPNHQqr5O4EzrT7O6VgiS0gk8Eh
   TCZg32QOE/eYnYQsBjaEUbZXYlmN95Q1tkZM5qGVpU0hPENCRcFDhhDSx
   1eqxkA8y6a7vnfpNUT3sxiofcWWsLTB8NBp2ibdWZhfDNlPyq9JOW0V5Y
   Y9hcVlgS5Pj+nGfxWSE4VEtUeEAvZVpbiLMaQNMzZmB++aa9tMHrQQQgy
   ADLC4oakxDcRrPQFXgfZB/ZDqIH9CAi4AB8NFqFDOr+15mpAIFSBa3NXo
   JKldfkPfJqsO/kwE4Y8jtrh5Lwvcv4t0RIkG8IsSWWulAxZx7mfzilMIQ
   Q==;
Received: from unknown (HELO jpmta-ob1.noc.sony.co.jp) ([IPv6:2001:cf8:0:6e7::6])
  by jpms-ob02.noc.sony.co.jp with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2026 18:51:38 +0900
X-IronPort-AV: E=Sophos;i="6.21,268,1763391600"; 
   d="scan'208";a="607384937"
Received: from unknown (HELO [127.0.1.1]) ([IPv6:2001:cf8:1:573:0:dddd:6b3e:119e])
  by jpmta-ob1.noc.sony.co.jp with ESMTP; 02 Feb 2026 18:51:38 +0900
From: Shashank Balaji <shashank.mahadasyam@sony.com>
Date: Mon, 02 Feb 2026 18:51:03 +0900
Subject: [PATCH 2/3] x86/defconfig: add CONFIG_IRQ_REMAP
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260202-x2apic-fix-v1-2-71c8f488a88b@sony.com>
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
 Daniel Palmer <daniel.palmer@sony.com>, Tim Bird <tim.bird@sony.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=897;
 i=shashank.mahadasyam@sony.com; h=from:subject:message-id;
 bh=WGBqeRf3m3q38dcFfIzoZC7KITAdIHJXG+fCWgOOD40=;
 b=owGbwMvMwCU2bX1+URVTXyjjabUkhsyG4hWJ5ZPesy10dLqdVPT13NLfdzYoem+Z+6FTrppr+
 3YRUxvJjlIWBjEuBlkxRZZSpepfe1cELek581oRZg4rE8gQBi5OAZiI71yG/3G5dneW7G7keJnx
 4Wd+z+9zOUtZjcKVjm+qm6rqVBCX9Jnhf+n3kx2OkYsNn+1Qe6/XFrn9pXSWzssdU98b3/BZ2S2
 XyAQA
X-Developer-Key: i=shashank.mahadasyam@sony.com; a=openpgp;
 fpr=75227BFABDA852A48CCCEB2196AF6F727A028E55
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[sony.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[sony.com:s=s1jp];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[31];
	TAGGED_FROM(0.00)[bounces-69831-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[sony.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[shashank.mahadasyam@sony.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sony.com:email,sony.com:dkim,sony.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 0C130CA6B1
X-Rspamd-Action: no action

Interrupt remapping is an architectural dependency of x2apic, which is already
enabled in the defconfig. Enable CONFIG_IRQ_REMAP so that a defconfig kernel on
bare metal actually uses x2apic.

Co-developed-by: Rahul Bukte <rahul.bukte@sony.com>
Signed-off-by: Rahul Bukte <rahul.bukte@sony.com>
Signed-off-by: Shashank Balaji <shashank.mahadasyam@sony.com>
---
 arch/x86/configs/x86_64_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/configs/x86_64_defconfig b/arch/x86/configs/x86_64_defconfig
index 7d7310cdf8b0..269f7d808be4 100644
--- a/arch/x86/configs/x86_64_defconfig
+++ b/arch/x86/configs/x86_64_defconfig
@@ -230,6 +230,7 @@ CONFIG_EEEPC_LAPTOP=y
 CONFIG_AMD_IOMMU=y
 CONFIG_INTEL_IOMMU=y
 # CONFIG_INTEL_IOMMU_DEFAULT_ON is not set
+CONFIG_IRQ_REMAP=y
 CONFIG_EXT4_FS=y
 CONFIG_EXT4_FS_POSIX_ACL=y
 CONFIG_EXT4_FS_SECURITY=y

-- 
2.43.0


