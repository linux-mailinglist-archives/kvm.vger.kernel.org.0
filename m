Return-Path: <kvm+bounces-63837-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 29752C73FDD
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 13:37:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 8AD3C3578A7
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 12:37:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99FA6338596;
	Thu, 20 Nov 2025 12:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lxctiXan"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B2A1337BA7;
	Thu, 20 Nov 2025 12:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763642244; cv=fail; b=ji9eOLAFLwC7N3SYWz2j2HmYp6jo/gr5GtoYDciR8OoD4vDlUQXdSAMMt5fzUEqKLG6C74bLT9ySa/1g40q0PJFOQ0q5/glsU+z9D7CkANqzVZK+cvHLW2HSi5Aj0uAkDp2NGNOj+697Qaq4uJV2pb+smhnxnHZeDWG8MmQFEZQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763642244; c=relaxed/simple;
	bh=t4Gx8n26CZ7tGqi+szkZ7Uca47wlQs3Za+MO8JxfDYo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cnOe5pzVoe8gbHahJz1uPf2kO8E75rhgB3pmOPRjGa7dw01qTXtWfGtzxKlN2/KufhAGf3Dh/PWcVfz5MLg35NfRnDXJMi8pQu2aZlr+xEuyX3ZxF54lrk0c2wmATj7PuV4XxLGqCx9Q55wtG6WlJkdZQ1jQvD8LjhFd9OMlJcE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lxctiXan; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763642243; x=1795178243;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=t4Gx8n26CZ7tGqi+szkZ7Uca47wlQs3Za+MO8JxfDYo=;
  b=lxctiXandrWh+TGZU5aPH6NYvBIP9RjmQChKq4P5clFaph6uYOFjp5xa
   ZPJk4VBLrvah6WcdjErTVos3JZgemfwiMolOm/k70Lq/132V+JT7ENbgz
   uGZXChLwHokFOgLnJsfqGfiSxZvBrwmhsp7S8iq/Il+AI9rKEnvkgjEAd
   Ah4ToAdHPtVFKvTaNFFnFqRsKi3r6tBECmeiaNXpQn0AhnNEXqMbZdfX8
   BicWd6o8URDTNuOURtQlCKH7MPgtfSkWMggGUMDqDalfoowAgt4YhYD2H
   bEohrSbBPzS3GsippnxCRHrLCgcCMY0ZLdYv32UiFAdjtb9+pT6slvRJr
   A==;
X-CSE-ConnectionGUID: 55Zi1P0qTBy+5OV2srDXrw==
X-CSE-MsgGUID: 36qp4uGtTs6Onmdhj0l+jg==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="76037878"
X-IronPort-AV: E=Sophos;i="6.20,213,1758610800"; 
   d="scan'208";a="76037878"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 04:37:21 -0800
X-CSE-ConnectionGUID: 4KXtJG/XRPyC0Mna1/zkXA==
X-CSE-MsgGUID: 4N9ATYHNSrSU0d3msZBbuw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,213,1758610800"; 
   d="scan'208";a="190633904"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 04:37:21 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 20 Nov 2025 04:37:19 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 20 Nov 2025 04:37:19 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.20) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 20 Nov 2025 04:37:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c4ZgkZD3dZfdfmbwy91wJBoNzxtMtOFkqsC00LaGvT0tNuZlNhmRZ5o9QnqCOGzcuQTIC7QL9F1lm1DDmSHBK8TlKJaMxj4xAxH+u5GJR/kJZ7GxmcyNjB5v1FOiCXD0Gsg3fHjWcKsoCw0IPIkxJBT6JyVQ3Frd56s2T8yE5mZpCUkALYnGyuV1jPDi56+KljEq/+mXnnpC0+KSIlxNDkrS6f5cMnycsW3ZZwnmmjLQ8/NmOes8oMy99sAPMWHYXphFUqZrtKKIWnwQLLtQoWCNiNTm/A28rcM0vV5bAPe5lailM3eJvh3fceEDx+prnZ3WXMQBRrpvgLjIuWv7CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xVslwVotWzt33S7oO0khZ7LB+QcP8eU1Dp3oGdoAAAQ=;
 b=SVOkIBpzP5HpxZQOx0sGNhgKk/voMJqXHNGa7MIFPyFpnUDfl3+pDV+f0W7uKn8CngfYGAyMBKrmm/GhUO0DrmDRmpoAEnWYsxawtjQwhIQGQjm408d+UvczlapZVdU6eEsKthV0pYbiu/1E6xHyrziNo8Wb9hLmFjJtUstft1JugHsDacmNC3DSoF3M/hIXPfJZ83uGW4T5yRbLhhbCzgHUOQuyAibQhQf5uUMmmeeXVotMgKEA0YpuCaB11gswygv7hx/DMx5v9Qq0WTfXSyaoebsGa9R5zig7dRqmttt36Tw7VoPLxWs2dM/x2xJIj44yGozFoqYBbYaAnm4e4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5373.namprd11.prod.outlook.com (2603:10b6:5:394::7) by
 DM3PPFC3B7BD011.namprd11.prod.outlook.com (2603:10b6:f:fc00::f49) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.11; Thu, 20 Nov
 2025 12:37:18 +0000
Received: from DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39]) by DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39%5]) with mapi id 15.20.9343.011; Thu, 20 Nov 2025
 12:37:18 +0000
From: =?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Alex Williamson <alex@shazbot.org>, "Kevin
 Tian" <kevin.tian@intel.com>, Yishai Hadas <yishaih@nvidia.com>, Longfang Liu
	<liulongfang@huawei.com>, Shameer Kolothum <skolothumtho@nvidia.com>, "Brett
 Creeley" <brett.creeley@amd.com>, Giovanni Cabiddu
	<giovanni.cabiddu@intel.com>, <kvm@vger.kernel.org>, <qat-linux@intel.com>,
	<virtualization@lists.linux.dev>, <linux-kernel@vger.kernel.org>
CC: =?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>
Subject: [PATCH 3/6] vfio/pds: Use .migration_reset_state() callback
Date: Thu, 20 Nov 2025 13:36:44 +0100
Message-ID: <20251120123647.3522082-4-michal.winiarski@intel.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251120123647.3522082-1-michal.winiarski@intel.com>
References: <20251120123647.3522082-1-michal.winiarski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BE1P281CA0279.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:84::7) To DM4PR11MB5373.namprd11.prod.outlook.com
 (2603:10b6:5:394::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5373:EE_|DM3PPFC3B7BD011:EE_
X-MS-Office365-Filtering-Correlation-Id: 60668499-c5a5-4244-98ea-08de28318ac6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?QTVhcXNrOGhTdmlwazdwYk9majdFTnQ0cGlhd1M0WUJkN2p0R2VWYjBUZDBV?=
 =?utf-8?B?Nm1YZ1djekthNWJiMGlrRGEzRGl3RDJRclpkdmNBeUhXYm9lQXhvRThMRHYr?=
 =?utf-8?B?cGhIVy9BenV2a29Ba2R0MmRMZkpwTkYvSTJHYU9TaXVjMnBseWJ5UXAzYWNq?=
 =?utf-8?B?aU81WXYwVUc5Y0VScW0vZk9vMWxaTWlIK1Z3Tm9oQTJSSXZ2dHRLVitBa0Zu?=
 =?utf-8?B?SWFDeVo1Z0U5NG14UFVnempwTE5rTUNXSzRvWXZGYk5NU1N2Y0svOU1WSHN4?=
 =?utf-8?B?UFgybDk3bzhwVjhuYzgxclR4b1RmZEVBV2J5enRrcUw4L09ST3dMMVYrWVdP?=
 =?utf-8?B?aVhPYXViWWJkSWVCVTVLVXFuZ1dGK2dMbEN1dk1kWGdOZGhHSEU1SDJYdGl2?=
 =?utf-8?B?RW94aFVPeVN6cFdWM1kranR0bmFONG5FbTMyVk5DSktYRzNSbVlqbkRkQU56?=
 =?utf-8?B?WGRXQktVeXZISWFyVENJczg5V1ZxUXQzZ01EMzJWU096eWZDeHpIaUxWa3dl?=
 =?utf-8?B?WnVOdk1CdXpoUkhrTkY0dnlyVDMyVEZySFM0LzF5TlNPUXRQeEk0eUN5MUlC?=
 =?utf-8?B?N0tTQjBRRG5kb1A3VVVHcC83MmtOa1VGQTBMRmxTVVpzUFRZNDN6VWhlU0hD?=
 =?utf-8?B?RWRqdTUwN1VVYm9vSzBZZy9pNDBTcHBHWDl3bWI0TmNabjllMnZnMzFTWU5O?=
 =?utf-8?B?cVUxNWFncjZNRWdWd1llV3dzaWFBSkJYQlRxcVpVMHBRMFNTemcrQU9PV2kx?=
 =?utf-8?B?L0djS293bDJPcFRJTDNDb0pjN1dRYlg0U1J0allwT3JVYVdpdk04Um8xdXh4?=
 =?utf-8?B?WW9HVjU5ZnZnNlorNHo0SCtqYmtyWTNIbTFDNWJVM1hzOHhrTXB0UFAxaUtr?=
 =?utf-8?B?Y3BTWDNYRHFQbSttK3ppY1RCN2pPMTNsNEUzb1JhMXJDUnpWL1JxaXVveUJN?=
 =?utf-8?B?bzNpMStuM0dLYzFyaHRoZlp6aDZaU2NyUEE1aHBUQ1Ezc0dIQWs0ZFFZSTAr?=
 =?utf-8?B?ZGJjWjlFdmhVY1NZb2UrYmFlV1hxb1ptb3AxRzBxemUzOEp6a0NZWDc3OVVJ?=
 =?utf-8?B?WDN0M0NycjM4SDkxWHhTUHd1WE1DL2pjNE1hdWJnQlh4TGtxc1liNFV2WVJW?=
 =?utf-8?B?NDB1Z1puZ1RISHY3ektxTGM1Uk1VSnBJOXVMd2h6TmtWMWxaSWJLbHArTlhn?=
 =?utf-8?B?Nng4QndTc1NpMGtROTFKclJ4SVVjNGRuUktZdHBjeWdJcUNBUFFDbTNIN2t2?=
 =?utf-8?B?YTJkR2Npd1I1TncvTGtMOUp0RlNKV3hScXFYQ1QwQjQ1R2dUS3E0VHcrcTBU?=
 =?utf-8?B?OUQ2b2RWRk5mZ3FSRU56cVFvVDduM2RqaGhNdWdOUlRCRVYwMGZhek14OUFv?=
 =?utf-8?B?VFBoRkRySkM3ZWp6Z1MwakF3NHVJRGdvbyt4RmZIUU9EbDlWcHdWdnFBR1hE?=
 =?utf-8?B?eWNyMzJCM2Z3UUNXc3V3aWZ1WTV1akxPL2tORDFwTEFYOXlWVDk2SWEzRnlV?=
 =?utf-8?B?Q1lPRFFVU3NtbVlZRGYwWWttbFRUSmx5WFoxWmxHWlJWT3V5MUpOOWMxOGpx?=
 =?utf-8?B?ZHFISHBhaUZONERCNHVpckNQM3FocFhyWlpTQ29DR2hiUzV0cEY1YmhpcWI0?=
 =?utf-8?B?Wk5YNmpGM1hnNW40dWFYWGwwdDB6UlE2OWdZbXVwQjZxdEs2RDRodnkxMmFm?=
 =?utf-8?B?bS90dVM3OHdSUUlzZWFjdFBDZ043MHpKdnZ6bWtsdVRBYklzZDB4MEJoZUhW?=
 =?utf-8?B?MlRNTlo3MDY4ZURXeUV5dE1uQWhldGpCNll3QldiZGQ5VFJYRHh3NkF3U20w?=
 =?utf-8?B?NmJpZUxwVnU3K05hdHVNMWFJbWxldXNkNXhRWlIyMS9mT0JIMW5yWThpcklk?=
 =?utf-8?B?M3Y5SytyU2NRajdwZU5rSCtCelZMQWZFL082b05uQ2ltVzBnemRTZ0dFNzgw?=
 =?utf-8?B?K3UwVktJaWJ1Rlh5WVJGYTJtNlp2UnhsTVloeVNJNzBnNmVFRmR3MlFsME50?=
 =?utf-8?B?MEJPbUtITFg3dkQ1RDdudnBvWUhoYUNnQ1Z5cnhzMmxEdldhdnhONm1JR0Rn?=
 =?utf-8?Q?b3UYtf?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NW53Z0Vlb2Z0bmE3Y29KM2ZTcUxlUTlOeDhuMFVRbW5tejBUWEozZ3R0dnA1?=
 =?utf-8?B?QklQRi9pSC9obE5ySG5qWXVTZnhkN0YxdDI3eVkxZzhEZ3hwTUhsT2VIOEI0?=
 =?utf-8?B?akROTXJhZGQ2aFhSdnhVbmdMNDRZVEtCbzJ6eEdiMVBFeXRSS0lEc1dPa3Z3?=
 =?utf-8?B?RW1zenptMGN6Z2tZNlkydE1oMmJmeVNRVnZZRTZnTGF1WkVhSGFGdDlmcVJq?=
 =?utf-8?B?bzdjd2VwKzJ2VFRvMFZncHRsMmlCcUE2R0RtWlJsY1RYcURacUFKMVVDanV4?=
 =?utf-8?B?NlJsRlMvTGV4Q3VCVnJielZGN0p4SkVMQWtUSTJNRnVOZzc0UE5URS85TXNw?=
 =?utf-8?B?elBTNm55cE4xbC85TG41eFN6QmdYU0ZyYklSY2gwbTB5K09JYnZIUXB6VjVv?=
 =?utf-8?B?VXBycThlVk93cjFkRUs4ek5TRStXRUpqYWV3cWpENFRpV054S29DY1p1Z1cr?=
 =?utf-8?B?VVhSV2YxY1ZUYld3cjEweTZxdDArNUZLTUkwVitVbyttWnNrR2FsZ0hyRnFY?=
 =?utf-8?B?QzNPN0hvOWp1dXJFZTJaQWowNlNzYzBGZ1NSbjNZWVlmQjNwdGZlM0sxVUN6?=
 =?utf-8?B?WjRYWFNoSUE5NU9Uc2QyQjJPSmdwR1ZrUm9OOHRSTStYQnRncXdYWG82NTFV?=
 =?utf-8?B?V3Y3Q0ViTzAzMFdXZHQwZnhucFFySG9vclBCaS9HYzhCNWZZY3MvTmtBUEpw?=
 =?utf-8?B?ZVQyc2lPM1lSSGtiMG9nd0k2RHVCQkdUeDhGS2lQR3Q1RElTNmg4NFY5cUsx?=
 =?utf-8?B?aVduU3BLcXNZMWE5UVBkbzZPTGxaN2o3dk9TYXlxY21QZDZWb0VVaEI3MmRo?=
 =?utf-8?B?Yk0zZVJLck1xczNqOEZFM3lDdUw0R0Ewc2dyazQrRWY0Q1RUV2h0bmJHem55?=
 =?utf-8?B?QjM3cEh5cGNNOUpzdEpOQW5xK0hYUDhxaGk1TzZaTDFUS2VTMUwxVjJFaHcx?=
 =?utf-8?B?ZVYrYnM2SDRyZ0hOa3ZnODhDV3JLS0lYWSt1Z2pBTUpKdkdkTU9XM293Y09C?=
 =?utf-8?B?OVRVR28vK25TNzFuMlEzaGhwbTYrRnZ5N2dYMGVoR2VCeWp6YXJYc04vdmlr?=
 =?utf-8?B?OHlJNGptaW93SDdYN3d0b0Jyc253S1MwYTR5OSt0bzE5UFZJclZMR3NGem9J?=
 =?utf-8?B?VFZmL25QUGFlZENyMFAzZjNQS3M3ejAvRE16Z0RRcjk3UFIySGpwUi9yOWlX?=
 =?utf-8?B?VkRHRFlHQWpiWCtIbjROMUs0R2V2ZnhpZlRuTnBPVTl5clZDcE9WRklXRUVR?=
 =?utf-8?B?a2dJUkFveDNKYmxuR2hDc2tjYnlVbnB6UnArcUt2N0grS1dRTDZRUUNvVTNV?=
 =?utf-8?B?dnVDZlhyczBnTUs1VmpJSmozcUxLcGdHdVVXTXhZaHRpK2FZSldSYUU2MFJw?=
 =?utf-8?B?enhzZGdRTFVMREs1Z3FKSlJneTNtK24rVHZiOUVLeW4xcUlERzhYTzZNK2Y5?=
 =?utf-8?B?WmoveEdzVTFYaW56cjhrenVYMDhHcnRDalNlSVJscjFERzB2czRYWnRPUlpP?=
 =?utf-8?B?OEs0dmZ6WVlUU2lUVExuZXR6end4QXRUcTROZDVYU0pVTlNEbHhOeVBCNmYw?=
 =?utf-8?B?OGxkZ1hTMmJSWjVVdVZTRVgwRWs5UU02ajhGdElUWVg1b0lId3ZGRzR4UHlM?=
 =?utf-8?B?OG1zK2tBSkkwcWlnV0x5VWpxM3hwNWIyZFY4VW05L0l5MkgrNG5CcmkySko2?=
 =?utf-8?B?bWFneXcvMUdKbk5PVjF2RG5kRlRrRkhPdkkwa3hVRGVTZ2N4VlQ1OStjbFV4?=
 =?utf-8?B?T3ZXS1R2disxbDVqSEg5RHVzbWJRdlBvSUh3Um9BNHRWSTk3NHlvOUlBd0xK?=
 =?utf-8?B?SFp3QnNhZ1lwQ2Y4cEZFMEtGSGRCSWo0V1Z5azFFWEdYQSs4cUZCWC9UN2c4?=
 =?utf-8?B?dGZPTGc1dWNPVVh4WHlMbjF4cnBGOFFsYWVnK3ZTQ2JiUXRTZ25pS1g0NjZR?=
 =?utf-8?B?QW5JTWV6MldZdHd6VTAxd2tUeVNRN01YTHk1SzI1aUlEclo2VFgvRnF2WVVS?=
 =?utf-8?B?QUI4M2JqU3Y1Z083NzNDVTlNVzhzbERSaWE0dzdZckloOVNlMkxtS3R1RG01?=
 =?utf-8?B?WXZWTTgzeDdYMFNnOC9lc2FqUWJvMkNybEgrUWdtL3JKTDlSSGlyMUVOZEhv?=
 =?utf-8?B?dnZNRUVlRW5tZG80RVMwWnplZktxZTJ4S21ZMWVxa2FyQnlVb1l2WmVtVHBy?=
 =?utf-8?B?T1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 60668499-c5a5-4244-98ea-08de28318ac6
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 12:37:18.1237
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QWg6KIoRf2f3EkxOXH8MNia2Fv0E6RNWgkWqHAz9MO30pwb27zCFjw3aeOOaEOmHcro1mnK3KIhT1CV+s20R+ryjGIla1kvZxBrtuV/TXis=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPFC3B7BD011
X-OriginatorOrg: intel.com

Move the migration device state reset code from .reset_done() to
dedicated callback.

Signed-off-by: Michał Winiarski <michal.winiarski@intel.com>
---
 drivers/vfio/pci/pds/pci_drv.c  | 10 ----------
 drivers/vfio/pci/pds/vfio_dev.c | 12 ++++++++++++
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/vfio/pci/pds/pci_drv.c b/drivers/vfio/pci/pds/pci_drv.c
index 4923f18231263..4cf3d2e3767a6 100644
--- a/drivers/vfio/pci/pds/pci_drv.c
+++ b/drivers/vfio/pci/pds/pci_drv.c
@@ -162,17 +162,7 @@ static const struct pci_device_id pds_vfio_pci_table[] = {
 };
 MODULE_DEVICE_TABLE(pci, pds_vfio_pci_table);
 
-static void pds_vfio_pci_aer_reset_done(struct pci_dev *pdev)
-{
-	struct pds_vfio_pci_device *pds_vfio = pds_vfio_pci_drvdata(pdev);
-
-	mutex_lock(&pds_vfio->state_mutex);
-	pds_vfio_reset(pds_vfio, VFIO_DEVICE_STATE_RUNNING);
-	mutex_unlock(&pds_vfio->state_mutex);
-}
-
 static const struct pci_error_handlers pds_vfio_pci_err_handlers = {
-	.reset_done = pds_vfio_pci_aer_reset_done,
 	.error_detected = vfio_pci_core_aer_err_detected,
 };
 
diff --git a/drivers/vfio/pci/pds/vfio_dev.c b/drivers/vfio/pci/pds/vfio_dev.c
index f3ccb0008f675..6b29641b5819b 100644
--- a/drivers/vfio/pci/pds/vfio_dev.c
+++ b/drivers/vfio/pci/pds/vfio_dev.c
@@ -101,9 +101,21 @@ static int pds_vfio_get_device_state_size(struct vfio_device *vdev,
 	return 0;
 }
 
+static void pds_vfio_reset_device_state(struct vfio_device *vdev)
+{
+	struct pds_vfio_pci_device *pds_vfio =
+		container_of(vdev, struct pds_vfio_pci_device,
+			     vfio_coredev.vdev);
+
+	mutex_lock(&pds_vfio->state_mutex);
+	pds_vfio_reset(pds_vfio, VFIO_DEVICE_STATE_RUNNING);
+	mutex_unlock(&pds_vfio->state_mutex);
+}
+
 static const struct vfio_migration_ops pds_vfio_lm_ops = {
 	.migration_set_state = pds_vfio_set_device_state,
 	.migration_get_state = pds_vfio_get_device_state,
+	.migration_reset_state = pds_vfio_reset_device_state,
 	.migration_get_data_size = pds_vfio_get_device_state_size
 };
 
-- 
2.51.2


