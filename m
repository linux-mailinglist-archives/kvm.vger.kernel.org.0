Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31BEF56244D
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 22:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237327AbiF3UhW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 16:37:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237007AbiF3UhA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 16:37:00 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9920F48812;
        Thu, 30 Jun 2022 13:36:58 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25UK2xPB003314;
        Thu, 30 Jun 2022 20:36:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=XVCFn3mz+ghgpMJyFPOty9LjaDNRv1CT8zuNp4iVUi8=;
 b=sFcKNoxvntN98euhtVB80c0ZBYjrHCIfmV+DgzfSVV0cPP0BtvbHbDG/xEj+kotmmYNc
 NEwzdMnjnneflld41QioaowRR3qtvrglrZZVuuInLUjFmysgb3vTRfaQoOQW5bzFRfJv
 FlNAZ8CmuhIEHyRrWnTG0M+St2WqfCFr+UqaUDOpRYJL4fNhXCEISnzAqkzj5p5gwiv1
 1lluqJdbaKxCbRPnxFx0Qxo8yTvZbakgoid0ltbP/1m2jv5gopnfHG873LMe44+sGpC8
 aA/vWZlCvnJ7AiSXYJBadR2pj9QywrRCsYbRGH8IFduN+HgvXMzCbauYLtI5ZCTP/z0k Tg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h1jhbs1w6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Jun 2022 20:36:54 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25UKKPd7021455;
        Thu, 30 Jun 2022 20:36:54 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h1jhbs1vj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Jun 2022 20:36:54 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25UKKe0q032745;
        Thu, 30 Jun 2022 20:36:52 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 3gwt08xg0u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Jun 2022 20:36:52 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25UKanmn20054388
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jun 2022 20:36:49 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0C066A4051;
        Thu, 30 Jun 2022 20:36:49 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ED68EA404D;
        Thu, 30 Jun 2022 20:36:48 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 30 Jun 2022 20:36:48 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id E9885E0261; Thu, 30 Jun 2022 22:36:48 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Eric Farman <farman@linux.ibm.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: [PATCH v3 00/11] s390/vfio-ccw rework
Date:   Thu, 30 Jun 2022 22:36:36 +0200
Message-Id: <20220630203647.2529815-1-farman@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: uf2IQdHBYVlrLsaxa8MOuXOIo377WaCt
X-Proofpoint-GUID: mFJ43KvhO8jT46DxQTTcbHOxhLB8MRv7
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-30_14,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 malwarescore=0 phishscore=0 mlxlogscore=742 spamscore=0
 bulkscore=0 lowpriorityscore=0 impostorscore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206300077
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Here's an updated pass through the first chunk of vfio-ccw rework.

As with v2, this is all internal to vfio-ccw, with the exception of
the removal of mdev_uuid from include/linux/mdev.h in patch 1.

There is one conflict with the vfio-next branch [2], on patch 6.

The remainder of the work that Jason Gunthorpe originally started [1]
in this space remains for a future day.

v2-v3:
 - [KW, MR, JG] Added r-b's (Thank You!)
 - Patch 7 (new):
   - [MR] Add better debug to fsm_notoper
 - Patch 8:
   - [MR] Call fsm_notoper for the OPEN event from STANDBY state
   - [EF] Drop FSM state=STANDBY in vfio_ccw_sch_probe()
     (it is handled in FSM, and was dropped by patch 10)
 - Patch 9:
   - [MR] Call fsm_close for the CLOSE event from STANDBY state
v2: https://lore.kernel.org/r/20220615203318.3830778-1-farman@linux.ibm.com/
v1: https://lore.kernel.org/r/20220602171948.2790690-1-farman@linux.ibm.com/

Footnotes:
[1] https://lore.kernel.org/r/0-v3-57c1502c62fd+2190-ccw_mdev_jgg@nvidia.com/

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
 drivers/s390/cio/vfio_ccw_drv.c     | 59 +++++-------------
 drivers/s390/cio/vfio_ccw_fsm.c     | 97 ++++++++++++++++++++++++-----
 drivers/s390/cio/vfio_ccw_ops.c     | 77 +++++++----------------
 drivers/s390/cio/vfio_ccw_private.h |  9 +--
 include/linux/mdev.h                |  5 --
 6 files changed, 123 insertions(+), 125 deletions(-)

-- 
2.32.0

