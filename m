Return-Path: <kvm+bounces-72032-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GN1ODHZ6oGmMkAQAu9opvQ
	(envelope-from <kvm+bounces-72032-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:53:10 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A2621AB40E
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:53:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 57D1633FA900
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 16:14:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 674DC4534A2;
	Thu, 26 Feb 2026 16:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mM07bNXi";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mM07bNXi"
X-Original-To: kvm@vger.kernel.org
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010042.outbound.protection.outlook.com [52.101.84.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C22144CF3E
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 15:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.42
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772121606; cv=fail; b=VnhjQnNYgWdMN+sGugW9/nOJqUrVi7j3DYokdKpO152sAfohWL3dcUKZGhEGf/PhUFpYOpGk6ebVAYvAuKZ09fhkeu6JxbIZCxbzx6ASLnm16pBj4H4S4+I4ksxOO2EKq8Kupnjcf981Nlm4HyufhXG9LnYDXHhVovo7ALJgnQ8=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772121606; c=relaxed/simple;
	bh=+O8BITEWWTyc1DE7NbgdclSyejoXGHlwIXyjhH0iDyY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aJv4CTrIwZRVJSi5gZwA8miqyA4+LAjd127nt5YbKgQdnd2bVpXdzbgL+b1OV51Ces9a+xP3YsV8iAYXTF8sisRKCcIPdqfO8LjvOUQEwIElYdVTA0oSCv1wEJE2SJ+R1rZsb107i6Jrc73VsHHLMG62kYZt15PWePdqgYzhxEo=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mM07bNXi; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mM07bNXi; arc=fail smtp.client-ip=52.101.84.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=ksQ6uzLZ7dFl9IbDcTU09eFAht9NThQGPlY6UoW4WTzRBJ/Bsdj3R6z9pTVZfqHeORSqKBO19KRE9bZY3eoRXzkfTjpMauMiyF+3S6a2TxRdsvi5M2IgAP/BSPw4cjAiXJLR7YOOELPSWiCIilzMitreO8DcS2XmAtVDFzxQqWdijgHrupoRYsXa/L/hUHpHil8p1j9c00EXISWuMkkKrA1wKCIla7wqp80K32OGhuGg2yiMG41gC/KnTXcoseplE1jpMTIhljn0ct/ZfL5NRlUBv7anxLXQDGhxMp+faRQHSeywkd5w3n06QO5AQ444HVt8ugsbBSyGv/ds2Ptarg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+7PndoxPONsSRxj5BdI6bteerDYGVfQol0U9NZ7dYvU=;
 b=MSiZImjgrBV6CUbr5npNlOTi8gtxgTrh4xoUBe8nei4Rp4h5L6IqFg3+XDAN8hB5+fVufQ0gtI4s6iUf2mEODFaxSXyAl6xQGlQ12QQxzkmeHt7WUCLxVa96+wR1w1m/vgz13LYpd4lhWrhvubKZccy/YoRGLkfjj5DWcAyBOWI1DwFeyN9QgJybq/o32/ADwkB8oV5JnUxHYqKQczCHNgonU3mFElH6sJARz8rI5K91ewMJD5NGWBnLyjTjwQJ9xak/wZYREpimGId94sBYL9Ht4WpTLCTnB1Ppv0tMZnmAg2oD10PbzC6owMA60iCcFA+mfQM+8WY+4svAB6DJlw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+7PndoxPONsSRxj5BdI6bteerDYGVfQol0U9NZ7dYvU=;
 b=mM07bNXi2m15hjq+4FPqlQIxVpX1GsNPztuo1BXY4vaaoSZwJ8cBxrtYx8rpdKelREW932S8k6E+gJpl0Mue4oAbj5Au1HQitUq9WA9aU7utrmIPfs+h9sqlMDBhvz/9czhH/vAsbTsfEa5TA9Cr5JCO5Ccu/BScf1rbdR8XbG4=
Received: from DUZPR01CA0017.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:46b::8) by DB8PR08MB5529.eurprd08.prod.outlook.com
 (2603:10a6:10:115::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Thu, 26 Feb
 2026 15:59:50 +0000
Received: from DB3PEPF0000885F.eurprd02.prod.outlook.com
 (2603:10a6:10:46b:cafe::57) by DUZPR01CA0017.outlook.office365.com
 (2603:10a6:10:46b::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.26 via Frontend Transport; Thu,
 26 Feb 2026 15:59:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB3PEPF0000885F.mail.protection.outlook.com (10.167.242.10) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.12
 via Frontend Transport; Thu, 26 Feb 2026 15:59:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yLi7gq2PWINOChjRwEzq9xQlribUYWrBzJ5SQ4UwM/5pyO9uR97yVeDRw84D2r9sLTzRZ6tziBpy/TIsz1zUwB1Isq1ytq9IZ1yb5dikT4BSdqVpRJvdw30CJ1CyZgDr4WsrQOmizOGFC26hbGwoMDEIf7yW3er5dcqYkW9FiIwl55XVCQct7fa8lm9idFH00WKiADqf3Qs+JKjaG67aJqJh/IId2wi/lqCHe4ld5xbU5clAnP9ouj+sCz37dzuKoxtTAfNpJKkDGN3ldUpEgOg1rdMfbM16A9HK2rNNcjNbfOnV04e1Pz6yE1m8m3GJnXrLA0JIcj9US1D6AM/6Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+7PndoxPONsSRxj5BdI6bteerDYGVfQol0U9NZ7dYvU=;
 b=fsJy/xPIx+pVhtvG6rju69EcMW2hXNOaz8dD7obIW3uj7NX5k1fyPrg+67qvX8t+GxVZ99vvyq5Y49UJiDZjP0sKplgYrS+k0SVSGyN1sy8TIj6/KmDa2m1k/o2HLmGMqbzEkzIiAY5P99q0+fy8gBW+fG1zGtawwavsUvvG7/PgtCDdFN6q1nzawDuQC2y95FW2ik/OiFUu34ycw0rEYrgCVZ16x0Lds2nX3V66LYuRZv8Jh/IvKMJ/wz9E1hJ5yCLcgT9Vq/vtZ0+wDMfA0yFJKaeFqfWmPeS52qWtfI/+shxPcgaFe5+khJYHy4GJDtDZaQ6EqsuR2sbFT/XPwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+7PndoxPONsSRxj5BdI6bteerDYGVfQol0U9NZ7dYvU=;
 b=mM07bNXi2m15hjq+4FPqlQIxVpX1GsNPztuo1BXY4vaaoSZwJ8cBxrtYx8rpdKelREW932S8k6E+gJpl0Mue4oAbj5Au1HQitUq9WA9aU7utrmIPfs+h9sqlMDBhvz/9czhH/vAsbTsfEa5TA9Cr5JCO5Ccu/BScf1rbdR8XbG4=
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com (2603:10a6:10:1b1::17)
 by DU0PR08MB7486.eurprd08.prod.outlook.com (2603:10a6:10:356::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.15; Thu, 26 Feb
 2026 15:58:47 +0000
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793]) by DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793%4]) with mapi id 15.20.9654.013; Thu, 26 Feb 2026
 15:58:47 +0000
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
Subject: [PATCH v5 13/36] KVM: arm64: gic-v5: Trap and emulate ICC_IDR0_EL1
 accesses
Thread-Topic: [PATCH v5 13/36] KVM: arm64: gic-v5: Trap and emulate
 ICC_IDR0_EL1 accesses
Thread-Index: AQHcpzjK5dsJ/YOhBEGF4DK0/7gNag==
Date: Thu, 26 Feb 2026 15:58:47 +0000
Message-ID: <20260226155515.1164292-14-sascha.bischoff@arm.com>
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
	DBAPR08MB5687:EE_|DU0PR08MB7486:EE_|DB3PEPF0000885F:EE_|DB8PR08MB5529:EE_
X-MS-Office365-Filtering-Correlation-Id: ea223048-6be4-4259-159a-08de755012a0
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 KboOWcvqeYcaE2Mz5BZ2X7Ow5SQOWdaxY4ebWIf0xDh3VUoj8g+Q9MR3J3brpJ5P9IdcVH3qW07Sp/ZKLdAoOLcq4xHZTTLE2p3s4NiySeMknxLo9P2Pv0kTdaQ8NBYAHTRdIb3zMM4Vq/dqsB33pwe/Dox8PuSqeuvTSmnxmlP14tOni0wg/DzPdm7WXlAJkY5ykOvwLBYdVV5rM4sBBdHfavbi9b5ptl/iprnxodQnc5N5flrqKy/Xd3rVhR2WZDJ8PKM5m2LTldcel6844es0xgTJWGfnJpBk40FXXSOkl8tgjXzvgCN7bZz/TzKefXW76nASs3VQKFyh1j04Q6TSQW6MkON7E3AfBPgiEB3oTEKEEInBliDhL0nQ8YruXVfn7ElE9scV8SORNCNXBgtBwV4lBFaYhww3ajjbWs4VlVZzvsNWqPm04kgrqEZO+5bgwOSmCll+zbkCya2jzTzonZiQ1gprkZzX1E4rswCWRh1s8LFZfHzvyL+wCnYLpSoyUOQU4hyJedstlVFxsFst6FlWpIkAlBwq1l6nzRBi60rNyQr/o+LaqhTC5VOeoD1u6CDTmEjvZt7GPyjRySYT4m40uBzMOMRlK6vc9EkFNGkPoSmW8SJIE9M3ta2riemZCWizP/EQaC9u8QIM2FA7O1wgthhkzlIUtrRioFLuqkHXlcmgqN+zEDTBOlC2LmQpXMEgyz+9IKEmAl/4TSmDzeDq8kb3QEi52kYcBO6+ipHH+zfzzxyDgSJQ6tzKg2Tke+3VWdfaRLbzGxdqzPzy1KQhjdImXnL4G9uKmKI=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBAPR08MB5687.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB7486
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB3PEPF0000885F.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	452a48de-715e-4af6-b9f7-08de754fecef
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|35042699022|376014|82310400026|14060799003;
X-Microsoft-Antispam-Message-Info:
	rWVR4aGfPD0TN/2GdRUc1yB1qOjQSAxZYblxKRe6XkXos2nJi3f61Y/2n3FS5/ErYnxUZmnxQIv4zfSFkoRixOI69MA5CjTuTwH6DsPVZabAdQqbIyCGXuN/l9KgwFuMbBXwY8iYmNjwCfqu8Qm3VWQLTO7atZ4fkZZzgs7C45+B7pPqMWwFHpe8/EuDgQNny7N7lUqctbnTU+28mPy3cAkZs3RMXTtGTj0WeOyN9zVkmOtrZH/jukYwBuBWgBTFdnHB/EKJ1no/IdCxsWMs8UEGD9zF0S+9jfPZiCxGbvHq3UsH235xwHIAa5hCyInAMuxyq2NiP+46tadPaU7bimGEKd/+eu3+75VtfFJxdgBTOnCfVZ9xTCYsbyQu8c0Ys3FSxNAnd/2K25layi5jyrTAdVppPeL7QUwm5tSdxSjf83PPEUwMOhp8S+vcwwev/Aw7s7MIChtKkcFscwVU+hhuAFA/CKCsL8EX/Knk5HCh6kieTbJ6GCnmiRarBPcbmvHKbTXG7K+HbfzmUZnFYbbG6rfINcjXgrc7xqeTUuswru2L9hnRUWSEsRsEXI9qkkVpcN66bl8bA8QjVQ8vkKpEnE0LFqGw/GYzYwBhuzo1aAzLKGFPQ5/8bqDp1K/hpQq/EoQbGldOYTD3km22lEoIQSFUNoZQIvQqsUjqZY7d48LgvT1SoU4Lke+Qq82Wqs8kw7FiiHtRxWFMlZEknxUPgl8lokh4g+3Zm1AGcneAAkvWz5TAG9BFl9AHhPC0VRNGQyM+5+0wZeLqWHuxdPX8aKywlHTxn1q0F2i+d/56UAWmpZz4phSE0BZX60MYeHTcRlwuvVzVlbV7Edfp/A==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(35042699022)(376014)(82310400026)(14060799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	NCxOH0gdrPGL7dacMhZb2pkDU9p3oz5ETmyc2MmYLN8uyNBZ+2Sgwhyzyw9WlmrummY7FO1Zb3qxgGQC18wPANNCZZS22o6EMqvQfxEbSVGoZnVeOmvonz27Fnv4ZmqZQnZVqsQWa7mb5WMSgygxaF+FNkAZ+JzyF37odbFmcTPVZr97iww66Sb4wdGz5tUJ0wvksEQ+XBpfKrnApzWzMHd0ib+3Ey4211O6amyNi1lkj08Vuks4OmdhIzlJfE/iapP1ZFzBPfE6saOe33mBr9IGl56cqa1UUug3uGC6SEN6pd8G2h2WwNVt/iZ+f5DB1RBbYQxwZvdB60HSUmCT5CxLbugsyu5YuNzmyDAQJSsw+uBEfk3VVyS2RfarnYgHfrkvTSyPG8Dj3sTF19hO59WolQBi6BSxwNSK7HCLY9kNU1osp5lm18qtONveXxam
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 15:59:50.2450
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ea223048-6be4-4259-159a-08de755012a0
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB3PEPF0000885F.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR08MB5529
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
	TAGGED_FROM(0.00)[bounces-72032-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,arm.com:mid,arm.com:dkim,arm.com:email];
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
X-Rspamd-Queue-Id: 9A2621AB40E
X-Rspamd-Action: no action

Unless accesses to the ICC_IDR0_EL1 are trapped by KVM, the guest
reads the same state as the host. This isn't desirable as it limits
the migratability of VMs and means that KVM can't hide hardware
features such as FEAT_GCIE_LEGACY.

Trap and emulate accesses to the register, and present KVM's chosen ID
bits and Priority bits (which is 5, as GICv5 only supports 5 bits of
priority in the CPU interface). FEAT_GCIE_LEGACY is never presented to
the guest as it is only relevant for nested guests doing mixed GICv5
and GICv3 support.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/config.c   | 11 +++++++++--
 arch/arm64/kvm/sys_regs.c | 26 ++++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index bac5f49fdbdef..5663f25905e83 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -1688,8 +1688,15 @@ static void __compute_ich_hfgrtr(struct kvm_vcpu *vc=
pu)
 {
 	__compute_fgt(vcpu, ICH_HFGRTR_EL2);
=20
-	/* ICC_IAFFIDR_EL1 *always* needs to be trapped when running a guest */
-	*vcpu_fgt(vcpu, ICH_HFGRTR_EL2) &=3D ~ICH_HFGRTR_EL2_ICC_IAFFIDR_EL1;
+	/*
+	 * ICC_IAFFIDR_EL1 *always* needs to be trapped when running a guest.
+	 *
+	 * We also trap accesses to ICC_IDR0_EL1 to allow us to completely hide
+	 * FEAT_GCIE_LEGACY from the guest, and to (potentially) present fewer
+	 * ID bits than the host supports.
+	 */
+	*vcpu_fgt(vcpu, ICH_HFGRTR_EL2) &=3D ~(ICH_HFGRTR_EL2_ICC_IAFFIDR_EL1 |
+					     ICH_HFGRTR_EL2_ICC_IDRn_EL1);
 }
=20
 void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 384824e875603..589dd31d13c22 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -681,6 +681,31 @@ static bool access_gic_dir(struct kvm_vcpu *vcpu,
 	return true;
 }
=20
+static bool access_gicv5_idr0(struct kvm_vcpu *vcpu, struct sys_reg_params=
 *p,
+			      const struct sys_reg_desc *r)
+{
+	if (!kvm_has_gicv5(vcpu->kvm))
+		return undef_access(vcpu, p, r);
+
+	if (p->is_write)
+		return undef_access(vcpu, p, r);
+
+	/*
+	 * Expose KVM's priority- and ID-bits to the guest, but not GCIE_LEGACY.
+	 *
+	 * Note: for GICv5 the mimic the way that the num_pri_bits and
+	 * num_id_bits fields are used with GICv3:
+	 * - num_pri_bits stores the actual number of priority bits, whereas the
+	 *   register field stores num_pri_bits - 1.
+	 * - num_id_bits stores the raw field value, which is 0b0000 for 16 bits
+	 *   and 0b0001 for 24 bits.
+	 */
+	p->regval =3D FIELD_PREP(ICC_IDR0_EL1_PRI_BITS, vcpu->arch.vgic_cpu.num_p=
ri_bits - 1) |
+		    FIELD_PREP(ICC_IDR0_EL1_ID_BITS, vcpu->arch.vgic_cpu.num_id_bits);
+
+	return true;
+}
+
 static bool access_gicv5_iaffid(struct kvm_vcpu *vcpu, struct sys_reg_para=
ms *p,
 				const struct sys_reg_desc *r)
 {
@@ -3420,6 +3445,7 @@ static const struct sys_reg_desc sys_reg_descs[] =3D =
{
 	{ SYS_DESC(SYS_ICC_AP1R1_EL1), undef_access },
 	{ SYS_DESC(SYS_ICC_AP1R2_EL1), undef_access },
 	{ SYS_DESC(SYS_ICC_AP1R3_EL1), undef_access },
+	{ SYS_DESC(SYS_ICC_IDR0_EL1), access_gicv5_idr0 },
 	{ SYS_DESC(SYS_ICC_IAFFIDR_EL1), access_gicv5_iaffid },
 	{ SYS_DESC(SYS_ICC_DIR_EL1), access_gic_dir },
 	{ SYS_DESC(SYS_ICC_RPR_EL1), undef_access },
--=20
2.34.1

