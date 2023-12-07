Return-Path: <kvm+bounces-3860-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9245E808955
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 14:38:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 04BC91F2138D
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 13:38:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C580540BF9;
	Thu,  7 Dec 2023 13:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RhCZKxKE"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2045.outbound.protection.outlook.com [40.107.223.45])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4C4ED54;
	Thu,  7 Dec 2023 05:38:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j6btKgnBF2db8ZZxk47wou3rGEWdiWf/eh8ASiNB13C0E9Ioq0N4SwqX9Dc6YPj9qtHcNBSKnPc2EkT9CedmcWyXNHF6vvOuoH1BtfGL0CsJQ1p/oljZXL64FQVVK9gNAnBWEfr/HseQsh5Agh3djmBegFOlsCYXNzbxT0E19XTnFD4hYOUQXBGn/IA4rJFhC6miBNx+uwB4tBgHVSv0Or1+UHyR4bu0P72/rr++2aPRQXYvwzKbcuV19Ahe40trkQhLBGgzG3OH78oz7IbKoyJpOmNHR0uQ2CR7mILkCzusd7e1PZfdY0dhI70wuq6LHebbEkw6D5wqWdM77E9hFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CNkJqALxPIloVQQyRq9w66yUKQ75s1OxQOBMXkXLLOY=;
 b=bpOZYbJb/5ieINi8OXkzkqCyG0yoPk3R2+JgdZ/y479itdbMucxSJiJ94gwX287Rv6Bb+9Q1ZR/MnoJwDjj38lTCWRLmsfvL5qQ+aXyCmoVCHT7QDblBi1xvEOXDfGI9Kz1Bx8DWqy0J37cg0kVioabBTpK0VJtOyOG+O5k3eUIGnucHsKJjCvKDfaR6XvjW/wCKNlrTXST7dkYKQc7Rntwr84xUUmBrkmqiDSxTWqliCxjpA2tN/puk3AD8asL796glCKlLDBW1Ux2U9DoGZVsCdxFZqJHKM6ovFMsjnk9066aUJAd5jxh7AyypnZUzSWKi3EcPxW0MhmzFdjQQYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CNkJqALxPIloVQQyRq9w66yUKQ75s1OxQOBMXkXLLOY=;
 b=RhCZKxKEg64gyT0b3j6M/kiF0VwmTEP3Vbzr65E4uYfcxx6SigYudTEJyaCC0JIzcyUs23wWsWO9XfD9Cxw5D3FVzaTKBLzmVlqPGSo1ckyEKpbWeQ0ujKipKI4KQ0vxsHgnBqtXdUHUZzu5ZHuli0Dfo97f6DAIQaKvaqc4Mc/2SJQEL28O2iQqvnFA+MCynuQJEv32XZDnMhTnUnzuyPe3lo/WaKJfsC9bdl45aR9r96MC7dQMVXoBmOd5k8B2LNGK8IIm2ygW5xN+B7zf9PIGxkCYYtvpx6t8Jm9xqigEjSpYqkdn+Wsy+9L6PmuWlFTxY0qx6C+h+e8d2LAMiw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS7PR12MB8289.namprd12.prod.outlook.com (2603:10b6:8:d8::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7046.34; Thu, 7 Dec 2023 13:38:26 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.038; Thu, 7 Dec 2023
 13:38:25 +0000
Date: Thu, 7 Dec 2023 09:38:25 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Lorenzo Pieralisi <lpieralisi@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
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
Message-ID: <20231207133825.GI2692119@nvidia.com>
References: <20231205164318.GG2692119@nvidia.com>
 <ZW949Tl3VmQfPk0L@arm.com>
 <20231205194822.GL2692119@nvidia.com>
 <ZXCJ3pVbKuHJ3LTz@arm.com>
 <20231206150556.GQ2692119@nvidia.com>
 <ZXCQrTbf6q0BIhSw@lpieralisi>
 <20231206153809.GS2692119@nvidia.com>
 <ZXCf_e-ACqrj6VrV@arm.com>
 <20231206164802.GT2692119@nvidia.com>
 <ZXGa4A6rfxLtkTB2@lpieralisi>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZXGa4A6rfxLtkTB2@lpieralisi>
X-ClientProxiedBy: BL1PR13CA0254.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::19) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS7PR12MB8289:EE_
X-MS-Office365-Filtering-Correlation-Id: d83d53c0-7edb-445a-1e14-08dbf729c9f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	+PLS9XJa84XgId/39fpR6mjL4zlOYkDm6EAMMNlxDWH27P/4vPSLDV6SzEl8RCXk7+9FZmLvNgYQVxzcfIajAo6TsFYJSDO3A3HgZ2dvuH8xhIDJZIU6dHpk/kY/Z4wxagzZxFiJjBrpRCVKkJv1rxfIxA8jxfwxHEg/vXIU5kbV+qktZXreKR98OmKY9LJdqX5zx9ew/FgSbHIoCr8K8ZVIHiAYUQO5NPM5wwtdZEd8Nb/a+1nffPNqX+ZTFyv4aIY8QnTO8Oz/cZoGB5083Og9afox625RegVqaT5Saz+lwDf0H/z3l4JLAinb/cIo6LYzdlcAe+jesEIz9yN0e3mdZC7JooXo1LoZhoptqLvBB76UJ72r6WaaKLSDhFrdjikxDWGvXANdC6fV368szwllxc4ROk819oSYjyr/W7dem2VBdZo5J1IvkibhYDLNpBMscBwFWI0Ji/IDJ/gWhyLvd9tvudONLsY/i4Rb7cBNCarVpJILhbDXxo9gqVffm5rMSJc+xKNExsBA+zJwc8ZmM7bVtJA6OCunbnduI1DwPtqKGBJ4F+S/xddqlnQh
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(39860400002)(366004)(136003)(346002)(396003)(230922051799003)(186009)(64100799003)(1800799012)(451199024)(4326008)(54906003)(316002)(83380400001)(5660300002)(7416002)(6486002)(6916009)(66946007)(66476007)(66556008)(8936002)(2906002)(478600001)(8676002)(6506007)(6512007)(2616005)(26005)(41300700001)(33656002)(1076003)(36756003)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?p2lInPG7+HvFJ/QV4Rl9Pvm7Y77r9O7E/I6Xf3z4jkELZr+qOxGlbQqqrYUf?=
 =?us-ascii?Q?qN/HoMOdLX2facLQDoFUJ2Bo7dGXSELZ9Elo8OPqvU1HYmxjfAS/fe6OMPEo?=
 =?us-ascii?Q?1MRHgF5aw7YNEax9dBHazay20Ei6LJq+I0zgsJFAuE2ESQNkYJhvTMTBAInV?=
 =?us-ascii?Q?KDMmww/FOR/lVNUR2fB7k3QS8ZktIiRKvTr6xxJgUh+9vmuPqqLXBqVrfYUN?=
 =?us-ascii?Q?NdGPFWRSDiBg9nZapq8gDIqvRV7IkHtwp33ejaH+g8NByk9euxZJf4gmqQmg?=
 =?us-ascii?Q?T+zxg5ChCvw5gBYJCXLBfWgXdArmQG3UIk7I1+ICYA5KlMkFGPBItpF30cEb?=
 =?us-ascii?Q?+86KovZeDxNE1BwPhMST54VLAeyXOCY3Vz7JHG8xRlynxHsINJQDN7wH7dpx?=
 =?us-ascii?Q?crCgkkL7rn81C7/chzxjQ/hMNz0oRQErYsG4bbNwRTs5fo7iN7L8VGyub/wp?=
 =?us-ascii?Q?3tM5yZUk5ZBE64Br+yonfAPYIPEsmpeuxPgdXLR8yerYcDj0UqhaYnTOXgtk?=
 =?us-ascii?Q?N5ImNumSTqtSdsrYXNrwf2YQ01FoCDPKxaajoQodFjtKzyzQ5p9wCIR9z9vo?=
 =?us-ascii?Q?j2M9T/+QiLF35nHRBzzi1zWn3FjF7Lmr5WE3yswGMFgoE4IPWDiVyQRIFu+O?=
 =?us-ascii?Q?uYIWn+r1GCK6CyD7eprlexPu9vnK+223UFzodwlkHHxViAbsBiu96J2nLYGP?=
 =?us-ascii?Q?CbIrPYzmmi0ptReY+8Wsaxz0preIsOwJRtfrRAw8NKNc0kHPWs3BqwkWcLxz?=
 =?us-ascii?Q?5AXVt+1xG99yZrdFgV6G+fbsXyP3PMkZMY6F/I8oLVGjMxcftE3p1x+K7iRN?=
 =?us-ascii?Q?l51byr1YABmErO06oT3huHy/ReFME6Wh6bl7Jiw1rDWCr0LUxZMDAD9XgPaX?=
 =?us-ascii?Q?1YGaotSuPWPVeHAO2oz7jvlU4UruUjtu1VbLZmCPSq5OkvjtEWm5YHTe0erS?=
 =?us-ascii?Q?VcPorsbEMJiBgmWzbgX1s+Zqz9GxlEkw+IfAAT2Na1oQybWd1xsRcRBbkeif?=
 =?us-ascii?Q?sLp5dsmmlYVvSYeLi7hWh+pvQ0ZrIl6/EedEIQA0ZcYJJpf9oiSk4ojB3RWC?=
 =?us-ascii?Q?ey0SWOvL1CHcJLW9V2dmigk1/t8BYmT3leVnAgzVYRDFes5MrsmOFdAYkB9F?=
 =?us-ascii?Q?ojibFeU1lir5DdfctevO/ZYxevXt0dRDivdRRiTD7okp9nD09qi2093eMKQ1?=
 =?us-ascii?Q?LG6M/u8RtCQaG1vN5g25HMeg2j7JT8NusM8hzcBwO7ZDZXFBbBrcIdHkP9rf?=
 =?us-ascii?Q?IEn2Ph5SCwcFneU7uAEpbNNCrbV2qB1t+QUZw7OBmJIhDITgP5+1xjiZDZXq?=
 =?us-ascii?Q?bbArTDONijhOFf3GvlvpbN5r/H9jOuHTnvkjEdO5K9iu2DZ0XAND5WyaaGXO?=
 =?us-ascii?Q?RCddAqhzS5SP4gJsXxyjyoZSWrUmJVOKJurhQs8SlrNxZSoZpDtDzJvXfnBx?=
 =?us-ascii?Q?bURMvRKkz1qBRvzL7aUGiIIRV8Ohz1BcciEftkC+D/wRG/Ir03sdNtl/2kjp?=
 =?us-ascii?Q?XZ4HmO65cOqTUKl5X5Ah0rdJmnyUYnAwPk9wBQToI7IeXbFb2CyB6Waid60I?=
 =?us-ascii?Q?Eo4S7T6CxLmsPtX69uakGzJWvMNCaVHVOcuRc+7H?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d83d53c0-7edb-445a-1e14-08dbf729c9f7
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2023 13:38:25.8836
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3BvC8BnVt6ea0X/JCkPQw/WlLk6usmY0nQ6sEn+u20QWJ+uAlP6Jw9+VPKEYuDM2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8289

On Thu, Dec 07, 2023 at 11:13:52AM +0100, Lorenzo Pieralisi wrote:
> > > What about the other way around - would we have a prefetchable BAR that
> > > has portions which are unprefetchable?
> > 
> > I would say possibly.
> > 
> > Prefetch is a dead concept in PCIe, it was obsoleted in PCI-X about 20
> > years ago. No PCIe system has ever done prefetch.
> > 
> > There is a strong incentive to mark BAR's as prefetchable because it
> > allows 64 bit addressing in configurations with bridges.
> 
> If by strong incentive you mean the "Additional guidance on the
> Prefetchable Bit in Memory Space BARs" in the PCI express specifications,
> I think it has been removed from the spec and the criteria that had to be
> met to implement it were basically impossible to fulfill on ARM systems,
> it did not make any sense in the first place.

No, I mean many systems don't have room to accommodate large 32 bit
BARs and the only real way to make stuff work is to have a 64 bit BAR
by setting prefetchable. Given mis-marking a read-side-effect region
as prefetchable has no actual consequence on PCI-E I would not be
surprised to learn people have done this.

> I agree on your statement related to the prefetchable concept but I
> believe that a prefetchable BAR containing regions that have
> read side-effects is essentially a borked design unless at system level
> speculative reads are prevented (as far as I understand the
> implementation note this could only be an endpoint integrated in a
> system where read speculation can't just happen (?)).

IMHO the PCIe concept of prefetchable has no intersection with the
CPU. The CPU chooses entirely on its own what rules to apply to the
PCI MMIO regions and no OS should drive that decision based on the
prefetchable BAR flag.

The *only* purpose of the prefetchable flag was to permit a classical
33/66MHz PCI bridge to prefetch reads because the physical bus
protocol back then did not include a read length.

For any system that does not have an ancient PCI bridge the indication
is totally useless.

Jason

