Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D39A53AA34
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 17:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351817AbiFAPhJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 11:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355658AbiFAPg7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 11:36:59 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38633BCBD;
        Wed,  1 Jun 2022 08:36:57 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 251F40q6003050;
        Wed, 1 Jun 2022 15:36:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=T+yzMBKMFG4peMB7qE+br+/+M+8gqEdu+T0E2EfPo00=;
 b=Qd6rrBKx2crTuUarNUHutw9NmpbIHCpN4B1MmWtINQN6PFJ7GzL8LaVqQX+APduErmQy
 j+IKpsBC6ZL3DyIWxfkULbbGdW6yW8A2IgZ8PEpN8e819wNaG7byTdWDRDdtWcsUONX4
 yFRhW3ymfptR1V3ONjTZY/VQdGnqOJqzCEYjrAW8j6AM8gvedpUwlneSDZOGBaKQ7l95
 6Z3USAhmSWK5N5XLJ+t3EL9rpu3dWXNVWUI6VqR470ExsoJDvJrRUF6B1/j8bXgAmDrA
 L+Urx3Jf2f93SU5oGnL+E1RecWpv4RbDDqB3c1Sy/ReDkFpsxnzWcWsn/eUvy3ZHlW9+ aQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3ge8t23ntv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Jun 2022 15:36:56 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 251FOZ8u032593;
        Wed, 1 Jun 2022 15:36:55 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3ge8t23nsy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Jun 2022 15:36:55 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 251FKaLm027646;
        Wed, 1 Jun 2022 15:36:53 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma05fra.de.ibm.com with ESMTP id 3gbc97cd6j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Jun 2022 15:36:53 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 251FaorI55247234
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Jun 2022 15:36:50 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6F6F042041;
        Wed,  1 Jun 2022 15:36:50 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5BF594203F;
        Wed,  1 Jun 2022 15:36:50 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed,  1 Jun 2022 15:36:50 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 20AF3E028C; Wed,  1 Jun 2022 17:36:50 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [GIT PULL 09/15] Documentation: virt: Protected virtual machine dumps
Date:   Wed,  1 Jun 2022 17:36:40 +0200
Message-Id: <20220601153646.6791-10-borntraeger@linux.ibm.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601153646.6791-1-borntraeger@linux.ibm.com>
References: <20220601153646.6791-1-borntraeger@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: FxjwYkhl7efXCCUfkb_CGPsxuRV7iwBi
X-Proofpoint-GUID: MPGLa6ewnX7SBd3sJFcWgLxuatp23iC9
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-01_05,2022-06-01_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 clxscore=1015 malwarescore=0 adultscore=0 priorityscore=1501 mlxscore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206010072
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

Let's add a documentation file which describes the dump process. Since
we only copy the UV dump data from the UV to userspace we'll not go
into detail here and let the party which processes the data describe
its structure.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20220517163629.3443-10-frankja@linux.ibm.com
Message-Id: <20220517163629.3443-10-frankja@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
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
2.35.1

