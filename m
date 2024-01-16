Return-Path: <kvm+bounces-6319-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 58BB682E99B
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 07:39:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E573E284E3A
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 06:39:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4780210A1D;
	Tue, 16 Jan 2024 06:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="E7/EQzMB"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2056.outbound.protection.outlook.com [40.107.220.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568CEDDB9;
	Tue, 16 Jan 2024 06:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IgwCpYfBUmSRB+0YhZ0cvUs5lHCd7N0zygCuI2WsOEsXrtBL23ODlx0RIaSnRrTLlpxjpzzwGyVrDJjrEJJB1BpXnboDjvTwXyy6yO0gD7A+qN9/seFUMTlFSSc/BBA6IefwDleKJ59kX0MDcgFq6k24WZG+GIZH1YdFlryul1Vs1ELaNP4miu+C4Hy4F0UKtives20b0jlgtYoZh+fWj+njBG0Yn/sLOgxen0p9C2Txn5mgZMdRPLHXKDter5CbHJ/5q2BzzdVtSa9k6fk6zeJy+xbYR0faf1dbvpV9cy1eiR9X5LzrlYmtwpvWu14cGqE19LPqX5AkpLvz3uYbpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lrse3qBUsF0L+KyqbTBknm1ywQFqiYMPQwaT3Ol+GJs=;
 b=O0SQaVTnTED0v2dIb0KNJKzOnP9eoLdu0Uif6q3pehqZCqLvEBvtobI9M3MCfILAUZYR7JA0Hz9JfulE171jL03R3eYh/vlXiLc04zuBr3z3v0nUcArYHz91OTgVhCIn8S4t1PTBFp+scU7Lodax+irP+WtCg1QVD04Lx1KalUAVbDQmyliVJVAinoU9aKUxdiI6fE2RYOyhu0bupX2Q3FS0IzpaNSrxcBPWl/p+GmTIZHpLtf7ET5tx5fu/WS3Tcim8iH4E1MCmyg3T6B6pFv2iQSPLLOTVB/mhNN1H/k6NbR3Fzdoe+C885gTkXRxMcZp5QyFKMazP+y21abs0Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lrse3qBUsF0L+KyqbTBknm1ywQFqiYMPQwaT3Ol+GJs=;
 b=E7/EQzMB/TDA42IvszN7DxTavRvf6oJiGe/9XqisTzEo8f1VIW4whJJVQu/qPts42M7byaoRczNPMseToTPqW3eD1673H13UvotAWTkfL+eq0QsgzUoYGHC0NpJvqfCGzL6S0TOvQfrEj0fYYw3+YqzPTpOpeZ5Y8nt6A9OaDC8SZ9ZArbVNRvJpUhzjXZ0hQrfjHUuPMH38YssXQsE95bMU8jus8+pnEfSPHN2c7L60kgJ0QCzkasFP+h1QrRe59nMX3oEYsxvNXfVq+n9FgavAhjFbj0ZjEhTNz7ch8OwnXmL8Ns7LXECWHQH8If2vjdKOJzaJ1pZAU1ukQL1N8A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by BY5PR12MB4856.namprd12.prod.outlook.com (2603:10b6:a03:1d5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7181.23; Tue, 16 Jan
 2024 06:39:11 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::ab86:edf7:348:d117]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::ab86:edf7:348:d117%3]) with mapi id 15.20.7181.020; Tue, 16 Jan 2024
 06:39:11 +0000
References: <20240115211516.635852-1-ankita@nvidia.com>
 <20240115211516.635852-4-ankita@nvidia.com>
User-agent: mu4e 1.10.8; emacs 28.2
From: Rahul Rameshbabu <rrameshbabu@nvidia.com>
To: ankita@nvidia.com
Cc: jgg@nvidia.com, alex.williamson@redhat.com, yishaih@nvidia.com,
 shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
 eric.auger@redhat.com, brett.creeley@amd.com, horms@kernel.org,
 aniketa@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com,
 targupta@nvidia.com, vsethi@nvidia.com, acurrid@nvidia.com,
 apopple@nvidia.com, jhubbard@nvidia.com, danw@nvidia.com,
 anuaggarwal@nvidia.com, mochs@nvidia.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v16 3/3] vfio/nvgrace-gpu: Add vfio pci variant module
 for grace hopper
Date: Mon, 15 Jan 2024 21:29:54 -0800
In-reply-to: <20240115211516.635852-4-ankita@nvidia.com>
Message-ID: <87il3tye7m.fsf@nvidia.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0030.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::35) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|BY5PR12MB4856:EE_
X-MS-Office365-Filtering-Correlation-Id: 45d67202-b899-417a-efb4-08dc165dd90f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	2uZM5w2eS5b7u3mDFfP25mmv0PmYtko/if06BUjRtfXefeaoMmIyrin+XZgLs1gkJ0jmlXCJy9VjWj8qg3s8sHHMaZbPGfiQsJXye4fg/zUFTzzF/DE1i5Lvt+IHs4IA425LuOH5ypxbFDUN3mGRmEz1iyCPznTHayEA4VVu0z/bpZ3688bmM7wcPo5Tjsm3+FdJrkYSs1YRyUtXAeQFm0pZ7BhcpIZsqpmDOOLdSCRLTrV+oaazbd5SsZghafMxqJxiy7ctzLQn6DcGAl6hqpvcVuFapYBD2HUm+mf8PErUZrpZ80RLRf9PJyw2n5aZHv5Ed6p4l/EechMXpppGmA3HoV7k0JKCebnNqYBlY5Ss57KpXhiz88Ex46t47Ep4GitObQOKckqDINx2KtPQsX3Sf180ASZMCxNnBarwSCj4VK2K/P3HH7F5uqMeOSc7q8B5aSmF48G3GO6oZ+khAdlDq1AD3WGpEoi4vr43rY61MTE39K2HN2ivjwXRa6gYZ8YyGmldCUsOF+WGD0NE6hdhiqVHyDmwTryUG4yjlVGuF75jqGD+NcaGmdBU2vSjtGSfGWrODgO/Y2NnupTqGmW7LL4oKYjE6Pshc8BZFyzvajA3t4sszCOrY+UVHQw5
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(376002)(396003)(346002)(136003)(39860400002)(230922051799003)(1800799012)(64100799003)(451199024)(186009)(84970400001)(83380400001)(86362001)(36756003)(5660300002)(6512007)(37006003)(34206002)(4326008)(8936002)(26005)(30864003)(2616005)(6666004)(38100700002)(66946007)(6636002)(8676002)(66476007)(478600001)(316002)(966005)(6506007)(41300700001)(2906002)(6486002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pNUI8/1xI/QVW5xKIHUn4FxzF7+5mhRN97hGD4sT+WVpWOfQ+EpGOQ8/cphu?=
 =?us-ascii?Q?mjGlYseN4+1uy0zyTJkNKBJBrSQznw28QFEVDpKVlmch6HE8+lpLJNHhrEVB?=
 =?us-ascii?Q?o0OAx+n2scgeDzYfoetIpD6g5LGcKsNmzcWV5VX2ejPmklBD1XI1MdWaD4PN?=
 =?us-ascii?Q?AcANIVHg2ktW+s4JD/oUmBIM+8hj3Zc8LvS67ZY3Hpugcg94lgonjhSxRXoG?=
 =?us-ascii?Q?7XvUeuOsLf11pBGkYlq/3RKnv/t5xvmLRt0LVhlxhOoIav34zyh3B5gKeSuA?=
 =?us-ascii?Q?Yw9cCcWutMzJUwk9LET9+j9bxdXmMf4tEBqXWxZr6MrhfOwstz60pgA0MIgi?=
 =?us-ascii?Q?iLUWM6gcdk56vqI8ZHz6+o2BwR/ql4VzRALH9fvrV0FmGtUjfaYw+8j0WFTp?=
 =?us-ascii?Q?IPT2IfLGpT2PsGkXlEqY8xBGFYevRcEzQ/FggMvZ1DlPeqZrWleOvDRvLt8x?=
 =?us-ascii?Q?juwxYXKsVtRL5caGtlQxGjWp/qHxEGgEQg07Nzyh6oB/+4Tq0qUJC5OkMxcc?=
 =?us-ascii?Q?8tfPxQKMa4AdH9JAvrdl7gA5Ca1wqOznRtXOgBE+X7tRUAN9WexVnIACX6GN?=
 =?us-ascii?Q?nE97cD2yaJCnTkoQ7IQ+P4riVeMaSmxlLVdSfKciHTAgJUiuRuDXlCUhF0ir?=
 =?us-ascii?Q?ya8aRapYGFS8Mv1YVzLkzuLVUC+GpmSpfultB5Bs37cruKWhqU8jB4t3jCqd?=
 =?us-ascii?Q?4Fec96aW/4+jrTgV1Jje+cByWTHv1vnkt79Gb0FEZ9ZiDRoN2yDgPakqbSoA?=
 =?us-ascii?Q?735sGrZ1EZylxZXO1aimr+/KZmN/n4I3zmcsSpEE+4TYzMvb9ul8jC1ost87?=
 =?us-ascii?Q?fmpfIJYz+1vSgzS8YZiLUCeTaOv6+VC33vcF7B+IAOYdTzn7KM0qsyjt0hhH?=
 =?us-ascii?Q?o/lueHH/iYpNVkercPmPwb6Np7oASyqDT6idAIK/myx7e2DiB2ufYnl7fcuU?=
 =?us-ascii?Q?cA8GsJqODNLzh0i4FblkUET0exPJ18jZTWKRGUKCGgsAVl/R2detvMUNq8QM?=
 =?us-ascii?Q?VxaHmRl28wVvAuu7ycSKjuW1fP3VthM3sD5XAdNw4o+5ZkHDEv2shJPvlyFR?=
 =?us-ascii?Q?REiHsfTfi8HCyHhUupIieJPvyP+v8qv9um0wZUE1yh17APA6tkfHxmxWcrnf?=
 =?us-ascii?Q?7IQ8pDNbb+rMTybEYyZdwcMYw3i2n94qvsRMNj+iEyv3A5dkEqDHmsO9uEhx?=
 =?us-ascii?Q?nVAKusK9sf9lekHaFEg1TZy24Im9glGBCPT54OmU/J8LLKS5l/zq7dgBNqPD?=
 =?us-ascii?Q?Uq9uEjEXrVGZOQKNhnL3dapIv8BbZsmOepOnh++gpiI9azKHr+woy8ZoNK86?=
 =?us-ascii?Q?GsRaO/IUZY5jF1z6gEDWX2l0PTdhPkhznxQKv6HfJFP7tf+ttenH2V1Qq4QK?=
 =?us-ascii?Q?jHRM7mn2Rr2d+FWS34NxGVuFkmugG6bMCDhvF6X2TLrTka7VQqYWLd8Lw41G?=
 =?us-ascii?Q?RUp1mj0PXGlIkhEP2WkwQvyUlC1Ra31F5wRLtmZOHH/omtGQ7UWEAD3tHb0N?=
 =?us-ascii?Q?wWZ2pY3NIAXDdiok3+hbaOY1p6Kcl+19iNDa2rKu7hO7OW15Y3N0kTTV2tyA?=
 =?us-ascii?Q?TwVr4qkCHo0qV+w1t04b7/HZWt/ySEYYv5HtTflg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45d67202-b899-417a-efb4-08dc165dd90f
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2024 06:39:11.1720
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8aYA+h+ykjJdcPuWpWZMLCkfyjW82rghfkUb0CPmcA625JAS3Kbr9pWDvCD7JRs8Z9tyGRGr40o2TWX+Ealy0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4856

On Mon, 15 Jan, 2024 21:15:16 +0000 <ankita@nvidia.com> wrote:
> From: Ankit Agrawal <ankita@nvidia.com>
>
> NVIDIA's upcoming Grace Hopper Superchip provides a PCI-like device
> for the on-chip GPU that is the logical OS representation of the
> internal proprietary chip-to-chip cache coherent interconnect.
>
> The device is peculiar compared to a real PCI device in that whilst
> there is a real 64b PCI BAR1 (comprising region 2 & region 3) on the
> device, it is not used to access device memory once the faster
> chip-to-chip interconnect is initialized (occurs at the time of host
> system boot). The device memory is accessed instead using the chip-to-chip
> interconnect that is exposed as a contiguous physically addressable
> region on the host. This device memory aperture can be obtained from host
> ACPI table using device_property_read_u64(), according to the FW
> specification. Since the device memory is cache coherent with the CPU,
> it can be mmap into the user VMA with a cacheable mapping using
> remap_pfn_range() and used like a regular RAM. The device memory
> is not added to the host kernel, but mapped directly as this reduces
> memory wastage due to struct pages.
>
> There is also a requirement of a reserved 1G uncached region (termed as
> resmem) to support the Multi-Instance GPU (MIG) feature [1]. This is
> to work around a HW defect. Based on [2], the requisite properties
> (uncached, unaligned access) can be achieved through a VM mapping (S1)
> of NORMAL_NC and host (S2) mapping with MemAttr[2:0]=0b101. To provide
> a different non-cached property to the reserved 1G region, it needs to
> be carved out from the device memory and mapped as a separate region
> in Qemu VMA with pgprot_writecombine(). pgprot_writecombine() sets the
> Qemu VMA page properties (pgprot) as NORMAL_NC.
>
> Provide a VFIO PCI variant driver that adapts the unique device memory
> representation into a more standard PCI representation facing userspace.
>
> The variant driver exposes these two regions - the non-cached reserved
> (resmem) and the cached rest of the device memory (termed as usemem) as
> separate VFIO 64b BAR regions. This is divergent from the baremetal
> approach, where the device memory is exposed as a device memory region.
> The decision for a different approach was taken in view of the fact that
> it would necessiate additional code in Qemu to discover and insert those
> regions in the VM IPA, along with the additional VM ACPI DSDT changes to
> communiate the device memory region IPA to the VM workloads. Moreover,
> this behavior would have to be added to a variety of emulators (beyond
> top of tree Qemu) out there desiring grace hopper support.
>
> Since the device implements 64-bit BAR0, the VFIO PCI variant driver
> maps the uncached carved out region to the next available PCI BAR (i.e.
> comprising of region 2 and 3). The cached device memory aperture is
> assigned BAR region 4 and 5. Qemu will then naturally generate a PCI
> device in the VM with the uncached aperture reported as BAR2 region,
> the cacheable as BAR4. The variant driver provides emulation for these
> fake BARs' PCI config space offset registers.
>
> The hardware ensures that the system does not crash when the memory
> is accessed with the memory enable turned off. It synthesis ~0 reads
> and dropped writes on such access. So there is no need to support the
> disablement/enablement of BAR through PCI_COMMAND config space register.
>
> The memory layout on the host looks like the following:
>                devmem (memlength)
> |--------------------------------------------------|
> |-------------cached------------------------|--NC--|
> |                                           |
> usemem.phys/memphys                         resmem.phys
>
> PCI BARs need to be aligned to the power-of-2, but the actual memory on the
> device may not. A read or write access to the physical address from the
> last device PFN up to the next power-of-2 aligned physical address
> results in reading ~0 and dropped writes. Note that the GPU device
> driver [6] is capable of knowing the exact device memory size through
> separate means. The device memory size is primarily kept in the system
> ACPI tables for use by the VFIO PCI variant module.
>
> Note that the usemem memory is added by the VM Nvidia device driver [5]
> to the VM kernel as memblocks. Hence make the usable memory size memblock
> aligned.
>
> Currently there is no provision in KVM for a S2 mapping with
> MemAttr[2:0]=0b101, but there is an ongoing effort to provide the same [3].
> As previously mentioned, resmem is mapped pgprot_writecombine(), that
> sets the Qemu VMA page properties (pgprot) as NORMAL_NC. Using the
> proposed changes in [4] and [3], KVM marks the region with
> MemAttr[2:0]=0b101 in S2.
>
> This goes along with a qemu series [6] to provides the necessary
> implementation of the Grace Hopper Superchip firmware specification so
> that the guest operating system can see the correct ACPI modeling for
> the coherent GPU device. Verified with the CUDA workload in the VM.
>
> [1] https://www.nvidia.com/en-in/technologies/multi-instance-gpu/
> [2] section D8.5.5 of https://developer.arm.com/documentation/ddi0487/latest/
> [3] https://lore.kernel.org/all/20231205033015.10044-1-ankita@nvidia.com/
> [4] https://lore.kernel.org/all/20230907181459.18145-2-ankita@nvidia.com/
> [5] https://github.com/NVIDIA/open-gpu-kernel-modules
> [6] https://lore.kernel.org/all/20231203060245.31593-1-ankita@nvidia.com/
>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> Signed-off-by: Aniket Agashe <aniketa@nvidia.com>
> Tested-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  MAINTAINERS                                   |   6 +
>  drivers/vfio/pci/Kconfig                      |   2 +
>  drivers/vfio/pci/Makefile                     |   2 +
>  drivers/vfio/pci/nvgrace-gpu/Kconfig          |  10 +
>  drivers/vfio/pci/nvgrace-gpu/Makefile         |   3 +
>  drivers/vfio/pci/nvgrace-gpu/main.c           | 760 ++++++++++++++++++
>  .../pci/nvgrace-gpu/nvgrace_gpu_vfio_pci.h    |  50 ++
>  7 files changed, 833 insertions(+)
>  create mode 100644 drivers/vfio/pci/nvgrace-gpu/Kconfig
>  create mode 100644 drivers/vfio/pci/nvgrace-gpu/Makefile
>  create mode 100644 drivers/vfio/pci/nvgrace-gpu/main.c
>  create mode 100644 drivers/vfio/pci/nvgrace-gpu/nvgrace_gpu_vfio_pci.h
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index f5c2450fa4ec..2c4749b7bb94 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -22813,6 +22813,12 @@ L:	kvm@vger.kernel.org
>  S:	Maintained
>  F:	drivers/vfio/platform/
>  
> +VFIO NVIDIA GRACE GPU DRIVER
> +M:	Ankit Agrawal <ankita@nvidia.com>
> +L:	kvm@vger.kernel.org
> +S:	Maintained

I think you want "Supported" here. At the very top of the MAINTAINERS file.

   Supported:	Someone is actually paid to look after this.
   Maintained:	Someone actually looks after it.

> +F:	drivers/vfio/pci/nvgrace-gpu/
> +
>  VGA_SWITCHEROO
>  R:	Lukas Wunner <lukas@wunner.de>
>  S:	Maintained
> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> index 8125e5f37832..2456210e85f1 100644
> --- a/drivers/vfio/pci/Kconfig
> +++ b/drivers/vfio/pci/Kconfig
> @@ -65,4 +65,6 @@ source "drivers/vfio/pci/hisilicon/Kconfig"
>  
>  source "drivers/vfio/pci/pds/Kconfig"
>  
> +source "drivers/vfio/pci/nvgrace-gpu/Kconfig"
> +
>  endmenu
> diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
> index 45167be462d8..1352c65e568a 100644
> --- a/drivers/vfio/pci/Makefile
> +++ b/drivers/vfio/pci/Makefile
> @@ -13,3 +13,5 @@ obj-$(CONFIG_MLX5_VFIO_PCI)           += mlx5/
>  obj-$(CONFIG_HISI_ACC_VFIO_PCI) += hisilicon/
>  
>  obj-$(CONFIG_PDS_VFIO_PCI) += pds/
> +
> +obj-$(CONFIG_NVGRACE_GPU_VFIO_PCI) += nvgrace-gpu/
> diff --git a/drivers/vfio/pci/nvgrace-gpu/Kconfig b/drivers/vfio/pci/nvgrace-gpu/Kconfig
> new file mode 100644
> index 000000000000..936e88d8d41d
> --- /dev/null
> +++ b/drivers/vfio/pci/nvgrace-gpu/Kconfig
> @@ -0,0 +1,10 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +config NVGRACE_GPU_VFIO_PCI
> +	tristate "VFIO support for the GPU in the NVIDIA Grace Hopper Superchip"
> +	depends on ARM64 || (COMPILE_TEST && 64BIT)
> +	select VFIO_PCI_CORE
> +	help
> +	  VFIO support for the GPU in the NVIDIA Grace Hopper Superchip is
> +	  required to assign the GPU device using KVM/qemu/etc.
> +
> +	  If you don't know what to do here, say N.
> diff --git a/drivers/vfio/pci/nvgrace-gpu/Makefile b/drivers/vfio/pci/nvgrace-gpu/Makefile
> new file mode 100644
> index 000000000000..3ca8c187897a
> --- /dev/null
> +++ b/drivers/vfio/pci/nvgrace-gpu/Makefile
> @@ -0,0 +1,3 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +obj-$(CONFIG_NVGRACE_GPU_VFIO_PCI) += nvgrace-gpu-vfio-pci.o
> +nvgrace-gpu-vfio-pci-y := main.o
> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
> new file mode 100644
> index 000000000000..6d1d50008bc4
> --- /dev/null
> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> @@ -0,0 +1,760 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES. All rights reserved
> + */
> +
> +#include "nvgrace_gpu_vfio_pci.h"
> +
> +static void nvgrace_gpu_init_fake_bar_emu_regs(struct vfio_device *core_vdev)
> +{
> +	struct nvgrace_gpu_vfio_pci_core_device *nvdev =
> +		container_of(core_vdev, struct nvgrace_gpu_vfio_pci_core_device,
> +			     core_device.vdev);
> +
> +	nvdev->resmem.u64_reg = 0;
> +	nvdev->usemem.u64_reg = 0;
> +}
> +
> +/* Choose the structure corresponding to the fake BAR with a given index. */
> +struct mem_region *
> +nvgrace_gpu_vfio_pci_fake_bar_mem_region(int index,
> +			struct nvgrace_gpu_vfio_pci_core_device *nvdev)

This function definition should be static from what I can tell.

> +{
> +	if (index == USEMEM_REGION_INDEX)
> +		return &nvdev->usemem;
> +
> +	if (index == RESMEM_REGION_INDEX)
> +		return &nvdev->resmem;
> +
> +	return NULL;
> +}
> +

<snip>

> +
> +static long
> +nvgrace_gpu_vfio_pci_ioctl_get_region_info(struct vfio_device *core_vdev,
> +					   unsigned long arg)
> +{
> +	unsigned long minsz = offsetofend(struct vfio_region_info, offset);
> +	struct nvgrace_gpu_vfio_pci_core_device *nvdev =
> +		container_of(core_vdev, struct nvgrace_gpu_vfio_pci_core_device,
> +			     core_device.vdev);
> +	struct vfio_region_info_cap_sparse_mmap *sparse;
> +	struct vfio_info_cap caps = { .buf = NULL, .size = 0 };
> +	struct vfio_region_info info;
> +	struct mem_region *memregion;
> +	u32 size;
> +	int ret;
> +
> +	if (copy_from_user(&info, (void __user *)arg, minsz))
> +		return -EFAULT;
> +
> +	if (info.argsz < minsz)
> +		return -EINVAL;
> +
> +	memregion = nvgrace_gpu_vfio_pci_fake_bar_mem_region(info.index, nvdev);
> +	if (!memregion)
> +		return vfio_pci_core_ioctl(core_vdev,
> +					   VFIO_DEVICE_GET_REGION_INFO, arg);
> +
> +	/*
> +	 * Request to determine the BAR region information. Send the
> +	 * GPU memory information.
> +	 */
> +	size = struct_size(sparse, areas, 1);
> +
> +	/*
> +	 * Setup for sparse mapping for the device memory. Only the
> +	 * available device memory on the hardware is shown as a
> +	 * mappable region.
> +	 */
> +	sparse = kzalloc(size, GFP_KERNEL);
> +	if (!sparse)
> +		return -ENOMEM;
> +
> +	sparse->nr_areas = 1;
> +	sparse->areas[0].offset = 0;
> +	sparse->areas[0].size = memregion->memlength;
> +	sparse->header.id = VFIO_REGION_INFO_CAP_SPARSE_MMAP;
> +	sparse->header.version = 1;
> +
> +	ret = vfio_info_add_capability(&caps, &sparse->header, size);
> +	kfree(sparse);

Reading vfio_info_add_capability and the fact that the
struct_size(sparse, areas, 1) is known at compile-time, I feel like the
following may be a better alternative to kzalloc-ing sparse for every
nvgrace_gpu_vfio_pci_ioctl_get_region_info call.

  char sparse_buf[struct_size(sparse, areas, 1)];
  struct vfio_region_info_cap_sparse_mmap *sparse = &sparse_buf;

  ...

  /*
   * Setup for sparse mapping for the device memory. Only the
   * available device memory on the hardware is shown as a
   * mappable region.
   */

  sparse->nr_areas = 1;
  sparse->areas[0].offset = 0;
  sparse->areas[0].size = memregion->memlength;
  sparse->header.id = VFIO_REGION_INFO_CAP_SPARSE_MMAP;
  sparse->header.version = 1;

  ret = vfio_info_add_capability(&caps, &sparse->header, size);

> +	if (ret)
> +		return ret;
> +
> +	info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
> +	/*
> +	 * The region memory size may not be power-of-2 aligned.
> +	 * Given that the memory  as a BAR and may not be
> +	 * aligned, roundup to the next power-of-2.
> +	 */
> +	info.size = roundup_pow_of_two(memregion->memlength);
> +	info.flags = VFIO_REGION_INFO_FLAG_READ |
> +		     VFIO_REGION_INFO_FLAG_WRITE |
> +		     VFIO_REGION_INFO_FLAG_MMAP;
> +
> +	if (caps.size) {
> +		info.flags |= VFIO_REGION_INFO_FLAG_CAPS;
> +		if (info.argsz < sizeof(info) + caps.size) {
> +			info.argsz = sizeof(info) + caps.size;
> +			info.cap_offset = 0;
> +		} else {
> +			vfio_info_cap_shift(&caps, sizeof(info));
> +			if (copy_to_user((void __user *)arg +
> +					 sizeof(info), caps.buf,
> +					 caps.size)) {
> +				kfree(caps.buf);
> +				return -EFAULT;
> +			}
> +			info.cap_offset = sizeof(info);
> +		}
> +		kfree(caps.buf);
> +	}
> +	return copy_to_user((void __user *)arg, &info, minsz) ?
> +			    -EFAULT : 0;
> +}
> +

<snip>

> +
> +/*
> + * Read the data from the device memory (mapped either through ioremap
> + * or memremap) into the user buffer.
> + */
> +static int
> +nvgrace_gpu_map_and_read(struct nvgrace_gpu_vfio_pci_core_device *nvdev,
> +			 char __user *buf, size_t mem_count, loff_t *ppos)
> +{
> +	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
> +	u64 offset = *ppos & VFIO_PCI_OFFSET_MASK;
> +	int ret = 0;

Remove the zero initialization since ret then gets initialized again in
the next statement. If the code gets refactored later, static analysis
can catch a mistake if ret is not initialized.

> +
> +	/*
> +	 * Handle read on the BAR regions. Map to the target device memory
> +	 * physical address and copy to the request read buffer.
> +	 */
> +	ret = nvgrace_gpu_map_device_mem(nvdev, index);
> +	if (ret)
> +		return ret;
> +
> +	if (index == USEMEM_REGION_INDEX) {
> +		if (copy_to_user(buf,
> +				 (u8 *)nvdev->usemem.bar_remap.memaddr + offset,
> +				 mem_count))
> +			ret = -EFAULT;
> +	} else {
> +		ret = vfio_pci_core_do_io_rw(&nvdev->core_device, false,
> +					     nvdev->resmem.bar_remap.ioaddr,
> +					     buf, offset, mem_count,
> +					     0, 0, false);
> +	}
> +
> +	return ret;
> +}
> +

<snip>

> +
> +/*
> + * Write the data to the device memory (mapped either through ioremap
> + * or memremap) from the user buffer.
> + */
> +static int
> +nvgrace_gpu_map_and_write(struct nvgrace_gpu_vfio_pci_core_device *nvdev,
> +			  const char __user *buf, size_t mem_count,
> +			  loff_t *ppos)
> +{
> +	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
> +	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
> +	int ret = 0;

ret gets initialized in the next statement.

> +
> +	ret = nvgrace_gpu_map_device_mem(nvdev, index);
> +	if (ret)
> +		return ret;
> +
> +	if (index == USEMEM_REGION_INDEX) {
> +		if (copy_from_user((u8 *)nvdev->usemem.bar_remap.memaddr + pos,
> +				   buf, mem_count))
> +			return -EFAULT;
> +	} else {
> +		ret = vfio_pci_core_do_io_rw(&nvdev->core_device, false,
> +					     nvdev->resmem.bar_remap.ioaddr,
> +					     (char __user *)buf, pos, mem_count,
> +					     0, 0, true);
> +	}
> +
> +	return ret;
> +}
> +

<snip>

> +
> +static const struct pci_device_id nvgrace_gpu_vfio_pci_table[] = {
> +	/* GH200 120GB */
> +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA, 0x2342) },
> +	/* GH200 480GB */
> +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA, 0x2345) },
> +	{}
> +};
> +
> +MODULE_DEVICE_TABLE(pci, nvgrace_gpu_vfio_pci_table);
> +
> +static struct pci_driver nvgrace_gpu_vfio_pci_driver = {
> +	.name = KBUILD_MODNAME,
> +	.id_table = nvgrace_gpu_vfio_pci_table,
> +	.probe = nvgrace_gpu_vfio_pci_probe,
> +	.remove = nvgrace_gpu_vfio_pci_remove,
> +	.err_handler = &vfio_pci_core_err_handlers,
> +	.driver_managed_dma = true,
> +};
> +
> +module_pci_driver(nvgrace_gpu_vfio_pci_driver);
> +
> +MODULE_LICENSE("GPL v2");

Modern license annotation for GPLv2 in the kernel is just "GPL". "GPL
v2" is around for historical reasons from my understanding.

  https://docs.kernel.org/process/license-rules.html#id1

> +MODULE_AUTHOR("Ankit Agrawal <ankita@nvidia.com>");
> +MODULE_AUTHOR("Aniket Agashe <aniketa@nvidia.com>");
> +MODULE_DESCRIPTION("VFIO NVGRACE GPU PF - User Level driver for NVIDIA devices with CPU coherently accessible device memory");

--
Thanks,

Rahul Rameshbabu

