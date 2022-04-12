Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 830B34FE98A
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 22:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231134AbiDLUnQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 16:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbiDLUnD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 16:43:03 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2061e.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::61e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67AFEAD11B
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 13:37:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kNRdOxCdnFJVJXt2tx/6dRCaKX9CPd6f1ruqiG/9xauUn7a6wWKLAzgOdlQY+dFOsHaNo1ZXAwQtXKhuB+Iw5lsoUDy64WQrGQJ4S4tWruRRGxk/B2y5P3z1/NZdQmyBbibpCpZiLBiQMdW8idsIAUGMnVo90pMRXcu75MvyPecOZD4XT5ghSLC2BAgj+l0JpXGnNhDwuPCuABW9rQpJV5T5JHd/8Wp/rtdatg3PIO38adkGq5fUjdNFMANAPodNhO+8adG7d/I74Iuf9YHPfnWkB7gxMHARSMI9mQfvRXnRp2mQ96yuJrRFOKcmNePHyMYE965J6ERdmu9lgXbR3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dwhCkbwtGbxcdKibcIY0Sp2NTEMV1VPkWSE3PK+G/cQ=;
 b=FQDDqQMykrgjLXXlAUgPuukRwF6xeFHz9sFSQ6/NzVzGoi5jnX0EIkUZwtQWXN2hQyfEEJUJ/hCZBxMItXxIFrbsR3uZlrhiufFf7cF0Wp27jGmd6fcJc1Kz+mnvEuQqB/E6/n9PW8gb+grCTIKzQD1PzuWIT1yqD+/7+YXHNuf9HnaMPeDKcB2CtFKHPQyMjwMtHOi7UHiYsvniT9idbRe9w1ugnYXWMB/JE4n063iynN+ZqmthGhYabIeyvnnV8DZHIhvRc8KRHdKZB1Os49pxiurpApHlM37byBY6522OEJCPnxFgrOQzyJ48p1OK1rWQ4Za9BlpNySjn7rs9ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dwhCkbwtGbxcdKibcIY0Sp2NTEMV1VPkWSE3PK+G/cQ=;
 b=Wk4mJfkat9CnSwI/iV9yHgaJUTqyQFKNaa1LLmWNMCgR1z+RZUlEM/AUqc2JOnMwEC/SJPpP8FlAJTkOlomcAiRnvWSHOncO06YiGyFRS4S7AF7AWcmIIUEoS2k40GDSSMep8JwikwRBmP1RN3q+up7TTXOJMdw76wJxqnG6eVXIiO5pVn1Nm7mDbxP849btif3PQ7A8z/qOcmuvi4PrZy4LplV994754r2xQtBDlQqrmq6JsyWHG4gWELDI0vJ0+6zWmLa39NkNNf2lTia698bV9HZDLUzVlS58/mpErDKDuihC6ToWZweYSizm10H1f517ky9PWK/LH/0rA8S+aA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH2PR12MB4181.namprd12.prod.outlook.com (2603:10b6:610:a8::16)
 by DM6PR12MB4926.namprd12.prod.outlook.com (2603:10b6:5:1bb::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 20:22:41 +0000
Received: from CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::c911:71b5:78e6:3a38]) by CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::c911:71b5:78e6:3a38%8]) with mapi id 15.20.5144.029; Tue, 12 Apr 2022
 20:22:41 +0000
Date:   Tue, 12 Apr 2022 17:22:39 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        iommu@lists.linux-foundation.org, Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH RFC 00/12] IOMMUFD Generic interface
Message-ID: <20220412202239.GL2120790@nvidia.com>
References: <0-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <17084696-4b85-8fe7-47e0-b15d4c56d403@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17084696-4b85-8fe7-47e0-b15d4c56d403@redhat.com>
X-ClientProxiedBy: MN2PR12CA0009.namprd12.prod.outlook.com
 (2603:10b6:208:a8::22) To CH2PR12MB4181.namprd12.prod.outlook.com
 (2603:10b6:610:a8::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 69bebda3-f369-4ddf-af55-08da1cc23188
X-MS-TrafficTypeDiagnostic: DM6PR12MB4926:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB492613739131B8A31F95E65CC2ED9@DM6PR12MB4926.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vSjmS8cCsY+Qv8vMxWZqG6IFK68g9Uu4gkYrsSfeVUpr+AZuNIsKCk5NvN8H0tFHtL2op/Ee8p6hDMqd2jq6Gp+dO0rPbpZwM0zxdGN2l+vew5i5bJsmLLunxoLS+81w/A/zmr1ip1783aZhPXbfXGF7sYcfabT+aMMR8MkbhaW0VjJoYdFxSy8GN+lfoavk1wHQnLm5x+MlyxZVLJ4nqLK94J2hC9LbOJX71yj5vFuoCBSdEo/NmXucoLeiRGwsC46YTS6G842Ta+Ug4bAFPOuOlfeP7CBpQKIRSY6JLUaafaI/jq5HMayBAUhV81us29iX41MtD2WKTK4tRzkm52guYsk2Y7mN1DrZ0snlS3zVjm9BU4Wkbt0paB7uStv4Q+UxMa2iMQeCd2SvjaWBageqIQE5WpRO4F0USgWt5bVOeBlx3QYVq70DhcJ9ZlyAR4L12aZ5a9oRLtI/JLLyWVd8oCwyB7Sjw/MgJgIcAl8UmPe7s6f9tNdr+9AGVlTu2jAmUqeDGgRlRw+mCHWXbNCXmp92lwf/5loTv6Ll9xhV7jiqAwGgctnbLcpM6UUb+WhExac2g6oEMPlLaLfseaB5lDbBEn6naGM8Bo7lwSA6PY0jWBDmPyRB+EX/XiYjmWjXcSnjuZm21IKz6p+ya8ao+R3e+q/PUOuWapzi2Aaj6X9BkEguT7wH/k2wU3kV72fmG16hpHgJpQgAQH3L6KeB+Ii/bi+wxlX4U4VjNq8kmS6FC0uNylW9W4Vu3RLqk1Oc6+8iBcZjJ4RaZy7IzA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4181.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(53546011)(6512007)(1076003)(66556008)(66946007)(8676002)(26005)(8936002)(186003)(66476007)(4326008)(2906002)(5660300002)(7416002)(83380400001)(6486002)(966005)(6506007)(6916009)(54906003)(316002)(38100700002)(33656002)(86362001)(36756003)(508600001)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KsbM9XWhSLnruKMJQXWbZHF+53LCeNLXgpHBygEZ1l50Ul2haAB+BOMT2Kp2?=
 =?us-ascii?Q?GMDr7Zg4A4J/SGCVJuDmUFm3jZ5eewkuNOcV/D+pe2sNhUmT3Ab4MheRvUvZ?=
 =?us-ascii?Q?XRYJEgF68oCjYxziPipI8nUDWy5h514sp0dFAmjFznud9yLb61w+CIhjxjYh?=
 =?us-ascii?Q?1pNoEXgsMPTsNcywCamFKl7ZqGRNuI/mBlOUnp6kganA5+eTop6Tujdl+dDl?=
 =?us-ascii?Q?qLZt3qbg083nOuHtJHOOw8OA9tkmzeKEgzcTQMbC/CldFut4CQa7HNj/8kl2?=
 =?us-ascii?Q?dSiCx8DhRELmMJAY/PbO1IJjswvrZh2gkYtDE0FjIGXZvN4VHDu0qgtowZjs?=
 =?us-ascii?Q?QYDGmeUqrMEDxc4zobwjkNVa23I0rP6yGdAm3q8v87yZcYtmfGPXnr33DaW+?=
 =?us-ascii?Q?3U/PSQxwDRatxmle8hWfIAyXlDizgiTSKeMqIht72P7BmU9qo2ciDwwwvUMu?=
 =?us-ascii?Q?vm2e9HAB954PBY8QKz2nh2DfxFV9nARbb/i1QrD2d2Uq/50hoWjVDjL9wkWn?=
 =?us-ascii?Q?PBV9Q59YpV2M+gRh8Y9/Up3YLdaY19rzxgKggd2e4ZXPmN5S3w4weOBiLMCM?=
 =?us-ascii?Q?ESr3iQzDWG3FisG4gX1RcVe8K7Ap7hG9U5fCKq9lh5MXOjlBdRqC1Uc+R+CO?=
 =?us-ascii?Q?nTtO/DZ4iDZ7oYcojZkQwfPkCQ9T81DWUQ8ZmQQ6wvsYIbUn926HfHG4h9ot?=
 =?us-ascii?Q?R47F9+0Is3xy7n80wnUHSth9pVvStxEK9CVoQlETtyyIIfkBzMFq2ZcpEIQc?=
 =?us-ascii?Q?rYTqk3ezTGhdqstyJTHZeP/om4+oq+NOho4Rnjkp8lHC3aWjvmA6ISUkG0Uq?=
 =?us-ascii?Q?5wqlmrLUqyQrXsoFiMh4vG6apMkHhV2U7t1DjUcUJJj7F17IJrEKi25nWbo+?=
 =?us-ascii?Q?MYp06HGAA+rBCpU2hlpUeJGBagC2FvnCqpO0DNbcBa95ZffTQhsrJHwnWsgW?=
 =?us-ascii?Q?gft98Ucw+LIOozQ4FAmUk8yRzTGstF7Rtx3jsmkohbUeURFBz92XBp18k9UB?=
 =?us-ascii?Q?RJnKAT4y5WX4mcOz0Srb2+DyDsWKHcZwpqFOYkXqGhLYWIfxKHZ69YHnVi1P?=
 =?us-ascii?Q?YwREYeQhgVNMrZk9/kt+zBZ/XaRqq3aCcSmwdIPZLomCmFhsNsgibuLCq530?=
 =?us-ascii?Q?irWiMBV4xy5WblVigGVBQMkpOXRwMhAAiB79J+asOgwVNWFgveC/f1odfEpp?=
 =?us-ascii?Q?vEe54smcEDR2t6VRco4rbXXUXMCpDJDCv5EV6yEAfX3qUATygPyeXu7ThWmQ?=
 =?us-ascii?Q?/tGlOxtRVj+fosTpccnDcRYfph9BJdrYhuTe1k5fsmf7yh6S8hKqtJioRsH8?=
 =?us-ascii?Q?WIZ2dnL06nXB9dz+5HPpjwRrDDOztuCHug6WyXSY4Um4VlKo8uBo3T/fvMhX?=
 =?us-ascii?Q?JcgX5vdoLUclx2bWzfHfjNCo8iTQIF/tR317aaRU62I8tGZsIAYDYDlnwHnP?=
 =?us-ascii?Q?EBb/HDrS29T5I3qsxPcxQRzxk+210q4SjF+MSEd9tZZjdtWq+81LfqkxxdRr?=
 =?us-ascii?Q?KAWYsvG/LXwEi032tigvAek/iKcIC5YNVssEiZid/XS32D6aGxOTOROLNNST?=
 =?us-ascii?Q?FdSoDLppkMkLm/5puvXrWMy5tXriiGTwBg05dxd/euCH/XnfpSrMo7REtubc?=
 =?us-ascii?Q?74erksNXYN1s/AN2LSr0z3pByaL/Hzp87bcIf2mWaT26GKT4Eqx2Zf0fdzwQ?=
 =?us-ascii?Q?FL0is0P39GMyXvDPFfMtnDtbJBoDhtfV83SJf2hB7VgFoadcyM5AdxDX6HEa?=
 =?us-ascii?Q?tMc9DmqYqA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69bebda3-f369-4ddf-af55-08da1cc23188
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4181.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 20:22:40.9120
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6yH5dJJK/8wvm06MWYggtsbB5I1+2YP8/upEgLwKZ79vqUHBqJQu5rfZit1+61i2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4926
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 12, 2022 at 10:13:32PM +0200, Eric Auger wrote:
> Hi,
> 
> On 3/18/22 6:27 PM, Jason Gunthorpe wrote:
> > iommufd is the user API to control the IOMMU subsystem as it relates to
> > managing IO page tables that point at user space memory.
> >
> > It takes over from drivers/vfio/vfio_iommu_type1.c (aka the VFIO
> > container) which is the VFIO specific interface for a similar idea.
> >
> > We see a broad need for extended features, some being highly IOMMU device
> > specific:
> >  - Binding iommu_domain's to PASID/SSID
> >  - Userspace page tables, for ARM, x86 and S390
> >  - Kernel bypass'd invalidation of user page tables
> >  - Re-use of the KVM page table in the IOMMU
> >  - Dirty page tracking in the IOMMU
> >  - Runtime Increase/Decrease of IOPTE size
> >  - PRI support with faults resolved in userspace
> 
> This series does not have any concept of group fds anymore and the API
> is device oriented.
> I have a question wrt pci bus reset capability.
> 
> 8b27ee60bfd6 ("vfio-pci: PCI hot reset interface")
> introduced VFIO_DEVICE_PCI_GET_HOT_RESET_INFO and VFIO_DEVICE_PCI_HOT_RESET
> 
> Maybe we can reuse VFIO_DEVICE_GET_PCI_HOT_RESET_INFO to retrieve the devices and iommu groups that need to be checked and involved in the bus reset. If I understand correctly we now need to make sure the devices are handled in the same security context (bound to the same iommufd)
> 
> however VFIO_DEVICE_PCI_HOT_RESET operate on a collection of group fds.
> 
> How do you see the porting of this functionality onto /dev/iommu?

I already made a patch that converts VFIO_DEVICE_PCI_HOT_RESET to work
on a generic notion of a file and the underlying infrastructure to
allow it to accept either a device or group fd.

Same for the similar issue in KVM.

It is part of three VFIO series I will be posting. First is up here:

https://lore.kernel.org/kvm/0-v1-a8faf768d202+125dd-vfio_mdev_no_group_jgg@nvidia.com/

Overall the strategy is to contain the vfio_group as an internal detail
of vfio.ko and external interfaces use either a struct vfio_device *
or a struct file *

Jason
