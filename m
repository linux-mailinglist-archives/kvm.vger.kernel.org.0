Return-Path: <kvm+bounces-69390-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gD/8EQ9Semnk5AEAu9opvQ
	(envelope-from <kvm+bounces-69390-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:14:39 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A3A95A7989
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:14:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5439830F8FA0
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 18:08:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 716D737472A;
	Wed, 28 Jan 2026 18:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="RtRnz28Q";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="RtRnz28Q"
X-Original-To: kvm@vger.kernel.org
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012053.outbound.protection.outlook.com [52.101.66.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E242A372B4C
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 18:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.53
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769623601; cv=fail; b=S9cNrqfMgtjkk0WSyNA+IzKeHOV2owp3tv7XSjiwjJ7gOSxCCmXYtVpSjniM2CI7RZzJH7h82fJnbb72IM11HMottG6j3WhLTaQzL4FZ0qNKFGGCM8f1ajy9Z5NWcaSLsQXdfIm6FURQhbe6dR5maxe9AF5V4WLS9iQim0uSy3g=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769623601; c=relaxed/simple;
	bh=jqcYW13CUAlz1rGxeVk5rAKIREusog1mO5qTrMLSRVA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EJDM+zPrS+JDuHq2Lym4p8y3RoAeQYnyrzaqc62xTFot6fjCKlscvyLbnpL6m8/ODVaspqdOZonAIKrpbbF11byLMR+Yy4orK00aNnqj5Khp7mckm95SPtnjJH2CipRuDx6jTCpa5XE7KZ8qkOGYH3f3fRNuPYblfjcHeNF1ojQ=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=RtRnz28Q; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=RtRnz28Q; arc=fail smtp.client-ip=52.101.66.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Je9gHAuQ5HPOiurQ6okOpU1MzsSkHEah2MZXXlrH5+EfFO6jq4hx3BhQHCI9u6DIk83GoXCB1ILfX9VT72G8sRZBnyb6/8dD5dfLFBmtgLYw119pue+oyQu0CNZ5/k2EV/GP/nqRqnaJQvgCXLfG6Z8WppL9nATaTXVgV7YytDbdYvK1zqwXt5ZXAxbyXyyDeanTdjTASZrF2/qjmzeF9EKLafM66KDgxmSEhm9YG6sEap735LPhbKAh1uF0R0onoP4joV7p6fU/iry+hW/lS9DDkdINlaqxBVvd+jGRAlPPzY+dDNxZ188eOeh8XMyqBaWyh+QYSjWNjMA8yOxgWA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b8KGgUqQMZfgIZHmPSx62HWSaRYu2dv/0XfJ3+AopiQ=;
 b=iirVkqifgEV6xP0HFpMoLGg5AO1eWMBF+USTi+zuE3yx2YRG9mk4meoMVjXr8SloXHluUxGpHIRgutE+oBwm9uEQCufWlGxo+oBpNKeXRhjcxdytEVePi5BxgOYWen7a3X3U1fngAO96eB7gMwqdix8lZaKKfhoFmkblhcX/o1qx8i39+nwvVn1UmiSQRhbxScUbmL/FL8Y61L94UvQB9JC+cMk2kmM/oD0A5GHM29Sfat5x3WXTJjBujsmkknu138ezwpfjjoFl9Qw+iItf3VxKpW2y2m6+6UcbR2HNgnJzRmS+YbX3d1DNUVwNlkUOelvWFvgBLEUYbYeLrhpsFw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b8KGgUqQMZfgIZHmPSx62HWSaRYu2dv/0XfJ3+AopiQ=;
 b=RtRnz28QQCxbRO5V64y9gX8n6XErYuTf1APRodovaLZx0YXkFd0zYREV6tatPONUpGSXbet9syKbRLTor3ywSNBUhnLiRaGWs4Mk4xQb2/lvN/gpSOON8iOjN/33AdYteLGZ38CthusHghaSBHyu5jN4yPu2k1046Fy7oRO+/LM=
Received: from CWLP123CA0031.GBRP123.PROD.OUTLOOK.COM (2603:10a6:401:58::19)
 by AM0PR08MB5300.eurprd08.prod.outlook.com (2603:10a6:208:18e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Wed, 28 Jan
 2026 18:06:33 +0000
Received: from AMS0EPF000001AA.eurprd05.prod.outlook.com
 (2603:10a6:401:58:cafe::1f) by CWLP123CA0031.outlook.office365.com
 (2603:10a6:401:58::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.8 via Frontend Transport; Wed,
 28 Jan 2026 18:06:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001AA.mail.protection.outlook.com (10.167.16.150) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.3
 via Frontend Transport; Wed, 28 Jan 2026 18:06:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z6/acnz2hviqaXtVNobG1cA4BpP8icBEzcO1kFTqOp5BKztUu4xbY8J8zxKrNvcYCNWg/kl2LGfgPtDXai4rTS2QZtExV4n9bcE2zwiZo/rla4+dVxRU78xqNuxmvIPRpmCYwvSxihudNzFPaDYkZ4taEdjRQwZUFlgI/uBrLBEptfJfMD+dTDI71Wqy1W60oUU+Ut9oFFkkFFmlbi+EUrpCWzgTDAljp6HE3hnkw6bHAg3QvV0h3UXdHaOL/hNdfjdDi2iBe54g5JOK9xGsHJ8uy6bCaStcXI5ayqjybDT+ryc+NEeiDdy8nrJXvMELgbckuOW9GyVDM0LZZidWVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b8KGgUqQMZfgIZHmPSx62HWSaRYu2dv/0XfJ3+AopiQ=;
 b=WdLzTWrweaUzLvz4SBnjnw4awPghkljRPQCBYP9P6pN1JgmjbG4vVRdWEuAmymXhdHnyeMtnC07uo0kVPbdbzHDVa7S+nAkdVOtCrdknqVw9hQH+4Fi7AYXvTp781khaBin2kqouly43FB6cWAkHbJd/Zqn3L7qgtbojfg69eYISz3Heg4tTGqFvCQHpsKOQLqhwFiyRGBBrMRIsDYm7EyON+B8eEVGlxGh7W/iVefWL6o8ADBnzwKdP3GV3HBNqdnHWGHkofPaOh3m6ECBPM0F8vL2fjkziU0uwHNM15IBZ0PSSTQJlrtfd+w0yhG39G9QXUbChCrQ5hoWH+Apx9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b8KGgUqQMZfgIZHmPSx62HWSaRYu2dv/0XfJ3+AopiQ=;
 b=RtRnz28QQCxbRO5V64y9gX8n6XErYuTf1APRodovaLZx0YXkFd0zYREV6tatPONUpGSXbet9syKbRLTor3ywSNBUhnLiRaGWs4Mk4xQb2/lvN/gpSOON8iOjN/33AdYteLGZ38CthusHghaSBHyu5jN4yPu2k1046Fy7oRO+/LM=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by AS2PR08MB9740.eurprd08.prod.outlook.com (2603:10a6:20b:604::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.14; Wed, 28 Jan
 2026 18:05:30 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9564.006; Wed, 28 Jan 2026
 18:05:30 +0000
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
Subject: [PATCH v4 24/36] KVM: arm64: gic-v5: Create and initialise vgic_v5
Thread-Topic: [PATCH v4 24/36] KVM: arm64: gic-v5: Create and initialise
 vgic_v5
Thread-Index: AQHckICwokB9uvJlHE2+j1urQPaFug==
Date: Wed, 28 Jan 2026 18:05:30 +0000
Message-ID: <20260128175919.3828384-25-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|AS2PR08MB9740:EE_|AMS0EPF000001AA:EE_|AM0PR08MB5300:EE_
X-MS-Office365-Filtering-Correlation-Id: 4162193d-1d36-447d-1e40-08de5e97f83f
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?Bmbg5u2ZGqfCuHfp0JrZbzjyYUPE2F8rloPKvVE8w0yM6IfK57VvHhXMMK?=
 =?iso-8859-1?Q?I2JX1vw3hmLmwFf+SPlyl1XGwJ+aAuldJAtns6mKLlwnYv3vgbzxqyp+jO?=
 =?iso-8859-1?Q?Q6o+35kAGQmr4mxxLM8w/Ia3iKxriMk6tTuPBgcKPDb+o8FCCbQOV/u+PH?=
 =?iso-8859-1?Q?KNyoEJB03N2UgmoF9sIX80qOSCy0NW6EbhLglrWGiAjrsx67NuJcFWiXSz?=
 =?iso-8859-1?Q?HmJLj4HFaNqQdymeh2Vh9PBkPTdzifUy/Yw/QniHsOKSIQa6cBd49r2Lzy?=
 =?iso-8859-1?Q?ugP3wJPfCVC/moHhTFCiYIQNOcPfJlKgbhW2r31Loa1ej200sYcAEOQEJE?=
 =?iso-8859-1?Q?Ysin1kpXLAxlMqUMtfuH7Mu8rRZiQ/LqtQcg4jN+IzAgyYA/2crkqNDWZP?=
 =?iso-8859-1?Q?PFDxsvkcx0LHGpXMzxhRCMI58RA1YuXYhD4fWp49l/KOeNbtNFw2Uzawzl?=
 =?iso-8859-1?Q?6L62DKsMH/kO/hP2u38UxSAabop9Ttl6oTIdu56aYb8UNYXQh/bgtIU6QX?=
 =?iso-8859-1?Q?znZCOmD5/ncxaJ+mK/gdyLCvrunEF1R5jwjE3qnZbIocXYstBt096jMGDS?=
 =?iso-8859-1?Q?St3PPnC/mtw/Dm+stlnV+gYqROC50HkpCrYq0Of8NydvUDNTBBnX0lKxy+?=
 =?iso-8859-1?Q?NqUqhr1ZHoW+o9eiTFE3YtQSmQn0BdQ5GkAxEhFf58hwhuh9qKS775lGfp?=
 =?iso-8859-1?Q?7p0mwOCXBHY1loHvxzj8+hnVvu2uhmYzmJl8hUGsNjyzrwNAp84Lq1FwDm?=
 =?iso-8859-1?Q?knq5gh2lHNCODS78i4brR8bxhQdDG8k331fcTRf+ldW98g4a4i7WpH80/4?=
 =?iso-8859-1?Q?pJGEA6D+HcVxMhFYIr8z18m+mT+8zDk7n4ZMavPxfh3HIHQekCyxYSA5uU?=
 =?iso-8859-1?Q?wwrEozGIJVUWDgyJPIjuvjGpWtC5f84CYe0L92jVHzeTtzG1MCHwA5BCEv?=
 =?iso-8859-1?Q?yezbmDqt/UwUrguWYV/LM+HfWIXQ2Y67SaYycTDHjw1g+1WhJygcYLHINA?=
 =?iso-8859-1?Q?V8jUF5f+iZkbMayjCTHgKAz8xPkYUrBuIj44N6J6nrdXoDz8gt62sG3uAh?=
 =?iso-8859-1?Q?/RVZFwUOzpAx+SZ6nWFGitS5jh8pBywOkyb/ayUkgl6QFcbbezKOvMBEpL?=
 =?iso-8859-1?Q?c79FGH7AVmXHTQy5Z9oI/86v7YGEt3zfK0EJ4mE5GDkph1bSY1cdsV4twV?=
 =?iso-8859-1?Q?6iwjSnG838XmdA5iC/uNoc0JBQObgnSnCLQdtuVWweeL44x/GKRDGz2lO8?=
 =?iso-8859-1?Q?FKE+KT8Ai/Dtkfa9wkMMoc/q42XekpoUV6wzYVw/x7R0cEx70OmimyjDdc?=
 =?iso-8859-1?Q?LYunPMejxG4VEfLpdXhosahrxfMu/mWrP5LUaSV2z8ZWwNoehIwFhGD6kR?=
 =?iso-8859-1?Q?RUIUOo4Mg242QeXdn9Yg+RgFi576NEDuEXDNBYR4Hgsed2DYcCbnThMUw0?=
 =?iso-8859-1?Q?VBvUwimTFbLe1wer43Upa2WpfqdlUZlh501aHbVU2vF2+UJ/+autjoykay?=
 =?iso-8859-1?Q?bPjaQ37hOOV5nbZKPqMNkitPSJGZxdJ3e/XBaxuFFo2EMU2ET3SlBkrfZv?=
 =?iso-8859-1?Q?XPcKlE35uolBntoueYWBjntb+vAWYICVikbOi+algIbO0PGUP6bO0+ZRen?=
 =?iso-8859-1?Q?v9WEt5niGYjf6TyEjmw4xBvA9d7VvteXlyraBgUzzQwWe4sSSnTLqVWP2x?=
 =?iso-8859-1?Q?1gWtLiy+jSe99TiJTY8=3D?=
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
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9740
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001AA.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	913ae6a8-c4b8-487c-6fcc-08de5e97d2bb
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|35042699022|36860700013|14060799003|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?FcAq0bZIwgUbiTc9qJm40PiGKwCOmRdZgdsrrP+fxC5xr9gJWv5JUZSwsS?=
 =?iso-8859-1?Q?KrVYpGgg4uK3aVxC39oA9AB13RPSHGc0MQljQvHLkOZzNjfFPOmcTJpfTS?=
 =?iso-8859-1?Q?TzEIzom56fXWwahEPVQtVjqBKUH4n4Z4oJZf+BCrWr2TMFeZmFrC5jpAAf?=
 =?iso-8859-1?Q?DBzNllsDP2GHw2h97cGY04xuLYrkUu6Dg2OSa0ts0BZwhcuRTuXAku3yee?=
 =?iso-8859-1?Q?Rqt4GJQNT0iUpOZSDHgyqi1cBJbh8M0E/oh3Fy1k6jxGtyB0TKPzOB6jDJ?=
 =?iso-8859-1?Q?kTJZe39bX5xDeraxz64mOH5HsHS9o/oMadeKerQ2V/lhHu+LxrRFhGEMVj?=
 =?iso-8859-1?Q?9xoLCmn1MTAlYmfpJKtB+kS9tAtrxSVtRejsbg6b/tUytan7V7aNVDsiwf?=
 =?iso-8859-1?Q?3+PXMEZ13m3Lj7TVkVN7AJBhMKCgyIguiAjktgIKRKqp74m4brLjI2+UTu?=
 =?iso-8859-1?Q?x9ueYyrzllBD9SsZcEL6echkoMLrjI6Wvc5/AG9eD3jpfps23FfHugHVKF?=
 =?iso-8859-1?Q?/4Mexs5s12fvoN/3GqADSQOnMjmymiPz00XPx4GMOteiB7Aa3B4Cr/0ybG?=
 =?iso-8859-1?Q?dHPPf9AV03ih2WHNPBr4zPQ4LLVs5vU5RSRBnRCmtFm71d4V+9C3bUdmA7?=
 =?iso-8859-1?Q?qgWujemPL6P9VpddJ35auUVzfcqbPVJL+XTX+H4sbIjEYj0+YBlcPoO8Z2?=
 =?iso-8859-1?Q?U+rOYHTlUVmhUtHQXr4i/FFcx76E3FSdeKg/3qvS8wtrdbwNJZNWzvgN1o?=
 =?iso-8859-1?Q?7E1PObE5pypMOm+KWuoF6gfvM8F4db95YwB4sJTMLPv0sbOLc+atqLrr/z?=
 =?iso-8859-1?Q?S8Js5zx7QAs+niJdtTVgfOgJth5jGwjd3Yl20CW+i7ipQ1d/9ylaZPepQ4?=
 =?iso-8859-1?Q?uRYagfy74dqu+P61I8LgpXqEDGSwt44l4CU4Bd547Bhpprq7ATmijlULtb?=
 =?iso-8859-1?Q?11SVaqC857KSjsLVWJXFnH/ebY1epHtu7qIpJd7Q2SYFXCiV4QzY4bzHPr?=
 =?iso-8859-1?Q?9K0e9olUaZe3oRawt06izS5gQ1OQdM7gn3xC4NPMkeM6rZG6VvYAFKUldh?=
 =?iso-8859-1?Q?SM4uJTtG9h6b9D2jEI8LHaREdWmtq2GwVFoEm+xQb4L6QXA2Vr8K/7jURD?=
 =?iso-8859-1?Q?hyh9uPwbHVVtOedgib5fV346wNVhcKPDwix7JsHwT0kvNFGaPC2Azx9dXU?=
 =?iso-8859-1?Q?7IhFgqQOiX1iKNh0j4zvNlOlCxW9xwp9UT68vXZI9D68+61tSL2aycDRXf?=
 =?iso-8859-1?Q?UEio+5OXt0tUWdsURWdqb4/IkWULLhZGEV96ertU4OVoiuvn5EwobE3zcg?=
 =?iso-8859-1?Q?rMbjTaLHzWOilWIuttBejeMM8hRFaCtii5tUPjmqokD5HaNLGw7Afgn+Ej?=
 =?iso-8859-1?Q?NsXay8v4mhbkpmhU03aZobCQ5iTC04uFQplVEthpNesC3n/KgykEHrWe/g?=
 =?iso-8859-1?Q?m1o429S3McY6yjWr2AMXVgZxI+NrUbeHwKqiuzdRSpZ6f5WmoyvZUIMban?=
 =?iso-8859-1?Q?EHDPWO9ycabM2NVBHHfrQGSNwfJno+YeSSf2k9R+nQ1sD1pSiDUN1w0/ru?=
 =?iso-8859-1?Q?TGf0QleWnTJw7kZfKDBb7GxE6subhwLy3wTESXFhmXpS8xMrOPPKglHlqT?=
 =?iso-8859-1?Q?9l9cKYp9peLJTKutYkBQ0tXV3yGQc411I5vqeAOy31v9FIqnpOOCZ27tW6?=
 =?iso-8859-1?Q?GI2k+3jLkLVe3bFcnKO8CaEblGQN4Q9AsQl3xaoEyD3wPiaDsUnPSZx6zD?=
 =?iso-8859-1?Q?EnXw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(35042699022)(36860700013)(14060799003)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 18:06:33.0132
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4162193d-1d36-447d-1e40-08de5e97f83f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001AA.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB5300
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=3];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69390-lists,kvm=lfdr.de];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[arm.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[Sascha.Bischoff@arm.com,kvm@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: A3A95A7989
X-Rspamd-Action: no action

Update kvm_vgic_create to create a vgic_v5 device. When creating a
vgic, FEAT_GCIE in the ID_AA64PFR2 is only exposed to vgic_v5-based
guests, and is hidden otherwise. GIC in ~ID_AA64PFR0_EL1 is never
exposed for a vgic_v5 guest.

When initialising a vgic_v5, skip kvm_vgic_dist_init as GICv5 doesn't
support one. The current vgic_v5 implementation only supports PPIs, so
no SPIs are initialised either.

The current vgic_v5 support doesn't extend to nested guests. Therefore,
the init of vgic_v5 for a nested guest is failed in vgic_v5_init.

As the current vgic_v5 doesn't require any resources to be mapped,
vgic_v5_map_resources is simply used to check that the vgic has indeed
been initialised. Again, this will change as more GICv5 support is
merged in.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/kvm/vgic/vgic-init.c | 62 +++++++++++++++++++++------------
 arch/arm64/kvm/vgic/vgic-v5.c   | 26 ++++++++++++++
 arch/arm64/kvm/vgic/vgic.h      |  2 ++
 include/kvm/arm_vgic.h          |  1 +
 4 files changed, 69 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index 973bbbe56062..c8109dba9807 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -66,12 +66,12 @@ static int vgic_allocate_private_irqs_locked(struct kvm=
_vcpu *vcpu, u32 type);
  * or through the generic KVM_CREATE_DEVICE API ioctl.
  * irqchip_in_kernel() tells you if this function succeeded or not.
  * @kvm: kvm struct pointer
- * @type: KVM_DEV_TYPE_ARM_VGIC_V[23]
+ * @type: KVM_DEV_TYPE_ARM_VGIC_V[235]
  */
 int kvm_vgic_create(struct kvm *kvm, u32 type)
 {
 	struct kvm_vcpu *vcpu;
-	u64 aa64pfr0, pfr1;
+	u64 aa64pfr0, aa64pfr2, pfr1;
 	unsigned long i;
 	int ret;
=20
@@ -132,8 +132,11 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
=20
 	if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V2)
 		kvm->max_vcpus =3D VGIC_V2_MAX_CPUS;
-	else
+	else if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V3)
 		kvm->max_vcpus =3D VGIC_V3_MAX_CPUS;
+	else if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V5)
+		kvm->max_vcpus =3D min(VGIC_V5_MAX_CPUS,
+				     kvm_vgic_global_state.max_gic_vcpus);
=20
 	if (atomic_read(&kvm->online_vcpus) > kvm->max_vcpus) {
 		ret =3D -E2BIG;
@@ -163,17 +166,21 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 	kvm->arch.vgic.vgic_dist_base =3D VGIC_ADDR_UNDEF;
=20
 	aa64pfr0 =3D kvm_read_vm_id_reg(kvm, SYS_ID_AA64PFR0_EL1) & ~ID_AA64PFR0_=
EL1_GIC;
+	aa64pfr2 =3D kvm_read_vm_id_reg(kvm, SYS_ID_AA64PFR2_EL1) & ~ID_AA64PFR2_=
EL1_GCIE;
 	pfr1 =3D kvm_read_vm_id_reg(kvm, SYS_ID_PFR1_EL1) & ~ID_PFR1_EL1_GIC;
=20
 	if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V2) {
 		kvm->arch.vgic.vgic_cpu_base =3D VGIC_ADDR_UNDEF;
-	} else {
+	} else if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V3) {
 		INIT_LIST_HEAD(&kvm->arch.vgic.rd_regions);
 		aa64pfr0 |=3D SYS_FIELD_PREP_ENUM(ID_AA64PFR0_EL1, GIC, IMP);
 		pfr1 |=3D SYS_FIELD_PREP_ENUM(ID_PFR1_EL1, GIC, GICv3);
+	} else {
+		aa64pfr2 |=3D SYS_FIELD_PREP_ENUM(ID_AA64PFR2_EL1, GCIE, IMP);
 	}
=20
 	kvm_set_vm_id_reg(kvm, SYS_ID_AA64PFR0_EL1, aa64pfr0);
+	kvm_set_vm_id_reg(kvm, SYS_ID_AA64PFR2_EL1, aa64pfr2);
 	kvm_set_vm_id_reg(kvm, SYS_ID_PFR1_EL1, pfr1);
=20
 	if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V3)
@@ -418,22 +425,28 @@ int vgic_init(struct kvm *kvm)
 	if (kvm->created_vcpus !=3D atomic_read(&kvm->online_vcpus))
 		return -EBUSY;
=20
-	/* freeze the number of spis */
-	if (!dist->nr_spis)
-		dist->nr_spis =3D VGIC_NR_IRQS_LEGACY - VGIC_NR_PRIVATE_IRQS;
+	if (!vgic_is_v5(kvm)) {
+		/* freeze the number of spis */
+		if (!dist->nr_spis)
+			dist->nr_spis =3D VGIC_NR_IRQS_LEGACY - VGIC_NR_PRIVATE_IRQS;
=20
-	ret =3D kvm_vgic_dist_init(kvm, dist->nr_spis);
-	if (ret)
-		goto out;
+		ret =3D kvm_vgic_dist_init(kvm, dist->nr_spis);
+		if (ret)
+			return ret;
=20
-	/*
-	 * Ensure vPEs are allocated if direct IRQ injection (e.g. vSGIs,
-	 * vLPIs) is supported.
-	 */
-	if (vgic_supports_direct_irqs(kvm)) {
-		ret =3D vgic_v4_init(kvm);
+		/*
+		 * Ensure vPEs are allocated if direct IRQ injection (e.g. vSGIs,
+		 * vLPIs) is supported.
+		 */
+		if (vgic_supports_direct_irqs(kvm)) {
+			ret =3D vgic_v4_init(kvm);
+			if (ret)
+				return ret;
+		}
+	} else {
+		ret =3D vgic_v5_init(kvm);
 		if (ret)
-			goto out;
+			return ret;
 	}
=20
 	kvm_for_each_vcpu(idx, vcpu, kvm)
@@ -441,12 +454,12 @@ int vgic_init(struct kvm *kvm)
=20
 	ret =3D kvm_vgic_setup_default_irq_routing(kvm);
 	if (ret)
-		goto out;
+		return ret;
=20
 	vgic_debug_init(kvm);
 	dist->initialized =3D true;
-out:
-	return ret;
+
+	return 0;
 }
=20
 static void kvm_vgic_dist_destroy(struct kvm *kvm)
@@ -590,6 +603,7 @@ int vgic_lazy_init(struct kvm *kvm)
 int kvm_vgic_map_resources(struct kvm *kvm)
 {
 	struct vgic_dist *dist =3D &kvm->arch.vgic;
+	bool needs_dist =3D true;
 	enum vgic_type type;
 	gpa_t dist_base;
 	int ret =3D 0;
@@ -608,12 +622,16 @@ int kvm_vgic_map_resources(struct kvm *kvm)
 	if (dist->vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V2) {
 		ret =3D vgic_v2_map_resources(kvm);
 		type =3D VGIC_V2;
-	} else {
+	} else if (dist->vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V3) {
 		ret =3D vgic_v3_map_resources(kvm);
 		type =3D VGIC_V3;
+	} else {
+		ret =3D vgic_v5_map_resources(kvm);
+		type =3D VGIC_V5;
+		needs_dist =3D false;
 	}
=20
-	if (ret)
+	if (ret || !needs_dist)
 		goto out;
=20
 	dist_base =3D dist->vgic_dist_base;
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index db74550d1353..1a0e8d693aa6 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -56,6 +56,32 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	return 0;
 }
=20
+int vgic_v5_init(struct kvm *kvm)
+{
+	struct kvm_vcpu *vcpu;
+	unsigned long idx;
+
+	if (vgic_initialized(kvm))
+		return 0;
+
+	kvm_for_each_vcpu(idx, vcpu, kvm) {
+		if (vcpu_has_nv(vcpu)) {
+			kvm_err("Nested GICv5 VMs are currently unsupported\n");
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+int vgic_v5_map_resources(struct kvm *kvm)
+{
+	if (!vgic_initialized(kvm))
+		return -EBUSY;
+
+	return 0;
+}
+
 int vgic_v5_finalize_ppi_state(struct kvm *kvm)
 {
 	struct kvm_vcpu *vcpu;
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 2c067b571d56..c7d7546415cb 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -364,6 +364,8 @@ void vgic_debug_destroy(struct kvm *kvm);
=20
 int vgic_v5_probe(const struct gic_kvm_info *info);
 void vgic_v5_get_implemented_ppis(void);
+int vgic_v5_init(struct kvm *kvm);
+int vgic_v5_map_resources(struct kvm *kvm);
 void vgic_v5_set_ppi_ops(struct vgic_irq *irq);
 int vgic_v5_set_ppi_dvi(struct kvm_vcpu *vcpu, u32 irq, bool dvi);
 bool vgic_v5_has_pending_ppi(struct kvm_vcpu *vcpu);
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 113b3fc7fd43..eb0f2f6888c7 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -21,6 +21,7 @@
 #include <linux/irqchip/arm-gic-v4.h>
 #include <linux/irqchip/arm-gic-v5.h>
=20
+#define VGIC_V5_MAX_CPUS	512
 #define VGIC_V3_MAX_CPUS	512
 #define VGIC_V2_MAX_CPUS	8
 #define VGIC_NR_IRQS_LEGACY     256
--=20
2.34.1

