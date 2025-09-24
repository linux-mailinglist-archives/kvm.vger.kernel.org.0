Return-Path: <kvm+bounces-58707-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CC3E3B9C346
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 22:54:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D648F1B276A7
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 20:54:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E3F526CE1E;
	Wed, 24 Sep 2025 20:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TYYqcyqf";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="SaPXnQPQ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E1C2236E8
	for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 20:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758747243; cv=fail; b=DC8ad7Iomxm19Igb2SWL1AXH99Fy8+//VBMtVtvGu7yqsxZoYSfR7SDjmhA11SvwApL+ZLqwsAtuIjT7eT3BDMfGtKK+4lTKYbCsjBs2kkzUXpSsiopVxbt/RhT39T/gyVIzPZTd6CDnVYNpmv7lEVq0UFu4PiLnQiSLmD3JohQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758747243; c=relaxed/simple;
	bh=cLYI6yZSCDLbmq9S7YYAJKtftdWZVM49e1WaV5nfUhs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=p55oER/Vjhgm2i74gQx3mQrQF8PcYVE+/rjCKaXvIdaawS0q3+/MuRCnnlyFcjiNYN3NvOe91tuzSlLFJv81qd7oOBI29B9pKv/yBvZlpkXQcw4sVudokxqalmfzM1QQM7UGJJX3/YijEekrJqF6G7X0WQXuXw/CzRcoQwg2QY8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TYYqcyqf; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=SaPXnQPQ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58OItqFZ001022;
	Wed, 24 Sep 2025 20:53:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=jqlEYxetvm4PAn5jUr4djm+VjqK/BOhlxOJNedGSjxE=; b=
	TYYqcyqfi/nLTI++X6gqrd1n5aSNq90Y2pWZIX70Iqp/D6D1eQLeGqTOw3WClktW
	9yJnKRwos8OpzJ5B9vwI/6GKoYgAF1vMft4WRAlT8gke2qxdxUdpWQ+Uy0LkteyI
	a66a3JbldvfKXNYASBZOlcAjJ65FjijFQx9pI8FQH0dFhR3bIxL5RgU7ZricyLJA
	ksEf0PJj4OxUySKv2fqJ5mxnuqZ1h5ke4mPZIvDdFW+5AlgRU3NejQictd+xYj7X
	hqw8qIChyZxzhwbsCcWmjiaD+5IDb+/IfhKC4PdbjZ3do34fFKnMpXO62e6U85s4
	1dNhw5QCqNC39DyAyMMB/A==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 499k23gnwv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Sep 2025 20:53:38 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58OKoX5X040931;
	Wed, 24 Sep 2025 20:53:38 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012022.outbound.protection.outlook.com [52.101.48.22])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 499jqa4d3r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Sep 2025 20:53:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KtAruQLg8nMUmdZmhOAG+IBghCib3bJwW8YxA3bQvOW90iDfmm9wGV4y4F+J2enT6zjspIPhmtqskZapAQlTyPsBAWDruPuN/d3NuYNgSWdYlWw2z72RzXD4blQrDCWtKl0WcbteAELRj3q37YejHJBtC2zqtF7r0nF2Cp8NgL/xTzsogK0AMtcxTm6gavDzGhAhEs67dvjsY6muNub90GVMn9oAKaPBAgfvKLsPoD8AecdhAW9frO0sR52PLyIAT2NcvJBrnxfOrR+Kpypr05U+mAmoQR16tEfhsW4G24xE2sEI7k76vVu+fYQrtpsmTYSMgYIoQxOt8wJSQ0FczA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jqlEYxetvm4PAn5jUr4djm+VjqK/BOhlxOJNedGSjxE=;
 b=wEQFJBXnJneNRktmaA6CRFJJY8QV7fVkyLUoO9a9LwuLQ97BFIcqAh8WBmRciMo+01uSYK1StFb/JMzVOAwaVgZWIsJdyQYe7GYOU9AnQ7uVXkLeZvjaEvgBvy6TkEpayYgKsYKyfW1ZKZ26mtII+DcU3Wcyk/1PiIAgVCqnXL7CPO5/DCNRXxGTy2mX12otXI/IrFa3cgEEv4wW7TlWTlPRLed7dzftWgBQL6SnHeLyrZjFAXqeSi6hUz6h611gFj9OnH5rZ0Aw8xUmClL4AscNrvPbOPkRUt4BJjpym85L+PTmk8gYcCQFuhCoeY5S47zdn8MoUU+lcSYYSA1Kxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jqlEYxetvm4PAn5jUr4djm+VjqK/BOhlxOJNedGSjxE=;
 b=SaPXnQPQXqbeN329cQuD+jeBsuEC1YorMxZSW1YJj8UH5v8wJHMfqzSbPblZ/rE2491C/hZE01pDqwEWMRlNsedt9qEbvsBitYmXSAm/kK/86V+rh48lwwc1VTDRE6Z/82RdggxGr2VmRerqBSuxzYUtmW6mMcNviFChBWPQ++M=
Received: from DS7PR10MB7129.namprd10.prod.outlook.com (2603:10b6:8:e6::5) by
 CY5PR10MB6093.namprd10.prod.outlook.com (2603:10b6:930:3a::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.19; Wed, 24 Sep 2025 20:53:35 +0000
Received: from DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::721c:7e49:d8c5:799c]) by DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::721c:7e49:d8c5:799c%3]) with mapi id 15.20.9160.008; Wed, 24 Sep 2025
 20:53:35 +0000
Message-ID: <2cf13be8-cd27-4bfb-af8e-ef33286d633b@oracle.com>
Date: Wed, 24 Sep 2025 13:53:33 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: Should QEMU (accel=kvm) kvm-clock/guest_tsc stop counting during
 downtime blackout?
To: David Woodhouse <dwmw2@infradead.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org
References: <2d375ec3-a071-4ae3-b03a-05a823c48016@oracle.com>
 <3d30b662b8cdb2d25d9b4c5bae98af1c45fac306.camel@infradead.org>
 <1e9f9c64-af03-466b-8212-ce5c828aac6e@oracle.com>
 <c1ceaa4e68b9264fc1c811c1ad0b60628d7fd9cd.camel@infradead.org>
 <7d91b34c-36fe-44ee-8a2a-fb00eaebddd8@oracle.com>
 <71b79d3819b5f5435b7bc7d8c451be0d276e02db.camel@infradead.org>
 <bbadb98b-964c-4eaa-8826-441a28e08100@oracle.com>
 <2e958c58d1d1f0107475b3d91f7a6f2a28da13de.camel@infradead.org>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <2e958c58d1d1f0107475b3d91f7a6f2a28da13de.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH8PR05CA0012.namprd05.prod.outlook.com
 (2603:10b6:510:2cc::11) To DS7PR10MB7129.namprd10.prod.outlook.com
 (2603:10b6:8:e6::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB7129:EE_|CY5PR10MB6093:EE_
X-MS-Office365-Filtering-Correlation-Id: 0079389d-c825-4bd5-7045-08ddfbac6dc8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RXp4dlRKeWl2YnRiY2hTYTJ5RVNjSDhpOUJkU1FvWW9EWVJvdmVkM3BQektp?=
 =?utf-8?B?dHdBMDRNb2F1bEF2V1BDUVVRakV2cGdoZFhkbzNuNVJydEJRSkw5QkR2MTVF?=
 =?utf-8?B?b3FqOXNoM0NQNzBIKzFrKzl1Nk9UYVVaWnowTGpKOUM3UDBhdEozNzF6bHJ6?=
 =?utf-8?B?TGVIUmtXWnNJRnBBRjRvN1NCWmo1NklYRFNJVWF2anhtRzAzZXdwckdDUkF1?=
 =?utf-8?B?NXpPTXVuRTRwYW1qOTYvdU95blRyK3dqb0tqQmw0QTJFNmdlZ0JBK1ZmZVo5?=
 =?utf-8?B?UWVTelZRdHVwQW9XcTNqYnYvUlZyQ094M1VZUnBRUTBhRVRsWE1ZbHZXTDYv?=
 =?utf-8?B?VVE1eWMwKzBoZUwxRTJHSG92cFZWVnc2UTA3aDZ2V3I3Z3hlZzZNL2FKeHd5?=
 =?utf-8?B?N3FycHNmL0pJbVI5cnYxUVVyOTR4VWxHQmhIUFVTS0k2dWNNcVBaeGthVSts?=
 =?utf-8?B?bEJZK0wzQlRrbDJLWC9rNUhXQTNZUldMdnBMbTdSaFMyVkk1QUIrNWwyOThW?=
 =?utf-8?B?OXdUeEJSRll6UVRUdTlxSWl4L3lIM3l5S25YWXp4cnZRakpOTmtDMGtXaWRS?=
 =?utf-8?B?dDlwendQazZ5SmtiRXBiYWRUeDFjTDdCcjloWkYvMWt5emFmbEYxcDVXUXN3?=
 =?utf-8?B?dUJOTUV4bHdrd0k1bWg4N3psQ0ppQUlNMDVNTjcwMDlPUk9tajVFenRINE1P?=
 =?utf-8?B?bTJ3SFl4ZlZxZXRDSThNNGJqME1hbmlxNWU3Z0pDa3JNeFowNEFPQ1RUeGhQ?=
 =?utf-8?B?RkxBaUlrUDJhaDBLWkJiZEVwUmprL0ZRY0hveFBxb3J0OENRWlZlZ0EvZ2Vi?=
 =?utf-8?B?OEhJcHdIMHFZdmhhTDdGdS9wZi9sZHFhcGJvN3FaM0Z3bzV1cjZYdHNRVHA0?=
 =?utf-8?B?NXY1dnZsWm9rbEUyNTZHMGNKK003bTEyb1pwOTZWMHhkSFA3WVowOWFCR1Rk?=
 =?utf-8?B?cmJOTGluclJMK2xZN0ZlbUtZR3Z1RnZUYk93blhNTnMyOGRIMnVqQlhEeGYv?=
 =?utf-8?B?Z3N0VlpEemNNaGJDMFBDb0l4NTZSZkh1akNTclIzSFRjZSszS1hnakVTTll6?=
 =?utf-8?B?bitWVVZ3eGpkYTg3WmY3b0hHQUF0enRyTFpjbEdGVjY3U3JJTG0xeGNlaEg2?=
 =?utf-8?B?ZDdRZlJLTGUvLzNjU2twSWxadDhoOTg1WnJSYUJXT3NZUGdtNjU4K3ZZd1Bi?=
 =?utf-8?B?TnU2eDQzVFd3ZzR4aUhHUjl6SWg1c2VjeU00cDU0TXN4WWFLU3I4TlVqRUwv?=
 =?utf-8?B?QTEvUmh1MlVZQi9iallUM25Xayt6Q0RMYWRKTHFKcDBpZCtsc0c4ZmNMYXl5?=
 =?utf-8?B?RHhjM1pMK3RkS0xtTjJRMVI2aW5vUjZ2RktPSWhiLzRPMlNROGlQMmRKZXZ4?=
 =?utf-8?B?eVpwWGVGbmFUR1ZHWkhVVHpQNkJJdlBaYU40Wm92MkE5V0dxbWdRM01lVUlN?=
 =?utf-8?B?RDBRTWRmYVdKR0E5YjNSZUptQzQxcVNQdUwrNUQyTnRGczVEUWJIS3Z4ckVZ?=
 =?utf-8?B?cFpXWldiVlluVUczN0hvWkxGbmxtcEZXUzgrSk9FOWI2dTVSNkNQZVJ0NmZW?=
 =?utf-8?B?TFAyZ2t4QWdoekI0REU3dVBDNWQ2aXpjUTFOQTVyWXNYaDFNbjVxZlhPd05l?=
 =?utf-8?B?ZUZ6aWloUXVjaVo0UFU2bmlZa05FZFNwVDE0bkJOWUZ3M0h0enRkT0RXUnZQ?=
 =?utf-8?B?bkR3ZkljRXJ5SUtjOGJ4M3dkcmN1bXdZVndqYnZwd0p5Ukh1cnluclEvcTZP?=
 =?utf-8?B?S3Q2RUtpZU81ZkNoby9Kc0NSdWpVaGhvTitaR210b0d1RzlGcFNDdyt0eE9w?=
 =?utf-8?B?dEJVTXl2SWRCVzBENlFzUlpXQzdQbHRzV01kbXRpMTIzRytkbFdsZjZ3aDRj?=
 =?utf-8?B?K21nSENCOXY1WEdzU3M0cFI3Tm1YRkVHVThQN3doaFZwYmdIeG1IYkUyM3Jl?=
 =?utf-8?Q?IlwktV+sVqk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB7129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RjZPUFlkR3dqYnJ6UC9sdTBXS3hDZ3pKZzE3VkxFUXBHWnpSSkE0TXNidkg5?=
 =?utf-8?B?T0I5aTZCTlBQbFdIaDJ5ZXVsdDEzL3pLeG40dXduTmpUZmM0Ty9Ca2FXYURU?=
 =?utf-8?B?WXhka3hUNW9nVG1yQUNTU0V3TmlkY1FybUsxLzNMQ1ZtMGJYb2dHU3JyZktB?=
 =?utf-8?B?eThHeHY0YjEwd0JEcURsUlpEbHcyQVdZQ3A1MzNReG9JVlNsTFFnNHJnL0Ex?=
 =?utf-8?B?UXMxYWkwNGd1QnNIamE1c2dBYWFEZEJ2ZFY1MXlkRHd3QzdSUXNTdkVrUXVr?=
 =?utf-8?B?Zm1IcXVIMzRxbEI1WTlXaTROLzFPTVlOUnIzOHRldUhHd25XRzJJRUd0eDNS?=
 =?utf-8?B?akpnZG42V09ZalVvNEM4TmM2OG0wNDM4bFl4Zy95ZW0yQlhRU3FBUTljc29D?=
 =?utf-8?B?enVFT2d3SENQT2VzZ3JrVWhEMDVQTmxmZ3MwTDQzeEc3T09XQW1kajNiK04x?=
 =?utf-8?B?c2VCTFdaZFVnVUxVK1BhUmwyemJxVEFmZFhuVDF5MHFTTE85alhmZCtGTVZl?=
 =?utf-8?B?R3l6dnZScU42RG0vajhwM2hkaUMwOWpTSTMvQ29FNDdzOHFReExZTHF2MkFD?=
 =?utf-8?B?VHQxeGpzTlI3RnFkQTZuUTkxdmJsMnoxM0I1N050UFZ0eHd0ZlNGTXk2QUkv?=
 =?utf-8?B?aG82SCs1MDJNalpwU0k2NGg3QnRZNHdrbDFkcjhaN1B0YXJDeXl6cS90ZWpD?=
 =?utf-8?B?ckN1SExiTlMxYVFjSmkvQWdlRTIxRG5JZ3pzMlVKNGtBdWlkallRSnBDV3JG?=
 =?utf-8?B?SkxGbUhXaEhwWXdHcERKUVBNczRlTGpHcStqWXlLRFhxSnhGTS9US0pGWXF0?=
 =?utf-8?B?SlZtdGUrMnpqbXpBVFdsUUtrMWpPRWh1T2lOSVlaVXpPeUVtTTRTemp2alhp?=
 =?utf-8?B?Zmd4ZjFlWldJWWgrZG9XcVk0ZHVaOGxYSnVjak1NdGVNekI5Rk9IOVNMZ2s1?=
 =?utf-8?B?TUQ2TURMQmZkMGFzREw2UDZ4TGQ3a2xyMWY2Z1FNQm02cVY0MDBBR1RQTGk3?=
 =?utf-8?B?OVlhelRScTV2b2NmN2lQcFEyeE81bE5XUDI0dFNidmdYSG0xbktpWHc2MkNv?=
 =?utf-8?B?TjMwSVdLZWZHQ1ZWMXA3MnFUTzJDSFpHd09lYi8zR0lDZGJUc0VnRzIxM0xG?=
 =?utf-8?B?Z1U4ZUZKbjNVVzlNQUhDU2JLeDF5Z09iVExNNUE2U25KeE9JSTFBSUpTU3d5?=
 =?utf-8?B?aFIzVlBIbjNFY2hXTU5lU0pJaG5RNUhVaW9zK25CWDBIeE9PS2RSdzdGYlAv?=
 =?utf-8?B?SCtzUTUyaUYwcUVMSzk5MnhXa1lrdVUwK3I5T2hvZU1xaTgxWi9YVzArbGY1?=
 =?utf-8?B?T0pQRnpGKzFZaXJ3dXBZUVNKN2RGZTFkODd0TmM3TlJyNmVDc0gwekZ1V3Yx?=
 =?utf-8?B?S0RkK1BpYVRIaVRyVm1ZWTFaWXhWaXdzc29QV0ZLV2ZvRGdObElLbFY1c05D?=
 =?utf-8?B?dlY1aUovdDAzcXFaY2xWNnpSWlpzSjNITXJwaTJIL1d4RHBUZzZrcHg5eFI2?=
 =?utf-8?B?WDRVR1hpK2R5TjZMOFJ0NU1UVzhZcXFDZTFPRFFWTVVxY3EwVms4VWpPNjR4?=
 =?utf-8?B?aWZrbVJhRnViZGQ1OWVhMmtGZ3NsZVRKYjA1N2I3a0oxVDBNUGtZc2pwcjMz?=
 =?utf-8?B?d25aUjZkQ1BTRnBtSnN6S3k5cjZiUTB4VzZKRmw5YVhidFpFL3B6UkpuZCs2?=
 =?utf-8?B?d255a3BBUDB2dkNxNk0wY0RuYzZuT21sSEh6dmo5MEwvUGFuZEtyR2tLUnRD?=
 =?utf-8?B?RDdHU3EvUUpTbURrSkYyZE12cHFsek5iVGRWZkwvaHhzc05VVkpMVlcycEhM?=
 =?utf-8?B?Nkl0V1JncGhsVXJFY1pPZDdQMk45S1EyVUhEdUFRa3ZUNGtaV3VOaDZWZWh5?=
 =?utf-8?B?bzVXVHlienhPV1ZyalFTeHRjQyswRm5YeFFRU1lPUjFjalhzQWJ5WW93czVi?=
 =?utf-8?B?WFJKeEQwd0xPTVFSQ0V0VjB4bm14NnpzMjZiK0lldVFVb2QwSnhmY25hSldW?=
 =?utf-8?B?dUFLRkREYyt2L3JEanN1TGlRUTZFemNuN3A1OGVza0JXemVkOUJHeGMxTmdl?=
 =?utf-8?B?ZmNzNWZBaVowKzFLZ21aTGdyWVJOTHRHMW1ubCtlWHJVczFobzhsUVYzL1F2?=
 =?utf-8?Q?sJesEGcQqxH/JWmxXQBb7dFgO?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	h8hQNC9ua2X+Iu+bht7UslQh+TDFhsReND7eZ2YpSzJUMtSc5TGIn4Wjm6zLy1TuqiUHg+R94eUf38HvP82jcb/UvyND2gmcJdkE+//LKjTRRqIY7PwgHvpeVEslABGBC6gxWoBB7SJmu6AsV66f6kbnTE9uXXFW2O+yXqFbM654ZdbQuqya1KcLtHdqWPaLKy9oOjWIaZ2KUi0jjVQXPXGd5OH9n1ZOD5wTJC/Wcuv0+kumPRvo3ury0o5mMC6rn10K3765U4xR38UcP7dqR5DaJaOB9qK/8lvLmaWZJTU3Q7esJpj5bSgfUXDsmhyMdfpGYPFUE0MGcRYCBoE3S8k3mWDKRKjwqttkEtW17ijdeLmtS0Gdkm2EYpw9wE5x/iYfCTexXFJS7yJT2K20hX7JHn6B/+zdjtbaYmaG9aKelb1hxih8SnuSR7CtzGh0qiFz3rG1V0wD/Z8wbnBsLCnv+EHvUDSdaaPlj73v6u2bg0A38e9USiaJwmimmHlpGmciZs2H715Y3iSBaTz3MXfyLhXybVBId4hWr8dYaqjxH4vPYMHjqLTvwbySyj46bAAKlA5DxD6Dv7FPI7sRJAWgnt/czbR1V1kNFJgoK6k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0079389d-c825-4bd5-7045-08ddfbac6dc8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB7129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2025 20:53:35.3979
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VW74UBI61M2wd9EooPgwLq07rcQLOBHS6mvhbii0DtNwt0DNEgHXeW6VJh0lYCy3ZU3uFTCxhjMfV0yQMPbXuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6093
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-24_06,2025-09-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509240183
X-Authority-Analysis: v=2.4 cv=C5XpyRP+ c=1 sm=1 tr=0 ts=68d45a53 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=bcS_L1TNRa0BnfPIa4MA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 9e-SAI4i4cElqbMCc4jB4fazitbMBHus
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDAxNiBTYWx0ZWRfX20+SJkjOOovS
 beHKzw2suaPohrtLeJ3GtviUws7Ks2H3GJ+oGvipCVVPXYgiy4u5VvCu3wAHYenwu2f9jUsX7qE
 JMglTc0s7ExBG8O1i/SkmujRubDMRWUpTPgdwmdrSdhPyI/0Vabv7Ytd3poL11yueQuEwQLwaG3
 mmdEcajHb7cKRK1OfFMlR+8BToibzqaAsTlMMZpJrYzGBevBDAqBRGYuzfVBqTdqdrbV45texGw
 UVhQcdR455b1qiPs28pYrUuN/P4yJQlbdGbhyV/V7kb4MsTZXaArJElaqr91y4B8wXvlkNVWGNZ
 hBBnrAXT+0t20/mYB6PTEMnvB+C6oSPiMRrnCkcy5qYOw7R54wkUOgs6iWt5mTe1SQ7bwOOhVzq
 LfPj6PNh
X-Proofpoint-ORIG-GUID: 9e-SAI4i4cElqbMCc4jB4fazitbMBHus



On 9/23/25 10:47 AM, David Woodhouse wrote:
> On Tue, 2025-09-23 at 10:25 -0700, Dongli Zhang wrote:
>>
>>
>> On 9/23/25 9:26 AM, David Woodhouse wrote:
>>> On Mon, 2025-09-22 at 12:37 -0700, Dongli Zhang wrote:
>>>> On 9/22/25 11:16 AM, David Woodhouse wrote:
>>
>> [snip]
>>
>>>>>
>>>>>>
>>>>>> As demonstrated in my test, currently guest_tsc doesn't stop counting during
>>>>>> blackout because of the lack of "MSR_IA32_TSC put" at
>>>>>> kvmclock_vm_state_change(). Per my understanding, it is a bug and we may need to
>>>>>> fix it.
>>>>>>
>>>>>> BTW, kvmclock_vm_state_change() already utilizes KVM_SET_CLOCK to re-configure
>>>>>> kvm-clock before continuing the guest VM.
>>>
>>> Yeah, right now it's probably just introducing errors for a stop/start
>>> of the VM.
>>
>> But that help can meet the expectation?
>>
>> Thanks to KVM_GET_CLOCK and KVM_SET_CLOCK, QEMU saves the clock with
>> KVM_GET_CLOCK when the VM is stopped, and restores it with KVM_SET_CLOCK when
>> the VM is continued.
> 
> It saves the actual *value* of the clock. I would prefer to phrase that
> as "it makes the clock jump backwards to the time at which the guest
> was paused".
> 
>> This ensures that the clock value itself does not change between stop and cont.
>>
>> However, QEMU does not adjust the TSC offset via MSR_IA32_TSC during stop.
>>
>> As a result, when execution resumes, the guest TSC suddenly jumps forward.
> 
> Oh wow, that seems really broken. If we're going to make it experience
> a time warp, we should at least be *consistent*.
> 
> So a guest which uses the TSC for timekeeping should be mostly
> unaffected by this and its wallclock should still be accurate. A guest
> which uses the KVM clock will be hosed by it.
> 
> I think we should fix this so that the KVM clock is unaffected too.

From my understanding of your reply, the kvm-clock/tsc should always be adjusted
whenever a QEMU VM is paused and then resumed (i.e. via stop/cont).

This applies to:

- stop / cont
- savevm / loadvm
- live migration
- cpr

It is a bug if the clock jumps backwards to the time at which the guest was paused.

The time elapsed while the VM is paused should always be accounted for and
reflected in kvm-clock/tsc once the VM resumes.

Thank you very much!

Dongli Zhang

