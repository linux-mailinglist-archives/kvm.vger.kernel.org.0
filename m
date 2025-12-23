Return-Path: <kvm+bounces-66597-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id EF281CD81A8
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 06:09:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DB029304074E
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 05:06:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83769305E2E;
	Tue, 23 Dec 2025 05:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="G8yjCpcB";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="C2hUTamK"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACCD82FC00D;
	Tue, 23 Dec 2025 05:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766466310; cv=fail; b=K9EzKXpgpfvBxV9oHRxxRscP/TkiysbBX44a5cFfcYCcVz9wCbE+45dr0ddumx+uHfodZa8Cll9Z6MTh5RJ0kqFgUDXjejgreudefdCNw4UDXWQNOi8CMMJ0vp2zGKdPZN2tRVu8zSJbWHsWt+3quzDExU9jBfZtlO1OcHI6NLM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766466310; c=relaxed/simple;
	bh=ibHmwe41Eh8fglQmhBlVl0xyKQyXcxuhQBA1NMJYQNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BZQ9/7fRORR9EudhPqVqieMsCmOnBBSp5g4p2ebaqgoRgykme3NkbpbZsPIXmEFuEArWYOs/mZk/NkCxaCMnhmN4qpR7Uab8Su1h+fk5CeUiyPkcyXBNZY/YTltH1KV4UpF7Tue2H6Hji//bXl+TeZt/4c8A37WkOa8Eqy76NuA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=G8yjCpcB; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=C2hUTamK; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BMHGVFw3289032;
	Mon, 22 Dec 2025 21:04:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=9sF+ujTX+NXuIvDRdr1YK2SSYXR5LfkAZUBtnFaZX
	v8=; b=G8yjCpcB6Kp+uZKOPnqlAKUdT1bagOU9cpN5MukFaVGEfmTXxue6booD2
	QQr2seZtXlgBGtzABcwLYmUgZXbZPNSNMkpWXY02ChO3Ndldp6vw/kqnFHeslx4v
	sAAeGOhW7aaU/4U/AW8CkSUIOlkOXWUgvnDpt7htE6/4s3NccXldQZo+oXQ9Zr54
	Ioid5a7Rl5Q8Z1+kjC+Rzij0IIIdGmPJQJNYejNVt5fDFs17VBvMqPEsAMQEMPlq
	wxcj9SMFZI97DLRA5VQZXzrEqmlDNpZ5UQ/fTWu7wbWTgv3Npood72F/yYMcGKe1
	nhzgBQ2sACTmzQLSR2jwKKuDbW4GQ==
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11021123.outbound.protection.outlook.com [40.93.194.123])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4b5tsjmwuv-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 21:04:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IIMZPnLkVUDJmYVPUXtiteT0RYBlNo1SoMwSE0f2Yi8bzAnPdhsjxqRs8lCW73RnrWJikE7V56ENrvf0mhu0C7AbFSKN9YWPR8+9Q3RMQHpUhMHoPPgwZl++6RMtEt/cUNMtt7Q1lAzMRPdIEI3xHJMKf7C71IssoVQrj4TQmHvDxybjfaqcY08+ClOiDQJx3vL9ue5DSxtxCVXjkh5DqkdbnfaXMB6PVG1ae9QSEz3E6rwtpz6kj13iPFjT0Ce4oblwNzD2pnkFpP0qbTkU4aEAzPq0q3i5SCfkgh6WUdYIwGag23QEUhBJEdeanQtZNcp0BfOm0vHqQyXfgGnLEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9sF+ujTX+NXuIvDRdr1YK2SSYXR5LfkAZUBtnFaZXv8=;
 b=QgaEXMDNvyJBZHPH7UgV3ZNnGnLUu9BSqfBvGpiPS1InMqnYICPwwpUiyks3O+9HjFSmOE+Q61ixHnBKZokU3dFWaT1boaHkHTiTcD5IfII9I6YOLvlYr3DyE/YQ5rx2hisz6KyJPJ3B7+5Pd0MuMgoO3JPpNaR1lQAAwRpIL1BYGW7AM01oEGu+FoiA/7ZRubpZx1OwY16YG54VM5PaIVwNpcAL4Q9jWoixSPZOWNJYDPebxMTZyOMnfA/dz0Z40xeDoYng94UzrVvfjY2PUsChe5znnde79xPs7Y10rClRshYaHHCsDdCr72ghUurcRmU/BWgKAOgkhZtb+HmcoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9sF+ujTX+NXuIvDRdr1YK2SSYXR5LfkAZUBtnFaZXv8=;
 b=C2hUTamKR4Jmx4UJNnlQo6lV2jjEUkQE0tP4dXDUdXBmhztHjZ/mvrM3fK5cPsaziGGCMbT57DdplBAEAjut/Bvf4APF88mZoEosYjszFR/7CERwyKz6+jMENX4ti0vpuLUJc4liQh+QEwbyFr+Zy0jnPrcIwbJb3EYtqqKzOsKMxWeAOZ4i/MkMQFl9ZqotfuEtnZSVHhLJcsz0E75b4bEp0vvphyAQPIxMOlQkaVViW5GaKZq+s2Y0HRvOK+sNxG50kQ2zJNACQg84+YSwQciCtWOtFeTgoEB2710a/jMpd6oVEAVH90xgXm/el4DGrzoVJma8L/taOIVtKY/O7g==
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18) by SA1PR02MB8560.namprd02.prod.outlook.com
 (2603:10b6:806:1fb::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.11; Tue, 23 Dec
 2025 05:04:33 +0000
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc]) by LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc%4]) with mapi id 15.20.9434.009; Tue, 23 Dec 2025
 05:04:33 +0000
From: Jon Kohler <jon@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Jon Kohler <jon@nutanix.com>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION)
Cc: ken@codelabs.ch, Alexander.Grest@microsoft.com, chao.gao@intel.com,
        madvenka@linux.microsoft.com, mic@digikod.net, nsaenz@amazon.es,
        tao1.su@linux.intel.com, xiaoyao.li@intel.com, zhao1.liu@intel.com
Subject: [PATCH 5/8] KVM: x86/mmu: bootstrap support for Intel MBEC
Date: Mon, 22 Dec 2025 22:47:58 -0700
Message-ID: <20251223054806.1611168-6-jon@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: 2f6bb9cc-f676-4339-b42e-08de41e0c2c2
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|1800799024|376014|7416014|366016|921020|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OOjPqAz55I9aTMarVbBN0rIvhNIYgav0lNkbJousTXSLrTtjcqhnsm4kTOix?=
 =?us-ascii?Q?RUq0dWdB2/onqoWuFKWPJNwEqK6OrRRCqyZIvVrD6/WbFKjreaQqtvauIaYT?=
 =?us-ascii?Q?Un1ioYu+Cw4hTeQYmD7Y+uRMAQ1n1NBu5p1g57sXvnCMUxDp1Q83DEefDR6H?=
 =?us-ascii?Q?ZLBcSX86r3q7pc2rjwBrv9nMx4bQ99eqY2CGG50jU9mPyL7bFMfMytBPLeSB?=
 =?us-ascii?Q?IZ8Z3+Z709mwfKSLV/t6CjS196leBJzFhhnD0L6Ma46OxOhiQKd0t6oOyNOs?=
 =?us-ascii?Q?oRo+EE2aAbQtsnEcUXlX1lNeNcyOJ2aBAI3rR6wYPpl7OuxooRW5rHgYKM+a?=
 =?us-ascii?Q?hrLvmWcZ/FOLblyKVzj2FyT8a7s/Pl2qivNO33uFLZWoUvmbD6UbzB3sgncX?=
 =?us-ascii?Q?h1VnXfhPoXKYs6kR5YuUXfXOJ/gyuVjk5Q+cOMeY+1UNkS0isy49i967avqR?=
 =?us-ascii?Q?6d3A/Y/ZDp+IywemPefbes+Z/naTaqcAVmvXpsOXGgPGZkIQvSAVOoXDlSZO?=
 =?us-ascii?Q?eknGBjv1orJVP41TERrs7DKUPYywqGcC/tYZhhihmdT4eC0mEtZOtp5yF86x?=
 =?us-ascii?Q?gyPD3RpoRLQ61urQE1wr2o8Rw0VqmeSvSSfgZdpfrz4/fGdtYsdq+JvvNUxT?=
 =?us-ascii?Q?jRVxupB5XNggSl3Nxw2iI4aczJNm3OEoODtLmTK8x4taltZh8mywksxTp+C3?=
 =?us-ascii?Q?ut0jNyy5nKocmjDUqZd6y0vHoAjxEefHbAD1UcDaPnCBy4ef1kNk2BLPoZTq?=
 =?us-ascii?Q?8AkyzRcPU4XxkxOHShu6Ql6n8OWJqpl+haDgx8UVRpZbgR8nBjCrqRLsVgct?=
 =?us-ascii?Q?Q59gZw4f4HbUIX3BSgqgSZ917u5IS4vf+Flvy0iAhLmd6QtFxuM21nLorlWt?=
 =?us-ascii?Q?rJlAJ52jcqKBhWaoGUBLDvcq0YOAT4w/qjTbum8R1eMkbyzSkPMUgP8oE4o5?=
 =?us-ascii?Q?0+HEmXk6beG5e3/E6w6YhmEtlBNxH1VqawVd/IsmWKDWtM0dN8bbA2VMwCcg?=
 =?us-ascii?Q?wr92v7Go6WGu4bUaSQKhVtysAAORKIbpxCxiCrkH9eWjO9xiUGu9N1hKQlyW?=
 =?us-ascii?Q?eLZeTaNlaROVhe6AFRT/X9jtMt8tRF1KrneQrUBRsLd8FuMSkHX+wwcYfS0N?=
 =?us-ascii?Q?vHUywDgAxjN1xf1Vv+svWmgSfIgXP3YPKFPz0L85CEiit0dut1ld1zBF+MZX?=
 =?us-ascii?Q?RGaftFS8+wca+3uXWnmVyMSOsnSMbP3xjFW++n+LuM4Qo0RRupxNOuDdnCa7?=
 =?us-ascii?Q?62xAsVKqQ0iyqckAHG/QE37X+cmqfQZEUKdDRHNHoTPOf5J192G8g5UzUsUz?=
 =?us-ascii?Q?A+0qVTwKyyhWx1ZlJJ77mT9kHS+2fBay0KI65S6JVXEJDG7YjN2r3VTHVpG+?=
 =?us-ascii?Q?Px+qOTkOXjsY1DY07wmBkCc/PzrLaVLBWh7zcjCRbInUJKwYUaXm39CiV74a?=
 =?us-ascii?Q?DwJ7J+kYhFumCj7AnzGyYa6pMIMEsYOyQNNYzUspoUKEd5vJT8WHzs47n4TJ?=
 =?us-ascii?Q?GUGB2+GolP6jdi90VuJZSfSfm6fVCoW6KU08doAIIL9EP6Oht0u1/eARIg?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0PR02MB11133.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(1800799024)(376014)(7416014)(366016)(921020)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ov687WUAeWaJBZ5EKRfJvnzBau+cOKGCXNDylofLQnjWu+whz0hXWzV3EfFy?=
 =?us-ascii?Q?yeLalXRUqmaaiCIn4laI2ogRaztqv8pQijwf9bqfC6tcZtf9ztWqDxagF0/i?=
 =?us-ascii?Q?DjR48WPqoofDaCJnKzxF8BEmUsbfUFHjpUMaP7nn9U/mzMgP6s3jEY7L/C4+?=
 =?us-ascii?Q?ylBLb+9Nm/moMKVwKI7tVZII8lhbaNQ285jaaGOydpELmOXCnPumn770eKny?=
 =?us-ascii?Q?FJl6nY2sqjy7MJ7L5cOujM1JgJjvFTJRC2u+nf3Nh8MWVK26PAohNuZwfxVD?=
 =?us-ascii?Q?Hq4n1PNznYamXlnMaLsdMMrAKunHuOLnWBHIYPu++th0FUar4IzuRImFGxAk?=
 =?us-ascii?Q?NIt9ZiliAIo5ez7ArRmkDvziEbKcjTzZbzwmF7bvQQPeI2JBHTjj0wciJ1t+?=
 =?us-ascii?Q?0KTUMnmMljGeb2AnqSMlYmVEYNynXTJTugjzlnnM07JrDhCUnWyt1GLmTS1u?=
 =?us-ascii?Q?GBVZgLZFfKe0BlIp/6UkgR1DuK8/hB+xej9i1GUMvO1ihK0/hZGdpriDIbgC?=
 =?us-ascii?Q?k66x9cwrDBMhUg7mi71sgBvz/4x4Duu/V6DkgrIim8k8CmFOEZ9goqG4o7i0?=
 =?us-ascii?Q?tAsJJwz5FAZmRuCf73k1Sm5zFXZfQ1aJcG0kLMF9U/TnUjvLka3LS9MZ3xaq?=
 =?us-ascii?Q?ahJizcfpl5ZhvswD0qDDm65nJqV3caC7YvrJAJZfLpHsaXi8kJ4zoTOoOXxn?=
 =?us-ascii?Q?OPlf4d5GwBsGbesOOHTHrp4+Zj3VY88cFaMT6/v7u4YzNmn87JDN/VA74PuE?=
 =?us-ascii?Q?QYxlLbWIcIMclzrYVaKVyQ0XaUp25pWRBFcKYxllkCfsQgkqJ+ej7jv7OEPm?=
 =?us-ascii?Q?lozkXeutLIDzrawwYGA7TZohO+3bFQSWblPv6uokNQndVGiuxSa0xxaMuaPR?=
 =?us-ascii?Q?+Z1EYVKttS0MaR/VYxxhi+9f94j/tJYgmmfHoyJbmXoW1rBD/dm++p8Ea0s5?=
 =?us-ascii?Q?pVER7peG+p/d0dhe05m7qocoqXLlZvyJlWQyp5ltShFlgi5stOzvr27Xu8P+?=
 =?us-ascii?Q?26Dc1aGr1IPFGL70nJ56YBNdwtDWRH4o/0DtcTehZguAEcNqY4IFLl3pNnVF?=
 =?us-ascii?Q?32Z1+HwFE9oF6WKoTglOgLFuujCtmLGEWxi/uZCoQkbH3T22xmGM1eDZJO5Y?=
 =?us-ascii?Q?Mk01mliKYTqzppc9NIRgCau+QboNNjc8XPztKIWORpR/8hxqjs7L7dpcBIHV?=
 =?us-ascii?Q?w5gE9WDQ6T/MlMzz0uFLPR90FKsZZsREdv5w9X8A2puwCfJrwazX0dmVmJqU?=
 =?us-ascii?Q?WkVmcV0Nw6FyFNmohGB3/wQ9bTiek2oZISmjh1yHXlJyy1aCysCotQTGSh6/?=
 =?us-ascii?Q?OEBEskI6RAM/aMtocfuGLc98MpKOokvBveAmgt85/wTGsvRySiUQJib7k3vh?=
 =?us-ascii?Q?qFNHCO0U2yBMTf5Td1YXvPmNDSlE6CTt0AD9mgaQXJyKQwA6DALmeQprfdu/?=
 =?us-ascii?Q?yMtWscNBuZjim624SYmia4W80VMNYT0AoE0ct+OhoGC+UfntJHImay0dor9N?=
 =?us-ascii?Q?txhZqvn1J8+CovD1qcY1wn7vESw1a2hyPYacS8ttVckCzU5ocAtgGyQzjugT?=
 =?us-ascii?Q?TgvgcfyXBl3yN3bhfkl8gh6Ap0/i5/rrxkHys6A/sC5Lv4uhjG43oOeCppe0?=
 =?us-ascii?Q?sjaagEljZhr854sYf1X+Ldq+J2j1qvVqIRqFSXKcg6Bt+glxZPGHLTsG9mHd?=
 =?us-ascii?Q?mom24GylQ80h04XUN/6NBtaIyFpmfTolZQbj5/VJ0nCGWnQfgR+kVY2m67aI?=
 =?us-ascii?Q?+A8urE6w4Px+Cf7nDaYfwAeZrnmXcJU=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f6bb9cc-f676-4339-b42e-08de41e0c2c2
X-MS-Exchange-CrossTenant-AuthSource: LV0PR02MB11133.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2025 05:04:33.0009
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p3L0e84+g2+zpefz//Ci/LQVQhdibtYDtGaflaOTRnjZRwj0HnBLM04RZQ5c9ui8vkPvSGU9XZF4rWsHvN+jbgwMwW16YWG085Va9u1I+Ss=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR02MB8560
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIzMDA0MCBTYWx0ZWRfX4Nxi3U0RfwG/
 hx7K+S/2ZaRRyj3xuo3u0Fg/i6Q1JnmlpY8dt3bZzPqg+8UKwad4LSnbLqccLSWBDHpIvVM77aG
 gdOEzWGZ6kfFobbldy97YuKQleeJWliM3ePQr/VlVm75DwBQKSOz5kCxrn04AlxJclShsAN3drD
 3UMAb5/DRhJSxHywVxowA+hqAkTCDMWhBkxZQ8x+myQmIa+DsE35ztPRFrVYbs83ogF3jQ1bN6s
 sQgZgbSSqQUeOTIl/oleUT/Dx7SyZDUrrnm9swiNHhkaGeA9zrUyr9dXbq4Mxi6gia8L53xSYni
 86gBESbdssUSCENdi9KXkwsCp1mUYJKZ1FXDeAMkeltH6quslhpjhVSbPrLie+nJzT2sEZgyFM/
 VD1E+xEJKHTex7ckH0l01cpmRwrNjxdINb0uFb6WJhp5zvvVLvumIy7XJAhjiVwrF2CW6k+DuX+
 /x+sveEWCgZSFRH+DFw==
X-Proofpoint-GUID: ho4k8jiSIOMMNXZdpIhaQxnSHSNWKpuN
X-Proofpoint-ORIG-GUID: ho4k8jiSIOMMNXZdpIhaQxnSHSNWKpuN
X-Authority-Analysis: v=2.4 cv=Xr73+FF9 c=1 sm=1 tr=0 ts=694a22e2 cx=c_pps
 a=1pmWRJemPF16E+bttNzokw==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=64Cc0HZtAAAA:8 a=v587mRpB5INqV5_a_pwA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-23_01,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Extend kvm_mmu_page_role access bitfield from 3 to 4, where the 4th bit
will be used to track user executable pages with Intel mode-based
execute control (MBEC).

Extend SPTE generation and introduce shadow_ux value to account for
user and kernel executable distinctions under MBEC.

Extend kvm_mmu_page_role to include a new has_mbec field, such that a
given MMU's can be flagged as one with MBEC-awareness, which is to say
with an access bitfield that can evaluate to 4 different options.

Modified various functions to utilize the new access masks, ensuring
compatibility with MBEC.

Update mmu documentation to clarify the role of execute permissions when
MBEC is enabled.

Add capability helper for cpu_has_vmx_mode_based_ept_exec and plumb
into kvm_mmu_set_ept_masks.

NOTE: Also roll back change to ACC_ALL vs ACC_RWX in mmu.c, as VM's do
not boot properly, which likely need to be reworked, open to ideas!

Past that, no functional change intended, as nothing sets has_mbec yet.

Signed-off-by: Jon Kohler <jon@nutanix.com>
---
 Documentation/virt/kvm/x86/mmu.rst |  9 ++++-
 arch/x86/include/asm/kvm_host.h    | 11 ++---
 arch/x86/include/asm/vmx.h         |  4 ++
 arch/x86/kvm/mmu.h                 |  8 +++-
 arch/x86/kvm/mmu/mmu.c             | 24 +++++------
 arch/x86/kvm/mmu/mmutrace.h        | 23 +++++++----
 arch/x86/kvm/mmu/paging_tmpl.h     | 24 +++++++----
 arch/x86/kvm/mmu/spte.c            | 65 +++++++++++++++++++++++-------
 arch/x86/kvm/mmu/spte.h            | 57 +++++++++++++++++++++++---
 arch/x86/kvm/mmu/tdp_mmu.c         | 12 ++++--
 arch/x86/kvm/vmx/capabilities.h    |  6 +++
 arch/x86/kvm/vmx/vmx.c             |  3 +-
 12 files changed, 188 insertions(+), 58 deletions(-)

diff --git a/Documentation/virt/kvm/x86/mmu.rst b/Documentation/virt/kvm/x86/mmu.rst
index 2b3b6d442302..f63db1a2b3df 100644
--- a/Documentation/virt/kvm/x86/mmu.rst
+++ b/Documentation/virt/kvm/x86/mmu.rst
@@ -172,7 +172,14 @@ Shadow pages contain the following information:
     quadrant maps 1GB virtual address space.
   role.access:
     Inherited guest access permissions from the parent ptes in the form uwx.
-    Note execute permission is positive, not negative.
+    Note execute permission is positive, not negative. When Intel MBEC is
+    not enabled, permissions follow the uwx form. When Intel MBEC is enabled,
+    execute is split into two permissions, kernel executable and user
+    executable, with the split controlled by role.has_mbec.
+  role.has_mbec:
+    When role.has_mbec=1, Intel mode-based execute control is active, which
+    gives the guest the ability to split execute pages into two permissions,
+    kernel executable and user executable.
   role.invalid:
     The page is invalid and should not be used.  It is a root page that is
     currently pinned (by a cpu hardware register pointing to it); once it is
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 48598d017d6f..66afcff43ec5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -319,11 +319,11 @@ struct kvm_kernel_irq_routing_entry;
  * the number of unique SPs that can theoretically be created is 2^n, where n
  * is the number of bits that are used to compute the role.
  *
- * But, even though there are 20 bits in the mask below, not all combinations
+ * But, even though there are 22 bits in the mask below, not all combinations
  * of modes and flags are possible:
  *
  *   - invalid shadow pages are not accounted, mirror pages are not shadowed,
- *     so the bits are effectively 18.
+ *     so the bits are effectively 20.
  *
  *   - quadrant will only be used if has_4_byte_gpte=1 (non-PAE paging);
  *     execonly and ad_disabled are only used for nested EPT which has
@@ -338,7 +338,7 @@ struct kvm_kernel_irq_routing_entry;
  *     cr0_wp=0, therefore these three bits only give rise to 5 possibilities.
  *
  * Therefore, the maximum number of possible upper-level shadow pages for a
- * single gfn is a bit less than 2^13.
+ * single gfn is a bit less than 2^15.
  */
 union kvm_mmu_page_role {
 	u32 word;
@@ -347,7 +347,7 @@ union kvm_mmu_page_role {
 		unsigned has_4_byte_gpte:1;
 		unsigned quadrant:2;
 		unsigned direct:1;
-		unsigned access:3;
+		unsigned access:4;
 		unsigned invalid:1;
 		unsigned efer_nx:1;
 		unsigned cr0_wp:1;
@@ -357,7 +357,8 @@ union kvm_mmu_page_role {
 		unsigned guest_mode:1;
 		unsigned passthrough:1;
 		unsigned is_mirror:1;
-		unsigned :4;
+		unsigned has_mbec:1;
+		unsigned:2;
 
 		/*
 		 * This is left at the top of the word so that
diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index de3abec84fe5..9a98c063148c 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -547,6 +547,7 @@ enum vmcs_field {
 #define VMX_EPT_IPAT_BIT    			(1ull << 6)
 #define VMX_EPT_ACCESS_BIT			(1ull << 8)
 #define VMX_EPT_DIRTY_BIT			(1ull << 9)
+#define VMX_EPT_USER_EXECUTABLE_MASK		(1ull << 10)
 #define VMX_EPT_SUPPRESS_VE_BIT			(1ull << 63)
 #define VMX_EPT_RWX_MASK                        (VMX_EPT_READABLE_MASK |       \
 						 VMX_EPT_WRITABLE_MASK |       \
@@ -605,9 +606,12 @@ enum vm_entry_failure_code {
 #define EPT_VIOLATION_GVA_TRANSLATED	BIT(8)
 
 #define EPT_VIOLATION_RWX_TO_PROT(__epte) (((__epte) & VMX_EPT_RWX_MASK) << 3)
+#define EPT_VIOLATION_USER_EXEC_TO_PROT(__epte) (((__epte) & VMX_EPT_USER_EXECUTABLE_MASK) >> 4)
 
 static_assert(EPT_VIOLATION_RWX_TO_PROT(VMX_EPT_RWX_MASK) ==
 	      (EPT_VIOLATION_PROT_READ | EPT_VIOLATION_PROT_WRITE | EPT_VIOLATION_PROT_EXEC));
+static_assert(EPT_VIOLATION_USER_EXEC_TO_PROT(VMX_EPT_USER_EXECUTABLE_MASK) ==
+	      (EPT_VIOLATION_PROT_USER_EXEC));
 
 /*
  * Exit Qualifications for NOTIFY VM EXIT
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index f63074048ec6..558a15ff82e6 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -81,7 +81,8 @@ u8 kvm_mmu_get_max_tdp_level(void);
 void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask);
 void kvm_mmu_set_mmio_spte_value(struct kvm *kvm, u64 mmio_value);
 void kvm_mmu_set_me_spte_mask(u64 me_value, u64 me_mask);
-void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only);
+void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only,
+			   bool has_mbec);
 
 void kvm_init_mmu(struct kvm_vcpu *vcpu);
 void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
@@ -174,6 +175,11 @@ static inline void kvm_mmu_refresh_passthrough_bits(struct kvm_vcpu *vcpu,
 	__kvm_mmu_refresh_passthrough_bits(vcpu, mmu);
 }
 
+static inline bool mmu_has_mbec(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.mmu->root_role.has_mbec;
+}
+
 /*
  * Check if a given access (described through the I/D, W/R and U/S bits of a
  * page fault error code pfec) causes a permission fault with the given PTE
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b1a7c7cc0c44..b0eb8d4c5ef2 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2033,7 +2033,7 @@ static bool kvm_sync_page_check(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 	 */
 	const union kvm_mmu_page_role sync_role_ign = {
 		.level = 0xf,
-		.access = 0x7,
+		.access = 0xf,
 		.quadrant = 0x3,
 		.passthrough = 0x1,
 	};
@@ -3080,7 +3080,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 		ret = RET_PF_SPURIOUS;
 	} else {
 		flush |= mmu_spte_update(sptep, spte);
-		trace_kvm_mmu_set_spte(level, gfn, sptep);
+		trace_kvm_mmu_set_spte(vcpu, level, gfn, sptep);
 	}
 
 	if (wrprot && write_fault)
@@ -3452,7 +3452,7 @@ static int direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		if (it.level == fault->goal_level)
 			break;
 
-		sp = kvm_mmu_get_child_sp(vcpu, it.sptep, base_gfn, true, ACC_RWX);
+		sp = kvm_mmu_get_child_sp(vcpu, it.sptep, base_gfn, true, ACC_ALL);
 		if (sp == ERR_PTR(-EEXIST))
 			continue;
 
@@ -3465,7 +3465,7 @@ static int direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	if (WARN_ON_ONCE(it.level != fault->goal_level))
 		return -EFAULT;
 
-	ret = mmu_set_spte(vcpu, fault->slot, it.sptep, ACC_RWX,
+	ret = mmu_set_spte(vcpu, fault->slot, it.sptep, ACC_ALL,
 			   base_gfn, fault->pfn, fault);
 	if (ret == RET_PF_SPURIOUS)
 		return ret;
@@ -3698,9 +3698,9 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		 * current CPU took the fault.
 		 *
 		 * Need not check the access of upper level table entries since
-		 * they are always ACC_RWX.
+		 * they are always ACC_ALL.
 		 */
-		if (is_access_allowed(fault, spte)) {
+		if (is_access_allowed(fault, spte, vcpu)) {
 			ret = RET_PF_SPURIOUS;
 			break;
 		}
@@ -3748,7 +3748,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 
 		/* Verify that the fault can be handled in the fast path */
 		if (new_spte == spte ||
-		    !is_access_allowed(fault, new_spte))
+		    !is_access_allowed(fault, new_spte, vcpu))
 			break;
 
 		/*
@@ -4804,7 +4804,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	if (r)
 		return r;
 
-	r = kvm_mmu_faultin_pfn(vcpu, fault, ACC_RWX);
+	r = kvm_mmu_faultin_pfn(vcpu, fault, ACC_ALL);
 	if (r != RET_PF_CONTINUE)
 		return r;
 
@@ -4895,7 +4895,7 @@ static int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu,
 	if (r)
 		return r;
 
-	r = kvm_mmu_faultin_pfn(vcpu, fault, ACC_RWX);
+	r = kvm_mmu_faultin_pfn(vcpu, fault, ACC_ALL);
 	if (r != RET_PF_CONTINUE)
 		return r;
 
@@ -5614,7 +5614,7 @@ static union kvm_cpu_role kvm_calc_cpu_role(struct kvm_vcpu *vcpu,
 {
 	union kvm_cpu_role role = {0};
 
-	role.base.access = ACC_RWX;
+	role.base.access = ACC_ALL;
 	role.base.smm = is_smm(vcpu);
 	role.base.guest_mode = is_guest_mode(vcpu);
 	role.ext.valid = 1;
@@ -5695,7 +5695,7 @@ kvm_calc_tdp_mmu_root_page_role(struct kvm_vcpu *vcpu,
 {
 	union kvm_mmu_page_role role = {0};
 
-	role.access = ACC_RWX;
+	role.access = ACC_ALL;
 	role.cr0_wp = true;
 	role.efer_nx = true;
 	role.smm = cpu_role.base.smm;
@@ -5826,7 +5826,7 @@ kvm_calc_shadow_ept_root_page_role(struct kvm_vcpu *vcpu, bool accessed_dirty,
 	role.base.direct = false;
 	role.base.ad_disabled = !accessed_dirty;
 	role.base.guest_mode = true;
-	role.base.access = ACC_RWX;
+	role.base.access = ACC_ALL;
 
 	role.ext.word = 0;
 	role.ext.execonly = execonly;
diff --git a/arch/x86/kvm/mmu/mmutrace.h b/arch/x86/kvm/mmu/mmutrace.h
index 764e3015d021..74d51370422a 100644
--- a/arch/x86/kvm/mmu/mmutrace.h
+++ b/arch/x86/kvm/mmu/mmutrace.h
@@ -22,10 +22,16 @@
 	__entry->root_count = sp->root_count;		\
 	__entry->unsync = sp->unsync;
 
+/*
+ * X == ACC_EXEC_MASK: executable without guest_exec_control and only
+ *                     supervisor execute with guest exec control
+ * x == ACC_USER_EXEC_MASK: user execute with guest exec control
+ */
 #define KVM_MMU_PAGE_PRINTK() ({				        \
 	const char *saved_ptr = trace_seq_buffer_ptr(p);		\
 	static const char *access_str[] = {			        \
-		"---", "--x", "w--", "w-x", "-u-", "-ux", "wu-", "wux"  \
+		"----", "---X", "-w--", "-w-X", "--u-", "--uX", "-wu-", "-wuX", \
+		"x---", "x--X", "xw--", "xw-X", "x-u-", "x-uX", "xwu-", "xwuX"	\
 	};							        \
 	union kvm_mmu_page_role role;				        \
 								        \
@@ -336,8 +342,8 @@ TRACE_EVENT(
 
 TRACE_EVENT(
 	kvm_mmu_set_spte,
-	TP_PROTO(int level, gfn_t gfn, u64 *sptep),
-	TP_ARGS(level, gfn, sptep),
+	TP_PROTO(struct kvm_vcpu *vcpu, int level, gfn_t gfn, u64 *sptep),
+	TP_ARGS(vcpu, level, gfn, sptep),
 
 	TP_STRUCT__entry(
 		__field(u64, gfn)
@@ -346,7 +352,8 @@ TRACE_EVENT(
 		__field(u8, level)
 		/* These depend on page entry type, so compute them now.  */
 		__field(bool, r)
-		__field(bool, x)
+		__field(bool, kx)
+		__field(bool, ux)
 		__field(signed char, u)
 	),
 
@@ -356,15 +363,17 @@ TRACE_EVENT(
 		__entry->sptep = virt_to_phys(sptep);
 		__entry->level = level;
 		__entry->r = shadow_present_mask || (__entry->spte & PT_PRESENT_MASK);
-		__entry->x = is_executable_pte(__entry->spte);
+		__entry->kx = is_executable_pte(__entry->spte, false, vcpu);
+		__entry->ux = is_executable_pte(__entry->spte, true, vcpu);
 		__entry->u = shadow_user_mask ? !!(__entry->spte & shadow_user_mask) : -1;
 	),
 
-	TP_printk("gfn %llx spte %llx (%s%s%s%s) level %d at %llx",
+	TP_printk("gfn %llx spte %llx (%s%s%s%s%s) level %d at %llx",
 		  __entry->gfn, __entry->spte,
 		  __entry->r ? "r" : "-",
 		  __entry->spte & PT_WRITABLE_MASK ? "w" : "-",
-		  __entry->x ? "x" : "-",
+		  __entry->kx ? "X" : "-",
+		  __entry->ux ? "x" : "-",
 		  __entry->u == -1 ? "" : (__entry->u ? "u" : "-"),
 		  __entry->level, __entry->sptep
 	)
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index ed762bb4b007..664b424108ed 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -124,12 +124,17 @@ static inline void FNAME(protect_clean_gpte)(struct kvm_mmu *mmu, unsigned *acce
 	*access &= mask;
 }
 
-static inline int FNAME(is_present_gpte)(unsigned long pte)
+static inline int FNAME(is_present_gpte)(struct kvm_vcpu *vcpu,
+					 unsigned long pte)
 {
 #if PTTYPE != PTTYPE_EPT
 	return pte & PT_PRESENT_MASK;
 #else
-	return pte & 7;
+	/*
+	 * For EPT, an entry is present if any of bits 2:0 are set.
+	 * With mode-based execute control, bit 10 also indicates presence.
+	 */
+	return (pte & 7) || (mmu_has_mbec(vcpu) && (pte & (1ULL << 10)));
 #endif
 }
 
@@ -152,7 +157,7 @@ static bool FNAME(prefetch_invalid_gpte)(struct kvm_vcpu *vcpu,
 				  struct kvm_mmu_page *sp, u64 *spte,
 				  u64 gpte)
 {
-	if (!FNAME(is_present_gpte)(gpte))
+	if (!FNAME(is_present_gpte)(vcpu, gpte))
 		goto no_present;
 
 	/* Prefetch only accessed entries (unless A/D bits are disabled). */
@@ -181,8 +186,9 @@ static inline unsigned FNAME(gpte_access)(u64 gpte)
 	unsigned access;
 #if PTTYPE == PTTYPE_EPT
 	access = ((gpte & VMX_EPT_WRITABLE_MASK) ? ACC_WRITE_MASK : 0) |
-		((gpte & VMX_EPT_EXECUTABLE_MASK) ? ACC_EXEC_MASK : 0) |
-		((gpte & VMX_EPT_READABLE_MASK) ? ACC_USER_MASK : 0);
+		 ((gpte & VMX_EPT_EXECUTABLE_MASK) ? ACC_EXEC_MASK : 0) |
+		 ((gpte & VMX_EPT_USER_EXECUTABLE_MASK) ? ACC_USER_EXEC_MASK : 0) |
+		 ((gpte & VMX_EPT_READABLE_MASK) ? ACC_USER_MASK : 0);
 #else
 	BUILD_BUG_ON(ACC_EXEC_MASK != PT_PRESENT_MASK);
 	BUILD_BUG_ON(ACC_EXEC_MASK != 1);
@@ -332,7 +338,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	if (walker->level == PT32E_ROOT_LEVEL) {
 		pte = mmu->get_pdptr(vcpu, (addr >> 30) & 3);
 		trace_kvm_mmu_paging_element(pte, walker->level);
-		if (!FNAME(is_present_gpte)(pte))
+		if (!FNAME(is_present_gpte)(vcpu, pte))
 			goto error;
 		--walker->level;
 	}
@@ -414,7 +420,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 		 */
 		pte_access = pt_access & (pte ^ walk_nx_mask);
 
-		if (unlikely(!FNAME(is_present_gpte)(pte)))
+		if (unlikely(!FNAME(is_present_gpte)(vcpu, pte)))
 			goto error;
 
 		if (unlikely(FNAME(is_rsvd_bits_set)(mmu, pte, walker->level))) {
@@ -493,6 +499,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	 *         out of date if it is serving an EPT misconfiguration.
 	 * [5:3] - Calculated by the page walk of the guest EPT page tables
 	 * [7:8] - Derived from [7:8] of real exit_qualification
+	 * [10]  - Derived from real exit_qualification, useful only with MBEC.
 	 *
 	 * The other bits are set to 0.
 	 */
@@ -511,6 +518,9 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 		 * ACC_*_MASK flags!
 		 */
 		walker->fault.exit_qualification |= EPT_VIOLATION_RWX_TO_PROT(pte_access);
+		if (mmu_has_mbec(vcpu))
+			walker->fault.exit_qualification |=
+				EPT_VIOLATION_USER_EXEC_TO_PROT(pte_access);
 	}
 #endif
 	walker->fault.address = addr;
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 37647afde7d3..a4720eedcacb 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -30,6 +30,7 @@ u64 __read_mostly shadow_host_writable_mask;
 u64 __read_mostly shadow_mmu_writable_mask;
 u64 __read_mostly shadow_nx_mask;
 u64 __read_mostly shadow_x_mask; /* mutual exclusive with nx_mask */
+u64 __read_mostly shadow_ux_mask;
 u64 __read_mostly shadow_user_mask;
 u64 __read_mostly shadow_accessed_mask;
 u64 __read_mostly shadow_dirty_mask;
@@ -223,19 +224,38 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	 * would tie make_spte() further to vCPU/MMU state, and add complexity
 	 * just to optimize a mode that is anything but performance critical.
 	 */
-	if (level > PG_LEVEL_4K && (pte_access & ACC_EXEC_MASK) &&
+	if (level > PG_LEVEL_4K &&
+	    (pte_access & (ACC_EXEC_MASK | ACC_USER_EXEC_MASK)) &&
 	    is_nx_huge_page_enabled(vcpu->kvm)) {
 		pte_access &= ~ACC_EXEC_MASK;
+		if (mmu_has_mbec(vcpu))
+			pte_access &= ~ACC_USER_EXEC_MASK;
 	}
 
-	if (pte_access & ACC_EXEC_MASK)
-		spte |= shadow_x_mask;
-	else
+	if (pte_access & (ACC_EXEC_MASK | ACC_USER_EXEC_MASK)) {
+		if (pte_access & ACC_EXEC_MASK)
+			spte |= shadow_x_mask;
+
+		if (pte_access & ACC_USER_EXEC_MASK)
+			spte |= shadow_ux_mask;
+	} else {
 		spte |= shadow_nx_mask;
+	}
 
 	if (pte_access & ACC_USER_MASK)
 		spte |= shadow_user_mask;
 
+	/*
+	 * With MBEC enabled, EPT misconfigurations occur if bit 0 is clear
+	 * (read disabled) and bit 10 is set (user-executable). Prevent the
+	 * creation of such invalid SPTEs by clearing the user-executable bit
+	 * when read access is not permitted.
+	 */
+	if (mmu_has_mbec(vcpu) &&
+	    !(spte & VMX_EPT_READABLE_MASK) &&
+	    (spte & VMX_EPT_USER_EXECUTABLE_MASK))
+		spte &= ~VMX_EPT_USER_EXECUTABLE_MASK;
+
 	if (level > PG_LEVEL_4K)
 		spte |= PT_PAGE_SIZE_MASK;
 
@@ -311,17 +331,21 @@ static u64 modify_spte_protections(u64 spte, u64 set, u64 clear)
 	KVM_MMU_WARN_ON(set & clear);
 	spte = (spte | set) & ~clear;
 
+	/*
+	 * With MBEC enabled, ensure we don't create invalid SPTEs where
+	 * read access is disabled but user-executable access is enabled.
+	 */
+	if (shadow_ux_mask &&
+	    !(spte & VMX_EPT_READABLE_MASK) &&
+	    (spte & VMX_EPT_USER_EXECUTABLE_MASK))
+		spte &= ~VMX_EPT_USER_EXECUTABLE_MASK;
+
 	if (is_access_track)
 		spte = mark_spte_for_access_track(spte);
 
 	return spte;
 }
 
-static u64 make_spte_executable(u64 spte)
-{
-	return modify_spte_protections(spte, shadow_x_mask, shadow_nx_mask);
-}
-
 static u64 make_spte_nonexecutable(u64 spte)
 {
 	return modify_spte_protections(spte, shadow_nx_mask, shadow_x_mask);
@@ -356,8 +380,14 @@ u64 make_small_spte(struct kvm *kvm, u64 huge_spte,
 		 * the page executable as the NX hugepage mitigation no longer
 		 * applies.
 		 */
-		if ((role.access & ACC_EXEC_MASK) && is_nx_huge_page_enabled(kvm))
-			child_spte = make_spte_executable(child_spte);
+		if ((role.access & (ACC_EXEC_MASK | ACC_USER_EXEC_MASK)) &&
+		    is_nx_huge_page_enabled(kvm)) {
+			if (role.access & ACC_EXEC_MASK)
+				child_spte |= shadow_x_mask;
+
+			if (role.access & ACC_USER_EXEC_MASK)
+				child_spte |= shadow_ux_mask;
+		}
 	}
 
 	return child_spte;
@@ -389,7 +419,8 @@ u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled)
 	u64 spte = SPTE_MMU_PRESENT_MASK;
 
 	spte |= __pa(child_pt) | shadow_present_mask | PT_WRITABLE_MASK |
-		shadow_user_mask | shadow_x_mask | shadow_me_value;
+		shadow_user_mask | shadow_ux_mask | shadow_x_mask |
+		shadow_me_value;
 
 	if (ad_disabled)
 		spte |= SPTE_TDP_AD_DISABLED;
@@ -489,7 +520,8 @@ void kvm_mmu_set_me_spte_mask(u64 me_value, u64 me_mask)
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_mmu_set_me_spte_mask);
 
-void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only)
+void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only,
+			   bool has_mbec)
 {
 	kvm_ad_enabled		= has_ad_bits;
 
@@ -501,7 +533,7 @@ void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only)
 	/* VMX_EPT_SUPPRESS_VE_BIT is needed for W or X violation. */
 	shadow_present_mask	=
 		(has_exec_only ? 0ull : VMX_EPT_READABLE_MASK) | VMX_EPT_SUPPRESS_VE_BIT;
-
+	shadow_ux_mask		= has_mbec ? VMX_EPT_USER_EXECUTABLE_MASK : 0ull;
 	shadow_acc_track_mask	= VMX_EPT_RWX_MASK;
 	shadow_host_writable_mask = EPT_SPTE_HOST_WRITABLE;
 	shadow_mmu_writable_mask  = EPT_SPTE_MMU_WRITABLE;
@@ -509,9 +541,11 @@ void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only)
 	/*
 	 * EPT Misconfigurations are generated if the value of bits 2:0
 	 * of an EPT paging-structure entry is 110b (write/execute).
+	 * With MBEC, the additional case of bit 0 clear and bit 10 set
+	 * (read disabled but user-executable) is prevented in make_spte().
 	 */
 	kvm_mmu_set_mmio_spte_mask(VMX_EPT_MISCONFIG_WX_VALUE,
-				   VMX_EPT_RWX_MASK | VMX_EPT_SUPPRESS_VE_BIT, 0);
+				   (VMX_EPT_RWX_MASK | VMX_EPT_SUPPRESS_VE_BIT), 0);
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_mmu_set_ept_masks);
 
@@ -551,6 +585,7 @@ void kvm_mmu_reset_all_pte_masks(void)
 	shadow_dirty_mask	= PT_DIRTY_MASK;
 	shadow_nx_mask		= PT64_NX_MASK;
 	shadow_x_mask		= 0;
+	shadow_ux_mask		= 0;
 	shadow_present_mask	= PT_PRESENT_MASK;
 
 	shadow_acc_track_mask	= 0;
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 101a2f61ec96..74fb1fe60d89 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -45,8 +45,9 @@ static_assert(SPTE_TDP_AD_ENABLED == 0);
 #define ACC_EXEC_MASK    1
 #define ACC_WRITE_MASK   PT_WRITABLE_MASK
 #define ACC_USER_MASK    PT_USER_MASK
+#define ACC_USER_EXEC_MASK (1ULL << 3)
 #define ACC_RWX          (ACC_EXEC_MASK | ACC_WRITE_MASK | ACC_USER_MASK)
-#define ACC_ALL          ACC_RWX
+#define ACC_ALL          (ACC_RWX | ACC_USER_EXEC_MASK)
 
 /* The mask for the R/X bits in EPT PTEs */
 #define SPTE_EPT_READABLE_MASK			0x1ull
@@ -180,6 +181,7 @@ extern u64 __read_mostly shadow_mmu_writable_mask;
 extern u64 __read_mostly shadow_nx_mask;
 extern u64 __read_mostly shadow_x_mask; /* mutual exclusive with nx_mask */
 extern u64 __read_mostly shadow_user_mask;
+extern u64 __read_mostly shadow_ux_mask;
 extern u64 __read_mostly shadow_accessed_mask;
 extern u64 __read_mostly shadow_dirty_mask;
 extern u64 __read_mostly shadow_mmio_value;
@@ -344,9 +346,53 @@ static inline bool is_last_spte(u64 pte, int level)
 	return (level == PG_LEVEL_4K) || is_large_pte(pte);
 }
 
-static inline bool is_executable_pte(u64 spte)
+static inline bool is_executable_pte(u64 spte, bool is_user_access,
+				     struct kvm_vcpu *vcpu)
 {
-	return (spte & (shadow_x_mask | shadow_nx_mask)) == shadow_x_mask;
+	if (spte & shadow_nx_mask)
+		return false;
+
+	if (!mmu_has_mbec(vcpu))
+		return (spte & shadow_x_mask) == shadow_x_mask;
+
+	/*
+	 * Warn against AMD systems (where shadow_x_mask == 0) reaching
+	 * this point, so this will always evaluate to true for user-mode
+	 * pages, but until GMET is implemented, this should be a no-op.
+	 */
+	if (WARN_ON_ONCE(!shadow_x_mask))
+		return is_user_access || !(spte & shadow_user_mask);
+
+	return spte & (is_user_access ? shadow_ux_mask : shadow_x_mask);
+}
+
+static inline bool is_executable_pte_fault(u64 spte,
+					   struct kvm_page_fault *fault,
+					   struct kvm_vcpu *vcpu)
+{
+	if (spte & shadow_nx_mask)
+		return false;
+
+	if (!mmu_has_mbec(vcpu))
+		return (spte & shadow_x_mask) == shadow_x_mask;
+
+	/*
+	 * Warn against AMD systems (where shadow_x_mask == 0) reaching
+	 * this point, so this will always evaluate to true for user-mode
+	 * pages, but until GMET is implemented, this should be a no-op.
+	 */
+	if (WARN_ON_ONCE(!shadow_x_mask))
+		return fault->user || !(spte & shadow_user_mask);
+
+	/*
+	 * For TDP MMU, the fault->user bit indicates a read access,
+	 * not the guest's CPL. For execute faults, check both execute
+	 * permissions since we don't know the actual CPL.
+	 */
+	if (fault->is_tdp)
+		return spte & (shadow_x_mask | shadow_ux_mask);
+
+	return spte & (fault->user ? shadow_ux_mask : shadow_x_mask);
 }
 
 static inline kvm_pfn_t spte_to_pfn(u64 pte)
@@ -479,10 +525,11 @@ static inline bool is_mmu_writable_spte(u64 spte)
  * SPTE protections.  Note, the caller is responsible for checking that the
  * SPTE is a shadow-present, leaf SPTE (either before or after).
  */
-static inline bool is_access_allowed(struct kvm_page_fault *fault, u64 spte)
+static inline bool is_access_allowed(struct kvm_page_fault *fault, u64 spte,
+				     struct kvm_vcpu *vcpu)
 {
 	if (fault->exec)
-		return is_executable_pte(spte);
+		return is_executable_pte_fault(spte, fault, vcpu);
 
 	if (fault->write)
 		return is_writable_pte(spte);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 98221ed34c51..46988a11dc51 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1183,16 +1183,20 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 		return RET_PF_RETRY;
 
 	if (is_shadow_present_pte(iter->old_spte) &&
-	    (fault->prefetch || is_access_allowed(fault, iter->old_spte)) &&
+	    (fault->prefetch ||
+	     is_access_allowed(fault, iter->old_spte, vcpu)) &&
 	    is_last_spte(iter->old_spte, iter->level)) {
 		WARN_ON_ONCE(fault->pfn != spte_to_pfn(iter->old_spte));
 		return RET_PF_SPURIOUS;
 	}
 
 	if (unlikely(!fault->slot))
-		new_spte = make_mmio_spte(vcpu, iter->gfn, ACC_RWX);
+		new_spte = make_mmio_spte(vcpu, iter->gfn,
+					  ACC_ALL);
 	else
-		wrprot = make_spte(vcpu, sp, fault->slot, ACC_RWX, iter->gfn,
+		wrprot = make_spte(vcpu, sp, fault->slot,
+				   ACC_ALL,
+				   iter->gfn,
 				   fault->pfn, iter->old_spte, fault->prefetch,
 				   false, fault->map_writable, &new_spte);
 
@@ -1220,7 +1224,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 				     new_spte);
 		ret = RET_PF_EMULATE;
 	} else {
-		trace_kvm_mmu_set_spte(iter->level, iter->gfn,
+		trace_kvm_mmu_set_spte(vcpu, iter->level, iter->gfn,
 				       rcu_dereference(iter->sptep));
 	}
 
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 02aadb9d730e..8107c8cb1d4b 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -270,6 +270,12 @@ static inline bool cpu_has_vmx_tsc_scaling(void)
 		SECONDARY_EXEC_TSC_SCALING;
 }
 
+static inline bool cpu_has_vmx_mode_based_ept_exec(void)
+{
+	return vmcs_config.cpu_based_2nd_exec_ctrl &
+		SECONDARY_EXEC_MODE_BASED_EPT_EXEC;
+}
+
 static inline bool cpu_has_vmx_bus_lock_detection(void)
 {
 	return vmcs_config.cpu_based_2nd_exec_ctrl &
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b6e370213769..520ccca27502 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8607,7 +8607,8 @@ __init int vmx_hardware_setup(void)
 
 	if (enable_ept)
 		kvm_mmu_set_ept_masks(enable_ept_ad_bits,
-				      cpu_has_vmx_ept_execute_only());
+				      cpu_has_vmx_ept_execute_only(),
+				      cpu_has_vmx_mode_based_ept_exec());
 	else
 		vt_x86_ops.get_mt_mask = NULL;
 
-- 
2.43.0


