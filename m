Return-Path: <kvm+bounces-3737-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D8B7E807668
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 18:20:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 161B21C20B78
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 17:20:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FA9B675B5;
	Wed,  6 Dec 2023 17:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SHmA1xuR"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2058.outbound.protection.outlook.com [40.107.212.58])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4C7BD4B;
	Wed,  6 Dec 2023 09:20:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ihelwTm6uZRY/glxuvHh6aVPpBj9YeN/d13A94TA/CNoxfek3ZeC0fUaF7Moz3NwHlkHVg/0urMW+iGIUx7MmxtfOMnMY+OVzoDkwfY5S7q4DmtGsNwWPZs4Xsc0cxMt0x62W8VKfPaDUJcfjHW4V9/DswF9rQWturYGxnHwmmEq16skxBsXyycDXtiGOU3b+eaZ4Y10tfM0tLDDOlCmRdxDKOk82if4fZeZ8I1sjCivk3bnwJovTVCsNfJTKmlgdO9LwVHLHofThDBpsBOYtlgO+mtfRWrgZIeofmOUpxZ3NRpt695DTbgYPSmM79ajpqRUs8Una5SC968F8w7+Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vVUE0rOnDjben9YuQw5c2i8NkkAISTFLCehfbKPtf9E=;
 b=kPDbHSm4KbYCTERVOavrY3DKEqbo/wyeAqt53ejGD9Se2e17y5PGCM+33vMRExsTxOB6ZHyU20XkS7locfPZ/fUTxQE+CLaQDbwSlq82Th+pyuVogR1wG1/lDYal7f1qQZFa6t4PpGjP5KJRpN3dseLdRAWhHK+fAq+Iuf2VoxuASLcd/o4UD73fNUlLSobAwhNR2xudlFisAtvRn6lvAu0qv10WZnOlV97M/03hThWRMoVyoKKfucf1K4Ym7BBzc8ktLBH0CwZMyiIHjh69cKaaRmtUYgwGZ1UwXvzI3U336L+nYsI67yP1G4BAdiXvWGE4eSLg3nVNQFDN+QlpVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vVUE0rOnDjben9YuQw5c2i8NkkAISTFLCehfbKPtf9E=;
 b=SHmA1xuRZmyhT6JWsScdIgDODdM25YLAWciAsgwByPSThCkBm5ycX6XyIfx3cbnJ1OlEE2x89Dk7A6KfN8teBtW3u30wNqKoRlPhAgUQFINgmr+g8Cqchc+3tZvddU8HvEqWkHdiv+fxAYzJxNtPS4GLfTgGuI8+H+wogqjZfycCov725Le7jxRQ39BQBE/HqdlKa6lMxYgDxe9tqhtJNFHUjhRpHIlqrIX2pq9BGF2vUIZcRGMFp2qz/vy/+YIJiQS5Krx1EYCD0eXTAgqvI2D6RY5eelMdEzfnrmFcuzcrzWWFzdI8Vrvl3qjuiSvHlQXBdhu4cG13Sq8Bge0q/w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM6PR12MB4057.namprd12.prod.outlook.com (2603:10b6:5:213::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Wed, 6 Dec
 2023 17:20:37 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Wed, 6 Dec 2023
 17:20:37 +0000
Date: Wed, 6 Dec 2023 13:20:35 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, ankita@nvidia.com,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	oliver.upton@linux.dev, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, will@kernel.org, ardb@kernel.org,
	akpm@linux-foundation.org, gshan@redhat.com, aniketa@nvidia.com,
	cjia@nvidia.com, kwankhede@nvidia.com, targupta@nvidia.com,
	vsethi@nvidia.com, acurrid@nvidia.com, apopple@nvidia.com,
	jhubbard@nvidia.com, danw@nvidia.com, mochs@nvidia.com,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, lpieralisi@kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/1] KVM: arm64: allow the VM to select DEVICE_* and
 NORMAL_NC for IO memory
Message-ID: <20231206172035.GU2692119@nvidia.com>
References: <ZW9OSe8Z9gAmM7My@arm.com>
 <20231205164318.GG2692119@nvidia.com>
 <86bkb4bn2v.wl-maz@kernel.org>
 <ZW9ezSGSDIvv5MsQ@arm.com>
 <86a5qobkt8.wl-maz@kernel.org>
 <ZW9uqu7yOtyZfmvC@arm.com>
 <868r67blwo.wl-maz@kernel.org>
 <ZXBlmt88dKmZLCU9@arm.com>
 <20231206151603.GR2692119@nvidia.com>
 <ZXCh9N2xp0efHcpE@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZXCh9N2xp0efHcpE@arm.com>
X-ClientProxiedBy: BL1PR13CA0109.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::24) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM6PR12MB4057:EE_
X-MS-Office365-Filtering-Correlation-Id: 085ca220-403a-46e2-6cb2-08dbf67fa9a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	+EbR6enDrIhiuG4mxoYJMPudX42UP1jRXkAhPX60Ec7FWTX0hnn/QuYUzeX5hXM97rzZWWG3K5bW33jBbO5AuDNgxrWgUQYsjjtDyq9Eht1cE+msy2LrchLkjjfEjgnx3jEAuz9NAW1wP4ExD/0N3sIBt9/RXmjgSr54Xpm9rC5nwQeXp1mdwvyOqchMwgDkMYrKP3oxAUDqwNr7GAzV4Q6qrpgIpsMpT4/KS08aElt+7t791bqvn3HcqpuaptQWVmplmvTDWj2+jXtDgho6i8NJ2GmGXvCrZ1bU7WwX7pqQXK7GErAhHejrY04X8TV1BBAVHjiMQAI8NWCiPx4NJSXAn0phkTbRgfjabiw849DgA2OcyErYHOZHiiLdadOUIZr6D3eLN3OtW7BcPAvOQfuMBUkL9zoYTqbGSnNhJdSgZv27kZIGxwu5qyoUKBJW9qJ7jtyWsHBt7TNtUje0gnv9f9W0wAL42I88OLLo9gg1sN9/F+V9eVFOs98jNxw/49S1wk0Ixi3bW7baazC/tRK7MvAvYN162PjC+6y39129sXg8QumBFrdyTAzkHdMx
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(346002)(136003)(376002)(366004)(230922051799003)(1800799012)(186009)(64100799003)(451199024)(38100700002)(6512007)(6506007)(6486002)(478600001)(54906003)(66946007)(66556008)(66476007)(316002)(26005)(2616005)(1076003)(4326008)(8676002)(8936002)(6916009)(5660300002)(2906002)(7416002)(33656002)(41300700001)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kBVnosITWAeDzgtSXO9TxTToBRB30CpIaElW/4IeCcn18Pex0eicT+qF3hqG?=
 =?us-ascii?Q?B0MCnJK88LZXw62bWoq7dRzzQT5liNnBpyO7oeMNiJnpeQO37r7mKHTYBBt+?=
 =?us-ascii?Q?MwgvTRT4ZcBnYI+K/sXUAA1nfj4BjVgU2WO3FRk7IEW6Xg1Qr2OffwvSSUu3?=
 =?us-ascii?Q?Tn8A7z2A/C+YDsxqPp6vinSzn9gSbijxvQrgcNSQjy9Tlw2G/pEupwnQ6qCC?=
 =?us-ascii?Q?7Pfxc1lYEKEXQL7lJF3eDcC9REYNKfL8RNb1fvw2378Yj7h/jrehyw7mKRWQ?=
 =?us-ascii?Q?YmrM8UHTF3hjg5r1Bkig0/Sdi17O91vUGB8NJyyYoD+hEkUBil8rRfvVEM4x?=
 =?us-ascii?Q?LmCjMfOfPSWiEopdbfoQ12ny+d1PSmT/MaB42G1+DdoxhqJrp8o++AFXGFHJ?=
 =?us-ascii?Q?jX8mNkTLlKXy+w2T3A72W7oe5vENdEz4t6tMb2NuW9icJFTFPNO9f6gbnJVt?=
 =?us-ascii?Q?y+EAVAke5Oz/aQVb5gxcYyLaY23D13iAbBlgs8mzwsj+vj/S3rqyaicCqV34?=
 =?us-ascii?Q?fiPqTsDbO5/sAGnv0z7CSKBPeKS2UPtlCEhflR6zIrqNN0sBskvLvCwI2Duv?=
 =?us-ascii?Q?P3fonk0QzwD/Ha0VnAWaccosswnB5FvIOZLLrddSIn2lLOu1J6kzuaR6Gqvl?=
 =?us-ascii?Q?OsYPqW6ogNOW1GZBYi/pk4GSh+WIBKVJd8Xwe0PSEaBf5LNokr/J7qmjbCpn?=
 =?us-ascii?Q?LkqrHI6+R/6aQlc7UWiTMwSMlVLGCwlQpL2iXBBufpaEucft853AmZz09CzE?=
 =?us-ascii?Q?u629WKTHdlK3ZgaHzNrev9P74r9AQuJVMlU4AbhSXn+i2bzNOGZ2Wv7BN6vM?=
 =?us-ascii?Q?hnjR4zsnTC26yIecBJG9NO3M+PGw+Q/PBZqj9ydGpZxbWBk1SxjbUkTWh1fK?=
 =?us-ascii?Q?bgs2sZwvnZk1PA8D5WzHm890meBYs4MmD0PT7RlXqHvMwXR/W/dHmjSVP5NR?=
 =?us-ascii?Q?EY2Fip+M8rNEpMbiso81s5udxlsp4pqVJny7EpwFON05603V63ljP1kAHkZ7?=
 =?us-ascii?Q?lanIoi2vhXm44e88Hl3S1U4E/J9elhyMRs+NJOFqUKCuWbYot3oRPvyIg1KA?=
 =?us-ascii?Q?Hu9fdlz8vbVDTT5Svp5OQqlgyUl9zpP9KhHUGbyDqvUBsmTeKJsjQcySmaPs?=
 =?us-ascii?Q?D5dygoyVdk/f8mv0OQzZhsD8a5vP5bG9ZaqtyQsFX3qKuSDCFFAy+lkdc1br?=
 =?us-ascii?Q?7xHrlBbLqNPct3k54xaCvAzpN/3x50DIA4/avfsESxF41wMkhfFm5Peq6LNb?=
 =?us-ascii?Q?EQaoFlCPp4mtTEgCgF5JcOj78mxnyV26DRwx4X1OsySceixGY61XIFJwU9so?=
 =?us-ascii?Q?sRmvSTX1zJvfTDsUe7agpy8iM5K6o1ji20RWXB1Qc+kHO/1vpaun6kmq4zJQ?=
 =?us-ascii?Q?1KFG+wzrk2ApBF9JhdgQ7fGjRuAiPJQIavaCCP16U6gjcGxfvhhbMBAHCkNP?=
 =?us-ascii?Q?vwjndTQOCRreL+RvRf+MSHI0wotNA25lHSKdW0929tqisTj6PZA3+zYNSGGt?=
 =?us-ascii?Q?g1OIR28G5vp0BsvPbitBIzbBX/tStzjmVSANVOLRwx5ry2zcDYZJy6cuWdue?=
 =?us-ascii?Q?iCnyt8PvIlrUvI6EA1BgFnBFvTJpbr5rACiBd5YU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 085ca220-403a-46e2-6cb2-08dbf67fa9a4
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 17:20:37.2119
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zDs2OKmci2tMSCfZ8bA5Lyc4+ta19BSfiU3OF/OMxVJf8FpcQ+W1n/b3fXod96Rp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4057

On Wed, Dec 06, 2023 at 04:31:48PM +0000, Catalin Marinas wrote:

> > This would be fine, as would a VMA flag. Please pick one :)
> > 
> > I think a VMA flag is simpler than messing with pgprot.
> 
> I guess one could write a patch and see how it goes ;).

A lot of patches have been sent on this already :(

> > > If we want the VMM to drive this entirely, we could add a new mmap()
> > > flag like MAP_WRITECOMBINE or PROT_WRITECOMBINE. They do feel a bit
> > 
> > As in the other thread, we cannot unconditionally map NORMAL_NC into
> > the VMM.
> 
> I'm not suggesting this but rather the VMM map portions of the BAR with
> either Device or Normal-NC, concatenate them (MAP_FIXED) and pass this
> range as a memory slot (or multiple if a slot doesn't allow multiple
> vmas).

The VMM can't know what to do. We already talked about this. The VMM
cannot be involved in the decision to make pages NORMAL_NC or
not. That idea ignores how actual devices work.

Either the VM decides directly as this patch proposes or the VM does
some new generic trap/hypercall to ask the VMM to change it on its
behalf. The VMM cannot do it independently.

AFAIK nobody wants to see a trap/hypercall solution.

That is why we have been exclusively focused on this approach.

> > > The latter has some benefits for DPDK but it's a lot more involved
> > > with
> > 
> > DPDK WC support will be solved with some VFIO-only change if anyone
> > ever cares to make it, if that is what you mean.
> 
> Yeah. Some arguments I've heard in private and public discussions is
> that the KVM device pass-through shouldn't be different from the DPDK
> case. 

I strongly disagree with this.

The KVM case should be solved without the VMM being aware of what
mappings the VM is doing.

DPDK is in control and can directly ask VFIO to make the correct
pgprot with an ioctl.

You can hear Alex also articulate this position in that video.

> There was some statement in there that for x86, the guests are
> allowed to do WC without other KVM restrictions (not sure whether
> that's the case, not familiar with it).

x86 has a similar issue (Sean was talking about this and how he wants
to fix it) where the VMM can restrict things and on x86 there are
configurations where WC does and doesn't work in VM's too. Depends on
who made the hypervisor. :(

Nobody has pushed hard enough to see it resolved in upstream, but I
understand some of the cloud operator set have their own solutions.

> > We talked about this already, the guest must decide, the VMM doesn't
> > have the information to pre-predict which pages the guest will want to
> > use WC on.
> 
> Are the Device/Normal offsets within a BAR fixed, documented in e.g. the
> spec or this is something configurable via some MMIO that the guest
> does.

No, it is fully dynamic on demand with firmware RPCs.

Jason

