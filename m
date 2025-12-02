Return-Path: <kvm+bounces-65158-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EBB3C9C4EE
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 17:57:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 9043334A0A7
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 16:57:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B775F2C08BF;
	Tue,  2 Dec 2025 16:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="kcngetHv";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="fiqUVtvH"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F0752BDC2A;
	Tue,  2 Dec 2025 16:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764694525; cv=fail; b=pFJfJn+KSl29bgRcOIX2jYOZ2JAbgrtr55LuhH140yrEbjg6P+WWeD8fDCxkAxOkOLFugIE4SMH3A/EbTPzlIs1rhs94hKMPtu+L4kA2eSZEjfzROQMhr0k2aX5NofUbs+EVC20Fb7R+zHOxD2A0mjJyJmWFcS6P18MJnKc4gF4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764694525; c=relaxed/simple;
	bh=U4WcMjVTNTcUH8xu2OLMuYnoO0Y5U9WDlodYHSEZoxc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hBmeo5lxcplLdFHzu+xfcIcJi4ZrEcPf+he4uRAsMFfNEYs7qPK556YuZFmpFMGgrlzSgY/FqfC16e7vLXGEcw3alJO2OSC4ggIyjhiaq3oAU+F1sP/wnf70iTsfA3nSZK4/WCPykByJ6JGs4QsNhivu1azjeoxSaSCzkVlyVgs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=kcngetHv; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=fiqUVtvH; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B2E7pCi1715418;
	Tue, 2 Dec 2025 08:54:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=U4WcMjVTNTcUH8xu2OLMuYnoO0Y5U9WDlodYHSEZo
	xc=; b=kcngetHv4Xkp33PrHbE5j/CXtQqV95cBtafOinZ5RQqgJpKwieCcxlgfH
	1TLyQgBsdgSbxxwtrSYjIzExN457Bsori7GobhaQYrgrKvrWTQmWhoZ4P50liZJ4
	lppUS+jXC3AgodMzU4+qbkvwSTvWGc5QcYdXeHAfBeTuXoUKvnLEJxUMb8Ex9nzz
	SV9KFHbiDCtdq/Rras9d4k7nVB8kxLxI3/A2qx26wqHgLTSGUibjNFAbz0pgm8Zg
	X/MXBz8+CbaRi0PEZarfTHqWClbb5I2uwJVXP4NoJmvGm6wvYQiZfVqtx5W9MD9r
	GlfnA8Kkr3VO/W7gaXFqs0AdLJxuA==
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11022134.outbound.protection.outlook.com [52.101.43.134])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4asrrxsjxj-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 02 Dec 2025 08:54:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jkdQT33Mf3WqXFtDTY+gBLJ1QYw1Sg98ISrPz+9IKc5Gpe6QSk4DLBfNC00CvJGlU0Aimycal84hW8xwTw7Msm6a81TlzkqUYxzE7/7WSWv6dxyoORN4coD6OmoARKMaKm24na3hB56BetmVhSZYD9HjHKwjBgIcjkpkvttAdbvrEWYlsJmAYwvV7m3WMC1uH+DZETqX3qvMMNCCH+iZLfu61Ejh0LKsoV+NuYYiAIPXUJhVcjlhKC0rmtkq373HHwj35UyDBmCWnX1Q03qPH6KIY4FRFwT2HEiv0Lvor/3LEUjdH3ICia0iw4tD2WBgokNIanJ0+1j185DroIvmFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U4WcMjVTNTcUH8xu2OLMuYnoO0Y5U9WDlodYHSEZoxc=;
 b=GRkNRzWrN67EEW9mS3r8RYhO/uSfsKzVr7cayIEly4np1aswYvvjmSHv7SSMj1r7UkGM6dW6/fSh0l9sHUqNcru4TazFvnIE9kRiLg00cFCqhUMRKXQ+B0dgIa+SJPriiVjjX8GWbIO2+ip1pNhcbIwj8cvdxS1r80iU4nxlRDmJ0kEsqpnv8P2Z0TrQOduj3rsd/VxJJas6iYBDes73msdVzFZR+PfTM+wgwzNUXTcdRwfCErSQnTCdqwTbsntD3v08hR6EYgUzL0aDZlNJq0QJfMz/IApIre/Ir7hciUro1MgvMnFZNU6gtpddf9c9DJ4rIZ/YvDLiJg/bsY+odQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U4WcMjVTNTcUH8xu2OLMuYnoO0Y5U9WDlodYHSEZoxc=;
 b=fiqUVtvHBCxmUWK7DzFHGB/3ORr834Pqs1fslNGgaKIJxN1T4PnGqEfqy9Doz3qcK+dqoVLD6SDwDOwTQYwHk/nywfA0cD3CRThnpioshQ5jCiQB2/VdgIeQvwpgS2b+ebHno/1+IGMl3CkfFxRL2WOGg1Ya5+XWKfB5EwaAkU2E88Zc3A2rWaxrg5MapE5vqf6gVkB90W/aSNWd5jnk4tU3SzNZwkopHVLFRphjWMwVb1mOsADA8w7AoJWjWjK5rhIsNF0DWwtkiSr3ad7ky3WfJoGWQALdoPDtWKz1FP4fuATa6YtTPPrtJE8Dtyusf7dX1yXpgfpQK4zpG/ZW6g==
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18) by SJ2PR02MB9895.namprd02.prod.outlook.com
 (2603:10b6:a03:546::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.9; Tue, 2 Dec
 2025 16:54:44 +0000
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc]) by LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc%4]) with mapi id 15.20.9366.012; Tue, 2 Dec 2025
 16:54:44 +0000
From: Jon Kohler <jon@nutanix.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Jason Wang <jasowang@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        =?utf-8?B?RXVnZW5pbyBQw6lyZXo=?= <eperezma@redhat.com>,
        "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>,
        "virtualization@lists.linux.dev"
	<virtualization@lists.linux.dev>,
        Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds
	<torvalds@linux-foundation.org>,
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
 AQHcVDJryQXjlObInEG9J4YkYYZKUbTvzAyAgAJ4RQCABAmigIAA2pWAgAOxCQCACQYXAIAArPaAgABI5gCAAJ0GAIAAWd6AgAAiVICAADg2AIAIiVQA
Date: Tue, 2 Dec 2025 16:54:44 +0000
Message-ID: <6AD6B7D8-6368-45ED-B7EB-484F25D13BE6@nutanix.com>
References: <E1226897-C6D1-439C-AB3B-012F8C4A72DF@nutanix.com>
 <CACGkMEuPK4=Tf3x-k0ZHY1rqL=2rg60-qdON8UJmQZTqpUryTQ@mail.gmail.com>
 <A0AFD371-1FA3-48F7-A259-6503A6F052E5@nutanix.com>
 <CACGkMEvD16y2rt+cXupZ-aEcPZ=nvU7+xYSYBkUj7tH=ER3f-A@mail.gmail.com>
 <121ABD73-9400-4657-997C-6AEA578864C5@nutanix.com>
 <CACGkMEtk7veKToaJO9rwo7UeJkN+reaoG9_XcPG-dKAho1dV+A@mail.gmail.com>
 <61102cff-bb35-4fe4-af61-9fc31e3c65e0@app.fastmail.com>
 <02B0FDF1-41D4-4A7D-A57E-089D2B69CEF2@nutanix.com>
 <CACGkMEshKS84YBuqyEzYuuWJqUwGML4N+5Ev6owbiPHvogO=3Q@mail.gmail.com>
 <5EB2ED95-0BA3-4E71-8887-2FCAF002577C@nutanix.com>
 <20251127013146-mutt-send-email-mst@kernel.org>
In-Reply-To: <20251127013146-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.700.81)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV0PR02MB11133:EE_|SJ2PR02MB9895:EE_
x-ms-office365-filtering-correlation-id: 44a75e21-6618-4790-cd53-08de31c37eab
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024|10070799003|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?WXk4SGF6MGgycVRweWRVN1hpcGZFbmpEcVpTeU43aFYyMXVJK0UzUEFWK1NH?=
 =?utf-8?B?UnpXRWNPRlVYTTE3OEpTdXN3aC9EcExOMEMvR2Rrcms0blRCVThjdmYvdkp1?=
 =?utf-8?B?SGsyTGJ5cWtobHh0eTVEb05GOE5Hb0JwVlZlcVhqSWorOTNtei9STHp1QnZo?=
 =?utf-8?B?RVBNY0JzaUdyejNzN3JVVkZ6SjBwb3BDMlRwenY3Ujh6eEcwT2YwNUxTWlc3?=
 =?utf-8?B?NFdSaGlqM21vY3lRMzV0K2pLalQybEhmWUc4YkhLVFJ3MnFneDMySlhEeVgy?=
 =?utf-8?B?d3ovL2w2Y0x4YjB3bFJLZlJuUjA0VTBJZkxmRklZVnVQbWxDTlcyMk85OUc4?=
 =?utf-8?B?MkJscmRORjNWaHB0eXhXZ2x2S2kwaVljenJSN0ZIZzhicFJBZk9nL2xpVG1V?=
 =?utf-8?B?cG0zTEdWWlQ1WmdrdWViNWVMMGpMQ3FTV0t5dmdJbkdhVTZTUjN6VzNzOU1E?=
 =?utf-8?B?aWV5Y0hQQ2d0SXV2KzVrNVRBTGdhTGVFZGVFVmpnY21pTmh5VEpTMjFIYnBs?=
 =?utf-8?B?VENTODh6S1dtamdxU1NBbnV2bHZGd2xwcXZMSm5pWlpMTUlTUDZNQ1o4OEoy?=
 =?utf-8?B?MzMzZHFpT3MwTDluUEswcHhLUVl1NWp4dldGa0ZwcStmM1JpYnRXcWdlTWFp?=
 =?utf-8?B?UmJ6K0pVcksxYkVVUlpBSnFSeXJrWmlZa1ArdWtMd2pnck4zZENnbnZXOGkw?=
 =?utf-8?B?cW5nK0pxRnJ0UDk1RW43WVU0VC9wMFRFNGtFeG9pQnZoSDFjelE2MGY1SXBC?=
 =?utf-8?B?cHRrVll4dFEyNkRMdXdTblRidDhIU2NvQ2txdVRWTFRMa0xya0lET2xGL2FR?=
 =?utf-8?B?dWtJN2ViNk96TzFTT09kcE4yUXB3UXgvY1YrdmZXNWd1Uk41dVI0a0NwNDFH?=
 =?utf-8?B?RDVaVkFxM2FBVG5RUXljSlk2ZGFEc0RxbjJvM05LOGdlU0kwSjY2SVNYQjV1?=
 =?utf-8?B?VTNPbFVldHNLQkcyVUpnT2VmQktMRGlIYnFsbVZEQ1dwelF4VlFNd2x6Z3hq?=
 =?utf-8?B?b3JsN2hoWjVUSG9ibW5sZXJ3UWEyQ3dXVFBrSDlRUkRCK3BXZnFDc1BmUVlk?=
 =?utf-8?B?QVVPRWxrRFYwUmFzbkoyL2xLcENxSUlXN1Azcm1wVkc5UUdQaklGREJKZW9m?=
 =?utf-8?B?TVhBUFRYQjBUZnM1cnVxRHhUZU4wR1ZOcGthMVllSEMxcFNrZkNocTUrTkVG?=
 =?utf-8?B?anlQRVIvVHpvYkdwZVFEb3h3STE3elExZmJWbGg3SDI5NVpnSkxJalVPTlVp?=
 =?utf-8?B?S1JyOFB3VlJxaDlrTFAyV3JYS1J2NU5oZTFpaHNRYWdHa3QwSm5PQUpXRnUv?=
 =?utf-8?B?YzFQaS9hQTBUdG9QQ3NYSzc0bEp1R04rSGl4UXFWcURUOEd5YzY0MVd1eGRu?=
 =?utf-8?B?MGtqVmZRcnF4dVFTVSs2OTVjZndHYjFTenVtRzlqZ3dCY3MzNFJSTS9WR2px?=
 =?utf-8?B?WG5EUkcyaDhpL09kS0FmazJIVzdqTkk0V0lPZksrdkpJS3puNG1kSUlmTmZn?=
 =?utf-8?B?Z3p1L1Y1ZnkvMSsyb2JJUVVzcE5KZEZvM3N6OXFvOG1wc3pYc2dOZk5NVmRR?=
 =?utf-8?B?V053dmR4SnhYRytZMHJKeUJRcjM3aVZ3b1czZHR2TEJ3NkR1RDdKTTBYN1do?=
 =?utf-8?B?MzFjQWMrRWpYTGRFaG9qeExybGJaL2gwM0xia2V6V3BtU01GbG1TQWdCalRJ?=
 =?utf-8?B?Z25kdEJFTlNzdHRWSUIwUGYrRnZVTTdZeVViTDJNU3Z4Y3A1Zkk2MEtXSGFP?=
 =?utf-8?B?cGN3NDBJY2ZCM09yZmJKUDVQbnU0Zk05U09tUWF6L2w3cFZpeklvQ2ZzVWRC?=
 =?utf-8?B?VVFNc0hvM3RZZUIyaitqYWRKcS96bWpkbDdMWjNJSDROZWpmZUpUNnRuak96?=
 =?utf-8?B?Q0VaeDEyWHlPV2E2dHIrcmZRdXJ6blJaQTUxYjFwVmZrSnk1QmwzQlQxcENk?=
 =?utf-8?B?c2E3Y2Z4eVd0TklEOTlWemtMZVNCVjRFVTZzV29iaVNQWExnMHRjSHdGQmo4?=
 =?utf-8?B?V0x6RHdGbnF5Zkc4cFpHcUlINE80QzhVaVdMZ1ovUFh0ci9aQjZNMFZhejZG?=
 =?utf-8?Q?GSV3cO?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0PR02MB11133.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(10070799003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?SVdPOUtRTXdPdlhuM1FEdFdHQVg5QWJISU1rYWJEM2c4KzhPVXhKOVBFdzVi?=
 =?utf-8?B?VGlLejYyd3owVGRKeDZ4QnVWMk1nd3JmdmxWd1hORm1ueTdwOXE0VW1Jb3lK?=
 =?utf-8?B?QkhLRUFiRGorSGFaNmx6YVZvTkJlb3VRVG5mcGxSb3dPWWVBZDJtSFZXcElZ?=
 =?utf-8?B?K25hQkIyQ2NDZVFVbVlTcmxBZWJHeFZMWjBoUWxUd1VkN1RNREFXUC9OSHJw?=
 =?utf-8?B?TTVFcGE5NWFMQTVLZjRwdktQTEo0V2FwK1pFcjJFTnJod0kxd0xKaENNaERB?=
 =?utf-8?B?bzA4Uyt1dG1WKzZMY2dDa0ZGLzNrVkFLUE9VZlhLVENBTFJHcFhIc1Z1L2pF?=
 =?utf-8?B?WjZodnZkQ043WVdhZmIvaG9lMWwybURvZ3RoZjV2TnZIT3VGcDE0eU9IaEZs?=
 =?utf-8?B?ODBXSUVEQytkNnRtUExROStJWk5PdUdYejFxZThNNHFtTWhCZE9ScGxtQ0p2?=
 =?utf-8?B?Szg1ODdtcGJacjkrekNHQ1pHYzBSS1hBc1BHc2Q4S2VrT0hQYjVhUjA3cTVK?=
 =?utf-8?B?TFhpcjMrRmJtQ3dOTkV6RTJUcHZsOWp6VlJieDhuQnByL2hkUW1OUWdmVTI1?=
 =?utf-8?B?TVEzY3BLOGhMa1lUU0hMajgxQVlld2NiUnQvVFFFeXpkWG9JT2xCWmFkMEs0?=
 =?utf-8?B?TVdpK2s1YzhRVDVZbFlrQjZwTnhRUm03cVF2T21SRVB2My9NdzJuZDdqM1U3?=
 =?utf-8?B?YSt4YVJLL1hsck9jOXVIRDNHNjdwMi9NaVNDbWgzamlzNysvV1VydkxwbkdF?=
 =?utf-8?B?aUlKZmU1VEZIaDM5NG9PS1BnaENxSjE4T3pUUUhyZjFsdmViclBVSlhiU3dk?=
 =?utf-8?B?WjhNWitteEpoWlEyR2I5VTllWHNqR1ZkUkdkMU9YZlNrVjFoaXFiQklsUnND?=
 =?utf-8?B?UzVSTkU2Smx4c0FZNzFRby9PaVBENGxMZHR5Mkt3RXBONi9qUEVpTWlFVVdy?=
 =?utf-8?B?cUVKb1pkQW96MFBzSStDbnRPWjd2VzJ2dktGZEVydzdYbFdlSHVtLzRXQVpD?=
 =?utf-8?B?YktoVVV5L2lJYmRRREFGLzhJTXFHbnpJeDVSazAvZDhBdjNPYmdGeGdJTWx2?=
 =?utf-8?B?RWhVNWdMRDdhRXEzcy9JbHJhaWhRQ2tGRjBKUjNqdkxvVDJzTERmeEg0cnI0?=
 =?utf-8?B?ZmdUZzcvSXJvb1JKemtSTXNKMHIzNDR6eDZzVmdaTi9hVVp6MC9QclMwcmFV?=
 =?utf-8?B?MVlBRElqZW1XaTR2cFUrK2t5bk0wRUE1ZkRuYUkvQXlXTmcxY2s2S0FpVlBt?=
 =?utf-8?B?aEZ5TWJ2L0E2WHQzRlZYMjl4Q1A5L01Bbk0vUXdpN1A3c2RKYUNvT3pzTWFq?=
 =?utf-8?B?cExGdHN4bWZkaHdqWTJEQVNOLzBMNGF0cXpPSUp1eTFqa21XUHRpQ3FLS0pC?=
 =?utf-8?B?QW5ET1ZCSnpRSnJOTDljWVhCNEd6eGFVaVA0MUxZUWpMazBEaGZZeFhzOHFt?=
 =?utf-8?B?NWhaYzFDcFZ3QkVMOUhLVGZFdk9wQjQ3L055OGNHQlNHMVhwNXF1azErNnRn?=
 =?utf-8?B?VEZ3ZmRxYUlrNllVQzB6NlNBWjdVUWdwYnVZZVQ2dGx1VDNpQlg2UjJSbnQ1?=
 =?utf-8?B?L3JiMDNSLzZVNjllTjdxWTVLQWkwMGR6MW1nRm45aFBCbmEvQ0lBa0xNZUJ3?=
 =?utf-8?B?QmFCVVhvKzN3amhOM3pWTVZLTlhoUkdJRlF6VmZjSmQwWnZNMjM4ekFZYmw4?=
 =?utf-8?B?TUI3OXVHZlJnQWRBMGxSUHd4OTEyM3o2c2UySVAwcitNbzZabTlqdW5vS0lq?=
 =?utf-8?B?SER6NERjR1MySHVSOVk3alpDakF6T25xL0NDc0xrSUo2OXJIckV3Zm8yNHFI?=
 =?utf-8?B?SktaTnR0cnpxNytnejc0VG4wMVNJRnkvbEpjU3VYNi9sWCt1ZVNDeWRqamdL?=
 =?utf-8?B?c01qdVZpR1ROUStSQ2JGa0JwaW9ZU1ZadVgvemFiNjFDNEtGZUV5VkNuY0Z1?=
 =?utf-8?B?bit3TnJqaXJ0UDVJcWI1UmJEaC9jUk0xVHJ0Wm5UMzFWYm91TWdrQ2ZiS3Ix?=
 =?utf-8?B?dHpLSCtySkQxYWJRMUZva1pXOHdqZzN1ZDgzb3VreEhJQ05VR2dFQUFaZFQy?=
 =?utf-8?B?MDl2UHVwSEdwVjNjZVVhQUdwUmhvaXRGcTRyUE9CdlQ1c05YUUZSN3BLOFdM?=
 =?utf-8?B?VDlhMG5tR1NQQngrTkJpQWVzbnpncytacmlueUVzMm0raUY3Y3ltN0ZkVGhs?=
 =?utf-8?B?YWtrdW1xSlBGcERPTlVHYUczelh0SmVQSmpwU0RSWk81M3FPcW9CTmlxTkRI?=
 =?utf-8?B?dFNiU3UyZ0M2U3JaY0hnZUJiQ093PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1CC4B5E8CEF34C489D778AEA109F3E7C@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV0PR02MB11133.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44a75e21-6618-4790-cd53-08de31c37eab
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2025 16:54:44.6674
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3I3q6+yPF5tht9MR0+J7anuoGLOHF6t+KXJEPz9DC4iRmns2EYrSScPQm4tOKDZcXrZ/RQKfwSXwkO7FkTamnZfCkfTUo0M9YDYsG/7ZEFQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR02MB9895
X-Proofpoint-ORIG-GUID: HRbi1o2rgxrFmHp5R65tMU0iIm6Zd75r
X-Authority-Analysis: v=2.4 cv=HboZjyE8 c=1 sm=1 tr=0 ts=692f19d8 cx=c_pps
 a=H6ktR1pBjhOhntuJGWw7QQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=20KFwNOVAAAA:8 a=64Cc0HZtAAAA:8 a=i0DmOSD8qNdVY4KC7IMA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjAyMDEzNCBTYWx0ZWRfXzWMIcjIc8mrX
 X1sZUE/d15t6oG0IBCKsWAruMBOmLIUTZMJAitNRI4ajixicyDjLd4x19f4VH3A3jaY2OF5Jbkh
 KfHwdRoNwFAdqYJrvUBqdrj1y+WEm3w+V8HDanFODFP6rvErIrNNd4dnyROqwp5IGxtfeBP3/RA
 MPMNlqOKiR/jQsDrnyiq/pynpEZra4xY2d0vPB+ez/TcI3Ue63JdFgyQ4heN/sZBJ4cC6JHfpeb
 EbrJ1j1saMIb3X9rR8ZxU0Eu3KQ14BR13xf/BY2Xn8e/he6j4QAJ3TbcgwbVShLGpzTfv5JAwhk
 YXEUo0jNOpomL843L6wmOI3h8Be8LLMwRySqMopgC//Mu88dYPb1wITvG9P3uaxGmelTylPtT8O
 +Yz5OeoQ9A7HohaKnDd3dDPAkKm9Yw==
X-Proofpoint-GUID: HRbi1o2rgxrFmHp5R65tMU0iIm6Zd75r
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-01_01,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gTm92IDI3LCAyMDI1LCBhdCAxOjMy4oCvQU0sIE1pY2hhZWwgUy4gVHNpcmtpbiA8
bXN0QHJlZGhhdC5jb20+IHdyb3RlOg0KPiANCj4gT24gVGh1LCBOb3YgMjcsIDIwMjUgYXQgMDM6
MTE6NTdBTSArMDAwMCwgSm9uIEtvaGxlciB3cm90ZToNCj4+IA0KPj4gDQo+Pj4gT24gTm92IDI2
LCAyMDI1LCBhdCA4OjA44oCvUE0sIEphc29uIFdhbmcgPGphc293YW5nQHJlZGhhdC5jb20+IHdy
b3RlOg0KPj4+IA0KPj4+IE9uIFRodSwgTm92IDI3LCAyMDI1IGF0IDM6NDjigK9BTSBKb24gS29o
bGVyIDxqb25AbnV0YW5peC5jb20+IHdyb3RlOg0KPj4+PiANCj4+Pj4gDQo+Pj4+PiBPbiBOb3Yg
MjYsIDIwMjUsIGF0IDU6MjXigK9BTSwgQXJuZCBCZXJnbWFubiA8YXJuZEBhcm5kYi5kZT4gd3Jv
dGU6DQo+Pj4+PiANCj4+Pj4+IE9uIFdlZCwgTm92IDI2LCAyMDI1LCBhdCAwNzowNCwgSmFzb24g
V2FuZyB3cm90ZToNCj4+Pj4+PiBPbiBXZWQsIE5vdiAyNiwgMjAyNSBhdCAzOjQ14oCvQU0gSm9u
IEtvaGxlciA8am9uQG51dGFuaXguY29tPiB3cm90ZToNCj4+Pj4+Pj4+IE9uIE5vdiAxOSwgMjAy
NSwgYXQgODo1N+KAr1BNLCBKYXNvbiBXYW5nIDxqYXNvd2FuZ0ByZWRoYXQuY29tPiB3cm90ZToN
Cj4+Pj4+Pj4+IE9uIFR1ZSwgTm92IDE4LCAyMDI1IGF0IDE6MzXigK9BTSBKb24gS29obGVyIDxq
b25AbnV0YW5peC5jb20+IHdyb3RlOg0KPj4+Pj4+PiBTYW1lIGRlYWwgZ29lcyBmb3IgX19wdXRf
dXNlcigpIHZzIHB1dF91c2VyIGJ5IHdheSBvZiBjb21taXQNCj4+Pj4+Pj4gZTNhYTYyNDM0MzRm
ICgiQVJNOiA4Nzk1LzE6IHNwZWN0cmUtdjEuMTogdXNlIHB1dF91c2VyKCkgZm9yIF9fcHV0X3Vz
ZXIoKeKAnSkNCj4+Pj4+Pj4gDQo+Pj4+Pj4+IExvb2tpbmcgYXQgYXJjaC9hcm0vbW0vS2NvbmZp
ZywgdGhlcmUgYXJlIGEgdmFyaWV0eSBvZiBzY2VuYXJpb3MNCj4+Pj4+Pj4gd2hlcmUgQ09ORklH
X0NQVV9TUEVDVFJFIHdpbGwgYmUgZW5hYmxlZCBhdXRvbWFnaWNhbGx5LiBMb29raW5nIGF0DQo+
Pj4+Pj4+IGNvbW1pdCAyNTIzMDlhZGM4MWYgKCJBUk06IE1ha2UgQ09ORklHX0NQVV9WNyB2YWxp
ZCBmb3IgMzJiaXQgQVJNdjggaW1wbGVtZW50YXRpb25zIikNCj4+Pj4+Pj4gaXQgc2F5cyB0aGF0
ICJBUk12OCBpcyBhIHN1cGVyc2V0IG9mIEFSTXY3Iiwgc28gSeKAmWQgZ3Vlc3MgdGhhdCBqdXN0
DQo+Pj4+Pj4+IGFib3V0IGV2ZXJ5dGhpbmcgQVJNIHdvdWxkIGluY2x1ZGUgdGhpcyBieSBkZWZh
dWx0Pw0KPj4+Pj4gDQo+Pj4+PiBJIHRoaW5rIHRoZSBtb3JlIHJlbGV2YW50IGNvbW1pdCBpcyBm
b3IgNjQtYml0IEFybSBoZXJlLCBidXQgdGhpcyBkb2VzDQo+Pj4+PiB0aGUgc2FtZSB0aGluZywg
c2VlIDg0NjI0MDg3ZGQ3ZSAoImFybTY0OiB1YWNjZXNzOiBEb24ndCBib3RoZXINCj4+Pj4+IGVs
aWRpbmcgYWNjZXNzX29rIGNoZWNrcyBpbiBfX3tnZXQsIHB1dH1fdXNlciIpLg0KPj4+PiANCj4+
Pj4gQWghIFJpZ2h0LCB0aGlzIGlzIGRlZmluaXRlbHkgdGhlIGltcG9ydGFudCBiaXQsIGFzIGl0
IG1ha2VzIGl0DQo+Pj4+IGNyeXN0YWwgY2xlYXIgdGhhdCB0aGVzZSBhcmUgZXhhY3RseSB0aGUg
c2FtZSB0aGluZy4gVGhlIGN1cnJlbnQNCj4+Pj4gY29kZSBpczoNCj4+Pj4gI2RlZmluZSBnZXRf
dXNlciAgICAgICAgX19nZXRfdXNlcg0KPj4+PiAjZGVmaW5lIHB1dF91c2VyICAgICAgICBfX3B1
dF91c2VyDQo+Pj4+IA0KPj4+PiBTbywgdGhpcyBwYXRjaCBjaGFuZ2luZyBmcm9tIF9fKiB0byBy
ZWd1bGFyIHZlcnNpb25zIGlzIGEgbm8tb3ANCj4+Pj4gb24gYXJtIHNpZGUgb2YgdGhlIGhvdXNl
LCB5ZWE/DQo+Pj4+IA0KPj4+Pj4gSSB3b3VsZCB0aGluayB0aGF0IGlmIHdlIGNoYW5nZSB0aGUg
X19nZXRfdXNlcigpIHRvIGdldF91c2VyKCkNCj4+Pj4+IGluIHRoaXMgZHJpdmVyLCB0aGUgc2Ft
ZSBzaG91bGQgYmUgZG9uZSBmb3IgdGhlDQo+Pj4+PiBfX2NvcHlfe2Zyb20sdG99X3VzZXIoKSwg
d2hpY2ggc2ltaWxhcmx5IHNraXBzIHRoZSBhY2Nlc3Nfb2soKQ0KPj4+Pj4gY2hlY2sgYnV0IG5v
dCB0aGUgUEFOL1NNQVAgaGFuZGxpbmcuDQo+Pj4+IA0KPj4+PiBQZXJoYXBzLCB0aGF0cyBhIGdv
b2QgY2FsbCBvdXQuIEnigJlkIGZpbGUgdGhhdCB1bmRlciBvbmUgYmF0dGxlDQo+Pj4+IGF0IGEg
dGltZS4gTGV04oCZcyBnZXQgZ2V0L3B1dCB1c2VyIGR1c3RlZCBmaXJzdCwgdGhlbiBnbyBkb3du
DQo+Pj4+IHRoYXQgcm9hZD8NCj4+Pj4gDQo+Pj4+PiBJbiBnZW5lcmFsLCB0aGUgYWNjZXNzX29r
KCkvX19nZXRfdXNlcigpL19fY29weV9mcm9tX3VzZXIoKQ0KPj4+Pj4gcGF0dGVybiBpc24ndCBy
ZWFsbHkgaGVscGZ1bCBhbnkgbW9yZSwgYXMgTGludXMgYWxyZWFkeQ0KPj4+Pj4gZXhwbGFpbmVk
LiBJIGNhbid0IHRlbGwgZnJvbSB0aGUgdmhvc3QgZHJpdmVyIGNvZGUgd2hldGhlcg0KPj4+Pj4g
d2UgY2FuIGp1c3QgZHJvcCB0aGUgYWNjZXNzX29rKCkgaGVyZSBhbmQgdXNlIHRoZSBwbGFpbg0K
Pj4+Pj4gZ2V0X3VzZXIoKS9jb3B5X2Zyb21fdXNlcigpLCBvciBpZiBpdCBtYWtlcyBzZW5zZSB0
byBtb3ZlDQo+Pj4+PiB0byB0aGUgbmV3ZXIgdXNlcl9hY2Nlc3NfYmVnaW4oKS91bnNhZmVfZ2V0
X3VzZXIoKS8NCj4+Pj4+IHVuc2FmZV9jb3B5X2Zyb21fdXNlcigpL3VzZXJfYWNjZXNzX2VuZCgp
IGFuZCB0cnkgb3B0aW1pemUNCj4+Pj4+IG91dCBhIGZldyBQQU4vU01BUCBmbGlwcyBpbiB0aGUg
cHJvY2Vzcy4NCj4+PiANCj4+PiBSaWdodCwgYWNjb3JkaW5nIHRvIG15IHRlc3RpbmcgaW4gdGhl
IHBhc3QsIFBBTi9TTUFQIGlzIGEga2lsbGVyIGZvcg0KPj4+IHNtYWxsIHBhY2tldCBwZXJmb3Jt
YW5jZSAoUFBTKS4NCj4+IA0KPj4gRm9yIHN1cmUsIGV2ZXJ5IGxpdHRsZSBiaXQgaGVscHMgYWxv
bmcgdGhhdCBwYXRoDQo+PiANCj4+PiANCj4+Pj4gDQo+Pj4+IEluIGdlbmVyYWwsIEkgdGhpbmsg
dGhlcmUgYXJlIGEgZmV3IHNwb3RzIHdoZXJlIHdlIG1pZ2h0IGJlDQo+Pj4+IGFibGUgdG8gb3B0
aW1pemUgKHZob3N0X2dldF92cV9kZXNjIHBlcmhhcHM/KSBhcyB0aGF0IGdldHMNCj4+Pj4gY2Fs
bGVkIHF1aXRlIGEgYml0IGFuZCBJSVJDIHRoZXJlIGFyZSBhdCBsZWFzdCB0d28gZmxpcHMNCj4+
Pj4gaW4gdGhlcmUgdGhhdCBwZXJoYXBzIHdlIGNvdWxkIGVsaWRlIHRvIG9uZT8gQW4gaW52ZXN0
aWdhdGlvbg0KPj4+PiBmb3IgYW5vdGhlciBkYXkgSSB0aGluay4NCj4+PiANCj4+PiBEaWQgeW91
IG1lYW4gdHJ5aW5nIHRvIHJlYWQgZGVzY3JpcHRvcnMgaW4gYSBiYXRjaCwgdGhhdCB3b3VsZCBi
ZQ0KPj4+IGJldHRlciBhbmQgd2l0aCBJTl9PUkRFUiBpdCB3b3VsZCBiZSBldmVuIGZhc3RlciBh
cyBhIHNpbmdsZSAoYXQgbW9zdA0KPj4+IHR3bykgY29weV9mcm9tX3VzZXIoKSBtaWdodCB3b3Jr
ICh3aXRob3V0IHRoZSBuZWVkIHRvIHVzZQ0KPj4+IHVzZXJfYWNjZXNzX2JlZ2luKCkvdXNlcl9h
Y2Nlc3NfZW5kKCkuDQo+PiANCj4+IFllcC4gSSBoYXZlbuKAmXQgZnVsbHkgdGhvdWdodCB0aHJv
dWdoIGl0LCBqdXN0IGEgZHJpdmUtYnkgaWRlYQ0KPj4gZnJvbSBsb29raW5nIGF0IGNvZGUgZm9y
IHRoZSByZWNlbnQgd29yayBJ4oCZdmUgYmVlbiBkb2luZywganVzdA0KPj4gc2NyYXRjaGluZyBt
eSBoZWFkIHRoaW5raW5nIHRoZXJlICptdXN0KiBiZSBzb21ldGhpbmcgd2UgY2FuIGRvDQo+PiBi
ZXR0ZXIgdGhlcmUuDQo+PiANCj4+IEJhc2ljYWxseSBvbiB0aGUgZ2V0IHJ4L3R4IGJ1ZnMgcGF0
aCBhcyB3ZWxsIGFzIHRoZQ0KPj4gdmhvc3RfYWRkX3VzZWRfYW5kX3NpZ25hbF9uIHBhdGgsIEkg
dGhpbmsgd2UgY291bGQgY2x1c3RlciB0b2dldGhlcg0KPj4gc29tZSBvZiB0aGUgZ2V0L3B1dCB1
c2VycyBhbmQgY29weSB0by9mcm9t4oCZcy4gV291bGQgdGFrZSBzb21lDQo+PiBtYXNzYWdpbmcs
IGJ1dCBJIHRoaW5rIHRoZXJlIGlzIHNvbWV0aGluZyB0aGVyZS4NCj4+IA0KPj4+PiANCj4+Pj4g
QW55aG93LCB3aXRoIHRoaXMgaW5mbyAtIEphc29uIC0gaXMgdGhlcmUgYW55dGhpbmcgZWxzZSB5
b3UNCj4+Pj4gY2FuIHRoaW5rIG9mIHRoYXQgd2Ugd2FudCB0byBkb3VibGUgY2xpY2sgb24/DQo+
Pj4gDQo+Pj4gTm9wZS4NCj4+PiANCj4+PiBUaGFua3MNCj4+IA0KPj4gT2sgdGhhbmtzLiBQZXJo
YXBzIHdlIGNhbiBsYW5kIHRoaXMgaW4gbmV4dCBhbmQgbGV0IGl0IHNvYWsgaW4sDQo+PiB0aG91
Z2gsIGtub2NrIG9uIHdvb2QsIEkgZG9u4oCZdCB0aGluayB0aGVyZSB3aWxsIGJlIGZhbGxvdXQN
Cj4+IChmYW1vdXMgbGFzdCB3b3JkcyEpID8NCj4+IA0KPiANCj4gDQo+IFRvIGNsYWlyaWZ5LCBJ
IHRoaW5rIHZob3N0IHRyZWUgaXMgYmV0dGVyIHRvIHB1dCB0aGlzDQo+IGluIG5leHQgdGhhbiBu
ZXQtbmV4dCwgYm90aCBiZWNhdXNlIGl0J3MgcHVyZWx5IGNvcmUgdmhvc3QNCj4gYW5kIGJlY2F1
c2UgdW5saWtlIG5ldC1uZXh0IHZob3N0IHJlYmFzZXMgc28gaXQgaXMgZWFzeSB0bw0KPiBqdXN0
IGRyb3AgdGhlIHBhdGNoIGlmIHRoZXJlIGFyZSBpc3N1ZXMuDQo+IEknbGwgcHV0IGl0IHRoZXJl
Lg0KPiANCj4gLS0gDQo+IE1TVA0KPiANCg0KT2sgY29vbCwgdGhhbmsgeW91IQ==

