Return-Path: <kvm+bounces-71105-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wNArBzvCkWlkmAEAu9opvQ
	(envelope-from <kvm+bounces-71105-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 15 Feb 2026 13:55:23 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B53613EB1F
	for <lists+kvm@lfdr.de>; Sun, 15 Feb 2026 13:55:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id C04A430041EF
	for <lists+kvm@lfdr.de>; Sun, 15 Feb 2026 12:55:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFC722E9EDA;
	Sun, 15 Feb 2026 12:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FPRF7xem";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="QSmaS8Cc"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0CA25F994
	for <kvm@vger.kernel.org>; Sun, 15 Feb 2026 12:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771160120; cv=fail; b=o0af+8wOWgHRvVZHpmHLpgMEfPbGJIMpzXlB0pP+BJqQTspfZxTYsTrIG7ZroMDE24ZzcRH6Dldm6tkzIVO9Kpw1jC0xZW+I7sFblqMUapa8X2F7K9Xr+9GFcTvY9bnfmpL2FFVJHBHsawzeEcU7gswDk7gWOQL/wOPTx6jvIUs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771160120; c=relaxed/simple;
	bh=74FJZItf6B71bIGIy/c7amKoQWZSk4ORxOgFjG4+0Qs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FdbFMDH2R44QirsBhWk4jLqU9XiBeOMi/cQL67BEDkDESXchT3CHNU/lxfpmD/HaTTUzYOJVxZaZy3+7A1KPBGni9w31OQBk+52i5kIwkXWYFsjcstql7APaLIF5R0coYHkHmWuq+5FgG6fz8MzdCGboILtv7mkvRph4cI2/q+c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FPRF7xem; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=QSmaS8Cc; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61FCnE3H3375942;
	Sun, 15 Feb 2026 12:54:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=BGTBarmP8NCZeQytSDKX5fZ9PvpFBvhWfasINMPzLeM=; b=
	FPRF7xemQX8kjrtU7NuiTHaufMz89KfDney4y9XI0quakjHlSnjbCPuY1konXU7i
	vIM9W1j03BgoYEluLFM5x/XcI/Nenvxj7rx4kI/To7iQrtt5OtZa0OUiUrVzOKsz
	Y673CQXNW4nCCwvcp+OAU6yPPaqvZnew/Rc373okXvsmw61KLjgag9oYD+xpFGAl
	Q45yJ7V8QtQPzCOK8FP7Op7gWovJF1f8MzvfDrY52W35/1US7dootHP2dDeO4vJs
	neYTZ3y/A7dxKYejtOSmIXD0mMgsDEH9mXd68cYdrgpUkEPDwGZI1QP+yR97iu45
	4ln/dxcyVYzIwH6NPu5G7A==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4caj0r8x4s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 15 Feb 2026 12:54:55 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61F9LS2F033480;
	Sun, 15 Feb 2026 12:54:54 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011004.outbound.protection.outlook.com [52.101.52.4])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cafgbg01e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 15 Feb 2026 12:54:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KmYot2ehN6t2XbyT8reqUKv0YATD23jejQq8r8ibErEfjZQvojJfa6zul+hEF2p2e4k+2uxCR5akS+k4G7m6vTaYwdXDJNQUhIJEbc5JVg1BcgS8qCu1hcBqiQ3I2NixRyTvRyXdcTSzZWsqOAtnzwXaFIhzL3AvF8isN2J4utrVuQ01etDgonvAHniy5sD2FZEPAHLyIlhvjfirVxdB/rVrCA9/7RfAm1ReQ3bfe4edR1IG/EXRR/feaMVxuMHIwM20syT97nIy7Z6WT99FsdFUe39/WDPHbIgbRnAoEc3rsVG19/XqWSLgQokx2ooAKp4ITbUc3D3zmV9MoMY9VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BGTBarmP8NCZeQytSDKX5fZ9PvpFBvhWfasINMPzLeM=;
 b=JZYVcyKcvxeipTl4prNj2gU6yBea4mYfipGv2npFd4z9AHBTMBnY7bD0JmHWXqeS7Il7JWuHlfx+zIyFGZKOAj4CdQaOPD5U8jGGqhOHVMRCnzpZZE+iXqWlnjDh9p1Uq5bgn8UXiWv3Q3DlDLCOrnit9UFBXiz79Y4OGnMCdUOpRNmUjcjzOf1WaS5paqj43xbAPiOVHD6ImTUpn7ffH0QUv0dVSOp4zfBjug3I6LKKPhdqP7XJGiHBghe6X8crYjpRLW8TMA+wi8ScHiduc/o+5V9zGUVJ8eI3NEKtm1RbCp7Tr3PpoSdOHi2PWm52Auu+4fgWR66C72C0qiUBXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BGTBarmP8NCZeQytSDKX5fZ9PvpFBvhWfasINMPzLeM=;
 b=QSmaS8CcBjhnu2BU+kbF+uS/Cme6t0hVvr4l6GZOJUiGeqzfyv5m0UpmhDtnaFHe+XExMUiGPle+33NDVlTecA5CgdZ6LlHtzeU7wx/PEOW4tnBiIMJdMDzeUghbAwYsXDHqroONuZSAE9VxH7Oblu18xtrYgSVnMR7b3HnNiUI=
Received: from DS7PR10MB7129.namprd10.prod.outlook.com (2603:10b6:8:e6::5) by
 CH3PR10MB7716.namprd10.prod.outlook.com (2603:10b6:610:1ba::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.15; Sun, 15 Feb
 2026 12:54:51 +0000
Received: from DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::c649:a69f:8714:22e8]) by DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::c649:a69f:8714:22e8%4]) with mapi id 15.20.9611.013; Sun, 15 Feb 2026
 12:54:51 +0000
Message-ID: <5bee6375-c1df-4a80-a9a1-510f4409456f@oracle.com>
Date: Sun, 15 Feb 2026 04:54:48 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] target/i386/kvm: Reset PMU state in kvm_init_pmu_info
To: ChaseKnowlden <haroldknowlden@gmail.com>, qemu-devel@nongnu.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        GitHub Copilot <copilot@github.com>,
        Copilot <223556219+Copilot@users.noreply.github.com>
References: <20260214190353.29337-1-haroldknowlden@gmail.com>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <20260214190353.29337-1-haroldknowlden@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH8PR22CA0020.namprd22.prod.outlook.com
 (2603:10b6:510:2d1::27) To DS7PR10MB7129.namprd10.prod.outlook.com
 (2603:10b6:8:e6::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB7129:EE_|CH3PR10MB7716:EE_
X-MS-Office365-Filtering-Correlation-Id: 1287d8b8-f57b-4b3b-3a59-08de6c91682f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RGVBaGdKSjhzZFFBZEFzU24wTHA4WVJyZXBLRXN3Q2FYT3BkV0E0WnRnakpQ?=
 =?utf-8?B?cHE3bjh5eGYxL280a1QzSWlCTjlmSVZTbndVQUZ1anFXdktPWmdVazMzZUlr?=
 =?utf-8?B?cXNNbE9SV2JVN1YzdFJZL0FKd2ErcEJRT2dRTmQzSTNYN0k4Tm5iSDZ2bytn?=
 =?utf-8?B?cW5UZ1dxeklRdGJrZXA3QkNvMEZBNlFaWCtDTnNpM2xLT1JiMmE5NHhMd0Jv?=
 =?utf-8?B?eXhYTVhVM1ZzSGRSaDVlMUIvcXVxN3pBQjNMMGJQL0V1ZHJCZm1RYjZuZ1I3?=
 =?utf-8?B?bG1qNTREcFFSNUUxQXpnSFFkNWRJSmlpdjFZRzViNTRKS2s2NGphYW1ueTdT?=
 =?utf-8?B?cWw1K3RmMzR6dWVDUzQzRUo5ZjFNSC9ZRkRYakd0M2puZkZtOGpiaDhJY2dh?=
 =?utf-8?B?MlozNGdSTFFvT3BFSDB2MGc5aFRCM3VuYzc4RC9vN0FhUWlIUUxLMi84czZm?=
 =?utf-8?B?Skt5aFlTQnczRVZUK0JIWXZQR29iQ1lrVHZjMVBLNy9zclNpOFV1MmdmbDZl?=
 =?utf-8?B?eUVrQ1RoMlByOXhLcEtRd3lIWEZ1dWVKSWQxamNJanpGaUtTMTIwTkpRMUdy?=
 =?utf-8?B?VWZFb1E2bm9BTmhxWkpScmczcFFEOFF5RUNWUEt0Z3dybzQ1OCtoS0lCNGdn?=
 =?utf-8?B?eVBISHVPUTdxV0VveEFIVlhSaXJYSlBjMVk5QnJ4QkUzc3ZHSGRuUjk3bU1m?=
 =?utf-8?B?SjBxemNYajZMU09QNlBOSDhHZ1NVWGJINlIxV3dwTUs0L0MyZUtHVFM5bzc3?=
 =?utf-8?B?dHgvd0hud0hpTXF0b0d4SXZhOHh1TFk2dUorTnk0ZTFydVZvVWhEOXg1U0ho?=
 =?utf-8?B?UW9xcUNuWkdmaGxsVEx2VitiakVyME42QlpMYVEveTlEdElzc2xPY2pvNXVD?=
 =?utf-8?B?eW1COWFGeWdIVTNFQmFuVEVrT1BxQkdhbWpxSFJSTEpvc0dHR3pTWXBQRG1V?=
 =?utf-8?B?NE93OUVNZEdoaEtkd0laWVArbFQzTHBNdG9CZURPcXZKMnJCM0VUN3VTN3VN?=
 =?utf-8?B?YVFhbVNKMXpZYkNtS29JM2NlaTQ2ZmdHRm1RUElnbFBmUVJDNE9scEJLM2E0?=
 =?utf-8?B?ajdia3ZraEVneDFqU2NVWXBHNDNOeTlrTHd6ZGJZSWdUdXJ2djZpdHg5ZjRl?=
 =?utf-8?B?S0xHRHp2RFdRZ0p0aUg4bHh4c25aSHhhWEJhRWxBMWc1NzRCbGpmWnJaZ2I5?=
 =?utf-8?B?SmNTTGpFOUhpYkx4NUQ4R0VFSGxJeFhQcXZmTmdYRlIvdFVpWEtrd290amRh?=
 =?utf-8?B?UWN6elplY3lWRzgwMGVvZ3VFRHVBck9aUFFVek9POUR2SWJBc3NuZnNScWlD?=
 =?utf-8?B?N1RFUUJlalY3dVVpbCtRMVZvbTBaSFlRdzlxQWVyZXg3QUI3YWV3bHVoYy9U?=
 =?utf-8?B?ZWd2dDl4SEFXYUhFS0R0TlJzQStUQmpxcXM2QzJvWWlTMEVqS25yeHNQbnd0?=
 =?utf-8?B?Tm5jMUpEY2JSbTJSVmFOcmVNNTdTV216WTZoVDZnSGNPN0o3ZnJsT0hXUXh2?=
 =?utf-8?B?VS83UVJBY1RSK3FtWmJycGd0Y05wTGZZcGFhT0U0dm4yY1lhZFp3N3ZnVTVn?=
 =?utf-8?B?dnFLNXdIcXRMeHZzdCtSbGIxNUJyWUtraDUrenlBaWxiK0Q4TE5KOFhhMldq?=
 =?utf-8?B?eURWaXA0OXc1UW5YYU56Nzd3Wnc4cXk4TUxEa28xM2pCdXp0d29HMmVHVWJm?=
 =?utf-8?B?Ui8wbEJreE5aeUxOa0psSXdWaXREUWFlcnAwWEx1VkFGZHI1cWlYMHIxU3J2?=
 =?utf-8?B?WVg1VktDa3lmeTZLUWNpeHh0SElCRkdaMW1sMDhGZmRSMG1RQjZmZzVjYW0y?=
 =?utf-8?B?dzZXVENpY0JWUTZ6RnBzdnk1alZnUWZydE5NOFJlRS9QTVk2aGpyQ0ozbThX?=
 =?utf-8?B?ZVlnQkVnZnQ2MVhpS2FTTG95eWwyVXUyN2d4dVNIM1NEaU9iLzVlK2tHVlFR?=
 =?utf-8?B?NlVsR00vaU5ZTXBDV3Jpelhqa0xBcWI2OWpMZ1ZKTEd1eVRXOHJXZHFEVmlr?=
 =?utf-8?B?NmlnSUt5dUpFZkh1cmdtWENJK2pQRG9Eb3UwTXNBenc5SXJDWDJVZmNGVXZT?=
 =?utf-8?B?RTlUNmRWdEkvazI3a1NSZ0YxdnlaL09lUyttT1RReVJVNlFkZHhXUmg1WWNU?=
 =?utf-8?Q?LPT8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB7129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MUVLKzV1ZVZ6M1lERCtVQWtNb0JrWG9UR2FvekgvMlloYjlVRmgvSFlFK2V1?=
 =?utf-8?B?RkdDUWNVWC9MNXBkK1MwVGduWitXc0VxM0g0c3F6cjZDTVcwd0l0QytER1d5?=
 =?utf-8?B?dHl6OGVySE15REtUNG9TaGd5Q0grVm5RQ2JDZjI0Myt5WHBHMUZDQ1ZaRXRM?=
 =?utf-8?B?cFhxR0U1ZnYvRHF1R0lZRkQrZGxodys0ZWY4eFBOemF6UytEVFVRNEVKUkMx?=
 =?utf-8?B?bTR4TDFYWllLM1k2K2Uxb0R1RmdKdm00bnRiY1oyS3RaaVdtWGloaEk1T0Ry?=
 =?utf-8?B?UTdHeG9KWG1kbjRFOVVvS3F1Y2loMncvNDY4ZEhpTmlBSFI1MUY4M1dlaUhv?=
 =?utf-8?B?b2x0RHRSQjV1N284OWFpdGlTaFZKVnlHc0J0Q0FCV3h3SVdnekVBTkpSVFNG?=
 =?utf-8?B?V2ljWHRWaVFqUkdMLzkyMEZpRUprK0J1Y1BTZ29oWU9DRnZjNCthTmNTUjhG?=
 =?utf-8?B?ZDVnRGFTYzVKQm9pYW02V2hiUnlQc256YitjQ2tydzhYcFkrYlZ0YjE0SnBL?=
 =?utf-8?B?d3VKL1NxMjZGSEc2TU13UzI5clN0NDBHMitHcDB3bXVyUnB0R0V6RCtJVURB?=
 =?utf-8?B?WkV4RTRZUmZwWlBBR0Jxa0xIRVVWcTU5eVYreE9NOGp6U2FiMXNsVmx6bWNQ?=
 =?utf-8?B?S25MR0dZTVVmcFpVZWJtTnRtQnZIZlpJZjJueXBiRDcyTFRSZ2hyM1ZHQUVR?=
 =?utf-8?B?U3JJeW03SUJucUpaOXlyOTZRUEQ3bklCdWFReU9EZGlLVjdBNVRTb2FQa0JQ?=
 =?utf-8?B?SGl0NGsxMS9OaU02d0VNckVERW9mK2RNbElDemVJZnlYYnNReVlXQjVuVksy?=
 =?utf-8?B?aGZ2bUhSZkRic0p5cURNMnNSSGNFeUFZOU5HRllwdTNRVURGVTErVUVxWnJo?=
 =?utf-8?B?QVZKM2REV2tpQ3VSQ3diUnY1U3lvaG83K1ZRd2VtZGxyQjB3bzMvb0tTZU9E?=
 =?utf-8?B?MG9vYmpwRyszMUM0NzgyS2c0N3FmcFNLWG5JYVFKZjV3Yk42NEhxRUU2dkov?=
 =?utf-8?B?czg0WkxxaEhhZ1pVelNZK1BMRitqVGZsWVVKTUFFRmowRjNUNTZpaUQwWUdS?=
 =?utf-8?B?WmNmdmZHU0xhakpTQ3VDZ2pkeWpJZkE5dWNWaWNLcUxJQlRjaGp3QlFJUDJt?=
 =?utf-8?B?K3RJOGlHdklNZ21zaTVmbjBGb0tvQXZlajFTNjB3S0d5cDNDL2JJTEUrMU5w?=
 =?utf-8?B?U1BJSDJFbk9uMUFldjRmNmNKQlpaeEMzUit0T2k3QnNidUxHdGR5cDd4VXVi?=
 =?utf-8?B?ZTVLUUtUUDdMNjFlTFlaQnJ3WmJtYi9sTEFoZG90RnJncFFEUDNQZjcyVDdr?=
 =?utf-8?B?TmdLT1psTFJmakFPSzhOWG9QU2hyQU5zbnE1T21TZlhEMnU0SW1MS1VRa051?=
 =?utf-8?B?QjcyMkpiS0NDUERXeUJrVGhZc3YvVW40THl2RmJBV1lKa2kvUTMyTUFOeDA4?=
 =?utf-8?B?WVArRi8wb2tzbkdsR2FkL3dTNXVlbjNISVFydEp0bVVKS1lXQVoxUW1UZnNL?=
 =?utf-8?B?VUJFdmhGZWxCL1gvYmc2cFcyclRyTmdVbEFpaGFkWWd3TWZvQjV0UEtKQmhV?=
 =?utf-8?B?a3FXVXloNzRMeXFLVml2T2ZtTlpvdmxZQUYvRWZwaHdwUU9SL0VQWnIvQUV1?=
 =?utf-8?B?NVUvditOblI0RHRBQzMzTVBYZDFoR0VoTXdXNkR6d25ZZkxlZE5TQko3cnRC?=
 =?utf-8?B?NTRHdi9GSmNIcURmYU1RQllEN0RXUXo4R0t6VXEvVStnUXNjeUJjR3VZNU9Z?=
 =?utf-8?B?akxTVXFuOVdOY2ZXZW5mRUlET1g3WVU2VjNPREpkRUwrbFZPZGM5RUxRN3JH?=
 =?utf-8?B?elVxczdtU2RCa1NNaWx1TDlnZ1NYRDZtVDM0YlNoNmNlREJpU09LWW41S0NM?=
 =?utf-8?B?a2JsVk5LaUpJaTFsalRiYU9EVzZCT2ZmZXcrdmNVdHkvZEZBbWhZTUgxQ01r?=
 =?utf-8?B?c290WjJZMnlNWjgrUkd3eHgydTRxWXRpZ1FkT3dlWC9xOEt2Umc4aVR5K0VN?=
 =?utf-8?B?RXl3RFdxNVpHd3hpQ3kzNlBlejdYNkNWalE4dUdlMDZ5aG94UVZ5L2FVNlkv?=
 =?utf-8?B?VDFwM1BWZlVxMHRZT3N4NXp4QXkraUVjVjhrc2dEYXJwTzFOdGRXKzNxNVdG?=
 =?utf-8?B?Sk5yVTNiK2lzYVVFUWNEUnNvaS84dE5NS1B3TEdoMStWdkV3MGk5SGpFSjE2?=
 =?utf-8?B?emczbEdzckJlWmFSV2J1bmErN3E1TzdVVk40ODVaNmVzZHVyNkx0UWVSYlJs?=
 =?utf-8?B?N1gzd08ydS9KWnAzV3pxeUxPcFpoNEtkRU5VWk9GN0ZkZ1JnNko0UlJvU2ts?=
 =?utf-8?B?VkdxUjBpYm4wYkhQZm5rN1lkQ3RwSk5EWHhxcXkxTjNGNkJZTmtrZz09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	LrSYEY9fvYzcbZEFOsuh+xCb0NermQFYhh4BJaoadgw2C9cFF36ZnTrjNaEnEbRW3OeO+EqNOiojRYulrCo7tltxJPhjSwBECo8Qzz7bdT71TrgziFZzEosP8kxIRm0IcDEWox541EbeebqhqvCDDUn9vyq3XDz0OvXKxCKP0HB3ZCrDrlxZ8kC4DWgP2Q5YKzQ+Owpb9xATrcSf/h+1brZUqA7dUOh3aYL5fvh6ebhFbDJcBmjGuiVLHYDe9/gt8z/lCP0B3oGe++vcxXfFe5rmGjT608IWDtH84hp1lH6W5HtKrsBNtClNmXWNJRIgUO1Xyf2EviN3HdY1o9mgjtV2rGvk4PIhfCIjvdrsO+854wWqFVO7g2T0+JrWZ4sIQ1KQRSnX8lKFq70xiYNYrQOPKGjSR/KeOyziYN1plE+bWrG06RX30OcVVLnsNIYf26AFhUSSTZytBnprh+NKQONonJx+wyB6Z2ai2r7WEl22S+emJ0jyMeAUk/jl/vhYWKFwNFhIW7afmS/dK7gqwhEiqrzLWsXyjAXBWOJiWwoSQhDiwfmQNGPnneYYc4wogiUuNWHWNDKcxTCYV2uZvsx4VZ2XN50zcbFivqUrypo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1287d8b8-f57b-4b3b-3a59-08de6c91682f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB7129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2026 12:54:51.0026
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RGC9fAoPU1j27SSjWKHtFLqRXeddKaw2xuhEcoh3MnaniLkzJAaOERxfbnZohOfJXfvu9u8TD/qt1bnj1tVNag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7716
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-15_04,2026-02-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 spamscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602150105
X-Authority-Analysis: v=2.4 cv=V6RwEOni c=1 sm=1 tr=0 ts=6991c21f b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=NEAV23lmAAAA:8
 a=_umytFC_EEKUtXc_1gUA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13697
X-Proofpoint-ORIG-GUID: 7GmdW-9VeE0EOxYnKkBjOZaGWPLZoI4n
X-Proofpoint-GUID: 7GmdW-9VeE0EOxYnKkBjOZaGWPLZoI4n
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE1MDEwNSBTYWx0ZWRfX/lECKyS9vlDE
 ghN5xSgdKX3tNDkX5vh+bk3vbpFUswXppWTt0j36gIJ8weXd0F0v93XqvoU/bvX0T0JcBSueLqt
 e0BQiz7+uDOEbL9HkyE0b93c1akDWWXGGrQkJA8CGaDeOloxXCatk2Mcq3ZbObKTPYDzh6Tvf7j
 oMGUYLlWI6MVirYFFi+qQEQMavaQeP/7naGfA1YbkK+/DSw2n2b3wRnY72/H9FbBS5WLQPtew4w
 rLpkfLbjuWJeTY+ut4hTCb491/cmUst2THv+ahoxGcbdB2yFXvWEy3gVIZXnlD/FnMdY0tUxS/f
 hwThbUDqkPEFfj8HItFOLgso+ZjD2pTbF/qV1+CEjItbmbFLh9W1jkeiXl6Bi/gttcE7NFbTXcB
 bOsKTn+5rEWjtc2lOgLxz5e62NLh5F8Aw/JxgLqwZ7Nz3/asHS4fmoI3hNJ8o2tWkQw6ii+Ucf4
 Q7VO1YcBXU7VrDozbMpfTK1TMf8/sPK5X7JnCFI0=
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[oracle.com,reject];
	R_DKIM_ALLOW(-0.20)[oracle.com:s=corp-2025-04-25,oracle.onmicrosoft.com:s=selector2-oracle-onmicrosoft-com];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-71105-lists,kvm=lfdr.de];
	FREEMAIL_TO(0.00)[gmail.com,nongnu.org];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,oracle.com:mid,oracle.com:dkim];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dongli.zhang@oracle.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[oracle.com:+,oracle.onmicrosoft.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm,Copilot];
	RCPT_COUNT_SEVEN(0.00)[7];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[9]
X-Rspamd-Queue-Id: 8B53613EB1F
X-Rspamd-Action: no action



On 2/14/26 11:03 AM, ChaseKnowlden wrote:
> The static variables pmu_version, num_pmu_gp_counters, and
> num_pmu_fixed_counters persist across different VCPU initializations.
> When kvm_init_pmu_info() returns early (e.g., when PMU is disabled or
> there's a vendor mismatch), these variables retain stale values from
> previous initializations.
> 
> This causes crashes during guest reboots, particularly with Windows XP,
> when kvm_put_msrs() attempts to write PMU MSRs based on the stale
> pmu_version value for a CPU that doesn't actually support PMU.

Can you provide more details how this may happen? The guest reboots won't change
CPUID. All vCPUs may share the same configuration.

Why "particularly with Windows XP"?

Thank you very much!

Dongli Zhang

> 
> Fix this by resetting the PMU state variables to 0 at the start of
> kvm_init_pmu_info() to ensure clean initialization for each VCPU.
> 
> Fixes: 4c7f05232c ("target/i386/kvm: reset AMD PMU registers during VM reset")
> Signed-off-by: GitHub Copilot <copilot@github.com>
> 
> Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>
> ---
>  target/i386/kvm/kvm.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 9f1a4d4cbb..c636f1f487 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -2193,6 +2193,14 @@ static void kvm_init_pmu_info(struct kvm_cpuid2 *cpuid, X86CPU *cpu)
>  {
>      CPUX86State *env = &cpu->env;
>  
> +    /*
> +     * Reset PMU state to avoid stale values from previous VCPU
> +     * initializations affecting subsequent ones.
> +     */
> +    pmu_version = 0;
> +    num_pmu_gp_counters = 0;
> +    num_pmu_fixed_counters = 0;
> +
>      /*
>       * If KVM_CAP_PMU_CAPABILITY is not supported, there is no way to
>       * disable the AMD PMU virtualization.


