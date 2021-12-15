Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32ECA4753DA
	for <lists+kvm@lfdr.de>; Wed, 15 Dec 2021 08:43:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233444AbhLOHnq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Dec 2021 02:43:46 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:12050 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230260AbhLOHno (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Dec 2021 02:43:44 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BF6CpvM037722;
        Wed, 15 Dec 2021 07:43:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=12XgCiCq4gDE5EEn4IkkSme3vYmK542Vhaz6dpPWGbU=;
 b=Mp6ij1Qx5J0W1UpiD0I4DtTPVFNkcTT7M2bVK8dn2aq6PLCcLw8bW07EpNqIQ4i9eFcD
 JOPEKDJAtO4rt0sMBp8QYUMoSuLyd7w6DPKSZOU42eTR03f1G9WjrA22zSr+lOvsgwMc
 Hth78Z965rFA3PjZm9tOx49MiAbtXjiiODndstJRSeu2CA8r0FgDi3nvzdgC4+yJM/oL
 +yg6r3Ot30Aq0u/Cg4OB1hs4HvQRV9qZoBTViS80I0H/sgbJVWoFYrDNfk7fYNDvS1k8
 tUtoCgEnpqH8LT0EYx5u6OcCSprvQIax2S4XjbU7HHyuMmxPg1Zwrs8NnPSGSd9kiXoJ gg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cx9raafmk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Dec 2021 07:43:39 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BF7I2MO013916;
        Wed, 15 Dec 2021 07:43:39 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cx9raafm1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Dec 2021 07:43:39 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BF7gY6u026776;
        Wed, 15 Dec 2021 07:43:37 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 3cy7vv9wjd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Dec 2021 07:43:37 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BF7hXLh43974958
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Dec 2021 07:43:33 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A18E0A4059;
        Wed, 15 Dec 2021 07:43:33 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B1EFBA405E;
        Wed, 15 Dec 2021 07:43:32 +0000 (GMT)
Received: from [9.171.24.181] (unknown [9.171.24.181])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 15 Dec 2021 07:43:32 +0000 (GMT)
Message-ID: <69925992-e6a0-5536-8190-00a435de72f0@linux.ibm.com>
Date:   Wed, 15 Dec 2021 08:44:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 07/12] s390x/pci: enable for load/store intepretation
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     farman@linux.ibm.com, kvm@vger.kernel.org, schnelle@linux.ibm.com,
        cohuck@redhat.com, richard.henderson@linaro.org, thuth@redhat.com,
        qemu-devel@nongnu.org, pasic@linux.ibm.com,
        alex.williamson@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        david@redhat.com, borntraeger@linux.ibm.com
References: <20211207210425.150923-1-mjrosato@linux.ibm.com>
 <20211207210425.150923-8-mjrosato@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20211207210425.150923-8-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: pA7nzTIM3RkffUlg8YPMzUE6dStoIjdP
X-Proofpoint-ORIG-GUID: NCEXS6xWWQNjZk5jiLpXBMsWmI_DwUCc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-15_06,2021-12-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 impostorscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999
 adultscore=0 clxscore=1015 mlxscore=0 phishscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112150042
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/7/21 22:04, Matthew Rosato wrote:
> Use the associated vfio feature ioctl to enable interpretation for devices
> when requested.  As part of this process, we must use the host function
> handle rather than a QEMU-generated one -- this is provided as part of the
> ioctl payload.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   hw/s390x/s390-pci-bus.c          | 69 +++++++++++++++++++++++++++++++-
>   hw/s390x/s390-pci-inst.c         | 63 ++++++++++++++++++++++++++++-
>   hw/s390x/s390-pci-vfio.c         | 55 +++++++++++++++++++++++++
>   include/hw/s390x/s390-pci-bus.h  |  1 +
>   include/hw/s390x/s390-pci-vfio.h | 15 +++++++
>   5 files changed, 201 insertions(+), 2 deletions(-)
> 
> diff --git a/hw/s390x/s390-pci-bus.c b/hw/s390x/s390-pci-bus.c
> index 01b58ebc70..451bd32d92 100644
> --- a/hw/s390x/s390-pci-bus.c
> +++ b/hw/s390x/s390-pci-bus.c
> @@ -971,12 +971,57 @@ static void s390_pci_update_subordinate(PCIDevice *dev, uint32_t nr)
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
> +     * The host device is in an enabled state, but the device must
> +     * begin as disabled for the guest so mask off the enable bit
> +     * from the passthrough handle.
> +     */

I think you should explain why the device must be seen disabled for the 
guest.
AFAIU it is because we need the guest to issue a CLP_ENABLE for us to 
activate interpretation.
This is due to the choice of activate/deactivate interpretation during 
device enable/disable.

Just curious: why not activate/deactivate interpretation on plug/unplug?

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
> +         * If the relinquised idx is lower than next_idx, use it
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
> @@ -1022,12 +1067,33 @@ static void s390_pcihost_plug(HotplugHandler *hotplug_dev, DeviceState *dev,
>           set_pbdev_info(pbdev);
>   
>           if (object_dynamic_cast(OBJECT(dev), "vfio-pci")) {
> -            pbdev->fh |= FH_SHM_VFIO;
> +            /*
> +             * By default, interpretation is always requested; if the available
> +             * facilities indicate it is not available, fallback to the
> +             * intercept model.
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
> @@ -1360,6 +1426,7 @@ static Property s390_pci_device_properties[] = {
>       DEFINE_PROP_UINT16("uid", S390PCIBusDevice, uid, UID_UNDEFINED),
>       DEFINE_PROP_S390_PCI_FID("fid", S390PCIBusDevice, fid),
>       DEFINE_PROP_STRING("target", S390PCIBusDevice, target),
> +    DEFINE_PROP_BOOL("interp", S390PCIBusDevice, interp, true),
>       DEFINE_PROP_END_OF_LIST(),
>   };
>   
> diff --git a/hw/s390x/s390-pci-inst.c b/hw/s390x/s390-pci-inst.c
> index 0cef7fbace..ba4017474e 100644
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
> index 6f80a47e29..78093aaac7 100644
> --- a/hw/s390x/s390-pci-vfio.c
> +++ b/hw/s390x/s390-pci-vfio.c
> @@ -97,6 +97,61 @@ void s390_pci_end_dma_count(S390pciState *s, S390PCIDMACount *cnt)
>       }
>   }
>   
> +int s390_pci_probe_interp(S390PCIBusDevice *pbdev)
> +{
> +    VFIOPCIDevice *vdev = container_of(pbdev->pdev, VFIOPCIDevice, pdev);
> +    struct vfio_device_feature feat = {
> +        .argsz = sizeof(struct vfio_device_feature),
> +        .flags = VFIO_DEVICE_FEATURE_PROBE + VFIO_DEVICE_FEATURE_ZPCI_INTERP
> +    };
> +
> +    return ioctl(vdev->vbasedev.fd, VFIO_DEVICE_FEATURE, &feat);
> +}
> +
> +int s390_pci_set_interp(S390PCIBusDevice *pbdev, bool enable)
> +{
> +    VFIOPCIDevice *vdev = container_of(pbdev->pdev, VFIOPCIDevice, pdev);
> +    g_autofree struct vfio_device_feature *feat;
> +    struct vfio_device_zpci_interp *data;
> +    int size;
> +
> +    size = sizeof(*feat) + sizeof(*data);
> +    feat = g_malloc0(size);
> +    feat->argsz = size;
> +    feat->flags = VFIO_DEVICE_FEATURE_SET + VFIO_DEVICE_FEATURE_ZPCI_INTERP;

I personaly do not like the use of "+" instead of "|" to act on bitmap 
or flags. But... yes, my opinion.

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
> +    VFIOPCIDevice *vdev = container_of(pbdev->pdev, VFIOPCIDevice, pdev);
> +    g_autofree struct vfio_device_feature *feat;
> +    struct vfio_device_zpci_interp *data;
> +    int size, rc;
> +
> +    size = sizeof(*feat) + sizeof(*data);
> +    feat = g_malloc0(size);
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

-- 
Pierre Morel
IBM Lab Boeblingen
