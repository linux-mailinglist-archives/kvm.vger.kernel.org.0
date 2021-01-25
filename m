Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAA2F302757
	for <lists+kvm@lfdr.de>; Mon, 25 Jan 2021 16:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728875AbhAYPzW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jan 2021 10:55:22 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:17554 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728134AbhAYPw7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 Jan 2021 10:52:59 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10PF4dK7180046;
        Mon, 25 Jan 2021 10:52:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=EKWPaDjPRkWw1Z3+/SrXg0fHgf06efCZ8z4aHSr4gU4=;
 b=tH4mMDSKX7mkVgL2JrOGmSBu4SnN5R37DqBJOvv3Sbv+tr04W77UZqOs3IKmjVw0oYZ7
 KnVCu1TuQdBJIBiWiW71lI/vBx6tQMDkyFyShB6waeiraAw7crtt2xRZJMSfXUJQ+ozo
 it8My/iIDrxgUDc/s8/0nI5Qt8lfA9jNDI/MKvpwHOkygb0/9cbLqAVKtqAUws9EWxNk
 rx9Ix8mk93NPFZWAhRd1nyU3g2CuUTEBz63nBpr8QkENOSRvVZZzhh06w3RovGjxi9X5
 7NCncajanHaE/LTD86Hak3Uw5xM94EtURICT1V5Ba8Xm0UsKAT4qTsneUsTOqgd1zJco pQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36a00x2ka8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Jan 2021 10:52:11 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10PF5MVe184462;
        Mon, 25 Jan 2021 10:52:10 -0500
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36a00x2k9k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Jan 2021 10:52:10 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10PFcYxu017763;
        Mon, 25 Jan 2021 15:52:10 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma03dal.us.ibm.com with ESMTP id 368be8upkw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Jan 2021 15:52:09 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10PFq6Fa23855414
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Jan 2021 15:52:06 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6F6076A04F;
        Mon, 25 Jan 2021 15:52:06 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 31F5A6A051;
        Mon, 25 Jan 2021 15:52:05 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.211.138.51])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 25 Jan 2021 15:52:04 +0000 (GMT)
Subject: Re: [PATCH 4/4] vfio-pci/zdev: Introduce the zPCI I/O vfio region
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        schnelle@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@de.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1611086550-32765-1-git-send-email-mjrosato@linux.ibm.com>
 <1611086550-32765-5-git-send-email-mjrosato@linux.ibm.com>
 <20210122164843.269f806c@omen.home.shazbot.org>
 <9c363ff5-b76c-d697-98e2-cf091a404d15@linux.ibm.com>
 <20210125164252.1d1af6cd.cohuck@redhat.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
Message-ID: <b9499b13-980b-8fa6-07c8-c74ed2cb90bd@linux.ibm.com>
Date:   Mon, 25 Jan 2021 10:52:04 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210125164252.1d1af6cd.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-25_05:2021-01-25,2021-01-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 phishscore=0 mlxlogscore=917 bulkscore=0
 lowpriorityscore=0 priorityscore=1501 spamscore=0 clxscore=1015
 malwarescore=0 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2101250088
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/25/21 10:42 AM, Cornelia Huck wrote:
> On Mon, 25 Jan 2021 09:40:38 -0500
> Matthew Rosato <mjrosato@linux.ibm.com> wrote:
> 
>> On 1/22/21 6:48 PM, Alex Williamson wrote:
>>> On Tue, 19 Jan 2021 15:02:30 -0500
>>> Matthew Rosato <mjrosato@linux.ibm.com> wrote:
>>>    
>>>> Some s390 PCI devices (e.g. ISM) perform I/O operations that have very
>>>> specific requirements in terms of alignment as well as the patterns in
>>>> which the data is read/written. Allowing these to proceed through the
>>>> typical vfio_pci_bar_rw path will cause them to be broken in up in such a
>>>> way that these requirements can't be guaranteed. In addition, ISM devices
>>>> do not support the MIO codepaths that might be triggered on vfio I/O coming
>>>> from userspace; we must be able to ensure that these devices use the
>>>> non-MIO instructions.  To facilitate this, provide a new vfio region by
>>>> which non-MIO instructions can be passed directly to the host kernel s390
>>>> PCI layer, to be reliably issued as non-MIO instructions.
>>>>
>>>> This patch introduces the new vfio VFIO_REGION_SUBTYPE_IBM_ZPCI_IO region
>>>> and implements the ability to pass PCISTB and PCILG instructions over it,
>>>> as these are what is required for ISM devices.
>>>
>>> There have been various discussions about splitting vfio-pci to allow
>>> more device specific drivers rather adding duct tape and bailing wire
>>> for various device specific features to extend vfio-pci.  The latest
>>> iteration is here[1].  Is it possible that such a solution could simply
>>> provide the standard BAR region indexes, but with an implementation that
>>> works on s390, rather than creating new device specific regions to
>>> perform the same task?  Thanks,
>>>
>>> Alex
>>>
>>> [1]https://lore.kernel.org/lkml/20210117181534.65724-1-mgurtovoy@nvidia.com/
>>>    
>>
>> Thanks for the pointer, I'll have to keep an eye on this.  An approach
>> like this could solve some issues, but I think a main issue that still
>> remains with relying on the standard BAR region indexes (whether using
>> the current vfio-pci driver or a device-specific driver) is that QEMU
>> writes to said BAR memory region are happening in, at most, 8B chunks
>> (which then, in the current general-purpose vfio-pci code get further
>> split up into 4B iowrite operations).  The alternate approach I'm
>> proposing here is allowing for the whole payload (4K) in a single
>> operation, which is significantly faster.  So, I suspect even with a
>> device specific driver we'd want this sort of a region anyhow..
> 
> I'm also wondering about device specific vs architecture/platform
> specific handling.
> 
> If we're trying to support ISM devices, that's device specific
> handling; but if we're trying to add more generic things like the large
> payload support, that's not necessarily tied to a device, is it? For
> example, could a device support large payload if plugged into a z, but
> not if plugged into another machine? >

Yes, that's correct -- While ISM is providing the impetus and has a hard 
requirement for some of this due to the MIO instruction quirk, the 
mechanism being implemented here is definitely not ISM-specific -- it's 
more like an s390-wide quirk that could really benefit any device that 
wants to do large payloads (PCISTB).

And I think that ultimately goes back to why Pierre wanted to have QEMU 
be as permissive as possible in using the region vs limiting it only to 
ISM.
