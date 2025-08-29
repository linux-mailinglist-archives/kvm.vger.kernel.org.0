Return-Path: <kvm+bounces-56230-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 19630B3AF83
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 02:33:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 301FA188C8EB
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 00:34:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 073701684AC;
	Fri, 29 Aug 2025 00:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b9/XHCNt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8141120B22;
	Fri, 29 Aug 2025 00:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756427623; cv=fail; b=ZZb/zgHVMc1ScLmRuDQvEt8B+4stw0zPK66cs+jn4HWw6sqsPstLhQyLfxJ8EEEcD5ufO42W4o2QfkO3xQDT7C97Zx/p1WWQGeVjKGAhlY6BsHuDjEbZ2OZsNoIJu2/6F+ruVMUZURAB1Y7V54MfJxJsZjNF+UTWcd80iZu2jp8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756427623; c=relaxed/simple;
	bh=//JCVxPXKkshtDDQxvZmCUzYZZKC0D91UN72aH2r6hw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=FOV284LbbZjvbOoSyQffPiYe3pudBljO4IsVq40DHusDAuv8jOsWaSl3q8aVFwRlNalrUwefMQGQTwgCfpnRCEAvgrzoHD0uzAGBAWTxmGVzJPCxLqKseA8pDz0+styk2FptKPUH0ZTBGy3YvPJpgczRrCDfR/PPZjvf1aRMHWY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b9/XHCNt; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756427621; x=1787963621;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=//JCVxPXKkshtDDQxvZmCUzYZZKC0D91UN72aH2r6hw=;
  b=b9/XHCNtbCvo5a/0932CbzgYBe18hfNVx2/+FCXq1xfyaMC9fRfYSeoN
   U7eR4Q/zb4MPEJhxM99K3Mwc3KDEcF5y8QIA5Aj7e58ApLf72Ynvyt+SQ
   3iJl3EDxdiXW70RzvSY5EYKnq3D7Y8FtmoCPG10tIZQUh1BgSlJxw3ApE
   WOxZ66To8xQq59S76mRWNCbCdi/2WUh647GFq/aB/KA0xYtX1HlrR7rAx
   KctRyVAIu55OZ0vBmFmIgNxkXPNTg3DFtu5uRIeqZaof4CeCKD+qZuSw+
   ypivKSHeQ2U9XP1rlJYEDSgCbqAmnVSK3hzohgCxF/s/sixosBGhgphdr
   g==;
X-CSE-ConnectionGUID: Sdj8rN5mRLu3pR0lChhGoA==
X-CSE-MsgGUID: zoumCJU3QAe79DWMIVUNQw==
X-IronPort-AV: E=McAfee;i="6800,10657,11536"; a="58813865"
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="58813865"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 17:33:41 -0700
X-CSE-ConnectionGUID: 25PdozfVSw2aM6IPD9ZRRw==
X-CSE-MsgGUID: SqTWGy40Rle0biGGy+MUkw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="174602266"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 17:33:40 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 17:33:40 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 28 Aug 2025 17:33:40 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.59)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 17:33:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BBr5OUwCKfFowtJTV9/smdVnf4TpuXFCfHFBK6ynBBPsI1TrvnjaO8u3Fc7aNem1cXu5SpjR0VvC2i8sMYf2Mfyo0NmCkPKC1eUJ2H4RgXYPWJxnl3KlQ6NS3cnOrrCbnmCumeO0vn2Ef/PurMCsuCNB9nUiy7RO3d9JmxL0mrDnAFI9HASrbG+nOPYit4tJf8R4P5nmdeKSTYDQvCimvFq7DMrIQ4PjkXHVeNuLBd3rLLzt4llFT9OR0NRIs3og/a7vUKh0wSgvlZNr+C7rNpNb4Cp4nqELIUZ4zfHOs3StmgCre5mfJQuf2kPehmpVr3nI0EMX/lFaSHGfbcJbmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jzuXYGIG2bnhDcMfuO9tSdUTcIPAlcWhTmQL6k9+mMY=;
 b=xY+/neTh1tTWtGHnEzw93J+NR+hNLC/7hq3lJgi8h02cDv+KLq3dBqtoWN7WOK/YdwgXGTZmY9/CJidaJ99KmtT1+8nWkBSbYrzCdT7Ltzci7JZCp0x6ojYex5jYHvRqq02bnQJe8X9BvDOLfgezFOXeKktQGuIehzlaxmmpEt1hGaDxUj3Ow2HUu5c2q6zt/C4DftHNyYgTdflTKgEHl+6XtAr6k8OEVv4Fq1KjJ2/osfQ14/uQ88fXhurISpdrVcb/d+MjENMo6T1WUpcSPSMBuClB+Xtqx3JWkKIInZQLIRldyAUz48PhfCRzBorpUi2+iAI4Q71lCe/OxorswQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by SJ5PPF50B3E12BC.namprd11.prod.outlook.com
 (2603:10b6:a0f:fc02::828) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.17; Fri, 29 Aug
 2025 00:33:29 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::bbd5:541c:86ba:3efa]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::bbd5:541c:86ba:3efa%7]) with mapi id 15.20.9052.019; Fri, 29 Aug 2025
 00:33:29 +0000
Date: Thu, 28 Aug 2025 19:35:16 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Sean Christopherson <seanjc@google.com>, Ira Weiny <ira.weiny@intel.com>
CC: Rick P Edgecombe <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "Vishal
 Annapurve" <vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Yan Y Zhao <yan.y.zhao@intel.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>
Subject: Re: [RFC PATCH 09/12] KVM: TDX: Fold
 tdx_mem_page_record_premap_cnt() into its sole caller
Message-ID: <68b0f5c4e6716_293b32946@iweiny-mobl.notmuch>
References: <20250827000522.4022426-10-seanjc@google.com>
 <aK7Ji3kAoDaEYn3h@yzhao56-desk.sh.intel.com>
 <aK9Xqy0W1ghonWUL@google.com>
 <aK/sdr2OQqYv9DBZ@yzhao56-desk.sh.intel.com>
 <aLCJ0UfuuvedxCcU@google.com>
 <fcfafa17b29cd24018c3f18f075a9f83b7f2f6e6.camel@intel.com>
 <aLC7k65GpIL-2Hk5@google.com>
 <8670cd6065b428c891a7d008500934a57f09b99f.camel@intel.com>
 <68b0d2fb207cc_27c6d294e1@iweiny-mobl.notmuch>
 <aLDjpe31-w6md-GV@google.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aLDjpe31-w6md-GV@google.com>
X-ClientProxiedBy: MW4PR04CA0309.namprd04.prod.outlook.com
 (2603:10b6:303:82::14) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|SJ5PPF50B3E12BC:EE_
X-MS-Office365-Filtering-Correlation-Id: 6cc273f1-1ab5-4391-e8d4-08dde693ace4
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?ftGw8rA5TRzgw1J+51RZRaCSPobHrpZMSHHis8x1zg0DRLzmVAds/wX3j6?=
 =?iso-8859-1?Q?Dx/0ZH5G5KFOdhYJVtp8pc92t79hbWVj8c1grvU6JlaQsVlvlL+WajhM0N?=
 =?iso-8859-1?Q?Pgjkj/FqDgo3tswG0kxQP3MAAlcUD7nyKPfzXrrV8rp7jpzQx5NRChFtQ4?=
 =?iso-8859-1?Q?3G3cQJ8cknkR6CWVMC8vBfDC6FsmlEQ5S2rUSsiOwGSq8lbkEH2j1FwXPw?=
 =?iso-8859-1?Q?B56u7fBgBpbmY3FjrkSzyRsa41Zb61F0yShrwhzVVLT8gnOMrwJwAYhkwe?=
 =?iso-8859-1?Q?IhitUIDqv8tITVfbDOATHPOXwTcS9ZaoUxGpj5y/1BPJ82snrHVe9wkveI?=
 =?iso-8859-1?Q?YiZ7usqkYr4sBP9U0iDpFsILPO9dQOWXzX4sVVAvxQC18yrgN6aDrqcMBI?=
 =?iso-8859-1?Q?+q0f2n78ZxkBHfNqZcicd3hwIDGgkyoLOxZ9Ua2PiKnyzaeV80FZu+V89s?=
 =?iso-8859-1?Q?62MCLI2gYXdJ6jjFmYiE3F6M1G1zTX7xK2Tdb4AdmYGJ0/AQUwMAfX9Xtz?=
 =?iso-8859-1?Q?y4USo3TDjq4eGwTlEfWNTgUlwS6BQmvmpySdPRhfhy90t6tfy184CkEcg1?=
 =?iso-8859-1?Q?4v6B5Ucp95e+9AfLz7z5A/IYzr7Sa8Fo99K54xYuXw9dZOTf+OG7AY7/zx?=
 =?iso-8859-1?Q?kSvAKndt5AEl+gzyke7xtGQAI3VnlwC9I5kgtNaQU9w+mCuzHphGI3kfGi?=
 =?iso-8859-1?Q?5en1JV/4AnHUVvUvayIUqC22dG1oK2TrIuAa1k3jXd/WWCrwh5G1gHMz5u?=
 =?iso-8859-1?Q?gp48YggHnIL6GWVhSymlDvinEpeshCaZ9MG43bI6iIwQDamtgMz6SGvaGX?=
 =?iso-8859-1?Q?U4k2zG5GMZr7beronOfHo1MTky4s75PlTqIyI6WduF1bFO/XLGaUiyRQoC?=
 =?iso-8859-1?Q?4c8p/Sbc7wCPLKPhx2+xZLXhgZS7xhY/R2y9CkNYjPwzzbCDcA8850Mb26?=
 =?iso-8859-1?Q?Ju8ZlwnKPXWsIAVYDA6aCz2LaM5XhXQ69WXl/bhSZqN2kxeu8wUEdgydhm?=
 =?iso-8859-1?Q?JSeWA/X1PUl+RmdXhE06V01Jh8b079tCnhp4WE9ReQyRpXJJ0oNcNntzHw?=
 =?iso-8859-1?Q?Sfv9hVIa4X/+Wq/2xV7un6mEtDbO5ampIn/M/fEQH3wPlrPM7Z7e/ew2VW?=
 =?iso-8859-1?Q?vxlMxCx0PI2KyDgfGXXlwrmHwr+5lKgKR7lyHcMJftLH6mcDPyfXBJTNXE?=
 =?iso-8859-1?Q?Wo4Cf3WLrgeoR0AmVmDIiTTVsutUa5Op0KpvGXDhMYfsPhswTcpVShhY/8?=
 =?iso-8859-1?Q?Phj0UU3Nb2n1tc944MLnlLQxW+Gut/faJVj0swTu0tOqF3qzZA7AfBkqEX?=
 =?iso-8859-1?Q?cTGHZ51LCHyysCL1WEKfSnn9X6qlRhFw9szkMfjbPPwAcq1DCVxih8q21B?=
 =?iso-8859-1?Q?jvmy8S5bEAfPFdpTt9Q2c/XJoS0frDBJN3sp8I8/PVlaUQqx93uo0nLSR0?=
 =?iso-8859-1?Q?T1GOLUUMl2IC/CG2ZogIygwNgu4+qRmJ0MpvrTwG4SuD0rlW0IFxMRdp2e?=
 =?iso-8859-1?Q?k=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?HutYnH0QgOKKvw4xKc+tZhpLEPVj3uMw4scurqJqmsKEnvgGaTmJtbJ5Ik?=
 =?iso-8859-1?Q?sZftL2XnD/RYJ4Vm+G5iBjKCRqnnseDAckeebIovS87Z3OLb+8LzhnMrI+?=
 =?iso-8859-1?Q?Rs1B6DCqYOTIH6Vdn/UswA/ATf051OuizThfQ3Uw4EVMv05bgnzYhBHltP?=
 =?iso-8859-1?Q?gvccec1zXmmDFPbIuEsB6D303vSEl4xji2kyQ+dYMGKqqZbOIErQOx7Jci?=
 =?iso-8859-1?Q?i1E6OZOOjErVIBFXat9rLyn+gDSRtCybja9z8Pa8PtlQXC7ix/sSTPp0sL?=
 =?iso-8859-1?Q?xlPnWKuNjcaAzxYTXy/OKW+5YEjUCKpblQFqslpx3kD/RZat3mkeU4c3Bc?=
 =?iso-8859-1?Q?rlcA+8lYEcDpJ8P5zW/n0XGiaYn8heeIQuZbGbTulj8MtaRt/GRNX4UWjy?=
 =?iso-8859-1?Q?3dqMu7MIbBWjSM+/1WVYtHhaDbArf8NwifMTdruVIa/x9D/F92W04tMYMG?=
 =?iso-8859-1?Q?LIdQT0CPrHmDQAh4irwYX4whsfKWZAQuqTvjzko3HqilYk91u9ta18UTxv?=
 =?iso-8859-1?Q?O7eP/mpwnxSCcoPeenmJcOouhgrUcecErGAm/Hl70SBEVVTjnnIhYSZ7I2?=
 =?iso-8859-1?Q?d9FeNxk36v98KU0kLxwiluN2T63pqQ10dirjpJ3tB+DaKZ4baZF0GLxoQe?=
 =?iso-8859-1?Q?gru/WlIOm78ooqyxDnt/Bt5TidbxmW65g5T9MJVba0BGg+X32jLLeu9aBw?=
 =?iso-8859-1?Q?gab+awVMAQZqca//vmCe+biK5O1cuz+xQO2aUj6P7+bZHqctxYi30CMtcB?=
 =?iso-8859-1?Q?m31WMyZJvS8hVrmD7YNI9BYnR4ul6KUP1MS4B+3eb7MtARZY8oZczHviMp?=
 =?iso-8859-1?Q?p6Qb1mKu3k6WSQR8TRX+7YAohi0t4wsUKQZ+oCqalIpEJ83wFWSez9vtZD?=
 =?iso-8859-1?Q?Z8384hpETQx6v2XXgJiAc1/Hp14yqfdT4O+tWXzZ29LWxIRkAJEFiQwOAc?=
 =?iso-8859-1?Q?n4GPVX2oBaV0hMcZQ1ZD/2M7mVmoqMowDkQoTSFWs0GIL/W2pBnDvUgRuF?=
 =?iso-8859-1?Q?PbwmlEj6jBGugF2iSx2+dW7AuybONKndJGhF0jvKefA79dhee3WPxz6gQf?=
 =?iso-8859-1?Q?VvKPqNBfyGrlG0SeWu6bj6TomnOab+C2KBJ9TdPTUCABl5KvS56ugO5QZD?=
 =?iso-8859-1?Q?4SjOZ2DxdJn8nLLXy/oiH5rST7jKUu7wl1/uyO98toOXmNsE0Qnt2ffqq6?=
 =?iso-8859-1?Q?QMGVy6nQAo2pKnaYGMQiOd+RTTWewVvL9hEAgNAdUUG/oPK3WMiA95mnOE?=
 =?iso-8859-1?Q?t33fSYjA5OX8U4pVzppes6XKUgNzSsYYGMHTwq50vIGKKH0Snqdq3uOD9g?=
 =?iso-8859-1?Q?mO7eaGqH2kfSMy580tKzy5EvzvhuwIZPA4mnrpSXTbtbfpbrZQFIbDN/57?=
 =?iso-8859-1?Q?n3bA7S4mRGl1D7InpqoKeySHkWu1/VyMEwWt0A1UloTviwi+48Uooy116h?=
 =?iso-8859-1?Q?w7GmLd7BKX3HMgFsweK2auDwVWP73EMmkj5raWbAYK35oHnn7/70+EdsKU?=
 =?iso-8859-1?Q?4m3rkwskvj5espKY6PyYrGRgMMosWMEPM6w1o7U+L1PwTk3/0jMkXmd53o?=
 =?iso-8859-1?Q?JP5CuVEQYgJXvNoeKg8QCURL03Phn37+TTSANJRInLSMKywf71dsQS6p8W?=
 =?iso-8859-1?Q?JkPix3hHEgBshS6ZPG1HhlfkdZiHN+FcS93demFCTl28Ws5AX5NkEa9A?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cc273f1-1ab5-4391-e8d4-08dde693ace4
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2025 00:33:29.4119
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j/lTXTX3ww1nMNLb/ci4+ea6DutQ935E92WgW4ZlTwI/xKWNioELXZgOVfHqDYyfhlz5D2TMLOmJhumRVM++ig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF50B3E12BC
X-OriginatorOrg: intel.com

Sean Christopherson wrote:
> On Thu, Aug 28, 2025, Ira Weiny wrote:
> > Edgecombe, Rick P wrote:
> > > On Thu, 2025-08-28 at 13:26 -0700, Sean Christopherson wrote:
> > > > Me confused.  This is pre-boot, not the normal fault path, i.e. blocking other
> > > > operations is not a concern.
> > > 
> > > Just was my recollection of the discussion. I found it:
> > > https://lore.kernel.org/lkml/Zbrj5WKVgMsUFDtb@google.com/
> > > 
> > > > 
> > > > If tdh_mr_extend() is too heavy for a non-preemptible section, then the current
> > > > code is also broken in the sense that there are no cond_resched() calls.  The
> > > > vast majority of TDX hosts will be using non-preemptible kernels, so without an
> > > > explicit cond_resched(), there's no practical difference between extending the
> > > > measurement under mmu_lock versus outside of mmu_lock.
> > > > 
> > > > _If_ we need/want to do tdh_mr_extend() outside of mmu_lock, we can and should
> > > > still do tdh_mem_page_add() under mmu_lock.
> > > 
> > > I just did a quick test and we should be on the order of <1 ms per page for the
> > > full loop. I can try to get some more formal test data if it matters. But that
> > > doesn't sound too horrible?
> > > 
> > > tdh_mr_extend() outside MMU lock is tempting because it doesn't *need* to be
> > > inside it.
> > 
> > I'm probably not following this conversation, so stupid question:  It
> > doesn't need to be in the lock because user space should not be setting up
> > memory and extending the measurement in an asynchronous way.  Is that
> > correct?
> 
> No, from userspace's perspective ADD+MEASURE is fully serialized.  ADD "needs"
> to be under mmu_lock to guarantee consistency between the mirror EPT and the
> "real" S-EPT entries.  E.g. if ADD is done after the fact, then KVM can end up
> with a PRESENT M-EPT entry but a corresponding S-EPT entry that is !PRESENT.
> That causes a pile of problems because it breaks KVM's fundamental assumption
> that M-EPT and S-EPT entries updated in lock-step.

Ok yes, I think I worded my query incorrectly but this makes things clear.

Thanks!

> 
> TDH_MR_EXTEND doesn't have the same same consistency issue.  If it fails, the
> only thing that's left in a bad state is the measurement.  That's obviously not
> ideal either, but we can handle that by forcefully terminating the VM, without
> opening up KVM to edge cases that would otherwise be impossible.
> 
> > > But maybe a better reason is that we could better handle errors
> > > outside the fault. (i.e. no 5 line comment about why not to return an error in
> > > tdx_mem_page_add() due to code in another file).
> > > 
> > > I wonder if Yan can give an analysis of any zapping races if we do that.
> > 
> > When you say analysis, you mean detecting user space did something wrong
> > and failing gracefully?  Is that correct?
> 
> More specifically, whether or not KVM can WARN without the WARN being user
> triggerable.  Kernel policy is that WARNs must not be triggerable absent kernel,
> hardware, or firmware bugs.  What we're trying to figure out is if there's a
> flow that can be triggered by userspace (misbehving or not) that would trip a
> WARN even if KVM is operating as expected.  I'm pretty sure the answer is "no".
> 
> Oh, and WARNing here is desirable, because it improves the chances of detecting
> a fatal-to-the-VM bug, e.g. in KVM and/or in the TDX-Module.

OK...  In other areas of the kernel if the user misbehaves it is
reasonable to fail an operation.  I would think that being fatal to the VM
would be fine if QEMU did not properly synchronize ADD, measurement, and
finalize, for example.  Am I wrong in that assumption?

Ira

