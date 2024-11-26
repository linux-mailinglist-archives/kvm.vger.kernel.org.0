Return-Path: <kvm+bounces-32499-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E0909D9403
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 10:18:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E9CF28288D
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 09:18:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB6F41B412D;
	Tue, 26 Nov 2024 09:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i0JcRLPW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 235E77E9;
	Tue, 26 Nov 2024 09:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732612728; cv=fail; b=Ghb174QQEecRyjGYJD0ry5WpR0SS5eUIWx75BE0jJyyLwVZDrOmUB5a/rShwP3e7U8b72CgrX6fM/qSvtv0PF6+/TVbMsVrpav4ohHUWk0VDz9kUwtpVpRZ18t2LRlxIcr1gBiaMtBvIiBxwcqF4+i7r9xJka+id+BbgcqZ20eE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732612728; c=relaxed/simple;
	bh=DehYKRW8Dhfq2Zr1xAliJEQGvhBBkAKyS/h/KDLDiQE=;
	h=Date:From:To:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=c7kBuoz7QqaJ+XzoXrGLpJmVp9Y2rAqBYtexrlvQUr48skrvI27tlzbyzxE4AUvgcqCKE1lGzbMIggYtZr9iGaJmn0nUICrFTxMxhAMsaHbYFJOLFaGQoXTyiaCV276j9mT4IRnBdLFSVC/PpcWZGag0EnuQcNTl9ZJHros94oQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i0JcRLPW; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732612727; x=1764148727;
  h=date:from:to:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=DehYKRW8Dhfq2Zr1xAliJEQGvhBBkAKyS/h/KDLDiQE=;
  b=i0JcRLPWgoYvSpF2aVP6V933xfLZvyW2okl6zIPeJ85wxS/fNlWL8mpw
   d2QPyGidgltzbrohGtn0FHnM9np8DOKiaP+JyDoWpHUC1jLdO5A6NGFrQ
   fU1ceE30saS2UgK7Md7wI1CULJEw9rQ6n2TPmVvq6MqR2Jm54W/u1+9VW
   KJ1/9mrZwNVRJq/6OIaqgjCEwZDNkXuXkut+1XrWQnhHPLAA9EUa5IbhS
   wA6H2tPjAU5CNxbANKnVvCO0SoxqtqMopJ8cUkfphNN4THrARwWltIjO1
   VzJWaXW0Yc8bAeU9ZLxN/OUwHkbfdGEBDZBh0tqquq7HFioK0BVy1OqJZ
   A==;
X-CSE-ConnectionGUID: +y9Vx4kZSfGmzBgSDwyhwQ==
X-CSE-MsgGUID: cLWxklpfSRGw5x54xWrIew==
X-IronPort-AV: E=McAfee;i="6700,10204,11267"; a="55259852"
X-IronPort-AV: E=Sophos;i="6.12,185,1728975600"; 
   d="scan'208";a="55259852"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2024 01:18:46 -0800
X-CSE-ConnectionGUID: IBE+su8JSOydi+VI4xDcPw==
X-CSE-MsgGUID: uFq42HLbTeidt+byW0Cmdw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,185,1728975600"; 
   d="scan'208";a="95972862"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Nov 2024 01:18:45 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 26 Nov 2024 01:18:44 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 26 Nov 2024 01:18:44 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 26 Nov 2024 01:18:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hcN8t/yKqgSp3uuROS9LZxKhCowzYnBe73PKjrjXKhLja/Ob06Xz3PjEoueUyXtPjWgi602pkloKFrtJl941FDc9kf5+FBeg3IpmbDhbW7m3YWNb7bzh+8iXUe+06onWaqwMxSsj34EaboHeRRrAcYeJD6fy+jmGN2gju6vxs6jNVSIWixJXKKV0+OvK+NvhdsyUMqWYvKxnmP77pmnvQI7yFv45kDcIHdYib59QA5kxzTLygfpxdFMI9EfbqTi00kDVhnkYlTTF8gs6R+sz0msaFwfSZc+A/PA2w6Ne7sLT7wh+LJB4PgAwaxK7uLNRnE5BHAlu3p2eDGMIs0yATw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CPMt33gx0o2qLDiUiacP2GhluvMFQVnYPB2DBS3anPI=;
 b=XPosxeBQvKTFVHSai1hNZwd1M2G5CxdF8knd92N0MbeZTK9YFGgh++e9joBC1yhOQJOWAgGqUoIJWxCvsePZaBFK/KIYQ/s672sA1kejfUa1W7EECaMIwEVw08IMh3NWtINneuam6tfeR4JNInt4ZIG5cyQTt9taJiH0OOx+zJ3Qc4y9rcW+KRSoBkOSZkg36ib/1HhmUpFFsS16ATpRzxcFZW5OLa/8E8Sihv9g6grHPybR6OEwCZ+bLYn1jyjNpG3+Bfy4zrnLgc5FxWUiXXKRe8yGDhUbhv4r1EOjAYKjbMGD2L4k5Olcj4XsGMYOvemLwITd/H5ajV8CITaP2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA1PR11MB6846.namprd11.prod.outlook.com (2603:10b6:806:2b0::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8182.20; Tue, 26 Nov 2024 09:18:41 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8182.019; Tue, 26 Nov 2024
 09:18:41 +0000
Date: Tue, 26 Nov 2024 17:15:57 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>, <pbonzini@redhat.com>,
	<rick.p.edgecombe@intel.com>, <kai.huang@intel.com>,
	<isaku.yamahata@intel.com>, <dmatlack@google.com>, <sagis@google.com>,
	<erdemaktas@google.com>, <graf@amazon.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <alex.williamson@redhat.com>, <kevin.tian@intel.com>,
	<weijiang.yang@intel.com>
Subject: Re: [PATCH v2 1/4] KVM: x86/mmu: Introduce a quirk to control
 memslot zap behavior
Message-ID: <Z0WRzTrtVfi5vSlr@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240703020921.13855-1-yan.y.zhao@intel.com>
 <20240703021043.13881-1-yan.y.zhao@intel.com>
 <ZvG1Wki4GvIyVWqB@google.com>
 <ZvIOox8CncED/gSL@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZvIOox8CncED/gSL@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: SG2PR02CA0090.apcprd02.prod.outlook.com
 (2603:1096:4:90::30) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA1PR11MB6846:EE_
X-MS-Office365-Filtering-Correlation-Id: d6d8e8a9-7119-43d5-5a49-08dd0dfb514a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|921020;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?GqIMS71AWQGvawSts5oC94Af9NqDOkZAVmU2dB6M3/q0x0RoqdjkdrpkcIZ8?=
 =?us-ascii?Q?HFQqHPn+b0Ub4akkKiMeRt2kAV80WawguUrkrtbwNWqB4//0a34nl60v7UNP?=
 =?us-ascii?Q?/NKZ8N0KWPzrsBTdGNwLJ+wjvcN9a42jZiVgXQqe8C9VpimgbTgvZnb1CLmY?=
 =?us-ascii?Q?H0idt+zJdW7Lf4QKVQ6qLgArH86jaFxabElQ2NDXQ6WLzOo3ITfBXWFSo/kx?=
 =?us-ascii?Q?k56Kt9WyVzkRCKjTv60RCSq0L5jyhkIdv036o4+nEQdGV+Y3Re4xN7qqxcMh?=
 =?us-ascii?Q?31Lue0jXayW6GhQS/Qs8zP6g2t891UgX4DpbSQTHQIO4Jq42P3dMK+UC90uA?=
 =?us-ascii?Q?Z6cSIywQBN6eXIJ91O+b8sFFCPEAx6hpvZoTWhPV/utQ9/Zpjr1GRWwv2gC7?=
 =?us-ascii?Q?9U+nYUIDVUS9Lp/wZQbz8zRFYTk/OVH7evCTLESKYrYYs2ziZogTZIQ9Z994?=
 =?us-ascii?Q?4Ma0hVs0OR2k514r46aUPu2KD9bwWrSavbKIG+lY5+BfXZlRebfMEjKRU6DA?=
 =?us-ascii?Q?f5SPl+GX60CVs3PUdouMkgGnUnrgbOFL5hKkr8yn0TXjLpJISwxUafCaVRfE?=
 =?us-ascii?Q?Lr6ighru1c+Q0EAGOs8Xl9BsrNF6FS+WX03TBCBtOiv9OqmQnhL1IrYJRU8M?=
 =?us-ascii?Q?8onQGvRFQjnz9A5fB/EcNcBjHFeEFMFN6jJVXM0Vru8teCkg9o/JSkCD83A/?=
 =?us-ascii?Q?461RIYHZKHZEt3be+Hay9AVWF53QtWyQO929uHWXv/d4k6O4mhWLBsQC2QJT?=
 =?us-ascii?Q?WbhTv/jiS1VHEv4/pM3E4N0SmgDmYA02VAwfsKQEmtem660ybbNpdeORFcVW?=
 =?us-ascii?Q?oS3arE6LOTlGDrr1xuMh7PVCdg2gGgUBJStk70E6PO2kNm5Qrp/u5U1XIfj4?=
 =?us-ascii?Q?y/WYfzglRbWG4RAT26pG0Vf+7GnYoI6IwUGkPfekg7VMCNY0R8SCKy+NSkmh?=
 =?us-ascii?Q?wbYPpkvwUySwSWr1XIWYnDtKNy071IFEjo202Hn3YIIDXh3HRyfWQzQsz+5F?=
 =?us-ascii?Q?UCZ4s16EotTYPm6lnhl1KaPN/qeH/7ouquLrwNtYYUCso2AJJFSMta2wO3NL?=
 =?us-ascii?Q?WxUSKduTPZbHYTO+zfhu/CE1dElKXtYnoxix+XjbRNIWrHgI7mJLtJDSi+sj?=
 =?us-ascii?Q?l3cHi13CbIprpTyJ/wgELfSWEm8GGbxZAXx2McRNyGmxFxGvgsU2iFdB4wLH?=
 =?us-ascii?Q?ZGDHJ58pv9FVv5yw5Bii1mvC4f7+6ZBj3tMdLj/dQ4G+XN6aHKHgGgVZ7Mv6?=
 =?us-ascii?Q?BM9VG0xC1gRh+NrZ7Xj7+FOv7Ro128NinkBgwxflDa+W0lEpdFejRlk8fPIR?=
 =?us-ascii?Q?4XluiIu+1fbnkfN8ROPg0BCUpd/CSV5RU05128Mx4V6CaztTxkiUra4cDUt3?=
 =?us-ascii?Q?xNc9ko0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lL7XU3dBn6l2x6Ok8+Q0XRvU3bMG7S2Cx7c3aFIqf9IWAsDN64T0f//KHj+m?=
 =?us-ascii?Q?dcjrWN2w/MtID+yKusEFCG34hYKKtQ79yWcXtqD+soP2b/0Bl5klHYjSpTJN?=
 =?us-ascii?Q?TvfRpnvMm4cwvqnPJqkBjn9ebeJJvcPFEjviRDsHh9BSaB9Gv/G4BJx/mMrQ?=
 =?us-ascii?Q?9iK7FYBm8+OYcKnf+pqks90aHF0tp1nrDxtQcrR2lQteNYuto7edfhHfh20n?=
 =?us-ascii?Q?QR2ksF5wXfkYzpQGNFxiXvQdIUwvYtQ928bWRI6CnVTq/sjQ+xaH+veC0Mdw?=
 =?us-ascii?Q?Gk9r5HLYzRngQa6Q3SvsVqJut7ffH06z9FiYz+w94MS5bD/RBZOIWVAcewLg?=
 =?us-ascii?Q?CbMx+0LIu2AUwFIHZOq/qmO3mD/ubTKMRlM1vH2LpBJyHlhkagS3qRwB/8rs?=
 =?us-ascii?Q?3k5pCn6itjHNl4kCTH++6LBdZtkcdRxM6NTmbeHO4iTla235FdR74ka9x0rL?=
 =?us-ascii?Q?fDfrZoKMwbmCqlCBG4X0fcq5QLSFL/Yq4Rz82rc+5GS5a2Bh5JFTaHEu1Tq6?=
 =?us-ascii?Q?LnS0dKw2iy4bUbe0ntTZ+DiBL7RaTkFYj8Dg0G3T9boqp2ZlQB51bnW4PzKu?=
 =?us-ascii?Q?IH+zL03YGRTv9KPvwsyz40Izbndb5NxLj6p19lVjlazNHxK7Mugs/4idDWiM?=
 =?us-ascii?Q?oPUC1q8/vPY6h5kT809v2R0uv7l/2VV/rPQCCuESDE0GdxueNxAgJwntv5O7?=
 =?us-ascii?Q?bvSgQ9ASmrI4vHG3hejMeYhsbSAIRCicGDR8bVfV0n+3CcbKXyVpcEdgOwzM?=
 =?us-ascii?Q?/w/Gnmc3X0APNKZTFnY7JMIp2i6RnXdXNheWuuti2nntu2RFqVzaVf8k5DA3?=
 =?us-ascii?Q?DUFb3bE4ULPOUceHj0N93rp1pgVKkTdlze9ATaQeVK/BFYKlDHjsHfxrWbbj?=
 =?us-ascii?Q?pXRXPgt5jSM60dO14jEurGaL10wNSfL2PnTBrzEvENHIP7VJdp5pvIZX5F3Y?=
 =?us-ascii?Q?XGSigkTLY/vDsAVg5H2cUQ0ecojHOBBp5TsGFZLRccB2YExxaPKwvTHNpoiw?=
 =?us-ascii?Q?nccyvhVAWOvOzdvIJ7DzBLWDlrN96GtUSpoC5qDyRtg2XMBCGGlbbnBo+7eW?=
 =?us-ascii?Q?lfkrpteg03Y5LG/WZD1iL09Mji8YMv4CeEd3RNO5KUCVMTCan6cKS319yRSI?=
 =?us-ascii?Q?UZfVO1YtgxPjOs0uQJD0UQqww3QivSvOad4MHvwPqODaDPBBgN84irtgpq9C?=
 =?us-ascii?Q?8Y4XByqkaMoFS+S+R3CnkLpmCCI1LVoZSaR6bFSmun+sQrL6nlf2n5ft0O/s?=
 =?us-ascii?Q?4sDhuAOCLGfdJSRb+SL18kVs+bctbS3MkzKdVuUbju46EU45nXgTrgrUFcwE?=
 =?us-ascii?Q?C7XLKpUqkPPGEA1oqdfaTwzkYqsDqf8AstX+Z2QFXQpCtZDjSa8K/NW02xbE?=
 =?us-ascii?Q?cfmfW6WLCbaZWq962ViBfTOzoPFcVWQEmp5ircaSdYRPTk3ZulS+XbyR+d9f?=
 =?us-ascii?Q?mQrK0NcYiP6pxqdbarBF/QZE1HBcr7R1cMC0ESXlIYrdvRJVL/fQdb74pV6M?=
 =?us-ascii?Q?FcFT6SOKVuJ1jR4+wKnMiqslBPAj02dIZ7hAv6OlpUBC5DFIsUBJLxSayx9l?=
 =?us-ascii?Q?gHyZiM9t+DM1hziNCcd/CRckn5PpTvJXdrYzVhaY?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d6d8e8a9-7119-43d5-5a49-08dd0dfb514a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2024 09:18:41.0061
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FvF0oxnfWH67SwHFL1g5Kn+JcfN2ogfykxLlkVuhTQRjf6dcnzfj/cPuec9UQIy1akoMlP05agK19lveTIGceA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6846
X-OriginatorOrg: intel.com

> BTW: update some findings regarding to the previous bug with Nvidia GPU
> assignment:
> I found that after v5.19-rc1+, even with nx_huge_pages=N, the bug is not
> reproducible when only leaf entries of memslot are zapped.
> (no more detailed info due to limited time to debug).
+Alex, Weijiang, and Kevin

Some updates on the Nvidia GPU assignment issue.
Good news is that I may have identified the root cause of this issue.
However, given the root cause, I'm not 100% sure that the issue I observed is
the same one reported by Alex. So it still needs Alex's confirmation and help to
verify it in the original environment.

== My Environment ==
With the help from Weijiang, I'm able to reproduce the issue using
GeForce GT 640, on a KBL desktop.
Besides the GeForce GT 640 assigned to the guest, this KBL desktop has an Intel
IGD device, which is used by host OS.
The guest OS is win10. Guest workloads: a video player + furmark + passmark.

I can observe error patterns that are very similar to those described by Alex
at [1] on kernel tags before v5.19-rc1.
- I can observe the error patterns on kernel tag v5.3-rc4.
  (It uses the zap-only-memslot logic and Alex reported that this version was
   with this issue at [2]).
- From tag 5.3-rc6 to v5.19-rc1, zap-only-memslot was reverted.
  From tag v5.4-rc8, commit b8e8c8303ff2 ("kvm: mmu: ITLB_MULTIHIT mitigation")
  was introduced. (though if I directly checkout this commit, the kernel version
  is 5.4.0-rc6).
  I can reproduce the issue on those kernel versions by adding back and forcing
  the zap-only-memslot logic, and setting kvm.nx_huge_pages=N.
  (Previously Weijiang found out that with kvm.nx_huge_pages=Y, the issue was
   not reproducible [3]).
- If I switched back to zap-all in all those versions, the error pattens were
  not observable.

== Root Cause ==
It's found out that with commit fc0051cb9590 ("iommu/vt-d: Check domain
force_snooping against attached devices"), the issue was not reproducible.
(I only bisected kernel tags. This commit first appeared in tag v5.19-rc1.)

Further analysis (with Kevin's help) shows that after the commit fc0051cb9590
("iommu/vt-d: Check domain force_snooping against attached devices"), VFIO
always detected the NVidia GPU device as a coherent DMA device. Prior to that
commit, VFIO detected the NVidia GPU device as a non-coherent DMA device by
querying cache coherency from Intel IOMMU driver, which, however, incorrectly
returned fail if any IOMMU lacked snoop control support. 

As a result, if the machine had an Intel IGD device,
- on the Intel IOMMU driver side, it would not enforce snoop for the assigned
  NVidia GPU device in the IOMMU SLPT.
- on the KVM's side, KVM also found that kvm_arch_has_noncoherent_dma() was true
  and would emulate guest WBINVD.


In KVM's vmx_get_mt_mask(), with non-coherent DMA devices attached,
(using the code in tag v5.3-rc4 as an example):
- when guest CD=1 && kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED),
  the EPT memtype is MTRR_TYPE_WRBACK | VMX_EPT_IPAT_BIT;
- when CD=0, the EPT memtype is guest MTRR type (without VMX_EPT_IPAT_BIT).

static u64 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
{
        u8 cache;
        u64 ipat = 0;

        if (is_mmio) {
                cache = MTRR_TYPE_UNCACHABLE;
                goto exit;
        }

        if (!kvm_arch_has_noncoherent_dma(vcpu->kvm)) {
                ipat = VMX_EPT_IPAT_BIT;
                cache = MTRR_TYPE_WRBACK;
                goto exit;
        }

        if (kvm_read_cr0(vcpu) & X86_CR0_CD) {
                ipat = VMX_EPT_IPAT_BIT;
                if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
                        cache = MTRR_TYPE_WRBACK;
                else
                        cache = MTRR_TYPE_UNCACHABLE;
                goto exit;
        }

        cache = kvm_mtrr_get_guest_memory_type(vcpu, gfn);

exit:
        return (cache << VMX_EPT_MT_EPTE_SHIFT) | ipat;
}

However, with this vmx_get_mt_mask() implementation, KVM did not zap EPT on CD
toggling.
So if I applied patch[4], the error pattens previously observed were immediately
gone and the guest OS appeared quite stable.

Or if I changed vmx_get_mt_mask() as shown below, the issue was not reproducible
even if KVM did not zap EPT for CD toggling and update_mtrr().

static u64 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
{
        if (is_mmio)
                return MTRR_TYPE_UNCACHABLE << VMX_EPT_MT_EPTE_SHIFT;

        if (!kvm_arch_has_noncoherent_dma(vcpu->kvm))
                return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;

        return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT);
}


So, my conclusion is that the Nvidia GPU assignment issue was caused by the lack
of EPT zapping when the guest toggles CD. (The CD toggling occurs per-vCPU
during guest bootup for enabling guest MTRRs.)
The lack of EPT zapping was previously masked by the zap-all operations for
memslot deletions during guest bootup. However, the error became outstanding
when only memslot EPT entries were zapped. (The guest may have accessed a GPA
during CD=1 to create an EPT entry with a memtype no longer correct after CD=0).

The ITLB_MULTIHIT mitigation [3] splits non-executable huge pages in EPT to
create executable 4k pages. e.g., I can observe GFNs 0xa00, 0xc00 were mapped as
2M initially with EPT memtype=WB. They were then mapped as 2M + EPT
memtype=WB+IPAT when guest CD=1. After some seconds during guest boot, they were
split to 4K + EPT memtype=WB. The split may also mitigate the lack of zapping
for CD toggling to a great extent.
In my environment, the guest appeared quite stable with
"zap-only-memslot + kvm.nx_huge_pages=Y". However, the benchmarks sometimes
still showed around 10 errors in that case, compared to 1000+ errors with
"zap-only-memslot + kvm.nx_huge_pages=N".

== Request Help ==
So, Alex, do you recall if there was an IGD device in your original environment?
If so and if that environment is still available, could you please help verify
if patch [4] resolves the issue?

Thank you and your help is greatly appreciated!

[1] https://lore.kernel.org/kvm/20200713190649.GE29725@linux.intel.com/T/#mc45b9f909731d70551b4e10cff5a58d34a155e71
[2] https://patchwork.kernel.org/project/kvm/patch/20190205210137.1377-11-sean.j.christopherson@intel.com/
[3] https://lore.kernel.org/kvm/20200713190649.GE29725@linux.intel.com/T/#m1839c85392a7a022df9e507876bb241c022c4f06
[4]
From e41a78c95ea3478be04dcb35f374084231a08a5f Mon Sep 17 00:00:00 2001
From: Yan Zhao <yan.y.zhao@intel.com>
Date: Sat, 23 Nov 2024 21:06:42 -0800
Subject: [PATCH] KVM: x86: Zap EPT on CD changes when KVM has non-coherent DMA

Always zap EPT on CD changes when a VM has non-coherent DMA devices
attached, no matter quirk KVM_X86_QUIRK_CD_NW_CLEARED is turned on or not.

Previously when kvm_arch_has_noncoherent_dma() is true, EPT is zapped when
CD is toggled only if quirk KVM_X86_QUIRK_CD_NW_CLEARED is off.

However, EPT should also be zapped when quirk KVM_X86_QUIRK_CD_NW_CLEARED
is on because the EPT memtype would switch bewteen
- "MTRR_TYPE_WRBACK | VMX_EPT_IPAT_BIT", and
- "guest MTRR type (without VMX_EPT_IPAT_BIT)".

Fixes: 879ae1880449 ("KVM: x86: obey KVM_X86_QUIRK_CD_NW_CLEARED in kvm_set_cr0()")
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/x86.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 93b0bd45ac73..3e874cfaf059 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -792,8 +792,7 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
                kvm_mmu_reset_context(vcpu);

        if (((cr0 ^ old_cr0) & X86_CR0_CD) &&
-           kvm_arch_has_noncoherent_dma(vcpu->kvm) &&
-           !kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
+           kvm_arch_has_noncoherent_dma(vcpu->kvm))
                kvm_zap_gfn_range(vcpu->kvm, 0, ~0ULL);

        return 0;

base-commit: d45331b00ddb179e291766617259261c112db872
--
2.27.0



