Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA62F1C5568
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 14:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728908AbgEEM16 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 08:27:58 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52188 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727090AbgEEM1x (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 May 2020 08:27:53 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 045CRisE196339;
        Tue, 5 May 2020 08:27:53 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30s45tt2n1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 May 2020 08:27:53 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 045CRjfx196455;
        Tue, 5 May 2020 08:27:52 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30s45tt2ke-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 May 2020 08:27:52 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 045CQRJj021271;
        Tue, 5 May 2020 12:27:48 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 30s0g5atvn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 May 2020 12:27:48 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 045CRjkt65667196
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 May 2020 12:27:45 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C3A7852050;
        Tue,  5 May 2020 12:27:45 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id AED7E5204F;
        Tue,  5 May 2020 12:27:45 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 2ACB7E1262; Tue,  5 May 2020 14:27:45 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     linux-s390@vger.kernel.org, kvm@vger.kernel.org
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v4 8/8] vfio-ccw: Add trace for CRW event
Date:   Tue,  5 May 2020 14:27:45 +0200
Message-Id: <20200505122745.53208-9-farman@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200505122745.53208-1-farman@linux.ibm.com>
References: <20200505122745.53208-1-farman@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-05_07:2020-05-04,2020-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 adultscore=0
 phishscore=0 clxscore=1015 suspectscore=0 impostorscore=0 mlxscore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050098
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since CRW events are (should be) rare, let's put a trace
in that routine too.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
---

Notes:
    v3->v4:
     - Added Conny's r-b

 drivers/s390/cio/vfio_ccw_drv.c   |  1 +
 drivers/s390/cio/vfio_ccw_trace.c |  1 +
 drivers/s390/cio/vfio_ccw_trace.h | 30 ++++++++++++++++++++++++++++++
 3 files changed, 32 insertions(+)

diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index 9144360851ed..8c625b530035 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -336,6 +336,7 @@ static int vfio_ccw_chp_event(struct subchannel *sch,
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
index f5d31887d413..62fb30598d47 100644
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

