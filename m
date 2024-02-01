Return-Path: <kvm+bounces-7709-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B3F22845995
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 15:05:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 17CA2B221B7
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 14:05:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7AF75D491;
	Thu,  1 Feb 2024 14:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=opensynergy.com header.i=@opensynergy.com header.b="HVu+OFmk"
X-Original-To: kvm@vger.kernel.org
Received: from repost01.tmes.trendmicro.eu (repost01.tmes.trendmicro.eu [18.185.115.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3BCE5D46C
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 14:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=18.185.115.119
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706796290; cv=fail; b=uO4IaElmf6NgU22hrX41lDRxMC15b5wdg9nnJEpKNPlg4E9NEWtdawU8X8gM/xR10zwoi2TdZlfljVFHzLkeT1zyfmckNJZW5V4JB7r6X6XzfVwbB9CjoGlUC2L7fM00ELmlnYjjQpBOXG8iJfjUxZBayDlRR8yri5mHDmBGZts=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706796290; c=relaxed/simple;
	bh=SDZrXyNltPZLAM5MLsLdUxrfnnYXD3dnusMcUNLmxK0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TlXvf7Ikw0uIIld4IVoeA5e6nrDK4b57sLuiAvzgkoOJ+i+yPqMbTMCuECet2g0UKxrClU0uqu7FLZ37Q97TyOU9DIi5FHIc24qSVSY1Gt3hq32RIR2ZamXF0aMLvtOxac3bj0f2MRzwZa6wcU1XanEzxRMD8AvUjetg07WHlUY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=opensynergy.com; spf=pass smtp.mailfrom=opensynergy.com; dkim=pass (2048-bit key) header.d=opensynergy.com header.i=@opensynergy.com header.b=HVu+OFmk; arc=fail smtp.client-ip=18.185.115.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=opensynergy.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensynergy.com
Received: from 104.47.11.169_.trendmicro.com (unknown [172.21.193.99])
	by repost01.tmes.trendmicro.eu (Postfix) with SMTP id 164C310001756;
	Thu,  1 Feb 2024 14:04:47 +0000 (UTC)
X-TM-MAIL-RECEIVED-TIME: 1706796286.003000
X-TM-MAIL-UUID: ee7b7f34-7d0d-4d18-9148-7bf92161c7af
Received: from DEU01-FR2-obe.outbound.protection.outlook.com (unknown [104.47.11.169])
	by repre01.tmes.trendmicro.eu (Trend Micro Email Security) with ESMTPS id 00D2010000407;
	Thu,  1 Feb 2024 14:04:45 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KRiAVn66FjLMuHznQVPk1V1Ocds4b+e9MffwLQVuT6tHce+4IC5yNxE15r0QSy90nixa7ilkBJ3S8KwMIDng0WDpqjU7TtLR9aZH/0c7UARDC8KaAdKv0nrP/xjH7CzOgzEh+CLqTPKnesm6NEHWQLzr2Vz1DpAlb3hNaVzj3JbWy1Hl3NpyZtw8ahieiIxiC7T62iEAL2Ta1neSXCfwDLXUJRLy/1zyJBXtb/BLkT9J1XIuwsHtQbhVuhFMuDk6E8YV+fHz9pD0FDpYL4o6weWQrJfRgogAZolD2ZcnJHB1SNRym891x3bcqTYLC9Bo2uRJWovbr5GB/TbXS356eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8uDEHA8uwt9Ge7JJ4LsVquUfMQKxBmI8FTI23ZOJyPk=;
 b=WwJkAkEs500319e2X9TtBC+An8YHveJwGJqBRiByIZ7lLaQmmZEga58jFapNNIHx98pz+FCQLgf1S5oQXDb2WnRX/5yMbVIipPAdq+Kpb4aPgBBQVJDp6hcIWMzVevGKf9DDAkJhnU3JARCg57wXU/jou/44CbJiJCtNmB2DE4X0+//x7DdQQAEDr3cLHLuqgk3FA3nLjhUs/325Aj95e7va37MPXoGA54kYF3OTEhN3ZL3F4sxTeQAblJR1mKlJMviTKvN9TOT4ayT2rQjalHUjNuxGESoJ6gWC8AhUflpJplFVA2qTIrq0Dm72PG6+p8dPxpeY3QJLnMohSixeJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=opensynergy.com; dmarc=pass action=none
 header.from=opensynergy.com; dkim=pass header.d=opensynergy.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=opensynergy.com;
Message-ID: <afbd30fb-929e-4d17-97cd-e0456fe99f34@opensynergy.com>
Date: Thu, 1 Feb 2024 15:04:43 +0100
Subject: Re: [PATCH v3 5/8] ptp/kvm, arm_arch_timer: Set
 system_counterval_t.cs_id to constant
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>
Cc: linux-kernel@vger.kernel.org,
 "D, Lakshmi Sowjanya" <lakshmi.sowjanya.d@intel.com>,
 Thomas Gleixner <tglx@linutronix.de>, jstultz@google.com,
 giometti@enneenne.com, corbet@lwn.net, "Dong, Eddie" <eddie.dong@intel.com>,
 "Hall, Christopher S" <christopher.s.hall@intel.com>,
 Simon Horman <horms@kernel.org>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 linux-arm-kernel@lists.infradead.org, Sean Christopherson
 <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Wanpeng Li <wanpengli@tencent.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Mark Rutland <mark.rutland@arm.com>,
 Daniel Lezcano <daniel.lezcano@linaro.org>,
 Richard Cochran <richardcochran@gmail.com>, kvm@vger.kernel.org,
 netdev@vger.kernel.org
References: <20240201010453.2212371-1-peter.hilber@opensynergy.com>
 <20240201010453.2212371-6-peter.hilber@opensynergy.com>
 <86jzno70ma.wl-maz@kernel.org>
From: Peter Hilber <peter.hilber@opensynergy.com>
Autocrypt: addr=peter.hilber@opensynergy.com; keydata=
 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
In-Reply-To: <86jzno70ma.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0090.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::15) To BEZP281MB3267.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:77::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BEZP281MB3267:EE_|BE1P281MB2449:EE_
X-MS-Office365-Filtering-Correlation-Id: a1ff9bc0-fb6b-4f6a-bcd1-08dc232ebe56
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	hNoNwMoyNybmzrZkXur+P8xJT7kGk1r3VJw5mO0dhsvrcnjiopofZsayHdTN93epS3ma2fxksXCSg96jUsK9CbNMILQ8HyaC0PPU08ZU7uORytzn8otp+oiarCfDeTxMOsegy/NcMsENqFUWQoNdlXshoRueKTTW9j2KZCyIh/VF2P0/tg+WwWs7Xgdtb45Hqs+718MTAzSFYAuUxtQgXh4REKxfv7XZMr436b0jhtmalLtnJuRw/lEAUsJp5+WBIdHxW1Xtl1vnqWKkv219I1zLkJ90ITFunzbUqGFBVBLOFpcPp8NvJx3se52AyWi+QnMHYdtpmV0MdUhDUuTmVNOKYg/hVVaEQq47uUT488IWl+hFF4EzWAXeEP1Xtkect19fM0zOo0cVwwOVzKh8iTf6EwHkaHxEfNfWZZlcI+1LvYHqkZJblB2CUaD8W62FoeFUgM0lk3q4pU20Su1i4c5eVxJ0AcxbkuBeTFg3/1Xsgh8nJmI1L4pJl7Of81KAQW1UmHH9gYeQiCR0oBfkF06wBajfH7GTa43ix7P9oGS09p0uFSpeNHFG0vCZb5Gw
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BEZP281MB3267.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(346002)(39850400004)(376002)(366004)(230922051799003)(451199024)(186009)(64100799003)(1800799012)(7416002)(2906002)(4744005)(44832011)(5660300002)(86362001)(36756003)(31696002)(38100700002)(478600001)(53546011)(2616005)(41300700001)(83380400001)(26005)(8676002)(316002)(8936002)(4326008)(66946007)(66556008)(42186006)(6916009)(66476007)(54906003)(31686004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K3VQUmthakdRaFA2aTZpUzdzMk01d1dwaklzUncvdzBuK0k5eHNMamJNZ1Zn?=
 =?utf-8?B?WDc4djRmZmlMMVloRFpxVjBqdGVBYVNyUlVJOFBxWmVzZzMzcEZrZm1WbWhn?=
 =?utf-8?B?ZnJCWWtkQWVLUTkvS21xUmtudzNKaDJrQzFtNEpxVmlaeDIyVUdOK016Q1da?=
 =?utf-8?B?MEJTenovRS96REdJekhqSmE0bnF5N1Y2cEpiNzQ4VzBHUkY4a0dTRUVpZ0or?=
 =?utf-8?B?QnZWZGxtRllUYWM3QmNxV09YSFg2WjA3anI3NGFtNWxjT1NWbEtXUkhsTStY?=
 =?utf-8?B?THEybG91c3UxMjZnd0VTMGdxakVuN08vcW5kTTRGNG1WWW1IMHcrOUh6SEhB?=
 =?utf-8?B?TnBBZmxQMmJNRTZZNGM4dlhlQ2lSNWMzc0wxd3pIUDVOMVo1eUIzY3NJZ0FX?=
 =?utf-8?B?QUc0SzAxZkxhak91dkZvRU9rQWFCOStHR3NKL2dsZHZIMHNCNEozTHNrUkpx?=
 =?utf-8?B?cUJScFVpMTlUZjZYZGc5WFduSkZSY2JyZkdmRi9QRDFKWWJGYnkxN0ZDSkhj?=
 =?utf-8?B?cWhtMmpPNy9SMnc4VkFCRE42TXc1NWNZQ0cwVGFZKy9WVWVZaFFWWjJsaXlz?=
 =?utf-8?B?bWtxRDVKUUVaVk96MXJPZ1VkQnJXRHBJT0hoLzB3OEc3MWliLytEeCtSdlNL?=
 =?utf-8?B?TmVRdzR0eC9XN0QzSXEyRUg3VHVyd2RtY1VJVmpGallralMwRm1rbjJkbVZp?=
 =?utf-8?B?RC9UUUk3OHRHdzc3YzlpaHZFVDdleVFlNS9RZ2NmYWZBRzhGTmV0aFdCakhF?=
 =?utf-8?B?b29jVGJHdUlteExtOGZsQW9VRm16RmxxOG4yYnlRdzVEeUhxZ2gwam9PYjcz?=
 =?utf-8?B?cC9sRm9BT0lqL3A4Z0NLVTdqbmhyUW1UMzhnSHpWUVJRKzhIZzlkVGNwK1da?=
 =?utf-8?B?ZFdIVzVVVisvYWhnRUVrbGIycUJUMnQwaVMyQURNVUR4R3ZMaHpKek43aHZK?=
 =?utf-8?B?Ly9RejlZWVpjRFYrbzlQTllTcHdVVkIzWVZ3Zld2dDVIL3N3L3Nrbm5pUG03?=
 =?utf-8?B?OVNiTVB4NUNaQTVNMGFNZm1ZYkpqK0YrM1FuVXhLMW9tZDRRRUV2VEZyMjRQ?=
 =?utf-8?B?M3Rhd01nQXRmZkNmV1d0bEliZGxBSHlDaXg5eWpGTWovNEdTTVNqVk04aDc4?=
 =?utf-8?B?cWIxclNsbGwxL0N0WHBzYXFyTy9FOEY1UERlQUVsanUrZDk3cDkxelZ2VXFD?=
 =?utf-8?B?alRHVEVOd1dLakM1djJ1UzFzOFBpZVZnRjdQcEVpbHhrS01LektoUHp3ZXpn?=
 =?utf-8?B?dmJFWUxYOVMvKzNldTFoVFhTTnpnZ29scFVTWThuZEVkUjJaU2kzcFd6YmtH?=
 =?utf-8?B?bkVDK2V5aUMySHhOWmxrTTBEOEpxRFRGQWRlKzZsTUZ2bzhqUTdKd3Bsdjgy?=
 =?utf-8?B?VHc0dXVHZEkwd0xMOHd0Rno5RmZCTml0RjRjQ3lnc3hZUVdMblV5dVZhZWhK?=
 =?utf-8?B?TUlOYnZQdkQvZGVNNThCMWxuajZoc3NURHRPS3Y0bm9OczFRNlpHdXdQNWRa?=
 =?utf-8?B?MEN5VkNGTEJ5RVBWNHA3KzNDS0JhTFlkMTYzeEpISWdqTlZLdjVmZDVDay9m?=
 =?utf-8?B?SHZVOGIrRFBoTmtOT2lDUTIvd1RjNWdZQkE1VWFqRW9KSlpvOFYyTW9xeld1?=
 =?utf-8?B?bzcwcnBqOElzMVFIalNvM3N3SjZpcXR5eGNOVkwwV29sVUxXSk5RQm40cDVy?=
 =?utf-8?B?aUN1YTZiNkV4aGFEUklmZG9FaTJLc3NYL3VLQklsaTBZVk02UlJIZnlaM0FL?=
 =?utf-8?B?R0d4T2h5RmRLVkJONHU2SEM1V20xaU9qY3c1M2IybUdLT0grdnFSTHVIbWtw?=
 =?utf-8?B?RkFzU1N1WU42bjlpekFKNnVwR01veVJ6WEoxYVNYbHBXcGpjc1lrSkZteldv?=
 =?utf-8?B?TDJwQ0liM3VrcnF5by8vSkl2elhKWnRMMjQ3VGlUTk84L01oSGxwakdSZTN4?=
 =?utf-8?B?WTFYRk8rYU52anpnc2pSdFI0VE56SjNuNWR6aVNHZzU1NkJYRHE1byswcEtz?=
 =?utf-8?B?WHZyUTJSYmpwNjBrUmVQZjArK21wU1FCb0YyYnBpb2RpVHlBYnpVSjJwYnRk?=
 =?utf-8?B?d0Y4TnhtVFlnWkFZbkRmVlNEdWlhRllSWCs1NTdrbHBXSUVwMWNHMHlxM05F?=
 =?utf-8?Q?Qv4bUAj/1IBYDaUsWtwxi0JEO?=
X-OriginatorOrg: opensynergy.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1ff9bc0-fb6b-4f6a-bcd1-08dc232ebe56
X-MS-Exchange-CrossTenant-AuthSource: BEZP281MB3267.DEUP281.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2024 14:04:45.0456
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 800fae25-9b1b-4edc-993d-c939c4e84a64
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AuY7U5SQo1dUfkUaEdt5MlTs2iYTLdoUxkiZx8j2zIWw8njwUHFP18LuhYo8uKMKl/+ERBy+sqP9YELiJV+IOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BE1P281MB2449
X-TM-AS-ERS: 104.47.11.169-0.0.0.0
X-TMASE-Version: StarCloud-1.3-9.1.1015-28156.002
X-TMASE-Result: 10--10.735900-4.000000
X-TMASE-MatchedRID: O/y65JfDwwsqXRK86+Icjgw4DIWv1jSVpolXqDXvwwqiMrI1WZc6u8DR
	RXCPbN1l+7XHtnlUOV9bqCzJ1PS/4sLotj7n0KJrLrzngQuTvvRR3UkpERYmZPsFqaKfjkncsNG
	beSbzWLnK+vpUwOjuKDDfSGFUeim/x10k8QqyoAwRLjqoJJt/9ZlRCkgBbO6Xvw9+amN5XW5aOx
	pgjiWHdd/upPexrMg4FdG/gF5eRE95SL8zubJzD7v4N5FegD9UAlSn9/KWSNc1R5o6+NZ3vg==
X-TMASE-XGENCLOUD: 091414d5-8e9a-45c0-ac83-fc92969e73ce-0-0-200-0
X-TM-Deliver-Signature: D5145814807AC387D029CF1BF50CC911
X-TM-Addin-Auth: PpRDtacuogoWZ00a6pEZVZVXI1BLedX9MVZzRxLYTAgVa9GeKL/GMo06YHw
	Vx0D20NHcRW7RQQV/dtsKg0qbVam9081WTkug0LVFY/eYndVRLx07+E90R/0C0r47gezeAVckK7
	nw2l3lMbznHM279G1fH1I+e0ecNFxFICfN3YAi7GicOD+VrZOgFgATGtbCzCu0RNxl+JdKv5hqz
	yFRE9671sx5b2z4LrDsHaC1+l7h9GiN7mIl7B/ZMo4+cfJA1vnMmnlCHLsQsL4pAZuqfNOBHkVB
	fByRG6IjbPS6+uY=.BCzl0ULLBhLUZG6fX0KHcXBspjPdyfHxEmzndjMidRmVdf+pCXMtMNO1tv
	6hpqViEDyYx6YiR2LXuL7Z/uFnVlzztNnbcA9hTHkACtS+JLLV1ihWCM9E9Jx4P19vkp+5tMHtE
	N3jC0RZo7OdpAa2jbgohHjXMGBPToOo+wjvUrBgisW3KvL9GNckZCwq/tFljtuO9xHlldvQZYqC
	r7t1SFVXLX6+ZBoA4ehzXghJ7NMz4tYhTMoixopQ9KeZzIwAeBBeOFISZHO7Rq9JoqKAcMZw0n8
	3lhaXIZRlz0FFVtisP0OUCt2sP0puXlu1/k/ie7xy4lKFHrBcdfJTTZYppA==
X-TM-Addin-ProductCode: EMS
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=opensynergy.com;
	s=TM-DKIM-20210503141657; t=1706796286;
	bh=SDZrXyNltPZLAM5MLsLdUxrfnnYXD3dnusMcUNLmxK0=; l=953;
	h=Date:To:From;
	b=HVu+OFmkA37wQoJXz5vc5KqgA6OoPD6LzR5xjzAh5B5tZBWwDjvrFKT2ymkL+46OM
	 EGPl0oCqYvE1062Fd6xLsm6BjJF3xadOxucY+RiY8LQluPxtnFe7bhuRbEGxMeSaKM
	 wsA4EuYsi95E4dakRstzWcntMPTKKt1J3livBlOzbuPxkErSmy9KjEJOCKQn6iumWL
	 eDCaws25tLOYmwO21C/c+xAt6iC6LkVnm512lTgL5qfFZ0ygrArRXPY+XqKZ6SpTCA
	 BQwo8ptSXSSP/hUDd0SfBd29GGxWij2TBsF8/soTokdcK1vVnfg+cF9tjjY9wPuRd4
	 8nrFp4s2o/3iA==

On 01.02.24 14:52, Marc Zyngier wrote:
> On Thu, 01 Feb 2024 01:04:50 +0000,
> Peter Hilber <peter.hilber@opensynergy.com> wrote:
>>
>> Identify the clocksources used by ptp_kvm by setting clocksource ID enum
>> constants. This avoids dereferencing struct clocksource. Once the
>> system_counterval_t.cs member will be removed, this will also avoid the
>> need to obtain clocksource pointers from kvm_arch_ptp_get_crosststamp().
>>
>> The clocksource IDs are associated to timestamps requested from the KVM
>> hypervisor, so the proper clocksource ID is known at the ptp_kvm request
>> site.
>>
>> While at it, also rectify the ptp_kvm_get_time_fn() ret type.
> 
> Not sure what is wrong with that return type, but this patch doesn't
> seem to affect it.
> 

I meant to refer to the type of the variable ret declared in
ptp_kvm_get_time_fn(). I will reword the commit message to make this clear.

Thanks for the comment,

Peter

