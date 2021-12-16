Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2CD64774FD
	for <lists+kvm@lfdr.de>; Thu, 16 Dec 2021 15:51:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237913AbhLPOva (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Dec 2021 09:51:30 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:13454 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230071AbhLPOv3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Dec 2021 09:51:29 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BGE2m5f018650;
        Thu, 16 Dec 2021 14:51:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=9cdVxNkXFUtdUSJugRQth96/dBPjYjnZyp9n+0PpXac=;
 b=B7wvWJeDZLRX+LOlBwrNMUhk6+b6pvJXSEbUyVXYjJxUyykwFKB+ZB+OX2wABtwYxQuG
 JcRBGUvq9HIoDmmRCOwZAFWd8TGUWIS4lGxuGW0EwcgTwKRFRRds95Nss1Xtq516m2lP
 xtK2uJ3iTCAtTrEFX8c6lN9gkvgmcK4gOpD09sz3neODx/2Vaat3hpYoSjxDp1Ca3r9a
 3jqOnbULJYq4brnxVBWMc/M/WvVUqiXAldW1PU2V37Jt7+1jKb5G2Zuu4FWws0muHS66
 YwaE+ZLWQnDeae52DmAyclY6BGpuePMMDlE6XchtOhe4CM4AemgCYJ1B36zGIVWgUrue TQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cyn1jydvn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Dec 2021 14:51:28 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BGEjDeP019793;
        Thu, 16 Dec 2021 14:51:28 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cyn1jydv2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Dec 2021 14:51:28 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BGEliDj001188;
        Thu, 16 Dec 2021 14:51:27 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma02wdc.us.ibm.com with ESMTP id 3cy77yksa9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Dec 2021 14:51:27 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BGEpPIc18481504
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Dec 2021 14:51:25 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 52AC378064;
        Thu, 16 Dec 2021 14:51:25 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9A67978060;
        Thu, 16 Dec 2021 14:51:23 +0000 (GMT)
Received: from [9.211.79.24] (unknown [9.211.79.24])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 16 Dec 2021 14:51:23 +0000 (GMT)
Message-ID: <ee217f34-539f-2759-e4ac-5098e3923555@linux.ibm.com>
Date:   Thu, 16 Dec 2021 09:51:22 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 23/32] KVM: s390: pci: handle refresh of PCI translations
Content-Language: en-US
To:     Niklas Schnelle <schnelle@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        farman@linux.ibm.com, borntraeger@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        agordeev@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
 <20211207205743.150299-24-mjrosato@linux.ibm.com>
 <d2af697e-bf48-e78b-eed6-766f0790232f@linux.ibm.com>
 <a963388d-b13e-07c5-c256-c91671b3aa73@linux.ibm.com>
 <9a953a7938218afed246e93995d22ee7d09a81f3.camel@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <9a953a7938218afed246e93995d22ee7d09a81f3.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: aUNvU2mYj5-qgHi9vbqg7vbk8wcH4f7K
X-Proofpoint-GUID: i_4QVHy6VyEac7L87FLOjuI9Dotnqax_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-16_05,2021-12-16_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 lowpriorityscore=0 priorityscore=1501 impostorscore=0 suspectscore=0
 clxscore=1015 malwarescore=0 spamscore=0 mlxscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112160081
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/16/21 9:39 AM, Niklas Schnelle wrote:
> On Tue, 2021-12-14 at 12:54 -0500, Matthew Rosato wrote:
>> On 12/14/21 11:59 AM, Pierre Morel wrote:
>>>
>>> On 12/7/21 21:57, Matthew Rosato wrote:
>>>> Add a routine that will perform a shadow operation between a guest
>>>> and host IOAT.  A subsequent patch will invoke this in response to
>>>> an 04 RPCIT instruction intercept.
>>>>
>>>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>>>> ---
>>>>    arch/s390/include/asm/kvm_pci.h |   1 +
>>>>    arch/s390/include/asm/pci_dma.h |   1 +
>>>>    arch/s390/kvm/pci.c             | 191 ++++++++++++++++++++++++++++++++
>>>>    arch/s390/kvm/pci.h             |   4 +-
>>>>    4 files changed, 196 insertions(+), 1 deletion(-)
>>>>
> ---8<---
>>>
>>>> +
>>>> +int kvm_s390_pci_refresh_trans(struct kvm_vcpu *vcpu, unsigned long req,
>>>> +                   unsigned long start, unsigned long size)
>>>> +{
>>>> +    struct zpci_dev *zdev;
>>>> +    u32 fh;
>>>> +    int rc;
>>>> +
>>>> +    /* If the device has a SHM bit on, let userspace take care of
>>>> this */
>>>> +    fh = req >> 32;
>>>> +    if ((fh & aift.mdd) != 0)
>>>> +        return -EOPNOTSUPP;
>>>
>>> I think you should make this check in the caller.
>>
>> OK
>>
>>>> +
>>>> +    /* Make sure this is a valid device associated with this guest */
>>>> +    zdev = get_zdev_by_fh(fh);
>>>> +    if (!zdev || !zdev->kzdev || zdev->kzdev->kvm != vcpu->kvm)
>>>> +        return -EINVAL;
>>>> +
>>>> +    /* Only proceed if the device is using the assist */
>>>> +    if (zdev->kzdev->ioat.head[0] == 0)
>>>> +        return -EOPNOTSUPP;
>>>
>>> Using the assist means using interpretation over using interception and
>>> legacy vfio-pci. right?
>>
>> Right - more specifically that the IOAT assist feature was never set via
>> the vfio feature ioctl, so we can't handle the RPCIT for this device and
>> so throw to userspace.
>>
>> The way the QEMU series is being implemented, a device using
>> interpretation will always have the IOAT feature set on.
>>
>>>> +
>>>> +    rc = dma_table_shadow(vcpu, zdev, start, size);
>>>> +    if (rc > 0)
>>>> +        rc = zpci_refresh_trans((u64) zdev->fh << 32, start, size);
>>>
>>> Here you lose the status reported by the hardware.
>>> You should directly use __rpcit(fn, addr, range, &status);
>>
>> OK, I can have a look at doing this.
>>
>> @Niklas thoughts on how you would want this exported.  Renamed to
>> zpci_rpcit or so?
> 
> Hmm with using __rpcit() directly we would lose the error reporting in
> s390dbf and this ist still kind of a RPCIT in the host. How about we
> add the status as an out parameter to zpci_refresh_trans()? But yes if

Another advantage of doing this would be that we then also keep the cc2 
retry logic in zpci_refresh_trans(), which would be nice.

However we do still lose the returned CC value from the instruction. 
But I think we can infer a CC1 from a nonzero status and a CC3 from a 
zero status so maybe this is OK too.

I think I will add the status parm to zpci_refresh_trans().

FWIW, I do also think it is likely we will end up with a s390dbf for 
kvm-pci at some point after this initial series.


> you prefer to use __rpcit() directly I would rename it to zpci_rpcit().
> 

>>
> 
> ---8<---
> 

