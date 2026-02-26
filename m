Return-Path: <kvm+bounces-71934-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8Gv8Bi35n2n3fAQAu9opvQ
	(envelope-from <kvm+bounces-71934-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 08:41:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A11421A1F44
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 08:41:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E3429301F9B3
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 07:41:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B664338F95B;
	Thu, 26 Feb 2026 07:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W3okHnyr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99B238B7BB;
	Thu, 26 Feb 2026 07:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772091672; cv=fail; b=PP62+Lh8qTrshmUY/mctmzLYm6g0NH6ATdz39CPrnuMzSW72AFfayBocWIxsmF6Gtw2hX3JjE9VN1C2XhzQrJk0E/Lc2qfh/0eGl1EPUKpoqmcM0FSdwSlUinRVA+sABGg1Ffd54qkhNLdoZq8GckU/UwzJ6NRCrxRqmR/l0zkY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772091672; c=relaxed/simple;
	bh=4Z2PZzeEHRwAWF7Iex0v9EmdYMcpI3glM6EBwsU5q0Y=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=hT3pC6WE3VTXYztmDnizrLQzRzYdZ3y73QfiCYcZZeAxDt0epbDvkRUK4W/EoxiWAz1LZyLH/+d9wzVKfVOXAe0UwBHWPYtOET84evdZWnJxrgOfbIYJTRYFPiDZawPCxf97PKvDxGMxN9AN/H//iWXg2ydOowfRwcYc0mMqGIc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W3okHnyr; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772091671; x=1803627671;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=4Z2PZzeEHRwAWF7Iex0v9EmdYMcpI3glM6EBwsU5q0Y=;
  b=W3okHnyrR0/VPFekyQNJnLpR+ni9VILdR8pl3WvfhkVO9jciyVwCItP1
   n88Of3Dh4CkfYjCkJINFD0p1dbTMtJwDnWx01fhPCsyzOvVuZb5HyVze8
   oezCPqbqDGhDoMlsgKitaG66VN7BvBoAth8S192/hhA3e7/mHjhhLUGUU
   8UBsbp9wP7pR4bcKxuskPljLWCKa01SwcCyi5XPfpJ4+3dHApcBKZU+p+
   NTgvULkYLUUfjNB4ozKiKu3a+No9CyZ1TE8AQ+RznjK44mBaCKmyEY0lz
   NGAsCTbSPXxkgotZIgtLZ00uY4F/Wl6WKOjY1eJJ4uhZk+5wdRToqFDaz
   w==;
X-CSE-ConnectionGUID: D7P071eeR32Sq9GYSljYtQ==
X-CSE-MsgGUID: +40gJ66wS/WP8iWEYSZp5Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11712"; a="83776238"
X-IronPort-AV: E=Sophos;i="6.21,311,1763452800"; 
   d="scan'208";a="83776238"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2026 23:41:11 -0800
X-CSE-ConnectionGUID: Jps/SFTeTSeFFsnu9M36fg==
X-CSE-MsgGUID: /g1Xn82TR76sKMCZ5a6cVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,311,1763452800"; 
   d="scan'208";a="214066851"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2026 23:41:11 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 25 Feb 2026 23:41:10 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 25 Feb 2026 23:41:10 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.32)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 25 Feb 2026 23:41:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bAsQWVh8NRKB8kAWFTIvxKwX1AEW8KGRUJ6rMoJHlisWv3HRQmgPR0CwWWUTVowQw++BPobqjGGwFSEn6NhEzSNx1UO0sWH7yjnFlbmkZmWWZgHywH/m67kEAYVEhEGdSI+pdobfA/xwxFEhS1tmIWUJ2+TRkq0WVr2i6DcCrreHkhhxbb98693HJ2gmwXEuE0mZMAur8p2EC7S5a+K6Zk+NC0SEz37pLg1t+Q3l/hguXuZuxAurLjsTe1K5mL4cwn2vMYNRy0xcFAe34J+r6MkC44A28H93/Uf29z5z6ECo2pvAekQzHQvpB/eue9JUz/SVs8YdKZs4QfrKQ+5otQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SiEWjH+c3YjZilh9h0T+bKF34fZq2jM1wFhQF4vLX3s=;
 b=L04iZU9hJtJz0WGH7bORRGNtVHhLprouCbf7rhXiPUaSSNrUNoamTajuvVDnDz+aLT1RLVVUgpMcfDKd3VllOIewzeu9soemvz953a7czs2zyBwNoP/vUZrBZBxtTavRiswWnzWL7gIX9/Lxk6PbhgDwBzMtMpA/fJKirANtbfSlM7hAQHU3F5H6AYQAbNBQoLBhFgh0+j93wroGrf91hG7IpNcuHcR0KZQv9cWvrehnXv10bAqX3WjydEdLIkcFFW/Hr/VC2d2HBXF9igEwwjx3imgDj14A6BtrCsLsOI3mYW6aiv7QRZc0Ldo22IkaHXaerJHV8i0m8AyZRRY5Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SA0PR11MB4623.namprd11.prod.outlook.com (2603:10b6:806:95::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.14; Thu, 26 Feb
 2026 07:41:08 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9654.007; Thu, 26 Feb 2026
 07:41:07 +0000
Date: Thu, 26 Feb 2026 15:40:56 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, Peter Zijlstra
	<peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, "Namhyung
 Kim" <namhyung@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	<linux-kernel@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<kvm@vger.kernel.org>, <linux-perf-users@vger.kernel.org>, Xu Yilun
	<yilun.xu@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v3 07/16] KVM: SVM: Move core EFER.SVME enablement to
 kernel
Message-ID: <aZ/5CDmCa8O5vrFZ@intel.com>
References: <20260214012702.2368778-1-seanjc@google.com>
 <20260214012702.2368778-8-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260214012702.2368778-8-seanjc@google.com>
X-ClientProxiedBy: SI2PR01CA0012.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::8) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SA0PR11MB4623:EE_
X-MS-Office365-Filtering-Correlation-Id: 806cb050-332c-485d-dad5-08de750a675b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info: gix/oqStzVATKAxSLoKmQocg99dJ7v0MhrAUK3j73W69wWKz2Q5SZGZAi1iz0xSokY6sjEt+nF6J82X15WERjR+HD1AyQxI8/kh+E8k7c8wtlmZgqBQpx680MEB/PUlxjUgkjsKkF8sTtYMrmTHLalVFJI+dv5lHU/c+OwIfJ3XgfosSaXr7Y53BSVAYOLjRvtC+iXyrIlA9Ri0JxIh++kYCfTijEbqCqT+KSZ0RMIOVB6nzxeDcHthETL8Ski8C8UIDLn7exsW8X5n1yYKW7mPvYdkq+BOOXA/UyWjIrQsULsU6OrrJB8RWeF1Ag2oWjTXiyxImOHyieawdOw/TQhDWjsMwT1lO1YaUvkaLylY6QaFmdJ52nDSnwFUt3C65+nF57flv6ZVxA693NNTi5LUd+BQQ0TQwSo1+7WEG+Hox7xfyyymTWiiH9zf5q3XjhbkwTDS29SLu6Ha+0/pEMOih6EPtWeLKlinrjmW3x76082TQBX5bV5NBjNNPujCh4QVm5r+KwaMlPqjdmR3ulRzrGKw0fSd4ZiHV5WVrUAw3SSDz4IXY4jzCWzvFxWnwzP58ZWaGyWgE14zy90vmkepUNozVFfvCBzBxy4BxjMCbFLwhRIfmIyC2zjbH6oj+luk26dbQJPKXDDHHAvvPLs2sPJLrrdUPIq4wYt8jm6QuXI6bmSvAaxNtVW5xUdN4FBiNPtksMaVasnfCUEE6r6rjEJHU1lT7KkJzCd7xt6s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kLjFIQjMZk7qiffKEKkNi3VXaRwDjsbXw1WUAcYQv9VM8urdRZmYzxkxvMv/?=
 =?us-ascii?Q?5LkWQWgkC8iHQZsxvi7TSV+xFkRaNyZJl3UAuWKem7TIN3cpA98EgAFS8inw?=
 =?us-ascii?Q?dYQhwnMedubGJdApj+tSLIe6ri2fHJPtC0wBcFdhq8/qUdORNT6hULaLgklF?=
 =?us-ascii?Q?jyLcA+EolzwfC3Vbxm6HmyhvasifWghMGTymDW56mL2yq4mJKXDvpHJmLQRv?=
 =?us-ascii?Q?yp3znQppHYlBqKpg/6VbO+Djy7QGfBYVWH9qNfv/uy2Lfd6Ul66wdU4zxEYg?=
 =?us-ascii?Q?b8n4zjiMca8foqn4ooAEnDd+lb0JAtTgLH1LY/54mXMzYEW0dKL7E3gI4kHp?=
 =?us-ascii?Q?dX5p6UMWdMkayrFcz+X4ubFC5BEDBeq5yLNpb3e9i68e3nTk0tpAt+vspMou?=
 =?us-ascii?Q?A8u0W/ZVsaLhfIfH2LB0+5xS7lbZQwxAFaWOizRWj86vHYn8rCdWIdXmgKbC?=
 =?us-ascii?Q?4IzA3T4p2mltFycI4WfMW+VZCA5gLbhlY7KBhsHIDLgWv0f94HgSKhtIUk8p?=
 =?us-ascii?Q?B41ElYwFkUcCiF1GWqBXLS/OCPmRi08rAhYkrZGCWk/F86DX7jDbCTC5ZRnf?=
 =?us-ascii?Q?a/Eo5nfXXI1idC11Kb0Oa/GLETTW+OlNCPit/6j1RMD6SOGSlDWYWSzSPv68?=
 =?us-ascii?Q?QUyrI4a35LYm3Dw63/VbewOpOw/DJeODKC3ZfbihHRMtwYkh38X0KK5ZWJrX?=
 =?us-ascii?Q?4qnZ1VtoVkAk58ckJTyVZKxSoNPg4yTe7psYv/xHQqHF3uu9fURAwX7WSAYm?=
 =?us-ascii?Q?vRgfq/sNYKfffCQ2/UWc+zJi6xSaY7zOYEscAVrBSVh9hWFzWAeHziNZrSBj?=
 =?us-ascii?Q?BO9b82iCHpEqIGo19nnfDgVruE3EBJny/0241Z5zKeJgQWHmfDtOzpX/Db4b?=
 =?us-ascii?Q?k1N0Vn0javZXwv1o37jtu9lMrdpuWjqT9gMioVDDOsQZeb5xbzV8oSUElRcn?=
 =?us-ascii?Q?xfA/YOfYnJU2H1/VJXkHDQPXk/XoRjogz1hhmxwjnaLToN9EFwJ7oDYyFytJ?=
 =?us-ascii?Q?kZ4I1HkLqHc4bZPWKmLkkWqoWcJl6HQ4NdoCAi+2HXt8evUJGK6iesLghN6J?=
 =?us-ascii?Q?tCYuUKBPnMUUuseoCCzuqe79/NCyt8P0ql6PKSddy1fBeVmmr3Rq+BAcpUTr?=
 =?us-ascii?Q?ESm+mBxjN4PxkH3ItXDmA/PbLjIb4RvqM7eyrZo40zfwnzPFJcywq8/jQxCF?=
 =?us-ascii?Q?oGik1PAoEjUjPn9AliInXmcg9gdsZZQDCvC4ur9Cd4Xh2REaYACXydCly50M?=
 =?us-ascii?Q?C2rQCZ19ZXaejIehso4WxIU5TMDQljt9aHXCRbKsXeEneks4CsW5fblP8Tei?=
 =?us-ascii?Q?vbfUGnAgI0FOhbBNZiV5/ttqhCAIZfdwCGajb2lFmSHV0kJQuOqkV8SHK5KA?=
 =?us-ascii?Q?viWnVPwh+xxzY99v84pilwwUXytGti63AVJPyQs+xUmuxDr6rF63JPnrD/Wt?=
 =?us-ascii?Q?bib7MqV7khY0JyS/ug00Zv2sYkMs62jYJvzKmnfx9QG+bOA44aHHoPk5XBov?=
 =?us-ascii?Q?H+1iVppkKLeuKzx1PitPrlZjaGKTHKuIObW2upQ4TlPUARVFQEeKvB+e+ugz?=
 =?us-ascii?Q?KPzmoIB8oLzx73zzp2dVQRdyn6oLgZWasig8xQp6VES0MNDkkeGvXssNsiZg?=
 =?us-ascii?Q?fr1RURsfa92j4STA6bZ23Q2nx08h8S9Y3RrSKOZJv2KPCPdcqmQ51D/fj3b6?=
 =?us-ascii?Q?cSRs9L8nUMWQvSFepExyzLJQC4qcBtjdJ9a2h/BJrq+Vd/aG1WStTNeT5nwZ?=
 =?us-ascii?Q?jrWnio/9PA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 806cb050-332c-485d-dad5-08de750a675b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 07:41:07.8765
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mhCUajxtbxeF/+3zQWopiyM2n+Adm8evnQ4biUtEfzlODE/LhNqoAlf5j3HoCP1mPcNTUzVfmn7CrloYKPwklw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4623
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71934-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: A11421A1F44
X-Rspamd-Action: no action

>-static inline void kvm_cpu_svm_disable(void)
>-{
>-	uint64_t efer;
>-
>-	wrmsrq(MSR_VM_HSAVE_PA, 0);
>-	rdmsrq(MSR_EFER, efer);
>-	if (efer & EFER_SVME) {
>-		/*
>-		 * Force GIF=1 prior to disabling SVM, e.g. to ensure INIT and
>-		 * NMI aren't blocked.
>-		 */
>-		stgi();
>-		wrmsrq(MSR_EFER, efer & ~EFER_SVME);
>-	}
>-}
>-
> static void svm_emergency_disable_virtualization_cpu(void)
> {
>-	virt_rebooting = true;
>-
>-	kvm_cpu_svm_disable();
>+	wrmsrq(MSR_VM_HSAVE_PA, 0);
> }
> 
> static void svm_disable_virtualization_cpu(void)
>@@ -507,7 +489,7 @@ static void svm_disable_virtualization_cpu(void)
> 	if (tsc_scaling)
> 		__svm_write_tsc_multiplier(SVM_TSC_RATIO_DEFAULT);
> 
>-	kvm_cpu_svm_disable();
>+	x86_svm_disable_virtualization_cpu();

There's a functional change here. The new x86_svm_disable_virtualization_cpu()
doesn't reset MSR_VM_HSAVE_PA, but the old kvm_cpu_svm_disable() does.


>+int x86_svm_disable_virtualization_cpu(void)
>+{
>+	int r = -EIO;
>+	u64 efer;
>+
>+	/*
>+	 * Force GIF=1 prior to disabling SVM, e.g. to ensure INIT and
>+	 * NMI aren't blocked.
>+	 */
>+	asm goto("1: stgi\n\t"
>+		 _ASM_EXTABLE(1b, %l[fault])
>+		 ::: "memory" : fault);
>+	r = 0;
>+
>+fault:
>+	rdmsrq(MSR_EFER, efer);
>+	wrmsrq(MSR_EFER, efer & ~EFER_SVME);
>+	return r;
>+}
>+EXPORT_SYMBOL_FOR_KVM(x86_svm_disable_virtualization_cpu);

