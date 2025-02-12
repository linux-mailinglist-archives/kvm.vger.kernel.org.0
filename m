Return-Path: <kvm+bounces-37935-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 280F6A31B01
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 02:09:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 523643A8F74
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 01:09:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 113CC3595E;
	Wed, 12 Feb 2025 01:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nfNOsH/r";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="D4Okt1AC"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC13200B0;
	Wed, 12 Feb 2025 01:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739322532; cv=fail; b=D7xSGG+20K3sHnZtDDDPWt4GbzZceOW9CFr0hBnqQ6LDh4vco7t28+SVVPwlnIgPuVRG+PQkeUkque5p1vOVwVXtQtvCw6/l9Qkfyua3UeAYyhFLoWfXgeFXl8ZUafYC83Kf/7UXcZI3rCtQw8332YJ27+tD7oKwq/QI8oTizm4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739322532; c=relaxed/simple;
	bh=n/b10zdJgq9Wp5er0u3u8PwY6L5QQwyr5nC2zgnoKyk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FO2Z0ccRwvx7DR/omSq4iN1KKOlJsKpIaVmhqXTzOHA5zOLVRb2OQ7Z6Rr/rYoKEL3LmF6inUjcrJxEUzOq0s40N/T90szN+5p2yfZxlDi0GFhwmCbvgJA2piuef1W/co5G4oSm7aRG+tZii5Ymy3ZuUDHPxMmyE+j3b21ymxUM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nfNOsH/r; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=D4Okt1AC; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51BLfTR8009691;
	Wed, 12 Feb 2025 01:08:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=e14S7Fag7zMFT4WNROQZjlDmBXMMj9AbBLZHccZziEg=; b=
	nfNOsH/rUgeSHcLaQNyBvq2fwZBP/Ve/UGb6+1PikMj3ykMVRUp6ubK2CT2shxjc
	rENObzbXGejGtS7sSLRCqlfKNzV4LPEG8eLa8Iokmm1XJngUo3g1UdbDcOHDXp37
	LfWQYBclvKMndoAuH/Xbku9e0J//33qW9ej4jdJULb+Ea4ZURAAN8Pt/IANDLDFk
	6KxdjOXEPo9+y997gCGuYiV5sFT1iRNgK4APB/BL/dCEyI1sSyz3k0TV/4+1xHPR
	4G2jRQTCGEygjV2BB/lVPOs3viLC55v4m6G2ic84E2Vz5LOUm8CLWcrnRsQAi36B
	9y95uYFHIL7mdFsrrljvvw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44p0sq6hvu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 12 Feb 2025 01:08:44 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51C0ig9k002660;
	Wed, 12 Feb 2025 01:08:43 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44nwq9mext-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 12 Feb 2025 01:08:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=syECddAWwDZc6eORYE8EKmsE/EPxVzBRZ7n7HXMzt2O9rTvxNUbTQvQ5PZFqp1ZpIdfQjJGoOGvfKHL/m8awQ0K8IFCqEWvMPl84nna3ImATiG/sBsKqNM9a0LpVRxxjzRKyP363xoUr/gIwovvgXbgGWY5eHBx9F9pjZOGcaWO8lEAVMJDJVcbeYKWfcJGecnj4a0UgGLqJZu2I654xVcgOwlZU3D4c6joZa5Yl9G6l1b1lZZWymaToRCewwP7CxtMvmHX1ELFvTiOUpdIQHYZMMdEFF/BRLm4cGGU9HeNa1rXE9eGqYMMXcE6QH+zHUdH1BcIKZTlNTN1sA59TIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e14S7Fag7zMFT4WNROQZjlDmBXMMj9AbBLZHccZziEg=;
 b=vwwrz8MvDO+zeMen60XTwEKg6PJhX1DeA+heUcmYf8v8kpLeTFVHELPUdD3ybLyq/qfFqiuDx7ntseQ64hC7ypyGXkLEDMq9DNh75S52JXMqud5nif0B1tsKtdIFGwZ3Fg4VVra5QnC9qaONTx11cHMbVuSdSYt/mULutykRB5SDnZofuCCsc1EOFKk3xBrwqJCJaL53IT2EGEhcqb6ppFR55Q4kr3fHGKhQhiGreT2dIAZWBfiJITcS6aOKE444gy+3Qq/mOYDHkPhvGb0xibTHQNNvTz9kv0f4KEsuAhFEhb8b8EE+5Z6REw7GM67ndTPIw5Fa1UQfAuFnnrfK2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e14S7Fag7zMFT4WNROQZjlDmBXMMj9AbBLZHccZziEg=;
 b=D4Okt1ACjG5GJ1QLewpgFVrC9piA7NyqY2MirE9gqwXsilmBPxVTkBLj1dcfgHX6ql3FqgSreaZe1c/Bg37mUaw7LzLpt25DsDipXNt7D9/I++c3OxfrIdwPOGxXrbIBZycAPVBjX4Nwt3UKSCV3nLr+ObPcQbtOfo2XqNsmRyk=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SJ0PR10MB4528.namprd10.prod.outlook.com (2603:10b6:a03:2d4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.19; Wed, 12 Feb
 2025 01:08:41 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%4]) with mapi id 15.20.8445.008; Wed, 12 Feb 2025
 01:08:41 +0000
Message-ID: <a6ea0706-e8b0-4416-86b3-c6eeeda49760@oracle.com>
Date: Tue, 11 Feb 2025 19:08:39 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/9] vhost-scsi: log control queue write descriptors
To: Dongli Zhang <dongli.zhang@oracle.com>, virtualization@lists.linux.dev,
        netdev@vger.kernel.org, kvm@vger.kernel.org
Cc: mst@redhat.com, jasowang@redhat.com, eperezma@redhat.com,
        pbonzini@redhat.com, stefanha@redhat.com, joao.m.martins@oracle.com,
        joe.jin@oracle.com, si-wei.liu@oracle.com,
        linux-kernel@vger.kernel.org
References: <20250207184212.20831-1-dongli.zhang@oracle.com>
 <20250207184212.20831-6-dongli.zhang@oracle.com>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20250207184212.20831-6-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0299.namprd03.prod.outlook.com
 (2603:10b6:610:e6::34) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SJ0PR10MB4528:EE_
X-MS-Office365-Filtering-Correlation-Id: 1cc949bb-2489-4495-702f-08dd4b01c9e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aklidnRzeDA5K3Q3bmx4VjdOOXNWeGN3eHBBZFQxUitoaHM0TC9XMlNpV09O?=
 =?utf-8?B?UUxDNGI1MnVGZ3NFQkpDc0t2bEh4TXRwQ3BpNDVuNW5yeDVyamVpa2Z6R3RQ?=
 =?utf-8?B?MkpidTg0Q01qOURzT1JLZ3Q5Wlk4R3YrbG9lenlaeFVRRS9JUS9iQXBwbGl2?=
 =?utf-8?B?bEI1QWRGaXJXcmNUclVna29DU1VxQ2tETXc1UHRLRjErRjNramN4bHhhcDNL?=
 =?utf-8?B?bytiR1VVSnJzalRsK0FtZk93cVZTcnlZZnB4UG9VVnhsSTBlNTc4OFlPWGxO?=
 =?utf-8?B?YTJNZkxtZlltOHhWTEk5VGUyK01jbW1oWFVGZ0NtSHIyb251RDFnUGdScDJL?=
 =?utf-8?B?Uk5TT2lqNGN0amxkOEg2UStXZFIzZHVUOXVPeW5IL3NHb0ZxN2FXc3gxU05U?=
 =?utf-8?B?SHUwWmdXcFBLK2h0Z252NUg2aXM1ODBERC9FR3JUbWg3cXVsdTNtbncxMFdz?=
 =?utf-8?B?YklYV3kwWjJNNkczT21kWmdGSzVnTDQybldQTkV4M1JaWWMxdHZ6cGFrdGp3?=
 =?utf-8?B?STZxZ3BXRzk5eTJhVlVOM2JNV2d1UDZOYlFURGZuNlY2MWh2STdWNnUzYm9M?=
 =?utf-8?B?cGtVZGE2eFpnMHhWOTdlcTJxTXZEUlhaenByWk5ZSlR1cWlIa3l2eS93clRK?=
 =?utf-8?B?WWxsNXo5dWY2UHMvRFA0alJmdXVnZEt2bWdBa0dxYWp1VGsxYi94R2xHdEZM?=
 =?utf-8?B?VFFMZGdPblZNOGhKUlRjcUJGZXZ5NTdzZnJ2TisrNS9VL2c3R3BjdUZyMmpn?=
 =?utf-8?B?dlZlTTV1K08zS1pVS0RsaGdiR0tPck1BY08zUThac1dZODBpdjFxWXJFZXRD?=
 =?utf-8?B?c3lYNHh4Y1RqSTRxUG00MllOMkg0NzFYai9lcDZHa1NwWHlXUVdFNXRTK0Zp?=
 =?utf-8?B?R0hOUEpJNkcxM3NtYXJ6OS9kMFVlWENvc1h3b2EzNWtxV2RXdW5jNXBlYTZk?=
 =?utf-8?B?alVxZkNmS3Q5WVp4dElESmV2OHVrQzkrd2NYZVRPejY1OWpoZjNqd1UrWmZt?=
 =?utf-8?B?NXRpYVlrK3pOYisyUW5iU28ydVBsYkN5anNHUG1zRlQ0ZHlUUFgzN0Qwc21a?=
 =?utf-8?B?SVBiRlBLR1crNVdabWZ4cThMWkN1QXIwVUdxSXMrRFdhci9PL2hycERHTGNH?=
 =?utf-8?B?Q00vdDZySE40Z09BQ0NKZCtOdVhqSjFPSXhEZERFTjRzRW5Hd29HVW9RYzBm?=
 =?utf-8?B?cFVUa1F1VFNoWTk0S05QU01McndtbWxJQ28veXdZcHJwVEJWazNSSlgrakx0?=
 =?utf-8?B?YmdmUEF2NXlXaStkMmQyeVFRUE9STGlGN2NIOWJsRzhiTFcrLzExQ0pvbUc1?=
 =?utf-8?B?NEVVQTVaZDZnNWF5eVVuYkhhNndDZ05QU2VTZ0UwTG1sencwRXdUZkFaNktO?=
 =?utf-8?B?NmNWRWkvdS9IaHZTQWpJbHBnRnB5M1hxSG5QUkVURmJyd25lMzBoTjFYb2du?=
 =?utf-8?B?ZUhQWWp5LzQvM25KRGJjSWNHYnZsRk9vVW5RdUplb1NuZVBQNFprRWorbmJS?=
 =?utf-8?B?QnpoV3hWZmtGU3BEUWtDN2JpU0gwdEdqMFVqb09ndmRGMnd2cHB2ZllXdVhm?=
 =?utf-8?B?ZlNGOHRTWEpFQWx2a2c1SlBncXdpWFFmUU1oR1p2Z1IwSllucGpTS2Myd0ZF?=
 =?utf-8?B?YmRhWXJXbTYrSCt1dHZMaHMxNXZ6N2sySFRZRW53ZytMNDZBVysrL1BTa0t1?=
 =?utf-8?B?QmxWRTE1dkFmOE5Lc3k1TitoRHVtMERoV1NpMWFTTi9RTE1FSU9kWWpZQzc5?=
 =?utf-8?B?MGE5TSttdVNQNUpjZGlrQkJ2bHdRV29LVGtsT2JFOUZIM0xSSDBaTTNGS3pO?=
 =?utf-8?B?NUlHdThudjZRY3hQNDdKK291R2wzdVlrZmd0aEZ2NEpNYmZPM0RCaHptanNm?=
 =?utf-8?Q?6Jx7QKUu+7mvW?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cmkyQ3hIVzVoYm5tQTBxdlRNK2xCNXVSaFZSc1FNNEVYeG4ydXNzSTROZ3Jw?=
 =?utf-8?B?cGRiSVR6c2FpRHdSLzhRVTJLUFFya1ZLVDdJM0s4OWwvNHl4QnkzRURVWEZG?=
 =?utf-8?B?NkNTcVVDeFNJOGpyeTJaOGs1czYyVFQ3RHluaXhkQmZqbG9ydGlpcjVTcGVS?=
 =?utf-8?B?U3RBWnMrZXdUY0dTQjl2ditxUmR2bEJjOXlSYWNKZVdvamVjcTVJclpDVEQr?=
 =?utf-8?B?VDU0R1pVZUNoUlFRKzBpNzZndVdXa1ZrSGJJSjd0eWJKTCs4TjlSWmdaK3Bs?=
 =?utf-8?B?R1pub1lWM0VuWjM3WDEzSWwxdGpOODk5bUVra3RoLzdQZkpKLzJsQTM0cms2?=
 =?utf-8?B?c3ovY3o1cksyayt4RTFsamJSblJBOXYvRkdKdlliaWcxbm1wa0lvWDlzc1dG?=
 =?utf-8?B?WWdxOXBJZ3k5N1laL2hZdUY5ZmRjRTJCV3RwQTdwMmUwQlFRUVp5Z0xzQXc4?=
 =?utf-8?B?Y3N3TFFEb2Rxd3lESWdMZlRqR3ZDTUFsRUk2WE1OelJXWW84V0tYckxkM3Nv?=
 =?utf-8?B?WnV0M2M5R1hLNkVVRUM2eGxRdDRqNHZPSG85cjZmNldIclNZMlJzZWpuQk40?=
 =?utf-8?B?UjRaNW1kZGRkeFdjWlJEMTdCSXprZzRrdFJEcEVFNm1hM1ZaL25SV0JCTDU4?=
 =?utf-8?B?eXVKanJvWjN6NVhHWmQwaXozOXlmYnZvcnBXSUZxdk5yTURwTFU3ZEwxTWFT?=
 =?utf-8?B?VXpIcEFlTjRxWERtOU9pK2h2V3Z0SmZGN1M0TTh3bHJwaVh1MDJYYzdiRW9u?=
 =?utf-8?B?NWdITVJsS0lZQjlleERlUTBJci9PL0NCUmJlUUtlUnFkbkFDbGVjdDVJREg4?=
 =?utf-8?B?QTF0Kytsa25yTk5la1lmN01rdFk1dzVid0dNUFNBdHlCWkZpVlhlUWlOQ1VW?=
 =?utf-8?B?R2kzTlRLWVp2Q016UlBJei9XWTNnaVJ1TTJzWS9rWWxyMXlMYUxLWlZCemo4?=
 =?utf-8?B?TmZTalRCUDh5OElkWW5FQ3pBamg2N1NGYnJSN3pKWGd1ZUs1RFZaM1NRaTZz?=
 =?utf-8?B?MUdhL1VLWmlEZ2I4dVJ4NWd2MU05UlFyZTY2RTF5azFKbjlxUkJ0NDNyZmtD?=
 =?utf-8?B?ZmkycE5BSDFPN0xPc3ZtTEltbHAvd0FReHcvLzhTampzVCtPZlM5TU5wdUsy?=
 =?utf-8?B?clh4bGxCNXFtNitMVWlFZXNTeStnbTFXMWN2MUpLS2lKdzFqTGNQazBjV2hj?=
 =?utf-8?B?QlBvMklSUnVhczVuMGRXZnBiNFJPejU5bHpYUEhMTXNzMm9mcU1EUTZjTVBz?=
 =?utf-8?B?aEtOaE9ETWltWEs5Z1gzamhCNU5oYXRVNjcyTGIxWTRGN3Uwc0J4S3lBcmhq?=
 =?utf-8?B?L3V0MzdVdnl0QnZQZDVKNkluQmRiNlJ2QjBBTmROQXkrTjZIT2lGaXNvZ1Ax?=
 =?utf-8?B?b01uMms4R1JHVkFZMUdZOVFUb2VrS1E2YWt1VFpEYnVEdllPRjRITWhQYnlD?=
 =?utf-8?B?TFZPbS9PNUM5RXltMXg0VkJpUFFxYWhnaFYyalJ5RkV2QkRsSGpNbDAzUmhV?=
 =?utf-8?B?em94N2hxM2VyOHRrM092cllINlQ1aVFzVHQ5VzJDVndCcnEyVE5URXBBZGpI?=
 =?utf-8?B?Y1lBK1FTZXBHLzYrem5YRkNXem92Yzc0alNENThwaGZERmFhSXNWbE1MZG84?=
 =?utf-8?B?VTZtak4xRFlQQnc1TXh2QzN2M29MMHUyOVN3NEMzL0sxTGgyVS9lbmxma3Vn?=
 =?utf-8?B?UTRUWVltQ0NvQWxERzRQbmRVcWhPdVFXRTg2STNuZEVmV3g2VnVDVWQvWm5J?=
 =?utf-8?B?aEx0bmx3b0ZRVWtEQWNUV3FWclg5aS85dHE3UllHNnhjdzlpcHA3Z25Vak9T?=
 =?utf-8?B?NGFrbGFhWnUxNXBxTUpQZlh4ZXFlR1ZaTnVrUFFxb2hObnNZMTZGejB4TmFr?=
 =?utf-8?B?QWQ4cmRHelAxWExwZ2NRMWxBM2xqVW9uTXdXYWhBUlNzS1ArZjZtcFVhdVkr?=
 =?utf-8?B?NTdZZWNMNk9jMEZOMjZWRHVsSzc5TTVBWUZCcC9FME56Yy8vRnhNZk1NaHF5?=
 =?utf-8?B?b2VoUlB5eE5HcXRlcHdDc25uaVFpbkNqU1VPTWxnc2JuMW1YWlR3V2hGZGRE?=
 =?utf-8?B?OWZDbWJuTDVlOTU2NTkxRWk3ZndsWG9sSldDVjdCY2VxelozcXFZU0RsRnAw?=
 =?utf-8?B?bEZQb3JBWXJ0VDJZZldncjMvVjRZNCtmVFJVTlkxbkp2OGswanpuOEswSW5E?=
 =?utf-8?B?RFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/s9gtQna8RCYoeouvZDlSUuaVQm/JbW9IKH2egqsZwaYY7dQkyh8277HVIRik/2wSUS1FJzsRLBq/FkA5AgOYgj9CVJ7Bnx3oO5+LMhWVmCgybQr4H6MGDZ1zNPK2UwX9E6FzsTqPRrOG2kQbSrV7SwWNsbXWuqq821qyR+iJQKrhUyRZ3Q79r0otNGFxBdz4KMWPWMx0E+0vFTSfa4+rQekPiOH9qLE223fjiCBU3nYqK5W6tiQmlgWMcR0AtsNgvfVqOEMiXnlVVxfUEppC+vgqF+/4Fn3xe5/GslJXpJoYYFP3WLCTRFSSnU3jy29sHUuhxxTMmzGqmOMpBM17REmp098JPSQnVjoCS3/ykdlWKZ2+Inlgv6r1+AzwS5UC9irMPVOtOuFkgESdAcn/V5Twk5+/t2NibGMXyaorZI/vqIXvhEC44oEu1Abfq8xIL4mq2TNEWwgczYXVs6gcg1b6bS0E2a4NeLm5CiJM+f0URg/br54VoER+UbbfGZ9EwgwKNapGZeQAnm/xKRFNjYH0GY1Jwkj4YJFDjfUR8dPJ9Jwaq3y+UZig5O6aJdY2oIF55GTRqPPqDESyh3ssCMDvmwXn8h1pWkppRZ+P1E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cc949bb-2489-4495-702f-08dd4b01c9e2
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2025 01:08:41.3283
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1mbkBQGgIMCYzRHjFsYkdKpnESwxnwpyyQk/G4wXbFkYkaTCXWCOlC6dybUqOgRjoWSBxuVmb5e7S94vfttRTPvE6YEJk3QDh+2FFgSzXXQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4528
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-11_10,2025-02-11_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502120007
X-Proofpoint-ORIG-GUID: _mp4vHPru8sCpIiY3nwwKJWfE120vUhS
X-Proofpoint-GUID: _mp4vHPru8sCpIiY3nwwKJWfE120vUhS

On 2/7/25 12:41 PM, Dongli Zhang wrote:
> @@ -378,6 +384,11 @@ static void vhost_scsi_release_tmf_res(struct vhost_scsi_tmf *tmf)
>  {
>  	struct vhost_scsi_inflight *inflight = tmf->inflight;
>  
> +	if (tmf->tmf_log_num) {
> +		kfree(tmf->tmf_log);
> +		tmf->tmf_log_num = 0;

Just a small nit. We can drop this line above. We free
the struct on the next line so it's not useful.

> +	}
> +
>  	kfree(tmf);


