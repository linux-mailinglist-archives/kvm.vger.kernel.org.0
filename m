Return-Path: <kvm+bounces-68915-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aHYNLR9bcmn5iwAAu9opvQ
	(envelope-from <kvm+bounces-68915-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 18:15:11 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EFD7B6AFA2
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 18:15:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C4A50301F7BB
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 17:09:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE7E736BCE6;
	Thu, 22 Jan 2026 16:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="HnETWPsP";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="HnETWPsP"
X-Original-To: kvm@vger.kernel.org
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013061.outbound.protection.outlook.com [40.107.162.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371E32F5A06
	for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 16:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.61
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769100415; cv=fail; b=IF8AsjuNxKsz7DCOf9vuXLT/F7fSWjVF333R+BKVWg7yMxA3JqsIsWJA6nlyYseKRqqjYfOwtjwZF+JXIiSHNEvTa7Om017TPexIbs6yit1DFG9Xpf99hcE1B0Iyhu5BD2F3seVGH8hT6ljEN18DJCUzYxo+xEm7Tf1P2aQbAOg=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769100415; c=relaxed/simple;
	bh=BeiFQ3bBnLh077jUV9sZjg6hSs0vVztm9DoIb3YOc+g=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=D5+ETbPtl/sFmxIAQ5hZJtBqTLqTA5z8SmykTotW0+vg7VbPTxwb4YAHB+Tdbm/ni5t6KqOiDqKj2v54syuvFBAWi8opnhVF8eS2uWYSMte0vWU7pjdAqYM5YRR/0H3h8LiZIt8u4sqXTtXkYmzjFszsL2R8BoBzQdMZAT/x4bE=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=HnETWPsP; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=HnETWPsP; arc=fail smtp.client-ip=40.107.162.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=RgPgdHjOIKwEr6TtFCKHH5kpVz0s/yEBDaSRSCvR7GNOvfY1jp0MNThFqHJL0uzjEZX2aLWsHGRLHrIkig3NurWaFrKZSImmjAOC+HcnAvCEzuo2Q4juqNEMyAFsms27G+b5YxdT4l14Aq673fWlIIivQNrQIOGXC75wd7CAmg5z9pnWVBkaRD5iZTRHOXLrk303iIoD6SVaOXZ4qOt5f6GHr5wh6Is7+jhRe8Yblrv6yBhaONlyybMMevHL53c5DuCpHLMb0dujrjrEuzLV73phtHkkxkgcqf1ZnxHUd9zuGA6wMt9ljtt+N7AiKvp9o6T90eBOobMDqk9ScfAHkQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BeiFQ3bBnLh077jUV9sZjg6hSs0vVztm9DoIb3YOc+g=;
 b=J1D7/j3NUW2naaglOTvo43cZdzmDx2ZyRsFsewbjokrX+PSLS9Mom8Jwqlo3XsTrRv/X3txxwE55x6Pt78M+7zXC7fwq0wWVLpScR3JPPf2tQvTq3SeG/gzkwZjaoJeOpH1yoRbX7KxiBADF38FHcFs7gW2PNifRTbQPS+TzagxYhdBNl22Y+cGgTXTCo/I/camcgkJ9Gz4yODH1e+iQlu1OIeeZ9A4Qkszo+1mdRbEgIdUsqesHTenAbqFQ4aEg+PwsuxNTTpaRjYJHDnU0Bi8iRGfpotQxbsjaNVO14uvSmIY1Q2p/zBF94XCz33qo1Jx6BIEWF7ct61i1uluEYA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BeiFQ3bBnLh077jUV9sZjg6hSs0vVztm9DoIb3YOc+g=;
 b=HnETWPsPKDHhTCi1vfYsD6MAqzT+bPeTlyoQFAE+lJ16usA59MwS7Ithe5u2Nm4GdmIJpEvMx8Q8lTm/QTA8XWDj/ehUmi91U51Ye4uhlQB0TYrpRwnOS0mNm/9GFBUijBuyuiQNFywmy7Fc5KlC5a19vFwwVTJVmnIWL0ndFvc=
Received: from DU2PR04CA0162.eurprd04.prod.outlook.com (2603:10a6:10:2b0::17)
 by PAWPR08MB10284.eurprd08.prod.outlook.com (2603:10a6:102:369::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.10; Thu, 22 Jan
 2026 16:46:38 +0000
Received: from DU6PEPF0000A7DF.eurprd02.prod.outlook.com
 (2603:10a6:10:2b0:cafe::27) by DU2PR04CA0162.outlook.office365.com
 (2603:10a6:10:2b0::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.10 via Frontend Transport; Thu,
 22 Jan 2026 16:46:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF0000A7DF.mail.protection.outlook.com (10.167.8.36) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.3 via
 Frontend Transport; Thu, 22 Jan 2026 16:46:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ib7SIGSNx9OKkIsSXc3bcFMPIB5+ogeWlgdGmr082YNxTmHf7QnpKWMKXH20W+ifKyja3APpCwMMDOUeKXwWlB5OOhWbJ3UvodNc6Q/3lkQS/fgnk5T7Ykxbv2ql0W9iKTWjgDKmQJImYh5CKHzka0aSbI69Cvz/ch2KeCDaO8ZK7FS5rNpZqV2Cgz3mZCjIoS793DQaU3LhCSelEb+fdmliCetDupFVZhTd9TUPlFuY3KrgSCKhHckOXIc6lmi+1L0qbCr5tpe1RFZlnmSgk04aKsn4EKOkcLObZ5w8vwg1hkHBmtL6/Q8VpmoRzd1T1FLQRkxuLjNcZEoMQat9QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BeiFQ3bBnLh077jUV9sZjg6hSs0vVztm9DoIb3YOc+g=;
 b=T8vm51pYurusuo4hGnMw+nKHa8vGvwkOaEiFikuyllTX/iZE4WkXnRFLVSoKO8FHvCi5dXgYkzQ95aYbyQJNFT4FKpSwa2qkUPjSJz9ipV5thucn2vEW2+A8mp65RDbxCyCQ5/meI2czG0qpv4lZX6OFQoQbnj/c00MjN78wULuTxU/XT/cRoYbrmNjlw1ok772yya0bjtIJuKJr2fjRVGvajwyOcxuxusyL3JmBzrhGhzVfYAbo8XwM0xUUyXbXUgVxPvYIz3jQUBevZZXaB3RM1hb7tSM3wGgrNNmv32YjQh0prJnpgjrl0rdyHMnUtJJt2tVNQLGCMVPCBK7nog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BeiFQ3bBnLh077jUV9sZjg6hSs0vVztm9DoIb3YOc+g=;
 b=HnETWPsPKDHhTCi1vfYsD6MAqzT+bPeTlyoQFAE+lJ16usA59MwS7Ithe5u2Nm4GdmIJpEvMx8Q8lTm/QTA8XWDj/ehUmi91U51Ye4uhlQB0TYrpRwnOS0mNm/9GFBUijBuyuiQNFywmy7Fc5KlC5a19vFwwVTJVmnIWL0ndFvc=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by DBAPR08MB5656.eurprd08.prod.outlook.com (2603:10a6:10:1a2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Thu, 22 Jan
 2026 16:45:34 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9542.008; Thu, 22 Jan 2026
 16:45:34 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: Andre Przywara <Andre.Przywara@arm.com>, "will@kernel.org"
	<will@kernel.org>, "julien.thierry.kdev@gmail.com"
	<julien.thierry.kdev@gmail.com>
CC: "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	Alexandru Elisei <Alexandru.Elisei@arm.com>, nd <nd@arm.com>
Subject: Re: [PATCH kvmtool v4 3/7] arm64: nested: Add support for setting
 maintenance IRQ
Thread-Topic: [PATCH kvmtool v4 3/7] arm64: nested: Add support for setting
 maintenance IRQ
Thread-Index: AQHcg6rlZrYu4QboQ02LT26IdoPyCrVVH14AgAlIDgCAAA5MAA==
Date: Thu, 22 Jan 2026 16:45:34 +0000
Message-ID: <cc8ed4098ae28258c96e14e1ff608e61207dcd55.camel@arm.com>
References: <20250924134511.4109935-1-andre.przywara@arm.com>
	 <20250924134511.4109935-4-andre.przywara@arm.com>
	 <3d2a364595956d06624102684418bdad2a9d20b6.camel@arm.com>
	 <a8e44aea-89a3-40d0-82e8-295d5f315065@arm.com>
In-Reply-To: <a8e44aea-89a3-40d0-82e8-295d5f315065@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS8PR08MB6744:EE_|DBAPR08MB5656:EE_|DU6PEPF0000A7DF:EE_|PAWPR08MB10284:EE_
X-MS-Office365-Filtering-Correlation-Id: 99717c64-af3e-4d3d-b5b0-08de59d5cfa0
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?MVhHaVJyY2c3RG1NamxkQWcrcjNKdDBGT0pjVGVsdDNxaXg2cDJJZVFZRFVo?=
 =?utf-8?B?ZFRaSTdpRHpyVFJSUXhKQ29PMnRDVmhTZTVBSHIzM2kxUmpEMldpSVQ4cnpv?=
 =?utf-8?B?NEJQTkRNcFNzUmtWN0tTYmhVT3VkeHl3QnJVWlBaUWRYUkR1UXIxS1lRWjdh?=
 =?utf-8?B?MFJFcjRYbGwxRXBSaVBnOCtVOEFsN2dCOG15ZXRXVGtudksxUmczeG0rNDNl?=
 =?utf-8?B?UlR5bmd1c1l5eDZpa244NnREM0s0SHYxb2dJdkIwRVQyZStiTkJMdnZPNUQ0?=
 =?utf-8?B?OHFGai9iTmZ0OXdES3hKOUpHU1hrcnRHVWtkT0VrNkJyUXREV1pmaHdwTlJq?=
 =?utf-8?B?VlpKZzFRMFJzdVFvR3B0aTZQMm5DV1JZOElGOU5VbDJuaXhjQUxVL0RCeXhF?=
 =?utf-8?B?V1FJQUErZkhEY2dnVlRmMXRpWWtHMGVjT2VON2tiN3ZHaTlnMDA4bk4zaVB1?=
 =?utf-8?B?bHdmbXRXT2xKN05hajhmT1Bsai9oSC81cmV1emxSTnNVdUlRdFdKblJ2dTBW?=
 =?utf-8?B?eHU3a1JVYlV3Zlg5YlFtZTFIY0RWTURJZzBvaHdzbTFmS1Z0VHc1ZDk1L0tK?=
 =?utf-8?B?Ujd3aGFkcTNlTElXNGVjb1pQNFM0RVNBWDkwamhSajIraXhjMVBua21hYTJr?=
 =?utf-8?B?cDFaaGdlcE1DK2dQQ3ZiT2VEYk5JRWxjQmdCMDQ4WENYOTkyY3ZwdmdJK0pS?=
 =?utf-8?B?bExPaXY1M0UwWERoeUxhdjBXWTc0OEFBbmd4ZWF0UzdGTnRDemZxT2s2Y3Bl?=
 =?utf-8?B?YzBUNzF4UTBlQ0hXRklpV3hrSjFWeTZsblU2VGthV0xyRGtoU3NaL3N3dFBh?=
 =?utf-8?B?eUUzcUdtb0taMzFwazEzLzVwR1BOclFjaVNaMFV0T3VsR04rSzhheDIzZlJi?=
 =?utf-8?B?dVA3dDBEWFV3bmNZRGtRNHpQeHZpdjE2RFpLVmwzNnNvaVkwaG82NzJabEZP?=
 =?utf-8?B?bW5TeTJFYlpnV1Vjc2YwdFNwb092L29vWDJUWDJ5REg2RzVoUUFiVUNiTjNy?=
 =?utf-8?B?bFBNYUZJK0pkUHB1L3M5SnQ3eXRrU1Y5WmxzcUJXWXBpSnZwZ0t5aUp6T3Jr?=
 =?utf-8?B?L0ZIaldWbGc2YlUrWXVlWU8xUkpQVUNvY0YyQ0lEbGttVG1GYS8wdnBrL1lL?=
 =?utf-8?B?SHVZejZtS1djSEdvQ1dGZGo3bEJkdFE5MlE5SE9rT1lUL2ZDTG5yMklRYWlE?=
 =?utf-8?B?Sk5nMlByRXhTd2FMWlNRYnJnSU1OV0p2ZTVRNlUxRVp6Rk1tRmdUUXlobUNN?=
 =?utf-8?B?VmpPV3dWZ0tCZ2Y3YUhaejlkUnBPcGhHMjVkelYwWTBrVmphaUUxNWtUN0ZH?=
 =?utf-8?B?V3JlMFZWR0VSdGZmT0ZBUWxiUXROU2lOYW9DeTQ2NWFBb203SXRBS1I5SFRn?=
 =?utf-8?B?bDlqZmVHUDRBZGRrSkZwVDRVQVQ2VGc4SEtITDZGNXR5NkV6V0NDaG95N1Fz?=
 =?utf-8?B?ei94WkptN2RRb1VXM0JNd2lDZkhncG4zQWRud0xUb2NWekhjbDlhSnBoNGRW?=
 =?utf-8?B?dDFaU3ZuSGkrUXFwMm9ZNEY2VzVxUE4vSmFURkZ2S0dRUlQya28zQlBOOC9E?=
 =?utf-8?B?ckJuRkI5TSt1Q0FpcFRMeFhoSDBWK0lIaUxRVmY2TVFZcEdpSzZhWk1xNjFR?=
 =?utf-8?B?ZzBQWGV5TllqcHY5UHlrVWU0WWNzTGk5bHZYRUtKWmh4RjVBanU5aHJ3OGc3?=
 =?utf-8?B?YUR6aEVpTGcwbER1UCs2bGZGektjYnpDbklsZnJFWUFzamlDcGRlQmQvMW5u?=
 =?utf-8?B?THZkK2ZDcTVoS3g0NkZHaVdZaFFSaUZsdXF6ZDFjdEJNWTQvcjNLenZiWm1K?=
 =?utf-8?B?WXpRY3UrVTdUTGpEbVF4ZDVPUHVXQjM1NlZoUTg3M2RPMktCd1J0Sk5Ma1JH?=
 =?utf-8?B?ZXZNOTFGN3RhZXY1NW1aa2ZrNERSazBUakhGeHBFSmVUcWpsT2I3b2dzcXdI?=
 =?utf-8?B?eG9QNzJhYVR5eXNxYVZKQi9PdTRuZW02YUlONW1IdjhOdkszR0ZqbFRvZUJN?=
 =?utf-8?B?M2ViclkyRXlVQnY3Y0M1Mm5IalplZTVmVGdDUWpoNGJFNEJvcWV6UWk3RlpF?=
 =?utf-8?B?NWhadXhoWTBCODRvUlZ1STNzSm56WmRzaGNhSkNqeTBHTTNzVFNmOWF3bmdX?=
 =?utf-8?B?TUdOaDhsTGYvbVV3dkR4UXlPM0JwWGxOMlA0MTU4ZGxXT21qTFErMWdZNjdq?=
 =?utf-8?Q?wgRW4sVaoGCTUEJ9Tsg1xDM=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <B8B14EA459634C4DA4CC21AE196B6D7A@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR08MB5656
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF0000A7DF.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	e8f99681-6032-4a0a-2f6c-08de59d5a9e6
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|376014|82310400026|14060799003|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RW41UCtLMVVqNlROL08zZkxWOVphcnJxVHViSGNTdHVIWVpWUnIzNTJNNWlk?=
 =?utf-8?B?L204MStUY2JRVjhsQ0J6bG9MSWJNbmhFbFA2R1J0N0lXcWV0RFZBdGxvN1dO?=
 =?utf-8?B?L012UlF0VXA5OGlsSkozZm9HUUEweTJ3bnB6aFZqUnZ5UElhc0M0MDZlS3J3?=
 =?utf-8?B?VE1tSncvcFphWUQxYTVxSWxwMEh3Y25wTHdaZzkrcVRBaTBLSkFpckxETXFF?=
 =?utf-8?B?SG1IQ3NpTFdQeVJsZC9TbWl4cWt3MFhzRHNYdGU1L0VUZkhqSUl5OVRnSjVr?=
 =?utf-8?B?M0dXb0wySTI4YjloVWJBUG5NaWNyS2IrcGo0QkhzYU05bnhwZjRkLy9IQUVs?=
 =?utf-8?B?VnRjYzJGZ2VESzkxdVJKcVdhMmllTGtTeXpuWmx4Y3lDZFAvVng3Zks0Qm9C?=
 =?utf-8?B?bGRTa2FjL24yd3BMcnNLa2YydFNpbDY0RGQ4TVRYMjBVdlNFQi9za04wczdN?=
 =?utf-8?B?Y3ZiQ2ZMSTQ5WDU1dGFSL2FGRDVKdjRlcUtRenhDeWhVMW04TnYrdlhYamFn?=
 =?utf-8?B?RDlMQ1RGOFZOMG4rWUNidjFmR1c5M1c2cGNCdHhUTE45akpKUUhJUkxSblU1?=
 =?utf-8?B?b1I3VzV0V1M3cFdaaEY4T1BiUTBqTFVhWUd3NUhucVRsRHIzS1N1WFJlT2lP?=
 =?utf-8?B?ZXIxTFdOWVByKzRhQzlxKzg1cStpVVE4dHU2M05hQzZBM1NXSDdPb0RqUHAw?=
 =?utf-8?B?d1A5MEJBNk5QRDkrQldXNkI1MklXYVdYRFAreEN0Sy9uQS9CSDB3VDNpTmx0?=
 =?utf-8?B?UEhhSmpUdjM5KzYzdlhIWWhjZ2lMdERRUmxpeE5qeGhEdkxBMFVIaS9yTEts?=
 =?utf-8?B?WGZNVWh1cThKajVQZFZ5M0NqdytrRWdFV0dienFId1kxS3dXRHJkS1VhWGRy?=
 =?utf-8?B?RUkvUTFubWlhTVNCRW5EbDZrNGNndG1RcUI4SFdhNWppalJQdHp5cDA1K3BC?=
 =?utf-8?B?VUZibTdpREl0TGlGMVhybzQ2VUZiOE1OcC8wMTJuTkZ0NnR0dFpyRklyZUZh?=
 =?utf-8?B?QWVaZ0VuR0daVjYzY1hKSjlvckM3WVJta0hCQUJCSUpvUUhwNzNSWW50VzFI?=
 =?utf-8?B?cnRncDRzbzNSMVJaS0tZcHRLMy9qalpvbjQvRldxMlNRM3FHdGtpZHFqSi8v?=
 =?utf-8?B?aHVHVVd5dVQ3QUZKZW9lOHV1RkZUcGNKald0NUZCKzU2azRCeGV0TFJ0TVc5?=
 =?utf-8?B?N1lWa1kreHJwdTEwMW1TU1h0d2NuejVYc0R4MFpFcm9RYzlNOWRlWHczSEFC?=
 =?utf-8?B?eGprUk1pVjIzdWhNU1FOdTh3WXdJVWVpcytoQUs1ZnhGWWo3ZmFqOTNhRzZm?=
 =?utf-8?B?d1liNmdEQ200bmROa0krUTBpcnJ4RlpkRUhVU1M3VURQUHc2UUdkd2d3L211?=
 =?utf-8?B?dnpkRVZ0eEJ5QnkwSUJrTE9tOVVHaUlER21nZm8yRUtxNTNhVXd4b21ZUTh4?=
 =?utf-8?B?M21CYjVRSHFlekZJODJ3c1lTMDMwMmZyNWRRRUcrTEdzbVZ4NEpZdjUvcHNZ?=
 =?utf-8?B?UUdTQmpwNXVuMjZCdnY3VG13NDVJU2I3ajZMNzd2bVErN1lZZzk5TnI1S2VM?=
 =?utf-8?B?QTJ5Q09HTEpMUUs5YzNvWjBVSk1BOFc5ajZVeDM3QjhXRGRtVExWMnhUMEZj?=
 =?utf-8?B?QXI1cGRjaS9vejVLKzJObHN3UVpnQzFleTdSRlV0aEQ0SnI1KzlYKzdMMHJ5?=
 =?utf-8?B?UDlTWGRNaUhRV0wwWDhMNXllQ3Q4TEdjUlRsY2p3d3lLemIvZUJmOHFEdllz?=
 =?utf-8?B?azZVYjdPbVVJQ0svOEdPaEQ1a1JPd1NGajNuaGtmWU1oRmFOOEVQbU5QaVZC?=
 =?utf-8?B?NDNaYzVkamxndEg0VmdydWpPeDB6eXBVYWVzVGNoU1lQM2RxNzFuNHRSeXVx?=
 =?utf-8?B?V1poSEZzTVJBQTVaNDJjcmp4a0ZYNjBPRTV6VUNpdno4VitMK2pSRUVrOW0x?=
 =?utf-8?B?L3VZNVBNcEowcW5SSkx2a1lYaDBLNll5cVIvUUNZSUVISFVBUytnK2lZUy9K?=
 =?utf-8?B?NEhnKzJEOGFOaGhOWW44UzYrN1NTckN0WGtZRnRGaVprZGt0bjBzOVNCODZV?=
 =?utf-8?B?OXBZbldaZ2dGK3RaZXZ4WklNY2w0YXR2YW1LRjdJU05NVFhvMW5HVExjVW9T?=
 =?utf-8?B?RHhiYU9OSDc0Z3VKb2M5QVk4MWZQQmJzeDBpSlF5YlozTXlQOWRCeThVNmk3?=
 =?utf-8?B?SHJLWnUzSThwNW4xemF4K1c2QXREUEMxL2p4R3ZGcEdCT0Z2UmpCMXJOQTht?=
 =?utf-8?B?SDNzd3FpRGhpMlIxb3NVV2RFbXZ3PT0=?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(376014)(82310400026)(14060799003)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 16:46:37.8438
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 99717c64-af3e-4d3d-b5b0-08de59d5cfa0
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000A7DF.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB10284
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.44 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-68915-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[arm.com,kernel.org,gmail.com];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,arm.com:email,arm.com:dkim,arm.com:mid];
	DKIM_TRACE(0.00)[arm.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[Sascha.Bischoff@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[8];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: EFD7B6AFA2
X-Rspamd-Action: no action

T24gVGh1LCAyMDI2LTAxLTIyIGF0IDE1OjU0ICswMDAwLCBBbmRyZSBQcnp5d2FyYSB3cm90ZToN
Cj4gSGkgU2FzY2hhLA0KPiANCj4gbWFueSB0aGFua3MgZm9yIGhhdmluZyBhIGxvb2shDQo+IA0K
PiBPbiAxNi8wMS8yMDI2IDE4OjEwLCBTYXNjaGEgQmlzY2hvZmYgd3JvdGU6DQo+ID4gT24gV2Vk
LCAyMDI1LTA5LTI0IGF0IDE0OjQ1ICswMTAwLCBBbmRyZSBQcnp5d2FyYSB3cm90ZToNCj4gPiA+
IFVzZXMgdGhlIG5ldyBWR0lDIEtWTSBkZXZpY2UgYXR0cmlidXRlIHRvIHNldCB0aGUgbWFpbnRl
bmFuY2UNCj4gPiA+IElSUS4NCj4gPiA+IFRoaXMgaXMgZml4ZWQgdG8gdXNlIFBQSSA5LCBhcyBh
IHBsYXRmb3JtIGRlY2lzaW9uIG1hZGUgYnkNCj4gPiA+IGt2bXRvb2wsDQo+ID4gPiBtYXRjaGlu
ZyB0aGUgU0JTQSByZWNvbW1lbmRhdGlvbi4NCj4gPiA+IFVzZSB0aGUgb3Bwb3J0dW5pdHkgdG8g
cGFzcyB0aGUga3ZtIHBvaW50ZXIgdG8NCj4gPiA+IGdpY19fZ2VuZXJhdGVfZmR0X25vZGVzKCks
DQo+ID4gPiBhcyB0aGlzIHNpbXBsaWZpZXMgdGhlIGNhbGwgYW5kIGFsbG93cyB1cyBhY2Nlc3Mg
dG8gdGhlDQo+ID4gPiBuZXN0ZWRfdmlydA0KPiA+ID4gb24NCj4gPiA+IHRoZSB3YXkuDQo+ID4g
PiANCj4gPiA+IFNpZ25lZC1vZmYtYnk6IEFuZHJlIFByenl3YXJhIDxhbmRyZS5wcnp5d2FyYUBh
cm0uY29tPg0KPiA+ID4gLS0tDQo+ID4gPiDCoMKgYXJtNjQvYXJtLWNwdS5jwqDCoMKgwqDCoMKg
wqDCoCB8wqAgMiArLQ0KPiA+ID4gwqDCoGFybTY0L2dpYy5jwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIHwgMjYgKysrKysrKysrKysrKysrKysrKysrKysrLS0NCj4gPiA+IMKgwqBhcm02NC9pbmNs
dWRlL2t2bS9naWMuaCB8wqAgMiArLQ0KPiA+ID4gwqDCoDMgZmlsZXMgY2hhbmdlZCwgMjYgaW5z
ZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkNCj4gPiA+IA0KPiA+ID4gZGlmZiAtLWdpdCBhL2Fy
bTY0L2FybS1jcHUuYyBiL2FybTY0L2FybS1jcHUuYw0KPiA+ID4gaW5kZXggNjliYjJjYjJjLi4w
ODQzYWMwNTEgMTAwNjQ0DQo+ID4gPiAtLS0gYS9hcm02NC9hcm0tY3B1LmMNCj4gPiA+ICsrKyBi
L2FybTY0L2FybS1jcHUuYw0KPiA+ID4gQEAgLTE0LDcgKzE0LDcgQEAgc3RhdGljIHZvaWQgZ2Vu
ZXJhdGVfZmR0X25vZGVzKHZvaWQgKmZkdCwNCj4gPiA+IHN0cnVjdA0KPiA+ID4ga3ZtICprdm0p
DQo+ID4gPiDCoMKgew0KPiA+ID4gwqDCoAlpbnQgdGltZXJfaW50ZXJydXB0c1s0XSA9IHsxMywg
MTQsIDExLCAxMH07DQo+ID4gPiDCoCANCj4gPiA+IC0JZ2ljX19nZW5lcmF0ZV9mZHRfbm9kZXMo
ZmR0LCBrdm0tPmNmZy5hcmNoLmlycWNoaXApOw0KPiA+ID4gKwlnaWNfX2dlbmVyYXRlX2ZkdF9u
b2RlcyhmZHQsIGt2bSk7DQo+ID4gPiDCoMKgCXRpbWVyX19nZW5lcmF0ZV9mZHRfbm9kZXMoZmR0
LCBrdm0sIHRpbWVyX2ludGVycnVwdHMpOw0KPiA+ID4gwqDCoAlwbXVfX2dlbmVyYXRlX2ZkdF9u
b2RlcyhmZHQsIGt2bSk7DQo+ID4gPiDCoMKgfQ0KPiA+ID4gZGlmZiAtLWdpdCBhL2FybTY0L2dp
Yy5jIGIvYXJtNjQvZ2ljLmMNCj4gPiA+IGluZGV4IGIwZDNhMWFiYi4uZTM1OTg2YzA2IDEwMDY0
NA0KPiA+ID4gLS0tIGEvYXJtNjQvZ2ljLmMNCj4gPiA+ICsrKyBiL2FybTY0L2dpYy5jDQo+ID4g
PiBAQCAtMTEsNiArMTEsOCBAQA0KPiA+ID4gwqAgDQo+ID4gPiDCoMKgI2RlZmluZSBJUlFDSElQ
X0dJQyAwDQo+ID4gPiDCoCANCj4gPiA+ICsjZGVmaW5lIEdJQ19NQUlOVF9JUlEJOQ0KPiA+ID4g
Kw0KPiA+ID4gwqDCoHN0YXRpYyBpbnQgZ2ljX2ZkID0gLTE7DQo+ID4gPiDCoMKgc3RhdGljIHU2
NCBnaWNfcmVkaXN0c19iYXNlOw0KPiA+ID4gwqDCoHN0YXRpYyB1NjQgZ2ljX3JlZGlzdHNfc2l6
ZTsNCj4gPiA+IEBAIC0zMDIsMTAgKzMwNCwxNSBAQCBzdGF0aWMgaW50IGdpY19faW5pdF9naWMo
c3RydWN0IGt2bSAqa3ZtKQ0KPiA+ID4gwqAgDQo+ID4gPiDCoMKgCWludCBsaW5lcyA9IGlycV9f
Z2V0X25yX2FsbG9jYXRlZF9saW5lcygpOw0KPiA+ID4gwqDCoAl1MzIgbnJfaXJxcyA9IEFMSUdO
KGxpbmVzLCAzMikgKyBHSUNfU1BJX0lSUV9CQVNFOw0KPiA+ID4gKwl1MzIgbWFpbnRfaXJxID0g
R0lDX1BQSV9JUlFfQkFTRSArIEdJQ19NQUlOVF9JUlE7DQo+ID4gPiDCoMKgCXN0cnVjdCBrdm1f
ZGV2aWNlX2F0dHIgbnJfaXJxc19hdHRyID0gew0KPiA+ID4gwqDCoAkJLmdyb3VwCT0gS1ZNX0RF
Vl9BUk1fVkdJQ19HUlBfTlJfSVJRUywNCj4gPiA+IMKgwqAJCS5hZGRyCT0gKHU2NCkodW5zaWdu
ZWQgbG9uZykmbnJfaXJxcywNCj4gPiA+IMKgwqAJfTsNCj4gPiA+ICsJc3RydWN0IGt2bV9kZXZp
Y2VfYXR0ciBtYWludF9pcnFfYXR0ciA9IHsNCj4gPiA+ICsJCS5ncm91cAk9IEtWTV9ERVZfQVJN
X1ZHSUNfR1JQX01BSU5UX0lSUSwNCj4gPiA+ICsJCS5hZGRyCT0gKHU2NCkodW5zaWduZWQgbG9u
ZykmbWFpbnRfaXJxLA0KPiA+ID4gKwl9Ow0KPiA+ID4gwqDCoAlzdHJ1Y3Qga3ZtX2RldmljZV9h
dHRyIHZnaWNfaW5pdF9hdHRyID0gew0KPiA+ID4gwqDCoAkJLmdyb3VwCT0gS1ZNX0RFVl9BUk1f
VkdJQ19HUlBfQ1RSTCwNCj4gPiA+IMKgwqAJCS5hdHRyCT0gS1ZNX0RFVl9BUk1fVkdJQ19DVFJM
X0lOSVQsDQo+ID4gPiBAQCAtMzI1LDYgKzMzMiwxMyBAQCBzdGF0aWMgaW50IGdpY19faW5pdF9n
aWMoc3RydWN0IGt2bSAqa3ZtKQ0KPiA+ID4gwqDCoAkJCXJldHVybiByZXQ7DQo+ID4gPiDCoMKg
CX0NCj4gPiA+IMKgIA0KPiA+ID4gKwlpZiAoa3ZtLT5jZmcuYXJjaC5uZXN0ZWRfdmlydCAmJg0K
PiA+ID4gKwnCoMKgwqAgIWlvY3RsKGdpY19mZCwgS1ZNX0hBU19ERVZJQ0VfQVRUUiwNCj4gPiA+
ICZtYWludF9pcnFfYXR0cikpIHsNCj4gPiA+ICsJCXJldCA9IGlvY3RsKGdpY19mZCwgS1ZNX1NF
VF9ERVZJQ0VfQVRUUiwNCj4gPiA+ICZtYWludF9pcnFfYXR0cik7DQo+ID4gPiArCQlpZiAocmV0
KQ0KPiA+ID4gKwkJCXJldHVybiByZXQ7DQo+ID4gPiArCX0NCj4gPiANCj4gPiBXaXRoIEdJQ3Yz
IGFyZSB0aGluZ3Mgbm90IGEgbGl0dGxlIGJyb2tlbiBpZiB3ZSdyZSB0cnlpbmcgdG8gZG8NCj4g
PiBuZXN0ZWQNCj4gPiBidXQgZG9uJ3QgaGF2ZSB0aGUgYWJpbGl0eSB0byBzZXQgdGhlIG1haW50
IElSUT8gSXQgZmVlbHMgdG8gbWUgYXMNCj4gPiBpZg0KPiA+IGFuIGVycm9yIHNob3VsZCBiZSBy
ZXR1cm5lZCBpZiB0aGUgYXR0ciBkb2Vzbid0IGV4aXN0Lg0KPiANCj4gT0ssIEkgY2hhbmdlZCBp
dCBzbGlnaHRseSB0byByZXR1cm4gYW4gZXJyb3Igbm93IGlmIGVpdGhlciB0aGUgSEFTDQo+IGNh
bGwgDQo+IG9yIHRoZSBTRVQgY2FsbCBmYWlscy4NCg0KSGkgQW5kcmUsDQoNClRoYXQgc291bmQg
cGVyZmVjdCB0byBtZS4gVGhhbmtzIGZvciBkb2luZyB0aGF0IQ0KDQo+IA0KPiA+IEFsc28sIHRo
ZSB3YXkgdGhhdCB0aGUgRkRUIGlzIGdlbmVyYXRlZCBtZWFucyB0aGF0IHdlJ2Qgc3RpbGwNCj4g
PiBnZW5lcmF0ZQ0KPiA+IHRoZSBwcm9wZXJ0eSBmb3IgdGhlIG1haW50IElSUSwgZXZlbiBpZiB3
ZSBjYW4ndCBzZXQgaXQgaGVyZS4NCj4gDQo+IFRoYXQgc2hvdWxkIG5vdyBiZSBzb2x2ZWQgYXV0
b21hdGljYWxseSwgYmVjYXVzZSB0aGUgRFQgYWRkaXRpb24NCj4gZGVwZW5kcyANCj4gb24gLS1u
ZXN0ZWQsIGJ1dCB0aGF0IGZhaWxzIGFib3ZlIG5vdyBpZiB0aGUga2VybmVsIGRvZXNuJ3Qgc3Vw
cG9ydA0KPiB0aGUgDQo+IGRldmljZSBBVFRSLg0KPiANCj4gRG9lcyB0aGF0IHNvdW5kIG9rYXk/
IE9yIGRvIHlvdSB3YW50IG1vcmUgcmVmYWN0b3JpbmcgdG8gbWFrZSB0aGluZ3MgDQo+IG1vcmUg
ZXhwbGljaXQsIHRvIGFjY29tbW9kYXRlIEdJQ3Y1IGJldHRlcj8NCg0KVGhpcyBpcyBmaW5lLCBJ
TU8uIEkgd2FzIG1vc3RseSB0cnlpbmcgdG8gcG9pbnQgb3V0IHRoYXQgd2Ugd2VyZSBzdGlsbA0K
ZW1pdHRpbmcgdGhlIERUIG5vZGUgZXZlbiBpZiB3ZSdkIGZhaWxlZCB0byBzZXQgdXAgYW55dGhp
bmcgZWFybGllci4gQXMNCmxvbmcgYXMgd2Ugbm93IGNhdGNoIHRoZSBIQVMgY2FsbCBmYWlsaW5n
IHRvbywgd2UncmUgYWxsIGdvb2QhDQoNCk9uIHRoZSBHSUN2NSBmcm9udCwgd2UgZG9uJ3QgaGF2
ZSBhbiBNSSBhbnlob3cgZm9yIG5hdGl2ZSBHSUN2NSBndWVzdHMNCihhbmQgdGhlIEdJQ3YzICJs
ZWdhY3kgc3VwcG9ydCIgcmVxdWlyZXMgbm8ga3ZtdG9vbCBjaGFuZ2VzIGFuZA0KKnNob3VsZCog
anVzdCB3b3JrKS4gVGhlIERUIG5vZGVzIGFyZSBzdWZmaWNpZW50bHkgZGlmZmVyZW50IGZvciBH
SUN2NQ0KdGhhdCBJJ3ZlIHNwbGl0IHRob3NlIG91dCwgYW55aG93Lg0KDQpUaGFua3MgYWdhaW4h
DQpTYXNjaGENCg0KPiANCj4gQ2hlZXJzLA0KPiBBbmRyZQ0KPiANCj4gPiANCj4gPiBUaGFua3Ms
DQo+ID4gU2FzY2hhDQo+ID4gDQo+ID4gPiArDQo+ID4gPiDCoMKgCWlycV9fcm91dGluZ19pbml0
KGt2bSk7DQo+ID4gPiDCoCANCj4gPiA+IMKgwqAJaWYgKCFpb2N0bChnaWNfZmQsIEtWTV9IQVNf
REVWSUNFX0FUVFIsDQo+ID4gPiAmdmdpY19pbml0X2F0dHIpKSB7DQo+ID4gPiBAQCAtMzQyLDcg
KzM1Niw3IEBAIHN0YXRpYyBpbnQgZ2ljX19pbml0X2dpYyhzdHJ1Y3Qga3ZtICprdm0pDQo+ID4g
PiDCoMKgfQ0KPiA+ID4gwqDCoGxhdGVfaW5pdChnaWNfX2luaXRfZ2ljKQ0KPiA+ID4gwqAgDQo+
ID4gPiAtdm9pZCBnaWNfX2dlbmVyYXRlX2ZkdF9ub2Rlcyh2b2lkICpmZHQsIGVudW0gaXJxY2hp
cF90eXBlIHR5cGUpDQo+ID4gPiArdm9pZCBnaWNfX2dlbmVyYXRlX2ZkdF9ub2Rlcyh2b2lkICpm
ZHQsIHN0cnVjdCBrdm0gKmt2bSkNCj4gPiA+IMKgwqB7DQo+ID4gPiDCoMKgCWNvbnN0IGNoYXIg
KmNvbXBhdGlibGUsICptc2lfY29tcGF0aWJsZSA9IE5VTEw7DQo+ID4gPiDCoMKgCXU2NCBtc2lf
cHJvcFsyXTsNCj4gPiA+IEBAIC0zNTAsOCArMzY0LDEyIEBAIHZvaWQgZ2ljX19nZW5lcmF0ZV9m
ZHRfbm9kZXModm9pZCAqZmR0LCBlbnVtDQo+ID4gPiBpcnFjaGlwX3R5cGUgdHlwZSkNCj4gPiA+
IMKgwqAJCWNwdV90b19mZHQ2NChBUk1fR0lDX0RJU1RfQkFTRSksDQo+ID4gPiBjcHVfdG9fZmR0
NjQoQVJNX0dJQ19ESVNUX1NJWkUpLA0KPiA+ID4gwqDCoAkJMCwgMCwJCQkJLyogdG8gYmUgZmls
bGVkDQo+ID4gPiAqLw0KPiA+ID4gwqDCoAl9Ow0KPiA+ID4gKwl1MzIgbWFpbnRfaXJxW10gPSB7
DQo+ID4gPiArCQljcHVfdG9fZmR0MzIoR0lDX0ZEVF9JUlFfVFlQRV9QUEkpLA0KPiA+ID4gY3B1
X3RvX2ZkdDMyKEdJQ19NQUlOVF9JUlEpLA0KPiA+ID4gKwkJZ2ljX19nZXRfZmR0X2lycV9jcHVt
YXNrKGt2bSkgfA0KPiA+ID4gSVJRX1RZUEVfTEVWRUxfSElHSA0KPiA+ID4gKwl9Ow0KPiA+ID4g
wqAgDQo+ID4gPiAtCXN3aXRjaCAodHlwZSkgew0KPiA+ID4gKwlzd2l0Y2ggKGt2bS0+Y2ZnLmFy
Y2guaXJxY2hpcCkgew0KPiA+ID4gwqDCoAljYXNlIElSUUNISVBfR0lDVjJNOg0KPiA+ID4gwqDC
oAkJbXNpX2NvbXBhdGlibGUgPSAiYXJtLGdpYy12Mm0tZnJhbWUiOw0KPiA+ID4gwqDCoAkJLyog
ZmFsbC10aHJvdWdoICovDQo+ID4gPiBAQCAtMzc3LDYgKzM5NSwxMCBAQCB2b2lkIGdpY19fZ2Vu
ZXJhdGVfZmR0X25vZGVzKHZvaWQgKmZkdCwgZW51bQ0KPiA+ID4gaXJxY2hpcF90eXBlIHR5cGUp
DQo+ID4gPiDCoMKgCV9GRFQoZmR0X3Byb3BlcnR5X2NlbGwoZmR0LCAiI2ludGVycnVwdC1jZWxs
cyIsDQo+ID4gPiBHSUNfRkRUX0lSUV9OVU1fQ0VMTFMpKTsNCj4gPiA+IMKgwqAJX0ZEVChmZHRf
cHJvcGVydHkoZmR0LCAiaW50ZXJydXB0LWNvbnRyb2xsZXIiLCBOVUxMLA0KPiA+ID4gMCkpOw0K
PiA+ID4gwqDCoAlfRkRUKGZkdF9wcm9wZXJ0eShmZHQsICJyZWciLCByZWdfcHJvcCwNCj4gPiA+
IHNpemVvZihyZWdfcHJvcCkpKTsNCj4gPiA+ICsJaWYgKGt2bS0+Y2ZnLmFyY2gubmVzdGVkX3Zp
cnQpIHsNCj4gPiA+ICsJCV9GRFQoZmR0X3Byb3BlcnR5KGZkdCwgImludGVycnVwdHMiLCBtYWlu
dF9pcnEsDQo+ID4gPiArCQkJCcKgIHNpemVvZihtYWludF9pcnEpKSk7DQo+ID4gPiArCX0NCj4g
PiA+IMKgwqAJX0ZEVChmZHRfcHJvcGVydHlfY2VsbChmZHQsICJwaGFuZGxlIiwgUEhBTkRMRV9H
SUMpKTsNCj4gPiA+IMKgwqAJX0ZEVChmZHRfcHJvcGVydHlfY2VsbChmZHQsICIjYWRkcmVzcy1j
ZWxscyIsIDIpKTsNCj4gPiA+IMKgwqAJX0ZEVChmZHRfcHJvcGVydHlfY2VsbChmZHQsICIjc2l6
ZS1jZWxscyIsIDIpKTsNCj4gPiA+IGRpZmYgLS1naXQgYS9hcm02NC9pbmNsdWRlL2t2bS9naWMu
aCBiL2FybTY0L2luY2x1ZGUva3ZtL2dpYy5oDQo+ID4gPiBpbmRleCBhZDhiY2JmMjEuLjg0OTBj
Y2E2MCAxMDA2NDQNCj4gPiA+IC0tLSBhL2FybTY0L2luY2x1ZGUva3ZtL2dpYy5oDQo+ID4gPiAr
KysgYi9hcm02NC9pbmNsdWRlL2t2bS9naWMuaA0KPiA+ID4gQEAgLTM2LDcgKzM2LDcgQEAgc3Ry
dWN0IGt2bTsNCj4gPiA+IMKgwqBpbnQgZ2ljX19hbGxvY19pcnFudW0odm9pZCk7DQo+ID4gPiDC
oMKgaW50IGdpY19fY3JlYXRlKHN0cnVjdCBrdm0gKmt2bSwgZW51bSBpcnFjaGlwX3R5cGUgdHlw
ZSk7DQo+ID4gPiDCoMKgaW50IGdpY19fY3JlYXRlX2dpY3YybV9mcmFtZShzdHJ1Y3Qga3ZtICpr
dm0sIHU2NA0KPiA+ID4gbXNpX2ZyYW1lX2FkZHIpOw0KPiA+ID4gLXZvaWQgZ2ljX19nZW5lcmF0
ZV9mZHRfbm9kZXModm9pZCAqZmR0LCBlbnVtIGlycWNoaXBfdHlwZSB0eXBlKTsNCj4gPiA+ICt2
b2lkIGdpY19fZ2VuZXJhdGVfZmR0X25vZGVzKHZvaWQgKmZkdCwgc3RydWN0IGt2bSAqa3ZtKTsN
Cj4gPiA+IMKgwqB1MzIgZ2ljX19nZXRfZmR0X2lycV9jcHVtYXNrKHN0cnVjdCBrdm0gKmt2bSk7
DQo+ID4gPiDCoCANCj4gPiA+IMKgwqBpbnQgZ2ljX19hZGRfaXJxZmQoc3RydWN0IGt2bSAqa3Zt
LCB1bnNpZ25lZCBpbnQgZ3NpLCBpbnQNCj4gPiA+IHRyaWdnZXJfZmQsDQo+ID4gDQo+IA0KDQo=

