Return-Path: <kvm+bounces-42877-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D8BF4A7F21A
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 03:18:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2AF5B18980DF
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 01:18:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC3CF22F392;
	Tue,  8 Apr 2025 01:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="lOr2YKL2";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="DjuLU5/l"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A47717548;
	Tue,  8 Apr 2025 01:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744075107; cv=fail; b=LtcUDy63bjmfzikX/mhUuFDOytYcznFSntLDwJkL9jpjeRhOK+2xVoiaY26a7iGS2+7rOnRefwzbMMaNFsa62fy9Can+cuoX3u6KFKtmL3JeiBFiMFLnNbUYypejPsWQFkqq9jLqVjKUjY4Jpr6j3mSgRqAAlOaqKzQcizDnVls=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744075107; c=relaxed/simple;
	bh=GXCiHe3urb8uWMaRZD/8Xjwk6Rv9vJL9i9JYWZe1lmU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=e0nsLbl6ocDw2Qb+jU1oGdk39rJfuXWNnDa+eumi/VwFZjC3q1QzbJYH3/OWDn/OtudjZ3tNEaA8hMlILSQdG8TxtI5XpCS8EmfndmMoe9oXdxAzI12G+IQcFTnrNuccP/Jjhp/LQlGPkDwvo2eIbaTUk41jzCoFCdO45u/tuJ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=lOr2YKL2; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=DjuLU5/l; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 537HcZJU002469;
	Mon, 7 Apr 2025 18:18:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=GXCiHe3urb8uWMaRZD/8Xjwk6Rv9vJL9i9JYWZe1l
	mU=; b=lOr2YKL2aY6jQikKRe3EsHJq3txP7ZQh5/4Xjyvxr8KLHWAkBFIP2yzlk
	XQUO0I01sHT/3VwK9mpokNQPOGSlUKJ0BoNOXmZydsjYbNUEP7hGOBnkMD3wI/H6
	4DjVmImVITysLe/ITB6zupJYL+wzbij2qEs4CUa6iFMXWX3yGRlszG4hK1cdNics
	upR67DnopoRJYDxXcyM6LqQ09yXSpiw4eyKoReMMTqKCwsd+hjuLrZnTS0zFpkLu
	LocjFtFHxiTHx1GCT2k9wxIUn6rcvSxuAXrE1eXgIT3ukHtdQRWWewOH4uLqupLU
	ECszIrUzP/Lro0khmjftMHzxFqeIA==
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazlp17010000.outbound.protection.outlook.com [40.93.20.0])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 45u0e7d47e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 07 Apr 2025 18:18:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Yw9MQdyMucHIIA0oRLnWRUf9ZHoSDSsGHZsYQSZIku3Nama+SJ9o0m936ZSAl8IX7Jd0yzgsChObsBEh0JzthgRaR3kSMZbyRz2+0PoF6Lhu0t9cTpgLHnz4xbFxZThUjNQTuUozeb7L0oL5p5t5RP/BLxHuxPzMSUn7Hfob2m1Z1mR8bd3smK9jKlAx2KXJpI51yV9O1TSNhqlO3dUQSJ4At+9jEBc5T/FCwJp+llmTjLbZTgJ2gHy9YcQ28X3ZS+IskZFQnr1DKMErxMEulUCmzvDIkYbluWrLrtEJvD5vdW6pCR+1eDhaDgWTm+CeRix6dzMVQebEmK9e17Z8aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GXCiHe3urb8uWMaRZD/8Xjwk6Rv9vJL9i9JYWZe1lmU=;
 b=n9gEt73pNsMRRk9xPVSivXSchlxYzlYj67g/9Ul57sOYmt8yxdng+oxQCxde8TZje1BZUKunzpgZKoJ6wedNU+/A+r+Om+2b4MS/Wn9Tdd1SLgOBm+ZpiTQjrxpeaQEPUesUk6azz+ujC0J7tRIH0V5lH5Kr31vjyTnDM25R8w0cq+1GMgXP1ysjyd+qa3MXJh+mBFcWQTbrt8YiPyif1e5GxxelN51kVvVYdMCzbOtffOLpXqk28w9mhv6N4/f+hpW0R3XHwPYXQ9k93NjHcBJmPFExweaKcu+kg/wTuPUrbR3573DrxeIf85z7RXtlxL4BnU2mRBv6nUqvf9w1hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GXCiHe3urb8uWMaRZD/8Xjwk6Rv9vJL9i9JYWZe1lmU=;
 b=DjuLU5/lE30e8kZe/SBED45xfPwuc9nguB5tRr2UiUgSeSaHRepoLPk9ThHElXCZ4BI5dARHyZ7HP1qzzN/0n2EIq+kjOMlpuzA4eFg6FHl38tiYOBr0Wrzv/LexH9iJxJKNScbVrhpY3F3YTxXAHR9VfQaiBIjlpEYCwLXqdIvBZCNL6rERREk7iJeo2zhRfxPoOtrSiA8VyVCc58VKMa1o53v/xq38cQeEc3U7NCeoCoHQhXBttO50JaWcgk9rzCO0PPIbOME2k45TvJarafIAbRZc8Lrv1H7iq7VEb1j0Min1BWqVoKoEHHicchfYP/YlQA+5yI0k1WMimA9P+g==
Received: from CH3PR02MB10280.namprd02.prod.outlook.com (2603:10b6:610:1ce::6)
 by CH2PR02MB6538.namprd02.prod.outlook.com (2603:10b6:610:61::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.35; Tue, 8 Apr
 2025 01:18:09 +0000
Received: from CH3PR02MB10280.namprd02.prod.outlook.com
 ([fe80::44c0:b39:548e:2e8b]) by CH3PR02MB10280.namprd02.prod.outlook.com
 ([fe80::44c0:b39:548e:2e8b%4]) with mapi id 15.20.8606.029; Tue, 8 Apr 2025
 01:18:09 +0000
From: Jon Kohler <jon@nutanix.com>
To: Jason Wang <jasowang@redhat.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>,
        =?utf-8?B?RXVnZW5pbyBQw6lyZXo=?=
	<eperezma@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vhost/net: remove zerocopy support
Thread-Topic: [PATCH] vhost/net: remove zerocopy support
Thread-Index: AQHbpW031K1yxtchPk+rB14ra05W57OXetWAgAGCcAA=
Date: Tue, 8 Apr 2025 01:18:09 +0000
Message-ID: <B32E2C5D-25FB-427F-8567-701C152DFDE6@nutanix.com>
References: <20250404145241.1125078-1-jon@nutanix.com>
 <CACGkMEsFc-URhXBCGZ1=CTMZKcWPf57pYy1TcyKLL=N65u+F0Q@mail.gmail.com>
In-Reply-To:
 <CACGkMEsFc-URhXBCGZ1=CTMZKcWPf57pYy1TcyKLL=N65u+F0Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.400.131.1.6)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR02MB10280:EE_|CH2PR02MB6538:EE_
x-ms-office365-filtering-correlation-id: 3871146a-2d1b-4da3-f0cb-08dd763b392a
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?L2xEeko3VkdhSnNxV1pmU0UwN3F6MENUcXBCWmRZSkY2NG15bnNTMUEyZVRa?=
 =?utf-8?B?RDRmdFJtb1hYSXBCdi9NYnZ0VkZHQkVHdnZrZStRNWEvd2pVdU04T01kc0ZQ?=
 =?utf-8?B?OTJZdFZjaGZUeUp5d1duNzRYemx3dEJ4aTdSbno2NDZJOEJpVGM1L2pwa3Qw?=
 =?utf-8?B?ckZBWHFscExtM2J0VXEzY3ltM1BLQjFxZ0d3ZWpHZlh2YW5BQ1ovZUU4MDdK?=
 =?utf-8?B?WTZnYk8rQnlTcHd4WmtHQ0xQaFNzL0RndnNIRTVETDVRbjA0Vnc0aHFMZ3RO?=
 =?utf-8?B?WHZwSDNCbU8xZHp0SUFNdWREb1R5RjlRUVlaZDVuSUtBQTNsWWlKSVh6MktU?=
 =?utf-8?B?WFVhckRRRXBRdjdzcDE2RUI0QitNd3lXQ25MYjZ4d1FGQ09vQ1NML1dqUFRo?=
 =?utf-8?B?S0pxK0dzTkVqS2lXRmFoMjd6LzBiVVRYMzYwSTJtTElMaWl1MjhmeUI2MFh4?=
 =?utf-8?B?RXlnZ2FhS0JKSjFzN1djeVhEc2FhSHZjMlFRVk13WFM2dkx4andscmRORHl4?=
 =?utf-8?B?amszKzI2U0VyZFR0SHZrVm1LSHVEZUtUMEN5N2RJV0J4c2tGM1pYeWQvSnpi?=
 =?utf-8?B?SWVNTGxLdWtIbFM0RytzTmJMMkJDSm8xb3h4RnJsampSZ0lZelkzSGh6ZGd3?=
 =?utf-8?B?bmNrdDVsOEI3R2pGNmg5a3A5cWtCQ1lvVjFaclpZRDBuRDBrblRiZVRYZHdT?=
 =?utf-8?B?M2hITkNkQ2NwNSt6YjI0Ykx0ME41RU9CYW90azBTbUFMTkRWOW9oK3JYUHcr?=
 =?utf-8?B?NEF6cUhUTmNjMk5OTkZkYldLVUNrR1o3M0xVRE8yeVJqZnBDMVZTSjVwZmNO?=
 =?utf-8?B?VUgrc3NVMWdoNHNwZkl0a2pidXF0NXNYTHdHY05ZbmhZcG1JUFpZb29saXJr?=
 =?utf-8?B?L1VWRmJ6OTR5NGZWVlkwNThLdE5hQmJrUi8yaVlNNlJCSW0xNy85dnA4QU8r?=
 =?utf-8?B?eDB5OThqeHhRWFg0bGdHM3RXWUdnUnZxU3d0Uy9KRng1WWVYcEgzdW5oUmFP?=
 =?utf-8?B?VXBMbXYzMjZYN09wUm5vd1pSN3NUZHZwZC9SUmtnUzN2Ri9uMzh3amY5dEc2?=
 =?utf-8?B?aXBzL1A2YnUzSG1DL1dEaG1QdHl1ZlZVdFBENFM1cFFKSlRVV29XckpjQlp6?=
 =?utf-8?B?V0I1STB6azN1RjdoNjExUzhoTTBtb3pKbElPVWNFU0ZqRjJ5Ti9BRFRNNzRo?=
 =?utf-8?B?VVBUVVo4QnhPWXNQMkNWeUlTS3ArdGFJMkJxSkVoVDBlcDdiYUF3SVEyYjlV?=
 =?utf-8?B?UDJqaktkN0IyYStGbXhnYzZBR2ZkYW5qUHVlUnlGUWdBalhMOHNBYVYvTHJZ?=
 =?utf-8?B?UVkrMzZqeTgyMEJZUG1BOGE1ZDBSQ2V5R1hsUXBMY2QxOWxHRjh0N2VvVVNn?=
 =?utf-8?B?R2YvR0VxTTZHRTQ2WXpuWVhiWVd6V2Y0dEl6VW1TNXN4QWpLUXdQYmMwWVhZ?=
 =?utf-8?B?VHlOTjV0T29qak56Y09MTk9VSDhkQUNzZ0cvajBpWmpyV3EwQkFIdWlPV2RV?=
 =?utf-8?B?SGY0WDAwSURteVhyTDZ0S2tvcWtJSHlqNHhVV2J0b3hqSThzdnp2MlE4bXlL?=
 =?utf-8?B?R0g5bjNuL2tGZDQ0dWxhT2NybVZ4VEo2V3c5Y0VHK0EyOEJvOHVKYmlqckxI?=
 =?utf-8?B?cEZQUG9kWURVQmJydU43UHd0YTNsUGZNQnVNNktNbWZseG0xODJVT1RWL2ZI?=
 =?utf-8?B?Uk41UWNnYnYzZ3FQNjh5WUdDdndRL0tjNGR0dmJXUFFWMjh4TU8zdXJ5dGRK?=
 =?utf-8?B?eTh3Y1A0cWZpcW1RTExFWko5NkVTT2lhdFdrZnZLTnNOTG5KQUp0SFlRblJ1?=
 =?utf-8?B?aDdGcHRrY3oxVXppdHA0Y2hjUXZ3bWNWRVRXV2hJcEZmWDRQWXV3SUxaMHdY?=
 =?utf-8?B?VUtiMjdRRlkyVnJKUGhFb1dVZUtaakZVcXJuampva09SNHhnbURWNk5SUzJT?=
 =?utf-8?B?enRXWTNlYk9tK2ZhMHBSUTBmbGdGK2VTV2I3VHdKbFlGdjJCS1QwakFMY214?=
 =?utf-8?B?aEJYVnFWU05BPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR02MB10280.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?eUxNd1ZXL2ZoVkpSU1NiYXVZNWNPS1VhbE9VZnZnbUJsc0lvNHZQblJDeWpu?=
 =?utf-8?B?YTFRc0NvOVJUMmw1VCtJWmxjQmozNDU0K2tKK0hycGZyVXFpOEEzU2crdUll?=
 =?utf-8?B?ZmVQc1ZONTJnQ1kwODAzVjhIelVrSk90RmVJeW9uMURvS1hIVVgydyt1SW5j?=
 =?utf-8?B?NDE5M1lraUpROG42cXdiU3J5aThlMkFuWis2ZlhDTEU3NW9YNzBNMmYzeTlL?=
 =?utf-8?B?dlRKaWJtWnoxUkZjakN4SU9XQWNCYlJzalI4SUhBMHJDa3BYZlNMbGV0bzFr?=
 =?utf-8?B?dEUrZzg0S3JWYkNXRy9RZ0NsYXlNUW10SUVpL082TXBlaUNRRW1maFVTL3dX?=
 =?utf-8?B?NXVHVERqYnk5a0ZRcWhCbkVaYXk2enh3K3FBSndmbUtGcHlPQS81UlVFdEg3?=
 =?utf-8?B?MkM4QlBjbnAwMjBuL1ZBVjZDamNNYUpRWkFqOVRweHBmaG9Vck9BWE4yRXg4?=
 =?utf-8?B?MGJaVmE0WC84Sk91V1pjMnMyYkovYUN5TUQzYysvQnQ0czJIMVhrUnhkNlZk?=
 =?utf-8?B?cWt5SzFBcW9weC96R25hRVRLMmdqYmxmZnE4cDBPenFIY1pKcWp6NmRFeHlO?=
 =?utf-8?B?Wmg4cmFXd1hvUlBab1pBSUZCYU8yTXZpMUVyS2xxRzVOVDJGTFZJdjJCMHRu?=
 =?utf-8?B?QysyaTR2bFBhUUFyMDBUZHBlY05iWWtLOU1lWWZ4MXpPdkhJc3ZodUhyWE5h?=
 =?utf-8?B?YVFKVVMwV3pJRGxNZU1EQlcxU0JjVlg5UWdISmwwdERSemg2NFZpL0FpYWll?=
 =?utf-8?B?cDAyaS9HNWkwQVU3VVJXQU1mV1pnMmkwMy94Rmh2SUhuQ2pBMFhpN2h1elN1?=
 =?utf-8?B?Qm5PVktMbm9UOUt6TzE0ZGpWK0hHUS9NTjFSOUNZK3l1ZFNRa2NQeCtyY2ha?=
 =?utf-8?B?ODBzWjMvUzdrSzZRMVMrbW5Nc3BzQVlVdVhTTkQwaVc5MC83cFhPTWxvV3dm?=
 =?utf-8?B?T2JHUHRjbUZIVFNjVUh5ODhaRmhiQWc3RGgrdzZ0eUpxSGhSUUpLalJCLy9N?=
 =?utf-8?B?OU05UW1TWTFEclJuOWVSUzVHVmxKa1Z3SGJsUW9mWEwzNm5xaVQwYXNqcFh4?=
 =?utf-8?B?Y1BUamw2TnVOOWJDZGVZVHJpQ214cm8vY2tBS2hQWjhleEU4L01ucjMvRG1x?=
 =?utf-8?B?VG1FdDlHckQrRnlEbWdIMU94QnFIOVZ0TUZwVTRMUFhKMjdRc0pxY1dZeXd5?=
 =?utf-8?B?a2t5UkxzOGIycCtEQUJHaVdCb3RiUENEUFJ6ekYrd1RDVzVVczNaejBORmJ6?=
 =?utf-8?B?cGl6eFVsazNvMEp3NFFJZVFjdDNmNWpkR0NhS3RqV3MzMnhCQkNWclgrdlFs?=
 =?utf-8?B?QkJ1T2NFVzgvUTY1Vm1LcUVmUDhLU2dRT05wK0t0cUczeXZ4blJ2Z2tEOW16?=
 =?utf-8?B?RW1DNmt4N3RJb0daZEFiQWpVM2hBaHVKaitSd0V0SXRPUmNUSGx0WkVYeW5y?=
 =?utf-8?B?Q0Y0YUtEQ20yRGdkRFJuL01FYzkrODV5VDkrSG1tOS9wbXZtemhzUTdSVTJM?=
 =?utf-8?B?eXZJODB2Q29DMG4yUnNrS3BUNWdwNnlhaEJKWlFHOGpiMjFYY1pieWhnTmxO?=
 =?utf-8?B?bzMrMUF1UVNiQklYeWlTY1J0eDlLOEx4a1ZXZG9TenFaNXlqcWE2cFllOWxX?=
 =?utf-8?B?WFo2eHA0OXMzdy90ODNySWFFNTE1eGIwUStTRGp3dis3WHJ6V0JoVERIelli?=
 =?utf-8?B?VUpZZ2MrYTdJNXFsV1pFT2hXa3lVajNuS3l2aWNyNm1MZEtVR2duS2NTTmh1?=
 =?utf-8?B?emxDSjVUZmhsVDlnS1VzMlNHN3VFV2tPemRpYUYvaFZQV0JUR09QazNQbUhx?=
 =?utf-8?B?M3RHZWxDZjBHclNGRktOZzFrMEdSalQxVzB4ZUtiS2I3ZS9GNDRvdnFvTDFp?=
 =?utf-8?B?S00xVGdBTzFDb0xNVmM4c0lUTFdIV0hmak03SDZoY0JieTZqaDhHcEhpbkJj?=
 =?utf-8?B?WmxBS05GanRkTVpwVnNja01Wc1p4NjdTVnozeXAzNW5XcUd0clVmMWQwcWpI?=
 =?utf-8?B?aVVBS1AyU2Y1YnJmeHlhRVlhWTVrdHBxR1JlQU1OY2d6bnhWcWpDNGJLRmsz?=
 =?utf-8?B?cFVnMkMxd0RzcE54TFB5eElYQk4rL1Irb3gvNzBQMXVDK1JVTEJ0Ky9Sak9P?=
 =?utf-8?B?c1AwV3NiR3JQbzJHcS9YRHpqZUVndDd6T2czSWxBN0dEcVpzQTM1SVVRYVRW?=
 =?utf-8?B?K1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DF7462851D748146B27944CB7AB73C33@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH3PR02MB10280.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3871146a-2d1b-4da3-f0cb-08dd763b392a
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2025 01:18:09.0458
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1BBKc8mzxeWDLSAmOZxAS6kMwZTv5/BBSoxIGXvZdETomXM+p24xUk++9F9Q7VIQys1OFrurAbou/CkJIQmhQjNctPgTLH3H0vSSW0Aj44g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR02MB6538
X-Proofpoint-GUID: 11EzQ8vsKkCXW-Zjja8ja2ECnmUJQYH6
X-Authority-Analysis: v=2.4 cv=caHSrmDM c=1 sm=1 tr=0 ts=67f47953 cx=c_pps a=xM7ec0glCC7UZJxDhKPaNg==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=XR8D0OoHHMoA:10 a=0kUYKlekyDsA:10 a=20KFwNOVAAAA:8 a=64Cc0HZtAAAA:8 a=4-fm-dLL3VxK4OzCi2EA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 11EzQ8vsKkCXW-Zjja8ja2ECnmUJQYH6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-07_07,2025-04-07_01,2024-11-22_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gQXByIDYsIDIwMjUsIGF0IDc6MTTigK9QTSwgSmFzb24gV2FuZyA8amFzb3dhbmdA
cmVkaGF0LmNvbT4gd3JvdGU6DQo+IA0KPiAhLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLXwNCj4gIENBVVRJT046IEV4dGVy
bmFsIEVtYWlsDQo+IA0KPiB8LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSENCj4gDQo+IE9uIEZyaSwgQXByIDQsIDIwMjUg
YXQgMTA6MjTigK9QTSBKb24gS29obGVyIDxqb25AbnV0YW5peC5jb20+IHdyb3RlOg0KPj4gDQo+
PiBDb21taXQgMDk4ZWFkY2UzYzYyICgidmhvc3RfbmV0OiBkaXNhYmxlIHplcm9jb3B5IGJ5IGRl
ZmF1bHQiKSBkaXNhYmxlZA0KPj4gdGhlIG1vZHVsZSBwYXJhbWV0ZXIgZm9yIHRoZSBoYW5kbGVf
dHhfemVyb2NvcHkgcGF0aCBiYWNrIGluIDIwMTksDQo+PiBub3RoaW5nIHRoYXQgbWFueSBkb3du
c3RyZWFtIGRpc3RyaWJ1dGlvbnMgKGUuZy4sIFJIRUw3IGFuZCBsYXRlcikgaGFkDQo+PiBhbHJl
YWR5IGRvbmUgdGhlIHNhbWUuDQo+PiANCj4+IEJvdGggdXBzdHJlYW0gYW5kIGRvd25zdHJlYW0g
ZGlzYWJsZW1lbnQgc3VnZ2VzdCB0aGlzIHBhdGggaXMgcmFyZWx5DQo+PiB1c2VkLg0KPj4gDQo+
PiBUZXN0aW5nIHRoZSBtb2R1bGUgcGFyYW1ldGVyIHNob3dzIHRoYXQgd2hpbGUgdGhlIHBhdGgg
YWxsb3dzIHBhY2tldA0KPj4gZm9yd2FyZGluZywgdGhlIHplcm9jb3B5IGZ1bmN0aW9uYWxpdHkg
aXRzZWxmIGlzIGJyb2tlbi4gT24gb3V0Ym91bmQNCj4+IHRyYWZmaWMgKGd1ZXN0IFRYIC0+IGV4
dGVybmFsKSwgemVyb2NvcHkgU0tCcyBhcmUgb3JwaGFuZWQgYnkgZWl0aGVyDQo+PiBza2Jfb3Jw
aGFuX2ZyYWdzX3J4KCkgKHVzZWQgd2l0aCB0aGUgdHVuIGRyaXZlciB2aWEgdHVuX25ldF94bWl0
KCkpDQo+IA0KPiBUaGlzIGlzIGJ5IGRlc2lnbiB0byBhdm9pZCBET1MuDQoNCkkgdW5kZXJzdGFu
ZCB0aGF0LCBidXQgaXQgbWFrZXMgWkMgbm9uLWZ1bmN0aW9uYWwgaW4gZ2VuZXJhbCwgYXMgWkMg
ZmFpbHMNCmFuZCBpbW1lZGlhdGVseSBpbmNyZW1lbnRzIHRoZSBlcnJvciBjb3VudGVycy4NCg0K
PiANCj4+IG9yDQo+PiBza2Jfb3JwaGFuX2ZyYWdzKCkgZWxzZXdoZXJlIGluIHRoZSBzdGFjaywN
Cj4gDQo+IEJhc2ljYWxseSB6ZXJvY29weSBpcyBleHBlY3RlZCB0byB3b3JrIGZvciBndWVzdCAt
PiByZW1vdGUgY2FzZSwgc28NCj4gY291bGQgd2Ugc3RpbGwgaGl0IHNrYl9vcnBoYW5fZnJhZ3Mo
KSBpbiB0aGlzIGNhc2U/DQoNClllcywgeW914oCZZCBoaXQgdGhhdCBpbiB0dW5fbmV0X3htaXQo
KS4gSWYgeW91IHB1bmNoIGEgaG9sZSBpbiB0aGF0ICphbmQqIGluIHRoZQ0KemMgZXJyb3IgY291
bnRlciAoc3VjaCB0aGF0IGZhaWxlZCBaQyBkb2VzbuKAmXQgZGlzYWJsZSBaQyBpbiB2aG9zdCks
IHlvdSBnZXQgWkMNCmZyb20gdmhvc3Q7IGhvd2V2ZXIsIHRoZSBuZXR3b3JrIGludGVycnVwdCBo
YW5kbGVyIHVuZGVyIG5ldF90eF9hY3Rpb24gYW5kDQpldmVudHVhbGx5IGluY3VycyB0aGUgbWVt
Y3B5IHVuZGVyIGRldl9xdWV1ZV94bWl0X25pdCgpLg0KDQpUaGlzIGlzIG5vIG1vcmUgcGVyZm9y
bWFudCwgYW5kIGluIGZhY3QgaXMgYWN0dWFsbHkgd29yc2Ugc2luY2UgdGhlIHRpbWUgc3BlbnQN
CndhaXRpbmcgb24gdGhhdCBtZW1jcHkgdG8gcmVzb2x2ZSBpcyBsb25nZXIuDQoNCj4gDQo+PiBh
cyB2aG9zdF9uZXQgZG9lcyBub3Qgc2V0DQo+PiBTS0JGTF9ET05UX09SUEhBTi4NCj4+IA0KPj4g
T3JwaGFuaW5nIGVuZm9yY2VzIGEgbWVtY3B5IGFuZCB0cmlnZ2VycyB0aGUgY29tcGxldGlvbiBj
YWxsYmFjaywgd2hpY2gNCj4+IGluY3JlbWVudHMgdGhlIGZhaWxlZCBUWCBjb3VudGVyLCBlZmZl
Y3RpdmVseSBkaXNhYmxpbmcgemVyb2NvcHkgYWdhaW4uDQo+PiANCj4+IEV2ZW4gYWZ0ZXIgYWRk
cmVzc2luZyB0aGVzZSBpc3N1ZXMgdG8gcHJldmVudCBTS0Igb3JwaGFuaW5nIGFuZCBlcnJvcg0K
Pj4gY291bnRlciBpbmNyZW1lbnRzLCBwZXJmb3JtYW5jZSByZW1haW5zIHBvb3IuIEJ5IGRlZmF1
bHQsIG9ubHkgNjQNCj4+IG1lc3NhZ2VzIGNhbiBiZSB6ZXJvY29waWVkLCB3aGljaCBpcyBpbW1l
ZGlhdGVseSBleGhhdXN0ZWQgYnkgd29ya2xvYWRzDQo+PiBsaWtlIGlwZXJmLCByZXN1bHRpbmcg
aW4gbW9zdCBtZXNzYWdlcyBiZWluZyBtZW1jcHknZCBhbnlob3cuDQo+PiANCj4+IEFkZGl0aW9u
YWxseSwgbWVtY3B5J2QgbWVzc2FnZXMgZG8gbm90IGJlbmVmaXQgZnJvbSB0aGUgWERQIGJhdGNo
aW5nDQo+PiBvcHRpbWl6YXRpb25zIHByZXNlbnQgaW4gdGhlIGhhbmRsZV90eF9jb3B5IHBhdGgu
DQo+PiANCj4+IEdpdmVuIHRoZXNlIGxpbWl0YXRpb25zIGFuZCB0aGUgbGFjayBvZiBhbnkgdGFu
Z2libGUgYmVuZWZpdHMsIHJlbW92ZQ0KPj4gemVyb2NvcHkgZW50aXJlbHkgdG8gc2ltcGxpZnkg
dGhlIGNvZGUgYmFzZS4NCj4+IA0KPj4gU2lnbmVkLW9mZi1ieTogSm9uIEtvaGxlciA8am9uQG51
dGFuaXguY29tPg0KPiANCj4gQW55IGNoYW5jZSB3ZSBjYW4gZml4IHRob3NlIGlzc3Vlcz8gQWN0
dWFsbHksIHdlIGhhZCBhIHBsYW4gdG8gbWFrZQ0KPiB1c2Ugb2Ygdmhvc3QtbmV0IGFuZCBpdHMg
dHggemVyb2NvcHkgKG9yIGV2ZW4gaW1wbGVtZW50IHRoZSByeA0KPiB6ZXJvY29weSkgaW4gcGFz
dGEuDQoNCkhhcHB5IHRvIHRha2UgZGlyZWN0aW9uIGFuZCBpZGVhcyBoZXJlLCBidXQgSSBkb27i
gJl0IHNlZSBhIGNsZWFyIHdheSB0byBmaXggdGhlc2UNCmlzc3Vlcywgd2l0aG91dCBkZWFsaW5n
IHdpdGggdGhlIGFzc2VydGlvbnMgdGhhdCBza2Jfb3JwaGFuX2ZyYWdzX3J4IGNhbGxzIG91dC4N
Cg0KU2FpZCBhbm90aGVyIHdheSwgSeKAmWQgYmUgaW50ZXJlc3RlZCBpbiBoZWFyaW5nIGlmIHRo
ZXJlIGlzIGEgY29uZmlnIHdoZXJlIFpDIGluDQpjdXJyZW50IGhvc3QtbmV0IGltcGxlbWVudGF0
aW9uIHdvcmtzLCBhcyBJIHdhcyBkcml2aW5nIG15c2VsZiBjcmF6eSB0cnlpbmcgdG8NCnJldmVy
c2UgZW5naW5lZXIuDQoNCkhhcHB5IHRvIGNvbGxhYm9yYXRlIGlmIHRoZXJlIGlzIHNvbWV0aGlu
ZyB3ZSBjb3VsZCBkbyBoZXJlLg0KDQo+IA0KPiBFdWdlbmlvIG1heSBleHBsYWluIG1vcmUgaGVy
ZS4NCj4gDQo+IFRoYW5rcw0KPiANCg0K

