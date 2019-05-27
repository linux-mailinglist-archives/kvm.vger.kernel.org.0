Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 393BD2B80F
	for <lists+kvm@lfdr.de>; Mon, 27 May 2019 17:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbfE0PBX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 May 2019 11:01:23 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47472 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726094AbfE0PBW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 May 2019 11:01:22 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4REqamI055986
        for <kvm@vger.kernel.org>; Mon, 27 May 2019 11:01:21 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2srj0rgkmp-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 27 May 2019 11:01:20 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <mimu@linux.ibm.com>;
        Mon, 27 May 2019 16:01:19 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 27 May 2019 16:01:14 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4RF1DN260096556
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 May 2019 15:01:13 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 499CDAA101;
        Mon, 27 May 2019 15:01:13 +0000 (GMT)
Received: from [9.152.98.56] (unknown [9.152.98.56])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id B6FA1AA0FD;
        Mon, 27 May 2019 15:01:12 +0000 (GMT)
Reply-To: mimu@linux.ibm.com
Subject: Re: [PATCH v2 3/8] s390/cio: add basic protected virtualization
 support
To:     Sebastian Ott <sebott@linux.ibm.com>
Cc:     KVM Mailing List <kvm@vger.kernel.org>,
        Linux-S390 Mailing List <linux-s390@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
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
 <20190523162209.9543-4-mimu@linux.ibm.com>
 <alpine.LFD.2.21.1905251124230.3359@schleppi>
From:   Michael Mueller <mimu@linux.ibm.com>
Organization: IBM
Date:   Mon, 27 May 2019 17:01:12 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.21.1905251124230.3359@schleppi>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19052715-0016-0000-0000-0000027FF93D
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19052715-0017-0000-0000-000032DCFF66
Message-Id: <f2b8d5c3-a39b-8632-c463-cde47bf38c91@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-27_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905270106
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 25.05.19 11:44, Sebastian Ott wrote:
> 
> On Thu, 23 May 2019, Michael Mueller wrote:
>>   static struct ccw_device * io_subchannel_allocate_dev(struct subchannel *sch)
>>   {
>>   	struct ccw_device *cdev;
>> +	struct gen_pool *dma_pool;
>>   
>>   	cdev  = kzalloc(sizeof(*cdev), GFP_KERNEL);
>> -	if (cdev) {
>> -		cdev->private = kzalloc(sizeof(struct ccw_device_private),
>> -					GFP_KERNEL | GFP_DMA);
>> -		if (cdev->private)
>> -			return cdev;
>> -	}
>> +	if (!cdev)
>> +		goto err_cdev;
>> +	cdev->private = kzalloc(sizeof(struct ccw_device_private),
>> +				GFP_KERNEL | GFP_DMA);
>> +	if (!cdev->private)
>> +		goto err_priv;
>> +	cdev->dev.coherent_dma_mask = sch->dev.coherent_dma_mask;
>> +	cdev->dev.dma_mask = &cdev->dev.coherent_dma_mask;
>> +	dma_pool = cio_gp_dma_create(&cdev->dev, 1);
> 
> This can return NULL. gen_pool_alloc will panic in this case.
> [...]

yep, will handled in next version

> 
>> +err_dma_area:
>> +		kfree(io_priv);

one tab gone

> 
> Indentation.
> 
>> +err_priv:
>> +	put_device(&sch->dev);
>> +	return ERR_PTR(-ENOMEM);
>>   }
> [...]
>>   void ccw_device_update_sense_data(struct ccw_device *cdev)
>>   {
>>   	memset(&cdev->id, 0, sizeof(cdev->id));
>> -	cdev->id.cu_type   = cdev->private->senseid.cu_type;
>> -	cdev->id.cu_model  = cdev->private->senseid.cu_model;
>> -	cdev->id.dev_type  = cdev->private->senseid.dev_type;
>> -	cdev->id.dev_model = cdev->private->senseid.dev_model;
>> +	cdev->id.cu_type   =
>> +		cdev->private->dma_area->senseid.cu_type;
>> +	cdev->id.cu_model  =
>> +		cdev->private->dma_area->senseid.cu_model;
>> +	cdev->id.dev_type  =
>> +		cdev->private->dma_area->senseid.dev_type;
>> +	cdev->id.dev_model =
>> +		cdev->private->dma_area->senseid.dev_model;
> 
> These fit into one line.

yep, surprisingly below 80 characters

> 
>> +/**
>> + * Allocate zeroed dma coherent 31 bit addressable memory using
>> + * the subchannels dma pool. Maximal size of allocation supported
>> + * is PAGE_SIZE.
>> + */
> drivers/s390/cio/device_ops.c:708: warning: Function parameter or member 'cdev' not described in 'ccw_device_dma_zalloc'
> drivers/s390/cio/device_ops.c:708: warning: Function parameter or member 'size' not described in 'ccw_device_dma_zalloc'

changing comment open token

> 
> 
> Reviewed-by: Sebastian Ott <sebott@linux.ibm.com>
> 

Thanks!


Michael

