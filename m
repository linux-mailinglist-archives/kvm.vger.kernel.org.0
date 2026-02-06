Return-Path: <kvm+bounces-70401-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gOMQGKxShWmV/wMAu9opvQ
	(envelope-from <kvm+bounces-70401-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 03:32:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B5F76F956F
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 03:32:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F0220302591F
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 02:31:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1943526B76A;
	Fri,  6 Feb 2026 02:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SSFTubbb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD6B156CA;
	Fri,  6 Feb 2026 02:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770345100; cv=fail; b=p0SltHZoHLwjYQ3rKEdrA3cyhH5c8X0zzJyVF+ytMy+q5i+3yisY3+3X+JPrD43Qf6dMP0nkXBfIL9xAddPGRm2TLUeEEHbyscjX3Q0a/D1ARt0rDlf5rsOojpHL/WtHUTElxlYe8WsQSDTZADNY0RXt2zppMPN+wTMr8r8gtUk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770345100; c=relaxed/simple;
	bh=AD6EPSslgAMKUoyQesqHylhNFK6ymst2efiA3AuRIao=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=utOqmYIjHr4K9FWLjKX2C6BwQ0/A+FoiWQL1FqMwN9FNbIH3LfJUzh7CPrPZfDlFt7Z+Pc9C6t8knDKk1agtA7ewMNtDc58ZoEKv/vwSB5xVkO6kNBedoeLdZv50rLJH8Njw/ldmscZmiijigEydLDuhID/fE2Tt6oSSQC1872o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SSFTubbb; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770345100; x=1801881100;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=AD6EPSslgAMKUoyQesqHylhNFK6ymst2efiA3AuRIao=;
  b=SSFTubbbjcMnCvxSCtZAWbIrel61jURj1+IMTQmgj3dVSxJPXtQkCqCq
   ylRTJb/qOx72kG/3D5Wvqync+BcmjY5Bxdw9wAsvcm1FAFpsPgihqlmJa
   inuEopNSETIEJiges0ILhjWB+rKJIiMDD4R8eKeiliHJy0BGA0laAufNh
   caP8rsDSjYH8vQ/iRsn49hD5jgL4BydSyiV8hpIWXRZ1W7KBBk4LOKN2T
   yoTNxsGPFbRTdrsPvPYdyJKb0uk3rDHDEAmkgUN4x5eCaSNvWtddq+q93
   nkcYhQkkD5NO3B3NbnTjEQw5htSuIbDJW8AItz/j1PWYYtW7UZ1BXMTPd
   g==;
X-CSE-ConnectionGUID: V32gIX1aT1aKNaKg6nGKMA==
X-CSE-MsgGUID: Mc/g7yQoS1mxIKclwsewLA==
X-IronPort-AV: E=McAfee;i="6800,10657,11692"; a="71547046"
X-IronPort-AV: E=Sophos;i="6.21,275,1763452800"; 
   d="scan'208";a="71547046"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2026 18:31:40 -0800
X-CSE-ConnectionGUID: kH5UARhUTGipRS7/HCtOZg==
X-CSE-MsgGUID: /pQt99p5SceDB/xtIieqdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,275,1763452800"; 
   d="scan'208";a="209831242"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2026 18:31:39 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 5 Feb 2026 18:31:38 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Thu, 5 Feb 2026 18:31:38 -0800
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.65) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 5 Feb 2026 18:31:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vBR3L/JiIxurFrzkwS8xMhRioF7wasD1taPFbsGsHl+AR5KjPYpPGknJ804tXkJist+Q2AyNKP6rI7+mJsqKdniVVDFFMQrlzu0jXz82OhZ49CEb6ijTcvR18HoDwlohpGpxg3KluBzYG+bGBbaPuwRnvQqRWtprvTxKoYBY5FI2AQEn+Yfyp7NlNnjehiFQgMjRFwVrMpNdk3VNMACH+r8nRpRSRLILwJ156VkSMzasRmOzLZAnE7itHtodf6x4TgGoUNPLspQ2lMnUHiVdN/QGpdiKcD1UPtkmZZwiPIp5ZxJodgoU+T6f4yJjQvAmarcQBz9gOo/R+ulhrLGChQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NFhW7RRdEZ8nXuF9l3ZssRoWt06fOus1NmUzJw/nX+c=;
 b=NxIsRSoZA9fI4R9lh52jwb++7ZzEom9fiFxXD52svmXFKUAkAp/zlkDSO47MSHYzvmWxkJ6UwhAC0IzNFWcFvq1jBZk8E1JP39Qp76jEndUQYN2Hy0Eb/gbLU7l7gz92CZ9rppIAhYN5qKdH8K+CHfSxCdnfXiVw1kdZLH5WC4+1/Y0uon0uMrwhGjNmjrBx/PWVBjYt5u3G3GLbC2sMfExyhfSGvjQo0P7+TqyDg5XyrYMnY7325JuRK8CWiHV4uut04uRt7hdXftBBJ6s9kQopzwtJc9G2nsLgzFgEE7LVf3PXnAC6V7PjVpGpB5GUzbVeMlwE487w9BMPg19B+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA1PR11MB7892.namprd11.prod.outlook.com (2603:10b6:208:3fc::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.12; Fri, 6 Feb
 2026 02:31:35 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9587.010; Fri, 6 Feb 2026
 02:31:35 +0000
Date: Fri, 6 Feb 2026 10:29:10 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, Paolo Bonzini
	<pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>, Kai Huang
	<kai.huang@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, "Vishal
 Annapurve" <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>,
	Sagi Shahar <sagis@google.com>, Binbin Wu <binbin.wu@linux.intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Subject: Re: [RFC PATCH v5 06/45] KVM: x86/mmu: Fold
 set_external_spte_present() into its sole caller
Message-ID: <aYVR9qgrlVayPAel@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260129011517.3545883-1-seanjc@google.com>
 <20260129011517.3545883-7-seanjc@google.com>
 <aYL3izez+eZ34G/3@yzhao56-desk.sh.intel.com>
 <aYUijQwl2Q6Q81DL@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aYUijQwl2Q6Q81DL@google.com>
X-ClientProxiedBy: KL1P15301CA0050.APCP153.PROD.OUTLOOK.COM
 (2603:1096:820:3d::16) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA1PR11MB7892:EE_
X-MS-Office365-Filtering-Correlation-Id: 9dd181f1-8a31-447c-6b02-08de6527d8de
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?wxAxXVratSxNrFQq+lsfJoKVSx2utGtJoiR7WSrK41I1By2b+MOK26K+TuzT?=
 =?us-ascii?Q?zSVNk8Q6cbpA8oTrCY+0WwS69un3QS729e4Ihrtq53NQnT5yx+9U6F8L/9BO?=
 =?us-ascii?Q?0EysGMYx2x06gJWwnq/7MJETtw+n2A35dop4FJb5Y0BAVBX4eXtXJbwNGtfj?=
 =?us-ascii?Q?UrjNOH61mqUzdZSbFrrF9CERwP5P3/ciT4TL3ITjWB+H+7BhrSzqML0/YMHh?=
 =?us-ascii?Q?FrR1MsDJAUH2bSzaFTXjW4/YdEoSgHFA8a8BVWo6MvnycORA/XbztHtoV5yz?=
 =?us-ascii?Q?mfw9XXfNberbJb3W+UIya75ByNVKkwq+bMNQDO97cerImAjR/O8GZ6itbUuG?=
 =?us-ascii?Q?kGQba1lDmOX7T6/HnFWOb1thDLMC7hg+XWo7HSu+lHATMm2nqLplYVOVblLV?=
 =?us-ascii?Q?FM2C3EMYQoD29iMWjcF/e2EER0zTnXa8x2mpLwc14E1CsMIeT5oNqMKSfYQh?=
 =?us-ascii?Q?HX9uLmYd9uZf69ioaBO5NvRPKrDAydXPxlgJmXRg2OGHJD6yBrHX9h50JajR?=
 =?us-ascii?Q?x33XvPlN9M1+WZyF4eXnKZmQ0QJHlkJtIiG5y/I+sD4Qs0CXw87HMv90NXNB?=
 =?us-ascii?Q?Po+VlP6Mx24U35E8F9m+OX+Y7kWtsH9jiJBv5ClcuclxIz4HhXxGuD/b945C?=
 =?us-ascii?Q?kN5ZzvrCKxWPQ+3v98NZxQEIYtrOy7W48nwcB/qj0xjf+YvXZD/4FtPW+9Hb?=
 =?us-ascii?Q?PV0F1hVTttqp5Ev9k+ELrmxwYlcYATcWsBG9oDouI0D0TXW66WcPAWn15TK4?=
 =?us-ascii?Q?aKbfuPBX0EN2tlR5+aIAyuFZcWm/sa4hyqY0nb0a5rCiB6XXjti8xYS8npvB?=
 =?us-ascii?Q?fcbb9DzIde9Sqe0CWm8AnjG9Csj6rL+LpgQojAZPveOucC+sd6/a/j0CvjsV?=
 =?us-ascii?Q?1sz8ZhUcA3g9BjKubFSFRrVEXRESJjrQcli5JQRpqL5PEMM6x1naRkkRCHzO?=
 =?us-ascii?Q?yIEXjP0X8FxDfMXLFrBBIASdXQuoEMpyGTV+eJC8fkvXlEv16aA0mpmvxcdL?=
 =?us-ascii?Q?vnsBsF9d0lChhP7SUSKMVtj8ARNH2+6d5/fJdwbXfsiu/CK8U2g+kzX/VGYv?=
 =?us-ascii?Q?6iEiRxjosFpNpiEUh+4ntsnvtfOimIe67j0lEQzu7iN88bYUspxyFoHl88Px?=
 =?us-ascii?Q?08R2ESHbKbnVVRhRGPeSk5RLSuyR367l/aUhN5aHa4qY2d6PfFt3q7aQN0av?=
 =?us-ascii?Q?apELVveVwDhoJP3JhGAUNEyNQXa4c5FyjTOsbimt+5hPQ8v3rRKFi+aq72+D?=
 =?us-ascii?Q?gR5dYCr+ZpOpyoKU5tLl4clabilg1USJkOCrlPmzhuRYVWCsDQMNswGgUoSb?=
 =?us-ascii?Q?6egYEH7jR7quM2Zr+xKW7KI5ksS2cIhea80JGlo81+aNiYB79imkJWqRR0Xx?=
 =?us-ascii?Q?JjGiwxFmMiFcqrG88KZ3hybkl7MAMn83IUnxJ/oSGeDLxKVcnZTV7RbbqvNb?=
 =?us-ascii?Q?anaV3TTztd+z5GfQYhFIQkW7jHkQJLl5iKIofa/rZ4kavKJv/Zif+2hJL6Rv?=
 =?us-ascii?Q?6c8SxePVVQWhXMfr4NxFpqNLh2npa9ck5aHP/oOEu9fR84vXlZ+sM7JMISge?=
 =?us-ascii?Q?lMYUDviZYy8YCLSgdU4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/GlyxFGEJvwT1CDV2YLxS5cPL+imUOjVMYEeDAacYFsFnMwCSq0fFDG7xDEY?=
 =?us-ascii?Q?VfrmKT1gwW8AI5JGaF7d26ZW5dlEfGWNPssAszqdTxcmlw79WzyGcg/t7Cj+?=
 =?us-ascii?Q?Ll0xJXG0GzNXg4pbzzmJKsV8PlydxhwXkH4CWDhrqJFPvRlRGp7chfmm5G1E?=
 =?us-ascii?Q?Zt2gF+0lxy3kM+Lv551tiSyDmceGENR3sw3eODfYgGWHtj6AKNkQAIoFWNox?=
 =?us-ascii?Q?RVbgPuDKhHxIPI84GUjWjrlYeETg0pXp9jdP0lfolBRHzle4Q6IJVZHrntWl?=
 =?us-ascii?Q?Ta+j3c7HeIojw1eB/cPRvqaDv4EtlWRWZXyqnPigwoGecGAIBs9vb4gNgR3c?=
 =?us-ascii?Q?K/GSlHiyEH2Q7t9+NESIYEAQZFe7UFxw7QqTSCYcwpnY9dXGjcpck3nza1My?=
 =?us-ascii?Q?sWLLcOqg5R/3L5z+Z78Hk4NFMAikGE7SYtWFqzj4hYwMx0ecJFWg1IROPk6e?=
 =?us-ascii?Q?PxLN1pXhdhsQOpsrWV/nWXpMGKoZh6oFBdC+sTMjq62Q1hSnJbyReAn5eutT?=
 =?us-ascii?Q?wx3ydzuctBpTvOTC6bD24whCIn/f7dNkXhD5URrlWreT/ZYuqPcDucmTodII?=
 =?us-ascii?Q?inO5LVHmoAjRYaE4+VDw18dq5YLRAlGttbC+PgDDTGNkhxXWPVJWzdHiWL3F?=
 =?us-ascii?Q?1T1TQhApL225FGRSZGJufz4Nik5n5HdN5Rx1GoL03w6biw30cayEuAz9AKoD?=
 =?us-ascii?Q?qSNh2ATCFbM8McZPd0HOAHni/+0L4jHlFq0st28H/tRoHNN7mYgDAcwHsGw1?=
 =?us-ascii?Q?FGgsP2LQ0jRSx+luSSPz8M0R8cfgHEIynhdXyRc3UI95vRrD4QIUYKR/gcVz?=
 =?us-ascii?Q?YoXWsJi4o/qDk/wX/3DJIyqZnDWbn7qPvQSXNILVIJTI3AFdO2a+nTmkMmvX?=
 =?us-ascii?Q?O61DHSUtFhyeu722HgepSSfX6UFvHAulZWrEK8VzaRyoTcK/KZ88u4NhbXlK?=
 =?us-ascii?Q?UY/E1Il/fIdNMhEdHqgc99NiX+qa4la6mI1z02iVdP87tVC5dCAjxv4xnF4I?=
 =?us-ascii?Q?gdXwu6lHWCYbFKuMl7Hon/jfoJlcJsHQa/lx8ILoKxPu26F0oV+q6KqsxqNF?=
 =?us-ascii?Q?Q/ufvNi+Q0o5SrN+NghUlLHMOVYIVitqJ4kn3lIz29Vkqg+qvHPGUXZhFlYg?=
 =?us-ascii?Q?uv38I1OfJbl+bz1N32cFm2ucH+IKQZLZxOcipW9o1h2hnus8SaPQtyj5lXul?=
 =?us-ascii?Q?H9cqBW9DWR7EjEhP1bmIT4J6dpzCQLW+Vl56b8PYBVYy+PTzn/jCoKTgrcFE?=
 =?us-ascii?Q?+AyWGQgNIRMa8gtLmHh5bqXJQA8YzNZqf1gU4asgvzRjJmZoFYjetzXSiXDD?=
 =?us-ascii?Q?aD4BEfEFOOhY92z4rFzLLLwgFz7fvP/cM74IOBz59EOGNKquaM96c+m6XChd?=
 =?us-ascii?Q?Y936XfApQ+ZxOh+RU1Y+FpaUn0SYtn1jQ8lCalmFwZdRQzVT8rr7kjV5hkpz?=
 =?us-ascii?Q?il5euZYuFCJubwTQmcB45LN3s+EH0vXqnperfhB9gbeS6eWU3jSg9ko+QlZ3?=
 =?us-ascii?Q?O6oGFtvlYD2OOg60h0xJ10b8u+6zE/TZwbXw7H/As+wK/l1qzbd/L3qa3XTz?=
 =?us-ascii?Q?YOBE7+9n7zpdy4yJ5NoprX0Y5+6k9VVO+Qg/3h53Tc5dNAnzPiiGntWaIpoY?=
 =?us-ascii?Q?Np+b8sOddfMSXJ93npbR5U54w6a+SuhPkAzUXV3DakUwEDVo35YoHwJMv1aG?=
 =?us-ascii?Q?ZCc09vrXGNhULJYcLl9Le++IILCf7m1UpOTousbj4CDYvgeKGPeHuMSGEP1B?=
 =?us-ascii?Q?yFGSoBVc8A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dd181f1-8a31-447c-6b02-08de6527d8de
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 02:31:35.0735
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0VhFyocy59qs4y22HXZ+Zoi/IdHdjf1wFS/ZjFOH4hsD+HjnRIBxvSJU2PGaPOku0j3aZPz0aq1wam0dj0Iy6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7892
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70401-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[10];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	HAS_REPLYTO(0.00)[yan.y.zhao@intel.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yan.y.zhao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,yzhao56-desk.sh.intel.com:mid,intel.com:replyto,intel.com:dkim];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: B5F76F956F
X-Rspamd-Action: no action

> > > -		ret = set_external_spte_present(kvm, iter->sptep, iter->gfn,
> > > -						&iter->old_spte, new_spte, iter->level);
> > Add "lockdep_assert_held(&kvm->mmu_lock)" for this case?
> 
> No, because I don't want to unnecessarily bleed TDX details into common MMU.  Ah,
> but there was a pre-existing lockdep in set_external_spte_present().  So I guess
> that's arguably a functional change and should be called out in the changelog.
> 
> But I still want to drop the assertion (or maybe move it to TDX in a prep patch),
> because ultimately the requirements around locking come from TDX, not from the
> TDP MMU.
LGTM.

