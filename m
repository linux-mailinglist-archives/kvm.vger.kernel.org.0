Return-Path: <kvm+bounces-66586-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 920A1CD8184
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 06:06:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 321A43040778
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 05:05:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B6572F5479;
	Tue, 23 Dec 2025 05:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="qmA8p2UB";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="V/2M3TOP"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2DC32F1FC4;
	Tue, 23 Dec 2025 05:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766466302; cv=fail; b=mmYRrFjK667E0zw1XE7TeCJiJQIxysbWxqPkdZSRLJN4pfMXl5aQtrJ09gylY6i/CFgDEbOieHuuGwGPfXPuGIEoDp2y3Us1xE1rGCQ3mujs7N98NTAJe5S8c0FED+1BshfA+Q/4hnq7+qVDSnPGNNUBIrhoYKV6o8zRRTRwyKI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766466302; c=relaxed/simple;
	bh=T/iLOj34LKHWEQ9jY9i2CZZKG4SmZHucSalL4Bh/PFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=koo41IiJAlvB3/nnsYDqc6asB0sOy1TdDCOvQOVDVd78vo+fdwdYd4ErMkGOeQEupCC0gktRmItsj3+lpUAERBdOGoLQ3UB3x9oC1IJpzevb7sBhZBSQXZJfGyFQPCAd8O56asqpVLKLqoLtuO1UfA56bLxS0V4QLmu6705xyco=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=qmA8p2UB; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=V/2M3TOP; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BMLwnIw3941949;
	Mon, 22 Dec 2025 21:04:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=8WfUqrS/0KsRBybful0VtNRlL9pxUCy+NuII3m8/e
	cE=; b=qmA8p2UBc7gNjPw4rN23UX9YZEMBb3D79Adn1mmdVc6xbExzE2ZMaQ01Q
	mT5RqOd/bM1bjL3wziwbBcuiadPTX8w//nciyf8HZBOYVBzYb79Oqd4DfuzIAYbo
	ZTHYiX2jXQhzibVZIDi16GUs5egkzRAnVuMz+j6t3bZKIQYJbPN3u+XGQkew2Xt6
	tzuDhMbofEaTo1KRVus3SjG8Rt4Lnxtb6/v5+OMdHgCY4Q99Zwic+pZDrg0x1Ylu
	0G9lsdE/+bn4zUemv2Mb6uxgI5PK76iFYuYK8Tw02S8TUD3QdjWay3Jz6nluLJam
	cvLB1YcHVkRdI24JKLWbXXosa5kAw==
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11020107.outbound.protection.outlook.com [52.101.61.107])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4b7ecgrr1k-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 21:04:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G2G3/EiIUfcmw5cYJnUcUugmePiOpgb7BdeOlKHmh/WHe7T61/bLmFPZkbI9S8c/y6jAvUmp5PKGtEH7WLVOinzllFsnEQzkcMXrQqomrrvQkhzFmAnmrProHIPQIOOmiZTmlRhcwg0mDPPCo61KtfWLPv4hPOkdFTXKi6yvAOzhgmH+I95F53rxrdxcAzMfEFIxs5dZ57gIT3+tqbyEtDukZyTVh2OmGWrTNVxuGSK0QNwfD2mXuqY2/jonBWzs5lsNLObQMbxLPWkxs7l9R89pi6K8DsENzSJadBgVwXykDfdSg4p+1ezthOyVVV8t1pNMxiz105Nmn5awcmkAhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8WfUqrS/0KsRBybful0VtNRlL9pxUCy+NuII3m8/ecE=;
 b=U+tXc1B/dt4eVPowBFG5alLgGYv1PhLF2/O4ku8OcK5JjxVPHNStaK4Kd9r4DlfpNwvWg/NmWD383LiRic6wtQlhAPzerLFs+fhShFZ/dZPtDuglMqMzt43wO9DroXJGFLx/KAA4vNKbeYNbKMKfOinBndD1ZfArd3i7fLWC4Kc/OIoXXAf6lJxUSiGtF11jFMn0sGV1XCGsMPJJ9SUE69cxzjGC6yMrSdDPeVqzirhI9UAWAtvuqVJX7Mk7haS2XHGd9c3wkxF3mgW9PQI5mkV/zf/aArDqooUa0EwlM+JcUiOo74iEYxp/sq+84q1OUVpEFAqL5xMY6dWMoPZISA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8WfUqrS/0KsRBybful0VtNRlL9pxUCy+NuII3m8/ecE=;
 b=V/2M3TOPWFJuzxykThLUwXiVamv7UCigjrnA3KweBVG41gEsLNlrCtlA8Xp5UJZKLuTzsnIHWRP++CeqSj4isS+idCm66FTES20Ng2y63bjyCrYiBfdfl9pdgF/OBHTk0/0aJVm5fxHDG4/+TowVmep3dEF+IFrNfL58PPJrsjghO12BNk1TtFx2Vg/XRVcndgaOVMGMw0JZThcCQ0OFKU6EpRl/ncEJGbxvAOF0XJDNETX4ZnwS+rxgeAyqpJOTAa47kEi2NCXqUtCwL8JdEZeg8od0jX07rHw90d/RfKUQDbzjgq8Er7XpkL2Z8PD6n7bgx1ktgdRbEljZpf2B8g==
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18) by SA1PR02MB8560.namprd02.prod.outlook.com
 (2603:10b6:806:1fb::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.11; Tue, 23 Dec
 2025 05:04:27 +0000
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc]) by LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc%4]) with mapi id 15.20.9434.009; Tue, 23 Dec 2025
 05:04:27 +0000
From: Jon Kohler <jon@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: ken@codelabs.ch, Alexander.Grest@microsoft.com, chao.gao@intel.com,
        madvenka@linux.microsoft.com, mic@digikod.net, nsaenz@amazon.es,
        tao1.su@linux.intel.com, xiaoyao.li@intel.com, zhao1.liu@intel.com,
        Jon Kohler <jon@nutanix.com>, Kai Huang <kai.huang@intel.com>
Subject: [PATCH 3/8] KVM: x86/mmu: adjust MMIO generation bit allocation and allowed mask
Date: Mon, 22 Dec 2025 22:47:56 -0700
Message-ID: <20251223054806.1611168-4-jon@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: 9fe5d98e-9bfd-4628-0d64-08de41e0bf4b
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|1800799024|376014|7416014|366016|921020|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UObGCVnJdFupsE9pu1c3jH2JbWrppBZoiBtQHl/DnTwhGHfqC6TxRe3wuEtl?=
 =?us-ascii?Q?Tm1SC53d7MV03aOtSbl96JVV8Jq6X4nSU4GccVkSypNoj+FiO+bIDew46qLM?=
 =?us-ascii?Q?kg//nVsqLPOjkeNK/QFrt0h0JP5j42FI8wl8mDQKTlFXuFeAsjBCsB4S6yrl?=
 =?us-ascii?Q?AvvMKcmB4ucZTpuqHrpLt73meC5Bk2b7/mFEy0z1QTHhZC7XcKb8DRwabbeK?=
 =?us-ascii?Q?BN/+uKfs76W4gz9IIeZSXRyxUC94nXr8fGR0UNn4A2WFtXWkE1yV4TQnxwBb?=
 =?us-ascii?Q?Szl+nd61aMkbLbmyAut4L0xkbPYo42qdurtSfXSgwp+pWjNlMUh5/ndFMUQJ?=
 =?us-ascii?Q?uGCRHvSuihyhdKq4KC0uTP/lUwsFvOW3iPXgqURwQ/h7L8OpPqQZjHxngR8z?=
 =?us-ascii?Q?67AoVI4yCm1CIafAeBybhR7p7hxNsud9N3risMXkTkpdln9qP9MWlE070eDd?=
 =?us-ascii?Q?rSbZ4CjDSwravCoogXYpLz+NHg5C/RiLm49nWgIYgyjte20+1X7PjmHGlrM8?=
 =?us-ascii?Q?v4quQfXmqk8oEhLyy9oBpPABYg9tQHyZKNwVkAQXDSexE8VbiOJkLw/+4cUN?=
 =?us-ascii?Q?X/WJyZFMT4bbDk1MC3a3pwMtGgrhfMgo55Us6fBW4WBpQoTlof0eIGcOksaU?=
 =?us-ascii?Q?OfbmhJGrSf6Xq5ItEw+tBAzmLkTWwk8IVEBXUNhkunHJgcUh9PrD7z8pSYAF?=
 =?us-ascii?Q?7Ii3cmIrI6aLOwbLNcmS683K4IhxpJC8mrEYjEuAEGgYqPvhh9lGuH912vn1?=
 =?us-ascii?Q?6usnVGVTG5g4fALUfF3/Sa4E13g7cIjmPEUP7wIApDnTs6MKbTNspEa4dbsy?=
 =?us-ascii?Q?EjEySOq/srh16ckwl1zKVGsaiJq9WP7uiFPsiDfR4Zo5L4NaAHj/43aETltv?=
 =?us-ascii?Q?i4z8f3rx8Do2MOuUQ2F9GpD/M18wccMmntN0+SqXJU2VDMfP2Bm2C28N94WL?=
 =?us-ascii?Q?sdg7X/5evjTKbiKs2J4BVFK5Rx31tJ+xuhnuGiJP4EIeFfrXe3i8nU885zNC?=
 =?us-ascii?Q?i9WKay0sT50PPpXpaBbBkxKCqLTtrqVPpapPQlzUOn8WwVfHZz2vVvPCh5px?=
 =?us-ascii?Q?EXoihv43ttBXln0fM9U64wnAUBuLo0Dd4Q9vL1E3xMZoXdrhEqh7YEMw3lzC?=
 =?us-ascii?Q?fargmI/wrHcOQqnBlWVXV9dtWZu5OL0k8K/bVzEbg4YMNoTXtj9e72A3tKuH?=
 =?us-ascii?Q?VtkCdh7oymQPVaCQoaKRuODpBFpEVchpIWrzdyMSnvXuGCuCEb64nA9mbwK2?=
 =?us-ascii?Q?2kE1lsN4g6UqLxaV5ybKueeRJaDDHeeH2k5ZhuyQaLxRsHjrVluK2vguOxfC?=
 =?us-ascii?Q?uS4g1bTDW4159i/T37iV9ESHYU2wYExDF2KsMxbo5iLJo4hhvJ8B7m+qic24?=
 =?us-ascii?Q?ByKpcmfW7v6jbzMmvprtZypH6gQKAgsxL8etypV8AU6CzU3aNKIMu07SIyVz?=
 =?us-ascii?Q?g/ebq017vKcIAjTeZQVysnKYzviPYFkFyF+7ZH1QSCZtzjGttLZjBI228d2y?=
 =?us-ascii?Q?r/PzFZ17Zu+jydiF8o6zSsbwqE756ZLCA0DBzWuvwc5TzrofuefltBfwlQ?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0PR02MB11133.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(1800799024)(376014)(7416014)(366016)(921020)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8SarLUVP6PqozJMPEc+DBhzCnTVzwRSYIBAywP2cOVPyDkr/7U0Go1ywAKlv?=
 =?us-ascii?Q?aoJHwvDNb0zwo1nJXnQTxlVzUcbGXruRuoIsNJdaWUxJFMoWqOATGz2kochS?=
 =?us-ascii?Q?c1oiNJjctkF8/qZeHXzotJsEmARqhgddgrQmcAj09X93dBzKI0wkD9g+kNjN?=
 =?us-ascii?Q?Ac5iEp/bo7y3xKH3gv1dqeVa62bH+SZq2wkn9IdnAsoBWwhoS1PbksmGRDo0?=
 =?us-ascii?Q?/alo5VFYrK2pS0z5Ub6KEaVxWVKzVGyf6ineHh/1YMUZV0c+SDSQKRWMtcCx?=
 =?us-ascii?Q?lFaKvCvc2qJt0HFzsbTIquO+3907Tsj63BZeGQz7n0sLGyRl0woM9FjvGBMO?=
 =?us-ascii?Q?P6/80qEykT9hQ1G8hZABP7K1vvOTBLX8faC+VwrfXtx8n0anYOFBjm9zFPFO?=
 =?us-ascii?Q?TYb6Y8g/Q39EieqckdkIH6AfJQnMwL4i12lL13MjvpLLbOQ6VPP4TaWBPxiO?=
 =?us-ascii?Q?wyBHlal2w0Z/qia4SZWrOBN2XhquRbwZ9vy0cRqgFBdN9BHBs5yhNypnEGp7?=
 =?us-ascii?Q?zJyRyR4P4CS7jb07fAy7BwYTXipvK/7bIoPne/shKA+a5fpVZZDFeaMJSR+R?=
 =?us-ascii?Q?19mHgd+Zlb2JdN1wl/DOVM3B27LU4xCrAlLGcFV2hdw2vlZhtulshCAisVeL?=
 =?us-ascii?Q?PXcHJIdcIX39fDHol/ms0ZruyI6BxIwHEXj+yn54lt5ItgPOjPSX7DDPYwS2?=
 =?us-ascii?Q?byqBJQPwFkQo+SzUV+Ac+GHdtdRm3DLplBwuZFACqMf2JFeq45Y3cgK+E45V?=
 =?us-ascii?Q?0MLBbIZ4BdGTkqfiAZ75czYt1rGjS1lWcdIvpiySoky3x81NdpR5SnLcTCXH?=
 =?us-ascii?Q?6PTSrpaZ8CYBmLZHieRa/o0IIZS9kZWO3oPuuguea9bzWZlnWjTlh8VwFveg?=
 =?us-ascii?Q?8UnNrxUG0ZW2yXXCFawf4or10FNVd/Znr8Hs8BkNNJqQT2W21ENSoo62mAEF?=
 =?us-ascii?Q?t0VbKuz0fXw1M/2c/ce70T8e29KLtCxUVEP1j0RV2MoSBIHLFzKJX/e5TRHk?=
 =?us-ascii?Q?lDMCKtv/HwhOXfgpeY9f8fGe7EVKsgZXwi+CRVUHukgN6/1+HrLYhgnEKzLr?=
 =?us-ascii?Q?rQs8SLaJbu/GKvhuRKCfIqzwVUUVIEusxaSb0TXTHHLyL9MHWvgqQWVw6JBE?=
 =?us-ascii?Q?PUH2DKcR/dJ/6SYTcmAlfcIHKk60xZfzgrBh1E/f2+g+4WJnhad2gIzumIym?=
 =?us-ascii?Q?f6e0prZmyYFooq/3Gko2jcxgv1rj8jEhEP2TIXHM9RvTtkcB3XwQhaJF50PM?=
 =?us-ascii?Q?DdMhpYt1U6gTeb6rXL1Aalp+aZqyV9fUpyhg6H/nLTzi03y+meqnOUL1kV+T?=
 =?us-ascii?Q?/k8AcajBueOXQ/o4bYbRTrghTUBAgr987iLGM/RVJB7STk/iBN1hiMuYr4LE?=
 =?us-ascii?Q?4PJqq5jk1isDyeXx3epeAkW/1CL6aPJpuORdjS6e8hXVbwcUFkjq6BXLrFCY?=
 =?us-ascii?Q?d4Wl90yjJiBeftUvLyWljZJjCIK3w4l5yTDbcjS9fHQNUVrD6QY7Wk3vRndG?=
 =?us-ascii?Q?bv7oEkSLZsVcDnmPhz7pN/LT2R6moTy1zQIhfpEr4aaFaDMlgHUBE0SYckX0?=
 =?us-ascii?Q?zEUl9EBCuh59c1EI1aQgabx0wT6YUEHDPRYl6XPPLkolOncyItAWYutXpCmV?=
 =?us-ascii?Q?kZ24IRL//UqsyKHyH3yg9ImbfIVCwkkSuIW9GKCi0H/HpPQ1B/vOPNmo+T1f?=
 =?us-ascii?Q?jrb+dmq1Itf6MyN+7zAx//piqEhrikag+8xALKtHuZCuO8csMU+g+ohIl8DM?=
 =?us-ascii?Q?xHw3HdEfmPjzyDml+j2929yBstBQzI4=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fe5d98e-9bfd-4628-0d64-08de41e0bf4b
X-MS-Exchange-CrossTenant-AuthSource: LV0PR02MB11133.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2025 05:04:27.1620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 30bWsvLfko5wz5qN1sMkOkPWKrPtfvCKMmI9KpD0pBoue3Dm0Ke1Oxq362216RbPnDLm1ArTel2oZpTzeb9RSQqQj2NdiPG4c2feAze4QOI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR02MB8560
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIzMDA0MCBTYWx0ZWRfXwFr0XeKUfOmi
 tPWSYM6ynXTKdnKeBB7YLuUOvPm6c2OSKta8IMFpX4OSu4T71pjm/peSBA+918l2Dub5iMB/rZ3
 FyS0mqnSQstRqjvOdO8BeiViKRLBwVLZvtkhVBjind7s6LxS0s9NzTv3Sylhah89X5iWvYbON0I
 USXe6+KlwUb8/Yd4Lg2wtaQaYWV9AQT5Sq4Um020zLB5Cr3c6dAa3+PzPOc1f+TsCtUTTygjrCW
 UlzXyDQ4zY+0Z1Yh2bYlYTB3W97Z23d36DcDqQc3rNqBwlFis6Quk6t70DwhSdf5iluikp04tER
 Ch698TS1/lQznmDLBg7tzUTbafd4RgS76MKYOf7VqTT1supgKw33NGdZiWaS7CvpjOHr1qTF5+u
 O5J8dLLhdzEm1oNvOA7mESXZzGb5igYpVjgA2pxRGlHV79wfJ0CzhmugQ9k+w5HVhH0AVJc1YWe
 bwVswAOWH+Q5Le1LkBQ==
X-Proofpoint-ORIG-GUID: UkT3lmH2NwcVhqLYtC06PybvZNutd-uw
X-Proofpoint-GUID: UkT3lmH2NwcVhqLYtC06PybvZNutd-uw
X-Authority-Analysis: v=2.4 cv=R7YO2NRX c=1 sm=1 tr=0 ts=694a22dc cx=c_pps
 a=5R/USArCWZnskgXodYG4KA==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=QyXUC8HyAAAA:8 a=64Cc0HZtAAAA:8
 a=EwT1G5GB7KXMQQH4ZFIA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-23_01,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Update SPTE_MMIO_ALLOWED_MASK to allow EPT user executable (bit 10) to
be treated like EPT RWX bit2:0, as when mode-based execute control is
enabled, bit 10 can act like a "present" bit.

No functional changes intended.

Cc: Kai Huang <kai.huang@intel.com>
Signed-off-by: Jon Kohler <jon@nutanix.com>
---
 arch/x86/kvm/mmu/spte.h | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 0fc83c9064c5..b60666778f61 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -96,11 +96,11 @@ static_assert(!(EPT_SPTE_MMU_WRITABLE & SHADOW_ACC_TRACK_SAVED_MASK));
 #undef SHADOW_ACC_TRACK_SAVED_MASK
 
 /*
- * Due to limited space in PTEs, the MMIO generation is a 19 bit subset of
+ * Due to limited space in PTEs, the MMIO generation is an 18 bit subset of
  * the memslots generation and is derived as follows:
  *
- * Bits 0-7 of the MMIO generation are propagated to spte bits 3-10
- * Bits 8-18 of the MMIO generation are propagated to spte bits 52-62
+ * Bits 0-6 of the MMIO generation are propagated to spte bits 3-9
+ * Bits 7-17 of the MMIO generation are propagated to spte bits 52-62
  *
  * The KVM_MEMSLOT_GEN_UPDATE_IN_PROGRESS flag is intentionally not included in
  * the MMIO generation number, as doing so would require stealing a bit from
@@ -111,7 +111,7 @@ static_assert(!(EPT_SPTE_MMU_WRITABLE & SHADOW_ACC_TRACK_SAVED_MASK));
  */
 
 #define MMIO_SPTE_GEN_LOW_START		3
-#define MMIO_SPTE_GEN_LOW_END		10
+#define MMIO_SPTE_GEN_LOW_END		9
 
 #define MMIO_SPTE_GEN_HIGH_START	52
 #define MMIO_SPTE_GEN_HIGH_END		62
@@ -133,7 +133,8 @@ static_assert(!(SPTE_MMU_PRESENT_MASK &
  * and so they're off-limits for generation; additional checks ensure the mask
  * doesn't overlap legal PA bits), and bit 63 (carved out for future usage).
  */
-#define SPTE_MMIO_ALLOWED_MASK (BIT_ULL(63) | GENMASK_ULL(51, 12) | GENMASK_ULL(2, 0))
+#define SPTE_MMIO_ALLOWED_MASK (BIT_ULL(63) | GENMASK_ULL(51, 12) | \
+				BIT_ULL(10) | GENMASK_ULL(2, 0))
 static_assert(!(SPTE_MMIO_ALLOWED_MASK &
 		(SPTE_MMU_PRESENT_MASK | MMIO_SPTE_GEN_LOW_MASK | MMIO_SPTE_GEN_HIGH_MASK)));
 
@@ -141,7 +142,7 @@ static_assert(!(SPTE_MMIO_ALLOWED_MASK &
 #define MMIO_SPTE_GEN_HIGH_BITS		(MMIO_SPTE_GEN_HIGH_END - MMIO_SPTE_GEN_HIGH_START + 1)
 
 /* remember to adjust the comment above as well if you change these */
-static_assert(MMIO_SPTE_GEN_LOW_BITS == 8 && MMIO_SPTE_GEN_HIGH_BITS == 11);
+static_assert(MMIO_SPTE_GEN_LOW_BITS == 7 && MMIO_SPTE_GEN_HIGH_BITS == 11);
 
 #define MMIO_SPTE_GEN_LOW_SHIFT		(MMIO_SPTE_GEN_LOW_START - 0)
 #define MMIO_SPTE_GEN_HIGH_SHIFT	(MMIO_SPTE_GEN_HIGH_START - MMIO_SPTE_GEN_LOW_BITS)
-- 
2.43.0


