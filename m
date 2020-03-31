Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68D0E199FA3
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 22:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729974AbgCaUAv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 16:00:51 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44676 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728840AbgCaUAu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 31 Mar 2020 16:00:50 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02VJXc8M121193
        for <kvm@vger.kernel.org>; Tue, 31 Mar 2020 16:00:49 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3043g7hjn1-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 31 Mar 2020 16:00:49 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <raspl@linux.ibm.com>;
        Tue, 31 Mar 2020 21:00:37 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 31 Mar 2020 21:00:36 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02VJxfAS35520912
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Mar 2020 19:59:41 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2E7B4A405B;
        Tue, 31 Mar 2020 20:00:45 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 040C8A4060;
        Tue, 31 Mar 2020 20:00:45 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 31 Mar 2020 20:00:44 +0000 (GMT)
From:   Stefan Raspl <raspl@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH 3/3] tools/kvm_stat: add sample systemd unit file
Date:   Tue, 31 Mar 2020 22:00:42 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200331200042.2026-1-raspl@linux.ibm.com>
References: <20200331200042.2026-1-raspl@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20033120-0008-0000-0000-00000367FE57
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20033120-0009-0000-0000-00004A8983F6
Message-Id: <20200331200042.2026-4-raspl@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-03-31_07:2020-03-31,2020-03-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 malwarescore=0 mlxlogscore=999 impostorscore=0 clxscore=1015
 phishscore=0 adultscore=0 lowpriorityscore=0 bulkscore=0 mlxscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003310160
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

