Return-Path: <kvm+bounces-72143-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eOpEOqWAoWkUtgQAu9opvQ
	(envelope-from <kvm+bounces-72143-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 12:31:49 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 66A351B6986
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 12:31:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id CECA930AA071
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 11:28:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05DD93EFD24;
	Fri, 27 Feb 2026 11:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gnp2e6K9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 257AE3ECBC7;
	Fri, 27 Feb 2026 11:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772191712; cv=fail; b=XSdXdvA3gosSuqPnABymnB8ZQcvrXE8noWg/PTGfpf/t0gCKeNkgd2rmV8e8sVsOPOUpiLad4nm0+vW0jfP5ijpVJCepN5I8uQ4CbE3yb5kLgr0aJg2nnE4GvCo6s2bi71wyuPo+r5bi12uTfWxeSyz+kzBa7Dk9V4iSHeunSEU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772191712; c=relaxed/simple;
	bh=rMz68lb+KsZZHx08gbMpLN5hLSdDI1FGaNcCN1klGqw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=tFGmz4QBwyC8XG6PFCDkvZKIZkdEPaVF47oPIfpen8MUee/ibGfo7/SZI41W4vkdwWm0KLkcDPVuVgKYtDDEJeu+uTODXxKihkB1/t2/b0d/F9imnz1VBM3+HNfPa5cwvSrjuelBkeCWu70ap0olMFS4/TtJOzVkTcKA3xm1+LA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gnp2e6K9; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772191710; x=1803727710;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=rMz68lb+KsZZHx08gbMpLN5hLSdDI1FGaNcCN1klGqw=;
  b=gnp2e6K9crsdtzpmCNPOnsUqxiHGwe3hvXowkcwYQouV+NjWZlawtXsi
   Tnx/h4xo7hvbeezx6hENFIkbIb9Uin9tvEcm7ItXSDBZiXzA51ZBR3jIg
   jHnY0LV3MdSPAHPme1aEIchihVvMmeDe9RRnbkc87wAkphR+u5CWWRz0O
   us5K4iS0XIaYdKuuNtfRNT51XoaYI9ubfMYBoEEpbnz3k9Yt6BGYrjzmi
   KsVvDyYMeeXSbrSoKO3DiEIfJJm4Kvn90AtYl65sBqUVRxtMKRDaRm6bR
   OnNEOoawt5Ge5Sy6UO7g0TP0do0Gea5PlcmdoA+kTnAEglPJsA8Gu0aG3
   A==;
X-CSE-ConnectionGUID: 3WtoHSNcT8mkAobn1CaBGg==
X-CSE-MsgGUID: 8cVt68kHQcmI64WGPWDKxw==
X-IronPort-AV: E=McAfee;i="6800,10657,11713"; a="73456921"
X-IronPort-AV: E=Sophos;i="6.21,314,1763452800"; 
   d="scan'208";a="73456921"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2026 03:28:30 -0800
X-CSE-ConnectionGUID: rMUDKYzkQrOXO0QiHUs2EA==
X-CSE-MsgGUID: Mkjxq1jTSLKllZcSTh67pA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,314,1763452800"; 
   d="scan'208";a="239866417"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2026 03:28:29 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 27 Feb 2026 03:28:29 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 27 Feb 2026 03:28:29 -0800
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.25) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 27 Feb 2026 03:28:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XeanYlHGnOV9GEOjm+tOCEbpGe12+g6JcYhJPNgUSRqUBvF7mezOx/xtbuQ8Vy/7jHysXhx1kGZQhkKPp/euBfY+5oUmNzLPUwnduABv05Wc/PNEvvOD/Wtp/Ms0bXTcFN0pJ72J9zRF01b2b0ZN1vjWP8ggt64xdRMauDxUEz57Ygkm8rs0x8HqaZ20pfm9Ied6A2Xw+EupWYIsKrlaEHgzL7unaCqchIJHk3iMlmbFKdC6KMKLz7oUEr4Zh9DmqO0BzNPtQuBa5tQk/Z4ZJKO7wo9Zc1Q6IhYY5C5lhy65z7opNnqHXDBGdx3fLa5qAuWNA29RTLIgDds3b3YI9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PGP8A365Es2RWq6B9T1QoJcf5w+RXZtpfqiPCtWxWxo=;
 b=NkFlqAzffxbfpmMn3uwinFqPQiBsY/dDtd4GAtBeyTr42sdymKBy/L9fKVzPlXc0WIWbSMELOFd0LUzm5IYn38yhOTl0X+8O+ojaUdvye6zgfBaXAZDmnLKAWjrlSImBwinjKnDAIOyvxrmmW5o160F9gutFCqf8y/2KqoB+Dohtuzd59FhQDCEO0INYgBk6xpWi4LUAve6/1/TZPBCWslye1gIWDSejVgNUYrS/tV+Tmwd92bYE1Gox7c4Zoil9w8GjqCeMFcydWKuQIzncmtfz2FkUFUAxr2shSwW8L/MQ3Vxa8FAqj/ODil5ohAprU9BLhSAWvTSXNkji45s0uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DS7PR11MB7739.namprd11.prod.outlook.com (2603:10b6:8:e0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Fri, 27 Feb
 2026 11:28:26 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9654.014; Fri, 27 Feb 2026
 11:28:26 +0000
Date: Fri, 27 Feb 2026 19:28:15 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, Peter Zijlstra
	<peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, "Namhyung
 Kim" <namhyung@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	<linux-kernel@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<kvm@vger.kernel.org>, <linux-perf-users@vger.kernel.org>, Xu Yilun
	<yilun.xu@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v3 11/16] KVM: x86/tdx: Do VMXON and TDX-Module
 initialization during subsys init
Message-ID: <aaF/z/N3pv/etuJf@intel.com>
References: <20260214012702.2368778-1-seanjc@google.com>
 <20260214012702.2368778-12-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260214012702.2368778-12-seanjc@google.com>
X-ClientProxiedBy: SI1PR02CA0045.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::16) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DS7PR11MB7739:EE_
X-MS-Office365-Filtering-Correlation-Id: 9fc3b1d5-7025-48ff-8606-08de75f35338
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: 0WTLeYZiGBlElUnsJuzbzZQ1eKIPhB/AU1UtCNr2dB3uLeKBEMNpqnHmC4Lq3uYSDwMwf06jXCgNwfeCUG8mdL67cmv+Zx1Vpf24nHr1wg9poYVDNJmyY70jTgBifiK7DZH/2PoBVFyp2FqS/uEqI1XGdiZStZoPRvn2NLs2f6uDwGXIR+Sb21isNqMFL0sU1WIFAZpUvjnBpf6BM/bgt/L57WKnoZMclk1VxLHYH3p9pU1hNIE5GA7QZifXAg7XkTYsAoLPdZB5CvzPgcx1+f+IsvCn0WXVkjya898qNevbZ+JdWMsWcc8+yc8rK7XMW+1BgFR09L0akrXbECsPEgu980mhFR0JP3tVXodcBre6YeH+ElbuC9UDygGIHc8Stg/yi6mjGlxcZNbO4cE5FERj/54lM/UugvAOmYkZuoOo6UJawj7p8xpzvDsvNbxX6t3SXNXjmbgddiYdzU/FEgCoohXLEPvIGHDv1PuYy1CDXGwwKM6aUFrTaIGgEK1f0tda/+Ke8rq+YbxghV8ZQ8QHHzd4muvZVRTLk5pIuBKsEmNfY9wHzUPSdgHQ60i/do2ZbA6CJ/NVDPgDnG5eyL1V0o7EloHIfz83iOXSq+UzpuCtL9fotjZ7H6Sbw7WvT0YZF2wm2ZdSb1IaAh2D29NctrQ4babF+DQcnHAQkK/KGOzyGQ03Gn44Dvq5CP6VIrXd+iD5BuApwosGDqoX1y7QrutDVQ64mHSij0EzOUk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?p4aYSshQdLwK00f6KUl9apID7BPK5MB29YWlq79Uz2N6nrZCTiESRoD7d6iB?=
 =?us-ascii?Q?BWe9WooeGyKhsoLj/BnGjz46k5N/+4GtVLGrtCvJJTeYQKJWQaXL1sYTFHZh?=
 =?us-ascii?Q?1lylOQoMJWnqtpjCf+o97slhN56s18GusQEtOlfkl53/eW8lGdkYRnR6SL8T?=
 =?us-ascii?Q?ydzNCWq7yPUb7f3gTCR1fLfyV2Nj516wdA1C3ZT3m/Pa6C5eGFhgho4qQVYK?=
 =?us-ascii?Q?42A98rYK9kGLRvMxO5O3DsF0coZpuljVFyVsgydEB2m3S9FA0cSHlRPbAvEQ?=
 =?us-ascii?Q?oa46+/ftQQaswElfq/WJVMgN1znhhUxN/uQtByaZDSIAOnB7kg10/xv/togP?=
 =?us-ascii?Q?mOKJl94Ufka7KEHB0Wnc9tZddeEtJivJwmCC+RttTs/7WzQ+ePBLXMqruNYW?=
 =?us-ascii?Q?MmaXETEsvp3n6ZWIrcSqlsNLttzAqa0gU6CdzZbNOtYvfcD63DDA+hrE4gqr?=
 =?us-ascii?Q?RQE3qtDoOXw+4M6RjRlZuCyzWncv7Ca2P4yLowE1UCcd/d4WS+kvvBPUAvMC?=
 =?us-ascii?Q?viaUAvgONn/0hyX2chG2p9elKd6Ao8KpT7P/eLEIGisK+0oMxox+5RgK+aeJ?=
 =?us-ascii?Q?avuueOuM6cOvac/Xm+xc3dsqs1q7XKiTbLg3uHOwQcD38+3ttbvQREcmKjQO?=
 =?us-ascii?Q?BjIhZ6yT7HR/fX7O5ydbfA4xBnv4KL94R3AtbykJjIodPf1BE/66Gy2poaE7?=
 =?us-ascii?Q?KgyjAoyJa+rTWxe2/R0gWo+ZZtRnmsgl69UM3oBIh5JEHbqiKkx8xeAykXN9?=
 =?us-ascii?Q?0o+gxxyWe1prnttcjrK2AcVKL7owXrp8Apq71VdY8230X5JOadNzGbG2L1wD?=
 =?us-ascii?Q?fLejwtpmXsxzYU2PSlhuUtxpOoz5fueZbGYhxUgv6bPJlEmYcJPMSOILLKSf?=
 =?us-ascii?Q?1B9o4SgcMmxgGcUkDM+dFB8d8hw6r1pkMg/0tOWwmSkJINBEPTjEgBqhw+rQ?=
 =?us-ascii?Q?F8TyOTO8sXAFfVleP51eu2xUQr/lVZzybBsriMO5gWDDPnjEjfn+j2+UMoS1?=
 =?us-ascii?Q?vbgHtXNi7Vg9wW+0/+waHOoo3pBVs/P3KNSGRKPLrKand9SoL/CwY98B/qh3?=
 =?us-ascii?Q?ecWaOxESNCU7SOpAJJyD3dAXtOkaizeAorYXeiTxZjIbP7YqDyCsZH3ZfuBu?=
 =?us-ascii?Q?XrLVCcytmZ+EYSu/mbTlGUIQngju5r3yAYldV0sL645EOYEFpRNeZT7xGb6S?=
 =?us-ascii?Q?MyQoYKc3k2Nnd10LxvUS4yMqczFnzgwm5KjFbAQDk1anbjkk/E3Ld7tHiSoH?=
 =?us-ascii?Q?igIvfG55TcUEJm03/FaWOrY/lZePKkWCJEnGIg0fle50Dnmy1U05xGaIv3wd?=
 =?us-ascii?Q?kAM0kS/TtH03b1Q7zIv0Kwzyy4Z52rm7/UVTG8CnQlM60q8fcuY0uv+f4koU?=
 =?us-ascii?Q?Hrhbp+p7x03jV/fWDE83trgTeq49gLKtW79tuv7IX73kifEFSGiJBfmO9D5M?=
 =?us-ascii?Q?kcZuquxtg+RYpRVuUXsTGV13CdImdX7qfY/8EdJKYUHwn+ur5TolbGjQpG1+?=
 =?us-ascii?Q?EkK80GoiwFMnTz9hKVbsXCAcDOyhEYkvk1aWRvqJzOhSFeOs0Lx7gn+Qs7MR?=
 =?us-ascii?Q?qZsdO/y0xVb7tQeCgYRL/QyOMUtYCnz83iXUsmrwkpPkS3wFmvbnqFFWWhNg?=
 =?us-ascii?Q?pHcPjWK03mzDaDo5yQp2c1xJEiy4ZCAythNYTWzIly1ckPcuj6N+39PdXIzd?=
 =?us-ascii?Q?C7ibBM9b5nic5mMWVAHDgV7/xzgkc0f1nE7eOK9huSq+uoumeUGYZnWPsszW?=
 =?us-ascii?Q?LNEZ06uzwA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fc3b1d5-7025-48ff-8606-08de75f35338
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2026 11:28:26.8015
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3eiCkgI1ydJoe4BjTxA4OqBQnyrohiWqx8dS3ywQ6DHX5Eu3K4+U3k4RXstgSuhwoQ31Jxl+33BZoOGuJF14Aw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7739
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72143-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,intel.com:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 66A351B6986
X-Rspamd-Action: no action

On Fri, Feb 13, 2026 at 05:26:57PM -0800, Sean Christopherson wrote:
>Now that VMXON can be done without bouncing through KVM, do TDX-Module
>initialization during subsys init (specifically before module_init() so
>that it runs before KVM when both are built-in).  Aside from the obvious
>benefits of separating core TDX code from KVM, this will allow tagging a
>pile of TDX functions and globals as being __init and __ro_after_init.
>
>Reviewed-by: Dan Williams <dan.j.williams@intel.com>
>Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

