Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA15A154E11
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 22:38:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727589AbgBFVie (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 16:38:34 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:17966 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727524AbgBFVid (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 Feb 2020 16:38:33 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 016LajNB109970
        for <kvm@vger.kernel.org>; Thu, 6 Feb 2020 16:38:32 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y0mpnnmj3-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 06 Feb 2020 16:38:32 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <farman@linux.ibm.com>;
        Thu, 6 Feb 2020 21:38:30 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 6 Feb 2020 21:38:28 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 016LcQZs36372724
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 6 Feb 2020 21:38:26 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 96E12A4040;
        Thu,  6 Feb 2020 21:38:26 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 85C97A4053;
        Thu,  6 Feb 2020 21:38:26 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu,  6 Feb 2020 21:38:26 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id B9598E029E; Thu,  6 Feb 2020 22:38:25 +0100 (CET)
From:   Eric Farman <farman@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [RFC PATCH v2 8/9] vfio-ccw: Add trace for CRW event
Date:   Thu,  6 Feb 2020 22:38:24 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200206213825.11444-1-farman@linux.ibm.com>
References: <20200206213825.11444-1-farman@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20020621-4275-0000-0000-0000039EA97C
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20020621-4276-0000-0000-000038B2D804
Message-Id: <20200206213825.11444-9-farman@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-06_04:2020-02-06,2020-02-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 clxscore=1015 suspectscore=0 lowpriorityscore=0
 adultscore=0 malwarescore=0 impostorscore=0 phishscore=0 mlxscore=0
 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002060157
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since CRW events are (should be) rare, let's put a trace
in that routine too.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_drv.c   |  1 +
 drivers/s390/cio/vfio_ccw_trace.c |  1 +
 drivers/s390/cio/vfio_ccw_trace.h | 30 ++++++++++++++++++++++++++++++
 3 files changed, 32 insertions(+)

diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index c48c260a129d..21952258d71a 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -357,6 +357,7 @@ static int vfio_ccw_chp_event(struct subchannel *sch,
 	if (!private || !mask)
 		return 0;
 
+	trace_vfio_ccw_chp_event(private->sch->schid, mask, event);
 	VFIO_CCW_MSG_EVENT(2, "%pUl (%x.%x.%04x): mask=0x%x event=%d\n",
 			   mdev_uuid(private->mdev), sch->schid.cssid,
 			   sch->schid.ssid, sch->schid.sch_no,
diff --git a/drivers/s390/cio/vfio_ccw_trace.c b/drivers/s390/cio/vfio_ccw_trace.c
index 8c671d2519f6..4a0205905afc 100644
--- a/drivers/s390/cio/vfio_ccw_trace.c
+++ b/drivers/s390/cio/vfio_ccw_trace.c
@@ -9,6 +9,7 @@
 #define CREATE_TRACE_POINTS
 #include "vfio_ccw_trace.h"
 
+EXPORT_TRACEPOINT_SYMBOL(vfio_ccw_chp_event);
 EXPORT_TRACEPOINT_SYMBOL(vfio_ccw_fsm_async_request);
 EXPORT_TRACEPOINT_SYMBOL(vfio_ccw_fsm_event);
 EXPORT_TRACEPOINT_SYMBOL(vfio_ccw_fsm_io_request);
diff --git a/drivers/s390/cio/vfio_ccw_trace.h b/drivers/s390/cio/vfio_ccw_trace.h
index 30162a318a8a..8c82d0c27e81 100644
--- a/drivers/s390/cio/vfio_ccw_trace.h
+++ b/drivers/s390/cio/vfio_ccw_trace.h
@@ -17,6 +17,36 @@
 
 #include <linux/tracepoint.h>
 
+TRACE_EVENT(vfio_ccw_chp_event,
+	TP_PROTO(struct subchannel_id schid,
+		 int mask,
+		 int event),
+	TP_ARGS(schid, mask, event),
+
+	TP_STRUCT__entry(
+		__field(u8, cssid)
+		__field(u8, ssid)
+		__field(u16, sch_no)
+		__field(int, mask)
+		__field(int, event)
+	),
+
+	TP_fast_assign(
+		__entry->cssid = schid.cssid;
+		__entry->ssid = schid.ssid;
+		__entry->sch_no = schid.sch_no;
+		__entry->mask = mask;
+		__entry->event = event;
+	),
+
+	TP_printk("schid=%x.%x.%04x mask=0x%x event=%d",
+		  __entry->cssid,
+		  __entry->ssid,
+		  __entry->sch_no,
+		  __entry->mask,
+		  __entry->event)
+);
+
 TRACE_EVENT(vfio_ccw_fsm_async_request,
 	TP_PROTO(struct subchannel_id schid,
 		 int command,
-- 
2.17.1

