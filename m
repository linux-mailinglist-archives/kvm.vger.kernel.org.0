Return-Path: <kvm+bounces-5818-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 89A6A826F85
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 14:19:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 03C2AB20D95
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 13:19:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D1AC446DA;
	Mon,  8 Jan 2024 13:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="j7Ek6whi"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2043.outbound.protection.outlook.com [40.107.94.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF604174F;
	Mon,  8 Jan 2024 13:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TQFtqcOTMDVmGvwcA3KiXufZgb5fBaQABGj2rDGawEGlj3oaCCd5o4QGcNkqfw+IjqbvF31jBhe/8/OwLzyE2XZR99b3tREH3j992U4Tc5a6us/ZewEXnQmNSuc32QyaR4NHFdez9SD03psjnn3NNOtl6emYIYiLj55YoAXvpo42WDXzLmqXgp6R+RSnUWNU66FYSOhjpmWxHlLHiT/JTYeOIrFzRSiKl+wmOclrcXNCDSCbdYA82jXbcnK4QYjzD23SSuflLqlfW4/LQlR+82+glvWgakISzabT5DITXuOXvi74x4eKGXQEhDDjZ9+UpmGC5YSWFXWbiM88zanCLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9m1IEbwkK6X0jpy+ma0dRF8Pb17RBYQfic5/cjacwZ8=;
 b=of3YSNzZDNiqhOYMz3RhWDRP2cFkNGo0PFhwVgKBQsDYPuk138tLXFtSGSatn6agDAa2thO6+4AT7TNiFfiE8hQQ7Q//GpHym0vGlknFDQdSJAIkDYWwiCg0QYBVF/TbazY5vkoqMzUTCpn3upoka0tD1Rru+grtLKvQBn5K4EeXCSxn6ByAh88i7KizQ53euowfiXZGb6vvE2nUwFSynheCEp0ZN8XCjg/9tLHn572uXJluVhbFBreSZJjwU1cpBc2Q43cnyT+LhBcr/3oJO7DYJM2snHFb5wlnLbji0VHPP2KmWYi8Wko+RzLcHacI8ija9TPLTn4NfV/tMsuxrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9m1IEbwkK6X0jpy+ma0dRF8Pb17RBYQfic5/cjacwZ8=;
 b=j7Ek6whiPdYUxabTLUdgd0cnDlEJYQnkJlrsDdEse6HdWjFwlTG+DO0rirupeL6vT/J1t676ZSvghsT4Jv851CiuJEvgBBH+M5CqZcpA+bX7ZTOn2gllMYO6gE9r7AURG2b75HXgbeHu4nHtSlrDIUXqXuky5y4CYHGYqoadsFVs6MxiyQxPKZ1NK6y93onCYt7wnvGIVNGXCoZ96mGpVUZfmgqavaBVJpDeSLPfVjMqCzRJNwvuX0QuL99iP0H4e7DZwrjiFHCAMSs8TarzlcejovT0Mz6IFEgdxqXxRfmDvounEhgLChx84mKbZcqSTqgLevBUc3FbQg6YDw3ePQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA0PR12MB8349.namprd12.prod.outlook.com (2603:10b6:208:407::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.21; Mon, 8 Jan
 2024 13:18:50 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7159.020; Mon, 8 Jan 2024
 13:18:50 +0000
Date: Mon, 8 Jan 2024 09:18:49 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>, ankita@nvidia.com,
	maz@kernel.org, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	will@kernel.org, alex.williamson@redhat.com, kevin.tian@intel.com,
	yi.l.liu@intel.com, ardb@kernel.org, akpm@linux-foundation.org,
	gshan@redhat.com, linux-mm@kvack.org, aniketa@nvidia.com,
	cjia@nvidia.com, kwankhede@nvidia.com, targupta@nvidia.com,
	vsethi@nvidia.com, acurrid@nvidia.com, apopple@nvidia.com,
	jhubbard@nvidia.com, danw@nvidia.com, mochs@nvidia.com,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	james.morse@arm.com
Subject: Re: [PATCH v3 2/2] kvm: arm64: set io memory s2 pte as normalnc for
 vfio pci devices
Message-ID: <20240108131849.GG50406@nvidia.com>
References: <20231208164709.23101-1-ankita@nvidia.com>
 <20231208164709.23101-3-ankita@nvidia.com>
 <ZXicemDzXm8NShs1@arm.com>
 <20231212181156.GO3014157@nvidia.com>
 <ZXoOieQN7rBiLL4A@linux.dev>
 <ZXsjv+svp44YjMmh@lpieralisi>
 <ZXszoQ48pZ7FnQNV@linux.dev>
 <ZYQ7VjApH1v1QwTW@arm.com>
 <ZZhpt8vdlnOP7i82@linux.dev>
 <ZZvWzyNb1V29-H85@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZZvWzyNb1V29-H85@arm.com>
X-ClientProxiedBy: BL0PR02CA0117.namprd02.prod.outlook.com
 (2603:10b6:208:35::22) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA0PR12MB8349:EE_
X-MS-Office365-Filtering-Correlation-Id: 2cf764f7-a2e0-467d-26a3-08dc104c5a56
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	fD63ep9UyQtlkIiOuVlpl2P7GFRJqVPUHsRZCHcjrCZuI+WriC3S3G2CyE98gNgWPduzCZDmONxNu7uO/gL3TUgI1Wq7rt6iTF9ub6RHhbwMARWI7/P6kpbvaa/NkzPlINPSpKlmFEm23gs6f6VjPmRDp7MoXBI/PR/E8gwbil/OlDtlgTJZU+xi9Sbxmr0fAKgN5K43Cx9UHuPDx+bG9+V1BJGIvhMCNBbGgZylPFOOeJfZM0baOchrbbt0WTTzcB4NzCIkPcjfgXqF7yQv+LjgymOnJT65X8Pch/I/Yx59IADzs/UdkZhb5N4MFqVL2FNlHKUnehGZCYaUY2CuTVoThWJrj76xquLznjclgCOWP24ZChDqO0JjMb5I1daaRDpkE4Km+DqWdBOrTHmT+LWN3EZCfbFGiTWDMhs0eX62PauzPaWgLpnBMCZKMCaE5hSrzUUCf8du4jucqB2kp4Jn5uahtrYWc8XqYecNKqdCqlrBxz+eJP8y9wQhetHooOm1zV2tPUnM/n7V+mIC8UFTOCiJ9sv+rd+C519EUmvWjK3Lo16YP0lf4+hMQEXt
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(366004)(39860400002)(396003)(376002)(136003)(230922051799003)(64100799003)(451199024)(186009)(1800799012)(26005)(2616005)(1076003)(6506007)(6486002)(478600001)(6512007)(38100700002)(36756003)(86362001)(33656002)(2906002)(4744005)(5660300002)(7416002)(41300700001)(66946007)(6916009)(8676002)(66556008)(66476007)(54906003)(316002)(4326008)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jeATqOI0WJw9XRA58JpP7wHzHZj35fK1Z39aLQs4RZojfiejnI2KrP71+Hqp?=
 =?us-ascii?Q?iFlEXqr9+AebV+C/guc4r9eqb4q/8E8qDbbLOjtLml+AzdWtICJh0g3wky76?=
 =?us-ascii?Q?XoiWHI9Pzi39Dddz9CrLv7m1YKxqIh5k+7Ct3XpBXsTa06NDVMR75i5Vu4k2?=
 =?us-ascii?Q?wN6R+dZ798xZVQQrB3VFGeiqP7XDY6i5IV6A4AYHFNRXObLNij4PUjznjhr2?=
 =?us-ascii?Q?BGJ2KIvQlwkBWZicwYBUAl/p1zc9FFXyWvu8Jkl/I90EbMCf4nQ3rL5NfUHm?=
 =?us-ascii?Q?T0VyGMatHOcjOn7pRjf/P7P3YvGSaG5OqObM2B1C8cYSBh5NESYOnBWIDj3H?=
 =?us-ascii?Q?rTboNrwQieYkDPWna0IaaEevaQZKpuJF+EUuKNv7sKDESHOd07T3xRnvd0vz?=
 =?us-ascii?Q?ql7jmEFWhJw3h44ENF22R8v+tdRSetAsiei3U/8a48DpLxXw5nwKb7a6KQ/9?=
 =?us-ascii?Q?i9zW4czP6rx5tU0PuxuENxO4T/sbsUbcyUEyb13IlhKZSp4OyUzeWy528Atv?=
 =?us-ascii?Q?qBmrOzdaC6979V6vsAa9l5SeocFEPW6H/Any0Kr5iNNAAPyqM2HfaHqkRti8?=
 =?us-ascii?Q?XGVF+T9dN+lWKFWkuWIuEgf8KBJA+6YXlw3MrqD7I3Pr1+GFffH4Pg9XuwR7?=
 =?us-ascii?Q?otr5XX+dC7p1Uh0IDT3121Uj6T/QphSBekF/NQEWMRVyXp4siSu0Iec4Dfnw?=
 =?us-ascii?Q?FvUtsWmdfy5YscEUaIJmO4LsJnsCX9JCVR9VR6Mh29/TrcFYNpFnnNp697K8?=
 =?us-ascii?Q?5D/eeaA+HiKvSj70KkKr3wcw/LayjPLXkWkccYYsmW5jvT+g/XYuw5ezVrGd?=
 =?us-ascii?Q?7p8D24QBELKQ5IAfsR/Tt1eluvaASaokSlTslYUJafcp7vXrRzld2culuNux?=
 =?us-ascii?Q?KSfIf+C3t7H80io5yigFFd+Qr93BCHZcEGY/cokb3ojszvXaO0rwnUf5tUKW?=
 =?us-ascii?Q?3vi1IrWXxPbRgv1YtgEy9moyUsF+Y4f92U3MR3aF1/zfdspHCd/mM7ceahXC?=
 =?us-ascii?Q?TebgH5mxgxXAc7mkCTDtmvsMpLbWZo3jaGg/aJ83E4/83+Y+8UwRtt3ahjJ+?=
 =?us-ascii?Q?Y13OmfQzTqYSYU4Jqn4y5JnInt2MwEHjfAr233hfSI+6F4OmUaMKYmKeasn6?=
 =?us-ascii?Q?ACdJKYMY75+dDKQTVUSoiliTCTpVI2k1kUWbn5tehugIGPM7+qh4/9e4GxJD?=
 =?us-ascii?Q?sWI+hndoRPxFGgFjG+isqhfIELkA7GGxAshVw6owPTevn1sh1fcA7ciJksji?=
 =?us-ascii?Q?2mb6qzmXWPhkYhje/f/t/8Ik72EgIHCsa/ZG1UPckPj7lM5W05xH1xWPBCwV?=
 =?us-ascii?Q?Qe5N3SaezISKQOK6kJ6UmfBD37BUWrHFCwU9aDpFHwYermcU0etCfVbQv34y?=
 =?us-ascii?Q?OjRyZbWqOjHkd2LEJ9Zt546BhTEKEQYn4rVAyGK5Yga0PYtMxsimIyqL1Zr0?=
 =?us-ascii?Q?2QjPkqlxXIosOYc57m/2X54CTLkGck+JJv+TrprErJ8V3Kpz323qlEGOkm0y?=
 =?us-ascii?Q?WBwySqGFqp6/KzyZZIQpV887OeGPqwsSj39HRORi4r7kxvo3yOTtKjt6WV/+?=
 =?us-ascii?Q?XYxUtrpZ6RxHykYlBTQ=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cf764f7-a2e0-467d-26a3-08dc104c5a56
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2024 13:18:50.0863
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VIllbjkq9USLBvXFmFJZvzOXvDdCr8BGePN3NnmkBC+s393yA5V4khh4g3FK0WZg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8349

On Mon, Jan 08, 2024 at 11:04:47AM +0000, Catalin Marinas wrote:

> If we want to keep this decision strictly in user space, we can do it
> with some ioctl(). The downside is that the host kernel now puts more
> trust in the user VMM, so my preference would be to keep this in the
> vfio driver. Or we can do both, vfio-pci allows the relaxation, the VMM
> tells KVM to go for a more relaxed stage 2 via an ioctl().

What is the point? We'd need a use case for why the VMM should have
the ability to create a more restrictive MMIO mapping.

I can't think of one.

So I'd go the other way, if someday we find out we need more
restrictive then the VMM should ask for more restrictive (not weirdly
ask for less restrictive)

Jason


