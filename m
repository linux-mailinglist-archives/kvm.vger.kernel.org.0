Return-Path: <kvm+bounces-29055-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 83F0E9A1D9A
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 10:53:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E5B06B22262
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 08:53:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC55E1D5142;
	Thu, 17 Oct 2024 08:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b="OMSYHl8p"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C3D8190055
	for <kvm@vger.kernel.org>; Thu, 17 Oct 2024 08:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.156.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729155206; cv=fail; b=lNEdkd9Hr2ssGZSZeIAzjURamJO+cf9qs3MAJpjQAiRYALEUeUa6FxsOHDapc1rj1fANPe81zI2ougkRGvJS5Ikvb76wBDB2b7xJB4yh5wZ743BwKtmp4s9qTho3jMQ6oc6TGQ8SL2a0Opn8fWmj68EQb1M+l7e3dMEvIOabnyo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729155206; c=relaxed/simple;
	bh=Xm6UIVpJLHVqlaaonBphPWsXsa5T1lYUyzafBbIaYCU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=o912a7qW6IhkRKCamk2ChPOCH4YyRM6s2/e2mPA637OyfZw62bjxb+jDo6bU+7xDhpwx8sBTy3BFMOk83Rmm6K94EbkTGmF7kHMNtE50b5eYj2tfXpIVAvz/4+r2EPRMJJm6+wFM+ZDzVfKwLk/gwzxq82qZ1BG3cz4pZYnbT9s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b=OMSYHl8p; arc=fail smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49H5Lcmx018211;
	Thu, 17 Oct 2024 01:53:13 -0700
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2046.outbound.protection.outlook.com [104.47.57.46])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 42avbw0csq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 17 Oct 2024 01:53:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T348KZ4Y+DY/au7PKs8V8VHsVBbyk4IX/Hx/63FdNJzOgtq+9U4nvQ50iiUkgmOLgfKw9ObjmBF923ZnVhuC9nJ3wUHsmZDo7p0kpfJsKWU2IOBYZzde23TzfScZKg6LpeEZg2mHJepbGaWg0gRhF6y2Se/uUa0xYQ5+z7/SD3w/OovhD98Kc6tiCvUekr5B9+w0BsitN4FoziZZtbUZxzMUozLYX6PoLmXF2WjqFPVdetHI2pcdB5fcTOeMLZelSi1IN1HXEfsAcsDVz+nf33tfC71+UCN2ZEkA7FznJrdGfBV4BlmPqTyo7zpzhAMlfWWF49BNJvsT0aVzjaK+gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xm6UIVpJLHVqlaaonBphPWsXsa5T1lYUyzafBbIaYCU=;
 b=Jz1GELtSia/jhpdad/SHBEWqmols8p6bkvcCeFCVUA61Ei33KDp36Srw/TTHn2GrZPFuhv0Nk8Os5DpuNFcd43+NTyGM3792DsaYPOlS8lRtsZcOLtiRWxTBgTCJfKFi/rnPOFeThccVahi8acEVSOh2n015qD91+5QdNIepxURmfbxtbDnIJR2vf+0JAXr46RKIkQf7bba9OXanTNWY39T73JjMfAuyOekl7jVGjWM5j43rzoVRDtDmxiQAb5w9D51Tr2B4oLbdnrCcZDqJKuRopBN7OCiBabGy4YZk5m+A7YMeHvl+4+I9HGHPpYi3L6qLwpP17yNeuXwIB3wWdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xm6UIVpJLHVqlaaonBphPWsXsa5T1lYUyzafBbIaYCU=;
 b=OMSYHl8pXeAUw2fdVSiCvnWKoD/ZSXk2kmuGcjaf9EFz34H/stTuppri+O13GC/ZXEfNCjvk1nHoSuBkkZcAOeam/b6JBljNvY4Gd/1ffMbihCMHDu1O9kdCsvWC8JBfcBShMas0pT3r4W9uYGQBhT+IswR6fWq5klblGf1pE2s=
Received: from DS0PR18MB5368.namprd18.prod.outlook.com (2603:10b6:8:12f::17)
 by SJ2PR18MB5684.namprd18.prod.outlook.com (2603:10b6:a03:563::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.18; Thu, 17 Oct
 2024 08:53:09 +0000
Received: from DS0PR18MB5368.namprd18.prod.outlook.com
 ([fe80::ad53:bef2:cc17:13ac]) by DS0PR18MB5368.namprd18.prod.outlook.com
 ([fe80::ad53:bef2:cc17:13ac%4]) with mapi id 15.20.8048.020; Thu, 17 Oct 2024
 08:53:09 +0000
From: Srujana Challa <schalla@marvell.com>
To: Christoph Hellwig <hch@infradead.org>
CC: "virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mst@redhat.com"
	<mst@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        Nithin Kumar Dabilpuram
	<ndabilpuram@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>
Subject: RE: [EXTERNAL] Re: [PATCH v2 0/2] vhost-vdpa: Add support for
 NO-IOMMU mode
Thread-Topic: [EXTERNAL] Re: [PATCH v2 0/2] vhost-vdpa: Add support for
 NO-IOMMU mode
Thread-Index: AQHbE96PlQaeJdnt006ohvbKHfff0rKGTA1AgAD2ZICAAnCmAIAA3iwAgAALuYA=
Date: Thu, 17 Oct 2024 08:53:08 +0000
Message-ID:
 <DS0PR18MB53686815E2F86EFC5DFE1E45A0472@DS0PR18MB5368.namprd18.prod.outlook.com>
References: <20240920140530.775307-1-schalla@marvell.com>
 <Zvu3HktM4imgHpUw@infradead.org>
 <DS0PR18MB5368BC2C0778D769C4CAC835A0442@DS0PR18MB5368.namprd18.prod.outlook.com>
 <Zw3mC3Ej7m0KyZVv@infradead.org>
 <DS0PR18MB5368CB509A66A6617E519672A0462@DS0PR18MB5368.namprd18.prod.outlook.com>
 <ZxCsaMSBpoozpEQH@infradead.org>
In-Reply-To: <ZxCsaMSBpoozpEQH@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR18MB5368:EE_|SJ2PR18MB5684:EE_
x-ms-office365-filtering-correlation-id: 306c31a3-a935-43ef-3668-08dcee891fb8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?ajI1OExKMHpnamZza3gwM1JIczVQSnFlOGNydWUxaFk1QXlnZkVpQjZlMGNH?=
 =?utf-8?B?U002eGJ2N2oyRFM5cHJnWHdtTTc0T002YndQYWw0c1A2TEdYTWJuMmhTd0F6?=
 =?utf-8?B?RzdpY0JCaVIvN2ZVRW1UZ1YwelBIaWJPbHcrMmd3R0JSVS93UXJjaXZzcnRn?=
 =?utf-8?B?RktCdy9qUkJWb24xRTdiUHkyaEFYNjF2VEJueWkvWEc4dU9qOVF3aHZTSWt4?=
 =?utf-8?B?d05CUU5kcDczY3RVVC82azQvQUxEY1RNaHFCWldkZ2YvR0VRMlUzQlZ4bE1j?=
 =?utf-8?B?VEgvcVBpdUhsRGpnbkkvR3hoSUhjb1B0R1RER3QrWmZ0cXNqdjZ1M01WRUY5?=
 =?utf-8?B?QjVtbks1K0ZodldKSHFzRHpkUHRnRm9TRUpFb1lBTmMycTNxL25zaHlXOXJB?=
 =?utf-8?B?YmhOMW1RSkhrbU1VTFFZRnQzaGxoRFVoaThXbUdQQ1V4K0dMcy8raUpGc29L?=
 =?utf-8?B?MjM3L0sxNW83VVJQamJmSm9tN0o3bTQzSGthK0JaYVdKVGNIdFJ4VVc5Ykc2?=
 =?utf-8?B?UDArejdwTC9HYS9uRlNVbk5PamFndEZkbVF4TW9mYkpzQXBsaGNmZ2ZVME1x?=
 =?utf-8?B?dnM1LzVmcTIyK3ZFODNNc1QvVVVZaFdlRlByOVlGeDZHUzBpN3NRQ214bWRY?=
 =?utf-8?B?UlpkcXpYUG1MOTVIckNrUzdUL1FoMVVYNWlEZngxSlk0dWl5dm1NQWFCck5O?=
 =?utf-8?B?VFo2ZmJicjc4YUFLbjlvb1pxWU5udUFScFQydDB5RVFIblBreTM4OXFuY2cw?=
 =?utf-8?B?bEcrZDhCYit2TkpnNlBuTVRaQ3A2M1hYajFUNFU3OGZoaWxXRkxvS0VWYUdV?=
 =?utf-8?B?Z2FKZnA4RHBqZldsb0RacnZTaE1mV3NFVmFqaXd4OTc5ODZIWnhsclJBMmhU?=
 =?utf-8?B?eDkzL2RFb2c5b3lXVTlUL2JEaFlRbjNFM1NKdkFlMlBKVHcyeUVJSWM3MFF6?=
 =?utf-8?B?TnBxM0hkV1hCTmJJZlpBMmt4SmVzaFZFdEphU1I0bmlGNXdET0o5WjlmZUti?=
 =?utf-8?B?QU1yUDVJcTBJQ1pkNzJwekdJSEkzejNoa0h1SkJZUE1BdGR5dk1laG5UNUo0?=
 =?utf-8?B?UHMwR0hkc0NQaDJyRmsvM1JTc3ZwNUF0MSt1RjBnY2p0YnE4Y05Bb29uejRx?=
 =?utf-8?B?U3VXOW9zSFFwdmFQM25aVy95a0d0YTVTc1RDNnpGRStYeDJGblk5RE50VGp5?=
 =?utf-8?B?Um9OR1BObEZieTdxZXRsRGJwNTVMcUFhR1lOZnpVYXMzMjFJOWV6aHJrUXZz?=
 =?utf-8?B?MDg0alZLS3cwS3o0RmQ5Q09mN2RVa20rY3gxdzZrOVJFUmdNVm9TcGtGckJl?=
 =?utf-8?B?Q0dZOERBdmZWTDhZcGFSZWRsVGlhTnptSmxBRjdqbkRpMlFXNWZ2VXhXdjh2?=
 =?utf-8?B?eFIwZk9BcWdJZXozY1FwRjJPdy9FeUtIK3lsU2c0VWVHNnozbURaYjUyVnli?=
 =?utf-8?B?bzgvOHhOd0R0Qzd3TXY3TVI1WUJERksrM1FUdk4xbDlPY1VJY0piY0l3Y05G?=
 =?utf-8?B?VENpd3JKR1ZmaStmSFY2ZW5XbTgyWFNwTjVIL1JFWkl4UkZsbCt6eU1LNG1Q?=
 =?utf-8?B?YVF5aEFtV0ZneGVBV3pTYy9yNTU4MG9neTRqb08wTlBKY0JDS1RBemswWVBL?=
 =?utf-8?B?VXcyNmtUbTduM0l6UTZLUEpKWmRZV3BUc1NCTGdzUkN6d0c3TjhROFE1dXJk?=
 =?utf-8?B?dTB6blRWM01Bam5GMklNRTlkVDRtRE5GTkd4MWpXemd2YkRxRUdxQWtMbmtj?=
 =?utf-8?B?TFJuRmFoVzc5bkZzWm9BYllUWEQ1YUlqVElXd0hIQUQ5aHQvR0xxai9FZjcy?=
 =?utf-8?Q?H8fWqVw+ZtkIcJ7nytWm6Cdfj70rjF7Qum7SI=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR18MB5368.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZWZkN2RoUVlxWGhOTDI5dlRPUFpTZDFxYlhZUWJlWlA1NXU3TmVTUlhuaWVu?=
 =?utf-8?B?K0tPR01SV0ZFRXh5RWpWMEt1dDA4UmZjWjgwcXhBR3dDamhPZzFKL0ViNENI?=
 =?utf-8?B?K2g2QjEwRTJNNkdhZjdoaUg0UkZBMG9DS2lzWEtLWjhMMy9BUS9UQUhGWFl1?=
 =?utf-8?B?U3Y3ZmtOR2xRaWJyVUJzeHBwT3ZuTEFBMERlSW90QVdoanZ3ZHlRWXhRRmJE?=
 =?utf-8?B?bFliSi9DL1JuSE5JMVk5UkJhZU1DRjZQS240SFpDR3M1czM3aWVrVnV0WDRY?=
 =?utf-8?B?SjBiZlBPczlsYzd5a1NkQWNqdHpuYy9rV1pqbGhYWW5WdXdMV0IzZXpCZkRk?=
 =?utf-8?B?bExUMk1wNmZmbjZ4NlBrWEdWcWZ0RW5rMzg0VUZVTjBTZTZoKzFYRlZuNFZk?=
 =?utf-8?B?UmV6K09UVjRkQ1h4M2JzZTZjN0xyVVk0OExXU0I4VlFRUk9LZUtUb2k5eHhV?=
 =?utf-8?B?Z01CVHpKaGE4ZEZnZHJ6KzhnRjh4ZC9NbnlqUGJhV3JYUkJQSG44T1JsakxB?=
 =?utf-8?B?SXZna3Z1N1JpTmlsM2xUY2E1R1FpdmxrK25QNHk3ZGVwZmYxMEJCUnZ4SW9M?=
 =?utf-8?B?Q1ljYzFCdlMwb0RHV3VFVHNEaHRsS0JGanRreFZ2TXdmdTNTVXk1QzBpOVd2?=
 =?utf-8?B?S3dtQVdqRVNmenhEaTYvSElhVEZYd2ZLcHVKVUEwTzdxL3BPalY3RUVhVEdX?=
 =?utf-8?B?Q0dmZDY4YmJFdUkwalJVcFFXOXdrVldmSUVsRm9WZkNJbHRXMmdodEdhVGpQ?=
 =?utf-8?B?azlQUXhKbUZxN0lSZEJ2enNIYkh2cFFmbHNjVCtyZnZrMjJhTEtTWjVyYWhr?=
 =?utf-8?B?WUdnS1ZWUVBPMTRsNk0rUTZhQjhLZS9wWkt4bzFtV29ZV1MyZFluVzF4Z1o0?=
 =?utf-8?B?aDRFN3JockttNEFOSFphaUlJbU1mcXhUbFNCejRCOUFwZEc1TVpkL1kzY2xS?=
 =?utf-8?B?OTlBMkZoMERLZFM0Ynk4a2d5cm5RS0hCeE9heXovUTRsMVRNUVFWNjM5cHdR?=
 =?utf-8?B?YWYwUXgvYThCaTdaNmluTVphaWphZSsySmFLZFZkbzk0cFMvYzlKS2xlU1dq?=
 =?utf-8?B?Vittb3F2UU1ZRkhIUGYzMzYwbEZ6dUNDMkdmRDdCZkQ3OWdjeFBXL0ZJM2VW?=
 =?utf-8?B?clZIWTNoUjIzTnc5bjZKM2V3MVZkMFcrSzlVcm81RG1BaXZqdVB2QkpucE51?=
 =?utf-8?B?RmxzQzhYK0J5UytyVlYydkx0OWQvaG15d3ZPeXRwbS9HTG1xZHdJSU9oK3p2?=
 =?utf-8?B?QURIckVsY1l3RU43UTBia1RYMVRLSytyQkxnb0JBUFIraFprVkZWcGhJTEk2?=
 =?utf-8?B?Y2g3STF0ME9rMDJQMG03R05KU25uazNsZDQ0TGNCdE45TkNEZzhYMkNYR1JZ?=
 =?utf-8?B?SVFDVSt3TVdUV3oyckVoQ1l0eU1reFNDODBadlBxbXBhSHlsZDU1TU41bWFS?=
 =?utf-8?B?NXdKMkt2cWFscmVEc25UTGlvZStneTg4dmJ4SWpLOTFOeXpmVUphWWdYYzMz?=
 =?utf-8?B?OUp2elZUcml0RlJ2RkdycU8xK3JYZnNYdEZTN3hDQ0pGWUNBTml2anA5TXFV?=
 =?utf-8?B?VldrSVFyUHE1Ui85QUp1Y3h3TEc3eFRaWXhwLzJGSTRWeWs3eElBZEdVYk5n?=
 =?utf-8?B?eWhHeTZ5WFNMUFZIV3VZOUdlN0JhNStHWFROdS9lT1dZNXdwS2FWellYNm1v?=
 =?utf-8?B?WnhBRFdMUm16UGtSK3p3TVpVQWx5d1dRUEdWcVczeTRvWVpvMEpoYzNPTzZt?=
 =?utf-8?B?YmhhN0drb3dDcjRVRDF1OWw3NlBPYU1ZUXhnZDVjVzM5UzJKVzVSdGtMOStS?=
 =?utf-8?B?eWhsSGY2T0RsNEhjM0VuUk9wY1VWZHpIUmt3UDRMRkk5dFpTOUtFMmdDTHdm?=
 =?utf-8?B?S1hYUjhWNVZHYnpEZWZtRDZQMzVRa0MzTHZYTTBKeEFUZnAxZVRMb2IxN20x?=
 =?utf-8?B?b3B4bnlTN2tYYXhmK3M4c0RTTDRGei9md2JJaG1nc0ZqbDJrZ3RodEdDMkdt?=
 =?utf-8?B?MlI0YXc5RU5iK0k2eWpMOW92NE9IZjZVQlBOSzE2MFRGZlF5YnRMeDkrZmFQ?=
 =?utf-8?B?SEFGUHA4dkpJaGxSVE1xOFJpdW9wNCtodVBSa05ZTVVDeWpNR1NDOTBxbTQv?=
 =?utf-8?Q?Un4EWgkaH0TYkl7s9tYduCXkj?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR18MB5368.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 306c31a3-a935-43ef-3668-08dcee891fb8
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2024 08:53:08.9520
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FJTSyXUOxYc/igvNGAvjC/l4iYp5AUIlfHaBebHkBOHZk1FfQ7h9EHoJH7Cizua2ETgV3J4BqS5U9IdOnL6j4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR18MB5684
X-Proofpoint-ORIG-GUID: nvE64lswXJyLfh0utI-_sO8b4ACoWJXn
X-Proofpoint-GUID: nvE64lswXJyLfh0utI-_sO8b4ACoWJXn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.687,Hydra:6.0.235,FMLib:17.0.607.475
 definitions=2020-10-13_15,2020-10-13_02,2020-04-07_01

PiBTdWJqZWN0OiBSZTogW0VYVEVSTkFMXSBSZTogW1BBVENIIHYyIDAvMl0gdmhvc3QtdmRwYTog
QWRkIHN1cHBvcnQgZm9yIE5PLQ0KPiBJT01NVSBtb2RlDQo+IA0KPiBPbiBXZWQsIE9jdCAxNiwg
MjAyNCBhdCAwNToyODoyN1BNICswMDAwLCBTcnVqYW5hIENoYWxsYSB3cm90ZToNCj4gPiBXaGVu
IHVzaW5nIHRoZSBEUERLIHZpcnRpbyB1c2VyIFBNRCwgd2XigJl2ZSBub3RpY2VkIGEgc2lnbmlm
aWNhbnQgNzAlDQo+ID4gcGVyZm9ybWFuY2UgaW1wcm92ZW1lbnQgd2hlbiBJT01NVSBpcyBkaXNh
YmxlZCBvbiBzcGVjaWZpYyBsb3ctZW5kDQo+ID4geDg2IG1hY2hpbmVzLiBUaGlzIHBlcmZvcm1h
bmNlIGltcHJvdmVtZW50IGNhbiBiZSBwYXJ0aWN1bGFybHkNCj4gPiBhZHZhbnRhZ2VvdXMgZm9y
IGVtYmVkZGVkIHBsYXRmb3JtcyB3aGVyZSBhcHBsaWNhdGlvbnMgb3BlcmF0ZSBpbg0KPiA+IGNv
bnRyb2xsZWQgZW52aXJvbm1lbnRzLiBUaGVyZWZvcmUsIHdlIGJlbGlldmUgc3VwcG9ydGluZyB0
aGUNCj4gPiBpbnRlbF9pb21tdT1vZmYgbW9kZSBpcyBiZW5lZmljaWFsLg0KPiANCj4gV2hpbGUg
bWFraW5nIHRoZSBzeXN0ZW0gY29tcGxldGVseSB1bnNhZmUgdG8gdXNlLiAgTWF5YmUgeW91IHNo
b3VsZCBmaXgNCj4geW91ciBzdGFjayB0byB1c2UgdGhlIGlvbW11IG1vcmUgaXRlbGxpZ2VudGx5
IGluc3RlYWQ/DQoNCldlIG9ic2VydmVkIGJldHRlciBwZXJmb3JtYW5jZSB3aXRoICJpbnRlbF9p
b21tdT1vbiIgaW4gaGlnaC1lbmQgeDg2IG1hY2hpbmVzLA0KaW5kaWNhdGluZyB0aGF0IHRoZSBw
ZXJmb3JtYW5jZSBsaW1pdGF0aW9ucyBhcmUgc3BlY2lmaWMgdG8gbG93LWVuZCB4ODYgaGFyZHdh
cmUuDQpUaGlzIHByZXNlbnRzIGEgdHJhZGUtb2ZmIGJldHdlZW4gcGVyZm9ybWFuY2UgYW5kIHNl
Y3VyaXR5LiBTaW5jZSBpbnRlbF9pb21tdQ0KaXMgZW5hYmxlZCBieSBkZWZhdWx0LCB1c2VycyB3
aG8gcHJpb3JpdGl6ZSBzZWN1cml0eSBvdmVyIHBlcmZvcm1hbmNlIGRvIG5vdCBuZWVkIHRvDQpk
aXNhYmxlIHRoaXMgb3B0aW9uLg0K

