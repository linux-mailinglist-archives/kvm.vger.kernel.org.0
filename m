Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD51E4A007A
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 19:54:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344432AbiA1Sy6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jan 2022 13:54:58 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34022 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239777AbiA1Sy5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 28 Jan 2022 13:54:57 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20SIaTxb028136
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 18:54:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=Xr+LbnpiaiD51e1ZSh7XJiw5U0q/D4hQ9uT9l9NYf0g=;
 b=gmwqLxi5PxLIIsa2zDcaoMt7wG77oY4gdOgO7ZO+PEwLF1ivS2/wilIxTyjS1CJc1FCk
 XdJlKdwBuXyN7Pn2/fFyNhejenBOUQ8bjuVdzW483levUQqtruhawuGEub7bv6dTDaDg
 K+Y6u8R4+urwu86d/fctgnrIsFCCzOR+jRf9bB3KvXHTJSQh3AQB5TGyfQPGZf/qlLbS
 TuDj8I8PRAHwL3xsbL6TOXsuPd4Ta20/l5H5ZN+eQOdP+dMVA29iy2DBvJCf9MDhBfKT
 IE3vdfpUpcxAgn7uivriKCxDLw8mOzESUS+tYUE9AyTOrrDuHPLn/oBMUVZJziRxEeQT Ew== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dvm8jjcsb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 18:54:56 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20SInL2P005075
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 18:54:56 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dvm8jjcrj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Jan 2022 18:54:55 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20SIqjia014539;
        Fri, 28 Jan 2022 18:54:53 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3dr96kc63h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Jan 2022 18:54:53 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20SIso2Q44630356
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Jan 2022 18:54:50 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1DD29A4067;
        Fri, 28 Jan 2022 18:54:50 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9A30BA405F;
        Fri, 28 Jan 2022 18:54:49 +0000 (GMT)
Received: from p-imbrenda.bredband2.com (unknown [9.145.7.17])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 28 Jan 2022 18:54:49 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, david@redhat.com,
        nrb@linux.ibm.com, scgl@linux.ibm.com, seiden@linux.ibm.com
Subject: [kvm-unit-tests PATCH v1 0/5] s390x: smp: avoid hardcoded CPU addresses
Date:   Fri, 28 Jan 2022 19:54:44 +0100
Message-Id: <20220128185449.64936-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: PVNLJlsNOYDdx4EwlwQ3I4U_FtqT0joE
X-Proofpoint-ORIG-GUID: Y181GvaP20gzCEgGg29YAq4bLe44XfBk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-28_06,2022-01-28_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 malwarescore=0
 impostorscore=0 mlxlogscore=918 bulkscore=0 lowpriorityscore=0
 clxscore=1015 adultscore=0 spamscore=0 phishscore=0 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201280108
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On s390x there are no guarantees about the CPU addresses, except that
they shall be unique. This means that in some environments, it's
possible that there is no match between the CPU address and its
position (index) in the list of available CPUs returned by the system.

This series fixes a small bug in the SMP initialization code, adds a
guarantee that the boot CPU will always have index 0, and introduces
some functions to allow tests to use CPU indexes instead of using
hardcoded CPU addresses. This will allow the tests to run successfully
in more environments (e.g. z/VM, LPAR).

Some existing tests are adapted to take advantage of the new
functionalities.

Claudio Imbrenda (5):
  lib: s390x: smp: add functions to work with CPU indexes
  lib: s390x: smp: guarantee that boot CPU has index 0
  s390x: smp: avoid hardcoded CPU addresses
  s390x: firq: avoid hardcoded CPU addresses
  s390x: skrf: avoid hardcoded CPU addresses

 lib/s390x/smp.h |  2 ++
 lib/s390x/smp.c | 28 ++++++++++++-----
 s390x/firq.c    | 17 +++++-----
 s390x/skrf.c    |  8 +++--
 s390x/smp.c     | 83 ++++++++++++++++++++++++++-----------------------
 5 files changed, 79 insertions(+), 59 deletions(-)

-- 
2.34.1

