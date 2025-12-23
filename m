Return-Path: <kvm+bounces-66573-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CB83CD8096
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 05:17:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E45A63023511
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 04:16:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C14B2E1730;
	Tue, 23 Dec 2025 04:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="ttvnyX1W";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="ytDAbfhr"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22DA2E1722;
	Tue, 23 Dec 2025 04:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766463406; cv=fail; b=eUhMi4Eo8W5lmhrsIRlqQhStZxqjvq+SL5ysrLor6FqaKBlNLBZeS1oU5J5EgHbGcLuyeVdHnqbgmT8nPgT/+iFz1/V+y84cH2fmw4xRq2Qft+FwwCVo/zsCYeQNrEVhAbC5jKDuUljtIvPinUi6n0iEBAsl/krG8bCAd2tVPBg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766463406; c=relaxed/simple;
	bh=79jAN4C47GPWVFzI5iSwahiJwbx72ayEoLnCP9xrwxU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BlHVDkuiYZC0O+30ml79J5Es0y7OpgdQJF1BLNxaKlTQJUw/DJQ/aUd7nBkgtIrysBI4bB59hOGZ+wqM01gVmetnkLkFCLQTlgQB3RWrXm+LqqPIuOXauIQh+5lzaHPYTIwjEtbWAswK4DjdE9ueOzjwc/yaHKf/Vbd1cZOlQJE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=ttvnyX1W; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=ytDAbfhr; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BMJJoet1942543;
	Mon, 22 Dec 2025 20:15:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=79jAN4C47GPWVFzI5iSwahiJwbx72ayEoLnCP9xrw
	xU=; b=ttvnyX1WVdfVO3KbFdjvk78PlmOfibVavDHaMcBblJVyEOts5cKhMkIHG
	KYs+uFvW7KTqn75NSEnAO/tvjp7MpITtw54PLdI64UQCqY6dEKyJ/HIrmes6c5dB
	y6mGwJYS8s4hX9ZkzlbOi6vhTg64koIVcykJQhzdd/9SJMd9mt4TBdDDIsS8CrG7
	SZCiFob8Ukl4DvWvwSNP74eTReVvsCXCDCX0hfgMpYe6o+lgUAYao+Rwe3LZMAi9
	5bwUBRVIqqHhHKFEYe1LO/kfRwvxce6VS0ibMR3DqyWg2Ihw1QKdRRc82p5nTgcz
	oSGaoVurAHC4Qut1eQeH6mNfmKB6A==
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11021088.outbound.protection.outlook.com [52.101.52.88])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4b73ydt2eh-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 20:15:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pnljf8g4gny1yUkic5TKuxDsoGub34IBXLG60NF3fVrsIGS6DtfQ0DxSiu06vmIMuqG+lNtPPd5VrZhtvXUFLHC3yJfVN/wC7xvE9JofDOC3y67XrhOL/jbozZe94hWi1FzJNkqtntKvis/7PgNRTDZAuCikNiYopGUgAde//R13BwRWuoZSU4zDgdcrHw7+fXbKmIjW9eZii74jhSkBJN3jEUJh/M/RDxVa+gCIPc8H9ZbOpjQC8BYN2rdm0vxfqt/o8Jev/6xzRUErHPWrQwW8jIMmNhPV5YCgD1UEuaSdPy03slL8z6GLcPs3aI37zff+xQEg3ae/VliULOCqXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=79jAN4C47GPWVFzI5iSwahiJwbx72ayEoLnCP9xrwxU=;
 b=GrHZEaGXT/SDTOtpMWWv23oJKnzI8lL1VHweQlUv/P9/3+U/C1eRweXu8nhodtrQswhBeQXFt/Mtv+VX71YDQPkpNnXFjhYrq30XM9LMqQEuZSngr9twP8RhSiZUU5nlFhBJisakOHIMHIqky2gdqoEYm1IxMO57mBl5rdVlbh6PdD5Z3DM1pBRlFEwFTLYyWKzY/5xtGfLyct6MI2c53k7Mh5mHmq3bFyVwT+azAvtspEw2CJUp2gBpof9scfytYgaMdK1iYphJDsxtY8CqHRQtk8Moz0BYxPn5qboMINqYu3Xgkwe/KBpSvsTx83v0syNqqqmvU/d4CmeFhHDZOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=79jAN4C47GPWVFzI5iSwahiJwbx72ayEoLnCP9xrwxU=;
 b=ytDAbfhr1j7AQ+d5Q6LhxAUiolODcOd/6YvShSCTHS4qeEmy16GYtZTsKhI1N3uqjrmiTKzri4R0bFgl7L3cSOZkmxa+w8LlhM5tSOM/Fvpq4K748aocptgSRRqdlSPhu/bg6M3K5VVfEaOcKZ8p5+shjwALb7B3Qgpyo8D7ipEF8IuT8N7RBEr7G+7eMh7owNJMDD9qRjyOe0HmRDfHiWHXbXxM6kLk3yKRBnNtYqDg63KAdSN1mjZqW92tQJKdhiCPb0GefFRlBthYRkgqQP2dQ0N8TCJ2dxsPgVfp3ZAIhyESFsdRWOa3WV5h88nX7eBL9YJb6b9VXVg/BFCIQg==
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18) by SA1PR02MB8512.namprd02.prod.outlook.com
 (2603:10b6:806:1fb::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.11; Tue, 23 Dec
 2025 04:15:54 +0000
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc]) by LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc%4]) with mapi id 15.20.9434.009; Tue, 23 Dec 2025
 04:15:54 +0000
From: Jon Kohler <jon@nutanix.com>
To: Jon Kohler <jon@nutanix.com>
CC: Sean Christopherson <seanjc@google.com>,
        "pbonzini@redhat.com"
	<pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org"
	<x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        =?utf-8?B?TWlja2HDq2wgU2FsYcO8bg==?=
	<mic@digikod.net>,
        "amit.shah@amd.com" <amit.shah@amd.com>
Subject: Re: [RFC PATCH 14/18] KVM: x86/mmu: Extend is_executable_pte to
 understand MBEC
Thread-Topic: [RFC PATCH 14/18] KVM: x86/mmu: Extend is_executable_pte to
 understand MBEC
Thread-Index: AQHblFP7puy8TgmqfkeW3xyH95EPUbPP3beAgABRrQCBYC2RAA==
Date: Tue, 23 Dec 2025 04:15:54 +0000
Message-ID: <3037CF06-6C1B-4FF1-8BE5-057B60DDCF01@nutanix.com>
References: <20250313203702.575156-1-jon@nutanix.com>
 <20250313203702.575156-15-jon@nutanix.com> <aCJlR9jZniZN_7cH@google.com>
 <9E0F858E-BAFB-46B3-8D00-442BE46F4D00@nutanix.com>
In-Reply-To: <9E0F858E-BAFB-46B3-8D00-442BE46F4D00@nutanix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3864.300.41.1.7)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV0PR02MB11133:EE_|SA1PR02MB8512:EE_
x-ms-office365-filtering-correlation-id: 2f35b569-f45d-4a3a-7e16-08de41d9f741
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|7416014|376014|10070799003|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?YnhRMERtM2E5MTNOOE53WGtONEZKdXd2WTR0YzAwZGExWU9WOVZxd1FMUmtC?=
 =?utf-8?B?VExYU3hvNzc1bElndkdjVSt5Yk83SXZVTHpVOFZJaE5GSjI0Rk9tYTZWY2o4?=
 =?utf-8?B?a3o3bUVvVnpWQW9TdkVWVG1RVDZROGhzQ3VkdGxLUHR6RWlSdUI1R2pvL0NI?=
 =?utf-8?B?aGg2K2hRWGdEV1p0MzdieGRuczRDKzlLYkFCWE9zQzRVSHArclBta1htQzc3?=
 =?utf-8?B?L2NDWjhlNVFWYWRISmk4YXBMQTgxclNsZmRsODFDc09WajhaK2VxR1lnUHNH?=
 =?utf-8?B?bm4zQ3g4cnNZNkdtaTRtUytEY1ZQMXlRZUJidmRoUmxkcDBVQkduUE02SUx5?=
 =?utf-8?B?ZU93dGdWeEw3eTNFbkplMFNOMkozYjBRM01qNjBMMEJZdFpNc0JGUU4rTXY3?=
 =?utf-8?B?VFloQ0xzclJ5Ym1yZEJCWnRsdnlwVGRVT3FzcERIOTlKeVVoQm85TlFjK0kr?=
 =?utf-8?B?Z21MRjJwVGJxNEpVZE1oWFJYUWVNZjlTSWlGTlNJbG45ek9kbTRscEtsWW5E?=
 =?utf-8?B?Znk1YTR6U0tBSlpIUitHcmFVbExkOGoxWHhPNUlKUk5XY3pNQXpkd1ZwUEFs?=
 =?utf-8?B?N0Zvc1BhQkdNbnl3Wi8vSUhaRXVSVm1yNFdjMndVV3AwcytmZXhRcTZjdHJo?=
 =?utf-8?B?SmR1VHg3dSs4U3BDbm9oR05kdThpL3l6WEFWNUJVcGlyblA5dXF2dnhnVmRQ?=
 =?utf-8?B?M2dBeFY0V2IzKzg1YS9jK0N6Y09vNFpobmtXRFFhK3ozR0c1NlRuZGYyb05z?=
 =?utf-8?B?dE1mSngyS2hqUE43UlBKcW1qajltTnAvbVRxdytEZ0cxM0JqZmpmVTROTVVY?=
 =?utf-8?B?S1FpQ3V3UTUySWM0SlZFZzRydDdHYjhXcnRwd1RyQlhaY3BaeTN5STJYaUF5?=
 =?utf-8?B?bnA3VTFHL1ZacFRBYVgxeFlOUVRhK0NQaUdxNURpbCtBd3AxZXRtVjRUWFcv?=
 =?utf-8?B?bllGVkY5ZHFyL2xaejU3cktGbjNFVUdpYXhmNzEvdGhROHdCdkk5d2xoVFlS?=
 =?utf-8?B?ZmxSUmRIcU5NNDMwandCa0QrSkR2MmE4emNCWnAxRXIyNFljM29aQ09PUUtp?=
 =?utf-8?B?RkxTQVdXNXFwbzUwOWF0Yk5Mam1XNmN1VFlTM2NGaW16aEpkRkdjN0psVGZw?=
 =?utf-8?B?OER2K1dXeFNVKyswOURvTVcvQlZRQkE1TVorL1VOT1dHT2hqSitVS29QekZC?=
 =?utf-8?B?a0YydnNVV0NZeEFsUXM0NXUrekhCUzJxT3Z2SGtsb1Bodm15dGxySWtESlhX?=
 =?utf-8?B?cnlwSVF3TDNuZ0JvUU1SNFlucTkwdmQ5QkdhRlg4ZXBwNFlnckNjWnZ1Z2s4?=
 =?utf-8?B?ejYxUDVJTTFrd1NyWU5kK3VlYkRycWxZenB3d3VCUEUwanNSN2tNWW9yRUw5?=
 =?utf-8?B?elcvYWhIUjZUR3JncHJHTlpPUFVkdGRBTS96d0NmQXdzUEEvOHR5cUVYUUQz?=
 =?utf-8?B?TXpxbTRNUUJaT0YzWDJQYldKN3dteXF6Uk5XQnJnMFZIKzUrN2tQbjArdy9J?=
 =?utf-8?B?bTN5TENodW1ITzI1clFyaG1uZVVndUJuWjEzUFNlcEtaTVR1bDFYMEZ4VVp1?=
 =?utf-8?B?RHowMnNtSmRoditCMFBNaWpIWHhDK1VVZ1ZDNGNVQzdnaGQ1dUNsMkd3akIw?=
 =?utf-8?B?c0lQMUNobkl3eXVLZzhyUlh1VGxNd1MrajZnbVg0amlZb0ZNUUVmSEIyRWd4?=
 =?utf-8?B?UytsY1lXcWk3WTJleHZocTZBUVN5Z3NMaS9tL3pML3pwS3o4NDJwb0MvMU52?=
 =?utf-8?B?Sm5sb2JMbzU5ZTJLT0Rla3FGLzJYSy8vSUdiQk53dVdtcVpnM2lqdXBiSERu?=
 =?utf-8?B?REx3aldjWDhEQlhWL1hBay9KVjQ3YWMwZktmQVdJR2hTOVczeUdHTEZyWTFs?=
 =?utf-8?B?emIveEppZ0Yxa09QTzBSUlFhUXA0UlpYK3ZOQXFKWjZWVXcxb29GQWFhaCta?=
 =?utf-8?B?dnM3bXEyYjJIZi85TlJYZy9zbEJsdk1Ob2dnd2c4ZGtHZWsvbEVwNldJMUw0?=
 =?utf-8?B?WGZnakg5S0hSLzFSdi9kaFBmUlBXMGdVYzljUXpwd29JYXBNalRaV1NydUtR?=
 =?utf-8?Q?ClvZ5e?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0PR02MB11133.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(10070799003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?YjZ4Z1cvNGdXbGlxaHMvU0FsTzI1aTRkUHM1RzJRd2M3ZytPemZVUUVNVXdF?=
 =?utf-8?B?Z0xVc3ZNd2kyeDN1OUxrNzFvMHMyOEJ4YVRYQ3J2ZzdrUC81cXo2aVNTek4w?=
 =?utf-8?B?eGtxTkRUbXB6NGlBNFd0WjBwMTIwd0VZZmdTeFBGSVBvbFFUM0RMN0taUlk1?=
 =?utf-8?B?N2NGUW5qaHdYUTI2Uzl4QjBrV1p5K0Z1bDhuL2ZlbGZCcDlKTHVIUGl1K3F4?=
 =?utf-8?B?N2RqU3VVRFp6TXNQRzAvUzhyakVlK2xTS2FReG9LTThXT080WUJPTkhTbG1Z?=
 =?utf-8?B?Q2hWYU8zMXE3TUlBL0x2b3JZbDg3OXhHNVFySTFtWGRrNDVhMjZ2aUdXZndk?=
 =?utf-8?B?aEp2TUlwY05GREpEdTlISWNQM0JiMWNqWHhXVWh2NjdpQ3hpQlB1R2o1dmZS?=
 =?utf-8?B?MnNlcE5MRFlDeWpGNTB3b3B4V0NJdU1aN2FWU3JUM3N4SzNyUHhJbHhZeFF1?=
 =?utf-8?B?cGFqRm9zdnFvR1pyNjRYczJreWlqZXdOOHl3aWNBSjZXSFJmbFRESGIvT0o5?=
 =?utf-8?B?b05LcVlQRjFQMmw0czhyaEcxNmpuMEZVRFVJYmtoQ29WSVM2RHhsS1ZNcDM3?=
 =?utf-8?B?WjYyMjIya2FTbG9lWC81WmpXKzZUM1FBVGZXT2hBYVMzRnByMk94UldTTXBm?=
 =?utf-8?B?eE4xeVR6UDh5SVViZU9PVDZrVEVLM0JPaVpuaFdvTUtna3BBbjNPd093emwr?=
 =?utf-8?B?Y3JyYnZtSlZuMWlpL2VvTGRxT2d1eWRGa1lFdjFHS2ZsckVDbUdxUVBrbUdG?=
 =?utf-8?B?VHFuY2VpUjdmckZmYXR5MGhTckt6ODNIQ2tWSFFzVUt6NXljcUsxT1RUZUJm?=
 =?utf-8?B?QlpSTXdBQXltUFlVaUpGWUhJdWZtbmx2eHZoc08yYUhzT21kUHV4V1lVNVFV?=
 =?utf-8?B?dGJWN2hhWXdJaGZSTU9HV3JkR2h0OHVVT1gvM045RXh6SDdSbXdpRGFFdnpz?=
 =?utf-8?B?VTR4dXczWXpVZnpnVEhTMHlzVjRPMW16NGsvMW80dHRTeTBNaFh1OHR4YXJM?=
 =?utf-8?B?eXNaNnk1cEw3TFdMamlXYU8rWFg2OEtTTlJqSVIrc3ZrMzlHVFJXSmo5QTFH?=
 =?utf-8?B?SkI4ajdmSUVjTTdzczlhUklDVDlDQ0RDbVhxVUJGZUozaWptY2I2ckJSUW5F?=
 =?utf-8?B?MFpjYTJPV3VVMHFwTlQzbWd1U2tMU00wUWVDcjBvb1dTeU1YNHJ6RkMyYUtm?=
 =?utf-8?B?aVQ3cjZzbzRzQkJiYlBUaWtkbmREaHArU21TNktrOXY0MVR1V0dIalU1blla?=
 =?utf-8?B?TS92QXJUMXExekhqd1JET3RMNlFuRzJzdmNPMXVSRlpxUVVNeWVYaGI3TFRk?=
 =?utf-8?B?TnJpQ2FZSHR0SE1tOEhRRFcxblJiUjlzVHpkMlVrV2VZL2MxNHBHWEVyVHI2?=
 =?utf-8?B?U1YyS2hKRi8rU0hTNGxtdlpuQ1Y5NEk5aU5hemlDZ1hTRG9Cd1RnRitySFAv?=
 =?utf-8?B?UXFuSUFabDVsSUMwWnRGcHZJbW9NMUVvdDhUeGgyMFFiQzN2M0RQRzA1WHk0?=
 =?utf-8?B?Yk5mQ0RqeldWTzVqZ0RxNVlxMXZHTzFFMk0zU3dGOWFMMEd2c1R2WEY0QU5U?=
 =?utf-8?B?NmtpdnRXV1VUZzljSDhjU1czdE13SXNiOGZZZGh2Y2MyOUdoek9XdVlzMUIw?=
 =?utf-8?B?YStkczRESk9nRnc4VVVwMmlhTE11Q1hsOFN6eW1nQUE2UEhwbm1JTzNtNmp1?=
 =?utf-8?B?RmtWc081VmVjL04wcW44L1JBYnVITk5ZTjREMnRLM1hvaFlxNHRtWWtWckgy?=
 =?utf-8?B?a2dyODRaQXdaaUhqMUpYZTZwTnlqVFEySzdtczErN3ZpMVl4U0JUS252RnJW?=
 =?utf-8?B?Y2pTY0t2ZUpyN0x4b1FXUitOaStRQTlCU2tnTDJEN20wY1pQS3YyMkJHOTND?=
 =?utf-8?B?YlZvRjFLNGhMSlpTaHdSZ3VvR3FPczh5eEJlT1FCUm9iUWI2MGtuV1FFVDd4?=
 =?utf-8?B?ZXZMQUQ0cHNqZkRuLzNBbThraVJNZzZUS05VZ3VMZGoyamdnTUx4MFhlTCtm?=
 =?utf-8?B?M1R2NUNvaGZqaFVoUUJTSVFsWTdOQng2NkZqYjVzYktQczVPckxEeHV5SWk5?=
 =?utf-8?B?TFFtK2VVckFTOEtzdjRTUlZqT3BQUXgwZUJwbEVNMGtpdVNQTE5JSlh1WjBu?=
 =?utf-8?B?QTd1MFlJZUZHMVl5Nks3ZVVlUXRTZjJUS0M4V3FUYVlaWHJ4V3h6U2JSWFFn?=
 =?utf-8?B?MWdjNnRFREFSVkxQeU9EOUsrQkZIUzFzZit2cmJFTUV2bkFncXdpT2ducEdZ?=
 =?utf-8?B?VGVjUHQxeDFYM2s0cm9nSUxiWk5kK0U0OFcwL2FRSFRJVDAvaklEbGJuZGlX?=
 =?utf-8?B?SGNZN2RrM21aaTUvQmYzOU0vWjlidjlvakFuWTZSU0lSTGNyZm1aVHNscWc3?=
 =?utf-8?Q?jK9vCQaiUdZiA1hwctvqSqO95V1oizglMHW7biSq5vGk+?=
x-ms-exchange-antispam-messagedata-1: NvbgBvp29vXPh+tFt8SzHGyppoyqjs61BCg=
Content-Type: text/plain; charset="utf-8"
Content-ID: <720E3E03E2052C4DBB4DDD0720D0B9E6@namprd02.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f35b569-f45d-4a3a-7e16-08de41d9f741
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Dec 2025 04:15:54.5003
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G/I95u53qLBAKcBYd7P3q9vs20aZVjszHeBlmYPGYeQzJdywd1MP7i6RHKdNab2T06W7FY1ZoKt4RSGDb2QbnHftuuVIUxf/OUIj2PbEp4s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR02MB8512
X-Proofpoint-ORIG-GUID: on6RtWdrXFH8G5DiP55pYX615cyKFH34
X-Proofpoint-GUID: on6RtWdrXFH8G5DiP55pYX615cyKFH34
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIzMDAzMyBTYWx0ZWRfX0ITHtgHG5YmZ
 hUCUOIyiCciB3+dputTFoGS+9BhUqEsUyViq5vR3VE3OaGqU+3iYbcsQpcJ1wm+dYdJl3gITW/M
 EmHzlyAzCYJQBDUO2jb6PD9gdJtsYPKIXAIGRJONHMhzWPI8hPLUbaYhA//SBSYoGMU67y2RqRv
 basipQyDNysk2bsU8EIFEfqYiuMArkXvhfaWWud0x0D9FRBtJXh3fS8R2ItpMczDGunhzxjxZah
 uiZKJJXp7yet69upjDssMBYMRPbcWIE22/hIpXN5q8LPMQQ1xMYQa1wnZtUK6YwjFCA4OnRxaqp
 JyC1TcCHGoGJV/1r/wcchd2RFzAD6XfmBkYD3h2cksdZ+kk7ooG63NSng75Fkm5vZYARbQAo8R8
 prrwC1OaEB0Yg67ciwiDKj2MZ2p8DvhAUNVC8dzgAvgK8VOg5m0tGK5rDLsTHmpN1sko/3bT+xB
 NsP9Muhovjb74vA6Bwg==
X-Authority-Analysis: v=2.4 cv=QZBrf8bv c=1 sm=1 tr=0 ts=694a177c cx=c_pps
 a=iWUa97dvZcywjWCZh5/f9A==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=64Cc0HZtAAAA:8 a=1XWaLZrsAAAA:8 a=RbTycAi8qh4f3MUQqEUA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-23_01,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gTWF5IDEyLCAyMDI1LCBhdCAxMDowOeKAr1BNLCBKb24gS29obGVyIDxqb25AbnV0
YW5peC5jb20+IHdyb3RlOg0KPiANCj4+IE9uIE1heSAxMiwgMjAyNSwgYXQgNToxNuKAr1BNLCBT
ZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4gd3JvdGU6DQo+PiANCj4+IE9u
IFRodSwgTWFyIDEzLCAyMDI1LCBKb24gS29obGVyIHdyb3RlOg0KPj4+IEBAIC0zNTksMTUgKzM2
MCwxNyBAQCBUUkFDRV9FVkVOVCgNCj4+PiBfX2VudHJ5LT5zcHRlcCA9IHZpcnRfdG9fcGh5cyhz
cHRlcCk7DQo+Pj4gX19lbnRyeS0+bGV2ZWwgPSBsZXZlbDsNCj4+PiBfX2VudHJ5LT5yID0gc2hh
ZG93X3ByZXNlbnRfbWFzayB8fCAoX19lbnRyeS0+c3B0ZSAmIFBUX1BSRVNFTlRfTUFTSyk7DQo+
Pj4gLSBfX2VudHJ5LT54ID0gaXNfZXhlY3V0YWJsZV9wdGUoX19lbnRyeS0+c3B0ZSk7DQo+Pj4g
KyBfX2VudHJ5LT5reCA9IGlzX2V4ZWN1dGFibGVfcHRlKF9fZW50cnktPnNwdGUsIHRydWUsIHZj
cHUpOw0KPj4+ICsgX19lbnRyeS0+dXggPSBpc19leGVjdXRhYmxlX3B0ZShfX2VudHJ5LT5zcHRl
LCBmYWxzZSwgdmNwdSk7DQo+Pj4gX19lbnRyeS0+dSA9IHNoYWRvd191c2VyX21hc2sgPyAhIShf
X2VudHJ5LT5zcHRlICYgc2hhZG93X3VzZXJfbWFzaykgOiAtMTsNCj4+PiApLA0KPj4+IA0KPj4+
IC0gVFBfcHJpbnRrKCJnZm4gJWxseCBzcHRlICVsbHggKCVzJXMlcyVzKSBsZXZlbCAlZCBhdCAl
bGx4IiwNCj4+PiArIFRQX3ByaW50aygiZ2ZuICVsbHggc3B0ZSAlbGx4ICglcyVzJXMlcyVzKSBs
ZXZlbCAlZCBhdCAlbGx4IiwNCj4+PiBfX2VudHJ5LT5nZm4sIF9fZW50cnktPnNwdGUsDQo+Pj4g
X19lbnRyeS0+ciA/ICJyIiA6ICItIiwNCj4+PiBfX2VudHJ5LT5zcHRlICYgUFRfV1JJVEFCTEVf
TUFTSyA/ICJ3IiA6ICItIiwNCj4+PiAtICBfX2VudHJ5LT54ID8gIngiIDogIi0iLA0KPj4+ICsg
IF9fZW50cnktPmt4ID8gIlgiIDogIi0iLA0KPj4+ICsgIF9fZW50cnktPnV4ID8gIngiIDogIi0i
LA0KPj4gDQo+PiBJIGRvbid0IGhhdmUgYSBiZXR0ZXIgaWRlYSwgYnV0IEkgZG8gd29ycnkgdGhh
dCBYIHZzLiB4IHdpbGwgbGVhZCB0byBjb25mdXNpb24uDQo+PiBCdXQgYXMgSSBzYWlkLCBJIGRv
bid0IGhhdmUgYSBiZXR0ZXIgaWRlYS4uLg0KPiANCj4gUmFtcGFudCBjb25mdXNpb24gb24gdGhp
cyBpbiBvdXIgaW50ZXJuYWwgcmV2aWV3LCBidXQgaXQgd2FzIHRoZSBiZXN0IHdlIGNvdWxkDQo+
IGNvbWUgdXAgd2l0aCBvbiB0aGUgZmlyc3QgZ28tYXJvdW5kIGhlcmUgKG91dHNpZGUgb2YgYWRk
aXRpb25hbCByaWdvciBvbiBjb2RlDQo+IGNvbW1lbnRzLCBldGMpIOKApiB3aGljaCBjZXJ0YWlu
bHkgZG9u4oCZdCBoZWxwIGF0IHJ1bi90cmFjZSB0aW1lLg0KDQpJIHN0aWxsIGNvdWxkbuKAmXQg
Y29tZSB1cCB3aXRoIHNvbWV0aGluZyBjbGVhbmVyIHRoYW4gQmlnWCwgTGl0dGxlWCBoZXJlIGZv
ciB2MSwNCkJ1dCBJ4oCZbSBvcGVuIHRvIGZlZWRiYWNrIGlmIGFueW9uZXMgZ290IGNvbW1lbnRz
Lg0KDQo+Pj4gX19lbnRyeS0+dSA9PSAtMSA/ICIiIDogKF9fZW50cnktPnUgPyAidSIgOiAiLSIp
LA0KPj4+IF9fZW50cnktPmxldmVsLCBfX2VudHJ5LT5zcHRlcA0KPj4+ICkNCj4+PiBkaWZmIC0t
Z2l0IGEvYXJjaC94ODYva3ZtL21tdS9zcHRlLmggYi9hcmNoL3g4Ni9rdm0vbW11L3NwdGUuaA0K
Pj4+IGluZGV4IDFmN2IzODhhNTZhYS4uZmQ3ZTI5YTBhNTY3IDEwMDY0NA0KPj4+IC0tLSBhL2Fy
Y2gveDg2L2t2bS9tbXUvc3B0ZS5oDQo+Pj4gKysrIGIvYXJjaC94ODYva3ZtL21tdS9zcHRlLmgN
Cj4+PiBAQCAtMzQ2LDkgKzM0NiwyMCBAQCBzdGF0aWMgaW5saW5lIGJvb2wgaXNfbGFzdF9zcHRl
KHU2NCBwdGUsIGludCBsZXZlbCkNCj4+PiByZXR1cm4gKGxldmVsID09IFBHX0xFVkVMXzRLKSB8
fCBpc19sYXJnZV9wdGUocHRlKTsNCj4+PiB9DQo+Pj4gDQo+Pj4gLXN0YXRpYyBpbmxpbmUgYm9v
bCBpc19leGVjdXRhYmxlX3B0ZSh1NjQgc3B0ZSkNCj4+PiArc3RhdGljIGlubGluZSBib29sIGlz
X2V4ZWN1dGFibGVfcHRlKHU2NCBzcHRlLCBib29sIGZvcl9rZXJuZWxfbW9kZSwNCj4+IA0KPj4g
cy9mb3Jfa2VybmVsX21vZGUvaXNfdXNlcl9hY2Nlc3MgYW5kIGludmVydC4gIEEgaGFuZGZ1bCBv
ZiBLVk0gY29tbWVudHMgZGVzY3JpYmUNCj4+IHN1cGVydmlzb3IgYXMgImtlcm5lbCBtb2RlIiwg
YnV0IHRob3NlIGFyZSBxdWl0ZSBvbGQgYW5kIElNTyB1bm5lY2Vzc2FyaWx5IGltcHJlY2lzZS4N
Cg0KQWNrL2RvbmUgLSB0aGFua3MgZm9yIHRoZSBmZWVkYmFjaywgSeKAmXZlIGludGVncmF0ZWQg
dGhpcy4gU2VlIHdoYXQgSSBkaWQgaW4gdjEsDQpidXQgSeKAmXZlIGFsc28gYWRkZWQgYSBURFAg
YXdhcmUgdmVyc2lvbiBpc19leGVjdXRhYmxlX3B0ZV9mYXVsdCBmb3IgZmF1bHQtPmlzX3RkcA0K
YXMgSSAqdGhpbmsqIHdlIGFjdHVhbGx5IG5lZWQgdG8gY2hlY2sgdGhpcyB0byBmaWd1cmUgb3V0
IHRoaXMgdXNlciBhY2Nlc3MgdnMgbm9uIHVzZXINCmFjY2Vzcy4gSSBtaWdodCBiZSBtaXNpbnRl
cnByZXRpbmcgVERQLCBzbyBJ4oCZZCBhcHByZWNpYXRlIHNvbWUgc2FuaXR5IGNoZWNraW5nIHRo
ZXJlLg0KDQo+Pj4gKyAgICAgc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0KPj4gDQo+PiBUaGlzIG5l
ZWRzIHRvIGJlIGFuIG1tdSAob3IgbWF5YmUgYSByb290IHJvbGU/KS4gIEhtbSwgdGhpbmtpbmcg
YWJvdXQgdGhlIHBhZ2UNCj4+IHJvbGUsIEkgZG9uJ3QgdGhpbmsgb25lIG5ldyBiaXQgd2lsbCBz
dWZmaWNlLiAgU2ltcGx5IGFkZGluZyBBQ0NfVVNFUl9FWEVDX01BU0sNCj4+IHdvbid0IGxldCBL
Vk0gZGlmZmVyZW50aWF0ZSBiZXR3ZWVuIHNoYWRvdyBwYWdlcyBjcmVhdGVkIHdpdGggQUNDX0VY
RUNfTUFTSyBmb3INCj4+IGFuIE1NVSB3aXRob3V0IE1CRUMsIGFuZCBhIHBhZ2UgY3JlYXRlZCBl
eHBsaWNpdGx5IHdpdGhvdXQgQUNDX1VTRVJfRVhFQ19NQVNLDQo+PiBmb3IgYW4gTU1VICp3aXRo
KiBNQkVDLg0KPj4gDQo+PiBXaGF0IEknbSBub3Qgc3VyZSBhYm91dCBpcyBpZiBNQkVDL0dNRVQg
c3VwcG9ydCBuZWVkcyB0byBiZSBjYXB0dXJlZCBpbiB0aGUgYmFzZQ0KPj4gcGFnZSByb2xlLCBv
ciBpZiBpdCBzaG92aW5nIGl0IGluIGt2bV9tbXVfZXh0ZW5kZWRfcm9sZSB3aWxsIHN1ZmZpY2Uu
ICBJJ2xsIHRoaW5rDQo+PiBtb3JlIG9uIHRoaXMgYW5kIHJlcG9ydCBiYWNrLCBuZWVkIHRvIHJl
ZnJlc2ggYWxsIHRoZSBzaGFkb3dpbmcgcGFnaW5nIHN0dWZmLCBhZ2Fpbi4uLg0KDQpTb2xkISBJ
IG1hZGUgdGhpcyBwYXJ0IG9mIGt2bV9tbXVfcGFnZV9yb2xlIGZvciBhY2Nlc3MgYml0IGFuZCBh
bHNvIGEgbmV3IOKAnGhhc19tYmVj4oCdDQp3aGljaCBib3RoIGhlbHBlZCBzaW1wbGlmaWVkIHRo
ZSBvdmVyYWxsIHdvcmsgKHRoYW5rcyEpIGFuZCBtYWRlIGl0IGNsZWFuZXIgdG8gZW5hYmxlDQoN
Cj4+PiB7DQo+Pj4gLSByZXR1cm4gKHNwdGUgJiAoc2hhZG93X3hfbWFzayB8IHNoYWRvd19ueF9t
YXNrKSkgPT0gc2hhZG93X3hfbWFzazsNCj4+PiArIHU2NCB4X21hc2sgPSBzaGFkb3dfeF9tYXNr
Ow0KPj4+ICsNCj4+PiArIGlmICh2Y3B1LT5hcmNoLnB0X2d1ZXN0X2V4ZWNfY29udHJvbCkgew0K
Pj4+ICsgeF9tYXNrIHw9IHNoYWRvd191eF9tYXNrOw0KPj4+ICsgaWYgKGZvcl9rZXJuZWxfbW9k
ZSkNCj4+PiArIHhfbWFzayAmPSB+Vk1YX0VQVF9VU0VSX0VYRUNVVEFCTEVfTUFTSzsNCj4+PiAr
IGVsc2UNCj4+PiArIHhfbWFzayAmPSB+Vk1YX0VQVF9FWEVDVVRBQkxFX01BU0s7DQo+Pj4gKyB9
DQo+PiANCj4+IFRoaXMgaXMgZ29pbmcgdG8gZ2V0IG1lc3N5IHdoZW4gR01FVCBzdXBwb3J0IGNv
bWVzIGFsb25nLCBiZWNhdXNlIHRoZSBVL1MgYml0DQo+PiB3b3VsZCBuZWVkIHRvIGJlIGludmVy
dGVkIHRvIGRvIHRoZSByaWdodCB0aGluZyBmb3Igc3VwZXJ2aXNvciBmZXRjaGVzLiAgUmF0aGVy
DQo+PiB0aGFuIHRyeWluZyB0byBzaG9laG9ybiBzdXBwb3J0IGludG8gdGhlIGV4aXN0aW5nIGNv
ZGUsIEkgdGhpbmsgd2Ugc2hvdWxkIHByZXANCj4+IGZvciBHTUVUIGFuZCBtYWtlIHRoZSBjb2Rl
IGEgd2VlIGJpdCBlYXNpZXIgdG8gZm9sbG93IGluIHRoZSBwcm9jZXNzLiAgV2UgY2FuDQo+PiBl
dmVuIGltcGxlbWVudCB0aGUgYWN0dWFsIEdNRVQgc2VtYW5jdGljcywgYnV0IGd1YXJkZWQgd2l0
aCBhIFdBUk4gKGVtdWxhdGluZw0KPj4gR01FVCBpc24ndCBhIHRlcnJpYmxlIGZhbGxiYWNrIGlu
IHRoZSBldmVudCBvZiBhIEtWTSBidWcpLg0KPiANCj4gK0FtaXQNCj4gDQo+IFdl4oCZcmUgb24g
dGhlIHNhbWUgcGFnZSB0aGVyZS4gSW4gZmFjdCwgQW1pdCBhbmQgSSBoYXZlIGJlZW4gdGFsa2lu
ZyBvZmYgbGlzdCBhYm91dA0KPiBHTUVUIHdpdGggKG5vdGlvbmFsbHkpIHRoaXMgc2FtZSBnb2Fs
IGluIG1pbmQsIG9mIHRyeWluZyB0byBtYWtlIHN1cmUgd2UgZG8gdGhpcyBpbg0KPiBzdWNoIGEg
d2F5IHdoZXJlIHdlIGRvbuKAmXQgbmVlZCB0byByZXdvcmsgdGhlIHdob2xlIHRoaW5nIGZvciBH
TUVULg0KPiANCj4+IA0KPj4gaWYgKHNwdGUgJiBzaGFkb3dfbnhfbWFzaykNCj4+IHJldHVybiBm
YWxzZTsNCj4+IA0KPj4gaWYgKCFyb2xlLmhhc19tb2RlX2Jhc2VkX2V4ZWMpDQo+PiByZXR1cm4g
KHNwdGUgJiBzaGFkb3dfeF9tYXNrKSA9PSBzaGFkb3dfeF9tYXNrOw0KPj4gDQo+PiBpZiAoV0FS
Tl9PTl9PTkNFKCFzaGFkb3dfeF9tYXNrKSkNCj4+IHJldHVybiBpc191c2VyX2FjY2VzcyB8fCAh
KHNwdGUgJiBzaGFkb3dfdXNlcl9tYXNrKTsNCj4+IA0KPj4gcmV0dXJuIHNwdGUgJiAoaXNfdXNl
cl9hY2Nlc3MgPyBzaGFkb3dfdXhfbWFzayA6IHNoYWRvd194X21hc2spOw0KDQpUaGFua3MgZm9y
IHRoZSBzdWdnZXN0aW9uIG9uIHRoZSBjb2RlIHNpZGUsIEnigJl2ZSBpbnRlZ3JhdGVkIHRoYXQu
IEkgaGF2ZW7igJl0IGZ1bGx5DQpwdXQgbXkgdGVldGggaW50byBHTUVULCBidXQgQW1pdCBJ4oCZ
ZCBhcHByZWNpYXRlIGEgcmV2aWV3IG9mIHdoYXQgSeKAmXZlIGRvbmUgb24gdGhlDQpNTVUgZGVz
aWduIHNpZGUgZm9yIFYxIHNlcmllcyBhbmQgbGV0IG1lIGtub3cgaWYgdGhlcmUgYXJlIEdNRVQg
cHJlcCB0d2Vha3MgdGhhdA0KbWFrZSBzZW5zZSAob3Igd2UgY291bGQganVzdCBwdW50IGl0IHRv
IGEgZnV0dXJlIEdNRVQtc3BlY2lmaWMgc2VyaWVzLCBlaXRoZXIgd2F5KS4NCg0K

