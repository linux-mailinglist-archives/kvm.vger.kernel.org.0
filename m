Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E611565747
	for <lists+kvm@lfdr.de>; Mon,  4 Jul 2022 15:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234906AbiGDNcT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jul 2022 09:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234834AbiGDNbq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jul 2022 09:31:46 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2068.outbound.protection.outlook.com [40.107.223.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE69DFF5
        for <kvm@vger.kernel.org>; Mon,  4 Jul 2022 06:27:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F1oGSwIREMSnTXU7ZaQu1f4Cy7m/Kjl+SWpMhV9mKJb0OYlMxEF1uX8SF6Rm4LxEyNLZEEShC3RdF2eQsuDxNjfBEz+cpcgLVmkC3aR93A1VG8h9WKgrSrID6yE7u1WbmQXvhHqHeAZXVQuh0AKqgWd2XMYspXnGBNBeqIEABWDhThoFJTmiFtVFT64iJ1NqP36dG89Kzs9F+9FfE+YRNKzIMEXDNAllLMLxW07DpqytmhglVzhpEkHB34nzBRkf21rOyeonoE2Hpa3jnkEFzjrm1pmE/6Z3pIoNPTtG32Ye4dq8KlSjpiDYjID/81+9g/50P3dhIqpqMeqbaUd8gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TKF4HsI35KZr//52mwID1VihP4ZF36WwiEafY85fZ9k=;
 b=Cl4MA9DkW7svC2i63N3jK3oHEMcW5ik4V9DnMvIv0nkIzKanhlm3zZJuDv79DpKnd2jnHmUGaKFtYGFdp8i2Fj2MlhxZyJusmaRZNBOz/x/8cVx9AqdGT5X3rzWzBGimjJRzT8OP/hqvIWFHejNmM6EVLDSqTfkHH55H1JZaqyTwki7Rg2YhIvjnlkNJR8exT3JMARqNeDr6JKjAIrMjUU7KmXcc0Y94+SBuEKkLdH3xaiqDgAbgTthDhtHfjGdENeCFoa50YlddavKcC1EvI7cyGZr7m026G/dIOKJ56i+dfLr5mApbw8+fazWiXCLADkZjrUvUbW5QbiOYdQerXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TKF4HsI35KZr//52mwID1VihP4ZF36WwiEafY85fZ9k=;
 b=mODYAX8JIc6OvQcVx7r//TrZyOvTQev9p+XC6bwWtlEZa4DDQbXkA2mlSX6F4NhfL4//sfKoqijTMYSJpk6oqZfn4pC90k27WptT1BevtHuT6NP/bcWGygeLW2YEe7eSUIt7oC8uCuq6xoKZXVQNltBlit8bJ1x1thTbP4kjtad2TEGyEiLvko0b8A12No1AhNJq6KP4j/3cIUWSZjjkQC+hPDCOEc8sDxQfZ5CwZWMtnwPld6pYmJOWqaSZ2gD3Spp4YBiT6sV6v//cYnaKJSHM+F6TAYbEVdyPczkFb6rUTshWpUXX8VXXd5VqNOS4EVY+sZzU60UDk0q7WVFLeg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MN2PR12MB3614.namprd12.prod.outlook.com (2603:10b6:208:c6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Mon, 4 Jul
 2022 13:27:40 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb%3]) with mapi id 15.20.5395.020; Mon, 4 Jul 2022
 13:27:40 +0000
Date:   Mon, 4 Jul 2022 10:27:39 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "chenxiang (M)" <chenxiang66@hisilicon.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        iommu@lists.linux-foundation.org, Joerg Roedel <joro@8bytes.org>,
        kvm@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v3 4/4] vfio: Require that devices support DMA cache
 coherence
Message-ID: <20220704132739.GP693670@nvidia.com>
References: <4-v3-2cf356649677+a32-intel_no_snoop_jgg@nvidia.com>
 <40454b70-11e1-f9a1-6c26-27e7340f2109@hisilicon.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40454b70-11e1-f9a1-6c26-27e7340f2109@hisilicon.com>
X-ClientProxiedBy: BL1PR13CA0013.namprd13.prod.outlook.com
 (2603:10b6:208:256::18) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1174652e-db4b-4294-9df4-08da5dc0f7e5
X-MS-TrafficTypeDiagnostic: MN2PR12MB3614:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6UNmtelwqUvYfMXzxcn9TztwNIp1XpUBmsZhm+CTShaleV1Lfn6q+v550Y+rYxfDSo6cGpAhQcRIRYcj5Aslr3uTso95s3xXvm49Y36hFoWju5X3ZrF2WaEYuJ6AWB1UTHL3lwN9BawAymtsAAEMdJkueVhnVdeY7cTROI3Q/B9pNmNAXjcQsDoBaVzXx5SZwwqBCXLEgVQ/6ghz3qffFx0jBQtIKxEEBkr/MsztvKQUB/L8wFnm9Bqf3moDv/ryBkg+g7wVPU3ah7ps578HejuACBWAA/GJnv3XH7Nlre5FHpoDR59DpSImsKrH6MQtWGB37r9SOC5ZSRAo3xoF0yzu7ujyuOEE2DrrxQ4aqp8n4iH79seyI2LMm5BpYfRvvtnm9tNGFvY+YT8qm/RlzxBR87z1h/5JjrsZGmKqvYGETADuBXlcQMYYoU2CV8haZ2TZhC+PW+rmHs6V4X29fsTPxC/oyXH7xY7Ruf2tTL9WhxM0nH8MSn3J9SmYtAP186w3VZujDtfpoqtTD/hADMBNSJUmCFyIeGMAG/XKcIgwP7wHUvN20mL/w0zUhBAugIhKe3F+agz53olxaQTLfA7lLjYMjoS4V+dUvbIbAJ98DDVBKqr8WuMBQCZdCgj5GcS3HFDokL2GdU9KZqVin44YjwN2Q2+01QqHko4F3J+/49fP/HvVZGR5hC97MLUETd77swOs51y0BZRW4EJjskzCVhKatX5hz3mcyJwQhqHXXGx8sTlble7xZRUPuHOLV1Tu1iNVtPJzctDIVrPxOVtIrjl14hRsci4UOal4gzWozlqLEAObXILCGZM0xsUN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(366004)(396003)(136003)(376002)(6486002)(478600001)(6512007)(66476007)(54906003)(66946007)(316002)(6916009)(5660300002)(2906002)(33656002)(7416002)(26005)(4744005)(66556008)(2616005)(4326008)(86362001)(6506007)(8936002)(8676002)(1076003)(36756003)(186003)(38100700002)(41300700001)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wub7iXJotPXJqEmDbnB/tWvJqdxVgKerxS311nNcDjbZpwWOmGgXqEzPTxxq?=
 =?us-ascii?Q?yu4WpxCllGukwdpSAvZ8vV5fX94KjrfTxo2wOBN3rRR0HviV61DEXso/8WDJ?=
 =?us-ascii?Q?7ncvKMsegmugalchVVlr9agUR0arS/fMNuFqs3AbIlbu4NBZugCNVMg5Ca33?=
 =?us-ascii?Q?Ia+3Mwj7T7Z1wdG9ZHFI37TzMgf39nLSBopIlJfdBXc5JglK8ncG3zzas/6e?=
 =?us-ascii?Q?rGt6mhGrxQ83MyuMNZOvh6HYeZQ6nNUpk4CVsUF6m/R6rq3U7X1P/bc3bQHi?=
 =?us-ascii?Q?560hPwNOOdQh2abNLZ5fnKmPxk77uwiUxguSzDv3OkknZ6coaWTn8FYHIDTO?=
 =?us-ascii?Q?Lw4Zmu7fEybaLRCu5OQmA3KVPETEjCvqbQxPf6w8Q0DIBudarkkhRGOEHhlx?=
 =?us-ascii?Q?HT7yokM7n0fLcyUZJp519mNmmkYH4D4c25OLS8t1FuM6Wm3cRpCKDUIBGBGY?=
 =?us-ascii?Q?yHMNUNNINVhpbYWAVXIVXJlS5Cf0ay/30pHyg70zQhiDXoxlbjP5+ADL7CsU?=
 =?us-ascii?Q?cvvegSN5fo04SGWeV52EouOHNrJFfoz4yuT5Z3PnhEXiWifN4br4rCKEl8Uu?=
 =?us-ascii?Q?9MPVNFEvJrX6nTgZGp+AUSEnGyMjVvTQvzZj9XB1i3tdbt5nOh99YYd5exOg?=
 =?us-ascii?Q?fBDueWeepHnuBYU6B68Nn7EDeyWU2SvGkc3m8ghC0TMD/qXJGgkf2s+yrnwY?=
 =?us-ascii?Q?hzg506Pdmqq2jFb30VpSK539/mcf7S6mm91kLyEKTd3ctMaKLsToGutOv3yd?=
 =?us-ascii?Q?v+GK9flQq6ScLBnN9FbkUTkReCY9mHNL7HF4m8fLlrPddR8ocqDUzTFeK5+d?=
 =?us-ascii?Q?5dzGPBTEgJCgba3uH/KZScG02msHU2sg62Qv6TkHJCk52vltRD6WIu3Yy2Zo?=
 =?us-ascii?Q?+6er0Io2sk6jY8ZD3rMwE9q40aSGERm/0GIMdN0SlLwSLSyRXIYQC5QvA/6y?=
 =?us-ascii?Q?vDtLZuOSUIven1hzEtNkWpJLrkYFy0K9jjgW3qHeoQH1pyz2meir7mWguMiG?=
 =?us-ascii?Q?f3ui9AJw2AcRwlE7ME6hCzd57BubZWsRuPPzjoF7x0SUnV1nTgHxwkW9QkMZ?=
 =?us-ascii?Q?JuBo5iTtrg+IqsX7Xnw02NC/w48ENRZqTHPBfMcUbZrgOAGZR7UW5eL48nmb?=
 =?us-ascii?Q?PHXYD7+H64Ep86XgKmFYDfkQTJcV1sWn3tuzmYomHCSspgp/X/IiwiNmbwIH?=
 =?us-ascii?Q?oT5bkMuNwcRSxIKZQ5mmwCBInfde/7LFzfGGzJo5JLioB6gsKuFgDRTyL+zD?=
 =?us-ascii?Q?L+PU5JKE6zTlmD8YTRfyEWYcKS/GZddzuvaTjbmHN7yI1vSeViG9ZNGDFzUk?=
 =?us-ascii?Q?haTJJwqBcp6tYj1/mDMMTai4pL786VTDXXC3t7jzLf/doZ5nSP56Ae1FEuDb?=
 =?us-ascii?Q?gMFKvDN0AL/8AeEKhZYPACE0cYSTQnf/wSwVa5A9UsqWHn2drlnajqg2fnPI?=
 =?us-ascii?Q?ITaDAjNM9ZIPdGs3+N7nU4FYWWtDVkLW9c95k3STYiDDq7QmmucVLMAmBoOc?=
 =?us-ascii?Q?PClQXParJxFl7jcyr36jZulHpfWzkxIOQgOQMjtWvPm5NYA6H3mB+Bmt9Z3m?=
 =?us-ascii?Q?jmDcwiZbuP13AeRXeH0CwpHyQ0jhvLP19G7KsTQN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1174652e-db4b-4294-9df4-08da5dc0f7e5
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2022 13:27:40.1408
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rYaTlEoR/CekgBVcA71FMt+/xoZ5QOQv0ELc1UsW1ucBDvVlS0fU/dTBjdj3jk0Y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3614
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 04, 2022 at 09:21:26PM +0800, chenxiang (M) wrote:
> Hi,
> 
> We encounter a issue with the patch: our platform is ARM64, and we run DPDK
> with smmu disable on VM (without iommu=smmuv3 etc),
> 
> so we use noiommu mode with enable_unsafe_noiommu_mode=1 to passthrough the
> device to VM with following steps (those steps are on VM) :
> 
> insmod vfio.ko enable_unsafe_noiommu_mode=1
> insmod vfio_virqfd.ko
> insmod vfio-pci-core.ko
> insmdo vfio-pci.ko
> insmod vfio_iommu_type1.ko
> 
> echo vfio-pci > /sys/bus/pci/devices/0000:00:02.0/driver_override
> echo 0000:00:02.0 > /sys/bus/pci/drivers_probe ------------------ failed
> 
> I find that vfio-pci device is not probed because of the additional check.
> It works well without this patch.
> 
> Do we need to skip the check if enable_unsafe_noiommu_mode=1?

Yes, that is definately an unintended mistake.

Thanks,
Jason
