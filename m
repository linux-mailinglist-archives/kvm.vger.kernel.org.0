Return-Path: <kvm+bounces-26738-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 06134976DD3
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 17:33:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 28FC91C23B03
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 15:33:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 998A61B985F;
	Thu, 12 Sep 2024 15:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="axSyoVYb";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="CDeKzODr"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C01126BF9;
	Thu, 12 Sep 2024 15:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726155192; cv=fail; b=UZy2emEBRRh1zFvYLyV+BRk7SNvMNalhiVfM2YPKooqDSRk7e5rgnudYQL727KPTcsNJNVTzlFSBpMpQeESBgEmtaRda+S+9uEKWbY55ZtnY0K2EjcCfnylu157weezmfsiIzYITzqVR/iednFVZExbVqm/yYRZk9TyPsHzkpIQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726155192; c=relaxed/simple;
	bh=Nrb5IE1dBnyt+2G8zRjApefmE1UKfh5LlKPFaFxOYMc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jEN9dyRdrSX9wAAZkxVXw7dpUVa6CN9Vhzrd1A+f23GFpmA/2Dd6PpnIKe3smSXbhUjZ4dsfH/xM4U3AmUb7ef2NX53yXtH1iClTP6O4qzkA28HlHC8l4/uzRyE9WHPw6JmaThqAnwbWKDvm5iIGLgD5nnIkGY1URgcGske2ilA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=axSyoVYb; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=CDeKzODr; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48C8AGtY032669;
	Thu, 12 Sep 2024 08:32:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=Nrb5IE1dBnyt+2G8zRjApefmE1UKfh5LlKPFaFxOY
	Mc=; b=axSyoVYbw34OqvvQ06RIg+WxmRig4BiqnkCqN+oKWVPoMThUF4hHYzyPN
	uLW0zaXE5l/ajU9kzJAm48J0FTRhGUYS0V1Uv+VUngt8yGF/3khPkS5LvnhjjlnL
	KyS4+3uQeTmeIM1/7RTsKge9d+5AGdBjsKICPn4jvb36eFXIxcdIw9iuUtb014TY
	oqEAjJu/T1S/4X9x3MdCfDafbZnGRDSeaoLohLHsdkzX0t1SOMLNaozU13Wua+WC
	zqMQDu7vMroD/7RemgXQWIyBbI6CLo2+5imsB3v8XSg7sAQeM3roIGGZv1h+K9km
	RbTDeKrQ1S//adxyaJj8EX61NZhaw==
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazlp17012048.outbound.protection.outlook.com [40.93.14.48])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 41gmc7vrvy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Sep 2024 08:32:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DRdZ2xWYCokynP14WVAo8Zhft6DF/ehrW85dD2q/h9J5inQLVxdoKCv4eY6UhiudHI21An69wuhCcPSfU8ZNAL+TZSL4dK+OrwWUSmvJgi45F1Jm+VyhCiZTGHdNJJZPr6KfFVcX3WCQWrZS5CNWP8uCYM59XoWbGy9q6iGrvZrQOKk1pvxL1GrcX6MAiOO1iGT+6E9IiiWWiDAuRTw7c0huThMVe6sLMegKLMYU6vO6Wy61gc6kAnmCwpWG/21MbOrHNbKNuPEm8dzUQq119N4g49B9fr8F+ttulBFEM//t7vs1zDLjveBSkrFuSLZnWhhRrhyw0FR2kkL1mVhjoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nrb5IE1dBnyt+2G8zRjApefmE1UKfh5LlKPFaFxOYMc=;
 b=QnMmbZagwclHr9yyYCeQSYV/LO9NHJeEZEGAmMpiwPI5Ik59NLy5sCdYYiQ44RsBjugKAPaxR9cgrlRSZicyOb/HVEXf8r6hQJSefRHILmth3TiGje65UKmjiGBNpTX75gSXX220sdPDasPBxSf25arZunVEukKuDIck4IkwN6aoYyUcapHe5AgvsqSMKxWF7IM1fbYrijjfCPmjZmKDld+n119TpbiFGs4QZUCSIGrVtxoB2D5EQ7mb4ze43pw4aKtKku3FOxjr2p2ktY6K0VcMW6UW6Fq6eOxtuZJ11gMhqMM4d6wLtfcHSMALSjJbFtAgKJSUOVo3gmQHr+OkdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nrb5IE1dBnyt+2G8zRjApefmE1UKfh5LlKPFaFxOYMc=;
 b=CDeKzODrbvCSHWyxX8DmnU7h/z5FY/kaKE9OmN2RmsOn76nhGiyC02WnFlzU5P3hMDU0iUlbGloni/X4HKBW6m3z9kXljiOgmVlkXySGilv1t7tZxBGShNZTXhhBqoPHRjk4aRgKzLBIznULTAEfIri1Agf+fLegVoqdCGO9Ytcl+Sg7K6fyDTJt29LJBfna1HiVFZFj88UjmNgrkF70c6y2lhxNQsZWCMuYFQbSKj069P4w4u+5JcDAH0TwiyfNaCMOcSI+cksgbhkbmxcz7gKWLoD70LUCgpJ11f/bKHaW3XXU47Xe7Z0CpxpyfRAieLCUf9FCmdGLFA0qctA98A==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by BY5PR02MB6979.namprd02.prod.outlook.com
 (2603:10b6:a03:21c::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.17; Thu, 12 Sep
 2024 15:32:52 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%5]) with mapi id 15.20.7918.020; Thu, 12 Sep 2024
 15:32:52 +0000
From: Jon Kohler <jon@nutanix.com>
To: Christoph Hellwig <hch@lst.de>
CC: Kirti Wankhede <kwankhede@nvidia.com>,
        Alex Williamson
	<alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, Tony Krowiak
	<akrowiak@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jason
 Gunthorpe <jgg@nvidia.com>, Rohit Shenoy <rshenoy@nvidia.com>,
        Tarun Gupta
	<targupta@nvidia.com>
Subject: Re: [PATCH] vfio-mdev: reinstate VFIO_MDEV Kconfig
Thread-Topic: [PATCH] vfio-mdev: reinstate VFIO_MDEV Kconfig
Thread-Index: AQHbBRyGixqrSwSYHk2iAjyDv7IUb7JUL1SAgAAYdYA=
Date: Thu, 12 Sep 2024 15:32:52 +0000
Message-ID: <8A26B654-51D0-4007-919C-F1934BD0DFEE@nutanix.com>
References: <20240912141956.237734-1-jon@nutanix.com>
 <20240912140509.GA893@lst.de>
In-Reply-To: <20240912140509.GA893@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3774.300.61.1.2)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV8PR02MB10287:EE_|BY5PR02MB6979:EE_
x-ms-office365-filtering-correlation-id: 9f5d7889-3f02-4cfb-a5af-08dcd3402a65
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?T3AwZ3VLejVVUlpGSThHdTEyY0pOOHIyTjA5NWZBVlJ1RnlicUdiWk14UkxN?=
 =?utf-8?B?Vi9uUHNXUGFCbW5mbi9UMDA0ckhGLzRxNzc5Ni8zTzV0N0VZcVpNdXFPSnEv?=
 =?utf-8?B?L2pOdENkc2RzdHAzaWxVZmVZMVJHd2VFMTRCTmxEOVRxMGUwQ3BvTlVwT2Ro?=
 =?utf-8?B?RGZBY01JZ3JKV0RVbVNOVzZ6dVJBQlpwZmd3ajV5eHNBRkdYR1hvOGRCcEFG?=
 =?utf-8?B?TWdjMFA3bUMwenh3ZEhaVUtZckg4L2hBWjU3RDRIdGdhbm1tZ1dOUjZJMmJn?=
 =?utf-8?B?OWhZaHc2ZUVxWVVVQytHMzNYN0pSbnNJdkRaWTIrSWlRMDltY2RvajFzd1NN?=
 =?utf-8?B?QU5hbnpXTElocmVycE84NnJzVW1uak9FNC9YWHdhT0dxczl6OEd2N01LcE0x?=
 =?utf-8?B?KzIzVjlXNmZEdUdTRVhzR2tIdjZJTS84elhhZFFLU0U0Z3B3dWd3NXo0SW5n?=
 =?utf-8?B?bXZOUmluVEVKK05WTWJjQmZpV1Vhb0d5QWdIMk9hSk9wUCtCQUkzVEdLMGJH?=
 =?utf-8?B?UmZtZFFKS25xSUZGUFlaQWI4NUJPUytkdi9SQ1FDUitRdkFkWFllOE1HZGZn?=
 =?utf-8?B?RkFmbDNrSXdlUEsrcTQ4TGVlalFMek5KdmJsUG9wODVVSjhuVWZ6alAxN08w?=
 =?utf-8?B?V3hKWDdTdXNEeXBXNGNlMStTSDhESlk5STJsNmpJNjZVMks0Tkx6TXlCV2hG?=
 =?utf-8?B?V2tUaWlsU1ZmMHRFY3hIUkVLUVhSR0p2MENNY09sSFBNV0MweHAycUVyMUFW?=
 =?utf-8?B?c1krUS82b2gvdHI4UGlkUTN5ZG1aU2cxdm1VQmd4M1orWGZ6ZStrdUNvd0pJ?=
 =?utf-8?B?WEFaOXN5M2NsSHpZMlJ2bk1sYmEvMTdSQ3B5QktJelJ4OUoyUzBWaXlFblhs?=
 =?utf-8?B?ZGRKOUJaOXZkb2RyZjRWZlViL3BvdER1Wi9pZ3djUEhtdDZraFRVbG5ZSVpK?=
 =?utf-8?B?ZTduYW1XdDJDMmlLNkVDNVZEa1VpSXAyNmx6MC9ldkZsMHZkL2kwWE5qMGxt?=
 =?utf-8?B?ZFFIS0IwRE42WEQvOEZvdXA0dGZ4aEhBV2JBNXU3L0U2bjJrT2lsblNNaENR?=
 =?utf-8?B?UGNLMUphUFNIVWlXUlZwemhMbTVzOFpOSXJvRFRhR3dUeEJISFUzUlNHUGZx?=
 =?utf-8?B?L3hvN1IzVGZPeEoyYittVENiSFlqNHRyKzhxSzVLZ0lieVlKemxOQXM3Wkk5?=
 =?utf-8?B?OGh6b0tCaldPNmd4MFQvWXdwWHhydHd6a0RUTER4bkg0L3cvdVM4azhpb0da?=
 =?utf-8?B?NUtsc2JtRWlmVm1qTC9iZ3dKSGZybFZpTUJFVGhsaWxlTjJwUW4ybTdJN3I1?=
 =?utf-8?B?dTV6YzYrWmNwaElxOUt0eFFJaDR2Ynd6VTZMTllOTDFqd2pSb1A4L0RDTnhu?=
 =?utf-8?B?L01sOWNDOFArYjNrTTFNcE41WHQ3N2dCd0hTSEdQL2huVWdlbElnRkVlMEZV?=
 =?utf-8?B?NVFDRERjKy9RY3d2ZUg4K29PM3V0d2R0dUZCZjVJczY3Q29kdzdtQVVkaW5r?=
 =?utf-8?B?WlJISTd5dVhEamVHR21VazE3K3BNWDdBWTc1T1NETUVOSDlwdERoN2lqU3F5?=
 =?utf-8?B?YVcybWdHRDVUbUg4ZjAxNWJEYVdxbm9RTjlJTWRFZS9uTSt1MFozVkpQMC9T?=
 =?utf-8?B?QmRlTzZHdGxhSnFqWkJyVXV4VEFaT1l5ZVhJdVhQRURDYlNTYncrTmlyUHZ6?=
 =?utf-8?B?VlNITS9HalVqRmh1WS9wK1VyUzRYYThNZUpyaHJacHlMZ0hlQUYyV2wrZ09w?=
 =?utf-8?B?Uno1VW1ETG81SVZDbXIvWEZsb1FKdWp6Nm1uejNQVFE2OVZDMFMrQ0thVUFp?=
 =?utf-8?B?aHA3S3RVUEx3TzN2aTlkVXRqUzBwN0hGTzF2R3NJQ0QrZUFDWDdJejNJMll2?=
 =?utf-8?B?eHlaRGU3WTMvVU03UnpMTXpqVnpOUnh6TTI0aWlJVjZjNEE9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?NWpFM2YvS09aTmhWVW1aa0NOaE9LSlAxQ3dWQ2tJcmsxcTI0TkxTc1dNQ21z?=
 =?utf-8?B?eFVhOGhYc3hrUDJ5enFWK1FYTWJINytzTEpYdXEvSU11MnI1a0RCeWczVkNi?=
 =?utf-8?B?WTNnTS9Qem0xU0hwandBMVRLejViSXBoQ0tGR1ZDTEEvSG12TVcva3QxdGFX?=
 =?utf-8?B?Q1NPUjNnS1ZDU2lFaUdSUUdYLy9sb245cDQ2T1NGTldQa3VUVEdwd25Gb3BF?=
 =?utf-8?B?c3hFWGprcFJUNkNKMFpjZUxtY3hJbTRwUGFNdzVtaUpSemZKYmt2bTJJeDJM?=
 =?utf-8?B?MWNUdmRjVUZQR0ZlYzlWUUUxSk1UMVB2dDNRNVMxdWpjRWh0QjVpNmZhUGxN?=
 =?utf-8?B?U3ZJY3Rtb2VwM202a1h0YUF0NUE4cDQ5S1VFSnlWbVM1dU9OcFpTRTJiMVBy?=
 =?utf-8?B?bjV1MWcvbk5DUERHcHFNUXl4eTZBTmljTVptKzFaL1lFZ3VHMlFJQ0taVEZR?=
 =?utf-8?B?dlYwWUR5N3hhQUo2VHZ3Zmd6NjEyRytaWUJobVZQQWsyVlNvMUQ5WXpSZUwr?=
 =?utf-8?B?ZUc2RzJDREgrdDNlaCtBSnRxQm14dm1iNzlPcVdtd1ZhSk5TQWdncmxzWFND?=
 =?utf-8?B?RkxwNG5SaFpEK2F3ZHNUR3UydmNZWnBrOXc0K1RWN2NGOGgvK3ZDaFdlQVY1?=
 =?utf-8?B?dVFTL29wZVNIU0Y5RXY4QmdPYlNRNzU5ekx5b0ZpWnpBOGJjdTBsdXkxYXNy?=
 =?utf-8?B?cWI3ZlpJNkdpNlhwRHlwQlpMekdzL3JJRVR6SWVkdVZjNG5yZjFlQmYwR29Z?=
 =?utf-8?B?YlhjbVpaMUdpNVFZdTRRUUdFT2tudm1NTzhPcm5CQi80RFFhbG41Ky85cGVh?=
 =?utf-8?B?bmd4aUFucXBvV1pwZThJUzc2c0U3em9VRi82MVY0N3FwVGdzNTg0eExOMFVj?=
 =?utf-8?B?eCtvazN6TUU5dHE0WkxtMnFMbGFhczBDZk1GczNMMlpWRjZWWEpsWHJDVGJj?=
 =?utf-8?B?RVNPcWIvMG5YQjF0QklRamlmazhOSWFYRjNCYlFZRGdpSW4rbEYydzNYeXN5?=
 =?utf-8?B?U3NoS2U4dzB4Q21ya216M21sNENLcDlGY0RyZkdiOW9FcEdzVkZCeHI4NTJj?=
 =?utf-8?B?Z3h4RWF0cDIzYXFSdlZFZERERW5XTjdVd3c4eE1CK3diUGRvR1IreGd4Um9i?=
 =?utf-8?B?QjlwVmpSY3AwYW90NVFVcHdHQlo3WTRaZDh3NEo4THRwT2xldFdnUTB0RnB0?=
 =?utf-8?B?Tm13TmY3QTBDYzJ3YkVmRFNjYm0vWEpPa1NRNXlMN1ZrcHROWDJKaGZUZ3ZJ?=
 =?utf-8?B?U3JJNnZJajk5VURydVF4QnovT3lWTU1WZENtZUgxa1NYSDhiQUl3ZE5zRXEy?=
 =?utf-8?B?WHFrRHJvRVNDb3Bud2FmSzd1MVY1eEpmRnVWTWZvK3ZINTBQZjFiWjY2R0Zq?=
 =?utf-8?B?QTlJVk5uKzBHNXlQc1g5WThKSFliWDkzeHQ0bjRIMGo3dUhlNXNkbEJXY1Bp?=
 =?utf-8?B?WUc5Kzd2L1NkN2F2aVVOUUwybWx2Y1hoNW5wYkJ5Znd4bURNNk12TnRuMlFU?=
 =?utf-8?B?eFNIT1AydVN1NVplalNkendCQ1RJOHJmMGZQN1RmL3RyNDYyS1VrdGtNREs0?=
 =?utf-8?B?NCtDanpqN21GMS9HeG1TZzhRcDRLK3d4OWc1azlNbEZwVkV2N3VJMklFbTBX?=
 =?utf-8?B?aW0zZUZSSWhYczEwOTJTQW1ZcDlBei80R0FQZnlCNGM2aTZUSU1GeEx3QW5C?=
 =?utf-8?B?cGlwUnZvSS9jRFpJbzRDSlArYis0SWpYOEhTOXFMN1RmTjhmTGNXSnpGT2xi?=
 =?utf-8?B?a1I0aWtFN0JiT293TldMMGhLdWZ5aFZKc2MxWTJaV2tLUlB2Y3dnMHRQaXVy?=
 =?utf-8?B?U0ljd2w2T041d3JGYUJ4K1R1MmJtQnNNUEdvL1hxTm5YZTBHeVhYcmt6UVFR?=
 =?utf-8?B?TS9WVFQ1TStYYXo5MGVJWSsyNkN1RFV6MEY3ajNEbHNjQ2UwRStSVUMvMHh4?=
 =?utf-8?B?VjJHM0VzcjdYQS9DUWlDQ0VWK0JRUE10eDRMM3dhamxqL0xIL0V2STIyemdN?=
 =?utf-8?B?WU9PUlBYeWRaMEpoNWppek9lN3huZE5wNmJNaFZwZ0tta2hHL2ZsMkpZM3px?=
 =?utf-8?B?RjM0c3V1UVlrc0JwdXA3VklLZ3lyaEYzZDR2M01BMEdnQWNkVndYdGpjWUMr?=
 =?utf-8?B?ZzI2S04vK2U0S1RZU1NRelVMN2tKa2N3cnFIak1nZ1lLaDEyaDdwY09Va2FP?=
 =?utf-8?B?V3dTcGhtYXdPZ1A4T3hvMVVtODFtYjFPQ1ZIUzlROU82Q3I2QkdIdnJHZVB3?=
 =?utf-8?B?QTh3ZnFlOGI2YXoyVTdhNkRRMmpBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <89D862FDD991C34D890561AA6F53B4BE@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f5d7889-3f02-4cfb-a5af-08dcd3402a65
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2024 15:32:52.2116
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Zc3UKWCe03fftJbfYBMC2apxjBBEVK4PGJZ22BzaeyXsByBPgzRVJ5USiStor1xt/9uQCQcVAufZRTndpP1v5keqgZ7w0sw0rH6plheKAFI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR02MB6979
X-Proofpoint-ORIG-GUID: HztBZBXGVd6Inm_rGjPE30RT9L6M00UO
X-Authority-Analysis: v=2.4 cv=TevEtgQh c=1 sm=1 tr=0 ts=66e309a6 cx=c_pps a=KNS6zyAANWoSenK6FAqM4g==:117 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=EaEq8P2WXUwA:10 a=0034W8JfsZAA:10 a=0kUYKlekyDsA:10 a=CHr2JbTOqPatGsS_H_YA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: HztBZBXGVd6Inm_rGjPE30RT9L6M00UO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-12_05,2024-09-12_01,2024-09-02_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gU2VwIDEyLCAyMDI0LCBhdCAxMDowNeKAr0FNLCBDaHJpc3RvcGggSGVsbHdpZyA8
aGNoQGxzdC5kZT4gd3JvdGU6DQo+IA0KPiAhLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLXwNCj4gIENBVVRJT046IEV4dGVy
bmFsIEVtYWlsDQo+IA0KPiB8LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSENCj4gDQo+IE9uIFRodSwgU2VwIDEyLCAyMDI0
IGF0IDA3OjE5OjU1QU0gLTA3MDAsIEpvbiBLb2hsZXIgd3JvdGU6DQo+PiBSZWluc3RhdGUgS2Nv
bmZpZyBzZXR1cCBmb3IgQ09ORklHX1ZGSU9fTURFViB0byBoZWxwIHN1cHBvcnQgb3V0IG9mDQo+
PiB0cmVlIGRyaXZlcnMgdGhhdCB1c2UgVkZJT19NREVWIGxpYnJhcnkgKGUuZy4gTnZpZGlhIEdQ
VSBkcml2ZXJzKS4NCj4gDQo+IE5BSy4gIFRoaXMgaXMgYW4gaW50ZXJuYWwgc3ltYm9sIGFuZCB0
aGUga2VybmVsIGNvdWxkIG5vdCBjYXJlIGxlc3MNCj4gYWJvdXQgb3V0IG9mIHRyZWUgZHJpdmVy
LiAgR2V0IHRoZSBkcml2ZXJzIHVwc3RyZWFtIGlmIHlvdSBjYXJlDQo+IGFib3l1dCB0aGVtLg0K
PiANCg0KQ2hyaXN0b3BoIC0gdGhhbmtzIGZvciB0aGUgc3dpZnQgcmVwbHksIEkgYXBwcmVjaWF0
ZSBpdC4gVG8gY2xhcmlmeSBzbGlnaHRseSwNCk1ERVYgZG9lcyBoYXZlIHZhcmlvdXMgZXhwb3J0
ZWQgc3ltYm9scyBpbiBNREVWLCB3aXRoIGJvdGggcmVndWxhcg0KRVhQT1JUX1NZTUJPTCBhbmQg
X0dQTCB2YXJpYW50OyBob3dldmVyLCB0aGVyZSBpcyBqdXN0IG5vIHdheSB0byANCmNvbnN1bWUg
dGhlbSBvdXQgb2YgdHJlZSB3aXRob3V0IHRoaXMgcGF0Y2gsIHVubGVzcyB0aGVyZSBpcyBhbHNv
DQppbmNpZGVudGFsbHkgYW5vdGhlciBpbi10cmVlIG1vZHVsZSB0aGF0IGhhcyBzZWxlY3QgVkZJ
T19NREVWIHNldC4NCg0KQWxzbywgdGhlIGtlcm5lbCBkb2VzIGhhdmUgcHJlY2VkZW5jZSBmb3Ig
bWFraW5nIGNoYW5nZXMNCnRvIHN1cHBvcnQgb3V0IG9mIHRyZWUgbW9kdWxlcywgYXMgcmVjZW50
IGFzIHRoaXMgNi4xMSBjeWNsZSwgZXhhbXBsZToNCmUxODhlNWQ1ZmZkICgiczM5MC9zZXR1cDog
Rml4IF9fcGEvX192YSBmb3IgbW9kdWxlcyB1bmRlciBub24tR1BMIGxpY2Vuc2Vz4oCdKQ0KDQpJ
IGRvbuKAmXQgd2FudCB0byByb2NrIHRoZSBib2F0LCBJ4oCZbSBqdXN0IHRyeWluZyB0byBtYWtl
IHN1cmUgSSBhcHByb2FjaCB0aGlzDQpjb252ZXJzYXRpb24gY29ycmVjdGx5LiANCg0KV2hpbGUg
SeKAmW0gb24gdGhlIHRob3VnaHQsIGZvciB0aGUgc2FrZSBvZiBjbGVhbnVwLCBzaG91bGQgZXhw
b3J0ZWQgaW4NCmRyaXZlcnMvdmZpbyBiZSBfR1BMIHZhcmlhbnQ/IFRoZXJlIGlzIGEgYml0IG9m
IGEgbWl4IG5vdy4NCg0KVGhhbmtzIGFnYWluIGZvciB0aGUgcmV2aWV3LCANCkpvbg==

