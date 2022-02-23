Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 662754C0F04
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 10:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239248AbiBWJU4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 04:20:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233201AbiBWJUx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 04:20:53 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CBA438BCE;
        Wed, 23 Feb 2022 01:20:24 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21N9A45S030965;
        Wed, 23 Feb 2022 09:20:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=YvKItfWJSsvmR6042FB8L7cEUUkLwFaR8uxV7fkFfz8=;
 b=kDSissZ0Ql2wn/S3U4JsDEhj/Rp8p44iW3VdBDpltLl6tq/lChb3EVkFL7N9SwnshdK9
 hyE9r1Y7vTndJF4M0AUpAT+Yt70tpPvPzGdFYjbs+YkaJad5DgeaWem5MYIzPs8UYS4H
 lr8qV6YjTGjubXvcTfRnrRNE98pBWKAG7N61DEnf8wGoCfkNeuOgwQ99l6L0R0nh8BP3
 gbbLjd8J50ofLIa4y7LIC0wtncm7JMuAc+VU9JEGvPFQu7L9VLDxs9v8eGBtBmE7Dh+b
 98yFEiWSzgIIjNCUiFTgSOdN7YRHGLtSvqGtw6vbYGbx3GH1iubd0egZEfa5GDT6GM3X MA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3edds7mrh7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 09:20:23 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21N8jvSh011123;
        Wed, 23 Feb 2022 09:20:23 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3edds7mrgf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 09:20:22 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21N9CR5h022170;
        Wed, 23 Feb 2022 09:20:21 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma02fra.de.ibm.com with ESMTP id 3ear6974a4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 09:20:21 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21N9KHoF40304996
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Feb 2022 09:20:17 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CCECE11C054;
        Wed, 23 Feb 2022 09:20:17 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3C2DA11C058;
        Wed, 23 Feb 2022 09:20:17 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Feb 2022 09:20:17 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, borntraeger@linux.ibm.com
Subject: [PATCH 0/9] kvm: s390: Add PV dump support
Date:   Wed, 23 Feb 2022 09:19:58 +0000
Message-Id: <20220223092007.3163-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: DvjhTa5QVrN8OTQejaCvyI1mUjGjB_AI
X-Proofpoint-ORIG-GUID: 2MSJ-ovPfkqBo38-UJkeboIwL70YASfM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-23_03,2022-02-21_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 lowpriorityscore=0 clxscore=1015 mlxscore=0 bulkscore=0 priorityscore=1501
 malwarescore=0 mlxlogscore=658 phishscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202230049
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sometimes dumping inside of a VM fails, is unavailable or doesn't
yield the required data. For these occasions we dump the VM from the
outside, writing memory and cpu data to a file.

Up to now PV guests only supported dumping from the inside of the
guest through dumpers like KDUMP. A PV guest can be dumped from the
hypervisor but the data will be stale and / or encrypted.

To get the actual state of the PV VM we need the help of the
Ultravisor who safeguards the VM state. New UV calls have been added
to initialize the dump, dump storage state data, dump cpu data and
complete the dump process.


Notes:
I'm still pondering adding a lock to the dumping PV struct member to
make absolutely sure that we can't run into the validity even if
userspace tries to achieve getting it.

I chose not to document the dump data provided by the Ultravisor since
KVM doesn't interprete it in any way. We're currently searching for a
location and enough cycles to make it available to all.

Janosch Frank (9):
  s390x: Add SE hdr query information
  s390: uv: Add dump fields to query
  KVM: s390: pv: Add query interface
  KVM: s390: pv: Add dump support definitions
  KVM: s390: pv: Add query dump information
  kvm: s390: Add configuration dump functionality
  kvm: s390: Add CPU dump functionality
  Documentation: virt: Protected virtual machine dumps
  Documentation/virt/kvm/api.rst: Add protvirt dump/info api
    descriptions

 Documentation/virt/kvm/api.rst          | 129 +++++++++++-
 Documentation/virt/kvm/index.rst        |   1 +
 Documentation/virt/kvm/s390-pv-dump.rst |  60 ++++++
 arch/s390/boot/uv.c                     |   4 +
 arch/s390/include/asm/kvm_host.h        |   1 +
 arch/s390/include/asm/uv.h              |  45 +++-
 arch/s390/kernel/uv.c                   |  53 +++++
 arch/s390/kvm/kvm-s390.c                | 267 ++++++++++++++++++++++++
 arch/s390/kvm/kvm-s390.h                |   3 +
 arch/s390/kvm/pv.c                      | 131 ++++++++++++
 include/uapi/linux/kvm.h                |  53 +++++
 11 files changed, 744 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/virt/kvm/s390-pv-dump.rst

-- 
2.32.0

