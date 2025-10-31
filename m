Return-Path: <kvm+bounces-61722-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 9636CC26827
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 19:01:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id BED394E5B7F
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 18:01:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 880063502AB;
	Fri, 31 Oct 2025 18:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="ByfzLHHJ";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="bupcrjSJ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C74221577;
	Fri, 31 Oct 2025 18:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761933692; cv=fail; b=FqFCFqX9u8DG+e3gos/jK3JA0JIaNq7AZXFkK3qFIqqk0QQGSdmnPS6sOcQQ3VxX7EfH/7JBrliGAaPVz9PeO6s0STsce2xmz1ucLfwXbnoCia4+NbVUpTvABw72ULLz26i9QF8Hq9zezXkujUhnfdmN+oekwwvLDozvYyAOYzc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761933692; c=relaxed/simple;
	bh=vHxhAA//jcdm6H53RECP+eKs3dIxbcR4C/oSD2/7Wzk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BII9l2ZGpN0UnCebqRFuZsPX5TuXwvBd/JRQQbnCWZsFVeEczU6Y03mgZRrX1iCYewcdVyve0saBDrXT3yQRB+39ba/2r6CfiBR1X4yX74u26notabI+wXrLdZigL0Oy2oBV6rKCH5ui6cLs7KVgs0Uy0Wb6E0Mp+J1t0Fjt9II=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=ByfzLHHJ; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=bupcrjSJ; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59VGp5X43754131;
	Fri, 31 Oct 2025 10:58:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=vHxhAA//jcdm6H53RECP+eKs3dIxbcR4C/oSD2/7W
	zk=; b=ByfzLHHJejFvv/I8Ya4zwPV7IBHhwPEKii6VlGniiKorklf+b6Hv1A52m
	1/vyLxiBdn6hKAe013cC2Rq4E02tjLHqPrR8DnvL3cDTPPHmpfC1qU+BDJc/soLJ
	rjKXgCwPwuFegwHMu2v9wcR01bQeaEZeVeSnIM2FpPUcX7p9rBpPDSmCC3PctkhM
	55SMuoUzyVi7XLAApoaMYStsbVzsHDNwvlUJArSOrWjd0M6mjWufMhpUkCIwP1g0
	2snIL9yg+YEpImphR99XkCNwA+xMBxKeedHfpg+fZZjFBmCmSotHoJdJ9mSO3Aze
	4UZCNgg0Lv9poYvPJc01LRroNM2Qw==
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11022139.outbound.protection.outlook.com [40.107.209.139])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4a4fstjd3x-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 31 Oct 2025 10:58:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uX3t7ye+DtfljO8D3pya6BaHoPEhqaVXaagQ/wuSaMHpdbOzJa1wr5lHIcMhytdRhsli4IYLRc+o35d1IB+lPrSo8S8FmOz3uQs8cuZTEYf0zmmV+DsV+JtCT2Q19CdbkF9MpLgWj6gThjezaJrF+YirRbVBJHN6rh06qnlrkJpDd9FPQo8Rl/QNSUqKjrYJFD2/glBAUfOZeY0Eb8N/4eAOPNGt5sgjXeU24INYWs4qECZqVxoRisIwBiX3YCUnDDT3qtJxqPP2d6TQCKSnMHonrZziJcaG2znBq/HTUmAF1jAaRGGhiCbnWyLyV7UW4ay2GsQqgFlf20wcd+hg9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vHxhAA//jcdm6H53RECP+eKs3dIxbcR4C/oSD2/7Wzk=;
 b=STJs9KmJ+phynMklslO82lGAD6/CRxAZsv9xSNZqW94sNGxfl02fEAG6ZR7RhsdZyCUf6ralfgKNPaRCOWfYIiXFGO0EODjz+2dBEaVNmlTqiXytHQ1Lcw944I3zIDlwAjQ0qfYv+XG5YAaOGL/J4Fi2mFjQhbK7jO1of7BOg8zsTuo9y4orWQ7PanYLWEcLlPGLmYrOYuuj8kUHjNBXhaNSCiIqdFheoL5MJKgxnxBqKKDphy/0Tyxt/9Jqp8jl6Q7C6c85jNjPYb4LR4LjCiz0iff78Lrr9SAF47sBY1AeV5wDttjHD7doiRhgAyG4pg1N0hJi8XMZdNeuJ3Z8wQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vHxhAA//jcdm6H53RECP+eKs3dIxbcR4C/oSD2/7Wzk=;
 b=bupcrjSJVo+/3LShWJsIUaw3a4XnqJIGmaS/uTST3kCq+0p9fNhjeieotYp6fAB6TIfZxdxyt1UC7HGvd3F9Bm2tfKDrnPNnBsQt2SG5tbhMtBop0NwDMyrx9weul/wX2SqMeBMXzmVqQpssaEEeqNdnQ47lztPLx/cICmLsb6o6q+r2Mb4lYKEAGzmvP6+mSAsbw3Z3peT3Ue/MRbNeB0nur8ACwfUEEiF0qNyiv6P3jHCqyjluA//uEQMldvS4w+101a9uWaOMygzXyGTAr2XUB1eR8GVz4K/qzKaIa9bS+KLqoenGR40Agyz9ISmvOgZtxp57FOo2DPvqwfBpmg==
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18) by CH3PR02MB10382.namprd02.prod.outlook.com
 (2603:10b6:610:203::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.13; Fri, 31 Oct
 2025 17:58:30 +0000
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc]) by LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc%4]) with mapi id 15.20.9253.017; Fri, 31 Oct 2025
 17:58:30 +0000
From: Jon Kohler <jon@nutanix.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] KVM: x86: Load guest/host PKRU outside of the
 fastpath run loop
Thread-Topic: [PATCH 4/4] KVM: x86: Load guest/host PKRU outside of the
 fastpath run loop
Thread-Index: AQHcSe6Mk5n8WDTvbk+yt3fEzmuvoLTcitMA
Date: Fri, 31 Oct 2025 17:58:29 +0000
Message-ID: <0AA5A319-C4FC-4EEB-9317-BDC9E2E2E703@nutanix.com>
References: <20251030224246.3456492-1-seanjc@google.com>
 <20251030224246.3456492-5-seanjc@google.com>
In-Reply-To: <20251030224246.3456492-5-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.700.81)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV0PR02MB11133:EE_|CH3PR02MB10382:EE_
x-ms-office365-filtering-correlation-id: 448d97e7-cf26-4629-f9c8-08de18a719ea
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?QVBNVVpWQ25XY043aml5Q1JoTnR0eG5QN0VVK1pWTm1rTzdRZmtoRnYxZnRT?=
 =?utf-8?B?VE1JLy84S2F5ZktGN2J4QVFKMFVRS0NIOVcwNmZQdEVpTG9LcjZWdUVGOVhm?=
 =?utf-8?B?YTBiNndsYUdrWlpJU1ZvNURvRE4rakxmZCtrSllwb0pJMFh5Ynl3OE01elhB?=
 =?utf-8?B?ajdabHZSNUFYOW5jeXdmNGc0NDRzS0IwUmlMdUtIQnhaMElFS0MzMVhYUVhw?=
 =?utf-8?B?Wk1tUEN0aDFzb2NlejE3VDFQeEtLZm9IQXB3bElGbFRCWG1DMmZNd0FBVUlm?=
 =?utf-8?B?c0NjYlM4d3hDVXpyeWJwaHNWc2g3QnRTV2hLSFptOEFMMHF2WXdVNnpPY1Fa?=
 =?utf-8?B?c29ndGNYQVd2Z2FkdDJWc2NtbFhuQkJBSm4wclQxSVdPN2tSSjhuS2VWcERO?=
 =?utf-8?B?dzBzTGRXc0hXSS95Zmtvd0VTblhOTUJoa3FxVy9MeTJHVCs1WW4zQVpMdVBU?=
 =?utf-8?B?ZFRkaEEvOVJrNCtoWmtkdXhMZmRkbGFTczZRYzlqYmZmcGYweGZoZnIvcGY1?=
 =?utf-8?B?VjlSMUZndE52L29QVnVJMWpIcHFxK1JLSFJ3RUZkMGpWS1pHdFVCK3Y4NzJM?=
 =?utf-8?B?RnJEdU9WQ1lGeFpJZkhJbmg3QUV1RkFqSy9pbkJUSWpWWkdhQmZxY29DVS9V?=
 =?utf-8?B?MUgrT2krYnFBL2ZvQzJYMTA1NVQ1QWJ3dWMyaHpyMGJhaEhZSHJuSHM1NVRz?=
 =?utf-8?B?bjdNK3JIZW1NTE1MaXNpM203THVWSGhzenVLL2JtNnorbDd2ZzVaOHQvVWR1?=
 =?utf-8?B?ZitjZUgvbTlkLzBuNnhnbGVJRUpLQm5xWXVPU1BJaG9ENWJpVzN4cHN4QnN3?=
 =?utf-8?B?SjNFNkg5TE8xblhsVGFFd1JkZG1jOXRYQUpYaE9FYmhkaVpOSjhWdlFOdVEr?=
 =?utf-8?B?QWZqeEVPUHBaeTdPa3pSY1YyNGFaMU1wSVJBRWR5K1pNaThVcEkyUEtoeCtZ?=
 =?utf-8?B?bm9HdW1zM0UrTGJqcGE4a091ODJZdXJNWXRnUk1XNytBWlhUeXBwWkVMZGha?=
 =?utf-8?B?SkxXcG90OG1sL1dmcXdBUUxLZXhrR1VhRDI1bFd1YzMvbCt1UEZ5M05nRnVF?=
 =?utf-8?B?bkF2M1YvVUgyMFNzdWdIdE14WW9lTzRqMUVFY2JaVWhtdUZtVHMzd2E3aU55?=
 =?utf-8?B?MEVyelBFMzdWdGloemFmbjUrM2Yxd1ZaZk0zY29uUVUrUEtRbk9ocnFQSzhS?=
 =?utf-8?B?Z2tNZE9kYnBuV0x4RUtVR0VabzA3MFRYbG5FN0Jadm9iWGJwYVkveUlqS3hY?=
 =?utf-8?B?clVNY0U2STdqMUpGUXlvZ0RUekZ1NWZady81bUptREppUUJYS0xyY3YvNm45?=
 =?utf-8?B?MDU5N2F4dUhGd3JMNzNjSGdVWEY4dk96ZWZPL1hyR0pGSFcrd2NTc3gvVUpi?=
 =?utf-8?B?Wmd1Qis3WmZXbFZTYks5VnMwcVl5OWViRnhaREo3bDYzazFlN2xZYnArcjdN?=
 =?utf-8?B?TVBBSFJCcElma1BjejhVYXlJaHBZRHgzM1ZnbGVpalE3YWZRQW1uaFBySHRr?=
 =?utf-8?B?L3BMYnZnNFVJSlE4dXJ4dmwyUnRPVHN2aFQvdEpxcUJ5UEt1R0RqSWlMMGI2?=
 =?utf-8?B?Z2JPNVdMRzdGbEt0ZU1tckNBTUVLblNiOFM1OFZnV1dlNzh0SUJMZDhTQ0pZ?=
 =?utf-8?B?L0VwenZJcVh5bitQOUhIdFdEd1R4UkFhdVVNOTM2VldGZHdDUS9jemNLSS91?=
 =?utf-8?B?bkZoUURqNFE4S1FxVDNtWGFtanlPV3dkc2RSRXVIRzNncmFPNG0zdGs5MzNQ?=
 =?utf-8?B?NVEvNTZQdzI3NnJ6YVVvV2dVWE12Um1rSmVwMlJPM01nRVFNMlpYaEtzSVpx?=
 =?utf-8?B?V0VrRjBuYkJpVk44eExSaGRic2kwbDVCWEQ2cDFXcUp6UElMVW5IOEMycGY5?=
 =?utf-8?B?QUhwRXZYSnJWY0orK0VkWGMzTkw2MCtkYitabFlCcGlxb2VtWTVpMkh4QlNQ?=
 =?utf-8?B?T0xuMXVPMlozU29yYVdvRWlVaWtyMUtDbXVkTWdjbDQzZGpRbFBpZEtzK2Nn?=
 =?utf-8?B?RGl5SndYUXpQeFlhMWFPUVhuWHNMY2szK2dsSG1RWDlTcE01djhQaWpuY2k3?=
 =?utf-8?Q?dLTz5x?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0PR02MB11133.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?K1hFQ3JOMGREcGVzK25uc0p5eXFaN3BQYnVnUlJERmI3bHY1SFdmam9yQXg3?=
 =?utf-8?B?RWJ1U3A5WkxiNTBLWW13UHZyd0dNQkRNeWNYK2J0ekFkY3dCMzdHaGZvdEZQ?=
 =?utf-8?B?cngzQ2FyMVFGZm56dG1BVnNYVWUxWWJTblRsN3lEQ2gzdjd0NjhpcXZ4OVF3?=
 =?utf-8?B?SFIySVFxVWJjNjN4bEFuZmVxc2svcWdMN29oQVBvTTdBOHU5RUNxZlZOanhD?=
 =?utf-8?B?R1RkMEpMYkt6eU5RQ3lzaC8xRDB6LzRHbGZCVXFMQkNIU05VTWF3b1BiM0Yv?=
 =?utf-8?B?SlgwSE12dlg0NEdjRTdyREpUam9KZVNaOXlSTU1xWW8ra3VYQ2ZMMVBuQ2sw?=
 =?utf-8?B?aVVWRDJkbDc0T0NqZmNkSCtacTVzbWkzeDZSK3B1Rm5IcXgvOWc4L292M0cw?=
 =?utf-8?B?WUxURlU2dFlrR1FZdWYxYUxUOXBJdlNhb1ZiNGdrRDZHUzRvLzVTNFFmb3l0?=
 =?utf-8?B?YUh2OE9BQmNXdGVjOUkwdVJab1prM1AxbWIyS1dPODB1U09PWTlFamxkaFBs?=
 =?utf-8?B?dmpDemJpZy9BUGlralgrRms1TW54U05tRzVoL2kwajFKR1NuNS9pTngyM3NJ?=
 =?utf-8?B?THdZdVp4dFdodit1MjJjY0NmK1RjbHJjdktia1IxVS82QkpINXg4QVlDRWJl?=
 =?utf-8?B?SHJMS3FvMWpEdzJua0tOY1RmMkZYaHVOYWNjL2FGSmQzQjJlV1JrMUtzZmtT?=
 =?utf-8?B?UnFXaXBpblJyRmQ0L2RBQktScjVNRlBNTHJ6YlEralprMDZQTEJZTVkyZ3Bw?=
 =?utf-8?B?d0YrNHc3OTZMaUI2OEJ5MDg1YXA5SlhGcjdLVDE0NWVNT3haUU1IZ0F2enlk?=
 =?utf-8?B?TFkrQVRKQkllbzhWT1NLNFRkUnZUTTYwdXJaVG4yYnR2ZGhCSUVvVEowT1h6?=
 =?utf-8?B?ekRDMU1PL29qeUllRlRxY1c4dnlHOFBOYkNZM255dHAwWEhFNWVucTlTQ3or?=
 =?utf-8?B?MzB6NlZsK01xUjhob3drWEppUjlCRUJDd3lWaE1veUlrZk9SZml1L3NqNExv?=
 =?utf-8?B?d29CM0hPdTBEaEdsYnZJMk9Gb1JmVHBxRlpZclRaemtidFBVTENyWWVNanY0?=
 =?utf-8?B?ZGNiV1g5SWlVYWpyNnZ2QjBkTWFVZzdlNjg2K0VpblZHQTJZanhTZHlXRzZP?=
 =?utf-8?B?dW02ajZvODFNRU9raEN3WUtzKzdUa3VOQkpwd3ZlYjFqYk85UGpBMyt6THVT?=
 =?utf-8?B?U0FlQ2JjQXc4cFVBbDUxNmpnWTB6VHhubkFRcm41dGMwYVBkZjBuQ3dFcVda?=
 =?utf-8?B?bEZackNiZUtJa21ZSWlsRWJyaEY2azZqbFM3YUVoUnhrajlqV3NuN1JYOHM5?=
 =?utf-8?B?QWRQOXpmUWNiZGZFRzMyRGV2NWxsQUFRZEJjTm5tamMyM0JqU21VTkF5SXor?=
 =?utf-8?B?T0lRVjF0NkRPOWNDajdmTWFCWnZWcU9idjFzWm1PVmRWaEVwZWVCN1JIanZB?=
 =?utf-8?B?RUtOM2JHS2N3QnUzMkRMbFFmSE1Fbm51cldvaHpPbkpib3JwWEt3Sm9GenFT?=
 =?utf-8?B?N1FDZzQxOTZ2dHk5dEZJWmw2MlNqTW5TRXVhL1JFY1hJYTNVMHFWeERuMURr?=
 =?utf-8?B?bnM3MTY1ZlE3Y2FMK3ZWTFBCUTVBczViUDRxak9kSXpNWldFRFdrR0dUYll3?=
 =?utf-8?B?c0svYUduZGY5WDZNekF2ZHRhMng1aDVTNWV2Vk8yUENBRVh4V0Zma3JlL09B?=
 =?utf-8?B?ditIYndzRkhpYVE4ZEt2SlVJcTB5Rk1RaUhKWitlSzZnTTRDa3F4ZDd2NmdR?=
 =?utf-8?B?ZGtTbzNjRWJadEpTSjZ5TnY5MUhXN0daRHRrbURNaFJCTUFKUFVUR3hDcUV6?=
 =?utf-8?B?ZmFHQUhRekk4RmJuTk9RUDJ0T0orSGNkMnl6N3d4eFduaTZXaThiKzdsd3VU?=
 =?utf-8?B?b2pUZ1JzYjZJdmttTFljNUw4enN2YUhBTEl2UjZmSVNLdTc1VEpuQzRvM2Ft?=
 =?utf-8?B?QVIwZklSQk5RcmJYT1djTFpXQmpnb294byszaVFkL2pnUVBya2lyQXc2M0Nq?=
 =?utf-8?B?Rk1PMVAyNVRtRUFKVWlBTWNQYXVVb0xFOHFrVEZMQkU3aFEwVkpQV3JWQ1BF?=
 =?utf-8?B?b083U1FycWFXMHBuOXF4T2ZYV290bWR6VE0vd2tQeEtER0h2UUdQVVA3NnRE?=
 =?utf-8?B?VTF1Q0wrSWd2bHRDZnNWSmF1NkhoM0pSaGhVamlBUHFIVDZkcUwySlRieUlX?=
 =?utf-8?B?T1VFM2VGUGpoYzM0Q091aHpIWWZQWEJqWDZxUHFmMHI2TTBVQ1JJQmdlUmtV?=
 =?utf-8?B?VUFxK0FpWnBGRnZaV28vaXFpQzRnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4030234A060F304D952535767F40EB1E@namprd02.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 448d97e7-cf26-4629-f9c8-08de18a719ea
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2025 17:58:29.9771
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qd0oktnss6XVUNVpBCTJPkAK1dt6NfFrS37foswtAoFwlUF4ENnC7DQeE0DiPTF4Dc8z9kOvjxIfFUaxlWmMcH88ZpGlvD8ZJTsDl5oa7jw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR02MB10382
X-Proofpoint-ORIG-GUID: xikkMJmER3cJe642Ng49bdDt1bS5_vB2
X-Proofpoint-GUID: xikkMJmER3cJe642Ng49bdDt1bS5_vB2
X-Authority-Analysis: v=2.4 cv=N8Yk1m9B c=1 sm=1 tr=0 ts=6904f8c8 cx=c_pps
 a=A91p8pFdSY8iZOlwlHItIA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=1XWaLZrsAAAA:8 a=Bcie3u8nvEPerFoYjosA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDMxMDE2MSBTYWx0ZWRfX2jlj0NAxj+0u
 EnL81GOlAOFroAM5lrM5qyvVm7KsS2RMoXIfcCdPoyPQmcyDzxaTl8Z7CPqLv1KYgdk+ogWgb2K
 TwXMlvRcDsOx09ocEkMYqlRS4UKQMRUw4d6GfhmeKLNfi1VHCeiy+AzMCiNj/WcJVoPzCfn89GM
 6TeY/REjzjJ1dwtVCaUc/H460eCvmXxe1/GkIExH/NZssdDAXj5hHSJ7zMC3GDSSQs3rOE9VDbf
 yN7MoQUC1gg4zI90VnmdWZPHz7bNc9+25P9QkSusLyoZt3c2KaZyp2SecPrSkNOZ1UEBHKR7u74
 vC/W1dAckUWUcWMVNNR8a9KTLvKIR/hIAzd8gAUaAi74mmV+fuKYSs2c3QZXDAglFkXMWTDLGTP
 gEBgJdyyIZVrEhu7vQwhfMcG3rREzw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-10-31_06,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gT2N0IDMwLCAyMDI1LCBhdCA2OjQy4oCvUE0sIFNlYW4gQ2hyaXN0b3BoZXJzb24g
PHNlYW5qY0Bnb29nbGUuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElP
TjogRXh0ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gTW92ZSBLVk0ncyBz
d2FwcGluZyBvZiBQS1JVIG91dHNpZGUgb2YgdGhlIGZhc3RwYXRoIGxvb3AsIGFzIHRoZXJlIGlz
IG5vDQo+IEtWTSBjb2RlIGFueXdoZXJlIGluIHRoZSBmYXN0cGF0aCB0aGF0IGFjY2Vzc2VzIGd1
ZXN0L3VzZXJzcGFjZSBtZW1vcnksDQo+IGkuZS4gdGhhdCBjYW4gY29uc3VtZSBwcm90ZWN0aW9u
IGtleXMuDQo+IA0KPiBBcyBkb2N1bWVudGVkIGJ5IGNvbW1pdCAxYmUwZTYxYzFmMjUgKCJLVk0s
IHBrZXlzOiBzYXZlL3Jlc3RvcmUgUEtSVSB3aGVuDQo+IGd1ZXN0L2hvc3Qgc3dpdGNoZXMiKSwg
S1ZNIGp1c3QgbmVlZHMgdG8gZW5zdXJlIHRoZSBob3N0J3MgUEtSVSBpcyBsb2FkZWQNCj4gd2hl
biBLVk0gKG9yIHRoZSBrZXJuZWwgYXQtbGFyZ2UpIG1heSBhY2Nlc3MgdXNlcnNwYWNlIG1lbW9y
eS4gIEFuZCBhdCB0aGUNCj4gdGltZSBvZiBjb21taXQgMWJlMGU2MWMxZjI1LCBLVk0gZGlkbid0
IGhhdmUgYSBmYXN0cGF0aCwgYW5kIFBLVSB3YXMNCj4gc3RyaWN0bHkgY29udGFpbmVkIHRvIFZN
WCwgaS5lLiB0aGVyZSB3YXMgbm8gcmVhc29uIHRvIHN3YXAgUEtSVSBvdXRzaWRlDQo+IG9mIHZt
eF92Y3B1X3J1bigpLg0KPiANCj4gT3ZlciB0aW1lLCB0aGUgIm5lZWQiIHRvIHN3YXAgUEtSVSBj
bG9zZSB0byBWTS1FbnRlciB3YXMgbGlrZWx5IGZhbHNlbHkNCj4gc29saWRpZmllZCBieSB0aGUg
YXNzb2NpYXRpb24gd2l0aCBYRkVBVFVSRXMgaW4gY29tbWl0IDM3NDg2MTM1ZDNhNw0KPiAoIktW
TTogeDg2OiBGaXggcGtydSBzYXZlL3Jlc3RvcmUgd2hlbiBndWVzdCBDUjQuUEtFPTAsIG1vdmUg
aXQgdG8geDg2LmMiKSwNCj4gYW5kIFhGRUFUVVJFIHN3YXBwaW5nIHdhcyBpbiB0dXJuIG1vdmVk
IGNsb3NlIHRvIFZNLUVudGVyL1ZNLUV4aXQgYXMgYQ0KPiBLVk0gaGFjay1hLWZpeCB1dGlvbiBm
b3IgYW4gI01DIGhhbmRsZXIgYnVnIGJ5IGNvbW1pdCAxODExZDk3OWM3MTYNCj4gKCJ4ODYva3Zt
OiBtb3ZlIGt2bV9sb2FkL3B1dF9ndWVzdF94Y3IwIGludG8gYXRvbWljIGNvbnRleHQiKS4NCj4g
DQo+IERlZmVycmluZyB0aGUgUEtSVSBsb2FkcyBzaGF2ZXMgfjQwIGN5Y2xlcyBvZmYgdGhlIGZh
c3RwYXRoIGZvciBJbnRlbCwNCj4gYW5kIH42MCBjeWNsZXMgZm9yIEFNRC4gIEUuZy4gdXNpbmcg
SU5WRCBpbiBLVk0tVW5pdC1UZXN0J3Mgdm1leGl0LmMsDQo+IHdpdGggZXh0cmEgaGFja3MgdG8g
ZW5hYmxlIENSNC5QS0UgYW5kIFBLUlU9KC0xdSAmIH4weDMpLCBsYXRlbmN5IG51bWJlcnMNCj4g
Zm9yIEFNRCBUdXJpbiBnbyBmcm9tIH4xNTYwID0+IH4xNTAwLCBhbmQgZm9yIEludGVsIEVtZXJh
bGQgUmFwaWRzLCBnbw0KPiBmcm9tIH44MTAgPT4gfjc3MC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6
IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPg0KPiAtLS0NCj4gYXJjaC94
ODYva3ZtL3N2bS9zdm0uYyB8ICAyIC0tDQo+IGFyY2gveDg2L2t2bS92bXgvdm14LmMgfCAgNCAt
LS0tDQo+IGFyY2gveDg2L2t2bS94ODYuYyAgICAgfCAxNCArKysrKysrKysrLS0tLQ0KPiBhcmNo
L3g4Ni9rdm0veDg2LmggICAgIHwgIDIgLS0NCj4gNCBmaWxlcyBjaGFuZ2VkLCAxMCBpbnNlcnRp
b25zKCspLCAxMiBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0v
c3ZtL3N2bS5jIGIvYXJjaC94ODYva3ZtL3N2bS9zdm0uYw0KPiBpbmRleCBlOGIxNThmNzNjNzku
LmUxZmI4NTNjMjYzYyAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYva3ZtL3N2bS9zdm0uYw0KPiAr
KysgYi9hcmNoL3g4Ni9rdm0vc3ZtL3N2bS5jDQo+IEBAIC00MjYwLDcgKzQyNjAsNiBAQCBzdGF0
aWMgX19ub19rY3NhbiBmYXN0cGF0aF90IHN2bV92Y3B1X3J1bihzdHJ1Y3Qga3ZtX3ZjcHUgKnZj
cHUsIHU2NCBydW5fZmxhZ3MpDQo+IHN2bV9zZXRfZHI2KHZjcHUsIERSNl9BQ1RJVkVfTE9XKTsN
Cj4gDQo+IGNsZ2koKTsNCj4gLSBrdm1fbG9hZF9ndWVzdF94c2F2ZV9zdGF0ZSh2Y3B1KTsNCj4g
DQo+IC8qDQo+ICogSGFyZHdhcmUgb25seSBjb250ZXh0IHN3aXRjaGVzIERFQlVHQ1RMIGlmIExC
UiB2aXJ0dWFsaXphdGlvbiBpcw0KPiBAQCAtNDMwMyw3ICs0MzAyLDYgQEAgc3RhdGljIF9fbm9f
a2NzYW4gZmFzdHBhdGhfdCBzdm1fdmNwdV9ydW4oc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCB1NjQg
cnVuX2ZsYWdzKQ0KPiAgICB2Y3B1LT5hcmNoLmhvc3RfZGVidWdjdGwgIT0gc3ZtLT52bWNiLT5z
YXZlLmRiZ2N0bCkNCj4gdXBkYXRlX2RlYnVnY3RsbXNyKHZjcHUtPmFyY2guaG9zdF9kZWJ1Z2N0
bCk7DQo+IA0KPiAtIGt2bV9sb2FkX2hvc3RfeHNhdmVfc3RhdGUodmNwdSk7DQo+IHN0Z2koKTsN
Cj4gDQo+IC8qIEFueSBwZW5kaW5nIE5NSSB3aWxsIGhhcHBlbiBoZXJlICovDQo+IGRpZmYgLS1n
aXQgYS9hcmNoL3g4Ni9rdm0vdm14L3ZteC5jIGIvYXJjaC94ODYva3ZtL3ZteC92bXguYw0KPiBp
bmRleCAxMjNkYWU4Y2Y0NmIuLjU1ZDYzN2NlYTg0YSAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYv
a3ZtL3ZteC92bXguYw0KPiArKysgYi9hcmNoL3g4Ni9rdm0vdm14L3ZteC5jDQo+IEBAIC03NDY1
LDggKzc0NjUsNiBAQCBmYXN0cGF0aF90IHZteF92Y3B1X3J1bihzdHJ1Y3Qga3ZtX3ZjcHUgKnZj
cHUsIHU2NCBydW5fZmxhZ3MpDQo+IGlmICh2Y3B1LT5ndWVzdF9kZWJ1ZyAmIEtWTV9HVUVTVERC
R19TSU5HTEVTVEVQKQ0KPiB2bXhfc2V0X2ludGVycnVwdF9zaGFkb3codmNwdSwgMCk7DQo+IA0K
PiAtIGt2bV9sb2FkX2d1ZXN0X3hzYXZlX3N0YXRlKHZjcHUpOw0KPiAtDQo+IHB0X2d1ZXN0X2Vu
dGVyKHZteCk7DQo+IA0KPiBhdG9taWNfc3dpdGNoX3BlcmZfbXNycyh2bXgpOw0KPiBAQCAtNzUx
MCw4ICs3NTA4LDYgQEAgZmFzdHBhdGhfdCB2bXhfdmNwdV9ydW4oc3RydWN0IGt2bV92Y3B1ICp2
Y3B1LCB1NjQgcnVuX2ZsYWdzKQ0KPiANCj4gcHRfZ3Vlc3RfZXhpdCh2bXgpOw0KPiANCj4gLSBr
dm1fbG9hZF9ob3N0X3hzYXZlX3N0YXRlKHZjcHUpOw0KPiAtDQo+IGlmIChpc19ndWVzdF9tb2Rl
KHZjcHUpKSB7DQo+IC8qDQo+ICogVHJhY2sgVk1MQVVOQ0gvVk1SRVNVTUUgdGhhdCBoYXZlIG1h
ZGUgcGFzdCBndWVzdCBzdGF0ZQ0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3g4Ni5jIGIv
YXJjaC94ODYva3ZtL3g4Ni5jDQo+IGluZGV4IGI1YzI4NzllMzMzMC4uNjkyNDAwNmYwNzk2IDEw
MDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9rdm0veDg2LmMNCj4gKysrIGIvYXJjaC94ODYva3ZtL3g4
Ni5jDQo+IEBAIC0xMjMzLDcgKzEyMzMsNyBAQCBzdGF0aWMgdm9pZCBrdm1fbG9hZF9ob3N0X3hm
ZWF0dXJlcyhzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+IH0NCj4gfQ0KPiANCj4gLXZvaWQga3Zt
X2xvYWRfZ3Vlc3RfeHNhdmVfc3RhdGUoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0KPiArc3RhdGlj
IHZvaWQga3ZtX2xvYWRfZ3Vlc3RfcGtydShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+IHsNCj4g
aWYgKHZjcHUtPmFyY2guZ3Vlc3Rfc3RhdGVfcHJvdGVjdGVkKQ0KPiByZXR1cm47DQo+IEBAIC0x
MjQ0LDkgKzEyNDQsOCBAQCB2b2lkIGt2bV9sb2FkX2d1ZXN0X3hzYXZlX3N0YXRlKHN0cnVjdCBr
dm1fdmNwdSAqdmNwdSkNCj4gICAgIGt2bV9pc19jcjRfYml0X3NldCh2Y3B1LCBYODZfQ1I0X1BL
RSkpKQ0KPiB3cnBrcnUodmNwdS0+YXJjaC5wa3J1KTsNCj4gfQ0KPiAtRVhQT1JUX1NZTUJPTF9G
T1JfS1ZNX0lOVEVSTkFMKGt2bV9sb2FkX2d1ZXN0X3hzYXZlX3N0YXRlKTsNCj4gDQo+IC12b2lk
IGt2bV9sb2FkX2hvc3RfeHNhdmVfc3RhdGUoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0KPiArc3Rh
dGljIHZvaWQga3ZtX2xvYWRfaG9zdF9wa3J1KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkNCj4gew0K
PiBpZiAodmNwdS0+YXJjaC5ndWVzdF9zdGF0ZV9wcm90ZWN0ZWQpDQo+IHJldHVybjsNCj4gQEAg
LTEyNTksNyArMTI1OCw2IEBAIHZvaWQga3ZtX2xvYWRfaG9zdF94c2F2ZV9zdGF0ZShzdHJ1Y3Qg
a3ZtX3ZjcHUgKnZjcHUpDQo+IHdycGtydSh2Y3B1LT5hcmNoLmhvc3RfcGtydSk7DQo+IH0NCj4g
fQ0KPiAtRVhQT1JUX1NZTUJPTF9GT1JfS1ZNX0lOVEVSTkFMKGt2bV9sb2FkX2hvc3RfeHNhdmVf
c3RhdGUpOw0KPiANCj4gI2lmZGVmIENPTkZJR19YODZfNjQNCj4gc3RhdGljIGlubGluZSB1NjQg
a3ZtX2d1ZXN0X3N1cHBvcnRlZF94ZmQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0KPiBAQCAtMTEz
MzEsNiArMTEzMjksMTIgQEAgc3RhdGljIGludCB2Y3B1X2VudGVyX2d1ZXN0KHN0cnVjdCBrdm1f
dmNwdSAqdmNwdSkNCj4gDQo+IGd1ZXN0X3RpbWluZ19lbnRlcl9pcnFvZmYoKTsNCj4gDQo+ICsg
LyoNCj4gKyAqIFN3YXAgUEtSVSB3aXRoIGhhcmR3YXJlIGJyZWFrcG9pbnRzIGRpc2FibGVkIHRv
IG1pbmltaXplIHRoZSBudW1iZXINCj4gKyAqIG9mIGZsb3dzIHdoZXJlIG5vbi1LVk0gY29kZSBj
YW4gcnVuIHdpdGggZ3Vlc3Qgc3RhdGUgbG9hZGVkLg0KPiArICovDQo+ICsga3ZtX2xvYWRfZ3Vl
c3RfcGtydSh2Y3B1KTsNCj4gKw0KDQpJIHdhcyBtb2NraW5nIHRoaXMgdXAgYWZ0ZXIgUFVDSywg
YW5kIHdlbnQgZG93biBhIHNpbWlsYXItaXNoIHBhdGgsIGJ1dCB3YXMNCnRoaW5raW5nIGl0IG1p
Z2h0IGJlIGludGVyZXN0aW5nIHRvIGhhdmUgYW4geDg2IG9wIGNhbGxlZCBzb21ldGhpbmcgdG8g
dGhlIGVmZmVjdCBvZg0K4oCccHJlcGFyZV9zd2l0Y2hfdG9fZ3Vlc3RfaXJxb2Zm4oCdIGFuZCDi
gJxwcmVwYXJlX3N3aXRjaF90b19ob3N0X2lycW9mZuKAnSwgd2hpY2gNCm1pZ2h0IG1ha2UgZm9y
IGEgcGxhY2UgdG8gbmVzdGxlIGFueSBvdGhlciBzb3J0IG9mIOKAnG5lZWRzIHRvIGJlIGRvbmUg
aW4gYXRvbWljDQpjb250ZXh0IGJ1dCBkb2VzbuKAmXQgbmVlZCB0byBiZSBkb25lIGluIHRoZSBm
YXN0IHBhdGjigJ0gc29ydCBvZiBzdHVmZiAoaWYgYW55KS4NCg0KT25lIG90aGVyIG9uZSB0aGF0
IGNhdWdodCBteSBleWUgd2FzIHRoZSBjcjMgc3R1ZmYgdGhhdCB3YXMgbW92ZWQgb3V0IGEgd2hp
bGUNCmFnbywgYnV0IHRoZW4gbW92ZWQgYmFjayB3aXRoIDFhNzE1ODEwMS4NCg0KSSBoYXZlbuKA
mXQgZ29uZSB0aHJvdWdoIGFic29sdXRlbHkgZXZlcnl0aGluZyBlbHNlIGluIHRoYXQgdGlnaHQg
bG9vcCBjb2RlIChhbmQgZGlkbuKAmXQNCmdldCBhIGNoYW5jZSB0byBkbyB0aGUgc2FtZSBmb3Ig
U1ZNIGNvZGUpLCBidXQgZmlndXJlZCBJ4oCZZCBwdXQgdGhlIGlkZWEgb3V0IHRoZXJlDQp0byBz
ZWUgd2hhdCB5b3UgdGhpbmsuDQoNClRvIGJlIGNsZWFyLCBJ4oCZbSB0b3RhbGx5IE9LIHdpdGgg
dGhlIHNlcmllcyBhcy1pcywganVzdCB0aGlua2luZyBhYm91dCBwZXJoYXBzIGZ1dHVyZQ0Kd2F5
cyB0byBpbmNyZW1lbnRhbGx5IG9wdGltaXplIGhlcmU/DQoNCj4gZm9yICg7Oykgew0KPiAvKg0K
PiAqIEFzc2VydCB0aGF0IHZDUFUgdnMuIFZNIEFQSUN2IHN0YXRlIGlzIGNvbnNpc3RlbnQuICBB
biBBUElDdg0KPiBAQCAtMTEzNTksNiArMTEzNjMsOCBAQCBzdGF0aWMgaW50IHZjcHVfZW50ZXJf
Z3Vlc3Qoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0KPiArK3ZjcHUtPnN0YXQuZXhpdHM7DQo+IH0N
Cj4gDQo+ICsga3ZtX2xvYWRfaG9zdF9wa3J1KHZjcHUpOw0KPiArDQo+IC8qDQo+ICogRG8gdGhp
cyBoZXJlIGJlZm9yZSByZXN0b3JpbmcgZGVidWcgcmVnaXN0ZXJzIG9uIHRoZSBob3N0LiAgQW5k
DQo+ICogc2luY2Ugd2UgZG8gdGhpcyBiZWZvcmUgaGFuZGxpbmcgdGhlIHZtZXhpdCwgYSBEUiBh
Y2Nlc3Mgdm1leGl0DQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0veDg2LmggYi9hcmNoL3g4
Ni9rdm0veDg2LmgNCj4gaW5kZXggZjNkYzc3ZjAwNmY5Li4yNGM3NTRiMGRiMmUgMTAwNjQ0DQo+
IC0tLSBhL2FyY2gveDg2L2t2bS94ODYuaA0KPiArKysgYi9hcmNoL3g4Ni9rdm0veDg2LmgNCj4g
QEAgLTYyMiw4ICs2MjIsNiBAQCBzdGF0aWMgaW5saW5lIHZvaWQga3ZtX21hY2hpbmVfY2hlY2so
dm9pZCkNCj4gI2VuZGlmDQo+IH0NCj4gDQo+IC12b2lkIGt2bV9sb2FkX2d1ZXN0X3hzYXZlX3N0
YXRlKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSk7DQo+IC12b2lkIGt2bV9sb2FkX2hvc3RfeHNhdmVf
c3RhdGUoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KTsNCj4gaW50IGt2bV9zcGVjX2N0cmxfdGVzdF92
YWx1ZSh1NjQgdmFsdWUpOw0KPiBpbnQga3ZtX2hhbmRsZV9tZW1vcnlfZmFpbHVyZShzdHJ1Y3Qg
a3ZtX3ZjcHUgKnZjcHUsIGludCByLA0KPiAgICAgIHN0cnVjdCB4ODZfZXhjZXB0aW9uICplKTsN
Cj4gLS0gDQo+IDIuNTEuMS45MzAuZ2FjZjZlODFlYTItZ29vZw0KPiANCg0K

