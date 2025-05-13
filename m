Return-Path: <kvm+bounces-46283-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F113FAB4959
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 04:15:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6981919E0F17
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 02:15:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 370951953AD;
	Tue, 13 May 2025 02:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="MR/Zk7Nk";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="XinK8dMp"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865411B3950;
	Tue, 13 May 2025 02:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747102516; cv=fail; b=ueX1+qym34HyxpFVm1DLEMFavOARCqnJxz7tROr6hN/AITWYGe9z2iNzNDXX1s5fjUACmpmuOtAcQ1M+c0scJg8x/YTIB3Y2+da64sKdtzyXazhFwsWC5SdFQk/EWkbGC4xmL3bZlWSuNU+Cuk1q8lDKzFVB+eUeljf9ThoHxj8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747102516; c=relaxed/simple;
	bh=cw4PXC8fwwT7BscpsJQkUPSMnkyuG5o7KOEA8IaB6Zg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=e8HXJhomcD8CVtMo0tDTGYQcua1NxYIanDblxREEmp50hqO78FSOuiptMa1ZPuGswsd5ilS3EgwN678j0T4whgfOAssAqgNzhn8ZjsRJZQUrWyelHW417F77NhewWrQMuKtSjAf9+HO4gmKt5C5e8ojwYlNWPF9kkx4PkESMWgQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=MR/Zk7Nk; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=XinK8dMp; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54CIKMUB007643;
	Mon, 12 May 2025 19:14:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=cw4PXC8fwwT7BscpsJQkUPSMnkyuG5o7KOEA8IaB6
	Zg=; b=MR/Zk7NkLfpAQF08830jh60U94UGRXPLP7BihSVZlo7gdNXMJCte471+I
	pNQkF46pcYFBVL/vE4b6nKFrwdrWCvPMOkUhTs9YT4AFOfjlP/m1icZy34fVvjlg
	X4lyjx3yNf8iriXrNRxGSE7G9EeI4Ys5xQRMfy3ux4G6JC2ZqUrrNYsoSD+WO3yF
	fjNy3zsnwXcGz8/c7cMUSXDsSj4CpHkqZwm8BTXxdUNj3/i8qz9fkNMxakraM7jU
	uYs/h6ePJMm/MZZFMZeCzYuzmydPPCh00zhCp7s6DWRDorgVfTQmSvGix/PHaNZ9
	y97u8BzDcuGxYTjvpXdu1DH+tP12g==
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 46j6b04kw9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 12 May 2025 19:14:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Vvw+A5aG/sUrnZW/FnwzkcQeYOxIHJVq7dGfi71FjMEm9AdAfU22JS1Fi9W7pYfsbEqCfhiznQJJBWg1P3ExbOrBbuXbzDR99NISQsAMJrdM2kNbsyVN3b8heTGoLRfzEEe87M2WLvA0HiHndSPdtQGBppWd/dBfzhYuuTaiEbFuwk6W+y16JaiFu+fmDX7+xrYiPPZC+Jk5BQrauMDYsQhtEIl9x8eorjlXN5Fqll2uGOXnlFbfBPEMVLeKP7ViVq0vskE/1qQ+ptkJIhNtGNijMxCp7CNYD4dNo4L4jbFZpCNmmvM3XKeaplU3koiZANpl906RvkDWcUcDyQI+CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cw4PXC8fwwT7BscpsJQkUPSMnkyuG5o7KOEA8IaB6Zg=;
 b=hIavTc6clAWTZ5bW167fyenSy9kISdHddgnDyxygi2x+U6x0r1OBrWG+dMWaBvoUZsx6jojS3aK3bt0SPt9ukQ5F16XTWKS7QyBCg0ep6nphXzA0Cc1bpU17oDO8AdYH2oJjn6XYO+kwFBLdDBeQntvoFgkoHt0jZLj84oN+zOcHseIZbmx69SmltvxWluHoFMLbAiE3walh4zE0gwUxsorX2u94i0aizYmsBb3hvjAKz0ry5nM0fvuw4amGetnyzj/hVK1L6apGS9ho5apnkMKnyRy7tNPqD1I1v9DpoDc0BdsdlJvnwYTCQQl/g+nHIM9oFikcDzFS+9cnESCY8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cw4PXC8fwwT7BscpsJQkUPSMnkyuG5o7KOEA8IaB6Zg=;
 b=XinK8dMp2nXkesrOnXLgBXUT6URQkEGKY8wPHClqeQZ069pa74wmay2GsaXjKlV/I9tHoudI330Eci7j2o/bCfkmWFeBxDjjv9TQknZE8C4PBeRfCRueXQg/Osj2D4MEb5tC80Ja45U70olRMQwGCUeBe8bA3AscTXmJ25t0N5DCFHjzgYusTFGM1+tPiGhulMgAoMs6LsRVrJLXXHCqxjtNKvM9bT9+SHl8zEeG/C0toou+owXK4h+fwpAQC+rE7r9q6039hZsWcKjqPDwqfLIsIcd1j8Z9apiAKDqcYLQR9XQzYGWwLYQtFQmKbc6yIVX4y4bkjITgXcWgyZGfVw==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by SJ0PR02MB7151.namprd02.prod.outlook.com
 (2603:10b6:a03:290::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.28; Tue, 13 May
 2025 02:14:46 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%5]) with mapi id 15.20.8722.027; Tue, 13 May 2025
 02:14:45 +0000
From: Jon Kohler <jon@nutanix.com>
To: Sean Christopherson <seanjc@google.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de"
	<tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de"
	<bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        =?utf-8?B?TWlja2HDq2wgU2FsYcO8bg==?=
	<mic@digikod.net>,
        Sergey Dyasli <sergey.dyasli@nutanix.com>
Subject: Re: [RFC PATCH 09/18] KVM: x86/mmu: Extend access bitfield in
 kvm_mmu_page_role
Thread-Topic: [RFC PATCH 09/18] KVM: x86/mmu: Extend access bitfield in
 kvm_mmu_page_role
Thread-Index: AQHblFPzZbE3L8M/tkagt2HsJIwA07PPr9yAgACBBoA=
Date: Tue, 13 May 2025 02:14:45 +0000
Message-ID: <A72BD2D1-4D38-4F3E-B05F-A9002256BFBF@nutanix.com>
References: <20250313203702.575156-1-jon@nutanix.com>
 <20250313203702.575156-10-jon@nutanix.com> <aCI-z5vzzLwxOCfw@google.com>
In-Reply-To: <aCI-z5vzzLwxOCfw@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.400.131.1.6)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV8PR02MB10287:EE_|SJ0PR02MB7151:EE_
x-ms-office365-filtering-correlation-id: ce73d680-191d-4036-efc3-08dd91c3ee3e
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|366016|10070799003|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?Y1VnaFpqMXo1bHloVUNmVS9NRXE0WkZDTXpLUDRnMzYwS3E5d1lvbGFVY1J2?=
 =?utf-8?B?N1d5WVBzTDZvZExaa3hkSnlhR0JsSmUyb284SGljWlpQN2lqNDFJbmNDdHhU?=
 =?utf-8?B?NnRZQ0hzVWNKUnBjNTh4eDN2SmxoenFjUEd0N0o3UWJTUklFZS9xdWdEK2lz?=
 =?utf-8?B?cllWL0tkL0hGWTZNVTJ2UUZMYzBWQUx4UjZsWDFHUHFhK0ZJTUVTSGxwREpK?=
 =?utf-8?B?RklWbm5RNGF0ZGJyRHdJQ2YzT1hOY2IyQjU4NXhQYnJsdlQ1UzA2c0ZQUzJP?=
 =?utf-8?B?Rm9RdzVLV2dUa1RGMFNwNEVwV3NqUWVWWjQ2Yll6UGFCYkZkMjVQQUlIQUNW?=
 =?utf-8?B?cVdrdnVteFROeHpka00za292Vno4RFZKSFlFeHN1Q29oeEJiN3QxNVErV016?=
 =?utf-8?B?dEI1alcyWWFRaVhwbEl2dlRNczRQenY2Slp3ZXN1QThCSXBMeTlsUDloWVNT?=
 =?utf-8?B?Z2NrUFNXcXJpM0R0UlBPYUJUdzB6N2FxVExybUJFU1lDUml6NzJxR0NJRTI1?=
 =?utf-8?B?SzlzUkJ3ZkNKMGNkWWNXZ2Y2Z0I3c2trL3pzamZEUDI0dVkvNFU0YzduSmRv?=
 =?utf-8?B?MTgyQWU3ZGRnb0o4aTRCcDhtUnNSK2ZkRmlNVEVUSVhYRFlNT2tHclZrdm1h?=
 =?utf-8?B?TTQ2M1NLQVNRVy9QVDM2R2V6MzBtdVZSRlJGSFZ5Z1EyTkEvc25OV3hmbmRy?=
 =?utf-8?B?Q3owYWRHNWwzNWE2TUxVV2FLM0VyRWxjZUwxREcrTUw3Wk80Y2N5WE9QMitN?=
 =?utf-8?B?Wkp6L1BTZHhLaXFCQXF1UW1CUUxHOXIvWTkwa2c2TVhWMWp5OFJ0c28rT1RC?=
 =?utf-8?B?d0RwTFJpZ0tuYWNWVHBieHBzU2ZybTNQVUJFbTQxSVM3V05jMU1UaEVJMXVz?=
 =?utf-8?B?Z2x5bTc5ZmNXd3JRRWRrWUlHb2tpRGhKUko4L1ZTb2NwSFhFa0xpL0d3QVc5?=
 =?utf-8?B?V2tkSUZPR2FUKzRVR1FEVXdhTmw2RlAzNlJmTThNbEl5cWdobzIxelhrVGZH?=
 =?utf-8?B?Z0JCOUYxWkRCYnc3ZS9oVFEwK2llcFVxYU9RZStjZ2tzeVVwZzRXTlZzZEF1?=
 =?utf-8?B?QWZJRTJWTW1qemRmQ253eDBvSVZibXoweW5kNzl3NEduU2YvVENUd1FVNFk4?=
 =?utf-8?B?OTNLakpmYzdrUExOZTdHNkwySGNpdisyN2liSkNYeHd3UVRhbllqbjR6NWRX?=
 =?utf-8?B?eTBHOUlNNnU2djM2M1VrcXdRSU9NVlBHeFRkT0hBc0tTY0Y2Yk1mOXE4cm1s?=
 =?utf-8?B?MmNLR3pyRWhUd3lhNE9GU1dtZ0Z3NFJSN0RoTW8zU1dLSU4wTTFqNzBQVWlu?=
 =?utf-8?B?STZVWXdkSCs1OHRCV25xMmRrUTlEd2VocjVMNzFUVk1nL0NJZHNzYkducHd1?=
 =?utf-8?B?SVgyR1l3MFp0QXdWcWplT0txUC81ZEkwY0ZERUVXdjZmYTQ1SWxiK1djUWcy?=
 =?utf-8?B?RG00TEZUTlhEcHY0YWFNczVvdHA4RUZ4MnV3eHZjT0pRSDhOanlaejFpdUtr?=
 =?utf-8?B?UkluRWUxTHFzL0dVSmlTM0hjcnRkUzlsSStsdjZHUkhVRGVBbWwybHVQUFgx?=
 =?utf-8?B?a2o2bTZNa3EzbHFCMnhMTFNXSXZLcDZxVUZQakhMQTcrWDVoVGxNSFNnRkRy?=
 =?utf-8?B?Mmo2STFCUitPWGlRcjh1SFBQUHkzazgxUm9ENXI0WVhGaklsNVdTcEVBWHJi?=
 =?utf-8?B?Z1ZuaURWVjNZVThBNzg2K0hEaFc1Z1hsV0gzOERjN3FnY0hvRVN1WW51SnJX?=
 =?utf-8?B?SWZEWUVsNlA4Vzk5UDZqMVhIMWtjVDIzMmVYa3F5MGFYNTZWY3M4dDlUbzYw?=
 =?utf-8?B?SmtPZ3JjbmdwWWhNRGFTQWUyWHVJVHVSWGNELzFlYmMvYXNrTmxsb21TMVlW?=
 =?utf-8?B?bHlnOTVsVU1RYUY0cFhlSnlyRnBYb0ZNSzlMK3c2aVpQNDRNeUtZdU1EcHhT?=
 =?utf-8?B?ODhISS8wZ0hjcFFvVUFVNkovQjBWQkVaU0thWDZHcnRJeFlxT0hpNUlaL01l?=
 =?utf-8?Q?9ONqiPdkbybqoVvDGLibjhI/K0CbWs=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(10070799003)(1800799024)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TnNsNDFCYnhKeDQzVE5UWXpVNFZoVzArU0luQVBVWFpnSS9tNUZJOFB6SjZT?=
 =?utf-8?B?WUpwMC9GWkZNaDZHN2plZkFJL2NvaTFsdDUzU0F5Y2tZWHdaQW9hVlppKzBa?=
 =?utf-8?B?Q3Byd0FLblZtRDdVR0tGWkRUcUVIeXdiOVFVbTIydVFnQUV0QnhwZXVDQ041?=
 =?utf-8?B?b2NvMzBqbG55U2pINDZWYkl2cEpSa1paZG0vZDYvcGdwVzJ0eHZabHNhSTkz?=
 =?utf-8?B?WEhGRXAycG9HdnA2d1NSU29KNk5DeWFPdnpIQUZrWHBwYlY0ZmQvektLNEdk?=
 =?utf-8?B?dEU0SlJUZk1WZWMzT0wwdDFxM2tFUVl1YmtiL2lCUUw0MG81ODRCZXdwMXpO?=
 =?utf-8?B?SFE5NWYveGFIQXBOTU0xN0F6MGxVeTVkMXdzSG9TZkxpNFJIc3Q2N2pZOTh6?=
 =?utf-8?B?b2plaUNhVlVBblFhaFBwTlptN1F0dTQyNDgwV3cxOEhpZG1JTlhXUDZTV2xy?=
 =?utf-8?B?SXhRT3ROZms2ZjhZSHFoeUJzUjFFbVJ4WEs5RkxubTZvNXo4RFdmWWUzMDRl?=
 =?utf-8?B?emNUR0VDdkxGaU9TeVdKYzh5ZytXL2o1b3RPTEUxRkF0S3lzTURvakphb1RD?=
 =?utf-8?B?VUpSMm5RdlhJZmpvOTdpeExXTkg0blZPejJzODB3TG1VQ1d6emdDdHVvZWJz?=
 =?utf-8?B?a0VLN0VzTHg1dENFT2VlZDhyTEVsSk1uVWhCNG14eCtYZytxUUpOK1M2ejMr?=
 =?utf-8?B?aXFwYThMY1V4ZnJEK3lxL2dhaXdvVXlPWnEvaUdCVUtuVC9SallQOTVscW5K?=
 =?utf-8?B?blhtRHBweC80b2pZRnVTMFlhSzFHTE1XOFJwZDk2cmoyTTZpVWR1Q2w1ZWVh?=
 =?utf-8?B?ekYyNXQzMDhzay9yc2h3L01Rd1B5SEVsQkFKd2ZPZmp1NzE2dnlKbUp2Um8x?=
 =?utf-8?B?WTNSYVI5UzRWQldiY1hIa25wRVVVWHVOTHBUeHF1N3JPZXIzWVAwUlFxdEpN?=
 =?utf-8?B?QytDcWFFd2FSSnJIQ3JGUXFXa2F4WE9FWHJVeWNGNXNsMXpJRzJ4dmhYSnhO?=
 =?utf-8?B?TGJuT0o3aDdHZWMrVXhFamd3dFA3SkRDMEdBczZmUHNyU2pzVkQ1VHN5MXNa?=
 =?utf-8?B?T0VmdVVPVnhXYi9hdWk5alBmVk9uZ1ZrNVFCUnRmZWdFMm1vNXd2WWZ5eWho?=
 =?utf-8?B?TFJqczUvUGNRaFlFcUhiVGFCRUtnRjdIQVNxV1hqL0lObnNXT3BSRWQyMDdh?=
 =?utf-8?B?YTRtRmt2eVZydk9NL0w5bUk4OGVselZnbWhkZ0Q5dUZ4NVlQN1dxTGxJR0w4?=
 =?utf-8?B?M3J4WUsrTk9vaTRSQml3cE9DSm4rbUxscXdKREJpZWlwY2pWT3hXRkdxRGM3?=
 =?utf-8?B?VmhTR2dzZk9IeE5Pb3dVY2l2OGZYTC9jWk5oNC9zSXVGaXlPcWlkanFrNmJh?=
 =?utf-8?B?RTNFeDFFbUVvV3pRMUNKRTZZSFFldWFRVlFNbTlmSkF4UU9jVktobEZJM0FN?=
 =?utf-8?B?Z1VFVE16cURJSVJtNDVDTmJKM1IvanRCUnI0TjlEbFNUcXo4QXg2bjh4eVJm?=
 =?utf-8?B?cnE4TVUxUkRWK081alVPMmZKeVkwTGJCaEdxZ1N6TWRFa2NFUGVrV1dwUEU2?=
 =?utf-8?B?amNDc3l0ejVIbDNESHN5UnJaVmVNQWNYUkFtbXVnZHBLa3QyZ2NsTGhCM2FX?=
 =?utf-8?B?dmdmMzY2UUlVaDIweERtc0RoNm5TamNWUGNTWFdEVXBrN0xmVkFoQVljOW1N?=
 =?utf-8?B?Z2NGUGdVUUxDL0VTS3l6QjhHT1JzQmh4M05MdXhhNGFTVEtTTWYwNHVyclJq?=
 =?utf-8?B?VlBkaFQ5TFpaVSt2dXJ0NVlZOERGTE40eGs0VzF1clBrVVJvV25QZVZzK29W?=
 =?utf-8?B?WWliYWFsd200WW55OUtPNVlMT0YrNjNXQmdCWWtXVlRyK0xiQ1MvNkptekZ1?=
 =?utf-8?B?WWdQdXVyZ0l2NmFPSmtTSFpUclhKbzVhTGo4TXhMOWlPbUROUWNzYUwySzEr?=
 =?utf-8?B?NFc2MllSREl5TThOcllBdlk4aWZ3REk1WlhFcUExT2hPTytOTHVYTXJNMVhL?=
 =?utf-8?B?Nzk5UUt3NFovUW5Sc3hIQXNEVk9WR1daZVptVTJQN0lyQ0FzL1NDTzg1UDk2?=
 =?utf-8?B?eFU1QXl3ZmRLYmdvdEhkQkxuYSsvcWpkRUM3Z0t0aVVleGN0a0Rsck9BVzhU?=
 =?utf-8?B?K01UTWxHV2pVUkJ6amRweFQ2ellXYjNSNk5DOGZxSHBLMzdiRWt6bnNlS2Zj?=
 =?utf-8?B?TXFaR3Jueit3QVdzS2tyckNMTDQxRm15TENRU2RvbDQ3UWxCZmNQRHZTSzVU?=
 =?utf-8?B?UUx0YzV1Q2RCaFF2cTdYeUwrMnZRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <368E4F0153ABFA4DA28C0E8C11243C19@namprd02.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: ce73d680-191d-4036-efc3-08dd91c3ee3e
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2025 02:14:45.7695
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sxUqP3kif4clCpUy3kEbuuqCCxIkE0kqexU3XTYp9KaSfjjMwWM0IL85HojdLmgKMoBtr4NisW1tH0q/qSrlrau5ga0hhu1X9rs17smbv00=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR02MB7151
X-Proofpoint-GUID: G9F7VwopmTnzymO-kAc8uUUg-5-aMXVv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTEzMDAxOSBTYWx0ZWRfX+LxLMjNMX7Go klquPQZIHDLgcSa9r7W1ClOBeE/eR2Ucni/epBH20tUOJoY5swR0WiDK9xbdfSqbVP19r5xr1yu bGUbluWVPCgVnMEydXCFtWA4/NOjgZQGky26n5fKOrP2HSlyFOXWvXQvfq26xvlVL/PH/oMk2dC
 +JGBBceNYcQEZc19w+YiA76Lgq0ER75DahNgnO9H3Cqfqrvzrm7d2iT1a8zRgO99PqeMBq8RXVF HxS2a5YwcwOJ8og5paQtMasfiJrOt+9uTcln/OSKpDR1kyoFsY4vqCsKLhVFV/AL1ce6ELN5Mcl y4WNJ57ass6NHRbLppD5mFion9dzXkfKXLcV1wGPfFwgq1Lt79DMYpmlygSGRbB1GrjWXSXEae4
 p8HIlr2QZIrYC2oIvop0PeaDY7L9sL6MpG7GPujHoRHWjyng14k/X6OzNhVKGoDgoKWJx6b/
X-Authority-Analysis: v=2.4 cv=FZs3xI+6 c=1 sm=1 tr=0 ts=6822ab18 cx=c_pps a=F+2k2gSOfOtDHduSTNWrfg==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=dt9VzEwgFbYA:10 a=0kUYKlekyDsA:10 a=1XWaLZrsAAAA:8 a=gl23KLxdzlndNxrgooIA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: G9F7VwopmTnzymO-kAc8uUUg-5-aMXVv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-12_07,2025-05-09_01,2025-02-21_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gTWF5IDEyLCAyMDI1LCBhdCAyOjMy4oCvUE0sIFNlYW4gQ2hyaXN0b3BoZXJzb24g
PHNlYW5qY0Bnb29nbGUuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElP
TjogRXh0ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gT24gVGh1LCBNYXIg
MTMsIDIwMjUsIEpvbiBLb2hsZXIgd3JvdGU6DQo+PiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3Zt
L21tdS9zcHRlLmggYi9hcmNoL3g4Ni9rdm0vbW11L3NwdGUuaA0KPj4gaW5kZXggNzFkNmZlMjhm
YWZjLi5kOWUyMjEzM2I2ZDAgMTAwNjQ0DQo+PiAtLS0gYS9hcmNoL3g4Ni9rdm0vbW11L3NwdGUu
aA0KPj4gKysrIGIvYXJjaC94ODYva3ZtL21tdS9zcHRlLmgNCj4+IEBAIC00NSw3ICs0NSw5IEBA
IHN0YXRpY19hc3NlcnQoU1BURV9URFBfQURfRU5BQkxFRCA9PSAwKTsNCj4+ICNkZWZpbmUgQUND
X0VYRUNfTUFTSyAgICAxDQo+PiAjZGVmaW5lIEFDQ19XUklURV9NQVNLICAgUFRfV1JJVEFCTEVf
TUFTSw0KPj4gI2RlZmluZSBBQ0NfVVNFUl9NQVNLICAgIFBUX1VTRVJfTUFTSw0KPj4gLSNkZWZp
bmUgQUNDX0FMTCAgICAgICAgICAoQUNDX0VYRUNfTUFTSyB8IEFDQ19XUklURV9NQVNLIHwgQUND
X1VTRVJfTUFTSykNCj4+ICsjZGVmaW5lIEFDQ19VU0VSX0VYRUNfTUFTSyAoMVVMTCA8PCAzKQ0K
Pj4gKyNkZWZpbmUgQUNDX0FMTCAgICAgICAgICAoQUNDX0VYRUNfTUFTSyB8IEFDQ19XUklURV9N
QVNLIHwgQUNDX1VTRVJfTUFTSyB8IFwNCj4+ICsgIEFDQ19VU0VSX0VYRUNfTUFTSykNCj4gDQo+
IFRoaXMgaXMgdmVyeSBzdWJ0bHkgYSBtYXNzaXZlIGNoYW5nZSwgYW5kIEknbSBub3QgY29udmlu
Y2VkIGl0cyBvbmUgd2Ugd2FudCB0bw0KPiBtYWtlLiAgQWxsIHVzYWdlIGluIHRoZSBub24tbmVz
dGVkIFREUCBmbG93cyBpcyBhcmd1YWJseSB3cm9uZywgYmVjYXVzZSBLVk0gc2hvdWxkDQo+IG5l
dmVyIGVuYWJsZSBNQkVDIHdoZW4gdXNpbmcgbm9uLW5lc3RlZCBURFAuDQo+IA0KPiBBbmQgdGhl
IHVzZSBpbiBrdm1fY2FsY19zaGFkb3dfZXB0X3Jvb3RfcGFnZV9yb2xlKCkgaXMgd3JvbmcsIGJl
Y2F1c2UgdGhlIHJvb3QNCj4gcGFnZSByb2xlIHNob3VsZG4ndCBpbmNsdWRlIEFDQ19VU0VSX0VY
RUNfTUFTSyBpZiB0aGUgYXNzb2NpYXRlZCBWTUNTIGRvZXNuJ3QNCj4gaGF2ZSBNQkVDLiAgRGl0
dG8gZm9yIHRoZSB1c2UgaW4ga3ZtX2NhbGNfY3B1X3JvbGUoKS4NCj4gDQo+IFNvIEknbSBwcmV0
dHkgc3VyZSB0aGUgb25seSBiaXQgb2YgdGhpcyBjaGFuZ2UgdGhhdCBpcyBkZXNyaWFibGUvY29y
cmVjdCBpcyB0aGUNCj4gdXNhZ2UgaW4ga3ZtX21tdV9wYWdlX2dldF9hY2Nlc3MoKS4gIChBbmQg
SSBndWVzcyBtYXliZSB0cmFjZV9tYXJrX21taW9fc3B0ZSgpPykNCj4gDQo+IE9mZiB0aGUgY3Vm
ZiwgSSBkb24ndCBrbm93IHdoYXQgdGhlIGJlc3QgYXBwcm9hY2ggaXMuICBPbmUgdGhvdWdodCB3
b3VsZCBiZSB0bw0KPiBwcmVwIGZvciBhZGRpbmcgQUNDX1VTRVJfRVhFQ19NQVNLIHRvIEFDQ19B
TEwgYnkgaW50cm9kdWNpbmcgQUNDX1JXWCBhbmQgdXNpbmcNCj4gdGhhdCB3aGVyZSBLVk0gcmVh
bGx5IGp1c3Qgd2FudHMgdG8gc2V0IFJXWCBwZXJtaXNzaW9ucy4gIFRoYXQgd291bGQgZnJlZSB1
cA0KPiBBQ0NfQUxMIGZvciB0aGUgZmV3IGNhc2VzIHdoZXJlIEtWTSByZWFsbHkgdHJ1bHkgd2Fu
dHMgdG8gY2FwdHVyZSBhbGwgYWNjZXNzIGJpdHMuDQoNCkF0IGZpcnN0IGJsdXNoLCBJIGxpa2Ug
dGhpcyBBQ0NfUldYIGlkZWEuIEnigJlsbCBjaGV3IG9uIHRoYXQgYW5kIHNlZSB3aGF0DQp0cm91
YmxlIEkgY2FuIGdldCBpbi4NCg0K

