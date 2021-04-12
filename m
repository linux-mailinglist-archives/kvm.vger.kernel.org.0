Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35C2D35CAC5
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 18:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243271AbhDLQGU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 12:06:20 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:50522 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243029AbhDLQGN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 12 Apr 2021 12:06:13 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13CG4TZ9096166;
        Mon, 12 Apr 2021 12:05:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=XWukzKHouwENk+ZAOMS2P00MOL4A7omZu7fsqrZ7ChA=;
 b=NRjOJbIEDJdYsEJLtH9mfY+BQoZCSsQulbt281EuANx8Za9s669QY/jLUKqhWLatuefA
 YBALg4/UkuQfGeSNmhKJwJD+1Ge+oq8ghNQxxTW6hr8DMvt30uz5swYRZKhRtal3uBx9
 8q2X/p8y0i6kTQIe8DvcuXFVjrAy3peVQ1m9kQmFwVRIomG2oTN0nLSSrZqq9e+2eliN
 jpmeB6YcJeaJleYDoFZxpgW/1EYFVg9YCfw3pFXBnIMsyTlAm7WCf2DQ1dVOS3ialp4M
 oYG4HlN1r3hTgouzMFzK5yFOJ+wv0oxrsbRRj3P68ZNx8NBIx/1wlMEWdTvTmBh2A81R pQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37vkde6tq7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 12:05:54 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13CG5NcV103142;
        Mon, 12 Apr 2021 12:05:53 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37vkde6tne-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 12:05:53 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13CFpvCY029685;
        Mon, 12 Apr 2021 16:05:51 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 37u3n89y1u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 16:05:51 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13CG5mIW51249638
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Apr 2021 16:05:48 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 81C24AE057;
        Mon, 12 Apr 2021 16:05:48 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 707CBAE045;
        Mon, 12 Apr 2021 16:05:48 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 12 Apr 2021 16:05:48 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 358F8E02A6; Mon, 12 Apr 2021 18:05:48 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [GIT PULL 7/7] KVM: s390: VSIE: fix MVPG handling for prefixing and MSO
Date:   Mon, 12 Apr 2021 18:05:45 +0200
Message-Id: <20210412160545.231194-8-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412160545.231194-1-borntraeger@de.ibm.com>
References: <20210412160545.231194-1-borntraeger@de.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 1Qf9rTHETdS4zU6ojbEdqVU1IBw2oYOL
X-Proofpoint-ORIG-GUID: lMTqe5GRD9bv6bRyyuyQjkgpLam0XpEA
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-12_11:2021-04-12,2021-04-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 suspectscore=0 adultscore=0 impostorscore=0 priorityscore=1501
 malwarescore=0 spamscore=0 clxscore=1015 bulkscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104120102
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

Prefixing needs to be applied to the guest real address to translate it
into a guest absolute address.

The value of MSO needs to be added to a guest-absolute address in order to
obtain the host-virtual.

Fixes: bdf7509bbefa ("s390/kvm: VSIE: correctly handle MVPG when in VSIE")
Reported-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210322140559.500716-3-imbrenda@linux.ibm.com
[borntraeger@de.ibm.com simplify mso]
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/kvm/vsie.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 7f7ac3040a16..4002a24bc43a 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -1002,7 +1002,7 @@ static u64 vsie_get_register(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page,
 static int vsie_handle_mvpg(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 {
 	struct kvm_s390_sie_block *scb_s = &vsie_page->scb_s;
-	unsigned long pei_dest, pei_src, src, dest, mask;
+	unsigned long pei_dest, pei_src, src, dest, mask, prefix;
 	u64 *pei_block = &vsie_page->scb_o->mcic;
 	int edat, rc_dest, rc_src;
 	union ctlreg0 cr0;
@@ -1010,9 +1010,12 @@ static int vsie_handle_mvpg(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 	cr0.val = vcpu->arch.sie_block->gcr[0];
 	edat = cr0.edat && test_kvm_facility(vcpu->kvm, 8);
 	mask = _kvm_s390_logical_to_effective(&scb_s->gpsw, PAGE_MASK);
+	prefix = scb_s->prefix << GUEST_PREFIX_SHIFT;
 
 	dest = vsie_get_register(vcpu, vsie_page, scb_s->ipb >> 20) & mask;
+	dest = _kvm_s390_real_to_abs(prefix, dest) + scb_s->mso;
 	src = vsie_get_register(vcpu, vsie_page, scb_s->ipb >> 16) & mask;
+	src = _kvm_s390_real_to_abs(prefix, src) + scb_s->mso;
 
 	rc_dest = kvm_s390_shadow_fault(vcpu, vsie_page->gmap, dest, &pei_dest);
 	rc_src = kvm_s390_shadow_fault(vcpu, vsie_page->gmap, src, &pei_src);
-- 
2.30.2

