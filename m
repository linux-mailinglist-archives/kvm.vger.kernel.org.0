Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F28091A006E
	for <lists+kvm@lfdr.de>; Mon,  6 Apr 2020 23:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbgDFVnr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Apr 2020 17:43:47 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:31192 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725933AbgDFVnq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Apr 2020 17:43:46 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 036LX4Ki052818;
        Mon, 6 Apr 2020 17:43:45 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3082j83ctp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Apr 2020 17:43:45 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 036LY1od055374;
        Mon, 6 Apr 2020 17:43:45 -0400
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3082j83ct6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Apr 2020 17:43:45 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 036LeHT5025407;
        Mon, 6 Apr 2020 21:43:44 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma05wdc.us.ibm.com with ESMTP id 306hv6b7w6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Apr 2020 21:43:44 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 036LhhPF53150038
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Apr 2020 21:43:43 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B6F00124055;
        Mon,  6 Apr 2020 21:43:43 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 39AE4124052;
        Mon,  6 Apr 2020 21:43:43 +0000 (GMT)
Received: from [9.160.96.56] (unknown [9.160.96.56])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  6 Apr 2020 21:43:43 +0000 (GMT)
Subject: Re: [RFC PATCH v2 5/9] vfio-ccw: Introduce a new CRW region
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20200206213825.11444-1-farman@linux.ibm.com>
 <20200206213825.11444-6-farman@linux.ibm.com>
 <20200406154057.6016c4a7.cohuck@redhat.com>
From:   Eric Farman <farman@linux.ibm.com>
Message-ID: <db43381a-6769-07f1-7d4d-9c6c680bde4e@linux.ibm.com>
Date:   Mon, 6 Apr 2020 17:43:42 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200406154057.6016c4a7.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-06_10:2020-04-06,2020-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 malwarescore=0 suspectscore=0 impostorscore=0 bulkscore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 mlxlogscore=999 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004060162
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

(Ah, didn't see this come in earlier.)

On 4/6/20 9:40 AM, Cornelia Huck wrote:
> On Thu,  6 Feb 2020 22:38:21 +0100
> Eric Farman <farman@linux.ibm.com> wrote:
> 
>> From: Farhan Ali <alifm@linux.ibm.com>
>>
>> This region provides a mechanism to pass Channel Report Word(s)
>> that affect vfio-ccw devices, and need to be passed to the guest
>> for its awareness and/or processing.
>>
>> The base driver (see crw_collect_info()) provides space for two
>> CRWs, as a subchannel event may have two CRWs chained together
>> (one for the ssid, one for the subcahnnel).  All other CRWs will
>> only occupy the first one.  Even though this support will also
>> only utilize the first one, we'll provide space for two also.
>>
>> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
>> Signed-off-by: Eric Farman <farman@linux.ibm.com>
>> ---
>>
>> Notes:
>>     v1-v2:
>>      - Add new region info to Documentation/s390/vfio-ccw.rst [CH]
>>      - Add a block comment to struct ccw_crw_region [CH]
>>     
>>     v0->v1: [EF]
>>      - Clean up checkpatch (whitespace) errors
>>      - Add ret=-ENOMEM in error path for new region
>>      - Add io_mutex for region read (originally in last patch)
>>      - Change crw1/crw2 to crw0/crw1
>>      - Reorder cleanup of regions
>>
>>  Documentation/s390/vfio-ccw.rst     | 15 ++++++++
>>  drivers/s390/cio/vfio_ccw_chp.c     | 56 +++++++++++++++++++++++++++++
>>  drivers/s390/cio/vfio_ccw_drv.c     | 20 +++++++++++
>>  drivers/s390/cio/vfio_ccw_ops.c     |  4 +++
>>  drivers/s390/cio/vfio_ccw_private.h |  3 ++
>>  include/uapi/linux/vfio.h           |  1 +
>>  include/uapi/linux/vfio_ccw.h       |  9 +++++
>>  7 files changed, 108 insertions(+)
>>
> 
> (...)
> 
>> diff --git a/drivers/s390/cio/vfio_ccw_chp.c b/drivers/s390/cio/vfio_ccw_chp.c
>> index 826d08379fe3..8fde94552149 100644
>> --- a/drivers/s390/cio/vfio_ccw_chp.c
>> +++ b/drivers/s390/cio/vfio_ccw_chp.c
>> @@ -73,3 +73,59 @@ int vfio_ccw_register_schib_dev_regions(struct vfio_ccw_private *private)
>>  					    VFIO_REGION_INFO_FLAG_READ,
>>  					    private->schib_region);
>>  }
>> +
>> +static ssize_t vfio_ccw_crw_region_read(struct vfio_ccw_private *private,
>> +					char __user *buf, size_t count,
>> +					loff_t *ppos)
>> +{
>> +	unsigned int i = VFIO_CCW_OFFSET_TO_INDEX(*ppos) - VFIO_CCW_NUM_REGIONS;
>> +	loff_t pos = *ppos & VFIO_CCW_OFFSET_MASK;
>> +	struct ccw_crw_region *region;
>> +	int ret;
>> +
>> +	if (pos + count > sizeof(*region))
>> +		return -EINVAL;
>> +
>> +	if (list_empty(&private->crw))
>> +		return 0;

This is actually nonsense, because the list isn't introduced for a
couple of patches.

>> +
>> +	mutex_lock(&private->io_mutex);
>> +	region = private->region[i].data;
>> +
>> +	if (copy_to_user(buf, (void *)region + pos, count))
>> +		ret = -EFAULT;
>> +	else
>> +		ret = count;
>> +
>> +	mutex_unlock(&private->io_mutex);
>> +	return ret;
>> +}
> 
> Would it make sense to clear out the crw after it has been read by
> userspace?

Yes, I fixed this up in my in-progress v3 last week.  Sorry to waste
some time, I should have mentioned it when I changed my branch locally.

I changed the list_empty() check above to bail out if the region is
already zero, which I guess is why the userspace check looks for both.
But if we only look at the contents of the region, then checking both is
unnecessary.  Just do the copy and be done with it.

> 
> In patch 7, you add a notification for a new crw via eventfd, but
> nothing is preventing userspace from reading this even if not
> triggered. I also don't see the region being updated there until a new
> crw is posted.
> 
> Or am I missing something?
> 

