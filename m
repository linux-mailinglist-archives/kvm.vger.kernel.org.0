Return-Path: <kvm+bounces-71852-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OMuxE+wtn2lXZQQAu9opvQ
	(envelope-from <kvm+bounces-71852-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 18:14:20 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AC9A519B544
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 18:14:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C6BF53053A46
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 17:11:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0CB43E9589;
	Wed, 25 Feb 2026 17:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="PsdUXu9B";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="PsdUXu9B"
X-Original-To: kvm@vger.kernel.org
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011051.outbound.protection.outlook.com [52.101.70.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F28A3E959D;
	Wed, 25 Feb 2026 17:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.51
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772039489; cv=fail; b=FOPV2FGUIBwrV9nTQRYTkt9QuJFQj9tYiKjWxslWcu/Uiu6+GKEELVV1WTvmbnircthTX16N0XjNtS5GOxIYLAlvGJ9b+SwlEOAUkuZW1PyCBf3eHNjNZ0CDo/uPVSu3nvvhQG8ppHOBg5nxeJKJm5WsQlGkGKh73HPhXNy1y70=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772039489; c=relaxed/simple;
	bh=98mYDT2/s2qBOngZLCgcYvUdPI4yhEXrccnVKu1TY24=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GHq42SIyQJEI363/YyOzcn7u0H+AWPkGu6qdUyl0fLTZy0dfGeEg3BtCEqskfS68t85F2B1GxAKBDrR4ApwVAacoYr/zt36/NeV/MXnP3WUdJFZ/cBhvZRfJsZuX6MQLdoaI/QEiQ1OnKHWBrl/+7TY/2AGgJ/i4ChRx82SeFZQ=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=PsdUXu9B; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=PsdUXu9B; arc=fail smtp.client-ip=52.101.70.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=qzvHg7ANIUetuo8aFHl/9fVoDCm2m0mYpjuqGYPYEuugiqho9RFoTSaJC/ffY51kgIhq65hvpyX50Q4pupxS+ej6yx6L5lO3SCLcch/JfywbUYYktgDQUdIutFBVgmQwgjKHhYi8k/enEPi18L3qXkNrNh72q9rl3RaJwsKKdx/lDTHVQqmseMq9/StHar8mhHSuZ0DBMOwEAkSyh5iz+U0CqTrQHPT4Q7iTy+9SiHXOOy2IOgIbbOJxpPtvrD7Y1pLBhMVHtN7oM0eD5wQKF8/Y+x3a0dbPuE9xNVCxDovis8tZ8w8gJGj18OjADIUqFXAWbqtBV5nj2BwNkyAJaw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kflzgJPM1t197nVw/rZcc3PpPQBAmiVhuUC/Wmq67qE=;
 b=Hr6mDX1g+0uFnJMl/L74Z5z2tug1UVWhr27O0UaJRICi5z468/sNqRa3zVCO6XJooVejwFDarS8E/wIMcI1IERki9q+lN+aOR5oAEBp93sJdyvVcNRk6VunX/Vq6n6nGYlZ+9BrEEEKn/yqHjTmVoHvAgIlNzXfyKY5TMlBiL7w83cN7CDiA8F6nbzZvtmnbnH3336G4R+vb64TN/OQGvemHMyxPiLeWj5qgICfpVIbWNLl+elwmL5Nn449+T7ttqSlq2ZhiLUXeIfw3+38dJ2XdvisqOJaEEWvmKkqYVSVvTXDoSuzIq1rat3Y03nLhyWyJLPH6fjDnZnl0JqKH2A==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kflzgJPM1t197nVw/rZcc3PpPQBAmiVhuUC/Wmq67qE=;
 b=PsdUXu9BY6pLIayFeslM2eKLYRkCE1+gH3blWMbKhkAOWIDuMLpSpfFpIfYPgKD+Ba4953Ydnjf9DJlXZl2KgaZtzxvc8F0XmIvvJDbbpTiSZaOcfcwkFXlbCUPCC/CzgItw03IbHuIE3ead9AMdfw8/cpUXizG+2VmEpWxR/7M=
Received: from DU7P194CA0020.EURP194.PROD.OUTLOOK.COM (2603:10a6:10:553::11)
 by GVXPR08MB10914.eurprd08.prod.outlook.com (2603:10a6:150:1fb::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.23; Wed, 25 Feb
 2026 17:11:16 +0000
Received: from DU6PEPF00009528.eurprd02.prod.outlook.com
 (2603:10a6:10:553:cafe::3f) by DU7P194CA0020.outlook.office365.com
 (2603:10a6:10:553::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.23 via Frontend Transport; Wed,
 25 Feb 2026 17:11:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF00009528.mail.protection.outlook.com (10.167.8.9) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.12 via
 Frontend Transport; Wed, 25 Feb 2026 17:11:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HVU62TgqR8ozx5ZSsqVVgSj7S0cowpg7YBDEA/UhGMscc3ZBv9nLvHUDDoAPF+Nd92qBztKwy5QaVLqgkK8a+DF4iy96m2APw3daMXVZ4UAZuUIsiFp5VSjWOF5sU8ulseO55EL/+uSocUW2Q4VrRCAWav00B0UhHoAqa6qGjU7PNC0BgXfSj+4njc70X1+f/J6ZwLuZtmZbgexmCBSWj2eFWphJGU8PH0mnuzcqKQJOF91lu17CK5RdoYVfyvW8V/qMlr9crI0eNgPolJ8EGK27rN6Dy1dspZqTmDmv5wq+KalgzreYA5D2z5MFyrbvf8D12xagfS1YxvvQtnfg8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kflzgJPM1t197nVw/rZcc3PpPQBAmiVhuUC/Wmq67qE=;
 b=pmpgGNOpQ87Oj6MTfdBQJKH1Fl7Mv8a1mZckAh22ziCpf0njnllDGgdRXicTWTfxLj7mqFb+IxbMix4k0iC0FAokCAMxzuBq7oqEsSSYEZhywSbwh7Sz/6PgmCZhwnRHgU4QsjyjhDElpWvu9+h1UIAhtqMrh+J4i8g4TQpVCUksm8CK71ivjNMtkI+V+Z1PEMo0qG/EXARU2Zb3qSrFMjQcs0m63sHZEjO5EMU7cqHI49ZFJr17yrdG0XbTEQXFTNzEtyxWz/t4quaPw28TKQVVdTnc6/FHz1Lo+ENvclWamTSDTrakdlzFJKciFoFbkjpw2TWYc+AhzTvWj0GIjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kflzgJPM1t197nVw/rZcc3PpPQBAmiVhuUC/Wmq67qE=;
 b=PsdUXu9BY6pLIayFeslM2eKLYRkCE1+gH3blWMbKhkAOWIDuMLpSpfFpIfYPgKD+Ba4953Ydnjf9DJlXZl2KgaZtzxvc8F0XmIvvJDbbpTiSZaOcfcwkFXlbCUPCC/CzgItw03IbHuIE3ead9AMdfw8/cpUXizG+2VmEpWxR/7M=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by PAVPR08MB8917.eurprd08.prod.outlook.com
 (2603:10a6:102:329::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.23; Wed, 25 Feb
 2026 17:10:13 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::8c9b:58d2:2080:eb98]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::8c9b:58d2:2080:eb98%3]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 17:10:12 +0000
Date: Wed, 25 Feb 2026 17:10:08 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Oliver Upton <oupton@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org, catalin.marinas@arm.com,
	will@kernel.org, maz@kernel.org, miko.lenczewski@arm.com,
	kevin.brodsky@arm.com, broonie@kernel.org, ardb@kernel.org,
	suzuki.poulose@arm.com, lpieralisi@kernel.org,
	yangyicong@hisilicon.com, joey.gouly@arm.com, yuzenghui@huawei.com
Subject: Re: [PATCH v13 7/8] KVM: arm64: use CASLT instruction for swapping
 guest descriptor
Message-ID: <aZ8s8NrY+/2sjgOI@e129823.arm.com>
References: <20260223174802.458411-1-yeoreum.yun@arm.com>
 <20260223174802.458411-8-yeoreum.yun@arm.com>
 <aZ4P-AcVjxfCFsew@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZ4P-AcVjxfCFsew@kernel.org>
X-ClientProxiedBy: LO4P123CA0137.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:193::16) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|PAVPR08MB8917:EE_|DU6PEPF00009528:EE_|GVXPR08MB10914:EE_
X-MS-Office365-Filtering-Correlation-Id: 883f58bb-2ccf-495e-8c13-08de7490e2aa
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|7416014|366016|376014;
X-Microsoft-Antispam-Message-Info-Original:
 KC3ERyll0JlekhcEmzcH45a4EypuzDefrOoTtPJ42YLULQIlfJtpjb+/aVY5iYrWB/eWVAdFMQD6rrUGVSPkrYxJZZ0eV17zNLwqde20ti0NnnKWskV02YrvSdkecWElCU2JTSv2XYl2gbJ2OEdJO+XZp8DPkh6eVoJQVNRSf/XbJlW84quXEdOd1ZQpn6VMA4rwIY0NnxAoJSgSdFyDlGeyo/GayO/Rn+m5eLavN3LdMVcBG1zOT8tCh07/XhI156aVfnh8A3Ip6AJBz5e8A744Jw+XkdB3KbdHkwug5JYceBWYlv1pyPbrxTYn+o0ZTcpFwM1UQcve8GD1HjDM8UzcC52BtOA1spekEVtisYuInAmL94fM4oF4ok0nvnJGcrfv7S2lRShxjLN6BaBZgfa+FLjOG0h7gYKdJz1NDHTzi2B5RUSNtClLXlA03uokDDXPagFfEugbab6OUMjqG+KtDIN1GEZTueGyjP1d/8EDv1NUk7PoBJnQsWZ+pcF8YYZbtmX3cf8n52cU8RoigepnY54YG4fqEFYVWATluTPd+i5k12zEnDMM8XswddMPMmhf8EOXapYtNBxLK5HR1YuAh/xzML/iosbyOrw+BPAXkCqsrMgqmmkMCrr44tbchO1Z8SLFFlDyeayLiIlLwsPjSS2FGV2Yron8VniqrsS4+IXu+0yqavdrdqrxn8UGYCB720zZnMmq+pVTxZB0XjfFi2wM8xw/CUbhpqIc4t8=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB8917
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF00009528.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	16b0388e-f77e-4eb0-c867-08de7490bc9b
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|82310400026|35042699022|36860700013|14060799003;
X-Microsoft-Antispam-Message-Info:
	7xusQM6HEnoDavme+OciAT8up3GfT1PBu6XKK5H27eN1VLvQy7wa37waGQBY7qIltyc5N0qKhwgslLip5rT3qstse3gmyJK5gvzn6wr0A6c7UOP55IgZZkHdGNpnCyQVqFGpx/y2taIJrKDVz6b5udBem2Vq3536XN5PTIKSL3PwvWBMBXEtBJbWbCBzel9ZShMP7JVWfkiblmu/ua0qnbKzPHwh3wr49HiOZ9xzuuCuWNiVr22AS+nIlAJvgrmZ7qeNR8xJAFLjMRF6V5vq6mZymBTMDEx1HQ0Ag0oZGTE0cZmebK85M5fithQ5pHiA53Y6tcqHD68mVw9Lvzm456RbY1Jm8ZXAZ5eziWMUR+IsnxuJh3g9+YTJLBb1dIe4+1qH48yt8GxrYiMf0dcweo7OdF1Mzsdcd6tfWNFd39cGG85XJTWz3wO9QenT+gD3WpKcXoCnsq8k6IZkN6yNMxEZaMxk+yBKit8BReiLTllS1//YuntaBRcodzCy/vyqysVjnOFEvAmIWThYbDEPa9wCTz3ajJFLysx2OqhW+rhRPCZgHNGpitooUK+wz08psetTC+bmxKn0gIrIWNAC6cwxc43S50Gk+vOMZDHDlxY3Kj9m1912PX7y3S0ddfWVt1siv4WWDuR0V5XsTweQgXkNEG4uU2/YpW7XE/WV+DjDG8W5CjVGvJ7k8TurDGDNgDD39xLy+PK4qRtC2RycPmOP0fUHhpQtX/SZzXx0cipvNX7mHGQ048zCU17WiRjipN1srXD7PKec2RA3VAkVmByWh/PCvOmfJhcZnPu18mFmGb5Np/HeyYhuQZ65Tnr1J324RAUPxCUtUOQJ0q3DiQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(82310400026)(35042699022)(36860700013)(14060799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	9s5YoEqtlPlNwxVF17dXnCQ5tkl4qRgoxgw1O1FlQLaTr/OQArRT97ZydeIir7aAt1FpjtXyCBs7XzYk62Pg43OMj1unPxF3pBB6x83R+YQy9BOLmZjtiSjX5C+cWUdl7CrNIUZ0vJP6acO9QxF5n7L852+r7cyjK5+9UGM1PzsXBMkR7VmIjRGLFIweAqYV+1qeRy9qbflj8y/X2MtmNxeIXdz9JN/D5XVle8iUQn6PL9fX7NWd6bFDv3jPPYr/cVCfBmQIxkGpBgIFWhL+08jiMB1tWdLgoH/b1Q8kJ+L5Z3jq1DVtI5YV0X/l6hdMP6EJ+Zh+cR+fe8hXnquNG/g4lPwiHdTQAQwhizANNjDb62EVfhxx8YJs+2MIAeyozxZdq86syhsV3yx1KqzhrJg/tlOge3/ifSXtB3QHIkRxX7SvXV8i8qXUHUS6wxV4
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 17:11:15.9097
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 883f58bb-2ccf-495e-8c13-08de7490e2aa
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF00009528.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB10914
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71852-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arm.com:email,arm.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,e129823.arm.com:mid];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[18];
	DKIM_TRACE(0.00)[arm.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yeoreum.yun@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: AC9A519B544
X-Rspamd-Action: no action

Hi Oliver,

> On Mon, Feb 23, 2026 at 05:48:01PM +0000, Yeoreum Yun wrote:
> > Use the CASLT instruction to swap the guest descriptor when FEAT_LSUI
> > is enabled, avoiding the need to clear the PAN bit.
> >
> > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> > ---
> >  arch/arm64/include/asm/futex.h | 17 +----------------
> >  arch/arm64/include/asm/lsui.h  | 27 +++++++++++++++++++++++++++
> >  arch/arm64/kvm/at.c            | 32 +++++++++++++++++++++++++++++++-
> >  3 files changed, 59 insertions(+), 17 deletions(-)
> >  create mode 100644 arch/arm64/include/asm/lsui.h
> >
> > diff --git a/arch/arm64/include/asm/futex.h b/arch/arm64/include/asm/futex.h
> > index b579e9d0964d..6779c4ad927f 100644
> > --- a/arch/arm64/include/asm/futex.h
> > +++ b/arch/arm64/include/asm/futex.h
> > @@ -7,11 +7,9 @@
> >
> >  #include <linux/futex.h>
> >  #include <linux/uaccess.h>
> > -#include <linux/stringify.h>
> >
> > -#include <asm/alternative.h>
> > -#include <asm/alternative-macros.h>
> >  #include <asm/errno.h>
> > +#include <asm/lsui.h>
> >
> >  #define FUTEX_MAX_LOOPS	128 /* What's the largest number you can think of? */
> >
> > @@ -91,8 +89,6 @@ __llsc_futex_cmpxchg(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
> >
> >  #ifdef CONFIG_ARM64_LSUI
> >
> > -#define __LSUI_PREAMBLE	".arch_extension lsui\n"
> > -
> >  #define LSUI_FUTEX_ATOMIC_OP(op, asm_op)				\
> >  static __always_inline int						\
> >  __lsui_futex_atomic_##op(int oparg, u32 __user *uaddr, int *oval)	\
> > @@ -235,17 +231,6 @@ __lsui_futex_cmpxchg(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
> >  {
> >  	return __lsui_cmpxchg32(uaddr, oldval, newval, oval);
> >  }
> > -
> > -#define __lsui_llsc_body(op, ...)					\
> > -({									\
> > -	alternative_has_cap_unlikely(ARM64_HAS_LSUI) ?			\
> > -		__lsui_##op(__VA_ARGS__) : __llsc_##op(__VA_ARGS__);	\
> > -})
> > -
> > -#else	/* CONFIG_ARM64_LSUI */
> > -
> > -#define __lsui_llsc_body(op, ...)	__llsc_##op(__VA_ARGS__)
> > -
> >  #endif	/* CONFIG_ARM64_LSUI */
> >
> >
> > diff --git a/arch/arm64/include/asm/lsui.h b/arch/arm64/include/asm/lsui.h
> > new file mode 100644
> > index 000000000000..4f956188835e
> > --- /dev/null
> > +++ b/arch/arm64/include/asm/lsui.h
> > @@ -0,0 +1,27 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +#ifndef __ASM_LSUI_H
> > +#define __ASM_LSUI_H
> > +
> > +#include <linux/compiler_types.h>
> > +#include <linux/stringify.h>
> > +#include <asm/alternative.h>
> > +#include <asm/alternative-macros.h>
> > +#include <asm/cpucaps.h>
> > +
> > +#ifdef CONFIG_ARM64_LSUI
> > +
> > +#define __LSUI_PREAMBLE	".arch_extension lsui\n"
> > +
> > +#define __lsui_llsc_body(op, ...)					\
> > +({									\
> > +	alternative_has_cap_unlikely(ARM64_HAS_LSUI) ?			\
> > +		__lsui_##op(__VA_ARGS__) : __llsc_##op(__VA_ARGS__);	\
> > +})
> > +
> > +#else	/* CONFIG_ARM64_LSUI */
> > +
> > +#define __lsui_llsc_body(op, ...)	__llsc_##op(__VA_ARGS__)
> > +
> > +#endif	/* CONFIG_ARM64_LSUI */
> > +
> > +#endif	/* __ASM_LSUI_H */
> > diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> > index 885bd5bb2f41..1aceeef04567 100644
> > --- a/arch/arm64/kvm/at.c
> > +++ b/arch/arm64/kvm/at.c
> > @@ -9,6 +9,7 @@
> >  #include <asm/esr.h>
> >  #include <asm/kvm_hyp.h>
> >  #include <asm/kvm_mmu.h>
> > +#include <asm/lsui.h>
> >
> >  static void fail_s1_walk(struct s1_walk_result *wr, u8 fst, bool s1ptw)
> >  {
> > @@ -1704,6 +1705,33 @@ int __kvm_find_s1_desc_level(struct kvm_vcpu *vcpu, u64 va, u64 ipa, int *level)
> >  	}
> >  }
> >
> > +#ifdef CONFIG_ARM64_LSUI
> > +static int __lsui_swap_desc(u64 __user *ptep, u64 old, u64 new)
> > +{
> > +	u64 tmp = old;
> > +	int ret = 0;
> > +
> > +	uaccess_ttbr0_enable();
> > +
> > +	asm volatile(__LSUI_PREAMBLE
> > +		     "1: caslt	%[old], %[new], %[addr]\n"
> > +		     "2:\n"
> > +		     _ASM_EXTABLE_UACCESS_ERR(1b, 2b, %w[ret])
> > +		     : [old] "+r" (old), [addr] "+Q" (*ptep), [ret] "+r" (ret)
> > +		     : [new] "r" (new)
> > +		     : "memory");
> > +
> > +	uaccess_ttbr0_disable();
> > +
> > +	if (ret)
> > +		return ret;
> > +	if (tmp != old)
> > +		return -EAGAIN;
> > +
> > +	return ret;
> > +}
> > +#endif
> > +
> >  static int __lse_swap_desc(u64 __user *ptep, u64 old, u64 new)
> >  {
> >  	u64 tmp = old;
> > @@ -1779,7 +1807,9 @@ int __kvm_at_swap_desc(struct kvm *kvm, gpa_t ipa, u64 old, u64 new)
> >  		return -EPERM;
> >
> >  	ptep = (u64 __user *)hva + offset;
> > -	if (cpus_have_final_cap(ARM64_HAS_LSE_ATOMICS))
> > +	if (IS_ENABLED(CONFIG_ARM64_LSUI) && cpus_have_final_cap(ARM64_HAS_LSUI))
>
> cpucap_is_possible() is where the Kconfig check should go.

Thanks. I'll fix with this.

--
Sincerely,
Yeoreum Yun

