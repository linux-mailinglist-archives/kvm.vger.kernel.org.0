Return-Path: <kvm+bounces-45179-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 50F67AA65AB
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 23:38:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 06D0B9A076B
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 21:37:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 772FC251790;
	Thu,  1 May 2025 21:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="edJUTHO5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD341DD0EF;
	Thu,  1 May 2025 21:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746135477; cv=fail; b=QU4XkV7FZF+aGQBy9JomZAOwkPmUycTmWqOB6G8r74yE0a0CmUlxvQs/O/AuTeino+Mmx9Q/gSip+8GsSBP2E1VOQuVpwCSeNh62NFUyvz1QDzOd1W1ResGjfxDJOAi6WOiyoBFOBAqauJEotiNMtjlFElBaA1fDmEgkVXHLsOQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746135477; c=relaxed/simple;
	bh=QzBScmVKdl/HkMU/MHQ1JrVuvybiFRWbAwYbU+7jjTs=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=oyNQxpL4SYHe68wqzDhfKq6m6214gghOfeuNXViX6So4WbqYBBKzgWUXlZTZVK81pvhmwP6f3RtDRYK4Ts0zKkRWOV9KpyEmaBzlMklR87k6rqDlL8daWJUOMgxYDdoWBR9c+qOvTzcGa0rPdcTLzbR2f/fWEdTFjA3+iYNd0mo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=edJUTHO5; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746135476; x=1777671476;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=QzBScmVKdl/HkMU/MHQ1JrVuvybiFRWbAwYbU+7jjTs=;
  b=edJUTHO5Lkfyxlk5YW+J35YOnpvZT78VdTCAGeftMnsE1ThY9+LrupdL
   m9JvV3zvyGSGT297NxuBCGK4O/nd2uREpPClLh38iFSnRA+nLuY0d4PxD
   s82I+3xp3aE8q5KUZ29VxKWG/Fwp+jxiEq5RQLRMoQ1IZ/MqYVNjCYxl0
   tTqLKg5oFqPx8PSc8OxB0xfQb2xTGOzElolKoogTE+0mbvpM35/inX3yc
   2E2FTHAVRRXpUaC56Idj3uq37Oiq/trK4r235Mah0nXdcGhVTxSDeQbcd
   jcYEaUBfOVLDuiSXJbewfpDsTkuiAzp9Z38u98Z7Br24cU3FoMF6GiAKq
   g==;
X-CSE-ConnectionGUID: 3JiAknoiRne3FvBAdF9z2w==
X-CSE-MsgGUID: QnisxDP9TdChGK4mbcNpZA==
X-IronPort-AV: E=McAfee;i="6700,10204,11420"; a="47958427"
X-IronPort-AV: E=Sophos;i="6.15,254,1739865600"; 
   d="scan'208";a="47958427"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2025 14:37:55 -0700
X-CSE-ConnectionGUID: Mt4dkSb+QPWgzXQuLzROig==
X-CSE-MsgGUID: +qw14h+aS7eSdHAN6xW8eg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,254,1739865600"; 
   d="scan'208";a="134794459"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2025 14:37:53 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 1 May 2025 14:37:52 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 1 May 2025 14:37:52 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.46) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 1 May 2025 14:37:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VfZek/js/bmo7QOlLXMCcWnD6DFmOKrguDGzLseWAJGZHTmyghBZ9uKJgBMxlxg6DbPnRm4ZKQOf8UOowG+xa0YtRZEsOqtU6O9ggEeefiu1iFFJiRaRlgtRdoICBzrkKNxAAyh6EmVMqhD2Wok457GmUV0NAL2I1lJ2E7pD28b2ww51SpYi3P/8l4cUOQUAxbt7VH7Xot5gXWIR7KTtffJVR7njmw3egEgsrbOtrluM02ISpvchD6DTPLaMx1uHxteoYvTZ8hAyQFS1j2v3L/Fe+ECWVI+xWQaQpUkydhppTZhAHt5bqiHSS72dE4tBDGv+A2tJPFXRRvZ18YFpzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WrO39Py723JOi1a3qdSp8n/gPWX7CgQiHHLmcLSSc4Q=;
 b=m1H2IciHp365HEaMBdQezSq71Lu8e1Ke+Xv5AEYZWoD9roQwurvoz1Wgn0YNwPsERwjiQz7PYfL3XjNKVqjox3AYstFugRSCGrW4W7ltJdZuAv2B3c8DTJ/g4LWWeW0unf2DPK0TtcLR/SOpQV2zM5UIRsTvHOR/TEym51Exi1ppfz0GTwo2b8S3qxo33ZU6j3MuXStRDfaz7rTOfLTX2frgEsmAjlGoQw2IXAKycI6he8WRaaj00pIMMb5EQBpx6GBLxvSftyuSzPYBTERYCABQTZUC6tixo2K4wwkWQUCsxfx0Eui7GPj0VeG3hLCxshKYo5UpsxK+kEZbvvP5yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by SJ2PR11MB8537.namprd11.prod.outlook.com (2603:10b6:a03:56f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.20; Thu, 1 May
 2025 21:37:49 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57%6]) with mapi id 15.20.8699.012; Thu, 1 May 2025
 21:37:49 +0000
Date: Thu, 1 May 2025 16:38:19 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Fuad Tabba <tabba@google.com>, <kvm@vger.kernel.org>,
	<linux-arm-msm@vger.kernel.org>, <linux-mm@kvack.org>
CC: <pbonzini@redhat.com>, <chenhuacai@kernel.org>, <mpe@ellerman.id.au>,
	<anup@brainfault.org>, <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
	<aou@eecs.berkeley.edu>, <seanjc@google.com>, <viro@zeniv.linux.org.uk>,
	<brauner@kernel.org>, <willy@infradead.org>, <akpm@linux-foundation.org>,
	<xiaoyao.li@intel.com>, <yilun.xu@intel.com>, <chao.p.peng@linux.intel.com>,
	<jarkko@kernel.org>, <amoorthy@google.com>, <dmatlack@google.com>,
	<isaku.yamahata@intel.com>, <mic@digikod.net>, <vbabka@suse.cz>,
	<vannapurve@google.com>, <ackerleytng@google.com>,
	<mail@maciej.szmigiero.name>, <david@redhat.com>, <michael.roth@amd.com>,
	<wei.w.wang@intel.com>, <liam.merwick@oracle.com>,
	<isaku.yamahata@gmail.com>, <kirill.shutemov@linux.intel.com>,
	<suzuki.poulose@arm.com>, <steven.price@arm.com>, <quic_eberman@quicinc.com>,
	<quic_mnalajal@quicinc.com>, <quic_tsoni@quicinc.com>,
	<quic_svaddagi@quicinc.com>, <quic_cvanscha@quicinc.com>,
	<quic_pderrin@quicinc.com>, <quic_pheragu@quicinc.com>,
	<catalin.marinas@arm.com>, <james.morse@arm.com>, <yuzenghui@huawei.com>,
	<oliver.upton@linux.dev>, <maz@kernel.org>, <will@kernel.org>,
	<qperret@google.com>, <keirf@google.com>, <roypat@amazon.co.uk>,
	<shuah@kernel.org>, <hch@infradead.org>, <jgg@nvidia.com>,
	<rientjes@google.com>, <jhubbard@nvidia.com>, <fvdl@google.com>,
	<hughd@google.com>, <jthoughton@google.com>, <peterx@redhat.com>,
	<pankaj.gupta@amd.com>, <tabba@google.com>
Subject: Re: [PATCH v8 06/13] KVM: x86: Generalize private fault lookups to
 guest_memfd fault lookups
Message-ID: <6813e9cba152f_2751462944a@iweiny-mobl.notmuch>
References: <20250430165655.605595-1-tabba@google.com>
 <20250430165655.605595-7-tabba@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250430165655.605595-7-tabba@google.com>
X-ClientProxiedBy: MW4PR03CA0345.namprd03.prod.outlook.com
 (2603:10b6:303:dc::20) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|SJ2PR11MB8537:EE_
X-MS-Office365-Filtering-Correlation-Id: eb4d0ed7-f83e-4fe6-515a-08dd88f86b55
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?8UKeV3Epy56CcVCSDQnwaxi1ZgQfmGx4D45w0CBN4C4owycGpwrwizzZcVAt?=
 =?us-ascii?Q?4BIrVPsEfYkMZ2Y4h8LFyUCVZTexTxcjMrmCJFPwWJcF93PhCywJgmzoK4JU?=
 =?us-ascii?Q?TXVLbfe/FgCljiuBHFzUEfQVV056ucPLgb424NDusTqgMKOLvcwcUHtU8fJd?=
 =?us-ascii?Q?/cFa+9xwUao0bH9Qajqaw4MPIwwTe8u3OIv7yNcq/kS/hfSkTQYyxcOy75Cx?=
 =?us-ascii?Q?XiNgFRjdEsVw1zrG3bl/LZc5ihjMylT8DVxFfCIEcwM8Pj+sGfwtzO8X3WPj?=
 =?us-ascii?Q?YV10YPWOzwRy7nmxzWPSsRSrOzHQ26y6ZPa95kPB8hazowCXYVNnuSoX6h9Y?=
 =?us-ascii?Q?6ciChGU+amZ5qnUVPvGD3yI1Njp0zmCp544OMBIbZ7PKxWB5zzuV3YJt8/qv?=
 =?us-ascii?Q?QnETpGfATsYvnJQjUC3Q1e+/s76DXkvfsAc6xyTGlETbunGVjsb0YCWATB7d?=
 =?us-ascii?Q?nGu8LbQmCdN62UkerZtkmWuhSepFdRSf2idM+z+m2j3skafrnAKyWepEe1/k?=
 =?us-ascii?Q?+5X2LVxHGsWsQBj0nxomZEwoBQUOCrz92QyiuKvCYUFvvOSRry2vBMqIecUD?=
 =?us-ascii?Q?1l0txeS+lCYSZOV9chbKb22uDSFOWw3gS98wxt2ZWKtLptdlJnpuj6uV/lmm?=
 =?us-ascii?Q?7bt3l6W53BBL/e06aCsoRj+HzNaLzzIIajhyRVZUTtAfp2ghsqLG+BK12/rz?=
 =?us-ascii?Q?cI8BQelOS6cN9J3IdvgOPbdRvpt1zt4eACyFzsB6jTNA8vhcbiJCZT2OtkmW?=
 =?us-ascii?Q?6hPF7RYBeYlBTnd7sFnRbtvsVvR/A/7cf633SoddUhMJV9E7Glo4CbIL0Kay?=
 =?us-ascii?Q?DTMMCZmQ6jlkBKV/cow7qpJh9S5Er5flXAWn5ceUd/dw30S9f/RUG1NuIsXX?=
 =?us-ascii?Q?eJixzyllKIC166z6g4YxcfcH8ZSrOfZCbgN39VSCBMEJ+uuS5DECYkxieihR?=
 =?us-ascii?Q?vE6X2uD3jURri9BS4bOdAL622ysampVVqOmKViPT7w/JBYAu3tUkMsvt3uT6?=
 =?us-ascii?Q?SMrP2zSO6O4BuhToxJMlC76F9g3+EIit+QqxxJ4whfdRgQRtmP11Bbb/usZM?=
 =?us-ascii?Q?cFfHeOpq7FBhrvTjb7H+v1bMh8Rgx/go+zjbxDKIYLtzas3Sg7kMVxCyEdxT?=
 =?us-ascii?Q?M6yDZY5aG7G1rM8RIQklZKzWZqxkk74pzGqEuBc7uwrc86U7nmh9YEHwDHSG?=
 =?us-ascii?Q?O00RQ1ojkxZo+Ha2sa61/LUlF86DoGyqLqyHvuMBpwQLpzdgUbjI3GQHER2q?=
 =?us-ascii?Q?E/kTG1rfOcSmCPh25aipFdLCyPwxg6l8i6ln+2Xu9d/xMhsWd7d9mB/JfG3Q?=
 =?us-ascii?Q?zER/YuCgC4K9TVVStS8cSHCxzhJ2oyPVWWBiB2oPwZDdw/Sjk5vftq9HwyHL?=
 =?us-ascii?Q?Kl8aVI9LKTEW7ToLBuySHerKfV8oRMrBtQpqkcwifTdK40+lcTwzhTmYiZBe?=
 =?us-ascii?Q?ZxLQw+0qQX8=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?io/RseZHpzIPHx5A+zhHWJn8NgaXjWnXmP1HYURjWLIg4mnRsi8AO0YDJDoN?=
 =?us-ascii?Q?nTDWQDv83SoLzel4YqQYW9SY0TWbP8GaVBquPgRl0R/72ycDJHbU4HAzXnnp?=
 =?us-ascii?Q?zDZeEbetxm9VE0EYrfWWY6lFM8ATtBHTwUdR0ZZboJad0MWo+NbToKtYRPig?=
 =?us-ascii?Q?+crrd0rAh8PO16Uz8dAHF6T7+D4e76Z82LfhOmCEY0DsM4mtw7GC7Dx5V7Q7?=
 =?us-ascii?Q?fXU0spXbD6y2iV6hdAs4JfpctttEYB4nyxMVGWLFJAMEuqg3Vo3dEfjP0agM?=
 =?us-ascii?Q?CnQkmN11ohaDToFLH5mm39oeo+u8qVRjpRlcY2tmvnIuKQqIAA3ND8WrBQ/x?=
 =?us-ascii?Q?imfY6g0vtMWDzmYMJTI4MRUZW6oYZhZe1OF9HqYeQJXFxG8VPIFK4MpIkH4p?=
 =?us-ascii?Q?DoSd9IJKOpiDtvQv1l/bF56h33ZPl45h2yZBdE/7W0OHLD7C8Z56aWUkyxw7?=
 =?us-ascii?Q?GqjPRE+JJBCccradfINzY9uQZX7jCtIQtCfAd/eW24IKdF466B3Akn+ltFG3?=
 =?us-ascii?Q?z5IqfY1TcCFwvWXyaIMOTLxkFPaM8KwdmrDLBIEZ9Xvlj4KLgmf+dHaDOaLe?=
 =?us-ascii?Q?guLW52dSLJCv8WtK2Q0EmqjkdWsksWT/UaqUUJmDKqb7xa5DDMqVr0kMJvXb?=
 =?us-ascii?Q?738d4F97HpW9/szOHAC9HAXaOtymjilQO58lCF9f0Pkbz4MEOoI5hiFI+lWG?=
 =?us-ascii?Q?KzFiC0MvnmEjO5DCHcDmxcELg/tgtUFjU44xcALVq66AM1HukQbsatVSMFfq?=
 =?us-ascii?Q?EmNJCaaBaIAymgztC5q7BzvbMhXa11D1JGtLZPben6g0JdabM1nYTKCDbAuq?=
 =?us-ascii?Q?Eblul5WW7tSxTHu1/4Boq2ojaVqfKhvEeXXsxJD5gAvtGtMZeb52nHf34Kq2?=
 =?us-ascii?Q?7arFbEdFVB/BknfIVIm5SYHVDccswyvwHTZppmzXMpdCz3xzZOFS8rocJw0E?=
 =?us-ascii?Q?L9PnEPCdfzx2R/8xMD2jwMjlJPI/mqU3b87bxoJuCiEbnltq95IFJFnclIlm?=
 =?us-ascii?Q?Cltd0jpjclywmT6krfhwTssXv6qoxmQ5Y8BQUZbpiV5mYgAHi70KFBS5HYvv?=
 =?us-ascii?Q?Mhn7KZEIkglge1JzR5z5OjjvttvumA5KI2+S7KPvsrUiqv8K0ThJHjGLuHxd?=
 =?us-ascii?Q?Li+IuecpdSOkwj1aJJfANAcNwOJDFcLfapcYZVXOTYTJQ2/pPvFHOeJs5eMb?=
 =?us-ascii?Q?ObiKW2aKFF0Tnonx3pusRT94HHEmjtngjos/zw/SnpiXQcC/4XosH4syEFPE?=
 =?us-ascii?Q?k8JJPTGPTLFDnqTw14BmAv/plULFoa6dRG1H2xVV2N0XCGSEIH6zCMjonU/4?=
 =?us-ascii?Q?1h10OVgaXhSoK+0R3FrzdYzh98JvJY1FG4bvTXoHWmEakT1XHwrgg3+1KT8+?=
 =?us-ascii?Q?0RlWKLJrojkifVC2D/izSurzCJVFGxbdpgPlWgqo688yXYylGRr95+yKVcQ8?=
 =?us-ascii?Q?vohL0B2ZVfy7Ci+TLngmrGv9EMBtaGMA7QsIKfQxC6r9NwWtmzm670vnG4Tk?=
 =?us-ascii?Q?UzmKZoDAe23GBNoQlchMCuQ3uahAFUvYVRwh1ZwxcAu8RH2yETxKPXDZlJJw?=
 =?us-ascii?Q?pUJpCzu28OcbQFXrQUCfBIyfUPfVuhb3NmNYh5lF?=
X-MS-Exchange-CrossTenant-Network-Message-Id: eb4d0ed7-f83e-4fe6-515a-08dd88f86b55
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2025 21:37:49.2210
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xcdBALIHOdFnvnhuD9Ea4Fuj5L7EEL0BVkLwyX3TjW34nmsa4Lxwp1OINS45cLtjeS0kToB0ZvEOT0GUDXzW2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8537
X-OriginatorOrg: intel.com

Fuad Tabba wrote:
> Until now, faults to private memory backed by guest_memfd are always
> consumed from guest_memfd whereas faults to shared memory are consumed
> from anonymous memory. Subsequent patches will allow sharing guest_memfd
> backed memory in-place, and mapping it by the host. Faults to in-place
> shared memory should be consumed from guest_memfd as well.
> 
> In order to facilitate that, generalize the fault lookups. Currently,
> only private memory is consumed from guest_memfd and therefore as it
> stands, this patch does not change the behavior.
> 
> Co-developed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

[snip]

