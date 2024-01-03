Return-Path: <kvm+bounces-5535-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 73DBB8231B6
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 17:58:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0CC0C2887E3
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 16:58:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86E541C2AB;
	Wed,  3 Jan 2024 16:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KTB6Rayv"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2088.outbound.protection.outlook.com [40.107.96.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 380051C281;
	Wed,  3 Jan 2024 16:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A6q/CpLXaJ8ikbuxT336fjJqhliOtsGjeNhUOdPMWnC63AbH3Bfc8lfSgY0+EdMZkmYm5Wl/6hZAcl2vuJqkXMauhD4n3OO66TYa15EpYeL0t0qYv1onWobIjX01Styi3u4s1rILEAfbi1WLQCCHU/vq/3ggKDcjQw25zWWkQMzRw4gDSrKtarJu7+1HWOMtZlsVK2T67Cx3MTMwoWaIAi9IrrWQioPM9moLrSdVh3Yu+Gmx46W7aQBJg6tYjmjkh2otJ5KCDT2Kvpag0/XIeQtlQSvK/ESC3CSYeHrIDAcMfm+PQjriRU3dWQkEhda2v9RcjMnt2F0prz0Njwn9NQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5zWh7XXcVtHaS5YxRDKPuR+TLC/njWTKk4FtDlGOwEA=;
 b=XNNuL+T9GyzzX7IRe+JaCYWN1Z+whA2Q1GM8sGGrRP98QJTj8DMv9iGJlsUBB5dMGhyMGidD6tZ6K6sHZoP59WZ7UBoTQlyCwC7p3ARFS6wYoBeEOOU79NAzmKDrgskaDbCoggPXE4we02UdHc8cz7UJK8t2CD7XqMEIDbiEJWXxYKgsCSulBoFXi+G6Oi6bLgijnTdDVmkpvqhWsGx0fFMrkDoKYjFsgZ6OvcsKDJQjsSbS+7NYt2a+tixSFky31wB9WPIfWJzIyaxCO/ZxjuDm5cnFMHHLP1QxEwOMZKDYsb5cCbAMX6uVWJvAIOCkGkLZ8bdhFnxmpCDeMGyW7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5zWh7XXcVtHaS5YxRDKPuR+TLC/njWTKk4FtDlGOwEA=;
 b=KTB6RayvOy0eZHEF3uK1sySayF6w6TDuks/B7NJ+CJDcZNErII8V5KBEgVydoHYAr6dcgWQJAk81qTwT5Lr+4zigjPrGtp1plf8q5SvkCK0k8yTb7nNwjqkhlhVGLlLykNB7H0sCan5msf4xkiMdRikyzHpVnyZArFooXAeuvQD1NyE80nqonOavdxEiA5DghhMdd9nzdgmwwzCkvpj0BLZmV4AcAQq3yLkYJxrwVELuu6NfLV9mksK5n6tvq8X//JxTPHYBnDPwzp7J8Y0UNeafTlzOYmWNTOojfMDOQryi7arrvgbEUXz1MKsBp6vCejNWcSZjfXnbWdPmChUMEg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH0PR12MB5449.namprd12.prod.outlook.com (2603:10b6:510:e7::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.13; Wed, 3 Jan
 2024 16:57:29 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7135.023; Wed, 3 Jan 2024
 16:57:28 +0000
Date: Wed, 3 Jan 2024 12:57:27 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Ankit Agrawal <ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com" <shameerali.kolothum.thodi@huawei.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>,
	"brett.creeley@amd.com" <brett.creeley@amd.com>,
	"horms@kernel.org" <horms@kernel.org>,
	Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>,
	Kirti Wankhede <kwankhede@nvidia.com>,
	"Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
	Vikram Sethi <vsethi@nvidia.com>, Andy Currid <acurrid@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>,
	"Anuj Aggarwal (SW-GPU)" <anuaggarwal@nvidia.com>,
	Matt Ochs <mochs@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v15 1/1] vfio/nvgrace-gpu: Add vfio pci variant module
 for grace hopper
Message-ID: <20240103165727.GQ50406@nvidia.com>
References: <20231217191031.19476-1-ankita@nvidia.com>
 <20231218151717.169f80aa.alex.williamson@redhat.com>
 <BY5PR12MB3763179CAC0406420AB0C9BAB095A@BY5PR12MB3763.namprd12.prod.outlook.com>
 <20240102091001.5fcc8736.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240102091001.5fcc8736.alex.williamson@redhat.com>
X-ClientProxiedBy: BL0PR0102CA0031.prod.exchangelabs.com
 (2603:10b6:207:18::44) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH0PR12MB5449:EE_
X-MS-Office365-Filtering-Correlation-Id: 2aa2d197-c267-4990-1d38-08dc0c7d1188
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ZXBev8oGZ6gDLfzrUv7nVQWScYkD6otdz+hsNKKOgXP4LGrdsHYZnwIq+Anng0quu/5ncD/RNjcMPVIN2v3BJFLHP7jtb+0yonrLsPmX/TgmRQvC55o6pj3+lf3knEGWv9QeWxEZkENhMwuodobUH3qzfmTtD2tc6xq9s4lFETW0xLDYWVeHrb3gsY/Oi69uD+d5M5TMmBmyJlSxFp6EoN8XR0ltojQJpTbpc7zH84tWGJB3gZSP0ZB0BoD+aLliWM6dstgnveZq8/KHAM7S/1cqO62oqRDqu9Wk1m5cS189pby3vwLMS7oAy8gMOtvEk/KHsN92SgUz/hAQgI6CnmZ9Cx9awhFyWnp+AXu7pkdz9JR6IkpxnJSv22U4ILKy2qlqAGdNMa0aQGhkq9DViFNMhrS/ZtsvKibf74ORLVf8YPR1Z2O05KIziG4IWAqE0StHAeXAlkP6sgJ1j1wXl/sZGofNbHg9QC+dbBD0k9Ndq6EKEAWd3nzYphYy48JeE8k3QbFLVEzftIHFU/r0OFt3dWPMxoCEvoFxVf8lvGihLvgtqT688+WxIblDgHLI
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(396003)(136003)(366004)(39860400002)(230922051799003)(64100799003)(1800799012)(186009)(451199024)(36756003)(6916009)(6512007)(66476007)(6506007)(66556008)(66946007)(6486002)(86362001)(33656002)(38100700002)(2616005)(83380400001)(1076003)(26005)(41300700001)(2906002)(5660300002)(478600001)(4326008)(54906003)(8676002)(316002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?063HchGtR/wnIf5PV0yDiospH06j7iWCA0xRLG1PYDeRo0DgSsH9W2uTfRq1?=
 =?us-ascii?Q?63HDcdnOFJHuCN9IhmZbAA9jIh52pFTuqWHIWbxzAls2yRFnpWGR0aAtGNbC?=
 =?us-ascii?Q?cPQrbJkoO1lvEtzOXrHoA9DajM8zxpaQEtam7ttJ6X6hbrLEY/pAFYubFCdS?=
 =?us-ascii?Q?RqXB1ViHsBn3ixkH/tkwlGU1u0xe//zzxdyU9AJc3GIxKwQZaq9pXYVqImRI?=
 =?us-ascii?Q?2s5+TgX6kyN11MvALmJVVSDu0qIZzh854/EI/hbNZS/v/5sZ7h4Rht6M7WZZ?=
 =?us-ascii?Q?dz8RKCqtpMzSQKNsF6KW5NvYIw9n6TnpC5kh95iDJ6TZX2P2UZcwPF9zIr+4?=
 =?us-ascii?Q?EdPPdMsm8OoRGHMNKJ0qc/fcO6tlCQgWfhb0yt59Piv4oceX1MYlQjPUohvW?=
 =?us-ascii?Q?gjp6jsrhXhUpb6LBR9op71/A1KLYVqnr9hDlzNpMk4VhLcRXtHT2f9X5dNuG?=
 =?us-ascii?Q?1ecVjWaOK3T9LfKnctOV3oYGKEyW0zaqC+eYqkKiQDvgj3+oxbGIS8AYNnVz?=
 =?us-ascii?Q?GZqAcUV2sKvXGoZIw4U/l6bUoYKuoqDwby+s6gBKZqaYvARmMQ6XEY8bl+nw?=
 =?us-ascii?Q?kofP4/5avHNFiDw5zuZ2Y+J1FVSptHAh1aJQ70pgREPiZGPkgdXnLByDnedT?=
 =?us-ascii?Q?OVL+XonASqsHc0Hxe+R3jq0S4SlKhkuSZr3fHxgtw0LZDjwEklE1v30Y6aMT?=
 =?us-ascii?Q?D63ifgIt6rlh7WELZlHAcqQHs4/f+jZtpc0yv1My+O3tCEdYenduQo8I5hr3?=
 =?us-ascii?Q?m/x//lXZ/wGjHDr+PaUQ4YRbFse0m5cOD8oYiYfToXrG0wTTHjLlsMrtJcRF?=
 =?us-ascii?Q?GJlYwkXCbi4zBL+D7b8KzQK0ddrMqf+9C+OdiBOWYu+xod05SwDu9jhooQzU?=
 =?us-ascii?Q?sa4KqmbroY7BxsTmrKb9FmTM9QfmbXCm1pr6yZwv61OcqglATayd7EucLj+b?=
 =?us-ascii?Q?FMOYBxNhFG8TyfBeTe5Y83VVjMVDVPL+d21rulV71CWp7vWL2WjJCwETcVbC?=
 =?us-ascii?Q?iAu+b9Dcz4ajhDFpn/FrkAU5Rveu/yJnsxC0r3nDZC1cd3HcsTOG780nQ6/L?=
 =?us-ascii?Q?OOx6cOqgdFKiF5odXA8+3rc/bKWvcCYETNW3GKyxUdsrcExh/SKyV01OJaYM?=
 =?us-ascii?Q?EgLJ0UNSS+h4vr3JzwJq2IFw/ALBBf5QTVPWZiFQd41g2AaACbkltViRav/A?=
 =?us-ascii?Q?OdicXlwaNEzgmtv1DqHtZzgNCtHnCO0Cy90Ap2/rbqRdB4yAjV56PktvgZ47?=
 =?us-ascii?Q?NGC/gCsjQvb9tQxaSJ7DJpg8xSRyq+4f/3/rOTfEFrTQrSC6W3CE5cfuHxvv?=
 =?us-ascii?Q?z0ekxRpo4++gkt4Wrd4I2zW0WtZfphkEeNok/LmYUg7xPtILKfArpXtaqIHx?=
 =?us-ascii?Q?zeqIopqsyBwLnw/Nnoh8j245y5kpmIW1xG8erMUDdwur3w7gy2xLCUmJGUO3?=
 =?us-ascii?Q?hRIyKfWQ01j67RaNAtE3nlq4kj9G8Nb6k+E2RFAUKhiedd7u7lhSAugINIIs?=
 =?us-ascii?Q?onzUz/YfZibIpADB58daDynJsszrm6ipQ1NnWZKS6WMVFnBt4qcaq/6BrA1Z?=
 =?us-ascii?Q?402gESdhxcIoKQ0wAqacMgoEpxQk3b1aTR1G0Oh0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2aa2d197-c267-4990-1d38-08dc0c7d1188
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2024 16:57:28.6461
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iHuX0ybvdn4Roq5ErHFUFXh79DDkkzLT9ibL+PLyOXYNxEV6OsWV/3aAm6v9m+oS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5449

On Tue, Jan 02, 2024 at 09:10:01AM -0700, Alex Williamson wrote:

> Yes, it's possible to add support that these ranges honor the memory
> enable bit, but it's not trivial and unfortunately even vfio-pci isn't
> a great example of this.

We talked about this already, the HW architects here confirm there is
no issue with reset and memory enable. You will get all 1's on read
and NOP on write. It doesn't need to implement VMA zap.

> around device reset or relative to the PCI command register.  The
> variant driver becomes a trivial implementation that masks BARs 2 & 4
> and exposes the ACPI range as a device specific region with only mmap
> support.  QEMU can then map the device specific region into VM memory
> and create an equivalent ACPI table for the guest.

Well, no, probably not. There is an NVIDIA specification for how the
vPCI function should be setup within the VM and it uses the BAR
method, not the ACPI.

There are a lot of VMMs and OSs this needs to support so it must all
be consistent. For better or worse the decision was taken for the vPCI
spec to use BAR not ACPI, in part due to feedback from the broader VMM
ecosystem, and informed by future product plans.

So, if vfio does special regions then qemu and everyone else has to
fix it to meet the spec.

> I know Jason had described this device as effectively pre-CXL to
> justify the coherent memory mapping, but it seems like there's still a
> gap here that we can't simply hand wave that this PCI BAR follows a
> different set of semantics.  

I thought all the meaningful differences are fixed now?

The main remaining issue seems to be around the config space
emulation?

> We don't typically endorse complexity in the kernel only for the
> purpose of avoiding work in userspace.  The absolute minimum should
> be some justification of the design decision and analysis relative
> to standard PCI behavior.  Thanks,

If we strictly took that view in VFIO a lot of stuff wouldn't be here
:)

I've made this argument before and gave up - the ecosystem wants to
support multiple VMMs and the sanest path to do that is via VFIO
kernel drivers that plug into existing vfio-pci support in the VMM
ecosystem.

From a HW supplier perspective it is quite vexing to have to support
all these different (and often proprietary!) VMM implementations. It
is not just top of tree qemu.

If we instead did complex userspace drivers and userspace emulation of
config space and so on then things like the IDXD SIOV support would
look *very* different and not use VFIO at all. That would probably be
somewhat better for security, but I was convinced it is a long and
technically complex road.

At least with this approach the only VMM issue is the NUMA nodes, and
as we have discussed that hackery is to make up for current Linux
kernel SW limitations, not actually reflecting anything about the
HW. If some other OS or future Linux doesn't require the ACPI NUMA
nodes to create an OS visible NUMA object then the VMM will not
require any changes.

Jason

