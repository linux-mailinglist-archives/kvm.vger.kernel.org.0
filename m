Return-Path: <kvm+bounces-56817-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 56FBBB43791
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 11:50:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D50453B078E
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 09:50:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02E532F99B8;
	Thu,  4 Sep 2025 09:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OxDWH4oK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1D82F83D8;
	Thu,  4 Sep 2025 09:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756979394; cv=fail; b=PQQx/MJdjE8nW3NDSvuq2MyEy93+6o2yorQ6qAp3ECdawffbyCSIN0gSNVo5HQq5LyturFU2KulKfl3wYuTpFssQWCy8Ela5xS5fcgo2+NOHHBvz02vujJZ7iGy63qHWBdnzS+0CvHmLUSR+3ZNRxRZa4xyEK2gcO5QWNSZO46w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756979394; c=relaxed/simple;
	bh=YZcbtkWznMQln27ytwi0jOAZnd91plI25z7iQIQOoko=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=e4n18Q2rL6WyrBZr0pTFsVVAAbdQiMgudlBd6MPl2qA0oKc7uNfyprdQtuq/YrxjREiyBNI1jCdmP8AZcEJppBZVheBjZrIk42Pbewm0MP5lRYYC+KGgizbRQHul95vDrSwwd5r/KMuerD5aQKew5LZE7N6i7rKhwBXQFVs+eR8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OxDWH4oK; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756979392; x=1788515392;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=YZcbtkWznMQln27ytwi0jOAZnd91plI25z7iQIQOoko=;
  b=OxDWH4oKTN4ecuqtmtqLBAZOQ2T/oU0i1XJy/TfT9SUa9zobVldZLiLB
   jIuyQ7AzKC4B8YiL0zOLzQy5BZwsFM4j3s1wcR2fiykAjeC0tpvABzPMS
   aYsT+b+zdlVTUvGpcchd5/35QL9QxmpkTSQNfhxw7C2K8FyllDOjsQHTU
   b/0DWYnyKxA5yjNK/YkdCpLFPx7bPYU9kkOxDMVdnJ8nfCzMcnvMqMTb3
   e7ttW4KD5T61YPtqTTLK5ueX4p670OySjIo5N+UCwu1cWI3vpuuIj0PAf
   oX1QmQHvunLoMSxrs0/OAeieUsuUd/9xfObL8YJHeCm+GnB0Pvw1iacu7
   A==;
X-CSE-ConnectionGUID: NWg9k8ptQtirS1NgOLSBLA==
X-CSE-MsgGUID: u2pbg+1cSVO8UgBLT3r3YQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11542"; a="69927262"
X-IronPort-AV: E=Sophos;i="6.18,238,1751266800"; 
   d="scan'208";a="69927262"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2025 02:49:51 -0700
X-CSE-ConnectionGUID: 6aSGJrstSkSTL32RrRnA2g==
X-CSE-MsgGUID: mNMTv7SHRa6DfkFxJEbfwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,238,1751266800"; 
   d="scan'208";a="209031762"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2025 02:49:51 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 4 Sep 2025 02:49:50 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 4 Sep 2025 02:49:50 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.67)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 4 Sep 2025 02:49:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BZoMEyb0A6zqjlX8Fdjto+lgcZkTMaB/5hiVv5Rpt/fSN+Wwg7ZUEbmd/Ic8hRplxuSHHbuguD6YgRj1MeFy2MRjjL/QOC912b9yPNFbxVqqMtMRy5fdcCkFUiH94bsS1r4tK/h0GEhsF9uRQT+B2Inb0zYAONlApvK5FofCyPaOs/BDA9fyFNtEa6kSdRvIMyBTXwcxlmJfFtyMiejz9aLnMpEsa3PNJmVMfHPGkVeR1DpTTi47leB1gc5/khPCMERIqg5RqMAxXiaSNeusA250/94cB1RxTOexJE9jPetipIPgNCjCGOWDeisziS/CzU8KoqwdqeIaN4Yzk6UdFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UnFBfnDPkE+miibxHdR6NN/euXzlV7KB6Cq0LgjTwPc=;
 b=LfQPwltyQ6ZNU/UUI5+cRgonOnDJPWrWJiHGQU+syVMvFA2OkErbWZJGLRvhHelbW5sHSSn039MlHT//7X98niMc4Z8iT9Cj5ph4Mtba8YAsVDCdFCxtrrvzwcWEtF+UloFMaW7DVVdJ+Pcfo0e/Druwik7YulPQynvre/7JA+rCV2xvg2iAriLNg57OoEQfJPm6jwRFaAow7lzjYqdI68HgZbWJX/3qST85ElH2AKG1HM4Kc1dh2f8Xrr9uL3aweXmd1xnNhsR8OQb3LeY0G4GzXySi7+t3oADCTzZ6rabDY8yQPeCNk0/A8dIKzZL5U8Wn8oWXn6ksWUWW3XLI0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SN7PR11MB7419.namprd11.prod.outlook.com (2603:10b6:806:34d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.16; Thu, 4 Sep
 2025 09:49:39 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%7]) with mapi id 15.20.9073.026; Thu, 4 Sep 2025
 09:49:39 +0000
Date: Thu, 4 Sep 2025 17:48:42 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@intel.com>, <kas@kernel.org>,
	<tabba@google.com>, <ackerleytng@google.com>, <quic_eberman@quicinc.com>,
	<michael.roth@amd.com>, <david@redhat.com>, <vannapurve@google.com>,
	<vbabka@suse.cz>, <thomas.lendacky@amd.com>, <pgonda@google.com>,
	<fan.du@intel.com>, <jun.miao@intel.com>, <ira.weiny@intel.com>,
	<isaku.yamahata@intel.com>, <xiaoyao.li@intel.com>, <chao.p.peng@intel.com>
Subject: Re: [RFC PATCH v2 17/23] KVM: guest_memfd: Split for punch hole and
 private-to-shared conversion
Message-ID: <aLlgesTc3ZIvgPg6@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
 <20250807094503.4691-1-yan.y.zhao@intel.com>
 <6b61cee4-0405-4967-afee-af934df34c5f@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <6b61cee4-0405-4967-afee-af934df34c5f@linux.intel.com>
X-ClientProxiedBy: SGXP274CA0003.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::15)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SN7PR11MB7419:EE_
X-MS-Office365-Filtering-Correlation-Id: af6c553f-c95a-4a6c-04d9-08ddeb985d86
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?S5NaPY7HVAEqyv+d5PSlxJnXNTwjS0W3qaWojzFcQOfbXC+Xd4Bd0vwmw9kz?=
 =?us-ascii?Q?TeBxccjKXojMlQ3Ge0KdYDEdRTlmgctf3WXqhXUsp4TcbB9tLnXpKD9+ivTD?=
 =?us-ascii?Q?ruYKhfL2bSjJ6pwOAyep25iD9LTI6LSBNN2AXfn9loLNdYPZEzAciLAZjQdu?=
 =?us-ascii?Q?UuvA4bQOND3PVRsLDfc5dOAXddYsvTPvbL8nV6q/U/RZMP+ByNZUokfkKL0k?=
 =?us-ascii?Q?4QFBcyjX/JrRusRMrkYPDkf3Cop5Dn9ijoN5XlonxZtibQSmgrGUEQBIwI6Z?=
 =?us-ascii?Q?CcVpZ4WKgfCVHPxM2FiH5Y1NzbQtdnPZ5e/IuFjLpK8mMOQ5rJnDsKsNC4hM?=
 =?us-ascii?Q?jCWDu4bGGGAewnZ708gjF1Uum3obB5oUvlnrCIz+SAjpmvgTrrwZhzDBUqxF?=
 =?us-ascii?Q?8Gv54wq1umPoepQ+x1V1S0XpjsQFUv1aHhB0V1VuPYIdkFzWgtbQQCAxJgDz?=
 =?us-ascii?Q?LQTpniCFJFDS9vjShGz8d+jpvRqGRZSUcDKVN6NuXwOIU/+BPvUGv/nvUgpT?=
 =?us-ascii?Q?tcgtyLbtguS6sqNpX7j5JnGY1hc4Qy1WhqdCnh1vu0eU52AGqYKZu53k9NWG?=
 =?us-ascii?Q?YT4Xpd0zxgTDAowI9cLvI3+o9pzJYXAEnxXjS8cEMmwoJtvZ64WiwAiiZeeT?=
 =?us-ascii?Q?p/lzJ9qDtH+9y9fYEOjHsGmpA44iWqPl2BNQv4Tuzf8XljmKZbtmNDTqorSY?=
 =?us-ascii?Q?2EKce4nouEAwXCf3ELalfTki9pkooyWJb9UzmEeX5m5RnMaRbZmxPQlwAuIU?=
 =?us-ascii?Q?ArSL5nHgA/uaWke6tLWJSGi0SlkTrbw/4UwkagUjOmS+MqowD3sD4YGFU+Qo?=
 =?us-ascii?Q?QuyldWLO8RbhrrsJ+v1aZZagXYtrEw0JZKwwAAV1LCcT3eUc1r2PDeHKoDHQ?=
 =?us-ascii?Q?LFAd2adHpfqHxxxoTcGlSoiYpzjC5wLR+W88ch/BPMPqDYu9QQz+SFWaj1By?=
 =?us-ascii?Q?1UrI1Mww5VupoYd2w1az2gb0G2sqiZ7XPiM8JmfwQKwfg1mknB+efUfYhvC2?=
 =?us-ascii?Q?NYBxdOtEUZaRuZvM/SBwDt5XOAaPtblxIc47ZnyJ3fN/Zhh4RLuqVFbR3ax5?=
 =?us-ascii?Q?S9arH4fVmQ4O+RQPpyS3LDR66WhxbUYMNlrqp2DZtnMGta2izHTYsCYlvPlu?=
 =?us-ascii?Q?Ggj/Utq4uw3b9H1Va8BcX920qBW92oWtsqf+wezrP9LsOjcB/fHu+2Ww9x7w?=
 =?us-ascii?Q?cRgpnnz5ZX93EnaU+N2uPk9miUWNG3bn4q73tDrU1jPslwkdg63UbkQ4fBha?=
 =?us-ascii?Q?s5dgWZbFyfqFHjFDatTIgTLXTpccRbjJEA6+LPBLwqY8lhGn71esP7ke+xli?=
 =?us-ascii?Q?4jsOr5Hn31vQgjAnDIceJ1izHPqA4jeVWHcrkgkrxmvjWvr1sWKzAtd/Oib3?=
 =?us-ascii?Q?RSnKddGdCITMhqE/NbpXQ9HSWYOcnFEgJIAhNQihGJx6NYnVTm9hVAlZ6f9H?=
 =?us-ascii?Q?V7FUMHoAgZs=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PrkY8axXWUNubN3Nm7uy6SDYGDlnnRfnuNHwn+MjmZMZxU2GHeJQQSwqXSr0?=
 =?us-ascii?Q?DH6npYiEVv2lMnFc6o9brF81dYFAu/qzrymZhF1OccjNRMzEMycAn20HfvHj?=
 =?us-ascii?Q?SneMVdgjvX2M4swyvjnxp8U8iQK2k91lM/vlisuXWSgeHW8CVFUwRadM+XuZ?=
 =?us-ascii?Q?Rv9K7cpBqqvuMmGQs7DTmfm4ugATuDqCqpXqQ6XZ8qGU+bbA+/4yBH1YSpkt?=
 =?us-ascii?Q?GGzLKc3HFS2lGy04r8wMFRSJrLlEQgXs76FzJki9UNtwFnSX7o4mOstBOxiK?=
 =?us-ascii?Q?Li2EwRsKZrS63RuOKXNj9yxPCRIvM72OJDXOQCqrytAQ4pY4PIPGMHca/XlX?=
 =?us-ascii?Q?aZeyUuUV/LLw+7DcvASSfi+NGDLwO2OrfcsQwB8X4uK/LHVSZMxFnSQw/mjN?=
 =?us-ascii?Q?ftIDhDen+TWltyKQgCX5icCoV/u4fd4gs6PPIThk8l9M+6ws0fit5J9m8AoQ?=
 =?us-ascii?Q?uGzjGl0K0oSO1Bhifbd5lz4Z7WfmD3//hD/fkhMVuoZ7nS1RqI6ZUzSg9mpd?=
 =?us-ascii?Q?5jzOQ9s3YrgBy5N4KSpRQv/zLP2cHH/Fd09yDGZgJDR0tfdlaAJrC2HW/9xN?=
 =?us-ascii?Q?oKQkM/Zi09VefE9/s05W1oyw60cT3BLw/RrqmHicY0mEnYv7XX9gZloU7zMV?=
 =?us-ascii?Q?kfag7KFMjqeDOPI7PbW1j+Mj+zgqTnHa0dH5zoBJh3alU2WrgD56qXOrXBYC?=
 =?us-ascii?Q?Yaq6vMuRGsTfPMXBfIrdMBd/jNY2NW4DirVG0pXouh+1i9raE2Op7DTFCcsH?=
 =?us-ascii?Q?UJXmyit1TD6PP6V7r8BYuBXe3p5KN4BQGmMy6Po5lgCz4zJpT3WfwkSuSOib?=
 =?us-ascii?Q?1mAGd8f0iBayE56lP/zviGXdkRt3xt5MezdmHw7uMUydqMWSd/w9i951t8TV?=
 =?us-ascii?Q?8WwrD7w4p7qQo7oSpIIYrhTM3MQBA/lc5xXU2bzA2H+MOCz2gS0QLHWsiZ3H?=
 =?us-ascii?Q?4jmok6sBybWzhXnePcihjDXAs4hpssvYb1aklwpus5Q0leIlVJvkUicT0uwa?=
 =?us-ascii?Q?U9f4xt0HHDmO7kMAzx2aHFYi/ldV3REfp3UdzTKfmCJL4stVrC34valHlz7w?=
 =?us-ascii?Q?3HTaksbfgHvHLZo5t2DHboNVxgq6WQdNuJmi5Yin8t3L8wNC1uH3jRhGowsc?=
 =?us-ascii?Q?HKeR7Hx2Q9xlmuARYu9imOAH/oz5xQdBxs3kFyguz4x2UvtGMu2YW2/cEa8/?=
 =?us-ascii?Q?gXnjxWlnFvATKzLOA2VzDcVb0zo+HOjRbILlvJZVYxKTEHVI/+JQTGKiW8XM?=
 =?us-ascii?Q?CF8c5Amfye1yIGqeh9qKD2IUt9Y3xbGhQsqFc+UFFwrpgoOtcOLx4Ezop+sx?=
 =?us-ascii?Q?jsF8VeDVjbTm36DtA9Pso/CTpchSSnaJoaZ/smohj9+jBX4AX/fg88ndwIrO?=
 =?us-ascii?Q?wxrboxPoyVPgMELSYigHYgd9a3HLLrpqTcU/omFVNw7Zpaa4+nZolUhdMMkh?=
 =?us-ascii?Q?H3uIQ22oQt3Izz33VVnPTfWCPol5WxqWXKL9XkFFnG3Xe9ZKKl78PPVyYKev?=
 =?us-ascii?Q?X1JcIq0ptFlCZ6xOqKqrVD6Wvq9M09l+D3kjFSDK4mUIqAHrtvft9vwEWn7r?=
 =?us-ascii?Q?E8kKQObdJqOEh8Q1kOQKw4MFLxISOgwA+DVsV41X?=
X-MS-Exchange-CrossTenant-Network-Message-Id: af6c553f-c95a-4a6c-04d9-08ddeb985d86
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 09:49:39.6021
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /4nlDsR/aTI4/BRiWaqpj5FEfRfy16ZdWMPPkCeNC0YPpanW4AXjizSRw0Rlz7QQzD8LoNBItoorD6WY4U8zYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7419
X-OriginatorOrg: intel.com

On Thu, Sep 04, 2025 at 03:58:54PM +0800, Binbin Wu wrote:
> 
> 
> On 8/7/2025 5:45 PM, Yan Zhao wrote:
> [...]
> > @@ -514,6 +554,8 @@ static int kvm_gmem_convert_should_proceed(struct inode *inode,
> >   					   struct conversion_work *work,
> >   					   bool to_shared, pgoff_t *error_index)
> >   {
> > +	int ret = 0;
> > +
> >   	if (to_shared) {
> >   		struct list_head *gmem_list;
> >   		struct kvm_gmem *gmem;
> > @@ -522,19 +564,24 @@ static int kvm_gmem_convert_should_proceed(struct inode *inode,
> >   		work_end = work->start + work->nr_pages;
> >   		gmem_list = &inode->i_mapping->i_private_list;
> > +		list_for_each_entry(gmem, gmem_list, entry) {
> > +			ret = kvm_gmem_split_private(gmem, work->start, work_end);
> > +			if (ret)
> > +				return ret;
> > +		}
> >   		list_for_each_entry(gmem, gmem_list, entry)
> > -			kvm_gmem_unmap_private(gmem, work->start, work_end);
> > +			kvm_gmem_zap(gmem, work->start, work_end, KVM_FILTER_PRIVATE);
> >   	} else {
> >   		unmap_mapping_pages(inode->i_mapping, work->start,
> >   				    work->nr_pages, false);
> >   		if (!kvm_gmem_has_safe_refcount(inode->i_mapping, work->start,
> >   						work->nr_pages, error_index)) {
> > -			return -EAGAIN;
> > +			ret = -EAGAIN;
> >   		}
> 
> Not from this patch.
> When if statement breaks into two lines, are curly braces needed?
Hmm, either one (with or without curly braces) can pass the check of
"scripts/checkpatch.pl --strict".

> 
> >   	}
> > -	return 0;
> > +	return ret;
> >   }
> [...]
> > @@ -1906,8 +1926,14 @@ static int kvm_gmem_error_folio(struct address_space *mapping, struct folio *fol
> >   	start = folio->index;
> >   	end = start + folio_nr_pages(folio);
> > -	list_for_each_entry(gmem, gmem_list, entry)
> > -		kvm_gmem_invalidate_begin_and_zap(gmem, start, end);
> > +	/* The size of the SEPT will not exceed the size of the folio */
> To me, the comment alone without the context doesn't give a direct expression that
> split is not needed. If it's not too wordy, could you make it more informative?
What about:
The zap is limited to the range covered by a single folio.
As a S-EPT leaf entry can't cover a range larger than its backend folio size,
the zap can't cross two S-EPT leaf entries. So, no split is required.

> 
> > +	list_for_each_entry(gmem, gmem_list, entry) {
> > +		enum kvm_gfn_range_filter filter;
> > +
> > +		kvm_gmem_invalidate_begin(gmem, start, end);
> > +		filter = KVM_FILTER_PRIVATE | KVM_FILTER_SHARED;
> > +		kvm_gmem_zap(gmem, start, end, filter);
> > +	}
> >   	/*
> >   	 * Do not truncate the range, what action is taken in response to the
> 

