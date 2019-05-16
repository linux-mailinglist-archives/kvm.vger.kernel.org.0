Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29C82203DD
	for <lists+kvm@lfdr.de>; Thu, 16 May 2019 12:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726902AbfEPKsZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 May 2019 06:48:25 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35326 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726796AbfEPKsY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 May 2019 06:48:24 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4GAhkAw111304
        for <kvm@vger.kernel.org>; Thu, 16 May 2019 06:48:24 -0400
Received: from e16.ny.us.ibm.com (e16.ny.us.ibm.com [129.33.205.206])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sh3vvxgyf-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 16 May 2019 06:48:23 -0400
Received: from localhost
        by e16.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <farman@linux.ibm.com>;
        Thu, 16 May 2019 11:48:23 +0100
Received: from b01cxnp22034.gho.pok.ibm.com (9.57.198.24)
        by e16.ny.us.ibm.com (146.89.104.203) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 16 May 2019 11:48:19 +0100
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4GAmJu239321640
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 May 2019 10:48:19 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EBBAB2805E;
        Thu, 16 May 2019 10:48:18 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9B0542805A;
        Thu, 16 May 2019 10:48:18 +0000 (GMT)
Received: from [9.85.164.58] (unknown [9.85.164.58])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 16 May 2019 10:48:18 +0000 (GMT)
Subject: Re: [PATCH v2 5/7] s390/cio: Allow zero-length CCWs in vfio-ccw
To:     Cornelia Huck <cohuck@redhat.com>, Farhan Ali <alifm@linux.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
References: <20190514234248.36203-1-farman@linux.ibm.com>
 <20190514234248.36203-6-farman@linux.ibm.com>
 <20190515142339.12065a1d.cohuck@redhat.com>
 <f309cad9-9265-e276-8d57-8b6387f6fed7@linux.ibm.com>
 <39c7904f-7f9b-473d-201d-8d6aae4c490b@linux.ibm.com>
 <20190516115946.11d18510.cohuck@redhat.com>
From:   Eric Farman <farman@linux.ibm.com>
Date:   Thu, 16 May 2019 06:48:18 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190516115946.11d18510.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19051610-0072-0000-0000-0000042E616D
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011104; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000285; SDB=6.01204099; UDB=6.00632085; IPR=6.00985030;
 MB=3.00026916; MTD=3.00000008; XFM=3.00000015; UTC=2019-05-16 10:48:21
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19051610-0073-0000-0000-00004C3E4D71
Message-Id: <5db87f05-3b20-3c49-a730-318afa59ecfe@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-16_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905160072
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/16/19 5:59 AM, Cornelia Huck wrote:
> On Wed, 15 May 2019 16:08:18 -0400
> Farhan Ali <alifm@linux.ibm.com> wrote:
> 
>> On 05/15/2019 11:04 AM, Eric Farman wrote:
>>>
>>>
>>> On 5/15/19 8:23 AM, Cornelia Huck wrote:
>>>> On Wed, 15 May 2019 01:42:46 +0200
>>>> Eric Farman <farman@linux.ibm.com> wrote:
>>>>   
>>>>> It is possible that a guest might issue a CCW with a length of zero,
>>>>> and will expect a particular response.  Consider this chain:
>>>>>
>>>>>      Address   Format-1 CCW
>>>>>      --------  -----------------
>>>>>    0 33110EC0  346022CC 33177468
>>>>>    1 33110EC8  CF200000 3318300C
>>>>>
>>>>> CCW[0] moves a little more than two pages, but also has the
>>>>> Suppress Length Indication (SLI) bit set to handle the expectation
>>>>> that considerably less data will be moved.  CCW[1] also has the SLI
>>>>> bit set, and has a length of zero.  Once vfio-ccw does its magic,
>>>>> the kernel issues a start subchannel on behalf of the guest with this:
>>>>>
>>>>>      Address   Format-1 CCW
>>>>>      --------  -----------------
>>>>>    0 021EDED0  346422CC 021F0000
>>>>>    1 021EDED8  CF240000 3318300C
>>>>>
>>>>> Both CCWs were converted to an IDAL and have the corresponding flags
>>>>> set (which is by design), but only the address of the first data
>>>>> address is converted to something the host is aware of.  The second
>>>>> CCW still has the address used by the guest, which happens to be (A)
>>>>> (probably) an invalid address for the host, and (B) an invalid IDAW
>>>>> address (doubleword boundary, etc.).
>>>>>
>>>>> While the I/O fails, it doesn't fail correctly.  In this example, we
>>>>> would receive a program check for an invalid IDAW address, instead of
>>>>> a unit check for an invalid command.
>>>>>
>>>>> To fix this, revert commit 4cebc5d6a6ff ("vfio: ccw: validate the
>>>>> count field of a ccw before pinning") and allow the individual fetch
>>>>> routines to process them like anything else.  We'll make a slight
>>>>> adjustment to our allocation of the pfn_array (for direct CCWs) or
>>>>> IDAL (for IDAL CCWs) memory, so that we have room for at least one
>>>>> address even though no data will be transferred.
>>>>>
>>>>> Note that this doesn't provide us with a channel program that will
>>>>> fail in the expected way.  Since our length is zero, vfio_pin_pages()
>>>
>>> s/is/was/
>>>    
>>>>> returns -EINVAL and cp_prefetch() will thus fail.  This will be fixed
>>>>> in the next patch.
>>>>
>>>> So, this failed before, and still fails, just differently?
>>>
>>> Probably.  If the guest gave us a valid address, the pin might actually
>>> work now whereas before it would fail because the length was zero.  If
>>> the address were also invalid,
>>>    
>>>   >IOW, this
>>>> has no effect on bisectability?
>>>
>>> I think so, but I suppose that either (A) patch 5 and 6 could be
>>> squashed together, or (B) I could move the "set pa_nr to zero" (or more
>>> accurately, set it to ccw->count) pieces from patch 6 into this patch,
>>> so that the vfio_pin_pages() call occurs like it does today.
>>>    
>>>>   
>>
>> While going through patch 5, I was confused as to why we need to pin
>> pages if we are only trying to translate the addresses and no data
>> transfer will take place with count==0. Well, you answer that in patch 6 :)
>>
>> So maybe it might be better to move parts of patch 6 to 5 or squash
>> them, or maybe reverse the order.
> 
> I think this will get a bit unwieldy of squashed, so what about simply
> moving code from 6 to 5? I think people are confused enough by the two
> patches to make a change look like a good idea.

Agreed.  I swapped them locally yesterday to see how bad that work might 
become, and I think got them reworked to fit properly.  Will be making 
sure they don't break anything in this order today, but shouldn't take 
long to be sure.

> 
> (I can queue patches 1-4 to get them out of the way :)

I wouldn't mind that.  :)

  - Eric

> 
>>
>> Thanks
>> Farhan
>>
>>
>>>>>
>>>>> Signed-off-by: Eric Farman <farman@linux.ibm.com>
>>>>> ---
>>>>>    drivers/s390/cio/vfio_ccw_cp.c | 26 ++++++++------------------
>>>>>    1 file changed, 8 insertions(+), 18 deletions(-)
>>>>   
>>>    
>>
> 

