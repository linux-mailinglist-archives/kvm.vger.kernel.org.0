Return-Path: <kvm+bounces-47211-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 678B8ABE9F7
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 04:38:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1969C4A218F
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 02:38:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B8C722B8C3;
	Wed, 21 May 2025 02:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k6NBKMdz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EEEE4430;
	Wed, 21 May 2025 02:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747795093; cv=fail; b=gh+e5uJqLscsZe3ocAel0Grcc3MjkWLXmGaB5DKG6W1hp8geY5ZIzNaDkiPPB5EvtILhB3H9lfjDrgYBDk0NbA7lqdxuRXLNBlvkBVhj+YMGrxGp7eaHovTSqOEJvmhOAklY+UXNXpqaGoAUdu9jfElcU081ZKq1KzbNvO1wOoI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747795093; c=relaxed/simple;
	bh=cunCauJJ79n/WjqK9sx0hFflq1hcITs0XHACyRj9baw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=mIF+OibWZCj1Eg9RubgHJSFHuJGK9bYezSSz9vnbakVnKDWphGIONJLIKMIIDj8cZ80e46o3LynXcqsS/gMUzEgsK5eJGSX+qlSCa8Mgmslg7MGKDvdCAUFErFwIdMxGhzDCPTgxSKoXqPs90/rJuPABa3CW65mYNiKHaipsvJE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=k6NBKMdz; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747795091; x=1779331091;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=cunCauJJ79n/WjqK9sx0hFflq1hcITs0XHACyRj9baw=;
  b=k6NBKMdzLI8783eKIq418CPOOOfb/LnX+hnObOYl0XS3nYIJrceQ4Q9K
   sYmMrSOAoxHYSVc4yiubXBs/stOFECe7gg67fdpva6xdgPAtZ+LW0EM9K
   sfpJxyod9el7zz4JCKTfLB4yO1iUTcaY+7X8Q7EueO9MPSRL/HJW1HxVb
   e2UDylKAF0NrCEDMBENUNkeUo5hbVFOd3MdcOaRc2JHsMx3rgSfkKswU0
   KdpbkCv0ZqzD5Nq+porreNJllYwAeeBRmfq1/UA6AfKl1UTLoZqufbYTf
   blBqOnM+HP98oHLY0KABrLxnpXII1C8xUAUUDcPkJPI3CES7Ywz6KMqKR
   A==;
X-CSE-ConnectionGUID: PLNAcufvQBWAy4KJpZmU9g==
X-CSE-MsgGUID: BL5V6srVQqKI9MSP+N4bsw==
X-IronPort-AV: E=McAfee;i="6700,10204,11439"; a="53419752"
X-IronPort-AV: E=Sophos;i="6.15,303,1739865600"; 
   d="scan'208";a="53419752"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 19:38:10 -0700
X-CSE-ConnectionGUID: ZA3j+DoORhCWs9Tdx8oQYA==
X-CSE-MsgGUID: 1cQ4TDjRRPS0KOIJ7fXcfg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,303,1739865600"; 
   d="scan'208";a="144843502"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 19:38:11 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 20 May 2025 19:38:09 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 20 May 2025 19:38:09 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 20 May 2025 19:38:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=braaLDsfOzOS0wcEVwTissoEvnsyaoZRo+8f0Y+VVS4Vj2kyrFVgxJQlAfW6hwtHaJUeeE1La6sxzaXZHBh851WRX0GTUkfvaqudRnfBUFrXVsJQl2xDRq14x8tCEiQtr327e9BQ5UYwJqi/cKogyiSbKnq8RJ82r57UP4xKVkpZZmT8ZNLCCcpRO/ltJ9bBs78+DnzWif+B76II0bnk64j/7z5OM8doLUf7j6vac9Hvp8+7p8iIOOCuwQmFxO4xCzKK7becV6n5wwJO03lVLJj6MKV1XtY24JmLnR9teIFwDj8rcWzS3mzG1TOkmoXej2ggfqaRE5VPktsO0k7D2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AGPuL6dPqqw7cXyzwpzjxrwYwrZPQig+BoRLYdIyX3s=;
 b=RYTWYaNCyCLPQUIoph62KUiteQkx6Ax2pz4toIxCvI09YBnrWqN4AVG+GrLrgTKKDE7PAySDShwzQ3fZJZ1e8LVNZGaMZMxjO5iE9goKdCTwf2fSDPuRiy3Nsu4G0cSPpgmBSH+Fkx9YYOLqXmc3WPbOtg4SPO95eQWsA38f53y74E4ypzdYDSrduKWy0a3wXUbYEv+1GG6ZNv1xkv1sTzL92+JuiOK8mlZSUhofVfn4iyiQiToEqgCIQPrKXAPRS7aOcQ7LtN3u6j+q95pOmGSsWWpURzUckfTLyL2s8115kdhnAViqQUjyQndI0FqE1DbtWNYvolfVB0w0flqRUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS0PR11MB8135.namprd11.prod.outlook.com (2603:10b6:8:155::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8746.30; Wed, 21 May 2025 02:37:51 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%2]) with mapi id 15.20.8746.030; Wed, 21 May 2025
 02:37:51 +0000
Date: Wed, 21 May 2025 10:35:38 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: "Shutemov, Kirill" <kirill.shutemov@intel.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Du, Fan" <fan.du@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>, "Li,
 Zhiquan1" <zhiquan1.li@intel.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"tabba@google.com" <tabba@google.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"Weiny, Ira" <ira.weiny@intel.com>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pgonda@google.com"
	<pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Message-ID: <aC07+s9VvNFCG1ZI@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <20250424030618.352-1-yan.y.zhao@intel.com>
 <dc20a7338f615d34966757321a27de10ddcbeae6.camel@intel.com>
 <c19b4f450d8d079131088a045c0821eeb6fcae52.camel@intel.com>
 <aCcIrjw9B2h0YjuV@yzhao56-desk.sh.intel.com>
 <c98cbbd0d2a164df162a3637154cf754130b3a3d.camel@intel.com>
 <aCrsi1k4y8mGdfv7@yzhao56-desk.sh.intel.com>
 <02f8678221629a0aa05a73bcade8e1fe6f3aa1e5.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <02f8678221629a0aa05a73bcade8e1fe6f3aa1e5.camel@intel.com>
X-ClientProxiedBy: SI2P153CA0007.APCP153.PROD.OUTLOOK.COM (2603:1096:4:140::8)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS0PR11MB8135:EE_
X-MS-Office365-Filtering-Correlation-Id: 6704d0d8-410d-4b74-647c-08dd98107b2f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?TABEDLA4rbY8jhP6ziunRn2TBJmsxM1/AfPv9yNtMagycC2v/YkxPRAJVI?=
 =?iso-8859-1?Q?AYUohoFNHIUFB1P5rX4Ym7TdlDxEJq9zbaT3uCsPHwlaipA7ojZ68RHMQX?=
 =?iso-8859-1?Q?O2o1khh5psXQx0IB6hIHq39iElRW7Wr1A48JG6zXjMsWS1Hq0vcjtaZ+a7?=
 =?iso-8859-1?Q?d4p+j7dhCpltCRmDtRJSW7+J5gz3k17gKtlpjJaeBivqEHh1OIXYN/lLa9?=
 =?iso-8859-1?Q?o6o+Sz6sQ/1wGJNQzmRB6HLXmTfJYnpZ7ruzviX/xvyKc2wtUIkOiCMSMt?=
 =?iso-8859-1?Q?O9P78ZI4BNDUkeiHqnIIjoTHt4GEbhhhovcwWBB9n+Sj3HaOUz9Kw8QJ8z?=
 =?iso-8859-1?Q?nfwx0QiHAfy4PB1pnP5is4VRQENyk5mPoHS6788O2s6PV1X+zwZxMg4KyH?=
 =?iso-8859-1?Q?JhfC8jZ9ZTYvyIcS3LlDvR7VHCpdd7QNTbrqdT07upbiH0b3+C4OpWx3SU?=
 =?iso-8859-1?Q?fzVNYwLUJrc4AfUFpafVq9YksDzKYRny3pkSOIfzSaFM1lhbDoP/8Dpg6O?=
 =?iso-8859-1?Q?FfzWbJyChRR9bnT6xLf3IXtiUX9jRWWNnjQUS59VAc4S+3sTZmDqRiBUNu?=
 =?iso-8859-1?Q?4IwiLEZ72SOlmPAjnN/CrtsJScJvuHtWw2nXYemq31Cx6vQoD3/RWik5Oa?=
 =?iso-8859-1?Q?5zdbwhsSBHRb4Z/prLhUUcNqSTr6GiK/xdF6jTYZ+7kFYYK8p/CBhIdoH6?=
 =?iso-8859-1?Q?0WPuUDSIDh40bheQZalqDPgP8m6xE1tjk8yzsdOyFYlWppbWwakzdA1h0w?=
 =?iso-8859-1?Q?5DycT/v/jOqD3utcaqgMJzdleiUiBMjnzORXCyv12I4Zk44SmNYmK4N0hK?=
 =?iso-8859-1?Q?aNK5wPiIY/lxbPoaBY86x04HcE7ofXFRW51G4sDtATEZUrMpwmrRyzXR1N?=
 =?iso-8859-1?Q?cGhFBAsofg1G/NrMlFmeHf4Riw963j4Q7hgBkFuQQYG4v55Mk14iDYIED5?=
 =?iso-8859-1?Q?Y5U/NUtoouHkizw61kqP/S3azRtfn9vHB2ycXWvwsXN7tQeW2zCWzUwE5p?=
 =?iso-8859-1?Q?06mxFLZM0XOAo9IpoV0/i4jQvBYfJMaoehvtx8a4qTd0yW0ZdHKR9Fdct1?=
 =?iso-8859-1?Q?JjBkgyAFs0s9cbghlmaw2H0OAdnG+Qq2Pa0nFsoZRc1hwRwG93MDE2JVWw?=
 =?iso-8859-1?Q?Ro233/PdbvMiPJlRlo0JA6msI01b9xMSX/oI2yEPUSQIdb4b7YKu0gBQCn?=
 =?iso-8859-1?Q?iPOeUiLRzVkCp+NV8bn+aJy0AXbub11bzqJdYyqfmJHUIvvAVCbWaWY8lt?=
 =?iso-8859-1?Q?GU+B8Ssp8auIjHbESocS49guBGOk2AstsM2fRoD9NkfcTjmIfsJy+G/r9q?=
 =?iso-8859-1?Q?jtNHsT6xUCLR/HWPoedGGV5PWAyw/5+ERxjzir2FRG4fwvTU3A7pbcLCTl?=
 =?iso-8859-1?Q?bHVNJqNuCtyQ2x0dXMNGuCvyJ5s+oDbgP2UoRCfs5lbrfyprlYj9v0/5oF?=
 =?iso-8859-1?Q?ZEQ8v95533afXgyNJPYBWFsuIJyOLZb4lTaQL3qJ8tkiEsEQyaJrYIpuf7?=
 =?iso-8859-1?Q?0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?EEzRIWGB7vMzIL/qCYuaiA+irRNLNJgxvd6OinvexyOxGHILk6cJRCdh6A?=
 =?iso-8859-1?Q?wJOlxljbVGL4CYiZPkBpSLARZa+SZEF3DhmFTD3MjnaOlzW7ZksaiAivMl?=
 =?iso-8859-1?Q?7UQbkIJRoi/gqS3q73Hp+oeWtL7GqMXJT9Pu4NCdKX6oFw+Heqj/j+HAjv?=
 =?iso-8859-1?Q?ruRQ2m9GWTx8Ik4wuD+2TjY1ujeiDxExddHD0AXyRzMvFCAHZv5PB4XuWZ?=
 =?iso-8859-1?Q?148TJg2ViXRn0rS03JUJs97YuPxvj4Y70dATrkDIMfiWSdMcTKbqqMhoY+?=
 =?iso-8859-1?Q?hVkBbChnXRJdfcTjtnYPki7ACZ/a41QVFmPEOkD1kJ1xDKNI5+fnW3fGdl?=
 =?iso-8859-1?Q?05bzQeKL01ykN2tfDI8Fd/t2QGeSXWXaejt98h0JxSAKT2YQRFKiaLBF3Q?=
 =?iso-8859-1?Q?CR15d6f3wGwj+0ivxipS+oCrjZX9eNU2b9thHZxNIOltMLM6hMLQWNcq0U?=
 =?iso-8859-1?Q?53o7UBPnuUlHlMYrAKgDrLGMQscPm9/2qZoGOKeHl8s5oxPB3jYeH/IVdu?=
 =?iso-8859-1?Q?SjHsoX82sMLjYFikhrSFjRsSJnD6od/YETZlbORwnWVUz7CCBzsKsXgYiX?=
 =?iso-8859-1?Q?tS3iMkk4S9xQCzKrpgjv9CSJRtinPu9uv1CP6sy8iQFMt+GNoZH6xkEEQQ?=
 =?iso-8859-1?Q?I+Tnqg/exJyVtEJ9NNkXTVRGew7JHpsMjIuI2MRBeHm6rdVPVantilm7Om?=
 =?iso-8859-1?Q?aZPL4u2z3FdaW8BOKBBAsnMnfd1bqEltutiux1XMH5S1STZphpVAGxsKbk?=
 =?iso-8859-1?Q?h76yBB6DKcmwslqVJwTnTJuTevL7onx3kSYQwrtpAZvgSBllDTvMR7VhA7?=
 =?iso-8859-1?Q?R/plb9t2vvYioCuMngmf58n3S0kHzlzScpWDI2xqzVuEEUojR8KfAP9mx8?=
 =?iso-8859-1?Q?ZLTWlM6mDrxa2qHWDIF4zpwfn2LMthV0krAliOU83DTVrO4UQ2UAGJIObA?=
 =?iso-8859-1?Q?zVs2CP7Dc4kk48LvS3zzJyaxMVs9rtV8XC/5tKWElDgG5S7sEzPM5B9tL1?=
 =?iso-8859-1?Q?9LtQAqa3raY8vCNLKStIckTZK9nxmHZl67o9t/JuFGJaLyUZ+dzCVGltNl?=
 =?iso-8859-1?Q?J0ye7oQHTalhBlt+pGWbvxDUTGB/WRNFYYusVIfHCE4L+/rXmE2vXu6QZb?=
 =?iso-8859-1?Q?f41bm8lMIsXT/NfvOHVF1R9VyqYhOEiz/OqUMcV5ruIpX7aCB7bqDPTpiG?=
 =?iso-8859-1?Q?39aJvLIJRcdEapDMvpjln1tS26ASXX3oujq9lqLtM/CeHR/ghjN3C2rWXd?=
 =?iso-8859-1?Q?RnXxrAYDmXtcIHc/iWq6oDyuEi9+bjgLoZyrOSssGkW6tdI4mU0vxh20cM?=
 =?iso-8859-1?Q?TE3ifDQ257VlDXz3Cxs8PInC/S7bD6mnJvvsDkugIcgc7ayJQ9ui+oRFE+?=
 =?iso-8859-1?Q?ZSwCvAHeH/3re5FXXO2ZpTnXKml8r0D85lJUIZE40NGG57IjLuftfZq8/Y?=
 =?iso-8859-1?Q?UE7Bm3i+GgSbZZ80lKJfZmvUqpgPorkuCzHppN2EvYIgyn+0bH7J/qSliq?=
 =?iso-8859-1?Q?1RNKhRehnqZKCQrVsHmM1vBzJr54l4KnVrM2cwL6zaxC5bm0qHUux1Q12r?=
 =?iso-8859-1?Q?26yajQqgE7s3sAfkIvkwYAXjUvGsCTou8hNG4Zo7OJ/cfqiNfp/+C3cTNy?=
 =?iso-8859-1?Q?xTB0QTCommjLu5Cf0VPL8zJ7I/VKIkf8YY?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6704d0d8-410d-4b74-647c-08dd98107b2f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2025 02:37:51.1535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dRtF9UD9Wm5QthbtgfZI3j2YDPYdrcQd+HD5kGf3+Mgv+HFdpurzvuTRP8XynGXWCrHTaegVev4/oGyK4aGWsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8135
X-OriginatorOrg: intel.com

On Wed, May 21, 2025 at 07:34:52AM +0800, Huang, Kai wrote:
> On Mon, 2025-05-19 at 16:32 +0800, Zhao, Yan Y wrote:
> > > But in the above text you mentioned that, if doing so, because we choose to
> > > ignore splitting request on read, returning 2M could result in *endless* EPT
> > > violation.
> > I don't get what you mean.
> > What's the relationship between splitting and "returning 2M could result in
> > *endless* EPT" ?
> > 
> > > So to me it seems you choose a design that could bring performance gain for
> > > certain non-Linux TDs when they follow a certain behaviour but otherwise could
> > > result in endless EPT violation in KVM.
> > Also don't understand here.
> > Which design could result in endless EPT violation?
> 
> [Sorry somehow I didn't see your replies yesterday in my mailbox.]
> 
> You mentioned below in your coverletter:
> 
>     (b) with shared kvm->mmu_lock, triggered by fault.
> 
>     ....
> 
>     This series simply ignores the splitting request in the fault path to
>     avoid unnecessary bounces between levels. The vCPU that performs ACCEPT
>     at a lower level would finally figures out the page has been accepted
>     at a higher level by another vCPU.
> 
>     ... The worst outcome to ignore the resulting
>     splitting request is an endless EPT violation. This would not happen
>     for a Linux guest, which does not expect any #VE.
> 
> So to me, IIUC, this means:
> 
>  - this series choose to ignore splitting request when read ..
>  - the worse outcome to ignore the resulting splitting request is an endless
>    EPT violation..
> 
> And this happens exactly in below case:
> 
>  1) Guest touches a 4K page
>  2) KVM AUGs 2M page
>  3) Guest re-accesses that 4K page, and receives #VE
>  4) Guest ACCEPTs that 4K page, this triggers EPT violation
> 
> IIUC, you choose to ignore splitting large page in step 4) (am I right???). 
> Then if guest always ACCEPTs page at 4K level, then KVM will have *endless EPT
> violation*.
> 
> So, is this the "worst outcome to ignore the resulting splitting request" that
> you mentioned in your changelog?
> 
> If it is, then why is it OK?
Initially I assumed the guest should always accept in the sequence of
"1G->2M->4K" as what's linux guest is doing.

If that's true, we can simply ignore the splitting request in the fault (shared)
path because it's the guest that not follow the convention.

However, Kirill and you are right, the guest can accept at 4K.

Given that, the "worst outcome to ignore the resulting splitting request" is not
OK. 

> It is OK *ONLY* when "guest always ACCEPTs 4K page" is a buggy behaviour of the
> guest itself (which KVM is not responsible for).  I.e., the guest is always
> supposed to find the page size that KVM has AUGed upon receiving the #VE (does
> the #VE contain such information?) and then do ACCEPT at that page level.
> 
> Otherwise, if it's a legal behaviour for the guest to always ACCEPT at 4K level,
> then I don't think it's OK to have endless EPT violation in KVM.
We can avoid the endless EPT violation by allowing the splitting in the fault
path, which involves the introduction of several locks in TDX code though. I had
a POC for that one, but we felt that it's better to keep the initial support
simple.

So, if we all agree not to support huge pages for non-Linux TDs as an initial
step, your proposal is a good idea to keep splitting code simple.

