Return-Path: <kvm+bounces-46755-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6C97AB9403
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 04:25:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 729D1501B3A
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 02:25:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A42F222A4E2;
	Fri, 16 May 2025 02:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Qc95J+aS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16EDD8BF8;
	Fri, 16 May 2025 02:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747362345; cv=fail; b=cSkszFL1UFllSNHzIDWCNT8UZ/FH394fMpzeZzrr99AwiW+vW4R8kWvbaD9FHN1sLSPueUFk86r+dgfjzB54YaLN8EQB+V9TdN75Q+xR4LwbvgZAymPll//jdLyNfjcbCn2GOAzYO7z3BpOKl4PIGYYdugJyurdqzZPVvHAdfqQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747362345; c=relaxed/simple;
	bh=Z7+vvUXtgKA6y3W5tDsX2TXo3q+jsbw2ac6IxSFBrjw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=G/sPHy8I4n8NrSdsL3aYZPPxcguWvZiuXkbXm/+2ePwQ8piN98LTnu5kJXxBk2FPVZM6apg9fgBiuSYKnLjE4+SDRqOFOCIdFJwF6tMr5eJBEqHULofYcNjgzT+ikyPiWL/8mM9NWJzUgI82tQAP0oF1jRFi0hd5LKbIevXxghQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Qc95J+aS; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747362344; x=1778898344;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=Z7+vvUXtgKA6y3W5tDsX2TXo3q+jsbw2ac6IxSFBrjw=;
  b=Qc95J+aS8uic+ZR9MPbdxCykIrvStJCtxaCjsf1trt0gdlByLRKL0K6W
   gI+Pk5mKDhyc5ZUdgqcNXHwFItu5QmE+8ablRwbDhGGjVoODi8kTndPVA
   R6GdnnoDM9dZ07wJ3pirGCQL3QGqxlYuwyjcPjuyi76YWVqWgG0hDMoVW
   agJhnclbjLTdJpjsZS8Ee82KjyJ7tWNnvqfN9chhGgtK3gY+d6KroQfLQ
   jRZhn9Y8xmVe3bc49Mh5avLXOSPoqMs/LQtH0vkYj6UC9krvM3MTaq8xp
   TxnTSv+8gGWLBLg3xq7AB/Gb1Hom4PdcfaERYrM1ND7J4epnYIhjUd6GK
   w==;
X-CSE-ConnectionGUID: oVlt+/NYQUC3U+rizEpccQ==
X-CSE-MsgGUID: ltgxVmcYT72bKA1s6MYKXQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11434"; a="66873729"
X-IronPort-AV: E=Sophos;i="6.15,292,1739865600"; 
   d="scan'208";a="66873729"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 19:25:42 -0700
X-CSE-ConnectionGUID: bpuRQxnESYCAXOTEgfUkeQ==
X-CSE-MsgGUID: 6bFjFpr3RQOcnzdJAsmGjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,292,1739865600"; 
   d="scan'208";a="169487429"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 19:25:42 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 15 May 2025 19:25:41 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 15 May 2025 19:25:41 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.45) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 15 May 2025 19:25:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r0Rp8SMkM1SGGMY8DnYYKXkH7Sfcu7qEV/osVMygz6/Li5lo/M59gE3u68/uu++CNGkuMxTFgf80PHVX6IllN7966iuucQf7airgyM9lpCckRbnqmQWef7qa6G0GZflMXtviTY6bBdzl8nivT5ZHMDercZxDfMJCu1U+1M4UkorH8JWQYNgOY6OYjP8RZUTqZ7v3HtJVZW+BdppDFiZZ8nwdAZNT+XEdkFa0hbIY6bAQdM0ZgVZ8lkpyx63ahbAmV+AmK3Utv8Cdc69fiPzbmbkLp9llYI4jSh806g40U7+5l4CuviHgoVBUepUdTZ8wCw5b7lWZPcNi3bO2dNxkqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tvA4ETVnQQ2hlNrrKpuwF1NNG+G09PfWHj0ddW5ELvU=;
 b=eBJLn9OkwRqWAJ+gVjuAxWicEbHvu5d3c7+BigNu3ToBOs024UUTnOB3f6hlEP1HJlVOgDK3y5R6pUK1Lsr+jmwxtYmOxrwVXThUg4BEcjGdIqxo2sBuvVaWOb1fGOpPr1VyRFr7vJsora9XgL7l+TnKvQj2tAEmmaAFuog7OUe7K8vG9faA+sVgRmMgp+dNNc4ZFNRdBSmGzFjYxHsLefCzL1jMZX7M7XvBicNv8nMJQZ8pgjwlyihSxj7aGjyJHa7mW1d9d6ckTc22SaKlTrVRrxJPTAE0dyfD9B8hb3U2RrxbtoQKnCZYj1D2HYUh1caX1HDsDhLehzC3LWQCmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DM4PR11MB6019.namprd11.prod.outlook.com (2603:10b6:8:60::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8722.31; Fri, 16 May 2025 02:25:37 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8722.031; Fri, 16 May 2025
 02:25:37 +0000
Date: Fri, 16 May 2025 10:23:27 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "Li, Zhiquan1"
	<zhiquan1.li@intel.com>, "tabba@google.com" <tabba@google.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"seanjc@google.com" <seanjc@google.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "Du, Fan" <fan.du@intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun"
	<jun.miao@intel.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 03/21] x86/virt/tdx: Add SEAMCALL wrapper
 tdh_mem_page_demote()
Message-ID: <aCahn+rpeighJP2J@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <20250424030445.32704-1-yan.y.zhao@intel.com>
 <fd626425a201655589b33dd8998bb3191a8f0e2f.camel@intel.com>
 <aCWlGSZyjP5s0kA8@yzhao56-desk.sh.intel.com>
 <81413f081fde380b07533a7839346334bb79d3cf.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <81413f081fde380b07533a7839346334bb79d3cf.camel@intel.com>
X-ClientProxiedBy: KU0P306CA0006.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:17::15) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DM4PR11MB6019:EE_
X-MS-Office365-Filtering-Correlation-Id: df1d2aab-7e30-496e-ddb3-08dd9420f1e3
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?APPYBQk/2DWRQCOiaTXCWoWeCRh9y9+WzCr+kdiT/1M9uNgs4st6c1ngeTXD?=
 =?us-ascii?Q?4eG/mv2TcHuWsJSWjKvJcOVQwf7EJJHeDGVtyTt+hTDpswiS9UEywuL78G7w?=
 =?us-ascii?Q?Pt9upeIFpky3r1DUFXKITIIj0djXISXBqa2rVbKDLBffoYecZ6DNS89grVvU?=
 =?us-ascii?Q?uynclQE5L106bu6ayZ9dblVfOMsTd5TNOdqtsBy5oju+/zCQFTtPGkbKjqNY?=
 =?us-ascii?Q?dPfI6ymh/LOBQE+0Q98H7OmqZGaqD6Hn4YoQ5nqSRWiyyjlGu+fcbjM2MydM?=
 =?us-ascii?Q?TKlggYlIdT6ZdCW0J8ZE3oNsFqf+LI0dUWlWfUuvbPdfDrw9spIPtbSXIL3l?=
 =?us-ascii?Q?VJ+DeSmdsGFpJw6OlUFk9Z0wEUJLarchrM1bprppbH0JK/CJwIIwV2ac3/pw?=
 =?us-ascii?Q?G0il4AGpjJOAth6QX/W2zKubX/lOiqe8iNIz/plidIhWM+tHpVwol3BmhHBp?=
 =?us-ascii?Q?eQZbAF0XxmrSpJoR1vdu5afrsCNdA+w1JXmjgIaRcUCfuaWly93nGnAvJ/OF?=
 =?us-ascii?Q?A3Tyil7veY4f/yhCALIDwyJyHD+AMJQdLovLgZUeRYUXsT3Fk7RRElM20lGG?=
 =?us-ascii?Q?q1doWSPq51ABBJ+BZsZA/mME4VDUoHirq+gc/xfdvSzkbWyykFUQRbCStJxl?=
 =?us-ascii?Q?+3x2MX/6HxuwVPUcctfDcNptwH+KR2rP+VZHLSm/Pbx8UUT/U/OgrP1zXjqA?=
 =?us-ascii?Q?LwKr7V4ygOqtF9H2y1WxmJ+Y71hwiAjDOKnFrFjH+HuT57vWYUX59ySMPE+A?=
 =?us-ascii?Q?385dyL2lbst5fLznaulAg5ndewD5JbFTJ5mri5U3atOgL2dcTuKAztt8CMBd?=
 =?us-ascii?Q?/0ak6M3YNxypGOJiZRz6pcgUHyIwnTFYjXcXdy3a44p4XHYlPOSW5A7mlaOO?=
 =?us-ascii?Q?xK2UBWoixiUdfS5xZpe00qhrhuI5DudFG2LOCbPB6fufQnv8+2tOixbQSid6?=
 =?us-ascii?Q?xjjqBdlKMKB7q5Lfahnlp1ikt3eW8kRUr3LulAetXmpagSTGd+q8tostU+qH?=
 =?us-ascii?Q?4a7aXMvGs3QKy27/UWr7dmS+hz1nN9nEVg0MMHNqW2BSQd+leYqATTjXooZO?=
 =?us-ascii?Q?bX9MWdWH7WbJ/2FsxnHQy8ESIwVivLQLSmCYcIP/pl0h121hifvX52EC58SP?=
 =?us-ascii?Q?icIe5a84aeAn1/gY7H185yLpbo+oWfNNAXw5tR+i0SxrJ9PU9iyy2naEeeis?=
 =?us-ascii?Q?3XEBVZV1awt66mniCc99KsoUNmK9C+ZxkhrsqKlJoYcfP4NqIQ69aEufC6zG?=
 =?us-ascii?Q?syM2tDUVQTpDai5syewKpZAzjMa2WMkK0Um5BD3tHxHmAabPcNn68PPHQMu6?=
 =?us-ascii?Q?qIFZEP2OF/WLmJ1dpmMxbH/XChlt9f7tZbZxq2KHuB5A+mjYXAv/YreJSApV?=
 =?us-ascii?Q?+KnZvemVPD4a8BrfUeqiL3wibDlMvyQlbKjDxb7W14zNiHGhOsVAVAfP5oR/?=
 =?us-ascii?Q?MPNIAemaUuQ=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pGQ6JH4FSCIZuo4BSYptingGb5LmBR6ZvOnOBX4LXZFM2igQx2oZrFsq0sSk?=
 =?us-ascii?Q?/R6b+72bj2dMovCzPYWYAvzuqB/I01UHyRfhCZ3yMx1F7yqK0kwfzx3mQoSL?=
 =?us-ascii?Q?HyTzg84LBy2OauPeUPGZ9d2CnONe9oWrwQYNeTy2OCrenQCLlXM3ic3Nz41y?=
 =?us-ascii?Q?WKbyJLWSgYY90xCefIvYOrE/fLb8Oo9bUmnIUR7ldM/do311Isvf1PQC8UIi?=
 =?us-ascii?Q?bkrV/3rqon3A8bNJNgwUFNxwnGPhd5SqUJtECcgG6iZOlKDfBvldM213g0nz?=
 =?us-ascii?Q?bwxR6/8OygSmznlVr2M+5DQoLwpEMKd8a3EhAa6Loh3TFl2/RbkHhnjMuvNh?=
 =?us-ascii?Q?4gvYUpzMlU4OcgZU8vacn9Tflnm+dM4FiFfVvBMTaTMJx+0Y7SuvQpMxZOUT?=
 =?us-ascii?Q?wL9Ju4ce6rfbuyy9g84fAskx5AsswaNZUd4rKWW2O8rF3WYhgNzW0zaon8Jh?=
 =?us-ascii?Q?EqLEUJ2X+EOCtTfjX9rfiz0GHmF4uodYlOO3fg4AAZ32INox6aXZNSi2aiRU?=
 =?us-ascii?Q?7Mjrep3G8LtscmQq6fPkO7TeFiDcgV2ugME78wA2FJDnC0lmSdQ41qAN3SH9?=
 =?us-ascii?Q?nFkxqbPdnQwmpklP2RaNPWENR0mL/MGjYz7WIcv0XumAD96raJHo+InmnSps?=
 =?us-ascii?Q?SL0DyHMMlC7JfUZidLB3WBkEG69Vhbr9YBDxiaLiwHhLVVT1liIkk+7KIY4Q?=
 =?us-ascii?Q?qHHCSU6ydMMMF3GC6nKtBO84/HJ/ikTX9VIcgtZAO2W+n7GCQUxQ2Peavsy5?=
 =?us-ascii?Q?+miR13Iho+EPHkVlwhTNNQ+8oYq7oeq3KsxigF/CSZ45Koofub5qe8NW/FcW?=
 =?us-ascii?Q?RjJRcamcOURhIrxroIL8YyBgnd6nXkN2aQ0Wnbbv+5vl8rRZltj9hBvy+Q8n?=
 =?us-ascii?Q?kLyFOKDH6rD0me1Z/ohwSzyKhIpeYY88aSYWXIHcgTmAIDqU3aCy2mqgM5Vy?=
 =?us-ascii?Q?aBg7vD64l0kfkhAz7VkDc7/Vo6sKdEZO42Ypm2+HinWSzVU/0vpAJTCiRLdq?=
 =?us-ascii?Q?OoqQ9Kbq15JDa5QqkkglXltrfs3zvfiRPXwF1yNOL3kNiZBsn3lp4BS4z1O6?=
 =?us-ascii?Q?LenDqRw4O4KosJyogks2cgsKXe/z2J1ITBGnz0ZaKXDh/lv7I/HoO6yKc10T?=
 =?us-ascii?Q?sC6L5q7vVB7Hwt4hjNOOSQg+z6C+rlUyup+sSM7QyNRLvmQITDvAeAvrjS5M?=
 =?us-ascii?Q?NZQrKTGIB50vnoSToSKVKsD9cLuCKoGKlxrMOLz5iuXOaqfdciBXile5yLSI?=
 =?us-ascii?Q?f611eZ8x38fPa1aY+e7Iq7vcvy7fgP7eE1lSLPK1LK5KIb6mjvBoBVtR8CT0?=
 =?us-ascii?Q?DGXk1GWbIIhQJY/1RloGS7uDyRB0C0WD6/MxftV7fHIdkkjx3U8bv6E9HJ4U?=
 =?us-ascii?Q?hcgGPy02RJC9/uSGUrSOZRHhQa0zletSiSnjBbm+suRRlhT4MxO8Iurv+iUm?=
 =?us-ascii?Q?GsSHgHnbv1NVs0xCX1+JqLZh5msbUvhBNgXdowJ8+QXBAyR6jjNlkJdBGNAR?=
 =?us-ascii?Q?KTpPSFOZjcgDKqA3b75iBgTZ+FgH48Lhyw9lSSFQRlVCxkanW5aaFuMHdiDM?=
 =?us-ascii?Q?5ibfzv/D+mN+OzVsCT7LxKADZIp8pGvolgavOYnQ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: df1d2aab-7e30-496e-ddb3-08dd9420f1e3
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2025 02:25:37.6659
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N8AS7qr4uEIEe3oXFFquzCKMrs0oiu2/ETvyCMNniywrNoouiY55xi4YS5SzVded0nu7JSwIvl1m7lcxqBQhpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6019
X-OriginatorOrg: intel.com

On Fri, May 16, 2025 at 01:28:52AM +0800, Edgecombe, Rick P wrote:
> On Thu, 2025-05-15 at 16:26 +0800, Yan Zhao wrote:
> > On Wed, May 14, 2025 at 02:19:56AM +0800, Edgecombe, Rick P wrote:
> > > On Thu, 2025-04-24 at 11:04 +0800, Yan Zhao wrote:
> > > > From: Xiaoyao Li <xiaoyao.li@intel.com>
> > > > 
> > > > Add a wrapper tdh_mem_page_demote() to invoke SEAMCALL TDH_MEM_PAGE_DEMOTE
> > > > to demote a huge leaf entry to a non-leaf entry in S-EPT. Currently, the
> > > > TDX module only supports demotion of a 2M huge leaf entry. After a
> > > > successful demotion, the old 2M huge leaf entry in S-EPT is replaced with a
> > > > non-leaf entry, linking to the newly-added page table page. The newly
> > > > linked page table page then contains 512 leaf entries, pointing to the 2M
> > > > guest private pages.
> > > > 
> > > > The "gpa" and "level" direct the TDX module to search and find the old
> > > > huge leaf entry.
> > > > 
> > > > As the new non-leaf entry points to a page table page, callers need to
> > > > pass in the page table page in parameter "page".
> > > > 
> > > > In case of S-EPT walk failure, the entry, level and state where the error
> > > > was detected are returned in ext_err1 and ext_err2.
> > > > 
> > > > On interrupt pending, SEAMCALL TDH_MEM_PAGE_DEMOTE returns error
> > > > TDX_INTERRUPTED_RESTARTABLE.
> > > > 
> > > > [Yan: Rebased and split patch, wrote changelog]
> > > 
> > > We should add the level of detail here like we did for the base series ones.
> > I'll provide changelog details under "---" of each patch in the next version.
> 
> I mean the commit log (above the "---") needs the same tip style treatment as
> the other SEAMCALL wrapper patches.
I thought I have followed the style.
Sorry that if you think the commit msg is too simple without showing details
of this SEAMCALL. I can provide a detailed on in the next version if that's the
concern you mentioned above.

> >  
> > > > 
> > > > Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> > > > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > > > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > > > ---
> > > >  arch/x86/include/asm/tdx.h  |  2 ++
> > > >  arch/x86/virt/vmx/tdx/tdx.c | 20 ++++++++++++++++++++
> > > >  arch/x86/virt/vmx/tdx/tdx.h |  1 +
> > > >  3 files changed, 23 insertions(+)
> > > > 
> > > > diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> > > > index 26ffc792e673..08eff4b2f5e7 100644
> > > > --- a/arch/x86/include/asm/tdx.h
> > > > +++ b/arch/x86/include/asm/tdx.h
> > > > @@ -177,6 +177,8 @@ u64 tdh_mng_key_config(struct tdx_td *td);
> > > >  u64 tdh_mng_create(struct tdx_td *td, u16 hkid);
> > > >  u64 tdh_vp_create(struct tdx_td *td, struct tdx_vp *vp);
> > > >  u64 tdh_mng_rd(struct tdx_td *td, u64 field, u64 *data);
> > > > +u64 tdh_mem_page_demote(struct tdx_td *td, u64 gpa, int level, struct page *page,
> > > > +			u64 *ext_err1, u64 *ext_err2);
> > > >  u64 tdh_mr_extend(struct tdx_td *td, u64 gpa, u64 *ext_err1, u64 *ext_err2);
> > > >  u64 tdh_mr_finalize(struct tdx_td *td);
> > > >  u64 tdh_vp_flush(struct tdx_vp *vp);
> > > > diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> > > > index a66d501b5677..5699dfe500d9 100644
> > > > --- a/arch/x86/virt/vmx/tdx/tdx.c
> > > > +++ b/arch/x86/virt/vmx/tdx/tdx.c
> > > > @@ -1684,6 +1684,26 @@ u64 tdh_mng_rd(struct tdx_td *td, u64 field, u64 *data)
> > > >  }
> > > >  EXPORT_SYMBOL_GPL(tdh_mng_rd);
> > > >  
> > > > +u64 tdh_mem_page_demote(struct tdx_td *td, u64 gpa, int level, struct page *page,
> > > > +			u64 *ext_err1, u64 *ext_err2)
> > > > +{
> > > > +	struct tdx_module_args args = {
> > > > +		.rcx = gpa | level,
> > > 
> > > This will only ever be level 2MB, how about dropping the arg?
> > Do you mean hardcoding level to be 2MB in tdh_mem_page_demote()?
> 
> Yea, we don't support 1GB, so the level arg on the wrapper is superfluous.
I'm not sure. It's not like tdh_mem_page_add() where the TDX module just only
supports 4KB.

But your point that permitting 1GB in tdh_mem_page_demote() in x86 code until
after KVM TDX code adds 1GB support also makes sense.

> > The SEAMCALL TDH_MEM_PAGE_DEMOTE supports level of 1GB in current TDX module.
> > 
> > > > +		.rdx = tdx_tdr_pa(td),
> > > > +		.r8 = page_to_phys(page),
> > > > +	};
> > > > +	u64 ret;
> > > > +
> > > > +	tdx_clflush_page(page);
> > > > +	ret = seamcall_ret(TDH_MEM_PAGE_DEMOTE, &args);
> > > > +
> > > > +	*ext_err1 = args.rcx;
> > > > +	*ext_err2 = args.rdx;
 

