Return-Path: <kvm+bounces-35108-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 23414A09CB8
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 21:57:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3545A3A7E86
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 20:57:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49E48215F46;
	Fri, 10 Jan 2025 20:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DGqMZy+7";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="j+Gx0fIS"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4896206F3E
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 20:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736542630; cv=fail; b=RCQPnzUXja+FdDBjkBs0MgOak/Xy1CRWuCA4Z1+kMNofnbKP9nLiKAOx6BOEvAVQR3NJECSmLqpmvoJRlm9NqY6fX0+VSWk7AoYmGExnvChaix+FW4YCRoYn2aFmKiAMX1HslSzOBwjd6kWtjv0bSIoSKV7q17PoPCgAyqxPlnc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736542630; c=relaxed/simple;
	bh=TCGnGCUZ2AUjEM9Bvnf0RRaEn/DALqo89SmkzyQ5rtw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=a2zNvarbSbCa6jYztKynwy3RpnCStYpXl9ZWSryDbKBgu4hwAj2Qaje+DM/I1RQJqeXDg/BGAxWBCETyc9kdeJ0L5AGJdJTz8fyKfMLfMi5OEsUzMojqLo22ffdDCICTdvO9hWhW3/PdNS94K2qTNmqArc4reKcySaZIkt2tCRw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DGqMZy+7; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=j+Gx0fIS; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50AKtrwl006398;
	Fri, 10 Jan 2025 20:56:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=bI+xoKalHeH6GfKo0hq9guKG9/Z5iiyETUIkRaWw7qM=; b=
	DGqMZy+7tCeJHC3HkBNr3JkE2fqsNkE2AK/7s9WP3KXOlJ83DXxtAAwTHZP+L2Bf
	9hI4/MdqruW/owULVkHgwjls6wsNr80ZMGrx6P4v0yxf0pCQmoAQKqmGfNy76PIx
	N5dn7pjGdpKWFEmgSHdy2GN0Nd9zjHuYAKny0L6jzfEBtJ1HnjicH+/TO/fCWQM6
	Z07pvVVLltmJmShfzlDDtBjrAkq5jIksbm7xoCLxT80QIZGUOkwCrSe/zHAFXlHs
	9NhA0OXW/EbqKOgkNGxKvMRdXH9bTs7VDtYyjfmjghdjet2rvwfXaClXncocfRzY
	UI8l+ZC9wgSTbENKA4GrHw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4427jpkmat-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 20:56:57 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50AK6cCm008550;
	Fri, 10 Jan 2025 20:56:56 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43xuecrq2d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 20:56:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eMki3RcfVUFxLzwNbCBAErLWtQcPxEZiweWf7hY9BDgmd94mzkNuq6MNB5kpdxfuiYjrI4oUoay9eihfHANshlBqoZDnV+i2HpfVBOeZW6SPZzahZLPgbZgre///2EGqpO8sMTVqAXaaATrDxJSY+KGZxSGqpOR9VcwTqb1OD9oJoCJl8fOxgY4SVW7pexGn+5AOa8juaG2pP+0TUPPEZRc3jIfC/UUu1glus55ds0n48dzhqQBki0B44v2AH/M4MSvu2o1QIJ1dpT90Vj6/8+LAz1OtlFSKEZnNSjPWInzk2T4S6eanj1LOyBD0bxhFf7GuDofQ/hobYN47k3dxHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bI+xoKalHeH6GfKo0hq9guKG9/Z5iiyETUIkRaWw7qM=;
 b=gghyXLfvZCVLzy9tqVDw5iBWRqkZWvEQYHgL/0QV+we7bOsVKmw/mdlPqycUY6XWkUKkYZo1JQNtH9aQ4aFcDeCXhHkk/r170HXhp8kW7XF3QYQWU3AJOyoIojKQRhU+12FkYpfl06kFLQnJkITBi3WciMD5T4W0TsTqxzxz2/bBoXFrBbmJA0WTEDzpaxdB9CWRyPqephXsP/TWDhTh7XYyS2Ta7NmbGUDAZeKQOHjuEe1viSpoxTLlw3YmvGIndEeq1dgLxJeYlgTsK5KAYzTV6lD0e8Yap8LSepnqaItel8WK49OsIcfrlxyV5gq6t7naRy9fDu0TNCOZ2f8asg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bI+xoKalHeH6GfKo0hq9guKG9/Z5iiyETUIkRaWw7qM=;
 b=j+Gx0fISVrDgn8pqISlg+7j9mmyp0fNLzGzr3p5r8SuPQDNMePqsxc3N//JcBcLxR9mfGHwj4XfXYWVc3eEN5Nt5xx78MY52XVuZZ1qWMhlGNV6rBtDNNSd3oLL40AgVnYkcEE2RNQh8p03bvw5Mqvt2oxi8WhkTHhxxPacYWHE=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by BLAPR10MB5156.namprd10.prod.outlook.com (2603:10b6:208:321::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.10; Fri, 10 Jan
 2025 20:56:54 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.8335.011; Fri, 10 Jan 2025
 20:56:54 +0000
Message-ID: <899b5002-58ad-4cf2-ab80-a5aaeafebc70@oracle.com>
Date: Fri, 10 Jan 2025 21:56:51 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/7] hostmem: Factor out applying settings
To: David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: peterx@redhat.com, pbonzini@redhat.com, richard.henderson@linaro.org,
        philmd@linaro.org, peter.maydell@linaro.org, mtosatti@redhat.com,
        imammedo@redhat.com, eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
References: <cf587c8b-3894-4589-bfea-be5db70e81f3@redhat.com>
 <20241214134555.440097-1-william.roche@oracle.com>
 <20241214134555.440097-6-william.roche@oracle.com>
 <5e2a7936-498a-4f65-923c-353f7ca1ab17@redhat.com>
Content-Language: en-US, fr
From: William Roche <william.roche@oracle.com>
In-Reply-To: <5e2a7936-498a-4f65-923c-353f7ca1ab17@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4PR09CA0004.eurprd09.prod.outlook.com
 (2603:10a6:20b:5e0::10) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|BLAPR10MB5156:EE_
X-MS-Office365-Filtering-Correlation-Id: 409f2970-1e7b-4dc0-2ab5-08dd31b9507d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RnZKY0Y1T3BEbnpKMytNOXpVSmhQMkJEOFd5Wk9JUVBvTnVGWEdGanJ1dG4x?=
 =?utf-8?B?eEFyS010MndFMGtsZklIdndJNVFZNFpibmViM1Zyc1hWZGxWME9YYnR0SmQ5?=
 =?utf-8?B?WENzR3kvL0VoNnJrOTRXOGt0Q2pzc3lWVnY3SFBxTFkrdXZUWDZuRlFqS0th?=
 =?utf-8?B?NmliVW14WHJGWkFnNzBMUmZlemJOb0FaZWw0cit0bGNJb3Jvc1ZTRDFRdWQ1?=
 =?utf-8?B?bVE4UG9UMGR0bU1Pa3ZHVTQrM3JQVlVPcEpBUXMrVVBXdzlwVEdvNU04Rnd4?=
 =?utf-8?B?akVhTlZSNlJtVFVWV21SUVRnNDFlaXhsVDdIRXVTcGF1YnVmd3RZOFV2T3h1?=
 =?utf-8?B?ZUFlMHZWcFhRcDlHQmN1VWlMalE2Sm5EMU5IWDRTVDJEZHpZZHQ2NUpqNmlZ?=
 =?utf-8?B?MTRHelNpZ3RUR2RjSkUvODJhZnV6cGQwaUNhUmxZL29rYS9pODdkVkc4TjVG?=
 =?utf-8?B?UUQ4S3MybENoMG9VeGtWU0lJVHR2YlYrTFJ1RG1yRTJKTjh2eldibUJKMWNK?=
 =?utf-8?B?RGRzYnNTMHlhTHhXZXBnNTdEMWVwMEtjaG5aWXdBWDRjNU1mWnhFUmNsZlJj?=
 =?utf-8?B?YmlRc09JQ29ncHZIRS9TVjRsMnpEZ1RJS2dJZkordTkzcTc0VWp4aDJCZWc1?=
 =?utf-8?B?M1N2Zjh2M1A0a1VacU5neDlCclJIaHZMRFB1aDJnMHZlMGNhekRlRzlMQUlU?=
 =?utf-8?B?ZUw1ZDRZN0xNNE8yWExUeGNLd2JKOEVRWTZ4RjBWbm0zV01LWHlHOUlCK3lM?=
 =?utf-8?B?QkNDWUdHM3AzSzdYMkxaOU84bnFlWnBxMm5SbTdyY0U2aGlNeHpUOUV4TEoy?=
 =?utf-8?B?KytFZkl6cTloWStUYlhqM3JKaFpDSEtidE5iL0s1ZkE2b2ZrcXFEZEtEcnJx?=
 =?utf-8?B?a2lPd2piN3dGQ3VqUlRBanVqYUEyTkJQQ0tqUFRnZGpPTnd6Qkh1OHZRV2c3?=
 =?utf-8?B?SlU2M2UvcEE3YXF3b3VaQlgxL1VGMWJVQ1F0QlYxb2tYZUQzbGJTay9mSEE2?=
 =?utf-8?B?RkFWMXlTaTZid0h2bHpHeU4zbFdRd1F6T3Z6Y2U3cnkxbFBBVWRndmpKTllh?=
 =?utf-8?B?ckM2STNYbUJjQVNKMUZ0V1VYM2J0QXBqV1JpQ3V3Z01OUkFzQU1VRFFJazhn?=
 =?utf-8?B?SUlRcm1naHdyQTl5WW5oZFBoVjZKNG5FazN3ZWVPQjg1TitjbHllTGF3ZTVm?=
 =?utf-8?B?ZWlQbCtEb1BXMmhEVEpEcEVHNFVTSlhhY1lMdEk5TTZsS1VRdFh3aG5rWDNN?=
 =?utf-8?B?NFp5cVZNRlNCSXRxakF6NVh0MHB1UEVxejczTnlOYUhFdFRIbDV5TkY3NW1H?=
 =?utf-8?B?cHBUTTNoWVIvVzIzV1JDRXBsTFExanNCZ2hOellzTyt5dDU4SHZxbkx1VWNL?=
 =?utf-8?B?aVBObDAvRG9WUUJrZ0w0VGpPdnVvc0ttbnI4a0lGQ2VGeWZHMkwrU2luTUJz?=
 =?utf-8?B?UUpXRHdKOWRKUkxrM203MG4yV2RCSXQwcEd1S0JQNnUrVEgwc0lhcERyQmZa?=
 =?utf-8?B?UEtseWVIQWMvcTkwU0w4OURsNUJPRjZwSzRYSHBycmhEQTFWMG0zQlgwanFh?=
 =?utf-8?B?TGg1Y1FRRThFSVZpVDR0dTBpb2JTSnRLQno5NzhrTUF3alh3Nm0rNFZydDdl?=
 =?utf-8?B?ME45QTZHaTl6VEk2ODZCVDBtcW9JUjFoRVVrdjNCZjhkSngvVjM0SVZZTzVW?=
 =?utf-8?B?WlRvMERFTkppdnJ5WE5JcHA2RkFFQXJ2cm5ldndKUDh1MUpLNzNxK0t6R1dw?=
 =?utf-8?B?OUw1UENLQUtIdVVVVjFnNFhFZVllYmlMSW43eWNaUmFIUmNZcTJuOXlCdkJ1?=
 =?utf-8?B?aVdVSEM1N0t6MXlzTlZwa2RKaEVXZ0NJR01udFowZEhsTHJGNzA4eWo4ZHMv?=
 =?utf-8?Q?N4/7oJ/eA4Xu7?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RHlSbU02Z2hFTlFYV2xzT1lvZEFoeW5sd0xUTXNQT1hYckorNWlmejU1Tk5m?=
 =?utf-8?B?bHRhRDVwc00zQ0Y3bmpReGNWOVdLREJIb1RlcFJSSWdURkM3MzgrM3VGUi8z?=
 =?utf-8?B?OExrL1FXN0ZNYk1IRGUwaURlK2dVdCswTkZsVWUzMzZmUWNqNjZKbU5NdnlC?=
 =?utf-8?B?dzkzQTBmYit0T2hveU1QbzczODIwSFp3UXBKZUpVSVBDY3g3VTFYTVVFMEVm?=
 =?utf-8?B?c3loR1E1Uk13UnZVSTZlZTZvRmx2RnVHRHU5VzJEcFFjd3BJb2Jlb0dZaGpi?=
 =?utf-8?B?cjdDNDVMK2tuQVAvdS9hRVpuWFRoakdlTEhhVFNqY1hOUTgzckFGcDI5dTd0?=
 =?utf-8?B?a0h4b0VJRW52ZjRyUy82bHliVW55SkNmNjdtVlIxTVA3ajV6VmFrOUwvR21H?=
 =?utf-8?B?MDdmb3JpMERRMXFpZ0wyWWRnNVczR0xyUUNqV1Y4T3VRSGo4cGdlR1YvdUc1?=
 =?utf-8?B?SFpEc0daUGdlS2ZwMks0ajNKZnczSGpRSDhGNWJzOEt2d2tCaHRGbVZjZDVm?=
 =?utf-8?B?UHRDdmdkV1lrbS9IdHpRTjRDZFMza0dkUXVmcVUxVVdrTGdkWlJ2cjFjVXlD?=
 =?utf-8?B?YzdidGpCVytUdURyVHhOR3M5WStIdXZtWGVheTRLaEJHQy9IN09KL1gyREhs?=
 =?utf-8?B?Z2VqYWpPNGNORGZwOE1uTXQxWHRkeTZIeUk4Q2NKREZsdmVpcnNybmRvVWJN?=
 =?utf-8?B?bDB0ZUNsQmZ5REh2VU55UWQ0QjBqUGNVeW1uMDlyYWlYV2Fwd2tGYm5mRHhm?=
 =?utf-8?B?ZHRNcmc2NXpzZDVrTURiV2pBVllRT25IWC9MSDVBUFpFOGpGSlVhUGRaNEM0?=
 =?utf-8?B?RU80Vmc2MVNmSmwxUEVOOTU4Qm12N3dkaXpwNm9VZDFKeVBIZk5LTitvQWpt?=
 =?utf-8?B?TDQranRDeCtmZXhOaG13Yk9Vb2FvdkxwOEhUYXdYZWxacWlnN3o5bkI2Rk4v?=
 =?utf-8?B?cXhYVnNNMHpZZzd5ZWJYZnpvRFYrOG55NUVoRlZ5S0YxdnA2bWVsaFhxUmJ0?=
 =?utf-8?B?ZzlIQ0VwMnJOTm9sdi83RXJZdWRJRFd0T0EzUzRuOWVXL1FzYTlscTZLME9S?=
 =?utf-8?B?U1QrdkRZSC94NGVGbHRJdm95Vnd6UFRMVnM4aklLM1pFQkx3Q3VjMU1CQUxs?=
 =?utf-8?B?Sm9ydFUvM2ttTVJwSGk2bWtuSHZxU3J3cjliOTlGeXNyTjlpRWZDMENtUzRs?=
 =?utf-8?B?dEs1L3drcWlhaURLZG9sbTd3d0JGQzQvQ0NaRnhkV3BLZUxKUXhrNS9Ud3Rk?=
 =?utf-8?B?VzlFZStmUktIbjFWM1J3SFZwZzc5cm5wVWZ1REdkR2RKaGFuczlwcWdtNlg4?=
 =?utf-8?B?cmdacklRN1JKVnErMStvK2hmQ09ScHNZRzgvcDV2SUZJTzBGcFNZSnN5Szk1?=
 =?utf-8?B?N0NGZzk1V0kvNkdFckVYMjlzUlE2Tnl3Vm0rd2ZhdmYxOXhJQzJqcFpodXJN?=
 =?utf-8?B?TlFZVmY5OE1xYkRIOGhiczR5bHJmR2lLVzRKbnF1azBPSmdjd01iSWJOeDVr?=
 =?utf-8?B?b3RNRDU1S1lYTndMdlRxN0lHK2NBN0g0MG4zSHpSb2FNU2xBQWZwUm5UNE5o?=
 =?utf-8?B?bDQwbTVvREJ4TTlSQlErS2MyVFV0cmNjNEM4VlBjZGVIOWdPN3E5bzl4bFFS?=
 =?utf-8?B?Z1poakhWSVpiOHhJR0wvNFNDdU14NGdTK0dnVGdqR2tWZkFYNlpvN3F6VFU0?=
 =?utf-8?B?U0ZCTVhrejFBWXVGMXZYVGZ6VUEzOUhWa3JEcVNwc2RtYjRXL0NXUG5oazVp?=
 =?utf-8?B?UUtldkRUc3FSSnlJK2VZSG9ESDNpRTRYQS81RnpUV2wwUUhMR0lYVmZ6VFY2?=
 =?utf-8?B?Y2RiQUhIZUh2THdkMDRPQ2M3clpMZlpIYVdMb0VKY2tCMzZIczhoSGxXL0p5?=
 =?utf-8?B?QXdUd1B6cDFleHhXRVFBN0I5TVdQdS9ZeGN3ajBMTmFWSE1VWnJqWkQ5VFBS?=
 =?utf-8?B?VnRZWVBJRnNZVjN6a0VySW00WllZcHhqRHhqQWN6cXZlOUNkMjF4TVVqZHZm?=
 =?utf-8?B?S01jNW4xQ3pmYlZsVDVGL0RLdDRTc2ViUFNJV3FaWDRjZVprVzZnUXZpblNu?=
 =?utf-8?B?TFBDa0h6d1BWenJPQ3M4S2N6cEZZbHBzQ0ovbUlIaVNENzJrZHFBcjR5bUxD?=
 =?utf-8?B?cUpDbXZKMWw4TG9ra2prK0U5MVlFZlpTZUtkaVdFMGprU0luZHByVEE3Wld3?=
 =?utf-8?B?VkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Fi8yPL0izg+BabDd/YaQfz5Wx+mdyAxrCyqtZ/VvpiDKbZzBA4UN3k+Nb5DuFCunK5D0/2NGkzaFSEa+/PmW2/lpx0gq/0vG2lw/J2aNQTUISukdGa4EhsTitgRb2zgQQmsfPHf540lzdzclupnrMR+NGgWkGkva300buYiajrKFf3m50Jy7jMLUYWp6t5PVT9PmOlCGfFOH36g8pZiE1qigUkan9RLw3bgixluBdTS64AGob07w4kS+ihAsehbVe6aOoJhv+tpoW/50YTFtBZvr8uQ0RWsw4jmUdjEVLdz7hGsmVVBSrxc/m3OB5qrWwbMcrE9PENoFaU7/Tf8N6YFZpshC5eqMvlYCJIud/tEh7Agtb+zANf7H/HJ7DvaVWc/mn7NWI/d6O6RKcZFivAcm0jGkRPGwQDjLzX435qTCi3014VXzrGO2Msw7FEnFr6s3cM4iwixlVM4AWzmUlzhNmWxsIzouHq0HutE7DQVotd70bt97D+YxnjpYajexiqtGVUhAunidzdPsNwPFvPJQCZYsZR6eXnBRckUp6ZPBJLHSAc3oviZLeQutiYDlM91B9luMvyelZoKzhDKmA+mldRBUu50dKzaB1xiGCxs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 409f2970-1e7b-4dc0-2ab5-08dd31b9507d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2025 20:56:54.8218
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qh/YRXyjJnBx6nG/q/UbT0+f69SVrCwCk3+gzBAvoB5lThDJQkIDJx3NIt0P03rt0e8e1c8OgwOIo/J1t7vyBJRbfcbq0W+q3Q4wfUzXQuc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5156
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-10_09,2025-01-10_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501100161
X-Proofpoint-ORIG-GUID: Aawm7V94bakwpwoo8NIaTaufUa3gPyvT
X-Proofpoint-GUID: Aawm7V94bakwpwoo8NIaTaufUa3gPyvT

On 1/8/25 22:58, David Hildenbrand wrote:
> On 14.12.24 14:45, “William Roche wrote:
>> From: David Hildenbrand <david@redhat.com>
>>
>> We want to reuse the functionality when remapping or resizing RAM.
> 
> We should drop the "or resizing of RAM." part, as that does no longer 
> apply.

Commit message corrected.



