Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8941C35CAC2
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 18:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243247AbhDLQGP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 12:06:15 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:26060 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241389AbhDLQGM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 12 Apr 2021 12:06:12 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13CG4R8E096038;
        Mon, 12 Apr 2021 12:05:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=Y3jtG5hK2ytzk/S35RYFm/c5e40U/zxnQaDZ4uv+0ks=;
 b=QMhZts1tpqgktLj3LptIWZUm0eLhVj1p9JrPmNh7fAcP8tKlDi88bnRfo0/t42iCVqI7
 lHLBuUorRbq2oWjaSxw71vn3N7bRsFhq9TAimP3FC6lzSjwbc/l6ikHGTGTduJFG8FUW
 pmhPb2VWzZZiqFDB2NWv6wNCjvcKahOvSvbqeOPQju2r/Sbz3VdAPAAmyepvn4EsCn//
 jEc8BW2pe1x3tUjCIFPdKeFIqwcFjYzT3wchNt0SVs14cLnt5n1X2eve89+lrew8AM3T
 SK7SIZkrWXNxC7DtOaRI+TLNV6Yihr7lCGx9UIxFy1RUm1tjSkkpP59HurmlBGvXS/nF xg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37vkde6tq0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 12:05:54 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13CG4hnj097443;
        Mon, 12 Apr 2021 12:05:53 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37vkde6tn8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 12:05:53 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13CFplO5001182;
        Mon, 12 Apr 2021 16:05:51 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 37u39hhy7y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 16:05:51 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13CG5mPp44237142
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Apr 2021 16:05:48 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0ECCC4204B;
        Mon, 12 Apr 2021 16:05:48 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E8CA542047;
        Mon, 12 Apr 2021 16:05:47 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 12 Apr 2021 16:05:47 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id A384AE02A6; Mon, 12 Apr 2021 18:05:47 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [GIT PULL 5/7] KVM: s390: VSIE: correctly handle MVPG when in VSIE
Date:   Mon, 12 Apr 2021 18:05:43 +0200
Message-Id: <20210412160545.231194-6-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412160545.231194-1-borntraeger@de.ibm.com>
References: <20210412160545.231194-1-borntraeger@de.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: mIOhfHlOZYC7qQVjHLjFTh_dzOMhRGr5
X-Proofpoint-ORIG-GUID: G-nMk1KXIsMfJowODLjb922TDihrIxXU
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

Correctly handle the MVPG instruction when issued by a VSIE guest.

Fixes: a3508fbe9dc6d ("KVM: s390: vsie: initial support for nested virtualization")
Cc: stable@vger.kernel.org # f85f1baaa189: KVM: s390: split kvm_s390_logical_to_effective
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
Link: https://lore.kernel.org/r/20210302174443.514363-4-imbrenda@linux.ibm.com
[borntraeger@de.ibm.com: apply fixup from Claudio]
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/kvm/vsie.c | 98 +++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 93 insertions(+), 5 deletions(-)

diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 78b604326016..7f7ac3040a16 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -417,11 +417,6 @@ static void unshadow_scb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 		memcpy((void *)((u64)scb_o + 0xc0),
 		       (void *)((u64)scb_s + 0xc0), 0xf0 - 0xc0);
 		break;
-	case ICPT_PARTEXEC:
-		/* MVPG only */
-		memcpy((void *)((u64)scb_o + 0xc0),
-		       (void *)((u64)scb_s + 0xc0), 0xd0 - 0xc0);
-		break;
 	}
 
 	if (scb_s->ihcpu != 0xffffU)
@@ -983,6 +978,95 @@ static int handle_stfle(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 	return 0;
 }
 
+/*
+ * Get a register for a nested guest.
+ * @vcpu the vcpu of the guest
+ * @vsie_page the vsie_page for the nested guest
+ * @reg the register number, the upper 4 bits are ignored.
+ * returns: the value of the register.
+ */
+static u64 vsie_get_register(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page, u8 reg)
+{
+	/* no need to validate the parameter and/or perform error handling */
+	reg &= 0xf;
+	switch (reg) {
+	case 15:
+		return vsie_page->scb_s.gg15;
+	case 14:
+		return vsie_page->scb_s.gg14;
+	default:
+		return vcpu->run->s.regs.gprs[reg];
+	}
+}
+
+static int vsie_handle_mvpg(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
+{
+	struct kvm_s390_sie_block *scb_s = &vsie_page->scb_s;
+	unsigned long pei_dest, pei_src, src, dest, mask;
+	u64 *pei_block = &vsie_page->scb_o->mcic;
+	int edat, rc_dest, rc_src;
+	union ctlreg0 cr0;
+
+	cr0.val = vcpu->arch.sie_block->gcr[0];
+	edat = cr0.edat && test_kvm_facility(vcpu->kvm, 8);
+	mask = _kvm_s390_logical_to_effective(&scb_s->gpsw, PAGE_MASK);
+
+	dest = vsie_get_register(vcpu, vsie_page, scb_s->ipb >> 20) & mask;
+	src = vsie_get_register(vcpu, vsie_page, scb_s->ipb >> 16) & mask;
+
+	rc_dest = kvm_s390_shadow_fault(vcpu, vsie_page->gmap, dest, &pei_dest);
+	rc_src = kvm_s390_shadow_fault(vcpu, vsie_page->gmap, src, &pei_src);
+	/*
+	 * Either everything went well, or something non-critical went wrong
+	 * e.g. because of a race. In either case, simply retry.
+	 */
+	if (rc_dest == -EAGAIN || rc_src == -EAGAIN || (!rc_dest && !rc_src)) {
+		retry_vsie_icpt(vsie_page);
+		return -EAGAIN;
+	}
+	/* Something more serious went wrong, propagate the error */
+	if (rc_dest < 0)
+		return rc_dest;
+	if (rc_src < 0)
+		return rc_src;
+
+	/* The only possible suppressing exception: just deliver it */
+	if (rc_dest == PGM_TRANSLATION_SPEC || rc_src == PGM_TRANSLATION_SPEC) {
+		clear_vsie_icpt(vsie_page);
+		rc_dest = kvm_s390_inject_program_int(vcpu, PGM_TRANSLATION_SPEC);
+		WARN_ON_ONCE(rc_dest);
+		return 1;
+	}
+
+	/*
+	 * Forward the PEI intercept to the guest if it was a page fault, or
+	 * also for segment and region table faults if EDAT applies.
+	 */
+	if (edat) {
+		rc_dest = rc_dest == PGM_ASCE_TYPE ? rc_dest : 0;
+		rc_src = rc_src == PGM_ASCE_TYPE ? rc_src : 0;
+	} else {
+		rc_dest = rc_dest != PGM_PAGE_TRANSLATION ? rc_dest : 0;
+		rc_src = rc_src != PGM_PAGE_TRANSLATION ? rc_src : 0;
+	}
+	if (!rc_dest && !rc_src) {
+		pei_block[0] = pei_dest;
+		pei_block[1] = pei_src;
+		return 1;
+	}
+
+	retry_vsie_icpt(vsie_page);
+
+	/*
+	 * The host has edat, and the guest does not, or it was an ASCE type
+	 * exception. The host needs to inject the appropriate DAT interrupts
+	 * into the guest.
+	 */
+	if (rc_dest)
+		return inject_fault(vcpu, rc_dest, dest, 1);
+	return inject_fault(vcpu, rc_src, src, 0);
+}
+
 /*
  * Run the vsie on a shadow scb and a shadow gmap, without any further
  * sanity checks, handling SIE faults.
@@ -1071,6 +1155,10 @@ static int do_vsie_run(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 		if ((scb_s->ipa & 0xf000) != 0xf000)
 			scb_s->ipa += 0x1000;
 		break;
+	case ICPT_PARTEXEC:
+		if (scb_s->ipa == 0xb254)
+			rc = vsie_handle_mvpg(vcpu, vsie_page);
+		break;
 	}
 	return rc;
 }
-- 
2.30.2

