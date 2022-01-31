Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 342574A4CC7
	for <lists+kvm@lfdr.de>; Mon, 31 Jan 2022 18:08:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380738AbiAaRIs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jan 2022 12:08:48 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:3270 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1380729AbiAaRIb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 31 Jan 2022 12:08:31 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20VGcPDn003702;
        Mon, 31 Jan 2022 17:08:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=sXr7DsZmWRUCaGjkfti1No9P+yzqHw0Z95+RhnRFZ7k=;
 b=aAMHvk+047o7x5kZYjk6+FQdcEw0vTKr5cUDEXPtGPhfpJpKPDlBbWszJOaorVy0dmI6
 t1x7JkkPDJqeDPkBjkrSGI/WGNxuoCTsePYn0HYdx25Iz54CzyWpY9gqqgQrmDI405UL
 bm+aEmZwZcW19sPd0mYCSrTL7y0oqp7Pa9G+fUiX8bRBKc2YEKZRlQ+js4n0KcogvxC1
 HnqjVAnL4n4b7SZjgOpuN1HMcm0rJr7pIkZOmWFpdObDWT4OyytsfmwpLKvvdU6RJa5b
 mViwA5o/8EDo0dA6R+ZObOHOgWqSvEQlMPkbBHfxrR6etBTwiukfbDtbIGF2hih2dkOQ Gg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dxhm3v1cj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Jan 2022 17:08:24 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20VGjt4J006682;
        Mon, 31 Jan 2022 17:08:24 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dxhm3v1by-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Jan 2022 17:08:23 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20VH8Lal027358;
        Mon, 31 Jan 2022 17:08:23 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma05wdc.us.ibm.com with ESMTP id 3dvw7a7nyp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Jan 2022 17:08:23 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20VH8LJD23527836
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Jan 2022 17:08:21 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AAB8C124054;
        Mon, 31 Jan 2022 17:08:21 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DB1A6124052;
        Mon, 31 Jan 2022 17:08:16 +0000 (GMT)
Received: from [9.211.82.52] (unknown [9.211.82.52])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 31 Jan 2022 17:08:16 +0000 (GMT)
Message-ID: <2f61cca4-58e7-48ca-599c-9489271f6d31@linux.ibm.com>
Date:   Mon, 31 Jan 2022 12:08:15 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 6/9] s390x/pci: enable adapter event notification for
 interpreted devices
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, thuth@redhat.com, farman@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com,
        pasic@linux.ibm.com, borntraeger@linux.ibm.com, mst@redhat.com,
        pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20220114203849.243657-1-mjrosato@linux.ibm.com>
 <20220114203849.243657-7-mjrosato@linux.ibm.com>
 <48b4014f-9a8b-be96-4abf-c9b7d8975386@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <48b4014f-9a8b-be96-4abf-c9b7d8975386@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: cjj9IVVVlDIjD-q2BIdJjjCDZDY8i8Od
X-Proofpoint-GUID: oCLLJ9rgrMfZEl7Ss5WVyDN5NiEQW5Zy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-31_07,2022-01-31_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 lowpriorityscore=0 suspectscore=0 phishscore=0 mlxscore=0
 bulkscore=0 clxscore=1015 impostorscore=0 mlxlogscore=999 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201310111
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/31/22 10:10 AM, Pierre Morel wrote:
> 
> 
> On 1/14/22 21:38, Matthew Rosato wrote:
>> Use the associated vfio feature ioctl to enable adapter event 
>> notification
>> and forwarding for devices when requested.  This feature will be set up
>> with or without firmware assist based upon the 'intassist' setting.
> 
> It is a personal opinion but I do not like the term 'intassist'.
> Why not using 'gisa' ?

Well, I don't think 'gisa' is quite accurate, we're not toggling the 
delivery mechanism here, we're toggling who is responsible for doing the 
delivery (forwarding).  The default (intassist=on) says firmware will do 
it if it can and if not, KVM will be tasked with delivery. 
intassist=off means KVM will always be told to do the delivery.

> I would find it more relevant.
> If something for the profane admin then interrupt_assist or irq_assist 
> or even int_assist.
> 
> Or is it forwarding_assist ?

Yeah, perahps 'forwarding_assist' is the right phrase, as we are 
disabling firmware's ability to assist in the forwarding of guest 
interrupts.

> 
>>
>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> ---
>>   hw/s390x/s390-pci-bus.c          | 24 ++++++++--
>>   hw/s390x/s390-pci-inst.c         | 54 +++++++++++++++++++++-
>>   hw/s390x/s390-pci-vfio.c         | 79 ++++++++++++++++++++++++++++++++
>>   include/hw/s390x/s390-pci-bus.h  |  1 +
>>   include/hw/s390x/s390-pci-vfio.h | 20 ++++++++
>>   5 files changed, 173 insertions(+), 5 deletions(-)
>>
>> diff --git a/hw/s390x/s390-pci-bus.c b/hw/s390x/s390-pci-bus.c
>> index 66649af6e0..6ee70446ca 100644
>> --- a/hw/s390x/s390-pci-bus.c
>> +++ b/hw/s390x/s390-pci-bus.c
>> @@ -189,7 +189,10 @@ void s390_pci_sclp_deconfigure(SCCB *sccb)
>>           rc = SCLP_RC_NO_ACTION_REQUIRED;
>>           break;
>>       default:
>> -        if (pbdev->summary_ind) {
>> +        if (pbdev->interp) {
>> +            /* Interpreted devices were using interrupt forwarding */
>> +            s390_pci_set_aif(pbdev, NULL, false, pbdev->intassist);
>> +        } else if (pbdev->summary_ind) {
>>               pci_dereg_irqs(pbdev);
>>           }
>>           if (pbdev->iommu->enabled) {
>> @@ -981,6 +984,11 @@ static int s390_pci_interp_plug(S390pciState *s, 
>> S390PCIBusDevice *pbdev)
>>           return rc;
>>       }
>> +    rc = s390_pci_probe_aif(pbdev);
>> +    if (rc) {
>> +        return rc;
>> +    }
>> +
>>       rc = s390_pci_update_passthrough_fh(pbdev);
>>       if (rc) {
>>           return rc;
>> @@ -1076,6 +1084,7 @@ static void s390_pcihost_plug(HotplugHandler 
>> *hotplug_dev, DeviceState *dev,
>>               if (pbdev->interp && 
>> !s390_has_feat(S390_FEAT_ZPCI_INTERP)) {
>>                       DPRINTF("zPCI interpretation facilities 
>> missing.\n");
>>                       pbdev->interp = false;
>> +                    pbdev->intassist = false;
>>                   }
>>               if (pbdev->interp) {
>>                   rc = s390_pci_interp_plug(s, pbdev);
>> @@ -1090,11 +1099,13 @@ static void s390_pcihost_plug(HotplugHandler 
>> *hotplug_dev, DeviceState *dev,
>>               if (!pbdev->interp) {
>>                   /* Do vfio passthrough but intercept for I/O */
>>                   pbdev->fh |= FH_SHM_VFIO;
>> +                pbdev->intassist = false;
>>               }
>>           } else {
>>               pbdev->fh |= FH_SHM_EMUL;
>>               /* Always intercept emulated devices */
>>               pbdev->interp = false;
>> +            pbdev->intassist = false;
>>           }
>>           if (s390_pci_msix_init(pbdev) && !pbdev->interp) {
>> @@ -1244,7 +1255,10 @@ static void s390_pcihost_reset(DeviceState *dev)
>>       /* Process all pending unplug requests */
>>       QTAILQ_FOREACH_SAFE(pbdev, &s->zpci_devs, link, next) {
>>           if (pbdev->unplug_requested) {
>> -            if (pbdev->summary_ind) {
>> +            if (pbdev->interp) {
>> +                /* Interpreted devices were using interrupt 
>> forwarding */
>> +                s390_pci_set_aif(pbdev, NULL, false, pbdev->intassist);
>> +            } else if (pbdev->summary_ind) {
>>                   pci_dereg_irqs(pbdev);
>>               }
>>               if (pbdev->iommu->enabled) {
>> @@ -1382,7 +1396,10 @@ static void s390_pci_device_reset(DeviceState 
>> *dev)
>>           break;
>>       }
>> -    if (pbdev->summary_ind) {
>> +    if (pbdev->interp) {
>> +        /* Interpreted devices were using interrupt forwarding */
>> +        s390_pci_set_aif(pbdev, NULL, false, pbdev->intassist);
>> +    } else if (pbdev->summary_ind) {
>>           pci_dereg_irqs(pbdev);
>>       }
>>       if (pbdev->iommu->enabled) {
>> @@ -1428,6 +1445,7 @@ static Property s390_pci_device_properties[] = {
>>       DEFINE_PROP_S390_PCI_FID("fid", S390PCIBusDevice, fid),
>>       DEFINE_PROP_STRING("target", S390PCIBusDevice, target),
>>       DEFINE_PROP_BOOL("interp", S390PCIBusDevice, interp, true),
>> +    DEFINE_PROP_BOOL("intassist", S390PCIBusDevice, intassist, true),
> 
> We allow to disable IRQ forwarding only for test or debug purpose don't we?
> Then shouldn't we make it explicit ?

Not sure I follow.

This setting makes forwarding assist (intassist=on) an implicit default 
which can be subsequently overruled by an explicit 'intassist=off'.

So, the idea is that by default if interpretation is available and 
enabled we will also use the firmware assist to do interrupt forwarding 
-- This is the preferred setup (performance) and nothing needs to be 
explicitly specified.  Explicitly specifying 'intassist=on' does nothing 
additional.

Conversely, if you want to disable the firmware forwarding (for as you 
say a test/debug scenario) only then must you explicitly specify 
'intassist=off'.

Or were you instead suggesting to make the bool a default of false that 
must be explicity set to true?  In that case, it would probably need a 
different name (e.g. implicit default is host_forwarding=off, override 
with host_forwarding=on and only when host_forwarding=on will we force 
host delivery of interrupts)

FWIW, I chose a default of 'true' because I preferred the idea of having 
to specify something negative like 'intassist=off' when forcing host 
delivery as this implies you are turning a feature off (because you are).

> 
>>       DEFINE_PROP_END_OF_LIST(),
>>   };
>> diff --git a/hw/s390x/s390-pci-inst.c b/hw/s390x/s390-pci-inst.c
>> index e9a0dc12e4..121e07cc41 100644
>> --- a/hw/s390x/s390-pci-inst.c
>> +++ b/hw/s390x/s390-pci-inst.c
>> @@ -1111,6 +1111,46 @@ static void fmb_update(void *opaque)
>>       timer_mod(pbdev->fmb_timer, t + pbdev->pci_group->zpci_group.mui);
>>   }
>> +static int mpcifc_reg_int_interp(S390PCIBusDevice *pbdev, ZpciFib *fib)
>> +{
>> +    int rc;
>> +
>> +    /* Interpreted devices must also use interrupt forwarding */
>> +    rc = s390_pci_get_aif(pbdev, false, pbdev->intassist);
>> +    if (rc) {
>> +        DPRINTF("Bad interrupt forwarding state\n");
>> +        return rc;
>> +    }
>> +
>> +    rc = s390_pci_set_aif(pbdev, fib, true, pbdev->intassist);
>> +    if (rc) {
>> +        DPRINTF("Failed to enable interrupt forwarding\n");
>> +        return rc;
>> +    }
>> +
>> +    return 0;
>> +}
>> +
>> +static int mpcifc_dereg_int_interp(S390PCIBusDevice *pbdev, ZpciFib 
>> *fib)
>> +{
>> +    int rc;
>> +
>> +    /* Interpreted devices were using interrupt forwarding */
>> +    rc = s390_pci_get_aif(pbdev, true, pbdev->intassist);
>> +    if (rc) {
>> +        DPRINTF("Bad interrupt forwarding state\n");
>> +        return rc;
>> +    }
>> +
>> +    rc = s390_pci_set_aif(pbdev, fib, false, pbdev->intassist);
>> +    if (rc) {
>> +        DPRINTF("Failed to disable interrupt forwarding\n");
>> +        return rc;
>> +    }
>> +
>> +    return 0;
>> +}
>> +
>>   int mpcifc_service_call(S390CPU *cpu, uint8_t r1, uint64_t fiba, 
>> uint8_t ar,
>>                           uintptr_t ra)
>>   {
>> @@ -1165,7 +1205,12 @@ int mpcifc_service_call(S390CPU *cpu, uint8_t 
>> r1, uint64_t fiba, uint8_t ar,
>>       switch (oc) {
>>       case ZPCI_MOD_FC_REG_INT:
>> -        if (pbdev->summary_ind) {
>> +        if (pbdev->interp) {
>> +            if (mpcifc_reg_int_interp(pbdev, &fib)) {
>> +                cc = ZPCI_PCI_LS_ERR;
>> +                s390_set_status_code(env, r1, ZPCI_MOD_ST_SEQUENCE);
>> +            }
>> +        } else if (pbdev->summary_ind) {
>>               cc = ZPCI_PCI_LS_ERR;
>>               s390_set_status_code(env, r1, ZPCI_MOD_ST_SEQUENCE);
>>           } else if (reg_irqs(env, pbdev, fib)) {
>> @@ -1174,7 +1219,12 @@ int mpcifc_service_call(S390CPU *cpu, uint8_t 
>> r1, uint64_t fiba, uint8_t ar,
>>           }
>>           break;
>>       case ZPCI_MOD_FC_DEREG_INT:
>> -        if (!pbdev->summary_ind) {
>> +        if (pbdev->interp) {
>> +            if (mpcifc_dereg_int_interp(pbdev, &fib)) {
>> +                cc = ZPCI_PCI_LS_ERR;
>> +                s390_set_status_code(env, r1, ZPCI_MOD_ST_SEQUENCE);
>> +            }
>> +        } else if (!pbdev->summary_ind) {
>>               cc = ZPCI_PCI_LS_ERR;
>>               s390_set_status_code(env, r1, ZPCI_MOD_ST_SEQUENCE);
>>           } else {
>> diff --git a/hw/s390x/s390-pci-vfio.c b/hw/s390x/s390-pci-vfio.c
>> index 2cab3a9e89..73f3b3ed19 100644
>> --- a/hw/s390x/s390-pci-vfio.c
>> +++ b/hw/s390x/s390-pci-vfio.c
>> @@ -149,6 +149,85 @@ int 
>> s390_pci_update_passthrough_fh(S390PCIBusDevice *pbdev)
>>       return 0;
>>   }
>> +int s390_pci_probe_aif(S390PCIBusDevice *pbdev)
>> +{
>> +    VFIOPCIDevice *vdev = VFIO_PCI(pbdev->pdev);
>> +    struct vfio_device_feature feat = {
>> +        .argsz = sizeof(struct vfio_device_feature),
>> +        .flags = VFIO_DEVICE_FEATURE_PROBE + 
>> VFIO_DEVICE_FEATURE_ZPCI_AIF
>> +    };
>> +
>> +    return ioctl(vdev->vbasedev.fd, VFIO_DEVICE_FEATURE, &feat);
>> +}
>> +
>> +int s390_pci_set_aif(S390PCIBusDevice *pbdev, ZpciFib *fib, bool enable,
>> +                     bool assist)
>> +{
>> +    VFIOPCIDevice *vdev = VFIO_PCI(pbdev->pdev);
>> +    struct vfio_device_zpci_aif *data;
>> +    int size = sizeof(struct vfio_device_feature) + sizeof(*data);
>> +    g_autofree struct vfio_device_feature *feat = g_malloc0(size);
>> +
>> +    feat->argsz = size;
>> +    feat->flags = VFIO_DEVICE_FEATURE_SET + 
>> VFIO_DEVICE_FEATURE_ZPCI_AIF;
>> +
>> +    data = (struct vfio_device_zpci_aif *)&feat->data;
>> +    if (enable) {
>> +        data->flags = VFIO_DEVICE_ZPCI_FLAG_AIF_FLOAT;
>> +        if (!pbdev->intassist) {
>> +            data->flags |= VFIO_DEVICE_ZPCI_FLAG_AIF_HOST;
>> +        }
>> +        /* Fill in the guest fib info */
>> +        data->ibv = fib->aibv;
>> +        data->sb = fib->aisb;
>> +        data->noi = FIB_DATA_NOI(fib->data);
>> +        data->isc = FIB_DATA_ISC(fib->data);
>> +        data->sbo = FIB_DATA_AISBO(fib->data);
>> +    } else {
>> +        data->flags = 0;
>> +    }
>> +
>> +    return ioctl(vdev->vbasedev.fd, VFIO_DEVICE_FEATURE, feat);
>> +}
>> +
>> +int s390_pci_get_aif(S390PCIBusDevice *pbdev, bool enable, bool assist)
>> +{
>> +    VFIOPCIDevice *vdev = VFIO_PCI(pbdev->pdev);
>> +    struct vfio_device_zpci_aif *data;
>> +    int size = sizeof(struct vfio_device_feature) + sizeof(*data);
>> +    g_autofree struct vfio_device_feature *feat = g_malloc0(size);
>> +    int rc;
>> +
>> +    feat->argsz = size;
>> +    feat->flags = VFIO_DEVICE_FEATURE_GET + 
>> VFIO_DEVICE_FEATURE_ZPCI_AIF;
>> +
>> +    rc = ioctl(vdev->vbasedev.fd, VFIO_DEVICE_FEATURE, feat);
>> +    if (rc) {
>> +        return rc;
>> +    }
>> +
>> +    /* Determine if current interrupt settings match the host */
>> +    data = (struct vfio_device_zpci_aif *)&feat->data;
>> +    if (enable && (!(data->flags & VFIO_DEVICE_ZPCI_FLAG_AIF_FLOAT))) {
>> +        rc = -EINVAL;
>> +    } else if (!enable && (data->flags & 
>> VFIO_DEVICE_ZPCI_FLAG_AIF_FLOAT)) {
>> +        rc = -EINVAL;
>> +    }
>> +
>> +    /*
>> +     * When enabled for interrupts, the assist and forced 
>> host-delivery are
>> +     * mututally exclusive
>> +     */
> 
> assist is unclear for me int_assist , forwarding_assist ?
> 

Yes, my wording here is confusing.  Here, 'enable' is meant to represent 
whether forwarding (AIF) is currently enabled.  And then 'assist' is the 
intassist (forwarding_assist) setting.  And my use of 'mutually 
exclusive' is just plain confusing and should be removed.

I think that otherwise the code is logically correct -- I'll re-visit 
this and change the variable names and/or improve the comments.  To be 
clear, what we are trying to verify here is:

1) if qemu believes AIF is currently disabled, then kernel should also 
show the same (AIF_FLOAT is off)

2) if qemu believes AIF is already enabled, kernel should also show the 
same (AIF_FLOAT is on).  Additionally, if qemu believes host delivery is 
forced (instassist=off) then kernel should also show this (AIF_HOST is on).
This is where my really confusing use of 'mutally exclusive' comes in to 
play -- the AIF_HOST kernel state is an inversion of the QEMU state, so 
the values should never match -- if intassist=off then AIF_HOST should 
be on.  If intassist=on then AIF_HOST should be off.  But really the 
comment should just read that we are ensuring that kernel space 
indicates what we expect for the current state.


