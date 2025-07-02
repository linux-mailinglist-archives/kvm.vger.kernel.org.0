Return-Path: <kvm+bounces-51233-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DB70EAF073A
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 02:20:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5ACE81C07A37
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 00:20:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C818639ACC;
	Wed,  2 Jul 2025 00:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AF3jobUC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8FEEED7;
	Wed,  2 Jul 2025 00:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751415586; cv=fail; b=K7U0NNRi/9U7U2nwpoA88txJSn9OwY7nwII5PlW+J3XuI6NTUR6GV/hmvJPpDR+kJ4nNhQssGy9x5j05bU+S4Y8LAmH5snwmpjjfzqhhyz6jOCi2Ue38QCt45uO1USl5/zrlGVjd42R7LL3PA0zPF9TG+Ky6++nqLmLRtD2P0b0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751415586; c=relaxed/simple;
	bh=jJ3vo4IM/4UGBZncaWRivICqNoV+TNXVEZOVZBMud74=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XTcfo505EYNA7c5l71kvNNAbPZHhROgiO3hCZwl81FAE+h2DwawtOLofC2lUzQk0kVPtsvcTZ6y7aSFeXKYQYhCSeUisPqla4EMsLOtBdYELziJ87gCnwzpZcUKD1jQaxPN2uTgxlF9s53aymMwMe4ylN4IOsHc6BtEGuy+3Quw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AF3jobUC; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751415584; x=1782951584;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=jJ3vo4IM/4UGBZncaWRivICqNoV+TNXVEZOVZBMud74=;
  b=AF3jobUCW4MPdT/HFJYGwkRqVuWJy5ueQzcB+GjC6ao9difh7vy7LdaJ
   oDVXviGsjc6wFglo37vYDsxkXJaw7Lx5TRUziX1hv9lBN5yA9FCA1JlLM
   qtx4aIOOV6Qfcfb2vrC279bhT9XjmR+kCjoN/hufvE7Q4KcGQUiM4+a71
   yQNRrEgPEinVKTWT1hxdksYiY6hvlwtD6rgM9n0szLcIAGPiXdORTEitp
   BySGNsNBNsjQergJV+xzLO7wvSfCt9jOgsK1CUrlc+qtqx6GbTVw5bePT
   LQa9Y81QMa5qTIh5pdsw7Ooax0rxhqVQybF4CqnJVoTCgEqw0asnA6CXz
   w==;
X-CSE-ConnectionGUID: IelNHGc9TuOdOBFt7D0Pnw==
X-CSE-MsgGUID: nEplONFCSu+k03yeYY6RDg==
X-IronPort-AV: E=McAfee;i="6800,10657,11481"; a="64393323"
X-IronPort-AV: E=Sophos;i="6.16,280,1744095600"; 
   d="scan'208";a="64393323"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 17:18:52 -0700
X-CSE-ConnectionGUID: lLfbhUa7RN+FVr+oKKDCuQ==
X-CSE-MsgGUID: S0e4BWFmRjCaREhEjriwBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,280,1744095600"; 
   d="scan'208";a="159432383"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 17:18:51 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 1 Jul 2025 17:18:50 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 1 Jul 2025 17:18:50 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.68)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 1 Jul 2025 17:18:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C2JDtDuu/aGhmbtCh2j6EH9FbYc0HtgpBwFaMJDuyjH1Cwaf4KG619cZb9j/K3x24lXkTsM6e90W+6earMPA8ejTiePV7n+u3792BejiQRFCHsn/QpojxF9LsI/CRwPhO2EelFgpvXaFplqGnRys8geApEVcB2RMQSWb4hTC/2bzncrylntRHssvSVRL8jrQNcmYz3kGEcDhIx0qElFY30qwGW8KRSEF4MTZWLFwBE2ZxNK1EgV3Xe/1DDkxaq/ynlPe6PAjgr4wzLzr0Ac6dT0SqNlP9yqyBOFVWilizILOzcCTHibSnu8vS1aIuo+6DrXA1VdAlWutCYO5L46sGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jJ3vo4IM/4UGBZncaWRivICqNoV+TNXVEZOVZBMud74=;
 b=H/pv6RemCGv5F5Rb2/TFn7TVcMK8EqtHhSTOp8bR/6iGYM6EuknSlsVwWWrBYl5W/QWLgMRgQte3okeDw4Sj/72HEr9XXb7jVZKRzZ6DPwPOuzHQxaT01p/yL+xn9Fjk3p05QiXKUi9hCciz6Dz53OkHMNARHAbPl/S7B0XTdaSLo9OMDqmlbxrl6Q96NgHDlKnMsIxBfKTuxtM47QcpOrdgga5kcceGKa7M5IUuP/1fPTmz9gvvF0TxSRiPt2TwoDRQHM+XqSgZvm8qQTXHg9tQMbe/2WxlMu/o2O62NTSq2pPrTSQZ4qwBNXj5ESuut7hNa1JqGplgsbEvUKi/ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA2PR11MB4796.namprd11.prod.outlook.com (2603:10b6:806:117::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.28; Wed, 2 Jul
 2025 00:18:48 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8901.018; Wed, 2 Jul 2025
 00:18:48 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Huang, Kai" <kai.huang@intel.com>, "Du, Fan"
	<fan.du@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "Li, Zhiquan1"
	<zhiquan1.li@intel.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "seanjc@google.com"
	<seanjc@google.com>, "Weiny, Ira" <ira.weiny@intel.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Annapurve, Vishal" <vannapurve@google.com>, "tabba@google.com"
	<tabba@google.com>, "jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun"
	<jun.miao@intel.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Thread-Topic: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Thread-Index: AQHbtMYisXlDVaH8LEKqVl1+c9iQ77PRHICAgAN/mYCAAIg5AIAA1+mAgAPLQICAAIwTAIABF74AgADuIICAIfsagIACKESAgAALWQCAAAHGgIAABSeAgAAA3ACAAAyHAIABVQyAgAAHeoCAABSygIADYjmAgAFIQYCAACKZgIABjCaAgAQxHwCABQ5egIAAzNwAgACQ3gCAAPlVAIAAWTqAgAEvVYCAB1KDAIAAIT4AgADYfACAAJAsgIAAAc2A
Date: Wed, 2 Jul 2025 00:18:48 +0000
Message-ID: <f13239faa54062feb9937fe9fc6d087ffcca7ac6.camel@intel.com>
References: <aFWM5P03NtP1FWsD@google.com>
	 <7312b64e94134117f7f1ef95d4ccea7a56ef0402.camel@intel.com>
	 <aFp2iPsShmw3rYYs@yzhao56-desk.sh.intel.com>
	 <a6ffe23fb97e64109f512fa43e9f6405236ed40a.camel@intel.com>
	 <aFvBNromdrkEtPp6@yzhao56-desk.sh.intel.com>
	 <0930ae315759558c52fd6afb837e6a8b9acc1cc3.camel@intel.com>
	 <aF0Kg8FcHVMvsqSo@yzhao56-desk.sh.intel.com>
	 <dab82e2c91c8ad019cda835ef8d528a7101509fa.camel@intel.com>
	 <aGNK2tO2W6+GWtt3@yzhao56-desk.sh.intel.com>
	 <908a8abdf0544d4fba23d3667651c4cfcafa9c4f.camel@intel.com>
	 <aGR5ZYpn3xyfOZhS@yzhao56-desk.sh.intel.com>
In-Reply-To: <aGR5ZYpn3xyfOZhS@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA2PR11MB4796:EE_
x-ms-office365-filtering-correlation-id: 351f4468-26be-475d-2037-08ddb8fe03d4
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?cWNvMWlZc2x4WDhjMFNTa0dBOG5tUk9scnI0REhhb2U2UGthaElmNE9tbHdJ?=
 =?utf-8?B?MDQ3VmpBZStXZUQwRFZxZmJPcGwyYnRzTWlyaHFNY0JWVVhwUlUvQldmOWNI?=
 =?utf-8?B?aHFheUpnekZ5cFFZT0gvbmJBOVJPWFJGY2JwN1N6aWNEbDRHTnNpWjhkTXk5?=
 =?utf-8?B?M1NUc1ArTEc4aGI4N1lPa25PQnZrd0VObmNsNldNUHJLcWI4T0tWRTc3bFV4?=
 =?utf-8?B?blppM0kxTGhpckZKMzNBdXNhQUQ3cmpZWm42MmJGV1lueXFoUCtPcDQ1bS9H?=
 =?utf-8?B?WnhXd1dFODN1Kyt6ZEoyalJNVmZPOFljeDcreks3Rjg0cWd2dzE5Q3c2a1Q3?=
 =?utf-8?B?OE13L0ZNdnZCSTFLRHUyVVFtaTA3ZVBSZm1kTmcyVUpUUmhEeUtPMWhqT2Fx?=
 =?utf-8?B?N1lqeWhoWEowRFFEeVFwazFnYXZ2dkxPMEZBdlRYNXRMczNidFYxY0o2UTlm?=
 =?utf-8?B?eTY2eExRNlZiMkI0OGpoUXJINzNhc2V5TkNueU42b2RudDFFc3JwMWpROGg1?=
 =?utf-8?B?R1M3V0dxSTR3Vm5XOE05NVBlR0JxREpncEUrQzdVZlp1RFhJeEdKRmZaKzl2?=
 =?utf-8?B?NDA4SzRoYkFGTGIrN3o2RUdFSWlZV2pXSEFvZFJuUkJvNFN1ekZCa09ibEs1?=
 =?utf-8?B?aG1KN3JwUHhIN0lSMUZpNXNjODl4MlhEZ21keHdBNjhLT3hMeVJoUjhmN3Ny?=
 =?utf-8?B?dTRaOTkwUk05RC81ck5ocS9WcWJPcmU0a3hUTUFVeHRqQlBiaFJsV2ZhSnRv?=
 =?utf-8?B?WjdSU2dxMCtNNkRCb1oyUFhVdjJjKy9hT1ZoeE94QTcyRUFQWDB3UnpON1Jl?=
 =?utf-8?B?OU5BS3NzWkkyMjZod3lmZ3Z2c28xTjZzLzlRVEt2aUZXZjYzcGNnaTYxenRR?=
 =?utf-8?B?Y2Z3RUJlK1V3amhzbHpHNjFicWRYcWZLdTVnUWc1Q2sxNytoN3hZZDRTVkZQ?=
 =?utf-8?B?WjIyR1B4QVVCd0lSb0tKeElNTDVBN3ZvZEhzMXJWWFoyL1MvNmlRWVVpT3Ni?=
 =?utf-8?B?MWRJN1poWE1DNFZMYloyYzFUalNoYjU3YlBqN1ZXaElwOXk1WGYyaTdOWW9Q?=
 =?utf-8?B?TzNnbFhnbFFSQkJ0SVFCMkEwcTRTMk5jMzRFYnE3WlBNY3Vuc1YrM0krSWhV?=
 =?utf-8?B?ck9jbE1vRzNTUGM5aUpCeUtLQS9EM3BzQTJmM3JMNVFtMUxrQ1JoMnUxbExG?=
 =?utf-8?B?c0dTUkJuN0ppaXk5QjBlVFFzazUvM0UxRzVXZmxRVDdaZnB3L0lsR21TcDlG?=
 =?utf-8?B?bzNTUFNvYmF2Q21yTDRRNUltdkQxTWxwMFZxbklKNndBL3pvOTVQWDA0a29C?=
 =?utf-8?B?UytVQUVwNUpDaTVXWS8rNnEvY1FLOXVtb0piWFFlWFV6WGl6bGZlSnNheG5R?=
 =?utf-8?B?aTR4azhEV2hHbHJSbHkraWdxK0p1U09waFR0TDAzeGlLdEJpcklRL2tmZzZB?=
 =?utf-8?B?ZzZaRHlkQVNyQVk2RHprWGo2Q2M1SUo1OWUrRnNNTndwSUIreExWTnVwUmU2?=
 =?utf-8?B?SkFXY2F3d3RQWjZyWUlMajM5ZVBnYzdLelIrMldqU01tNGJtMVYreVcyOGdj?=
 =?utf-8?B?OFE2RmJwOVlQRVFaZDEvNEhLNHFqbmV4Z1J0SGVMalE5dW1KZUVHM0Fxc3I0?=
 =?utf-8?B?N2s1cUwrS1NkQy9BWFRjbEZLdFUrNkw1dXRiZlNkRlhKM1dVUXZhUjEvUTNX?=
 =?utf-8?B?cFZFNUJ3aVhCcGJyZUNCUG42M2g0OFM4ZU1VYklCNVRkeEttOHlPYlJjdUpl?=
 =?utf-8?B?dUV3aTJQbS9RdlpZVHU3RTloRHlrKzdyZ3cwL3FpSlVGU2prdDBLaGpqdEtO?=
 =?utf-8?B?aTVhc0VOQ1N6UnBBUHFBc21rV1dJVTJzVVRZbHhnR1NhbVlaQXlKdThWcTlU?=
 =?utf-8?B?Y0hXbjBMZnlTODhReU10eWs1cWQ4c0FQZk1tYnFuRGZnVmYxMGgyRDhDbEd2?=
 =?utf-8?B?eDBzeUJnRG1SM1A3eWlhTGVFc0NDaDN3YzhUMTlvUEhMYUFpdWtFZlE3MlJi?=
 =?utf-8?B?VjdUWm5xTk5nPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YTVzRHNLU3IrbUwrVERySHIzM29sOXBkUk94QlUyVGtGbCtmUjk3U3cyVDVO?=
 =?utf-8?B?RUZENEdzYXQrY3ppTm9pd2U4VUM3MnBoMkhvb0tuVkJUMjJ5L0JBNjFSSUNq?=
 =?utf-8?B?SUg3RStIUGlCU3RMQUdEa291ZFFQVCtPS2JrVVU2UVhFTnh0UG9tdTUzb2Yy?=
 =?utf-8?B?RFRYWDEvQ0c3cHVPVld4czdjNi9xQzV2QzhETUJaNjd6dnZjNENjcnE4T25u?=
 =?utf-8?B?bTUwTm1UQmgwb253NzVKanFFa2pIaGQ3SGV4eHdFT3o3SWNOdVZCNVBJcTlT?=
 =?utf-8?B?NGhyQjdtbjBNZVhLZ3J3b05DeWMyeEsrUVMxR0R3RzlKT1YwdUVyM3lFSm1C?=
 =?utf-8?B?SW52cmZOOGJXM09RU21ObUNKNHpvWCtOcUhJamlNTkt3UjJmWDJJR0VJc0dW?=
 =?utf-8?B?SEpQaFRCUkhDOGw0d0FGUkZFVnQrTGFPTHUvdk5uZklFaVR4YWlVQmI4U3U3?=
 =?utf-8?B?TTlIbjUrTlhPUlRyOFU0ZE9TM0tqQit1REtCVHpiVFhiL2xxbGU0R0c0U2gv?=
 =?utf-8?B?TGgrL3dQSFk2RHZkdmxmb1l3TVdzaDYraS9XUUI3NWpMTXA1dnZrWnQyeWRY?=
 =?utf-8?B?WkZHdDgyczhMY0k4Q3duUStieFRpR09RaWNWT0Vrc0NGUnFXWUpnVlFjMmM1?=
 =?utf-8?B?aDhaRlhORjJ1ampYTTlnMDI5NjZUbFZXVmtDUXdkVXh5WFNXbGwwUGVyeURB?=
 =?utf-8?B?STM1cmxjejAzTGc4R0E1aFpsdHJjTWVpZVk1M1oreXFzbm11RnQxemRpTEpD?=
 =?utf-8?B?c3lTb2ZwZjkydGczamluMi9WL25RdStYUG5nQTRGYXl6Y3NsSXJlSUJNODAx?=
 =?utf-8?B?UVV3ZUdhU3RXcUhyRW15dEVFN052elR2SDFYRHNIaTNvOUVXTFBTb0M1VzN1?=
 =?utf-8?B?dmtlVUp5L2ZLTmdsWnd4SmJXYnpoK2RoUm0zcXFpMkpFUTduKzhQUi9mRm96?=
 =?utf-8?B?L1VTZXVjaGp4OGJKRXorNlV6cnJtbDZ3VTJQb2hNclRGUHJkOUdNcTEveVRz?=
 =?utf-8?B?a2ZoZEk0MHBlZlBRanAxNlhmOVVVTEFkdzFFNUhCcGw2YXBQdytmN1dOSmcw?=
 =?utf-8?B?Ujg2ZDZmNnZkSTdtNm1uUXZhOGQyTjZuRm1RR2JxL3NYMytRaGVBL1FxTGRa?=
 =?utf-8?B?aEhkMTQ0RlZXMm56a1FJYW5yK0NYdHhxUkdMUkZIeGdEbjhKNmduSzRncWl5?=
 =?utf-8?B?SCtsNkNuT0xvYzNpOFlSWkJ1bS9rRXJzYzR5M3gvVFNxcEZCQk9UdkgwMHAv?=
 =?utf-8?B?VGhQN1lpeUdISm1QV3EyRlQ0M21zWTVtQVNqZWpTcm5weGxYcWNaODlwYU00?=
 =?utf-8?B?b21kaWRWMXJHMU15VW9iQXZWcFp2S2cvNTZ0a0J5R3QrOHpLM0NHUjV0Tmd1?=
 =?utf-8?B?T0U0VFhpMm1TRGZKNFFpYTYyYVJpM0o2di85NG5Ybi8vcFRsSW9vMW9LK1Bk?=
 =?utf-8?B?Tkt4emEwMVU1dnlCTUlxcjhnejNsck14TWtBNGpOTUVDSzVId1hmZDIreU9R?=
 =?utf-8?B?dU5yRUJmMXlncjdHUHBYMzFkeHNWK1RHK2NkUkVDREgzcFlkZ1U0YmgwV1Fx?=
 =?utf-8?B?SmxsM1dFdE9IMlNxTmdKdXNScVdJWDdDSHV0UFZid2VNRWQ0NDIvNkpwVlR2?=
 =?utf-8?B?ZjFZTStpczN1MkpDWENhQ2l4YndGM3dqS0FUdFFmTVQ1aVFOUFNpbkJtQWR3?=
 =?utf-8?B?ZlRlc24zNXdiODJyL3N1TVNyNVVyWXRXNUFHWFpiR09HNWp5UmlRblZsZFlX?=
 =?utf-8?B?TDV2T3VhTXptLzBJT2FvVFZnS1N2VGVMcEE4aTQwaE00a0Uzb1RsR2MrTjMw?=
 =?utf-8?B?OVR4NVJ1NFNHTmh4UFNzMnY1ekd5OFp2NUlDck9HaVNzczFVNHcxQzJOZEpk?=
 =?utf-8?B?bTdYL1FMamxVbkhRTkxEMEhGNThEZlZaeGVmSVE0QXQybXNiMnUwSUJVMXhP?=
 =?utf-8?B?Z0FENmIxcFgwZDlZY3FCUFZkNm1mRXo3eDRNcEIyWGY0SXQvRFdnYTA3Q0Ja?=
 =?utf-8?B?aU1PTFp1UHF1Rml5RlpMQTZjK1BNeitlbktPalZRNUI3a1ZSZTQ5L2RZdHVo?=
 =?utf-8?B?YVZRaTAvL3VaTXl0SGFFdnppbDhVTDdLQ1o4cDN3RVZadmF4Tm5vaEJ6YTdT?=
 =?utf-8?B?NDJVQXZQeXBwSnBvV2VZSGdxNThmUk1saGZoakxpMzlNVW5Jby9KZ2hKM2o2?=
 =?utf-8?B?dkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <58C452C749FF3A4A98D611551729A45B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 351f4468-26be-475d-2037-08ddb8fe03d4
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2025 00:18:48.1727
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: beGr6fJ8eOiV3DGDEWGsQpeOUNHdjrEI7vdNcSD43tSoSRsx7Lg12Hh7Njx7a7ZXexplfenh9o+ZN6z9t9GjAKTxf6Vz/I+HObzU+7vy3O4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4796
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA3LTAyIGF0IDA4OjEyICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gPiBU
aGVuICgzKSBjb3VsZCBiZSBza2lwcGVkIGluIHRoZSBjYXNlIG9mIGFiaWxpdHkgdG8gZGVtb3Rl
IHVuZGVyIHJlYWQgbG9jaz8NCj4gPiANCj4gPiBJIG5vdGljZWQgdGhhdCB0aGUgb3RoZXIgbHBh
Z2VfaW5mbyB1cGRhdGVycyB0b29rIG1tdSB3cml0ZSBsb2NrLCBhbmQgSQ0KPiA+IHdhc24ndA0K
PiA+IHN1cmUgd2h5LiBXZSBzaG91bGRuJ3QgdGFrZSBhIGxvY2sgdGhhdCB3ZSBkb24ndCBhY3R1
YWxseSBuZWVkIGp1c3QgZm9yDQo+ID4gc2FmZXR5DQo+ID4gbWFyZ2luIG9yIHRvIGNvcHkgb3Ro
ZXIgY29kZS4NCj4gVXNlIHdyaXRlIG1tdV9sb2NrIGlzIG9mIHJlYXNvbi4NCj4gDQo+IEluIHRo
ZSAzIHN0ZXBzLCANCj4gMS4gc2V0IGxwYWdlX2luZm8NCj4gMi4gZGVtb3RlIGlmIG5lZWRlZA0K
PiAzLiBnbyB0byBmYXVsdCBoYW5kbGVyDQo+IA0KPiBTdGVwIDIgcmVxdWlyZXMgaG9sZGluZyB3
cml0ZSBtbXVfbG9jayBiZWZvcmUgaW52b2tpbmcNCj4ga3ZtX3NwbGl0X2JvdW5kYXJ5X2xlYWZz
KCkuDQo+IFRoZSB3cml0ZSBtbXVfbG9jayBpcyBhbHNvIHBvc3NpYmxlIHRvIGdldCBkcm9wcGVk
IGFuZCByZS1hY3F1aXJlZCBpbg0KPiBrdm1fc3BsaXRfYm91bmRhcnlfbGVhZnMoKSBmb3IgcHVy
cG9zZSBsaWtlIG1lbW9yeSBhbGxvY2F0aW9uLg0KPiANCj4gSWYgMSBpcyB3aXRoIHJlYWQgbW11
X2xvY2ssIHRoZSBvdGhlciB2Q1BVcyBpcyBzdGlsbCBwb3NzaWJsZSB0byBmYXVsdCBpbiBhdA0K
PiAyTUINCj4gbGV2ZWwgYWZ0ZXIgdGhlIGRlbW90ZSBpbiBzdGVwIDIuDQo+IEx1Y2tpbHksIGN1
cnJlbnQgVERYIGRvZXNuJ3Qgc3VwcG9ydCBwcm9tb3Rpb24gbm93Lg0KPiBCdXQgd2UgY2FuIGF2
b2lkIHdhZGluZyBpbnRvIHRoaXMgY29tcGxleCBzaXR1YXRpb24gYnkgaG9sZGluZyB3cml0ZSBt
bXVfbG9jaw0KPiBpbiAxLg0KDQpJIGRvbid0IHRoaW5rIGJlY2F1c2Ugc29tZSBjb2RlIG1pZ2h0
IHJhY2UgaW4gdGhlIGZ1dHVyZSBpcyBhIGdvb2QgcmVhc29uIHRvDQp0YWtlIHRoZSB3cml0ZSBs
b2NrLg0KDQo+IA0KPiA+ID4gPiBGb3IgbW9zdCBhY2NlcHQNCj4gPiA+ID4gY2FzZXMsIHdlIGNv
dWxkIGZhdWx0IGluIHRoZSBQVEUncyBvbiB0aGUgcmVhZCBsb2NrLiBBbmQgaW4gdGhlIGZ1dHVy
ZQ0KPiA+ID4gPiB3ZQ0KPiA+ID4gPiBjb3VsZA0KPiA+ID4gDQo+ID4gPiBUaGUgYWN0dWFsIG1h
cHBpbmcgYXQgNEtCIGxldmVsIGlzIHN0aWxsIHdpdGggcmVhZCBtbXVfbG9jayBpbg0KPiA+ID4g
X192bXhfaGFuZGxlX2VwdF92aW9sYXRpb24oKS4NCj4gPiA+IA0KPiA+ID4gPiBoYXZlIGEgZGVt
b3RlIHRoYXQgY291bGQgd29yayB1bmRlciByZWFkIGxvY2ssIGFzIHdlIHRhbGtlZC4gU28NCj4g
PiA+ID4ga3ZtX3NwbGl0X2JvdW5kYXJ5X2xlYWZzKCkgb2Z0ZW4gb3IgY291bGQgYmUgdW5uZWVk
ZWQgb3Igd29yayB1bmRlciByZWFkDQo+ID4gPiA+IGxvY2sNCj4gPiA+ID4gd2hlbiBuZWVkZWQu
DQo+ID4gPiBDb3VsZCB3ZSBsZWF2ZSB0aGUgImRlbW90ZSB1bmRlciByZWFkIGxvY2siIGFzIGEg
ZnV0dXJlIG9wdGltaXphdGlvbj8gDQo+ID4gDQo+ID4gV2UgY291bGQgYWRkIGl0IHRvIHRoZSBs
aXN0LiBJZiB3ZSBoYXZlIGEgVERYIG1vZHVsZSB0aGF0IHN1cHBvcnRzIGRlbW90ZQ0KPiA+IHdp
dGggYQ0KPiA+IHNpbmdsZSBTRUFNQ0FMTCB0aGVuIHdlIGRvbid0IGhhdmUgdGhlIHJvbGxiYWNr
IHByb2JsZW0uIFRoZSBvcHRpbWl6YXRpb24NCj4gPiBjb3VsZA0KPiA+IHV0aWxpemUgdGhhdC4g
VGhhdCBzYWlkLCB3ZSBzaG91bGQgZm9jdXMgb24gdGhlIG9wdGltaXphdGlvbnMgdGhhdCBtYWtl
IHRoZQ0KPiA+IGJpZ2dlc3QgZGlmZmVyZW5jZSB0byByZWFsIFREcy4gWW91ciBkYXRhIHN1Z2dl
c3RzIHRoaXMgbWlnaHQgbm90IGJlIHRoZQ0KPiA+IGNhc2UNCj4gPiB0b2RheS4gDQo+IE9rLiAN
Cj4gwqANCj4gPiA+ID4gV2hhdCBpcyB0aGUgcHJvYmxlbSBpbiBodWdlcGFnZV9zZXRfZ3Vlc3Rf
aW5oaWJpdCgpIHRoYXQgcmVxdWlyZXMgdGhlDQo+ID4gPiA+IHdyaXRlDQo+ID4gPiA+IGxvY2s/
DQo+ID4gPiBBcyBhYm92ZSwgdG8gYXZvaWQgdGhlIG90aGVyIHZDUFVzIHJlYWRpbmcgc3RhbGUg
bWFwcGluZyBsZXZlbCBhbmQNCj4gPiA+IHNwbGl0dGluZw0KPiA+ID4gdW5kZXIgcmVhZCBtbXVf
bG9jay4NCj4gPiANCj4gPiBXZSBuZWVkIG1tdSB3cml0ZSBsb2NrIGZvciBkZW1vdGUsIGJ1dCBh
cyBsb25nIGFzIHRoZSBvcmRlciBpczoNCj4gPiAxLiBzZXQgbHBhZ2VfaW5mbw0KPiA+IDIuIGRl
bW90ZSBpZiBuZWVkZWQNCj4gPiAzLiBnbyB0byBmYXVsdCBoYW5kbGVyDQo+ID4gDQo+ID4gVGhl
biAoMykgc2hvdWxkIGhhdmUgd2hhdCBpdCBuZWVkcyBldmVuIGlmIGFub3RoZXIgZmF1bHQgcmFj
ZXMgKDEpLg0KPiBTZWUgdGhlIGFib3ZlIGNvbW1lbnQgZm9yIHdoeSB3ZSBuZWVkIHRvIGhvbGQg
d3JpdGUgbW11X2xvY2sgZm9yIDEuDQo+IA0KPiBCZXNpZGVzLCBhcyB3ZSBuZWVkIHdyaXRlIG1t
dV9sb2NrIGFueXdheSBmb3IgMiAoaS5lLiBob2xkIHdyaXRlIG1tdV9sb2NrDQo+IGJlZm9yZQ0K
PiB3YWxraW5nIHRoZSBTUFRFcyB0byBjaGVjayBpZiB0aGVyZSdzIGFueSBleGlzdGluZyBtYXBw
aW5nKSwgSSBkb24ndCBzZWUgYW55DQo+IHBlcmZvcm1hbmNlIGltcGFjdCBieSBob2xkaW5nIHdy
aXRlIG1tdV9sb2NrIGZvciAxLg0KDQpJdCdzIG1haW50YWluYWJpbGl0eSBwcm9ibGVtIHRvby4g
U29tZWRheSBzb21lb25lIG1heSB3YW50IHRvIHJlbW92ZSBpdCBhbmQNCnNjcmF0Y2ggdGhlaXIg
aGVhZCBmb3Igd2hhdCByYWNlIHRoZXkgYXJlIG1pc3NpbmcuDQoNCj4gDQo+IA0KPiA+ID4gQXMg
Z3Vlc3RfaW5oaWJpdCBpcyBzZXQgb25lLXdheSwgd2UgY291bGQgdGVzdCBpdCB1c2luZw0KPiA+
ID4gaHVnZXBhZ2VfdGVzdF9ndWVzdF9pbmhpYml0KCkgd2l0aG91dCBob2xkaW5nIHRoZSBsb2Nr
LiBUaGUgY2hhbmNlIHRvIGhvbGQNCj4gPiA+IHdyaXRlDQo+ID4gPiBtbXVfbG9jayBmb3IgaHVn
ZXBhZ2Vfc2V0X2d1ZXN0X2luaGliaXQoKSBpcyB0aGVuIGdyZWF0bHkgcmVkdWNlZC4NCj4gPiA+
IChpbiBteSB0ZXN0aW5nLCAxMSBkdXJpbmcgVk0gYm9vdCkuDQo+ID4gPiDCoA0KPiA+ID4gPiBC
dXQgaW4gYW55IGNhc2UsIGl0IHNlZW1zIGxpa2Ugd2UgaGF2ZSAqYSogc29sdXRpb24gaGVyZS4g
SXQgZG9lc24ndA0KPiA+ID4gPiBzZWVtDQo+ID4gPiA+IGxpa2UNCj4gPiA+ID4gdGhlcmUgYXJl
IGFueSBiaWcgZG93bnNpZGVzLiBTaG91bGQgd2UgY2xvc2UgaXQ/DQo+ID4gPiBJIHRoaW5rIGl0
J3MgZ29vZCwgYXMgbG9uZyBhcyBTZWFuIGRvZXNuJ3QgZGlzYWdyZWUgOikNCj4gPiANCj4gPiBI
ZSBzZWVtZWQgb25ib2FyZC4gTGV0J3MgY2xvc2UgaXQuIFdlIGNhbiBldmVuIGRpc2N1c3MgbHBh
Z2VfaW5mbyB1cGRhdGUNCj4gPiBsb2NraW5nDQo+ID4gb24gdjIuDQo+IE9rLiBJJ2xsIHVzZSB3
cml0ZSBtbXVfbG9jayBmb3IgdXBkYXRpbmcgbHBhZ2VfaW5mbyBpbiB2MiBmaXJzdC4NCg0KU3Bl
Y2lmaWNhbGx5LCB3aHkgZG8gdGhlIG90aGVyIGxwYWdlX2luZm8gdXBkYXRpbmcgZnVuY3Rpb25z
IHRha2UgbW11IHdyaXRlDQpsb2NrLiBBcmUgeW91IHN1cmUgdGhlcmUgaXMgbm8gb3RoZXIgcmVh
c29uPw0KDQo=

