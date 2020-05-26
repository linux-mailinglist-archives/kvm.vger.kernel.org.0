Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09FC419BE3F
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 10:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387792AbgDBI5O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 04:57:14 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:6060 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728612AbgDBI5N (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Apr 2020 04:57:13 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0328YO9U108207
        for <kvm@vger.kernel.org>; Thu, 2 Apr 2020 04:57:12 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 304swspmj0-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 02 Apr 2020 04:57:12 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <raspl@linux.ibm.com>;
        Thu, 2 Apr 2020 09:56:54 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 2 Apr 2020 09:56:51 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0328v6Qx57999492
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Apr 2020 08:57:06 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 766D4A4051;
        Thu,  2 Apr 2020 08:57:06 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4BFEAA4057;
        Thu,  2 Apr 2020 08:57:06 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  2 Apr 2020 08:57:06 +0000 (GMT)
From:   Stefan Raspl <raspl@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH v2 0/3] tools/kvm_stat: add logfile support
Date:   Thu,  2 Apr 2020 10:57:02 +0200
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
x-cbid: 20040208-0016-0000-0000-000002FCD22A
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20040208-0017-0000-0000-000033609ABD
Message-Id: <20200402085705.61155-1-raspl@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-02_01:2020-03-31,2020-04-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=1
 bulkscore=0 clxscore=1015 lowpriorityscore=0 mlxlogscore=991 phishscore=0
 adultscore=0 impostorscore=0 malwarescore=0 priorityscore=1501 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004020073
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Next attempt to come up with support for logfiles that can be combined
with a solution for rotating logs.
Adding another patch to skip records with all zeros to preserve space.

Changes in v2:
- Addressed feedback from patch review
- Beefed up man page descriptions of --csv and --log-to-file (fixing
  a glitch in the former)
- Use a metavar for -L in the --help output


Stefan Raspl (3):
  tools/kvm_stat: add command line switch '-z' to skip zero records
  tools/kvm_stat: Add command line switch '-L' to log to file
  tools/kvm_stat: add sample systemd unit file

 tools/kvm/kvm_stat/kvm_stat         | 84 ++++++++++++++++++++++++-----
 tools/kvm/kvm_stat/kvm_stat.service | 16 ++++++
 tools/kvm/kvm_stat/kvm_stat.txt     | 15 +++++-
 3 files changed, 101 insertions(+), 14 deletions(-)
 create mode 100644 tools/kvm/kvm_stat/kvm_stat.service

-- 
2.17.1

