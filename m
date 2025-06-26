Return-Path: <kvm+bounces-50781-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 08734AE9377
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 02:47:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AD3141C4282D
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 00:47:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EFCE18DB01;
	Thu, 26 Jun 2025 00:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZujvI+78"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFD5F12C544;
	Thu, 26 Jun 2025 00:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750898826; cv=fail; b=mfS2KpvI2UV1ed02aggvvNB3xoGYA2zNCsMIShbdIE1lpwPVc6Fa+/MIn/RpBtaiM7VPO+3V8OYOwl4V+mLr3gZzJIYfvYqPj6Vp1FsD8n0akNxIZwVg2Asa9GDA70HMoDP0hykg1LL1g9/fMlc/aYl9Nm5/6+RtjdbNIMjmmDQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750898826; c=relaxed/simple;
	bh=PguWdUUKcH+ZAT++e+42spMPiNBKG+t/IU4ODQuLMOM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=r+tD5y6c6TYYLZdwuIn1l2bbNmHGAkYh/mNSWcNw+kviK0H6IH6F5ibKNB6zynsqrJuHOuhNOVsi4StOrnsNrGakDtZFxs9fqhbQNFSvietRbzyP5JqGbdZgg1r6IolMtF14CzZ2nrvd+M0X6qFkaqF2aa7G1jBZ4tNc+4l1bpM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZujvI+78; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750898825; x=1782434825;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=PguWdUUKcH+ZAT++e+42spMPiNBKG+t/IU4ODQuLMOM=;
  b=ZujvI+78BA+W/olu4/mpEpZSm8V5DfM9dmxiFZc0Z/lMWdHe4Q3VHl4v
   yp5Q49DMcEfrZnDtFB6yWViEc24OEWbPyNjx8eIZVUGdtR8wwTG0CGGTZ
   AGrIcclBbjFFOKwyQU36wzsYv+uCkDDE8wMQctl2rk0NDyFg1iDibe1oa
   189Hd+znQq4YByf5soFj+HoIbcSElxjQ/VRLJ1SkFKEmbK3fP+8ijf99v
   CyfG1ELmaAG9uB6s5fmhNOGNkyEmABD6dFXYU6fds16Tpi0fQj4MNH/cq
   99DRbIG1q0oIol04WL1/bng9GGwzsrPVqc9xkvxZ5iJKhc+zihigi9gJJ
   Q==;
X-CSE-ConnectionGUID: BVFkhAmjTjSLEl2e4Q9iDA==
X-CSE-MsgGUID: jDq6LOoCSreCXsxa+GB9rw==
X-IronPort-AV: E=McAfee;i="6800,10657,11475"; a="53121985"
X-IronPort-AV: E=Sophos;i="6.16,266,1744095600"; 
   d="scan'208";a="53121985"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 17:47:04 -0700
X-CSE-ConnectionGUID: unwqISdrQjGZOnbmh6KcEQ==
X-CSE-MsgGUID: EY6GFozcRHGgZZekZP4IiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,266,1744095600"; 
   d="scan'208";a="152133298"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 17:47:04 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 25 Jun 2025 17:46:56 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 25 Jun 2025 17:46:56 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.82)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 25 Jun 2025 17:46:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IuFj9XQFsDcbVgXERA8i2JUSces/idATh8R4MJB4Jf3lRNGEG0U3U933dtai4b3oxcbDxxEOxINuqDBNhSYx5/G6ghJNBAmGHvBX5kjTK+hSBPV9WUJeVL+LLaSbgoXVyM55x69rEgNd2KMN6KAiZNebr2i+O+KoF9BWrtTb7pPj6D+/NB3JNkVxruXUZr2hFcOnCJVL/sL2smfu7Duz8bZ+F+pfDXiFjgB44Ds5noAzlH9iYYU/w8YDmAuGpaAHLS2Kd0O7XIVNvWKk41C+Q8NEpUunBCLNLdZ6fOqC9NVJS7ksGhbSU4Rgq9uGVZ8oPfrGLCql8MHHSWcr6fnwjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YsYEjfpZXC9YetBJ9JyU47JA3uq5WMkQr+ZqtIyFRVw=;
 b=hLPem4qCqnZgnLrywOqyfbeT3Vaoh2LztgHX36ICH2izcI2JT6BAw7SximgHNLOw5+VNlRSr2xRTSqtZxBzEq7aa2japyiHSAtKbY6g9VqZmfuHEEMyjH81CNe3ZGUXgI6p1QV7Q/43pa2EksM1dH5yUxWnpBtXrFDaG7bTX77lfZtUnMzXdhhMxB6RwQsYWTxRVlyow6bFUgOXt8Qtua7kbjJrO0YuDR8umzfB10qLitTzU12b1MJIAhp9FZGTxXGBqMkxmLgfOEJ8mcXAydhmqXrd2OL0cDP80RvhSHtfjWRtpiNC6Rzt3nJpwqDydHgKlF6RWJ8lPvWFGLR697A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH7PR11MB6955.namprd11.prod.outlook.com (2603:10b6:510:206::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Thu, 26 Jun
 2025 00:46:53 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8835.025; Thu, 26 Jun 2025
 00:46:53 +0000
Date: Thu, 26 Jun 2025 08:46:41 +0800
From: Chao Gao <chao.gao@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
CC: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <dave.hansen@linux.intel.com>,
	<rick.p.edgecombe@intel.com>, <isaku.yamahata@intel.com>,
	<kai.huang@intel.com>, <yan.y.zhao@intel.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 04/12] x86/virt/tdx: Add tdx_alloc/free_page() helpers
Message-ID: <aFyYcT+BzbRkcCBT@intel.com>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
 <20250609191340.2051741-5-kirill.shutemov@linux.intel.com>
 <aEeaJH1KqZ38tgKi@intel.com>
 <a49c523c-0c9e-47c6-ae2a-c84ff19f6717@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <a49c523c-0c9e-47c6-ae2a-c84ff19f6717@intel.com>
X-ClientProxiedBy: SG2P153CA0011.APCP153.PROD.OUTLOOK.COM (2603:1096::21) To
 CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH7PR11MB6955:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ffb862c-2ee6-41d4-ee83-08ddb44af185
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?ci/vn57doCAYR4QQSFtJvjR7idkTXdzlp74YRD/T+KsGRIxt73sXxyzSrGhO?=
 =?us-ascii?Q?Kbtlfc3witouD34oRRQj1TIgAOvFKneombokKytOZYT5ib8ReLytaFTh2PZP?=
 =?us-ascii?Q?GwJaJOIjzIKf009L2BqbxBaoW2H2Wz2G4GwVeZPR3PrbfeUJcpvKTr61BiMu?=
 =?us-ascii?Q?qvzYBHbwvyWy+AMUWGEVLVykEebg1crE07/q3blAirgTNr0fMyVHJAm35Wml?=
 =?us-ascii?Q?RRi8Ub2sCVrDa7jb4nPPoxku9wQ8T0+bgyibfNwbAd6lXL/ij861bEC9oehT?=
 =?us-ascii?Q?UdgIKIs7iGcO1I63+fGelT1q+aW51XyXv0ofuTqoc72HHnvyr4BBh8eGSHQX?=
 =?us-ascii?Q?H9EjYYTBNy1BAZ/GjeVXZN7jkJ1A1Z1RzLThWYSUu49RjoYB4IvxdcdJWXf4?=
 =?us-ascii?Q?uGRsWxbCwaZpImCwXg+99c5w75R6UmJ52SOqYXwn4D0zsssH/qTwVQAXhx6E?=
 =?us-ascii?Q?gJ9M0NGWx6R+98oz2aWpmMpyd9De33huLdK5EpsTvrhX5qorGai1LLIpT+qo?=
 =?us-ascii?Q?UBV+ChDtYRVQlopIMgNBR5+pF4sb0qtf19UbMv8R73GXiJDt8lKaOi5zg3Eo?=
 =?us-ascii?Q?8GCh4JmuTolM85xRV/m+XDUlgSaBCoUNpO2k2DIh6+QCu7RdfjIItZkQXXl+?=
 =?us-ascii?Q?kEB3GyBTfJ70LXvZUHInV7o5WOFwMOEnZf6Y4qB2XlceecLICx+I94V4M//Z?=
 =?us-ascii?Q?g7UTngOFbu/gA2j7YqzV4yhfl7g6N9aG/COKKIjLUMIkHThS21tWJcnxBKpO?=
 =?us-ascii?Q?pplri007w3Diahrg81aCpwMlxeYeCBIrrXcaLAuEHaiPkHwGq74rOxoW7TFn?=
 =?us-ascii?Q?MEq+jZofJcylnD0WvUQtIjH+5AI5S05E0mFciE4hmIXXK73mW1CxrrH2P6cD?=
 =?us-ascii?Q?xtnnY4L7jIaf9zcb6sg+adnR4ifL4YMVPIjKMprzDm3HSNCVglvFRYzJbRWJ?=
 =?us-ascii?Q?vwUu5IPm5rpcrOXchTPfQ82aJrt7NebpMa7ZgSxaskP3MgAq73kBAuODF6Oo?=
 =?us-ascii?Q?NudfOp1sUzUjKRPxYu59qsBUvoPV3JG4VFpi5amtYDCZwKHhQft3RD8nYJQ6?=
 =?us-ascii?Q?U4hhZlizuSWowwh7YvBcti/IONenMe6UQT0lQI9dM0zd5gTQAEU1HpJA51qT?=
 =?us-ascii?Q?lePZKzkBzEoGBTqv4ZAbi6N8afMXeec0VQCnDu2mIlclTTDyoevoz+IHJq2o?=
 =?us-ascii?Q?CR3GBGgGgjRQ7KnPmjeB6ssmBVupYZowk7fhAL+WhsEl+B61JQYKq3Mkkv5N?=
 =?us-ascii?Q?svAS7cx/kZAMJRpc3q9Gg+tWYTDUykENlpRHh0KCxXJW1ChT7Dzuooa13WRU?=
 =?us-ascii?Q?MAQ9nImDdofTBeusU343r3+77XjIShGEt8DqbNGBzwZBGmQhma0K8+Kc4+cC?=
 =?us-ascii?Q?8fqsLdhC8b4dsZ05NCGHSJknj2Mh1iCjgxuwV56HFf6GNUMJO2a0XEK3+5Bk?=
 =?us-ascii?Q?8bCmZjQ17Bs=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SlUublzszhl9bK69K7A9FNOaSnN6r6WFnv3WcrSQWlEUopgckf+hXEyYCvkj?=
 =?us-ascii?Q?q8LqZLyJQpMiGznymSgX+tQ1I3UFoY0ACNXCTRTrrIASzieSXwm13v+3xqZX?=
 =?us-ascii?Q?iWjMrly5nzJ+WI+IaIN8Yh9piwSaqJffQvhEzEgXENK1/1kEeehNjESqVGpE?=
 =?us-ascii?Q?ZGDpDZ4MBNlX6yw6gJp82La/7lzREaiZyiPOggjoAiSqeS6fCWck+d2Jmrcj?=
 =?us-ascii?Q?HFRbJXymllAWkSE/49HVKTSfQya2HoZotk7y5XeBSygOt1NWlefyJtHbq1ip?=
 =?us-ascii?Q?N4mZ8I3r8TOTVi6A2pAf2ED4Xs9w1zfvhYyVogfFaXBYunReVa1JLGpViJ7F?=
 =?us-ascii?Q?l+A+u2tkYlxUWUYX7xoSe3VEwKcZmjHjhpHKVgtEYH1zpo9WxGR4xxMIkNdb?=
 =?us-ascii?Q?TAExNJ5S52zoRq3F49qMeitI+ogw3IOO2y/AsoihImgY/e+eK6LcFp+N1hZg?=
 =?us-ascii?Q?pcXKAEKfKl9UGptRQqS3MAiJDlkDDqRiXLowoa/zXJ7K49R40taSeP7HAsti?=
 =?us-ascii?Q?z0FCNM8h/Dv7UUfrlNHOA3Midrbsk/BLdLYeU66Kf3p/YI1kWshUr2qBhDuK?=
 =?us-ascii?Q?REimVLMDdioeFFo1e/B8gORMxhO/74eP4ktAdyKJgPnEZZ7/xt6ojEXIITGd?=
 =?us-ascii?Q?jMAcf9VMxLYzaTctRMhUcJr/ChZSpN0fkL3Bx8FfbHeCVtqcVH2AI/9JEGvN?=
 =?us-ascii?Q?BStgihloZ9p6pxfYGU4CT1pHxc2itIDPxHo95GMIq8hsNVo/7x3HogUTavA/?=
 =?us-ascii?Q?KT2L05IHTf6U957nz5Rfmau2GtlCD3cYjsdvnejV5aFq1T3Zhtn2y9oxgIYx?=
 =?us-ascii?Q?IDrllh27CNiTxzxCRwPGjCrrB3jnkh6Zeqa0rgvntM6/gXjMX/lxcu3Komdj?=
 =?us-ascii?Q?aToXxwV6+pll4jKrdSoqJHoLgpdG+0Qe7OiVMWUy8OFC6ZH0dKhLdV/+7/Ve?=
 =?us-ascii?Q?e5iFNkZ7gx44rF7jvqc3zpulUX8P7Q7ryrmlWuvx3iyVDy6p0eMR3ByPPaZs?=
 =?us-ascii?Q?n6h4bLJYQI98RrkJ34jA+eKiggX6fhYQMuPH2JXEPGthDyh9DFSAqd8U+eZp?=
 =?us-ascii?Q?yhS8+8ug6wH0HW6m5+qhrEBPO6KDkzc1YiyLTsLpn9OqsLYMdyaI5GOrHQ4v?=
 =?us-ascii?Q?3g1y2z2HMHo8XabwzM6b6RGnECymrdcQkmmiiTm136tHGtMIbQGxkcGHMkMO?=
 =?us-ascii?Q?wjSG+bMPCMFKwpc9YtT10Proac+T26pAfFScFqRtpkOAlPF8pF7Lyyr3H2Ik?=
 =?us-ascii?Q?98yXSo3g9ZbyD0xUgIYbIaGXn0VbX5b8+RgLh/i3XxXNb1spZyQQ2rZNOe0g?=
 =?us-ascii?Q?CD5PTIizKS7mO2EuEskekMtPkDbD/1viPMPL6SFggX8GMFuDCbxWVx4oD7um?=
 =?us-ascii?Q?RQFaAtwxtb8iGF+5U+DTxkjVQQLhaXigar7f23mbRP/z7wiXtcfJz+Q9KFN6?=
 =?us-ascii?Q?C0b5npBOTcqA8h8hlWQE5xBRfdtSQmlQFlKSYWD3XwYLRRTkymN6e7X8OZcL?=
 =?us-ascii?Q?BOmDvbC07POJu/YkgijyYnkr8yPPwrihc4pPyxW1bD1UZ1PXNDFiAFAc2Zd+?=
 =?us-ascii?Q?Jjwv2EFIDbdJomDY5B3aHHkacibosE3IdtGR3AjH?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ffb862c-2ee6-41d4-ee83-08ddb44af185
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2025 00:46:53.3170
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IiAGjC4x78xCsR2FhUZcWKgbpeOUGvAX9aLwR3Fn8BmhbvJJ92iV0y4qsQzPNWCn1kjKnYhrdxosGcf7eeMD4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6955
X-OriginatorOrg: intel.com

On Wed, Jun 25, 2025 at 01:09:05PM -0700, Dave Hansen wrote:
>On 6/9/25 19:36, Chao Gao wrote:
>>> +static int tdx_alloc_pamt_pages(struct list_head *pamt_pages)
>>> +{
>>> +	for (int i = 0; i < tdx_nr_pamt_pages(); i++) {
>>> +		struct page *page = alloc_page(GFP_KERNEL);
>>> +		if (!page)
>>> +			goto fail;
>> 
>> this goto isn't needed. it is used only once. so we can just free the pages and
>> return -ENOMEM here.
>
><shrug>
>
>There's no rule saying that gotos need to be used more than once. It's
>idiomatic kernel C to use a goto as an error landing site. In fact, I
>*prefer* this because it lets me read the main, non-error-case flow
>through the function. Then, at my leisure, I can review the error handling.
>
>This is also, IMNHO, less error-prone to someone adding code and doing a
>plain return without freeing the pages.
>
>Third, the goto keeps the indentation down.
>
>So, the suggestion here is well intended, but I think it's flawed in
>multiple ways. If you write your code this way (free of one-use gotos),
>I won't complain too much. But if you suggest other folks get rid of the
>gotos, I'm not super happy.
>
>So, Kirill, do it whatever way you want.
>
>But, Chao, please don't keep suggesting things like this at least in
>junk I've got to merge.

Sure. I am still trying to develop a sense of good code. Thank you, Dave, for
correcting me and the detailed explanation.

