Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A99656A4BA
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 15:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235734AbiGGN6x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 09:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236389AbiGGN5s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 09:57:48 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE582193EF;
        Thu,  7 Jul 2022 06:57:47 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 267Da68u015737;
        Thu, 7 Jul 2022 13:57:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=22vAzVTYg1CLa9eVhzFm60aPk3tsXO0cO+FHybkseuI=;
 b=Zsst4XTMGkTqMWDBDj04Te+uHYhAFtoVU8f62ZkP1AOTqGMzJjdXoTjgGxpSJsehddNA
 TLxoztXyyPvv993eYweEFM0N85Uvk3+eWH9Wn+ikYkg+U0Y/W5ANLIEfUGn2r2yzh2A+
 4QNn9Pc23NthcVXMZvGVJVGItFU5zs8IxmySbHFUpmcn+JSDSjsA6ZGBkAtJ8bt1fp4F
 XOpc90oaa6Xw8uE4GPqehmcrZBeovQiFBVWQ0BwKSkAQEAmlGacXeKwpy1eJS6p+BUJu
 EeItnKkM3e8ea6d3VVUMtAQdODlJBxZsSiPi8IUHzWCgjcX+HP3qnXgk9Np693X1iUwM cg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h5wy6dnjx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jul 2022 13:57:45 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 267DaKs7016611;
        Thu, 7 Jul 2022 13:57:45 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h5wy6dnj1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jul 2022 13:57:44 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 267DuEnw000450;
        Thu, 7 Jul 2022 13:57:42 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3h4usd2ny1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jul 2022 13:57:42 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 267DuKMv23789988
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Jul 2022 13:56:21 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 68554AE045;
        Thu,  7 Jul 2022 13:57:39 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 565B3AE051;
        Thu,  7 Jul 2022 13:57:39 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu,  7 Jul 2022 13:57:39 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 1312EE0231; Thu,  7 Jul 2022 15:57:39 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Eric Farman <farman@linux.ibm.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: [PATCH v4 00/11] s390/vfio-ccw rework
Date:   Thu,  7 Jul 2022 15:57:26 +0200
Message-Id: <20220707135737.720765-1-farman@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: YGG39jb5B7NPSCKcAYu4rBZbAEBOIyiU
X-Proofpoint-GUID: 8r3eaBlMlQHE3yOMZ5gnoquAZwRIDKcX
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-07_09,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 clxscore=1015 adultscore=0 lowpriorityscore=0 impostorscore=0
 bulkscore=0 phishscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207070053
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Alex,

Here's a final pass through some of the vfio-ccw rework.
I'm hoping that because of the intersection with the extern
removal, you could grab this directly? [1]

There were no code changes since v3, I simply rebased this
onto your linux-vfio/next tree, currently on commit 7654a8881a54
("Merge branches
 'v5.20/vfio/migration-enhancements-v3',
 'v5.20/vfio/simplify-bus_type-determination-v3',
 'v5.20/vfio/check-vfio_register_iommu_driver-return-v2',
 'v5.20/vfio/check-iommu_group_set_name_return-v1',
 'v5.20/vfio/clear-caps-buf-v3',
 'v5.20/vfio/remove-useless-judgement-v1' and
 'v5.20/vfio/move-device_open-count-v2'
 into
 v5.20/vfio/next")

v3->v4:
 - Rebased to vfio/next tree
   - Tweak patch 6 to fit with extern removal
   - The rest applied directly
 - [MR] Added r-b's (Thank you!)
 - [EF] Add a comment about cp_free() call in fsm_notoper()
v3: https://lore.kernel.org/r/20220630203647.2529815-1-farman@linux.ibm.com/
v2: https://lore.kernel.org/r/20220615203318.3830778-1-farman@linux.ibm.com/
v1: https://lore.kernel.org/r/20220602171948.2790690-1-farman@linux.ibm.com/

Footnotes:
[1] https://lore.kernel.org/r/e1ead3e4-9e7d-f026-485b-157d7dc004d3@linux.ibm.com/

Cc: Kirti Wankhede <kwankhede@nvidia.com>

Eric Farman (10):
  vfio/ccw: Fix FSM state if mdev probe fails
  vfio/ccw: Do not change FSM state in subchannel event
  vfio/ccw: Remove private->mdev
  vfio/ccw: Pass enum to FSM event jumptable
  vfio/ccw: Flatten MDEV device (un)register
  vfio/ccw: Update trace data for not operational event
  vfio/ccw: Create an OPEN FSM Event
  vfio/ccw: Create a CLOSE FSM event
  vfio/ccw: Refactor vfio_ccw_mdev_reset
  vfio/ccw: Move FSM open/close to MDEV open/close

Michael Kawano (1):
  vfio/ccw: Remove UUID from s390 debug log

 drivers/s390/cio/vfio_ccw_async.c   |  1 -
 drivers/s390/cio/vfio_ccw_drv.c     | 59 +++++------------
 drivers/s390/cio/vfio_ccw_fsm.c     | 99 ++++++++++++++++++++++++-----
 drivers/s390/cio/vfio_ccw_ops.c     | 77 +++++++---------------
 drivers/s390/cio/vfio_ccw_private.h |  9 +--
 include/linux/mdev.h                |  5 --
 6 files changed, 125 insertions(+), 125 deletions(-)

-- 
2.34.1

