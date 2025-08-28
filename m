Return-Path: <kvm+bounces-56028-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4108CB393BD
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 08:24:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EE7742076C9
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 06:24:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67F5C1CAB3;
	Thu, 28 Aug 2025 06:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ARtMOT07"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E270E1EEA5D;
	Thu, 28 Aug 2025 06:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756362290; cv=fail; b=G/g7+qlXRlG0DgjhxW8GAfW+fWytFejh8nzb0WeOMxwHaQZiDYwTqOKeC6lS9Xk8r6EdBR0ulYMbKj81Dq/voR0y/Z8OqragTrwT16layqD6lBhFeyE+hOGxeTvbsrMeSrJbHaGysH4VeO7tm6BCEXf8yRe3TgqEbaymkLkoKPE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756362290; c=relaxed/simple;
	bh=JWZMAQelFwJ7oh1Y1YfonMxfob0n5s7v2BIybsC7kHs=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=D6ivs1zkDHpqyXxC3CG4v6Tz/ZZnRkMJJu72/AE0h8Gba1CH/9NWYewE3NKWfegx3sPKqc0fjYuKqrs3Os1WGx5Rke1BSWMyQlWOeilRxMAWmiHeRvQnQjLU2Dbz+5mQqRhVjahwoidmBRIgPQKNU7HXpdI245M2l6EK76xFU7E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ARtMOT07; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756362289; x=1787898289;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=JWZMAQelFwJ7oh1Y1YfonMxfob0n5s7v2BIybsC7kHs=;
  b=ARtMOT07kU1Dk9+M/fExNumO9RlTdPVeDJN9m1MQT3FY+sV4QeTABM28
   TSHjzFSgP3R/Td2fGlmy14A+sZi7QQ4vImjzUOvSA6e2QPEghs+TJ+9OD
   zEFDyAgWGgsQowAuQ9w/95seZu4qEtk3Ce5XNOvN4Jd8fcFlIwEj2euG/
   4XhazLF5uqOOAUICugVTcqjBAsAk5pyw+h84hYfg4gN4bdzJJBIukkxp5
   F1xLsXBJgobdceHVX4CcPeVvEbUX2rlAGs07ckS2VILmUqjb5matyxbDi
   olPYvJxQWi1r7k7JsoaztfesLu5AWyuCN/atz7lp3nJaXCnXMrA4a8Om0
   Q==;
X-CSE-ConnectionGUID: 2LOz4BrrQyyYbB7Tq8nFjQ==
X-CSE-MsgGUID: F9WLBOoASuOhwxP9QWbaPw==
X-IronPort-AV: E=McAfee;i="6800,10657,11535"; a="69992755"
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="69992755"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 23:24:48 -0700
X-CSE-ConnectionGUID: bMQwDOMSQVuzs0Dmz/Gy/A==
X-CSE-MsgGUID: m2oivxlFRVeyDVgf9tkvCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="170420302"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 23:24:48 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 23:24:47 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 27 Aug 2025 23:24:47 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.72) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 23:24:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NOUAFAhb7IYtqhEbJRaPfPUDYF3dh9+bhaO+UoykJN5iz0IUOa6Y4XBl59RBB6WnK/Zm+5jbnNliaLAWuhJorG9UfFVI03+sdmZZ4590jIzeiBUqsXtA1opdQ0IkHfS7o5luAI0MmVTM5W97/0b+7HhOBicV8KrABq7yZb8V0w0H2yzj2/CqbKiV38ZuUfGuzUM6a6Q+qtDwr+fz8GR1KrnUDGDeOeHJaixirX2op1WexLjAR4D5P5odHD1gF4vKfgFKYTJJ6wl3aMsmmW+3sN+k5xVRTLqjTIf5RCtg6bzlMJ50W20RmtZDs3JwPrZGEt+CswH4ZaYpiRYqO8yQpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+9fdBZ3zrwUzcKZNO8pHtm9ZyrT/V4mE3BcU+/7vvRg=;
 b=rQfaWXGKRm+/q+0jBKC9e1Bee4LBBsto7gUL7VpuYv+5d9DVMvLfUEs+U5rikk0y9ryF0UoGP+bdHAoPrfRIqQ70P1apuKo7M/g0b2MLcMuwt+DamhOFNt2g/jR1iBqV/Hf7HvAREviCHXSakG1jMl0s/Lg5nW73f1JJoMNQDaayMtqV5GGX4RRySnR+/tvPPbhIMXbxCPmg0YUcJ9I3aiSPWaMMDevylMB6YVfAHqqipv3UijfGj8k8BL1pOP9pTXh1RsB/QPggicCwPQkI3bzU8RYVdh1VqFKVt1hsZPtbTbY6yH+WG1T/PosFrwy7uhnZsLJ6I6qBS8L2v/ZpHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SN7PR11MB6946.namprd11.prod.outlook.com (2603:10b6:806:2a9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.17; Thu, 28 Aug
 2025 06:24:42 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%7]) with mapi id 15.20.9052.013; Thu, 28 Aug 2025
 06:24:41 +0000
Date: Thu, 28 Aug 2025 14:23:52 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "Weiny, Ira" <ira.weiny@intel.com>
Subject: Re: [RFC PATCH 02/12] KVM: x86/mmu: Add dedicated API to map
 guest_memfd pfn into TDP MMU
Message-ID: <aK/1+Al99CoTKzKH@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250827000522.4022426-1-seanjc@google.com>
 <20250827000522.4022426-3-seanjc@google.com>
 <aK7BBen/EGnSY1ub@yzhao56-desk.sh.intel.com>
 <4c292519bf58d503c561063d4c139ab918ed3304.camel@intel.com>
 <6bb76ce318651fcae796be57b77e10857eb73879.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6bb76ce318651fcae796be57b77e10857eb73879.camel@intel.com>
X-ClientProxiedBy: SGAP274CA0009.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::21)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SN7PR11MB6946:EE_
X-MS-Office365-Filtering-Correlation-Id: a013a82e-d9d2-4515-5613-08dde5fb924e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?fY4ALGYTCpadYNYcgrBSwFXRFhS+dCShBdjCG+/7hpaP1DYpBoXdjT8ndh?=
 =?iso-8859-1?Q?1C/ylb7o9p2u47nT2KF0zX9zMToZNgs0680xLLj8zecnF6DQOK3+z+OxlF?=
 =?iso-8859-1?Q?AFoJqou9sWwGrofpxzFCjR2mEqSiu9BGl3MiEoFaeIdme1X0gU4eqrbhcH?=
 =?iso-8859-1?Q?fHBVZ6tS3YM+RZ8x+hUq/UO5XDj7mx/aWPfJU3foIzpV1egYbH9PGjNUYh?=
 =?iso-8859-1?Q?IqO4hy9bNg6bfA2S5xFC/nOFwob9uBraXGGybn81Q7ZLrx8Ef187Y9bHvf?=
 =?iso-8859-1?Q?hs2I6Ezc6UPfkIFNfmMgfhHP/ULdJaEqFne65f0s4rm8vLgEveoFOd/Tsc?=
 =?iso-8859-1?Q?iq8D+RuMSbU+49pn/hgwbsr59ztT/yfWKHGnJ42qSQJHyKxUCVZnPt6Pza?=
 =?iso-8859-1?Q?0ct4vuradQ+2YaWj98Yhri2u2nTm+6kFzWKSzoWOabKum8mAu+vTP0nbwe?=
 =?iso-8859-1?Q?wGziOnmsuV3oziOdOultQFp/wJDlgOYDcqBFjVL5OGV6EuRxq5/RodXIz/?=
 =?iso-8859-1?Q?2k4PBgTFKzs8nxoUvsyUufWxObQw+Dw2H0UqrEAfYb4pbgTBYfC0QTzFAe?=
 =?iso-8859-1?Q?KC8U91bEUnyJvTxLEUDisnEzVpcFvLf40+4hbQ/1OvmLqB6bKEwY65p9+h?=
 =?iso-8859-1?Q?hHn37lVokyhjmK/waLuIEfEH1F+l8tx3mqZkcwvXNuCyQ3R7fe98QO+pjA?=
 =?iso-8859-1?Q?AT2F9HARuDQYWZ60Cz7+Z2sOiyHlPt2fTQCmxa4dnyE0iNwWgW6rpfX9gi?=
 =?iso-8859-1?Q?QEe8d9T7nJNmRtbFJMycWHLQVwDnIJQeQK3AJdx7Nbm7S7J846gqu0cWDA?=
 =?iso-8859-1?Q?0WrHDyoo3sobHCG+PbO8XzFagfWgxk810aqupkwzLa8xQ90qMYUXTgNmXF?=
 =?iso-8859-1?Q?BoXv+/gLcpqFG+gGkjUU/vVNIwjr9jED0w44bOyNp/P+z/7C91kdJgusOY?=
 =?iso-8859-1?Q?rc/BYF6AFYzwtRRxyU7XwegHoo/kQt6jXhYVhnkg61jh2Ycr5I4H7XvWfA?=
 =?iso-8859-1?Q?QsHUU8qPpZ+9Lrl18zd3iVSKHPhD1UvSkU8XgoEzkBXbwiU0VWzcSzGOu2?=
 =?iso-8859-1?Q?1CjmrpWe/fwYYac89H9R5/a/6Oxkgt0eEd7pKgoHLrLlmlh9L2pdZOtfN6?=
 =?iso-8859-1?Q?unTLYXrszR66UbTyZjkVdJ731xorXepEOd6/jD25b/LVWzR1uFqabAsKEY?=
 =?iso-8859-1?Q?jyWkkoDL04jT9qSaJMYn8kMmYW5hT48+uHzrraaqCQE7mz0gRBKsyqc2N+?=
 =?iso-8859-1?Q?B4SlG96j5CKHUSuZo0eJLW7jKdhnEPgok3HA6k9oPx7G+fsjAc9+jKyM4B?=
 =?iso-8859-1?Q?n7/96ew/KgCA5Zhx1b9E1u5oRpKcsQEENIVgM9fE91iDiTLZeDmaqOznC7?=
 =?iso-8859-1?Q?qCZjANxqnhDus4nGHeWQSd1jqfa3HSyqLpZD6fO1yIZqubddfpXuVj/xh7?=
 =?iso-8859-1?Q?wSwWyjt/DrCsKHnVtjX58X6wuyOUXYkM4jhuFOADG8ADlIsvAJaa47SOPk?=
 =?iso-8859-1?Q?k=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?DZyyloqfB5uoFRJ3OsjdLml/DBSFZedqxkVBCMnH9phy3ZIfUmRz26DH1O?=
 =?iso-8859-1?Q?n9I7Esos9aeZ4XznYv5kAK5IewIE/HAjw25RD1jofh0tzUGiUTaQEgJ6hk?=
 =?iso-8859-1?Q?8o85yxsS7xL4dC/oAwOe2v81ztVvXkgdevWA2PyT1q6nbfH0Gq7uWOQDaa?=
 =?iso-8859-1?Q?TgBt1vkFAuoTqP7WT7gaxcOSZJtdDw9e/NNQ8h3PHM/Ua13BDMIz518xkH?=
 =?iso-8859-1?Q?Q0qK66x1YaWnHbH2uPC1EBb//Iz1zHF+5PKrbEa4Q6M3YsqgsoUGBMOSJ8?=
 =?iso-8859-1?Q?DtmhosA66Us0tcm7c8cOYzCJe2UFpMHIxSDYFpz9RXnkNyltiXldXCE4U+?=
 =?iso-8859-1?Q?60T8McLX9t/LX5dlrUE0+niLm90yjmalG3h1xlCYr/wKMuxRbFTgnms7vy?=
 =?iso-8859-1?Q?LFw8z+rMPdNvGS3PUWx2n3LQzlxxVPyLXBNQvMsKLSznDtawKr6qglR3z1?=
 =?iso-8859-1?Q?H1TMHvS2OdsIwP+pMkY9605X3KDfmKI90o0b+ZagdoAns16XUql3B8iv6C?=
 =?iso-8859-1?Q?PH+/qWV+5OLRC+1uRa0b2DCGfswy+tZLsQMwQ/IU5N03Rax4D+lnRB2+Rg?=
 =?iso-8859-1?Q?PeUIawO2X6uIO5hmRlSWq2FksS7rwm9WoV43pVDi7iAw5NQk7MC2xjL0Oi?=
 =?iso-8859-1?Q?cPvda7Gbkt9GvOQumcem18gU/DZxsvBymu9Qm5LIc1iFm506GkvQCKfiS9?=
 =?iso-8859-1?Q?zD1toZV09I/PQELRNtyRI3yNCk2P2THgV0e8UsTPbPdbR1V2ufNXAiwKtm?=
 =?iso-8859-1?Q?E12FK9X9asWXfT43gQiwShwBi7PTKUv7jS4MDG5lyEZOk+NGyd/8D9ME+q?=
 =?iso-8859-1?Q?0pQh0o4fwkGFiwi82tUCKU/bLT0kV8hiEF2/u43EaytdQ4XQsXdoBeu8E8?=
 =?iso-8859-1?Q?xdHi0VMAF5Utf0UNX4B7w9TY4vDMTplCvE4uWTmlpXnmyIwj1XTGcNOEgx?=
 =?iso-8859-1?Q?SegEJhg5baH0hrgnacHzBj3Pc8QJdBMsz+hFdfpbxa7NoCAPIVIKdk+mBp?=
 =?iso-8859-1?Q?cqjnWNUwR8zOyahf0BOUiQeljE/7Ya0XGzvDEPk0LsdpfYaZeuv5oMnalj?=
 =?iso-8859-1?Q?Pdb4M/WzJm6/vpuW61LcREVPUop4JIUSnroPHD+dzq2uUvYAA2bwPaYXmY?=
 =?iso-8859-1?Q?BrQh3TKBn1O+swrq/u6W0eqy7gVs2Sbsep21oY/e6zjupyWtybKHZ09rqF?=
 =?iso-8859-1?Q?r3lHINFq7LmGA/YpXSdfYwfsf3BXxyPoj7RzL0KGPWVFw7mHSF7MNAX6fg?=
 =?iso-8859-1?Q?+q940ZlK30yXD458ezaKa8vq8jc9RWbn4FKVwbkHO0ex7uagUn5dTotIOI?=
 =?iso-8859-1?Q?D1W/X30UKl4zZ88E8XaJxqJwWJJuDj1U/r4AKtrsLdb9tctvcU6ZrS7vEo?=
 =?iso-8859-1?Q?EZGNNl6c71vp2x48iKgO4RmmTZ1tmQHO+nJ7FjB/SbE7/IGLvICPkZJsyx?=
 =?iso-8859-1?Q?yJjg/40K6KzWazQzeba02NhXtkmAOYk9C+OozyXkq4/fDbOe1loFOYT1ce?=
 =?iso-8859-1?Q?36qPtZJorxNl+HvH8rrsEis1IK8UF+ct7OCGMephSiPqegxMrmO8qM1GX5?=
 =?iso-8859-1?Q?JXzQ4tcsBxvWp4Y/LAY13TRyyOjnbbJcXW2qjTsMohKHq11aDJbcpJmU7r?=
 =?iso-8859-1?Q?wKvCmcAtLHsQW0IgEV1d8uOikPt3tDCnBN?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a013a82e-d9d2-4515-5613-08dde5fb924e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 06:24:41.2061
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: haIU8Dl+gEX9rJEqc3hR/dX/HmYSTI7vFPfG5jS9i+7yeddPqozdkPFF5ZZj0FMOLrk60MyssTlbTMkneV7p4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6946
X-OriginatorOrg: intel.com

On Thu, Aug 28, 2025 at 09:26:50AM +0800, Edgecombe, Rick P wrote:
> On Wed, 2025-08-27 at 17:54 -0700, Rick Edgecombe wrote:
> > > 
> > > Then, what about setting
> > >                 .max_level = PG_LEVEL_4K,
> > > directly?
> > > 
> > > Otherwise, the "(KVM_BUG_ON(level != PG_LEVEL_4K, kvm)" would be triggered
> > > in
> > > tdx_sept_set_private_spte().
> > 
> > Yes this fails to boot a TD. With max_level = PG_LEVEL_4K it passes the full
> > tests. I don't think it's ideal to encode PAGE.ADD details here though.
> > 
> > But I'm not immediately clear what is going wrong. The old struct
> > kvm_page_fault
> > looks pretty similar. Did you root cause it?
>
> Oh, duh. Because we are passing in the PFN now so it can't know the size. So
> it's not about PAGE.ADD actually.
Right, it's because the previous kvm_tdp_map_page() updates fault->max_level in
kvm_mmu_faultin_pfn_private() by checking the private_max_mapping_level hook.

However, private_max_mapping_level() skips the faultin step and goes straight
to kvm_tdp_mmu_map().

> Sill, how about calling the function kvm_tdp_mmu_map_private_pfn_4k(), or
> passing in the level?
Looks [1] can also address this issue. Not sure which one Sean prefers.

[1] https://lore.kernel.org/all/20250729225455.670324-15-seanjc@google.com

