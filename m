Return-Path: <kvm+bounces-66772-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DEE3CE67FC
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 12:19:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A016A301FF7F
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 11:18:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93B253009DE;
	Mon, 29 Dec 2025 11:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="KIX+X084";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="I3vblus2"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DCFA237180;
	Mon, 29 Dec 2025 11:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767007133; cv=fail; b=t7RRLCMzZ1i3SQkuLoTvk/dt9CC7UiAlJuH6js6gDoEOovqDWD51uyO25mal+7Xmk+quwX/uoUcB68XSs7zrarPjW0r2qKFXZ3uKDwVcM/Y+cv+aYw3Hy/BiJsjH//cM22W3iCYiD5/7VdDaVKFusz8Eoj3zQXZOB964Gin8Kp8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767007133; c=relaxed/simple;
	bh=5S5fdNSj1Ag1F4fksqEm4GWMwd3obM5IrzXEeHtHbrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uGDy9DMUAeiHCcqCNG1PRlhKJuCW99vJiLfGwaGUyfc0J4l1wVr4cDs+/HB9v+KtIzV739FAZanDzx8SQY0Oj3Oxn7lQZ3WTVaK6JvsS8tQB2cI4DVmCdPFqp6iLn/FAszuwPCy0SCvDY+qBVk6rkNTLPgwEPAJWYE/vCEWVx1o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=KIX+X084; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=I3vblus2; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BSMIcA01210614;
	Mon, 29 Dec 2025 03:17:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=Vilz5b85wH9tw+0GiYvZ5ZQ9xPnq2jHC9cqsDxd7a
	Jc=; b=KIX+X084lxfcM7Okw9WKDLlsDVXctoYHAG1F60kD/8fTCZvstmpsRJSuA
	IeUp3NeNuyr5Yc4jQdnX5/9a6EoGEXyH8T5rihdjnV9FnX+wOj65WqE9j7roY/Z3
	k+rpkbR1DkQ3F9O3N1L0Om9sd9atGzWAegsxRcKv1qa4rWmd64FJ34YS8QzMbnYS
	lqdGck+eehg07+I0bsfLIyorA0ssXcn59xgmxjOofLbNVOtJU3n3BbUmG81XkIV/
	So6fK77pGCW4Bit+uoS04MPO2iPdOtSuBRMZo9AvEgqlFEctnR2zChEsJ3dj4x/M
	04308IHdhmgV3XFNC18SSMJmX+8Dg==
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11021096.outbound.protection.outlook.com [40.93.194.96])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4bacns2pwd-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 29 Dec 2025 03:17:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fHqTBse/GxwcLpUL8uq/aTdBW8R04oqaR3ZVL3HNcLESpxf7bvrRrECYmqDkmno9OylwqFL3uLEP14C2aZzSfjZQK6dPwhS35iypJMBK5ch20XHSZDSntaOp4xyWwxO9E9yye4W/1XSOjQq4QaeduYDfuCqMmLppJEq6IS/RXLrNRImL1+Ppd+/epZRz13HWvDh+da1wR5rebrOxd/woi6kuJIdt//bqXPOSESrmKIQmcuNNTnO532SX2Zy8jfM1UE2aMookVy7SIp7G6DiVTjLSNA7TW10hsfBJe2vOElGoysH3jZeu3PFDQGdUcQBhS/GmEnNUQR2Cw3MDLw3hdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vilz5b85wH9tw+0GiYvZ5ZQ9xPnq2jHC9cqsDxd7aJc=;
 b=IVqJxoeqbHm5oZ5IM0UvZM198kmjPEpoMzd7nVuvPmddG7KczFWyLtHhhlycGzu8PSdX3sR6dD0Sk2Cp2bT1COWmg6kRn6FRlX5YkMlXh2eLShzOSp/KWxZQsH7kCi3ZanWwHAMoS8i3XXvyWpWkeJXdmyRUI+Bgm3Vda9B5eDPKHfVEZ6T/omp588hUzWxXHGXXhJLLPHP16ENUckr0ccq5bBCuzYhdJ5fbDr1WAhnpRjcFthdHw524BobNXRDygsGnoGlCZbEXFVdDMEL7c0p7JcG8qDDXEY6gQv+N3gaUCA/iG99ycfwMkJNrmKDx/iT7z1zc98tVMi8PaD3wsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vilz5b85wH9tw+0GiYvZ5ZQ9xPnq2jHC9cqsDxd7aJc=;
 b=I3vblus2wUkvyPThb+SsyeLaf9hXdjJ1wbyEgLbLt4CqNhvmHLaFhkL6y9QvOVOWohslj9ku+mbxh0RswVEcMceQylk+WcIB75vhkIAwFpeSlN48MAdbhxOQiDlXt4X30aRD2L5jcrjnPilNVe5dG3nTQr5LXy3zoCLTogjtzpCi3uxPse8cN8dvq0PpoM3x/oOqTrHgVZf73bPDq2Lp0UyeFtn9yAtW1WA2Yc5tsw9WGX0xQTzIxGxxS1IvS1742/1VKpPqgVnnvdX+zuJ0GgpyXcMgmN0Epc0hRSN4nFVbJAnTuisB/eMvPIhVZWfeX0tQESCp6LBZBUqzoH1Gpg==
Received: from PH0PR02MB7557.namprd02.prod.outlook.com (2603:10b6:510:54::17)
 by PH7PR02MB9965.namprd02.prod.outlook.com (2603:10b6:510:2f9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.14; Mon, 29 Dec
 2025 11:17:49 +0000
Received: from PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef]) by PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef%5]) with mapi id 15.20.9456.013; Mon, 29 Dec 2025
 11:17:49 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, kai.huang@intel.com,
        dwmw2@infradead.org
Cc: mingo@redhat.com, x86@kernel.org, bp@alien8.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dave.hansen@linux.intel.com, tglx@linutronix.de, jon@nutanix.com,
        shaju.abraham@nutanix.com, David Woodhouse <dwmw@amazon.co.uk>,
        Khushit Shah <khushit.shah@nutanix.com>
Subject: [PATCH v5 2/3] KVM: x86/ioapic: Implement support for I/O APIC version 0x20 with EOIR
Date: Mon, 29 Dec 2025 11:17:07 +0000
Message-ID: <20251229111708.59402-3-khushit.shah@nutanix.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20251229111708.59402-1-khushit.shah@nutanix.com>
References: <20251229111708.59402-1-khushit.shah@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH5P220CA0011.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:34a::11) To PH0PR02MB7557.namprd02.prod.outlook.com
 (2603:10b6:510:54::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR02MB7557:EE_|PH7PR02MB9965:EE_
X-MS-Office365-Filtering-Correlation-Id: 264e9027-48ff-4450-ad4f-08de46cbe66d
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7ZHaQIqUOsLv/Fc0wtZfVyLqLlUBDHXHyp/22tMFa1GMzNa85VrEm9fszuUr?=
 =?us-ascii?Q?ymjguQpK89JZGHNwFe54NwGb7fOrWmrRiNFeTDUks6rnVeyFvEtiNoobRa4e?=
 =?us-ascii?Q?Dl67Q5mLiO7yaXjWhYeikJDFJaPuPiYzRAciHGoCIsNZVzVB1islOy2/B4i1?=
 =?us-ascii?Q?vtm+XKX0/BYWdyrBr1Mmmzc4OSHh4AO+pTyIaRX1hu8R1EGG7eTcIrLxtMYa?=
 =?us-ascii?Q?wc3EWZ5SG+t/JbryXH8aVM9eEYm+FE7T0+4Xq69HmFbcWceKJ1uFgHe9iC4t?=
 =?us-ascii?Q?ZS0XFSlLJXG7E60nVuAGenQZanzb6Xuc+y+zM17z6u502VbkCPCogqWOXD+/?=
 =?us-ascii?Q?LmGzBqwevyYBbcFfEzODbZ5JfwzLILE3x2M4JYp2pmlIcMjfdUxVsRNKLOtk?=
 =?us-ascii?Q?6DbOd51AFq7ZT5zxtJ3X6krxlimTxEPqiviu7kvzeLRvDIqjKwChjmJ3nT1f?=
 =?us-ascii?Q?Tp6X5f75nE/ZSdmT2Qqycjp0I0cKxIDDSacPR45mQIu1G5aoVQDIZzbA7Wv9?=
 =?us-ascii?Q?YRaFLvic7cspgwJhYDfzIkNbIqwD7Yy+vCR8+lbs0MBmtnrUzmh3tu7ySeQY?=
 =?us-ascii?Q?7ZJKcldbhEpN7pmfVA3DLcfrKAv0Rj+3DWUrKObdGsD63dRlN4TM7SsAJfDk?=
 =?us-ascii?Q?NqUSngxe0msDF51K/qvRDa/W/z6HFI7367g0GDKi+iePMjfk41b2lHW4CHAm?=
 =?us-ascii?Q?vWtAQw4neq3Z0HYtRcOeRzcfXvXPZl+tfUfpfxakvyu/KjkikhxwkILiYKCo?=
 =?us-ascii?Q?eppTSYVKlM7K4gx9TYT5WbZbS56ramOi9/dEBobD/SRG0k7RI2u4J0LeQTT9?=
 =?us-ascii?Q?gVMb7dGr6cBwkK8Nd4jV0uy2djuOKAd9XZAqzmGCNf5AYbHioqYev2ZcQ6Hf?=
 =?us-ascii?Q?RexTFDTopdzO/3+QON1Zn7GUINfJcv8h+AQUxFkFg1iRUE6eraMBxpLMcHhu?=
 =?us-ascii?Q?xaH4TG11cnVQjdIZz625IKNQfVcOGUe7G0sb/coXqiDUpkRXbZ6NCLIN3fWf?=
 =?us-ascii?Q?KXo96kBLOh4ceb/UIYyap+UpO138knYQhZ/+oj9MKha395vfkhtZ8cwaGI2+?=
 =?us-ascii?Q?Y8FbUkMrmd9DLScrmGVAs+92ZpET37sdkRdSYYJRqRirXc1ZWCOl1IYcsUJ9?=
 =?us-ascii?Q?gO1/B8DG665xGFrmlQGvaT5UPvBmqDURAErTaPvcmry01HKSyqrV+sGhtP3K?=
 =?us-ascii?Q?LNdLiF8qS2bEV0gxAjk6GgdMQf1yTGVUy5Pbioc/kTAvuGrj7DW6aPvzCygv?=
 =?us-ascii?Q?XU12/SmuApUf+LqMWy39kdMCo7Vtb8aXFO0Q5CYEgInLMCvrDLgHVWJSzBSk?=
 =?us-ascii?Q?CWdEh6VfXnglVREqR/mOm7dGaXO27nwuqd4p9ok3Qnx98FgtJb9553jGl5P6?=
 =?us-ascii?Q?pvfBWXM+v6x66/NovDpHdJBoPK5mo4X3MOvgxvm56ObSN60ujRf87j1lwyfv?=
 =?us-ascii?Q?fkRVfqpz35c14xMu8e2JaM+NrRAHaThv?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR02MB7557.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?EZBQecMKdiOp4uqtV8X9faoZL/rl70fhde/sPqv79b6JcbPa4KHbn9cXZi7D?=
 =?us-ascii?Q?+muLoohzrydF7lyj5FpQ67g3z+6jaKkQ7+3VTlEpgK+OUDm/EG+mYMBC86Me?=
 =?us-ascii?Q?SvXddMpOmduRd3Fr5PZ7cnBRTs9sUR6966Hk7bA9xTWZFxLU/da5PQYPYOkc?=
 =?us-ascii?Q?4vKItD6Zu/5zGOnzZizbjAgoKde/nH59IpzMLjH1yzANOiAsJlNGSlqh+HFd?=
 =?us-ascii?Q?rJ5AB3LidFN1rDQKYFYu+cAATnASdc1ySPyWivXaW747T1+6JwQjwmd+W66r?=
 =?us-ascii?Q?dm2K+PURPPWRTiY30HL24v+1V1OWkmQlXNkGWabx9v3+fB60VYipxaaNkaGw?=
 =?us-ascii?Q?Kj5KTCrak3lATwwNREj41h1uTnZ6oy5AvNksGUhDs7p7Tyz5ti9Xb28vE9vV?=
 =?us-ascii?Q?RWCy7TGznmhKhl3bgUqCrn64KEx1lPWho84iw4EH7tv2fXbn5rO6oXkYx3M7?=
 =?us-ascii?Q?4hVK+wR46muyyu7XH5pZq+F8YERkBigCQEP9UXCH03KoQMO04SaKkNNUH/G+?=
 =?us-ascii?Q?ttydBZHAxu/ItEHwj4+jRfNbjO0G0wwnQxtHktgGfG/YtCZzdRb+owzyY5jv?=
 =?us-ascii?Q?sGknMnJwvBGVPj5EUHcYk5ONca0kcUnbj4N2l83ReGqcK+jCehj3mrgQxiCA?=
 =?us-ascii?Q?qWR3sqzaoevLM5VrhW5I//ctIl2oypNwpmdWL8aUmrrgws8cqBJ4zCHHJvIa?=
 =?us-ascii?Q?LFY59ShvmWZnLtqq1qKW6jeq2Gs4/MYv2WzexeGvQ4qg8vfcnlTqD73BHLe3?=
 =?us-ascii?Q?ofD01jrcu6xB0KQ6ZH//HlDWGR4zgdB4mf6LGB2EgKOmd7MvfRhGZr8WTL0B?=
 =?us-ascii?Q?M1QNbfZFqCzZzD0W9E9EalMmGAcDMKYnq4f5CCHSFWs2cx7g4pXO5DsUQ7Z2?=
 =?us-ascii?Q?wegF1myfjkKo7DO0Nq1zx0m97kN8g1DIo00nHk3g+bJ3sgaPXXvOPp133Mmg?=
 =?us-ascii?Q?pt9J8huFY2pF+TWLcIj8zKw5LFLINDw/Xe57jOqGHvnhJHvQtyNZNNgxHAhE?=
 =?us-ascii?Q?ebV1iJh1crW/vKYMV5dwPIaTCm9ZC7F7QjFa0f8tL2z240ZaqTrIK3/QYaSa?=
 =?us-ascii?Q?bSKvpPMGgPSNf6pN85abaSeIXm9FmuDkeSreawsQTNPS+MjbHoqcZAo9xW5/?=
 =?us-ascii?Q?Ez7EFBxKl7SzjcGj/ob1H/iD/1HiSni39s3EOoAf5ZYQefBZUgv5BQAOzgWB?=
 =?us-ascii?Q?yFoBnf9NDc6ig/s3Xzd27fW7SyjEwGmNILZ6gsAOExRq/tcqckeSfnke373E?=
 =?us-ascii?Q?JnHX4ANdjWzGC3v2U0rsJAGILRXaRxMSau9AJHoYat+uSjqYL42ShP1dliyi?=
 =?us-ascii?Q?UwHFRNJEufqv1/XiEFt9e6mjgG+hT9H1nn/3MzH3AhMuR4mdhJQXSaZ+jUkd?=
 =?us-ascii?Q?7xjUTLbJgdQZBufmJYShhQ/xo5wscg3P7nz99tUC5TDy03qAmAOij+txdsL9?=
 =?us-ascii?Q?A4JvRIVOQpigwdnriatvVv3IsXfn/ip7ufBeuiyeyC+vNOgpA3MZnB36pipk?=
 =?us-ascii?Q?LirDjHZLvz4+dxC9+hoziWvqhsfcGtGsptaCYhES97BelctHMuLKC1qFsnj8?=
 =?us-ascii?Q?enTqCwy8VQ8hBqzgJGeTG/Rmw2oVaR77fAfJf52wNVs1tFC0culEYKcGCaLw?=
 =?us-ascii?Q?4+M36PMdzPG4g3IQ77ciZ7G/L9CnPGAm1Mn+l+HoSLUz4VRl5qJUa3BImdQh?=
 =?us-ascii?Q?VgTG2D8OND7rgpmLpaAgWfgyxCwHQ2v1643xTgNbRESFbxrfnNf6Wsc1kND+?=
 =?us-ascii?Q?DuuYEYgEKLi84M3M8eSaCuSGYYm/q9s=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 264e9027-48ff-4450-ad4f-08de46cbe66d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR02MB7557.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2025 11:17:49.2646
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8/KbRBazdf4Mup2LfT9SP3k3j0RFc8TxdQXfDuVPHmkxuE21sQpZPUDMCzLD1hLAUC+6kpEg2bqA8bJfGetDfzfplJ8BucHT1pqaVVvuzhk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR02MB9965
X-Authority-Analysis: v=2.4 cv=MMptWcZl c=1 sm=1 tr=0 ts=6952635f cx=c_pps
 a=Y5OhYnybWnDos8loL9/x+g==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=pBOR-ozoAAAA:8 a=64Cc0HZtAAAA:8
 a=ZJXzLAxtXV6UqsjHDPUA:9
X-Proofpoint-GUID: Ht4ARm4LLHLCo0pvsDREii7O7uJfFak3
X-Proofpoint-ORIG-GUID: Ht4ARm4LLHLCo0pvsDREii7O7uJfFak3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjI5MDEwNSBTYWx0ZWRfX3WA84gj2Eg2D
 sDIs4bgDnTOCbqyOmj1uPr4W34J/KIDWUDHy6zWBEjYrUTO2Rr1B3DulOSMmSOD33Rh7gSe/bgh
 yiJbjuCirl1pnsC/I9GJFIVP8SPThA5U1L+OnmRtIQVdrgV6AwrX8Qcsxx+83OrtLCXNx9sfKfL
 XQTSUW1F2hpWMoqG3aXREdtbfQQMLHB5vPcR/T4HZVvb4TEskZdakcfbemfezaml5g6U8UKbSfJ
 QT+3Qjm9O+LsYgfuVobdSVekSV+HkzZ09eZetPx/lweS+u2HToglos92jXZaF2Kci3SxYIhjomD
 u05Z1nQwl59KaWxA7BYI22tIro3Z+aOtGzSDmaPb+uS5PDD1ZiwOqtpYwXCjwNLcCq8yqO64cVe
 GnjRADefwM4wr0sEtJWVE11nh3Ev9FJhCYQ5hMiNt3+IRUfbg6J2TGJyDzG1lWyd7wyJHELzH5U
 WJVJ11cMqwZLwddFlwA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-29_03,2025-12-29_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

From: David Woodhouse <dwmw@amazon.co.uk>

Introduce support for I/O APIC version 0x20, which includes the EOI
Register (EOIR) for directed EOI.  The EOI register allows guests to
perform EOIs to individual I/O APICs instead of relying on broadcast EOIs
from the local APIC.

When Suppress EOI Broadcast (SEOIB) capability is advertised to the guest,
guests that enable it will EOI individual I/O APICs by writing to their
EOI register instead of relying on broadcast EOIs from the LAPIC.  Hence,
when SEOIB is advertised (so that guests can use it if they choose), use
I/O APIC version 0x20 to provide the EOI register.  This prepares for a
userspace API that will allow explicit control of SEOIB support, providing
a consistent interface for both in-kernel and split IRQCHIP mode.

Add a tracepoint (kvm_ioapic_directed_eoi) to track directed EOIs for
debugging and observability.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 arch/x86/kvm/ioapic.c | 31 +++++++++++++++++++++++++++++--
 arch/x86/kvm/ioapic.h | 19 +++++++++++--------
 arch/x86/kvm/trace.h  | 17 +++++++++++++++++
 3 files changed, 57 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index 6bf8d110aece..eea1eb7845c4 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -48,8 +48,11 @@ static unsigned long ioapic_read_indirect(struct kvm_ioapic *ioapic)
 
 	switch (ioapic->ioregsel) {
 	case IOAPIC_REG_VERSION:
-		result = ((((IOAPIC_NUM_PINS - 1) & 0xff) << 16)
-			  | (IOAPIC_VERSION_ID & 0xff));
+		if (kvm_lapic_advertise_suppress_eoi_broadcast(ioapic->kvm))
+			result = IOAPIC_VERSION_ID_EOIR;
+		else
+			result = IOAPIC_VERSION_ID;
+		result |= ((IOAPIC_NUM_PINS - 1) & 0xff) << 16;
 		break;
 
 	case IOAPIC_REG_APIC_ID:
@@ -57,6 +60,10 @@ static unsigned long ioapic_read_indirect(struct kvm_ioapic *ioapic)
 		result = ((ioapic->id & 0xf) << 24);
 		break;
 
+	case IOAPIC_REG_BOOT_CONFIG:
+		result = 0x01; /* Processor bus */
+		break;
+
 	default:
 		{
 			u32 redir_index = (ioapic->ioregsel - 0x10) >> 1;
@@ -701,6 +708,26 @@ static int ioapic_mmio_write(struct kvm_vcpu *vcpu, struct kvm_io_device *this,
 		ioapic_write_indirect(ioapic, data);
 		break;
 
+	case IOAPIC_REG_EOIR:
+		/*
+		 * The EOI register is supported (and version 0x20 advertised)
+		 * when userspace explicitly enables suppress EOI broadcast.
+		 */
+		if (kvm_lapic_advertise_suppress_eoi_broadcast(vcpu->kvm)) {
+			u8 vector = data & 0xff;
+			int i;
+
+			trace_kvm_ioapic_directed_eoi(vcpu, vector);
+			rtc_irq_eoi(ioapic, vcpu, vector);
+			for (i = 0; i < IOAPIC_NUM_PINS; i++) {
+				union kvm_ioapic_redirect_entry *ent = &ioapic->redirtbl[i];
+
+				if (ent->fields.vector != vector)
+					continue;
+				kvm_ioapic_update_eoi_one(vcpu, ioapic, ent->fields.trig_mode, i);
+			}
+		}
+		break;
 	default:
 		break;
 	}
diff --git a/arch/x86/kvm/ioapic.h b/arch/x86/kvm/ioapic.h
index bf28dbc11ff6..f219577f738c 100644
--- a/arch/x86/kvm/ioapic.h
+++ b/arch/x86/kvm/ioapic.h
@@ -11,7 +11,8 @@ struct kvm_vcpu;
 
 #define IOAPIC_NUM_PINS  KVM_IOAPIC_NUM_PINS
 #define MAX_NR_RESERVED_IOAPIC_PINS KVM_MAX_IRQ_ROUTES
-#define IOAPIC_VERSION_ID 0x11	/* IOAPIC version */
+#define IOAPIC_VERSION_ID	0x11	/* Default IOAPIC version */
+#define IOAPIC_VERSION_ID_EOIR	0x20	/* IOAPIC version with EOIR support */
 #define IOAPIC_EDGE_TRIG  0
 #define IOAPIC_LEVEL_TRIG 1
 
@@ -19,13 +20,15 @@ struct kvm_vcpu;
 #define IOAPIC_MEM_LENGTH            0x100
 
 /* Direct registers. */
-#define IOAPIC_REG_SELECT  0x00
-#define IOAPIC_REG_WINDOW  0x10
-
-/* Indirect registers. */
-#define IOAPIC_REG_APIC_ID 0x00	/* x86 IOAPIC only */
-#define IOAPIC_REG_VERSION 0x01
-#define IOAPIC_REG_ARB_ID  0x02	/* x86 IOAPIC only */
+#define IOAPIC_REG_SELECT	0x00
+#define IOAPIC_REG_WINDOW	0x10
+#define IOAPIC_REG_EOIR	0x40	/* version 0x20+ only */
+
+/* INDIRECT registers. */
+#define IOAPIC_REG_APIC_ID	0x00	/* x86 IOAPIC only */
+#define IOAPIC_REG_VERSION	0x01
+#define IOAPIC_REG_ARB_ID	0x02	/* x86 IOAPIC only */
+#define IOAPIC_REG_BOOT_CONFIG	0x03	/* x86 IOAPIC only */
 
 /*ioapic delivery mode*/
 #define	IOAPIC_FIXED			0x0
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index e79bc9cb7162..6902758353a9 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -315,6 +315,23 @@ TRACE_EVENT(kvm_ioapic_delayed_eoi_inj,
 		  (__entry->e & (1<<15)) ? "level" : "edge",
 		  (__entry->e & (1<<16)) ? "|masked" : "")
 );
+
+TRACE_EVENT(kvm_ioapic_directed_eoi,
+	    TP_PROTO(struct kvm_vcpu *vcpu, u8 vector),
+	    TP_ARGS(vcpu, vector),
+
+	TP_STRUCT__entry(
+		__field(	__u32,		apicid		)
+		__field(	__u8,		vector		)
+	),
+
+	TP_fast_assign(
+		__entry->apicid		= vcpu->vcpu_id;
+		__entry->vector		= vector;
+	),
+
+	TP_printk("apicid %x vector %u", __entry->apicid, __entry->vector)
+);
 #endif
 
 TRACE_EVENT(kvm_msi_set_irq,
-- 
2.39.3


