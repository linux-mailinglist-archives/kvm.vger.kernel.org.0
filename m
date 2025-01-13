Return-Path: <kvm+bounces-35326-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 657BAA0C2DC
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 21:59:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2BCAA3A8139
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 20:59:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 327261D0E20;
	Mon, 13 Jan 2025 20:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="m23hJ53I";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="pTaTsgay"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A91A35280
	for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 20:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736801980; cv=fail; b=G8690vfxtWE+xd+q19JG2f9GLjC4CF73xb0+qOfQzbqrK2Z0dJzgE0PvOhiH50b7oP487Pqlvh36m10Q24JNP7ER/9bpPdZGCa4FkYMaFRzE/aRzMzU2OwF41stFYIp1umkoZm6ULRyTXx60e4JnirEeeJnDZrv3vTc9pWWRiao=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736801980; c=relaxed/simple;
	bh=G2Gxw7dOY0+IHi5fZzUbPrihH5OOz9zPyErj1Nq0EcY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XxkBWHK9X4OPMOFjx3HtC2f0K95WM/q5OkDAG0VZkAWLHFS8RIjq2tiBbezCkCC6SQMmBhm5SYCssejUADiASBXA4DR1SnKMsrFguAj1OehVUCFLLe1KN+14v1zV8i5mZskFwySAbXrG+p6AVl7t79/DuU93C5E0cMc+oqVD7DU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=m23hJ53I; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=pTaTsgay; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50DExhUm012503;
	Mon, 13 Jan 2025 12:53:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=G2Gxw7dOY0+IHi5fZzUbPrihH5OOz9zPyErj1Nq0E
	cY=; b=m23hJ53ITMR4A8Zk82QASuOCRSDj8UFw4sqls8yqNmZ0DkY6uihUzh88W
	F3mG89vdIYegeoTZrSYluBbYPnpbBJGEYzWLK3o52pX1LNj3KDcwFyatvkQTM8CT
	uSR4LqEE6MzzKFpIGgmhkf7AWwnLMJru/M4pF59zFn+Z61LQT6T3DvWiDAbOkkbi
	TNh2eeTHetBCazbJxctJDnbGKVcegMYxrD0v+VDu1kI0JXsogd5NUQeqHtnp7Hnx
	9OxZmXiXf7GCmvM5SXV8r+vtAFpo+3yN8tUyXyE6WcWPq3hHiKN2tYXBErgNZ4bS
	VAqQPQ1DSGahyZI4scM8KmXpCX+DQ==
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazlp17012052.outbound.protection.outlook.com [40.93.20.52])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 443qmmvbm9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 13 Jan 2025 12:53:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ihyMycWeqSkNsusi8LiOePwSfu64D4z2hT9PKf37go8t35kpL2kTa/r675c4PkpFpA2FgHA1qyONTDPvXbdPnvNBt0uhw9ISUNngK4nvBKH/H3XPY+cPlxZDbd9apTy4XUUcEwE0GEc0whPCOAZ7RNh1wKggWi9ZB1EkEZokNqeYlDBOjLEtOAQnm2aMrEyV4qHaA4Em2cy1WrnUeZJVAW6N6hMoN7CrsDYGf84viAemeYFXNnNECsQcEHu+0WZDchGPEp+M1FV4Kx0d9BgI1+SIr1eRwUfomqSJTJ2rm2Hs5rq5cf3w82fnlmXGEgz+BRAbJPMbLqu55BtlWk0n9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G2Gxw7dOY0+IHi5fZzUbPrihH5OOz9zPyErj1Nq0EcY=;
 b=rRYRvXWWxInt0WzM0BFUkGALxExie7c1A9tpUxzAks37rQ3Zc4rJzHv1IdD0UTtbrkS50O3Ao9eAZBTQcXhJCcybFceNLqJEoipJHfednIcDY2ot2Rvj427U6Ls/7SF9oG92ITMrZloTfCCQ0OsKM1k4zofvUB1so7OxZ8CVqVa5ihEH28TQ9L2TzUOCLaNk7IUMMu7yZEKSLUrUvIGFdMfcjlizDbumhj57QA/5CSkma1ESI2ZomVSAxSSDKfFRnxzcVZxyQ41KJZUi8O5rvfNqe2/b+JdUsGOrLtcmnxjnlWfNakKcAf2X4YGYwrtY/gYRAU3woI3AGb0RVEGufQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G2Gxw7dOY0+IHi5fZzUbPrihH5OOz9zPyErj1Nq0EcY=;
 b=pTaTsgayLnBDRRus6oI7F2k4Z8dhGWjC5o03xglfECSxqj35rCDhXz53YhrpwI3hfkh7R7vpOUFxnyCyZKhf68JqBl+peyx8m4tlXUK/djPJy7oKhQgj1PWZZNcO/h8hT73lTgbUq1P3aO68kZ0pwX/pvGp48lPgpQU1c4wsCTH51upPPhh6bxuAMu067nVAojGMrg45wdEtLw2MqfvR3pImAfiyn7VZE3PUkpYfwfn0pUqRkQl2CW5RsOST3e5ZRMYmq87JQzP1yTXZEtwom8C4n6BQigsff5C72kWctoGOAMikhxCAU+O3+DFghLhsKfmPeqeBBLp1Jg7mgnKVMw==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by BY5PR02MB6817.namprd02.prod.outlook.com
 (2603:10b6:a03:20e::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.18; Mon, 13 Jan
 2025 20:53:41 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%5]) with mapi id 15.20.8335.017; Mon, 13 Jan 2025
 20:53:40 +0000
From: Jon Kohler <jon@nutanix.com>
To: Andrew Jones <andrew.jones@linux.dev>
CC: Alexandru Elisei <alexandru.elisei@arm.com>,
        Thomas Huth
	<thuth@redhat.com>, Nicholas Piggin <npiggin@gmail.com>,
        Eric Auger
	<eric.auger@redhat.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH] Makefile: add portable mode
Thread-Topic: [kvm-unit-tests PATCH] Makefile: add portable mode
Thread-Index: AQHbX5f8EXkP7wAqgkWvoAteylAdmrMUuR+AgAAcQACAAA01AIAAWKIA
Date: Mon, 13 Jan 2025 20:53:40 +0000
Message-ID: <3F7065A3-DB24-48C5-BD5D-05D98AF8E3E4@nutanix.com>
References: <20250105175723.2887586-1-jon@nutanix.com>
 <Z4UQKTLWpVs5RNbA@arm.com> <806860A3-4538-4BC3-B6B9-FA5118990D78@nutanix.com>
 <20250113-e645de551c7279ba77e4fb74@orel>
In-Reply-To: <20250113-e645de551c7279ba77e4fb74@orel>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3774.300.61.1.2)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV8PR02MB10287:EE_|BY5PR02MB6817:EE_
x-ms-office365-filtering-correlation-id: 95f10b60-fd25-48ed-00d4-08dd34145c50
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|10070799003|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?N1lyTTUwbkFUOTAxNnppT2Zpd2lOZUJzT0xNeHYzQ0JOci9IR0F1WVZDVmJ6?=
 =?utf-8?B?Mkd1QUFDN21oR0F1N1ZpM2ZLRE12ZTAwZklxblFYenFvRnF2L1U0eEhQNmlK?=
 =?utf-8?B?WWF0MjAyV3hDL3lsVFhRQ3NIZmJMMm5tclJpN09WUmVlL0RxaTVmWm8vNC9j?=
 =?utf-8?B?S2FmNnQ5eEVvQmlOTk1pZnltNmJ1bFZjZ0d3cXV2RnZLdWdhcGJiT3pxMGNt?=
 =?utf-8?B?T3VxenVnZWFMSmIrVExSZkExUkl0empLZmF1TTNQZi9sU0dGU2d2a0ZhN3cz?=
 =?utf-8?B?RnlRMUF3ZzFTMk84QkZBSk1VYnpyVUFITnpRdGQzdDM3TXJUVjhvcStPNDlt?=
 =?utf-8?B?MCs4RTVzSlNOSWo4ZlI3VnovOGk5VnhoZk5xRUZwbkc4VThHNVVmQ2Mxbml2?=
 =?utf-8?B?OU9kMzFZTnd6b0ZiR3NSeVdzblZtekNTOUlXQWI4ZGdPUVEvS21BWnJHK1N1?=
 =?utf-8?B?OUxmTmtzcDZDR0gvVWwzSGlCNlVyelBqbEQ3UVQxM3Z2MlZ3WG9VZWMydFlm?=
 =?utf-8?B?R2NocFBqR2RUWnNiSk15M21BdkliL2lSS3FOU0YvZExEQ0JaWTE1NUk2bjRC?=
 =?utf-8?B?WjBRWWk2ZUh4SHlhbGxabm1HaUZRTFdyemZjWWllbHMzMTA1eU15aUJOVWxR?=
 =?utf-8?B?UXVZSzJPWThNNmNNZHJXa3NTQWtmVEo1bElQbGdlK3pLYmJTbWZqUU91ODR2?=
 =?utf-8?B?VFdoSWhFTXpIWTRjZzBpYm52bG5ZazNsUTFNL0ZJM0c2Zkx5WU5rZHJ6c1dX?=
 =?utf-8?B?YWlDZy9GWmE5VWR5aEswSGh0NG41NmFweTZXcURhYTBUUm12MzRUV3ZzR2ho?=
 =?utf-8?B?Ui9vVVFvMFRXeXhuTFRGQUhTMFFtKzlNVnFUM2xlbkluM3FFRU8rYWdvWHFm?=
 =?utf-8?B?RnJyZDUrcnJXdXBUWG1DaUszOUQ2QkhyRllyL2MzL0hKYzNUa0R6RlM3VEpt?=
 =?utf-8?B?NXJjTnJXWUtqdlNwQWw4QVdzZzZzMTBRZlhnUklYMXpRT29tN2xaeUdCVmt0?=
 =?utf-8?B?M2JBbnhNMzhsZGFrSW5oVGhuY0IyVTJLUmVWcTZ4KzQ0N0FFeGV3bUl3dEdr?=
 =?utf-8?B?QlZnNTFxeGFET1Btd2I3cngzRzJDc3ZTdTNhMUZGZFFVVGtBRlkrRUpOeGlK?=
 =?utf-8?B?bS9qNExlUkFXTW9TWHRDZy9PNjJKaGlyQXR1VTV3Z2lPSGJyVmpBc1A4cTVw?=
 =?utf-8?B?VkVRVXZwSy8vYlhCbzcwYVc5bGsvM2VsenU0SE0xUXViOEdiQitMNiswMDBR?=
 =?utf-8?B?cm40YUc3Rmc3OEUrUjl2YTZtekJnVkN4MUlQTzZPZFhFa0tlMHVqckJsWWJz?=
 =?utf-8?B?cng1K0tmbENKRGxxSGx2U1FCS1RGNEdGOEJtRGZnVjkyYzRaL2QvUTVseEhB?=
 =?utf-8?B?S1NSbzdra05FZ1RDa2I1bTFiMzh6cE52dDhkL3FuRnI0eFNkWUxUOVoyOE4x?=
 =?utf-8?B?eEk1OFNtdktaU2x2QmN5NkpXS0poYjc3dnE0U0Q0UmQ1bTkzaFNYcHFBRGYr?=
 =?utf-8?B?WGt1U2FXbEdvcmNHeWdjYW83R0NPeVkvVGN1Y3RPOU9HZTFycXJTSGVsdTBF?=
 =?utf-8?B?c2pyMEhVYW1XbVJNck9EL1R4OHppekdMTkUzYXNuTFZqTzFkQXB6S1A5a2Z3?=
 =?utf-8?B?c0xNN29pNUxWWDZ5enpPWEVmc3BGU0pid0M5ZWNLK2VCb1ZPaWVWcTcrYmx3?=
 =?utf-8?B?UndkMDUzRHJTc3Z5T1hycEFmazMrTFpPWFR1U1c0WG5ZSjY0dEVtaUl3T3ZU?=
 =?utf-8?B?L1kxT0ZqQzJycFZUUXVoSXpPMFNidWR6ZEZQSG0rNnlpcWV2VEl5RmZyandQ?=
 =?utf-8?B?a1QyenFLNWxoN0FWUGVXb3NwL1d6Rzl5SnVXSzRRc1JJQ0M2TmQ4TkN2WWR6?=
 =?utf-8?B?UUpKVW1rRFBDRXZZOXZXWHpYMERvZVBOWnJaL1EzTlU1M2ZPRStyV01wSklt?=
 =?utf-8?Q?zDc8SshF4GHpy/75Wgshe3Ot5bn8OhqS?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(10070799003)(376014)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?K1NqbnljcithVW1EZjl5aVMxMEtJNDJVVG1iN3k5N1ErRjA0QlVWK3VPaWxS?=
 =?utf-8?B?WDVDTlU2ODdRcCtybWlISmtLV3pmVlllS1dBYWFPS2creXhUckVpcy9EbHhM?=
 =?utf-8?B?bDBwVTM0MVhpWnZybWsvT1pPWXdKaWVFNWVzOXpDZXkvbUJibHJXZWRBVWk2?=
 =?utf-8?B?aDk4c2FnNTNhR1Z3UXF3ZnpBdHV4K3hzVzM2aEdtNVBveE1yUkNEZXJhZW9n?=
 =?utf-8?B?Z0ZsTVBadkVrSmtycUYrR2dSSTFzM0tQSVVYVUFhRFQyVGVEUlNucW5wR2xC?=
 =?utf-8?B?QkEvek8rdllrV3FTdXRWRDVla0tRcWN1SjBsRVlUQTkxZGswWklqUGwyYkVF?=
 =?utf-8?B?OGNOZjZwSFhoYW5rVUJEYXllU0xvc1ExWThpbmphYXVzN09WK1J5Nk1HR3Vn?=
 =?utf-8?B?cFJvNlNzbXJtTkh0SC9TQmxoQlBtWlpQNnQxeGJLVVo2ejNpOXh6bUFlSkxr?=
 =?utf-8?B?ZWhWRitKQ3VPQ0Fjclo0aVRqTStZWk5PM3BoNVIxWTF2Q0pOMFZCWTNDWG1H?=
 =?utf-8?B?QUhWd2hzMjlCcnU1U1pHVnE2MEdkeGVhS3hYRkdjb1Avd1RveHQ3a3Q3YmJS?=
 =?utf-8?B?Wi84MVlFUlBRWWZsQk9ST1JpTmdJS09XUW45am5EQmI2WnB1TVlKK0k3QXVW?=
 =?utf-8?B?dUcybVluczBkMDVzRis5aHhHYTlhekwveGprU3JGQXZ2UWJnMmpRRXQ4VHNa?=
 =?utf-8?B?TFlzMUg2NjV0K25WUkxGM2tDVDkzR3RkUFFESUdFNnVNNWpiN3MxUFRUQ3Nx?=
 =?utf-8?B?cEJCdnErak9BKzdlZ3l0U1E3QlA4VjUyUEVSeThOdERUb1JWYjNYOXVIZXZL?=
 =?utf-8?B?eU9ZdUJIcHVOc2VwY0VsUmpUSmdSalBIbUV2dUJyWDNlMW5oNS9zU01zNUFq?=
 =?utf-8?B?N0hSai9QbnZNeTlHL2Z2MmRsOUJlZktHYmtLTjJyaDcwbWVYZXFEUEp3Vk9K?=
 =?utf-8?B?MjVMTThkWWorZk9kOVE3SXVueHBGT2JmR3NjeExRKzRWTjk2ZXlPdi8rQjhG?=
 =?utf-8?B?MHcvV1ZQMU8rcGVtbDJ4QnNJSUQvT3hwUjcwaTlEZ2lSZXVGWE1NTmpJTER6?=
 =?utf-8?B?Y3dSc25JdVVSWlBNYWFHSXVQMDkwWE84b3pPaFVXazhSSysyaTcxbWNoMy9R?=
 =?utf-8?B?bmRHeFFrK1dnSU9TU0ltNU4xdlByUWRYRmlBZGRKZnFqOURCc1o1NHdUQkww?=
 =?utf-8?B?aGg0elRpc0drQTgwellqaENhN1g1K2gwZGRJOWNSaDFrZzBjRXFOZ3k5WExX?=
 =?utf-8?B?bEs5ZHlFdWZDQy8vdHRqMmZoNnMyY2w0NVRyVDlHVnJKTDU5UHRiVHVsRTNK?=
 =?utf-8?B?WHJqWFJLelMxRGs3MXRkUlJtLzh2c1hWTWFxaVo3L1FUR3NaQlZocHdjSGpl?=
 =?utf-8?B?VTN5NXFHaFJ6VS9EcWpFalNIK1l3bUNQVzhNaUk5dFZ4YXFpS0pNRWhWWDNM?=
 =?utf-8?B?aTd4Tkx5YUxzODlsNUFuRTMrZlc2YkZ1dW1NYlVoQVhYekFNSGRHbXdWMVdn?=
 =?utf-8?B?UkhXOTBqYUxCZ21INGdibHhTNXdxY2U5Ymd2QVRiaEhaTDR5RG1JamYyT3d4?=
 =?utf-8?B?eGFJWUJpYXJCZC96Rm9nbFZ6TDdielFKeUpNUVpxbHRVZ2FRcFNKd1RGdE4r?=
 =?utf-8?B?S01MRUR4T051eFJSMkFsN3RnSHdiRHh2enVrQ3VTejlOVW5Ec3dkYUpCZGxF?=
 =?utf-8?B?MFZoa0F3d213VmFJb0JpcjlIUDNGWTg5RGM4VmtDYnIzZ1IvTm5vcFNqY0RV?=
 =?utf-8?B?aC9XNkh2NG9qVy9uSDFJRGhpM1B3OTdLU1ZLbmNodWx6eUFmZXptQkk5V3dq?=
 =?utf-8?B?bFZIcThxS2pRUTJIVXY4aG16QlNlajY2UXBDbi9oRjRrblhMb2ZoUUoycnhL?=
 =?utf-8?B?WWFsY0lESFhPTFFwenRGbHJ6eWRCazdTL2pWYkFQcW5GdW5uRTRsNE8rRS96?=
 =?utf-8?B?QlM5Yi9nd2VoTVRwc2JGampzaU56dEpDTXhsTldnMXZRaTlRd1FMbG44NFg3?=
 =?utf-8?B?K3pPR0crQndTelloaExxeUVRY3R1S2xxSW4vdnJDVnJiZTlheUVObXdWWWd3?=
 =?utf-8?B?YzRxWFdMZTBVM2tDc0dFcDhkaXMyMHJ1Sll6VWNCVEJzaEp6U05abGp4UGZ2?=
 =?utf-8?B?bVN4a1FHOHF2cHRSWUNCN0RlS3dHNVFiZEROOVNLMlhQUFVzWi91SndwcmZR?=
 =?utf-8?B?bHhFditXQmNlbDdISHJtNDh6TjhrcUdlcS85Z1hJQTlFanJMaGRLZjZBVnVN?=
 =?utf-8?B?azIxd1ZyK2s2eGY1ZTlibnNlNEhRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9C17D9AEDA0990469541D71FD7D43781@namprd02.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 95f10b60-fd25-48ed-00d4-08dd34145c50
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2025 20:53:40.8772
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dUZ/4PG9n+ZKNATe7dyRRPcDCU2hawBBlvCfICZhAIaxQ2W7gUNyWU+WWAaOeohy10tqNGLxyVUyUb9zutr6fy3+D2m7T8qcieMadSDiauo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR02MB6817
X-Proofpoint-ORIG-GUID: rMu6iCIUbNOB7dVazZHcKa6LPeEYjK-5
X-Authority-Analysis: v=2.4 cv=StRq6OO0 c=1 sm=1 tr=0 ts=67857d56 cx=c_pps a=UnxCF3xIguukyKwtQsEHPg==:117 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=VdSt8ZQiCzkA:10 a=0034W8JfsZAA:10
 a=0kUYKlekyDsA:10 a=7CQSdrXTAAAA:8 a=OQGWXCVmJ-ROUqwtZAMA:9 a=QEXdDO2ut3YA:10 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-GUID: rMu6iCIUbNOB7dVazZHcKa6LPeEYjK-5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-13_08,2025-01-13_02,2024-11-22_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gSmFuIDEzLCAyMDI1LCBhdCAxMDozNuKAr0FNLCBBbmRyZXcgSm9uZXMgPGFuZHJl
dy5qb25lc0BsaW51eC5kZXY+IHdyb3RlOg0KPiANCj4gIS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS18DQo+ICBDQVVUSU9O
OiBFeHRlcm5hbCBFbWFpbA0KPiANCj4gfC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0hDQo+IA0KPiBPbiBNb24sIEphbiAx
MywgMjAyNSBhdCAwMjo0OToxMVBNICswMDAwLCBKb24gS29obGVyIHdyb3RlOg0KPj4gDQo+PiAN
Cj4+PiBPbiBKYW4gMTMsIDIwMjUsIGF0IDg6MDfigK9BTSwgQWxleGFuZHJ1IEVsaXNlaSA8YWxl
eGFuZHJ1LmVsaXNlaUBhcm0uY29tPiB3cm90ZToNCj4+PiANCj4+PiAhLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLXwNCj4+
PiBDQVVUSU9OOiBFeHRlcm5hbCBFbWFpbA0KPj4+IA0KPj4+IHwtLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPj4+IA0K
Pj4+IEhpLA0KPj4+IA0KPj4+IE9uIFN1biwgSmFuIDA1LCAyMDI1IGF0IDEwOjU3OjIzQU0gLTA3
MDAsIEpvbiBLb2hsZXIgd3JvdGU6DQo+Pj4+IEFkZCBhICdwb3J0YWJsZScgbW9kZSB0aGF0IHBh
Y2thZ2VzIGFsbCByZWxldmFudCBmbGF0IGZpbGVzIGFuZCBoZWxwZXINCj4+Pj4gc2NyaXB0cyBp
bnRvIGEgdGFyYmFsbCBuYW1lZCAna3V0LXBvcnRhYmxlLnRhci5neicuDQo+Pj4+IA0KPj4+PiBU
aGlzIG1vZGUgaXMgdXNlZnVsIGZvciBjb21waWxpbmcgdGVzdHMgb24gb25lIG1hY2hpbmUgYW5k
IHJ1bm5pbmcgdGhlbQ0KPj4+PiBvbiBhbm90aGVyIHdpdGhvdXQgbmVlZGluZyB0byBjbG9uZSB0
aGUgZW50aXJlIHJlcG9zaXRvcnkuIEl0IGFsbG93cw0KPj4+PiB0aGUgcnVubmVyIHNjcmlwdHMg
YW5kIHVuaXQgdGVzdCBjb25maWd1cmF0aW9ucyB0byByZW1haW4gbG9jYWwgdG8gdGhlDQo+Pj4+
IG1hY2hpbmUgdW5kZXIgdGVzdC4NCj4+PiANCj4+PiBIYXZlIHlvdSB0cmllZCBtYWtlIHN0YW5k
YWxvbmU/IFlvdSBjYW4gdGhlbiBjb3B5IHRoZSB0ZXN0cyBkaXJlY3RvcnksIG9yIGV2ZW4gYQ0K
Pj4+IHBhcnRpY3VsYXIgdGVzdC4NCj4+IA0KPj4gWWVzLCBzdGFuZGFsb25lIGRvZXMgbm90IHdv
cmsgd2hlbiBjb3B5aW5nIHRlc3RzIGZyb20gb25lIGhvc3QgdG8gYW5vdGhlci4gVGhlDQo+PiB1
c2UgY2FzZSBmb3IgcG9ydGFibGUgbW9kZSBpcyB0byBiZSBhYmxlIHRvIGNvbXBpbGUgd2l0aGlu
IG9uZSBlbnZpcm9ubWVudCBhbmQNCj4+IHRlc3QgaW4gY29tcGxldGVseSBzZXBhcmF0ZSBlbnZp
cm9ubWVudC4gSSB3YXMgbm90IGFibGUgdG8gYWNjb21wbGlzaCB0aGF0IHdpdGgNCj4+IHN0YW5k
YWxvbmUgbW9kZSBieSBpdHNlbGYuDQo+PiANCj4gDQo+IHN0YW5kYWxvbmUgc2NyaXB0cyBzaG91
bGQgYmUgcG9ydGFibGUuIElmIHRoZXkncmUgbWlzc2luZyBzb21ldGhpbmcsIHRoZW4NCj4gd2Ug
c2hvdWxkIGZpeCB0aGF0LiBBbHNvICdtYWtlIGluc3RhbGwnIHNob3VsZCBpbmNsdWRlIGV2ZXJ5
dGhpbmcNCj4gbmVjZXNzYXJ5LCBvdGhlcndpc2UgaXQgc2hvdWxkIGJlIGZpeGVkLiBUaGVuLCB3
ZSBjb3VsZCBjb25zaWRlciBhZGRpbmcNCj4gYW5vdGhlciB0YXJnZXQgbGlrZSAnbWFrZSBwYWNr
YWdlJyB3aGljaCB3b3VsZCBkbyAnbWFrZSBpbnN0YWxsJyB0byBhDQo+IHRlbXBvcmFyeSBkaXJl
Y3RvcnkgYW5kIHRhci9nemlwIG9yIHdoYXRldmVyIHRoZSBpbnN0YWxsYXRpb24gaW50byBhDQo+
IHBhY2thZ2UuDQoNClRoYW5rcywgRHJldy4gVGhlIHN0YW5kYWxvbmUgc2NyaXB0cyBhcmUgbm90
IHBvcnRhYmxlIGluIG15IGV4cGVyaWVuY2UsIGFzDQppbiBJIGNhbiBub3QganVzdCBwaWNrIHRo
ZW0gdXAsIGNvcHkgdGhlbSBhcyBpcywgYW5kIHB1dCB0aGVtIG9uIGFub3RoZXIgaG9zdA0Kd2l0
aCBkaWZmZXJlbnQgZGlyZWN0b3J5IGxheW91dHMsIGV0YyAoYW5kIGltcG9ydGFudGx5LCBubyBr
dm0tdW5pdC10ZXN0cyByZXBvDQp3aGF0c29ldmVyKS4gDQoNClRoZSBtYWtlIHBhY2thZ2UgaWRl
YSBpcyBlZmZlY3RpdmVseSB3aGF0IEnigJltIGRvaW5nIGhlcmUsIGJ1dCBpdCBoYXBwZW5zIHRv
DQp1c2UgdGhlIHdvcmQgcG9ydGFibGUgaW5zdGVhZCBvZiBwYWNrYWdlIChhbmQgbm90IHVzaW5n
IG1ha2UgaW5zdGFsbCB0byBkbw0KdGhlIGRhdGEgbW92ZW1lbnQpLg0KDQpUaGF0IGJpdCBpcyBp
bXBvcnRhbnQ6DQpUaGUgYmlnZ2VzdCB0aWRiaXQgaXMgdGhhdCB0aGluZ3MgbGlrZSB0aGUgZXJy
YXRhIHBhdGggaXMgaGFyZCBjb2RlZCwgc28NCmluIG15IOKAnG1ha2UgcG9ydGFibGXigJ0gaXQg
Zml4ZXMgdGhvc2UgdGhpbmdzIHRvIGJlIG5vdCBoYXJkIGNvZGVkLCBhbmQgYWxsIGlzIHdlbGwN
CmFmdGVyIGZpbGVzIGFyZSB0YXLigJlkIHVwIGFuZCB0aGVuIHVudGFyJ2QgbGF0ZXIuDQoNCkFs
c28sIGluIHN0YW5kYWxvbmUgbW9kZSwgeW914oCZZCBiZSBtaXNzaW5nIHRoZSBydW5uZXIgc2Ny
aXB0cywgZXRjLCBzbyBpdA0KbWFrZXMgaXQgaGFyZGVyIHRvIHR3ZWFrIGFuZCBpdGVyYXRlIGxv
Y2FsbHkgb24gdGhlIHN5c3RlbSB1bmRlciB0ZXN0Lg0KDQpIYXBweSB0byB0YWtlIGd1aWRhbmNl
IGlmIEnigJltIG1pc3Npbmcgc29tZXRoaW5nIHBhaW5mdWxseSBvYnZpb3VzIHdpdGggdGhlDQpl
eGlzdGluZyBzdGFuZGFsb25lIHNldHVwIChJIGZlbHQgdGhpcyB3YXkgd2hlbiBJIHN0YXJ0ZWQg
bG9va2luZyBhdCB0aGlzISkgYXMgaXQNCmRvZXNu4oCZdCBkbyB3aGF0IEnigJlkIHRoaW5rIGl0
IHdvdWxkIGRvLg0KDQoNClRoYW5rcyBhZ2FpbiwNCkpvbg0KDQo+IFRoYW5rcywNCj4gZHJldw0K
DQo=

