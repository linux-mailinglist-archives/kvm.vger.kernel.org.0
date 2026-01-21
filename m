Return-Path: <kvm+bounces-68753-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wF1pLb0OcWlEcgAAu9opvQ
	(envelope-from <kvm+bounces-68753-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 18:37:01 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DD665AA2D
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 18:37:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id CB35E769EF7
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 16:44:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA4A6477E5A;
	Wed, 21 Jan 2026 16:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="rp8u9LOj";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="rp8u9LOj"
X-Original-To: kvm@vger.kernel.org
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013048.outbound.protection.outlook.com [40.107.162.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447704A13B7;
	Wed, 21 Jan 2026 16:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.48
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769013173; cv=fail; b=Kf43A001KS6/CHg6GCSqRWBe1w37nyJJAvQjLh1ZUVM2zGO5zLnQj4fBUpRLhFg+AjHcx+pHBytYNFw6qULpzWofM7XRpthsnZVKtukdez4BHKD6VDSILxRg3+WcDOEXVKOrbvp+VwTNCziqReTaYbmiu29oBzpeTEqL3QAkLj0=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769013173; c=relaxed/simple;
	bh=OurYZzwqhRfrXrAMCoPOJCWr+8ZwVozgD29Wcev2hjU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=PZgtJCPZdYrIC2vgKUEDHtOtjY+qzQA05YUSotaSlvH14tD5qq//IoLLL4hKpuNN31tYpz9cLaj7wVtQE5mUAanRNRM82REV8Uh/S/21tMbe3DQRXrMzg8EgrD51uRzkZWMhhD1HlotBoLZfgsxkuzMjlhx37WxfY5x34nOOlX8=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=rp8u9LOj; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=rp8u9LOj; arc=fail smtp.client-ip=40.107.162.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=gVo+mld/B4KUa0k9srJ1p53owU7UgUbAH9fGI08TQ77jlGPAX0snTBF+lh49UTM0ULh7PA/HgLVb0jN0eS/unuQnYa3TlijncE55zkamzA7x8+KntZcEvLaUAjCVfDcuGBQBZUrjEOuLA7HhtAGogAIkY67ow4KFJyX6H3rXAXz2Ju61zP8DGf/kXzie2j9RCEO+nU/pP+4QzM7X5m6itQI132m8FY6ih8YsGrYVC+dK5cNuOn6+yjjVmwaIWTGT8Xmyun32TTUqug/XlHZJREQh/ppy5136091ab+gsNLIN1jYedMiRDswl6FkIy2jXIEHxJ91vcgmehv3b/mjdWw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W6gAPwmSRUx52KxgWvKrA7HkdeH85BN8162p2G4mwxg=;
 b=ebDILpgVSaf26wNffUmpn/QohxIQaLcJGvlXXBCJvG3jWroCkMYepSxWKc2WkwG/TveMEDgcC8PBStyvLFZ2b0qTz7SSzDS2Bz5TfTpNz9Sw/FZfj3elJV4AHXkWWP7RLIXtd7Jsb8ZlDJbzeK2TyarGHg5c0r17eAWi+sQ5zBdtbsEX4075EmBB2U60DuXdbU4xiMjjH6InG1bEV1wBH1uBzQAcjCmIAB1SW7IfF9TPjMgs9m1VquUKtKoB2BI4BTSYEh+tURGJI/rV4Wv9BVaPb+z/C+YjXx699MsNILcg8K8LC4QGcp6pFSJSwSMYkPM3pAbsAxOGWzEVswrKWw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W6gAPwmSRUx52KxgWvKrA7HkdeH85BN8162p2G4mwxg=;
 b=rp8u9LOjf+c+IlDRkwgCf45FnkXIhFps1m9qLmNWlinwKhOV/sAbsKwItMrR+RQbDDr90ajPizyZ1vGc1rjyABdGHQI7IRC7ygJaReH5pF4WiHfclKbGgz1vOTkENCi2ikJcOC2IAqZS3ER0c1zFJQQf7VWSDqrAWs23G4sUHCA=
Received: from DU7P194CA0015.EURP194.PROD.OUTLOOK.COM (2603:10a6:10:553::10)
 by AS2PR08MB10267.eurprd08.prod.outlook.com (2603:10a6:20b:647::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.12; Wed, 21 Jan
 2026 16:32:39 +0000
Received: from DB1PEPF000509FE.eurprd03.prod.outlook.com
 (2603:10a6:10:553:cafe::31) by DU7P194CA0015.outlook.office365.com
 (2603:10a6:10:553::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.9 via Frontend Transport; Wed,
 21 Jan 2026 16:32:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509FE.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.1
 via Frontend Transport; Wed, 21 Jan 2026 16:32:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uG8w+EMqqKfmosbIefU/6djFdga50u+2okDIjso4obNOBTWy2LBjW87Jr/FKtjETuZOfW1r6oAesUk5OfMMpO9xuUxBjk/Gl0k11QzBB3zBJMpUx1VVDIa+cZU31DyHmOueuWEiKuReGNTppuPzQiUXkayRjRYvf9P7RMW64AqoCc/UbmA0XwMKlGajPJTXA0ayT3BeTBIsYzcKLaY1PgSl8FMmQUOm9fIqS8mK8+2a9MkpUpbo5bQ6r14nw4Gvkm3qVt6S8rXclo0WfZ+rJNbIVQOpRCBFc7RVZbQFhx9spewhNI9kj16HSD1kk8oJYVwT7Hzntue+0aRvNB4zKvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W6gAPwmSRUx52KxgWvKrA7HkdeH85BN8162p2G4mwxg=;
 b=rJTAc04F0ME7VXCojKldQHSEig7rMWmKNH85y0iXkUNujt+DuMKN+2jjTH5LYQhWhj0mptP9NbjlR5VlXh8qQ2ia6H4h0yTCx2cSk4E3cyJz1ycSTYouj6bK1fqtQbvXFqdt5mxCWd5tvWjs1w+0T3IV31ks0v/LXFtBN1Ki/Q6HSM8dt1f0rTrXsqTTF0UAUsYOsqbnfzLY5mWJtryP4/yysVkqJioQHlMnDMzpsvDTrujLvmdWXSLvyJT5a4bPXnfGTUSXXLuq595RQYAwk+hPpLWtkiBkdsDsndfsRK9L0/Q8jxOQD/jLmjUX1Lm6ugECawqXCbfiK9zr5AIr0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W6gAPwmSRUx52KxgWvKrA7HkdeH85BN8162p2G4mwxg=;
 b=rp8u9LOjf+c+IlDRkwgCf45FnkXIhFps1m9qLmNWlinwKhOV/sAbsKwItMrR+RQbDDr90ajPizyZ1vGc1rjyABdGHQI7IRC7ygJaReH5pF4WiHfclKbGgz1vOTkENCi2ikJcOC2IAqZS3ER0c1zFJQQf7VWSDqrAWs23G4sUHCA=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by GV1PR08MB8569.eurprd08.prod.outlook.com
 (2603:10a6:150:81::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 16:31:31 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::8c9b:58d2:2080:eb98]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::8c9b:58d2:2080:eb98%3]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 16:31:31 +0000
Date: Wed, 21 Jan 2026 16:31:28 +0000
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
Message-ID: <aXD/YFNirTfoATvN@e129823.arm.com>
References: <aT/bNLQyKcrAZ6Fb@e129823.arm.com>
 <aW5O714hfl7DCl04@willie-the-truck>
 <aW6w6+B21NbUuszA@e129823.arm.com>
 <aW9O6R7v-ybhrm66@J2N7QTR9R3>
 <aW9T5b+Y2b2JOZHk@e129823.arm.com>
 <aW9sBkUVnpAkPkxN@willie-the-truck>
 <aW/Ck3M3Xg02DpQX@e129823.arm.com>
 <aXDbBKhE1SdCW6q4@willie-the-truck>
 <aXDn3iRXEtgaUtnp@e129823.arm.com>
 <aXD81LT6TX32vlTS@willie-the-truck>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aXD81LT6TX32vlTS@willie-the-truck>
X-ClientProxiedBy: LO4P123CA0259.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:194::12) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|GV1PR08MB8569:EE_|DB1PEPF000509FE:EE_|AS2PR08MB10267:EE_
X-MS-Office365-Filtering-Correlation-Id: e696a115-7b98-4038-db7b-08de590ab104
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?VXNzdGJvSEJudlFBZGhDNDh1UTNRWlBDNTNEbnRCbWlFN0xiYlBScmpxekNa?=
 =?utf-8?B?TlhiSVFKdGNQaHBQWXVNNTVDNUJucW5sZ3VGTUJjclNiR3FzSEdrRFZVTUtx?=
 =?utf-8?B?WVBOQnBCVisrbnpQemdzR2QwK3JnVkdnZzV4Njc3NUFFWTlXQ2hlZzV1ZzNP?=
 =?utf-8?B?bFdzN3dYZncyR3JCL1JrUVZ1RHlUb0l6RlljdWNHUjhoLytsTDl5bEFVWXhO?=
 =?utf-8?B?L0FEUFhEMGl0NTdLcFIzVHVLTmdWZHJtc2t1cldSMVgxQ3VjeHJ3S2lnQ1cy?=
 =?utf-8?B?dXd4ZCtDL3hBbks5VVJmT0RtRUJmNzZqNEF3dGtvYW9SVmFITlUrenZEUzh5?=
 =?utf-8?B?OW03T3pLc3ViUktIN2FQTU1xeGNaZVBUWkdNNTFCMlRmdXc1bXUzdll1ZEx0?=
 =?utf-8?B?ZnZ3WnQzSm01SVhGSkthdk5Sa0JsV1hmSzVHTGd3WFB3OWdUbEZzN0N1VEx4?=
 =?utf-8?B?Y1Bhc2w4YW9RZTBSb2dqNnFDY3RxbGpsRm01NHIraVg3K01BWGM2dGYzeDFY?=
 =?utf-8?B?cVVLc2sxMU1HbTJrUXlkRzd3TG9Zb1BlNDJJV0lGM3pqYXdWVEFjM2VEZmww?=
 =?utf-8?B?SEJjaW9NWFArcGMvN25zTktpMUdDMlNwczlmK24zcjJiNzdHZ01QQURpcytx?=
 =?utf-8?B?N0t0aVBiNzNnZ1dZaTJEM2lOVEJFRjJNcTJwUTBpSWlteFFSenpXVGZ5N3Ev?=
 =?utf-8?B?MVB2UDVYcEVqNzF3cVBaYWVYdE82azdHMGhIUGdNU1cwanEwYWM0Qm93RDd0?=
 =?utf-8?B?MmQwSDNkTWE4anJBY3dKUnBycHRUekFWUExhQVlEbW50NmUxcGIwR2VsSDlW?=
 =?utf-8?B?eGNYN25HbjlIaStDY2JPcG1rWEZzd3RCVmV0S3FzemNLUjdBbFFkd1NTaXlu?=
 =?utf-8?B?VzcwTWVRSHdicksvUDFwZFk1eXV2TWRNeFdRNDBHVHhkTThGQ3BRQWZXS2JX?=
 =?utf-8?B?Tml1MUVNUXZhL3grS1VIMXF2dmhVV3FtMkNaSGwvdmlpKzJJdXRPdGFtejJo?=
 =?utf-8?B?bFU5UTgzcHdHSTl0ek9LOVhTc2wrK0JnaWZuaFNVMzB4U0hMRUZtenZXVCto?=
 =?utf-8?B?Y0UwOG53aWZYZ3BIK1dSSkQzYzRWYXVlQlBIM3IvMkRodE9uVk83MDNRK1pr?=
 =?utf-8?B?ang2YnVJZ3YwdFJEN1NZR3VoS3oyMHFQWVFzeU5COWNnRlF4a1JWamRzaGRR?=
 =?utf-8?B?eW41LzdsckhxMk1ad3pkWWw5ODZtOGIvbW1iV3NHcmtyWVF0N3N3RmV6c0lO?=
 =?utf-8?B?eHQyZ3pwRThRY3I2TDdLQThzbkVueVZrN0c0U0N2Zks2dmlLa0tsVmg4K0Vj?=
 =?utf-8?B?MHFZYTVHQ0MvWTRVNmpaNzF4WFFXL2V0eEQxeHpUcm1RMi82Tm5MbW50NjY0?=
 =?utf-8?B?bFhtVHpPVGlXVlVTcmZTY054c1pNUmFreENPczFibXRiZUYxU0tydUFFQjBJ?=
 =?utf-8?B?eHZLYkpxRUFBRENoQXpQWmdSOHRKc0o4UFg2NitFR05YeG9teEo1Z0wwemp0?=
 =?utf-8?B?WWNhNVpCcU5EMnFTdzNmTTJXWXBRbGx6ZXRRbGY4SGVPTGFlRnc0STJPdmZ3?=
 =?utf-8?B?TVk0Y0lTdThEVVFaOEI0THdIZEh1enlWZDdiQ2lGZ2FQeStyQy9QL3FlbGx4?=
 =?utf-8?B?WlFIdGl6S3hWdHVDZUhHRHY1enNidHFULzk5dVljeUlpVjgreVoxRDZjMG9D?=
 =?utf-8?B?MFNBcUxZMjNzZEtJTm5xR1YwMndqVmFLZklub2p1Q2VZeElEb0pwNzF2QTly?=
 =?utf-8?B?TXNYekJXTnAyYkRCdEhiNG9ITG96dm9CYkNHenJBbXlJY2hqT2UwOXdPQmU1?=
 =?utf-8?B?eGl1SzVlUXBnalBiVnd4NHlHQTNLS09pdStSQ3gwenBmbDJDK2VuNW9LU252?=
 =?utf-8?B?VS92VnVPeUt4c0V6YnRsYVY5ODhYU3g1dmJDajlubmJvZDNsYm5KZVFTSkh0?=
 =?utf-8?B?RWdxV2Ewc3VUblFMS3RUMFFzSG5pdmlhTWJZcEp3REQ0Qkpib2Nscjk0Vy9U?=
 =?utf-8?B?d2FmUnhqNEdieVF0ZDRqNGZwRDA4OG5SMVJyNXBMV0VXbmovT01uM2RzZ1NJ?=
 =?utf-8?B?M2RnRnE5VDVJeGNGaHBHK055V3BtdmJlaFRGRmVBRk5oc0c3aXErVER3YXJR?=
 =?utf-8?Q?Wu7M=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB8569
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509FE.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	303694e4-0031-4c0b-d5a6-08de590a889d
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|35042699022|7416014|376014|1800799024|14060799003|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?N2t0aGVOY2Fzbnd6akhIeGkxQmw1STZBRUExL2tsK3ZYNGhuRCtwZjJsWFdQ?=
 =?utf-8?B?VzRlb2pjMGNUdnh0czFwQmVoRXpQYXJqYnNVRGlsMDMxVnp3K3ZRaCszV3lK?=
 =?utf-8?B?SGc5RVVuRDMvV2VxMkZTVHVCejVkdWhBVStrQ1BHNzNxVjRzSkdWSGlUVGoz?=
 =?utf-8?B?RVJqQzhCMWRpZERDN2o3bHFteUNOdnNGZm1Id3BCcU5JMHREMmFvVmxucWVN?=
 =?utf-8?B?OFRhK1NuSUFrVDNKdEJXSitTNjhTeUNtZXZyWjZ3dmNiNzFjc3JQMnVNZXl6?=
 =?utf-8?B?NG50N1pVajBqL3BML09td0hWV01OUkdBc0h1U2Mva2FjT3oweGJLWkF5dUxm?=
 =?utf-8?B?U0ViZ1lvTHB2TVN1YXNHYkY1K0d6RC9DNlVFRDJPTUE3a0RUSTVtRVlTN3ht?=
 =?utf-8?B?cHhMcVVUSXowRnFqZGgzMldEcUtsVTBpME1CNHpPb3RySlFyVWV5a3ptQUx2?=
 =?utf-8?B?VFFaREJGUDNyczZGQjhWSHRQVW5RTVErYlVSQWVrOENFakU0Z29zWFZSdXM1?=
 =?utf-8?B?NDBuT0V3WmNkUW9jT0tPN0FnbGRLWHI5OG5zZUxuVFlKa3lBdTNyeXZoS3ZH?=
 =?utf-8?B?MHpTOE1mZ0FxaVVqSUdzckl0T0s1elBFYXhSeHByZVBZdTVVOVAzdFp3Z1k5?=
 =?utf-8?B?WlVLUlZYcHBJczJWMk1EclAydlZFSkhmKzQrVDdNZjQrRTdGV0JVbG1jTzRy?=
 =?utf-8?B?cUk3OUdtb1pkVE1tczhzZXl2VzBPUWt2K2hER29tZFFkUzdPZXBBOVFUdm5K?=
 =?utf-8?B?LzU0TXdBdTlwRkdXODA5UUk1MFFMMlhrWklBbms2dm13eUN0VExGMjM2Wlll?=
 =?utf-8?B?NmZOaFQ4aXVrUy9qUENUOFNRS0U4akNYWEdDKzRQOEtscEdRNGhmUHRsQWto?=
 =?utf-8?B?Q0lHTjQxa3U2eDBZZWF4d0RDU0JZZEFlUmQ5d3RWV1BjYVFGYjJERC9ndXV0?=
 =?utf-8?B?d3V1dFZzeW44N3N4MWk5VWJIa3Rvb21pQ0pvTDJwZlV5dFI3VEgvb3RLaC9M?=
 =?utf-8?B?dzNyN1c4UmR6bGp4MkpKWjdPRkVTTWNUVWFpVUpIdGJ4ZlcvczgzTE82aENE?=
 =?utf-8?B?VTVTaG9pSXgxcVJ4OFMwZkxWalMvNHU1WTAzZ045blRxUmZRbUdtOEd6ODJk?=
 =?utf-8?B?dHRHUW8rcmRUdFBjY3ZaVGFrd0ZHSGQ0azU5c1NMSGxhMmRHRlpkR2NKMDlk?=
 =?utf-8?B?TkpLQitReDlLNTVWcGxKeVhzRXFqeHhaRnRxQnVuV0FQbDNSYjV1RW1wRGxk?=
 =?utf-8?B?dkh2WjdvRUFJMHNOMllaZDM0NXNWNEVtSWROa0RhbTIvY0lReHpvLzdOcTll?=
 =?utf-8?B?UUt1ZDN3dGFQU0tzeXUzNXYyK2l2a3pOTFRYMWUzc01sMGVQQkhkanloWmth?=
 =?utf-8?B?QmYxd2E2WlRqNE1HY2ZrRzQ1OENaU2d3TUdDOGpZNUlVNFFQQllBOVpkVGUv?=
 =?utf-8?B?alFjVC9FR0RhNXZOancwZkNGMGdjbGZQeGVTZFdha1BXaDVwa3Brc1VMTkFn?=
 =?utf-8?B?V05tcjRUeUVPSy9ISStET1EzL1pSSGJjNzJUVCtBT2RLZGNtYXBzYzF0MHBG?=
 =?utf-8?B?NGRnV1F0SUxUdEZQRlc0aW1DYTE5QktRcVBzUUZaUytjdW9IK01oTG0yV0k1?=
 =?utf-8?B?NitDS3ZNSmhoMXBEZEt6enEvUXBlZnFrMEJwY25Zc1QrUWZQUEJ2Z0FnLzll?=
 =?utf-8?B?NzJkSWhGZEdFVHZ5UjZ0ME9qeXllRGdERkFTdGtWZnQ4V2VzblMwK1dsdFNS?=
 =?utf-8?B?QXpGcWpEVXBMTFljS2lGeUZCYVZXL01oaXlDN3IyY3lIYWIyOU5RQndWdFF0?=
 =?utf-8?B?TG1QdlJ6Q1BBVXUzM1JGZFArN0lXQ09oMjJxTklMZTFWdzZlangrM09OMzFw?=
 =?utf-8?B?SXQ4VjJxNDhoaEN4dGtqRW1iUGhyZlB0L0JIc2VnMzNRWVE4aFp5S09hcFN6?=
 =?utf-8?B?TmtWUkFiekhjdDRTblVSYXV6aVh4WWdJbUdMZHZ2Ty9GeFp1STdFK2J3Y2gr?=
 =?utf-8?B?S3J6eGk0LzE0L2FJQzNpRWNvRjJpZWJONUdlQi94UjF0aHVpbTAxUU1uakZB?=
 =?utf-8?B?Zy9Ja2J0d1piZHpaZjUvdTliSk1aTmc3KzR1ZDJ2S3lyVlFEMGxvTkpTeFNW?=
 =?utf-8?B?YVJVYnRLaExUOWNHc3hHbXFIMFJzeDFuL1ZzSENSSWsvaERZR2ZWMUM0Qnhy?=
 =?utf-8?B?N0ZMTjd2ZmQzUGJPUjRhd05uUVJYTmo5K0dreG5zb21kaFEzd3hZc294Z0FB?=
 =?utf-8?B?amRGNXJLYndTemo4UHhqc2k4aU13PT0=?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(35042699022)(7416014)(376014)(1800799024)(14060799003)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 16:32:38.6635
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e696a115-7b98-4038-db7b-08de590ab104
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509FE.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB10267
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
	TAGGED_FROM(0.00)[bounces-68753-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[arm.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[e129823.arm.com:mid,dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo,arm.com:url,arm.com:dkim];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yeoreum.yun@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: 0DD665AA2D
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Jan 21, 2026 at 04:20:36PM +0000, Will Deacon wrote:
> On Wed, Jan 21, 2026 at 02:51:10PM +0000, Yeoreum Yun wrote:
> > > On Tue, Jan 20, 2026 at 05:59:47PM +0000, Yeoreum Yun wrote:
> > > > On second thought, while a CPU that implements LSUI is unlikely to
> > > > support AArch32 compatibility,
> > > > I don't think LSUI requires the absence of AArch32.
> > > > These two are independent features (and in fact our FVP reports/supports both).
> > >
> > > Did you have to configure the FVP specially for this or that a "default"
> > > configuration?
> > >
> > > > Given that, I'm not sure a WARN is really necessary.
> > > > Would it be sufficient to just drop the patch for swpX instead?
> > >
> > > Given that the whole point of LSUI is to remove the PAN toggling, I think
> > > we should make an effort to make sure that we don't retain PAN toggling
> > > paths at runtime that could potentially be targetted by attackers. If we
> > > drop the SWP emulation patch and then see that we have AArch32 at runtime,
> > > we should forcefully disable the SWP emulation but, since we don't actually
> > > think we're going to see this in practice, the WARN seemed simpler.
> >
> > TBH, I missed the FVP configuration option clusterX.max_32bit_el, which
> > can disable AArch32 support by setting it to -1 (default: 3).
> > Given this, I think it’s reasonable to emit a WARN when LSUI is enabled and
> > drop the SWP emulation path under that condition.
>
> I'm asking about the default value.
>
> If Arm are going to provide models that default to having both LSUI and
> AArch32 EL0 supported, then the WARN is just going to annoy people.
>
> Please can you find out whether or not that's the case?

Yes. I said the deafult == 3 which means that allow to execute
32-bit in EL0 to EL3 (IOW, ID_AA64PFR0_EL1.EL0 == 0b0010)
-- but sorry for lack of explanation.

When I check the latest model's default option value related for this
based on FVP version 11.30
(https://developer.arm.com/Tools%20and%20Software/Fixed%20Virtual%20Platforms/Arm%20Architecture%20FVPs),

  - cluster0.has_lsui=1 default = '0x1'    : Implement additional load and store unprivileged instructions (FEAT_LSUI).
  - cluster0.max_32bit_el=3 default = '0x3'    : Maximum exception level supporting AArch32 modes. -1: No Support for A32 at any EL, x:[0:3] - All the levels below supplied ELx supports A32 : [0xffffffffffffffff:0x3]

So it would be a annoying to people.

--
Sincerely,
Yeoreum Yun

