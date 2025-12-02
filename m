Return-Path: <kvm+bounces-65109-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 12B40C9B8A3
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 14:00:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 25A19346947
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 13:00:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5403231354F;
	Tue,  2 Dec 2025 12:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="gjy395tL";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="xr9wn3kN"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C8C27E7EC;
	Tue,  2 Dec 2025 12:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764680390; cv=fail; b=qXxJhKr9R0c1gdayF1tIhH7xUmswzXtMXTqItCGfCln1zQ0vzpaF7w+QZmdZGQtxzhJMNjRntQy7RHnOEm9vk4UsnZ4TOY4AIrlB0ZQNJEDP7fFebUhV7VpZHo6y8+isxuuujNlOczQcMehcje1waGe0boj5d15deqSsf8mEgVE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764680390; c=relaxed/simple;
	bh=zczjjywK3KGF2FmUOLjCQWTnO4X96HVXCweDXzrx1uk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=STUXbRIOPNyGBg62yHArqkya0/LhHYwkAJrF+LwUglFr/htHRGUimejQiu48IzEss48NQMbk5rKDi+bu5UnmikBnarPrwdjPdAZ41OvOg6cqVzZc1jB9R9/yF++ow/bfi1soEDrOz0unnEbIO6vtF8WSF6vTRIV9hrOZhBbFGuY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=gjy395tL; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=xr9wn3kN; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B244QHP1715414;
	Tue, 2 Dec 2025 04:58:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=zczjjywK3KGF2FmUOLjCQWTnO4X96HVXCweDXzrx1
	uk=; b=gjy395tLOBtcl2jRodp6dcmUrxsP3NshMZFbJ/Vl4tP0MaqZHi7lxXpqJ
	02taICi9ebfin+Qqwh/zAFQ4xuZmAQzETvP5A64PjrKZtqzsgSQEescxPX+0WuTg
	HpWaOvl5ioXYl/fb7SLJIc+8IFLNjDjsCBLq3YHMc0P0C4YpkM8mcHOvTzxyuMFY
	hqZvZeiHqEICULqHYpl8oSEvf3YVDD6VCx7jkli9S5eCFBEnKxhjLGj/StOq7XIW
	P/Hgv09lz2Y5i5t/K0mChdkrPBeqx5/MFKSTA3Tdc3sbQIBVrt4C0mmmkxd3skBT
	n6bZzqwLL3OYvkY8IsB/l+eLbI9ZA==
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11021074.outbound.protection.outlook.com [52.101.62.74])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4asrrxs0hx-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 02 Dec 2025 04:58:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QcujUJKe7OWwJJNzB9EsHC2uQkp5VSbGNnqpRJVqc4TEECfUle+ZeaFIpK51DrcE/d4ZIN9kwEOiz9nF/DzuymMsdpR7xGD5ymG3K3XlQKIeVmAoT4NWRoeUuYHHlbk5+YEeKUWelMVmYf+4Xq0ILrA++X2BzFU8a08++y3l+aT2AJAjRbUEwH0sZIoCPVmWOrK5taq0Jc623ym6TWQcPY9WTMRHQZHjP4ae2NuDjiizZxzS7qXWWWtO90GE9qqIHwbwBKuPXRIJOt7TJRjh+6tY4Nsl+nASYAjJbrBSJpOiv3rjIVXlco0YJQd2ssIfyH734uPQEymCTBV9+ecAAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zczjjywK3KGF2FmUOLjCQWTnO4X96HVXCweDXzrx1uk=;
 b=uChSk/BvLABFhVWJjD9aZGYvQ2CLzrhHKxGi4bBuzYI3JzWrvtGr3K5Gu1Ya4kOoiBr373XfX2h18qFEJBhJ0DUrTNPh1BNfO1DH/2aVuLjztH36t1ARyy6C1R5Tve36jVEpVsLs3i6IOnFaGjoFCZwxmN6ay2lNiJKZ1v0KxzQIxYHswrkfAD748AvZpzBlHAn3FPG8ji9P3cziRAn6JkuQo0Ib6NXNgHJ2/wLnfZZUTGznUOWTUFGsTRFaXaoBRzzwM7bhFYW+VKRQUII2K+i66sNG09W3Jfe1GWACezflbV4l8/aRLWvhzLPqkK2pv2KXSfEK+j8VXBXzUkJ7lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zczjjywK3KGF2FmUOLjCQWTnO4X96HVXCweDXzrx1uk=;
 b=xr9wn3kNgi9YSLDlLxYI8h4MdCB5Z+KbnYV2xaASiZ7/Idxw3ezhkNCnxF8ZUQH13ZDW5Dp6HsxSieGWm9JT+jDBeWbRMpPCT4fefQgfH9ToEGimfhynshkkTpvX7MFIHw7iOI2jQ3a2Y8d+Iv82ZoBRoIId4Ipx0tRYJ1z1M6UdvRLnxq5LwPgS3lzgQyKOeoIIpKCFH2DwO0QONU0p+hVU4K+w4D9SJpBp8AajaWAzIbmpGxejdsu8LNVwiufQB1sYX79GU2sb5QhvvzspXappNN9RVat98ckw+Y+xi8u5f+3zbGFm82jVeJZk2tfHQ445GsHchro6kOtBDX707Q==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by PH0PR02MB7288.namprd02.prod.outlook.com (2603:10b6:510:9::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.9; Tue, 2 Dec
 2025 12:58:53 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::27c4:c948:370:572b]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::27c4:c948:370:572b%4]) with mapi id 15.20.9366.012; Tue, 2 Dec 2025
 12:58:52 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: David Woodhouse <dwmw2@infradead.org>
CC: "seanjc@google.com" <seanjc@google.com>,
        "pbonzini@redhat.com"
	<pbonzini@redhat.com>,
        "kai.huang@intel.com" <kai.huang@intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Jon
 Kohler <jon@nutanix.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v3] KVM: x86: Add x2APIC "features" to control EOI
 broadcast suppression
Thread-Topic: [PATCH v3] KVM: x86: Add x2APIC "features" to control EOI
 broadcast suppression
Thread-Index: AQHcXjYohMZ/JxHmj0OqVx2H9OyjkbUOG28AgAA+6QA=
Date: Tue, 2 Dec 2025 12:58:52 +0000
Message-ID: <A922DCC2-4CB4-4DE8-82FA-95B502B3FCD4@nutanix.com>
References: <20251125180557.2022311-1-khushit.shah@nutanix.com>
 <6353f43f3493b436064068e6a7f55543a2cd7ae1.camel@infradead.org>
In-Reply-To: <6353f43f3493b436064068e6a7f55543a2cd7ae1.camel@infradead.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|PH0PR02MB7288:EE_
x-ms-office365-filtering-correlation-id: 745d7294-78a5-468e-390d-08de31a28b92
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?NjcvVUVwS0JoSEYzZ2I5Z3pqV0d0TzdjVWhqdnpWanVNa2VQZmpZaloxbUs0?=
 =?utf-8?B?bUh1MWhFZGR4WnlZMEM1eitTUTZyZW5PRzF0MWpFZjhUOUdyTXgzUlMvTHhl?=
 =?utf-8?B?Uk1WVEs5KzNWMytFMC9sMldKVFRFbmdycWVXUm9ldHRIM2UvRlFQUE5FeGxO?=
 =?utf-8?B?cU5ieFVacGsvb0JvWVdYYVVZcUVwUURTWFZ1b1VrYm5JWFM2VUlFL3ZSdk1u?=
 =?utf-8?B?SU9HaGhZT29tR00vT1RWRCt6M2gyVGRSUU5WbDFQWXFiWkpld0NXY0NLcGJ2?=
 =?utf-8?B?OTFYaHpGZ0lUbzY4eWVLVzh2L2VnN2tMa0Z0TEwyaituUXF6clhFY1h5UXlr?=
 =?utf-8?B?cjd5S1dNc1N1WExGaWVMNyt4TWZIUkk1NnRNd0swUWszYko4N25DWnZ0eUZo?=
 =?utf-8?B?Q3YxQ0g0TXRDMEIwS3BSMUNMY0pYOHBvNGk2blhEUkoyaEttUUFBQmppREsr?=
 =?utf-8?B?SE1KN3BEM0M4ellKWFdLUnd4UjAxblUrUVRGeWozNmlZUVBBYnNzM3IzZmcy?=
 =?utf-8?B?ajNwekUvZGsrbi9DbkZOWmQ3eGZWT1pNYlJoUis4Mk1IY3VlRzdSWFJOd3Y0?=
 =?utf-8?B?cGd2MmdHUHo5N0hlRGc4cnprbzhjOEQ3d05pU2U4OUtyUzNocTVRQllKaTJ5?=
 =?utf-8?B?UlN6M1NRSTJGaWJ0TDFiVktBMDE0NGZueXV2TWhDcTFtV21ucVMrNU1CVTRK?=
 =?utf-8?B?WVpaSTJlVnVGUzl4NHhicVVGUVlEdng5bDAzTE1RUDV3OFJaNWN2dG5qM3k5?=
 =?utf-8?B?a29sRm1qbE5XckV0YkJuSVFiVGlKc3ZrbDN1NS9MZnhYeStYcHJHdkl0b2J3?=
 =?utf-8?B?QXNzbDNMeWdWQUNFRFZSQWc5SzRtWGUvRUlpMEluSFJhL1dpUkkwUDFyMzhx?=
 =?utf-8?B?V3VCcDhjdHh4R1JVbVJYSW5iMmVDMzhVM2FkWG1ITWFOT0IxV3VwL3R6VXE5?=
 =?utf-8?B?VC9RMmFUSVVsM0xRd1A3WXc3WDdaQ0l5UE5MUFFjNE1ZQTVLaW41akJFTHR4?=
 =?utf-8?B?dTRjdGZNNk1QcklYcmNuVWRnQ2ZnN25kSkpVOHN6c01BOTA2TGJJODJxU1ZZ?=
 =?utf-8?B?SXZzSTVmUDBCY3dZZEhjM3BPUEY4dEY2VjZaVnJ4ODJqODA2dnZoUVJDT1dM?=
 =?utf-8?B?Q21VcWtWOGI0ME9zQ2lkTkMxMGJ0TnRVWGFnRmphYnZ1SXFYdHZRd3E2TUlM?=
 =?utf-8?B?ZUZXeGQyQTdIYlBiR3J6YTVZdHdUdkNJcE43ZVJMZW1MbjBENHN3cXdBKzlK?=
 =?utf-8?B?U3hvS1NtTjJOUEY5TmxJSC9JR2RRNnBUajMvY0puZFFUd0FMeG12WkdkRktt?=
 =?utf-8?B?RGwreS8rYnFVOVM3ZEhMa3I0TUVnVlV5djlQSUtzcUhDNlVNcHNsNFhWRVlM?=
 =?utf-8?B?S0pVc0V4ZHZpTHlNNDNXeVAySzVhOFpUTW16eFpvZmxReGdTdDA1Yk9TTk54?=
 =?utf-8?B?MDVWOE9hdW12QkZsVlovTkc4ZmhwVFJYSllvK2xFTHZLb0tOM3J5Y2I5MzZD?=
 =?utf-8?B?dHRBU0xIWnJIOUxGR0VuT3Nxekc2MmovTE1Ob24vZk5IWVhpOFFPdFN0ZHhw?=
 =?utf-8?B?STV6YVdYT1VTSWd1MWY3cFlORk9lNllHOHgwcmFWejE2NkVPN21VVnNzZksx?=
 =?utf-8?B?QldBUS9SVVFxbThwamFWT3dHZHM3VStHZmIxRGJqeGI5NElsdURhSjJrTlNm?=
 =?utf-8?B?UVdHN0tzWWQxbjNRY3Q2dk05RHhHdjJKMGhxbVZ2ZTBDbm10SklSUDRrNC9P?=
 =?utf-8?B?WmNlWERMSGxQVjU4NmNobDcyK1RWR25HZ3FOZXZTTmdLL29OUDFpaEY4Q0Vz?=
 =?utf-8?B?bXVwSENSUS9jKzRtOUgxcmVVcmFHa3BScm1SMFFRN2JRSWxqRzlmaUI4UnNW?=
 =?utf-8?B?Z2FNb2REWEM3YzFqS1pFREZxN3lrY29rZzlhQnNNVEF6N1NsUDhPWUtaT0NW?=
 =?utf-8?B?SUhsZzVUNmdFbm5rSFJ2Q2IvcUMwOGtKMDdUZGxHdXVQS2ZrMW8rN1J4WFZm?=
 =?utf-8?B?ZlMyNWE5TTBoWmpKSUlPbGs1UTQwblNYMGFkQ2dXYXJtS2J1dzlTZlE0dnA4?=
 =?utf-8?Q?SwzR2f?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?V2RjUXd5N3lyeWtBaVU1Q204bEV5T0V6bTR1Z282ZXM1RCtlVkZWa21Na0Rw?=
 =?utf-8?B?clNRMUErUDcxSWdXZmJIVFZpWEZrMUpOSGltYUNJT0lteTJhK04wOGtxL09Q?=
 =?utf-8?B?RHdqbG1IUWQ4elpDOHNOS1V4bDZQcXl5UGlkTmZSV3FWTjQ5UnM1dGdHQlIv?=
 =?utf-8?B?RzdLWHhXbnllVFF1N2VJc2VoaEFoeWZaSEhTRXoyTWlHSWUyOXRqRVR2VG1x?=
 =?utf-8?B?SHRNaUFRZWNkMU5oU2d5TnpsWndtbmwzOUVZSHpJK3dTMWs5OFJVUzBjdVBu?=
 =?utf-8?B?Z2QrS3Y0RG94WTRWMGdJK21CUkRGWFhkYXpqK2xFdnpSOGlHbi9KaHNKS3Za?=
 =?utf-8?B?YVpqZFN0akJUbjIwcTJGc2w3eno0YklISFJEUlJDc2JHaFF5amtHcnJvTisz?=
 =?utf-8?B?Q0ZzV1dTTmVkU2VQS0tyUTRtM21JdFUwL25EcTI5aVVrOElaUzRLd29XWUtC?=
 =?utf-8?B?ZjZNYk5kNGg0KzZ0cG1uTWZSSW0zSnJkT2JLaEZUcytnV2VLQnNhVDBzSGZp?=
 =?utf-8?B?TmJQQUIrSldvclZXcTVnNVVFUi83UUorTHpYZFVWWjFLd1V3dmNnRTR1NWl3?=
 =?utf-8?B?Y2p0ZVExUHIxL2cyczN5N0E1azJDSngrT2JlYjYyNGFicSswS1hieW9Hd09k?=
 =?utf-8?B?R2l4d2htb1ZOdWVmNktFeW1PZTIvUnA4cnhyMDA1b0dNZ0s2bzZkV0haa0xm?=
 =?utf-8?B?SEhoak9vTk5BRE52V1FrWWZnbiswakw2aEdrSjF4UDRyR3ZDdEZVN1JXZm5I?=
 =?utf-8?B?alZObGF3V1JlSkdQK3NHeFliRlNFbGcxcTZGcUZFL0o3dUQyRGlXY0pKUTN0?=
 =?utf-8?B?bmhwYzBlOGdlbGRjWmJXaG9weHhnMGkxdjcveGtxb3dVbXVLVmNaRi83TWhL?=
 =?utf-8?B?VUNEOFVuNG9sdnZscXN5ekV3NHVDcWp2L1owcy9YTmpxQzd3WU1yT2dBQXo5?=
 =?utf-8?B?Z1dyZU5mb2F4L1BPL2pNcTNES3loaWxxTGpEWXNRS0twTjNrbCsrS3h6YmFH?=
 =?utf-8?B?TEh4bDRjdHFFd1Q2dVFhTStSclFxYlIyWEF3WE9ZNm1RNUtCemg1TUdFeHN6?=
 =?utf-8?B?SGhkK0FGalVaZG1kWkxmdThRV2UyUGt1dmFEazBad0JOZklmUGpLNld5MktW?=
 =?utf-8?B?bjhNVlIvSTFYbkdrOGdIZHdTOXdndlE4ckVzbFJGMEFvZWhPeW5aZjA3NThD?=
 =?utf-8?B?OTRvTnIzYno0cjQzUFVLOUg0WVA0TXdVMjZkM3R2bmdsdmpJNDRBaGdyMHEw?=
 =?utf-8?B?YXVnNHZ2R2pXRStjMkprYVp4QTUrQnVTRGY5bFpxeW9IdFMvZTY2T0M3bjZk?=
 =?utf-8?B?U0hxSXZCMkF4cHlvNGlXclZGZzVURU5qRGRWZmhDSFlSUFN0eDc5WTRxYmJF?=
 =?utf-8?B?MkhpWENOQTVXYTRuNU1DbEhFZFd6MDZKeC9lQThKcllxWk9qSkRmYTdpV0Rl?=
 =?utf-8?B?SEVabENjOW9LbWkyMHdxVmhRQnRRdC9WYVNXTXlnOFFzRVQ4RVNzcWd4aU5R?=
 =?utf-8?B?NWtiYmN1MHIvN3BiVlhOV3d0VXluRkVqSVM0b1JlbGpLUVRCWTZxTHJuQUNn?=
 =?utf-8?B?TU11NEhHcG5ZVFBSQjVSb0o0MG83SW1zclAzQ2JmUlNGNlFoWVZKNkN3T3RC?=
 =?utf-8?B?ZDladm5SSGtFYkhRN0JSaUJZT3NVbWk5YjFnUWJiYndXRzVhWWt3ak44eFJ3?=
 =?utf-8?B?RXNnaE5aemZwSU9MOW1pZTZGUVZucTZCVjRLbzBLYVBFcWpObStISERCM1Y1?=
 =?utf-8?B?ZnEzd0hZK1U1WXZOVERtV09vaHhsYUlQbmd3NEp5QUJQdUptc2VRUFB5Ty9R?=
 =?utf-8?B?STd6L0I4YWNDNE93bXZIN2xobk5HQ2w5dDJJNE1UNGw3V2RCNlVZRWdwL0pQ?=
 =?utf-8?B?ekVJQVQ2UFVwTG1Oek9sS1R0RzNuaUtrcWZTWVNFcWxLMHJhY0xaSkJ0eFh6?=
 =?utf-8?B?M3JWcTB4b0JaL2dpdWpVTm9XeU5RMlZJUW1NaUU1K1NTNnM5bXFmdDZPNG5Q?=
 =?utf-8?B?YXMvWXdIbnBrK0sybGljN1NtY1FFTlZRbnluRjE3d0RXT1Rkck5UeGUwYUhH?=
 =?utf-8?B?d2tmYmpKU3R5L2kvSUpTLzNSdkN0N2ZXa1ovSldhUFRya3JoK0JyajN4UW5N?=
 =?utf-8?B?Z2laVENPYWNpT1FaS0oyeXZzUTJSNEhBYjRaNE14eUZ4TndGNXFtQlJ1K1A3?=
 =?utf-8?B?YUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6AC7F75036834841A407C6215ED2B8C1@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 745d7294-78a5-468e-390d-08de31a28b92
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2025 12:58:52.9203
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qcyQNmqmz9T9RSVjOzkiO9mDa/fOSHhoxFwRVC6Lnsf735Pk9Vm6QMI2N5krfBzBswY4TiEgGSidyqWrm2/reNbMUCRHyChMKgkq+siv4tI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR02MB7288
X-Proofpoint-ORIG-GUID: kvECNL8AoVLgtqufsuOgYShwmgf4z70C
X-Authority-Analysis: v=2.4 cv=HboZjyE8 c=1 sm=1 tr=0 ts=692ee28f cx=c_pps
 a=GnodoI7vw6685P6KDJTVEw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=JfrnYn6hAAAA:8 a=nq6pBA9TrdP2hHpb-IkA:9 a=QEXdDO2ut3YA:10
 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjAyMDEwNCBTYWx0ZWRfX+dQLIjnv3Z7w
 ilp69vvqlEt9PEI3N4qYdzgqNVaix3O2pY6WbuZ82gZq0A1htWohuLL3lRCfqAxTbnJmngOHSeG
 eGvqLO5bITpceng3CONNzT0C2K1wRnWK5Q0JcICkFY/Kkh+/1hgw0cklav47ik/+zemTsyBwE0N
 hURYj9B08P6/nUOFj+8QFlTKPw1IRns6pqeFBFzI1Jyetmc8IioReC8D57lr6Yuh0afi6319m4P
 d7vPpU0vn8wntl0OgdQ5FUbCVGU2nyHzTbyDPkin4rhJCiadeW5ROxDqnSgcXQ9yLZHUyGbrDm4
 gAJ+79ij1qEn/AEi8L8gsGFKgrwzxINjLaogONWPl57xRrb11wJaOWE3g4yEg39ZDF/oLNGVhj1
 5F8qUMgH/c1Q1CKte0iorXYc9H7CHA==
X-Proofpoint-GUID: kvECNL8AoVLgtqufsuOgYShwmgf4z70C
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-01_01,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

VGhhbmtzIGZvciB0aGUgcmV2aWV3IQ0KDQo+IE9uIDIgRGVjIDIwMjUsIGF0IDI6NDPigK9QTSwg
RGF2aWQgV29vZGhvdXNlIDxkd213MkBpbmZyYWRlYWQub3JnPiB3cm90ZToNCj4gDQo+IEZpcnN0
bHksIGV4Y2VsbGVudCB3b3JrIGRlYnVnZ2luZyBhbmQgZGlhZ25vc2luZyB0aGF0IQ0KPiANCj4g
T24gVHVlLCAyMDI1LTExLTI1IGF0IDE4OjA1ICswMDAwLCBLaHVzaGl0IFNoYWggd3JvdGU6DQo+
PiANCj4+IC0tLSBhL0RvY3VtZW50YXRpb24vdmlydC9rdm0vYXBpLnJzdA0KPj4gKysrIGIvRG9j
dW1lbnRhdGlvbi92aXJ0L2t2bS9hcGkucnN0DQo+PiBAQCAtNzgwMCw4ICs3ODAwLDEwIEBAIFdp
bGwgcmV0dXJuIC1FQlVTWSBpZiBhIFZDUFUgaGFzIGFscmVhZHkgYmVlbiBjcmVhdGVkLg0KPj4g
IA0KPj4gIFZhbGlkIGZlYXR1cmUgZmxhZ3MgaW4gYXJnc1swXSBhcmU6Og0KPj4gIA0KPj4gLSAg
I2RlZmluZSBLVk1fWDJBUElDX0FQSV9VU0VfMzJCSVRfSURTICAgICAgICAgICAgKDFVTEwgPDwg
MCkNCj4+IC0gICNkZWZpbmUgS1ZNX1gyQVBJQ19BUElfRElTQUJMRV9CUk9BRENBU1RfUVVJUksg
ICgxVUxMIDw8IDEpDQo+PiArICAjZGVmaW5lIEtWTV9YMkFQSUNfQVBJX1VTRV8zMkJJVF9JRFMg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKDFVTEwgPDwgMCkNCj4+ICsgICNkZWZpbmUg
S1ZNX1gyQVBJQ19BUElfRElTQUJMRV9CUk9BRENBU1RfUVVJUksgICAgICAgICAgICAgICAgICAg
ICAoMVVMTCA8PCAxKQ0KPj4gKyAgI2RlZmluZSBLVk1fWDJBUElDX0FQSV9ESVNBQkxFX0lHTk9S
RV9TVVBQUkVTU19FT0lfQlJPQURDQVNUX1FVSVJLICgxVUxMIDw8IDIpDQo+PiArICAjZGVmaW5l
IEtWTV9YMkFQSUNfQVBJX0RJU0FCTEVfU1VQUFJFU1NfRU9JX0JST0FEQ0FTVCAgICAgICAgICAg
ICAgKDFVTEwgPDwgMykNCj4+IA0KPiANCj4gSSBraW5kIG9mIGhhdGUgdGhlc2UgbmFtZXMuIFRo
aXMgcGFydCByaWdodCBoZXJlIGlzIHdoYXQgd2UgbGVhdmUNCj4gYmVoaW5kIGZvciBmdXR1cmUg
Z2VuZXJhdGlvbnMsIHRvIHVuZGVyc3RhbmQgdGhlIHdlaXJkIGJlaGF2aW91ciBvZg0KPiBLVk0u
IFRvIGhhdmUgIklHTk9SRSIgIlNVUFBSRVNTIiAiUVVJUksiIGFsbCBpbiB0aGUgc2FtZSBmbGFn
LCBxdWl0ZQ0KPiBhcGFydCBmcm9tIHRoZSBsZW5ndGggb2YgdGhlIHRva2VuLCBtYWtlcyBteSBi
cmFpbiBodXJ0Lg0KDQpZZXMsIEkgYWdyZWUgdGhlIG9yaWdpbmFsIG5hbWUgaXMgdG9vIHdvcmR5
LiBIb3cgYWJvdXQgcmVuYW1pbmcgaXQgdG8NCktWTV9YMkFQSUNfQVBJX0FDVFVBTExZX1NVUFBS
RVNTX0VPSV9CUk9BRENBU1RTPw0KVGhhdCBtYWtlcyB0aGUgaW50ZW5kZWQgS1ZNIGJlaGF2aW91
ciBjbGVhci4NCg0KSSdtIGFsc28gbm90IHZlcnkga2VlbiBvbiBFTkFCTEVfU1VQUFJFU1NfRU9J
X0JST0FEQ0FTVA0KaXQgcmVhZHMgYXMgaWYgS1ZNIGlzIHRoZSBvbmUgZW5hYmxpbmcgdGhlIGZl
YXR1cmUsIHdoaWNoIGlzbid0IHRoZSBjYXNlLg0KVGhlIGd1ZXN0IGRlY2lkZXMgd2hldGhlciB0
byBlbmFibGUgc3VwcHJlc3Npb247IEtWTSBzaG91bGQganVzdA0KYWR2ZXJ0aXNlIHRoZSBjYXBh
YmlsaXR5IGNvcnJlY3RseSBhbmQgdGhlbiByZXNwZWN0IHdoYXRldmVyIHRoZSBndWVzdA0KY2hv
b3Nlcy4NCg0KPiBPbiAyIERlYyAyMDI1LCBhdCAyOjQz4oCvUE0sIERhdmlkIFdvb2Rob3VzZSA8
ZHdtdzJAaW5mcmFkZWFkLm9yZz4gd3JvdGU6DQo+IA0KPj4gIEVuYWJsaW5nIEtWTV9YMkFQSUNf
QVBJX1VTRV8zMkJJVF9JRFMgY2hhbmdlcyB0aGUgYmVoYXZpb3Igb2YNCj4+ICBLVk1fU0VUX0dT
SV9ST1VUSU5HLCBLVk1fU0lHTkFMX01TSSwgS1ZNX1NFVF9MQVBJQywgYW5kIEtWTV9HRVRfTEFQ
SUMsDQo+PiBAQCAtNzgxNCw2ICs3ODE2LDE0IEBAIGFzIGEgYnJvYWRjYXN0IGV2ZW4gaW4geDJB
UElDIG1vZGUgaW4gb3JkZXIgdG8gc3VwcG9ydCBwaHlzaWNhbCB4MkFQSUMNCj4+ICB3aXRob3V0
IGludGVycnVwdCByZW1hcHBpbmcuICBUaGlzIGlzIHVuZGVzaXJhYmxlIGluIGxvZ2ljYWwgbW9k
ZSwNCj4+ICB3aGVyZSAweGZmIHJlcHJlc2VudHMgQ1BVcyAwLTcgaW4gY2x1c3RlciAwLg0KPj4g
IA0KPj4gK1NldHRpbmcgS1ZNX1gyQVBJQ19BUElfRElTQUJMRV9JR05PUkVfU1VQUFJFU1NfRU9J
X0JST0FEQ0FTVF9RVUlSSyBvdmVycmlkZXMNCj4+ICtLVk0ncyBxdWlya3kgYmVoYXZpb3Igb2Yg
bm90IGFjdHVhbGx5IHN1cHByZXNzaW5nIEVPSSBicm9hZGNhc3RzIGZvciBzcGxpdCBJUlENCj4+
ICtjaGlwcyB3aGVuIHN1cHBvcnQgZm9yIFN1cHByZXNzIEVPSSBCcm9hZGNhc3RzIGlzIGFkdmVy
dGlzZWQgdG8gdGhlIGd1ZXN0Lg0KPiANCj4gVGhpcyBwYXJhZ3JhcGggZG9lc24ndCBhY3R1YWxs
eSBzYXkgd2hhdCB0aGUgZmxhZyAqZG9lcyosIG9ubHkgdGhlIG9sZA0KPiBiZWhhdmlvdXIgdGhh
dCBpdCBvdmVycmlkZXM/DQoNClJpZ2h0LCBnb29kIHBvaW50LiBJJ2xsIHVwZGF0ZSB0aGUgZG9j
Lg==

