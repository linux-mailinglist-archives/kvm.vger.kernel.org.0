Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8646D51779F
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 21:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234612AbiEBUAm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 16:00:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234557AbiEBUAl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 16:00:41 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBD0BBC3D
        for <kvm@vger.kernel.org>; Mon,  2 May 2022 12:57:10 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 242JKoXc030855;
        Mon, 2 May 2022 19:57:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=84KxC3O83czdtJRgS7qoXRJ4ubFTgQmj1l+f2k9eX+I=;
 b=XdovGjL9bgV48Qf2a1tvn5aoOPjKHRODp1suFT4+fkV0nW6JGmztPJSkJoT0h67NyoCL
 39eXU4MBPkyyAumkxo2kfBWUo5cKREBeqKx1zCUarYPBSsOg7140f++kJgBrx+4D/iVT
 MuSE6CTbLUMKhHh9mHWymcoG2YLp5etGuboVNGhyE4yvcfNuGm0suJM6X8h7vbSocb1s
 KnOFy19wkkzpCAva2t/ApH6wLUPP5Hp1RgXYaEOfVkbMVYEc23w8mzlFy/594h97JnzX
 MN30pBLs5UMyVc2SxOi04yarv3vI//m6behMdGljCaA+0BxuLhU22aGuVy//ak4i/jSk pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ftnckrjrd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 May 2022 19:57:04 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 242JoxVr013181;
        Mon, 2 May 2022 19:57:04 GMT
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ftnckrjr3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 May 2022 19:57:04 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 242Jq9V7001296;
        Mon, 2 May 2022 19:57:03 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma01wdc.us.ibm.com with ESMTP id 3frvr97ekh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 May 2022 19:57:03 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 242Jv2bs26018172
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 2 May 2022 19:57:02 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 689E8BE054;
        Mon,  2 May 2022 19:57:02 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 113AABE04F;
        Mon,  2 May 2022 19:57:01 +0000 (GMT)
Received: from [9.211.144.152] (unknown [9.211.144.152])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon,  2 May 2022 19:57:00 +0000 (GMT)
Message-ID: <8ad9f2c8-9fb8-cb47-fd1e-f9a33eced548@linux.ibm.com>
Date:   Mon, 2 May 2022 15:57:00 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v5 7/9] s390x/pci: enable adapter event notification for
 interpreted devices
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        qemu-s390x@nongnu.org, alex.williamson@redhat.com
Cc:     cohuck@redhat.com, thuth@redhat.com, farman@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com,
        pasic@linux.ibm.com, borntraeger@linux.ibm.com, mst@redhat.com,
        pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20220404181726.60291-1-mjrosato@linux.ibm.com>
 <20220404181726.60291-8-mjrosato@linux.ibm.com>
 <31b5f911-0e1f-ba3c-94f2-1947d5b16057@linux.ibm.com>
 <9a171204-6d71-ee1d-d8bd-cd4eac91c3d5@linux.ibm.com>
 <d14625f4-d648-05d9-38aa-a5ad7e0c9cf5@linux.ibm.com>
 <2df134498bf60e4878bdb362a28c56ec32d902f8.camel@linux.ibm.com>
 <eb2fde35-7b9d-a8c8-3212-ae92b2b3e754@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <eb2fde35-7b9d-a8c8-3212-ae92b2b3e754@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7dygu4fLgW0mVtg-_zWrDgFsDBIrl98F
X-Proofpoint-ORIG-GUID: DIL68uPF0rV0GCxtHd4WM0whwtm_qVvL
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-02_06,2022-05-02_03,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 clxscore=1015 suspectscore=0 malwarescore=0 priorityscore=1501
 adultscore=0 impostorscore=0 spamscore=0 bulkscore=0 lowpriorityscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205020145
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/2/22 7:30 AM, Pierre Morel wrote:
> 
> 
> On 5/2/22 11:19, Niklas Schnelle wrote:
>> On Mon, 2022-05-02 at 09:48 +0200, Pierre Morel wrote:
>>>
>>> On 4/22/22 14:10, Matthew Rosato wrote:
>>>> On 4/22/22 5:39 AM, Pierre Morel wrote:
>>>>>
>>>>> On 4/4/22 20:17, Matthew Rosato wrote:
>>>>>> Use the associated kvm ioctl operation to enable adapter event
>>>>>> notification
>>>>>> and forwarding for devices when requested.  This feature will be 
>>>>>> set up
>>>>>> with or without firmware assist based upon the 'forwarding_assist'
>>>>>> setting.
>>>>>>
>>>>>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>>>>>> ---
>>>>>>    hw/s390x/s390-pci-bus.c         | 20 ++++++++++++++---
>>>>>>    hw/s390x/s390-pci-inst.c        | 40 
>>>>>> +++++++++++++++++++++++++++++++--
>>>>>>    hw/s390x/s390-pci-kvm.c         | 30 +++++++++++++++++++++++++
>>>>>>    include/hw/s390x/s390-pci-bus.h |  1 +
>>>>>>    include/hw/s390x/s390-pci-kvm.h | 14 ++++++++++++
>>>>>>    5 files changed, 100 insertions(+), 5 deletions(-)
>>>>>>
>>>>>> diff --git a/hw/s390x/s390-pci-bus.c b/hw/s390x/s390-pci-bus.c
>>>>>> index 9c02d31250..47918d2ce9 100644
>>>>>> --- a/hw/s390x/s390-pci-bus.c
>>>>>> +++ b/hw/s390x/s390-pci-bus.c
>>>>>> @@ -190,7 +190,10 @@ void s390_pci_sclp_deconfigure(SCCB *sccb)
>>>>>>            rc = SCLP_RC_NO_ACTION_REQUIRED;
>>>>>>            break;
>>>>>>        default:
>>>>>> -        if (pbdev->summary_ind) {
>>>>>> +        if (pbdev->interp && (pbdev->fh & FH_MASK_ENABLE)) {
>>>>>> +            /* Interpreted devices were using interrupt 
>>>>>> forwarding */
>>>>>> +            s390_pci_kvm_aif_disable(pbdev);
>>>>>
>>>>> Same remark as for the kernel part.
>>>>> The VFIO device is already initialized and the action is on this
>>>>> device, Shouldn't we use the VFIO device interface instead of the KVM
>>>>> interface?
>>>>>
>>>>
>>>> I don't necessarily disagree, but in v3 of the kernel series I was told
>>>> not to use VFIO ioctls to accomplish tasks that are unique to KVM (e.g.
>>>> AEN interpretation) and to instead use a KVM ioctl.
>>>>
>>>> VFIO_DEVICE_SET_IRQS won't work as-is for reasons described in the
>>>> kernel series (e.g. we don't see any of the config space notifiers
>>>> because of instruction interpretation) -- as far as I can figure we
>>>> could add our own s390 code to QEMU to issue VFIO_DEVICE_SET_IRQS
>>>> directly for an interpreted device, but I think would also need
>>>> s390-specific changes to VFIO_DEVICE_SET_IRQS accommodate this (e.g.
>>>> maybe something like a VFIO_IRQ_SET_DATA_S390AEN where we can then
>>>> specify the aen information in vfio_irq_set.data -- or something else I
>>>
>>> Hi,
>>>
>>> yes this in VFIO_DEVICE_SET_IRQS is what I think should be done.
>>>
>>>> haven't though of yet) -- I can try to look at this some more and 
>>>> see if
>>>> I get a good idea.
>>>
>>>
>>> I understood that the demand was concerning the IOMMU but I may be 
>>> wrong.

The IOMMU was an issue, but the request to move the ioctl out of vfio to 
kvm was specifically because these ioctl operations were only relevant 
for VMs and are not applicable to vfio uses cases outside of virtualization.

https://lore.kernel.org/kvm/20220208185141.GH4160@nvidia.com/

>>> For my opinion, the handling of AEN is not specific to KVM but specific
>>> to the device, for example the code should be the same if Z ever decide
>>> to use XEN or another hypervizor, except for the GISA part but this part
>>> is already implemented in KVM in a way it can be used from a device like
>>> in VFIO AP.


Fundamentally, these operations are valid only when you have _both_ a 
virtual machine and vfio device.  (Yes, you could swap in a new 
hypervisor with a new GISA implementation, but at the end of it the 
hypervisor must still provide the GISA designation for this to work)

If fh lookup is a concern, one idea that Jason floated was passing the 
vfio device fd as an argument to the kvm ioctl (so pass this down on a 
kvm ioctl from userspace instead of a fh) and then using a new vfio 
external API to get the relevant device from the provided fd.

https://lore.kernel.org/kvm/20220208195117.GI4160@nvidia.com/

>>>
>>> @Alex, what do you think?
>>>
>>> Regards,
>>> Pierre
>>>
>>
>> As I understand it the question isn't if it is specific to KVM but
>> rather if it is specific to virtualization. As vfio-pci is also used
>> for non virtualization purposes such as with DPDK/SPDK or a fully
>> emulating QEMU, it should only be in VFIO if it is relevant for these
>> kinds of user-space PCI accesses too. I'm not an AEN expert but as I
>> understand it, this does forwarding interrupts into a SIE context which
>> only makes sense for virtualization not for general user-space PCI.

Right, AEN forwarding is only relevant for virtual machines.

>>
> 
> Being in VFIO kernel part does not mean that this part should be called 
> from any user of VFIO in userland.
> That is a reason why I did propose an extension and not using the 
> current implementation of VFIO_DEVICE_SET_IRQS as is.
> 
> The reason behind is that the AEN hardware handling is device specific: 
> we need the Function Handle to program AEN.

You also need the GISA designation which is provided by the kvm or you 
also can't program AEN.  So you ultimately need both a function handle 
that is 'owned' by the device (vfio device fd) and the GISA designation 
that is 'owned' by kvm (kvm fd).  So there are 2 different "owning" fds 
involved.

> 
> If the API is through KVM which is device agnostic the implementation in 
> KVM has to search through the system to find the device being handled to 
> apply AEN on it.

See comment above about instead passing the vfio device fd.

> 
> This not the logical way for me and it is a potential source of problems 
> for future extensions.
> 



