Return-Path: <kvm+bounces-46415-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 525FCAB625D
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 07:34:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 13AE916EFC5
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 05:34:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FEEA1F4174;
	Wed, 14 May 2025 05:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EHS1cmVl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8900929408;
	Wed, 14 May 2025 05:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747200848; cv=fail; b=lY6tSLjwzFxYPDX50us3QPK0N8fKZNpK6Pq0Sov88KrV9W1DF9/43EhV0sxFhx7A/z4p+vLkPFQ2yi04osvJaUHW4tGUpfNXKN+JaLIeDgNZaQakANzNdkgQByQGUzTfl5PLrrS8GYFCkTvZDVobenc8vX7gfBPsqBwu2bnN7n4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747200848; c=relaxed/simple;
	bh=f/UICu8J4y0OHP9f/mPxJLjtfAftNcgLkxOlOxs3K28=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=r3UVrCbfEglWhJWgCoOhpnmYty8RaG8RoJ2PBNRj2BgJGbbDENP/5beWdJSHIP4+UbBwVbCbfoNVxv7gDL+/H/SmUWRagDNQrqG6d9Y0QvMymUzchhQGq8duTEdMQl7QJHhZXfzJpOh//483s5pRL6ZJyJx+KwXTesKPch5h71s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EHS1cmVl; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747200847; x=1778736847;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=f/UICu8J4y0OHP9f/mPxJLjtfAftNcgLkxOlOxs3K28=;
  b=EHS1cmVlD8faSGw/aj21A4k7YCSkfb4bmllogUW3CPopgEMA0dzvDiim
   hBZROgzpUsLGcFNJ1MTtDxZD7V/Z4FHM8f//+sZn9VAyiW/4wTWQ8kFEI
   sNUvjOMrfMlmdAUtJweFNooUg037IXQd8bbRj8RHJ3jpqtCa7QmoV9JtH
   z8wtftRRXgD+F+QcybjILmm3LeyyOUqjpw/VsNEoDZST8uuNtpLxuT3F3
   bCTTRQuwFSNK+ogovyNn1tnjULAoYUaLUqBMjaVgNSh/7EEf2ng7WAtt0
   1sYhgu+GXwYHhjn0Gytt4+u6QqUI9kYKB+1L4XApROIyGA1FFAChhjdPa
   w==;
X-CSE-ConnectionGUID: a+/ioTDCRK+YXFmAb8+YOw==
X-CSE-MsgGUID: hE4NAdmWTqe4/+F6VZ2vzA==
X-IronPort-AV: E=McAfee;i="6700,10204,11432"; a="74479483"
X-IronPort-AV: E=Sophos;i="6.15,287,1739865600"; 
   d="scan'208";a="74479483"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 22:34:06 -0700
X-CSE-ConnectionGUID: 4XrE4jdqQRK8uaV2lmXDKQ==
X-CSE-MsgGUID: NKcmCzkCQ6SdnzofdjsZog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,287,1739865600"; 
   d="scan'208";a="142688041"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 22:34:06 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 13 May 2025 22:34:05 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 13 May 2025 22:34:05 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 13 May 2025 22:33:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Dmjac/TPS4AU9vvQ/H3n+CClauMznRN8N5DUFOHPg0G8/7QWB8FBpziCSU6p600tAXW1xnaeRCtQZGL9zYCs+lHaNhN9tNnCYzdBPzVaqZMT+xQl4i1A0q3SOacDsjSNZm86EkQXpMWaY4N0wCaIzBeuAuTf2yvb4k608jUsj7M/VBFKqKq5pufX4ZQ5UmV3AmWqtsuceoGkBpOd79T0UT9N8fRKjG87tQHXg2ZQvrJD41wLN2tKObcJKO29Ami9LlfI5tJ2ivBQKF+9RNoTF3bp54HDt4zTh4iTJsPsNm5YTpWDf44XOTnvj5XTEKJemI719toO8Lj6DiwdEvlnbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xz07WHGtd8MLFf2A1m0A7U4JmOSanAKAoHy5f1ljOaA=;
 b=yLGREL/Wx7L+SV9DcggY/3IJ82aCZj7s7MHFlMFZVUct9wNvvRAV3AWv/oG0fzTceq6wyO3l6/sTtjjVf14QmpRIYws92uIjSmlaZ8Nt+IWqd3XB/maQfmd2n0VdQ2NX0JhZV+wknTDUOKpsMVB6NSAF8A3/+IodxvQEm2QTsxG/UoFl+iKShBkJPfEPxnbR4EmhLEDcX/r6eAkUISf+r0a1cgF+wEjYbFJ3EoW3P0yUwwEiNhnLowjpUnROZ7aS6msyTvM6Ln9O8Z88uMpJtU6UtaqnlNmZVHjUHsLqW1hvYfmCpgU++FJbe7FQ6KTb5J4TFsZLXg70IrfYUiutjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by MW4PR11MB6713.namprd11.prod.outlook.com (2603:10b6:303:1e8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Wed, 14 May
 2025 05:33:49 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.8699.019; Wed, 14 May 2025
 05:33:49 +0000
Date: Wed, 14 May 2025 13:33:38 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>, <rick.p.edgecombe@intel.com>,
	<isaku.yamahata@intel.com>, <kai.huang@intel.com>, <yan.y.zhao@intel.com>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC, PATCH 05/12] KVM: TDX: Add tdx_pamt_get()/put() helpers
Message-ID: <aCQrMh+wxDzrpAKA@intel.com>
References: <20250502130828.4071412-1-kirill.shutemov@linux.intel.com>
 <20250502130828.4071412-6-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250502130828.4071412-6-kirill.shutemov@linux.intel.com>
X-ClientProxiedBy: KU2P306CA0050.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:3d::18) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|MW4PR11MB6713:EE_
X-MS-Office365-Filtering-Correlation-Id: 191c89ae-ce38-4cc4-5d15-08dd92a8e780
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?jNX/mftcAPcTFOax0knBwxLHf4eY5iebW+jc4Sy7ZwxBZitrVxl8Np5Eh/rQ?=
 =?us-ascii?Q?P4McKACjQtMWFyVe6tpdytMSXHyM14kysUkVGhLM4TPtXWZDIpApXJFscuNc?=
 =?us-ascii?Q?PUjA4c8JovsO194adCT90SvC4oHaz21uQgzuU5ipFs4e2T+oPSHb89uiskWD?=
 =?us-ascii?Q?CtnjfK1P7Onno89m7xfpKu+iM9ik2IXhD2OGWNT9huCknLodmMVx3qXUvC9F?=
 =?us-ascii?Q?jv5zguMJtmyefoc1HN1Lt8Russ4mFsiDvW74B2sYNSRCbAQktoT0GoeVd5uR?=
 =?us-ascii?Q?pW3dcNTfdudPSi5MsBY6/UZAv+5I8XXFk3eRpb7yBfrUQqfsCp6orUdBa7yf?=
 =?us-ascii?Q?kX0TeU3moiLssY2hZuc2Erfv0Yew99nnkIqhs14GrLVj+PLZ/pkKDesI4BwP?=
 =?us-ascii?Q?62iCc2j+4WB4lug126g7KwDTkLo2eZLbDff9r9tAUksRVyd/508V48J4L6u4?=
 =?us-ascii?Q?e5QaGs/kz8L8yVChtFqOFyueTlbVlUQrXRk+/gnQnNWqi6BBHRuYzIK9zpEy?=
 =?us-ascii?Q?N1F4+vGOGw0Pdi5ZaXQD0af+wRdkvWSHb7YuFJiU1tnlUyQmrAEidZwKxCtk?=
 =?us-ascii?Q?320jl4owaO5cZkv8ioCrinKF81EGiKssEqLHLiGuBdMlzMlZ1z4Qu56NSjia?=
 =?us-ascii?Q?4HJ5Fk9YzmAfo6cle9pdzA9WQFIBIX0ybR1cPX4gQ1p11JoXcweR65j7tQdl?=
 =?us-ascii?Q?uoLpz6FXbKfMO8V0wHpgGpuV1OQ/wuHS4v+Ll1H9GtflrifPpTMyaE4tD1rV?=
 =?us-ascii?Q?8O7/jrK27LfLAFSP2xu4KuoCWnoVwHJZzD5ZDsvnFcQ78G7YfLx2oFYz547i?=
 =?us-ascii?Q?Q+OAppB7m0TsuRoxAL5dbFsOblFeQAe8y1y5bqMvo2szTr35m9YU5JligNXc?=
 =?us-ascii?Q?e73GprK2PhwXCUEI2xsg75JMloZngAwSWYRSD5bjaRjNZ4fFlnX3HRG2TMO5?=
 =?us-ascii?Q?6wGNJUMx0mVQPkmVd+Dr69Qw+FUdGmm501fTUdFZeb0TmneFhIlYf8ty96Md?=
 =?us-ascii?Q?6ICVtmTDpiU8tHue/+XC+XoDKYJR3IixogPwqz3EPR/xLwhApzfDKGjQ/Klu?=
 =?us-ascii?Q?oyztL9uME2Eb6eCJ3RM5jgNP6JtKp8apt/5l0lnoRTfF0RtdKx9FpobawMv8?=
 =?us-ascii?Q?8g+YkuGF+3bYfX9zcpVEFbLw5eQTKMZhyHDpyAqZQFJFkoJRxsNQ1tW81QTC?=
 =?us-ascii?Q?FeSwx5Mb2JpU5k2Yke98om9ZRmvmIR8kzXhpYc1UuVV3Vxi5inLFxd3XcZ8S?=
 =?us-ascii?Q?OwFbw0r5gkdES9QzSQfq3CERrPw6nzptMcr7xsxfTQqJAP4J5VQFCUfDbVdR?=
 =?us-ascii?Q?HXRxYST2gH7XJkjmt+y9ueOfG7xqqcli5BvYeCTwm89GN1lsaOTsIyJNQ7Yq?=
 =?us-ascii?Q?7w1TFbcm0Qcpt9l+hyjv/qSVDtonAsJkAfdkOu+KtFhYGQC6YwxkB5MLfyhk?=
 =?us-ascii?Q?o4EJqPhdcOk=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6xQ2bzV+sGM8M42USps29Fe2aXs5axO9W59lAlP4FZGITyui4RQS4TBUw2mw?=
 =?us-ascii?Q?XgCLOZtVmlN7Lac585aEERvcGq26d6s4bdh4sPYP3925dObva+30dYC54b15?=
 =?us-ascii?Q?xOXynBl4R+Uye7gU//1goPeeZx2Hw4VcRD5teQuzeBJvmLemRWb9w8OfzbGn?=
 =?us-ascii?Q?RBD2A9Doq7AHjjt46ZrH0BJmk7Lei45KXfQajHF8ghP59ZJPKHOxfpLbd0Bh?=
 =?us-ascii?Q?RIw4wwsemZ73rNM/W5P8ZZkDf4rEXzDunS6lbhSwjuqz/sJA1zo38DlxS/gV?=
 =?us-ascii?Q?WzoQljpVBf3S3GFHPjFH2EvTQITGbWv3sPBiNjCiBqJbkM8qMASDg05LcOPs?=
 =?us-ascii?Q?hPyF1Pf/y/FOKYdRarJ+dEKMdIjMVouvzjEHd/pFCihCHPTqzo/gAn9nYBN3?=
 =?us-ascii?Q?ar4OybFHYSHFzWJHej7Xo3qeMz4pCSP6M1cII1scddtWv2oYhxHPVzgdVjR/?=
 =?us-ascii?Q?/tFWLaGeAZdPrtWMpa1WA0Peqb+Aw1vbxWIp24XNBb0f4xOL4omvjxJwX4RU?=
 =?us-ascii?Q?Ok+ZBpBD3Fy0ZzuvcnUFQSTU4snCvbBYPmiBgXd0jURwRlSUcUd3Dty3XGXr?=
 =?us-ascii?Q?o55O+AeNvni6X5VvxYiaWDDtnA/P4X1+2HK2U2tMOJbFM6GmAbSm6v6WGhvB?=
 =?us-ascii?Q?/VvF+am/MzGcoHKhIhYCl6oAg1ThUbRF9K9p/6i+9U35T8CFnPXWdjLVWWi9?=
 =?us-ascii?Q?Ard0RKLUx5WjdpyBb5RfeyRUjSfTTOAjA2synWR4VdWtA6SsFYmL+p3a9CcZ?=
 =?us-ascii?Q?VAN6zp4xDbWz7gN59dwEqGiipwfh2bhTBzR1+lyG12ZxWYiVWoWLFgAVB0Db?=
 =?us-ascii?Q?hnQIGjxkF23C40/renWIXP5xDyyiqmJauInvi021t2XZePEtsxvW10BS3N0J?=
 =?us-ascii?Q?iJgiqNE2/XFftTqanxVnWibciKL36jCShgpXGbaN34tD4IfWzGR/WJjXsDue?=
 =?us-ascii?Q?8AvprhiV2uC5YOBcf71LIljZRjoCEyZxEEmfgp9QkV5m7aICEiJRHordyMoC?=
 =?us-ascii?Q?nEzn2PlGk3P6g1es+VL4IcHYX9h7WGjX8+qTdnFtPkK+EAFcThjreKivD8lb?=
 =?us-ascii?Q?85B7w9+23q1rIHy6OQCy2LM3Q9QI2awOISLGAx4LcmF2SsdpXJK7y21hnnM0?=
 =?us-ascii?Q?4G+BRmzI5/j0wWLnAhFcFuxIy/boc6qebsOeZ+AdkwIUkr2IYNaBXln2UDT0?=
 =?us-ascii?Q?BbE7FG85/aXTT1Wg8cYjAZ+eyvnGW4qlGbm1e7APjNsTc1Z/qNVAw5zQr41Z?=
 =?us-ascii?Q?O9aJxX1DSAyKzZ6cxhCPBYdPTq4x2hic8vGqtomFRzIeyea7hwCauFPU3dve?=
 =?us-ascii?Q?JhFzxsuSy/JWBsQX5wA5xU5FDj4b4VCTPhcZuTe+F9BSjDiQXBKYthGYk4IR?=
 =?us-ascii?Q?VBcZVUR1uSipVP7NvP2e4XSeVMcpQf9rKtUZNMLX4VxYY0Zil91LN+s6Bv1U?=
 =?us-ascii?Q?8NQujqN0T0RX0bcFdf9Ve8umaIyVLOs0CyFcqT18LlRVdY9fIF8lvc0KDihh?=
 =?us-ascii?Q?9Bt6bd+2zVDJ/q93z2BUB1DiiprVQ3kzZrDWhWxyKLeoH73J1tI55lM6hKbR?=
 =?us-ascii?Q?sVD3NEL1Y2EyAXCP77t2vlNKHOT3GiXgw5V1fD0B?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 191c89ae-ce38-4cc4-5d15-08dd92a8e780
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 05:33:49.5941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VdJKAbWbPoMKPGF5jCRkF05cWRmrEaQtAH9XwHxHS+VE7fO3yyhfaL4G7cIVCchE2lCZYQZJHelNTj8s2O/VWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6713
X-OriginatorOrg: intel.com

>+static void tdx_pamt_put(struct page *page)
>+{
>+	unsigned long hpa = page_to_phys(page);
>+	atomic_t *pamt_refcount;
>+	LIST_HEAD(pamt_pages);
>+	u64 err;
>+
>+	if (!tdx_supports_dynamic_pamt(tdx_sysinfo))
>+		return;
>+
>+	hpa = ALIGN_DOWN(hpa, SZ_2M);
>+
>+	pamt_refcount = tdx_get_pamt_refcount(hpa);
>+	if (!atomic_dec_and_test(pamt_refcount))
>+		return;
>+
>+	spin_lock(&pamt_lock);
>+
>+	/* Lost race against tdx_pamt_add()? */
>+	if (atomic_read(pamt_refcount) != 0) {
>+		spin_unlock(&pamt_lock);
>+		return;
>+	}
>+
>+	err = tdh_phymem_pamt_remove(hpa | TDX_PS_2M, &pamt_pages);
>+	spin_unlock(&pamt_lock);
>+
>+	if (err) {
>+		pr_tdx_error(TDH_PHYMEM_PAMT_REMOVE, err);

Should the refcount be increased here, since the PAMT pages are not removed?

>+		return;
>+	}
>+
>+	tdx_free_pamt_pages(&pamt_pages);
>+}

