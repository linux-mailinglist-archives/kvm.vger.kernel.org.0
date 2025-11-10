Return-Path: <kvm+bounces-62491-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DC34C452C5
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 08:09:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 210D4346C39
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 07:09:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 004212EB5B4;
	Mon, 10 Nov 2025 07:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nRDeDB0v"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 422D52765F5;
	Mon, 10 Nov 2025 07:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762758534; cv=fail; b=JTgt+EqyT85oUfQFIkyNWyuU2ombps0Qbnnc1+egQbSL4Ua/KyuMSDY7jxbWScUmv5Cdx72/uHw0nUyVrJggN1k7+kZSP2GPVcXUNdb0RCdulOk4pwyQnZsVZ1UstoklKmjdi6dKFrQJX2FdCs1snF9L/keAL1axw8tM5/DpE4o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762758534; c=relaxed/simple;
	bh=weLQyT3EaGzgOXCoAuQksWFLwsIddYHOI7jKbIJHOJY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ATAtskyKQireEBHixlXTbf8c8OgzmsN7+2V9C3TWDDj14UvxcgSwBlN4QECe4cD6EA9RpBJrhXENBc/+XHGGUsV4adr+oEhlwvFUii1XcsCDhGjG0DXBtWmBiDHnHvZ+mZgJJwkzGoSHXVyUJPKIMgTp6JBfrx8XFmal8+bKqCc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nRDeDB0v; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762758532; x=1794294532;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=weLQyT3EaGzgOXCoAuQksWFLwsIddYHOI7jKbIJHOJY=;
  b=nRDeDB0vaRHwpN0QY4X1KiG5lABaFjK3i2IrY5kfFIxx7oirF5LcYief
   SigOTW4kl+Ve/jd0b8q3xdc0KQQ45UP9XEhd2uH5SL+39DIlSPUgdqjz6
   AKjQgzctAhSIEwPpkLMgbcNZCA/aa7I7nObFBiJPm4H5KQk1Jr9Lj8F+8
   bMpR5crpKhQfFu0jc7rJE48AFtK1eeTCKJx56TdWrLPVQSRF1ZDLtUk4w
   nCtugrKGoly1B8R65NgwbeNwrS8WHiN45i5re8Ys8BntTfDHd7qBbXxKC
   nEncmwPbpplpH77/r9jUas3hY7X9XgyNLvDhCA/IV43OEtV9YKa3Eo1HM
   A==;
X-CSE-ConnectionGUID: sRgNwNbyTweTSXI2OvsZUw==
X-CSE-MsgGUID: lHo9n1vhSNeLXEeC+UUDIg==
X-IronPort-AV: E=McAfee;i="6800,10657,11608"; a="76256700"
X-IronPort-AV: E=Sophos;i="6.19,293,1754982000"; 
   d="scan'208";a="76256700"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2025 23:08:52 -0800
X-CSE-ConnectionGUID: 6QiISvePQvqz6uK/cuaxDg==
X-CSE-MsgGUID: paeM18FgQxqsa1tUXj2gHw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,293,1754982000"; 
   d="scan'208";a="189322924"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2025 23:08:51 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sun, 9 Nov 2025 23:08:50 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Sun, 9 Nov 2025 23:08:50 -0800
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.59) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sun, 9 Nov 2025 23:08:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xTml2ivQWVUduxfeG39H/mpKsx0wIuxc45mddJ7clsJP1RzaXq942n5QG9ecPgTTWriJJZVocW+9arsJoFHICitO+iVQ8K7rgBECTzYapf5o2+/tMQRxhe8Y0Os5KrCg5y5MTsu2oLXWogf2knG66qJxpi0/rL1446T+f8QbBP6s72I3aszGjMd9jbnHpT7oo2sO5hA7tVd2tkH9YQh5+xKWr6DunbvH7Q7NNTVE63s3QQiZ3XVWvNOhWLm8b4fCx2Zd+vNznK5EyGih7JRy7bicLuqKvSV23H7oXVVGRq2zkOfW3FoNqoTugmF8arWA2qpbjiGg5cdK2HJFnDhy8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bV6Fj730+772hiGS2ax4QwfbJj//EuIfcwPxJqnBxF4=;
 b=VwUawC46c4Cyg3a6aJHKSFC0HL304EkW823DigtfpYvJfsueDz2zSGKy/IohRFV5vcVJGuzj45FE3+1C4H+xTv/jsYHIp5OqXuj0HPNAJ2LYkiBBMfRFPGMkqJsOHgJVR8NJQZGA/+6cZN1EnGTKLgRI4osvkaMPUbFxeXaPyni6CGeKceVdFK9aR7O9jx/2vaD1/UcmQfmiaHoHFTV7FJrYkfMVeOkBOd3xJ1GTEa1dyO1GhesMtpM2R4q8mNZ81iqpQlZ/an//Gp0iSUEWpObrQLjc+uzyTW0EtTLu1Gwh6ljWIoC8DXU0mhamPufIfxaOe1A8ohW2R4ss6y3/NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SJ5PPF77D28E3C2.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::837) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Mon, 10 Nov
 2025 07:08:44 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9298.015; Mon, 10 Nov 2025
 07:08:44 +0000
Date: Mon, 10 Nov 2025 15:08:33 +0800
From: Chao Gao <chao.gao@intel.com>
To: Dongli Zhang <dongli.zhang@oracle.com>
CC: <kvm@vger.kernel.org>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>, <joe.jin@oracle.com>, <alejandro.j.jimenez@oracle.com>
Subject: Re: [PATCH v2 1/1] KVM: VMX: configure SVI during runtime APICv
 activation
Message-ID: <aRGPcYE4liEI+DfT@intel.com>
References: <20251110063212.34902-1-dongli.zhang@oracle.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251110063212.34902-1-dongli.zhang@oracle.com>
X-ClientProxiedBy: SI2PR02CA0042.apcprd02.prod.outlook.com
 (2603:1096:4:196::19) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SJ5PPF77D28E3C2:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d0cb721-a7c6-42f5-41b6-08de2027fbee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?idYZG5T6uZ2GQnrVUEyTa4ypEl237n9Ro2+JD5rdmeFMzdVDkLuS3ncQqe0R?=
 =?us-ascii?Q?/zRTF8ULpIzWWwa4E7egeLShnIF1nJWDIBqglDwWEpAo8zVpdeb/L3WReYO1?=
 =?us-ascii?Q?snSHcuhz9rTYHHPvp3NDGQiijZLX/cwffqHFGJkzx0igKojT5tuGpiN0OGlU?=
 =?us-ascii?Q?mN/RUCA8TUv3zOjVbLjAXWkWvH0OQIqBjoZvEvZrwHbAoutqPsolnGJr2u99?=
 =?us-ascii?Q?ZhY0wLXbHQKUc3r4EbKob833n+3LWbiHjP5mCX6vu2b5eXxCQWh4v5B7+Nij?=
 =?us-ascii?Q?XksMi08xh+TsKhygzjSvryf7N5CxiMxE8t4uSACNvSndYnWdvVWKWMOqHj2v?=
 =?us-ascii?Q?mbXHV526nGzz8ludg9kHJ/gc8nv2/Y1oyr8Znp9pAKATuZyu5HC9TwnTS489?=
 =?us-ascii?Q?puyB5TRE93iFbJZHQ++Q27yx496H0sc+UlatAFWfskXosoYzZZvpk2C6blRe?=
 =?us-ascii?Q?4H2fY/9b6CZ33sdSBnlAwxgNMrAMifz/KI60WStcDG0YO15zZoeVHxvAyT1h?=
 =?us-ascii?Q?jrbe2ONXsJESqaEGMN6Hpf++9QGsXz4Nwe6MRgl0dv1Y59NVT0iRDaEbKv5m?=
 =?us-ascii?Q?SbmlQ6BeY8FKMGhx0KNyR+Owprcb9IdHt6cdCuheSv4TJYrv7+g8mudfHerC?=
 =?us-ascii?Q?GRuc0fMOdS3JNrPcxoTNTV2HA76eERqJ4tVVVcgrrPVpyBIsfI99x9waumKQ?=
 =?us-ascii?Q?iGALt0rTSF9517VFnyxyPMzekRezpLY8MuuhPZ/xGQtfeQmP3KGDWS4lwEwv?=
 =?us-ascii?Q?DAQAn/Kw0qyYyauXrh/FuD8t6tTSENETp2doGpCAoW3rUMPzwvJeXbjdTehV?=
 =?us-ascii?Q?sa8TPrjz4Q3VQj9duQUZ4xXLG3Wq8L5Ni3BVxxhWq0YiLV8eHcDSuL2PnfWW?=
 =?us-ascii?Q?m3sXvJ05NbkOI57qBqqd5l0hxPKygcpU6Q5MRrZJcS3IYQjHOePYmCA0EbDi?=
 =?us-ascii?Q?ei0QhnEnSFH+PXRdRdJTZMqwmdxOt7Zf+2rz5rUweWpdDdSeUuE99zvDjC8K?=
 =?us-ascii?Q?wlz7UEKZkV5bzuEQCs/LLCVo7Lc+7nI+dnxr3dk7fy+3i5zav/OqRs0il0Fg?=
 =?us-ascii?Q?HjuQAv2aOjR1AfqmZEqwzhX4fEYxmfeYuDBeFLUrVB/zRNV8ht9Ko38ElEh1?=
 =?us-ascii?Q?vKoY9Sx40ut/tvHaaReA9ELrngdtWqqAz7K9vtwEep6ApiHbCLfrnvmxghQP?=
 =?us-ascii?Q?7gjhY2lFbmzGuNBOLLpggcIzkZr//yMa6Y5Xf/lNzBZfbQ6l3Tkii+Wv6KNV?=
 =?us-ascii?Q?bYIHsu/mau9djKP5o2Xa3PxCf9HTDZeRgJrbPWN1cSo1/L5sp1tbykO7ETBJ?=
 =?us-ascii?Q?eUyfb81EIsUIgHba1xirzkAlz80Qc5N2dJKjUzqoAey7sJ/SD5bs8xsmsC9H?=
 =?us-ascii?Q?xxWV7fqU3Oc44bd7E+RDCb4zm+64HB6i1+miglR2q8mJ0bureD0Aty36z/JH?=
 =?us-ascii?Q?cNUqDMGS5+i03Leok7czAYjSoQHFQfzH?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QXk2TOtoRavoKDTyIir7NxSWqOwGAluFJyblGNPZubaOWywFVHsKcDIs8lbB?=
 =?us-ascii?Q?blT2bwTJhN3NPWEedgn/Ubl9XXMYz+NEq9C9RqjoaVhcNQGqoJUKSHiie5PA?=
 =?us-ascii?Q?q5WnYrP5kfSBQwovQLURVp4onVtduAW/ZB7WG105X++53eAmlnvJ659rmUYm?=
 =?us-ascii?Q?m2iVSPuhk27ld1KsQ4emAZYFGSWgJ/rIJLzpQgMuH3Q7/HTZZlnrVnqXsiEV?=
 =?us-ascii?Q?pxpaGEb8d2JklyZ0WGJTP5v0MlNJr+gdNHIrsniEr+Gpo0TF5njSAl0sdOih?=
 =?us-ascii?Q?YsmmxUuAg1pL5qV24DsJpPZH6RZTAHYj/j/KRUXx/aw4BTTahfmBKy9gAtJZ?=
 =?us-ascii?Q?rhjdHywuIMhJ9FzxEqHJH+FEbfAvocHkp7WqWOnkFDBoCFdbZWRghcHK078V?=
 =?us-ascii?Q?9+QsmOva8oRLaL4M3vDhmznp6ftr7TRFpW+HGNQ3d8WU/lZyl4AIDxGS2oOZ?=
 =?us-ascii?Q?0FiyOb2Fc4LXB4aHm7/0TfwwrrWsiEep6K7/OE6zZ2ajNmV8wRF+zg1BV5sG?=
 =?us-ascii?Q?4ouPtn3d4Yt5CfY5gYjzJ/WcCwQOKSBvfWJQ3wkbkQRdyFNEDMDEFns/mWdF?=
 =?us-ascii?Q?4yx2UkBvwGbfRkeQQ4hNl2VnhvWq0DOL9QD9wsAl10nfMh/2JuhK4J2/pfkI?=
 =?us-ascii?Q?HUebC0DiL1+3k/7RvfFNBz8IAxgfjHQcwLqgfbOhb9SbdNZOC0zDZ22fWwfr?=
 =?us-ascii?Q?oZgXbPvT6rzFmvQNbblqKoN41RWQt38Btr4Qx8ypjB47+xsbIE4+r2CFBi4L?=
 =?us-ascii?Q?VF+W6QIWKoAwrk2FwKMd9KLuSNvdI5USimPLqeAbyHjx9ZYMcwLuyP8nrcYh?=
 =?us-ascii?Q?7NnlwUHcnFCoI3F1Bum81m+Q/ITYF9rTkejPEJpldtYprYWM2OaZ0k7T9xFJ?=
 =?us-ascii?Q?xoBzj8pLydQ6CgkM2G2g/n/Rr7+i+2sY4sb6UZueJp7DZ4t4siMWd8qDYa8K?=
 =?us-ascii?Q?6PLIvf+E3Z5kOTmvbGTCgIZae4qEZiJaPBC8rvVCqp1uYkC3Q2TUC4KvrWlF?=
 =?us-ascii?Q?KIeWtCTCBb87jC0Dis8AmuM0HRk0XHwG1dWFqgjMp/qEnMCS7re2bOECbJyF?=
 =?us-ascii?Q?pnnmTamMaMwf1DZlpv1RUD809LmwQsxEV8W3noUJ53zAQV2VsNdw3kQJQah9?=
 =?us-ascii?Q?d6q+2Y7CjZ4Y5wg3P0a5zbBDYEoMz+P5Lz1CRDtYCrkgknxCt5hvbLskN3lt?=
 =?us-ascii?Q?XSHyBUeqWl1CbduXuE+VYi9kZLC2PO9/IddNY3hXkmSWLuVoWZ1UXe3hkczP?=
 =?us-ascii?Q?ziZ8kJBx+FLBa5cDhhmD2aEqZQ5zB5X2LT1F0m3R9IT0BjHPKLjyxr6Uep5z?=
 =?us-ascii?Q?rRLf0PNSNMT/tv4ga6z2yyhWNw+S3moARL4mcnkWPCnsVzdXUIg0HwwQSKpb?=
 =?us-ascii?Q?66GqT2mBH+JTIVhQfXQpRGPju2LvjUwC0gfhFgwllmZ5YmE8DBgHANxyLS9o?=
 =?us-ascii?Q?dF4j4phgmQM77R3zUC8LwubEpZjQHWGXI+2Vou26UiHP7026UwpS+P6zxMbf?=
 =?us-ascii?Q?nSRelYZLbF4yQnEr6HMS/XnTVmUF7DdSpfBScviXzkIRRyHieXfxoqhFWXRJ?=
 =?us-ascii?Q?TWsBFl11A6f/Jp+W5aSuXgVhFBokTPTfqUgSwI2N?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d0cb721-a7c6-42f5-41b6-08de2027fbee
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2025 07:08:43.9151
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9ij+AnH7YJ42B3HExWAJDsXuVGpklTjmg7vq5HSifUdKpG/B4zPo48tisyUWyWr9ei373vnMz8UNqKjkjKELEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF77D28E3C2
X-OriginatorOrg: intel.com

On Sun, Nov 09, 2025 at 10:32:12PM -0800, Dongli Zhang wrote:
>The APICv (apic->apicv_active) can be activated or deactivated at runtime,
>for instance, because of APICv inhibit reasons. Intel VMX employs different
>mechanisms to virtualize LAPIC based on whether APICv is active.
>
>When APICv is activated at runtime, GUEST_INTR_STATUS is used to configure
>and report the current pending IRR and ISR states. Unless a specific vector
>is explicitly included in EOI_EXIT_BITMAP, its EOI will not be trapped to
>KVM. Intel VMX automatically clears the corresponding ISR bit based on the
>GUEST_INTR_STATUS.SVI field.
>
>When APICv is deactivated at runtime, the VM_ENTRY_INTR_INFO_FIELD is used
>to specify the next interrupt vector to invoke upon VM-entry. The
>VMX IDT_VECTORING_INFO_FIELD is used to report un-invoked vectors on
>VM-exit. EOIs are always trapped to KVM, so the software can manually clear
>pending ISR bits.
>
>There are scenarios where, with APICv activated at runtime, a guest-issued
>EOI may not be able to clear the pending ISR bit.
>
>Taking vector 236 as an example, here is one scenario.
>
>1. Suppose APICv is inactive. Vector 236 is pending in the IRR.
>2. To handle KVM_REQ_EVENT, KVM moves vector 236 from the IRR to the ISR,
>and configures the VM_ENTRY_INTR_INFO_FIELD via vmx_inject_irq().
>3. After VM-entry, vector 236 is invoked through the guest IDT. At this
>point, the data in VM_ENTRY_INTR_INFO_FIELD is no longer valid. The guest
>interrupt handler for vector 236 is invoked.
>4. Suppose a VM exit occurs very early in the guest interrupt handler,
>before the EOI is issued.
>5. Nothing is reported through the IDT_VECTORING_INFO_FIELD because
>vector 236 has already been invoked in the guest.
>6. Now, suppose APICv is activated. Before the next VM-entry, KVM calls
>kvm_vcpu_update_apicv() to activate APICv.
>7. Unfortunately, GUEST_INTR_STATUS.SVI is not configured, although
>vector 236 is still pending in the ISR.
>8. After VM-entry, the guest finally issues the EOI for vector 236.
>However, because SVI is not configured, vector 236 is not cleared.
>9. ISR is stalled forever on vector 236.
>
>Here is another scenario.
>
>1. Suppose APICv is inactive. Vector 236 is pending in the IRR.
>2. To handle KVM_REQ_EVENT, KVM moves vector 236 from the IRR to the ISR,
>and configures the VM_ENTRY_INTR_INFO_FIELD via vmx_inject_irq().
>3. VM-exit occurs immediately after the next VM-entry. The vector 236 is
>not invoked through the guest IDT. Instead, it is saved to the
>IDT_VECTORING_INFO_FIELD during the VM-exit.
>4. KVM calls kvm_queue_interrupt() to re-queue the un-invoked vector 236
>into vcpu->arch.interrupt. A KVM_REQ_EVENT is requested.
>5. Now, suppose APICv is activated. Before the next VM-entry, KVM calls
>kvm_vcpu_update_apicv() to activate APICv.
>6. Although APICv is now active, KVM still uses the legacy
>VM_ENTRY_INTR_INFO_FIELD to re-inject vector 236. GUEST_INTR_STATUS.SVI is
>not configured.
>7. After the next VM-entry, vector 236 is invoked through the guest IDT.
>Finally, an EOI occurs. However, due to the lack of GUEST_INTR_STATUS.SVI
>configuration, vector 236 is not cleared from the ISR.
>8. ISR is stalled forever on vector 236.
>
>Using QEMU as an example, vector 236 is stuck in ISR forever.
>
>(qemu) info lapic 1
>dumping local APIC state for CPU 1
>
>LVT0	 0x00010700 active-hi edge  masked                      ExtINT (vec 0)
>LVT1	 0x00010400 active-hi edge  masked                      NMI
>LVTPC	 0x00000400 active-hi edge                              NMI
>LVTERR	 0x000000fe active-hi edge                              Fixed  (vec 254)
>LVTTHMR	 0x00010000 active-hi edge  masked                      Fixed  (vec 0)
>LVTT	 0x000400ec active-hi edge                 tsc-deadline Fixed  (vec 236)
>Timer	 DCR=0x0 (divide by 2) initial_count = 0 current_count = 0
>SPIV	 0x000001ff APIC enabled, focus=off, spurious vec 255
>ICR	 0x000000fd physical edge de-assert no-shorthand
>ICR2	 0x00000000 cpu 0 (X2APIC ID)
>ESR	 0x00000000
>ISR	 236
>IRR	 37(level) 236
>
>The issue is not applicable to AMD SVM which employs a different LAPIC
>virtualization mechanism. In addition, APICV_INHIBIT_REASON_IRQWIN ensures
>AMD SVM AVIC is not activated until the last interrupt is EOI.
>
>Fix the bug by configuring Intel VMX GUEST_INTR_STATUS.SVI if APICv is
>activated at runtime.
>
>Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

