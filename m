Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A739C490D03
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 18:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241652AbiAQRA1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 12:00:27 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:16402 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241452AbiAQQ75 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Jan 2022 11:59:57 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20HFRnV6012283
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 16:59:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=quHvre/C7THZuHLZUH655juP4QVuPMDj/Mv7IIkVQ8I=;
 b=QkmkU2mveN404DzrBxUcNiJOXNzK/NVa0JZWM87piO+FYy7alj7ucoSxJfkJY5JTCZCD
 ohB7s9E7If788wPzJPGSu8hTJ1wItQZZQLHvPy4ZePfQ0JjSJ02ydnoxn0ePJ/+XQdUg
 E0a0hamlBQpQ+ZTWRaUah2ure6fKd1KB08a5BlBt/NLqljj2DJFSrwHXkXqlqj2t6MX4
 XY+nJfi+8/SI3YTjlaS0uvllfWOo6xmRNqLUHs17A01ntuf2Z1sSWsx3NtOQ+Wfl/3Z+
 QQcQFA4qq8g1mQn7zt+Pgh+EQD21V62+Swy4zZR61GUVTi0C7jwjPkNk5opfKjF6Omfj BA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dnb4bjj8w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 16:59:57 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20HFhNid003396
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 16:59:56 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dnb4bjj88-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Jan 2022 16:59:56 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20HGl8th019697;
        Mon, 17 Jan 2022 16:59:54 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3dknw9e2th-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Jan 2022 16:59:54 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20HGxpcU26477004
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jan 2022 16:59:51 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5D0BEA405F;
        Mon, 17 Jan 2022 16:59:51 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 12E2EA405C;
        Mon, 17 Jan 2022 16:59:51 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.3.16])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 17 Jan 2022 16:59:50 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 02/13] lib: s390x: sie: Add sca allocation and freeing
Date:   Mon, 17 Jan 2022 17:59:38 +0100
Message-Id: <20220117165949.75964-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220117165949.75964-1-imbrenda@linux.ibm.com>
References: <20220117165949.75964-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: R3GgKAuHDWTuha67OCvLTcFXIekUyqI_
X-Proofpoint-ORIG-GUID: qy_mNy-4sblz551A5tb0yYBiSO5vFoNe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-17_07,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=848 spamscore=0 priorityscore=1501 suspectscore=0
 lowpriorityscore=0 phishscore=0 clxscore=1015 malwarescore=0 mlxscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201170104
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

For protected guests we always need a ESCA so let's add functions to
create and destroy SCAs on demand. We don't have scheduling and I
don't expect multiple VCPU SIE in the next few months so SCA content
handling is not added.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/sie.h |  2 ++
 lib/s390x/sie.c | 12 ++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
index 7ef7251b..f34e3c80 100644
--- a/lib/s390x/sie.h
+++ b/lib/s390x/sie.h
@@ -191,6 +191,7 @@ struct vm_save_area {
 struct vm {
 	struct kvm_s390_sie_block *sblk;
 	struct vm_save_area save_area;
+	void *sca;				/* System Control Area */
 	uint8_t *crycb;				/* Crypto Control Block */
 	/* Ptr to first guest page */
 	uint8_t *guest_mem;
@@ -203,6 +204,7 @@ void sie(struct vm *vm);
 void sie_expect_validity(void);
 void sie_check_validity(uint16_t vir_exp);
 void sie_handle_validity(struct vm *vm);
+void sie_guest_sca_create(struct vm *vm);
 void sie_guest_create(struct vm *vm, uint64_t guest_mem, uint64_t guest_mem_len);
 void sie_guest_destroy(struct vm *vm);
 
diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
index b965b314..51d3b94e 100644
--- a/lib/s390x/sie.c
+++ b/lib/s390x/sie.c
@@ -55,6 +55,16 @@ void sie(struct vm *vm)
 	vm->save_area.guest.grs[15] = vm->sblk->gg15;
 }
 
+void sie_guest_sca_create(struct vm *vm)
+{
+	vm->sca = (struct esca_block *)alloc_page();
+
+	/* Let's start out with one page of ESCA for now */
+	vm->sblk->scaoh = ((uint64_t)vm->sca >> 32);
+	vm->sblk->scaol = (uint64_t)vm->sca & ~0x3fU;
+	vm->sblk->ecb2 |= ECB2_ESCA;
+}
+
 /* Initializes the struct vm members like the SIE control block. */
 void sie_guest_create(struct vm *vm, uint64_t guest_mem, uint64_t guest_mem_len)
 {
@@ -80,4 +90,6 @@ void sie_guest_destroy(struct vm *vm)
 {
 	free_page(vm->crycb);
 	free_page(vm->sblk);
+	if (vm->sblk->ecb2 & ECB2_ESCA)
+		free_page(vm->sca);
 }
-- 
2.31.1

