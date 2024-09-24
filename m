Return-Path: <kvm+bounces-27391-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 19FD0984D2F
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 00:00:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3B8FD281B8B
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 22:00:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAB1A146A97;
	Tue, 24 Sep 2024 21:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Dyqz1MZr";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Bfbbc1YA"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23AF713BC02;
	Tue, 24 Sep 2024 21:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727215192; cv=fail; b=cqPPEuhrsn17DPNfY5cNP/Edr0dfYRZ/Ht9VnaYZpfKigFCkqDXfXt9QJTGNWIa4N3fjrO8laKlJ7bcHONT8eUFkHZ6omen4bngH6S7taLiqIT4EszQSC9IWkA7syk54AIv3FYYXJBnGtXhUxlt81n8G1fbbrhpC+hqUSaOEcRo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727215192; c=relaxed/simple;
	bh=6W9fO8b4e9lZp71ZsmnLSggUgJ63SbHXOnYIKumQPA8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RxUezaPXEhfoahGNeK7wmprCl37tJi+jng3C5wZVevGZTHJwltLnhNI8qppr9eGrBw97apGQBI/CsXrkuIcA86TFdNx8sWAFoAnKcdV/mwhMYWxkoCC6+qqsA+qfN9ZJud/jblqHXrrXaY2PJyuGvr3PQEZ0u/PIo3Y5pg3t6H4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Dyqz1MZr; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Bfbbc1YA; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48OHMZHP014722;
	Tue, 24 Sep 2024 21:59:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=y6tVUU6yT/MVbiDI27S24s9c+H5Tv6Dqf4O412rhijA=; b=
	Dyqz1MZrz24w5urMVowtwaF+HHMYdaRsdMt/bJdDtkv4s2ufN/xdT6Plu+9JC6Sm
	d/yM/xpcKYpQopI9fPZJPAhp8+uVFEYIf788SYnhChy3qob1g9lAT05p56VEyGkO
	vMfXcu8OU1WiMg7w+ArTmje0NWokMeXfGoDIC076Kr05QJasBl/g9Hky4ZTCAfUu
	JKDATdB4iS/lPnjgZSV5vewBT45QQpZyearo63SDK6UlrqUeFE5u8v8+TDw/GJK/
	d05u1kcM2FJJHudOD4bPNe+Z6ASbqs0x5wVlcDbqcW45GO1tIaQpzUsCY9qOGDN6
	bViMMZQYHmEz5N9cIvZWIQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41sn2crse2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Sep 2024 21:59:47 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48OKjqbJ026070;
	Tue, 24 Sep 2024 21:59:46 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2049.outbound.protection.outlook.com [104.47.70.49])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41smk9ugah-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Sep 2024 21:59:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yoiEBsSh+gILxQQKAtim8W5d6NSUlQNyp9LMDRZ8nO2uRBijc9hL/bxgBw6jIkw9RoBYfb6w4S4aSMWvl7v1ZvS1XBhTDUFkIruylgzsLSyInHt9GZLECQAvNJ2YFV/a253cjuipq6EsuOos+bWhQJ+scU0Cmjrq5uPvk8u8spXaAAovY3xHWIGVj/f2+LMZ4GkRXJVQ9kTQv5E3lpZ/z6lQN9JCEeockSMKx7ztC4An6Frw6HdvzSBdGSkZvcH9A8ySK/VKLm8dnZ7PCZ2QCAJwSasJh8NqzD+naBrp/2rAOIEH3H+OmZ9auw4RQXTx+Cs6JUQ/tkzRTUt5suWBnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y6tVUU6yT/MVbiDI27S24s9c+H5Tv6Dqf4O412rhijA=;
 b=O00D12OeCEJrRNC+zM0Tt8ujPiXIn6VMdeaFRg6/OPJTGsy63IAYCcO0NXTcGX94+MUtrA1/aDUQ8b8qE4smNCpDtDj+9xkt+xhEWeEk9E3XdS22kP85l6XxYODFig3Ptm9NalWJZvGaEGAZtX4XDAIGuqGWGwMDnEaTNyhbQ5SSNKz0ftIoCAMTxnmmTMEeyhPb9XWUGEdXQhL/2+SoBP+IvCYSb3UXi0v/FwrF8LIjOZ1Lj0MChCocLoA5bHDyWEuBM6xkdKydY6SmI7IwIG4LyiD3OkOt4wufWP9VtRjo1cnDWVtabuPIf85z17kcIN1JJATxS1RLV1jposZf0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y6tVUU6yT/MVbiDI27S24s9c+H5Tv6Dqf4O412rhijA=;
 b=Bfbbc1YAQ9ij4sV5H/cArVR+NG1Dfetkp7bQ7fH51O8ltYah3PeDAcSXoxI4v3JAh+liU7e1SdEI5fA3w3L43SGnv1adTUDIPnu979grPmsHJgWLR//eBL+w6lQvFB1PkD7u5rGq7F4pQOwjgbsUtun6W4fX9OcFo0PZxYlLHcY=
Received: from BLAPR10MB5009.namprd10.prod.outlook.com (2603:10b6:208:321::10)
 by PH0PR10MB5546.namprd10.prod.outlook.com (2603:10b6:510:d9::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.11; Tue, 24 Sep
 2024 21:59:43 +0000
Received: from BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::a088:b5e0:2c1:78a0]) by BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::a088:b5e0:2c1:78a0%5]) with mapi id 15.20.8005.010; Tue, 24 Sep 2024
 21:59:43 +0000
Message-ID: <4274f9be-1c3d-4246-abe9-69c4d8ca8964@oracle.com>
Date: Tue, 24 Sep 2024 17:59:39 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM/x86: Do not clear SIPI while in SMM
To: Igor Mammedov <imammedo@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric Mackay <eric.mackay@oracle.com>
References: <20240416204729.2541743-1-boris.ostrovsky@oracle.com>
 <c7091688-8af5-4e70-b2d7-6d0a7134dbbe@redhat.com>
 <66cc2113-3417-42d0-bf47-d707816cbb53@oracle.com>
 <CABgObfZ-dFnWK46pyvuaO8TKEKC5pntqa1nXm-7Cwr0rpg5a3w@mail.gmail.com>
 <77fe7722-cbe9-4880-8096-e2c197c5b757@oracle.com>
 <Zh8G-AKzu0lvW2xb@google.com>
 <77f30c15-9cae-46c2-ba2c-121712479b1c@oracle.com>
 <20240417144041.1a493235@imammedo.users.ipa.redhat.com>
 <cdbd1e4e-a5a3-4c3f-92e5-deee8d26280b@oracle.com>
 <534247e4-76d6-41d2-86c7-0155406ccd80@oracle.com>
 <20240924114051.1d5f7470@imammedo.users.ipa.redhat.com>
Content-Language: en-US
From: boris.ostrovsky@oracle.com
In-Reply-To: <20240924114051.1d5f7470@imammedo.users.ipa.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR01CA0065.prod.exchangelabs.com (2603:10b6:a03:94::42)
 To BLAPR10MB5009.namprd10.prod.outlook.com (2603:10b6:208:321::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5009:EE_|PH0PR10MB5546:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a5d0809-6f18-4e85-26d0-08dcdce43243
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Nm5NejNEN2ZlSkhnOE5YZE1zSnJCajhIMVpnWFdyWjh2VDMxUFFlemZVSnVM?=
 =?utf-8?B?aHZLS1g4ZEY0dzMzOWEwbUNybU01aCtTcTk3T045TGUrZGdBWUFIM25rSVc5?=
 =?utf-8?B?TXM3VXJidm9oZUM3MmhUZUV2YkFVMnVQOXF0dGN6dE1ZR0ErSEZQdFJoNElt?=
 =?utf-8?B?Q0I4eG81RlFpQkMxV3RtNTZRYWpDNlMvbGFlUGRyQ1ZsVDU2bExqck1vaDBM?=
 =?utf-8?B?M2hFcUp6TkZIaGRiZTkvcGtqMDVsRi91RDJybmNWb08ra0Z1UWR1VGhSbmpJ?=
 =?utf-8?B?OEV5citvTnI4TzZ5QmJBb0NOMzZ4THJHdGE0c1M5b1FKZWQ1b3EvRnhKT0tD?=
 =?utf-8?B?TFN0azQwTlVhV1A1SmpjTGQ0SmwyY1lHcEMxcFpFRURRRll5L1llaEFkcDZ2?=
 =?utf-8?B?dGRuS2dpZkUwWTVaV1pGYldMMVJBODd3cHlyR20zUE1VOEhUOC9DOVZla0tt?=
 =?utf-8?B?aXFBK0wxTnNJeWtBRU5rUUlhY2VOcU0waTczN2MxUHVpYStBZlA5NkR0eHo1?=
 =?utf-8?B?STY3ZWZYYmg5UHk1ZmRtZ0MyNUJqY0FsY3E5c3lobTc5TFpveGRxSDVtL2dX?=
 =?utf-8?B?ZzB6ckJVSERvdW5qRW1kSDd4YUl1Y0s3UlFSOHBuUnhrdFloVnVVTGNIdGVP?=
 =?utf-8?B?NytpWXZoTDNuYUFNWTRERHhkNGxYb3lRZ0EyNkh4WE9iNmZTZGZ2eElqM3Z6?=
 =?utf-8?B?cXM0WThQaDlDRkpLT1F0cUFYek8vRXZTRWV2bktnQ25Hc3VsQTh0UGRORE9L?=
 =?utf-8?B?Mk1tdlZ5aXlKZmMvTG0xczhrVGtrY0tkS053TGpUVFllYTQ2MU0xemg1UHNr?=
 =?utf-8?B?bjg1dmtPQ0NSWnpRaTFHZUhPWHlwVkhBQUQrZmliQXVsbHpxRkdHQm1RcUpJ?=
 =?utf-8?B?cE9uRStBaEZZNStHaWZ6R0RuSDY1K2xzd1JTazhSaUQwR0ZaZURVVmRxTWd5?=
 =?utf-8?B?QU80K1puUnA3UE5hSlF3VGF5RVpIUDIzYzdqUWkvMGxKcUxtN1M5NjRhZy91?=
 =?utf-8?B?UmM1VjRUb0Q4U2hUbDlrYmVKZlNXZDBnblVZcFFxd044SERkaXYvK0hQWkJk?=
 =?utf-8?B?dVhIQ1l1SUlub3Rrdk9EeTg4eFBMNlZnWW9VdXMzMWphRVkwRGRDNFVNZnE2?=
 =?utf-8?B?OWlDVmVFMmhQTkExbjFjSXRncUdoaThOY2xJV3lBak0zdTQ3RmdhbUVKdDJp?=
 =?utf-8?B?eDBEZGtxVmtXZ1ZFSm92S29jNnphMk43NGcyNWJudlFoSGM4WW8ycTVrNy9K?=
 =?utf-8?B?cE1BdWZQTTdsOXNSbVVHc2o2ZmdaeWJLVTBraGI3cHRjcjNoTHNMUE9oQ3VZ?=
 =?utf-8?B?bCtabkt3ejVkSlJTdnFvbjJwZEtmUVNCZGVEbXFCeFAyaDlqRWdiOTA5VGdG?=
 =?utf-8?B?Zk03THl5N290MHQwYkZ6OGp6L2VpNG0zN3lwc3ZqNWRFdHpHMTRUUGMvaStD?=
 =?utf-8?B?OUx6OHZUTms0RmRPbXJpcTE5TWxFTDNEN0VVSnBvQkRYcnRxb01aci9PSzk0?=
 =?utf-8?B?U3BkMitZdGhLS2xWV0lTTit0NW1nQ3QzdGphSDkyeTVUdFJUNXRpVGZtT1di?=
 =?utf-8?B?b0paeXpma2twdlNMNFRJTjE4VWRLMXVuUVVmWldJTW9DMVJuUDhIUHNqaUho?=
 =?utf-8?B?Q2pNemdVbWRhWFZsZ0poNkxFc3V2c1EzVjFsWG0zdTBQZDRkUG1rQmFLOHBi?=
 =?utf-8?B?ZkFqMHkxUk5BYlZYQm45RUNTbU5QTDFNb1RHamJuZUhlZjVRaEFoaUdpSmRR?=
 =?utf-8?B?MXo1Y0hHOGY1dWc1djNzNG5hTmdPeTZaV0FlRnlHMExxdW1wSEFVc0Vreits?=
 =?utf-8?Q?rH48c+CfN76ZQBJRA2BvsoW8KvaAD6I0lm5Es=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5009.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cktpK3hDRDVlend3WWtPK0Fkc09PUEF5dXp3TDFnd3ZhZTNwTXJvWjNhNDI5?=
 =?utf-8?B?REhFL1QrckQ5L0tTM2VBKytMSU1vT3pjVGtEY0MwdmRhb2NpeHdTL1didms3?=
 =?utf-8?B?c3ZHS3pyRllHVUxiSStUTVQwckxCT0pZem01RVh4SnBzYUh1QU5kY3JsTWRY?=
 =?utf-8?B?VVFhaGFtQXR2ZkN4OWpMN3RxVTNZYlhRSDN5RUJuTk9aYnVRSk5kRGFzT0Vw?=
 =?utf-8?B?cnZWUXNOMjdlTStWaklvQ3Y5MmcxOWhzVGUvNm9VMHFQaUtmS3N6b3RlbFFt?=
 =?utf-8?B?OGNxQmxpUXVMZVlTeDE1TUYyWnZ5NFIzWHllN0I3bHBTOUxDc0p5SE9BRHNt?=
 =?utf-8?B?QjZMVFhTUXJWbHpRRzJrY251R2FrSVdzaWRLdHpiMlZjeHB6cy8yUDQyejRk?=
 =?utf-8?B?Y3RPRjNTNkZzTEpzM2N1eTcycGdtQjM4Um9UajdTQnY0UFpUNng1UlF5THdt?=
 =?utf-8?B?UjA5ZTNmS0g4TjZwNnNKSVU3Wm9TdUNQK3RLdXI2TzFPRlJPajBCYnR5RkhR?=
 =?utf-8?B?QzVZTmRGMnhXa3F2eGJHcHVIREQvNERuc1EwdXplRzNQQi9qekJkR3pYTDl5?=
 =?utf-8?B?MG05Nkw4cXFaSThhZjBUVk9GZGpaODNoUGxYaFBGUndLSUsvMW5IVGxaRWQ4?=
 =?utf-8?B?TzJyVm9uZks2RTZBb3B4Q2s1SmJSQko5VytrK2lCd3IvcS9HcEwySGdzYlhv?=
 =?utf-8?B?azN5L0t4Q3dYMzBGS3JpTWcvMXQwVzdXVnFMUFJYQXBLV0FZYkdocG5YaDJx?=
 =?utf-8?B?LzhiU3F6YnlmM3BLcVpnWmZIT3c5d0NsM1NjeUhpNGk3dktwalR5YmRQVFMx?=
 =?utf-8?B?dmRuN2UxUnBhNjlxSHd4ZkZOZUdhUXlhQktjaWFCWGMxWEozUkYyMzZBbC9i?=
 =?utf-8?B?d01BK0ZyYk4rRGJIKzBjQkFvTTF3MnM3OHVzbXJ3dVZPcUM3aFFMdDJEejVv?=
 =?utf-8?B?ODcvUThYSVV4SmJ3ZlQveC9EMHFyMjBBTC9oQVVkYzdreE4rTjhOWkFhSUZa?=
 =?utf-8?B?ZFBITG1BUmgwai9lRWtzeElvckF4WWxOeHdiWm12bWVtY2tjY1RqNDVNOXRz?=
 =?utf-8?B?dTZjSzZRdTI2ek45ZkowaGpPenE3ZUpHYXpYR3NOaE8xS1RHdXRVVWwvcTZZ?=
 =?utf-8?B?d0g0VTJCRC81L0ljNnhJZ2JvbGRMVnZ3Um93amdWSWd2bWVseE9DVTZ3MGY1?=
 =?utf-8?B?WXpSMkg2RUYxV0YzNVFOVkxYb095SEoxcjZTN0Z0TCt3eXlaMVZyb2k3L0ZR?=
 =?utf-8?B?Z0Yxc21YRXFRYTc2dGNMSVFYQjE1K3ZuTDh4SDFBa21lTlUyODFONkxxaWR6?=
 =?utf-8?B?SUw0cFhHN0sySDA5RFc4eXU4ZzZpN0FCdzRGTVYwVkZRaHJabXFRdERZUE5W?=
 =?utf-8?B?cEVBK0d5a2IrNlRnY3FueXd4MzNpUDRGUUNxdmY0bHF2NExpLzQyay82blBM?=
 =?utf-8?B?MjdkVzdQREUwZ0IyamdCUktnVCt6MHNxNnZwWU1hZ29Udm4wZ0loSzIrMGdD?=
 =?utf-8?B?MlQ2cURlOEpQTWRob1MrTkdCNWpWT0tLL2g5VXVQVjFiRXVGaVJmSWZyN0dO?=
 =?utf-8?B?T1lad1V5SFNLVWgxTkt5ZFo0M21IYkF6Rm1ZVnIxdG1sM1JPZWxCZGFTWE02?=
 =?utf-8?B?RGgwUTMvbFYwcjVobC9YSjZubjF6N2gwMkE2Zk04SEUwc1NYVExRa29HU3J1?=
 =?utf-8?B?VzFWOEg4MEYyeGUrTmtkQ3UzWjBFWjI3aE5LM1VDS1I0YW9nQWxVaDc2NDJ3?=
 =?utf-8?B?VGpMOXFBaS91NktWWU9TdWRqcmk5Y1Nnd0t4SXAxV3FtWkFLMTVnYzcxQWZB?=
 =?utf-8?B?bXRXOWg1ZHdzM1E0bmZkRFAwS2taYkNIdWVwUFZ4M1p1RDJ4Zis1TUJaK0Fp?=
 =?utf-8?B?ZVJ1ZE9RbXRydFlvMGNLNE1jOGlnTlNSVWlQM0ZtN0N5ZzNJTit1NkZYcDZ2?=
 =?utf-8?B?cUhlLzVoSmpVWkI0NStKWlJWcDR4eFJtelZCV3dvbkR3OUNCU3M0OVUxWkVa?=
 =?utf-8?B?ejJITEUxYm56SmJCQnQ0ek9yTG9TZzI5cyswbDFVSk5yMmVBNzBwTlhSWXkx?=
 =?utf-8?B?RUE0WGE2NE1BL2RnblpycE5vS3k1OFpERkdSMkdUSHNFWEhNKzBTMlNMa2VY?=
 =?utf-8?B?VUFPZkNTZkFqT0xGZFNDak81bHB5ZFJkTUtPOW03Mi9KSVZBcXdmcXl2UEVr?=
 =?utf-8?B?L0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	aGWSEChoz3QlDMbSaTZ/QF0DJmDKXVILUXCAHRWL0C+zLwXdHw2vJ7g7BWYyl3ypA30g9BBtsXIYEVQuXxwlCpqKG3mvz/K/bmXHfHFvD5EQVKMHRwIlZMD61nAxNqXQwRwEpB/o2IFbN0jWWh86tCBenwvluxXHuaW1NfdMQTc82bdjQ8ps7Tz8Z5hDu9/oIu2MPj3IiqOO+ncNzr87pf9uta7mvxUyyIIS8aFSHQAUpZoEtnao+sjYCWn7Y5NhWaFJF6MyJl3cZceFsRIfJb38BeuEHBGOzA5nWU6ntsyfoqfD8gsI6Wi+EpHdPL4JP/VePvegSq0/Wahj1E+5i0VTbjPiQK0+LCV8Ij9adkSkP7jpcC0NkmWuRTBLm5eIMZU9NPvXISPR/Cc4oGasbih+OdGTdWnUwdLhbymRwzawbAbTJkMU6NDDTlDKog1sBnBGxChg/WEJFj1Su1g+U6Ep9xEbZcvEQrdvc9Z8lTAWzp1m5GXRKt0cCgAvPAyxy598EAZ4A57DRy+/uXr/k7WK/alP/JwKh5rf4N8Jm2dSjL2wPCXofDQalEkE0yRtckxpdehU34tRtdVoRsf1TSj2qVt5CroKU34irmS5rp0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a5d0809-6f18-4e85-26d0-08dcdce43243
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5009.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2024 21:59:43.5434
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eOIF4G4kFqzBD9O/Gjl1xJmneg9GX21si4bYIo9pyvh3FgZBtSE5p0ZnPdJo5GkcKgNskkBDSgeE/tNFGt7TfbD3wr3lq2/tjR7ovLOjAHI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5546
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-24_02,2024-09-24_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409240152
X-Proofpoint-GUID: D6RwW44MfhvdR3az7Q8NE_drbHwGUXSM
X-Proofpoint-ORIG-GUID: D6RwW44MfhvdR3az7Q8NE_drbHwGUXSM



On 9/24/24 5:40 AM, Igor Mammedov wrote:
> On Fri, 19 Apr 2024 12:17:01 -0400
> boris.ostrovsky@oracle.com wrote:
> 
>> On 4/17/24 9:58 AM, boris.ostrovsky@oracle.com wrote:
>>>
>>> I noticed that I was using a few months old qemu bits and now I am
>>> having trouble reproducing this on latest bits. Let me see if I can get
>>> this to fail with latest first and then try to trace why the processor
>>> is in this unexpected state.
>>
>> Looks like 012b170173bc "system/qdev-monitor: move drain_call_rcu call
>> under if (!dev) in qmp_device_add()" is what makes the test to stop failing.
>>
>> I need to understand whether lack of failures is a side effect of timing
>> changes that simply make hotplug fail less likely or if this is an
>> actual (but seemingly unintentional) fix.
> 
> Agreed, we should find out culprit of the problem.


I haven't been able to spend much time on this unfortunately, Eric is 
now starting to look at this again.

One of my theories was that ich9_apm_ctrl_changed() is sending SMIs to 
vcpus serially while on HW my understanding is that this is done as a 
broadcast so I thought this could cause a race. I had a quick test with 
pausing and resuming all vcpus around the loop but that didn't help.


> 
> PS:
> also if you are using AMD host, there was a regression in OVMF
> where where vCPU that OSPM was already online-ing, was yanked
> from under OSMP feet by OVMF (which depending on timing could
> manifest as lost SIPI).
> 
> edk2 commit that should fix it is:
>      https://github.com/tianocore/edk2/commit/1c19ccd5103b
> 
> Switching to Intel host should rule that out at least.
> (or use fixed edk2-ovmf-20240524-5.el10.noarch package from centos,
> if you are forced to use AMD host)

I just tried with latest bits that include this commit and still was 
able to reproduce the problem.


-boris

