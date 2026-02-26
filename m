Return-Path: <kvm+bounces-72024-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +DdBG1B3oGlwkAQAu9opvQ
	(envelope-from <kvm+bounces-72024-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:39:44 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BCE751AABC8
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:39:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E2A9731C8ACB
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 16:09:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE1EC44B697;
	Thu, 26 Feb 2026 15:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="k8/AZ+Ub";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="k8/AZ+Ub"
X-Original-To: kvm@vger.kernel.org
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011041.outbound.protection.outlook.com [40.107.130.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 689C0449EA1
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 15:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.41
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772121516; cv=fail; b=ErsRGS82/P2JLp3W+AXCFhPJe8tH5GQJVUabZFfMGJ2Q2AA45PPbOedGNn6yw5EkLja5VqVyFBk3IaFrpI96+RKyjBM8NA+3SIdsguiQIiabH/s+Qf5Khhl+q5A6KNz7pzflTdzp1BCYFBEBG146lkehJ66Sh/txfRzuUoLR758=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772121516; c=relaxed/simple;
	bh=1ZCG13xdflBr64XFsx2DFBw49D1l87mGQP4thE7QiNg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=f3yKz5CQwLCLNnSplQWsNeSMczj5mbsnbd+8ST/wq6oODrkVTdoXhMJxnHWvDbmz2nLdZvrt04Tl/VGvkx9exNEpOqN1UiyFXW9nnOmfgDy7wUr9mPiCiN4Tzc/PG0jgW73TEoeInZAPs1J7Rswc4MUHXs0um+vcaodx7C3ETRg=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=k8/AZ+Ub; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=k8/AZ+Ub; arc=fail smtp.client-ip=40.107.130.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=qme+BbqjwuwGgFHKPmsrBeqh/3iTs6l5OzHArz3ZbENNhOgpuUu4e90bzINW+nDzD5sT+OgAyyp5yhWww6yaY52tHR8lc+bcfemDPEp8FxTaayF+14XfAqvw5qB+Rw6TOILBl21DCa2CGJ/3ZRiZbT1jD/na8d0SkPZ3YEAbs4KVRDSBKG2vZ4LsqpY9ezqUtXOpp0Ezp8DmOXaemUGfkDUvre0L4b5B8FIJxPWwL4egG8k5s1saLWPj+F+RPIIf1TyJ6UYwfnql1sTyWH/q4tL4COHw4vgUs6iIqceklIqHpdWBxBE1O25/5b8c0UiuZzfrbItz3CtqMYksxosoaA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HhWo3wzfygBKcyNVlouO+A8VOgg+UEO4Y37JglwACTU=;
 b=kdXCaa4hwV47McSX07WVrXs9CQxoI0jGNpsLQOVbD8ptiTHVbZE2CDS62c0MYcr3F5lVDaepqzizpKejT3lPUPEw2Xyj12F2sRXtTDOwf6jEfT0eaDcQqZZvlLFOv3H/ByR4WRYBdAQrtTO4K3DCo9Opr/IzclhbZl9/oCeHTJy8cQYvcTyEx9baX+Ibevy7PzjJ0j9mUiJFVUPx+yu+lF0RTFMAiQ5HcuYUO1YotvkrN44BGmCrE4xa7RAHZJCONebSPOeXxIDHEYmX8remzU7GiB8A1KEhroemHlNUlRsZ+hRfC9krP6RLOBotQRNr8liR+Sg0Z11mTBnGDmodZg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HhWo3wzfygBKcyNVlouO+A8VOgg+UEO4Y37JglwACTU=;
 b=k8/AZ+UbH+fRQ0WdTufzvf/fLP8dnpAujdj96EJTDRjqDFDAaWMVYoKniKEOdXmsa49/TgJr6w4H/pjqQdEGgT0ZU8Xh7ySDT3CYW/5iZbMzjJ9mC9KbITG0QKfyl5FOmGp1v3zK4ekCKw6+OHbtMe0cZGND7pZ8OYqZK/fAX6A=
Received: from DUZPR01CA0179.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b3::10) by PAWPR08MB11509.eurprd08.prod.outlook.com
 (2603:10a6:102:511::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.13; Thu, 26 Feb
 2026 15:58:16 +0000
Received: from DU2PEPF00028D01.eurprd03.prod.outlook.com
 (2603:10a6:10:4b3:cafe::ae) by DUZPR01CA0179.outlook.office365.com
 (2603:10a6:10:4b3::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.24 via Frontend Transport; Thu,
 26 Feb 2026 15:58:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D01.mail.protection.outlook.com (10.167.242.185) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.12
 via Frontend Transport; Thu, 26 Feb 2026 15:58:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uJq5E8+OBk9DUL8Twmaw7Vlid+c+Ri1stgCBwciUaqpcYMtNZ2VkWCD+eNXnMIR4bTojAnUxWVQUNIw3pB+7GXM2AMH+ActeeAMbJAFSA3TeRz5y4v/QgvFJ6cZfRXn+DevP1pnx/xCnRU8kqlKVVI/Ah6ldK/Kmo89t7Nxh85MuG5t6Jn/PYt/GkoNTZLdVu5BIVp/5AJ7dslgferX+g9XBA5wdA/bbfaoUJ/xvRi6bV3p6+JZntiq2ZxDh5r5CRDERyRGCycxWkgddx6fr3vH7GOT7+ZB+TcpqM7lJ39Q1NVs/x0AWJs/sR4wsnrm6hInXagq9z6JOUHTW/Re3JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HhWo3wzfygBKcyNVlouO+A8VOgg+UEO4Y37JglwACTU=;
 b=rG87+UtS8CNxbJHVaRfN0MsqBYoJszoB70lT+/W+hqzRA0RDukvebEkd1t1EsTC8H1vBpRCq5dKbvTfEfnIxsx24xNAyAp16/OzTp2fGFSyG7Xcf7leAPAwdUpYNYgBD/E0/RWfSGa30nl1jwIAEA4n0DIgKd68n3qSd2V47xDXnu4VCm81U48KIJtqt0glE6BppVGJExEUJaqyU2OBu3Z+/RDZCOauUmje3vol6QqmaD0+lN6xlljqCjHGL8NO9yzYlori+XAJSg0e8uuETDZxqRqghvtpFSuUy2vHg9TRxxiH7hePpKGMtHC+n6u/s0ysd2VrHHtxsyiZFrYBCgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HhWo3wzfygBKcyNVlouO+A8VOgg+UEO4Y37JglwACTU=;
 b=k8/AZ+UbH+fRQ0WdTufzvf/fLP8dnpAujdj96EJTDRjqDFDAaWMVYoKniKEOdXmsa49/TgJr6w4H/pjqQdEGgT0ZU8Xh7ySDT3CYW/5iZbMzjJ9mC9KbITG0QKfyl5FOmGp1v3zK4ekCKw6+OHbtMe0cZGND7pZ8OYqZK/fAX6A=
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com (2603:10a6:10:1b1::17)
 by PR3PR08MB5819.eurprd08.prod.outlook.com (2603:10a6:102:92::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.14; Thu, 26 Feb
 2026 15:57:14 +0000
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793]) by DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793%4]) with mapi id 15.20.9654.013; Thu, 26 Feb 2026
 15:57:14 +0000
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
Subject: [PATCH v5 07/36] KVM: arm64: gic: Introduce interrupt type helpers
Thread-Topic: [PATCH v5 07/36] KVM: arm64: gic: Introduce interrupt type
 helpers
Thread-Index: AQHcpziT3fzselMNikaB/ISa0/5QPQ==
Date: Thu, 26 Feb 2026 15:57:14 +0000
Message-ID: <20260226155515.1164292-8-sascha.bischoff@arm.com>
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
	DBAPR08MB5687:EE_|PR3PR08MB5819:EE_|DU2PEPF00028D01:EE_|PAWPR08MB11509:EE_
X-MS-Office365-Filtering-Correlation-Id: a680084c-9981-41f5-1eab-08de754fdad4
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 IoQyG7m9TtphRbV7wMyOCZYT3VmbnmSx89e4ZDgqRRaA3evsOWFt+5nhCHhWbfoiZfC2u2OjTFb6L/9a+vijDoGNfP9ppL+bFZBz9d9jeF6ZKTQKH6oBgqxG3wGJAgmeODZrlBcj0rSU56WVB/FV8eQbANiyLCDw27IB8vvsAPZaRo+3NPLr09xWzHexDX6YBcwUO5clqI6rtaNZdV4o16XlDmXosKxq8X8QevlLvU/iOxq8FkmuRLW7xo2uvt+hMBbhF/pVTRL0m5OifmL9mJmgn/iQm6W15G4IEq3dBYxxlp0vk6BaqAVnprrAnOS3XXM8f6vcVG9dZrwCQJBXlDzd+u82EGPGI9Rqz0bAACYzWp06bmMZl3uwMo35lSj06cSNED3XOrBRe5hRmoQ5/vf2SWW8tXUxES8nruWU/9Wt9mYnBTEdAQYF3Yce3d4qY8xQ0Xb5w34cvWU9aaL8y8D88X/h5P/5piUVJO6RXBVA/zP1nJ8XEHy5vS31NVwOXDehZTaNqcEjd+UMNMmqhZ8vjh00gb0TnHtSlX4mRLRIBCuGyFJTsMsYhic5lyQcxWmLwSnWZ1060U/IUYEdKE7DzirsnKaUKWybZ7e2KR4E6CN1FmYcIc6WiSM8XaY9PSAGoyN4rCX+UknzAjnLYg1otHcpuAgkpNGzkYP3YCBLEFBviS18+qjt8EuTtrSgeGTvkLd2ClaoeLYXIe3rDC/Dw9yzLYza/PHHst85XsYmmsBb/V6tMkvLi+EXYd5bwePkVh+4pVrkRoEJkW9T1855+PFa7rBUIrgeynGNIQg=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBAPR08MB5687.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR08MB5819
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D01.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	15a7518a-1f35-4631-a5a2-08de754fb589
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|1800799024|35042699022|82310400026|14060799003;
X-Microsoft-Antispam-Message-Info:
	ImPHLpQDTY5MItDqii0hH8i/zUOWVA+uc0THRc30wzAtFFnKJ9E0U1u8roebxUybcq+6biY5oKTDnBm306Ew6qHW2YoVgwcYDmQq+xvH3eGCmei3rBqOHle9qYGrkHViNj51wagc0Nt90/dybylsM/KQIPxtPU+nUgIhqfRsOLCUDFpH2LmgZf/RidxGhDIH+Fc2X1spPx/W6RACkJiYLl+RHsChnxdF4PZpQiH9DhbDuDoEzIuVej0oX2bcH3xrIhtUL/JaRP2q4g2HBzIsN6pU/GMSFaYSDtGKXXKzODJVyavucejtCb9y53u+qBolAPCbs9RXPQOe02ZY5Ep+70tw+V/2TwSVxXMl2+ePp0YRCMF0wHygJ9eOPAMh7S517WOR23EqNDbBdNATr+0g479gd6TLTRN1PDgu/Jv0IbY50MBuvb82HHYjXYkJJrLmc5kg24VkfFaPs3B0IqtfElurrp4sz7xPxRihY40kDnMltyL9nsEVcHYsqLaammszaRA5fjbxwQrk8W2L8wrSG0FfO63svjtjrdhQUtf0eugFfdx6PcYa0u1yxfg2YLw0R6yph4ahwlwE0TvP4UU99av8u21l8mnn9D+6HoVDcB14czIwNmUSrZOY39gzGqD52suRWtGeGPsBSlTt6L71Kwe67km/byUp/Y/IgDLGz+3voMv0xx6GoDWsscGlfB+c2gTnPuPkrU1PX5ARgfzce3jHVYmMX8+Y9NRH20K4uAaFIDl3tTdbPpqvQJ7tIShJpLUo7gHL0e3S/3xC6aFiS/UJZzFOWiedFkcMMFkJx17b6k645Os/etXV6Aahv0TELuta11nd/sXP1SflnXCNZg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(1800799024)(35042699022)(82310400026)(14060799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	B3KP+oP7k+fFrPwhI47PAqys0a5OYd7h8uPp9/M568PJJZmAGTugspLwFbN+pb9QuZk9DuNCspL5q11aaHxWJIjNgvwokoJ7w1ekdV8d98Q3rmN2fPmGfNofyDChvfTDnPNc6TmBCd2GufD9M4NmzMhfjssqpPNre4q1Yw/1xK9ZiaPgtTIrk6N1HrSINGITZDMzubJKV1wOWQzH1ddrF5zsYofVlGW4CYIGPJZxP4+qE0YbWzGSDM80awUrLuCg/36RLr0FUXNXhj+mrOYOch/o1sagNMzRUzFUYB9KcxVZOy1gxGxKnVDQUzsT2yaqeidewIoQJU6JJ0wd8r8qUk3RGhkXFaZghDw9JAis87J3qC25VjvSyzYKH7rq9hppVESVh0s/TAfPyWiNB3Jrj+dVn/Trj7eq9qmQ1QZlyZu1Rq3ktn589eacJLgUaOsv
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 15:58:16.6303
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a680084c-9981-41f5-1eab-08de754fdad4
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D01.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB11509
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
	TAGGED_FROM(0.00)[bounces-72024-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,huawei.com:email,arm.com:mid,arm.com:dkim,arm.com:email];
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
X-Rspamd-Queue-Id: BCE751AABC8
X-Rspamd-Action: no action

GICv5 has moved from using interrupt ranges for different interrupt
types to using some of the upper bits of the interrupt ID to denote
the interrupt type. This is not compatible with older GICs (which rely
on ranges of interrupts to determine the type), and hence a set of
helpers is introduced. These helpers take a struct kvm*, and use the
vgic model to determine how to interpret the interrupt ID.

Helpers are introduced for PPIs, SPIs, and LPIs. Additionally, a
helper is introduced to determine if an interrupt is private - SGIs
and PPIs for older GICs, and PPIs only for GICv5.

The helpers are plumbed into the core vgic code, as well as the Arch
Timer and PMU code.

There should be no functional changes as part of this change.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/kvm/arch_timer.c           |  2 +-
 arch/arm64/kvm/pmu-emul.c             |  7 +-
 arch/arm64/kvm/vgic/vgic-kvm-device.c |  2 +-
 arch/arm64/kvm/vgic/vgic.c            | 14 ++--
 include/kvm/arm_vgic.h                | 92 +++++++++++++++++++++++++--
 5 files changed, 100 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 600f250753b45..f1f69fcc9bb3d 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -1603,7 +1603,7 @@ int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, str=
uct kvm_device_attr *attr)
 	if (get_user(irq, uaddr))
 		return -EFAULT;
=20
-	if (!(irq_is_ppi(irq)))
+	if (!(irq_is_ppi(vcpu->kvm, irq)))
 		return -EINVAL;
=20
 	mutex_lock(&vcpu->kvm->arch.config_lock);
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 93cc9bbb5cecd..41a3c5dc2bcac 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -939,7 +939,8 @@ int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu)
 		 * number against the dimensions of the vgic and make sure
 		 * it's valid.
 		 */
-		if (!irq_is_ppi(irq) && !vgic_valid_spi(vcpu->kvm, irq))
+		if (!irq_is_ppi(vcpu->kvm, irq) &&
+		    !vgic_valid_spi(vcpu->kvm, irq))
 			return -EINVAL;
 	} else if (kvm_arm_pmu_irq_initialized(vcpu)) {
 		   return -EINVAL;
@@ -991,7 +992,7 @@ static bool pmu_irq_is_valid(struct kvm *kvm, int irq)
 		if (!kvm_arm_pmu_irq_initialized(vcpu))
 			continue;
=20
-		if (irq_is_ppi(irq)) {
+		if (irq_is_ppi(vcpu->kvm, irq)) {
 			if (vcpu->arch.pmu.irq_num !=3D irq)
 				return false;
 		} else {
@@ -1142,7 +1143,7 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, st=
ruct kvm_device_attr *attr)
 			return -EFAULT;
=20
 		/* The PMU overflow interrupt can be a PPI or a valid SPI. */
-		if (!(irq_is_ppi(irq) || irq_is_spi(irq)))
+		if (!(irq_is_ppi(vcpu->kvm, irq) || irq_is_spi(vcpu->kvm, irq)))
 			return -EINVAL;
=20
 		if (!pmu_irq_is_valid(kvm, irq))
diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vg=
ic-kvm-device.c
index 3d1a776b716d7..b12ba99a423e5 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -639,7 +639,7 @@ static int vgic_v3_set_attr(struct kvm_device *dev,
 		if (vgic_initialized(dev->kvm))
 			return -EBUSY;
=20
-		if (!irq_is_ppi(val))
+		if (!irq_is_ppi(dev->kvm, val))
 			return -EINVAL;
=20
 		dev->kvm->arch.vgic.mi_intid =3D val;
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 430aa98888fda..2c0e8803342e2 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -94,7 +94,7 @@ struct vgic_irq *vgic_get_irq(struct kvm *kvm, u32 intid)
 	}
=20
 	/* LPIs */
-	if (intid >=3D VGIC_MIN_LPI)
+	if (irq_is_lpi(kvm, intid))
 		return vgic_get_lpi(kvm, intid);
=20
 	return NULL;
@@ -123,7 +123,7 @@ static void vgic_release_lpi_locked(struct vgic_dist *d=
ist, struct vgic_irq *irq
=20
 static __must_check bool __vgic_put_irq(struct kvm *kvm, struct vgic_irq *=
irq)
 {
-	if (irq->intid < VGIC_MIN_LPI)
+	if (!irq_is_lpi(kvm, irq->intid))
 		return false;
=20
 	return refcount_dec_and_test(&irq->refcount);
@@ -148,7 +148,7 @@ void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq=
)
 	 * Acquire/release it early on lockdep kernels to make locking issues
 	 * in rare release paths a bit more obvious.
 	 */
-	if (IS_ENABLED(CONFIG_LOCKDEP) && irq->intid >=3D VGIC_MIN_LPI) {
+	if (IS_ENABLED(CONFIG_LOCKDEP) && irq_is_lpi(kvm, irq->intid)) {
 		guard(spinlock_irqsave)(&dist->lpi_xa.xa_lock);
 	}
=20
@@ -186,7 +186,7 @@ void vgic_flush_pending_lpis(struct kvm_vcpu *vcpu)
 	raw_spin_lock_irqsave(&vgic_cpu->ap_list_lock, flags);
=20
 	list_for_each_entry_safe(irq, tmp, &vgic_cpu->ap_list_head, ap_list) {
-		if (irq->intid >=3D VGIC_MIN_LPI) {
+		if (irq_is_lpi(vcpu->kvm, irq->intid)) {
 			raw_spin_lock(&irq->irq_lock);
 			list_del(&irq->ap_list);
 			irq->vcpu =3D NULL;
@@ -521,12 +521,12 @@ int kvm_vgic_inject_irq(struct kvm *kvm, struct kvm_v=
cpu *vcpu,
 	if (ret)
 		return ret;
=20
-	if (!vcpu && intid < VGIC_NR_PRIVATE_IRQS)
+	if (!vcpu && irq_is_private(kvm, intid))
 		return -EINVAL;
=20
 	trace_vgic_update_irq_pending(vcpu ? vcpu->vcpu_idx : 0, intid, level);
=20
-	if (intid < VGIC_NR_PRIVATE_IRQS)
+	if (irq_is_private(kvm, intid))
 		irq =3D vgic_get_vcpu_irq(vcpu, intid);
 	else
 		irq =3D vgic_get_irq(kvm, intid);
@@ -685,7 +685,7 @@ int kvm_vgic_set_owner(struct kvm_vcpu *vcpu, unsigned =
int intid, void *owner)
 		return -EAGAIN;
=20
 	/* SGIs and LPIs cannot be wired up to any device */
-	if (!irq_is_ppi(intid) && !vgic_valid_spi(vcpu->kvm, intid))
+	if (!irq_is_ppi(vcpu->kvm, intid) && !vgic_valid_spi(vcpu->kvm, intid))
 		return -EINVAL;
=20
 	irq =3D vgic_get_vcpu_irq(vcpu, intid);
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index f2eafc65bbf4c..f12b47e589abc 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -19,6 +19,7 @@
 #include <linux/jump_label.h>
=20
 #include <linux/irqchip/arm-gic-v4.h>
+#include <linux/irqchip/arm-gic-v5.h>
=20
 #define VGIC_V3_MAX_CPUS	512
 #define VGIC_V2_MAX_CPUS	8
@@ -31,9 +32,78 @@
 #define VGIC_MIN_LPI		8192
 #define KVM_IRQCHIP_NUM_PINS	(1020 - 32)
=20
-#define irq_is_ppi(irq) ((irq) >=3D VGIC_NR_SGIS && (irq) < VGIC_NR_PRIVAT=
E_IRQS)
-#define irq_is_spi(irq) ((irq) >=3D VGIC_NR_PRIVATE_IRQS && \
-			 (irq) <=3D VGIC_MAX_SPI)
+#define is_v5_type(t, i)	(FIELD_GET(GICV5_HWIRQ_TYPE, (i)) =3D=3D (t))
+
+#define __irq_is_sgi(t, i)						\
+	({								\
+		bool __ret;						\
+									\
+		switch (t) {						\
+		case KVM_DEV_TYPE_ARM_VGIC_V5:				\
+			__ret =3D false;					\
+			break;						\
+		default:						\
+			__ret  =3D (i) < VGIC_NR_SGIS;			\
+		}							\
+									\
+		__ret;							\
+	})
+
+#define __irq_is_ppi(t, i)						\
+	({								\
+		bool __ret;						\
+									\
+		switch (t) {						\
+		case KVM_DEV_TYPE_ARM_VGIC_V5:				\
+			__ret =3D is_v5_type(GICV5_HWIRQ_TYPE_PPI, (i));	\
+			break;						\
+		default:						\
+			__ret  =3D (i) >=3D VGIC_NR_SGIS;			\
+			__ret &=3D (i) < VGIC_NR_PRIVATE_IRQS;		\
+		}							\
+									\
+		__ret;							\
+	})
+
+#define __irq_is_spi(t, i)						\
+	({								\
+		bool __ret;						\
+									\
+		switch (t) {						\
+		case KVM_DEV_TYPE_ARM_VGIC_V5:				\
+			__ret =3D is_v5_type(GICV5_HWIRQ_TYPE_SPI, (i));	\
+			break;						\
+		default:						\
+			__ret  =3D (i) <=3D VGIC_MAX_SPI;			\
+			__ret &=3D (i) >=3D VGIC_NR_PRIVATE_IRQS;		\
+		}							\
+									\
+		__ret;							\
+	})
+
+#define __irq_is_lpi(t, i)						\
+	({								\
+		bool __ret;						\
+									\
+		switch (t) {						\
+		case KVM_DEV_TYPE_ARM_VGIC_V5:				\
+			__ret =3D is_v5_type(GICV5_HWIRQ_TYPE_LPI, (i));	\
+			break;						\
+		default:						\
+			__ret  =3D (i) >=3D 8192;				\
+		}							\
+									\
+		__ret;							\
+	})
+
+#define irq_is_sgi(k, i) __irq_is_sgi((k)->arch.vgic.vgic_model, i)
+#define irq_is_ppi(k, i) __irq_is_ppi((k)->arch.vgic.vgic_model, i)
+#define irq_is_spi(k, i) __irq_is_spi((k)->arch.vgic.vgic_model, i)
+#define irq_is_lpi(k, i) __irq_is_lpi((k)->arch.vgic.vgic_model, i)
+
+#define irq_is_private(k, i) (irq_is_ppi(k, i) || irq_is_sgi(k, i))
+
+#define vgic_is_v5(k) ((k)->arch.vgic.vgic_model =3D=3D KVM_DEV_TYPE_ARM_V=
GIC_V5)
=20
 enum vgic_type {
 	VGIC_V2,		/* Good ol' GICv2 */
@@ -414,8 +484,20 @@ u64 vgic_v3_get_misr(struct kvm_vcpu *vcpu);
=20
 #define irqchip_in_kernel(k)	(!!((k)->arch.vgic.in_kernel))
 #define vgic_initialized(k)	((k)->arch.vgic.initialized)
-#define vgic_valid_spi(k, i)	(((i) >=3D VGIC_NR_PRIVATE_IRQS) && \
-			((i) < (k)->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS))
+#define vgic_valid_spi(k, i)						\
+	({								\
+		bool __ret =3D irq_is_spi(k, i);				\
+									\
+		switch ((k)->arch.vgic.vgic_model) {			\
+		case KVM_DEV_TYPE_ARM_VGIC_V5:				\
+			__ret &=3D FIELD_GET(GICV5_HWIRQ_ID, i) < (k)->arch.vgic.nr_spis; \
+			break;						\
+		default:						\
+			__ret &=3D (i) < ((k)->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS); \
+		}							\
+									\
+		__ret;							\
+	})
=20
 bool kvm_vcpu_has_pending_irqs(struct kvm_vcpu *vcpu);
 void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu);
--=20
2.34.1

