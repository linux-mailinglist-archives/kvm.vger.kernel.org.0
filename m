Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D86894C0F12
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 10:20:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239274AbiBWJVE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 04:21:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239258AbiBWJU7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 04:20:59 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E6B685648;
        Wed, 23 Feb 2022 01:20:30 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21N8flZT002650;
        Wed, 23 Feb 2022 09:20:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=pyu4O5lMMU/BUfHgswvm5ffmgsd3h8dI5XjfpWkeku4=;
 b=SSHeK58zaxo0w+0skiZ9eWxwL62hCckmjQr4+vXOKC56puKfKttz1/l/z94vPCBxyqrV
 G/ocYeGjVONfcyIFKYuyP7Ud0Bng8bPqepogzKFZW6ZWhLdWi+UjWg9SoKjB+vT56jIj
 Ia1uLJ7H5e522RRSyzrH93EB8htzVWe3zIDmK9JVxTZNv9R6zBo6vZZG2vGJzxBjPZM5
 TUpTut5SiLuyQhD1S/JJgE5H0iTziBJSrJZUYImVe7WbASbsRq+lRb6lgkpkqTIaquY2
 PpMse9HaeQifAsoby98Oi7Bh359HJjbq2N+7Me4MIwRAZY3XUCpj9VePPkOv76xsGG31 vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3edhmwgp7u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 09:20:30 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21N99LhV024875;
        Wed, 23 Feb 2022 09:20:29 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3edhmwgp70-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 09:20:29 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21N9CNxi023164;
        Wed, 23 Feb 2022 09:20:27 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3ear698mfm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 09:20:26 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21N99jDG34603412
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Feb 2022 09:09:45 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CA5D311C050;
        Wed, 23 Feb 2022 09:20:23 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3A15B11C04C;
        Wed, 23 Feb 2022 09:20:23 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Feb 2022 09:20:23 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, borntraeger@linux.ibm.com
Subject: [PATCH 8/9] Documentation: virt: Protected virtual machine dumps
Date:   Wed, 23 Feb 2022 09:20:06 +0000
Message-Id: <20220223092007.3163-9-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220223092007.3163-1-frankja@linux.ibm.com>
References: <20220223092007.3163-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ea-ghoWMgif1kkoU1iia6VzN2KfZgicF
X-Proofpoint-GUID: tZs9MhNdvibt816QCxx4AhkBJdJgvxoh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-23_03,2022-02-21_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 mlxscore=0 malwarescore=0 suspectscore=0 clxscore=1015
 mlxlogscore=999 spamscore=0 phishscore=0 bulkscore=0 lowpriorityscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202230049
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's add a documentation file which describes the dump process. Since
we only copy the UV dump data from the UV to userspace we'll not go
into detail here and let the party which processes the data describe
its structure.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 Documentation/virt/kvm/index.rst        |  1 +
 Documentation/virt/kvm/s390-pv-dump.rst | 60 +++++++++++++++++++++++++
 2 files changed, 61 insertions(+)
 create mode 100644 Documentation/virt/kvm/s390-pv-dump.rst

diff --git a/Documentation/virt/kvm/index.rst b/Documentation/virt/kvm/index.rst
index b6833c7bb474..32f3eed5fadb 100644
--- a/Documentation/virt/kvm/index.rst
+++ b/Documentation/virt/kvm/index.rst
@@ -20,6 +20,7 @@ KVM
    s390-diag
    s390-pv
    s390-pv-boot
+   s390-pv-dump
    timekeeping
    vcpu-requests
 
diff --git a/Documentation/virt/kvm/s390-pv-dump.rst b/Documentation/virt/kvm/s390-pv-dump.rst
new file mode 100644
index 000000000000..6fe7560e10b1
--- /dev/null
+++ b/Documentation/virt/kvm/s390-pv-dump.rst
@@ -0,0 +1,60 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===========================================
+s390 (IBM Z) Protected Virtualization dumps
+===========================================
+
+Summary
+-------
+
+Dumping a VM is an essential tool for debugging problems inside
+it. This is especially true when a protected VM runs into trouble as
+there's no way to access its memory and registers from the outside
+while it's running.
+
+However when dumping a protected VM we need to maintain its
+confidentiality until the dump is in the hands of the VM owner who
+should be the only one capable of analysing it.
+
+The confidentiality of the VM dump is ensured by the Ultravisor who
+provides an interface to KVM over which encrypted CPU and memory data
+can be requested. The encryption is based on the Customer
+Communication Key which is the key that's used to encrypt VM data in a
+way that the customer is able to decrypt.
+
+
+Dump process
+------------
+
+A dump is done in 3 steps:
+
+Initiation
+This step initializes the dump process, generates cryptographic seeds
+and extracts dump keys with which the VM dump data will be encrypted.
+
+Data gathering
+Currently there are two types of data that can be gathered from a VM:
+the memory and the vcpu state.
+
+The vcpu state contains all the important registers, general, floating
+point, vector, control and tod/timers of a vcpu. The vcpu dump can
+contain incomplete data if a vcpu is dumped while an instruction is
+emulated with help of the hypervisor. This is indicated by a flag bit
+in the dump data. For the same reason it is very important to not only
+write out the encrypted vcpu state, but also the unencrypted state
+from the hypervisor.
+
+The memory state is further divided into the encrypted memory and its
+encryption tweaks / status flags. The encrypted memory can simply be
+read once it has been exported. The time of the export does not matter
+as no re-encryption is needed. Memory that has been swapped out and
+hence was exported can be read from the swap and written to the dump
+target without need for any special actions.
+
+The tweaks / status flags for the exported pages need to be requested
+from the Ultravisor.
+
+Finalization
+The finalization step will provide the data needed to be able to
+decrypt the vcpu and memory data and end the dump process. When this
+step completes successfully a new dump initiation can be started.
-- 
2.32.0

