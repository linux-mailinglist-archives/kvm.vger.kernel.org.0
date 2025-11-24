Return-Path: <kvm+bounces-64437-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CA08C8290C
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 22:44:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 112D63478ED
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 21:44:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD19732ED4C;
	Mon, 24 Nov 2025 21:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S5gpftp5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F01D32E6BE;
	Mon, 24 Nov 2025 21:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764020663; cv=fail; b=eooa1ksy0g+vuXL7tDvHI/+VSQ+UuOeUxg8rQd2c5h89VvrGABZoJNpBhtw2ExvMN3V8fkuNICoGHlOdsKGV7yWNLCnOzs3pa+YV+453igFUdIw1jb6R9qgimrMdpskARvgjahKNMRDS2gdX0Mzdw3axqNCeLT5JRkRZGCoWzQw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764020663; c=relaxed/simple;
	bh=XOfbxwRQ53HEBb8qOdjVGbK/vULhrCuEoPyxnYUozv4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=SYiDqpRHj0BFiMCEqBU8zEFd96Pd+/KJM42PFwVQwhDyxHITa4r+UE1FzO+9Y4/v6KAEjYIuKeBumZcnfmb/YMhNHzyLvCyMMrVPIt4Fm56p259wsgDy6LUyYP0a+1q/PBRw+3oIoXmXN+QxFbDpOt9/NcoGuFTDfjw9BKt0CvU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S5gpftp5; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764020661; x=1795556661;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=XOfbxwRQ53HEBb8qOdjVGbK/vULhrCuEoPyxnYUozv4=;
  b=S5gpftp5pmlMsG1ckbGMwpiSfKwGeeJykvh4AqG41mMa2L9qSfciiIW7
   EZP+iLk+oVwW3ltky8LRO2VmXuNAwj0TD69WV7gpN4SjbfNTpxvZshckf
   05U1JoopximmmzHsbeH20hEo55H5az2QWlBTvYEiQ0ulIOIW79FxSRsoK
   5QEQd7fsrPJUuchRaRBMfYEFMBSGk50JMzjOk8anMyBjZ7wjZmjU7camH
   6kb3SvMbkWIEdR7HUnauCP3VQUCdMODNAjkL5RxQrEkV1+s+Chl3LHyY3
   9vThtgU/HG4cj472m7mWYGc1m1CHpG9o6P2kMFLp3c5jLJlTYhctqtys8
   g==;
X-CSE-ConnectionGUID: P/dY9kfxSYuHAeEd80q2Pg==
X-CSE-MsgGUID: VjmVDaWOR1qYahYGErcnkg==
X-IronPort-AV: E=McAfee;i="6800,10657,11623"; a="83647571"
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="83647571"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 13:44:16 -0800
X-CSE-ConnectionGUID: c06yqfkWRSiafOuVo2E4AA==
X-CSE-MsgGUID: K/uAVCqBTBmHTYc9Css16w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="191710695"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 13:44:16 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 24 Nov 2025 13:44:15 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 24 Nov 2025 13:44:15 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.25) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 24 Nov 2025 13:44:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b/ls6JAkLN0E7Q+1Iv6IzyPxgC9U3s2EKgAMB+sgNLXLTocHaKxhX4fBQ4UlMeQm5k/2dSeI1yC2wgrJ6aR4rpGEGRVxRCcJrnNRWrZ+GS+xKyJqYZD5TGymLEvQGjDDddemMSaIcN8tAwLdfXOldCy6vsti3DQysvMnQi5ctNWlJ5dFKEWTVXJvP8T2sADsP8MJv11FtjJk+uZD/e07J6NbRZvEBrqGKu5vUr6mfBWmWSt1tfzIkK3lUbPRilkN9WuPVhvqG3ah/dAf03NVEBQZjCHPVJmJ7VwV/4yOPkd4j+TuQxvHq+iTyBrLVHcE9OKLlELF2mykKWV1FtcywA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K2rmvXQSYs8xMuEgdU6rlbJj4iHEYfJDaeQT5/VVrTY=;
 b=yKXmLZpAYfZvccIrXdHInh7KKqLAFbS2Y25M0HaiCgmGZOQwdKqJ0GOQkPgakK7tDBCDEPm4LyBSAKO1Ig1famp0GYU38XpAYdEulDTA0IMxYPQ231QYgLBwGResFF/vdZt3e9j56rYOptpjC/q67t1Ax0Bfl/3BUUEC4kjwcFV4PxsU79VB0T2F56iYDdoNKilXxlFWpFkk7vGhb6mEIYCeT3Vl4XpUFeJZztR7a7A/yWbBlxXzf3R3damsqve4ZfrEPqOLfl2aNdBDoN2G5g9jq6hD8exHPkSsG/0fanybXIQ80dYzm8jeVRuqH1Yp94ljQnPtzJ3QjVvga5Un2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5373.namprd11.prod.outlook.com (2603:10b6:5:394::7) by
 SJ2PR11MB7501.namprd11.prod.outlook.com (2603:10b6:a03:4d2::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.17; Mon, 24 Nov 2025 21:44:12 +0000
Received: from DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39]) by DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39%5]) with mapi id 15.20.9343.016; Mon, 24 Nov 2025
 21:44:09 +0000
Date: Mon, 24 Nov 2025 22:44:06 +0100
From: =?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>
To: Alex Williamson <alex@shazbot.org>
CC: Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>, "Yishai
 Hadas" <yishaih@nvidia.com>, Longfang Liu <liulongfang@huawei.com>, "Shameer
 Kolothum" <skolothumtho@nvidia.com>, Brett Creeley <brett.creeley@amd.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>, <kvm@vger.kernel.org>,
	<qat-linux@intel.com>, <virtualization@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/6] vfio: Introduce .migration_reset_state() callback
Message-ID: <i4vq5amjds2xoqablojiwgplrp4uw7xvhk2esibytx25mesekc@q6ajjaexw2pu>
References: <20251120123647.3522082-1-michal.winiarski@intel.com>
 <20251120123647.3522082-2-michal.winiarski@intel.com>
 <20251121111603.49b1577c.alex@shazbot.org>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251121111603.49b1577c.alex@shazbot.org>
X-ClientProxiedBy: VI1PR0102CA0043.eurprd01.prod.exchangelabs.com
 (2603:10a6:803::20) To DM4PR11MB5373.namprd11.prod.outlook.com
 (2603:10b6:5:394::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5373:EE_|SJ2PR11MB7501:EE_
X-MS-Office365-Filtering-Correlation-Id: e08a411b-f461-466d-c15d-08de2ba2999e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?S2xpUkF6eXlTTk4yYkU4eDd1UkRUb054akhVOGFhVzdWYWlOWnEvWjM4Ky85?=
 =?utf-8?B?eUMvOVFPcEQrODV2Zm1IajNNY2dPemZsOXpuc1lTZXpnRkY4Nm8yalRiTVls?=
 =?utf-8?B?Uy9jTzhIdnJzaVM2RWVaTEVHc1A1T3lMbUFLQ2YvTUxRaVE1L1pyZzdzTFZt?=
 =?utf-8?B?bFBnRjNRYlIxbWlYZzV3OHp0S2tvdHFYNEpsQndBQ1dpcGhmT1JjK1ZTaTNY?=
 =?utf-8?B?QVJOR3NudUZqajljdVpTeUV1eUlQTmpQdjA3UDd5TVpiOXg0QStpcVNPaVpO?=
 =?utf-8?B?TnI4alVlZWRsZHVvOVVodGpwY25rSWpscXhBdzJNVitnNEovbHhTMm1RZ2NO?=
 =?utf-8?B?bGQwcjUvRWg3Vm5JUVMzWGhzemVOdTkreEhhb2FDYVpWdVlYWnJCRDc5L3A1?=
 =?utf-8?B?ZHBOYnZVK28yOVQveG5jM1k5S3UrRGJrUzkxSE1lTkpERWFXUFVIZmJoUGNE?=
 =?utf-8?B?TzlDZzlmbE8rNU5MVXBFTGpTcmkwSzBJYXJjMTdmbjlpOEo4cWlndWJJR0J5?=
 =?utf-8?B?MDVqTG5xOXJxM1FsRTBUQWhLZW4yMDVVdVhEWmhaUGIrNDM1aEsyL2RwUFFm?=
 =?utf-8?B?QUI2ZjdNODhVTE5rckE1OEhqcDlCL3pkY0FEaUZyTDdSOW1WMnd1aWg3MVA0?=
 =?utf-8?B?OEFHek8zbU1odExMd0E0V0NlbHc3ZmVJckRNVjZDWThmVkhoeUdFMUpZZU1j?=
 =?utf-8?B?anhWZmZiditvam00NUZsaHYxL0xuaXZpOWpmOGxZZ0RRd3ZMWlMvbDVCMENI?=
 =?utf-8?B?c0xwY2FvU3NqcGVVSU9sRmVhNXRLWVFZckR1TzVrandMdHF1R2JsWEtQOXZv?=
 =?utf-8?B?SlZqcXN6cU81TmlVWll2YTY1VU1EVHBzdU9CcWZ0MUVuYlAxQU8vRVVpOFhq?=
 =?utf-8?B?bk5XczRHaWxuZFBnV240N1FCYnB6d0pxNjJ0MC9Tei9iYkljNlhMVEoyWXNy?=
 =?utf-8?B?QUR1SE0yUXlxWXJMZzdLMHdTbnRYTzhjUG4zeks1Qll5UVZ3VkFxeUFLUS9U?=
 =?utf-8?B?alR5bG1kc1UvQ2gwREl2Yyt3cWtTbjkxZmtBaElwcXVuSEZTT05LUERNWmQ3?=
 =?utf-8?B?VC94SHRpc054UlZ6RFlmbnpPcTlDc1ZJY0ZCNGppckRlSHM3MyswYXVNeVpv?=
 =?utf-8?B?eDRBdnVqeTZ6dUcxYkRiV0tLODZDUUsyS3hVQjJBT21hUUxqbk1oTGVyZWto?=
 =?utf-8?B?TW1mNWRId1ZLUGJGbll4ci9Wem50MjNRelhhNnJ2czZpR3NQNVkwVFBtOFRm?=
 =?utf-8?B?eVFQODhLeXVmZkNvc09RK3NJbzBsQUZaV0s5RE9kU05IQ0ZjOXFRUER0bFJC?=
 =?utf-8?B?MEVZNEVRV200SHhOcmlUT29td2s2OFVtdGszZGlOYktRdVhQcWpvRTZsb2M5?=
 =?utf-8?B?NE1Va0grYXNFV3Raa3RubHZ5M1FZZDNWTkdSZytQVi9NNUQ4SzlWVU5LbjJp?=
 =?utf-8?B?UTlpcXUrckUrWUhVTlRSTVNTZHh6RWpLYkVoQXg0MDNnaVBBNEdMTHloMk1a?=
 =?utf-8?B?d0ZiU3ZtbFU5SG9acjZFMjNubEc3a1FyUVV0eVpKR2dHOWJKWndqT1VVVkwr?=
 =?utf-8?B?VE0waEV5c3VzZHRyU2YveFNQNnNTdThnZlNuWWhHSkdRNUpCZjAyNnRUcmpB?=
 =?utf-8?B?YkZ3YkZjWDhHVlRQODUzOEpHdjZVcE80YU1jbkxrVVBta3hxWVdEcG9nYVNt?=
 =?utf-8?B?Z2tGTVEwaWZsYjZxb1VwaUlWL05TM096OXBDREdRV0JNVm5pbWxsYkV4WW9j?=
 =?utf-8?B?a3g0a2hBRnMwQ0hDbi80MGtVVjlPaCtPcmt4c2tiNWMxbzdBREM5Y2ZTZXBq?=
 =?utf-8?B?b3dPd1hMbm9MYUdvOUlndHZ0SlhWdmpycGxKOVllZ1R5TFIyeUE0d2k5STVI?=
 =?utf-8?B?SDNJbjl0WThoblpLajJwUnJrUUhBMFBmb0N2bDlrWlBYbllFK3J5bVU4STVY?=
 =?utf-8?Q?KIEtpxpCxMLJBbD9LWt2loe/QOQPgPK1?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dkliRkJQcll4TVpOK2ZNTmxweFpxM2lyNmJwaVNlbFU2OVYrSEZHcXpJNVFn?=
 =?utf-8?B?Y29odkVHS1ptUThUOVk1Z3Jma3Y2aHZ5Uk5oQnV2NTR0MkRIR2FmRFNxbTlB?=
 =?utf-8?B?ZVhyZFU4UzFBZmdIZFJmVi9oUUJwdEt4dUY4RC9uRUxQbmI4dzhYQWV5dmUw?=
 =?utf-8?B?Nlk0UWxOZG04TGZ6ZnBjN2xXTnFnUld4MDl4RjFwSWlIcVpxM3RLSElocmtH?=
 =?utf-8?B?cUp0QzV2aTFMWVVUNEVlSjRWd0dHeUtYOUIxZEtYaTJxWFdRZ1JBZklCdmRX?=
 =?utf-8?B?bGxwcXhsUkdTRzFuRmFrT2FpTm51UmxuTklPb2ljQngvakZKWmMxMk5iTVpC?=
 =?utf-8?B?dDNVQmpQZnJDbmJ6VUU3Yko2eWVOTGJVU2thOGJXMUxpdnJpc20wNmZjY0F3?=
 =?utf-8?B?bm5VU29sMjdTZm9JdnNLL2I0SzVVS2tJOS9RWlBUQTJvRXpucEU5TEhta29C?=
 =?utf-8?B?S3JvdHhXQlhsQ2h5NDVkMStIZVFHVGdRaXNyQUZ0S1NxWktjdmQydHdkc1pm?=
 =?utf-8?B?M2JCV2JjeHF1VUd1VmxrNC91dEN3amtUNURqcmYxdnJkb0FkRzhacU42NVdR?=
 =?utf-8?B?RngrNVZXZ0wxQnNmdmFNZk5ob0lvTGJUT3pnaXY3ZnU1VFJvVitvcm5jMENz?=
 =?utf-8?B?OWtqSml0c04xR0VUcklQSkpSdkZsZjZaSEFPL0NJdFBtVUFDV1p4TWJBTTdV?=
 =?utf-8?B?WHJkTW8zaXJ0V2R1WGVQam0xQWpUd2pYeURqL3o4RVlEdkVpV0hHOE15SjVl?=
 =?utf-8?B?b2g3WEJ5Y2toNWFNblc3TGljME5EbEtvTnNPMnZyb29CbVk2OXFkZUlwbFZw?=
 =?utf-8?B?WjRwM0phYVQ1bzlKVHUxTmRxTElETnFPYVBKcWI2dHF1UHEvK0FxVHFnVk82?=
 =?utf-8?B?WXF5Ym0wdEZVZmw0VysyRHlEbU05UFBOd0NHMlF6NlZqU0dQb05OSndLSjRo?=
 =?utf-8?B?WDlMd0VQbm12ZG9USDBKVUhtVnZWQTl6NnFmMjBhSEpPaFpVZUNUaDRIWjF6?=
 =?utf-8?B?ZnVTOUpyYlp1T0MvNW1qblF2aFpVNG92WjM3SlBKRmVUSmhhNHlHNzRjdUhp?=
 =?utf-8?B?UVhuVjhFMGxRRTJtaTBSN0o1QU5WMzEzb0RZcmozczE1U000WStoUVA5ZkdC?=
 =?utf-8?B?TWwxMDVlN1ltcVZzTGNzWTFPelJwaWpJVk9RZ1lSNUx5OU91bVMxcnQwcHIy?=
 =?utf-8?B?YmF5V2lSWHdjNDZXZ3ZPSlBTMzdPYlN1NjZXL0F5VGxZSTBVZ1J5WFFDS2pW?=
 =?utf-8?B?ZURKNTVDQmFnbDV5cUwzTEFnVEhkYml3bnFxbE5BK2dESlBMYlEvL3FMa1pi?=
 =?utf-8?B?c0dYTjFnbVl1YzJEUS90S2dDcFQ4UW5mRDBrS0dmc3dlR2lYWlFiYytoUEhx?=
 =?utf-8?B?N3U0WkhpNlJVV010RGU2QTVmdTk3NGFBUU9xcUFGYzBsVE5sYzkrL0t0L2tG?=
 =?utf-8?B?WnN0cHpUSlVZWFhiY1NOL2pjWXNJcVRhS1dnWlZ3dWNUbmJacVRFY2V6LzBM?=
 =?utf-8?B?Ylh4OFNtOEFzMUpyb2tyMjd3RTJkb3ByditRWnBQSFZxY3hDbVVwa29UaWl5?=
 =?utf-8?B?N1lDU1JCQzZ1WFdBOE9neUcyd21aS1FUenoxZ01BRUtZOGVaVzRjWmd1RzZL?=
 =?utf-8?B?eEM3Q1RtZ0xaRTNtUkYxcDJiWTAzdW43dGZiWmxNZjVTeklzWnp6N1JSa29G?=
 =?utf-8?B?WVN1WUxuWFdEUUlXOXIwZlhQNXdjUHVyUjQweVNkOVVsQ2xRQkZHckQ0K1B0?=
 =?utf-8?B?VTkrMUwrNXVERnd2cWd4REEraDZzS2J4NEdRSEg0UWJydFpMbFk3UFlkcVJy?=
 =?utf-8?B?dVNrRldNckVNSFRDVlZHR01JOVI2RitWcTkyZGwvN3ZWOXVPODl6UXpyZDdT?=
 =?utf-8?B?d0tHSVZPa1k0RmRJWXdzOWdQcDQ1OVowUzBxUndHWEtWd28yNmdMTHBPNFE5?=
 =?utf-8?B?Mk9jMEdrTGdVSlh1S0xwRW9xU1V3T1p3azM2WjJHL0dOZENwbmwxK3ZJT25U?=
 =?utf-8?B?V05jRDY0WlBDalBjRVA1YndJcGZyMnhTc1JFRkdKZWt6OGNJaVZwZ2EwUXVm?=
 =?utf-8?B?REk3MWphUnlrTGdxRGplWlNveDVsbHJacVg2VUtlZ0lWQUpiNzRTQ3Z3MkJm?=
 =?utf-8?B?eGwrYUdaU05qeDk5eFNFcVJTYWxLeWdFU2ZkYVBIZmduR2tRb01EeFNIeGky?=
 =?utf-8?B?amc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e08a411b-f461-466d-c15d-08de2ba2999e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2025 21:44:09.6223
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JYm3gcj1/Bq/SAl6ATGly4H+6P70VH+lmW342kqghv+p9WfdSDMEtnTBBVmZ/XtszcBkteu56KybPx2EHcAUuxuW3PfQAFs2KUFmWyQtVNY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7501
X-OriginatorOrg: intel.com

On Fri, Nov 21, 2025 at 11:16:03AM -0700, Alex Williamson wrote:
> On Thu, 20 Nov 2025 13:36:42 +0100
> Michał Winiarski <michal.winiarski@intel.com> wrote:
> 
> > Resetting the migration device state is typically delegated to PCI
> > .reset_done() callback.
> > With VFIO, reset is usually called under vdev->memory_lock, which causes
> > lockdep to report a following circular locking dependency scenario:
> > 
> > 0: set_device_state
> > driver->state_mutex -> migf->lock
> > 1: data_read
> > migf->lock -> mm->mmap_lock
> > 2: vfio_pin_dma
> > mm->mmap_lock -> vdev->memory_lock
> > 3: vfio_pci_ioctl_reset
> > vdev->memory_lock -> driver->state_mutex
> > 
> > Introduce a .migration_reset_state() callback called outside of
> > vdev->memory_lock to break the dependency chain.
> > 
> > Signed-off-by: Michał Winiarski <michal.winiarski@intel.com>
> > ---
> >  drivers/vfio/pci/vfio_pci_core.c | 25 ++++++++++++++++++++++---
> >  include/linux/vfio.h             |  4 ++++
> >  2 files changed, 26 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> > index 7dcf5439dedc9..d919636558ec8 100644
> > --- a/drivers/vfio/pci/vfio_pci_core.c
> > +++ b/drivers/vfio/pci/vfio_pci_core.c
> > @@ -553,6 +553,16 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
> >  }
> >  EXPORT_SYMBOL_GPL(vfio_pci_core_enable);
> >  
> > +static void vfio_pci_dev_migration_reset_state(struct vfio_pci_core_device *vdev)
> > +{
> > +	lockdep_assert_not_held(&vdev->memory_lock);
> > +
> > +	if (!vdev->vdev.mig_ops->migration_reset_state)
> 
> mig_ops itself is generally NULL.

Yeah, I clearly didn't test it with plain vfio_pci.
I'll fix it in v2.

> 
> > +		return;
> > +
> > +	vdev->vdev.mig_ops->migration_reset_state(&vdev->vdev);
> > +}
> > +
> >  void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
> >  {
> >  	struct pci_dev *pdev = vdev->pdev;
> > @@ -662,8 +672,10 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
> >  	 * overwrite the previously restored configuration information.
> >  	 */
> >  	if (vdev->reset_works && pci_dev_trylock(pdev)) {
> > -		if (!__pci_reset_function_locked(pdev))
> > +		if (!__pci_reset_function_locked(pdev)) {
> >  			vdev->needs_reset = false;
> > +			vfio_pci_dev_migration_reset_state(vdev);
> > +		}
> >  		pci_dev_unlock(pdev);
> >  	}
> >  
> > @@ -1230,6 +1242,8 @@ static int vfio_pci_ioctl_reset(struct vfio_pci_core_device *vdev,
> >  	ret = pci_try_reset_function(vdev->pdev);
> >  	up_write(&vdev->memory_lock);
> >  
> > +	vfio_pci_dev_migration_reset_state(vdev);
> > +
> >  	return ret;
> >  }
> >  
> > @@ -2129,6 +2143,7 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
> >  	if (vdev->vdev.mig_ops) {
> >  		if (!(vdev->vdev.mig_ops->migration_get_state &&
> >  		      vdev->vdev.mig_ops->migration_set_state &&
> > +		      vdev->vdev.mig_ops->migration_reset_state &&
> 
> For bisection purposes it would be better to enforce this after all the
> drivers are converted.

Makes sense. I'll split this patch.

> 
> >  		      vdev->vdev.mig_ops->migration_get_data_size) ||
> >  		    !(vdev->vdev.migration_flags & VFIO_MIGRATION_STOP_COPY))
> >  			return -EINVAL;
> > @@ -2486,8 +2501,10 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
> >  
> >  err_undo:
> >  	list_for_each_entry_from_reverse(vdev, &dev_set->device_list,
> > -					 vdev.dev_set_list)
> > +					 vdev.dev_set_list) {
> >  		up_write(&vdev->memory_lock);
> > +		vfio_pci_dev_migration_reset_state(vdev);
> > +	}
> >  
> >  	list_for_each_entry(vdev, &dev_set->device_list, vdev.dev_set_list)
> >  		pm_runtime_put(&vdev->pdev->dev);
> > @@ -2543,8 +2560,10 @@ static void vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set)
> >  		reset_done = true;
> >  
> >  	list_for_each_entry(cur, &dev_set->device_list, vdev.dev_set_list) {
> > -		if (reset_done)
> > +		if (reset_done) {
> >  			cur->needs_reset = false;
> > +			vfio_pci_dev_migration_reset_state(cur);
> > +		}
> 
> This and the core_disable path above are only called in the
> close/open-error path.  Do we really need this behavior there?  We
> might need separate reconciliation vs .reset_done for these.

Some drivers do the migration state reset explicitly in their, some rely
on reset (and .reset_done) being invoked.
We can remove it from here if we just call migration_reset_state
consistently in each driver.

> 
> As Kevin also noted, we're missing the non-ioctl reset paths.  This
> approach seems a bit error prone.  I wonder if instead we need a
> counterpart of vfio_pci_zap_and_down_write_memory_lock(), ie.
> vfio_pci_up_write_memory_lock_from_reset().  An equal mouthful, but
> scopes the problem to be more manageable at memory_lock release.

And it also needs to be called conditionally on certain paths.
Which means that it will take an extra argument (whether prior reset was
successful).
I'll try this approach in v2.

Thanks,
-Michał

> Thanks,
> 
> Alex
> 
> 
> >  
> >  		if (!disable_idle_d3)
> >  			pm_runtime_put(&cur->pdev->dev);
> > diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> > index eb563f538dee5..36aab2df40700 100644
> > --- a/include/linux/vfio.h
> > +++ b/include/linux/vfio.h
> > @@ -213,6 +213,9 @@ static inline bool vfio_device_cdev_opened(struct vfio_device *device)
> >   * @migration_get_state: Optional callback to get the migration state for
> >   *         devices that support migration. It's mandatory for
> >   *         VFIO_DEVICE_FEATURE_MIGRATION migration support.
> > + * @migration_reset_state: Optional callback to reset the migration state for
> > + *         devices that support migration. It's mandatory for
> > + *         VFIO_DEVICE_FEATURE_MIGRATION migration support.
> >   * @migration_get_data_size: Optional callback to get the estimated data
> >   *          length that will be required to complete stop copy. It's mandatory for
> >   *          VFIO_DEVICE_FEATURE_MIGRATION migration support.
> > @@ -223,6 +226,7 @@ struct vfio_migration_ops {
> >  		enum vfio_device_mig_state new_state);
> >  	int (*migration_get_state)(struct vfio_device *device,
> >  				   enum vfio_device_mig_state *curr_state);
> > +	void (*migration_reset_state)(struct vfio_device *device);
> >  	int (*migration_get_data_size)(struct vfio_device *device,
> >  				       unsigned long *stop_copy_length);
> >  };
> 

