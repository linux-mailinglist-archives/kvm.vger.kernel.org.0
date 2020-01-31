Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D44514EEFF
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2020 16:03:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729207AbgAaPDS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jan 2020 10:03:18 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53850 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729126AbgAaPDS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 31 Jan 2020 10:03:18 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00VF1nPE085236
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2020 10:03:16 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2xuvd6s4h0-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2020 10:03:16 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Fri, 31 Jan 2020 15:02:12 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 31 Jan 2020 15:02:09 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00VF29PK58654812
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Jan 2020 15:02:09 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EE4924C046;
        Fri, 31 Jan 2020 15:02:08 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DCD604C04A;
        Fri, 31 Jan 2020 15:02:08 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 31 Jan 2020 15:02:08 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 9B976E03BC; Fri, 31 Jan 2020 16:02:08 +0100 (CET)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [PULL 01/12] MAINTAINERS: Update S390 PCI Maintainer
Date:   Fri, 31 Jan 2020 16:01:56 +0100
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200131150207.73127-1-borntraeger@de.ibm.com>
References: <20200131150207.73127-1-borntraeger@de.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20013115-0020-0000-0000-000003A5DEF8
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20013115-0021-0000-0000-000021FD995E
Message-Id: <20200131150207.73127-2-borntraeger@de.ibm.com>
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-31_03:2020-01-31,2020-01-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 adultscore=0 priorityscore=1501 phishscore=0 suspectscore=0
 impostorscore=0 bulkscore=0 mlxlogscore=847 spamscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2001310127
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Matthew Rosato <mjrosato@linux.ibm.com>

As discussed previously with Collin, I will take over maintaining
s390 pci.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
Message-Id: <1569590461-12562-1-git-send-email-mjrosato@linux.ibm.com>
Acked-by: Collin Walling <walling@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index bd7ee2310184..21264eae9c43 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1206,7 +1206,7 @@ T: git https://github.com/borntraeger/qemu.git s390-next
 L: qemu-s390x@nongnu.org
 
 S390 PCI
-M: Collin Walling <walling@linux.ibm.com>
+M: Matthew Rosato <mjrosato@linux.ibm.com>
 S: Supported
 F: hw/s390x/s390-pci*
 L: qemu-s390x@nongnu.org
-- 
2.21.0

