Return-Path: <kvm+bounces-58391-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 46968B92408
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 18:38:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F0A6F3B4EFE
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 16:38:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA544311C14;
	Mon, 22 Sep 2025 16:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="L+bh5SUH";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="WTcF4+pe"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A3226CE3C
	for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 16:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758559097; cv=fail; b=ZKko5lhATU+E4RbTbARR0RUX0gchTTxru+NpVbzhVI+bA63fH+9ohQN8p4T+2vnxVE1UK45n6hDE1NWWaQ3+Hp0MFR7yXAcRi5Txl3Hwl92iU/ynW0CVoUBA6nx0Nu7H+PYt0dkcUYIO5aCrVBdipWS4RAv4kDH5uXd6n6v252c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758559097; c=relaxed/simple;
	bh=1GJ05FRgY+LBvbdNQ816Mjf3Ali2q5TS6uOUT5DVH8A=;
	h=Message-ID:Date:From:Subject:To:Cc:Content-Type:MIME-Version; b=rsNBmulziprj5cpH2zCjmW6nHni1EcpeXJcdhgaxE18X4RHhE9BgIMhJBRk52LLeHplrvIA4famivDUrAzhHLrAFZqRRLH96jCBIzzO72h3Jm/VaOZbnnRwSW3TnbCg88XeeYCQiiSN+z2rgTqnyw+BuTp5Acj7Ldxq0rhJKR14=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=L+bh5SUH; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=WTcF4+pe; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58MFgVmV030272;
	Mon, 22 Sep 2025 16:37:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=dSuTRrUyv6D+pf/p
	HtMRZJF7k0xO8Ak/jT2yYPN5Y48=; b=L+bh5SUHNV7rEFBtLGqdGdTY3fkGPQd3
	NBwp5K2nBAydHqHfYN5P8A5gzdqBVGtSzuYcb1Z2gdR33YPJd6OwC7DANpUa2vQf
	O7nhC3duH/ztVKmu7HfKbg081zYg40W5T2GNSJHU3T+Pg/bmAOOP7v8tYXdvjXeh
	xGh1imomK6X0OWNaktVV75OLuGa/7i6JYgDS98458SZmSivfWHTPp6xxp2gsD5M7
	A+u88Y31doJFsN1KpGdKob+7otltzm+NnHtdaPzOyHXXHosO6DvOwcFQdw/AXjjR
	asg0f4vnX/1JUuTwIk5XBGh2tjy0LbWbHOddUUnon3eRqPqyLjQgBg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 499k6atvjp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 Sep 2025 16:37:55 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58MFeDjQ034365;
	Mon, 22 Sep 2025 16:37:54 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010036.outbound.protection.outlook.com [52.101.193.36])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49a6nhgxgu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 Sep 2025 16:37:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vnLq03ioXeBBLysVCraVWbvqHMV3U3eK6Y0EEXJz99EgY+hCwm8+WBUAjn4VI37HGD0RN4zJewyS8+K/AAp6GK5shKAMVwkTMzeCzETkhoWFkHLbbFVLWhz7UVq9VJfYUlbKstBo12vgM9S69PrlLl+Z5vO95RjC7FbiYsDyYay6fFkaoZA4CtFnSIeMpIUYm4hnXp5jwJhCSXzjIjYCv1dqZA6MviQ+bJ287P5AYH5FK5u3xevonTW1NOcEfoIODZshBKVcDDEUvidtnnmkIExd3s7FT7oKwOYXJC3loyenU3GNymBXhT0fJ24sTdBVotFQHRcbS9+9eBYsSr44qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dSuTRrUyv6D+pf/pHtMRZJF7k0xO8Ak/jT2yYPN5Y48=;
 b=EnQzwBfpcCMWs1hBRriLmusvLYtP1+YxXNdzXNLx/LNZAcp4nmh4Br+d7yyjYdRFWylCViUCWhwUzFQbh0Gml6eNGvWBqYvlfEMYUI+0mzQ4kuwRRsZH/BDhmlU99IvmaOoi2ixqLpqctZvvhtXdH17iBmmRvzavcAx9VycjX1AGiONPu+FUh3ZZIVpyky7Ay/GW2kFT0Ljt8ejXrZxlDBo+KCzHypRJTH+xdY20Vfk9d2ExEc6iap1YA66jrNWGNPZ9FVy7vLGZXb0bpUIY5/PMtA7iAM8BsNz6kHQuF/mQuIY71FG2prX37FRSTY6ZIrQXaozBjv+i1A77iEB+3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dSuTRrUyv6D+pf/pHtMRZJF7k0xO8Ak/jT2yYPN5Y48=;
 b=WTcF4+peVwJ4830jzIH8HMNKem7EMK74WqxgIBm69278Pw2CsGCSk6lKhfMEzCL7YI7Nk//APhb8EeMy2NBZVZFG2BM38YudragS7XCcYylUIrqhrMFhwa1iZ1Wbkr3OUbM/P8aHZXhFeFv+tfU7oOnqh5KIaWlhRyjHIIBJfJs=
Received: from DS7PR10MB7129.namprd10.prod.outlook.com (2603:10b6:8:e6::5) by
 SJ0PR10MB5785.namprd10.prod.outlook.com (2603:10b6:a03:3d1::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.19; Mon, 22 Sep 2025 16:37:51 +0000
Received: from DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::721c:7e49:d8c5:799c]) by DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::721c:7e49:d8c5:799c%3]) with mapi id 15.20.9137.018; Mon, 22 Sep 2025
 16:37:50 +0000
Message-ID: <2d375ec3-a071-4ae3-b03a-05a823c48016@oracle.com>
Date: Mon, 22 Sep 2025 09:37:48 -0700
User-Agent: Mozilla Thunderbird
From: Dongli Zhang <dongli.zhang@oracle.com>
Subject: Should QEMU (accel=kvm) kvm-clock/guest_tsc stop counting during
 downtime blackout?
Content-Language: en-US
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, dwmw2@infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH0P220CA0026.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:d3::7) To DS7PR10MB7129.namprd10.prod.outlook.com
 (2603:10b6:8:e6::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB7129:EE_|SJ0PR10MB5785:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e6c390f-4b98-45da-d7b8-08ddf9f65e54
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UDhpWFFHZUFWSCtUZ0xwYkV2UkVCdmRFRHMwK0JZaGQzamY1c2RlNTlDVUhW?=
 =?utf-8?B?SjNIaDVucDZXZnJMYzRIOEkySzVrZVZkVy9pNG4wYU5WbHdYRVE2UFprS2ZB?=
 =?utf-8?B?RFF1RG0xaERGMU9SWUxlMEM0dVBNSFVZQkw4emZjU3RET2Fqc0RDMVBoWnRU?=
 =?utf-8?B?ZTlENTNiSlV3V2oxd0lBck5YNGVJY1BUUHFObW95RjVFWGdQL2dCUnNHR251?=
 =?utf-8?B?YjRtdjJJVERsd0w2TjdqS2lhd09ZYUJQY2JNelA1V0w4bDlLLzJIbDNaeXpW?=
 =?utf-8?B?UVY5ZEFiZFQwdkppSkFZYW5MUkNBc0RWZnIwRWZMWWZMZ0EydzhSWXUrVVFq?=
 =?utf-8?B?RjAzVXdjcy9SdWhlTldsUjN0d09ZTW9Yb2cwVEpNQ0FOWng5K3FEOXY0SDZo?=
 =?utf-8?B?SkVZdzRSV1c1UEpUV1dSc0U2STlQN2dON0VvcDM3ci80Qi85eEx1K3RHek9H?=
 =?utf-8?B?bFFhWll6Y25kYkJTMUpuUlBzcW5NajZNb0pFYkpIQkNrc0NOcGFBd2d0SWN6?=
 =?utf-8?B?THo2R2k1WVNJak1SNmQxMUh6L0MyaUp6TjdkQ01iU05rWG5aRzJzU0lwSExJ?=
 =?utf-8?B?ZXc0YVNNeU1DaDhEQTFZL01ocElROWJRTHJqWk04dlc2ZG1yb2poWGNNK1FU?=
 =?utf-8?B?czZMNUcxb2dGeTdNaUcxMEl3MndOT3U4cGtkRUJINjBnSi9IUjNYanVRRVdR?=
 =?utf-8?B?TW1ONm9mSTduWndlWHJLWmZDMWx6R3RvOW9sV0hWeGlhL3pSSDZ6bnNoWEVW?=
 =?utf-8?B?SnU0bGlRVU5GcE1JS05LdldYZFh5bHBibHJLQ1Z4L052dFZhM2hxaUoxaUtI?=
 =?utf-8?B?ODRQZ1FYdWZObTFZUXZvN1EwME13d25aVjhQVnpnWWhnTkJBbTZxLzlFMFdy?=
 =?utf-8?B?RHl5R2pGVFNwcis1WjMvTTNtQmxZYVUyU1dEYWpmQWovRW85RTFmSjlHcFpB?=
 =?utf-8?B?am5HWW0zcm80eGdsZnUvM3YxZmxKalRrSit0Zk1LUVprbXhsMzI3dU9oazVU?=
 =?utf-8?B?MHErMElsODVvL2dUVTh1Q2w0UlVmVWdSNWNOVmUwYk1qaHJaYW82a1psWWta?=
 =?utf-8?B?TytCZituMWFOMVlIR2YyNVZPZ1lqUVdheFY5NVE0YlBpTXFIVkZaNmExcEhz?=
 =?utf-8?B?UWZJSDJXR0xWZ0ZVbnRPNFU1RGF2REgrMUVsOVBYcDN6MzFoREhlOHdWMG9P?=
 =?utf-8?B?QUc0Mml1ZFpmZ1Q4WVJkSFNhVUcwWnRFcndmcnNGb3dQaEs2OHllNlQ4Wlkx?=
 =?utf-8?B?a3JjU2dVK3I1akFRZ1AreDBDdjVuTWFLbzE3akdHSjhWN2lPTzQrK1RWeEtJ?=
 =?utf-8?B?TFMyb1pkSEJXek1mcFZIYi9VeWw2NEx0VXN0Y09zRU1pQWZycjh5OXhKeHVO?=
 =?utf-8?B?VlZ4UjJ5dS9ybDVrWmJWY3AxMGlzZ3VncWgyaUsvaHE4NGhwZUUvMmlEdE4w?=
 =?utf-8?B?S083U2RHaUtnNUZJUnkzK2RpSjJWcDJtNXlXNkFleHlqU2Nrem5FaWZYQlo4?=
 =?utf-8?B?WjlUclFxYnhvRzljOGhUMktYNzNnNEpzYlRvV2VMOTJZdnB1Z1hjV0tnS2dQ?=
 =?utf-8?B?NlUwOG9yMGhtRlRoSTRUM0Q3T3ZqWC8rWGhGZDVlUkVIbWgvVzVmZGNKSWpm?=
 =?utf-8?B?QzFveWQwNzZCNlczaEVkWEpzcDY0ZEVyNzc4amhYZUltdjF1Vnlic3lQMFpq?=
 =?utf-8?B?R1FhMjM0TWNnWDh5NnNCLzZOOEtTaGlqeUlaazV3ZDZ1bFVMODdIRWhPRHV5?=
 =?utf-8?B?SkcyYVMrU3ZONGpjOHR0NjBWZVg4bmNXZEF0MHdLZ2NGMXdDMTNWL3VnNzJI?=
 =?utf-8?Q?Pm2CLAIWQHZwvFkxARiJeOiVOdc08F5Z1tP+w=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB7129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V0NuY1ZzSmt0NzVSbWlVYzBKeUxaVDlZb1o1RWxBaVRzbG1BQjlWZ2hnRkN1?=
 =?utf-8?B?QzNYOGhkRGRUYlN3RG1FSHZ5M2JqUy9neHZVZzBCdXlSOWVLV0tVUDlOTlpP?=
 =?utf-8?B?YnpraWp2YUhvNW9YbWh6dDlXRWFyUGlrckh1UVl6Yi9DdlByaXJwanBZS0FD?=
 =?utf-8?B?SHdya2RIeUNPMzdGQ1BQYU5YRTM3MVhhZ3RaVFlIbUxFZGVxaDNsZjdKTUtN?=
 =?utf-8?B?Z2ptLzFTRU8wRkt5aHl6VXZoQ2pSZ29hUEVWZTFxUjFydWY4TFpKbWRjNXpn?=
 =?utf-8?B?M05xWmkwSnBuMVFSb2ZkZUV0emxoYTd1NUlvMU5nSmNwOFA2RWNIOWxRQ0F4?=
 =?utf-8?B?ZFhBKzFkUndET24vVTRFTWhzY2xMVG4zQkNwVFhXSUU3WHJqb2tHRTc5akhs?=
 =?utf-8?B?VFA4M3NIVjBMT2QzN0Y5aUYwTzJCWXRWNGwvRG9oaml5R1U2bnVsYkZ5R0dM?=
 =?utf-8?B?R0YrNHJ3M1VpVlFzWFlKajZqVWx0R2luSDlVVzlYalY5ZjBGQzIvRytjdDlF?=
 =?utf-8?B?WC9BSmJveS9VM2hFK1ZIQ1NtUVcwWVMxSDJkSWxtZ3RBMDU3UExITkVySlVX?=
 =?utf-8?B?eE9jSEw2SnpKcXZSWUYvaWxYRFdIRFFCOEZWSzN5OERhSmtBakhqNkRwQmFn?=
 =?utf-8?B?OXR2NlZ5MEprRmw4SXBnbDlYQkdJc0xLMVB2NWpoSExVNXBMWTBwRHRNTlJE?=
 =?utf-8?B?aGNuL0RjVkRxR2pCSUg1eWxlRFVpbmRYbnBQRWpzN3F6RmphQ0R6THhwd04w?=
 =?utf-8?B?b1d3ejFIZ1k1cjJBdy9TbGcrS3laRDFPcUVTbGlWY1VvbUhhbjFqNllOTVhs?=
 =?utf-8?B?aVJoQ1pxMVJ4dW81dnEwdk5wbUUzbjBtd2xkWk9XMENrWGlSVHhiZWlYcFpC?=
 =?utf-8?B?MlBSMEY5L2wySXNNQkl5UkhrSEpDR3g0cmJyK21nQUoxSHVMTjY3dnRzaVNu?=
 =?utf-8?B?NjVGRTNQNG4rY0xtdlRQSUdhTDdpS3F6ZERJanF1UVRFK2pYUmxYRGd3bjRa?=
 =?utf-8?B?WlEwWXg1SDE0N3pXbUFlbHJTSVVBbTZCYVkra3I5dkJLQ3Qwbk5ySlZSbXRM?=
 =?utf-8?B?cTFFdDNEN283Tm9UaXZ2MjBCMVFVZGkzV2Vudm12QXE5aTVhdlRIZGN2djV6?=
 =?utf-8?B?UTh6Mm9vUUQ3TkZWd2VSa0RVTFdqNmtYWHIwM0w0OXJPNEZXZFRBUnpLWndG?=
 =?utf-8?B?V0xLT1dlRGk2VjFWTDhZZU16QUo5R2dEcDNBSVFOUXFYT0w5UU1CallKanpB?=
 =?utf-8?B?ZERwN25yQ0tRTmZ1TmxIS2NvY3hUbDNUc2RNcmhzNEhFWFNLMlN0YVB6QTY4?=
 =?utf-8?B?RjFwWko0R29yV0N5N2NaZ0sxb3N4U01Cd1Yrd2Mxbk5YNXNOa0szbnE4Tjc0?=
 =?utf-8?B?R2U2UVIxQ2VqUEx5ZGxEL3ZINGJxUE04Yk5uSSs5VnZqdEszeHRhNUxYRFAr?=
 =?utf-8?B?cldLVzg3M0gweE1LY0QxQmMyZHVXTnV1eEx5SW9Scmswb1NOQ0VjcFNkVVlv?=
 =?utf-8?B?akRXbEhaTzY2akx3dmNaUFNBMlFRdDNoQm1GSGt4a0ZxRms0T05rdXJuVjdt?=
 =?utf-8?B?MGZmeGVKdTg0VDZqMmJzamRlbDlaWWVuTGVZdEY1MnJDSVY3SWtTdEwxSUlx?=
 =?utf-8?B?K2xjNmRRaEI1ZFBCdU90VGhPUnBMMFBsa2hGZzdxNTFKK2ovZjlGUWtSWURP?=
 =?utf-8?B?aWJQYnVCTDlJUnE3TG05U0dvcThHOHI3UU85cUEvY29ZQ0dUK29aV29ZWDd5?=
 =?utf-8?B?WnV5MStmUWpIeVJYbG1pQUxPTlBBTStoV3k3QkdXMVMyUXNFMDZkVFJ5WkxZ?=
 =?utf-8?B?SThSSjRaWmplcEtldXBqN2l6TWI1M3NQWWpsYnJKaU5pWHJuRDlVWWtvTksy?=
 =?utf-8?B?dElYWmJxcFNoMTdudStIcTIwME5YWnAzUXpxN2lKN1I4NWlnaXFTUWovMnpq?=
 =?utf-8?B?dTdlS2RxamdaSURrN3lmRGplbHRsM0JsV3l1VFFGbkp5QjQ1aDUrZkthTXpy?=
 =?utf-8?B?eFlobXJQVzFnVXQ3WC9DWDNaY29tL0UvcnFNOXVnUUtlSHo2eldnZnNldHZh?=
 =?utf-8?B?M3pFcHA0OHg2T3RDL0kzRFE1S2ttNzlKSitLZzFjWm91WWZrQXFKS2Y3Tkgw?=
 =?utf-8?B?cXowZmpqaFZHdkFONnpiRXZnYTd3MjMyU05vNk1nMFZ2QmJObmlCWTlZNTdM?=
 =?utf-8?B?VGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Krrz5GyIdfJeoa3EZimJWq7f1wd/JJIjN++m0VeZepN9v/a9mK0J89q9XhwwQCzb/Yvs1OaWS1hSfgHBR3HM9vYWkVoCYiXWwFE2MW+fpZXQ2zdVNuQAPSmCAkNwbLXcaANlM8ob4BQhTYt9xI2/iUVgXka9LrZtyzSXaZZKwDfsL03NczgTW2RoOGPWHOWadzVtn20jHP5Jtne2/L3mx8ZmnjYSUxzb+DTGSQST1E5FGfx90UY+US2QmUs/HNCI+s9CfyRjaMc/Jl0JYE/SldcznwPTQWZfgMvVC2sjrGKbWK4Ne62DWKJve1ByFtHp1Zq7SPpmGcHpRtczfWBmyGRYZ6E8fc5sqHsxfVirOngXybZEQbDnHVmBU+BS2ptydVhXGDlDc2tZkMtOMNWNUoRuDRBLUucQ7gVBdxd6HBrBhNSnzQwOEu88EO4hacjGI7qkqeUb6mjly+67WW5ytV04b/08ZY+hIaqANrTbhzDvCcAiU3MfRgNjNmipKyfWmwLJLipvQSY4n4cHC4+9sVADebSVvuJjCC8mGSPghabS/Nhkmm3I5tq/8QXPxR1Hb1UKzntE1q30ZzhnwmvOWtYEngw4PoldtSnzvdFYuNk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e6c390f-4b98-45da-d7b8-08ddf9f65e54
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB7129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2025 16:37:49.8724
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cV6Tu/CiM534qtekHgadtz1jH+w6GY6Uwz+47EDYDSvjforGjfeTsrfom0G0mMpavFsOmHAMpfbEcgWHfKQ+7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5785
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-22_01,2025-09-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 spamscore=0 malwarescore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509220162
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDAxNyBTYWx0ZWRfX+xmERdkHEF8k
 BZNEY+Wirs/g0HmEN0dkK+bZMg+yoHsCXliHsiXMVPQ0PnNB0tZO9cqPkLMI/XDVY+lhf3AF5Jo
 0zVkmjOM+SUJRJvJfFps6IaVM2mP8/+3oGRILoiAGXZedW9FYcnWWib+JXZVjA5ifs3VDO9Bw3O
 8fzz4VEh5u3C5+GMpeNJEOALN+glipWXK7EQI+rs/4vusEgwU5uUW4qlGPi1dDTtPzw8fyg+XDy
 BTmDw8JQ+NEVVqo5ieY6CjFVsQdJlY0+qExB6EYqzjF95jMCST6yM0NpyPrq5Dn4GB8NwMhgP6q
 uVAi7pG9dEzlRyboGJVgNxZgPfRzgc50yRAuJqXf00lzKMjVarkpu0yjcz1WQsiT+5FAbnKGNQ7
 EyIFD5h1Zrb2OgyFhWuwFkfGbV89Mg==
X-Proofpoint-GUID: 95pwAn0OXSr5ALTX_bZX-N7a-n-_fker
X-Authority-Analysis: v=2.4 cv=E47Npbdl c=1 sm=1 tr=0 ts=68d17b63 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8
 a=yPCof4ZbAAAA:8 a=uUGVTsTA-Yh1XSuKgd0A:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:13614
X-Proofpoint-ORIG-GUID: 95pwAn0OXSr5ALTX_bZX-N7a-n-_fker

Hi,

Would you mind helping confirm if kvm-clock/guest_tsc should stop counting
elapsed time during downtime blackout?

1. guest_clock=T1, realtime=R1.
2. (qemu) stop
3. Wait for several seconds.
4. (qemu) cont
5. guest_clock=T2, realtime=R2.

Should (T1 == T2), or (R2 - R1 == T2 - T1)?


For instance, suppose guest clocksource is 'tsc'. It is still incrementing
during QEMU downtime blackout.

[root@vm ~]# while true; do date; sleep 1; done
Tue Sep  9 15:28:37 PDT 2025
Tue Sep  9 15:28:38 PDT 2025
Tue Sep  9 15:28:39 PDT 2025
Tue Sep  9 15:28:40 PDT 2025
Tue Sep  9 15:28:41 PDT 2025
Tue Sep  9 15:28:42 PDT 2025
Tue Sep  9 15:28:43 PDT 2025 ===> (qemu) stop, wait for 14 seconds.
---> 14 seconds!
Tue Sep  9 15:28:57 PDT 2025 ===> (qemu) cont
Tue Sep  9 15:28:58 PDT 2025
Tue Sep  9 15:28:59 PDT 2025
Tue Sep  9 15:29:00 PDT 2025
Tue Sep  9 15:29:01 PDT 2025


However, 'kvm-clock' stops incrementing during the blackout.

[root@vm ~]# while true; do date; sleep 1; done
Tue Sep  9 15:35:59 PDT 2025
Tue Sep  9 15:36:00 PDT 2025
Tue Sep  9 15:36:01 PDT 2025
Tue Sep  9 15:36:02 PDT 2025
Tue Sep  9 15:36:03 PDT 2025 ===> (qemu) stop, wait for many seconds.
---> No gap!
Tue Sep  9 15:36:04 PDT 2025 ===> (qemu) cont
Tue Sep  9 15:36:05 PDT 2025
Tue Sep  9 15:36:06 PDT 2025
Tue Sep  9 15:36:07 PDT 2025
Tue Sep  9 15:36:08 PDT 2025
Tue Sep  9 15:36:09 PDT 2025
Tue Sep  9 15:36:10 PDT 2025
Tue Sep  9 15:36:11 PDT 2025
Tue Sep  9 15:36:12 PDT 2025


They are many use cases that can involve a long/short downtime blackout.

- stop/cont
- savevm/loadvm
- live migration, especially from/to a file.
- dump-guest-memory
- cpr?


The KVM already exposes 'KVM_CLOCK_REALTIME' and 'KVM_VCPU_TSC_OFFSET' to help
count all elapsed time.

https://lore.kernel.org/all/20210916181538.968978-1-oupton@google.com/


This is a prototype to demonstrate how QEMU can count elapsed downtime by taking
advantage of 'KVM_CLOCK_REALTIME'.

From b97a514ac227645010ce3d1012af3a4943413844 Mon Sep 17 00:00:00 2001
From: Dongli Zhang <dongli.zhang@oracle.com>
Date: Thu, 18 Sep 2025 14:59:42 -0700
Subject: [PATCH 1/1] target/i386/kvm: take advantage of KVM_CLOCK_REALTIME

The Linux kernel commit c68dc1b577ea ("KVM: x86: Report host tsc and
realtime values in KVM_GET_CLOCK") introduced 'realtime' field and
KVM_CLOCK_REALTIME.

The 'realtime' value is saved through KVM_GET_CLOCK and restored via
KVM_SET_CLOCK. This enables the KVM clock to advance by the amount of
elapsed downtime realtime during operations such as live migration,
stop/cont, and savevm/loadvm.

This patch/feature allows QEMU to take advantage of KVM_CLOCK_REALTIME.

Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
 hw/i386/kvm/clock.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/hw/i386/kvm/clock.c b/hw/i386/kvm/clock.c
index f56382717f..906346ce2f 100644
--- a/hw/i386/kvm/clock.c
+++ b/hw/i386/kvm/clock.c
@@ -38,6 +38,8 @@ struct KVMClockState {
     /*< public >*/

     uint64_t clock;
+    uint64_t realtime;
+    uint32_t flags;
     bool clock_valid;

     /* whether the 'clock' value was obtained in the 'paused' state */
@@ -107,7 +109,10 @@ static void kvm_update_clock(KVMClockState *s)
         fprintf(stderr, "KVM_GET_CLOCK failed: %s\n", strerror(-ret));
                 abort();
     }
+
     s->clock = data.clock;
+    s->flags = data.flags & KVM_CLOCK_REALTIME;
+    s->realtime = data.realtime;

     /* If kvm_has_adjust_clock_stable() is false, KVM_GET_CLOCK returns
      * essentially CLOCK_MONOTONIC plus a guest-specific adjustment.  This
@@ -186,6 +191,11 @@ static void kvmclock_vm_state_change(void *opaque, bool
running,
         s->clock_valid = false;

         data.clock = s->clock;
+        if (s->flags & KVM_CLOCK_REALTIME) {
+            data.flags = s->flags;
+            data.realtime = s->realtime;
+        }
+
         ret = kvm_vm_ioctl(kvm_state, KVM_SET_CLOCK, &data);
         if (ret < 0) {
             fprintf(stderr, "KVM_SET_CLOCK failed: %s\n", strerror(-ret));
@@ -259,6 +269,7 @@ static int kvmclock_pre_load(void *opaque)
     KVMClockState *s = opaque;

     s->clock_is_reliable = false;
+    s->flags = 0;

     return 0;
 }
@@ -290,12 +301,14 @@ static int kvmclock_pre_save(void *opaque)

 static const VMStateDescription kvmclock_vmsd = {
     .name = "kvmclock",
-    .version_id = 1,
+    .version_id = 2,
     .minimum_version_id = 1,
     .pre_load = kvmclock_pre_load,
     .pre_save = kvmclock_pre_save,
     .fields = (const VMStateField[]) {
         VMSTATE_UINT64(clock, KVMClockState),
+        VMSTATE_UINT64(realtime, KVMClockState),
+        VMSTATE_UINT32(flags, KVMClockState),
         VMSTATE_END_OF_LIST()
     },
     .subsections = (const VMStateDescription * const []) {
--
2.39.3




To take advantage of 'KVM_VCPU_TSC_OFFSET' can further improve 'guest_tsc'.

Any suggestion on whether kvm-clock/guest_tsc should stop/continue counting
during the blackout? Any expectation or requirement by QEMU?

Thank you very much!

Dongli Zhang

