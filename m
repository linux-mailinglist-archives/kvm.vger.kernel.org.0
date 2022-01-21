Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B913B4961C4
	for <lists+kvm@lfdr.de>; Fri, 21 Jan 2022 16:09:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381515AbiAUPJs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jan 2022 10:09:48 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52154 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1381494AbiAUPJk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 Jan 2022 10:09:40 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20LEoLog023872;
        Fri, 21 Jan 2022 15:09:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=c7rXY1TSNcHxXEv5JmLygCrMShQiFHdi1tHZ2WEj558=;
 b=danntO0e5g5Mk/SB3GPZEY74wBXIN3d8IY36tPFKpIwhP7ozU+Is6Ex6xErNokoimtNB
 WDMwVydfXG9qDsIXJhyYiTswTe3n93QYNEMYx8Zn2WXZXNZw8wXNNczBw2QLij66xe68
 P7D09z3JY7ywu9X4OCsaGGnt3HG3yY7Z2kvL8ApQQITayB0Lv0RnMfb1RdOOZhbJ/YAv
 HZj2BtDN+1P7b5x2p+h3dhIPAYRA6Vk5U66mWKHHfWsaRzEpBjiX/Y5X0mmADvMe7IRZ
 0c9sEVvWPSk3M3myX4ExfLz4qnx1XsJCyokEYZjrf3YCkyxoT3VSxifzQVtBx1t4E60d HQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dqx1x9vpd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jan 2022 15:09:38 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20LEou9f027184;
        Fri, 21 Jan 2022 15:09:38 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dqx1x9vns-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jan 2022 15:09:37 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20LF2O85032358;
        Fri, 21 Jan 2022 15:09:35 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma02fra.de.ibm.com with ESMTP id 3dqjr55g1k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jan 2022 15:09:35 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20LF9WXH37814538
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 15:09:32 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 280D14203F;
        Fri, 21 Jan 2022 15:09:32 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DFCA74204C;
        Fri, 21 Jan 2022 15:09:31 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 21 Jan 2022 15:09:31 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com
Subject: [PATCH kvm-unit-tests v1 0/8] s390x: Extend instruction interception tests
Date:   Fri, 21 Jan 2022 16:09:23 +0100
Message-Id: <20220121150931.371720-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: EHGrLtOGi0VKYwBIg4rsgIL4N_au0Qfb
X-Proofpoint-ORIG-GUID: CiJ0jsGGHTUx1Gkr6HTwJRt6_lL0O9N8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-21_06,2022-01-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 lowpriorityscore=0 phishscore=0 impostorscore=0 mlxlogscore=733
 clxscore=1015 spamscore=0 malwarescore=0 priorityscore=1501 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201210102
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series extends the instruction interception tests for s390x.

For most instructions, there is already coverage in existing tests, but they are
not covering some failure cases, e.g. bad alignment. In this case, the existing
tests were extended.

SCK was not under test anywhere yet, hence a new test file was added.

The EPSW test gets it's own file, too, because it requires a I/O device, more
details in the respective commit. 

The EPSW test must be fenced when running in non-QEMU. For this, we need
vm_is_kvm() from Pierre's patchset 
"[kvm-unit-tests PATCH v3 0/4] S390x: CPU Topology Information" 
(Message-Id: <20220110133755.22238-3-pmorel@linux.ibm.com>)

Nico Boehr (8):
  s390x: Add more tests for MSCH
  s390x: Add test for PFMF low-address protection
  s390x: Add sck tests
  s390x: Add tests for STCRW
  s390x: Add more tests for SSCH
  s390x: Add more tests for STSCH
  s390x: Add tests for TSCH
  s390x: Add EPSW test

 lib/s390x/css.h     |  17 +++
 lib/s390x/css_lib.c |  60 ++++++++++
 s390x/Makefile      |   2 +
 s390x/css.c         | 276 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/epsw.c        | 104 +++++++++++++++++
 s390x/pfmf.c        |  29 +++++
 s390x/sck.c         | 127 ++++++++++++++++++++
 s390x/unittests.cfg |   7 ++
 8 files changed, 622 insertions(+)
 create mode 100644 s390x/epsw.c
 create mode 100644 s390x/sck.c

-- 
2.31.1

