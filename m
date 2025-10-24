Return-Path: <kvm+bounces-61020-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 90080C062CD
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 14:10:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 644D61C02117
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 12:10:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A109E3148D3;
	Fri, 24 Oct 2025 12:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="oxQE0ZI9";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="YLwLXlGO"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797FC2DC344;
	Fri, 24 Oct 2025 12:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761307784; cv=fail; b=DC8zGWLInG3djygaF77zGzsvsqWYFQQcMuBFHTxNIlry09qO7rwLMW2W7J5tzRs+UhcpJpQHdWTMsJE3brCChTwiaxZPZgTK87gTYlu/Ralr6W4wxqVZB6Lgesf4wEQLBoC3M4bAL6YSgWMlDx0frpVog6fBrcTapva7LW/3EdQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761307784; c=relaxed/simple;
	bh=pVTaSZB2X/WruWmokqarUYFoPM3MabGyHBfTHk8vohE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DHJuvwNJU0Ee2hf1HgsIG5xPDr+03wGX40LP7c3r3IchzW2QTykRoKtfltlyGwCXKVkDzc0yvXizV6KDWkYhrgMkC7u19z5P6Kv+clA8m9/i1ayhuXjG6Lj1h/ruPlDGLLP0F7YO9ubDJdmRnlbn8Y+/eNjamxDvFUcKE5+P//E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=oxQE0ZI9; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=YLwLXlGO; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59O1c6ao095852;
	Fri, 24 Oct 2025 05:08:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=pVTaSZB2X/WruWmokqarUYFoPM3MabGyHBfTHk8vo
	hE=; b=oxQE0ZI9kOxSfSPRuAuN7JBxJnEtTaTZYodKUiZzUT89BN0VH1tSFYugy
	FOpQhrJLiSnPoGSVc3mZZQf/uoUeq4n6XGnpY55BAaj+frM39sE/uzOj0K8GNdHr
	KZDmOumVE0r4PPa8VXLjYLUSuq0c/RNE8703tFJi4sK3A1kcFXDIU2+2mzjB/5Pv
	4sXZjZNJN6pbShlAGSFyQL2BIpZSgD2Xd+zfdHGyvmA9WPE0oDfrYszwrUkTol3p
	Zn1JGa/Q9Ab/44NZDL+D3iyPEA5IJJPJ4j4LP3jBcpcImcMdroU2gGT7Z8EeA86u
	/H5ot0QcrmkHcDm3UBQm4t7anJ96g==
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11020138.outbound.protection.outlook.com [52.101.85.138])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 49yncgtdps-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 24 Oct 2025 05:08:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Im2STl6JH/hLtPAHZP34FuOye2dOF0Z5j6XnxrrjVWngp0W5CXrGdvONasKWjUcUtuVnBu/pLWzSCiCb9pxQTnwBAfzdNAVILBVAwtCEJZLOqeUrglipz55k+QDl86KmMkTZAMFvi6JegTwcDMv5fbNhBg683h7q3uENwyNEiB+tG50NkpMojnGkeIs+ZCzzmKlz0EzUvSxmfyCUq7UYVg9WUuhV4I5IDl/hwxEI6EjahZXJM1tJcanBWBTdMhqPT8XM7zcY2sZROD0vSl/8t7xh/5XP1qRmjQVChLnmWrUiuElklZebaHaaNYJeLsrKUP7nBeISMVPBa4usu4dIng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pVTaSZB2X/WruWmokqarUYFoPM3MabGyHBfTHk8vohE=;
 b=LOZUEY+UaLTVD6gjH5lUe/LwxHma7YUCKApXlh+lL+KVc5HnXLEoNKEmWKl7TRcng4SLREHwss1PNoY5rZaDaM806bAUzePCpG/ro4r9Swv+ZtPDCKLM+V8Hk0k5hpLsYEv4MKi+MNPA7PdMqeU2CWWnoO/rFzSVKkibh479vyMMrJ6meS6jWbQAAB+zCqLGTNWySCsrX5aJCsCmwEsZyuJWZzRgeEGlvOMJalb+NQPHE64xhGg3Ia9qWubS3fgFYSnj4i1yI8s3i1Ve5MT5qnRu3qcuct75k8ddEflHTfsvigAFq5TezLtvvZGCCRWCqnyJsVMzTqGDmxwiIlBA1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pVTaSZB2X/WruWmokqarUYFoPM3MabGyHBfTHk8vohE=;
 b=YLwLXlGOW2XUStW8CIVNjC4mnDlwRydyRUxdq6Z2v7apG48P7Nn7fd6Jb1cbhCKmL7xUiCmNQJEoLO3XW/d6LfQfzsi/9E35p3zgXbraoy3hVUAECyjYuz5aCP0QC+VygrAh1KGGJSIDtAf+wimr25IXKJp9BPpA9/isyX2zzbsCQfJyY3yWDJoG2EskbS9Og0L45mtHy+s76NtsmQJEqcTk7pIYLGzH+3QcStol8AezD9xjCx5hDfwaBVnox7BCagKOj/Ken3uEZsyojCwkfE1SWbXvU2qlC37O4+H5It1Ui4ERPDIJyKqmHzd0mFZaJy1W76o8Z9m7IPUMLu6VlA==
Received: from BY5PR02MB6353.namprd02.prod.outlook.com (2603:10b6:a03:1fb::31)
 by CYYPR02MB9826.namprd02.prod.outlook.com (2603:10b6:930:c0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Fri, 24 Oct
 2025 12:08:54 +0000
Received: from BY5PR02MB6353.namprd02.prod.outlook.com
 ([fe80::1be7:41b2:df69:6ab9]) by BY5PR02MB6353.namprd02.prod.outlook.com
 ([fe80::1be7:41b2:df69:6ab9%2]) with mapi id 15.20.9253.011; Fri, 24 Oct 2025
 12:08:54 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini
	<pbonzini@redhat.com>
CC: Jon Kohler <jon@nutanix.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo
 Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen
	<dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "H. Peter
 Anvin" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: skip userspace IOAPIC EOI exit when Directed
 EOI is enabled
Thread-Topic: [PATCH] KVM: x86: skip userspace IOAPIC EOI exit when Directed
 EOI is enabled
Thread-Index: AQHcKLOgBGqDS4wr/EWm+kbhH0rY57TRbHiA
Date: Fri, 24 Oct 2025 12:08:53 +0000
Message-ID: <A15A2625-574F-4ACD-B551-D46B016633DF@nutanix.com>
References: <20250918162529.640943-1-jon@nutanix.com>
In-Reply-To: <20250918162529.640943-1-jon@nutanix.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR02MB6353:EE_|CYYPR02MB9826:EE_
x-ms-office365-filtering-correlation-id: fe03f808-9dbc-4a1a-8621-08de12f619ff
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|10070799003|1800799024|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?MUtjWVg4SEQ1RjRFcFYwc2MyWkJxZlZ3QnF6R0pYbk90a0VZdzZWVjg1ZGlO?=
 =?utf-8?B?SmdmSFBCWDdPNTB4NklKYngwMnBCdlk5SFRTNGJGU0NUbmkxMXF3Si9UT0Ev?=
 =?utf-8?B?MEJCQW9ucXVYdGJwcmdGZEJhaTl1TGVEMi9vbkdCa0xxcmhDWU5OdWk5UjZs?=
 =?utf-8?B?TE83b1RBZ3lrTUlBeTNlK2tvNS9FUHlUTzA4SjZFbDN2bXJ5VUIrU3BJSXJv?=
 =?utf-8?B?R2NOS0Nnc0FXcU5xTHJXUFRaL3JNQnc0UCtaTlgwMEgyYXJTYlNQanZQdTJi?=
 =?utf-8?B?R0FOejdvQytuOEt3d1pXZENBc2QySTJQMzBjdmVMTXduQlFTQVhsYVAyYTls?=
 =?utf-8?B?c0F4OEhMR3hWQTdzbGhtMnVPdXRLS2MwVXBCa0ZyU1hCSzFwNjZIYUFabnh0?=
 =?utf-8?B?STRPMVZlbWxaNDU3N0xTVXlHYVZlSG9GV0ZUbjFsTFZUVTdVbmdYbTNoZGRL?=
 =?utf-8?B?M1BUVGlDRlN1M29rUUdHd2JOQk81SVhrRjg2ek5hK0JUd0RZYWZuWDJHb0gx?=
 =?utf-8?B?TFFpNlhmc2pJUWIzZjJsd0hqZ3BJdFZHd0VoWXVOa0wyeHhCMXRhM2xlNzBH?=
 =?utf-8?B?dWNRU1VrTzZTcFdEaFhET2Z2cC9mR1dEc3pISklyMGRsS2h1MEp6M21panFM?=
 =?utf-8?B?NlE2YjI1MXQyN2NJME1rWjA0QU8ydXBKZkxWRkpReUQ3cUZSUXl5RHFHNUxW?=
 =?utf-8?B?UG9VTFoyYVZlTWNBaXVJZFd5eFhBMHZVUUh2UEVscC92Q3FqQ3JycmV2SmNN?=
 =?utf-8?B?Um9YaFVUVlJNcm5CVVA4YXNpTmNqOTZkVU11MncyTlJKTmg2VEhYdmRVQTRZ?=
 =?utf-8?B?NDI4dUcxTWI3bGNZa1pRTE80L1g3YWhkRUcrVklSK3ZRUXNCeGVKWVlURE52?=
 =?utf-8?B?bzlKMlZTSHdQMm4xM2RYVjZhaEI5OFgwMi9TVW1OanBHR0JEa0Uvc081b1Rp?=
 =?utf-8?B?dmhrYndJbGFxMzhqRFVoTHNvZkJGeEcvaFkrWE9kMk1UZmEzb1V6bUpuOWRn?=
 =?utf-8?B?ZFVSbDk4RjcyanJ4U0k2Tjg4S2JZL2JVeDRmampXcHd3MWFvOXhSRVVwUEVn?=
 =?utf-8?B?M3pVQWEvaXdvTEJmYkwrcWxqUjZxUmhnVXQrZWg3S3dndDRyNnVBOW0zY0t0?=
 =?utf-8?B?ZUVSTnV6R3hZZmY2MWZSeGRhU2F3SzB2ZGRoV0JRTDF5K1dvVjNYK3lUV0hu?=
 =?utf-8?B?RXFRTWJFUjlxOW5RZDBJNXJCaGtxOTlBTTd0b25NWnVkNkNkQkxWWVFUZWpk?=
 =?utf-8?B?NE9LMDY5aGw4T3E5VnZTL0JjZHl3eW9uL3hXZ0dIVHo5SzNaYjRFOUdvVnpJ?=
 =?utf-8?B?U3ZpamhvVmhSYS8yTDhBMXltSkFXYytmT3p3aXJqNEI0R3NUbjFwQ28ySUs3?=
 =?utf-8?B?bzliNjdTYmkzdUhSamlQU3dud0lTdE9Md1hzNzJQK0sxbDNaaXYwM2lPZHBu?=
 =?utf-8?B?QXpIYjQ2K20vTzVIK1puRk9MTGEwUEw0UDhscm1JWjFYdWI3TEhVQlY4endC?=
 =?utf-8?B?MEhDL3JuMk5CM3BWUEQ4NUt3a3EwSXl1VTlIa3krWlZkSjJ3c2JENVY1dzVw?=
 =?utf-8?B?WjN2UWozMFI3RmRzYXdJMkYxc0lmclJNMGtuRFNxZ1VuTmlaNnBQYzRwL2JO?=
 =?utf-8?B?RzFIN1hiaCtFYStrbzRjZjhNVUVwQWc0YWhCV3ZXTnh0Ynk1RFBmSTFQKy9I?=
 =?utf-8?B?VjIxRDUvUTNxbUNpNFZ1ZnNYdlBXejZWaGpMV0tJVnpvRVBKaVIrZEU1LzZJ?=
 =?utf-8?B?RzZLMnRMWHpYVEw5cTg4blRibCtTVG1nK1JZeU9kL2JvQXJHR0MzcXovcDhU?=
 =?utf-8?B?am5uTVp0VUdmTjFpSFVpZnhWZ2UwMW9pdEg5T2NmdWhqTE5HUnovcE1CdnpJ?=
 =?utf-8?B?TENSL25NN0VUbjZvd0pXekxzMktEM2d4SkFIQlhWK1Vadm5yTVJBa0kwa0Fo?=
 =?utf-8?B?K2tjYmtTZHR1MmNzeEtaZW5qRFMway9Mb3RvNEFoejNMazVHcnlpSU1ZQkNo?=
 =?utf-8?B?dTZyelVjOXF6ZFF1SG9jVjlFZS9JbTRwUER4eUo5WjV5NjlrU1FWVWRVb3NU?=
 =?utf-8?Q?BKNIlE?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR02MB6353.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(10070799003)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MzJEVU1nbW16Z0pqUGRFT2EzTUVXV2NyUlNsMkdYNUdWaGFoQURDZUhUZ2Rq?=
 =?utf-8?B?Vld5WnFja2FONm1iRGs0VitIUm04ZU1KOHYzOHM0WmEwMjhFaGF2cGZJMnRw?=
 =?utf-8?B?c3FvWUlHUFdMdGVWK1B3V2cyR0g2ZmgzOXR2eFkwNVRyMjJMeTJGZUdJVjhO?=
 =?utf-8?B?Vi9nZVYrbkE1a1lTR2QrU29Iazh2NExDNmt2OW10bzVPUDlKTUs0UTFwdWJq?=
 =?utf-8?B?Q3lyM3ZKWnpud2NXNzJIeHBmeDBjYnVoRWIzalhUZFdrR3h4WnVqY2I0WVhL?=
 =?utf-8?B?OVZoT25wSnA0MWVENFRUTEIxN0VON3JjVTJOOVBxaDE1aXdHM2RyYVdzQmgv?=
 =?utf-8?B?OWpJRWJmaGdrOHdtZzNPd0hDeGppMkJTeFFmWkJDL0ltZW9FdEtjUmxGQ25y?=
 =?utf-8?B?bmptZ081SHZhUi9rQ3VPTmtleDcydk13aVpBS2RqRFRNcWlHMWh4enEwL0cr?=
 =?utf-8?B?amRGT1hmZzk0VW90NWxkTDFBNHNvMVlJT2puS1NpQWVPS0VFbjZDYzZaSitv?=
 =?utf-8?B?V05CSDJOUHR6UFY3ZzRCRzRtV1hqRHVVNVdmTlZMZFBPQ0k3aTN2UDNoNWhh?=
 =?utf-8?B?N0NPZHV4SmpXRGI5dnZwS1VlTkxWcEo4djkvSnlMTy9nazl1SjZ5QWRCMDFJ?=
 =?utf-8?B?SjZVeWhTT21sTVlMb2NFQXlraW5XR3VMUkwwNWU4c2tLZExxMWs3VHV2THJT?=
 =?utf-8?B?MjVaRDYzVCtwK2dCaXZ4ZjBLVjJGeUJpelVQRk1aV2JEdUpzWk1rekJZWnYz?=
 =?utf-8?B?S3dWZ044MjJDdDRUemlGVkVONXFTVWdnTkNjS3BlbTNPd2RGRFlMSE5KUzlK?=
 =?utf-8?B?UGJPV3htZit3QXJLbloyRHFla1JqaG5HaWtMaGwyVWZQS0l5cVVMUzhPVTdy?=
 =?utf-8?B?OStiTnhjT0Y2Qm1SU2VPSkZkVFdseHdKN0FYZE5zYlFSNEFvYzFNTEszOHdT?=
 =?utf-8?B?Y1poSFY1dFNaSTF0bXp4SVRXOHNCempsRXJBeGFpa3Z1aFZDc001LzZHcG4w?=
 =?utf-8?B?bGZLUlpNc0xpZUV2NEtYQlh0MWExZFpJM0VOQTFCcWt5RkxlTHk2UXVJL09G?=
 =?utf-8?B?MDB5dXJpOUlYM0g4V3loMnB0UDJsWm5JbU93eGI1WmhsMzkrU2hiQU9CeEFt?=
 =?utf-8?B?VGZyZnFGR2JjYUh1SG5XUjVmS0haU09JYXl5Ym9UNUVKclhZc2xuNzRoT1R4?=
 =?utf-8?B?QnBxSnRDSHg4ZCsyck1tKy80Ymh6bW9RVWk1Z0t5QzBDNHk0L0ZZL3RjRUUz?=
 =?utf-8?B?TUhCNnhMb0p5Yzl2UUF1VVhJQlRMc2FFcC9NTWlqSExULzJ4eVVvVzdJc0gy?=
 =?utf-8?B?cGVsMXM4MXFwTTlyUGlOT00yVUIrb0h4clVXdDJqUHB5WjJCcDk4MzVxanBJ?=
 =?utf-8?B?MXZWNDRvdzA4Uks2Yyt5WFJrcVdCK01nZllmNmZZRzlOb0ZDSEZUbXdNWUtz?=
 =?utf-8?B?STBEbStTVCsxRzg2NHhSSHIvclRKTGVjU2pRSnhDKzgvU2xxajBBWmQ2VGpO?=
 =?utf-8?B?ZnpWSi9mWlZPdUZTZU16L3Z0WHZkMC9UdnErclB3bnZVZVozOWxMdGV5MXds?=
 =?utf-8?B?QW14TkExNEtUSVVjcGx1WDNnandvbjNQUVlYY21KdTUzd3hVVU9qWWJoMElC?=
 =?utf-8?B?TE1DMFNNdFFIQ2llRE92dXZVN0hvK2FVTHllWDh1ZDd2bktZQVhKclkyeVBx?=
 =?utf-8?B?R01QOVI2ZnlZNUE0QXoxY3BRUjU4THJXRDBaTG9oMXl3RXFTNktZSUZES2Nw?=
 =?utf-8?B?OW1heTArWXlrVXNsb2drSUZJeU1wKzBvKzdHMVRCUlJyNytFanVxOTUvWndR?=
 =?utf-8?B?djV5RUtqc0wrcGZLK0dhVnpwZmJudm5xOXdBYmtaZU4zVWF1c1NYVVExSVVY?=
 =?utf-8?B?eE9qUHJwWS93UTlPNFN3aVpEN0ZYYlNDREVZOCsxR1NPbjlKR3BFeXRCR2lz?=
 =?utf-8?B?eHQ1dHh1VHlQbUJhUlRtaThBU3lBZnI3RDFRbXZ6YlUxbEhISGxUSys3emZq?=
 =?utf-8?B?ZXI0OWVLdTFqSVB5UkJvcFFSYmovN2JGalg1UVJCbURZbFBhZEE3eisvRldz?=
 =?utf-8?B?eWdUOGdUcVJGRXV3K2tuQ08rQXBwbzlqb25pd0lrTUppbmNVUEtuQ1p2WGxo?=
 =?utf-8?B?Z2N3Z0JnVHVmK01mNW5MY1dSS05UWUphd201TnF5Z2dqUG1VT1ZUMTNIbExv?=
 =?utf-8?B?MnpBeVozL2s5SFpndlY4THF6aUdjUTFBTVdNaHlQTlgzQjhiVnhybDBQN0VK?=
 =?utf-8?B?NU5qSUd0L3FqSnFBWUR0VFRGYTNRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D42F69676A571E459623FABE20392A51@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR02MB6353.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe03f808-9dbc-4a1a-8621-08de12f619ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2025 12:08:54.0095
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9ucZFYUrAZV8IBUctJfZsAuUuRUqSJLbqo2xY+27Btfb8GJT8oATXrh3HDnLBDvRZmY9tBOYFeKXMhuZvo4QZpg654ObJpVnDtJ4MqGbI+c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR02MB9826
X-Proofpoint-ORIG-GUID: wbcDs2b1x75M_5F-DiQqURSkzJtvAu87
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI0MDEwOCBTYWx0ZWRfX0aP1gfrNHAXT
 XqstH7rbVRHLMsV6vzi3Rjoo9/s3sltNc0PcV7sUTHKjdd+p86EJARdu8fSizisIz5hg/1BMW+l
 qZLLkWL3JmjMxzdQStHmQkCs6hZT3HNeNoGP2p1/xnB/AEvN3yrV1e5wBZwVBZk9uPdBBdJuJmu
 6jDvhCu7R6ZbIb1c6k7kT66XCBTsN9B1Z0Q1+BiMvI+HYt1E5sqW6r+iD9YDLuX7WM6QeS+j+0F
 RW1XGEX4Na2OuImKrdT21KbWpFmeV9ocov6QwoMq2HqkWNqDCa26cq3il16Vnxprd+1KVepwcL3
 1Xi/QxswpJE0WHAuibIOdX//n1l51g9hU40D/ark/AtHGEL3weiOcykLkrT3+mvPPKKrsTjSjFr
 z1HZ6mEp7aV8oPeMAIWhd4G3/FhVGw==
X-Authority-Analysis: v=2.4 cv=MPFtWcZl c=1 sm=1 tr=0 ts=68fb6c57 cx=c_pps
 a=LJnPBYNXoDXf0nqqeknapg==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=zPDcAfKELqem0OgpuicA:9 a=QEXdDO2ut3YA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: wbcDs2b1x75M_5F-DiQqURSkzJtvAu87
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-24_01,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Reason: safe

SGkgQWxsLA0KDQpKdXN0IGZvbGxvd2luZyB1cCBvbiB0aGUgcGF0Y2ggc2VyaWVzLiBUaGUgaW5p
dGlhbCBmaXggYW5kIHRoZSBwcm9wb3NlZCBLVk1fQ0FQX1NQTElUX0lSUUNISVBfQVBJIGFkZGl0
aW9uIGFyZSBib3RoIHJlYWR5IGZvciBmdXJ0aGVyIGRpc2N1c3Npb24gb3IgcmV2aXNpb24gaWYg
bmVlZGVkLg0KTGV0IG1lIGtub3cgaWYgdGhlcmXigJlzIGJlZW4gYW55IG1vdmVtZW50IG9uIHRo
aXMgb3IgaWYgSSBzaG91bGQgcG9zdCBhIHYyLg0KDQpUaGFua3MsDQpLaHVzaGl0

