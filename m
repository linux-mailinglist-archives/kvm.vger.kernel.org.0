Return-Path: <kvm+bounces-62839-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A9E12C50B01
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 07:19:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 13F833AB869
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 06:19:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 265712DC32B;
	Wed, 12 Nov 2025 06:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f+HzTd9B"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9AD34A35;
	Wed, 12 Nov 2025 06:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762928374; cv=fail; b=QXWo+9TdNw566kYOK+J4roek9kjwY/a9WiMCjXFpR9xQxhUmaL/BmE3PRsmGyic9Qo0qnaZ3sxmkj8CbPwIRP87+Qmw5HscLiUrmwMeNXTbw7qWmanXJr9dCHmsuHw05U2bOeLCiXh8t1M/wrjQC2rkaloVK/IvCFiV8o0Ag7ec=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762928374; c=relaxed/simple;
	bh=E2NYIyEUQZAUeeTPwwNZmXudqJps0/cz8rH80G7PN+o=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=kS2WbOgrGBfpgnerhC+pS7Ln+J/H6ZD0e/AOkefGbLdsaOArjvtpKkzYAVFIsWwre8BGW1h+ynwBx5UcecEuJ2GKdNZbD9quKbQ1f86o00ZIXmwFlmEcKH8xqLiFmGqUL2VG3wac0mPvax1u7VB+iu4xno5NGIZIlFMThrnzSNA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f+HzTd9B; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762928373; x=1794464373;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=E2NYIyEUQZAUeeTPwwNZmXudqJps0/cz8rH80G7PN+o=;
  b=f+HzTd9BkEwa5x7P6yszBJAf0FHg8VrWWmNwnS559KaWSzU5grimsimB
   74xzIe2qD1LEoJqalEJgArwe1DNrDGzHf5Ob157mh0bGYXAY2o0ZmQmEf
   JUpcADmJFTGevwwV+0DRYCg4ztiFgmz8D+NyfEd9b0Xr2dhkckpv03IMN
   1O6O6q1Hqkdrst1SY9qKKAl2ZTpz00N2y/dkENLMT5bYj563HqOBOLd1U
   0Gl34YzdOHGLyr/nmZ+tkgzo+IIruaVq1TevByJ+/cxlEVWEGQBWGWHM5
   Z6wz8P7PTmLo1AaUeGb0UyiqgIZxOELZ37narGZ/mGR7YI/4d0jq7YUXD
   A==;
X-CSE-ConnectionGUID: xAHTBmG8RaKgevQ9vtynFA==
X-CSE-MsgGUID: vuu9MWUlR5GH+tYsh+t8ZA==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="64922131"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="64922131"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2025 22:19:32 -0800
X-CSE-ConnectionGUID: ttHc0XzyQHune9yktIsDLQ==
X-CSE-MsgGUID: FXEcB25aROaHelPqXJ63DQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,298,1754982000"; 
   d="scan'208";a="189868276"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2025 22:19:31 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 11 Nov 2025 22:19:31 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 11 Nov 2025 22:19:31 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.2) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 11 Nov 2025 22:19:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hVQgHjtmpMjiCT1oPnV8y6oFlQgFcTfhmimL8juE+KR9L+TUfL76N9jQkhfQvyiURzhw191b4jll8s+fR6olMja7fb6NPbIy0fz0d0mFoWuMUgsASrKfBcQI5hgG3jVgfYwrdYyhqt5bbtDzqQ/qpBDjR9+BX3V+icEcwAswSRwzFiL6veD6E+CUx1QY9xdBBiNtvnCLQBlxtQVoDyZRoBRMQ8RPjsBKfDLUR/DY9UoNfSYzuw5+GYsdsdmsyZQPVaNT724PvvWn3pjuErXzhhx0bNU/4305SxM5d+MRlyiIAsr001wOMUpKbli9EoGIgzCEa2oRjGVyVHvlMCRgcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E2NYIyEUQZAUeeTPwwNZmXudqJps0/cz8rH80G7PN+o=;
 b=cQOURPVAE90mFwyNCYZ09ntJVkxUc61VFJBm15lCVI3wZTTXHOkdQsQsB21I/PcfiaUk1hvjx6ZCYBU2RfFYPUS+3nk7vzQtHsPCv4wWmRRlq7bOGAbyEnzcekPwqqHOe1udcdP6YbmSI/5IuPBU7bw9OCRG7I0Qyv2xEZPFtkyyg9d/kwnvpeUwCSvqL+G05qFUJQ/f/XMfI/FkYJR0BuIsdEJHy9YUSztzXXwtO9Qq8GKJMkST+eEuRTzY/7ylVsxLryhNfRN9RMepWJsP92HPr0Hu3ZPKUW/jGAsnaUCVhLsd5FwbqY3FU83utHs5wRRqTWYAM43vwY9O7jHnmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CY5PR11MB6344.namprd11.prod.outlook.com (2603:10b6:930:3b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.15; Wed, 12 Nov
 2025 06:19:29 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9320.013; Wed, 12 Nov 2025
 06:19:28 +0000
Date: Wed, 12 Nov 2025 14:19:19 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Xin Li (Intel)" <xin@zytor.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<corbet@lwn.net>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<luto@kernel.org>, <peterz@infradead.org>, <andrew.cooper3@citrix.com>,
	<hch@infradead.org>, <sohil.mehta@intel.com>
Subject: Re: [PATCH v9 11/22] KVM: x86: Add a helper to detect if FRED is
 enabled for a vCPU
Message-ID: <aRQm51LpnFIUquXH@intel.com>
References: <20251026201911.505204-1-xin@zytor.com>
 <20251026201911.505204-12-xin@zytor.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251026201911.505204-12-xin@zytor.com>
X-ClientProxiedBy: SA1P222CA0186.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c4::18) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CY5PR11MB6344:EE_
X-MS-Office365-Filtering-Correlation-Id: 298e608d-eb71-427b-f96c-08de21b36f56
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?myqUPPE9EZUUrKoH31VGoo4w4ARAGABpHZ/OB2OyRECpMYu9Dm1t9KcogTjH?=
 =?us-ascii?Q?k0gwZdrGFChs4YmModriA9qiI0Ao5BXa9GOk2MQmCjRm886sdzRa3KVDtyau?=
 =?us-ascii?Q?nywtuIjXHsg7eObuz3kzOm6g1N8jOdU1OmEaU2xjCeeuDdb6QFI9q0Qeg/k5?=
 =?us-ascii?Q?aG3JaTIw8WHU0QmSS2HD7r4ayI8Air/7kpUJa0EHccXrbyrPP2lsEWTWFaXF?=
 =?us-ascii?Q?USBzc7QfYhVbUL1NDX+CnvJ/Vq41CBJOFKBcBG5gZeAlILOz4aw0tuYBS165?=
 =?us-ascii?Q?+T+dBIRmUZPiFraAtcvb8f1L4UenQ7ZHXEZ8aFSlS60F59V2dwP+EWdYBxue?=
 =?us-ascii?Q?tuhcAQrTl4JSHtlX9yFRA7VpUQiwhak4W4yPwrEJX8zuHxwgUD7nBDuKgmA1?=
 =?us-ascii?Q?XnfGBjXkyADiHCY/WnFwfguU7Hh9lpMsRcJQRZghVAmWuX0rP6v47/i4zKwR?=
 =?us-ascii?Q?QmloWEJQ7aAWdwoSZ/B6Rn/Vn6xVI/qsCYJsDukTmVsYZoB3Ct8fUWKQ7sV8?=
 =?us-ascii?Q?wImS7PVnKQEWcKb/mbnM9Vt4CLvJeGAaJrnw49eEvSAVcdX2C8lPco5T07FG?=
 =?us-ascii?Q?W0uv+gjVXe2QxIF8p+T0F448lTqNF9vM2ZhRmP+9DKpHpzCu8pWs35mMH4tI?=
 =?us-ascii?Q?A2dgUoJKXUwyFJb445q8g0jYNhBDBxl+51rJSRQ0uEEQpwixHSHM4SbI9lk3?=
 =?us-ascii?Q?UwD36DYCRQSg4UFyyaD9QFDbtXBA2O77nYEiHxytcsfHwbLl/0A8VSEfnLp7?=
 =?us-ascii?Q?YhxHZTD19JmwSP+tybIoSxrM6N2EZ3bpo+eRa36ak/0Tmgp52IRLZFQveJd2?=
 =?us-ascii?Q?366PyQ2nx4P3v8l2MGjpRrGN1fVPSGqCrgghP3C8EzbifmAof52jXggScPFB?=
 =?us-ascii?Q?F6QwbbyHMw06BvdQNfnBFSj4YfWEwksJH+0sAFdQlVjbUaUzEgc9csRo4dQ6?=
 =?us-ascii?Q?Y9ECPa14nmGvbY8+8EzELRZUzS1SJsCBS4S22NZ2J5Bgq0DRg/JtltrmzJy/?=
 =?us-ascii?Q?T7XftYZbhtdGSorQ6uErf2lWQRMDUezTqtBb1uqZg1GutX8wYsXcUu3Gpwq6?=
 =?us-ascii?Q?mPsjJvwUBDLSXoUDqYA4MrPk6lJPOv4NXAA+pWi/eyNRO4f7Jjbp184bd7qZ?=
 =?us-ascii?Q?gXnoAM6j1Svgeuyoz//G6tT783Cm1ePNTdRm4JQ7GMIFzv8NDmnuwN66jeNJ?=
 =?us-ascii?Q?JuHYdyp5xi8ylfk/03QoNZqfwc7m6PQ2/mVyNF6TrU9/hho1NBHGXxOo9Hbv?=
 =?us-ascii?Q?EOeWhEF+iyxK672DJA367GiyeJLvL/88Kj/razjn5jDS2PJobI2OKfhMl1oX?=
 =?us-ascii?Q?4suk98+kN/ZYp9/MRY/Uj8SfCF/dU99swE8y0/bJ8G72JU7uCA+ddqMIenyc?=
 =?us-ascii?Q?o5ojFa4K7liCBhfEI52wJ0zP5d8JGEXJE8UHsmdaTdAIp5kZy0uRQy86LvMp?=
 =?us-ascii?Q?1k+r2uTF0hZ8M6SkvEVaQTXgb+0YaX+t?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?umpdYZ92YOin1esjeG+hVQivy8Oh6gPhG4QV7THCJ5XkDPL6ZT+wOrkCnjh0?=
 =?us-ascii?Q?TyVx2bn0G+PH4yBhMy0Nc0wYn8282Q6eqTsPs2HeZpmInEzwU0zcmU0rCTRM?=
 =?us-ascii?Q?nBl6ruuoRhDAw7b6PBlqMWu04p3T/WWHZjhrkZlS72C6ta5eq9H+xgREx9bn?=
 =?us-ascii?Q?U9iJMENYTc325P+o4TIsaF2/ebce8+Daw6kcbgEchpzt31oPZoVJ9zgcdYAf?=
 =?us-ascii?Q?ZiOuzM4qFCZVEYF47mVcEQsBMdjJtTUPQnYNsK2RM2xuGLL5d7VBGt0HcALR?=
 =?us-ascii?Q?3W1pYuzlyqA7MF1YQ2xvQPivHNlYL5VYrg9p20Il97j0mDJnvyztBAlouyc9?=
 =?us-ascii?Q?sSK0Dps5KU/j5KKe9BBYsEKSIA6LlP+ZJMY0ihhypvrTOT2DXFxTSi5psSfz?=
 =?us-ascii?Q?zDGOttQN6xy95p90OpXJeOBA7pe9jwauMiI4HtGmeRhgyi+T4zkKCHu9B4rZ?=
 =?us-ascii?Q?XtSj40aO43jsl9Vg0oarD2IRUVdAi5+xhK0Wb0HPRdcv3qKfPb+e6IPXsKUs?=
 =?us-ascii?Q?Ixxb9Wfo56+TFrOqTKwKNVHwIg50qx+ydoRSrEKw33aw2a5BLEWTPGlv3fT1?=
 =?us-ascii?Q?aS0eRY5uMRwtVlT4QoD1csgf4VzejzFmui8ZuBK2v2otgJziE7ei43vlT0Xn?=
 =?us-ascii?Q?Lnp/JMWz4wa1Lgb2sjtHzrI4kRoMNIw/CFfHX5fB8M0EsiTU0rphu10dMorV?=
 =?us-ascii?Q?FdYGsnGtFGkHYdBxpG7Lv3PwMX9UMMxKvBd12B6je8MpX49RIe2STicOsk8g?=
 =?us-ascii?Q?0jiQjOzQNirzAdJBtTPjqpBcI2NK9pa0tgMrAixz+e1/EqTqR6lFzUCjORMd?=
 =?us-ascii?Q?7FJp+wyqq8oenKs+6f3JI0ptZ/ChRk3Klt6H4Z21NVMmCt3D0rcqP1JQawnO?=
 =?us-ascii?Q?IJCi3lPEFS22fqdG+RnNc/gHNKHYAH7s0C/NDsmqKlOVS4e9PpFnHi5o2zNr?=
 =?us-ascii?Q?BS1MkpJKjyIVk0VK7usciAHiaDbP/E4S7VR1vPIpQZvAkD8WMw9V1W/fDmlS?=
 =?us-ascii?Q?xS+nwmyBIN5S1szG927uKiFTyIhdQKtMLpigKSBgQFWj/wseRSBtIdaxTXvW?=
 =?us-ascii?Q?/W7yjKI5kLVuU5rqvFSRZvp3rdb62uk/XrtGVEAil2YH0EB4SGc1wWrHfX8a?=
 =?us-ascii?Q?eEl10iizkm2n2F356xXANQgc1DBZQVlOy+67zCUg4nqXlIXGwjvg2ZdgoMa0?=
 =?us-ascii?Q?IFjLpWEE0qr2dX9EJ740TeQ5TTNbxdLAO1hThcJ+vYl2s5BJeQo0cb2ws+L/?=
 =?us-ascii?Q?U4HS1HdjPlJTaifkgcnfNjlMdS9P7I5GrQaLlQs0h4gcaQ1lFyXlbrnyP6Wq?=
 =?us-ascii?Q?1wvesWyv7ynnvZTfPRuAxoIFDDzZkoUIJMRthhRCWoWV/GyT6oW0icBoWFzB?=
 =?us-ascii?Q?vJhR1P2alQV3ZtlBwuBwk1eorhIM2ucdY6ve5UbVW3AdtIAhVfLeQL3t41RG?=
 =?us-ascii?Q?29S4GPQGJd7AXFFXFN+Gcz95cyyImgHUI+r7sY3fNcU/JuDZeJ7A1mF2CyOJ?=
 =?us-ascii?Q?wyx7DOrKuf71jo2mXibHDW4IzMrbcv337P2ow6y5SEtQYsYi3SDNyPP3p3CP?=
 =?us-ascii?Q?ljD9HtrIwcKjm9zTzTbNcvKaiMCma+Ixyjs3LArV?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 298e608d-eb71-427b-f96c-08de21b36f56
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2025 06:19:28.7696
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oSzyz3ZHskNKM6gmmKQ/4vFmJ6lBOmwac8prEzikVU+ayUKB/P0D4+z1emvGOZ2TXtIJm3+IAE8+1VijGVZ3fg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6344
X-OriginatorOrg: intel.com

On Sun, Oct 26, 2025 at 01:18:59PM -0700, Xin Li (Intel) wrote:
>From: Xin Li <xin3.li@intel.com>
>
>Signed-off-by: Xin Li <xin3.li@intel.com>
>[ Sean: removed the "kvm_" prefix from the function name ]
>Signed-off-by: Sean Christopherson <seanjc@google.com>
>Signed-off-by: Xin Li (Intel) <xin@zytor.com>
>Tested-by: Shan Kang <shan.kang@intel.com>
>Tested-by: Xuelian Guo <xuelian.guo@intel.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

