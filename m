Return-Path: <kvm+bounces-70956-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qI/qMojdjWna8AAAu9opvQ
	(envelope-from <kvm+bounces-70956-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 15:02:48 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B50E12E10F
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 15:02:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 801473015D85
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 14:02:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84E2A346E5A;
	Thu, 12 Feb 2026 14:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="JDm407du"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7972A2C234A;
	Thu, 12 Feb 2026 14:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770904962; cv=none; b=d7wf6DbhBCdK9f6HO+lqei/tjE4b1t6GuLGD/7CqfvZ0R10HjOWAjywCcMpUvxLsPAG84APf8h7HSch69v0rfLxqmV82OOEEPX+WMCvwvgHj9jRr/tzGE6CNZYVUO67NzGZ9UNLXb3/53dNoIRnwKnw1b7FVtpEA1OgMbKI6YDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770904962; c=relaxed/simple;
	bh=iS+s19X3jjjts8Df2O63rWj3hlfZLHXYx/c7cTEzgEI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=nQ0BmD+9UMxdBG8JSudd0lpPIS4qq51ZJnEJS12BEIobfLz5BLWggS0YP2TfQYZSCWt3dwgDTkIlQ5nKMZWndTfnNsXy8iMyzJqma+2tHHTmEJx6bXe+dfTuaS//SwDFFFewcIyXJeSkBoTsnZIJG3bkCDvC6u/+yCadPcZ6MCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=JDm407du; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61C741v5473751;
	Thu, 12 Feb 2026 14:02:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=tmqPTD
	XRn4fBwC657wa097v50m21rpJjL5kQW52yC6U=; b=JDm407du5dtyjZgys88DD2
	N3eS18wKZhc86+U9mVpJOTq0LpxnVHnAWRjq5Rj7oqzSbXRikpbsloLl9uYi3/y1
	and3Q9SVl4J/bYaA85gukYlV1Xs+HJkQTqknY5NDYBTmvyQCOpK4nrj7zOZmEb4I
	IzMKErdCXc4tvAg3/JdUEfmtP/FhZFLsnjB0aEbeVUwgpITVLzLoHW1CUx6GIPb9
	30DK0bQKc0KTMFOfp8/Huw5AnX2jfx1+V8NjOY3bt1pbFIViPNTjweNDEiNQJh3N
	4LmMuL/RghdTT/0P/1K1nf9ZYG0/nNBMzhUS1FZtWwiABd+RojzXvms4B5OZjjZw
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696x3qvx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Feb 2026 14:02:36 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61CCGKve008404;
	Thu, 12 Feb 2026 14:02:35 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4c6g3yjrt3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Feb 2026 14:02:35 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61CE2VWp61669810
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Feb 2026 14:02:31 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C533E20040;
	Thu, 12 Feb 2026 14:02:31 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 79D4F2004B;
	Thu, 12 Feb 2026 14:02:31 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 12 Feb 2026 14:02:31 +0000 (GMT)
From: Julian Ruess <julianr@linux.ibm.com>
Date: Thu, 12 Feb 2026 15:02:17 +0100
Subject: [PATCH 3/3] MAINTAINERS: add VFIO ISM PCI DRIVER section
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260212-vfio_pci_ism-v1-3-333262ade074@linux.ibm.com>
References: <20260212-vfio_pci_ism-v1-0-333262ade074@linux.ibm.com>
In-Reply-To: <20260212-vfio_pci_ism-v1-0-333262ade074@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=WZYBqkhX c=1 sm=1 tr=0 ts=698ddd7c cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8
 a=VwQbUJbxAAAA:8 a=Ikd4Dj_1AAAA:8 a=N04f8XHk16Uzgq2NRSwA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: vm_oryJQ4MZObU8Y1D8-iHXUu2E0M2me
X-Proofpoint-ORIG-GUID: vm_oryJQ4MZObU8Y1D8-iHXUu2E0M2me
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEyMDEwNCBTYWx0ZWRfX5hZKwaP5Pj6d
 2Qr9xdvlifsUyoju/hVBjA0okCcJizyINBMyQoZ8mbvtLuPDp8C1mAtKPzwzfO1SMsMaIS4BOFE
 V/FOWUOyOQuXRa6fmSp1V5FfasFgfYghf8a7rAywMvKN4BtX9GatEAcaK5NZkyqLwu7aIoP3htT
 kFHEgLSxZ8+cQ+If3+CCk5zVD9gyKZMOf+83oDhMQKYX0Hp0zz9XEyIcIm+o2L5OZqH+iRkSHX0
 /tKd7FvZGdwe3ozg97envwZMbuFBOZtBsC0godOaeWULRWtE2CiyrEP+KulPyQOGDCjs+SBSpmW
 NXSf7IhwRZhae6WR8qPn9Z7+4dGxJ23Y0nw8eH6KxsIX5EGJidKeDCow5YEwVWwAvQFTudHS04O
 3cGfhBS+E+JVE3iKVLQbP1vfN1uvcgknXOmtegQLZ7QynQqCPCmNmn2nGabsmr9WuT4ETzZrt4q
 y5Vk6dt5joLuutWqBkg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-12_04,2026-02-12_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 phishscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 impostorscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602120104
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[21];
	TAGGED_RCPT(0.00)[kvm];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	DKIM_TRACE(0.00)[ibm.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[julianr@linux.ibm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,nvidia.com:email];
	PRECEDENCE_BULK(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70956-lists,kvm=lfdr.de];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: 5B50E12E10F
X-Rspamd-Action: no action

ism_vfio_pci is a new kernel component that allows
to use the ISM device from userspace. Add myself
as a maintainer.

Acked-by: Alexandra Winter <wintera@linux.ibm.com>
Signed-off-by: Julian Ruess <julianr@linux.ibm.com>
---
 MAINTAINERS | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index e087673237636268346979ddc270f8cf0905c722..e9d025ea396e71102463a50b2934827175356da2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -27393,6 +27393,12 @@ L:	kvm@vger.kernel.org
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


