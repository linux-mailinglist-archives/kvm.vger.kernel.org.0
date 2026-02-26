Return-Path: <kvm+bounces-72050-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SEw4EJB2oGmtjwQAu9opvQ
	(envelope-from <kvm+bounces-72050-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:36:32 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B4A141AA9B1
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:36:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E36D63227CF0
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 16:28:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA431495502;
	Thu, 26 Feb 2026 16:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="nZ6KR69A";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="nZ6KR69A"
X-Original-To: kvm@vger.kernel.org
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013059.outbound.protection.outlook.com [40.107.162.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2AA748C8C2
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 16:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.59
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772121870; cv=fail; b=o+neDoq+CGr2IIxySfTrVCUrVVSygRTU+GJrR7cVriivbyqB57frBRjhoIKcMqMPRndIwjsICAJa0NPdU5QUb6oK2sGQ8Ul9IcleO8sqbd/OTjuski9vb/3ZyNiWe3U8HRmgWrgRDTwlu25cbHHs8d6HiMmY6F7yUlFVpuZXyjY=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772121870; c=relaxed/simple;
	bh=pUCdZEZINZKh20BMVdGHSfcrG7cvRbFBm0pVLzElK6c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kIOls4+pKaz6JQaOWKKEgnUp9W4e7Q6lnqSDU9Pl2jLlNJ8O7uqHoXmW5vPLA0hHBZ87nLs2eYyFAGKDffqq6B2cM7K6MZuoOvu3M0L04KNm9iboooPqOKsiDzDzQUQpQS5Ax3dmj8Jfzf4JWBU70EtvBSf1OjIGwhPgWEAtTqs=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=nZ6KR69A; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=nZ6KR69A; arc=fail smtp.client-ip=40.107.162.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=tIm9TuoOsreWpsZx6Ebzn4hXRZaBa8M3QY79CW7FScua2aHxrnJOuoAsWYEriUgz9AwE2AJRFl1RfAMxbkUbSaC3pldsfkGllLyOgnLzUQza9ZG7bHaK+vLcMXi5btZF42lZnDTLxfaGAKbyEmW+ZrL9SGbiIe94i8Yxl8USnLsahI5NqVbzLwJ90MRKOsjZzovGT/9hr9wC2aWesbvJ0jZy1ALV6HsY1zyvczGQVWMMEr6ZsTHNWv8XpDjMLeuaZesslcLuIi6d4i+B3M1BIJGO1I6AtbviQGxDTYryNmQ0a/9rqYn9xNabfbwAyu/Lx/a/cyYZ/cW05/Cd0+zIhA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uLr4zTLDGkwrjruv8e/X4eqI9ZrGIV9xPpF4lpoRVjI=;
 b=nShPL/6wgt+s9Hkg2i5rg4XykyWtFFTlMr4NpV/GDl6XCYv9vhg6dkdXQwxBh3gHte0EvD3u6IfQk8aRqfeKTAVBwTPFunFWjnvwJJ8NbnfScy6DFVzPWCp9yk0zC5aRO95Wg6APuyVimuycoj2tE7DYVfcdMym6KDAtKVzcjnQBQjQ3JmtpnkDykJmtU1d/q0ML8mDb7Ok1LlX1HtooBB6aDWelhDbaFj+cDlHBebD0Gth4Vczsv7chZRz4mg26jprqrOwLKP3/tgrKclRVZFNfsF5i+oZuJFZmP02QW4SSTuEcfbSdxJ5ShuXT+vODUZ4B6iiex8U1/MOXHaE9ag==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uLr4zTLDGkwrjruv8e/X4eqI9ZrGIV9xPpF4lpoRVjI=;
 b=nZ6KR69AFlur1Js8Te9LN2oXia8cpHzAQPj/fjhbLnDaAb0lFOaexn57vbPgYDngNc1ihNC3ohbGh93m2SdEIpmQxiOXWTbgihR7eWLiFUpkXjGbggtP3m/dsLMEZC4EOgGWHj2lK93vs7g2lHvp8M/OW8URgYRVRbgNcpG8ZTo=
Received: from CWLP123CA0172.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:19b::7)
 by PAXPR08MB6334.eurprd08.prod.outlook.com (2603:10a6:102:dc::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.17; Thu, 26 Feb
 2026 16:04:17 +0000
Received: from AM4PEPF00027A6C.eurprd04.prod.outlook.com
 (2603:10a6:400:19b:cafe::be) by CWLP123CA0172.outlook.office365.com
 (2603:10a6:400:19b::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.26 via Frontend Transport; Thu,
 26 Feb 2026 16:04:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A6C.mail.protection.outlook.com (10.167.16.90) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.12
 via Frontend Transport; Thu, 26 Feb 2026 16:04:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Hi6ZphX3JSZlp7BOyxYyggPjTUpUFj/M9SaeOk43wakEUobeW9Q8RaPoTgF/+JsbNMkyjBRIczg4IC5N/TXbx5zvYqdQkj0o5NIPfFqrodPQdZfrEEbRWan7m07j8SBw6CmN/ogwWimCheYtS+7AWo0gieAriHwUXdmHhENhF+ljFv8gb68d7QklII5C8BeJUGEGZO1ypkxz10pnWkdggwzGTv/BaWotVemgScvorS4ZT9la+rk3e1JQQvc/4ohpaJn3rCj2zJk6SYXKk3ZPm8o61h3FTgcO4/uhwxr4Pf7WxeiAmOpEHs53aFqWDW9ZSgxqhsr54rR26LzU5VtiwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uLr4zTLDGkwrjruv8e/X4eqI9ZrGIV9xPpF4lpoRVjI=;
 b=u+SEaurT44TDkASc2xuqNdN3CWzv89CZDfiGIlW8Emy88FzKfczkpnZW1ljfhcZwnOxA0cpbElXOcuo+VDYQjbEIyxSGVLIlse4+/b/fF1SDmGMCUwUiamsW+nHbuzgkc/uD3+SyI5J+5LDFqtfYwvVgoGTXWavpKPgp+n6qawVsYG/4NZErqhlCzKTt1VC8/jb7Nb/pHrlmdnNMTBDf0r5Y08F+rxffB8v0PV5M9m2E6lU1JhZewjLmV0QRCPDkaEHi2yRpEG+06DmD30NOgCnDlOSWNER/ePrXHAzFoxNHKGjTEyI7oItj84X2pjTeR27okVH1XTEe+19bglLhNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uLr4zTLDGkwrjruv8e/X4eqI9ZrGIV9xPpF4lpoRVjI=;
 b=nZ6KR69AFlur1Js8Te9LN2oXia8cpHzAQPj/fjhbLnDaAb0lFOaexn57vbPgYDngNc1ihNC3ohbGh93m2SdEIpmQxiOXWTbgihR7eWLiFUpkXjGbggtP3m/dsLMEZC4EOgGWHj2lK93vs7g2lHvp8M/OW8URgYRVRbgNcpG8ZTo=
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com (2603:10a6:10:1b1::17)
 by PA4PR08MB5950.eurprd08.prod.outlook.com (2603:10a6:102:e0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Thu, 26 Feb
 2026 16:03:14 +0000
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793]) by DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793%4]) with mapi id 15.20.9654.013; Thu, 26 Feb 2026
 16:03:14 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>, "jonathan.cameron@huawei.com"
	<jonathan.cameron@huawei.com>
Subject: [PATCH v5 30/36] KVM: arm64: gic-v5: Introduce kvm_arm_vgic_v5_ops
 and register them
Thread-Topic: [PATCH v5 30/36] KVM: arm64: gic-v5: Introduce
 kvm_arm_vgic_v5_ops and register them
Thread-Index: AQHcpzlpxCxVIZJnXUuja9LUjiSvXg==
Date: Thu, 26 Feb 2026 16:03:14 +0000
Message-ID: <20260226155515.1164292-31-sascha.bischoff@arm.com>
References: <20260226155515.1164292-1-sascha.bischoff@arm.com>
In-Reply-To: <20260226155515.1164292-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DBAPR08MB5687:EE_|PA4PR08MB5950:EE_|AM4PEPF00027A6C:EE_|PAXPR08MB6334:EE_
X-MS-Office365-Filtering-Correlation-Id: 0faa86ed-0958-41ec-59ad-08de7550b187
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 /oBKB+ONq+2BEiYqf3xuRNFRnlAnmoPqrqkL+8uDhm+VKIG/wZvNraSWL0MGMCf9evaTsJhNmL6Ezh61McQfX5mtTb7Kc2bWyB5bXG9uvlPcTASMAQXmsBBZDRgPq46O073ckgFAPLiVHmOLDsewBjN9UERUEbOhm0zkxDWI5cLw941U1hedFszCYK8hSLqSSCWvisUwhZZ5kbwe3T3aiPy+9mXVHXKD8G76+hpHVAwRewDj39vWV0P5ajwcAlO4LegEqr9cBNytyRKkVC4xSMBfxRq6FZN7+GyoD4H3E/sszM2YbQAIp6jYaYEpsERDmRN+y431ebsIPqHIxQC766yPviis5zMMm2Ppf/gfwesXUQPoIGwcFuyOhkE30rAkvNbFHdNOysoFaH2WcprrvCp6Z7A2kH8BV4Y42cg82soB9g6roYtW/x0aSzACCPVheZiHGamlnlSJf+peZ8wLiaajhAvQM1hj0j3vR8n6amh6raiA8U9Ptbj9BmMleEjLK1KXwDnAWT7nFhIGMstfcQEM7w333DIyUhzxgZ15OpHIwKAtFTLZ6Qjac1R3nqKpOodlY1f4WTQKkCR2tczaD0Glz8aUaeoCs24zS24REnEBIuquZ1G1YxJgSNSgkRxOBZrRl9IdrZsBuF2XLz6h5rNzH4l7MJLobovXBTFoMunC5Rd+mWgST/eFbr7/ZHCj1cR2gGm9F7Amdkm9tyI3QniUUyxmyDSv+Oy11utxqtbOVrcWtsoMRjxEZdkbOSPhTJ5JyizGG8B3rxpySgasBM0wM2O/uooPA2ugq018H2k=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBAPR08MB5687.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB5950
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A6C.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	de5c0940-5a64-47d6-ed72-08de75508c0c
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|35042699022|376014|14060799003;
X-Microsoft-Antispam-Message-Info:
	GDHLH0p+x4QAyn7wHdplUIC7mEuC8CXGPaLMV537fXbnef6KwLioKAofWjd6STBnqA5KLXsXEvGp/Xyu9GlS5C+XGvfkxUoXr5z7BBa26VYVn64jDnWf/meWB5I+KZ7KZlCER1QDp6savReoBNQCaTbksBs+o5zH/WzPOZzRFlW7A2553nXwIPSaNqyGs0B2ikVnfVSuBlxwf55L2WMFa39WIgMLqXC5jZ1ebaEtaQJUB2qdlfHObCUMK/JlmFcfFtG/7yRbxUjhEcYSi2vKTFXlmf0zYKni2Aonre9gESKeZf4N2Jp7gz4yHDJrx42gjxVl6UEEzJQtiJ6p6BgspD3WyNHYpMAYzA+HtPYHslsciQSQ6JvDG51/apSuo2zUBV2tC1tdit71w5t5o8Q+CCUozpfxOM5/XmMpJe6sxwAsUDbyQMAvpX2XBiK26RkQ0gahKFPSR1u0iGuoYOG6izTE5ZD235wtQ2eRdnw8JYFadE7ZHsLdcbtHHucy1Zw1L509ikkH6SzbVN0XuS27F+n3s2nRsutICjah7MZmm+GmbeVaGHeI/QRsSLS4dclH9I1dmabpu4dNrffXkQ3QRvWO1ZW5Puz9uGs/f/n3bHNybwND6sLj+Sd1kpns9c089Wk94jkevHyqIHAfy7qbclsrUw1mwLTuBLbyoxyvPo+00v6BwtuH/wjaZMuNQMZkv3gmrvpk9CRA8evP76Vy6mqNnThAb7TBuex48mqbm4rk1d/aQ3swDuuFMzziZMFWx3K0azl4WM6aR94FfztUQsve2h7LYixSsiW6E0AoqtVEm5ORUeac9woOeV+6D317J6/T1gd4JqFjTrJrrZA8vw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(35042699022)(376014)(14060799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	1O2IQeUW6lgVUao5PxUXFenqxo6jS4PtHj7p7brugTFHP5MvRUF/yaIbyFYTco3ndThgAybPzzxjxKhJ/IO6XNZWKzzGZ55gnpUcFPuNmhILk9c4V/38kVNh5Y8G+URYavbyk9rTc7czo+jmdWJu2H5nwIg9e8prER+6jwiOjJzH/iSOibMsKxqa8ExOur+q5v3YHQ7TpMrZr92Lsi4z4nHh74b3gmRaAfQsVDwhr08ThXcxQ/qxVikFcmHB3gWx/8fcinDexxQnf6syLlQ15Z9nm1wGW3Z+4IKcqbPnms09U6Iwxs6SKieVfdY0TmB/F/h0K/wmzCjmyN4kbjugujznRwNmyLtpLtGl+P4XRK7yp/QWxHRB5sHziwZM6JrjF3gGe79Tc36NkVD2rqBSpkSXDp/lfxFC1XgrdRWN8D7oYvLtgj5hZWyyz/4RjHsI
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 16:04:16.8516
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0faa86ed-0958-41ec-59ad-08de7550b187
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A6C.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB6334
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72050-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arm.com:mid,arm.com:dkim,arm.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[Sascha.Bischoff@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[arm.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: B4A141AA9B1
X-Rspamd-Action: no action

Only the KVM_DEV_ARM_VGIC_GRP_CTRL->KVM_DEV_ARM_VGIC_CTRL_INIT op is
currently supported. All other ops are stubbed out.

Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 74 +++++++++++++++++++++++++++
 include/linux/kvm_host.h              |  1 +
 2 files changed, 75 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vg=
ic-kvm-device.c
index b12ba99a423e5..772da54c1518b 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -336,6 +336,10 @@ int kvm_register_vgic_device(unsigned long type)
 			break;
 		ret =3D kvm_vgic_register_its_device();
 		break;
+	case KVM_DEV_TYPE_ARM_VGIC_V5:
+		ret =3D kvm_register_device_ops(&kvm_arm_vgic_v5_ops,
+					      KVM_DEV_TYPE_ARM_VGIC_V5);
+		break;
 	}
=20
 	return ret;
@@ -715,3 +719,73 @@ struct kvm_device_ops kvm_arm_vgic_v3_ops =3D {
 	.get_attr =3D vgic_v3_get_attr,
 	.has_attr =3D vgic_v3_has_attr,
 };
+
+static int vgic_v5_set_attr(struct kvm_device *dev,
+			    struct kvm_device_attr *attr)
+{
+	switch (attr->group) {
+	case KVM_DEV_ARM_VGIC_GRP_ADDR:
+	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
+	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
+		return -ENXIO;
+	case KVM_DEV_ARM_VGIC_GRP_CTRL:
+		switch (attr->attr) {
+		case KVM_DEV_ARM_VGIC_CTRL_INIT:
+			return vgic_set_common_attr(dev, attr);
+		default:
+			return -ENXIO;
+		}
+	default:
+		return -ENXIO;
+	}
+
+}
+
+static int vgic_v5_get_attr(struct kvm_device *dev,
+			    struct kvm_device_attr *attr)
+{
+	switch (attr->group) {
+	case KVM_DEV_ARM_VGIC_GRP_ADDR:
+	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
+	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
+		return -ENXIO;
+	case KVM_DEV_ARM_VGIC_GRP_CTRL:
+		switch (attr->attr) {
+		case KVM_DEV_ARM_VGIC_CTRL_INIT:
+			return vgic_get_common_attr(dev, attr);
+		default:
+			return -ENXIO;
+		}
+	default:
+		return -ENXIO;
+	}
+}
+
+static int vgic_v5_has_attr(struct kvm_device *dev,
+			    struct kvm_device_attr *attr)
+{
+	switch (attr->group) {
+	case KVM_DEV_ARM_VGIC_GRP_ADDR:
+	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
+	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
+		return -ENXIO;
+	case KVM_DEV_ARM_VGIC_GRP_CTRL:
+		switch (attr->attr) {
+		case KVM_DEV_ARM_VGIC_CTRL_INIT:
+			return 0;
+		default:
+			return -ENXIO;
+		}
+	default:
+		return -ENXIO;
+	}
+}
+
+struct kvm_device_ops kvm_arm_vgic_v5_ops =3D {
+	.name =3D "kvm-arm-vgic-v5",
+	.create =3D vgic_create,
+	.destroy =3D vgic_destroy,
+	.set_attr =3D vgic_v5_set_attr,
+	.get_attr =3D vgic_v5_get_attr,
+	.has_attr =3D vgic_v5_has_attr,
+};
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index dde605cb894e5..cd81a5af3c3b2 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2384,6 +2384,7 @@ void kvm_unregister_device_ops(u32 type);
 extern struct kvm_device_ops kvm_mpic_ops;
 extern struct kvm_device_ops kvm_arm_vgic_v2_ops;
 extern struct kvm_device_ops kvm_arm_vgic_v3_ops;
+extern struct kvm_device_ops kvm_arm_vgic_v5_ops;
=20
 #ifdef CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT
=20
--=20
2.34.1

