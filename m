Return-Path: <kvm+bounces-70959-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0K8BEIjejWnE8AAAu9opvQ
	(envelope-from <kvm+bounces-70959-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 15:07:04 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 90E2C12E1F3
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 15:07:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 293FF31A737C
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 14:02:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2744235C1A5;
	Thu, 12 Feb 2026 14:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="cEACVcTX"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB10346E5A;
	Thu, 12 Feb 2026 14:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770904968; cv=none; b=JcSF1jCovJhAyUriQzuec00bo3AHnXkklUuT80x+NzoHFFhZsDg7Oduh09LlflYL9oypKiWjdTbyVdMOJ3XaGtUV1pTKAss2hmFNxQtJBj3fxolFvaRRPQG5ujTXubkQD/AaKF+y4E57IIajInEhxOks4if2JaFbEbtwn0CL2EA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770904968; c=relaxed/simple;
	bh=R9x5Z5Kah0FOwz+XsjqJAfOjK2AVQJPUaRi3J+mut2Q=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=UhtGp7e1vEMWp6RwpA+Tn0/iqW9p3T63v8sJ88RWYptkABjf8rgqGqRqafn8P7h9ReHRgLG26GaSHj31JZHQDhQCaEFpfCfEqhj4HtCIwEyXrTq5CA1KsFlmUt/NQcQT4Lw1oFyn8vlh9oUEnMpOdH82hFcgEVS0Nssjz3Axkt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=cEACVcTX; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61CDOJAL3414107;
	Thu, 12 Feb 2026 14:02:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=mhB6RF
	oPQK8dVzbsRqsEX6IfqiK9Fcw9WsnO2/SS6IQ=; b=cEACVcTXq43FhjX/ng0t5b
	pdozQtOsmKEx06Qq7i3e1Hfgu4dUxWBNVckEBry9nbHhFW28uDgBRJH8trgJXrde
	7y4Y+EZrAp0UVy7MyVrODW1uDkmYKCjLBJQveBzrdHImRQffBHkJOFpwjhHGuJB6
	SiD62Sah/l7Db3TnixotSjlZZN03A0UZh66pp8Ydrk7AGUbSLWLfTEDv9CEje7Gn
	1k9SRfaNEX+Bk+WfNzhRAsyFlb8QZUU/ujhUU4f1kyoNyHG1mVQXTDjzjQUXqmcA
	9ymprvZKNPZ2Odup4sbRYIqJtxlmda+PQMd38BYIBc+541gH2z9zDd6rzYQiIASQ
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696vbmvc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Feb 2026 14:02:35 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61C9goXG001837;
	Thu, 12 Feb 2026 14:02:34 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4c6je2ad0b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Feb 2026 14:02:34 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61CE2VSD61669798
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Feb 2026 14:02:31 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0C62A20043;
	Thu, 12 Feb 2026 14:02:31 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BF5F22005A;
	Thu, 12 Feb 2026 14:02:30 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 12 Feb 2026 14:02:30 +0000 (GMT)
From: Julian Ruess <julianr@linux.ibm.com>
Date: Thu, 12 Feb 2026 15:02:15 +0100
Subject: [PATCH 1/3] vfio/pci: Set VFIO_PCI_OFFSET_SHIFT to 48
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260212-vfio_pci_ism-v1-1-333262ade074@linux.ibm.com>
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
X-Proofpoint-GUID: fv3arNPVHzcKc8BmdOyKW6B-d1ksJ0l7
X-Proofpoint-ORIG-GUID: fv3arNPVHzcKc8BmdOyKW6B-d1ksJ0l7
X-Authority-Analysis: v=2.4 cv=JdWxbEKV c=1 sm=1 tr=0 ts=698ddd7b cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8
 a=modniqXMBZv9BQ1X5YgA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEyMDEwNCBTYWx0ZWRfXwLduAeLBOgD0
 s7s1iJarvhbtDEp0HnZR88d8BWjr8OcFYH14Drr2PlzcDTfIQVw8qCjY8K6VaacbxG84SVjxBTD
 M40uX2I35PMDxk1nHEN8ELesZsYrOGnh9C6acIFvUZgk0h+psJ5oNH7WOzReqNmu/qfz5KExg3X
 paJv6mtOkUkLin6zGiPXyNmGa9UneXA7YWF+Jznknv0F8H8u9gF+ZBY65fjOPKu7uZgq/dAYV6o
 TdQrSeobKEbgmcSndVe+0wDaey5LE2QajnfS73DyjmX+BCZHS47l5gaESjH8nHwXlrHQVpDi3lN
 0vB3a3HYn8Yg2fqj2LHu2X+a4yU9hbc9TNwG76i/ZnbS8K6VqV9xwImeWay1+rOkaAgnX9Us5qB
 vVVnxAK7HnU4Lg1gH4KfiOzaENgQYJmdAsSlb3LUFOdA+mHnnDsv5g4KuiT+1zle0gem50pu/zN
 uP3yPyXLq6WWyPjYV5A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-12_04,2026-02-12_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1011 impostorscore=0 bulkscore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602120104
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[11];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[21];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.ibm.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	MID_RHS_MATCH_FROM(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[julianr@linux.ibm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70959-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[ibm.com:+]
X-Rspamd-Queue-Id: 90E2C12E1F3
X-Rspamd-Action: no action

Extend VFIO_PCI_OFFSET_SHIFT to 48 to use the vfio-pci
VFIO_PCI_OFFSET_TO_INDEX() mechanism with the 256 TiB pseudo-BAR 0 of
the ISM device on s390. This bar is never mapped.

Acked-by: Alexandra Winter <wintera@linux.ibm.com>
Signed-off-by: Julian Ruess <julianr@linux.ibm.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 4 ++--
 include/linux/vfio_pci_core.h    | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 3a11e6f450f70105f17a3a621520c195d99e0671..3d70bf6668c7a69c4b46674195954d1ada662006 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1647,7 +1647,7 @@ static unsigned long vma_to_pfn(struct vm_area_struct *vma)
 	u64 pgoff;
 
 	pgoff = vma->vm_pgoff &
-		((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
+		((1UL << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
 
 	return (pci_resource_start(vdev->pdev, index) >> PAGE_SHIFT) + pgoff;
 }
@@ -1751,7 +1751,7 @@ int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma
 	phys_len = PAGE_ALIGN(pci_resource_len(pdev, index));
 	req_len = vma->vm_end - vma->vm_start;
 	pgoff = vma->vm_pgoff &
-		((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
+		((1UL << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
 	req_start = pgoff << PAGE_SHIFT;
 
 	if (req_start + req_len > phys_len)
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 1ac86896875cf5c9b5cc8ef25fae8bbd4394de05..12781707f086a330161990dc3579ec0d75887da8 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -20,7 +20,7 @@
 #ifndef VFIO_PCI_CORE_H
 #define VFIO_PCI_CORE_H
 
-#define VFIO_PCI_OFFSET_SHIFT   40
+#define VFIO_PCI_OFFSET_SHIFT   48
 #define VFIO_PCI_OFFSET_TO_INDEX(off)	(off >> VFIO_PCI_OFFSET_SHIFT)
 #define VFIO_PCI_INDEX_TO_OFFSET(index)	((u64)(index) << VFIO_PCI_OFFSET_SHIFT)
 #define VFIO_PCI_OFFSET_MASK	(((u64)(1) << VFIO_PCI_OFFSET_SHIFT) - 1)

-- 
2.51.0


