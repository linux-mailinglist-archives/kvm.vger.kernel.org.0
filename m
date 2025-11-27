Return-Path: <kvm+bounces-64820-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D31A0C8CB44
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 03:59:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A6923B45E3
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 02:59:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59C9229BDA3;
	Thu, 27 Nov 2025 02:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="su6aYbG3";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="Vqne071/"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F4D29D266;
	Thu, 27 Nov 2025 02:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764212367; cv=fail; b=MHcSpf0LHSeDTbygzmBoAqP+HKRadR8z3YQuxTotu5itugE0q5LaUKNr+3NhN/ccajE3HJOTWWkAZNfMlnmTjuokmNizHi0d2lFQPCqht66Z0xqSfm4nVro40+izTV2dvHZdRZvQYGw18nmffy3s+QFUmQKIVxLNLYjkr4kHg8A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764212367; c=relaxed/simple;
	bh=HCe68LddHejycehFUGtDZfFoQGKwzycGUYROfuuROjQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Wr2+rSYOqt6a+NhYj3mc9/6KD8VOYkaal2DEKlkfBsW+dK4nty65bKJVordj5jTRY18GhZdcMskVwCMr8A0rKF0VhyQORt6iy8i3ILIzXYNAsLtWSK0+VNl1bwUm2Y02KgvOTqv7MOQM1OM3vfQckyvMhax1/vbIoxM1iKs41Qw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=su6aYbG3; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=Vqne071/; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AR2ANtV1765051;
	Wed, 26 Nov 2025 18:58:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=HCe68LddHejycehFUGtDZfFoQGKwzycGUYROfuuRO
	jQ=; b=su6aYbG3ONU1ouSswkLE4+8QFloOcau9LfPRH+6LeAFAPoYb5f/5ma4K5
	izoU6GWCoPb6TSH54KV3N9Bo6rQC9RRbz0jf4QMvPepr/e81VJR0O7V2QD03TyPl
	DPeMGZ08G39IGnAbqBiz3Xp14RmTyLd8/jEsRqstCcv8cCNQ28YXaKOkRE3dHWDB
	yyj5hynQHmrL1QeJ10Nb3OT8nvUqbAyiy5F4X4LwjJKmliTLso71rE9DZUvclvTF
	E7zM55IUqy+t9Gkp4gVSMs5iP21O3NclDQfkAiTj1toclCWX3hjmENVEDkZasqag
	2KB79/PEhHY0zLAd+QFFBcCfHheNA==
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11022108.outbound.protection.outlook.com [52.101.48.108])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4ap206he5x-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 26 Nov 2025 18:58:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CFQMpF8iMywcMeIWEJRUvo1rl7Wt0RF/1MKCPmU4eGrhGA65/6HxDaKuno/Frz6JmujnurevJQL2c0dauFpxP5q59nRQsWbSBcxv98uNMn65tvJ0jxt5WSASu4rXuocX7IQTi9RCiZzdGttQI2QHKD3QgJKsiIO2NnQg1xtak2cBi3tLX9LQRt2XY3+q0+/eN4Sj6mILkIHxf3Q4f42TZXIydXwkCRCSHsQgzvlVIq1cuV1OrUso/4pk1gpfmjcBF6/rBTU83V9Sdwc+XHZ0qzY5RFVPcgQRU7zvsUn/irOv00DxalZfsoPuknsyYHMRzrS2wugBZhLvzG4JJHqmCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HCe68LddHejycehFUGtDZfFoQGKwzycGUYROfuuROjQ=;
 b=KXHu16Vrc72lPYCIQeEPHgfUwTIRR5sSEpgfy8t2JcbRHbLp/vo7T2jYd2QdnYaY8krffk1tqDYlD+m7uuhxQZjC+20KvPHmU4bH5iRiaCCLGLomnUWHgcufshJtlftQLSDZPJRAYTULedEbsBKYKZ/Uhp+uduCA/Dia3gAvYLE5+G1kHak0NquEC6+JUR8SZ0VIvKGAJ93YoK2LH7UmcBsdIFNE+yIfnq2RNW5Caiq/ypxlQGrew1Giu3V02862nayAZBlL4v/EVNkM08duRmxPF3SjJTNf0/3vyOGFK+BVMFfrfPN9mMYP+WrSE4exKc0AGE+nVIAL5lgLXNbdHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HCe68LddHejycehFUGtDZfFoQGKwzycGUYROfuuROjQ=;
 b=Vqne071//3npr1KalZrHAp5tYKTK+yRtpOG+6SeT/165WNGsyENecZb7X2cwou8MM6bmBd0wd1zM3V/liuctnqN4g0zbFxOU3yPCKv8KBUIyWwPngsAWFEXGWYOKTz4f6n6tRHecHeDYyQXFfxU6ekTnf6dt8p2mM9eDwCnVEZTiJ90cFiaJY/RIYWcze/IDQPMOZqsksMsg6kqiivzKm0/wMyUe0ubc8AD2i2uicOoZ5I36sl25ut5zjiEQqkXzeDG+VTC/imHWR8A/gpE2JELlk/TfFtXXkXlPkT4oODxPGBLneXXNbOcsiP/FsfmIYFM664EV0s373kTEHUBn/w==
Received: from DS0PR02MB11138.namprd02.prod.outlook.com (2603:10b6:8:2f7::17)
 by SJ0PR02MB8751.namprd02.prod.outlook.com (2603:10b6:a03:3d5::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.14; Thu, 27 Nov
 2025 02:58:48 +0000
Received: from DS0PR02MB11138.namprd02.prod.outlook.com
 ([fe80::b514:ca81:3eec:5b97]) by DS0PR02MB11138.namprd02.prod.outlook.com
 ([fe80::b514:ca81:3eec:5b97%6]) with mapi id 15.20.9366.009; Thu, 27 Nov 2025
 02:58:48 +0000
From: Jon Kohler <jon@nutanix.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Arnd Bergmann <arnd@arndb.de>, Jason Wang <jasowang@redhat.com>,
        "Michael
 S. Tsirkin" <mst@redhat.com>,
        =?utf-8?B?RXVnZW5pbyBQw6lyZXo=?=
	<eperezma@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
        Netdev
	<netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Sean
 Christopherson <seanjc@google.com>,
        "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Krzysztof Kozlowski <krzk@kernel.org>,
        Alexandre Belloni
	<alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Drew Fustini <fustini@kernel.org>
Subject: Re: [PATCH net-next] vhost: use "checked" versions of get_user() and
 put_user()
Thread-Topic: [PATCH net-next] vhost: use "checked" versions of get_user() and
 put_user()
Thread-Index:
 AQHcVDJryQXjlObInEG9J4YkYYZKUbTvzAyAgAJ4RQCABAmigIAA2pWAgAOxCQCACQYXAIAArPaAgABI5gCAAJ0GAIAAAzkAgAAdBoCAAADbgIAAV2wA
Date: Thu, 27 Nov 2025 02:58:48 +0000
Message-ID: <76DE60E2-4A83-4BA0-B8EF-C8AE536F823D@nutanix.com>
References: <20251113005529.2494066-1-jon@nutanix.com>
 <CACGkMEtQZ3M-sERT2P8WV=82BuXCbBHeJX+zgxx+9X7OUTqi4g@mail.gmail.com>
 <E1226897-C6D1-439C-AB3B-012F8C4A72DF@nutanix.com>
 <CACGkMEuPK4=Tf3x-k0ZHY1rqL=2rg60-qdON8UJmQZTqpUryTQ@mail.gmail.com>
 <A0AFD371-1FA3-48F7-A259-6503A6F052E5@nutanix.com>
 <CACGkMEvD16y2rt+cXupZ-aEcPZ=nvU7+xYSYBkUj7tH=ER3f-A@mail.gmail.com>
 <121ABD73-9400-4657-997C-6AEA578864C5@nutanix.com>
 <CACGkMEtk7veKToaJO9rwo7UeJkN+reaoG9_XcPG-dKAho1dV+A@mail.gmail.com>
 <61102cff-bb35-4fe4-af61-9fc31e3c65e0@app.fastmail.com>
 <02B0FDF1-41D4-4A7D-A57E-089D2B69CEF2@nutanix.com>
 <32530984-cbaa-49e8-9c1e-34f04271538d@app.fastmail.com>
 <0D4EA459-C3E5-4557-97EB-17ABB4F817E5@nutanix.com>
 <CAHk-=wiEg3yO5znyPD+soCkVi_emP=wHrRZk2sv4VS768S3a2g@mail.gmail.com>
In-Reply-To:
 <CAHk-=wiEg3yO5znyPD+soCkVi_emP=wHrRZk2sv4VS768S3a2g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.700.81)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR02MB11138:EE_|SJ0PR02MB8751:EE_
x-ms-office365-filtering-correlation-id: 0b73e590-b9b9-456f-a1d3-08de2d60e33e
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|1800799024|7416014|376014|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?VEg2SjlFZnFlZjcwWks3SXVsMUh2U0ZoeHY4L3JjVndRSVJmTWVlV1RsTG5M?=
 =?utf-8?B?dCsyRGZBaTFYUHhMejVlTFFCU2ZoSFpkOUxyaHpNcWtLYnV2eSszS3VwZFRi?=
 =?utf-8?B?bVpDU1l4ZnFlamU2WXdJVnEwYk9ibWc3bUplTTlub2VrdDc2VCtJTEg0LzRM?=
 =?utf-8?B?N2haWDVaVjhkVjJWZDhlZzdWY0RsVHhGaGpKbTBhcUpYTjh3aXFXTHYyL0ky?=
 =?utf-8?B?R1cxczNmUVgrTEk3SU55dmxJNldVNG8reExNYXVXbkZ2cE9Vd1dhdkV3bG9Q?=
 =?utf-8?B?RVQ3SlRVL1VmN2llbHdjeDdta0tEWTFKQVdnSUgvSlFJWEJLMTNOaGJlRmN4?=
 =?utf-8?B?Wk9EbG8zUjZSZ0MzUlErajFVUE5RcWlwa3MvUXpaQjduOEdCVU1yNFJ6U3Vx?=
 =?utf-8?B?TldOdzZGcWl4ZEJocXoxTDl0Qmt1UnRBTmpwUksvakVQYU13bEU3MGYxL2VZ?=
 =?utf-8?B?R0N4OFlzMXVta2xMdnJXaXRrN3pWQXN1SzJwZjltYWQ1eGhla2hxWE9KVFFt?=
 =?utf-8?B?eWpKR1gzUmlqajBaSHd3MytuNkgwNTdFMy9GVGZJN2gzQ0ZWT2RRVk5JNEUv?=
 =?utf-8?B?a0RYSWpyZGhyV0lYQXl1UW5BdWdaZ05HUlRhMHVjT2hjeDJQQ1VWczB2Snp6?=
 =?utf-8?B?ai8zZExQaFdJWHlDdUxtdC85TitMN1gxZDVYekgrRE1nQkFuQmZZdHIyK3Jq?=
 =?utf-8?B?OVFYUEI5ckxMS2EzWHRHN2c3QVkzbllndHNDNmN6djV1MlJ3aENyMzB6eWdW?=
 =?utf-8?B?RndqN1N6V2dSa3J1QTJtRm43eFZSUk5rdDMyL3g0UkFhbDhkWlFDRTQ3UCs3?=
 =?utf-8?B?Z21nZVEyam1MekwzSWJLelZ2bmNsN1g5cWhmKzBMU040akVrNUhYclIrOVBZ?=
 =?utf-8?B?d1BnMzd6bGZ4bFhmUEMyZnFySjB1czlGbzk4T0FvcXlnaW9RejhPWUUrQjBC?=
 =?utf-8?B?YndtSmFxSmNiYUNmeVJWOXpub2t5SXJVcnd4SWtIQlVuNWZadnJYNmVtcTFV?=
 =?utf-8?B?azJwY2h6dFJtb1luRlhoV0l0ZGxXeHFaZ1Y0ME9JSnJ1YzhLNnRRdHZwZVAr?=
 =?utf-8?B?YkFsV2dLNEUzZGFjZTZ4a1cxTXEybnlHdFdtWjJTT0VrTUtoNXRCektwUFBo?=
 =?utf-8?B?TGQzNjhCWGdkSGpydU4xNG1zdWtYSTczSmRNWk1NR2U1THlqRk1uRlJ3QTVx?=
 =?utf-8?B?bEltT292RG52VkVhOVRKbmNQNUxCeE9VYllXaitEN0N4WkduRllFMDlHOHlG?=
 =?utf-8?B?WXVnMWVFQkFyaS9oTzhKQ25XVXNJY0FDdkc1VHFncjJ1RXJMUDdELzRmSFVP?=
 =?utf-8?B?RVdwTVBOa0FpeHBNcHNJWmtqQStwVVBFS0RtTzhHM1BCRE8yYjZqVUdzdGxX?=
 =?utf-8?B?NDN5K0FVUW9YUTk2QlJFc1k0YlJxU2pUcmV4RWg5Vkh0cllUMnFSUkt6V3lG?=
 =?utf-8?B?Q2ZCWjZpNzlCclU1Y3VXdzZQUGJyTk0yQldESlZzZ0lyNUhLMDFXaUczWFVO?=
 =?utf-8?B?dGQ5QVE1cno2UDdHSURzNllpR3AvYWVKV2IzeStYR1MrYW1CQWRHY1o4eC8w?=
 =?utf-8?B?Y1FWN3ZxMGY3eXFINE5xd2tvL0l2aUtnVDJZbzAwYnEwU0xURTZFU3BOY0RO?=
 =?utf-8?B?M3BML09VRzlhajNyR3FZQ0pqNzB6MHJPWlhvaTQ5RUZqdDlHUFJwRVRCVzU2?=
 =?utf-8?B?WjhscWNCQk05M0NmMEZuVmg4SXk1cjU3Q29VaUNhdjRXTFg0ZUE2eXRCMUpk?=
 =?utf-8?B?aldET2tXb2pJYmdObVoyZENnbjQ4dFoySWtJemhmMFRjOWJabGVaQTlBZ3Vy?=
 =?utf-8?B?SWlJNGdYbElhMmM4QlRkaHlGNTRya0N5NTNhUWt0QkRKZzlFYVdRNzhiWGxm?=
 =?utf-8?B?dHRNRzE4aTdtWkpPSUJScjRremQyTmRaL1dRUUpLalpWNjNtNlh0Q0pFMkVJ?=
 =?utf-8?B?WXRHRFRCamZhYnAzWkNWajhTSkZ5b0NrNCtjS2FxeDRVekZ3TU9WSWo4NC9I?=
 =?utf-8?B?a0c1dHRNUFhEakdpa0V1WXdSaXBycUg4TVNOQWt6ZjR4N1Fab1VSV1FJMkxK?=
 =?utf-8?Q?1WqtLi?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR02MB11138.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(7416014)(376014)(366016)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bWd6MHdINm45cDNYU2l4eTV0MU82dXlodUNYRmdxdWdUTkJjYXI2enJYU2FO?=
 =?utf-8?B?RjdtNnBWdHc5V0ZscmhwOTdidnNxeWd1Um8vZ3UvNjhneSs1bm5JWGwxSyth?=
 =?utf-8?B?dGhndzlkM3kwOHVVbmtGbFlldkQvMkQzQjQzRDBySmkySi9Pc1lHWnBJS2My?=
 =?utf-8?B?YXJJRnFuUlI1cktRUUZhSVNrcWRJeUt4ckZVdkd4SVVpNk12Q3JIOU81VVZr?=
 =?utf-8?B?Z1pCNEJqVWEwSFBTcDhlOXNnbjkwSnlIVlVaM1pONmtDbG5Qd0JZbUthN0RW?=
 =?utf-8?B?M3MwWWl4V0VLTUpiZ29jUWpXbkpGMGdKL2RESnBRMDgxeHREOUZOZjd1enE2?=
 =?utf-8?B?QVBtS2toTWZ6U3V6SFhZL1A4dTdRVjkzb1YxME9vS0FhN0M3R0pWVzF5Q09D?=
 =?utf-8?B?ZE0zQ2hjOUtDeTZkREpDTmY0cVV5UC82WGs5MXNrNW85SlhEd3U5VnowV3ly?=
 =?utf-8?B?akZLaXFqRWtiWEZaQm1YTFU3OGVLT1pFWHcxNXVoZW43WWFtZFhUVGlFcE1j?=
 =?utf-8?B?d2RzZ3ljVmRPUHNrMWhmYVZ0aWpETVBGclZJV1krTzF5TVZ1Y1NsQ2dnaTho?=
 =?utf-8?B?anNHVjJHTUJGeFhMQ0Y3Mnp4YXZBQ2Y1N0NoMmJGNVowQ0VDMjN5TUNuM1NR?=
 =?utf-8?B?QnYwajdOT3UydVlyY2RHVUduTGFxT3VnWGRJL3JTVlRQRlIvQU9HRnF4K1NQ?=
 =?utf-8?B?WFRHUW5pSFYyN0taaVAzdU9IOGdEdjgrVEp0dE5JbjZZUHMyUEk2aTg0U1hr?=
 =?utf-8?B?Zi9Jcm1oTVZzS1kycXNTeG5mVEpCMFFIM2JaSEREek5lbFROV3I4d2FnZWo0?=
 =?utf-8?B?VVRhRHJab1JkSWZPMTBtOFU5WUV0UG1DSTRPcmNwOENIRWtDWHdqUEZnR1ll?=
 =?utf-8?B?a21pSTd0SmU4SVd6QVA5YkFDcVNmZnk5QytVWXVXTm9GRFpMSEJsRTY4S1Fk?=
 =?utf-8?B?aTlkZGJ6YXlCTVJCMSt6Ym5QUVdqRGdYdG40QkxacnVMNFRWMFRFTnN5WDNX?=
 =?utf-8?B?TG9hSHlBMmdNRXhCVlNWV3JPZ2RnN09lVS9jaUkza2tDanpHS3p0V2RxcDJ1?=
 =?utf-8?B?Mm5iaGZFQlJ0R3M1VUhXbTkyQnNZZ1FtM1NEaHcvSStpYTQ1dlArV2tid08r?=
 =?utf-8?B?TEVFNDFkTTJUODdidC9iaVFNWFBCNGMwVXhOUGR1TUszRkJWQUZuYUYyWTdo?=
 =?utf-8?B?T0wxREc0bjZiRnFZaTgwVmJ1dmhkZmxYM2VYZVBiTjJZNlArNFVGOXhKcUtE?=
 =?utf-8?B?d2JYazlKMnY3OHhoYnlDZFZMZEgreTR0eHdtakR0MjlmR0h4RzhtYkNOd0VP?=
 =?utf-8?B?S05hK1pXNEZFeitIZ1V5eUpDMkRNdm5PT21McjRHTE9teUZicVlRT205d3VX?=
 =?utf-8?B?ZUVsZGdyVkF4TUNmUXlwaXJmMVhYMG9ZU2JpQWowazVVQ3JLWUtqNDZEYW1P?=
 =?utf-8?B?bGlJNzR1SlFEbGtjL2I2T05ndWh4MlV5QTVCTTZtR2RzZFhrOU84MkpxL0VS?=
 =?utf-8?B?TWQyVGNFVGVXWmFoam5wK29rUEtDMjViTUg2YmhDQkRQOGRPMGZwNzY4WHYw?=
 =?utf-8?B?NEplUGM5alJ5bjErQWxJaTJtdTNhUTZwd01PR01UM0M4MDRZN09xcjhveSto?=
 =?utf-8?B?eDZkd0RNbU1mVXNtd1FuZUhqdTArdG9DTXQvN3NlWXR1TzlRWlM1ZkxheUJC?=
 =?utf-8?B?RXRqNkxRY0ZNY0tUZlBwRDNJclF5NzNPMXRDMXlEWjZLbDBDKzZzQTdmTVV6?=
 =?utf-8?B?VzNYVmNNRDRHcTMrd2EvaHdJRUZrU2lBdEdUNjFmODBma0VyVm5SdXFTTFA5?=
 =?utf-8?B?QkRrR3BwL0k2cDk1d2Y4STFzcUVuM3R2SURLamlPdzRkWXJxeTRJOWFPVTF3?=
 =?utf-8?B?THhheFNQSFFHTnNTWjFhOFIxTXUzb0pxRDl3TGRpZUJWNkdpRFNtQmNHQ0cv?=
 =?utf-8?B?UThBNXFXT00zMCtCUldHS2huUEtsMDkvU2x4N1RtcmZQMkxEWi8xbjhBb2Js?=
 =?utf-8?B?L1lzelhwUzh0VFkrRDRtWWZ5TnhVQW5jTmN5YjJhTFYvRkxQMjZmVkc3YlJV?=
 =?utf-8?B?RVhkZzdUZVNiL3BRaTZ4bE85VThQampDaVRyd1c4N3BhTUloMHV3dndBSGtW?=
 =?utf-8?B?R3JHdG5pY2RIOUVhWko0ejNLRktSQXdoZWFZVmhBWENpVUZxZ2xXV1c1Y240?=
 =?utf-8?B?bXBZaHc1dG1PVXpjaFFCdllQVjRpVUw4OTYwQmxVbmlERENxSVpNa1FRWi9B?=
 =?utf-8?B?eityYVdQTTZiQ25QS2hncnR5YTFnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <61DE2312D89FEC42A18616842B882F64@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR02MB11138.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b73e590-b9b9-456f-a1d3-08de2d60e33e
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Nov 2025 02:58:48.5744
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HXxrGwlKjCbeHOQOlov6JebLcC786O8iTuBGt/hsOZNUvVUnuGG/X4DvNzt9UU9NIM8S7791li13NCy4NcBeuvpuHwkRj8PDLLBLSVkDmog=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR02MB8751
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI3MDAyMiBTYWx0ZWRfX3FcZjcyrBDqJ
 XRueTCOpkF+Ujw7JTGVlsU8QgY8BnoRBVq0RpTnqJ2qu3/nFP5fhQ6fU6OIAk+f5lyI9TB88siH
 SKklHDEiWgIBLxIxO/cuWSmUmw0Tk1NGmGipBxkx5Q27//AKP8h59Byyd9qNKgIFAZ4BkNt4zEQ
 mDxnlWOf48yZhP8AcjYXQ/yr9w/9YPDg70SGvTsgNdsBwF2BJT3Xh2YBHnmrRZ5tGq/z+QH76Ak
 XhV7blrT1olWgPsujqQfFHFAVdfl1AZ8Tb+h6pvroABl031sTtZ4Fg64ZAmcaubhIIkvU+iaJIJ
 5X5h6kJeB9iOCOMN71faHkzKBoTX2KibTWxAsvcwWIhTdWX3fNDN9E1XZowUUqkdpRSqwGjmC6X
 JY0lGCx9AmdalqyAMU49Q6ZpW0QRlw==
X-Proofpoint-GUID: ZaEV3RpLcJPWRM_rHOzbqpnX1UDvWuHp
X-Proofpoint-ORIG-GUID: ZaEV3RpLcJPWRM_rHOzbqpnX1UDvWuHp
X-Authority-Analysis: v=2.4 cv=OaSVzxTY c=1 sm=1 tr=0 ts=6927be6d cx=c_pps
 a=0vs9Akrd78aydvmXS5/lXw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Z4Rwk6OoAAAA:8 a=64Cc0HZtAAAA:8 a=DlFrHOek14SDfmokfNsA:9 a=QEXdDO2ut3YA:10
 a=HkZW87K1Qel5hWWM3VKY:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-26_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gTm92IDI2LCAyMDI1LCBhdCA0OjQ14oCvUE0sIExpbnVzIFRvcnZhbGRzIDx0b3J2
YWxkc0BsaW51eC1mb3VuZGF0aW9uLm9yZz4gd3JvdGU6DQo+IA0KPiBPbiBXZWQsIDI2IE5vdiAy
MDI1IGF0IDEzOjQzLCBKb24gS29obGVyIDxqb25AbnV0YW5peC5jb20+IHdyb3RlOg0KPj4gDQo+
PiBMaW51cyBtZW50aW9uZWQgaGUgbWlnaHQgZ2V0IGludG8gdGhlIG1peCBhbmQgZG8gYSBidWxr
DQo+PiBjaGFuZ2UgYW5kIGtpbGwgdGhlIHdob2xlIHRoaW5nIG9uY2UgYW5kIGZvciBhbGwsIHNv
IEnigJltDQo+PiBzaW1wbHkgdHJ5aW5nIHRvIGhlbHAga25vY2sgYW4gaW5jcmVtZW50YWwgYW1v
dW50IG9mIHdvcmsNCj4+IG9mZiB0aGUgcGlsZSBpbiBhZHZhbmNlIG9mIHRoYXQgKGFuZCByZWFw
IHNvbWUgcGVyZm9ybWFuY2UNCj4+IGJlbmVmaXRzIGF0IHRoZSBzYW1lIHRpbWUsIGF0IGxlYXN0
IG9uIHRoZSB4ODYgc2lkZSkuDQo+IA0KPiBTbyBJJ20gZGVmaW5pdGVseSBnb2luZyB0byBkbyBz
b21lIGJ1bGsgY29udmVyc2lvbiBhdCBzb21lIHBvaW50LCBidXQNCj4gaG9uZXN0bHksIEknbGwg
YmUgYSBsb3QgaGFwcGllciBpZiBtb3N0IHVzZXJzIGFscmVhZHkgc2VsZi1jb252ZXJ0ZWQNCj4g
YmVmb3JlIHRoYXQsIGFuZCBJIG9ubHkgZW5kIHVwIGRvaW5nIGEgImNvbnZlcnQgdW5tYWludGFp
bmVkIG9sZCBjb2RlDQo+IHRoYXQgbm9ib2R5IHJlYWxseSBjYXJlcyBhYm91dCIuDQo+IA0KPiAg
ICAgICAgICAgICAgICAgIExpbnVzDQoNClRoYXQgaXMgZmFpciwgdGhhbmtzIExpbnVzLiBJ4oCZ
bGwgc2VlIGlmIEkgY2FuIHBpY2sgb2ZmIGEgY291cGxlDQptb3JlIHRvIHN0YXJ0IHRoaW5uaW5n
IG91dCB0aGUgcGlsZSwgYW5kIHNlZSB3aGF0IHNvcnQgb2YgdHJvdWJsZQ0KSSBjYW4gZ2V0IGlu
dG8uDQoNCkNoZWVycyAtIEpvbg==

