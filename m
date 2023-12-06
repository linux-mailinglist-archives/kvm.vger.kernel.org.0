Return-Path: <kvm+bounces-3722-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 47DBE8075A3
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 17:48:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6949F1C20EA0
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 16:48:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 824F2487BB;
	Wed,  6 Dec 2023 16:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="GpTJ9gaB"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2079.outbound.protection.outlook.com [40.107.212.79])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82072D3;
	Wed,  6 Dec 2023 08:48:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QWfoXd5+TAIII3Lz8U2uyDbCohWMjh0TLLWSCrv2YSkjDqIQPoDaLwDTnYlk+dsZ0icDho7zcuUehxmXOA8YHVxneR3v0i9exv40iiHWGGRnlHSYts061GqKSFJ01GXJ+WT48GdyqEmDMVzT41LjlGDsHCmbd0PoqbBrdVJ55+FWctYq1QfP9k/GGGe17HZFnlmEGhIGnrndomUoNhjft5Q5l1xKHA4k6KEC8o/BJAEJzgueGqmCMv45IaNDfkba6dCSWECfKVxaPoW9QywpHGVfsxYAUKohgFx6erNB0cJkd0vmTcZgOa8OyF//JEEEg0bdcqF1FjR7HCXGOmYInQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cPXFmOM2k3qyPi62hYgnnEkkF8MPM3VteBX9M4Q4HIg=;
 b=NQzORgGEqFYxfe0hHA3rtS8OEcS8aa8MyhoUhKb3EJT9YF+EymmuUJfqW0CBAle4S7Ah6sntpQlS7QGcNQZRGATOS4wzyZ+GQ0V+FdY9Z7SDnGnTusLy+wyruf9n6Q0+Oea5A8Jhsw79KQ8tKJT244K0PlzCKiAJAKCdQLE89bexUSYWJ2kBK3xp/JgW05HnKUuqEjJyHIVI1JBs6RReV4HwMf5jcXspqafvKkKEfkHNxdtIEGaMkd/Ms/nB0HxG4C3DEqbBIQe7Zki7HaU1P1pxntr3kgMqi2xyixIWFtLgAA5c5UKxKIkYzhCYll5dGMjmvhPP6NKRQwT6z6yC+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cPXFmOM2k3qyPi62hYgnnEkkF8MPM3VteBX9M4Q4HIg=;
 b=GpTJ9gaBZfwQNlpAYwlX4p+zuyaBkWYgHZsBMCtMwkhpsjRA6SGZZGswKKMR6MxkipqMlQZFmRug6/lWhlZClXkt5b9jdt0PSMF7NwkE9sOJtbXge59mAifo+v616oIaHenbkK+QRWqTGOT7AkeTWObXOyVrsilkCRf0ggjgJrLC3gSD4axKv4aXi/cWzytefBRQf1YiC2oWghIVOw5LqrV9suSgYnwyv2iysdElzn9qWfxnPWvyvIDKiIk5AbOsdF3sdJmnRkTGbfGhg+ca1wzlHZYaYk3Cf/8gj9c4nNjhX1rUhBHE6ZCifnl456TRSHnTt9gTXf//2Va1UYPQVw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ1PR12MB6171.namprd12.prod.outlook.com (2603:10b6:a03:45a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.27; Wed, 6 Dec
 2023 16:48:03 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Wed, 6 Dec 2023
 16:48:03 +0000
Date: Wed, 6 Dec 2023 12:48:02 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Marc Zyngier <maz@kernel.org>, ankita@nvidia.com,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	oliver.upton@linux.dev, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, will@kernel.org, ardb@kernel.org,
	akpm@linux-foundation.org, gshan@redhat.com, aniketa@nvidia.com,
	cjia@nvidia.com, kwankhede@nvidia.com, targupta@nvidia.com,
	vsethi@nvidia.com, acurrid@nvidia.com, apopple@nvidia.com,
	jhubbard@nvidia.com, danw@nvidia.com, mochs@nvidia.com,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/1] KVM: arm64: allow the VM to select DEVICE_* and
 NORMAL_NC for IO memory
Message-ID: <20231206164802.GT2692119@nvidia.com>
References: <20231205130517.GD2692119@nvidia.com>
 <ZW9OSe8Z9gAmM7My@arm.com>
 <20231205164318.GG2692119@nvidia.com>
 <ZW949Tl3VmQfPk0L@arm.com>
 <20231205194822.GL2692119@nvidia.com>
 <ZXCJ3pVbKuHJ3LTz@arm.com>
 <20231206150556.GQ2692119@nvidia.com>
 <ZXCQrTbf6q0BIhSw@lpieralisi>
 <20231206153809.GS2692119@nvidia.com>
 <ZXCf_e-ACqrj6VrV@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZXCf_e-ACqrj6VrV@arm.com>
X-ClientProxiedBy: MN2PR15CA0063.namprd15.prod.outlook.com
 (2603:10b6:208:237::32) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ1PR12MB6171:EE_
X-MS-Office365-Filtering-Correlation-Id: 3866fe20-9d9b-4d36-a84b-08dbf67b1d01
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	xy55FX6KsUfxybQC1kYqU37S1uHzQxNYSF+dCQ/ule99YsUs+B+bKs5KA3ADzVoVXjEXD5zPUkbQRkax6Cxg+RBoqrczc0GaV4UYN0RypLCy9GYtJp4nVBQd/prTbxUv2MFPc0ccCFrTq1dwDhvgeVdbjzIOpXh1Wh2OE67c1mG9ohpSA2FzvA/OetbSxgyQNn9tThJ19Wx4OtuT3MlePGYcKRViJUXtFzOsYP8gvQLkM0Xey3zbWejaNFlJAETuZnGMmK0EwvZrnxbOsFKCow7yJurZ5L1PG6tNkcT4yV0MjH2ZLWK6dvkTkaR3Bhu/CbrgvET/UAGzAUrj6aYJTvMtYdvx2GI8HuPivwFvF1nxzAC4ewiWEFX/q7tbewITm1QCKIXPlT2YMIsjjy1OnUvWj6xOGDlQX1NapQKvnoknsvwyoUIkrhLAJdxFL8RqpN/Zlg/pdFPb52YweMx4/SpKGUDhrEZyGPLreSqQ4T5gzFYoruq/KdeBC/fET+LfSYN8zvxsxbytBW16EupK+XzlD8EphKx3bN9JxsoVStuxAQWKqSCKV8njReoH0DOm
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(376002)(39860400002)(396003)(346002)(230922051799003)(1800799012)(451199024)(186009)(64100799003)(6916009)(38100700002)(86362001)(6506007)(5660300002)(8676002)(4326008)(66476007)(54906003)(7416002)(66946007)(478600001)(316002)(41300700001)(6512007)(33656002)(2906002)(36756003)(8936002)(26005)(66556008)(1076003)(6486002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vgXhN8xZjUaXP/Jkn9+XSSJYKDQAFzhMBnBi9G6IWC5NbmgalQB0qi0Pl+fh?=
 =?us-ascii?Q?sPtKfcSaY5+6v8faQ/AjmA6Q5Ll5Jjei4uy4jljyJOztwPSS841ZGKC+c7IF?=
 =?us-ascii?Q?4GaPd4QTEV/rfwfGefYzjfq/n6+z7qKMikiF/Uj7zofkItqarD/yYp3oXKCi?=
 =?us-ascii?Q?xeC8lJ9kfqE1kKIkmgh6yspm3I7f5jCcJLty3MQCLVwfTu+T8umI6QAo81eG?=
 =?us-ascii?Q?W5dC44SEnuyj0WT3K3b7k4DafT54sS6luWWI/JdJ0rHPKzKmc/8h7TRcJys6?=
 =?us-ascii?Q?Zk7Ta5EzSbMSmzhqeG7gcufymiBXBdU90GiceTvZsCgUTGC0AlWlM8mvANeF?=
 =?us-ascii?Q?tMgFztutzr7smddQRjJqRPMvniBVJdAb1yd714V7HkeIwQFzRsSS4mubECu4?=
 =?us-ascii?Q?6obYHSg3gxy3bPwF9Ic0uzKDMi7ZQ1A/tmOwJCHKEBdt4pSmxZL6NSDamWQp?=
 =?us-ascii?Q?GPk3AlK6vSeNNN1srxgTELIgh/t7hA6PdFH5Hm3o2Lw69t3VQYzvP+cdhXCw?=
 =?us-ascii?Q?TbJrt+3lLqfCD/dWaMR8GmVxxElc5v8NCpNJeUtiqUUnLtAv6Y/n6LDedNmo?=
 =?us-ascii?Q?+R1c5ZueFU9PHfelIaFJ8dQUhOWGi31u2CHiiziyx7hWHx1Umxp8ydjXowei?=
 =?us-ascii?Q?UlbBK/UubxdIJ0BaXEa6usOSTKqClM2Y2+Nnqxzs/7DUxxEEtVkLXl8Tk2W1?=
 =?us-ascii?Q?np1ZVmGMgIMJoB/bJu8K6TF6FzcJOyaitZlI8sPnbzoyFvSUM55At3AQvPv7?=
 =?us-ascii?Q?xNpkO1RFDfe3CuBw7SOw0Pa00L+jrnULLtq6nP3tb9AEoIJOBZ82fC4C/1bU?=
 =?us-ascii?Q?SIgukHP9HJ3xpjN52g0HEIYCYlO1TArUfhLk09uCYETg9gFUxfwTX6qPhu39?=
 =?us-ascii?Q?0q1wIqidLBGp+mVEtmlW5v3O7WOQuKPJ4QHjgtZ+Ude6VReDQsPjiCq0cB4+?=
 =?us-ascii?Q?zmyRab23UZtUnb8E2kNgOnDcZ7EZn+/Yao/Us1lEfVDDfRDhyjkGDXgD3xSx?=
 =?us-ascii?Q?YzzRDURZuiVwpdB5oFhVhAru6/8H/Rc4QsWBIs27lMbcjwaDw5ab8UegPsgn?=
 =?us-ascii?Q?rdsOIyNSqxGXe4Z5JlC1aq20gBLAhEiftpk7nzjRl0LpDe0a/sKm32Q3htcG?=
 =?us-ascii?Q?Mi2q+kuqavA2QtiHXYuHeXQhqD2LRfkydw3fO+sTd0smo9JURentJmj6n48H?=
 =?us-ascii?Q?aS3+eVPkQt1Q0T4nqmEma2ixNDXEaelVp1/xDuWLFKldLC66FW7RAllVJU9q?=
 =?us-ascii?Q?dx3u9QiDOcd0wQ6K+xesYbmKWNJCqPD9UAug+4DzJ895WAy0SHNoIffogq4Z?=
 =?us-ascii?Q?Yl2ToX3XgXzfIPR92Ij0wTdlCuFN8Oi6NpidAuwEK7BdSyF4Oyey6Wkot9Kb?=
 =?us-ascii?Q?/P/RGo4d/OJIqlxff/UKSQRqSJnPeiDQdrGNo2oQHO685g4e+2xetIfCGfgT?=
 =?us-ascii?Q?AFc9Iz7VokhAo47ZqAYduktFOrrjngL61a7WHtQIpGKc8zC7PRnaG7TfbFD6?=
 =?us-ascii?Q?Jw7ksQYeY8sRaK0dP7aessAMYl3awZsUPt6TrZdks3xUiEKZP0+MYD22xgNU?=
 =?us-ascii?Q?TY3DR24Cns9LNjmWQtJ4Us0B0mrNgabKuVW5Fc0J?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3866fe20-9d9b-4d36-a84b-08dbf67b1d01
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 16:48:03.3145
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gwBaVBxLkcJYB8Vl88lNk0uBtFZaU+27YDo7zSdcKDI0f/b1zDhTZhSTYhHYlVnX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6171

On Wed, Dec 06, 2023 at 04:23:25PM +0000, Catalin Marinas wrote:
> On Wed, Dec 06, 2023 at 11:38:09AM -0400, Jason Gunthorpe wrote:
> > On Wed, Dec 06, 2023 at 04:18:05PM +0100, Lorenzo Pieralisi wrote:
> > > On Wed, Dec 06, 2023 at 11:05:56AM -0400, Jason Gunthorpe wrote:
> > > > On Wed, Dec 06, 2023 at 02:49:02PM +0000, Catalin Marinas wrote:
> > > > > BTW, on those Mellanox devices that require different attributes within
> > > > > a BAR, do they have a problem with speculative reads causing
> > > > > side-effects? 
> > > > 
> > > > Yes. We definitely have had that problem in the past on older
> > > > devices. VFIO must map the BAR using pgprot_device/noncached() into
> > > > the VMM, no other choice is functionally OK.
> > > 
> > > Were those BARs tagged as prefetchable or non-prefetchable ? I assume the
> > > latter but please let me know if I am guessing wrong.
> > 
> > I don't know it was quite old HW. Probably.
> > 
> > Just because a BAR is not marked as prefetchable doesn't mean that the
> > device can't use NORMAL_NC on subsets of it.
> 
> What about the other way around - would we have a prefetchable BAR that
> has portions which are unprefetchable?

I would say possibly.

Prefetch is a dead concept in PCIe, it was obsoleted in PCI-X about 20
years ago. No PCIe system has ever done prefetch.

There is a strong incentive to mark BAR's as prefetchable because it
allows 64 bit addressing in configurations with bridges.

So.. I would expect people have done interesting things here.

Jason

