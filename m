Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10562563836
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 18:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232564AbiGAQnT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 12:43:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiGAQnR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 12:43:17 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2051.outbound.protection.outlook.com [40.107.101.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91BAB1CFC1;
        Fri,  1 Jul 2022 09:43:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A8AEb8XbrJmBWLqZ+/Lr/Fypl7HFl3Rg+e3NJIuVpIgkCxzOHOrwmPvVRXOUE5p6IljzHbJpl403m88wxHFHHg5hlMwAZOv/RutSlq3mRKOVQeH9A+u/TRwsGgzVxNnkwUvG19R0K7LY+aKu7GRV0g+24e17TXIwUfOJ5spwBtO8Jvjpme3X/B99xwjJYmrc/QKQv9t4OMBI5Oz1Xb1upET5YMY5z3e5sBZvDWO/WiZ3bRRkUATb1u5hr2KgME6/5/xywpcj9PBL/cAjrdbiRiMX4Q80rxyH8qmZdajydLp//67WRlBMPwnjFtOQmL/LeoImPA4qVFzayPByagNmHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J96Z1IiyrT4233SGqgBUZQywiRvohREcngH7MVSfyIk=;
 b=XBhYvivFekujPTqwmR0Dmm2b9LZUFb96vFK0jbhuNfLIHAhcwJ56FoGwcGc7L7aDOYrWu/7Q+c8N8ZlQV0M+MQKf8ViLjcpa0nkL61dXhEidAV3NfM5Ic7e8E33ooasOfuJHN/owb5Tio3L143j5S7k37CEFKeuqV2OVSTSJbCoNhChAyh8zn7Vv9JshSsw8M8p2f1ZEDB+JzQqNQTX8unpvB34b+GWzcJtDNTxFtwLBojXkg6GEai2IPscWM0soqD4LvYJr+hNIBOlmR2QKbDD8ywJrKvf0I0MiJ9On9ekK1H5F0zHH4G3cm7odwpycDDVx0uqzxprlmqx0wFPIJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J96Z1IiyrT4233SGqgBUZQywiRvohREcngH7MVSfyIk=;
 b=HshpNoOKDpZXSWvMZC95Wbtx6PuDO/okXp4geWGfpQ6jDBVNJFKSHR0x4TtIyGOfPTn75LBnuZfSPYmPEqkbytLaFp8nZGLBROXzQQSW9vhZr6NrQcKqqrB8ROJb56VkAX5VL/wLabIcFFe5LcAeR53MtdtpjFn4hce8WK0d+oaWAT2a9tza++gQwqn0AZUVkQfAIawFLwap2GO0mKce2dRLHaX1FfX0NeAiciZPAwle2EZE6wAyBag0YfpN36Q8OBuv9EmydjsnM2qJry4Ztl7riLSCDm8NB3lX2guoSB6Q+xXSvisbjQJCJBNZt2Av9kjuAOGqiaKURl7a68m2lg==
Received: from BN9PR03CA0886.namprd03.prod.outlook.com (2603:10b6:408:13c::21)
 by DM6PR12MB5698.namprd12.prod.outlook.com (2603:10b6:5:78::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Fri, 1 Jul
 2022 16:43:15 +0000
Received: from BN8NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13c:cafe::90) by BN9PR03CA0886.outlook.office365.com
 (2603:10b6:408:13c::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14 via Frontend
 Transport; Fri, 1 Jul 2022 16:43:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT013.mail.protection.outlook.com (10.13.176.182) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5395.14 via Frontend Transport; Fri, 1 Jul 2022 16:43:14 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Fri, 1 Jul 2022 16:43:13 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Fri, 1 Jul 2022 09:43:13 -0700
Received: from Asurada-Nvidia (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Fri, 1 Jul 2022 09:43:12 -0700
Date:   Fri, 1 Jul 2022 09:43:10 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     Robin Murphy <robin.murphy@arm.com>
CC:     <joro@8bytes.org>, <will@kernel.org>, <marcan@marcan.st>,
        <sven@svenpeter.dev>, <robdclark@gmail.com>,
        <baolu.lu@linux.intel.com>, <orsonzhai@gmail.com>,
        <baolin.wang7@gmail.com>, <zhang.lyra@gmail.com>,
        <jean-philippe@linaro.org>, <alex.williamson@redhat.com>,
        <jgg@nvidia.com>, <kevin.tian@intel.com>,
        <suravee.suthikulpanit@amd.com>, <alyssa@rosenzweig.io>,
        <dwmw2@infradead.org>, <mjrosato@linux.ibm.com>,
        <gerald.schaefer@linux.ibm.com>, <thierry.reding@gmail.com>,
        <vdumpa@nvidia.com>, <jonathanh@nvidia.com>, <cohuck@redhat.com>,
        <thunder.leizhen@huawei.com>, <christophe.jaillet@wanadoo.fr>,
        <chenxiang66@hisilicon.com>, <john.garry@huawei.com>,
        <yangyingliang@huawei.com>, <iommu@lists.linux-foundation.org>,
        <iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-arm-msm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 1/5] iommu: Return -EMEDIUMTYPE for incompatible
 domain and device/group
Message-ID: <Yr8kHnK7xRx2DZus@Asurada-Nvidia>
References: <20220630203635.33200-1-nicolinc@nvidia.com>
 <20220630203635.33200-2-nicolinc@nvidia.com>
 <fab41f28-8f48-9f40-09c8-fd5f0714a9e0@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <fab41f28-8f48-9f40-09c8-fd5f0714a9e0@arm.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: da8342bf-82d6-4b41-f875-08da5b80cb07
X-MS-TrafficTypeDiagnostic: DM6PR12MB5698:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uYPWP9gbgnY7z1BsnckcbY42Y4appJ7ERQesmeL0i4m5N0+A4QC4DdTgxw6O5yiHWHnz7fH7X9nPzn8pyT9iQgeTJ1bxkGbwqyfyxAYQTlYPoIf4g8lra7tMSVa9Kj90nyCafWnoviIrGzwRTHsIie7sGszG1BL0rnh9RAhqqe+1JNjNmNm/YJknZGWMgSc4xYrN+z+oKw7Z0Gxi+K9K6qjE6jGPNqluYxRLZRGaca+Gm/zLM9LzTgvUZLrCq8l0sUY09ieoGl8v0QXXWC3cMaMGY2iL6jAF7Q9KU9FVdDewI4VF8Lhn+e2XouuxV5KFftLnHBXCJ41GGpgADKcofZ32fkA3h39EU50lM7WzhJ+UTzZrkbG9u3jQAXvY5+MV/kR1kGvd/aFX+2ZA6xiHmju8k8m5zsO7I4bwHsRTOkrr1liGl3Lryp2/jTtLd8FqnMAu6TbRb4ZqRDi3kkMrb8M189j66VIZGwnZP30M9x1QVCNzgM91EK0fVS93PlVgcvnHQkFr2XG/XHuh0AVXG/JoaHWyngGlL6ShP+rj5qb6LenXwL5AAEZEiU3EsQFXqHd4EmyTCZJLL7tsJ8YVOatktDNI9ybBS3JXHnZ7IPy45eOFtImCr1w/iLw8xsW35V0VbuunIrZLQWXb104xQvF1gYmMfwkj0aGyY2blWwIwJWczJMinpp5zqhXU9EDnu/nD12cFW6NpsZozq72g8qScgtAP1KReN5M2tr3qqX1R6CsrZCNiKpGt0NOU3SLE+0RErRqVqJOsIpWNM9yyvhufM6A+vOPjnBeKSB5g2bCORpmz308tA75K8BV9xREJxwq1y+ySNAfDd3mpVEJiGj/i/WcD3Fip5ZdH35CVXPE=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(39860400002)(376002)(396003)(40470700004)(36840700001)(46966006)(6916009)(2906002)(41300700001)(54906003)(7406005)(81166007)(5660300002)(40480700001)(82740400003)(55016003)(8936002)(7416002)(26005)(9686003)(186003)(33716001)(316002)(40460700003)(478600001)(356005)(86362001)(426003)(47076005)(70586007)(336012)(36860700001)(82310400005)(70206006)(4326008)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2022 16:43:14.4710
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: da8342bf-82d6-4b41-f875-08da5b80cb07
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5698
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 01, 2022 at 11:21:48AM +0100, Robin Murphy wrote:

> > diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu.c b/drivers/iommu/arm/arm-smmu/arm-smmu.c
> > index 2ed3594f384e..072cac5ab5a4 100644
> > --- a/drivers/iommu/arm/arm-smmu/arm-smmu.c
> > +++ b/drivers/iommu/arm/arm-smmu/arm-smmu.c
> > @@ -1135,10 +1135,8 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
> >       struct arm_smmu_device *smmu;
> >       int ret;
> > 
> > -     if (!fwspec || fwspec->ops != &arm_smmu_ops) {
> > -             dev_err(dev, "cannot attach to SMMU, is it on the same bus?\n");
> > -             return -ENXIO;
> > -     }
> > +     if (!fwspec || fwspec->ops != &arm_smmu_ops)
> > +             return -EMEDIUMTYPE;
> 
> This is the wrong check, you want the "if (smmu_domain->smmu != smmu)"
> condition further down. If this one fails it's effectively because the
> device doesn't have an IOMMU at all, and similar to patch #3 it will be

Thanks for the review! I will fix that. The "on the same bus" is
quite eye-catching.

> removed once the core code takes over properly (I even have both those
> patches written now!)

Actually in my v1 the proposal for ops check returned -EMEDIUMTYPE
also upon an ops mismatch, treating that too as an incompatibility.
Do you mean that we should have fine-grained it further?
