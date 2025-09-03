Return-Path: <kvm+bounces-56678-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EEF02B419CB
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 11:20:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A4F09487516
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 09:20:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 773CC2E8B70;
	Wed,  3 Sep 2025 09:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hfcM5DPr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 052AC1078F;
	Wed,  3 Sep 2025 09:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756891228; cv=fail; b=dkTW7N6o9Ksvnsu/bwDWBznckG7/CLVfImgSxNXv+Zw9feTUPPXQe2uvfGdybcWHWw0qM3Puo+QRVFxUaneTo/6X8QysbJ8YoNfWyakC5V2MPknv7F7kc9wZHHQ4goMBnKaEVTDOjWADnnhXeu0GoRIACZC8alj9qFpSy60zO4E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756891228; c=relaxed/simple;
	bh=T0nGi8TVCYuRDvgx8a8cIC95z1MfyKAVAzenacSFdMM=;
	h=Date:From:To:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=hGKbHAOzJm3pP0HuHoxtoRGLR0x58H98zIg3LWx6InbHrBI1RYOTh+OfvPIkyY/SqFQyF0ORiXS8DnQmPFfF6G5ZxSYznyxyLhee1iB3fAIfkOaBrXGiH/Xrw8y7gN0/3T/2bu7L2id0nTZElqFdKOo62J4q/SCZd2T5lkDWqGs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hfcM5DPr; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756891227; x=1788427227;
  h=date:from:to:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=T0nGi8TVCYuRDvgx8a8cIC95z1MfyKAVAzenacSFdMM=;
  b=hfcM5DPr3x4IAUgTBLjayGQMwQ/yY2Q7PVqty+myw/3dashMSvvixw6A
   5D/tgW6zQ+32n3F1L9Ce4pYsvHHsiwkBPFpQQzFDe1pcarEttzxCSxlFd
   7jXLa1EwlgQodXz2IDe5YmYul5f/MC7mfPSVogaDr2U4683dRXnZrIgPG
   KKJ5QDs4yX0vxylisrISvArwPTvgNjgb8UcqneWuAadzCSGN34YBbGN0+
   PQWIkfbUV1+BaCVPbB3bu7W+p3qRvX3LBJYuhLBOaVESCL3gkz3dPjhVu
   POoE8bs8Z8inkCQdnBhpr3S/HgcxDlwdSqtXBMQnhmclc++0aEuvu/3e+
   g==;
X-CSE-ConnectionGUID: bpdDucosQSy1du6lWmgELg==
X-CSE-MsgGUID: xH42AmzTQ0+mz+EZQWHG7g==
X-IronPort-AV: E=McAfee;i="6800,10657,11541"; a="62840532"
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="62840532"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2025 02:20:27 -0700
X-CSE-ConnectionGUID: H4b2FG79QVyLNuws1HZiJg==
X-CSE-MsgGUID: 8F5AXUTCR7utuAn0hqUKNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="171503385"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2025 02:20:26 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 3 Sep 2025 02:20:25 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 3 Sep 2025 02:20:25 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.55)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 3 Sep 2025 02:20:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d1ouViqKtdQhOWtuplUHK3ZGtDWZ1zVlu9wQNSg2it3w2IfwiSVIy8JtH/1TxzV61KnOPb69wIJa6u1eHc4K+lJS1/I85X6ZcYolP0LqLC0rvk4uy1HoFViUDZqMchhR38mB7NUd6fYiJa0FUragrluqdb/l9DuYVltevHgmqq7f1dJuBexoEOESO9ukPOgQY5kp5FptIZP4A3u2dwmMa+EH8xII7U7W4FMJKegT270RAPhdsrgP8WscanapnyDTETqgfZSXGRTHlyjmxEO+mTQ/nC9wxaCV1SlQ6AT7lBxIr+c2lEb1sEflAt89FcOWVk6sZvMevwAXFNkjxa90jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rHsiOlsr66VC5JI7Urvfar3mQvdGURgMUf148i2Ol8Y=;
 b=as2evhqUZi6eyKRzKoDM+Q/0KszWlpii9ecpzd/0TMs51TuGRMHfpqORfAt1kAnZ+38mjQO6obfJVmWw6q+uCSRuf9AT+zuCX8jhWpFjW4JGlxc1eFqTlnSbPO6RI5OV3k0tKdReu5ShT8zSzMgJfihIeudNlueywSzjnXTCGEvBBB+AoEb9nQoRD7E54lRoKmCE8ckBAW0+8uTiZ8crvifx24LFqjZXnlEGEy2MyBHE63i6ckMi/1eUXmKqv6L/omR3ZyBevaID+dVN1MzU1JHvDimr+pKRu3ZlYEmt2vN+dh58NSYgukLmLxFVZOn7nlRXYRVgsqd5WY61dh/ihA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA1PR11MB8837.namprd11.prod.outlook.com (2603:10b6:806:468::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Wed, 3 Sep
 2025 09:20:20 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%7]) with mapi id 15.20.9073.026; Wed, 3 Sep 2025
 09:20:20 +0000
Date: Wed, 3 Sep 2025 17:19:27 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Weiny, Ira" <ira.weiny@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [RFC PATCH v2 12/18] KVM: TDX: Bug the VM if extended the
 initial measurement fails
Message-ID: <aLgIH8i9r7jnYnj1@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250829000618.351013-1-seanjc@google.com>
 <20250829000618.351013-13-seanjc@google.com>
 <aLFiPq1smdzN3Ary@yzhao56-desk.sh.intel.com>
 <8445ac8c96706ba1f079f4012584ef7631c60c8b.camel@intel.com>
 <aLIJd7xpNfJvdMeT@google.com>
 <aLa34QCJCXGLk/fl@yzhao56-desk.sh.intel.com>
 <aLcjppW1eiCrxJPC@google.com>
 <77cd1034c59b23bae2bbf3693bf6a740d283d787.camel@intel.com>
 <aLe3V9mgv/gK4MPV@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aLe3V9mgv/gK4MPV@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: SI2PR02CA0026.apcprd02.prod.outlook.com
 (2603:1096:4:195::19) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA1PR11MB8837:EE_
X-MS-Office365-Filtering-Correlation-Id: 887bec32-9a9b-4811-e484-08ddeacb1a93
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|921020;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?jFjPmqKbWH7hK6pLwXA++6dvSYrE5F8NKNcpo+/J/KUnpRgc4ynZSUe/1vEl?=
 =?us-ascii?Q?hw1v57eYizNCR2Yl7+/XgBgHBuZ48X8q0VxCKwvwAYjnM04gjQZEr+kLFGH2?=
 =?us-ascii?Q?KZomZMovYTWXGtzlqKowxChu0149pUOZJKQCV3p49rUodfr354exD+OEQExB?=
 =?us-ascii?Q?fyzivTrXLJ0dbnyKHkY1//sktSRPMBRXdnjHNGMaRPr1HdPZynpr3zsd09Tw?=
 =?us-ascii?Q?glUepidese7zm8o+TN16MjNMSDh5NbsQf5z99/uV85OLj2wHXAJIA45pcs8F?=
 =?us-ascii?Q?MxMJ0+TraJRkieFSw/diIx4BFxmJ6fS24UBMnsNBUQ/BatDanYGTIeWshwju?=
 =?us-ascii?Q?gTpyCSUbMZ0kQNI08UlnkkjsuJzJl5CeORm26MRv87YMsCrAZJeW+49D+FxY?=
 =?us-ascii?Q?tjr9r6r+wtiwrfr2l/9Et1FoXH9hoV78LjgKlS4BURj00N/butWeYdnA3Oq1?=
 =?us-ascii?Q?res4tGGQxA4RbCLUMxjRTgkRA24mf86rwyEoFoubitAFuvWNg7Htb7UzGrVU?=
 =?us-ascii?Q?1yL/Om9xzsE/0DYOquzrRT3cs9oTi2lOatLb8EyPOpqf6L6R1y2GbvRg3IPz?=
 =?us-ascii?Q?VjP2KugjgbJXG9Ey9agCRn8JmPkt46GVwKayZCHWkqp86naqpEkN/U/6bPhA?=
 =?us-ascii?Q?2VxgMO68XgOjl5cz5wfKeQ3lNRArqaHcmtveVkxd9yY/v66z1OUcF+wsE5T3?=
 =?us-ascii?Q?sAryZWb+C0HGGo/Hk+ohOpSJJfls6RoxabI7nseTOH291YXQPoMtiQ6cat4x?=
 =?us-ascii?Q?cNNlGNmfLPoW9vxn52oDdl8ubAsD1VjazY8u+rmkzVPISIrfkeOLgY+fYffR?=
 =?us-ascii?Q?PeXngsyboS3xt2TNMGGaniL6B4LHl7lCk2UAf6nvarTTERFgULoVT0eakM4x?=
 =?us-ascii?Q?wAcOtumIrpVB7FglVFNukrDlhtAGkKh48ONmqwkTs6S+Ax1/3aZl3bHylxt5?=
 =?us-ascii?Q?5Brba1vbsaoyIv4J/GCNuAvesCjUECj+UqHIgDKLZ8oOA2qxmHxH1Sa6plZ/?=
 =?us-ascii?Q?MH8fHKtDayuevUQdwG1S84zAlKKyUc9fVtVymbV4uepn0UPH5cMxs+SAv/0h?=
 =?us-ascii?Q?2bt1vTVkpiwIfsbRJPiO50JJUNRmj3idrvKnJvQTZu/7bILZuHIvYk7pmN2R?=
 =?us-ascii?Q?FldPcVZ7gExCz0Z02HHiCv2LsM+2/xbBt5jK7jXO/c5YDZfsJQ809oWwEOeA?=
 =?us-ascii?Q?vhLmkvKwcb24JvEMCs9NEl/R6s5AO03KDGW9v6RyWZ3RqcmDiqURok2EoDZt?=
 =?us-ascii?Q?40yg52LUnpqycKWGajEHn3yTxi/+BDaBfX0AVEIQI09zwbp6quLIN5jRCGIx?=
 =?us-ascii?Q?678SIR+xAFwmL2JWVKCODjsJZ6uQ3nu3c+hPFwA149utuQ/9f9E2DXesZhmT?=
 =?us-ascii?Q?mhePodHebGDVFwYSY4UB95RL0NAbPbQZw91EYei0TsB+m08d4lkk/skChlD8?=
 =?us-ascii?Q?OOB5vtGLVpdIzYHT6uW44aegKOd3WOp5qp4NEMO6d1OrnR6dUjUr9A=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JGp9CxXRjqiBlpCKU6l6l1ZUJkQrCeoV/YY+jHBUq8ZUeIxfIRFeqvKM61A3?=
 =?us-ascii?Q?brBf2UPjaZddpuuAxfRwsJ5Zthu7GMf3MrJ9iFFYUNVuXiHRBkBa+0M673bg?=
 =?us-ascii?Q?oTdZVGHt13mUAkTTn3tEuaRFcd8ceoyOPCwVkAqDF0cWh5CSnjyXaMG9Mjf6?=
 =?us-ascii?Q?ejtew+jNLZa8bknrl/+dwYHiBmvIkgX72snsterTbzKEm5XvdgNRN5bZomUr?=
 =?us-ascii?Q?mmQ40KtUaXNKh+7x7Ht8NtzYRECMFVPtsOp9DbGAK7xnKmdYRwwrW53z2g2Z?=
 =?us-ascii?Q?9ISWHxcjJ/Fy0dUdkqxKpBO8unRzirm7vxVuj0uE8Q1DKrzwD3Gv6H3Gn239?=
 =?us-ascii?Q?L0zeIXzJHoNli7iuWxL5wWe4sWnrbspmvU0J+82pQ/H9nzHR08KYM/wMxKR8?=
 =?us-ascii?Q?XKQrBwqqUkgDs7fKObAIeor1NF0jpB8q3+EY2bqJFkYx5Kb9lre8G85HLUzx?=
 =?us-ascii?Q?DRC41g+K0bHgvrN+DlD7Jomr7IkEAeyvvqx8/3nufa5aIVsz7/gFNJO5svAj?=
 =?us-ascii?Q?Fl+sg49s/OWbClcSL454EsQXE9cSLTSsKWicGVGG1RzNIt5HzqTRUgY2xWUl?=
 =?us-ascii?Q?EGHW9fsLDq0SgIx2Gokei8zAk7hyqf8NJgxRotP+3//lMdgQIhGT29lsje0o?=
 =?us-ascii?Q?EKBYXpLBWcF8PX/xoeo9wqia1bGPuM+M7fXUvKb+tEKm1EnYbTNLIos2RyTC?=
 =?us-ascii?Q?b1TNb8BY1E1fmDEnpSOLzNNIWaNITuBMKMjok+NqM6XhLRBYzS5NSR71NZ30?=
 =?us-ascii?Q?jliD1VHFn4FZgh649DHManIZlaUdEDEuiHeem/zK27Pw2AgCC+vzKzRla6yg?=
 =?us-ascii?Q?sE7SjtIknlx7F6kzPGXEkTD7gzJOaNdZud5o+lS+kYrD1rbyQ3K5z5DavpqR?=
 =?us-ascii?Q?wp0tm402KkYfDQKhwyxB6UOzNnkf9SHgUyaY54tr2sLRoqiO3l1f98BxIn3U?=
 =?us-ascii?Q?YXvgdXxX2kugOlkI+Sm47l9F+1SXNiZXSQawrML1cH6EbM+RZ7mqyJXlbilt?=
 =?us-ascii?Q?Hn6zjp9DDbF8ekinFeNvUfVEO5l3ueoOfyLV616D9/2KVEtuktftdIkcp8BH?=
 =?us-ascii?Q?egxGod6V3utopQFTA3hesuZQH1Gue1/r6oKxWbXDxWDlBOfsGS1L+r9+BzFZ?=
 =?us-ascii?Q?T8uiUHlasEMGNp4ERhwNYdOkke5i96KjjgJq2nKt/xSYAaU8E9A2VNbmsGBE?=
 =?us-ascii?Q?KjUNgdp6eBDdn8I0Rhku+OUHUr+tbpbyFjseC5BIX9DZUf9KwriROW0usXgY?=
 =?us-ascii?Q?byHHkYHLkaw0q1yxy/g6yBzN7+Jul4uicPBtNSrxf4G4/auzZFxk44osxXl8?=
 =?us-ascii?Q?mw8eyGiFmsBN/1GJAi6wmYiIRgmE67wQk7YPC8UulMDeWkJcAH4DkcPFPAE2?=
 =?us-ascii?Q?uCWYZmA2qbxMi0N6IHUPxUjyrq5qK4EUuf3mAtzTUxIxwcv256Io8xRayhFX?=
 =?us-ascii?Q?me94+03MxIuaIFXrVYPVSHNLVVPPf6FIiw/fTFo3xtcGoAa0N5XxniBm1yMm?=
 =?us-ascii?Q?3nRKqYqJOYf02qiYEQRxItMB50hbu2sZC/Nl0NT9/jf8ZZdrbFBKjXv2yeCJ?=
 =?us-ascii?Q?9aXTWvuE4JT+waK83ptaibCWOsg2SxR+Qm6SWlTH?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 887bec32-9a9b-4811-e484-08ddeacb1a93
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2025 09:20:20.3361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /7jaxHxNWmnXyaXW0fsvbfIHBno5EGh01dkahI5JqqlSoK8wkJpriEhB5IjokHAoUIY56yWQSUQMC3mJLY3GYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8837
X-OriginatorOrg: intel.com

> From 0d1ba6d60315e34bdb0e54acceb6e8dd0fbdb262 Mon Sep 17 00:00:00 2001
> From: Yan Zhao <yan.y.zhao@intel.com>
> Date: Tue, 2 Sep 2025 18:31:27 -0700
> Subject: [PATCH 1/2] KVM: TDX: Fix list_add corruption during vcpu_load()
> 
> During vCPU creation, a vCPU may be destroyed immediately after
> kvm_arch_vcpu_create() (e.g., due to vCPU id confiliction). However, the
> vcpu_load() inside kvm_arch_vcpu_create() may have associate the vCPU to
> pCPU via "list_add(&tdx->cpu_list, &per_cpu(associated_tdvcpus, cpu))"
> before invoking tdx_vcpu_free().
> 
> Though there's no need to invoke tdh_vp_flush() on the vCPU, failing to
> dissociate the vCPU from pCPU (i.e., "list_del(&to_tdx(vcpu)->cpu_list)")
> will cause list corruption of the per-pCPU list associated_tdvcpus.
> 
> Then, a later list_add() during vcpu_load() would detect list corruption
> and print calltrace as shown below.
> 
> Dissociate a vCPU from its associated pCPU in tdx_vcpu_free() for the vCPUs
> destroyed immediately after creation which must be in
> VCPU_TD_STATE_UNINITIALIZED state.
> 
> kernel BUG at lib/list_debug.c:29!
> Oops: invalid opcode: 0000 [#2] SMP NOPTI
> RIP: 0010:__list_add_valid_or_report+0x82/0xd0
> 
> Call Trace:
>  <TASK>
>  tdx_vcpu_load+0xa8/0x120
>  vt_vcpu_load+0x25/0x30
>  kvm_arch_vcpu_load+0x81/0x300
>  vcpu_load+0x55/0x90
>  kvm_arch_vcpu_create+0x24f/0x330
>  kvm_vm_ioctl_create_vcpu+0x1b1/0x53
>  ? trace_lock_release+0x6d/0xb0
>  kvm_vm_ioctl+0xc2/0xa60
>  ? tty_ldisc_deref+0x16/0x20
>  ? debug_smp_processor_id+0x17/0x20
>  ? __fget_files+0xc2/0x1b0
>  ? debug_smp_processor_id+0x17/0x20
>  ? rcu_is_watching+0x13/0x70
>  ? __fget_files+0xc2/0x1b0
>  ? trace_lock_release+0x6d/0xb0
>  ? lock_release+0x14/0xd0
>  ? __fget_files+0xcc/0x1b0
>  __x64_sys_ioctl+0x9a/0xf0
>  ? rcu_is_watching+0x13/0x70
>  x64_sys_call+0x10ee/0x20d0
>  do_syscall_64+0xc3/0x470
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>

Fixes: d789fa6efac9 ("KVM: TDX: Handle vCPU dissociation")
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
>  arch/x86/kvm/vmx/tdx.c | 42 +++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 37 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index e99d07611393..99381c8b4108 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -837,19 +837,51 @@ void tdx_vcpu_put(struct kvm_vcpu *vcpu)
>         tdx_prepare_switch_to_host(vcpu);
>  }
> 
> +/*
> + * Life cycles for a TD and a vCPU:
> + * 1. KVM_CREATE_VM ioctl.
> + *    TD state is TD_STATE_UNINITIALIZED.
> + *    hkid is not assigned at this stage.
> + * 2. KVM_TDX_INIT_VM ioctl.
> + *    TD transistions to TD_STATE_INITIALIZED.
> + *    hkid is assigned after this stage.
> + * 3. KVM_CREATE_VCPU ioctl. (only when TD is TD_STATE_INITIALIZED).
> + *    3.1 tdx_vcpu_create() transitions vCPU state to VCPU_TD_STATE_UNINITIALIZED.
> + *    3.2 vcpu_load() and vcpu_put() in kvm_arch_vcpu_create().
> + *    3.3 (conditional) if any error encountered after kvm_arch_vcpu_create()
> + *        kvm_arch_vcpu_destroy() --> tdx_vcpu_free().
> + * 4. KVM_TDX_INIT_VCPU ioctl.
> + *    tdx_vcpu_init() transistions vCPU state to VCPU_TD_STATE_INITIALIZED.
> + *    vCPU control structures are allocated at this stage.
> + * 5. kvm_destroy_vm().
> + *    5.1 tdx_mmu_release_hkid(): (1) tdh_vp_flush(), disassociats all vCPUs.
> + *                                (2) puts hkid to !assigned state.
> + *    5.2 kvm_destroy_vcpus() --> tdx_vcpu_free():
> + *        transistions vCPU to VCPU_TD_STATE_UNINITIALIZED state.
> + *    5.3 tdx_vm_destroy()
> + *        transitions TD to TD_STATE_UNINITIALIZED state.
> + *
> + * tdx_vcpu_free() can be invoked only at 3.3 or 5.2.
> + * - If at 3.3, hkid is still assigned, but the vCPU must be in
> + *   VCPU_TD_STATE_UNINITIALIZED state.
> + * - if at 5.2, hkid must be !assigned and all vCPUs must be in
> + *   VCPU_TD_STATE_INITIALIZED state and have been dissociated.
> + */
>  void tdx_vcpu_free(struct kvm_vcpu *vcpu)
>  {
>         struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
>         struct vcpu_tdx *tdx = to_tdx(vcpu);
>         int i;
> 
> +       if (vcpu->cpu != -1) {
> +               KVM_BUG_ON(tdx->state == VCPU_TD_STATE_INITIALIZED, vcpu->kvm);
> +               tdx_disassociate_vp(vcpu);
Sorry, I should use "tdx_flush_vp_on_cpu(vcpu);" here to ensure the list_del()
is running on vcpu->cpu with local irq disabled.

> +               return;
> +       }
>         /*
>          * It is not possible to reclaim pages while hkid is assigned. It might
> -        * be assigned if:
> -        * 1. the TD VM is being destroyed but freeing hkid failed, in which
> -        * case the pages are leaked
> -        * 2. TD VCPU creation failed and this on the error path, in which case
> -        * there is nothing to do anyway
> +        * be assigned if the TD VM is being destroyed but freeing hkid failed,
> +        * in which case the pages are leaked.
>          */
>         if (is_hkid_assigned(kvm_tdx))
>                 return;
> --
> 2.43.0
> 

