Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAE2B24988D
	for <lists+kvm@lfdr.de>; Wed, 19 Aug 2020 10:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbgHSIuh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 04:50:37 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38336 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725903AbgHSIug (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 Aug 2020 04:50:36 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07J8nMXV137573;
        Wed, 19 Aug 2020 04:50:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=xAYeKHW/+Z92JV4H3sNpKkOnm0wWuGsKoCdnJ1LtkJM=;
 b=kDV3mrfBjpXFkq1WaCdvTSEYM8HFBYOZAJAMIm78jSuKtftX0BU/UBPU+45XGpvmcPOP
 p27FnFW9gbLqX++YGh/siRKUfRs6LIBs9BCOWMYFiQhPLOKggyHnknL7iDgXWVnl5VMu
 chFLkVoDAnWmetQNKCGwsKmJ05TTzPgHSpTl5DKWlXGgBqM4hsYvEVpOPG44lUHoD9Dz
 WkVyXhJzW5Y6JdF0DDd2OKnk0C3CITAwRcmT4tFU/NzAi9syRL4HB16gxiJAcCixGBnU
 K34TzTn6/xe2P2QThbpPtwCO5XZcctXNxAVBlNYY/cLjbS2+QS9k3aZ+eTYJ8x2Mt3R6 HA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3304r447d9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Aug 2020 04:50:26 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07J8nsmS139800;
        Wed, 19 Aug 2020 04:50:25 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3304r447c9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Aug 2020 04:50:25 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07J8nGOj023704;
        Wed, 19 Aug 2020 08:50:22 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3304um1mkc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Aug 2020 08:50:22 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07J8oJsc31850946
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Aug 2020 08:50:19 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9D14211C04C;
        Wed, 19 Aug 2020 08:50:19 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0D94111C04A;
        Wed, 19 Aug 2020 08:50:19 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.33.131])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 19 Aug 2020 08:50:18 +0000 (GMT)
Subject: Re: [PATCH v8 1/2] virtio: let arch validate VIRTIO features
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     linux-kernel@vger.kernel.org, pasic@linux.ibm.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, mst@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, thomas.lendacky@amd.com,
        david@gibson.dropbear.id.au, linuxram@us.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com
References: <1597762711-3550-1-git-send-email-pmorel@linux.ibm.com>
 <1597762711-3550-2-git-send-email-pmorel@linux.ibm.com>
 <20200818191910.1fc300f2.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <64acd55a-8a22-4b84-0f9e-e13196c1520d@linux.ibm.com>
Date:   Wed, 19 Aug 2020 10:50:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200818191910.1fc300f2.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-19_04:2020-08-19,2020-08-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 priorityscore=1501
 malwarescore=0 impostorscore=0 adultscore=0 clxscore=1015 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008190069
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-08-18 19:19, Cornelia Huck wrote:
> On Tue, 18 Aug 2020 16:58:30 +0200
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
...
>> +config ARCH_HAS_RESTRICTED_MEMORY_ACCESS
>> +	bool
>> +	help
>> +	  This option is selected by any architecture enforcing
>> +	  VIRTIO_F_IOMMU_PLATFORM
> 
> This option is only for a very specific case of "restricted memory
> access", namely the kind that requires IOMMU_PLATFORM for virtio
> devices. ARCH_HAS_RESTRICTED_VIRTIO_MEMORY_ACCESS? Or is this intended
> to cover cases outside of virtio as well?

AFAIK we did not identify other restrictions so adding VIRTIO in the 
name should be the best thing to do.

If new restrictions appear they also may be orthogonal.

I will change to ARCH_HAS_RESTRICTED_VIRTIO_MEMORY_ACCESS if no one 
complains.

> 
>> +
>>   menuconfig VIRTIO_MENU
>>   	bool "Virtio drivers"
>>   	default y
>> diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
>> index a977e32a88f2..1471db7d6510 100644
>> --- a/drivers/virtio/virtio.c
>> +++ b/drivers/virtio/virtio.c
>> @@ -176,6 +176,10 @@ int virtio_finalize_features(struct virtio_device *dev)
>>   	if (ret)
>>   		return ret;
>>   
>> +	ret = arch_has_restricted_memory_access(dev);
>> +	if (ret)
>> +		return ret;
> 
> Hm, I'd rather have expected something like
> 
> if (arch_has_restricted_memory_access(dev)) {

may be also change the callback name to
arch_has_restricted_virtio_memory_access() ?

> 	// enforce VERSION_1 and IOMMU_PLATFORM
> }
> 
> Otherwise, you're duplicating the checks in the individual architecture
> callbacks again.

Yes, I agree and go back this way.

> 
> [Not sure whether the device argument would be needed here; are there
> architectures where we'd only require IOMMU_PLATFORM for a subset of
> virtio devices?]

I don't think so and since we do the checks locally, we do not need the 
device argument anymore.


Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
