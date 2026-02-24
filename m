Return-Path: <kvm+bounces-71617-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eHdRAOibnWnwQgQAu9opvQ
	(envelope-from <kvm+bounces-71617-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 13:39:04 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D2D6187117
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 13:39:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A231431E046E
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 12:35:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D977B39A81C;
	Tue, 24 Feb 2026 12:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="OxeRycpe"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEC87395DBC;
	Tue, 24 Feb 2026 12:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771936512; cv=none; b=MfAWnnL8PXYyDelds3EzsOJ4T+HeL/dBfDF27sQDx1irqtCmIdykCeCGjshBLmnBGasZ9hdK9mIlda73D2wSK9vR9qTjoY1zksDVlz/vO0Wok7K4xNThycGvxEtGMYmcjupkh9E8pn6LlhWqo2RSAj90cGrYwvlZgsUrp83U4PE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771936512; c=relaxed/simple;
	bh=jgV0M3inHIdG82dqe/HOmmFItJk44LXErTHkR3d5wdI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=TAZzuL702bPGU66H9GfCemXeeVHA0DHRWvZzWZxqYbXmC+JiG4IQQYlN8mozqDVKmVZIXstU+2FrEC5R8RtouWhh2/KpGKR2+D2toopurKgH2v+4IBYsPJhlG0NbOf+ylhq0xT4oEcFYzhFv5qOKffGY2xnI5j7/fgqHGZD20VQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=OxeRycpe; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61O90xGr2849182;
	Tue, 24 Feb 2026 12:35:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=2GRSXU
	xjybI8Mm7DxJNae/l+qDkmGkl+yaEQNMvLc2U=; b=OxeRycpedKmxNhw8HrxayP
	bOQDZb+kuRk41Dlt0UpEg+ZaaMtfmfodjakkMmIZYK9pIz5aJpZFwQRToeBBQ7X6
	nEiJxBoBF2C5lqAWtBbmnTHPl4bgJgI6m3L6425lPl0DO7hqxI0W1Gw7xo9nqGUM
	LYYylD3imAL5j2QcLjEXNz4T7HJFKk5LbdT/7E+jh1uPyWPBnSrIGItSRbG91Bto
	5T0FhSf7SE5d1PSSNAJ+3GVqgrL/Z1iM9346ObdVwxNoJUHeqpyGxs6gv9lL736v
	ZO9HupmAVhp9I6QiD623Pyq+IORUAPd1WOeI2c1H5tLJLLpFI7knSkU7Boj5ia7g
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cf24gb4jc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 24 Feb 2026 12:35:04 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61O9CZRw027887;
	Tue, 24 Feb 2026 12:35:03 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4cfsr1rj4p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 24 Feb 2026 12:35:03 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61OCYxGr30802326
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Feb 2026 12:35:00 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D44C820040;
	Tue, 24 Feb 2026 12:34:59 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 92B9F20063;
	Tue, 24 Feb 2026 12:34:59 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 24 Feb 2026 12:34:59 +0000 (GMT)
From: Julian Ruess <julianr@linux.ibm.com>
Date: Tue, 24 Feb 2026 13:34:34 +0100
Subject: [PATCH v2 3/3] MAINTAINERS: add VFIO ISM PCI DRIVER section
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260224-vfio_pci_ism-v2-3-f010945373fa@linux.ibm.com>
References: <20260224-vfio_pci_ism-v2-0-f010945373fa@linux.ibm.com>
In-Reply-To: <20260224-vfio_pci_ism-v2-0-f010945373fa@linux.ibm.com>
To: schnelle@linux.ibm.com, wintera@linux.ibm.com, ts@linux.ibm.com,
        oberpar@linux.ibm.com, gbayer@linux.ibm.com,
        Alex Williamson <alex@shazbot.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        Yishai Hadas <yishaih@nvidia.com>,
        Shameer Kolothum <skolothumtho@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>
Cc: mjrosato@linux.ibm.com, alifm@linux.ibm.com, raspl@linux.ibm.com,
        hca@linux.ibm.com, agordeev@linux.ibm.com, gor@linux.ibm.com,
        julianr@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-pci@vger.kernel.org
X-Mailer: b4 0.14.2
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=TNRIilla c=1 sm=1 tr=0 ts=699d9af8 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8
 a=VwQbUJbxAAAA:8 a=Ikd4Dj_1AAAA:8 a=pktR2d_FFHlprNNHfO0A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: jelGowaXYEAFxmg675U-D9l3YFnzYKES
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI0MDA5OCBTYWx0ZWRfX7QCzjVxsjQTW
 Iox9qUdokImXmDj+oD9IBOVPs4NEhXvM2hAnvXma74HPXy74+/0semJoZioTwVJjVu7EUuwkTBB
 dCgLJsfGzma8IWx0YerfTGB5YK2h9CZOSPjUNIlFnFWkZlpv4Gv/4/TC0WF6vksvxsoT2Mmfthd
 SOMfT5g7rMareBeh1cTDpVEPxjB9CqwvmTfPOrgCDx8Us0CGuRUqr4uvGWVWqwGMxQI99m/BFy5
 M9U/VCyJFrJoI6LI/hoQmAZHvC/q0gzX/9Gi2nUhu3y2TKh2j0N75yUNfHZiDecOHiLQLpOSdP4
 6nCOBJIUmcYWMUsNGXfFU9BL3kMBZ892QJJxKZKphfxh7JEaM9zRrO40IlD05LFaQBfLyhdp8Gg
 4Kwe2QsQn/xYdppLglFTPzBiWsb3vntRI5106RK0RD4gZeVQGK2eBmIUQDi+3ZkqEPv6ihF90ZP
 Cod4YTBQlEmszQS40Ng==
X-Proofpoint-ORIG-GUID: jelGowaXYEAFxmg675U-D9l3YFnzYKES
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-24_01,2026-02-23_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 adultscore=0 priorityscore=1501 impostorscore=0
 spamscore=0 clxscore=1015 bulkscore=0 lowpriorityscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602240098
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[21];
	TAGGED_FROM(0.00)[bounces-71617-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[ibm.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[nvidia.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linux.ibm.com:mid];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[julianr@linux.ibm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: 5D2D6187117
X-Rspamd-Action: no action

ism_vfio_pci is a new kernel component that allows
to use the ISM device from userspace. Add myself
as a maintainer.

Signed-off-by: Julian Ruess <julianr@linux.ibm.com>
---
 MAINTAINERS | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 55af015174a54e17cc7449e5a80b6cdc83aa6fde..88d728abeab4faedf5bfefbf98ab45e288d1332c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -27710,6 +27710,12 @@ L:	kvm@vger.kernel.org
 S:	Maintained
 F:	drivers/vfio/pci/hisilicon/
 
+VFIO ISM PCI DRIVER
+M:	Julian Ruess <julianr@linux.ibm.com>
+L:	kvm@vger.kernel.org
+S:	Maintained
+F:	drivers/vfio/pci/ism/
+
 VFIO MEDIATED DEVICE DRIVERS
 M:	Kirti Wankhede <kwankhede@nvidia.com>
 L:	kvm@vger.kernel.org

-- 
2.51.0


