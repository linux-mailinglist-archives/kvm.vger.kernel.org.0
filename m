Return-Path: <kvm+bounces-40174-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F28DA50AE9
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 20:07:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 71BEF3B23A5
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 19:05:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D3452566C0;
	Wed,  5 Mar 2025 19:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jJ6yMJDJ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Q3a3oQOe"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC2C2566D5
	for <kvm@vger.kernel.org>; Wed,  5 Mar 2025 19:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741201280; cv=fail; b=hlJFMMmvWQ4o7D943hCDKHk9Orkw+N70DEMFF6aKI8mv/f8Hr5Lh+E3aWvLR5z2GOi3gumwmxYb7EjckgQClH7v+U9f1o2utRrEMnPa7nA9jZItF9l2RvcZmG916ztsfc1FWn33DOrLZjNEemp/6eemY1zosOZgueNE5ab0Etv4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741201280; c=relaxed/simple;
	bh=RdWwwQ6bLFe2U685WrJv2fYgFd6nka7lf7UKz4ao5yg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Kd0Q0vK0VQw59VPRT3YElclNFEmBCfldOKoubL15zYLBD8CJJpXRsYy412nV27bgNBVfkVfkSHDpWDVAjnH/UhhCWsF5vz3hNeRoPxMyPIgL68TJ3Gs+aDRQVwGPJdSVJu7cxqsAGNU4veBx+dwQpDMxMPEvMNpQSI4hYoCJ1lE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jJ6yMJDJ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Q3a3oQOe; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 525IMein005748;
	Wed, 5 Mar 2025 19:00:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=YuAD49qjmt5GCyuZjjLr0dqF7E30emA24OvpS2Zt9ZQ=; b=
	jJ6yMJDJn1zDoFVePr+xeloXzmYx729T4t5EIHz86O11R2NXuHMDJpPO5df5Tjho
	asOZnMN0fZv2/DI2v3RuVCUkjbC1UMNuaKniRymvqYfEQcZVfAoPq0xwMBj1VrZU
	qKrFuiQcFG0pEQTQcVQz9HhtVDcFsfciIv3iO42Qf56qvJEoyt3F/ez3qTrJmXyf
	fiOe5NpH6DOwf1K4TJMBuJ5kV2Pk7T6rIfdwyU8rAUW+AjwgAKwHBeyVfK/GCd1z
	c096lSnCl5r0ZzjV4Qg9oLgIv5d8Wo8y4dgglXs5B6MyUOJ7pJ1Aa00eFZxtYWLp
	52VoGtf4CAfBYa9dW5At6Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 453u8wr9ef-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Mar 2025 19:00:32 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 525HFDYt003191;
	Wed, 5 Mar 2025 19:00:32 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2048.outbound.protection.outlook.com [104.47.58.48])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 453rpau6yn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Mar 2025 19:00:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MGw8qfAoKFwkDEp7E0a+Liij8Vt/7t0C12Gpo2POBYimF0cGEojv5kiXVm4WSSX5RxerbCzhrvjswJg+LUD/tHJ1sFBgqDhZw9yUIlwCEicUGGn7j6Mm6ln1C72hPC1O39RunZ0KYpfc4KodP56C5ie8yAWt2ZVB5joy4tYR3e/vco/Q2zBH125UXVg7FiN/HQRUzZzE1aq9aVLeIhr9NA2C45P5LVdwE6igHQYI2RlbvC8mgv73s1OJU5f4JI3yBE0m5GYAExPRvWrWPOQhrT4SV3ab7pHEQ2/yxWvEXqqx0ZY2VvZpVEFHkZTAAq349TkQ6cYHy1VpR/8F93xZ9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YuAD49qjmt5GCyuZjjLr0dqF7E30emA24OvpS2Zt9ZQ=;
 b=ZHaz1Fshp+LCsl4ZOlv/jjqhhkfMAtTc6H0UtxxTUTZEAwhRRcqgUiZv1ISIxmZgVCuusVk5jOz7dDGynAbnnBRBi4YhX8zF3py7t62YjXguRxGLkpmDFUFRoGHt0N1ydjjSF+Yszwh+olVJa3kl0kz9r9Cu5hYVZ6+mI4pouqf1t3WixQB+p6yu0K/WZjVU025oCFgx2zD7kiz6zpIzdmgHfxXtIKLHgs+pj3YwdSOwRD0KHbnyqvmAXo5SLIMAYdSWN/nYxE01DatgM0uIdsbusscyCMOcPXaNPDlJzj+et7fo4tV4RmzCKYrg8oUd+upBVc+aq72YHWMCHS/7rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YuAD49qjmt5GCyuZjjLr0dqF7E30emA24OvpS2Zt9ZQ=;
 b=Q3a3oQOed3qfGIulXRvzcuoYK/FooF2TBaL0V9kSZzLfiM3oe3zbFzSEUeh1DsTyE3/DR9CaKLcRqymPopsLhKju2oW9oU4B2iaX8n89d8x09TrgcjISfXecnFBApSPxqzlheocPBVTExNQsUordmGaKNAniGeBvVE7pGORGnT4=
Received: from BN6PR1001MB2068.namprd10.prod.outlook.com
 (2603:10b6:405:2b::35) by SJ2PR10MB7081.namprd10.prod.outlook.com
 (2603:10b6:a03:4d2::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.17; Wed, 5 Mar
 2025 19:00:29 +0000
Received: from BN6PR1001MB2068.namprd10.prod.outlook.com
 ([fe80::c9b4:7351:3a7d:942f]) by BN6PR1001MB2068.namprd10.prod.outlook.com
 ([fe80::c9b4:7351:3a7d:942f%4]) with mapi id 15.20.8511.017; Wed, 5 Mar 2025
 19:00:28 +0000
Message-ID: <3bfa6447-5724-43d7-8176-3dc13cbb0657@oracle.com>
Date: Wed, 5 Mar 2025 11:00:25 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 10/10] target/i386/kvm: don't stop Intel PMU counters
To: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com,
        sandipan.das@amd.com, babu.moger@amd.com, likexu@tencent.com,
        like.xu.linux@gmail.com, zhenyuw@linux.intel.com, groug@kaod.org,
        khorenko@virtuozzo.com, alexander.ivanov@virtuozzo.com,
        den@virtuozzo.com, davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
        joe.jin@oracle.com
References: <20250302220112.17653-1-dongli.zhang@oracle.com>
 <20250302220112.17653-11-dongli.zhang@oracle.com>
 <5f76ce8f-5f69-4a95-8c27-011a7d713fc3@linux.intel.com>
Content-Language: en-US
From: dongli.zhang@oracle.com
In-Reply-To: <5f76ce8f-5f69-4a95-8c27-011a7d713fc3@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR04CA0017.namprd04.prod.outlook.com
 (2603:10b6:a03:40::30) To BN6PR1001MB2068.namprd10.prod.outlook.com
 (2603:10b6:405:2b::35)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN6PR1001MB2068:EE_|SJ2PR10MB7081:EE_
X-MS-Office365-Filtering-Correlation-Id: b6e682c7-49ca-4382-8d67-08dd5c17fe84
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?K05Rc0FMWCt4VGZnOEJhREhoV2Y2bTF0V3FaOHd0ZWgyQ3U0MU1lendhNlEy?=
 =?utf-8?B?aFdPTWNHS3BZYVRYQzg0TGxSa1dOalhEUmE1ZTdOMW51QWFjUW53d0dmV0pQ?=
 =?utf-8?B?NCs3b1o2cjk2NjcvWGNPN2RLMGxPeFllUi9vLzR1dmZaK3dJSDNvc3pSZmYz?=
 =?utf-8?B?cXpwbHduR050d1pwVzdWWk9CVzNlenJ6TXpZVFdINXZ4czdkOVgvTjZZWXFI?=
 =?utf-8?B?THpTWlgrazRqM0wxbDB1ZkwxMEdhTEgrR1ZNekVoZmRWbzZSY1ZoNlVIRDRq?=
 =?utf-8?B?S282dFJsenJmWkxJTnlrSUh3V1VQOERoUDdMd3JvZkNZTkFhcTR6bDZpbjFI?=
 =?utf-8?B?QXQ1UWhPVzFlbGNpN01vRWlQdEZ3WjRYMkRjM3QraTMrY2VGbi9zV05mM2FP?=
 =?utf-8?B?bVZLYXRqZzVuRDg1eW5USzhPTnZmVlNCMjh6VUMrRWoxV1FvVStqVEd1RGxI?=
 =?utf-8?B?UWlUN3VWNzNkUXVlam9Cd2RKNmlLQ1FiNzQwbDFGdEtBV0FVRkxOeXQ0NThL?=
 =?utf-8?B?SUdKL2pNNXFsTGU1RXdNNnc2eTJGWnMyazRiVW14VE0zZDB6MzBWV21jL2hz?=
 =?utf-8?B?SFl2RDBkdldjdWdsRlFSQThlMlhVQk5BbnF0T2lJYnRZVnFxQ3U1ZnFxdFdB?=
 =?utf-8?B?S29WRUtOeEwvbUhZUllnZExleGthYVRzNVF2bGwvZ3NuUzlPYnozdGdvMWw1?=
 =?utf-8?B?cFNoTm9IQXNvTHdSNXd0Z1RQZWU1L3hEaHI5TEMxQkVSM3luTWgvMXRqSGpj?=
 =?utf-8?B?WUVJUTMrUDZLTnREUmRLVXhSTkdPMXZaU2tza0lsUGQ5K01ZejA4Uyt3UFNM?=
 =?utf-8?B?a25XMjlLamR6LzlTaStqRW1Zdm1IVjVZQzN5dW5VRGFzQ3RoRGZYbXp1WUFm?=
 =?utf-8?B?anBvQWhIZGc5V1hvdGIvWCs0bzZMWit0KzJJV1dFdmdwVlZlNUtwd01ERVBQ?=
 =?utf-8?B?TDRyemZkQ0ZhaGQwN1VGNmtvNE1RREF1TTAvRU91Nno5NmR5N0JjOXA4enBj?=
 =?utf-8?B?VnZhV0N1b2E0d0pKZnhsdFdnUFRoc25KM25pYkN4VHcxR0h6aDB1amc0TmlR?=
 =?utf-8?B?dzk2VlRhUjRtaFVlVFBIOGZ2ZnNZdGFlMjBkNGYrb0JzaWcray9mMi9uaTg0?=
 =?utf-8?B?K1F0VW1oMFRGZVVzZURVQThFb05rNjZQcTlEcXVGTlNJRUVVbHdMZmY4VlI0?=
 =?utf-8?B?Ri9YTG9OM29pTHhDdlFJSngrUURoNjNtci9zK0habnN1U3ZLUDhaUEdiME9Y?=
 =?utf-8?B?d3F1QTdTV1dvUGh4T1J3N0Q4QVE5cng1b0thZFI2RElnVkdqbktEME5Dd1Ew?=
 =?utf-8?B?djEwbjRSMGRmbGI5eW9tTWJ6Zy9wcGZXUWFRdXN1QnJPN1NzRkFkd0xpa2tN?=
 =?utf-8?B?WFI1NlBKdGxINWtqaWRsRVNXUjJnNVhwNEo0YzVuaE5mSHE5cDdncFJSTnVl?=
 =?utf-8?B?SmFHMVc4bjRpZWpKTmsyYnlmemFUSmZmbkVNLzJtVTY1bGhETXZFV3g2dCtS?=
 =?utf-8?B?Wkp4c2FBOGt4d3JZSFQwdGlBUmJLZnc0THQrcndYeThtYWxFQTRtT29FTWlR?=
 =?utf-8?B?VmExZndSSXlWM2U2NmNITzJOS3d2T2ROb1Z5VHFTY28zVThZTVRIcEg4THBq?=
 =?utf-8?B?TkFkaDJIWWdTamxOSTY2bjh5b2FMNEk4VUVlaHM4dXMzMlJzYkh5Wmc3Unlv?=
 =?utf-8?B?ZXRUQ0JMVUhDbjJnR0pVQy96aU9adDdzUkdXNExsYU1VSUM4MmlHSFg2WU9q?=
 =?utf-8?B?aGl3MVN3NnIvdzdiMlpOK3htTUZGbUJxV3hQU0lxQWY0c2EyZXNzZzZVWVJi?=
 =?utf-8?B?U25PUFFlTTdEODlYbjdZZExyWGc4OUlqQVFnaTQrZC9YYXJsdHZWQUNLcmJ6?=
 =?utf-8?Q?3EHUn4UCbMVnw?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1001MB2068.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UVdjR3ppbHNKMEJreWFPWkhMMloxakJ5MWZ6cElxbFZyZXU4YWhHZXlsdkMx?=
 =?utf-8?B?NDRrVkhhNyt6dXRXRjFQMTI2T0pLb2J0WXVpOFRGc0x1Nk9rL1NBS3diRzdK?=
 =?utf-8?B?cTJlUVcrYXo1aHUzTlc3eHo4WENJaGlrYVl2NGhReVV5bTRJd0h4YUs2RFRB?=
 =?utf-8?B?K1RrVGRiVDJVTW8va2dIRmY0LzJYUU00aSs4OFZmZk1vZFR3ZER1UStPMXVy?=
 =?utf-8?B?VVFCWU9hcTJ3eENoc0t1anhTVjB2dURpUE00TnJScy9NNG1EN0NQbnNKWGtG?=
 =?utf-8?B?Y2ZlTzJRb29CTHl2M1ZaU1dGcWRpaGJRK1RONjRreHdldjhNNjJTOHpvL1p1?=
 =?utf-8?B?dGJiNGxoZ1RaczlOVkVJOUF3MThDeXZ2b0xRdzVsbTNMbEZBdU5vS0VwSTNi?=
 =?utf-8?B?U1p1aFFNZkkwZTJGR25MZjRzN3Jlci9yWXhqcmJnMDM5eDRNSk1yZnNJR1hV?=
 =?utf-8?B?cldqZFpDM2crREZPN0kreEczbVg1bXhJS25kNUhaZnNYZ1d1N0w3cDBzSGl1?=
 =?utf-8?B?V3EySzk1dndpUzV4cUpsbklOZFpaS09YRThqZUtWVkpOU0hmRFRZWmQ5N1J6?=
 =?utf-8?B?dUlYeUdoSkUxVDVmck9rMjlGNmRVNmZ1M0N1emZPc2hvdEFwNW1CVGx4dzZY?=
 =?utf-8?B?bHk4RUJZUCt1bkJxRUlhV2JvSTRRUEtrSnFiSTlPRTN4US92aFUrWGs3WHZP?=
 =?utf-8?B?SCszOUswbGIvNkw5R0xrUUF4YkUvbUVqRGk1Q2F4azhCUGFzRnV3UHdZcEVD?=
 =?utf-8?B?clRSWGpqUkdQNzVLMWJ5d2tjakpjT2ZwNEozS3dpdzdxVnZSNmJidDI2b3c1?=
 =?utf-8?B?YW9GRFRJYTErbURCOVhUSFV3eE5ZZ3hQZXBrU1lZb0lqOEtXb3V6WjFpM0VZ?=
 =?utf-8?B?am9RWGkzczluTjBtakVINFM1OEhheStGMXVXRXllR2ptWXlsaWpHUkdEdUR0?=
 =?utf-8?B?V3lNRTduY2NHeGx4VEpweTJoZGdVNkhPV0Rhd0YzZEZIb0V5QlRaN254Uk5s?=
 =?utf-8?B?dEtJUjAwMW1RQWdVTGM0RWFpVk1ybjdBVnBwZy9ScGVKU0ZWZThJNWlSaG9O?=
 =?utf-8?B?RThrWUFTTkdIVWZTbDd0VUNTSkhjZElBRjFjVUpKc1IwaTFKdnRzZDBReisr?=
 =?utf-8?B?SUVkTit3b0lybFVFWDkrZlZVUm9henFCcjJPYjdNWXc2a3JQSDdMQy9qSHpG?=
 =?utf-8?B?K3BvOGFFOW44bVdndUZxMm5uTEwwbDN6Qzl1bFpyYm50Ykx5VU9RUTQ0aUVI?=
 =?utf-8?B?a1RRSk53OTBKOGNHWWV4cnJFZFhMWGRkRkJWZzFWYy9JZmRxMWo2MjJ3Nm9S?=
 =?utf-8?B?QlNIU3p4RlhiOVN3ZTVMMXRJdTRoUHp3VkY3MkRhRk9PTk5DOWwyL1pwMVox?=
 =?utf-8?B?YmxSUmFwaGJpTzVYV2Q4d28xb2VOOTdmdmRkelV6Mm10U2ZsWEVHa055WVRY?=
 =?utf-8?B?OFdKdm9wSmVuMGNVSGlLLzRYMmc2OUQ1QmoxMDBrZGkxOTMwc05KSDZUbkds?=
 =?utf-8?B?YkppWGt1SXQxYldudHpSRDMxa0llVUZUSDZiQktqU3FYRjcyTHh5UjgwSG5X?=
 =?utf-8?B?Skc5ZEN6Q0trVDJPTEtMY204QTNJMUwzT0dIYm5WamZ5L2F3Q1RScndBWUJk?=
 =?utf-8?B?Z2JpaEdlWGk4WlZ5Z3pSQ2t2VkZVRWNWcnIxMVZQV2ZDbzJ6VFVtNTRlZkE2?=
 =?utf-8?B?d2J3U1VlNkFOWjlTSzNMdnN5ZEFETm1aSHdOZ0NPVWozQ3RBanlSV2hzVFhm?=
 =?utf-8?B?SDI0T3ZFNEtFeHJkR1RzWXhXNWVPZ2l2RUMxc3FnWWlLemUwZ2FoTFdqTi9C?=
 =?utf-8?B?bXk3TFYwSnQ4QWhkT2VNNXB1ZWEzWFY0VDF3YjBUVVYwV3lSaE9IUmZYdUJj?=
 =?utf-8?B?bzVLdVNQclhCS05iMUJrdCtlT2E4NlFaUEVhczdhallpRTY5R0hlMFBKd21V?=
 =?utf-8?B?d2pWMGlxMSs4YlNqZTJPMHJxTmlya2U2aW92Y3pQdkZaWFI4eUJQb0x3Sjdm?=
 =?utf-8?B?QTFXSTQyOTdOU09ZaXdBejNiSWZMY3YwRUhwWWJzZ283dVJtOG5TNUpvSFlX?=
 =?utf-8?B?WHc0N3Rua3ZKelJZbm9xdEtvTjRRdVM2ZUEyR2FwMHhUSDhIYUVlYlE3ZFhn?=
 =?utf-8?B?QmlTTTF5bm11VWg4RkYzTlFRcEpRM0p1Q21yK0xMSXc4OTUrK0dBNmpXY0ov?=
 =?utf-8?B?bUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	TiEQPtYA+rR3j0t/LhucrgGZu79oOpG8MxBgmIv8CnBImTju7FT8ZqwAuMhfSLvPp+vWe5Hy+I69IAT8Kw4Tmno2zMKpsMVqS/E/duDBtmKnwLTwAukTNHsVPJPh1hmyElCAIAqHH05kly/1/wIN6Vg/9lt6h66pzI+yVRelqFdgb0DQMQKNpkP2kT2U3XJ46hjIg56xOdIN+S2tAUtGcOTMRiVk/LzSrfUmFfH0uRkFoIOIkAFzhMv7mmRMtbRGewc9VlSCeA+pL3T2VtFl/UpSYzcpxgSKY1vMwegACtGtyOaRAvY3Hmpc90Zj97GjShkYQj4wpIgZoUnUGcgbX1qRvP1dWy0yGiHjKNSmbYzmG2nkLiF6+eHSl3wqhob+UfakblocYWsOzYok+jHO6POWrLfHplbCNtUJ4/Q2/6roxTY9a7tL84rnOuu0QVCWb13Gd7Ps3ct03AqjmYrV6iU4nzNgWaQM2RYxh71boTzOKiV5zzlzUumF+ydsNRq/Ch0ss2y1H9jHgwlCB/l72rGqG9f87G5JihIiYYYl0nGYIojn875Cs6CpTAcYvqCVr007PdVbjk1LiLmM0UezIjXGZ5yAjKvQfVv1cqLHq+A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6e682c7-49ca-4382-8d67-08dd5c17fe84
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1001MB2068.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2025 19:00:28.3069
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wy69Bz8VIXSkvsSH+Pq1tS76WtvlsR6jHYKjKwZJ3hgh3TOw0h0xnQqrsbBtH+gb01bXbK7GBloxyHZGxRvgxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7081
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-05_07,2025-03-05_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2503050146
X-Proofpoint-ORIG-GUID: TTVBa6wBCGAHkGsWpoXLBGqxCk6w_J6M
X-Proofpoint-GUID: TTVBa6wBCGAHkGsWpoXLBGqxCk6w_J6M

Hi Dapeng,

On 3/4/25 11:35 PM, Mi, Dapeng wrote:
> 
> On 3/3/2025 6:00 AM, Dongli Zhang wrote:
>> The kvm_put_msrs() sets the MSRs using KVM_SET_MSRS. The x86 KVM processes
>> these MSRs one by one in a loop, only saving the config and triggering the
>> KVM_REQ_PMU request. This approach does not immediately stop the event
>> before updating PMC.
>>
>> In additional, PMU MSRs are set only at levels >= KVM_PUT_RESET_STATE,
>> excluding runtime. Therefore, updating these MSRs without stopping events
>> should be acceptable.
> 
> Suppose this works for upcoming mediated vPMU as well? If so, please
> mention it here. Thanks.

TBH I am not sure if it works for mediated vPMU. The entire patchset is
based the current implementation in mainline linux kernel.

Otherwise, it is also required to modify the AMD's implementation ... that
is, to stop AMD general PMCs or global registers (PerfMonV2).

How about only consider the case without mediated vPMU so far?

1. For user without PerfMonV2 servers, they only need the patchset to reset
general PMCs.

2. For user with PerfMonV2 servers, they need extra patch to reset global
registers.

3. For mediated vPMU, we may add extra patch in the future.

Thank you very much!

Dongli Zhang

> 
> 
>>
>> Finally, KVM creates kernel perf events with host mode excluded
>> (exclude_host = 1). While the events remain active, they don't increment
>> the counter during QEMU vCPU userspace mode.
>>
>> No Fixed tag is going to be added for the commit 0d89436786b0 ("kvm:
>> migrate vPMU state"), because this isn't a bugfix.
>>
>> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
>> ---
>>  target/i386/kvm/kvm.c | 9 ---------
>>  1 file changed, 9 deletions(-)
>>
>> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
>> index c5911baef0..4902694129 100644
>> --- a/target/i386/kvm/kvm.c
>> +++ b/target/i386/kvm/kvm.c
>> @@ -4160,13 +4160,6 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
>>          }
>>  
>>          if (IS_INTEL_CPU(env) && has_pmu_version > 0) {
>> -            if (has_pmu_version > 1) {
>> -                /* Stop the counter.  */
>> -                kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
>> -                kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_CTRL, 0);
>> -            }
>> -
>> -            /* Set the counter values.  */
>>              for (i = 0; i < num_pmu_fixed_counters; i++) {
>>                  kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR0 + i,
>>                                    env->msr_fixed_counters[i]);
>> @@ -4182,8 +4175,6 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
>>                                    env->msr_global_status);
>>                  kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_OVF_CTRL,
>>                                    env->msr_global_ovf_ctrl);
>> -
>> -                /* Now start the PMU.  */
>>                  kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL,
>>                                    env->msr_fixed_ctr_ctrl);
>>                  kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_CTRL,


