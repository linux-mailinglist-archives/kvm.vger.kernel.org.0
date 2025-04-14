Return-Path: <kvm+bounces-43212-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 09EB4A87940
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 09:43:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7D531171DCE
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 07:43:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C5F2258CCF;
	Mon, 14 Apr 2025 07:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Lj6SPVNj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE9C11A23AC;
	Mon, 14 Apr 2025 07:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744616493; cv=fail; b=h/HURK5KQTbybTjUcTnlRGdwXyxKq4B9wW85I9iDvajI0+f3KHrI/NK6n9FMPJTHQLXXTvLe/Ab8D8Mkx+HaxsG6caNqIREi2kZo2n2WZ3272xr76DEkDfLrfaMffiCmjIPI26BZF2vvpz7DOp/GRjTK5cvk+YIYgHa3UjYD1SU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744616493; c=relaxed/simple;
	bh=0utzxmfUz27hNllfHGMekN3yK0frGwPSHh+QXxZBlos=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=UqVsJW7EE/h63fHD8CMyf9NC/mpdG9meTEguUKyjIpB1d23sfAMnAumI2ULb4CJdSzVQRar76ky2HbqaMqaZ5V6XAq1DakRbrkYACy//jQjWaAKmhSag+c1OwGaiT2Ij9qgP36VVruqHsYSE8UkOIqeXin52T0szCxDjqiKeNDw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Lj6SPVNj; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744616492; x=1776152492;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=0utzxmfUz27hNllfHGMekN3yK0frGwPSHh+QXxZBlos=;
  b=Lj6SPVNjy+N4Tl/311XTKHY0hrWNJLXx/O35PZQDSYJhg8xAdIHVnvGu
   H2jUrx4z1ewQFjjJ1E0iKp3IAhkDuQSjIG47q4BubT3+yMTt4w3ggD2xB
   GbkNPfA+tnCai3oRPxuSFxURgWWJeRUOpiZ3trKCXtHxITz0JOJc3PRen
   c3ov2yUaXWuRV5qbtVEIhmWZIOx8WBkNIK7ab1oZg+r4S9UIWRJihE9eU
   7zpYVA9KhY/bmw8y8fYZpO57eFVSu6su0A6++5wMyBi3MFh6a/cv1BLua
   ZRqV/FydeV6eydxKcTDR1VEr6OLWpQFzCSefj0ILw/gIzT4CBI68Q2efY
   w==;
X-CSE-ConnectionGUID: wVGKeogYQtODcvJ2OFst4g==
X-CSE-MsgGUID: 4h1K65eaREmzaLsil2L1xA==
X-IronPort-AV: E=McAfee;i="6700,10204,11402"; a="71459308"
X-IronPort-AV: E=Sophos;i="6.15,211,1739865600"; 
   d="scan'208";a="71459308"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2025 00:41:31 -0700
X-CSE-ConnectionGUID: WuJ1OUd0QmqvFL+qXVAvwQ==
X-CSE-MsgGUID: SvPUBfvlQmKDWU8wMmTRCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,211,1739865600"; 
   d="scan'208";a="134493737"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2025 00:41:30 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 14 Apr 2025 00:41:30 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 14 Apr 2025 00:41:30 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 14 Apr 2025 00:41:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iLDYnms2CpCpOBDaCV+oPhI9z25wZyhj7F+4zPuu5PssxIvzBFJ8p6fFbIn36VjJZVkS7Zq/N+fjE3wBuujGgStNm3YQB9JYIaoZzIwtw5eu7A9Dd5m6U+H3crYKg2q3PTxhO3EBWacPf7holRtF8NZyDaO+bxEDVtjffZl6/PNRbX3G02m5ZY8xQtw3gh5+/E3gJUK3e+Qt6UMdPIAztJOOpsZ1Lycn3TS5LsaZqFJuZgB8Io8RyBH36GtTJCneReA8dybVlzxw6XQC+AVE585HXwVuXfmefB4pXoW2Y76xhqON2fVATwlNXbJv2ZjsTtuGNHfPzxh4Zy+CRku5Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aAEm1Pvp6wbZzLTObK4AydDl8vaea26cNGhvVEjoQsQ=;
 b=r1vzm4HKcIAaMPmH9kEH79H7zkwaYkfnusQyGbxqiajDrvGDP5Yhsnf2Mdoh7m+Iwbh2ws8Fr6iJpZQAkQZzT8Dun17UFb4so9D9O0le2pl+uACm/bkdvRBq/G6fun/NgURRoL8LIzJaXhziX0e59UMygAq1TUNOO3LEjj1tz2/BtF0zI5xkdKGLIRlvRuUqutdHt0Zw5mpr10ub8N5JPviUL0u2K60FBzKhwDg5ABLgofBGY26Lly6TBD+N2RU0J1TtDImdmVOYEq8LQg1QnVWLqmL4i4I3VJHbwWsrXoLVk7FBKt/KX30o++jfFdZPjO7pQm/E9cDRMLO+9aDG2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SA1PR11MB8489.namprd11.prod.outlook.com (2603:10b6:806:3a9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.34; Mon, 14 Apr
 2025 07:41:13 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.8632.025; Mon, 14 Apr 2025
 07:41:13 +0000
Date: Mon, 14 Apr 2025 15:41:01 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Xin Li (Intel)" <xin@zytor.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>, <kvm@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<corbet@lwn.net>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<andrew.cooper3@citrix.com>, <luto@kernel.org>, <peterz@infradead.org>,
	<xin3.li@intel.com>
Subject: Re: [PATCH v4 02/19] KVM: VMX: Initialize VM entry/exit FRED
 controls in vmcs_config
Message-ID: <Z/y8DamYKsutPHvo@intel.com>
References: <20250328171205.2029296-1-xin@zytor.com>
 <20250328171205.2029296-3-xin@zytor.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250328171205.2029296-3-xin@zytor.com>
X-ClientProxiedBy: SI1PR02CA0035.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::8) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SA1PR11MB8489:EE_
X-MS-Office365-Filtering-Correlation-Id: 362e1cb7-857a-45ed-ca3d-08dd7b27bb13
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?0tYAyVb2Ejzr8PZpXVFsWtFDIq1qbwOlkdjpURObhth1mRvaEzsiVI2NzVCK?=
 =?us-ascii?Q?PUd7+NF/suBSccOIhWEgiRylvmSVbzsAGWhmZzKgp4hVRQE8n+xBnH1gpFea?=
 =?us-ascii?Q?b8kD/uvZ7Hy+5P0uIn3hLF2Qn66DIU9DM8Opbe0YehnT0TSJ+1RQVWmOSs+e?=
 =?us-ascii?Q?bBgIzVaQlGnEk/toHZTkxBtEDIz8jWwzFLBXPzkHGFJnZt4lMqIu/ajwaTW8?=
 =?us-ascii?Q?KIfj2RnjiElB8uvxqSt6BwIuzPqpTAviEhLdZtvSHevOIMUr3SyNDmWRDOOp?=
 =?us-ascii?Q?2hkHw/PvWx8svZJ6vkmoqqLp3cSncjAbVqs1wWjc/4bp2DpFRiCGNLePyldz?=
 =?us-ascii?Q?hF8UGz8LRqzLLKhJDX5FmSh3rveJ1wBxK99JaN6+lttezfNruPouvpY4z5tT?=
 =?us-ascii?Q?+gFvv5V4Q1lVRTxiDq1AKTtG4BafdUP+ynlKgPJx+FfSUc3dOayGg5RuVa8G?=
 =?us-ascii?Q?9wnp05AUat7DtkSEtXvTFY8T/Q4Z3yZJpJhBx9DtRzU9ulxOikcIDrjMBe6s?=
 =?us-ascii?Q?dHaLT7rXd6/72juqgu92qg+wXhS/ImLbUqtvuHx9A2ETmxKMr7Ox2BliicTy?=
 =?us-ascii?Q?N22oFGpMPTT8dYPQg/FVYl2Kw69L15RQNNALk6bIZySvoaqc0IfmuDtOMzEm?=
 =?us-ascii?Q?ZoOsL2C2uhDzr5MKeMlEeJGoS3t1EVDeouW7EX3iI7qDAEcY+Y0gK+gXu2w2?=
 =?us-ascii?Q?rhfIoL4xGQjMAemNP6Lz7A2CINWZ6ile0rVN5ypl1EMz6riHaj8IzpWC3Edq?=
 =?us-ascii?Q?2VJkYbQif9ICLTXRHb/U3G6kFIzusUNAZ90TtkwVcMwmCtZqDEIxfHUM+Wu8?=
 =?us-ascii?Q?nOSIX35i+WUJ8o3AIiLHuIeZnxMMgvTPKH0Idfx/b33746JdXnlnlZdkXd/H?=
 =?us-ascii?Q?wS6Rjzo+MbjdXJ34xQbE+PY8zHXre1LjJg4VRMoq1Im3Dkr49NcIZR6B8vcG?=
 =?us-ascii?Q?6fpXFZBa4TqYWwYIF7my2XwJ+ZTI7/jiFOHGJmM13grtDkMEOTHpJxpEKWZG?=
 =?us-ascii?Q?PLgEvwBdQD8k0pG2caW34txVCc+B/+zL5W8hHARdJKSxDtCRSZ5S3YF2sBAG?=
 =?us-ascii?Q?+FJ0nG4zQ4QlMA7vii20csQ+8WFugmDc26NvwU6JRbrdh/E+whqNwdp7r7EN?=
 =?us-ascii?Q?B32UEqIzlmnzTg6guK4vphFYRnwAq1fA170b+5ikqSKped42XYgFRLEG8aPB?=
 =?us-ascii?Q?c9aZMnX4S6/i8l8NrmNhOjWdqZ6MnlyKMzp0nXNUOKNCRm7D71iKlEhrvL4T?=
 =?us-ascii?Q?OdHCKd7k/gfI7ETLEgDLLvdrVhL830xpPbr+QJbm8cJ+S5p7njV2ykpMNVmO?=
 =?us-ascii?Q?zWg+WeAggDD17c7ZzSLwrKbl8CXYfd3BMS/ACYI4tAZdAGNWNwLdcrPaCBpD?=
 =?us-ascii?Q?Cz5ljO1tyumX3eTmbk6OveFhqdKa0K7JYnQgBmeCn9R7eplLJ/RSn+arIyIX?=
 =?us-ascii?Q?wk9/OBdAljA=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9eaqL730b9yvzB2jOYPRxyDunZXTTu6imf581uHvbIaBstazy1AepksYXqo7?=
 =?us-ascii?Q?eRDSdipp/XHjzO4p+lo288oCC7sA3Fn7krx26EZwsPd3a5LRtZmFkZqVz/nP?=
 =?us-ascii?Q?Lh61wK9KdlJNANWU8n52Cckh7pDYWXN71Zaw+DntTTCHfwxu28mqLWgt0+tW?=
 =?us-ascii?Q?8N73yTvz5/8XkvIrL0vA9dT04ezjFT+5QBgQFqxETciAQdD0jyFnZctkwKkp?=
 =?us-ascii?Q?Nku7/JzGeRqR2gn03VvMKnbke+AP9hClhviS0ZJXbFSaU/IEv2LEVJ1E3fYA?=
 =?us-ascii?Q?axqVF/434fuI4RzFK5pMCasGtwpNR0RnIeKTp2S80S+2zJGp1dOrHN1jfXEi?=
 =?us-ascii?Q?kjEYFVbhawTBRPbftFongSvfx3jyyP8tV2CCXQyWdIOHbhapaJE20GsN+QMS?=
 =?us-ascii?Q?vIonAMcLCceSOfWxe2NT3ZNSp6cA0rWtlVxnfb2bX+uL2T0KQfr/6o0cDWl4?=
 =?us-ascii?Q?BEmfivnEBK0U1BXA0hEmNZw5RPh6nxTWZ+4/Zvf5NH5bH4DOhQnxNIRwDHwH?=
 =?us-ascii?Q?FRzTiFQhtJzSaRRECVWcK+B6gdmHBlkTCMwnZp/XPMK6vjIj4O3Q7KYG387t?=
 =?us-ascii?Q?3WhWTJ7/8g5A8ELy7XLVDZKdqt9dw3xoR61Bdo4pw/rP3wNY2wMOeB3IZNQ2?=
 =?us-ascii?Q?09q7aoyEiqHfIPI19/A7/AZSFknf/2fPTpbSbASkMKXMf0RR9MQ5XYsBGz0z?=
 =?us-ascii?Q?/yvh5QrXb9qSnAQ7wOJ34cC5VWTch0tra/Kha2V9puq5xDpCbwGcmw0Xspe2?=
 =?us-ascii?Q?TXcWDKtEU6AK6Hp04sKWTlVpaZE/47fIJYoPfPD7PmoZfjT3UqAGXDyyuDKh?=
 =?us-ascii?Q?7GE/LJ4ZmPFUSzTXsafdkw/UtyPJs3zR2C6bI2huIr4SmAnykUSIW+EBt/k4?=
 =?us-ascii?Q?e2bc1i+Su4eLVAFl0WWcsXQCosCWcSHpX9y2iZjwOxe/FHEtAtw1Z0881VpK?=
 =?us-ascii?Q?tm0rwsJzQMKlm7utIA6a1dzAQS/D2vTKrYwkJsrJ9u4gCMOuW0rFKWbZrSbm?=
 =?us-ascii?Q?1a9FeKIwbqDMgZazZze5AR8uz8vy1q1N1gy/GpvtCSlBnxsUAtG1rtCbpIH2?=
 =?us-ascii?Q?uNe2Cyi9uyglF7TqMe6grLLM/pN0Nqr87oUWLmBOi+RPcuml7hVCN87OvXcN?=
 =?us-ascii?Q?5FGSrcRlKg5rhzrqYxlfSWntM6O8OGXitgVkpm6NKS+RvldIsUijYJ5b/rna?=
 =?us-ascii?Q?4+fmFnuRPFMXvtCsK1TOQS2+yICO6f5hQphKakARMoPQ2n3nma4oqLt4aWgv?=
 =?us-ascii?Q?EpOPO2StsSjLBKHbrkPQv/qFKXCQDBuNnUpxtJlTp5jOhtOFeP/mxVEJmreS?=
 =?us-ascii?Q?IJIUqVuIQ5Megu4Qq2e4467iLCD7yuvp2kNTvvRg60NbVyS0cnI1xdDAoNbe?=
 =?us-ascii?Q?bGeoNR5mD9zkLCeyskqgedTNU/iBOvTUhfRpCII4PN4SUKYFx4IwP/txT8IF?=
 =?us-ascii?Q?4ELTCt0hkd1SyTWbuIyJ+y2dKG8EGGZkamd6F6HKQw/RQ6yjlgTODy6nzh5p?=
 =?us-ascii?Q?8ug+4DkMhg+lE5r5Rqc43xH4uAgbzP+CpGnHkT7617LZjRuUTsywumx5r0l2?=
 =?us-ascii?Q?SRK99o9aQXkPj1EEKk9Cn2/nxwn/qm7XnkOF3UgD?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 362e1cb7-857a-45ed-ca3d-08dd7b27bb13
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2025 07:41:13.1328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LHDxi+qHsLB69IJrQZ2D9GpTmo/8LywJFzAO/idoL8SElczLnEbZn2uBldKfRWXlY1yXxlfLQpMJCW26WTqCkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8489
X-OriginatorOrg: intel.com

>diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>index f1348b140e7c..e38545d0dd17 100644
>--- a/arch/x86/kvm/vmx/vmx.c
>+++ b/arch/x86/kvm/vmx/vmx.c
>@@ -2634,12 +2634,15 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
> 		{ VM_ENTRY_LOAD_IA32_EFER,		VM_EXIT_LOAD_IA32_EFER },
> 		{ VM_ENTRY_LOAD_BNDCFGS,		VM_EXIT_CLEAR_BNDCFGS },
> 		{ VM_ENTRY_LOAD_IA32_RTIT_CTL,		VM_EXIT_CLEAR_IA32_RTIT_CTL },
>+		{ VM_ENTRY_LOAD_IA32_FRED,		VM_EXIT_ACTIVATE_SECONDARY_CONTROLS },

This line should be removed. It enforces that "Activate secondary controls"
is supported iff FRED is supported, which isn't true.

Bit 3 of 2nd VM-exit controls is "Prematurely busy shadow stack". Some CPUs
support it, but not FRED.

