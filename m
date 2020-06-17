Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0CB1FCCF3
	for <lists+kvm@lfdr.de>; Wed, 17 Jun 2020 14:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbgFQMAJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jun 2020 08:00:09 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:56806 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725901AbgFQMAI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Jun 2020 08:00:08 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05HBViMW107449;
        Wed, 17 Jun 2020 08:00:00 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31q6j9m327-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Jun 2020 08:00:00 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05HBVntA107921;
        Wed, 17 Jun 2020 08:00:00 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31q6j9m31g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Jun 2020 08:00:00 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05HBuLVX025239;
        Wed, 17 Jun 2020 11:59:58 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 31q6bs9091-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Jun 2020 11:59:58 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05HBxtxY9175400
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Jun 2020 11:59:55 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8D7D111C04C;
        Wed, 17 Jun 2020 11:59:55 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A9AE011C052;
        Wed, 17 Jun 2020 11:59:54 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.186.32])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 17 Jun 2020 11:59:54 +0000 (GMT)
Subject: Re: [PATCH v3 1/1] s390: virtio: let arch accept devices without
 IOMMU feature
To:     Heiko Carstens <heiko.carstens@de.ibm.com>
Cc:     linux-kernel@vger.kernel.org, pasic@linux.ibm.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, mst@redhat.com,
        jasowang@redhat.com, cohuck@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, thomas.lendacky@amd.com,
        david@gibson.dropbear.id.au, linuxram@us.ibm.com, gor@linux.ibm.com
References: <1592390637-17441-1-git-send-email-pmorel@linux.ibm.com>
 <1592390637-17441-2-git-send-email-pmorel@linux.ibm.com>
 <20200617112222.GF4479@osiris>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <d85aa0cf-c158-a263-aeb2-c5817687275e@linux.ibm.com>
Date:   Wed, 17 Jun 2020 13:59:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200617112222.GF4479@osiris>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-17_03:2020-06-17,2020-06-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 adultscore=0 spamscore=0 clxscore=1015 suspectscore=0
 mlxlogscore=812 lowpriorityscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 phishscore=0 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006170087
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-06-17 13:22, Heiko Carstens wrote:
> On Wed, Jun 17, 2020 at 12:43:57PM +0200, Pierre Morel wrote:
>> An architecture protecting the guest memory against unauthorized host
>> access may want to enforce VIRTIO I/O device protection through the
>> use of VIRTIO_F_IOMMU_PLATFORM.
>>
>> Let's give a chance to the architecture to accept or not devices
>> without VIRTIO_F_IOMMU_PLATFORM.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> Acked-by: Jason Wang <jasowang@redhat.com>
>> Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
>> ---
>>   arch/s390/mm/init.c     |  6 ++++++
>>   drivers/virtio/virtio.c | 22 ++++++++++++++++++++++
>>   include/linux/virtio.h  |  2 ++
>>   3 files changed, 30 insertions(+)
>>
>> diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
>> index 6dc7c3b60ef6..215070c03226 100644
>> --- a/arch/s390/mm/init.c
>> +++ b/arch/s390/mm/init.c
>> @@ -45,6 +45,7 @@
>>   #include <asm/kasan.h>
>>   #include <asm/dma-mapping.h>
>>   #include <asm/uv.h>
>> +#include <linux/virtio.h>
>>
>>   pgd_t swapper_pg_dir[PTRS_PER_PGD] __section(.bss..swapper_pg_dir);
>>
>> @@ -161,6 +162,11 @@ bool force_dma_unencrypted(struct device *dev)
>>   	return is_prot_virt_guest();
>>   }
>>
>> +int arch_needs_virtio_iommu_platform(struct virtio_device *dev)
>> +{
>> +	return is_prot_virt_guest();
>> +}
>> +
>>   /* protected virtualization */
>>   static void pv_init(void)
> 
> Can we please stop dumping random code to arch/s390/mm/init.c?
> 
> All the protected virtualization functions should go into a separate
> file (e.g. mem_encrypt.c like on x86), some of which could also be in
> header files.
> 
> Please consider this a comment for the future.. just go ahead with
> this patch as-is.
> 

OK, thanks Heiko,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
