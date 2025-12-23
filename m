Return-Path: <kvm+bounces-66584-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 55315CD8175
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 06:05:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6D141302AF90
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 05:05:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9383A2F361A;
	Tue, 23 Dec 2025 05:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="WV0YdIkX";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="J1xnibM5"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F198014B084;
	Tue, 23 Dec 2025 05:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766466300; cv=fail; b=ky6T9U6101lhD8RoDF9LuikJ3apWsp9WJ576MVXL1MmC0LYNFpIS+6VRLEd1BtaXUC38FOWHI775EyvPWIiiySXKu8RX6dsGF4Gdn4V/YRtdbqvFFAOMQuNlR8EODMevOkHbYEzbYwgC1xQP+/wNIR12DXPJOFNEtnzhHRaztTM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766466300; c=relaxed/simple;
	bh=N2R8kanykj1w4se+ZEpmEK7vqr1jslorOyWRxt3IPPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fEUq7oY/iqrau4KwB1dvjLYOnkpDw1FKoyUOjymzDMf45kobKAb6OejrsyXxLCHvke805JnZ2XFCP6o8T0uj/0e5+AbaQSID9QWVrTxBEj6EQkY/AzWXuiB+7Z0WmvkRz2GgtLdU9dlX/TuUa8LRZqd6ky+tI3nf6oO7ePNeLmg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=WV0YdIkX; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=J1xnibM5; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BMKrL3b1942757;
	Mon, 22 Dec 2025 21:04:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=vdwyVNSGr1bu/F4R51gwOFjVoZydkdHYLRXz+H+sK
	cs=; b=WV0YdIkXneTW7UQBBJ/vmObjt7RjddGHcKG0IJOZQWwj3OWmQGlEtYNf0
	uL1C7QkZausFVUyJAldep7/x0pXVuBQS1wQI3a68f5jdr0uH3wMUX7OfYS7sGK0x
	VyUPzIiAhmbOvR1fUItMbJ9ml7afJQ+JaEw+iuWuenCvKQsA4Fhyt1soQau1w6Ym
	WfJl5q0E44su0Vj1sYCRizwOk/Zh8qFo+/WU7WoXNk8UAhuHRP/spGfZJUMP//RI
	r7YbdlKy/JFiL22pWgEtFKMQ3cBjY15RqfZPSkZPfBYsC5kbR/Hmw5wMsaaGQjZt
	xPbWBbYL1B7SZZwJp/vjrwlKxHGUA==
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11020085.outbound.protection.outlook.com [52.101.61.85])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4b73ydt5v4-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 21:04:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QzG7QkqOsPJ/A2T3nLuDB4O0fUIeozIEWzzliisWP1z2rnMJ95Ig5/p00Do52ZPK/9F5QYwsX6Wv0NoW3plWnTD/HkkLFfviNv/uD6VVIHyK+uRY26AdB1KdXHsek7k3RA50XuIPlVbPd5XRZ2Tw87Bpa5k/ZlQPSfY06OuJih8zRknZ4+2K/mU0pYOqAX/yxl0LOPQsdBtb7Un2cdoKn/6TP8iioiPf/O9IsY8hVjoBRb4MvOQGzXmgDzkTNhYNNL/mlfhLJYFrFPn8Mu8plq55YjNAQu1G+4tDCv82VE0WvAbHC4GzXPXC042T7il/zh3FcLLUYRX2JQKniDWH0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vdwyVNSGr1bu/F4R51gwOFjVoZydkdHYLRXz+H+sKcs=;
 b=xnTwCcj0dEM3QVdQlsU+qUEsZaSNTftyQaNEuH3zW5j4WTiu4hlGl2cubIhOGaThlty3SkVI/JzEEQk8tNOdjyyD+fZmtS/FK1wYBYrAPJxP8NMNgPx3o0B0pMOLM2D7+YfJScIIf60aztEMHCobhzA6PGn4QhfU50epq6tXj2M7Auw1BSISGxutRl8xD/jexX6+juwBscl1A1E8VxCynLiK9BRA4VG31jxgAtCguBHNbeKKo0/bKyGoQrfi31HE4BvAUn3yiQ2rNja8Ax+KYkLeob1U3XjMtfyZC/Z8tOX8h27Uk42Q3654BaS1jDZTmeqGzsYwOQw6RAZDxGiSuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vdwyVNSGr1bu/F4R51gwOFjVoZydkdHYLRXz+H+sKcs=;
 b=J1xnibM57FlnNpQTmQqcIEGFGQLZ+r5wjZZJg5XQH0bXaStzA/a/ItPQFzZJZpoZjAaXKYGfsIc1GJHdJNTeeo4RBISFy/TaBWyCtGRcTxerxaUsb24I33xl3Jij2YZGs3R6Bzgj1GQqD0bVl4NhHF2nVtE6C/zvQ8YT5fKsSYFhM3bVblAN4jWmRwboO6EhdxTXKTQkcYMRhx3/wsbiAIKqdnJ/luSXkMaBwna7KaEmw27wBzLYjTeY5LTMWEB4taH6xNa2IIjzwwkVRmM8g91TBqi2uSlManN07zu96YYMD29IM19YO8E8bjA5c2HddgnXg441pHddJ9cgCf3Q7Q==
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18) by SA1PR02MB8560.namprd02.prod.outlook.com
 (2603:10b6:806:1fb::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.11; Tue, 23 Dec
 2025 05:04:25 +0000
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc]) by LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc%4]) with mapi id 15.20.9434.009; Tue, 23 Dec 2025
 05:04:25 +0000
From: Jon Kohler <jon@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: ken@codelabs.ch, Alexander.Grest@microsoft.com, chao.gao@intel.com,
        madvenka@linux.microsoft.com, mic@digikod.net, nsaenz@amazon.es,
        tao1.su@linux.intel.com, xiaoyao.li@intel.com, zhao1.liu@intel.com,
        Jon Kohler <jon@nutanix.com>
Subject: [PATCH 2/8] KVM: x86/mmu: remove SPTE_PERM_MASK
Date: Mon, 22 Dec 2025 22:47:55 -0700
Message-ID: <20251223054806.1611168-3-jon@nutanix.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251223054806.1611168-1-jon@nutanix.com>
References: <20251223054806.1611168-1-jon@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0P220CA0016.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:d3::19) To LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV0PR02MB11133:EE_|SA1PR02MB8560:EE_
X-MS-Office365-Filtering-Correlation-Id: e00446fc-ab9a-4172-34cf-08de41e0be4b
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|1800799024|376014|7416014|366016|921020|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ohDXBe6V9nHOJ2v8jRYrTVFcRhrWx/7YbspUcZKGYwOoiCUjw0a4F23Lz5QG?=
 =?us-ascii?Q?0YqPDMdPl756z9KPurejAltKPJzidP0T0YyUuRNZxYmxxSDv3egkvhELG2Dh?=
 =?us-ascii?Q?nVgxfbKlKsJxfu0dHNKmMbabeipz0PWLPY2TgKWK1kg152QsOtYsjRQDvlLa?=
 =?us-ascii?Q?fMeIan/qTCP712vx4R40F4WZs2ItN0Kkz6V5Jb0BbSBMEZ/wjDh0MbKyWFT9?=
 =?us-ascii?Q?4ta+ItZ03jIhuJ3HGXYqDrd47apz/uW6gI15XsH/QnQrFxT3OlNF23tcF+EC?=
 =?us-ascii?Q?tQzfp7ORWwaU7ut8cxTcR3X8YNTM0SI8wKMJ3gpX3EPKdtOoXEzaqHMJMImJ?=
 =?us-ascii?Q?4DNy1lSe0R5cmYgY5uBtOkSAOZm1y62twiI3lMdCAYiGElL6JBCqurSaEISy?=
 =?us-ascii?Q?KBlYk1M6ZdDFvh5fpxkELX/dhPnCvsVbEh4VN/3w4UncpWKHd2dCUgj+18iX?=
 =?us-ascii?Q?YzWjugWWHN+chMn5wKFMZ880XHHzdTGckt5GdQaxQA5RR/Uxd5D5d2+UY92Y?=
 =?us-ascii?Q?ye3EBDZBAcByTU3y1XZmM+hcQ/UcKK4tHo9xUhBGEh49bOVfVGxqYvppP3UE?=
 =?us-ascii?Q?/BYCGfCeujCT9blyCi13gtJs4qiscmCXWJiqU7EtPuuXwzGhtlzijI1EUnAV?=
 =?us-ascii?Q?zZx7W36cP8rhvEYtOWCevZQ3M3z9ljSYHIx17pA4iNsIXtBLDXESBTA7AEze?=
 =?us-ascii?Q?jejeZnHjqxPKgpSdJtfaYDvA42mZSE81q8jHTSxs65QmTzPo6lJhYP1PV160?=
 =?us-ascii?Q?pcIGXoq2ISRoIvu0NCichztaKO44zVAgona5dB5BU5OLIQTSTCD+jB2yrKfn?=
 =?us-ascii?Q?Lc0klbzmFBdB8gehjodA2/fPpCW/0akmrGbrNbGeRW9e0YKe+3zrtPnSoW+4?=
 =?us-ascii?Q?mDd5aGwfS4gK6bw+YU71l8eNya70FAVbO5iBL2UAIQeSzk7cRHTBYMMfFHCO?=
 =?us-ascii?Q?K9owuTsyb+gA15yRlyfKgWf+K64NCBdK/WTrwZT+Z5Puk2QsvvdCLYWF+0xV?=
 =?us-ascii?Q?syC8bm7/DwLkmd1iIPlfMgEjWkOlKcwuSrP4cTBzNu6LuROZccFPhlTfblhi?=
 =?us-ascii?Q?ZhjfCPtC0/W0SpHp8pNOMnM8BtZoB9dKJYZ7JKW3WqZe5etyJUEyb7PSnWW2?=
 =?us-ascii?Q?9I554jSKcBokmToj+lTPYy/bOS5NToORYDhfglzmQRyuLv8OhD/SGeptmVPN?=
 =?us-ascii?Q?NM5vmEI0vRERtvx8Q+SDamfAC2SUIp+evBoHapkxHrN8r61W6GeoO01ONVhy?=
 =?us-ascii?Q?rafsCYjTjyEq5PrnFX7WUNDVnSaZkk+jhPWnN8PPinK16lr6nl8ky8h7Q8Yr?=
 =?us-ascii?Q?kEHBU/ZfdOlp0y338RfMBq5pDZSAqtriHrex80KVleq8FW1+fOhoyp4uYa7/?=
 =?us-ascii?Q?t4FMoOCL2M+fsVO9qatypI32CGBMF/u/79HJ4nSoo97jpFt+cLwuuTAkNAC+?=
 =?us-ascii?Q?DLCnS97qW1kw+yFZXxfEDir4Tg9Y8TqkHv3DWgh9Uh7olrP2vmhRd4UYm3Qm?=
 =?us-ascii?Q?Ux3uwgP/UgRmL9Wz9AzKTPk5qehqBSu8W4RFlvJyPlVZHtqQQ3YfVoWZng?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0PR02MB11133.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(1800799024)(376014)(7416014)(366016)(921020)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GaTJWw0Ua1rsSpOhvnMl9DJDSGXAauF4pxonfhzRpxShNJIiNz5XWJa0x7Fd?=
 =?us-ascii?Q?qUlZOufbX93TnEixCtIysjvS+L7prOmOpPXimhW640bl4osrdnyE8ytTPOKT?=
 =?us-ascii?Q?8rm6Cg7MOJDRsWlhQ3syU2oomsH1lB55TTVgUdq3b+i+PgYsuUuzs3tmICRJ?=
 =?us-ascii?Q?pikB5wY6Q16IDibESvWRENptS0d1tbGv4utF45yNXlFQWyVoKakorecK6jmA?=
 =?us-ascii?Q?3Et6tXngjfrbQxdxRx69rfvDJmqz074i9UVgQSkvuc+bt6HKK/U5IKhMbQH7?=
 =?us-ascii?Q?HUg5DqjhhKsTviUyu3OALXHZKE5BACfMtyE194IxAD70fSi6YjFMgFwJSkey?=
 =?us-ascii?Q?1p8BtM5kdWTvvH91r5Ysly8Q1mKAVZX+rUCqd8AVtlFJQp56D4kxmnqBe40c?=
 =?us-ascii?Q?dqzOCzNfhwWqj3lvJuZ1fegK74yAF08Gx2NNuZAUzF5eut4PI2mJ0k9p0Huv?=
 =?us-ascii?Q?kHeAP2xhLptr8h5WbgBZK71/GF28UHsDK+G6WTmT+QwK9NapsRAl+W/yyXv6?=
 =?us-ascii?Q?w/Rd2VzuAjue87XkfCWSsMkbXvb7AXmM7cGiOYaMSNb6kz6SPgbDVjpZPNFI?=
 =?us-ascii?Q?AQd7WkABFy47WtqORXNnb0f755fs6QIiE5iD/0k58BBJqCzFXw3lKQKAlR6Y?=
 =?us-ascii?Q?zLFA7mCo2Pzw4jFrRbhkUCJl7OfK1GXTm64tpFhgeQV4EJ3L7ydPp6hRESS0?=
 =?us-ascii?Q?nKlhHfymu0KBH2pE6ecTqId42QvHfrUG4oqLdi4sZ7WkNH5+z8pNGilUrnqN?=
 =?us-ascii?Q?bSRCyrV0IKiT9sq/W461qJFMK37k5v6zCphtaPQ8FVwDzL/9xg3Wiv8VxPdw?=
 =?us-ascii?Q?7oYplczRK4tRolp5nbzWnSbgRqN4OdkfDwfaNDhRFOdBx2C7MfFC1pH29xSY?=
 =?us-ascii?Q?pZKahnCe25mPfXRUG1IEJUxtKzdxYP1/+eprI62Per0hChp8JLXVdngpDttN?=
 =?us-ascii?Q?jChdNkiFJJn88J0Hnpuc0Z4NYLhiXFdnCAk13XZjQwnJWwHU0EkAb3LBNPGE?=
 =?us-ascii?Q?zKpCZHHwgbvhKlO18w5p0sr4qDM27mR9S0oK7h9KwzHzyGpCIdaDBnw7jz7g?=
 =?us-ascii?Q?pWVce4J1Tg23GwSgUYpOYb6gKuIKt7TPuKyGnoRpKlJufcSAhelCTDhvFOqV?=
 =?us-ascii?Q?yQ2ZYzVPqBSqrIWCuxqPT9QIg8Jgivhztld8RkZ7pZjGYR4Z5Ni2Gzt1CiZP?=
 =?us-ascii?Q?KwwXtTT9m/T5GfQGCwRTtaOzPy8Vx2mwx3EymkafQs3aKyErV9AoFHLsZiSS?=
 =?us-ascii?Q?0WtVcLp7ex+rBxivGrsWR6Jpfaxom5SjUqeJR73/JN+ARmYi6eYi7oFhgI6d?=
 =?us-ascii?Q?X48K1HhkZp9EYmg/wolaLsNo8pBOBYHANE6xoNGt1GPLHPiKWrREGqCvlySE?=
 =?us-ascii?Q?DZRZcewCGYgVvxht4yD7ESmQ7U8/wknZYhKS6/AtKWYf7wXM1v3de6Uj/Q1k?=
 =?us-ascii?Q?beMscApX1FVxJr8U6lOZJk+SXltcA9FzBH1idzKoUfhXqJxc29PmacXFK0P9?=
 =?us-ascii?Q?Ld5cepAEcBjbBtS5V0rThaC0D0tjlEcmPDJzIOdmp10n4i4cRjSMRo4Dg/AF?=
 =?us-ascii?Q?2XJcBku3yUciiUwp/MD3sp/AV1ncvWi87chBLwK1YyvvwcJPnzo3XhQYCubh?=
 =?us-ascii?Q?6SZBbMTsL+nTsYkiDGsYQ4wprEuiISVLVkr1ZwEltdiH2GH/du4wXor4QI2b?=
 =?us-ascii?Q?KVeWYa5joabeokqL7+B79APYQWkpIX9xEVlTC0fA5T1wE8deUMy+Dhen545C?=
 =?us-ascii?Q?G8LgsefP7GsGcQo0wz85MomapiRke/0=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e00446fc-ab9a-4172-34cf-08de41e0be4b
X-MS-Exchange-CrossTenant-AuthSource: LV0PR02MB11133.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2025 05:04:25.5671
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eKmIuOZnOZpwGzf7aYcCt6PPiSBHm3DuWVP33AaLWPNqaBK1ObIgLfg6HW0rgRvdE5f6EAzNQBpaTLFPo5vm3TW3g650TfgOv3u5UIqb5iE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR02MB8560
X-Proofpoint-ORIG-GUID: zQlobrh_OMDI-x33SsAIeVftBG-HASUv
X-Proofpoint-GUID: zQlobrh_OMDI-x33SsAIeVftBG-HASUv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIzMDA0MCBTYWx0ZWRfX5qbOouYpwGd7
 SC2wXD8mRMaTA7tZmaHoUgHQ+BrlT9xAmRAkwZPUsLTdcZTsCvCOncz5uSyHPt3xjG2D7oKPbhu
 0YB3O2YRRXgMmxmPmX2rOlf5M15b3g8Z0XXp0NeIVXdWdpCFf0k1Qbd0drqLxjxvbkcFzSXvYdK
 w37pH3iM5uYhuNNEXVuNLg672aLHwqD/steZ1RpW4tAvtOxU9Gl0WimIXnGJiMdKX/hRZUzYKsU
 2ZYU0jSOFSrw6Qi5EY1vsTZ5mQVVQtnPjPBAaghfyhuXdQA3FsRrjwfJwfiB/7lpnRbfPyJnRS7
 zHNpbKBgegmoUwN6sK2QmCSeLhhuMOrvFGJB474K6EqUBTCcDXDHYQ/Ynkh6QWzlJ4ozN46u/u4
 uzLeavIhB1oacAXJMU4ctf2oreT+anM2DBR0mbI0CVlD9WJUtxhTVc81Geb/IDRxn++T3o3Oq6H
 pNM6a7zvFmmG3/g91VQ==
X-Authority-Analysis: v=2.4 cv=QZBrf8bv c=1 sm=1 tr=0 ts=694a22da cx=c_pps
 a=CX+cjZXKan4d/jn2X7CWJw==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=64Cc0HZtAAAA:8 a=sKgUPJO2Fa4kC_44OIQA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-23_01,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

SPTE_PERM_MASK is no longer referenced by anything in the kernel.

Signed-off-by: Jon Kohler <jon@nutanix.com>
---
 arch/x86/kvm/mmu/spte.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 3133f066927e..0fc83c9064c5 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -42,9 +42,6 @@ static_assert(SPTE_TDP_AD_ENABLED == 0);
 #define SPTE_BASE_ADDR_MASK (((1ULL << 52) - 1) & ~(u64)(PAGE_SIZE-1))
 #endif
 
-#define SPTE_PERM_MASK (PT_PRESENT_MASK | PT_WRITABLE_MASK | shadow_user_mask \
-			| shadow_x_mask | shadow_nx_mask | shadow_me_mask)
-
 #define ACC_EXEC_MASK    1
 #define ACC_WRITE_MASK   PT_WRITABLE_MASK
 #define ACC_USER_MASK    PT_USER_MASK
-- 
2.43.0


