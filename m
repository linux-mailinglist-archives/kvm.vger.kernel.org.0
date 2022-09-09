Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 400B25B2CD5
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 05:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbiIIDRd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 23:17:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiIIDRb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 23:17:31 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2066.outbound.protection.outlook.com [40.107.93.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EED8265F;
        Thu,  8 Sep 2022 20:17:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YcVaHVn+DMuS+GQpcw0YEoKQnB/sJkf8kTrJ9ebXL2KNF1hLlRK1CkiJwBonfY6gAMG8HI+WffH5KxMbkWYLTdA8oo5QBbmV0YRm1kgW7kF5bSPyWwifsetin6xfyyAON7jVome8VjbM/hNfVzkhdIhTNp1NBNg/3bgJFSjGF0mhC4U8inHbbgre8WtpBk0wwDR3vQC0MP3GEhbKEbbPKLMspoZBGmGkrT6cqTtbUMKmtSkoEbbNEYEraB39ZDm2EEWoghi5wSfovVn/G8H6i+rucNL7PdX6F+SXrvfOD+fCVJaqJxgd/8wIxUJXnJLlPM8vqtSENupN0L2Pf7SW0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cWi81IMdZwicw2LJEyRXdtA41SF9WN6zcwiHFsu0pD8=;
 b=Xmgo0zR1WbCVhvU4pgAA52g93AAvbuxK3Wr61VFF0wyAP9LriCrXCtuMYLDCl6++Lg5DLkV39U5X+m9kz3oD8EHJKcjTcwBz2vwh60+csf1x0QQwamJ+GKVrRGXfzNyTgH+QnEByzqbsjU6Mo0gsoWkf5TDK19YTKiwK6CUdtf/JssqpKyZrZXgrdprA8nrVPFzSw6io7J1lsmDw/xWTLFUvT0jY2DQsUuvNGs4QUduEHbLEh7meJ4sZqORa+9D9PP1eC57okFGx+G1TfJ57Yp6QZeifsRsBz7oQ+1zPfToZfXCWhAgc8SSdbcRJn3w7P5BLVCF5YsZRW0cPC+1TmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=svenpeter.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cWi81IMdZwicw2LJEyRXdtA41SF9WN6zcwiHFsu0pD8=;
 b=WGBGQ4+X6CBSSNxM4LEt46hpfdBPOnMr1IV/+HGwFUHY/uWJMNtRPYtmEuVWHuHo/xNhzUY5DiBASlibrIchBoj/jtKexYCpicpQjhHocIL35NFwwXIVpJVPCa1wxBLE9jtvVZpc+04BUd/pipKfU6wQtB/euUVBH0eGfOI+0WUs377ZPxhwxk9jK2C0miM7pkTlZRGS1JVBesDN/8PrAetkmsp7PP1fXPRpVtfSBWIc9Ck6Oec1yxMOOrv/3eSiYv/Be72ZsjzHdPC1SyR2gyUW2rPz+e1UDeMzg0QqMu1ADuGZm0rstzOqRwuvcO9xmrHSOMKYQcqYVLXVVolOCw==
Received: from MW4PR03CA0032.namprd03.prod.outlook.com (2603:10b6:303:8e::7)
 by SJ1PR12MB6265.namprd12.prod.outlook.com (2603:10b6:a03:458::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.14; Fri, 9 Sep
 2022 03:17:28 +0000
Received: from CO1NAM11FT101.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8e:cafe::f9) by MW4PR03CA0032.outlook.office365.com
 (2603:10b6:303:8e::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.14 via Frontend
 Transport; Fri, 9 Sep 2022 03:17:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT101.mail.protection.outlook.com (10.13.175.164) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5612.13 via Frontend Transport; Fri, 9 Sep 2022 03:17:28 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Fri, 9 Sep
 2022 03:17:27 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Thu, 8 Sep 2022
 20:17:27 -0700
Received: from Asurada-Nvidia (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29 via Frontend
 Transport; Thu, 8 Sep 2022 20:17:24 -0700
Date:   Thu, 8 Sep 2022 20:17:23 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     Joerg Roedel <joro@8bytes.org>, Jason Gunthorpe <jgg@nvidia.com>
CC:     <will@kernel.org>, <robin.murphy@arm.com>,
        <alex.williamson@redhat.com>, <suravee.suthikulpanit@amd.com>,
        <marcan@marcan.st>, <sven@svenpeter.dev>, <alyssa@rosenzweig.io>,
        <robdclark@gmail.com>, <dwmw2@infradead.org>,
        <baolu.lu@linux.intel.com>, <mjrosato@linux.ibm.com>,
        <gerald.schaefer@linux.ibm.com>, <orsonzhai@gmail.com>,
        <baolin.wang@linux.alibaba.com>, <zhang.lyra@gmail.com>,
        <thierry.reding@gmail.com>, <vdumpa@nvidia.com>,
        <jonathanh@nvidia.com>, <jean-philippe@linaro.org>,
        <cohuck@redhat.com>, <tglx@linutronix.de>,
        <shameerali.kolothum.thodi@huawei.com>,
        <thunder.leizhen@huawei.com>, <christophe.jaillet@wanadoo.fr>,
        <yangyingliang@huawei.com>, <jon@solid-run.com>,
        <iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
        <asahi@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>,
        <linux-arm-msm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        <kevin.tian@intel.com>
Subject: Re: [PATCH v6 1/5] iommu: Return -EMEDIUMTYPE for incompatible
 domain and device/group
Message-ID: <YxqwQ+3OICPdEtk0@Asurada-Nvidia>
References: <20220815181437.28127-1-nicolinc@nvidia.com>
 <20220815181437.28127-2-nicolinc@nvidia.com>
 <YxiRkm7qgQ4k+PIG@8bytes.org>
 <Yxig+zfA2Pr4vk6K@nvidia.com>
 <YxilZbRL0WBR97oi@8bytes.org>
 <YxjQiVnpU0dr7SHC@nvidia.com>
 <Yxnt9uQTmbqul5lf@8bytes.org>
 <YxoU8lw+qIw9woRL@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <YxoU8lw+qIw9woRL@nvidia.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT101:EE_|SJ1PR12MB6265:EE_
X-MS-Office365-Filtering-Correlation-Id: c011eca3-74e5-48d5-ea39-08da9211d333
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sHXN/KKHM1XqDv2azSzqcajRY297pTWIwlt21Oi+lOQCQiDUPNdS563UqSg4J16qQzfA/PAU3YuWHfSFROcJdbqM8kkCdpJgNqu9tNKc2Kb+OBRYBujk94qzcEcpRxjYdjUPVXGnnlsA/6lj7TD9TjlOZd9bOjRYQ9yi5qsrL3pyFBe5YI/i+MKbIepvsyh7tXba7rkBcNJGfVmZlwIBDyv4n4MQmfBnAPLJuPL1a66AMQpMgS+T+pzkZhi9R1prURmGLTAjEue/mF9f4t3BWI4KapBTjNxE3l+7uoBwaWl5UQfJh6fFLi5b624ZK+darjRg4fEgKeB1tATIbunOVdlUqtfkG3RNSf3NGqEsiX8bBTXGjhkeE/6Hpgo2U4u6NSxeRR6A1UZUivPgO+iv9WEZaxwXDOELG552xAbOHhft+NEJxRq7jGnPJgebz6w5zRwHOLBc8rhjpARThNLBcsJQ1XKKp1TlxAIaqvp/1ClRNX/uKsKwGVgVyB0XvuVgfTSAfcepAYNcfcwdN5WGCs475qGVZxDs1wL+iG2IObD06i0WpTOopysA9GLo2Vb2HgED2D8kz5SDTFz0pIS7xFpbNnx3+gS8sQxm+Tj/9urE7dqQO1hoNI2M4iAcVn+c/xZ5JzyPUOtCkx7ribuE/f+tpYopVhEav2VP+IpFO/fCpvHuDGHRJJBYJ1KU1oVQlUfQg345Hh7zwLxITDtEd+zjOr0BwamW3f7yZWju4tBE470JvzWdHVIVbc7fZkz9x4KoCvEeTi7d5FwCSkHJb7kTxndx8obj0bcR9EXB1P28p/nS7QmIHNhro8tR20+9RtaSdOuvc0Bxy5S09Y8eCQ==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(396003)(376002)(136003)(46966006)(40470700004)(36840700001)(40480700001)(336012)(81166007)(426003)(356005)(47076005)(26005)(8676002)(36860700001)(82310400005)(33716001)(478600001)(70586007)(82740400003)(40460700003)(70206006)(86362001)(55016003)(4326008)(41300700001)(6636002)(8936002)(110136005)(54906003)(316002)(5660300002)(186003)(7406005)(9686003)(2906002)(7416002)(67856001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2022 03:17:28.0590
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c011eca3-74e5-48d5-ea39-08da9211d333
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT101.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6265
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 08, 2022 at 01:14:42PM -0300, Jason Gunthorpe wrote:

> > I am wondering if this can be solved by better defining what the return
> > codes mean and adjust the call-back functions to match the definition.
> > Something like:
> > 
> > 	-ENODEV : Device not mapped my an IOMMU
> > 	-EBUSY  : Device attached and domain can not be changed
> > 	-EINVAL : Device and domain are incompatible
> > 	...
> 
> Yes, this was gone over in a side thread the pros/cons, so lets do
> it. Nicolin will come with something along these lines.

I have started this effort by combining this list and the one from
the side thread:

@@ -266,6 +266,13 @@ struct iommu_ops {
 /**
  * struct iommu_domain_ops - domain specific operations
  * @attach_dev: attach an iommu domain to a device
+ *              Rules of its return errno:
+ *               ENOMEM  - Out of memory
+ *               EINVAL  - Device and domain are incompatible
+ *               EBUSY   - Device is attached to a domain and cannot be changed
+ *               ENODEV  - Device or domain is messed up: device is not mapped
+ *                         to an IOMMU, no domain can attach, and etc.
+ *              <others> - Same behavior as ENODEV, use is discouraged
  * @detach_dev: detach an iommu domain from a device
  * @map: map a physically contiguous memory region to an iommu domain
  * @map_pages: map a physically contiguous set of pages of the same size to

I am now going through every single return value of ->attach_dev to
make sure the list above applies. And I will also incorporate things
like Robin's comments at the AMD IOMMU driver.

And if the change occurs to be bigger, I guess that separating it to
be an IOMMU series from this VFIO one might be better.

Thanks
Nic
