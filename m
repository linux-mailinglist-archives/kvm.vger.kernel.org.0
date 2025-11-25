Return-Path: <kvm+bounces-64552-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id CCAF3C86D7D
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 20:46:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 8D847351DA4
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 19:46:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C6BF33AD88;
	Tue, 25 Nov 2025 19:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="ffP59Le1";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="Fm5NFOFv"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429261F9F7A;
	Tue, 25 Nov 2025 19:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764099951; cv=fail; b=b447e7tjmojoD9EZryvI+pnCUnB44sUprsSTvDAnUZ4I+cBLRvoNENB+Yr2VhZH3rKAaQsou37cdVG5YRc7JH9x9CZKOKdyoVGMVxmzwkbOim7c46ubcDQGPkXamNcKrocea3xx0SyJzPU7L89s1EDozUkJEGzDLeflsOPGROlA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764099951; c=relaxed/simple;
	bh=hspHssVuh7wT87Guded4Icn8te6dR0PxXLQE6Vp0eQY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jpuNbqgm3632dg2gtdF6wEU70B4dXExAuSUjQWYVG3qjxbA3cihlQdZjRTxItQTRdhTumQkIfPMz95TULcE+9EdTUUOvX8ZtUdQB4IKwBzk22LDRtCsL4q+dMs/51+ZjkZXuCx83mA4dtej+jhWjJxqz5oH7x1Oz74juqMypBtY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=ffP59Le1; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=Fm5NFOFv; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5APFD8Wn3499641;
	Tue, 25 Nov 2025 11:45:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=hspHssVuh7wT87Guded4Icn8te6dR0PxXLQE6Vp0e
	QY=; b=ffP59Le1Fadfjjb9AD+H3mTrzWRJy/l8wYvgsDu/gR2jSzOQ+8K6bvhto
	AHOiF5ktfWNMBGxarvlAo56hbPWmbRAOjKyRrknsQMrW49yr/8/a5xa7kKc8XiuZ
	NGFlCGbYun++6Qx4OsGID5vdk3lvg2Cj0OgMhpM1eYlE98nQiPqJP7XdGgAsv2EW
	Qokqd3INA7c7dFkiJF5Mep/K1cddDQ4oXpuTOfKDygF/YVIpMM8Z2oAnXlSDjvht
	GmfkZn5u3fLsA8DS4/E5H5+hwhpzt2S2z1H/i7UmDpO3Mcz0eqHsouT7uIEl3i/K
	BPfSRNjSJ9kQwAnQKDr96imkgGaKA==
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11023125.outbound.protection.outlook.com [40.93.201.125])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4amu4jk1qw-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 25 Nov 2025 11:45:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jshn+B3xeiDvEFqwK802yvbXgSjLdHiUrbHDSCwewswVmj3ydh4bG/cLV23sqejxu69pUyYkiS3Ai38PDudqOPBCtVZuHhTc/cMAbHCkjsu7/5GgPtyb+cmZT52Q8AWUgK1ZNY2xt4u7NO8jR4PY8vgRKelQ4ElaexF1/SEV6HssysJj3Y5uOGCCiriNXASN8TdjE9YxnrurHvoa8hH/nicJduIkbJHATndZ5nI8ZMfZetiAglO6QjiFoAyqsj1fnqejYMpsRFmr7Pq9GVmPqS5Aif5aXs7a0HHdCsipyMSyZUT4cwpHiKgcsbtfLhdMLnAu6iY2J8MMj/23whCraA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hspHssVuh7wT87Guded4Icn8te6dR0PxXLQE6Vp0eQY=;
 b=wC+9pJcxky2eBpZsGYMclOZoxuQzVLvStGEl1XR8XTH/QA+iC3W3kJ6HuDUJzMuvnpwss4TxYzgZphlbUMk0etm7BNr3JVxReaAsSGZRJ8HV6bYLuqJF9XboY8WH7Kk3CwWgnq1j2jv8/H7VvFciJiNFRodSQJu8gt5CJtmsr0AuyQW9DH1ejCYqWJ/4q4Y0saNHFM5BdLQYmGXwqCFxaiPiqajVulx/EHQexq2PE3yUkLUggSbNMM43ojHVOz+RcBpmS/WJilMhz3fE94qN6ZkwSUmHaWAy8PxASzk+81bl4fsC7LnowOBh4OA/B06iE2ihxvdcMf99xaM8H+FRtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hspHssVuh7wT87Guded4Icn8te6dR0PxXLQE6Vp0eQY=;
 b=Fm5NFOFv4cfPLwLufL4+kx6Rp8UijVJFVnoViFb4r4zDrX6jjPuhh4BgCQMftUkuNnvK9br8vaj/VsoPYP5Oqg3oe21NDa2/Zkc7tGwN4fmDdLU/lEt6bYfE77EYJRAUHkBweLQOqrJobrXI70+zKhLeCYWcUceKc8Cvp4XjU7pO7OiBvdp2qdvbnJu5WZ1WQONSBHG3H8g72X6b9Ss1ebHRyP+ITu6Bad6ySKBNmS6UQTq2aaGQQrXCoM7pgiigt0giOIY0MBiwfSieJeCwsYxphYdsG2Wjs5RqHqrLM/SsAIUb+ijGphaAezxRMr1St7AGIJ617jKq31TuFNfIYQ==
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18) by DM6PR02MB6825.namprd02.prod.outlook.com
 (2603:10b6:5:21a::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.11; Tue, 25 Nov
 2025 19:45:28 +0000
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc]) by LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc%4]) with mapi id 15.20.9343.016; Tue, 25 Nov 2025
 19:45:28 +0000
From: Jon Kohler <jon@nutanix.com>
To: Jason Wang <jasowang@redhat.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>,
        =?utf-8?B?RXVnZW5pbyBQw6lyZXo=?=
	<eperezma@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds
	<torvalds@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>,
        Sean
 Christopherson <seanjc@google.com>
Subject: Re: [PATCH net-next] vhost: use "checked" versions of get_user() and
 put_user()
Thread-Topic: [PATCH net-next] vhost: use "checked" versions of get_user() and
 put_user()
Thread-Index:
 AQHcVDJryQXjlObInEG9J4YkYYZKUbTvzAyAgAJ4RQCABAmigIAA2pWAgAOxCQCACQYXAA==
Date: Tue, 25 Nov 2025 19:45:28 +0000
Message-ID: <121ABD73-9400-4657-997C-6AEA578864C5@nutanix.com>
References: <20251113005529.2494066-1-jon@nutanix.com>
 <CACGkMEtQZ3M-sERT2P8WV=82BuXCbBHeJX+zgxx+9X7OUTqi4g@mail.gmail.com>
 <E1226897-C6D1-439C-AB3B-012F8C4A72DF@nutanix.com>
 <CACGkMEuPK4=Tf3x-k0ZHY1rqL=2rg60-qdON8UJmQZTqpUryTQ@mail.gmail.com>
 <A0AFD371-1FA3-48F7-A259-6503A6F052E5@nutanix.com>
 <CACGkMEvD16y2rt+cXupZ-aEcPZ=nvU7+xYSYBkUj7tH=ER3f-A@mail.gmail.com>
In-Reply-To:
 <CACGkMEvD16y2rt+cXupZ-aEcPZ=nvU7+xYSYBkUj7tH=ER3f-A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.700.81)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV0PR02MB11133:EE_|DM6PR02MB6825:EE_
x-ms-office365-filtering-correlation-id: 71116681-c285-4ed1-bf47-08de2c5b2f8f
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|7416014|10070799003|376014|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?UFBhS3NvYmdVQ1pTZTNOQlJTOVpBVXV3N3ZQcm1ET0xkYlVMclNwb3ZNMmhi?=
 =?utf-8?B?N29LZ3hWMjl6bnhISlFSenlNSHdWcnNSL1ZRdkVkRDdRRW91ZXczU0Eydytk?=
 =?utf-8?B?L2dwa2F2ZHdlMVhES2VLaUk3K1pMK01lRzhQTlZXUW43Z0JBVHZMdkdLUUN5?=
 =?utf-8?B?cy9UVWtIT0U5Y0d6OHhhbjR2REVhT1pmbmQ3NXZQRVpKVFpwR0ZiQnFNSkZv?=
 =?utf-8?B?TWp5UE41ZElHOERxZjVZQ1pYS0lNSTd2bjl1b1VlZTlLUjVSd2puUCs3Y0Fn?=
 =?utf-8?B?Z0VKYXh4TUFtQjJ5Z29HeXFJTVJvaGQ0b3JJNFN0RTEySHEzeGRrMUJEWkFD?=
 =?utf-8?B?SGUzWmQ3WUNzUHNsdERITVNNWmtFZXl6cm5mWTdWdVA2WHNDK0p2Nm05WHUw?=
 =?utf-8?B?VjBsR1djRG9PY2R1VlJjOFFWeUNBdytsSGVkcnlXTWQ4cUdwTGo1R0RkNUR0?=
 =?utf-8?B?d21TdHg0cExsVDVMRm55eDRQVjROVzZ5TWtwanFqY2dlWm50RUlkNUxIZm5S?=
 =?utf-8?B?VG9VQlhVclBCMCtxRnpTWjZ3M2xDRVNJSnFwVFIxUW4vckVCRzgxcFp4Nll3?=
 =?utf-8?B?SjZxakRDcDRJTVVabGd0ZWNwNEMyVjFWOTdQZjlBSlRHVWNLeUtGT29UTlVX?=
 =?utf-8?B?amlUY09xZCtzQVRnSW9nN1U4bmdVRStESzkwZ2xCUEtLUXhGOGR2VURCeGk4?=
 =?utf-8?B?S3NjQ0JreU8xSjZCZHcxc3FtTzVRa2JUMHhSN1JDR2dEQmJzaTAzT3J4ZFRZ?=
 =?utf-8?B?WEdlZjJEakJlSWZkTTFERHpnZHo5MW8zdzVmbk1iZEYzamN4MmY0LzRrcVNQ?=
 =?utf-8?B?T1dualJTU2gxSXgyalF5VmdjUmNUWjdsM3JERjZxOEcyWERpalVzc3IxdGNl?=
 =?utf-8?B?NUlhTE41bkZzNjE5aVVQRUJwRlZLQUV0bVMxQ25aQ3NzTi8rQmwzM2VZNWEw?=
 =?utf-8?B?TWdRK2dJalZzc1pHYjBseXVZWDZpK0dwNXpDaGVmYTJ0Ri9DZ0tUb1RaOCtW?=
 =?utf-8?B?TUJzR1lyK0c2VUtkbndnaEVKcXFKalpwVzRrdUtZWXZqNnNIK3VaTHpoOXg3?=
 =?utf-8?B?QldhZU5CcmtxejdpQmtkYnROVmFuSkdRUkJlZ21XYW1vNWdmZm1ZaFZPazNP?=
 =?utf-8?B?SDMyZytWZThLSDNhdXE1SFY3K21ybXl4Q0tBN0xEc1pGWWY2OXByOW9ieEhL?=
 =?utf-8?B?VmF4T1FoTWx3UWpSeGJtbnFDazBaNHBKd2MvU1hKUjNjMUE3aEtpNS93Z3E5?=
 =?utf-8?B?U3V6cG11TW5TdEl2UnRseEl4YkJsN0VwWmtGSTJVeHRLQlZnaFVaWURsR3Bx?=
 =?utf-8?B?RXhqT2tmT0lsL1N6NGs1clhIRU42TW8zdk1XMm1xTzdpUFFHOWZiUG1VMUIx?=
 =?utf-8?B?ZEFJVGdMaTlGbGh2TGFiaWRNQ0pmVzJ1QVZUcUk2aVZsNWgxeCtPWjRET2d4?=
 =?utf-8?B?STdCSlFWTTZqRVVWeFdIYkNhNEJxZXQvYTRSdFUxQWoxNjdjNHhTekVmeWZF?=
 =?utf-8?B?dXlKZVVuaWZsS3FDWHFiZDIvVVFReVpYbXlCa29sL3RJSURXK0c0bk1RdUVp?=
 =?utf-8?B?UEoyV0o1TnpYMXc2TUk1N3N1eFRZREZSd2x6MHRPYTlIY0lnSkI5MExhVzhh?=
 =?utf-8?B?RllWZ0tlVjdrOGt0VU9hV1FHZkIxdFBYVkxXN1N3d1pOZ2d1d2IzL0Vxd29X?=
 =?utf-8?B?WExDU3BSV3BBSWxtVzhTK0pSZnh2a0Y5d3JiY3hlODFWTjZsR1dQdVdSZkx3?=
 =?utf-8?B?dDV4cmEwcUxvSXFuNzV2cTVGTEdlZVZxdW9kREF2MTdzL3pENmJmT3JlTU9r?=
 =?utf-8?B?aFAzOUN6UFl6R3JKOFd4SHNnNlRCMWhPV3V0cXBpMDdMd3BnekZYd24ydTFt?=
 =?utf-8?B?Q05hM3R0VFNXNWZvS3NLeHc5ZDZaWDJUZXVIbHRKUThvVVduWlRwWFQzSlNO?=
 =?utf-8?B?S1RBTHAyck5WdHRMY0ZXZ1JTdEZ1YWtIckhpTkxVZFFGVGp5c2loZ0Z3UlFF?=
 =?utf-8?B?Y1NES2Vmd0pmTFRYMlg2UEpsUzgvdzFsK21GNDAwcnc2Nmo3ejJOVlJJRDdC?=
 =?utf-8?Q?WV70rk?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0PR02MB11133.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(10070799003)(376014)(366016)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Z0JDd2hubno0VTYybHlFRUIyMS8rV3BSbHlaT0Nnc2FxT3ZKVUUrV2RVbmdv?=
 =?utf-8?B?dWVLQTRxRndiTWN4d0J3RlFXV3Z6Rk93NXVHS1FTQjIvSW9vNmZPN3hPUE5T?=
 =?utf-8?B?N3BYS0ZvcGhGYnJkVWFLYjVLUHNhc0I0WjJ3MldCK0NFVUJNLzlDaFh6VUZZ?=
 =?utf-8?B?dElsVEhBaW9vM1QrNzhtOUkzQ1ZhbjN5RmhqaWx3bkZMMzdab1VBL3lRRUlT?=
 =?utf-8?B?YXZnSktrRG5yTFg5cUcwSjlyZDYyamhTMlUxdUg1OXBCSzlrOU1kaUlCSkdZ?=
 =?utf-8?B?WnZ0M3hGdURMMmZoc2dLclVvQ29LWWU4RzVMRGFnM1cweTZvUkVMRUdjaDhH?=
 =?utf-8?B?amJSS2VQbXg0WExtQVQ1ZG4vTEczTVMwVFZLNmtoQklCNGZuTmZ3TnRVVjJQ?=
 =?utf-8?B?S1FCSUhyeTJabWE2NzIvUUJHSWp3WkxDczR3cHoyd2tlRHd6RDhGZmszN1hK?=
 =?utf-8?B?eFdUYVk2cGQ1Q1RmS3JPU2FzRDd6TkQvcXBxbzZpMlY3ZTR0ajZJN1NwSURZ?=
 =?utf-8?B?VHFrV3FWOGRFSnJzOU9uVnJwaC8yMEZWWjM1ZHFZZ3lGWVovUDlObHJnUzVv?=
 =?utf-8?B?bzl0dXUzZ0FOQ29JVDdSdk5OOUl0MVlyMkxZcEoxWVBFUk5hbkUrQUY1SHpw?=
 =?utf-8?B?S0JieWMySy9JRGtiS2dWSVlSUmFyU01mbE5UT3RqcjdBSkdhR0lwQWJGN2pM?=
 =?utf-8?B?NU80dWlwa3VnWUg3V1ZvOTZIS3pBVnlMbnlBa0hQZlpTQVFmSjBFVnRWSFlE?=
 =?utf-8?B?VDFkZkZHQjJUcTBQbENYT1I5N3BTV2pvKzA4bHlVVmgzdm5HSjQvODJRbGQ1?=
 =?utf-8?B?Z2FncHRXMEtyaS9LQ0EzSVkwUWh3RmVuWXoyTTJGcGk0NmJMdGRjbVIyQXR6?=
 =?utf-8?B?SStoVDZBeVFodVdCUUs3bFFPeEswMWZWcDdoM25GN1pYTzR2WFAzN2dualJK?=
 =?utf-8?B?NE53RHZSY0pqMFd1RlF6WFpJaTh5SHE5SkZyRWwzdHFKbmN0eUN2R0tHYXdJ?=
 =?utf-8?B?Y3FZeS9YeXYyTDV4Vy9zbjI5anRpdGR6WTBNU0ZmTUJDZWxTREtySjBaK2Vo?=
 =?utf-8?B?KzQrNk4xL2pQdmE0dllzNzhpRjZtZFVsN2xlcXNHcWI3Tk44QTM3eHlrQklt?=
 =?utf-8?B?K1E0K2VBMWJoRU16ZjkwZHRkR2RRbnhLWUYwR3BrdUMzaEFHT003cnh2d3JS?=
 =?utf-8?B?MFdXQ0cxdE84WThyVU5xVGJyVmh3WjhsQXRRQVFpL2ZWMDhKSWl5b2lQVmdi?=
 =?utf-8?B?MkdBSllkZStoZGdoblNQZTRLUG1XZU5odWxKNHVpSUEvTjlaQVVNZStPL1FO?=
 =?utf-8?B?WGxzQnYrcklZd2hqT1k4YU9rZFJRR1lMWVJuK3FLZGhRSU54Q2NONlR5YUZB?=
 =?utf-8?B?OUJ4d1NkcGNvZ2Rnd0hYc3hRaHRaOW1PWHBsbjA2bGZqd0ZNa3pWTEk2aDk5?=
 =?utf-8?B?ZTVkck9tM0ZMN3dWZldsTlVtU29zN0g2WGwrd3RvL0xJV1R4UnRCSitmUmZD?=
 =?utf-8?B?UG5XRGhHenhQdHQ4NThRekp4aGRFSTA1ZWpqeE15YW9FODVCYlBJVTRvL2Nm?=
 =?utf-8?B?eUZlYjVPcWs4Qm9IY2Urclg5YkhpMVA3M2xkMnRzdE00VXRpYm9UcXppNDBM?=
 =?utf-8?B?OC9scW1aV0RtUUl6NnhvcnQ3QkJOSFR6YTRUNm9kL0hIM2crRThXYVlxUG1n?=
 =?utf-8?B?bGhhTHMvK0dZMC9ZczFsQ012cFpjNFFDa1pHZS9mbmtnbnEvS3dkMHFsa3Bz?=
 =?utf-8?B?cjh2aVc1dzVxV01DSXJucFA4L3hTYU1Wblc4YnlVdm82VVRjYWlrS2ovdGY5?=
 =?utf-8?B?cU5aL0VjK1V3cXFMQ2hTbVo4dFQyZXBHOU0xK084cWJrRFVRVzdiYnRWbmRz?=
 =?utf-8?B?VmhONmlhdlJROXZGNTZNZkQxUlJFaW95cEU4K0w5U2JyTEZtL3VRS3orYktG?=
 =?utf-8?B?bFdpWG1FTmVYdUNDbHF0T1RXNFpPRlVqc3NsZVV2N2w0T2JCcFpBalZlNEpU?=
 =?utf-8?B?dWdJUCtRVVZjVkVWMXY0ZnZHSFhxMjVpcVZRSmpYaHRnUjlHRVJ5VmJYZUNa?=
 =?utf-8?B?MkVQTVladW1EWE1BNjh1VmRtTlVWS3ZYWlNpbXV0UmwvdzdsZmJRNytFYkZk?=
 =?utf-8?B?ZkZRQXZmT1BTYzdMSHVUcUFMcGtIT2FnQmljbUo2cU9GLzRJMWRSWnJQbDJQ?=
 =?utf-8?B?blJ3cU9lWXVFSnlvY2FKaVp1SWhjUk9SelRGb21QWDZ5ak45OWEwcXM2VStH?=
 =?utf-8?B?WnN6OG42TXMyU0ZCRTM1L0VYSE1RPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F07122368A813340901ACA7E21D79017@namprd02.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 71116681-c285-4ed1-bf47-08de2c5b2f8f
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2025 19:45:28.4766
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xm0fT+hnwHLRAeHtamTwKtbWpLGTWqhyEHcE3Mhm2Ew617wS4vI3PxtSyxOhYcWdHr0biYdj2gNtb0qunJavKM9L3GA0Dc61ZC9+rgyCws0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB6825
X-Proofpoint-GUID: nkZ9GiSWEXTVIMUD1InsDLcJMoHcQnlE
X-Authority-Analysis: v=2.4 cv=YOaSCBGx c=1 sm=1 tr=0 ts=6926075a cx=c_pps
 a=wNUz95N+lX1OGTQbYu/32w==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=20KFwNOVAAAA:8 a=64Cc0HZtAAAA:8 a=NIo-WXXdcX_suqEXpZsA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: nkZ9GiSWEXTVIMUD1InsDLcJMoHcQnlE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI1MDE2NCBTYWx0ZWRfX8iSQU2In2olZ
 oc52c63GGwxMsDPFvqJyvLB9EIP5I+3MAV4YtlQX6FAX27aSZ081z1kLsE/HcIrNaKrNC0faQI/
 W8ruq15c1bkWkTnyMvwGUbplDVbqhrELGkFR+/G956kfxjvd8cHMod7R/IdRUBTxCcCrKy3cEee
 ElCtkgkV9iumS6mScNmvAwLBZIfDMy4FcqKYtUTUId1hs0i9LQqgw16hSlf8vtaq4Mnvg+YeSqn
 MvvDrQmkwa40RbFRvYGPD91r1Q7+Q1gqib+NRwMCBH3AdXhpr0SxlEBjM3UrDM+lw4gM+mvWVPI
 Nlhrr0ZXfoln43ugfXYcna8+b3f0UwRtxw5tXFrRKUlkwjoeNITvtwWDLA9d3VvXfOpDGT3oVvm
 IqtGl93mcZFw3hXvavfKh5GgerIZTw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-25_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gTm92IDE5LCAyMDI1LCBhdCA4OjU34oCvUE0sIEphc29uIFdhbmcgPGphc293YW5n
QHJlZGhhdC5jb20+IHdyb3RlOg0KPiANCj4gT24gVHVlLCBOb3YgMTgsIDIwMjUgYXQgMTozNeKA
r0FNIEpvbiBLb2hsZXIgPGpvbkBudXRhbml4LmNvbT4gd3JvdGU6DQo+PiANCj4+IA0KPj4+IE9u
IE5vdiAxNiwgMjAyNSwgYXQgMTE6MzLigK9QTSwgSmFzb24gV2FuZyA8amFzb3dhbmdAcmVkaGF0
LmNvbT4gd3JvdGU6DQo+Pj4gDQo+Pj4gT24gRnJpLCBOb3YgMTQsIDIwMjUgYXQgMTA6NTPigK9Q
TSBKb24gS29obGVyIDxqb25AbnV0YW5peC5jb20+IHdyb3RlOg0KPj4+PiANCj4+Pj4gDQo+Pj4+
PiBPbiBOb3YgMTIsIDIwMjUsIGF0IDg6MDnigK9QTSwgSmFzb24gV2FuZyA8amFzb3dhbmdAcmVk
aGF0LmNvbT4gd3JvdGU6DQo+Pj4+PiANCj4+Pj4+IE9uIFRodSwgTm92IDEzLCAyMDI1IGF0IDg6
MTTigK9BTSBKb24gS29obGVyIDxqb25AbnV0YW5peC5jb20+IHdyb3RlOg0KPj4+Pj4+IA0KPj4+
Pj4+IHZob3N0X2dldF91c2VyIGFuZCB2aG9zdF9wdXRfdXNlciBsZXZlcmFnZSBfX2dldF91c2Vy
IGFuZCBfX3B1dF91c2VyLA0KPj4+Pj4+IHJlc3BlY3RpdmVseSwgd2hpY2ggd2VyZSBib3RoIGFk
ZGVkIGluIDIwMTYgYnkgY29tbWl0IDZiMWU2Y2M3ODU1Yg0KPj4+Pj4+ICgidmhvc3Q6IG5ldyBk
ZXZpY2UgSU9UTEIgQVBJIikuDQo+Pj4+PiANCj4+Pj4+IEl0IGhhcyBiZWVuIHVzZWQgZXZlbiBi
ZWZvcmUgdGhpcyBjb21taXQuDQo+Pj4+IA0KPj4+PiBBaCwgdGhhbmtzIGZvciB0aGUgcG9pbnRl
ci4gSeKAmWQgaGF2ZSB0byBnbyBkaWcgdG8gZmluZCBpdHMgZ2VuZXNpcywgYnV0DQo+Pj4+IGl0
cyBtb3JlIHRvIHNheSwgdGhpcyBleGlzdGVkIHByaW9yIHRvIHRoZSBMRkVOQ0UgY29tbWl0Lg0K
Pj4+PiANCj4+Pj4+IA0KPj4+Pj4+IEluIGEgaGVhdnkgVURQIHRyYW5zbWl0IHdvcmtsb2FkIG9u
IGENCj4+Pj4+PiB2aG9zdC1uZXQgYmFja2VkIHRhcCBkZXZpY2UsIHRoZXNlIGZ1bmN0aW9ucyBz
aG93ZWQgdXAgYXMgfjExLjYlIG9mDQo+Pj4+Pj4gc2FtcGxlcyBpbiBhIGZsYW1lZ3JhcGggb2Yg
dGhlIHVuZGVybHlpbmcgdmhvc3Qgd29ya2VyIHRocmVhZC4NCj4+Pj4+PiANCj4+Pj4+PiBRdW90
aW5nIExpbnVzIGZyb20gWzFdOg0KPj4+Pj4+ICBBbnl3YXksIGV2ZXJ5IHNpbmdsZSBfX2dldF91
c2VyKCkgY2FsbCBJIGxvb2tlZCBhdCBsb29rZWQgbGlrZQ0KPj4+Pj4+ICBoaXN0b3JpY2FsIGdh
cmJhZ2UuIFsuLi5dIEVuZCByZXN1bHQ6IEkgZ2V0IHRoZSBmZWVsaW5nIHRoYXQgd2UNCj4+Pj4+
PiAgc2hvdWxkIGp1c3QgZG8gYSBnbG9iYWwgc2VhcmNoLWFuZC1yZXBsYWNlIG9mIHRoZSBfX2dl
dF91c2VyLw0KPj4+Pj4+ICBfX3B1dF91c2VyIHVzZXJzLCByZXBsYWNlIHRoZW0gd2l0aCBwbGFp
biBnZXRfdXNlci9wdXRfdXNlciBpbnN0ZWFkLA0KPj4+Pj4+ICBhbmQgdGhlbiBmaXggdXAgYW55
IGZhbGxvdXQgKGVnIHRoZSBjb2NvIGNvZGUpLg0KPj4+Pj4+IA0KPj4+Pj4+IFN3aXRjaCB0byBw
bGFpbiBnZXRfdXNlci9wdXRfdXNlciBpbiB2aG9zdCwgd2hpY2ggcmVzdWx0cyBpbiBhIHNsaWdo
dA0KPj4+Pj4+IHRocm91Z2hwdXQgc3BlZWR1cC4gZ2V0X3VzZXIgbm93IGFib3V0IH44LjQlIG9m
IHNhbXBsZXMgaW4gZmxhbWVncmFwaC4NCj4+Pj4+PiANCj4+Pj4+PiBCYXNpYyBpcGVyZjMgdGVz
dCBvbiBhIEludGVsIDU0MTZTIENQVSB3aXRoIFVidW50dSAyNS4xMCBndWVzdDoNCj4+Pj4+PiBU
WDogdGFza3NldCAtYyAyIGlwZXJmMyAtYyA8cnhfaXA+IC10IDYwIC1wIDUyMDAgLWIgMCAtdSAt
aSA1DQo+Pj4+Pj4gUlg6IHRhc2tzZXQgLWMgMiBpcGVyZjMgLXMgLXAgNTIwMCAtRA0KPj4+Pj4+
IEJlZm9yZTogNi4wOCBHYml0cy9zZWMNCj4+Pj4+PiBBZnRlcjogIDYuMzIgR2JpdHMvc2VjDQo+
Pj4+PiANCj4+Pj4+IEkgd29uZGVyIGlmIHdlIG5lZWQgdG8gdGVzdCBvbiBhcmNocyBsaWtlIEFS
TS4NCj4+Pj4gDQo+Pj4+IEFyZSB5b3UgdGhpbmtpbmcgZnJvbSBhIHBlcmZvcm1hbmNlIHBlcnNw
ZWN0aXZlPyBPciBhIGNvcnJlY3RuZXNzIG9uZT8NCj4+PiANCj4+PiBQZXJmb3JtYW5jZSwgSSB0
aGluayB0aGUgcGF0Y2ggaXMgY29ycmVjdC4NCj4+PiANCj4+PiBUaGFua3MNCj4+PiANCj4+IA0K
Pj4gT2sgZ290Y2hhLiBJZiBhbnlvbmUgaGFzIGFuIEFSTSBzeXN0ZW0gc3R1ZmZlZCBpbiB0aGVp
cg0KPj4gZnJvbnQgcG9ja2V0IGFuZCBjYW4gZ2l2ZSB0aGlzIGEgcG9rZSwgSeKAmWQgYXBwcmVj
aWF0ZSBpdCwgYXMNCj4+IEkgZG9u4oCZdCBoYXZlIHJlYWR5IGFjY2VzcyB0byBvbmUgcGVyc29u
YWxseS4NCj4+IA0KPj4gVGhhdCBzYWlkLCBJIHRoaW5rIHRoaXMgbWlnaHQgZW5kIHVwIGluIOKA
nHdlbGwsIGl0IGlzIHdoYXQgaXQgaXPigJ0NCj4+IHRlcnJpdG9yeSBhcyBMaW51cyB3YXMgYWxs
dWRpbmcgdG8sIGkuZS4gaWYgcGVyZm9ybWFuY2UgZGlwcyBvbg0KPj4gQVJNIGZvciB2aG9zdCwg
dGhlbiB0aGF0cyBhIGNvbXBlbGxpbmcgcG9pbnQgdG8gb3B0aW1pemUgd2hhdGV2ZXINCj4+IGVu
ZHMgdXAgYmVpbmcgdGhlIGN1bHByaXQgZm9yIGdldC9wdXQgdXNlcj8NCj4+IA0KPj4gU2FpZCBh
bm90aGVyIHdheSwgd291bGQgQVJNIHBlcmYgdGVzdGluZyAob3IgYW55IG90aGVyIGFyY2gpIGJl
IGENCj4+IGJsb2NrZXIgdG8gdGFraW5nIHRoaXMgY2hhbmdlPw0KPiANCj4gTm90IGEgbXVzdCBi
dXQgYXQgbGVhc3Qgd2UgbmVlZCB0byBleHBsYWluIHRoZSBpbXBsaWNhdGlvbiBmb3Igb3RoZXIN
Cj4gYXJjaHMgYXMgdGhlIGRpc2N1c3Npb24geW91IHF1b3RlZCBhcmUgYWxsIGZvciB4ODYuDQo+
IA0KPiBUaGFua3MNCg0KSeKAmWxsIGFkbWl0IG15IEFSTSBtdXNjbGUgaXMgd2VhaywgYnV0IGhl
cmXigJlzIG15IGJlc3QgdGFrZSBvbiB0aGlzOiANCg0KTG9va2luZyBhdCBhcmNoL2FybS9pbmNs
dWRlL2FzbS91YWNjZXNzLmgsIHRoZSBiaWdnZXN0IHRoaW5nIHRoYXQgSQ0Kbm90aWNlZCBpcyB0
aGUgQ09ORklHX0NQVV9TUEVDVFJFIGlmZGVmLCB3aGljaCBhbHJlYWR5IHJlbWFwcw0KX19nZXRf
dXNlcigpIHRvIGdldF91c2VyKCksIHNvIGFueW9uZSBydW5uaW5nIHRoYXQgaW4gdGhlaXIga2Nv
bmZpZw0Kd2lsbCBhbHJlYWR5IHByYWN0aWNhbGx5IGhhdmUgdGhlIGJlaGF2aW9yIGltcGxlbWVu
dGVkIGJ5IHRoaXMgcGF0Y2gNCmJ5IHdheSBvZiBjb21taXQgYjFjZDBhMTQ4MDYzICgiQVJNOiBz
cGVjdHJlLXYxOiB1c2UgZ2V0X3VzZXIoKSBmb3INCl9fZ2V0X3VzZXIoKeKAnSkuDQoNClNhbWUg
ZGVhbCBnb2VzIGZvciBfX3B1dF91c2VyKCkgdnMgcHV0X3VzZXIgYnkgd2F5IG9mIGNvbW1pdA0K
ZTNhYTYyNDM0MzRmICgiQVJNOiA4Nzk1LzE6IHNwZWN0cmUtdjEuMTogdXNlIHB1dF91c2VyKCkg
Zm9yIF9fcHV0X3VzZXIoKeKAnSkNCg0KTG9va2luZyBhdCBhcmNoL2FybS9tbS9LY29uZmlnLCB0
aGVyZSBhcmUgYSB2YXJpZXR5IG9mIHNjZW5hcmlvcw0Kd2hlcmUgQ09ORklHX0NQVV9TUEVDVFJF
IHdpbGwgYmUgZW5hYmxlZCBhdXRvbWFnaWNhbGx5LiBMb29raW5nIGF0IA0KY29tbWl0IDI1MjMw
OWFkYzgxZiAoIkFSTTogTWFrZSBDT05GSUdfQ1BVX1Y3IHZhbGlkIGZvciAzMmJpdCBBUk12OCBp
bXBsZW1lbnRhdGlvbnMiKQ0KaXQgc2F5cyB0aGF0ICJBUk12OCBpcyBhIHN1cGVyc2V0IG9mIEFS
TXY3Iiwgc28gSeKAmWQgZ3Vlc3MgdGhhdCBqdXN0DQphYm91dCBldmVyeXRoaW5nIEFSTSB3b3Vs
ZCBpbmNsdWRlIHRoaXMgYnkgZGVmYXVsdD8gDQoNCklmIHNvLCB0aGF0IG1lYW4gYXQgbGVhc3Qg
Zm9yIGEgbm9uLXplcm8gcG9wdWxhdGlvbiBvZiBBUk3igJllcnMsDQp0aGV5IHdvdWxkbuKAmXQg
bm90aWNlIGFueXRoaW5nIGZyb20gdGhpcyBwYXRjaCwgeWVhPw0KDQpIYXBweSB0byBsZWFybiBv
dGhlcndpc2UgaWYgdGhhdCByZWFkIGlzIGluY29ycmVjdCEgDQoNClRoYW5rcyBhbGwsDQpKb24=

