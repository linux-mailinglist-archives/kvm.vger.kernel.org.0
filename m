Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 686F2569123
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 19:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234139AbiGFRyD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 13:54:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234116AbiGFRx7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 13:53:59 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2040.outbound.protection.outlook.com [40.107.102.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E57C91F627;
        Wed,  6 Jul 2022 10:53:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h6dElNbeca8U2EpeecwxtaCw4HJNBVCmldzvbEeSjB1Ef+qtEhBDLVVVkvETuKtwwWS6MKQ/72uGqb+3Z3dRFl5PetcdinvQiiKScgwf/qtSeQk1ggsfpsJ6CwM9zV3Ec7d01litNhO8/ovbNt1FDR+PkYY5nXlWBFpfgWcb/haoxEV29fhM28IneEDb7hACCzmY4T1iJ6EIN21IdGIJsrQIBLpdvABz0tn/xs75c1y8G2fIGdoNbDDHVcQ3ib7rtr/1JCxFeKnvxLYLrUy17w6sXLx0v0oymKrHx2SLuMJipb7ZpQXm34mt6adQ347TtW+6QmkasSr7CRhKpQ01Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YQPVPIuhkcS7tuL1RwC5N21Hr8Gq0dHikBkRvlIB6C8=;
 b=IPcAWEUdpSKp9YOkFYtGVsIKHYOxu4Hu9Yjqk5yCO6EoM16tCAk2ezfJ0s2iprvS1dQ12PMtTPZWkKIai0GvpD8VqqJOqHlDXPOk5xf9Aopro/oDpXXPjuSjp70okK1gQVfiFK+mTV/pZG3zA7IrSPO1ssVJCRslc6jKvtx05Lq/b87RLS1WDI8dOwI6f1bKbGb97p7sGVpz9SvCgrjBp+Zb7MGMkYoJPQoEV9Z2WOj2aU+Y4pgDajdROXAtSxd+XEq2HiSrKSbmyAYATmzNrBnT4Yf5vEDJIxQEF6TxGEsFkeeWnAQGxWxfYwWTYM/Xw3G2VMC/eVlg29RtVO2HVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YQPVPIuhkcS7tuL1RwC5N21Hr8Gq0dHikBkRvlIB6C8=;
 b=ud4Y92zYyTHuoWCV+fCn7SPHgoZWmetAD3+4rBOZln7Em62zPlurbFnRpIS7qU9i3+6ogh97Dam3t2THlaNmwj/i4XS5UUXVj66jSg+sekJXbalOfWQwJwMLRhHZT7XX1tKXHF7xr72NnhZfxRN1Z/5gek+IIPoZsgJmbdlCIbAjfuYn5iHC1lkyJpWckE8wxNzWCXt78sxCyCB6vvSSiCMKk49tYDPmeuvubSG6tFviSvCDRLWl2iT14xEmkSP3UJ5C2UqXNUrOqKjcGLv/WgNb32cFnmS+5YV3dfqV7tgrX0jB8ZyBJ5xAUHnFIedMrcsMr2PbQGA0tofWGPfRNA==
Received: from MWHPR10CA0050.namprd10.prod.outlook.com (2603:10b6:300:2c::12)
 by DM4PR12MB5280.namprd12.prod.outlook.com (2603:10b6:5:39d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Wed, 6 Jul
 2022 17:53:57 +0000
Received: from CO1NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:2c:cafe::e0) by MWHPR10CA0050.outlook.office365.com
 (2603:10b6:300:2c::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.15 via Frontend
 Transport; Wed, 6 Jul 2022 17:53:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT040.mail.protection.outlook.com (10.13.174.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5417.15 via Frontend Transport; Wed, 6 Jul 2022 17:53:56 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 6 Jul
 2022 17:53:56 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 6 Jul 2022
 10:53:55 -0700
Received: from Asurada-Nvidia (10.127.8.14) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Wed, 6 Jul 2022 10:53:53 -0700
Date:   Wed, 6 Jul 2022 10:53:52 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <joro@8bytes.org>, <will@kernel.org>, <marcan@marcan.st>,
        <sven@svenpeter.dev>, <robin.murphy@arm.com>,
        <robdclark@gmail.com>, <baolu.lu@linux.intel.com>,
        <orsonzhai@gmail.com>, <baolin.wang7@gmail.com>,
        <zhang.lyra@gmail.com>, <jean-philippe@linaro.org>,
        <jgg@nvidia.com>, <kevin.tian@intel.com>,
        <suravee.suthikulpanit@amd.com>, <alyssa@rosenzweig.io>,
        <dwmw2@infradead.org>, <mjrosato@linux.ibm.com>,
        <gerald.schaefer@linux.ibm.com>, <thierry.reding@gmail.com>,
        <vdumpa@nvidia.com>, <jonathanh@nvidia.com>, <cohuck@redhat.com>,
        <thunder.leizhen@huawei.com>, <christophe.jaillet@wanadoo.fr>,
        <chenxiang66@hisilicon.com>, <john.garry@huawei.com>,
        <yangyingliang@huawei.com>, <iommu@lists.linux.dev>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-arm-msm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 0/5] cover-letter: Simplify vfio_iommu_type1
 attach/detach routine
Message-ID: <YsXMMCX5LY/3IOtf@Asurada-Nvidia>
References: <20220701214455.14992-1-nicolinc@nvidia.com>
 <20220706114217.105f4f61.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220706114217.105f4f61.alex.williamson@redhat.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2af2284f-cf26-432e-ddd3-08da5f787f9f
X-MS-TrafficTypeDiagnostic: DM4PR12MB5280:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TA6wmf5iv/NwH5LQQ58dPM/DvO5uz7Yh1C0R2KST3NMbv4AQzL90/oeDyL1KpdObs1vpFSknxYoy0S0Tee12I1dqk+RQNkl+nwq77CuK7+gM6J9NSp2v3BGjjB1ryB00PtsmAPmQr8YketWLJc80tKUiPGEEIz4JdPOhmjmZGeoCZ9nnKLmgz5kwEV+S12ESYVkV43VboCtErWvtDZ0ogXjGs1qh67yXyljBTqKxOLofuYbgaKOEpXjTbdrfVd8X0tblRVPOKMRxgOQaxVV9yxRVpWxAkNBDZgNHciiIMETu726AoQK52N2RBrHbfjVCFUXgBA/Z4VX7Yua2VgJ+0xJTm61RPWoQtk5xkP2MLO2I+9SPGL7rHqhcsXIhBpKePcpVZl/pXj+yU28AyQ344H692t0L7w8/oHnzVFknp4Gz+ks4fATr1wqDYxcC5t/pvgf+/9JeAlM9qjbyDGEI2inakiThuMnhMSKvQPDxI4ai8RfemdbmvmpjOd9D0XpGDrhUk7ZZrzRN2fAmhq9AxpXUropc0+KEDDeoRYWYCMSoiDvNzRboFLzX4MqQI88osr0qL/pred/PL663aVoA3ozBAAYpfe1x5J5MHVpTAPBRAGwwxZmeNCeO7XLGnogF2eWlJSqwUxyDFZ1ADQPIbq8MBJ2/wTTSNzTAe75Nvaj72nPbUHjNeuUP6ZIvm82AiMxHxWIZgu9TeK+qRCaiI8OyX/jBXrXVk/BTP2Tl8C85Ojwo3T9Q9rTGq6Zwdg7oPp4KCRYw95r7NGYJU00DMVU5EE0EasoI0mMKSJ74MzyBvafoH2znwtaqH+o6WDfA7DHioabxYaExfmx/TFriXXaXfRFfg0oC48Y2MuHQzIvEi6YGycJbNQl88DXkFtRgpYUaLeZqRBvFn4MhRzguyDsuxapRYRWPX5Vbnw31dKGKdv8kiQYFzRB4Zfsaf2Zu
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(39860400002)(396003)(136003)(36840700001)(46966006)(40470700004)(47076005)(336012)(426003)(54906003)(83380400001)(6916009)(36860700001)(40460700003)(186003)(41300700001)(82740400003)(316002)(82310400005)(4326008)(70206006)(5660300002)(7416002)(7406005)(9686003)(8936002)(81166007)(356005)(966005)(478600001)(86362001)(33716001)(26005)(40480700001)(2906002)(70586007)(8676002)(55016003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2022 17:53:56.7150
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2af2284f-cf26-432e-ddd3-08da5f787f9f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5280
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 06, 2022 at 11:42:17AM -0600, Alex Williamson wrote:

> On Fri, 1 Jul 2022 14:44:50 -0700
> Nicolin Chen <nicolinc@nvidia.com> wrote:
> 
> > This is a preparatory series for IOMMUFD v2 patches. It enforces error
> > code -EMEDIUMTYPE in iommu_attach_device() and iommu_attach_group() when
> > an IOMMU domain and a device/group are incompatible. It also drops the
> > useless domain->ops check since it won't fail in current environment.
> >
> > These allow VFIO iommu code to simplify its group attachment routine, by
> > avoiding the extra IOMMU domain allocations and attach/detach sequences
> > of the old code.
> >
> > Worths mentioning the exact match for enforce_cache_coherency is removed
> > with this series, since there's very less value in doing that as KVM will
> > not be able to take advantage of it -- this just wastes domain memory.
> > Instead, we rely on Intel IOMMU driver taking care of that internally.
> >
> > This is on github:
> > https://github.com/nicolinc/iommufd/commits/vfio_iommu_attach
> 
> How do you foresee this going in, I'm imagining Joerg would merge the
> first patch via the IOMMU tree and provide a topic branch that I'd
> merge into the vfio tree along with the remaining patches.  Sound
> right?  Thanks,

We don't have any build dependency between the IOMMU change and
VFIO changes, yet, without the IOMMU one, any iommu_attach_group()
failure now would be a hard failure without a chance falling back
to a new_domain, which is slightly different from the current flow.

For a potential existing use case that relies on reusing existing
domain, I think it'd be safer to have Joerg acking the first change
so you merge them all? Thank!
