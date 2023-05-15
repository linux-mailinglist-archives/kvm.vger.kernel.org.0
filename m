Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5571770320A
	for <lists+kvm@lfdr.de>; Mon, 15 May 2023 17:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242479AbjEOP7E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 May 2023 11:59:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242514AbjEOP6q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 May 2023 11:58:46 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2077.outbound.protection.outlook.com [40.107.244.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6E2730F0;
        Mon, 15 May 2023 08:58:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XU+20i5Jw11BG05+Kf5iWbmvUbofMI/3OiF1XMKrKfZ4Q0/Acrp3hzgr11Y4wfQQNxeJXhssP4AODR3XjnHlgppuiPDEpXgVJkl/VjRtvWlyHY3Pxp3KbgOGPFFxnwhEC0R4mKUCzFAC96+JoaaJHvEY/Bzho47cXABATncqBZBBpHoFCRbdaGqGAYLE24U6+Z/164dtujIpOmnP3bdONh32LePIggW0wRnXrkc6N1lnVXrmsqme3jHhCJT7jVbaFDsNnf9CJHus/GvaosVG/wJksCpTX12ZjRuQ11XTZVEpaG5qjJvDQkz+S2+68IG4XZMgfqZaFiUc7jSRUhAX7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lLCdeyfuqkdoWsFvgwI2ZPMmQ7gFAcK9jgiuQU9FpdY=;
 b=L+eQyqOhDZBZ+Ouyuypu62yznfqKraleWjMbqBChKr2HIDiRXhrZhaInXClH2fHxWlplZAbX2nx51J7k/pOjO9Wun/ozboxcysPOR5kGwK/WlJ1CBxEuh7Ri7ua1b/EfRWEMF4PK4CuuoW6Y9IbOYLSmL5aWzi/QR8pc86ovRycgsjZe6EBfjIrNteAnDxLE8Y629Y+u/Bqdq8jYu1BQD4yIIxFT47BE4xo17W0YRat0S8VseYy8GCwMtxop64+IQ6o68aCMGox900Pd9S8T7QXdn3+IzBV4JkSLklORmH8uwnLFzR09IajuDjbmCGZlp4Gz7lPiZSrvaCinnzjnRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linaro.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lLCdeyfuqkdoWsFvgwI2ZPMmQ7gFAcK9jgiuQU9FpdY=;
 b=ni8fLrWqgNTaKLfgHjOvsQPhUcTSZtdiQPvW4fXGJ1s3XflulfO7mUx9m70+UeLPP4DcVZFvHHyYOSxdmFFRe/G1Rk7QtJ2rijEkbUF1yCbT+N8aYkCL9dw2Nac8foP+Lnbd5QdmzasCcjtQtFnSs9nHlB9ybMdlzlyktYxil7Mc4JGbF5UrlqEIC0Ordr9N206P18z8EN3hVJ5YVI1mMIl7xV7bZMX4sNTk+LzPWHkxJwj4G0iT3nBFGNfmCPGw4JB8A2px4bbMsCaHWQtrkFSIUJe7Cd6a8HuE7cQrsofwW4+n2zwj8Dgrsi2/XYn8WKPGHhPeRqvUe8mEgpYutQ==
Received: from BN0PR04CA0153.namprd04.prod.outlook.com (2603:10b6:408:eb::8)
 by LV3PR12MB9093.namprd12.prod.outlook.com (2603:10b6:408:19d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Mon, 15 May
 2023 15:58:10 +0000
Received: from BN8NAM11FT015.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:eb:cafe::2a) by BN0PR04CA0153.outlook.office365.com
 (2603:10b6:408:eb::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30 via Frontend
 Transport; Mon, 15 May 2023 15:58:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT015.mail.protection.outlook.com (10.13.176.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.14 via Frontend Transport; Mon, 15 May 2023 15:58:10 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 15 May 2023
 08:57:54 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 15 May
 2023 08:57:54 -0700
Received: from Asurada-Nvidia (10.127.8.11) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37 via Frontend
 Transport; Mon, 15 May 2023 08:57:53 -0700
Date:   Mon, 15 May 2023 08:57:52 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     Zhangfei Gao <zhangfei.gao@linaro.org>
CC:     <jgg@nvidia.com>, <robin.murphy@arm.com>, <will@kernel.org>,
        <eric.auger@redhat.com>, <kevin.tian@intel.com>,
        <baolu.lu@linux.intel.com>, <joro@8bytes.org>,
        <shameerali.kolothum.thodi@huawei.com>, <jean-philippe@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <alex.williamson@redhat.com>, <yi.l.liu@intel.com>
Subject: Re: [PATCH v2 00/17] Add Nested Translation Support for SMMUv3
Message-ID: <ZGJWgFVJDWxVpiBE@Asurada-Nvidia>
References: <cover.1683688960.git.nicolinc@nvidia.com>
 <CABQgh9FL4ssQjBJM52_kb0aBVVPb_9Wc0Q+NL1PaQO=2LYBHCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CABQgh9FL4ssQjBJM52_kb0aBVVPb_9Wc0Q+NL1PaQO=2LYBHCA@mail.gmail.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT015:EE_|LV3PR12MB9093:EE_
X-MS-Office365-Filtering-Correlation-Id: e48d40ec-0f4e-4946-af04-08db555d2ea2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SKe7LsCQHX7Y3rHey3Syi2/3rjtRGNDLi8ArCTEuK9FHJrfvNa7UJzxxDBXlqYclWYPNb3cGYtDrywjcLiNhNNa1cCI/hrTg1XPybrwJSgcHIu7tbMGLnjBjrwhLsIjL65F6JSa/+PbxU23c9znvIvwYbUTnwM3u11bi2fyPjHYDwo5a7s4z7AfpPw130Fw5l249tCGyN0YdRDW0GtLB9CdSmKeRV8LGqFa/I5TCqXZWQqLPPhGGYb5MynEgjAzA3xcYqE5kO+Mok9maSQmu7fVMyVoYmAwKWSvaH7XfJfZTYn+o1NFDwiZlRwCQb9IbYs6zsCg8ZV+hwu04p2MEM5p9f+WtBWsHyUkWR5YOct61EuwT01kxeexZ4lqCFFvJBNgvMZep1zGbLnSVxQ2xJijATRyNXvrZDiynSaROWIFzFHN6nzR6xWpdw9KKxZLvXCHt8F419D/PNaZBUyzOtm6j6qh/7qqWkRYXILTOLFkHJ01Qg66Yn14w9ZeF4F2dCdV0OnKasISNZWxksrt6B6w+aRQ/CiOfUNOaIq3+9K4jQOm/cE17ClPziFe5gPbZJ1opkR96f1pAeiEhUCtJpnn+FKG6JDy6FeU85juMUd5mXWxB+z9Enpl58Qf5py1voNUfxWWl2Rv59paKNI8GvpsVez5RQSAoYjcxGfoo+HBBvZ0Sel9nXKMo8ChJosOceB03vpjcs5AFThdIvTnFoELdNIUILHbKW2e+dlwW/Gjhluir9FoOP1iqvGltZof1w9K+CKhZPWlF/h2aGG7tTp0Z7QIvMdcvEDx3W0o2KJ3xs20721f1tWrdd2c3ROsh
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(396003)(376002)(39860400002)(451199021)(46966006)(40470700004)(36840700001)(33716001)(336012)(47076005)(36860700001)(426003)(9686003)(316002)(70586007)(70206006)(55016003)(26005)(966005)(40480700001)(478600001)(54906003)(2906002)(86362001)(186003)(7416002)(8676002)(8936002)(40460700003)(5660300002)(356005)(82740400003)(4326008)(6916009)(41300700001)(7636003)(82310400005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2023 15:58:10.3915
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e48d40ec-0f4e-4946-af04-08db555d2ea2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT015.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9093
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Zhangfei,

On Mon, May 15, 2023 at 06:00:26PM +0800, Zhangfei Gao wrote:
 
> I rebased on these two branches and did some basic tests.
> 
> The basic functions work after backport
> iommufd: Add IOMMU_PAGE_RESPONSE
> iommufd: Add device fault handler support
> 
> https://github.com/Linaro/linux-kernel-warpdrive/tree/uacce-devel-6.4
> https://github.com/Linaro/qemu/tree/iommufd-6.4-nesting-smmuv3-v2

Thanks for testing!

> However when debugging hotplug PCI device, it still does not work,
> Segmentation fault same as 6.2.
> 
> guest kernel
> CONFIG_HOTPLUG_PCI_PCIE=y
> 
> boot guest (this info does not appear in 6.2)
> qemu-system-aarch64: -device
> vfio-pci,host=0000:76:00.1,bus=pci.1,addr=0x0,id=acc1,iommufd=iommufd0:
> Failed to set data -1
> qemu-system-aarch64: -device
> vfio-pci,host=0000:76:00.1,bus=pci.1,addr=0x0,id=acc1,iommufd=iommufd0:
> failed to set device data

Hmm.. I wonder what fails the set_dev_data ioctl...

> $ sudo nc -U /tmp/qmpm_1.socket
> (qemu) info pci
> (qemu) device_del acc1
> 
> guest:
> qemu-system-aarch64: IOMMU_IOAS_UNMAP failed: No such file or directory
> qemu-system-aarch64: vfio_container_dma_unmap(0xaaaae1fc0380,
> 0x8000000000, 0x10000) = -2 (No such file or directory)

This is resulted from the following commit that we should
drop later:

commit c4fd2efd7c02dd30491adf676c1b0aed67656f36
Author: Yi Liu <yi.l.liu@intel.com>
Date:   Thu Apr 27 05:47:03 2023 -0700

    vfio/container: Skip readonly pages

    This is a temparary solution for Intel platform due to an errata in
    which readonly pages in second stage page table is exclusive with
    nested support.

    Signed-off-by: Yi Liu <yi.l.liu@intel.com>


> qemu-system-aarch64: Failed to unset data -1
> Segmentation fault (core dumped).  // also happened in 6.2

Hmm, would it be possible for you to run the test again by
adding the following tracers to your QEMU command?
    --trace "iommufd*" \
    --trace "smmu*" \
    --trace "vfio_*" \
    --trace "pci_*"

Thanks
Nic
