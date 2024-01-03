Return-Path: <kvm+bounces-5592-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A7A038235A5
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 20:34:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 007E5B243CE
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 19:34:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A98601CFA0;
	Wed,  3 Jan 2024 19:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FSMTKji8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2082.outbound.protection.outlook.com [40.107.223.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 353021CF82;
	Wed,  3 Jan 2024 19:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z1MxUCFplgwNLFLZLNv7czB3HY652Ft5P+zx29AiNG6YBtEDIFPFxXIHSDCCWHVfAxQ7wIiaAP0u8DMRbpfRxZWEXlMDSSnwpMs6RM+RoC6RUmnz8BKZjX1znjaCzWzcAyADtYhosVHf1YVUON+bWmLmheb6LFkYWX263+tx4chyIr3ggW6fheN6NdN/qtf4+bJ/Z9UBS6BlsJxrczyHEVWltsv2uj6hcg+59E9Eh9NZhJOtJbU/5Wcq6DzFUsYTSDKeXSlTaWr5xHa8mH080qmn8YZMqiDbzAoNpDiHAakEX1cJGllkMAujCACVF7ttcVroek9/9SGUxcUNSGY37A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rGK/mEF5QmhIZUnl5ZJYKyrORoqXOkFHkPN73lzdN3Y=;
 b=kvj8wTX1QN+dd97YxVjmBPTK4eiqDScgyvbnITSihab18GYa70Z6FV8UGFSvDacolemWXdHCSjmVNfRrF9WZvQb+HA56FW5Auu4oNwG8CaNpVKbyKv4idAJwHgItLDm8xkPpakbWFrvwAgcr8nRSXsYWx1VwiFbU/1nzcuP4Ix22bPDLaxmEfrn4eYGQHWgKgAfHJmJXTAGIUWj6UKfQrWYvpVTTtBLLt5aclwWw2ujEACm/1O9UzH6SIfXbn1bICuWWzjRz6ROj5H/Atxj6pLJ2nwqmC2wSMan2OaRuVXoBj46dvQADhGUhFMHAYdQa4fRzZn7jE7qUoNm20pDg6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rGK/mEF5QmhIZUnl5ZJYKyrORoqXOkFHkPN73lzdN3Y=;
 b=FSMTKji8MJHLBhVvB3DCau3yDvUwT1UfMg5wH24gQei9xQgJvzB3m2Y5maBDBIcle6Z243qbZdZcTqGMHNCEOws04r2bSwOpnye1Q+85SOpHeIHpRyZoMok7Xzmdec5GRY5iWtGrcq2k40s/eOqZNQX8wOGWJGj0+atPUFgYJFE7T+x2sPrehaXa/AiTt3qE6XncDd9KsKQ8845H1JkoAv3XLPyh+j3XAdIGP17dI+Y9Wy4lrIFyjFlDxruAr4L5zHaKJMp0J75djpRrWqiqJrmLCNQ0Ty0VWwAFvQ9xYp5TnGEFfq20VcpVnMl+hBGXiUKJ9QqkqqLV2VKMz2oGBA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB5925.namprd12.prod.outlook.com (2603:10b6:510:1d8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.25; Wed, 3 Jan
 2024 19:33:57 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7135.023; Wed, 3 Jan 2024
 19:33:57 +0000
Date: Wed, 3 Jan 2024 15:33:56 -0400
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
Message-ID: <20240103193356.GU50406@nvidia.com>
References: <20231217191031.19476-1-ankita@nvidia.com>
 <20231218151717.169f80aa.alex.williamson@redhat.com>
 <BY5PR12MB3763179CAC0406420AB0C9BAB095A@BY5PR12MB3763.namprd12.prod.outlook.com>
 <20240102091001.5fcc8736.alex.williamson@redhat.com>
 <20240103165727.GQ50406@nvidia.com>
 <20240103110016.5067b42e.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240103110016.5067b42e.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR12CA0011.namprd12.prod.outlook.com
 (2603:10b6:208:a8::24) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB5925:EE_
X-MS-Office365-Filtering-Correlation-Id: 249f5ead-432e-497e-16b8-08dc0c92edb9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	T1VaPPnKTrZRU9W9JaC1i7pL8+YbBbSRoeqbVaEdKJYQPsl9Lzq7e0qGkqM8rA1LtI0Bgmvs4AxZb1q/dVAtItO1wth/bSQI4rXD58RMATDBqyV15oF9qQs8LCgsNmVnzJ/FGPH0rTKItX/tPjBmyL4VfcG05DTwp6vDGfzpqBBJRrIr2rISBNivvFqHo11zV/3DnovWfHHrTtjHIQPCJB2EAyUzgY+iUBQ+VAhCsurX6nP2YOeyxlMz/isLlQqPcLyaplF1lUxdxvBEH+0IMBdEWc3fWVs+kwKgmYSDzvhzKFf1EiyzkZvCSbwngYDQ1J6WoeclIY+SVqtAXkw8VOTjKXQIl00TQ1XEnQ84ZCE2cX/kU5OD/JX6axYr4wRmEEJvJTORrMAwqDXU//kaMKs/AKY7FOqQ2sizHnrdYtquQJ80qRiQboOYNhCjI/QmAh/vCEisYLoCxXPD7yzknlXQrhwZA+PxQJB5IoYWhy1sRykWncvkYOWfcNBJKslWeyFODERkNCn2YnkcQNRVeNxaDRljndUBNOHct3PI0bGqSrK/xBwtTIt+BsZlv8EV
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(39860400002)(136003)(346002)(396003)(366004)(230922051799003)(64100799003)(186009)(1800799012)(451199024)(36756003)(66899024)(33656002)(66476007)(6512007)(6916009)(6506007)(66946007)(86362001)(66556008)(5660300002)(38100700002)(83380400001)(26005)(2616005)(6486002)(1076003)(4326008)(2906002)(478600001)(54906003)(8676002)(316002)(41300700001)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZS5ynI+2pQTjA4Kk7JMP+Jfc8bNw+/H0sewcAMLOdQIZ0K9axNDnaQHfaOuB?=
 =?us-ascii?Q?XKWGLXSIXNvOag0RWn2kr/dp0gAtxlBcmAP8vQ4ckvfxd61lTEkQ4bm0Ssni?=
 =?us-ascii?Q?m4vVvMoos3D7xRDiBkcfFAb0e3++FfHcvumLa8K0Uelo4w8AoPx36UIPY14x?=
 =?us-ascii?Q?B62ixZQd1NeexSrAJAp0F6pGuGJ9cJ06qWStcKb4Qshw2INbAgWVsOIZ0jbe?=
 =?us-ascii?Q?oo2FP/tyTovZExWzgUtnabIQelubuyOZptk54piys+fGggNEmUbnT1pLKJWL?=
 =?us-ascii?Q?kJYEjmQYRhly/uPkH8QalrmOmVoOz1m/JG36KxcHUWV92429KrPyb/gobBSN?=
 =?us-ascii?Q?KKKHivpd82tp49McCWX28K1YqmkMsIGClojaxH3G6iu6CiYYuBDJ7g1KgFCU?=
 =?us-ascii?Q?k/jKabnzbkG6B8LN9/X0EjY+G20xARJvA/egztssFS/DFV57CiAMYs6vVswv?=
 =?us-ascii?Q?5r+OHz8qq23+qNghWvJ0sH4EV5/GHPtslGYRU7QAtS+wmklA+ZBPbO4nPC4K?=
 =?us-ascii?Q?lfuTzbRBh/ElfQzKTq38CYayEyDJexDWZA/huXBupJ89stnZZVPbUbnct+Ev?=
 =?us-ascii?Q?m1pKJNWGF7fuKLVNWPYg4hnuZoye4G/phf61PYWSJh8se/fI7oyxKlEDdFCQ?=
 =?us-ascii?Q?kbkOJYi3oZfqKfB7e9/+pzKRKO7czqxCzwJonf2JEDjnzunzsEHtpWvmgPgG?=
 =?us-ascii?Q?cvN5ecFhJ/rj3oVqWG4bbLl+k0R8E+7HlBoejfrVwYKM8K5Tue0llyitDcI7?=
 =?us-ascii?Q?vGeroHuWi4IaXEKA51HVaI7BD7uXy/cjYofsGV2YnpMHJdtDg0m2fF54VEUq?=
 =?us-ascii?Q?cIFTlMruxF6Tzkn39ucBl9x7q1YsPinEDce9JOs7ParFIlv45I3OXauMOkLk?=
 =?us-ascii?Q?qAM47RdvBiW0e0LzYKQy+Nuh+zqMZQEeNnfWE9HVi6IBg19c8MEfre7VZXKT?=
 =?us-ascii?Q?5ATFncnFGhAZ45Tj4YfMjI2eeFWh0qfcUsqSzAAsTE2DPWI62QKBB6/g2w9D?=
 =?us-ascii?Q?IF4GAmLbR+DNvqiPJGqjirTjo7loMe15BiGtpzxfCcl/J9rZVn4SngM2LAqu?=
 =?us-ascii?Q?yDNJhNsMc5p/QYyETPMeH3/id4UPkqq1P6cD1W+EBhf5Gry/0767sQ6BHPN6?=
 =?us-ascii?Q?jsi9wmcF4e3RhdctDAUwO+5TPlzyy9NDysiIMjV0R3KLyNYJpDKPtCunU+8n?=
 =?us-ascii?Q?G+u6Cmyh4BWDLdpYaibRoOwefq4ComA7ybu5MUPvD6HU4vClOAion0a0o2oZ?=
 =?us-ascii?Q?Sw834Kw9KDhZaplH0FHREywOwuST3ifnQ59Crp48VUlDWbdl9KcN3xMj3yYh?=
 =?us-ascii?Q?yUhRPK+4KpE0qTnFGkz0jKw1eLz3VPi6c+rETCDJHSm9cseg3D2GMHOkh+he?=
 =?us-ascii?Q?lTZPum1OLqVV+jnq57LwZQIRxP5QlQNtAUixdujNYlAGEVIVFnOSHdprbR/+?=
 =?us-ascii?Q?biWLHpIG0tiwy0NajuO1D/KbnJFCdQXbV3w7m6K/sLI+YGCoaCdr4NitCnsY?=
 =?us-ascii?Q?IUPNa2ZteZfjzrBY+fXQvxKFLSkFrmybS4yQYVZc4qWyr6rBfKW8b4Vj8avb?=
 =?us-ascii?Q?LbugdQOYNprzfw3MzZrOAnPoQ/voPbhAXN7JE8Mf?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 249f5ead-432e-497e-16b8-08dc0c92edb9
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2024 19:33:57.4887
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CESyYUJ/P6pguHZhoC+MR61G/2rX6Zy39c3UYDWH8QV8APQjDEGGAwBwncp65Zua
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5925

On Wed, Jan 03, 2024 at 11:00:16AM -0700, Alex Williamson wrote:
> On Wed, 3 Jan 2024 12:57:27 -0400
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Tue, Jan 02, 2024 at 09:10:01AM -0700, Alex Williamson wrote:
> > 
> > > Yes, it's possible to add support that these ranges honor the memory
> > > enable bit, but it's not trivial and unfortunately even vfio-pci isn't
> > > a great example of this.  
> > 
> > We talked about this already, the HW architects here confirm there is
> > no issue with reset and memory enable. You will get all 1's on read
> > and NOP on write. It doesn't need to implement VMA zap.
> 
> We talked about reset, I don't recall that we discussed that coherent
> and uncached memory ranges masquerading as PCI BARs here honor the
> memory enable bit in the command register.

Why do it need to do anything special? If the VM read/writes from
memory that the master bit is disabled on it gets undefined
behavior. The system doesn't crash and it does something reasonable.

> > > around device reset or relative to the PCI command register.  The
> > > variant driver becomes a trivial implementation that masks BARs 2 & 4
> > > and exposes the ACPI range as a device specific region with only mmap
> > > support.  QEMU can then map the device specific region into VM memory
> > > and create an equivalent ACPI table for the guest.  
> > 
> > Well, no, probably not. There is an NVIDIA specification for how the
> > vPCI function should be setup within the VM and it uses the BAR
> > method, not the ACPI.
> 
> Is this specification available?  It's a shame we've gotten this far
> without a reference to it.

No, at this point it is internal short form only.

> > There are a lot of VMMs and OSs this needs to support so it must all
> > be consistent. For better or worse the decision was taken for the vPCI
> > spec to use BAR not ACPI, in part due to feedback from the broader VMM
> > ecosystem, and informed by future product plans.
> > 
> > So, if vfio does special regions then qemu and everyone else has to
> > fix it to meet the spec.
> 
> Great, this is the sort of justification and transparency that had not
> been previously provided.  It is curious that only within the past
> couple months the device ABI changed by adding the uncached BAR, so
> this hasn't felt like a firm design.

That is to work around some unfortunate HW defect, and is connected to
another complex discussion about how ARM memory types need to
work. Originally people hoped this could simply work transparently but
it eventually became clear it was not possible for the VM to degrade
from cachable without VMM help. Thus a mess was born..

> Also I believe it's been stated that the driver supports both the
> bare metal representation of the device and this model where the
> coherent memory is mapped as a BAR, so I'm not sure what obstacles
> remain or how we're positioned for future products if take the bare
> metal approach.

It could work, but it is not really the direction that was decided on
for the vPCI functions.

> > I thought all the meaningful differences are fixed now?
> > 
> > The main remaining issue seems to be around the config space
> > emulation?
> 
> In the development of the virtio-vfio-pci variant driver we noted that
> r/w access to the IO BAR didn't honor the IO bit in the command
> register, which was quickly remedied and now returns -EIO if accessed
> while disabled.  We were already adding r/w support to the coherent BAR
> at the time as vfio doesn't have a means to express a region as only
> having mmap support and precedent exists that BAR regions must support
> these accesses.  So it was suggested that r/w accesses should also
> honor the command register memory enable bit, but of course memory BARs
> also support mmap, which snowballs into a much more complicated problem
> than we have in the case of the virtio IO BAR.

I think that has just become too pedantic, accessing the regions with
the enable bits turned off is broadly undefined behavior. So long as
the platform doesn't crash, I think it is fine to behave in a simple
way.

There is no use case for providing stronger emulation of this.

> So where do we go?  Do we continue down the path of emulating full PCI
> semantics relative to these emulated BARs?  Does hardware take into
> account the memory enable bit of the command register?  Do we
> re-evaluate the BAR model for a device specific region?

It has to come out as a BAR in the VM side so all of this can't be
avoided. The simple answer is we don't need to care about enables
because there is no reason to care. VMs don't write to memory with the
enable turned off because on some platforms you will crash the system
if you do that.

> I'd suggest we take a look at whether we need to continue to pursue
> honoring the memory enable bit for these BARs and make a conscious and
> documented decision if we choose to ignore it.

Let's document it.

> Ideally we could also make this shared spec that we're implementing
> to available to the community to justify the design decisions here.
> In the case of GPUDirect Cliques we had permission to post the spec
> to the list so it could be archived to provide a stable link for
> future reference.  Thanks,

Ideally. I'll see that people consider it at least.

Jason

