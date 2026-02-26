Return-Path: <kvm+bounces-72036-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EPxKDdd3oGmtjwQAu9opvQ
	(envelope-from <kvm+bounces-72036-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:41:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 062D21AAD19
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:41:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 3F4D330B8CE5
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 16:17:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9CAC47887E;
	Thu, 26 Feb 2026 16:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="m9rx6/5d";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="m9rx6/5d"
X-Original-To: kvm@vger.kernel.org
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013031.outbound.protection.outlook.com [40.107.159.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C0394779B0
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 16:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.31
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772121666; cv=fail; b=KUJX8euBBrySWCVKoXg7lgwGEjMRxfMw4VrWHQj0J+Kf24QgRKN90fvxmUHU5RPi7Tl4DNUPJsRVE18v27CnlZb7/2Nwgz/b0biwHUwpJ59trG3xGfsut6IshfhQ5/Gxhouzkgie5Vcu/CQZ+mYRVvFiB8zkTbchjTzn0cYd5Yc=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772121666; c=relaxed/simple;
	bh=o/oJF1U2cReqh7pnTO4l+iHAgb4C5U8qKZUEcrXjM50=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YYV5vqN7IapbrL0mNKghFUzrkk+iGRE2sPNvJxrai3nP15rRtvEckTXoegmZMkgtnBKUMzo4eiUv8Km5kzu1LYsvK0SuUgUnbGbunoLqHpMUPthk75vNomYjnNww1CRCXiJEJx0DnjYqnIeiIYNHyUpWKhmI8u3skz+0vIewsKI=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=m9rx6/5d; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=m9rx6/5d; arc=fail smtp.client-ip=40.107.159.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=XNUkxBKzV/n2PVZtOEgf12sBK5JRHHZ0M+qk8xOhZi5LUT5BYJQ/tDSW+bS9/+wJiHFgDhwI4fdxXHyoyLHYTyoMU49rhcG0+sc8Z+Pqncno+aNj2J2gSmjJNOx9PqEyJeonuBjR+G81aLC/pxEaQc5EzNlMQ2AJ6IsgWVjbx9kK+Y4mo5jNx1cD62244RC3M37fKu+g19wbAj8QQ13F9/8RfWMK55olKj43SrbziPX4T4vAABpKQ5UPzs4Pw9BpkM7ILm58Pp8xHX/7hyS/1GbAccU3xLw5NvVxv41vLkdCKBFsrX6OY5UFU125sdJ78ySaaDgONWmOqFbXVe+7IA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=10aZ81HebK5F2/XI8GgT0H0wk8m06M0IIhvsOP2nKK4=;
 b=r8txBsgC16xNYDq5QEu7klkOpDU2XgtSvmMxg7KcQFypcbzm8vu7Yaqytsu9ViLwDnIHUYffLWqb1uYnVmqv9QixlEvPxpgFqKhSonCGvdqyaebcp/fRewj9QYnNMwUBWd7E86JbjpbAuhp6CetB6Uu60S0x5/awnsrqqrszgJ7oXlzvVAl/QaNquS4gHO1nS33r3+tSA2mdYguKSN4PZBZKBU7g6PAuJQZ3IEq/+R6+am2H4txP3kmuRACtXmQbk0+lfw3t5PT1JOIfAx15WqupfcCGUAY7Gv24IjPxC+L1zxjSnW/5gGOri4iFeFfUTvRWGlRQn5T9xuvq+fY7pA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=10aZ81HebK5F2/XI8GgT0H0wk8m06M0IIhvsOP2nKK4=;
 b=m9rx6/5ddy8p6sq66MaGrBbX298J9BFquCqst9RxiLtURTRQbFfOKIbF2aXhfGAbgJFSEk1J8SgmoTYWWjPXqqGizMQB1LjKLINLUXp0ZBn9EmTL0Gh54A1fFsr3sl8UPHbFrNjBsdscpRIjcJ4kIn7UjeOqGoc4vS/IhKqzT68=
Received: from DUZPR01CA0200.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b6::10) by AM7PR08MB5415.eurprd08.prod.outlook.com
 (2603:10a6:20b:10d::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.13; Thu, 26 Feb
 2026 16:00:51 +0000
Received: from DB5PEPF00014B90.eurprd02.prod.outlook.com
 (2603:10a6:10:4b6:cafe::ae) by DUZPR01CA0200.outlook.office365.com
 (2603:10a6:10:4b6::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.26 via Frontend Transport; Thu,
 26 Feb 2026 16:00:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B90.mail.protection.outlook.com (10.167.8.228) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.12
 via Frontend Transport; Thu, 26 Feb 2026 16:00:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mLRinmabSrCzi5MtEVtvNRmI3J2KGukEB7beoPG+UfX2iiOzzfdsVvNhtPP/o5gZ8YvFsj3jVvVefehVIO5JWypAOChN8WQ1iJWVgIj718uc5Xro8zbPbYaljubE6xAvraHRJv/GFs5uaNhL7I/cjjmUD/TUuJb8sYW7sowO2pFms2Kr8skEedfGgPmxQuTCSD/BbNeg353cvFrErjGNbCXizn5qNUoGGryb4zLIrSn1u9K/gTmET9Gfj33vzw+46OBmtp6lOISg8jKe+U5c003KKNcSWeAL1V0eldM1ycEt8d9631sLDDi0Nb7ydICVKmA/gH24QeLqOCHMmzYQ9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=10aZ81HebK5F2/XI8GgT0H0wk8m06M0IIhvsOP2nKK4=;
 b=Ji3pVmjQsXtWI9wXHhl9co4qVt5KFY2/YsWhNpaToZNV+JA4pc8dfF9X3I3Hl5ENJCwc6VKMOg3cTuGgdwUzGjN6/KHnn2uvuGfuR+b4EEgFlX2a+cRKRX/r6s+7dsJuKpNCJxumuiChYiH86kJJ2JRq50SEG9jikpMNsg9ABi2REa/5xbypypkm/MEdqmBGNOjU7IdghuVUBl/sOdlWQKYMTGLcj4lSJrrtQmmfy/dbnCR3vI3nRGK1O48eTtJnZHhcHbifXDuzhIRtI8/7r2azeHPv3VyWHuhPiPhLhwuOLnA1Ck2Efrb1CCrphSnVwRWJZ5Hm+GaFwFeBUd9PBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=10aZ81HebK5F2/XI8GgT0H0wk8m06M0IIhvsOP2nKK4=;
 b=m9rx6/5ddy8p6sq66MaGrBbX298J9BFquCqst9RxiLtURTRQbFfOKIbF2aXhfGAbgJFSEk1J8SgmoTYWWjPXqqGizMQB1LjKLINLUXp0ZBn9EmTL0Gh54A1fFsr3sl8UPHbFrNjBsdscpRIjcJ4kIn7UjeOqGoc4vS/IhKqzT68=
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com (2603:10a6:10:1b1::17)
 by DU0PR08MB7486.eurprd08.prod.outlook.com (2603:10a6:10:356::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.15; Thu, 26 Feb
 2026 15:59:49 +0000
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793]) by DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793%4]) with mapi id 15.20.9654.013; Thu, 26 Feb 2026
 15:59:48 +0000
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
Subject: [PATCH v5 17/36] KVM: arm64: gic-v5: Finalize GICv5 PPIs and generate
 mask
Thread-Topic: [PATCH v5 17/36] KVM: arm64: gic-v5: Finalize GICv5 PPIs and
 generate mask
Thread-Index: AQHcpzjvcgzcmr0D7EeCSZxOwboJzg==
Date: Thu, 26 Feb 2026 15:59:48 +0000
Message-ID: <20260226155515.1164292-18-sascha.bischoff@arm.com>
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
	DBAPR08MB5687:EE_|DU0PR08MB7486:EE_|DB5PEPF00014B90:EE_|AM7PR08MB5415:EE_
X-MS-Office365-Filtering-Correlation-Id: 5069ad5b-6bd8-405d-a7ec-08de75503741
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 ylQO2bHPB2DytV+p0auLhVSW4HHJbdtIB2KBfK7OTTwLQzws1tf+twFjDfHOlm3jEAJH8a4O8yfTXX6LuB1WDwKWA+IMOpbCSocyifmvVGLqc+5yInTDpZ1EoOWvfdJKZUVlawkxt/pQnxFPrcOJXOmLWdSSuPq5ce9NW8ZJ5ICbABdG0GlBU2ZqxUBsrfqh12moXSRbEAGRUEb60iROmu9BviHgWH9VUNG9ShO84NHLXjVPBQsqMIgKYjeFZY5gGHQLRp1P764v3dlazkGv8oiMiHMkV/SGZVQCBWEImhxTvfNLZed1ErYo1z/W/dIWMynXvw4Gxc8S2eprYVQfzySHa8ZCVvH/iMrWyhpybyLdhGqbSNRxP+vm3aKZ80fohl+jRxpAvcUj1Iifbwu00fWIpqNb8n2oUaDsTsAZfiJTsGjebyY48wCkOuHIRqrKlGvuGn9R55PJgtMjwxfPuy7SY/9jylLWd2coyxdUWapmWmzjQVxBoI7BcypsbXGurF833LtH4zaFnvrUUsHXpsWsVVglnaWzV0QOefMbO4jOToRZOJ5fC7yG4nzsEai/wqgXzQmPA9czhj59amfT5f/troQ+UCHCas0nxmaUtBOhZMF57iSRlJLT59cQQqNN8zLL9Qn9fWccl3UlzaIv2AjxCqfoS+4f2BlfDnmXacQ+a266eWcoJR+UoyOfgNL97VnIaqPrbEyQdD+fH7DD45GC9tiRSDTn8TAsQZeMAZcefkHXC62r7UZuH2B8atKxlN0NKbnxDQ31utbbfF3CDH8LUNe+E+rO/7c4fIvMULQ=
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
 DB5PEPF00014B90.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	4c64c247-803f-42c1-5d95-08de755011be
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|1800799024|82310400026|376014|36860700013|14060799003;
X-Microsoft-Antispam-Message-Info:
	bVD9mQHU0flcfINWQ3dIyVOj2kmbbguPnYqjigoZNZjMDwnAuxbCEPHyZ7jCUZsRm7Rb10qh5Z4BJAhwEM73JoGX1KsZtpwk33pPHank6YOOHyxoxkhQNn5ZlG2si0ZPdik6rm5fABXRSvuPNuqes2KWb5m/VqMRTD5y6zxYWTImokTt7qqjIEtscmLi/lKOpScK3Zb5u7j96G8wJuKTnoqq7paG4Ou1pbMqPgTsWwrnD65lCKR8zdV1a5TzZpZ4VSUdyJWB7xYIL7wlcvmQqLaczRdnvJoOA5CqRz258WW1tXKMKxCj1WEc3WNNRxJtBHK0Jg4+rT5LMlg2C7TAWp3hDHp+cymIUGqGBYgDPVI2UwqaKa8jXuXdFYXPcUV8IFDz5Of6E7D6EZGiaAmSml6HcQ6bDW3QNGjlADA/47ITlm8bMhYDxOTfAuI1uSVt0gYbmd3Bai5TqzDjPlZKp6DXjCwhUXS9eBj/HtwTjT904crTHcSvoO0Uzp1G+6DWabq8WGMpmU+sxOr0ve28/+MSf37+UpL7Y7xjQxxvWWevQQ9nEngd66/0Mfqf7F7cGWP9DEEOTcT/sK0PhSB19LonYjdu3L3LLEeufY7d3l0MGgpQv1wL/kq/3ev9MLy1kL7y/P/whfaE1l9HieV+Ogb8VRZDPhV6xEhXyUpM7nCY0H9AEco/gTA+8JPpk3tTpJslqj4ZgD+Zb0MFZKF1NQgSNUn2XSUz70SxIfJ9BsD9CiZdvfk1T6qnsxwGI0LbZrivHo0klZBAX3bkBxnqdTDd2TUEgnV6Ctc4RZypGTRgGxrQfZY9up3BqczOssjmrCTnYuDAUa5+t3vuOoMgqA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(1800799024)(82310400026)(376014)(36860700013)(14060799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	HVgeyMUrbA39UEcbT3f37IUTSiaRr8PZBoc6IEPv52KtduSpcdya7E5T3vYds1+oAKTLIB7gI6kAXtLfwBa5R2djTf6OKbdi8SoGjLTt4s0tNw3vMoqOyLUc3yH/Nab0Gr+g7ZawKyMEEnjdCleG9i3OZCyDTgi8OEh/5oTWDJgPn+xSXOkRemakIMYqsZZG2RvbFac+w8CCMV99mZBZZ2ID/drJ/P6tRYs5k3m6hGTFvitOs0zWY8suNL1qtCA5kkjuhXjOQjCTQxpaBrV2YUFkQJnMAqedJRqQW9JVgOJynSio2A0Zae8rqm7uO1Mtk6A/uHuUC4Esa62Vkm/3GoxTtnAZ4gvAiYa5PCZUJlAp/liFDNBqbGUzdbPXDiAO/tJJ7P13DUfCpgcTStlh3sfboIAoC/sCao2WkNCYtmbfqdADn7mRTeVO2SZOP7Yj
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 16:00:51.7064
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5069ad5b-6bd8-405d-a7ec-08de75503741
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B90.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR08MB5415
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72036-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[huawei.com:email,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,arm.com:mid,arm.com:dkim,arm.com:email];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[Sascha.Bischoff@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[arm.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: 062D21AAD19
X-Rspamd-Action: no action

We only want to expose a subset of the PPIs to a guest. If a PPI does
not have an owner, it is not being actively driven by a device. The
SW_PPI is a special case, as it is likely for userspace to wish to
inject that.

Therefore, just prior to running the guest for the first time, we need
to finalize the PPIs. A mask is generated which, when combined with
trapping a guest's PPI accesses, allows for the guest's view of the
PPI to be filtered. This mask is global to the VM as all VCPUs PPI
configurations must match.

In addition, the PPI HMR is calculated.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/kvm/arm.c               |  4 +++
 arch/arm64/kvm/vgic/vgic-v5.c      | 46 ++++++++++++++++++++++++++++++
 include/kvm/arm_vgic.h             |  9 ++++++
 include/linux/irqchip/arm-gic-v5.h | 17 +++++++++++
 4 files changed, 76 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index eb2ca65dc7297..8290c5df0616e 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -935,6 +935,10 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu=
)
 			return ret;
 	}
=20
+	ret =3D vgic_v5_finalize_ppi_state(kvm);
+	if (ret)
+		return ret;
+
 	if (is_protected_kvm_enabled()) {
 		ret =3D pkvm_create_hyp_vm(kvm);
 		if (ret)
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index f5cd9decfc26e..db2225aefb130 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -86,6 +86,52 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	return 0;
 }
=20
+int vgic_v5_finalize_ppi_state(struct kvm *kvm)
+{
+	struct kvm_vcpu *vcpu;
+
+	if (!vgic_is_v5(kvm))
+		return 0;
+
+	/* The PPI state for all VCPUs should be the same. Pick the first. */
+	vcpu =3D kvm_get_vcpu(kvm, 0);
+
+	vcpu->kvm->arch.vgic.gicv5_vm.vgic_ppi_mask[0] =3D 0;
+	vcpu->kvm->arch.vgic.gicv5_vm.vgic_ppi_mask[1] =3D 0;
+	vcpu->kvm->arch.vgic.gicv5_vm.vgic_ppi_hmr[0] =3D 0;
+	vcpu->kvm->arch.vgic.gicv5_vm.vgic_ppi_hmr[1] =3D 0;
+
+	for (int i =3D 0; i < VGIC_V5_NR_PRIVATE_IRQS; i++) {
+		int reg =3D i / 64;
+		u64 bit =3D BIT_ULL(i % 64);
+		struct vgic_irq *irq =3D &vcpu->arch.vgic_cpu.private_irqs[i];
+
+		guard(raw_spinlock_irqsave)(&irq->irq_lock);
+
+		/*
+		 * We only expose PPIs with an owner or the SW_PPI to the
+		 * guest.
+		 */
+		if (!irq->owner &&
+		    FIELD_GET(GICV5_HWIRQ_ID, irq->intid) !=3D GICV5_ARCH_PPI_SW_PPI)
+			continue;
+
+		/*
+		 * If the PPI isn't implemented, we can't pass it through to a
+		 * guest anyhow.
+		 */
+		if (!(ppi_caps.impl_ppi_mask[reg] & bit))
+			continue;
+
+		vcpu->kvm->arch.vgic.gicv5_vm.vgic_ppi_mask[reg] |=3D bit;
+
+		if (irq->config =3D=3D VGIC_CONFIG_LEVEL)
+			vcpu->kvm->arch.vgic.gicv5_vm.vgic_ppi_hmr[reg] |=3D bit;
+	}
+
+	return 0;
+}
+
 /*
  * Sets/clears the corresponding bit in the ICH_PPI_DVIR register.
  */
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index d828861f8298a..a4416afca5efc 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -32,6 +32,8 @@
 #define VGIC_MIN_LPI		8192
 #define KVM_IRQCHIP_NUM_PINS	(1020 - 32)
=20
+#define VGIC_V5_NR_PRIVATE_IRQS	128
+
 #define is_v5_type(t, i)	(FIELD_GET(GICV5_HWIRQ_TYPE, (i)) =3D=3D (t))
=20
 #define __irq_is_sgi(t, i)						\
@@ -381,6 +383,11 @@ struct vgic_dist {
 	 * else.
 	 */
 	struct its_vm		its_vm;
+
+	/*
+	 * GICv5 per-VM data.
+	 */
+	struct gicv5_vm		gicv5_vm;
 };
=20
 struct vgic_v2_cpu_if {
@@ -567,6 +574,8 @@ int vgic_v4_load(struct kvm_vcpu *vcpu);
 void vgic_v4_commit(struct kvm_vcpu *vcpu);
 int vgic_v4_put(struct kvm_vcpu *vcpu);
=20
+int vgic_v5_finalize_ppi_state(struct kvm *kvm);
+
 bool vgic_state_is_nested(struct kvm_vcpu *vcpu);
=20
 /* CPU HP callbacks */
diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm=
-gic-v5.h
index 3e838a3058861..30a1b656daa35 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -380,6 +380,23 @@ struct gicv5_vpe {
 	bool			resident;
 };
=20
+struct gicv5_vm {
+	/*
+	 * We only expose a subset of PPIs to the guest. This subset
+	 * is a combination of the PPIs that are actually implemented
+	 * and what we actually choose to expose.
+	 */
+	u64			vgic_ppi_mask[2];
+
+	/*
+	 * The HMR itself is handled by the hardware, but we still need to have
+	 * a mask that we can use when merging in pending state (only the state
+	 * of Edge PPIs is merged back in from the guest an the HMR provides a
+	 * convenient way to do that).
+	 */
+	u64			vgic_ppi_hmr[2];
+};
+
 struct gicv5_its_devtab_cfg {
 	union {
 		struct {
--=20
2.34.1

