Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77EE2D79B5
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 17:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733233AbfJOPYL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 11:24:11 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59036 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726523AbfJOPYL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 15 Oct 2019 11:24:11 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9FFDGDd078472;
        Tue, 15 Oct 2019 11:24:08 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2vng7e1cqe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Oct 2019 11:24:08 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x9FFDUig079645;
        Tue, 15 Oct 2019 11:24:07 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2vng7e1cq0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Oct 2019 11:24:07 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x9FFLNUT004956;
        Tue, 15 Oct 2019 15:24:07 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma04dal.us.ibm.com with ESMTP id 2vk6f7bhmh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Oct 2019 15:24:07 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9FFO6d754591992
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Oct 2019 15:24:06 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 55C20AE064;
        Tue, 15 Oct 2019 15:24:06 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 08FD0AE05C;
        Tue, 15 Oct 2019 15:24:06 +0000 (GMT)
Received: from [9.85.147.229] (unknown [9.85.147.229])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 15 Oct 2019 15:24:05 +0000 (GMT)
Subject: Re: [RFC PATCH 3/4] vfio-ccw: Add a trace for asynchronous requests
To:     Steffen Maier <maier@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>
Cc:     Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20191014180855.19400-1-farman@linux.ibm.com>
 <20191014180855.19400-4-farman@linux.ibm.com>
 <2fd50890-2d94-37ae-8266-1b41b9bf9a74@linux.ibm.com>
From:   Eric Farman <farman@linux.ibm.com>
Message-ID: <7c52ae8f-c38d-206e-03fb-11e89a8f1dd7@linux.ibm.com>
Date:   Tue, 15 Oct 2019 11:24:05 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <2fd50890-2d94-37ae-8266-1b41b9bf9a74@linux.ibm.com>
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
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910150135
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/15/19 5:54 AM, Steffen Maier wrote:
> On 10/14/19 8:08 PM, Eric Farman wrote:
>> Since the asynchronous requests are typically associated with
>> error recovery, let's add a simple trace when one of those is
>> issued to a device.
>>
>> Signed-off-by: Eric Farman <farman@linux.ibm.com>
>> ---
>>   drivers/s390/cio/vfio_ccw_fsm.c   |  4 ++++
>>   drivers/s390/cio/vfio_ccw_trace.c |  1 +
>>   drivers/s390/cio/vfio_ccw_trace.h | 26 ++++++++++++++++++++++++++
>>   3 files changed, 31 insertions(+)
>>
>> diff --git a/drivers/s390/cio/vfio_ccw_fsm.c
>> b/drivers/s390/cio/vfio_ccw_fsm.c
>> index d4119e4c4a8c..23648a9aa721 100644
>> --- a/drivers/s390/cio/vfio_ccw_fsm.c
>> +++ b/drivers/s390/cio/vfio_ccw_fsm.c
>> @@ -341,6 +341,10 @@ static void fsm_async_request(struct
>> vfio_ccw_private *private,
>>           /* should not happen? */
>>           cmd_region->ret_code = -EINVAL;
>>       }
>> +
>> +    trace_vfio_ccw_fsm_async_request(get_schid(private),
>> +                     cmd_region->command,
>> +                     cmd_region->ret_code);
>>   }
>>
>>   /*
>> diff --git a/drivers/s390/cio/vfio_ccw_trace.c
>> b/drivers/s390/cio/vfio_ccw_trace.c
>> index b37bc68e7f18..37ecbf8be805 100644
>> --- a/drivers/s390/cio/vfio_ccw_trace.c
>> +++ b/drivers/s390/cio/vfio_ccw_trace.c
>> @@ -9,5 +9,6 @@
>>   #define CREATE_TRACE_POINTS
>>   #include "vfio_ccw_trace.h"
>>
>> +EXPORT_TRACEPOINT_SYMBOL(vfio_ccw_fsm_async_request);
>>   EXPORT_TRACEPOINT_SYMBOL(vfio_ccw_fsm_event);
>>   EXPORT_TRACEPOINT_SYMBOL(vfio_ccw_io_fctl);
>> diff --git a/drivers/s390/cio/vfio_ccw_trace.h
>> b/drivers/s390/cio/vfio_ccw_trace.h
>> index 24a8152acfdf..4be2e36242e6 100644
>> --- a/drivers/s390/cio/vfio_ccw_trace.h
>> +++ b/drivers/s390/cio/vfio_ccw_trace.h
>> @@ -17,6 +17,32 @@
>>
>>   #include <linux/tracepoint.h>
>>
>> +TRACE_EVENT(vfio_ccw_fsm_async_request,
>> +    TP_PROTO(struct subchannel_id schid,
>> +         int command,
>> +         int errno),
>> +    TP_ARGS(schid, command, errno),
>> +
>> +    TP_STRUCT__entry(
>> +        __field_struct(struct subchannel_id, schid)
> 
> Not sure: Does this allow the user to filter for fields of struct
> subchannel_id or can the user express a filter on the entire combined
> struct subchannel_id?

Good question...  I tried playing around with this a little bit, and
while format says it's using "REC->schid.foo", trying any combination to
get an element within schid just fails, citing some form of invalid
argument (the exact reason depends on what I try).  Harrumph.

> In the preceding patch you have the 3 parts of schid as explicit
> separate trace fields in the tracepoint.

Yeah, I did.  Why didn't I do that here?  :)

Well it seems that the one trace that exists (vfio_ccw_fsm_io_request
(nee vfio_ccw_fsm_io_fctl)), uses this same field_struct, instead of the
three-piece schid.  So, I need to change this in both the I/O and
asynchronous traces.

Thanks for the suggestions!
 - Eric

> 
>> +        __field(int, command)
>> +        __field(int, errno)
>> +    ),
>> +
>> +    TP_fast_assign(
>> +        __entry->schid = schid;
>> +        __entry->command = command;
>> +        __entry->errno = errno;
>> +    ),
>> +
>> +    TP_printk("schid=%x.%x.%04x command=%d errno=%d",
>> +          __entry->schid.cssid,
>> +          __entry->schid.ssid,
>> +          __entry->schid.sch_no,
>> +          __entry->command,
>> +          __entry->errno)
>> +);
>> +
>>   TRACE_EVENT(vfio_ccw_fsm_event,
>>       TP_PROTO(struct subchannel_id schid, int state, int event),
>>       TP_ARGS(schid, state, event),
>>
> 
> 
