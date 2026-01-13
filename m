Return-Path: <kvm+bounces-67911-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 82A20D16C67
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 07:13:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F1BDD302BA9C
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 06:13:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16622368271;
	Tue, 13 Jan 2026 06:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VVAzyB4H"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38FCA41;
	Tue, 13 Jan 2026 06:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768284821; cv=fail; b=J0Dap0290+4vxO9v3hQQM1pBP/sUv+1SBaXwXjqvNJmCSqYNlpmwHn9xMli2LVwXoehaJAT5LJVF9CeayPebzLWRX2JDNwAjU4yKtxOh9wjRbeaLN3hooqAxZFV5BCmQ0HzSxfCpYBOx19YDZ7ag1jmbYS7Md/AB3vV5i5wt2QM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768284821; c=relaxed/simple;
	bh=2S5szE132RAzaPTejk9uPxSxOBcv6eEOd/+awarGehY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=JKOC7svN0UxIwTjsv7tHORZ6mHP0TPLb7bVbjG49pAWOUlm4mcSu9RBN6qh4PomeI1HwAfaZtYh8IJlwMgU0UoykJ1SQc2pxTv0DwpnCzcTTPEepl82Bqfe6R8CezVKPVEdQJvn+35MO7MsT/+fn2+dbNVox6q4iL3jcPS/H1g8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VVAzyB4H; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768284820; x=1799820820;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=2S5szE132RAzaPTejk9uPxSxOBcv6eEOd/+awarGehY=;
  b=VVAzyB4HY1ovAozP7/sxPdljWOxUZtkgwY0juSdrkqPuN/UJLtMXiH8N
   0bLhE5Pw0ZpXvY5xca+Ut2tXb+lRze4ozWuNwvgJSi4Pkmv+ENaD9PLKI
   6xfxwbNcjEiSzzwPPB2TtWJd1aKV6jYTxra5vvfTXO3SpJg4+WBjDJEwt
   +sTBUicFgnL/9y13Vh/0LmZ1GLDkXmx4ReV7LsP6SKHpCWaM8NpcfsVpQ
   8AtWZzISkHV6dzkIAwRJs3TA/970hCvUiSlyVzIoJKscXR/sk+5fKVYR+
   +H2AJFeN3S54NE3lJStIXjh+2EhUNftfYmA7G2/fXCaH1z0wlC5reNcTD
   A==;
X-CSE-ConnectionGUID: wzYrz0fZSQCQz9G/wkq6qg==
X-CSE-MsgGUID: NGQrrmrUQae6unzpNg9Msw==
X-IronPort-AV: E=McAfee;i="6800,10657,11669"; a="81017758"
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="81017758"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 22:13:40 -0800
X-CSE-ConnectionGUID: A5vR41oIRDqNU+3nn4HbKg==
X-CSE-MsgGUID: ywnNd3WDTv+04rh6cZR8Tg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="204382779"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 22:13:39 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 12 Jan 2026 22:13:38 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 12 Jan 2026 22:13:38 -0800
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.59) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 12 Jan 2026 22:13:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GsNh/krDCeh9p7igYRIW0BOP+n0pOOKeaY/ihdHOnnHSDJWKR3iLAqagh5oNyTlH3+skMWSWoIDrVEG6ksJhlrMw8ORfRjm+3wzw699NQAfspVV6o0Ojr3a0prxkAMtWvTlxqutn1psCDVPsWPY2U4bRTL7osjYVIDhZQmI7riBysSYYpVcvgfN776oy+b+fNWDid9EtathSNJSJ2OzevHcBd2bM+0yCIT18mo2JpChnWHbX7u1TCRhCngiD9VkivivFekCyinDa73NUQihoSJ2bGUh235j6DoLuIRpCdUkDAq8Lhyv3ZHybevmFy7RozuN8KiHk6PsPvlefs4j2Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/C32T0fEwVejKhZrejGJVCYyDqWwxEJu78e1qcKNuBw=;
 b=Q11ZMJbgfKzQVcQaDLBcJ3TWYuDFexUr1oEevCypLjC4FDcwaem00yw6gJhhRMi0YMIuxk16BZn+/PwfYkBWYATjFZ3nZY8L/IyuV7dSbQwvT3WzcVm4uF+jQI5ErJ1rtGPMFPEMMVkX09lf7iFJk3zWnP203MKVAqkn5JMAbyzJCERJciASkuwColINCmrHXrp43rvUC5c+Gp9HP2K4NJSPs/wTyfefxqOI+eQ4kVeNiXp16oggwFABhpckD4ymvyIVJG2QtbABCk0smHtc8yzkvOo9CieHOWLdqjqdJwAlAgzDJUHt7TpNQRr4nuur6AWnjlZZJVsbPohn2ciJrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MW3PR11MB4522.namprd11.prod.outlook.com (2603:10b6:303:2d::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.4; Tue, 13 Jan 2026 06:13:29 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9499.005; Tue, 13 Jan 2026
 06:13:29 +0000
Date: Tue, 13 Jan 2026 14:10:47 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Ackerley Tng <ackerleytng@google.com>
CC: Vishal Annapurve <vannapurve@google.com>, Sean Christopherson
	<seanjc@google.com>, <pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <x86@kernel.org>, <rick.p.edgecombe@intel.com>,
	<dave.hansen@intel.com>, <kas@kernel.org>, <tabba@google.com>,
	<michael.roth@amd.com>, <david@kernel.org>, <sagis@google.com>,
	<vbabka@suse.cz>, <thomas.lendacky@amd.com>, <nik.borisov@suse.com>,
	<pgonda@google.com>, <fan.du@intel.com>, <jun.miao@intel.com>,
	<francescolavra.fl@gmail.com>, <jgross@suse.com>, <ira.weiny@intel.com>,
	<isaku.yamahata@intel.com>, <xiaoyao.li@intel.com>, <kai.huang@intel.com>,
	<binbin.wu@linux.intel.com>, <chao.p.peng@intel.com>, <chao.gao@intel.com>
Subject: Re: [PATCH v3 00/24] KVM: TDX huge page support for private memory
Message-ID: <aWWQq6tHkK+97SOB@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <CAEvNRgFOER_j61-3u2dEoYdFMPNKaVGEL_=o2WVHfBi8nN+T0A@mail.gmail.com>
 <aV2eIalRLSEGozY0@google.com>
 <aV4hAfPZXfKKB+7i@yzhao56-desk.sh.intel.com>
 <diqzqzrzdfvh.fsf@google.com>
 <aWDH3Z/bjA9unACB@yzhao56-desk.sh.intel.com>
 <CAGtprH-E1iizdDE5PD9E3UHXJHNiiu2H4du9NkVt6vNAhV=O4g@mail.gmail.com>
 <CAEvNRgGk73cNFSTBB2p4Jbc-KS6YhU0WSd0pv9JVDArvRd=v4g@mail.gmail.com>
 <aWRQ2xyc9coA6aCg@yzhao56-desk.sh.intel.com>
 <aWRW51ckW2pxmAlK@yzhao56-desk.sh.intel.com>
 <CAEvNRgGCpDniO2TFqY9cpCJ1Sf84tM_Q4pQCg0mNq25mEftTKw@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAEvNRgGCpDniO2TFqY9cpCJ1Sf84tM_Q4pQCg0mNq25mEftTKw@mail.gmail.com>
X-ClientProxiedBy: TP0P295CA0020.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:5::10) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MW3PR11MB4522:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f3d420d-7e6d-4216-35a6-08de526adeaa
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?mz9KWHr2qlVy/F3vv3e4OAxYgzV8tQlion8kg4mHoLagIw8nlBC7JwE33MjC?=
 =?us-ascii?Q?pcnpGXmJW7Igr3RpmZhuFdxEjHqRLNG2z86KnrNdzZyFrSrBTpXExUP/6735?=
 =?us-ascii?Q?NbRigCgjGr8cmVADut2If598CVqtU05MtFAf56OFIqkBqPpU1MsAnfGOZEZa?=
 =?us-ascii?Q?Wg0ALwuSUyaE074ksElKRpcPXKO+H29mMp9SI7W1uzb/6y0ZanHaUSDJcn+R?=
 =?us-ascii?Q?gjhoU2kxvXIBlrNSegUm2SaIBnpLNZw/GwIxZbW0TiFrw0P9uUyeQsua1fy7?=
 =?us-ascii?Q?H8y0wmL7P+MHo5frfFCgE0xaWDCDioLa5amFIVaSJ2xQAxg3SIkcoj4O7OC6?=
 =?us-ascii?Q?X/4us/CCjhzrYnbmfip1Y/2tuc8Gs+7NQ1MNgV/cVHUZNRog0+lBY0jTbb4U?=
 =?us-ascii?Q?EP5TJL4Wu1V/q253J/802+LfrBJRN+6JM9aK42Q/75lRTrtPKyp6KRM81Wp5?=
 =?us-ascii?Q?l28iuUSd/gGCovwe7vbWaJMZKY2uEYgGAUPe9N2BxD0ZTNe8TqqUjQPu+kYz?=
 =?us-ascii?Q?d6gQtl+LKDOAJBiK3iVyuiuSaG6vy8cTla73krTPzeQN3xaISKYY2hNCZQdm?=
 =?us-ascii?Q?8fUbxQtUSZjwx3ckbzwyz842jVUHkhCS3wc5FccDZxH+u6mp2oFnXeg35DqB?=
 =?us-ascii?Q?qlDQO5lS2JjIkzCHHSRRAprGPd/Bn0nrwetiM8XeEigE9LY1TT6obuclVCxT?=
 =?us-ascii?Q?okHhdZHlRZANQdMvL8aXnN6RRjFE0g9CAbetfLJeRoe1LBTBKEftU/PVmwr6?=
 =?us-ascii?Q?3j8iRza4nRLr55VN40xhKXJFqbx8ISuEIILcDnEvUsXJ3zldv/q4ZTFU+9iy?=
 =?us-ascii?Q?DVTvlT8JFgVnnnhe5augIZnn2ncvdQsvJBZCRISEekLaWu/ZyfHGRM5U2Ey6?=
 =?us-ascii?Q?TR3ko0jE4ktZbLlRWKUNdQ7cES4xzNhKcMK2989hnJjxHXA+X8LMiS8rgtfN?=
 =?us-ascii?Q?TmVmVZDM7xWmsZlhv4iENfh5HS1SNcK01inM+TNGAf3ZiJYHquDSmHMGKeoa?=
 =?us-ascii?Q?BM+ZWToDSLjiruZdOhybLY9i2cz/ez6l5eibf5LulWA8myQWPtCkwDKWm6xT?=
 =?us-ascii?Q?6vZbPf6uaDAUUQjODvuDsctFoWxS7/5n5bAjpX5d/ezHEbqTFceCvXYFXuR1?=
 =?us-ascii?Q?azdyxdfrdAVCcT2QdjOILUvqibO9/+puXEAjQOkyueF7j5D9qEB9gebte2cU?=
 =?us-ascii?Q?4ZfUVHqqbBvCa6Z++5LDKGLW1zWu0evZouzv2o09zwdo5g3FkYnbABzy8xUf?=
 =?us-ascii?Q?7Nodvq0UHH2U0wghffMNjNTxR70jC3RHssikxBrmF1mMxYZOFVBeO/tzsAV0?=
 =?us-ascii?Q?HOo/flrtbLWlWdg9CV0QaOQxhzhfZyOtmWy+KZFjRlPdyad53MZnA/RBUC2a?=
 =?us-ascii?Q?Qit0dWDk9a5V7OP1a95RoMNrcZwcza2UN8XfNzzRnDEt+CRkSLWDe32iQaaV?=
 =?us-ascii?Q?c3EZnwPYaESAw6d57oghAb7IHwTeNTyVcDwOpYqD/Xlo5FqMclEFCg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+xh+pT4CdUAqRHaQ0VcoaLIwkXfDmGDcl2mWhi73CnMBqLZTKZiXUB6Wym2Z?=
 =?us-ascii?Q?drtVW6mvFeInGx2vbQJO78wLlEQo30ZPmVsPAZQMtUtYNKIr6EVmco2Ewgwa?=
 =?us-ascii?Q?uXuoZInm7JyGDrBhNFkeALr4jaaXFyYkhOFN7txMSFVsA7W7bOdWnxiKLCLd?=
 =?us-ascii?Q?koVvSNdzwqChi0jMivFweTGhohR75UYrKa0x/ypDY5puVk0edc0BLocSXfol?=
 =?us-ascii?Q?S6IECh7mzTHwDlVxpsntfyEnasX6T9i5hqMXSnx6sPp3CIyoV1TFSaqBJnAY?=
 =?us-ascii?Q?3isOUsp6mlFAIO4bEogDWYylLbYzy0jUsE5nNkTe2xIQloBE7P9Gzo2XbdB4?=
 =?us-ascii?Q?lAvMC7fXjDP/Qwg+Lh/DV09PUwUvnchTTupteyNgR22fgSeK76tKGFxotKZ6?=
 =?us-ascii?Q?bhf8HyRriA1MwormGjoElsV80Ibaqkxh38jwF6H7lNuye/5FurancaQRU7qg?=
 =?us-ascii?Q?nGrm8kPwXG+iN2qgLUZBVd79IQ38QnxDNAueCNAX+rXg3G95LLZgb+b87MCk?=
 =?us-ascii?Q?sE71w5IUbMSUilJhTHsx/+Ch9XABcIUh1LgRPBbl3nO2YW7X5I0QKr6wrnZ5?=
 =?us-ascii?Q?ZW3BtlyatgWfE9du/KyTkaeSaYavf1CHkXvu0uzf7P9mEq5JeZXfuXFuu139?=
 =?us-ascii?Q?4y3IH0kqpeQHpkXbr3ohpxfApA8/wK3Ozp1/Q7QuXG10vBnBWZhEbXM+iNnb?=
 =?us-ascii?Q?5zqf2ydhNiOiEim5ijnP/kq3VFvG9DdP7/ub5yW2BtrB1VlTORVOGDeMdC5r?=
 =?us-ascii?Q?ynsu2JMuP8TNZRoNZDy/HoMnbMIAr8RW8Pqm5p6CjywVwFc5TmJi4Wzp9r0H?=
 =?us-ascii?Q?faYFs8V8ktIKzRpM6U7sMye9jhr4zbWNpR+81orXfySnDxo5eke/RomLmA31?=
 =?us-ascii?Q?6h5QMzzmHfiAtcLlq2CavRH4qjeZoSkCtvgJ2LgNoa7ZbPgQIA3IulA4KraE?=
 =?us-ascii?Q?UhlVT294/RcAIFCpDYgEt3H4IUOdDf22vD7nCe+kY9Cu9GSi1KJixtIEbnWs?=
 =?us-ascii?Q?MoaTpz4zSDbF2fASKFBUb6C+16sSfR9k3HHwlNBFpOaRy1wOPSc+2wUCDUT7?=
 =?us-ascii?Q?ZB86IK+jWvpFNFskSbaPmuojIVVACbawDnRZuyQXDz00R0AgIemiCmmgsL6B?=
 =?us-ascii?Q?rpfuu3fd6DPmBvMNjj2ADIhG65yd8qW9hVvNLDTi2evmzgwuBqvY3fKky691?=
 =?us-ascii?Q?us0RiQdNvEd2hiDgksnVfOxtTz1WI3bffcwcxm9ScS3JrNi0Q4buQw2hifsg?=
 =?us-ascii?Q?ShKrzu+kn1KL85OowmXXcuANbzaVw3KIMiZknpNmqMEuOgkWBdGuYh2DIoVO?=
 =?us-ascii?Q?iLw9wkTXm9VGtXt9c5uxrWW83NRv0Qw+GMpWeS/56Ed6fAauKreo/LUp/p3W?=
 =?us-ascii?Q?tr0NT3IF4lhg5pVFysFrKZFyelyvu5eiCQHd6s47tfEvjQSG6cLwg276P0NR?=
 =?us-ascii?Q?bHGq3F32PdzPHg1BOj+h0EfMxsnvgyjJK9NKoxCbXBsktgTIuEyOw8GJr13N?=
 =?us-ascii?Q?FSkclH7cxDXdpqiNM53e4nnIqJdnVzAq85I4oRm0tE1+Sauq/l53QXO4xqhM?=
 =?us-ascii?Q?/MPQYdzZWe9ARn8RNHwDVhLkpx5twRaqDygqBrmafiUfCUzvQRyuyF8Gf8Dw?=
 =?us-ascii?Q?0WuCCRWlucj3cn7yR+W+75glPoZ03D9VHBtt4b5AI8S9+9TqzSCvHC6l1Gxx?=
 =?us-ascii?Q?a/heXOqUc63iE1Tk4gS7EyCX1fRo2Pq0VuUkk/3PZqCu1aApOsjdcIS3suqY?=
 =?us-ascii?Q?LP86jfo/mg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f3d420d-7e6d-4216-35a6-08de526adeaa
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2026 06:13:29.1465
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dkKBcpAzo0Yub24J63788iECddMYf6WRY2cnep8Tmf67P/RPugrMqYV6RflrVpaj2wwWKf9Nn8OE6f0CGLwkaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4522
X-OriginatorOrg: intel.com

On Mon, Jan 12, 2026 at 11:56:01AM -0800, Ackerley Tng wrote:
> Yan Zhao <yan.y.zhao@intel.com> writes:
> 
> >> > >> > I think the central question I have among all the above is what TDX
> >> > >> > needs to actually care about (putting aside what KVM's folio size/memory
> >> > >> > contiguity vs mapping level rule for a while).
> >> > >> >
> >> > >> > I think TDX code can check what it cares about (if required to aid
> >> > >> > debugging, as Dave suggested). Does TDX actually care about folio sizes,
> >> > >> > or does it actually care about memory contiguity and alignment?
> >> > >> TDX cares about memory contiguity. A single folio ensures memory contiguity.
> >> > >
> >> > > In this slightly unusual case, I think the guarantee needed here is
> >> > > that as long as a range is mapped into SEPT entries, guest_memfd
> >> > > ensures that the complete range stays private.
> >> > >
> >> > > i.e. I think it should be safe to rely on guest_memfd here,
> >> > > irrespective of the folio sizes:
> >> > > 1) KVM TDX stack should be able to reclaim the complete range when unmapping.
> >> > > 2) KVM TDX stack can assume that as long as memory is mapped in SEPT
> >> > > entries, guest_memfd will not let host userspace mappings to access
> >> > > guest private memory.
> >> > >
> >> > >>
> >> > >> Allowing one S-EPT mapping to cover multiple folios may also mean it's no longer
> >> > >> reasonable to pass "struct page" to tdh_phymem_page_wbinvd_hkid() for a
> >> > >> contiguous range larger than the page's folio range.
> >> > >
> >> > > What's the issue with passing the (struct page*, unsigned long nr_pages) pair?
> >> > >
> 
> Please let us know what you think of this too, why not parametrize using
> page and nr_pages?
With (struct page*, unsigned long nr_pages) pair, IMHO, a warning when the
entire range is not fully contained in a folio is still necessary. 

I expressed the concern here:
https://lore.kernel.org/kvm/aWRfVOZpTUdYJ+7C@yzhao56-desk.sh.intel.com/

> >> > >>
> >> > >> Additionally, we don't split private mappings in kvm_gmem_error_folio().
> >> > >> If smaller folios are allowed, splitting private mapping is required there.
> >> >
> >> > It was discussed before that for memory failure handling, we will want
> >> > to split huge pages, we will get to it! The trouble is that guest_memfd
> >> > took the page from HugeTLB (unlike buddy or HugeTLB which manages memory
> >> > from the ground up), so we'll still need to figure out it's okay to let
> >> > HugeTLB deal with it when freeing, and when I last looked, HugeTLB
> >> > doesn't actually deal with poisoned folios on freeing, so there's more
> >> > work to do on the HugeTLB side.
> >> >
> >> > This is a good point, although IIUC it is a separate issue. The need to
> >> > split private mappings on memory failure is not for confidentiality in
> >> > the TDX sense but to ensure that the guest doesn't use the failed
> >> > memory. In that case, contiguity is broken by the failed memory. The
> >> > folio is split, the private EPTs are split. The folio size should still
> >> > not be checked in TDX code. guest_memfd knows contiguity got broken, so
> >> > guest_memfd calls TDX code to split the EPTs.
> >>
> >> Hmm, maybe the key is that we need to split S-EPT first before allowing
> >> guest_memfd to split the backend folio. If splitting S-EPT fails, don't do the
> >> folio splitting.
> >>
> >> This is better than performing folio splitting while it's mapped as huge in
> >> S-EPT, since in the latter case, kvm_gmem_error_folio() needs to try to split
> >> S-EPT. If the S-EPT splitting fails, falling back to zapping the huge mapping in
> >> kvm_gmem_error_folio() would still trigger the over-zapping issue.
> >>
> 
> Let's put memory failure handling aside for now since for now it zaps
> the entire huge page, so there's no impact on ordering between S-EPT and
> folio split.
Relying on guest_memfd's specific implemenation is not a good thing. e.g.,

Given there's a version of guest_memfd allocating folios from buddy.
1. KVM maps a 2MB folio in a 2MB mappings.
2. guest_memfd splits the 2MB folio into 4KB folios, but fails and leaves the
   2MB folio partially split.
3. Memory failure occurs on one of the split folio.
4. When splitting S-EPT fails, the over-zapping issue is still there.

> >> In the primary MMU, it follows the rule of unmapping a folio before splitting,
> >> truncating, or migrating a folio. For S-EPT, considering the cost of zapping
> >> more ranges than necessary, maybe a trade-off is to always split S-EPT before
> >> allowing backend folio splitting.
> >>
> 
> The mapping size <= folio size rule (for KVM and the primary MMU) is
> there because it is the safe way to map memory into the guest because a
> folio implies contiguity. Folios are basically a core MM concept so it
> makes sense that the primary MMU relies on that.
So, why the primary MMU needs to unmap and check refcount before folio
splitting?

> IIUC the core of the rule isn't folio sizes, it's memory
> contiguity. guest_memfd guarantees memory contiguity, and KVM should be
> able to rely on guest_memfd's guarantee, especially since guest_memfd is
> virtualiation-first, and KVM first.
>
> I think rules from the primary MMU are a good reference, but we
> shouldn't copy rules from the primary MMU, and KVM can rely on
> guest_memfd's guarantee of memory contiguity.
>
> >> Does this look good to you?
> > So, the flow of converting 0-4KB from private to shared in a 1GB folio in
> > guest_memfd is:
> >
> > a. If guest_memfd splits 1GB to 2MB first:
> >    1. split S-EPT to 4KB for 0-2MB range, split S-EPT to 2MB for the rest range.
> >    2. split folio
> >    3. zap the 0-4KB mapping.
> >
> > b. If guest_memfd splits 1GB to 4KB directly:
> >    1. split S-EPT to 4KB for 0-2MB range, split S-EPT to 4KB for the rest range.
> >    2. split folio
> >    3. zap the 0-4KB mapping.
> >
> > The flow of converting 0-2MB from private to shared in a 1GB folio in
> > guest_memfd is:
> >
> > a. If guest_memfd splits 1GB to 2MB first:
> >    1. split S-EPT to 4KB for 0-2MB range, split S-EPT to 2MB for the rest range.
> >    2. split folio
> >    3. zap the 0-2MB mapping.
> >
> > b. If guest_memfd splits 1GB to 4KB directly:
> >    1. split S-EPT to 4KB for 0-2MB range, split S-EPT to 4KB for the rest range.
> >    2. split folio
> >    3. zap the 0-2MB mapping.
> >
> >> So, to convert a 2MB range from private to shared, even though guest_memfd will
> >> eventually zap the entire 2MB range, do the S-EPT splitting first! If it fails,
> >> don't split the backend folio.
> >>
> >> Even if folio splitting may fail later, it just leaves split S-EPT mappings,
> >> which matters little, especially after we support S-EPT promotion later.
> >>
> 
> I didn't consider leaving split S-EPT mappings since there is a
> performance impact. Let me think about this a little.
> 
> Meanwhile, if the folios are split before the S-EPTs are split, as long
> as huge folios worth of memory are guaranteed contiguous by guest_memfd
> for KVM, what are the problems you see?
Hmm. As the reply in
https://lore.kernel.org/kvm/aV4hAfPZXfKKB+7i@yzhao56-desk.sh.intel.com/,
there're pros and cons. I'll defer to maintainers' decision.

