Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D80B3405F4
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 13:46:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231520AbhCRMp2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 08:45:28 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36106 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231496AbhCRMpQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Mar 2021 08:45:16 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12ICXvSo071340
        for <kvm@vger.kernel.org>; Thu, 18 Mar 2021 08:45:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=toWmj4aOy71vvdraiWF+P2rkLxHrW/0/nlu/hzKrLQA=;
 b=iUtoiPvLNhTUXmGZZxMteDyU3pioBJMVQLMWufQ+MRl1OQjEz/zlctbMoPsm8HFlNOEB
 u5OoNMjA4LNFVRsZW2LyknpVifnQUdG3+76jZiQmPkz6n/0Qz5k+s68GVD5Lm9gsXzK0
 Ossd8coBQnDJvU5SUpNxHTtqCZG9EbZ4hsx0mf3W9BaJuSVgu8vEvy+QXexzTn/Ha0I+
 unOj0ZJkKgTUtIcdotl+tdBtOXbbcrrQkA/gxjgxRXEjMWqPjV1UV3mwHK9fZ0Mc63J0
 651cxHVHZ8ZVkgITcZmwAmwJwbLHKc61EOLZvWGMPz3pjEakSRfPuM1b+knJvWTRZgJV BA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37c2vp8058-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 18 Mar 2021 08:45:15 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12ICY4xJ072700
        for <kvm@vger.kernel.org>; Thu, 18 Mar 2021 08:45:15 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37c2vp804e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 08:45:15 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12ICSbPb007377;
        Thu, 18 Mar 2021 12:45:13 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 378n18ms02-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 12:45:13 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12ICisE937224768
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Mar 2021 12:44:54 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D660942041;
        Thu, 18 Mar 2021 12:45:10 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 552A74204F;
        Thu, 18 Mar 2021 12:45:09 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.24.61])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 18 Mar 2021 12:45:09 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     lvivier@redhat.com, thuth@redhat.com, david@redhat.com,
        drjones@redhat.com, pbonzini@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests RFC 0/2] scripts: Fix accel handling
Date:   Thu, 18 Mar 2021 12:44:58 +0000
Message-Id: <20210318124500.45447-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-18_07:2021-03-17,2021-03-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 phishscore=0 mlxlogscore=933 mlxscore=0
 bulkscore=0 suspectscore=0 spamscore=0 clxscore=1015 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103180095
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When running on a system without KVM but with a /dev/kvm file or when
/dev/kvm has the wrong permissions we will think that we have the kvm
accelerator because we only check if /dev/kvm exists. To fix that we
instead start a qemu with the kvm accel and check the exit value we
can check if kvm is available.

Also we only compare the accel specified in unittests.conf with the
env ACCEL. That won't help if we don't have kvm but a test has KVM as
a requirement in unittests.conf.

My bash knowledge is rather limited, so maybe there's a better
solution?

Janosch Frank (2):
  scripts: Check kvm availability by asking qemu
  scripts: Set ACCEL in run_tests.sh if empty

 arm/run               |  4 +--
 powerpc/run           |  4 +--
 run_tests.sh          |  6 +++++
 s390x/run             | 10 ++++---
 scripts/accel.bash    | 63 +++++++++++++++++++++++++++++++++++++++++++
 scripts/arch-run.bash | 63 ++-----------------------------------------
 scripts/runtime.bash  |  2 +-
 x86/run               |  4 +--
 8 files changed, 85 insertions(+), 71 deletions(-)
 create mode 100644 scripts/accel.bash

-- 
2.27.0

