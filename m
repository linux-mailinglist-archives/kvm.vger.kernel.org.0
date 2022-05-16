Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3BC152808D
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 11:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233538AbiEPJKT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 05:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242097AbiEPJJh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 05:09:37 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37D4522B32;
        Mon, 16 May 2022 02:09:36 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24G8fbr8031807;
        Mon, 16 May 2022 09:09:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=xGrIwh8soY44hQEdlxZ5dMjy1LvUzDu9b6HmepSn5Nw=;
 b=o5qIvIrXCaxS/a+HsW7nejncg4MP0P9QpLvyvDxm3vFX8+26GRzO5TSseDPi37TKG6E5
 7PTGiC9PliNBNJ4xpoRV62VpoToXVAdmqDbGIO4Ne+ALGhgjIGt2FADGmz3jJ0mjnCsK
 gUR66EPOoO8e0Bqf7oNN81C9zXHBpuuN2wNtpZMNs+Ywe4R9iBoSJrcmy+umDFAlr6pN
 lWIAFMsyFGHqCQLM8BSgKsikwiSEuP0QWxB6xy0OgxIpWV4PoEh12vCCbcStDsdn/9LE
 dhK3brWSg0Qqs1f0y2z/J7fFggpQ4JDKOSVntBDBzrey15fylh6aifAKeARCsBf3E06P iw== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3kaw0h8h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 09:09:35 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24G98u5T017209;
        Mon, 16 May 2022 09:09:33 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 3g2428suad-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 09:09:33 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24G990sX29950302
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 May 2022 09:09:00 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 617344203F;
        Mon, 16 May 2022 09:09:30 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D91EF42041;
        Mon, 16 May 2022 09:09:29 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 16 May 2022 09:09:29 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, borntraeger@linux.ibm.com,
        imbrenda@linux.ibm.com
Subject: [PATCH v5 09/10] Documentation: virt: Protected virtual machine dumps
Date:   Mon, 16 May 2022 09:08:16 +0000
Message-Id: <20220516090817.1110090-10-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220516090817.1110090-1-frankja@linux.ibm.com>
References: <20220516090817.1110090-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Htm-to2oasA622ovopfLXYyitSSDzfcl
X-Proofpoint-GUID: Htm-to2oasA622ovopfLXYyitSSDzfcl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-16_05,2022-05-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 priorityscore=1501 mlxscore=0 malwarescore=0 spamscore=0 adultscore=0
 bulkscore=0 mlxlogscore=959 lowpriorityscore=0 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205160049
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
 Documentation/virt/kvm/s390/index.rst        |  1 +
 Documentation/virt/kvm/s390/s390-pv-dump.rst | 64 ++++++++++++++++++++
 2 files changed, 65 insertions(+)
 create mode 100644 Documentation/virt/kvm/s390/s390-pv-dump.rst

diff --git a/Documentation/virt/kvm/s390/index.rst b/Documentation/virt/kvm/s390/index.rst
index 605f488f0cc5..44ec9ab14b59 100644
--- a/Documentation/virt/kvm/s390/index.rst
+++ b/Documentation/virt/kvm/s390/index.rst
@@ -10,3 +10,4 @@ KVM for s390 systems
    s390-diag
    s390-pv
    s390-pv-boot
+   s390-pv-dump
diff --git a/Documentation/virt/kvm/s390/s390-pv-dump.rst b/Documentation/virt/kvm/s390/s390-pv-dump.rst
new file mode 100644
index 000000000000..e542f06048f3
--- /dev/null
+++ b/Documentation/virt/kvm/s390/s390-pv-dump.rst
@@ -0,0 +1,64 @@
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
+**Initiation**
+
+This step initializes the dump process, generates cryptographic seeds
+and extracts dump keys with which the VM dump data will be encrypted.
+
+**Data gathering**
+
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
+metadata comprised of the encryption tweaks and status flags. The
+encrypted memory can simply be read once it has been exported. The
+time of the export does not matter as no re-encryption is
+needed. Memory that has been swapped out and hence was exported can be
+read from the swap and written to the dump target without need for any
+special actions.
+
+The tweaks / status flags for the exported pages need to be requested
+from the Ultravisor.
+
+**Finalization**
+
+The finalization step will provide the data needed to be able to
+decrypt the vcpu and memory data and end the dump process. When this
+step completes successfully a new dump initiation can be started.
-- 
2.34.1

