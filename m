Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D012815D979
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 15:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729457AbgBNO3c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 09:29:32 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54094 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729327AbgBNO3b (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Feb 2020 09:29:31 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01EENtFj083007;
        Fri, 14 Feb 2020 09:29:30 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y4j8gjqtq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Feb 2020 09:29:30 -0500
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 01EEPJm5092074;
        Fri, 14 Feb 2020 09:29:30 -0500
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y4j8gjqte-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Feb 2020 09:29:29 -0500
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 01EEPqBq006356;
        Fri, 14 Feb 2020 14:29:29 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma04dal.us.ibm.com with ESMTP id 2y5bc08p2x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Feb 2020 14:29:29 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01EETSfJ54002016
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Feb 2020 14:29:28 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3BDD8B2065;
        Fri, 14 Feb 2020 14:29:28 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B8549B205F;
        Fri, 14 Feb 2020 14:29:27 +0000 (GMT)
Received: from [9.160.20.216] (unknown [9.160.20.216])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 14 Feb 2020 14:29:27 +0000 (GMT)
Subject: Re: [RFC PATCH v2 4/9] vfio-ccw: Introduce a new schib region
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20200206213825.11444-1-farman@linux.ibm.com>
 <20200206213825.11444-5-farman@linux.ibm.com>
 <20200214133218.6841b81e.cohuck@redhat.com>
From:   Eric Farman <farman@linux.ibm.com>
Message-ID: <b7beb425-8af2-5db4-5d0d-e2f52a84d37f@linux.ibm.com>
Date:   Fri, 14 Feb 2020 09:29:27 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200214133218.6841b81e.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-14_04:2020-02-12,2020-02-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 phishscore=0 impostorscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 adultscore=0 spamscore=0 priorityscore=1501 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002140116
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/14/20 7:32 AM, Cornelia Huck wrote:
> On Thu,  6 Feb 2020 22:38:20 +0100
> Eric Farman <farman@linux.ibm.com> wrote:
> 
>> From: Farhan Ali <alifm@linux.ibm.com>
>>
>> The schib region can be used by userspace to get the subchannel-
>> information block (SCHIB) for the passthrough subchannel.
>> This can be useful to get information such as channel path
>> information via the SCHIB.PMCW fields.
>>
>> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
>> Signed-off-by: Eric Farman <farman@linux.ibm.com>
>> ---
>>
>> Notes:
>>     v1->v2:
>>      - Add new region info to Documentation/s390/vfio-ccw.rst [CH]
>>      - Add a block comment to struct ccw_schib_region [CH]
>>     
>>     v0->v1: [EF]
>>      - Clean up checkpatch (#include, whitespace) errors
>>      - Remove unnecessary includes from vfio_ccw_chp.c
>>      - Add ret=-ENOMEM in error path for new region
>>      - Add call to vfio_ccw_unregister_dev_regions() during error exit
>>        path of vfio_ccw_mdev_open()
>>      - New info on the module prologue
>>      - Reorder cleanup of regions
>>
>>  Documentation/s390/vfio-ccw.rst     | 16 +++++-
>>  drivers/s390/cio/Makefile           |  2 +-
>>  drivers/s390/cio/vfio_ccw_chp.c     | 75 +++++++++++++++++++++++++++++
>>  drivers/s390/cio/vfio_ccw_drv.c     | 20 ++++++++
>>  drivers/s390/cio/vfio_ccw_ops.c     | 14 +++++-
>>  drivers/s390/cio/vfio_ccw_private.h |  3 ++
>>  include/uapi/linux/vfio.h           |  1 +
>>  include/uapi/linux/vfio_ccw.h       | 10 ++++
>>  8 files changed, 137 insertions(+), 4 deletions(-)
>>  create mode 100644 drivers/s390/cio/vfio_ccw_chp.c
>>
>> diff --git a/Documentation/s390/vfio-ccw.rst b/Documentation/s390/vfio-ccw.rst
>> index fca9c4f5bd9c..b805dc995fc8 100644
>> --- a/Documentation/s390/vfio-ccw.rst
>> +++ b/Documentation/s390/vfio-ccw.rst
>> @@ -231,6 +231,19 @@ This region is exposed via region type VFIO_REGION_SUBTYPE_CCW_ASYNC_CMD.
>>  
>>  Currently, CLEAR SUBCHANNEL and HALT SUBCHANNEL use this region.
>>  
>> +vfio-ccw schib region
>> +---------------------
>> +
>> +The vfio-ccw schib region is used to return Subchannel-Information
>> +Block (SCHIB) data to userspace::
>> +
>> +  struct ccw_schib_region {
>> +  #define SCHIB_AREA_SIZE 52
>> +         __u8 schib_area[SCHIB_AREA_SIZE];
>> +  } __packed;
>> +
>> +This region is exposed via region type VFIO_REGION_SUBTYPE_CCW_SCHIB.
> 
> Also mention that reading this triggers a stsch() updating the schib?

Yeah, I tucked that in the uapi header, but it should be mentioned here too.

> 
>> +
>>  vfio-ccw operation details
>>  --------------------------
>>  
> 
> (...)
> 
>> diff --git a/drivers/s390/cio/vfio_ccw_chp.c b/drivers/s390/cio/vfio_ccw_chp.c
>> new file mode 100644
>> index 000000000000..826d08379fe3
>> --- /dev/null
>> +++ b/drivers/s390/cio/vfio_ccw_chp.c
>> @@ -0,0 +1,75 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Channel path related status regions for vfio_ccw
>> + *
>> + * Copyright IBM Corp. 2019
> 
> Should the year be updated?

Probably.  :)

> 
>> + *
>> + * Author(s): Farhan Ali <alifm@linux.ibm.com>
>> + */
> 
> (...)
> 
