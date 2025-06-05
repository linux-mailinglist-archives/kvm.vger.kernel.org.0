Return-Path: <kvm+bounces-48505-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B9C8EACEC04
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 10:34:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7ABFD169636
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 08:34:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6443E20A5F1;
	Thu,  5 Jun 2025 08:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gC4pF/6k"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC0711E7C03;
	Thu,  5 Jun 2025 08:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749112480; cv=fail; b=jcN3Kg7LlSUCMy7hKRhmgI4VgJdwl8hSzvmjoyVDAWy7ekaO/SXgNuJRtHCbt9HfMYm1eF3T4rrfsBiKPi+yHHx5NZCY374u2ss50h+FdeNo+1vXF5rysf+HqdlGbwUaReTN0oaxyCf6l4zo4NPaaEptCAZKV4RECkHYFa/O4lw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749112480; c=relaxed/simple;
	bh=hTwU+bUMqatiP7JNRsIn9sfOrfnATlelRtiGIdV2NUQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=mvfg2V8fNww5y67Bsk/a7lrDgiPWuTOLSKQ/aRk09SFK9oojL/IDgnwpA/OyyUo6u4mgKlsApD7vHKEizetjBPPGm8hiG21cnExFqNBStbusJPEcWAj3wuyEeoMm8sN30krFIYNglAaaaf8BODsluFAFZOADrnxos40pScpcYS8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gC4pF/6k; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749112479; x=1780648479;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=hTwU+bUMqatiP7JNRsIn9sfOrfnATlelRtiGIdV2NUQ=;
  b=gC4pF/6kxCNbZk1GIwjw2ew0o+nnJsrq+/dZYSvHZscWem0fHZLDO5ov
   qcLLo8wR5+VqGDvf5MfLLV3sPs/xbMBKoM+rAdUf093TJmTW/g+sa9S/9
   fXkxASuYznEAwjB91liP5xpIS7P0N51GaVoJpG031drryAbqcRYIEOxPA
   ub3zrSv65CZu4RTzkkQ0n2pHbmVZe10SSemdwRVBNmqwH8lkdZZLf/wDS
   cqeA3n+8jcl268/n9IfHjU3KH+RFtn/jExwbZkitAJGpVUSyV7I1m1a9M
   QfBEU6mOH+kpAUCuHceakDElyAtBFxjnKpYEOI0SXUDgAsDP7xPIgbZMX
   Q==;
X-CSE-ConnectionGUID: 0liFfBeMQB+AQLcFqVrD6A==
X-CSE-MsgGUID: /HlPfsP9RESyxolYWSYF0w==
X-IronPort-AV: E=McAfee;i="6800,10657,11454"; a="51367678"
X-IronPort-AV: E=Sophos;i="6.16,211,1744095600"; 
   d="scan'208";a="51367678"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2025 01:34:38 -0700
X-CSE-ConnectionGUID: cR1F6PsuTn6gK5lh72E28w==
X-CSE-MsgGUID: 1Y/EAypBT6ihZ7nb7lJdVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,211,1744095600"; 
   d="scan'208";a="176392914"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2025 01:34:37 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 5 Jun 2025 01:34:37 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 5 Jun 2025 01:34:37 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (40.107.101.84)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 5 Jun 2025 01:34:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B+CKADeY9YQmVXjZHUnK5QtdjJ2Lu8T3yGzdCd3rrsib8Ogl1x2uPwM834cSNLyBqATd9FD7oe+KgtzOoqXO2eMESbRjznYfDsgSyFJrg1gXyKK2misjlJdDsMLBPj6BqiOgzCEZ+lXm0s8AizIoGeLe8XivN73dTWpSVZ2rf5qB0O4b0ZfW5f33O2q0CBRu6aLWUM5ShUH762yA2Wi8u837vCmsm6QmM0dNnspLI9usjFIFR32MQW3h5QGbWYfR/xokmKxj6grnnZ8v2mvaYZp/E1QZ9G7KVr9sW4r2Jc6U/EdNMivzFiq1sRAq7ekR0FTar9U4hp+e9kOWLBb4KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CiHEEHs8Elkv5AVKgmApjeQkFKgSJzVeo9ef86ZKltk=;
 b=wlbVpkKpcE7sUo9JaE71vjlAwFuQTRMXxjjVoCiBe4WxYLp8BT5avvHSoHZsv3EKEa4/dvDD+iq4cEYmx6UViRXXbNOYB2hrE1AD23GszjDCyzc8SZLoLCcw7TZwBYywS1ZqGYujzHjrpv+4aZ3dZe8A3KxMpRKd3vSh1aUeIiL0h6q9XgNcX7tTV5ZnMrmKrGUe2B6lndInn6yFO2rOd57t7vlohIDXLk3cOslfo/U0SaS1BvH5J0bCN4V9Of5M7/2YpavoSaU4PGyT7SJQ7e5SOvAvNUmY7meNOiLV13NQt+dvyFl2K+XgSjdddjZP34+9B59hq0R28JIiVXJ2AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SA3PR11MB7462.namprd11.prod.outlook.com (2603:10b6:806:31d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.26; Thu, 5 Jun
 2025 08:34:21 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.8769.031; Thu, 5 Jun 2025
 08:34:21 +0000
Date: Thu, 5 Jun 2025 16:34:09 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "x86@kernel.org" <x86@kernel.org>, "Shutemov,
 Kirill" <kirill.shutemov@intel.com>, "Dong, Eddie" <eddie.dong@intel.com>,
	"Hansen, Dave" <dave.hansen@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "Reshetova, Elena"
	<elena.reshetova@intel.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "Chen,
 Farrah" <farrah.chen@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>, "Williams, Dan
 J" <dan.j.williams@intel.com>
Subject: Re: [RFC PATCH 04/20] x86/virt/tdx: Introduce a "tdx" subsystem and
 "tsm" device
Message-ID: <aEFWgV0a2kLI62Bf@intel.com>
References: <20250523095322.88774-1-chao.gao@intel.com>
 <20250523095322.88774-5-chao.gao@intel.com>
 <61fd680c4e4afd5eb4455ee0dbbb05c30f0e7a0d.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <61fd680c4e4afd5eb4455ee0dbbb05c30f0e7a0d.camel@intel.com>
X-ClientProxiedBy: SG2PR02CA0028.apcprd02.prod.outlook.com
 (2603:1096:3:18::16) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SA3PR11MB7462:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c69badd-2da3-4d4c-01de-08dda40bc52c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?yrvfMagAXs1V/uZ9VVTlrzJI4/O7ZcHx9LHG/IR/AbpB8dV0FjeJgXJLJF4a?=
 =?us-ascii?Q?sXavUm5anO9bJbaYcfsSVfdJ/3FjX7PVKE6juezG/Jv9kUw7s12U/tyBN+L0?=
 =?us-ascii?Q?++xCqzzgQ0elNd/69PG4v8uCFZMljNGb9yyE9ByaWCBBYnMWnBdAbAUT0A1A?=
 =?us-ascii?Q?BsKkGl0XS1Qu5GkK3ehzzpvZ7JoUkqolPvg2MKsUyu4oQgw5a9cSBJzNMbhW?=
 =?us-ascii?Q?g4OF/CK59duNCc5ctQw6/u1mYfcedy4hdHC0XMborFTDOw+wjvNOYZGplC5C?=
 =?us-ascii?Q?PC+Odb3QTBjV6v5teeQqPn/ycZjfLiC87dXcCm126NQf61MYkBOHDgvVIZFe?=
 =?us-ascii?Q?0HHuHjKci3zAnVoXnvc+9lvBGJDwZ8rtDTR4YJYSIlqD9nIkywaGuTRbiQzp?=
 =?us-ascii?Q?PnmtrJ7XKer2SdJHZFBTifJwZRyufxjkIy5RGbj2B1/OE+S7Mv9jeuZYxrgV?=
 =?us-ascii?Q?DrqqWidl3ugGtv3QSaxwb1thF7rICW9LKrM7cu3Ypmffn04BduTxOtRKxd5n?=
 =?us-ascii?Q?e0/OoKSdNwiblNzdZ1+Dd3+NLPOfUBBzRpSxgwNbx96Wz2XRC+8LpWWalB6v?=
 =?us-ascii?Q?f8QUN1vGT36+F/dtKT4MIaJyoYjfIM8JKn9B1Ud820oK4O5vgG6MlUPQlVBn?=
 =?us-ascii?Q?cWjnQZyRZUU+eCiBNybUVq8nIgyO6PpvtHUB61v3S+Hp9ALBG0KrZeP8Yl50?=
 =?us-ascii?Q?xBLIsAToDb1Cuj1aKTPdpmNcB1Fup0qOzXlOhM1KH4fVLIL1Sh97WURibvSZ?=
 =?us-ascii?Q?BJCbK30cLrpdmhzIJAU55kE0oSyEmYA1146qc9Lsw7O4MPGgkCMdOqSqai74?=
 =?us-ascii?Q?BdLcFmZxG7IwCo4mHI8wl5eCvQaOWPVURMRrhodmGfXgALTzLgI3uP7w0Cma?=
 =?us-ascii?Q?IvQYgiKXH6R9usL32KL9vTWi2MNKw9/V+78fnJAOi/F5iU98Z4p8KcA9kwRp?=
 =?us-ascii?Q?iJK5e9hMUK2DZxyYgwGxLyuBXtmTTn8WE+SRMUBqAdX12DrXlho0WXvydNRN?=
 =?us-ascii?Q?iSleGiyn3kahmTJmvaABviNZP9Irpintp2iZOnPOJDjJ97cbxbbaP4mfR1Ou?=
 =?us-ascii?Q?AHMpGPI65CjdY4y2pKZbDhnufvBR698Izv/vqg6BaV0IoA1/fmaYVYn7oIe4?=
 =?us-ascii?Q?pCB/RAcWKyiZGFbw6OWDdQQnOgv90rbOtWOsxLDsN8SSQkG1kaA0sA4d2Uup?=
 =?us-ascii?Q?IeXJjUX/cVdPr/QqrGvXSOM04pVZ5ZRZWgmrEhXlzT5miPlF+wLXuI2GO30+?=
 =?us-ascii?Q?cBT5NxA1hOwL7iFAG9l/XTfCxthtQ/MJiD/ZmeqKRbCQLwVay4S3NSI1zWQS?=
 =?us-ascii?Q?pLct+RYFwsy5HRNAayGJNpBOfyw3fa6HTCO7kB4HRpDdIfnBFHg5Hy4kQ+Q0?=
 =?us-ascii?Q?5i1q2nAA7uxroXu8QNNO5WOJli72vau1dciHMAkfMGO2eL9KS3jJyJ9nesjO?=
 =?us-ascii?Q?XlWJzNM0gt4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?H+F/OTc1ej9KBIv8b+puSgCa6lN86wLDE0zD7z2qpfAUuuN603YOILHWK3/e?=
 =?us-ascii?Q?gPNF/wDO6Vly0THrD3wQydYPbjIoeTHTS+21+WndOl305gqJx2BI+EfGwWZi?=
 =?us-ascii?Q?3TZS0npwfL6q9L8N6cRRvihPXdrxhQE9x6Daq4opGABBZogbfLhDE9e+C7iv?=
 =?us-ascii?Q?mk4kxI/4pBUPyYa9omaSyErai+1tYmaKDJo64D5KbMOc4lZk/tOnrpobmmkC?=
 =?us-ascii?Q?bNQ0X+XeTgnpwMWeKJwnnDTzhEn83bYSUcieQVTicRM1+ZYqJB/RX/a6USl/?=
 =?us-ascii?Q?MLD2iOzEvjx4j2RCZ2NLe5uq/UWx8Mq4eM1ZvIiKIH/DrptWCthfF6aNAtVK?=
 =?us-ascii?Q?GCe/iVpzBRJigLhyvFYy0VOXYWF6s0wyldm9X89ie8qMChi1nAgEu01WgGXU?=
 =?us-ascii?Q?GiphKUxNTCP+trjMZcCWGhXOEuaayq0CFF0crCrLqmCX3nZqfpcHOW567USR?=
 =?us-ascii?Q?DU98BIo65EAwM6AnUpWwaEUeIz4B6GB8FfzScGCyX5facYzQ605PsJs80VUQ?=
 =?us-ascii?Q?pPwdA/w9we0hy5NAw4kSI/XZPdPHOnkv2umHjZH5LYBMwUgma6UViJw2oTbx?=
 =?us-ascii?Q?DLZY7gdeCUQpmZKrcmQ/BM+N9zNeKpOXb2fLXvr+tfoVLST9nbWjIlb5c4JZ?=
 =?us-ascii?Q?R2XRJPj3kuu2q2MLTMQS3PJtYYkpfOtBCZqI3NwY9xI79YJFuMwFpzT9V1tb?=
 =?us-ascii?Q?lNS4JTMq9aH5oSCqDWXbYyHkgGbloKEy985mhMObD9oo46I1b0CJTL46t7Tc?=
 =?us-ascii?Q?ccMQZr8NZVlSK4Ly20Q9PZmZhrNnky0inF1BbjvoKuB7OzgXv6B6S2Eq2DNC?=
 =?us-ascii?Q?Nr3zmEtwO1/T3wsDnF6r0AEhvJRB/VThJsVnM6+fDqaUx/RiNyrZjXdNytMM?=
 =?us-ascii?Q?/8Ul+fJKFN84azLYpfvxb0RGaOITf0ES2sZRqXnhLfjnC8EQW0j7uiOzqTuf?=
 =?us-ascii?Q?ZFBoj/sfjhwjGyYtg2GAZ8ykCBb0hGH2onbOvSol3WhueaF+ihMwHAyxqgh5?=
 =?us-ascii?Q?madegcXp2fyHBUCnR9ODUzhwATO9RDWfU1cseMdvnpRnuc1f7UJtORBS1EzP?=
 =?us-ascii?Q?4hAhyn7rqVurwBfK38666odSlDumvG6E/mmvOaTgd7Ut1hOOl+qHYs54HhK8?=
 =?us-ascii?Q?Oh8ht3ELcHS92OBRlZzZ1BKmJAUInN3xJs+CixGw84bR7WpCRqqxhuz3ddi2?=
 =?us-ascii?Q?bvLC+iw3haTiyvD4w74CG/DS62K49AeyCEFD5J7iuJestuE+urtkx0wVh3u6?=
 =?us-ascii?Q?y/Tfc2fzUEUgl6RIFT7b0w2BAhC/NW73Lv1suHXt1lOosxUMgBEXffQ/0aC4?=
 =?us-ascii?Q?koVZfd5sB29x8EtBWvohWryhocJIoAg1tRQOh6ryv7uMEzTpVdRldgQINtn+?=
 =?us-ascii?Q?2wVloljylQQpUYJXyHczthmGXtIOUFIJ7S4nqORkmVWD10mbJ9zSVk0o9+CI?=
 =?us-ascii?Q?/VfekpdYIUqUzXY+Kh2EKZV9iCZgHykq/q8oFEtm4XCEhsxjRt1fOhaO1/cp?=
 =?us-ascii?Q?e3wL/LyikN6dwdVTSM1Cx3N2twpXhVKMHmL6dNWZBoeB1V2UyOeRdoCbxlaD?=
 =?us-ascii?Q?yTApAcENknxiGZP3PtKcgQHTTzfPJ2evtNHOnjyr?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c69badd-2da3-4d4c-01de-08dda40bc52c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2025 08:34:21.7605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5zKtSNGLBoeLH+pC2g8EkJyHLy+R9Fwe9FbqM7/aQj1S4plgeNXlfL2Iv7REcX6z1l36lsbwGsclRec7CYeiUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7462
X-OriginatorOrg: intel.com

On Tue, Jun 03, 2025 at 07:44:08AM +0800, Huang, Kai wrote:
>
>>  static int init_tdx_module(void)
>>  {
>>  	int ret;
>> @@ -1136,6 +1209,8 @@ static int init_tdx_module(void)
>>  
>>  	pr_info("%lu KB allocated for PAMT\n", tdmrs_count_pamt_kb(&tdx_tdmr_list));
>>  
>> +	tdx_subsys_init();
>> +
>>  out_put_tdxmem:
>>  	/*
>>  	 * @tdx_memlist is written here and read at memory hotplug time.
>
>The error handling of init_module_module() is already very heavy.  Although
>tdx_subsys_init() doesn't return any error, I would prefer to putting
>tdx_subsys_init() to __tdx_enable() (the caller of init_tdx_module()) so that
>init_tdx_module() can just focus on initializing the TDX module.

Sounds good. Will do.

btw, I think we can use guard() to simplify the error-handling a bit, e.g.,

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index a755cdef69d2..0b93064b9e0f 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1218,11 +1218,11 @@ static int init_tdx_module(void)
	 * holding mem_hotplug_lock read-lock as the memory hotplug code
	 * path reads the @tdx_memlist to reject any new memory.
	 */
-	get_online_mems();
+	guard(online_mems)();
 
	ret = build_tdx_memlist(&tdx_memlist);
	if (ret)
-		goto out_put_tdxmem;
+		return ret;
 
	/* Allocate enough space for constructing TDMRs */
	ret = alloc_tdmr_list(&tdx_tdmr_list, &tdx_sysinfo.tdmr);
@@ -1253,13 +1253,7 @@ static int init_tdx_module(void)
 
	tdx_subsys_init();
 
-out_put_tdxmem:
-	/*
-	 * @tdx_memlist is written here and read at memory hotplug time.
-	 * Lock out memory hotplug code while building it.
-	 */
-	put_online_mems();
-	return ret;
+	return 0;
 
 err_reset_pamts:
	/*
@@ -1283,7 +1277,7 @@ static int init_tdx_module(void)
	free_tdmr_list(&tdx_tdmr_list);
 err_free_tdxmem:
	free_tdx_memlist(&tdx_memlist);
-	goto out_put_tdxmem;
+	return ret;
 }
 
 static int __tdx_enable(void)
diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index eaac5ae8c05c..a0c0535a9122 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -2,6 +2,7 @@
 #ifndef __LINUX_MEMORY_HOTPLUG_H
 #define __LINUX_MEMORY_HOTPLUG_H
 
+#include <linux/cleanup.h>
 #include <linux/mmzone.h>
 #include <linux/spinlock.h>
 #include <linux/notifier.h>
@@ -172,6 +173,7 @@ int add_pages(int nid, unsigned long start_pfn, unsigned long nr_pages,
 
 void get_online_mems(void);
 void put_online_mems(void);
+DEFINE_LOCK_GUARD_0(online_mems, get_online_mems(), put_online_mems())
 
 void mem_hotplug_begin(void);
 void mem_hotplug_done(void);

