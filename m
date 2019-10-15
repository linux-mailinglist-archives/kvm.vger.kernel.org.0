Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DCAAD779A
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 15:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732095AbfJONmp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 09:42:45 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:51932 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728880AbfJONmp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 15 Oct 2019 09:42:45 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9FDc72Z136888;
        Tue, 15 Oct 2019 09:42:42 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2vne46txx3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Oct 2019 09:42:41 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x9FDcXPc139555;
        Tue, 15 Oct 2019 09:42:41 -0400
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2vne46txwd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Oct 2019 09:42:41 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x9FDeoEG009261;
        Tue, 15 Oct 2019 13:42:40 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma05wdc.us.ibm.com with ESMTP id 2vk6f73q23-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Oct 2019 13:42:40 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9FDgdv441157046
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Oct 2019 13:42:39 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 85BC07805E;
        Tue, 15 Oct 2019 13:42:39 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4E5317805F;
        Tue, 15 Oct 2019 13:42:38 +0000 (GMT)
Received: from [9.85.147.229] (unknown [9.85.147.229])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 15 Oct 2019 13:42:38 +0000 (GMT)
Subject: Re: [RFC PATCH 2/4] vfio-ccw: Trace the FSM jumptable
To:     Steffen Maier <maier@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>
Cc:     Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20191014180855.19400-1-farman@linux.ibm.com>
 <20191014180855.19400-3-farman@linux.ibm.com>
 <96431f2f-774c-0be2-54ef-ebcaa4ae7298@linux.ibm.com>
From:   Eric Farman <farman@linux.ibm.com>
Message-ID: <b9d59763-4052-2dbb-ffc7-32f6cec9c426@linux.ibm.com>
Date:   Tue, 15 Oct 2019 09:42:37 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <96431f2f-774c-0be2-54ef-ebcaa4ae7298@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-15_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910150123
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/15/19 6:01 AM, Steffen Maier wrote:
> On 10/14/19 8:08 PM, Eric Farman wrote:
>> It would be nice if we could track the sequence of events within
>> vfio-ccw, based on the state of the device/FSM and our calling
>> sequence within it.  So let's add a simple trace here so we can
>> watch the states change as things go, and allow it to be folded
>> into the rest of the other cio traces.
>>
>> Signed-off-by: Eric Farman <farman@linux.ibm.com>
>> ---
>>   drivers/s390/cio/vfio_ccw_private.h |  1 +
>>   drivers/s390/cio/vfio_ccw_trace.c   |  1 +
>>   drivers/s390/cio/vfio_ccw_trace.h   | 26 ++++++++++++++++++++++++++
>>   3 files changed, 28 insertions(+)
>>
>> diff --git a/drivers/s390/cio/vfio_ccw_private.h
>> b/drivers/s390/cio/vfio_ccw_private.h
>> index bbe9babf767b..9b9bb4982972 100644
>> --- a/drivers/s390/cio/vfio_ccw_private.h
>> +++ b/drivers/s390/cio/vfio_ccw_private.h
>> @@ -135,6 +135,7 @@ extern fsm_func_t
>> *vfio_ccw_jumptable[NR_VFIO_CCW_STATES][NR_VFIO_CCW_EVENTS];
>>   static inline void vfio_ccw_fsm_event(struct vfio_ccw_private *private,
>>                        int event)
>>   {
>> +    trace_vfio_ccw_fsm_event(private->sch->schid, private->state,
>> event);
>>       vfio_ccw_jumptable[private->state][event](private, event);
>>   }
>>
>> diff --git a/drivers/s390/cio/vfio_ccw_trace.c
>> b/drivers/s390/cio/vfio_ccw_trace.c
>> index d5cc943c6864..b37bc68e7f18 100644
>> --- a/drivers/s390/cio/vfio_ccw_trace.c
>> +++ b/drivers/s390/cio/vfio_ccw_trace.c
>> @@ -9,4 +9,5 @@
>>   #define CREATE_TRACE_POINTS
>>   #include "vfio_ccw_trace.h"
>>
>> +EXPORT_TRACEPOINT_SYMBOL(vfio_ccw_fsm_event);
>>   EXPORT_TRACEPOINT_SYMBOL(vfio_ccw_io_fctl);
>> diff --git a/drivers/s390/cio/vfio_ccw_trace.h
>> b/drivers/s390/cio/vfio_ccw_trace.h
>> index 2a2937a40124..24a8152acfdf 100644
>> --- a/drivers/s390/cio/vfio_ccw_trace.h
>> +++ b/drivers/s390/cio/vfio_ccw_trace.h
>> @@ -17,6 +17,32 @@
>>
>>   #include <linux/tracepoint.h>
>>
>> +TRACE_EVENT(vfio_ccw_fsm_event,
>> +    TP_PROTO(struct subchannel_id schid, int state, int event),
>> +    TP_ARGS(schid, state, event),
>> +
>> +    TP_STRUCT__entry(
>> +        __field(u8, cssid)
>> +        __field(u8, ssid)
>> +        __field(u16, schno)
>> +        __field(int, state)
>> +        __field(int, event)
>> +    ),
>> +
>> +    TP_fast_assign(
>> +        __entry->cssid = schid.cssid;
>> +        __entry->ssid = schid.ssid;
>> +        __entry->schno = schid.sch_no;
>> +        __entry->state = state;
>> +        __entry->event = event;
>> +    ),
>> +
>> +    TP_printk("schid=%x.%x.%04x state=%x event=%x",
> 
> /sys/kernel/debug/tracing/events](0)# grep -R '%[^%]*x'
> 
> Many existing TPs often seem to format hex output with a 0x prefix
> (either explicit with 0x%x or implicit with %#x). Since some of your
> other TPs also output decimal integer values, I wonder if a distinction
> would help unexperienced TP readers.

Fair enough.  Since they're just enumerated values, they are probably
better as %d; I don't have a good reason for picking %x (with or without
a preceding 0x).

> 
>> +        __entry->cssid, __entry->ssid, __entry->schno,
>> +        __entry->state,
>> +        __entry->event)
>> +);
>> +
>>   TRACE_EVENT(vfio_ccw_io_fctl,
>>       TP_PROTO(int fctl, struct subchannel_id schid, int errno, char
>> *errstr),
>>       TP_ARGS(fctl, schid, errno, errstr),
>>
> 
> 
