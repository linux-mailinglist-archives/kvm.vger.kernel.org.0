Return-Path: <kvm+bounces-68740-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SISxHXTxcGk+awAAu9opvQ
	(envelope-from <kvm+bounces-68740-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 16:32:04 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 23A835937B
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 16:32:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 3793A54C0CF
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 15:10:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA2C5296BD4;
	Wed, 21 Jan 2026 14:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="L7TgU28Z";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="L7TgU28Z"
X-Original-To: kvm@vger.kernel.org
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011066.outbound.protection.outlook.com [52.101.70.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 554FD33890E;
	Wed, 21 Jan 2026 14:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.66
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769007154; cv=fail; b=e1Jk19sIwf0DEoLuSaHrpeZjoJ+CiFXqKy/WnSbyk4slv13cmhvFldyUX8Usz0+XDAQyMFWr/wHFTcWcG0jnx2Sra+3rGpz9mxwjArLVubcJL8j5wzrG2fP/5PupCr8fvK6DbViLKqZYq0hRM9MNaO0cwG81a2C9d3UKvOtivJk=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769007154; c=relaxed/simple;
	bh=oIxW4sWeH7B01j4NK9s+ZpGXLXVs1f9+x4GesE3BqRU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=aMskO/akFhGQFANY5i4KNEdTPHMuz3aY/venhKB5QbZJ1WgBzcCcWmVA7JQY+biJoyhA50G2lQKDHmphF0dnxnKhTCdaYRPQBe5EufpucUrgiYZwkCVBkGsYygZ46l3niRwkuLJb6sasedo0R41o5l+K8YP9VHJF1svx20fzYEI=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=L7TgU28Z; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=L7TgU28Z; arc=fail smtp.client-ip=52.101.70.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=E+6/DogbxtBifA/UUIrLvxXDjNXqJdSxL1k+lKbz+j35FopkGEmvNCoxrVTpX4kc+ygt52LFNYrrUtVXS0g1s/sEPb3zqv0054NXBQGRhqhDiOW8f+9ZwGMvwb8BKOk5O+1x71eT6DtFiO2wHCtYqXDBat8kFMZ4JmsZlb3/Csr16I9LL3CQMp2NC+JqOa1elZN/SBCpb+1Y/idvWOU7a35heNm1koIw6xfgLhCj63V3ADyimEg5Q2Dsj7MKHz1ooZaH65XUoa45L/NiditCrdvyngRTYITt1LFIrCjkyzmuM6PKf2APtC7ew1US2OaQQQJEnBcZwRhy1X4F7K+Kgw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oIxW4sWeH7B01j4NK9s+ZpGXLXVs1f9+x4GesE3BqRU=;
 b=yCUU2IRWHkJJAhdZePZarCVU8vuPqNOr/Y3KkAfV05/yuDY8+ub+2UHSp5i1U2/L34AC30LQ2+FgkZfbqrPipgHzTREr+EYrasHhiQYMtiglHtCIn1pZgg8PhSzv2NwSxAW0xOsrUKeGeAwwMup0Z5rNlg5yWm6G4N2UDtdSD22uj8s3M2MWrvVmi/tfMbH/8gtfZ7icrA9k0DzAyYLhS9+gqzD1QDbJa4VLihYSZXMkoLlkzOdmADT5UvpIhjlJCuWw45ordo8/wgFXtv/F6CuyO12H7ZDRp6nppr8Ixq41xp5/ybp0/ULkjFyFeO/F3dDxy780tpCo9b1aRGEnFw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oIxW4sWeH7B01j4NK9s+ZpGXLXVs1f9+x4GesE3BqRU=;
 b=L7TgU28Z9S8TSTe4e4zEVeLYi+1WdEyDfGgA3QR24fjoIGpX+eiVsir5LvRIToKHJl8UamQD/XdgPma6mAFrjiOWtCAt+52kcaN2geGHErsa5aZisM5eCFQc4pTstbM14uDC+YjtHD5stAVeIzrI7d5PTIQefTWiIyPHg9zOO8w=
Received: from AM0PR10CA0050.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::30)
 by GV2PR08MB8414.eurprd08.prod.outlook.com (2603:10a6:150:bc::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 14:52:21 +0000
Received: from AMS1EPF0000003F.eurprd04.prod.outlook.com
 (2603:10a6:20b:150:cafe::ef) by AM0PR10CA0050.outlook.office365.com
 (2603:10a6:20b:150::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.9 via Frontend Transport; Wed,
 21 Jan 2026 14:52:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF0000003F.mail.protection.outlook.com (10.167.16.36) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.4
 via Frontend Transport; Wed, 21 Jan 2026 14:52:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uUOPNJDqOzvbQJoncALqW0262rx5WeWMiZEiwUPsDbbDR67QVHUgsMTPVWwWObblHAqhVaR5CJg40drB6GXmNuI9wTPx30ihy836TkiKiuIHHBB35pXMkSXZhgaCMstCw/yIp/HyEdbG5bHZPAgiCw0su4PPtjBipQQuxG9XkKxRmUJn1PIa/3l33HDmPlOQgt6b78CTn9UkkWeCXA8kQGNo+h4nNeOZXIzb/9ns61z6pQfqfkrI/t8Uhjp6kdF6V5JRsfYtnwaCrymtA4Iddg6+J8IUGFh3FSrPxo4py56Wz50mlg4AHAatps5YHvf9C4F8CFhFr1+H1q2U1ShN3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oIxW4sWeH7B01j4NK9s+ZpGXLXVs1f9+x4GesE3BqRU=;
 b=H3yaNNLHJICp11EjNgJ7jtIZ0nItCY1GdnpSJ2lFfTfi0SIfvHRI3bsQW2pZd7zAevQkkOUNqZtBSc/bEbOxjt6iL/1dPNsVSV+URUj5vn68Szhq5gIaOPw9q8KIRLW8FhHfBnbvlJ74qcT8VezSRQ8UoNZX7MIpuCWWQ4RyElw9aURGzggMGbctQvQFpqwnXgerMszCZ+mh9SmD7YPh1vQKr7imG81sB5BqewySKi7phEFeSYqwejNxhcpzzKDnJrqSTMItrLyLN0mS8nKFB7d3S8kZgZQYKedE9AY0Jg/NQFmYxv1AB7TifjE+NEVJsyHHiFlmimcYteqpRvNXSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oIxW4sWeH7B01j4NK9s+ZpGXLXVs1f9+x4GesE3BqRU=;
 b=L7TgU28Z9S8TSTe4e4zEVeLYi+1WdEyDfGgA3QR24fjoIGpX+eiVsir5LvRIToKHJl8UamQD/XdgPma6mAFrjiOWtCAt+52kcaN2geGHErsa5aZisM5eCFQc4pTstbM14uDC+YjtHD5stAVeIzrI7d5PTIQefTWiIyPHg9zOO8w=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by GVXPR08MB11095.eurprd08.prod.outlook.com
 (2603:10a6:150:1fb::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Wed, 21 Jan
 2026 14:51:16 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::8c9b:58d2:2080:eb98]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::8c9b:58d2:2080:eb98%3]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 14:51:13 +0000
Date: Wed, 21 Jan 2026 14:51:10 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>,
	catalin.marinas@arm.com, broonie@kernel.org, oliver.upton@linux.dev,
	miko.lenczewski@arm.com, kevin.brodsky@arm.com, ardb@kernel.org,
	suzuki.poulose@arm.com, lpieralisi@kernel.org,
	yangyicong@hisilicon.com, scott@os.amperecomputing.com,
	joey.gouly@arm.com, yuzenghui@huawei.com, pbonzini@redhat.com,
	shuah@kernel.org, arnd@arndb.de,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v11 RESEND 9/9] arm64: armv8_deprecated: apply FEAT_LSUI
 for swpX emulation.
Message-ID: <aXDn3iRXEtgaUtnp@e129823.arm.com>
References: <20251214112248.901769-10-yeoreum.yun@arm.com>
 <86ms3knl6s.wl-maz@kernel.org>
 <aT/bNLQyKcrAZ6Fb@e129823.arm.com>
 <aW5O714hfl7DCl04@willie-the-truck>
 <aW6w6+B21NbUuszA@e129823.arm.com>
 <aW9O6R7v-ybhrm66@J2N7QTR9R3>
 <aW9T5b+Y2b2JOZHk@e129823.arm.com>
 <aW9sBkUVnpAkPkxN@willie-the-truck>
 <aW/Ck3M3Xg02DpQX@e129823.arm.com>
 <aXDbBKhE1SdCW6q4@willie-the-truck>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aXDbBKhE1SdCW6q4@willie-the-truck>
X-ClientProxiedBy: LO2P265CA0008.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:62::20) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|GVXPR08MB11095:EE_|AMS1EPF0000003F:EE_|GV2PR08MB8414:EE_
X-MS-Office365-Filtering-Correlation-Id: 648504fb-0d99-4c51-278d-08de58fcae4b
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?b2h5ejkzWVZ5MEk1REZCcDRuMFdZMUxuYlR0N1NBUWcrWGVTcklIczI4VnZv?=
 =?utf-8?B?NEpKWEtjQzAwM28rTjB5YlUvTXlEWWNRbGw2TEVNNVNrUDdVWFBLNjAyUnV3?=
 =?utf-8?B?NDlCWWNsWVZqY0xaQ2tGVFR3U1Fnc3hxRG4wRG4xZzZ6N1h5U09wRk9YWGt1?=
 =?utf-8?B?Q2o4SXhZM3kzZUpGTGdpYmc1MXRUT25Xa1BMVVRSRUpVL1NXeWJQd3VIb2hZ?=
 =?utf-8?B?T3R2QVVZK3pEVEx5Z2NFMkE0WG04ZTBCL0szNE5zaWQzV0FQbWQvZFRjanRt?=
 =?utf-8?B?YlJXejFKZkdZcEl3cGJjMHowVnUrM21uanhoc2pjK2Q0Wml0SGR2c2c3RHl3?=
 =?utf-8?B?T1Z1ZDdBNlNuN29paXk3TC9KTTRjRnZFQnd2UTZ2RkZGcTZyaEtzT3J0WUE4?=
 =?utf-8?B?UXRSY2M5WG9QVDB4UlhuQUdjendQeU5CUTdUUGVPbUNvZytYalQwTzgwMUF5?=
 =?utf-8?B?d1JiZDNFUGNZQ0ZmMG5SZ2xIY1FrbUdPdmpmcDRmeEM1amdZNWM4bFkvVU43?=
 =?utf-8?B?cXo4enhzTnpvT1BVdUlnd0JEdThMM3ZQSHdIMnFlVWVPQkdXQllMY0g1WHBu?=
 =?utf-8?B?UHJBcmQ4UjM4OGJUNTUwMi9BYWR2RDNjUVBJMVR1bDFTQ1NwdUNveFIzcGRQ?=
 =?utf-8?B?SnorYjNqc0I4cGJiRlpWRXBONlZCekFBcGtaRFAvMFVIdUtNR3J5aXRoRHd1?=
 =?utf-8?B?WXU5Q29WOEZJcDk4M09JMFhrNm9QZ2kvQXcwSzIxTG54RUxTTmV5MkxFNEdv?=
 =?utf-8?B?a0xiUzJWdXZXbm1tM0JISDlqYUhSbmlnb0xoRy9DNEZ6QWt5QVF1cU93cFBS?=
 =?utf-8?B?ZU9xRnphY1FvbHFsYWRUTHNyNGVFSkNjRG1nNTFTQVNpNXFlMFF0dG5DaThT?=
 =?utf-8?B?R1BkeDF0UDBNYUMzdWV0MmRGbHZlcTFwK2JLaEQ0NnZIb1lEVkJ2WS9CSHJO?=
 =?utf-8?B?YTE0UklUblZvK2gvR2UyRGpyMDVkc0cvdDdxT2ZMREI2SWR6SlQzWHArWTkv?=
 =?utf-8?B?dGZpT3RtK3Iva3dOZ0Z0dmpVaWNiQWZiMVUwU3RVZXNyVStmdFdKaHZ2eDY1?=
 =?utf-8?B?emVieXY4dEtBd2xSdVE3WjFEYmNGS2pIZDRCbnl5UUVNc05pYUdLeVI1UCta?=
 =?utf-8?B?ekFNMVVWY2dpdTZ3ZjBqNnptbW0xbnB3bTl2TlFTTnJBVnFkdUNkdlBLQW1F?=
 =?utf-8?B?cHRvWFg2dE1VQjZqZ24wRllYd29FRnJkdVhDS1o5ZGFtcC9vVGJyWGJFSUI0?=
 =?utf-8?B?dUw5bVZSVHM0QTFSU0hTZXBOQUtCSEdVMG5xN2RWblVORHZOSHd4djhTTmM2?=
 =?utf-8?B?d3RTTWxFek1KbXFTTmFBb3pWZ3FLQXBoaTk1bTVuMlhjL3lHMDZZd3h3dXVW?=
 =?utf-8?B?S2Y5TktpNjR1T0NQa0w3aTVHcFVzaFc5N3F5VTJKcngzdi9NSUF0d2FvOSs0?=
 =?utf-8?B?dHBURjhUaEJNVzNnK0J5bERiam5xb1lPQ1Rpa1UwcDNPNTE1TlFOL013cVgz?=
 =?utf-8?B?Yng0SWZtNDNzQUhpNmJweTN1M3c3WDA4cXdWK3FVQTNrbWQyQXAyQ09LeWdl?=
 =?utf-8?B?ajV2VGEzM29ZbGtsdTZtejIrVmZtUGlyVjVMeUJ0Y29FTm9HbnBHOVZWZm5I?=
 =?utf-8?B?cTVwcXJtb3ZndWZOd1k1dUJaekJiRUt5amNlTzJxTXB0Vnl0NWRvVVpFd2Ry?=
 =?utf-8?B?NG5NalhMazlzaXNhOFZPWVVpZUtLL09IRHZtZVZsNURLRlBSTXdaejZWZ2J2?=
 =?utf-8?B?VlMxK3Q0a2ZsczN6S3NxdXNKNGdzeWN0dU1wZnVxWEN3L09FREVhRE5IeDcy?=
 =?utf-8?B?OU5wVFRXeXpCb2kxYmVvcS9odk9nanNkdjJDU2drdTRBaUo3aTY1aGprb0NC?=
 =?utf-8?B?T3Jhd1IxTjl1OWJ3MVViZnc2eVduMFFHTVNuY2E5aEMzbW9qZjRabXJrc3ph?=
 =?utf-8?B?RHMzZndOV1kvNVRhK3NrWDJodUlNS2lQWEYzNGZIWlo1VVEyY2NmSDVteWtw?=
 =?utf-8?B?UFlrRWRycC9sUjhza0k3WmVlRWphYUVwTnFiNUFTUzR3S3RsVFlybTdwbnNo?=
 =?utf-8?B?NVB4MERmWGNEVVF6bzRUYUhhN2ZrVzUwTER1UHJZeEN6WW01KytKbHl3akF0?=
 =?utf-8?Q?C2kk=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB11095
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF0000003F.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	0b97b1da-4974-4169-b38c-08de58fc85cd
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|35042699022|7416014|1800799024|82310400026|36860700013|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TjlESm5WZFBqbU13UjcyTmU3a3I5YS9UbTVaKzFxZ1R6ZFBpUXQzaFEwK0Ir?=
 =?utf-8?B?aGdKV3FQWUluMXNEVThhcUZTdUtqMVMrY2t1RXVVcWQ1UnhSU2tvT2hWRnEw?=
 =?utf-8?B?aUxab1d1c3dhR1ozd0l5WDRLVnZRemhCUEFUemJsN1pIRnhlTU9Qb1cyVk0x?=
 =?utf-8?B?OVJkTW5uV1NieDh0ZVlmdzJCWGgyUkhoUGloWmVQNFI5dHdoSERsR3pScDQ0?=
 =?utf-8?B?MkZtNDJaS2lUNnAxSUNQdmdRWW5SYnBBSitQSWxGcGo4RjUvRDhVZ3hoNTQ0?=
 =?utf-8?B?akhDZ0IwY2FoNmYxanptV0tOWnJPR2lQbGhxemRXUHV2Q1dwV1BUeTVDRGFG?=
 =?utf-8?B?VFRRYm9LUy9jRzV5SCsvVWdaN3NJQjF1VXhqRDQ3U25qSTZpUWx1STN3VnRv?=
 =?utf-8?B?dHFBNUFDaElPVHg3TlIzcnJMYm1udkxRL2pWNUc2S0R6L01mSEpOUkNtaE5K?=
 =?utf-8?B?VVdpdm9EZDFEcmFSOHk4TWR4bVFWdWViMlk0eTdkL3hmVkgrTGlxT0VWTWNa?=
 =?utf-8?B?MSs4a1NvM2EwczZoMkxUK0F3T3NTUm9BNHlFM2NwWExyZGdZSkowbkJOc2k2?=
 =?utf-8?B?ZXdHVnhmRjY4WTg0WDZXZ2lmbTMzYkNRZ1JDcktFNk1qOVBJUFpQYjRlWXV4?=
 =?utf-8?B?VTE3dDdqZnpsbVdvdStYUDdWdk1WK3NBUEUvVWdZVGxIWmlNOEdibXFsQjhS?=
 =?utf-8?B?Uk5PK0lFUythQzFORGtkb1Fld2picEpDRHRrNnUrSy9Jc3JwK0I5WXpzM2p3?=
 =?utf-8?B?RmxxVmVnWld6eDJPNFhUOFRibkpGN0FVdmVudlVUVHc3Q0JmS3d0Rk9NQmZo?=
 =?utf-8?B?Wis1dXdaOEZrMElkQURRVzdnYmZoalgxRytsMEw3U3dtTHBkTldxUitYcTh1?=
 =?utf-8?B?MCtobEhqcllWTllwMUloNWkvTHk3T1lSQlZSK0luUWVXUmhLNDUvM1pJN0py?=
 =?utf-8?B?UW1WWTMxalQva0g3TFV0ODV0YysyUm53QkViUjFkVHdxOExtMUtFMFpqQ3do?=
 =?utf-8?B?NWhkdFNURVRRNFNoZE13UHVxa2diQ0llc20zcXhPTHVYaXQ5ZTQ5aDhDbU9F?=
 =?utf-8?B?eVFJNEFpMThIbXRZTFdoNTRnc2RHS2Vnc09VNnp2ekdLdksyQ0F5dUVVNlBV?=
 =?utf-8?B?K0NxMlF0MkZ1Lzk2YWJQQWQ3OFMzQjJyOXNoZU1FL0Z1Uzk1QWhlaXVhcmtv?=
 =?utf-8?B?d21aS3ZINktreTZaU1EzeXFmZ3hIYm9Mc2FLbEU1ZkxlUHY2aDU3WFBGVHRG?=
 =?utf-8?B?UjNMbjNwcWo1bXdIQ1oybG9uWG1CUFNlZEZVdHlLZUFOSnZHK3p2elByTmlV?=
 =?utf-8?B?Y2xNWVBQcjNuNDRxeEF5WG01TFNvdnQrd2hYV2pPRXRQNWErOFlFa3hrOU5D?=
 =?utf-8?B?aFpZa3MzdUFGcUZtY0tLSlU1eW5ZOFc2b29seFdxQXhmdmx3SUhBNGRwRklQ?=
 =?utf-8?B?OEZzeWxPVmlmbGdpVFEzZGFBVmtkS3NVdlhqNTRMdXRka1pTSWdpTldiN213?=
 =?utf-8?B?OHdmenduUDRpZXVnYjlKeFFGMUQxakhuVVFxbm1kQU5hSVRvNnRRcVFudDBX?=
 =?utf-8?B?WnFRYnBLcmduODhPLzhVTi9nM25CcmluSFllQmw4K2tJd0I5ajdPUHZqdzZh?=
 =?utf-8?B?b2thRmJqYXpCaXpneHcwdmM1MGRDbUxtdWlkVXBaaTN5ZzJSbVRpbEZuN01h?=
 =?utf-8?B?RncrbEV0L0JFckdTaDEvb2lQZjF5Ry93WUFid1lEWEJCKzY4amthYzdKTGhI?=
 =?utf-8?B?dDJYcnR1YU1JdWhSY2N4eS9UVXBJU3FRK0FueExaTUNHOHRCZHgxUjRXK1Ny?=
 =?utf-8?B?UUU0VnZac3lLVkxFMDNqcG0ydXIzbzloMDl2Y2VGa1F3WmhtWTNNeERKeHJ4?=
 =?utf-8?B?S2FPN0w1QzIrb0tlVzBhY002b0FhODQ2a2xDU2dmeURlTURMN2dLZzI0c3ZN?=
 =?utf-8?B?Wk5ybUJzeGdsZDlHRGRiZGRzUGVMd0lxNTNnOXV4SmtSZkRJSmZmSFhTemh0?=
 =?utf-8?B?YWFnZmEwS2YzUmw0dEM2bUxSdjM3V3BWWlArVEFiRURKRjF2eFJRcy9iOFdZ?=
 =?utf-8?B?NnRiaEo4K1FZQ0ljUkU5MGYwUFRuM2NPZDN4NE5IdmdwWHRQYWJMV1dMSWNH?=
 =?utf-8?B?WlQyRk4rc3BCK3hlcjhVd2QzL09hODlyUUdaWUdxbWVBSmxUWDYyTi9MaDlH?=
 =?utf-8?B?UE96MXA2WjlaQ2hyVUFSRkNwTjVGSlNwOUFqTnQ2OEdlazhpVW9kT3hKZTJM?=
 =?utf-8?B?ZERKSHJTOU1uYnRjT0J0NWFQT09nPT0=?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(35042699022)(7416014)(1800799024)(82310400026)(36860700013)(14060799003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 14:52:21.1510
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 648504fb-0d99-4c51-278d-08de58fcae4b
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF0000003F.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB8414
X-Spamd-Result: default: False [0.04 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[23];
	DMARC_POLICY_ALLOW(0.00)[arm.com,none];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68740-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[arm.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo,e129823.arm.com:mid,arm.com:dkim];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yeoreum.yun@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:7979, ipnet:213.196.21.0/24, country:US];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: 23A835937B
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

> On Tue, Jan 20, 2026 at 05:59:47PM +0000, Yeoreum Yun wrote:
> > On second thought, while a CPU that implements LSUI is unlikely to
> > support AArch32 compatibility,
> > I don't think LSUI requires the absence of AArch32.
> > These two are independent features (and in fact our FVP reports/supports both).
>
> Did you have to configure the FVP specially for this or that a "default"
> configuration?
>
> > Given that, I'm not sure a WARN is really necessary.
> > Would it be sufficient to just drop the patch for swpX instead?
>
> Given that the whole point of LSUI is to remove the PAN toggling, I think
> we should make an effort to make sure that we don't retain PAN toggling
> paths at runtime that could potentially be targetted by attackers. If we
> drop the SWP emulation patch and then see that we have AArch32 at runtime,
> we should forcefully disable the SWP emulation but, since we don't actually
> think we're going to see this in practice, the WARN seemed simpler.

TBH, I missed the FVP configuration option clusterX.max_32bit_el, which
can disable AArch32 support by setting it to -1 (default: 3).
Given this, I think it’s reasonable to emit a WARN when LSUI is enabled and
drop the SWP emulation path under that condition.

Thanks!

--
Sincerely,
Yeoreum Yun

