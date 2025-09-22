Return-Path: <kvm+bounces-58378-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4525FB90002
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 12:28:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E985E3BB17B
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 10:28:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 977DD2FE05D;
	Mon, 22 Sep 2025 10:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="irjKD9SU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB1AB182B7;
	Mon, 22 Sep 2025 10:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758536895; cv=fail; b=oRQJZRoRd/jyAqFvVvJOb9QMvSB8oPj5v3u1rig64cYpBcauCGK6bGwjwEBshi3cr5mPQvB2ngKDEzCahErsjzP7rn0KtAlukaolXZCa0fq3lylyIqlWscfpkuMhd5hy3o0Y1zP0F8kybwRECELyx3ABu8vSRGQgBLhDmbjU3KY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758536895; c=relaxed/simple;
	bh=gQBk0Ir/+BjlAHpWfHtycsg6tM5DfT03SrWhqzQw4zw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XWI+HudpyNUeD2SR88a+nQmfhNjZOGaXEt1Ah6sr1DKrW0ikNHy63jSCHpMqENJF0UBzJm4A/7wlEX5xMNrELiPx/G4IiFBeTady9/uihpwmnc2BN2pFDrj5JUFTjt+U6YTWa/y+W9hVY7ZXOP761ba9lwcVpxrAuX33ogQQRY4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=irjKD9SU; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758536894; x=1790072894;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=gQBk0Ir/+BjlAHpWfHtycsg6tM5DfT03SrWhqzQw4zw=;
  b=irjKD9SUxOhLgDBDIy+Q6hie9ef8sb8k0y40cDa9CEogXvXbuBfT55dl
   fdhJhiMlG2Ma8PALVUxKIqH/EOgpHP/lZdKCIWUwixDIHsfhbTp/mC3Y5
   y7aEHZ7QKO9d3VOjjH218/fSbLmU2ra9Y9koCpi9PYx34Rb4E8rSUFot2
   E+TjYbD4mJ8Ic6609bNXfXdXiJgCRcPtCfS7xGZKxjZordiDou5YwrWrw
   WbjdhVFSajMecbovc8RolXfiBKd9H9zmXW8CU2RG3jcMSA/vcMTItX0QK
   uyM55UxJ3Kvm23N0jh6Ft9MziHuJuvKdzeAgFfCe4iuFNhUX8MQqTDIL6
   g==;
X-CSE-ConnectionGUID: fwQ56/qySwe0Y8XPj0jeQg==
X-CSE-MsgGUID: oZhzR+kfTq2ihMpth+4GoQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11560"; a="60913509"
X-IronPort-AV: E=Sophos;i="6.18,284,1751266800"; 
   d="scan'208";a="60913509"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 03:28:13 -0700
X-CSE-ConnectionGUID: /qK6UGzmTme4sf+gzngFKQ==
X-CSE-MsgGUID: Sg1VAFFwRjuGQC+6rGI5CQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,284,1751266800"; 
   d="scan'208";a="180854530"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 03:28:13 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 22 Sep 2025 03:28:12 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Mon, 22 Sep 2025 03:28:12 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.7) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 22 Sep 2025 03:28:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oG5CZhWTJNA5d9fEVyiOU0LMdYHg8FhlRXZJGZ7hfu3LCvqVC58gldEgBPTWnQe/woVVu70R+mykM5fGiROwvVn2Luk+oyvkG3BwGk+SlZ2jfLo2J4NKE0tkPmrKZwp16PJQI/1aDXcXwy6idCKkcEKbEmYGZXj7iHxRtWXxm2XqOWuaWqwZCQKAggkP5wF2SEBYvq9vjqvGej5ow3XBhzYWfvr1aO0vZncpQg0jYDWZM86FSeozIcy9iSnFGJ9f4bFbXUotnrueJTl0OIP3RbEvN9qx3PHXIKmMdmsa5ZocF76lLDlvCOhot/rO51sdpANeMqkdiRcU+9FwJNwGng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I9w2DndcOCB/72NPeQCRj1DfP1rHL7fwUrooajL3Duc=;
 b=lWnhtMDsGWYXl9xBIKZavXQwCY6Ylq7CUt/BAWB1DoV0K/X1/l0zZ6w5U4kVMLvX2/hToZRAPNvvSrr/QgK/QZ8pTI5PrE8Wx/LG5TCizq6n+sDyi+EQf/JNwUXcuQUljW9ZlaXcI4OuJzWi2BKL1bl8mRkIC9vvqxDl8qFYUBceOkFToTiXryiMOPKjtd7NZufoDg02LOUctWLLd196i10jGNLYhvvdGj/ZNj0oAyF2/i/tcIujpVIaCu1fNoKhw4IStl0qZ7Snna+s8Fm9YVogGOoSTTfLbGIQc29RQWx3MZPFFPUlAic6r41uTlGf2ONFzmd64wKjg1A6X+TFkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DM6PR11MB4721.namprd11.prod.outlook.com (2603:10b6:5:2a3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Mon, 22 Sep
 2025 10:28:09 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9137.012; Mon, 22 Sep 2025
 10:28:09 +0000
Date: Mon, 22 Sep 2025 18:27:58 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>,
	Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Binbin Wu
	<binbin.wu@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, "Maxim
 Levitsky" <mlevitsk@redhat.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>,
	"Xin Li" <xin@zytor.com>
Subject: Re: [PATCH v16 18/51] KVM: x86: Don't emulate instructions affected
 by CET features
Message-ID: <aNEkrlv1bdoRitoU@intel.com>
References: <20250919223258.1604852-1-seanjc@google.com>
 <20250919223258.1604852-19-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250919223258.1604852-19-seanjc@google.com>
X-ClientProxiedBy: SG2P153CA0049.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::18)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DM6PR11MB4721:EE_
X-MS-Office365-Filtering-Correlation-Id: eac51076-3d44-44c9-5969-08ddf9c2b97e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?aM9OHYzUAGPZMNy8pTsv2qnwK7v/YsHZqYHb6Y9RniGs1Ee1MKypqJZauLcc?=
 =?us-ascii?Q?hQ7oE6+vr0AraWJ3lR3JkTDHpn/2ln39MB3lFQ/y2t5i2khYv7ErglFsxE4M?=
 =?us-ascii?Q?6UOsX99Bfqi+W8F/kSls3gg9u5G7WsxQqUZtHqaUbsCpmBUGnXcD9Cigto8W?=
 =?us-ascii?Q?sUOIZw18DCvaHaRq8V2NE1MlL2iapBpNZWQTzRnuTCZy9EkPz2gESY+KyaBU?=
 =?us-ascii?Q?F0mFFbHOoKLetdXI4oDj2bGPbonks3JxzOlIFAoGNZga7gCaNOoRdmJM+0hj?=
 =?us-ascii?Q?Jxvl3H3P5AunOxLBuI8EADYgL6xxo1wRUZ+/+MoQT4WrA8seAJbI3c63n9MF?=
 =?us-ascii?Q?g37vKmju/Tp4khhB09GwXqQNWE0PuyGXY1iDj87+4Xd3RlXHyeDp5MOMfCar?=
 =?us-ascii?Q?atFV0WbmR/rIe8C0DpVo/QXd7XGkRszSWX9KsKEIqJoWAdOuRyDUQclc4vfv?=
 =?us-ascii?Q?ujhqGsUNUN4hzYMbnaZrh1hMQ4ayyGqzXiil00vQg+Bxeefs4xlbTZjP+mA/?=
 =?us-ascii?Q?x2P1HqhYdKPOeXWWkEI4wMk8zU9l0ZwqYjlmqAK+pWbcxXiUutGl9X6razGG?=
 =?us-ascii?Q?uKyhFPSS18NodaUf7HQIVnn0XufJQshZWPszOV4kXa8kMBx3KoTfkyuQMyg+?=
 =?us-ascii?Q?vC7PWyq3ZEFfwx9D5hRzFla2tASIDJbVW0vodVxp2pAknjA9louCj6mHNLTC?=
 =?us-ascii?Q?km9AbJ0Vs+YOTmYHsNTr8rBHWfd8XxkQuEBhh0A5QurWE7+Yf/I6DQhyhcM2?=
 =?us-ascii?Q?hJkT2TnARI9vqtAL029kGTh8+B1JyAhbTq09BnXQ/yJwjGdqGAdLuTIb5LQO?=
 =?us-ascii?Q?aAyHrwoEF1kHXxcoSo3GZZlgOhjj+KiSxz9stjwyXoOxDLUgkhByb3uW66+x?=
 =?us-ascii?Q?gtRzN622TTgJbzy72z83xUKPq1iF3SQUJ7lyPPQ55ymjZ7tS0f2QO1Ih7CAU?=
 =?us-ascii?Q?oNUqN37kxtE89Rj9+AO/PNx/mWEtwbMkyKvUhRYlq3t0btsohh2oRYXo+2qz?=
 =?us-ascii?Q?KeebFakxOnx9Dzs1SmKKIXsFIHtTiRG31xl3FvVPmiofhT8XQtER3r9TdzdR?=
 =?us-ascii?Q?Zvf1pAOi521lUhRPzuJXfMBfa3hRJWvRLT6TSMT/wCH8uKvU64jtIudxai3z?=
 =?us-ascii?Q?Iv05YG+45rILC+C4c83NzltTmmy3idlc0x5VLUok5wjopljzTd+buXk0sGdR?=
 =?us-ascii?Q?YZ7iLWVLFVNltwcF1/unojzN8OJhKdMm61TWLs8JY5J0lvqg8ijvr8IoCpL5?=
 =?us-ascii?Q?dRquWuKi1DgNvj/1izOnapxfm3VQ24gSMNjDS/vk6VDjb4Q0d6G/hV3s0/4J?=
 =?us-ascii?Q?Vibs109Imxf5ibq7HDYgavKd6AOlT+bGoMq8g37WION9dbqQj0016i5pSK3a?=
 =?us-ascii?Q?jdQRTQjsYyJQKqbLCAmmEqrrLDoJmKgpIRhYVH1PyzJcS3RFaOG49rdcowzH?=
 =?us-ascii?Q?0TeDFyn6YN8=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0hXYhT1/8DHeoNbx0zHYEmtc/1yvtU/lPnsOCybNlmM9fPUoTAFUKzBYPrJa?=
 =?us-ascii?Q?EbunF+LUOkx2a/HzDjZI3EEaHx5OzHZb64nOpkq4EHsTiXCHYyb+dFk1ZimK?=
 =?us-ascii?Q?8BW9pdw557eAyMZpGoVnnyMiPfhLhH/obRXmMyUP5f8EYV17iv0qqi2+q0MH?=
 =?us-ascii?Q?XWHTa4evS+5JenbSXcKGPAkKxAe8+MlfVosSeyM+j8I4yoq+baNgFNsEs2BG?=
 =?us-ascii?Q?waYdsT51ck3PfW8IrN8qVL9EoW0Ev0Iyr4Tnh/K9Rt1O9souN2hGeC8+ovao?=
 =?us-ascii?Q?bIWUImbi3RSQBJ2DbmqwGVLXkiKX++H5JmzkbvPoLK0f6UQcuB2Twep6Qczi?=
 =?us-ascii?Q?pyrJF6o4V5esYBWhra2PBkbbkPQGm4E2gaXe1lsKyszZ4e2eE4bDtSXtr+0K?=
 =?us-ascii?Q?K2cgNqHIrG9Hjbt2XZsDHZjLpMYhDQjMlyIK+CRaAHot+VCQC88TTZHgP+W8?=
 =?us-ascii?Q?CHCyr+mPuMs/K3Dd9FPn5HYvFKLxA2NBFjrz+IyW0hDGdjFid9J7DBrE9BSm?=
 =?us-ascii?Q?cKHx4OzSE2OeCYr2YT+acgCgKIQvYAyOk9BxWSldv2qy1uy7XFWdyUEFXAek?=
 =?us-ascii?Q?UzooL92EEJX7Crczwyzqh4YHXwcug+NTTb9lBRTtswJ+sgtlWP5FgChKNqOJ?=
 =?us-ascii?Q?yaeo4b30lqJRalXn9CADfV/WL/dDiaHPd5ArbD+sZr+frjynBFPs3F6x/IH5?=
 =?us-ascii?Q?Lg8JTSRJUPn0lL2OP3NAFLh3m4LdGb1UGYECHftBvK4fV2sp2r6vGVXZMkJW?=
 =?us-ascii?Q?M2iZssG8+w7NwDwGKPkeDv8rNCwuoAqJkFldsVktBU2XdxFiwDFcWtAoYJdX?=
 =?us-ascii?Q?cLfSnVGK3BFRmkyV2Ke7wQSOe/O5B8sQLIM3W0MnuHHfk7ubi8goRvybGTFd?=
 =?us-ascii?Q?vnHNYghDXndcAqpALxpZt1xH4iVOcFNdnpV6xhY8ZZGEJB40mN07lVjUFQdh?=
 =?us-ascii?Q?FmDdl5hSEmNYOawmZH05RrZylXS7URa2JjmH2BAiSCWB4wIxmtOX/XR9kmxM?=
 =?us-ascii?Q?PBbU4pwvXClfcrArmkXIvTXyq8CdaLrgnwvMfBXBbsb7ZZBtL59THWoFv6B2?=
 =?us-ascii?Q?RQU4riTxi4wrwOmItWzWwZ51DRj4SYWATTN1QKaAAJMDQJxvyY+lEV+JyNwt?=
 =?us-ascii?Q?vqNTUjC6AaTXmReNmAA+7hzcvstJJQGrKGs3TV+trySzd0DF1b4Y2HDG9OVB?=
 =?us-ascii?Q?L860rD9k2Mre61Atl5vVz8nW3w8JRNX2u/vg7K76lrLz5ppNuncKrc2rS78+?=
 =?us-ascii?Q?ALUKHjZ1ssULuEtfrDgBH2r+KGjX1Hkpy4goIJSRlXLLUM2So23iYjuAFVY8?=
 =?us-ascii?Q?tpKkgOV2Ivm+m8rf/Nu7S9QKDXKEjOKHzZCUL4EQjCb0W/znktVjj3muW2tS?=
 =?us-ascii?Q?nqgsmWL2btt2+ZffX/3U2OcRRW59waqAsNCkI1XnIwgzK4CFKxYfS7oShU7F?=
 =?us-ascii?Q?qv+uKkw487jB/encYO1rV6xmpEuYCFum5sDSaIWoLPO01OEJUqkcwFG6IsLJ?=
 =?us-ascii?Q?vjf1iiDKMaDO7UJvNgckoUvYkiW5K5STatd2UMV/j7Qier3qwPxbGWQSWoZx?=
 =?us-ascii?Q?nbqJ6xq1CONtaNTq4mmKYYMITf0Q8h8aG+EhIGsi?=
X-MS-Exchange-CrossTenant-Network-Message-Id: eac51076-3d44-44c9-5969-08ddf9c2b97e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2025 10:28:09.0204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LCxKMZTWBkiXId5kmGbK+P4mv4n5UMa3Y31QrWD3EZAQ1u87eXWx8DR70TqeBeXV5kTicLnf4nQaycbkRQbHsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4721
X-OriginatorOrg: intel.com

On Fri, Sep 19, 2025 at 03:32:25PM -0700, Sean Christopherson wrote:
>Don't emulate branch instructions, e.g. CALL/RET/JMP etc., that are
>affected by Shadow Stacks and/or Indirect Branch Tracking when said
>features are enabled in the guest, as fully emulating CET would require
>significant complexity for no practical benefit (KVM shouldn't need to
>emulate branch instructions on modern hosts).  Simply doing nothing isn't
>an option as that would allow a malicious entity to subvert CET
>protections via the emulator.
>
>To detect instructions that are subject to IBT or affect IBT state, use
>the existing IsBranch flag along with the source operand type to detect
>indirect branches, and the existing NearBranch flag to detect far branches
>(which can affect IBT state even if the branch itself is direct).
>
>For Shadow Stacks, explicitly track instructions that directly affect the
>current SSP, as KVM's emulator doesn't have existing flags that can be
>used to precisely detect such instructions.  Alternatively, the em_xxx()
>helpers could directly check for ShadowStack interactions, but using a
>dedicated flag is arguably easier to audit, and allows for handling both
>IBT and SHSTK in one fell swoop.
>
>Note!  On far transfers, do NOT consult the current privilege level and
>instead treat SHSTK/IBT as being enabled if they're enabled for User *or*
>Supervisor mode.  On inter-privilege level far transfers, SHSTK and IBT
>can be in play for the target privilege level, i.e. checking the current
>privilege could get a false negative, and KVM doesn't know the target
>privilege level until emulation gets under way.
>
>Note #2, FAR JMP from 64-bit mode to compatibility mode interacts with
>the current SSP, but only to ensure SSP[63:32] == 0.  Don't tag FAR JMP
>as SHSTK, which would be rather confusing and would result in FAR JMP
>being rejected unnecessarily the vast majority of the time (ignoring that
>it's unlikely to ever be emulated).  A future commit will add the #GP(0)
>check for the specific FAR JMP scenario.
>
>Note #3, task switches also modify SSP and so need to be rejected.  That
>too will be addressed in a future commit.
>
>Suggested-by: Chao Gao <chao.gao@intel.com>
>Originally-by: Yang Weijiang <weijiang.yang@intel.com>
>Cc: Mathias Krause <minipli@grsecurity.net>
>Cc: John Allen <john.allen@amd.com>
>Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
>Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

<snip>
>+static bool is_ibt_instruction(u64 flags)
>+{
>+	if (!(flags & IsBranch))
>+		return false;
>+
>+	/*
>+	 * Far transfers can affect IBT state even if the branch itself is
>+	 * direct, e.g. when changing privilege levels and loading a conforming
>+	 * code segment.  For simplicity, treat all far branches as affecting
>+	 * IBT.  False positives are acceptable (emulating far branches on an
>+	 * IBT-capable CPU won't happen in practice), while false negatives
>+	 * could impact guest security.
>+	 *
>+	 * Note, this also handles SYCALL and SYSENTER.
>+	 */
>+	if (!(flags & NearBranch))
>+		return true;
>+
>+	switch (flags & (OpMask << SrcShift)) {

nit: maybe use SrcMask here.

#define SrcMask     (OpMask << SrcShift)

>+	case SrcReg:
>+	case SrcMem:
>+	case SrcMem16:
>+	case SrcMem32:
>+		return true;
>+	case SrcMemFAddr:
>+	case SrcImmFAddr:
>+		/* Far branches should be handled above. */
>+		WARN_ON_ONCE(1);
>+		return true;
>+	case SrcNone:
>+	case SrcImm:
>+	case SrcImmByte:
>+	/*
>+	 * Note, ImmU16 is used only for the stack adjustment operand on ENTER
>+	 * and RET instructions.  ENTER isn't a branch and RET FAR is handled
>+	 * by the NearBranch check above.  RET itself isn't an indirect branch.
>+	 */

RET FAR isn't affected by IBT, right? So it is a false positive in the above
NearBranch check. I am not asking you to fix it - just want to ensure it is
intended.

>+	case SrcImmU16:
>+		return false;
>+	default:
>+		WARN_ONCE(1, "Unexpected Src operand '%llx' on branch",
>+			  (flags & (OpMask << SrcShift)));

Ditto. use SrcMask here.

