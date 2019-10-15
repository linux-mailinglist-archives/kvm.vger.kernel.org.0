Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49A33D7297
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 11:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbfJOJyW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 05:54:22 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:7158 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727033AbfJOJyW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 15 Oct 2019 05:54:22 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9F9lxZ3057780
        for <kvm@vger.kernel.org>; Tue, 15 Oct 2019 05:54:21 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vn8n175kg-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 15 Oct 2019 05:54:20 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <maier@linux.ibm.com>;
        Tue, 15 Oct 2019 10:54:18 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 15 Oct 2019 10:54:15 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9F9sEjQ54919300
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Oct 2019 09:54:14 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1E1D652052;
        Tue, 15 Oct 2019 09:54:14 +0000 (GMT)
Received: from oc4120165700.ibm.com (unknown [9.152.99.188])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id BD86452054;
        Tue, 15 Oct 2019 09:54:13 +0000 (GMT)
Subject: Re: [RFC PATCH 3/4] vfio-ccw: Add a trace for asynchronous requests
To:     Eric Farman <farman@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>
Cc:     Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20191014180855.19400-1-farman@linux.ibm.com>
 <20191014180855.19400-4-farman@linux.ibm.com>
From:   Steffen Maier <maier@linux.ibm.com>
Date:   Tue, 15 Oct 2019 11:54:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191014180855.19400-4-farman@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19101509-0016-0000-0000-000002B8305D
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19101509-0017-0000-0000-000033194E09
Message-Id: <2fd50890-2d94-37ae-8266-1b41b9bf9a74@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-15_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910150091
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/14/19 8:08 PM, Eric Farman wrote:
> Since the asynchronous requests are typically associated with
> error recovery, let's add a simple trace when one of those is
> issued to a device.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>   drivers/s390/cio/vfio_ccw_fsm.c   |  4 ++++
>   drivers/s390/cio/vfio_ccw_trace.c |  1 +
>   drivers/s390/cio/vfio_ccw_trace.h | 26 ++++++++++++++++++++++++++
>   3 files changed, 31 insertions(+)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_fsm.c b/drivers/s390/cio/vfio_ccw_fsm.c
> index d4119e4c4a8c..23648a9aa721 100644
> --- a/drivers/s390/cio/vfio_ccw_fsm.c
> +++ b/drivers/s390/cio/vfio_ccw_fsm.c
> @@ -341,6 +341,10 @@ static void fsm_async_request(struct vfio_ccw_private *private,
>   		/* should not happen? */
>   		cmd_region->ret_code = -EINVAL;
>   	}
> +
> +	trace_vfio_ccw_fsm_async_request(get_schid(private),
> +					 cmd_region->command,
> +					 cmd_region->ret_code);
>   }
> 
>   /*
> diff --git a/drivers/s390/cio/vfio_ccw_trace.c b/drivers/s390/cio/vfio_ccw_trace.c
> index b37bc68e7f18..37ecbf8be805 100644
> --- a/drivers/s390/cio/vfio_ccw_trace.c
> +++ b/drivers/s390/cio/vfio_ccw_trace.c
> @@ -9,5 +9,6 @@
>   #define CREATE_TRACE_POINTS
>   #include "vfio_ccw_trace.h"
> 
> +EXPORT_TRACEPOINT_SYMBOL(vfio_ccw_fsm_async_request);
>   EXPORT_TRACEPOINT_SYMBOL(vfio_ccw_fsm_event);
>   EXPORT_TRACEPOINT_SYMBOL(vfio_ccw_io_fctl);
> diff --git a/drivers/s390/cio/vfio_ccw_trace.h b/drivers/s390/cio/vfio_ccw_trace.h
> index 24a8152acfdf..4be2e36242e6 100644
> --- a/drivers/s390/cio/vfio_ccw_trace.h
> +++ b/drivers/s390/cio/vfio_ccw_trace.h
> @@ -17,6 +17,32 @@
> 
>   #include <linux/tracepoint.h>
> 
> +TRACE_EVENT(vfio_ccw_fsm_async_request,
> +	TP_PROTO(struct subchannel_id schid,
> +		 int command,
> +		 int errno),
> +	TP_ARGS(schid, command, errno),
> +
> +	TP_STRUCT__entry(
> +		__field_struct(struct subchannel_id, schid)

Not sure: Does this allow the user to filter for fields of struct subchannel_id 
or can the user express a filter on the entire combined struct subchannel_id?
In the preceding patch you have the 3 parts of schid as explicit separate trace 
fields in the tracepoint.

> +		__field(int, command)
> +		__field(int, errno)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->schid = schid;
> +		__entry->command = command;
> +		__entry->errno = errno;
> +	),
> +
> +	TP_printk("schid=%x.%x.%04x command=%d errno=%d",
> +		  __entry->schid.cssid,
> +		  __entry->schid.ssid,
> +		  __entry->schid.sch_no,
> +		  __entry->command,
> +		  __entry->errno)
> +);
> +
>   TRACE_EVENT(vfio_ccw_fsm_event,
>   	TP_PROTO(struct subchannel_id schid, int state, int event),
>   	TP_ARGS(schid, state, event),
> 


-- 
Mit freundlichen Gruessen / Kind regards
Steffen Maier

Linux on IBM Z Development

https://www.ibm.com/privacy/us/en/
IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Matthias Hartmann
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

