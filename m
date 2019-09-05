Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92074A9D42
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2019 10:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731519AbfIEIkk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Sep 2019 04:40:40 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:16488 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731686AbfIEIkk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Sep 2019 04:40:40 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x858baLi088861
        for <kvm@vger.kernel.org>; Thu, 5 Sep 2019 04:40:39 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2utxpyruvg-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 05 Sep 2019 04:40:38 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 5 Sep 2019 09:40:37 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 5 Sep 2019 09:40:35 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x858eA8j36897176
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 Sep 2019 08:40:10 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0B60EA4057;
        Thu,  5 Sep 2019 08:40:34 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B720CA405E;
        Thu,  5 Sep 2019 08:40:33 +0000 (GMT)
Received: from dyn-9-152-224-131.boeblingen.de.ibm.com (unknown [9.152.224.131])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  5 Sep 2019 08:40:33 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com
Cc:     kvm@vger.kernel.org, cohuck@redhat.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org, frankja@linux.vnet.ibm.com,
        david@redhat.com, thuth@redhat.com
Subject: [GIT PULL 5/8] KVM: s390: improve documentation for S390_MEM_OP
Date:   Thu,  5 Sep 2019 10:40:06 +0200
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190905084009.26106-1-frankja@linux.ibm.com>
References: <20190905084009.26106-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19090508-4275-0000-0000-000003616F80
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19090508-4276-0000-0000-00003873B6D9
Message-Id: <20190905084009.26106-6-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-05_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=408 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1909050089
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Cornelia Huck <cohuck@redhat.com>

Explicitly specify the valid ranges for size and ar, and reword
buf requirements a bit.

Signed-off-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Link: https://lkml.kernel.org/r/20190829124746.28665-1-cohuck@redhat.com
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 Documentation/virt/kvm/api.txt | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.txt
index 2d067767b617..76c9d6fdbfdb 100644
--- a/Documentation/virt/kvm/api.txt
+++ b/Documentation/virt/kvm/api.txt
@@ -3079,12 +3079,14 @@ This exception is also raised directly at the corresponding VCPU if the
 flag KVM_S390_MEMOP_F_INJECT_EXCEPTION is set in the "flags" field.
 
 The start address of the memory region has to be specified in the "gaddr"
-field, and the length of the region in the "size" field. "buf" is the buffer
-supplied by the userspace application where the read data should be written
-to for KVM_S390_MEMOP_LOGICAL_READ, or where the data that should be written
-is stored for a KVM_S390_MEMOP_LOGICAL_WRITE. "buf" is unused and can be NULL
-when KVM_S390_MEMOP_F_CHECK_ONLY is specified. "ar" designates the access
-register number to be used.
+field, and the length of the region in the "size" field (which must not
+be 0). The maximum value for "size" can be obtained by checking the
+KVM_CAP_S390_MEM_OP capability. "buf" is the buffer supplied by the
+userspace application where the read data should be written to for
+KVM_S390_MEMOP_LOGICAL_READ, or where the data that should be written is
+stored for a KVM_S390_MEMOP_LOGICAL_WRITE. When KVM_S390_MEMOP_F_CHECK_ONLY
+is specified, "buf" is unused and can be NULL. "ar" designates the access
+register number to be used; the valid range is 0..15.
 
 The "reserved" field is meant for future extensions. It is not used by
 KVM with the currently defined set of flags.
-- 
2.20.1

