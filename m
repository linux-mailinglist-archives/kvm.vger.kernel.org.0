Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8A4735E64B
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 20:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347659AbhDMSYl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 14:24:41 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53216 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347644AbhDMSYj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Apr 2021 14:24:39 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13DI3LJD174939;
        Tue, 13 Apr 2021 14:24:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=Mcj9KNyb1VQD9tj3wCqDsBlIU/svScL3oqGgdcN5QYs=;
 b=FV0T1FHiogE4wPvFv6aB9jN/7LfHl280jSWtYGm8rJ4bOo4i1yBkRFNWM3UqcIyqoUZZ
 XDDnUjCtSAR8lNpldUeD77fBXOLzAbv+J0pJyF/FbeFQ2SVmFRpoYU4C3aDlnRG+7lfQ
 BRDb6LUQs6/ClHBBrJdRg9uiLWmHSRIOdRdbywyc/WwZCLzPgKTxcNHWYSDcI+1REYXk
 YeUc4FQUXtghADv0cfawrPNn5jpuDjM6rimGLOPfADQXsWqNxBznKZTe52h8o85j+0nW
 sgmrYszWrEEBF3NrMo/0AGmF1TQlPz3EjSYP5p465Oa+xVEmSQMLibG6LiCeKvhCAre1 vA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37webguqq9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Apr 2021 14:24:18 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13DI3NZB175114;
        Tue, 13 Apr 2021 14:24:18 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37webguqpm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Apr 2021 14:24:17 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13DIOGTg005743;
        Tue, 13 Apr 2021 18:24:16 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 37u3n89gq3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Apr 2021 18:24:16 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13DIODPN28180832
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 18:24:13 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DCDCE52052;
        Tue, 13 Apr 2021 18:24:12 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id C922452054;
        Tue, 13 Apr 2021 18:24:12 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 7A553E045F; Tue, 13 Apr 2021 20:24:12 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [RFC PATCH v4 0/4] vfio-ccw: Fix interrupt handling for HALT/CLEAR
Date:   Tue, 13 Apr 2021 20:24:06 +0200
Message-Id: <20210413182410.1396170-1-farman@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: aXEvu7h_WgfUNsKDSpLfdw-30kt-u1g-
X-Proofpoint-ORIG-GUID: fTwHtlTHMYvLtGaSkZ7V6KtnAsjAzqI2
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-13_12:2021-04-13,2021-04-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0 mlxlogscore=999
 spamscore=0 priorityscore=1501 mlxscore=0 suspectscore=0 impostorscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130122
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Conny, Halil,

Let's restart our discussion about the collision between interrupts for
START SUBCHANNEL and HALT/CLEAR SUBCHANNEL. It's been a quarter million
minutes (give or take), so here is the problematic scenario again:

	CPU 1			CPU 2
 1	CLEAR SUBCHANNEL
 2	fsm_irq()
 3				START SUBCHANNEL
 4	vfio_ccw_sch_io_todo()
 5				fsm_irq()
 6				vfio_ccw_sch_io_todo()

From the channel subsystem's point of view the CLEAR SUBCHANNEL (step 1)
is complete once step 2 is called, as the Interrupt Response Block (IRB)
has been presented and the TEST SUBCHANNEL was driven by the cio layer.
Thus, the START SUBCHANNEL (step 3) is submitted [1] and gets a cc=0 to
indicate the I/O was accepted. However, step 2 stacks the bulk of the
actual work onto a workqueue for when the subchannel lock is NOT held,
and is unqueued at step 4. That code misidentifies the data in the IRB
as being associated with the newly active I/O, and may release memory
that is actively in use by the channel subsystem and/or device. Eww.

In this version...

Patch 1 and 2 are defensive checks. Patch 2 was part of v3 [2], but I
would love a better option here to guard between steps 2 and 4.

Patch 3 is a subset of the removal of the CP_PENDING FSM state in v3.
I've obviously gone away from this idea, but I thought this piece is
still valuable.

Patch 4 collapses the code on the interrupt path so that changes to
the FSM state and the channel_program struct are handled at the same
point, rather than separated by a mutex boundary. Because of the
possibility of a START and HALT/CLEAR running concurrently, it does
not make sense to split them here.

With the above patches, maybe it then makes sense to hold the io_mutex
across the entirety of vfio_ccw_sch_io_todo(). But I'm not completely
sure that would be acceptable.

So... Thoughts?

Thanks,
Eric

Previous versions:
v3: https://lore.kernel.org/kvm/20200616195053.99253-1-farman@linux.ibm.com/
v2: https://lore.kernel.org/kvm/20200513142934.28788-1-farman@linux.ibm.com/
v1: https://lore.kernel.org/kvm/20200124145455.51181-1-farman@linux.ibm.com/

Footnotes:
[1] Halil correctly asserts that today's QEMU should prohibit this, but I
    still have not looked into why. The above is the sequence that is
    occurring in the kernel, and we shouldn't rely on a well-behaved
    userspace to enforce things for us. It is still on my list for further
    investigation, but it's lower in priority.
[2] https://lore.kernel.org/kvm/20200619134005.512fc54f.cohuck@redhat.com/

Eric Farman (4):
  vfio-ccw: Check initialized flag in cp_init()
  vfio-ccw: Check workqueue before doing START
  vfio-ccw: Reset FSM state to IDLE inside FSM
  vfio-ccw: Reset FSM state to IDLE before io_mutex

 drivers/s390/cio/vfio_ccw_cp.c  | 4 ++++
 drivers/s390/cio/vfio_ccw_drv.c | 7 +++----
 drivers/s390/cio/vfio_ccw_fsm.c | 6 ++++++
 drivers/s390/cio/vfio_ccw_ops.c | 2 --
 4 files changed, 13 insertions(+), 6 deletions(-)

-- 
2.25.1

