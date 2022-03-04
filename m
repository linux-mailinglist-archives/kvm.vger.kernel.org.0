Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5B2E4CDF40
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 22:01:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbiCDU6P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 15:58:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229474AbiCDU6N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 15:58:13 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2046.outbound.protection.outlook.com [40.107.92.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80649E0AD3;
        Fri,  4 Mar 2022 12:57:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eaZ7z14pTr/PuwHoSspWfPWB3eRRmji+aWLY4DXitatdwrWXFyRzqnpSWmIOYNtYkck4OGGKvVtuKfZ1s4Nu5+uPGqBI0vDtUpHWebHPQCND0wfHVdJ5N+3ekR5pAmQ1zpoVE1MsqeBhJLG3HKxn1hDBed3REqkMtbvAS2G3w+4hkrkYSM0A1Qg/yW9oqO0WJV/qprW/d2Stl9Dhz+j9bbdsgcmXToIrbqWlTQTfdZlcTLnJuVs+GiyTkPWHkD17cEcdvg+/7GIY4h0r8sqCzxrb0OGPeUcoKMu/2Qm2AaF4cvcv0CNo+ghwQNho1xjhEJmXHgWuC2j4Fgcefm2+WQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OCRSEm9tVteoM/zBpKvwvjYLfbBvvRtWjnfLXnzo3hY=;
 b=FoR41nHeZmI00OdhVisko1hvo2GglTepbQH7gb1Ouw3zKCnKfumZ8J+YHda2bz3be66jrW2WeE9WYHFJsYU7Vxrv2RBSYI5s0fAEwD6qfsa9hVvsW79bdVJ74zSioAecwwyie6vvVly9HOf2g3I7FHID0ZGHTZtaSFEhVku2bCd1QGYg9ojrxax4WpDVvmNnv1hcdaklEguD14OsxM6CJ78SEN99twp+Iuecn2tn+ytRsyd7kh0/pJ6VC8OhAakZ5NAaNjLeixMy1pCHeJvRI2mdYu2gsoQkkrsgsKChZwV1Hty8cIRGvIgcJf8946li5SJxkk/zIg/mHhqwUabn2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OCRSEm9tVteoM/zBpKvwvjYLfbBvvRtWjnfLXnzo3hY=;
 b=X/Q0ZcfWkcT5MmPpGv057IlSAUqiXrEeZpEhGGIzGjt4uPN8eoGATZ4mOoqGMXS2PeVHtuPFmnbzOdvmiEXrkxlUVol2eRykBDqrEkkl28/Wd/cOGblEZM0TSInM7ciZFbQianRBizZlvz/bhMHSsA0jwZ0HyYXHrJLO6wHEVjxgeJNNPDlLKdCApEGf56wtaZ+iAcjUiXcQ274oYD5O45Pi5PWOcGX6A3Pc5uxPQd0D8ERDLoRYQfDpEy3Oz6HYhmtCTW220irj/6crK1sedfmb4N4pv+tuQhcugnAXxl3s1iGHCF90X1RDiJul/NLLJR4n1vLkbWdGqp7PnUiP3A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MWHPR12MB1150.namprd12.prod.outlook.com (2603:10b6:300:f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Fri, 4 Mar
 2022 20:57:21 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::51a0:4aee:2b4c:ca28]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::51a0:4aee:2b4c:ca28%4]) with mapi id 15.20.5038.017; Fri, 4 Mar 2022
 20:57:21 +0000
Date:   Fri, 4 Mar 2022 16:57:20 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-pci@vger.kernel.org,
        alex.williamson@redhat.com, cohuck@redhat.com,
        mgurtovoy@nvidia.com, yishaih@nvidia.com, linuxarm@huawei.com,
        liulongfang@huawei.com, prime.zeng@hisilicon.com,
        jonathan.cameron@huawei.com, wangzhou1@hisilicon.com
Subject: Re: [PATCH v8 8/9] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Message-ID: <20220304205720.GE219866@nvidia.com>
References: <20220303230131.2103-1-shameerali.kolothum.thodi@huawei.com>
 <20220303230131.2103-9-shameerali.kolothum.thodi@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220303230131.2103-9-shameerali.kolothum.thodi@huawei.com>
X-ClientProxiedBy: MN2PR08CA0014.namprd08.prod.outlook.com
 (2603:10b6:208:239::19) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b84b89af-8942-4085-3715-08d9fe219395
X-MS-TrafficTypeDiagnostic: MWHPR12MB1150:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB1150D87EC584FA0B6E711E79C2059@MWHPR12MB1150.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VMBPIZVhMhvjqG+rpA5BoLxas2MxoBG9d8ohPDnAiVeb5HZ9gpIwLYuYEmFvuazHRlZQMkAIpiGzZDEMWp0dVP2u9ojjF/x00RzZTA159zQX+5gK59yB7bGyG6RXqJobgwlBqjSrIXOWNvPMUrVhbLN8eqPb367YtUuGl93yX8SqteltJJ0h369uKzU/Ri3jLYVahMJPyLNXpbTAherw0/q6UhW5yQdMf3VYN/vqCsEnLK8taoqSMVK/65QXxUlNiRwPTvPtG3fnV6fKVBBeqvTmeMkBpD2rh1CxmJl1s/C+Kn6PsMUTr/CVNF0Oy2+L8LwlykkZDsjGTVycPh4Uk1EUWm/seDj0xfUxaquBwoi8F0+TeI59YIobU7383TNxwru23JyXpwpirKow0fHG1A3gh01McwejA8Qwxv3CcWySXvfn6U2D95okZXMq6VsiptlRzUZhPV4zRP9ng8FgmjmuP9LHpiZz2hDCaDUa3aRRerMOVX97zuCkfRibGOTtYmGi8AEAc9jP5q6H5VRR6t+peesCIpc0cpPVzdJUKAEMyxWTrxBuDB9wUre+BIMn898moIusNvTH5+/9woAiZyDV+7oU0MgSrnlXfQXyUv9Iy8WFZkNwC3o4p8y74M/hWPIIbgVqYf63p4NCRst1ia9KW8ayE3TN5RP2VQHZcum3z7SLU68IC3Ubzkbu9UpT6VZSaW5tDJrHyztf17b97Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(316002)(26005)(6486002)(6506007)(33656002)(66556008)(8676002)(4326008)(66946007)(6512007)(66476007)(2906002)(8936002)(38100700002)(36756003)(86362001)(2616005)(1076003)(83380400001)(6916009)(508600001)(7416002)(5660300002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2Kt01ho33ImBR+3HDCB+n7uFucG4IoKwlpF/VgeVutiqaMGGFkvH5+WQ06rl?=
 =?us-ascii?Q?KpANkBL3m5W3xzAgs9RRHAH78U97VwX+DBql+x3OcRUfaRSlQX1IBAQmRWxc?=
 =?us-ascii?Q?T3/ovZ9slHnyfVKKpVl2HqQ2bRarmi6UaOZLrhqJ2pmKk8pfjgMD0vo45eZG?=
 =?us-ascii?Q?HiP5E8dpc3F78M7fu0acMBEKcJYFHXQrFsVLAzM+pJWFsm/0omyF2bFquegG?=
 =?us-ascii?Q?PRzbfmTJS2+14szNj3qxRdRonITd6QeOlgR1X4ns/ewh23/eOVZojdD6ZkpL?=
 =?us-ascii?Q?hRkyVQ3d+o8y+r03jIV3HwF+IdYrY3/pUt6q9p8ZVdNwJXrmkIATaGk7inyL?=
 =?us-ascii?Q?TUruh9qZL1WrWvTdM076KPN9gjjfK649MgRFHgAWYWwh7hfJ808Uic4FkNQy?=
 =?us-ascii?Q?V8h4iROa0Z5arF88IJ+LlDs8lTRzAdXyWAgORmfo0JsASAzyMdkaZvFgWFCu?=
 =?us-ascii?Q?k4cTJOTLwvb/k2qcWmRHsrOLYuysAjN4cNY74nyeHF3ZnvVGT3j33NKlDiVX?=
 =?us-ascii?Q?VDuG4+c1EZqIANtSzDyLe9PTebxfwGjVm0k2spNakGys4v9eG3HYInxQmd63?=
 =?us-ascii?Q?vpt1x4Boi+Nv0b3FRxfpbhZAfPb0LFMqjNCeyBuamSU2GdfMJ2lD9gx7opeC?=
 =?us-ascii?Q?Os3ZFmVaf/+eVPJQmy+Kbj63ykkL/sPkcBcNt/9X/weiDLQU4oplcO96+KDC?=
 =?us-ascii?Q?qsihr2s1/5TRodvBWmuBi+HvcwflRjxK5RtQb1W3BGKxfXIgFrsBsxTBu5TF?=
 =?us-ascii?Q?ZbrlzgSkHRCu953UQEYoUMQfVwyrMQou+/RErq5LQ7AK7xfa6a5vG4Jbxptm?=
 =?us-ascii?Q?uQmQdoruPRZJ0eoM+6VnUBs4n+I6gXqhMSu8nRMfR1eDo/RhkpIaScwC78GM?=
 =?us-ascii?Q?ANKNCq68I4mmvrEHw/cR7rx1zoc3MET3FwzvbtKYGyDvDWodxL1q5TDRRofx?=
 =?us-ascii?Q?Mv63ZxhAcwK5DqsM6nee7dKPHPeKyTjDjb/BhvaZnur0AI0KYY81VCAawNyK?=
 =?us-ascii?Q?xaiSDl7Y4mFWlNbTxE51KEeA+S58oiWzF8EyCbEbrU5NBwqER9u11B7iXO+W?=
 =?us-ascii?Q?p//HfCXbQmS8n4jOp51hIMyfeuBYpPlgbxw5uadO3jeJ/omvs0Q39UWIGRtt?=
 =?us-ascii?Q?iQu4IWSkJ/AkLX5NXxPjXKyqloZM+amz6rVEgFTpKhyU2JTuh3r4Hf1DFl4J?=
 =?us-ascii?Q?1FRT8hRLXu2Jnr3rfU77AUoAflakkighVhGSSB6aRsFwv+RApNfJRZckFRzH?=
 =?us-ascii?Q?PRcRrsXNOsYUDxvxVD1nJJxf9FYKHmIAeey1KePe/rLt3n4J5+jPqyMlPvs0?=
 =?us-ascii?Q?vSKFgvS7u7BNLNqQOX6CNs7kgGcOwkE4DTbqPExC7kIaxEITq3MkQ3aOV/t9?=
 =?us-ascii?Q?nEAr59wtUcC3WMk6l1/gZFtu3ilOwSxtzwcS3z7jUYfP39tzOzOLUqQ//Bgd?=
 =?us-ascii?Q?b+PXKDIXtn1BMqE8wxSalLUrClOlg0XOYgL/DKAcNziSvRL+RQ3GCCzzHL7Q?=
 =?us-ascii?Q?lUPGNGQRkuZbcqJjylvi7RRUTTPnq36FtEcTjF/X1UddE+QmRLWvlmTALKVw?=
 =?us-ascii?Q?34JiXPiHmaw2J/zShJk=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b84b89af-8942-4085-3715-08d9fe219395
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2022 20:57:21.4759
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VT7hQZn8KZc6epSnTNyuG3Uk4G/1bxjJasjtD6AjLTe04X1ohnfTEk7+2ynJla90
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1150
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 03, 2022 at 11:01:30PM +0000, Shameer Kolothum wrote:
> From: Longfang Liu <liulongfang@huawei.com>
> 
> VMs assigned with HiSilicon ACC VF devices can now perform live migration
> if the VF devices are bind to the hisi_acc_vfio_pci driver.
> 
> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> ---
>  drivers/vfio/pci/hisilicon/Kconfig            |    7 +
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 1078 ++++++++++++++++-
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  114 ++
>  3 files changed, 1181 insertions(+), 18 deletions(-)
>  create mode 100644 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> 
> diff --git a/drivers/vfio/pci/hisilicon/Kconfig b/drivers/vfio/pci/hisilicon/Kconfig
> index dc723bad05c2..2a68d39f339f 100644
> --- a/drivers/vfio/pci/hisilicon/Kconfig
> +++ b/drivers/vfio/pci/hisilicon/Kconfig
> @@ -3,6 +3,13 @@ config HISI_ACC_VFIO_PCI
>  	tristate "VFIO PCI support for HiSilicon ACC devices"
>  	depends on ARM64 || (COMPILE_TEST && 64BIT)
>  	depends on VFIO_PCI_CORE
> +	depends on PCI && PCI_MSI

PCI is already in the depends from the 2nd line in
drivers/vfio/pci/Kconfig, but it is harmless

> +	depends on UACCE || UACCE=n
> +	depends on ACPI

Scratching my head a bit on why we have these

Looks OK though:

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
