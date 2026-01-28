Return-Path: <kvm+bounces-69402-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sNsQGAhUemnk5AEAu9opvQ
	(envelope-from <kvm+bounces-69402-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:23:04 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D895A7B86
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:23:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 683FD30277B3
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 18:11:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 132BF36F435;
	Wed, 28 Jan 2026 18:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="RbExDuJ4";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="RbExDuJ4"
X-Original-To: kvm@vger.kernel.org
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011003.outbound.protection.outlook.com [52.101.65.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE6F2FE58D
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 18:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.3
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769623858; cv=fail; b=sq28kTVKRpDuod28u0FlrPUuJxcNp/QeXnqwrwQj4AreLFJykWqhI5HI4sOOzHz/QCQqpsgKMNMk3W6Cuv1pV4bHvp8L3B8HyTI3lvR0ZT/1hmQ5YrQdmpgT6i6wJLnbW+VrCu0fdLyJ9VT6Iw1K1TwpaMGiMKxYJhMCVq7BSyE=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769623858; c=relaxed/simple;
	bh=W3tx/l7ZsG5B9P4MIvZhjrGO10RkdLF377rOYARp1o8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YJGcJ+6HtTlfutYP+Q9ruZ5lf+/iV5RkxghIgVxqVb4kjmr9A8YTbllRYRIQTGdpyQ0qySFLjnd3G4DU+GgNawfELUoYbavePuyj0/APGmzp1kbwrwUDws0F4+SbnwYB9oDHjj9n5dPYvW1IjNkz0rxGyPB0w7ddwFofgMTsNMs=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=RbExDuJ4; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=RbExDuJ4; arc=fail smtp.client-ip=52.101.65.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=m48JxYi5Amj9aArZKiSv8vxn8vYou0bGdmQdsjWXWauU/DstNvHb9BCw8R6VDV+fA1+eLZKCQmrCHwkaexfcWaC5nOqRSQVJy4CLvHIN5yfZG++XtpwBxc/TCoNSVwR3I5ETqCHr6NkNx4sgrcrraJ6G+NIloojOJQA21oTkXlosMCo5Vi+QmWq2gmPSNJs1jq+7230uQmNxGECh+9v6wV2zaqp8HgD9dx85hEdXF2cZEYtgHwXM1ZcLlcYqwRbBmIyNl+RrSVbH4CPPJz1w5WQetQmEwWVAABmD2OfwEOLraLkcZt7MBNfyDgFVtqk5srZAwpfSQBTwAwD65c8KGw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JPv7ewZ/qK2efYh8ng8pILZ08Tv9Newa1UwtpMrepuM=;
 b=vhHJ0Q6EI3E4IPOrDpfRvTDWQIbF2Qp6dJpayiqU211ZdsJOBdgO0zrz3Y+duopVL670Z8GtAEIDu8p0gAmt3qFMmXecyn+jhMwc6/KELN3+nt5YS/EidI/NYSg1duJlgloItNpAoLecyYNuIMnCAIjWYcXbbcQUvK0SLP0rZcrtZGzi1iA2PjANyeEJtgEDM8+UAMszhsjAgq1zRcqhRL3t+ufMD8tpWXBt1AptNzKCrnRPMGMe968dhpwV+PYtO+g7XgHW5elkrYToYl95ivW45ED7G9lPcMKTg4VcwYtgLdXqL6JH1nDEEwpDVsOwRPfSndSgjYSwGIKtiwJO/Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JPv7ewZ/qK2efYh8ng8pILZ08Tv9Newa1UwtpMrepuM=;
 b=RbExDuJ4udnz8n17ObL5tQsSmMoKS/aui03oo0Pef7FHo5cyUKuZqMO0RrMgnwEE3UVvU54P7ZoyKvCHt11P/WNimiShyEtzkg6lfS/Jlw3avhbnUMXYWbib7FwgyQRx6arLUYdFvbcGJBjQNT6RfuTlhwNTu/BcJSBcvza9eRA=
Received: from DB3PR06CA0028.eurprd06.prod.outlook.com (2603:10a6:8:1::41) by
 AS2PR08MB8311.eurprd08.prod.outlook.com (2603:10a6:20b:556::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Wed, 28 Jan
 2026 18:10:50 +0000
Received: from DB3PEPF0000885C.eurprd02.prod.outlook.com
 (2603:10a6:8:1:cafe::c6) by DB3PR06CA0028.outlook.office365.com
 (2603:10a6:8:1::41) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.8 via Frontend Transport; Wed,
 28 Jan 2026 18:10:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB3PEPF0000885C.mail.protection.outlook.com (10.167.242.7) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.3
 via Frontend Transport; Wed, 28 Jan 2026 18:10:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vz95cDbNbzuyg7hLa2IkBNcsyCkgqcc1Q+8QX/WBQbciwZ4dryxegoa6vHntHqtCTglb2lGzWeN7WBGT0NoMSghAXWgVi8K18hMqu7qZTNApxsZISS9m4neJgzbx3rz3xeFfeyzrRWCEXi/PtUP5tsjiDTSbDBFaHkrd4MLzrZwEElJDzB+B78cd0cml1y2VRwTHoSt4sJZxmBmcumvtYXwUWoRFU2m0ukGMn9DO4S5kEXTog2ACj19W5I5YDbRMTfbYABzn8ULqf7d/Hg+SCqfcIgN2I5ll46LyuhHoFeNQp6MRVpHBI3ceZxIlU4QLryVr2BmkK13zS3gddoN9jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JPv7ewZ/qK2efYh8ng8pILZ08Tv9Newa1UwtpMrepuM=;
 b=StRyCx+UDLLvfij9hKgB/IKR5AnM8QDXNCPo3Y9OrbgtDFfOgUynaRlXvMPqkJaeltT9cQ4T9GxO1n42nKGWtL1pTJcxasG28Dt/RxUf1IT0uEr9Q8E41+oHxZc536buOsCmbsbSUFlXna20vYb+TthF5dd1Xj4wO2pMAeJvd3VPTAC47CfdrZ0/o+N9g+xm/eXVMurSWuwIN/hqHz12bdcPTp1ah6CSfjDgl+hrnsBQo7RyQmLtB8lJslKwOkMMytyHc8p1Dp0V9YjgddjaNHjMfVdw3jSKGtT/eeeCTr/XuGkmKkpIuWQ75P1IwiQSosQsXYOvWZnPfx939NY7vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JPv7ewZ/qK2efYh8ng8pILZ08Tv9Newa1UwtpMrepuM=;
 b=RbExDuJ4udnz8n17ObL5tQsSmMoKS/aui03oo0Pef7FHo5cyUKuZqMO0RrMgnwEE3UVvU54P7ZoyKvCHt11P/WNimiShyEtzkg6lfS/Jlw3avhbnUMXYWbib7FwgyQRx6arLUYdFvbcGJBjQNT6RfuTlhwNTu/BcJSBcvza9eRA=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by AS8PR08MB6085.eurprd08.prod.outlook.com (2603:10a6:20b:294::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Wed, 28 Jan
 2026 18:08:35 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9564.006; Wed, 28 Jan 2026
 18:08:35 +0000
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
Subject: [PATCH v4 36/36] KVM: arm64: gic-v5: Communicate userspace-driveable
 PPIs via a UAPI
Thread-Topic: [PATCH v4 36/36] KVM: arm64: gic-v5: Communicate
 userspace-driveable PPIs via a UAPI
Thread-Index: AQHckIEeKDCq6hdOO026wABLHjXrZw==
Date: Wed, 28 Jan 2026 18:08:35 +0000
Message-ID: <20260128175919.3828384-37-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|AS8PR08MB6085:EE_|DB3PEPF0000885C:EE_|AS2PR08MB8311:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e7600fb-ab24-46c0-0c23-08de5e989126
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?H6Mwv+k7FvTK42eWVKlkGXO7QsY4UWEE7b+yHF/uan8V+AR6mX+mimcOSN?=
 =?iso-8859-1?Q?iN4zPUTajYckSzMbusdypwN+yJEVVsV6QcpzG9aZwAVyZT9v0sBkR/q6i0?=
 =?iso-8859-1?Q?UK5Rpj/xnTLUWf9/AfvcV71bDecYxPaWNXu3nDd9x6D96iuqxlOyCk0XN9?=
 =?iso-8859-1?Q?6PjECzhXzd/ZwcDjVd+LhEidNBYHSVk4jcNs64M1kiy8yPcME+jqh4vD2D?=
 =?iso-8859-1?Q?Nil3ANClhDAUTk1hELQPOzz83uKzjpR0wAxC4kAjTcjhl31O8XVQSdF5Nz?=
 =?iso-8859-1?Q?gX/WQ4G94ndDYe39j4DzHlt2ny6zdvqon8UE/eRMwbFsgv0wnD3MhALoEC?=
 =?iso-8859-1?Q?mG0HDsN4fkoEIwPvzX7/RRTMwCDcSFMMMNWvAjojIzE7DTD3RuyFMUa6Gh?=
 =?iso-8859-1?Q?ruFsUEpDH7r106StMLte+zA/68UkEp/xNi3J/q28FPFrDR/f3sVpPu/t5F?=
 =?iso-8859-1?Q?Xc6b1RKq8yyAMIz5NWhuBYSr8SZKApubNjwr7oZj8au5P3vxXGwP0sbKpb?=
 =?iso-8859-1?Q?KFCt/hc0fju9Qbrl9AV2VtfcrtLWXnwM2nNYwVOu7xGEECP/EMNTrL7hS0?=
 =?iso-8859-1?Q?ka8A6YePzyR4Hem9K+1zSVPB/v1+kguUFOxrMVPCBD6/qt5nWTyYz4uvCY?=
 =?iso-8859-1?Q?LE0d+iI0ufviuG8iX/r4mbsexuhlk77LtXcz+UojcH7hNVy3hxGDWNHey7?=
 =?iso-8859-1?Q?FMNlWjryeNPebeukRXBWmgCaSITwii1Yku0NvlpE91flFDkkg4Koxx4pNe?=
 =?iso-8859-1?Q?kYJbahPV+KVegUb6uiXaThtl+K8wlxzMfi5EKC20LGzVi9tOW3kAVumwRf?=
 =?iso-8859-1?Q?aAi14EfrhCmfcYWa0zRvUaMTBna4TL4g5//3MTmNUwA9bhl/nJZ2KfXEkD?=
 =?iso-8859-1?Q?P5TzlfZoEHCMdbGsF9UsIj3TnMxsIRmTbOmAJXYir8Z0ou5zOIBnCmCWEc?=
 =?iso-8859-1?Q?9M2+Oybguqnn0CNnSEOaSZUelAeWQh7IPBcRGcgWE0eHfq6z5InC3m946D?=
 =?iso-8859-1?Q?WQscUB6QQ8ow4JqGkz/Z147Fjpn3+blm2Ydyqql4kmZAfMqV11Yz/PU9eZ?=
 =?iso-8859-1?Q?vMiRjWx3R8TmJbsRbmA5RrVi2+6cemB9t6D8cDMpkueh2kUmJLPtfPjmUq?=
 =?iso-8859-1?Q?u+BgM3lXh04Wu1sHn2g3WwfBBrppWb7y0SbtvkNmNnc44PIDec4K1Z15tD?=
 =?iso-8859-1?Q?83xKVMaRYGy3pCOM+rijVZrecEC0PYPG5z5BwRKcsvW1dnOphkbl2jmdF7?=
 =?iso-8859-1?Q?nHtBe9kNAMVjg62r9/Mdw5qjW46zOW8bgUyt54tPLs6zBiVed7tgGMFhTI?=
 =?iso-8859-1?Q?/j4TBP9BiS9TYmIcGTO3X39N7N2m5W6skVcmCzTtCTKmU+mBNaQrXag5PA?=
 =?iso-8859-1?Q?vNdLG0vnOe7+nYb/QPcOP89BokAyQdutH8jbESTwZzgvKvUIOW/sr8d5cc?=
 =?iso-8859-1?Q?HgUM6tDZjiFd0+IrVMtwMVdAj6NDGInjSnK5HZIMtNYqvf8Aal6n1Sf7ot?=
 =?iso-8859-1?Q?WxqCwN9ToaQ1QTFvcqwJ1BgdV6V7LLNjfevPfKdmqBz9T35r8RGpeRV4Wf?=
 =?iso-8859-1?Q?cnWiAGd1Gq9viIRujLkXQ8kCO6J/GAIFQfPtpZbtn5tUQYNEj7c0+Q+zjF?=
 =?iso-8859-1?Q?S+BrK8vtb3yDhPM2+NJ3moPpQSPLXg3P9abv8ptBygb4O7xy9ftAUew96v?=
 =?iso-8859-1?Q?LUya5WnRpE4RPbBI8N4=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6085
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB3PEPF0000885C.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	62d9acc7-ffc4-47ed-9559-08de5e984105
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|376014|82310400026|1800799024|36860700013|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?/8DHhUo1BQHChMTdPo5Ei92JBOq93daTMxB7b2JgCqf7Qwhfra/j/nMaNI?=
 =?iso-8859-1?Q?MWCGbHn483T0yALAtg8ZTyQ7QUY0y5TJTHzx6VdXd+soOAWVUHOYIUp0PX?=
 =?iso-8859-1?Q?Q/NgGYKSA1a8U7FDsLe9+yZ0AwpjBgF6XGu/TqLASn6WG2wHppZICHLxEj?=
 =?iso-8859-1?Q?82I4UT4Z5huDcUUgpy9R2bUblAsjYrO90a2XrqSMA/AVyQZ62CH5F2S6jm?=
 =?iso-8859-1?Q?mNz/uL68WvVtvON9cYZAzfYwSZ9xmxV5H7Z/xhP+2moqiNHk/H6J8xbshU?=
 =?iso-8859-1?Q?CU+wQJNQ2ihiF7ZsTp4qh5nIX+MJ2amKcRgY2ZOqDReJdYd10KbX2Cx92E?=
 =?iso-8859-1?Q?c5tI0sxRSkSYcAXHMMaodHoQvQiv+180bv98fU9zz72hXms/IVeOz98ym1?=
 =?iso-8859-1?Q?t+PuTjKKYDoBa7UbAsMsScl+g9i33JC++t05U9b8ZV9/4PF7BVTH5jpAxV?=
 =?iso-8859-1?Q?4qHk9G+SN8jolnS26DGlo+9ysg69pNZNCCy4HWQY9yFM6YqaZEZvXbXZNC?=
 =?iso-8859-1?Q?uG1cu3bDBFiI6NvF/lX7WDCUFr+zAGpXzU969OUWd412GSYqWM1S13uRWn?=
 =?iso-8859-1?Q?iAvu//z0ZieOo1m3apWvRVbH3PP9hyhx9NTQLpo9QHQMTxhYkyg8VCDS3F?=
 =?iso-8859-1?Q?jvrbmSqjJkR+1TmECGaSLECXWygbtfOiyZpJUyx31VeFB+C6R1f0Fr3JfN?=
 =?iso-8859-1?Q?uBSM8gsLTobh/Ka7IhUqmI9xZLPNtVBw5d40TSIACMtT8ogYinmVvY5xuU?=
 =?iso-8859-1?Q?ijdVLSOQ2Sn5JQ1ZlfjZCIeLPV+my47yvs8km0g5T5ifIJTJ45ziDXFwUk?=
 =?iso-8859-1?Q?emZSGXHMoXszZ8E1QPYn3MUr+WPiNFo7cRmUgU1i+L1Bd8GaKK8Z2rx06H?=
 =?iso-8859-1?Q?/XkhK5Xygvf1zxzVpeySUqMjCjl1O6pIhbGZ/ypZ7EeZRGFN4TeqbV00rF?=
 =?iso-8859-1?Q?XBVzCzr2jkiG7rgul7gbAgKGZHEu8SdBaEUtamDfd50nLO0RBKeXYPm+vx?=
 =?iso-8859-1?Q?cTxMnA6jAYvomH7gRk+zv+jk4Hy2f9LjEwySmcKXxo2rQt2LE5r2ahvh+m?=
 =?iso-8859-1?Q?/VJlQO2zyamNx7LXBCh6En2HZyf5ss3w0YdpD9rDiB16e3u1FrdKZkNJfg?=
 =?iso-8859-1?Q?LjQOk093GK7019hwfAFtrxVKkMxOuxtIn7hr+TH3GTNeNQBbYW4WBuzRJd?=
 =?iso-8859-1?Q?5fWLo+u2rE3xxXELb1MgkVbWyAxHc3ph4Ls8p0eJFmSH+ZDKhKcEP0j2oD?=
 =?iso-8859-1?Q?HADmpZhVhnYnyX1HRJlaYiqUVYvjeJXHx6P4fHIdGw7XufUMASS6iHSadt?=
 =?iso-8859-1?Q?KUNzdszD4etCsFL19DhOgNChh85GuW8YPEWM/SfViWWZAqw4q+cn9MKrsp?=
 =?iso-8859-1?Q?7rdJNO9gwFhCbebD5zWwU8np9vpwM+9KD1cxJRRvLoZH2Rr924P6aNNE2g?=
 =?iso-8859-1?Q?Nj1dOazVJ5JPsYQkV+uP//w3gJ7U3vFxj9HPKdDndK9XHn6upgQWE8Trwe?=
 =?iso-8859-1?Q?9bgg0PPIYniwyBs3I6HQGAblH6G3M26Sq/aVWPX+7zhxizQRudvo9pShF6?=
 =?iso-8859-1?Q?Z5xSL8C51pNmI39C1BfBC2DxUGQ6gaahYbhJaOAIotPNi9LyG5kd58pJZ0?=
 =?iso-8859-1?Q?KTuyVPh7nmxvvPa9/ZFgP5SKkCjC+irMwVSsbqEGBGgP5b23rVuLEtD7WQ?=
 =?iso-8859-1?Q?cpURexoUYGbE/OaDu5Twafkouf44lBtv2JQFo5c2Iu6NheYv50pno0Tssb?=
 =?iso-8859-1?Q?Qghg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(376014)(82310400026)(1800799024)(36860700013)(35042699022);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 18:10:49.5309
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e7600fb-ab24-46c0-0c23-08de5e989126
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB3PEPF0000885C.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB8311
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69402-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,arm.com:email,arm.com:dkim,arm.com:mid];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[Sascha.Bischoff@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[arm.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: 7D895A7B86
X-Rspamd-Action: no action

GICv5 systems will likely not support the full set of PPIs. The
presence of any virtual PPI is tied to the presence of the physical
PPI. Therefore, the available PPIs will be limited by the physical
host. Userspace cannot drive any PPIs that are not implemented.

Moreover, it is not desirable to expose all PPIs to the guest in the
first place, even if they are supported in hardware. Some devices,
such as the arch timer, are implemented in KVM, and hence those PPIs
shouldn't be driven by userspace, either.

Provided a new UAPI:
  KVM_DEV_ARM_VGIC_GRP_CTRL =3D> KVM_DEV_ARM_VGIC_USERPSPACE_PPIs

This allows userspace to query which PPIs it is able to drive via
KVM_IRQ_LINE.

Additionally, introduce a check in kvm_vm_ioctl_irq_line() to reject
any PPIs not in the userspace mask.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 .../virt/kvm/devices/arm-vgic-v5.rst          | 13 ++++++++++
 arch/arm64/include/uapi/asm/kvm.h             |  1 +
 arch/arm64/kvm/arm.c                          | 10 +++++++-
 arch/arm64/kvm/vgic/vgic-kvm-device.c         | 24 +++++++++++++++++++
 arch/arm64/kvm/vgic/vgic-v5.c                 |  5 ++++
 include/linux/irqchip/arm-gic-v5.h            |  3 +++
 tools/arch/arm64/include/uapi/asm/kvm.h       |  1 +
 7 files changed, 56 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/devices/arm-vgic-v5.rst b/Documentation=
/virt/kvm/devices/arm-vgic-v5.rst
index 9904cb888277..29335ea823fc 100644
--- a/Documentation/virt/kvm/devices/arm-vgic-v5.rst
+++ b/Documentation/virt/kvm/devices/arm-vgic-v5.rst
@@ -25,6 +25,19 @@ Groups:
       request the initialization of the VGIC, no additional parameter in
       kvm_device_attr.addr. Must be called after all VCPUs have been creat=
ed.
=20
+   KVM_DEV_ARM_VGIC_USERPSPACE_PPIs
+      request the mask of userspace-drivable PPIs. Only a subset of the PP=
Is can
+      be directly driven from userspace with GICv5, and the returned mask
+      informs userspace of which it is allowed to drive via KVM_IRQ_LINE.
+
+      Userspace must allocate and point to __u64[2] of data in
+      kvm_device_attr.addr. When this call returns, the provided memory wi=
ll be
+      populated with the userspace PPI mask. The lower __u64 contains the =
mask
+      for the lower 64 PPIS, with the remaining 64 being in the second __u=
64.
+
+      This is a read-only attribute, and cannot be set. Attempts to set it=
 are
+      rejected.
+
   Errors:
=20
     =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/as=
m/kvm.h
index a792a599b9d6..1c13bfa2d38a 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -428,6 +428,7 @@ enum {
 #define   KVM_DEV_ARM_ITS_RESTORE_TABLES        2
 #define   KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES	3
 #define   KVM_DEV_ARM_ITS_CTRL_RESET		4
+#define   KVM_DEV_ARM_VGIC_USERSPACE_PPIS	5
=20
 /* Device Control API on vcpu fd */
 #define KVM_ARM_VCPU_PMU_V3_CTRL	0
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e1acd16ed213..12053fd27d28 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1401,7 +1401,7 @@ static int vcpu_interrupt_line(struct kvm_vcpu *vcpu,=
 int number, bool level)
 int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_level=
,
 			  bool line_status)
 {
-	u32 irq =3D irq_level->irq;
+	u32 mask, irq =3D irq_level->irq;
 	unsigned int irq_type, vcpu_id, irq_num;
 	struct kvm_vcpu *vcpu =3D NULL;
 	bool level =3D irq_level->level;
@@ -1438,6 +1438,14 @@ int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kv=
m_irq_level *irq_level,
 			if (irq_num >=3D VGIC_V5_NR_PRIVATE_IRQS)
 				return -EINVAL;
=20
+			/*
+			 * Only allow PPIs that are explicitly exposed to
+			 * usespace to be driven via KVM_IRQ_LINE
+			 */
+			mask =3D kvm->arch.vgic.gicv5_vm.userspace_ppis[irq_num / 64];
+			if (!(mask & BIT_ULL(irq_num % 64)))
+				return -EINVAL;
+
 			/* Build a GICv5-style IntID here */
 			irq_num |=3D FIELD_PREP(GICV5_HWIRQ_TYPE, GICV5_HWIRQ_TYPE_PPI);
 		} else if (irq_num < VGIC_NR_SGIS ||
diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vg=
ic-kvm-device.c
index 772da54c1518..21d21216f218 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -720,6 +720,25 @@ struct kvm_device_ops kvm_arm_vgic_v3_ops =3D {
 	.has_attr =3D vgic_v3_has_attr,
 };
=20
+static int vgic_v5_get_userspace_ppis(struct kvm_device *dev,
+				      struct kvm_device_attr *attr)
+{
+	u64 __user *uaddr =3D (u64 __user *)(long)attr->addr;
+	struct gicv5_vm *gicv5_vm =3D &dev->kvm->arch.vgic.gicv5_vm;
+	int ret;
+
+	guard(mutex)(&dev->kvm->arch.config_lock);
+
+	for (int i =3D 0; i < 2; i++) {
+		ret =3D put_user(gicv5_vm->userspace_ppis[i], uaddr);
+		if (ret)
+			return ret;
+		uaddr++;
+	}
+
+	return 0;
+}
+
 static int vgic_v5_set_attr(struct kvm_device *dev,
 			    struct kvm_device_attr *attr)
 {
@@ -732,6 +751,7 @@ static int vgic_v5_set_attr(struct kvm_device *dev,
 		switch (attr->attr) {
 		case KVM_DEV_ARM_VGIC_CTRL_INIT:
 			return vgic_set_common_attr(dev, attr);
+		case KVM_DEV_ARM_VGIC_USERSPACE_PPIS:
 		default:
 			return -ENXIO;
 		}
@@ -753,6 +773,8 @@ static int vgic_v5_get_attr(struct kvm_device *dev,
 		switch (attr->attr) {
 		case KVM_DEV_ARM_VGIC_CTRL_INIT:
 			return vgic_get_common_attr(dev, attr);
+		case KVM_DEV_ARM_VGIC_USERSPACE_PPIS:
+			return vgic_v5_get_userspace_ppis(dev, attr);
 		default:
 			return -ENXIO;
 		}
@@ -773,6 +795,8 @@ static int vgic_v5_has_attr(struct kvm_device *dev,
 		switch (attr->attr) {
 		case KVM_DEV_ARM_VGIC_CTRL_INIT:
 			return 0;
+		case KVM_DEV_ARM_VGIC_USERSPACE_PPIS:
+			return 0;
 		default:
 			return -ENXIO;
 		}
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index b5c9e73007e6..c13c541752ac 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -122,6 +122,11 @@ int vgic_v5_init(struct kvm *kvm)
 		}
 	}
=20
+	/* We only allow userspace to drive the SW_PPI, if it is implemented. */
+	kvm->arch.vgic.gicv5_vm.userspace_ppis[0] =3D BIT_ULL(GICV5_ARCH_PPI_SW_P=
PI);
+	kvm->arch.vgic.gicv5_vm.userspace_ppis[0] &=3D ppi_caps->impl_ppi_mask[0]=
;
+	kvm->arch.vgic.gicv5_vm.userspace_ppis[1] =3D 0;
+
 	return 0;
 }
=20
diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm=
-gic-v5.h
index c9174cd7c31d..fcebb0796a7d 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -381,6 +381,9 @@ struct gicv5_vm {
 	 */
 	u64			vgic_ppi_mask[2];
=20
+	/* A mask of the PPIs that are exposed for userspace to drive */
+	u64			userspace_ppis[2];
+
 	/*
 	 * The HMR itself is handled by the hardware, but we still need to have
 	 * a mask that we can use when merging in pending state (only the state
diff --git a/tools/arch/arm64/include/uapi/asm/kvm.h b/tools/arch/arm64/inc=
lude/uapi/asm/kvm.h
index a792a599b9d6..1c13bfa2d38a 100644
--- a/tools/arch/arm64/include/uapi/asm/kvm.h
+++ b/tools/arch/arm64/include/uapi/asm/kvm.h
@@ -428,6 +428,7 @@ enum {
 #define   KVM_DEV_ARM_ITS_RESTORE_TABLES        2
 #define   KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES	3
 #define   KVM_DEV_ARM_ITS_CTRL_RESET		4
+#define   KVM_DEV_ARM_VGIC_USERSPACE_PPIS	5
=20
 /* Device Control API on vcpu fd */
 #define KVM_ARM_VCPU_PMU_V3_CTRL	0
--=20
2.34.1

