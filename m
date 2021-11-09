Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD15244A9FC
	for <lists+kvm@lfdr.de>; Tue,  9 Nov 2021 10:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244640AbhKIJF6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Nov 2021 04:05:58 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:25448 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244647AbhKIJEr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Nov 2021 04:04:47 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A97gXU4008878
        for <kvm@vger.kernel.org>; Tue, 9 Nov 2021 09:01:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=fxqT8E973hg9cQ5MsGdHKZgcUGIeLiKOuhbtyCKwXqM=;
 b=EN6hNqM6tMXp69V4UrXW+uDyUbRQO61y1tlLahTwucnVrrnOuMoD4OlqKrL+EW+Rnmvm
 KGZncKWRPCxp0IyUzZT0zyoVBtVV7U0HLK+oI8Pgyd2OHKhFrVBjud/4CleTpLMUlDnl
 zVpzYclPBCKu8vcW59jfNtX5ay/4yoL8LThfbk+3M8TIqmJ84MOPLBypOw+QCNQH8kmT
 nPLalqKKUVeWcvydrcngqBOwihq1bP4G1tM9Dby5ufEm44IeSKG0DZySYSYTXcu94vpf
 8Xzt0WWiPqZC0ofeINE4+C74W6kkeix5zWufyfSufP8UloDdwdJV3dwGab2L8gIp1wLL tQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c7mu9hm6y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 09 Nov 2021 09:01:29 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1A98fRsh032706
        for <kvm@vger.kernel.org>; Tue, 9 Nov 2021 09:01:29 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c7mu9hm6a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Nov 2021 09:01:28 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1A98qL3v002028;
        Tue, 9 Nov 2021 09:01:26 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06fra.de.ibm.com with ESMTP id 3c5gyjuyk6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Nov 2021 09:01:26 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1A98sk6e51904768
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 Nov 2021 08:54:46 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 183734204F;
        Tue,  9 Nov 2021 09:01:23 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AF36C4204B;
        Tue,  9 Nov 2021 09:01:22 +0000 (GMT)
Received: from [9.171.88.190] (unknown [9.171.88.190])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  9 Nov 2021 09:01:22 +0000 (GMT)
Message-ID: <f6d24d55-f8ec-dd38-299f-2c664982464c@linux.ibm.com>
Date:   Tue, 9 Nov 2021 10:01:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [kvm-unit-tests PATCH 6/7] s390x: virtio tests setup
Content-Language: en-US
To:     Andrew Jones <drjones@redhat.com>, Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
References: <1630059440-15586-1-git-send-email-pmorel@linux.ibm.com>
 <1630059440-15586-7-git-send-email-pmorel@linux.ibm.com>
 <20211103075636.hgxckmxs62bsdrha@gator.home>
 <c977b200-ba2d-d3eb-eae0-75a17d16496d@redhat.com>
 <4d85f61a-818c-4f72-6488-9ae2b21ad90a@linux.ibm.com>
 <f5aa60d6-6e9b-e64c-9f6a-9e6bdfc21d32@redhat.com>
 <20211109084224.t4yenupsb7z4diqg@gator.home>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20211109084224.t4yenupsb7z4diqg@gator.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: faMRwpl7yPFLqMXbpG3UawF5orcTeMHZ
X-Proofpoint-ORIG-GUID: Ciir8Tu7_NxPwhgW6PqrNvv-VMQmTY_c
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-09_02,2021-11-08_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=999 malwarescore=0 suspectscore=0 mlxscore=0 spamscore=0
 phishscore=0 priorityscore=1501 impostorscore=0 clxscore=1015 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111090053
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/9/21 09:42, Andrew Jones wrote:
> On Tue, Nov 09, 2021 at 08:10:34AM +0100, Thomas Huth wrote:
>> On 08/11/2021 14.00, Pierre Morel wrote:
>>>
>>>
>>> On 11/3/21 09:14, Thomas Huth wrote:
>>>> On 03/11/2021 08.56, Andrew Jones wrote:
>>>>> On Fri, Aug 27, 2021 at 12:17:19PM +0200, Pierre Morel wrote:
>>>>>> +
>>>>>> +#define VIRTIO_ID_PONG         30 /* virtio pong */
>>>>>
>>>>> I take it this is a virtio test device that ping-pong's I/O. It sounds
>>>>> useful for other VIRTIO transports too. Can it be ported? Hmm, I can't
>>>>> find it in QEMU at all?
>>>>
>>>> I also wonder whether we could do testing with an existing device
>>>> instead? E.g. do a loopback with a virtio-serial device? Or use two
>>>> virtio-net devices, connect them to a QEMU hub and send a packet
>>>> from one device to the other? ... that would be a little bit more
>>>> complicated here, but would not require a PONG device upstream
>>>> first, so it could also be used for testing older versions of
>>>> QEMU...
>>>>
>>>>    Thomas
>>>>
>>>>
>>>
>>> Yes having a dedicated device has the drawback that we need it in QEMU.
>>> On the other hand using a specific device, serial or network, wouldn't
>>> we get trapped with a reduce set of test possibilities?
>>>
>>> The idea was to have a dedicated test device, which could be flexible
>>> and extended to test all VIRTIO features, even the current
>>> implementation is yet far from it.
>>
>> Do you have anything in the works that could only be tested with a dedicated
>> test device? If not, I'd rather go with the loopback via virtio-net, I think
>> (you can peek into the s390-ccw bios sources to see how to send packets via
>> virtio-net, shouldn't be too hard to do, I think).
>>
>> The pong device could later be added on top for additional tests that are
>> not possible with virtio-net. And having some basic tests with virito-net
>> has also the advantage that the k-u-t work with QEMU binaries where the pong
>> device is not available, e.g. older versions and downstream versions that
>> only enable the bare minimum of devices to keep the attack surface small.
>>
> 
> I'd also like to see the testdev we already have, qemu:chardev/testdev.c,
> get more functions, but I'm not sure virtio-serial will allow you to
> exercise all the virtio functionality that you'd like to.
> 
> Thanks,
> drew
> 

Yes, that is why I did not used it first.
But OK, I understand what you both want and will build something in that 
direction, virtio-net, virtio-serial and come back later to something 
independent of existing devices if we find it does have a purpose.
Thanks for the comments.

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
