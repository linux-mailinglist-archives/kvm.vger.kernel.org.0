Return-Path: <kvm+bounces-59896-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 247E6BD32C4
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 15:20:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 349B83C6A37
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 13:20:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D66F269B1C;
	Mon, 13 Oct 2025 13:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e2TiXU4t"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AFFC2773F8;
	Mon, 13 Oct 2025 13:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760361616; cv=fail; b=tBB45Q5DyLesabqCj2m7bDDPaF9jONZHBp+RI7HLHXv+SKpy84tVdBl+nqf+pN9vRxzokLzFcRphjEwJ/c9f2psX+q8ylVMj2XrvPJ8Kkkjo9lkA3uZKSo/smbnxpoBEe1ZHL0p2729AWxQhhsOJXvdCUDSzQvoAJXq3qGRI+Wg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760361616; c=relaxed/simple;
	bh=B+kQnGz/qpuw4NivkkPUX+XbEdt9kTQ00G9On4OX2kU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=OiZXDcuMY7VLxfUSi7Iq7etN3j0EivSKTKnwzCVD4ZMX1qQvbVRqsB36d2Enox0gt9LRvLuFp/PMu41M21LZ6qFE+ZZHtfs0o6fw/XCb/5HiJGjVux4BhVosxZ0SrSRmVPr9AsItIBF2p0+Wqr3Wbsm4/AD9hMuGtQ5Eajhnq28=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e2TiXU4t; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760361615; x=1791897615;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=B+kQnGz/qpuw4NivkkPUX+XbEdt9kTQ00G9On4OX2kU=;
  b=e2TiXU4t1tsM+fUVIlCtNpmDG58RrIQjW0qYHN1v/ZTBpJvLFPN/4wyF
   kQG9eqd0Hy1piwaSWbkT2DcHpL7P6oWKu53OO7nyQGlUPYXW/j0WBdgcB
   WEQ/2YlmG6E4TOM4IkKDS5IaHJnUP/VtCsGRMW0B4npQ4kN64/TraLV3u
   QS3XBq10THFuwjIviD7P7V3qmKnflkv0vue426Lm2KppqI5tjyGKhHDn7
   vAP0e9Ac+Z+mOD/2ORtEb6I43eX1mVuM9QF4b4g129e+71+jyyufkZmDx
   VfstBDxgqcfAXdCxi4eFg0Gc6QmWwQjfRLkYpMbCopMKc5NlA1kwHN9bh
   g==;
X-CSE-ConnectionGUID: rNhPnbzxRNmN5zOsFhq0Jw==
X-CSE-MsgGUID: MF5LrwIfSTmstEKVZpz5GA==
X-IronPort-AV: E=McAfee;i="6800,10657,11580"; a="62594078"
X-IronPort-AV: E=Sophos;i="6.19,225,1754982000"; 
   d="scan'208";a="62594078"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 06:20:14 -0700
X-CSE-ConnectionGUID: tVaZJiLdTqmLowxrVSbhaA==
X-CSE-MsgGUID: pP41227xS9uBlRfEgIw2LA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,225,1754982000"; 
   d="scan'208";a="186888301"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 06:20:14 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 13 Oct 2025 06:20:13 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 13 Oct 2025 06:20:13 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.2) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 13 Oct 2025 06:20:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mXKtCHHEL7REbo8YBGiY96u6+Jj6sp6EIvwg8amCnizSrQfH0+bmegMge2fFe+DRht/MyU5/tF2Gu6lW2Sk9z2/Ig26gv0jUvfEB8bN3F7cjEqaWd/7THzNKzWjIOWevWR5aRJvwY35iOR3/3xjpsaP3ob6R8UvcqxBKS+MLTj8zONEJowXutqK68RINOKMoYJ3HJwHabdYoXIbTGmRSr28fVMG3TQn91LfUJrR5+6H5CwpFbcdUtjDz6NLBcgoTmJOdtEGtGShEP1PJQDGgw3WfqmQu4VGvP+l5B6EeZt30mVVRInfAyn/lPx1uIifMcN6EOu28iFKVr2cDVsMr7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RfZMcyEDkASXM01RdqYZvn42zQTuTBGElRo51WupTDA=;
 b=FPffv8oFXokbT5vPfi6DTOyetkRUa8TEgRsNxR3zF+yoECGVKQ9BPsfsA8KNc01JFDnE7AQ0Nlr1WEepcAvObJHVnq1s2TOVrTSZj56sQzSbwF8aaEj6zi6219eoVRY+AKq+ucnwY8hjMEG00+Tw73SvZIbkN0OxoTXl8S/Iux33GMLdXZsmaAJCKyp3UH5Nob2g6nN51Q/sSzLcsR0xd6SLNPd3b1FLQ8vzIPv/FKM839Mnde0Yej99smdOk6d5MfOTpR4FJU2qLIYbKpdOQhkMPFWKo9AmXaJM40S7l3Tz4GozeTz2d9vUbroVx9QnJvQ1REgjYPw32JLQ9Hmg5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SJ2PR11MB8470.namprd11.prod.outlook.com (2603:10b6:a03:56f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.12; Mon, 13 Oct
 2025 13:20:10 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%7]) with mapi id 15.20.9203.009; Mon, 13 Oct 2025
 13:20:10 +0000
Date: Mon, 13 Oct 2025 21:20:00 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, "Kirill A. Shutemov" <kas@kernel.org>, Paolo Bonzini
	<pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>, Dan Williams
	<dan.j.williams@intel.com>, Xin Li <xin@zytor.com>, Kai Huang
	<kai.huang@intel.com>, Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [RFC PATCH 2/4] KVM: x86: Extract VMXON and EFER.SVME enablement
 to kernel
Message-ID: <aOz8gHzmZ8PdsgNw@intel.com>
References: <20251010220403.987927-1-seanjc@google.com>
 <20251010220403.987927-3-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251010220403.987927-3-seanjc@google.com>
X-ClientProxiedBy: PS2PR02CA0049.apcprd02.prod.outlook.com
 (2603:1096:300:5a::13) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SJ2PR11MB8470:EE_
X-MS-Office365-Filtering-Correlation-Id: d715cf89-5d40-43c1-947b-08de0a5b3c3a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?t/YdiCGgpkhaBlx3kxnWZx3nErmagBnYsVSsTUGcYw3xGWFnYAMobrUjSNmp?=
 =?us-ascii?Q?VAITR3mdzKyygcL38tufz3FjAn1AWp4PzCbZD00kh5mupdyn4B/Vcx9b+FgV?=
 =?us-ascii?Q?cWJIdeORqFDd1ihlhCkTcxGNHj+E46CwTDirZa9hIowv4zbO1LwuqAFso8WS?=
 =?us-ascii?Q?B/7cA0iGvxBQQ0xdsA0juXypik0hPcBOKmlbbwVOW96DabG4TqdRfN/5QeIf?=
 =?us-ascii?Q?88RmWwjV8XVDi8KsX1NlkRFF8Rfyddnw6vFeuFmLwBAsikF8RI7E/wkKgt35?=
 =?us-ascii?Q?wF9kqKn9zZ/DDQZ3/COFILlyZhNFoNQc16szqYBX2sP8mUv/cW+gUNtrrhk6?=
 =?us-ascii?Q?dYDzo4/8IEfrHXiRY/lFyBKfmyxmsSPFsHkZGJrBAAYbApzQ7FHyV/AxD0en?=
 =?us-ascii?Q?0KLAh6y2w8skS7+SHmJXgGjkGt/Qd+p/jk+FV1pWjpGh/rSzcmQ4OstzbeF5?=
 =?us-ascii?Q?r2rTDZEoiZ1XfT5yLWSKPPXZVhvS781i7BEq+9OTj2tc+yahgXh4B3389OkT?=
 =?us-ascii?Q?+9siXe5umE+Qaeakg6kCZiSpDAh8DzVuJpOj4RBSOtGP3VvRRkcFk4oyhWKp?=
 =?us-ascii?Q?ZKPgV8xNvZfDNgLOsLW2pAHjzHv1aFX9JSbFXEslSidwb5VZuzDVjbhHp8qZ?=
 =?us-ascii?Q?WP+9inIxMdIE9PzvNO47vmKHc5cQlmdlfrfNtyafLLsYmNy12AcBbc2Z/v4s?=
 =?us-ascii?Q?YaxtbU8D6rfaPCXmDYBgWsRCrR/FjY6wb3xEuSmf/bmpmWknwETw3e8AoVRH?=
 =?us-ascii?Q?VnY+MqQ/D0jvZ2pKcqod7o49Q/vJdCuh4PogXiMxvzWyf4GvHzqwEswOOa8I?=
 =?us-ascii?Q?njszKzKei/OH5nw5PkOEJOuFhTY5CMiOXK0c2fwWAznisnjCqkVs1eFTJYBU?=
 =?us-ascii?Q?3xQf7SneLrN/wQScVfpnjlDBem+r+vdJ/uFQzuuNrIvU7gXRtQ1qVitSfmTJ?=
 =?us-ascii?Q?P44a7VKFvSZfxsgyMk8Kg4ZW2WgSecccCHIjNAcWvmx2LS4AV1o0XogwEkR6?=
 =?us-ascii?Q?PHryK1qFYOXujLATUrqJ3nXFt1z+r66hdXnbUJLkKVE4lq781vm80A+gjy2T?=
 =?us-ascii?Q?MHieic5uQxTR2gnB9OIGlVEct0BWOqFK+Wn7RAukUgkHeBuB3QeFRFp0aEiU?=
 =?us-ascii?Q?XnAd4PJyFw5xCqAHRLAGFTULSqlg/VBpmVFNW/usI9w6pR+WgSe1HTyu6Y5J?=
 =?us-ascii?Q?coGcj3ttGe1B/7xiLid/KRVoE0BU1C06d0hU3hg449KUVgLhl7zjq+Tv0InW?=
 =?us-ascii?Q?4zwyUzB08cWvSE8e0Law0j2pa6sfbBRuMxPC+u+IDtkGfUDxkmpcxgzD1lZ9?=
 =?us-ascii?Q?SnBRjr0bbUKysgps6KhMCwz/cKU4R01swb+CkFnq8vhxc6X5bOWGmZzwb4Vp?=
 =?us-ascii?Q?DIFWauS3TY6vcB0QphHH+4cCLy1ETwCAKjf6+/YGbb26Ll12J+vZ1yGBgA5r?=
 =?us-ascii?Q?NPHX37iZULPryaPa7uXUk81Ln5lVYC93?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ssqI+aZDlMnXmH5/z2n/PpT2+DnGiOZTg3hgh+yF57+nlTNnJ+aLKVuH7EDM?=
 =?us-ascii?Q?2Jh1NjqCuIUjlDwTy3pZnU0xOa4UKt9W2cxVYYLgNt+cYc5C1AKg0PkpLRqn?=
 =?us-ascii?Q?kWUqDJPQtiMkRt/m12Pe2LbxRJMUh8E/EyCtBKpuQGHu7FQvES55tEP9aLFJ?=
 =?us-ascii?Q?Pu2qJLxVXTvSDE2z7POCcKLyf6vt3gmKVdEUPSkw4ZlI/YuXGEAgOCmop3dC?=
 =?us-ascii?Q?4FvNkwNcOY0hkJU6DUKh0hRzSZW7oHH9sWWDUV5aRvkPRfU22+p/aCN0+iYk?=
 =?us-ascii?Q?VA1zT07kwH+MneIb81q5q587RYfbSno/0TEZ39OnjKzFSRtPDMgv0ReDwCIT?=
 =?us-ascii?Q?nvTEM1R8Ya564bukJXYMujUoYcvN2RBK/8vCkjGTfDup6xe6h2KW7lrLmeHi?=
 =?us-ascii?Q?48V2lfNMST6CFQZJqwuA7Irgwgw67ZnEG/DR4Q/VCoQiC0B9k36Yz9XxfmK9?=
 =?us-ascii?Q?GJ4OJZBW+BefV9XV2k2LxFSLH/hn+rYXsZPJG5TEb6SSM5Qh3Dlm0Zskuqp3?=
 =?us-ascii?Q?VXaqJm3g7a0zjxUJT/rf8XKdZY8KJjgckZ1eNC5Zt5vnupTZg71/DwWrwCOC?=
 =?us-ascii?Q?NF1jz2s4EohMvg3m02deFQaDTjDT3FYlz8OwFY53/1MjukaIW6Jd8uWY7U7j?=
 =?us-ascii?Q?l5Dk1IJJ3Yjn0HwXQITR0zdT2qbL4Sj3lS1b6zwyyScy24HTfuixlNu+Ynl4?=
 =?us-ascii?Q?FICtmuQ8enLlGmVsD5u439rHVCfWXU7bnSI6tm6rfZOvN22lifuYOMBI4wTH?=
 =?us-ascii?Q?sruPiN7rAnX5nnT9cnMpaQIPUqPhfQOEEfGngN+KdEWBC5d0twNS5zDHONBm?=
 =?us-ascii?Q?TiSnVEfjCkdwq0Qc+gUiw9sEokAi3sCDFl5BSecV4UENGjvVFwQRg5hqfzMp?=
 =?us-ascii?Q?i2uSfXB6TJC5W0gz5KHCLr4MSn5Ajrot05HV5a9ACEY3UTxSI7UzpPC9b952?=
 =?us-ascii?Q?558oqLRT1sTEYh9bRspfOZef1KeiTYrbw8yAc/41bcrw/0X0qWrEvQ6kFJG4?=
 =?us-ascii?Q?euNNshO31BfNgjTmSgEJxhqZqpC2i9IZCPtpv4K1hG9Wp4OTU1sK/Zf/VpiZ?=
 =?us-ascii?Q?GRO0XmFGfOiz2zfETeZo6tgYo4OhJx/JnHJ+cNXo0LMII8V2eW4j/edhFGKs?=
 =?us-ascii?Q?pYf6MCNANoXEbcVPmGbqkXVc56TLaypYfW1zwfrdCwmqAD0YnwQFFqTZFs/U?=
 =?us-ascii?Q?xVctNaWYgRmqKITksgBfT7g2apmT08qX4tjai8+lOCqAZ1m7PLusVzi4fjHl?=
 =?us-ascii?Q?/tu1Dt7Szavyi4fEib2mrNkqvmX9c1tuPAqHbK5xFjfm3a3yy3RfxXUOkhjN?=
 =?us-ascii?Q?oPh2O2VPezp3qEaJKZjAyZ6MSByw46CKAWpOk40m8ys979YIcc6t7gUDZMlJ?=
 =?us-ascii?Q?uw//mxWaGR1TVpCibigVRa9D8uRiYfxkUSpg5Uh+wsIJgr1Vxb83Z7GZMihu?=
 =?us-ascii?Q?6M+HjnwYWlEZqLD03tE8LnwNshPIrmbMuPpTkH/XEVbeihT9AMSFzLF8n4Jg?=
 =?us-ascii?Q?wIEtPVWLdBRqzw06Jmly9vOMwbGXuQmMwaP5JVJ5l/S6smDOHNEGnoIsd5FV?=
 =?us-ascii?Q?yKhR7lQ6ldw2WOGv1KLi54yMyNUaFLZekoS9VXSK?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d715cf89-5d40-43c1-947b-08de0a5b3c3a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2025 13:20:10.5200
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GsT4C02pRzOolYw7CSquBGAbgUX+1uZseqER/rxLruQYrGYleLYza5KKKzL/KsuFIzY8sE5FlG+MnbiobkO7ng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8470
X-OriginatorOrg: intel.com

>+static void x86_svm_emergency_disable_virtualization_cpu(void)
>+{
>+	virt_rebooting = true;
>+
>+	/*
>+	 * Note, CR4.VMXE can be _cleared_ in NMI context, but it can only be
>+	 * set in task context.  If this races with VMX being disabled via NMI,
>+	 * VMCLEAR and VMXOFF may #UD, but the kernel will eat those faults due
>+	 * to virt_rebooting being set.
>+	 */
>+	if (!(__read_cr4() & X86_CR4_VMXE))
>+		return;

copy-paste error.

>+void __init x86_virt_init(void)
>+{
>+	cpu_emergency_virt_cb *vmx_cb = NULL, *svm_cb = NULL;
>+
>+	if (x86_virt_is_vmx())
>+		vmx_cb = x86_vmx_init();
>+
>+	if (x86_virt_is_svm())
>+		svm_cb = x86_svm_init();
>+
>+	if (!vmx_cb && !svm_cb)
>+		return;
>+
>+	if (WARN_ON_ONCE(vmx_cb && svm_cb))
>+		return;
>+
>+	cpu_emergency_register_virt_callback(vmx_cb ? : svm_cb);

To be consistent with x86_virt_{get,put}_cpu(), perhaps we can have a common
emergency callback and let reboot.c call it directly, with the common callback
routing to svm/vmx code according to the hardware type.

>+	x86_virt_initialized = true;
>+}
>-- 
>2.51.0.740.g6adb054d12-goog
>

