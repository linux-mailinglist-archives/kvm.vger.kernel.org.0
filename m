Return-Path: <kvm+bounces-68473-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BEC0FD39E4A
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 07:18:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 19577303830C
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 06:18:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4383026B77D;
	Mon, 19 Jan 2026 06:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ffqe3/94"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0278F1D6187;
	Mon, 19 Jan 2026 06:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768803527; cv=fail; b=dn1SS1kfGOT//t1vdWIsbhXwS+EAmiubosAb2SmqDMD+pVsGikyFFmQDrJU+c04Q+T1PyMdB0ko16K7F7SZ1CBQeEplRI6NpnUGIjzJCrQbK1cHzoEXkM6oe77zdkdFXSBEYWwRAblHMsPJq+amGJ1GImuENuJlU2yCmrvvbf4s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768803527; c=relaxed/simple;
	bh=v/fB7Eq0qeSZC0LDpJBwN5jZioHJkBCJffJ2Qh9y6iI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=faHu8CDNWJI9Pux3WVDXCdi4sJlN9Y5ebCrzGBr2KQqOHKDtqoyDgWP783A02j6QsCh+BJQoL7pbhhhliQs+lBxyUzj5VhusgsFErQ6K84JfclWErG19ugup3vCXfyZnuJZf0ooZ4h8DMDAfyPIpLp1XzJ80CJBnXea8WblZxq8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ffqe3/94; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768803526; x=1800339526;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=v/fB7Eq0qeSZC0LDpJBwN5jZioHJkBCJffJ2Qh9y6iI=;
  b=Ffqe3/944zbC8fhq4XFy5OapqvnQfjPnths8kHKnGv1EaSgE9XXaZ0Z2
   pSxrji9uIB0Cl1Xl0JiR+H/FaZHR6ckOvWgxwf8kaEHFx208sa1dTZaPp
   jpvIj2Bxea+nrVp0jnaZdtloHD6QmxcHsZAmzLFcqmqAKV1S0RfUlDN0L
   BlUm3lLJ3xvgONAUQ2hifYWFP3eT+kausemqhsXZwrt6gjHnslkzKY7s4
   1bxQFpD9T8NkV8ph6l8WLk/B6zAb7outN8hEWOBl8501iwYgCxLQapwGk
   BeD3Y3rGyBqvjNnKWpKLMzMrZE4wveuOkUDou5MnDJI7GESSSpHzZM1zp
   g==;
X-CSE-ConnectionGUID: eD3+sObQThGh207XAWs3tA==
X-CSE-MsgGUID: IxHCvSbTStGm7rW04INhsg==
X-IronPort-AV: E=McAfee;i="6800,10657,11675"; a="73868728"
X-IronPort-AV: E=Sophos;i="6.21,237,1763452800"; 
   d="scan'208";a="73868728"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2026 22:18:45 -0800
X-CSE-ConnectionGUID: YfXne/m0R7aCarsdfsYNPg==
X-CSE-MsgGUID: y/jV/1/0SmG8PaNAtOD0zg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,237,1763452800"; 
   d="scan'208";a="210268937"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2026 22:18:45 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Sun, 18 Jan 2026 22:18:44 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Sun, 18 Jan 2026 22:18:44 -0800
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.14) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Sun, 18 Jan 2026 22:18:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ud2SbIZ7ncA/Nh7fIeTZvZTqnSpH+ie2zhPGwB7rB2URrY9X15RRTKgxoRQ0ufBJ5drtkJOLd2j7YIQAh4wSmV4WmDLZRKL+1acR1OB3DVdGngl7rsFq/kBaE70Emo5UEgrWFiuQdxxAoOQ5FLnTSQiedZsyU2z/5FYvmLUn8N87HMQPy/0TcRQepmAk/VoKIw+36YSFQN3gB+SrnoX3VKjh7yfQGKA5nOM6XT5tsRsCG72CuxbtFGHofoFEMh6D3xzvb8URQxeTi5LTXkPHLHLHL8mFeECe+xHFG4QOR5auZjC/e1OdHfoH4zLRvszpHKr/KNneClXYcHwcpMHbbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MQrToaZ75p+Al+b3pH9shDhA8EDOh1Acqefb8LGIrHg=;
 b=OaW8nOQCuXWf7DKtKklOBWebdCGOf4sapMcaW8Jn8FUO5W3FawvBoNVAXtDQU88QJaJGZi4D0jswEjWe5HcdTLzWcJq+wezy2uNw1t2Qm5GJTpNqKTehVIvVNrbpA8aCaxV5pEDCwGYcJ2Rk0zrDbVEffIONNq8Ds+r7VgsawAdNKuN2HAUf8d1VxEktEoL7jD2RhM4YwhnfXM+NrDmrHrnNiE2/Q2AN0/8BTVidkXBdi/l/yyjtZMFVqEncJorkueSkJ+41mU4YX1/xT+/g4Ds9lT1W0g/Vgh/He7NYl+BbeArbvs2FUA6G9ap49ZREeCLKPRp3rJuY/g06Nnih/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SJ0PR11MB4992.namprd11.prod.outlook.com (2603:10b6:a03:2d4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.11; Mon, 19 Jan
 2026 06:18:36 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9520.010; Mon, 19 Jan 2026
 06:18:36 +0000
Date: Mon, 19 Jan 2026 14:15:52 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: "Du, Fan" <fan.du@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "david@kernel.org"
	<david@kernel.org>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"kas@kernel.org" <kas@kernel.org>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "ackerleytng@google.com" <ackerleytng@google.com>,
	"Peng, Chao P" <chao.p.peng@intel.com>, "francescolavra.fl@gmail.com"
	<francescolavra.fl@gmail.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"sagis@google.com" <sagis@google.com>, "Gao, Chao" <chao.gao@intel.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Miao, Jun"
	<jun.miao@intel.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"jgross@suse.com" <jgross@suse.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 02/24] x86/virt/tdx: Add SEAMCALL wrapper
 tdh_mem_page_demote()
Message-ID: <aW3MGJxR3IuC/tDV@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260106101646.24809-1-yan.y.zhao@intel.com>
 <20260106101849.24889-1-yan.y.zhao@intel.com>
 <ec1085b898566cc45311342ff7020904e5d19b2f.camel@intel.com>
 <aWn4P2zx1u+27ZPp@yzhao56-desk.sh.intel.com>
 <baf6df2cc63d8e897455168c1bf07180fc9c1db8.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <baf6df2cc63d8e897455168c1bf07180fc9c1db8.camel@intel.com>
X-ClientProxiedBy: TP0P295CA0019.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:5::13) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SJ0PR11MB4992:EE_
X-MS-Office365-Filtering-Correlation-Id: e1d823cb-8be1-4eed-eca5-08de57229474
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?uIhJWHSj2NQ+BzfetTNcGVQE5taluTFuR6HzZYmx232XRZNrJqB1uTA9d9?=
 =?iso-8859-1?Q?ZSAxkQeFHx+txOj86rxqw6QN270IQKrBUVKshyy7DN4WM9IXOBxtnaZLhI?=
 =?iso-8859-1?Q?2KlAzWNR6imttlH8srnjGaIOnmCXuxZ9fRxQuVa2gH3ZxlCkj9mnEVN9EX?=
 =?iso-8859-1?Q?8DxxHu3TflS8o0BbUUi+AW5N8XVAB8l2zvNdy52E9FIt+BT5SbSo6d5/kv?=
 =?iso-8859-1?Q?UPIyy8t2BOOaRZeniJwYd9vdyj0hSeN2Ar9EdkGFWNm2xJRL6GyoJooNeg?=
 =?iso-8859-1?Q?FBLQ8BBcdlUnf/cmm9yOkGUrgV6ajK+PUl9EEGKt0MM/NO3ZUfBKqfMVOB?=
 =?iso-8859-1?Q?0yVN38QrPl6ueieGUoRWEYsHLUZzMXUZkyVSyRvLv39ohV5s/THuo5vzDB?=
 =?iso-8859-1?Q?UzxlZem4PviiuNerZm4L6ufVjys6CXlTcFmdO83MrfeNT6hnpto/tRYNB0?=
 =?iso-8859-1?Q?PV0KkD6Hv85YA5p/0f2FXpV3DEO7JuDTGvOhtt8X3IkCqzZvDzNTBJd5FE?=
 =?iso-8859-1?Q?oCC4MPpO2URVHbx/mZrqGWJQ2X6Axuc8NDfL14ONFXCQObGwdR+IzbBWuZ?=
 =?iso-8859-1?Q?xd1thNNfI8sJwolPEW7hDai/IcrVeZs/t1GfcSqYsc51lcia+ZIsi09IQv?=
 =?iso-8859-1?Q?/p+kWjmcKzr9S7+q818HQA0G8vdwXpFE4TXKueyjlybXicyWTra9CGRiEO?=
 =?iso-8859-1?Q?TbjFo/wVQb2Hp8pZMdgyoZ/dvZhbk1IvpCtIFxz5gWP2wrrL3OnZPzuMm+?=
 =?iso-8859-1?Q?U5t6pguqgYHnt/BbgFa39leWQscioWhrw7K5tRufZtACBTQn/6ljmnH613?=
 =?iso-8859-1?Q?MlsSjbqmFXuAbPItOEqazpA+7vki1ZgSloT9O4ntE1VCoKlPk9/6NEzlUh?=
 =?iso-8859-1?Q?abUJOSVhGf8HxLD1t7bSxeCAq6z9YKqi7K4AODQB04oD8pRymXpgUKeEuw?=
 =?iso-8859-1?Q?EhMSB1QuakEB3tUO01c5HzrtxGhpkMqiBEVSG8UJExyctCZTX30MDNandk?=
 =?iso-8859-1?Q?pgsrDp91je2C7ODZhkDFvG7mgp2pBnyiRw6s9KOiF6m57AvgzWOJpDBRpn?=
 =?iso-8859-1?Q?iVSPIqRcSBQ3ynVO8StDWpROsPFGSRjC27kEC7arXmyP58it2SU/mjN8BZ?=
 =?iso-8859-1?Q?EnFtPyTtfsaMrgKC7Lj2+dM0eijFEsqZAc5sjnwV3oksZEgI4YnCgsGbF3?=
 =?iso-8859-1?Q?/FQP9d3cgM53OGt90luC+0V4gTwM0j3IftkQ2z8NDmIB4GGGRKAXOGxjug?=
 =?iso-8859-1?Q?yaRwMy0qik0m8zqz6+VwRAk0GmMBgID1tD8F6Qu6Zl2YyvKTDyPM/ZTRh7?=
 =?iso-8859-1?Q?FjGXoayx4XxKoht/IbNdWYINpHoYuePp/20ibbDZz+AQiseOEqAIxkTAbh?=
 =?iso-8859-1?Q?KzbegWFazy1COxmQqzBzypuu73X9fnUsbItQPIRYQ3evhXyvPNJhHnWiDx?=
 =?iso-8859-1?Q?QKk0NR12ratfKTki0E6Yx4aQ40lN/rBfHmQVYL3RMO4VA885nl6h+8Ud1O?=
 =?iso-8859-1?Q?OYK9unn+WcHLJEjsUwbbVTsblcPtKUV33/lRm9l6v+8o8IhruW7E66QRGj?=
 =?iso-8859-1?Q?7HEw6GR1ls4xda55DqrKF9Ry57fvdjMhnEp/5vFwvBPwi3HfOKzVNawzUi?=
 =?iso-8859-1?Q?SOKfKnVQTWtI4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?iaImqlXQYlN6bzc90UBsnm48+zXcS/KN0fULZ7R3NHLalmsC6EybNyz3kd?=
 =?iso-8859-1?Q?6AzWhihOKg4q7195jArEWEed1JnfS5G/zBlcxsh9613JuGznrc+3ZACOxP?=
 =?iso-8859-1?Q?j5n+o3pRMDJosCqClSlzzm9kJElpEYVkNQujJw5s7VKlaE0JeoJ+dPZyCG?=
 =?iso-8859-1?Q?zuoYO7iUz33OjinqoHBDQ0S7q301/+S2IO0PCbpBRAL5ANfzv8klgf0XDS?=
 =?iso-8859-1?Q?bx9trqMcGpNN6VnmH1buYzvLbG8aNArk1eNFdEJkvUTW8xTzkZ3+Qq1wpj?=
 =?iso-8859-1?Q?a+UwxXIdK5g4RWxe4kIR7XTcqjWgk9kkh07ur/umZtT21k6t7Ygr2IAtDK?=
 =?iso-8859-1?Q?/nj0I3Esv23UhnGkvxfCH07LIRJrfQs0HN3c14a3W//wLAXRmnn7F5c7Kf?=
 =?iso-8859-1?Q?ZzNWVOwtEHAlTwTdsI4qhsHiwm0VpjJ+GSAjli8Y8CVQguzfVYQY1uQ6In?=
 =?iso-8859-1?Q?4a+aIO0/2BetVKPQ3IOKvrABPQlrvJ4+oWYgPjeZJ1f3y4qqlnLLDY7+3Y?=
 =?iso-8859-1?Q?5JsxyIASjKZr+OAwW7xakR+oXgAj/D8rTCyzpZlNfdqlpNwBgeaqiXp1O9?=
 =?iso-8859-1?Q?+tzhJSnwJYnfF4OztbETHMk+D+RFPPIj+vf+X3zlT6d/tj8NSkpE9P52cp?=
 =?iso-8859-1?Q?Q+3GA6D8OX8DZQu3NSEX680chliIuavt4gdOMdFRaYMGQ23s6TT2jeZlDq?=
 =?iso-8859-1?Q?OLlVv7OKzX3/v63BCc2E9LLQMguwDzuD7AptaLqrlx5AwOcBzmQjPHyg3j?=
 =?iso-8859-1?Q?5Qi9yAkCbB4aqfy3Bfe6s9O6dc44F/bILZ1dk92L+vl0WzwK9+OsxPvpm8?=
 =?iso-8859-1?Q?fvItjuNg/0cxRKf4CWvi3NlQTF/s6rZnkzLIDmcju7EPP2UbDUltZ9bQE4?=
 =?iso-8859-1?Q?5DhWStYdbDt0aiIk6HjghDgnk4TZmkfCnIpKZcBwQ2fZz+w7n78P73eLCl?=
 =?iso-8859-1?Q?OYqETtDbOsmO8868RxnRTa65a00nCHgFwZghnMr+k4x58twLl8LPjJyKxQ?=
 =?iso-8859-1?Q?8txj615K2n/myZaM3or83YK1NJu/or8DL4F8ZsG5wvAfsJ9kC30lPOP4BI?=
 =?iso-8859-1?Q?z991Kt3q0BjIdoNZPWy2xhRewoyb60wnHFL6Hud6Gsv5f6B7qhz1a08KTn?=
 =?iso-8859-1?Q?rGEyn26jKZuOqNMuq4cl3Ae4C2siUmXhweoPG/bHr/5rTqKpEUeKQx6SDQ?=
 =?iso-8859-1?Q?l4AFmC+c466bNgavtJeCUYAjSAXEzfpRk8v1KsUmKoD3811m4Zw9I/qa+m?=
 =?iso-8859-1?Q?3vJGEJJoGK72hFz9K11Y5NLs7ua79DIeYLqaDkQFXr/TEt1PUOx0huqCzx?=
 =?iso-8859-1?Q?KYJUIx8DpdYJ7T+XIlaDdfdSAABbzn3g262V287PSzSfHiW31UqIVgKvEN?=
 =?iso-8859-1?Q?1neDwoG6Sbc+CA6cMMWgw/U9loMthZJWTwjVJuI9DFzKJOXFfiV8GpW2B7?=
 =?iso-8859-1?Q?x99iK24/1TtWyVf7VbHdrXGinkCHZc2QaKe8i2Pu9QIKIXQ+mk0PyVufL5?=
 =?iso-8859-1?Q?YO+BhDbE9dR8a7C6vf07WzSgq03wYwB1hcmVHWeBnK6verBwl8/Vx9VbQ2?=
 =?iso-8859-1?Q?tTd/UgA1zY2XF7UBWKsjVayNB02hV+mAUbWPrzeKCNH1I0FY3zd/4lXuQY?=
 =?iso-8859-1?Q?BdTCSRpsMlAnXSRltXtS5b5Q/wMPxnQqMz3VVSPyk7XsxVVbDy7Tz6qNAy?=
 =?iso-8859-1?Q?14Yi0he/IVGd/EMhVhOETjKinGLtFmAlmGOHOf0tbhpRF240wwyL3yhU7N?=
 =?iso-8859-1?Q?AFv+L37PBoGrDeX+LwDGovZmWoDI35RldYrxpSyUyQ42eCyr5h5O1GMvla?=
 =?iso-8859-1?Q?g2Tg6w9S6w=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e1d823cb-8be1-4eed-eca5-08de57229474
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2026 06:18:36.5953
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D1GQO6jX6MHCWWhhOO1QoZAubnk340jUSGITfgKyCcN9JWbb/yNgYZT5tuOfhhVt5OWa5IQr/fp1p2obGSGf4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4992
X-OriginatorOrg: intel.com

On Fri, Jan 16, 2026 at 07:10:05PM +0800, Huang, Kai wrote:
> On Fri, 2026-01-16 at 16:35 +0800, Yan Zhao wrote:
> > Hi Kai,
> > Thanks for reviewing!
> > 
> > On Fri, Jan 16, 2026 at 09:00:29AM +0800, Huang, Kai wrote:
> > > 
> > > > 
> > > > Enable tdh_mem_page_demote() only on TDX modules that support feature
> > > > TDX_FEATURES0.ENHANCE_DEMOTE_INTERRUPTIBILITY, which does not return error
> > > > TDX_INTERRUPTED_RESTARTABLE on basic TDX (i.e., without TD partition) [2].
> > > > 
> > > > This is because error TDX_INTERRUPTED_RESTARTABLE is difficult to handle.
> > > > The TDX module provides no guaranteed maximum retry count to ensure forward
> > > > progress of the demotion. Interrupt storms could then result in a DoS if
> > > > host simply retries endlessly for TDX_INTERRUPTED_RESTARTABLE. Disabling
> > > > interrupts before invoking the SEAMCALL also doesn't work because NMIs can
> > > > also trigger TDX_INTERRUPTED_RESTARTABLE. Therefore, the tradeoff for basic
> > > > TDX is to disable the TDX_INTERRUPTED_RESTARTABLE error given the
> > > > reasonable execution time for demotion. [1]
> > > > 
> > > 
> > > [...]
> > > 
> > > > v3:
> > > > - Use a var name that clearly tell that the page is used as a page table
> > > >   page. (Binbin).
> > > > - Check if TDX module supports feature ENHANCE_DEMOTE_INTERRUPTIBILITY.
> > > >   (Kai).
> > > > 
> > > [...]
> > > 
> > > > +u64 tdh_mem_page_demote(struct tdx_td *td, u64 gpa, int level, struct page *new_sept_page,
> > > > +			u64 *ext_err1, u64 *ext_err2)
> > > > +{
> > > > +	struct tdx_module_args args = {
> > > > +		.rcx = gpa | level,
> > > > +		.rdx = tdx_tdr_pa(td),
> > > > +		.r8 = page_to_phys(new_sept_page),
> > > > +	};
> > > > +	u64 ret;
> > > > +
> > > > +	if (!tdx_supports_demote_nointerrupt(&tdx_sysinfo))
> > > > +		return TDX_SW_ERROR;
> > > > 
> > > 
> > > For the record, while I replied my suggestion [*] to this patch in v2, it
> > > was basically because the discussion was already in that patch -- I didn't
> > > mean to do this check inside tdh_mem_page_demote(), but do this check in
> > > KVM page fault patch and return 4K as maximum mapping level.
> > > 
> > > The precise words were:
> > > 
> > >   So if the decision is to not use 2M page when TDH_MEM_PAGE_DEMOTE can 
> > >   return TDX_INTERRUPTED_RESTARTABLE, maybe we can just check this 
> > >   enumeration in fault handler and always make mapping level as 4K?
> > Right. I followed it in the last patch (patch 24).
> > 
> > > Looking at this series, this is eventually done in your last patch.  But I
> > > don't quite understand what's the additional value of doing such check and
> > > return TDX_SW_ERROR in this SEAMCALL wrapper.
> > > 
> > > Currently in this series, it doesn't matter whether this wrapper returns
> > > TDX_SW_ERROR or the real TDX_INTERRUPTED_RESTARTABLE -- KVM terminates the
> > > TD anyway (see your patch 8) because this is unexpected as checked in your
> > > last patch.
> > > 
> > > IMHO we should get rid of this check in this low level wrapper.
> > You are right, the wrapper shouldn't hit this error after the last patch.
> > 
> > However, I found it's better to introduce the feature bit
> > TDX_FEATURES0_ENHANCE_DEMOTE_INTERRUPTIBILITY and the helper
> > tdx_supports_demote_nointerrupt() together with the demote SEAMCALL wrapper.
> > This way, people can understand how the TDX_INTERRUPTED_RESTARTABLE error is
> > handled for this SEAMCALL. 
> > 
> 
> So the "handling" here is basically making DEMOTE SEAMCALL unavailable
> when DEMOTE is interruptible at low SEAMCALL wrapper level.
> 
> I guess you can argue this has some value since it tells users "don't even
> try to call me when I am interruptible because I am not available".  
Right. The caller can understand the API usage by examining the code
implementation.

> However, IMHO this also implies the benefit is mostly for the case where
> the user wants to use this wrapper to tell whether DEMOTE is available. 
> E.g.,
> 
> 	err = tdh_mem_page_demote(...);
> 	if (err == TDX_SW_ERROR)
> 		enable_tdx_hugepage = false;
This use case is not valid.
When the caller invokes tdh_mem_page_demote(), it means huge pages have already
been enabled, so turning huge pages off on error from splitting huge pages is
self-contradictory.

> But in this series you are using tdx_supports_demote_nointerrupt() for
> this purpose, which is better IMHO.
> 
> So maybe there's a *theoretical* value to have the check here, but I don't
> see any *real* value.
> 
> But I don't have strong opinion either -- I guess I just don't like making
> these low level SEAMCALL wrappers more complicated than what the SEAMCALL
> does -- and it's up to you to decide. :-)
Thanks. I added the checking in the SEAMCALL wrapper for two reasons:
- Let the callers know what the wrapper is expected to work under. So, the
  caller (e.g., KVM) can turn off huge pages upon detecting an incompatible TDX
  module. And forgetting to turn off huge pages would yield at least a WARNING.

- Give tdx_supports_demote_nointerrupt() a user in this patch which introduces
  the helper.

So, I'll keep the check unless someone has a strong opinion :)

> > What do you think about changing it to a WARN_ON_ONCE()? i.e.,
> > WARN_ON_ONCE(!tdx_supports_demote_nointerrupt(&tdx_sysinfo));
> 
> What's your intention?
Hmm, either TDX_SW_ERROR or WARN_ON_ONCE() is fine with me.

I've asked about it in [1]. Let's wait for the maintainers' reply.

[1] https://lore.kernel.org/all/aW3G6yZuvclYABzP@yzhao56-desk.sh.intel.com

> W/o the WARN(), the caller _can_ call this wrapper (i.e., not a kernel
> bug) but it always get a SW-defined error.  Again, maybe it has value for
> the case where the caller wants to use this to tell whether DEMOTE is
> available.
> 
> With the WARN(), it's a kernel bug to call the wrapper, and the caller
> needs to use other way (i.e., tdx_supports_demote_nointerrupt()) to tell
> whether DEMOTE is available.
> 
> So if you want the check, probably WARN() is a better idea since I suppose
> we always want users to use tdx_supports_demote_nointerrupt() to know
> whether DEMOTE can be done, and the WARN() is just to catch bug.
Agreed.

