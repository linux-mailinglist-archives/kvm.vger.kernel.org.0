Return-Path: <kvm+bounces-26918-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BBFA978F7E
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 11:29:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8863D1F234B2
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 09:29:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FC1276046;
	Sat, 14 Sep 2024 09:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B0bffDzD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C8671474B9;
	Sat, 14 Sep 2024 09:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726306182; cv=fail; b=ChbOAcccRpFwfoE3cGPAP2etTSS4lNBrw5naTwCnhNklnMKQth/FzAcLribOC2hZCIJOrWsvWWJzM7fxefl8LdlcVKpqCWRp6iH6j7wXJCxhtWBd6Ns+FBR1nVvNZCPPEkSpHJl3hun5SoH49aMGk8lj/nmeKLnAoxPIW560sOs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726306182; c=relaxed/simple;
	bh=qkujYtWq/I7XLeAn12ZQH40oKgtKagA646IU7MnkB1c=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=kbeBiVzn9kNKTOjZK4OkL53pJ2Y8VCQ5QQx14c90jomtGWJHLTxU1pjZby0oVFVrBd+BQDCUtWEfuP+4LruFU5oxpqAwu9MiY9C5OhYn4PbBmQiObRzKvgVrRddEbTpQ739oerlJrmFdF0YL85nWXSWsy4jrE2TYzQWL92KcR/Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B0bffDzD; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726306180; x=1757842180;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=qkujYtWq/I7XLeAn12ZQH40oKgtKagA646IU7MnkB1c=;
  b=B0bffDzDAAkLnR6c5FDA8tNvVkRh5C0nsAdLOKrij4y7HDkjB1CcX12E
   glvZdFp6KB+js6RIKMkmO4PMTYQg/nYtB1x9SbbRvMk3yuzH3wTHdg+pS
   OgLMzWTPpkW63cDgYGUUOf06HFlxpcWhlkk1Wvq3WAjf8AoPsZXaB0pYO
   i17OfTxEfROZqHgXZGpHfl32Ocuq5Am4ya+E1N9rpT7/xicfI0t3oIzGf
   1wZpfw2iXUr1U6gegdhzkaE71YGavGTMuSOmPJXNFAIgkxENK8+ZWmcSR
   nBTxgnCxbRkFfrc+4W14NPv80896P0uedLNdbAt36NPBi4zJB89kTsNUA
   w==;
X-CSE-ConnectionGUID: 0arES7/8TxaJ1H2qBR/xxg==
X-CSE-MsgGUID: 4xq8TWLXS4GTHyH5kXlmig==
X-IronPort-AV: E=McAfee;i="6700,10204,11194"; a="50624270"
X-IronPort-AV: E=Sophos;i="6.10,228,1719903600"; 
   d="scan'208";a="50624270"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2024 02:29:39 -0700
X-CSE-ConnectionGUID: gfXHfEJ7ThmHFJ1lOI0icg==
X-CSE-MsgGUID: UWZPATcnSFqjSpbrs9OlMg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,228,1719903600"; 
   d="scan'208";a="91627865"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Sep 2024 02:29:39 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sat, 14 Sep 2024 02:29:38 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sat, 14 Sep 2024 02:29:38 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sat, 14 Sep 2024 02:29:38 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sat, 14 Sep 2024 02:29:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j9IOvoPrf+DO/JRunpGBzlG40ZelD/vizGB8C/2Ntk92+D2IBaF7jtwjhlfv5w7NpK3KYuGmcL3AZClFrphCfunKyv4L6Z29GxysEmlXyfJy/lGFa7B9pBRMuu7JGd9o0uJEcpWD5+kmGSRCN57Z+tutu18i15O8esgd/2z1cteTcWoy5ctmVQR1PTngiodVkiN/O6vg4rz1Lpied2Lq2kYsyhnL9Ub15DLzEncfIQVBjQWSP3T2SOsUuR1jX21/WGeHEmvoAsGGjsH/K0FO+FOu5uuuqM9XpzQJG+0MwOoESxFvQVhxG1WgadpTMzCwsJMnY7DbXC8qchxlZPFMdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7WwFl0+Vf6jnHlhaR4kXF/bFiIvKlXbtL5RSWcHAcic=;
 b=PyBjN2IoJhVZc9xTJavbdW3+Q0L8mGPqfPJ/OdM6AM8BlHwYCqf6QpKp0ZJtU2SOh5YPwpqnFnYh611DtbKqL0KXCI5lrvVaJFzREdquMVbM+e5Zjsb5A2lTOdVWXhx5e7EIP/EPw5z7j78zQeQSzGyL7ay3d54vduWIi5G2ExkK3fWEspMoaOqL2ygxSAufJUDzwDvYVSa52SBY+lNj9T8Z7HUvbne6G2iQvndX8Q1ztLj/xF4AFju8Gy6xkGmyW+KvavkXQjph9mJ1rxKvcXgpmtPaYB+F0YXTi1bbhqS9umTd/6zSUT+RJSjQLQfiw6l3ng3wHm/HM5Kbu666tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CH3PR11MB8185.namprd11.prod.outlook.com (2603:10b6:610:159::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.21; Sat, 14 Sep
 2024 09:29:33 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7962.021; Sat, 14 Sep 2024
 09:29:33 +0000
Date: Sat, 14 Sep 2024 17:27:32 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Rick P Edgecombe <rick.p.edgecombe@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, Yuan Yao <yuan.yao@intel.com>, Kai Huang
	<kai.huang@intel.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "dmatlack@google.com"
	<dmatlack@google.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>
Subject: Re: [PATCH 09/21] KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY
 with operand SEPT
Message-ID: <ZuVXBDCWS615bsVa@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <b012360b4d14c0389bcb77fc8e9e5d739c6cc93d.camel@intel.com>
 <Zt9kmVe1nkjVjoEg@google.com>
 <1bbe3a78-8746-4db9-a96c-9dc5f1190f16@redhat.com>
 <ZuBQYvY6Ib4ZYBgx@google.com>
 <CABgObfayLGyWKERXkU+0gjeUg=Sp3r7GEQU=+13sUMpo36weWg@mail.gmail.com>
 <ZuBsTlbrlD6NHyv1@google.com>
 <655170f6a09ad892200cd033efe5498a26504fec.camel@intel.com>
 <ZuCE_KtmXNi0qePb@google.com>
 <ZuP5eNXFCljzRgWo@yzhao56-desk.sh.intel.com>
 <ZuR09EqzU1WbQYGd@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZuR09EqzU1WbQYGd@google.com>
X-ClientProxiedBy: SI2PR01CA0010.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::12) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CH3PR11MB8185:EE_
X-MS-Office365-Filtering-Correlation-Id: ed124c0b-83a0-47fb-e12e-08dcd49fbdbc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?QIlAMoCKST9GgqCcGOLwCOjrZtboYQgX5ofNXw/oRW3J8IG26/dv7ACy+c0r?=
 =?us-ascii?Q?yzoX+QEMzGzWtNi4ahWqPKqKeewY9Lt1+ZAgz5wxIhOaWHLX8y0f/L4Y6QTn?=
 =?us-ascii?Q?YSFeEsQEqzQqDcEMF4aeok9AwlH0cBV8hk3pVFCqD4GNcIGu9WzIW2uCsh/B?=
 =?us-ascii?Q?e+Q2V57m/onngCFJRlmTuwVtDYzlfJM04RKbsr2hynW/eeaU8naXKyzMJ6Wu?=
 =?us-ascii?Q?/ffMKHqIwgOdiSvS/hIIRZjcRptU4sB7d/0CYCFiK6Td6bo9K0IS4aLkuM1U?=
 =?us-ascii?Q?pBcfVwyegSrjs5dOviOJbFvnpgIsCg7JddiuwSFyJjVyqb/itZosFNQ94NdI?=
 =?us-ascii?Q?tkg+dpsDDE30jpSh9a43XrtRxgGR3bN/klta5nVTd/ZoYTuLYFjrGJoT1UWU?=
 =?us-ascii?Q?C5u2ZLcjXjC/cHPNbArcYAkFEZMdunCiP2DcOw1jc9wEA+vQycH1mNtOHDYV?=
 =?us-ascii?Q?MtjO7YPA5CIUSMbUdHF1zXPjuZM6scxc+jLdJL/v78E6UbBTVeHX+0qGu3b4?=
 =?us-ascii?Q?8XePFqqZTUV7LtgPa0lFXTQ/d3lye30IO8Cgb8wNOtzLfZat2V+AAXvSjsGF?=
 =?us-ascii?Q?OzHAj3FnEscd/gft1V5m40n0ml6jlXFY9OvLYSAyhDsTzonIbLxhBin+twkV?=
 =?us-ascii?Q?F+sfsarJQZ7gAfH8DaGB9XdhZ84uj4Q6c2O0X1AdzbbMOC0kJa/kMdeRcDy1?=
 =?us-ascii?Q?gGbJODbraeezLYUIY7Vo4rvPMabqjdm1mNdpXKbDr6PE22OmPgDamZGdS88V?=
 =?us-ascii?Q?3rtlUq7YRntOXtBID/ll9QJ71jZdhVznk5MGFrDD14ESZnkiEttHAgl9Jkju?=
 =?us-ascii?Q?66CofkgojvK4wYOw2vMgQTBF2IAE8T+eCbN/86G/lrYu+6QceXTHrsZQ3/p4?=
 =?us-ascii?Q?YuVQx+aw9280K9t/Qm0D/eqT+zqhkm06voUehJepyIh4dBKvNxMWed+IEbJP?=
 =?us-ascii?Q?/SVsy2jdm4j5cDRRyfz9sCzXrKRV9de+jCOJ+cl2CXQB7Eu5uDXhoVk7VXzL?=
 =?us-ascii?Q?qPlYA18P1v01TJWn994KTbSN2jkd1oqc59Fh+ysLHZbGyEXGRS/FJSPISiWk?=
 =?us-ascii?Q?zI/mFco/Y1LOlcRfh6T/9qhlfHnW8UdcuSBGzicQ0bqzT3XKHXvn0klNT9wz?=
 =?us-ascii?Q?thuh0SL0OlxYpMRz7Au2orQYxelvLHCVWueCCRqtEneEGwcwypJhrKV+q0eO?=
 =?us-ascii?Q?rPm9I2J73BlBdHMHmLjQq4WEuueWfFnRQzEuN/hVqztjPmlXrMkmGrvpgcYs?=
 =?us-ascii?Q?DkG/52g595s7EGz0J1vSfOQ/t8kUI/3mgLrBLErh7mzTVJRkUzPh36csna8I?=
 =?us-ascii?Q?TYMtP9/+sB/PuKcKnrNtYByt5VcT5IdHjBH3n/XwOVIQj1+yEBixFC7yu1HU?=
 =?us-ascii?Q?GwGJrJo=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Hvxba1L9aCNN67Z37npRYz1am+viLMqvQ0qrPITXcboV+3x7SZkSGuRcCSeR?=
 =?us-ascii?Q?Pdo6/hvc2Nz3fRk2WfMaVyiPBQNZASZy81x9SYkih20RKqF2D6P5EXTJC7yT?=
 =?us-ascii?Q?fmq9GHHCGpi/Y+ubCcIRjczp9LEbBdfq49gi9a51biV0iPwOEH6hdJXkTEJH?=
 =?us-ascii?Q?lq3rIenNZY35LNa2d2SGEDsPNr19gqipVREFbJUX94AP+abrCstXKzU0esIQ?=
 =?us-ascii?Q?4rKVuOccvbaAepwr4jbzBZ3EuLzVynnBp2wObu3d8pmpJy+1wjju75zRqIz0?=
 =?us-ascii?Q?RO49cOkoi9nTQfgKMaOHfUdxFIxvSAwVeyjvbIP1b7u4Y8IA5BkSkW+l9fpC?=
 =?us-ascii?Q?+9EawESZtPZrcx4d6ALxN33qT3R+xHRQKjDc0maFb0czMncln8fhd8B/8Asb?=
 =?us-ascii?Q?MbptKwpuKkupjUYCuQzfXUgU038g/vZU+9SBIj+ps9ugI6Bg3RL2m2+O3SsL?=
 =?us-ascii?Q?kCGFHc83uup3ANf2yAc7REjaGEsDmq+7s8HU7O9G3YKu9tf016PphpjN8Dm9?=
 =?us-ascii?Q?xbRdKDu04vvqpDu0/hCFjYKvs4BoAiUdkJV5b9z1c/p5rZ/CU8yx/9EOBWaR?=
 =?us-ascii?Q?ngDYZKhiY8Eka2Gbl0ihUc5CKuB/BG16hWaHwvghIY2lxnnCeUIU7Cqw61v5?=
 =?us-ascii?Q?08zFlWiCbKkpv9ASJjLLriMXBk1MgRWWd9ILUk1Kgy6b1alYS8yK1I+x7H5A?=
 =?us-ascii?Q?L/1eWo0GSPsPJpnumeMMbi/rAZoE91ITJ8Zw275n1n+uZTIP2vFutyRQXB2d?=
 =?us-ascii?Q?sgyxaAo5Es6vZmTRUHTZJi1fgBOKW+DCpK2Yd5vNwrfPla+0vZhPqoLFp849?=
 =?us-ascii?Q?eai7nVXtNk0XjfeXSeTO7sJTHYF3NATrK72aJ+jQcXhvuRJ1EBsUJmuJfj9S?=
 =?us-ascii?Q?cjqYERQtyLYxT0mE+xm09krKZtUCYAWywimmkGKzPsYsKN+XOcgdb1wvgALy?=
 =?us-ascii?Q?Lwff3EFrvAQb6xPe1ncupgJHIBNAaQVuC0gjlmGGT469BqnRg1NHw4CnQupb?=
 =?us-ascii?Q?1NhLvarGbPuJbpKZbonHJCqmmOPpPr9/eetBl2CaKBYIYESWr8ArSTwsmRqW?=
 =?us-ascii?Q?k6/Zg2Apt5dxFFj2iF0JQ7UjtyZ/rqJPvj/EEUWWjwxlCjEv1ZG8/Nrl1JPl?=
 =?us-ascii?Q?C8Jzq4k2M/M/EUXz9ABy0lNHqQiCAY8VuP5XINnNf5eleZGVmPsW3w6PMvNM?=
 =?us-ascii?Q?f9pKQaVpFUA2beLL8Ws4Fwuz5647gHT0QAuRD6iF/rTC0bFtFylPo8ckUmwQ?=
 =?us-ascii?Q?qLGIwaFQLHhsSIOPwjXtSWWB78XqTrFHGuG2FHF36r2K5dFTLVSLtvhA1b0L?=
 =?us-ascii?Q?NCINN+C4vIg//JPNLTtyzyOzKJ5k+yCMvk7lRkfdEEEQOmTLlcL+ZFLBPthI?=
 =?us-ascii?Q?b8vDWM+e72AL5gBjYSe5dQHPlLQNSoEUFA6fMU0v/eRe5jRMaVMMpm+Ar5dT?=
 =?us-ascii?Q?K2dDJY/63u/iIx6TpuwwuVEvG+DHkv9A3m8JXHht0+PPj2nLS7yVcqAmnwv0?=
 =?us-ascii?Q?/eIPoYGXU6fjpo3cKi3iWUHYPQoIyeLp5OCiWMa8fLToj5eHDslUwUadr2TF?=
 =?us-ascii?Q?EvM/6lPX/w4jtxml8xuEmux+rPHHvag3pq2AtUE3?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ed124c0b-83a0-47fb-e12e-08dcd49fbdbc
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2024 09:29:32.9310
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 13RjyYpQfVxFVOpVQp/+M12GrY8/tyiVoipEKsyIPGsb+vVX7IxmH2GvxNQENH6PjYA63z7gtidWDiSLu3tKSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8185
X-OriginatorOrg: intel.com

On Fri, Sep 13, 2024 at 10:23:00AM -0700, Sean Christopherson wrote:
> On Fri, Sep 13, 2024, Yan Zhao wrote:
> > This is a lock status report of TDX module for current SEAMCALL retry issue
> > based on code in TDX module public repo https://github.com/intel/tdx-module.git
> > branch TDX_1.5.05.
> > 
> > TL;DR:
> > - tdh_mem_track() can contend with tdh_vp_enter().
> > - tdh_vp_enter() contends with tdh_mem*() when 0-stepping is suspected.
> 
> The zero-step logic seems to be the most problematic.  E.g. if KVM is trying to
> install a page on behalf of two vCPUs, and KVM resumes the guest if it encounters
> a FROZEN_SPTE when building the non-leaf SPTEs, then one of the vCPUs could
> trigger the zero-step mitigation if the vCPU that "wins" and gets delayed for
> whatever reason.
> 
> Since FROZEN_SPTE is essentially bit-spinlock with a reaaaaaly slow slow-path,
> what if instead of resuming the guest if a page fault hits FROZEN_SPTE, KVM retries
> the fault "locally", i.e. _without_ redoing tdh_vp_enter() to see if the vCPU still
> hits the fault?
> 
> For non-TDX, resuming the guest and letting the vCPU retry the instruction is
> desirable because in many cases, the winning task will install a valid mapping
> before KVM can re-run the vCPU, i.e. the fault will be fixed before the
> instruction is re-executed.  In the happy case, that provides optimal performance
> as KVM doesn't introduce any extra delay/latency.
> 
> But for TDX, the math is different as the cost of a re-hitting a fault is much,
> much higher, especially in light of the zero-step issues.
> 
> E.g. if the TDP MMU returns a unique error code for the frozen case, and
> kvm_mmu_page_fault() is modified to return the raw return code instead of '1',
> then the TDX EPT violation path can safely retry locally, similar to the do-while
> loop in kvm_tdp_map_page().
> 
> The only part I don't like about this idea is having two "retry" return values,
> which creates the potential for bugs due to checking one but not the other.
> 
> Hmm, that could be avoided by passing a bool pointer as an out-param to communicate
> to the TDX S-EPT fault handler that the SPTE is frozen.  I think I like that
> option better even though the out-param is a bit gross, because it makes it more
> obvious that the "frozen_spte" is a special case that doesn't need attention for
> most paths.
Good idea.
But could we extend it a bit more to allow TDX's EPT violation handler to also
retry directly when tdh_mem_sept_add()/tdh_mem_page_aug() returns BUSY?

> 
> > - tdg_mem_page_accept() can contend with other tdh_mem*().
> > 
> > Proposal:
> > - Return -EAGAIN directly in ops link_external_spt/set_external_spte when
> >   tdh_mem_sept_add()/tdh_mem_page_aug() returns BUSY.
> What is the result of returning -EAGAIN? E.g. does KVM redo tdh_vp_enter()?
Sorry, I meant -EBUSY originally.

With the current code in kvm_tdp_map_page(), vCPU should just retry without
tdh_vp_enter() except when there're signals pending.
With a real EPT violation, tdh_vp_enter() should be called again.

I realized that this is not good enough.
So, is it better to return -EAGAIN in ops link_external_spt/set_external_spte
and have kvm_tdp_mmu_map() return RET_PF_RETRY_FROZEN for -EAGAIN?
(or maybe some other name for RET_PF_RETRY_FROZEN).

> Also tdh_mem_sept_add() is strictly pre-finalize, correct?  I.e. should never
> contend with tdg_mem_page_accept() because vCPUs can't yet be run.
tdh_mem_page_add() is pre-finalize, tdh_mem_sept_add() is not.
tdh_mem_sept_add() can be called runtime by tdp_mmu_link_sp().

 
> Similarly, can tdh_mem_page_aug() actually contend with tdg_mem_page_accept()?
> The page isn't yet mapped, so why would the guest be allowed to take a lock on
> the S-EPT entry?
Before tdg_mem_page_accept() accepts a gpa and set rwx bits in a SPTE, if second
tdh_mem_page_aug() is called on the same gpa, the second one may contend with
tdg_mem_page_accept().

But given KVM does not allow the second tdh_mem_page_aug(), looks the contention
between tdh_mem_page_aug() and tdg_mem_page_accept() will not happen.

> 
> > - Kick off vCPUs at the beginning of page removal path, i.e. before the
> >   tdh_mem_range_block().
> >   Set a flag and disallow tdh_vp_enter() until tdh_mem_page_remove() is done.
> 
> This is easy enough to do via a request, e.g. see KVM_REQ_MCLOCK_INPROGRESS.
Great!

> 
> >   (one possible optimization:
> >    since contention from tdh_vp_enter()/tdg_mem_page_accept should be rare,
> >    do not kick off vCPUs in normal conditions.
> >    When SEAMCALL BUSY happens, retry for once, kick off vCPUs and do not allow
> 
> Which SEAMCALL is this specifically?  tdh_mem_range_block()?
Yes, they are
- tdh_mem_range_block() contends with tdh_vp_enter() for secure_ept_lock.
- tdh_mem_track() contends with tdh_vp_enter() for TD epoch.
  (current code in MMU part 2 just retry tdh_mem_track() endlessly),
- tdh_mem_page_remove()/tdh_mem_range_block() contends with
  tdg_mem_page_accept() for SEPT entry lock.
  (this one should not happen on a sane guest).

 Resources              SHARED  users              EXCLUSIVE users      
------------------------------------------------------------------------
(5) TDCS epoch         tdh_vp_enter                tdh_mem_track
------------------------------------------------------------------------
(6) secure_ept_lock    tdh_mem_sept_add            tdh_vp_enter
                       tdh_mem_page_aug            tdh_mem_sept_remove
                       tdh_mem_page_remove         tdh_mem_range_block
                                                   tdh_mem_range_unblock
------------------------------------------------------------------------
(7) SEPT entry                                     tdh_mem_sept_add
                                                   tdh_mem_sept_remove
                                                   tdh_mem_page_aug
                                                   tdh_mem_page_remove
                                                   tdh_mem_range_block
                                                   tdh_mem_range_unblock
                                                   tdg_mem_page_accept


> 
> >    TD enter until page removal completes.)
> 
> 
> Idea #1:
> ---
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index b45258285c9c..8113c17bd2f6 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4719,7 +4719,7 @@ static int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code,
>                         return -EINTR;
>                 cond_resched();
>                 r = kvm_mmu_do_page_fault(vcpu, gpa, error_code, true, NULL, level);
> -       } while (r == RET_PF_RETRY);
> +       } while (r == RET_PF_RETRY || r == RET_PF_RETRY_FOZEN);
>  
>         if (r < 0)
>                 return r;
> @@ -6129,7 +6129,7 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
>                 vcpu->stat.pf_spurious++;
>  
>         if (r != RET_PF_EMULATE)
> -               return 1;
> +               return r;
>  
>  emulate:
>         return x86_emulate_instruction(vcpu, cr2_or_gpa, emulation_type, insn,
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index 8d3fb3c8c213..690f03d7daae 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -256,12 +256,15 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
>   * and of course kvm_mmu_do_page_fault().
>   *
>   * RET_PF_CONTINUE: So far, so good, keep handling the page fault.
> + * RET_PF_FIXED: The faulting entry has been fixed.
>   * RET_PF_RETRY: let CPU fault again on the address.
> + * RET_PF_RETRY_FROZEN: One or more SPTEs related to the address is frozen.
> + *                     Let the CPU fault again on the address, or retry the
> + *                     fault "locally", i.e. without re-entering the guest.
>   * RET_PF_EMULATE: mmio page fault, emulate the instruction directly.
>   * RET_PF_WRITE_PROTECTED: the gfn is write-protected, either unprotected the
>   *                         gfn and retry, or emulate the instruction directly.
>   * RET_PF_INVALID: the spte is invalid, let the real page fault path update it.
> - * RET_PF_FIXED: The faulting entry has been fixed.
>   * RET_PF_SPURIOUS: The faulting entry was already fixed, e.g. by another vCPU.
>   *
>   * Any names added to this enum should be exported to userspace for use in
> @@ -271,14 +274,18 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
>   * on -errno return values.  Somewhat arbitrarily use '0' for CONTINUE, which
>   * will allow for efficient machine code when checking for CONTINUE, e.g.
>   * "TEST %rax, %rax, JNZ", as all "stop!" values are non-zero.
> + *
> + * Note #2, RET_PF_FIXED _must_ be '1', so that KVM's -errno/0/1 return code
> + * scheme, where 1==success, translates '1' to RET_PF_FIXED.
>   */
Looks "r > 0" represents success in vcpu_run()?
So, moving RET_PF_FIXED to 1 is not necessary?

>  enum {
>         RET_PF_CONTINUE = 0,
> +       RET_PF_FIXED    = 1,
>         RET_PF_RETRY,
> +       RET_PF_RETRY_FROZEN,
>         RET_PF_EMULATE,
>         RET_PF_WRITE_PROTECTED,
>         RET_PF_INVALID,
> -       RET_PF_FIXED,
>         RET_PF_SPURIOUS,
>  };
>  
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 5a475a6456d4..cbf9e46203f3 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1174,6 +1174,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  
>  retry:
>         rcu_read_unlock();
> +       if (ret == RET_PF_RETRY && is_frozen_spte(iter.old_spte))
> +               return RET_PF_RETRY_FOZEN;
>         return ret;
>  }
>  
> ---
> 
> 
> Idea #2:
> ---
>  arch/x86/include/asm/kvm_host.h |  2 +-
>  arch/x86/kvm/mmu/mmu.c          | 12 ++++++------
>  arch/x86/kvm/mmu/mmu_internal.h | 15 ++++++++++++---
>  arch/x86/kvm/mmu/tdp_mmu.c      |  1 +
>  arch/x86/kvm/svm/svm.c          |  2 +-
>  arch/x86/kvm/vmx/vmx.c          |  4 ++--
>  6 files changed, 23 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 46e0a466d7fb..200fecd1de88 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -2183,7 +2183,7 @@ unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
>  int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);
>  
>  int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
> -		       void *insn, int insn_len);
> +		       void *insn, int insn_len, bool *frozen_spte);
>  void kvm_mmu_print_sptes(struct kvm_vcpu *vcpu, gpa_t gpa, const char *msg);
>  void kvm_mmu_invlpg(struct kvm_vcpu *vcpu, gva_t gva);
>  void kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index b45258285c9c..207840a316d3 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4283,7 +4283,7 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
>  		return;
>  
>  	r = kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, work->arch.error_code,
> -				  true, NULL, NULL);
> +				  true, NULL, NULL, NULL);
>  
>  	/*
>  	 * Account fixed page faults, otherwise they'll never be counted, but
> @@ -4627,7 +4627,7 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
>  		trace_kvm_page_fault(vcpu, fault_address, error_code);
>  
>  		r = kvm_mmu_page_fault(vcpu, fault_address, error_code, insn,
> -				insn_len);
> +				       insn_len, NULL);
>  	} else if (flags & KVM_PV_REASON_PAGE_NOT_PRESENT) {
>  		vcpu->arch.apf.host_apf_flags = 0;
>  		local_irq_disable();
> @@ -4718,7 +4718,7 @@ static int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code,
>  		if (signal_pending(current))
>  			return -EINTR;
>  		cond_resched();
> -		r = kvm_mmu_do_page_fault(vcpu, gpa, error_code, true, NULL, level);
> +		r = kvm_mmu_do_page_fault(vcpu, gpa, error_code, true, NULL, level, NULL);
>  	} while (r == RET_PF_RETRY);
>  
>  	if (r < 0)
> @@ -6073,7 +6073,7 @@ static int kvm_mmu_write_protect_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  }
>  
>  int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
> -		       void *insn, int insn_len)
> +				void *insn, int insn_len, bool *frozen_spte)
>  {
>  	int r, emulation_type = EMULTYPE_PF;
>  	bool direct = vcpu->arch.mmu->root_role.direct;
> @@ -6109,7 +6109,7 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
>  		vcpu->stat.pf_taken++;
>  
>  		r = kvm_mmu_do_page_fault(vcpu, cr2_or_gpa, error_code, false,
> -					  &emulation_type, NULL);
> +					  &emulation_type, NULL, frozen_spte);
>  		if (KVM_BUG_ON(r == RET_PF_INVALID, vcpu->kvm))
>  			return -EIO;
>  	}
> @@ -6129,7 +6129,7 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
>  		vcpu->stat.pf_spurious++;
>  
>  	if (r != RET_PF_EMULATE)
> -		return 1;
> +		return r;
>  
>  emulate:
>  	return x86_emulate_instruction(vcpu, cr2_or_gpa, emulation_type, insn,
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index 8d3fb3c8c213..5b1fc77695c1 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -247,6 +247,9 @@ struct kvm_page_fault {
>  	 * is changing its own translation in the guest page tables.
>  	 */
>  	bool write_fault_to_shadow_pgtable;
> +
> +	/* Indicates the page fault needs to be retried due to a frozen SPTE. */
> +	bool frozen_spte;
>  };
>  
>  int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
> @@ -256,12 +259,12 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
>   * and of course kvm_mmu_do_page_fault().
>   *
>   * RET_PF_CONTINUE: So far, so good, keep handling the page fault.
> + * RET_PF_FIXED: The faulting entry has been fixed.
>   * RET_PF_RETRY: let CPU fault again on the address.
>   * RET_PF_EMULATE: mmio page fault, emulate the instruction directly.
>   * RET_PF_WRITE_PROTECTED: the gfn is write-protected, either unprotected the
>   *                         gfn and retry, or emulate the instruction directly.
>   * RET_PF_INVALID: the spte is invalid, let the real page fault path update it.
> - * RET_PF_FIXED: The faulting entry has been fixed.
>   * RET_PF_SPURIOUS: The faulting entry was already fixed, e.g. by another vCPU.
>   *
>   * Any names added to this enum should be exported to userspace for use in
> @@ -271,14 +274,17 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
>   * on -errno return values.  Somewhat arbitrarily use '0' for CONTINUE, which
>   * will allow for efficient machine code when checking for CONTINUE, e.g.
>   * "TEST %rax, %rax, JNZ", as all "stop!" values are non-zero.
> + *
> + * Note #2, RET_PF_FIXED _must_ be '1', so that KVM's -errno/0/1 return code
> + * scheme, where 1==success, translates '1' to RET_PF_FIXED.
>   */
>  enum {
>  	RET_PF_CONTINUE = 0,
> +	RET_PF_FIXED    = 1,
>  	RET_PF_RETRY,
>  	RET_PF_EMULATE,
>  	RET_PF_WRITE_PROTECTED,
>  	RET_PF_INVALID,
> -	RET_PF_FIXED,
>  	RET_PF_SPURIOUS,
>  };
>  
> @@ -292,7 +298,8 @@ static inline void kvm_mmu_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
>  
>  static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  					u64 err, bool prefetch,
> -					int *emulation_type, u8 *level)
> +					int *emulation_type, u8 *level,
> +					bool *frozen_spte)
>  {
>  	struct kvm_page_fault fault = {
>  		.addr = cr2_or_gpa,
> @@ -341,6 +348,8 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  		*emulation_type |= EMULTYPE_WRITE_PF_TO_SP;
>  	if (level)
>  		*level = fault.goal_level;
> +	if (frozen_spte)
> +		*frozen_spte = fault.frozen_spte;
>  
>  	return r;
>  }
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 5a475a6456d4..e7fc5ea4b437 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1174,6 +1174,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  
>  retry:
>  	rcu_read_unlock();
> +	fault->frozen_spte = is_frozen_spte(iter.old_spte);
>  	return ret;
>  }
>  
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 38723b0c435d..269de6a9eb13 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2075,7 +2075,7 @@ static int npf_interception(struct kvm_vcpu *vcpu)
>  	rc = kvm_mmu_page_fault(vcpu, fault_address, error_code,
>  				static_cpu_has(X86_FEATURE_DECODEASSISTS) ?
>  				svm->vmcb->control.insn_bytes : NULL,
> -				svm->vmcb->control.insn_len);
> +				svm->vmcb->control.insn_len, NULL);
>  
>  	if (rc > 0 && error_code & PFERR_GUEST_RMP_MASK)
>  		sev_handle_rmp_fault(vcpu, fault_address, error_code);
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 368acfebd476..fc2ff5d91a71 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5822,7 +5822,7 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
>  	if (unlikely(allow_smaller_maxphyaddr && !kvm_vcpu_is_legal_gpa(vcpu, gpa)))
>  		return kvm_emulate_instruction(vcpu, 0);
>  
> -	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
> +	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0, NULL);
>  }
>  
>  static int handle_ept_misconfig(struct kvm_vcpu *vcpu)
> @@ -5843,7 +5843,7 @@ static int handle_ept_misconfig(struct kvm_vcpu *vcpu)
>  		return kvm_skip_emulated_instruction(vcpu);
>  	}
>  
> -	return kvm_mmu_page_fault(vcpu, gpa, PFERR_RSVD_MASK, NULL, 0);
> +	return kvm_mmu_page_fault(vcpu, gpa, PFERR_RSVD_MASK, NULL, 0, NULL);
>  }
>  
>  static int handle_nmi_window(struct kvm_vcpu *vcpu)
> 
> base-commit: bc87a2b4b5508d247ed2c30cd2829969d168adfe
> -- 
> 

