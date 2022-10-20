Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6136D605A6D
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 11:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbiJTJBS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 05:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbiJTJBM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 05:01:12 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2B8F17999F
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 02:01:10 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29K8ckh4024523
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 09:01:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=uUzX15mnK6AvromgOewf8Lqoj0s9WKzVaSAXFcvhph0=;
 b=sODe3himFX0ncskr1urIJxaq+Y2ZY3FkVWHXFINHMgxNmmAHc3CtbLJzBejlL2BD6hSf
 w7XkcZMMGAonp5JyG0d/e4NMkRNnJcgcZ/j2f3IMC51V7eKwW1iD0zKs4aMDpjkz9wLW
 vc/cfZkHiotbV7T0E0Uc7OLUIBC8HrKbxt103AhJNTt0ka4+fvkYaMBWYYV/K8yHyNvm
 OwwZf30b2k24JwMYFYfW4H9NdyyT7Kkdyn/jA6V7aQEhsnTJwahm91eVXvORY5vNcztc
 aCc+XhXLBLauxX8AclgQa6w0DWZTK9QmczyoQx64HWzb9mlLK9rWL9eOfXg0fs4Pb/tR DA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kb29q20kj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 09:01:09 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29K8fJCW001946
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 09:01:09 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kb29q20j8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 09:01:09 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29K8oWx7030777;
        Thu, 20 Oct 2022 09:01:07 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 3k7mg9eemv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 09:01:07 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29K914WQ3736182
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Oct 2022 09:01:04 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3675F4203F;
        Thu, 20 Oct 2022 09:01:04 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7DCA942049;
        Thu, 20 Oct 2022 09:01:03 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 20 Oct 2022 09:01:03 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 6/7] lib: s390x: Enable reusability of VMs that were in PV mode
Date:   Thu, 20 Oct 2022 09:00:08 +0000
Message-Id: <20221020090009.2189-7-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221020090009.2189-1-frankja@linux.ibm.com>
References: <20221020090009.2189-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: zplu6VWwaCy_RVMAGivglUifweGUDMUU
X-Proofpoint-GUID: tt4mwpp302hAPIcMBUsf80xsEqlSB-8b
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-20_02,2022-10-19_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 malwarescore=0 phishscore=0 impostorscore=0 clxscore=1015 mlxlogscore=999
 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210200049
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Convert the sblk to non-PV when the PV guest is destroyed.

Early return in uv_init() instead of running into the assert. This is
necessary since snippet_pv_init() will always call uv_init().

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/uv.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/uv.c b/lib/s390x/uv.c
index 0b6eb843..99775929 100644
--- a/lib/s390x/uv.c
+++ b/lib/s390x/uv.c
@@ -76,7 +76,8 @@ void uv_init(void)
 	int cc;
 
 	/* Let's not do this twice */
-	assert(!initialized);
+	if (initialized)
+		return;
 	/* Query is done on initialization but let's check anyway */
 	assert(uvcb_qui.header.rc == 1 || uvcb_qui.header.rc == 0x100);
 
@@ -188,6 +189,14 @@ void uv_destroy_guest(struct vm *vm)
 	free_pages(vm->uv.conf_var_stor);
 
 	free_pages((void *)(vm->uv.asce & PAGE_MASK));
+	memset(&vm->uv, 0, sizeof(vm->uv));
+
+	/* Convert the sblk back to non-PV */
+	vm->save_area.guest.asce = stctg(1);
+	vm->sblk->sdf = 0;
+	vm->sblk->sidad = 0;
+	vm->sblk->pv_handle_cpu = 0;
+	vm->sblk->pv_handle_config = 0;
 }
 
 int uv_unpack(struct vm *vm, uint64_t addr, uint64_t len, uint64_t tweak)
-- 
2.34.1

