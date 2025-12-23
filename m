Return-Path: <kvm+bounces-66590-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 7731ECD817E
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 06:05:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id EC6F83002886
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 05:05:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 710EB2FB0B4;
	Tue, 23 Dec 2025 05:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="FYidLE/o";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="B5WL/Cie"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4E692E62AC
	for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 05:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766466304; cv=fail; b=UYJIkbFvCeJuXUXhqbqJPRVl5ku/WZHCFecBOMHfvAi70ptoLmIPOnl5u4ORTvkWHWr6InbRKDmxMdl27b6zmne3DY3Cxiw3K91AyJqG3WNxHrbiu502/NuUTW6Vpv287aFNfAykzE8Gn3wr82nxxOmdvzduxe8R/LsO+C16rZI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766466304; c=relaxed/simple;
	bh=xKPDMrkm7G+zus7sMa8bI31kvaJNwXK49ewpTmBvSHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=eiTXiODbmZqCSdDFV/112tOyjsELKVT9FcnpHyBxaDLgNpavM/VpH0SHFMSxiEKjx/A6vZ4Hp/WQHaAxIQXm7Kv5pUmUg2TyfjD2d0ViYOkiWFy9e//rF7MU1KmEzrFRQ8aXlqW2MP8u2/0GmThR7gveUr7NoY9j08N89riChvw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=FYidLE/o; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=B5WL/Cie; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BMLNNoP723792;
	Mon, 22 Dec 2025 21:05:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=Ob1vGPomRJsNJyumXe7xMIbKi6JNxRXchN1S3CKwU
	aw=; b=FYidLE/o+JTyqY17eMfvPgTye6P8jcBPizHgAUTi4lAKHaQQ3U7jSTCh+
	kGXcgoLB6VmOfrNvXFRfDjQDeMFf9aS4+YOBCKILcFqvqYLLiYmYOegp0N8s/bXF
	AV8JBnUsgHATLqOzYI/Ng7KEKaL/su3BPhsMH2BIFPglGJGTIe6dNqpTJHsw2oBc
	BCE2LyKt32kJoKeXOqnOrXs4k1H3Hxwh1SPiyHscQAobrZNamv1NGpXzr2+pagKv
	NninnloDzdYrILfU1QfeZdU4l1rsbQbwea0icYUsilnbJ4S+ROh9Y8w6L1mS7qII
	OZz89uJmGu3UaJ7Hs7eUejcW03flg==
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11021103.outbound.protection.outlook.com [40.93.194.103])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4b5tsjmwva-3
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 21:04:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eIyhtZBe6gZ+X1yfBCnrRZXsdkUqG34QSdzNu40NoXFkfQ0SMH7zwOLTZhcPfwouNCQOtnTZPCFocEMEJmoGrtrjdoilmKiquSgdY0yTGzRHO44WgVyLRDyQkQuGtuCy6eJGw/s0uAgMbAEaSD5EHoUpGfckQUhHbqD9g9w6L7h52UsBxpchQ7pJCGQquNrUo/g4r6hlnPVGJ3+RqY1NIpl5BwSz/nscao/4xm/QOLoWbUxvl0tSxpK5ZumN0ptfpW/lbW0Ukx++qZLwx3t6J/HT5t5o7+zhMnpzgrJGAXX6n5C3RrJ8FhdxbCTp9UOTCb4wBpkwy1OiGcezijYxqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ob1vGPomRJsNJyumXe7xMIbKi6JNxRXchN1S3CKwUaw=;
 b=pdEIFLfZ62WaqyxIKd4pDcfR/V52KTjDRJzWML8Yy0bDsTTfYkDi3HXCFngl5CNHd3EbLrNFBvXWQbz9ra7hQTJSKkDQBZHkPDCWZeZlPs8ltO7p7Xbs3e05rvawCrCVzHtyJW5bRRdvwap9A1q4SrQQXKe36j/6OyCszsDHSqiclkLE7J5Nl0KO02ObI7uQQ/gfDvj7qjMlFZPpaVZk18pbWRjsnNJqQjlFc1BkAPLn5Jx5Uo0rlmk3xbbJqdSpJIIKllURG7q+TjR27MjgFAb1WtkfTDGWPUX68znk7Z9iD9Zs0wSb1sdvXJyDqUoRlrn9A1KCvSOYbgIE33ujNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ob1vGPomRJsNJyumXe7xMIbKi6JNxRXchN1S3CKwUaw=;
 b=B5WL/CieZtyIvpfOJygvXk9XylpILnELoXsBBJWm6qnUO7gATowS8OIZBrMHVgO9FrxMskctwxpIFY6d76RCwWDJaE/YD1rs5UHjL2SraGN0/4XOgA6gQrmAb2FA5iEC0QXC1kJdqAFlh1u6CcFDLoc4AnfKlWMlJyaOP50RqxfKaprq24UtBwwBVu92FCVDQohZs5sYAc/MgjmDzaiU0UAe/YXZYT6mLmnDq/3cv//+2rxIciGjcWR7qnK8Br3tYILi7QzCuLutv6CK4uiMLWZe+Sn4LPNezKZ1K4++hsgoP0PVR+0SzsWs1+NDMaivTTIh9aJEDi7e8/i3hebRig==
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18) by SA1PR02MB8560.namprd02.prod.outlook.com
 (2603:10b6:806:1fb::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.11; Tue, 23 Dec
 2025 05:04:58 +0000
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc]) by LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc%4]) with mapi id 15.20.9434.009; Tue, 23 Dec 2025
 05:04:58 +0000
From: Jon Kohler <jon@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
Cc: Jon Kohler <jon@nutanix.com>
Subject: [kvm-unit-tests PATCH 02/10] x86/vmx: update EPT installation to use EPT_PRESENT flag
Date: Mon, 22 Dec 2025 22:48:42 -0700
Message-ID: <20251223054850.1611618-3-jon@nutanix.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251223054850.1611618-1-jon@nutanix.com>
References: <20251223054850.1611618-1-jon@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR07CA0018.namprd07.prod.outlook.com
 (2603:10b6:510:2cd::15) To LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV0PR02MB11133:EE_|SA1PR02MB8560:EE_
X-MS-Office365-Filtering-Correlation-Id: 3670fabc-fe7e-4e8a-ea1f-08de41e0d1ef
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|1800799024|376014|366016|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?D0geLnwHYzHlK00yZVtbWOw/25/r6qfCjxhP5QXHk6JL+whslbZVsP8hbBTP?=
 =?us-ascii?Q?qZrS3fFS+8/yH6Y88zIo3Oi3UpX4reSIcIaANEbucMcCMS/R5EmsZSkJn5DP?=
 =?us-ascii?Q?7FSZnkErP7+cm18MpZ7wXV//umlaazec3aM28Z7o/wSxuAQZIzBy8kzsnIPv?=
 =?us-ascii?Q?BPxIWp7wUJJdnkImNA1Cpsy5ZoKOF16tKq4pSyG4rAeLBGbfrIOBHwXe/A7F?=
 =?us-ascii?Q?lizZG6Nj2ycp2v0Rr7417VN60Z2OPOldvOj9lJ2AxAw4N9ZicyEHpxFyCrHo?=
 =?us-ascii?Q?1PaMH5pW4qkqY1u3Aiwojv2GDNKBYR6/CTUtBQPAYjFdLbm6vxC2BYccejFF?=
 =?us-ascii?Q?U7Z7HpnCurqQpBmSm3dNgxnSM1ULNOD3TvobOyADj4QqclkUj9toT/1VlPA0?=
 =?us-ascii?Q?ZervZWcjdrbaKd502gCR7c/e8pdKMurGbyTXXHmsGzd6gd1BO0d8C/dF01z2?=
 =?us-ascii?Q?2vrhh1fr8UZQb2F8lCCn8VMnOWVQKCHRgMccW6kAY6JMlsRB7AOBpfWsUJPo?=
 =?us-ascii?Q?qDI+c7dS6fZf713g6nZJU+8CLTBG8dB6L/HNLhuvcTj/c6BBZ0ItfWhrJAbo?=
 =?us-ascii?Q?COU8+6AtgygMROl34zZkTtnVy+OszUL3wAPOVUFz2tuXMM2sGT4/EUVQ7vKn?=
 =?us-ascii?Q?a95Uxq9Gc9j7xDLEZmTpsjELYyqigD16RS8sfPOy12VEYYAEVvj3OQVwRpWu?=
 =?us-ascii?Q?kvb9PmR/hiCkIERGqP8Km2SY7rtehiMtOgTiEuZnMWvBvBwzwUIbNLbrAQ+n?=
 =?us-ascii?Q?vmEgXH6Q0ueGMJT9EpnvtwDinAQ8DKI2kEyByALVI3yUyI9eExKlC8Pabnba?=
 =?us-ascii?Q?fMWTPMdAoswQO6Mk3nqsv2gsTB5lyTmj1hzvYwyxY8N+mIO9+MEa3F9iVPxT?=
 =?us-ascii?Q?/5hf2ti8SH5fF4NXC4iVH88dEDHeFsczncPh4ruN3xGeqHKDuOrWBSSyPXPC?=
 =?us-ascii?Q?QJ95eqD9iG6kXqe9I1J9bWe/C00r947kca5X2G2zU5nUil5HbGAgTFluWieZ?=
 =?us-ascii?Q?Wr+oO3kHdrwY5muT3757f557DEfEDdPU/kZLFx2DptiTwm9eP3lbdiOHl/DB?=
 =?us-ascii?Q?UGAL0xl8ege0bdX5/y4hgLDGvbfeGbxpI5pA1NdLnhZ+Pzo7eLYc/6g5J38M?=
 =?us-ascii?Q?NELGjTwokYlc5gqwoUBVYhBLtDlNSHRgPpn68hrhY3Fyyj2CwukFvJKPGTuV?=
 =?us-ascii?Q?e2LjRGYAHeZ3WzDX5rn0TMfvNWTONRu6idBSO/2LkHPJrPfY+NapgePtGplu?=
 =?us-ascii?Q?40mp3snp5Mv5pcpMftivLNXYANV2NSHMEI/awZB01y2wCnTSt7ZwPfZK3I7p?=
 =?us-ascii?Q?O7FQHBGgdAHIMM1d68feAW1Dm+UH2pTviY8D+5x+U6NbaOGqk/NBHrWq09N8?=
 =?us-ascii?Q?S+Kf8quki6ptG3QEkAnareH4WmgfgI2w0dzFgeM+JuT7GZWaGb8LVZvihfhU?=
 =?us-ascii?Q?p3YICxLuFfIZQetK/J/iB6RkF2xvnn6tTQNa0pvgFih3AULnqR5IqJ0Nhq/I?=
 =?us-ascii?Q?oTGxfzS2ZDbWwDK45qqJ4gCqGQceTNloX3jP?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0PR02MB11133.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(1800799024)(376014)(366016)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6yKMNRfIVWp4u3wjAAXC9oVqAQg9tUzQzxs1cWwEdbdiO+UYXBCQBnnzrzXV?=
 =?us-ascii?Q?gw1FOpsdEocy5QiGJmuVMvy9ssfGNmC/5n/Yawwe496ZUIalzv7AOB5qhfU0?=
 =?us-ascii?Q?zFfWcgyYL6Jv61DGYAmsD9DV0YrkNWU+CRWEiiFYuFYwJqPgfDHuv0ldjCAX?=
 =?us-ascii?Q?SQEyDGXPZSG/4Gc7W5qK5Iq6VL6FZjv+L5mUcYs7GsGY9TVp8Lz8+5hvPF3b?=
 =?us-ascii?Q?uqybm9+rf5Hy3VxKnGTuf6Jb1C3nGilMr3aoP31TmZVK6Ch/hcyvKjTZHzpY?=
 =?us-ascii?Q?xPTVD89tznKllS+dNoTaDaP9Js0q88eKdKOf+4Blr4xNXz2ZI2/x615iIeMl?=
 =?us-ascii?Q?nykeCNBoyic83lDPeo2Kcx0mi2yMrmKZ0fsVAFUImsPaJj/5993jCFh95qjq?=
 =?us-ascii?Q?MFQK9eV1m2lzM0dlKsbE2iq4Y38AN+MkXgLL674pnUdJ6DFyJhB7pVsrq+3+?=
 =?us-ascii?Q?IOJSGfFv9CxNhDcoLH7FPce5FgQK9lkP1M3R3LGQC8zuRtwIs8BoT1OMXXT0?=
 =?us-ascii?Q?hQ2gmZNWYc+WynjdImn6GzGkKKMhgzv0/6R1i60oNY4xN5OHNyibcAQWe+Tq?=
 =?us-ascii?Q?gnZqbCOmhPQg5GIY321De6JECy9IG9qIr5mCNq9sJryisixitjqoEiWofcGb?=
 =?us-ascii?Q?v5s43YNUbJURwLCSTixc7yliw7MLuiiosSPh9Dxd2TfqUQQyRozi/hXkHJ0g?=
 =?us-ascii?Q?+4UHR/rZAj/tI1zL0K1Yd+YYCxPUYwcLp5UA6SPy+9RvIDIIsZXlCTAX/VRM?=
 =?us-ascii?Q?DN2diKEXBbs2GDlK65TXr6lp1G63c5yryORmfv/9BiWTYTA8U2icATS9BdbH?=
 =?us-ascii?Q?VbJtZZhVGNIrdZiU1yznSktvWxnOq7hVJbHEUIB6L6DN0PoBA6Bmju8WfwZ2?=
 =?us-ascii?Q?w8MkP8Zbg/lv+W5TrM4X33rKb/lzUb6dfxvDt/3/JQNuRH80Ps0eJuVuNXtj?=
 =?us-ascii?Q?xVK0GY/DnQhDBHGZahM012RZqHaqgj6Hp75ocsluu0kLqEVPAamw75gCaNTy?=
 =?us-ascii?Q?dCuE82umVpN6+QrHQBWHyr2rv7/9fXEjRXY8lHFOkihw8ydORQ0xs6O6A6Vl?=
 =?us-ascii?Q?9gdT5BPbWAViW65E3t1g7be+oFmqdz3U/XI7RRSS557UF8dR4m19vQWJVXIU?=
 =?us-ascii?Q?Gk5kh8qjIi7HuHl96u8rzmGndwt/Vuhhga9t+F6AVWhJZTDAzc6QyYGDXwb5?=
 =?us-ascii?Q?c5iwzJcF6oSp+UiF8M5AqZ5yBNdqxHKHx0HeySdF1Nw30yqxZoku7HB5e1lm?=
 =?us-ascii?Q?Jfx4UuzzSrDqbi37vsoN89JXkKenSFs4D8TAA0/oEPk86DzzIjefJBpBVL3/?=
 =?us-ascii?Q?cHcgdnDLDDALP9KgTYaauO5DQa8cGhQ2wp89pOakKtn9gKUonPSMUcpo1sfl?=
 =?us-ascii?Q?jPMTy9XW0g8/zFV9/+5VhaxbaZaYgNvR/KI5uwU/5FoT6j8awDigCnLnJaaX?=
 =?us-ascii?Q?ye31PCZkB3idWwRjSOuj3rPmRTl5Ivl6kEY4AwDG0D/eVDotRDBR+nJbJ2Ow?=
 =?us-ascii?Q?Pbv2Fw9tT/YAvmXMTrn3aiACnc5SeWkueXHjtrrBAKuxAigrggxuzMzQ//uc?=
 =?us-ascii?Q?4q/xYGHGRVUCgQ962R7YavC3AXlgBLodzjs+oawQePFTeP0eoysbaERRaDZq?=
 =?us-ascii?Q?speL13YDCWe/Tpbw9hEloxzr7aGOphZqK/zmRvsFb94P1E3S1vl0CUDS2C9N?=
 =?us-ascii?Q?Jc4SexqidzQIe8yaxEUq8io59S37WdlFC3U8FRBaVIsReHwB4N9/6NgGnWJu?=
 =?us-ascii?Q?qzH+yCR1//sT+MvNwemkmeZuAabKb3c=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3670fabc-fe7e-4e8a-ea1f-08de41e0d1ef
X-MS-Exchange-CrossTenant-AuthSource: LV0PR02MB11133.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2025 05:04:58.4338
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vGHUv+JRIe8QHJJzMGwu5zW2HU1vCLLT6V135lPYwezRcqV8prGmGIjPHDm3DpIMFZ/ChBKSfkhQmCTubuNZG/80Z8mW0sL17SnVRm1bTPk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR02MB8560
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIzMDA0MCBTYWx0ZWRfX6KCN23rQLNGh
 XPG16DEWS/lVoafx1oa8tA623bKxrSBdzFfAhsm98Uz72ZnrK4wX+uyju6/6zqCLAO360kugke0
 Hrs6rLIlP6UQixxy526Ry7D+17qEsQ3/cY0rU8lsgJ4OQiqh+67YAZgmYdGcypJF0C2En1yzmUT
 9XyP7ZINeWVRf39c/E6DptRdxcLeGl8S/F12dxEOuTWvxO58stZwXdn6ie+aMHONNJAwRzmmILv
 EKLHnRLDlSkaidrNY/ffXGGCqzmIjBjLTL6rMpTe5qYHSn3jeq8xGfi1YddgxjpHfqjm45RkRRs
 KLHjAUOAWAmqTgkEjfGxTAkxfzH+Lm3x3xy6Ql1WtVhXnmpFNsp9TsKvIxowaZC9x8uMpJ6VtSp
 DSzASZ8uH7dMjX+C35Us+a1sH7tC0OZLRl6UCDHdiq/M19ky92/x2GrbcWWjpDJbKo1OUz9hiYJ
 /SbR/YHMMEE3CM0hfcA==
X-Proofpoint-GUID: vM5z0GWZvwVP-b-mKLrP7im74rvrLpan
X-Proofpoint-ORIG-GUID: vM5z0GWZvwVP-b-mKLrP7im74rvrLpan
X-Authority-Analysis: v=2.4 cv=Xr73+FF9 c=1 sm=1 tr=0 ts=694a22fb cx=c_pps
 a=GZ5nxs7iJwyXCG4rR3qJ+A==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=64Cc0HZtAAAA:8 a=LfI1OgkwEnAxbgSdoy0A:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-23_01,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Prepare for MBEC EPT access test cases by refactoring the EPT
installation logic in vmx_tests.c and vmx.c to replace the use of
EPT_RA | EPT_WA | EPT_EA flags with the EPT_PRESENT flag.

Update the EPT_PRESENT definition in vmx.h to conditionally include
user access rights based on MBEC support.

No functional change intended, all tests pass with both +vmx-mbec and
-vmx-mbec.

Signed-off-by: Jon Kohler <jon@nutanix.com>
---
 x86/vmx.c       |  3 +--
 x86/vmx.h       | 16 ++++++++++------
 x86/vmx_tests.c | 24 ++++++++++++------------
 3 files changed, 23 insertions(+), 20 deletions(-)

diff --git a/x86/vmx.c b/x86/vmx.c
index c803eaa6..eb2965d8 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -875,8 +875,7 @@ void install_ept_entry(unsigned long *pml4,
 			else
 				pt_page = 0;
 			memset(new_pt, 0, PAGE_SIZE);
-			pt[offset] = virt_to_phys(new_pt)
-					| EPT_RA | EPT_WA | EPT_EA;
+			pt[offset] = virt_to_phys(new_pt) | EPT_PRESENT;
 		} else if (pt[offset] & EPT_LARGE_PAGE)
 			split_large_ept_entry(&pt[offset], level);
 		pt = phys_to_virt(pt[offset] & EPT_ADDR_MASK);
diff --git a/x86/vmx.h b/x86/vmx.h
index 75667ccc..f88188af 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -665,18 +665,22 @@ enum vm_entry_failure_code {
 #define EPT_MEM_TYPE_WP		5ul
 #define EPT_MEM_TYPE_WB		6ul
 
-#define EPT_RA			1ul
-#define EPT_WA			2ul
-#define EPT_EA			4ul
-#define EPT_PRESENT		(EPT_RA | EPT_WA | EPT_EA)
+#define EPT_RA			(1ul << 0)
+#define EPT_WA			(1ul << 1)
+#define EPT_EA			(1ul << 2)
+#define EPT_IGNORE_PAT		(1ul << 6)
+#define EPT_LARGE_PAGE		(1ul << 7)
 #define EPT_ACCESS_FLAG		(1ul << 8)
 #define EPT_DIRTY_FLAG		(1ul << 9)
-#define EPT_LARGE_PAGE		(1ul << 7)
+#define EPT_EA_USER		(1ul << 10)
 #define EPT_MEM_TYPE_SHIFT	3ul
 #define EPT_MEM_TYPE_MASK	0x7ul
-#define EPT_IGNORE_PAT		(1ul << 6)
 #define EPT_SUPPRESS_VE		(1ull << 63)
 
+#define EPT_PRESENT		(is_mbec_supported() ? \
+				 (EPT_RA | EPT_WA | EPT_EA | EPT_EA_USER) : \
+				 (EPT_RA | EPT_WA | EPT_EA))
+
 #define EPT_CAP_EXEC_ONLY	(1ull << 0)
 #define EPT_CAP_PWL4		(1ull << 6)
 #define EPT_CAP_PWL5		(1ull << 7)
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index ad7cfe83..9d91ce6b 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -1100,7 +1100,7 @@ static int setup_ept(bool enable_ad)
 	 */
 	setup_ept_range(pml4, 0, end_of_memory, 0,
 			!enable_ad && ept_2m_supported(),
-			EPT_WA | EPT_RA | EPT_EA);
+			EPT_PRESENT);
 	return 0;
 }
 
@@ -1179,7 +1179,7 @@ static int ept_init_common(bool have_ad)
 	*((u32 *)data_page1) = MAGIC_VAL_1;
 	*((u32 *)data_page2) = MAGIC_VAL_2;
 	install_ept(pml4, (unsigned long)data_page1, (unsigned long)data_page2,
-			EPT_RA | EPT_WA | EPT_EA);
+		    EPT_PRESENT);
 
 	apic_version = apic_read(APIC_LVR);
 
@@ -1359,8 +1359,8 @@ static int ept_exit_handler_common(union exit_reason exit_reason, bool have_ad)
 					*((u32 *)data_page2) == MAGIC_VAL_2) {
 				vmx_inc_test_stage();
 				install_ept(pml4, (unsigned long)data_page2,
-						(unsigned long)data_page2,
-						EPT_RA | EPT_WA | EPT_EA);
+					    (unsigned long)data_page2,
+					    EPT_PRESENT);
 			} else
 				report_fail("EPT basic framework - write");
 			break;
@@ -1371,9 +1371,9 @@ static int ept_exit_handler_common(union exit_reason exit_reason, bool have_ad)
 			break;
 		case 2:
 			install_ept(pml4, (unsigned long)data_page1,
- 				(unsigned long)data_page1,
- 				EPT_RA | EPT_WA | EPT_EA |
- 				(2 << EPT_MEM_TYPE_SHIFT));
+				    (unsigned long)data_page1,
+				    EPT_PRESENT |
+				    (2 << EPT_MEM_TYPE_SHIFT));
 			invept(INVEPT_SINGLE, eptp);
 			break;
 		case 3:
@@ -1417,8 +1417,8 @@ static int ept_exit_handler_common(union exit_reason exit_reason, bool have_ad)
 		case 2:
 			vmx_inc_test_stage();
 			install_ept(pml4, (unsigned long)data_page1,
- 				(unsigned long)data_page1,
- 				EPT_RA | EPT_WA | EPT_EA);
+				    (unsigned long)data_page1,
+				    EPT_PRESENT);
 			invept(INVEPT_SINGLE, eptp);
 			break;
 		// Should not reach here
@@ -3020,9 +3020,9 @@ static void ept_access_test_paddr_read_write_execute(void)
 {
 	ept_access_test_setup();
 	/* RWX access to paging structure. */
-	ept_access_allowed_paddr(EPT_PRESENT, 0, OP_READ);
-	ept_access_allowed_paddr(EPT_PRESENT, 0, OP_WRITE);
-	ept_access_allowed_paddr(EPT_PRESENT, 0, OP_EXEC);
+	ept_access_allowed_paddr(EPT_RA | EPT_WA | EPT_EA, 0, OP_READ);
+	ept_access_allowed_paddr(EPT_RA | EPT_WA | EPT_EA, 0, OP_WRITE);
+	ept_access_allowed_paddr(EPT_RA | EPT_WA | EPT_EA, 0, OP_EXEC);
 }
 
 static void ept_access_test_paddr_read_execute_ad_disabled(void)
-- 
2.43.0


