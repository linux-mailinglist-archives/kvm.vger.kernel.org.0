Return-Path: <kvm+bounces-42473-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FC13A79052
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 15:53:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D477F3B4328
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 13:48:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 955A423BD08;
	Wed,  2 Apr 2025 13:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="TGZK9sS6";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="QbJcax3r"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1690237705;
	Wed,  2 Apr 2025 13:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743601635; cv=fail; b=fspLyiXIFBRfqYuZciTJV2AIOhYtUQLQwjPFhdfC7N5Ajr5ZGQcnw4twnnin4v8Wpm9XPR2Ir3odxuSirKykVuQqOU0bqaGiyE6hFOb4H07t5Vs/UMdRsSfq8gsGFmQbiImwNYYjjcryF2vEm9Mz3TD910miHRZidWbyPYF4dWk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743601635; c=relaxed/simple;
	bh=H2xiqjGcBkOiTWbQDW0MlxstX57KpMUKPoCyOc8gecM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=A8vMi3RIyzCNhuevkSKJ1z5qHey5GPiAGqfkQ1nwgJA1XCZjkWtwNFopNWc0x9ohPfHmz4RANvlVygVDyqKI5kOSKYrITRZYSDBHzqxf6ncbR2r1mIdpGn+Hb80VYcAzmIFjh9UkwsI2d+77IUw8EK+F8Nc/gai70idcwa5vOB0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=TGZK9sS6; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=QbJcax3r; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 532CcnlT025526;
	Wed, 2 Apr 2025 06:46:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=H2xiqjGcBkOiTWbQDW0MlxstX57KpMUKPoCyOc8ge
	cM=; b=TGZK9sS66fegnCyST9c/iwGeK5F24jfMe7PJdyqsr2ftAS+1Bp0SfJ6Nt
	UyeLh43LJ8Zf/sPihvJAzq8uNlbhTb06lPE9WXyWDD+dFrED8uw5vwqrSiNAHGQb
	G7f3B2/eGwOc6L6shVL0NnJ9gOHqrGTSBZ+Lb3/MARukuYaXdATTbY+MIseRE7K7
	sKN7sIZwT4q46WDR2YCg59i+vnlbQj8SEDxpKHeQK9bOfkgfz+m/D6FlWKUEsQ1+
	XAD4vYuPydzK0bVwosjw0WtJJZ4Hs5p/TNoYkv9posFVSkoYTahcRxFlFlzXLz64
	xbdD+yLta9JdDqb/a9rNu8TROxN5A==
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2040.outbound.protection.outlook.com [104.47.74.40])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 45rj5aaqpr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 02 Apr 2025 06:46:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OC+YMK88G6ncMvCwynPg7vCGEpDz207iXvqD9fzD/Ho24I+ch8H0kNYuSUNdGUsbd9GYuYcKQ0zAv36fwzo/sp5RjHsLd/3lugICPb5QZEVsgNYD5ajQ1DrB2A1JxvSZPGSvch49ud1wG1/IOwbVskUxHY1FcDimHZeNkk+SzSKPdU99uR3Utk3WX+zOF218Hz2ytq9Ej6ullQfRKaED1eJWpUaL/pP+cdi4K2Qdhwz9BpzM8VZ8+SgjU8/EVaFtHI+5wbRUbrP6UGvYYcmj1yh2QcI6uOvAAqYdmxdjgR+dO5fBi6RCGa4l+9zcfjxbbhfmdcHnUj+3iRMgqDRR4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H2xiqjGcBkOiTWbQDW0MlxstX57KpMUKPoCyOc8gecM=;
 b=HAf1mWHDxgezgKQBKWLQ8vwC0xwd7VIZe6Lti+lBLcFKHljq9MoQRIO2MOKDGML8NeeDFgDA2/KftIhT7Hd+onHCUzfATx2htrE2MntlkwbXzuTVS0GuFMNdutibNBx6dc9WLwrJ68eLofXeEH44AF32obp8N16S5DhmJlrOzTmH2z02jMUzQn7mDunsuIwBUhS4svut19B2Gg3S0BKoM2lm3DbhO+5I5QhxzeVxKVSX8gaIvY9596sz+CHuDbGL+bldrmZrD22fEs+0Weh15wkYuTymRU8dbZgXPsgw4cY+thhgtQSCOXbXtL8fh4HHCSbfTmNqjO8Nm9ItMzcgoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H2xiqjGcBkOiTWbQDW0MlxstX57KpMUKPoCyOc8gecM=;
 b=QbJcax3r3qnBHlrUCfyijZNcUP1ccrbUjGekAvPF5NV6nb2KkGdn2PrkV0BmqLib5AQbWE+XnOPDrQOAPkLojJG6yTIzLxMDgGJqYx+eqkFxBCiAxhz1SYLWL310s3T7P6POG42Iwor8Jmk1m6Tq/4uAzFhIJzFQQr4qMX1pf27h77EInqMf3JNEZNMY8cRk6hkyw2zclPjryZZr5ZSyBT3+T8NKYGv1SkqZTGeBpw9VeD6XvIrdrB5A+Ru4yzN4x++/ivnuVa/EutSFAn4rQC/A9eRWgAjRopiQSrY62TL9YLzT0vyVVij2Toz2eAzg5KFpVpXfsJYO5eH8Ev4JDQ==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by SA1PR02MB8397.namprd02.prod.outlook.com
 (2603:10b6:806:1f1::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8583.43; Wed, 2 Apr
 2025 13:46:31 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%4]) with mapi id 15.20.8534.048; Wed, 2 Apr 2025
 13:46:31 +0000
From: Jon Kohler <jon@nutanix.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen
	<dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "H. Peter
 Anvin" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Emanuele
 Giuseppe Esposito <eesposit@redhat.com>,
        Pawan Gupta
	<pawan.kumar.gupta@linux.intel.com>
Subject: Re: [PATCH] KVM: x86: Expose ARCH_CAP_FB_CLEAR when invulnerable to
 MDS
Thread-Topic: [PATCH] KVM: x86: Expose ARCH_CAP_FB_CLEAR when invulnerable to
 MDS
Thread-Index: AQHbor2IxxgP0CwV+ECMWY07obZlPrOQYuoAgAABiIA=
Date: Wed, 2 Apr 2025 13:46:31 +0000
Message-ID: <BA4DD4E6-D507-4BB9-8CC4-50043049DC86@nutanix.com>
References: <20250401044931.793203-1-jon@nutanix.com>
 <Z-09TLXNWv-msJ4O@google.com>
In-Reply-To: <Z-09TLXNWv-msJ4O@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.400.131.1.6)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV8PR02MB10287:EE_|SA1PR02MB8397:EE_
x-ms-office365-filtering-correlation-id: daf74e28-effd-44d4-6267-08dd71ecc686
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|1800799024|366016|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?M29zZVovYU1HdXhiMDVHUG9ZS3ZRNTdmWXh6cHBPdmdDdVZFdGgvcjdiZkxl?=
 =?utf-8?B?bUN6ZkxIZ2Q0YW40ZnlXVEpwd2FCSjNMMUtad3ZQREhUK2k4QkdFalBBTzFF?=
 =?utf-8?B?cnZ5WVBPVGg2RCtkdG9ud215ekZ3bUJBWGhLQm1Kc2Z2VDhPSkxLSXRwM0dN?=
 =?utf-8?B?VWFmWXdCTUl1T1hZNXpCeTZLSndmNDR3UUgxYU5tSDFUSml2R1VoeG9Ib0lq?=
 =?utf-8?B?aEFtbUpWSmJOT2JkS1Y3aCszR3ViQkE1U01KNlJLQmRUc2FraWFDbnlVazh6?=
 =?utf-8?B?UDVkUUw3aXpLMVZnMW5Zakg3cjZzVzZveWc0aGZLbDRIbUpSUGg5eFIwU0lv?=
 =?utf-8?B?SzlaTW13bGs0NENHRm1XaS9laDNMMmQyUkxQUGV3ekNDTW9JdGNST242TG15?=
 =?utf-8?B?MnZBb0I1YWtsZElOcXUwY2ZLYjVXd1pjeHpDRHR2TThJTlN0Z01UazFWc0pu?=
 =?utf-8?B?S214VEhJaC9DbGViLzRybldYNUsvNngzd0s1TFJYNk9MZXRNdStYdENpZHgz?=
 =?utf-8?B?WWJyYVBnWXR5aU00ajdGTndvZDhNQURydlJaVEtFY2c3YmNqWnRISEpOQnlZ?=
 =?utf-8?B?YnQ1QXZFRlp3bGc3QjNEWm5oTTRtdG1BUHV4NTZtaE9MbmE2S2VveGF6cVY1?=
 =?utf-8?B?S0FhalMvZ1Q4V09Rb0hldnE1NElMTFloL0RTcTVGcjdESXlpK3pWc2UrdWRV?=
 =?utf-8?B?N1dHdDd5bi9RSlRadHF5T0c5amE1NWFYS3JtRzI2d0tha1AydUNLWis5YlF4?=
 =?utf-8?B?ZmJhUTcvcVhEQ0dKSEVBTS8yRlRUN245NWM5ZFkvUHdKZE0waEJPd2p4dGwy?=
 =?utf-8?B?VFh1eXZTbmJ5REF4YlpRV0tkOFVnVklPSnNFZlJiSjQxamVHVDhQRCs5bC9C?=
 =?utf-8?B?cEVHYzAxV2dWblhWOGtxc25iTzdjSUMwSkdDeXFmSjhhcHJGemhNbzFTQVM3?=
 =?utf-8?B?T2xEU2M2cnVualQ2bFhIQ0FsbW1rcThFNzE1cHBxYlNNWk9vSjBzSlpuUHZV?=
 =?utf-8?B?bjdqekRJODFNM204SjdzTGxNUElneThTc0ljZmdJT2kzZDhmalpFbjlTTVFV?=
 =?utf-8?B?aFl6NS9tekRXdk9aUklpQXRLU3ZtSEd5NlVFS2htemtZT21rM25tQzJrRk5o?=
 =?utf-8?B?ZEZWYy8xNDZpZlg5RW9YbjYvVTNWckRFNlBmbWNvNEJ6UGJ6ekl4UUh5bzJi?=
 =?utf-8?B?NjlHemZtR21KeXNVYXVPNmx1ZmwvWkkrYWhjUEpvL0hDcmZEZWRwdUVuZ1Jy?=
 =?utf-8?B?UjZSZ2dlYnRkcmQ5R3lvMEUxbk9WbitzdEc1dXB6WE1TMmViaUVkdlpVbnpL?=
 =?utf-8?B?bmZPd1h0VmN2cE5qdmJsWWVhTUhMQ2tPZE1tYm1aWjlXc29zS0crbmpDWGUr?=
 =?utf-8?B?TzNscUtXaGdOLzB4RExxdzUzNnFyakY4aW9jVHVhZHJxK2xnWmJMdTgxdHhz?=
 =?utf-8?B?QzhxV0NXaEl3clRPTUJVdkkvMnM3QUNjNkVRWGl1Vk9renc0T3AxZzRmaEZ3?=
 =?utf-8?B?c1hQREZGTUVhZEN3NzMyL2VueGcvVWRNbVAzL3Q4eUhhL0lxMjBWaDl4MnVx?=
 =?utf-8?B?K1NYYkRFQlMvRVdGemRUL0JOellmTi9BMlcraGpNS2hFZFBxeG5UWk1LZmFD?=
 =?utf-8?B?SisxRFJBcTFqM1lZdklhQVpFM2loalIvbjlpSjdjOGJpYng2cTJuLzhRU1ZJ?=
 =?utf-8?B?OXZFVnpvUUd2eW5oaHRCbkZOdnZ5ZGxxQnFoQVBPMEVscGw1ckpkZnF3YUpm?=
 =?utf-8?B?bHFjTzJVT0RMNFZoNmtGSXZNUWFDeWhHeUhRRno3aFpPSDJha2FjdHMzOE4v?=
 =?utf-8?B?MWJ3RjhoR3VKeHNWOUNxdU5BclZoMlZZNVZVN1RhbHNldVpTbG44UHRmMGl3?=
 =?utf-8?B?N1E3ektSNnRCcEdoc012aTd4ZjFHVzZ4akVidU80bCtBOWI4OW9pS1hUbFpP?=
 =?utf-8?Q?t9zL4RD5gEonkVU4LAwIjL1zYqN64zsC?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(10070799003)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dFJmNkJOUzh2am1YWWJ5R0E1YVYrV1pzNnluRHB6VVIxU2l6ZXljU0J4cDRa?=
 =?utf-8?B?Lzhsd003c2NnTVFCV2tzUUcyUFFrZ0FWL2dyNTk5cEFYNS9zclAwZ1NjcUd6?=
 =?utf-8?B?Y0gzN1V2VnpVbHNLVW05Rm1TUzk0a2hVRWJLTmtMZUp2OGRrM1ExSnFaVExE?=
 =?utf-8?B?cENXYXBkUEZuRXlUejFwbTBLY2pnSUZyeWVtQ1N2VldjeUI4YWtBbmxaVUts?=
 =?utf-8?B?c0crcHpqTFgwODByQjRyQjRMbE05UEtROWt6anZtcUtDc1crUXdSVnNPR2Na?=
 =?utf-8?B?TVVXMTJDN21LZmlWVGlUd1lOekxOOWdBc1JES2RtbnhDdldwbDY2NHhwY0NE?=
 =?utf-8?B?Q2tJdnJKUW5ieHpmS2hEekc0ZFZSSkNRYWg5M0FoZVhRUlVHOS82Qk9MUUp4?=
 =?utf-8?B?WDIrdFY1YTMxUDJYTHlFelpoRnNPSWpBZGVMTUVJajZkK1lXR0NrRGhhdHNn?=
 =?utf-8?B?NW5qYWtZck93dWk4emNPMXUzQk5VTmpjeTdKOWxwS0VJV0V5Y2MyeGlLdVFS?=
 =?utf-8?B?UmdLeGQ3aXk1QU1NNVJUZllEN2t0ekljc2dEVUZ6aWV1WWNUMnFIYW1HRXps?=
 =?utf-8?B?R3RHbXY3VkVkL3hEQW91QzlaUGRsbWF1dCswMVhMSEdpT3YrdGtRaGNBWkFK?=
 =?utf-8?B?TFNrZzBlTVZIZGdBZ2pYTWZNd1o1NllxRU1Yb2lWdTJZd0NzK21XVEhzWk5F?=
 =?utf-8?B?Rkg4NTQwVllVYkpCWHpMRGJkeDN5YjE2aEwvYmNHWExRd0pJOTBtSko1c3Ar?=
 =?utf-8?B?SmtDU25YaEppanc3VXpZWmxHQStxZVdrRk5FajJLR1hacTEzbzVsc3lNcy96?=
 =?utf-8?B?ZE15ck4wRjFMbG1rTFY0MXlLbDBTb1lCTjlmOFExenluWnMzeFNQNExTM3k1?=
 =?utf-8?B?b3lHYzVuWTZIQkVsWGt3d1ZNUTdnMnZXdTgyWkRiMjVQS21TQUNXejhiL2I2?=
 =?utf-8?B?ZU1rQllkd2ZIejdXZm1iKzJFY1FvSWFRMlg4NmVNZ3hlUEVjRHhTTThjRVJh?=
 =?utf-8?B?U3RjMjBEdTUvRVk2Q3k4amt2MTZtUGtoS21YSENJNHZEL0NLM0ZQVWl5eXk2?=
 =?utf-8?B?NGhWRy9hUldZQ1lLcWtOVklHZTFwSFV0VXdFZXlTUVA3QjAxWHNvQWdDSVhm?=
 =?utf-8?B?YXhNYTVpbU9NZ0h6MDE5VHlXdWNlODNseHJyNVVVczdyaDc0alVCRm1adE5v?=
 =?utf-8?B?Q0VEV0lXMDlVNGpkTENjd1c2ZFBJd0hxVEFKNWtFUGhBcnpHUE5DK3lQVzB2?=
 =?utf-8?B?SXVXbVVtaHhBaHo5czdDMnFSUS80Z0hicXVMc1YvaHM4TVhHV1ExZU9aMDZ4?=
 =?utf-8?B?a0lZbFgyTk53WXRUcDNPVjBPSnVyYnVVelVvS0IzM1FnUUd6eE1iV05Bdktu?=
 =?utf-8?B?SjVLOFA3cXB0b2l0MXJDaCt1RGZpNy9wMitSTlZuUUlwa0FQTjJweG15Y3NT?=
 =?utf-8?B?QkdZY0VPdG0zQUE0ckg4RG0xZ3QyanJMV0hVYlBZcjkreFZhZ1J5dmNkMG5k?=
 =?utf-8?B?TWd6T0VBS01qSGwycDdKOWJJRkZSR0E4dHhCd29kTXpwWG1hRmh2T0k2S1dt?=
 =?utf-8?B?a3dKditMYXQ5OUd2eE9XaUR0cmRHV0tjL1FndkY2K01ONU5BcGhhdnNFMEhD?=
 =?utf-8?B?eEI5Z05taW5yZjdGNmI1dkh1c2Y4TmIzTHYydmJFUVhXN3BQYUxPVWg3V1ZQ?=
 =?utf-8?B?akJDZHdLc2ZGNG8wZUdtRjhobURFSUZpODhOYm81bUdDemF5MFI1K3lUWlNU?=
 =?utf-8?B?eVA5Ri9aTlRFZ2pmRkhDOHdhMDFJT3RGSmJGbjhuelNINlRFeVB1WTQ0NU5s?=
 =?utf-8?B?RTFrYUt3QTkvY0NYRncwNDk0Z21YcFI0TG1kK0RKL0dYbm50L0J6bjc2SlR2?=
 =?utf-8?B?N3BlMUZzRjRHMlRvL1ZaN2U0TFY0V2t4WHcyUEtSc3Z6MHFoSzg3aEV4WEFo?=
 =?utf-8?B?VzJwWnUwRVJKSWxrbWJsclh6Sm5YWnNpV3JpaWpGTzg1TER2d0VRUkpPNE9G?=
 =?utf-8?B?WHVZeGpnY0pWV2JEeVh6aXg1QlY3c2IyQzFSeUdLSEVUdGNwT3hpaWVTTTNG?=
 =?utf-8?B?SW9aejdMME9uRDIxYVhTN2txWEJnSzBpYk1pZXlHYnVOTFk1enVGTHRPNzlN?=
 =?utf-8?B?VDNkN0o2QkhQbDdUdzNmOTRNQVVZU0xYRWQ3VmZVZW8vNTFFcFhaMEgrek5t?=
 =?utf-8?B?ZHo1WnpkU1dpaTNqQjI4c2crTk9ZUjg3bm9FRmhuZVRQRkJoZjRoUGR0S2lI?=
 =?utf-8?B?R1NBaHAxUGlHanJXeG1jcmtKNUd3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <769B91123192A447B357C18E9F2E354A@namprd02.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: daf74e28-effd-44d4-6267-08dd71ecc686
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Apr 2025 13:46:31.3353
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wh3W6lQGcK5lQh8dJwRh2biwiqnVmJcG2La51COYet8nXBEkiOzklTvZP+v1dsox+UmqVzbE2G1vmiJMW53XRW0quGspweA5qF4TFSln+RY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR02MB8397
X-Authority-Analysis: v=2.4 cv=WbwMa1hX c=1 sm=1 tr=0 ts=67ed3fb9 cx=c_pps a=ZeveGGZnxkNpWlA7A6AaFA==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=XR8D0OoHHMoA:10 a=H5OGdu5hBBwA:10 a=0kUYKlekyDsA:10 a=1XWaLZrsAAAA:8 a=20KFwNOVAAAA:8 a=QyXUC8HyAAAA:8 a=64Cc0HZtAAAA:8 a=DzpXC62FNzYl_gwYTgQA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: bs-zcZvL6bMZ7kv_GqzbNz9w2yl4EeIS
X-Proofpoint-GUID: bs-zcZvL6bMZ7kv_GqzbNz9w2yl4EeIS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-02_05,2025-04-02_02,2024-11-22_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gQXByIDIsIDIwMjUsIGF0IDk6MzbigK9BTSwgU2VhbiBDaHJpc3RvcGhlcnNvbiA8
c2VhbmpjQGdvb2dsZS5jb20+IHdyb3RlOg0KPiANCj4gIS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS18DQo+ICBDQVVUSU9O
OiBFeHRlcm5hbCBFbWFpbA0KPiANCj4gfC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0hDQo+IA0KPiBPbiBNb24sIE1hciAz
MSwgMjAyNSwgSm9uIEtvaGxlciB3cm90ZToNCj4+IEV4cG9zZSBGQl9DTEVBUiBpbiBhcmNoX2Nh
cGFiaWxpdGllcyBmb3IgY2VydGFpbiBNRFMtaW52dWxuZXJhYmxlIGNhc2VzIA0KPj4gdG8gc3Vw
cG9ydCBsaXZlIG1pZ3JhdGlvbiBmcm9tIG9sZGVyIGhhcmR3YXJlIChlLmcuLCBDYXNjYWRlIExh
a2UsIEljZSANCj4+IExha2UpIHRvIG5ld2VyIGhhcmR3YXJlIChlLmcuLCBTYXBwaGlyZSBSYXBp
ZHMgb3IgaGlnaGVyKS4gVGhpcyBlbnN1cmVzIA0KPj4gY29tcGF0aWJpbGl0eSB3aGVuIHVzZXIg
c3BhY2UgaGFzIHByZXZpb3VzbHkgY29uZmlndXJlZCB2Q1BVcyB0byBzZWUgDQo+PiBGQl9DTEVB
UiAoQVJDSF9DQVBBQklMSVRJRVMgQml0IDE3KS4NCj4+IA0KPj4gTmV3ZXIgaGFyZHdhcmUgc2V0
cyB0aGUgZm9sbG93aW5nIGJpdHMgYnV0IGRvZXMgbm90IHNldCBGQl9DTEVBUiwgd2hpY2ggDQo+
PiBjYW4gcHJldmVudCB1c2VyIHNwYWNlIGZyb20gY29uZmlndXJpbmcgYSBtYXRjaGluZyBzZXR1
cDoNCj4gDQo+IEkgbG9va2VkIGF0IHRoaXMgYWdhaW4gcmlnaHQgYWZ0ZXIgUFVDSywgYW5kIEtW
TSBkb2VzIE5PVCBhY3R1YWxseSBwcmV2ZW50DQo+IHVzZXJzcGFjZSBmcm9tIG1hdGNoaW5nIHRo
ZSBvcmlnaW5hbCwgcHJlLVNQUiBjb25maWd1cmF0aW9uLiAgS1ZNIGVmZmVjdGl2ZWx5DQo+IHRy
ZWF0cyBBUkNIX0NBUEFCSUxJVElFUyBsaWtlIGEgQ1BVSUQgbGVhZiwgYW5kIGxldHMgdXNlcnNw
YWNlIHNob3ZlIGluIGFueQ0KPiB2YWx1ZS4gIEkuZS4gdXNlcnNwYWNlIGNhbiBzdGlsbCBtaWdy
YXRlK3N0dWZmIEZCX0NMRUFSIGlycmVzcGVjdGl2ZSBvZiBoYXJkd2FyZQ0KPiBzdXBwb3J0LCBh
bmQgdGh1cyB0aGVyZSBpcyBubyBuZWVkIGZvciBLVk0gdG8gbGllIHRvIHVzZXJzcGFjZS4NCj4g
DQo+IFNvIGluIGVmZmVjdCwgdGhpcyBpcyBhIHVzZXJzcGFjZSBwcm9ibGVtIHdoZXJlIGl0J3Mg
YmVpbmcgdG9vIGFnZ3Jlc3NpdmUgaW4gaXRzDQo+IHNhbml0eSBjaGVja3MuDQo+IA0KPiBGV0lX
LCBldmVuIGlmIEtWTSBkaWQgcmVqZWN0IHVuc3VwcG9ydGVkIEFSQ0hfQ0FQQUJJTElUSUVTIGJp
dHMsIEkgd291bGQgc3RpbGwNCj4gc2F5IHRoaXMgaXMgdXNlcnNwYWNlJ3MgcHJvYmxlbSB0byBz
b2x2ZS4gIEUuZy4gYnkgdXNpbmcgTVNSIGZpbHRlcmluZyB0bw0KPiBpbnRlcmNlcHQgYW5kIGVt
dWxhdGUgUkRNU1IoQVJDSF9DQVBBQklMSVRJRVMpIGluIHVzZXJzcGFjZS4NCg0KVGhhbmtzLCBT
ZWFuLCBJIGFwcHJlY2lhdGUgaXQuIEnigJlsbCBzZWUgd2hhdCBzb3J0IG9mIHRyb3VibGUgSSBj
YW4gZ2V0IGluIG9uIHRoZSB1c2VyDQpzcGFjZSBzaWRlIG9mIHRoZSBob3VzZSB3aXRoIHFlbXUg
dG8gc2VlIGlmIHRoZXJlIGlzIGEgY2xlYW4gd2F5IHRvIHNwZWNpYWwgY2FzZQ0KdGhpcy4NCg0K
Q2hlZXJzLCBKb24NCg0KPiANCj4+ICAgIEFSQ0hfQ0FQX01EU19OTw0KPj4gICAgQVJDSF9DQVBf
VEFBX05PDQo+PiAgICBBUkNIX0NBUF9QU0RQX05PDQo+PiAgICBBUkNIX0NBUF9GQlNEUF9OTw0K
Pj4gICAgQVJDSF9DQVBfU0JEUl9TU0RQX05PDQo+PiANCj4+IFRoaXMgY2hhbmdlIGhhcyBtaW5p
bWFsIGltcGFjdCwgYXMgdGhlc2UgYml0IGNvbWJpbmF0aW9ucyBhbHJlYWR5IG1hcmsgDQo+PiB0
aGUgaG9zdCBhcyBNTUlPIGltbXVuZSAodmlhIGFyY2hfY2FwX21taW9faW1tdW5lKCkpIGFuZCBz
ZXQgDQo+PiBkaXNhYmxlX2ZiX2NsZWFyIGluIHZteF91cGRhdGVfZmJfY2xlYXJfZGlzKCksIHJl
c3VsdGluZyBpbiBubyANCj4+IGFkZGl0aW9uYWwgb3ZlcmhlYWQuDQo+PiANCj4+IENjOiBFbWFu
dWVsZSBHaXVzZXBwZSBFc3Bvc2l0byA8ZWVzcG9zaXRAcmVkaGF0LmNvbT4NCj4+IENjOiBQYW9s
byBCb256aW5pIDxwYm9uemluaUByZWRoYXQuY29tPg0KPj4gQ2M6IFBhd2FuIEd1cHRhIDxwYXdh
bi5rdW1hci5ndXB0YUBsaW51eC5pbnRlbC5jb20+DQo+PiBTaWduZWQtb2ZmLWJ5OiBKb24gS29o
bGVyIDxqb25AbnV0YW5peC5jb20+DQo+PiANCj4+IC0tLQ0KPj4gYXJjaC94ODYva3ZtL3g4Ni5j
IHwgMTQgKysrKysrKysrKysrKysNCj4+IDEgZmlsZSBjaGFuZ2VkLCAxNCBpbnNlcnRpb25zKCsp
DQo+PiANCj4+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0veDg2LmMgYi9hcmNoL3g4Ni9rdm0v
eDg2LmMNCj4+IGluZGV4IGM4NDE4MTdhOTE0YS4uMmE0MzM3YWE3OGNkIDEwMDY0NA0KPj4gLS0t
IGEvYXJjaC94ODYva3ZtL3g4Ni5jDQo+PiArKysgYi9hcmNoL3g4Ni9rdm0veDg2LmMNCj4+IEBA
IC0xNjQxLDYgKzE2NDEsMjAgQEAgc3RhdGljIHU2NCBrdm1fZ2V0X2FyY2hfY2FwYWJpbGl0aWVz
KHZvaWQpDQo+PiBpZiAoIWJvb3RfY3B1X2hhc19idWcoWDg2X0JVR19HRFMpIHx8IGdkc191Y29k
ZV9taXRpZ2F0ZWQoKSkNCj4+IGRhdGEgfD0gQVJDSF9DQVBfR0RTX05POw0KPj4gDQo+PiArIC8q
DQo+PiArICogVXNlciBzcGFjZSBtaWdodCBzZXQgRkJfQ0xFQVIgd2hlbiBzdGFydGluZyBhIHZD
UFUgb24gYSBzeXN0ZW0NCj4+ICsgKiB0aGF0IGRvZXMgbm90IGVudW1lcmF0ZSBGQl9DTEVBUiBi
dXQgaXMgYWxzbyBpbnZ1bG5lcmFibGUgdG8NCj4+ICsgKiBvdGhlciB2YXJpb3VzIE1EUyByZWxh
dGVkIGJ1Z3MuIFRvIGFsbG93IGxpdmUgbWlncmF0aW9uIGZyb20NCj4+ICsgKiBob3N0cyB0aGF0
IGRvIGltcGxlbWVudCBGQl9DTEVBUiwgbGVhdmUgaXQgZW5hYmxlZC4NCj4+ICsgKi8NCj4+ICsg
aWYgKChkYXRhICYgQVJDSF9DQVBfTURTX05PKSAmJg0KPj4gKyAgICAoZGF0YSAmIEFSQ0hfQ0FQ
X1RBQV9OTykgJiYNCj4+ICsgICAgKGRhdGEgJiBBUkNIX0NBUF9QU0RQX05PKSAmJg0KPj4gKyAg
ICAoZGF0YSAmIEFSQ0hfQ0FQX0ZCU0RQX05PKSAmJg0KPj4gKyAgICAoZGF0YSAmIEFSQ0hfQ0FQ
X1NCRFJfU1NEUF9OTykpIHsNCj4+ICsgZGF0YSB8PSBBUkNIX0NBUF9GQl9DTEVBUjsNCj4+ICsg
fQ0KPj4gKw0KPj4gcmV0dXJuIGRhdGE7DQo+PiB9DQo+PiANCj4+IC0tIA0KPj4gMi40My4wDQo+
PiANCg0K

