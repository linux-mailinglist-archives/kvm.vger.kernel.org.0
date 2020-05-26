Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3B98199FA2
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 22:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729153AbgCaUAu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 16:00:50 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:24464 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727837AbgCaUAu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 31 Mar 2020 16:00:50 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02VJX2g5046117
        for <kvm@vger.kernel.org>; Tue, 31 Mar 2020 16:00:49 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 303v2t526b-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 31 Mar 2020 16:00:49 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <raspl@linux.ibm.com>;
        Tue, 31 Mar 2020 21:00:34 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 31 Mar 2020 21:00:32 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02VK0ins51511398
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Mar 2020 20:00:44 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 93906A405B;
        Tue, 31 Mar 2020 20:00:44 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 68DFBA4060;
        Tue, 31 Mar 2020 20:00:44 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 31 Mar 2020 20:00:44 +0000 (GMT)
From:   Stefan Raspl <raspl@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH 0/3] tools/kvm_stat: add logfile support
Date:   Tue, 31 Mar 2020 22:00:39 +0200
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
x-cbid: 20033120-4275-0000-0000-000003B71EE6
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20033120-4276-0000-0000-000038CC6FA4
Message-Id: <20200331200042.2026-1-raspl@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-03-31_07:2020-03-31,2020-03-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 mlxscore=0 lowpriorityscore=0 phishscore=0 mlxlogscore=861
 adultscore=0 suspectscore=1 spamscore=0 clxscore=1015 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003310164
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Next attempt to come up with support for logfiles that can be combined
with a solution for rotating logs.
Adding another patch to skip records with all zeros to preserve space.

Stefan Raspl (3):
  tools/kvm_stat: add command line switch '-z' to skip zero records
  tools/kvm_stat: Add command line switch '-L' to log to file
  tools/kvm_stat: add sample systemd unit file

 tools/kvm/kvm_stat/kvm_stat         | 110 ++++++++++++++++++++++++----
 tools/kvm/kvm_stat/kvm_stat.service |  16 ++++
 tools/kvm/kvm_stat/kvm_stat.txt     |   9 +++
 3 files changed, 121 insertions(+), 14 deletions(-)
 create mode 100644 tools/kvm/kvm_stat/kvm_stat.service

-- 
2.17.1

