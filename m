Return-Path: <kvm+bounces-2759-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 376387FD715
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 13:48:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5BF02B21694
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 12:48:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D10461DDDF;
	Wed, 29 Nov 2023 12:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="G/BCKbCj"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2075.outbound.protection.outlook.com [40.107.223.75])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FF28DA;
	Wed, 29 Nov 2023 04:48:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XpWCD6FgBQav3Qil3G6xRr5b7BlLP3Rap05ttmCGq/nBYrU0iks4DOAEtta1A+j2+Zy2DKRUrdIU9xo94o0qwLXMQSyAvxI/fKN89m+gV3tZsd4881hq48XMBw6v7h9pKbmQdUFOt1+HaLNqu9TYJT8RKwjqYN9l0PgLZiwgShLwwr7g0qtEQT4lO4zMe4ZWILMTfM98Rmh8zH95nwja02UV7x5VPvSx86CXBx3v3MGV0hGvECRVlGiQAQSRp0AdVSysJ/7+ptFL8rq1o3p+9EgVfEbGGC/T3d2Em241H8h8obeKGSALphDEIkiGaGX+FbCeOuP0XqScgANbuIyMYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lcWq4if9cmADukEvBcodVOCwdQ3T/ZT/uMOuXBb+b1E=;
 b=Pj7G+wNKfAsR34SQOCxVMNghCM+ze9hCI5D3dseYbJ+68yzXJ/yJqxfmjNUkkFvXvjyzzg2seGLpUa/q9G0yS014uSKlBzqtdTc7V/uZCf0fnUsJav2W2vq0mC8PMVqvWmBjqVKXkDn1VVpWdLnMA5kWK/r0TAT+tA3Ll9SeQg7qzCrDmu712aukn7OHuZ/VqsrgjF6A4TqfN1rWUTTmZzKxcFgyFr601durGdR7JG8vtR2DKNd1wu26WFO9rUq7p0YjZYb4FSmugyH1l7K9WbFMCbCCBtedrGdajr7fqWH3wUi4cgQ5cTwTrBhvEpm8Jxzh2v4FcDCtrpO67J4pGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lcWq4if9cmADukEvBcodVOCwdQ3T/ZT/uMOuXBb+b1E=;
 b=G/BCKbCjlfHJIHZURRDJEbJGa1lkw5czhgLyTxqnTAbOPij2K7DitjlS/lgCq/nq2Fa8OTEI4lKmIyosyL1tfDU2JjYVvBhnkxUfOKQekkcjfRZw1ESAqMd+AXytiTZrStVY7ezQrgAaoBosYhUmpLSXcrswiEdETbPv3bAvNYYVv6/w0bx3ZLZZ1KLeHSavucqlFTzlOJQJtsoeCnKL+vTsZxkC0w0LnzFw1H0v7Qvk/j3CyRzf4/Ll4ASYnXkCAq4xJaL/hWN9nESomexBl0Kz1i0NrUAWOiOv3W2zU299zWhFTofjrSAqeU3Txvd7iR7yrw5aokmCD/w4L+kVwQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH2PR12MB4134.namprd12.prod.outlook.com (2603:10b6:610:a7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.23; Wed, 29 Nov
 2023 12:48:24 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.015; Wed, 29 Nov 2023
 12:48:23 +0000
Date: Wed, 29 Nov 2023 08:48:21 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Borislav Petkov <bp@alien8.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	James Morse <james.morse@arm.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	Marc Zyngier <maz@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
	x86@kernel.org, Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: Ping? Re: [PATCH rc] kvm: Prevent compiling virt/kvm/vfio.c
 unless VFIO is selected
Message-ID: <20231129124821.GU436702@nvidia.com>
References: <0-v1-08396538817d+13c5-vfio_kvm_kconfig_jgg@nvidia.com>
 <87edgy87ig.fsf@mail.lhotse>
 <ZWagNsu1XQIqk5z9@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZWagNsu1XQIqk5z9@google.com>
X-ClientProxiedBy: SN4PR0501CA0056.namprd05.prod.outlook.com
 (2603:10b6:803:41::33) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH2PR12MB4134:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d0e92e7-ec43-46ea-7e22-08dbf0d97909
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	m/t+sjzr3pyerQJQ+gZMlgh86AakykYx8B2TOd4FzoXhNSDiTUtXnHiswabH228jfK6mNAcpQHOfSR6mV/Z80NAKtuuxCCtKysPLsQ6cHr5rP2cnnSEclxwBUpkasVFMHpbUJb5AFoNrHexRR/gBmI6RJSFlbQ8h7a/CI6FeWX7Q6mrWqcX1F7/EJ+rKAFO2Im1ASVvrwYFbQsjuxFAwJOyXjcOPStm3rQbHlQrZSUTFLn6Ot/7OX4ihjR+8wZ9m90B4h2J8qSaGcNfvC/N7afY1nwAeRCYGJTU4+6CX4UzKQazxFIQOFy5cxh05zvOs3kfC3JM8Ko4kUkH4+On5C2lakiMuP67DS6H1lQevvY37GXLfQPdkgzb6I7GeqZ21P9pEUpR56hTKihtnwHk7osLlbguCf7kUNZHrcxMFNTTVszmE9CgXZqabJGCLchDlr6N0HBCCVo2kcPX8XlVZPLgabQj2SDa2qb4R4v6FBbrxrcG+QQ6TcVv1aKPSbCOQG/2towL/q1aNoAYNwBy7hOJL4SSESeUeEIIl7X2RVdk9YlCcQ5wJSlh5uW2lkoP1UfelEiyDxJrk4GxxgSYGzkIlCDWbY405lZz0dpy+SoghRh4oX8+x7nx6AAIRs9nJBSIEPvCk4PZDXjK3cK2R8OAozOwlLRwqW5tj8O2SMjw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(136003)(366004)(39860400002)(376002)(230273577357003)(230173577357003)(230922051799003)(186009)(451199024)(64100799003)(1800799012)(38100700002)(2906002)(4744005)(86362001)(5660300002)(8936002)(8676002)(4326008)(7406005)(6916009)(316002)(7416002)(66556008)(66476007)(54906003)(66946007)(6486002)(478600001)(41300700001)(6506007)(33656002)(36756003)(6512007)(26005)(1076003)(2616005)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pPV1N9GZZpATuU0NUFnIt+Bsy80JQI1ZRt3PYAtyrlUY5ksj+QrRGV8Ob6CQ?=
 =?us-ascii?Q?mD7lsWzpknrRHZIhF/4lCjI7o1gXI+Z/8zYNXWoIU7FXDngJegf+5+Be3JeN?=
 =?us-ascii?Q?I8kKGsKgsSXS/EwYwUktMT9ETHT4fYXc93kgy3DyoljHM/6u1DebqFmgFyHC?=
 =?us-ascii?Q?uWhJsReWpdjsIJK1PMUTgRkZSZfvQ/stOU8mjTltnBsNhOCJd9efG5eX/tSi?=
 =?us-ascii?Q?yOSGw5It1ZP7dqJqXecqCRGrjB2BMe0RIBDH4D1dfSgYWut0epwbm9S6wtEX?=
 =?us-ascii?Q?IbeGS7kAGpJekNsdgG2OrOLI5Lwd+ZCejrcGg9Srd5R7JjlWVr4rYWXEbOtV?=
 =?us-ascii?Q?LlpZz32NZmO0Hbj2b9Ch6DQzpDpBNSIERTOfyXGyPwXBouoAVN05BzEwUEe9?=
 =?us-ascii?Q?/wfgDefM4j+uuws7oNcIPIWrVwx6Kj38WUZ1cwpxyYkyLqR3MaBKUR+ypL9y?=
 =?us-ascii?Q?AKMYUOuiF+pam9tQ+Txiq/OzHHWucDYQUU9lf6o+Zz2zIefivp7RHRR6SmDG?=
 =?us-ascii?Q?nOPube3/d54jEdIVGBR+McLU+P0DSNIF2cLp3gP6ls6Ezmp0dq8Z0INeTw5v?=
 =?us-ascii?Q?K1YOpqYhYOEAXQsvRERQwrzfRt0uJVtD6ukq+hHQd7YHPO2QkVp9qOp995o4?=
 =?us-ascii?Q?CWs5bjgYSGmf1uNG1cqT7hsqIQzbd8rNQXypcMOIhnNCPONqtT5M++Y/Z+1d?=
 =?us-ascii?Q?/FUynF9lpMSQ6FVOLPpC+/Gz/QTma1c4tCra4qVYaq24SNpFaQBW/oAu+3lA?=
 =?us-ascii?Q?6aDv4Dh/g8vGgFDCynHNxRs1GNKAsf5vJdjXlf5TGTZLumndsTuyddYD46tt?=
 =?us-ascii?Q?6KTbZjUZFK1mvarHJ4U9kCogPc/aPY5LAnx08rM9L0EFxYAfSywrTJiDEuB7?=
 =?us-ascii?Q?6WJIz9ayMViSoP/oNOgz0vvKYUxbjZSdo0AQjlbiWYBtt4CkgMv7eBNnK82Y?=
 =?us-ascii?Q?jzWzj9i6Sp8Lb2L/wP0KkU42dcLwo2DD6899ifVglY7YlBfGhr9rPKGQhtN9?=
 =?us-ascii?Q?IHVhI7NfUCKVnLAqHjB9aM/3x1lLB7y7ZdgxeK3bsIWQ8xHs9JLU+CfSLkO/?=
 =?us-ascii?Q?zAIYhx/NYvslFpDYmZOu2txY4rB85IIq9I7V392xC99YQyf6YNtcnuSd/H74?=
 =?us-ascii?Q?PACqvNtAzXvUTrKgQauON0tVq/yPBmzSpEaF+2nFAWILPcmpoaRNzIsGlmZH?=
 =?us-ascii?Q?090vO4ttjzCHObL0xtvSGRGWXMJpMV2c0YbGq9TkbYQ0P6sH/dE9tp4Z8VAx?=
 =?us-ascii?Q?YNmMW98qQlZL18YJqU+3zTNDAhWOod1tTU26KB8s9KWs1VwF5OpGHtDO9G9D?=
 =?us-ascii?Q?GSV+Ptj3cNKFJFnSgsLkXX2j17qXZzVrFSUnLNvMR2VbMr1CmgVzdThV1tQy?=
 =?us-ascii?Q?aezdwOlgbyzfPey8W8vkVayGpOl1FyTIso0zbwSWKR4gD2CHd4obpyDrSPuf?=
 =?us-ascii?Q?W4PTbPrbzJ7YIDkpNFL5UVdiCw0cHZ6REbZdJHlJPVYMjz2zzdV96fW9DtY2?=
 =?us-ascii?Q?cSeFj7KCi9P2BgqyAqYappugeaBQyPPCEMKXpeTTX9CqFGDGwu3ELXRYHdzc?=
 =?us-ascii?Q?cVyYpeKdLbeWfqObe1Z/8PkUfp2Re5cUXM5/HdM7?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d0e92e7-ec43-46ea-7e22-08dbf0d97909
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2023 12:48:23.8873
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5p79KdaXh8c3QPOQdsU/BYyWAXW+dLEl3O5FC1H1RO2rbZMGEfQ2rEC40E2dYxdv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4134

On Tue, Nov 28, 2023 at 06:21:42PM -0800, Sean Christopherson wrote:
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 454e9295970c..a65b2513f8cd 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -289,16 +289,12 @@ void vfio_combine_iova_ranges(struct rb_root_cached *root, u32 cur_nodes,
>  /*
>   * External user API
>   */
> -#if IS_ENABLED(CONFIG_VFIO_GROUP)
>  struct iommu_group *vfio_file_iommu_group(struct file *file);
> +
> +#if IS_ENABLED(CONFIG_VFIO_GROUP)
>  bool vfio_file_is_group(struct file *file);
>  bool vfio_file_has_dev(struct file *file, struct vfio_device *device);
>  #else
> -static inline struct iommu_group *vfio_file_iommu_group(struct file *file)
> -{
> -       return NULL;
> -}
> -
>  static inline bool vfio_file_is_group(struct file *file)
>  {
>         return false;
> 

So you symbol get on a symbol that can never be defined? Still says to
me the kconfig needs fixing :|

But sure, as a small patch it looks fine

Thanks,
Jason

