Return-Path: <kvm+bounces-72137-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8PlJEjJxoWm6swQAu9opvQ
	(envelope-from <kvm+bounces-72137-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 11:25:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FBF31B5FB8
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 11:25:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8EE4C30CF03C
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 10:25:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F2063D3484;
	Fri, 27 Feb 2026 10:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="STbyiFUz";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="STbyiFUz"
X-Original-To: kvm@vger.kernel.org
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013027.outbound.protection.outlook.com [40.107.162.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB233D1CBE;
	Fri, 27 Feb 2026 10:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.27
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772187904; cv=fail; b=OjvGkBihBWzUDwn6hLq/PfBrTp+Q/2FzRDxiw0cjyotZHyqkiYZPwojsBJ+Waonsf7+oI808MRhxxbS811d3VyLZ0rrBY5C518qOVZqNdcEnkMbfnvfebSc8xIkjmBhrXXPxHEOVkqUmPvQB+B7A0KGXcd/bTtFCRNjhdKzJwJQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772187904; c=relaxed/simple;
	bh=r5y3+ciMJeAWRvE+G1JEeEIeu+eMGPlgTPH0QjwHosw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lQr0SBZjhGecNm8bltj4ddlT7EnXBVpG4WXmOq0lLyhxwMyQ/V6WHttT4ff3vvvmGBm8QmHYeE5vkfAA5ORmXc5kvbChfzDLsE4Jote+4Gvj93P/lVlD30WtpaeCUbM0+YXVsCdV/5bRyjm2H2QJf4olGsjE1KgnDgLin52ST1M=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=STbyiFUz; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=STbyiFUz; arc=fail smtp.client-ip=40.107.162.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=vEPHtXIZ4Q0kGfGoj9t4+a+1U4EeT3T0RwHaZtBnHqz25fiBjUzT8Kc7/RYk7dr8URkpXF95f1dtJGgehLHZ7fvG1kVLvGhu3GsWJenegY/qVRHrgnfY8l7x7mb7Mbi91VLv7fIiJvqhYi/LscflmXAgA6PJxst0nXWmUoAoAVn1LwzeinoZLke/TQIXJCMao/Ib5xgT5xUS6GXtr1UAinUANMSo3/wP9d6lHHORN8M6jpwEaKgpS1YZ/IK8y3EuE1qNK5HND8+8CoguLicjJVz9AF78XWwHojv9boI+BO7vbKVEy556C7/0vAfxg0T+5jt5VQjn3cGpD/hwXVi2Kg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RLQGDJTbAb9U8Hqc/oOFdfN3t8LP2WEYgZt5uiGKUYc=;
 b=tob7XRy+iFrgLQV2lnztR95/1yQ7GvAQ9wUAfxfbBXMgicUyRnhIpyM44i+QR/ezkKRO5vZQrtgqJrWJea6m7eWs3fvEXL/UnRA63Q8Vi64UuVVvlfmDBa8beFvG3L3KRD63gaygWlFRvcoXPFDQ3lRgsCwyEuB/551O+IuhuhgR5ds+ZvvmNRRNqYjOE5secED93WGYZnzYY+hVbdhO78aTl4D7yqXCWUGEsb/0o/V6qAtt4SfOFZadKImti0fbWdToKu/zNs/Qu2PDlMlyoC/zJao8htAExiQ/NIEGiuAJGAbS+oND82nafcqtW0sv7W1aQwZ/CFHRtAV6VBLqgg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RLQGDJTbAb9U8Hqc/oOFdfN3t8LP2WEYgZt5uiGKUYc=;
 b=STbyiFUzCvWBYJgSb70SaA1wWhTFmWTWXXHZx6tXRsQrRSg6JwI798OTOi1NkcETO35WbX1uEBpEoRy8Gq6A/YNiExNu/wEEY8jB0Im7gKjFDhk/Rr2E2I3hu1o1e7g9a4WYLgnUyjOba77Nu9DqLFUaFQdmDgubMnjZwEvkcUg=
Received: from DU2PR04CA0181.eurprd04.prod.outlook.com (2603:10a6:10:28d::6)
 by DU0PR08MB7390.eurprd08.prod.outlook.com (2603:10a6:10:351::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.15; Fri, 27 Feb
 2026 10:24:57 +0000
Received: from DB5PEPF00014B8F.eurprd02.prod.outlook.com
 (2603:10a6:10:28d:cafe::88) by DU2PR04CA0181.outlook.office365.com
 (2603:10a6:10:28d::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.26 via Frontend Transport; Fri,
 27 Feb 2026 10:24:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B8F.mail.protection.outlook.com (10.167.8.203) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9654.16
 via Frontend Transport; Fri, 27 Feb 2026 10:24:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rjIra7wwN3d74r6WeLJudtqfX5lVS+tAKGxPd8XYFEbEOCQzBZeNqlUaQ+RPVDx/8Q79zDlXen/5K9RK5M9NMtLmla545UlX1UPKCHAL//95sTPdfPeC2nFHPTEyvygiqxO75gKk/DCZJqvZm1GN3cBeZQ16Vzm3i1ETKDuLt/dRJFMER09KE5/DFxrjHSUEOsigXMwmYYAuVc4Wg/PXBTD/C2yiJjKazjQ4QeNt5ISRTo+2ZacHgfDPEjN0Sc0khUf0dFGq5YT8gTWMhPa2CCImoqWCUyypdFcGzA+WmAo2mDZauzWT/K2RT+rgdvHlVhPim/xWhaKDXUmABE31yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RLQGDJTbAb9U8Hqc/oOFdfN3t8LP2WEYgZt5uiGKUYc=;
 b=Prh9H3LS41ZzAYnIDbvnpvXkM4hNO4tferiwNgSMGrkNvgPYqacp5ww6vkLOT/MswMzgkSF1muog1+1bVFv0exMo1/PDX8/sCpQ22oO+RXcxEfxlDlA4XcKK7cCaBY7C5x86cwJcPSQGc/Oru9o9VgwkFG7bSQnkwBwMdmVZPKOheTIAl3BL577Isw6r9VnZp7LkSoyTB4weDz47tiNG2rkV4OZADK+R8peZa/mqt4q50gGd6AnAHcKDWSWpZ6Cap/5kQf1rnYXq5lAKt8ard4LglETBraphGGj24Tt4I/hfQ6HK2Z7HkIuHibgJlfiv60P5uSC4jd4oxwvdJUDN6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RLQGDJTbAb9U8Hqc/oOFdfN3t8LP2WEYgZt5uiGKUYc=;
 b=STbyiFUzCvWBYJgSb70SaA1wWhTFmWTWXXHZx6tXRsQrRSg6JwI798OTOi1NkcETO35WbX1uEBpEoRy8Gq6A/YNiExNu/wEEY8jB0Im7gKjFDhk/Rr2E2I3hu1o1e7g9a4WYLgnUyjOba77Nu9DqLFUaFQdmDgubMnjZwEvkcUg=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU4PR08MB11769.eurprd08.prod.outlook.com (2603:10a6:10:644::21)
 by VI0PR08MB11082.eurprd08.prod.outlook.com (2603:10a6:800:258::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.15; Fri, 27 Feb
 2026 10:23:52 +0000
Received: from DU4PR08MB11769.eurprd08.prod.outlook.com
 ([fe80::d424:cd62:81a8:490f]) by DU4PR08MB11769.eurprd08.prod.outlook.com
 ([fe80::d424:cd62:81a8:490f%6]) with mapi id 15.20.9654.013; Fri, 27 Feb 2026
 10:23:52 +0000
Message-ID: <90bac820-7c15-4528-9d7f-3a8a4a67fb10@arm.com>
Date: Fri, 27 Feb 2026 10:23:52 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [kvmtool PATCH v5 02/15] update_headers: arm64: Track psci.h for
 PSCI definitions
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, maz@kernel.org,
 oupton@kernel.org, aneesh.kumar@kernel.org, steven.price@arm.com,
 linux-kernel@vger.kernel.org, alexandru.elisei@arm.com, tabba@google.com
References: <20260108175753.1292097-1-suzuki.poulose@arm.com>
 <20260108175753.1292097-3-suzuki.poulose@arm.com>
 <aYoCiXg8pSC_bwIv@willie-the-truck>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <aYoCiXg8pSC_bwIv@willie-the-truck>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0114.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c3::18) To DU4PR08MB11769.eurprd08.prod.outlook.com
 (2603:10a6:10:644::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU4PR08MB11769:EE_|VI0PR08MB11082:EE_|DB5PEPF00014B8F:EE_|DU0PR08MB7390:EE_
X-MS-Office365-Filtering-Correlation-Id: e3128496-5958-48bc-fab4-08de75ea74cc
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info-Original:
 4/I7n/eIEzjlOQtWI5mbPFoLfSAT/bi6I5pGfphac5HpgfKtYqy2gpHtspoUKWJgh1zhZRCin96+yK6Y5pHoQ7UKTQ1ZfG9WfrENo7S/jXLLXHi5fr6ITwPL64PA5ZFVQirudGVmFdjdms8z8j13X4X3TVfz78BZ85qiITu4DBieHJblkGpBnihb/vSq1u7X2R3SAXnLEEZfD17jwtKCWbm8GZLSKACm/+q8FiRiV7+s8Ox80ooJw1rl1zwkdiu/B9pcSrqgM30Ia3gcu+q1dh50Mdn5rwIRHnJpOVINk3hYjmAgUCe07KKXWnzVRef+ZeJYrbjZvTipgt5l3nFvtaJOLV4RRhr0/E/hiqXbjrmlDRcf5FsnZ6yCgjbr8TN1vp9EmmRAMA0UDp0+HLvgJUR6Yn2nhhLY/OXrSEcC2cJfz0OYyBl3Q30m1vyUas5TLdjyyo6XXl2ypqLdUMAG6lTOmk95RG9I3uE5Xah2wD9yunwIf37bO/5W9T8SZgQOXH7Qgu2YuxB1qNIlzPdUE8hYJ8Pc8lssGya2na7WAEPxZLDuJBHX0hGBKM1SnIHwztz+wLJsQqPGppMOJ/16GntEp632FHEbNnTF/gXRws+1QWQrET1t/R2irKweA3cYRuBXGbth9sWDYIHptU1RZaXV/qQqWX3S3kE35XI5GTTQZPegurPYl77jcmVUugzgMnuG4N2DB6zUEE6BxLflkTKrCvCxRRcZLjMmuKiqwiM=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU4PR08MB11769.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB11082
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B8F.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	6994be59-109c-4cdb-e83e-08de75ea4e30
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|14060799003|376014|1800799024|35042699022|82310400026;
X-Microsoft-Antispam-Message-Info:
	bwBMHuqaeXFGcX9zIiLe5c8C2TzJniAsymaljja4Nr1CYmtkgN1IxEXiv5rxialqmkdoSiUb+IJVkDIQZErhStmOntgWV5hyWRmLvbBlR0CbVJ0myVXWex5dDj52vvcsb945X75wyne+API8VMka/Ak5lC4NIdtwuYcjCRppkQ52HQ0EDfUyTeKochPEh24bd9OLsjP66HRdzZQu/VGMzybwUdXsgFF9KXIcjcR0XXzwKV/25GGIRsf93hQLVwpPS7p6T8/jhB/YsG4s6RmcA3ReuFCWZvKT5XmC7sOU7Q7KbkOJEomKfrwkI0B4iCH0D8KjSA0mAMn3qfC9WWQNCUuYjBPKoQ5VfsGxRnXmS8LjLIO/MUNmcb0EjWZ6qP3WiVg8+AEUMOiukgtykinCsN+oAvk4TNfysqi1j+8dNGLW6P+aIS9kRmXV3kejAaWghF1KoQJyIKbX73XodHKClmAspn6vDYMuzmG+lwDkkdH6H/6k0n7VvZ9/okMfk/m7iwknF0LcLax97OfNwPkObboLx5PmKQQcbdvGpQiW6tO8yT0kUtFXU9L9WPH8GnvT0IwoelrmxQ0RUpPKuq3sBLtTPgiclyTgcc/K3ZefWypMKh8d+0Nb/GxfzoEnI3+ro2TPivmumaqu685jLHYbRLzPvJimZ4tgQJDFWHp/ZFE8JyYNXWnphEdc5cPvsgGybrL15v9S//t8FjuAOnOhR5YcMTdSzqojhZty3tGz55rObWu1W0nn9YkxdAYlV2SSh8eDFXz2GkWwgGc0Wx5/ox7D5sl6RNgz7fFHEekSeXgWWBUbBnykbCDWcKRQ62FNAPfiMy/8mhmE0udRTSiQhg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(14060799003)(376014)(1800799024)(35042699022)(82310400026);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	I6cLdNT7m0Ad2iMLRbzwoZDBCdwM8CR/UA9nSySjt+hLJ5yyC4ntrwr1a2/6S/dY0nf5BRmsFNtaIYGs/elNP65CDCrdyoNBwHavfojrjF8CyPppxlqJCMHuVSYd8aA0QtUhw75Xt6dB/qhtILZhwbV27i2Du895xXKKBoCeJidDiCBQaabZoQOmhXhhfwBcZGNqffIFTKuII0cPOXntpS+gyZo5f2cXxQt7ZPrwuuWzF8tAHJvxn2XnueLzV6j8VF7Uq9GiKjtLsgn2L460bm6OznHWaZ8absglidplnF0rJhyL9gXcgH1S4HbYE/L7OuS7WWhU+ZMLb6zI5sSVfhB2P8DFinfjKtnddrSA819ArGWZrap7sTvx1c+ENmmDAli/abddGk0iqsMC5SqMQj9RjN4nQTK8gwYVm985tJsgyabDj3dYif9POSL5wHSu
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2026 10:24:57.3976
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e3128496-5958-48bc-fab4-08de75ea74cc
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B8F.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB7390
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-72137-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[arm.com:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,arm.com:mid,arm.com:dkim,arm.com:email];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[suzuki.poulose@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: 9FBF31B5FB8
X-Rspamd-Action: no action

On 09/02/2026 15:51, Will Deacon wrote:
> On Thu, Jan 08, 2026 at 05:57:40PM +0000, Suzuki K Poulose wrote:
>> Track UAPI psci.h for PSCI definitions
>>
>> Reviewed-by: Marc Zyngier <maz@kernel.org>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> ---
>>   util/update_headers.sh | 17 ++++++++++-------
>>   1 file changed, 10 insertions(+), 7 deletions(-)
>>
>> diff --git a/util/update_headers.sh b/util/update_headers.sh
>> index af75ca36..9fe782a2 100755
>> --- a/util/update_headers.sh
>> +++ b/util/update_headers.sh
>> @@ -37,13 +37,16 @@ done
>>   
>>   unset KVMTOOL_PATH
>>   
>> -copy_optional_arch () {
>> -	local src="$LINUX_ROOT/arch/$arch/include/uapi/$1"
>> +copy_arm64_headers () {
>> +	local uapi_asm_hdr="$LINUX_ROOT/arch/$arch/include/uapi/asm"
>>   
>> -	if [ -r "$src" ]
>> -	then
>> -		cp -- "$src" "$KVMTOOL_PATH/include/asm/"
>> -	fi
>> +	for f in sve_context.h psci.h
>> +	do
>> +		if [ -r "$uapi_asm_hdr/$f" ]
>> +		then
>> +			cp -- "$uapi_asm_hdr/$f" "$KVMTOOL_PATH/include/asm/"
>> +		fi
>> +	done
> 
> This doesn't make sense to me as I don't think we've ever had an
> arm64 uapi/asm/psci.h. You presumably want linux/psci.h (which is what
> the next patch pulls in), but then I don't understand how that worked
> with the change you've got here :/

Yikes, it is in the generic uapi. I will fix this in the next iteration.
May be we could add a Warning message in the util script for missing
header files to catch such errors.



> 
> For now, I'll apply the first patch and then update the headers to 6.19
> myself using the current script (as other folks need them updating too).

Thanks

Suzuki

> 
> Will


