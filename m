Return-Path: <kvm+bounces-63459-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CC674C670C5
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 03:46:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id C9FE229764
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 02:46:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55261242935;
	Tue, 18 Nov 2025 02:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BC95K6pP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF91645;
	Tue, 18 Nov 2025 02:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763433986; cv=fail; b=DXWCNNrGAmtPV0meMCPWb4lJ7McS7tbE4ZFrWdWgx/6SlvXPgd/31y9K0sumdtTR0YIwUOPiOdtGjq3G6nvJbbkzHK7aYLPdN4mfBhl/pat9zYJGoCyjRrTs2Pq9RppczwSkg243B7GwvPgb2AOJ6oCFYZFCRr1g/4/y0wqGdHc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763433986; c=relaxed/simple;
	bh=QPdq3n9/N8qTAXKqs36o9K0j3rJ+WDmHZG5GhJoSoIQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=CZmwBHSc6zQe/+Xah5CLQ+M0xOXn3lTCK7W42+4H4HfkjRNvBN7HLA6Q/FYZ6A8mIyc/Naf7bPEpkvuxcpgiEuvPca0QWJw+/0mQ8i9ZlemvfYR6ep+kv+pByDnH6k74SRcP1l5w+AKqNN9N299f5mv0JKERQwUGKpWU/2q5Nh4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BC95K6pP; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763433985; x=1794969985;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=QPdq3n9/N8qTAXKqs36o9K0j3rJ+WDmHZG5GhJoSoIQ=;
  b=BC95K6pPlKXjCYtcXxyfnqLpojoMEksuxuyc7PcviE98LeN3kFLF/Qav
   r8RxY8SsrOdwdUg8aq9TnF8CmLSAJQZ/9r7WsipcnG8dMudYzFQQiVNMB
   a1tknqau+qCHE79dwb+miy5u7PWpqhHaIbsw1RVFYPo7u/DkvqIJpHc4u
   8xAZUyhqMO0Sl0HjlUmWZTnAtrOczaPzIQIyokbzq1TKsIADtlmv6sM+q
   LPc95jRFujlvfiXOU4+eWzhHn+Enh6bmpZfmhG2BVsq46iE5QCh7a/nUd
   GUgjLFMM+HmWbXyMSuhUrEORio5qMw3Gm30skRFxBwemsoFjoy9otohAt
   Q==;
X-CSE-ConnectionGUID: QCdIwSSjQfyk7/QR8uNUtg==
X-CSE-MsgGUID: XcgiZqmZSFe9XVsN5o0wWA==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="69315177"
X-IronPort-AV: E=Sophos;i="6.19,313,1754982000"; 
   d="scan'208";a="69315177"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 18:46:24 -0800
X-CSE-ConnectionGUID: 6SU0YKCOQ9qYA3e0JEqa6w==
X-CSE-MsgGUID: OsPjwKvpQqO3HYU8OW1dVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,313,1754982000"; 
   d="scan'208";a="195552286"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 18:46:24 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 17 Nov 2025 18:46:23 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 17 Nov 2025 18:46:23 -0800
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.64) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 17 Nov 2025 18:46:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tk0aE0nlCuqeOyJyhNxwX0u/YJfJ+ehOTdDzPLd9xmfeK7B4joU6WpwU1OYhsnhOaxQo4lgGHmTphrjQ94CPthzZQNfV+tfKHtAfgpQYwfhZFkFNKzBATuxHv1O3jYgH123ySxKVaLyccC5mbh68SJrUFwgO2kA1y8j3QPixa1QM1v5CD7bsSk7Do8P360W9vOiHCsNLcjrQac5yBjU0fpE+AyZTxmbWM7CuRQXuW6DnV1OX817j+NrfHvKfkqouvUqUVfWJ4rdMbH2sX0/e9VIeM+8habRQ1Q5A6HobmeIxApFmUctfWutVUre/p4cNXjT4t0KXQt6aaiNu1312CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WDr48BEivdx6OnjhTEGDdSVb9cfVsiPZqlebxTeqpps=;
 b=E6CNmFBzpuuotBGLUJYmLmFPM6KGRrv6fcufnoX/mw8Yk3sSGEybPpNf5L+a3iBHqztl7x4aZHa/yHmQ3flBWznqzKraSad5Ci+6TAHUdWdNATSl173yy3EX/Apdv4d/fbGLDzV2PkDA/OzozQGTbDcVZd1TTubH3hFDG7XAjXWxsXiShUGEnWy0zNSixzOrrReCcibsR2cSCzDTjw9Yye5rOXO08ASJmzVphzKRuzUOvaMuQbfu7LtseaC6MT0xHIKnrxpWqL96slpYM/jh3gbXhzAnh+w4cjnH7yjmzIwWFEfIjBkebquR3MWdf1noodSEU/GlAgJ+PP2nTwV3YA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CY8PR11MB7798.namprd11.prod.outlook.com (2603:10b6:930:77::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.21; Tue, 18 Nov 2025 02:46:20 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9320.013; Tue, 18 Nov 2025
 02:46:20 +0000
Date: Tue, 18 Nov 2025 10:44:11 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"tabba@google.com" <tabba@google.com>, "Du, Fan" <fan.du@intel.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "seanjc@google.com"
	<seanjc@google.com>, "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Weiny, Ira"
	<ira.weiny@intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "zhiquan1.li@intel.com" <zhiquan1.li@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"Miao, Jun" <jun.miao@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"pgonda@google.com" <pgonda@google.com>
Subject: Re: [RFC PATCH v2 14/23] KVM: TDX: Split and inhibit huge mappings
 if a VMExit carries level info
Message-ID: <aRvdewUMeaPZoCEU@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
 <20250807094423.4644-1-yan.y.zhao@intel.com>
 <183d70ae99155de6233fb705befb25c9f628f88f.camel@intel.com>
 <aRaJE6s8AihGfh8w@yzhao56-desk.sh.intel.com>
 <ada5b8af9ba70b7af87820d5e3a551fb6352853d.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ada5b8af9ba70b7af87820d5e3a551fb6352853d.camel@intel.com>
X-ClientProxiedBy: SG2PR01CA0117.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::21) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CY8PR11MB7798:EE_
X-MS-Office365-Filtering-Correlation-Id: 111900a8-3e60-4b9f-f827-08de264ca765
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?PNJrx+tm/C4N253+SIAorCP8Ik61IqodM+OoK8XgxUwvLqCUg64FU0v3V0?=
 =?iso-8859-1?Q?IzYAcCRSrXARFtBr/wCjEsSl260nLomqQ/hmxCsu3uibao3RApb+WsKPeR?=
 =?iso-8859-1?Q?wKkBDjuByM7l0zLkoXKH9uqjAe0qzaFCskhJx0n8DgulQYUK0Ho40V/qx/?=
 =?iso-8859-1?Q?fHl7ACj0KGzzFeiuWQK2Bkixv/MOfgZFt9OZIBeki+vVgQk4o7+LxLq7Tn?=
 =?iso-8859-1?Q?ixDB29B5fKn8LVY/Fzu+SBMviuCivjffoAlLVuRiBSd+TCuMVnm/GnWhfd?=
 =?iso-8859-1?Q?XX/makzurcpburw2Vaf9R+yXsUrh6OYGVAVPm4ykkq05lzROma4PSod/ku?=
 =?iso-8859-1?Q?lHDn3dJUn0OKoallLPmxAm8pLqYDU7ykbe8J6G5WrqzyOThh5Nsjf0Ikxn?=
 =?iso-8859-1?Q?wa6BXQHhbBBkdFsm7R081S7Hl0B54FvRvm4xBcK7EJyx7q0YuxF+TQhkhu?=
 =?iso-8859-1?Q?bcK81E4MYHh1b9DghTLyypltcxJFa8sa+Nt5SN6qI0pv7Von7lijHzFVAX?=
 =?iso-8859-1?Q?28tjnuJpgluvrDRrAwf7WXJhBJ0ZA0F8X2qCZtpnCCToKRMYzyoSUKHybl?=
 =?iso-8859-1?Q?Y2v1w2p5+NklTgbQaqyx7YKAEouGkHO7g5sZtOhasZYAUsoxbwwnHvEUzO?=
 =?iso-8859-1?Q?t+5XxeAAFZq7mwYIpgX7zjmHrJXF7DGHZ2vlpL1FSRQScFpeejQxBHUjqn?=
 =?iso-8859-1?Q?g4eDK2ivHTcJQm6sSOp8W4pvedILK3biishf3ATi3KgjUz6fCNKuTLEhuc?=
 =?iso-8859-1?Q?dG90QBZp46sTZ/pGBzI4R/IwleVmH99eTXuAFlydq1v0aksV9BUP0IR302?=
 =?iso-8859-1?Q?C5RagmMqSTkx7OWgX13wAbZEqI0MGhMsaOYzcNE1kUxEIMV56mjHbOo70o?=
 =?iso-8859-1?Q?cOQVuxoKlxP7ppvatSEdHzW8DTbEYImJlm2meKZboZWAb1avAdXVc9RqOw?=
 =?iso-8859-1?Q?3yjslsmDNLXWS0LWCgTsQArW7mNmUzzc2J05rqpL29QtVv4F5jkh5jF5ia?=
 =?iso-8859-1?Q?LGfkbXcAMY24iCicl4OUuxHq2bLKPruTcmOhPt4F2Uwj+14nKzf0ay7S+o?=
 =?iso-8859-1?Q?/j5xiC5VXKbuSDRCn8SnJ+YqfnBbE3G9A8qEiOn1z2A6GLUsW2cqkbQu7E?=
 =?iso-8859-1?Q?cJ5y6MfuqUX7Sqpg0Mmk7EdoqyRb00PXiLE2AG3/sqSBMo4+blGDd8yPuj?=
 =?iso-8859-1?Q?2PCoVqV+aArntJcle/OjQyVWrJ5NeudAvPTOCAQMerbQInDbQlNL32Y8WA?=
 =?iso-8859-1?Q?vTvX1JQzfw7NlzSC7ub2/qWuEZZtfGxnP51dqueYYjjRoeYbEaQmolikHB?=
 =?iso-8859-1?Q?viezi3VxGSOGzEmbeg7D0IwEEzK1BAYQ5HVomVXeI/OW9z4qaJAPtTTZYY?=
 =?iso-8859-1?Q?fgRnqvDysbPqp7SgR8wAcAxqxzr9gewwIx4xPnSmmPvnU7spoLN+qGSGmw?=
 =?iso-8859-1?Q?aJtpw/mj65hLpLLHBwQJy2PmScvw8FBqkDgHxphuZjrz9AdPGMx/23G57m?=
 =?iso-8859-1?Q?rYO1d5IbIIKc6x/58BHvrN?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?29xNWfp71b8YGlMGpNWza4waPHaEnO+AJS7S657yq1Z4irNpR7wE9GzfTB?=
 =?iso-8859-1?Q?fArn5H3HMfhcw5fYexrMDD1I3aKcfs6npL3UlhpGrQj0+Sye6D6WC0RfEK?=
 =?iso-8859-1?Q?kD/t962eothkzps0j8iKkwlsqa9StuB/Kz8NJxS6Ymek62Hx/rb5snvDys?=
 =?iso-8859-1?Q?s6YPB7qOlFUkuymzBAUfmBCFbPZ3bn2/QiQeEHCd4YGDKoBHn0NtZQQrbQ?=
 =?iso-8859-1?Q?1KyLuttFq4H2CERQxrIZ1NKk7+x48Yz8ulkTL927oWZ/ZyzlA+XUs7Ub7S?=
 =?iso-8859-1?Q?vdUowB7PoRSfAnvGxpPP6yTAcQIdwENMnZEVOoLyviertRRto0k32PeJKP?=
 =?iso-8859-1?Q?AVROJaILCtKQrGgK3iIisUqry9sVxo8MO9H3jePqLFAgTYgndRu0W3MpYG?=
 =?iso-8859-1?Q?sUDtjqHfV6aRoPMueQF35V0TzrFZ/qUrc7njaj0BYPFP0ASVyFPT7GQ73/?=
 =?iso-8859-1?Q?WXbfvEqZYZ6ARGt3NKAUZtKZ/rRcbo73vseiYoOf7BLYSfaBXLhXOn6lDX?=
 =?iso-8859-1?Q?4VvWw0yxv5BWsXnq6/qm6t7FtX6XN41YaOWxuUBrrciOxUGRAN5u0JA8nQ?=
 =?iso-8859-1?Q?+Ym5IPfGun68oQDhduLdFK4llDlhWyQQIa2k9aMnZ0KlITkjBZ0MlayXtu?=
 =?iso-8859-1?Q?S6lPPYCAkpTZoAdvUL2OpKaaDYNSMA2SeekQJIntlerLPGB3DNziGCXqfv?=
 =?iso-8859-1?Q?iOBd9iqCiqQPMSTmCUHz8LADEe/8ifzIofT8wDD5rpFv2S1IMShIv+H+V9?=
 =?iso-8859-1?Q?Toz+jtDFunJeFcIbfIviStTK7ecX8NqAcu3Nv9A7xeA1RaSc6udcqLRVv3?=
 =?iso-8859-1?Q?7+9jgBlEonh63je7V2sTC4HGMCo3/WnTh8uzpAn4rubND0CFzZ0W6xjmVS?=
 =?iso-8859-1?Q?JQZLgH7DWSLd59eGmeorF/0ZWqFTo8v3G786oJMpHvMfMvnsS5/Mqy54YL?=
 =?iso-8859-1?Q?9tJ7fiQ/tb0Oz7nrf4QNiS3qOOZ5YCCwyHRazOLZgUyULxVSQQmj7FR4do?=
 =?iso-8859-1?Q?zs3J8wRcaqI9+fFFMVurzgsHOUiIBl5Rpkj67HKYnUdogafyrd75l2o0G1?=
 =?iso-8859-1?Q?I2NZN414Jc4X+5FGCZhyp0Q8pbACQ8cchJdE5VnYyCoHmglUjQRJyWdm4w?=
 =?iso-8859-1?Q?qgPDc282+NcaW8qnm55FrRs9qf/vLBfa48OlhhBWxRi7v5H/4oVK3X00+b?=
 =?iso-8859-1?Q?Pt5u5XDkDrRSRJZUL/DEGX+VclCuALpjFQLzvTZHqlZnHVxm3ex02aEaKJ?=
 =?iso-8859-1?Q?2+A9GW3cVjziGt8Gt/oCPaSqDYslurkU1mucrQUQFJl4J5njQkUVHkzg2Q?=
 =?iso-8859-1?Q?DtxIvrkIcfzDNGSwnoxwyzDdYoYZn/sBHbWoAidYZgtgzBETLEXnAWxvVR?=
 =?iso-8859-1?Q?aoYQN2Ah7Gri0u+PICabZ6lY1UwatFs6559rbYzAX5/1VYC1ugvQdWHlgd?=
 =?iso-8859-1?Q?doAfELZeFdUq2t35LAVzynF6kGT5CzBdQYQo8bIejJ58494/5b6YbgVf8E?=
 =?iso-8859-1?Q?jdtp1D+sWvcDP6/Irb4gqlo561LZSUF7PHbGOrvnHaGNhu8VjBX1phL3wK?=
 =?iso-8859-1?Q?acyjXe2YLJw7eDcc/R3jLoagvc/6F8QFz1cnfnrB8EXqEUJx7e1Ic+Zt68?=
 =?iso-8859-1?Q?d6ZBdEaNxJZ7roy0Td67Eubvz+dzTv4b9G?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 111900a8-3e60-4b9f-f827-08de264ca765
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2025 02:46:20.2804
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RWT/g4nKdQW6nVYkzh4xx5/rxxx0io7wCktlBAlIqbY5ZlG4UmXAEGGqTtoUfcOTwh6rj6STdH7eGy/M7PCeFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7798
X-OriginatorOrg: intel.com

On Tue, Nov 18, 2025 at 08:26:42AM +0800, Huang, Kai wrote:
> On Fri, 2025-11-14 at 09:42 +0800, Yan Zhao wrote:
> > On Tue, Nov 11, 2025 at 06:55:45PM +0800, Huang, Kai wrote:
> > > On Thu, 2025-08-07 at 17:44 +0800, Yan Zhao wrote:
> > > > @@ -2044,6 +2091,9 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
> > > >  		 */
> > > >  		exit_qual = EPT_VIOLATION_ACC_WRITE;
> > > >  
> > > > +		if (tdx_check_accept_level(vcpu, gpa_to_gfn(gpa)))
> > > > +			return RET_PF_RETRY;
> > > > +
> > > 
> > > I don't think you should return RET_PF_RETRY here.
> > > 
> > > This is still at very early stage of EPT violation.  The caller of
> > > tdx_handle_ept_violation() is expecting either 0, 1, or negative error code.
> > Hmm, strictly speaking, the caller of the EPT violation handler is expecting
> > 0, >0, or negative error code.
> > 
> > vcpu_run
> >   |->r = vcpu_enter_guest(vcpu);
> >   |        |->r = kvm_x86_call(handle_exit)(vcpu, exit_fastpath);
> >   |        |  return r;
> >   |  if (r <= 0)
> >   |     break;
> > 
> > handle_ept_violation
> >   |->return __vmx_handle_ept_violation(vcpu, gpa, exit_qualification);
> > 
> > tdx_handle_ept_violation
> >  |->ret = __vmx_handle_ept_violation(vcpu, gpa, exit_qual); 
> >  |  return ret;
> > 
> > The current VMX/TDX's EPT violation handlers returns RET_PF_* to the caller
> > since commit 7c5480386300 ("KVM: x86/mmu: Return RET_PF* instead of 1 in
> > kvm_mmu_page_fault") for the sake of zero-step mitigation.
> > 
> > This is no problem, because
> > 
> > enum {
> >         RET_PF_CONTINUE = 0,
> >         RET_PF_RETRY,
> >         RET_PF_EMULATE,
> >         RET_PF_WRITE_PROTECTED,
> >         RET_PF_INVALID,
> >         RET_PF_FIXED,
> >         RET_PF_SPURIOUS,
> > };
> > 
> > /*
> >  * Define RET_PF_CONTINUE as 0 to allow for
> >  * - efficient machine code when checking for CONTINUE, e.g.
> >  *   "TEST %rax, %rax, JNZ", as all "stop!" values are non-zero,
> >  * - kvm_mmu_do_page_fault() to return other RET_PF_* as a positive value.
> >  */
> > static_assert(RET_PF_CONTINUE == 0);
> 
> Ah, OK.
> 
> But this makes KVM retry fault, when kvm_split_cross_boundary_leafs() fails, due
> to -ENOMEM, presumably.  While in the normal page fault handler path, -ENOMEM
> will just return to userspace AFAICT.
>
> This is not consistent, but I guess nobody cares, or noticed.
Oh, I got your point now.

Though retrying on -ENOMEM is also OK, returning ret to userspace for
consistency is a good point, given mmu_topup_memory_caches() returns -ENOMEM to
userspace.

I'll update it accordingly. Thanks!


