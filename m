Return-Path: <kvm+bounces-68507-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 78101D3A90B
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 13:36:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id D15CE300533C
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 12:36:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0610435B15C;
	Mon, 19 Jan 2026 12:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iJ18MZvK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EF2C31281C;
	Mon, 19 Jan 2026 12:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768826182; cv=fail; b=KMJVkwcVSejFrMcnGvpjWg0JL25AEpyIAITbkZhk7iP7hj0dzjuTiTfza08lPLogEg09+UeO0fBi25MSvoi2rYKNypoZkdfR+v5EDIpbGOuKyXJVNNLJLfJodxpf1Z3dGAEg/yi5SYCOcZZ5hRjfHJjUb82J3PBv3TpfJSefbuM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768826182; c=relaxed/simple;
	bh=/FPwvks7lLcH7JMoW/UDba0WVyiTOc7nUpkeI15zNZk=;
	h=Date:From:To:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=fkTsNSZsDAB6MARlSRsOWJOcRtlOikNgQya1wxih5Bn/xgiU4+thmKTuTMRJ0yttjm5FbngHnlqYLHVNb1zHDLebvgAOE9BLwwjwtJxLpXppQAv2FDU/NLN0xbRJJ6F1Kv1KGMczCaKnxXrrKkB50hB3LCO8eQG0AT5JpTjJwsM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iJ18MZvK; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768826181; x=1800362181;
  h=date:from:to:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=/FPwvks7lLcH7JMoW/UDba0WVyiTOc7nUpkeI15zNZk=;
  b=iJ18MZvK+P7E2vPe5BIz1SVllk1Bm8x8lMNW54u+VBfFoNR1OpRcNom3
   UauCV3HMCyhGx9CjmcIcuzi8ReqCQ9rMATE8Yon9/wR/MCw/KQfcVfbCs
   +NpjhGtoMJs79X0MFunOiS8SlEpYpU7mbkVLu0jbxn9hwQZkqv4oswlWD
   /DmTqrwdcIokLpZsiYjz/bD14yNC96AYtphS1aQLGSm1w3MCq38XZ5Dqi
   0XidfEYU0Yg9GGksPibPmnddOVGaDjvBsKVvY3PEm3rsteCjBY2jaXDtj
   CnOV/5eo4WCuZamYtzU0oYvCvuwKR5QlMdCWCFbEsSOt1Epsq/hetlOoq
   w==;
X-CSE-ConnectionGUID: wy2m1FeMQPOE0sUwL7Wwhw==
X-CSE-MsgGUID: 40B+0pKKSfiPH8gqA+laHA==
X-IronPort-AV: E=McAfee;i="6800,10657,11675"; a="73896006"
X-IronPort-AV: E=Sophos;i="6.21,238,1763452800"; 
   d="scan'208";a="73896006"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2026 04:36:20 -0800
X-CSE-ConnectionGUID: MdsHEN1AQ1SSGHjpdeB9SQ==
X-CSE-MsgGUID: hVIy5fxRS42fdpyGfTlD5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,238,1763452800"; 
   d="scan'208";a="205475044"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2026 04:36:19 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 19 Jan 2026 04:36:19 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 19 Jan 2026 04:36:19 -0800
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.19) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 19 Jan 2026 04:36:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XwEsukilG94UO5XtETzrMXSrW1chuoWY1WH+AJ4dTMcBogh50PgW8Txw9qh88uBQwHZvizI42pMvgBcDlC0oY2qi6g3vCkUnh4+n0T8RYxxrq1EZBdvQM/ls78NLS2m0KjVTHxpqYzR+v6oe/ul4tFC/tb8hMWBd1IFJE16MWx/Yq1fb/UTE1t/TLhHL/nBGiZ3nSQVqpr2pQLw8/lDxTfDVxBgzlW63HQ8KbyuWiJupGDmgCXaA6BIIUaOrYFozPy+dD90giNXHr7xysFWQ2Bzk+H3T3pEmVkECrwCfjpSBGkMKX0LytHbbhfcOFuQw3unPY8DH1kdmKUi5Z7wBxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SwgSBYW3YfhuAFlvMKjKPDNbF8PQEiUEps47flR8Pjw=;
 b=RgL30T4IxKef50CPUZvSiE2aCQVTgsR5ENr2teWyNzClxA79sdCN0u2WdkeFrlk7fr88SzDUqZe9K2kMh4lIs8oDJTn9EEdbZN0D21rXA/ACGdNNNfHopMrwD84lXH0v/oVjD8DG+OvMyWfrVfL0V9hyXOKGVrJNUXMdn2ntZ1dFSSnS9LM0pngjBE/+rESnWq2SzE7ouKzHEd7XrSVXymVq/6OkVUDV1iVnce5eN2WlM//RVlRWPCwHUAAdOqignSIAIgH79rqFjR5nhgyRusadSKAATGft4p6GdURXS76lJ9hA19GX3OpXNebtf3V1YYOZBL9uyawcohZ3BacD2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN0PR11MB5964.namprd11.prod.outlook.com (2603:10b6:208:373::17)
 by DS0PR11MB8081.namprd11.prod.outlook.com (2603:10b6:8:15c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.12; Mon, 19 Jan
 2026 12:36:15 +0000
Received: from MN0PR11MB5964.namprd11.prod.outlook.com
 ([fe80::853c:b617:1543:8a4e]) by MN0PR11MB5964.namprd11.prod.outlook.com
 ([fe80::853c:b617:1543:8a4e%4]) with mapi id 15.20.9520.011; Mon, 19 Jan 2026
 12:36:15 +0000
Date: Mon, 19 Jan 2026 20:32:55 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>, "Du, Fan" <fan.du@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "david@kernel.org"
	<david@kernel.org>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "kas@kernel.org"
	<kas@kernel.org>, "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"Weiny, Ira" <ira.weiny@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "francescolavra.fl@gmail.com"
	<francescolavra.fl@gmail.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"sagis@google.com" <sagis@google.com>, "Gao, Chao" <chao.gao@intel.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Miao, Jun"
	<jun.miao@intel.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"jgross@suse.com" <jgross@suse.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 11/24] KVM: x86/mmu: Introduce
 kvm_split_cross_boundary_leafs()
Message-ID: <aW4kd4nCjP+9Akva@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260106101646.24809-1-yan.y.zhao@intel.com>
 <20260106102136.25108-1-yan.y.zhao@intel.com>
 <2906b4d3b789985917a063d095c4063ee6ab7b72.camel@intel.com>
 <aWrMIeCw2eaTbK5Z@google.com>
 <aW2Iwpuwoyod8eQc@yzhao56-desk.sh.intel.com>
 <3ef110f63cbbc65d6d4cbf737b26c09cb7b44e7c.camel@intel.com>
 <e69815db698474e113dec16bd33116e54cb21c2a.camel@intel.com>
 <aW4DXajAzC9nn3aJ@yzhao56-desk.sh.intel.com>
 <d9b677b4f4cbbf8a8c3dadb056077aa55feb5c30.camel@intel.com>
 <aW4QGYQ+qMytZ4Jq@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aW4QGYQ+qMytZ4Jq@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: KUZPR04CA0003.apcprd04.prod.outlook.com
 (2603:1096:d10:32::15) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR11MB5964:EE_|DS0PR11MB8081:EE_
X-MS-Office365-Filtering-Correlation-Id: 859498a1-55cd-4b9f-784a-08de57574d36
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?mFWYyAlcUzTK9ZV44l8eshxyB5W7AT4yTQXCcN1U2QdSJDCgf0ULo+1xJG?=
 =?iso-8859-1?Q?QTzu1RMqPD9rQJe8IEpjg38tGlWYW///EZ6x50x0dtRJ0Kg+ae0w53ObS8?=
 =?iso-8859-1?Q?CsPiCA3zOHSLeA8A1a2vTMKIYuvvatjJv0Dt4GLOCZC0noJEmUgLuebxsw?=
 =?iso-8859-1?Q?Yf3eLwfwYtRIDuhLY56MkzH3JMDNbgNSt/6BJDlLUnFpi+6c4/q4eZ4dbS?=
 =?iso-8859-1?Q?CM/Sfu6oJNtI62Xz9f4eWwmLrSzb7T7RZe3hemVzuZMizlGduaT5eSDgCH?=
 =?iso-8859-1?Q?t0Fc6O34HaooLgLdZtfBrPrVB5u+MPBSuKVIshZk1Jj8fnI6jsOEb9e4Df?=
 =?iso-8859-1?Q?KT69Fn8OIQcKJL9Tdp/WBd5dXSfiDEXI3MeVqvY8q/ID3StGkhgEghpodQ?=
 =?iso-8859-1?Q?fpC0wf5cZOQrJLiGOtqnWUHsYRWtNjayva60kdCCR/IMdIOnY+rHM4WC/g?=
 =?iso-8859-1?Q?o4lBvuNTY93AeUQR+RiEnzxRPJhmVaKwIp/0Dkw3KClxTIeSV4BEXnw2pt?=
 =?iso-8859-1?Q?GiAo69vgFlyiSqooZ81AchMk6+BKIfW3Zv2llq6pN+9DVDArHCeWzMUp3R?=
 =?iso-8859-1?Q?emiCmj/E8GvhnGr6x2pzRy7T7nNCxl7IOXZHf01siDqAtYPFYj8Uv+nR//?=
 =?iso-8859-1?Q?6plXF/gSnh9JOyp5C3/InEUdeoLf6E0Og2JIibqVs1CBjJKi5LnuTtKWOX?=
 =?iso-8859-1?Q?SHQzTBGzQPUv6HnAAjnl8z6ZbHf7HQdGOMxVKTdgq4Z5ZmfbFL28a8Wfw+?=
 =?iso-8859-1?Q?zLkZqFjVk35hJpTZoG6R5wyOZJzK9l0d2sMEElRpkGl2Ll5wFbAC6LRk2N?=
 =?iso-8859-1?Q?/W3wJ085U6RBXxgvnG3R2MGdR0Ah0GRkBFsGFFeF4QjJXDF1bV8O6E1QVw?=
 =?iso-8859-1?Q?zt7nD91KKH+kzjXHmTD2RO2kcDMMnDeCel79graFYhavq9Iv+rPEesSxam?=
 =?iso-8859-1?Q?60xgBUhH2EdO+NCBBBau0Aot9HdGSSGO7TozdudXPEltmmRJxqflKyBNai?=
 =?iso-8859-1?Q?IJEIpSJh5zuRXSDy9HCsf7lVHfUubu+rVatNP9u1MCW02KaszDlV/AmZiL?=
 =?iso-8859-1?Q?li6hHkbjYH4Lz5pXP6eHAK6kynckfBjpVPs/OVuHzYslHY3oHU0NCvywEJ?=
 =?iso-8859-1?Q?7xY5c3BpoyccXtgs8HQ4a3/vWXxErwxEtFKx0XtpecyI2FXA3LEMF5bm37?=
 =?iso-8859-1?Q?YTAJpc7Ulz5kUsxdxF9eTyQkl58AjyVTVtpN+M5tgBHC/7+JCTzNCs4HKS?=
 =?iso-8859-1?Q?uD+p+pTHpjP3w3wEmRGtvZ4cpj7y8IPsGZRgd2q+91fLkanRIcb8BhYLU3?=
 =?iso-8859-1?Q?nX0jXM/gTFZwI4z+tFziwMxACb65Qn8/snIqU+oWxZS/7JFObglApgwrb7?=
 =?iso-8859-1?Q?zfB/zTUA+LwymcM8gZoYaG5zp5FD1Ggq8cm1OM06BYUi/UkTwi4baOT/s9?=
 =?iso-8859-1?Q?mC6I2gFie8r7bBJhMLipBl5Hj3cta7/mEO932MB0v5AkFanEhEn9NCK/Wb?=
 =?iso-8859-1?Q?f7DJWjCT3KrpE+irI864m/Tlbe2DRXHEPPZGdu7F8CKdkwptiT3xfPp4N9?=
 =?iso-8859-1?Q?duftHT89ZfwCPsmPKCpHP6t/kreOm3NUgucLav6qSbOdHOW/IF05/uKo0o?=
 =?iso-8859-1?Q?Iea2HK/SybSLvQuhkpr0MSVyv39EjW5klzF28Mr5x86o5jNqSu7xIOfxyg?=
 =?iso-8859-1?Q?kv4PiX2WzII+zHmyUvw=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5964.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?myyPkxML1Jqiju8EeknSFFSGuj7kK1E1RvyQZ3CLrH/si+ojPGQiQyJ97e?=
 =?iso-8859-1?Q?NgXPiq4WigFTTvHVqWxjQKlEIlK7uyrQTENXVP6FsJEgcfHEObMkk9ZqPn?=
 =?iso-8859-1?Q?ZhWxDsKrR29JeALa4MV+Lq0RokKUB+FHbIc2tW2tkrnvnRlADDrX6VglYA?=
 =?iso-8859-1?Q?KSQCcGfWDRC3N+As0DdrHo+cIDReNs7jv/auTbO7jpnyh48XUgbH5YYRCT?=
 =?iso-8859-1?Q?VmEBKyrredegW4q6iXYj68OTABwDu3a1eii5xrw69e4PUrJ3OIfBN5XgxN?=
 =?iso-8859-1?Q?Ckh2fA2hJAM85UkGN/YBXH9k4PkgkjKYrv3TEHTao8m/nbgfneIRujnCYr?=
 =?iso-8859-1?Q?iF3cIHGAyTLa7TLjX6pGN9vpXAhM5Vs97B5FOpm+xaAgmMrKD3I4FvZPjJ?=
 =?iso-8859-1?Q?QJoqp4BPVs93bmHep9Y8ETnOEsy920/FArrlhJy5KNnmV68ZPMeebY2LiX?=
 =?iso-8859-1?Q?gXKk7gxXHAo1E78d5Seh1sFJokd64vYU5fhlKZDYB8My1X+La8UkLRSVC7?=
 =?iso-8859-1?Q?nBIcq9WEGDNf52Kdr+uKK/Xcuo9GB7cCRRcGnoHlIR/Z14/BU+2Y9MX5OP?=
 =?iso-8859-1?Q?Uq+wtX8aIa+uo4mkkDPxxhEFw7Sqahb2CFFsGcBChnqjyTw0WpMNuyh+cf?=
 =?iso-8859-1?Q?xUTZPsQ5upkuzIgsBryKQcZp/lN+QBQ8uzHUrY9s6ZDT42vQTGGT041RGZ?=
 =?iso-8859-1?Q?Avzk8h2tHsuE17YXtI/Wt8WMJ1itYqBbf/2rtRZh89cydvs3tL+cFAdtGj?=
 =?iso-8859-1?Q?t2IHc4Vwu7MA36SEbaN2gcywIkvFt50xIDQBMNtGIwnHEcTzrREpvdTlE1?=
 =?iso-8859-1?Q?V4zPRuft8onqxwQQmblxsnJMTbi1+OquUNdHpJroslyj/Xt88M3QWiXClS?=
 =?iso-8859-1?Q?33NhOCl9vv4tISOooV3XabPZsWE5iV0JkVZq3RWWm2i0hm+luONBrnAkmh?=
 =?iso-8859-1?Q?AEgbqRZFUZUIs2JejGOHNM9CA6lbb80QJ2GkWE8LgMrcNEKjBL5XGLTC9w?=
 =?iso-8859-1?Q?I6rY2NtfU+MEdLTHklDFoow0vzi0jpwJZ3YArg+j+6g1Fwv7EE+JC1kcSs?=
 =?iso-8859-1?Q?UxCXgBkviNGYVEKJUEGTN7LoQKKbgCWKOwFgqvqUrLbsakLersMFrA2rUe?=
 =?iso-8859-1?Q?9hB930OsM3mu7+aAdIYh0REtu/QdY1SVeWZE+Vg3lRCgB6UGH6QEjfKf9T?=
 =?iso-8859-1?Q?sove7gfwmKp+LkLRFJTZIDhz40GCmUkIpDONSroY9ltUeko5v6yb97advn?=
 =?iso-8859-1?Q?bjT0BgVIsA28lKgVNEJUo3rF9Rkp9v2xlUgU2aIE0Lh5W2cVzlDgGDa2Tw?=
 =?iso-8859-1?Q?pHhLxoIlLNqXk80OFWf6b4DY+BflI71IvaihRR+0FRBGjt3u7dkkgPz7Yv?=
 =?iso-8859-1?Q?EoWgbW0EfqcFGNEHdP8rL6rW5VpAdhWR+Blg+dY6ftcPGNbXFZy2x94V+O?=
 =?iso-8859-1?Q?HgYPA/wYovKV2J0qSNTakSn8TdQyycadMvHZG9G1ghL2OLApAWQsi3pPRz?=
 =?iso-8859-1?Q?YpyfgiSvDewn7HWbVchPxYXyXvpkveQPXiL5AiZzZJU1Ttp7ZkI20XMgqI?=
 =?iso-8859-1?Q?7GqxF5xshGWNWebn0snEkYJOYC76Ig6g8RglHqld0V3mzcJhLWQuLT5IpI?=
 =?iso-8859-1?Q?5RI9QBDMB5fhq45oVPv+GELr+AsVOO7mRukS7V7OltTQFTeiVEMIJ4MboZ?=
 =?iso-8859-1?Q?3HureHL/ragAGKwDLJpsXzNrkpSwdKzurjrBVMpJ+mknH5unpnRqUzlVOd?=
 =?iso-8859-1?Q?bwxk2Y3/11ivsfRz/nqB6Nw3fELPg8RNXQVRYFhUiGUrHQMHtAufYVxNZy?=
 =?iso-8859-1?Q?/H+snZkOeg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 859498a1-55cd-4b9f-784a-08de57574d36
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2026 12:36:15.1998
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dy66YMmFEbM/mdDKQsq5qcSQM77nq5ggtq2xENsF91yeqQ5+LWK7+nuQUmn4RZfvlFiGN+87EqPPLPMoeQo9/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8081
X-OriginatorOrg: intel.com

On Mon, Jan 19, 2026 at 07:06:01PM +0800, Yan Zhao wrote:
> On Mon, Jan 19, 2026 at 06:40:50PM +0800, Huang, Kai wrote:
> > On Mon, 2026-01-19 at 18:11 +0800, Yan Zhao wrote:
> > > On Mon, Jan 19, 2026 at 04:49:58PM +0800, Huang, Kai wrote:
> > > > On Mon, 2026-01-19 at 08:35 +0000, Huang, Kai wrote:
> > > > > On Mon, 2026-01-19 at 09:28 +0800, Zhao, Yan Y wrote:
> > > > > > > I find the "cross_boundary" termininology extremely confusing.  I also dislike
> > > > > > > the concept itself, in the sense that it shoves a weird, specific concept into
> > > > > > > the guts of the TDP MMU.
> > > > > > > The other wart is that it's inefficient when punching a large hole.  E.g. say
> > > > > > > there's a 16TiB guest_memfd instance (no idea if that's even possible), and then
> > > > > > > userpace punches a 12TiB hole.  Walking all ~12TiB just to _maybe_ split the head
> > > > > > > and tail pages is asinine.
> > > > > > That's a reasonable concern. I actually thought about it.
> > > > > > My consideration was as follows:
> > > > > > Currently, we don't have such large areas. Usually, the conversion ranges are
> > > > > > less than 1GB. Though the initial conversion which converts all memory from
> > > > > > private to shared may be wide, there are usually no mappings at that stage. So,
> > > > > > the traversal should be very fast (since the traversal doesn't even need to go
> > > > > > down to the 2MB/1GB level).
> > > > > > 
> > > > > > If the caller of kvm_split_cross_boundary_leafs() finds it needs to convert a
> > > > > > very large range at runtime, it can optimize by invoking the API twice:
> > > > > > once for range [start, ALIGN(start, 1GB)), and
> > > > > > once for range [ALIGN_DOWN(end, 1GB), end).
> > > > > > 
> > > > > > I can also implement this optimization within kvm_split_cross_boundary_leafs()
> > > > > > by checking the range size if you think that would be better.
> > > > > 
> > > > > I am not sure why do we even need kvm_split_cross_boundary_leafs(), if you
> > > > > want to do optimization.
> > > > > 
> > > > > I think I've raised this in v2, and asked why not just letting the caller
> > > > > to figure out the ranges to split for a given range (see at the end of
> > > > > [*]), because the "cross boundary" can only happen at the beginning and
> > > > > end of the given range, if possible.
> > > Hmm, the caller can only figure out when splitting is NOT necessary, e.g., if
> > > start is 1GB-aligned, then there's no need to split for start. However, if start
> > > is not 1GB/2MB-aligned, the caller has no idea if there's a 2MB mapping covering
> > > start - 1 and start.
> > 
> > Why does the caller need to know?
> > 
> > Let's only talk about 'start' for simplicity:
> > 
> > - If start is 1G aligned, then no split is needed.
> > 
> > - If start is not 1G-aligned but 2M-aligned, you split the range:
> > 
> >    [ALIGN_DOWN(start, 1G), ALIGN(start, 1G)) to 2M level.
> > 
> > - If start is 4K-aligned only, you firstly split
> > 
> >    [ALIGN_DOWN(start, 1G), ALIGN(start, 1G))
> > 
> >   to 2M level, then you split
> > 
> >    [ALIGN_DOWN(start, 2M), ALIGN(start, 2M))
> > 
> >   to 4K level.
> > 
> > Similar handling to 'end'.  An additional thing is if one to-be-split-
> > range calculated from 'start' overlaps one calculated from 'end', the
> > split is only needed once. 
> > 
> > Wouldn't this work?
> It can work. But I don't think the calculations are necessary if the length
> of [start, end) is less than 1G or 2MB.
> 
> e.g., if both start and end are just 4KB-aligned, of a length 8KB, the current
> implementation can invoke a single tdp_mmu_split_huge_pages_root() to split
> a 1GB mapping to 4KB directly. Why bother splitting twice for start or end?
I think I get your point now.
It's a good idea if introducing only_cross_boundary is undesirable.

So, the remaining question (as I asked at the bottom of [1]) is whether we could
create a specific function for this split use case, rather than reusing
tdp_mmu_split_huge_pages_root() which allocates pages outside of mmu_lock. This
way, we don't need to introduce a spinlock to protect the page enqueuing/
dequeueing of the per-VM external cache (see prealloc_split_cache_lock in patch
20 [2]).

Then we would disallow mirror_root for tdp_mmu_split_huge_pages_root(), which is
currently called for dirty page tracking in upstream code. Would this be
acceptable for TDX migration?


[1] https://lore.kernel.org/all/aW2Iwpuwoyod8eQc@yzhao56-desk.sh.intel.com/
[2] https://lore.kernel.org/all/20260106102345.25261-1-yan.y.zhao@intel.com/
> > > (for non-TDX cases, if start is not 1GB-aligned and is just 2MB-aligned,
> > > invoking tdp_mmu_split_huge_pages_root() is still necessary because there may
> > > exist a 1GB mapping covering start -1 and start).
> > > 
> > > In my reply to [*], I didn't want to do the calculation because I didn't see
> > > much overhead from always invoking tdp_mmu_split_huge_pages_root().
> > > But the scenario Sean pointed out is different. When both start and end are not
> > > 2MB-aligned, if [start, end) covers a huge range, we can still pre-calculate to
> > > reduce the iterations in tdp_mmu_split_huge_pages_root().
> > 
> > I don't see much difference.  Maybe I am missing something.
> The difference is the length of the range.
> For lengths < 1GB, always invoking tdp_mmu_split_huge_pages_root() without any
> calculation is simpler and more efficient.
> 
> > > 
> > > Opportunistically, optimization to skip splits for 1GB-aligned start or end is
> > > possible :)
> > 
> > If this makes code easier to review/maintain then sure.
> > 
> > As long as the solution is easy to review (i.e., not too complicated to
> > understand/maintain) then I am fine with whatever Sean/you prefer.
> > 
> > However the 'cross_boundary_only' thing was indeed a bit odd to me when I
> > firstly saw this :-)

