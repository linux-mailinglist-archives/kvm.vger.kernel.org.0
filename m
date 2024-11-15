Return-Path: <kvm+bounces-31972-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E9639CF68D
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 22:04:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 31180285854
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 21:04:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BCD31E1A34;
	Fri, 15 Nov 2024 21:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZlRUDnDt";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Q2g3ndU3"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F44A12F585
	for <kvm@vger.kernel.org>; Fri, 15 Nov 2024 21:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731704673; cv=fail; b=Yjy6mGmot0eFDgTjPWTcjn59jcERb45Sqsgdg0iusylPPqMNEIsrkCDxdYuxffIaVJKXt935PQMqPHKUu4M5djln7VdGUuqApij0S4WXoY4WDbYy53mDI5N/vuncc6MMO8WlbsYxXwk4JvjYlUxGwwFu3/iO1KpAolNSaRpQPps=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731704673; c=relaxed/simple;
	bh=HZhrgF7jeXzAhJSYcl8Xa/mMcMIWIz5yEOkQeRO/jww=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=i2Gf4t5sULxs68KgAMGkj29jz+KIMD/w0y2tPdwoqzYz2vDxHiuvlR/60VdgSggyaUzIIBAUDfGxkVWrolClZ1gvL2QBW8b4NL5pdVLAYkZdDPOwdNyCRYisLQMV61phS8CPmVO2euYlBmOyr+ARBP6fQK0hmSQW4JBgpNwSGnA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZlRUDnDt; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Q2g3ndU3; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AFKMgul027018;
	Fri, 15 Nov 2024 21:03:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=lxd7PbXuBa2CBiklUB8QMYyv9koAREe/ZrlBf4Z94fE=; b=
	ZlRUDnDt81sCMmTgEC30cvpQdjf4sX84zE0lh6vWbn8aZUSu+HB9AJfTz+ngrhfN
	516sfztP6eQ6WkLe8skIRYayWC4bcsbH2Ub4UUWgMq6LPfMxxAyR6EDXkoBJp4RR
	fVI7QJ7emroNuHVbAd6u6tt7vOCUiFqsOTvSDFq0Aadk9FaFw0tAyB644sGr2xMb
	LpwDJukvw5xaIWOuhGBJAJAIvdMWI5966TsMbfVhlATuYeP9g2vDqwrp3gkJMTGu
	14GgVV05Azgx8DGOV7x3BC9p4YwnolASXX1sMi2vGYWpZilQF5zd5/R6P0CWYz8z
	eXDupf005oQpahiarMQxpA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0k5m3n9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Nov 2024 21:03:49 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4AFKJ1O5022776;
	Fri, 15 Nov 2024 21:03:48 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42vuw361eb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Nov 2024 21:03:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NJGUtQIEhjQ3Pies7KDV6iRPUWrGC4krBMJ6loXq6Q8QxjYABg1R59/CXjaE+zhV1rrCe0bnegURm+zpLfmqeJz5HHA7qo25jgIhR6VfZztgEpgM8YqdT2iIoTMieVLJnG5na6WNMuC+c547WOroo0T7dpNfsSslN72NrXqKbjsQdOYjB/lUax/PHp9LcQ+eVhX+ypUUudRn0jcDM3ao+ojJx5J2djzv5HEjamPqs9rXmFd31Y9QEa8fMU9J8u480KgAB6CMG85c0do6QUPUFrEWvIGImLwdHNFk/rE0jo+fF+VFh8Tbs05gVamGfgYeb1oJPKkMFsRBHo7a+txahQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lxd7PbXuBa2CBiklUB8QMYyv9koAREe/ZrlBf4Z94fE=;
 b=xu5YfgLUDNgTopaSq10c+GX7OhjgxUtjcS7tcX453+T/famuKbadG7vBxhFPVrjQOrpbzZ4X5DbOS2YT+nUpWX4EUdykhgE+3Xm3fb2HmpG+t3pS0i7RkAo5h4NS6MUp0TU0cXxkax0pnjuwaZ8C9y7rUEV9PxMD/i9ZXR8QPRaNvK4xn4iJXsk/yMeH5F520kcGkF3Bulzt2BiMWEbwb9NDX2qqLMkOiEdq1uKR4z/YYxplnUJG8sXnAotDgOP7ITP5IuL1A6S3d826ruhcVblkSD1bUzW9wKDPDEiuMf/cUp5sMnmPSxci8HhXYqKu6D56wt//cOS8JFmPbR8zpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lxd7PbXuBa2CBiklUB8QMYyv9koAREe/ZrlBf4Z94fE=;
 b=Q2g3ndU3atsOT1nEVz66oYeIR73CDgeBQgfJo2QXfiFOI49WNU0FFdJyPZXB6iEJsn6gPE1+dqFjpVBT24pnOfotGmV/lU/enHm7kiRPdXEkGkDl8uJjByOO8s3u2Y018OBuxsb4TV5mJUTyd+ljIcNJbwiG97VxySsbVXhcO2Q=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by PH0PR10MB5796.namprd10.prod.outlook.com (2603:10b6:510:da::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.18; Fri, 15 Nov
 2024 21:03:39 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%3]) with mapi id 15.20.8158.017; Fri, 15 Nov 2024
 21:03:39 +0000
Message-ID: <386af93d-5a61-4a90-9af0-1f33fa04b0bd@oracle.com>
Date: Fri, 15 Nov 2024 22:03:34 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/7] accel/kvm: Report the loss of a large memory page
To: David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: peterx@redhat.com, pbonzini@redhat.com, richard.henderson@linaro.org,
        philmd@linaro.org, peter.maydell@linaro.org, mtosatti@redhat.com,
        imammedo@redhat.com, eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
References: <e2ac7ad0-aa26-4af2-8bb3-825cba4ffca0@redhat.com>
 <20241107102126.2183152-1-william.roche@oracle.com>
 <20241107102126.2183152-4-william.roche@oracle.com>
 <f5b43126-acbd-4e3f-8ec4-3a5c20957445@redhat.com>
 <08e03987-3c9a-49b2-adf5-fd40e7ede0c0@oracle.com>
 <e5d6bae8-a3bd-4225-b38f-65de6b1a2b54@redhat.com>
Content-Language: en-US, fr
From: William Roche <william.roche@oracle.com>
In-Reply-To: <e5d6bae8-a3bd-4225-b38f-65de6b1a2b54@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM8P190CA0006.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::11) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|PH0PR10MB5796:EE_
X-MS-Office365-Filtering-Correlation-Id: 78bb8d40-5531-403f-4172-08dd05b8fa46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eFVnUFZ3dGE5WWlTQWZXLytWUkRjZlpJVGJacmY4d3VVKzFrOW9RSlc2U2c4?=
 =?utf-8?B?K084bkNlcWlCeFlRTytNMzdydEtoc2xsU00rTFM3eEl2TzNmVUZQQ1cvYjcy?=
 =?utf-8?B?MW1LcmpCL0ZjeXpwYzZ0bjRGN29uT3hCaWF2bFJKaC9QcDIyYU5lOTEvb3JH?=
 =?utf-8?B?ZVFQUURubFpMTHpDK29NSEQ0Z1dRM3NEL2FnWmZ5cXBuKzhtTWFuNXNMNTcw?=
 =?utf-8?B?Vm9SeEpwMFRsOVVldEw3dDRXeDdvV3o0ZWJKUVBtMWtEMldvV0Ewa0NFcjJ0?=
 =?utf-8?B?NUdpeGRXd3VDaUNLSDJMK3VGSU5XdXk5N0NrU0JYMzhEcUtaQnNUUkJRYm44?=
 =?utf-8?B?a3R0Q213MGFBL0U0OTRLdlNuU1VCR2lYYVdIK0dlTVFSOW0yR0g0UXRzOFox?=
 =?utf-8?B?SUtQcnV5VUhRUnNUbXIwbVBDb0tyeHQxYXpMdFM2cHExaVdUR1FUbHJGeVZV?=
 =?utf-8?B?N3VqWHpQUmN6OWlySlk3Wk9oYktZR0ZJRlRIeWhkaEFpbmwyWjFmeE1nK29Z?=
 =?utf-8?B?bGFhUUxaQ09qWkJHR1VoeWVhZzloUCtMbG9USEpLMTZaMFNOaTV1TnltaUhz?=
 =?utf-8?B?L2lQZ3ZKMHpxU2huMGFaUGdwZlhTcS9OaHpFZnZ6Nk5qTGFQY3cwN3ZMeEFS?=
 =?utf-8?B?MU9sMWtFNEdZclJtd3BEckUrQzJNclN5Tk1XTVlkK293bmczWEhoRWdWZFFo?=
 =?utf-8?B?M1NyZzZqLzVEUXFPWTlwVnhHeVdyN1dQeE5JZmRpaWsvSFZlVlorZ1YwSVhO?=
 =?utf-8?B?RnF6dE15UFE5L2Z5KzFtMVplNnBySjgyNktqaHJldzJTZW52RGlCY3ZaWDJz?=
 =?utf-8?B?UXIyRHQ2NGZNUzd1TmlsK3VLak9kU2hkb1lmd1FLRU5wR2Y2d3crZjNHcVMy?=
 =?utf-8?B?a3VWS25TQU1vOXJ6UHRSN2hHYk5KYUFzcGt5dXVSSXZTZ3pSaHN3RUV5QllW?=
 =?utf-8?B?NDVLamFoMjJtM3VMR2FwVnVUZWdNMGdXdHhLL2tLQ1BtYitFaTR6T2hWWW9H?=
 =?utf-8?B?OUU3UFlqb2UyZys1bzJmNVJYUG1TSEZtV1FwR1ovODlueEV1K09tQ2JIOTNq?=
 =?utf-8?B?Z3ZNc0wxcEpkbGNOTzZjNkJ3RXhpOXZJQU1lVi9CV3VoOW5aMlI5TlMrV21y?=
 =?utf-8?B?V0pCd0FtMmNJcHd6bGNCTllEODEva1ZYeUUyVTN2azhNcXVyZGhpdGZ5Qksx?=
 =?utf-8?B?SjBmUFpqVEhORVd2eURJMkw4WTZ3ZEk2bDhUQzNGSVZqQWZ1dW9tenVUOWFS?=
 =?utf-8?B?aUxpWDNLa0dEVFBwMTI1QVVFaDNLVWErQmFENmxrY2J5cFhZcGtkRk93Sjh0?=
 =?utf-8?B?YWNib1puOExHYzl2Z2tDQXI2T1hHdThpMWxsQmJPMGM4M3UyYW1aVkQzSUFo?=
 =?utf-8?B?T1VFMVlrSDV0N3ZLTVNDQlBRbDlrNnRkelBoV29EbzlCTFFXRDE1Sy9ET1N3?=
 =?utf-8?B?Z25Nd1E4OE5OMldXNEhJY3crNlo2THVvU1AyblhVbzRkSVIxTmRwbk9laE5K?=
 =?utf-8?B?STNlRjVuc1QrTDVsUHJ1Rmt1bUJrdld3ZHg2UU9FaVRkZEVWcmpMNjBFakZw?=
 =?utf-8?B?dWpyUDdWV05FTDludEE4S3pncHFiT2tDWDZKaFNLUnpYNEN5Qm0vaWlMNm5r?=
 =?utf-8?B?SzBZaEVKOElUb3R1ZllBMlBWUEVlcFEycTdURjZhZ1h3V2hmZVJjTjBDUkRW?=
 =?utf-8?Q?JN6mdLX5EjESy4OUrWYs?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NEpQTStBazI0S2dUeFhLM3hRWkZ2VllKeDlLcG1WY1VQTVc5dDhlOXBDckxD?=
 =?utf-8?B?em81SjlWQWR4NlpOdUZRMGZCOTM3RlFrd0ZaZVk0V0lGa1dZV3lTZzF5MWhv?=
 =?utf-8?B?SHg2K3djcnZhNWNWbGpqcmZwREpFT05jQ20vQ2t0WEcwczZqRVZkOUR1NVU3?=
 =?utf-8?B?R2gwMWxRWENNS0RCeXlMVHR4R0pWYXpyMW5OdWhHTVRzbi9sMUN3MmdxcUVT?=
 =?utf-8?B?VXRyMTQzSVJSeVE1Qjd4RkxvZksvaGoycXdBNHNKTmxSMkhVay9ZeGZSaVFw?=
 =?utf-8?B?TXdBYlVOaDlDWDFIUlNQYmNjRXJRcisrUU4wcFFpSS9kWFlqdkNMOUQ0VTBt?=
 =?utf-8?B?TWJQUGdBbVNnZ3pQVjE2eGRLU09JWE1mS3ZjMXdlZm5nemNmR3ZmZUc4TWJW?=
 =?utf-8?B?amZZR1Znak5SVVB1eGxtYWJWZ2cvVHd6elhwMXJSV3JOMSthWEZBSXhyVlk4?=
 =?utf-8?B?cFhtMzE4SzRtNUVtSE8vYXV3SENjRmMvYTIyN25Bb0ZuZkIrdTBkdlk4ekcz?=
 =?utf-8?B?a0xNTnk4YzdxVUtzbmoybVBBajlEdFc0Y0s4dFdjdURVVEh2WkpmUUhCb2ln?=
 =?utf-8?B?MldTNk5zRFlKMkk5ZUhGRHV2VFJuWFMvaExwZWpJL2JlMEdzR1kxTk5Jd0FK?=
 =?utf-8?B?Zy9PaTVtUXJQcmVnY0VLM3o5TVMvSXAxRGtpUzZHTXE0R2x6RXgxMTFCWFdI?=
 =?utf-8?B?Smowb0RYaDhkaElHYWJsdS8rdXJZNk9jaDdORVdhakpuMHg5b01vNS9PenNZ?=
 =?utf-8?B?MmlCaVYrOWlENG44eGhjZGdVRzhTRGsyc2RINURwMVVlQ0h1MGdRSmVwSUVN?=
 =?utf-8?B?ODEwSmEzYWtUeXRiUExSSDRYTlY4VENJRy83NHBiWVJ6NWUxemFxUjROU2dU?=
 =?utf-8?B?V0xzcmxtM3B4MXh6elBEZVo0UVZHWFIwV0E4U1REK3JNVWk5aisxNmV2dm1y?=
 =?utf-8?B?UlhZaUZ1NHFqREx5SGtVdGxnOFVXZHpJUEMyZFlSZjYxbmFCSFpqRDMwNDF4?=
 =?utf-8?B?L0hnQkVldFVRQ2x3TEJSdWtOS1lEV05xa2ljV3A4VjV5NzR6R0xBRnJxRlNu?=
 =?utf-8?B?M3ZwSXV1Yko0dTZSZUNOZHQvVytCTXRWaXJ2UzdBUmVTS0h1eGhpRlJCd2h6?=
 =?utf-8?B?OStYQnlnMFRZb0JrR0x6QS90bjZMRFBFb0VZRUhTVnZBdnVlS3NUK0xUU0VS?=
 =?utf-8?B?dlpHaC9kY1pjWUNxcVFpYzQreXNLVlJzR0xjV2Y3Z1R6Zk9aei9sQjBFV3dP?=
 =?utf-8?B?b1lpOGxlYmR0UDdNaUY3OXdHeXJ6QkpHeWcvSlpNbTFPUTNnWjJydWNmS2Ru?=
 =?utf-8?B?RXBtdUlVU2tReUhsbVZNelhmeGxIK05kWldRV2hyaUUyUThkaDk4WFVOM2VN?=
 =?utf-8?B?Qmh1TjdGanhNVTgwM0VEZmYrYUJsSCs3cW9ocmpMdzVhZWxxbDgwbXk4SG9u?=
 =?utf-8?B?dWJZbTZmUEgxMXdvd3owQWdSSDdVbHY0cVJKdmx2RGV6cWEzSDN6dWt0QTAw?=
 =?utf-8?B?azg0b1JTVjk5NUJieVZPeS9hU3RvNTl2bVpJYVVBVnI4Kzc2NXFVSlM4UHhC?=
 =?utf-8?B?SWJDaWNxWUNOaWdteTlRU1hvMkdvTmpkWnVzMGNCWnRvK0xUWnV5Sm16Q08x?=
 =?utf-8?B?cFYwSjltSHcydTJ2Qms2NW53MUROVlJ5N0pjVEh4eWlvZXdOZHNEMnRhSFFR?=
 =?utf-8?B?MUdqU3JXYVhBOVcvblNFNnA2VkhvVnMvNkxGdytsNkl1K3dnNkl5VXM1Vit4?=
 =?utf-8?B?VDNDQUpaRG90R1FGNWV5YjdWNjkrWk84NkFkRm5xTjVGWGdWcTV3YkZ4aVpH?=
 =?utf-8?B?ajFzYUlvM1U0c09CMjd5VWsvK2IzbmhCOHErVVdJZHZxNzJ5Z0F1Q0tVK3dF?=
 =?utf-8?B?dDJWSXFiYWthSTFzUlVUcHdlTHhET25OV2NvbVFLUS9KanlkdkxrTWFOL0Qw?=
 =?utf-8?B?cWVWY05JVE9LNjJGQ1REcERDQ0c1SzFhdXBXeDh4VlRrMHhLdmVLOXZuMjky?=
 =?utf-8?B?M09wZys5MFF6NE1qeGVVVGMzTnd5eVV2elZjempHZEp1eStHL3hEL05JM2Nm?=
 =?utf-8?B?b0l6OFFKRTZzY21zYlNrSC96TWxvNHhSSEtJSVNBTUZiTzBMNlhmQnNUUTJH?=
 =?utf-8?B?VXlJZkk1RElBU2k2SUwvMnR1NzJnS1BjSkV5TUZObm80NFBJdXJnaUtiMmxQ?=
 =?utf-8?B?UWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MVHn8kOcKkvvlYmSQ2tvAU/BnoIGdZRtFQ3gefpoEsfLZupOvlTMqLLLUf2qMeUFGp/OdE0HM/L6gMtVlYeEhYfDf0ZPWbMCdeSW5jDmxTDUjluTMmINq5Bf2FUq3I0Xcm70uDN0YzN20ola3KlyddVyaVCg+jBv4tlfz+qZxk/x36j2jAZeNE6G3OzqSzjo/dnxcfY0+H2vWjJMcPWCOWNL9I8YdtcszuEI/jft/jsXj+78zBO0qysIHdH6e4KYWSWbpHv+xOMv4ArsC+nJ8RROiE/zDYaneiTKFpnocqmpn+QH8jdQ4+WPzS/vaQhBaqJMOjZG3E7W0SFzK/KdrcChPHqFcIZ+RsvphQP4XIxCHV00JlnmT3HQi2TpYGK7iFzhtGlZVH7GWSnZeos3X88+ZfDRjdJUL2JDCCdZ24bA6Oc19zd1LgC/xwWFDLDtm3h3/xwR5qRM2DaRG3CpYBM13PnogP9qcFBqApUHdvQaj20z6/LvFWI9Isv3fIsVgkRkKLvYF75MlWaDkzkG4gQjxJwtj6AqsJ4o1vw5MhmKbp5rUqPfCDRNdxqnBbeYR1/qrsQNeaCdrekNOe/NandWN4+jsXN7JpV2XutLAl8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78bb8d40-5531-403f-4172-08dd05b8fa46
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2024 21:03:39.0368
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wrMrHBlFbkMtunv6U9l/1mONBuppWibZThTAUPAu8tj7WkULVAwABPi1Uy8vejuunVM20T0nITITt5QBoEDKblhQPYRl5cskJ16nnTQIgMg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5796
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-15_08,2024-11-14_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411150177
X-Proofpoint-ORIG-GUID: dOPcH0dCQciLHuyALVrUWOC263LgTYFy
X-Proofpoint-GUID: dOPcH0dCQciLHuyALVrUWOC263LgTYFy

Thanks for the feedback on the patches, I'll send a new version in the 
coming week.

But I just wanted to answer now the questions you asked on this specific 
one as they are related to the importance of fixing the large page 
failures handling.

On 11/12/24 23:22, David Hildenbrand wrote:
> On 12.11.24 19:17, William Roche wrote:
>> On 11/12/24 12:13, David Hildenbrand wrote:
>>> On 07.11.24 11:21, “William Roche wrote:
>>>> From: William Roche <william.roche@oracle.com>
>>>>
>>>> When an entire large page is impacted by an error (hugetlbfs case),
>>>> report better the size and location of this large memory hole, so
>>>> give a warning message when this page is first hit:
>>>> Memory error: Loosing a large page (size: X) at QEMU addr Y and GUEST
>>>> addr Z
>>>>
>>>
>>> Hm, I wonder if we really want to special-case hugetlb here.
>>>
>>> Why not make the warning independent of the underlying page size?
>>
>> We already have a warning provided by Qemu (in 
>> kvm_arch_on_sigbus_vcpu()):
>>
>> Guest MCE Memory Error at QEMU addr Y and GUEST addr Z of type
>> BUS_MCEERR_AR/_AO injected
>>
>> The one I suggest is an additional message provided before the above
>> message.
>>
>> Here is an example:
>> qemu-system-x86_64: warning: Memory error: Loosing a large page (size:
>> 2097152) at QEMU addr 0x7fdd7d400000 and GUEST addr 0x11600000
>> qemu-system-x86_64: warning: Guest MCE Memory Error at QEMU addr
>> 0x7fdd7d400000 and GUEST addr 0x11600000 of type BUS_MCEERR_AO injected
>>
> 
> Hm, I think we should definitely be including the size in the existing 
> one. That code was written without huge pages in mind.

Yes we can do that, and get the page size at this level to pass as a 
'page_sise' argument to kvm_hwpoison_page_add().

It would make the message longer as we will have the extra information 
about the large page on all messages when an error impacts a large page.
We could change the messages only when we are dealing with a large page, 
so that the standard (4k) case isn't modified.


> 
> We should similarly warn in the arm implementation (where I don't see a 
> similar message yet).

Ok, I'll also add a message for the ARM platform.

>>
>> According to me, this large page case additional message will help to
>> better understand the probable sudden proliferation of memory errors
>> that can be reported by Qemu on the impacted range.
>> Not only will the machine administrator identify better that a single
>> memory error had this large impact, it can also help us to better
>> measure the impact of fixing the large page memory error support in the
>> field (in the future).
> 
> What about extending the existing one to something like
> 
> warning: Guest MCE Memory Error at QEMU addr $ADDR and GUEST $PADDR of 
> type BUS_MCEERR_AO and size $SIZE (large page) injected
> 
> 
> With the "large page" hint you can highlight that this is special.

Right, we can do it that way. It also gives the impression that we 
somehow inject errors on a large range of the memory. Which is not the 
case. I'll send a proposal with a different formulation, so that you can 
choose.



> On a related note ...I think we have a problem. Assume we got a SIGBUS 
> on a huge page (e.g., somewhere in a 1 GiB page).
> 
> We will call kvm_mce_inject(cpu, paddr, code) / 
> acpi_ghes_record_errors(ACPI_HEST_SRC_ID_SEA, paddr)
> 
> But where is the size information? :// Won't the VM simply assume that 
> there was a MCE on a single 4k page starting at paddr?

This is absolutely right !
It's exactly what happens: The VM kernel received the information and 
considers that only the impacted page has to be poisoned.

That's also the reason why Qemu repeats the error injections every time 
the poisoned large page is accessed (for all other touched 4k pages 
located on this "memory hole").

> 
> I'm not sure if we can inject ranges, or if we would have to issue one 
> MCE per page ... hm, what's your take on this?

I don't know of any size information about a memory error reported by 
the hardware. The kernel doesn't seem to expect any such information.
It explains why there is no impact/blast size information provided when 
an error is relayed to the VM.

We could take the "memory hole" size into account in Qemu, but repeating 
error injections is not going to help a lot either: We'd need to give 
the VM some time to deal with an error injection before producing a new 
error for the next page etc... in the case (x86 only) where an 
asynchronous error is relayed with BUS_MCEERR_AO, we would also have to 
repeat the error for all the 4k pages located on the lost large page too.

We can see that the Linux kernel has some mechanisms to deal with a 
seldom 4k page loss, but a larger blast is very likely to crash the VM 
(which is fine). And as a significant part of the memory is no longer 
accessible, dealing with the error itself can be impaired and we 
increase the risk of loosing data, even though most of the memory on the 
large page could still be used.

Now if we can recover the 'still valid' memory of the impacted large 
page, we can significantly reduce this blast and give a much better 
chance to the VM to survive the incident or crash more gracefully.

I've looked at the project you indicated me, which is not ready to be 
adopted:
https://lore.kernel.org/linux-mm/20240924043924.3562257-2-jiaqiyan@google.com/T/

But we see that, this large page enhancement is needed, sometimes just 
to give a chance to the VM to survive a little longer before being 
terminated or moved.
Injecting multiple MCEs or ACPI error records doesn't help, according to me.

William.


