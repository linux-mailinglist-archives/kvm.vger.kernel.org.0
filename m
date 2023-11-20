Return-Path: <kvm+bounces-2118-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F172E7F15B1
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 15:29:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1FCAB1C21822
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 14:29:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AEF11C6B4;
	Mon, 20 Nov 2023 14:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="W8E8Vgjc"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2089.outbound.protection.outlook.com [40.107.237.89])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B4F698;
	Mon, 20 Nov 2023 06:29:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m7TRiHOFwXViAWlxyWXu8YYLQrbRzd60F84+Hu9OozwexeZeSivnZxmCGacWQF5EI/uh3+sjAhpisOzWEk4rVGHXNIgEbRaXSs4f0aV39xeg03LVzqDOh63FR8R11OaDwyzWpH/KDzmGdxAhU5xbWE5E9DwzlXGX2pa+cl4a4vaj8BmISfeXunUy8xuqms/w5Kmahh7QkfBXhQoH1mhN+wvM1zhJmeRTAGlm+Lr3CoRay8J6+FlggVoUsb3Dk6bVTaf0kL4u1VkKxkchjjXYglBLT2vcSUBsJtEvDF2s3tS3UJMZC83h8UrB06R0fHD1ArpCQ2EmZ4SjfjaY9kzKOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7by+eLfwHQCnYuH2fNiocsiIGHdDW/4/5Ty6E7ZoxLE=;
 b=BgA7bfsafquYwa/xvvMwa/k2hy5YOtm5gnMoxtntoHYYl+c8T8Pt6PG3bgbvHRb0V4sPBardakckApa0preze21IYW8U24WHa+0MRmeCmVIaO0UeeI0UcFBGe59q0VIt60jrQlhgfCaMz/msc/xUBsM56wqOwwp0ffnmrNdveLBfFJsLRHaMm24XDPPnEj9/qHFXyXTaO0NGE2L3In7KdmEz8185mO6VQ5OO50ENXnlsqOgptgvGRiIPz6VwGkUBt0arZpGdVPS5KTyZgMgnDaKOVLm0zuDnrSKI7Qv97uNPojskRrSmqns+HEPJhVTVfnZEKmG1o1X8ncujAdvceg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7by+eLfwHQCnYuH2fNiocsiIGHdDW/4/5Ty6E7ZoxLE=;
 b=W8E8VgjcaL/WxG9mmsCudrD4UwBCccky+x78mJ2UWVrjevWUgsQvGbceHqvrTSVqy1GNw1oF9mcShl4o0VxoAxCCNWR7WNaYIJYV/P2L7SZyaRoKFrTUec4cf0JlbLhtC/FxmDwXUQBmnI4mmpv02kVkhC7Bw15GdXB+oOs4toFmZGhoZFcedqJKgjQxzg57uoc4bygxS9fomcS7+jBTszOe6d5TkIDJdtKxXsmRSgQW2LbhDQ1vjb48tDsHtKrySWDzRbQ8QGnLlm0lRSXUTzRPa5q3q9Y6kGDoaDewgrqdjV1MpyMZbF6XkuroCdd7I8/J76nGZ1ylBUjAFwOglw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB7307.namprd12.prod.outlook.com (2603:10b6:510:20b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.26; Mon, 20 Nov
 2023 14:29:31 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7002.027; Mon, 20 Nov 2023
 14:29:31 +0000
Date: Mon, 20 Nov 2023 10:29:28 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	alex.williamson@redhat.com, yishaih@nvidia.com,
	kevin.tian@intel.com, linuxarm@huawei.com, liulongfang@huawei.com
Subject: Re: [PATCH] hisi_acc_vfio_pci: Update migration data pointer
 correctly on saving/resume
Message-ID: <20231120142928.GC6083@nvidia.com>
References: <20231120091406.780-1-shameerali.kolothum.thodi@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231120091406.780-1-shameerali.kolothum.thodi@huawei.com>
X-ClientProxiedBy: SN4PR0501CA0110.namprd05.prod.outlook.com
 (2603:10b6:803:42::27) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB7307:EE_
X-MS-Office365-Filtering-Correlation-Id: c6848490-6953-44f7-ae52-08dbe9d51bfe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	vkE4Jsx8NowdmTvC8KYcctSKSFMmCsUgS/WRLyl9vyBpD8uu7u347O/yjjxitbNIMHUQ/6+Gnu6+bgneVQerYk5oRlVPS+lq8vBn/xA9wkvLDG0HwrT7iEomBVJ1xE3uJCKJGTwn3He9WAsqzoUNq5F5AhNmpd/f1CzMzJSXgzPe2BoB0i97fsON1/sAu9HG5T6GVkhZq7+2/cOl2Z4gdKLJi9W9fqslzjc9gqAmOjAWfoShuPDpmsuzOEdfGMyNIpSCV6zIBqXmo/BA12LPvzCigE5ShFFTCL9t1HtsKfO33N/34go2FfdDTEZ34GWvd/mztR8EPhxxcVRFiwgST2OJo2AO43BuasPm3pWCNty5fA9r9z0ydWGyGYpRaseQhw2YanoFwotWI+bjb+6GTQP6VnGxOlJ4R4AmaskLfT652R0WunA++nZ4em/51grYgrBziIdYAdhHokJTqwCKFTLluZUq/T47iGn6ek423eWAnJhUw/27IM1j5/kL9KErIH4EptS4G7dQEZTp5LLeo9xLFoGpXvIsTmrKzbzQVlTN7UvwPSGC1Y2fCPvw+AOT
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(346002)(39860400002)(396003)(366004)(376002)(230922051799003)(186009)(64100799003)(451199024)(1800799012)(83380400001)(36756003)(86362001)(33656002)(38100700002)(66946007)(66556008)(66476007)(6916009)(4326008)(8676002)(316002)(41300700001)(8936002)(15650500001)(5660300002)(2906002)(6512007)(1076003)(6506007)(2616005)(26005)(478600001)(6486002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xZfk56657jGwqquCaFd/cg7zG7bDT6KpGM5ZSTccH9BbmS7t2JyVmEOZpBRs?=
 =?us-ascii?Q?kkaslQ9gcyv5q1CqhUBDSg3apHsTABcVomOgX+YGtldNs6VCgV24kq/bUTDJ?=
 =?us-ascii?Q?U1BEUhJZgjeAI8grDlq7ghCiqoOWIVpy1F2ZTJW3sJuibShFSovU6jNRvyp6?=
 =?us-ascii?Q?YWlZZ0VZVi5f3267UkD3X9PmN9B+zGlKntP3B24n3OCDm57QqbVgfGyBHKhO?=
 =?us-ascii?Q?nudUriagPxEGJEmyNpB8I4YFNbi7K8Vqa814QGrTZspS6QIpbZorJ3Z+J674?=
 =?us-ascii?Q?78eRUTSJ9/zZr6F1qCO/8aeETNsbn9ceHTZGbLgJMvZ/ppd3ClsxUMXsvAnO?=
 =?us-ascii?Q?1OZmOyd76UHrCQQUxsGMDPrSSuR64BNygY8QSZkTfOWuKl3Rezbr9Bp3HJKt?=
 =?us-ascii?Q?VbsrDLlftpp2WTI3aNFllyLHawG/BrsIFZwN5nLBuA5y9ej4WoBKXP93bqUZ?=
 =?us-ascii?Q?t5r72MGkpXUUw/56sjZtgNRAQkNSly9h/jfw60/CzMjWhtjUGfEn6i8EA3Nl?=
 =?us-ascii?Q?KMtc1tKOX7AgCwoSX/bwSCYhWUVsTGvhIEEvU68QxJhcuITlpuK8lPh25kVm?=
 =?us-ascii?Q?n6ADZLni4bOkwRYI5Af0zvjeRqLidjACBLMBNbCMUFo1HmqrAxN/KMUgxEMw?=
 =?us-ascii?Q?TE198KQk61owGw2+m41Wi0Al/D9P9/T4pHBzcgb84Y0UyJ9ZOLQjbMRTr31b?=
 =?us-ascii?Q?zcyI2BYYB7dNJl8c57KVrwFdsBzUedAwiPMNc6SRcwABylxa/ogh0Wxqb0wr?=
 =?us-ascii?Q?ju/deidxPofzyPiK6yC4XUgNZXR/a8VfGr4pdVP+1n8XBgD832kn0Po1DbLD?=
 =?us-ascii?Q?D42QMKf+nqDI1KGKVjtRNk3b8ayrLP/bOHBuN0s+vtEl70Jj3cxVBhjvefQ2?=
 =?us-ascii?Q?eU8mm/MHc5ShQSV0z30QPITSwJcI6HcwhJnAsN1gGpPFxlwhag0yb5FJL+TE?=
 =?us-ascii?Q?n5kODW9QqeeRFSOrXi2c0N9dbL+KKshNP6DwST0IM++quYtAoW/JarcKQb2e?=
 =?us-ascii?Q?j0oJbIRhR7GD6BsehTaP8fGVxInS6DVG0RmhieBH3R6CoDmucv1zbLzh4Eoy?=
 =?us-ascii?Q?XayeQupqRYzWRX9oKnaCz3wxmxtzCLUrIU1bqg0zMEkw6F4A9NSZvsbTScWJ?=
 =?us-ascii?Q?GDU+9faYV3RHcQ952BIZdzqXYH1EzgFcw05xGNHkgtnpqP6u1EvLGXox/Vq/?=
 =?us-ascii?Q?qfrBsGxgijYWiNK5mwFfFBG3gvvav5eIH25/WAuIlDys8lE3rWqPSfabbqom?=
 =?us-ascii?Q?aQjABpiL2PoKCjN6PXkVMzgKFVrQi/lc1PDVEQsrQZGQOGUBWOwVFmlEYo0P?=
 =?us-ascii?Q?cjq+2rB8S7Pm4M0hOY5A5Vg0iFPHW3Ci0pUQJPuEI9i5C1Ow5btTE//odBVG?=
 =?us-ascii?Q?k/TgBGhcLpBDeyIY6YxutjamWrFUzShkNRHKTnhjUn8HP1UQLCSADFqnlMZ0?=
 =?us-ascii?Q?S37e5CA3CXrorR8RMdgtW/N/KYOL9YC/uslshZsw1eWq8WYf/DoPm6dOUnWY?=
 =?us-ascii?Q?mmRbLQriieM6OmMLDFoMveN8k/1SOTYSkaq6WP693OJvL0KoC6JDm6T2U5Zg?=
 =?us-ascii?Q?tr/MjIsbERxpkS6AvEtOR4VvpMwNrkBSQvosI0Zi?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6848490-6953-44f7-ae52-08dbe9d51bfe
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2023 14:29:31.1138
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SUDzEokSZ0+obN3Cm/rmZ50fS94M1m9c6NO0bDuhT3ijAvB4VPqWbbQ6CeMMgqte
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7307

On Mon, Nov 20, 2023 at 09:14:06AM +0000, Shameer Kolothum wrote:
> When the optional PRE_COPY support was added to speed up the device
> compatibility check, it failed to update the saving/resuming data
> pointers based on the fd offset. This results in migration data
> corruption and when the device gets started on the destination the
> following error is reported in some cases,
> 
> [  478.907684] arm-smmu-v3 arm-smmu-v3.2.auto: event 0x10 received:
> [  478.913691] arm-smmu-v3 arm-smmu-v3.2.auto:  0x0000310200000010
> [  478.919603] arm-smmu-v3 arm-smmu-v3.2.auto:  0x000002088000007f
> [  478.925515] arm-smmu-v3 arm-smmu-v3.2.auto:  0x0000000000000000
> [  478.931425] arm-smmu-v3 arm-smmu-v3.2.auto:  0x0000000000000000
> [  478.947552] hisi_zip 0000:31:00.0: qm_axi_rresp [error status=0x1] found
> [  478.955930] hisi_zip 0000:31:00.0: qm_db_timeout [error status=0x400] found
> [  478.955944] hisi_zip 0000:31:00.0: qm sq doorbell timeout in function 2
> 
> Fixes: d9a871e4a143 ("hisi_acc_vfio_pci: Introduce support for PRE_COPY state transitions")
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> ---
>  drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

