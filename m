Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB5361F5C5
	for <lists+kvm@lfdr.de>; Wed, 15 May 2019 15:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727811AbfEONnk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 May 2019 09:43:40 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:34918 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726674AbfEONnk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 May 2019 09:43:40 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4FDe2a7101402
        for <kvm@vger.kernel.org>; Wed, 15 May 2019 09:43:38 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sghwtebrg-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 15 May 2019 09:43:37 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <mimu@linux.ibm.com>;
        Wed, 15 May 2019 14:43:29 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 15 May 2019 14:43:26 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4FDhOZe46334144
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 May 2019 13:43:24 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 649E95204F;
        Wed, 15 May 2019 13:43:24 +0000 (GMT)
Received: from [9.152.99.219] (unknown [9.152.99.219])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id B2D4552050;
        Wed, 15 May 2019 13:43:23 +0000 (GMT)
Reply-To: mimu@linux.ibm.com
Subject: Re: [PATCH 10/10] virtio/s390: make airq summary indicators DMA
To:     Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Sebastian Ott <sebott@linux.ibm.com>,
        virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>
References: <20190426183245.37939-1-pasic@linux.ibm.com>
 <20190426183245.37939-11-pasic@linux.ibm.com>
 <20190513142010.36c8478f.cohuck@redhat.com>
From:   Michael Mueller <mimu@linux.ibm.com>
Organization: IBM
Date:   Wed, 15 May 2019 15:43:23 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190513142010.36c8478f.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19051513-0008-0000-0000-000002E6F96B
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19051513-0009-0000-0000-000022539922
Message-Id: <3a8353e2-97e3-778e-ab2e-ef285ac7027d@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-15_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905150086
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 13.05.19 14:20, Cornelia Huck wrote:
> On Fri, 26 Apr 2019 20:32:45 +0200
> Halil Pasic <pasic@linux.ibm.com> wrote:
> 
>> Hypervisor needs to interact with the summary indicators, so these
>> need to be DMA memory as well (at least for protected virtualization
>> guests).
>>
>> Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
>> ---
>>   drivers/s390/virtio/virtio_ccw.c | 24 +++++++++++++++++-------
>>   1 file changed, 17 insertions(+), 7 deletions(-)
> 
> (...)
> 
>> @@ -237,7 +243,8 @@ static void virtio_airq_handler(struct airq_struct *airq)
>>   	read_unlock(&info->lock);
>>   }
>>   
>> -static struct airq_info *new_airq_info(void)
>> +/* call with drivers/s390/virtio/virtio_ccw.cheld */
> 
> Hm, where is airq_areas_lock defined? If it was introduced in one of
> the previous patches, I have missed it.

There is no airq_areas_lock defined currently. My assumption is that
this will be used in context with the likely race condition this
part of the patch is talking about.

@@ -273,8 +281,9 @@ static unsigned long get_airq_indicator(struct 
virtqueue *vqs[], int nvqs,
  	unsigned long bit, flags;

  	for (i = 0; i < MAX_AIRQ_AREAS && !indicator_addr; i++) {
+		/* TODO: this seems to be racy */
  		if (!airq_areas[i])
-			airq_areas[i] = new_airq_info();
+			airq_areas[i] = new_airq_info(i);


As this shall be handled by a separate patch I will drop the comment
in regard to airq_areas_lock from this patch as well for v2.

Michael

> 
>> +static struct airq_info *new_airq_info(int index)
>>   {
>>   	struct airq_info *info;
>>   	int rc;
> 

