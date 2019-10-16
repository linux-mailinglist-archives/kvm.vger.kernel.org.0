Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80DC6D92A5
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 15:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391854AbfJPNfq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 09:35:46 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41158 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728986AbfJPNfp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 16 Oct 2019 09:35:45 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9GDRhwR196426;
        Wed, 16 Oct 2019 09:35:40 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2vp39p2xrg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Oct 2019 09:35:39 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x9GDSNNP003176;
        Wed, 16 Oct 2019 09:35:39 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2vp39p2xr1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Oct 2019 09:35:39 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x9GDU4qe006137;
        Wed, 16 Oct 2019 13:35:38 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma02dal.us.ibm.com with ESMTP id 2vk6f7nw32-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Oct 2019 13:35:38 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9GDZbW152953496
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Oct 2019 13:35:37 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 90D31AC05F;
        Wed, 16 Oct 2019 13:35:37 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 633C1AC060;
        Wed, 16 Oct 2019 13:35:37 +0000 (GMT)
Received: from [9.60.75.213] (unknown [9.60.75.213])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 16 Oct 2019 13:35:37 +0000 (GMT)
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
 <6c559ea3-4abd-d83b-4a20-d022a188545e@linux.ibm.com>
 <20191016133919.6f8592e7.cohuck@redhat.com>
From:   Eric Farman <farman@linux.ibm.com>
Message-ID: <1e32a1ba-e187-c0db-05cc-ccea1dc3f7b0@linux.ibm.com>
Date:   Wed, 16 Oct 2019 09:35:37 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191016133919.6f8592e7.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-16_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910160120
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/16/19 7:39 AM, Cornelia Huck wrote:
> On Wed, 16 Oct 2019 07:36:09 -0400
> Eric Farman <farman@linux.ibm.com> wrote:
> 
>> On 10/16/19 6:15 AM, Cornelia Huck wrote:
>>> On Wed, 16 Oct 2019 03:58:21 +0200
>>> Eric Farman <farman@linux.ibm.com> wrote:
>>>   
>>>> Since the asynchronous requests are typically associated with
>>>> error recovery, let's add a simple trace when one of those is
>>>> issued to a device.
>>>>
>>>> Signed-off-by: Eric Farman <farman@linux.ibm.com>
>>>> ---
>>>>  drivers/s390/cio/vfio_ccw_fsm.c   |  4 ++++
>>>>  drivers/s390/cio/vfio_ccw_trace.c |  1 +
>>>>  drivers/s390/cio/vfio_ccw_trace.h | 30 ++++++++++++++++++++++++++++++
>>>>  3 files changed, 35 insertions(+)  
>>>
>>> (...)
>>>   
>>>> diff --git a/drivers/s390/cio/vfio_ccw_trace.h b/drivers/s390/cio/vfio_ccw_trace.h
>>>> index 5005d57901b4..23b288eb53dc 100644
>>>> --- a/drivers/s390/cio/vfio_ccw_trace.h
>>>> +++ b/drivers/s390/cio/vfio_ccw_trace.h
>>>> @@ -17,6 +17,36 @@
>>>>  
>>>>  #include <linux/tracepoint.h>
>>>>  
>>>> +TRACE_EVENT(vfio_ccw_fsm_async_request,
>>>> +	TP_PROTO(struct subchannel_id schid,
>>>> +		 int command,
>>>> +		 int errno),
>>>> +	TP_ARGS(schid, command, errno),
>>>> +
>>>> +	TP_STRUCT__entry(
>>>> +		__field(u8, cssid)
>>>> +		__field(u8, ssid)
>>>> +		__field(u16, sch_no)
>>>> +		__field(int, command)
>>>> +		__field(int, errno)
>>>> +	),
>>>> +
>>>> +	TP_fast_assign(
>>>> +		__entry->cssid = schid.cssid;
>>>> +		__entry->ssid = schid.ssid;
>>>> +		__entry->sch_no = schid.sch_no;
>>>> +		__entry->command = command;
>>>> +		__entry->errno = errno;
>>>> +	),
>>>> +
>>>> +	TP_printk("schid=%x.%x.%04x command=%d errno=%d",  
>>>
>>> I'd probably rather print the command as a hex value.  
>>
>> I'm fine with that too.  Want me to send an update?
> 
> I think that would be the easiest way.

Will do.  Thanks for the reviews on the other ones!

 - Eric

> 
>>
>>>   
>>>> +		  __entry->cssid,
>>>> +		  __entry->ssid,
>>>> +		  __entry->sch_no,
>>>> +		  __entry->command,
>>>> +		  __entry->errno)
>>>> +);
>>>> +
>>>>  TRACE_EVENT(vfio_ccw_fsm_event,
>>>>  	TP_PROTO(struct subchannel_id schid, int state, int event),
>>>>  	TP_ARGS(schid, state, event),  
>>>   
> 
