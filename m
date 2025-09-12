Return-Path: <kvm+bounces-57415-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DEBFB55345
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 17:26:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4623D3B0D7A
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 15:25:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D13C155A4E;
	Fri, 12 Sep 2025 15:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="pa+1cIgZ";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="ZI3Ll9iy"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02568204096;
	Fri, 12 Sep 2025 15:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757690709; cv=fail; b=YbX6idP2ytf8yCxY0FoY2DGUDwGaHK1oQ7CEuwDvktRLbbAK0przzYvVk5mb76kokKqrPfT0OD7iRSvh7YcPVDAnVoLlpTWbD5WKgeo9u7/D0ee+cmUlVMUwyYcfTbyhuW2nsg1GUEnXi2ZMElkOHjnTQBdlY3YAroRAyoNU4yo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757690709; c=relaxed/simple;
	bh=5PIeZsSFJV1dujp0b8U5l86HPPVCHKNBSR/dQG4NZQA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IlvBT7bPE+IbLirC+p8LNSEnCRFDLRhSfKD7LTgwNAYa5mBx2w4kNRcGmof/ATOCEXdMDnh/n3Oi2kWgRY4CzL2ivZSB/VLSxb5fDoDpW4QqxfyR6212IhRCq3AQoJ8FUAzx+3i06MJ7sSn1KgSdmaH0cFJ1cx2tH/jNvHGeZDU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=pa+1cIgZ; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=ZI3Ll9iy; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 58CAqOVr097161;
	Fri, 12 Sep 2025 08:24:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=5PIeZsSFJV1dujp0b8U5l86HPPVCHKNBSR/dQG4NZ
	QA=; b=pa+1cIgZMG6r2n8mPfuhZJjpWCQko3K2jcnP9SjuddcL/mw5D9bfQslZ2
	kAqb0GXXS8yMP9uEuNC0unLvo06xqqJNlsZo2OGVkhhDGF7LMvRycwMChxKE9tHt
	aSmE73b/8RUp5C9nPRXUN6W+HqvQNygCygalv04KBMtTkO1VjX0cKcua4nh2dW1B
	U9J2KglA7yfX2ZUhiqqdsguWNJzfcE8TL0zWQRKsXNRC5Tl2v0huRJJ1ayyu/Vdv
	wCu3GlMzdAcmgZuffrswxAvpRCdO+xPX2DJ1IZPIKBMNwiKsVGrpNVAJU2lhE8uP
	l/vLr4xyul+6frYndPyaMKoq6QyZQ==
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11022089.outbound.protection.outlook.com [52.101.43.89])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4946ut1uu4-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 12 Sep 2025 08:24:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Om+8qtzo5Jb2csqW89RC7RU9nM+XzVBaw3CzJa7X/ftAlIAeF2Yf6WdW93068Nws62Z3IdfMk57Rj7hNyLiVwOm47bIzgzA/saHUeU/QYVQViANs+/C6WUN66UL8RlI3tbiR/MG6kogHg+Mhg1AJsaa+KtXhYlb0eTHduBdfL5Sqf0boWeuPdkdEexqdl1FyEZ+vkj/HToJdcpSv+VGXY8LBpBAa4blqzjJjDphGvRHRexx2riD/Yo7inQYZ8OhQL8d1ac3/4DyO1hJUbQFmhcmSWz8+SeGpCRKDal30/5gDzzAZ59QKZsAdqbmJs0K0qrVAGPTdggOS9CwqF6grWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5PIeZsSFJV1dujp0b8U5l86HPPVCHKNBSR/dQG4NZQA=;
 b=bazMzh8yFO0KMS0LMUMmj7/L4hgocjOYB2hVFaTYLpfLOIgbLLAywQiai7W5cJ7cJFNZufaxzNIoRwZWZE2lHPLoADwzYxfKUyOxcyFJAiBPFug1S8MrHjK6yrLo+vAXJb8sp1sNtn5yiiFK27naMCEa+Me3JNAL6W6WAc7xaAyFUaZ/ZMDP0NXajm4zlOrFuZgKmSvuRZ3LBNxOKAEUdk6wQn4AZcpOtViJUimX9BFRlqfvSuoJ+olDIm4vgH6O+IPbEe21MRVVLeAY8uTtN6V/qsuPF+KaxrFAYI+qqy81r0T5yCJdioJkULMuKpklUe90b2VJ+1UNInmFvNIS2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5PIeZsSFJV1dujp0b8U5l86HPPVCHKNBSR/dQG4NZQA=;
 b=ZI3Ll9iyfdhBP/EsVftJx4KcrsiSB2KLWK6xMnB0cFVQc/QJGQoQqrOc/dZPWyQIQ7gyYmECR5tr84aA1DTvaKzGPlvWXAiljvJPJ/Unc9s9Vk81neqIseb74i+xVMmNg6PTwoU7TidMGJyeyaI5iTTEi6wu1GOwmvTyVXGbQ40DQ0fOeu3rUNG5b+Q4u9OXwZcVIpX9CyfkKwuH3VSbAQsvyBFdB+siuBd2/DKyQA16ghzajjlvfAJg5jY7hdQ90TtQxEtuGSG9jgOos8Rh7hsnlYEw19NFDKqNY8uJq9USovrR1OXgcN2JgTfdjgjRWU/P2wDuEIte48ac2EPFgA==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by IA3PR02MB10544.namprd02.prod.outlook.com
 (2603:10b6:208:53b::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Fri, 12 Sep
 2025 15:24:42 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%5]) with mapi id 15.20.9094.021; Fri, 12 Sep 2025
 15:24:42 +0000
From: Jon Kohler <jon@nutanix.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Jason Wang <jasowang@redhat.com>,
        "eperezma@redhat.com"
	<eperezma@redhat.com>,
        "jonah.palmer@oracle.com" <jonah.palmer@oracle.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>,
        "virtualization@lists.linux.dev"
	<virtualization@lists.linux.dev>,
        "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org"
	<stable@vger.kernel.org>
Subject: Re: [PATCH net 2/2] vhost-net: correctly flush batched packet before
 enabling notification
Thread-Topic: [PATCH net 2/2] vhost-net: correctly flush batched packet before
 enabling notification
Thread-Index: AQHcI78QBWYHJwNr40+h8qu/MFb2LLSPPR2AgABuEIA=
Date: Fri, 12 Sep 2025 15:24:42 +0000
Message-ID: <63426904-881F-4725-96F5-3343389ED170@nutanix.com>
References: <20250912082658.2262-1-jasowang@redhat.com>
 <20250912082658.2262-2-jasowang@redhat.com>
 <20250912044523-mutt-send-email-mst@kernel.org>
In-Reply-To: <20250912044523-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.700.81)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV8PR02MB10287:EE_|IA3PR02MB10544:EE_
x-ms-office365-filtering-correlation-id: 127fe37c-6782-47a1-9cd5-08ddf2107f3e
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|1800799024|376014|366016|10070799003|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?NTVQcjFwb0E1c0x3czlDbnpNTUlqc0ZFeFBZMVl0VFBQdHZwMENUVHpHdU9Q?=
 =?utf-8?B?WVVSUHl0QURVYTY4bXd4VHNoa0RIZFg2QWpmYit3SVR5Z3NXd0U2WmZwU1ov?=
 =?utf-8?B?bEZFVUxDY1VhWHRZN1FnU0JOVTlNaWN6RUoyRWVBTEJuYTJrVVpzeXQreDU5?=
 =?utf-8?B?bmh4ODczUEw2UkszdzUvU2VVKzBoYlFiNVBzR1JWb2gyL2xCYkpUQVZJN3pG?=
 =?utf-8?B?UDF1b2U4R0pvTkx0MnVsRUw3enYvNGRxYlBCdFBzMVJDTEJvdk4zNHFwRGJD?=
 =?utf-8?B?L1QvdnIwV2lDdW00NnA4eEdnZFlmRVNlZnpyM3dRaUhPQzU3NlhnQVhkYncr?=
 =?utf-8?B?NlgweWN4b25IM243MTlvLzQ1V1kyU2drNGJPNUlubnVJZkxMSWcrT1UxanJM?=
 =?utf-8?B?citRN0VzaFRFejFCNlBoQWljdXVXQjFRUTN0amplbGxTeUM4eHRuZ2F0MlE3?=
 =?utf-8?B?b09XZGZacFpzejhrdVJnTEJSaVkrUkxHaGU2amt2Rk1MYzcrVEVjSzJleEJl?=
 =?utf-8?B?bDVjSktsVy9NeEw3ZUE3Um5nNHVWR3ZHZTRWUlNUcmNkdnFxbkRNL2J2bjJy?=
 =?utf-8?B?TVNtSDJTZURxUW1uQnhMNndRSEJMRXE3Z2p4REVPL3FpN25FczRVc01WZDFX?=
 =?utf-8?B?Y0RTeUNObks4VkhDcEoxYU9tOGNHbHRCSVZ4bysvSm42Y1Q5V09EQktLejV5?=
 =?utf-8?B?ekVTUlNKMS9VZHBEdlhCVjg4MmpZL3lESUVuVVlXQjQwbGR5cnptNTdVelV5?=
 =?utf-8?B?RVBQVG41K2FOMlhYdjBtQVdHTncxeWJYaG52LzFaaFY2Ujc4Z25oWWZibGI4?=
 =?utf-8?B?bGJ1U2QxcGUyMEFkVUk3Z0NtbDVFRS9mTEY4alhBNDQ1UnFPWEhRY1BTK25r?=
 =?utf-8?B?aTg0SUdaVWxQVWs4U29Ib3IxM1BvYjBnNS9mdHFRVmxnZkQyUHZRYklzUFB0?=
 =?utf-8?B?VzVqaElWa3llMHlVTk93L0pLUDJRUFY5d1Qrd3hLbEZqSzV5RGl4MmtkRmZ4?=
 =?utf-8?B?djRBR05kN1drSmJmVXlKNHNmdWtqbXJsNkdMVnZmVzhiNHBpcUNCRG5GSDNr?=
 =?utf-8?B?Vm11NHZWeHR3NU1sdGVQTzNjdndVUE01TnloSGtUNGQwbHN6N2ZWaEVMTDJC?=
 =?utf-8?B?Qnp6NkVOaTRwd0pHc3g5QmU1WHVOT1JvZ0xPcFBCWjNTTEIwQkpGNDhlQk9t?=
 =?utf-8?B?NHhxQkNKZjlJcnpGR2huWTIvOUpreUdRODFjQ2ZEcEo5VEUxZExSZVE3dFA1?=
 =?utf-8?B?dldIUmhNdXFIWkZOdWdaVzJRcFRwWFRnOFNNcWRjcFBIUHBnbnRDYkVHbzJV?=
 =?utf-8?B?T29JRUlYeVRKR25qcm1GTG1WU0pSUWloN1BLQmNhczBHRDFhbHdidTBNMVZa?=
 =?utf-8?B?cFZoeGxUSERPNVlGMjVhcXNMNGRGSzAyVytYU3NkTXBvR0tSTnZRZmVaMFhq?=
 =?utf-8?B?YlBTd0Z3ZkxER1k1RXFQbEI1MFRvNWxjLzJIN2NPUW81VTFXS29hQlZNMGFj?=
 =?utf-8?B?YlBEUjc2UXJNM3FhdGc5VWZRVTY4VE50dHpNRkhFZGZXVG15S2ZnRDB0UlFM?=
 =?utf-8?B?bjI2c1NsU0U5NTdDaFhNNFc4aDRvNy9lN0cxZUtGMENXelhuWjFDd3pETUF5?=
 =?utf-8?B?TmorVzRHSXZMcXJKZFlkM2UzVHV2SmhSK2RIcnVZZXVFcjd5Ti9aZnpOdjlm?=
 =?utf-8?B?alpJc3YvYnN0VHdkejlINUtYNk1GRG81TUJVSFJ6QWVKZFcrVVJjVFdXaFJw?=
 =?utf-8?B?T1c2WU1RQnpNSVhHbDhPVUdmYTF0Zm1rQ1M4dSt0dTk0aWN1ckorWVBqRlg5?=
 =?utf-8?B?U2VOZTVNTVIybk1OVU1ielA2VTZJYStBM1VnWE9tcDRteXFaTTNMUTBJU2Rm?=
 =?utf-8?B?bHZYZTN5dWdmL2RGUE5wY29ncFhsUGk5R3F3RWNERkZsQjcyU1I3eDBNdkdZ?=
 =?utf-8?B?U2VLNDNSaUZmZGlUb2t0WGNyb2dVMENhT296eXN2bTAzV1Bhd0k3TEpMVHor?=
 =?utf-8?Q?Qc29y5GTgFchnSCsfrcOQz4k5az5bo=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(10070799003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?aHduZWQzbHNRK3JTNjVwdU5qVTN1ZG9hMmNhMWxZQThjMnc5NmhQWXhDWThq?=
 =?utf-8?B?TjVSTnl0dmZCMUIzK0dIY1FQeVVEQ2NVd21kUG1wdFdjNThBZlZxVWhWUDN4?=
 =?utf-8?B?NlE5cUo5SjRNTWMxV1FXenlmK2lDRmRvWC9tdi9VODJFcjFpOWptTWc2WFVk?=
 =?utf-8?B?MnE1alN6SWh0VTBGVU5LSm9PVCs4d2JuTEhmRkpnUVNCazZVVUc2a1VFYVNP?=
 =?utf-8?B?UkNsQ203Z1ZZemRLdWZUM3lWbVZ5eHc0UklVK3ZwblJscFg0RTM2RkxlNlBM?=
 =?utf-8?B?RTZEY3EwQlgreFZMWkZNRXpldHhUNHZySUY1SmFOdDhoY1pqTnlnc0pvcGMz?=
 =?utf-8?B?cGdWZVFQbGNFNXlhYXRLOVJnSlBzeUFaZCtBck1idlVLdDBCR0pNckdwNWJD?=
 =?utf-8?B?VzNBQzdGcDNnZXV2RklxUXAycVhIbGdjM240b1c5cnJwNGtuWXFXMzRvWVk3?=
 =?utf-8?B?aTJSVXhDODJKSHNRVlpuWFY1ei9kNWUwaEpQNUtKeHh3ekZYcVF1aGJEZFhs?=
 =?utf-8?B?eEc1OWJ0SmN6L2VCTTVQODVUWktJSXRKVUQ2QmdpbXUza25aZGRMN2NBMm1n?=
 =?utf-8?B?R1VYVWNtSUYzNnd0SkNicGVzK1VlUXZqayt1YkhodWwySzRPRnJYUzFRZVdO?=
 =?utf-8?B?eHkwZGhlZUtydGxEQ2hRdU9VeDRENGczb3AxRTVsNXdibkRnb3JTRHlaYlpm?=
 =?utf-8?B?TjNLVmx2S1NFamtkZlkvcDFLOUZMY1hOSnA3VnhTTkRXb0xnajlKRit3QVZa?=
 =?utf-8?B?M3BvbTlrRUw1aUxNMXJvazlZcTlqZXB2RmYxYW5mT0E4dUUvNmo2aGtyN2NE?=
 =?utf-8?B?VzlYbVFZMGVtODBlQzNKanN1VlpLZzg0akZPMDUyajhoaEl6TG9XY1BzT1pT?=
 =?utf-8?B?S1JCUDErNmpGeUxldEtFUHZFQTMzUXNZOEpteUljeTI1V1NmY2ZOaWZCbnN5?=
 =?utf-8?B?ZWFjV0FUbEdoNnhPbkREeERrYmVYT0hrVGl1SzlTdzVidjVPcE1hUi9UQkE2?=
 =?utf-8?B?bGQ3ZjZJaEp1YmpvdXZXS2ZnakltR2xEUU5XZ2ZONXlyb3BMZVBXRTlrdmt6?=
 =?utf-8?B?c1VselhwV3d6aGtnN0RISTlFTjNSYjZMWU5MVFZmYzdHU205WnhRdE1Md0c4?=
 =?utf-8?B?U3Vtc01JZCt4Z2dUczE2LzZnRzBKcVlTZTRCQS9GV3dNdXdzd3g4SFQ3N3hI?=
 =?utf-8?B?L000bTRXUUozNDlWb09tY1QvKzlpY0JyMGx4VWdXQXBkZ3oxVHlITjNTSWE1?=
 =?utf-8?B?Q2JmZFRqb08xZHBjSmx1dkIrOUlOVG5RKzg5NjRIcGdVdVZIeGFxTWl5Q21C?=
 =?utf-8?B?RW9yczVhZGZ5K0pubDN5WWhXRDVUZlR2VFFzalNWQmgwaUZydEpMbW9vQ3hL?=
 =?utf-8?B?bHU3andualUxWWQ5YkhBL2dJays3YzZGdkozUkJQYjJic3UvTkxtbVI4R2lk?=
 =?utf-8?B?MjN2ZU9GQXU3Wlo0TXQ3YW00YkdpZ0Q1VUpQSlVXZTIxYW9oT1JScGszZ0t2?=
 =?utf-8?B?YVp3bERRSkVSMC9PQm9uZ2hvSjVSQm1yTE5HdDUxdEo2NERGRHB6Q2JISHB4?=
 =?utf-8?B?V2lnU2FMbmxWU0ZEbm8vQnU1L0dWNVNvTXRwSEhtQmM4b001aDlJaU1XRDlY?=
 =?utf-8?B?cGJ1RE02UGk4T2RHN0dyMGRwUXJ1KzM2YWVrS3UvOW13b3h2ekNrMTdDRGFP?=
 =?utf-8?B?SXNiNDVPSjk3VEdkZUpaekdVWTB6amxCTkZOOVA1bGdsdmJMdmFsQURzams1?=
 =?utf-8?B?RmZid1JWbFY5Z2c0N0pLTnFEUWozRlVrK2JnMzY4b0dhLzJyc3h4clZMTVps?=
 =?utf-8?B?Z1FlZ0lmeTZ0SFdqU1NDOXZwWGIralVTdjczcllhdmhyZDRFSWFMTnV1NU5r?=
 =?utf-8?B?b1BabE1yRXI3QWgxR0JrTGZISkExMW1hdkt2aS95SFRnZThPeXRCV2YwT0FN?=
 =?utf-8?B?R1BwN3ZFUzAwZHZoZkFLR3JiV3hhZzZHUmk5VGVsS1FpM2tYTm5wT1RFb3E0?=
 =?utf-8?B?WGdFc1Rad0N6blBYTmhObU9PYlM3QnptaUJrSVF3dmRkODdTYmh5eXlBQVNN?=
 =?utf-8?B?WjdQVXR5OHJwL3o4RjZUN3RLVDdoc2d4aFUxak9DWnMyY0g0UTZwYVkwMW1B?=
 =?utf-8?B?dVpwQmlvSHR2aUFMZXR6NVkveGpOY1N1dGV4VVUvVWFQc1F3UnNJSWtlTm1B?=
 =?utf-8?B?b3M2TFJUdm03MWxncXhzVFV1Yk9WR3FadXdyWW9UdWlQM2tEbzVYTUNzYXJx?=
 =?utf-8?B?WkFBU1lSR1R5RWdVb3UzUFBhd1JRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <618E6037768A9A46941A5391DFD0FCE4@namprd02.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 127fe37c-6782-47a1-9cd5-08ddf2107f3e
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2025 15:24:42.4288
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5GjDqjFQZY7L3qRrUsr+PmRfS147vaoUgk5F+A2+fopZgwhWV0RgI4J9bAT9hX0ROoXfjlm8CnNJmZ/lToKQbNliVdXFxnkUxF5NlmTpUdI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR02MB10544
X-Authority-Analysis: v=2.4 cv=N+MpF39B c=1 sm=1 tr=0 ts=68c43b3d cx=c_pps
 a=ebY7fRpV/2+SmvP/Q3YtXw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=0kUYKlekyDsA:10 a=20KFwNOVAAAA:8 a=64Cc0HZtAAAA:8
 a=VwQbUJbxAAAA:8 a=4iP_89sOV2JIjznwk0sA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: o99qE7wmoJYpLUl7jK1eyj1FeuVhowQ4
X-Proofpoint-ORIG-GUID: o99qE7wmoJYpLUl7jK1eyj1FeuVhowQ4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEyMDE0MSBTYWx0ZWRfX1wGtN/S9Bmkl
 MBBHOvfTOkAxjE+0X/V4HESdNO3+SwL2wnwYwBsEdVazG8xfEj5mV9czY/yNkcAIIWT9x4L6XUI
 NLOBLxuY6AMXCV91PG9UusRjv0YxuYB67SsB+PyMueeXIg4ofR+jWiUumlKxtqdQNQOOU6jr7Tf
 hwX+jVQ2+yNn9DDqH3ZW+K9mi+OdE4UXYUTuaRpuYbp1AKQXrZojjNTBDf61Vb0U9bUaw9J3X2u
 67ScygxVmqsTL9jpFiNJUQuMSgCHB/U2SFyPUnvuBJpCgw/GaIoqQVwORZnVaKYtm1n1B4qV6Dy
 Vu6nQ+hWTf4H3mc7tYxkdiC0ppoqmM/yd3hVz3Em90p566udF8lv8YvBzkrU6Q=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-12_05,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gU2VwIDEyLCAyMDI1LCBhdCA0OjUw4oCvQU0sIE1pY2hhZWwgUy4gVHNpcmtpbiA8
bXN0QHJlZGhhdC5jb20+IHdyb3RlOg0KPiANCj4gIS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS18DQo+ICBDQVVUSU9OOiBF
eHRlcm5hbCBFbWFpbA0KPiANCj4gfC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0hDQo+IA0KPiBPbiBGcmksIFNlcCAxMiwg
MjAyNSBhdCAwNDoyNjo1OFBNICswODAwLCBKYXNvbiBXYW5nIHdyb3RlOg0KPj4gQ29tbWl0IDhj
MmU2YjI2ZmZlMiAoInZob3N0L25ldDogRGVmZXIgVFggcXVldWUgcmUtZW5hYmxlIHVudGlsIGFm
dGVyDQo+PiBzZW5kbXNnIikgdHJpZXMgdG8gZGVmZXIgdGhlIG5vdGlmaWNhdGlvbiBlbmFibGlu
ZyBieSBtb3ZpbmcgdGhlIGxvZ2ljDQo+PiBvdXQgb2YgdGhlIGxvb3AgYWZ0ZXIgdGhlIHZob3N0
X3R4X2JhdGNoKCkgd2hlbiBub3RoaW5nIG5ldyBpcw0KPj4gc3BvdHRlZC4gVGhpcyB3aWxsIGJy
aW5nIHNpZGUgZWZmZWN0cyBhcyB0aGUgbmV3IGxvZ2ljIHdvdWxkIGJlIHJldXNlZA0KPj4gZm9y
IHNldmVyYWwgb3RoZXIgZXJyb3IgY29uZGl0aW9ucy4NCj4+IA0KPj4gT25lIGV4YW1wbGUgaXMg
dGhlIElPVExCOiB3aGVuIHRoZXJlJ3MgYW4gSU9UTEIgbWlzcywgZ2V0X3R4X2J1ZnMoKQ0KPj4g
bWlnaHQgcmV0dXJuIC1FQUdBSU4gYW5kIGV4aXQgdGhlIGxvb3AgYW5kIHNlZSB0aGVyZSdzIHN0
aWxsIGF2YWlsYWJsZQ0KPj4gYnVmZmVycywgc28gaXQgd2lsbCBxdWV1ZSB0aGUgdHggd29yayBh
Z2FpbiB1bnRpbCB1c2Vyc3BhY2UgZmVlZCB0aGUNCj4+IElPVExCIGVudHJ5IGNvcnJlY3RseS4g
VGhpcyB3aWxsIHNsb3dkb3duIHRoZSB0eCBwcm9jZXNzaW5nIGFuZCBtYXkNCj4+IHRyaWdnZXIg
dGhlIFRYIHdhdGNoZG9nIGluIHRoZSBndWVzdC4NCj4gDQo+IEl0J3Mgbm90IHRoYXQgaXQgbWln
aHQuDQo+IFBscyBjbGFyaWZ5IHRoYXQgaXQgKmhhcyBiZWVuIHJlcG9ydGVkKiB0byBkbyBleGFj
dGx5IHRoYXQsDQo+IGFuZCBhZGQgYSBsaW5rIHRvIHRoZSByZXBvcnQuDQo+IA0KPiANCj4+IEZp
eGluZyB0aGlzIGJ5IHN0aWNrIHRoZSBub3RpZmljYWl0b24gZW5hYmxpbmcgbG9naWMgaW5zaWRl
IHRoZSBsb29wDQo+PiB3aGVuIG5vdGhpbmcgbmV3IGlzIHNwb3R0ZWQgYW5kIGZsdXNoIHRoZSBi
YXRjaGVkIGJlZm9yZS4NCj4+IA0KPj4gUmVwb3J0ZWQtYnk6IEpvbiBLb2hsZXIgPGpvbkBudXRh
bml4LmNvbT4NCj4+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+PiBGaXhlczogOGMyZTZi
MjZmZmUyICgidmhvc3QvbmV0OiBEZWZlciBUWCBxdWV1ZSByZS1lbmFibGUgdW50aWwgYWZ0ZXIg
c2VuZG1zZyIpDQo+PiBTaWduZWQtb2ZmLWJ5OiBKYXNvbiBXYW5nIDxqYXNvd2FuZ0ByZWRoYXQu
Y29tPg0KPiANCj4gU28gdGhpcyBpcyBtb3N0bHkgYSByZXZlcnQsIGJ1dCB3aXRoDQo+ICAgICAg
ICAgICAgICAgICAgICAgdmhvc3RfdHhfYmF0Y2gobmV0LCBudnEsIHNvY2ssICZtc2cpOw0KPiBh
ZGRlZCBpbiB0byBhdm9pZCByZWdyZXNzaW5nIHBlcmZvcm1hbmNlLg0KPiANCj4gSWYgeW91IGRv
IG5vdCB3YW50IHRvIHN0cnVjdHVyZSBpdCBsaWtlIHRoaXMgKHJldmVydCtvcHRpbWl6YXRpb24p
LA0KPiB0aGVuIHBscyBtYWtlIHRoYXQgY2xlYXIgaW4gdGhlIG1lc3NhZ2UuDQo+IA0KPiANCj4+
IC0tLQ0KPj4gZHJpdmVycy92aG9zdC9uZXQuYyB8IDMzICsrKysrKysrKysrKystLS0tLS0tLS0t
LS0tLS0tLS0tLQ0KPj4gMSBmaWxlIGNoYW5nZWQsIDEzIGluc2VydGlvbnMoKyksIDIwIGRlbGV0
aW9ucygtKQ0KPj4gDQo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy92aG9zdC9uZXQuYyBiL2RyaXZl
cnMvdmhvc3QvbmV0LmMNCj4+IGluZGV4IDE2ZTM5ZjNhYjk1Ni4uMzYxMWI3NTM3OTMyIDEwMDY0
NA0KPj4gLS0tIGEvZHJpdmVycy92aG9zdC9uZXQuYw0KPj4gKysrIGIvZHJpdmVycy92aG9zdC9u
ZXQuYw0KPj4gQEAgLTc2NSwxMSArNzY1LDExIEBAIHN0YXRpYyB2b2lkIGhhbmRsZV90eF9jb3B5
KHN0cnVjdCB2aG9zdF9uZXQgKm5ldCwgc3RydWN0IHNvY2tldCAqc29jaykNCj4+IGludCBlcnI7
DQo+PiBpbnQgc2VudF9wa3RzID0gMDsNCj4+IGJvb2wgc29ja19jYW5fYmF0Y2ggPSAoc29jay0+
c2stPnNrX3NuZGJ1ZiA9PSBJTlRfTUFYKTsNCj4+IC0gYm9vbCBidXN5bG9vcF9pbnRyOw0KPj4g
Ym9vbCBpbl9vcmRlciA9IHZob3N0X2hhc19mZWF0dXJlKHZxLCBWSVJUSU9fRl9JTl9PUkRFUik7
DQo+PiANCj4+IGRvIHsNCj4+IC0gYnVzeWxvb3BfaW50ciA9IGZhbHNlOw0KPj4gKyBib29sIGJ1
c3lsb29wX2ludHIgPSBmYWxzZTsNCj4+ICsNCj4+IGlmIChudnEtPmRvbmVfaWR4ID09IFZIT1NU
X05FVF9CQVRDSCkNCj4+IHZob3N0X3R4X2JhdGNoKG5ldCwgbnZxLCBzb2NrLCAmbXNnKTsNCj4+
IA0KPj4gQEAgLTc4MCwxMCArNzgwLDE4IEBAIHN0YXRpYyB2b2lkIGhhbmRsZV90eF9jb3B5KHN0
cnVjdCB2aG9zdF9uZXQgKm5ldCwgc3RydWN0IHNvY2tldCAqc29jaykNCj4+IGJyZWFrOw0KPj4g
LyogTm90aGluZyBuZXc/ICBXYWl0IGZvciBldmVudGZkIHRvIHRlbGwgdXMgdGhleSByZWZpbGxl
ZC4gKi8NCj4+IGlmIChoZWFkID09IHZxLT5udW0pIHsNCj4+IC0gLyogS2lja3MgYXJlIGRpc2Fi
bGVkIGF0IHRoaXMgcG9pbnQsIGJyZWFrIGxvb3AgYW5kDQo+PiAtICogcHJvY2VzcyBhbnkgcmVt
YWluaW5nIGJhdGNoZWQgcGFja2V0cy4gUXVldWUgd2lsbA0KPj4gLSAqIGJlIHJlLWVuYWJsZWQg
YWZ0ZXJ3YXJkcy4NCj4+ICsgLyogRmx1c2ggYmF0Y2hlZCBwYWNrZXRzIGJlZm9yZSBlbmFibGlu
Zw0KPj4gKyAqIHZpcnF0dWV1ZSBub3RpZmljYXRpb24gdG8gcmVkdWNlDQo+PiArICogdW5uZWNz
c2FyeSB2aXJ0cXVldWUga2lja3MuDQo+IA0KPiB0eXBvczogdmlydHF1ZXVlLCB1bm5lY2Vzc2Fy
eQ0KPiANCj4+ICovDQo+PiArIHZob3N0X3R4X2JhdGNoKG5ldCwgbnZxLCBzb2NrLCAmbXNnKTsN
Cj4+ICsgaWYgKHVubGlrZWx5KGJ1c3lsb29wX2ludHIpKSB7DQo+PiArIHZob3N0X3BvbGxfcXVl
dWUoJnZxLT5wb2xsKTsNCj4+ICsgfSBlbHNlIGlmICh1bmxpa2VseSh2aG9zdF9lbmFibGVfbm90
aWZ5KCZuZXQtPmRldiwNCj4+ICsgdnEpKSkgew0KPj4gKyB2aG9zdF9kaXNhYmxlX25vdGlmeSgm
bmV0LT5kZXYsIHZxKTsNCj4+ICsgY29udGludWU7DQo+PiArIH0NCj4+IGJyZWFrOw0KPj4gfQ0K
DQpTZWUgbXkgY29tbWVudCBiZWxvdywgYnV0IGhvdyBhYm91dCBzb21ldGhpbmcgbGlrZSB0aGlz
Pw0KIAkJaWYgKGhlYWQgPT0gdnEtPm51bSkgew0KCQkJLyogRmx1c2ggYmF0Y2hlZCBwYWNrZXRz
IGJlZm9yZSBlbmFibGluZw0KCQkJICogdmlydHF1ZXVlIG5vdGlmaWNhdGlvbiB0byByZWR1Y2UN
CgkJCSAqIHVubmVjZXNzYXJ5IHZpcnRxdWV1ZSBraWNrcy4NCgkJCSAqLw0KCQkJdmhvc3RfdHhf
YmF0Y2gobmV0LCBudnEsIHNvY2ssICZtc2cpOw0KCQkJaWYgKHVubGlrZWx5KGJ1c3lsb29wX2lu
dHIpKQ0KCQkJCS8qIElmIGludGVycnVwdGVkIHdoaWxlIGRvaW5nIGJ1c3kgcG9sbGluZywNCgkJ
CQkgKiByZXF1ZXVlIHRoZSBoYW5kbGVyIHRvIGJlIGZhaXIgaGFuZGxlX3J4DQoJCQkJICogYXMg
d2VsbCBhcyBvdGhlciB0YXNrcyB3YWl0aW5nIG9uIGNwdS4NCgkJCQkgKi8NCgkJCQl2aG9zdF9w
b2xsX3F1ZXVlKCZ2cS0+cG9sbCk7DQoJCQllbHNlDQoJCQkJLyogQWxsIG9mIG91ciB3b3JrIGhh
cyBiZWVuIGNvbXBsZXRlZDsNCgkJCQkgKiBob3dldmVyLCBiZWZvcmUgbGVhdmluZyB0aGUgVFgg
aGFuZGxlciwNCgkJCQkgKiBkbyBvbmUgbGFzdCBjaGVjayBmb3Igd29yaywgYW5kIHJlcXVldWUN
CgkJCQkgKiBoYW5kbGVyIGlmIG5lY2Vzc2FyeS4gSWYgdGhlcmUgaXMgbm8gd29yaywNCgkJCQkg
KiBxdWV1ZSB3aWxsIGJlIHJlZW5hYmxlZC4NCgkJCQkgKi8NCgkJCQl2aG9zdF9uZXRfYnVzeV9w
b2xsX3RyeV9xdWV1ZShuZXQsIHZxKTsNCiAJCQlicmVhazsNCiAJCX0NCg0KDQo+PiANCj4+IEBA
IC04MzksMjIgKzg0Nyw3IEBAIHN0YXRpYyB2b2lkIGhhbmRsZV90eF9jb3B5KHN0cnVjdCB2aG9z
dF9uZXQgKm5ldCwgc3RydWN0IHNvY2tldCAqc29jaykNCj4+ICsrbnZxLT5kb25lX2lkeDsNCj4+
IH0gd2hpbGUgKGxpa2VseSghdmhvc3RfZXhjZWVkc193ZWlnaHQodnEsICsrc2VudF9wa3RzLCB0
b3RhbF9sZW4pKSk7DQo+PiANCj4+IC0gLyogS2lja3MgYXJlIHN0aWxsIGRpc2FibGVkLCBkaXNw
YXRjaCBhbnkgcmVtYWluaW5nIGJhdGNoZWQgbXNncy4gKi8NCj4+IHZob3N0X3R4X2JhdGNoKG5l
dCwgbnZxLCBzb2NrLCAmbXNnKTsNCj4+IC0NCj4+IC0gaWYgKHVubGlrZWx5KGJ1c3lsb29wX2lu
dHIpKQ0KPj4gLSAvKiBJZiBpbnRlcnJ1cHRlZCB3aGlsZSBkb2luZyBidXN5IHBvbGxpbmcsIHJl
cXVldWUgdGhlDQo+PiAtICogaGFuZGxlciB0byBiZSBmYWlyIGhhbmRsZV9yeCBhcyB3ZWxsIGFz
IG90aGVyIHRhc2tzDQo+PiAtICogd2FpdGluZyBvbiBjcHUuDQo+PiAtICovDQo+PiAtIHZob3N0
X3BvbGxfcXVldWUoJnZxLT5wb2xsKTsNCj4+IC0gZWxzZQ0KPj4gLSAvKiBBbGwgb2Ygb3VyIHdv
cmsgaGFzIGJlZW4gY29tcGxldGVkOyBob3dldmVyLCBiZWZvcmUNCj4+IC0gKiBsZWF2aW5nIHRo
ZSBUWCBoYW5kbGVyLCBkbyBvbmUgbGFzdCBjaGVjayBmb3Igd29yaywNCj4+IC0gKiBhbmQgcmVx
dWV1ZSBoYW5kbGVyIGlmIG5lY2Vzc2FyeS4gSWYgdGhlcmUgaXMgbm8gd29yaywNCj4+IC0gKiBx
dWV1ZSB3aWxsIGJlIHJlZW5hYmxlZC4NCj4+IC0gKi8NCj4+IC0gdmhvc3RfbmV0X2J1c3lfcG9s
bF90cnlfcXVldWUobmV0LCB2cSk7DQoNCk5vdGU6IHRoZSB1c2Ugb2Ygdmhvc3RfbmV0X2J1c3lf
cG9sbF90cnlfcXVldWUgd2FzIGludGVudGlvbmFsIGluIG15DQpwYXRjaCBhcyBpdCB3YXMgY2hl
Y2tpbmcgdG8gc2VlIGJvdGggY29uZGl0aW9uYWxzLg0KDQpDYW4gd2Ugc2ltcGx5IGhvaXN0IG15
IGxvZ2ljIHVwIGluc3RlYWQ/DQoNCj4+IH0NCj4+IA0KPj4gc3RhdGljIHZvaWQgaGFuZGxlX3R4
X3plcm9jb3B5KHN0cnVjdCB2aG9zdF9uZXQgKm5ldCwgc3RydWN0IHNvY2tldCAqc29jaykNCj4+
IC0tIA0KPj4gMi4zNC4xDQo+IA0KDQpUZXN0ZWQtYnk6IEpvbiBLb2hsZXIgPGpvbkBudXRhbml4
LmNvbSA8bWFpbHRvOmpvbkBudXRhbml4LmNvbT4+DQoNClRyaWVkIHRoaXMgb3V0IG9uIGEgNi4x
NiBob3N0IC8gZ3Vlc3QgdGhhdCBsb2NrZWQgdXAgd2l0aCBpb3RsYiBtaXNzIGxvb3AsDQphcHBs
aWVkIHRoaXMgcGF0Y2ggYW5kIGFsbCB3YXMgd2VsbC4g

