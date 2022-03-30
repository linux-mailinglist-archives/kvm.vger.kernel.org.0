Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACEBE4EC42C
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 14:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245276AbiC3Mfe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 08:35:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344644AbiC3MfT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 08:35:19 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB2667DE18;
        Wed, 30 Mar 2022 05:21:00 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22UB6pdE009916;
        Wed, 30 Mar 2022 12:20:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=dCcUDpRwUTtW2St/Zxwt0vR7E223ZaXO52Uej7mNbB0=;
 b=GNIxuDT9dnzKGgOdu5J08Nzl3iA6R5nwRv7v8oPU7+clcTH+X44Aj8dQc2qKfKMC2hQL
 IZacUoTNaOWeY3VbsO8VnuKFMcCttEisXhzOpq1GpL3x//uTpFCD1q9eT0gPARYe6ZQZ
 QWMIwvjnduqMinvoVkfHUXNrxotJQ2PQdbRxD+JPFtRuWqA3M4f+l5jNgT3AIZ8CF+8e
 gwBtZ28ykzeNxOHsmg5G9plAbtKwPtpxFaLU5+zd/CrEydGcrOta0vhSUrUjp/+epW9S
 UEkFrZ4UafctnZNUkW7KzSO7M7KIIiYwh74woqdHLA1pI+uza/mRvs3z547ZQsYuk/r4 OQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f40t8w2fa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Mar 2022 12:20:37 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22UB6n6a014739;
        Wed, 30 Mar 2022 12:20:37 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f40t8w2ed-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Mar 2022 12:20:36 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22UBx6J6021922;
        Wed, 30 Mar 2022 12:20:34 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 3f1tf8y9af-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Mar 2022 12:20:34 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22UC8VHd36241708
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Mar 2022 12:08:31 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C1D9942045;
        Wed, 30 Mar 2022 12:20:30 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3B3C442042;
        Wed, 30 Mar 2022 12:20:30 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 30 Mar 2022 12:20:30 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, borntraeger@linux.ibm.com
Subject: [PATCH v3 0/9] kvm: s390: Add PV dump support
Date:   Wed, 30 Mar 2022 12:19:43 +0000
Message-Id: <20220330121952.105725-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 3nN6pkCtkcEboUynhcQHMrUUpuFx-7PL
X-Proofpoint-GUID: WI10TKiU8rgDc9OistnJEwmrGZhls1PQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-30_04,2022-03-30_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 clxscore=1015 impostorscore=0 phishscore=0 priorityscore=1501 mlxscore=0
 suspectscore=0 spamscore=0 mlxlogscore=520 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203300062
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

I chose not to document the dump data provided by the Ultravisor since
KVM doesn't interprete it in any way. We're currently searching for a
location and enough cycles to make it available to all.

v3:
	* Added Rev-by
	* Renamed the query function's len variables to len_min

v2:
	* Added vcpu SIE blocking to avoid validities
	* Moved the KVM CAP to patch #7
	* Renamed len to len_max and introduced len_written for extendability
	* Added Rev-bys

Janosch Frank (9):
  s390: pv: Add SE hdr query information
  s390: uv: Add dump fields to query
  KVM: s390: pv: Add query interface
  KVM: s390: pv: Add dump support definitions
  KVM: s390: pv: Add query dump information
  kvm: s390: Add configuration dump functionality
  kvm: s390: Add CPU dump functionality
  Documentation: virt: Protected virtual machine dumps
  Documentation/virt/kvm/api.rst: Add protvirt dump/info api
    descriptions

 Documentation/virt/kvm/api.rst          | 150 +++++++++++-
 Documentation/virt/kvm/index.rst        |   1 +
 Documentation/virt/kvm/s390-pv-dump.rst |  60 +++++
 arch/s390/boot/uv.c                     |   4 +
 arch/s390/include/asm/kvm_host.h        |   1 +
 arch/s390/include/asm/uv.h              |  45 +++-
 arch/s390/kernel/uv.c                   |  53 ++++
 arch/s390/kvm/kvm-s390.c                | 308 ++++++++++++++++++++++++
 arch/s390/kvm/kvm-s390.h                |   3 +
 arch/s390/kvm/pv.c                      | 131 ++++++++++
 include/uapi/linux/kvm.h                |  55 +++++
 11 files changed, 808 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/virt/kvm/s390-pv-dump.rst

-- 
2.32.0

