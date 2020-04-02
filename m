Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73C4719BE40
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 10:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387841AbgDBI5N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 04:57:13 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:64104 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387749AbgDBI5M (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Apr 2020 04:57:12 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0328YVwq113638
        for <kvm@vger.kernel.org>; Thu, 2 Apr 2020 04:57:12 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 301yfhp9rn-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 02 Apr 2020 04:57:12 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <raspl@linux.ibm.com>;
        Thu, 2 Apr 2020 09:56:54 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 2 Apr 2020 09:56:52 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0328v7ED56164566
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Apr 2020 08:57:07 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0F87EA404D;
        Thu,  2 Apr 2020 08:57:07 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D97E6A4055;
        Thu,  2 Apr 2020 08:57:06 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  2 Apr 2020 08:57:06 +0000 (GMT)
From:   Stefan Raspl <raspl@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH v2 3/3] tools/kvm_stat: add sample systemd unit file
Date:   Thu,  2 Apr 2020 10:57:05 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200402085705.61155-1-raspl@linux.ibm.com>
References: <20200402085705.61155-1-raspl@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20040208-4275-0000-0000-000003B817EF
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20040208-4276-0000-0000-000038CD6D2A
Message-Id: <20200402085705.61155-4-raspl@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-02_01:2020-03-31,2020-04-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=1 impostorscore=0 mlxscore=0 phishscore=0 clxscore=1015
 bulkscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004020073
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Stefan Raspl <raspl@de.ibm.com>

Add a sample unit file as a basis for systemd integration of kvm_stat
logs.

Signed-off-by: Stefan Raspl <raspl@linux.ibm.com>
---
 tools/kvm/kvm_stat/kvm_stat.service | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)
 create mode 100644 tools/kvm/kvm_stat/kvm_stat.service

diff --git a/tools/kvm/kvm_stat/kvm_stat.service b/tools/kvm/kvm_stat/kvm_stat.service
new file mode 100644
index 000000000000..71aabaffe779
--- /dev/null
+++ b/tools/kvm/kvm_stat/kvm_stat.service
@@ -0,0 +1,16 @@
+# SPDX-License-Identifier: GPL-2.0-only
+
+[Unit]
+Description=Service that logs KVM kernel module trace events
+Before=qemu-kvm.service
+
+[Service]
+Type=simple
+ExecStart=/usr/bin/kvm_stat -dtcz -s 10 -L /var/log/kvm_stat.csv
+ExecReload=/bin/kill -HUP $MAINPID
+Restart=always
+SyslogIdentifier=kvm_stat
+SyslogLevel=debug
+
+[Install]
+WantedBy=multi-user.target
-- 
2.17.1

