Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 239A3D8FAA
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 13:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbfJPLgR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 07:36:17 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:29852 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726078AbfJPLgR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 16 Oct 2019 07:36:17 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9GBXCn6061229;
        Wed, 16 Oct 2019 07:36:15 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2vp07ww3ds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Oct 2019 07:36:15 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x9GBYNaC064735;
        Wed, 16 Oct 2019 07:36:14 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2vp07ww3d8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Oct 2019 07:36:14 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x9GBZgPF019152;
        Wed, 16 Oct 2019 11:36:13 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma04dal.us.ibm.com with ESMTP id 2vk6f7mx2n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Oct 2019 11:36:13 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9GBaCsQ43778538
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Oct 2019 11:36:12 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D8631BE054;
        Wed, 16 Oct 2019 11:36:11 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6E094BE051;
        Wed, 16 Oct 2019 11:36:10 +0000 (GMT)
Received: from [9.80.230.104] (unknown [9.80.230.104])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 16 Oct 2019 11:36:10 +0000 (GMT)
Subject: Re: [PATCH v2 3/4] vfio-ccw: Add a trace for asynchronous requests
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Steffen Maier <maier@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20191016015822.72425-1-farman@linux.ibm.com>
 <20191016015822.72425-4-farman@linux.ibm.com>
 <20191016121543.2b3f0a88.cohuck@redhat.com>
From:   Eric Farman <farman@linux.ibm.com>
Message-ID: <6c559ea3-4abd-d83b-4a20-d022a188545e@linux.ibm.com>
Date:   Wed, 16 Oct 2019 07:36:09 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191016121543.2b3f0a88.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-16_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910160105
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/16/19 6:15 AM, Cornelia Huck wrote:
> On Wed, 16 Oct 2019 03:58:21 +0200
> Eric Farman <farman@linux.ibm.com> wrote:
> 
>> Since the asynchronous requests are typically associated with
>> error recovery, let's add a simple trace when one of those is
>> issued to a device.
>>
>> Signed-off-by: Eric Farman <farman@linux.ibm.com>
>> ---
>>  drivers/s390/cio/vfio_ccw_fsm.c   |  4 ++++
>>  drivers/s390/cio/vfio_ccw_trace.c |  1 +
>>  drivers/s390/cio/vfio_ccw_trace.h | 30 ++++++++++++++++++++++++++++++
>>  3 files changed, 35 insertions(+)
> 
> (...)
> 
>> diff --git a/drivers/s390/cio/vfio_ccw_trace.h b/drivers/s390/cio/vfio_ccw_trace.h
>> index 5005d57901b4..23b288eb53dc 100644
>> --- a/drivers/s390/cio/vfio_ccw_trace.h
>> +++ b/drivers/s390/cio/vfio_ccw_trace.h
>> @@ -17,6 +17,36 @@
>>  
>>  #include <linux/tracepoint.h>
>>  
>> +TRACE_EVENT(vfio_ccw_fsm_async_request,
>> +	TP_PROTO(struct subchannel_id schid,
>> +		 int command,
>> +		 int errno),
>> +	TP_ARGS(schid, command, errno),
>> +
>> +	TP_STRUCT__entry(
>> +		__field(u8, cssid)
>> +		__field(u8, ssid)
>> +		__field(u16, sch_no)
>> +		__field(int, command)
>> +		__field(int, errno)
>> +	),
>> +
>> +	TP_fast_assign(
>> +		__entry->cssid = schid.cssid;
>> +		__entry->ssid = schid.ssid;
>> +		__entry->sch_no = schid.sch_no;
>> +		__entry->command = command;
>> +		__entry->errno = errno;
>> +	),
>> +
>> +	TP_printk("schid=%x.%x.%04x command=%d errno=%d",
> 
> I'd probably rather print the command as a hex value.

I'm fine with that too.  Want me to send an update?

> 
>> +		  __entry->cssid,
>> +		  __entry->ssid,
>> +		  __entry->sch_no,
>> +		  __entry->command,
>> +		  __entry->errno)
>> +);
>> +
>>  TRACE_EVENT(vfio_ccw_fsm_event,
>>  	TP_PROTO(struct subchannel_id schid, int state, int event),
>>  	TP_ARGS(schid, state, event),
> 
