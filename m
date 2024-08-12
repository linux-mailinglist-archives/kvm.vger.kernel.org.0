Return-Path: <kvm+bounces-23920-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DBFF94FA09
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 00:57:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 113D5280A9B
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 22:57:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DF4F19B3CE;
	Mon, 12 Aug 2024 22:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BUMeIG2s";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ZYTlQqyl"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E6319AD70;
	Mon, 12 Aug 2024 22:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723502997; cv=fail; b=uzlgXt2xLWXhIqQNRI94PoDGWuYZQ5XYj3Op3OM6CiUZlOInib/0C6PRq8ye1h5WX4Dh0izgRkNkjTlGxJCrGr9+yHurTCtAtmQmlJLhIM1mWr+u00Sb2Z/T2+UtRnNXbUBpVes5hzS294JHj1P+mxjcTZaOiEcRWDd2kCbaCiw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723502997; c=relaxed/simple;
	bh=9trgygyngn3qK1uPANa3iBOu+NAu0+CBm0x7V8U+1MU=;
	h=References:From:To:Cc:Subject:In-reply-to:Date:Message-ID:
	 Content-Type:MIME-Version; b=ugWCbQhT+owtyTAd0URpMvpjky+BHemvaITWQ0F5tAjV/P1YP28cGpWkCRla3T7h+aEX5qG/VDco4ez6A/EFy6+QLcpvQJb2ruwXrNidTgVF8oMNUD5mbFnmqeI0mSUoulpZUoPh7tuyjLMKMHiOZZQ8jozLtqvZHL3WHbUlrFk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BUMeIG2s; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ZYTlQqyl; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47CL7KOv002285;
	Mon, 12 Aug 2024 22:49:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	references:from:to:cc:subject:in-reply-to:date:message-id
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=hT5UnLvRn1puLX2oWaeDPbtP/nK7/ppWykwb2nnCmwM=; b=
	BUMeIG2sqj7mUnCreKAV+pwO15jGHlsW4gn59Sdf3ls/WdW9GdeC8FbziWT+57tq
	RokbvVn8By0HliSWjyD5wQzzOijvGAwCjo1AL3MkwDZbBHkc5tRuYoBb9DsICyHM
	uWbWn+sQVF4eV75F8fesLUfzo+LSSpkVUDicqGUjaxpJU2ryd1xqj8rrRxHh+BbF
	KixTv7yEdzBPywLN8L/IL4iWbuOj+mVrKXCYIryFhDe4qjZ3bjSMBbEZHYdQla0z
	hyg9V5B+NQwS/5qpVS3Et6ZKJS1H6WjirdvF1GncRNroQ8k12dUctryJGWu3BEWq
	lIACw1dkq3OheKg0tZeVUg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40x0394m82-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Aug 2024 22:49:04 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 47CMbPcJ000621;
	Mon, 12 Aug 2024 22:49:03 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40wxn7rww3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Aug 2024 22:49:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rMIFXvh/210ilc96nBRnM13yDvIVQCsGgk0U74yt1eHJGJ2h0QmAfehtvukVBDQBuehPzKGRfrbt7WSqiQLIWQqGWn0LvrBoDdcao80+bbfzLHBNlxH1lFSiTPZ0NzEuNoBVjP2VGuGFnocy13tW2RGyvv1TOiPmI5l6jbcEjHa+D1O8bkv1+kKYb3NTPwcyNZ/LadeF6EJ2EWzOC7mxt0hK/MzdXZjQ6oX3OOR2ZlwobTkJ7CNEHd/d8St5Q6DbidIe0KUkVDDiUD58JiSzvBPQckjCTkpXHm78WFFmiWfHuqHyVJULu7KmnoTzBXXXEQNaIkDRP75NfbtyY9ZBLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hT5UnLvRn1puLX2oWaeDPbtP/nK7/ppWykwb2nnCmwM=;
 b=PVrJi0tjOajaiTqKVHWY9YW3oUjBf/IVKwr7Z158se1nKyYXxotRuNE4+xoZruuiBnaf56jEWG9RTC6Ln4jTaA1akvqQacwQXdFWbixrXeJePMqrWDtMNqfu/QTj3iSwNxsn81fysRHGbKcR+k/dhPTYdURQAjRlL83EdyVUcp39XifKf06QeDZaW4qTe3fscp/Gusp3wsr+uyvKHUZLYruk8H3D55kgmPYnL+cHkFvfzQi7jwMeSLmGMHznM39zI8hzYo7/a84q/iQACr7iQBfYvmPXMBLtz2bvldcLiosWRlc+KFeV42dj3zAGXfDudenock9N7Ssc8LzeS16Fdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hT5UnLvRn1puLX2oWaeDPbtP/nK7/ppWykwb2nnCmwM=;
 b=ZYTlQqylhB5nViVVSVWpqFdRS+AehwgGk3oiWm7bUz3ASZFI4YVPA5yzLWfhb7xHFAXN9dNJsNBvcDZBfQe5kfV7wtqBrIiKz0sP4tTbLMH0f3uMCPyGVz5mW3KtD91fLGHMVwmkwffTCO9dRrAGnJ06bkyeEyGqY3yqDCLFJzo=
Received: from DM8PR10MB5416.namprd10.prod.outlook.com (2603:10b6:8:3f::19) by
 SJ0PR10MB6421.namprd10.prod.outlook.com (2603:10b6:a03:44b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.13; Mon, 12 Aug
 2024 22:49:00 +0000
Received: from DM8PR10MB5416.namprd10.prod.outlook.com
 ([fe80::e085:31f:84d1:e51a]) by DM8PR10MB5416.namprd10.prod.outlook.com
 ([fe80::e085:31f:84d1:e51a%4]) with mapi id 15.20.7875.012; Mon, 12 Aug 2024
 22:48:59 +0000
References: <20240726201332.626395-1-ankur.a.arora@oracle.com>
 <20240726202134.627514-1-ankur.a.arora@oracle.com>
 <20240726202134.627514-7-ankur.a.arora@oracle.com>
 <f1a5d666-d236-572b-f9fc-5adeb30be44b@loongson.cn>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: maobibo <maobibo@loongson.cn>
Cc: Ankur Arora <ankur.a.arora@oracle.com>, linux-pm@vger.kernel.org,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        pbonzini@redhat.com, wanpengli@tencent.com, vkuznets@redhat.com,
        rafael@kernel.org, daniel.lezcano@linaro.org, peterz@infradead.org,
        arnd@arndb.de, lenb@kernel.org, mark.rutland@arm.com,
        harisokn@amazon.com, mtosatti@redhat.com, sudeep.holla@arm.com,
        cl@gentwo.org, misono.tomohiro@fujitsu.com, joao.m.martins@oracle.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Subject: Re: [PATCH v6 09/10] arm64: support cpuidle-haltpoll
In-reply-to: <f1a5d666-d236-572b-f9fc-5adeb30be44b@loongson.cn>
Date: Mon, 12 Aug 2024 15:48:56 -0700
Message-ID: <87plqdqrvr.fsf@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MW4PR03CA0245.namprd03.prod.outlook.com
 (2603:10b6:303:b4::10) To DM8PR10MB5416.namprd10.prod.outlook.com
 (2603:10b6:8:3f::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR10MB5416:EE_|SJ0PR10MB6421:EE_
X-MS-Office365-Filtering-Correlation-Id: a9aba137-96a9-493d-bdc8-08dcbb20f3e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NTZSYm9RUGM4dW9LM01URUphVGVyVXJoQjdOT3lRTHhZMVFwVUs0L0VUVzB3?=
 =?utf-8?B?UjhtYXQ0WUkyeU5DRWdwc0JjbmdreWhOTEhvTXlrWmh5S3I5cXl1TXBjMVIw?=
 =?utf-8?B?TExBQTlua1hEWnVUWmVSZ3FZQml6a29IUnB3a0czcWNXU2ZRdms1TU9rRDJj?=
 =?utf-8?B?cmhRR0ZxVHI2eW5POUJubHJVSmtPVWFvRU9iamlPOElLTllza0pwZVB2bXhx?=
 =?utf-8?B?RW9ieVJVNHoxOFdMTDFYY1hpcit5UWZKT0xPR0I2YUFuc09tV3JhMXJZVVZw?=
 =?utf-8?B?blpib042SVZnUUI1aXQ2VUpCVUY4a04xa0d6ZmNFNVhXMEw2OFQ4dEJvQitU?=
 =?utf-8?B?dVR6QjIwN2dFMVBsNDd3bjJvQ3RkMFJOYXU0cEdMK0lqWTFubXQxODNydHpH?=
 =?utf-8?B?MFNYYlp6cVpxZ0txbFdpY1h3Q2Q1ZzB2eTl3TFNrWVYraC9QK1BockE3cEtj?=
 =?utf-8?B?RzdlS3VQMm1qUEpDT3RUdk53S0dSNVF6TmlwUlhZak14V3FONWs4ZklRUWNO?=
 =?utf-8?B?WHpGenRIeDN6NWFJcEJnd1FlYkZIN09vb3loWXJBd0xoOWFqaE1zZGp4ajRy?=
 =?utf-8?B?UituaHEzK2dKZDdZYzVObC9DODV5bEFWelhlWFRjVExBOGJyQ05MRGlJNi9v?=
 =?utf-8?B?YTRGNkxrYktrR05tU3VnYTZ5TVJFTTMrN205elYvNDJYTStEWE9uQUVYTUhq?=
 =?utf-8?B?R1NzZGx5MVZNdm5CRHdPZkZyOFZFZUphRnVoZlYzdWZUNnhBZG1MNEo3RTBC?=
 =?utf-8?B?WjVPT2ZIMTBFWFNxaFdwUkFOTFN2TjNHZnAxQ0x4QUhHTktDRXF0ekF4aFFj?=
 =?utf-8?B?YTdPYzZjK295YlI3eFVLOE01bm9IeHcxWEpNWG5GMkZ6dnpQTVpuaWVYSUhJ?=
 =?utf-8?B?a2RyTEcweHgxRFUvRWpnMmZlTnkwS1lPZWJ6SGVDQ3pZcXRLN3FyMC8zL1VO?=
 =?utf-8?B?ZmxDQW1Cd0dhQkFVZk9UWDRaYVJ4Z2FROEoyOXBlN2dPZDhWSnpLNUQwYThp?=
 =?utf-8?B?ejhsRk5zTXdaZ3VydHQwOVZJTkphUHF3Z1ZRWXN5RkEwOEgxZXRVUWNwQ2hB?=
 =?utf-8?B?WHhSV29FTEZaL2NKcGsxM0QwaVU5dnZOSC9CV0hpdEFBVzgxWnBZRDYvdE9B?=
 =?utf-8?B?QW9pTElkcDFzSzk1MFdNQWZZRFozSGN6K0pVc2lsb252ZFpsVDdtR3FWRmF3?=
 =?utf-8?B?Ti9nWVU4Y0hWSjhlcllibkRzbVdwRjNCbkF2NEJ5R1FIS0VENStrbi90RS80?=
 =?utf-8?B?Nm96VTU1NERxQlh3dm5OYTZtOWFVa21tWGNrSmo4VHNiYXBhNyt4L3JWaDVu?=
 =?utf-8?B?TVd4aitUa3pPc0lZWFNpL0pxZVU2NUFEUjladHYxQmxjQ1ZUSFY3Y0hCUHlM?=
 =?utf-8?B?TjVlYzFRMXJ0UFpBZ0psTEcvbUtzTExXbmpzSGZXYUZMTTFGY3JhU3R4UXBT?=
 =?utf-8?B?T3pPdlZWdENOVlVYdFo2dWlSQkZEQVJKNEQ4clY4RS91eHl6bGFuZ2RLNm9T?=
 =?utf-8?B?WllGcTNPZEhtcGJ5b0NCTXdEZFB3Mlp5K3dXT01rQ2FUWlJnSkQ3b25jOUNy?=
 =?utf-8?B?UzZpeDIramJRZUlZaG1TdWYxdW5ZTzkxamRUYTZCc0Z5b09OdGlmMklMNU8r?=
 =?utf-8?B?S3lGWHkwc2JEdGtHQ3ppdHJpWTZvQU1VdDFBYTFPaGxIN2JrMFJ1UXhuQUJF?=
 =?utf-8?B?dkxKM0xXckJuY3Bhc3hnL1VTYTJGQTN5ZjNBWXVlUDY1QTBvN3laYjdUOE1B?=
 =?utf-8?B?TzNuVEtJaHIxY2FXdHhtRkVUazd4MEp3YTBPcHBNTlo3MUdoRVZKQUNXTGxO?=
 =?utf-8?B?UUZ5M0hTK0R3OExSQms0QT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR10MB5416.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SWpzdldIOFlPMFJzRG1RckhYOUpBbnZON3V4WHgxakZKZUowMjN2UFFONnlY?=
 =?utf-8?B?ZWtqSm94dVlncjF0WENoMnhyRGFiU0FKZmhmZktZQk51SkFvM2p1OVMzSHRi?=
 =?utf-8?B?YVNMMkJ4MytqSHhrbTZwRkkveUliaGdySkZXWk5Xb1pnY3A2WHVpVWw2MFV6?=
 =?utf-8?B?ZlJCWVNvSUhaZ1dzSU1nWnFxQWpUVklTUVVVSzBYcStFK0FNeVdudHhqU1NM?=
 =?utf-8?B?MkxDODJmLzg5L2ZOUjVhTlJsaGk4ZUgxK3JQb3VBV2hOWEpFQ1J0U0pCQ0hx?=
 =?utf-8?B?Yk1KWUFqWGdjQ1BmY05MZEU0R09OOXVHYm8rS203V1ZFbGVsNjdZSjVZanpD?=
 =?utf-8?B?ZVppcWFWeUNTZHdJa0RMREhTT3pENVNiRGNKLzBxNjdBT2x1cGpsL042ME9K?=
 =?utf-8?B?OEE3QnhlMFZCYWlYWEFvMUpLeHRiRjllOU56SXVBTWdXQ3VKb2ZTWnZJcVpD?=
 =?utf-8?B?UTgzNFRpck5uVkxmbUFtQktwK2Z4djhzcGxXd1QyK1ZZREJVcDZTZThnUUZP?=
 =?utf-8?B?eXJmZDZDV3RQUnI2UmNYOVVoYllnZ1Y3U1JpZW53Y3pKNVF3M1N0d1FoNXBO?=
 =?utf-8?B?bHlKMW8vbW9kS0VCeStZdzE2bENhQWV4VXVKS0crcDFDeE84SzNCQ3RZeVNZ?=
 =?utf-8?B?bTVMcGJMUUVXS05KU3N4TEZRZytGKzAreHlURmxYMmpKZVhSMHhuT0hFZlR3?=
 =?utf-8?B?aHFKbEw0ZVZJWU0xVDRxclhrWGtPZHNXckloNzd1THZoSldSRXBCdndFTU56?=
 =?utf-8?B?VWxuaDV2MDJmQmMydTc2ZXMvWlQ0cTFoVlkwSXJjdy9uV0pnM29XRm0wVlpS?=
 =?utf-8?B?bjNkVjlKRWZlOGoyMkNSaHp6VTdtR3hhVFBNVVh0TEhXNFRUQVE3THJaQm4x?=
 =?utf-8?B?WG9qMldrWk80MkFHWjZOYVlLNWQ0Z2lxZVBkdzNNN2VPSk5uL0M1N3NDRWoz?=
 =?utf-8?B?ODdzdEZiRjl0MldYeFBtQjZJdlh0cEd0bjdqdXQ4Y2VjTG9qYWJhTVFTVVV0?=
 =?utf-8?B?VWZvbk83OEUyN3BESU5VZHNqWUZSOFhKN3ZMT2RQVFRtQ0k0M3hCR3JCUlkx?=
 =?utf-8?B?QjVOT0VnUDNCcWNZaithYjhXOCtvZU9BcE9vT28ycWRDcngzbnhyNjF5bnBD?=
 =?utf-8?B?TWVIOUpybDNDeFEvZ1NWRk1QelZWWlJyZld2aC9QNUpFTnlVRUhKdHZyTVFP?=
 =?utf-8?B?YTUwM01hYS8rWmhpcFBrbjBKaVByOTl0bWxseFFJaUlxWmZYVWhWSTFoR2FU?=
 =?utf-8?B?ZW5QekI2MFdSU1d2bjFSVW5qdVVKZnlFSWJ3SUh1UndCTVBIK21yNDNpWGpj?=
 =?utf-8?B?NUpHZzlHUFRQSVMrcDV2ZUJiUHlQdjlWbWZzL0xtUFZKcXd0Mi81cWUrWlJQ?=
 =?utf-8?B?eXFuZlNOT1dpL01BSGZUYVRzemVRY29VOFJxV2dZZ0FGTG1DTGkzMEZXVS8r?=
 =?utf-8?B?S3dwdUN0Rmg1Y2xMYUdDQmREWkZ2cWVpUFZUbk1NV2ZNVUZjeEFFblVhZVBs?=
 =?utf-8?B?RWpKbWhUY3ZCWHk0VGUvUDhQVW1wVEF4dmpHV2FFN0dMU3R4L2cvV1lieXow?=
 =?utf-8?B?ZjVVdGpDVzdTb2E0Z0duQlVyb2NxRFZicEpPdVNMRFNXTWlNTW1OdkduTDAv?=
 =?utf-8?B?R3FLTUhKN2htNk56SDRXbHdJb09IYk92RnpIVTNsck1yYjRqaVVvakdPVTBJ?=
 =?utf-8?B?Y3ZGQWF0ZCtyWDllZFRZek4rZVF3QjFhQms0ckVEbitmby85SUpVeElLOWU4?=
 =?utf-8?B?blJwN1o0K1FNbVk5bGRFMlZISVVVRmxzdWlQM0w0L1dIUDRvb0dWbjE1R0xq?=
 =?utf-8?B?YjU3MkUwMDhKS1NqeDB4QTZ0cDBHSllseWQ5dnRwdW9jR3F5bDBIWU84R1k2?=
 =?utf-8?B?SUlUanpwYUR1OCt3OE1MSzlvUmVNUzRsVko1aC9RT3pSaHpaMU02RzNVNEJo?=
 =?utf-8?B?YmgwbjNUREVjai9lekN2aUp5UVROU0prYXI3RDE5ckZnSXQ4RVBtc0NkWFNn?=
 =?utf-8?B?Wk9lV0tpcndzOHVsZUcyWERjbHBrRkF1aUFFRTE1YUJuUmphdzFBRU5mZ1Vn?=
 =?utf-8?B?ZXBETlR4OXVqdjdLMURNQzF5UjRiVE9pZnJwMXN3VHNQS0U1K0pzMFd1U1FY?=
 =?utf-8?Q?7+l8p9vI+20hS0yea5QqGkvFZ?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	u3lJLH6uFeQ+Ulde1Tzcq3nKJ24qBbrH1CB5jUBFWRgeyG0HVvq+aBL0Da/0U2NwamoQdX3LbyA6r2VhQdHTLPO4UK6wDutILqCew3hkQ/YRQmZXDKkc/mFMYSAb2NCvmZMqvrY93GFOlnFKuhjIQGotY0MCepQr1gwk5PW8ml2aRDdbn7GEsywve4dmdFYYASlQZ+ipY+/BaFMqneCtKgkPYqznbUKEQExoMizf1rum24drwIxK0eD94+ga4PYD+U+8yxAZP+1jtCGW7Jc96fXNhpwMrx7Gz5nz5wDtyXloHSkHFRRtlUlbbaACDX5B2GeHFBafVx0tlQ8VFhwA/jZrcPxCODoaReyPq8Uf0/x6aBAwHINqGZfKbUKh2AGcp+iATVZswBKv/wP26GZQpa3Ex0lZpMPJrzBDd4xLn4Ib6k7mS+D9LF5k33inkHaCWUqCT/yi1QKUsYuzTwJgZPse6U7cPmcKS40d2anzCZdwVpz3ftxX3/H/99ItVApYtRA+Mct61c+Xwd8zz4aj8OHpPFyC+tAlCtKDfFQn+rWb3gAZ0AI6vg6TyrouIvUtWwF4RIkhDR9XRxuUig2fMungHhNrozzk24heetNuo50=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9aba137-96a9-493d-bdc8-08dcbb20f3e9
X-MS-Exchange-CrossTenant-AuthSource: DM8PR10MB5416.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2024 22:48:59.5693
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6y2J6fFtu1fm0JujZhoa/+NR3HqmjQNzR9uXowfiYwubrihd1LGCFZL7mVEQncfXCbSaxWjzjIhU8+4TR+/WHjNaLGZQ3Wm9EAV+08lW02E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6421
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-12_12,2024-08-12_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 mlxscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2407110000 definitions=main-2408120168
X-Proofpoint-ORIG-GUID: VI6L7iyWBY6TqxjXPgh9PoFswwrNAFHj
X-Proofpoint-GUID: VI6L7iyWBY6TqxjXPgh9PoFswwrNAFHj


maobibo <maobibo@loongson.cn> writes:

> On 2024/7/27 =E4=B8=8A=E5=8D=884:21, Ankur Arora wrote:
>> Add architectural support for cpuidle-haltpoll driver by defining
>> arch_haltpoll_*().
>> Also define ARCH_CPUIDLE_HALTPOLL to allow cpuidle-haltpoll to be
>> selected, and given that we have an optimized polling mechanism
>> in smp_cond_load*(), select ARCH_HAS_OPTIMIZED_POLL.
>> smp_cond_load*() are implemented via LDXR, WFE, with LDXR loading
>> a memory region in exclusive state and the WFE waiting for any
>> stores to it.
>> In the edge case -- no CPU stores to the waited region and there's no
>> interrupt -- the event-stream will provide the terminating condition
>> ensuring we don't wait forever, but because the event-stream runs at
>> a fixed frequency (configured at 10kHz) we might spend more time in
>> the polling stage than specified by cpuidle_poll_time().
>> This would only happen in the last iteration, since overshooting the
>> poll_limit means the governor moves out of the polling stage.
>> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
>> ---
>>   arch/arm64/Kconfig                        | 10 ++++++++++
>>   arch/arm64/include/asm/cpuidle_haltpoll.h |  9 +++++++++
>>   arch/arm64/kernel/cpuidle.c               | 23 +++++++++++++++++++++++
>>   3 files changed, 42 insertions(+)
>>   create mode 100644 arch/arm64/include/asm/cpuidle_haltpoll.h
>> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>> index 5d91259ee7b5..cf1c6681eb0a 100644
>> --- a/arch/arm64/Kconfig
>> +++ b/arch/arm64/Kconfig
>> @@ -35,6 +35,7 @@ config ARM64
>>   	select ARCH_HAS_MEMBARRIER_SYNC_CORE
>>   	select ARCH_HAS_NMI_SAFE_THIS_CPU_OPS
>>   	select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
>> +	select ARCH_HAS_OPTIMIZED_POLL
>>   	select ARCH_HAS_PTE_DEVMAP
>>   	select ARCH_HAS_PTE_SPECIAL
>>   	select ARCH_HAS_HW_PTE_YOUNG
>> @@ -2376,6 +2377,15 @@ config ARCH_HIBERNATION_HEADER
>>   config ARCH_SUSPEND_POSSIBLE
>>   	def_bool y
>>   +config ARCH_CPUIDLE_HALTPOLL
>> +	bool "Enable selection of the cpuidle-haltpoll driver"
>> +	default n
>> +	help
>> +	  cpuidle-haltpoll allows for adaptive polling based on
>> +	  current load before entering the idle state.
>> +
>> +	  Some virtualized workloads benefit from using it.
>> +
>>   endmenu # "Power management options"
>>     menu "CPU Power Management"
>> diff --git a/arch/arm64/include/asm/cpuidle_haltpoll.h b/arch/arm64/incl=
ude/asm/cpuidle_haltpoll.h
>> new file mode 100644
>> index 000000000000..65f289407a6c
>> --- /dev/null
>> +++ b/arch/arm64/include/asm/cpuidle_haltpoll.h
>> @@ -0,0 +1,9 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +#ifndef _ARCH_HALTPOLL_H
>> +#define _ARCH_HALTPOLL_H
>> +
>> +static inline void arch_haltpoll_enable(unsigned int cpu) { }
>> +static inline void arch_haltpoll_disable(unsigned int cpu) { }
> It is better that guest supports halt poll on more architectures, LoongAr=
ch
> wants this if result is good.
>
> Do we need disable halt polling on host hypervisor if guest also uses hal=
t
> polling idle method?

Yes. The intent is to work on that separately from this series. As the comm=
ent
below states, until that is available we only allow force loading.

>> +
>> +bool arch_haltpoll_want(bool force);
>> +#endif
>> diff --git a/arch/arm64/kernel/cpuidle.c b/arch/arm64/kernel/cpuidle.c
>> index f372295207fb..334df82a0eac 100644
>> --- a/arch/arm64/kernel/cpuidle.c
>> +++ b/arch/arm64/kernel/cpuidle.c
>> @@ -72,3 +72,26 @@ __cpuidle int acpi_processor_ffh_lpi_enter(struct acp=
i_lpi_state *lpi)
>>   					     lpi->index, state);
>>   }
>>   #endif
>> +
>> +#if IS_ENABLED(CONFIG_HALTPOLL_CPUIDLE)
>> +
>> +#include <asm/cpuidle_haltpoll.h>
>> +
>> +bool arch_haltpoll_want(bool force)
>> +{
>> +	/*
>> +	 * Enabling haltpoll requires two things:
>> +	 *
>> +	 * - Event stream support to provide a terminating condition to the
>> +	 *   WFE in the poll loop.
>> +	 *
>> +	 * - KVM support for arch_haltpoll_enable(), arch_haltpoll_enable().
>> +	 *
>> +	 * Given that the second is missing, allow haltpoll to only be force
>> +	 * loaded.
>> +	 */
>> +	return (arch_timer_evtstrm_available() && false) || force;
>> +}
>> +
>> +EXPORT_SYMBOL_GPL(arch_haltpoll_want);
>> +#endif
>>


--
ankur

