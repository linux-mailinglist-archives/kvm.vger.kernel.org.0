Return-Path: <kvm+bounces-72814-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yJ63Hc91qWl77wAAu9opvQ
	(envelope-from <kvm+bounces-72814-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 13:23:43 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EF7A02118EB
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 13:23:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 720BD31433F7
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 12:20:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E31A939A7E0;
	Thu,  5 Mar 2026 12:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ClbecIxi"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C40EF2D2486;
	Thu,  5 Mar 2026 12:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772713235; cv=none; b=mFenSrJxo4UKCOYItJutKKgFkJ8aOKhES6kVVhTlSTTfzRujUaD1dHV5AXMzv5V32G1KvjNcYD5DOHH8pwgLEJ9yyeM5EBbILgFLk8xQnwbfVAy0cOlFPGlexEsyeJhfSj79N6WvCoHV7cRuFSmDF1ES/kDwMZ/e1r0GBVlDB0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772713235; c=relaxed/simple;
	bh=iLJjOaBasa5wqp8pJKVLzB3iLIlNJucj2+/WyMGarQQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=sE6vth/Fefv52844A2l8RP4WQ0QFO8RuxGOzm4XGZZLMANiTy7oOaRM5hxEoObLnpxgxozDOWUPSnlswg4JDwAYaDGjfh/zrLirCQHkQS14DjAJwdPWnK/ZaqsFHrmtRcnoRL8wtg11Ajj8y0RYhORw04LC9VsTBpbu+ZWLqw0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ClbecIxi; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 624IJT0a614134;
	Thu, 5 Mar 2026 12:20:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=YssNr5
	zdvq4c5Fn1XZLKXxTrO6VR1IwkM3ky8LEG65M=; b=ClbecIxiQaA8D3U3Q5Te3g
	XO1waVGxfAX4JApXoHV1yVXo4c0+bf6M6B5RbtcEl7Cbvc1RLqY3Q9eL3ZIn4Cv1
	CkUF/gP4ZGUDgwqXDizCrtsxlwWXPwZdFFI/NZdPkOan7WRVdZFr1xgZ7Pn4yTrl
	u/hK+uG6q+5Jb7Ke97OHzBdn+aDe2B7V6BttghYHH+kJiQSlNaB8GKLrNFFBuibg
	Bm0SS7XwclyH7R5LqnPnCBbHrNHO11K5TMU9qNSDVW1e5mtt5FMw4TdUU4YWqMiY
	8wnO97wQsg9ypzFr8mxhh69Vno+UOU5DbR28IENIB1JCu/TBYnwMXmKP5APhtzGw
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ckssmu6a8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 05 Mar 2026 12:20:27 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 625BNlLY008769;
	Thu, 5 Mar 2026 12:20:27 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4cmdd1jx7c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 05 Mar 2026 12:20:27 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 625CKNc732375182
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 5 Mar 2026 12:20:23 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7439220040;
	Thu,  5 Mar 2026 12:20:23 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 284DD2004D;
	Thu,  5 Mar 2026 12:20:23 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  5 Mar 2026 12:20:23 +0000 (GMT)
From: Julian Ruess <julianr@linux.ibm.com>
Date: Thu, 05 Mar 2026 13:20:15 +0100
Subject: [PATCH v3 3/3] MAINTAINERS: add VFIO ISM PCI DRIVER section
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260305-vfio_pci_ism-v3-3-1217076c81d9@linux.ibm.com>
References: <20260305-vfio_pci_ism-v3-0-1217076c81d9@linux.ibm.com>
In-Reply-To: <20260305-vfio_pci_ism-v3-0-1217076c81d9@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA1MDA5OSBTYWx0ZWRfXwQ9Cuy97zLS1
 KD3x4qgwx2g6hpzbsXxI9Gu+AzojLeyRS9sKM/bAM/3QBQ+Nl1n0B8zZ8Li3nb9yKfhmc9w72Vp
 Vx2egbfKEdkqArntAPKQRyQS7EiBtSHcDKO1RUGOvc+FSi++YtLAI5ujuh68c28GbKi4DT7D8+7
 +keFixGLQ8fVdySextuUNsR/hLoqxBWYMmAXT3TT5pFK2wXpmE1e1jnaYABLZT5eQgE8pbqrTbZ
 TMGOXZsDS9iZ1q8jcMjzUrD4hCdiNcy/rF+b7uvX0i5vIdkHo5gYv/cnacoe/pTpY/A3r345KwC
 9SAvlOQUH5lpS1F4nyPpjm69H3euyCgrrgy4PFAFR24ESc4QdjCjTG1MvI75HcQ/IlRy+XNAMAV
 dyEeD04Box1Uw8YYRgsEylpf9qyUX1Iod+/B5Ay+HtuxzfjTY3kKDVCOSaRUFPkJJfQY6gZ7ZQH
 j8du1dWI8mkdaIpK17A==
X-Proofpoint-ORIG-GUID: 38UMEjqMNiZF65w7RxC5Yn-0uxngn8TG
X-Proofpoint-GUID: 38UMEjqMNiZF65w7RxC5Yn-0uxngn8TG
X-Authority-Analysis: v=2.4 cv=AobjHe9P c=1 sm=1 tr=0 ts=69a9750c cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8
 a=VwQbUJbxAAAA:8 a=Ikd4Dj_1AAAA:8 a=jBZh5NATpTL4zB9YInYA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-05_04,2026-03-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 impostorscore=0 malwarescore=0
 spamscore=0 clxscore=1015 suspectscore=0 adultscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603050099
X-Rspamd-Queue-Id: EF7A02118EB
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
	TAGGED_FROM(0.00)[bounces-72814-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[ibm.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.ibm.com:mid,nvidia.com:email,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[julianr@linux.ibm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Action: no action

ism_vfio_pci is a new kernel component that allows
to use the ISM device from userspace. Add myself
as a maintainer.

Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Julian Ruess <julianr@linux.ibm.com>
---
 MAINTAINERS | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 61bf550fd37c274843e516e00068bb2ab1e152ac..b2b937890877f227e95872bb808a6b4d99a0ebee 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -27709,6 +27709,12 @@ L:	kvm@vger.kernel.org
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


