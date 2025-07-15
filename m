Return-Path: <kvm+bounces-52505-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B129B05F2C
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 16:01:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BCCA81C40143
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 13:55:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8EAD2EF291;
	Tue, 15 Jul 2025 13:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="Phz6hZP+"
X-Original-To: kvm@vger.kernel.org
Received: from smtpbgeu1.qq.com (smtpbgeu1.qq.com [52.59.177.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB5C62ECE8D;
	Tue, 15 Jul 2025 13:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.59.177.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587175; cv=none; b=AiwCewEm0Ljj0WHaPVml8hD0tcGCxIwccImsQ4DGpRcuMXBEdZDCasDMPyP5LcIygSY11gHDMrN5P97mCfscwnpbW+k4OUsyPkhfp0yf1NpS5P/vAKY+hbu0GEs8B5usm+riKBm1+fvAb705iN6h9vtd0iKtA9mfUk9pVWJwl6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587175; c=relaxed/simple;
	bh=NHY04lWbnuGt7TUMVXMBAd99xrE3nzf7tN3dhvAdpFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PiTTdvSdnneMZaaZurzdfvwI+oz+gylPOybpSITVduy5HeWC6m8oLIx/WodF4G/YYAabmOGJGOgM8OKcbgKPePIsojIZANG+2XJe9D7xd7rzl3mXXYsy9qVu3A0AL+o7swmg15z47TJAg4T32469cIwVJQ/h/KpaczGrDHG/xIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=Phz6hZP+; arc=none smtp.client-ip=52.59.177.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1752587163;
	bh=NWDrOIeUTkfMgeyG9DirCptVDnqPmotqOLDK+VZpCcc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=Phz6hZP+BX4JxgSZv0yx6y4RzgAezdoknG6JcU4T+5IiBA1DlhmX0IRf92dZHV7Mh
	 Uq1gANZLNFY8pjDy9/8lguRTsytG6eIhAvdZ47kuKQzBnFqrfPZVuFOJ09ChWQabIg
	 Yuyz5WaWnAYwlrPiMU+QMUa0YAAlPAz6Zk+N214Y=
X-QQ-mid: zesmtpip2t1752587129tb54538eb
X-QQ-Originating-IP: PsIrTfnu37O5BQpc09CPKOeWtbwmOWY2B4qF0spybKw=
Received: from avenger-e500 ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 15 Jul 2025 21:45:25 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 9443703254596192763
EX-QQ-RecipientCnt: 63
From: WangYuli <wangyuli@uniontech.com>
To: wangyuli@uniontech.com
Cc: airlied@gmail.com,
	akpm@linux-foundation.org,
	alison.schofield@intel.com,
	andrew+netdev@lunn.ch,
	andriy.shevchenko@linux.intel.com,
	arend.vanspriel@broadcom.com,
	bp@alien8.de,
	brcm80211-dev-list.pdl@broadcom.com,
	brcm80211@lists.linux.dev,
	colin.i.king@gmail.com,
	cvam0000@gmail.com,
	dan.j.williams@intel.com,
	dave.hansen@linux.intel.com,
	dave.jiang@intel.com,
	dave@stgolabs.net,
	davem@davemloft.net,
	dri-devel@lists.freedesktop.org,
	edumazet@google.com,
	gregkh@linuxfoundation.org,
	guanwentao@uniontech.com,
	hpa@zytor.com,
	ilpo.jarvinen@linux.intel.com,
	intel-xe@lists.freedesktop.org,
	ira.weiny@intel.com,
	j@jannau.net,
	jeff.johnson@oss.qualcomm.com,
	jgross@suse.com,
	jirislaby@kernel.org,
	johannes.berg@intel.com,
	jonathan.cameron@huawei.com,
	kuba@kernel.org,
	kvalo@kernel.org,
	kvm@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-serial@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	linux@treblig.org,
	lucas.demarchi@intel.com,
	marcin.s.wojtas@gmail.com,
	ming.li@zohomail.com,
	mingo@kernel.org,
	mingo@redhat.com,
	netdev@vger.kernel.org,
	niecheng1@uniontech.com,
	oleksandr_tyshchenko@epam.com,
	pabeni@redhat.com,
	pbonzini@redhat.com,
	quic_ramess@quicinc.com,
	ragazenta@gmail.com,
	rodrigo.vivi@intel.com,
	seanjc@google.com,
	shenlichuan@vivo.com,
	simona@ffwll.ch,
	sstabellini@kernel.org,
	tglx@linutronix.de,
	thomas.hellstrom@linux.intel.com,
	vishal.l.verma@intel.com,
	x86@kernel.org,
	xen-devel@lists.xenproject.org,
	yujiaoliang@vivo.com,
	zhanjun@uniontech.com
Subject: [PATCH v2 8/8] scripts/spelling.txt: Add notifer||notifier to spelling.txt
Date: Tue, 15 Jul 2025 21:44:07 +0800
Message-ID: <A205796B545C4241+20250715134407.540483-8-wangyuli@uniontech.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <BD5C52D2838AEA48+20250715134050.539234-1-wangyuli@uniontech.com>
References: <BD5C52D2838AEA48+20250715134050.539234-1-wangyuli@uniontech.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz8a-1
X-QQ-XMAILINFO: MhWaMTxgikzcXM78z348aNip/MqyZXeaEcqps5e452C7wk+IjCoLDT5P
	bx/+gd1zygbbCORvht4sKMoIGWIpEfRoJrGSkDTCbWGKNv/UB9dtGaVmvvcn+wt7AjsAWtP
	vIOHA5e69i8ggVIh0HCI5l92uDyE1pkFZV9TGujQw9a3uyc3k+446kZKbZ4OaMk2hFhKz/Z
	SYt3TCLDKfxFYpH6a8CQASXr5uNFR6wQcmuRGxC06Ic2GzK7mNtIkMDmK+VtTCbhcWDeia2
	H9bqo6LGBdd1CK3vSDm/GiNfDvL1b1dTpLi2VGl+zPH2tebta/VgQ8y9GvVviClntMj+CX3
	WpmubpOmgOcfR2zHV4h31YNQpCwvx09dWj1tZB+qLPUtwibshvSw61YV0n17xleed9EZ3eZ
	7Pm1/SV+PxrroEbc327V6SG9/MOe1plIUiiqEy9OFN/EXpZGVVeePzCQOedLOsZ4FJVfmxJ
	jodDR4VcL4s3qrLr0yfLCHFhoxJU386EaxpBp/Gd0rqcLUfDARMPJnI6VzVbTvnymhcxksp
	5xvY8BgJMks70NMwqAr8OnfWHmUSYAVSAzmRPdkhMgzLTnQMRKBGj9t3cFSOQNOX8mcQTax
	rFe/aP0a+gVCWOxvj1wHpqybcK2jCRJhOjWBtUagbKEqfkUlWazasSselbdD3Gv7+9xAq5x
	l0vGyP2qFUY0GYGCsy7Ea9eyAgPdxh9uyNlQYh+CZGOoRodgoT7Fd3wt1Tb4IHvY39n/6S8
	wfeeQmLFR7CSjgSDQy/KnmRbqjHSrJZvwnrLV4N3BWbVvqEU+FhGdmv0GI+sujt5g7FMh2t
	/w9/NYr/Ce7ZwqWSg1/rlgcpfe5wTEsrwz1dASQ5ZimjhsPOqKCSeiT7Fz0Zm4M0GVXLxzd
	RlqqGfrfRxbk+MU8XY2N0xK9fE6n65s6y9WUcSWaI872AEbClgCmbTdVMZ6+gFGP6WB01Ve
	eHVUqt5gS8ma4gJVcQxx5bmgmEuQKvNeCDorxP28mFZgb6w9GG+lfxgJewMSOnTPAI1GYAE
	ZjGgB98iRoJNIy3entSX2Y1Rda99NmnrGL7FBTstavaUIfLzDzH6kddcSosZM03IZA7ufk1
	TpzbO5K0Eae
X-QQ-XMRINFO: NS+P29fieYNw95Bth2bWPxk=
X-QQ-RECHKSPAM: 0

This typo was not listed in scripts/spelling.txt, thus it was more
difficult to detect. Add it for convenience.

Link: https://lore.kernel.org/all/B3C019B63C93846F+20250715071245.398846-1-wangyuli@uniontech.com/
Signed-off-by: WangYuli <wangyuli@uniontech.com>
---
 scripts/spelling.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/spelling.txt b/scripts/spelling.txt
index c9a6df5be281..d824c4b17390 100644
--- a/scripts/spelling.txt
+++ b/scripts/spelling.txt
@@ -1099,6 +1099,7 @@ notication||notification
 notications||notifications
 notifcations||notifications
 notifed||notified
+notifer||notifier
 notity||notify
 notfify||notify
 nubmer||number
-- 
2.50.0


