Return-Path: <kvm+bounces-70297-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4KoCGAUuhGkA0gMAu9opvQ
	(envelope-from <kvm+bounces-70297-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 06:43:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B8786EEC87
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 06:43:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 88BE73017243
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 05:42:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5264E3246F4;
	Thu,  5 Feb 2026 05:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NE+16FQL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4BF6322B81;
	Thu,  5 Feb 2026 05:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770270168; cv=fail; b=Hb8XKzWky7xKcN3kOoyT51MczjB0R5jTcLQRBwH+AaGFMesVwEscWZqLSdHeLPtPLFjylVmfGPGa8Qx0lQdr5xyNDp/NGx5vHTcn3KyFw6AWLFdcdty1/TePcQfNff1G1PICGEWU5aelwwNCvprNhHIuANufcf4p/h86NnEBjL8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770270168; c=relaxed/simple;
	bh=hoScQBrHY1y40HYskxYyaZb10vkm8OBq2N0BI6nQ8CM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Jt4n/cjnrzhl7RTx5CvdWVsGTRQkO48ZGMBKGjxmEyzqcvkvTyxa5ZTQCMJ2XoggfcYTrQXdpv0yJUscA4469Vte37JbXyFJcuAP57/EatcQ/1ZuCsKrLLkCA/87dF8+SfhPopc63LIZ18HDX0fVYQ17yIE69YAvnRtSJ68fh7k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NE+16FQL; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770270168; x=1801806168;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=hoScQBrHY1y40HYskxYyaZb10vkm8OBq2N0BI6nQ8CM=;
  b=NE+16FQLLMNuO8Cc3Fw/5DoztBX8rGUsMAQLmZNXSACTR6Zm+b4SHcKc
   zBRYJU6bz9dHF3PLiHftwjnzm/wGGiVOWLqzxjyPGLlNe7SbmVquwJnVb
   0tJXxlL3OpVn89bv7CWo1xEj3Q23g8es4+hsuXANm1hvTDkXfafEt11bz
   OOvfyPvHZyBbi+mmQ+P6vZH3LR08IOlI2fV4r1WNgDNeMVQRtuY/Ym6qK
   dv9NJjutAN5jxif6p9aBhj8ucDst/KFe7RXv21Na6N1uKAFieduaNKFJ9
   c6MHLdSjY6lTST3akH8K30JDxr8tlC4A8zvVjb7o+MDng25exev/pTIjq
   Q==;
X-CSE-ConnectionGUID: cV57ZAh0TzyDEOhSdMOFlg==
X-CSE-MsgGUID: uW9z0B6bQR2ynElahTIAmQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11691"; a="75315631"
X-IronPort-AV: E=Sophos;i="6.21,274,1763452800"; 
   d="scan'208";a="75315631"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2026 21:42:47 -0800
X-CSE-ConnectionGUID: vl+mLQgMQICDhMVYm41xSQ==
X-CSE-MsgGUID: Gz2FxZCFRdeYG1KjQBlRUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,274,1763452800"; 
   d="scan'208";a="214891934"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2026 21:42:47 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 4 Feb 2026 21:42:46 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 4 Feb 2026 21:42:46 -0800
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.49) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 4 Feb 2026 21:42:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qPgv1TsV9XT0xvXRggOItE233U3KBiFOdfb2nnyPDpkzzYzm4PoH4fPrghrc7UoRA2A/rVpGzkWmSq0IncO3Wq41fDwsBPnKgllkj2hJtUIAOTlLA9QkQA1Q5dxyplSK5+Yxfd3dESQWoYbVXGiKbJcg2aD5PCgi8QdhB0+3bmQj0koXYhyL/B0LeiLeNx+AgQVFTw09FKrp6pCch5kFlkrPpLRUjUzKTCVEYodCy4YE3DpK0rObmlaNd4XblR5zfEl+suHbHYwd8N/2iQPcDjhNSpv/yOavQJdw2L8GR2Jtu/q4f7VTExR0hTE11wMyoMUhFq80WCVuB83lp5GTXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JhSDdW3tXkAgpcMcY3AG3I1zA2idUsodjLOWR0P3lzU=;
 b=Isf5ISHn+QNctf2CIoBzx+JvRDwu//nxaRhZoFfFeep9m2vgHB/q8yQ3nTB2VIF7l7S/1hRS/UtP1poqYxWEDgUfJxaaSwmAiCbkt2rO9KsrqZcdXZL4dgGDlyKI7FcJSRsnpgG5sjRpC7VWk5smge2Baxx8k/XcUoCCTpi3FvSTBuIvXoEp3HE1YxKbB6nwikipDCwvr+Co/5hukR3KMrWvdliigqJkD2zR9m6LVGzujOA73f7vwofA99kTHms2GkDhrUqjaoTv8gK8DGQQn08yRr7aA8AMNdQo3kY60AX+ioA2G8YwhecpoG3zhl2P/nt6D6IVKjTPl+UGY0Q43Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SN7PR11MB7512.namprd11.prod.outlook.com (2603:10b6:806:345::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.12; Thu, 5 Feb 2026 05:42:37 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9587.010; Thu, 5 Feb 2026
 05:42:37 +0000
Date: Thu, 5 Feb 2026 13:39:44 +0800
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
Subject: Re: [RFC PATCH v5 08/45] KVM: x86/mmu: Propagate mirror SPTE removal
 to S-EPT in handle_changed_spte()
Message-ID: <aYQtIK/Lq5T3ad6V@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260129011517.3545883-1-seanjc@google.com>
 <20260129011517.3545883-9-seanjc@google.com>
 <aYMMHVvwDjZ7Lz9l@yzhao56-desk.sh.intel.com>
 <aYP_Ko3FGRriGXWR@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aYP_Ko3FGRriGXWR@google.com>
X-ClientProxiedBy: KU3P306CA0002.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:15::20) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SN7PR11MB7512:EE_
X-MS-Office365-Filtering-Correlation-Id: ed5a588c-284a-4c5d-819d-08de64795eaa
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?7nEErM8wVvew2GGcCu6qP4ZZZp1ntTDKkPq8kK1B130uXXAyIzl7IYP01MyZ?=
 =?us-ascii?Q?jvX85p8ez0lT4qZu4gs1U3exyrj1Ekv/LExagnKa4ZVK4UG/58q7hRShxekb?=
 =?us-ascii?Q?GTTKp5RPT1VXMFZ2PkYrpUGI8WYksm5UcTH12r2mVaed5jtu+LZ3+HDyMQd6?=
 =?us-ascii?Q?0bTDTLaUHkwdX8z/p9wXAh6An4cNGY4+XsBQGwT0nCTWljIINKt8k4qoT34v?=
 =?us-ascii?Q?ukPM/RiOxDa8L7eFXQLKGlLLOYRmw7+PoCBFH+vEvicOXvdVhK5YrsO7nqwk?=
 =?us-ascii?Q?sfxoWoCs1rsHZbzRz2cp8JysziJ8w9pakgbTC+BI3qyBmCMIm/Pt7m70NjAM?=
 =?us-ascii?Q?d2Zc9vDUQjSnMFrZajpDEI2lYi9kPdYQPEVUUYn0kkrbT/DPFSXKvej6A+KH?=
 =?us-ascii?Q?Ah1GDlp/EyS3oTEjM6PGIV4cRqM7LJnwjgdcRU5DsphsqFD6x3HFa+/HbMm9?=
 =?us-ascii?Q?tJ2HwLBeL+2nRnlQN133A4U2Wo54USH3KKjN3FBt5euEJucdFiaV4QSWMq4s?=
 =?us-ascii?Q?OS11y2fPlLXdKs6v6O6ptLSYtQXrMo4syWfIZFTmgkzWXK19iWNKQXhdozMk?=
 =?us-ascii?Q?UVN4O6Oqcvk0rSvlq2T2IGHnQ5q+DFGGZ4LS5cwb5UgmyjhUW1MSjTMkfU96?=
 =?us-ascii?Q?1AARJft6aSlzebkbRgTW8MBwturoESemtxWiHZmQu3DSDj5U/gxE2QEf+lPr?=
 =?us-ascii?Q?KFizJUWq/67L6pb2VFR0zUR3Gvhbio422NdyQmyEunkV4E+pmKc7t5DXSNMB?=
 =?us-ascii?Q?jMkCbVjkz7HWrqr/+K1Hi6RsE4xKfkQiDMTMVpE7etbjXJO6i9PXYz5rFvdz?=
 =?us-ascii?Q?p5bVvRF8HL5rnfIAUpdFm/ef91nAjgQ57RAjYzwIp+gQ1+87bBgyJmPsQ6ll?=
 =?us-ascii?Q?D1RknMxhkUVaGRBt0+ukLPkuoQT2jVIDhTwvfGNswok/5CU2JXXCLEjjg6lV?=
 =?us-ascii?Q?nkfjfBigVwOeEFrmfxxHb6e6kJGupRZH9GaevGqwVStChKKw9EpInW0RzqL2?=
 =?us-ascii?Q?vLMYlXMrSM+uGZyXxmkgBDLkD//6DnOTv+Nkb7jonmalH01mH1vahb4LzBKW?=
 =?us-ascii?Q?wuwQ+kD4QJK4bsPbS2QIBEZBQK0u1Fk+/XFj52BsYH9WS202f/n4htciWLRZ?=
 =?us-ascii?Q?lgcbHw34eW/FJET9a92CPYRDvYaYIR4xX61sNxd6Wh9lmG7s4I5lwxXIoNly?=
 =?us-ascii?Q?L/mPGkSHSmkKmaDKg9oR9MRXbkY6Mpr4RhBPVl1qTtdtMj99fFkGGirhe2+7?=
 =?us-ascii?Q?ezyvhsY4tubLXxWvquJvSjnMRF1SuIkc5NZVnx3KPj0evvTyGW5Ka6mZuGG5?=
 =?us-ascii?Q?GmL9HUM9dfNMrfFXK89ehYkarNnoj1yfO1vAS5ksWi5z+HkUZCTGhuTWL8w2?=
 =?us-ascii?Q?cD09r952oEuk960uIEtRbufEm/sIyzRRiC0e7e0cDycO5zvWPsaV7ePKMY5E?=
 =?us-ascii?Q?jbAzE51xgOgOaSCjmZpUUZFXRAx+8WICu+nUU2YoPWvqND01HQtEbfWW15Ln?=
 =?us-ascii?Q?QjZgC85ZKgy3M1YtyIxCXUUyCMtb6YpxbnZSipKtHetCmEgVVobl3BaFaz2I?=
 =?us-ascii?Q?xx9EEbEHG2vfN7plTkI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FhRuM5j5hN6r8qvim29mAaJoyT53tZPtZfd0d2ZmLTL8sLPgaN7ZPKt/XBdt?=
 =?us-ascii?Q?NMjilJ50rKe1L5AM3GuRIwaW/07QY8GHmm6mzrnpI7SP9TVYWjgobIx9ZiQj?=
 =?us-ascii?Q?xr9hD4S7llTkL14b2T+3pRrEcS+57Cwd51rJVwwkAMhXYY93RkrEkKMI2huC?=
 =?us-ascii?Q?45Jn2hM4wusPo7ynKFbLB4pHwBjUFkl0Pl5zURg0dhK69eaSfvxJ4wbtCo87?=
 =?us-ascii?Q?SWY4VtFsCE4zoxegMv8fRHBS719cqLw8GknVEXueCQ+Jtimf2YYR5Xt1C0Bh?=
 =?us-ascii?Q?KLPobEsxmX2S/3uhut46g1DISek7LiDoXEhgDPws0rmeBY69OiVjJ2gmH2C/?=
 =?us-ascii?Q?zJqZ6ufhxX8cmiXcVWFfMMmVRcJpLOtoCI2HGK1BwRA3QTnkHhtjDhfsdtkd?=
 =?us-ascii?Q?9ll941eMfQHTWNmxk+IIm7DPUhsS8+LNfjwe8gLd6/aBnajocJw/g+oSdERc?=
 =?us-ascii?Q?40JQ8girBQ+Y2/H0JK2q/F8rs+6LAaaC1K+vZ+j2TcXRfIBZ74FgtS22lKpD?=
 =?us-ascii?Q?hFn92y8Z5GoFO/AOMIq0bQCDpHnsJLAVd4nh8IMQCaMujw5wxQXA8Xbl5a9s?=
 =?us-ascii?Q?wk+36od3sXsEnj6+qbYkVCwpSY5QfHF1YLvwYuOwA8Lk5Nq6SlABBMeV/kT1?=
 =?us-ascii?Q?aURYYJb8hdMvtpsBQ08Qf5Q7l0siJ/72omb4TQ5r4K1YXiFK8yDudNEYAPRu?=
 =?us-ascii?Q?BvV7GNiOH2ICJPddde68O6i/9Zly128or1I72AHA0/1KdW3lecjz4FWWHizA?=
 =?us-ascii?Q?86J9j5UjwHXMeC7XWj3yn3rZMAEKZTUww5r9XycIj4h33WseN1vyeAF0Iv/k?=
 =?us-ascii?Q?brP9GNKXy8zY1wNKc1SU2W0qkQhZggCeq3kp20zqYdi+//OWkCh2+LYz4rwX?=
 =?us-ascii?Q?x91gGcuxXTXaDp5b/I+TM6p/oSsu5Xa4LtOExrZzAPo/CJqerJA45ZZAvsbB?=
 =?us-ascii?Q?UTve2DJoxMNbIB/WmOJGlDZhlw+xDUymdk1Sh8vt5SjjEmQd9idLMzFLgPBm?=
 =?us-ascii?Q?tg8TPPCyPvYJdeh/W5dHHmrBeFUI+ukPgKvKIg2+xTPk7aDvkZXiW0DLoWHa?=
 =?us-ascii?Q?YlhQl4EvnBckH+r9KmHv5NXR2Rp9l3RXs0Y7MeGM4Hj3kvy1EKOeqJeyHXUs?=
 =?us-ascii?Q?/foibvBsoDROsfpR2YSZjahaUonMDKNXNAS4L+9PVIhJ/PeudcPUHn9YeqJn?=
 =?us-ascii?Q?ERhPH+ADiCYoe4HSDe+cmnX+jieJJmpIaFYSFLo4s5oNLFsQX4TiinsIyWPI?=
 =?us-ascii?Q?uEof/Ua0meq9vBqCcD6fF4VU9tT1IK1hNVHrCgeq1H5MZcOn6Pg380CZf2wi?=
 =?us-ascii?Q?4o03Zie/6RvoEVR5fjteHYNdl+z3Gs8u9TzaG+tP0Ws/MxEJbhyOwuQAwzV+?=
 =?us-ascii?Q?oYF0XQwstYuVyM5iZNULVJRCyzqdN7StfmjotMymhANT2giA27XwI4Tkm8Cy?=
 =?us-ascii?Q?RZZXHvV5jhbkxSrO2m687eSXB1+LVMveRf/CfUyD0+/gofCvxwx4s3KrPhjV?=
 =?us-ascii?Q?UdJJRo/zrPgr9dkcvMwHmKz09b5pQ9pQOhPTTFlMPkOy4lHrkq3/JduKpwOf?=
 =?us-ascii?Q?CiupcrAJebNlz4bG7MZTV+f240q20ajYeDcSLTKhy1TZfG6jV6aFyJ9SgUWy?=
 =?us-ascii?Q?URM5NtLALVwTheYatu6UUtnJ0SOPekIwCvNOdnDF/EY3LbrnK7m9EQOfq5yv?=
 =?us-ascii?Q?5gQMmAVbaGKhzCem2N4Hz+zA78KtegGH3709/eGBI7UVggIZcw7Qf67CxTnt?=
 =?us-ascii?Q?SGLVI6V4vw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ed5a588c-284a-4c5d-819d-08de64795eaa
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2026 05:42:37.6753
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q3Q/f8QQSMHTZmsfqHNkKBDx099++gMMaxjJLu8S6L5JflyhtApyK+NgKQa8bhD7d1WVUVqeo0gCUS66IVwUeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7512
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
	TAGGED_FROM(0.00)[bounces-70297-lists,kvm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:replyto,intel.com:dkim];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: B8786EEC87
X-Rspamd-Action: no action

On Wed, Feb 04, 2026 at 06:23:38PM -0800, Sean Christopherson wrote:
> On Wed, Feb 04, 2026, Yan Zhao wrote:
> > On Wed, Jan 28, 2026 at 05:14:40PM -0800, Sean Christopherson wrote:
> > > @@ -590,10 +566,21 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
> > >  	 * the paging structure.  Note the WARN on the PFN changing without the
> > >  	 * SPTE being converted to a hugepage (leaf) or being zapped.  Shadow
> > >  	 * pages are kernel allocations and should never be migrated.
> > > +	 *
> > > +	 * When removing leaf entries from a mirror, immediately propagate the
> > > +	 * changes to the external page tables.  Note, non-leaf mirror entries
> > > +	 * are handled by handle_removed_pt(), as TDX requires that all leaf
> > > +	 * entries are removed before the owning page table.  Note #2, writes
> > > +	 * to make mirror PTEs shadow-present are propagated to external page
> > > +	 * tables by __tdp_mmu_set_spte_atomic(), as KVM needs to ensure the
> > > +	 * external page table was successfully updated before marking the
> > > +	 * mirror SPTE present.
> > >  	 */
> > >  	if (was_present && !was_leaf &&
> > >  	    (is_leaf || !is_present || WARN_ON_ONCE(pfn_changed)))
> > >  		handle_removed_pt(kvm, spte_to_child_pt(old_spte, level), shared);
> > > +	else if (was_leaf && is_mirror_sptep(sptep) && !is_leaf)
> > Should we check !is_present instead of !is_leaf?
> > e.g. a transition from a present leaf entry to a present non-leaf entry could
> > also trigger this if case.
> 
> No, the !is_leaf check is very intentional.  At this point in the series, S-EPT
> doesn't support hugepages.  If KVM manages to install a leaf SPTE and replaces
> that SPTE with a non-leaf SPTE, then we absolutely want the KVM_BUG_ON() in
> tdx_sept_remove_private_spte() to fire:
> 
> 	/* TODO: handle large pages. */
> 	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
> 		return -EIO;
But the op is named remove_external_spte().
And the check of "level != PG_LEVEL_4K" is for removing large leaf entries.
Relying on this check is tricky and confusing.

> And then later on, when S-EPT gains support for hugepages, "KVM: TDX: Add core
> support for splitting/demoting 2MiB S-EPT to 4KiB" doesn't need to touch code
> outside of arch/x86/kvm/vmx/tdx.c, because everything has already been plumbed
> in.
I haven't looked at the later patches for huge pages, but plumbing here directly
for splitting does not look right when it's invoked under shared mmu_lock.
See the comment below.
 
> > Besides, need "KVM_BUG_ON(shared, kvm)" in this case.
> 
> Eh, we have lockdep_assert_held_write() in the S-EPT paths that require mmu_lock
> to be held for write.  I don't think a KVM_BUG_ON() here would add meaningful
> value.
Hmm, I think KVM_BUG_ON(shared, kvm) is still useful.
If KVM invokes remove_external_spte() under shared mmu_lock, it needs to freeze
the entry first, similar to the sequence in __tdp_mmu_set_spte_atomic().

i.e., invoking external x86 ops in handle_changed_spte() for mirror roots should
be !shared only.

Relying on the TDX code's lockdep_assert_held_write() for warning seems less
clear than having an explicit check here.




