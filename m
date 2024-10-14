Return-Path: <kvm+bounces-28807-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 17E1C99D711
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 21:13:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8714D1F239AF
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 19:13:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 568A91CC143;
	Mon, 14 Oct 2024 19:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UA295GxR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 744E620323;
	Mon, 14 Oct 2024 19:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728933207; cv=fail; b=lWVukQBfNZXbVdgfpCMB1ofYq6nYZdFt6SNDw+h1HJ/J5qho/PRFWF9rWfh+zBPm3xJ+0jhM0f5rqTGfWSiSvjWR05tBw96UyhuOFfadRxDtkab0HYAvPGCcSPB4e1jj7MatWiFd+lnULzMAAQPYr3v0hZGx62a9PPDHAmYVc+w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728933207; c=relaxed/simple;
	bh=ffltj1P/3kKpOIVFnkLih3MIFtkID8LyOdkidpaDTRI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Lptoc0NJ7WRTz8O1iVrjCFtIkt2IN54EJ03prJpmqnSfPT6C5MYHPaBSVIAiWg4JkCqdTYZK9zY5RdxGbQqEeqfcfjcu/YWrhDcgVsjLmgsuLHS1UB8ldo5my+z7I7Df2VyMmP4o1Lb2smPx9eYYTvaxKkeKV+9hY0PJMjAdaV8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UA295GxR; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728933206; x=1760469206;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ffltj1P/3kKpOIVFnkLih3MIFtkID8LyOdkidpaDTRI=;
  b=UA295GxRXkGgC9cKNGQ3IcLvlf2NdYdQxKOMaPd9GL/vhYNMT/RWVSRh
   9Evj+GpWKq1Cyt3Ne09UsifkTrUTSUmSQkw6O2yWVOzOaIcQjSywvFyN/
   d6oT/iAPqNrj0zZnE25JN5PMrq+98asRdOB412HWJ06Pz9yJp0yxrCVFG
   QAz169wpLXNrb7rVa65gYq8DkhH0QkvIzYQIam7XqDTX8o9jaMQk7jv9N
   7EQs1BEnFe9xI0LDnlnzfp3wPMPiQ7/PMXgjXt/J5OLzRIITVE0N1IMVl
   cEOgTtX4GcT+Y/ziv/zt5Y9YVb0YtSrcZhC0FHWMZEhUbQ8c42EQZv3If
   Q==;
X-CSE-ConnectionGUID: HYhQLtFcRce+ffzgMzEiPg==
X-CSE-MsgGUID: SMONW+2MTUyzY21pGz5G2g==
X-IronPort-AV: E=McAfee;i="6700,10204,11225"; a="28485963"
X-IronPort-AV: E=Sophos;i="6.11,203,1725346800"; 
   d="scan'208";a="28485963"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2024 12:13:25 -0700
X-CSE-ConnectionGUID: U4RQI3H9RM+UOB9jwTxtCw==
X-CSE-MsgGUID: hd7yARxiRVOB55vBIctD9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,203,1725346800"; 
   d="scan'208";a="78110603"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Oct 2024 12:13:24 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 14 Oct 2024 12:13:23 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 14 Oct 2024 12:13:23 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 14 Oct 2024 12:13:23 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.48) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 14 Oct 2024 12:13:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X6O4UTUG0ay1lxDdG90znQYND0ZPMUhi28F25p/tEJm4Q/iyFHzBBU7SQzwOl8vSXRT5vxqhGhXNVQk2nfrK2vEm3Hpvxo6ps+vsFTYvjDSfvOouNwpuFzfoERtd5cFe5OAfvbGCqm5AwGz6LOhpSYlT6wEsdlPENletWfkqAHJ5AfdOdlNjXIxzF7wby4OTmzhrkU7nB5SBgf5HRzlUWfWe3CyVHltPh0bpUlIh6m/8gC6zc8nNLpu87/Ex0DPhaVJB4SnXHZ8pYB8DRhTTQIJmies+T4OGOdqgrZEpjRc4Cpo50Ehf9WRyVxfks8tPzgPXRyxXatftfpcK3hOLBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/pjYUKE9vkoGQfxLOjCNBYbboEsKDzcl6wAYYrG7K3s=;
 b=qLVZbaaoxs8Wcz6Vxbcn44ow2FKeN1FwxiA8qAS7De0KZ2ZjbS65ZXOveF87Ha3Ha77+FzWU2jJuUnc44mt9P014xFcSO028NTr9UvfVzV8spfpyrunKFOWKkK076720mCv0uboOtK+Raw9XeIH+IFV+wXD9JNY2defLTSSpCsBOrLB4dS7KTy4MbgOEp/32nqgFjFTWFYWHa7r7VM1CAAGfrfEM2JNkZRWMAgRqhfD6c0PYeSil+5puGhYrxfH+KHmV0bWUPUqY/Zt9aqpg5A+UKEpKnMs2L8GDfqeIxpR9W+XhOMfmUgQSikjmqgjBR4fNzyXCW6MdAZEixpa6WQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DM4PR11MB7398.namprd11.prod.outlook.com (2603:10b6:8:102::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.26; Mon, 14 Oct
 2024 19:13:20 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%5]) with mapi id 15.20.8048.020; Mon, 14 Oct 2024
 19:13:20 +0000
Date: Mon, 14 Oct 2024 12:13:16 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Dave Hansen <dave.hansen@intel.com>, Kai Huang <kai.huang@intel.com>,
	<kirill.shutemov@linux.intel.com>, <tglx@linutronix.de>, <bp@alien8.de>,
	<peterz@infradead.org>, <mingo@redhat.com>, <hpa@zytor.com>,
	<dan.j.williams@intel.com>, <seanjc@google.com>, <pbonzini@redhat.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <isaku.yamahata@intel.com>,
	<adrian.hunter@intel.com>, <nik.borisov@suse.com>
Subject: Re: [PATCH v5 2/8] x86/virt/tdx: Rework TD_SYSINFO_MAP to support
 build-time verification
Message-ID: <670d6d4cab43d_3ee229434@dwillia2-xfh.jf.intel.com.notmuch>
References: <cover.1728903647.git.kai.huang@intel.com>
 <f3c63fb80e0de56e15348d078aa3ba1b1aa9b3c6.1728903647.git.kai.huang@intel.com>
 <c3b1e743-6d34-49ce-8e60-a41038f27c61@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <c3b1e743-6d34-49ce-8e60-a41038f27c61@intel.com>
X-ClientProxiedBy: MW4PR03CA0326.namprd03.prod.outlook.com
 (2603:10b6:303:dd::31) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DM4PR11MB7398:EE_
X-MS-Office365-Filtering-Correlation-Id: f255e4fa-2758-4e05-e867-08dcec84442b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024|921020;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?PCo2wws2/nzm2oeUeR42vHUglu5ItJ75uaS1fho3XjLQENUnSlvxxDoFuy/b?=
 =?us-ascii?Q?sacPWKG/VkXYRmb41wsEhuvFyV+ZdjWi4x9KgEw7U27azpfd4FycHf84QfCk?=
 =?us-ascii?Q?f6qLCqgsNw1CxfXx4RGEDAvjIyFacRxpfbVTpaOF7dl2PFq+XbwmlPUKFdHw?=
 =?us-ascii?Q?HEHYpqJwftcwlk47NXuD0wmuV4iSTmfdJjhEdYOWVW2UcGu4yY6gg1k5fvZC?=
 =?us-ascii?Q?+7HTni2b7Nx7WVCW2YgY/L7xDdzDVQ39XWrA8z3sRN7gI0PsuFlHkc695wo/?=
 =?us-ascii?Q?PoDaYKXXBBJYstZfFEIyqi4aXqslu0ZctPbfSxC4KjDRS1cpPLrttGIhlaCy?=
 =?us-ascii?Q?RBOKQOMDs42HWb78wLidwH1VhudoQt2HVoIIA6SNmUnvdi/DKFfGR0Gslpc3?=
 =?us-ascii?Q?zcuXwI/T5nsxeVF5ItCPIqzQxRMlZWQNd3xZGgs7D6uZcu2qFUvZaJtTL95/?=
 =?us-ascii?Q?uTA7kVrbKGQ0ML0YYRbFdTQlfqn/ezr7KWlqYABC+ZDdeSq6/fYGX4Xac/+L?=
 =?us-ascii?Q?pa2zX7SB0u0OQD5TPkrZCsqG0HWvD6YchK50icWHyfc82U0PJvKW7fkDoaZv?=
 =?us-ascii?Q?+/bcEOwU3sRu6ftF6ruuhzdhu8gFad+xYbjNKm9QIBsIQw61QaDPJMFfWvtf?=
 =?us-ascii?Q?ytSojNCTPxwgG+xdhSoq05UKqCPTLsj6Iw+lpy5azPazvKAzw97jY8qlGJRu?=
 =?us-ascii?Q?kQRqbCk0SbcVk/eVmUcUG3xpmJeqBj/s9SGNlvaDlEu6FbYVX9kHAzM7r2pT?=
 =?us-ascii?Q?OGQi6lJV8tVpOzUAybm5AQgjiOSqgk37/KU2EPJ8cT5J17mX3iMCAQJ91ltp?=
 =?us-ascii?Q?NUFwJcqK7o/KzfBLMWfmQl+lEqYRiH3E4BzQ5hDAJswsnkFTu8zgeuMJnrpz?=
 =?us-ascii?Q?+KjFxds5XjnCrraGQxUPkbpdq5esIgWMT2kf+Rt4UsObIK93fmUHxEYpveNT?=
 =?us-ascii?Q?zUXVHUxy9uzroIaSrcug984pCOnaJtfLwbKmkqk1W58JDVYQ0B8cKGx8uUCh?=
 =?us-ascii?Q?4ljWU7cff1rzfGDbDR+578nLbYHBEpBU6DxaYcAkeB98KMW7c5ZhxDDMuStw?=
 =?us-ascii?Q?MzlMNmJAiVAQjX2s+X7lP/7MS4pIbzKFNqXXTfufGy4JFu4/cdMmAGdDq16g?=
 =?us-ascii?Q?rD7nWKNWJN+b7Qong3RhS801OyjC/Az9aqitN/+Ll4CXZ0TFCTUQcSwrax02?=
 =?us-ascii?Q?eIU/rcvnE6Lmdt5nR7n5ryr/op5ZR1pB0tiJiheYCCV1MDYIjOQe6fqz1Z3+?=
 =?us-ascii?Q?8XE1xdOsQEjPkABhZ+rbppZO3HH/DxdLN4d1UGlWzpGnKdHmkh3gq41ea84+?=
 =?us-ascii?Q?1Nsd6UynNzQnvgBG5R7pfIH1?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UyM+cb41N6YJDSJpXzC+yOJBLjIBbxxZy6LSOfuwijUgoSKINc5SK9FkTq2t?=
 =?us-ascii?Q?63iE9LJqOUmqs468VT4EHp4KUhuSYSRBF+hzh9rbLdVApOaL2W0DkHlBeIPF?=
 =?us-ascii?Q?8raZJTW8YxPK25A0hEM8s0y78ifvL4+L2dDIjjDL9F7Xnd9i763V4kOImjJH?=
 =?us-ascii?Q?/4xebabHJ+/F1pGIgUndbg8yyP2tS195guZhEGN98Or4KfV89F3zBR4Dor1m?=
 =?us-ascii?Q?Y1tNXjZBo2CZ2wn1hSboMJrJS9TAs5Ilxx8zR2LaV2pZ3MQF/VFzpL0oMXpc?=
 =?us-ascii?Q?BS3+gNTP9rzkoSVAhjkKNJen1WXr9EjBuElYToFYGg1RiVEJzYuf21xuPHxo?=
 =?us-ascii?Q?vyn6LlZfJhmLyG1Wr3OnynSAfQv4MN0B9lKoU+fGNZ4iJC8Kt0SMVC7Gy0pQ?=
 =?us-ascii?Q?BeY/tfKx2+6t1BH7tlU6w3oO49TDLM5R0qlyPMZcC3T8FEfBPQfE7S/pb75F?=
 =?us-ascii?Q?WpHnnTdUfQ7HgbMj7j1yLNpNzX9wjoVUTuHepekGLyP0y20eXdSz95F67gW2?=
 =?us-ascii?Q?MEfUuV/HuXQuB4py0S1O4TX2f2AK4MQh9pdie3IzNEyFZonvFVyrJDLVzZkt?=
 =?us-ascii?Q?qeYrUFdaSCAAuPFiBXG0NvCols3WT6zNFS4HXS8zC2gG6lmZgHZGxb+4zkLo?=
 =?us-ascii?Q?feHBAkQ0yq12mNDh22bqEu3mwVnGjxqrigdTVmMamlkAoQJOVc6ChRlamsNM?=
 =?us-ascii?Q?GvNE3QkfhCaerLKq9Tq4h2ds+tRIVh7a3S7L/fpa+PWq2WyAoW3tbBjsvTYe?=
 =?us-ascii?Q?LbzhpILHWaNBDXxE5J2fU6Hnvab1iSPOmN5hicA7BG428e1SocYqYoTpb0v4?=
 =?us-ascii?Q?ELPyhumWVt+Ckxh6Ad1ZY3PU/W3eM9aY8MATZ9rHLdwU1VPCTuYC4Ex3kE1C?=
 =?us-ascii?Q?yb0eOGp6OT9upXt2HbDiYPQr1r8QrnNLT0tv0C61CsBifnYnXyEPtPqdCfmr?=
 =?us-ascii?Q?LH2hFDExbzM/7eOi42vM7x2Ike19YFK8+Ag7W8+4HRdhw6n/QNmXKup+mz5P?=
 =?us-ascii?Q?tMYjYdZl9dl/Bq7oYCZDLx95vlgBnUpVLqJk41d1miSbTwUmq7sKLAc+5/k1?=
 =?us-ascii?Q?mFDL6c8swVyhXizwbx4I1JoSU2JSErAzZsMq3n70RhUWlMGJxuxq/N0TJ/hS?=
 =?us-ascii?Q?iLqEjDBEcqc4lvaHkoYmIqzAs6qOXB3uj7Wckqow39Aa4UNLB/fN6iVjNev0?=
 =?us-ascii?Q?qxyGanZqCngtUgQ4pZE6p2dKI5j324ckY5IWZDQg1elunvGqVvCKsBDqLnMF?=
 =?us-ascii?Q?uopkOMoPEIStPTI94i342heUdkVtogdPonnOHALlq8RymzWDT7qpoRQ+0Ox+?=
 =?us-ascii?Q?VCt5E7jIhteN6O3Zm2V0QMj1XmR6xc4/3/Rt8OKUx0pimyinrsvFtJ3qR5g8?=
 =?us-ascii?Q?lDBm5L6Kl8zgW5RFnPr3qxJAwIk6HBwml4ioRSAUry4JxnkMiAj+BEcqWjbx?=
 =?us-ascii?Q?71nSJ0t9oGa40qDzexqobmS859b611vbWduDCJbZJXdv6uoWsb5FHiqpylhN?=
 =?us-ascii?Q?nc6XsnsR2GOvriUOQ6HPw7XEOxP3tdX6AQs3iu8umrhSA3R1ZwBCVKxmy8+c?=
 =?us-ascii?Q?raYXNWBjHa7VIuE9gPgJV3VbOEGRlXxWklscYUgMf4mKaciG3RGE/xv08YNX?=
 =?us-ascii?Q?Dw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f255e4fa-2758-4e05-e867-08dcec84442b
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2024 19:13:20.5272
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: snTo2hSvIkehA2Tgzgs5qXBRwmJe+A08qU5Ad4nv1mwToPQQNg+peyCQMkwvfeumxmSgLdy3uElju4la9pbcvssEr6VO8XGBaumPlUZ4iAI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7398
X-OriginatorOrg: intel.com

Dave Hansen wrote:
> On 10/14/24 04:31, Kai Huang wrote:
> > +#define READ_SYS_INFO(_field_id, _member)				\
> > +	ret = ret ?: read_sys_metadata_field16(MD_FIELD_ID_##_field_id,	\
> > +					&sysinfo_tdmr->_member)
> >  
> > -	return 0;
> > +	READ_SYS_INFO(MAX_TDMRS,	     max_tdmrs);
> > +	READ_SYS_INFO(MAX_RESERVED_PER_TDMR, max_reserved_per_tdmr);
> > +	READ_SYS_INFO(PAMT_4K_ENTRY_SIZE,    pamt_entry_size[TDX_PS_4K]);
> > +	READ_SYS_INFO(PAMT_2M_ENTRY_SIZE,    pamt_entry_size[TDX_PS_2M]);
> > +	READ_SYS_INFO(PAMT_1G_ENTRY_SIZE,    pamt_entry_size[TDX_PS_1G]);
> 
> I know what Dan asked for here, but I dislike how this ended up.
> 
> The existing stuff *has* type safety, despite the void*.  It at least
> checks the size, which is the biggest problem.
> 
> Also, this isn't really an unrolled loop.  It still effectively has
> gotos, just like the for loop did.  It just buries the goto in the "ret
> = ret ?: " construct.  It hides the control flow logic.
> 
> Logically, this whole function is
> 
> 	ret = read_something1();
> 	if (ret)
> 		goto out;
> 
> 	ret = read_something2();
> 	if (ret)
> 		goto out;
> 
> 	...
> 
> I'd *much* rather have that goto be:
> 
> 	for () {
> 		ret = read_something();
> 		if (ret)
> 			break; // aka. goto out
> 	}
> 
> Than have something *look* like straight control flow when it isn't.

Yeah, the hiding of the control flow was the weakest part of the
suggestion. My main gripe was runtime validation of details that could
be validated at compile time.

There is no real need for control flow at all, i.e. early exit is not
needed as these are not resources that need to be unwound. It simply
needs to count whether all of the reads happened, so something like this
is sufficient:

    success += READ_SYS_INFO(MAX_TDMRS,             max_tdmrs);
    success += READ_SYS_INFO(MAX_RESERVED_PER_TDMR, max_reserved_per_tdmr);
    success += READ_SYS_INFO(PAMT_4K_ENTRY_SIZE,    pamt_entry_size[TDX_PS_4K]);
    success += READ_SYS_INFO(PAMT_2M_ENTRY_SIZE,    pamt_entry_size[TDX_PS_2M]);
    success += READ_SYS_INFO(PAMT_1G_ENTRY_SIZE,    pamt_entry_size[TDX_PS_1G]);
    
    if (success != 5)
    	return false;


