Return-Path: <kvm+bounces-5448-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3067A822062
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 18:26:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B5D3D283EE9
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 17:26:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0B98156D1;
	Tue,  2 Jan 2024 17:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XnIN+mHJ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D3E21549A;
	Tue,  2 Jan 2024 17:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jmM7V/GxrPfddKbHme1NHRjRwHCMHOlmnr8zriuRlBoSe4uLN1p0ko3XtKO10aIThX0U7enhSoDZZDLZ7riS0uuxB3Pf0OyzdyawktM4wtjTkELS9PzAoGHyenHJGjMxbjlNFahcPzfc7uYG4v7/1BLGup3534wd2KV7O5Z0A5d8FnLjfN+bonGolM7anVb7yVpIFkruTr9CB5d7POn6Z2xBeLskMfgeNhjPLcTBXpOXeHVmidlWN4jn/8M3LbxfcTtl/3B9Nknw+e6PdkaW8AigqlFZmQC87tC2w7KuBQP1of2u8DQOytBjNOPmzPwcxUDzJ4H6VAryHl1FnONkaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=itx4w3+s+gxpzi9tWG6Yft2RN6S+69GT1GDl+UnqtGo=;
 b=a/kLiPUJxhTi10tCdgGdJZcT6CyTzcRe0F/nTpUbN2LIreB+eBT43xULeeOpF1Dz1kuR7P2sMnfopmfHgtC0L2mr2IopIXkQ3oFeEg5lhPFysSJoRAXGrhdCY8G+cPgBt333Hs5B7vePMGybnSRwTNUWm2PGNedgdwPfvQs7bYtHFV1fAsKdzpQoQcxFK+/ASOjWgZXMlRIZR09KrQeKsHQwsBRlmOkHRca6MdzTF7ukh592p4TDPad60xIECpxSXMVv7IZUSWV1SV7Z4a9F4Xp/CTAFjW5agYP+aqmHstzBplo9AgcrfbWdvWe8P9wJ/lWfa3JEtehQ4ql/NlXrig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=itx4w3+s+gxpzi9tWG6Yft2RN6S+69GT1GDl+UnqtGo=;
 b=XnIN+mHJd3f7x4fWkgie6D4R+974/67OBf12ZCRt7MQPDRlXS4M7sQsuyZQzXBM+X2U4+Wvszwf5aVRyxG6BWll+tQiWzDmvMMG4LolTUX8aUF0VJZjeT2HVEn+QUNwCpMVV6nPCXy/b4Vd3qTkXHKSx+Vt3e+ZLYzEm2xasFQhaKuWdTRvXd/7g2B+W8n9hnqUW8PV55mCrpycwjAWF8v6yvzkMWJy9JYZn5tmZuTxVjhCdjISMVDux8nRz32dQYruThLbYqveYe+32J+h+qwU8xg8KMQq58eoQXBgY1LcCLlVKImHe6NZnpsPlnS7MxIy7eVxShOIKGiCc5k9tbA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH3PR12MB7641.namprd12.prod.outlook.com (2603:10b6:610:150::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.13; Tue, 2 Jan
 2024 17:26:22 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7135.023; Tue, 2 Jan 2024
 17:26:22 +0000
Date: Tue, 2 Jan 2024 13:26:21 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Catalin Marinas <catalin.marinas@arm.com>, ankita@nvidia.com,
	maz@kernel.org, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	will@kernel.org, alex.williamson@redhat.com, kevin.tian@intel.com,
	yi.l.liu@intel.com, ardb@kernel.org, akpm@linux-foundation.org,
	gshan@redhat.com, linux-mm@kvack.org, lpieralisi@kernel.org,
	aniketa@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com,
	targupta@nvidia.com, vsethi@nvidia.com, acurrid@nvidia.com,
	apopple@nvidia.com, jhubbard@nvidia.com, danw@nvidia.com,
	mochs@nvidia.com, kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 2/2] kvm: arm64: set io memory s2 pte as normalnc for
 vfio pci devices
Message-ID: <20240102172621.GH50406@nvidia.com>
References: <20231208164709.23101-1-ankita@nvidia.com>
 <20231208164709.23101-3-ankita@nvidia.com>
 <ZXicemDzXm8NShs1@arm.com>
 <20231212181156.GO3014157@nvidia.com>
 <ZXoOieQN7rBiLL4A@linux.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZXoOieQN7rBiLL4A@linux.dev>
X-ClientProxiedBy: MN2PR20CA0046.namprd20.prod.outlook.com
 (2603:10b6:208:235::15) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH3PR12MB7641:EE_
X-MS-Office365-Filtering-Correlation-Id: 5de10323-dadf-44f3-753f-08dc0bb7f082
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	xT8/3tFhh2UWmfRfenpezBYHlZW2sjISj59A53LBeEQUeL+9+HDGhHsVl3cZUvw3R9Gh6b1ZlHry7djRQneVHP96dORr7b926xmQMkyYGGUFYbc+ulUxsgsSHBpEMPd4olycG5yL2zF8ZCUfFMism1Ip/qL6SmED52zm/Zi1mq23K1WjceHI2KRmHrLcFXRNMsETCOdcLAyI25FDl0DLUiUPlhZj7KT8zSOaHwvd1nybkCUrsDOPmJ5ab5C6/Z8R1E2++2mcjwTUHJKUxz2BJWJGv8TPuWh9kZJsTfZvzY1tOt+ABg2fr5cmXWQdViXFtp1V5/PnppvQhhMO6599UvBq091w/S3GDxcvyGozQtwdRIY3NkWRbKaNNDSjCtT7MkP+M7wDqbAJg8Dmvt2Tx9+kT1BgHZOJPw955ByizdJCNr3jSVVrTsvTkeKg+LhO0RXjOJwC/ZWGBA1GhoGlvQdqcgNR9Ds5/WOgwf5C76b2E1nbRjUuFtSVU4vseQjkd1zdFcb767Xt5LjgqWx5slxKhYHkifxFXLvhDDE7XwxN6BaQyFoyqQo8KIBfST2Z
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(396003)(39860400002)(376002)(366004)(346002)(230922051799003)(1800799012)(451199024)(186009)(64100799003)(38100700002)(36756003)(86362001)(6506007)(6512007)(478600001)(83380400001)(4326008)(66556008)(66946007)(66476007)(6486002)(1076003)(26005)(6916009)(316002)(2616005)(8676002)(8936002)(33656002)(41300700001)(7416002)(5660300002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BCiUz9J9/pDYZCzpto5Mg5kpJ5VSIPG/FP8XL2i2BbDTmkhdzU3MFMRY72na?=
 =?us-ascii?Q?/1PaOsWZlOktmM657nPA6vfiBv9t1WCuPl+HKIU8f6PQUf0srompd1hTGU4V?=
 =?us-ascii?Q?94R/vz7muiGJ94n6H1UTWih64IGHuKkmUSB5HcXaDyNUKu8pO0RYSOnj0ShA?=
 =?us-ascii?Q?DxMtHH1eJv96/REGnAPC20a7R5L0liDQ6OBwOque9SqjuExlF7kddzBZvAwy?=
 =?us-ascii?Q?AlGzqhj3Enan4cjAUDsH446AYMHn4q72hX+LTPTToKLS6yjBJBmPvdou+QdA?=
 =?us-ascii?Q?a8MvMxeV4QRzYdkCOLtIago8DtxK5E+Z+cKyEYr4dlET5M4vdMZ181sTo+NR?=
 =?us-ascii?Q?hurmKVKSj0d8qvFe4DG6CQ6fwAH9HgMCdj9R1B7YCrqSy0uFqOfuvvJ60NYl?=
 =?us-ascii?Q?/ky5X/eaaz7ro8K71Bowmu2zeXvnopVLnAO1LCYoaUUa8+hIDHGKnaWrcIVQ?=
 =?us-ascii?Q?7X4v6mo4IcG/Gz9PbbOsY/sSHkg7briTGBo55f4DSCvekcria6Un0t/qzovz?=
 =?us-ascii?Q?+3zy+3AW1MAYZDCmn5xXOYvh2sCTabveP4BSThNBt2ITAswxkd0VOoQwL+uV?=
 =?us-ascii?Q?nXRYeCXgYZ3s/WbEfnoEelf0ug5Tqx/NwAwLASKik8/8OhiKwHDVAyVRGQVA?=
 =?us-ascii?Q?+FkrNpWjZMmRS3kP+3k+uHCxnLkamejO2mWJLByyULQz3BUKqMoYRwMdwCQx?=
 =?us-ascii?Q?qWCUi0kJuEC/fDYy9nlMICOl4SjnY25oTerB4j23hU1NJWrvBMPPNty6tXMN?=
 =?us-ascii?Q?FzbKvnBf2qLgWnb0XqAP/VeVmZxbU63HH7TYgUuQeAdIj+EI58+G9+HJ7lVN?=
 =?us-ascii?Q?BjJ/DF19ArHifjvN6IsiaKFeblVQXD0zeT4tmShRsCsaDmFxHlnFVxNWfb08?=
 =?us-ascii?Q?LsmEKO0NcJ2zhXlzheO2KDLBpl55JjYifoPBMMEplyFXE+IKUQ2R/8UHafoG?=
 =?us-ascii?Q?5cQsNR8Wsu7ZUAdkkUPuQr1lJpvup4KwyhLURafgdeyJ/Wfml68/Fy7JtNsK?=
 =?us-ascii?Q?+XuOavsTUZH/NsiZsR7YYbKN9JXusUpR1E+B0imJcMJtU5Myd/SPcX7LYBaL?=
 =?us-ascii?Q?RpjivtayZzOg5lusncC0/4xr0tVZg8CdOoHtWHxhGcFtzBo766riGqiVHFm7?=
 =?us-ascii?Q?sFBONv3DrObdLdU6HAgpJq+Q+YzEL70I2OVj5P+kncUTAUqJNVc+ciIj8FFC?=
 =?us-ascii?Q?By+/Fv43q2f+qjSxXjPlynnByP/93dz6o2gC79o14SNtFSgXjlkNWQkrc+ld?=
 =?us-ascii?Q?GcvYh4OlfYXBWCE0b1r+D4zSYyEFHyKzVd5w58fQGJCI0BRc2eV57AhaYYxa?=
 =?us-ascii?Q?Q5zpyxWHgDgdsG1WIi74SthyEPFh4aKPTOS9FmtVeQ9K/za32R9ZtutS58s0?=
 =?us-ascii?Q?uPBlUaELjGETjSveNdHKziWDtH3DRNkMYAoEgEA2w8yQNOvjOfbX6ieJAFro?=
 =?us-ascii?Q?nYn83aGj8C3x8dSm/XoB0NoXwgX0j95y7dHBLcUduciAY8COL1KaCDqKUFjN?=
 =?us-ascii?Q?tNSlu6+5iTkwAKbEzPLWRQPDIJtKD/2DVe1463Jkt4Pia8vpYQju5ITPbb4F?=
 =?us-ascii?Q?JG3ByYkf8DEErERNGZU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5de10323-dadf-44f3-753f-08dc0bb7f082
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2024 17:26:22.3695
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MAsGVTdQ9C6AFQZMyu5YaVdVHoa+5PGuF4x4N6Ls4kkDycpS+mYidBn1Oqcg24Lg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7641

On Wed, Dec 13, 2023 at 08:05:29PM +0000, Oliver Upton wrote:
> Hi,
> 
> Sorry, a bit late to the discussion :)
> 
> On Tue, Dec 12, 2023 at 02:11:56PM -0400, Jason Gunthorpe wrote:
> > On Tue, Dec 12, 2023 at 05:46:34PM +0000, Catalin Marinas wrote:
> > > should know the implications. There's also an expectation that the
> > > actual driver (KVM guests) or maybe later DPDK can choose the safe
> > > non-cacheable or write-combine (Linux terminology) attributes for the
> > > BAR.
> > 
> > DPDK won't rely on this interface
> 
> Wait, so what's the expected interface for determining the memory
> attributes at stage-1? I'm somewhat concerned that we're conflating two
> things here:

Someday we will have a VFIO ioctl interface to request individual
pages within a BAR be mmap'd with pgprot_writecombine(). Only
something like DPDK would call this ioctl, it would not be used by a
VMM.

>  1) KVM needs to know the memory attributes to use at stage-2, which
>     isn't fundamentally different from what's needed for userspace
>     stage-1 mappings.
> 
>  2) KVM additionally needs a hint that the device / VFIO can handle
>     mismatched aliases w/o the machine exploding. This goes beyond
>     supporting Normal-NC mappings at stage-2 and is really a bug
>     with our current scheme (nGnRnE at stage-1, nGnRE at stage-2).

Not at all.

This whole issue comes from a fear that some HW will experience an
uncontained failure if NORMAL_NC is used for access to MMIO memory.
Marc pointed at some of the GIC registers as a possible concrete
example of this (though nobody has come with a concrete example in the
VFIO space).

When KVM sets the S2 memory types it is primarily making a decision
what memory types the VM is *NOT* permitted to use, which is
fundamentally based on what kind of physical device is behind that
memory and if the VMM is able to manage the cache.

Ie the purpose of the S2 memory types is to restrict allowed VM memory
types to protect the integrity of the machine and hypervisor from the
VM.

Thus we have what this series does. In most cases KVM will continue to
do as it does today and restrict MMIO memory to Device_XX. We have a
new kind of VMA flag that says this physical memory can be safe with
Device_* and Normal_NC, which causes KVM to stop blocking VM use of
those memory types.

> I was hoping that (1) could be some 'common' plumbing for both userspace
> and KVM mappings. And for (2), any case where a device is intolerant of
> mismatches && KVM cannot force the memory attributes should be rejected.

It has nothing to do with mismatches. Catalin explained this in his
other email.

> AFAICT, the only reason PCI devices can get the blanket treatment of
> Normal-NC at stage-2 is because userspace has a Device-* mapping and can't
> speculatively load from the alias. This feels a bit hacky, and maybe we
> should prioritize an interface for mapping a device into a VM w/o a
> valid userspace mapping.

Userspace has a device-* mapping, yes, that is because userspace can't
know anything better.

> I very much understand that this has been going on for a while, and we
> need to do *something* to get passthrough working well for devices that
> like 'WC'. I just want to make sure we don't paint ourselves into a corner
> that's hard to get out of in the future.

Fundamentally KVM needs to understand the restrictions of the
underlying physical MMIO, and this has to be a secure indication from
the kernel component supplying the memory to KVM consuming it. Here we
are using a VMA flag, but any other behind-the-scenes scheme would
work in the future.

Jason

