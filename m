Return-Path: <kvm+bounces-58016-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 38E1FB85614
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 16:55:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E16183AAA2C
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 14:55:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C7A830C0EB;
	Thu, 18 Sep 2025 14:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="V5PG49KD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0683A2F547F;
	Thu, 18 Sep 2025 14:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758207307; cv=fail; b=GV1nUxv13tMLbeTFN86OchX9nsnu3AFC1sgrmM8t61zYkeAQaYbZdj9g5YfL9zN/aE+o6hfzwhkurNIovx6KU1hy0t9e+RM6rVQmmZzGc5BI1KxU03HJ7SDbONND9aMesvCGIaPFFRznTamHG6Genb+3YwQEgVNoakMbLgXYI18=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758207307; c=relaxed/simple;
	bh=FlcKDiOPESlWDEEf+XxSbRoZ2Aoqco0Hz/8YfXX5Jdk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=tA+NpkP5FK/u5zhCv5WPBX240JdjxXJOuN/xGo1fBuYb78wKoWglcUN12gmbrakFBB+Tq0mcGzhRKSze/UIe6jPT1FP799467CVsZ0P4SUXqel/PIFncFiXpPKigOa9qtoDNSQ6+cZvK6Yuv7LcqqNWuvv/ep/ic+o/FRjud9Oc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=V5PG49KD; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758207304; x=1789743304;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=FlcKDiOPESlWDEEf+XxSbRoZ2Aoqco0Hz/8YfXX5Jdk=;
  b=V5PG49KDvIxmFBurwrX3KEWFWkEh08xvxvhdhYidmAd8Hq8w4dfqjsaB
   DZjUPV8qcNPteb9X+xz84W8YojOBVP3QGnWWd0cV3y1nBgJOG25zoO303
   fGjPCOZILBP/s5qqRaNrUsVFIaEKI2GNj2t6UuPqgYKCSe+2Njz2ii7a0
   7Kzn6uhpmYgDT2v1SqiA9PXVtxnCfvQnRyJmbO5EMn7ffv+dHydY5zJDg
   91AkmaSc/iZyD+DnZd+JIBJNwcH+vTZx20vhu3FudsGq0bHstUuPl0dx9
   iuB/18oU+MumODN7tDMBOc5GE3WvtYbTJIx24II/xq8JFHrJqlJpFiCk9
   g==;
X-CSE-ConnectionGUID: Hyw/O44SSJ20fAVXr9fshA==
X-CSE-MsgGUID: t9Fo9SI1T0yGlsY0zt7HhA==
X-IronPort-AV: E=McAfee;i="6800,10657,11557"; a="71170794"
X-IronPort-AV: E=Sophos;i="6.18,275,1751266800"; 
   d="scan'208";a="71170794"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2025 07:55:03 -0700
X-CSE-ConnectionGUID: TRXyvlfNRQiWebLUmRL/PQ==
X-CSE-MsgGUID: p7XOZJOGQ5yYTm2eFI1Lbg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,275,1751266800"; 
   d="scan'208";a="179557890"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2025 07:55:04 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 18 Sep 2025 07:55:02 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 18 Sep 2025 07:55:02 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.4) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 18 Sep 2025 07:55:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nBm+wdhS4OQTdMNNr521SYvfvWGtkYYLDK/EMG1bYJUhabJLeC7OnltZl7RDw3s2t5QTUOr521zV2aRuvET7KZAuW3+eGpqApUaVSZjJ/tO6cR8hESHxSIt7aARAEVGzzE8SNQ61C9alVAoTSfcoAxys5emeS1RqvgoaHuv3PzHfuzKcPwAnqTwt3PIZPftcBpeibtLzgljZgSvUXdfsIv4+FWdGnbzI1t50PdYnBLGEzJN3tLtezPlm3wKJ471Rrn3C+dal6KdjtemksW7zqRSo0IdY9kBK8MBE32j1Q1P0ISo1V/iTQsPmNcv72pewcyGPo6fEUzvaBhMkW3/JNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6s6j/Y2YVCFKWswsaPy7J0lfpTX2t1HRiBFZ9S7bPi0=;
 b=fYcwZkTvQlhw2SK+r9o4gzrsdp7/YZlaX5/dMrY96uNq0zHpwXSZwO9KOR6LUXvvQfOigQGJS0Irr2OCOgjJ+B/wOdVmoNyqUjeBSsKX6/6hc92CdhiRpEVcN+PJQtp0JuKUAPpYa+yqAmWUo4iV5MhjClm9Fzimy1hmADM4reHtR3HgffPK9RbIvxOqhhJc0zSdRPfOehIYcMVlO0JwToZO+NplT2KK5nFlr8CYp16PdMXcOABDGI4NenFJP4bzFodXK1V+GqW0PWk33hgWOQcEs7yYagraPfgHA6CwwENIOhtgXXT8Z++JbDs5ZCXT82q21W0hxbFdA5Frb+fqEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SA0PR11MB4767.namprd11.prod.outlook.com (2603:10b6:806:97::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.14; Thu, 18 Sep
 2025 14:54:54 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9115.022; Thu, 18 Sep 2025
 14:54:54 +0000
Date: Thu, 18 Sep 2025 22:54:45 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>,
	Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Maxim Levitsky
	<mlevitsk@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Zhang Yi Z
	<yi.z.zhang@linux.intel.com>
Subject: Re: [PATCH v15 18/41] KVM: x86: Don't emulate instructions affected
 by CET features
Message-ID: <aMwdNTCYak/1wwS0@intel.com>
References: <20250912232319.429659-1-seanjc@google.com>
 <20250912232319.429659-19-seanjc@google.com>
 <aMpuaVeaVQr3ajvB@intel.com>
 <aMsk43I7UkGbmL88@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aMsk43I7UkGbmL88@google.com>
X-ClientProxiedBy: SI2PR01CA0001.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::13) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SA0PR11MB4767:EE_
X-MS-Office365-Filtering-Correlation-Id: 08987df5-5902-41bf-4939-08ddf6c353f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?SMm+5MF/Hf7qAdBcNTLIB7KAcFUGNQL+cHsogk5dYEPDVVhSCPyC9z3xBe9T?=
 =?us-ascii?Q?J2X1vU4h+Lxd6yd0YdkAEjYI0BVxQWSrbANmqt5Ppwi5sY2Bt5Y2e51IFtJO?=
 =?us-ascii?Q?vJXTqwnw5oMPQgKM5brEKpv+5FCoFatiCWdW5gkyvgYYS/mz7tANp+SBFWP2?=
 =?us-ascii?Q?p5RFNLgkYU9m5aWreAtq/B1mOQcgcRyL1W/X8H8VgSxjPmVQ3iB4ER8P32pI?=
 =?us-ascii?Q?bral3FTCSSiam68IyimEXp0Vh7OkRgS1i23V87FcT5VloRd+xAgeQgekF4nj?=
 =?us-ascii?Q?DVp8VQJU5C5+q5qFWcZHXCRWM20V1kKb7ICl2bNTwnxEZCJ+3YupI5xeTrvX?=
 =?us-ascii?Q?uVMfTGZrJfOX9E8qGYGrZHi2W6EW4w9x2F2fhaLOcqXX9gYDYZC/eQlfReRS?=
 =?us-ascii?Q?9lcHYZ3uIp87xF3DkQavbXdVXBjMMWJDsFdRHiG3doj2KRx2Gu79OSW+Jxm0?=
 =?us-ascii?Q?WCDgi8Ymza5qTWjR43AcXWZ1tSeUby6YZtY71XXz/sR+z9Obn2uYMKWKDGWC?=
 =?us-ascii?Q?KimwGt/an3jClyJrsgjSGvTgsN/s1aWVDff4PInUdgKscccVJ/4ydibcqoIf?=
 =?us-ascii?Q?tD+SrzDbwTvBjgCjt4K7GOByaobCuEY7Z1goEXAeY3KpvGKWOSMuTgUsTycI?=
 =?us-ascii?Q?4lzlcIDKh5Pd34gjmK9BGAsKLo+ZzGFqdj26C6DEU6RHVbE3LfHIZcLutCmq?=
 =?us-ascii?Q?FYSAdXavIi9WCr4RKh0B7BTqDG1F43xrJQIEqAGxk5eXzk8+ujsAH/GKkl7y?=
 =?us-ascii?Q?qLY+rQo+yD4vEf5SiHYs1An99cKwAGxkXNE45I8TC+D1fM19eNcaar9wuUns?=
 =?us-ascii?Q?Yf80xGD+TdQpOF5YJA3hz4fKJW6rsDyOIe3UsDtf7zFXDtDTF75h8CAWu3Vc?=
 =?us-ascii?Q?AAai687GKJ+dIWtZiI+XXSpkimusmgb3jAD6dEFuDG5EoFMwQ/Jf5J1TZuWM?=
 =?us-ascii?Q?3j6hTxKVH8JAwc0KXfbsj/oKB4Rc/PFbwsWxzmDoAfx4n6bq1HrEuAKRTgJw?=
 =?us-ascii?Q?Xo3lIEXOxJu7szlVRIVo+EK2ONfkCqCrI/r7Xxj7pkkRrzIIHpwPw66ZqSnY?=
 =?us-ascii?Q?/hKWVufWP0Os80PwRHYJmbijQr2JzH4Cw/g5rmCnK01O3T5WfR5GMxZm+mxT?=
 =?us-ascii?Q?wcqn1fszx1MZ5vCwvB4ZS/bjWoCgdduoKRulKBEIjxbSNmG9Lt6L7PCh2f23?=
 =?us-ascii?Q?BEEssb097j8Di5agd0/r0ISGn7n4y6MkutMuL1VnM23/eUKk0+SBjoK6O7dh?=
 =?us-ascii?Q?VuBRaxlDK+KgHR4kXHR9aqf8b5jLQRfQCtarJTnipODoCsqiyDy+6OeMftWn?=
 =?us-ascii?Q?1MJsQo5lo86ttSw+YyLQhzLaGcwjSp8LMKVjuCHCU3BrlmMjz54HisLQOuQ4?=
 =?us-ascii?Q?wQT8tH+chNiWShFi3HSnOtgWb28SpSlaQKBGRp6SQBfIWoqmsb85O5JJ+N+p?=
 =?us-ascii?Q?wkcg6DCaMu4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0wD5/+R9P1O6jzj6S0oA5YLS8GlE+EAvOvNAafOK5BZItYcdSU/RTv/qT9Lj?=
 =?us-ascii?Q?ukEPbL2BTl9UK0X52UNk3jYZuSWZj+oAfyVIXP7m0JBW5/a8cV4O+52CrGDc?=
 =?us-ascii?Q?cElibzbTLWR4oglnY/+I7YZCALL3yLnNSzLRjZMhYPQhQcoK7mrnRKrItq0d?=
 =?us-ascii?Q?ih5y/dg8KAtBKl2zJT7CwQ7z1inoUqzBiPElnMt/t+pwaxrCgdBsJirtERqX?=
 =?us-ascii?Q?RsuSgOdXw+ug+k7gITMUTCXrjt7Nbv7K0ddlo3i6hWndOK3VGprcTz3p+JQv?=
 =?us-ascii?Q?ozDy3Vgytpa4ATDrfsxMp7l7JiRbRedylkPKJgewU/65vw0VmIFPHPA/cPnt?=
 =?us-ascii?Q?itjghVmqty0hx4xN4E2EQlzT+Fbvi/WJewrzrzobOH6pbIAKGG/31bN2+UEn?=
 =?us-ascii?Q?/4VD83jERMP4Qvfl3gFB9UWbR4SCtVXYGytM+DXpkrwkZwHhkNrV+r4dBdKE?=
 =?us-ascii?Q?C9QvXP2R77booW+cdwbGvpVufMaOz39lanimrncjKSkDeshwa4uxevigabCB?=
 =?us-ascii?Q?yja/S/nqe4aPLJdEiR+O1Y3nJTvSd5msAS2SEwKLVBr86G/4tmQrHpMbyHEU?=
 =?us-ascii?Q?Te4YZXK/vW1k3mXx30+6Bqvk/Z0x0gUnCtW1M8c+v1oC97tVYaYrTE4/51Q4?=
 =?us-ascii?Q?ms50x8ky0UBFayILjv6lPJ2NrK/qyuNgg2Orw0HKHVyIDgdxaeEmKX63VKsr?=
 =?us-ascii?Q?ro5+OVC+4OYB/cd26YlBVT38UYLS8kqXwbl83lp7lGV6Ly3Ne4gVpuOy1vYo?=
 =?us-ascii?Q?aPq44gYYpxbkhvPvoO5+7mNFVZ27slq/U2pkGyWOUYuMbDDUeB/Yxf4yrQHD?=
 =?us-ascii?Q?F1WqdILJgesP+66nwsq1JbG5lCdYknlTsYT25V5fz2Nzb6ACIWIHZTfNuXux?=
 =?us-ascii?Q?n25K1Q47ElovE2y/VWFoeldMTNuEpqFoBq1KxxlN73Hi4B5izVxo7YGMSqkz?=
 =?us-ascii?Q?vz7ED0qyGd8crCN6NRD7rKCGPXMaA2pHqvAQj6UbOzFAvCo8Zkl4sYh103IC?=
 =?us-ascii?Q?X3Sy9uZ5A+5hOi38mLiGAeCU3pFoXWBSjsecpzyiJRYKkx2J3Ov2INz8Lw8O?=
 =?us-ascii?Q?uHv9POgXPPMhoy9GdakVMF9upgLVcMahSMRQjR8xAIivLhg9UE+EKI4s2BIm?=
 =?us-ascii?Q?mn7C80YjyoL66l0hAzUNXu/+SHKDznn60xhi48NN4cpIdbvF+f5ZUUpo9iTl?=
 =?us-ascii?Q?YjUWc4OdIe0YNRD7MF0KOriO5OhyltZUoEEAuMoRB3yGch1WRcgjfW4C8kmT?=
 =?us-ascii?Q?AJcvqYAv/kBj0xszqmT90qMKiBQVezamGOw1QQNOZI9pKLvenVEbHiKS60M7?=
 =?us-ascii?Q?4yJx5zRW+nr+PCfqimYzl1nl0nGEQdJdkkIgo72zUzVhDe1w42kAPIrOxe5T?=
 =?us-ascii?Q?0VRL32HK6t5rGY2czHC9eag9Z/ivrOfvGSblDFZ6UU8RQXq2udVHdvAyZhix?=
 =?us-ascii?Q?rjlx9wwm7zs6+lSK0Sfb8Pgs9FIooVifhOt4n8huVUoF+NNSSrPZu1JV2bc/?=
 =?us-ascii?Q?7sx0Im4yUzHJZiwi4re6gyL+DO89oPXwMW2Fc6fWGh0/uEqdg0g6PoXKFQvy?=
 =?us-ascii?Q?X/afTJjNklTuRH6lDpHu/yee8+oIzN/YsQcMJjlw?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 08987df5-5902-41bf-4939-08ddf6c353f1
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2025 14:54:54.5491
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kTzsQ3u+pHx/8tUVVTR91KqAj5I6arkzX9wxtM+pXhnoycF6HcmrZHRmW61u1MbXB3Mb3Cr0pvRi963SabAyJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4767
X-OriginatorOrg: intel.com

>> --- a/arch/x86/kvm/emulate.c
>> +++ b/arch/x86/kvm/emulate.c
>> @@ -4326,8 +4326,8 @@ static const struct opcode opcode_table[256] = {
>> 	X8(I(DstReg | SrcImm64 | Mov, em_mov)),
>> 	/* 0xC0 - 0xC7 */
>> 	G(ByteOp | Src2ImmByte, group2), G(Src2ImmByte, group2),
>> -	I(ImplicitOps | NearBranch | SrcImmU16 | IsBranch, em_ret_near_imm),
>> -	I(ImplicitOps | NearBranch | IsBranch, em_ret),
>> +	I(ImplicitOps | NearBranch | SrcImmU16 | IsBranch | ShadowStack, em_ret_near_imm),
>> +	I(ImplicitOps | NearBranch | IsBranch | ShadowStack, em_ret),
>
>Tangentially directly related to this bug, I think we should manual annotation
>where possible.  I don't see an easy way to do that for ShadowStack, but for IBT
>we can use IsBranch, NearBranch and the SrcXXX operance to detect IBT-affected
>instructions.  It's obviously more complex, but programmatically detecting
>indirect branches should be less error prone.  I'll do so in the next version.
>
>> 	I(DstReg | SrcMemFAddr | ModRM | No64 | Src2ES, em_lseg),
>> 	I(DstReg | SrcMemFAddr | ModRM | No64 | Src2DS, em_lseg),
>> 	G(ByteOp, group11), G(0, group11),
>> 
>> 
>> And for reference, below are the changes I made to KUT's cet.c
>
>I now have a more comprehensive set of testcases, and it can be upstreamed
>(relies on KVM's default behavior of injecting #UD at CPL==3 on failed emulation).

IIUC, for KVM_FEP-prefixed instructions, the emulation type is set to
EMULTYPE_TRAP_UD_FORCED. Regardless of the CPL and
KVM_CAP_EXIT_ON_EMULATION_FAILURE, KVM will always inject #UD on failed
emulation.

		r = x86_decode_emulated_instruction(vcpu, emulation_type,
						    insn, insn_len);
		if (r != EMULATION_OK)  {
			if ((emulation_type & EMULTYPE_TRAP_UD) ||
			    (emulation_type & EMULTYPE_TRAP_UD_FORCED)) {
				kvm_queue_exception(vcpu, UD_VECTOR);
				return 1;
			}

