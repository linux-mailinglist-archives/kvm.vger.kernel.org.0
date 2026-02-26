Return-Path: <kvm+bounces-72053-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2B+iM5KGoGknkgQAu9opvQ
	(envelope-from <kvm+bounces-72053-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 18:44:50 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3089A1ACBE9
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 18:44:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CD95D32A5873
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 16:30:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DC7C4A33FF;
	Thu, 26 Feb 2026 16:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="JCAdkQ1A";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="JCAdkQ1A"
X-Original-To: kvm@vger.kernel.org
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011066.outbound.protection.outlook.com [52.101.70.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD3843E4B8
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 16:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.66
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772121916; cv=fail; b=XOcUOsBOovhWsyEERQebBZXXSIo27PmplT79OuaUMUbrMU/vX2zbdQwoX4unk8RhmXPwjktx20JQtHRYGHKjkvEtF5AjubO/AygBmHnqmz1y83PP3ZZ26KZHgOrGgR2l+aGd9Lv3Vzal+9R6IvDGgkoZknHnayst8knvD7PMRJU=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772121916; c=relaxed/simple;
	bh=q5gy2AaVDs8MCE7rhPEQzIRf/wVd58xdLeoqYlYvpO8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=e28c6Qbf73WThzAA9TFpH2kniqxrKZ7mCLOVhhJD4iMug/6gpCJejgP9EXmMQdtsh5JjojBRUDplpw55lhVnDXMJmVdbglao0ppRK1EuIiTnppb1KoMrFmKL8Zxxod1pLsvNKQFBR+za6o7sZQFw5dVL9cV31Pk0vrz/cHuPB+0=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=JCAdkQ1A; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=JCAdkQ1A; arc=fail smtp.client-ip=52.101.70.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Ab5lF+HSfoOMqMlyHbR64icN8js2R0tweaYM0OXLrQEfNDYvRo1JWyIi/B6ZvgmXPRAUBLzje0F6Hi5ZJ12KTaJk/lo8U9fGO7LszgqBUSZp21diTcRIEljcq0cjermt174LKzx6JHDIGW9rGjDpkApIKYxysWK+MxQ+2liIbaxG9qsmFvpwvUkxeT/cyDt5+6/3JQiMNnGoDa3Vyy3DoVXOYjgyppAO+7dak5QWdOg2qain+3BSKdZvPr1cjHR+BB0/RbhyTkZ4ER7sS37aTUyzq5Fsym+1T0/Ht/BvpqOMipMMODZWdwXn7wTRvZc3PAi4X4PmrSZLvnjzaxYRvA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gDZQV/4RuTis6K9nWMpwIW6VTdtu9zU19VjmNoDhv1g=;
 b=nW9mrM84Acve2WMSguHwJsCxw9wzqEK6i30nRRTNVSrTnoO36/FRxIqt08Pn1oa/pvGqtyakq94t04dp18FTspZlinkD64Ut6zhm6houXNwqS6x1TclRrTgx0f3f7kGjfREm5LxUzex9lZOyaONFM+v9Aa1XNj0pnsfxMDM3B5HEdNSdh+0sn4gvDweUCwiry1HA20PaC4qQCU8vv4jBj7De/ZJayFMP0syvBdx7TBY1d0nCpdGqPAJ4SJFzO8RCNfMK5qyro+u8tXwOTom2dKSm2MBGrFxpNlkrWu+Idn5WMmB2uqU6b8VgCWLqDH9g6/Qou77OHxPTOmm21+NI2g==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gDZQV/4RuTis6K9nWMpwIW6VTdtu9zU19VjmNoDhv1g=;
 b=JCAdkQ1AeRJygEqPqtPI9YVvxJbyRfooKdRjKRoUTuuQmYKpccu4VwusudPK0LX4PTKq7jlNzUEdVxe2hHywKUta10QEhy8fCIH79X0AVj/0l8tKwHla4eOgjZoOCBTcSq3XQYxblomT/BcX2jMDY2XfWcrtquINyBdBo9a5kOI=
Received: from AS4P251CA0004.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:5d2::6)
 by AS4PR08MB7604.eurprd08.prod.outlook.com (2603:10a6:20b:4ce::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.11; Thu, 26 Feb
 2026 16:05:04 +0000
Received: from AM4PEPF00027A60.eurprd04.prod.outlook.com
 (2603:10a6:20b:5d2:cafe::71) by AS4P251CA0004.outlook.office365.com
 (2603:10a6:20b:5d2::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.26 via Frontend Transport; Thu,
 26 Feb 2026 16:04:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A60.mail.protection.outlook.com (10.167.16.68) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.12
 via Frontend Transport; Thu, 26 Feb 2026 16:05:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lSYgDKUAfrtjj+mWoJxVb5y3sZJItdZXh6CI2axg88tt9Q064/vV+SpLD2dYzP1cLanuZCFXG39/hCIsUwjJSnSefBYuE1BjmBdnJtdUTu6oTreF9j0cnPHLdVOhvnhFJU3Q1AVOLuSx2ivKLDIMfKn3BTPyjVVAUrEGL/sHxnt6dBnv1RgkQhyWiu7MlaGLuicnhduLeynvSSSh9IoLhV2bsRUzeOI900NzUzuGRfoj/9Fi6Xf/l8xUWrMyckTu5NGQ6uz+4xysld+EHYSxwEYdu7i2lsCCqvjcVtHRfz+C85kR34pWl7kZPemU03yz0daoCTweeb7Jo8RkdHzGoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gDZQV/4RuTis6K9nWMpwIW6VTdtu9zU19VjmNoDhv1g=;
 b=Am/mUnNOI3svLS+DXyftGrMYEwlwIRb0tAG34gID64X/7MYvqoOImtyx1OjFeUxiK94vwErtVUCeO/Hf9z0LeN0OzADeKyIiQyVSD3LLg8mqaVbUrGei3un3EujUlGALusR0TQgixewy/lFL6uFIru4lwrwI6sS9CF2tf9dui/Mff/XXai7I4rgPvoxTCYDOqFuJGJPIvE3EoEE01pWEYarwhgO2lG+YWmCW38BENq5OHIMpIT5V1tJpg19hmUQQtcITGNGFqjYJZJCz3r5YR1kRVIYp6ME5t0OH8IHiVZsOy9+EPYcM9b6Ndb4HyWVB8iK7Fz+yGmxDXcbMdZ8y0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gDZQV/4RuTis6K9nWMpwIW6VTdtu9zU19VjmNoDhv1g=;
 b=JCAdkQ1AeRJygEqPqtPI9YVvxJbyRfooKdRjKRoUTuuQmYKpccu4VwusudPK0LX4PTKq7jlNzUEdVxe2hHywKUta10QEhy8fCIH79X0AVj/0l8tKwHla4eOgjZoOCBTcSq3XQYxblomT/BcX2jMDY2XfWcrtquINyBdBo9a5kOI=
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com (2603:10a6:10:1b1::17)
 by PA4PR08MB5950.eurprd08.prod.outlook.com (2603:10a6:102:e0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Thu, 26 Feb
 2026 16:04:00 +0000
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793]) by DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793%4]) with mapi id 15.20.9654.013; Thu, 26 Feb 2026
 16:04:00 +0000
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
Subject: [PATCH v5 33/36] Documentation: KVM: Introduce documentation for
 VGICv5
Thread-Topic: [PATCH v5 33/36] Documentation: KVM: Introduce documentation for
 VGICv5
Thread-Index: AQHcpzmF0GKqxoIUKk+Sc7P1G8L4Mw==
Date: Thu, 26 Feb 2026 16:04:00 +0000
Message-ID: <20260226155515.1164292-34-sascha.bischoff@arm.com>
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
	DBAPR08MB5687:EE_|PA4PR08MB5950:EE_|AM4PEPF00027A60:EE_|AS4PR08MB7604:EE_
X-MS-Office365-Filtering-Correlation-Id: c5ac098e-7454-4548-a408-08de7550ccba
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 aH/4TfKCTK9tnqi69ZqsAK5Sh9xhWOAYVnAszya/I676qCxA1y/Bw/P5Uzw65qPVDtgXU/+CNtSSwUWYMnCTxckgc+ilgnSxTdGtue+Coxf9b237XBYNvjkLeyfHANugWe7J1Ke2fFekXuESQWdLqBiDsFVUhPx2vIEVQqo/+QP0iQlt9Mlkl+QejcwiNzSnr4xlxCsxZfCU+Az83+CwdxzWBwC8WFadg8KnrXT7TbUmyE4kFsTIaoVHfD3JgkJf+tnAkSI36cEjlb18cNsMyaiPq1nDme50mRMLv5zKDmI3Kt3lP/c6J9WYDNC/TmUotzngiYesKDR9/gHCkQj5KIzeOucc7/S4xXVr3Bv8qcqzj9Ph9eGLlFOGT2/239YALYVTEyruNHcbRhXh3Mk2AB+6RV6JymBzxvHefSthiUoL20nEz7D18mjZ35kw2nX5PlxW8t14pH4me1cMQ4LRGkMqf+yDmNXu2wUBYnqMbh4Aq5vkh4J42h/ly7UU24rZpE80mPcXkrAEi7B5IM4o7WwLIWe2SNSrwy2TwtvhhsdGR7KAqD8NX2bZcNPicm0thDK9nrfv8jQbEzr5+zrVUjNn7B+I3xj2DeLN7oZeQ8tRatHBdVwcvekyjVkc2jWv2hJw0HPEd+fWd6nypNxRBiVZCm6c5U+dGq7YvHsIl0gDYsbGJudm8JMJcpSLhw+pOCDwIoi7aN2Jl+blQd2plnbwKztCl8Yt1mIjEvZT3UItFBIFKBffk8p/+L9s8AzpqN2yqQa8yalFfdwsXa0elAmu4JFdoOtzDQ/qx6QT5+w=
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
 AM4PEPF00027A60.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	2cc492dd-8622-4384-3ea8-08de7550a7a2
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014|30052699003|35042699022|14060799003;
X-Microsoft-Antispam-Message-Info:
	jFRYpfDN19IabFM7i2qMtMA5892Aof57McpdI2zmT8W4DwmByEwnXoyqRo3xCswOZFvZtXUDz6XfSd7dmQeNMw1wLttRQLSKy/JP9PqclYUXLiwntTDvS/OVXfHPq2q5oF87eKQgmhEIYYU2eWCv0ildK350ktB3b7uiaLWzn0JhqqpCrjkGEBLWmaqyY8w7mHzYS+aPh8SKs75u1YuDLpBiawbMR4tZf2260fS9O3yYbULjNYbJ6sZV/gC1gfdtEFI8aby0CJAeTth/vOTW3DvjfndpZURNFYmv7qZPW+nIEh5eLSrBjawpX9K8hzAIbCMChoaOOfoX1JJt1nzQIMFMmGw/WTmCWPaoiMQ77kJE9kpPPL647aXDNpIxRjbBIdP67HoeFkNi8bgZhjuFYOTTGupMvHwR7W7qoSb19KVqiCa2q9SWjEA20im1E4WED0F4oVu7s72jgT4EGDyrAfNIcfTehytZRjSEGEotrDxlKilteCNgDTXqH0GMOPQlJLissBrBNQkuaxYMlKHFrjFr8tLU2U70B2L8y//+knr2IjlASVT7K1B6eUGxz402qkKAyzD+Oh4127rD4GvoDLCkFLqSldsAum2pR+5iceX4bTkR6iGf0WAoOkg2E3WIubxumQzUFYa/f8vQ5mBe+DBqV2CkTZND5chd63H7wyoNR10BCAWrs94xYnw0f1KhsZk7PeyyvbybOwqOkraUPgyAq/FoJ8mzU1WF90UjqU3FIBlNi2/OryMRktV3h24ayreZ/ywqZqpSV8UPJCN3qE2gUABnkVfiDsoMFH4BopDJROd+zg/5QiAH94kIIYWkJMWNhFPxMOgrw/C3PmJ6fQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014)(30052699003)(35042699022)(14060799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	rtaBmWo+cJsntw7F1EBGtMe/j1NlpfzlBXK2zgDnsMgYWXG+mBnXrCvRAmhaKp0n717LiEsTMNGjuU4Xu+yDUnPTnk+cHJSHbZJPphziTw5moJbMKI3hnXcJTPyWHSWlGrMPDxelNw9DpCO4LnDgpN+Vqh0fTHDL0Jed5f5MVY45IFzUvlh9FQdXclAblKzy8PqpMltSwEKnYxQoQ9A6V0h8w+4abjGj9hAo3FTrYasutwRd7jKF6PiPv/Nn3HanI2cjqqEs/iL/7o1JZqfZZlJWmjO42T1tUO34sKxzC2tj1zwOf9GFgMXZMOeuHAKgU1MVKMx+q7f1QHOzxnhY8tEGcGvlKxIzbqTLYBQUrhY75KdPW8CLXytFgl5B+8fpiajZukNfRDPnlkbu3Ob/8Lg0TFCimfyX/XPUe2dxDm4mFYUYtlCvD3vW0BiiMNXg
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 16:05:02.4851
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c5ac098e-7454-4548-a408-08de7550ccba
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A60.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR08MB7604
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
	TAGGED_FROM(0.00)[bounces-72053-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,arm.com:mid,arm.com:dkim,arm.com:email,huawei.com:email];
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
X-Rspamd-Queue-Id: 3089A1ACBE9
X-Rspamd-Action: no action

Now that it is possible to create a VGICv5 device, provide initial
documentation for it. At this stage, there is little to document.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 .../virt/kvm/devices/arm-vgic-v5.rst          | 37 +++++++++++++++++++
 Documentation/virt/kvm/devices/index.rst      |  1 +
 2 files changed, 38 insertions(+)
 create mode 100644 Documentation/virt/kvm/devices/arm-vgic-v5.rst

diff --git a/Documentation/virt/kvm/devices/arm-vgic-v5.rst b/Documentation=
/virt/kvm/devices/arm-vgic-v5.rst
new file mode 100644
index 0000000000000..9904cb888277d
--- /dev/null
+++ b/Documentation/virt/kvm/devices/arm-vgic-v5.rst
@@ -0,0 +1,37 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
+ARM Virtual Generic Interrupt Controller v5 (VGICv5)
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
+
+
+Device types supported:
+  - KVM_DEV_TYPE_ARM_VGIC_V5     ARM Generic Interrupt Controller v5.0
+
+Only one VGIC instance may be instantiated through this API.  The created =
VGIC
+will act as the VM interrupt controller, requiring emulated user-space dev=
ices
+to inject interrupts to the VGIC instead of directly to CPUs.
+
+Creating a guest GICv5 device requires a host GICv5 host.  The current VGI=
Cv5
+device only supports PPI interrupts.  These can either be injected from em=
ulated
+in-kernel devices (such as the Arch Timer, or PMU), or via the KVM_IRQ_LIN=
E
+ioctl.
+
+Groups:
+  KVM_DEV_ARM_VGIC_GRP_CTRL
+   Attributes:
+
+    KVM_DEV_ARM_VGIC_CTRL_INIT
+      request the initialization of the VGIC, no additional parameter in
+      kvm_device_attr.addr. Must be called after all VCPUs have been creat=
ed.
+
+  Errors:
+
+    =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+    -ENXIO   VGIC not properly configured as required prior to calling
+             this attribute
+    -ENODEV  no online VCPU
+    -ENOMEM  memory shortage when allocating vgic internal data
+    -EFAULT  Invalid guest ram access
+    -EBUSY   One or more VCPUS are running
+    =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
diff --git a/Documentation/virt/kvm/devices/index.rst b/Documentation/virt/=
kvm/devices/index.rst
index 192cda7405c84..70845aba38f45 100644
--- a/Documentation/virt/kvm/devices/index.rst
+++ b/Documentation/virt/kvm/devices/index.rst
@@ -10,6 +10,7 @@ Devices
    arm-vgic-its
    arm-vgic
    arm-vgic-v3
+   arm-vgic-v5
    mpic
    s390_flic
    vcpu
--=20
2.34.1

