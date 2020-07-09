Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9164721A27F
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 16:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727819AbgGIOvU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 10:51:20 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:18396 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726353AbgGIOvU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jul 2020 10:51:20 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 069EWgTj008126;
        Thu, 9 Jul 2020 10:51:12 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 325n5xtvef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Jul 2020 10:51:12 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 069EWv6i009579;
        Thu, 9 Jul 2020 10:51:11 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 325n5xtvd3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Jul 2020 10:51:11 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 069Efn2w009788;
        Thu, 9 Jul 2020 14:51:09 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06fra.de.ibm.com with ESMTP id 325k2qrfxa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Jul 2020 14:51:09 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 069Ep5MW10551578
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Jul 2020 14:51:06 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C6E23AE05F;
        Thu,  9 Jul 2020 14:51:05 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F3EDBAE051;
        Thu,  9 Jul 2020 14:51:04 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.34.67])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  9 Jul 2020 14:51:04 +0000 (GMT)
Subject: Re: [PATCH v5 2/2] s390: virtio: PV needs VIRTIO I/O device
 protection
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, mst@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, thomas.lendacky@amd.com,
        david@gibson.dropbear.id.au, linuxram@us.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com
References: <1594283959-13742-1-git-send-email-pmorel@linux.ibm.com>
 <1594283959-13742-3-git-send-email-pmorel@linux.ibm.com>
 <20200709105733.6d68fa53.cohuck@redhat.com>
 <270d8674-0f73-0a38-a2a7-fbc1caa44301@linux.ibm.com>
 <20200709164700.09a83069.pasic@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <c9be019f-236e-5e44-64b6-0875cd40ab11@linux.ibm.com>
Date:   Thu, 9 Jul 2020 16:51:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200709164700.09a83069.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-09_08:2020-07-09,2020-07-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 bulkscore=0 impostorscore=0 malwarescore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 phishscore=0 spamscore=0
 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007090104
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-07-09 16:47, Halil Pasic wrote:
> On Thu, 9 Jul 2020 12:51:58 +0200
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>>>> +int arch_validate_virtio_features(struct virtio_device *dev)
>>>> +{
>>>> +	if (!is_prot_virt_guest())
>>>> +		return 0;
>>>> +
>>>> +	if (!virtio_has_feature(dev, VIRTIO_F_VERSION_1)) {
>>>> +		dev_warn(&dev->dev, "device must provide VIRTIO_F_VERSION_1\n");
>>>
>>> I'd probably use "legacy virtio not supported with protected
>>> virtualization".
>>>    
>>>> +		return -ENODEV;
>>>> +	}
>>>> +
>>>> +	if (!virtio_has_feature(dev, VIRTIO_F_IOMMU_PLATFORM)) {
>>>> +		dev_warn(&dev->dev,
>>>> +			 "device must provide VIRTIO_F_IOMMU_PLATFORM\n");
>>>
>>> "support for limited memory access required for protected
>>> virtualization"
>>>
>>> ?
>>>
>>> Mentioning the feature flag is shorter in both cases, though.
>>
>> And I think easier to look for in case of debugging purpose.
>> I change it if there is more demands.
> 
> Not all our end users are kernel and/or qemu developers. I find the
> messages from v4 less technical, more informative, and way better.
> 
> Regards,
> Halil
> 

Can you please tell me the messages you are speaking of, because for me 
the warning's messages are exactly the same in v4 and v5!?

I checked many times, but may be I still missed something.

Regards,
Pierre


-- 
Pierre Morel
IBM Lab Boeblingen
