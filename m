Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 607351FB61
	for <lists+kvm@lfdr.de>; Wed, 15 May 2019 22:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbfEOUId (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 May 2019 16:08:33 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51520 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726124AbfEOUId (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 May 2019 16:08:33 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4FK8U75005934
        for <kvm@vger.kernel.org>; Wed, 15 May 2019 16:08:32 -0400
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sgr2putxv-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 15 May 2019 16:08:31 -0400
Received: from localhost
        by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <alifm@linux.ibm.com>;
        Wed, 15 May 2019 21:08:23 +0100
Received: from b03cxnp07029.gho.boulder.ibm.com (9.17.130.16)
        by e31.co.us.ibm.com (192.168.1.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 15 May 2019 21:08:21 +0100
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4FK8JNJ8585496
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 May 2019 20:08:19 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BF095C6055;
        Wed, 15 May 2019 20:08:19 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 540C5C605B;
        Wed, 15 May 2019 20:08:19 +0000 (GMT)
Received: from [9.56.58.102] (unknown [9.56.58.102])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 15 May 2019 20:08:19 +0000 (GMT)
Subject: Re: [PATCH v2 5/7] s390/cio: Allow zero-length CCWs in vfio-ccw
To:     Eric Farman <farman@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
References: <20190514234248.36203-1-farman@linux.ibm.com>
 <20190514234248.36203-6-farman@linux.ibm.com>
 <20190515142339.12065a1d.cohuck@redhat.com>
 <f309cad9-9265-e276-8d57-8b6387f6fed7@linux.ibm.com>
From:   Farhan Ali <alifm@linux.ibm.com>
Date:   Wed, 15 May 2019 16:08:18 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <f309cad9-9265-e276-8d57-8b6387f6fed7@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19051520-8235-0000-0000-00000E971E19
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011102; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000285; SDB=6.01203813; UDB=6.00631912; IPR=6.00984739;
 MB=3.00026907; MTD=3.00000008; XFM=3.00000015; UTC=2019-05-15 20:08:22
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19051520-8236-0000-0000-00004593B4CE
Message-Id: <39c7904f-7f9b-473d-201d-8d6aae4c490b@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-15_15:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=827 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905150122
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 05/15/2019 11:04 AM, Eric Farman wrote:
> 
> 
> On 5/15/19 8:23 AM, Cornelia Huck wrote:
>> On Wed, 15 May 2019 01:42:46 +0200
>> Eric Farman <farman@linux.ibm.com> wrote:
>>
>>> It is possible that a guest might issue a CCW with a length of zero,
>>> and will expect a particular response.  Consider this chain:
>>>
>>>     Address   Format-1 CCW
>>>     --------  -----------------
>>>   0 33110EC0  346022CC 33177468
>>>   1 33110EC8  CF200000 3318300C
>>>
>>> CCW[0] moves a little more than two pages, but also has the
>>> Suppress Length Indication (SLI) bit set to handle the expectation
>>> that considerably less data will be moved.  CCW[1] also has the SLI
>>> bit set, and has a length of zero.  Once vfio-ccw does its magic,
>>> the kernel issues a start subchannel on behalf of the guest with this:
>>>
>>>     Address   Format-1 CCW
>>>     --------  -----------------
>>>   0 021EDED0  346422CC 021F0000
>>>   1 021EDED8  CF240000 3318300C
>>>
>>> Both CCWs were converted to an IDAL and have the corresponding flags
>>> set (which is by design), but only the address of the first data
>>> address is converted to something the host is aware of.  The second
>>> CCW still has the address used by the guest, which happens to be (A)
>>> (probably) an invalid address for the host, and (B) an invalid IDAW
>>> address (doubleword boundary, etc.).
>>>
>>> While the I/O fails, it doesn't fail correctly.  In this example, we
>>> would receive a program check for an invalid IDAW address, instead of
>>> a unit check for an invalid command.
>>>
>>> To fix this, revert commit 4cebc5d6a6ff ("vfio: ccw: validate the
>>> count field of a ccw before pinning") and allow the individual fetch
>>> routines to process them like anything else.  We'll make a slight
>>> adjustment to our allocation of the pfn_array (for direct CCWs) or
>>> IDAL (for IDAL CCWs) memory, so that we have room for at least one
>>> address even though no data will be transferred.
>>>
>>> Note that this doesn't provide us with a channel program that will
>>> fail in the expected way.  Since our length is zero, vfio_pin_pages()
> 
> s/is/was/
> 
>>> returns -EINVAL and cp_prefetch() will thus fail.  This will be fixed
>>> in the next patch.
>>
>> So, this failed before, and still fails, just differently? 
> 
> Probably.  If the guest gave us a valid address, the pin might actually 
> work now whereas before it would fail because the length was zero.  If 
> the address were also invalid,
> 
>  >IOW, this
>> has no effect on bisectability?
> 
> I think so, but I suppose that either (A) patch 5 and 6 could be 
> squashed together, or (B) I could move the "set pa_nr to zero" (or more 
> accurately, set it to ccw->count) pieces from patch 6 into this patch, 
> so that the vfio_pin_pages() call occurs like it does today.
> 
>>

While going through patch 5, I was confused as to why we need to pin 
pages if we are only trying to translate the addresses and no data 
transfer will take place with count==0. Well, you answer that in patch 6 :)

So maybe it might be better to move parts of patch 6 to 5 or squash 
them, or maybe reverse the order.

Thanks
Farhan


>>>
>>> Signed-off-by: Eric Farman <farman@linux.ibm.com>
>>> ---
>>>   drivers/s390/cio/vfio_ccw_cp.c | 26 ++++++++------------------
>>>   1 file changed, 8 insertions(+), 18 deletions(-)
>>
> 

