Return-Path: <kvm+bounces-56721-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 85ACDB43012
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 04:54:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1B4301B25DE7
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 02:54:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FFE51FE44B;
	Thu,  4 Sep 2025 02:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IuE3ETYv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1139078F51;
	Thu,  4 Sep 2025 02:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756954459; cv=fail; b=ICOLDHlLm7/1EL7xiZ7hTX55nNmUSsQnjefr6Tiiv4X1bXI8347TVAhu3fBdwyyyY38LSa6uGcmEYd8fcRxc33raVEFAOPVQ6mxpLyCyiaj9ULqAP27J1bGdIkZXkmLInVyVsfh75D/awtUd6n8oI2WMeehmgnqq6q6UR7QnzX0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756954459; c=relaxed/simple;
	bh=HHehcl5nOMaMkJsRyBNg1lizyOMH12RV4xOD8ic329g=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=A2FHrdkWa21BBN9sGJW31ZakYFQ0kneZCRT5dtR7dt3K30aHNGn8cz6zv1J9oggrb2B2LuGIiySLljzOP8bu3VQfs93cZcpTMJetQ7T8kfBloH0Dfr8yljKZJ9w4BhRpOgLOssnmnwZ/EmLs55HeQermPJOB7SiWbdXHXJu4mP8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IuE3ETYv; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756954458; x=1788490458;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=HHehcl5nOMaMkJsRyBNg1lizyOMH12RV4xOD8ic329g=;
  b=IuE3ETYvF2WzhUjnhL6XCrBD9wLkKhju2/5PxFFp5qnLNnL8FcC2TWAT
   pmL5gLuUMWeTBWhFPCsTL8xf+G1jsKV9m4A9TeGo4iSimQUx4JG2hkir2
   QWfbhlPOhI0w1Vr25ApjI44YC/5HHsFzkroRKhmadDM8qmujOLQExAN2y
   IUo9KPFc+lBA6SUQPN2v2fms+D1B0VNZkhMse11rnrU1xg6amR7JPtzJf
   0x0bZ0YGoSxVLFGqjg4dYdq+KrU0Zn9I1nIuP48gGaKEISshC0+3163YZ
   ZovN8vK0X7ZUhd7mCjbIuVD44bXD5gWisqR3crEUmnBVOFZvc5p3YNiyi
   A==;
X-CSE-ConnectionGUID: n/RUBhieR3K2MghONLin6A==
X-CSE-MsgGUID: OuYGSAM5S52VNBgx9mhdKw==
X-IronPort-AV: E=McAfee;i="6800,10657,11542"; a="70379978"
X-IronPort-AV: E=Sophos;i="6.18,237,1751266800"; 
   d="scan'208";a="70379978"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2025 19:54:09 -0700
X-CSE-ConnectionGUID: nnFMiIjtTXyhcvsh8nW9gw==
X-CSE-MsgGUID: yrKIDZ4lTgygAbwM8xF9+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,237,1751266800"; 
   d="scan'208";a="171315247"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2025 19:54:05 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 3 Sep 2025 19:54:01 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 3 Sep 2025 19:54:01 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.46) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 3 Sep 2025 19:54:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GiPyf7p89ozKle22WZtealfZEqiif/g/and4qK5Atg8TtlFoFZYuCUNJA9JcQKoS8rVVlRiIpaAZXPO02pWmMtIB5qNglEbVzLdsPkLoEn5NYo6rUiOpCD2B09kdyNuDJ3dGy80MwunXpdvFyZKM0R/ea3H0a2g80mwqq+oVxT8xmG9W7RwIKikrjrXAeItlXui2oZiefD1CGSdOpHi8Y6RdCI8xbrbAzZF1gu1YhoGlf2vGhDevaASM8NBF89GeYEpYcojy6cv1Lkp/WCPu9GjtACc+PDTBINcaJRE7OdO7PfJFUd3udHWBgTp/x1TbdOOgnhqLubCDdC8EHTbkcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IAguDfadETm19vR9TexdxDzw/5xj3/PiatXV2HvDrEg=;
 b=w3cEdIcXBnksDF8QTnVFgbYTzhF9KVIHmBYjv4AjDMde9uzk9WCzimvB3apkjunB8o/gkgFjf2iZdi4yVpiY34gJBN/JkCRf9hKwRvBLi4MicjV49Idt225qb7Zr4yyb3P57qYmKGegT3tvxtFsx0SUvahgd8alF3bauoQXbwDF6MjxB8mV8v3cjhi+82rf54C0eECWbEsQiMuglMQSOO95edWUNuaTJtrt3B1D7dAfcRksmceNk4PwL3my/vIvhYTkg6YJApCRxdfHQLeX+w8LobhgfU2T69B4EZYnsDebEP6E6lbdOWETfgZx4ZESDyMKSoYO45whTx3xOy+8aEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SN7PR11MB6654.namprd11.prod.outlook.com (2603:10b6:806:262::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.17; Thu, 4 Sep
 2025 02:53:58 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%7]) with mapi id 15.20.9073.026; Thu, 4 Sep 2025
 02:53:58 +0000
Date: Thu, 4 Sep 2025 10:53:00 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@intel.com>, <kas@kernel.org>,
	<tabba@google.com>, <ackerleytng@google.com>, <quic_eberman@quicinc.com>,
	<michael.roth@amd.com>, <david@redhat.com>, <vannapurve@google.com>,
	<vbabka@suse.cz>, <thomas.lendacky@amd.com>, <pgonda@google.com>,
	<fan.du@intel.com>, <jun.miao@intel.com>, <ira.weiny@intel.com>,
	<isaku.yamahata@intel.com>, <xiaoyao.li@intel.com>, <chao.p.peng@intel.com>
Subject: Re: [RFC PATCH v2 04/23] KVM: TDX: Introduce tdx_clear_folio() to
 clear huge pages
Message-ID: <aLj/DLzikcN3tUbk@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
 <20250807094214.4495-1-yan.y.zhao@intel.com>
 <04d6d306-b495-428f-ac3a-44057fd6ccfc@linux.intel.com>
 <aLgPsZ6PxGVqmeZl@yzhao56-desk.sh.intel.com>
 <a42dae7e-4608-4488-9621-0cf32b68dfbc@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <a42dae7e-4608-4488-9621-0cf32b68dfbc@linux.intel.com>
X-ClientProxiedBy: SG2PR01CA0164.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::20) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SN7PR11MB6654:EE_
X-MS-Office365-Filtering-Correlation-Id: 49675568-f910-47d2-cc1a-08ddeb5e4b1d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?H6KMn05zdVEyNM/LCK2lcUfZRKaqE6B8qgOalzrm7DkxoQCJXfRAXMsy4zOJ?=
 =?us-ascii?Q?yjFJkLEo6TE5GN4x/ERkWKb9jiSIGe4ZjBo3AzOIxbEuxZs7MVoqlwF0W8iz?=
 =?us-ascii?Q?z9OJ9+QGXRQZ/obMbsmwGPw4tr9Xjksxd5EZx4qT1GQb6ZT3DQpLL0ObCHpu?=
 =?us-ascii?Q?QeMWY4V5Q9HmjWUTlAbiLaMEEZzw0IRIBIxXRPuf5tsVH5284QDz0I+yTVzY?=
 =?us-ascii?Q?ZpAnN0a+exaBKPkouCt4/UvTyg8Fj4J/XClOyTe2m3PmXGqG05xy1fgf5jRA?=
 =?us-ascii?Q?2YXSyZY0D5PSrVh9xRaLbZgV6AAsd9Gsiw3t8TGq1IPfil27zHAGQy/8O9Fg?=
 =?us-ascii?Q?/QbeWYQr2nHlMLy91Og0UBC2kr/Dpif/Veql1KLNab804O5kLvps+BUA3ab0?=
 =?us-ascii?Q?WkQnP5Bq2wonKBVoVUocNqRkayZILWz6wySlKcJ5YERylZyCuzI8aT9OthxE?=
 =?us-ascii?Q?FX1/CWk8rf7IZUR/7+IvJKGPq5x2mp2xqZCqV/Kzm6VCFPQLSyJMKvoKjsgA?=
 =?us-ascii?Q?f20dAm0QKQNF9TgsNwahLHbQ34et6tOIjsvYCu9a8bZkfLz8de5p10M0X7WU?=
 =?us-ascii?Q?qHKx/D+cxKqGJnRkrNvWRLvNCB/AxPH10DUtK363Er0Zm/IjAFK4TMdiA8e6?=
 =?us-ascii?Q?BnuMhcROplvvof1joRFPtr004y5rzDzLbaAKU8SRrn28gK5USJ5rWC+qKkyZ?=
 =?us-ascii?Q?cu/MKXEHlu2g+dvDJoJllvKgWqdHoFQDxSaahDpRSVhWgtIsD1NtJ9joN6N9?=
 =?us-ascii?Q?xXheSV1TENxQlKgC9Ti10QNtOC3cw2+VLMmVxQDJzFPk7GKg6X87OlfRGopY?=
 =?us-ascii?Q?GNo7pFcexcUhriheFN3bc/OKXiNerWXOwaR4jefrulUYg1x4uyS2Mvt7R2IP?=
 =?us-ascii?Q?JWjOjvlWzOvUeS+BHIj8ScNqwkH9OYTcb3oBNu+eq1unS+uTzVJs3LKadSKk?=
 =?us-ascii?Q?DwaQMnE+BBLYneCUOUYBh2eoPeBV31baNRXwd0rsVXu28TYyV1Sz1olDvWjS?=
 =?us-ascii?Q?3Kf7vED7qjGBtvgJbuDLGpz1HhKDrX0QpokYuPln0H4gOjbPucjN5HnSHO7S?=
 =?us-ascii?Q?Rf1T0PWdKCo/KQVBrIj0SfhRd+EpEJwr5oAMi+3D718+AEbUuahZ7hXoN7+O?=
 =?us-ascii?Q?e3ge9y4Rp6Pe1mDQ/wmJdldI0B9BuHq8jmQTgSRc7AM4eyOSvj6NnZiKfagv?=
 =?us-ascii?Q?rUxFMvzaHML4XLzbJyYkBINZYBHOAg3vox5GYBbSENoL2seIayOomsPjuIPX?=
 =?us-ascii?Q?Sp/oi0ULFZVGBpFqBH7MFeQIJmBQcATOhWzhtc+ITu0BwMRt5aPaI7DhioSQ?=
 =?us-ascii?Q?hLIKx0YG9ISHIiS+9tRR/T+GXfjuBqqf27UPTeG2PSGxd72CfN4D4C1fEezs?=
 =?us-ascii?Q?nxyC7btfgtiEXLHlZNTVApsG5B04i33Iw9uvpD7+ZDBjxau2suxPmmZoM+NA?=
 =?us-ascii?Q?FilI3ZEaj9k=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FZBLc1A43hxXsJkeN/VbU6BtpM5dNVlBjx341sbRI5f29RgPXcbkSFLvYu43?=
 =?us-ascii?Q?7bxAl1sfp3WPxQYs5DAXwaXIEnsDwSJEB3hYuIoToe47OfjavtA33XG/HZLh?=
 =?us-ascii?Q?pdUPYzeomhjA0kuXPnlBfL94EzrEVfNr5TYHo9RSNbMbjmzLhDBODxGbaQzx?=
 =?us-ascii?Q?IJXR8hQ4eZLU45+487Y2Kd5LLnh4WKAzGXJ6U7JHszD0SxC0SCAhV7Ts8ahk?=
 =?us-ascii?Q?Bz4R9I9TsscBFcDaTLOs+n3URkOp4Lo7+JDsrWt3p9JbpfY2WENebjXncOuR?=
 =?us-ascii?Q?WLN9fMY8fumyahZGK4ZOxfVCu/gFbdHYbaz1coZ1+mIgXw1BjO56P+Jxh3bs?=
 =?us-ascii?Q?qVfUdan2RCutzOlm3CvtvvROGy8xATf4nRnfAjpiEniw9DZAHzVItaWhr9jD?=
 =?us-ascii?Q?kAilZaRn6lpnHGQ4PLxN/hVF+OlVbJ3tNRFbvhZy8da2trmdQpQLcoX6ZsCx?=
 =?us-ascii?Q?PE6C6cgUB5nglIEF9OaiDRiGnIAkZM/fJnPMul65oXHixMUOPAUimaD4Zqfj?=
 =?us-ascii?Q?VnT8Lp9i63SUKgLpdKPTMbXiq4mM54eRU0Mqvd2dX1rSjJXA/UuPmSEtXnYW?=
 =?us-ascii?Q?pwOJPAC/bKlddkYn/HCfSK5jpuOlKqjE20dP8LLQh5DTftz/Kjnng0DH6XEY?=
 =?us-ascii?Q?bqcwgbnpXpIlpGIDre8j6p3DT//0g/AwWDi2XVXeez+vE54C4Mp+81sD84eI?=
 =?us-ascii?Q?g55bU/ILI/JpggYw/3LrZ8T7dyFil+titK+o/sg5hmWcJ4x4b7FFXSzCM208?=
 =?us-ascii?Q?BTC3TRJ7u640El3hwjPWX1S9xKdskV3kiGPrsc0V74c+JQ6b8PWs13dARZ0l?=
 =?us-ascii?Q?YBTMZvANOItrjQ8iRZliqGog4elZ33dKs7xZqOBU44mMlBH0F1ysRy7aKf1e?=
 =?us-ascii?Q?oWHr6o4HptB3oQhrsLE5n6UdtJR8R1yy2dmXwvgw59B9xsdUJg51stWKJGpp?=
 =?us-ascii?Q?EryKEphoflff9rLXqfr31mVCca4WuhYfLS59du/XPxyJPyHTF/vheDrd088e?=
 =?us-ascii?Q?/dQOYtfzWpw/EHOvM3fGSnq4gDenFd/o/d6EuIFMMCLdJo2v8QyDAJsxTi4r?=
 =?us-ascii?Q?/Q78N7VtPxL17wSmmFGNaRP3Qfmi5Ry70uZvrS6CSl//Ds+j6nrxIZ0jejlf?=
 =?us-ascii?Q?fzRboMqZzE2aSPl1x+k4tyHnfJ+uZ8E1HK/U97aJxs5fNumedkOLOzjXR5Pb?=
 =?us-ascii?Q?n4gOKg1bD0mtqwAqKGI98Fr7MyaVorZIN5GywkCRdSx55KLzb9fxOYdPAqT6?=
 =?us-ascii?Q?/WS3Dtwk+bm2d/lJX42/yPgysSyCD0Xomzw9Fp/Pk3gtqBlrJIDDKd5btORg?=
 =?us-ascii?Q?+Ep5oX+2hMCTK8L+b1ts5VpvMd9zuVAw3Z/olAcqPTG8/OKutV4vofXWwKsy?=
 =?us-ascii?Q?f2MGQldruMsn6mB0383eLqLlXF8id8WpZJ0Bdt9QPoq4YjHPCEDF1PuSbUp0?=
 =?us-ascii?Q?aCiaJIMvtt9l+XY2YFvgnTKDiuvQHYVC2BUX0VW7sha3FGjTD6G1zihw+UGj?=
 =?us-ascii?Q?o4qNM3k98yAUSJwP423GzfJKWQCmyn0bUSqLB5QtyVFj6mQCfCzXiEcg47B7?=
 =?us-ascii?Q?hdxfdpNjrwWSprKxPjvUs6YI8ZqGm8n+gah4OPJ/?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 49675568-f910-47d2-cc1a-08ddeb5e4b1d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 02:53:57.7511
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7xsXNWRxueX+trjKdwnOdi1aubGdI9jnwwogBUtQVI0qWkpBj7nvRvx5mOlRhAd4B+2+7Dp4+MbnyAnQZ3aOcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6654
X-OriginatorOrg: intel.com

On Wed, Sep 03, 2025 at 07:19:32PM +0800, Binbin Wu wrote:
> 
> 
> On 9/3/2025 5:51 PM, Yan Zhao wrote:
> > On Tue, Sep 02, 2025 at 10:56:25AM +0800, Binbin Wu wrote:
> > > 
> > > On 8/7/2025 5:42 PM, Yan Zhao wrote:
> > > > After removing or reclaiming a guest private page or a control page from a
> > > > TD, zero the physical page using movdir64b(), enabling the kernel to reuse
> > > > the pages.
> > > > 
> > > > Introduce the function tdx_clear_folio() to zero out physical memory using
> > > > movdir64b(), starting from the page at "start_idx" within a "folio" and
> > > > spanning "npages" contiguous PFNs.
> > > > 
> > > > Convert tdx_clear_page() to be a helper function to facilitate the
> > > > zeroing of 4KB pages.
> > > I think this sentence is outdated?
> > No? tdx_clear_page() is still invoked to clear tdr_page.
> 
> I didn't get the word "Convert".
Ok. I wanted to express that tdx_clear_page() now is just a helper.
Will rephrase it to

"Make tdx_clear_page() to be a helper function to facilitate the zeroing
of 4KB pages".

