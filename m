Return-Path: <kvm+bounces-69829-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KO5WLil2gGkV8gIAu9opvQ
	(envelope-from <kvm+bounces-69829-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 11:02:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2663BCA649
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 11:02:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7BC5E301CC58
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 10:01:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D63212DAFAA;
	Mon,  2 Feb 2026 10:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sony.com header.i=@sony.com header.b="WthYmqm1"
X-Original-To: kvm@vger.kernel.org
Received: from jpms-ob02.noc.sony.co.jp (jpms-ob02.noc.sony.co.jp [211.125.140.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF8913DDA4;
	Mon,  2 Feb 2026 10:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.125.140.165
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770026511; cv=none; b=fxAYiT+igBKWcTpLh+k37x3AHMx9NJS4l4HXFfhTys9gbDmDfMFFDf8/7MOGvg2E9Yrfh2OlBGd7ENOCOT/ABP4yxOtLiUiM8WQ4XzUSXnxWhgcVXtBUiulKA6qYA82oK30l9mp6hb2No5B+J/Q8RINhz6iy7q0rStMDkxiw2Vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770026511; c=relaxed/simple;
	bh=rciqWe9MknIhKucUK+4wbzClj9FvwHeXsn6kPpt+wM8=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=CjEol7uscSrBu/Fn883/DfSD2IVkr0LfT1A4bygIAFgwkeJHQAeMORCjqFEpWsZkxoWTAC6g39C4E5/ucpWB9GFZIf+LDn/mAlhhekC/6Pyhb3iiWTmvV4maMB5fSGqAD/0Pnb8VWyOfhUQ78aSEKTWQ0dpOQJ2zzFOdevrwvYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sony.com; spf=pass smtp.mailfrom=sony.com; dkim=pass (2048-bit key) header.d=sony.com header.i=@sony.com header.b=WthYmqm1; arc=none smtp.client-ip=211.125.140.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sony.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sony.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=sony.com; s=s1jp; t=1770026509; x=1801562509;
  h=from:subject:date:message-id:mime-version:
   content-transfer-encoding:to:cc;
  bh=9aqqCS44lWCHB49Zm7J55r5rkQXnOnuoUWB3fHL0bvM=;
  b=WthYmqm18NcKRaulODHiMrXwGk3KNmOKbApGsp+aHd/mAzUUanpb2H8a
   yMcqfdsJlcTu5MnszvUuh0csC3XBtbZEp5j4anZFRIKP4Lc/EMRScPGaO
   3/0Y+DplUVZrK9huDVcZKw5TyrpyjIC4nGeE2vM2hGV6kK+oHqImMJVYa
   zyNVPmTUbQ8DOKlzU+GuOAgBJ7tOc2xODkLD/NgZL5E7MH9DRQe0aKoTK
   ec1JfmUVIV+qix/aM3Nud5bihiFYlwJ4JGLPh54wapM/hieiCKfCsIgQl
   Cmp8WGKnIceiUNEljFyW1t0VabUqnn1ug0P1l40vuGqcFYjAESoh+Ypbd
   A==;
Received: from unknown (HELO jpmta-ob1.noc.sony.co.jp) ([IPv6:2001:cf8:0:6e7::6])
  by jpms-ob02.noc.sony.co.jp with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2026 18:51:38 +0900
X-IronPort-AV: E=Sophos;i="6.21,268,1763391600"; 
   d="scan'208";a="607384933"
Received: from unknown (HELO [127.0.1.1]) ([IPv6:2001:cf8:1:573:0:dddd:6b3e:119e])
  by jpmta-ob1.noc.sony.co.jp with ESMTP; 02 Feb 2026 18:51:37 +0900
From: Shashank Balaji <shashank.mahadasyam@sony.com>
Subject: [PATCH 0/3] x86/x2apic: Fix hang-up of defconfig kernel on resume
 from s2ram
Date: Mon, 02 Feb 2026 18:51:01 +0900
Message-Id: <20260202-x2apic-fix-v1-0-71c8f488a88b@sony.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAIZzgGkC/x2MQQqAIBAAvyJ7TlDBsL4SHXTbai8mCiGIf086z
 sBMg0KZqcAqGmR6ufATB+hJAN4+XiT5GAxGmVkZpWU1PjHKk6t0Fh3qYDEsCkaQMg39z7a99w8
 R+TM4XAAAAA==
X-Change-ID: 20260201-x2apic-fix-85c8c1b5cb90
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2357;
 i=shashank.mahadasyam@sony.com; h=from:subject:message-id;
 bh=rciqWe9MknIhKucUK+4wbzClj9FvwHeXsn6kPpt+wM8=;
 b=owGbwMvMwCU2bX1+URVTXyjjabUkhsyG4hXbtvp/s2L/pXvGSPVq9wtGQUU/0+sZWw9OOKhfs
 jfkl8CHjlIWBjEuBlkxRZZSpepfe1cELek581oRZg4rE8gQBi5OAZhIlhTD/8DScGFBO6NF8ydO
 ftFcVXsmfwpX6p0FupNYLebce84rq8zI0Cddbi5zcoJG8MkZzSbn5D/+eMqwb04Pw8ycnOdp7hW
 XuQA=
X-Developer-Key: i=shashank.mahadasyam@sony.com; a=openpgp;
 fpr=75227BFABDA852A48CCCEB2196AF6F727A028E55
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[sony.com,none];
	R_DKIM_ALLOW(-0.20)[sony.com:s=s1jp];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[32];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[shashank.mahadasyam@sony.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_FROM(0.00)[bounces-69829-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[sony.com:+]
X-Rspamd-Queue-Id: 2663BCA649
X-Rspamd-Action: no action

On resume from s2ram, a defconfig kernel gets into a state where the x2apic
hardware state and the kernel's perceived state are different.

On boot, x2apic is enabled by the firmware, and then the kernel does the
following (relevant lines from dmesg):

	[    0.000381] x2apic: enabled by BIOS, switching to x2apic ops
	[    0.009939] APIC: Switched APIC routing to: cluster x2apic
	[    0.095151] x2apic: IRQ remapping doesn't support X2APIC mode
	[    0.095154] x2apic disabled
	[    0.095551] APIC: Switched APIC routing to: physical flat

defconfig has CONFIG_IRQ_REMAP=n, which leads to x2apic being disabled,
because on bare metal, x2apic has an architectural dependence on interrupt
remapping.

While resuming from s2ram, x2apic is enabled again by the firmware, but
the kernel continues using the physical flat apic routing. This causes a
hang-up and no console output.

Patch 1 fixes this in lapic_resume by disabling x2apic when the kernel expects
it to be disabled.
Patch 2 enables CONFIG_IRQ_REMAP in defconfig so that defconfig kernels at
least don't disable x2apic because of a lack of IRQ_REMAP support.
Patch 3 is a non-functional change renaming x2apic_available to
x2apic_without_ir_available in struct x86_hyper_init, to better convey
the semantic.

Signed-off-by: Rahul Bukte <rahul.bukte@sony.com>
Signed-off-by: Shashank Balaji <shashank.mahadasyam@sony.com>
---
Shashank Balaji (3):
      x86/x2apic: disable x2apic on resume if the kernel expects so
      x86/defconfig: add CONFIG_IRQ_REMAP
      x86/virt: rename x2apic_available to x2apic_without_ir_available

 arch/x86/configs/x86_64_defconfig |  1 +
 arch/x86/include/asm/x86_init.h   |  4 ++--
 arch/x86/kernel/apic/apic.c       | 10 ++++++++--
 arch/x86/kernel/cpu/acrn.c        |  2 +-
 arch/x86/kernel/cpu/bhyve.c       |  2 +-
 arch/x86/kernel/cpu/mshyperv.c    |  2 +-
 arch/x86/kernel/cpu/vmware.c      |  2 +-
 arch/x86/kernel/jailhouse.c       |  2 +-
 arch/x86/kernel/kvm.c             |  2 +-
 arch/x86/kernel/x86_init.c        | 12 ++++++------
 arch/x86/xen/enlighten_hvm.c      |  4 ++--
 11 files changed, 25 insertions(+), 18 deletions(-)
---
base-commit: 18f7fcd5e69a04df57b563360b88be72471d6b62
change-id: 20260201-x2apic-fix-85c8c1b5cb90

Best regards,
-- 
Shashank Balaji <shashank.mahadasyam@sony.com>


