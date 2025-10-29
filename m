Return-Path: <kvm+bounces-61419-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id D2925C1D453
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 21:46:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 7FA6C4E25AF
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 20:46:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 945993115B5;
	Wed, 29 Oct 2025 20:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NWIZwJND"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE281805E;
	Wed, 29 Oct 2025 20:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761770779; cv=fail; b=UNNHQGAd1CFGmQ2M9FFWTUTNyhC/O0RQl6oKmMb70tX88aj+9j9am2tyKGHMvlCgY6inKuMERN4q39boyT5ZcraoGmA+THEwJZisCmO5hSioE8o2golM9bjgeAB9/k4qL/e7qJYbXfLUrq6MILgz/fx70LrvG/X2GDI7evvoXzM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761770779; c=relaxed/simple;
	bh=zXxjcWnXnFJoBvBsf/KFoHIukVA6nUgKgrRJ2Z68OCQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=AANd/xk1TZZOPkeUaeVVY9X1u1hXao73dGEJ4cqJTmMBYs1WHwB7WrpsyJcUdCGyysfZK+GXaMziX+GFensjThXqZ4daYsI1RcMJlYiObfU0682TBpsPbuVHQ9jHgF73Rd7NzzboZAMhHyVqZKHYObgsozDCOQ23HjvkMorMnyQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NWIZwJND; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761770778; x=1793306778;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=zXxjcWnXnFJoBvBsf/KFoHIukVA6nUgKgrRJ2Z68OCQ=;
  b=NWIZwJNDeA7zn635hU6B9ALPnFgDvZUA8qyaoAdQX87BBzIHDVeZhI5+
   JHM9uX04FhBHfAGE2FxNFUcyjLibSdcCoHfDFvfXFzn0xoYvcAEv3Vo7O
   ZqH9XrP1ToTiv9ht3jmMYsKOHn7c9XFavr/aYCwKUuPTJrXdZKb/crRF1
   x0p2J14FECbJF7kjvpJgOUw9GrbXEARUJKMJpIUhR4bXsj8S/aHNH9LTi
   oUvQvM3HFz62d8Po4P4WCwn06dA63hlIECk9wcjzcXRSw48gmw2UHkXE/
   DT2rP/Izzsa/HvxxXPp82UUTrDJX0y5zFlmqc77mVd2FcECbbnM5FsdbU
   A==;
X-CSE-ConnectionGUID: VF5iMN0kRzqexjcVyx/ryQ==
X-CSE-MsgGUID: XhahXrs0TiSpuOedfzUEiA==
X-IronPort-AV: E=McAfee;i="6800,10657,11597"; a="63604908"
X-IronPort-AV: E=Sophos;i="6.19,264,1754982000"; 
   d="scan'208";a="63604908"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 13:46:17 -0700
X-CSE-ConnectionGUID: EJzkuq2TSNyqKP21NdrLVA==
X-CSE-MsgGUID: ls44Dv0jRry8A78+LFtKZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,264,1754982000"; 
   d="scan'208";a="186511554"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 13:46:16 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 29 Oct 2025 13:46:15 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 29 Oct 2025 13:46:14 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.26) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 29 Oct 2025 13:46:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CTOMIGfOhMt9IS6zH/2OeiMfG0Oeja/AyDncUZ4aJ2+c0U9DlFGAGBLCSSNJEgG9DTe985pFQwfXEbjNOiWqJECV0yePWJDJ8YRn+T7LYn2KO6vJxwhh5bWs7g2gUTlMmcF+lth08k5IzlUXz6FIRhvkGSVXHhMZcAz+3Y1sCjM8NTYf6jOExA8qOJ1JFgzMQgLUlzD+Jwcepa2dQXUD/oCNpmu1CPETVO+XzN3ZdM1mJf/uEdO/3cOg2JIXbD3W2DtG8NJq0y8ACFxtU9NO8n5DR6DzxZwGQPtveMk/mQ9D5YJ/Ll23XhFwu7tNF2judl7XeOth2XWeRExwFcjmgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZxvCv1PHseZRqjz9YgLbQCLwCns4hkWyPcs+RH3TDN8=;
 b=Z04rKOq/GBbVjXGKh3ipshiqVNwIRQ8yed5t6QI5KYi13R9j7QIZ741I7evELsTfECWuF7EIF1XVLgSZVjS0TGIFtFDRmBZfrRenTQu0oEgkN9Ul2lFqg/TgUf+DNZpG/SEnPWys2sH33SV33CAGhbXpVPrmqpsPXLZKieKoOoUJFf6p7vSXnSHeO166/ljT+G5wqrDzA8OoA4ZxaD2gPiSwdUjzTOrLSJVnFFyj/PCqJO8bAksRD1DiJJBJbRPaKcVwmjq6XfGF12SnCl1bTwXjSFd+Eg0UI4lCZs/7ioppVqppj9e6As3qni1NuEhyNgUGsbgBjzFcuQXrwWbAjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5373.namprd11.prod.outlook.com (2603:10b6:5:394::7) by
 SA3PR11MB7979.namprd11.prod.outlook.com (2603:10b6:806:2f9::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9253.19; Wed, 29 Oct 2025 20:46:12 +0000
Received: from DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39]) by DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39%5]) with mapi id 15.20.9275.011; Wed, 29 Oct 2025
 20:46:11 +0000
Date: Wed, 29 Oct 2025 21:46:08 +0100
From: "Winiarski, Michal" <michal.winiarski@intel.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
CC: Alex Williamson <alex.williamson@redhat.com>, "De Marchi, Lucas"
	<lucas.demarchi@intel.com>, Thomas =?utf-8?Q?Hellstr=C3=B6m?=
	<thomas.hellstrom@linux.intel.com>, "Vivi, Rodrigo" <rodrigo.vivi@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>,
	"intel-xe@lists.freedesktop.org" <intel-xe@lists.freedesktop.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Brost, Matthew"
	<matthew.brost@intel.com>, "Wajdeczko, Michal" <Michal.Wajdeczko@intel.com>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "Jani
 Nikula" <jani.nikula@linux.intel.com>, Joonas Lahtinen
	<joonas.lahtinen@linux.intel.com>, Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, "Laguna,
 Lukasz" <lukasz.laguna@intel.com>
Subject: Re: [PATCH v2 26/26] vfio/xe: Add vendor-specific vfio_pci driver
 for Intel graphics
Message-ID: <5fnnkyi7uhxmtvake3hobz6uzq2g5cx37hfuzrb7e6pes32pxp@3bhfcecpahnc>
References: <20251021224133.577765-1-michal.winiarski@intel.com>
 <20251021224133.577765-27-michal.winiarski@intel.com>
 <BN9PR11MB527666A6CA6D9DD2F948961C8CFCA@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BN9PR11MB527666A6CA6D9DD2F948961C8CFCA@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BE1P281CA0446.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:81::22) To DM4PR11MB5373.namprd11.prod.outlook.com
 (2603:10b6:5:394::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5373:EE_|SA3PR11MB7979:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c59de54-96c1-4cfd-5799-08de172c31e0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?d0IyMnZRK2NRZzVrb3NMUHU0S2k3bWRaanZkSDBOT2x1dlgya2gxYXJHWmdG?=
 =?utf-8?B?M29iTGw5dE9RcnRXOEFrbk85NjlaVHpIcUVMakpZT1E0YndnbzdzWnlkOTdO?=
 =?utf-8?B?Y0ZBZlJLY1ZDbEFvV05WYW5zbTdaSHJYUzhvK1kvbEl4VTYyYXRmYmR0dXhh?=
 =?utf-8?B?MGRRdUx6YlN6UmM1anNIaFhUTStydmxCVnV2R2h6S0lpakNiZ3NTRG8vNHdu?=
 =?utf-8?B?TFpYYUxOdlI3WEtKZlJVL1FURlhTNnRVcW9GSERVZDJBTm1kMVE5NlFFejl3?=
 =?utf-8?B?VlFndmZUY1RjMkF3YmZrWHByS0UrWnVSWFRMNnl0S3M1T0N0aURaTC9CNTIw?=
 =?utf-8?B?d3l5ZCtVTzY1UXFLRHFuRzgvREp2aWtkOExwUlhEbEpoQXNWZ2xTV1JvU1RE?=
 =?utf-8?B?NGFNT2c3ak0wVEcyNElKbXU3SkExWjgzSmlXNFpUTlF1QjlJaDBPckpLSy9M?=
 =?utf-8?B?cmNmYzlFcWtidCtUQUJrWnd1V3NXVFpOOXB3M1ZGMXBlK2tRSXE4aEhKZFpL?=
 =?utf-8?B?QUY2ZHNDdWhsa1B2M1RNTEZjV2hvWXRVNmFheGcyejd4MnluUEJEa1EveFFm?=
 =?utf-8?B?RSs5cmVPRElZWEpjQmNUS1pQM3U5RGxGbUlhSUp5WmxhVUcvemFiczR5MzZk?=
 =?utf-8?B?Z3pOTUt5R2FmdkIxUkczb20wWnZITkRIWkV4dTVmaGtpdWVidTFjelV3Zmlz?=
 =?utf-8?B?SEtMOWIxS3lTRW55MXg2aGlUay9ieHhsbVpEbFpKZUVUZkk5bXFVdjgydHk5?=
 =?utf-8?B?TnFIc0V2b1NSZk94ZFZrdi9ienV1c2JBejlMR0VGZndHUEQ0SmZpblgvUkNO?=
 =?utf-8?B?dEdtTzZoYUtZL1M3M1EycVg2M2dFL2svc1J3K3d3Wkd0MzhmQjNLWnlxVmZ6?=
 =?utf-8?B?R1k5Uyt3Q2hyR2dFNDVnOFYzY1lhWnB0R2ZtenA0U2pJS3VLVnNHbVlQYTlz?=
 =?utf-8?B?ZGhua21RYW4xcFJkQ2xpL3ZuVUJjVUE1STJ1UmdUUXVybE8wNktPclljc2ha?=
 =?utf-8?B?OEFjR08wZE5wRUpPNzloNVhsdXNRckVVTm1sSzVBVCtScnlFa0ZSU0F3dXJK?=
 =?utf-8?B?akI3MmEyTm5UWmRRS056dG5WNnhwMDlrWmRCdDhYRmpST2lUNGMwYyttUXgy?=
 =?utf-8?B?WGJXOURRaUxWY0h1bFRaeHdRYXRieDFRWGgzZE9aUnBic1BPTC9SS25JelI5?=
 =?utf-8?B?Vm1teElRaElVQVVKRVZFYWRncWNKK284TGQ5MXNmTWsxbS9yNGIvNnFmWkdP?=
 =?utf-8?B?N3JoSURwd1JPZFFLSk52bXV5YlZ5SHBtVk5lOHhXZFd1NjRSdmp6ejRjZWt6?=
 =?utf-8?B?azg4R0JPM3JsQnFFVjZjMHVnWEhaM2ZzdEJaNGZXdW9DaU5xSnZRUDdYbS93?=
 =?utf-8?B?U1JBakFwZG10OG1EUzZ0dzhOT1o3Qnd6bGljaVE5UXByTDdPVjZucjJyWHF1?=
 =?utf-8?B?VlRFSjFxc2E2OWoreVN2cmtWYlg0TkNwUTF0SnFnYXhrcWRVTEI1OXdYUmsy?=
 =?utf-8?B?OWRTRVBsaU9LaTVObndsNFh1Y1ZPaWhDeTh1YllLNmUzdlk2eHZpYncybjJR?=
 =?utf-8?B?Vm9ZVnh0Mi93djJjKzBYNTY2S1c1MTBHU1ZESGdTQW1DZ0tXOWs2YWNGeW4x?=
 =?utf-8?B?Q2o5aEdqcUpySzVDVEFNRDdhK0dXQW1DcU1sQ0daUUMvQjB0VFV3Nkh0bHUr?=
 =?utf-8?B?K2l5bXhpNHFnSVgvWDZFbWxMVXJBWkt6aWtRdEtBWlRLbmsrYlAxaE5jNExk?=
 =?utf-8?B?OFVqSXd3SW1OcXNwV2l1Q0U0RWNpeGkvOXJBK0k4V2p3V3pNTDVLQTJNOVo1?=
 =?utf-8?B?V3lFak9OQkNoZEhTRS9WTUJLQThyL0ovUS9aU0g3QnorZkpkQmtVaVZhUk9E?=
 =?utf-8?B?M1pyS1g1aEY0bW5SY2JvYjRWQ1k3WnFyNXVtOUx3R0kzYW4xZTlUa0s3d1Jt?=
 =?utf-8?Q?KfI8lh9zTUtSjLuZKsc1WwmBk440OfN5?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NWNpaWJSemlnbWZwUjBYT0IzN3U2YnY1WHlUM3A0SGlZWmpGOWdieUpFNU1L?=
 =?utf-8?B?Q1M0SzlDOE5vRG1wdUtSODhxcDZwdHVxQVhCZytMYmpDc1pxeDNiQmt6NUpW?=
 =?utf-8?B?VXJUZzZ2UFRjN29FejA5ZHR5UlhPTVdUblBHcDhJMWVxcjNsSXVRVzcvRkZQ?=
 =?utf-8?B?THlWTmNNcEQ0NWFmU0VuZW1sTnVneFQ0MmxEOU9rcGtqdW9qMmFNV2Q4ckt5?=
 =?utf-8?B?NGc3VVk5elZaSUFKckVKMHlsZE9IMjlCV3k3NDRVOFVoOS9hdnk4RU03WERl?=
 =?utf-8?B?SkMwWkViMWxxWmQ4VmRjMGJHbC9XdS9PZnAvcE44cnN3NTFLc3JoSEkxM3du?=
 =?utf-8?B?bDh1NGJRV3pmS1czZzBXYXN4Mnh2am90eTNzMlNmSm5lTFJvSkNJUFVlKzdP?=
 =?utf-8?B?ZUMzK0VwejJzekFaamJua2dISUJBQURVMzd5U3dnanlxM3o2SDF5Kys1U09u?=
 =?utf-8?B?SUxhWUpGOHN0NDg0OTl1dUdsT09aTlNtL0dUTFRlUXpZTVQ5cU93czBTL3pq?=
 =?utf-8?B?NGM1RnlwQVUvb3V1TFVzUDZGbklzTDFDWHlhWWNNOVVNQUJBSnUzaUJ3L3gv?=
 =?utf-8?B?UGRTbVJaS1BMdUl3NWFpWTNTSnhOTzBXQVVxMkkvMmFJWEVBUU9Qb0c5MW1l?=
 =?utf-8?B?bXJ5NjRYR29HSmxDUkZxSElZY3k0UGhyOG5Xdms3ZGZwR2VsYVplT0pSOGxY?=
 =?utf-8?B?eDlaZjRZSm95elNMWm9vN050TUE2R09jY0FWUGVSNGt1NjcyU0Fpb3dYbzFa?=
 =?utf-8?B?UjJZYU91Z25ySzY5dTBZclZjVlNrbmVNZEZ5TkcwUEVvSGJDRlYwR3lkQzhL?=
 =?utf-8?B?ZnE2bEx6QTFHYzZ1c2ZmN25IOTJqSlRHNDNYYWpjMmhrVFFyS0I1Nk9yNXhy?=
 =?utf-8?B?aHZGbW9nL3FHRlQ2L1gvNmorODV4QTdwWE1DL1pyRjJaQkx2MnUvWUdNOTNY?=
 =?utf-8?B?SVBqWnozU21SaVM1dFl3VG5Fc2txK09ZbkwyNGFnOUVlMVpldjVqanhsSWpj?=
 =?utf-8?B?NmJiUkJJL0hXenFDYmlBaVNKT0Jzb2hESFdiekFqQU1QN0lhRDhENzhvaS9v?=
 =?utf-8?B?K25GRDhlK2lYR2NlYWZSRXc5bmErUkt2TnZtK24xMUNOek9lM01kK05jbDgx?=
 =?utf-8?B?OFcrR1lpdnZmUm1iL3J1M3hHYTZRbGZmbXdzYWx1SGNldzVqcUVJcjlkUGpF?=
 =?utf-8?B?WHIvU1NOcVlJTEFuQmFrbGVGbkc2cC83dlQxR2I3NnY3U2VOb21mSGZyUzNa?=
 =?utf-8?B?QnAxejdkS2FmREpVRDZhY2FnWktYbnNyZlJiTVlsTVVkcXRleVdEMnZhNHAz?=
 =?utf-8?B?a3MwQW5pb3krb3R0UHNxTTlaUS9JUkczNGtXZkd0Z0tDUWRYRGR2YlN1cXVs?=
 =?utf-8?B?ajhOVDFuOG1sdXloQkIvckJDaDRzWXdPLzZKNG91YlVvdk1RK2puNUNtbElx?=
 =?utf-8?B?YS8rSlpsN0xxRTZ3NDVhbVRsM3NheVY5Z2Nody9kM0VSV1ZPSUNwdUJFMkkv?=
 =?utf-8?B?Ky9vVnVmNXRrRS96MUJ5L3h0WFNlMTFpS2FybVBzLzlIZGpWQjRuUzN0ekFw?=
 =?utf-8?B?L3NCcVVmLytyUy9YUzNzdEJTMHZaanF4VkU0aDBBWjRhR05UT2RSWU1BaDAy?=
 =?utf-8?B?STliQ204NW5tK2I0Q3ZuZVZ4c0J2YTR5bU13SjFGcnk1MzlpbWJMcnhyNk45?=
 =?utf-8?B?RmdiTzN0UkNzNG1MZWp1ajVndkFraUZQU1RwVkJobkNYYUU3M1pTMElHNE0y?=
 =?utf-8?B?L0FXeklDeUZiVFpWUFhaSHZyTHl5ZUExMTRLZlcwcjBRUDgyV3krQmtaYVQx?=
 =?utf-8?B?NkwrWXRIMTVjMlc4QWNoTzgrc2VTNnNLUzJaVHNzbmN3YXJPSTY1cjh0VUIz?=
 =?utf-8?B?TEVTY3RaV1BtckgxVDFvRnZ1WldXODdjUHdTN2tPYWRPcU1FaFVqelZpdEwv?=
 =?utf-8?B?MDVzTENWMDRTT3R6MU9OMzJXdE9FT01zTjdnaDloZFFNYjZDMitQcFoyTzdO?=
 =?utf-8?B?emVBTis0emtzaUtoNzEwYXF1ZVJIc1FTS0FjTXkzLzRzM0VEbjl6eVJUVjNj?=
 =?utf-8?B?b2hMYy8wRnNjd09iQlRwWG1SR3RkMTZ3RjZLSWxSZi82bll0M1Z6di9qQXBl?=
 =?utf-8?B?aUltaVE0NlJSNGlCUlpTZEloekpEcHJyVkRDUFlHUGhpb2ZZQm5oN3M0QTlN?=
 =?utf-8?B?K0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c59de54-96c1-4cfd-5799-08de172c31e0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2025 20:46:11.8846
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4ay2HenoUx4CTDpARD5kpD+ynGAyFC6ElQfdu8TVPWSoWqpED8/InOgEJatIWKP78CFizgCAmj9QvGzXDnHZKt4X77Q53pes4ETgcbPcq5Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7979
X-OriginatorOrg: intel.com

On Mon, Oct 27, 2025 at 08:24:37AM +0100, Tian, Kevin wrote:
> > From: Winiarski, Michal <michal.winiarski@intel.com>
> > Sent: Wednesday, October 22, 2025 6:42 AM
> > +
> > +/**
> > + * struct xe_vfio_pci_migration_file - file used for reading / writing migration
> > data
> > + */
> 
> let's use the comment style in vfio, i.e. "/*" instead of "/**"

It's a kernel-doc format (it's also used in vfio in some places).
I'll drop it though - because of the comments below.

> 
> > +struct xe_vfio_pci_migration_file {
> > +	/** @filp: pointer to underlying &struct file */
> > +	struct file *filp;
> > +	/** @lock: serializes accesses to migration data */
> > +	struct mutex lock;
> > +	/** @xe_vdev: backpointer to &struct xe_vfio_pci_core_device */
> > +	struct xe_vfio_pci_core_device *xe_vdev;
> 
> above comments are obvious...

Ok - will keep it simple and drop the obvious ones.

> 
> > +struct xe_vfio_pci_core_device {
> > +	/** @core_device: vendor-agnostic VFIO device */
> > +	struct vfio_pci_core_device core_device;
> > +
> > +	/** @mig_state: current device migration state */
> > +	enum vfio_device_mig_state mig_state;
> > +
> > +	/** @vfid: VF number used by PF, xe uses 1-based indexing for vfid
> > */
> > +	unsigned int vfid;
> 
> is 1-based indexing a sw or hw requirement?

HW/FW components are using 1-based indexing.
I'll update the comment to state that.

> 
> > +
> > +	/** @pf: pointer to driver_private of physical function */
> > +	struct pci_dev *pf;
> > +
> > +	/** @fd: &struct xe_vfio_pci_migration_file for userspace to
> > read/write migration data */
> > +	struct xe_vfio_pci_migration_file *fd;
> 
> s/fd/migf/, as 'fd' is integer in all other places

Ok.

> 
> btw it's risky w/o a lock protecting the state transition. See the usage of
> state_mutex in other migration drivers.

It's a gap - I'll introduce a state_mutex.

> 
> > +static void xe_vfio_pci_reset_done(struct pci_dev *pdev)
> > +{
> > +	struct xe_vfio_pci_core_device *xe_vdev = pci_get_drvdata(pdev);
> > +	int ret;
> > +
> > +	ret = xe_sriov_vfio_wait_flr_done(xe_vdev->pf, xe_vdev->vfid);
> > +	if (ret)
> > +		dev_err(&pdev->dev, "Failed to wait for FLR: %d\n", ret);
> 
> why is there a device specific wait for flr done? suppose it's already
> covered by pci core...

No, unfortunately some of the state is cleared by PF driver, after
PCI-level VF FLR is already done.
More info on that is available in patch 23:
"VF FLR requires additional processing done by PF driver.
The processing is done after FLR is already finished from PCIe
perspective.
In order to avoid a scenario where migration state transitions while
PF processing is still in progress, additional synchronization
point is needed.
Add a helper that will be used as part of VF driver struct
pci_error_handlers .reset_done() callback."

I'll add a comment, so that it's available here as well.

> 
> > +
> > +	xe_vfio_pci_reset(xe_vdev);
> > +}
> > +
> > +static const struct pci_error_handlers xe_vfio_pci_err_handlers = {
> > +	.reset_done = xe_vfio_pci_reset_done,
> > +};
> 
> missing ".error_detected "

Ok. I'll use the generic one - vfio_pci_core_aer_err_detected().

> 
> > +static struct xe_vfio_pci_migration_file *
> > +xe_vfio_pci_alloc_file(struct xe_vfio_pci_core_device *xe_vdev,
> > +		       enum xe_vfio_pci_file_type type)
> > +{
> > +	struct xe_vfio_pci_migration_file *migf;
> > +	const struct file_operations *fops;
> > +	int flags;
> > +
> > +	migf = kzalloc(sizeof(*migf), GFP_KERNEL);
> > +	if (!migf)
> > +		return ERR_PTR(-ENOMEM);
> > +
> > +	fops = type == XE_VFIO_FILE_SAVE ? &xe_vfio_pci_save_fops :
> > &xe_vfio_pci_resume_fops;
> > +	flags = type == XE_VFIO_FILE_SAVE ? O_RDONLY : O_WRONLY;
> > +	migf->filp = anon_inode_getfile("xe_vfio_mig", fops, migf, flags);
> > +	if (IS_ERR(migf->filp)) {
> > +		kfree(migf);
> > +		return ERR_CAST(migf->filp);
> > +	}
> > +
> > +	mutex_init(&migf->lock);
> > +	migf->xe_vdev = xe_vdev;
> > +	xe_vdev->fd = migf;
> > +
> > +	stream_open(migf->filp->f_inode, migf->filp);
> > +
> > +	return migf;
> 
> miss a get_file(). vfio core will do another fput() upon error.
> 
> see vfio_ioct_mig_return_fd()

Ok. I'll take a ref on both STOP_COPY and RESUMING transition.

> 
> > +}
> > +
> > +static struct file *
> > +xe_vfio_set_state(struct xe_vfio_pci_core_device *xe_vdev, u32 new)
> > +{
> > +	u32 cur = xe_vdev->mig_state;
> > +	int ret;
> > +
> > +	dev_dbg(xe_vdev_to_dev(xe_vdev),
> > +		"state: %s->%s\n", vfio_dev_state_str(cur),
> > vfio_dev_state_str(new));
> > +
> > +	/*
> > +	 * "STOP" handling is reused for "RUNNING_P2P", as the device
> > doesn't have the capability to
> > +	 * selectively block p2p DMA transfers.
> > +	 * The device is not processing new workload requests when the VF is
> > stopped, and both
> > +	 * memory and MMIO communication channels are transferred to
> > destination (where processing
> > +	 * will be resumed).
> > +	 */
> > +	if ((cur == VFIO_DEVICE_STATE_RUNNING && new ==
> > VFIO_DEVICE_STATE_STOP) ||
> 
> this is not required when P2P is supported. vfio_mig_get_next_state() will
> find the right arc from RUNNING to RUNNING_P2P to STOP.

I'll remove both states (RUNNING -> STOP, STOP -> RUNNING).

> 
> > +	    (cur == VFIO_DEVICE_STATE_RUNNING && new ==
> > VFIO_DEVICE_STATE_RUNNING_P2P)) {
> > +		ret = xe_sriov_vfio_stop(xe_vdev->pf, xe_vdev->vfid);
> > +		if (ret)
> > +			goto err;
> > +
> > +		return NULL;
> > +	}
> 
> better to align with other drivers, s/stop/suspend/ and s/run/resume/

This will collide with resume_enter / resume_exit for actual migration
data loading.
I'll use suspend_device / resume_device, and resume_data_enter /
resume_data_exit.

> 
> > +
> > +	if ((cur == VFIO_DEVICE_STATE_RUNNING_P2P && new ==
> > VFIO_DEVICE_STATE_STOP) ||
> > +	    (cur == VFIO_DEVICE_STATE_STOP && new ==
> > VFIO_DEVICE_STATE_RUNNING_P2P))
> > +		return NULL;
> > +
> > +	if ((cur == VFIO_DEVICE_STATE_STOP && new ==
> > VFIO_DEVICE_STATE_RUNNING) ||
> > +	    (cur == VFIO_DEVICE_STATE_RUNNING_P2P && new ==
> > VFIO_DEVICE_STATE_RUNNING)) {
> > +		ret = xe_sriov_vfio_run(xe_vdev->pf, xe_vdev->vfid);
> > +		if (ret)
> > +			goto err;
> > +
> > +		return NULL;
> > +	}
> > +
> > +	if (cur == VFIO_DEVICE_STATE_STOP && new ==
> > VFIO_DEVICE_STATE_STOP_COPY) {
> > +		struct xe_vfio_pci_migration_file *migf;
> > +
> > +		migf = xe_vfio_pci_alloc_file(xe_vdev, XE_VFIO_FILE_SAVE);
> > +		if (IS_ERR(migf)) {
> > +			ret = PTR_ERR(migf);
> > +			goto err;
> > +		}
> > +
> > +		ret = xe_sriov_vfio_stop_copy_enter(xe_vdev->pf, xe_vdev-
> > >vfid);
> > +		if (ret) {
> > +			fput(migf->filp);
> > +			goto err;
> > +		}
> > +
> > +		return migf->filp;
> > +	}
> > +
> > +	if ((cur == VFIO_DEVICE_STATE_STOP_COPY && new ==
> > VFIO_DEVICE_STATE_STOP)) {
> > +		if (xe_vdev->fd)
> > +			xe_vfio_pci_disable_file(xe_vdev->fd);
> > +
> > +		xe_sriov_vfio_stop_copy_exit(xe_vdev->pf, xe_vdev->vfid);
> > +
> > +		return NULL;
> > +	}
> > +
> > +	if (cur == VFIO_DEVICE_STATE_STOP && new ==
> > VFIO_DEVICE_STATE_RESUMING) {
> > +		struct xe_vfio_pci_migration_file *migf;
> > +
> > +		migf = xe_vfio_pci_alloc_file(xe_vdev,
> > XE_VFIO_FILE_RESUME);
> > +		if (IS_ERR(migf)) {
> > +			ret = PTR_ERR(migf);
> > +			goto err;
> > +		}
> > +
> > +		ret = xe_sriov_vfio_resume_enter(xe_vdev->pf, xe_vdev-
> > >vfid);
> > +		if (ret) {
> > +			fput(migf->filp);
> > +			goto err;
> > +		}
> > +
> > +		return migf->filp;
> > +	}
> > +
> > +	if (cur == VFIO_DEVICE_STATE_RESUMING && new ==
> > VFIO_DEVICE_STATE_STOP) {
> > +		if (xe_vdev->fd)
> > +			xe_vfio_pci_disable_file(xe_vdev->fd);
> > +
> > +		xe_sriov_vfio_resume_exit(xe_vdev->pf, xe_vdev->vfid);
> > +
> > +		return NULL;
> > +	}
> > +
> > +	if (new == VFIO_DEVICE_STATE_ERROR)
> > +		xe_sriov_vfio_error(xe_vdev->pf, xe_vdev->vfid);
> 
> the ERROR state is not passed to the variant driver. You'll get -EINVAL 
> from vfio_mig_get_next_state(). so this is dead code.
> 
> If the pf driver needs to be notified, you could check the ret value instead.

Ok. I'll do that instead.

> 
> > +static void xe_vfio_pci_migration_init(struct vfio_device *core_vdev)
> > +{
> > +	struct xe_vfio_pci_core_device *xe_vdev =
> > +		container_of(core_vdev, struct xe_vfio_pci_core_device,
> > core_device.vdev);
> > +	struct pci_dev *pdev = to_pci_dev(core_vdev->dev);
> > +
> > +	if (!xe_sriov_vfio_migration_supported(pdev->physfn))
> > +		return;
> > +
> > +	/* vfid starts from 1 for xe */
> > +	xe_vdev->vfid = pci_iov_vf_id(pdev) + 1;
> 
> pci_iov_vf_id() returns error if it's not vf. should be checked.

Ok.

> 
> > +static int xe_vfio_pci_init_dev(struct vfio_device *core_vdev)
> > +{
> > +	struct pci_dev *pdev = to_pci_dev(core_vdev->dev);
> > +
> > +	if (pdev->is_virtfn && strcmp(pdev->physfn->dev.driver->name, "xe")
> > == 0)
> > +		xe_vfio_pci_migration_init(core_vdev);
> 
> I didn't see the point of checking the driver name.

It will go away after transitioning to xe_pci_get_pf_xe_device().

> 
> > +
> > +MODULE_LICENSE("GPL");
> > +MODULE_AUTHOR("Intel Corporation");
> 
> please use the author name, as other drivers do

Ok.

Thanks,
-Michał

