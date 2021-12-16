Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70D8947758D
	for <lists+kvm@lfdr.de>; Thu, 16 Dec 2021 16:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232620AbhLPPQZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Dec 2021 10:16:25 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58102 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230228AbhLPPQY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Dec 2021 10:16:24 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BGE2511018712;
        Thu, 16 Dec 2021 15:16:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=mnp2m9qhM42JOQ6SKSKp5wgLHWXRBxMDM9ya0U7txJs=;
 b=FOi9o9NidnveaFkBtZeOkUgb5D0U2cHk/O1HIskUKWdxo5EYXeGzCG0su+eok3EC2GUS
 AfU+33F5xAPoA0gKnCMgu+ToCRn5B3JSiY8Zx3NmI5NpyFK7qn/FDMN9/t0Zqa1wcUp9
 sWrlZVfDWSAVBLzbIuiMP46rVTGvWKJvL5iPveyIhkZXn+JY8C4bsJmNomqgUG+HAh3f
 0teBrmxCgyTeqfmRAhk9u6x4+OWyIlPem83C7MNbdHu07d0MpAAHccc7q6X8emsCPU7t
 VxAZlni+8WFJapZBf9tT4Q95UwdZE5FSx2rH/Trqhde8NFulk37DVNUh1RCBDsU+7vWH Bg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cyn1k02w9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Dec 2021 15:16:15 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BGEu06X003973;
        Thu, 16 Dec 2021 15:16:15 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cyn1k02vs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Dec 2021 15:16:15 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BGFE4Cb003103;
        Thu, 16 Dec 2021 15:16:14 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma04dal.us.ibm.com with ESMTP id 3cy7hfmw9s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Dec 2021 15:16:14 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BGFGCWV32637420
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Dec 2021 15:16:12 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 568907807C;
        Thu, 16 Dec 2021 15:16:12 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D796778060;
        Thu, 16 Dec 2021 15:16:10 +0000 (GMT)
Received: from [9.211.79.24] (unknown [9.211.79.24])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 16 Dec 2021 15:16:10 +0000 (GMT)
Message-ID: <b445e4e7-21b1-b9bc-3d9f-9f5f94c1d7fa@linux.ibm.com>
Date:   Thu, 16 Dec 2021 10:16:10 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 12/12] s390x/pci: let intercept devices have separate PCI
 groups
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     farman@linux.ibm.com, kvm@vger.kernel.org, schnelle@linux.ibm.com,
        cohuck@redhat.com, richard.henderson@linaro.org, thuth@redhat.com,
        qemu-devel@nongnu.org, pasic@linux.ibm.com,
        alex.williamson@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        david@redhat.com, borntraeger@linux.ibm.com
References: <20211207210425.150923-1-mjrosato@linux.ibm.com>
 <20211207210425.150923-13-mjrosato@linux.ibm.com>
 <599c66a7-6e91-1fd0-ac96-bec7ffe51dfe@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <599c66a7-6e91-1fd0-ac96-bec7ffe51dfe@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: LFSvmGH9jWRHhMN6rYPT3QE6fxfnrQgu
X-Proofpoint-GUID: fcEiz2IWt_2rCBw8Skray-llxBMwgTfV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-16_05,2021-12-16_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 lowpriorityscore=0 priorityscore=1501 impostorscore=0 suspectscore=0
 clxscore=1015 malwarescore=0 spamscore=0 mlxscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112160085
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/16/21 3:15 AM, Pierre Morel wrote:
> 
> 
> On 12/7/21 22:04, Matthew Rosato wrote:
>> Let's use the reserved pool of simulated PCI groups to allow intercept
>> devices to have separate groups from interpreted devices as some group
>> values may be different. If we run out of simulated PCI groups, 
>> subsequent
>> intercept devices just get the default group.
>> Furthermore, if we encounter any PCI groups from hostdevs that are marked
>> as simulated, let's just assign them to the default group to avoid
>> conflicts between host simulated groups and our own simulated groups.
> 
> I have a problem here.
> We will have the same hardware viewed by 2 different VFIO implementation 
> (interpretation vs interception) reporting different groups ID.

Yes -- To be clear, this patch proposes that the interpreted device will 
continue to report the passthrough group ID and the intercept device 
will use a simulated group ID.

> 
> The alternative is to have them reporting same group ID with different 
> values.
>

I don't think we can do this.  For starters, we would have to throw out 
the group tracking we do in QEMU; but for all we know the guest could be 
doing similar tracking -- the implication of the group ID is that 
everyone shares the same values so I don't think we can get away with 
reporting different values for 2 members of the same group.

I think the other alternative is rather to always do something like...

1) host reports its value via vfio capabilities as 'this is what an 
interpreted device can use'
2) QEMU must accept those values as-is OR reduce them to some subset of 
what both interpretation and intercept can support, and report only 
those values for all devices in the group.  (More on this further down)


> I fear both are wrong.
> 
> On the other hand, should we have a difference in the QEMU command line 
> between intercepted and interpreted devices for default values.

I'm not sure I follow what you suggest here.  Even if we somehow 
provided a command-line means for specifying some of these values, they 
would still be presented to the guest via clp and if the guest has 2 
devices in the same group the clp results had better be the same.

> If not why not give up the host values so that in an hypothetical future 
> migration we are clean with the GID ?
> 

Well, the interpreted device will use the passthrough group ID so in a 
hypothetical future migration scenario we should be good there.

And simulated devices will still use the default group, so we should 
also be OK there.

This really changes the behavior for 2 other classes of device:

1) Intercept passthrough devices -- Yes, I agree that doing this is a 
bit weird.  But my thinking was that these devices should be the 
exception case rather than the norm moving forward, and it would clearly 
dilineate the different in Q PCI FNGRP values.

2) nested simulated devices -- These aren't using real GIDs anyway and I 
would expect them to also be using the default group already -- forcing 
these to the default group was basically to make sure they didn't 
conflict with the simulated groups being created for intercept devices 
above.

> I am not sure of this, just want to open a little discussion on this.

FWIW, I'm not 100% on this either, so a better idea is welcome.  One 
thing I don't like, for example, is that we only have 16 simulated 
groups to work with, and for example we might find it useful later to 
split simulated devices into different groups based on type.

> 
> For example what could go wrong to keep the host values returned by the 
> CAP?

As-is, we risk advertising the wrong maxstbl and dtsm value for some 
devices in the group, depending on which device is plugged first. 
Imagine you have 2 devices on group 5; one will be interpreted and the 
other intercepted.

If the interpreted device plugs first, we will use the passthrough 
maxstbl and dtsm for all devices in the group; so the intercept device 
gets these values too.

If the intercept device plugs first, we will use the QEMU value for DTSM 
and the smaller maxstbl requried for intercept passthrough.  So the 
interpreted device gets these values too.

Worth noting, we could have more of these differences later -- But if we 
want to avoid splitting the group, then we I think we have to circle 
back to my 'alternative idea' above and provide equivalent support or 
toleration for intercept devices so that we can report a single group 
value that both types can support.

So insofar as dealing with the differences today...  maxstbl is pretty 
easy, we can just tolerate supporting the larger maxstbl in QEMU by 
adding logic to break up the I/O in pcistb_service_call.  We might have 
to provide 2 different maxstbl values over vfio capabilities however 
(what interpretation can support vs what kernel api supports for 
intercept as this could change between host kernel versions)

DTSM is a little trickier.  We are actually OK today because both 
intercept and interpreted devices will report the same value anyway, but 
that could change in the future.  Maybe here QEMU must report

dtsm = (QEMU_SUPPORT_MASK & HOST_SUPPORT_MASK);

So basically: ensure that only what both QEMU intercept and passthrough 
supports is advertised via the clp.  If we want to support a new type 
later, then we must either support it in both kvm and QEMU to enable it 
for the guest (or disallow intercept devices on that group, or provide 
some means of forcing an intercept device to the default group, etc)

If we do the above, then I think we can drop the idea of using simulated 
groups for intercpet passthrough devices.  What do you think?

> 
> 
>>
>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> ---
>>   hw/s390x/s390-pci-bus.c         | 19 ++++++++++++++--
>>   hw/s390x/s390-pci-vfio.c        | 40 ++++++++++++++++++++++++++++++---
>>   include/hw/s390x/s390-pci-bus.h |  6 ++++-
>>   3 files changed, 59 insertions(+), 6 deletions(-)
>>
>> diff --git a/hw/s390x/s390-pci-bus.c b/hw/s390x/s390-pci-bus.c
>> index ab442f17fb..8b0f3ef120 100644
>> --- a/hw/s390x/s390-pci-bus.c
>> +++ b/hw/s390x/s390-pci-bus.c
>> @@ -747,13 +747,14 @@ static void s390_pci_iommu_free(S390pciState *s, 
>> PCIBus *bus, int32_t devfn)
>>       object_unref(OBJECT(iommu));
>>   }
>> -S390PCIGroup *s390_group_create(int id)
>> +S390PCIGroup *s390_group_create(int id, int host_id)
>>   {
>>       S390PCIGroup *group;
>>       S390pciState *s = s390_get_phb();
>>       group = g_new0(S390PCIGroup, 1);
>>       group->id = id;
>> +    group->host_id = host_id;
>>       QTAILQ_INSERT_TAIL(&s->zpci_groups, group, link);
>>       return group;
>>   }
>> @@ -771,12 +772,25 @@ S390PCIGroup *s390_group_find(int id)
>>       return NULL;
>>   }
>> +S390PCIGroup *s390_group_find_host_sim(int host_id)
>> +{
>> +    S390PCIGroup *group;
>> +    S390pciState *s = s390_get_phb();
>> +
>> +    QTAILQ_FOREACH(group, &s->zpci_groups, link) {
>> +        if (group->id >= ZPCI_SIM_GRP_START && group->host_id == 
>> host_id) {
>> +            return group;
>> +        }
>> +    }
>> +    return NULL;
>> +}
>> +
>>   static void s390_pci_init_default_group(void)
>>   {
>>       S390PCIGroup *group;
>>       ClpRspQueryPciGrp *resgrp;
>> -    group = s390_group_create(ZPCI_DEFAULT_FN_GRP);
>> +    group = s390_group_create(ZPCI_DEFAULT_FN_GRP, ZPCI_DEFAULT_FN_GRP);
>>       resgrp = &group->zpci_group;
>>       resgrp->fr = 1;
>>       resgrp->dasm = 0;
>> @@ -824,6 +838,7 @@ static void s390_pcihost_realize(DeviceState *dev, 
>> Error **errp)
>>                                              NULL, g_free);
>>       s->zpci_table = g_hash_table_new_full(g_int_hash, g_int_equal, 
>> NULL, NULL);
>>       s->bus_no = 0;
>> +    s->next_sim_grp = ZPCI_SIM_GRP_START;
>>       QTAILQ_INIT(&s->pending_sei);
>>       QTAILQ_INIT(&s->zpci_devs);
>>       QTAILQ_INIT(&s->zpci_dma_limit);
>> diff --git a/hw/s390x/s390-pci-vfio.c b/hw/s390x/s390-pci-vfio.c
>> index c9269683f5..bdc5892287 100644
>> --- a/hw/s390x/s390-pci-vfio.c
>> +++ b/hw/s390x/s390-pci-vfio.c
>> @@ -305,13 +305,17 @@ static void s390_pci_read_group(S390PCIBusDevice 
>> *pbdev,
>>   {
>>       struct vfio_info_cap_header *hdr;
>>       struct vfio_device_info_cap_zpci_group *cap;
>> +    S390pciState *s = s390_get_phb();
>>       ClpRspQueryPciGrp *resgrp;
>>       VFIOPCIDevice *vpci =  container_of(pbdev->pdev, VFIOPCIDevice, 
>> pdev);
>>       hdr = vfio_get_device_info_cap(info, 
>> VFIO_DEVICE_INFO_CAP_ZPCI_GROUP);
>> -    /* If capability not provided, just use the default group */
>> -    if (hdr == NULL) {
>> +    /*
>> +     * If capability not provided or the underlying hostdev is 
>> simulated, just
>> +     * use the default group.
>> +     */
>> +    if (hdr == NULL || pbdev->zpci_fn.pfgid >= ZPCI_SIM_GRP_START) {
>>           trace_s390_pci_clp_cap(vpci->vbasedev.name,
>>                                  VFIO_DEVICE_INFO_CAP_ZPCI_GROUP);
>>           pbdev->zpci_fn.pfgid = ZPCI_DEFAULT_FN_GRP;
>> @@ -320,11 +324,41 @@ static void s390_pci_read_group(S390PCIBusDevice 
>> *pbdev,
>>       }
>>       cap = (void *) hdr;
>> +    /*
>> +     * For an intercept device, let's use an existing simulated group 
>> if one
>> +     * one was already created for other intercept devices in this 
>> group.
>> +     * If not, create a new simulated group if any are still available.
>> +     * If all else fails, just fall back on the default group.
>> +     */
>> +    if (!pbdev->interp) {
>> +        pbdev->pci_group = 
>> s390_group_find_host_sim(pbdev->zpci_fn.pfgid);
>> +        if (pbdev->pci_group) {
>> +            /* Use existing simulated group */
>> +            pbdev->zpci_fn.pfgid = pbdev->pci_group->id;
>> +            return;
>> +        } else {
>> +            if (s->next_sim_grp == ZPCI_DEFAULT_FN_GRP) {
>> +                /* All out of simulated groups, use default */
>> +                trace_s390_pci_clp_cap(vpci->vbasedev.name,
>> +                                       VFIO_DEVICE_INFO_CAP_ZPCI_GROUP);
>> +                pbdev->zpci_fn.pfgid = ZPCI_DEFAULT_FN_GRP;
>> +                pbdev->pci_group = s390_group_find(ZPCI_DEFAULT_FN_GRP);
>> +                return;
>> +            } else {
>> +                /* We can assign a new simulated group */
>> +                pbdev->zpci_fn.pfgid = s->next_sim_grp;
>> +                s->next_sim_grp++;
>> +                /* Fall through to create the new sim group using CLP 
>> info */
>> +            }
>> +        }
>> +    }
>> +
>>       /* See if the PCI group is already defined, create if not */
>>       pbdev->pci_group = s390_group_find(pbdev->zpci_fn.pfgid);
>>       if (!pbdev->pci_group) {
>> -        pbdev->pci_group = s390_group_create(pbdev->zpci_fn.pfgid);
>> +        pbdev->pci_group = s390_group_create(pbdev->zpci_fn.pfgid,
>> +                                             pbdev->zpci_fn.pfgid);
>>           resgrp = &pbdev->pci_group->zpci_group;
>>           if (cap->flags & VFIO_DEVICE_INFO_ZPCI_FLAG_REFRESH) {
>> diff --git a/include/hw/s390x/s390-pci-bus.h 
>> b/include/hw/s390x/s390-pci-bus.h
>> index 9941ca0084..8664023d5d 100644
>> --- a/include/hw/s390x/s390-pci-bus.h
>> +++ b/include/hw/s390x/s390-pci-bus.h
>> @@ -315,13 +315,16 @@ typedef struct ZpciFmb {
>>   QEMU_BUILD_BUG_MSG(offsetof(ZpciFmb, fmt0) != 48, "padding in 
>> ZpciFmb");
>>   #define ZPCI_DEFAULT_FN_GRP 0xFF
>> +#define ZPCI_SIM_GRP_START 0xF0
>>   typedef struct S390PCIGroup {
>>       ClpRspQueryPciGrp zpci_group;
>>       int id;
>> +    int host_id;
>>       QTAILQ_ENTRY(S390PCIGroup) link;
>>   } S390PCIGroup;
>> -S390PCIGroup *s390_group_create(int id);
>> +S390PCIGroup *s390_group_create(int id, int host_id);
>>   S390PCIGroup *s390_group_find(int id);
>> +S390PCIGroup *s390_group_find_host_sim(int host_id);
>>   struct S390PCIBusDevice {
>>       DeviceState qdev;
>> @@ -370,6 +373,7 @@ struct S390pciState {
>>       QTAILQ_HEAD(, S390PCIBusDevice) zpci_devs;
>>       QTAILQ_HEAD(, S390PCIDMACount) zpci_dma_limit;
>>       QTAILQ_HEAD(, S390PCIGroup) zpci_groups;
>> +    uint8_t next_sim_grp;
>>   };
>>   S390pciState *s390_get_phb(void);
>>
> 

