Return-Path: <kvm+bounces-52089-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AEBE7B012F7
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 07:50:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9BCB81C83079
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 05:50:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0ECD11D61BC;
	Fri, 11 Jul 2025 05:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U/TB1YzC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B80161A2547;
	Fri, 11 Jul 2025 05:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752212997; cv=fail; b=bX6w+VClJ6YwSlpFKefT7Uuqe2ZCtrWSjlMXKMVDp6yo0agQd6QCEwLHpIi506KmbBopxPaR7OASpH1pLhyPKrjRgpWO+mN4auowJfQ5hbzUuC0u7Dx9oLW0YUj8lPLafWZCFSxZAyS76raJgChBtIBQHsCvNmm99WjaUuhm0co=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752212997; c=relaxed/simple;
	bh=i0j9q14+36CoUBzrxH4dmEWLhgH055OnEx5TfenUqQU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=MD3Cr60+5glpBrrHCC5G0WCzI+MjJpHoTJbRL/VtgeO7dLEZxAULtlvnWZd2DGEdLbohDhU1cDo1kCLYHNcDtLXqlqExbbYeZg6gtihxeAEuDAmsqkJqFsnfTTo9Wvfg0PSjYfDyUw9g8mOahQOCsV9TWdG87BwERygab5gvHPI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U/TB1YzC; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752212995; x=1783748995;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=i0j9q14+36CoUBzrxH4dmEWLhgH055OnEx5TfenUqQU=;
  b=U/TB1YzC05z2nS62eLznaNv9VB+Q6v3joFTHhU8NeGbfchkVLYE1OX1o
   4ED5hxf+ZQwunS/2gi7m7fAY3cBr3GgvOz69yg0aczcuS5udon9VTKl9Y
   YDKewUCWf3HDzLZduIui5s17+0mJMfpw6+1IWyVdGy0v2meED09vttDXd
   XOAaHGt+J+XUhbzlOB2deTqVknpG4XwUL9KpPECO3Wn9VHc1TQ1E0dWTs
   ZFHP5dgl3LfXcR/CmTLxzv0rU/2gBOM5jOQJ5GWqCzAK9kAT5N5z3Wm7p
   OTbMtxiItrGcDniM6MwRyTMm87TKf6aTcAsfmPHJaINqmd5vgw9EWVdnA
   A==;
X-CSE-ConnectionGUID: N0W56wYzT5myHjtDbNDqdw==
X-CSE-MsgGUID: NKw4sPAHRsaYNZlkJ//qHg==
X-IronPort-AV: E=McAfee;i="6800,10657,11490"; a="79938688"
X-IronPort-AV: E=Sophos;i="6.16,302,1744095600"; 
   d="scan'208";a="79938688"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2025 22:49:46 -0700
X-CSE-ConnectionGUID: /Xf3jgsnR5u7MSN8U3qYfA==
X-CSE-MsgGUID: vCFFChreRbaKZ8aeRf/52Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,302,1744095600"; 
   d="scan'208";a="156408208"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2025 22:49:42 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 10 Jul 2025 22:49:41 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 10 Jul 2025 22:49:41 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.61)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 10 Jul 2025 22:49:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RaorlOV0fb7IvmEyR0QM1I8EK0pIMVfwS8WaIZRmLZ+bnqmQFALStXeZOMvTXd3naoVl9Uk//nXIPsg0rC8LTzjw1ADWIQyHYoL6BkrUf489UXNm+xV9hghO7FnciuA3/YDOAFwQilvSrkfWXf8UJmxdtyVu+gmNkxK+zZWoexwPbyTdiJN+sYvILSNeoZKSBOilOxT1JovgZE+KAnOHnMQwM+Ucb6vWD1jvi0Jc6o7w5HmXCSWkUn7oNlQjhGKikeyIMtS4Dv+qPJswYDHCgWTc6ypiKIR5bHhFABE1jwoBUDct+6R9o1kqyMALTcoc8W3VLyVpLLZ+OC/QIgUc9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bT0dnEhrLQIKhHNwchqp1eTGJco6QiM06XIu9Hwc7dE=;
 b=CXRe97opRilQVzHWvKn9d90CtNgTb20LzT1Es7UvT7OjsP+6NOUrbmmqoYA3PQAYkh2oIVNy+znSj/qsc9BDxORLFnKesyXObPShJPBh5gnzYKz4b41Gf60bwu+f0aoRruHpTdaxl/GCoEnIxXASNFFHskLyi7aED7x+ovhXwBnFUaabyfgXZTGGLOXEcF6aorz3/CY/rR3SKfl9hakePL6zzPLVtKVQdVUpWXZYQrxQHVGjEdeEAd1stDNb3k4DpUJSlOYE9qxe/4/VPeOJuy0pO8Lyrk1p9S7ocI+vgGCiRb+4Q/t7r6pe4ccUs8Aj/WhEphx/THbDQvmLaw7PWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CH0PR11MB5220.namprd11.prod.outlook.com (2603:10b6:610:e3::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8901.26; Fri, 11 Jul 2025 05:49:37 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8922.023; Fri, 11 Jul 2025
 05:49:37 +0000
Date: Fri, 11 Jul 2025 13:12:36 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "ackerleytng@google.com" <ackerleytng@google.com>, "Shutemov, Kirill"
	<kirill.shutemov@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Du, Fan"
	<fan.du@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "Li, Zhiquan1"
	<zhiquan1.li@intel.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"seanjc@google.com" <seanjc@google.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"Peng, Chao P" <chao.p.peng@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tabba@google.com" <tabba@google.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Message-ID: <aHCdRF10S0fU/EY2@yzhao56-desk>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <diqzms9pjaki.fsf@ackerleytng-ctop.c.googlers.com>
 <fe6de7e7d72d0eed6c7a8df4ebff5f79259bd008.camel@intel.com>
 <aGNrlWw1K6nkWdmg@yzhao56-desk.sh.intel.com>
 <cd806e9a190c6915cde16a6d411c32df133a265b.camel@intel.com>
 <diqzy0t74m61.fsf@ackerleytng-ctop.c.googlers.com>
 <04d3e455d07042a0ab8e244e6462d9011c914581.camel@intel.com>
 <diqz7c0q48g7.fsf@ackerleytng-ctop.c.googlers.com>
 <a9affa03c7cdc8109d0ed6b5ca30ec69269e2f34.camel@intel.com>
 <diqz1pqq5qio.fsf@ackerleytng-ctop.c.googlers.com>
 <53ea5239f8ef9d8df9af593647243c10435fd219.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53ea5239f8ef9d8df9af593647243c10435fd219.camel@intel.com>
X-ClientProxiedBy: SG2PR01CA0128.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::32) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CH0PR11MB5220:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ce40cdc-ccde-456c-a07c-08ddc03eb834
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?/5T0bhDFc9SfVhVL7Xq0qtGc3KwOH9qug/qRnFUXPseXU64LicR64L5Qak?=
 =?iso-8859-1?Q?pa6e8n3Vj/KRiXG9zfABOMY/9ij+lMnIuHKEOstPmCb4AN52tSu50vgCRb?=
 =?iso-8859-1?Q?VIJLrmqGerblpzQgtXsrqyG1ybAeLjFyb75spuixJp5tHApuQtC8j2+alu?=
 =?iso-8859-1?Q?2naZjTiOEcs09EzLY6m0F2oocPPjNKi+PhMAORgWILqFZYtJRMtU9UrxO3?=
 =?iso-8859-1?Q?BZQJXzXwgJgsJrT6Z3TE8DoeTC37Rsj8yjeJ+1trgIE60o0ZAojo1NRY1j?=
 =?iso-8859-1?Q?qTDCv1ArpIhaYSaPHdqmzkAAHOi0KoreTorzE5JduHAZ0ZKqtau+GHMGh3?=
 =?iso-8859-1?Q?XCduxw0bDMlArPSU/UNeVzWW6MSMjh4PAMB0UChejybC76kjoWA2ylJoNU?=
 =?iso-8859-1?Q?lOxZ4wfS31eNpP141parTFbBKol6Qel+mgtmWhLBPfZEKHXrp4JkV6xWMP?=
 =?iso-8859-1?Q?eHktp0gvZdW3RxwkfPzhIXD2eXs42D/1ldvGX5BNntUlq1JyDtflxwYzdH?=
 =?iso-8859-1?Q?HINYHX+Za18OYkUJiB8DUeoE4EYXmlmwuXiulpY6CIiNfq5uBw0cN3o32v?=
 =?iso-8859-1?Q?gybUqi5qRyBWsl6Qf02PONLQwZ/FOQDeKJU0hCluZBG2cUqi8amD6GvpeL?=
 =?iso-8859-1?Q?LmZQ2MUrDs6Xb20vhokm+xqx09lPxAnoD5o26lTaxsIyXz3MdgZfdUxDuq?=
 =?iso-8859-1?Q?zryGCTt4d/XLeuXg6OrSCu+YsT3Q4KjCSeYdEYxWJF+kJy2eRRVVTwmdm6?=
 =?iso-8859-1?Q?aV/NC+fuwhrodNdXFlMp3n53wcjo4puYwNQVXXydt2HjCqtGzI1azceOp+?=
 =?iso-8859-1?Q?H5o66QRvIMf8FCLCcBqn2OyuKFJPTlW+4P5hohC1HnjUwu7mpQ63zOg76t?=
 =?iso-8859-1?Q?G4jpGPDUWNtze9TAIlfAaDNpQB3b30CC7XN6CRaXrsD7yWjbRUszwOIoNq?=
 =?iso-8859-1?Q?QGAMX7z/IXEQSVQMQnZ0gLMG/HbOZqPYBsAk0XEyoQqCOyQm8SXvVlYTy0?=
 =?iso-8859-1?Q?y2WUboqvrAPA9R1zlAWdHA5Elcfd10wbZpOYH4v9zl8QpPxgYzJqnohCJ2?=
 =?iso-8859-1?Q?+1F9A9l6WIKE0CKzA9xFULZG/dmCQAYSAtFSaMiOYpq8+FAbX7/Hgh196H?=
 =?iso-8859-1?Q?jsjiVvPmXXRtP7BsamgAxHBox8ofFSKm3DINe1gf8z9egX/fCsFNTyjzK2?=
 =?iso-8859-1?Q?MMLH0Ymmg6CxPew7m57vRADTc7esPh5jQJbdYJbtHUCensM+lRyMbHIJpa?=
 =?iso-8859-1?Q?eFpvrwRW6UUsHyWPXslEJxhgBtQLPDJyxKg8uDyq4dmZu0eYpLfV3wtuAE?=
 =?iso-8859-1?Q?yYMh9oj5X5STbiTy55Rwpgn9zdGabI11ByOk8dyq7rTYSAm5djko6hUwsJ?=
 =?iso-8859-1?Q?3I3wSVJGctgEg5J1rSn/r487bHj82HXx+DaZihME/V5wV+OvTf+r6D1Q/Y?=
 =?iso-8859-1?Q?lc8rTsFl9QlinI7J60m1UAOQ2C+MngNDc850FID46y3cT9lL3JjdY+8EtE?=
 =?iso-8859-1?Q?g=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?JYfpav4ZztYkjqLlZl+/hMDB5kzCke2OgDe3INZw+ygMBW3NnDJJKe15U0?=
 =?iso-8859-1?Q?eVniAw46ZxbQ3+Vh59chaPLU7nUeCjZ1GOrFNpi8sJdRZWyZ9qpy3pQL82?=
 =?iso-8859-1?Q?uaYrlywhZU4WoTfPth+QKg2ZJMkO1PIn0H9+pAO65pT33AVKGOSFdbwkj2?=
 =?iso-8859-1?Q?dHFYI1h47Ua1ODcMtlPV/uCBI/NovxwlcoDA2AcoQvimmxlBcgqD/bCvS1?=
 =?iso-8859-1?Q?bwwanFYWIXmSNgiIB+UN28Nka7Tw1lFpuhN0h6WioHRrR1mDMIGzQg5Tvf?=
 =?iso-8859-1?Q?JnykiweGWnp8Ewvuz9+lpVY2vTm9xU2L7JkJ7FhhXGym+Ib7Kf1fAxmvid?=
 =?iso-8859-1?Q?Xpnzgv69+rlD96waeWCx+EcW/inRQP/o/ZeFOgWuPmoNL4fQVDTNRZ3qTd?=
 =?iso-8859-1?Q?wWGPyhRouJ0rjNni2CDE6X8GIm0h7jg+pPP8E78e+geUg1iZl3FWFhY5M5?=
 =?iso-8859-1?Q?lSArWczUc5oOInLc8RScn/Gw2w6mFxZcB3Rcr64JFcC+7fpUgPtfxZ30H/?=
 =?iso-8859-1?Q?HygxKMm802AG/oQIOTbTwsfPBqNqcf1ocb0QRyeZlYrwKp7RtENMfq7Fmq?=
 =?iso-8859-1?Q?AbDLAQcNpF+7yB5uVcqowC3dpX6KdzC3tcMbBqhqd7OLlPa8FCC0WF0roR?=
 =?iso-8859-1?Q?Mtkpw5lu9WLnInK379ydqAJifMEcwkwp23f64aJM6RroDqt+Ow+Pn1M2Lf?=
 =?iso-8859-1?Q?OBTSwlGp5sC9eH9u5KuHjuCXtnF/WbmGAXxh5R2emQ+6jvYyiO41tG67vM?=
 =?iso-8859-1?Q?C/mYLOVTnuMRNC+sBirriitHM3T58IA2THs6gRxKmcWLCXx0YIqVgW0xFq?=
 =?iso-8859-1?Q?9p4xM7hD66t8KCu1XGLU/Z9PLdHptHx2qfFiMmaRihU+rOwbWwb3tetHRL?=
 =?iso-8859-1?Q?cT2YAB44IBGlqnuGfJoxeRF7b2UuQBjsBeOy75Et1k3fUwxntyHB5XEdRf?=
 =?iso-8859-1?Q?amWbDLWl1gp24Sg7YZVJsmd69URPgIWJgwrsjcb4EL5FJolvZ1nRUzjdbL?=
 =?iso-8859-1?Q?ODEUmxY/0lpOPKzZOz6We9mDBBVt9oCs0J6BQFDxD3nBht2xpESjrgYfGI?=
 =?iso-8859-1?Q?d7pHYnOvR3JBgMW+NnY+2c8N4cBjv+a1TB9L7JiqXj3s9uDm4IHnY0Q9uB?=
 =?iso-8859-1?Q?A7+stgwWgtl4ZDFCVhgItFsQx601xZUlt+Wwyu5PRYH5kV9ahFY++M6sml?=
 =?iso-8859-1?Q?7RQH+ynK8vvMwFMuXDvqxvctny+Zm1Zwfj2unGkPDmDF84TJk1McG8wNpx?=
 =?iso-8859-1?Q?PzK0xtiSOMuzoBKCtIzIjz0ZRJiVtmXB+6KNqeL4oc869l43LEmvEambxy?=
 =?iso-8859-1?Q?GjRKDIwVa/Ddwlhv7GqtvvI/NHH50rYo9GpvxlMwFuTc1+gDYqqbK2dSN7?=
 =?iso-8859-1?Q?DO4o7h3rXA0iC3CMsqG584dml4bCYyh7MZJLruVm1zogkDNea88eEsL+oI?=
 =?iso-8859-1?Q?698plbLXSeuOkuq6pPuHx6PJ2v7IhbT+2XQoq2BVRznrMmngPDhvkbHx6D?=
 =?iso-8859-1?Q?Ul1MN8DpfBLl+erU9xumdI3HWrTPi71Qp1qdcDx03OhFDmxoemtUKzQfmy?=
 =?iso-8859-1?Q?KJK6pGz2yDip2jo+G/VrQ1AEg6cMjphZ8dGBZXp+fdiybKpUIjctNtUZ4v?=
 =?iso-8859-1?Q?81KUBa6Dy7zlrENOlHNsJosm0ekJ5zNQNY?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ce40cdc-ccde-456c-a07c-08ddc03eb834
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2025 05:49:37.4062
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Mv94GvKTbfzu37KXtlcIFWzcxMZ5hsmgGBp3zW3jMYIEw4gFDq/sSU9MbvhyjWqRwbmhmdlIe9nDpMN/IPP+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5220
X-OriginatorOrg: intel.com

On Fri, Jul 11, 2025 at 09:46:45AM +0800, Edgecombe, Rick P wrote:
> On Tue, 2025-07-08 at 14:19 -0700, Ackerley Tng wrote:
> > > Ok sounds good. Should we just continue the discussion there?
> > 
> > I think we're at a point where further discussion isn't really
> > useful. Kirill didn't seem worried about using HWpoison, so that's a
> > good sign. I think we can go ahead to use HWpoison for the next RFC of
> > this series and we might learn more through the process of testing it.
> > 
> > Do you prefer to just wait till the next guest_memfd call (now
> > rescheduled to 2025-07-17) before proceeding?
> 
> Ah, I missed this and joined the call. :)
> 
> At this point, I think I'm strongly in favor of not doing anything here.
> 
> Yan and I had a discussion on our internal team chat about this. I'll summarize:
> 
> Yan confirmed to me again, that there isn't a specific expected failure here. We
> are talking about bugs generating the invalidation failure, and leaving the page
> mapped. But in the case of a bug in a normal VM, a page can also be left mapped
> too.
> 
> What is different here, is we have something (a return code) to check that could
> catch some of the bugs. But this isn't the only case where a SEACMALL has a spec
> defined error that we can't handle in a no-fail code path. In those other cases,
> we handle them by making sure the error won't happen and trigger a VM_BUG_ON()
> if it does anyway. We can be consistent by just doing the same thing in this
> case. Implementing it looks like just removing the refcounting in the current
> code.
> 
> And this VM_BUG_ON() will lead to a situation almost like unmapping anyway since
> the TD can no longer be entered. With future VM shutdown work the pages will not
> be zeroed at shutdown usually either. So we should not always expect crashes if
> those pages are returned to the page allocator, even if a bug turns up.
> Additionally KVM_BUG_ON() will leave a loud warning, allowing us to fix the bug.
> 
> But Yan raised a point that might be worth doing something for this case. On the
> partial write errata platforms (a TDX specific thing), pages that are reclaimed
> need to be zeroed. So to more cleanly handle this subset of catch-able bugs we
> are focused on, we could zero the page after the KVM_BUG_ON(). But this still
> need to be weighed with how much we want to add code to address potential bugs.
> 
> 
> So on the benefit side, it is very low to me. The other side is the cost side,
> which I think is maybe actually a stronger case. We can only make TDX a special
> case too many times before we will run into upstream problems. Not to lean on
> Sean here, but he bangs this drum. If we find that we have case where we have to
> add any specialness for TDX (i.e. making it the only thing that sets the poison
> bit manually), we should look at changing the TDX arch to address it. I'm not
> sure what that looks like, but we haven't really tried too hard in that
> direction yet.
> 
> So if TDX has a limited number of "gets to be special" cards, I don't think it
> is prudent to spend it on something this much of an edge case. So our plan is to
> rely on the KVM_BUG_ON() for now. And consider TDX arch changes (currently
> unknown), for how to make the situation cleaner somehow.
> 
> Yan, is that your recollection? I guess the other points were that although TDX
I'm ok if KVM_BUG_ON() is considered loud enough to warn about the rare
potential corruption, thereby making TDX less special.

> doesn't need it today, for long term, userspace ABI around invalidations should
> support failure. But the actual gmem/kvm interface for this can be figured out
Could we elaborate what're included in userspace ABI around invalidations?

I'm a bit confused as I think the userspace ABI today supports failure already.

Currently, the unmap API between gmem and KVM does not support failure.

In the future, we hope gmem can check if KVM allows a page to be unmapped before
triggering the actual unmap. 

> later. And that external EPT specific TDP MMU code could be tweaked to make
> things work a little safer around this.

