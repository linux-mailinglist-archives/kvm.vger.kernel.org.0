Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86B6252A839
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 18:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351027AbiEQQhO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 12:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350995AbiEQQhA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 12:37:00 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C24972DA83;
        Tue, 17 May 2022 09:36:59 -0700 (PDT)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HGPTeU031650;
        Tue, 17 May 2022 16:36:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Em4AmOowG46albKW1Z4OcSlANVYsZUFrClZGhbSMr1k=;
 b=C/ioXHzZHlfjCwMCtFjThi19RjnuwLcjoSC4Pwyh1BKH+FUjk7Ro4NRjcS0PELfkpBP3
 cFX/JCLKpHsUDcEq87xkoavGpYP8pWNvFYSdgZZ78RNiUMrTRO1/rq/0xAhhtNHW88ww
 dL68MpqZlpNaSon4UjONf2jvNaJMA2cN2rQlq/Ox70s3ryMOOJWmuQHpAK6AEd66gr30
 TGxQEW78ReSDBm2STgOiJWFQfJm6r47jwXJqdl1B15P/RLmwD/2Fj5EsRuW2P27asVsI
 qCcJ+cLjrmqYPCzYke8fUZXzhoH1lbgdH9DInq1vzWFBKDHz0i7b2S33cdK0Mdw2q4p+ aQ== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4f7d0ah7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 16:36:58 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24HGY7M7030319;
        Tue, 17 May 2022 16:36:57 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3g23pjchg8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 16:36:56 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24HGasNa25166326
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 16:36:54 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1013911C050;
        Tue, 17 May 2022 16:36:54 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7E0F211C04A;
        Tue, 17 May 2022 16:36:53 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 17 May 2022 16:36:53 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, borntraeger@linux.ibm.com,
        imbrenda@linux.ibm.com
Subject: [PATCH v6 11/11] Documentation/virt/kvm/api.rst: Explain rc/rrc delivery
Date:   Tue, 17 May 2022 16:36:29 +0000
Message-Id: <20220517163629.3443-12-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220517163629.3443-1-frankja@linux.ibm.com>
References: <20220517163629.3443-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: efB-_4SnB61P-rSM6V7Mxe5B6vK8lTLt
X-Proofpoint-ORIG-GUID: efB-_4SnB61P-rSM6V7Mxe5B6vK8lTLt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-17_03,2022-05-17_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 mlxlogscore=841 spamscore=0 adultscore=0 bulkscore=0
 phishscore=0 mlxscore=0 suspectscore=0 malwarescore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205170101
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's explain in which situations the rc/rrc will set in struct
kvm_pv_cmd so it's clear that the struct members should be set to
0. rc/rrc are independent of the IOCTL return code.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 Documentation/virt/kvm/api.rst | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 06d1b717b032..7b0993e4106f 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5067,6 +5067,14 @@ into ESA mode. This reset is a superset of the initial reset.
 	__u32 reserved[3];
   };
 
+**Ultravisor return codes**
+The Ultravisor return (reason) codes are provided by the kernel if a
+Ultravisor call has been executed to achieve the results expected by
+the command. Therefore they are independent of the IOCTL return
+code. If KVM changes `rc`, its value will always be greater than 0
+hence setting it to 0 before issuing a PV command is advised to be
+able to detect a change of `rc`.
+
 **cmd values:**
 
 KVM_PV_ENABLE
-- 
2.34.1

