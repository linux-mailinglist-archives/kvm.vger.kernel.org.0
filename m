Return-Path: <kvm+bounces-70723-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AMnOIYMPi2l/PQAAu9opvQ
	(envelope-from <kvm+bounces-70723-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 11:59:15 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E89FF119E83
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 11:59:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3D721306147A
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 10:57:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 768AB35CB9A;
	Tue, 10 Feb 2026 10:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AeLq0rDo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D8DA35E52C;
	Tue, 10 Feb 2026 10:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770721044; cv=fail; b=enkemNvKe5RfwIa0Kqu6ffqfzQ4pNUCU3oj2msklrOp9DOtqOB3LRkKqX6WeAVdj/BBWSfpX34fuvP+sndPXeqC3nxHKtjvCKTHiLrc/Ds1xTBuM9k+A6Htp6kjUl+IrdfWdJlq20uinfNqNMxCSr5Ag4MuJMKfyR06NVFWdMBY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770721044; c=relaxed/simple;
	bh=TxKwWL64e19FEfmmk39fpDs7/kyRDSZHURV7ngSbK7Y=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Mf0z4g5QAeVLiV8rRpoK8dAdTeRGPZXU73u382bgPcYYFB+i/SeomVq1pk7LBZcO8EwlDbzZVKZ2oo0YWEqs1nMb0HUYBjg+UYlLV9iBJP/Z1ETAQn7beWnd8CpB4MUaqgBGyJmSMBCDrajpxOpP/K9M/FcqwpK4BYacCCzf4EI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AeLq0rDo; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770721042; x=1802257042;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=TxKwWL64e19FEfmmk39fpDs7/kyRDSZHURV7ngSbK7Y=;
  b=AeLq0rDof8pM7ZfoOwZ2jBdEVdzyOciM8txRzKfUQiexHclFNWSRBcOO
   ZGpPrBSN89jBiAAFqV36mh4okLqCI/8rdg1FvctBiskG7uKhld581IDaV
   bYhM0XMRV5clGq6d6VUADP4OYh5sItekJdp8tFYwWedbInQLQbnYYQmVW
   WfvqEJW4ION+N7eshSN5t7LzmDxO6ycJ96iUbFrwYxAsNICEnldnl41gg
   j17ijzw8ZiCAbzyL6EAPfJR5zlKfs4E2K9HyvzQI2f6QL1X5viHNMJI+0
   PuDWEMQLr9jlIPhukWr8TasL4W2Yk+H+O5y+vrfRGleKit2SDuBcuNXKG
   Q==;
X-CSE-ConnectionGUID: KuGp/b5JRXCwk6Y7XbQVmw==
X-CSE-MsgGUID: VzjU5A2rQmSU2oCSac+/zw==
X-IronPort-AV: E=McAfee;i="6800,10657,11696"; a="82951694"
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="82951694"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2026 02:57:21 -0800
X-CSE-ConnectionGUID: Aja7FKi7Rsmt26vwcvM0KQ==
X-CSE-MsgGUID: CSroHWBsRH6wFyoD1t8GOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="216421419"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2026 02:57:21 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 10 Feb 2026 02:57:20 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 10 Feb 2026 02:57:20 -0800
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.21) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 10 Feb 2026 02:57:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DuzhXP1joTVSFFLwfbVHqaGxjezL33k5m4vttVzx0dA/tpZco/F5S9hcSVqPrv4noTA5trxV3SrujSl4Gd2sd723tjVaL2tGjj0VGZ9EQje+qNhnvOPT9jBUSpNhp6lucnzgxbPc7B/wwTDHxWTLs/X97I6X5yhw17hqxxsR/GHQ+GG4cLWH+UTsnB5qPPdSlu7oiVh8kFkY2olqS1Gj6mk4QsyWmk7mXa7INsmiqJfeUP8GlryH+ZNWJSYQ0IXKh2Hl5HgrSMsHr2b5oqiBjmpfrRYmutWvrqrHmyikXWhSf4bvIx2SzDW99KrZ18ApXTp3lJIeQAPjog3uMTkw0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vAgXjuVJcfnzZ3N6veTSUr1pxyM3RVo6dMZN4tI9Kp8=;
 b=iwz/MygNqk5kDzxgsPdJijytDuiSpgNMZN6mRlOn2e98iPVr+wF4lF6ZWXYtc8YArAKseoZMWtA6DvCCwjgkh6kUrefByENm33bExkk/fBZ7/EaUqd+joybg8lfdfj4swQkttriobxRoBQbCHfWA/teNddMqvdBKLpJ1p8ujd98lUTjJWI0nYnAvBEdAFgAXwRkq0yj4Mp0G6qhpJDlR1UAt0IBDBJJfVHjTHubrKDlFzWW9LZLOaZXNJG+7zj7LrpvCxy2jk2bBeFe9xKY6QAvRlTRmPJJtYalkZC0EUeF6Wz7nVy5YnQAKhpH6gF0GwOxpCTz+UB8glt0epEh+4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB5887.namprd11.prod.outlook.com (2603:10b6:510:136::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.19; Tue, 10 Feb
 2026 10:57:11 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9587.010; Tue, 10 Feb 2026
 10:57:11 +0000
Date: Tue, 10 Feb 2026 18:54:15 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, Paolo Bonzini
	<pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>, Kai Huang
	<kai.huang@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, "Vishal
 Annapurve" <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>,
	Sagi Shahar <sagis@google.com>, Binbin Wu <binbin.wu@linux.intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Subject: Re: [RFC PATCH v5 08/45] KVM: x86/mmu: Propagate mirror SPTE removal
 to S-EPT in handle_changed_spte()
Message-ID: <aYsOV7Q5FTWo+6/x@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260129011517.3545883-1-seanjc@google.com>
 <20260129011517.3545883-9-seanjc@google.com>
 <aYMMHVvwDjZ7Lz9l@yzhao56-desk.sh.intel.com>
 <aYP_Ko3FGRriGXWR@google.com>
 <aYQtIK/Lq5T3ad6V@yzhao56-desk.sh.intel.com>
 <aYUarHf3KEwHGuJe@google.com>
 <aYVPN5M7QQwu/r/n@yzhao56-desk.sh.intel.com>
 <aYYn0nf2cayYu8e7@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aYYn0nf2cayYu8e7@google.com>
X-ClientProxiedBy: SI2PR02CA0041.apcprd02.prod.outlook.com
 (2603:1096:4:196::20) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB5887:EE_
X-MS-Office365-Filtering-Correlation-Id: bc69f3ed-422a-4d33-0241-08de689323fa
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?PtyNn0kzJF+r6/3VW1C1xxj8BdHxfr81aM27J9RsVNGRap/3aAhznA8YM4uB?=
 =?us-ascii?Q?ZJJq7JAU7afQwU/Fj4JYY33dFal+jpWa9kWmfEa8KoIllzeT089oIgvL/3Qg?=
 =?us-ascii?Q?R9KLIUkq2w+ivCIW4i4mbOVJg837jrkLZj9iL4+vvCi//qI4SVRj/9/Slk7n?=
 =?us-ascii?Q?Dp7fDvji8vPYM0rV9phtFtmUbubK9vlS+He8ko1gTmZvMKLP5P+Rn0L3/MrR?=
 =?us-ascii?Q?KAz7UNotoIyYovOmrkbzb7rS2j6vn59vzn/9Y3+3bsoW6Zm3VXA9TLcVa5YQ?=
 =?us-ascii?Q?NOI0zgJDfPvDE9On42iatdYxZU1Lyx19wPmYJ9hPsXiTd8xBViTeVwbDMMdO?=
 =?us-ascii?Q?/UvrRoSP8AeVUjKrouBvhwy9HzuV2F2UbYlp5gNW1wRXCTBZMiCA7jW8CbBP?=
 =?us-ascii?Q?4tZ8kn3AX0mclxRYq3N3dE+16sJom8etrK6QWYSvJgSay5VLnyiQYTAI4PPb?=
 =?us-ascii?Q?XELjHw+lvi0BXN94hqYsp54ywhLgMpYjRpf65TpNOpuM/uGiFhrGZ6+mEpAw?=
 =?us-ascii?Q?IfGMg3K+Xwkqgxzmvnn6F8eOEFb/kNWs0jmgIXXoCvGGcUcg1sVp7Lv7Su1N?=
 =?us-ascii?Q?pxSFx/wdyXoLqv6Eu7p+Omf3hGhiR8IqJQrkbPXaE29bDemBEMQwkoefVPpb?=
 =?us-ascii?Q?CgjkI6j+8Sv0L4XtuO09B5umEcsFZ0RL40ij37avKdpvHvYlaj3HGqpn0u6/?=
 =?us-ascii?Q?rXeIYqJIB+dguSSxV1bFWmAHCf80hZU/MVjazlCyzGeeJOf8T0LbNIcNYXZs?=
 =?us-ascii?Q?9aLwNdJzMSIcMFn96FSOhTG/tDWZrFobIpOn0934ccM/5bsMjbB32B+C9JcY?=
 =?us-ascii?Q?R8XxkQdiwrVqf+ql6VHKxZQDlj9RCdrURluODclg3QBTBeJJW5TqFp0D5hJ8?=
 =?us-ascii?Q?bsYE2+NkA30wsPa5Egoc3LuqRx6O83wL5KlPE+orPeLrGjiSdFsPrjYYihAK?=
 =?us-ascii?Q?ualfqGQNTYNegMwl29J7EEsZNSdjltKll68VvOZoYv+kbnr0rKEVfB35S8/A?=
 =?us-ascii?Q?PsMBhWKRFLeFhVhvVLNoC4SCsrOIXjoGIIyfymM6P75iXvlDck3Ju+qDVkW/?=
 =?us-ascii?Q?LGwQrGUgqOLFnhzlrT6rWMHv0gERViBVk1eGQji7A+Dj3yxmzH7NURjoS685?=
 =?us-ascii?Q?FO1Fh2WsplonSBYlsin/MTK5DlLGl0kEX09NYYT7JgOtWcNdcwIm0tbcIVnr?=
 =?us-ascii?Q?vcfCoj++nLwromXX4cdcpfEefAiN/PgAWcUngXabJ1yymtAv+w59eG5s1Z2P?=
 =?us-ascii?Q?VBJrb+m1xmu1oEB9teR8qLQD6fky0/mPf7gaVqQ7LNzR2sTSfbb5xRnCErDj?=
 =?us-ascii?Q?ls6RzkpyW6MLhwYfq5+6Dxzb2/UGTSMlf0UL2gbEWFg4jS4PH+H/SiaFEVMr?=
 =?us-ascii?Q?0JI1qG2yTOALUMkkLrPYClNv437QhuChhrM2CTKKyIu1Um0y7pGlxUclcwnl?=
 =?us-ascii?Q?KN3zPeO+O7yEgvzQdj/+V5UoFmhJa5Db0iEWMCF5IcA0H6lMj0OpkIa+Yid1?=
 =?us-ascii?Q?q74IAvwvy/ApuGP7e4MVa1P1Krw0o8ghcGBKKozAsXq5+snRLavEhOGj0JPI?=
 =?us-ascii?Q?eivpbjWDTCuSYJp5fNc=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LNkEG3RKB6gJK9d0qAxx8mYnJ1w5gqVszxPZaAQzhL09303Zk4kasdRY6HUU?=
 =?us-ascii?Q?ClHX1lZgjEKjoiro7e+9RSzAH3tMp5lSTOTUvyfXS3sA3AjLqNCWwksvYX/4?=
 =?us-ascii?Q?EMUB+MYmfa6lU7iM7sZXqjjSI+yMAw6R1YNi8bvyQnVnjdT8WqXsSMGQkRLM?=
 =?us-ascii?Q?Dp+B2q/oj7z9klo0umd1ezaDYEBbyi0iDMdsq1wS03oU30X8fA11Og9kBmce?=
 =?us-ascii?Q?nm7DQX8XjkAhPE1yFwNdODojcjHvOglstbv0B4mW1G5BTwD2pNA9tnm3IHi0?=
 =?us-ascii?Q?5eDduN0k+8g7cWYVH71RVKIX4N8bUz3yo30ZJ2W8kYsYsk1ctu6iu6/5gtq6?=
 =?us-ascii?Q?u16TgTT7iN9GdUWittll2oef6wJsyK95cHA9YVZrZ0r+ZQnIIJ754Qj+ruIl?=
 =?us-ascii?Q?6rJftdnvxC7IswGvSx9nzd4ZqrhmNMxY+PUGcf5f5r8C5x88fkDV/D6ngj1Y?=
 =?us-ascii?Q?Ug5nkDl9K/QEUO1/xsDOQWJkqKKZn9+yVCGZM8nblBuUe4RGf0nF+DO8kFkM?=
 =?us-ascii?Q?DLIhvPegaXwHx7mU5XfW895X3UxfsY0VEjNNvnLJBKStquyQPIyWhmdjIumW?=
 =?us-ascii?Q?o6nB8ondUlEGKo9ichSJg9cMCgSKTM4MvhTS/UTDm48r/tORwDXq+XYWlEs0?=
 =?us-ascii?Q?toeKLizTDKg2/aKlCBgTXwcLyrE7+YOU/6jNoBp3JRAmSoMNe9xjEv8HNXDu?=
 =?us-ascii?Q?0XCJfCwLm5utvf71wcsLPt/t605zQfciJQDKw9XEC+Gh4GF5CuVmny+at1t7?=
 =?us-ascii?Q?uyqPtaURyeVC/ZSkPFDtrHblk3DIQvEX8BYv2XSXOkcXjdDwdxlnKddxljjO?=
 =?us-ascii?Q?Qvye/mz+WASX3y6/GEE7HcdDGL6qQ2DtF/o9njLkERw60KnBPbYWbU3czvuW?=
 =?us-ascii?Q?VvKWka1pHguSNx8ce+fEK7YQJXa8nlJ+vMQnGIdsAGNlFbMpRnc7f58YDQh2?=
 =?us-ascii?Q?VcZIixyK7cJUBuQg53vb38yoF5umXCjOxMvJN9YWzSiU5jJvadUzFOK3VJOh?=
 =?us-ascii?Q?ve+D6oBQ2lgAENl6s4YPjNxl+6yRbvGgHRurmeZwIJr/boJ5fP5wPuVNFrqM?=
 =?us-ascii?Q?qqTRW5uvz8dr+lPDCPyp5S2USeyi1gsp8kf8flxr5NyUh0CExSdshuy0psac?=
 =?us-ascii?Q?RuzukJ7fQOCPMAYu7bKQfxqTQKTsOoKjBcEFcBavABHnpUhDtyRLkRL5Po+8?=
 =?us-ascii?Q?hKtPhxeXCNz+ididkVqZXfX2MTTIy96Lwf/hsilf7NVrIy+amk7YHoMO53aC?=
 =?us-ascii?Q?Lve2x8qaCrqi526mck+Dbz0L7N2+Fr9812yzgMwAHMFOotkV1GgZukuQs2e+?=
 =?us-ascii?Q?Xv84yYdh9GNKSNWRZ2QLi5449tNn9OctvevhF2rE5vyciHAR8+tiB1058d1R?=
 =?us-ascii?Q?m9wPHS5d3WZvPkZojdsfmeb1X/6/vb58HaalLG63xdJx5637JjOTl3BUYTIE?=
 =?us-ascii?Q?nYtTdaBp+Nwqf0I1Zf7G2cnew8suGoCMGPG9QoCR69C/WZ4g6GuCO1qKRjqk?=
 =?us-ascii?Q?b6wMSDiYNTmB9A+3qQ5iSUHSj4C6wZ4njIZ9Sfb9ZBpKOAYOYGtAXktrcKm1?=
 =?us-ascii?Q?oYKjivWmG8BD3CiHkeNbh+4Mwgv0Nl+lQkFjhdbnX2rYepA0pZh1iYRXomGD?=
 =?us-ascii?Q?RWGKBRBdhk9I1SjQ8un+JVsf2DV0RPA/NDahbZnGa/y3KenXJpFIzhaOCpd9?=
 =?us-ascii?Q?T8ZPy8rFqyibQeCGCjS2FfkwGelKzZRvLQsWAe2EskEnZWL+Eaj17rE+YgBV?=
 =?us-ascii?Q?6ERG2zDZSQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bc69f3ed-422a-4d33-0241-08de689323fa
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2026 10:57:10.9890
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UXFjAWSkb3T30POYVDZ8ItdAUN2xUQaT+99sgddfuPJtXzDov9/V0QAIcm3OW243nkRZULHXJauBB0Ria24Pjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5887
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
	TAGGED_FROM(0.00)[bounces-70723-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[10];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	HAS_REPLYTO(0.00)[yan.y.zhao@intel.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yan.y.zhao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:replyto,intel.com:dkim,yzhao56-desk.sh.intel.com:mid];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: E89FF119E83
X-Rspamd-Action: no action

On Fri, Feb 06, 2026 at 09:41:38AM -0800, Sean Christopherson wrote:
> On Fri, Feb 06, 2026, Yan Zhao wrote:
> > On Thu, Feb 05, 2026 at 02:33:16PM -0800, Sean Christopherson wrote:
> > > On Thu, Feb 05, 2026, Yan Zhao wrote:
> > > > > > >  	if (was_present && !was_leaf &&
> > > > > > >  	    (is_leaf || !is_present || WARN_ON_ONCE(pfn_changed)))
> > > > > > >  		handle_removed_pt(kvm, spte_to_child_pt(old_spte, level), shared);
> > > > > > > +	else if (was_leaf && is_mirror_sptep(sptep) && !is_leaf)
> > > > > > Should we check !is_present instead of !is_leaf?
> > > > > > e.g. a transition from a present leaf entry to a present non-leaf entry could
> > > > > > also trigger this if case.
> > > > > 
> > > > > No, the !is_leaf check is very intentional.  At this point in the series, S-EPT
> > > > > doesn't support hugepages.  If KVM manages to install a leaf SPTE and replaces
> > > > > that SPTE with a non-leaf SPTE, then we absolutely want the KVM_BUG_ON() in
> > > > > tdx_sept_remove_private_spte() to fire:
> > > > > 
> > > > > 	/* TODO: handle large pages. */
> > > > > 	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
> > > > > 		return -EIO;
> > > > But the op is named remove_external_spte().
> > > > And the check of "level != PG_LEVEL_4K" is for removing large leaf entries.
> > > 
> > > I agree that the naming at this point in the series is unfortunate, but I don't
> > > see it as outright wrong.  That the TDP MMU could theoretically replace the leaf
> > > SPTE with a non-leaf SPTE doesn't change the fact that the old leaf SPTE *is*
> > > being removed.
> > Hmm, I can't agree with that. But I won't insist if you think it's ok :)
> 
> If the code is read through a TDX lens, then I agree, it's seems wrong.  Because
> then you *know* that TDX doesn't support back-to-back remove()=>add() operations
> to handle a page split.
> 
> But from a TDP MMU perspective, this is entirely logical (ignoring that
> link_external_spt() is gone at this point in the series).
> 
> 	else if (was_leaf && is_mirror_sptep(sptep) && !is_leaf) {
> 		kvm_x86_call(remove_external_spte)(kvm, gfn, level, old_spte);
> 
> 		/*
> 		 * Link the new page table if a hugepage is being split, i.e.
> 		 * if a leaf SPTE is being replaced with a non-leaf SPTE.
> 		 */
> 		if (is_present)
> 			kvm_x86_call(link_external_spt)(kvm, gfn, level, ...);
> 	}
>
> And that is *exactly* why I want to get rid of the hyper-specific kvm_x86_ops
> hooks.  They bleed all kinds of implementation details all over the TDP MMU, which
> makes it difficult to read and understand the relevant TDP MMU code if you don't
> already know the TDX rules.  And I absolutely do not want to effectively require
> others to understand TDX's rules to be able to make changes to the TDP MMU.
Ok. I can understand your reasoning of checking !is_leaf now.
Thanks for the explanation!

Though I still think checking !is_present before calling op remove_external_spte()
in this patch is better, I have no strong opinion :)

... 
> Nope, as above, 100% the opposite.  Over ~3 patches, e.g.
> 
>  1. Drop the KVM_BUG_ON()s or move them to TDX
>  2. Morph the !is_frozen_spte() check into a KVM_MMU_WARN_ON()
>  3. Rework the code to rely on __handle_changed_spte() to propagate writes to S-EPT
> 
> That way, the _only_ path that updates external SPTEs is this:
> 
> 	if (was_present && !was_leaf &&
> 	    (is_leaf || !is_present || WARN_ON_ONCE(pfn_changed)))
> 		handle_removed_pt(kvm, spte_to_child_pt(old_spte, level), shared);
> 	else if (is_mirror_sptep(sptep))
> 		return kvm_x86_call(set_external_spte)(kvm, gfn, old_spte,
> 						       new_spte, level);
> 
> which is fully aligned with handle_changed_spte()'s role for !mirror roots: it
> exists to react to changes (the sole exception to that being aging SPTEs, which
> is a special case).
> 
> Compile-tested only.
LGTM overall.

>  arch/x86/kvm/mmu/tdp_mmu.c | 118 ++++++++++++++++++-------------------
>  1 file changed, 59 insertions(+), 59 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 847f2fcb6740..33a321aedac0 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -464,7 +464,7 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
>  }
>  
>  /**
> - * handle_changed_spte - handle bookkeeping associated with an SPTE change
> + * __handle_changed_spte - handle bookkeeping associated with an SPTE change
>   * @kvm: kvm instance
>   * @as_id: the address space of the paging structure the SPTE was a part of
>   * @sptep: pointer to the SPTE
> @@ -480,9 +480,9 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
>   * dirty logging updates are handled in common code, not here (see make_spte()
>   * and fast_pf_fix_direct_spte()).
>   */
> -static void handle_changed_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
> -				gfn_t gfn, u64 old_spte, u64 new_spte,
> -				int level, bool shared)
> +static int __handle_changed_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
> +				 gfn_t gfn, u64 old_spte, u64 new_spte,
> +				 int level, bool shared)
>  {
>  	bool was_present = is_shadow_present_pte(old_spte);
>  	bool is_present = is_shadow_present_pte(new_spte);
> @@ -518,7 +518,7 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
>  	}
>  
>  	if (old_spte == new_spte)
> -		return;
> +		return 0;
>  
>  	trace_kvm_tdp_mmu_spte_changed(as_id, gfn, level, old_spte, new_spte);
>  
> @@ -547,7 +547,7 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
>  			       "a temporary frozen SPTE.\n"
>  			       "as_id: %d gfn: %llx old_spte: %llx new_spte: %llx level: %d",
>  			       as_id, gfn, old_spte, new_spte, level);
> -		return;
> +		return 0;
>  	}
>  
>  	if (is_leaf != was_leaf)
> @@ -559,30 +559,31 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
>  	 * SPTE being converted to a hugepage (leaf) or being zapped.  Shadow
>  	 * pages are kernel allocations and should never be migrated.
>  	 *
> -	 * When modifying leaf entries in mirrored page tables, propagate the
> -	 * changes to the external SPTE.  Bug the VM on failure, as callers
> -	 * aren't prepared to handle errors, e.g. due to lock contention in the
> -	 * TDX-Module.  Note, changes to non-leaf mirror SPTEs are handled by
> -	 * handle_removed_pt() (the TDX-Module requires that child entries are
> -	 * removed before the parent SPTE), and changes to non-present mirror
> -	 * SPTEs are handled by __tdp_mmu_set_spte_atomic() (KVM needs to set
> -	 * the external SPTE while the mirror SPTE is frozen so that installing
> -	 * a new SPTE is effectively an atomic operation).
> +	 * When modifying leaf entries in mirrored page tables, propagate all
> +	 * changes to the external SPTE.
>  	 */
>  	if (was_present && !was_leaf &&
>  	    (is_leaf || !is_present || WARN_ON_ONCE(pfn_changed)))
>  		handle_removed_pt(kvm, spte_to_child_pt(old_spte, level), shared);
> -	else if (was_leaf && is_mirror_sptep(sptep))
> -		KVM_BUG_ON(kvm_x86_call(set_external_spte)(kvm, gfn, old_spte,
> -							   new_spte, level), kvm);
> +	else if (is_mirror_sptep(sptep))
> +		return kvm_x86_call(set_external_spte)(kvm, gfn, old_spte,
> +						       new_spte, level);
For TDX's future implementation of set_external_spte() for split splitting,
could we add a new param "bool shared" to op set_external_spte() in the
future? i.e.,
- when tdx_sept_split_private_spte() is invoked under write mmu_lock, it calls
  tdh_do_no_vcpus() to retry BUSY error, and TDX_BUG_ON_2() then.
- when tdx_sept_split_private_spte() is invoked under read mmu_lock
  (in the future when calling tdh_mem_range_block() in unnecessary), it could
  directly return BUSY to TDP MMU on contention.


> +	return 0;
> +}
> +
> +static void handle_changed_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
> +				gfn_t gfn, u64 old_spte, u64 new_spte,
> +				int level, bool shared)
> +{
Do we need "WARN_ON_ONCE(is_mirror_sptep(sptep) && shared)" here ? 

> +	KVM_BUG_ON(__handle_changed_spte(kvm, as_id, sptep, gfn, old_spte,
> +					 new_spte, level, shared), kvm);
>  }



>  
>  static inline int __must_check __tdp_mmu_set_spte_atomic(struct kvm *kvm,
>  							 struct tdp_iter *iter,
>  							 u64 new_spte)
>  {
> -	u64 *raw_sptep = rcu_dereference(iter->sptep);
> -
>  	/*
>  	 * The caller is responsible for ensuring the old SPTE is not a FROZEN
>  	 * SPTE.  KVM should never attempt to zap or manipulate a FROZEN SPTE,
> @@ -591,40 +592,6 @@ static inline int __must_check __tdp_mmu_set_spte_atomic(struct kvm *kvm,
>  	 */
>  	WARN_ON_ONCE(iter->yielded || is_frozen_spte(iter->old_spte));
>  
> -	if (is_mirror_sptep(iter->sptep) && !is_frozen_spte(new_spte)) {
> -		int ret;
> -
> -		/*
> -		 * KVM doesn't currently support zapping or splitting mirror
> -		 * SPTEs while holding mmu_lock for read.
> -		 */
> -		if (KVM_BUG_ON(is_shadow_present_pte(iter->old_spte), kvm) ||
> -		    KVM_BUG_ON(!is_shadow_present_pte(new_spte), kvm))
> -			return -EBUSY;
> -
> -		/*
> -		 * Temporarily freeze the SPTE until the external PTE operation
> -		 * has completed, e.g. so that concurrent faults don't attempt
> -		 * to install a child PTE in the external page table before the
> -		 * parent PTE has been written.
> -		 */
> -		if (!try_cmpxchg64(raw_sptep, &iter->old_spte, FROZEN_SPTE))
> -			return -EBUSY;
> -
> -		/*
> -		 * Update the external PTE.  On success, set the mirror SPTE to
> -		 * the desired value.  On failure, restore the old SPTE so that
> -		 * the SPTE isn't frozen in perpetuity.
> -		 */
> -		ret = kvm_x86_call(set_external_spte)(kvm, iter->gfn, iter->old_spte,
> -						      new_spte, iter->level);
> -		if (ret)
> -			__kvm_tdp_mmu_write_spte(iter->sptep, iter->old_spte);
> -		else
> -			__kvm_tdp_mmu_write_spte(iter->sptep, new_spte);
> -		return ret;
> -	}
> -
>  	/*
>  	 * Note, fast_pf_fix_direct_spte() can also modify TDP MMU SPTEs and
>  	 * does not hold the mmu_lock.  On failure, i.e. if a different logical
> @@ -632,7 +599,7 @@ static inline int __must_check __tdp_mmu_set_spte_atomic(struct kvm *kvm,
>  	 * the current value, so the caller operates on fresh data, e.g. if it
>  	 * retries tdp_mmu_set_spte_atomic()
>  	 */
> -	if (!try_cmpxchg64(raw_sptep, &iter->old_spte, new_spte))
> +	if (!try_cmpxchg64(rcu_dereference(iter->sptep), &iter->old_spte, new_spte))
>  		return -EBUSY;
>  
>  	return 0;
> @@ -663,14 +630,44 @@ static inline int __must_check tdp_mmu_set_spte_atomic(struct kvm *kvm,
>  
>  	lockdep_assert_held_read(&kvm->mmu_lock);
>  
> -	ret = __tdp_mmu_set_spte_atomic(kvm, iter, new_spte);
>
> +	/* KVM should never freeze SPTEs using higher level APIs. */
> +	KVM_MMU_WARN_ON(is_frozen_spte(new_spte));
What about
	KVM_MMU_WARN_ON(is_frozen_spte(new_spte) ||
			is_frozen_spte(iter->old_spte) || iter->yielded);

> +	/*
> +	  * Temporarily freeze the SPTE until the external PTE operation has
> +	  * completed (unless the new SPTE itself will be frozen), e.g. so that
> +	  * concurrent faults don't attempt to install a child PTE in the
> +	  * external page table before the parent PTE has been written, or try
> +	  * to re-install a page table before the old one was removed.
> +	  */
> +	if (is_mirror_sptep(iter->sptep))
> +		ret = __tdp_mmu_set_spte_atomic(kvm, iter, FROZEN_SPTE);
> +	else
> +		ret = __tdp_mmu_set_spte_atomic(kvm, iter, new_spte);
and invoking open code try_cmpxchg64() directly?

>  	if (ret)
>  		return ret;
>  
> -	handle_changed_spte(kvm, iter->as_id, iter->sptep, iter->gfn,
> -			    iter->old_spte, new_spte, iter->level, true);
> +	ret = __handle_changed_spte(kvm, iter->as_id, iter->sptep, iter->gfn,
> +				    iter->old_spte, new_spte, iter->level, true);
>  
> -	return 0;
> +	/*
> +	 * Unfreeze the mirror SPTE.  If updating the external SPTE failed,
> +	 * restore the old SPTE so that the SPTE isn't frozen in perpetuity,
> +	 * otherwise set the mirror SPTE to the new desired value.
> +	 */
> +	if (is_mirror_sptep(iter->sptep)) {
> +		if (ret)
> +			__kvm_tdp_mmu_write_spte(iter->sptep, iter->old_spte);
> +		else
> +			__kvm_tdp_mmu_write_spte(iter->sptep, new_spte);
> +	} else {
> +		/*
> +		 * Bug the VM if handling the change failed, as failure is only
> +		 * allowed if KVM couldn't update the external SPTE.
> +		 */
> +		KVM_BUG_ON(ret, kvm);
> +	}
> +	return ret;
>  }
One concern for tdp_mmu_set_spte_atomic() to handle mirror SPTEs:
- Previously
  1. set *iter->sptep to FROZEN_SPTE.
  2. kvm_x86_call(set_external_spte)(old_spte, new_spte)
  3. set *iter->sptep to new_spte

- Now with this diff
  1. set *iter->sptep to FROZEN_SPTE.
  2. __handle_changed_spte()
     --> kvm_x86_call(set_external_spte)(iter->sptep, old_spte, new_spte)
  3. set *iter->sptep to new_spte 

  what if __handle_changed_spte() reads *iter->sptep in step 2?
  Passing in "bool is_mirror_sp" to __handle_changed_spte() instead?



