Return-Path: <kvm+bounces-62276-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B5C3C3ECE6
	for <lists+kvm@lfdr.de>; Fri, 07 Nov 2025 08:46:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C9F5C3A5400
	for <lists+kvm@lfdr.de>; Fri,  7 Nov 2025 07:46:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DF2F30EF9A;
	Fri,  7 Nov 2025 07:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JqrAgvyJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A321E1A17;
	Fri,  7 Nov 2025 07:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762501546; cv=fail; b=Kt5PAQCdckOLGbsv1DQP2uvhTHzwr6eqIs2lgH5V2cWveg1614DHbKSYG9krq1aQ4/JSgtJpA8kV99A8qZ1VqyPVpKCA+oE/NHWKhHWNmSjRsU2ZXuH9W8dn3+OfmKpR2qDZJrKJLrH+5mRZMkE1TxVfkX2LtCUd0xwzHHhTDj8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762501546; c=relaxed/simple;
	bh=h3DdZXIG+1YUCZ31JTrWnT3AC6cjg27msDkwssZCl4c=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=BgQcMo9r61G/IWckV6w7YVJISF6hKnL7hgVbKhX+TfSmOqb5S0TWR7sYl5IxktS4UrZ8UDJyDhTyyZEGTXVQc8sjrhMzUe8pmrm4M/QLQ+cVRINYYZjU8VgudwEfqQ2r0C9mHwjWdExo1CcVXhX3W4XfAAm+xSgM/Mf/SsnDswE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JqrAgvyJ; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762501545; x=1794037545;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=h3DdZXIG+1YUCZ31JTrWnT3AC6cjg27msDkwssZCl4c=;
  b=JqrAgvyJ6CAAhPur4uB/fZmwTAjIQIqPYCvvg+v3RM/0OXvVzZuafdhk
   gltJNctp/Rd97+2aA5/ZYLqzzKO2yL8rEs/SC/jmXQkKjgjS0V8+1M32r
   Nh47jzGw976II/KFbR07ExWTRfSTL958VIR++5HrrsbTNWn5Jkx9nRn2+
   wS9HTY6uJlWRK2VLE8MXTDQPsNOTmI4RaFiNJHza0AoHMlbZGdOHumYlq
   lJtYRSU7rIdmXk5l7iBxL5EQR8f72rm+E/ipIiC3hyahkZ98ZBRYVcW6p
   ZWUgPJKWHXSYF9kQyUtvM64DJJICeCPLob3GmCVd5KSrW+kUwPYPL3Hdp
   w==;
X-CSE-ConnectionGUID: mssH7ZPBR1SaUz8WDt0SRw==
X-CSE-MsgGUID: SNx2ie7NSFyM9jSvJVT5Tw==
X-IronPort-AV: E=McAfee;i="6800,10657,11605"; a="63660352"
X-IronPort-AV: E=Sophos;i="6.19,286,1754982000"; 
   d="scan'208";a="63660352"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2025 23:45:44 -0800
X-CSE-ConnectionGUID: JoSrAvWIRXuhNFUBGHeSTA==
X-CSE-MsgGUID: YpJ0rAS5TFes2mfRYwUrzQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,286,1754982000"; 
   d="scan'208";a="193010665"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2025 23:45:44 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 6 Nov 2025 23:45:43 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 6 Nov 2025 23:45:43 -0800
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.37) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 6 Nov 2025 23:45:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vXBzyiE32QlUVzrn01EKCesV8vHqofeQhiUan4H2uLa4ucBvjOan+VcApS3iiu9Q1hNxD3Lwe1l9/dUf4AsUBE2Y+Kqr1K+b7r24iTXLxqu+oXoiS6P/EGAMwLdm3OzcUPQAPB65dWGNbuJJvyQhWHvvjWma+4/9StRHrH8zzlf63lC51g3yA7C84nrVWlvDrLbTf5BpupC0Yud5Y/l3ypR4TO01WStnYPUxLleFfCb+omDM3oihj57v0W7ewPyIsvY5HmxbcXNFJxVq406tmFZ8LvD00dzkmhb7/GgORsRhWsnkCkWe9E9wQ1/YSVv51i6J/koLN+UKS5txDNoAtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/EXZsSEoDvmvB6zQQtN1OgFrL/33e29EcaA7xR88jSU=;
 b=R6boLJSTtaf6HYmAr5mK/i6oZ5EKITwX5Q462zb1nl0m7Sjauc//oa3VUUTOTdYKRBPE7qjvrdukn+/WYFQGb1SDZYikxB4MMszdb2FJEmuc5Y0i4WzyDN8Uwtj6K3c19LyYR32XvbHCJzkgwREkAIYYfUzS7RNrgC9Vv/1RWSk1ARQsqXcJ0yBRQL91Ov1AREeh+BpKJZ45ILZaiKjnXfWH8ik6AEpaV3EFcM2R4IaYw/xWTH16qGJzsKjmq3IuXF1UpmYp0dAPUkMRA4DB7h3BeaMiUIWRSIS2diavdur9qpEkQhRMPDzEWTsWTN+qliMBz89t0o+h+pTxFqE2NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH8PR11MB6611.namprd11.prod.outlook.com (2603:10b6:510:1ce::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.12; Fri, 7 Nov
 2025 07:45:41 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9298.010; Fri, 7 Nov 2025
 07:45:40 +0000
Date: Fri, 7 Nov 2025 15:45:30 +0800
From: Chao Gao <chao.gao@intel.com>
To: Dongli Zhang <dongli.zhang@oracle.com>
CC: <kvm@vger.kernel.org>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>, <joe.jin@oracle.com>
Subject: Re: [PATCH 1/1] KVM: VMX: configure SVI during runtime APICv
 activation
Message-ID: <aQ2jmnN8wUYVEawF@intel.com>
References: <20251103214115.29430-1-dongli.zhang@oracle.com>
 <aQmtNPBv9kosarDX@intel.com>
 <9a54bd8d-ea42-4c9b-afdc-a9ae3c31b034@oracle.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <9a54bd8d-ea42-4c9b-afdc-a9ae3c31b034@oracle.com>
X-ClientProxiedBy: SI2PR02CA0029.apcprd02.prod.outlook.com
 (2603:1096:4:195::6) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH8PR11MB6611:EE_
X-MS-Office365-Filtering-Correlation-Id: fe7e8fb5-ad1e-4c1d-737d-08de1dd1a60f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Q4aMIm8iH3xpEp0xl/6Rv6Dmq/SPw0b/WqiPsloQlJD8guMAhkhfStzklyDi?=
 =?us-ascii?Q?rJ8z70I3GfrVBYRrytlyw8ffvi2gb7PzzI/bPL6x3aThk6yxZJX6h61WIIGl?=
 =?us-ascii?Q?rcE3Qx8HrVwc6swrtN4FSpJGc/y2aQtpqzrcHT+2LJjXTSYVjOZTy4CcDEn4?=
 =?us-ascii?Q?mK2G9KvBFwvxtDSr2LADgpUa3/Eju+rmSzmTR/m1/t2OvQNsjiDFc2yRZP2X?=
 =?us-ascii?Q?H42Ug+02JPl6ti8RddOsKiJESHHBs6HqXPVJoZiPaau0X2Gh5mYI9aLWN9fi?=
 =?us-ascii?Q?/LCZcnEaUXl64vYHexHvh3eBPeaz43KFTKm/5FztvQXoTdCgwttNYVe6tf61?=
 =?us-ascii?Q?FUYwf09cuR99HHu1cTFo6fD0hKnVwQ9Ppm1aoN43tFM3fCd+0R3kfGnKkXyN?=
 =?us-ascii?Q?ED8ZiVJmIujGSIF3H2sj0Kf15TIgdiczZAMijZITTmWBS6LaDOLGPhnBDU+Q?=
 =?us-ascii?Q?ryaYEsI5nei41mGWbG9qCgZXbOyGx8AsvlIAYdfTvNBfhVkReZqVh31Njn3N?=
 =?us-ascii?Q?WhPZnZ4vLtI+aivG8YL3OWzh9iqUUcDuQQdMrdsg7UeFT24n0Y/2f3iOfvlI?=
 =?us-ascii?Q?T3a1Vhh/F1DeJJqjS4JUEKDGHbeU0NE+h01ntwuaUdNmy8jRhBibbK1IFQfA?=
 =?us-ascii?Q?FLWz25UqcXQkuNJTIcIVrN7ssohO62wD4Bz3ZK+raa7dgtUV2cuMJs66Idqk?=
 =?us-ascii?Q?9XNPGPiyg94ngfQd0TWiBMsXXsHH93awrCQtPoP4OprTf5t0NYUDfcNxQY5h?=
 =?us-ascii?Q?j9MaJWdf0pPcePTJCULc7MqTF182vSBNwnVxcTYUlboO186PQFCTzAsfcse4?=
 =?us-ascii?Q?2HtGDTJ5H9EFG89iQr5Y8tUq7hbC6G2MKac8pN0SISWExuPOmNXlAcdSAT/n?=
 =?us-ascii?Q?X0P/bD3SNLn9fSeBy31ONWam5Ewb50O6LsL87tPNZx3uit5FZiXWzM9kzqDC?=
 =?us-ascii?Q?XppLFa5KxI5v15dRdsEcolA4lIfDL4TZI3MQ9QYQ/gWrVM1rjpj4ztnCb6C4?=
 =?us-ascii?Q?4NHCE9MRE6DXwwwAhu5nhf9QXjW6clRkwFbSIJQV8y+oUffVpCk/FCimKQ7b?=
 =?us-ascii?Q?Kb933qSDgaNfPh5qlV54GInY8qDctgAqWiEgB5k4QUqAWygL3iSK/aIXH1OU?=
 =?us-ascii?Q?r8ABn2ypSGTf3fjX8GY2djzbvLd5zEckaHF8yi95h4skAu7qfh5hUF8iGDFl?=
 =?us-ascii?Q?js2/HfgH3E3/S/UdfxZDg8Bg6N6CM9jODvQZOvNCfF3hyP7V/omOna5A0LPZ?=
 =?us-ascii?Q?whGUu31rTisdzQVOwV3ZVtN6JU3dBKFcSjDo8WmlbKXO6+5gWSnfPR5ftd/C?=
 =?us-ascii?Q?SRXmEEptdqYKzUc02aKp4TF/ZNEupeft2PNjoW1qXg0xhPGmwQ2dxHvRfkNA?=
 =?us-ascii?Q?gozfhoxKCM9pWmhANPiunZoG3fSuAEvQ9jcFfP6YJGovb0g6u3An4xQqmkG2?=
 =?us-ascii?Q?h6IQO6IO7wGfZqIo3Km/kc2DbSizSeY2?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4cIrWuaOJJ89Lw51g8o85if/VmGp5HLfRPLQ5DKHE6nYNawMc770TQthc1EZ?=
 =?us-ascii?Q?B9cxbd3YpJLQVzU7vYZZokLbYGlm8InMxMZ8fA3EpJMFhn0h+i1C/4ge0XDH?=
 =?us-ascii?Q?I3Qn2Y7++c3TBLFYmslLHE95yrh7g6Gu5FMJWFEur1FDYT2wcNsUuXf/YZCJ?=
 =?us-ascii?Q?segicgRQdAl0585sRo8Uugz3d6ZLlBLW2nyDJOTiRNXEeFU1SIr06g6SO6Q2?=
 =?us-ascii?Q?gyuR7F6TnjLqA6wFaMi52v53MmBEAuMs3fUFVhyTaJOh5Ctq5rWkbfVUVfBt?=
 =?us-ascii?Q?IrQfJp1lhvAwg1EXbDpbZrSfUN2obbJfE0NqsEu3BzXZy6+uNQwnN4UopGCF?=
 =?us-ascii?Q?4rH8m77mf85RADo6Yn0bHZfONY/xd8Czv/pj85PaoK4vCDAA8W8rl9XUQ27o?=
 =?us-ascii?Q?1iZc/Um+2qVFmrL5JWnweAwN6fU/EFDpB1O0TAVnvW2XDrF0hkXVYxV1cHjU?=
 =?us-ascii?Q?hSx+hLnUQsJgZl5L1N9ZPEnuUrgwhrJD44+MAQYIHn/QeI1dKlGu4O1bgwe/?=
 =?us-ascii?Q?qRSrRuVImZIHbMY1wCn5ry2BPk62gjgzqHwIFisQ2R7qeH3EXlcMp2wstmD0?=
 =?us-ascii?Q?13/2HpnNZC1ksvZZye2ZXyPBCiz6Ilmrq6VEDBMWBotsyzvHDHaAlP4TbgXJ?=
 =?us-ascii?Q?iGLzQL+2nlBY1fUgBOBYqOiNNxnW7YcWz2/9CbLMyqXMI5ThCF+i/2McuHsV?=
 =?us-ascii?Q?UzpUnX66w5R4KJQlTQgoBYUk6IFihIzdR2uDfepD09FG3gY3iHhLtHD9T2ky?=
 =?us-ascii?Q?z0uFZCE3aZLwnv4V27MHHo9XZDmm5GFyofKaikm62N+FK2vX8f1IcJ33o+2p?=
 =?us-ascii?Q?HLDI4b7O9VPrSdUDgHWcop3Cpm8vd+Wi+yKnGZLhd/+2MDWWrGED9nIDIiwr?=
 =?us-ascii?Q?eiepXOZrkbv5mkoall3BLRTvo8QGILrCznimSsmD8Q431Z3K9UvQ3pfxqGkv?=
 =?us-ascii?Q?9l22duc3cfVJ1ZTPEYZQsHJJqzvoaBMwYsV0eOQeeEAlop7OJQ9hpRa5q7zy?=
 =?us-ascii?Q?oprkjee8u56ruJT0dc7D8LSqBArapxsbuWFzeFknj4pCe364SkK5ziVnjoLr?=
 =?us-ascii?Q?QxRumpKfGOWlrWoxWzBuC9uTGdzBUk5cmFDt4LCGe2MjG0aJckycYYTPaZx7?=
 =?us-ascii?Q?7DC7JYNPoIruk42ch2xy5iyISVw+I3WH7wqCXWFP05ffcEOn6lxm0SdO1VsU?=
 =?us-ascii?Q?r5jwJ9rv4Ut5VpqBYlUsyUs0cZFbGauGL/7KiF4q/YBwVXf2J617yi33WJDt?=
 =?us-ascii?Q?UwsZ66Tu/lL1XZ4whQQ4ldMCiKtw9xNB0qqUkpLmhGXSfOWtnVoeHxtE6bRh?=
 =?us-ascii?Q?HOPwvYCx+IxohjOAZXELR46PhIfLeA5gb3XIr08tAr3hl/7kCI+Vc4Qet3OI?=
 =?us-ascii?Q?8sS0KkzY9aDzWuVQBvBMpGb1bi5YXFxo1XcYkzpYgng9sAn4o4e67RhCTy7s?=
 =?us-ascii?Q?irLkdjynMPbuJGZRJQfJ646pbikOC2VKM1YvSts17kzYZFzXFJR2uo8ljXTX?=
 =?us-ascii?Q?dYcNa12UdYk4mdcLUqNaQVMOdUmi2Vwa7tYhdg/0l5xqb0SNgu0vaFeXLpar?=
 =?us-ascii?Q?+FLIo2qJqX07MWcwI+EgYMcBrfE8RxawQKl7AvJn?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fe7e8fb5-ad1e-4c1d-737d-08de1dd1a60f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2025 07:45:40.8919
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4PTKUWHMSOXQm6yKnRXDmd3ItueKba6Sh5qFXxNo4mPvJA0Gyv+Q49kbAtQMyo9WMJYaysExvNAt1A/zx5E0Ag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6611
X-OriginatorOrg: intel.com

>> Why is the nested case exempted here? IIUC, kvm_apic_update_hwapic_isr()
>> guarantees an update to VMCS01's SVI even if the vCPU is in guest mode.
>> 
>> And there is already a check against apicv_active right below. So, to be
>> concise, how about:
>> 
>> 	if (!apic->apicv_active)
>> 		kvm_make_request(KVM_REQ_EVENT, vcpu);
>> 	else
>> 		kvm_apic_update_hwapic_isr(vcpu);
>
>Thank you very much for reminder.
>
>I missed the scenario when vCPU is in L2. The __nested_vmx_vmexit() will not
>call kvm_apic_update_hwapic_isr() unless 'update_vmcs01_hwapic_isr' is set to true.
>
>However, can I remove the below WARN_ON_ONCE introduced by the commit
>04bc93cf49d1 ("KVM: nVMX: Defer SVI update to vmcs01 on EOI when L2 is active
>w/o VID")?
>
>Now we need to call vmx_hwapic_isr_update() when the vCPU is running with vmcs12
>VID configured.
>
>diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>index f87c216d976d..d263dbf0b917 100644
>--- a/arch/x86/kvm/vmx/vmx.c
>+++ b/arch/x86/kvm/vmx/vmx.c
>@@ -6878,15 +6878,6 @@ void vmx_hwapic_isr_update(struct kvm_vcpu *vcpu, int
>max_isr)
>         * VM-Exit, otherwise L1 with run with a stale SVI.
>         */
>        if (is_guest_mode(vcpu)) {
>-               /*
>-                * KVM is supposed to forward intercepted L2 EOIs to L1 if VID
>-                * is enabled in vmcs12; as above, the EOIs affect L2's vAPIC.
>-                * Note, userspace can stuff state while L2 is active; assert
>-                * that VID is disabled if and only if the vCPU is in KVM_RUN
>-                * to avoid false positives if userspace is setting APIC state.
>-                */
>-               WARN_ON_ONCE(vcpu->wants_to_run &&
>-                            nested_cpu_has_vid(get_vmcs12(vcpu)));

Thanks for testing this.

I think it is fine to remove it. The warning produced some false positives when
added. That's why we have the vcpu->wants_to_run check here. Now that we have
new false positives; the check is less useful than expected. But let's see what
Sean thinks about this.


A side topic:

I am not quite sure how vmx_refresh_apicv_exec_ctrl() works for the nested case.

If a KVM_REQ_APICV_UPDATE event is pending, __kvm_vcpu_update_apicv() is called
to update VMCS controls. If the vCPU is in a nested case, vmcs01 isn't updated
immediately. Instead, the update is delayed by setting the
update_vmcs01_apicv_status flag and another KVM_REQ_APICV_UPDATE request is
queued to do the update after the nested VM exits.

So, __kvm_vcpu_update_apicv() gets called again. My theory is that the second
call doesn't update vmcs01 either because the "if (apic->apicv_active ==
activate)" condition becomes true and so vmx_refresh_apicv_exec_ctrl() isn't
called again.

>                to_vmx(vcpu)->nested.update_vmcs01_hwapic_isr = true;
>                return;
>        }
>

