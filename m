Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50CE32B3D1
	for <lists+kvm@lfdr.de>; Mon, 27 May 2019 14:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbfE0MAu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 May 2019 08:00:50 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41872 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726888AbfE0MAt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 May 2019 08:00:49 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4RBq74N113452
        for <kvm@vger.kernel.org>; Mon, 27 May 2019 08:00:48 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2srdyddb9f-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 27 May 2019 08:00:48 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <mimu@linux.ibm.com>;
        Mon, 27 May 2019 13:00:45 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 27 May 2019 13:00:42 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4RC0f1F44564674
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 May 2019 12:00:41 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2CB1EA4072;
        Mon, 27 May 2019 12:00:40 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4EED8A4067;
        Mon, 27 May 2019 12:00:39 +0000 (GMT)
Received: from [9.152.98.56] (unknown [9.152.98.56])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 27 May 2019 12:00:39 +0000 (GMT)
Reply-To: mimu@linux.ibm.com
Subject: Re: [PATCH v2 2/8] s390/cio: introduce DMA pools to cio
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     KVM Mailing List <kvm@vger.kernel.org>,
        Linux-S390 Mailing List <linux-s390@vger.kernel.org>,
        Sebastian Ott <sebott@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
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
References: <20190523162209.9543-1-mimu@linux.ibm.com>
 <20190523162209.9543-3-mimu@linux.ibm.com>
 <20190527085718.10494ee2.cohuck@redhat.com>
From:   Michael Mueller <mimu@linux.ibm.com>
Organization: IBM
Date:   Mon, 27 May 2019 14:00:38 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190527085718.10494ee2.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19052712-0008-0000-0000-000002EAE067
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19052712-0009-0000-0000-00002257A940
Message-Id: <347a8be1-7db7-f9c9-4755-e02ee4c58e17@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-27_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905270085
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 27.05.19 08:57, Cornelia Huck wrote:
> On Thu, 23 May 2019 18:22:03 +0200
> Michael Mueller <mimu@linux.ibm.com> wrote:
> 
>> From: Halil Pasic <pasic@linux.ibm.com>
>>
>> To support protected virtualization cio will need to make sure the
>> memory used for communication with the hypervisor is DMA memory.
>>
>> Let us introduce one global cio, and some tools for pools seated
> 
> "one global pool for cio"?

changed in v3

> 
>> at individual devices.
>>
>> Our DMA pools are implemented as a gen_pool backed with DMA pages. The
>> idea is to avoid each allocation effectively wasting a page, as we
>> typically allocate much less than PAGE_SIZE.
>>
>> Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
>> ---
>>   arch/s390/Kconfig           |   1 +
>>   arch/s390/include/asm/cio.h |  11 +++++
>>   drivers/s390/cio/css.c      | 110 ++++++++++++++++++++++++++++++++++++++++++++
>>   3 files changed, 122 insertions(+)
>>
> 
> (...)
> 
>> @@ -1018,6 +1024,109 @@ static struct notifier_block css_power_notifier = {
>>   	.notifier_call = css_power_event,
>>   };
>>   
>> +#define POOL_INIT_PAGES 1
>> +static struct gen_pool *cio_dma_pool;
>> +/* Currently cio supports only a single css */
> 
> This comment looks misplaced.

gone in v3

> 
>> +#define  CIO_DMA_GFP (GFP_KERNEL | __GFP_ZERO)
>> +
>> +
>> +struct device *cio_get_dma_css_dev(void)
>> +{
>> +	return &channel_subsystems[0]->device;
>> +}
>> +
>> +struct gen_pool *cio_gp_dma_create(struct device *dma_dev, int nr_pages)
>> +{
>> +	struct gen_pool *gp_dma;
>> +	void *cpu_addr;
>> +	dma_addr_t dma_addr;
>> +	int i;
>> +
>> +	gp_dma = gen_pool_create(3, -1);
>> +	if (!gp_dma)
>> +		return NULL;
>> +	for (i = 0; i < nr_pages; ++i) {
>> +		cpu_addr = dma_alloc_coherent(dma_dev, PAGE_SIZE, &dma_addr,
>> +					      CIO_DMA_GFP);
>> +		if (!cpu_addr)
>> +			return gp_dma;
> 
> So, you may return here with no memory added to the pool at all (or
> less than requested), but for the caller that is indistinguishable from
> an allocation that went all right. May that be a problem?

Halil,

can you pls. bring some light into the intention of this part of
the code. To me this seems to be odd as well!
Currently cio_gp_dma_create() might succeed with a successful
gen_pool_create() and an initially failing dma_alloc_coherent().

> 
>> +		gen_pool_add_virt(gp_dma, (unsigned long) cpu_addr,
>> +				  dma_addr, PAGE_SIZE, -1);
>> +	}
>> +	return gp_dma;
>> +}
>> +
> 
> (...)
> 
>> +static void __init cio_dma_pool_init(void)
>> +{
>> +	/* No need to free up the resources: compiled in */
>> +	cio_dma_pool = cio_gp_dma_create(cio_get_dma_css_dev(), 1);
> 
> Does it make sense to continue if you did not get a pool here? I don't
> think that should happen unless things were really bad already?

cio_gp_dma_create() will be evaluated and css_bus_init() will fail
in v3 in the NULL case.

> 
>> +}
>> +
>> +void *cio_gp_dma_zalloc(struct gen_pool *gp_dma, struct device *dma_dev,
>> +			size_t size)
>> +{
>> +	dma_addr_t dma_addr;
>> +	unsigned long addr;
>> +	size_t chunk_size;
>> +
>> +	addr = gen_pool_alloc(gp_dma, size);
>> +	while (!addr) {
>> +		chunk_size = round_up(size, PAGE_SIZE);
>> +		addr = (unsigned long) dma_alloc_coherent(dma_dev,
>> +					 chunk_size, &dma_addr, CIO_DMA_GFP);
>> +		if (!addr)
>> +			return NULL;
>> +		gen_pool_add_virt(gp_dma, addr, dma_addr, chunk_size, -1);
>> +		addr = gen_pool_alloc(gp_dma, size);
>> +	}
>> +	return (void *) addr;
>> +}
>> +
>> +void cio_gp_dma_free(struct gen_pool *gp_dma, void *cpu_addr, size_t size)
>> +{
>> +	if (!cpu_addr)
>> +		return;
>> +	memset(cpu_addr, 0, size);
>> +	gen_pool_free(gp_dma, (unsigned long) cpu_addr, size);
>> +}
>> +
>> +/**
>> + * Allocate dma memory from the css global pool. Intended for memory not
>> + * specific to any single device within the css. The allocated memory
>> + * is not guaranteed to be 31-bit addressable.
>> + *
>> + * Caution: Not suitable for early stuff like console.
>> + *
>> + */
>> +void *cio_dma_zalloc(size_t size)
>> +{
>> +	return cio_gp_dma_zalloc(cio_dma_pool, cio_get_dma_css_dev(), size);
> 
> Ok, that looks like the failure I mentioned above should be
> accommodated by the code. Still, I think it's a bit odd.

This code will be reached in v3 only when cio_dma_pool is *not* NULL.

> 
>> +}
> 

Michael

