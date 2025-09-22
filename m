Return-Path: <kvm+bounces-58366-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 57655B8F64D
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 10:03:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E8D3F4E06AF
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 08:03:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6332E2F90DE;
	Mon, 22 Sep 2025 08:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iO0VuZSZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2CD41531C8;
	Mon, 22 Sep 2025 08:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758528177; cv=fail; b=aOlkUuM6WjRg5VbHQ2JMQS2GS6JIIwExU+2UznmrUZTURtPz1UryiRmNJo/5tmaZ2Jxj1qAjeNtIG+6XYwDwC8Ms1kbY/GQ/js1jU+wGcabu6t9ThFpRIK2neNc8LauoUV+V8gCct3MLyyycD1MlLokU1oI1RyXJRwlSTAgCRVM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758528177; c=relaxed/simple;
	bh=4sc2xLa4NWga+tFQw05Fld1jdeXBEyZ5FvpyGjg2ANw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ZNR3trZxNLxBVnPDaf1Nfhk62N+1DINf10aRmROFbXo++q67NwBzbwZ9OEdw+XU2daZeSWRsMrtWr7pPt1bwMGDQ+DTqaS/PT+wSMliwomwn3QMMTYrcOKy9oPEBOClDAFt9+G/y4faDd6hwXoqtAnNHg+E2jrSSf3/had3DItE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iO0VuZSZ; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758528176; x=1790064176;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=4sc2xLa4NWga+tFQw05Fld1jdeXBEyZ5FvpyGjg2ANw=;
  b=iO0VuZSZAYwe8DPLlax7QzdCoGhecNnYqdRarnfSss5NLWAwJ/xCrpS1
   fqZAIoKR/cMRCCc7FVcWzhylTACFsVuFJcsUyVk1nb+A3Y5pLnxb5Wnky
   nrSN80v46jaQ7qzBleINnRsC1A1esvtAI2M9hVqMBw63lMJy7a3bZUPRJ
   vu/TSGgrre+oadGBLT4EXiK8uM/Xsvw1SR+6lM5WmKDP4wcLkY6WcJloG
   HefzGkFm16i76dDOTbV8r89ocYqet55g+IVKtLahBuwgcEJVGgM/KAqq/
   pgtWxGkLUZl+y4P/2BaqQWhyreLMNxJYPRvzGboT+1cvOfcSHaAEcWmvf
   A==;
X-CSE-ConnectionGUID: S7NNfmt3QOefJspneMaPxg==
X-CSE-MsgGUID: ms8e3RG/RJSHRrAhEjccgg==
X-IronPort-AV: E=McAfee;i="6800,10657,11560"; a="64422589"
X-IronPort-AV: E=Sophos;i="6.18,284,1751266800"; 
   d="scan'208";a="64422589"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 01:02:55 -0700
X-CSE-ConnectionGUID: 7/zGXynJT7q8SWCHG95lJg==
X-CSE-MsgGUID: C5vodmeYSpq7Sg0bbYgQ+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,284,1751266800"; 
   d="scan'208";a="181666844"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 01:02:55 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 22 Sep 2025 01:02:54 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Mon, 22 Sep 2025 01:02:54 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.21) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 22 Sep 2025 01:02:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rDUQFwlFqMJMdenHVCFEj6fRyhENxrEItg6wOBeFfAHT7c0a1ClonQ2+WMI+wI3wVKOjZlTaGQBoFve+XwpE88j9lAeYZ7fzuj2IMa9+z5quP2L55MEJNJoEj9UZ5S26OPq0+P439xUT8pqZW/ZlxSBI8ULF6wwE3y+OX49xRj3J5Kcq4aByaUgnUhk1OnJmE/4/4OPNr1X0T+jOK+hug4gb8G63kSixa9WMSRp4L6oP6McGn3N5cnBYUiGrB+QE62BcWdnqsDuDecJUhhJzpjek68myFCEemNB9bdcLT5/S9ZGjiAYkgw4a31/41D/Od0d3ngMNHODMZ0s8u+CuDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jYi7rK25uBhDL14JjQzhmOmtA5+NnScvkRiYveX/kAw=;
 b=T3d6aFef+wxqzV7brJFtVt4LqVsE49LpOaEOrlkTThpXWZAWEZMWNgQ2nxUDZDECtcZpAiwWtL14DjqkC795o7X8XO47J93832jewt0iLRmnPu/Q5ZtYgM0QuHCH9lmISRhWGrLUNU/M9u2/O5LsPVGEpD7PT0qHAqiyJWHLwPqQ0vqn2dKgJFJko/+YGHTb+GTDTYWSQm8taVmknX0EVuESQiGFt7muwAJgv+PnAnRzqrN9DrpewWS7RabzDUbKBeJqY9pbGPLwmBFaaWF4I7kxGjsF3BCTk2Ca52gkINqLrBwz79dFffIeMHgQVuDQk4GGxJSJ6gXJCieNcG5aAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CH2PR11MB8868.namprd11.prod.outlook.com (2603:10b6:610:284::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.14; Mon, 22 Sep
 2025 08:02:48 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9137.012; Mon, 22 Sep 2025
 08:02:48 +0000
Date: Mon, 22 Sep 2025 16:02:40 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH] KVM: x86: Don't treat ENTER and LEAVE as branches,
 because they aren't
Message-ID: <aNECoDGVRjy1OMOn@intel.com>
References: <20250919004639.1360453-1-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250919004639.1360453-1-seanjc@google.com>
X-ClientProxiedBy: SG2P153CA0043.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::12)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CH2PR11MB8868:EE_
X-MS-Office365-Filtering-Correlation-Id: d3601baf-ea84-45fd-b98a-08ddf9ae6bab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?gLBZU62rz1bFX39c2fWIgRjenHQyPmPwy25Ea7z0KM0Py7J7U6MqJhTYR/Dn?=
 =?us-ascii?Q?8w+gczX2pJffdL/rQp9895MytcHaSl8S3X5wI5Hl0lTDkgzOcfbIkYmvwsO6?=
 =?us-ascii?Q?0mMuciTI22FOAI0ieh3tm9B2IntTfCC42T1Hj/udtLr76kvPihHzJEjIFb5y?=
 =?us-ascii?Q?aMZt7nt4CUpU4YG8tIn3u0IlSVh/I3wi32pdvIi7oiiBpRNHP8dXcS1mecl9?=
 =?us-ascii?Q?YaOeeHAWQduw/B1wRSBVe9lVda/6LdANoJBRp4mztXwowPGYR6b3f0LEX21D?=
 =?us-ascii?Q?nyP13F3E60SUvO180Gma0wijIWULGt/HB48CbWVknx4+0ybhbCUataveN+1t?=
 =?us-ascii?Q?WRa9V3rMYXhY1BoZ9QG3IsdkgiDfzQrwg2nwm5JkrGNIzcW9D84f6VVwThmA?=
 =?us-ascii?Q?zpmyFcxxYi5+Zqza1amBlkwwH7Jar0Yg/YHMUYe7xntKvwgTJhcriqMP3wUZ?=
 =?us-ascii?Q?ugWMtXRYyu7DmfqQV5PCsEVq8BVW+LhYptug8GwWVbhILZnFt2neVSkOUe0A?=
 =?us-ascii?Q?Zpiv32F2O1HpGFb6yg5vQjJ3+GQ81iZF6lgFjZrERJnFnDRMP0geMn3i5/8b?=
 =?us-ascii?Q?3ENto7gOJv26qzkcOi71Djvl3tHh9fh6Eg4ixtamXY1EZcTCkN4/g6K6LkgL?=
 =?us-ascii?Q?0sEFBZAXyVj3dwLl2QGDMaQ3HwlE5kgg2DANzdt3l5cQ8mn8w+l0puaoO8mT?=
 =?us-ascii?Q?6uEm3dE3Ohcfuhdr1eRzmFCKv21BJnok7LKBPmOEnKpNGQnUIOv7Xf5TRKhC?=
 =?us-ascii?Q?RS8kMdNm4rY+3qpsSg7lYhbQ+rEMyKnA/IXdx2k+oQXI6CB4lqtsjGwzoz01?=
 =?us-ascii?Q?weN3/Uskv+RvqeWgCoNuImgGYKLbtz4piOYqzY0DbY1YxirHo4sfg6ioGiZZ?=
 =?us-ascii?Q?5uTruYmxh3YII9WzGEyJOgV+wuqIPQPXTjSuUOB0cD0cAlfZkVRp6eLyVw8p?=
 =?us-ascii?Q?7Q3+kiZ2cZbkrGUOORcKrnZDcksJNyI2g17Ueg/S7eNwts0OnLzziXaaYbyx?=
 =?us-ascii?Q?9vp3J9d2/rgwBDBXdM36uwGSox5FU3r6I1vJifGD9itZaV1EEsPbOO6W/fv3?=
 =?us-ascii?Q?EWwoY7hXRF+lcb7jnySl/tXigPwbn3m9Dvfa1B2Sfjz9kyDICG0+2PD6EJUl?=
 =?us-ascii?Q?5B0Rt4AmM+hHkLzjIEh/gSUyUFgnjv9DBuUwXwXUhrVNiPiB7Lpcn79nwo2h?=
 =?us-ascii?Q?+eYV1zCkHDoEMDyBZxGRougYn+SdsQlWKxin6cJmeKVZmgTVmGo5hRdbnGTS?=
 =?us-ascii?Q?iFRdpEofTP/Dfsg6cUOAu73LtsOn0yyYZa6U4AZeKLvxgv/K+16OHnC5Qwr4?=
 =?us-ascii?Q?AOwMeQ9UllV5G3u+ZjB3izBPIafERGEpXctucN/ZvcSY2Eakwlzzc0EtkLAu?=
 =?us-ascii?Q?O+a/+CyHeR9aqop2R5OSBCn/jJY4sLo2pQ1K6AIn734Oa93i8jBMH9IyuQN0?=
 =?us-ascii?Q?3XMcjl/zBwY=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SBwXTJ/bcK3sjYcCliEElHKNfGM40HV6gr0DQmg0jw5PcUaEGVAtReTGSAUE?=
 =?us-ascii?Q?VSJD8jKe7e31hB3Q9l2driJv+UwcyoKAEpzgJKJVcqQZYb+bMhG6/C3yTKus?=
 =?us-ascii?Q?IbeCjCH0fEaMT5XgFgCb0WYczJJrPbSBzmFz8skVigSZsIpFli/fVQnHjUcF?=
 =?us-ascii?Q?9nFeF9Il7Accj/K+EDmk1vQ0qSMTL22ThRc81QOlwtI2GLc6GfIldsswfOMF?=
 =?us-ascii?Q?nV6nZhKT1l8kxoD6fnfKgh8Y3xdjXRLLyeYvW9VL9NWzhWHO7g3/v/ULJKi+?=
 =?us-ascii?Q?6hUNoZB2WC94E3jfoaAnYwa02Oz0hiapYkOfjdWd5t4k9NJIHZhzDOH8Ph8p?=
 =?us-ascii?Q?q32i0px5NjZj8LySG0l78q/dmdSmJultDmb4O/FbmEcNT06/mZ3z1qjDYDNf?=
 =?us-ascii?Q?Yf8BRKYQWyN24jfVgUmFxoUhL7Y9nMTRKADLTEv/j4dFl7vQj7sKCWPG3fDJ?=
 =?us-ascii?Q?Fq2gVAUXzDPqA9zfxOZv38ywp8R2ZgEvZP2rH92eTstmLMigtgIi9pRw03ch?=
 =?us-ascii?Q?PqkCyedwIXoC28/yDJtbXyqiXCdWEer6+X0OT/4iE9dPXE6pbmulCDo2u/fB?=
 =?us-ascii?Q?IdMj3F/+Oors/9PlwbVOxRKMzESiSHR1k1ahMiMKCdZp5yJDOcbMSjlG6i7l?=
 =?us-ascii?Q?t66WoKyN9FynzNakbyW841JZxEj/Oo7Gp+lgjZclTI8pB7OzrqLLjlxIkUxt?=
 =?us-ascii?Q?c7WX1uxjO/VaVxTQmV0nWBSpaYSDBhaNr64Ltx19QVkB2FZ1QfC9lY7tYvHZ?=
 =?us-ascii?Q?cFg9rSl7VRhQLHf+s4icXbYAdBKw43AqACweqYaICkDcSCA2WRnN3ACKqzmk?=
 =?us-ascii?Q?BCPsWANubL/7kmmORWaNJfjAuTGeUVej2wEw0TKyFOllbRF0N49Lg57HQNjO?=
 =?us-ascii?Q?vZokVlcSKySw++RM7wLrlgouKGDBckD9ENdSO/uDh3jJOBpHNZULOb41XRt8?=
 =?us-ascii?Q?KDNLFDmqC+S51M4Em2lh3bZpWBewjonUBNxBI3qruciKWuhF8vJ5DgoSYxKL?=
 =?us-ascii?Q?0Vq8rI8I24c6UX4+etnopbtnEwe6anmAZ26tZMBzTIQ0VlBOYve76GO02cMO?=
 =?us-ascii?Q?eC19aQjWZTusDU/vfqPmRHO9LSRwNhYfsCcsFUp+TCutQO2+DIEG+ANTEnf7?=
 =?us-ascii?Q?YdlcSv15GgbKsDq83cW6cxWHskS5wfZzsEkUydRYPCa463K476T9GB6b4S/i?=
 =?us-ascii?Q?ikv2vOkdn777aA3/Q3vUR6gCrV82Y8maVH/XYNWspTPoewuiLyYUyRgSPs4C?=
 =?us-ascii?Q?qqi8JAUtejuK2mNaleZDuIBUBigUV9g7U91xiGygWbEE4+j/WFisHFNJI2eF?=
 =?us-ascii?Q?hCsfBp/o2RnuAFB0v55VbK/dgT/Vrajh2gqYyDB8vu2sIM5aEaTKKBjC7bva?=
 =?us-ascii?Q?WXoIaAkPM8VdxxulchV6PnB94giMn8Y9hJdx4WA2wi6az4HK2tahxnZgglFi?=
 =?us-ascii?Q?+QNdMTMWj7aaWN93d5I5I2XZuwxJsWLdXIGKKaQvMx0XF9BQgnMJ0xRJZu3N?=
 =?us-ascii?Q?IKHoR3hv+NLZefL58Kx1WqgaUWqLijA4IkZbUBwE9t0o4ZbtWC/wrn2D3B0g?=
 =?us-ascii?Q?rcj4JnxVlQPJul1fkMkZTDHuvu2JWliJbhLzy6G4?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d3601baf-ea84-45fd-b98a-08ddf9ae6bab
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2025 08:02:48.4197
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z2aZM5Cp+sV4rxkxsfimtOcWYDZK8GJ8vr/oNJyJh2u9DH/jmxiyXCZgx8Wmj197wg7u9bxCE6emYHKpqq5AYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR11MB8868
X-OriginatorOrg: intel.com

On Thu, Sep 18, 2025 at 05:46:39PM -0700, Sean Christopherson wrote:
>Remove the IsBranch flag from ENTER and LEAVE in KVM's emulator, as ENTER
>and LEAVE are stack operations, not branches.  Add forced emulation of
>said instructions to the PMU counters test to prove that KVM diverges from
>hardware, and to guard against regressions.
>
>Fixes: 018d70ffcfec ("KVM: x86: Update vPMCs when retiring branch instructions")
>Cc: Jim Mattson <jmattson@google.com>
>Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

one nit below:

>---
> arch/x86/kvm/emulate.c                              | 4 ++--
> tools/testing/selftests/kvm/x86/pmu_counters_test.c | 8 +++++---
> 2 files changed, 7 insertions(+), 5 deletions(-)
>
>diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
>index 542d3664afa3..23929151a5b8 100644
>--- a/arch/x86/kvm/emulate.c
>+++ b/arch/x86/kvm/emulate.c
>@@ -4330,8 +4330,8 @@ static const struct opcode opcode_table[256] = {
> 	I(DstReg | SrcMemFAddr | ModRM | No64 | Src2DS, em_lseg),
> 	G(ByteOp, group11), G(0, group11),
> 	/* 0xC8 - 0xCF */
>-	I(Stack | SrcImmU16 | Src2ImmByte | IsBranch, em_enter),
>-	I(Stack | IsBranch, em_leave),
>+	I(Stack | SrcImmU16 | Src2ImmByte, em_enter),
>+	I(Stack, em_leave),
> 	I(ImplicitOps | SrcImmU16 | IsBranch, em_ret_far_imm),
> 	I(ImplicitOps | IsBranch, em_ret_far),
> 	D(ImplicitOps | IsBranch), DI(SrcImmByte | IsBranch, intn),
>diff --git a/tools/testing/selftests/kvm/x86/pmu_counters_test.c b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
>index 8aaaf25b6111..89c1e462cd1c 100644
>--- a/tools/testing/selftests/kvm/x86/pmu_counters_test.c
>+++ b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
>@@ -14,10 +14,10 @@
> #define NUM_BRANCH_INSNS_RETIRED	(NUM_LOOPS)
> 
> /*
>- * Number of instructions in each loop. 1 CLFLUSH/CLFLUSHOPT/NOP, 1 MFENCE,
>- * 1 LOOP.
>+ * Number of instructions in each loop. 1 ENTER, 1 CLFLUSH/CLFLUSHOPT/NOP,
>+ * 1 MFENCE, 1 LEAVE, 1 LOOP.

	      ^ 1 MOV,

7803339fa929 ("Use data load to trigger LLC references/misses in Intel PMU")
forgot to update this comment. Otherwise it is a bit confusing that the comment
lists only 5 instructions while the macro is 6.


>  */
>-#define NUM_INSNS_PER_LOOP		4
>+#define NUM_INSNS_PER_LOOP		6
> 
> /*
>  * Number of "extra" instructions that will be counted, i.e. the number of
>@@ -210,9 +210,11 @@ do {										\
> 	__asm__ __volatile__("wrmsr\n\t"					\
> 			     " mov $" __stringify(NUM_LOOPS) ", %%ecx\n\t"	\
> 			     "1:\n\t"						\
>+			     FEP "enter $0, $0\n\t"				\
> 			     clflush "\n\t"					\
> 			     "mfence\n\t"					\
> 			     "mov %[m], %%eax\n\t"				\
>+			     FEP "leave\n\t"					\
> 			     FEP "loop 1b\n\t"					\
> 			     FEP "mov %%edi, %%ecx\n\t"				\
> 			     FEP "xor %%eax, %%eax\n\t"				\
>
>base-commit: c8fbf7ceb2ae3f64b0c377c8c21f6df577a13eb4
>-- 
>2.51.0.470.ga7dc726c21-goog
>
>

