Return-Path: <kvm+bounces-68609-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QOz8NTtrcGkVXwAAu9opvQ
	(envelope-from <kvm+bounces-68609-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 06:59:23 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FB0A51CE2
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 06:59:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 19AC6625D48
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 11:37:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF565423172;
	Tue, 20 Jan 2026 11:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="id9Fpedf";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="id9Fpedf"
X-Original-To: kvm@vger.kernel.org
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013052.outbound.protection.outlook.com [40.107.159.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A655842317C;
	Tue, 20 Jan 2026 11:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.52
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768909027; cv=fail; b=kNZyD4CDdA1rW3bL/EzPglKTXuNKh4hO377wUJlLXFEJIDX/A9GBxZXvpHH7k3FhWnExaDJSBlys19G4IQj+8fcV6i7WfySihR3bqv8GW0B44krAB95a1V5tOVX/DeUpNoF2Q+F4UkD0bsKa+LtkY6ZODJex18m2n5Sx2fggHeU=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768909027; c=relaxed/simple;
	bh=4pxGM9k/a2vg5CwsVBnlAtUyKdlMp8RCZkZd4x0ACkI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=qLS6be2gYJBj18bx79jQ24WlEbBqjAn3MBReFWUi+zjh/aVaMMVnB1uZSKtPaI/3SsoY/OQ3kmLqvRIyWMKRyrG4vLZtw7QUFCqa+/t7ZUuSOpLnneGy+mKmklF0/7ZMY6CMrNsRfPEpXnr1gGNekkgZSmPC8X322CSlyBWXEA0=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=id9Fpedf; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=id9Fpedf; arc=fail smtp.client-ip=40.107.159.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=X5EBKLV4boUo/4pwdStu+4eSfmm/IyQSkw+jdDuiOFRYWNNZ03tQ+POoUSJqkbbmJE3Tlv7ylWTh2nPXxXVrj828p9V9m72iZTuvUYkJ+yuML1lg67cChND/xDk0c0p7RQ2AVI2fDJO4JXcFlOm9toIYdP13+uyIolxp5hxlIWOIn0l/UK9D7Yu3yvRkVebRJgxy1JklheuB0N205VyXS/dGxcYZ0WO8BOTHbkJK5jruFmLUYynGeiXZvTovFryKHjbL+E+mLrkX7YONqyLFI8M8bGK5IID6Bfz9Kvuanq/H7Hn7IJ15725CZtdJ4ku/Wh/2kCEoDBFpen0SL5t0WQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V3NI6xDhLT5HFStH8gBNPdRjYdGedyvlW6q3j1EG4Xo=;
 b=Ac7djti5OeQeR1N6plYx6QltshZERzTsxGT17Ms0FMKUxlxiliFnFYV9YuRfnnnUaQOgvaUKR2soPW+O8wswCCCe3Vlw1gLVSgpDsA8FI8oBnVvOPoAd6hTkelz3t4Y8IBQ4K0ONy8v6FgxDIXZuY46GcyE23BBrFT3GJbXngHCxJId22Vs5BZZ1q06mWdVnvklmj4id9wl0MC/crWxaHDTLEggBe0lNQLzh3S/PodqLcin2AAMpU8Kq2q58neWPrDCF0G14Hmvk2m6skjqecssrjpsI0Roup9vNzTjquoYbOZPl5ISae4v0d7sXAF2zYvAYA95MtfCcmAuk6m2gdg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V3NI6xDhLT5HFStH8gBNPdRjYdGedyvlW6q3j1EG4Xo=;
 b=id9Fpedf/cLkaUSn8Utn2pRT4KFfjNVYNrKflPpJlOfI070sGENbgJjRvp+EYJOMxryhHTikC1hbkNuGiOzuT3ocsb2FyeGn9ffpHKxIdIUgGqaNBYUgpzm7CG/F9UgtQDG1eOFVRuJVkzidYlX4aOa6uuDImFIfW4wekbqeocY=
Received: from AM8P190CA0024.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:219::29)
 by AS1PR08MB7658.eurprd08.prod.outlook.com (2603:10a6:20b:479::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.12; Tue, 20 Jan
 2026 11:36:58 +0000
Received: from AM1PEPF000252E1.eurprd07.prod.outlook.com
 (2603:10a6:20b:219:cafe::96) by AM8P190CA0024.outlook.office365.com
 (2603:10a6:20b:219::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.12 via Frontend Transport; Tue,
 20 Jan 2026 11:36:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM1PEPF000252E1.mail.protection.outlook.com (10.167.16.59) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.4
 via Frontend Transport; Tue, 20 Jan 2026 11:36:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ScfJYDhDag4AFatPxPfjngjkOrtyxZFWL9T+nFEUm9C8HZmo0myVf7OCQJMe44Ldvk2pevUuqNC4Io3bhwMLENyuZo2YuWSM/3iGjuQjuMEnYJAY2a8xwgJEUetEsoUl5vuyPIblw6qB/9AOaNCgWwUe2mCU6koaBuiOjXfhK7fE+3WqRnbiOjbA1430kdUIS5HP50QNkeSlQ71hefETVbx6MTUd8ABTfRyF9XKB3xTdT77m/oSe8X6Ld/WEnPJXCR2KGhKydv9HyFpFATxhCXHjMqBW6Rw9eU+8vqgND8FTdoLxkHhV/C6gYVel5AT9Km0V9WC+nQRbsoseL3v9VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V3NI6xDhLT5HFStH8gBNPdRjYdGedyvlW6q3j1EG4Xo=;
 b=n0oO/F3VFG0Ie2Brssjpn8XhYKQPZ9LxvX7D3Hs8KEdl4a2h5Pg/NqByuvp/ZjDDgP9r0Ldf40uS9266PrWA2KgHS6TATzh+JWx3LWWzHGhvQJdZi3HL9F2L3WIdShPqrq+DNjPicpPVhalobO8i2y6B6FQyzKQQQaRoDq8+EScaynlw9nRsq6iHoFZFevFEZgoXtRJ39qfcAL0tmchvGxwTnmCp4qqvJsjCNOKAeh2sMsTvaSYmzT4TLyGXjv3LvgzAD0D6yH/e7p1j0A8iqVys4MJdGIeQhwK/Jjf//Ddg1btqqZOLSaMx3PKA2KXtJkhlZ+22m/dkhH5hfjfZFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V3NI6xDhLT5HFStH8gBNPdRjYdGedyvlW6q3j1EG4Xo=;
 b=id9Fpedf/cLkaUSn8Utn2pRT4KFfjNVYNrKflPpJlOfI070sGENbgJjRvp+EYJOMxryhHTikC1hbkNuGiOzuT3ocsb2FyeGn9ffpHKxIdIUgGqaNBYUgpzm7CG/F9UgtQDG1eOFVRuJVkzidYlX4aOa6uuDImFIfW4wekbqeocY=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by DBBPR08MB6201.eurprd08.prod.outlook.com
 (2603:10a6:10:20a::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.12; Tue, 20 Jan
 2026 11:35:56 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::8c9b:58d2:2080:eb98]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::8c9b:58d2:2080:eb98%3]) with mapi id 15.20.9520.011; Tue, 20 Jan 2026
 11:35:55 +0000
Date: Tue, 20 Jan 2026 11:35:52 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Will Deacon <will@kernel.org>, catalin.marinas@arm.com, maz@kernel.org,
	oliver.upton@linux.dev, miko.lenczewski@arm.com,
	kevin.brodsky@arm.com, ardb@kernel.org, suzuki.poulose@arm.com,
	lpieralisi@kernel.org, yangyicong@hisilicon.com,
	scott@os.amperecomputing.com, joey.gouly@arm.com,
	yuzenghui@huawei.com, pbonzini@redhat.com, shuah@kernel.org,
	mark.rutland@arm.com, arnd@arndb.de,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v11 RESEND 4/9] arm64: Kconfig: Detect toolchain support
 for LSUI
Message-ID: <aW9omBgyHyI4267b@e129823.arm.com>
References: <20251214112248.901769-1-yeoreum.yun@arm.com>
 <20251214112248.901769-5-yeoreum.yun@arm.com>
 <aW5S04xS4FT0zvXv@willie-the-truck>
 <20a2e113-7d53-4857-9cbb-9e4ea910b7d0@sirena.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20a2e113-7d53-4857-9cbb-9e4ea910b7d0@sirena.org.uk>
X-ClientProxiedBy: LO4P265CA0254.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:37c::18) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|DBBPR08MB6201:EE_|AM1PEPF000252E1:EE_|AS1PR08MB7658:EE_
X-MS-Office365-Filtering-Correlation-Id: 25a2909a-e5cc-4960-a618-08de5818386f
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?dXVShAm4cQ+F4RirjT3+6PUB5L/+S1qlj4lWhl9b4vm/9F9uxBVfcknGVftz?=
 =?us-ascii?Q?7xXAwPKPfZyd6e0zhVZQD1xH3j8+TfHK+lPakEwCFegTqdWUBzX4ORXgQFWl?=
 =?us-ascii?Q?WwOXYB9KapMKdzW7JaV+8hRBbsIJbWIJmafx6jh5fNrHnAGTbbFwNhQebwky?=
 =?us-ascii?Q?C4jou5j5mMpfS+Wieh00CaEfuFcLrxSK5CoFOkQ6HtELsbX7AEVnqI0maIzl?=
 =?us-ascii?Q?suPI9Cv8AiOlOe9kbArnKBTMvjVNYUlBRt5D9UPrEXBfS6SPWl0U+wbeejFM?=
 =?us-ascii?Q?5aXUl3d/dznQ0v9qAsrZOCoyYm7tjUgLglsmM8C8OTmd3jmzestAlblxQT/g?=
 =?us-ascii?Q?qyJwGuUFDk6KzylAGvtg6unPm5r1LR9U2bz5EtvlOlFrk0ri5Bo71WCtYaZN?=
 =?us-ascii?Q?R+Jpl0RfRY1xUvk/MQQRcwBIA69N9RythSQJfBAZ5V5fvlmVsQIzSbuGsx3a?=
 =?us-ascii?Q?mRMkpcdUE6mcptphP3ERsO9hsPWuv43SMSrJMEplEdUrU9kWjjaxyCMJ91Ol?=
 =?us-ascii?Q?ZEkUPERJl5Wl2lPjOGKR7JxbYfhYUaiGmV7IZ6+hgDxGveiOXIm41IhIQ+rS?=
 =?us-ascii?Q?cWnmXyYEbeqvrAmYp7Yhg1aFoD7f2Fjw+Vi+t0UTfgAkdZ7BMVRN3yXMU+Q0?=
 =?us-ascii?Q?w+FCRxoW+huMVGjI3zes6GpuW3Xf+RY1ONts65bczspv6QjkAoFJbuwspF5s?=
 =?us-ascii?Q?FAvZcBTEgZnivV6b0mAgVTuiaYgtPukUEbC1YuzwDe3oxsFEC7wTUN3v+cyR?=
 =?us-ascii?Q?EjMcBD6myGpSZgG++Dhp87OAjpLzserhHBdtFbLat0rGNwO8dMwsJsT1GZla?=
 =?us-ascii?Q?hTFz27/RTouS6nK1oJ/DsBiWgNBj5b9Oj7NiP+TMDzoiqnZvfVheiihOHXml?=
 =?us-ascii?Q?SmmN0OeVxm+BYdxsa6aXyUdNVlc40NmRNaXkgQgGmtlpHc0FXkQf7rOpu9PA?=
 =?us-ascii?Q?jqc2Pmw6qVE7A2Q+Y6lW+zB2IjqZ2xEdQTDBMH6K5bhJgljcSTT+6+NKs90F?=
 =?us-ascii?Q?gNYJUilDXJIIfzmk1C+3fHozn/xliHBEjW8cT8fxDe8dcv2/CgDKL5/uUK3F?=
 =?us-ascii?Q?ico5iOmVwaUiEzJlXu3N7JzSwz3u6ikHNKf9XD3VIjQl7hjIDiTMAaIOnLgS?=
 =?us-ascii?Q?8f4xk72mMXBozhfRMhI2wI9Jd5X3blJssy/jOSElrhWeGDhNxMaCr8ST7gDG?=
 =?us-ascii?Q?zuBF1dMFRMjzphh4XlXFIe8gNC0Cufzl/q89sPk9Z4rsIFl0agI0748Bwt0K?=
 =?us-ascii?Q?6d/WijHKVD7O6kuMcajOPD9lFbIAaXF8s9TOACsccZ5vVLONdWD7umhC7TYY?=
 =?us-ascii?Q?M9loNwlReqAPda6YNX/uF0V3+4UnORR0dL3vvJpukzmSsAodvFWM6/XIHPEl?=
 =?us-ascii?Q?mCGn7+BoSpS1QgTg+nITc5Cq0FYSv/iWhe7Fv3az+N13MhKnFdcEXcj5ISZA?=
 =?us-ascii?Q?RPLhtPYdrD6eN+NRg+04+1xG5VAlD5qQomkepCflJWLCfMH2EdT7SWXCYxNR?=
 =?us-ascii?Q?dbdFmKgRGvXywd8kHWGXvuqx21rxFub3+E8ulEOEoc3XSDig6mUIL+VEZbwl?=
 =?us-ascii?Q?95bDp+ozvD/5+W+246w=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB6201
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM1PEPF000252E1.eurprd07.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	976b6ee8-f169-4906-db1d-08de5818131d
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|7416014|1800799024|376014|36860700013|82310400026|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kJY2h23UDgqIjtvke0+Ee6xVg9Xljnxijp6XuXQOhvj0Do6ajC1M4WjMdYLV?=
 =?us-ascii?Q?Msph4MH0TUgX8SFOVUSsi3A5z5V9PF2hgqe+FZ5M+eQLtfRQdg3fP7Qmd0mu?=
 =?us-ascii?Q?/qLdTTZHvn0e2TvwfPs0Ax1cPvb8svt0T8ZLZRlxjBaeuVuAlAqczZZerkX8?=
 =?us-ascii?Q?8AdjwJQpHssA/IKXSZsHWKBBAV/+Tpprp0RTqI5r6iNozBB+G0/Jl4KPe9gb?=
 =?us-ascii?Q?U+hdbFDD957mdukFe8Ag9IXrykeuhxqWo4GWyyVNPnb9FPpfNNwZVTQl+7j5?=
 =?us-ascii?Q?sv/opSGnNhFP57yZ7020nXkXvedHAfjA53JsP6Ljat13EQWptYEZ8izad4v9?=
 =?us-ascii?Q?G1QKAdLA9WWCle0XdxPBjo/C1zsuAzvCuziUUumrveYcOi2mORT1wmQUe0FI?=
 =?us-ascii?Q?cfmRDcW6SyhIRPin8EazaZDtmoQDSMw27zw2ge3vQDNLVKbtA4bfQR8Q/73E?=
 =?us-ascii?Q?mIM8NSwN5HKcNMNvCRzo3j9euqBjWCuHQnwK4DNQnWKVjHXIhV09/q6PkdtW?=
 =?us-ascii?Q?2BJ83vTuhrsbb1vJqSZoHoaAdsIrMGkVXPE2sWdFARWxurattP3+TJFM0nhw?=
 =?us-ascii?Q?XINg32qii0s6y3764kpjy0hTbwluTSzG52zRq8Xc5msAPDCDxLe9cH1HZ8cR?=
 =?us-ascii?Q?b2fR8ujc7xjrquR7nEi1/7RFo9Lyqpz6ji45S8pKsuNaL2pXQZCICbVEA5Ws?=
 =?us-ascii?Q?Vu9vW1Cr6OlDmVSD8EldNMoc7IpwOTbYxAwN+LBZTQUFSIS3kfjUS7gWMgbZ?=
 =?us-ascii?Q?ao/A2rU5XKAuHOMILsgeAc8kAjO4vDA9n7IK00L3JYAF5xzTcz5nr9SYKylU?=
 =?us-ascii?Q?9BrCBsJutV9yzUDPGJkrrJK65e8ay7Dnq0GUdQoWQcYqUi0SXG1JwuJWJCiQ?=
 =?us-ascii?Q?j5o4qTvL3Z2bKhqRnEwKLSniVuEqdoMsART93Fg8baQMU4YFUQY+lnJJw7H2?=
 =?us-ascii?Q?MpTtmdaOicZYa+AuCCj14wRsveq8bb+1auKoqmDo8mpuHLrhR9M2WNiwxr0n?=
 =?us-ascii?Q?qKfe1nAbZ9uq+/lqwzfVhjLO31HQ0qkN6kzxIOf/Y/8yp920fvBiESvSv06h?=
 =?us-ascii?Q?5zknl2VuJ6QFShQzS0/Jq/hpHRRrJKOs2fPrwJ3auU6i3oUaTtS1UlhHij+D?=
 =?us-ascii?Q?1mgc7b38r/YwBQtB+sUpSFyIU6x8QPchFr3kPiI95W+gbX1Z0QMr2vSJcQs1?=
 =?us-ascii?Q?xRsuxu5OXMXpimhb7GVZEY+JTu6hMEyQfyui5Q4+tkCXCpsUEMWyTbUFFaDd?=
 =?us-ascii?Q?E2omwACyjLm2GmTMVZ9pklqBY9GfJGhO8/sVwsjVrzwnvNh973BoizdpHyO+?=
 =?us-ascii?Q?2I5fIjTWmtwVtwOf+lL98XosC0Jqf2fflZPvKB2b5Cjadp7GU1VTeMvqhuui?=
 =?us-ascii?Q?IFjdJ+j9/S3U0WptF1E39vOuUlII7dFnZr7dIicdVOxeDz5b5EDWPJcomOOt?=
 =?us-ascii?Q?CPdKbawRgu+CQRg188ajzOoNT2ZNH8dXf1v9s10y6iqa0FrcaMPIzY7Fsu3E?=
 =?us-ascii?Q?y+NQSHMoUDOP4KprMUQvSSsGiOC1WUkyWKCNorykLp8HoQn1JZPGtzW30BK1?=
 =?us-ascii?Q?UcKGIT49GS4EHda4ObM+xc/MW/YEUsFdgE05Juma0g392Il0+raDPNAZ6lO1?=
 =?us-ascii?Q?DW6KyNUXQproJmD2NN6yxDPr9/wA37fqIuIczf5CYkHa?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(7416014)(1800799024)(376014)(36860700013)(82310400026)(14060799003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2026 11:36:58.1518
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 25a2909a-e5cc-4960-a618-08de5818386f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM1PEPF000252E1.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR08MB7658
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
	TAGGED_FROM(0.00)[bounces-68609-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[arm.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arm.com:dkim,ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo];
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
X-Rspamd-Queue-Id: 7FB0A51CE2
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

> On Mon, Jan 19, 2026 at 03:50:43PM +0000, Will Deacon wrote:
> > On Sun, Dec 14, 2025 at 11:22:43AM +0000, Yeoreum Yun wrote:
>
> > > +config AS_HAS_LSUI
> > > +	def_bool $(as-instr,.arch_extension lsui)
> > > +	help
> > > +	  Supported by LLVM 20+ and binutils 2.45+.
>
> > This is an internal Kconfig variable so please drop the help text.
>
> It would be useful to keep the information about supported compilers as
> a comment though (as is done for some of the other toolchain feature
> tests).

With some comments from other thread,
What about this?

+menu "ARMv9.6 architectural features"
+
+config ARM64_LSUI
+       bool "Support Unprivileged Load Store Instructions (LSUI)"
+       default y
+       depends on AS_HAS_LSUI && !CPU_BIG_ENDIAN
+       help
+         The Unprivileged Load Store Instructions (LSUI) provides
+         variants load/store instructions that access user-space memory
+         from the kernel without clearing PSTATE.PAN bit.
+
+         This feature is supported by LLVM 20+ and binutils 2.45+.
+
+endmenu # "ARMv9.6 architectural feature"
+
 config AS_HAS_LSUI
        def_bool $(as-instr,.arch_extension lsui)
-       help
-         Supported by LLVM 20+ and binutils 2.45+.


--
Sincerely,
Yeoreum Yun

