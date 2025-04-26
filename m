Return-Path: <kvm+bounces-44460-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B68A0A9DCDB
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 21:07:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 277E67B14DE
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 19:06:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B39025E440;
	Sat, 26 Apr 2025 19:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="Esax3aYE";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="tNHQgPkS"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF60F1C5D44;
	Sat, 26 Apr 2025 19:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745694427; cv=fail; b=CEnjw4T5OKRk2TUjWm11J/ZQfEe2/J0Cb39W++9ICml/7cJql14qs1ugxUK3seSfiiqkD4EhUZ9lhjQH18gxlStTvCG4+QBIcrpJV+Ah9Tya3eqIEJ22duN+H2AJXUAzbvvSe79UyV3UKRQG7FAM4eV2lAy+m4kli/6UulrsvhM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745694427; c=relaxed/simple;
	bh=nrXbtsg9xTTUJcISz1PqeDG8lwPb9xmmIiP8tOY+c4Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BH2NNUV5796yNpv34J41g2/S8wLMoFJFE7VvkWgWuhqBi4hqvy3yjCjS2j41YURYb+sAiEOljhE0/MmvHR51CNPSkGc/u6v4PHIphcGXtn7PbOUmC+p10tAk192quDqqSSvJ2Mn7Og2aZJGvzje3mj6CnfBJO2qxRZNykdtkrFc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=Esax3aYE; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=tNHQgPkS; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53Q9cslG011773;
	Sat, 26 Apr 2025 12:06:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=nrXbtsg9xTTUJcISz1PqeDG8lwPb9xmmIiP8tOY+c
	4Y=; b=Esax3aYE5ahmqGbWlRs66PmAR6C/8L/D+3A0N0ne2ivPonBjwJuucqg5O
	U5X6S78JSUhCYZbNah9MaYRItcC+bO+G54LXBW+jfKw3PCUvxD12W0Oo2zPh3RWe
	909jA3vPcm/ZNvWvFH96fxf78KHIjwv/9ZNTugk1dW5EoSyqlAioR2nnsFZRGWkd
	9eACnWb+DJNeE1jFTx2Mk1BYOFs3f651zAP/jBXIjnEUdI0r0/Kx+v8yZB3z/QNK
	TlcMJnhssMWw7bzmHtjjkWo95ux1BAV68KTvd/mMUDnCwL+5zyou9X6Eaqr1pmjf
	8KPMZyhQo8L//zbsJN6xyf9Tmwt9A==
Received: from cy4pr02cu008.outbound.protection.outlook.com (mail-westcentralusazlp17011029.outbound.protection.outlook.com [40.93.6.29])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 468w17rh8u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 26 Apr 2025 12:06:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G0IhwPVmJ+35lw3OgwkVxZWPnfCgimlyhqdDMCHkaWVu3h41/nr8vWAZtkOCPRhWU0HQqYlBXN47aIMsgm09XFmhbK/XJnW9XilC758ucRUD8JE3IvgKpk/cnGdjRaYN7tkkdy581OptbFP9vQPmdhw/DyzCyhOyGHApRGF/WUABC6T1dAy3AftayvK68eiU2Ckm9bh99do9kQ5vs7cf9IhaqD+y8vBuHDL9MlzRalLyWI4QcmvuG27K91j3nyaDAukLf3uu3cifztc/BS0k6xQgfPOl+qZFF7B/j/o33n5nlasQh0Aps1iySKJ//MTbj4N5SzbAlT9kFuSvvOoLXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nrXbtsg9xTTUJcISz1PqeDG8lwPb9xmmIiP8tOY+c4Y=;
 b=LOEkCMvFv3EPLrKknJrB/ZhhG+0hDadSrhKpFjQaKdKeUkj9Be80Mcmy2MRv0+NJS3iKkDvB7sy7aH1fLdk1eL3EeWf9J0VgCbVSvXxR/Wtr729bjdgVTuSAUb0zsoYCvrhu2YK+S0A6Gwy0IfItr4Vzo/lmnFZX3V2iCDjbemCyKW8c15VlaS0FJBrrpqOhWkr/Gm6Gav7miwNtC2vHTFw+dC/e9VPgszudemHn57AhlP5nLlg6WG6c01C9mCoYudsnu38tOqT8+JsKs7jBUQldxfBN3Bg11uf/RnIq+TEyLKizF9ndMyuU4x32p7+gxYg2XR6+P7Y7hz4EGNEGQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nrXbtsg9xTTUJcISz1PqeDG8lwPb9xmmIiP8tOY+c4Y=;
 b=tNHQgPkS3goCriyUxQBpwwyIGHzljyQBXRMthuzvAPnFAWIMgPd0Yp4Yrxsgio7jfcSy8FKTAkeNpF0A16jZRHq2/C6XOC9iS/nHlnUuqHBLgHcAG2re/yWPx0Mtdm8XVMk8gyjqUgjG93meTQlwRXd0IgLRJSQxLkwvLq1t7GhLlRe6dqsRPkCM8Oqut+Y+6B2rN5zK763U+/POvuuGEJgaMpx3lqxvl+v3y7zaYqfHNI+aMiLSqJ5qccmEgtc+pDGSUmC1XUSAqPdPYp3pp3NJg5nFt2ekFo2rkU4lHApIqjAkUOsapp86qTWr7XUj3vw5t8CH0irCdmKBxN8XpQ==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by CH0PR02MB8150.namprd02.prod.outlook.com
 (2603:10b6:610:10b::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.10; Sat, 26 Apr
 2025 19:06:47 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%4]) with mapi id 15.20.8699.012; Sat, 26 Apr 2025
 19:06:47 +0000
From: Jon Kohler <jon@nutanix.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Paolo Abeni <pabeni@redhat.com>, Jason Wang <jasowang@redhat.com>,
        =?utf-8?B?RXVnZW5pbyBQw6lyZXo=?= <eperezma@redhat.com>,
        "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>,
        "virtualization@lists.linux.dev"
	<virtualization@lists.linux.dev>,
        "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2] vhost/net: Defer TX queue re-enable until
 after sendmsg
Thread-Topic: [PATCH net-next v2] vhost/net: Defer TX queue re-enable until
 after sendmsg
Thread-Index: AQHbsYwmjuQam6Y/SEmtlBggg4gnP7OyupuAgAAGMoCAA5jFgA==
Date: Sat, 26 Apr 2025 19:06:47 +0000
Message-ID: <368F25EF-AC86-4FB6-B119-8DBE8DDE8F09@nutanix.com>
References: <20250420010518.2842335-1-jon@nutanix.com>
 <a0894275-6b23-4cff-9e36-a635f776c403@redhat.com>
 <20250424080749-mutt-send-email-mst@kernel.org>
In-Reply-To: <20250424080749-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.400.131.1.6)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV8PR02MB10287:EE_|CH0PR02MB8150:EE_
x-ms-office365-filtering-correlation-id: 90316a27-870a-4989-e3e8-08dd84f57e2f
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?dE9UUWdHamZ1b1RTUDdwQUMrbExrZERubmdYSCtzOWRrUWhPUFhFZ2I5T1U3?=
 =?utf-8?B?YkNXN2IzaHRVUXk2QXEzOXpHMS9FWEs3RjhjTjhjOTJqRXVzQ0MwVkwxUGR6?=
 =?utf-8?B?RG5DazFKY0NJdnlabUhUTnpXVndhbzZRZ0w1K0ljNUZraUpxRjlYUjJFcEdE?=
 =?utf-8?B?ZGdsM1grYlpaZmgvczRIcGlkeUh2Z1dLaFhRVytGU3luL0ZEN3dLYitZWmdE?=
 =?utf-8?B?RitHTVo3SWlZRWJpTElNVlYzUTJGcE5IbzQvdGY2WitQcWhIVnFSUnh0RC92?=
 =?utf-8?B?ckwvRXFxbGFPdDRNdVFuQkZIQVdUbW1EaWY2MDJWTlFpK1BaWkk4L2pjelpu?=
 =?utf-8?B?bGlGMEd0UXdDUGNNb2lmSDVJWVA4b3hSWmJVeXJxNEIrNUhHZ0lZQStGR1ZU?=
 =?utf-8?B?U1U1VWJBTU1hS1V2Y1FrQzEwNzBZRWlEN0tkZ1RZb3hvMHpNUXJxbTVyNk81?=
 =?utf-8?B?U3RqNXVQRC9BMENJZUtlRkhrbExGVUNVSjlMZzlxclFDbTdFcy9VNm5aTXpr?=
 =?utf-8?B?d0VBUFJSbDJWSjZ3eHhJM2E3dzRwb1dCMDJTMDFWU1dVTUJaS3krTTNjNy9v?=
 =?utf-8?B?L0JybGlhVjVEVUtvVUhDbndjUzVmNVl6a1JodTZNc1pkZDZoaUN6V1Fnd0VI?=
 =?utf-8?B?VTZLRHRwMzdBY25YUGRCNjRXTmZyVkp3eDQ5clFkMDJqcDNjbDBRQjNoY1Nu?=
 =?utf-8?B?ay9jK0kzNTloSWtic05IVzI4bHR1OHNTaVhOSmNoRTFJNGNvSytmWTZZZnYz?=
 =?utf-8?B?cXlBbHFPVmhPYU56RmFET1Jkd2lVSGtZQ2RIUmJ4U3pNRzBMam93RzBubEZ4?=
 =?utf-8?B?anJuSno0TEhBdWpnUzdMdnhUdTBtMjl5SjdsRENZSjI3M1YwTVFJZkF0eFVt?=
 =?utf-8?B?NURlTXNHOG1xeGdDc0JHZmF3RkRPcjJYTGtrUm5rNWhSOEJhUzR3UWM1ZWkw?=
 =?utf-8?B?S0hRSXlBYnFHM0dUVDd3dG1DYVVwWVlaZisvNmhBZmxKOWxjby9PNUxTNUdU?=
 =?utf-8?B?RGdhMGQ1clVDc0JEdUVrRHFIR25wV2U0VVUrdnRZdXQrbFlBM2prR3d2Yk9O?=
 =?utf-8?B?RTZieFlwK0o5VnJTTnpZRWdjb0FvS3FpbnNqaG5VOC9rUml6OXdZV1ZWOHhQ?=
 =?utf-8?B?Z3FlcFNYOU5FZ1ZSRDh4enFlTkQ4T25QbVlhencrcmZXclJYVlpvWXVoYWpW?=
 =?utf-8?B?cHFIaEFoQlE2N3I3SGRZQmxxNEVENmlkZnVLN1dDbHJuQkVXdjkzNVExSGx0?=
 =?utf-8?B?SU1QbVNYV0gybi9JVnJnREd2UVpEdDlDNmlOV2hzU0NNai9vclVJSFJZT3F1?=
 =?utf-8?B?T3RUeEN5bTlqdE9LWWNnS3hJTllCRC94NitTRGFMeURLZUNsbmJCYkVBUXZT?=
 =?utf-8?B?eDN3VDV0S3BUdHllN1A0QWNFZFJiaC85UnBXNWd3UW9XUXJYM2Q1R1RhdGhn?=
 =?utf-8?B?aldVOUpNc2ZFNTdzWFpvWHZnNmNhdHprQ0xVc3V5L1NIZjZGZm9RdGQzVnN1?=
 =?utf-8?B?S01EK2VuN1R4Q0pUOFN5VTlrUmlUWm4vbk1IRXpoT0VxVWwrS3MxaktvcHNK?=
 =?utf-8?B?cFVKNS9YZ1F5ZmI2REJoajBSanVYTmFHZUFJMklPK0JqOWZ4RnVWZXZiL3Js?=
 =?utf-8?B?Wmk0alpLRWw2SWh2czlIejdIcGsrL3VnN1dwOTJCQnlHNnp2c1NiWUFCbGI0?=
 =?utf-8?B?bDFVM2NRdDhTVjBueXJlYVBtTTZ6UUdUdXRCdjdhSXQxeXlyay9TQUZ6QXB2?=
 =?utf-8?B?WGxzdEF1Vjk4U0R4S011bnYrbk5CR1ZXMjE5cWpla0tpaDZmNEF0OS94UlNK?=
 =?utf-8?B?QXpodWhBSzNmRkpBNmlPdDZCa1lPa05NaXJDaHJ5K3Nmd3ZoZUdRRDA0MHJE?=
 =?utf-8?B?K1FlWDdmUzZtZTc5QzVSTFhPMURVZlRTZWY3L282aVJENStxSmk2YzlxcElT?=
 =?utf-8?B?Zm0vRTVKSG5RYThqQ1BTdFFrRTFlWjJjQXBpcWhPQkJJQmFLQ250SzFaMkdF?=
 =?utf-8?Q?1T7u4LJlyjUCrc9yy9zMFenUdBWdbw=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RkdzSzJjKzgyNThoOHFkZnNlTXFPOGJrL2VWNFErdEt1WldhTXE3WUdPNVFa?=
 =?utf-8?B?SjgxQzlqaVZ3UEJvVWw0b3NpSFNZYjBGVlFIVUlxY2RTc0JGWFdNVUZPNC9Z?=
 =?utf-8?B?T0VFSzVPeEIxUDIvejQ0R2RhMlN6YXJ2d0RUc2c5YWp2anA4ODBtV1FkWGFt?=
 =?utf-8?B?OTdYNExJK1FTMTdHc2dYQktLK205MWJIOGVJc1BFQjJ1U2ZmV3ppSlhtMlN3?=
 =?utf-8?B?SUl6VGVRUEM2MXU5OHJ5RHdvTnNuSkFRTGZ5akR1TGRoT0FvLzA1QURHNXBH?=
 =?utf-8?B?ZHlqUCtpV2RwSWdJaXIrbmN6Z3RjVk5QUTl1Z2xGVUNMMGNoNkJEQ3g2MXhj?=
 =?utf-8?B?UjlvZG1OMGI4MGx2eThOVHd5MDlzVTh1SWErUzlpSm9YaWRJbWkyK09hNjU5?=
 =?utf-8?B?NGNNY29Ud0xVcUxvM2JQb1JKYmkxNzh0SUJ2OVlCNlBmNU9qT2FkNXFJTDVj?=
 =?utf-8?B?dXJkc1FDWDB6TTNUMDhUbjJsekJvclY4bFEyRWRkQzFyeTRhdW5tWk9LNC9p?=
 =?utf-8?B?NjRMbU1aMDRGcENnS1c0eUppN3BRcXljNk1od1NnY3RrdmorMWZoQlNEZ3Ax?=
 =?utf-8?B?WHhGYzJYQVNFMGN6aUZxc1gySzZ2T1dod1Z0bXdOWGRnbmxhdWx2TitQbVhX?=
 =?utf-8?B?YXRld0ppVUhxU1pJZXBmYTAvRldQNCt6QkZrN1JiRDlQUHBJQWZNVm5xZGRm?=
 =?utf-8?B?L0phMld1SE9ySC9ROGwzUS96eVFESFdZTXJHTVJMVW1VeHVSU0wycXduUkJT?=
 =?utf-8?B?d0pjeUpGZjZXMGN4S3diT2VQV2QxaUc2bGhyaWF2bXF2ZWRNa1g4R2NUR1py?=
 =?utf-8?B?V1A5cE9zOXg4S2t3ODFPMzJtT3E3RUJDWDh1TW5IR0xQZUJMbUJ2ZnVXNW53?=
 =?utf-8?B?K093WUU3TW9INXF6NmprcDhacDF1WTJaTnNsK1IvQzBJQ3BCRFF4T0R2Qzdm?=
 =?utf-8?B?QnFzQzFKV0Zwc0dYemFCMHczNFY0RjZnVFlxcDlkUXBBUnhLWmp3Vk4yRnBI?=
 =?utf-8?B?QkQ5UjJ3WGJHdFMydTdDenpFbEY0cFJ1b3pTNmV6MWtXN25NQllFNEJvNjRp?=
 =?utf-8?B?YWtjbm02SWM2KzVIYldCckxZZlN4aTh0aFZEZEErYjJPRTdIMGhvMGhkWEZG?=
 =?utf-8?B?Wm5VOFBBQ1UwUnZnSFNOMFNrUFVaRjNzSW9kbXNRUVRac05aclhHN2VvdzZ3?=
 =?utf-8?B?RHhkVFBBZHpnTks1QXhiUFI4eGV5aE5rMU9XTnArZUNURGZtZ3RkZVNtaUFp?=
 =?utf-8?B?bzl4RHhjaDJ3bnVJazl5NUR4VTdselR1cVN6aGFtZEVZMTZnS1lDc1FQSzNz?=
 =?utf-8?B?cmQ0VEZXRGx4blVjNGtNU2YwRnJZNzk0UXlGRmo2a1NZUEhkR202Qk1rY3Fi?=
 =?utf-8?B?UjE1clFQM3NBZnlRY1B0RXRxT2VtTzJsKzUzYXhPTlRsNm50Q0lmY2lkcnBV?=
 =?utf-8?B?d2phcTErS2tTNDV4emNkSXNodUhlbk9YN0lwVkZzZllDU0dldTl2cFB1T1dC?=
 =?utf-8?B?WlNoTTVkSDM5SU1kaXdNZlhxYjlReTRCYmVuOTJLYzExZEhIL3BDYkhqR2Ru?=
 =?utf-8?B?V0xIQjVqakJoZXg0clNXTjdvd0RYbHJLdUdKVksyb3FDcGtQNVRhUFByaVBF?=
 =?utf-8?B?OGhkaVg5S0FDWENMVGRoSWQrUC9mTm1xVkR0VzdSajZoWUVYRk53bFBsZldT?=
 =?utf-8?B?cEZzZ1hIdXYyaURGRHc4dUpUNmFqbzNGSGVJTHF1bWszMThmaUJhYU9aTjND?=
 =?utf-8?B?bHM2WEVHbnFGNVJTTlJCMmFyNmJ5cHQ5dU5TTE5BT09GcDhleFFUNjcrWXNk?=
 =?utf-8?B?bUtEU0xQMEZoVTFsVW1hZTdscUdKc2REUWZxK3JOdEdhSFZqYUpXOVoxaU9N?=
 =?utf-8?B?OW42ZUs2V2FRZFdlUkR3WkkxREM4eTYvTHhkOU9Ma1duOEQvOFpJblFrK1FS?=
 =?utf-8?B?R3JuNzhvOXB1ZVV5VHVwb2NJL09BYy9tS3ZqRC80RTNHOFl1Q0p0ZUppdm5T?=
 =?utf-8?B?ZzhLNFZkcVBtd1ZyYWh3Y1Qydk5wc0hUdWdRSVY3M0QxQmw0VUdOWFJlZEIy?=
 =?utf-8?B?SlB0LzAyZU5mcHdpVTRGWUNHUC9adUZrcWZMemFmK3hUZVBVYloxOE9hQlVy?=
 =?utf-8?B?dHhxcEltYlArbnEwNUNQS1Y3eTJxRE9rSzZUZEVTaTd4LzdCMEVwd21mdzBY?=
 =?utf-8?B?dVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <061EBBA866B73E4DB7BE2AA8B1AF9E8B@namprd02.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 90316a27-870a-4989-e3e8-08dd84f57e2f
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Apr 2025 19:06:47.5312
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dVeHJz0zWjvv78BmSH8AMEDioLpkAcFKu8bwNqC0fuy4tgGOt2jCYmH4QufcrRKFOjaqdXOlb4M1d/k55kWdwVtTybQF+9odGTSwlYlD9pE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR02MB8150
X-Proofpoint-ORIG-GUID: Rkk2ygeyHbGYdvjICG38S8TgJZlhOacX
X-Proofpoint-GUID: Rkk2ygeyHbGYdvjICG38S8TgJZlhOacX
X-Authority-Analysis: v=2.4 cv=VITdn8PX c=1 sm=1 tr=0 ts=680d2ecc cx=c_pps a=MGIL9jhmtb3Hqg0nl2vIzw==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=XR8D0OoHHMoA:10 a=0kUYKlekyDsA:10 a=20KFwNOVAAAA:8 a=errH5zuwLQWypmTLywcA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDI2MDEyOSBTYWx0ZWRfX8zCKV5WhLtSx gZYwI9YNyprWoq9Q9uN8x7q1e6mDGo74VyYaPb+P290IFaQwOshy5azF8IZda9kYUzSBPctQxzt fMqBWT69H0dYTK++pGYGl+yCEJ/ewhzQVVh4UJHMV25S5sWtgaCMtS6CUepkcuGHOKSkA6TiWxR
 qNQkt2GL8eW7MrQHHUwe6DnthX+q3XCcKh1RdNs7tNhdsIk5XVDILy3Xq+OuFV6W0PXZJ2ev5cA bddwnQLkQcvKYQJFonCQSWNvb/QDxtxw6/zu3fxewkVMjl/Ty+WHyU+lK3jbngWV7P+jYeAZQ1S 0RDTaWqnyMekZLUV31QV7WhZoB2YMwz2XB+ypKvQuKubTrf1q7FNXqDo0gFwxyvIZD+6SC5t38g
 YyCMeEIha3SXuC0lDAhDWOlKi6paBIJ3KgNAkcRoCtLLabSr2qM1WoDbR3hdHRhybHQL62Zh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-04-26_03,2025-04-24_02,2025-02-21_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gQXByIDI0LCAyMDI1LCBhdCA4OjEx4oCvQU0sIE1pY2hhZWwgUy4gVHNpcmtpbiA8
bXN0QHJlZGhhdC5jb20+IHdyb3RlOg0KPiANCj4gIS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS18DQo+IENBVVRJT046IEV4
dGVybmFsIEVtYWlsDQo+IA0KPiB8LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSENCj4gDQo+IE9uIFRodSwgQXByIDI0LCAy
MDI1IGF0IDAxOjQ4OjUzUE0gKzAyMDAsIFBhb2xvIEFiZW5pIHdyb3RlOg0KPj4gT24gNC8yMC8y
NSAzOjA1IEFNLCBKb24gS29obGVyIHdyb3RlOg0KPj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Zo
b3N0L25ldC5jIGIvZHJpdmVycy92aG9zdC9uZXQuYw0KPj4+IGluZGV4IGI5YjllOWQ0MDk1MS4u
OWIwNDAyNWVlYTY2IDEwMDY0NA0KPj4+IC0tLSBhL2RyaXZlcnMvdmhvc3QvbmV0LmMNCj4+PiAr
KysgYi9kcml2ZXJzL3Zob3N0L25ldC5jDQo+Pj4gQEAgLTc2OSwxMyArNzY5LDE3IEBAIHN0YXRp
YyB2b2lkIGhhbmRsZV90eF9jb3B5KHN0cnVjdCB2aG9zdF9uZXQgKm5ldCwgc3RydWN0IHNvY2tl
dCAqc29jaykNCj4+PiBicmVhazsNCj4+PiAvKiBOb3RoaW5nIG5ldz8gIFdhaXQgZm9yIGV2ZW50
ZmQgdG8gdGVsbCB1cyB0aGV5IHJlZmlsbGVkLiAqLw0KPj4+IGlmIChoZWFkID09IHZxLT5udW0p
IHsNCj4+PiArIC8qIElmIGludGVycnVwdGVkIHdoaWxlIGRvaW5nIGJ1c3kgcG9sbGluZywgcmVx
dWV1ZQ0KPj4+ICsgKiB0aGUgaGFuZGxlciB0byBiZSBmYWlyIGhhbmRsZV9yeCBhcyB3ZWxsIGFz
IG90aGVyDQo+Pj4gKyAqIHRhc2tzIHdhaXRpbmcgb24gY3B1DQo+Pj4gKyAqLw0KPj4+IGlmICh1
bmxpa2VseShidXN5bG9vcF9pbnRyKSkgew0KPj4+IHZob3N0X3BvbGxfcXVldWUoJnZxLT5wb2xs
KTsNCj4+PiAtIH0gZWxzZSBpZiAodW5saWtlbHkodmhvc3RfZW5hYmxlX25vdGlmeSgmbmV0LT5k
ZXYsDQo+Pj4gLSB2cSkpKSB7DQo+Pj4gLSB2aG9zdF9kaXNhYmxlX25vdGlmeSgmbmV0LT5kZXYs
IHZxKTsNCj4+PiAtIGNvbnRpbnVlOw0KPj4+IH0NCj4+PiArIC8qIEtpY2tzIGFyZSBkaXNhYmxl
ZCBhdCB0aGlzIHBvaW50LCBicmVhayBsb29wIGFuZA0KPj4+ICsgKiBwcm9jZXNzIGFueSByZW1h
aW5pbmcgYmF0Y2hlZCBwYWNrZXRzLiBRdWV1ZSB3aWxsDQo+Pj4gKyAqIGJlIHJlLWVuYWJsZWQg
YWZ0ZXJ3YXJkcy4NCj4+PiArICovDQo+Pj4gYnJlYWs7DQo+Pj4gfQ0KPj4gDQo+PiBJdCdzIG5v
dCBjbGVhciB0byBtZSB3aHkgdGhlIHplcm9jb3B5IHBhdGggZG9lcyBub3QgbmVlZCBhIHNpbWls
YXIgY2hhbmdlLg0KPiANCj4gSXQgY2FuIGhhdmUgb25lLCBpdCdzIGp1c3QgdGhhdCBKb24gaGFz
IGEgc2VwYXJhdGUgcGF0Y2ggdG8gZHJvcA0KPiBpdCBjb21wbGV0ZWx5LiBBIGNvbW1pdCBsb2cg
Y29tbWVudCBtZW50aW9uaW5nIHRoaXMgd291bGQgYmUgYSBnb29kDQo+IGlkZWEsIHllcy4NCg0K
WWVhLCB0aGUgdXRpbGl0eSBvZiB0aGUgWkMgc2lkZSBpcyBhIGhlYWQgc2NyYXRjaGVyIGZvciBt
ZSwgSSBjYW7igJl0IGdldCBpdCB0byB3b3JrDQp3ZWxsIHRvIHNhdmUgbXkgbGlmZS4gSeKAmXZl
IGdvdCBhIHNlcGFyYXRlIHRocmVhZCBJIG5lZWQgdG8gcmVzcG9uZCB0byBFdWdlbmlvDQpvbiwg
d2lsbCB0cnkgdG8gY2lyY2xlIGJhY2sgb24gdGhhdCBuZXh0IHdlZWsuDQoNClRoZSByZWFzb24g
dGhpcyBvbmUgd29ya3Mgc28gd2VsbCBpcyB0aGF0IHRoZSBsYXN0IGJhdGNoIGluIHRoZSBjb3B5
IHBhdGggY2FuDQp0YWtlIGEgbm9uLXRyaXZpYWwgYW1vdW50IG9mIHRpbWUsIHNvIGl0IG9wZW5z
IHVwIHRoZSBndWVzdCB0byBhIHJlYWwgc2F3IHRvb3RoDQpwYXR0ZXJuLiBHZXR0aW5nIHJpZCBv
ZiB0aGF0LCBhbmQgYWxsIHRoYXQgY29tZXMgd2l0aCBpdCAoZXhpdHMsIHN0YWxscywgZXRjKSwg
anVzdA0KcGF5cyBvZmYuDQoNCj4gDQo+Pj4gQEAgLTgyNSw3ICs4MjksMTQgQEAgc3RhdGljIHZv
aWQgaGFuZGxlX3R4X2NvcHkoc3RydWN0IHZob3N0X25ldCAqbmV0LCBzdHJ1Y3Qgc29ja2V0ICpz
b2NrKQ0KPj4+ICsrbnZxLT5kb25lX2lkeDsNCj4+PiB9IHdoaWxlIChsaWtlbHkoIXZob3N0X2V4
Y2VlZHNfd2VpZ2h0KHZxLCArK3NlbnRfcGt0cywgdG90YWxfbGVuKSkpOw0KPj4+IA0KPj4+ICsg
LyogS2lja3MgYXJlIHN0aWxsIGRpc2FibGVkLCBkaXNwYXRjaCBhbnkgcmVtYWluaW5nIGJhdGNo
ZWQgbXNncy4gKi8NCj4+PiB2aG9zdF90eF9iYXRjaChuZXQsIG52cSwgc29jaywgJm1zZyk7DQo+
Pj4gKw0KPj4+ICsgLyogQWxsIG9mIG91ciB3b3JrIGhhcyBiZWVuIGNvbXBsZXRlZDsgaG93ZXZl
ciwgYmVmb3JlIGxlYXZpbmcgdGhlDQo+Pj4gKyAqIFRYIGhhbmRsZXIsIGRvIG9uZSBsYXN0IGNo
ZWNrIGZvciB3b3JrLCBhbmQgcmVxdWV1ZSBoYW5kbGVyIGlmDQo+Pj4gKyAqIG5lY2Vzc2FyeS4g
SWYgdGhlcmUgaXMgbm8gd29yaywgcXVldWUgd2lsbCBiZSByZWVuYWJsZWQuDQo+Pj4gKyAqLw0K
Pj4+ICsgdmhvc3RfbmV0X2J1c3lfcG9sbF90cnlfcXVldWUobmV0LCB2cSk7DQo+PiANCj4+IFRo
aXMgd2lsbCBjYWxsIHZob3N0X3BvbGxfcXVldWUoKSByZWdhcmRsZXNzIG9mIHRoZSAnYnVzeWxv
b3BfaW50cicgZmxhZw0KPj4gdmFsdWUsIHdoaWxlIEFGQUlDUyBwcmlvciB0byB0aGlzIHBhdGNo
IHZob3N0X3BvbGxfcXVldWUoKSBpcyBvbmx5DQo+PiBwZXJmb3JtZWQgd2l0aCBidXN5bG9vcF9p
bnRyID09IHRydWUuIFdoeSBkb24ndCB3ZSBuZWVkIHRvIHRha2UgY2FyZSBvZg0KPj4gc3VjaCBm
bGFnIGhlcmU/DQo+IA0KPiBIbW0gSSBhZ3JlZSB0aGlzIGlzIHdvcnRoIHRyeWluZywgYSBmcmVl
IGlmIHBvc3NpYmx5IHNtYWxsIHBlcmZvcm1hbmNlDQo+IGdhaW4sIHdoeSBub3QuIEpvbiB3YW50
IHRvIHRyeT8NCg0KSSBtZW50aW9uZWQgaW4gdGhlIGNvbW1pdCBtc2cgdGhhdCB0aGUgcmVhc29u
IHdl4oCZcmUgZG9pbmcgdGhpcyBpcyB0byBiZQ0KZmFpciB0byBoYW5kbGVfcnguIElmIG15IHJl
YWQgb2Ygdmhvc3RfbmV0X2J1c3lfcG9sbF90cnlfcXVldWUgaXMgY29ycmVjdCwNCndlIHdvdWxk
IG9ubHkgY2FsbCB2aG9zdF9wb2xsX3F1ZXVlIGlmZjoNCjEuIFRoZSBUWCByaW5nIGlzIG5vdCBl
bXB0eSwgaW4gd2hpY2ggY2FzZSB3ZSB3YW50IHRvIHJ1biBoYW5kbGVfdHggYWdhaW4NCjIuIFdo
ZW4gd2UgZ28gdG8gcmVlbmFibGUga2lja3MsIGl0IHJldHVybnMgbm9uLXplcm8sIHdoaWNoIG1l
YW5zIHdlDQpzaG91bGQgcnVuIGhhbmRsZV90eCBhZ2FpbiBhbnlob3cNCg0KSW4gdGhlIHJpbmcg
aXMgdHJ1bHkgZW1wdHksIGFuZCB3ZSBjYW4gcmUtZW5hYmxlIGtpY2tzIHdpdGggbm8gZHJhbWEs
IHdlDQp3b3VsZCBub3QgcnVuIHZob3N0X3BvbGxfcXVldWUuDQoNClRoYXQgc2FpZCwgSSB0aGlu
ayB3aGF0IHlvdeKAmXJlIHNheWluZyBoZXJlIGlzLCB3ZSBzaG91bGQgY2hlY2sgdGhlIGJ1c3kN
CmZsYWcgYW5kICpub3QqIHRyeSB2aG9zdF9uZXRfYnVzeV9wb2xsX3RyeV9xdWV1ZSwgcmlnaHQ/
IElmIHNvLCBncmVhdCwgSSBkaWQNCnRoYXQgaW4gYW4gaW50ZXJuYWwgdmVyc2lvbiBvZiB0aGlz
IHBhdGNoOyBob3dldmVyLCBpdCBhZGRzIGFub3RoZXIgY29uZGl0aW9uYWwNCndoaWNoIGZvciB0
aGUgdmFzdCBtYWpvcml0eSBvZiB1c2VycyBpcyBub3QgZ29pbmcgdG8gYWRkIGFueSB2YWx1ZSAo
SSB0aGluaykNCg0KSGFwcHkgdG8gZGlnIGRlZXBlciwgZWl0aGVyIG9uIHRoaXMgY2hhbmdlIHNl
cmllcywgb3IgYSBmb2xsb3cgdXA/DQoNCj4gDQo+IA0KPj4gQE1pY2hhZWw6IEkgYXNzdW1lIHlv
dSBwcmVmZXIgdGhhdCB0aGlzIHBhdGNoIHdpbGwgZ28gdGhyb3VnaCB0aGUNCj4+IG5ldC1uZXh0
IHRyZWUsIHJpZ2h0Pw0KPj4gDQo+PiBUaGFua3MsDQo+PiANCj4+IFBhb2xvDQo+IA0KPiBJIGRv
bid0IG1pbmQgYW5kIHRoaXMgc2VlbXMgdG8gYmUgd2hhdCBKb24gd2FudHMuDQo+IEkgY291bGQg
cXVldWUgaXQgdG9vLCBidXQgZXh0cmEgcmV2aWV3ICBpdCBnZXRzIGluIHRoZSBuZXQgdHJlZSBp
cyBnb29kLg0KDQpNeSBhcG9sb2dpZXMsIEkgdGhvdWdodCBhbGwgbm9uLWJ1ZyBmaXhlcyBoYWQg
dG8gZ28gdGhydSBuZXQtbmV4dCwNCndoaWNoIGlzIHdoeSBJIHNlbnQgdGhlIHYyIHRvIG5ldC1u
ZXh0OyBob3dldmVyIGlmIHlvdSB3YW50IHRvIHF1ZXVlDQpyaWdodCBhd2F5LCBJ4oCZbSBnb29k
IHdpdGggZWl0aGVyLiBJdHMgYSBmYWlybHkgd2VsbCBjb250YWluZWQgcGF0Y2ggd2l0aA0KYSBo
dWdlIHVwc2lkZSA6KSANCg0KPiANCj4gLS0gDQo+IE1TVA0KPiANCg0K

