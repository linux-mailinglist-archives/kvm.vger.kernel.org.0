Return-Path: <kvm+bounces-62167-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 46F65C3A8FB
	for <lists+kvm@lfdr.de>; Thu, 06 Nov 2025 12:28:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 1BF334FBE57
	for <lists+kvm@lfdr.de>; Thu,  6 Nov 2025 11:25:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7080130EF7B;
	Thu,  6 Nov 2025 11:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L3lflDxw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B76F225F79A;
	Thu,  6 Nov 2025 11:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762428297; cv=fail; b=LfEA9JTPzhLyZY6+ZFtQdlTUJ7K9DWBdPPIIQKgXX0VW/B7vic4beI4csUdwC+vbnvvQ7WaQ8FmRIG+2miznx9uUm4QPZu8bhHJQnOEaPjDk+sXPpWCi9TvBy2iIfqt8g5NAIWKLbFBrmk9Pl+s5xRuGuqh7D1a6RHSwOJI6Thk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762428297; c=relaxed/simple;
	bh=OCbb+vHuAjcUgXda87CHsGYk2AG0kUlKmek2YHF/NQE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=KHoCBr+bgz6ABFIYywP/yKn+1q4IVjQ00VvZH0IOrEjEAoo/+EGw9fVQCm55Els0CMy3hIe0dOPa7WC4Yvd0RtUcWpfHFXsTdKfCa4HVQJU2OGt+fr6GmRL1i1Juwb/IqcyI/lwcZFocrVqFczxFxlxfH+1ups2YAESWv4F5eEI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L3lflDxw; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762428296; x=1793964296;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=OCbb+vHuAjcUgXda87CHsGYk2AG0kUlKmek2YHF/NQE=;
  b=L3lflDxwVsanrTXUHHsgaK7VrYbkcD4oqgoKNIKx7NJyYGIYouuo1AkX
   iCu9wCwG9lf5tbEkIVHce/2OaKhP8zgV/MNsK7sfwgKnq71epw5vaVSH6
   +2KPlZe8nggOqN418QuDbnInbkQe3K/BNEbeOLFlJ0SdDKHgs3kpZ//Cv
   fVEyV+RF9RzQyy7E+tqXyIxo6DHW8TrFTyLiF8ZmMa7/rStNA520rBddW
   5Fy0749ivQM4r50J8lUY3uKwiKX4fOA64mbFsGOUJ3IQ3SogjKMYFQtim
   7swMlAGlEDQMnBrtJLNblpH5kIHSzMb8egXT8kxzWtm5/lgPxWZGuAqpM
   g==;
X-CSE-ConnectionGUID: zPn4hCNdSMeJAt1Ihc687g==
X-CSE-MsgGUID: UYmmvt9zSvO2TE9/aN+wig==
X-IronPort-AV: E=McAfee;i="6800,10657,11604"; a="74852280"
X-IronPort-AV: E=Sophos;i="6.19,284,1754982000"; 
   d="scan'208";a="74852280"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2025 03:24:56 -0800
X-CSE-ConnectionGUID: kgJ9tpA0Rx+cdY6QHthEBQ==
X-CSE-MsgGUID: mjtuUSiITLO37zY2/Kw0jQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,284,1754982000"; 
   d="scan'208";a="188452972"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2025 03:24:55 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 6 Nov 2025 03:24:54 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 6 Nov 2025 03:24:54 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.61)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 6 Nov 2025 03:24:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ro3LWHj0sV9qhfZGTInAviH67rlXgEdhjtP3Hdd15EiDcBNq80H5AKr5waHCglq093lfbXAZGpy11JPLqxCuGm8i7ze9cV+sWtn9fK65N2fFFRgQMC6xpdGkbzJ48t60V7HVyDpRDeOZyQC7OAdjSN0usflGCa8UbRDXBMiU0F/StO+cVZy5kH0dc6iC75YDuPMiLNnvMBuzG9mS4WCY4tJ5FX7vjWkoGxFYkhEEBxsUD4VU0dN5S9V+KWc820tP/ib05xL1mpWH1eD+WBVv9wbjSMRwGBLIYWFFj0FAuBaDFH9l/jddM+B+XGwavuhVFkz8LzAe7ZdSC9llVi/qrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r6JPmGqAssaRhrgBi3w7Y8ioYcFr5vcX64Q9TVbIhb0=;
 b=okukMBRD266HHIjXpxW55fI/ReEEDHqlLF0W25IISLUuHItun59FHBO0kK/P5N2p2DsW0YXMH4C5punK2rheOaSRBOieIRJS7iCVNfSzWJqm55WMmQQQJ+OmyW5C91m+EuMwbt6L3d8iityysH93ezN4638Fk+yM0tYN3OrkrwGqOt0jXE01XDyIFI9sqMc6EvWBk4nEnf2oitW0fiAXCD3ugu1z8DH3mNrPZQf3pFThZOci5JQOVdGD/cVnqLfgMChsdJ5dxOJy4ZuTlAvKEjDQelI9OtzloVR2uv/fIogJtRltWK9oJjNBC0Ej1cfQWlX5+muvKe0kVBKlS2nhjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5373.namprd11.prod.outlook.com (2603:10b6:5:394::7) by
 IA0PR11MB7331.namprd11.prod.outlook.com (2603:10b6:208:435::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.8; Thu, 6 Nov
 2025 11:24:52 +0000
Received: from DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39]) by DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39%5]) with mapi id 15.20.9298.010; Thu, 6 Nov 2025
 11:24:51 +0000
Date: Thu, 6 Nov 2025 12:24:48 +0100
From: =?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>
To: Michal Wajdeczko <michal.wajdeczko@intel.com>
CC: Alex Williamson <alex@shazbot.org>, Lucas De Marchi
	<lucas.demarchi@intel.com>, Thomas =?utf-8?Q?Hellstr=C3=B6m?=
	<thomas.hellstrom@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>, Kevin Tian
	<kevin.tian@intel.com>, Shameer Kolothum <skolothumtho@nvidia.com>,
	<intel-xe@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, Matthew Brost <matthew.brost@intel.com>,
	<dri-devel@lists.freedesktop.org>, Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Tvrtko Ursulin
	<tursulin@ursulin.net>, David Airlie <airlied@gmail.com>, Simona Vetter
	<simona@ffwll.ch>, Lukasz Laguna <lukasz.laguna@intel.com>, Christoph Hellwig
	<hch@infradead.org>
Subject: Re: [PATCH v4 05/28] drm/xe/pf: Add data structures and handlers for
 migration rings
Message-ID: <frft6t5wwtqppqi2nc6hfo6dx3vgfzpwc3jumatharhv2zegbk@jnaafyx7fzrk>
References: <20251105151027.540712-1-michal.winiarski@intel.com>
 <20251105151027.540712-6-michal.winiarski@intel.com>
 <fdca0d94-5c5e-4749-8278-42ec14869313@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fdca0d94-5c5e-4749-8278-42ec14869313@intel.com>
X-ClientProxiedBy: BE0P281CA0010.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:a::20) To DM4PR11MB5373.namprd11.prod.outlook.com
 (2603:10b6:5:394::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5373:EE_|IA0PR11MB7331:EE_
X-MS-Office365-Filtering-Correlation-Id: 1caae835-34b8-4e97-9882-08de1d271a48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NTVBL2ozTkE2RndUMkFmczBleWxsOUFmWG5XcXlFeDk2d3VTaUxWTUp1ZVll?=
 =?utf-8?B?VUt0bGtIYk5oaXJJbkhHOW83WTM5akJSS1c5ZjFaRDZIUjJMMlY4MGZqa2ht?=
 =?utf-8?B?NGpIT3dIY0FhS1lOcDZqSFRwbVFHRW1DRzErSE9QaEJVYVlaaG50Z0d2d0Y3?=
 =?utf-8?B?N0tBTnpMS1o0L1liNEtESlFNcnFaKzBoa01uN1gvZnYxSlNFbjYxUllVUWl2?=
 =?utf-8?B?aE1CMGZLWWlJK2VkUjNpTHQyV0ltN3BRVm1hcEpZVmUxb1FMRlg4SEFlelhP?=
 =?utf-8?B?UFE0YVp3QVBVb0tiSlQ4bWlxYy9va1N0Sm5qT214bVhBNEdPMkI1K3NVTkYz?=
 =?utf-8?B?T0dyTFVOVEFVZmdIWDdvTEIvMzZiYVpockkydlVwalhhOURBdktiZk4zMGw5?=
 =?utf-8?B?Q1lLQ2tCQkhjN0tuRHZzYWVOMnJDVXdOTXNyVzNua2kxNnJxSS91WVhPNUxY?=
 =?utf-8?B?RXNTc1RadU1iNEJ6RHlPUDBDbUdVaWxqWWtSa0dEaFBMcTA3WlArWjcwUW8x?=
 =?utf-8?B?QWFSRTQySmx0R3lxNCtjN2JGajUwOHRFNDFYY29IOVE4Q3djcUR0YVJXcG1J?=
 =?utf-8?B?aWFMczdtejNZdzBpMzR5RVg5UzR5WmczNndNSXlHQUk3bFN6dVJsZkwzVllP?=
 =?utf-8?B?UGJhc0FuSklnTi9mVzFMenJmZDVFdHAzclJncnRNYUhpOHpvWWhEVjJRZWZh?=
 =?utf-8?B?RjZkZEJpbFdEZnJJSXFJT3pNMys4ZGxiUG0xeEJ6dzFMRjFLd25iQ1dCRDQ4?=
 =?utf-8?B?MWw5Vmd6TW9ENUcvb3NJY1UxeS9tdW5DRE94bDI4ZWZFWm81REVwd1R2S0lI?=
 =?utf-8?B?d3RrYUprM0I2eWJlWkx4TTAyOGJNaU4vUkFoeExTY2h4SUtzNW1nNGtZcHNO?=
 =?utf-8?B?dGcrMWxvRGx1TXBTblNPMmx6SURZOHoxdlg1OHFaWUs3NU50cmRTUzJSOTIv?=
 =?utf-8?B?WVV0eldYbVBuS1dXL1ZTbXN4UVhUTXIySG1BckNibWl6T0ptYWlhUkdVcGU5?=
 =?utf-8?B?WXpaeVcrcWtWOUFvOVBKeGN6UFRQbDNkM0c2Y0puSnhpZnFGNU5rTGdsVnZ0?=
 =?utf-8?B?NDZDNU1mR1FmQzBTTU0wcXh1elRaTVBMZ01PRUR5eXVkWU9PemdsTi9hZG0y?=
 =?utf-8?B?WEtxWVFTOWoySzV0TDFxck9tSmJBanlxeFhHN2hwYVRZYUgxdTlIeGoxM1Ja?=
 =?utf-8?B?K0U3V05qdzJWRVJMZ0owbnQ1bVduQTk5WVdmWTh2RHIyY25nbkRsRHpvMlBP?=
 =?utf-8?B?ejF5dm5OSzlGUzQwS3UxK1hDQ3lBVlFmSVhjNTRLQ2pQMGU5RHQ2SXJydEY2?=
 =?utf-8?B?cSt2ZnJkeVorUzk3QUxBUXF1TzZTWXJjenFEc3VWdUwwQ2sweEtqcndxVGZZ?=
 =?utf-8?B?bHBVUzBkUXMwZklSR0VBbDdZV25INURqQVV3UENSSUhyeHlxS0VFMjc0SUtp?=
 =?utf-8?B?OXdqMVhKTFVJYXFvYlc3ZGVITjhJdExWT24zRmxINnZEL0V6amtOQW5wSCtN?=
 =?utf-8?B?djh1d3IzWE5ydEVLVlg5emRydFJRa3VuYWpFVjNuK1VmU29VUkhnYUZCSGhV?=
 =?utf-8?B?d2F5Wk1CTXAwS0RYa0J1QmxtY05DdGR1NnlqYXVnV0FMOFpTQTVVOXFXd0l2?=
 =?utf-8?B?Uy9vLzRkY1RKRG82UDg1Q3l3UXBEUFZFL2lwUjZhSTdIdmxsbXAyY0pyVE1l?=
 =?utf-8?B?a1IwWGYxdXgwc044bkJiOFRma094b2hVWkZJQUhTdlpiZUt4RDNTNkVWeUpn?=
 =?utf-8?B?eWdlUDh1Mnd1dkpYR2gwU3JQQzJNZHVWQkQrT1RUTkk4ek5WQmtvUWU1MWM0?=
 =?utf-8?B?YmVxS29LbzRBbWlyUUdJWEdWeUtvQ01sQUpoeFZPTDVXVjg5REh0azFRNDBU?=
 =?utf-8?B?LzUyZ0o2Y2F3NzZJYVpYWXVhbHJZZEVVTnFDN2xVYlRkdUJqVEF6RzBnaFh2?=
 =?utf-8?Q?IWhW3qC3Iwd+L1r51sofMIww5ZbOKGpw?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QW9XUEd6SFc4Z2tBa0N3eVRERXFwOGx5bThmSXZNK0ZiVUpwbHl5amRHRG5R?=
 =?utf-8?B?L1hMaDY3ZE9SbWlzODZXNWh5bXlvL2lMZVlLc1BEd2hGbkZ2N2lXdkk4ZUZr?=
 =?utf-8?B?Mit2c2wydWZUdFFtMzNFL045aDZRTFdzVnQ0OEYxaWhSVGxobGorV0EzNnZn?=
 =?utf-8?B?VjdkMTcxZXYyR3hhSjBncDhPNFREamV6aVhUVDVJYjBVSEFVdU5JSTNGNC8z?=
 =?utf-8?B?RU1FRjk3MnpwVjdiT2pOTTVOSGtiUy8xT2IyZW5TZFRKRXp2WWhLOG8rQjk5?=
 =?utf-8?B?ZWFmNFBhY1NrTlllS0VVMjZVb0ZjWXdWQmFJWVRqbWhoM2Q4cW8zSWJYN3dw?=
 =?utf-8?B?eFB5VlJOYjc0eThZL1MvSVBGUjNwdkZnTnBvVHVKcmRHR3duenkxa0ZaMjYx?=
 =?utf-8?B?d0U1YUdONHdjK0xJL2U1Um5OWTBLQm1xSEdOZkpOYVF6Zno1NGFvOUpmWlN2?=
 =?utf-8?B?Q3N2cjc0YjRhdUJkNjljTklDUEY3YkdNaXBmcGlmdEFRS1RZd0hLVHJYTTY5?=
 =?utf-8?B?T09lZFVKR1N0Y1ZpYTcvQ21NZXpFTldRNnBGdWVrYVNZWGg1UWlxR3dPNlVh?=
 =?utf-8?B?WTNDNFREdUF0NGhEK1k2dWE1amgwZU9TZFMvVk1zUWdIZHV2MlptOXlHWlZz?=
 =?utf-8?B?VlVBTk9FckZScWREUGdUUmR4S1Bla0ltN3NWcjVOWTBtZ3NrZW16VXdMODZV?=
 =?utf-8?B?K0NxYzFBK2piN1paN0UzNm1kem1VUEs2NEZZRGRaNUJtaWlSdlozZW9KN1FN?=
 =?utf-8?B?S05kQWJzZ0xxQ0pXdW1jNCsxNXc0L1ZOeTlMbVVGZ1RvRmhwRlNHaWxUYXdz?=
 =?utf-8?B?YW9NNTJwam00bU9jY2lGbkgvbk9NQWRZV2JUYWE2STROYVFPbVIzVElxSTYx?=
 =?utf-8?B?TzBHaG1yNHhqNXJtNE9oMlVnMkpYRGxQdlcvMGRPZnkrSGZxOFM4MGN3Nk5z?=
 =?utf-8?B?R04vS2NEbURHanJqSnVxczlSNFlETFFTNWRSZlJISjZvRkRXZzhOYVg4WFJU?=
 =?utf-8?B?U2hZYjRHb2ZyYi9nRFRwVkU1aVZ2SkhoMXd0c3ZWZ1ZFUS83cHhVb1piTjhN?=
 =?utf-8?B?Mm9TUlFmL0FaSTY0YTNkSDgxSGhXUFpINzVsYklGdTJvM3JkU2hSaWtvVzc2?=
 =?utf-8?B?K3c5Y1d2NDVlWWhDa01kcWFMZlFwNHBXV1pkRVJwbi9Zdmp2eCtGT3dSNmF1?=
 =?utf-8?B?UHBUWHVyeThUWkZ6QUVMTVN0dUI3Y0IyRWZ5QnpMZHhlNk5ZSFB5ZmM5ak00?=
 =?utf-8?B?WE4wM096T0FWN0VkS2lIZ0dpcVRVbkQ2UU83SjlmdUFCTWhib2U1ank1Q0o0?=
 =?utf-8?B?cWFqaGF3ZUVMUTZ1bzZNc3MrYlJ6TTNUWXFNUmtwbW4rTTR2d2hjY3g1NUFQ?=
 =?utf-8?B?TklBN1BEb1lydE1Fby9ycG8zZWtNR1lhQTM3ZU4rNXFXbHlrUkRIaUdmUUVi?=
 =?utf-8?B?aG93ZFNoSEsxa0ZqVTZmV3I0eWliT3c0ZlRNeHFCcUpMTFRld0dFb1dKVit2?=
 =?utf-8?B?ekM1ZU51Q1piYUNWcHlaejVzcjhsZS90aHdldFZWK0UrUWdUN0twUlNLeEtB?=
 =?utf-8?B?anJLd1htTk9ERlcwajRlY0RrZ3p2b3ZKOHJBcnNnYkQwR2V1dklkMnlDaU5j?=
 =?utf-8?B?RWtjaTRiWGN5dC9XVDFvZXJoaW9JaFZqa0lNeVQ3ckx3UXg2dVpyZ2hhZldO?=
 =?utf-8?B?OWRrY0E0MzFnSUFGRGs0RVUydDhkN1d5bGdSOFdXQmFyTW5sWlJxd0IvTDZu?=
 =?utf-8?B?VDRnYzB3WktOOHkzSVlDWXdLenNhZDZQbzNLU2dtMnl0cExCbjB0VUd3Rkx4?=
 =?utf-8?B?TGNQSWlTbFUvTWZDYVNnMUhPeW52SXUvNEdtUUE0VDdITEs5dHhMUEdibGVQ?=
 =?utf-8?B?Qi92TlBHdmpQOE8yS0JsVE9oWDRZNHdPWHpwU2p2QjNMMG44cHJ5NkRPU3p1?=
 =?utf-8?B?QU1QaFFRcUpjSjB2cHgwNDVSTGZkTllDOVRLSGtlZ1ZkRWw1ZitGOWhkSWdP?=
 =?utf-8?B?TDFDK0tSTDA2SXF2d2VQbytBU0ZPSmxLQXFJeTIyNzl6aFdBWWJvSk53NnZs?=
 =?utf-8?B?UGNMTEpOMU5McHZ1czZuTXZ0OVh0WWRJMlBLdzNiVk9yTjFST2ZiOWVsdlht?=
 =?utf-8?B?aEdtaURxemhNM0d5aWNsZHRvbGtRNHVzZXFzZU1JdmsyUVdVRDZqZ3B1Mk1X?=
 =?utf-8?B?eWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1caae835-34b8-4e97-9882-08de1d271a48
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2025 11:24:51.7327
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MUZtgYtQjhhcRayBcZ7h+jF/iVbdPbmGz48O+RgRAnCa7oSQqWXTk6CVmwBMUysypX9ioLkXKxEp9HJTVPeLKYTwgCa4Ydr529dJJHJaiiQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7331
X-OriginatorOrg: intel.com

On Wed, Nov 05, 2025 at 09:17:05PM +0100, Michal Wajdeczko wrote:
> 
> 
> On 11/5/2025 4:10 PM, Michał Winiarski wrote:
> > Migration data is queued in a per-GT ptr_ring to decouple the worker
> > responsible for handling the data transfer from the .read() and .write()
> > syscalls.
> > Add the data structures and handlers that will be used in future
> > commits.
> > 
> > Signed-off-by: Michał Winiarski <michal.winiarski@intel.com>
> > ---
> >  drivers/gpu/drm/xe/xe_gt_sriov_pf_control.c   | 310 +++++++++++++++++-
> >  drivers/gpu/drm/xe/xe_gt_sriov_pf_control.h   |   6 +
> >  .../gpu/drm/xe/xe_gt_sriov_pf_control_types.h |  12 +
> >  drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.c | 199 +++++++++++
> >  drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.h |  14 +
> >  .../drm/xe/xe_gt_sriov_pf_migration_types.h   |  11 +
> >  drivers/gpu/drm/xe/xe_gt_sriov_pf_types.h     |   3 +
> >  drivers/gpu/drm/xe/xe_sriov_pf_migration.c    | 143 ++++++++
> >  drivers/gpu/drm/xe/xe_sriov_pf_migration.h    |   7 +
> >  .../gpu/drm/xe/xe_sriov_pf_migration_types.h  |  47 +++
> >  drivers/gpu/drm/xe/xe_sriov_pf_types.h        |   2 +
> >  11 files changed, 741 insertions(+), 13 deletions(-)
> > 

(...)

> > diff --git a/drivers/gpu/drm/xe/xe_sriov_pf_migration.c b/drivers/gpu/drm/xe/xe_sriov_pf_migration.c
> > index 8c523c392f98b..ed44eda9418cc 100644
> > --- a/drivers/gpu/drm/xe/xe_sriov_pf_migration.c
> > +++ b/drivers/gpu/drm/xe/xe_sriov_pf_migration.c
> > @@ -3,8 +3,36 @@
> >   * Copyright © 2025 Intel Corporation
> >   */
> >  
> > +#include <drm/drm_managed.h>
> > +
> > +#include "xe_device.h"
> > +#include "xe_gt_sriov_pf_control.h"
> > +#include "xe_gt_sriov_pf_migration.h"
> > +#include "xe_pm.h"
> >  #include "xe_sriov.h"
> > +#include "xe_sriov_pf_helpers.h"
> >  #include "xe_sriov_pf_migration.h"
> > +#include "xe_sriov_printk.h"
> > +
> > +static struct xe_sriov_migration_state *pf_pick_migration(struct xe_device *xe, unsigned int vfid)
> > +{
> > +	xe_assert(xe, IS_SRIOV_PF(xe));
> > +	xe_assert(xe, vfid <= xe_sriov_pf_get_totalvfs(xe));
> > +
> > +	return &xe->sriov.pf.vfs[vfid].migration;
> > +}
> > +
> > +/**
> > + * xe_sriov_pf_migration_waitqueue - Get waitqueue for migration.
> 
> nit:
> 
>     * xe_sriov_pf_migration_waitqueue() - ...

Ok.

> 
> > + * @xe: the &xe_device
> > + * @vfid: the VF identifier
> > + *
> > + * Return: pointer to the migration waitqueue.
> > + */
> > +wait_queue_head_t *xe_sriov_pf_migration_waitqueue(struct xe_device *xe, unsigned int vfid)
> > +{
> > +	return &pf_pick_migration(xe, vfid)->wq;
> > +}
> >  

(...)

> > diff --git a/drivers/gpu/drm/xe/xe_sriov_pf_migration_types.h b/drivers/gpu/drm/xe/xe_sriov_pf_migration_types.h
> > index 43ca60b8982c7..3177ca24215cb 100644
> > --- a/drivers/gpu/drm/xe/xe_sriov_pf_migration_types.h
> > +++ b/drivers/gpu/drm/xe/xe_sriov_pf_migration_types.h
> > @@ -7,6 +7,7 @@
> >  #define _XE_SRIOV_PF_MIGRATION_TYPES_H_
> >  
> >  #include <linux/types.h>
> > +#include <linux/wait.h>
> >  
> >  /**
> >   * struct xe_sriov_pf_migration - Xe device level VF migration data
> > @@ -16,4 +17,50 @@ struct xe_sriov_pf_migration {
> >  	bool supported;
> >  };
> >  
> > +/**
> > + * struct xe_sriov_migration_state - Per VF device-level migration related data
> > + */
> > +struct xe_sriov_migration_state {
> > +	/** @wq: waitqueue used to avoid busy-waiting for snapshot production/consumption */
> > +	wait_queue_head_t wq;
> > +};
> > +
> > +/**
> > + * struct xe_sriov_packet - Xe SR-IOV VF migration data packet
> > + */
> > +struct xe_sriov_packet {
> 
> hmm, shouldn't this be defined in xe_sriov_packet_types.h ?
> 
> in the very next patch we will have:
> 	xe_sriov_packet.c
> 	xe_sriov_packet.h

Sure, let's introduce xe_sriov_packet_types.h

> 
> > +	/** @xe: Xe device */
> 
> nit:
> 
> 	/** @xe: the PF Xe device this data packet belongs to */

Ok.

> 
> > +	struct xe_device *xe;
> > +	/** @vaddr: CPU pointer to payload data */
> > +	void *vaddr;
> > +	/** @remaining: payload data remaining */
> > +	size_t remaining;
> > +	/** @hdr_remaining: header data remaining */
> > +	size_t hdr_remaining;
> > +	union {
> > +		/** @bo: Buffer object with migration data */
> > +		struct xe_bo *bo;
> > +		/** @buff: Buffer with migration data */
> > +		void *buff;
> > +	};
> > +	__struct_group(xe_sriov_pf_migration_hdr, hdr, __packed,
> > +		/** @hdr.version: migration data protocol version */
> > +		u8 version;
> > +		/** @hdr.type: migration data type */
> > +		u8 type;
> > +		/** @hdr.tile: migration data tile id */
> > +		u8 tile;
> 
> as in this struct we already have "xe" which represents pointer to the xe_device, as used/named elsewhere in the driver,
> maybe this "tile" (and below "gt") should have "_id" suffix to avoid confusion with "tile" (and "gt") members used elsewhere in the driver where they are pointer to tile/gt?

Ok.

> 
> > +		/** @hdr.gt: migration data gt id */
> > +		u8 gt;
> > +		/** @hdr.flags: migration data flags */
> > +		u32 flags;
> > +		/** @hdr.offset: offset into the resource;
> > +		 * used when multiple packets of given type are used for migration
> > +		 */
> > +		u64 offset;
> > +		/** @hdr.size: migration data size  */
> > +		u64 size;
> 
> btw, it looks that this __struct_group() confuses kernel-doc:
> 
> Warning: drivers/gpu/drm/xe/xe_sriov_pf_migration_types.h:72 struct member 'version' not described in 'xe_sriov_packet'
> Warning: drivers/gpu/drm/xe/xe_sriov_pf_migration_types.h:72 struct member 'type' not described in 'xe_sriov_packet'
> Warning: drivers/gpu/drm/xe/xe_sriov_pf_migration_types.h:72 struct member 'tile' not described in 'xe_sriov_packet'
> Warning: drivers/gpu/drm/xe/xe_sriov_pf_migration_types.h:72 struct member 'gt' not described in 'xe_sriov_packet'
> Warning: drivers/gpu/drm/xe/xe_sriov_pf_migration_types.h:72 struct member 'flags' not described in 'xe_sriov_packet'
> Warning: drivers/gpu/drm/xe/xe_sriov_pf_migration_types.h:72 struct member 'offset' not described in 'xe_sriov_packet'
> Warning: drivers/gpu/drm/xe/xe_sriov_pf_migration_types.h:72 struct member 'size' not described in 'xe_sriov_packet'

Looks like struct_group() usage is just a leftover from development
process and we don't really need it here.
I'll just replace it with regular named struct xe_sriov_packet_hdr.

> 
> 
> > +	);
> > +};
> > +
> >  #endif
> > diff --git a/drivers/gpu/drm/xe/xe_sriov_pf_types.h b/drivers/gpu/drm/xe/xe_sriov_pf_types.h
> > index b15d8ca2894c2..d1af2c0aef866 100644
> > --- a/drivers/gpu/drm/xe/xe_sriov_pf_types.h
> > +++ b/drivers/gpu/drm/xe/xe_sriov_pf_types.h
> > @@ -24,6 +24,8 @@ struct xe_sriov_metadata {
> >  
> >  	/** @version: negotiated VF/PF ABI version */
> >  	struct xe_sriov_pf_service_version version;
> > +	/** @migration: migration state */
> > +	struct xe_sriov_migration_state migration;
> >  };
> >  
> >  /**
> 
> otherwise LGTM
> 

Thanks,
-Michał

