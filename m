Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C84ED638A70
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 13:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbiKYMnO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Nov 2022 07:43:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiKYMnG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Nov 2022 07:43:06 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2116E1AD82;
        Fri, 25 Nov 2022 04:43:06 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2APCUirf030028;
        Fri, 25 Nov 2022 12:43:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=+uY/OZp6eg3uryq+aZ4IgnmE9i65ExmVwY3dTPcN7zw=;
 b=CAdaG4brvEE/S7rFVxxttzI6aL8oimBfxlqjGmNqpciVBzvwu0A0SSjD81s6ty4Rzthj
 RjHMXn8BWV2pjbtKEZYFfo8wqX/M4jhOW2EGiVvAsuGmdtd6PM4lWN7nQKSfiNWMIX1+
 rzT9Sef1066+gl1LgyaDXobRUGkfKCbi+bSUpBeND+yHe0DRBDuFcflFtcK6I7+XKY7u
 0gOQ9wHrFVT4LhZBu9+u/QaWRVYD3iT0mD7bYuiH7+TMu0fDbUz735TWpNv+JMK5C2qW
 H0VLtymIPhQjCWUfNcINWSz73409B78yjYzc2LITJeQaVXYdAkJBSPQlpbSFJvB2Zsv1 Mw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m2wsc86bw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Nov 2022 12:43:04 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2APCYHd7006947;
        Fri, 25 Nov 2022 12:43:04 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m2wsc86bd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Nov 2022 12:43:04 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2APCZF91019572;
        Fri, 25 Nov 2022 12:43:02 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04fra.de.ibm.com with ESMTP id 3kxps8xx20-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Nov 2022 12:43:02 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2APChfdh328340
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Nov 2022 12:43:41 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 405F64C044;
        Fri, 25 Nov 2022 12:42:59 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B9A8A4C046;
        Fri, 25 Nov 2022 12:42:58 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.171.63.115])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 25 Nov 2022 12:42:58 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        Nico Boehr <nrb@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [GIT PULL 06/15] KVM: s390: VSIE: sort out virtual/physical address in pin_guest_page
Date:   Fri, 25 Nov 2022 13:39:38 +0100
Message-Id: <20221125123947.31047-7-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221125123947.31047-1-frankja@linux.ibm.com>
References: <20221125123947.31047-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: gyivZyQ_sRV0KuLeraCKWe_CqyMtmMES
X-Proofpoint-ORIG-GUID: 1qsa1D--YuJ6up6Jph2YkvGoAT7h_nG6
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-25_04,2022-11-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 malwarescore=0 spamscore=0 mlxscore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 priorityscore=1501 impostorscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211250098
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nico Boehr <nrb@linux.ibm.com>

pin_guest_page() used page_to_virt() to calculate the hpa of the pinned
page. This currently works, because virtual and physical addresses are
the same. Use page_to_phys() instead to resolve the virtual-real address
confusion.

One caller of pin_guest_page() actually expected the hpa to be a hva, so
add the missing phys_to_virt() conversion here.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Link: https://lore.kernel.org/r/20221025082039.117372-2-nrb@linux.ibm.com
Message-Id: <20221025082039.117372-2-nrb@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/vsie.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 94138f8f0c1c..0e9d020d7093 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -654,7 +654,7 @@ static int pin_guest_page(struct kvm *kvm, gpa_t gpa, hpa_t *hpa)
 	page = gfn_to_page(kvm, gpa_to_gfn(gpa));
 	if (is_error_page(page))
 		return -EINVAL;
-	*hpa = (hpa_t) page_to_virt(page) + (gpa & ~PAGE_MASK);
+	*hpa = (hpa_t)page_to_phys(page) + (gpa & ~PAGE_MASK);
 	return 0;
 }
 
@@ -869,7 +869,7 @@ static int pin_scb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page,
 		WARN_ON_ONCE(rc);
 		return 1;
 	}
-	vsie_page->scb_o = (struct kvm_s390_sie_block *) hpa;
+	vsie_page->scb_o = phys_to_virt(hpa);
 	return 0;
 }
 
-- 
2.38.1

