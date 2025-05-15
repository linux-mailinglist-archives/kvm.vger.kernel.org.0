Return-Path: <kvm+bounces-46636-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C57ADAB7C11
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 05:07:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DC09E4C3429
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 03:07:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F20242951D8;
	Thu, 15 May 2025 03:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mDphWl+t"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F3528F505;
	Thu, 15 May 2025 03:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747278402; cv=fail; b=g6C0C/fuLKOIKuQBfEDQZFlzmy4B9vWrxKC4TFGMqHbxNwrqa3XTdlwCu/u76y8zoQ6wX5bNfd9ylDySYA3HmvspTIwH63kSTO2iZTSscut1rLcT1nzkkzo3sq7zIioVzMtX61rlcr2UFApM+PNUn7FUW5cX8IBi/lr96ddJAQo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747278402; c=relaxed/simple;
	bh=WjK+qmT+ChuuKr5Vr9GfbjkS16x828e0V927s/4THE8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=tj1npxh6+/S75iyl7anuglBGTXxLoF/0kYlJq0oR8HsBm8HEGWR9HgZD0DTghL7gS9MpALmJXyJBw31e2UqM+7VMzSOUfINSPq9ZYbgx27HXB7QJXGAeJttvt6DXRuj3Xiae2So5F7KoZMVlCDibgD/6EXmeeCnxK15x7ghf6tM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mDphWl+t; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747278400; x=1778814400;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=WjK+qmT+ChuuKr5Vr9GfbjkS16x828e0V927s/4THE8=;
  b=mDphWl+ts7liG0HQc2Eujl4mxGcjReC1TNvxwt/htiIyWnGjyFFZnLyw
   IiIvSi1oLpblPIVcPIicZvKqkj0Hr+J7cS7WtgZWeCRRidI7raKWgBuw4
   gFokf5QsMatX7hn+k91hwyELWuxCV34AvhjAFW7zXPh/D+iKmJHy0mMAY
   sP4mxr6BnuLDDjM8C9JSmQOxygECkc7KLwfhaDl/xcbrlzWJh9b5bI4nK
   1Ku1vsjwcPGFi3Rox920b5b5JiHtT9OB6XXWhDj/PPCmQ6cjry/wPB0mb
   lFEx4GSIZ4JWyiWJS0XOvTJF6uVCuKqeTx2s8tDWd0HTG8u3SESBxCnN8
   g==;
X-CSE-ConnectionGUID: qrU7qFvsTV6uEhjuf9Zr8g==
X-CSE-MsgGUID: GgwK9BOcRneUjJM82lVGoA==
X-IronPort-AV: E=McAfee;i="6700,10204,11433"; a="74600032"
X-IronPort-AV: E=Sophos;i="6.15,290,1739865600"; 
   d="scan'208";a="74600032"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2025 20:04:08 -0700
X-CSE-ConnectionGUID: sD1mLasZRAGkYjDOUW4dYQ==
X-CSE-MsgGUID: l768JMg+QsWbOL59NGkw6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,290,1739865600"; 
   d="scan'208";a="139128982"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2025 20:04:09 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 14 May 2025 20:04:08 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 14 May 2025 20:04:08 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 14 May 2025 20:04:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pqIGG0uOMNKLWAceDBONeGACC77xnKMmmFe+bkZVQuhjUEfT2FV8Pl5tKqF91BF1KXjkFUwgCWj6R1AfTC+KGFivO/i5OlItZMGDsFJ/nt83LjOTCzSUdCWp2wxEQEH50VqV/EvvI9iFK3GrcwCTatZckm0XRjZcjlb/Ur69AmaTMd4AnWwBAHscNLoogHWgRK0doQfC0v2HjCXV6TCHKy4BltSDW89l+P7Q/W7XEx8Z8TmZaOyTdnviW5Ds7n7nY+TknzRCfcy0jxRe801RLoYOLdViR1NuBg80qGIu+momNObEJc+AGUZec9h+Nh8LtkDx6cazfnNWMyUjjqFoHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fo6m0KLQpx9MMy9Vqp12V1w4REbk6SVsQDc3NIQ/Omg=;
 b=JiZ5/tuqSv02bTDTJMDJTAuY47R1hxje9B1jr7CH1r0mH4p2Lc4TANhH8fyKasl7FGox2X7TKb6s/5ekt+V0zcY/BjuaEKcL43wbfNmNBJ0qgGWL+X/DVF80pm5Q9BJ8xYUExnwnfCn7ET2vqfeHSgosMg9QbOq4voH2QH1/h0R0halgzo1ABXC6zrPT5B3qVxbpIre0OeVbNJkCIY3+SVefyogsQiSsSkm5+8tlpD+j2BXPBCoaLgx+6aMzP1b6/M/afJs3CMDFmY/ZtyyuBtbexIeqC9Jwsuqtl7aG4nqjXpYTRKx50hb1DD0laNqHbpVLL9TsHEbiOv1cRaOBmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN0PR11MB5964.namprd11.prod.outlook.com (2603:10b6:208:373::17)
 by SA3PR11MB7413.namprd11.prod.outlook.com (2603:10b6:806:31a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.31; Thu, 15 May
 2025 03:04:05 +0000
Received: from MN0PR11MB5964.namprd11.prod.outlook.com
 ([fe80::7a0e:21e8:dce9:dbee]) by MN0PR11MB5964.namprd11.prod.outlook.com
 ([fe80::7a0e:21e8:dce9:dbee%3]) with mapi id 15.20.8722.021; Thu, 15 May 2025
 03:04:05 +0000
Date: Thu, 15 May 2025 11:01:54 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Vishal Annapurve <vannapurve@google.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@intel.com>, <tabba@google.com>, <ackerleytng@google.com>,
	<quic_eberman@quicinc.com>, <michael.roth@amd.com>, <david@redhat.com>,
	<vbabka@suse.cz>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
	<pgonda@google.com>, <zhiquan1.li@intel.com>, <fan.du@intel.com>,
	<jun.miao@intel.com>, <ira.weiny@intel.com>, <isaku.yamahata@intel.com>,
	<xiaoyao.li@intel.com>, <binbin.wu@linux.intel.com>, <chao.p.peng@intel.com>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Message-ID: <aCVZIuBHx51o7Pbl@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <aBmmirBzOZfmMOJj@yzhao56-desk.sh.intel.com>
 <CAGtprH9fDMiuk3JGSS12M-wFoqRj+sjdtEHJFS_5QfKX7aGkRQ@mail.gmail.com>
 <aBsNsZsWuVl4uo0j@yzhao56-desk.sh.intel.com>
 <CAGtprH-+Bo4hFxL+THiMgF5V4imdVVb0OmRhx2Uc0eom9=3JPA@mail.gmail.com>
 <aBwJHE/zRDvV41fH@yzhao56-desk.sh.intel.com>
 <CAGtprH9hwj7BvSm4DgRkHmdPnmi-1-FMH5Z7xK1VBh=s4W8VYA@mail.gmail.com>
 <aB10gNcmsw0TSrqh@yzhao56-desk.sh.intel.com>
 <CAGtprH8=-70DU2e52OJe=w0HfuW5Zg6wGHV32FWD_hQzYBa=fA@mail.gmail.com>
 <aCFZ1V/T3DyJEVLu@yzhao56-desk.sh.intel.com>
 <CAGtprH8GfY2NjVM4=iVoWOenoexB1vs8=ALYTC-y7suf__+3iA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGtprH8GfY2NjVM4=iVoWOenoexB1vs8=ALYTC-y7suf__+3iA@mail.gmail.com>
X-ClientProxiedBy: SI2PR02CA0044.apcprd02.prod.outlook.com
 (2603:1096:4:196::17) To MN0PR11MB5964.namprd11.prod.outlook.com
 (2603:10b6:208:373::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR11MB5964:EE_|SA3PR11MB7413:EE_
X-MS-Office365-Filtering-Correlation-Id: a2296b37-2e40-419d-8c5d-08dd935d26dc
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?QllBNnJSQWpzWEdkRWFCY2JVUmtYdWpDR2dhb2VETndCaUNZc3pyYlgyNUtJ?=
 =?utf-8?B?THVXWmtXTWFEdi8zcW9uT0Q3OGZvNGFvRXBFSXErZG9SeTFBa0JibElaK2Y0?=
 =?utf-8?B?TkdEZG8vaWpIWTNOTWw0bE1PNS84Z0R1UWdRQWliTUpYMWM1SFNPYzZGSVZW?=
 =?utf-8?B?eE0zcHhyQytaWDI3aDA2cVpDN1M4QXZ1Vlpnd2J2dUkzUWtoQ29GRlRNWisz?=
 =?utf-8?B?SmpmQjJSWkFQRjZBbFU1eHJlSGtRYmM0Y0JGR0JPSERmcE5TTDJFSFFOQVVY?=
 =?utf-8?B?QlBlcHZhK1RncldMZ28yamZjb1gwdm5GcGg2Z3dPRmVPd3VDeFY4dm1jVjEr?=
 =?utf-8?B?dXQ2SDExZmNIVTJ5UURNTWJDWUh4Z3FKQjVOVWlhTmNjaTd1RUF2ZnhFRmMz?=
 =?utf-8?B?T256TThlaVpNTXJUYTluZkpWVjlzM3BtVjkzTEpUMUhRb09xTXc5b3F0NVVQ?=
 =?utf-8?B?djkxc291YlZFUGlLQUVEdU5wc2lKdmcyK09MeWhLelpSd2ExT2JRUFdGU1FB?=
 =?utf-8?B?TGlJbGhjSEQ4Tk9BYVo5dkFKRTlMN3FadXYxM0x2VDAyYkpSZVl1cTBQcXZl?=
 =?utf-8?B?QWpiUitmc2kycG9NLzIxNFZ4NHUvUUdGUlVmS0lGTjNDSXVkWWFyd3psUkFx?=
 =?utf-8?B?WmhCMFZWUnd5dEVBbVNLbFJRQWVlNWdRYUczTHRQcndnYUJBbThmSkU4R2FD?=
 =?utf-8?B?ckpQWGRnVVF2eE5LSVlpV3Y2Q1FwRFBNY0xJNVVHbmdDNTV6d1QyaEc3OTBI?=
 =?utf-8?B?eTNvZG5zUHJOUjFhaVZscUt0eWNVVTFieXMrV2RodGQxNXVOSWltcXpVZldX?=
 =?utf-8?B?S0N6RzlLaHNIeG03dFJOdjFzYkNyVHBCZ1k0dFNrRHNhQ2EwRDU5bXBncWRI?=
 =?utf-8?B?T3NLT1hhd2JIV2tIZVo4WTFHNGd2WXhqaTFSMEczbzRvRmJNT3FWOVhPeklU?=
 =?utf-8?B?YVN1d1drU1g0QWNSTkgyc2YvdWJpZFlBSXg0azkzb2ZiNTBWZGhVQTNESUdw?=
 =?utf-8?B?NlRYWGl3Z2ZaRkhFYUl0MkVTRXIvSGp0QngzVEsxb3l1N3NvcHBpSVNDdnpE?=
 =?utf-8?B?VDFPTmhpNXdJd29YNTl5Sm4ydXR0Qk5BaGY2aWkwdlBPWGJTd21pQVl1MFdM?=
 =?utf-8?B?Szc2Rm9xQlJYNmlrSXFYbXZLZVJUWmR3RXhGR3lGcExveGZGWndpZnR0Y3dj?=
 =?utf-8?B?N3lvZlVEUURhQlpPU0phQXpGSFZROTMveCtSOENEYVpKa2lEZWhxRnZWU0Fy?=
 =?utf-8?B?aVlUYTRHQ0s1TUdLUXJZMkNNU1dEVEFqRzBiTEhtVjdqK0Z1Yk5VSmVMVjli?=
 =?utf-8?B?MEVIK3lkaTVYZThYS21KSm5rVUU1V0N4U0RqdnQwaWJrN1BqN095OUc2L1dS?=
 =?utf-8?B?V21uazNaUVFkaU40bjFoeHVkeUtGSVNUNHpMNlptSTd2VVBKNVllWk1YOFNT?=
 =?utf-8?B?QUVjU1lxTklFRnZOYmFHNkJIMHlLdzVsL3lFbXJGeVhiMUJ2NXcxbEZXOVpO?=
 =?utf-8?B?eWt4RzkxdFIrQ3ozd1hhWi8yUjJMMStmNkZEclRSM2RXU3YzTGgvZ1NTdGcx?=
 =?utf-8?B?RklIOXUrMzhQSTMwVGdXTlNIam9xQTFvNEZqZ0FtZjhTT2VGeGNBdVpsOHhi?=
 =?utf-8?B?SDBKUHUvNk5sZDFSVWx5N2ZOK2VDNkQwYTh3Y1hMejJPa3d5cjdXT1pyTDNR?=
 =?utf-8?B?UEpmOE9tbk42aTVwQWRrWXM1YnZSMUtzME1CTDY2TGR1ZGd6Tmw2eDhCK2ZG?=
 =?utf-8?B?NlRKQlIrZ3VmZ2o2T3JBeUMrbUJUcnJaWUJGOWI0RVJ4ZERyWlhGQXBOSjhD?=
 =?utf-8?B?Wm5qbFdnbGhUbjVGU1ZuVFZqMS9iOGYzd0hwVzVoWUs2NVBvaXBCTDZlWVZo?=
 =?utf-8?B?azUvekpnRW5rK3NseThVOFQrUzg5T0pWZHpRN1ZpUlZUbkxtb3RMdkpyL3pQ?=
 =?utf-8?Q?Q77DxHTnAxg=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5964.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Nzh0YVd5VUdNQWxqTHlNUnFhYkx0bnJjNnRKL0xGbnphcC94R0s3Y3pQSEVl?=
 =?utf-8?B?R0dJc25oUnVsdDJ5QnR6N2pjSkZPbDJDK2QxVlFwZ2p1TFBZQ0NJWERHcG5B?=
 =?utf-8?B?Y2VGVExXZHVuVlJLVjNzMWt5dnNTUGx1RUFCbGo1NTE2K3RrZUExVWk3N2N0?=
 =?utf-8?B?VnIzU0JyRmtBRkpBQTNtYWg1a0JDMzhJa01ESnNpcm1tRU5OVjJqbnRFMzMz?=
 =?utf-8?B?S3B2KzA1QmEyRFNaTDB4aW5HNldvS2tXU2ZSbDFVbUZBcG5IMDIwT2JjVXVB?=
 =?utf-8?B?RCsrcHA5RG5INjd5VWtSNHdwQ0t5TUVTWk95UjlucHQ4VUNjczBZdWMzZW9E?=
 =?utf-8?B?QnpyVzNqSDhNL3RVNEUzeCtyU1JhSkRVWUhPdFlXM0tZalJpclRiR0R3alhh?=
 =?utf-8?B?aTRJWUxNRVRtR0tyWDdGT0owc2xGYU5XNEh6U3Axd25KaXRwbnpRaWJJWmIx?=
 =?utf-8?B?OG4yaTFzL1JzeFY4ajBlc2dWL0luZzRYbXZ4b1htWGlmVzN3MHBicldRWDVT?=
 =?utf-8?B?VUNxSkFtczJSeGtHZEJJRnR4VGNia1hVeUNwN0taakRjRDhJajcrWUdkWVZz?=
 =?utf-8?B?YjI1Q3d1NDU2V0NpbWZSZmxuQlExc2xoZkdhRnZjSGVNT0hNNCt6WmcramlT?=
 =?utf-8?B?TGJRU3ZFQkpLZ2hvZ2tibitnY3pFbUhRcHl5Z2l5TG5NU1NVTG9lOFhpbE93?=
 =?utf-8?B?VVk3T1hJQ1FvcVFsVHRUbFE4L3BlQUpjS01Da1FWWG5yTktBU0VLRXFKdWQz?=
 =?utf-8?B?MlNCVTF1MUFhMkpQV0E3MFUvcld5anBpaHMzTndscnVrRDB5a1dXa0ZEaXo3?=
 =?utf-8?B?YXdHbjF4VSs4S2FDOHRoNEFYejJuVUU2VUZNZU51RXRnZWFCM0RCZElOemFx?=
 =?utf-8?B?Tm02REZsenBGak51ZE4yLzl3THBUQXQzTm1GcndJVHMrdUc1aTFsQUZCODNG?=
 =?utf-8?B?T3hsQ0pLMGdGY1lXdHpTamZ5bVJhNTVsKzZhZ3FMeGNiQWRmV3VxVGdMZ3VC?=
 =?utf-8?B?Y3ZtZVdnWnhXVEd0cVc3VnorV05wRnFQamZLcDBuSm02SXVtWUN1cmRzZElE?=
 =?utf-8?B?S0lBVnBzWFpJOUZRNHI2R2Z4UncrZjh4RHZaWklaR2cyUDdINFRtNnY3SDhP?=
 =?utf-8?B?QTdKMzZJeUR4cVhjR2hvZkRwTW9KWXNvYk5VWEF1a08zK0JnazBXWVV1dFVJ?=
 =?utf-8?B?WUNSajNyZm8xT255bEwvUythNTM4a0tONnpQQ3VtRTBTMmNnV3hobDZyQloy?=
 =?utf-8?B?VUlzK2F2S2w3eXdUbEVqSXcwMlRKUHQ3NmRtTVVQUDMyU2hQQVRlZHdIYlFC?=
 =?utf-8?B?cDNjNDAxZTJsQXFQT3doNkpkTnBSTFNhcDBLMWE2SVRoZVI0YzNFYnkrUkl0?=
 =?utf-8?B?U3NVaFBseWx1QWExTVoxS1dhdHc4T05zVHlTTWNxekVmV011V0pEbjUzcXpU?=
 =?utf-8?B?N1RFMUhsaHNtNjd1d2c5YUhvdjBtYzhXT0Zsd2VCWnRRb2dmaHRGNkZFcDJ3?=
 =?utf-8?B?TGhTMHpVdnJWUXR3TDZjNTI1Ui9CNzRSZTJGZEJVaGN2N3M4aXJjbXZTMGhk?=
 =?utf-8?B?NTZxUEtJS3M0Um03M3dYd0lHRFlyQ3N5bjNqTm1qOE41UTYxbHJqSk9KVjdD?=
 =?utf-8?B?ZTJkQTI0MVJKT2hLV2VGNENueW1UcUhCQzZuN2ttTTVoZjM4emdUYnh5Q1c0?=
 =?utf-8?B?aUxmUFd2dTZtbDBzV29oTXdzS1dIaDdFN1k1UGZ5OWJEWDhhZnhOM1B5NlRO?=
 =?utf-8?B?S3d2YnRGbTNWOU5LMFlwMEcvSFRWUEczUTBsWUI4SWd3T0ZZazRIUkJ4UUho?=
 =?utf-8?B?eTZhYS9ZamxoK09Ob0crQUtJVzd0V2p4YkJBOUpjKzhJWkhkT2YwQW9MdjMw?=
 =?utf-8?B?VURBUDNyY1BFSm9vY3YrQmZVNHFNK3ZFSE44R0VMaG16NzNoMTBabVVESzVL?=
 =?utf-8?B?cEpXUWdGNHJoc3ZxL3RPMzU1bmN1ZTUxaFJTRHVPUllEZ3B2aHA2WFkvTnpj?=
 =?utf-8?B?MkpiT0pqeS85UjdBZ28vUXk3Y2NObUpHUURtL00xcEFYVTcrWHR4eXZZeDMw?=
 =?utf-8?B?cTBweFJETzBka2hBU1FnMTNwekFuUkZaOG5LdGFkOUpMemJUSWpHMXpDT0Y1?=
 =?utf-8?Q?jPu4vkyj9PZaRWWrqTnwT/EZY?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a2296b37-2e40-419d-8c5d-08dd935d26dc
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5964.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2025 03:04:05.1328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bbrL6+ZFVb7bIRPJhvnPm2Hx8peIlE4z+SojWQrtuv+3wbIm9rqBdF45Lpea5hMSdXOmbvNY8/zzNmJhrNc4Ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7413
X-OriginatorOrg: intel.com

On Mon, May 12, 2025 at 09:53:43AM -0700, Vishal Annapurve wrote:
> On Sun, May 11, 2025 at 7:18 PM Yan Zhao <yan.y.zhao@intel.com> wrote:
> > ...
> > >
> > > I might be wrongly throwing out some terminologies here then.
> > > VM_PFNMAP flag can be set for memory backed by folios/page structs.
> > > udmabuf seems to be working with pinned "folios" in the backend.
> > >
> > > The goal is to get to a stage where guest_memfd is backed by pfn
> > > ranges unmanaged by kernel that guest_memfd owns and distributes to
> > > userspace, KVM, IOMMU subject to shareability attributes. if the
> > OK. So from point of the reset part of kernel, those pfns are not regarded as
> > memory.
> >
> > > shareability changes, the users will get notified and will have to
> > > invalidate their mappings. guest_memfd will allow mmaping such ranges
> > > with VM_PFNMAP flag set by default in the VMAs to indicate the need of
> > > special handling/lack of page structs.
> > My concern is a failable invalidation notifer may not be ideal.
> > Instead of relying on ref counts (or other mechanisms) to determine whether to
> > start shareabilitiy changes, with a failable invalidation notifier, some users
> > may fail the invalidation and the shareability change, even after other users
> > have successfully unmapped a range.
> 
> Even if one user fails to invalidate its mappings, I don't see a
> reason to go ahead with shareability change. Shareability should not
> change unless all existing users let go of their soon-to-be-invalid
> view of memory.
My thinking is that:

1. guest_memfd starts shared-to-private conversion
2. guest_memfd sends invalidation notifications
   2.1 invalidate notification --> A --> Unmap and return success
   2.2 invalidate notification --> B --> Unmap and return success
   2.3 invalidate notification --> C --> return failure
3. guest_memfd finds 2.3 fails, fails shared-to-private conversion and keeps
   shareability as shared

Though the GFN remains shared after 3, it's unmapped in user A and B in 2.1 and
2.2. Even if additional notifications could be sent to A and B to ask for
mapping the GFN back, the map operation might fail. Consequently, A and B might
not be able to restore the mapped status of the GFN. For IOMMU mappings, this
could result in DMAR failure following a failed attempt to do shared-to-private
conversion.

I noticed Ackerley has posted the series. Will check there later.

> >
> > Auditing whether multiple users of shared memory correctly perform unmapping is
> > harder than auditing reference counts.
> >
> > > private memory backed by page structs and use a special "filemap" to
> > > map file offsets to these private memory ranges. This step will also
> > > need similar contract with users -
> > >    1) memory is pinned by guest_memfd
> > >    2) users will get invalidation notifiers on shareability changes
> > >
> > > I am sure there is a lot of work here and many quirks to be addressed,
> > > let's discuss this more with better context around. A few related RFC
> > > series are planned to be posted in the near future.
> > Ok. Thanks for your time and discussions :)
> > ...

