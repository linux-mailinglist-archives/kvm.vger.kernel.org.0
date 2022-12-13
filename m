Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2824064B78B
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 15:38:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235978AbiLMOh4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 09:37:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235986AbiLMOhw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 09:37:52 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2066.outbound.protection.outlook.com [40.107.92.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C88E17A8D;
        Tue, 13 Dec 2022 06:37:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XUMNgOOIrrE4ACa5WGK7QLbMNj5tyoZ61/ANYyV6jFhsa1uAgCbPKx5gEkZ+zCMfmrbcNwsGmtuXXU0XkhmdE6tbqOMcrHHQ4+wpqcp3b5u8Gqvi0TFhkv4qnJ4hj0Y5RVoDwXUoHFM/X+GFqhUhzQwrOn52G3VoKdK3HZWtsKp2jYCmeyGCYVVZl9VMXGu506KgQFYQdzexhcmmTIL9bE5l9JfiZ7Q0J8hNclIXG7AZJmD7t763FaioK5c+iB3AAe08j4VUzxkIQPEpggk4EWLOQSPUbbDtj+XO+gof6rqEkwLiyoArLT/1Be1hr7dta7mTx5DPsrWZzXJv/3b7Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pREtGlHDQ2gppoB1iGEaWc4ScZiL+0XCs/gr8oEXiws=;
 b=YAnlpqPzXetC1sjKI2aHAnBTNEnoCQCdj2oaQVcPtm60VziaA+FRpdZkSTsWiA0+NudoT1jihouutwfKzsLkJMu3yk7axtcFvNz53nTZPH8KgdoaIwRbPMssnQQCrxPssfoyuPfbbsNwJObnBatHC4LiEcnpR8J7eCgcj/jQXmiGg9+TbuMwVIjD11yPirA0RnKpoo3Xzq7M6nTEWnKWt2qhi06hfT6kGkXveZlFrLJH6Um2pKdo4rpCxbhYsG2B7U5er84ngG6VbR+EpwQMG2RgXMIc/lm3sT857f6+Rw0MSOGi3T3SBwjCnyWGnp2bYvBEZCzG2nf+uDWn+qLuJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pREtGlHDQ2gppoB1iGEaWc4ScZiL+0XCs/gr8oEXiws=;
 b=MK0T2DxWvw72z/ssUy+TqUa+1xklchEWy/RYVeWyQ9QZUYJ1k3eHuCOQ6xx1DdrJkhppbbDmYWpg0l5xFrq2T9TsSw0L+mEoMngOrwdgM+z6FvYrLfyNx9KsNTgZycmE+AwAsg4WShlUvIvejE5IEh+4fPEKnQHETxDvHBpE6u2pZAw6QJGGvEBxKZual1UDI9zeQEL3PgBkuQs/KaKHPYnA5pwhTATzR5NB+J+VL6zfErhCzCTzfft77VvGV/Ux0HCX7HH+MsexdLsRauFF75dOCo02ZT3HV62yxOgVDtmWP9ueglM3Dz8taR/0vet9zTvOesHXzN9GWX8w1aIIGA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA1PR12MB5672.namprd12.prod.outlook.com (2603:10b6:806:23c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Tue, 13 Dec
 2022 14:37:45 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5880.019; Tue, 13 Dec 2022
 14:37:45 +0000
Date:   Tue, 13 Dec 2022 10:37:44 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alexander Gordeev <agordeev@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, iommu@lists.linux.dev,
        Joerg Roedel <joro@8bytes.org>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>
Cc:     Bharat Bhushan <bharat.bhushan@nxp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Tomasz Nowicki <tomasz.nowicki@caviumnetworks.com>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH iommufd v2 2/9] iommu: Add iommu_group_has_isolated_msi()
Message-ID: <Y5iOOL4JQ3Vuxjnq@nvidia.com>
References: <0-v2-10ad79761833+40588-secure_msi_jgg@nvidia.com>
 <2-v2-10ad79761833+40588-secure_msi_jgg@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2-v2-10ad79761833+40588-secure_msi_jgg@nvidia.com>
X-ClientProxiedBy: BLAPR03CA0171.namprd03.prod.outlook.com
 (2603:10b6:208:32f::31) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA1PR12MB5672:EE_
X-MS-Office365-Filtering-Correlation-Id: bc7c815a-5136-4a06-207a-08dadd179943
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: clfDY3hdFIPGizpvOwcg/hfpxYK2oW3qXXV0xH6UtxtZ5fHMZHA2+/c++bj4Boijk8NeOqRSYMTQcgmpaBGDmREx6eTjrJN4ZaLgBHm7szmNpJBtRAfGrJ6fUZtGBrkKTwlP5mfx5wJSzu4/RlGDI9UpQ2SgOzsDSzCcz04JIVtQwjOyVXvS+JEu9CrXTeLx7+KvFR8Keg5wKcOFqnR/vO1Wp7Yngpctl9dXO5zlID8Y4y4BcH4o/NviRnvxRMryMhqpsLPfT89WRrrulJ9bVTwkHTWbfd56GNpgasjDV3AZeUfQ0UHZKXYku031Wv6gF+UTJMC/BgIIOuBaL3H2oqEpNaP+daS4PmutwelWldOpUojzXsxtfsetMTuTDoz6SI6JjRAmVb90Vm4XGIZ3jPd4cONNRqgLAXtDes6nBLuqasOljkrulV8bUDheGYs+3sIBISWiJ6cub4rzjKRk4gbRqrcNo0hDKloL3CmKU4M4nOC9aY20Ch6AqpjrZ2kAjHy43gxR46vsYjQpXWQBWby5cQcn1I/Anh7FBjre0JysCrlQKQ/wu5XogV9rh/AdawH1528qSnIu0YS1nppcRQECl32okbf9UndiuMcSBUnrRw3UHW9El6shwc4Ft/fGThGAM3oWPG5JV0BsDUoFg3U20blIYBzCuDpRbSVc2+E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(396003)(366004)(346002)(136003)(451199015)(36756003)(66556008)(4326008)(921005)(66946007)(38100700002)(110136005)(54906003)(8676002)(316002)(5660300002)(86362001)(6506007)(8936002)(26005)(66476007)(2616005)(478600001)(7416002)(186003)(6512007)(2906002)(6486002)(83380400001)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ifT+RAngxCZOjq+3Kyhtm3lUgQUF3oDN1P4u91we79rEZP27g6N/13P+RlWc?=
 =?us-ascii?Q?sHLQiJAyHQ3myoFKRoQZosLtZ2OYmxctz/MLyUgnAhmfLTOlmzCp27a2gUBA?=
 =?us-ascii?Q?ww9il1S72HIEvOvFmBygPJGrwDrSWFNapNVFJiyJbqmpUF3UNZCOCzX64Z7Q?=
 =?us-ascii?Q?UsJLfqKKcykyl/zOCZpupqZv4yMqfU6KILzLoSpIvCg1yYAYJ+lCw5Pc62Cj?=
 =?us-ascii?Q?ooQjPf2uK54BKg4Ke1q0ZwskyEZs1kjZwOQsxMXv0bAnHNdN+//98YtkR7l6?=
 =?us-ascii?Q?I5DYuLDlDy6cthXi5IT99mNVk0o+gSechKpSgiOMXEvx2baQm27KW2TMCEJn?=
 =?us-ascii?Q?YkObW+Q7dgCKiK19gdE6eK4iPT6lovzW8L3FmjoHZ+qotrfazCV3muJiMyhM?=
 =?us-ascii?Q?ogjnXQygOHpI65mNlVZH37r0jOt64EXk5127+BFtzRrkKH9avWwE9PfVx7uF?=
 =?us-ascii?Q?jaVmV0t/hOWwtKux771iSA46W12etpgSSq+SUE7KLF4AfHCAdJjqylLkyIt8?=
 =?us-ascii?Q?faYLiqHBIzcf6TMZqxYlBrgbn8b1cNzKkmqwML0kM3dqt0dNxu4BeoKZdOIs?=
 =?us-ascii?Q?Jz4EH/dQOzTHimcvG4jgRbA2n5EwnfNu6Ir3XYuoE1RmrtTaMyK+goN53O5b?=
 =?us-ascii?Q?7dtCHdGh44q0jQYbaMozW8rwTCcrR3gJpvb5Xio6WFq3VS/f/kX7QekAlCCE?=
 =?us-ascii?Q?D/sF+DabP66vVZD/wyHfCxfoIzsSaAh+QuICNC09ZKkK22eE1LoGqoP53RT8?=
 =?us-ascii?Q?Evr0ZMdPA668IlX8Akb+8MgMWodMXOvsnDltMKt4HZd0jL5R36pS7fvdRGBe?=
 =?us-ascii?Q?8gbjJO6uhgXAzxINR9RF68GqJPzPJQOl8HllhToduO1pA6/WU6Sq0Hhm2A5n?=
 =?us-ascii?Q?ktSPq+8eCwl5oPmwds/xNAxLPouqCo4AUwBt5nAW97xnpRcAN9NOToOOAR1L?=
 =?us-ascii?Q?NjmH4WQEE+WWJiislM9Q9WBPN7DB4q27ZHeqj27gaWv4hG3aQpQMyTxeWWwH?=
 =?us-ascii?Q?VqicNLvyFT1dHGVkgQ+tkyrCk54Tc91Fp3SL7yftMuhEvGincxmEwF0zumJs?=
 =?us-ascii?Q?4whsBwlSvQSjj0c46Ctht3+/WTLYS98BRPZfdfZQ00C6PZs+MLOAGtZJwy1c?=
 =?us-ascii?Q?dvgPXIJ2aVp7+wVJ7zHhayGw/hlUCtIFz4GRomz4g410QLeUsu/OESdr5vn0?=
 =?us-ascii?Q?LqF1Wz/b2hlkkhnIstDtwwy3PMEnXN1b3i9Gc4AlG9P1UjnVEswwc619jTc2?=
 =?us-ascii?Q?NQ0m9Kgn/X+Kw11IF7L7Md2GEH6S6nbN595ReHxtUJC9BJGN8eQmzJl8U9hM?=
 =?us-ascii?Q?wlMlIQNZ+DYE9qVPM0JuWOjyP4u1mTQW0ATkWJnV8bCCEih+toQFobwaraZb?=
 =?us-ascii?Q?aISg7n6oxWfYISBxRBOJIY3LNuGCx0p7n7TcAAgggjw6x7TQovOi5eJ5m3ci?=
 =?us-ascii?Q?A0X2DEwpXOwsURRpTM9o06p+pTWirzBYgXzKOrrivbrRS62Mdz3vwgpg7eI4?=
 =?us-ascii?Q?6CJxqjPDUUQb9Yukjp8+lChrgQ6KNcUxrk8yH7U3w4qLJT6ty148fw7YVFw0?=
 =?us-ascii?Q?63MmdcUB+dhE7Ckwmbi4z+9Aj4vY21o7vhMJ1ICS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc7c815a-5136-4a06-207a-08dadd179943
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2022 14:37:45.3833
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nAQ1ajlQ1sTppgW0pQSN4ozwXgcFtT7c3UcILqEA704oimirMvJWa9AznvuJ0hM6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5672
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 12, 2022 at 02:45:56PM -0400, Jason Gunthorpe wrote:
> +/**
> + * iommu_group_has_isolated_msi() - Compute msi_device_has_isolated_msi()
> + *       for a group
> + * @group: Group to query
> + *
> + * IOMMU groups should not have differing values of
> + * msi_device_has_isolated_msi() for devices in a group. However nothing
> + * directly prevents this, so ensure mistakes don't result in isolation failures
> + * by checking that all the devices are the same.
> + */
> +bool iommu_group_has_isolated_msi(struct iommu_group *group)
> +{
> +	struct group_device *group_dev;
> +	bool ret = true;
> +
> +	mutex_lock(&group->mutex);
> +	list_for_each_entry(group_dev, &group->devices, list)
> +		ret &= msi_device_has_isolated_msi(group_dev->dev) ||
> +		       device_iommu_capable(group_dev->dev,
> +					    IOMMU_CAP_INTR_REMAP);
> +	mutex_unlock(&group->mutex);

I thought I had let this sit long enough for 0-day to check it, but
nope, it needs a:

@@ -30,6 +30,7 @@
 #include <linux/cc_platform.h>
 #include <trace/events/iommu.h>
 #include <linux/sched/mm.h>
+#include <linux/msi.h>
 
 #include "dma-iommu.h"

For some configs

Jason
