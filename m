Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94CFDFB210
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 15:03:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727406AbfKMODm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 09:03:42 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31048 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726190AbfKMODm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Nov 2019 09:03:42 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xADE06Xj090710
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2019 09:03:40 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2w8j0fbgpm-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2019 09:03:39 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Wed, 13 Nov 2019 14:02:01 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 13 Nov 2019 14:01:59 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xADE1xCB47120574
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 14:01:59 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EDBF3A4062;
        Wed, 13 Nov 2019 14:01:58 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CA9F2A405F;
        Wed, 13 Nov 2019 14:01:57 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.152.224.131])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 Nov 2019 14:01:57 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com
Subject: [PATCH] Fix unpack
Date:   Wed, 13 Nov 2019 09:03:06 -0500
X-Mailer: git-send-email 2.20.1
In-Reply-To: <07705597-8e8f-28d4-f9a1-d3d5dc9a4555@redhat.com>
References: <07705597-8e8f-28d4-f9a1-d3d5dc9a4555@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19111314-0008-0000-0000-0000032EAE77
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111314-0009-0000-0000-00004A4DB88A
Message-Id: <20191113140306.2952-1-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-13_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=797 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911130130
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

That should be easier to read :)

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/pv.c | 60 +++++++++++++++++++++++++++-------------------
 1 file changed, 35 insertions(+), 25 deletions(-)

diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 94cf16f40f25..fd73afb33b20 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -195,43 +195,53 @@ int kvm_s390_pv_set_sec_parms(struct kvm *kvm,
 	return 0;
 }
 
-int kvm_s390_pv_unpack(struct kvm *kvm, unsigned long addr, unsigned long size,
-		       unsigned long tweak)
+static int unpack_one(struct kvm *kvm, unsigned long addr, u64 tweak[2])
 {
-	int i, rc = 0;
+	int rc;
 	struct uv_cb_unp uvcb = {
 		.header.cmd = UVC_CMD_UNPACK_IMG,
 		.header.len = sizeof(uvcb),
 		.guest_handle = kvm_s390_pv_handle(kvm),
-		.tweak[0] = tweak
+		.gaddr = addr,
+		.tweak[0] = tweak[0],
+		.tweak[1] = tweak[1],
 	};
 
-	if (addr & ~PAGE_MASK || size & ~PAGE_MASK)
-		return -EINVAL;
+	rc = uv_call(0, (u64)&uvcb);
+	if (!rc)
+		return rc;
+	if (uvcb.header.rc == 0x10a) {
+		/* If not yet mapped fault and retry */
+		rc = gmap_fault(kvm->arch.gmap, uvcb.gaddr,
+				FAULT_FLAG_WRITE);
+		if (!rc)
+			return -EAGAIN;
+	}
+	VM_EVENT(kvm, 3, "PROTVIRT VM UNPACK: failed addr %llx rc %x rrc %x",
+		 uvcb.gaddr, uvcb.header.rc, uvcb.header.rrc);
+	return rc;
+}
 
+int kvm_s390_pv_unpack(struct kvm *kvm, unsigned long addr, unsigned long size,
+		       unsigned long tweak)
+{
+	int rc = 0;
+	u64 tw[2] = {tweak, 0};
+
+	if (addr & ~PAGE_MASK || !size || size & ~PAGE_MASK)
+		return -EINVAL;
 
 	VM_EVENT(kvm, 3, "PROTVIRT VM UNPACK: start addr %lx size %lx",
 		 addr, size);
-	for (i = 0; i < size / PAGE_SIZE; i++) {
-		uvcb.gaddr = addr + i * PAGE_SIZE;
-		uvcb.tweak[1] = i * PAGE_SIZE;
-retry:
-		rc = uv_call(0, (u64)&uvcb);
-		if (!rc)
+	while (tw[1] < size) {
+		rc = unpack_one(kvm, addr, tw);
+		if (rc == -EAGAIN)
 			continue;
-		/* If not yet mapped fault and retry */
-		if (uvcb.header.rc == 0x10a) {
-			rc = gmap_fault(kvm->arch.gmap, uvcb.gaddr,
-					FAULT_FLAG_WRITE);
-			if (rc)
-				return rc;
-			goto retry;
-		}
-		VM_EVENT(kvm, 3, "PROTVIRT VM UNPACK: failed addr %llx rc %x rrc %x",
-			 uvcb.gaddr, uvcb.header.rc, uvcb.header.rrc);
-		break;
+		if (rc)
+			break;
+		addr += PAGE_SIZE;
+		tw[1] += PAGE_SIZE;
 	}
-	VM_EVENT(kvm, 3, "PROTVIRT VM UNPACK: finished with rc %x rrc %x",
-		 uvcb.header.rc, uvcb.header.rrc);
+	VM_EVENT(kvm, 3, "PROTVIRT VM UNPACK: finished rc %x", rc);
 	return rc;
 }
-- 
2.20.1

