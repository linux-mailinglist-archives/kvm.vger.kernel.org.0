Return-Path: <kvm+bounces-65344-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E880CA7915
	for <lists+kvm@lfdr.de>; Fri, 05 Dec 2025 13:31:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CE377306FD9C
	for <lists+kvm@lfdr.de>; Fri,  5 Dec 2025 12:31:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3597932F74F;
	Fri,  5 Dec 2025 12:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UyLQeYJV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBEDC2F8BD3;
	Fri,  5 Dec 2025 12:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764937875; cv=fail; b=n9BAYpTrFJ05Qu4krwH8DESfKd8rbDdSc3oHqN78EX+hmAfGbZ4I2OtTvKRYCmWxrWimm+S0LURwrMc6KXD8b3dlPOEaHElaQfFUXROF2SRzMjBbmRtxx9hY+s/HGLTWYUB5sMcoH38ndz6ZZ6J9Fi6Tjm8m6D+K3z5aKa6Vfhg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764937875; c=relaxed/simple;
	bh=z9VrGwAARB8i8eZTA3vUaEDrWnt9iDYy8hJx4mI4sN8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ouMtDOKBjoIMvCCSE+bM1bJGZzSTXnOMPOALbMT25dyWX8gpzqaQKlwcP9R9YSbRHcjFTLVFfqMf+Bq2AXgrm2j5521OJ1rYzrq7hNkSDJtREYn5n/71/hofuNPMWPWnkMYYO0D06Zl0hzWO8BFWcUNMUVRBmaoZErmnZ6SGaBw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UyLQeYJV; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764937874; x=1796473874;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=z9VrGwAARB8i8eZTA3vUaEDrWnt9iDYy8hJx4mI4sN8=;
  b=UyLQeYJVsbNS/utlIJ9nz3B+GSJJBhqcl+c3QB/4vBRTCR9z0ok8JRXl
   CT3rsuUhVmVYyd2+xf2F2sEAF1rJL9Jqh9EBi3+i+dV+5KQSybDHulH1i
   1Bf0l1hwICH682vzayZ8HXmBGlXfyHbIw1iygNTtl+9OL8w6VIHWDLnkO
   mjZdBUfnNx6yIzL27x/PrG9delIGDJ8J1wMUfEQQXBmTSJqH9hf3C4yTT
   o68S/4WbxJq9UlbyU0pwSJLumxsC+oWWLAkDBhqP3+qRiDZacdR1J+sWd
   g7Pw8MgAX82MBSy0PAFD6ueYWGGRlhvBqOjOYrNGqESvt/Hpg8gm0JgVg
   A==;
X-CSE-ConnectionGUID: MhakAr1lRcmeradRSV9O1A==
X-CSE-MsgGUID: 1eqi0JiBTuOCam31GBVlKg==
X-IronPort-AV: E=McAfee;i="6800,10657,11632"; a="66906311"
X-IronPort-AV: E=Sophos;i="6.20,252,1758610800"; 
   d="scan'208";a="66906311"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2025 04:31:13 -0800
X-CSE-ConnectionGUID: 0BFzs+k3STK4H1zRxl/knQ==
X-CSE-MsgGUID: fZyPU5H8SgaKFxtpZJjl+Q==
X-ExtLoop1: 1
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2025 04:31:12 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 5 Dec 2025 04:31:11 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Fri, 5 Dec 2025 04:31:11 -0800
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.54) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 5 Dec 2025 04:31:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IS9EY1rq9nbYs0BZ2V185509pWGuOqoUT2fs46aeBIRqXEq8nSp9RN3OBwilpqAkzrDcs7ldrZhZ+AJ4A1OcMluwNdGnE8tTRAGJUtolBPRvXTT6RH7SWUDJnDqt4HFZMSrvPYI3yDQY+s7ChSjpWCzgtEt4dJ6dlb8fLJVHObmda6tOyZE/X1UUkaJFYhwYSUJWGlACRk9MnV5Kf+/ldi8RjLY06dm4Wlq+WuNFaTFlBwDseZM+Ee24yKav593/Y8BO3GlfU7j+J04Htu9UBMwyFk1DhAW6oDyW6rWWO+89xKRj1829nbEiD0mGFgl7iuO5eD253S3DiY1HqSg5bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SuSMZZt9JwK5A2sNuSkIlzCgjExs6T9k160iqkR9/SQ=;
 b=w0LMIKVswWpOm+rW75Fgay32Hm+4qCQE9OedR6xm6ppj0X3OexI/zfXZ+oLkNi+8DU3qS4prnCi7Hwn2dU9ihL4sXj83aTkH8a62OpspR7S2sRuWOICVsWTweC4Lt+5T9DQ7tv8hM6Uapy7HXjzsyz3Ben55QrsKK+Ez249MgaV20AURaw2Z9BaqWPKeHB0IcQjVFxpEvZ9i3G2XG2HiyfHfDgIjdfJ84zDrI9BJdxte4Vzy0oMwUiiHOx1mvrqSOANDF64qdItGP1emLnZra2P+7ltGrTxLvnrxgrFI+mrb85U6l06w0q4UdL1qyZGE6gw4QFoB54FoCt9wjBmUxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN0PR11MB6011.namprd11.prod.outlook.com (2603:10b6:208:372::6)
 by DS4PPFDA283F46A.namprd11.prod.outlook.com (2603:10b6:f:fc02::54) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.9; Fri, 5 Dec
 2025 12:31:09 +0000
Received: from MN0PR11MB6011.namprd11.prod.outlook.com
 ([fe80::bbbc:5368:4433:4267]) by MN0PR11MB6011.namprd11.prod.outlook.com
 ([fe80::bbbc:5368:4433:4267%5]) with mapi id 15.20.9388.011; Fri, 5 Dec 2025
 12:31:09 +0000
Message-ID: <88c3e5b4-8ac2-42fc-acf0-2aec2406a7ef@intel.com>
Date: Fri, 5 Dec 2025 13:31:04 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH next] vfio/xe: Fix use after free in
 xe_vfio_pci_alloc_file()
To: Dan Carpenter <dan.carpenter@linaro.org>,
	=?UTF-8?Q?Micha=C5=82_Winiarski?= <michal.winiarski@intel.com>
CC: Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>,
	"Shameer Kolothum" <skolothumtho@nvidia.com>, Kevin Tian
	<kevin.tian@intel.com>, "Alex Williamson" <alex@shazbot.org>, Rodrigo Vivi
	<rodrigo.vivi@intel.com>, <kvm@vger.kernel.org>,
	<intel-xe@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
	<kernel-janitors@vger.kernel.org>
References: <aTLEXt_h5bWRWC0Z@stanley.mountain>
Content-Language: en-US
From: Michal Wajdeczko <michal.wajdeczko@intel.com>
In-Reply-To: <aTLEXt_h5bWRWC0Z@stanley.mountain>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VI1PR04CA0070.eurprd04.prod.outlook.com
 (2603:10a6:802:2::41) To MN0PR11MB6011.namprd11.prod.outlook.com
 (2603:10b6:208:372::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR11MB6011:EE_|DS4PPFDA283F46A:EE_
X-MS-Office365-Filtering-Correlation-Id: 230b3643-e46a-4d1d-2394-08de33fa2aed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?eUxQcGFlVzZMS29Rd1JHRmJJOFFYTE9BWGFCdFhTdkwzV2JwdkYxem1jTTY2?=
 =?utf-8?B?cmpETlRVSTZtWTM3V042MlNocUpWMkpQTFlqS3lkL2tuZ3VYRkNOZXRlcWda?=
 =?utf-8?B?VStVaFhDZ2RUSU80bFlGeGRhY25DdjVJYStFRjZ5NUgwZ240WEVVbjlXak1z?=
 =?utf-8?B?WEhRWjRiai9oSkhnTEVoZm1nVHB5UkVNM1RmNmNHSW5Xdll0aml3cEJGNjBn?=
 =?utf-8?B?KzVMRVRWMGRxWlNWcm5Kb3hFbHJLZ2RvYTNpY0tjWTB5WXgvQXBQZ1hZQk1E?=
 =?utf-8?B?RWZJYjMvbWMvNzBPWWVKN2pwbDROd25EUmMzeTJ4SzJSem5Id3hhNW1pNUtI?=
 =?utf-8?B?eWNxQ1BPeWkxNGg1RytEdU5oUHZ4TTdHTmhFQjhORTdodWZCQmVWVmQ2aUN6?=
 =?utf-8?B?WWFSaGR6Mlc2cU5aZVRQNUROWWhKdFlXTHY0ZGRkVmorY3ljOVZQcEE2cTBC?=
 =?utf-8?B?bEFIL0VMOG1JWVN6R2E1ZSt5eU9FYkhrTHNSeU9BVmZ1V2hQbDZoTytzQWI4?=
 =?utf-8?B?MWZ3cXlGaFVaeDVzako3RE9BNWlqL002NWl5SzM4SWw2bDBjM3c2dzBsOTBr?=
 =?utf-8?B?dDZLbVB4aUFJNURtM0RCTU1XZTI5cXBvSFFURXhWMkx3ZFlBbnhPOCs0aFdm?=
 =?utf-8?B?NXlFOFNPZWR3eFBvb3k4TUlJQmk4NzhOWFVWVGpPZWNZd2lOUkFlQmptd2tI?=
 =?utf-8?B?VW9VMUlaU1JiYzAvT21HQ1lncFdZbTRnWllLdFRuWFRSeDRBYkN4emVpeEZY?=
 =?utf-8?B?TjQrL2gyNlJEdGZlaXhramlxcDViTVp6elo3cm5nNmVWOEZsZUl3NWZNSXQr?=
 =?utf-8?B?T0NpRnNpN3FRRFhRcFZJVENKRnJRUGxkZnBDVG5sR0pPSERoN1duWmczUHVK?=
 =?utf-8?B?cUxhTmhoTHZyTnplUTZtaWRNUUtwazhsT1A5aG5Rc2htOCtBLzZ2dHJCRFU5?=
 =?utf-8?B?bUpmT0FVbTJkeXV0L2V4S1pIY3V5UXVrT3cwNFo0YTkvS2loQkRVQkluTnda?=
 =?utf-8?B?N1ZXZlZWZUllMFRlSzlCNm5qOUloVHZxWHdhVnBoNEMrTFRJb0NrOFNJMDVq?=
 =?utf-8?B?M25zbUpGRWJEUUNmVjVaeGFOUXJJamozNTZzMHUxU1JZWFhaSDd4VWhyeHJC?=
 =?utf-8?B?WE1IR0tVQzhYb2dVdTVHRTRCL3RlQ05NL1YvRlhOZVdZNnRub0R5MFJBV1pX?=
 =?utf-8?B?OGdWMWp5eXM2Vm43eW9Gb0grYXJVZ2Vac2s2SStIVTN6c20rbm9PdXQrRGZk?=
 =?utf-8?B?c3RZUGpBRWN3amIwT2MydndKTWVIby9qMXU4QjM4S29kazhZODVpQW15RXk4?=
 =?utf-8?B?UDN2elV2WDc1SlVkNk5mMFB3dm1nZDBaZ3cwRnBlYVNBTTJiMUpESDVnTnJG?=
 =?utf-8?B?YlpvazVYbVdEVFNseWtkYWxYbENqczhmMkJyR1VQQ2x4Mk43UVBMeUljYzZl?=
 =?utf-8?B?YVB2ajRocWpGbCtESkxHcWtNd2lsdUJmdlVRcHRSb0tsNDIyMEcrdjJWZDVY?=
 =?utf-8?B?V1BuTFlaa1ZlQUxRNlQ3bDNMNXJodXEwdCtJTXdWMUdreDQwZkI2T2xaNUZE?=
 =?utf-8?B?d3JoaTE4MkJEMkl0WmpnbDB1eFNPcVhGZUZmTVFQVFJYbHduRG5jWGN2a2Zx?=
 =?utf-8?B?OFY2V0tUenlibnEzckZrVWgyT296ZS9SQy9LYTBoSFlIRjZyWGxVR3FHR21x?=
 =?utf-8?B?a2N6cjk3RGlXNE5hcFBITXdub3Y5U1JTN1FHdDNBQm1zdTBza0tDM2ZWZEVk?=
 =?utf-8?B?VHF6Mks2M2ZuSTFqSys5QVNXTlB0UGEzQnhJeDQ5K21uUGJRQmJ2OExFQTkx?=
 =?utf-8?B?NXkxL0hXY0k2M0Jsc04rcDZjcW5oZmxZbFBjOXZnZDRMRjVOdGxLc25oVHI1?=
 =?utf-8?B?WmtNR0c2WkUzSjM0OXBteHl6a3Boa09yVlhjazhEbzN0MytmVHBQL3F5YUtN?=
 =?utf-8?Q?52E16u7Iu9W8X4kgQ2HvM5RL6/oJD7dz?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB6011.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L1d5a3VmZkk5N2hJNXFiSWdlOW5QQUp6b0srY0pqa2FFSVNYalBLUTZNeWxs?=
 =?utf-8?B?VSt5VisyN0dZTXV4MTJiWXBTblZQZElmU3BSTWlGeWREZnRrR2xtc2hueDZX?=
 =?utf-8?B?NGI1N2hNcEx6SS9vSWJvRUhreS9VUjd6RzAvQ244M1g1RysyZkNSbjl5dk9W?=
 =?utf-8?B?bnF2TTdlMEVteE4zbzBJTGRHN1M1RTBpbGhBelp5U1hwTW1CbUpLalZYLzYv?=
 =?utf-8?B?RHpIMlVnYzllekNDeEJ3eExjam0vaTh6UG85Ylg3dC9hdktKT3ZYMFRyRTBS?=
 =?utf-8?B?eVVncEUrWllBVXVpRkNxMHZ0SXhCdlFSL2pUZXYxVGNPZ05UU1BmdzF5aDFn?=
 =?utf-8?B?cytjVUhlZWRraVk3aTJ3MStiV1ZZMkNGUkpLcHIrMzVicnM5d2FsMFhpS1Iw?=
 =?utf-8?B?U3UwNEdOSys4Q290WTNoOXp6K0hIYWdsK2g3L3JYNGtyNHl4VkM2RUNPN1FZ?=
 =?utf-8?B?dXRIVjhtdnloaVZ1Q09weU8vTXhNdUdUSzdpRkRtb3UybjlxRkg3R1R4N3k4?=
 =?utf-8?B?T0Zua01BdGxNVC83c1gzS3doaVlEb0hTd3phRVNxNEh4RUlNQi9LZzhyVDRZ?=
 =?utf-8?B?SDFqaHUwKzcwbmp2N2VPSC85NHRRK01JY0pLWDhUaGxvb1VyelpMUDhteTVo?=
 =?utf-8?B?Nlo0VVduU1BlcmNYTkN6aU9UQ3g2bTVMQ2UxeUZjdnhRcW1hRlNycFZRempP?=
 =?utf-8?B?OWdOZjY5WGJBTWxuV0FXZVhpTmIwamRRRi9MMWxxOXpuMmVVSDcwT1JqUnZh?=
 =?utf-8?B?NGJoaHUvRW9laEQrLzVpd3dpczZodmRRYnN3RXFZUEJsVDVJMW04cHZDVUJn?=
 =?utf-8?B?SVFFSjh1N2tEWWd3cGcrTHhrNXEySlVlTmdxaFlXek9ycXBSRFFmWkFoQjMx?=
 =?utf-8?B?THRWV2hxWUhxYXkreGJhSFB0MVU0TVVMUUU5NThTR3pvMmtPSTlxNVZvdHB4?=
 =?utf-8?B?dGtvTmNiYWFUdDhPZU1YK3pBdy9DcG5DSlBDeHE2QTkvTysrMGVmMktmME9k?=
 =?utf-8?B?VzljSXgzUWpuVjhULyt2aWR3b2JmQUxiWWk3MUhyU2xDaldvRlJCNXFISVIz?=
 =?utf-8?B?Unhpci92dk9PcE9CWUo2VGo0SG5VVC9qcEUwYjRhalIzUHlVQWVGb2JFTklY?=
 =?utf-8?B?YXBBcTNhUXpTakUyWmpaS1pNTVZKcm55bXpZMHBlbG1CcFphaUMzUEhqZVZx?=
 =?utf-8?B?amxHeUZPV29LSHlsazlLQkJ5ZVdYUGQwbE9FbzM2VnZ4SHFRcXBnZVBaODVX?=
 =?utf-8?B?QjJOWUlJSVZOLzlpOEs1NEhxZ0FYNlZYdDFMbmZub2tuY0hRUURGWEJjTVdP?=
 =?utf-8?B?em5DN3ZhOWlKWTl5eXV6ODFkalJJR0FDUHZPNHhKL2ZMS1NJUW9UdkhKVFA4?=
 =?utf-8?B?ZitWTkt3SmFkeWNWajBOa3lkUXhEUzl0YkthVjZSNTl3aUpkZkNkY2FPbEpl?=
 =?utf-8?B?R2FZd2ZoVUc5M1JtVmRiMCtTc3VlMkNvM0tYV3ZaZXZyZDVBWUwwUDNnMjBQ?=
 =?utf-8?B?VFpNNm9GcVlWU1AzZDFWU3ZDTVByQmwrZjZYZG9mZ0ZDWjJQaG8wUWI1Tldl?=
 =?utf-8?B?VEZNZzJsL1RpMUVaaHZCTXZTTXNQRG9nWDBnN3ZMRFhlL0NqQ25BODJ1UVFM?=
 =?utf-8?B?bmJSQjRhSTVkYXJCMTFXWjB6Q2lTL3VPZ20yOEdrY2RBTExpazhyTExjY1Rq?=
 =?utf-8?B?MlNuNEUvRHRnSFJRaFFkSkxJaFJTS2NlR1hObTBqUE1kTjZCSVdYVWFkempt?=
 =?utf-8?B?WGlIdnF5TDNjTXpYenJRcllhL3g0VUdISU51R2FMT1dzUUhFa0tXSEYyNmg2?=
 =?utf-8?B?aHpqMFJiNjk2dXV0WGZPRkhNLzZIVWRncWJNc0t5eUcyOUljaE1YUDFqRXlh?=
 =?utf-8?B?WkFDQlNWdnRkcjZnQkRrVTJsMU9YTnB6YWh4TVNVT2R4OHhoUXJuTTJEVXVh?=
 =?utf-8?B?UVFoN0tJL1pmcENZMnhaZ0o0YzJHdkVhSENINnBEbno2bXBITVhKVGlILzd3?=
 =?utf-8?B?cXZQTVdnZENWSjZRK3BPSlBvNUR3UEY5TDF0WEQrT2t6UEdTdTg3eTc0NHZu?=
 =?utf-8?B?V2ZhZjZNT2Q5UDZIVkpJN1ZZNUpDRVRLZVR3VDRhNTJqTjE4OEEyVEFhc25z?=
 =?utf-8?B?SVk2NmptQ3FoZGtTWTBOcmRwVjlaNHl5TElrdnVsMzFmTExWNHRhZnZIQjRR?=
 =?utf-8?B?TGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 230b3643-e46a-4d1d-2394-08de33fa2aed
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB6011.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2025 12:31:09.0191
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OpAMNBFTl/gQRoln4kOgrmsWsPtwcOPJGA3visUpky/TykADz6xbHN8y98Lyx4adDVucZ5gTL9789pojwsuwOLBYNzzdjxfTxknirxinPY4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPFDA283F46A
X-OriginatorOrg: intel.com



On 12/5/2025 12:39 PM, Dan Carpenter wrote:
> This code frees "migf" and then dereferences it on the next line to get
> the error code.  Preserve the error code before freeing the pointer.
> 
> Fixes: 2e38c50ae492 ("vfio/xe: Add device specific vfio_pci driver variant for Intel graphics")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>

Reviewed-by: Michal Wajdeczko <michal.wajdeczko@intel.com>

> ---
>  drivers/vfio/pci/xe/main.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/pci/xe/main.c b/drivers/vfio/pci/xe/main.c
> index 0156b53c678b..8e1595e00e18 100644
> --- a/drivers/vfio/pci/xe/main.c
> +++ b/drivers/vfio/pci/xe/main.c
> @@ -250,6 +250,7 @@ xe_vfio_pci_alloc_file(struct xe_vfio_pci_core_device *xe_vdev,
>  	struct xe_vfio_pci_migration_file *migf;
>  	const struct file_operations *fops;
>  	int flags;
> +	int ret;
>  
>  	migf = kzalloc(sizeof(*migf), GFP_KERNEL_ACCOUNT);
>  	if (!migf)
> @@ -259,8 +260,9 @@ xe_vfio_pci_alloc_file(struct xe_vfio_pci_core_device *xe_vdev,
>  	flags = type == XE_VFIO_FILE_SAVE ? O_RDONLY : O_WRONLY;
>  	migf->filp = anon_inode_getfile("xe_vfio_mig", fops, migf, flags);
>  	if (IS_ERR(migf->filp)) {
> +		ret = PTR_ERR(migf->filp);
>  		kfree(migf);
> -		return ERR_CAST(migf->filp);
> +		return ERR_PTR(ret);
>  	}
>  
>  	mutex_init(&migf->lock);


