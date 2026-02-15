Return-Path: <kvm+bounces-71108-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id heZ3OzTTkWnXnAEAu9opvQ
	(envelope-from <kvm+bounces-71108-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 15 Feb 2026 15:07:48 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F9B313ECC8
	for <lists+kvm@lfdr.de>; Sun, 15 Feb 2026 15:07:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B9411300AC2A
	for <lists+kvm@lfdr.de>; Sun, 15 Feb 2026 14:07:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4994C2C0F90;
	Sun, 15 Feb 2026 14:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="dKXLYDK9"
X-Original-To: kvm@vger.kernel.org
Received: from xmbghk7.mail.qq.com (xmbghk7.mail.qq.com [43.163.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38120221265
	for <kvm@vger.kernel.org>; Sun, 15 Feb 2026 14:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=43.163.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771164458; cv=none; b=kGt+rGHuIqkdk9Y/PooCgiACfbjKCL05KqioOVBPDJmDcpWht5cRs0ujbo1x2y5gm5PADDNkgou4M5ULxCbU0VWh4zWmGuwc1uyg5NvHX1gbluFmKXOvD6+Rl1J4tgRwu03tQHtUe+E/55/BEvMP5Px1s4ldaJnayxzNUxZIIIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771164458; c=relaxed/simple;
	bh=U6KYEXATx/ZCb6Bg2e0PEz/fg7fICtelTaeSAArkc3w=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=qFccdHIZRvSUsF/705NW/K7gAZTdFobqgjhBND4BIh/ciA4VN4JTKDyb4VRFLDsR6c1NHdOMPvVTbY/dGajCVV/u4VBGqE1C/HDFBN0yi68yKRhxuNsl5k3QVdoiLIeN/s01s5IDBGMqglM9Yhp8GXfWSno5YNURx2XdwSl4bqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=dKXLYDK9; arc=none smtp.client-ip=43.163.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1771164447; bh=MkD6nItPwMd4tt8SWDWFZGGMOk990r8XHR1o3xlig9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dKXLYDK9zQlDHFDNpjAnmRVW8IAdwaR+Y9LV09iMi9UzJydfmfim4rI2nOeoa7G+P
	 2RHZH+VNeeII1NnYuJ/4vHma5vxI8uZykPvdktVHFUf8k6Uy7uec+va2UJPhCMxdxV
	 DfoqWPgF4TD2c0mWWf4SgWNFz2d2C/zW+TmyH0qU=
Received: from pve.sebastian ([118.250.2.92])
	by newxmesmtplogicsvrszb51-0.qq.com (NewEsmtp) with SMTP
	id 10481CF7; Sun, 15 Feb 2026 22:04:04 +0800
X-QQ-mid: xmsmtpt1771164245tza7zjg4d
Message-ID: <tencent_606610DBCF4CC9C810B0694110E12E135C05@qq.com>
X-QQ-XMAILINFO: NAuAIaytDrXpxXCDmZmOCKCK1bOKUjrgBwWL8uGpm/wWSjQstzq0IUX6btbuxZ
	 Qmg79n5QM10IRy/nLfo31B+V1dnJV1VE2THpCViQj6iY9BZ6wjX+OCyWbQbLVivHuJoDIq/Fv+Mv
	 dZKyczOmNFKEtLG3m7xPqQ8ri5SMi5KslJuzGl+RCPkWNnmm5n4tfc1XSBKc7DADL6WvDT0BAx1I
	 G8mAki8Hjz06ujdzbKeKWJ76xhQqVECSRB/q1byBhLByLGOU4KUotUBSTFKwRGELdHIHKJCNG09o
	 E2S58cDKv7QfFMFVNL4956+zS+fPbZ5pNI3KQpULlhUo2RUR2VzIwAWtoolZ+9iRxVFBKKd69b6o
	 3FqXe4vhsxm6V3EBfOf3yoHS+btob27uFxuVV2lJ3jAg+P7JkZjFrXYnpyPaLFabazHp72awm3fo
	 9N6WPrCL0HHjC+xnb90UY3G5m/CK3QSPNdS3e59SKjhCohMybUgjog4akzYqYGNteYvH3I3ZhVPq
	 faCP+ohxWdD0XMC6t7LTcq1N/UJ3e536zEtw2/34SugrXGHn+RRWiqIxm0wEYTCo+wCu3iEptQdW
	 k1+DwzOovQ1vxF169B8t+HUdLEtYIZQ9T8tiwPZt3JR0V7bo1kl1c333GpmT0Bt8dK/RDtyHLnmj
	 xqzLFhF1utSceBis4SoM/v5Xq/YTAQ61Us0z3LYzrWc0t6Fe/kG/vN8qenOj8pkfjfZC5Hjj/Sn7
	 4QlY+UVV0MGm+8V7Nq5woora8EPpjzz+6+RYenrm8m7t67t2v542UMD3xcmRwtvW/miRpjFDu5K8
	 txD2LvEgyUljpKaPOUr9O4wqwpPb0S0P47fdvEvRPrdfESyvK5/vnZ/6laEp//hErXUxzr+Wyozo
	 xFtITJMSxMeTWn8SEVpoRjoU44hNpquZL0G4qY+53t9XlG+NBNmKs+10IyOo/y5kOM+jg64+SbeY
	 R2LIEcefGcCyBMkvD06AOxaXlIbm6R/lhZo9TJqdEhVPodxyPkDe3VWLKJwoRlr0jVm4G+MoKzpy
	 J/bmPt3LbSnlVpTfNF
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
From: 76824143@qq.com
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org,
	zhanghao <zhanghao1@kylinos.cn>
Subject: [PATCH 1/3] KVM: x86: Enhance kvm_vcpu_eligible_for_directed_yield to detect golden targets
Date: Sun, 15 Feb 2026 22:04:00 +0800
X-OQ-MSGID: <20260215140402.24659-2-76824143@qq.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20260215140402.24659-1-76824143@qq.com>
References: <20260215140402.24659-1-76824143@qq.com>
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
	R_DKIM_ALLOW(-0.20)[qq.com:s=s201512];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-71108-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[qq.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_FROM(0.00)[qq.com];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NO_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FROM_NEQ_ENVFROM(0.00)[76824143@qq.com,kvm@vger.kernel.org]
X-Rspamd-Queue-Id: 9F9B313ECC8
X-Rspamd-Action: no action

From: zhanghao <zhanghao1@kylinos.cn>

Detect "golden targets" - vCPUs that are preempted and ready.
These are ideal yield targets as they can be immediately scheduled.

This check reduces unnecessary yield attempts to vCPUs that are
unlikely to benefit from directed yield.

Signed-off-by: zhanghao <zhanghao1@kylinos.cn>
---
 virt/kvm/kvm_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 61dca8d37abc..476ecdb18bdd 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3927,6 +3927,9 @@ static bool kvm_vcpu_eligible_for_directed_yield(struct kvm_vcpu *vcpu)
 #ifdef CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT
 	bool eligible;
 
+	if (READ_ONCE(vcpu->preempted) && READ_ONCE(vcpu->mode) == IN_GUEST_MODE)
+		return true;
+
 	eligible = !vcpu->spin_loop.in_spin_loop ||
 		    vcpu->spin_loop.dy_eligible;
 
-- 
2.39.2


