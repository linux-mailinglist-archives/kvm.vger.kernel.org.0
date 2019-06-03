Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 853F53315E
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2019 15:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728330AbfFCNni (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jun 2019 09:43:38 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36472 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728350AbfFCNni (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 Jun 2019 09:43:38 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x53DbMiQ133193
        for <kvm@vger.kernel.org>; Mon, 3 Jun 2019 09:43:36 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2sw47qshsj-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 03 Jun 2019 09:43:36 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <mimu@linux.ibm.com>;
        Mon, 3 Jun 2019 14:43:34 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 3 Jun 2019 14:43:30 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x53DhS6853084226
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Jun 2019 13:43:29 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E23E2A404D;
        Mon,  3 Jun 2019 13:43:28 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4D63CA4040;
        Mon,  3 Jun 2019 13:43:28 +0000 (GMT)
Received: from [9.152.98.28] (unknown [9.152.98.28])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  3 Jun 2019 13:43:28 +0000 (GMT)
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
 <035b4bd3-5856-e8e5-91bf-ba0b5c7c3736@linux.ibm.com>
 <20190603145730.3e45b8f5.pasic@linux.ibm.com>
 <20190603153420.671939c3.cohuck@redhat.com>
From:   Michael Mueller <mimu@linux.ibm.com>
Organization: IBM
Date:   Mon, 3 Jun 2019 15:43:28 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190603153420.671939c3.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19060313-0020-0000-0000-000003443333
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19060313-0021-0000-0000-000021973597
Message-Id: <7fa32979-b94f-ad71-3c1b-37b601c114e7@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-03_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906030098
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 03.06.19 15:34, Cornelia Huck wrote:
> On Mon, 3 Jun 2019 14:57:30 +0200
> Halil Pasic <pasic@linux.ibm.com> wrote:
> 
>> On Mon, 3 Jun 2019 14:09:02 +0200
>> Michael Mueller <mimu@linux.ibm.com> wrote:
>>
>>>>> @@ -224,6 +226,8 @@ struct subchannel *css_alloc_subchannel(struct subchannel_id schid,
>>>>>    	INIT_WORK(&sch->todo_work, css_sch_todo);
>>>>>    	sch->dev.release = &css_subchannel_release;
>>>>>    	device_initialize(&sch->dev);
>>>>
>>>> It might be helpful to add a comment why you use 31 bit here...
>>>
>>> @Halil, please let me know what comment you prefere here...
>>>    
>>
>> How about?
>>
>> /*
>>   * The physical addresses of some the dma structures that
>>   * can belong  to a subchannel need to fit 31 bit width (examples ccw,).
>>   */
> 
> "e.g. ccw"?
> 
>>
>>
>>>>      
>>>>> +	sch->dev.coherent_dma_mask = DMA_BIT_MASK(31);
>>>>> +	sch->dev.dma_mask = &sch->dev.coherent_dma_mask;
>>>>>    	return sch;
>>>>>    
>>>>>    err:
>>>>> @@ -899,6 +903,8 @@ static int __init setup_css(int nr)
>>>>>    	dev_set_name(&css->device, "css%x", nr);
>>>>>    	css->device.groups = cssdev_attr_groups;
>>>>>    	css->device.release = channel_subsystem_release;
>>>>
>>>> ...and 64 bit here.
>>>
>>> and here.
>>
>> /*
>>   * We currently allocate notifier bits with this (using css->device
>>   * as the device argument with the DMA API), and are fine with 64 bit
>>   * addresses.
>>   */
> 
> Thanks, that makes things hopefully clearer if we look at it some time
> in the future ;)
> 

Applied both with with requested change.

Michael

