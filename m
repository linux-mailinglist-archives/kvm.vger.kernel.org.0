Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6F1E440E0D
	for <lists+kvm@lfdr.de>; Sun, 31 Oct 2021 13:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231841AbhJaMNq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Oct 2021 08:13:46 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41940 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230505AbhJaMNn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 31 Oct 2021 08:13:43 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19VC7kQe030854;
        Sun, 31 Oct 2021 12:11:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=FJQiPSf7T9iBe/i8m8JrkcuN86jHLYpPfivxszgvt+o=;
 b=EOzHqqr1ejWvAb9PL/6SOAWXDDDquJrh0JENNNe6J6pvdEZvxIHFsilWDQxFWSC4D6mk
 8Jj82UgRBJnkvIv4CrUaIp3Yo0aoBUlFYH2SzlIXvC3jG/+RSUyVSEpt8/6wJUvHS+/d
 jz+3IvrSUavUe1z8CcvwYTkx3tGkUYldE8hQBFi6GD7e5xMEmSDpQ+sEhzP9CVLzPE41
 UO/lvMFaN6IzE6ZIKXh8Nq6J7kfOk1iYw2ignuPyHk7I5xNSu42IdcLevIAoNtQ3WdBJ
 SWLQJZYfT/s5ulA30K4rTE3bUTLIVygeiW15I1DNPEE9eS1g9mWFC10lYvQVKYUrXoBk qA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c1tk2g5tv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 31 Oct 2021 12:11:12 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19VCAjZ7011488;
        Sun, 31 Oct 2021 12:11:11 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c1tk2g5tg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 31 Oct 2021 12:11:11 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19VC8ssG008838;
        Sun, 31 Oct 2021 12:11:09 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3c0wpa57qf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 31 Oct 2021 12:11:09 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19VCB5ri7209246
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 31 Oct 2021 12:11:05 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AA531A404D;
        Sun, 31 Oct 2021 12:11:05 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 937C6A4040;
        Sun, 31 Oct 2021 12:11:05 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Sun, 31 Oct 2021 12:11:05 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 32379E056B; Sun, 31 Oct 2021 13:11:05 +0100 (CET)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [GIT PULL 02/17] s390/gmap: don't unconditionally call pte_unmap_unlock() in __gmap_zap()
Date:   Sun, 31 Oct 2021 13:10:49 +0100
Message-Id: <20211031121104.14764-3-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211031121104.14764-1-borntraeger@de.ibm.com>
References: <20211031121104.14764-1-borntraeger@de.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: g4QWBiCFeqcWMCt73YPjrQUbuXT5MVze
X-Proofpoint-ORIG-GUID: X_1ioAIfF0cGeZJ-BEopd7Jl2-KsUzEB
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-31_03,2021-10-29_03,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 spamscore=0 lowpriorityscore=0 malwarescore=0
 impostorscore=0 phishscore=0 adultscore=0 suspectscore=0 bulkscore=0
 clxscore=1015 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110310076
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Hildenbrand <david@redhat.com>

... otherwise we will try unlocking a spinlock that was never locked via a
garbage pointer.

At the time we reach this code path, we usually successfully looked up
a PGSTE already; however, evil user space could have manipulated the VMA
layout in the meantime and triggered removal of the page table.

Fixes: 1e133ab296f3 ("s390/mm: split arch/s390/mm/pgtable.c")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Link: https://lore.kernel.org/r/20210909162248.14969-3-david@redhat.com
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/mm/gmap.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index e0735c343775..d63c0ccc5ccd 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -689,9 +689,10 @@ void __gmap_zap(struct gmap *gmap, unsigned long gaddr)
 
 		/* Get pointer to the page table entry */
 		ptep = get_locked_pte(gmap->mm, vmaddr, &ptl);
-		if (likely(ptep))
+		if (likely(ptep)) {
 			ptep_zap_unused(gmap->mm, vmaddr, ptep, 0);
-		pte_unmap_unlock(ptep, ptl);
+			pte_unmap_unlock(ptep, ptl);
+		}
 	}
 }
 EXPORT_SYMBOL_GPL(__gmap_zap);
-- 
2.31.1

