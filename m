Return-Path: <kvm+bounces-71106-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id VMYoMGrSkWm+nAEAu9opvQ
	(envelope-from <kvm+bounces-71106-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 15 Feb 2026 15:04:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 124E213ECB7
	for <lists+kvm@lfdr.de>; Sun, 15 Feb 2026 15:04:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 263CB300E398
	for <lists+kvm@lfdr.de>; Sun, 15 Feb 2026 14:04:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8C5E2BEFF5;
	Sun, 15 Feb 2026 14:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="wM70qFrn"
X-Original-To: kvm@vger.kernel.org
Received: from out203-205-221-239.mail.qq.com (out203-205-221-239.mail.qq.com [203.205.221.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E92EEC0
	for <kvm@vger.kernel.org>; Sun, 15 Feb 2026 14:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771164258; cv=none; b=TaJqScu2eE7wPCJQm9r9HlVvWrZgRRb1MvL5aULSKTamSXlcK2qHi1F9M888KnWQfNrJsb/yiibkk6pSMreiCa9bdx2oHn9Umfaqm29L5lVtdmhD4IbHwpAxRjhDM+eFEBvQL2XUzKY5U0uFTzPzNOOpTBsVEi/2d2FytenVKIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771164258; c=relaxed/simple;
	bh=WpOfL2Bn8g4/W7z8ZnWJq6zfZc+urImCHd736qo90EY=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=m6KK8yYEKvidYMHCQJfOpsKk/SZHyEPf6xUpjZpoTOOhGrW8aENkjHpIxKbzMUa7giTZZc148KWvBtc89SwFcKNBEgxhya3tldrkmxqiDhclwWO/D29LKNnPCRdnC9LUGJzFG0+IoZZxoVFMR+yleDfyUoeAEtiSCSP3KBFI0iY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=wM70qFrn; arc=none smtp.client-ip=203.205.221.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1771164246; bh=X0GvlRLI4rrQIuaL+GSTrdCqVg51X9/vhV24mQGoupI=;
	h=From:To:Cc:Subject:Date;
	b=wM70qFrnwdsH3rhiD7BXdNN+Wp5xSXg1P5zHCTfH//mOCoUi3K+F2i/7SMNGDkfj4
	 aY7Ntv2eNpvio1nNHdXMlRqDc0IVpSKk3zIiH4eQ/fashOsgOfIzuXExeFYdpai/cu
	 fP1B1bngSCd/fjNIryNomW37GQmvOaz4WpBBp1rA=
Received: from pve.sebastian ([118.250.2.92])
	by newxmesmtplogicsvrszb51-0.qq.com (NewEsmtp) with SMTP
	id 10481CF7; Sun, 15 Feb 2026 22:04:04 +0800
X-QQ-mid: xmsmtpt1771164244tixi9phqq
Message-ID: <tencent_D3CAACC1681AB06EA109E125B35186117B05@qq.com>
X-QQ-XMAILINFO: OATpkVjS499u+0Xac6RDsDGcpKBDqltaHLJWef9yVxO17xSXa/7f+6yRmGrLIZ
	 S/T2l7Dy2TYPhhsuptt839LFZAHezzqzt11C+0Q3INCGLP5D4rh5m+amyRoL0XlJK66DDSmdA2E+
	 BfDkgUtT5XeMlx6YmJYiw7LYzKDVKKg0fZtp/NCzJqwyw1rOMrXS//Jq0hfcgs5izjixN4we/G7C
	 YGQGB/tAPR1/Q0B/souYSHP63VbS+sdE6JWNeE30QryWkKo6zL0YXDZqv7bI4Tmn8jotGqM1QMB5
	 zz+t/1DJPI0HXoLCWhylCqZ72PA/7EJjihh5sDDzEwM2cfWVUyGrM7ImMb4E0QbQzXxr3bsJ8q16
	 GoiOJwvBE6WPLnk8Xyd/SWLyfZogil/o5O+uZcRkBoGXOf1HB4N9Uj5IHMPnzwmCaSHX+16tVXok
	 CQJHviDyredExUgczULfTcaLIDfrsm4mtmlS33rVmCKwiKk52MK5Z/6wqtADxH1ffmRnGTWlrXLh
	 xq2KN6/G1AMkprbZXSd3pudep4kyF+1e/hcqhL3Q5w4wisiYA9sx3ZkecOH/n6Wk01hLtazmVp0+
	 b+XbdpQImwb1uNyTjuGEa4GAwsFRHYpcfG3du7edmkFpdaoHqMty/ZRzvqO/SXXT+UEONLFP1xzj
	 j+g+Y5TDoJ0AqZMc5OqNezgSMgcFRIxUiIE3g2jroOZYHnlFWvfVJy/MZXl7gvL4t7HS6FvYkKc/
	 WDpFrxeWQQoint7X4QwMeJvDPijPkac8fhkP4cgnaj3KeAK5qn1FeGdhMPs3MMosyUgyCNtQJQg3
	 1gdhHEjjnnRilcPFUfvO6jpubJKL/igDcPwAn0XakK5POI1iiGTxELUirrp2vMxxS/mOWznKT0VP
	 oT+G0oketp5tq4YyDDIZgDWnCHtKOHiqF5EW5ssh0PU9yB86iyt4aKhY5LvTj29crpXUnlCo+egz
	 ZEP28vg60v6ogaA4dQBR6It+8Xeq998O8w4mILpHhY92Z70Mhdn7aQO8SM00uOB0hXFsvX5iL87H
	 l17TMQKbjS5EOCZ2N4w70Z82vNYLuQkwbxD4jvoA==
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
From: 76824143@qq.com
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org,
	zhanghao <zhanghao1@kylinos.cn>
Subject: [PATCH 0/3] KVM: x86: Optimize kvm_vcpu_on_spin() directed yield
Date: Sun, 15 Feb 2026 22:03:59 +0800
X-OQ-MSGID: <20260215140402.24659-1-76824143@qq.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[qq.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	R_DKIM_ALLOW(-0.20)[qq.com:s=s201512];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-71106-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_THREE(0.00)[3];
	FREEMAIL_FROM(0.00)[qq.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[76824143@qq.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[qq.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NO_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kylinos.cn:email,qq.com:mid,qq.com:dkim]
X-Rspamd-Queue-Id: 124E213ECB7
X-Rspamd-Action: no action

From: zhanghao <zhanghao1@kylinos.cn>

This patch series optimizes the KVM directed yield mechanism in
kvm_vcpu_on_spin() to reduce VM exits and improve vCPU scheduling
efficiency in overcommitted scenarios.

The main improvements include:

1. Enhanced target selection: Skip vCPUs already in guest mode and
   prioritize preempted-and-ready vCPUs as "golden targets".

2. Skip IN_GUEST_MODE vCPUS in kvm_vcpu_on_spni main loop to reduce
   unnecessary yield_to() calls and vm exits.
 
3. Dynamic try count: Scale the number of yield attempts based on
   the number of vCPUs, rather than using a fixed value of 3.

Testing on a dual-socket Intel Xeon E5-2680 v4 (56 threads) shows:
  - 9.1% reduction in VM exits under ping flood load
  - Reduced vCPU preemption overhead

Performance Impact:
  ==================
  Test Environment:
  - Host: Proxmox VE 6.8.4-2-pve
  - CPU: 2x Intel Xeon E5-2680 v4 (28C/56T, 2 NUMA nodes)
  - VM: ubuntu24.04, 32 vCPU / 16GB RAM
  - Load: ping flood from host to VM

Results (3 x 60s runs, average):
 
   Metric                  Baseline        Optimized       Improvement
   ------------------------------------------------------------------------
   VM exits/sec            30,677          27,886          -9.1%
   kvm_vcpu_wakeup         1,049,387       985,546         -6.1%

zhanghao (3):
  KVM: x86: Enhance kvm_vcpu_eligible_for_directed_yield to detect
    golden targets
  KVM: x86: Skip IN_GUEST_MODE vCPUs in kvm_vcpu_on_spin main loop
  KVM: x86: Use dynamic try count based on vCPU count

 virt/kvm/kvm_main.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)


base-commit: ca4ee40bf13dbd3a4be3b40a00c33a1153d487e5
-- 
2.39.2



