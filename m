Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4304E5562
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 16:38:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237525AbiCWPkA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 11:40:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237933AbiCWPj6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 11:39:58 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD6DA65B6
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 08:38:28 -0700 (PDT)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22NErXtC010901;
        Wed, 23 Mar 2022 15:37:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=K2LLicr2JWytAgQJVc9LUrnG4RWZCmoG46Dq3Bulh4A=;
 b=Agg0+HZkaGB83f6YCa1z07SiTs+9TUIUTqL/kNU4ephnxSBICXwLdQXoD2W9/GNWfy0S
 KxU9HyKn857GB2R4SMeB4Ypkoj2zgFpxqGDhYLUm0VXB+NZlv3KjWIXjA4dTbrexcxxv
 SmLcEl8tRSLcmL0cV8CNOuNV0bnLo4TfNXyqmWORUyt84WsMavq3kaBy9ozYufg9Othf
 EiopJOgAhBjvho/XYSIDmFodzqFJcPSRJLU5wxDWZNGR9PnJoASxv51/07iUQCIOoanv
 QM3RbMLgUqL1yCfPmGkXcPLa5m/i/USOW4ghp9AaOfweFQNucPASD8YyYuioOPDXlOeW vg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f03c9d00k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 15:37:56 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22NEV9CP019981;
        Wed, 23 Mar 2022 15:37:56 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f03c9cyym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 15:37:56 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22NFNOQw030191;
        Wed, 23 Mar 2022 15:37:54 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3ew6t90vs6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 15:37:54 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22NFbqpg28639696
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Mar 2022 15:37:52 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E2177A405B;
        Wed, 23 Mar 2022 15:37:51 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D6F7AA405F;
        Wed, 23 Mar 2022 15:37:50 +0000 (GMT)
Received: from sig-9-145-1-1.uk.ibm.com (unknown [9.145.1.1])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Mar 2022 15:37:50 +0000 (GMT)
Message-ID: <910ee0690554fcfff282996f3e78b3d7b77145c3.camel@linux.ibm.com>
Subject: Re: [PATCH RFC 05/12] iommufd: PFN handling for iopt_pages
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        iommu@lists.linux-foundation.org, Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Keqian Zhu <zhukeqian1@huawei.com>
Date:   Wed, 23 Mar 2022 16:37:50 +0100
In-Reply-To: <5-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
References: <5-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: wxyok1J2EPzePu5byA5SW_Q5wyjqYPZo
X-Proofpoint-GUID: HsgPjVA_F7pdvx7ZrfHuVGKaJLEqRN0v
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-23_07,2022-03-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 phishscore=0 adultscore=0 impostorscore=0
 suspectscore=0 clxscore=1015 malwarescore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2203230084
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-03-18 at 14:27 -0300, Jason Gunthorpe wrote:
> The top of the data structure provides an IO Address Space (IOAS) that is
> similar to a VFIO container. The IOAS allows map/unmap of memory into
> ranges of IOVA called iopt_areas. Domains and in-kernel users (like VFIO
> mdevs) can be attached to the IOAS to access the PFNs that those IOVA
> areas cover.
> 
> The IO Address Space (IOAS) datastructure is composed of:
>  - struct io_pagetable holding the IOVA map
>  - struct iopt_areas representing populated portions of IOVA
>  - struct iopt_pages representing the storage of PFNs
>  - struct iommu_domain representing the IO page table in the system IOMMU
>  - struct iopt_pages_user representing in-kernel users of PFNs (ie VFIO
>    mdevs)
>  - struct xarray pinned_pfns holding a list of pages pinned by in-kernel
>    users
> 
> This patch introduces the lowest part of the datastructure - the movement
> of PFNs in a tiered storage scheme:
>  1) iopt_pages::pinned_pfns xarray
>  2) An iommu_domain
>  3) The origin of the PFNs, i.e. the userspace pointer
> 
> PFN have to be copied between all combinations of tiers, depending on the
> configuration.
> 
> The interface is an iterator called a 'pfn_reader' which determines which
> tier each PFN is stored and loads it into a list of PFNs held in a struct
> pfn_batch.
> 
> Each step of the iterator will fill up the pfn_batch, then the caller can
> use the pfn_batch to send the PFNs to the required destination. Repeating
> this loop will read all the PFNs in an IOVA range.
> 
> The pfn_reader and pfn_batch also keep track of the pinned page accounting.
> 
> While PFNs are always stored and accessed as full PAGE_SIZE units the
> iommu_domain tier can store with a sub-page offset/length to support
> IOMMUs with a smaller IOPTE size than PAGE_SIZE.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/iommufd/Makefile          |   3 +-
>  drivers/iommu/iommufd/io_pagetable.h    | 101 ++++
>  drivers/iommu/iommufd/iommufd_private.h |  20 +
>  drivers/iommu/iommufd/pages.c           | 723 ++++++++++++++++++++++++
>  4 files changed, 846 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/iommu/iommufd/io_pagetable.h
>  create mode 100644 drivers/iommu/iommufd/pages.c
> 
> 
---8<---
> +
> +/*
> + * This holds a pinned page list for multiple areas of IO address space. The
> + * pages always originate from a linear chunk of userspace VA. Multiple
> + * io_pagetable's, through their iopt_area's, can share a single iopt_pages
> + * which avoids multi-pinning and double accounting of page consumption.
> + *
> + * indexes in this structure are measured in PAGE_SIZE units, are 0 based from
> + * the start of the uptr and extend to npages. pages are pinned dynamically
> + * according to the intervals in the users_itree and domains_itree, npages
> + * records the current number of pages pinned.

This sounds wrong or at least badly named. If npages records the
current number of pages pinned then what does npinned record?

> + */
> +struct iopt_pages {
> +	struct kref kref;
> +	struct mutex mutex;
> +	size_t npages;
> +	size_t npinned;
> +	size_t last_npinned;
> +	struct task_struct *source_task;
> +	struct mm_struct *source_mm;
> +	struct user_struct *source_user;
> +	void __user *uptr;
> +	bool writable:1;
> +	bool has_cap_ipc_lock:1;
> +
> +	struct xarray pinned_pfns;
> +	/* Of iopt_pages_user::node */
> +	struct rb_root_cached users_itree;
> +	/* Of iopt_area::pages_node */
> +	struct rb_root_cached domains_itree;
> +};
> +
---8<---

