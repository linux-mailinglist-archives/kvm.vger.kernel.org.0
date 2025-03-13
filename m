Return-Path: <kvm+bounces-41002-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 595BAA60238
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 21:15:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DA43019C57B0
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 20:16:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86C851FECAA;
	Thu, 13 Mar 2025 20:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="kzaNZy2D";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="D2qcfTWG"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C641FC11A;
	Thu, 13 Mar 2025 20:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741896660; cv=fail; b=uOwwPyek4DMYvSorahMSkI3OT2NhF74Z5qzwwZ8Pi4O50xzwFrmXydK2ppn5Jz76nmGFJrua+z1jn6gFwxodI6rT427jyQQfxdEI1SE/lx6o8fSKWWBv7gwsC769C0Pd5lbiRLwgU71luUUVDhdyIclYx/MFc9YKkAo6Z5Q1f6A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741896660; c=relaxed/simple;
	bh=fdNlBw9tLvEeU0tB5XJfNZJX2Su+NWmebH6tcKY1jT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qKyUa3z2OtJiius05CD4O80abbsZu9nqMtxCJclueYk1EU2JOMjsHiAs1Qn2HD2DFuHy7zymq/esRysYPgg8CGyMeXdE2Qy2Qe2Pfkq3mEunMm/SkSemAb9ajUiPT/7lgIj0e6EkYp6BpkyunUq1RB3ODfwqNHtBhmcErZGCMmI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=kzaNZy2D; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=D2qcfTWG; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52DEsPiK009012;
	Thu, 13 Mar 2025 13:10:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=nz6J/mgC56zCtUZaLDZ9gn8F02cKqRmlSO5epT3Rh
	0Q=; b=kzaNZy2Dpu2phGk6H2MDDVtFs0qLqKuO4bkandDccxv+iSXMQ8uJZb3uj
	GRSVuf5z1BFgI6izPFJeL0bpc1hE5nZTUh/uEXU1kKLGBkjovidJvGiLm8sYYSAv
	A0T06OQlweI09kcOuJZnPDfeQCIj5a6ZbzfKjQJ0IMA5X38OFXHME1Fi8Iud+1oA
	c3uSHvZNcnID1Zzbudig/1ADWVrOJZKtWLippufZqkTfyvxV0oewyMvyy9C81CLj
	sA401ckm1dWZTb6iC/UPp8el6CElVVijH43codwWoVA/oyXF02ke9p8dieZbJ7c9
	HBPOyGlpFqSg6Ykn5aDZpMaXBhYCA==
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 45au9g67k2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Mar 2025 13:10:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pIlJ44i7XTDhUhA++7l3XVjxiDO0iCEflzyI7b1V7mVLpq0WA0GLxRHoBzT7mjoNDNI/mEzjJsLbVj1FT9HHXQzJLiLYim6uZcyFpXaRCI6NECVaTIHAJwd37Vpce+OARPgSCYZ00LDID6VDTvOQl7n43lD+rDXPBmx8G+za+NhiXoY9W6PMs7d9Eu1j8L0v6v+jR76IYaBgdHOCIzOHnHhTNJf8XMkgzNsKxQj9ylt0wn4xmzyo1sohkQSiD0xl4DzI4GpfdLYwvaokyZzqmz7DWtCGSFt7SwAWRS55cfiupI73NHaA76AC4hLzGiDo+q9DlQ5HDyjnq05+UCoNQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nz6J/mgC56zCtUZaLDZ9gn8F02cKqRmlSO5epT3Rh0Q=;
 b=M9K6a1fw/AIq3MaZH+ki2IaFtPjlD5wMr1cjIhG7HlAKQq+LnY0Apv1DzNI875a6OBQoA8PQDdDswSHgtFh7Y5NxG9YUD2SYnD3lgRKpNdMLXgzhHuLQGu8muJw2G8Qb+lRi29SKfpJP8u19roo9lTXCR7FHeiUyZm3FrTyIniI2R5AqsQyrWGVkpnMZqRiXTH1Poubrrg4eASx/DiW9YNHjE02YvT5PqyrxygQRfNjDapuwI8R1sEd8FuTv1bBQY6qZXJjhdGOPbvHIp6MmJQox7ZHVWvhzftQVb2hrE6NsKzGmeaYjI4uSBqRA9YNXylFu2KSuWzMtJh9xjbXt4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nz6J/mgC56zCtUZaLDZ9gn8F02cKqRmlSO5epT3Rh0Q=;
 b=D2qcfTWG0Ge6htjZW9exPxSiNSxE4Td4x30Gk63/1c4jOhsj1omYpbNqGupOiRCrbsfjkElPtFpOSrX07mmfYSaaLHmOuEZBgT9CG5W7f1QQbt5t9HVRcR6mQ7vEHQkX8hvzWnAFzCJLu+GCr/vu8E6uuwAvMiLlXXaD+Hiucds4UN/0PKT04cMOwbgCVZRGWqvMKP/2Dke3rJvhlik8fMcj91KR5Me1fJmA9NGw115qzC5VOR0mCwHP8aUsljH0LodglECYUEA4vVemGJibzd5lFcEH229bWmHkkZL0xs1WUOrMpTgMmMDck+1KdOLoFBGKRNKHOxc/kqhLFaFJ9g==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by SJ2PR02MB10313.namprd02.prod.outlook.com
 (2603:10b6:a03:56a::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.28; Thu, 13 Mar
 2025 20:10:43 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%4]) with mapi id 15.20.8534.028; Thu, 13 Mar 2025
 20:10:43 +0000
From: Jon Kohler <jon@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Jon Kohler <jon@nutanix.com>
Subject: [RFC PATCH 17/18] KVM: VMX: Allow MBEC with EVMCS
Date: Thu, 13 Mar 2025 13:36:56 -0700
Message-ID: <20250313203702.575156-18-jon@nutanix.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250313203702.575156-1-jon@nutanix.com>
References: <20250313203702.575156-1-jon@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR02CA0007.namprd02.prod.outlook.com
 (2603:10b6:510:2d0::18) To LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR02MB10287:EE_|SJ2PR02MB10313:EE_
X-MS-Office365-Filtering-Correlation-Id: 854b0607-21f0-45ea-af8e-08dd626b2269
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|52116014|376014|38350700014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?U8I9eQbsxJS9kpWFZHsCw3vwrkzZKkiVVtRl7zTdwbO+WeAkDKDnB5nOu9Tc?=
 =?us-ascii?Q?aQKy/S6KRYoQwSjorMjs9YobXPuGcin5Db0SMU0JFJOeTD54V3h1mpOZ4IwD?=
 =?us-ascii?Q?2b+uUie9Qm/TEIMY79Q2MKnAsr0sVZgrYTvoWqUb7+V9Z6wSPhfwfImidyL6?=
 =?us-ascii?Q?S3HsPdrXaYED5l5EpEzUgCOYVDYWs9Y33GG4g3Tt4rEEwNDXQ+t4bw9hIVvh?=
 =?us-ascii?Q?uRh6k+WC5W2LzhdhKQd6aV5gchK5/TGYOhWyux4T7Dq4ycKcoLx8EnrImc+z?=
 =?us-ascii?Q?O3xDwNX4BcI+MylXIKY6jgY+vHopZ8esfMwJz+hoIAGhHsDAXxn94QxGgK6Z?=
 =?us-ascii?Q?aaTORdLmNiZmzj2bvUnlqijBkkdES+LmXqNHY3w2lkTBEuYJ7ln6c2Rgylh4?=
 =?us-ascii?Q?60pof8unya7MyXIXDxRrcmMWipgRecLKZoN4UzX3KF6ZP4PE+dPmeL+gYUUY?=
 =?us-ascii?Q?7hwlmydx96U9wWf8o1aYstUe+NQfhhNap6zZfovAKeqQvf/GY8CtOsxAfRx/?=
 =?us-ascii?Q?dM+haakJ52IqLMlpkZ01FuoZwI/TWjE0/IKcj8BDpmGC/4eSM1FAQ3zawSdY?=
 =?us-ascii?Q?Xq38QSiGr4+hun8pGRWQEwaBxhbSYOP3ojZyJ4htwIE30fzUo8SRtW5V43iY?=
 =?us-ascii?Q?3NX2XJXaMTYJnqpucvA4bGIgQUP+0aqlVuWRYuzsy6SPx9qwvFiMmiG+CEWr?=
 =?us-ascii?Q?4id87gQiJRQfGMhXK8NhIebCerF75GYWn+nSxz3W+3UQu9GWttTFU/KY4/fh?=
 =?us-ascii?Q?Kbn3kOOGTAJmMdiL5f/S7WmnghUk6QFwd+3WKsH72lGN96ycz5BTL8RieNIl?=
 =?us-ascii?Q?0/D5+ONtLJFdh5DE5P2ein2q77befnV9SkrAwh487gxsooqp7tfbNYAResOl?=
 =?us-ascii?Q?SgdWTDjVrYl/7Qgzz/ODt+nJvVsV8hp1Hd2DBFv0GNsoC8cnvWgfCIQBUaub?=
 =?us-ascii?Q?opo5TlANOPoaSmxaWMMI13vixocfr4u0ioEAHY3+nNEJLxZ8XZzD4lhwexwu?=
 =?us-ascii?Q?7OT7XOWQywKhf9709/CsiOPQhaI0lwBLeTyyqu5YerP4dPpBH//vBpegw2Kq?=
 =?us-ascii?Q?mroDWVD9XYwvkm5VOfsOlaG/3sviXX/36q75kNyQ7W+yFUUs6+9vswTYAy5J?=
 =?us-ascii?Q?bfqS/JQl2ZWLcaEYUZ83gKFWFOGzYtUFzJawHqvHI2WZ1qOV9Jv1BgmqLd6v?=
 =?us-ascii?Q?pqFo7i95g0ksiu2ln5U0oamF4/s0V9OPZ4xdp3t+gCRDujlA3AOaZdwENnui?=
 =?us-ascii?Q?n+iiAXi9+00wzUjrymKvXG1za6cHWdyBIvQ2qh5CKswYFMM7IR/TpOEPDMsM?=
 =?us-ascii?Q?IwoDNbVE1opbPdCaHskeFNSuzwtz0KvrUqBU3AnxVRlsMb+Uf9VmpuvniuxI?=
 =?us-ascii?Q?QWJTHnC395HyK3jaBe5aT/3sWmxJ4KGS46vdtiPLUFpIiTP5N4p+4flmPQT6?=
 =?us-ascii?Q?bo3dgDLpea9rJDAv3Q1GKjrjr6gvbTN5JnStx6p/mKfmboL+cTD/Cw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(52116014)(376014)(38350700014)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TMp6N8NofZZTx6X43LP99klhZdhMeGYAPvr2o5cIiLlyExtAImvPK/JkgwgA?=
 =?us-ascii?Q?EC65Z4fLSaVFXDOGcHqD/7ePuhXsklK7C0EYcqDkSrShn6b6YJe16RId7ENC?=
 =?us-ascii?Q?8yajZrq67XzKbWgFmCFwrCRQ7nb5kiOTaLtY61Azjh9lCvvq3QZbvw1QoDsB?=
 =?us-ascii?Q?uEgXh7uYbnoZTA/f/FdtmPVxEtV3mY0l4Q8RfBQafHqnJ+UKudVE1jRktimy?=
 =?us-ascii?Q?SSSmHKTcKsW9gxzU810YOsp0C8nlf2+mwjLrJCQcuOjluaML6af616wvjZGa?=
 =?us-ascii?Q?c5B/hx5PqfLcgBFS/jYU5aLebTg+DbaH9pGVuKjp3NYYz9v/V+6FRHaYcfr7?=
 =?us-ascii?Q?FdgPBFEuhrIvLnrZRDIzlCNia2vPRRLcNwvbtg0x7HttdcO+LOdp6VONMLUG?=
 =?us-ascii?Q?DkOduQvBPPoDGqjBDs/RON2LfimKw8G0V/qSeWZw1iMpLWDJL8pPx3U9FVSS?=
 =?us-ascii?Q?PKCPNgFxX6salG9SGUmVqPdrKPpIWnz4Rfc+yNsgl3kjE3+NKUF3uaJnTGpT?=
 =?us-ascii?Q?0JLv+EfqKcqfSrx440OdW4nNwf0rUN8z2dDHEIDV+ypBmr2Z6eZFMdIwpJ20?=
 =?us-ascii?Q?1HwiIAPcyaDUH8N2WsLSvpS3/4jzPABTluxmnOlrhneky/vxWgj86+yTy4lR?=
 =?us-ascii?Q?/GJx4hTahrtHRaMM7ja3ec9bu03jkOkN9LvKzW8RGdoC3I3+lNNVtVlkUeK2?=
 =?us-ascii?Q?jgcR/NFmGOulov503JEiSINlS5Tc27NJfSbjJcI6g2fHoCP1ZplnzK9dfwd3?=
 =?us-ascii?Q?l/12v2bYxQiylM1Qp3J7TxWaOnPHp4xM5L4TPej4IWuPLXZNoR8SKdi9nJZL?=
 =?us-ascii?Q?TMaBs5l2cxRO9Yv0LV5x7pSrwxdDB6Q/6UJTnNZ+L3MZi9jhY71uOJe8Pm7N?=
 =?us-ascii?Q?gsrBdW/aiD9fJMXLnevj5/u92MkcksxROfGmMgen/BKn4SjFnNQ9hqQEHaH7?=
 =?us-ascii?Q?4Vr7CU/7kn4s8JyQQxmh5FPQhQOZoov+TP0/pl7NlOx0sh1KRBQb7cIcAtCW?=
 =?us-ascii?Q?gS7hHk++L/RmRs4AnTH31lH1YZr96NKxoFdWbsxKj5niD0DhqbyPPiD/Epro?=
 =?us-ascii?Q?SChJsfMcj1jyBYV6Mvxgj8Vtk3g+SmrAozENJYTjwX+La6RynPp7AdDmDVP0?=
 =?us-ascii?Q?DdvMWRnrvJ4zrMEur7B1mk0XsXTam3rhQyGiE44cSplA7dsNIJR2CWR2gOx5?=
 =?us-ascii?Q?uQk16AAofeMnKBCYssYnpq0s24++Ijuz9XnWAH+B4rO5Y4cHlMOtayM8fbJb?=
 =?us-ascii?Q?tBnlYgyq2PGZx/F1a+EYcMJarZUsbJYjg0ubsIEu9IAEfkNC5RoPbnVsINKD?=
 =?us-ascii?Q?DG93Y7WE8bo6bdXzwmgOgvwRhIWMQovZmd4Cq5Al2fwlMWPk0FfNLZsJBqYo?=
 =?us-ascii?Q?uYHOMp4UpRghJAaKfG2vz/ly/Oc1jYb1rkP1RD24wLa29os/mR03AduGtEGn?=
 =?us-ascii?Q?5tm7bkwD1way8tRilLG8eWfb3iPMFXvnh31Fat6vrDFunqr5GuvCh0qUK4lW?=
 =?us-ascii?Q?lIqAb+JS2jbFmbR2GWB6zn/qkgMxm2BKVsFUmpWk/jYTdmicPSVtGdxNcLyB?=
 =?us-ascii?Q?EB11ubX76Sbs6RCIjyvBBOw7vIeJyCG5k4KIEUQiaXALCDgtgNmvGvwFo0HN?=
 =?us-ascii?Q?6w=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 854b0607-21f0-45ea-af8e-08dd626b2269
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2025 20:10:43.6034
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y2BAsmgE/mFbXHTErg1Ask7fBp//FIarg29/8UNQoNMX02sr6+v/vFXP6Yk8oxB/7nFCpgpmqEz5H2mCTyMffRJu5vmQB5xJR3alQaioAXM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR02MB10313
X-Proofpoint-GUID: hBikA27T06n4MW54lyt79qZgyj6U55ZE
X-Proofpoint-ORIG-GUID: hBikA27T06n4MW54lyt79qZgyj6U55ZE
X-Authority-Analysis: v=2.4 cv=c4erQQ9l c=1 sm=1 tr=0 ts=67d33bc5 cx=c_pps a=Odf1NfffwWNqZHMsEJ1rEg==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Vs1iUdzkB0EA:10
 a=H5OGdu5hBBwA:10 a=0kUYKlekyDsA:10 a=64Cc0HZtAAAA:8 a=oo17p7DTFPNWD3L-sCgA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-13_09,2025-03-13_01,2024-11-22_01
X-Proofpoint-Spam-Reason: safe

Extend EVMCS1_SUPPORTED_2NDEXEC to understand MBEC enablement,
otherwise presenting both EVMCS and MBEC at the same time will disable
MBEC presentation into the guest.

Signed-off-by: Jon Kohler <jon@nutanix.com>

---
 arch/x86/kvm/vmx/hyperv.c       | 5 ++++-
 arch/x86/kvm/vmx/hyperv_evmcs.h | 1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/hyperv.c b/arch/x86/kvm/vmx/hyperv.c
index fab6a1ad98dc..941a29c9e667 100644
--- a/arch/x86/kvm/vmx/hyperv.c
+++ b/arch/x86/kvm/vmx/hyperv.c
@@ -138,7 +138,10 @@ void nested_evmcs_filter_control_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *
 		ctl_high &= evmcs_get_supported_ctls(EVMCS_EXEC_CTRL);
 		break;
 	case MSR_IA32_VMX_PROCBASED_CTLS2:
-		ctl_high &= evmcs_get_supported_ctls(EVMCS_2NDEXEC);
+		supported_ctrls = evmcs_get_supported_ctls(EVMCS_2NDEXEC);
+		if (!vcpu->arch.pt_guest_exec_control)
+			supported_ctrls &= ~SECONDARY_EXEC_MODE_BASED_EPT_EXEC;
+		ctl_high &= supported_ctrls;
 		break;
 	case MSR_IA32_VMX_TRUE_PINBASED_CTLS:
 	case MSR_IA32_VMX_PINBASED_CTLS:
diff --git a/arch/x86/kvm/vmx/hyperv_evmcs.h b/arch/x86/kvm/vmx/hyperv_evmcs.h
index a543fccfc574..930429f376f9 100644
--- a/arch/x86/kvm/vmx/hyperv_evmcs.h
+++ b/arch/x86/kvm/vmx/hyperv_evmcs.h
@@ -87,6 +87,7 @@
 	 SECONDARY_EXEC_PT_CONCEAL_VMX |				\
 	 SECONDARY_EXEC_BUS_LOCK_DETECTION |				\
 	 SECONDARY_EXEC_NOTIFY_VM_EXITING |				\
+	 SECONDARY_EXEC_MODE_BASED_EPT_EXEC |				\
 	 SECONDARY_EXEC_ENCLS_EXITING)
 
 #define EVMCS1_SUPPORTED_3RDEXEC (0ULL)
-- 
2.43.0


