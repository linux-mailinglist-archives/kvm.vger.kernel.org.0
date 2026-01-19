Return-Path: <kvm+bounces-68451-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CA8D6D39BF9
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 02:31:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C502B3015037
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 01:31:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52DEF1E531;
	Mon, 19 Jan 2026 01:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Cj1CQGgV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533A11A8F84;
	Mon, 19 Jan 2026 01:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768786259; cv=fail; b=rEa/sQCnXNOp8I4rrtbHP7FEEWJB+aPMR4gDxkSlQDn5H9udoq4w8bF9jVD2W8m2/XuJQbw/CvRnWC3yBSaWgHqutrGXbRQz0pqUI7/XG0yRFOdT3upD6HBUMpe6DVkueTzeLOKWDOn2Lg65nkIz7LaHd6CvK/c3jURi/szqo1M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768786259; c=relaxed/simple;
	bh=fiSN/9FB6HTlfdhyVHjPdBtQrWVOMKZtS/hN101j5Ig=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=pzNdDFgMZSqhChRu+Kb8utT3yqoMr5+u1qfqOfZtBR6RTVT8DDPxqNnR8+pYlZn7kY6C3HfygFG7fH7V/q4Q3Yfh7npHdJMTdhA4tLJ8eTL274ZdJkJNLyL6LBlAxqOFQc1jluQ2F5eSnKboH213YhsiSE8txDZBxdfy9WBgkCM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Cj1CQGgV; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768786258; x=1800322258;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=fiSN/9FB6HTlfdhyVHjPdBtQrWVOMKZtS/hN101j5Ig=;
  b=Cj1CQGgV/vMzw3ysuvQiwWzbpB1xHmFnnlZQ2jncSz/GLRP0EnWxXwWA
   t2QHNuEecsaYSOITerorwfqw1fARe1FKtDrrRoildLOt1+MDU80q8CIBu
   SNfO6K5fPCbRfaFfOOJRKFaE5E0DhUpUAEHvJZULGCv4R1wcaxiGKg79p
   RjVkPv6Fw0mk6slAu5EEJNw6qntA++vgzG1PAm2ob+hVs+DMn8INnrPEF
   SCrARQgbGiNQpBP2N8YQThVI05XLoeRDX8ytaiSU7AfM8bdBPS4nmMpHs
   UDoRVMdE7OYB5uu44Z1IKyeeTmB6E5k0MWMiODQkF4ypBP8KaJQl220oQ
   Q==;
X-CSE-ConnectionGUID: p2FPwsxoQTCpOnE+PJKpfA==
X-CSE-MsgGUID: NHh9lyRuT0i/qVICvWt0hQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11675"; a="69198720"
X-IronPort-AV: E=Sophos;i="6.21,237,1763452800"; 
   d="scan'208";a="69198720"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2026 17:30:57 -0800
X-CSE-ConnectionGUID: pjx9kIG4SPqWC/isw5cNJw==
X-CSE-MsgGUID: q/grtQbNTGm1tqzSgksp7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,237,1763452800"; 
   d="scan'208";a="206102529"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2026 17:30:56 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Sun, 18 Jan 2026 17:30:55 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Sun, 18 Jan 2026 17:30:55 -0800
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.5) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Sun, 18 Jan 2026 17:30:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lo54AkDRV0Sig9/5c4OeOMHkA1GqySylVbO09nkcAFlQhrO8oy/1CY19glUlSeyyOvIdBd5XnmeIpqMIClbJMExEO4xQgph4BkV4M0/i/Xh2kjT0Tjfxt8KQFoqDxKl2+ALkwycutIaCUJt1k68hgryf1uEjWNlI6vOuh43O9VFCSrTV6YDTF20nFYmPj0CRdJNRaMrmm9RbZZXsT1zU1aNxGGqIl4M7iLZ9umQxPxQg3mfohmMPm3VZtWWwfh/kfb6RYnqStcgPIFoOTZ1T7grMxDK/kDfMU20a9l2IBB5W7+3szAcdCnydKjn67kCeHsQY2OGiRrU7pcsCrvtcwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tk6OpECiZVNDjg4kJKrE3sOnVQcoXvM+9GtzxtOb2uc=;
 b=iCa5nC/en6Dnl1Zy42YAknNtIi2HXuptFi3xTmO/rPsDkUOmr3sXedMhNZAeu28O4nwqXsKWXdNAlDeQgHQ4sCVVfFe6YAhqpcC5gacEimfNflgab8M2fWuV6u6vC5LTnkkaJitDNJhdaKdLp5ZJoEkXczQhpA/QxSQjVixH0M2JPkJYO4Feys4+/66MOZLpipjEfDsj9YnbvFD72SRiOVrG9EGSsmycajzOH5AHATUYTT3K/DOuAYO6px26IpggQZh6Sdiblj4GcoVxs0Ho1ePW0VNEGy0WD4GXekQbPu0zePSJPWN4H/9N3QibRmjNmGJqHFpe6/7ZHfxk7x84wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SJ0PR11MB4879.namprd11.prod.outlook.com (2603:10b6:a03:2da::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.10; Mon, 19 Jan 2026 01:30:50 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9520.010; Mon, 19 Jan 2026
 01:30:50 +0000
Date: Mon, 19 Jan 2026 09:28:34 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Kai Huang <kai.huang@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Fan Du
	<fan.du@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Chao Gao
	<chao.gao@intel.com>, Dave Hansen <dave.hansen@intel.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>, "david@kernel.org"
	<david@kernel.org>, "kas@kernel.org" <kas@kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>, Ira Weiny <ira.weiny@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, Isaku Yamahata <isaku.yamahata@intel.com>, "Chao P
 Peng" <chao.p.peng@intel.com>, "francescolavra.fl@gmail.com"
	<francescolavra.fl@gmail.com>, "sagis@google.com" <sagis@google.com>, "Vishal
 Annapurve" <vannapurve@google.com>, Rick P Edgecombe
	<rick.p.edgecombe@intel.com>, Jun Miao <jun.miao@intel.com>,
	"jgross@suse.com" <jgross@suse.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 11/24] KVM: x86/mmu: Introduce
 kvm_split_cross_boundary_leafs()
Message-ID: <aW2Iwpuwoyod8eQc@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260106101646.24809-1-yan.y.zhao@intel.com>
 <20260106102136.25108-1-yan.y.zhao@intel.com>
 <2906b4d3b789985917a063d095c4063ee6ab7b72.camel@intel.com>
 <aWrMIeCw2eaTbK5Z@google.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aWrMIeCw2eaTbK5Z@google.com>
X-ClientProxiedBy: SI1PR02CA0002.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::16) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SJ0PR11MB4879:EE_
X-MS-Office365-Filtering-Correlation-Id: 11d4b93a-204d-4d4a-140e-08de56fa60cd
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?upsW2ODpcZxE9qeUamUY19FFPrYUjXi3I7s2wARm6Zpu/c72qg8aZFbxro?=
 =?iso-8859-1?Q?lJsrmGX9HMsfzaCLYGY1pMMZF/dFSNwNTTN+/ZrznOgvoASaTV1CeqJI5Z?=
 =?iso-8859-1?Q?75IZPhKU/iLe73ihdh2KUd/LU3t9JgvmwqemrRN2dmM4WqZS45fhgzqGTt?=
 =?iso-8859-1?Q?QFOAplVEoD6KSpK1hm9bjiVlZ5YR0IocE5ZxxOx0cvdfBmu7FJJd2Ga/rk?=
 =?iso-8859-1?Q?zdQHb9VWlP8TbYE/lsR6F5OE/sCAR746ptAegsm7K14uNrHFl7LDc4lYX5?=
 =?iso-8859-1?Q?OrvJNvjRymFBNL828Cep90Wf1IHKVgLvZKRMOvX69SrSWaPW2ICPHQRezq?=
 =?iso-8859-1?Q?8mhN70LKC3YnQYZGqPkwlE1XXHnOrN6AIh5yJf8a/g1kC/PC8GgpVAGKTm?=
 =?iso-8859-1?Q?64dnxNkbq2gFovm6M342jlIO+5AXkqe86hOzaB8zCOeM9jEX3Cl1jRhWTN?=
 =?iso-8859-1?Q?iyuJ92Q2uFEaYtfEhulIMIeeDkfdi9CUzcWEZffbrDmAbg9XF5Gw/7N88Z?=
 =?iso-8859-1?Q?ITYG5N2h3ysAgcHjWnu8a+MFPOwFVWIzmDZjjFKcntvctAvQsV2TQQGHxZ?=
 =?iso-8859-1?Q?R79lj/lID9V6nIlNwOk8yqiP9hO1YLbLcJ98DwKfDdN7WSZbHhnVvwCda8?=
 =?iso-8859-1?Q?YxTgSbbmLUyGrTW3+QPtF5GKjEF1QcrX/AAmk1VMbhEAdAiFGP5lhCa4PB?=
 =?iso-8859-1?Q?kuQ4YSKP+jhFbIqKk3v/CBFv1tXL5JpemqYJ/mdKB89OZkDgkXfCLVQPSz?=
 =?iso-8859-1?Q?ixAhvG0va76gIY1JLh9JXBwRXXuehv8ro+b7cqfSNn7C7Xawtbuo0J/6rS?=
 =?iso-8859-1?Q?QIrbX64mHaDz8pzBRl+t/DY+n8sJAtlVW8ZyDalzDCpn7u706QG8OdYjiH?=
 =?iso-8859-1?Q?A9rkc0RvQw09ymNhhu24YsnVdaD6FJ0O7HPdHXROdrHk55qSzo/5Y8nEVn?=
 =?iso-8859-1?Q?+QTOv9QvDd2cTiYv+GyIQ2hw8Q3WI/ZQrNGoG9Hmn+rJHXwceeJCDodWZ6?=
 =?iso-8859-1?Q?Pd3tVNjkPO0LcjIeaCyGP/aZfmZs/htNP21RV9XcuMUrMSZhJNttN3Ly0x?=
 =?iso-8859-1?Q?nS+lRQkTHAEwIh7V4XKzzrnYgVNoQAedIIcpyphUIfF1fsFWcxDhpo8ZUC?=
 =?iso-8859-1?Q?RVpItg9u0wYVlV95lACpAWg0uxyH+00awVPKFguTR6iDk1SMhCCDsyFCwX?=
 =?iso-8859-1?Q?rVNTHNgXhzbQ6l0wTBUsLKtJYfxqaxhFqwInKxJKD1ProOOWbqI4e/KHwL?=
 =?iso-8859-1?Q?PvQBeTfKkirOpa6FtIsPY6ybEUUV4tGwXd3X8XhWIYaWhm2MR/t8eyOZat?=
 =?iso-8859-1?Q?QlkUvlHGDi+RhXFD4dlXzdrCPVYNW8zpq6BJULuulK5ujg4G5vcKHNOS4c?=
 =?iso-8859-1?Q?GN8E2TcCoNb7Ra+yEge42kKmeEkxjklu2Bt+sz0CI1YeVcTa9A6HJx7Kts?=
 =?iso-8859-1?Q?hfymUOU8xgvIPiAi6U6dCe8Glpu22iali7M2wSpwkoeq9rxVE5LLPiDM+K?=
 =?iso-8859-1?Q?a/r3ZaExDysZSiEzwFwVF55rasMHpv92LTXHC/4ZGMAJmSz30qe28XTyAd?=
 =?iso-8859-1?Q?JgQX2g2WxjN2JuKkKtHsDL/YeO61iQJb91AKjEgD4iwb7olJNWRdMKqL2i?=
 =?iso-8859-1?Q?1Qs67abzpM7Pc=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?ELrseUC4IimhqsMJoawkoPMLu6ue9BjmHDoM1QeWHkn2pk1pcmS1O+8Boo?=
 =?iso-8859-1?Q?RDnMJrh8M7H4Y8B4Igi8ZJ/r+bopjWQ8AIfq70B+9pRWcL59jfulK15DkF?=
 =?iso-8859-1?Q?a9qeFGckbwslu6MQTFGleC2XzulgKIY7xDMAyGuN7X3r4RzHtss0qr8eWs?=
 =?iso-8859-1?Q?P40Wpi4Pxl/63hlJXrA9j4iuyGX7UYJWQgqF/hfGqJ/kxmq3QnMhPHXeqc?=
 =?iso-8859-1?Q?o5Hnm+U5Rxex3CM+PJKw6xKyHC83IzhxcXDv1h77qX8odXN7qZ0otftf8D?=
 =?iso-8859-1?Q?yjWLZwDzqoRErDElvJk8idlzNWGNt6BreoZCwsqmF9DsvZ7Ees3mRWoWfg?=
 =?iso-8859-1?Q?7IWwU8uRklICWjXA9MsDpSF96ZmuCORZazML0PweYl/b8YABxNzxpLEkkC?=
 =?iso-8859-1?Q?A3+tz+y1jEZOGgs97VW8tKQoEJ8UiMtf66jhqd7TS8PhO2PmgPiflJPXm6?=
 =?iso-8859-1?Q?i1pfUI5+LJ5PBwFiVB7zjI/5ARNA37bbZz0hRBNQN8R4kQUo5K2qzjx4Dm?=
 =?iso-8859-1?Q?wU5rHrr/SO7w29liw1I6rkD81Xz3jGF1bbtufnPhdFJ0CI7qJMVEjZCe2E?=
 =?iso-8859-1?Q?Rk9zGBVeGhNPpWNMAnznkl6Dmmz7tNnmbJY+ZsJ2rngklozvXaaPFa1GvC?=
 =?iso-8859-1?Q?EXVmbnv5AK+cfDO+tf+a1WRo+ARfTOkeKm+lCTl5Je2gZ/+o/eyLUYnQfX?=
 =?iso-8859-1?Q?JjzPWVMN1mtNirGNSX4+irK5eIYDfWFT2XJo2rjM6M7zMIL0fzQ19IjNp0?=
 =?iso-8859-1?Q?6DZtrOP6AT3dL2adONm2ZiTdJU2YUHuLAQhNmxvJ7Vq4y0frhakXU2k5jV?=
 =?iso-8859-1?Q?K5tPIK0M1GZgT9SlVFAfll+F5oq4m0bjhuCR06MIP9Jkjd0wr+EnvQ5kfs?=
 =?iso-8859-1?Q?gY8aTjIXN3mxyoTdkdj//mWkNbTunKWkXwg2BEBGjCDqq0mFO1avAy7Ta1?=
 =?iso-8859-1?Q?PAk61nO6MiLXWod6pEHvAUJfshbnfxtliqyHVUVTWe8wABzCcxlQMqsWgH?=
 =?iso-8859-1?Q?ZDlxoTjOVSJSnCKDsnKh3NdcksEcBF5gmGqUEsouW11bu7ESFphaqI++ui?=
 =?iso-8859-1?Q?WUFZCLAm0HFnhur/9f/2gCUsBmWw3TkByxisagma2PktLThDQOAZaVRNox?=
 =?iso-8859-1?Q?uXWfpcBKtKlqG6kOrADYeDJK/Nh1ahVptlyN7/0nw7KkvBasIFAR98337Z?=
 =?iso-8859-1?Q?OEPaPoercjVUXg3hSp1tFmKCunS5B98nYIzWndd5P+b5B9STOMtmLwIpkZ?=
 =?iso-8859-1?Q?65IO5ZiZRuMQlvXnYGe7OD3s3F/zhsIBxQ8aiZyVHiTYaYFPhLFnXfh/s2?=
 =?iso-8859-1?Q?zOmkzi7O/4RfumgLdul7PQstyVrEdDxk2xQKh0rd5wFDEe3U09tvmx1G+1?=
 =?iso-8859-1?Q?dSYolZHUZz5y1Mpni+KfhEFdPaumVTgdDGu5nmg5wQeGVeyMs+xDWRgPNh?=
 =?iso-8859-1?Q?lMlJ/OeZYY7Mm1TeKlrPARxUfcbGNbePTJx5Lfp2PG2Ir00EjoulKaktoo?=
 =?iso-8859-1?Q?LDvzn3c9hClhjdLYfsWOodtX3k49RM0CzJeS5airv71s02FCtkGCd4IRDu?=
 =?iso-8859-1?Q?ut4lhvnJUPkLkb19qUnP1Y9cf4gpUhizF12z5VvALdHTtlp163XhmrYEcz?=
 =?iso-8859-1?Q?fEINJhkL6TmHPJ2LmLMbpAiVHfftiPm81FoQbYAhXKOPhpbGEWgWK99VkQ?=
 =?iso-8859-1?Q?RCAF/I4ox4LkpRPmRMH35Y359BlIzMxAY2fGL/aEpKXLvAQQNj48hZWBn7?=
 =?iso-8859-1?Q?sH7YM1AY7jUbL601gAtTynSLCY5KJ+QPnxeSy5cJJCToiYnOMSZYELYZL5?=
 =?iso-8859-1?Q?+VOMfmhGPg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 11d4b93a-204d-4d4a-140e-08de56fa60cd
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2026 01:30:50.4774
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6V46zcUlE6gXGFlHRU77sbj0KcrlnETl4bqzcVlaLuQ8dR5il8Yf9ZfO1HLqWuld1LCZ5AC5Jx2Bsyv9xMq76Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4879
X-OriginatorOrg: intel.com

On Fri, Jan 16, 2026 at 03:39:13PM -0800, Sean Christopherson wrote:
> On Thu, Jan 15, 2026, Kai Huang wrote:
> > static int __kvm_tdp_mmu_split_huge_pages(struct kvm *kvm, 
> > 					  struct kvm_gfn_range *range,
> > 					  int target_level,
> > 					  bool shared,
> > 					  bool cross_boundary_only)
> > {
> > 	...
> > }
> > 
> > And by using this helper, I found the name of the two wrapper functions
> > are not ideal:
> > 
> > kvm_tdp_mmu_try_split_huge_pages() is only for log dirty, and it should
> > not be reachable for TD (VM with mirrored PT).  But currently it uses
> > KVM_VALID_ROOTS for root filter thus mirrored PT is also included.  I
> > think it's better to rename it, e.g., at least with "log_dirty" in the
> > name so it's more clear this function is only for dealing log dirty (at
> > least currently).  We can also add a WARN() if it's called for VM with
> > mirrored PT but it's a different topic.
> > 
> > kvm_tdp_mmu_gfn_range_split_cross_boundary_leafs() doesn't have
> > "huge_pages", which isn't consistent with the other.  And it is a bit
> > long.  If we don't have "gfn_range" in __kvm_tdp_mmu_split_huge_pages(),
> > then I think we can remove "gfn_range" from
> > kvm_tdp_mmu_gfn_range_split_cross_boundary_leafs() too to make it shorter.
> > 
> > So how about:
> > 
> > Rename kvm_tdp_mmu_try_split_huge_pages() to
> > kvm_tdp_mmu_split_huge_pages_log_dirty(), and rename
> > kvm_tdp_mmu_gfn_range_split_cross_boundary_leafs() to
> > kvm_tdp_mmu_split_huge_pages_cross_boundary()
> > 
> > ?
> 
> I find the "cross_boundary" termininology extremely confusing.  I also dislike
> the concept itself, in the sense that it shoves a weird, specific concept into
> the guts of the TDP MMU.
> The other wart is that it's inefficient when punching a large hole.  E.g. say
> there's a 16TiB guest_memfd instance (no idea if that's even possible), and then
> userpace punches a 12TiB hole.  Walking all ~12TiB just to _maybe_ split the head
> and tail pages is asinine.
That's a reasonable concern. I actually thought about it.
My consideration was as follows:
Currently, we don't have such large areas. Usually, the conversion ranges are
less than 1GB. Though the initial conversion which converts all memory from
private to shared may be wide, there are usually no mappings at that stage. So,
the traversal should be very fast (since the traversal doesn't even need to go
down to the 2MB/1GB level).

If the caller of kvm_split_cross_boundary_leafs() finds it needs to convert a
very large range at runtime, it can optimize by invoking the API twice:
once for range [start, ALIGN(start, 1GB)), and
once for range [ALIGN_DOWN(end, 1GB), end).

I can also implement this optimization within kvm_split_cross_boundary_leafs()
by checking the range size if you think that would be better.

> And once kvm_arch_pre_set_memory_attributes() is dropped, I'm pretty sure the
> _only_ usage is for guest_memfd PUNCH_HOLE, because unless I'm misreading the
> code, the usage in tdx_honor_guest_accept_level() is superfluous and confusing.
Sorry for the confusion about the usage of tdx_honor_guest_accept_level(). I
should add a better comment.

There are 4 use cases for the API kvm_split_cross_boundary_leafs():
1. PUNCH_HOLE
2. KVM_SET_MEMORY_ATTRIBUTES2, which invokes kvm_gmem_set_attributes() for
   private-to-shared conversions
3. tdx_honor_guest_accept_level()
4. kvm_gmem_error_folio()

Use cases 1-3 are already in the current code. Use case 4 is per our discussion,
and will be implemented in the next version (because guest_memfd may split
folios without first splitting S-EPT).

The 4 use cases can be divided into two categories:

1. Category 1: use cases 1, 2, 4
   We must ensure GFN start - 1 and GFN start are not mapped in a single
   mapping. However, for GFN start or GFN start - 1 specifically, we don't care
   about their actual mapping levels, which means they are free to be mapped at
   2MB or 1GB. The same applies to GFN end - 1 and GFN end.

   --|------------------|-----------
     ^                  ^
    start              end - 1 

2. Category 2: use case 3
   It cares about the mapping level of the GFN, i.e., it must not be mapped
   above a certain level.

   -----|-------
        ^
       GFN

   So, to unify the two categories, I have tdx_honor_guest_accept_level() check
   the range of [level-aligned GFN, level-aligned GFN + level size). e.g.,
   If the accept level is 2MB, only 1GB mapping is possible to be outside the
   range and needs splitting.

   -----|-------------|---
        ^             ^
        |             |
   level-aligned     level-aligned
      GFN            GFN + level size - 1


> For the EPT violation case, the guest is accepting a page.  Just split to the
> guest's accepted level, I don't see any reason to make things more complicated
> than that.
This use case could reuse the kvm_mmu_try_split_huge_pages() API, except that we
need a return value.

> And then for the PUNCH_HOLE case, do the math to determine which, if any, head
> and tail pages need to be split, and use the existing APIs to make that happen.
This use case cannot reuse kvm_mmu_try_split_huge_pages() without modification.
Or which existing APIs are you referring to?
The cross_boundary information is still useful?

BTW: Currently, kvm_split_cross_boundary_leafs() internally reuses
tdp_mmu_split_huge_pages_root() (as shown below).

kvm_split_cross_boundary_leafs
  kvm_tdp_mmu_gfn_range_split_cross_boundary_leafs
    tdp_mmu_split_huge_pages_root

However, tdp_mmu_split_huge_pages_root() is originally used to split huge
mappings in a wide range, so it temporarily releases mmu_lock for memory
allocation for sp, since it can't predict how many pages to pre-allocate in the
KVM mmu cache.

For kvm_split_cross_boundary_leafs(), we can actually predict the max number of
pages to pre-allocate. If we don't reuse tdp_mmu_split_huge_pages_root(), we can
allocate sp, sp->spt, sp->external_spt and DPAMT pages from the KVM mmu cache
without releasing mmu_lock and invoking tdp_mmu_alloc_sp_for_split(). Do you
think this approach is better?

