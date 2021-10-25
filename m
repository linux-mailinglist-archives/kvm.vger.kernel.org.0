Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D701439039
	for <lists+kvm@lfdr.de>; Mon, 25 Oct 2021 09:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231418AbhJYHWM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Oct 2021 03:22:12 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:3258 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231133AbhJYHWJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 Oct 2021 03:22:09 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19P3qPHp010969;
        Mon, 25 Oct 2021 03:19:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=r9NZASqRXXwCsirGPISArBmLj+26uqiuuX2sxpyOTZA=;
 b=N5bygwkZXNQkGz4MB8xQBGJ3J2PjwFdRYz1OvASvVzwsxkUNVXrlA2z29mJHqm2hWPHo
 Fdx3YUt4CHPiTQG5t+sMK+41LbI4QShZu7xYqJn6JKVCTHzp0i5FsJHvAB/tz2aCL6Li
 8AreWem4y161h25RJRMaznE0F37zmUwX0GvmG8zrtx3493sJsqTdMjITaD26qyDBLRDv
 c7pBAWhTvZuB7tNRhW0gHsdTe20jmb9RK2gjPA8jGhYDnauGVZDLyLc7LPpkoL322Xxx
 YoKuPcZp0yoUH0UdoBgqzRsU8weKDILEHuEPjMF8APG8oLqkko1tRJ+ySk5KsM1lpEdZ Vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bw008aemu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 03:19:47 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19P74QNn005089;
        Mon, 25 Oct 2021 03:19:47 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bw008aem6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 03:19:46 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19P7IpHp007813;
        Mon, 25 Oct 2021 07:19:44 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06fra.de.ibm.com with ESMTP id 3bv9njhfpt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 07:19:44 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19P7Jf0O3539466
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Oct 2021 07:19:41 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2A8D64C05A;
        Mon, 25 Oct 2021 07:19:41 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 171614C04A;
        Mon, 25 Oct 2021 07:19:41 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 25 Oct 2021 07:19:41 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id BCD3CE079A; Mon, 25 Oct 2021 09:19:40 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [GIT PULL 1/2] KVM: s390: clear kicked_mask before sleeping again
Date:   Mon, 25 Oct 2021 09:19:39 +0200
Message-Id: <20211025071940.43696-2-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211025071940.43696-1-borntraeger@de.ibm.com>
References: <20211025071940.43696-1-borntraeger@de.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: AMnyj63fI-dQ8Tej6Ex0q2TqNkWxZaXA
X-Proofpoint-ORIG-GUID: NS6LsRFGkgRFVjq_zT5UtUvHoKVOsBxb
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-25_02,2021-10-25_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 mlxscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0
 priorityscore=1501 phishscore=0 adultscore=0 impostorscore=0 clxscore=1015
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110250040
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Halil Pasic <pasic@linux.ibm.com>

The idea behind kicked mask is that we should not re-kick a vcpu that
is already in the "kick" process, i.e. that was kicked and is
is about to be dispatched if certain conditions are met.

The problem with the current implementation is, that it assumes the
kicked vcpu is going to enter SIE shortly. But under certain
circumstances, the vcpu we just kicked will be deemed non-runnable and
will remain in wait state. This can happen, if the interrupt(s) this
vcpu got kicked to deal with got already cleared (because the interrupts
got delivered to another vcpu). In this case kvm_arch_vcpu_runnable()
would return false, and the vcpu would remain in kvm_vcpu_block(),
but this time with its kicked_mask bit set. So next time around we
wouldn't kick the vcpu form __airqs_kick_single_vcpu(), but would assume
that we just kicked it.

Let us make sure the kicked_mask is cleared before we give up on
re-dispatching the vcpu.

Fixes: 9f30f6216378 ("KVM: s390: add gib_alert_irq_handler()")
Reported-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Michael Mueller <mimu@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20211019175401.3757927-2-pasic@linux.ibm.com
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 6a6dd5e1daf6..1c97493d21e1 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3363,6 +3363,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
 {
+	clear_bit(vcpu->vcpu_idx, vcpu->kvm->arch.gisa_int.kicked_mask);
 	return kvm_s390_vcpu_has_irq(vcpu, 0);
 }
 
-- 
2.31.1

