Return-Path: <kvm+bounces-69721-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AOxIJXq4fGkEOgIAu9opvQ
	(envelope-from <kvm+bounces-69721-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 14:56:10 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D06DBB655
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 14:56:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DFAC23015471
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 13:55:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8033313E15;
	Fri, 30 Jan 2026 13:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FkhCNzAh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3317B30F943;
	Fri, 30 Jan 2026 13:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769781358; cv=fail; b=nwiF1+z3AHYUYxvebbWfuETeGPXhSouiTW5y7KHtoxPhIOfeiCdVNugwmYspxcfRnlefqE4JggXj2pqPuk1sPuUbsJDiiykbU+yJJSxXG/0WP7q/BCHVQ38EtlwRcAVIZYJm6PiKgnZFx75fKzkVmkf6i8HBnC2uEkyOLMR2ddw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769781358; c=relaxed/simple;
	bh=CTRVwn3mlxWajhgOiF058QHMI11NkebOqWOGmEw542M=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QQYoybEAIp4i1KcSrtTHA4827Emh7FIf/o7RVgpxZQOdQRUh5TwjLyaoZTnMizaJDywbjklfjKvhiMNmK4RYp0iuor+enXqDmIKCPQ49VkYfaPTJQGnw188t++dxVESO8BKGpzP+AhJM+O59j3Awh75VjC9/LWAI8aMU3neBDO4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FkhCNzAh; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769781356; x=1801317356;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=CTRVwn3mlxWajhgOiF058QHMI11NkebOqWOGmEw542M=;
  b=FkhCNzAhxDk/maiBLN0AH2n7nvtF/DhlHS6nJyYBnVKA3BEWp8tIrtyM
   RhU+zbWzAn4JvKzplZVgHQI6jbPas/p2T8HOptKw12il/cO3/Ix0/9UnC
   5ie1wFdSLUZY6bK6S82fC/mAs4UzZsfPQ1YasaCxDN3+bG+fITjJHiu9y
   vd2atNoeloQN+9feaNKptyzE2aU25NoSBCHFE4f0LSiZJb0nfaYgdrfav
   FZgrr8/3/tMB6VVNQsb/2kAv4liRvpOHsRnAae+L6bX6eH4Mk4tkn5AY1
   RMhwuXG3kV1yLlRo1h2OAAVKScLwpZgktcK4LEIvLR5OFYQtHET8FBNU7
   w==;
X-CSE-ConnectionGUID: z80fz0A5T3O4kcx7iY6yhA==
X-CSE-MsgGUID: za5NvmCqRuuKsayMiCBdZw==
X-IronPort-AV: E=McAfee;i="6800,10657,11686"; a="88604477"
X-IronPort-AV: E=Sophos;i="6.21,263,1763452800"; 
   d="scan'208";a="88604477"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2026 05:55:56 -0800
X-CSE-ConnectionGUID: tp7vfQTNT9W0W3Gz7jOo4A==
X-CSE-MsgGUID: Gdr6269SQS2pVf2K4MZgyQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,263,1763452800"; 
   d="scan'208";a="207985185"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2026 05:55:55 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 30 Jan 2026 05:55:54 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Fri, 30 Jan 2026 05:55:54 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.60)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 30 Jan 2026 05:55:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VR8Puo1FToPI4HZudPjj5TxWDZjsU8KVD9a1lOF+BpsddZn55Qk4rafwURViIp1X2zSczEYKzy4B7/tglI/5khugjkgIVVWQabuwHrP/+6qxMcN1msILVj3wtDJRoviY0vo4GhMhlgC//LdlXwJjXep9WQnOnk/Nua7kuK0+HDsBwcl5pl497EJlB9wA4l4gz6ADSYJq9/1g+KXmI7RDeGK/Sx77yBeshRw1mDOZS786AM9BZbcwEcvIMurbwoE3bPCP3xF94ARzAmmSS4u8y+UWVpQwnzX5PKsU9ASP7rmpbT+/hd0XOcYQg7H7RQTzaDhhDawdO4CeZki+rTUkTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tgmx/QvlkfN/Y6qHNXqd/PgE2OSPp44DT6MFAfQlWDU=;
 b=M1yloacuY/sNzEfHYsToJbXEs7e4Wqq5UQlUPOHnM3rpkJCJ1iWaNVq5oUy+sObD1VwsCkzpMw5Y7AmbBHIojO34JcwXiFeYq1kz9DmpUXA3H4cqyZ91mIjK4Q/3ClxCPPjE42p3jwpHkhQMl/e4ps5ugQXMVVDUzzsx32CzXHM3gcmnyrPzT8YGrftGP0hmpeGxXOKrkQbKhwsr5eA8CH+H59CPhoY/FJi8maXpNwCJDyezg9gk7dsc+Sies6TiSOc/MTaQDZOwAnkUIwN2iLyjO3ASRNtHdCbTuytCZ+kzGQ/ogBiu4tX8xATQj4VsZtQJ2Q/ULV9tXDbF7gqh+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by BL4PR11MB8799.namprd11.prod.outlook.com (2603:10b6:208:5aa::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.11; Fri, 30 Jan
 2026 13:55:50 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9564.006; Fri, 30 Jan 2026
 13:55:50 +0000
Date: Fri, 30 Jan 2026 21:55:38 +0800
From: Chao Gao <chao.gao@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
CC: <linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <x86@kernel.org>, <reinette.chatre@intel.com>,
	<ira.weiny@intel.com>, <kai.huang@intel.com>, <dan.j.williams@intel.com>,
	<yilun.xu@linux.intel.com>, <sagis@google.com>, <vannapurve@google.com>,
	<paulmck@kernel.org>, <nik.borisov@suse.com>, <zhenzhong.duan@intel.com>,
	<seanjc@google.com>, <rick.p.edgecombe@intel.com>, <kas@kernel.org>,
	<dave.hansen@linux.intel.com>, <vishal.l.verma@intel.com>, Farrah Chen
	<farrah.chen@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin"
	<hpa@zytor.com>
Subject: Re: [PATCH v3 08/26] x86/virt/seamldr: Retrieve P-SEAMLDR information
Message-ID: <aXy4WgLd5ncrmje5@intel.com>
References: <20260123145645.90444-1-chao.gao@intel.com>
 <20260123145645.90444-9-chao.gao@intel.com>
 <b2e2fd5e-8aff-4eda-a648-9ae9f8234d25@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <b2e2fd5e-8aff-4eda-a648-9ae9f8234d25@intel.com>
X-ClientProxiedBy: TYCP286CA0011.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:26c::17) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|BL4PR11MB8799:EE_
X-MS-Office365-Filtering-Correlation-Id: 6bbe2eb8-55a7-429f-2113-08de600746c5
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?w0c5QuZuJ45BAn3tSVS50KUzoADF9LHZgj3KFk40yDnkC4wbqFGYQBjwAZew?=
 =?us-ascii?Q?HwAfSCOCXEfZ/Z7SCJxQJc0WN1mZ2ny9otiHKJInHA1cvUUr3SMxaHthquxL?=
 =?us-ascii?Q?ITU0WkOp49y5DR50hZ7PtRKIF2amycFcUteXjfFi1bYf5/CXP6xLPBHeQhxM?=
 =?us-ascii?Q?31rZHLnc3hrM234oodDUIwvXQU+w1a/22Xrclwaov6EY9omBR+W8OLbvk3X+?=
 =?us-ascii?Q?LMl+NfoRVnBp3SGDGStaa6qMhr9TiR6EH5Vph7/X9YrwpPtRLKX1WK39funp?=
 =?us-ascii?Q?CQV2Vbp4n/UT1KpD5Hm+RFvFy704PMuyjz/GDkYZpa89ZFasEiD+vRina8jJ?=
 =?us-ascii?Q?uCW1jIW3G1OYxfZlC6QUgNsTJYdmc2pJios1CT00yEmv1i5R6ggZk/S5XJMC?=
 =?us-ascii?Q?53jkb1aGIlp9LlDFqyLA6KBDsR+kpn36Jrf8xcHKRtpq9tzbISPR2PTujMY+?=
 =?us-ascii?Q?hS46yKIWTV8Zvqa/nUtK9k3spUfXcyh7ludanGuF0796IGQ96R+uXtKJtZfy?=
 =?us-ascii?Q?JWkcRlM2utM9MfSqqPHw30JWhIXbuoKPJCYUse9kq/+iDhX3I66UZvoUagqK?=
 =?us-ascii?Q?pYuACHpAPlR9C8BlqNtFxV6i3MTweswLBt3nsrQMBsHahgc9xa7Di+QHGY/4?=
 =?us-ascii?Q?58PISvyTdPbWx2/OSIMQRz5zOiyPInYNIymrZVmhINItw5LOOfsMl5B30cRT?=
 =?us-ascii?Q?Cw+i4z4wmIYTTd6rVM3f3ZHDMQ1a/4D9W61zOMmxQl8axzYLZisfBjGss6K0?=
 =?us-ascii?Q?XwWGDMg7EBb3J7YuuVlKsCw1vFLyBVDzrYGGa+UOqUmkn61md5/GL7cyR6KD?=
 =?us-ascii?Q?/LvmH2dY9APQZiy/Yt4oyiod6kt0EyRRyNZl+y8iC6E3+bPMoqWHDQFRgRoz?=
 =?us-ascii?Q?PQFM7Iod29h+2yBH/kJSRc7+d+dV+C/qn5xgLoOR9C1bcQDSyU9SZjo7PDmn?=
 =?us-ascii?Q?e+Kuho0XOGpzTg5KrmwUL9SJo9YDaEbE/O53gJEkD8wmSYo1tg9yIBt5o8Om?=
 =?us-ascii?Q?RZa+r3Z+ZJ2Al8bIyNseBqbphQQclpoN9pHH2/+KkWtftylwixk9Nsvo3U7o?=
 =?us-ascii?Q?HY2+dxxKIDsHVA43/L5dWFlPqfKMRN0Tga9t+4AHMXcuYnlh2h4FZC8/oQNk?=
 =?us-ascii?Q?gMmfgSQUvgDefeEDbYF3FzBOjas/43tYGa1WXgjUbToOxGiLSW4esm/iJDB3?=
 =?us-ascii?Q?cXQ+G+Jl2hHVhydlPsg33NSov5DqmelamQcz9gIM2JpKzn0FnNw3snp1w27x?=
 =?us-ascii?Q?2Ln2FtBotSuvRmMxiP9llnBQbeN/CE3DEYfRGWo+aI1y7i8tB+8AECAL6SHW?=
 =?us-ascii?Q?4qOzDw/a3O0Ifip7l3IssuSoSURhWna9J+vLmH4vb5tN4RZ4Jh5PwXzrG+LI?=
 =?us-ascii?Q?Izwu1dBaGH6I8xMBJNFKxD3M38MbbEUtmlQIV2B2q/BN5GMeB7waRiaoXQ8q?=
 =?us-ascii?Q?ISfFlUAwk80BIH1RtqCWX8I5rqBudxuhuN+C0ttwK9pO6wgZooAVSWh/qXvU?=
 =?us-ascii?Q?3rL9nA35DUbylf93L6VUMLiNfgR+Pi0oQdfLwOaZImBzAMHTPUxgW26OvKwl?=
 =?us-ascii?Q?tX6Gdu6hWKrmVU0HJOc=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Sbvaf3+fwdZ+/z+V3N8pNIhAI4ZvlFoBT79Eoe9dk64C125uc93tTVvY5yZ2?=
 =?us-ascii?Q?Qgl3F4o238/DBYAl6zmLP50kdF+RnQtSoT5phjBFi66EDx6N0lVojaO6Jze7?=
 =?us-ascii?Q?vvoH+BU5A3Krkwa34Dae72m7LQtLd0eZkmV8wCbL39OVkREcaqoXYUgLSpKG?=
 =?us-ascii?Q?kmOgFsRhY1Jz8McHMxIxVI//86ZG+kcvAvnFXQMTb3ty2qfUXsd7LrUCq1tE?=
 =?us-ascii?Q?m0QSUNzmSbEzHp0LsaZc1p9gVJjnMV/bzqVGDq6nVDN3mcgSvZtthnW2YlYD?=
 =?us-ascii?Q?TfWHreBFtDSxXuVEW25uPtBELbODc53ar4uInhWHYSb2/BImuZI3YLQ/WIGG?=
 =?us-ascii?Q?x9BdaI5ypIkIw7jFhogmWkFWaGL0uJ6s1oi7Ju0NODj1lEx5K5NfwB1PnFxE?=
 =?us-ascii?Q?jPQNH/KCPyCtTXTHaanw8hNGQ0Qzs31n03ZYFeHa5v1H3/VHESblyNYdyjJ6?=
 =?us-ascii?Q?H6M70Xr3LbPIa/m0q5SXplXamBpjToEwKGk8qU8um42NlWSdZqLl//lw+fqN?=
 =?us-ascii?Q?6PphYbozL5o6ia8wve0ZNJzGRqOB62SHzqCCQf/bxD2vRbwvU2ShgfV7+nbc?=
 =?us-ascii?Q?AReq4cH/MsjKz1v+medxtAZXrxyFkuGQp6g/IZSbqVW5oe8sEK1i0wGbEjak?=
 =?us-ascii?Q?tGy1PUpHqMpHxHWZNmRvECCsbmN+Dxqe3a/6CS0CFMUFpYW+gtsxhz6rtdie?=
 =?us-ascii?Q?BD64q7UonoGCiLYT1PJmb0ZhkE+/TI/wPQGT+8vGX/v0QTzSQtix/CHxFcks?=
 =?us-ascii?Q?2ODOuq5b+3P3d4VGf64Tg7FotaC6d7BX6yLu4/godJ1iEMZgutnFrAKuyggT?=
 =?us-ascii?Q?Sghctlxcft8Qj+iT8ET0gD2exLJy+gMv8LMHomjKILuLjxQntyx4KrvlPRG1?=
 =?us-ascii?Q?5P6WAbEQHVxrab9KBUBVHBDGjk0OojKuAlrOSJR6A/5KQvfr1IFGDvjrjupP?=
 =?us-ascii?Q?tawQ+5FNVnKvsO9IPjBg8wTGWlzUyDx3uxWFNbDF2YqXu24yR8fno0t4Tcj7?=
 =?us-ascii?Q?EwMR9qJKVwE5I45bRZhAjvX92W+Divrneur7y5ZcfmozlVjLHJK/aA5jJ0x2?=
 =?us-ascii?Q?jUNPxGghFFmoN2oTUVN9aasm8846v+A52zJFOtmnL9G36uS3YVW9aejcS9D6?=
 =?us-ascii?Q?cZIEIWBGr69dB2u1kXkf+jX8eSVz12kJAx1bqjnrFOqgDnW//tF9iygp6SwG?=
 =?us-ascii?Q?BEZB8fYDVyDI4nwO7Wv5q/qdGur+wXObDffdjK0Hqi2TrEZMdz9YdR7XErQ2?=
 =?us-ascii?Q?rTZcxGHXDVZjW8v0Vm92q5NWh/XtRYCSzJsRn+L8IbglxjIVnMPikC8EKD/n?=
 =?us-ascii?Q?SCbuXjBVqV82TAm0RwXbHYZRzR2Iu+HBm5Sjrm3TENRa9DQb230LCEVgJdDc?=
 =?us-ascii?Q?8TAsvJOIg5C9KQNJJZhkHhcV0UrIROpxOGOA2cCtooSE3xK4lPRlcMX6hqNh?=
 =?us-ascii?Q?ZilfYdxkGp97dWn3iSqgLAhIMLnSo5YsJFVIL/i6dDMKsmh4aUh/xu7zEZxA?=
 =?us-ascii?Q?/Iefjpj7EAXeEo8hrXWtIyrW2aO2oh6XD4Gdc0zGEQORzQeCbiVuPSDoIImU?=
 =?us-ascii?Q?d+MEupP1NIH4526q/v/sOJMbNszUph0l3U7N2wxEt+tPKvutQw2NjLJ5mDWO?=
 =?us-ascii?Q?fTKa6HKseYkIapeYYPIPETINYeoxQmLvK3aKLdDPoGa0wCPmMHINoLf5Z7M0?=
 =?us-ascii?Q?c+2DkWK6C7ZbFKAJ4eMRJxsDrY2fXsidAN945bfLFtJkteFofm9Lt2BvND3V?=
 =?us-ascii?Q?nY0I0XM/cQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bbe2eb8-55a7-429f-2113-08de600746c5
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 13:55:50.3239
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8OqwS1q3fsNIZzfwuya0MwFTUapg7dtlyjtyi6mBeASMs1afu9rLOMJgltSlxPWPVIlSlAVjQfM7pq/JKdNjYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR11MB8799
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69721-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[25];
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
X-Rspamd-Queue-Id: 0D06DBB655
X-Rspamd-Action: no action

On Wed, Jan 28, 2026 at 03:54:38PM -0800, Dave Hansen wrote:
>On 1/23/26 06:55, Chao Gao wrote:
>> P-SEAMLDR returns its information e.g., version and supported features, in
>> response to the SEAMLDR.INFO SEAMCALL.
>> 
>> This information is useful for userspace. For example, the admin can decide
>> which TDX module versions are compatible with the P-SEAMLDR according to
>> the P-SEAMLDR version.
>> 
>> Add and export seamldr_get_info() which retrieves P-SEAMLDR information by
>
>I don't need to know what the function name is. That's in the code.
>

Hi Dave,

Thank you for the thorough review.

I will go through the following patches to ensure they don't have the same
issues you have pointed out.

>> invoking SEAMLDR.INFO SEAMCALL in preparation for exposing P-SEAMLDR
>> version and other necessary information to userspace.
>
>I also want to know what spec you are getting this out of.

Will add a link in the changelog.

>
>I think it's also worth calling out that there are SEAMLDR calls for both:
>
>	SEAMLDR_INFO
>and
>	SEAMLDR_SEAMINFO
>
>Which is astonishingly confusing. Please have mercy on folks that are
>looking through the docs for the first time and explain this.

Sorry about this. Will do.

>
>> diff --git a/arch/x86/include/asm/seamldr.h b/arch/x86/include/asm/seamldr.h
>> new file mode 100644
>> index 000000000000..d1e9f6e16e8d
>> --- /dev/null
>> +++ b/arch/x86/include/asm/seamldr.h
>> @@ -0,0 +1,27 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +#ifndef _ASM_X86_SEAMLDR_H
>> +#define _ASM_X86_SEAMLDR_H
>> +
>> +#include <linux/types.h>
>> +
>> +struct seamldr_info {
>
>/*
> * This called the "SEAMLDR_INFO" data structure and is defined
> * in "SEAM Loader (SEAMLDR) Interface Specification".
> */

Will do.

>
>
>> +	u32	version;
>> +	u32	attributes;
>> +	u32	vendor_id;
>> +	u32	build_date;
>> +	u16	build_num;
>> +	u16	minor_version;
>> +	u16	major_version;
>> +	u16	update_version;
>> +	u8	reserved0[4];
>
>Why not label this:
>
>	u32	acm_x2apicid: /* unused by kernel */
>
>?

Will do. Probably because I thought the kernel would never use it.

<snip>

>> +const struct seamldr_info *seamldr_get_info(void)
>> +{
>> +	struct tdx_module_args args = { .rcx = __pa(&seamldr_info) };
>> +
>> +	return seamldr_call(P_SEAMLDR_INFO, &args) ? NULL : &seamldr_info;
>> +}
>> +EXPORT_SYMBOL_FOR_MODULES(seamldr_get_info, "tdx-host");
>
>I'd also prefer a
>
>	BUILD_BUG_ON(sizeof(struct seamldr_info) != 2048);
>
>just as a sanity check. It doesn't cost anything and it makes sure that
>as you muck around with reserved fields and padding that there's at
>least one check making sure it's OK.

ok. 

