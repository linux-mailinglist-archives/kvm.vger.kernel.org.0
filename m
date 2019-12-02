Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E393210E581
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2019 06:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbfLBFgi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Dec 2019 00:36:38 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:29586 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725807AbfLBFgi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Dec 2019 00:36:38 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xB25aXbQ083405
        for <kvm@vger.kernel.org>; Mon, 2 Dec 2019 00:36:36 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2wm6bywcy7-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 02 Dec 2019 00:36:35 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <alistair@popple.id.au>;
        Mon, 2 Dec 2019 05:36:34 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 2 Dec 2019 05:36:31 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xB25aUWF34603136
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 2 Dec 2019 05:36:30 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C8451A405B;
        Mon,  2 Dec 2019 05:36:30 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2C3DDA4054;
        Mon,  2 Dec 2019 05:36:30 +0000 (GMT)
Received: from ozlabs.au.ibm.com (unknown [9.192.253.14])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  2 Dec 2019 05:36:30 +0000 (GMT)
Received: from townsend.localnet (haven.au.ibm.com [9.192.254.114])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ozlabs.au.ibm.com (Postfix) with ESMTPSA id 8277EA01A4;
        Mon,  2 Dec 2019 16:36:27 +1100 (AEDT)
From:   Alistair Popple <alistair@popple.id.au>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>
Cc:     linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        "Oliver O'Halloran" <oohall@gmail.com>
Subject: Re: [PATCH kernel RFC 0/4] powerpc/powenv/ioda: Allow huge DMA window at 4GB
Date:   Mon, 02 Dec 2019 16:36:28 +1100
In-Reply-To: <20191202015953.127902-1-aik@ozlabs.ru>
References: <20191202015953.127902-1-aik@ozlabs.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 19120205-0012-0000-0000-0000036F706C
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19120205-0013-0000-0000-000021AB267B
Message-Id: <22858805.RAHADn2P79@townsend>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-01_04:2019-11-29,2019-12-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 adultscore=0 priorityscore=1501 impostorscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=82 lowpriorityscore=0 spamscore=0 phishscore=0 clxscore=1034
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1910280000
 definitions=main-1912020049
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Monday, 2 December 2019 12:59:49 PM AEDT Alexey Kardashevskiy wrote:
> Here is an attempt to support bigger DMA space for devices
> supporting DMA masks less than 59 bits (GPUs come into mind
> first). POWER9 PHBs have an option to map 2 windows at 0
> and select a windows based on DMA address being below or above
> 4GB.
> 
> This adds the "iommu=iommu_bypass" kernel parameter and

Would it be possible to just enable this by default if the platform supports 
it? Are there any downsides? Adding it as an option seems like it would make 
things harder to support and reduces the amount of testing/use it would get.

> supports VFIO+pseries machine - current this requires telling
> upstream+unmodified QEMU about this via
> -global spapr-pci-host-bridge.dma64_win_addr=0x100000000
> or per-phb property. 4/4 advertises the new option but
> there is no automation around it in QEMU (should it be?).
> 
> For now it is either 1<<59 or 4GB mode; dynamic switching is
> not supported (could be via sysfs).
> 
> This is based on sha1
> a6ed68d6468b Linus Torvalds "Merge tag 'drm-next-2019-11-27' of git://
anongit.freedesktop.org/drm/drm".

Are you sure? I am getting the following rejected hunk trying to apply the 
first patch in the series:

--- arch/powerpc/platforms/powernv/pci-ioda.c
+++ arch/powerpc/platforms/powernv/pci-ioda.c
@@ -2349,15 +2349,10 @@ static void pnv_pci_ioda2_set_bypass(struct 
pnv_ioda_pe *pe, bool enable)
                pe->tce_bypass_enabled = enable;
 }
 
-static long pnv_pci_ioda2_create_table(struct iommu_table_group *table_group,
-               int num, __u32 page_shift, __u64 window_size, __u32 levels,
+static long pnv_pci_ioda2_create_table(int nid, int num, __u64 bus_offset,
+               __u32 page_shift, __u64 window_size, __u32 levels,
                bool alloc_userspace_copy, struct iommu_table **ptbl)
 {
-       struct pnv_ioda_pe *pe = container_of(table_group, struct pnv_ioda_pe,
-                       table_group);
-       int nid = pe->phb->hose->node;
-       __u64 bus_offset = num ?
-               pe->table_group.tce64_start : table_group->tce32_start;
        long ret;
        struct iommu_table *tbl;

- Alistair
 
> Please comment. Thanks.
> 
> 
> 
> Alexey Kardashevskiy (4):
>   powerpc/powernv/ioda: Rework for huge DMA window at 4GB
>   powerpc/powernv/ioda: Allow smaller TCE table levels
>   powerpc/powernv/phb4: Add 4GB IOMMU bypass mode
>   vfio/spapr_tce: Advertise and allow a huge DMA windows at 4GB
> 
>  arch/powerpc/include/asm/iommu.h              |   1 +
>  arch/powerpc/include/asm/opal-api.h           |  11 +-
>  arch/powerpc/include/asm/opal.h               |   2 +
>  arch/powerpc/platforms/powernv/pci.h          |   1 +
>  include/uapi/linux/vfio.h                     |   2 +
>  arch/powerpc/platforms/powernv/opal-call.c    |   2 +
>  arch/powerpc/platforms/powernv/pci-ioda-tce.c |   4 +-
>  arch/powerpc/platforms/powernv/pci-ioda.c     | 219 ++++++++++++++----
>  drivers/vfio/vfio_iommu_spapr_tce.c           |  10 +-
>  9 files changed, 202 insertions(+), 50 deletions(-)
> 
> 




