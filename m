Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3272F3DE5
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 01:44:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388804AbhALVwx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 16:52:53 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:58760 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726952AbhALVwv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 16:52:51 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10CLXr5Q115084;
        Tue, 12 Jan 2021 21:52:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=RJ8CjSMg8nvlX0gWaiTYdMOIxFZpSsD2z6rrzNsOchc=;
 b=OyoYnBLmfbKFYGIMDLOSKaVN77n2ChZ2maOl1V+TuCAbozO5500ldBBnLt0NaLsMHhhm
 26NJRYuBOIUvUEBPaUDlMH5OCgRwDaVBAufpWC08TtaRfT6nhh+B8GKHKYNfmCRcM7yc
 csHVghsrir+yoK/RsHHFyP4JbEZ4AjeOD/YPSdEyhocpe2oEH5fknbRxb8Akrj4qguEQ
 wlHTnO4O6GDZr9Y8YsYECHLf34/cXgOQhZ3ZF0XtgvroGNPbERE8p8O7dj+bOjktzBo9
 kyeIRkHy1TXfgutIaxZhCqMjvLx1P3aRphekpGnSYE6UUWi4QvZtPPrhX7pXtMmh/mLH 7w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 360kg1rmtn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 21:52:07 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10CLaVNB037132;
        Tue, 12 Jan 2021 21:52:06 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 360kf674dn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 21:52:06 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 10CLq5Fg021664;
        Tue, 12 Jan 2021 21:52:05 GMT
Received: from [10.39.203.132] (/10.39.203.132)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 Jan 2021 13:52:05 -0800
Subject: Re: [PATCH V1 0/5] vfio virtual address update
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>, kvm@vger.kernel.org
References: <1609861013-129801-1-git-send-email-steven.sistare@oracle.com>
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
Message-ID: <7cc773c7-1072-1fda-6f7e-e5410e53e4fc@oracle.com>
Date:   Tue, 12 Jan 2021 16:52:04 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <1609861013-129801-1-git-send-email-steven.sistare@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101120128
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 clxscore=1015 impostorscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101120128
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/5/2021 10:36 AM, Steve Sistare wrote:
> Add interfaces that allow the underlying memory object of an iova range
> to be mapped to a new virtual address in the host process:
> 
>   - VFIO_DMA_UNMAP_FLAG_SUSPEND for VFIO_IOMMU_UNMAP_DMA
>   - VFIO_DMA_MAP_FLAG_RESUME flag for VFIO_IOMMU_MAP_DMA
>   - VFIO_SUSPEND extension for VFIO_CHECK_EXTENSION
> 
> The suspend interface blocks vfio translation of host virtual addresses in
> a range, but DMA to already-mapped pages continues.  The resume interface
> records the new base VA and resumes translation.  The implementation
> supports iommu type1 and mediated devices.
> 
> This functionality is necessary for live update, in which a host process
> such as qemu exec's an updated version of itself, while preserving its
> guest and vfio devices.  The process suspends vfio VA translation, exec's
> its new self, mmap's the memory object(s) underlying vfio object, and
> resumes VA translation.  For a working example that uses these new
> interfaces, see the QEMU patch series "[PATCH V2] Live Update".
> 
> Patch 1 modifies the iova rbtree to allow iteration over ranges with gaps,
>   without deleting each entry.  This is required by patch 4.
> Patch 2 adds an option to unmap all ranges, which simplifies userland code.
> Patch 3 adds an interface to detect if an iommu_group has a valid container,
>   which patch 5 uses to release a blocked thread if a container is closed.
> Patch 4 implements the new ioctl's.
> Patch 5 adds blocking to complete the implementation .
> 
> Steve Sistare (5):
>   vfio: maintain dma_list order
>   vfio: option to unmap all
>   vfio: detect closed container
>   vfio: VA suspend interface
>   vfio: block during VA suspend
> 
>  drivers/vfio/vfio.c             |  12 ++++
>  drivers/vfio/vfio_iommu_type1.c | 122 ++++++++++++++++++++++++++++++++++------
>  include/linux/vfio.h            |   1 +
>  include/uapi/linux/vfio.h       |  19 ++++++-
>  4 files changed, 135 insertions(+), 19 deletions(-)
> 

Hi Alex,
  I can send a patch V2 for review if you weigh in on the following:

* preferred interface for unmap-all (patch 2)
* name of the suspend and resume flags (patch 4)
* is vfio_iommu_contained() acceptable, or is a new backend interface needed? (patch 5)

- Steve

