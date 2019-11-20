Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDC8F104153
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2019 17:49:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729400AbfKTQtu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Nov 2019 11:49:50 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:9050 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729484AbfKTQtt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Nov 2019 11:49:49 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAKGcU9W040612;
        Wed, 20 Nov 2019 11:49:48 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wcf5991t5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Nov 2019 11:49:48 -0500
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id xAKGcZHU041236;
        Wed, 20 Nov 2019 11:49:47 -0500
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wcf5991sy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Nov 2019 11:49:47 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id xAKGjMsX011087;
        Wed, 20 Nov 2019 16:49:47 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma03wdc.us.ibm.com with ESMTP id 2wa8r6pfv4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Nov 2019 16:49:47 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAKGnktp37224794
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Nov 2019 16:49:46 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BE2CAB2065;
        Wed, 20 Nov 2019 16:49:46 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8AA3CB2066;
        Wed, 20 Nov 2019 16:49:46 +0000 (GMT)
Received: from [9.60.89.236] (unknown [9.60.89.236])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 20 Nov 2019 16:49:46 +0000 (GMT)
Subject: Re: [RFC PATCH v1 05/10] vfio-ccw: Introduce a new schib region
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>
References: <20191115025620.19593-1-farman@linux.ibm.com>
 <20191115025620.19593-6-farman@linux.ibm.com>
 <20191119175253.3e688369.cohuck@redhat.com>
From:   Eric Farman <farman@linux.ibm.com>
Message-ID: <97e27530-fed5-40df-0dc7-7b7adc219b96@linux.ibm.com>
Date:   Wed, 20 Nov 2019 11:49:46 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191119175253.3e688369.cohuck@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-20_04:2019-11-20,2019-11-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=646
 suspectscore=0 adultscore=0 clxscore=1015 phishscore=0 bulkscore=0
 lowpriorityscore=0 malwarescore=0 spamscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911200143
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/19/19 11:52 AM, Cornelia Huck wrote:
> On Fri, 15 Nov 2019 03:56:15 +0100
> Eric Farman <farman@linux.ibm.com> wrote:
> 
>> From: Farhan Ali <alifm@linux.ibm.com>
>>
>> The schib region can be used by userspace to get the SCHIB for the
>> passthrough subchannel. This can be useful to get information such
>> as channel path information via the SCHIB.PMCW.
>>
>> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
>> Signed-off-by: Eric Farman <farman@linux.ibm.com>
>> ---
>>
>> Notes:
>>     v0->v1: [EF]
>>      - Clean up checkpatch (#include, whitespace) errors
>>      - Remove unnecessary includes from vfio_ccw_chp.c
>>      - Add ret=-ENOMEM in error path for new region
>>      - Add call to vfio_ccw_unregister_dev_regions() during error exit
>>        path of vfio_ccw_mdev_open()
>>      - New info on the module prologue
>>      - Reorder cleanup of regions
>>
>>  drivers/s390/cio/Makefile           |  2 +-
>>  drivers/s390/cio/vfio_ccw_chp.c     | 75 +++++++++++++++++++++++++++++
>>  drivers/s390/cio/vfio_ccw_drv.c     | 20 ++++++++
>>  drivers/s390/cio/vfio_ccw_ops.c     | 14 +++++-
>>  drivers/s390/cio/vfio_ccw_private.h |  3 ++
>>  include/uapi/linux/vfio.h           |  1 +
>>  include/uapi/linux/vfio_ccw.h       |  5 ++
>>  7 files changed, 117 insertions(+), 3 deletions(-)
>>  create mode 100644 drivers/s390/cio/vfio_ccw_chp.c
>>
> 
>> diff --git a/include/uapi/linux/vfio_ccw.h b/include/uapi/linux/vfio_ccw.h
>> index cbecbf0cd54f..7c0a834e5d7a 100644
>> --- a/include/uapi/linux/vfio_ccw.h
>> +++ b/include/uapi/linux/vfio_ccw.h
>> @@ -34,4 +34,9 @@ struct ccw_cmd_region {
>>  	__u32 ret_code;
>>  } __packed;
>>
> 
> Let's add a comment:
> - that reading this region triggers a stsch()
> - that this region is guarded by a capability
> 
> ?

Agreed, and ditto for patch 6.

>   
>> +struct ccw_schib_region {
>> +#define SCHIB_AREA_SIZE 52
>> +	__u8 schib_area[SCHIB_AREA_SIZE];
>> +} __packed;
>> +
>>  #endif
> 
> Seems sane; but I need to continue reading this and the QEMU series to
> see how it is used.
> 
> Oh, and please update Documentation/s390/vfio-ccw.rst :)
> 

Whoops!  Yes, I'll do that here and in patch 6.
