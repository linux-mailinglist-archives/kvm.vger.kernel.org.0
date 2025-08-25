Return-Path: <kvm+bounces-55583-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E6508B33385
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 03:27:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C662C1B22564
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 01:28:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25BEA20CCDC;
	Mon, 25 Aug 2025 01:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hsIBYAMS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F658834;
	Mon, 25 Aug 2025 01:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756085253; cv=fail; b=e9RB8BPQAZbe2A6Q2etCdzjmzM1t44JmO7brdinKCgxxmaEJVPLZP+boTfwfJMdqFd14JAX9WnUdCL3X/ZOYJMkJ1cmsWzEcvDDqN0zgLmN9m9YzqqlKrfJCdjSZQXb12+qpVoyt/svFvl+0iBHsRfJOcsZOa490kWUbjdyQGXI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756085253; c=relaxed/simple;
	bh=vV5l+ffXBarqfU7/F4A59B2gQtImvPVowC1/I9lXTlg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=R/WACx7V0n9RVG557W5aZ8hXgpolX4I93TcicS3kjdupDliV8cIljyODm5oycjKs2+Etg/UcMfrSwSWBpJhOMg1qBavFG/gupzSVum/RIaTE1vAMiTeX0MddxcEy3fLfplIVxXLJwbNd4BhoAUaOp+Kopsh4Xx1//VZhidgIptY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hsIBYAMS; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756085252; x=1787621252;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=vV5l+ffXBarqfU7/F4A59B2gQtImvPVowC1/I9lXTlg=;
  b=hsIBYAMSKGjJzBJt+3Z6mprRWRWN7iReOiMkJ/lgxTn+QazUotg1uH6p
   l6omj6wtAGyXUFqP221995/tiS6prFLce2aacncuDDD/8L7oHAxd8O0XZ
   Nv+JZr5qMTBfOzZEuqwbAaZDDaF5c/fWMDxEk4aTFo4HmhL9zdwbYF8Bh
   svf+6L4fuJHv4+OEQ++L576g4TE2LaEgoE+sFXCY4M75GllkTEO1IKd7V
   9nmpAlL3YnZbhoWX9fr8qra41gtfdhFy3ktAYKr8CU1B3VUwEi1mgCjTv
   ya/kf40fcGdOMSpcKSQBMNYlUwJ9ICIAViRpqaBYtmD6pKbQOgGYqyZo9
   w==;
X-CSE-ConnectionGUID: onYf20vhTTucRQ86n/BGEA==
X-CSE-MsgGUID: eiYkFLUqRm6hSHX2dxeJEg==
X-IronPort-AV: E=McAfee;i="6800,10657,11532"; a="58361997"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="58361997"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2025 18:27:31 -0700
X-CSE-ConnectionGUID: Yax5tlNeQNuIsGdDmeIt7Q==
X-CSE-MsgGUID: RX51CYmuR2msQhMAa39cpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="200107441"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2025 18:27:31 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Sun, 24 Aug 2025 18:27:30 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Sun, 24 Aug 2025 18:27:30 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.46) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Sun, 24 Aug 2025 18:27:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dIczUWlbbiu2np+K2ANwfqOWYrR9Ow6XRrJVcUDsBwpxfntBcpPxsQOeBmAtEOVXMROMSS4XDbZhpw6s9/inifxleFXqrKp0cnpux279bxtrUu8Ky1qOI1faIY28Eyd3xgpMA9VsZDukYbzUrx9z4H2NsJR7SMXFveaS8kF3k9oyBN8biPl+fT0HGGl/zhTaLaiD7BCCR87jmx1fayIUjROFUVi/rFRWG3GlhzMmqCN7Eb3hY4Okx2k9qN5lhE0u2Vin4ZQsafh35QWNUcuf8HsQyff75yqINurSSJVTF8vIELkB5zR0X2S1T6QwMjMpFwQTVSQ0NFmElEheCzoEzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MKPiIfiiNl/Xr+QlfZjmOVYtl9rqeDPDa7q5Fyxkg10=;
 b=WWOFnORPHKIbT/XJ8U4llU2pcWm7hbym+ojZIf7UyGTMPd8kN8du/tUsNxXeI+tMD+PsbPsIp4rU7kbPtGDZWv16Wx+K9aStv2AdOcrnCIhGUZt4/ycud3VAoX+M5ynTCx3myPbhe+KE7jLNkbtIDgtxjHRnBFm9S0iq2HQRJdpk/guISh3j2PCIN7dKkuHuNStjaLVHRdKedQU3o09HCJUAezun0JZuX46zCsZDWaiTPteNznGTuIp7N1DZfdtFxqShUHd93yGoRfjdDTijF55u5VxrSoDFyiPMsBWnW8484G9R/6Yl3d7hJQs+Gd4jJsNofUAkTjykgYOOSO9iOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SJ0PR11MB4895.namprd11.prod.outlook.com (2603:10b6:a03:2de::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Mon, 25 Aug
 2025 01:27:28 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9052.019; Mon, 25 Aug 2025
 01:27:27 +0000
Date: Mon, 25 Aug 2025 09:27:17 +0800
From: Chao Gao <chao.gao@intel.com>
To: John Allen <john.allen@amd.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>,
	<rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>,
	<weijiang.yang@intel.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<thomas.lendacky@amd.com>
Subject: Re: [PATCH v3 1/5] KVM: x86: SVM: Emulate reads and writes to shadow
 stack MSRs
Message-ID: <aKu79ed+IIC2tjWj@intel.com>
References: <20250806204510.59083-1-john.allen@amd.com>
 <20250806204510.59083-2-john.allen@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250806204510.59083-2-john.allen@amd.com>
X-ClientProxiedBy: SG2PR04CA0177.apcprd04.prod.outlook.com
 (2603:1096:4:14::15) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SJ0PR11MB4895:EE_
X-MS-Office365-Filtering-Correlation-Id: ae5a7229-6229-4c7e-15fb-08dde3768d83
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?DPEuzs9ayS0CYkGozX/2tOZ0oSd93WfVCDMIWx4QoAF4L4rwm1BeorXdo4cD?=
 =?us-ascii?Q?qvpnp2Py3AAhvm2Xv0ZISRxfBWrERksV7tq344vd4FB1ypSvRgi3Ta+iJbxf?=
 =?us-ascii?Q?+zb2SiSGG2m9PL+wIQJJNS5xYlXChCrX9r/ESRAVtbSOOd6V4Jn1Ph7WJS/Y?=
 =?us-ascii?Q?WHHA9E7Z/9i51ttqPTGbBcnCrrSFmp+SZjMXmdOC3OEhvwEMAMWd1zGpQpJM?=
 =?us-ascii?Q?przJtnKvEMS3ym9cm6bIxd4qYfoD0pYv4SBe7qAa3DCea5TNjCvU2Sz1uzyY?=
 =?us-ascii?Q?ojIQ+ghlgnBclXxQiqBVpJu4Oghi/6Qva2ihrJ3LCGqXjKg67Nh8DI7yjUgN?=
 =?us-ascii?Q?Bx9BHwC+nUDx4f99u3PyCnKVCe3+v6BtmuP5Rbyaix1sYh7U4Zvy58kPi7LE?=
 =?us-ascii?Q?XX/16PBKYwuPB/PzE6Fq7PevB4iWbwmBFsyKGhf5Jzp6iDXoqHH+U7PUzzwb?=
 =?us-ascii?Q?DsHUUaZlZn/0O21BBLnvawMmYAYaLMINfeaJFlwResCYoplHr41MA1Yaz6yV?=
 =?us-ascii?Q?JCTXIx2h1G+qLXvk8r1o13ODiMRr+CDHGGemYv6IyLVvNSFWfzWibiQ0ZuQm?=
 =?us-ascii?Q?lPo0vhrlNhiyJFyzxeP2WzQvzg8zlhj+v2m7P5l/E8rGedTxuhWMMPuNThST?=
 =?us-ascii?Q?s8/NTL0fzW1OedyzPUYvfOqnPa+/CkVnr9Dz+/9Q13CIzXYToWNVahQjqrCe?=
 =?us-ascii?Q?om1JOUVRVexnwuG5VU8ZvkukocyCgVLNQsBgiVoEYuRGDrrTEA1dBhOUXkyx?=
 =?us-ascii?Q?4bgqdKhshbtZniPD3RIyCHrgzIPUWZ4CpVhWCuxDvSowVFNhTL1tandwrUwc?=
 =?us-ascii?Q?2OvGqlX5X8AVocmufi17yoqRecFCRGlxP06agNm0kgcehtTfoxYqv2YrXIHr?=
 =?us-ascii?Q?QOvHwhWIuDMZ3VeIEyiZMEa7yKrG85UGqDv/b6IUwuVvD36pFX+OOy8GbQTi?=
 =?us-ascii?Q?QasD1EI3L5+onXBTEY5gnlYSqlnyuuYmBlnXpj/GyZj48Y7hOnDh9JEz5fUD?=
 =?us-ascii?Q?NSmj0nJWbXHp5l+Vwzq5On1tWtO4U1aUO4URADSvBpO3csNq61PCRsomSI2i?=
 =?us-ascii?Q?87AYi1E74s06tbVIeiDYDFsKXCh8Wcp4Jti1hz2DZfudkkLcrfIAe6N+hWHY?=
 =?us-ascii?Q?uVs5TMDqqH4oj0ORVGV0HnJV+yVbgEfKX0lvKZXooWiKW9dt0K33p2SMjCaj?=
 =?us-ascii?Q?DinMIg6OeE3L+o0DRLhzkmLxR5BGlmD6NBqX4kWzF9NwWJEZ8MaXHDp6OpKD?=
 =?us-ascii?Q?Cll9fjDcU9fTuqJ1Wl1hMdPC5Rpt5ED4Dn1LRlRemvRJ6FW5b/mtH9OonfwV?=
 =?us-ascii?Q?1RjRSScBXaxrzWpZdRSrJDa/BODQ72VT6HLRlAGZe5bb2mEIp1fw9ZYsUkJO?=
 =?us-ascii?Q?xf1vKlnpzJbgZcGsrTb/NtKX3+YQ91U2cflUDZbXc6lNJfZUULIjg/4Yd65M?=
 =?us-ascii?Q?Den9lba88Uw=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZZSO8iih2CBsBq3KshNPykzkB0HBoz2Uczlp3ayp/tDt7TYnopFezpt9SstF?=
 =?us-ascii?Q?l4I2lU/QOAs2pR2HTYjWKlta6xMABG2ZJ3Vl/8dv2s1iWyrwy5uUBowcezM1?=
 =?us-ascii?Q?kAlkM1K8tYaWGVMrSz394OAdwNkAtA6pHxNLG3qQX/wytV1zINvyIy+qIyfV?=
 =?us-ascii?Q?E5ncBEByiBFS7b6PfAqvMkr2nqB3XhxOSIQ9nUpayKYtJVfqY8KRj7MGAWdW?=
 =?us-ascii?Q?jrXrMW8cfSvaJlZ3sPK/BtR/zifYjkwje/hTAiSGQGPFES0PdGiazoVgUMCX?=
 =?us-ascii?Q?5dicdQSidYk0g4i6FYLsqtwnKER2SjZ4OQmu85/xmItiaCTX7G5EnReE6d3U?=
 =?us-ascii?Q?knyoP/I2Rac22WlWBM7NYvo637jsPFXKJeJwIeUW/xJ3t60jacJX9/Q63KSm?=
 =?us-ascii?Q?anYCTpyFxFjwqwsCYUckrkDtZhwpxXqn3np+0iv9VNQlSy+f7MsdPkLfVVxX?=
 =?us-ascii?Q?gIsMdDOoREN52qYC68Bo9n0rMkH0LiL8nYNh9Y9knLbp3KeVD6wexWjw/BGX?=
 =?us-ascii?Q?oMwieJZD0eL64gEUPv06H0YJD+KcdSrGQ97WqaTiUEeqUtwayNjSL13r/D/t?=
 =?us-ascii?Q?DTAvEOp3LWJiDtieUv/NK12HMZngLRQurmGo+zBl+XGRNSvfizA7i9lcyb4f?=
 =?us-ascii?Q?xpWjWDCltxJTrDb8RVn+GBAELitCf5KcJF+DJd9LRRwnyHmvINre+AaCgqqz?=
 =?us-ascii?Q?qBuSctcMwVBnmLKlIpb+VHDi7IDWCNIqcDGkbQ74FRa1gc/gAd1UL3C7e55h?=
 =?us-ascii?Q?S2y3hE4Y9u1OwJU/YH2u6F8HhZaJq/T9796b1kLjJmxhYhfr7N/vbXTK6QZd?=
 =?us-ascii?Q?BhVAQT/v6Hg4n/Yp35mnqCfDKqvSbaJaf/bir4Qx5ICOngeqde1o9XCCYkSL?=
 =?us-ascii?Q?eChHpBKJ/wVWrILp9efmbiu30I3gz+lnxIkk0HcjmVf8A8RPtNxFFr6Pu644?=
 =?us-ascii?Q?ktHAsMQXs+KFeifPZViB1duXacmWBrkr/pEqElaLoE9d0o5eJqs3Vjb9e7kj?=
 =?us-ascii?Q?9awPZYnzfjRT0nnGHTf8XbAdrt27Bolzi0tL9PebbvN9dpdD5BCpvqGPQMR/?=
 =?us-ascii?Q?wvcdxkdHmqTGbcIAezFMcwxroYlb7LUeW+Qhy3q787MAnLvDCGkIpWTpp2bH?=
 =?us-ascii?Q?Yg6QjGdDZoQ2blV0ZFtMzv28gr9bnMXsNM7v310akxcVePv76xgJCIoJ5os0?=
 =?us-ascii?Q?qB/oss700Yq4y09XqkRmJlZ+rt55F1LprUSE+zSbUcUnpjx9MjSHg/318LZA?=
 =?us-ascii?Q?89XBssR7Xbj1fcLSWBTq9WB3iYSixox7CHmOicBfE9UruCdAvLFlylURKhtY?=
 =?us-ascii?Q?Q2MqvoUlRf610yMPSlJim9L39/OrykQAQRF8kFhOpJp2ROykzoXY7I2KDmOG?=
 =?us-ascii?Q?pGdJHPkbpn0y6w8vnS2TG/WAizIAONfVAxtMJNRlUke7QfH9QMXpSWlfS3Fp?=
 =?us-ascii?Q?8fdvt36LmthmmVMguXiViBONpFOvy5SLlAL8NJpxtfAZvOlKk7cE7L5gy9YU?=
 =?us-ascii?Q?gnYZZJMy3HWCDaSugycUIN6msTHLnRXdGpQam2RhBdkF5K9HPeQi95rtqL3c?=
 =?us-ascii?Q?tH1Jxf7jM251I8U10yaA6VIzwjUgJZW7BHijdOF2?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ae5a7229-6229-4c7e-15fb-08dde3768d83
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2025 01:27:27.8367
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ET+QFsmo8QRbXo5F0KFyOFtXY1GcVttn9NkG8fu9eXx4j2HOJf3Dwags3zdJvFZVCye0msIs8rTqNE1OR2voNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4895
X-OriginatorOrg: intel.com

On Wed, Aug 06, 2025 at 08:45:06PM +0000, John Allen wrote:
>Set up interception of shadow stack MSRs. In the event that shadow stack
>is unsupported on the host or the MSRs are otherwise inaccessible, the
>interception code will return an error. In certain circumstances such as
>host initiated MSR reads or writes, the interception code will get or
>set the requested MSR value.

The changelog does not match the code. This patch does not set up interception
for shadow stack MSRs; instead, it emulates shadow stack MSR read/write by
accessing the corresponding fields in the VMCB.

>
>Signed-off-by: John Allen <john.allen@amd.com>
>---
> arch/x86/kvm/svm/svm.c | 18 ++++++++++++++++++
> 1 file changed, 18 insertions(+)
>
>diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>index 6375695ce285..d4e27e70b926 100644
>--- a/arch/x86/kvm/svm/svm.c
>+++ b/arch/x86/kvm/svm/svm.c
>@@ -2776,6 +2776,15 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> 		if (guest_cpuid_is_intel_compatible(vcpu))
> 			msr_info->data |= (u64)svm->sysenter_esp_hi << 32;
> 		break;
>+	case MSR_IA32_S_CET:
>+		msr_info->data = svm->vmcb->save.s_cet;
>+		break;
>+	case MSR_IA32_INT_SSP_TAB:
>+		msr_info->data = svm->vmcb->save.isst_addr;
>+		break;
>+	case MSR_KVM_INTERNAL_GUEST_SSP:
>+		msr_info->data = svm->vmcb->save.ssp;
>+		break;
> 	case MSR_TSC_AUX:
> 		msr_info->data = svm->tsc_aux;
> 		break;
>@@ -3008,6 +3017,15 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
> 		svm->vmcb01.ptr->save.sysenter_esp = (u32)data;
> 		svm->sysenter_esp_hi = guest_cpuid_is_intel_compatible(vcpu) ? (data >> 32) : 0;
> 		break;
>+	case MSR_IA32_S_CET:
>+		svm->vmcb->save.s_cet = data;
>+		break;
>+	case MSR_IA32_INT_SSP_TAB:
>+		svm->vmcb->save.isst_addr = data;
>+		break;
>+	case MSR_KVM_INTERNAL_GUEST_SSP:
>+		svm->vmcb->save.ssp = data;
>+		break;
> 	case MSR_TSC_AUX:
> 		/*
> 		 * TSC_AUX is always virtualized for SEV-ES guests when the
>-- 
>2.34.1
>

