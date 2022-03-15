Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 777434D9529
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 08:23:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345364AbiCOHYr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 03:24:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232959AbiCOHYo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 03:24:44 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2058.outbound.protection.outlook.com [40.107.223.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EE4A3A722;
        Tue, 15 Mar 2022 00:23:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cIKra04QDIxuisVE0sK+wz1aOoV7xjUfkDy6SAEaWEKSOl/w4Qg3t7GctlY0/F4ZOW0Ev8GppKceXs4TgIvMhQ2Pw40/AVOZIuKwrh1baSmcCnoDlCKGnCn4TfbiwF9BtvhnA2iD27J7wgO4/4hAIbEG/7E9RF78bNlo0RdCJR+ON6iJufz5Z/cZ4HeFFx53ZB/xKTHYwSWBxnkEF9a4XFPAyFqAhzWzYcgTcG4SfziinIwznC3G24OSLO5OO0DEaXU86v6IpTqulvnFN7vIm/IypwcpgYnPd6gim4YwIRqV4CH0n4Rd2s056U5mcvnJAottac8scWz8ItSTyGP8ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UXvmna2U+dRzug8/Omycr9FyHrMYczlvZb6af37+haE=;
 b=aTcSulhhTDWZzkAFoPHTZZ3xrg5wsRKOqWd7dFd7bFuWEpKyQ5riNn0pIal5drbF2ibGxv83hk2GGTjgIQWWHVUvVQ7pSog7N62wBs6TnUYPjmvLhByf+gMdjRDFyuFNKhb6qDpXFuCnnx7xNqrKNIobzo+xJnSIZIUizQH2ldIPlB+1TGPM9oZuuXnbs4jpD1ch5CnE+06/R5naGUGiFpCtQBAG713U2eBg1xfRw2/LUVoSd6fQ19XQ8qDHkH6JeM726g3+MyJMIrhDXJmccWPbxWecnIIQsoi9MS7USaEJJMf55cVy9bY2r7aOJZR7z47D1t4gAPfWS712xg9lQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UXvmna2U+dRzug8/Omycr9FyHrMYczlvZb6af37+haE=;
 b=okS4BDqztT1a1Ynpe0q9ITTYa5H8W0txy5LAn5YDo4kJtgcZsXmHo3JGax0aEQ3K1w0T/qpmU4AcQp2c8Z7Gk8XVoCnQeTS7BH9a50MW8V12maCCvAl42GkahX5aQFnDzEZn1FbgiW6ho5BYpHo+pc8PCxwYW0JdQ0K/xOfu0KFXGue7krPeBBiSYU4nhTVN47s0dU35B3/cWL6RfP0s2zuat+FdcQY7sEHTB/emudl8e/xhFsfoum7FTPt/WNNzzNTpu2H16vJhT7l6+M8+3ppneOX1DcjQWdpSsOECoD4q8PP1JhxNxVzN81+W2m5kG2MlBafttSxjg3ngkb1sLA==
Received: from MWHPR1201CA0021.namprd12.prod.outlook.com
 (2603:10b6:301:4a::31) by MWHPR1201MB0078.namprd12.prod.outlook.com
 (2603:10b6:301:56::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.26; Tue, 15 Mar
 2022 07:23:30 +0000
Received: from CO1NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:4a:cafe::e1) by MWHPR1201CA0021.outlook.office365.com
 (2603:10b6:301:4a::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.21 via Frontend
 Transport; Tue, 15 Mar 2022 07:23:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT037.mail.protection.outlook.com (10.13.174.91) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5061.22 via Frontend Transport; Tue, 15 Mar 2022 07:23:29 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 15 Mar
 2022 07:23:28 +0000
Received: from [172.27.14.19] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 15 Mar
 2022 00:23:24 -0700
Message-ID: <4b9b242a-c36c-dbb1-70d7-48e5314b2967@nvidia.com>
Date:   Tue, 15 Mar 2022 09:23:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH v3] vfio-pci: Provide reviewers and acceptance criteria
 for vendor drivers
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <linux-kernel@vger.kernel.org>, <jgg@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
        <linux-doc@vger.kernel.org>, <corbet@lwn.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <164728932975.54581.1235687116658126625.stgit@omen>
From:   Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <164728932975.54581.1235687116658126625.stgit@omen>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 87dbe575-fe97-452e-fe66-08da0654b462
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0078:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1201MB007877A0DC19161EE7AE39F1C3109@MWHPR1201MB0078.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VIQBD7uDSH5lDGKOCl40HyyxMZBKcUXNJqqamp0m9mERKr9lEVoU0+VryYC5uT7klEvfe2QSunU1rW+KZvHEUxGXXIpO0BvVtbLDCTe6T8xAWiPWHT7l47j1H28nEaheqm4OPj5gIe86Ihnst8aBOPmoc5ENgcvPvrdKDDFQrUwwKUjyxKWZ0hWPhtza1NVNNHBhYUTRPi48JZfuINvS09h6bjm0NvtsGQJaD9cQdb45bLpTgF1rYgCZVVLe4Co1K4KMQ1dIauwMrJ4a26gvWWWaR+JnEhLFpko5kbqqSE4cfBJ0T1NRmRZdIVrYjlwhXxJwwOj/Ztohrgp7aMysDokO9aDRp5xMP7jMtFCtbXP2pL9PTBqgCZduXoL56ik7a05zKXepXKbv6aoNWw0t9LWuUZJ29pHOXz5kq/JI46uMqQ43LEvDl3kGb0NTpoHua+G9Z4PZxpoK0eigZatpQ6ZBFTrvfP6QXjOaCGPHtcSJZwLPOZWRw4YvgMFpPhssPkHOc0FFl6Rw/pGjdQ8q1bnBdNa+4ZJi9TYSL6EFf6Drbw0rd1i9V79su4kMenf/d5lMYVyLN0IoPfAdcnby7XoQGTkRZbYHtT0ZsIx7UdxGpleDi47riWVTHZUMkalRAIRDUqnWe2F96LgAkn7tuGv45G+zuhYcxdf5CXVwtTJ4OkFx2f3PnVVxJx05jjQwnkeoiqcJW+1X3M8PjKvk4ZEfMbyo11k3+xbxXpiH9Q7Oo0sn1J71N6gdG7CjyvZwPn0cBIFUas5qHrRdWd14IWzNU1jX3s9RKIBLMQB0MHsL9sc6DbvVRNYKmmpdMnW23UJVWAue4KVkt2ACJdfJgA==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(53546011)(8936002)(6666004)(8676002)(5660300002)(70586007)(70206006)(86362001)(26005)(508600001)(186003)(16526019)(4326008)(82310400004)(40460700003)(31696002)(2616005)(2906002)(45080400002)(356005)(336012)(36860700001)(81166007)(54906003)(6916009)(31686004)(426003)(316002)(16576012)(36756003)(83380400001)(47076005)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2022 07:23:29.8658
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 87dbe575-fe97-452e-fe66-08da0654b462
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0078
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/14/2022 10:24 PM, Alex Williamson wrote:
> Vendor or device specific extensions for devices exposed to userspace
> through the vfio-pci-core library open both new functionality and new
> risks.  Here we attempt to provided formalized requirements and
> expectations to ensure that future drivers both collaborate in their
> interaction with existing host drivers, as well as receive additional
> reviews from community members with experience in this area.
>
> Cc: Jason Gunthorpe <jgg@nvidia.com>
> Cc: Yishai Hadas <yishaih@nvidia.com>
> Cc: Kevin Tian <kevin.tian@intel.com>
> Acked-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

Reviewed-by: Yishai Hadas <yishaih@nvidia.com>

> ---
>
> v3:
>
> Relocate to Documentation/driver-api/
> Include index.rst reference
> Cross link from maintainer-entry-profile
> Add Shameer's Ack
>
> v2:
>
> Added Yishai
>
> v1:
>
> Per the proposal here[1], I've collected those that volunteered and
> those that I interpreted as showing interest (alpha by last name).  For
> those on the reviewers list below, please R-b/A-b to keep your name as a
> reviewer.  More volunteers are still welcome, please let me know
> explicitly; R-b/A-b will not be used to automatically add reviewers but
> are of course welcome.  Thanks,
>
> Alex
>
> [1]https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fall%2F20220310134954.0df4bb12.alex.williamson%40redhat.com%2F&amp;data=04%7C01%7Cyishaih%40nvidia.com%7Cf97af54aedc341708d6f08da05f8b34b%7C43083d15727340c1b7db39efd9ccc17a%7C0%7C0%7C637828862983240522%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=aQQY6NWJ65p%2B6nyzMXu9VUpOFi1ZClrSW0fQZbLWuoE%3D&amp;reserved=0
>
>   Documentation/driver-api/index.rst                 |    1 +
>   .../vfio-pci-vendor-driver-acceptance.rst          |   35 ++++++++++++++++++++
>   .../maintainer/maintainer-entry-profile.rst        |    1 +
>   MAINTAINERS                                        |   10 ++++++
>   4 files changed, 47 insertions(+)
>   create mode 100644 Documentation/driver-api/vfio-pci-vendor-driver-acceptance.rst
>
> diff --git a/Documentation/driver-api/index.rst b/Documentation/driver-api/index.rst
> index c57c609ad2eb..da1372c8ec3d 100644
> --- a/Documentation/driver-api/index.rst
> +++ b/Documentation/driver-api/index.rst
> @@ -103,6 +103,7 @@ available subsections can be seen below.
>      sync_file
>      vfio-mediated-device
>      vfio
> +   vfio-pci-vendor-driver-acceptance
>      xilinx/index
>      xillybus
>      zorro
> diff --git a/Documentation/driver-api/vfio-pci-vendor-driver-acceptance.rst b/Documentation/driver-api/vfio-pci-vendor-driver-acceptance.rst
> new file mode 100644
> index 000000000000..3a108d748681
> --- /dev/null
> +++ b/Documentation/driver-api/vfio-pci-vendor-driver-acceptance.rst
> @@ -0,0 +1,35 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +Acceptance criteria for vfio-pci device specific driver variants
> +================================================================
> +
> +Overview
> +--------
> +The vfio-pci driver exists as a device agnostic driver using the
> +system IOMMU and relying on the robustness of platform fault
> +handling to provide isolated device access to userspace.  While the
> +vfio-pci driver does include some device specific support, further
> +extensions for yet more advanced device specific features are not
> +sustainable.  The vfio-pci driver has therefore split out
> +vfio-pci-core as a library that may be reused to implement features
> +requiring device specific knowledge, ex. saving and loading device
> +state for the purposes of supporting migration.
> +
> +In support of such features, it's expected that some device specific
> +variants may interact with parent devices (ex. SR-IOV PF in support of
> +a user assigned VF) or other extensions that may not be otherwise
> +accessible via the vfio-pci base driver.  Authors of such drivers
> +should be diligent not to create exploitable interfaces via such
> +interactions or allow unchecked userspace data to have an effect
> +beyond the scope of the assigned device.
> +
> +New driver submissions are therefore requested to have approval via
> +Sign-off/Acked-by/etc for any interactions with parent drivers.
> +Additionally, drivers should make an attempt to provide sufficient
> +documentation for reviewers to understand the device specific
> +extensions, for example in the case of migration data, how is the
> +device state composed and consumed, which portions are not otherwise
> +available to the user via vfio-pci, what safeguards exist to validate
> +the data, etc.  To that extent, authors should additionally expect to
> +require reviews from at least one of the listed reviewers, in addition
> +to the overall vfio maintainer.
> diff --git a/Documentation/maintainer/maintainer-entry-profile.rst b/Documentation/maintainer/maintainer-entry-profile.rst
> index 5d5cc3acdf85..8b4971c7e3fa 100644
> --- a/Documentation/maintainer/maintainer-entry-profile.rst
> +++ b/Documentation/maintainer/maintainer-entry-profile.rst
> @@ -103,3 +103,4 @@ to do something different in the near future.
>      ../nvdimm/maintainer-entry-profile
>      ../riscv/patch-acceptance
>      ../driver-api/media/maintainer-entry-profile
> +   ../driver-api/vfio-pci-vendor-driver-acceptance
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 4322b5321891..fd17d1891216 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -20314,6 +20314,16 @@ F:	drivers/vfio/mdev/
>   F:	include/linux/mdev.h
>   F:	samples/vfio-mdev/
>   
> +VFIO PCI VENDOR DRIVERS
> +R:	Jason Gunthorpe <jgg@nvidia.com>
> +R:	Yishai Hadas <yishaih@nvidia.com>
> +R:	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> +R:	Kevin Tian <kevin.tian@intel.com>
> +L:	kvm@vger.kernel.org
> +S:	Maintained
> +P:	Documentation/driver-api/vfio-pci-vendor-driver-acceptance.rst
> +F:	drivers/vfio/pci/*/
> +
>   VFIO PLATFORM DRIVER
>   M:	Eric Auger <eric.auger@redhat.com>
>   L:	kvm@vger.kernel.org
>
>

