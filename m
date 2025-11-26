Return-Path: <kvm+bounces-64752-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 67683C8C122
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 22:43:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 61A623AC6E0
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 21:43:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B4C33168E0;
	Wed, 26 Nov 2025 21:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="E49dm/8/";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="p+KKJRkm"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28BFA304BB2;
	Wed, 26 Nov 2025 21:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764193425; cv=fail; b=AJbxGsZzVzJhZtN6RTFOOygGFuRR41cJZ0eVg3Tm88XFcXApzgEoKLXJR7eL1hsrpvyac24/YeLaTIeYZlXXZBBwQlHRGET8TjNFz8h0Dn7XeKBPutsVtsJarUllgnYDzIzFJJ4NxL6b2+42sKtFs6/1B3jlr/mbzOhgdBGATjE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764193425; c=relaxed/simple;
	bh=/IF/qAPfrdxnVpTVQsYs5DOJYoPiyTwNkJ+2IcAZoqc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZgtptxTLf3UwQzbJK2s2fvrJvSWSJqBfYXIRMyr6Ers+34Y3Jr2WaczVa96r2o9+5l6PHDzPsyK9GUWta+H08Eqi09ig++VEG0KhyKfBAUxKsES4RgBtJI7ZEZznULVmB1fI+/oonW3S65poA0rxQvgYeL63SSC6xn/g8XNGC0A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=E49dm/8/; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=p+KKJRkm; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AQIAeGQ991085;
	Wed, 26 Nov 2025 13:42:54 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=/IF/qAPfrdxnVpTVQsYs5DOJYoPiyTwNkJ+2IcAZo
	qc=; b=E49dm/8/2ZcHLvsN60Q7Uf/a5GnPX3H+P+XI1ofAcdAOVUPwrN2963VN+
	nAU47d7AwWoMRb8XPIkPj3ZO4xxwmtBdMXeCwnls7ykIfe6N7yIf7SfyzMMWbXVb
	9B4dT2m18RWmp97tpujbtxvKsPtQxpoCIHUgx6JPMi5+/Fge10LRC1DJZbk5zdLx
	Q91qmbomfZwZNHA75xVQtstgjMbty0DuSdFSm1ElUbhRqfDtSp4joZ0heHnWJtQX
	1YrZ/7QlmBChJAAM4UKbVpV+dbNbU6tuWUtWadLEzbL2LuAqbJ3m7k7iMlexfVeq
	o43mSJc6/1JlnhVTWbTJJXV0HCYFQ==
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11022119.outbound.protection.outlook.com [52.101.48.119])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4anm6yanum-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 26 Nov 2025 13:42:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WZ12CXIUdJl2O33XA8lV4nUvFqoR6bIqGyawGPM5RE3jiz+/Hit1ATduvJD49iOI8EG7F2zZi0EY3EfGfR0fQ/rmEEELcVzkylwcgAo9QPFl29MIb6rhh+MP3cP8S8/6Kj8B2f5mYY4TinyCTqbMJ3q/Mtykd/PvSQlsneBE5CxXYkLdcfdB+bL7YeedcFoDlUHgqq3/wowS9rX7xWeSHawq27lY8KeFVtyOtPg/p94XOB6VZLH3Y7kUNwMFiWI8tcWqrdDkIkUM6Wwx1nMuTgRA7K/Q8aGyyNLHjIIi+RJgPhMWpO0bpZK3UZeCWh1MNC7jXGiSh3mmUOAu6ONYZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/IF/qAPfrdxnVpTVQsYs5DOJYoPiyTwNkJ+2IcAZoqc=;
 b=XKNk543MWBkhijJT7Y3ZXeqAYfUM55IBdNEZq490JSPS10YUbT1Uz45fKDJFScxhU2fDwgKKV2RZwPqaskVvqCKS+uUqGAyewHl7NUqZCTCpRTc8yMRipWZamUcMd5hpt/GiLlAU7dtHEdUB9JwQ+KHKlNY5xJS1xAAzAq0jZfQF2QnSb6kxbDmIkJnTcC7E9nENgJJfX1JIAH71cOvZpldBxsh6odMes5i5DGig6u8LfNUpyoP8/3pYDKWPZKHjUMDLSkrWO/LfRiJync1mlqofRAwKkRtodsEoBljL291MUU0EZnuF2zgZDNEjwXDCPilPyk4NBSgmPNF6/UOofg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/IF/qAPfrdxnVpTVQsYs5DOJYoPiyTwNkJ+2IcAZoqc=;
 b=p+KKJRkmteGLR8KIaXIs0q5uG9Rn4aaJOF9DB88TJL477FPgeO5TftwPSSB1hAJg/BuDePx4oWO74WxrMf0oq6a0R15lgWsdFz5veq5/pMSptshfiOcIqtH1qRQonMkiUZH3F6d+63kxUXsW1sCKaNpoj/hgCEaON7egGuWqK4Ji0lKrxIZmDNwNLmq+3RagFyQdOanx5YFrBgp/498LJCQRKMFpxwDxKiPwzWk20BThVNEaadWMi1MujmPxz2arXOrcziwwSKwQjMqG+XjlTeXfbhw1w3jnZRlpvr2QX2JnfSfzlcgPIXwja779QMQkg7AnNSAR68J9ZhdgTxds3w==
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18) by BN0PR02MB8032.namprd02.prod.outlook.com
 (2603:10b6:408:16f::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.11; Wed, 26 Nov
 2025 21:42:52 +0000
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc]) by LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc%4]) with mapi id 15.20.9343.016; Wed, 26 Nov 2025
 21:42:51 +0000
From: Jon Kohler <jon@nutanix.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Jason Wang <jasowang@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
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
 AQHcVDJryQXjlObInEG9J4YkYYZKUbTvzAyAgAJ4RQCABAmigIAA2pWAgAOxCQCACQYXAIAArPaAgABI5gCAAJ0GAIAAAzkAgAAdBoA=
Date: Wed, 26 Nov 2025 21:42:51 +0000
Message-ID: <0D4EA459-C3E5-4557-97EB-17ABB4F817E5@nutanix.com>
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
In-Reply-To: <32530984-cbaa-49e8-9c1e-34f04271538d@app.fastmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.700.81)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV0PR02MB11133:EE_|BN0PR02MB8032:EE_
x-ms-office365-filtering-correlation-id: 77658431-c6fe-4288-7f31-08de2d34c035
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|7416014|1800799024|10070799003|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?L1hNU3dpMGU2UVBFZlJwRnhYY3hBR1dUTU1DNlg4UmZqZkY3V3Q1MDZPVmdS?=
 =?utf-8?B?bnVkT0pEZi9wcFFYZFpqZVdVN0V2U1V4dk1Zd2drcENObzVQbHF2RnBnTGwx?=
 =?utf-8?B?TjgxRUFHbVJ6cmtHMlJ3K0d6UHRVZzVoYVpSTzgzRXZXQXZ2RzA5YU9oaHJL?=
 =?utf-8?B?U1NoN29MRmlSVkt3OTlSRXE5QUNNbERGeno3dS82U1NoRGlaSGpmbmNxWUY1?=
 =?utf-8?B?SFFuNDBpL2FBOGV4RnAvU3ZWMmZycThlRk0zY2tCVDJ2bjJmemxQRmUvcTJ1?=
 =?utf-8?B?dXJXb1laZENOa0N3WGQ3VmlGcXowU1RqMkZmUWxRWDZzcndNblBHQnN2VGdj?=
 =?utf-8?B?MjhBdHNvaEtpYXllMXdUcWUzQVBMd0g3Y25NNEsyYXZqMWIxYjVqRWljWUxD?=
 =?utf-8?B?K1NQYVQyWGx6TmxaTUhoY25kSVZqdXdMTVlWTi8rWEliWkllY1h5aTNkNHpy?=
 =?utf-8?B?cDZFYlBDY3QraTFMUTAwQUViUy9HeTZ6QkNZbGlzcmpRZFBjZWhDNkFwK2gy?=
 =?utf-8?B?V2IrMGpHRStMOXZUTGFRVUk4ZnVFNEZFU3FDOVE5SHBKV0F6WWlucGZCNWpQ?=
 =?utf-8?B?UjRHYkdJMG1hNXNJNVNRQ0VlbFJEU3hvWG5meGlpQ2Z3YVpvRHZITWVGc3ZE?=
 =?utf-8?B?T2pKa0sxMWFiNnJLVktzdzBabFhCOUpPOW16VktOZkFFTTJrWVZDdzFUTE1J?=
 =?utf-8?B?OWlzbXZDQnRTUUp1a1pnZ3B0ckE3NlF2Vnp3VnVCbm80aXFQRDEyczJsWkRD?=
 =?utf-8?B?WVZRY0xlanRvcHZyaUk3R29mRld0R29aUlJiWktpVHE2MFM0SGRSNmVmYXQ2?=
 =?utf-8?B?a01CaUxwQmJSVkJ4K3ZZZDRaTDVKY1MyR0QxbURQb21LOFRqUTBDM2FBK1FH?=
 =?utf-8?B?NWVSaG9JaVFKQmFzbWtucndFOW95NUMxK1ZuN0l1U1pXM3kwOU5tZ0EvakJG?=
 =?utf-8?B?Sk5zakxqTmtLYkZSQlBkY01JRFQ3OUNqNGl0dVU0VmdwVnpEOHc5TkN2VzAv?=
 =?utf-8?B?MDJHdkNlZFJJRHVuOGdieCtlbUU3RGFxNERoTzg0NFpycmYxaGdpaERXQVAw?=
 =?utf-8?B?RC9Qb0ZZaHYzK3NRYWNJblVjaVRsN1dVb245T04zMmc3Nm1PSTBKTkRBU1k1?=
 =?utf-8?B?RjBLOHhidUcxRUdyVWd1VnA2OW9ncnZJbTRMa3NtYzU3N0V2S29TYW1KbjVY?=
 =?utf-8?B?RGxvTldhU0pnVlltNFhtRllybnk4TExXcU5QS1M4THc2NnpMTVE1MERTTCtt?=
 =?utf-8?B?UXZGd0pxZER3K25mb2c3RGVuMk5wdmhMQnh2NERyVDVxak5IelEwREVCS0V1?=
 =?utf-8?B?ZmhXTWs2SkhVVHVUdmhVUnducXVXSHAwYkJzODc5c1hFVFk4aUs3MGw4M0xE?=
 =?utf-8?B?OG13YzI0VmJ5SGZ0OEhuMVRpWXNHNzZpNWxDdmdzRGcxOStBbWsyeG1BQWUr?=
 =?utf-8?B?UjZYTnRNQ0s0UFYzbEZOdmNERmpxZHc2VEhLdGlQS1cyS3lYS1VHbXJaK2M0?=
 =?utf-8?B?U3EyMk9QUkFoMHE5Q1lybGs0SkJjU2NVNlAzMWJTVVNndzNDYWNCckxEU01O?=
 =?utf-8?B?YUticXhoZW1Hbk1Ma0U3d0w0Q01SQzdOOGpRNHRTS3ZFMmViNFhycXg0Z0JG?=
 =?utf-8?B?RlVuTElxd2l4VWsxbWNTUWFmVzcvb0R1dmQ1eDRBVmdLeTVodFc2WTlXazkw?=
 =?utf-8?B?bVZpY1NsK2U5T2l0VDZPbW9aaXk4bUtZRHc2TUsySG9NcnpJK2NOL3dGaC9w?=
 =?utf-8?B?OEF1VGJrL29wNkVFMzhRSHZ2Uk5heGNXRFNLMXdzc09POEhzbEk0WHpkakw2?=
 =?utf-8?B?M0NZd3BLaG9qcnF5bXBseWE3L0tpZVlEMGl4RHBWNzVZSWZHUGZaOVJvNEkz?=
 =?utf-8?B?M2VlNXhJNTZKb1FKcFpSaFN4cFhTcm43azE4RCt6VHRXUHQ4Y0ZhS3lYT2Zh?=
 =?utf-8?B?NVJuTkJzZGpqcnlWVjE0RE5sWngzcFphVnJZSUJWbWI4YjNEVnEwOVFHZlB1?=
 =?utf-8?B?NFVuY1M1dVhlWmhEa3NaVTN6bTBUQ2RJckJmZmd6R2Fwa3NING5ROVdKSEhp?=
 =?utf-8?Q?qfk4nA?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0PR02MB11133.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(10070799003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Y2xDc1c3VHZydkxnUnNvdDJ1ZDlEMTN1a0hVQTdKWWhoUVhxRXR4L0NzWnUz?=
 =?utf-8?B?Z3VDMHVjZEMvU0Q1OG9CWWdsRFRpTnF3L1ZIbEhNQ0JuK1lMak9PYm9FRWtS?=
 =?utf-8?B?UVR4YWFpWFBwVmM4Y2djQ2xGTG1RVzh6QUVaSHdZYTVCMWsvUnFNWDEvVStT?=
 =?utf-8?B?cWUzVWw2TGF0QitMNHN5UWdBR3ZVcmFxdXp3VjN0NE10QkxPNGZ2OWVPZ1ov?=
 =?utf-8?B?YzYyYWdPZU53QnNuNzlGVFFRSDNzWkE4RUlVVEFGL3ByS0lBVUhkUG1vY2tC?=
 =?utf-8?B?Z0J1bTBMdzhMQkVCWXNqZjNBWm5sSi9XL3ZYaVZMTkxKeW1YUDR3T2ludFZZ?=
 =?utf-8?B?ZkFaaWo5YWd1U2k4UktmbFZpOW0rQURhS0pZaXBjTmt2VDhUNDdLNGdtMDZx?=
 =?utf-8?B?ZVNjT2NFOHpXRmpRNEpZenZwWGUwTWp6MnY2dFVEcDRneUNGaU5ZMjZHc1FF?=
 =?utf-8?B?aVFCY2M4bUorbHJGRnlCOHE0S0EvVTRydE1YbXg0WUFkYUtXb0grYlVsMzdW?=
 =?utf-8?B?SU1xN01UaHdKZEJiekk4NXNMaEwwYk5IR2FPSmJ1NitIcS94VXY5NVZFcFZp?=
 =?utf-8?B?cEkxOEE0VTdlYzNScGpVNyttaUVqRjAybG9kT0c0K0pQM3M3cGF3VkpxR29z?=
 =?utf-8?B?MEJ3b1VvTzJLYWEvK0tBL2VTall1WTdlK09JN1NIVEVkSkZSU0dmcUg0dmg1?=
 =?utf-8?B?ZkRDcnlFbFA5OUZoM0xUeVNHdUNvM2hQREpTTEU3c1RvdGZMUTArRS9Fb0Fi?=
 =?utf-8?B?eXF1bzg2ZWtRaVd1MlFsYld5ZTIxY1pQMXJiRjZlNE1rVnRrQ050ZU5oUm1D?=
 =?utf-8?B?eGg4TFZ1QmlGRVIvQmxlcXdsR0hPWTM4YmhPcmI5RGtFeVFZb1pFNE1KTUNn?=
 =?utf-8?B?TlVDaWZtbEMwRjgwaTE4bjNTRG93b1hSOTcyZDJVdVgvYjFadE9ndDlwbnkr?=
 =?utf-8?B?WVhwcncySGtoQ1BLSXhIQy8xOG5Wb0NYNC9hby94QXhJeEZPSVY2MTRCblJt?=
 =?utf-8?B?TnZTY2VhZzV1L0VPUUhTdnRSYmpwNlpFVGtSa1gzMjQ3cEtiVFZNeHhCRzhR?=
 =?utf-8?B?bUVlOXFQOGdhMzI0ZzF0MDFQZUxaUEh5ZHdmTmZ6ejJnZ0JpUVZNbVRJN1B6?=
 =?utf-8?B?OHR1YjF1NXYzN0hKUTViV25ZRGVUUjkvamxuRGxYU2oyYU15cldtOHpHZWJh?=
 =?utf-8?B?dkRJbXVWZkI0N0s1cHJocTZlTWpJTjFBYS9rN3dCdDNFMXZxeTBRYW11MDJt?=
 =?utf-8?B?VTZNV0FRRFJPRUgyeDgvKzcxb0VtYUFoUXJFL2NVcm0xL2wvU3F3RVpKeklm?=
 =?utf-8?B?Zlo1R3VuRDZIbHBveGkrTTZ4Mnh5aWVWcndLNmhQS2dIQVUwd3NicHhvdTFm?=
 =?utf-8?B?WlI2TFVpTDVrUlVROW5pOWpTcUhwbldDbTR5QVpHYzJzamZzaWNsYWduZVFD?=
 =?utf-8?B?SDVoYTVibVRQeGQ2MVFwWmFOanpLMGllREpDQnQ0MUthRXpzYVQ4N3krRGR0?=
 =?utf-8?B?RTZuVFU3bVlHYVhpdzdwenJDamFIVVp2em9WbG10RFRzOTltMTI4RUFNNFZ5?=
 =?utf-8?B?QzdGaGFpRk1Ea1FreFgyQ1d5QStmdWFFMWpEc2ozV2IvcUR2M0tOM3B1NEor?=
 =?utf-8?B?eW5HeklCb2lwc3NwdDdYRlpLOWJqMkRITzBvN3FVdlJodHQ1Zkw2MXk4SnlZ?=
 =?utf-8?B?bWd3Z1FOWWRYeHBjNHUxRzlQUWkzdkF1NXZKOXJLcC8rcWIwRy9TVFNiWXpU?=
 =?utf-8?B?aWgvd0tBcnVNMmdsNmQ0Qkg3SXRzQk1vaFhqSHZMamQ5cWUxMmk0RlprWTRG?=
 =?utf-8?B?ZllwWVJNaUJiYStmLzBwVHhwN3VhMlVrUmNOazkvQXp5Yzc4Nk12UFkyQzRh?=
 =?utf-8?B?S1ZVV0FycHY0MkJSamp3R2w4Wlp6WWtqRDdodGhzYjcwQklGMVE2bnN6Q2xt?=
 =?utf-8?B?dXB4SjcrWUNlQUVlbTNsNXpIL0Ywd3AySThJMTFSY0JaTXd6V014U0ZDaEt3?=
 =?utf-8?B?aGhrSVkxalFzWVAvNDA0QlZ2dVZJamExVmwyL01UOEcyRytKd1RoOUFoTXJ0?=
 =?utf-8?B?OCswSjdSTG1mYkk5WlM2WVhoTHNGSGh4Wnppd0oxZy84bjhRNERSVjZXbUZZ?=
 =?utf-8?B?aE5JazBjdG8vNFhRak1IbkNkL3pwY3JhR3ZZckxZT2E4RGMxOW9vSk04NlBi?=
 =?utf-8?B?dGUraXdEZXFBa1djNHNtM3pCOFpCS05GK0FEUk90bUQrc2JaRVBSVlcwWXNa?=
 =?utf-8?B?bWs4c3ovb0ZibEY3dnp2cHQwUHN3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D91D8E201A8F2445AC09DD72E8E4E942@namprd02.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 77658431-c6fe-4288-7f31-08de2d34c035
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2025 21:42:51.8563
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Hkzi8T0xmXUXRBmuYDAUw0mo6bOK7wcXZUyePJ/9xJ6h1J7pfe92jGIs7Nxuw3+H/aCCGYMf1TQY0o1CieXLYl4NRZiAtFSgCLeg0fPgw9o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR02MB8032
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI2MDE3NiBTYWx0ZWRfXw4z+11mCwXvp
 zJCfoeSzPWpkX2sHkY75e2kv//Dudr0FHHOwKIlk8E0kRViEiwx/4fV7C7p0VdJRft89yCdRIRT
 V8hFNc/u3ktXFPNU2JPPE7BtsmkEq/lfG69N8vVCTPrHixdsKB4MF/mcj4E26Wsc58H0ttZlDIH
 f6Q+a9s3dovvbTbWMpWaSsb4l87Hu4U7l51y3EM5dpYrUd01psZX8BVjh53IDycRfEWx7vXWZP7
 l7rKmB8RZpI+wLzleNFgkBCQ7iOOq3oCo06HGgwYvosaENxUQWZH/8YxNzy+CoQOi314uqCLJUV
 s9uPg/KNn4+wPCH3Hh5JyQjeJkKaTQZaKfQb+C4m721oC3UtzSrzuf1Ze9bHSWCdD3Z3wr+TwL+
 nAGq5bUXCSG7hvWj9ngm+1KBBFqKMg==
X-Proofpoint-GUID: aOM-7tvRRtL_2fFOy0jNe6A2d4hUcilv
X-Authority-Analysis: v=2.4 cv=JJY2csKb c=1 sm=1 tr=0 ts=6927745e cx=c_pps
 a=xSzMZOIKDOBgwsc4tMfFrQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=64Cc0HZtAAAA:8 a=ZnPZ_Q0fCw4HsSt0HFUA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: aOM-7tvRRtL_2fFOy0jNe6A2d4hUcilv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-26_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gTm92IDI2LCAyMDI1LCBhdCAyOjU44oCvUE0sIEFybmQgQmVyZ21hbm4gPGFybmRA
YXJuZGIuZGU+IHdyb3RlOg0KPiANCj4gT24gV2VkLCBOb3YgMjYsIDIwMjUsIGF0IDIwOjQ3LCBK
b24gS29obGVyIHdyb3RlOg0KPj4+IE9uIE5vdiAyNiwgMjAyNSwgYXQgNToyNeKAr0FNLCBBcm5k
IEJlcmdtYW5uIDxhcm5kQGFybmRiLmRlPiB3cm90ZToNCj4+PiBPbiBXZWQsIE5vdiAyNiwgMjAy
NSwgYXQgMDc6MDQsIEphc29uIFdhbmcgd3JvdGU6DQo+Pj4+IE9uIFdlZCwgTm92IDI2LCAyMDI1
IGF0IDM6NDXigK9BTSBKb24gS29obGVyIDxqb25AbnV0YW5peC5jb20+IHdyb3RlOg0KPj4+IEkg
dGhpbmsgdGhlIG1vcmUgcmVsZXZhbnQgY29tbWl0IGlzIGZvciA2NC1iaXQgQXJtIGhlcmUsIGJ1
dCB0aGlzIGRvZXMNCj4+PiB0aGUgc2FtZSB0aGluZywgc2VlIDg0NjI0MDg3ZGQ3ZSAoImFybTY0
OiB1YWNjZXNzOiBEb24ndCBib3RoZXINCj4+PiBlbGlkaW5nIGFjY2Vzc19vayBjaGVja3MgaW4g
X197Z2V0LCBwdXR9X3VzZXIiKS4NCj4+IA0KPj4gQWghIFJpZ2h0LCB0aGlzIGlzIGRlZmluaXRl
bHkgdGhlIGltcG9ydGFudCBiaXQsIGFzIGl0IG1ha2VzIGl0DQo+PiBjcnlzdGFsIGNsZWFyIHRo
YXQgdGhlc2UgYXJlIGV4YWN0bHkgdGhlIHNhbWUgdGhpbmcuIFRoZSBjdXJyZW50DQo+PiBjb2Rl
IGlzOg0KPj4gI2RlZmluZSBnZXRfdXNlciBfX2dldF91c2VyDQo+PiAjZGVmaW5lIHB1dF91c2Vy
IF9fcHV0X3VzZXINCj4+IA0KPj4gU28sIHRoaXMgcGF0Y2ggY2hhbmdpbmcgZnJvbSBfXyogdG8g
cmVndWxhciB2ZXJzaW9ucyBpcyBhIG5vLW9wDQo+PiBvbiBhcm0gc2lkZSBvZiB0aGUgaG91c2Us
IHllYT8NCj4gDQo+IENlcnRhaW5seSBvbiA2NC1iaXQsIGFuZCBhbG1vc3QgYWx3YXlzIG9uIDMy
LWJpdCwgeWVzLg0KPiANCj4+PiBJIHdvdWxkIHRoaW5rIHRoYXQgaWYgd2UgY2hhbmdlIHRoZSBf
X2dldF91c2VyKCkgdG8gZ2V0X3VzZXIoKQ0KPj4+IGluIHRoaXMgZHJpdmVyLCB0aGUgc2FtZSBz
aG91bGQgYmUgZG9uZSBmb3IgdGhlDQo+Pj4gX19jb3B5X3tmcm9tLHRvfV91c2VyKCksIHdoaWNo
IHNpbWlsYXJseSBza2lwcyB0aGUgYWNjZXNzX29rKCkNCj4+PiBjaGVjayBidXQgbm90IHRoZSBQ
QU4vU01BUCBoYW5kbGluZy4NCj4+IA0KPj4gUGVyaGFwcywgdGhhdHMgYSBnb29kIGNhbGwgb3V0
LiBJ4oCZZCBmaWxlIHRoYXQgdW5kZXIgb25lIGJhdHRsZQ0KPj4gYXQgYSB0aW1lLiBMZXTigJlz
IGdldCBnZXQvcHV0IHVzZXIgZHVzdGVkIGZpcnN0LCB0aGVuIGdvIGRvd24NCj4+IHRoYXQgcm9h
ZD8NCj4gDQo+IEl0IGRlcGVuZHMgb24gd2hhdCB5b3VyIGJpZ2dlciBwbGFuIGlzLiBBcmUgeW91
IHdvcmtpbmcgb24NCj4gaW1wcm92aW5nIHRoZSB2aG9zdCBkcml2ZXIgc3BlY2lmaWNhbGx5LCBv
ciBhcmUgeW91IHRyeWluZw0KPiB0byBraWxsIG9mZiB0aGUgX19nZXRfdXNlci9fX3B1dF91c2Vy
IGNhbGxzIGFjcm9zcyB0aGUNCj4gZW50aXJlIGtlcm5lbD8NCg0KSeKAmW0gd29ya2luZyBvbiB2
aG9zdCAvIHZpcnR1YWxpemVkIG5ldHdvcmtpbmcgaW1wcm92ZW1lbnRzDQphdCB0aGUgbW9tZW50
LCBub3QgdGhlIGJyb2FkZXIga2VybmVsIHdpZGUgd29yay4NCg0KTGludXMgbWVudGlvbmVkIGhl
IG1pZ2h0IGdldCBpbnRvIHRoZSBtaXggYW5kIGRvIGEgYnVsaw0KY2hhbmdlIGFuZCBraWxsIHRo
ZSB3aG9sZSB0aGluZyBvbmNlIGFuZCBmb3IgYWxsLCBzbyBJ4oCZbQ0Kc2ltcGx5IHRyeWluZyB0
byBoZWxwIGtub2NrIGFuIGluY3JlbWVudGFsIGFtb3VudCBvZiB3b3JrDQpvZmYgdGhlIHBpbGUg
aW4gYWR2YW5jZSBvZiB0aGF0IChhbmQgcmVhcCBzb21lIHBlcmZvcm1hbmNlDQpiZW5lZml0cyBh
dCB0aGUgc2FtZSB0aW1lLCBhdCBsZWFzdCBvbiB0aGUgeDg2IHNpZGUpLg0KDQpUaGFua3MgZm9y
IHRoZSBpbmZvIGFuZCBiYWNrIG4gZm9ydGggaGVyZSwgSSBhcHByZWNpYXRlIGl0IQ==

