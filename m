Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A98B84ADB3C
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 15:35:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377673AbiBHOfD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 09:35:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230420AbiBHOfB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 09:35:01 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2085.outbound.protection.outlook.com [40.107.101.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59127C03FECE;
        Tue,  8 Feb 2022 06:35:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mzi9sOzzTGbfwvgoAvMxa+MlGql1uAOkrFYuaVT4PG6Xgy7KBpN6L9X56G4NX7GpzTkdKRU27Tdl36McnUNlxssf3dRkgqI1voycRb2KROZhV1nuEuTfpoOX+urA4RitJXcAMkGuyeIuB7HbLTKorwXl3NsvfXOzKK+lW0ZyPzLlIsKiBnhndBMgLyZF7nH1XDm9FXGrXTVVlXT4aLjcg1aI7TAB/mUNkOa5mXyc/g+7gx/Jo6KfbXnHzae+iud8Zk5fnANBYPlR27MDS3GjcEgHvTyM2WbOnPQm6Qar87S1x68PmG0x1FoP/OzARCf94ngmmG4nO9/+DX8oefxKSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4wukJVxFgunDHxJTzeXGr9m4/izuvLhWjzEayPFGDdM=;
 b=lNItQIMPqbq5kMOS7f9vKuIJytvh8ZGu1OH/PuGA0KYhaJVisJMWLgBftMthV4mkuFMqCkpYXHJMO/fXS8Fzfk69A+aqUWs6utQwJYvszQcSZ1o2Q1k045bsySsZHX5QpqPedf9x+vrf1yX6HLa2iq4OQmaVp0qNAGDjmI9ZrLhW+8csw2nhvojfR06qKhG37K29VeLaM/+w65uTiIiK3vtzye67Ea6/3kMMj5AWzBfDHgovEHvr0XrR1zEwSu41ZA/oQ636T8zslj/ORHuWk/1jkGlqL9HmbhanK77I7cfwdrUze/ray1JqvACSfzUBLT3xFeF4jdgvq3lFaec+dA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4wukJVxFgunDHxJTzeXGr9m4/izuvLhWjzEayPFGDdM=;
 b=iZRM9xwCp16U1cbixWqYXKfiJvdd8Eq7mNV/wZHV2NiRbpqWAwQxcpOP/Y3hEMzMmc2UrzfzNtO9nZtYv8R9rpqgBIJLO6sHESNkZhbaSL6/GB8oD4t98BHgMQiNbmgkceLUrrSkm9EvecTyd//XN+R3oVGWflcUXOipFDYziA5Tz37aXYS+Lb1MXZQkPZ59uRDi1YunL+u6XZoai77mZyyDDC/5lhGAw4Foyg0gI5FDC2GrBpymWIDi+GXTA3gHafeq4ksOcvIv1/jF+f+r+IIIE6F/RbvpbXSifBXSHjyaHrO1Dvb+ssP0mPp4kxe8RCL++qBhljkf+7ZTbByT3A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM5PR12MB1388.namprd12.prod.outlook.com (2603:10b6:3:78::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4951.12; Tue, 8 Feb 2022 14:34:58 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.4975.011; Tue, 8 Feb 2022
 14:34:58 +0000
Date:   Tue, 8 Feb 2022 10:34:57 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, alex.williamson@redhat.com,
        cohuck@redhat.com, mgurtovoy@nvidia.com, yishaih@nvidia.com,
        linuxarm@huawei.com, liulongfang@huawei.com,
        prime.zeng@hisilicon.com, jonathan.cameron@huawei.com,
        wangzhou1@hisilicon.com
Subject: Re: [RFC v4 4/8] hisi_acc_vfio_pci: add new vfio_pci driver for
 HiSilicon ACC devices
Message-ID: <20220208143457.GA164934@nvidia.com>
References: <20220208133425.1096-1-shameerali.kolothum.thodi@huawei.com>
 <20220208133425.1096-5-shameerali.kolothum.thodi@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220208133425.1096-5-shameerali.kolothum.thodi@huawei.com>
X-ClientProxiedBy: MN2PR17CA0014.namprd17.prod.outlook.com
 (2603:10b6:208:15e::27) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b43e068d-b102-48cc-c915-08d9eb102eb7
X-MS-TrafficTypeDiagnostic: DM5PR12MB1388:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1388658756E9B19EDD561040C22D9@DM5PR12MB1388.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pknwaWR2QFFn6PrPkj4ZJnCK2XptUVOtNcx+XcfAHWjf8oISt7jGVs6dLQmg5vaZp9QRS3LbWyjNTRJqqe/ukT707EWWsvt2l2hycnBoXl226zfJ9O7Gm9TQPTQ++HzBfv4YEZqw8HmTxNP2hDygziK0ewPS3XprvoIkXMy55VLMikr7FxD+0gjAfbZQspWjQ+9FxGIdN0AvI4EZDV68VRSfE4Z8ZjlpJQFp3c59QWDwnKFOFdYV5A/tRWZeLRWzFZ+UWl/xd8QOzszklfYJlEgeewhZ7wu4R8IoTIKI90zOw9qCgrE3gXn+fthbRzFHWRDBtzPcx46vjA+9i1hMwlha5IvZ1X98B3afVQsrMYGBkr7khOk9A+0nZ+bkAycT1n8AaIp01Yvcokb3cEaVtYgPv4TBy3KyKRYqsqUmp8kYR2OIy39qP678/LoVbGbb1NHnk+wMcPhxMlSwKzJ5PL+FDPytFMc5g1ySRZEn2aZqANz4qYm4FY/qI7oO1cB0p0q0prErNo9MuStQLt/sZDlS1ov4HpM6EHqJZBk6T55dnzyaD20xre49pWXij00UK0Tbh+9V0Ge8RK3BpmyND80LOEWXCxd8dF0Vm1HuDhnw49HgNfYMn0+Tm9vCKnnebO3EwUi8erdJT/nW6QBm8s3w7awGFvurIqElfa++WkcilYuS+/rnFbLB0WJQL6XZCfoLaGx96deSdbii+vv29A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(6029001)(4636009)(366004)(6506007)(7416002)(508600001)(8676002)(38100700002)(2906002)(6486002)(6512007)(5660300002)(33656002)(2616005)(66946007)(4326008)(66476007)(66556008)(8936002)(86362001)(316002)(6916009)(186003)(26005)(1076003)(36756003)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NTrqVn7dF2iEjQnB1INrQ+UdHAQvLc+2o27AQXQsppWzC1Mn4Ot0ipLp1yRF?=
 =?us-ascii?Q?OQdyVTNQ+m+aE+efRmsCJ0Lid53FvyX4kOmKtWWzgFJInWpMgl6EIHv3lTgC?=
 =?us-ascii?Q?GkLGGQD9vCR2XFjjJ+ZcSH3RTs5p9Aob8g31zmE1UXNp25u4cbfAVn2TIayN?=
 =?us-ascii?Q?Lnp75OI6c4hbMqUe5WfWbbHpVZVYPo17EwvyLT67CF/YDWkK9RsXvMOBABx+?=
 =?us-ascii?Q?3K27FX03CamlH73xeCMbQzuqtvf4Ss5DL8l1y1Mqn5nYy7xm/MCaL5uveatO?=
 =?us-ascii?Q?qKQVY38qpp8BGdTlFpTApymDT1VVrNuk4cBDDm3/Aw1wGc+E3+CBZHrPV8GU?=
 =?us-ascii?Q?kI4apDf3gipltJmxyWVg/ZFVKGzHDhFY80bIjET3HpQDjwu5i2ldkGCsVM8K?=
 =?us-ascii?Q?2tDtaLahvd35Duabc2NQHO9fYODkcnMvbW7M2r+M40DklyTb5OTlvNV4EUd0?=
 =?us-ascii?Q?Ua7vp0+nB0SCRtv1EjSXQ9LgI/frU6Nn4IDKz7dx2BOt4Irwfygk71XOmdbr?=
 =?us-ascii?Q?Q+IaG8eBk8ciFw4HD4J9iFRgoN7rITLraoSQ8ZaCY28G7MRhUVgaH4hxmIP5?=
 =?us-ascii?Q?Gltyo915EHBcupdS5MTe6GGsagNooQjjzGEw4k7kpQ9dFMrzYz1KvCPMCF2H?=
 =?us-ascii?Q?bchjVdeaV0rupJO8Imwud8bDvDIpVidw4ccv0+Je/YrWHxElpT05GSt0ZRAl?=
 =?us-ascii?Q?o5qUoMvEf0MiBF7NVdWjnOGjQmWStYSm65Tm65Wfr4vOieTBYB5Ao9BWM5iw?=
 =?us-ascii?Q?JF0B8RXUCNgu3m+Fqgq7r/iwzUp5B0Pb+0YNmwDwPHcACxer4OsKMC94hqow?=
 =?us-ascii?Q?KctyDpyv/gujOgYd2JN0ACf4xcvV8bC/YOy3ZTLV6coAedofahKJRTah5+8f?=
 =?us-ascii?Q?cwycJSsFk85qqj89Pji+y43NCTHtO1qAlk/BpNHmb1Pg6eGeRiAgUWrX1XPU?=
 =?us-ascii?Q?PIxyGfKhNoIyIa39NfL/mjaOARWSAT6VYqG2E8gMka2QlLg2MicB4zEkLUV3?=
 =?us-ascii?Q?aIsHs7f5J2+Ghdj1uHMBaZd/x+2xffLMTDuztUXm6FTK62FcDDtBFM+Bf51M?=
 =?us-ascii?Q?szfsTi9b0mKzz8EsOBwTk4URPXod0OHO+ZWSQ63/X/9rfyi4FUAjf7xfKmx3?=
 =?us-ascii?Q?cflfs8RGD9N7ei6sQ8p2zQ61L/8vGLYgpQMzQEgXxKmhtup4AOurT5o4z3+W?=
 =?us-ascii?Q?bvNbNkKBYoZDPsIkeEVAd0Cov5Sb6Ro2QTCYcpqlQFw7b9c8tqQ+9RZndL9N?=
 =?us-ascii?Q?cnh9Z2dSeFlMFO47gamjetctpdt0PY9gwYQX/WGa2Oxe18e+xjBJz4oGKtog?=
 =?us-ascii?Q?HyDsqxZeQDgNAd/ZA9U7r1vlbnh36QsoFcNVjSra1WR/4cIcptZ/bFVKHi2J?=
 =?us-ascii?Q?+OiHa03yxgZJyPhPl320q2C80VyBgbixU5EqyLgQBSWGTsqCwUX5avb5WVdo?=
 =?us-ascii?Q?Awy1cojHirmqUhMM4CHP4sgpL4MYieTRIeVHQ4U+phKGjEt/DaXft7nL/xgk?=
 =?us-ascii?Q?sR3lIpKqHltMh8dxTJ4SLnLgTvwPFspCoE6GPIfP7whGuXgBx6hV5KnAN5hg?=
 =?us-ascii?Q?i3XrbiLj2cN2iVtdC3w=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b43e068d-b102-48cc-c915-08d9eb102eb7
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2022 14:34:58.6530
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VhZGwclAoAvXU5P93WLfJOxN9lWWTZoN/z9r70AugOLcA38mOSrLTNfjeeg5n0lH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1388
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 08, 2022 at 01:34:21PM +0000, Shameer Kolothum wrote:
> Add a vendor-specific vfio_pci driver for HiSilicon ACC devices.
> This will be extended in subsequent patches to add support for
> VFIO live migration feature.
> 
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
>  drivers/vfio/pci/Kconfig             |  9 +++
>  drivers/vfio/pci/Makefile            |  3 +
>  drivers/vfio/pci/hisi_acc_vfio_pci.c | 99 ++++++++++++++++++++++++++++
>  3 files changed, 111 insertions(+)
>  create mode 100644 drivers/vfio/pci/hisi_acc_vfio_pci.c
> 
> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> index 187b9c259944..8023b20acf66 100644
> +++ b/drivers/vfio/pci/Kconfig
> @@ -44,6 +44,15 @@ config VFIO_PCI_IGD
>  	  To enable Intel IGD assignment through vfio-pci, say Y.
>  endif
>  
> +config HISI_ACC_VFIO_PCI
> +	tristate "VFIO PCI support for HiSilicon ACC devices"
> +	depends on ARM64 && VFIO_PCI_CORE

You should try very hard to make this driver compatible with
COMPILE_TEST, I think it should not be a problem.

Jason
