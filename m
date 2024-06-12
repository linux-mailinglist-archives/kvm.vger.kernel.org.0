Return-Path: <kvm+bounces-19425-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F243904F1F
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 11:23:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D7D491F220AD
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 09:23:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61DAD16D9D7;
	Wed, 12 Jun 2024 09:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b="LHXvOlFG"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8DD816D9CA
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 09:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.148.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718184176; cv=fail; b=mNPOyNPmhJgrVTjQ/7jmdrwwryPugAyJljUYRY+bb8fSyBQPMx6IQI3v+CTJazyjMvy07drKh19qDPMaA6ogWUzJYhcQeBWMPk+F1cowtO+nap9NS0fG4WHJWd5QrEvE7NKJzowa/adKWv2i/mV11VUBKgYAygRKNnfbFwF+SXU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718184176; c=relaxed/simple;
	bh=qo6RlgT5X8XetEWZfhU87798wQqena7l6Kqj9c9UQXg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ASrDRddOuBt5WcE7yUIRyT2BsMdRWE/fwgsTMUFMsWezL+M/4nngDKzldp5zo1AY3DrqUEUdLJ0MBtR0XWuT31aXwxj9oSNy4EvTsVMUWMEVaBUzBoY07R1VvOv9tk2G9UHXQijX7OijOyPxkTd4+6WSUnHTwKho5rVATchQqJg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b=LHXvOlFG; arc=fail smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45C95U0H027498;
	Wed, 12 Jun 2024 02:22:49 -0700
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3yq8qx021s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 12 Jun 2024 02:22:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UKEf5K26FL/wzkdhZp7SaGvewN9H5UyV1uutDDnFMIEsQuL+f1E2UdmZUXuEyixe8HAOa+oqvl8lFsZQL4m3e3Zm32Au90BrX92SA7g4IdA1PV6SvZ88YIpABUxRxboBAk1GRwOI+eW/byBsAsM7XpXBLMF6/3dXCmQxTZq06CSJ9Ernuybt4RKHaNIYU7H6QdDiBaD9xbwmXosqJTFCZY44xUM8Zc6po5edvZXCBZnJA73GwUodBjzPzvLoFPy3PGkYQ6eyWTEVk9BPGrS7++XJXhx0oycvPuiZHlZwhLZnYd872bvK0BJg4PVJEYNfPwB0gM0d+llALZ3R5EscFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qo6RlgT5X8XetEWZfhU87798wQqena7l6Kqj9c9UQXg=;
 b=CIL3x6+rb/JJE4bqodKM+PjTZ/6inPAHGNTEDA/dmHogKKhGHPOTkZ1HH3L1rjsSwQf8FM+zOp9Zjv0nOaU2WHAmWVbhW55sdzBnz5S8vBG2AqCNx3x/rwSqgSEf0Xj3MV85cozSlnJdc6UBH3Vzy1MdcQFZO/FCmOuxSDsoXdjR/DxUYIbl5S5OOoHmdXngtAMHKkFlgRimqTgVhzN6dZ1w05/kf5lQiBeACTONET3ZXk/8jcnbwP0uiHyU2zUSqJs3aPMXYZaxICUxJo7CWlBbuGhOsnBFK3Qa5hG85T10qMipo3q3d4/Y/x9IgFuk7sqX6hWs9l4MCjhqm3FhDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qo6RlgT5X8XetEWZfhU87798wQqena7l6Kqj9c9UQXg=;
 b=LHXvOlFGkTiIjjraCd6Ery2pwpW5XkUbvYqxxI5LEZTH6D3yQRaYGWbisldDRahVikxoKQFpyYmdCzgvU09qGXPG3iVAe6D0Ve60yXmveDScSHjpFLvlwuKMyBlx4LVnbPiWZY6J49yp4QiZQDo2g5Jq8j+puoqidZSGH4p8tgU=
Received: from DS0PR18MB5368.namprd18.prod.outlook.com (2603:10b6:8:12f::17)
 by DM8PR18MB4518.namprd18.prod.outlook.com (2603:10b6:8:3f::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7677.21; Wed, 12 Jun 2024 09:22:44 +0000
Received: from DS0PR18MB5368.namprd18.prod.outlook.com
 ([fe80::ad53:bef2:cc17:13ac]) by DS0PR18MB5368.namprd18.prod.outlook.com
 ([fe80::ad53:bef2:cc17:13ac%3]) with mapi id 15.20.7633.036; Wed, 12 Jun 2024
 09:22:43 +0000
From: Srujana Challa <schalla@marvell.com>
To: Jason Wang <jasowang@redhat.com>
CC: "virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mst@redhat.com"
	<mst@redhat.com>,
        Vamsi Krishna Attunuru <vattunuru@marvell.com>,
        Shijith
 Thotton <sthotton@marvell.com>,
        Nithin Kumar Dabilpuram
	<ndabilpuram@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>
Subject: RE: [EXTERNAL] Re: [PATCH] vdpa: Add support for no-IOMMU mode
Thread-Topic: [EXTERNAL] Re: [PATCH] vdpa: Add support for no-IOMMU mode
Thread-Index: AQHasnq4Ve/zJa91a0mQb+nM4LHR9bGwnvCAgAa0y7CAApScgIAKA5Iw
Date: Wed, 12 Jun 2024 09:22:43 +0000
Message-ID: 
 <DS0PR18MB5368CD9E8E3432A9D19D8C8FA0C02@DS0PR18MB5368.namprd18.prod.outlook.com>
References: <20240530101823.1210161-1-schalla@marvell.com>
 <CACGkMEsxPfck-Ww6CHSod5wP5xLOpS3t2B8qhTL0=PoE3koCGQ@mail.gmail.com>
 <DS0PR18MB5368E02C4DE7AA96CCD299E0A0F82@DS0PR18MB5368.namprd18.prod.outlook.com>
 <CACGkMEs+s7JEvLXBdyQbj36Y8WSbHXqF2d9HNP3v7CPRPoocXg@mail.gmail.com>
In-Reply-To: 
 <CACGkMEs+s7JEvLXBdyQbj36Y8WSbHXqF2d9HNP3v7CPRPoocXg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR18MB5368:EE_|DM8PR18MB4518:EE_
x-ms-office365-filtering-correlation-id: 734ac1fd-cc0f-46d7-8cce-08dc8ac13712
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230032|366008|376006|1800799016|38070700010;
x-microsoft-antispam-message-info: 
 =?utf-8?B?aHB1THdlWGtSWjluMEMwK0VtOXliK3FFUHB0aGF5TUoyWjk4UnJ5R1NFY2lw?=
 =?utf-8?B?SXhHd2dORXpiNVJuREpEdXJxZnhQek1VSk1ZWXYxVG9VTDBFWU5ZS1hwMVFE?=
 =?utf-8?B?WG5TMWVYRkIxRCtUL3lIZ0JzTUdNcjZqWk1yc1p1RitZTHp2N21DTGdSUjRx?=
 =?utf-8?B?MnlPQVpJbXRJR2I1NVNiZkJoMitQaWlSM2svMXg2ZEpHQVVkMzh1RFVsMFZU?=
 =?utf-8?B?aHhyaVpzTTBzNzJYYWZqdS93TURXMkNYN0Z5WUc4ZlV5Rk5iRy94ajBtY3M2?=
 =?utf-8?B?dlpSS0lIVzZ1MEFRN1pvRXowTmFheEx5MlBwNjdYZmk4V1M2SU9vQ3lTYVJG?=
 =?utf-8?B?TEYzb0lQUWZocTlJSTFUdjFRR21xOStmT0J0YWRhQTdSMTZOQXZjcy90YkJr?=
 =?utf-8?B?N2RXK0Q2bi9tOW5zUjRRTFV5amUzODFRZFpOY0pLaUYwaHRoTExmZDFpR3NP?=
 =?utf-8?B?OXAvQTkwcEF3dTdnSU5ha3NCd0dUK0wyTjNqZ0VRelJYdzd5M2M0Z1NJUGZ4?=
 =?utf-8?B?MHl0Y2c2dUo3Qm9PekljOXBCMjBZSGZRaG5TdW5uRzNhR0RxU2xjM3J4WDcw?=
 =?utf-8?B?U09tQkY1ZGwyWS80RFN4QU9KMXBPZVBKcjNUTnVCVWJDVFV2OWdaeXNCeXVD?=
 =?utf-8?B?bmlOTXJrRkd2N3llV3hUNytaTk5FaW5LTExsZzlwc2E5QkhNbUoyVzB4RDNH?=
 =?utf-8?B?NFZOWU0vODF0cElKYmQzUEdzcFdxZStzUGxvSUs5M1pUSytadDBwUHRpd1g2?=
 =?utf-8?B?UnBlNVloM2J3ay91bmRQc1dQWExabW5KU1ZvT0R0NU50bFM1MVFNa042N2tK?=
 =?utf-8?B?TUpSaE1tUHdHTzZaVHhvdXdDbjhFYW9JcmlKMjFPM01JM1Z3dGdUTkpJWml6?=
 =?utf-8?B?Nm1RQS9lSmxGd2NUVkRSWXBQQkE4RC8rWlJMcUFjUmh0eGp0LzRXMXVkRGsv?=
 =?utf-8?B?dVhRUkdIT2pyRTc4emFZSFE3U2FlZDBVRVN5MHRGVzRhY1plMFl4aHF4bGZB?=
 =?utf-8?B?S00xb1d1V25KOHBGa2VRZm92VFpKcm1nOWxGR3hwZWxyS1hlaGpqUXVsT2xZ?=
 =?utf-8?B?eTBEMU8vSXIwcEdPdGZBSVZ3QW9kTW96U2t2N1N3RXB6RmVaM0VHRkRGVDFI?=
 =?utf-8?B?ZWlzRU4xcko0c0dJalZ5SmVOejdKV0c3VmZ3U1dFZFQ5dnEyQnZwTTlMZDNz?=
 =?utf-8?B?YkEvQkY3L3pOcDYwak1wcnA5TUt4YmRJam9OK2lwQ0VudnEyUHlTSzYzdS9h?=
 =?utf-8?B?UEVsWmdPZTdSNmdGWXVyT3FBbWZGa0J3QmRldzFtQzVjYmJRV3ZHM2c4OVVX?=
 =?utf-8?B?Rm9MdEJVNTFSbDh1M1l3SXdpUnh2ZldOOXZXK1pJbHJ0ak9KQnFtRXpNVEpK?=
 =?utf-8?B?cmtYSVhJV21vbC94MW12cnNvaTlITDRnL3B1a1lKdmI4U21mMWZuQUtqQ1Uv?=
 =?utf-8?B?QUZlZVVUbzlaSURPRFpIZjQ4UmZvRHVIYTB1UjJ0cVNDcUxBUUF0RXZidGMw?=
 =?utf-8?B?UWVmTnJBdFpscHJCRWxLTGNvS0oyT0xqYmdLZkZDSTY3NVJxWUpTODFieFlr?=
 =?utf-8?B?WkR1Q1NCWHJrNThWOW5UU0IreWdITEZubjBXbXY4MkJrQzB1U0lwMWFSZDly?=
 =?utf-8?B?TlJnb0xXYi9lUmJEMWFCcmFoZXdlY20rUlcyYmxEM0lCS2dCTW5VYzBqUlNE?=
 =?utf-8?B?OUMwQnFhemZISWtPV29CWlVJOVh6UU1XNVhNUXNPL0NsUkY1aUUzODJPQStU?=
 =?utf-8?B?a0psekRwRjlBUGl5TUVpMVp1eXNLcW8zbll6Z0hnWFdDTFh4K2crUVh5QkhV?=
 =?utf-8?Q?VQuLqTalIvRtODEiqtFvAI4sGX6emREDG+VMk=3D?=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR18MB5368.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230032)(366008)(376006)(1800799016)(38070700010);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?MlpmL0NtQXBDMjhTb1hQMjV0ZmN0RGU1bHlwVzRqb2F1eTEyWUdKSGxIQk1q?=
 =?utf-8?B?N29VN2hjSDlPb21lK0FiSnBIZzdodk5uRmNiUG5SNUs2eFZYY0hHNU9OSkNm?=
 =?utf-8?B?RXArQTVsNldVUDhOVnkyRTQ2MFpzb01JbDU2TEpsQS9WZmlwc243dWlxNENG?=
 =?utf-8?B?QmY1T1loU24xV2Nhc2IyeHFzbGpEN0NMb25JK3RVT3N6OUN6VnhUWlRsSHIy?=
 =?utf-8?B?ZWxkTjV2WVJpMm5RNnd0RzdzUEdoOU1qZzJEd1liYlVmaWJoMDVtNnNPR0w5?=
 =?utf-8?B?SHgvelZ0dHloaHZPWEJ6MHExcEczWkJRdzZmNUR5NEhUV1lMYTJSamNodHR6?=
 =?utf-8?B?RDdMK0xqSVZjNnNnUkQvUHl0Z3U4c2pMTG1vaGFWSWtDb29DaGd5dmlENzZJ?=
 =?utf-8?B?UWRFL1VSSFRTWU5vUkhoRVd0L0EvZVNVQ08zbGVYQzlFYjBPNFRQb0RYY055?=
 =?utf-8?B?eEsyTkNrcGdLV1BtOGo1Yjkrc0kxRUQ5VTNRSXp0TTY2R1lIRXJUdExtNEY3?=
 =?utf-8?B?VHBzd0tCalhqNjJyM3VwWWVlVDQ1Mzlod3BteUlCSHBVVHRxa1NkRDVaZHR2?=
 =?utf-8?B?YVlYSkVkUloxdnJWdzQwR0hHOVNZNHR0TkpiRkVIeTVQbE82OHJFOFpWd25L?=
 =?utf-8?B?MGEydW5nMUE0bFZLZ3ZmbFZRR0RHY29UaFVTSEZNbG92KzR0Y1QrNXhEdk5C?=
 =?utf-8?B?SExmdGFKdjlOQ2ZnRzQyZThmdzFXK3NuQ2Y3QVhDdnFtZUZNWkpJYlpyeUo1?=
 =?utf-8?B?MkdRcTZHTnBlMjB0dzFYdXd5aldaSFNQZktPaytXVEtiR2hKeVJ3b2YxVmlX?=
 =?utf-8?B?U01kTG5TVkFENUNtcHBQYXcxVzU5a0EvQ0t1cnN2ZDYrOUZYdSt0eFVJRDRh?=
 =?utf-8?B?OFBtaHFTdGU2NDYvaW4zMkt0RTREMUpETHlLbmwvbFlWb09CdjFCaUZ3TVBp?=
 =?utf-8?B?dXpXc3NwTzlMUGRLenpqaU9EdEdpQ25CYjNqQXBOSjdoZjRrYzVab0VWQXo3?=
 =?utf-8?B?TkczamNCbDZ5aGJvc0ZvT3V6QlZZdUFCL3VJZjd6TEx2ejV6N05LOTZuY1pq?=
 =?utf-8?B?dFdMNXJaMGRwcXVKWXREYW5XK2dzWXpTcXp2ZGwzbmpXY1lWekd3OVRZRDhB?=
 =?utf-8?B?WEkveUJMdVdRUi9SQ2NWM1MyQi9WV21DMHEwUTB6SGh1S0xYMXBYNUJUbFBk?=
 =?utf-8?B?eVRMbWtZNXo4Mk1Fa1d0U3pMajVtaGEwQkM0bUFxdzdzeXIyeVlKSzl4Umcx?=
 =?utf-8?B?bXBrSVl3bU91QU9INmtoQ0Jza2ptRWdIdE91VjRkM2lQRXlXQXMwLzBzZnZI?=
 =?utf-8?B?US9PSTZRRk4rYjhwS21DUG9YODJKMkNrNUxmMVFVbWUrd01ySzF2M2NJeXAy?=
 =?utf-8?B?VmQ1dHArQUVKQjJ0cEpVdk1EMlU1aSt2YnViLzVTMmR0UHNWTE5meTZxNTFE?=
 =?utf-8?B?aDlucml5T2pFeW05eGV0NCs4UnlrSHY3dXAvWTdyQnl0Zk4zUnp2TUM5U25D?=
 =?utf-8?B?bWxNOE9vTW9zYnI0UFBRcThPMDgzR0dzOUM5L2xveWFSaU5admxoNHBPOHlw?=
 =?utf-8?B?dHZMZ1lkL2pSSHRERHVOTUp1bjIzNkJha1BRYld3dDA1WW5QWS9XZ3g1Wmlq?=
 =?utf-8?B?MU5kQk5YUDJOR0lKM0liZUo5YnQ2OEM3OXJoTlR3cEtWOVpuVmZjcnZQU3h6?=
 =?utf-8?B?alp4TXFMKzBsS0J6Uy91ajRsajF5YUJJZ1M2S1BYWTVYN05QRUpOSHRILzdO?=
 =?utf-8?B?YmlpMHRpRDJXUVh1YWRSZGxaS09udktsYmluSEFzUGtUeC9hNlRvWnhuNXpV?=
 =?utf-8?B?M2lIRElMYmpHb2JQSGY4ZEE5V1ZpMW95N3dNb0VqOTBHdTBXWDNjRkFNU2lD?=
 =?utf-8?B?Q0gyKzJRMHI2eUtWdmtyM3h6Z0w2NFdKbi9DU1JCRlNxOWxsRFZJbG5wL2Uw?=
 =?utf-8?B?bHVqUXRweGtvZG5GbTV3clB0MlZzaFF2Z0NDSW1lTDBMWHBqL2drbFhKMjZa?=
 =?utf-8?B?VHVxcCtIaWVQV2JUWW9PMnIra3FZTWRUUERJZGVBZi9Hb2JtNVdDaVd1TW5T?=
 =?utf-8?B?L1N5YmRycFNTSDFWeU8yemJHbFFjdWZQNHhpY0J5cWJXNERjV3ViMlltVWd6?=
 =?utf-8?Q?W9/Q=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 734ac1fd-cc0f-46d7-8cce-08dc8ac13712
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2024 09:22:43.6792
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9Mye/37kw3p8ljuRGbpLVygGbU/3+vloZbaolJJ4lAwiH6X7Z3VOz1zJjAazX4GNJ11Fl9PXHEvZiKMamm8oFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR18MB4518
X-Proofpoint-GUID: x1kbCqDMDHFeEHeum9WwNcZjeeePifyp
X-Proofpoint-ORIG-GUID: x1kbCqDMDHFeEHeum9WwNcZjeeePifyp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-12_05,2024-06-11_01,2024-05-17_01

DQo+IFN1YmplY3Q6IFJlOiBbRVhURVJOQUxdIFJlOiBbUEFUQ0hdIHZkcGE6IEFkZCBzdXBwb3J0
IGZvciBuby1JT01NVSBtb2RlDQo+IA0KPiBPbiBUdWUsIEp1biA0LCAyMDI0IGF0IDU6MjnigK9Q
TSBTcnVqYW5hIENoYWxsYSA8c2NoYWxsYUBtYXJ2ZWxsLmNvbT4gd3JvdGU6DQo+ID4NCj4gPiA+
IFN1YmplY3Q6IFtFWFRFUk5BTF0gUmU6IFtQQVRDSF0gdmRwYTogQWRkIHN1cHBvcnQgZm9yIG5v
LUlPTU1VIG1vZGUNCj4gPiA+DQo+ID4gPiBQcmlvcml0aXplIHNlY3VyaXR5IGZvciBleHRlcm5h
bCBlbWFpbHM6IENvbmZpcm0gc2VuZGVyIGFuZCBjb250ZW50DQo+ID4gPiBzYWZldHkgYmVmb3Jl
IGNsaWNraW5nIGxpbmtzIG9yIG9wZW5pbmcgYXR0YWNobWVudHMNCj4gPiA+DQo+ID4gPiAtLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLQ0KPiA+ID4gLS0gT24gVGh1LCBNYXkgMzAsIDIwMjQgYXQgNjoxOOKAr1BNIFNydWph
bmEgQ2hhbGxhDQo+ID4gPiA8c2NoYWxsYUBtYXJ2ZWxsLmNvbT4NCj4gPiA+IHdyb3RlOg0KPiA+
ID4gPg0KPiA+ID4gPiBUaGlzIGNvbW1pdCBpbnRyb2R1Y2VzIHN1cHBvcnQgZm9yIGFuIFVOU0FG
RSwgbm8tSU9NTVUgbW9kZSBpbiB0aGUNCj4gPiA+ID4gdmhvc3QtdmRwYSBkcml2ZXIuIFdoZW4g
ZW5hYmxlZCwgdGhpcyBtb2RlIHByb3ZpZGVzIG5vIGRldmljZQ0KPiA+ID4gPiBpc29sYXRpb24s
IG5vIERNQSB0cmFuc2xhdGlvbiwgbm8gaG9zdCBrZXJuZWwgcHJvdGVjdGlvbiwgYW5kDQo+ID4g
PiA+IGNhbm5vdCBiZSB1c2VkIGZvciBkZXZpY2UgYXNzaWdubWVudCB0byB2aXJ0dWFsIG1hY2hp
bmVzLiBJdA0KPiA+ID4gPiByZXF1aXJlcyBSQVdJTyBwZXJtaXNzaW9ucyBhbmQgd2lsbCB0YWlu
dCB0aGUga2VybmVsLg0KPiA+ID4gPiBUaGlzIG1vZGUgcmVxdWlyZXMgZW5hYmxpbmcgdGhlDQo+
ID4gPiAiZW5hYmxlX3Zob3N0X3ZkcGFfdW5zYWZlX25vaW9tbXVfbW9kZSINCj4gPiA+ID4gb3B0
aW9uIG9uIHRoZSB2aG9zdC12ZHBhIGRyaXZlci4gVGhpcyBtb2RlIHdvdWxkIGJlIHVzZWZ1bCB0
byBnZXQNCj4gPiA+ID4gYmV0dGVyIHBlcmZvcm1hbmNlIG9uIHNwZWNpZmljZSBsb3cgZW5kIG1h
Y2hpbmVzIGFuZCBjYW4gYmUNCj4gPiA+ID4gbGV2ZXJhZ2VkIGJ5IGVtYmVkZGVkIHBsYXRmb3Jt
cyB3aGVyZSBhcHBsaWNhdGlvbnMgcnVuIGluIGNvbnRyb2xsZWQNCj4gZW52aXJvbm1lbnQuDQo+
ID4gPg0KPiA+ID4gSSB3b25kZXIgaWYgaXQncyBiZXR0ZXIgdG8gZG8gaXQgcGVyIGRyaXZlcjoN
Cj4gPiA+DQo+ID4gPiAxKSB3ZSBoYXZlIGRldmljZSB0aGF0IHVzZSBpdHMgb3duIElPTU1VLCBv
bmUgZXhhbXBsZSBpcyB0aGUgbWx4NQ0KPiA+ID4gdkRQQSBkZXZpY2UNCj4gPiA+IDIpIHdlIGhh
dmUgc29mdHdhcmUgZGV2aWNlcyB3aGljaCBkb2Vzbid0IHJlcXVpcmUgSU9NTVUgYXQgYWxsIChi
dXQNCj4gPiA+IHN0aWxsIHdpdGgNCj4gPiA+IHByb3RlY3Rpb24pDQo+ID4NCj4gPiBJZiBJIHVu
ZGVyc3RhbmQgY29ycmVjdGx5LCB5b3XigJlyZSBzdWdnZXN0aW5nIHRoYXQgd2UgY3JlYXRlIGEg
bW9kdWxlDQo+ID4gcGFyYW1ldGVyIHNwZWNpZmljIHRvIHRoZSB2ZHBhIGRyaXZlci4gVGhlbiwg
d2UgY2FuIGFkZCBhIGZsYWcgdG8gdGhlIOKAmHN0cnVjdA0KPiB2ZHBhX2RldmljZeKAmQ0KPiA+
IGFuZCBzZXQgdGhhdCBmbGFnIHdpdGhpbiB0aGUgdmRwYSBkcml2ZXIgYmFzZWQgb24gdGhlIG1v
ZHVsZSBwYXJhbWV0ZXIuDQo+ID4gRmluYWxseSwgd2Ugd291bGQgdXNlIHRoaXMgZmxhZyB0byB0
YWludCB0aGUga2VybmVsIGFuZCBnbyBpbiBuby1pb21tdQ0KPiA+IHBhdGggaW4gdGhlIHZob3N0
LXZkcGEgZHJpdmVyPw0KPiANCj4gSWYgaXQncyBwb3NzaWJsZSwgSSB3b3VsZCBsaWtlIHRvIGF2
b2lkIGNoYW5naW5nIHRoZSB2RFBBIGNvcmUuDQo+IA0KPiBUaGFua3MNCkFjY29yZGluZyB0byBt
eSB1bmRlcnN0YW5kaW5nIG9mIHRoZSBkaXNjdXNzaW9uIGF0IHRoZQ0KaHR0cHM6Ly9sb3JlLmtl
cm5lbC5vcmcvYWxsLzIwMjQwNDIyMTY0MTA4LW11dHQtc2VuZC1lbWFpbC1tc3RAa2VybmVsLm9y
ZywNCk1pY2hhZWwgaGFzIHN1Z2dlc3RlZCBmb2N1c2luZyBvbiBpbXBsZW1lbnRpbmcgYSBuby1J
T01NVSBtb2RlIGluIHZkcGEuDQpNaWNoYWVsLCBjb3VsZCB5b3UgcGxlYXNlIGNvbmZpcm0gaWYg
aXQncyBmaW5lIHRvIHRyYW5zZmVyIGFsbCB0aGVzZSByZWxldmFudA0KbW9kaWZpY2F0aW9ucyB0
byBNYXJ2ZWxsJ3MgdmRwYSBkcml2ZXI/DQoNClRoYW5rcy4NCj4gDQo+ID4gPg0KPiA+ID4gVGhh
bmtzDQo+ID4gPg0KPiA+ID4gPg0KPiA+ID4gPiBTaWduZWQtb2ZmLWJ5OiBTcnVqYW5hIENoYWxs
YSA8c2NoYWxsYUBtYXJ2ZWxsLmNvbT4NCj4gPiA+ID4gLS0tDQo+ID4gPiA+ICBkcml2ZXJzL3Zo
b3N0L3ZkcGEuYyB8IDIzICsrKysrKysrKysrKysrKysrKysrKysrDQo+ID4gPiA+ICAxIGZpbGUg
Y2hhbmdlZCwgMjMgaW5zZXJ0aW9ucygrKQ0KPiA+ID4gPg0KPiA+ID4gPiBkaWZmIC0tZ2l0IGEv
ZHJpdmVycy92aG9zdC92ZHBhLmMgYi9kcml2ZXJzL3Zob3N0L3ZkcGEuYyBpbmRleA0KPiA+ID4g
PiBiYzRhNTFlNDYzOGIuLmQwNzFjMzAxMjVhYSAxMDA2NDQNCj4gPiA+ID4gLS0tIGEvZHJpdmVy
cy92aG9zdC92ZHBhLmMNCj4gPiA+ID4gKysrIGIvZHJpdmVycy92aG9zdC92ZHBhLmMNCj4gPiA+
ID4gQEAgLTM2LDYgKzM2LDExIEBAIGVudW0gew0KPiA+ID4gPg0KPiA+ID4gPiAgI2RlZmluZSBW
SE9TVF9WRFBBX0lPVExCX0JVQ0tFVFMgMTYNCj4gPiA+ID4NCj4gPiA+ID4gK2Jvb2wgdmhvc3Rf
dmRwYV9ub2lvbW11Ow0KPiA+ID4gPiArbW9kdWxlX3BhcmFtX25hbWVkKGVuYWJsZV92aG9zdF92
ZHBhX3Vuc2FmZV9ub2lvbW11X21vZGUsDQo+ID4gPiA+ICsgICAgICAgICAgICAgICAgICB2aG9z
dF92ZHBhX25vaW9tbXUsIGJvb2wsIDA2NDQpOw0KPiA+ID4gPiArTU9EVUxFX1BBUk1fREVTQyhl
bmFibGVfdmhvc3RfdmRwYV91bnNhZmVfbm9pb21tdV9tb2RlLA0KPiA+ID4gIkVuYWJsZQ0KPiA+
ID4gPiArVU5TQUZFLCBuby1JT01NVSBtb2RlLiAgVGhpcyBtb2RlIHByb3ZpZGVzIG5vIGRldmlj
ZSBpc29sYXRpb24sDQo+ID4gPiA+ICtubyBETUEgdHJhbnNsYXRpb24sIG5vIGhvc3Qga2VybmVs
IHByb3RlY3Rpb24sIGNhbm5vdCBiZSB1c2VkIGZvcg0KPiA+ID4gPiArZGV2aWNlIGFzc2lnbm1l
bnQgdG8gdmlydHVhbCBtYWNoaW5lcywgcmVxdWlyZXMgUkFXSU8NCj4gPiA+ID4gK3Blcm1pc3Np
b25zLCBhbmQgd2lsbCB0YWludCB0aGUga2VybmVsLiAgSWYgeW91IGRvIG5vdCBrbm93IHdoYXQg
dGhpcyBpcw0KPiBmb3IsIHN0ZXAgYXdheS4NCj4gPiA+ID4gKyhkZWZhdWx0OiBmYWxzZSkiKTsN
Cj4gPiA+ID4gKw0KPiA+ID4gPiAgc3RydWN0IHZob3N0X3ZkcGFfYXMgew0KPiA+ID4gPiAgICAg
ICAgIHN0cnVjdCBobGlzdF9ub2RlIGhhc2hfbGluazsNCj4gPiA+ID4gICAgICAgICBzdHJ1Y3Qg
dmhvc3RfaW90bGIgaW90bGI7DQo+ID4gPiA+IEBAIC02MCw2ICs2NSw3IEBAIHN0cnVjdCB2aG9z
dF92ZHBhIHsNCj4gPiA+ID4gICAgICAgICBzdHJ1Y3QgdmRwYV9pb3ZhX3JhbmdlIHJhbmdlOw0K
PiA+ID4gPiAgICAgICAgIHUzMiBiYXRjaF9hc2lkOw0KPiA+ID4gPiAgICAgICAgIGJvb2wgc3Vz
cGVuZGVkOw0KPiA+ID4gPiArICAgICAgIGJvb2wgbm9pb21tdV9lbjsNCj4gPiA+ID4gIH07DQo+
ID4gPiA+DQo+ID4gPiA+ICBzdGF0aWMgREVGSU5FX0lEQSh2aG9zdF92ZHBhX2lkYSk7IEBAIC04
ODcsNiArODkzLDEwIEBAIHN0YXRpYw0KPiA+ID4gPiB2b2lkIHZob3N0X3ZkcGFfZ2VuZXJhbF91
bm1hcChzdHJ1Y3Qgdmhvc3RfdmRwYSAqdiwgIHsNCj4gPiA+ID4gICAgICAgICBzdHJ1Y3QgdmRw
YV9kZXZpY2UgKnZkcGEgPSB2LT52ZHBhOw0KPiA+ID4gPiAgICAgICAgIGNvbnN0IHN0cnVjdCB2
ZHBhX2NvbmZpZ19vcHMgKm9wcyA9IHZkcGEtPmNvbmZpZzsNCj4gPiA+ID4gKw0KPiA+ID4gPiAr
ICAgICAgIGlmICh2LT5ub2lvbW11X2VuKQ0KPiA+ID4gPiArICAgICAgICAgICAgICAgcmV0dXJu
Ow0KPiA+ID4gPiArDQo+ID4gPiA+ICAgICAgICAgaWYgKG9wcy0+ZG1hX21hcCkgew0KPiA+ID4g
PiAgICAgICAgICAgICAgICAgb3BzLT5kbWFfdW5tYXAodmRwYSwgYXNpZCwgbWFwLT5zdGFydCwg
bWFwLT5zaXplKTsNCj4gPiA+ID4gICAgICAgICB9IGVsc2UgaWYgKG9wcy0+c2V0X21hcCA9PSBO
VUxMKSB7IEBAIC05ODAsNiArOTkwLDkgQEANCj4gPiA+ID4gc3RhdGljIGludCB2aG9zdF92ZHBh
X21hcChzdHJ1Y3Qgdmhvc3RfdmRwYSAqdiwgc3RydWN0IHZob3N0X2lvdGxiDQo+ICppb3RsYiwN
Cj4gPiA+ID4gICAgICAgICBpZiAocikNCj4gPiA+ID4gICAgICAgICAgICAgICAgIHJldHVybiBy
Ow0KPiA+ID4gPg0KPiA+ID4gPiArICAgICAgIGlmICh2LT5ub2lvbW11X2VuKQ0KPiA+ID4gPiAr
ICAgICAgICAgICAgICAgZ290byBza2lwX21hcDsNCj4gPiA+ID4gKw0KPiA+ID4gPiAgICAgICAg
IGlmIChvcHMtPmRtYV9tYXApIHsNCj4gPiA+ID4gICAgICAgICAgICAgICAgIHIgPSBvcHMtPmRt
YV9tYXAodmRwYSwgYXNpZCwgaW92YSwgc2l6ZSwgcGEsIHBlcm0sIG9wYXF1ZSk7DQo+ID4gPiA+
ICAgICAgICAgfSBlbHNlIGlmIChvcHMtPnNldF9tYXApIHsgQEAgLTk5NSw2ICsxMDA4LDcgQEAg
c3RhdGljIGludA0KPiA+ID4gPiB2aG9zdF92ZHBhX21hcChzdHJ1Y3Qgdmhvc3RfdmRwYSAqdiwN
Cj4gPiA+IHN0cnVjdCB2aG9zdF9pb3RsYiAqaW90bGIsDQo+ID4gPiA+ICAgICAgICAgICAgICAg
ICByZXR1cm4gcjsNCj4gPiA+ID4gICAgICAgICB9DQo+ID4gPiA+DQo+ID4gPiA+ICtza2lwX21h
cDoNCj4gPiA+ID4gICAgICAgICBpZiAoIXZkcGEtPnVzZV92YSkNCj4gPiA+ID4gICAgICAgICAg
ICAgICAgIGF0b21pYzY0X2FkZChQRk5fRE9XTihzaXplKSwgJmRldi0+bW0tPnBpbm5lZF92bSk7
DQo+ID4gPiA+DQo+ID4gPiA+IEBAIC0xMjk4LDYgKzEzMTIsNyBAQCBzdGF0aWMgaW50IHZob3N0
X3ZkcGFfYWxsb2NfZG9tYWluKHN0cnVjdA0KPiA+ID4gdmhvc3RfdmRwYSAqdikNCj4gPiA+ID4g
ICAgICAgICBzdHJ1Y3QgdmRwYV9kZXZpY2UgKnZkcGEgPSB2LT52ZHBhOw0KPiA+ID4gPiAgICAg
ICAgIGNvbnN0IHN0cnVjdCB2ZHBhX2NvbmZpZ19vcHMgKm9wcyA9IHZkcGEtPmNvbmZpZzsNCj4g
PiA+ID4gICAgICAgICBzdHJ1Y3QgZGV2aWNlICpkbWFfZGV2ID0gdmRwYV9nZXRfZG1hX2Rldih2
ZHBhKTsNCj4gPiA+ID4gKyAgICAgICBzdHJ1Y3QgaW9tbXVfZG9tYWluICpkb21haW47DQo+ID4g
PiA+ICAgICAgICAgY29uc3Qgc3RydWN0IGJ1c190eXBlICpidXM7DQo+ID4gPiA+ICAgICAgICAg
aW50IHJldDsNCj4gPiA+ID4NCj4gPiA+ID4gQEAgLTEzMDUsNiArMTMyMCwxNCBAQCBzdGF0aWMg
aW50IHZob3N0X3ZkcGFfYWxsb2NfZG9tYWluKHN0cnVjdA0KPiA+ID4gdmhvc3RfdmRwYSAqdikN
Cj4gPiA+ID4gICAgICAgICBpZiAob3BzLT5zZXRfbWFwIHx8IG9wcy0+ZG1hX21hcCkNCj4gPiA+
ID4gICAgICAgICAgICAgICAgIHJldHVybiAwOw0KPiA+ID4gPg0KPiA+ID4gPiArICAgICAgIGRv
bWFpbiA9IGlvbW11X2dldF9kb21haW5fZm9yX2RldihkbWFfZGV2KTsNCj4gPiA+ID4gKyAgICAg
ICBpZiAoKCFkb21haW4gfHwgZG9tYWluLT50eXBlID09IElPTU1VX0RPTUFJTl9JREVOVElUWSkg
JiYNCj4gPiA+ID4gKyAgICAgICAgICAgdmhvc3RfdmRwYV9ub2lvbW11ICYmIGNhcGFibGUoQ0FQ
X1NZU19SQVdJTykpIHsNCj4gPiA+ID4gKyAgICAgICAgICAgICAgIGFkZF90YWludChUQUlOVF9V
U0VSLCBMT0NLREVQX1NUSUxMX09LKTsNCj4gPiA+ID4gKyAgICAgICAgICAgICAgIGRldl93YXJu
KCZ2LT5kZXYsICJBZGRpbmcga2VybmVsIHRhaW50IGZvciBub2lvbW11DQo+ID4gPiA+ICsgb24N
Cj4gPiA+IGRldmljZVxuIik7DQo+ID4gPiA+ICsgICAgICAgICAgICAgICB2LT5ub2lvbW11X2Vu
ID0gdHJ1ZTsNCj4gPiA+ID4gKyAgICAgICAgICAgICAgIHJldHVybiAwOw0KPiA+ID4gPiArICAg
ICAgIH0NCj4gPiA+ID4gICAgICAgICBidXMgPSBkbWFfZGV2LT5idXM7DQo+ID4gPiA+ICAgICAg
ICAgaWYgKCFidXMpDQo+ID4gPiA+ICAgICAgICAgICAgICAgICByZXR1cm4gLUVGQVVMVDsNCj4g
PiA+ID4gLS0NCj4gPiA+ID4gMi4yNS4xDQo+ID4gPiA+DQo+ID4NCg0K

