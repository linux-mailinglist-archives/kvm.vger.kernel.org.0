Return-Path: <kvm+bounces-69385-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oLebIIRQemnk5AEAu9opvQ
	(envelope-from <kvm+bounces-69385-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:08:04 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DEE6FA77C0
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:08:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E5077308189E
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 18:05:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEBA936F437;
	Wed, 28 Jan 2026 18:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="fj8XKNOW";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="fj8XKNOW"
X-Original-To: kvm@vger.kernel.org
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011033.outbound.protection.outlook.com [52.101.70.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D922C36F435
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 18:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.33
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769623525; cv=fail; b=m7NWjJVn+alw8u7ajtcyahxonoUjHY74++bejslC3CDNbwxYE++0HfVbi4btiHnqA5zUTVJFybE87mvEY/dskhvZSstZiKeonmTg/Sl0yXe2tlXn2ztZYvsYiwUzkvRlWbpPi0cSBhZbuAw0aiGxW/1jtdWUZgC8xyGdlKJbEds=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769623525; c=relaxed/simple;
	bh=4zCe+NllZ1AGknZ67LxzgQedhRhzBxeVi6nZUkIUS9c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ojbu6qD89Qg0QYZo0S6IIXLaa9NZy8RcOdr7qglHqQOqRDmeQxgRWCSP3lf+eiMD2hVdOczb0GuOo7BUQRCJdvD2UBc9jICvxNdoxIyNKvH10HUdvJ5LfuyUL9bUCsoqpjT++gYgZ3K3V08tGdjvLYoLitK0vLMVUqyv4WPi4m8=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=fj8XKNOW; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=fj8XKNOW; arc=fail smtp.client-ip=52.101.70.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=A+HzOKQGU71CA1JYRk8ONwvfNZ5wXXQzExxZ44vGfaSN2qoMceNNsVHJGPWTHw3Murg9nAUx0Ca5AKWCeC6KVJtTfZMd4U24UWWBNurEs8cLu29EYu27JtTgiwVqetExlo1KZQMlBjjEXHZhXkFhZrQjymv6/roGQYUiLhsFcj6K2KQX94ZVCQeq86xZPrpLEI4tgaIZlewkWzeQMgIuUw3XEwogWefDwDNlu2AG0FiHWwkLZnouchsQbnkSGfjkczcTFSUmmWTw7T1PfqXdVHlNFtliEEX/kY3CKuKoto9Y2WFigmfnN+/GfiUecfi1VCkG87dAWWLWzuAZLhIowg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kzhzVKLDzx1A295XTwSAffKWnlsm/TSSHKnuyDQlT4U=;
 b=GGd+OCu9E1i5tYTJNKCV3yCPOnsnp4ece19Zb8B7g4yDDMXA+urXbuV73j9Kzic7NB5grz1GupAw4txJkDO0jaspw9XY70PKF+4aFzaNSpbdkzOZT+u2G+02rsgx0MYVIqDKQNHmU9RH7ejB4HE3JtCcER5j0hg7Etv0uEj51FBVK180VI/ZRSVxc2lnuKgWK8KwhLyYbynZzghJC7CgjTPVARBVigXMwPckJ0FpNWtixa8J2xTvPBZtob/9c7EWhOSwlyQDyIatHIrIM/KgEKZjjBZ8itw15LZXgFgh4Wf+Q9Qeze+KyMKqormQDF3QxUfq2dnAHm6Z68iqeAif0g==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kzhzVKLDzx1A295XTwSAffKWnlsm/TSSHKnuyDQlT4U=;
 b=fj8XKNOWJHPGw6vQwkmxnnraVi3GDmG6Y09wAJmjR4rYwqizkyMZk+kmxwY9Bz4T7yvnNB7s/EveH6KfbFAeG9TjQHCK1Jhta+Xw6VnocuH4lUd2KcTIADjh+zdsbbFVTUd9RJcW3VdTnmcRw3jsk5NLFC7RgKjLAhGnSilsxsQ=
Received: from AS4P191CA0007.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:5d5::7)
 by AS8PR08MB10246.eurprd08.prod.outlook.com (2603:10a6:20b:63c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Wed, 28 Jan
 2026 18:05:15 +0000
Received: from AM4PEPF00027A6C.eurprd04.prod.outlook.com
 (2603:10a6:20b:5d5:cafe::d1) by AS4P191CA0007.outlook.office365.com
 (2603:10a6:20b:5d5::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.8 via Frontend Transport; Wed,
 28 Jan 2026 18:05:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A6C.mail.protection.outlook.com (10.167.16.90) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.3
 via Frontend Transport; Wed, 28 Jan 2026 18:05:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r2L1lsTNOy1Db4fn73YQHi1YmuIvujhTtpDxQPJCHpMPAnJzEhMi2BNJZ6PtOU15uEbyNKAPpxOHVZBWgUJRRr0fZAhp0otBSyI0FBtfz2uUmVaJOYuCVukHwRHIUOhKo91+5ovvufRj5qNRz5Mi21qVmjN3erYKLOBUMx4L3pQ2Lr/gl4qKGgvE1QulK18rF/MZKwgOB2pG1v5bXdUeqJ/KqNQZ+3ni5dkOD4xfWj77L+3zWfntugGwYmdT4VrO7zunXo0OB+1ejf2qzK+UEuWggUCt6V2gqDTTGHIZNJ3hihhr+PvsJzk5CEozQuTwf0p/kA9HZFFMPvoiJ8VhMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kzhzVKLDzx1A295XTwSAffKWnlsm/TSSHKnuyDQlT4U=;
 b=n95tm/ggsjsvWUDLnh/vGGF6I0CCj9SfVxhLnuEn9ai+23yRK0BwgCJSzzyEVHvswbV9FJgty9Z/SYwdqU/G7DCncKyNhJ2CCN3qvMp/pQ6gI8+odkdOMbg0MzpaFQE21jhFoj81D3ia5l7qNRzMBOB9dZZC+WSJYImutncHbf2xiwQZprvYlSk4SxgII6b+4g9mMC1FKnudWxPTMpi5bv98XJmIje9TvVXKDMv5hJ1TIbPev76FCIleZo5MtusxWOfy90Fj0YBH8AcYoQFdFhDljRpgjRjKWceQtMFgvQMM9cVx3vZbbJ7rSk3oZ5sbHhqCNF3gWJav+vJos31TBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kzhzVKLDzx1A295XTwSAffKWnlsm/TSSHKnuyDQlT4U=;
 b=fj8XKNOWJHPGw6vQwkmxnnraVi3GDmG6Y09wAJmjR4rYwqizkyMZk+kmxwY9Bz4T7yvnNB7s/EveH6KfbFAeG9TjQHCK1Jhta+Xw6VnocuH4lUd2KcTIADjh+zdsbbFVTUd9RJcW3VdTnmcRw3jsk5NLFC7RgKjLAhGnSilsxsQ=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by DB9PR08MB8483.eurprd08.prod.outlook.com (2603:10a6:10:3d5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Wed, 28 Jan
 2026 18:04:13 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9564.006; Wed, 28 Jan 2026
 18:04:13 +0000
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
Subject: [PATCH v4 19/36] KVM: arm64: gic-v5: Implement PPI interrupt
 injection
Thread-Topic: [PATCH v4 19/36] KVM: arm64: gic-v5: Implement PPI interrupt
 injection
Thread-Index: AQHckICCPv6x6YDK20eLRCFNSm33gw==
Date: Wed, 28 Jan 2026 18:04:12 +0000
Message-ID: <20260128175919.3828384-20-sascha.bischoff@arm.com>
References: <20260128175919.3828384-1-sascha.bischoff@arm.com>
In-Reply-To: <20260128175919.3828384-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS8PR08MB6744:EE_|DB9PR08MB8483:EE_|AM4PEPF00027A6C:EE_|AS8PR08MB10246:EE_
X-MS-Office365-Filtering-Correlation-Id: 23b6c098-b508-4734-8e99-08de5e97c9fd
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?TT2zwoKjqBZKS40M//Qa4zTdOWuM6W3oTkiAWRXsln8KxVfdJMVk4Uzj5N?=
 =?iso-8859-1?Q?i6NwGy0e8w2Vr1IKdYTEBNJk2VAdUrX17/jbDDWrM+oDhD0O85VwwrwNJ+?=
 =?iso-8859-1?Q?ASuEX11h0lOPkkT0aFCRRThe6uB5hn1ngF7HxKjo/k7twvHJeWmykdjaEl?=
 =?iso-8859-1?Q?FBYgtQrfWs5Yodn7dRdr8K2+i7KMEgMH1NN57wpscIisDaIMRmuV8A5sZF?=
 =?iso-8859-1?Q?EWmWIQ5mMMZoN+LI8tBZjD6OJJa93cO5orpzPwV7uISoMedXijDvtutU0K?=
 =?iso-8859-1?Q?E5OKaLYoFRbNgSiKmoH4nrXhxRiAobkRNrr9tu0X4VF6PzqzHWMDKziTJt?=
 =?iso-8859-1?Q?tXDE7kX+zGmn9O37Td/Dp8rcHVfB5W2qdXFP77gIe0ytTYF5e7Q6QFV+rP?=
 =?iso-8859-1?Q?HcUwP//lnj/lcfGmAzd7sNuV7yiv3zCZgljcYl1vfLu+6JcZyy/SxbPVki?=
 =?iso-8859-1?Q?ZA+os41zAIQ0LDYlZMZY5Jpyg3OQhPmiMbR7zfJUKsIxDE7lPNOgobSaxv?=
 =?iso-8859-1?Q?8mwPdpIVehBXs0ebw+sWq+OlV4WieLJoF5TiE4euTgrTBMitapCJ3PjBHf?=
 =?iso-8859-1?Q?ao/gct0mL5p8qskj7DZpfu9qTDWpR+w64eqBa+C5cKqnvyDlQeCJClWAOV?=
 =?iso-8859-1?Q?8G6Q50l8PKw+EFiaMQG2Zzt7xa8Bd1MwHsooYLcYonz/Uf8MC8E8QP2lgs?=
 =?iso-8859-1?Q?UkhHgv1mjXOU2cYRMwfHuhwHxliyPI4z7u1zLqqMEow43h+8dwHoQkw1GU?=
 =?iso-8859-1?Q?XLwSkCqmvXPXTQE/Iz+On0EoLBXnj14RMcg767uSuUS4EfHKvyrXtYM+HL?=
 =?iso-8859-1?Q?p9xRHvY7UnMyTP8bY58LiS52Ucdz+1XkhFCOjC5AJEB5MSSHQoyejAxAU9?=
 =?iso-8859-1?Q?0bwwIPgp1WkmFu90Z0bnFv3lKj5SOLdiI+HOn6Qzatdn5Q6vg947TZV8Zn?=
 =?iso-8859-1?Q?vnmkYe/LPajAV4WKijvkgNOHlVgDn0ErqRybbV+MQHgHvHMF58FGvF6M4f?=
 =?iso-8859-1?Q?UmN6vTKkH4oqLXxOCe6X+hMqKAoZ2Vl6wtcif6PuEhbkYvm/ztZZOvhiRq?=
 =?iso-8859-1?Q?M8PMjL7xsAbw8De4Zr9DmHZqS+q4reEAYfPAC8+KVnPsiTsmutCweBE2gp?=
 =?iso-8859-1?Q?xW5d6PgNjmt0q1kpfzjWRpOOSjgO//MGq2SoAtBDQ2MGakdu/lkTu4FhRU?=
 =?iso-8859-1?Q?ehgG4aywe2dQyXdmyE7/OSac3xpb6PuCNntb8vTYaAXFdaSlEPW8utLynZ?=
 =?iso-8859-1?Q?wpEeCHdbxOa2f+lpIyR45FcNh1YaLCZqsXfQJsRJ8jSZKiWxMmh/EOiJRg?=
 =?iso-8859-1?Q?a3uDdHap765O7nV6a4GN1Vr7KXF7hBfii8OzscAHio/Ka7ZMNzGtpknWEc?=
 =?iso-8859-1?Q?ath8qm1sbbs0r4G9/pmIYUB2PFciQK1hu2GKvVq6fbcSQoNJ2JB8P2p2F+?=
 =?iso-8859-1?Q?rxiXBBKaOqU/j2Xx21BWIf9BywmO9Q25iLkjpdUm8TpsTp+yvHjsAVkJCc?=
 =?iso-8859-1?Q?xwT3i8qaJKsluASPU+3b9EHxntEQ0hqYuzaKFtLJFnvpDV5dvOGDI7UOwz?=
 =?iso-8859-1?Q?xYmV/PcaZ3wNrN0pvJhfz/0ikUvijpuZJtSRhmpMJwtacw1SAuXgABjjWh?=
 =?iso-8859-1?Q?KREisyNYfPOkhqcqES4+X3fRupItm751Xujd9AOQMC7Z9odMUDGDg3drKs?=
 =?iso-8859-1?Q?095xUOIgIAZjxhI4F1E=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB8483
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A6C.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	118a5924-9e45-45f9-1690-08de5e97a4b9
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|14060799003|376014|35042699022|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?5dgipRGY/e1znND8cgBuXaO4xPfBOV1ty5qpDKCfDw53S4xnYZsHQOPq5f?=
 =?iso-8859-1?Q?EnHEQjuTrZWxFsvYTrg1PBchiI40MiWRjYlUAgCb4QdrJAAUTFqX9l8+if?=
 =?iso-8859-1?Q?rnx3NxGVUn1qTgtUhHWZllKBLf57jEQCYF73BQFQGPXGFe2ATZawOlcmgP?=
 =?iso-8859-1?Q?b42K8RGrAqdGE+mnNFm1WYlfc0AanjhODdYia03dCnBN63Euu96JWRaHqm?=
 =?iso-8859-1?Q?/HLGS41fWb0E0hnIfibZpGiZjeQo3gB0d7Kl7RYPjv3dP6RE0YmhYok+BN?=
 =?iso-8859-1?Q?KW/kBoAwQKyfWLVyDP/Pxz8dLmY3pnRHtIfyddxOspjfBljUmyD6Z0jSuf?=
 =?iso-8859-1?Q?nXpXqtS50b3d2lPtvTPj2a8I+L0xdx16/o715aCEsIM+GuTe/rhnWQ5ZoX?=
 =?iso-8859-1?Q?r5eZ7kLdH88tftq9/t9EnjntfdPeuRqQsB4IohxJBCiVGhI8RFY1JNapqI?=
 =?iso-8859-1?Q?0zj3cb+mJUEm5qaO1Qyy2QE9LI8BNZ6LbYapfuj2n5FaOrUqQYsdCEyaJ3?=
 =?iso-8859-1?Q?UR/opxa1UhvOseGb8guYaU9Uuiv4MO2jxs/IRxxU1md4AHuDn/cY9B2VvK?=
 =?iso-8859-1?Q?EVpU5e3TlQe0q44DlJujI9PY16MgDH5XfzgExg2X5f6hY3o92L5c+QcnyA?=
 =?iso-8859-1?Q?3GZM6VsqtjCm67uLjul/riGSldQePbPyrj/2zBECha+heIu6oOfSCrMbIo?=
 =?iso-8859-1?Q?UDoT9LUkDJwVUzFCLmUYqycmxetPQEV6UaYUZJ1sBsoUBbEVq8QwfQPBPZ?=
 =?iso-8859-1?Q?nMNpnxW3KOnHcDQW6wBKJUhtLf5VMLss7tJQrG42L9KjWn7QYLCHqVbAf/?=
 =?iso-8859-1?Q?+D2/nDlfO9uZgZ+tBagVQDccnelGGlya7ciiGFYVyIDTro7iYgk6RMQFqh?=
 =?iso-8859-1?Q?xXe/T1KDW4MLcI520B5wWg2dFvOUW5ZRNsRN+xfMQy2vqBbw1mM20wIvq+?=
 =?iso-8859-1?Q?MI092Fl8vLYkyWWUwUeCJs/LmaNIqMVVy5Dr57W2BXi6W9IM842WBq2Fqm?=
 =?iso-8859-1?Q?Uao/sHGWpvpIjLb5y124gU33e5AFwpY7TX7LzTch4G4r8vwtbMA8WtWC5s?=
 =?iso-8859-1?Q?+ESlwchWP5ZQb9Xe7JSpu+QjlkP8yUlD6P/K8JmjeurP1+3DtQM+heFsjI?=
 =?iso-8859-1?Q?0POTZi3xh9PBBELDJ2rDkeXZcZ13vhqPZfMWquiBjeMX5jZMLBzYnYw0uC?=
 =?iso-8859-1?Q?XH1N8Ps8jLO8EVjYwI3ceR2CLTyEK9bfU+yu7jJM6xTjBd7/IQ+LLFiiuW?=
 =?iso-8859-1?Q?h4HUbDSOdG3zeqJuliwSFxs3cQORbSItiE/7cQiLPqwQDxyr//lvTPue2Q?=
 =?iso-8859-1?Q?I76eCcMXe3MRwbnxQBOeeAu8gkzq1rDjgpG57E5mmZyO+PMQKaVL2+LGPb?=
 =?iso-8859-1?Q?2uxVA1RtrHbGoPZVmz18vAZ/u2p3eeOKpjxAqwwpWks8fmn9xqVp1XLXkd?=
 =?iso-8859-1?Q?enX1TDKcbmLhUpi6Uz3Jz8LsdWGelOBXKRbNFN4218XdBGhbzbd3hG6oUZ?=
 =?iso-8859-1?Q?Hklzvgv3MPSf3sgiKBo3HDDP5WWOwFMdrbwoylTDfErMAgj0gyFnPvIPpR?=
 =?iso-8859-1?Q?ePK6iHVcC7Zt9wWA+j+x6XZnPxxIhzBqg385kadTMcYfbDC0IoU/T+u5HX?=
 =?iso-8859-1?Q?xdGYx3fBOcSyNG1T9zoqG2rNVXalliSy9/AIKdIjK/R+FwRMyJ+KloCf/S?=
 =?iso-8859-1?Q?t8eKnBf5kneGYkY2pjrsGR35u+u0pD5ArhHgPIzz3wbNrjTtH7F7budZDF?=
 =?iso-8859-1?Q?wihg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(14060799003)(376014)(35042699022)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 18:05:15.4121
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 23b6c098-b508-4734-8e99-08de5e97c9fd
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A6C.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB10246
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
	TAGGED_FROM(0.00)[bounces-69385-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arm.com:email,arm.com:dkim,arm.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,huawei.com:email];
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
X-Rspamd-Queue-Id: DEE6FA77C0
X-Rspamd-Action: no action

This change introduces interrupt injection for PPIs for GICv5-based
guests.

The lifecycle of PPIs is largely managed by the hardware for a GICv5
system. The hypervisor injects pending state into the guest by using
the ICH_PPI_PENDRx_EL2 registers. These are used by the hardware to
pick a Highest Priority Pending Interrupt (HPPI) for the guest based
on the enable state of each individual interrupt. The enable state and
priority for each interrupt are provided by the guest itself (through
writes to the PPI registers).

When Direct Virtual Interrupt (DVI) is set for a particular PPI, the
hypervisor is even able to skip the injection of the pending state
altogether - it all happens in hardware.

The result of the above is that no AP lists are required for GICv5,
unlike for older GICs. Instead, for PPIs the ICH_PPI_* registers
fulfil the same purpose for all 128 PPIs. Hence, as long as the
ICH_PPI_* registers are populated prior to guest entry, and merged
back into the KVM shadow state on exit, the PPI state is preserved,
and interrupts can be injected.

When injecting the state of a PPI the state is merged into the
PPI-specific vgic_irq structure. The PPIs are made pending via the
ICH_PPI_PENDRx_EL2 registers, the value of which is generated from the
vgic_irq structures for each PPI exposed on guest entry. The
queue_irq_unlock() irq_op is required to kick the vCPU to ensure that
it seems the new state. The result is that no AP lists are used for
private interrupts on GICv5.

Prior to entering the guest, vgic_v5_flush_ppi_state() is called from
kvm_vgic_flush_hwstate(). This generates the pending state to inject
into the guest, and snapshots it (twice - an entry and an exit copy)
in order to track any changes. These changes can come from a guest
consuming an interrupt or from a guest making an Edge-triggered
interrupt pending.

When returning from running a guest, the guest's PPI state is merged
back into KVM's vgic_irq state in vgic_v5_merge_ppi_state() from
kvm_vgic_sync_hwstate(). The Enable and Active state is synced back for
all PPIs, and the pending state is synced back for Edge PPIs (Level is
driven directly by the devices generating said levels). The incoming
pending state from the guest is merged with KVM's shadow state to
avoid losing any incoming interrupts.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 160 ++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.c    |  40 +++++++--
 arch/arm64/kvm/vgic/vgic.h    |  25 ++++--
 3 files changed, 209 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index b7ff336dd50b..40412c61bd2e 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -136,6 +136,166 @@ void vgic_v5_get_implemented_ppis(void)
 		ppi_caps->impl_ppi_mask[0] |=3D BIT_ULL(GICV5_ARCH_PPI_PMUIRQ);
 }
=20
+/*
+ * For GICv5, the PPIs are mostly directly managed by the hardware. We (th=
e
+ * hypervisor) handle the pending, active, enable state save/restore, but =
don't
+ * need the PPIs to be queued on a per-VCPU AP list. Therefore, sanity che=
ck the
+ * state, unlock, and return.
+ */
+static bool vgic_v5_ppi_queue_irq_unlock(struct kvm *kvm, struct vgic_irq =
*irq,
+					 unsigned long flags)
+	__releases(&irq->irq_lock)
+{
+	struct kvm_vcpu *vcpu;
+
+	lockdep_assert_held(&irq->irq_lock);
+
+	if (WARN_ON_ONCE(!__irq_is_ppi(KVM_DEV_TYPE_ARM_VGIC_V5, irq->intid)))
+		goto out_unlock_fail;
+
+	vcpu =3D irq->target_vcpu;
+	if (WARN_ON_ONCE(!vcpu))
+		goto out_unlock_fail;
+
+	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+
+	/* Directly kick the target VCPU to make sure it sees the IRQ */
+	kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
+	kvm_vcpu_kick(vcpu);
+
+	return true;
+
+out_unlock_fail:
+	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+
+	return false;
+}
+
+static struct irq_ops vgic_v5_ppi_irq_ops =3D {
+	.queue_irq_unlock =3D vgic_v5_ppi_queue_irq_unlock,
+};
+
+void vgic_v5_set_ppi_ops(struct vgic_irq *irq)
+{
+	if (WARN_ON(!irq))
+		return;
+
+	guard(raw_spinlock_irqsave)(&irq->irq_lock);
+
+	if (!WARN_ON(irq->ops))
+		irq->ops =3D &vgic_v5_ppi_irq_ops;
+}
+
+/*
+ * Detect any PPIs state changes, and propagate the state with KVM's
+ * shadow structures.
+ */
+void vgic_v5_fold_ppi_state(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+
+	for (int reg =3D 0; reg < 2; reg++) {
+		const u64 activer =3D host_data_ptr(vgic_v5_ppi_state)->activer_exit[reg=
];
+		const u64 pendr =3D host_data_ptr(vgic_v5_ppi_state)->pendr_exit[reg];
+		unsigned long changed_bits;
+		int i;
+
+		/*
+		 * Track what changed across activer, pendr, but mask with
+		 * ~DVI.
+		 */
+		changed_bits =3D cpu_if->vgic_ppi_activer[reg] ^ activer;
+		changed_bits |=3D host_data_ptr(vgic_v5_ppi_state)->pendr_entry[reg] ^ p=
endr;
+		changed_bits &=3D ~cpu_if->vgic_ppi_dvir[reg];
+
+		for_each_set_bit(i, &changed_bits, 64) {
+			struct vgic_irq *irq;
+			u32 intid;
+
+			intid =3D FIELD_PREP(GICV5_HWIRQ_TYPE, GICV5_HWIRQ_TYPE_PPI);
+			intid |=3D FIELD_PREP(GICV5_HWIRQ_ID, reg * 64 + i);
+
+			irq =3D vgic_get_vcpu_irq(vcpu, intid);
+
+			scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
+				irq->active =3D !!(activer & BIT(i));
+
+				/*
+				 * This is an OR to avoid losing incoming
+				 * edges!
+				 */
+				if (irq->config =3D=3D VGIC_CONFIG_EDGE)
+					irq->pending_latch |=3D !!(pendr & BIT(i));
+			}
+
+			vgic_put_irq(vcpu->kvm, irq);
+		}
+
+		/*
+		 * Re-inject the exit state as entry state next time!
+		 *
+		 * Note that the write of the Enable state is trapped, and hence
+		 * there is nothing to explcitly sync back here as we already
+		 * have the latest copy by definition.
+		 */
+		cpu_if->vgic_ppi_activer[reg] =3D activer;
+	}
+}
+
+void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu)
+{
+	unsigned long pendr[2];
+
+	/*
+	 * Time to enter the guest - we first need to build the guest's
+	 * ICC_PPI_PENDRx_EL1, however.
+	 */
+	pendr[0] =3D 0;
+	pendr[1] =3D 0;
+	for (int reg =3D 0; reg < 2; reg++) {
+		u64 mask =3D vcpu->kvm->arch.vgic.gicv5_vm.vgic_ppi_mask[reg];
+		unsigned long bm_p =3D 0;
+		int i;
+
+		bitmap_from_arr64(&bm_p, &mask, 64);
+
+		for_each_set_bit(i, &bm_p, 64) {
+			struct vgic_irq *irq;
+			u32 intid;
+
+			intid =3D FIELD_PREP(GICV5_HWIRQ_TYPE, GICV5_HWIRQ_TYPE_PPI);
+			intid |=3D FIELD_PREP(GICV5_HWIRQ_ID, reg * 64 + i);
+
+			irq =3D vgic_get_vcpu_irq(vcpu, intid);
+
+			scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
+				if (irq_is_pending(irq))
+					__assign_bit(i % 64, &pendr[reg], 1);
+			}
+
+			vgic_put_irq(vcpu->kvm, irq);
+		}
+	}
+
+	/*
+	 * Copy the shadow state to the pending reg that will be written to the
+	 * ICH_PPI_PENDRx_EL2 regs. While the guest is running we track any
+	 * incoming changes to the pending state in the vgic_irq structures. The
+	 * incoming changes are merged with the outgoing changes on the return
+	 * path.
+	 */
+	host_data_ptr(vgic_v5_ppi_state)->pendr_entry[0] =3D pendr[0];
+	host_data_ptr(vgic_v5_ppi_state)->pendr_entry[1] =3D pendr[1];
+
+	/*
+	 * Make sure that we can correctly detect "edges" in the PPI
+	 * state. There's a path where we never actually enter the guest, and
+	 * failure to do this risks losing pending state
+	 */
+	host_data_ptr(vgic_v5_ppi_state)->pendr_exit[0] =3D pendr[0];
+	host_data_ptr(vgic_v5_ppi_state)->pendr_exit[1] =3D pendr[1];
+}
+
 /*
  * Sets/clears the corresponding bit in the ICH_PPI_DVIR register.
  */
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 49d65e8cc742..69bfa0f81624 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -105,6 +105,18 @@ struct vgic_irq *vgic_get_vcpu_irq(struct kvm_vcpu *vc=
pu, u32 intid)
 	if (WARN_ON(!vcpu))
 		return NULL;
=20
+	if (vgic_is_v5(vcpu->kvm)) {
+		u32 int_num, hwirq_id;
+
+		if (!__irq_is_ppi(KVM_DEV_TYPE_ARM_VGIC_V5, intid))
+			return NULL;
+
+		hwirq_id =3D FIELD_GET(GICV5_HWIRQ_ID, intid);
+		int_num =3D array_index_nospec(hwirq_id, VGIC_V5_NR_PRIVATE_IRQS);
+
+		return &vcpu->arch.vgic_cpu.private_irqs[int_num];
+	}
+
 	/* SGIs and PPIs */
 	if (intid < VGIC_NR_PRIVATE_IRQS) {
 		intid =3D array_index_nospec(intid, VGIC_NR_PRIVATE_IRQS);
@@ -825,9 +837,11 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
 		vgic_release_deleted_lpis(vcpu->kvm);
 }
=20
-static inline void vgic_fold_lr_state(struct kvm_vcpu *vcpu)
+static void vgic_fold_state(struct kvm_vcpu *vcpu)
 {
-	if (kvm_vgic_global_state.type =3D=3D VGIC_V2)
+	if (vgic_is_v5(vcpu->kvm))
+		vgic_v5_fold_ppi_state(vcpu);
+	else if (kvm_vgic_global_state.type =3D=3D VGIC_V2)
 		vgic_v2_fold_lr_state(vcpu);
 	else
 		vgic_v3_fold_lr_state(vcpu);
@@ -1034,8 +1048,10 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 	if (can_access_vgic_from_kernel())
 		vgic_save_state(vcpu);
=20
-	vgic_fold_lr_state(vcpu);
-	vgic_prune_ap_list(vcpu);
+	vgic_fold_state(vcpu);
+
+	if (!vgic_is_v5(vcpu->kvm))
+		vgic_prune_ap_list(vcpu);
 }
=20
 /* Sync interrupts that were deactivated through a DIR trap */
@@ -1059,6 +1075,17 @@ static inline void vgic_restore_state(struct kvm_vcp=
u *vcpu)
 		__vgic_v3_restore_state(&vcpu->arch.vgic_cpu.vgic_v3);
 }
=20
+static void vgic_flush_state(struct kvm_vcpu *vcpu)
+{
+	if (vgic_is_v5(vcpu->kvm)) {
+		vgic_v5_flush_ppi_state(vcpu);
+		return;
+	}
+
+	scoped_guard(raw_spinlock, &vcpu->arch.vgic_cpu.ap_list_lock)
+		vgic_flush_lr_state(vcpu);
+}
+
 /* Flush our emulation state into the GIC hardware before entering the gue=
st. */
 void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 {
@@ -1095,13 +1122,12 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
=20
 	DEBUG_SPINLOCK_BUG_ON(!irqs_disabled());
=20
-	scoped_guard(raw_spinlock, &vcpu->arch.vgic_cpu.ap_list_lock)
-		vgic_flush_lr_state(vcpu);
+	vgic_flush_state(vcpu);
=20
 	if (can_access_vgic_from_kernel())
 		vgic_restore_state(vcpu);
=20
-	if (vgic_supports_direct_irqs(vcpu->kvm))
+	if (vgic_supports_direct_irqs(vcpu->kvm) && kvm_vgic_global_state.has_gic=
v4)
 		vgic_v4_commit(vcpu);
 }
=20
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index d5d9264f0a1e..c8f538e65303 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -364,7 +364,10 @@ void vgic_debug_destroy(struct kvm *kvm);
=20
 int vgic_v5_probe(const struct gic_kvm_info *info);
 void vgic_v5_get_implemented_ppis(void);
+void vgic_v5_set_ppi_ops(struct vgic_irq *irq);
 int vgic_v5_set_ppi_dvi(struct kvm_vcpu *vcpu, u32 irq, bool dvi);
+void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu);
+void vgic_v5_fold_ppi_state(struct kvm_vcpu *vcpu);
 void vgic_v5_load(struct kvm_vcpu *vcpu);
 void vgic_v5_put(struct kvm_vcpu *vcpu);
 void vgic_v5_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
@@ -433,15 +436,6 @@ void vgic_its_invalidate_all_caches(struct kvm *kvm);
 int vgic_its_inv_lpi(struct kvm *kvm, struct vgic_irq *irq);
 int vgic_its_invall(struct kvm_vcpu *vcpu);
=20
-bool system_supports_direct_sgis(void);
-bool vgic_supports_direct_msis(struct kvm *kvm);
-bool vgic_supports_direct_sgis(struct kvm *kvm);
-
-static inline bool vgic_supports_direct_irqs(struct kvm *kvm)
-{
-	return vgic_supports_direct_msis(kvm) || vgic_supports_direct_sgis(kvm);
-}
-
 int vgic_v4_init(struct kvm *kvm);
 void vgic_v4_teardown(struct kvm *kvm);
 void vgic_v4_configure_vsgis(struct kvm *kvm);
@@ -481,6 +475,19 @@ static inline bool vgic_is_v3(struct kvm *kvm)
 	return kvm_vgic_global_state.type =3D=3D VGIC_V3 || vgic_is_v3_compat(kvm=
);
 }
=20
+bool system_supports_direct_sgis(void);
+bool vgic_supports_direct_msis(struct kvm *kvm);
+bool vgic_supports_direct_sgis(struct kvm *kvm);
+
+static inline bool vgic_supports_direct_irqs(struct kvm *kvm)
+{
+	/* GICv5 always supports direct IRQs */
+	if (vgic_is_v5(kvm))
+		return true;
+
+	return vgic_supports_direct_msis(kvm) || vgic_supports_direct_sgis(kvm);
+}
+
 int vgic_its_debug_init(struct kvm_device *dev);
 void vgic_its_debug_destroy(struct kvm_device *dev);
=20
--=20
2.34.1

