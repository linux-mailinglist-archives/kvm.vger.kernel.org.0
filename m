Return-Path: <kvm+bounces-68305-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C1D9D304F4
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 12:23:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 8C7983005015
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 11:23:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EA70378D6A;
	Fri, 16 Jan 2026 11:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C30fnDeC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 751B6374176;
	Fri, 16 Jan 2026 11:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768562564; cv=fail; b=laWyJwPA7sfuYkfTFsf3hyiEQcDGf/fwg2WlEnY9SvgTnXTC94IGQOq0bBjb1QIp9mIVSvVQXB643VuvT/+sex2feuAOjTwvJ4C9X06FoefYiG5d/l56XPFdn/oOGzAsCzODGDDcHwrxV5EXdpBOwEfiPkBzE3wLrhMKs/fnbz4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768562564; c=relaxed/simple;
	bh=qVmP6hh6CkaEdoncQ0R3oQPDlTakl/q8yo2O9O87+ZQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZwK5GPrOfjZT3mgApyZ/uhyM1IrJMw3MRlBuhTWgYpK4qmRHdHx/xXmbqIGfk6HfPRp9Lihi4kXPcL5i1ki1wg8cbTqSQDGjutvXhMw9g4Ty78qydPPWv5rXesxMLGyU2/90YGL0ocEYoIaG52kyXPy31qL2gyBdLMIKjD4zGR8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C30fnDeC; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768562561; x=1800098561;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=qVmP6hh6CkaEdoncQ0R3oQPDlTakl/q8yo2O9O87+ZQ=;
  b=C30fnDeCIpUJhAtWXJzve8fjLDNK/Te99Sx6AhmSstMedeLE/2sI0BwO
   KQZqP+4Wu7Ago4dOg3DJO4uyq9mSEb/mFL39NhLAQIiEPNeogrnGoNaXv
   h9SPV2E213P8beNpv6b4sW3be4I1EDeRItKfsy4sNfLMvA6vbY7Ty1BYi
   12H39AUrGndHYUPJ/2qNH+mp1w+vwb7j8+q6qF2EpgmD6YsRZUJBvfina
   m60T8O8SLm2Cm4WtZ9+4KjIm0s+NItfcRLgTaUC9eyrz6Gu7VweTEVPc3
   UWkW0Tkng/iTXyFnBFycHuBvje2XoNwXSPAAJh5YUl6WLxbU9hRTOKuEY
   g==;
X-CSE-ConnectionGUID: WjOE1YvUTECUmhf1mnVKaQ==
X-CSE-MsgGUID: a0da1LlLSv2TYXzyMnwCmw==
X-IronPort-AV: E=McAfee;i="6800,10657,11672"; a="70044024"
X-IronPort-AV: E=Sophos;i="6.21,230,1763452800"; 
   d="scan'208";a="70044024"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 03:22:38 -0800
X-CSE-ConnectionGUID: l7RhLy1MREePv21xKciMNw==
X-CSE-MsgGUID: Q0qnWrxtSYyO245XtGHxCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,230,1763452800"; 
   d="scan'208";a="204832628"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 03:22:37 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 16 Jan 2026 03:22:37 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Fri, 16 Jan 2026 03:22:37 -0800
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.4) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 16 Jan 2026 03:22:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q65/zpE1y/iVyR8ytXgR2IP/B7HiyVrKyKQwPtcUYtn2wgsmneDb0jhSGhi/1daiIW6jISFtF3PqsGzJ9sWIpEg1VGzhkg6JUux03Kn5JGjoMnujs99gmB2dII5kiB5/+3PD1kKJ5mxt7dez1rftJR1pmIbHmgFsO0fChrOaFFxeJWPRB+cZLA87tnJmFXhllF8iavXoR96HYlvbJnnKpTNPU8PfQ1AmGuR6hlmjUSGp71AycXa/T1Zn9zszVdWaVaFluRnEzzlBwSsfjXwtC9IUyQY9RRxArB6aKXpYKJX7dmp2Z98B0sgKVZvGmHlnHOH5+vjx6o5NHaPCGF7cBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qVmP6hh6CkaEdoncQ0R3oQPDlTakl/q8yo2O9O87+ZQ=;
 b=WoSdb0oS/AjlG2OMMr4JUsEDUJmXPEihq3R0lZ1ezmhic9T3bDOpCRV63bQEs+AbkfKsMJO3NiwUgdHMgYoWiUZu2J7jffKA4jIT7Pnw+WFjkZ5vAJU8mzbJApSH29eJntcv6ejqvT99nF6pNJkChSZ87W83abiKqv4i6r0jHWXMbFZQ3d9B0KN4cWNduLJYrD2d/z5aqJOmgCWccZJ4WNicKlzTq6lIgJw7twkseRQz2PKIeTR4qeeZ+vzEUA+5GWNYc5JFdAOBkKd4N5BhrFKWPNpzFnmPhWowlCR6xPYUZA+z/E1DXlXw3k8wDW0W4EbiwEkitnRAHrE/ywPp+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.6; Fri, 16 Jan
 2026 11:22:33 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a%5]) with mapi id 15.20.9499.005; Fri, 16 Jan 2026
 11:22:33 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "Du, Fan" <fan.du@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "david@kernel.org"
	<david@kernel.org>, "kas@kernel.org" <kas@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "ackerleytng@google.com" <ackerleytng@google.com>,
	"Peng, Chao P" <chao.p.peng@intel.com>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"sagis@google.com" <sagis@google.com>, "Gao, Chao" <chao.gao@intel.com>,
	"francescolavra.fl@gmail.com" <francescolavra.fl@gmail.com>, "Miao, Jun"
	<jun.miao@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"jgross@suse.com" <jgross@suse.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 02/24] x86/virt/tdx: Add SEAMCALL wrapper
 tdh_mem_page_demote()
Thread-Topic: [PATCH v3 02/24] x86/virt/tdx: Add SEAMCALL wrapper
 tdh_mem_page_demote()
Thread-Index: AQHcfvYqSBTaRjpSZEO/4jcRgCnGbrVUCRMAgAB/DoCAACtDgIAAA30A
Date: Fri, 16 Jan 2026 11:22:33 +0000
Message-ID: <c9b7b375019873b4bf8fccd93b3b1b53778ca3c0.camel@intel.com>
References: <20260106101646.24809-1-yan.y.zhao@intel.com>
		 <20260106101849.24889-1-yan.y.zhao@intel.com>
		 <ec1085b898566cc45311342ff7020904e5d19b2f.camel@intel.com>
		 <aWn4P2zx1u+27ZPp@yzhao56-desk.sh.intel.com>
	 <baf6df2cc63d8e897455168c1bf07180fc9c1db8.camel@intel.com>
In-Reply-To: <baf6df2cc63d8e897455168c1bf07180fc9c1db8.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|PH8PR11MB8107:EE_
x-ms-office365-filtering-correlation-id: 58e4c3c9-8956-4960-7646-08de54f18b60
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?TTFBNUUycUE3VXpqcldXMitlbmlYYmV3RmZUSzN2NDkyNkZwREdxR0N4cTVY?=
 =?utf-8?B?UkVjWWlmdmk1YUxHQ3FtbzNpWlpOT2J2R0ZXL1BNa0xJcE5IVVJtbk80YUlQ?=
 =?utf-8?B?YXUzdDBKR2VjbTFMY1NkK0Q5MjBiVnhib3lFdnFYM3Y2RzlJVkxuTGVjVGRx?=
 =?utf-8?B?NmVGQitGSkU0TTZDQmRFN25qcGlCamN5Rm12bU1PQ25wRVFiTThxSXNtSis1?=
 =?utf-8?B?NDFRYXBkeTFENHROZjBNQVMvby81RnpJY3NHcW1Kd2t0c3BYSjk3K2xxRDdN?=
 =?utf-8?B?OHBPRFBlY3oxeWpTdUllaVBRbDRvZitDMFV3bmVMTDJkcVE5TTRocEFwcnJ3?=
 =?utf-8?B?bmp3azlRZjRZMVRETUN0T0owc3ZCTnZUVmJNeUtLZG5QNkVtU3RkN1FwVkRI?=
 =?utf-8?B?b3FiWlpqZDJjdFhDVWcvUW50Y29xTVBxT3IzSklIeE0rTnFYeU5JWUxzUjY3?=
 =?utf-8?B?aUgvOCswNVBjdVorb01BY1pNSGdTQkdkSWJkVnJvd2JBTXQyd2NZejFFMmp1?=
 =?utf-8?B?aERyTkdJSFZEdkpEdlNoL3ppWHNZMDRoUytGbkZ1ZUN6bmZIYmorSVUycnoz?=
 =?utf-8?B?K25neUpJRUFUUHRLcGNGSm5GNkVJYmh0OWMwdXpZMWw5WGJpVWUweTlFc1hj?=
 =?utf-8?B?Q1NnQlJCcld1eE1jcFlBL2t1eXpYRmxtVjJHWno1TmRsbVg3RnVNZUNHa3ZB?=
 =?utf-8?B?Tk5BV0pmRnJEL1piNElkMXdML09IWVltV0NMM1IxNEJ6cHFYWVUxTENKUlVr?=
 =?utf-8?B?Q1AxKzFmU3NZWGFyVTBtV2pJNE1OWVFmV0lxcmF3YzRoYzVBcnRrSTRhZTNJ?=
 =?utf-8?B?d01WMlMxVFZnZmZDQWpvTGRzWG8rbG5mYUhidHdZSGRCenZkZU1WbGFXQmpU?=
 =?utf-8?B?VG1VWUZuNW5nTmQ2OHNXbWcwaGRLcDdML3J1S3k3NXhHSEpXZks5WHZ1SkRj?=
 =?utf-8?B?a1k4OHFaa0xHbHJMamdOSWZhQVU5b1B3Z2VzbGxIVmZQdzltNWZvSFpZQmp2?=
 =?utf-8?B?UGJqQWVJSnVqL3cvWHhFNGFWY2RvNWVrcldZR29VWjYrOWJMallGN2Z1NTFQ?=
 =?utf-8?B?NTI1anhSTDl2anZuZnNla0hLQzcvKzRXMS9qUXVZQWEveEc3c3ZpNEd0M3gr?=
 =?utf-8?B?eHFLMGljVWU0Slp5WkJrd3ExSzFpTCtXeDFHTStuOVRkUGdDZm9PcTVuampa?=
 =?utf-8?B?TGRsTnR2aEdUM2JKdGhOOE5NeTlyekhhRVZMMjd6QmY2OE5lbDdGRmFHNEZC?=
 =?utf-8?B?NWxrYnpZVGNUU2dZT044QnJiTXo2VzUrRzRhdXJnRXNFdVpBWUdOdFJvSDBr?=
 =?utf-8?B?MDhGNzJMTnNCU0t5cHZja1Q3QUJXT3VHWXVxeldRQU9BckdNbTNFSXdVL29B?=
 =?utf-8?B?cUVIY1BlSVdYdkFIWEJTb0NtUHF5cHBwMFVZM3Y4b1hGeXM1QUpmQy9oMkxs?=
 =?utf-8?B?TXg3UWpoeWMzU0ZBcnlaK2ZOeCtJcERVdzhFLzRIOE4xMG0yTXJ5WXd2czV5?=
 =?utf-8?B?c3FFUXVoZXN1MXo1TnFDYlRrUjhweDZXbXBLakNDc21tQVg5eG1lZ3BBZko4?=
 =?utf-8?B?NjVpV0dvelBjaEVZejBqWG1yQ3IzRytydkhYYXJtOHVMRWNKaDlrRVk3SGg4?=
 =?utf-8?B?dFNZZXJ3aFllSDR1RWozYU5zTENuZnJYSllLRGpVNTI2cFMyd0JvdGJsWXFj?=
 =?utf-8?B?cTN3cGlNWnp4dkdNWExadW9zYXRzQVFFM2tWTnZzeW1Zd0FMNmlCV2hwQk9G?=
 =?utf-8?B?cjYzUi9uNjMrWDkyclc5ZUQvVkdla0ZTYzd1TGtLTnV1d04xbHpjbW5lWlV3?=
 =?utf-8?B?bE91Q21BQllZWTdOSDMyZDE5WXhndzFDSTN5UTlBUDI2S2ZRUnY3cUoxWkF6?=
 =?utf-8?B?U1F5bmg1U2JZNVhvNXF5STh5bGptQ0hwajBYakUwVm84ZzBBOWcyU3hVYkRX?=
 =?utf-8?B?dmRFU3FuQnVwN3ovdmJvRk9XVUhpSGs1S2lkR09xaHFJSDBwQ3IzNkJwejh4?=
 =?utf-8?B?c3JTMTBZR3dTRDdQV2p4ZFRrK3gwR01sbUM5b0N3c05BakUvLzA0MmtQL09U?=
 =?utf-8?B?ejgxSkFwZDNYL29OOHdZZWVVUHA1NnZkVkRTZzJDZmZ1VTN5b3hkRXpTMFh4?=
 =?utf-8?B?YWJwRjZsMzBGRXdiTE9WQ3NZV3JoSHVLWFQzN1U0ZkthUjRHSFRER2pqWDdn?=
 =?utf-8?Q?oKNdSWe9z5iqsSe0PG0kvyI=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N3RaMmV3ekFyMUhwOTg1d0JLdVN6UDc2WEM2NmhaR0FGaWg1UG5kVlRUenZZ?=
 =?utf-8?B?ZTBOUFpBVFUyUlIxeFUyejFFbE1sVjgrVXZ1ZnZiaUlpOGJERXQxcklCOUQv?=
 =?utf-8?B?c2wrckY3THk3MnRQaTFlNHlXTjdPZVkyOVNlQURTTU1UeUV1QXZ6MkYzM1pL?=
 =?utf-8?B?eEhCSkZ2M3J6V0VUdWN6cnhIc1FoR2ZVclZ3c2NjUWdGWC95VStxNWFIS0p2?=
 =?utf-8?B?SnVqcytqVDU2V1pXWGs5ZWJlNHRvM2pLekwxV2hYNEJHU0k0Wm4wU2dVbkNT?=
 =?utf-8?B?OTA5RGhreVpkUDNiakRrL1FaYk04VFVLUkcxc1hmQ3lBODc2ZVNINnJlRUhL?=
 =?utf-8?B?d0VSaTg2aTQ3Q2xWc0phNC9KNitLTVhLS0piSEVnS0VzMjVCNU4vOUZZUFha?=
 =?utf-8?B?dy9mYTcwNHFYL0hENkg2ZWRrS3dZZTU2RHQvRmpuQ3V1Z05INVVQeDBnUTRP?=
 =?utf-8?B?ZUdKekpCYlU5TFpNTVEvby9NNmx2SHE2djZMaW56QzJ3RjcrczNhcDk0SXd1?=
 =?utf-8?B?ajhJS3RLNkdOL0FtZ0J3ZTBzRU05MDVsbUZoWHYrakJhRUM5bFJKYnM1Lzg4?=
 =?utf-8?B?UlozQzcwM1JwdXlsREp1SXNVWmZXaWt4Z2ZJQ0tpRlh1TTJZN1NVdi95cVlp?=
 =?utf-8?B?MVk0M0E0S0dxK3NLQlJKQ2VnNDZrMXRpQmFGV0U5cFdwSmdvVEQrKy9TbGFn?=
 =?utf-8?B?RnhzTUp6WUNwQTN2YTRFT2VpTGcvSktaaWx0KzNGQXRxRkJPNkhjRFE0aDBj?=
 =?utf-8?B?dERRYThkTGhiVmdCVjJaY2VOa3o2TDJrY24zR25CTDNnVUprY1NDVzIwODJ6?=
 =?utf-8?B?OFE4WVU2V3l2Q0RwaEZSWndsNGlzZVNManY3ODRBRUZFeDBmZjduVHJldFI4?=
 =?utf-8?B?d1dCVWFJZGNUOTZiWUxQVzU4TWxjemVDcit4M3FkODFpNllyc1VZMUZtNHRv?=
 =?utf-8?B?czZOUEozY0ZIT2xtVEhlOFBuKzhYMXluTU5FTlVhM1UzUFpTdCtQazBZeVRn?=
 =?utf-8?B?YU1wWjZQSXlCMkNycm16TTR1emJ1c3ZlMGpockJCQm1WRmR6c1dwUU1oZ2xC?=
 =?utf-8?B?MUxSWjdoMjcrWU50V01Yb1lYN0dyNXNEK2NkVTU1NXdBbVdYRFBEY0NGQkg4?=
 =?utf-8?B?UGNNM1pvVHpRK3V0cXhZS1FBLy9UTmd1NXlJWEo0Qmo4MXp5ZzRFVGdqUzdI?=
 =?utf-8?B?YUk1cVB5K3hNdjhjcjRHRk1pTnhJUHVFWStQaS9mZlFZNnZ4NlVuNk5VQXVj?=
 =?utf-8?B?dDFLV3lsUnJ4V2pEOFVWeTR5VU5DTjdRbzZqMFNLUkJsVllCMjdCMkM4akor?=
 =?utf-8?B?NzhCS0VnMHJSSXlJT1YyNVllRXRTQllySzVrZjFzUGNVd2orMzY3dHZPaVJR?=
 =?utf-8?B?N1lZQnhabFRwS08yOXBhRnkvSHVFRWFQRElrZ2RrbUdZMGY1Y2VEMGtXcWNE?=
 =?utf-8?B?d0dPdmtQaU43d21JSWUyTkd2dVVlUEZLTmdKRmxKZ0VCVUZKVXdrVUNGaUdq?=
 =?utf-8?B?OC94bDRIY0pCWkJiZ1FuWml5WEg3eEJ6Q3FMNGl3Y0E3L2RMTVpLMWtFMDlK?=
 =?utf-8?B?WVJrc3haMTVDSDBvd2YzMmhPNDFSWHpmbWFJaFZEK201c1NHdjZHb0lmaTIz?=
 =?utf-8?B?aXdxZkJqVWpPMXljSWR6WVZSU0lPSC9GV2c3eTNVczdUd3IxVUdObUNOd1Ew?=
 =?utf-8?B?ams3MzlLMDJveTFPNmhFOUNaaHFITTRTNm9XYW5yQTZEK0orOWI1ajRzWUtU?=
 =?utf-8?B?clV0RllNSHlFZW10V1ljQU1JODJvMFZ5M0tuaFhmQ1lkTklBbGVUbmhmaSta?=
 =?utf-8?B?NTBvTnNLSDk0ZXhOeUtLMHVPVldjS01Idmk2cTBQVDNhNU0vN0d6bCt6SGJu?=
 =?utf-8?B?b2l1OU5UQVVCZkxmV3ozTEk4cCtCQ0ZoNjkzMDlvZk9BSFBUazh4UndKb1ZK?=
 =?utf-8?B?WS9KdW5iM3hjU3d1RHZaTGlsTjA1N0RtZ1VzVm8wRDZYbmdsLzN4VlhXZDBn?=
 =?utf-8?B?YVVKZFRGOGdvUGs2M3Z0dG5MMG9vdGNQVDlKamMzOFZ1RSsvSnhRS3A1cEZ3?=
 =?utf-8?B?YlVudElqUWxPV1RaOVMrREdNcDAra1V3dDFId09sQ2lua2I1aG8xdUI4VEMr?=
 =?utf-8?B?ZDJNblkyckVwRkdKQTNRZXgxWE1HV2hvQnFVYzlwWnVRQTlwUW9jRXZqUmRT?=
 =?utf-8?B?NkxPcnJodUljU1FmMEpJRmFrc1ZldW1GRHdVb2h1Q2hqNU5yTWVUT3UweWhT?=
 =?utf-8?B?L29NZ3JjK0ZVeUJTYkh1aERobTRJTHFGaVN1SEh5NGFRN1NPSElQMzhrb1BP?=
 =?utf-8?B?UE5Jb3JZS2haR3UzeDdzOFBtbmYwdndLakxWcEoxQVpFRVo2TW5rQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4D69FA38FECD9A4FAEE325A3B6075468@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58e4c3c9-8956-4960-7646-08de54f18b60
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2026 11:22:33.3580
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F3adjWCiYLhpKAbkBMX0h8+SDFhIteTvWIh1zKVpU81tdoz/8meAmB9k2cvMKtJpKyL094Hfu6rwZRIHo//STw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8107
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI2LTAxLTE2IGF0IDExOjEwICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiBX
L28gdGhlIFdBUk4oKSwgdGhlIGNhbGxlciBfY2FuXyBjYWxsIHRoaXMgd3JhcHBlciAoaS5lLiwg
bm90IGEga2VybmVsDQo+IGJ1ZykgYnV0IGl0IGFsd2F5cyBnZXQgYSBTVy1kZWZpbmVkIGVycm9y
LsKgIEFnYWluLCBtYXliZSBpdCBoYXMgdmFsdWUgZm9yDQo+IHRoZSBjYXNlIHdoZXJlIHRoZSBj
YWxsZXIgd2FudHMgdG8gdXNlIHRoaXMgdG8gdGVsbCB3aGV0aGVyIERFTU9URSBpcw0KPiBhdmFp
bGFibGUuDQo+IA0KPiBXaXRoIHRoZSBXQVJOKCksIGl0J3MgYSBrZXJuZWwgYnVnIHRvIGNhbGwg
dGhlIHdyYXBwZXIsIGFuZCB0aGUgY2FsbGVyDQo+IG5lZWRzIHRvIHVzZSBvdGhlciB3YXkgKGku
ZS4sIHRkeF9zdXBwb3J0c19kZW1vdGVfbm9pbnRlcnJ1cHQoKSkgdG8gdGVsbA0KPiB3aGV0aGVy
IERFTU9URSBpcyBhdmFpbGFibGUuDQo+IA0KPiBTbyBpZiB5b3Ugd2FudCB0aGUgY2hlY2ssIHBy
b2JhYmx5IFdBUk4oKSBpcyBhIGJldHRlciBpZGVhIHNpbmNlIEkgc3VwcG9zZQ0KPiB3ZSBhbHdh
eXMgd2FudCB1c2VycyB0byB1c2UgdGR4X3N1cHBvcnRzX2RlbW90ZV9ub2ludGVycnVwdCgpIHRv
IGtub3cNCj4gd2hldGhlciBERU1PVEUgY2FuIGJlIGRvbmUsIGFuZCB0aGUgV0FSTigpIGlzIGp1
c3QgdG8gY2F0Y2ggYnVnLg0KDQpGb3Jnb3QgdG8gc2F5LCB0aGUgbmFtZSB0ZHhfc3VwcG9ydHNf
ZGVtb3RlX25vaW50ZXJydXB0KCkgc29tZWhvdyBvbmx5DQp0ZWxscyB0aGUgVERYIG1vZHVsZSAq
c3VwcG9ydHMqIG5vbi1pbnRlcnJ1cHRpYmxlIERFTU9URSwgaXQgZG9lc24ndCB0ZWxsDQp3aGV0
aGVyIFREWCBtb2R1bGUgaGFzICplbmFibGVkKiB0aGF0Lg0KDQpTbyB3aGlsZSB3ZSBrbm93IGZv
ciB0aGlzIERFTU9URSBjYXNlLCB0aGVyZSdzIG5vIG5lZWQgdG8gKmVuYWJsZSogdGhpcw0KZmVh
dHVyZSAoaS5lLiwgREVNT1RFIGlzIG5vbi1pbnRlcnJ1cHRpYmxlIHdoZW4gdGhpcyBmZWF0dXJl
IGlzIHJlcG9ydGVkDQphcyAqc3VwcG9ydGVkKiksIGZyb20ga2VybmVsJ3MgcG9pbnQgb2Ygdmll
dywgaXMgaXQgYmV0dGVyIHRvIGp1c3QgdXNlIGENCmNsZWFyZXIgbmFtZT8NCg0KRS5nLiwgdGR4
X2h1Z2VfcGFnZV9kZW1vdGVfdW5pbnRlcnJ1cHRpYmxlKCk/DQoNCkEgYm9udXMgaXMgdGhlIG5h
bWUgY29udGFpbnMgImh1Z2VfcGFnZSIgc28gaXQncyBzdXBlciBjbGVhciB3aGF0J3MgdGhlDQpk
ZW1vdGUgYWJvdXQuDQo=

