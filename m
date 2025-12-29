Return-Path: <kvm+bounces-66780-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C89E5CE7454
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 16:58:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0C34E300EA15
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 15:58:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5144D32C31A;
	Mon, 29 Dec 2025 15:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="n2EvuD6w";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="RVnGChkp"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F2723F27B;
	Mon, 29 Dec 2025 15:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767023878; cv=fail; b=MgY1pQWMCVFJz1yRgyddgwIYELKSIli7TogGxxPtxRfJa4qP9ZbzRL+dpiPksUgvIs0EkB34McVN3SWyd7DQuEkcdOTWL7yUYoylj6BbP7SfAoASWRvlMJN8Gu/deNp5t9xxOcY5EEnqTfrQ1fvs+rJm08c4FTcAEq2QGJ6E8lk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767023878; c=relaxed/simple;
	bh=NXmi8oKR3DDMJB5dd3xJ8Zh2bkdsT0v83NxljbWgbl4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ds3U7MPKuJrah2/MOj5WceTbUAqreg01z76lZDmQdJmiFQL5AXuiHgmvzB0t0YMOtxAbKEJBi39kjTTSROieaAsk3I/quDlO8TNLESu93eJfglaJaWNaavA/xgPwcNSHRmkRJjh+EDJTM2BkrnWUa9I7nB3vyn3CjNjjG9kV0Pw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=n2EvuD6w; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=RVnGChkp; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BTBp6A83834886;
	Mon, 29 Dec 2025 07:57:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=NXmi8oKR3DDMJB5dd3xJ8Zh2bkdsT0v83NxljbWgb
	l4=; b=n2EvuD6wqDpFrV44MCQ9etp7C5GY8bbEkplXDv/KXZiaPQTMaqtr9ftqd
	CER6L5IJPX+2zIdVMgYH9XZRLqfS7uzOoi/mBIfohtbLQ4+I8uCj3NnKFa/oJPnB
	DJFUxzxK3ekPoQqxNYYyFqxlWXrT8gV1DTJg2LsjBuDkc1L59i0Yx3KajhGUTCUW
	/lrFBeVgqySZPclNQnhe+r7mf5i84QKNgMt9eUjr+A8sN5wbVVqTnU7Q4QnKjF1D
	DuLloEVVo+DA5poHzWau7zl5r9rPqXk970UeUkvh/pCOladnybWwkUme3Kyeuk8g
	1PYjeu7PtSTncl5zLTtMeG8JcXrnw==
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11021116.outbound.protection.outlook.com [40.107.208.116])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4bafw0b15k-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 29 Dec 2025 07:57:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VtvXf56s4pKJvFjTeseQ7hjP62TB92mXzXeqQOSl5FrJ1Pa8qimZ7xUywjNXFeouA3rXAHLxHg/aU91uUrdQZ+PKsWiNiz/rD5OKJS80IC5m3R/2Be/URqiOhBe34HuLa/8g5wausZJh1SmoK6p+QDJl9YNZFrECkrXPvPdFoFVLUWxmgSzsAChpSJMl7ZkYbIIWKUQTqo5woJ37tS8AGRyMAcuILG8YIe3XRifRgJqTbCRjmwLnSt6EyzmfuRv2gFditKcSRiaeoEFtGEilmGvppdTVryOhVN23WviO5bKJR8blCmbwREvGjisBcMtXZyOKXgQi0GnNJ1ZiQvtleQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NXmi8oKR3DDMJB5dd3xJ8Zh2bkdsT0v83NxljbWgbl4=;
 b=vfJ36bi+7VbMp1rKce2EeY9O0ZTTR7ZvGe6c55l7E5WwpsvYzjBSz9lx7XAbC24rW/2Mow7jSoQZTWIlIIW85rM5aZALB517wiwth0yGkaHsPvz6tWFYnQrcfydOTpv4UDUA9IGbAW4M55ASODIiWFLzya7iMY2lz9+CI7uM7/3SaDF4JxOokgAoFrzNeXPeFtatORn9FEalA0J5NbdN9nQc68U2vTJN0bF8LeIYCorwHPOCzpOUluk27eVePqw5eB77T41AKJGnGj2NjJSWTedvLpxl7K5V1I3W8FhdaU4MbjrPid6E1q6QIqQ0cxcbWveuxZUx1rY+3i+1cYYpAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NXmi8oKR3DDMJB5dd3xJ8Zh2bkdsT0v83NxljbWgbl4=;
 b=RVnGChkpuBRSW0Qmj2ubKa+wUtVlTTyr7WluXSlUUYPoZM+oXpnn1gu5CORZQiM+yeDfbMq/SlRq+Ej6AU8O01Kuhr/7lidSXiib+TmNteOnA6MstNciboe+vg48BaqiLWCfzdmmuiInRqm2dPjxgJ/MT8UBcq+796jVgUXgEyAo88Zf4t32D8OwYXoHBm3d9mgD/xbSmkFALaxUtdkQW6O2ZqW/2e7zC7nGfmL7LQissbe9U1arAXMd4tRU98IsueCtX+jJhl9Wd8Fg8YS4K16Aax93Zfhp00wZzkRUDREz+tlrh2bpZ62NrnvSUXCUMTvyv8E42+8Pg7TaqJjvDg==
Received: from PH0PR02MB7557.namprd02.prod.outlook.com (2603:10b6:510:54::17)
 by SA6PR02MB10551.namprd02.prod.outlook.com (2603:10b6:806:404::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.14; Mon, 29 Dec
 2025 15:57:24 +0000
Received: from PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef]) by PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef%5]) with mapi id 15.20.9456.013; Mon, 29 Dec 2025
 15:57:24 +0000
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
        Shaju Abraham <shaju.abraham@nutanix.com>
Subject: Re: [PATCH v5 2/3] KVM: x86/ioapic: Implement support for I/O APIC
 version 0x20 with EOIR
Thread-Topic: [PATCH v5 2/3] KVM: x86/ioapic: Implement support for I/O APIC
 version 0x20 with EOIR
Thread-Index:
 AQHceLTEKfxcrcgmBUCGXzBVU4MWXbU4fimAgAALkYCAAAtAgIAAJdKAgAAFdACAAAXugA==
Date: Mon, 29 Dec 2025 15:57:23 +0000
Message-ID: <02B570C0-BEF5-439C-A081-9537489A7FF7@nutanix.com>
References: <20251229111708.59402-1-khushit.shah@nutanix.com>
 <20251229111708.59402-3-khushit.shah@nutanix.com>
 <7294A61D-A794-4599-950C-9EC9B5E94B58@infradead.org>
 <DD13B2B3-5719-410F-8B98-9DB3E1738997@nutanix.com>
 <9a04f3dda43aa50e2a160ccfd57d0d4f168b3dce.camel@infradead.org>
 <BE16B024-0BE6-46B4-A1B4-7B2F00E4107B@nutanix.com>
 <D6CA802E-F7E0-410D-87FB-6E6E5897460E@infradead.org>
In-Reply-To: <D6CA802E-F7E0-410D-87FB-6E6E5897460E@infradead.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR02MB7557:EE_|SA6PR02MB10551:EE_
x-ms-office365-filtering-correlation-id: 6d061086-88df-4969-8e24-08de46f2f502
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?Q0FYMlFCZ3puRCs2a0oybXpVREorK3lhUTE0SDRENGZoeXIzSzVYY1JhWlNk?=
 =?utf-8?B?d2UrbjVRNjA3Y2YwenlEalkrT2h1UVlQOTQ1eENvREVYUWhGdTZFTEZIbjg2?=
 =?utf-8?B?c3VHMHdEVHREVUhoSllremkvOEI5MnViZUJ0NDBNSklCNjRBaWRXeDcvMDB1?=
 =?utf-8?B?WGw2ZjdaR0FINDAyY056b2lJSDZUb1U5bDUrYk84VVd1a3h4akVpWENxaUdH?=
 =?utf-8?B?aHkya2R0dVB5aEI2eW9haEdGSU1jZG13YjZveXZiT3JSZHI3SkhqaFA5Um80?=
 =?utf-8?B?NWtENDRFZmo2VnhiQWFKbHZZdzIyQnpvN3JDTklKTHM5SVd5STRrdjJjbGhF?=
 =?utf-8?B?eXRKOTJEcVN5eE1ITi92STVkUjArNnl5ZE5LRExTWkhSWTJWNnBEUHduandD?=
 =?utf-8?B?UXdtUTIyUjkxbGpvS2piUzJML1J6TUlaMnNzZEt1S3JPL2lDOWVnTzFKdXhl?=
 =?utf-8?B?b3Fxb05EK1lDRUdDWEd1NlZ0UFlTUGgxS3ArbkJwbmdPdE0rbFZ4R2ovamZP?=
 =?utf-8?B?SlhCZCtTdGk4dTlkcnVYQURBNXkzMzVqQk1UcWxDUGlKR0ZCcmdjWksyNXZK?=
 =?utf-8?B?UHA5QmgxdEFOeGd0SHh2NmhSVnZrbDZKWHJldjRaQnJjREhVc1ptQkUvL3dO?=
 =?utf-8?B?dkRGOFU5QWRqSGY3NXRiTlpVb1BRTmZDR2QzT2hmM2JzaFV1UTZzYVVSVDhM?=
 =?utf-8?B?ZDY4SFZHbm55ZzNtVENQYWFEam94U01BNzcvY2VyNTlQR3JzMWd6U0xMNlNC?=
 =?utf-8?B?VUZEeGFlazhEUkhhZG9JYmpnWUphekhkRjlPQWtJeGx4SWNtWDhMS2szNDhZ?=
 =?utf-8?B?WTJWNFJKU09DWElQOGoyNnZkN0ExRXpNWDhlZG1YRkpVbE1kUVUxQnFIVlVq?=
 =?utf-8?B?RnJvajQ1dnVOeTNEZWlRWGp4OG40QVpIYnpxdER2dUkwZjhYS3FETzRRVnRX?=
 =?utf-8?B?U2pXaENGc1FuZ1NtRzMxM21wUjFBdHdDaHZkdUd0bDVkaG4vNXNEeWNoazVN?=
 =?utf-8?B?akp3YUlpUHlFV3J6SlZ4RGxBRHRNQVZYUG5OWUNrZGE0NDgxSlBIc1JZTkpZ?=
 =?utf-8?B?Q3orb3hDRDJJcDV5eDFCd284cnFnK3IxUlVrTFM4OUVoUng3NUtqVkt2cXVZ?=
 =?utf-8?B?NExTWEpRMVRhYTV3cGNpOU8vZGJNbGd6S3NvdDhiUlBoalJjdGtSUnFvQlVD?=
 =?utf-8?B?NWdJdWx5VzRpWW85ckZSQS9aTUdldGxSYVc0MmRBbXlpRmVmeVJaNlZnS0ps?=
 =?utf-8?B?anF1eEJNUytGc3VFeEp0KzUyTENyQU9jOFc4REtHaEJ2VU83RzFRL01tRnVY?=
 =?utf-8?B?OSs3UE54dUpkNDBFc2hXd0RWbEdOcG52UEhLbHFoMEtSUko5elNFZFR2SHhM?=
 =?utf-8?B?OGR6cWNJcFZla1FheFV5QndCYW1FazBvOUNXekFkT2dqYVErSk9OcTdmeUlZ?=
 =?utf-8?B?ZFpjeGNKUERHZjlhd3lLcURrcDJtZURGb0U3OXpISUhzRUpaZ2pHK1ZsLzNO?=
 =?utf-8?B?WTRRVDZlKzU3d1pmdElCdnRDQnVjcGNzMi9GZWQ4dmd0RTltcWhYdnA5N0Ex?=
 =?utf-8?B?dUtNWHY0N2NzKzhKTDR1Vm5Uc3JXc3VqY2U2M1pCMEhneG1IUmY1QUIxaVYv?=
 =?utf-8?B?STl4MGw3V2xZZXJOSXU0dkkrM3gwU1hPZ0Z3clA2QlhRUWdqZUpJek0xNFo5?=
 =?utf-8?B?WXE5M015T2F2ekVFQW9pMDJaVUtjeEpTNEh2QWtqQ0lwbU5aTFdXSUdmOHdI?=
 =?utf-8?B?VXBUSi8rVGNXTzA4WHEvK3BsY2ZxVUdqS3JCQUVRUXBENG56TGwzcHd4MzlY?=
 =?utf-8?B?NzhZemVMYW91OTZXd1AxNngvTHF0UnM5bHdXd0trRk9lUmVHOFErUldHdzNB?=
 =?utf-8?B?cWg4bWg1cGVvK1d4Y0V4VGVvQmRxRFZ5TnAzUXA0ZE1GQnNZTXVGUlR6SmtE?=
 =?utf-8?B?YTZvQVRDMEs1VVBFc1NveU5UbmV2NEJURTZvSDVhSm4zSlB5NUdKVmQyRFFK?=
 =?utf-8?B?UW5QSTJvWjliVWhUd1FOSG5ZTFNRUlhGNFROR0hEUmNGcm5WREdjNURJS2FH?=
 =?utf-8?Q?K13F0l?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR02MB7557.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?UXZRRkJ6N3c4NklEZzFmcDBUMGREOUYrN08zUDRpWmNyMlZId2hRRFNxVlA0?=
 =?utf-8?B?NSs3RGUrTm9YaWJqQitJckdFajVVVm5aYnZiNDZMKzBVVFAwWU84eEduUUR6?=
 =?utf-8?B?YmhCclZrZmlxK0xpWnRhekMwZ3hhN2pqeE5nK25jbEJ3UHZ2TkRRSGs0Skhh?=
 =?utf-8?B?RkdlMWNXcXQ3N2pDUlhvbHIxR3VxTjJJNlc0QlVZUng5VHBVckZobktxb2FP?=
 =?utf-8?B?Z01lTlBwT3k5V3pVY0xrVkE3M0ZGMlFpYjFHNS9ud1ZTVnRGWHBQeHExL3I3?=
 =?utf-8?B?bzRDQURaZDhUTDZndFErZW9kbjUyckt1KzFmaFRkUzhDQ3FjakxNNzY4dURV?=
 =?utf-8?B?NHpoamJHYnpxaUtxQ2dQTFVYYitBdWk3K0I0QTNZNGFsZWhCUUo0Q2U5c2xz?=
 =?utf-8?B?cGtNeFBtejRqYU5tUDN4dy8waEdzbWJtV0tleDQ0bENPOVFCNDdQTW5BeXZV?=
 =?utf-8?B?aDhQZzNTcXVUMzhURnhNYW5VY25hRW9hUW5xaXQwZVNxQ1l3Nkl0Wjg5alU2?=
 =?utf-8?B?ZngyWnlucjFTSUVGR1hoY2dQSGo5ZW5SZktYU3h2eG91V1B1VU1lYVQvWmpm?=
 =?utf-8?B?RkQvQW81c1N6M3pYRG5kU1drZFZJN3lFN3pSTDBDOGtqZDhGZ3dPbm9NanND?=
 =?utf-8?B?b1BOQWFleUNtdnc4Sko3RUkzUHhUZW44ZVBsSWhza29qWXNKVUorVU1OTmVo?=
 =?utf-8?B?dmdFUzdUTHNwZGlpcWJmdHdKKzJkNHByMEhDc1NxTGJydXFrVld1QzZoc0ph?=
 =?utf-8?B?UGRkNjhHWTZ4OU1UelJZTncyMzArV25YYklTSjVFVExsZ1FKUFRub0t1VlZQ?=
 =?utf-8?B?b1EwTy9qS2MwV1o4OVpIZVJJMDEvUVc2QmF0UG43NlpWa2NYajBDSlhGd3VD?=
 =?utf-8?B?WjFNcVZ2aHk4UVZnQUdCK1hFcVNYaExSN1ZJbWVjaThDd25BSkhxTUwwU01a?=
 =?utf-8?B?MmdrOVNPcXY4YXpjVkcveExvZkNYRG1HditOcnVaREEydGlySml4cTdBdDJl?=
 =?utf-8?B?SUl5Y3hVc0RqRE9uRHkvLzN4L0JTY2xRdWVDVUF3dGJIQm1lbHBVeDVGamo4?=
 =?utf-8?B?VU1QNTd0Q0MzRk1SMWh6RnBKWThnRVdPYXdjeXpLUFVtMUFEZ2I2eWxlVExV?=
 =?utf-8?B?Nm16T1BtN05MRVlobjJwSzQ2NnBtTXVIUlhzeDFFSXN3L2s0RmMzbzg2WWRs?=
 =?utf-8?B?ZUkzMVlpcWdqZU15L1VVSzhYNnU3dEVZR0dtY244ckdIWFBlSjAxdG1aRlpr?=
 =?utf-8?B?MUtuc2U1WjdpdWw2M210TjBoTkNTNjY4VC9SbnBlVTVaSWdpb3VVdkV6Y3Y3?=
 =?utf-8?B?OHVuQnhHZHJDa3ZmNXhkWlRIRzh2YmMzdjVoQkZuWkFLV1UvdjI1cmJ1Q0tT?=
 =?utf-8?B?T21oRnptdjNDeHplTURscDV4VmRvb1BqRXpHN05PNERtb2xoRmRmcnp4Z053?=
 =?utf-8?B?Y2VCQlVFNDVJUk41VjdEOTcyUDVwTVRxQVlkaTkrWGFtb2VoSzBqVnV5RHY4?=
 =?utf-8?B?QXBZWjIvZ0hxRVBTMWp5b0cxc2RjV0hZUGJkMFYwQnZRbm5wYnRpRXg2R3BQ?=
 =?utf-8?B?VjVmVkwvbGNZem00UlpUUVRUTnJPS1dkUkVESjBQaUdNODM2ODlKMElUWTZL?=
 =?utf-8?B?OE0xelh1UHJiR2VTWFFXL2N0WCtVT1JJTm1TNElIQk45SXpiV0ZXSzlqMERm?=
 =?utf-8?B?QU9Pa2xJRmZWb0Ird3p1MXcwNll3TmpnUDVXUkJoNndlNDUxUU0rWlpheHBN?=
 =?utf-8?B?TndOU3YwSHExWFNKNWtwSFIvYThXbWxBMWZLLzFnMDJpaDJWbWtWeTkrQjhP?=
 =?utf-8?B?MkFGeUxXNitHbWNzdGZyc0NpcG5ScHluQ3NiYkVYOGVkSTFLbW1BWFQycXRk?=
 =?utf-8?B?R1BLcXllallHTlB3cm9JSEdwVWRZaVJvSnoyOEVkUlFLTjVETFM1cEF5Z2hv?=
 =?utf-8?B?ODdEV1p5cHUyR2pIbERRNTMvMm5aQzRPc2tNeTdrNE1GdTNuNHJqOTkvblYv?=
 =?utf-8?B?WFZkcFB3TFRBUFRPbTl4U212bW54NU5BMTBHWmFkaTJHdW55RWxtQzFvdWVB?=
 =?utf-8?B?RFVWMGQwQTNoRXFlTG5yeUloMnA1Wit0UnlQakdKZkMxVjRpaURSM2dISGpC?=
 =?utf-8?B?cjZPYzdHazBZaXBqSnhNbFEyZkFYVm5pWkdMMkl3cFkrdWlJZUhxbVhIdEhk?=
 =?utf-8?B?VXViZ2txWDA2eWJRQW04VmRONm5ZcXNmQnoxdHBDbHhHYTlPZk42c1gxaFVD?=
 =?utf-8?B?RmxRTVIxSHZjRzNidE9wSGUrTDQzSVdoUG4wTUF2TDZxVzhkQ1NaTHJvMm5j?=
 =?utf-8?B?aEhLNlpDeEIwMFdra3BNWHVkc084byt4R1VrRHRXd2dKZ2hnL3JBeEJGbEY0?=
 =?utf-8?Q?T5Nj+uk/zIdvSJOQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C8554A264778DC469B31DB4F1A305CC8@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR02MB7557.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d061086-88df-4969-8e24-08de46f2f502
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Dec 2025 15:57:23.9310
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BY4s7zPlH12Fb9B5QpHQNe7rv6qxKMjTEparue+IMOEAbl7zOA+STCwT2I/fqx9ku+uWaQ0YkXlxf6Ln5xicudLQ4MrNcRKzSR0lad8Gd44=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR02MB10551
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjI5MDE0NiBTYWx0ZWRfX/DtwSjTy2OGO
 07kgooAFbgxSz5sfW4nngaFDgMcMen3XsP+mBVJQtxYD7EBYNcC/6hcT7kHUS7kCj/EAuct525D
 RV5VbA9ZpWaNmE1x7cv8lv5nZBzYkfY7tC2pdMPyApnlHVQr5LeSkLNiXd2abiFaTCFeINjPXaE
 x9fcyXAp8qUUFOC7zZMOXXJUFZ7z0/etg2JKw+VHOKvgdKRVTtqPUsuqDGRtVYen57Zb8nNJqkE
 S5aPISQTILPZGIlE7UKx4CLI1IM0/+/nhDJL1bJWk0Dq6GmUZ1j5pYLuSFsB3cLjT4K+hBYSAT/
 dVqVfJo90Ba6y/zN9/IDlyp0t/h+JRbfqcHa/AFVNqmuveh+BVTntH7LeoHiy3PFivUTpEzQj+M
 O3jNm116zRLhmBs3yya2aQ50x/LsOBE8P5DhDOHuFtwiDKmI7idYnCtZGgMqjDn7yGZSanN1gTL
 ElmG3X6I/cFtBe6GqrA==
X-Proofpoint-GUID: PgQY6ng4nucgqh6yA-E1ji2gklxqRdF4
X-Authority-Analysis: v=2.4 cv=Fe46BZ+6 c=1 sm=1 tr=0 ts=6952a4e6 cx=c_pps
 a=5La41DunaOgqFQnkXytrUA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=JfrnYn6hAAAA:8 a=ijlThhBT1WYAvNy7muEA:9 a=QEXdDO2ut3YA:10
 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-ORIG-GUID: PgQY6ng4nucgqh6yA-E1ji2gklxqRdF4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-29_05,2025-12-29_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMjkgRGVjIDIwMjUsIGF0IDk6MDbigK9QTSwgRGF2aWQgV29vZGhvdXNlIDxkd213
MkBpbmZyYWRlYWQub3JnPiB3cm90ZToNCj4gDQo+IEFoLCBPSy4gU28gaW4gdGhlIGNhc2Ugb2Yg
aW4ta2VybmVsIEkvTyBBUElDLCBrdm1fbGFwaWNfYWR2ZXJ0aXNlX3N1cHByZXNzX2VvaV9icm9h
ZGNhc3QoKSBrdm1fbGFwaWNfcmVzcGVjdF9zdXBwcmVzc19lb2lfYnJvYWRjYXN0KCkgYXJlIHRo
ZSBzYW1lLiBJbiB0aGF0IGNhc2Ugd2UgY2FuIGNob29zZSB0aGUgb25lIHdoaWNoIGlzIGVhc2ll
ciB0byB1bmRlcnN0YW5kIGFuZCBkb2Vzbid0IG5lZWQgdGhlIHJlYWRlciB0byByZWZlciBiYWNr
IHRvIGFuIGVhcmxpZXIgY29tbWl0PyBJIGFjY2VwdCB5b3VyIGNvcnJlY3Rpb247IHRoZSBwYXRj
aCBpcyBjb3JyZWN0Lg0KPiANCj4gQnV0IEkgdGhpbmsgSSBzdGlsbCBwcmVmZXIgdGhlIGNoZWNr
IHRvIGJlIG9uIF9yZXNwZWN0XyBhcyBpdCdzIGNsZWFyZXIgdGhhdCBpdCdzIHBhcnQgb2YgdGhl
IG5ldyBiZWhhdmlvdXIgdGhhdCBpcyBvbmx5IGludHJvZHVjZWQgd2l0aCB0aGlzIHNlcmllcy4N
Cg0KDQpXZSBjYW4ndCB1c2UgYF9yZXNwZWN0X2AgaGVyZSBiZWNhdXNlIGluIFFVSVJLRUQgbW9k
ZSB3aXRoIGluLWtlcm5lbCBJUlFDSElQOg0KDQogIGFkdmVydGlzZSA9IGZhbHNlICAodmVyc2lv
biAweDExIGFkdmVydGlzZWQsIG5vIEVPSVIgcmVnaXN0ZXIpDQogIHJlc3BlY3QgICA9IHRydWUg
ICAobGVnYWN5IHF1aXJrOiBob25vciBTUElWIGJpdCBldmVuIGlmIG5vdCBhZHZlcnRpc2VkKQ0K
DQpXaGlsZSBpdCBpcyB0cnVlIHRoYXQgd2hlbiBTRU9JQiBpcyBub3QgYWR2ZXJ0aXNlZCwgIHRo
ZSBiaXQgc2hvdWxkIG5vdA0KYmUgcmVzcGVjdGVkLiBIb3dldmVyLCB0aGUgbGVnYWN5IEtWTSBp
bXBsZW1lbnRhdGlvbiBzdGlsbCByZXNwZWN0ZWQgdGhlDQpTUElWIGJpdCBpbiBrdm1faW9hcGlj
X3VwZGF0ZV9lb2lfb25lKCkgZXZlbiB3aGVuIG5vdCBhZHZlcnRpc2luZyBTRU9JQi4NCkkndmUg
cHJlc2VydmVkIHRoYXQgbGVnYWN5IGJlaGF2aW9yIGluIGBfcmVzcGVjdF9gIGZvciBRVUlSS0VE
IG1vZGUuDQoNCkkgdGhpbmsgdGhlIGxvZ2ljIGlzIHN0cmFpZ2h0Zm9yd2FyZDogaWYgd2UgYWR2
ZXJ0aXNlIFNFT0lCIHdoaWxlIHVzaW5nIGluLWtlcm5lbA0KSVJRQ0hJUCwgdXNlIEkvTyBBUElD
IHZlcnNpb24gMHgyMC4=

