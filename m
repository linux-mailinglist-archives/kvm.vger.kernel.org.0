Return-Path: <kvm+bounces-69408-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QAx2GsRgemkc5gEAu9opvQ
	(envelope-from <kvm+bounces-69408-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 20:17:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D810FA81AA
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 20:17:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 730683023076
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:17:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4AAC37417C;
	Wed, 28 Jan 2026 19:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D1PIMKQy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F9971D5CC9;
	Wed, 28 Jan 2026 19:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769627833; cv=fail; b=jJkyKqYybT2LtX381VP/Kmx8WTMbYp2gOOlUBj3KoEIY3WgUH8P2zNXHifc1RJSG3UqbLxCdx1mr40sS9+WZr0q+ytXXsKabPWjhjcsBN109lhixl+oqhLZJ4WY+Ztp6Wxae9m9i88AkCMM2e6xuQ1eTOTAmve4LpZbv+x0U3h8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769627833; c=relaxed/simple;
	bh=7+jqySFjRPA1wEmBF+x0eLWXKh147aRqScJEjwaTHdk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=RretdR1MxYJ4GT+yYAqxnxUSxjFfWy2POBbkL6Mz3dYjUluhWAULM/6pmLgYFPMuHjVXE+Bw1uUxtT6AJ2sduTpXXKakESus5aVD1JyO47BWU63VLZApC1RTa3OELyFMqJUXlmj/SOO37inzD4325ClkfRIxm2kJsutFu3LD1Ec=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=D1PIMKQy; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769627831; x=1801163831;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=7+jqySFjRPA1wEmBF+x0eLWXKh147aRqScJEjwaTHdk=;
  b=D1PIMKQyn3njYs4PXRcxi1w7gCX2bArhl5qcqiQdpiEvjlA5LQkMYIcb
   VKs0DQmRHGpJPwGpwzd8cK6uW8Jf9lkPMComL43mnIobxJQCBAfYHBuMX
   GwEabK845p236Wwa0aMVQnXNI4k6k277wzxzQpKE1CFfFZtzIPKWJ9m2Q
   X13Chcvq9tsKQGjxcUysBTyESUoeJyF0H9eGMc54aA2Na12vlfTGqT+Om
   ehZiZJdRI2HPC/oDCnoANcUhea6w3NnWi3wetn3qYa3O2Vlr56WwspRDP
   uoW5hce/HjSHpiBX7Gwm6nzID4DcwTyY8RpAR2WEFFNG8PHj/CxsTMTuC
   Q==;
X-CSE-ConnectionGUID: ofE+gZa7RkOs6Cipq4oGNw==
X-CSE-MsgGUID: SDAPpqP8T9enZL+EVvthiQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11685"; a="93510340"
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="93510340"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2026 11:17:09 -0800
X-CSE-ConnectionGUID: xEs2DgoaSYKyrybs+/lEBA==
X-CSE-MsgGUID: 6QVALMO1Qk67OpoS8aL8fg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="212901531"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2026 11:17:09 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 28 Jan 2026 11:17:07 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 28 Jan 2026 11:17:07 -0800
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.8) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 28 Jan 2026 11:17:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fDGc15ZSVETk+DHB6Y1wZK+oAR7VqMW69DnI/G755pC9D+uEJQ/h1Vd+KcvavE2cKz8ecY2aQ2xit5LXJ2s4mfE0wyUJhgEEIJluvD1baoHwoFug9WEjInrV+H0M2FMEYZg/MHk5HYsIObnd8eXMFvNXCLfNy4gQRdlzoH2b2xZzcErm1H8sREU5rWSOv0gsertLOFL4NgOqYZ2/Ed+ZGG3BYh5iAU5q2L1LfYtfefWBbNIyQ7JCStaJ5MDcsGE6/t6uSwEFKuin734CGrC+Bgf6nF6LBhWdocDRsXJz+h514WU82MBMLmA19bdEXmWiQFfW9W2o0Q7WPibXluCQ/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rRsJZRzCkYFx1J5AvBqsBGffP9qH2zW60jU6Y3rwe/E=;
 b=T20ktAbX/guElo2vrOulsP1joYOa8tXmxoDkFQZktzSq6QOx0YAs3VtUMYvbhJKR3DxXtBNaH0FYRyiLoFBa6yYwzZj10PAeAFRXTdSjPiYQOuFn6aoDNhKtrWzXb7YIlOkH+kViEV4c4IeB7THJtdhFAZiNmt0HrbgAHO9tHE+OcMyH+NnXvtglgjO6a3WK7vfEnTqS3rh5Hqgb+o8AMRtx379mtcvFYC8sMTklgikHl4tV7hFpm66/p9szyDzCbbXux0DU7+nt8pglxcHgay6FJMJaNaucvaPOGoLboeqHOxpQtycglXnERVcmohfkmKpGul/oqiNGA2Di5N3wUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by BY1PR11MB8008.namprd11.prod.outlook.com (2603:10b6:a03:534::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.16; Wed, 28 Jan
 2026 19:17:04 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%3]) with mapi id 15.20.9564.006; Wed, 28 Jan 2026
 19:17:03 +0000
Date: Wed, 28 Jan 2026 11:17:01 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: "Moger, Babu" <bmoger@amd.com>
CC: "Moger, Babu" <Babu.Moger@amd.com>, "corbet@lwn.net" <corbet@lwn.net>,
	"reinette.chatre@intel.com" <reinette.chatre@intel.com>,
	"Dave.Martin@arm.com" <Dave.Martin@arm.com>, "james.morse@arm.com"
	<james.morse@arm.com>, "tglx@kernel.org" <tglx@kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "juri.lelli@redhat.com" <juri.lelli@redhat.com>,
	"vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
	"dietmar.eggemann@arm.com" <dietmar.eggemann@arm.com>, "rostedt@goodmis.org"
	<rostedt@goodmis.org>, "bsegall@google.com" <bsegall@google.com>,
	"mgorman@suse.de" <mgorman@suse.de>, "vschneid@redhat.com"
	<vschneid@redhat.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "pawan.kumar.gupta@linux.intel.com"
	<pawan.kumar.gupta@linux.intel.com>, "pmladek@suse.com" <pmladek@suse.com>,
	"feng.tang@linux.alibaba.com" <feng.tang@linux.alibaba.com>,
	"kees@kernel.org" <kees@kernel.org>, "arnd@arndb.de" <arnd@arndb.de>,
	"fvdl@google.com" <fvdl@google.com>, "lirongqing@baidu.com"
	<lirongqing@baidu.com>, "bhelgaas@google.com" <bhelgaas@google.com>,
	"seanjc@google.com" <seanjc@google.com>, "xin@zytor.com" <xin@zytor.com>,
	"Shukla, Manali" <Manali.Shukla@amd.com>, "dapeng1.mi@linux.intel.com"
	<dapeng1.mi@linux.intel.com>, "chang.seok.bae@intel.com"
	<chang.seok.bae@intel.com>, "Limonciello, Mario" <Mario.Limonciello@amd.com>,
	"naveen@kernel.org" <naveen@kernel.org>, "elena.reshetova@intel.com"
	<elena.reshetova@intel.com>, "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "peternewman@google.com"
	<peternewman@google.com>, "eranian@google.com" <eranian@google.com>, "Shenoy,
 Gautham Ranjal" <gautham.shenoy@amd.com>
Subject: Re: RE: [RFC PATCH 13/19] x86/resctrl: Add PLZA state tracking and
 context switch handling
Message-ID: <aXpgragcLS2L8ROe@agluck-desk3>
References: <cover.1769029977.git.babu.moger@amd.com>
 <17c9c0c252dcfe707dffe5986e7c98cd121f7cef.1769029977.git.babu.moger@amd.com>
 <aXk8hRtv6ATEjW8A@agluck-desk3>
 <5ec19557-6a62-4158-af82-c70bac75226f@amd.com>
 <aXpDdUQHCnQyhcL3@agluck-desk3>
 <IA0PPF9A76BB3A655A28E9695C8AD1CC59F9591A@IA0PPF9A76BB3A6.namprd12.prod.outlook.com>
 <bbe80a9a-70f0-4cd1-bd6a-4a45212aa80b@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <bbe80a9a-70f0-4cd1-bd6a-4a45212aa80b@amd.com>
X-ClientProxiedBy: BYAPR02CA0068.namprd02.prod.outlook.com
 (2603:10b6:a03:54::45) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|BY1PR11MB8008:EE_
X-MS-Office365-Filtering-Correlation-Id: fe9dde6a-abcc-4de7-7374-08de5ea1d1d7
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?XOrZXmlbVqfVK3IQvKw9EgJp3jAP1YRB9caGUAW0TnTfMOl+5F7vtmuWvfS1?=
 =?us-ascii?Q?fdetsuV2LBFRR+mCogXwvhkwVYiasjqv/Zo2+tZ9AACxAaX/8ILcHZKwMTfI?=
 =?us-ascii?Q?pAZwPY6PzHtUjB81s5tdRIF2VnpP1h7Ady0pc5nFRzXbt6mHuE61d3WjFfAu?=
 =?us-ascii?Q?zylizwyyUtxSGAPslinvExxPW7205ssfuW1m8Hqg6afdFdbH8Z7RrrwEkEx2?=
 =?us-ascii?Q?jeNaHOTrVBtEwu1kLws3SZcD0muBrqJ+FgJWuim2860o696sn3IUU4Z61RDb?=
 =?us-ascii?Q?fOW7OglXpRIznk8V6kpu0d2XWij7jCuPF/tIk6N3ETE6ra/5AfeH+9Rj39qA?=
 =?us-ascii?Q?v+/mpKsCdAou08+JXjhcuulZDm8m60KIPf+jn1OjUUzQYLHV0vvSEyPVgI6r?=
 =?us-ascii?Q?UeXl6gSRkt4CXiom8+483lchu3fqZUz9X1Z1LVkZoXRUMp/XgvEAwDQ+V9+B?=
 =?us-ascii?Q?HyzpX8q+mMyOuUQ7fAiGLuPj5xCGvYArVXvbLaswku5NViNIMda2oOUaLUWe?=
 =?us-ascii?Q?6F/KYj+iBhphgnF5FYhOlPu0wAzppaFRjFac9/ZPrSTRpr7stieOkVx+upF9?=
 =?us-ascii?Q?JB7/XHx7eqtuvcq5QHM/wW/ATliywCHDv4AOdBJ69FfYr8TUFAbzdWBV4zKY?=
 =?us-ascii?Q?KDghzJCuVIOpJNxXHOGOpWW9cYhq1Ur8jqorgpCm0+gQKYLdM5Aj4Rh2y5Le?=
 =?us-ascii?Q?KKO2a8H6nbao6zN3ulvzaAhd/5GmJnZ2FzGrsOcjJmtNq232qzNNjeX9ymi6?=
 =?us-ascii?Q?cFOiLz7gRUDUuMiobMjpbo6ehlsb/vwpkxkKWu3/jDtkIxBx0e24K4CDzu+A?=
 =?us-ascii?Q?ndtfGEMAIEejDydVGsT/Qxa0AgePbWokCAviywk5pUpJ/JkIfKpszpZ7Vl/q?=
 =?us-ascii?Q?mcqOFJe/OmraQg7BhQbSthGJskSm+pEHjKIYOnQRozi4LcwmQKqvfICC+Inb?=
 =?us-ascii?Q?r+IkeOxMONvY9Hq7cy4vfBEOlqMHqt0b39BI2dVNNTiZ79eqnbRUrhVBZzd/?=
 =?us-ascii?Q?tR19HioKf2QNs2KejUAwF8QM3VHLsAm9CbiRAXe+jIxRnQVQbuRvhW3m5Lyg?=
 =?us-ascii?Q?N8TnkP4GpL9Eqr5hX62pASyC3vzQf/qN/mkFZrG7nvl5lonI44mGQbiepW56?=
 =?us-ascii?Q?L8G22Ex7ZuOJCC6b0Hz2t1xy8/tmEWlzIVHExvAiCtppR/p611FCpqQ9WKQj?=
 =?us-ascii?Q?VwZO69G5yxqXL6eFyidK3HjYgFiqXdfdYt3qjz21lMpsJOw+QLWziqwkF3Ej?=
 =?us-ascii?Q?awXju+gdaQ93uplixF4lGytyzttb5lI+yyyTbfbFPTdGfcFBR5Ak3CqCF5P0?=
 =?us-ascii?Q?CNvd0O5Te8uiUJHHf9hoqMwt9WrmG6hb7zP4yx3Co7bD8TqNvSrO7GzN7S/N?=
 =?us-ascii?Q?WExE8yOxFIQlCRfMXkisXRP/jTkuIVnSDBaat1ttev7JAMz7+0qKiCx7h3pV?=
 =?us-ascii?Q?ieQDWCW5hvzurKKVioL7Ln1mdR/ffjbl4by9A/UBPYFxvjqB1pMBsoFi7rbi?=
 =?us-ascii?Q?4kEXn2iHG780MLxAfafP2uoSbN48KC3B6SNsZpg4xoXKcK/jHaBk+pgG8qzM?=
 =?us-ascii?Q?IOFQ5gwL9H7H6/NvHHA=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Kqjpr+5N0nJY2S/wVU/osQPZ6U7MgwrKBLeJZ5ta/emMMSNpfXegYmXOha50?=
 =?us-ascii?Q?ylROJzB3V2agozYUO8kcT3CiEpQI+V3Dy603WLSRgVbMo4p3iZisOhwvZQ3N?=
 =?us-ascii?Q?/cBeuUrCF9YWKUD7Kzp32KHbu6Vhd9dn3tPskpm1fqP4y3cjleBi40iNRl42?=
 =?us-ascii?Q?irlfeSmrN2JdlsZrvVLD+fhlYSb2V/4Ek/bL0U2wPt4Q/OavC0wyEeU889MZ?=
 =?us-ascii?Q?CfRv0J9xONrJE3hdYK58Nz5m2Zj+EaKMVc18qXdNUdZUur+D7+b+Gfl/bn4P?=
 =?us-ascii?Q?plDW5VxHExo+7fdyju9Cqn8e3icMc9uf7amxVjOD8xcH/ZmztPcvTRe24TJf?=
 =?us-ascii?Q?cFzx2OLpRbCYoScfhing/DH8d1PX28C7HiFcANMF4MtcSfzxBIKG3CqQYzeX?=
 =?us-ascii?Q?P1x1MdJvZVBBm268fU0VqxrzrE/s8MB0MqytipmwcRylKjxIUfVh1Mp8/pMd?=
 =?us-ascii?Q?5DoxVRRsWL1ydszg01F+5RFeGdRcWKmVGvhXBhrdBvibKsjyrDkC3VD0p6UN?=
 =?us-ascii?Q?vX9hNN2BP7fC7W09oiriIQQXqVsgchm/tkfR3E3ALnac5MjnXy0zJt3xP2US?=
 =?us-ascii?Q?akKW156Bc8t/tCY3tirMIKY5xLkavJUh7OLByQSTgp5ISEKmq/tT0TUEIpYP?=
 =?us-ascii?Q?CdrHISP4GuHoX7lthoaa2yBWLtOLfAvp96MTaBhcf/PTmn2cpp4JXLWK5cgL?=
 =?us-ascii?Q?hc9VpfjxGzcZI1h1cY55ItNq47/pn4Zq3zh3Dnya8WVMeSm+nWSqLEl2WJhG?=
 =?us-ascii?Q?jEGotsY2wPNo2ThEGlk1yKebdeaqvuEEtrlkb44QB9R7vTvHW89VQcC5aXQ9?=
 =?us-ascii?Q?F8HREt5FIUneyZkAQpLspuzXMjkjZnKHcphFUlxlYS94Risbrh27ptDguWT9?=
 =?us-ascii?Q?OdtMrLHhfsjBIHCtoL2wjmuuZ+mjINxerJiFQcpz33eb8VMdjY85Erydq2AR?=
 =?us-ascii?Q?l3TGiwXEDdlNKf+5/hWIf2EfYQNdAKoGlICN+vN9i7xYFh+34zVgNi0MQCIZ?=
 =?us-ascii?Q?VjObVhFxWBvqtHzWCJ/MrYNdcpO66dD2y/RPzg2QAu+N+PZzRUt+BfC1we1+?=
 =?us-ascii?Q?gYo2w1/oKXtYNhMy1LF+46PWJq5m/q2FIHK1GsGDNebTNC7RSoAQmE5z3JlM?=
 =?us-ascii?Q?wf2Sbo+vLTlg9S1sb4IwEKwexcD9WENrVyL3Cw8O75KW4dEVDoBU9Q7RSwST?=
 =?us-ascii?Q?2Toz3oEweD94IM+Xt2Q9jx3SXV3Nd8BEbVCoMLtPP9DVx/IFkSMtLK3fLFJY?=
 =?us-ascii?Q?h1hdWMjX9h1Q449KgwdPAfAEKHgB9PbDFpNNdBSqiT7cwo6+WulfLwrhGlQc?=
 =?us-ascii?Q?1M6aGZYslCwVdsqkAkBhoSSMScuuStkBVtfsOpO+7soKpznsEyO0lt4wgM6I?=
 =?us-ascii?Q?afSjBLBgsAaYdSA7WeQxSQdu/Y15X2+hH0rOhxyWIIGMlZTTf0R7KGwPWVl1?=
 =?us-ascii?Q?fNWFVGwHbVyXwvTa9vUrN0Ft9lErB9ehHxAt1YLtQAzCk7oq8sgCDuzqEAvG?=
 =?us-ascii?Q?a2HFbLFc73tE1WHRBU7AwimcLKFJbIeauZSQa19uVzlIIBSDBpuI3PpsnIx3?=
 =?us-ascii?Q?XWC/uSmu59Yd2NXuBe6F9NN+TP5rfkoKqzWuiTAMfUjun/JjRNrhNlluDkwJ?=
 =?us-ascii?Q?i3baMGIOJETjKyzlhEypPk/Ott6iMKb63SQypCz6yb6UX8CTDKFqe6fqGZ08?=
 =?us-ascii?Q?ct/NolIc15q0Lz4UH/8PxwSJ5jmh1lWLX7DuEoqtGJgEn2cevcSpN6nm0qBT?=
 =?us-ascii?Q?pd7WeeqqEA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fe9dde6a-abcc-4de7-7374-08de5ea1d1d7
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 19:17:03.8578
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hyMfFsLhVeTwkrLCg8hJncNHP/6JnTjal7rldUAVkwtfadoR1HV0tWOjTjJL1hcq4TX5THCrJ2Z89apOVvSvFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8008
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69408-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:dkim];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[44];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tony.luck@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: D810FA81AA
X-Rspamd-Action: no action

> > > Would a potential use case involve putting *all* tasks into the PLZA group? That
> > > would avoid any additional context switch overhead as the PLZA MSR would never
> > > need to change.
> > 
> > Yes. That can be one use case.

Are there other use cases? I think the prime motivation for PLZA is to
avoid priority inversions where some task is running with restricted
resources, and does a system call, or takes an interrupt, and the kernel
is stuck with those limited resources - which may delay context switch
to a high priority process.

That thinking leads to "run all ring 0 code with more resources".

Do you see use cases where you'd like to see the low priority tasks
bumped up to some higher level of resources (but perhaps not full
access). While medium priority tasks keep same resources when entering
ring0.

I think there is some slight oddity if a resctrl group that already
has some tasks is made into the PLZA group.

The existing tasks get marked as PLZA enabled. So run with the same
resources in ring0 and ring3. But you can't add a new task to this
group with that same property. A newly added task retains its ring3
resources by remaining in its original group. It only gets the PLZA
treatment when transitioning to ring0.

-Tony

