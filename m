Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7D14A499F
	for <lists+kvm@lfdr.de>; Mon, 31 Jan 2022 15:46:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236725AbiAaOqi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jan 2022 09:46:38 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21888 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235984AbiAaOqh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 31 Jan 2022 09:46:37 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20VDWLdS030817;
        Mon, 31 Jan 2022 14:44:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=8H210n/nMxyMX/OTzS0e7OdMB03iBoR4fyZMAj1j3xA=;
 b=fI2qh/b5Bvbi7VlbQ8k1w/Uhd+P1A/XamX14Y1G5c3Ttmrg1bXlycO+8mAW/7dP/zzcf
 ssDXf/HgxhnFIoFYZwMOWxvXSsznephlp/J60xpMUnSmNW6v9XZehcM2WVMzTXJn1Ed5
 Drxj6bCHiFr/6LP7EVPtgXehftoNBEsZrY5msfF0I8jBJqhW7NN3hn6Uaf4lFDYdEM//
 ZwBzBFNXXAk9ByhlAf4xE0oRdVxvAU4tMSqZEAJJ688JRed+1KMP1bVuWqI89gfcBVrW
 8+0SW3SVEyIDV+A+zZ1TmNXf76NiMc1butBXJBGSbdRrMO7IvCf2huvgMghu1SLXed0a zQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dxgr69m33-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Jan 2022 14:44:46 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20VELo3O013674;
        Mon, 31 Jan 2022 14:44:46 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dxgr69m2b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Jan 2022 14:44:46 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20VEgBtL030209;
        Mon, 31 Jan 2022 14:44:44 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3dvw79ch9m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Jan 2022 14:44:44 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20VEideH46924150
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Jan 2022 14:44:39 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B2E6CAE057;
        Mon, 31 Jan 2022 14:44:39 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E1184AE051;
        Mon, 31 Jan 2022 14:44:38 +0000 (GMT)
Received: from [9.171.84.74] (unknown [9.171.84.74])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 31 Jan 2022 14:44:38 +0000 (GMT)
Message-ID: <799e6d4c-57f4-c321-4c96-d6186cfb3136@linux.ibm.com>
Date:   Mon, 31 Jan 2022 15:46:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v2 4/9] s390x/pci: enable for load/store intepretation
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     farman@linux.ibm.com, kvm@vger.kernel.org, schnelle@linux.ibm.com,
        cohuck@redhat.com, richard.henderson@linaro.org, thuth@redhat.com,
        qemu-devel@nongnu.org, pasic@linux.ibm.com,
        alex.williamson@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        david@redhat.com, borntraeger@linux.ibm.com
References: <20220114203849.243657-1-mjrosato@linux.ibm.com>
 <20220114203849.243657-5-mjrosato@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20220114203849.243657-5-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: GpdItj6yBkjBq2cn50kR8eE4ZKSHScTQ
X-Proofpoint-ORIG-GUID: zy4sNk5hte7DsE7d6WU0n1c9WBzJeWqP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-31_06,2022-01-31_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 priorityscore=1501 mlxlogscore=999 suspectscore=0
 phishscore=0 clxscore=1015 adultscore=0 impostorscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201310097
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/14/22 21:38, Matthew Rosato wrote:
> Use the associated vfio feature ioctl to enable interpretation for devices
> when requested.  As part of this process, we must use the host function
> handle rather than a QEMU-generated one -- this is provided as part of the
> ioctl payload.

I wonder if we should not explain here that having interpretation as a 
default and silently fall back to interception allows backward 
compatibility while allowing performence be chosing by default.
(You can say it better as I do :) )


> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   hw/s390x/s390-pci-bus.c          | 70 +++++++++++++++++++++++++++++++-
>   hw/s390x/s390-pci-inst.c         | 63 +++++++++++++++++++++++++++-
>   hw/s390x/s390-pci-vfio.c         | 52 ++++++++++++++++++++++++
>   include/hw/s390x/s390-pci-bus.h  |  1 +
>   include/hw/s390x/s390-pci-vfio.h | 15 +++++++
>   5 files changed, 199 insertions(+), 2 deletions(-)
> 
> diff --git a/hw/s390x/s390-pci-bus.c b/hw/s390x/s390-pci-bus.c
> index 01b58ebc70..a39ccfee05 100644
> --- a/hw/s390x/s390-pci-bus.c
> +++ b/hw/s390x/s390-pci-bus.c
> @@ -971,12 +971,58 @@ static void s390_pci_update_subordinate(PCIDevice *dev, uint32_t nr)
>       }
>   }
>   
> +static int s390_pci_interp_plug(S390pciState *s, S390PCIBusDevice *pbdev)
> +{
> +    uint32_t idx;
> +    int rc;
> +
> +    rc = s390_pci_probe_interp(pbdev);
> +    if (rc) {
> +        return rc;
> +    }
> +
> +    rc = s390_pci_update_passthrough_fh(pbdev);
> +    if (rc) {
> +        return rc;
> +    }
> +
> +    /*
> +     * The host device is already in an enabled state, but we always present
> +     * the initial device state to the guest as disabled (ZPCI_FS_DISABLED).
> +     * Therefore, mask off the enable bit from the passthrough handle until
> +     * the guest issues a CLP SET PCI FN later to enable the device.
> +     */
> +    pbdev->fh &= ~FH_MASK_ENABLE;
> +
> +    /* Next, see if the idx is already in-use */
> +    idx = pbdev->fh & FH_MASK_INDEX;
> +    if (pbdev->idx != idx) {
> +        if (s390_pci_find_dev_by_idx(s, idx)) {
> +            return -EINVAL;
> +        }
> +        /*
> +         * Update the idx entry with the passed through idx
> +         * If the relinquished idx is lower than next_idx, use it
> +         * to replace next_idx
> +         */
> +        g_hash_table_remove(s->zpci_table, &pbdev->idx);
> +        if (idx < s->next_idx) {
> +            s->next_idx = idx;
> +        }
> +        pbdev->idx = idx;
> +        g_hash_table_insert(s->zpci_table, &pbdev->idx, pbdev);
> +    }
> +
> +    return 0;
> +}
> +
>   static void s390_pcihost_plug(HotplugHandler *hotplug_dev, DeviceState *dev,
>                                 Error **errp)
>   {
>       S390pciState *s = S390_PCI_HOST_BRIDGE(hotplug_dev);
>       PCIDevice *pdev = NULL;
>       S390PCIBusDevice *pbdev = NULL;
> +    int rc;
>   
>       if (object_dynamic_cast(OBJECT(dev), TYPE_PCI_BRIDGE)) {
>           PCIBridge *pb = PCI_BRIDGE(dev);
> @@ -1022,12 +1068,33 @@ static void s390_pcihost_plug(HotplugHandler *hotplug_dev, DeviceState *dev,
>           set_pbdev_info(pbdev);
>   
>           if (object_dynamic_cast(OBJECT(dev), "vfio-pci")) {
> -            pbdev->fh |= FH_SHM_VFIO;
> +            /*
> +             * By default, interpretation is always requested; if the available
> +             * facilities indicate it is not available, fallback to the
> +             * intercept model.

s/intercept/interception/ ?

> +             */
> +            if (pbdev->interp && !s390_has_feat(S390_FEAT_ZPCI_INTERP)) {
> +                    DPRINTF("zPCI interpretation facilities missing.\n");
> +                    pbdev->interp = false;
> +                }
> +            if (pbdev->interp) {
> +                rc = s390_pci_interp_plug(s, pbdev);
> +                if (rc) {
> +                    error_setg(errp, "zpci interp plug failed: %d", rc);
> +                    return;
> +                }
> +            }


Can't we rearrange that as
if (pbdev->interp) {
     if (s390_has_feat) {
     } else {
     }
}


>               pbdev->iommu->dma_limit = s390_pci_start_dma_count(s, pbdev);
>               /* Fill in CLP information passed via the vfio region */
>               s390_pci_get_clp_info(pbdev);
> +            if (!pbdev->interp) {
> +                /* Do vfio passthrough but intercept for I/O */
> +                pbdev->fh |= FH_SHM_VFIO;
> +            }
>           } else {
>               pbdev->fh |= FH_SHM_EMUL;
> +            /* Always intercept emulated devices */
> +            pbdev->interp = false;
>           }
>   
>           if (s390_pci_msix_init(pbdev)) {
> @@ -1360,6 +1427,7 @@ static Property s390_pci_device_properties[] = {
>       DEFINE_PROP_UINT16("uid", S390PCIBusDevice, uid, UID_UNDEFINED),
>       DEFINE_PROP_S390_PCI_FID("fid", S390PCIBusDevice, fid),
>       DEFINE_PROP_STRING("target", S390PCIBusDevice, target),
> +    DEFINE_PROP_BOOL("interp", S390PCIBusDevice, interp, true),
>       DEFINE_PROP_END_OF_LIST(),
>   };
>   
> diff --git a/hw/s390x/s390-pci-inst.c b/hw/s390x/s390-pci-inst.c
> index 6d400d4147..e9a0dc12e4 100644
> --- a/hw/s390x/s390-pci-inst.c
> +++ b/hw/s390x/s390-pci-inst.c
> @@ -18,6 +18,7 @@
>   #include "sysemu/hw_accel.h"
>   #include "hw/s390x/s390-pci-inst.h"
>   #include "hw/s390x/s390-pci-bus.h"
> +#include "hw/s390x/s390-pci-vfio.h"
>   #include "hw/s390x/tod.h"
>   
>   #ifndef DEBUG_S390PCI_INST
> @@ -156,6 +157,47 @@ out:
>       return rc;
>   }
>   
> +static int clp_enable_interp(S390PCIBusDevice *pbdev)
> +{
> +    int rc;
> +
> +    rc = s390_pci_set_interp(pbdev, true);
> +    if (rc) {
> +        DPRINTF("Failed to enable interpretation\n");
> +        return rc;
> +    }
> +    rc = s390_pci_update_passthrough_fh(pbdev);
> +    if (rc) {
> +        DPRINTF("Failed to update passthrough fh\n");
> +        return rc;
> +    }
> +    if (!(pbdev->fh & FH_MASK_ENABLE)) {
> +        DPRINTF("Passthrough handle is not enabled\n");
> +        return -EINVAL;
> +    }
> +
> +    return 0;
> +}
> +
> +static int clp_disable_interp(S390PCIBusDevice *pbdev)
> +{
> +    int rc;
> +
> +    rc = s390_pci_set_interp(pbdev, false);
> +    if (rc) {
> +        DPRINTF("Failed to disable interpretation\n");
> +        return rc;
> +    }
> +
> +    rc = s390_pci_update_passthrough_fh(pbdev);
> +    if (rc) {
> +        DPRINTF("Failed to update passthrough fh\n");
> +        return rc;
> +    }
> +
> +    return 0;
> +}
> +
>   int clp_service_call(S390CPU *cpu, uint8_t r2, uintptr_t ra)
>   {
>       ClpReqHdr *reqh;
> @@ -246,7 +288,19 @@ int clp_service_call(S390CPU *cpu, uint8_t r2, uintptr_t ra)
>                   goto out;
>               }
>   
> -            pbdev->fh |= FH_MASK_ENABLE;
> +            /*
> +             * If interpretation is specified, attempt to enable this now and
> +             * update with the host fh
> +             */
> +            if (pbdev->interp) {
> +                if (clp_enable_interp(pbdev)) {
> +                    stw_p(&ressetpci->hdr.rsp, CLP_RC_SETPCIFN_ERR);
> +                    goto out;
> +                }
> +            } else {
> +                pbdev->fh |= FH_MASK_ENABLE;
> +            }
> +
>               pbdev->state = ZPCI_FS_ENABLED;
>               stl_p(&ressetpci->fh, pbdev->fh);
>               stw_p(&ressetpci->hdr.rsp, CLP_RC_OK);
> @@ -257,6 +311,13 @@ int clp_service_call(S390CPU *cpu, uint8_t r2, uintptr_t ra)
>                   goto out;
>               }
>               device_legacy_reset(DEVICE(pbdev));
> +            if (pbdev->interp) {
> +                if (clp_disable_interp(pbdev)) {
> +                    stw_p(&ressetpci->hdr.rsp, CLP_RC_SETPCIFN_ERR);
> +                    goto out;
> +                }
> +            }
> +            /* Mask off the enabled bit for interpreted devices too */
>               pbdev->fh &= ~FH_MASK_ENABLE;
>               pbdev->state = ZPCI_FS_DISABLED;
>               stl_p(&ressetpci->fh, pbdev->fh);
> diff --git a/hw/s390x/s390-pci-vfio.c b/hw/s390x/s390-pci-vfio.c
> index 6f80a47e29..2cab3a9e89 100644
> --- a/hw/s390x/s390-pci-vfio.c
> +++ b/hw/s390x/s390-pci-vfio.c
> @@ -97,6 +97,58 @@ void s390_pci_end_dma_count(S390pciState *s, S390PCIDMACount *cnt)
>       }
>   }
>   
> +int s390_pci_probe_interp(S390PCIBusDevice *pbdev)
> +{
> +    VFIOPCIDevice *vdev = VFIO_PCI(pbdev->pdev);
> +    struct vfio_device_feature feat = {
> +        .argsz = sizeof(struct vfio_device_feature),
> +        .flags = VFIO_DEVICE_FEATURE_PROBE | VFIO_DEVICE_FEATURE_ZPCI_INTERP
> +    };
> +
> +    return ioctl(vdev->vbasedev.fd, VFIO_DEVICE_FEATURE, &feat);
> +}
> +
> +int s390_pci_set_interp(S390PCIBusDevice *pbdev, bool enable)
> +{
> +    VFIOPCIDevice *vdev = VFIO_PCI(pbdev->pdev);
> +    struct vfio_device_zpci_interp *data;
> +    int size = sizeof(struct vfio_device_feature) + sizeof(*data);
> +    g_autofree struct vfio_device_feature *feat = g_malloc0(size);
> +
> +    feat->argsz = size;
> +    feat->flags = VFIO_DEVICE_FEATURE_SET + VFIO_DEVICE_FEATURE_ZPCI_INTERP;
> +
> +    data = (struct vfio_device_zpci_interp *)&feat->data;
> +    if (enable) {
> +        data->flags = VFIO_DEVICE_ZPCI_FLAG_INTERP;
> +    } else {
> +        data->flags = 0;
> +    }
> +
> +    return ioctl(vdev->vbasedev.fd, VFIO_DEVICE_FEATURE, feat);
> +}
> +
> +int s390_pci_update_passthrough_fh(S390PCIBusDevice *pbdev)
> +{
> +    VFIOPCIDevice *vdev = VFIO_PCI(pbdev->pdev);
> +    struct vfio_device_zpci_interp *data;
> +    int size = sizeof(struct vfio_device_feature) + sizeof(*data);
> +    g_autofree struct vfio_device_feature *feat = g_malloc0(size);
> +    int rc;
> +
> +    feat->argsz = size;
> +    feat->flags = VFIO_DEVICE_FEATURE_GET + VFIO_DEVICE_FEATURE_ZPCI_INTERP;
> +
> +    rc = ioctl(vdev->vbasedev.fd, VFIO_DEVICE_FEATURE, feat);
> +    if (rc) {
> +        return rc;
> +    }
> +
> +    data = (struct vfio_device_zpci_interp *)&feat->data;
> +    pbdev->fh = data->fh;
> +    return 0;
> +}
> +
>   static void s390_pci_read_base(S390PCIBusDevice *pbdev,
>                                  struct vfio_device_info *info)
>   {
> diff --git a/include/hw/s390x/s390-pci-bus.h b/include/hw/s390x/s390-pci-bus.h
> index da3cde2bb4..a9843dfe97 100644
> --- a/include/hw/s390x/s390-pci-bus.h
> +++ b/include/hw/s390x/s390-pci-bus.h
> @@ -350,6 +350,7 @@ struct S390PCIBusDevice {
>       IndAddr *indicator;
>       bool pci_unplug_request_processed;
>       bool unplug_requested;
> +    bool interp;
>       QTAILQ_ENTRY(S390PCIBusDevice) link;
>   };
>   
> diff --git a/include/hw/s390x/s390-pci-vfio.h b/include/hw/s390x/s390-pci-vfio.h
> index ff708aef50..42533e38f7 100644
> --- a/include/hw/s390x/s390-pci-vfio.h
> +++ b/include/hw/s390x/s390-pci-vfio.h
> @@ -20,6 +20,9 @@ bool s390_pci_update_dma_avail(int fd, unsigned int *avail);
>   S390PCIDMACount *s390_pci_start_dma_count(S390pciState *s,
>                                             S390PCIBusDevice *pbdev);
>   void s390_pci_end_dma_count(S390pciState *s, S390PCIDMACount *cnt);
> +int s390_pci_probe_interp(S390PCIBusDevice *pbdev);
> +int s390_pci_set_interp(S390PCIBusDevice *pbdev, bool enable);
> +int s390_pci_update_passthrough_fh(S390PCIBusDevice *pbdev);
>   void s390_pci_get_clp_info(S390PCIBusDevice *pbdev);
>   #else
>   static inline bool s390_pci_update_dma_avail(int fd, unsigned int *avail)
> @@ -33,6 +36,18 @@ static inline S390PCIDMACount *s390_pci_start_dma_count(S390pciState *s,
>   }
>   static inline void s390_pci_end_dma_count(S390pciState *s,
>                                             S390PCIDMACount *cnt) { }
> +int s390_pci_probe_interp(S390PCIBusDevice *pbdev)
> +{
> +    return -EINVAL;
> +}
> +static inline int s390_pci_set_interp(S390PCIBusDevice *pbdev, bool enable)
> +{
> +    return -EINVAL;
> +}
> +static inline int s390_pci_update_passthrough_fh(S390PCIBusDevice *pbdev)
> +{
> +    return -EINVAL;
> +}
>   static inline void s390_pci_get_clp_info(S390PCIBusDevice *pbdev) { }
>   #endif
>   
> 

LGTM
With the corrections proposed by Thomas.
Mine... you see what you prefer.

Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>


-- 
Pierre Morel
IBM Lab Boeblingen
