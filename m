Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7BC525812A
	for <lists+kvm@lfdr.de>; Mon, 31 Aug 2020 20:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729239AbgHaSeX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Aug 2020 14:34:23 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45346 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728748AbgHaSeX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 31 Aug 2020 14:34:23 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07VIWWG8146794;
        Mon, 31 Aug 2020 14:34:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=TEjsDqJ+Qq9r48V+zxdJ1HjjfjTzuEurbsewT8DpRDE=;
 b=fewlgfbOwLPYhkvXTFSRodFfRl9TX37w+fW787h0OPHH1TYmzLYLaD6Qw1dd1Rk0/AGz
 qFNF1Tgu18z2+gGImT2Th7LwziGoaK2wSZJs+PdX6ck30y4W7wbyD4c2NY2P2PWsj+Oj
 iXLodE2odFNQyddPjEN5L39FzJnWXIhjsK8lWo/3Y52BPQAZn88r707TuHNys/iniPOW
 dVQzz8ALGfQ9uA0RXMjupFS2IuASmALKX63r9WFtMV2HjNv0xcfq0bTo3MVlDuKMdr5X
 n5mCmgYEyNKVrc+B/1nLGUHc7RSlC4iBf/R4DbfryOKyyEborDHWupdu7gJPsMOqqXqH XQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3395wns5uk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Aug 2020 14:34:21 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07VIXlRv154296;
        Mon, 31 Aug 2020 14:34:20 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3395wns5ts-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Aug 2020 14:34:20 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07VIVL5f029266;
        Mon, 31 Aug 2020 18:34:19 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma01dal.us.ibm.com with ESMTP id 337en96kjd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Aug 2020 18:34:19 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07VIYHKY48824606
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Aug 2020 18:34:17 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 88C7EAE05F;
        Mon, 31 Aug 2020 18:34:17 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 039DCAE060;
        Mon, 31 Aug 2020 18:34:16 +0000 (GMT)
Received: from cpe-172-100-175-116.stny.res.rr.com (unknown [9.85.170.64])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 31 Aug 2020 18:34:16 +0000 (GMT)
Subject: Re: [PATCH v10 16/16] s390/vfio-ap: update docs to include dynamic
 config support
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com
References: <20200821195616.13554-1-akrowiak@linux.ibm.com>
 <20200821195616.13554-17-akrowiak@linux.ibm.com>
 <20200825124529.7b51d825.cohuck@redhat.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <cb4d43b9-bfe1-b2a0-179c-a6362a5f1380@linux.ibm.com>
Date:   Mon, 31 Aug 2020 14:34:16 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200825124529.7b51d825.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-31_09:2020-08-31,2020-08-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 adultscore=0 mlxscore=0 priorityscore=1501 suspectscore=3
 spamscore=0 mlxlogscore=999 clxscore=1015 lowpriorityscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008310108
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/25/20 6:45 AM, Cornelia Huck wrote:
> On Fri, 21 Aug 2020 15:56:16 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> Update the documentation in vfio-ap.rst to include information about the
>> AP dynamic configuration support (i.e., hot plug of adapters, domains
>> and control domains via the matrix mediated device's sysfs assignment
>> attributes).
>>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> ---
>>   Documentation/s390/vfio-ap.rst | 362 ++++++++++++++++++++++++++-------
>>   1 file changed, 285 insertions(+), 77 deletions(-)
>>
>> diff --git a/Documentation/s390/vfio-ap.rst b/Documentation/s390/vfio-ap.rst
>> index e15436599086..8907aeca8fb7 100644
>> --- a/Documentation/s390/vfio-ap.rst
>> +++ b/Documentation/s390/vfio-ap.rst
>> @@ -253,7 +253,7 @@ The process for reserving an AP queue for use by a KVM guest is:
>>   1. The administrator loads the vfio_ap device driver
>>   2. The vfio-ap driver during its initialization will register a single 'matrix'
>>      device with the device core. This will serve as the parent device for
>> -   all mediated matrix devices used to configure an AP matrix for a guest.
>> +   all matrix mediated devices used to configure an AP matrix for a guest.
> This (and many other changes here) seems to be unrelated to the new
> feature. Split that out into a separate patch that can be applied right
> away? That would make this patch smaller and easier to review; it's
> hard to figure out which parts deal with the new feature, and which parts
> simply got an update.
>
> Also, do you want to do similar wording changes in the QEMU
> documentation for vfio-ap?

Will do.

>
>>   3. The /sys/devices/vfio_ap/matrix device is created by the device core
>>   4. The vfio_ap device driver will register with the AP bus for AP queue devices
>>      of type 10 and higher (CEX4 and newer). The driver will provide the vfio_ap
> (...)
>
>> @@ -435,6 +481,10 @@ available to a KVM guest via the following CPU model features:
>>      can be made available to the guest only if it is available on the host (i.e.,
>>      facility bit 12 is set).
>>   
>> +4. apqi: Indicates AP queue interrupts are available on the guest. This facility
>> +   can be made available to the guest only if it is available on the host (i.e.,
>> +   facility bit 65 is set).
>> +
>>   Note: If the user chooses to specify a CPU model different than the 'host'
>>   model to QEMU, the CPU model features and facilities need to be turned on
>>   explicitly; for example::
>> @@ -444,7 +494,7 @@ explicitly; for example::
>>   A guest can be precluded from using AP features/facilities by turning them off
>>   explicitly; for example::
>>   
>> -     /usr/bin/qemu-system-s390x ... -cpu host,ap=off,apqci=off,apft=off
>> +     /usr/bin/qemu-system-s390x ... -cpu host,ap=off,apqci=off,apft=off,apqi=off
> Isn't that an already existing facility that was simply lacking
> documentation? If yes, split it off?

Yes and will do.

>
>>   
>>   Note: If the APFT facility is turned off (apft=off) for the guest, the guest
>>   will not see any AP devices. The zcrypt device drivers that register for type 10
> (...)
>

