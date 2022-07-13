Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0B8A57404B
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 01:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbiGMX5m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 19:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiGMX5k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 19:57:40 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2065.outbound.protection.outlook.com [40.107.93.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4C6E53D16;
        Wed, 13 Jul 2022 16:57:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F2FT1kk1/BdPiQpn8wJ0On0/QkqFa32x7QWB3/EfcF4l2/1/+XRPhkt6aYfLPctjvRPPwJzsaWk3SUL8w7H5EwaoGLbigWl6zx+LWbP9kb/V0UJS1AVHuy2WP2dLIQKTnrfkbkn0Rz6gE5inyEqx6m02mmPfY3K/qaNHR1GBPiAM4H1/CPRpIBBTxWKY/WgmdXpQv/1kfNBWShE2DhLHk1iR8P/IWCQOPJbrWObJzuCqyCbfK/GOWKF62pwhcKpH4Nj0dC2dmWHeAyX4Hlyu2SxgorCncjEAj3HE1VTkSi/3Xosvox7qtU44SnM2eCIh0MVgrcCcJVIy3MJuS6ci5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J7z8LWlPotPhYXvrQ6ceYiFG0tG3FYUbgZXWcDIauRw=;
 b=XUxPhtdBl0SUkNc4pDUx6rEYarIeIrAVm/bIGynsfn5UJv/DxgNjz6IzFFJajNYRciJZBROYAW4k8b2suiBzV1/2lv2GoHQsn/RvQndNbEvc5lwF554eDh5mFyPl6qCEkY8PfhfpNea5uMZ5Kot3Kj7ZtYNkuYhJlSskHGb5ofdOjnfXwmAgcNU9dDEWdLWfJyVwvcafUTQQ4Xi1DHD06IWn7JmqKe87DONGNs2MOcaHKklkRm92bBHaBmkIVw+vVvGQAuWUXF5gAJesn8RhElZMld+TwZ6W9+fl5CB0Sc/I+m9VD0xGDLzGIZQsg+vyf4KIQ0ycaX4NG/MwGOhdgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J7z8LWlPotPhYXvrQ6ceYiFG0tG3FYUbgZXWcDIauRw=;
 b=U4ITf6oa3UcnRBkWu6LO/zYrlPrgMyOZDCvcXnH0wl00AeBSLgnujHPRADLrsIxaleQ2s36gEWt+WgbhOAm0RyIAREJG5wPFy3zO9+RJ+pdSVKFAwNbMLUM6JpgRbP80wSf+kgtEn0Wg51hSSu/bN3nwqoAAkIwsRyYVnbs2J6sINTsoZ33/8C+B7OBf/l4IboWHi2hY+EIIOo3OiDRpqP0KQ2XjaI/cvLqjHvBee6fU3RXDGStvdGFvQEV84Nk3FIJ99Yz5KDsP1IIKlHGxkBQoi2yyfJtSG8JR8sJAZ5fIBNov1V55jaYuPmvwW8VueCYu48JJt3hW+m2CoBmX3Q==
Received: from BN9PR03CA0095.namprd03.prod.outlook.com (2603:10b6:408:fd::10)
 by SA1PR12MB5638.namprd12.prod.outlook.com (2603:10b6:806:229::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.21; Wed, 13 Jul
 2022 23:57:37 +0000
Received: from BN8NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fd:cafe::71) by BN9PR03CA0095.outlook.office365.com
 (2603:10b6:408:fd::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26 via Frontend
 Transport; Wed, 13 Jul 2022 23:57:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT040.mail.protection.outlook.com (10.13.177.166) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5438.12 via Frontend Transport; Wed, 13 Jul 2022 23:57:37 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 13 Jul
 2022 23:57:36 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 13 Jul
 2022 16:57:35 -0700
Received: from Asurada-Nvidia (10.127.8.13) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Wed, 13 Jul 2022 16:57:34 -0700
Date:   Wed, 13 Jul 2022 16:57:32 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     <joro@8bytes.org>, Alex Williamson <alex.williamson@redhat.com>
CC:     <will@kernel.org>, <marcan@marcan.st>, <sven@svenpeter.dev>,
        <robin.murphy@arm.com>, <robdclark@gmail.com>,
        <baolu.lu@linux.intel.com>, <orsonzhai@gmail.com>,
        <baolin.wang7@gmail.com>, <zhang.lyra@gmail.com>,
        <jean-philippe@linaro.org>, <jgg@nvidia.com>,
        <kevin.tian@intel.com>, <suravee.suthikulpanit@amd.com>,
        <alyssa@rosenzweig.io>, <dwmw2@infradead.org>,
        <mjrosato@linux.ibm.com>, <gerald.schaefer@linux.ibm.com>,
        <thierry.reding@gmail.com>, <vdumpa@nvidia.com>,
        <jonathanh@nvidia.com>, <cohuck@redhat.com>,
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
Message-ID: <Ys9b7GSImp/sHair@Asurada-Nvidia>
References: <20220701214455.14992-1-nicolinc@nvidia.com>
 <20220706114217.105f4f61.alex.williamson@redhat.com>
 <YsXMMCX5LY/3IOtf@Asurada-Nvidia>
 <20220706120325.4741ff34.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220706120325.4741ff34.alex.williamson@redhat.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e132a6f9-c9a7-4f8e-9a24-08da652b7689
X-MS-TrafficTypeDiagnostic: SA1PR12MB5638:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aa8p8HShc//3A7rH7/TM0CGDp72gv84y1x2PNdYVcx+3D5f/eyPlyydxMpUEQ5QgSldZTWoUDUw3KQAF5pFD5cngfIVMKrnGX4hAyhCJV0KFuC9vyJZ4+ccoW46NQCn9P/v41nXyDpbE8mBgTARYj+UOlPsSn9XVkLsoHsdyd5B5RVf+YhGeK/h15tYgLTNHredsVwoTQqOnaOYz8IwO9B5rMHk+HjgBoU746w4HcWZvkAd2eCU+KlnR1nilhbRJlRkk20soZiDlBALHy0nuWo1iDepNS9SGdHWR4vVN7zBhXUmgSP2lAIwxArGBGxRxCQ+Noga1SWqJN/q0xDoY82BEEUaDsF/ZrXPVSFrTHrsUo3AeJWjOL4FYx9Y0x+egLoNbOwH+4YZP+GMZdxNTh3gs7uDY+NE9hwZHkEDLzQ8TiBZdtYZCMQTz7vSbGqWL0OGdquM199MbvzMqZIIqvAygKhUmvixdcRhx0sxJI1zQFEsutsXbTx29KYtp19f60FHyEBJbPLftCnnqqZhEx7hu9yH+4KtGr9d35/TmJJ5sJtl4sXceFsgbuiKO5KWDoEkv1e8EfFRSI8Q4HOqRJAEwzPMJYXHsQ3k+mni5ZzIzPdL13EORm0JGdfwvtmR8edVUNDVIyJq5KMnYRjx23f9uIWWCSbHtI7i8QKF9R6bGUTr9xHck8JcX974po0vedlVhVhaCj4UaL5o9I2/F8xFL8Kr3s6jaBDO9erhT7cZHfQyEAi4c8hFlAUawiVZAJ02UwW+3TQBkuxUchUJmYshejBGMTj59bgDvho32bF37FyV1ynDXP/kFiS/n6Rbrwypv6X2YwCMbfwroEsOY3J3SEP4DNQM1beG+3FjIBmAd8M1vF3nboXGBgomxvhonpqS+s1g2hFAdvRaYYHZEpZfvLPD2KIdpH0oXaTP2cxyzU2NWLGThAEswn3SQbT92
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(376002)(39860400002)(396003)(36840700001)(46966006)(40470700004)(8936002)(7416002)(9686003)(7406005)(110136005)(83380400001)(26005)(55016003)(54906003)(186003)(5660300002)(47076005)(478600001)(336012)(316002)(426003)(966005)(8676002)(2906002)(41300700001)(36860700001)(40480700001)(81166007)(33716001)(82740400003)(40460700003)(82310400005)(356005)(4326008)(86362001)(70206006)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2022 23:57:37.1356
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e132a6f9-c9a7-4f8e-9a24-08da652b7689
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5638
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 06, 2022 at 12:03:25PM -0600, Alex Williamson wrote:

> On Wed, 6 Jul 2022 10:53:52 -0700
> Nicolin Chen <nicolinc@nvidia.com> wrote:
> 
> > On Wed, Jul 06, 2022 at 11:42:17AM -0600, Alex Williamson wrote:
> >
> > > On Fri, 1 Jul 2022 14:44:50 -0700
> > > Nicolin Chen <nicolinc@nvidia.com> wrote:
> > >
> > > > This is a preparatory series for IOMMUFD v2 patches. It enforces error
> > > > code -EMEDIUMTYPE in iommu_attach_device() and iommu_attach_group() when
> > > > an IOMMU domain and a device/group are incompatible. It also drops the
> > > > useless domain->ops check since it won't fail in current environment.
> > > >
> > > > These allow VFIO iommu code to simplify its group attachment routine, by
> > > > avoiding the extra IOMMU domain allocations and attach/detach sequences
> > > > of the old code.
> > > >
> > > > Worths mentioning the exact match for enforce_cache_coherency is removed
> > > > with this series, since there's very less value in doing that as KVM will
> > > > not be able to take advantage of it -- this just wastes domain memory.
> > > > Instead, we rely on Intel IOMMU driver taking care of that internally.
> > > >
> > > > This is on github:
> > > > https://github.com/nicolinc/iommufd/commits/vfio_iommu_attach
> > >
> > > How do you foresee this going in, I'm imagining Joerg would merge the
> > > first patch via the IOMMU tree and provide a topic branch that I'd
> > > merge into the vfio tree along with the remaining patches.  Sound
> > > right?  Thanks,
> >
> > We don't have any build dependency between the IOMMU change and
> > VFIO changes, yet, without the IOMMU one, any iommu_attach_group()
> > failure now would be a hard failure without a chance falling back
> > to a new_domain, which is slightly different from the current flow.
> >
> > For a potential existing use case that relies on reusing existing
> > domain, I think it'd be safer to have Joerg acking the first change
> > so you merge them all? Thank!
> 
> Works for me, I'll look for buy-in + ack from Joerg.  Thanks,
> 
> Alex

Joerg, would it be possible for you to ack at the IOMMU patch?

Thanks!
Nic
