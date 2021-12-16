Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 350A9476BAB
	for <lists+kvm@lfdr.de>; Thu, 16 Dec 2021 09:14:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232333AbhLPIOY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Dec 2021 03:14:24 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51712 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229590AbhLPIOX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Dec 2021 03:14:23 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BG8371V029512;
        Thu, 16 Dec 2021 08:14:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=LJBU2VBOjf4S1fwpzrDp3Juat/KSk3aHWv7XOMKV4hc=;
 b=tjujOh4njLisMsjQIkk0lDOK12qYlF4QWozunDGsn/mR8XJUGM1rDpjlOKE9uaGkiCoY
 jl0sUET2bnC2OGvwZk2uvB6cFvhB5xwhHhEg9BpIVkCO1j1hXQJclweZlC8YRlOnxLby
 rTaOXbXfqVV5TnwnAd1PBao1I8onomPLfYHNJAyABqRgQnFM0HchQEgPRixSokXjo5Zt
 6vAVcsQ9vIYQQTkntV/cKiPbuEEydBcKpg2Bg8z56uWfOL1/S5ojoEwr/bztdSL7WT8g
 R2rEfS4J7ONvT2OV3n9TNlRXPs96UJBUt3H8dp+ck6g3+9DHt7XAZL/PKpJiNQA0QzRQ lw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cyqbhunxe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Dec 2021 08:14:16 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BG88hwP021540;
        Thu, 16 Dec 2021 08:14:16 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cyqbhunwj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Dec 2021 08:14:15 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BG8BoTg011714;
        Thu, 16 Dec 2021 08:14:13 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3cy7qw45ru-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Dec 2021 08:14:13 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BG8EAuu46465458
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Dec 2021 08:14:10 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E3ECCAE064;
        Thu, 16 Dec 2021 08:14:09 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2E62DAE053;
        Thu, 16 Dec 2021 08:14:09 +0000 (GMT)
Received: from [9.171.32.185] (unknown [9.171.32.185])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 16 Dec 2021 08:14:09 +0000 (GMT)
Message-ID: <599c66a7-6e91-1fd0-ac96-bec7ffe51dfe@linux.ibm.com>
Date:   Thu, 16 Dec 2021 09:15:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 12/12] s390x/pci: let intercept devices have separate PCI
 groups
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     farman@linux.ibm.com, kvm@vger.kernel.org, schnelle@linux.ibm.com,
        cohuck@redhat.com, richard.henderson@linaro.org, thuth@redhat.com,
        qemu-devel@nongnu.org, pasic@linux.ibm.com,
        alex.williamson@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        david@redhat.com, borntraeger@linux.ibm.com
References: <20211207210425.150923-1-mjrosato@linux.ibm.com>
 <20211207210425.150923-13-mjrosato@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20211207210425.150923-13-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CTDqrP4tv1EZ28EQ-U8Ko6RRmjWsarxN
X-Proofpoint-ORIG-GUID: V7Vg9WkPVcipg3u_KgNed2L_j0NL_B9Y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-16_02,2021-12-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 malwarescore=0 bulkscore=0 mlxlogscore=999 impostorscore=0
 lowpriorityscore=0 suspectscore=0 phishscore=0 spamscore=0
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2112160041
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/7/21 22:04, Matthew Rosato wrote:
> Let's use the reserved pool of simulated PCI groups to allow intercept
> devices to have separate groups from interpreted devices as some group
> values may be different. If we run out of simulated PCI groups, subsequent
> intercept devices just get the default group.
> Furthermore, if we encounter any PCI groups from hostdevs that are marked
> as simulated, let's just assign them to the default group to avoid
> conflicts between host simulated groups and our own simulated groups.

I have a problem here.
We will have the same hardware viewed by 2 different VFIO implementation 
(interpretation vs interception) reporting different groups ID.

The alternative is to have them reporting same group ID with different 
values.

I fear both are wrong.

On the other hand, should we have a difference in the QEMU command line 
between intercepted and interpreted devices for default values.
If not why not give up the host values so that in an hypothetical future 
migration we are clean with the GID ?

I am not sure of this, just want to open a little discussion on this.

For example what could go wrong to keep the host values returned by the CAP?


> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   hw/s390x/s390-pci-bus.c         | 19 ++++++++++++++--
>   hw/s390x/s390-pci-vfio.c        | 40 ++++++++++++++++++++++++++++++---
>   include/hw/s390x/s390-pci-bus.h |  6 ++++-
>   3 files changed, 59 insertions(+), 6 deletions(-)
> 
> diff --git a/hw/s390x/s390-pci-bus.c b/hw/s390x/s390-pci-bus.c
> index ab442f17fb..8b0f3ef120 100644
> --- a/hw/s390x/s390-pci-bus.c
> +++ b/hw/s390x/s390-pci-bus.c
> @@ -747,13 +747,14 @@ static void s390_pci_iommu_free(S390pciState *s, PCIBus *bus, int32_t devfn)
>       object_unref(OBJECT(iommu));
>   }
>   
> -S390PCIGroup *s390_group_create(int id)
> +S390PCIGroup *s390_group_create(int id, int host_id)
>   {
>       S390PCIGroup *group;
>       S390pciState *s = s390_get_phb();
>   
>       group = g_new0(S390PCIGroup, 1);
>       group->id = id;
> +    group->host_id = host_id;
>       QTAILQ_INSERT_TAIL(&s->zpci_groups, group, link);
>       return group;
>   }
> @@ -771,12 +772,25 @@ S390PCIGroup *s390_group_find(int id)
>       return NULL;
>   }
>   
> +S390PCIGroup *s390_group_find_host_sim(int host_id)
> +{
> +    S390PCIGroup *group;
> +    S390pciState *s = s390_get_phb();
> +
> +    QTAILQ_FOREACH(group, &s->zpci_groups, link) {
> +        if (group->id >= ZPCI_SIM_GRP_START && group->host_id == host_id) {
> +            return group;
> +        }
> +    }
> +    return NULL;
> +}
> +
>   static void s390_pci_init_default_group(void)
>   {
>       S390PCIGroup *group;
>       ClpRspQueryPciGrp *resgrp;
>   
> -    group = s390_group_create(ZPCI_DEFAULT_FN_GRP);
> +    group = s390_group_create(ZPCI_DEFAULT_FN_GRP, ZPCI_DEFAULT_FN_GRP);
>       resgrp = &group->zpci_group;
>       resgrp->fr = 1;
>       resgrp->dasm = 0;
> @@ -824,6 +838,7 @@ static void s390_pcihost_realize(DeviceState *dev, Error **errp)
>                                              NULL, g_free);
>       s->zpci_table = g_hash_table_new_full(g_int_hash, g_int_equal, NULL, NULL);
>       s->bus_no = 0;
> +    s->next_sim_grp = ZPCI_SIM_GRP_START;
>       QTAILQ_INIT(&s->pending_sei);
>       QTAILQ_INIT(&s->zpci_devs);
>       QTAILQ_INIT(&s->zpci_dma_limit);
> diff --git a/hw/s390x/s390-pci-vfio.c b/hw/s390x/s390-pci-vfio.c
> index c9269683f5..bdc5892287 100644
> --- a/hw/s390x/s390-pci-vfio.c
> +++ b/hw/s390x/s390-pci-vfio.c
> @@ -305,13 +305,17 @@ static void s390_pci_read_group(S390PCIBusDevice *pbdev,
>   {
>       struct vfio_info_cap_header *hdr;
>       struct vfio_device_info_cap_zpci_group *cap;
> +    S390pciState *s = s390_get_phb();
>       ClpRspQueryPciGrp *resgrp;
>       VFIOPCIDevice *vpci =  container_of(pbdev->pdev, VFIOPCIDevice, pdev);
>   
>       hdr = vfio_get_device_info_cap(info, VFIO_DEVICE_INFO_CAP_ZPCI_GROUP);
>   
> -    /* If capability not provided, just use the default group */
> -    if (hdr == NULL) {
> +    /*
> +     * If capability not provided or the underlying hostdev is simulated, just
> +     * use the default group.
> +     */
> +    if (hdr == NULL || pbdev->zpci_fn.pfgid >= ZPCI_SIM_GRP_START) {
>           trace_s390_pci_clp_cap(vpci->vbasedev.name,
>                                  VFIO_DEVICE_INFO_CAP_ZPCI_GROUP);
>           pbdev->zpci_fn.pfgid = ZPCI_DEFAULT_FN_GRP;
> @@ -320,11 +324,41 @@ static void s390_pci_read_group(S390PCIBusDevice *pbdev,
>       }
>       cap = (void *) hdr;
>   
> +    /*
> +     * For an intercept device, let's use an existing simulated group if one
> +     * one was already created for other intercept devices in this group.
> +     * If not, create a new simulated group if any are still available.
> +     * If all else fails, just fall back on the default group.
> +     */
> +    if (!pbdev->interp) {
> +        pbdev->pci_group = s390_group_find_host_sim(pbdev->zpci_fn.pfgid);
> +        if (pbdev->pci_group) {
> +            /* Use existing simulated group */
> +            pbdev->zpci_fn.pfgid = pbdev->pci_group->id;
> +            return;
> +        } else {
> +            if (s->next_sim_grp == ZPCI_DEFAULT_FN_GRP) {
> +                /* All out of simulated groups, use default */
> +                trace_s390_pci_clp_cap(vpci->vbasedev.name,
> +                                       VFIO_DEVICE_INFO_CAP_ZPCI_GROUP);
> +                pbdev->zpci_fn.pfgid = ZPCI_DEFAULT_FN_GRP;
> +                pbdev->pci_group = s390_group_find(ZPCI_DEFAULT_FN_GRP);
> +                return;
> +            } else {
> +                /* We can assign a new simulated group */
> +                pbdev->zpci_fn.pfgid = s->next_sim_grp;
> +                s->next_sim_grp++;
> +                /* Fall through to create the new sim group using CLP info */
> +            }
> +        }
> +    }
> +
>       /* See if the PCI group is already defined, create if not */
>       pbdev->pci_group = s390_group_find(pbdev->zpci_fn.pfgid);
>   
>       if (!pbdev->pci_group) {
> -        pbdev->pci_group = s390_group_create(pbdev->zpci_fn.pfgid);
> +        pbdev->pci_group = s390_group_create(pbdev->zpci_fn.pfgid,
> +                                             pbdev->zpci_fn.pfgid);
>   
>           resgrp = &pbdev->pci_group->zpci_group;
>           if (cap->flags & VFIO_DEVICE_INFO_ZPCI_FLAG_REFRESH) {
> diff --git a/include/hw/s390x/s390-pci-bus.h b/include/hw/s390x/s390-pci-bus.h
> index 9941ca0084..8664023d5d 100644
> --- a/include/hw/s390x/s390-pci-bus.h
> +++ b/include/hw/s390x/s390-pci-bus.h
> @@ -315,13 +315,16 @@ typedef struct ZpciFmb {
>   QEMU_BUILD_BUG_MSG(offsetof(ZpciFmb, fmt0) != 48, "padding in ZpciFmb");
>   
>   #define ZPCI_DEFAULT_FN_GRP 0xFF
> +#define ZPCI_SIM_GRP_START 0xF0
>   typedef struct S390PCIGroup {
>       ClpRspQueryPciGrp zpci_group;
>       int id;
> +    int host_id;
>       QTAILQ_ENTRY(S390PCIGroup) link;
>   } S390PCIGroup;
> -S390PCIGroup *s390_group_create(int id);
> +S390PCIGroup *s390_group_create(int id, int host_id);
>   S390PCIGroup *s390_group_find(int id);
> +S390PCIGroup *s390_group_find_host_sim(int host_id);
>   
>   struct S390PCIBusDevice {
>       DeviceState qdev;
> @@ -370,6 +373,7 @@ struct S390pciState {
>       QTAILQ_HEAD(, S390PCIBusDevice) zpci_devs;
>       QTAILQ_HEAD(, S390PCIDMACount) zpci_dma_limit;
>       QTAILQ_HEAD(, S390PCIGroup) zpci_groups;
> +    uint8_t next_sim_grp;
>   };
>   
>   S390pciState *s390_get_phb(void);
> 

-- 
Pierre Morel
IBM Lab Boeblingen
