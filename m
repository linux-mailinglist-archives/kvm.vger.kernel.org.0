Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F83E63CC4C
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 01:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbiK3AKh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 19:10:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbiK3AK3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 19:10:29 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2046.outbound.protection.outlook.com [40.107.100.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B2D132064
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 16:10:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hEiBNyw3h/Pf/HSWbjA5sLDLrUTw/IaEOj8fbehmLIgP1auGxztcMWnCLQQpJ/MkZNLE+eqdmDQePnhzqRIMmB/00j02/DLLWiT1qlUS7N/DLoVkGhD4dtkCr2NafPl0oQ2CGBhib67RGKtfqZJD9zQ2LaVnp9zcslqvLdS+RSoFJGkb/ckkh2XaqrMNapyhLpptAGm/j8+NmCxP4eZ1Ec5KX3r8OIH9tu7E83GFf0EmH2605iXcrLxqX5uSZo7aoRLzCwbBnx3JCQLDPBNk9FtmSg9Ddv1onFING1Bn/owjjkHMBMh64ASdIq1/hZyvGw6/SJPJiL3ulrPrczMISA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UAs9ZZgcvkgCemtD4DNGDFuL5sM2lb8xOFx0kvPzz2w=;
 b=ZLuXiZ9U2QQwS69jY0IcSrsW8EHc/xqPdXIFONv/TMj1tKeTizr9ZDbar5l8GOrSC/ikc4bcAyHxpgLLZstcl3iWY9H9/9pxvQ1e2VADL7bR1bpEvUZTaxWxzQXiixHX+DH89vSXu3HsLBmgms5UIZCnLLyqx4u8dTs4bkQXPr+aT4jPCFiz71h1Aus6/O0SKMkc5c8VYSB1GTlo6uY52lkyu9zQOpOj/MJtWh1+tFY974jssa5CSFamBTKGXXvtfdo2ZIQURfI+MtGv048CGVQ47lop5qACKfKdI2HYZVz+GZK3wLAEA33JUcWALXYoncyx9fxzlzh49+/FXBpYDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UAs9ZZgcvkgCemtD4DNGDFuL5sM2lb8xOFx0kvPzz2w=;
 b=fy0M/nPDBdwc/MwlwxwISRf8x1Kj4v0Imkpxt5OWh0RgCzBbm+SQNSx1v5qHJYEfn8qLz3WeeOWdJ4KfYPvUfrSYxOO3zsUVaBpaQrTi9lfD4niUqdk581oDMtCKUC0r/0zdnmFwmaRwRVN/vkOf/CGTjOYCJxd7NXT+MB7CYeBNGMeNvoWEwzo1/o9ZdzL7jSlNstlqMKCT5ao3XjLwxZz6m+MtHD0w0DhNLvZ4C1vsrJHvBnCUjAsrJdHuLzNVTuNhZDk05gMXppDuZP8DS+BQ9HoaphzeAlLCIjNcrzeU3UxMyCGKvw/qj+v+H+qvEfTcgpCzNIbJmtB7NPFPVg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA1PR12MB7411.namprd12.prod.outlook.com (2603:10b6:806:2b1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Wed, 30 Nov
 2022 00:10:25 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5857.023; Wed, 30 Nov 2022
 00:10:25 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        =?utf-8?q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v4 2/5] vfio/spapr: Move VFIO_CHECK_EXTENSION into tce_iommu_ioctl()
Date:   Tue, 29 Nov 2022 20:10:19 -0400
Message-Id: <2-v4-7993c351e9dc+33a818-vfio_modules_jgg@nvidia.com>
In-Reply-To: <0-v4-7993c351e9dc+33a818-vfio_modules_jgg@nvidia.com>
References: 
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1PR13CA0331.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::6) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA1PR12MB7411:EE_
X-MS-Office365-Filtering-Correlation-Id: 75ecb609-c9c5-4066-c916-08dad2674709
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ns1M4g+GnTEkBLwFGEPFtpTn3+wMltiHUU5ZH1yHgWMfz8/zufTcK/Tc1r8f0Wb8y4wSZxU6j+ep47xhyBCSiDdwRoZVjTLx3fRQQtEnLcDopqYfPscS5Jsw/myoMsYoH6Jnm1mDZFes/l0p/5i/ZULhzmjs9wCtq2UcKRLlSedDwyPKkra8f3Z/L1YFdwsBW0jwB+GIejKdrF55hE0/ylJ6/incuTymAOWJXWkddBF6t2Yr8CQ+cKLHBADzBYPJR0y0Mq8ACvW/hN261PY3/wEtZF2FsU5oJdCSD8HmroEWqIoxMA7B8f8pFWxxe2N0WByUhbgrwiO5lC0uoSm/M96159z8PNjKDu/25VW5GP7c/Dq+AP+LIOzB38CWZq1DwLLp27QtX5dUn8j4NezM3sFbIa9vLjLIvyTyDgkPRuLFOUpQfx+Xidq1DBRCwnLxme5JZVpN29USZATPKhfszGTu00HRgkrSNYS70r6VBsYHUivLf6SScsj5cAGuarnEk5eUnG+ZQVENk0GBd2tbKqAtIsz9KuDbBZou4f/qEpb1g6NxaI9Z0HHA71+pu7LYHAOwR+Sgtv1/JrmsToHLopA8/qCzuoMD26W4qNF1IWEoVHAsVQemGDxmIJnckd16K6FA4TWse0j4iMD99K6AaaUnUV021fvkPA0SjPzLEehNBh7jRGF+IKy4XPEKHZow
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(376002)(366004)(39860400002)(136003)(451199015)(6506007)(110136005)(2616005)(316002)(54906003)(6512007)(478600001)(26005)(6486002)(36756003)(186003)(38100700002)(86362001)(6666004)(83380400001)(66946007)(4326008)(8676002)(5660300002)(66556008)(8936002)(66476007)(41300700001)(2906002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bUhpcTVORmZXSWxCeTZZWGt4NU5OZWhqUEtBcnlUWnNWaVBFL3dsYzFkVUZK?=
 =?utf-8?B?VW1SK3lGMTc1WG5TTTgzS01KNVR1bnN3VE5XRldDZW1zZklaU3RoSXBtQW5M?=
 =?utf-8?B?cXlQTVlhVzZCSGtyTUFIcWtCeVVnc0RKWUlhendaMFV3NSt1UDhTaEdjYUZU?=
 =?utf-8?B?bXJ5MFFFWWtUWGpOMGxOSTl3dmd0SFJJeDF5cDE4UEdpNWtmdmk2aGRvaGxm?=
 =?utf-8?B?ckszTTlVM1c4bU85TmNqSk1KM2lreFZHSWlCOUhqU2d3VXhCS3lhWEk3ZFJE?=
 =?utf-8?B?dUhXejUzR0ovejc4aGJqWVFGL3NTUGhHRkd6Qy9yRlFTakV6aVkwUkxVU1hi?=
 =?utf-8?B?OEUzV2phTHZIK1ZudGF3RnREQ2w2N3dvWFZCN28vNlRJNUcycDMvSzNPeFFC?=
 =?utf-8?B?UUtqcHMveUl0anVGZnFoNHVNVWF0WFZYTS9YU29xTUFMbE9Qd0NwT1FJRnpB?=
 =?utf-8?B?Sk1EL2dWOWtXbkpSR0ZRSWpsRW5GTmRvSXdtSCtOdkZuQVYvL2gxelZHZ2NP?=
 =?utf-8?B?eFhRVnNDRGx2Mmkwdm84Y0xBMXpvcVU2NURLVklpUjhzVUpySUVEUk40VWJU?=
 =?utf-8?B?eEpiaS8zVHRhQ0MxQTlLdWNnajZ1ZXpJSWs3YTRSMXNDekhwUWpXakYvZ3FR?=
 =?utf-8?B?WnJpR2YxbUNSajhqcmlwakZQV3NXQkx0ZmRFNTUyZFZpK0ZKdWNJTlY5OVRh?=
 =?utf-8?B?ek9IRUt3VG5mdm9NT1F4cnYya0NMQjM2VUx0Q1F6UWtjbGQrRElKalhTMys4?=
 =?utf-8?B?K2tZbDhVTGFmbWp0ZHU0ZGZ0RmFwUFZxUVQ5M1pjTzdIVDlmZFV0UWgxVE9Y?=
 =?utf-8?B?dWJyN2gzczVlTjBaWFRaemNDNUtZQ1BoUXdjY0FyUk4yZHhCajdON3FGQU81?=
 =?utf-8?B?bmhmZTI5RUpicWtieWZOL0ZISzFlM1lzM21zL1F4RWRHTlplOWN1TVdyeUhq?=
 =?utf-8?B?ZVgzM2xQWTJKWnhraTJrS0lWMzgvY2dXLzNFZkpOK3NyTU5MRjNaa2prYVRl?=
 =?utf-8?B?a1RMS0JlOXArOXZERWQvQkU4cThjNWJ3RURwTW4yRHFtTFZvQkV6dVNhRk0r?=
 =?utf-8?B?SkprVnZWUC9pK1JTYXlpM0laeHdLSStOb01OdE5wTVduUDM0S2VnUDJocTJL?=
 =?utf-8?B?Yk9ZOU91dmlodlRHcXBiNzFnQkdDc3MrMWVHRkVoQzc4Q2RUcXY5ampQZ3pP?=
 =?utf-8?B?dFRpQW5RZDZOM2N2WE55dk9ubmdzU0t4UndKTWdiVEQ4MEpDT1RWenFscGpy?=
 =?utf-8?B?cmQ4anFISitzSUd4K3VPVTR0NWFWLys1ZWg3emsxOGNMc2d2REZHdXoxbHIz?=
 =?utf-8?B?YWg0SmNWc0J3TUhFYUUxc1I4WThwVktCZC9ONzZJVDh5djQzczNtU016OUZN?=
 =?utf-8?B?RGlNdlluNVV6eUE5UHRrYVhiRUdKRHVMU2Q3Y29MU1lBNU10UzdxeGN2R3JY?=
 =?utf-8?B?R09CUERjM2VDNTBrR0tXSjQ3NllrVWZVa2ZKSWMxL0ZEY29QY2Q3RTZ4MEha?=
 =?utf-8?B?dkVnYmdwYTVPNTZtNVY0UWpKSWxMUFNHRVlyci9odTI5YkFyQXNTYlpySE40?=
 =?utf-8?B?dTAyMDdNbjMwM1ZrYSsyb1hGeEwwRTB2YlgxLzFkejZ0bU8vMlFjL0l0eWlD?=
 =?utf-8?B?TlF1VWc2ZjNiWmpVZS8yRUpjN1g4M1F4UFVBU2FrZ2EydFdXRVNRMWc1NTMz?=
 =?utf-8?B?MHVldFBLMXlBd3VlNkpNamdUMDlRQ2RuQ0hubW1TZ3QzMVFjWXdrQ2N1cHBS?=
 =?utf-8?B?L2ZxME5mb3E4cnFXc2pnd3dHOG9ibDB3ZCthMHMvWFdzWnl5TDJXdERQZWMx?=
 =?utf-8?B?Q0l1ZTNXRWcydWJEc05POVFXcDRvREJwd3R2Zi95WnNpS2hTNDNoRE5adUFU?=
 =?utf-8?B?R21CQVVxTitjWXdBWWM3R3J3emh4Wkg2a3pQbTlMdXd2Tjl0cFJVN0x4akZH?=
 =?utf-8?B?Ujd6NklCSDhoREt1NXZpb2IySmRQRGQ0eXQvSmdTUWJvMEV1VzA0N0tFb1ow?=
 =?utf-8?B?NzduN0ZrMjRKd1VzZmptUmxoR3c0dmIyWEJmdW53djM2aUxQU1BkeC9EdDd2?=
 =?utf-8?B?RVFNWmVLaFhoekNYWjA4emszMmljN3ljTUxYTDBSZEw3NEFiUnZmT1NYWXRr?=
 =?utf-8?Q?g6Gs=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75ecb609-c9c5-4066-c916-08dad2674709
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2022 00:10:24.2571
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CG5Mu92swornCGC1oVgTAl04tBVPZ9rnismkOypuiiyaDXJHZv235et6Qvq1lwt+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7411
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The PPC64 kconfig is a bit of a rats nest, but it turns out that if
CONFIG_SPAPR_TCE_IOMMU is on then EEH must be too:

config SPAPR_TCE_IOMMU
	bool "sPAPR TCE IOMMU Support"
	depends on PPC_POWERNV || PPC_PSERIES
	select IOMMU_API
	help
	  Enables bits of IOMMU API required by VFIO. The iommu_ops
	  is not implemented as it is not necessary for VFIO.

config PPC_POWERNV
	select FORCE_PCI

config PPC_PSERIES
	select FORCE_PCI

config EEH
	bool
	depends on (PPC_POWERNV || PPC_PSERIES) && PCI
	default y

So, just open code the call to eeh_enabled() into tce_iommu_ioctl().

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio_iommu_spapr_tce.c | 10 ++++------
 drivers/vfio/vfio_spapr_eeh.c       |  6 ------
 2 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_spapr_tce.c b/drivers/vfio/vfio_iommu_spapr_tce.c
index 169f07ac162d9c..73cec2beae70b1 100644
--- a/drivers/vfio/vfio_iommu_spapr_tce.c
+++ b/drivers/vfio/vfio_iommu_spapr_tce.c
@@ -785,14 +785,12 @@ static long tce_iommu_ioctl(void *iommu_data,
 		switch (arg) {
 		case VFIO_SPAPR_TCE_IOMMU:
 		case VFIO_SPAPR_TCE_v2_IOMMU:
-			ret = 1;
-			break;
+			return 1;
+		case VFIO_EEH:
+			return eeh_enabled();
 		default:
-			ret = vfio_spapr_iommu_eeh_ioctl(NULL, cmd, arg);
-			break;
+			return 0;
 		}
-
-		return (ret < 0) ? 0 : ret;
 	}
 
 	/*
diff --git a/drivers/vfio/vfio_spapr_eeh.c b/drivers/vfio/vfio_spapr_eeh.c
index c9d102aafbcd11..221b1b637e18b0 100644
--- a/drivers/vfio/vfio_spapr_eeh.c
+++ b/drivers/vfio/vfio_spapr_eeh.c
@@ -24,12 +24,6 @@ long vfio_spapr_iommu_eeh_ioctl(struct iommu_group *group,
 	long ret = -EINVAL;
 
 	switch (cmd) {
-	case VFIO_CHECK_EXTENSION:
-		if (arg == VFIO_EEH)
-			ret = eeh_enabled() ? 1 : 0;
-		else
-			ret = 0;
-		break;
 	case VFIO_EEH_PE_OP:
 		pe = eeh_iommu_group_to_pe(group);
 		if (!pe)
-- 
2.38.1

