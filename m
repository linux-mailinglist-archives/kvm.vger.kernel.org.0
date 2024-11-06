Return-Path: <kvm+bounces-30849-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BBF69BDF2B
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 08:11:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BE80A284CD0
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 07:11:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F405D1990CF;
	Wed,  6 Nov 2024 07:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KRn5VOS7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 896CC190067
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 07:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730877102; cv=fail; b=gCkjL7KuJOB+LYCGIBtyJfoH76kPuPvRSMefvRkYBVs8nFrHQkKDYMflPh2Zem4spsRE54Hi2/tzaAvgsR19UedeipSSWgqAJtauuYMtF+zfT0kUmH0BhYpDoa+drDbmJN+IyRQOSlJ339GWpqVnrPrRW9YrezdBp2KO+J7onAA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730877102; c=relaxed/simple;
	bh=2UdCYxwMfWQI95nKzeKae8n+JK/djB8sfC91vzanHPM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=slYWhyjagNN/Ro0UcFXSdGPXJo5i/ZY865Fm4sFwHmujSOhmg0XMMianudegjkNcyMSfmTMTPvlXz3yp5Fmdwlg9+tZMJy28cvo1h52KaE91AlfHY5cMljnTRxrm9MWGBB/eNWs5J7harCHuFnUINmsVp5+TbJ++Zv8Y4geABsY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KRn5VOS7; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730877101; x=1762413101;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2UdCYxwMfWQI95nKzeKae8n+JK/djB8sfC91vzanHPM=;
  b=KRn5VOS7+Gb0se9dkmFJmyNJ6t41j5mrCy4KdAFExx5emwbV1lR4K64v
   RXgmoSEpSokhDHTqbOfB98tFco6D8AbfAe4RuOWiGYlVVSickBBB0RRRC
   a/aRbEctvY1Ivaba6mRa2xZfowLpEVaxYdGg/kP3V2/RSwcyDLeCiEbt6
   Po+WxJvfvNXntAQR89T/ov7PWXxTNf9HQ++95Sq+NYMT8eeJZZjXelKl4
   rQnS4zQ1ccic41lN67WpPU6/b3S4f+B/ZxX26cjNNT88TtkfqzJD42rgd
   FglxAFTHbPv05KrmdW2hZZi6Sli2MTVJJtIytgUnEW3hYu4KlNGDM/Qo/
   g==;
X-CSE-ConnectionGUID: OeXQW/MqTlKNK0H9lYYI7w==
X-CSE-MsgGUID: OxLq87cLSQuhrbuP7ys+Vg==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30836886"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30836886"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 23:11:40 -0800
X-CSE-ConnectionGUID: S60l8b0ETX2FYBgC5aCS8Q==
X-CSE-MsgGUID: 9AqkS78WTdSvORDKdtKWdg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="88945550"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Nov 2024 23:11:40 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 5 Nov 2024 23:11:39 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 5 Nov 2024 23:11:39 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.174)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 5 Nov 2024 23:11:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i6UMs3wii33k20+sAhnQpwht0bBbDgs/Us2fQwH//LjS84hUyNUkyREf9F7+cYLi8prgv95kH+e+X5MX9m4e0aeDFMf0+KzkcCqUGpf73Vj6oOPw1PPLZn8GyoKxIWL3V6JfB1NYGbZl42fPskX85sOkHTcbcrSj1TWTU8nJzGrv3NPl5PaFpuRndwlXx7hV/KBI1q3q3mhfhdVmRMaNZ/6cdsmLAK/cKtE9MggacbltLTbtvRgCHHU0iqNlRPlZ/0jRuK1l9devrYn7RvjAf0iaHwIoWJz1Yi5iBFCuEJ7IXnlYS1NY20lBtGTfQO52FQrB2kTuUtq2R0/necmajw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2UdCYxwMfWQI95nKzeKae8n+JK/djB8sfC91vzanHPM=;
 b=f7Nm4lKSEQM0ScSgcEbZHV1WHlm3DhAabpHyFwRO6SRd9X/msQSZIZSlBwiF7VvzE8zfLH5XQUmo2xX709IIHvl+wVt8trpAh5TR5oEsFBkI26acKJxPb7GENLQtvWTE+0OR2NTALDFVdrhnbAJ6P0RtfrqUFC/NFERY62P9Wj65LCZL89jr+tQr8Uwqbd+UYCJZJPuYts+jzaDM72gEAygl+0AazaOcdI3T+lVf6tvssk6dW1P+bLV345GiR675jYq7/JANqDP/t5joito2ZZLigv6iX6m/NpIBrx+qntW9fU2TBQbOQOxwkdsBeErka65QgHpXrAwR+gHNDzJnuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA1PR11MB7891.namprd11.prod.outlook.com (2603:10b6:208:3fa::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Wed, 6 Nov
 2024 07:11:36 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.8137.018; Wed, 6 Nov 2024
 07:11:36 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Liu, Yi L" <yi.l.liu@intel.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"jgg@nvidia.com" <jgg@nvidia.com>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>, "nicolinc@nvidia.com"
	<nicolinc@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "vasant.hegde@amd.com" <vasant.hegde@amd.com>,
	"will@kernel.org" <will@kernel.org>
Subject: RE: [PATCH v4 02/13] iommu/vt-d: Add a helper to flush cache for
 updating present pasid entry
Thread-Topic: [PATCH v4 02/13] iommu/vt-d: Add a helper to flush cache for
 updating present pasid entry
Thread-Index: AQHbLrwctIjgbShWBEe3vvkahqtBGLKp111A
Date: Wed, 6 Nov 2024 07:11:36 +0000
Message-ID: <BN9PR11MB5276D12FF07A6066CEAAF4308C532@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20241104131842.13303-1-yi.l.liu@intel.com>
 <20241104131842.13303-3-yi.l.liu@intel.com>
In-Reply-To: <20241104131842.13303-3-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA1PR11MB7891:EE_
x-ms-office365-filtering-correlation-id: c847b078-057f-4e34-5ac9-08dcfe324091
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?WGZyOEtHOWhYZW1oSTJoaXlNb3hyazdiTGtGT1c2eko1cHlLTnZvZXZvUEFk?=
 =?utf-8?B?WTVOMnJXSG1xWEpJcGJlc1o4OGFGWm11WmZoSzhpYWVOMDlwZlJYNEtXY08y?=
 =?utf-8?B?T2lJV0JmSFRnU1BpSnpNeDZuSStuRlh1dzNtN21LaEE5dzdDc0FkaFVpS0lq?=
 =?utf-8?B?d3VTVnlVZldOQm9GVHRIVFB0SFNNcWxMcUdxTGhobzlZSkRKQTcyeTZ3Slpw?=
 =?utf-8?B?Qmd3SlNWRDhLc2pZRmlsSEkxT1BFbjhiR3J5QW1leUQ0QnBUZGExbmRFR2hH?=
 =?utf-8?B?ZmE2RmtnZlI2MkZIdlFuRWlRRmVGZ0UvQnVFNElkOVZNTXliVkN1azU5aVZs?=
 =?utf-8?B?MHV5Nis2NDlqUTBxR3pQN1p2RktiYkZoVHpKWTFSemVMRklrZG5VTHBFQ2VR?=
 =?utf-8?B?TEpRUzgrZ2JkcnZBbm5rWnVlMlhKYklIQTNhTkRkWFB2cjBhMzlQV1A2RXk4?=
 =?utf-8?B?aXlzS2IrbXlVSGhFZkZqVmJhUXhZMDVXWjZTaTlZWVo5M3lTSG01MVR1RTN4?=
 =?utf-8?B?VmRoTjY2dGZWS3E5eHRLVndnRXM4TUM2YkY5WVA1WGFpWEZWMFBOMExpYmdT?=
 =?utf-8?B?RFBXZnJ1ZlN0UUdXdWFOcE9WSzgyc2dJMGl2dVdBMVNUd0FKWHlmQXMrMVpN?=
 =?utf-8?B?YjMwZmFra1dhOHJNUWVGOHNzb1BObHNoOVZsNmxuSmFNOW5yZ1ZlWnlGc0o3?=
 =?utf-8?B?WFRHN3RINmFmUUpTQUYwb05DV0h6QTR4aThBZnVhei9tVGlzT2p3Ukk0ejhO?=
 =?utf-8?B?UUF1RlM1UFRiNEQyS0xQZ295Y3VjNmpsT0VhU2Z6ZWRDMXJ3TmpvU005Q1Ev?=
 =?utf-8?B?ajBoTko2VGNDQmxtYnMzYmxVWTI1K0Z6K0pmdHViYUZTcnZjOXY5MXljbGRq?=
 =?utf-8?B?dU4zQy84eGFNcHgvQnJwTkZYdDkwZTd3NW5sc3I5Q2FNUlR6VE5GeEZXREIv?=
 =?utf-8?B?U3RtWWhIZngxMEhkWEd6d2d1dXMvYXdPa3dvVDhuWlNCUXQwVG0yY3JQVExa?=
 =?utf-8?B?c3VJSmlSRVZIZTNLN3AzZDhTcXN1SXZlQWxaWTYyTTNzMzgxOGtxSzB6RDVm?=
 =?utf-8?B?YTVZZDNPU21pYklObG8zM3NQV3dMUXNHTWV4WEtibk9TcXJoMk1TaE1EZmJq?=
 =?utf-8?B?bGNyc3ZEaStsZ0NSTkk0VnkzaEJyY3VoTHZHZTlob0xnOG03bkhHbksxVzYy?=
 =?utf-8?B?SmE4S001bzVFYkRBU1ZUOWRSNS9MTy9Pa012OHA0YWV4NmZBZ2dSNExuUFkx?=
 =?utf-8?B?UTRKTDJHZXEyVHBiMmVOMDZmREp2NTYxcW9QMktFeXhtWUkvZGtDV01PVzdl?=
 =?utf-8?B?OStaTC9oWHpjL0w1dmljK0c5aUFIK25JZFBpZlZRSklpNk5uZkNNdnJMRWlj?=
 =?utf-8?B?S3dKdGR0UW52TG5sKy93SE9INlNJa3BaL1JUbmk0S0ZuVTFhM082cndPWmtu?=
 =?utf-8?B?RzJMM3I3MStrdnNVM09SM2pBYVlKQ2s0K0cya0FZa3FISVZ6V2dqL0Y4TmJV?=
 =?utf-8?B?SFpjUjR3UGVnUElCNGpsNXBWVHlOWUJTODRZellBUkRiSmppdjhHU2Vxc01E?=
 =?utf-8?B?YnJ6K0c4Z3JQOVpWZTZBK200TUxEei8xZC9EZFVQU2RkRkRBd2pGejBWeXZl?=
 =?utf-8?B?VXpUWGZ2bTJvdmt6bXRJZFZTNWhHS3V0QWdOREVMejdPcC9xYjh0VXk4UnJo?=
 =?utf-8?B?Y1V6em9qZVVqS0F6OXZmRnRsQ1MwVFJaN0pKaXg1eTEvKzg3MTk5VGRJOHNZ?=
 =?utf-8?B?aFpteUFkcUV2QWlkdVp4c2tocWxJbnVMNk9XZG1DalNqU0xQZzVkTVZ0Y3JR?=
 =?utf-8?Q?sZmytdE2T3bsIDGD9Iu8JqMs+RuDzrVNOez5Y=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S1A4SGJJMnVaaG5lNk5CeGRQb05wV20vRjFhd29IRHlBYXJQY1V3L2JORjYr?=
 =?utf-8?B?TkJ3eEpCV3FYZFJIdzZ6K0FwTFNrQ3hFeFVnRmhFWS9QMjVlUzZteUljNG9o?=
 =?utf-8?B?NkI2eTFxN3VCS1VncE1td1pkRWRFa1VTMG5WcHRhb1lUajBNUnVwd2RvajBU?=
 =?utf-8?B?SU1OTlN6akhwT3BFRENSZ3J4bmFCTGxOZXpnQWk4N1JxWG1Ma2QvWUhDOXc0?=
 =?utf-8?B?bE5sYisrUjFWa2RQdC9CckVqTmZyV3IyUEJUL1NUbUFYR0NtN0UwbC9kUjBq?=
 =?utf-8?B?N2xVYmo5V2tDZ1pjSHdDbkFocTcyZnhqM0Raa1JoRUhNc0RSTmxLam1la0FG?=
 =?utf-8?B?emZqMjRQdTg5V2x2NFBLK2lScC9Dakpxa2pEY25Qa0pQM1JqQ1lybnZZV0lM?=
 =?utf-8?B?eWZLZmJDcHRzRUlZUndKVDZiQS9FR3FiRE51NThLTXhPd0dhR2IyWXdVcTYw?=
 =?utf-8?B?M2RjZEZKZU03RW53R1Z3dS9nQzBxRkhLOHhFODRqbVFKc0R3R0hkZGFzSit4?=
 =?utf-8?B?eVYrWHZsTm9JaWs3SnAySGNFa05QTW42UmprUjBsVUY1cG1XSFFkSmR1U2w5?=
 =?utf-8?B?Z3poQjNvWjZvSCtUSmVPaEYxUU85czZUV01VNkh1U0tTZDhJQXhnYng1Z3Zo?=
 =?utf-8?B?MDE5ZmR0SHdQVDBERjF6bXY2bWZ6bWdrQXBGcmUxOXhRSStpeDNBZnF2enVM?=
 =?utf-8?B?WU9IZlYvTDNnRW55QktBY01zbys1Yk5wVHltUE9weUF6M1BWa1VCR1BnNmVo?=
 =?utf-8?B?bWJmVExydlJmQ3cvSjRUQVM2MmlndGRyZ0t0R2E2TnhWMGcvS3NPOHhQcmNq?=
 =?utf-8?B?R3RCZGEzZERjQ3RZd1FIWGVLeDlYR1IyNU9QSTV1eUhaL0RKd3pvZVBRZGVO?=
 =?utf-8?B?NDF0Nnl0VWo0N0hGei9XWFRHcVBiZTZKUkZBcFdBL1haOU9RWi9sM0l0NEdS?=
 =?utf-8?B?bDNlZUZKNlIzc3dOQnFNVGVySVpLUUxGelRJVENtaURneHVRZnczY1ZyU2Q3?=
 =?utf-8?B?cENKTThuNGZTRFFhdk5lMDl1K05FWHB3bzdJTWZ3a0U4MHFsOGtheDdhOUhw?=
 =?utf-8?B?TktIN0YxWnN5czRvSG10cm1OeU55YW5LR2gwWFE2NVlpNlgwUlFVTkpvTm81?=
 =?utf-8?B?SHV2aTB4aUZPbTArYkpIWjEzTE9lQmhIK2lwVnIxOTNZZ3lPbUYzd2dIUWJD?=
 =?utf-8?B?M1pzZmJzS2lJTkxNN2V6NDRqMkF6VFJwWDlrVTNuUWUrb085WWthS0xWejZQ?=
 =?utf-8?B?RG1walpwQVVLQ3YvN1pZTUowY2tUQSs5ZTJPQnFETE5USitOQVBMOWp3a0RL?=
 =?utf-8?B?WHllSHZPSTk3WnNpS3M4U21ic05PN3RkRnNzR2ZJV0hSVS82WHpkc2J0VENn?=
 =?utf-8?B?bExQOStXQVY3RDlvdytib1ZtekliQldIYytIM0MxR1JuZEZUbmt3eGxEZWpS?=
 =?utf-8?B?dHExMlpidzhTbFh5c0g1TzIwUHVvQlVNQ0JkRGo4NXBuZTZKZHozNDVxUWdN?=
 =?utf-8?B?ZjIxeVFkZGhUK2wvY1REd0NsT0pIQjhjOEFQQ1k5Y0ZDUXBac1paV1pzNHhH?=
 =?utf-8?B?SDdja3lvc0J1UWQxbklvZmNZNkc0Y0VhYlFxVE1idU1UV3QzVlEzRG5DWUMr?=
 =?utf-8?B?SWZxa21qR0JPdmRNRHAzME8vY1hHT1VpbGowY3RVNnFNVjVnUktYN0t6MCs5?=
 =?utf-8?B?UXFTdnJYY3BJUFZrTElsSUhuRkFLclI2MmhjMk9RQkpTSXMrQzJIMTFZLy9G?=
 =?utf-8?B?OTVGb1hWOG9sck5udERQUnorM1h6R2ZUZHRhTUFmaFVYTHFzcVd2QU45OHdz?=
 =?utf-8?B?VEJ0NmlpM3NWSCsxbHAzZEZrcjQzS0Z4YUtOM09rT2pYT2RCTkdJUFE2dE9W?=
 =?utf-8?B?cnZhQUpLQWpVdVNBNU5YN0Z5djFXRTFILzYrYkJVR2NJRTJSL3BoRXBmaDM5?=
 =?utf-8?B?Y0I1dWY0SUpwdDhFWjVocWRDVUEvQ2hKcUhxUnErTUN4czBKTVd1R1dwK2ps?=
 =?utf-8?B?bjR2R3k5ay81V2VKYnNPMndBTlArdG9KT293cmhxbS9Fa1l6cElxai9uaTlT?=
 =?utf-8?B?UVVlMFh1b280MUdUYzhibnhUUk54WGRrTG5ZY0NqSlNTenh3aWtQYVNvdlJB?=
 =?utf-8?Q?4PvWZfsibG1SCP4cggQ60iPou?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c847b078-057f-4e34-5ac9-08dcfe324091
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2024 07:11:36.4461
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3veQCNobd+QDgfBofP8We6OkL7UtfI4yyk9M5uZE81MSQdEVKjXSnYfXZMpTnVqamkWBx++5YKfRqCLjwP0VAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7891
X-OriginatorOrg: intel.com

PiBGcm9tOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gU2VudDogTW9uZGF5LCBO
b3ZlbWJlciA0LCAyMDI0IDk6MTkgUE0NCj4gDQo+IFRoZXJlIGFyZSBtb3JlIHBhdGhzIHRoYXQg
bmVlZCB0byBmbHVzaCBjYWNoZSBmb3IgcHJlc2VudCBwYXNpZCBlbnRyeQ0KPiBhZnRlciBhZGRp
bmcgcGFzaWQgcmVwbGFjZW1lbnQuIEhlbmNlLCBhZGQgYSBoZWxwZXIgZm9yIGl0LiBQZXIgdGhl
DQo+IFZULWQgc3BlYywgdGhlIGNoYW5nZXMgdG8gdGhlIGZpZWxkcyBvdGhlciB0aGFuIFNTQURF
IGFuZCBQIGJpdCBjYW4NCj4gc2hhcmUgdGhlIHNhbWUgY29kZS4gU28gaW50ZWxfcGFzaWRfc2V0
dXBfcGFnZV9zbm9vcF9jb250cm9sKCkgaXMgdGhlDQo+IGZpcnN0IHVzZXIgb2YgdGhpcyBoZWxw
ZXIuDQoNCk5vIGh3IHNwZWMgd291bGQgZXZlciB0YWxrIGFib3V0IGNvZGluZyBzaGFyaW5nIGlu
IHN3IGltcGxlbWVudGF0aW9uLg0KDQphbmQgYWNjb3JkaW5nIHRvIHRoZSBmb2xsb3dpbmcgY29u
dGV4dCB0aGUgZmFjdCBpcyBqdXN0IHRoYXQgdHdvIGZsb3dzDQpiZXR3ZWVuIFJJRCBhbmQgUEFT
SUQgYXJlIHNpbWlsYXIgc28geW91IGRlY2lkZSB0byBjcmVhdGUgYSBjb21tb24NCmhlbHBlciBm
b3IgYm90aC4NCg0KPiANCj4gTm8gZnVuY3Rpb25hbCBjaGFuZ2UgaXMgaW50ZW5kZWQuDQo+IA0K
PiBTaWduZWQtb2ZmLWJ5OiBZaSBMaXUgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gLS0tDQo+ICBk
cml2ZXJzL2lvbW11L2ludGVsL3Bhc2lkLmMgfCA1NCArKysrKysrKysrKysrKysrKysrKysrKyst
LS0tLS0tLS0tLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgMzYgaW5zZXJ0aW9ucygrKSwgMTggZGVs
ZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9pb21tdS9pbnRlbC9wYXNpZC5j
IGIvZHJpdmVycy9pb21tdS9pbnRlbC9wYXNpZC5jDQo+IGluZGV4IDk3N2M0YWMwMGM0Yy4uODFk
MDM4MjIyNDE0IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL2lvbW11L2ludGVsL3Bhc2lkLmMNCj4g
KysrIGIvZHJpdmVycy9pb21tdS9pbnRlbC9wYXNpZC5jDQo+IEBAIC0yODYsNiArMjg2LDQxIEBA
IHN0YXRpYyB2b2lkIHBhc2lkX2ZsdXNoX2NhY2hlcyhzdHJ1Y3QgaW50ZWxfaW9tbXUNCj4gKmlv
bW11LA0KPiAgCX0NCj4gIH0NCj4gDQo+ICsvKg0KPiArICogVGhpcyBmdW5jdGlvbiBpcyBzdXBw
b3NlZCB0byBiZSB1c2VkIGFmdGVyIGNhbGxlciB1cGRhdGVzIHRoZSBmaWVsZHMNCj4gKyAqIGV4
Y2VwdCBmb3IgdGhlIFNTQURFIGFuZCBQIGJpdCBvZiBhIHBhc2lkIHRhYmxlIGVudHJ5LiBJdCBk
b2VzIHRoZQ0KPiArICogYmVsb3c6DQo+ICsgKiAtIEZsdXNoIGNhY2hlbGluZSBpZiBuZWVkZWQN
Cj4gKyAqIC0gRmx1c2ggdGhlIGNhY2hlcyBwZXIgdGhlIGd1aWRhbmNlIG9mIFZULWQgc3BlYyA1
LjAgVGFibGUgMjguDQoNCndoaWxlIGF0IGl0IHBsZWFzZSBhZGQgdGhlIG5hbWUgZm9yIHRoZSB0
YWJsZS4NCg0KPiArICogICDigJ1HdWlkYW5jZSB0byBTb2Z0d2FyZSBmb3IgSW52YWxpZGF0aW9u
c+KAnA0KPiArICoNCj4gKyAqIENhbGxlciBvZiBpdCBzaG91bGQgbm90IG1vZGlmeSB0aGUgaW4t
dXNlIHBhc2lkIHRhYmxlIGVudHJpZXMuDQoNCkknbSBub3Qgc3VyZSBhYm91dCB0aGlzIHN0YXRl
bWVudC4gQXMgbG9uZyBhcyB0aGUgY2hhbmdlIGRvZXNuJ3QNCmltcGFjdCBpbi1mbHkgRE1BcyBp
dCdzIGFsd2F5cyB0aGUgY2FsbGVyJ3MgcmlnaHQgZm9yIHdoZXRoZXIgdG8gZG8gaXQuDQoNCmFj
dHVhbGx5IGJhc2VkIG9uIHRoZSBtYWluIGludGVudGlvbiBvZiBzdXBwb3J0aW5nIHJlcGxhY2Ug
aXQncw0KcXVpdGUgcG9zc2libGUuDQoNCm90aGVyd2lzZSB0aGlzIGxvb2tzIGdvb2QsDQoNClJl
dmlld2VkLWJ5OiBLZXZpbiBUaWFuIDxrZXZpbi50aWFuQGludGVsLmNvbT4NCg==

