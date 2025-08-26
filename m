Return-Path: <kvm+bounces-55717-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A051B350F6
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 03:23:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0EFAB1B24DB8
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 01:24:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAEA3264A7F;
	Tue, 26 Aug 2025 01:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Pedp0n/A"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EFB722A1D4;
	Tue, 26 Aug 2025 01:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756171424; cv=fail; b=VgFIBMblSb9veaQ1EJwrxjmQ0udIf0H0awxnvIksW70KDP6jYxjdEb5YXx39jy62Tjq7nAz9vRuKHcXu2H2/N93LzDVrYjjyU2xiBHtPB9KwwGA/2JjgFXli3HOkOcNX8xMWIuar6eyJhK3IPO5DltXu5IqW556s6uncKRHFy5k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756171424; c=relaxed/simple;
	bh=wanqNLlpZFqio3xiBvuoChXlo3g/WCj+Ouh/47m+eec=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QMqYrh6m18QfWmvbwViX87tUIHbTiLS1f3BH15IDrBPK/TL3yAKpJFll3HEG0T5d3o0mjAB74iRirxpsj/++2LaR+GKt1qYVjAYyrWGfrH1Er7wbsdYEFULoEZtb3/8xkFi6tUfLJ8YP1xDJLZfoYgAJnhcOVB5PiHb/AZ1qA4w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Pedp0n/A; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756171422; x=1787707422;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=wanqNLlpZFqio3xiBvuoChXlo3g/WCj+Ouh/47m+eec=;
  b=Pedp0n/AFbWZ9rGeeN5RNc6+smmy0z7AW4FjAz3v0o/Gmlng1t7H9SWv
   kePsD2yDW/7G6JrgG7nzQzZ6e/MrFmhNgwLFoJW12UVKyh8KTyWs9qnRZ
   1V3IZLJs0efzvMqCfhSfYJRiB4bXyZMM6GFlHJIUUdyxNow+u1nXrT8/S
   r2A4QXRkIj/G1uHrQWUujpFvrpPhYZeJsMcW/CrlFD2KCdWvpl8tzUVlg
   67nBnx2EvTrR3Z5G8BXir1enp6pN2KgEfj8M3Z/oASEr/Uu1h/IJZIlGC
   snktxvxkuWksKfTF3Cl+HoMI6LuqzotsLiRn0C2Qq0D9Ils4GHCh0uksy
   A==;
X-CSE-ConnectionGUID: xogOyDPCTf+qieZNfvnZ7Q==
X-CSE-MsgGUID: gWhP/aeRQLqqzFBR85PjKA==
X-IronPort-AV: E=McAfee;i="6800,10657,11533"; a="75847186"
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="75847186"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 18:23:28 -0700
X-CSE-ConnectionGUID: QuCBUySOR6GKC1dRi0LRnQ==
X-CSE-MsgGUID: heN6fPdsRtCZiuJmp4RE1Q==
X-ExtLoop1: 1
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 18:23:27 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 25 Aug 2025 18:23:27 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Mon, 25 Aug 2025 18:23:27 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.53)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 25 Aug 2025 18:23:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wZPHYeb7NZE3KggR2GymD8V3vd0qK/9fCLR9NNGehjKVWsBLLwyjy7LqDNDa3FCPost+tAABdl7XIARPBporwDwhDQOtCToDYc23fwsec6Pj825iVb6iLJI7nBbaq2dQBBADZrrHB1ZpZ5RfucBrcD45HJYGr95FbrfPE3bu9T9YHpLVlyAZEnDf8m8TqgSGSy1v5E7/YhJ3AKTV2/neMEnH5enS8QClFRcNZwztTNCxWbiqwqeOoUnsrCGjQ1CLxHQTLm9dYKk8oN5TN61WKoD5hdg65AVWS/zp3Q2uEmJK5vhjVcfYIre3rSJi7tifH22aApTG8fEgm1ijaM2KYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5396LohSawNudMq6kD2fQJ4/QDI2CKW0PcyHJVbJoZU=;
 b=bBwCrdl2veNWZtpDga6I9a4PATgbnIAZGkCpWBMaZftKQPwg62Ct5/4nYqkvypcv115/RCInysKDW+juotVR74ZtHmV4aoV8AR6dXMKlkp3H1QrWwgxRKnwL9sr5+5pb3H77qv+s1agzv11UFZba/uN0FyyyZCLEWftzadMRiwOU49Hl3Da+l7sjL91oMGKJ278GQAAsZWdTfJXY0TNrOTd02Z2x1TzxkOwbx70LECOnCqsrj9jwm1oHzGBT9t4FYsirjQhH6CcC5ymaPRJLQNLtVLUR7tKAW76+Tm4fdhWAQk/XpQugHYVFpqWccpcyJiLpR1lwcK17MajVeFvjFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SJ0PR11MB4941.namprd11.prod.outlook.com (2603:10b6:a03:2d2::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9031.24; Tue, 26 Aug 2025 01:23:25 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%7]) with mapi id 15.20.9052.013; Tue, 26 Aug 2025
 01:23:25 +0000
Date: Tue, 26 Aug 2025 09:22:36 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <peterx@redhat.com>, <rick.p.edgecombe@intel.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 1/3] KVM: Do not reset dirty GFNs in a memslot not
 enabling dirty tracking
Message-ID: <aK0MXIcZu4H7Izw5@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250822080100.27218-1-yan.y.zhao@intel.com>
 <20250822080203.27247-1-yan.y.zhao@intel.com>
 <aKzKw70r5bRnv0FC@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aKzKw70r5bRnv0FC@google.com>
X-ClientProxiedBy: SG2PR02CA0117.apcprd02.prod.outlook.com
 (2603:1096:4:92::33) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SJ0PR11MB4941:EE_
X-MS-Office365-Filtering-Correlation-Id: 85830837-c9c3-4147-18be-08dde43f274e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?S4+BS4xF0qNdfcpK5W2ic5EAvIRV5aZmBITxEakCi52REOEjC6Tpf1dKj2m9?=
 =?us-ascii?Q?+jjIrGWVEnvq/a+5GEUoBmLfaqt26ryohbkTHWDHQdBXcTuznzv2hcaYcFoH?=
 =?us-ascii?Q?AMVzBh2NplzYLBpJpZy4CGd/5Z27PpxtnTTJflAMvTsfseUO22y8B+RkB0Lr?=
 =?us-ascii?Q?33wVwlFfe+ivQQPSdlG1SPn9kBGTf3R0ahRfoyxT6msK3azxqVY3hfpR3q00?=
 =?us-ascii?Q?fkvUatJ5l3qFz8FM2NX6QnNMGGQENKtNEQDjavGsf/OcXsp4HdwIP5QD8TUZ?=
 =?us-ascii?Q?Duncuj+/kt4+MrCI/fI23vmnkhSPK64E/vbXVy7jI125J+Ci8O1GFaRpWpgA?=
 =?us-ascii?Q?FvbK8tTgPgSzvNkhF9cARzXtTyrGzyfOanNLUztLbnyMO4AivtUDfIw58xqX?=
 =?us-ascii?Q?2u/14wp13lDH7Ix6/VOcdOnvTfjEVy7CXLN8kd58oaiGhjlbNEW5nqZFc/12?=
 =?us-ascii?Q?njna5CYyGgXaS3LPKQ+jJmpV5pap5tGnWqzM1LiO/wGMMWxsEZkWxwsPf8Zo?=
 =?us-ascii?Q?VnfWERBZN7n/c+FcwOO6QKJIM1oI1H2Ka9tisxMEC82xUiqkzh+ue4PE47fO?=
 =?us-ascii?Q?DSBc4Y0KCPzfhuybc8QvkV5nRyC8U6c21M3C/TEwRfnjinlqFnsxFympOT40?=
 =?us-ascii?Q?TXixwlQMpIGN1eUhvbexzKHcnroqgID0XKf9yiZfA8d7kWbpOoK3yEx6q70S?=
 =?us-ascii?Q?yUkaZ+ztY7NTRZ3zJdLm17TaRVshEUewMZPsw0vWORvSe6GajQzU1HyZiwf1?=
 =?us-ascii?Q?wj/VKHxgTv9byXUdbUEyfJFom57JgsDx9FMFw3+a4ePMAKFS8LBtc1RDgusn?=
 =?us-ascii?Q?CpIEFaMchzZNMC7q7JHAN/tR9FGo9Ez1/5vfj3p19ws5KVDz4o3wOg0x9zkb?=
 =?us-ascii?Q?aK45lJ+I9+0LJwY99xVAq2RYgm7XIX/a6o/j9Btw0b12HhiyVCxnfP1HMNmV?=
 =?us-ascii?Q?RTnipJxBev4mf5QqzsanTy7KlZs+bIyfXXYePyuf6A3r8LdJiyLkz/lZMl29?=
 =?us-ascii?Q?buwA3TuiVl7yNfTrOTTMXqkHN4OmW8FAza0JQaLzQSgb5XKAA5Ux6qeyc8jf?=
 =?us-ascii?Q?UgEc6w3XV+g+ILhBmUMrHC15mPN/uFYJP8t5RFqTWuUU1Z+eGryhP0zbklYL?=
 =?us-ascii?Q?AgJPs95+8OfCbYqdyBBW/JviNisJV91usuexX9G7tPCeLLXFbUFMNrDdcQmG?=
 =?us-ascii?Q?ZuIUTUWvwwmhrgCF27IPBhE9TcO9eUzmFkxXEBSqmsuwjxChbOkPBRPZ5Dbc?=
 =?us-ascii?Q?0kjr6Vi80t1GemRTtQK0H/rS9x7r5ojB346EWxYYXtxFdjDIhSdhcWXaK1bP?=
 =?us-ascii?Q?prCwSkKyJi6MoCUKUafhLuqOaBeXVBkjCSAfILiycmevyHh5NwxAOKZry4W4?=
 =?us-ascii?Q?0Js0n3GokbbkC/cchKQF8ss5mnDivxneSXRUW/YLrbgN2n8XsfoWtn+y1QO3?=
 =?us-ascii?Q?3x4Dhar3h78=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bF9l8n13N4jP+0qGXWds4IoVwfhosSbvODZG6WV15LfEzNU/EEkKYCaBOnOG?=
 =?us-ascii?Q?a3X8vZZtowCLOGNAeXAM25oKWBpq9pb/SoSHNWz3wUniEvnluunAOA1zjUge?=
 =?us-ascii?Q?bqu4jTiZDIn0+aLPebjeEh0wVSCbE6Bj62n8u/3g5Z8j9D6sXSnMIb5vUt7D?=
 =?us-ascii?Q?OXVqCDxFHQ0z4Qd6TP/6VH/UD6m4WX5d2fTkjvda3cx2iYXgfLdmKJpBno+B?=
 =?us-ascii?Q?Hr24pPvBMCNiDq9yXk0hm8hAG6KasP8QYfhqSDQJ85GPO+8vN4FXV/d5+jLJ?=
 =?us-ascii?Q?Spa+FXLeIfY2oBkb3PSbYk1Ob1qetupwh0N72GAJfaJrgWLfTbmzQk7AJepD?=
 =?us-ascii?Q?SPcqv3wjspdbR4IZeyX+SEfSCiE/cJDAcHomJXBuZnckBJUwCfQfpO8UHyeL?=
 =?us-ascii?Q?ZHSvNqdXoat2FVFPnuEnwN3t6smnq7N+MbKNZyZYZuD7QpKgj61qLKB+BGe6?=
 =?us-ascii?Q?G6AvTt/BbGQEkf11IzyAamwfB5HIv4MmVDBCPEXZsmS0N9i6LcFiS/E+Xnz0?=
 =?us-ascii?Q?E0p57UyUgIxQ/RmzCsMv5OER+S+JezD4WTDQMw+7gbvjqCkla57BB4pgDKmF?=
 =?us-ascii?Q?ZOvmSVoL3Sgr0HYaVWzLC+PVnokUePpTU44Zynn2XBPTBXC3vz9302riqVJ1?=
 =?us-ascii?Q?ovtHiwEbIH8DAwUfSyifCHOal6EziKqd6qC2pSuOxihCB8W9mtYiI0se+z2l?=
 =?us-ascii?Q?LnyOudIrbpNUsSRG1YLCMfmP1toZUw51BHPb6FgeTYt5sociTrkHF6BcRJo7?=
 =?us-ascii?Q?5ii9slYrLrQGCoJChAa6rBTmCKPRyL05AE6gYTGHXeG+S4dT+/hJ9v0iBnHf?=
 =?us-ascii?Q?4marBp1pgPm7aXjfUn4fh64hswMMrIyEvT8JmTYEvhSthlk4Qq0ztcEsIT6k?=
 =?us-ascii?Q?jEo7+LjJTXIUkv8hc7l8II5oJ8aLD6T+Z1O4G7kYLs58m7tf4VndULNV+ffz?=
 =?us-ascii?Q?Wv7eiXQDJXyhB/E8QoCszT9jbsTm8CbVB8Mu5Jv2KX0J5X4zsIJKvweJcV97?=
 =?us-ascii?Q?sB8+qdxKtNfW+fRtyFVFaAwgTBxmUk7kkK8mHaTf0HEh5SVuNMF4anDVtZ8A?=
 =?us-ascii?Q?ias0i2/3I1pJ1KET/z+YqWRfDOJqnO+e+nHyu9sLaGWN1rggSpBCxCSzVCB7?=
 =?us-ascii?Q?uM32smfnmr8YvS4VJSZRjjN6nEiLOCON5KbXbMJoUvPq3le4yjyzcEWmYq1i?=
 =?us-ascii?Q?tt2IvtxpNPw85ugyatCEQd6HDBwi9VQ72JCxFdBXkNSFQJf//MY6UeHOHEnD?=
 =?us-ascii?Q?zVSgckBo/WFzJR0jBy5SMLWbxPoouZ4JU7pmrtulDPC2R00dlLiublPz8mt5?=
 =?us-ascii?Q?A5M8E2JxV1/GatqfIQZaOEWntHhLtXSk9F9Xikj+syMBcACO1GCKU56cWyzi?=
 =?us-ascii?Q?6R/CHhRbZnof9i6BElPXOjGvboJmvkA4/P1SgF4WcOoKN56OZc1k8Nhc+6zb?=
 =?us-ascii?Q?Ez0prFTo51IL65cHXgOhQmgTxIIKUrx/xB+buAc4/clCSx68J/rTNnmJRACd?=
 =?us-ascii?Q?cJ59sqwdPAXEgcr1wMr4P4FPrvxPdybWLRsgKLcLnVmExOb9j73+xKsTXZ+u?=
 =?us-ascii?Q?gkaEbp5+WDAxdneNHu8Pro+xdrBfmZRIJbpc/nxF?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 85830837-c9c3-4147-18be-08dde43f274e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2025 01:23:25.1659
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L7YRfahnJnAAI6vjtszEVRZ66cccJI4L2RRgCrpNUGCsDEo8D22STOIBJAoudhlfXwKt3+YCbKKaX/35PLjKKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4941
X-OriginatorOrg: intel.com

On Mon, Aug 25, 2025 at 01:42:43PM -0700, Sean Christopherson wrote:
> On Fri, Aug 22, 2025, Yan Zhao wrote:
> > Do not allow resetting dirty GFNs in memslots that do not enable dirty
> > tracking.
> > 
> > vCPUs' dirty rings are shared between userspace and KVM. After KVM sets
> > dirtied entries in the dirty rings, userspace is responsible for
> > harvesting/resetting these entries and calling the ioctl
> > KVM_RESET_DIRTY_RINGS to inform KVM to advance the reset_index in the dirty
> > rings and invoke kvm_arch_mmu_enable_log_dirty_pt_masked() to clear the
> > SPTEs' dirty bits or perform write protection of the GFNs.
> > 
> > Although KVM does not set dirty entries for GFNs in a memslot that does not
> > enable dirty tracking, userspace can write arbitrary data into the dirty
> > ring. This makes it possible for misbehaving userspace to specify that it
> > has harvested a GFN from such a memslot. When this happens, KVM will be
> > asked to clear dirty bits or perform write protection for GFNs in a memslot
> > that does not enable dirty tracking, which is undesirable.
> > 
> > For TDX, this unexpected resetting of dirty GFNs could cause inconsistency
> > between the mirror SPTE and the external SPTE in hardware (e.g., the mirror
> > SPTE has no write bit while the external SPTE is writable). When
> > kvm_dirty_log_manual_protect_and_init_set() is true and huge pages are
> > enabled in TDX, this could even lead to kvm_mmu_slot_gfn_write_protect()
> > being called and trigger KVM_BUG_ON() due to permission reduction changes
> > in the huge mirror SPTEs.
> > 
> 
> Sounds like this needs a Fixes and Cc: stable?
Ok. Will include them in the next version.

> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > ---
> >  virt/kvm/dirty_ring.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> > 
> > diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
> > index 02bc6b00d76c..b38b4b7d7667 100644
> > --- a/virt/kvm/dirty_ring.c
> > +++ b/virt/kvm/dirty_ring.c
> > @@ -63,7 +63,13 @@ static void kvm_reset_dirty_gfn(struct kvm *kvm, u32 slot, u64 offset, u64 mask)
> >  
> >  	memslot = id_to_memslot(__kvm_memslots(kvm, as_id), id);
> >  
> > -	if (!memslot || (offset + __fls(mask)) >= memslot->npages)
> > +	/*
> > +	 * Userspace can write arbitrary data into the dirty ring, making it
> > +	 * possible for misbehaving userspace to try to reset an out-of-memslot
> > +	 * GFN or a GFN in a memslot that isn't being dirty-logged.
> > +	 */
> > +	if (!memslot || (offset + __fls(mask)) >= memslot->npages ||
> > +	    !kvm_slot_dirty_track_enabled(memslot))
> 
> Maybe check for dirty tracking being enabled before checking the range?  Purely
> because checking if _any_  gfn can be recorded seems like something that should
> be checked before a specific gfn can be recorded.  I.e.
> 
> 	if (!memslot || !kvm_slot_dirty_track_enabled(memslot) ||
> 	    (offset + __fls(mask)) >= memslot->npages)
Makes sense.
Thank you!

> >  		return;
> >  
> >  	KVM_MMU_LOCK(kvm);
> > -- 
> > 2.43.2
> > 

