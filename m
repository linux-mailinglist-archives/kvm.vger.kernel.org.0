Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAD9F509B24
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 10:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386943AbiDUIx2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 04:53:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386937AbiDUIxX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 04:53:23 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18EAE1DA48;
        Thu, 21 Apr 2022 01:50:28 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23L8fk0H001181;
        Thu, 21 Apr 2022 08:50:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=PZBTxIzZnQMbcdvKOQBKQtIW3YEOwhqRLgk1fsb6gsg=;
 b=M8diq7JJ77boqtcibQnapSpr5ecOPh3BXuIgR9k3IGZnUo5Mjfs1pxjJDAFGi3/zYKH7
 jczoscMr2XzcDg+vDH9g/Q9qru5piZUcjJBVmcfhajzG3A+qDnugosOFxFpK3GfMl0Kx
 Zkh3S/psECNvyvrqlICObe489yXDlNvFyQrhVO5TwMLw8ob9/BupQ28CoNQ6SoYM+nCt
 HBfjubBLVcX+GKY5s35SSZJmyF9LkZSMHXRbuN/ob3Y/BvYld8/bzl33yMMsEZiYUoDs
 9EvwyCYhbL6jSOEHwUSOuXQI4Q/CuwUxu1yqerSXLciJNct58pvY7FMbuGvo48aFt8Dx Jg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fk3yvr5dy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 08:50:27 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23L8iFjH011759;
        Thu, 21 Apr 2022 08:50:27 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fk3yvr5de-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 08:50:27 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23L8RbDW007666;
        Thu, 21 Apr 2022 08:50:25 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 3fgu6u4ec5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 08:50:25 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23L8bWc544761462
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Apr 2022 08:37:32 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 27795A4051;
        Thu, 21 Apr 2022 08:50:22 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D13A2A404D;
        Thu, 21 Apr 2022 08:50:21 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Apr 2022 08:50:21 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        farman@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 0/3] Misc maintenance fixes 2022-04
Date:   Thu, 21 Apr 2022 10:50:18 +0200
Message-Id: <20220421085021.1651688-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: zxj5jrS_mVaGLm3Dikvg3HOmEh8evwzB
X-Proofpoint-ORIG-GUID: cSVjGJpra2bUnmuhMqpPRFIwa8vW4iFf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_06,2022-04-20_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=999 impostorscore=0
 lowpriorityscore=0 bulkscore=0 malwarescore=0 suspectscore=0 clxscore=1015
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204210048
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changelog from v1:
----
* tprot: Change system include to lib include in commit message

Misc small fixes, which I previously sent as:
- [kvm-unit-tests PATCH v1 1/3] s390x: epsw: fix report_pop_prefix() when
  running under non-QEMU
- [kvm-unit-tests PATCH v1 2/3] s390x: tprot: use system include for mmu.h
- [kvm-unit-tests PATCH v1 3/3] s390x: smp: make stop stopped cpu look the same
  as the running case

I broke the threading when I sent the patches, so Janosch asked me to
resend this as a new series.

Nico Boehr (3):
  s390x: epsw: fix report_pop_prefix() when running under non-QEMU
  s390x: tprot: use lib include for mmu.h
  s390x: smp: make stop stopped cpu look the same as the running case

 s390x/epsw.c  | 4 ++--
 s390x/smp.c   | 5 +++--
 s390x/tprot.c | 2 +-
 3 files changed, 6 insertions(+), 5 deletions(-)

-- 
2.31.1

