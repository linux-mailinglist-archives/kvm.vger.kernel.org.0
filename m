Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2D032F36
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2019 14:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbfFCMJM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jun 2019 08:09:12 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35484 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726996AbfFCMJM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 Jun 2019 08:09:12 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x53C6u7k017155
        for <kvm@vger.kernel.org>; Mon, 3 Jun 2019 08:09:10 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2sw2ptsn1c-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 03 Jun 2019 08:09:10 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <mimu@linux.ibm.com>;
        Mon, 3 Jun 2019 13:09:08 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 3 Jun 2019 13:09:05 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x53C939m52691028
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Jun 2019 12:09:03 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4D125A4053;
        Mon,  3 Jun 2019 12:09:03 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B68FCA4051;
        Mon,  3 Jun 2019 12:09:02 +0000 (GMT)
Received: from [9.152.98.28] (unknown [9.152.98.28])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  3 Jun 2019 12:09:02 +0000 (GMT)
Reply-To: mimu@linux.ibm.com
Subject: Re: [PATCH v3 2/8] s390/cio: introduce DMA pools to cio
To:     Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>
Cc:     KVM Mailing List <kvm@vger.kernel.org>,
        Linux-S390 Mailing List <linux-s390@vger.kernel.org>,
        Sebastian Ott <sebott@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        virtualization@lists.linux-foundation.org,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>
References: <20190529122657.166148-1-mimu@linux.ibm.com>
 <20190529122657.166148-3-mimu@linux.ibm.com>
 <20190603133745.240c00a7.cohuck@redhat.com>
From:   Michael Mueller <mimu@linux.ibm.com>
Organization: IBM
Date:   Mon, 3 Jun 2019 14:09:02 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190603133745.240c00a7.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19060312-4275-0000-0000-0000033BB255
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19060312-4276-0000-0000-0000384BBCA4
Message-Id: <035b4bd3-5856-e8e5-91bf-ba0b5c7c3736@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-03_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906030088
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 03.06.19 13:37, Cornelia Huck wrote:
> On Wed, 29 May 2019 14:26:51 +0200
> Michael Mueller <mimu@linux.ibm.com> wrote:
> 
>> From: Halil Pasic <pasic@linux.ibm.com>
>>
>> To support protected virtualization cio will need to make sure the
>> memory used for communication with the hypervisor is DMA memory.
>>
>> Let us introduce one global pool for cio.
>>
>> Our DMA pools are implemented as a gen_pool backed with DMA pages. The
>> idea is to avoid each allocation effectively wasting a page, as we
>> typically allocate much less than PAGE_SIZE.
>>
>> Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
>> Reviewed-by: Sebastian Ott <sebott@linux.ibm.com>
>> Signed-off-by: Michael Mueller <mimu@linux.ibm.com>
>> ---
>>   arch/s390/Kconfig           |   1 +
>>   arch/s390/include/asm/cio.h |  11 ++++
>>   drivers/s390/cio/css.c      | 120 ++++++++++++++++++++++++++++++++++++++++++--
>>   3 files changed, 128 insertions(+), 4 deletions(-)
> 
> (...)
> 
>> diff --git a/arch/s390/include/asm/cio.h b/arch/s390/include/asm/cio.h
>> index 1727180e8ca1..43c007d2775a 100644
>> --- a/arch/s390/include/asm/cio.h
>> +++ b/arch/s390/include/asm/cio.h
>> @@ -328,6 +328,17 @@ static inline u8 pathmask_to_pos(u8 mask)
>>   void channel_subsystem_reinit(void);
>>   extern void css_schedule_reprobe(void);
>>   
>> +extern void *cio_dma_zalloc(size_t size);
>> +extern void cio_dma_free(void *cpu_addr, size_t size);
>> +extern struct device *cio_get_dma_css_dev(void);
>> +
>> +struct gen_pool;
> 
> That forward declaration is a bit ugly... I guess the alternative was
> include hell?

That's an easy one.

  #include <linux/bitops.h>
+#include <linux/genalloc.h>
  #include <asm/types.h>

> 
>> +void *cio_gp_dma_zalloc(struct gen_pool *gp_dma, struct device *dma_dev,
>> +			size_t size);
>> +void cio_gp_dma_free(struct gen_pool *gp_dma, void *cpu_addr, size_t size);
>> +void cio_gp_dma_destroy(struct gen_pool *gp_dma, struct device *dma_dev);
>> +struct gen_pool *cio_gp_dma_create(struct device *dma_dev, int nr_pages);
>> +
>>   /* Function from drivers/s390/cio/chsc.c */
>>   int chsc_sstpc(void *page, unsigned int op, u16 ctrl, u64 *clock_delta);
>>   int chsc_sstpi(void *page, void *result, size_t size);
>> diff --git a/drivers/s390/cio/css.c b/drivers/s390/cio/css.c
>> index aea502922646..b97618497848 100644
>> --- a/drivers/s390/cio/css.c
>> +++ b/drivers/s390/cio/css.c
>> @@ -20,6 +20,8 @@
>>   #include <linux/reboot.h>
>>   #include <linux/suspend.h>
>>   #include <linux/proc_fs.h>
>> +#include <linux/genalloc.h>
>> +#include <linux/dma-mapping.h>
>>   #include <asm/isc.h>
>>   #include <asm/crw.h>
>>   
>> @@ -224,6 +226,8 @@ struct subchannel *css_alloc_subchannel(struct subchannel_id schid,
>>   	INIT_WORK(&sch->todo_work, css_sch_todo);
>>   	sch->dev.release = &css_subchannel_release;
>>   	device_initialize(&sch->dev);
> 
> It might be helpful to add a comment why you use 31 bit here...

@Halil, please let me know what comment you prefere here...

> 
>> +	sch->dev.coherent_dma_mask = DMA_BIT_MASK(31);
>> +	sch->dev.dma_mask = &sch->dev.coherent_dma_mask;
>>   	return sch;
>>   
>>   err:
>> @@ -899,6 +903,8 @@ static int __init setup_css(int nr)
>>   	dev_set_name(&css->device, "css%x", nr);
>>   	css->device.groups = cssdev_attr_groups;
>>   	css->device.release = channel_subsystem_release;
> 
> ...and 64 bit here.

and here.

> 
>> +	css->device.coherent_dma_mask = DMA_BIT_MASK(64);
>> +	css->device.dma_mask = &css->device.coherent_dma_mask;
>>   
>>   	mutex_init(&css->mutex);
>>   	css->cssid = chsc_get_cssid(nr);
> 
> (...)
> 
>> @@ -1059,16 +1168,19 @@ static int __init css_bus_init(void)
>>   	if (ret)
>>   		goto out_unregister;
>>   	ret = register_pm_notifier(&css_power_notifier);
>> -	if (ret) {
>> -		unregister_reboot_notifier(&css_reboot_notifier);
>> -		goto out_unregister;
>> -	}
>> +	if (ret)
>> +		goto out_unregister_rn;
>> +	ret = cio_dma_pool_init();
>> +	if (ret)
>> +		goto out_unregister_rn;
> 
> Don't you also need to unregister the pm notifier on failure here?

Mmh, that was the original intention. Thanks!

> 
> Other than that, I noticed only cosmetic issues; seems reasonable to me.
> 
>>   	css_init_done = 1;
>>   
>>   	/* Enable default isc for I/O subchannels. */
>>   	isc_register(IO_SCH_ISC);
>>   
>>   	return 0;
>> +out_unregister_rn:
>> +	unregister_reboot_notifier(&css_reboot_notifier);
>>   out_unregister:
>>   	while (i-- > 0) {
>>   		struct channel_subsystem *css = channel_subsystems[i];
> 

Thanks,
Michael

