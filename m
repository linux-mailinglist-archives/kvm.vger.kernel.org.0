Return-Path: <kvm+bounces-39837-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A90EA4B5BD
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 02:16:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6C80B3A82CE
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 01:16:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F32B912D758;
	Mon,  3 Mar 2025 01:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J8DYMgCP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6041DFED;
	Mon,  3 Mar 2025 01:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740964601; cv=fail; b=IF9YSUzOToN9MkefbYOMFWXWHBcDBdvuhlnr7OYUxOSswCOtr0UZwqkhqQt8h76eXSZ9NerugZ7whqvVl6/zX66De39Er/aWnlO70TxFsbEp0+6d0rMqi6DtbVewo9+gJRhlqTA0VlCVO/n8zGLz9Wnri2+c8aJr8ImqC8Zst4M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740964601; c=relaxed/simple;
	bh=OIpfomfCOIPQP36TEuGt4YB+HOLqhStdjFvHtWmCto0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XzUj9R+b6ad3dLs270M/4LhOwrsWHbla/m3kQxSifjhsQPBFoG1119JXEWi7VoE+vTbl+IiXqDHAv2+uhgPWPmsuh2vIs9hlXUKc6mBJVRsMIKE2gAm+VyKmakiT8uUCOG7jwOddQHfVP6D2PmCFiZjAwls1WNTPYB6bbrxqDWE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J8DYMgCP; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740964599; x=1772500599;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=OIpfomfCOIPQP36TEuGt4YB+HOLqhStdjFvHtWmCto0=;
  b=J8DYMgCPgoDcZ1oATZefXxdM/wUEpkLx27FhgyLTScoomRsRQDbUjiXV
   vsXCCq9y635jAa2Lo9xf79rl2BKNTEQKsGYlvzUYSAP6ExBIj/cxDXKkB
   Go9MAFSAoNtUoqRF1YDsxxDvr0Ax0ZdJq/6A5e3wqRBOeCJFyE4Y3TYwu
   ncYFKafmfPc3/D+SamnbNiTHeZW1zP3qlkLEO9IPSCRJ9uF5lIxJXCMoW
   yS7f5o/7zqks2yZFwluaivzF65sUbsl9sSA2zoXtAcon1QYo9wQvUSVPc
   Uqilz4nDgLHGUT6PotijN5GgLN4xUn7qA33+FMas5dSQTI/g6doRewtim
   A==;
X-CSE-ConnectionGUID: JnBGexSsRQecXDDonA24WQ==
X-CSE-MsgGUID: Rd7eUR3GRAO8XBqnuaIpJQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11361"; a="41678078"
X-IronPort-AV: E=Sophos;i="6.13,328,1732608000"; 
   d="scan'208";a="41678078"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2025 17:16:39 -0800
X-CSE-ConnectionGUID: 7Swphx5ITmeSIOHyn5PCjQ==
X-CSE-MsgGUID: xJzJSEZwTZuEvBAFk7HNbg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="148770838"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 02 Mar 2025 17:16:38 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Sun, 2 Mar 2025 17:16:37 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Sun, 2 Mar 2025 17:16:37 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 2 Mar 2025 17:16:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IYPjo6JfkC9qG+3sp2UfndUptaLcc3gstWpkbp7NSQDpSjwOd8u6lsms8NZYncmUEX9uqq7i6JPniCb4fK6yii0bcgE7vOB1/SgWDuKy+HJl0QZCiqLJSHndh5SmhcR56sr9yo+6mW3hILlBl6Lj9c6s92RMiDAT7ls8MAIWzqIwtH+ViGrSi+VUscfpdi/+WtIopjudK7ZcVWiQi5fxdGE3r79OoE9IhhfgN3Xt+0E1pa6lm0QNINYYBPHZkYqCvyrUb3JsKJthG8fv/cDcM1PRD1eHB5aQUP0lAn35+owaupeU8dz4a+2gm+oVBmsbMTlMOsFCEdI4vxj4eGwi8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0xcGXDXVZswe7GrUDtwYXsdvvKf7fYgV4nAzgC5NRT8=;
 b=yhh1IW8RSDKC0ow38cRtK0MG9A2oKODLz+DcqDi7sdT/fdTf2E3dY0eHIiGVnlCGhVZYUcc+igk689hJOe1s+MKItusk+wuhSCIaRzBg4R7YOT+VV/sXkFD1ydIK5fUZcclMWDvxFx9lT7GSMNklnP1fDvxOV5ZQOC02TCJ2xFjXtE/bTFWpIfUCc6FyLaI68sP/se2oY4BLH+WfIwafwZ1eI7XcNp1mbUShIgxhOpD4CubrLHerwkEDiptM1XB3NVP8GFFh4yqFsSmjHaKWijp5IJcSksr4ab+dcJR2DHyMz6vZNx1KX32en4FwIOHMP5hq2QnS3N0YXiO4AXXjDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA1PR11MB6710.namprd11.prod.outlook.com (2603:10b6:806:25a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.28; Mon, 3 Mar
 2025 01:16:33 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8489.025; Mon, 3 Mar 2025
 01:16:33 +0000
Date: Mon, 3 Mar 2025 09:15:14 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <seanjc@google.com>
Subject: Re: [PATCH 1/4] KVM: x86: Allow vendor code to disable quirks
Message-ID: <Z8UCosKAJIUZ5yq/@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250301073428.2435768-1-pbonzini@redhat.com>
 <20250301073428.2435768-2-pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250301073428.2435768-2-pbonzini@redhat.com>
X-ClientProxiedBy: SG2PR04CA0178.apcprd04.prod.outlook.com
 (2603:1096:4:14::16) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA1PR11MB6710:EE_
X-MS-Office365-Filtering-Correlation-Id: 63b154b8-61f4-41bd-9948-08dd59f1091f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?QWhpcY9DCaPQ4aOcGkGZe+sPc6/RiG0nT1nX22Svi9mhDyVRpg7No8R/rGYx?=
 =?us-ascii?Q?jFVRPN3HPvXIKwUS6Edq+DRDv5xeUxC2Zca6OX5JWaccbI/3vqCQGhopT08f?=
 =?us-ascii?Q?vFcp7tvEMU+dCfWgIArRglxNhuXr54O/P3HvMgXYCn860GwhR5RWb91PiX3g?=
 =?us-ascii?Q?x66mpWqiDta8+e/cmnRg6j8RFSAscW6fhK4DrntBL3WOaXGRt/cvbi/fdDi3?=
 =?us-ascii?Q?qiWNeX3L/4EmxV++lluR1KBzhwF9B5wB9oXMK7e/+NoYdX0PCdh792XQj9wT?=
 =?us-ascii?Q?kf65BDZSkrxnqFwG6TL09Z5gv5hT0OvVJJSKo1lLoZRsOcNdieBvb+NBelsm?=
 =?us-ascii?Q?ngIgqmLlxoSxRqVLrLmSN5kENxE5lKAGhN2oF3ghrRpP8+59fXeOfxKHGHZd?=
 =?us-ascii?Q?FYNqUhUM/JFIjPFYEyBUH3Ny0K55P23o+BrnnLzAWYP/EmzvfG037TtEk2mZ?=
 =?us-ascii?Q?nqYFS5emtr0WUJtHroMOByL/1DwxoE0eh4ieP9tfKed4sKG1Y9MKHMR27yJx?=
 =?us-ascii?Q?pUTrbMM+kWg4Fva7cfmQHuArVl/7yQ5G9isbeXLVph1KOb8osL69SM8YBFoU?=
 =?us-ascii?Q?naB+me8jLCbQb7w7wm4OlIWG6zEXa5mGxgXb3ByQnYT9CvjcK0R973+wTY5G?=
 =?us-ascii?Q?Se6x/0bgKWSkGm3tvj0EuZGZGJMjMeeY4Bz345DtgxislVaFjkjJm3Wlqn/u?=
 =?us-ascii?Q?AONvZx/OxgqMQ0qburTbLkkLRvqPkz/lZKD0KdE/Cm56M/a9kOurjTSbIDVI?=
 =?us-ascii?Q?DKstOqpZD13BKBFTtxOD0MhmWk5vESe+3DzKZI8SwAroxnOtlTs2lu2mYnYX?=
 =?us-ascii?Q?9fcEuEm1x22gYl77soYs0LDks4LzSJ4ZafjF+EPOpN3mNxN4AzlKEAJulDSt?=
 =?us-ascii?Q?BSF3PxnA1Ghn9Cyid/vcyepi0pX/0jy+zh9lXZbI9jz5vp4P7VmaA/o3daCH?=
 =?us-ascii?Q?EPVSJswHSXLLUG0E7+GY69cBm8tA00eLTBLj4sHl97C1Dk4iCrxOuFXzcuP6?=
 =?us-ascii?Q?Ey+rXeBDrsnpkzwFDtMzIWG9fsxdLOuXc0dM4y2b6Y7odjDmdYyaDkt5hK+E?=
 =?us-ascii?Q?iXpOInQ660imJ7ye3s3S6v71tUHH4syU0vkU6g2aBrUUG1+VdTo4QkGVDcyR?=
 =?us-ascii?Q?aniOb/2pVaKJO6C3Qz5LiKiaJv6G3nK4RqcfN7uFf2hSJ2IllAFC/BKUurff?=
 =?us-ascii?Q?vJF1fsV42FO2mZsX2GjLff63Fo4YsoFo2dOxLMperauYJDKrr5NQhMrROPCb?=
 =?us-ascii?Q?mpgrLl0iFCpvhKzOth3u6emyD8TpSCt3a8XljTDnmu44U9wLbERVr2uwb95r?=
 =?us-ascii?Q?6lZSoq1eI09zalRs/vuILqf+xxPN4IH2wHBIWHa+gQcOGn35gITuesnAqvkc?=
 =?us-ascii?Q?d1oJ7+a92znxPb7Ma+SKoqN0dDWn?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2xJpJJFr1Bge8LQr1OBPtf94rxdZ9dIIJmqjm6Igrb2To4+BjKR9XzZKW5q7?=
 =?us-ascii?Q?Cz5EG9UAgJfsGWTipJ2yQW52mq8oehJ/EBCIeYAaP6Hl4yC+V0vuvcSaCEUf?=
 =?us-ascii?Q?Q28x7DWoiiXFvFlF1nY0lFVTxYI0piJ9g1vmzEtn0JH2FT6ZbSfG6FNTPND4?=
 =?us-ascii?Q?25+N9lqjMH78hN622DA7GQ4dwGjMoQ6rcj5Smi2OlC0XURjQhgqhR7M9hLZn?=
 =?us-ascii?Q?mYqfRxO6Xe3r75482V93VAw88jj0poH/pxNiq8Bnq6vL4U7zFklwxWnxgWfE?=
 =?us-ascii?Q?qrBURjmq6bed1r0i7X4nDCqPcYMW7n/28mnIlBTIHeme5mf+xtlohy7dqlYO?=
 =?us-ascii?Q?tD3ViEwgG8mxSGK5PGF847jOThy01h4rXP0dcSutOX24UQOz58sr2ISX7x4z?=
 =?us-ascii?Q?q8s7QzDmoWgQxq9Y49Mzp6T88QG7FPNzPbJ4mCYC+a952vMoe6COgqd2E/KE?=
 =?us-ascii?Q?lirFPNE6dB/IaoNwN1dHkBo6qmFxo8kQCITzNCdG82koGz5xZuGgI41BCuJ+?=
 =?us-ascii?Q?s0zzXUlEJnzw7vYskJPkGpKhyIiaQaAW7319aEnryiwRi/Tq8RwnOra6tr1B?=
 =?us-ascii?Q?TC6hNeY7jYq9dTdL6l8OF9Y8mVIUBSuDrfUsEpCD714EMz6vLFEcZRu8xUe7?=
 =?us-ascii?Q?TfIK02VhG545YPNTSsVt+tw+LD0K/MgMLkpYOnrRJQW0eRyQnXq8RoefPRXi?=
 =?us-ascii?Q?Dt+v+djjBn6VIKG9uit6hpjAlmmqiFjbVR4DwsiJyyi4ygJG7lxhY32ts8IQ?=
 =?us-ascii?Q?I59dZDwapGfCJj86wNsqhbtWe7ARQNmtNQ6HXsQmT7Jx2I86Aq7XqoYO60r5?=
 =?us-ascii?Q?p3d82YwsQ+HidJ+DBx8SquGaQJedoFeRb3Ay0eHjG+ORS7mMWSZhJHWcELzA?=
 =?us-ascii?Q?q2N+GvvEAsmGDY5JMjfk5H1MUb6Bl6qpFmUo3wn5gJnhaKI2i4+uaZIA5l2E?=
 =?us-ascii?Q?TrsWMYmik0/qWK7UeuDwlt9p6vdHUfpmlBniUw8Sl1mjZj4RSGfW4jgs0rDK?=
 =?us-ascii?Q?LWk7mgPBY+Q31Xl+EaQVxV5zFGSJDH1PPqwI9sWPL5mr8xpa3tuIO6VdgJnW?=
 =?us-ascii?Q?XgSOtE5bP31YKBiLR5Rp1pPSaZ57/cV8zp+DnzYOahZq9xInnn5zj1IyhIkq?=
 =?us-ascii?Q?hfTSIUjQAYLmqGkiCuYTHVJDnaTZa8a3ujyaknBC53XcrAM25f3mYOvG8uxr?=
 =?us-ascii?Q?2c7P4mc3kgl+kEL8rG1bMAZoYq3hkgnRsh+M+NEY9uSB9FLcqVkO8e2/pmdw?=
 =?us-ascii?Q?2bAV0eXxCZPlT789021kLcZya3jcL7x+svlEm9g7r2TEJxqy3GKBEPTmR5Hd?=
 =?us-ascii?Q?opEHyzv4aQJRne2aNJ7t2th8uDCDB6orCp0+KcYJL06+MlNg5Xj/dven/yIE?=
 =?us-ascii?Q?UPAMrhNkmnUD2+ImoM8cS208oWpvvJ8JjwrC5+lsqE4dZxjv1p1ejNu2Ek9V?=
 =?us-ascii?Q?knEz7NisNr9a27FZE82Kx4K30RatiOWUyiul890E8z5ojEr9FHScAznxT5YO?=
 =?us-ascii?Q?1pr6yFjGgVWWWoD2jhgMG8+FWS5nMMFIzi3xqIdQX5SdUkCIUNIWHX/9clDv?=
 =?us-ascii?Q?+orGOtJC0ll5IDj3PFZ4LmcKgqNUmxb37BLM0z1b?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 63b154b8-61f4-41bd-9948-08dd59f1091f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2025 01:16:33.2607
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DA2RJcuJSKJgP63v7PCAFZWTbVZzE7VCdc79G+Z9Zn1SC82m2hsBqf8p2fsy2e7RC7CEGTribuhdxT+U2tt1CA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6710
X-OriginatorOrg: intel.com

On Sat, Mar 01, 2025 at 02:34:25AM -0500, Paolo Bonzini wrote:
> In some cases, the handling of quirks is split between platform-specific
> code and generic code, or it is done entirely in generic code, but the
> relevant bug does not trigger on some platforms; for example,
> KVM_X86_QUIRK_CD_NW_CLEARED is only applicable to AMD systems.  In that
> case, allow unaffected vendor modules to disable handling of the quirk.
> 
> The quirk remains available in KVM_CAP_DISABLE_QUIRKS2, because that API
> tells userspace that KVM *knows* that some of its past behavior was bogus
> or just undesirable.  In other words, it's plausible for userspace to
> refuse to run if a quirk is not listed by KVM_CAP_DISABLE_QUIRKS2.
> 
> In kvm_check_has_quirk(), in addition to checking if a quirk is not
> explicitly disabled by the user, also verify if the quirk applies to
> the hardware.
> 
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> Message-ID: <20250224070832.31394-1-yan.y.zhao@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/vmx/vmx.c |  1 +
>  arch/x86/kvm/x86.c     |  1 +
>  arch/x86/kvm/x86.h     | 12 +++++++-----
>  3 files changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 486fbdb4365c..75df4caea2f7 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -8506,6 +8506,7 @@ __init int vmx_hardware_setup(void)
>  
>  	kvm_set_posted_intr_wakeup_handler(pi_wakeup_handler);
>  
> +	kvm_caps.inapplicable_quirks = KVM_X86_QUIRK_CD_NW_CLEARED;
As you mentioned, KVM_X86_QUIRK_CD_NW_CLEARED has no effect on Intel's
platforms, no matter kvm_check_has_quirk() returns true or false.

So, what's the purpose to introduce kvm_caps.inapplicable_quirks?

One concern is that since KVM_X86_QUIRK_CD_NW_CLEARED is not for Intel
platforms, it's unnatural for Intel's code to add it into the
kvm_caps.inapplicable_quirks.
If AMD introduces new quirks that apply only to its own platform in future,
they may have no idea whether it's applicable to Intel as well.

>  	return r;
>  }
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 856ceeb4fb35..fd0a44e59314 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9775,6 +9775,7 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
>  		kvm_host.xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
>  		kvm_caps.supported_xcr0 = kvm_host.xcr0 & KVM_SUPPORTED_XCR0;
>  	}
> +	kvm_caps.inapplicable_quirks = 0;
>  
>  	rdmsrl_safe(MSR_EFER, &kvm_host.efer);
>  
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 8ce6da98b5a2..9af199c8e5c8 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -34,6 +34,7 @@ struct kvm_caps {
>  	u64 supported_xcr0;
>  	u64 supported_xss;
>  	u64 supported_perf_cap;
> +	u64 inapplicable_quirks;
>  };
>  
>  struct kvm_host_values {
> @@ -354,11 +355,6 @@ static inline void kvm_register_write(struct kvm_vcpu *vcpu,
>  	return kvm_register_write_raw(vcpu, reg, val);
>  }
>  
> -static inline bool kvm_check_has_quirk(struct kvm *kvm, u64 quirk)
> -{
> -	return !(kvm->arch.disabled_quirks & quirk);
> -}
> -
>  void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip);
>  
>  u64 get_kvmclock_ns(struct kvm *kvm);
> @@ -394,6 +390,12 @@ extern struct kvm_host_values kvm_host;
>  
>  extern bool enable_pmu;
>  
> +static inline bool kvm_check_has_quirk(struct kvm *kvm, u64 quirk)
> +{
> +	u64 disabled_quirks = kvm_caps.inapplicable_quirks | kvm->arch.disabled_quirks;
> +	return !(disabled_quirks & quirk);
> +}
> +
>  /*
>   * Get a filtered version of KVM's supported XCR0 that strips out dynamic
>   * features for which the current process doesn't (yet) have permission to use.
> -- 
> 2.43.5
> 
> 

