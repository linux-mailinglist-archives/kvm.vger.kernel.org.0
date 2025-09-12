Return-Path: <kvm+bounces-57420-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 11491B553DE
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 17:41:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4833B1D64CE0
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 15:41:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F0DF314A6A;
	Fri, 12 Sep 2025 15:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="rhYgc7yV";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="S2bfJBLJ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9700013AA2F;
	Fri, 12 Sep 2025 15:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757691658; cv=fail; b=SejRs6s2duVe8dL30wRZ92gRO4cdygr2A5U+g2hJJs76m0Dyy1jJN6eHFytsjt7KTxOjAvufpyKxYVIRuqjCr0YuuYdFcgbISmS7Hs4GVKcojnxMlt8ULD1L9pZqDR7DxNFrlAME8y1OdRuWBxgNu0hmUo7Y7Y0Hj536F7NEwxY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757691658; c=relaxed/simple;
	bh=au87iKs8VwCoXJEPayLkvCzr103p7J4w4d4jI7LhnRc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WqOmAPUIB+TYSr52FZ1oCNjQhGfe0t7GHZkPfpe1F7GH/gjgyKKbm4rIa1BjvWjuKyY+ivRWjQEObcERULKsED91S1oFT36VepnR4+5mZjDAKxYM9GPm3w2cCIu4aAN+0+8j270g1X6jhBu7XTfhzmC9uP+7kwpnc9o88MHizOo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=rhYgc7yV; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=S2bfJBLJ; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 58CB0Qbs140322;
	Fri, 12 Sep 2025 08:40:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=au87iKs8VwCoXJEPayLkvCzr103p7J4w4d4jI7Lhn
	Rc=; b=rhYgc7yVAQIDw2ORkyjAtXmX1VOuzuqNEA1iPQ97qR1L0ZkX+orL+TbKg
	It6nYkvaZOIoZxKDT9Bs9jRSZWff09jpLhW7khER+X5BsH10m3ngevqKZvNvlcRq
	fDtH2j8x2PfX9oDAS3VWX4tYzBNodlNRwb46VXB59Jxh3Pwjd1ANp4eHFBMzJfUA
	70j9Ovxq55T1WEB7cslqTJDIEFYPwvFT2/bkgGojk/KJxRcozQhhcmr/ODFjRTrk
	7AU3zVhhPia/3w8MEqRr4mmUQBZ76Ro9mmmaJp71eO7j7QNZ2cVZ8CHnD7+gkdH5
	7oTOuMd/X9H/SowaAVRIom34pEZFg==
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11022093.outbound.protection.outlook.com [52.101.43.93])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4946ushu0x-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 12 Sep 2025 08:40:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CEti8c6ktIaRWcWdAAD3D/9fqo55XSpAaCDu/xvUG4f9XLBX6bMfGNKWeyzNG21L6pbI0P8b5lsAsi/1mIQtkrO2/Pqg0ZSmfL00EF2xyFQttBXTvuhTQEA5LTYfMogE62rx2QGq51oHHgNFtmGIpH7yuXzgRxCWIa/J7dqkCCqvuXzcrTa5kfwedBm6T+5QAfX6WJEog+W5xpyZpMLo+S425/36K5+vJv7R3dxmm09PgnJGcqkHget/Xr0eHSvrkAVga3v61zAEAiiBKsIm3IoKRSbSGVztJ6EwVE2nHZkDLpu0dNeHp1RMWhoZQ+ovv9A2yP3mpY2pDiP+p0Kuqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=au87iKs8VwCoXJEPayLkvCzr103p7J4w4d4jI7LhnRc=;
 b=tz07WcKZ9LgsJoCdBVLzVj7CYSGNkhruNv7/M+6y/pOVrH+0nZKpGLMozB1zANAMkJZE3GPAa243kyYQsQeASSfy2YumhQTsU2J4th2GulLvkdlYybo7e15amE9SVQL6GH4YgM3yQOOGU14Bv966ubddAj8APyuD39+XszhqNpHm+yjS5w4fOqkm6PpqOs5MpsVQvWKi0E3r+oNBApqHXsQd2HIQCIY0Gab62YpYIa4o/VGmQNXMZlVjrvICAKPUkDb1cj0aieHA+1tyM00VeNUw6Xrkz4Kq3LHjLhmWEBKLphD44kN6eO5V1mdhLqfOhphEIlTMD+7ZN0fLPjTkGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=au87iKs8VwCoXJEPayLkvCzr103p7J4w4d4jI7LhnRc=;
 b=S2bfJBLJy2J4UQqzBvqOHCyQprVpz/E5vsAXkxYA5olv/kTCmTkKs4qr04uo18xzyiGSIJNNVqzLhJZB6ekU4YlXjJmwCb8Q4XX/+BwOnAejKCU3qZq0EhHAN7eUUUddXC1BpYyHucclvV+Z5USpcukAXPPWtL6ssnNVF8QE1jAWnQFqDo0G7WtaM1sHV89g1XSU1kJO30h6pBlLgzo7bxDpSCV6+HPKicQdTRtuWfWFOZKAFA/uIIeC1x9IgskRCBRmztmcEyVTIwnZeSlNxQHqlHBSY+qSGpy8v84Aymjn9E6DdjrGU3ZmZ8rJyrq6C87l77CeTCeqOYo0kauMIA==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by DS0PR02MB10967.namprd02.prod.outlook.com
 (2603:10b6:8:293::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.18; Fri, 12 Sep
 2025 15:40:31 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%5]) with mapi id 15.20.9094.021; Fri, 12 Sep 2025
 15:40:31 +0000
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
Thread-Index:
 AQHcI78QBWYHJwNr40+h8qu/MFb2LLSPPR2AgABuEICAAAGXAIAAAOGAgAABdQCAAAB/AA==
Date: Fri, 12 Sep 2025 15:40:31 +0000
Message-ID: <A515A019-08B7-4D4E-A341-F1AA4407BCE4@nutanix.com>
References: <20250912082658.2262-1-jasowang@redhat.com>
 <20250912082658.2262-2-jasowang@redhat.com>
 <20250912044523-mutt-send-email-mst@kernel.org>
 <63426904-881F-4725-96F5-3343389ED170@nutanix.com>
 <20250912112726-mutt-send-email-mst@kernel.org>
 <4418BA21-716E-468B-85EB-DB88CCD64F38@nutanix.com>
 <20250912113432-mutt-send-email-mst@kernel.org>
In-Reply-To: <20250912113432-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.700.81)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV8PR02MB10287:EE_|DS0PR02MB10967:EE_
x-ms-office365-filtering-correlation-id: cc938bf6-7636-452b-0acf-08ddf212b4b9
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|366016|10070799003|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?Q3dwZ09JZlI5NmpkU2dVOFdacDdUaVJneERtckNTNlBGWVdDd3BMOWdySlFx?=
 =?utf-8?B?c3Q4TkVYUGNselQ0QmludlR2M2k2Rm13YkYxYVJBVHpzVnVHRCtBejlReUY0?=
 =?utf-8?B?VEE1aEtvdTZVMmVEZ0ZHNHZVOVBueS9McjhNYW9RVGNMQTc4T0d0RW15SjRB?=
 =?utf-8?B?a0RBeTMxT1BZcGRuMXlXSzRHdHowb21IQlRqYmQyalZqTlFxNGdGUUpVaFg2?=
 =?utf-8?B?ZWg1eVBkMDZZQ214RW1qNGFyOEVVbEVGL0djZTlySlNDK2Zmam9JRTdWcTVO?=
 =?utf-8?B?cmFQbFNMaEowMXNveTlIVkkxdG5kMzYzdmpxTXg1RXdmWkcxc0M1QSs4TG9W?=
 =?utf-8?B?Uzk1LzltZVVBSGV0WFVrTzhpVTJTcUlyTjNBd0lJWTJFSnZGRkdhVU16Ymk5?=
 =?utf-8?B?VkFFdGx1NkFFV1VGQTFJN0tLcWdSYUNUWjBoa3BNQmxJaWlpTDJ1eWd3U0E3?=
 =?utf-8?B?V1RvdFdoOFNJeHJ0dmNrcExPb01rcjdkK0p4azJmNGFEM0ZYd09PY0xNaTh1?=
 =?utf-8?B?TitCN1AxcUlsSGttaUNmSldXUThwTGpxN2pmWTR4eXlNY0hWazJnbXZiSnJP?=
 =?utf-8?B?SXhHU2dZaVVQRXcwckJRQUNWNCtJZlJjQ2kyM1RjVWJsSi90clhaN3dmNG9V?=
 =?utf-8?B?R3U3UzFRenJxQVpEQkdSa2dnNDFUcUVsNVk0ZDhJWW9IWEMrMDFzOHJpdWFm?=
 =?utf-8?B?TUNnNHRkeXppSHZaV21SN0Z5aHBEMGpjY3I2Q25HdzFhLzYvMjliV0pLeVh5?=
 =?utf-8?B?UGhiUS9NMUsvakNTUEd5RWRzVlpMZkMvb0I5ZDkxUGpSTk9wazBWYU5VZmE5?=
 =?utf-8?B?ZWVJU0pHRGhkOWEvd0lWbWI5SkpkVkNpM1hiMERsZUcvMXNPZUhxOWNpR1RY?=
 =?utf-8?B?SVZtOGErVEtNUExiczNnWnFuRTNVSG1kTkZnZGl5SEh1bU1PYXhuOCtQS1FR?=
 =?utf-8?B?MGV4akNTTWVqWWUwWjhiTmMwVllQUlR2OXFCSlhmR3hNTnRLU3Zxc3BWM0Np?=
 =?utf-8?B?UmhZRDQ1KzMrajVkeU1BYXVkdWNNZ0tPcE9uOXM1OG9TS0MrZ0dtS1Z6aVdU?=
 =?utf-8?B?ekRoZnlUR09MQkk0Sjd1ZlEzYVBrbHZ6bU5jTGsxeHluMVNjOElvajhkdXVB?=
 =?utf-8?B?a3d2ZEtCS3hpZjJLUEcrUEtGVTQ1TjhRMlhSVFVOMS9VR3BVeUVuZmNpRXoy?=
 =?utf-8?B?Ykp3czVhQ2cwRXA0SHNKbzF2VjJuVUNyOW9BbjNTbUk4VmJBekpKT0VUN0lN?=
 =?utf-8?B?TkxGZW1OeTk3S1JpeXBQMStReDJMQlYranpiYWtZRERwU1FCeHlLY01vWklD?=
 =?utf-8?B?NVpIYnhMUGdwMHlKSW9GMU5WKy9GMGd4aXNSUE5RU1dkQldMaVV5VFR5bzU5?=
 =?utf-8?B?Z3dXZkJyV09HV3lnWVlFellYd0d3aDZ0VTN0dGJSSzI1Q0xzM0lOT0lEMFBR?=
 =?utf-8?B?RUZGek5LNlVSQkdmQzk2YnhHdHF4R1RpdHYxeGs2ZHU1eVJDSUwxclpJVTdB?=
 =?utf-8?B?aWlVeWlSVytLNlZCbTY4WjAreWFIbWUyQ0Y3S3IzNC9lT09RYy9jZ2VWUHNm?=
 =?utf-8?B?U3dUa2IzOVFXdnZRalNFVkRwaGwrOFNmVVZLTmVlbG02ZUpHWE9xbVFpMGtx?=
 =?utf-8?B?NUJEYXNUdkNzeUVtNE5pTU1XZERneC8rZFozZi9lRUxkQUZ5TUdJdlNqNkRp?=
 =?utf-8?B?dDJYcUMrWGpGdVNlRkd6dmpYa1ZsSTlwTDZCYlFqZWh2TXRDbWdDY0RXbDdo?=
 =?utf-8?B?d0c0Q2ZCdkd2ZXNySUVzbm5VMWsvM0JHVm9XcGlnQ200dG40U2J1bEt6NDVr?=
 =?utf-8?B?RXlGVFRVa3JRQVZkQjhzempXT21KZnhheVYzZVVKNmp4S0REMy9LaFB0VnRm?=
 =?utf-8?B?bWd6V0djcVF2eEpwWUlSbzRBeEdDSThaYWJhWXkyNUoyZEtWaURjL0gzdXgr?=
 =?utf-8?B?d2M5NVdzdlVBaFJzVUhZSmp1dmZ3Q09Oc01LRGxySm1zeWJqQjMraTdDV2JG?=
 =?utf-8?Q?nwvVS3Nca4gani0qcn7H2l3py3WHW8=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(10070799003)(1800799024)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?VGgrK3Z4akNwQnJzSWNOOEIzZmlGN2xlREpac0xFQ2t2YUJHcFN3Q21XV2VB?=
 =?utf-8?B?UXd6R0plYloyZkY3d1pFU1NYTVJmWHFSNHlnV0V1M3g1U2lzbERLYnMybFN5?=
 =?utf-8?B?UHZqMGhVMnBaNHlMYXN6aWdaY1gzRXJhOUFhMHpaa2xTeExybzVPbDZaR2xM?=
 =?utf-8?B?L0FGOFBhWWlXd3MrVDdUcG9MZzc5bVVUMjJUNnNtWGVrdnJDZVhlaDJkVVRP?=
 =?utf-8?B?bkk5UHFrWGlJMEFOaUhqNlY0KzJDeGRTR3dOU0pXd3Jha3htbWVoaFVQcHR5?=
 =?utf-8?B?WWE3L1FldkFiZDZKelVnVEh3bEJuTU1ydUJMMzRDd1RNS2xxOWRzQ245R3Bh?=
 =?utf-8?B?SVdSM0p4cGxOVW1HQ3RQVXV0VnhBaGEzei9CdnVJdGJ1Z05QUE8xVy9nSTh5?=
 =?utf-8?B?UElIOW9OM3pJZThwcU8yWXBBTUJNd1ViK2pIcUhjdFJMcEtScWFZYll2Z1Ew?=
 =?utf-8?B?MWhGbkQ0S00yWXo2NlozL1FiSHVqQnNPeDhYWkljM29HU1g1WkU2RHE2VzJ1?=
 =?utf-8?B?ZHROcHVsd1BTS3U2aHJqZkJYS3VyTzBYT2NuL084NmFZRmFxOWh3L1h1bkYy?=
 =?utf-8?B?WDdMTnNZNXNVbjdwdUV3dkZkczFOQmRqMUo2VzAyR3pYQ2VNRC9MU0x6VjN0?=
 =?utf-8?B?aysvbWRKMzVRZ0g0QXc3cXEvQVB2cHJTYzRNZWViMVVZODlmcU1rTFJOc0Jt?=
 =?utf-8?B?eWc3dU04c1ZucnRmL2EwY0xRKzJhMEV4ckdJMUhEZUMxa2Zua0lrWFd6aEk4?=
 =?utf-8?B?TmlMT1dRZUU0b1RuemNoWjVIU0diQjEybTN0eGQ4T2d5K2p0bWNJdXZyUzdt?=
 =?utf-8?B?T2FseFlwaDVMREhyRWU0TnhBYUhQb29kOWtYU21sTkMzZ1JvYUR6SlBJUjZl?=
 =?utf-8?B?a0ZSZm9mMm1qSDhmd0ZJYjFPZXJRVExCY2JIcC93QTltTzZpa0tqVjhTTVFa?=
 =?utf-8?B?OVFEb28rbHZGMkZXSUdjNE9CdHJZNFlFQzdQL2l1UHJ3Z2E5TmFTdTlGUi93?=
 =?utf-8?B?QjBWTDEyYjczbVkxM0ZHTkUyL3RZVlg4eExWdGRtNTB4bE05eG9VMWR1SzJN?=
 =?utf-8?B?dzl6K05WOE1YMUphcnNlRTIvR2NsU1p2NWNDNWF2UmNrN2ZEOEs5b2sxUHlJ?=
 =?utf-8?B?TmVYNUp1VzBMVFBjQlY4WDhqM3RHUkpFSjhIU043ZzFaakliVFRaeFAzY1Fn?=
 =?utf-8?B?Y3YxU2pTa1hoOFg5UWVLSnZPZXZhbm5ValVXWE1CSkxVeW54Wm5lbUhLaWRF?=
 =?utf-8?B?MVpnaU4zOHUzaTlmclVnSm9ud2ZuZTd4RGRIbllUNzN4cmQ3UmVsYXlnR2xJ?=
 =?utf-8?B?K2xkTzdGMElEbHB0VHJHRmVFUXpjNFpDa0lLVWMvVXU2Z3RnYkoyL2J2dmNM?=
 =?utf-8?B?OVdYVFBGMUtqeHhmQ1FQNTF4Qjk0WlZtcmpUYlY1QnI2R2k5elRxNTZDdjdO?=
 =?utf-8?B?WjhHRENRRFNOcWdtLythVGVSNU00SGVlL0w2emw5QTFaRmt2emc2bmoxZnBs?=
 =?utf-8?B?NHlBeGs1SHptQzZORnVkOVlLZG4yS1pydFhGcEVIL0hmSUlRNitVdWJDUitT?=
 =?utf-8?B?TzFOektudTAwc3Y5UnRCR3A3NlJRTUhLbklzWmxwN1lOc0FZN3o3QVYzclhL?=
 =?utf-8?B?UjhXUXV3VDRJTTNhZUhyY3pxYjZ1TWZPZkJUS1k3U1ZITXorcFk1dkZtcnFj?=
 =?utf-8?B?RjNLWENDbFY5cllhNmV6Y0h1TUkzNUtETTF3MklDRjdqek1VWk1WMGMrOFNG?=
 =?utf-8?B?ckFaUzV0dGFLdnRVV0EzNU9hdW0wNlEyQ3BHbTRLM0xNZDRRVTM4eFBWOHcv?=
 =?utf-8?B?SEcvUm92b085ODJETjNCd2QyZEdXMGkwWHBkVE03NlMyM25FQWtXZTh5RDBE?=
 =?utf-8?B?WmJIQkNZSEhVTCtFV2tPMGcva3hUMUkvc2dGcUZ5c3p4WjZyaHExbTZ3Umxo?=
 =?utf-8?B?cnVMQ2hwYVR2ZHgrVEVjVFJUR2U0bmljalhoeXZ6TmFidTJ4Y2NSYXZFblJK?=
 =?utf-8?B?UWIzdUlKRFMrTTh6RDZHY0JtVWp5V202L1lpWlVtaURaUDJkS1UxSXBoUU9T?=
 =?utf-8?B?QlpMTTd0R3QvTFNzYmlPK3oxUm9LTFV4U3NrTC90UnVkS3NjdzZiU0J5ZlJK?=
 =?utf-8?B?d2xSOG95MU16UjQrWDE3YzRzKzZXUkx5amRxeno4QmpaRmlGSzh3QksycTg0?=
 =?utf-8?B?andkWmdlcEJ4RFBDOWJXR3o4RytzdW5Wa0p2TURkNWxHNFI3YWNvaHFlN3M0?=
 =?utf-8?B?cHFUVjlHaklVdHhPN2pCRzNwd1R3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3C2FF39FD805314FB8F111D258CBBF28@namprd02.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: cc938bf6-7636-452b-0acf-08ddf212b4b9
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2025 15:40:31.1423
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7iQplF2KyDazcsOEZw+ekU35wMWPkNp5EVolIJS3pkfRKQ2W7nin0q8kSHKe9XhU791L+9nBfa5aztlVuMqI/yVJC7/XAre7gP8NU5sObVI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR02MB10967
X-Proofpoint-ORIG-GUID: tilP-rHQbrqU2rnSz0JEQ86b6w6lTiPL
X-Authority-Analysis: v=2.4 cv=Du5W+H/+ c=1 sm=1 tr=0 ts=68c43ef1 cx=c_pps
 a=+CKpLqsC5QamL8vULJ+FWg==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=0kUYKlekyDsA:10 a=20KFwNOVAAAA:8 a=64Cc0HZtAAAA:8
 a=VwQbUJbxAAAA:8 a=dwgzuv5j7Ytyjc_9RAgA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEyMDE0NSBTYWx0ZWRfX8dNwtWqHfg5F
 lSoSX0DA6LZ864pPLhLgDFwH+m1CJc5k13/e/gsyysCU2DGLqONEab0JyQkViGO7XEyy/+mRZaa
 jvtFzLnT0FCJ2IyvSqdq/93g+iLJyFuBHViEq/TOk9tMVDqXwJW680cXKN40fe8s40l6y/zWrxy
 LS5Vfvc5hi06DnJ5WpL9H6SROtBL0QhLoLxhPCafYEG/nX2x2g0MLFeVrhoesHUKc+c4cTwHAzH
 pmPI7R4MY68b4WRc1SLVBglwxRDV65A33s2+yrMsjUcpd/YJk7AgD5ZT2CGkifRGSp0SDZ0LHEN
 ptb0869OibNNhrRkvV+pG6TCIpk8dekycj8nYqqdIj4En89gMGFA+JXOFm3e/k=
X-Proofpoint-GUID: tilP-rHQbrqU2rnSz0JEQ86b6w6lTiPL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-12_05,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gU2VwIDEyLCAyMDI1LCBhdCAxMTozOOKAr0FNLCBNaWNoYWVsIFMuIFRzaXJraW4g
PG1zdEByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElPTjog
RXh0ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gT24gRnJpLCBTZXAgMTIs
IDIwMjUgYXQgMDM6MzM6MzJQTSArMDAwMCwgSm9uIEtvaGxlciB3cm90ZToNCj4+IA0KPj4gDQo+
Pj4gT24gU2VwIDEyLCAyMDI1LCBhdCAxMTozMOKAr0FNLCBNaWNoYWVsIFMuIFRzaXJraW4gPG1z
dEByZWRoYXQuY29tPiB3cm90ZToNCj4+PiANCj4+PiAhLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLXwNCj4+PiBDQVVUSU9O
OiBFeHRlcm5hbCBFbWFpbA0KPj4+IA0KPj4+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPj4+IA0KPj4+IE9uIEZy
aSwgU2VwIDEyLCAyMDI1IGF0IDAzOjI0OjQyUE0gKzAwMDAsIEpvbiBLb2hsZXIgd3JvdGU6DQo+
Pj4+IA0KPj4+PiANCj4+Pj4+IE9uIFNlcCAxMiwgMjAyNSwgYXQgNDo1MOKAr0FNLCBNaWNoYWVs
IFMuIFRzaXJraW4gPG1zdEByZWRoYXQuY29tPiB3cm90ZToNCj4+Pj4+IA0KPj4+Pj4gIS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS18DQo+Pj4+PiBDQVVUSU9OOiBFeHRlcm5hbCBFbWFpbA0KPj4+Pj4gDQo+Pj4+PiB8LS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLSENCj4+Pj4+IA0KPj4+Pj4gT24gRnJpLCBTZXAgMTIsIDIwMjUgYXQgMDQ6MjY6NThQ
TSArMDgwMCwgSmFzb24gV2FuZyB3cm90ZToNCj4+Pj4+PiBDb21taXQgOGMyZTZiMjZmZmUyICgi
dmhvc3QvbmV0OiBEZWZlciBUWCBxdWV1ZSByZS1lbmFibGUgdW50aWwgYWZ0ZXINCj4+Pj4+PiBz
ZW5kbXNnIikgdHJpZXMgdG8gZGVmZXIgdGhlIG5vdGlmaWNhdGlvbiBlbmFibGluZyBieSBtb3Zp
bmcgdGhlIGxvZ2ljDQo+Pj4+Pj4gb3V0IG9mIHRoZSBsb29wIGFmdGVyIHRoZSB2aG9zdF90eF9i
YXRjaCgpIHdoZW4gbm90aGluZyBuZXcgaXMNCj4+Pj4+PiBzcG90dGVkLiBUaGlzIHdpbGwgYnJp
bmcgc2lkZSBlZmZlY3RzIGFzIHRoZSBuZXcgbG9naWMgd291bGQgYmUgcmV1c2VkDQo+Pj4+Pj4g
Zm9yIHNldmVyYWwgb3RoZXIgZXJyb3IgY29uZGl0aW9ucy4NCj4+Pj4+PiANCj4+Pj4+PiBPbmUg
ZXhhbXBsZSBpcyB0aGUgSU9UTEI6IHdoZW4gdGhlcmUncyBhbiBJT1RMQiBtaXNzLCBnZXRfdHhf
YnVmcygpDQo+Pj4+Pj4gbWlnaHQgcmV0dXJuIC1FQUdBSU4gYW5kIGV4aXQgdGhlIGxvb3AgYW5k
IHNlZSB0aGVyZSdzIHN0aWxsIGF2YWlsYWJsZQ0KPj4+Pj4+IGJ1ZmZlcnMsIHNvIGl0IHdpbGwg
cXVldWUgdGhlIHR4IHdvcmsgYWdhaW4gdW50aWwgdXNlcnNwYWNlIGZlZWQgdGhlDQo+Pj4+Pj4g
SU9UTEIgZW50cnkgY29ycmVjdGx5LiBUaGlzIHdpbGwgc2xvd2Rvd24gdGhlIHR4IHByb2Nlc3Np
bmcgYW5kIG1heQ0KPj4+Pj4+IHRyaWdnZXIgdGhlIFRYIHdhdGNoZG9nIGluIHRoZSBndWVzdC4N
Cj4+Pj4+IA0KPj4+Pj4gSXQncyBub3QgdGhhdCBpdCBtaWdodC4NCj4+Pj4+IFBscyBjbGFyaWZ5
IHRoYXQgaXQgKmhhcyBiZWVuIHJlcG9ydGVkKiB0byBkbyBleGFjdGx5IHRoYXQsDQo+Pj4+PiBh
bmQgYWRkIGEgbGluayB0byB0aGUgcmVwb3J0Lg0KPj4+Pj4gDQo+Pj4+PiANCj4+Pj4+PiBGaXhp
bmcgdGhpcyBieSBzdGljayB0aGUgbm90aWZpY2FpdG9uIGVuYWJsaW5nIGxvZ2ljIGluc2lkZSB0
aGUgbG9vcA0KPj4+Pj4+IHdoZW4gbm90aGluZyBuZXcgaXMgc3BvdHRlZCBhbmQgZmx1c2ggdGhl
IGJhdGNoZWQgYmVmb3JlLg0KPj4+Pj4+IA0KPj4+Pj4+IFJlcG9ydGVkLWJ5OiBKb24gS29obGVy
IDxqb25AbnV0YW5peC5jb20+DQo+Pj4+Pj4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4+
Pj4+PiBGaXhlczogOGMyZTZiMjZmZmUyICgidmhvc3QvbmV0OiBEZWZlciBUWCBxdWV1ZSByZS1l
bmFibGUgdW50aWwgYWZ0ZXIgc2VuZG1zZyIpDQo+Pj4+Pj4gU2lnbmVkLW9mZi1ieTogSmFzb24g
V2FuZyA8amFzb3dhbmdAcmVkaGF0LmNvbT4NCj4+Pj4+IA0KPj4+Pj4gU28gdGhpcyBpcyBtb3N0
bHkgYSByZXZlcnQsIGJ1dCB3aXRoDQo+Pj4+PiAgICAgICAgICAgICAgICAgICB2aG9zdF90eF9i
YXRjaChuZXQsIG52cSwgc29jaywgJm1zZyk7DQo+Pj4+PiBhZGRlZCBpbiB0byBhdm9pZCByZWdy
ZXNzaW5nIHBlcmZvcm1hbmNlLg0KPj4+Pj4gDQo+Pj4+PiBJZiB5b3UgZG8gbm90IHdhbnQgdG8g
c3RydWN0dXJlIGl0IGxpa2UgdGhpcyAocmV2ZXJ0K29wdGltaXphdGlvbiksDQo+Pj4+PiB0aGVu
IHBscyBtYWtlIHRoYXQgY2xlYXIgaW4gdGhlIG1lc3NhZ2UuDQo+Pj4+PiANCj4+Pj4+IA0KPj4+
Pj4+IC0tLQ0KPj4+Pj4+IGRyaXZlcnMvdmhvc3QvbmV0LmMgfCAzMyArKysrKysrKysrKysrLS0t
LS0tLS0tLS0tLS0tLS0tLS0NCj4+Pj4+PiAxIGZpbGUgY2hhbmdlZCwgMTMgaW5zZXJ0aW9ucygr
KSwgMjAgZGVsZXRpb25zKC0pDQo+Pj4+Pj4gDQo+Pj4+Pj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMv
dmhvc3QvbmV0LmMgYi9kcml2ZXJzL3Zob3N0L25ldC5jDQo+Pj4+Pj4gaW5kZXggMTZlMzlmM2Fi
OTU2Li4zNjExYjc1Mzc5MzIgMTAwNjQ0DQo+Pj4+Pj4gLS0tIGEvZHJpdmVycy92aG9zdC9uZXQu
Yw0KPj4+Pj4+ICsrKyBiL2RyaXZlcnMvdmhvc3QvbmV0LmMNCj4+Pj4+PiBAQCAtNzY1LDExICs3
NjUsMTEgQEAgc3RhdGljIHZvaWQgaGFuZGxlX3R4X2NvcHkoc3RydWN0IHZob3N0X25ldCAqbmV0
LCBzdHJ1Y3Qgc29ja2V0ICpzb2NrKQ0KPj4+Pj4+IGludCBlcnI7DQo+Pj4+Pj4gaW50IHNlbnRf
cGt0cyA9IDA7DQo+Pj4+Pj4gYm9vbCBzb2NrX2Nhbl9iYXRjaCA9IChzb2NrLT5zay0+c2tfc25k
YnVmID09IElOVF9NQVgpOw0KPj4+Pj4+IC0gYm9vbCBidXN5bG9vcF9pbnRyOw0KPj4+Pj4+IGJv
b2wgaW5fb3JkZXIgPSB2aG9zdF9oYXNfZmVhdHVyZSh2cSwgVklSVElPX0ZfSU5fT1JERVIpOw0K
Pj4+Pj4+IA0KPj4+Pj4+IGRvIHsNCj4+Pj4+PiAtIGJ1c3lsb29wX2ludHIgPSBmYWxzZTsNCj4+
Pj4+PiArIGJvb2wgYnVzeWxvb3BfaW50ciA9IGZhbHNlOw0KPj4+Pj4+ICsNCj4+Pj4+PiBpZiAo
bnZxLT5kb25lX2lkeCA9PSBWSE9TVF9ORVRfQkFUQ0gpDQo+Pj4+Pj4gdmhvc3RfdHhfYmF0Y2go
bmV0LCBudnEsIHNvY2ssICZtc2cpOw0KPj4+Pj4+IA0KPj4+Pj4+IEBAIC03ODAsMTAgKzc4MCwx
OCBAQCBzdGF0aWMgdm9pZCBoYW5kbGVfdHhfY29weShzdHJ1Y3Qgdmhvc3RfbmV0ICpuZXQsIHN0
cnVjdCBzb2NrZXQgKnNvY2spDQo+Pj4+Pj4gYnJlYWs7DQo+Pj4+Pj4gLyogTm90aGluZyBuZXc/
ICBXYWl0IGZvciBldmVudGZkIHRvIHRlbGwgdXMgdGhleSByZWZpbGxlZC4gKi8NCj4+Pj4+PiBp
ZiAoaGVhZCA9PSB2cS0+bnVtKSB7DQo+Pj4+Pj4gLSAvKiBLaWNrcyBhcmUgZGlzYWJsZWQgYXQg
dGhpcyBwb2ludCwgYnJlYWsgbG9vcCBhbmQNCj4+Pj4+PiAtICogcHJvY2VzcyBhbnkgcmVtYWlu
aW5nIGJhdGNoZWQgcGFja2V0cy4gUXVldWUgd2lsbA0KPj4+Pj4+IC0gKiBiZSByZS1lbmFibGVk
IGFmdGVyd2FyZHMuDQo+Pj4+Pj4gKyAvKiBGbHVzaCBiYXRjaGVkIHBhY2tldHMgYmVmb3JlIGVu
YWJsaW5nDQo+Pj4+Pj4gKyAqIHZpcnF0dWV1ZSBub3RpZmljYXRpb24gdG8gcmVkdWNlDQo+Pj4+
Pj4gKyAqIHVubmVjc3NhcnkgdmlydHF1ZXVlIGtpY2tzLg0KPj4+Pj4gDQo+Pj4+PiB0eXBvczog
dmlydHF1ZXVlLCB1bm5lY2Vzc2FyeQ0KPj4+Pj4gDQo+Pj4+Pj4gKi8NCj4+Pj4+PiArIHZob3N0
X3R4X2JhdGNoKG5ldCwgbnZxLCBzb2NrLCAmbXNnKTsNCj4+Pj4+PiArIGlmICh1bmxpa2VseShi
dXN5bG9vcF9pbnRyKSkgew0KPj4+Pj4+ICsgdmhvc3RfcG9sbF9xdWV1ZSgmdnEtPnBvbGwpOw0K
Pj4+Pj4+ICsgfSBlbHNlIGlmICh1bmxpa2VseSh2aG9zdF9lbmFibGVfbm90aWZ5KCZuZXQtPmRl
diwNCj4+Pj4+PiArIHZxKSkpIHsNCj4+Pj4+PiArIHZob3N0X2Rpc2FibGVfbm90aWZ5KCZuZXQt
PmRldiwgdnEpOw0KPj4+Pj4+ICsgY29udGludWU7DQo+Pj4+Pj4gKyB9DQo+Pj4+Pj4gYnJlYWs7
DQo+Pj4+Pj4gfQ0KPj4+PiANCj4+Pj4gU2VlIG15IGNvbW1lbnQgYmVsb3csIGJ1dCBob3cgYWJv
dXQgc29tZXRoaW5nIGxpa2UgdGhpcz8NCj4+Pj4gaWYgKGhlYWQgPT0gdnEtPm51bSkgew0KPj4+
PiAvKiBGbHVzaCBiYXRjaGVkIHBhY2tldHMgYmVmb3JlIGVuYWJsaW5nDQo+Pj4+ICogdmlydHF1
ZXVlIG5vdGlmaWNhdGlvbiB0byByZWR1Y2UNCj4+Pj4gKiB1bm5lY2Vzc2FyeSB2aXJ0cXVldWUg
a2lja3MuDQo+Pj4+ICovDQo+Pj4+IHZob3N0X3R4X2JhdGNoKG5ldCwgbnZxLCBzb2NrLCAmbXNn
KTsNCj4+Pj4gaWYgKHVubGlrZWx5KGJ1c3lsb29wX2ludHIpKQ0KPj4+PiAvKiBJZiBpbnRlcnJ1
cHRlZCB3aGlsZSBkb2luZyBidXN5IHBvbGxpbmcsDQo+Pj4+ICogcmVxdWV1ZSB0aGUgaGFuZGxl
ciB0byBiZSBmYWlyIGhhbmRsZV9yeA0KPj4+PiAqIGFzIHdlbGwgYXMgb3RoZXIgdGFza3Mgd2Fp
dGluZyBvbiBjcHUuDQo+Pj4+ICovDQo+Pj4+IHZob3N0X3BvbGxfcXVldWUoJnZxLT5wb2xsKTsN
Cj4+Pj4gZWxzZQ0KPj4+PiAvKiBBbGwgb2Ygb3VyIHdvcmsgaGFzIGJlZW4gY29tcGxldGVkOw0K
Pj4+PiAqIGhvd2V2ZXIsIGJlZm9yZSBsZWF2aW5nIHRoZSBUWCBoYW5kbGVyLA0KPj4+PiAqIGRv
IG9uZSBsYXN0IGNoZWNrIGZvciB3b3JrLCBhbmQgcmVxdWV1ZQ0KPj4+PiAqIGhhbmRsZXIgaWYg
bmVjZXNzYXJ5LiBJZiB0aGVyZSBpcyBubyB3b3JrLA0KPj4+PiAqIHF1ZXVlIHdpbGwgYmUgcmVl
bmFibGVkLg0KPj4+PiAqLw0KPj4+PiB2aG9zdF9uZXRfYnVzeV9wb2xsX3RyeV9xdWV1ZShuZXQs
IHZxKTsNCj4+PiANCj4+PiANCj4+PiBJIG1lYW4gaXQncyBmdW5jdGlvbmFsbHkgZXF1aXZhbGVu
dCwgYnV0IHZob3N0X25ldF9idXN5X3BvbGxfdHJ5X3F1ZXVlIA0KPj4+IGNoZWNrcyB0aGUgYXZh
aWwgcmluZyBhZ2FpbiBhbmQgd2UganVzdCBjaGVja2VkIGl0Lg0KPj4+IFdoeSBpcyB0aGlzIGEg
Z29vZCBpZGVhPw0KPj4+IFRoaXMgaGFwcGVucyBvbiBnb29kIHBhdGggc28gSSBkaXNsaWtlIHVu
bmVjZXNzYXJ5IHdvcmsgbGlrZSB0aGlzLg0KPj4gDQo+PiBGb3IgdGhlIHNha2Ugb2YgZGlzY3Vz
c2lvbiwgbGV04oCZcyBzYXkgdmhvc3RfdHhfYmF0Y2ggYW5kIHRoZQ0KPj4gc2VuZG1zZyB3aXRo
aW4gdG9vayAxIGZ1bGwgc2Vjb25kIHRvIGNvbXBsZXRlLiBBIGxvdCBjb3VsZCBwb3RlbnRpYWxs
eQ0KPj4gaGFwcGVuIGluIHRoYXQgYW1vdW50IG9mIHRpbWUuIFNvIHN1cmUsIGNvbnRyb2wgcGF0
aCB3aXNlIGl0IGxvb2tzIGxpa2UNCj4+IHdlIGp1c3QgY2hlY2tlZCBpdCwgYnV0IHRpbWUgd2lz
ZSwgdGhhdCBjb3VsZCBoYXZlIGJlZW4gYWdlcyBhZ28uDQo+IA0KPiANCj4gT2ggSSBmb3Jnb3Qg
d2UgaGFkIHRoZSB0eCBiYXRjaCBpbiB0aGVyZS4NCj4gT0sgdGhlbiwgSSBkb24ndCBoYXZlIGEg
cHJvYmxlbSB3aXRoIHRoaXMuDQo+IA0KPiANCj4gSG93ZXZlciwgd2hhdCBJIGxpa2UgYWJvdXQg
SmFzb24ncyBwYXRjaCBpcyB0aGF0DQo+IGl0IGlzIGFjdHVhbGx5IHNpbXBseSByZXZlcnQgb2Yg
eW91ciBwYXRjaCArDQo+IGEgc2luZ2xlIGNhbGwgdG8gDQo+IHZob3N0X3R4X2JhdGNoKG5ldCwg
bnZxLCBzb2NrLCAmbXNnKTsNCj4gDQo+IFNvIGl0IGlzIGEgbW9yZSBvYnZpb3NseSBjb3JyZWN0
IGFwcHJvYWNoLg0KPiANCj4gDQo+IEknbGwgYmUgZmluZSB3aXRoIGRvaW5nIHdoYXQgeW91IHBy
b3Bvc2Ugb24gdG9wLA0KPiB3aXRoIHRlc3RpbmcgdGhhdCB0aGV5IGFyZSBiZW5lZml0aWFsIGZv
ciBwZXJmb3JtYW5jZS4NCg0KT2sgZmFpciBlbm91Z2gsIGFncmVlZCwgbGV04oCZcyBmaXggdGhl
IGJ1ZyBidXNpbmVzcyBmaXJzdCwNCnRoZW4gcmVvcHRpbWl6ZSBvbiB0b3AuDQoNCj4gDQo+IA0K
PiANCj4gDQo+IA0KPiANCj4+PiANCj4+PiANCj4+Pj4gYnJlYWs7DQo+Pj4+IH0NCj4+Pj4gDQo+
Pj4+IA0KPj4+Pj4+IA0KPj4+Pj4+IEBAIC04MzksMjIgKzg0Nyw3IEBAIHN0YXRpYyB2b2lkIGhh
bmRsZV90eF9jb3B5KHN0cnVjdCB2aG9zdF9uZXQgKm5ldCwgc3RydWN0IHNvY2tldCAqc29jaykN
Cj4+Pj4+PiArK252cS0+ZG9uZV9pZHg7DQo+Pj4+Pj4gfSB3aGlsZSAobGlrZWx5KCF2aG9zdF9l
eGNlZWRzX3dlaWdodCh2cSwgKytzZW50X3BrdHMsIHRvdGFsX2xlbikpKTsNCj4+Pj4+PiANCj4+
Pj4+PiAtIC8qIEtpY2tzIGFyZSBzdGlsbCBkaXNhYmxlZCwgZGlzcGF0Y2ggYW55IHJlbWFpbmlu
ZyBiYXRjaGVkIG1zZ3MuICovDQo+Pj4+Pj4gdmhvc3RfdHhfYmF0Y2gobmV0LCBudnEsIHNvY2ss
ICZtc2cpOw0KPj4+Pj4+IC0NCj4+Pj4+PiAtIGlmICh1bmxpa2VseShidXN5bG9vcF9pbnRyKSkN
Cj4+Pj4+PiAtIC8qIElmIGludGVycnVwdGVkIHdoaWxlIGRvaW5nIGJ1c3kgcG9sbGluZywgcmVx
dWV1ZSB0aGUNCj4+Pj4+PiAtICogaGFuZGxlciB0byBiZSBmYWlyIGhhbmRsZV9yeCBhcyB3ZWxs
IGFzIG90aGVyIHRhc2tzDQo+Pj4+Pj4gLSAqIHdhaXRpbmcgb24gY3B1Lg0KPj4+Pj4+IC0gKi8N
Cj4+Pj4+PiAtIHZob3N0X3BvbGxfcXVldWUoJnZxLT5wb2xsKTsNCj4+Pj4+PiAtIGVsc2UNCj4+
Pj4+PiAtIC8qIEFsbCBvZiBvdXIgd29yayBoYXMgYmVlbiBjb21wbGV0ZWQ7IGhvd2V2ZXIsIGJl
Zm9yZQ0KPj4+Pj4+IC0gKiBsZWF2aW5nIHRoZSBUWCBoYW5kbGVyLCBkbyBvbmUgbGFzdCBjaGVj
ayBmb3Igd29yaywNCj4+Pj4+PiAtICogYW5kIHJlcXVldWUgaGFuZGxlciBpZiBuZWNlc3Nhcnku
IElmIHRoZXJlIGlzIG5vIHdvcmssDQo+Pj4+Pj4gLSAqIHF1ZXVlIHdpbGwgYmUgcmVlbmFibGVk
Lg0KPj4+Pj4+IC0gKi8NCj4+Pj4+PiAtIHZob3N0X25ldF9idXN5X3BvbGxfdHJ5X3F1ZXVlKG5l
dCwgdnEpOw0KPj4+PiANCj4+Pj4gTm90ZTogdGhlIHVzZSBvZiB2aG9zdF9uZXRfYnVzeV9wb2xs
X3RyeV9xdWV1ZSB3YXMgaW50ZW50aW9uYWwgaW4gbXkNCj4+Pj4gcGF0Y2ggYXMgaXQgd2FzIGNo
ZWNraW5nIHRvIHNlZSBib3RoIGNvbmRpdGlvbmFscy4NCj4+Pj4gDQo+Pj4+IENhbiB3ZSBzaW1w
bHkgaG9pc3QgbXkgbG9naWMgdXAgaW5zdGVhZD8NCj4+Pj4gDQo+Pj4+Pj4gfQ0KPj4+Pj4+IA0K
Pj4+Pj4+IHN0YXRpYyB2b2lkIGhhbmRsZV90eF96ZXJvY29weShzdHJ1Y3Qgdmhvc3RfbmV0ICpu
ZXQsIHN0cnVjdCBzb2NrZXQgKnNvY2spDQo+Pj4+Pj4gLS0gDQo+Pj4+Pj4gMi4zNC4xDQo+Pj4+
PiANCj4+Pj4gDQo+Pj4+IFRlc3RlZC1ieTogSm9uIEtvaGxlciA8am9uQG51dGFuaXguY29tIDxt
YWlsdG86am9uQG51dGFuaXguY29tPj4NCj4+Pj4gDQo+Pj4+IFRyaWVkIHRoaXMgb3V0IG9uIGEg
Ni4xNiBob3N0IC8gZ3Vlc3QgdGhhdCBsb2NrZWQgdXAgd2l0aCBpb3RsYiBtaXNzIGxvb3AsDQo+
Pj4+IGFwcGxpZWQgdGhpcyBwYXRjaCBhbmQgYWxsIHdhcyB3ZWxsLg0KPj4+IA0KPj4gDQo+IA0K
DQo=

