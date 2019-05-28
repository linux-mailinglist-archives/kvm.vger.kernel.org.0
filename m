Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1B4D2C95D
	for <lists+kvm@lfdr.de>; Tue, 28 May 2019 16:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbfE1O6V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 May 2019 10:58:21 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54426 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726497AbfE1O6V (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 May 2019 10:58:21 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4SEvXiE146422
        for <kvm@vger.kernel.org>; Tue, 28 May 2019 10:58:19 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ss4y8pkb2-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 28 May 2019 10:58:19 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <mimu@linux.ibm.com>;
        Tue, 28 May 2019 15:58:17 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 28 May 2019 15:58:13 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4SEwCD545744128
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 May 2019 14:58:12 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E050052052;
        Tue, 28 May 2019 14:58:11 +0000 (GMT)
Received: from [9.152.99.121] (unknown [9.152.99.121])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 6B19E52071;
        Tue, 28 May 2019 14:58:11 +0000 (GMT)
Reply-To: mimu@linux.ibm.com
Subject: Re: [PATCH v2 8/8] virtio/s390: make airq summary indicators DMA
To:     Halil Pasic <pasic@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
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
References: <20190523162209.9543-1-mimu@linux.ibm.com>
 <20190523162209.9543-9-mimu@linux.ibm.com>
 <20190527140018.7c2d34ff.cohuck@redhat.com>
 <20190528163342.335eea0b.pasic@linux.ibm.com>
From:   Michael Mueller <mimu@linux.ibm.com>
Organization: IBM
Date:   Tue, 28 May 2019 16:58:11 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190528163342.335eea0b.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19052814-0020-0000-0000-000003414827
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19052814-0021-0000-0000-0000219444FF
Message-Id: <f06a939d-0d80-a3b2-e69c-3bac9bb2c688@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-28_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905280097
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 28.05.19 16:33, Halil Pasic wrote:
> On Mon, 27 May 2019 14:00:18 +0200
> Cornelia Huck <cohuck@redhat.com> wrote:
> 
>> On Thu, 23 May 2019 18:22:09 +0200
>> Michael Mueller <mimu@linux.ibm.com> wrote:
>>
>>> From: Halil Pasic <pasic@linux.ibm.com>
>>>
>>> Hypervisor needs to interact with the summary indicators, so these
>>> need to be DMA memory as well (at least for protected virtualization
>>> guests).
>>>
>>> Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
>>> ---
>>>   drivers/s390/virtio/virtio_ccw.c | 22 +++++++++++++++-------
>>>   1 file changed, 15 insertions(+), 7 deletions(-)
>>
>> (...)
>>
>>> @@ -1501,6 +1508,7 @@ static int __init virtio_ccw_init(void)
>>>   {
>>>   	/* parse no_auto string before we do anything further */
>>>   	no_auto_parse();
>>> +	summary_indicators = cio_dma_zalloc(MAX_AIRQ_AREAS);
>>
>> What happens if this fails?
> 
> Bad things could happen!
> 
> How about adding
> 
> if (!summary_indicators)
> 	virtio_ccw_use_airq = 0; /* fall back to classic */
> 
> ?
> 
> Since it ain't very likely to happen, we could also just fail
> virtio_ccw_init() with -ENOMEM.

That is what I'm currently doing in v3.

> 
> Regards,
> Halil
> 
> 
>>
>>>   	return ccw_driver_register(&virtio_ccw_driver);
>>>   }
>>>   device_initcall(virtio_ccw_init);
>>
> 

Michael

