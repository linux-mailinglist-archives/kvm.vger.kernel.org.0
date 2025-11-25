Return-Path: <kvm+bounces-64500-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D37FC8560F
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 15:22:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C5553B40DB
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 14:21:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 102BA3246FE;
	Tue, 25 Nov 2025 14:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="PXuWp4Tk";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="ialNbHVM"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D6793254B4;
	Tue, 25 Nov 2025 14:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764080469; cv=fail; b=AhZkdGfoKh1r0soz6/szT07MF18nalHh584wpU8N6/O+Ypo7K2ryzumS0fQMXJUEHadDxb5Xj6wxmkF2t9LG4nB9IZVbjvD95bSf0aeFSz98en0WsewH3J+Ic8qFFia37XaiLymNkI7aimv2st716YBHzoUPBKaWv0zDrlWMX/g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764080469; c=relaxed/simple;
	bh=nkkdIDr3EA5/uNI2oersvNC2e0hJMO1MVAr/tQ4Prbo=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=bwiRsmWT9BBXoXJhX3D263fA5ZON0FdlXxqTBpDhdkMsIb0wCrHldTBSd9oigM5vKL6YbbdtHliNVuiRnK/z8XGAQcc5TU6+UNX3MssjKg+l0Gmk+sUQOz/kaZkCtuw7b1gcl4VoaYI8fwXKHJ/IHpBmKc6q1VEQfJMVyGTPYkA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=PXuWp4Tk; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=ialNbHVM; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AP67VmO3499637;
	Tue, 25 Nov 2025 06:20:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=proofpoint20171006; bh=sJDJgT0mxGx8P
	BjIS876teBejaIsNLpYp3fDq8VbHXc=; b=PXuWp4Tk2DN/X3fvMNgrPO1K9ODAV
	U3HgQpkN1WV2FJCUIQXNy1oNV/Gw+8jzX8Y/5IULW7HNfmG6R+ojvh121/BxwiCj
	icUM2PUcMUgi54+57UMxNx7M8s69+8pJjUY1suuqfQVFj/A/U04+7cNYrh5DzF3t
	IzalLmw3h7iGewJ+Qaeef+PEwJfpaJ/j7jOGGQfrmAlo7P4T1XlCa7epIn+2KleN
	4ihyG3//Nt+mO0oZTySqjSpTJMz7qh2kPP3qHtIVLfQZ3Yd6kTnGDw6H5+YOYqGy
	YygvCcpi8Q+GGOZ/aauHRpLbdamHnMjA6ztYnLzuN3oXW/93VOzl31maA==
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11020096.outbound.protection.outlook.com [52.101.56.96])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4amu4jja2c-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 25 Nov 2025 06:20:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UKx+29eijALT5A0Ty1WXGEgcVxbdqFyUdmtlIhyNneI9Sb1QISDdmJM2uooV/GW4dhlb2UZQKT9RsdxSmsr2knJ5yfNKBbfaFsfGe1BqynbXkbEIr5DXqfc17FlbZMbyQYzI/1rm9sTvL2infADclMWzFS5TdOvTMLAFJrUssjLjCKRe6aolk54rjlAXIvXf16isnLf4LQSFk9MLMXRzu6r1dyqlq/MQLCx34mjUNEeOVYVXzrl8LOPrR/1YnkXVfOni9jH0a/6J87iEgbMrEUiDQloq1q0mmIQP1VtQJm0GRvYu1QkKPXZqO9j2085mWPOdlvDNobbYLMQAjIdQNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sJDJgT0mxGx8PBjIS876teBejaIsNLpYp3fDq8VbHXc=;
 b=uvf9P4gb51Rw0JsgzbTOxxuVIkFLrYawuWPHL7JNNxLGPMEKOdEj3hOtqcyNqjD7Jk+4v/1AAxuzCfRd3tiimBz1SdV50wNZpK04lN98B53pRKYjQgxERwolw5KB2zk+ZGhOPzw2P1UrNeLr/IKGdRzTQBQUerB8kWKa+XVG7eeU0OnsvisMmFuuPoWBT6uuraz6dQJ1GF0dAjnyN8Sbn2nE4vnLvu/e43ei3cwB0A0Butwgt9dZ0JL5ndhdne5bmM6wVgOoxkBhYvDhkBCt4mX9D9crtaiVap83tdg7CYUgstcf9KxWukOyMRtAeNw2E7FvHP1013nEIjxPO09KbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sJDJgT0mxGx8PBjIS876teBejaIsNLpYp3fDq8VbHXc=;
 b=ialNbHVM5sJ0wKm5TYkLVS0eAnOv8v6LTp32fu6lKL3uE4tgSw5fIPLk76DEO/1S5wQuomVlXNsMceKYGtoGpklg4B0FExoQ1UlRZZTEGhnXwk1+XqdZaF3X6lHRP2l6dHnecbZZMw4o/zcxCnXjPH+aPMdsj5uOvgTtKWOtv0sXBpSpGl6oG19I2et9VnjO7dFvysqUttJHQC0KvUUb8FhMAZ3rpVzrLYdCLYzuc3nmYVwVDxHfDyBqpm1zdMGn5G+0JBtJwIDtW685SjqXAWyURPmgVoYQ2jBTC9sYZGIn4Yqm9n8LyMwlwbcEs+Emp62TVa4/exlhjPZWT7gGMg==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by IA1PR02MB9136.namprd02.prod.outlook.com (2603:10b6:208:42c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Tue, 25 Nov
 2025 14:20:15 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::27c4:c948:370:572b]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::27c4:c948:370:572b%4]) with mapi id 15.20.9366.009; Tue, 25 Nov 2025
 14:20:15 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, kai.huang@intel.com
Cc: mingo@redhat.com, x86@kernel.org, bp@alien8.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dave.hansen@linux.intel.com, tglx@linutronix.de, jon@nutanix.com,
        shaju.abraham@nutanix.com, Khushit Shah <khushit.shah@nutanix.com>,
        stable@vger.kernel.org
Subject: [PATCH v2] KVM: x86: Add x2APIC "features" to control EOI broadcast suppression
Date: Tue, 25 Nov 2025 14:19:51 +0000
Message-ID: <20251125142010.1831117-1-khushit.shah@nutanix.com>
X-Mailer: git-send-email 2.43.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PH8PR07CA0004.namprd07.prod.outlook.com
 (2603:10b6:510:2cd::13) To SA2PR02MB7564.namprd02.prod.outlook.com
 (2603:10b6:806:146::23)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR02MB7564:EE_|IA1PR02MB9136:EE_
X-MS-Office365-Filtering-Correlation-Id: f8044642-63f4-4eb9-74a0-08de2c2dc0d7
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WDNObDlKZmtMWlh0YWc4U3VsY3V1WmlJTVJuK0FoQVY4SVkwRzdhaWFHZlpy?=
 =?utf-8?B?VjIwakV4TkI2WkVEOVdXK29oaXp1QU9GZHpKV0N6UStHSElkTEg5YUFZdThO?=
 =?utf-8?B?VEorZk4xUVNjQmFXeGo2TkZ6Tm5jc1lOdmxWY3psQkh4dlZkbnR5S2xsRksy?=
 =?utf-8?B?dlZSOWlDeHZWOVBnZm1VNUVkZTRsSzdKYWxQU1hQNEVPUDN2Uk5rZm1VYnBE?=
 =?utf-8?B?N09neTFnV3R6S2NTOFVEem56aHErT0gvOEFtRHVmSUpvaUt5d0NrZ3lNZ3Yr?=
 =?utf-8?B?VnY3bDlDQU1sYmFQdzF6Q0NJNmp1blU1cEUxbFhoRGQ0U1ZqNUo2azduNGpM?=
 =?utf-8?B?bEd6SC90ODUreFVMdFdTcW5PTWtEcHlDMlgzZDVkZE9HTFMvMDRCbHlka0Y1?=
 =?utf-8?B?SnlPOWUyMWJmcnViZGowQzNWWDBFVGZ1djZNa0ZvMkdvU3JNVm9NUFhTeEhp?=
 =?utf-8?B?dGIvd2NOWFh6U2VYNnl4TDd0d2xjUDZHUkI5TGN0MnpnQ3RPWkhZQUdhS0Vr?=
 =?utf-8?B?Z0g5WlcyVFFnUU1LWHU0VTZlcllLQnZSYXhZRGxyelBJUFg4SE1uTFlBdDhO?=
 =?utf-8?B?TFRwZmx3M2N0NVJZb1BuWE9MOXBuZVdFYmkxVmhRaGNlamdTMWw1cWlPZHJU?=
 =?utf-8?B?OWR3RFo1cHZOQXdlUlZoWDZBYXZJbFBEUjlMdEIwaFBvbTlVeG0rTDNROGFF?=
 =?utf-8?B?WURnK1RSOXVIalU1b211eWl2SE05MGR0MHZHUGVucEVFYnp5S1hRZ2dUMUxO?=
 =?utf-8?B?ZHBsMjdDcjk0dkZJZ1VURURFYmowbG9qbytmTUhxYWwwQzUxWWRwaU5sTDZz?=
 =?utf-8?B?OUtLeHA2VGVhMWk5OVZ5MWlreUdFMzB5ME5kQjFvcloxWG00NGZ4a0lmeE1m?=
 =?utf-8?B?N0R1cFR0aXNCdi8rR0dSaktaNFdXRHNJR1EzOC9pZ2xweDR3NDVZUTlBV1lj?=
 =?utf-8?B?MmQxbG9UVDdKQlAvMlh1RFZINUxWaFhJWTFoK0pZU1pDR1dadEFLa1E1WUpG?=
 =?utf-8?B?UGxkajRURGVldE0vaHFmUkdQTnZ6YlRTcGg1QWZFYUpIdWtSdytDcWhRd3No?=
 =?utf-8?B?cTArankvUzd0MktDWjdpQXJkQWNiL2hLT0tPcG0rVDBzMDQ5M0xnUkhKU0Vm?=
 =?utf-8?B?bXZ1bmVadnBkb1RGcmh1dXk5SkFUSHJ2WWhjeDNyOWdhKzdGak53a2pzdE5K?=
 =?utf-8?B?emhmRS9mbjNBa1RmTjhmaSs1eDBRTktIeDdmNS9DckFScmlMY0g4dlVlRmVh?=
 =?utf-8?B?Y3YzQ3A3NjRCRXZSWE9aOVRzSEI2cW5lOEZhdVVOSXhTeHVMOHFhWlI1ZnJk?=
 =?utf-8?B?aklxQ296RTVPeUFYM0MwQ0ttUG9BdllSUFQ2N3E4ZUN0aENFWTJDWUFMR0hu?=
 =?utf-8?B?aHJvSUlCb29nYjJORVlXZGdrU0QrWkRpdGNSb2dJSS80R085a09mTUdGKzl5?=
 =?utf-8?B?aVhSc0h2L1VGaHFrbjE3Ymc4UUxNUENCME1VekRwbFFKbHRHWE1aWi85OFJC?=
 =?utf-8?B?MGlSOTBSZ2ZMVVl0VU9EUHdzL3NFMGJYWE1qZFNJMDYxR1dHYVVqTnQrWXRD?=
 =?utf-8?B?OXl5Wklub1FJd21sWFVFUHVGNTNEVU1ZTlRuT1dJOG9RV2VHL01ZdzQ1OEV4?=
 =?utf-8?B?NUxZSDFKU0VITmM3TVZ3MGpjVWl5d2ZiQkk0RzJVc1FZcTFXK1hyMEZvTnBk?=
 =?utf-8?B?Z2lWOXkydkMvaEpTM05rTkpTd2V5WGNjVS8wZnZ4WHM4SVVacUpzeC9xS1p1?=
 =?utf-8?B?SmdEc3BFbWQyeDk2eDZsYkV5Rm1xc1Yyc0hyVENFZk9EKzdFOTRxMWJRWUNY?=
 =?utf-8?B?QmltTGhSbFNEa2dYS1hzanFRVUx2SGNuZjJDVC9aNEFxQkU4WWxSdnN4ejJP?=
 =?utf-8?B?WURKSU1xZDlnbEpueXFOeE1SK2wzMUMzZjhvcXB5VWNhem0wTWJxWTBmdGxk?=
 =?utf-8?B?ZVNDVEUwdHpuTkhTNmN4Mmk2M0o3RUE3YmYzU0ZPUGxvc2xPcERmdEdEbUJx?=
 =?utf-8?B?Q0N5UHhEcTBnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R3U3TzFaaTROMW1nbTZMNDVwb1hXZVVDdlRzMkdmc3pXQnByTk9RSmU0Z2pV?=
 =?utf-8?B?eVFIRi9jR0RmSVhIQnBBcXhBSUNkVHN5akJEZWozcDFYNmRGejJrbjdENjZV?=
 =?utf-8?B?T2cvQnNacTNyeGdNaEdldTRDejVpTCtaOS83QWNhWURMcTJBNWlyNHlzZDVP?=
 =?utf-8?B?a0ZDTFFQRXVSZ3gvWWlWL29JNUNxdS9YYzZmaE5qZXpwTFc4MEhlSTliMnp4?=
 =?utf-8?B?aFhVNGs4R0NkZUlJQzdkOEgwdCtVSDlKRVhvS21zV0YrQXJXSUlmemx4dFNr?=
 =?utf-8?B?S0poTkRrSmZkaXA5RGtQWCtVRGxQYWtNSnBnWk5Ba3ptYk1WNllPME1GV2Vq?=
 =?utf-8?B?U1JJYzUwS2pNUDlRY1Jxc2RCN2pLcS9yN0l0OERGMmh4ZHg2cHhoYVdXUGpO?=
 =?utf-8?B?N3V5SG00dnZpWWpkZGZkakdLYnFTcC8wWmFNdFA1dG5xOVd1MTVOQi9pU2t6?=
 =?utf-8?B?T3o1Q3g3MUJhdFRzMXR6OXE5Y2VrNHNWaWVPR3hNVXRHN0hlenI2Y2dKSXpN?=
 =?utf-8?B?VVI2dncyaDdnYU8zU2hNcEU0ZzhVQWpTNUVLbWR0Mzdud0lCNmwvVUg1QnhD?=
 =?utf-8?B?UFVQenJMait0QS9YQURsZVFDeC80OUs4WDI0akNvc0ZVVHM2Znp1MHpGSkhW?=
 =?utf-8?B?alpDOEc4Q002YzNnMWtBc1hIcnRVNnZYT1hiZGNGMnVqUm9DTytEUjVrWWVQ?=
 =?utf-8?B?UVFILzhjbGk0VU1jQnRVN3dMM1IwM3ZPV1dxMmZkMGE1Z3R0WEg3ckpuVmYz?=
 =?utf-8?B?ZmY4T1VLTU9wWFFpSG5hZFczOWQ3MlNDUXA3OXJyTFhzTHJLdWg3dDJMNEc2?=
 =?utf-8?B?ZjhleThKYnpxK0V1Y1l2d1NKeVNweDhLQ3MwTitOYVBJcmxWR2E2RkFCUWxG?=
 =?utf-8?B?ckhPd2laQzN5Z3VyTm5nV2RnVjNWTDg1cElGS2ZZbW11dENLTzRPUW1hVjhk?=
 =?utf-8?B?bnVVczFUNUJzNExPT2JiTjNLYlFkbFpDaVNRYzdGNXhDcWtRRU5GSnZSTExI?=
 =?utf-8?B?a2ZqZGpPOGdYT3JtZ2Fhc0xRRG5XMHdZb0JZSDhVK09kZHVHUnJMTk5RV0lG?=
 =?utf-8?B?Mm1FTHMyYTIyOUdpUnFZck00blh0a2RLVXBXRlV3VVd2aWplTEd2cWp2cTNV?=
 =?utf-8?B?RXRra3M5RC9rZlBJVjJsL1dDblk1VW9zUDBaMlJ5Mk1nNGxGcTgyNWdEZndE?=
 =?utf-8?B?bVRXRUpvWk1SR3hDNWlrblBkeFE5d1ZNc1VQc1BNQ1RPR1Z2MjV1b3ZvNVor?=
 =?utf-8?B?L3N6STErWjJ5NFRxbzBBUi95TUppeVd3eW1rQnFrZ3VjRkR3SXptT2szYnJX?=
 =?utf-8?B?QzVrazNxM3pVYk96ald0M3lKZ2lreWdJRVo0ZHRySDFISXBlei8zMXJ5YWx4?=
 =?utf-8?B?Z2c4THl4WU04Vk5rVXYwRHZFZmtBTytST1oxTGVpL283eVFvbXp2VFpWcURT?=
 =?utf-8?B?SjN4TlU2U1JWS29HSGRJT2VkMnpjdHBhRjdnQXI1S21nSEFLQ0FTZFZ2TTJ3?=
 =?utf-8?B?dU9haTNwK2IvRHZ2NlJ3OFo3Ly9JTWgzT2ZYa3BBc0JIZk5wMFVRV0FCRnRH?=
 =?utf-8?B?OWNJQWhnUWRrbUViNnM3QmtKV3d4bkZWN0FNMUhlSDJ3VnhmSHRZbGlodFhu?=
 =?utf-8?B?MkQ4OEcwM1BOWStGVEV2aHBtUjFwUWNLL1RVWEVwWkdKcHpBWkE5L005QTgz?=
 =?utf-8?B?SmhzMTV1QTU0UkZoeUE2ekk1SmRRcDUwaEw0WUVIQnBEUXFHMFFGaWlDajB5?=
 =?utf-8?B?SFEycHMzY1Q3T2VUVzdINHFQWDdLTGhiN1ZSMTdlVHp1ejZ2MWYrQkpTRDNY?=
 =?utf-8?B?T2tsUzIwRmMwWjA0WTJJY1lKcHJXMjU5L0dNL2llVkowZmN2QjlaYWNoRWZy?=
 =?utf-8?B?NndqOGRQdHdHM2pCb1p4dVNOT3dZc0c5eEF5SmhSNU1lSXV1NFhNcXlUd3Va?=
 =?utf-8?B?WVgrNzUrTU83Q2Jva0Z0UFllbjJVc0h3WVVoOU1LMlhTUy9maWZneW5HbWhS?=
 =?utf-8?B?RHdITXVMM1F3YldnTFdKWi95R3FkSlNrZWJ4VUVTV0pxR3V1TitkOUNqWkJZ?=
 =?utf-8?B?bGFiQzFWZVJ1NndiMnVaME51M2dYcW5nOENJU1NTSHNTWkVvQnNtelJheVVn?=
 =?utf-8?B?QTNWekc1a2VWdmpXTlNFN01vZ1dlRy9Rek5BTjRIeHUyNFZzTFBuWjM3TUhm?=
 =?utf-8?B?VkE9PQ==?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8044642-63f4-4eb9-74a0-08de2c2dc0d7
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2025 14:20:15.6878
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EmwUG/Wl6veKR6abHPkXxe381XT60IHwu1HjF423ANylrLFeI2eLWrIj/DcqDH/WENnTKXrXDfeViHtmJy1X7yWcFgruPTHll0lvtr6PMr4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR02MB9136
X-Proofpoint-GUID: Sx_oBzchy8QUTWB8KCEjzEnVFoqillHL
X-Authority-Analysis: v=2.4 cv=YOaSCBGx c=1 sm=1 tr=0 ts=6925bb25 cx=c_pps
 a=NO5CczpcTQW1gtzKHD9VpQ==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=64Cc0HZtAAAA:8 a=1XWaLZrsAAAA:8
 a=9rnDWOd_n04SSkEilkoA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: Sx_oBzchy8QUTWB8KCEjzEnVFoqillHL
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI1MDExOCBTYWx0ZWRfX+baiMYXAG1uj
 4avR0/SiXPBFKpGUpyK1WFxxUmZVNSCuS0ZcXgyS9dNkNG43978APD7cIXOiDKW1up7cCFMDjWp
 YKdAy68Fx0cMXYhct2g5ZPonMjmRF2de7CqGecevz/phD8eNQeKPt9pMhRrJNOPW4VjZqf6A7wP
 uyTJp+/xZQ3BwfyaiAeLJtRB4MUTSalybncuB1n3nhYRaW2xHB1kOEFpPyeubzcHx7XuskNJPAg
 nAhOnpa5FF69O3oXS81ikxEJcis0IJei7rJYwR5LAm/jBLYLU7zgHInDgqYRDqr51q6fAzD62Ih
 xejB2xD959UBaqmHrqmhyp5bGVctC9E5v+jv9zz/AkfNJfXWCkCRtAWwUgr6o2Rv0kzT+VUkiv2
 NY9DH3pcgt0VbUKRnfIxIDl3k9uisA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-25_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Add two flags for KVM_CAP_X2APIC_API to allow userspace to control support
for Suppress EOI Broadcasts, which KVM completely mishandles.  When x2APIC
support was first added, KVM incorrectly advertised and "enabled" Suppress
EOI Broadcast, without fully supporting the I/O APIC side of the equation,
i.e. without adding directed EOI to KVM's in-kernel I/O APIC.

That flaw was carried over to split IRQCHIP support, i.e. KVM advertised
support for Suppress EOI Broadcasts irrespective of whether or not the
userspace I/O APIC implementation supported directed EOIs.  Even worse,
KVM didn't actually suppress EOI broadcasts, i.e. userspace VMMs without
support for directed EOI came to rely on the "spurious" broadcasts.

KVM "fixed" the in-kernel I/O APIC implementation by completely disabling
support for Suppress EOI Broadcasts in commit 0bcc3fb95b97 ("KVM: lapic:
stop advertising DIRECTED_EOI when in-kernel IOAPIC is in use"), but
didn't do anything to remedy userspace I/O APIC implementations.

KVM's bogus handling of Suppress EOI Broadcast is problematic when the guest
relies on interrupts being masked in the I/O APIC until well after the
initial local APIC EOI.  E.g. Windows with Credential Guard enabled
handles interrupts in the following order:
  1. Interrupt for L2 arrives.
  2. L1 APIC EOIs the interrupt.
  3. L1 resumes L2 and injects the interrupt.
  4. L2 EOIs after servicing.
  5. L1 performs the I/O APIC EOI.

Because KVM EOIs the I/O APIC at step #2, the guest can get an interrupt
storm, e.g. if the IRQ line is still asserted and userspace reacts to the
EOI by re-injecting the IRQ, because the guest doesn't de-assert the line
until step #4, and doesn't expect the interrupt to be re-enabled until
step #5.

Unfortunately, simply "fixing" the bug isn't an option, as KVM has no way
of knowing if the userspace I/O APIC supports directed EOIs, i.e.
suppressing EOI broadcasts would result in interrupts being stuck masked
in the userspace I/O APIC due to step #5 being ignored by userspace.  And
fully disabling support for Suppress EOI Broadcast is also undesirable, as
picking up the fix would require a guest reboot, *and* more importantly
would change the virtual CPU model exposed to the guest without any buy-in
from userspace.

Add two flags to allow userspace to choose exactly how to solve the
immediate issue, and in the long term to allow userspace to control the
virtual CPU model that is exposed to the guest (KVM should never have
enabled support for Suppress EOI Broadcast without a userspace opt-in).

Note, Suppress EOI Broadcasts is defined only in Intel's SDM, not in AMD's
APM.  But the bit is writable on some AMD CPUs, e.g. Turin, and KVM's ABI
is to support Directed EOI (KVM's name) irrespective of guest CPU vendor.

Fixes: 7543a635aa09 ("KVM: x86: Add KVM exit for IOAPIC EOIs")
Closes: https://lore.kernel.org/kvm/7D497EF1-607D-4D37-98E7-DAF95F099342@nutanix.com
Cc: stable@vger.kernel.org
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
All discussions on v1, v2 only apply the naming feedback and grammar
fixes.

Testing:
I ran the tests with QEMU 9.1 and a 6.12 kernel with the patch applied.
- With an unmodified QEMU build, KVM’s LAPIC SEOIB behavior remains unchanged.
- Invoking the x2APIC API with KVM_X2APIC_API_DISABLE_IGNORE_SUPPRESS_EOI_BROADCAST_QUIRK
  correctly suppresses LAPIC -> IOAPIC EOI broadcasts (verified via KVM tracepoints).
- Invoking the x2APIC API with KVM_X2APIC_API_DISABLE_SUPPRESS_EOI_BROADCAST
  results in SEOIB not being advertised to the guest, as expected (confirmed by
  checking the LAPIC LVR value inside the guest).

I'll send the corresponding QEMU-side patch shortly. 
---
 Documentation/virt/kvm/api.rst  | 14 ++++++++++++--
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/include/uapi/asm/kvm.h |  6 ++++--
 arch/x86/kvm/lapic.c            | 13 +++++++++++++
 arch/x86/kvm/x86.c              | 12 +++++++++---
 5 files changed, 40 insertions(+), 7 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 57061fa29e6a..4141d2bd8156 100644
  results in SEOIB not being advertised to the guest, as expected (confirmed by
  checking the LAPIC LVR value inside the guest).

I'll send the corresponding QEMU-side patch shortly. 
---
 Documentation/virt/kvm/api.rst  | 14 ++++++++++++--
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/include/uapi/asm/kvm.h |  6 ++++--
 arch/x86/kvm/lapic.c            | 13 +++++++++++++
 arch/x86/kvm/x86.c              | 12 +++++++++---
 5 files changed, 40 insertions(+), 7 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 57061fa29e6a..4141d2bd8156 100644
  results in SEOIB not being advertised to the guest, as expected (confirmed by
  checking the LAPIC LVR value inside the guest).

I'll send the corresponding QEMU-side patch shortly. 
---
 Documentation/virt/kvm/api.rst  | 14 ++++++++++++--
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/include/uapi/asm/kvm.h |  6 ++++--
 arch/x86/kvm/lapic.c            | 13 +++++++++++++
 arch/x86/kvm/x86.c              | 12 +++++++++---
 5 files changed, 40 insertions(+), 7 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 57061fa29e6a..4141d2bd8156 100644
  results in SEOIB not being advertised to the guest, as expected (confirmed by
  checking the LAPIC LVR value inside the guest).

I'll send the corresponding QEMU-side patch shortly.
---
 Documentation/virt/kvm/api.rst  | 14 ++++++++++++--
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/include/uapi/asm/kvm.h |  6 ++++--
 arch/x86/kvm/lapic.c            | 13 +++++++++++++
 arch/x86/kvm/x86.c              | 12 +++++++++---
 5 files changed, 40 insertions(+), 7 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 57061fa29e6a..4141d2bd8156 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7800,8 +7800,10 @@ Will return -EBUSY if a VCPU has already been created.
 
 Valid feature flags in args[0] are::
 
-  #define KVM_X2APIC_API_USE_32BIT_IDS            (1ULL << 0)
-  #define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK  (1ULL << 1)
+  #define KVM_X2APIC_API_USE_32BIT_IDS                               (1ULL << 0)
+  #define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK                     (1ULL << 1)
+  #define KVM_X2APIC_API_DISABLE_IGNORE_SUPPRESS_EOI_BROADCAST_QUIRK (1ULL << 2)
+  #define KVM_X2APIC_API_DISABLE_SUPPRESS_EOI_BROADCAST              (1ULL << 3)
 
 Enabling KVM_X2APIC_API_USE_32BIT_IDS changes the behavior of
 KVM_SET_GSI_ROUTING, KVM_SIGNAL_MSI, KVM_SET_LAPIC, and KVM_GET_LAPIC,
@@ -7814,6 +7816,14 @@ as a broadcast even in x2APIC mode in order to support physical x2APIC
 without interrupt remapping.  This is undesirable in logical mode,
 where 0xff represents CPUs 0-7 in cluster 0.
 
+Setting KVM_X2APIC_API_DISABLE_IGNORE_SUPPRESS_EOI_BROADCAST_QUIRK overrides
+KVM's quirky behavior of not actually suppressing EOI broadcasts for split IRQ
+chips when support for Suppress EOI Broadcasts is advertised to the guest.
+
+Setting KVM_X2APIC_API_DISABLE_SUPPRESS_EOI_BROADCAST disables support for
+Suppress EOI Broadcasts entirely, i.e. instructs KVM to NOT advertise support
+to the guest and thus disallow enabling EOI broadcast suppression in SPIV.
+
 7.8 KVM_CAP_S390_USER_INSTR0
 ----------------------------
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 48598d017d6f..f6fdc0842c05 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1480,6 +1480,8 @@ struct kvm_arch {
 
 	bool x2apic_format;
 	bool x2apic_broadcast_quirk_disabled;
+	bool disable_ignore_suppress_eoi_broadcast_quirk;
+	bool x2apic_disable_suppress_eoi_broadcast;
+		 * Suppress EOI Broadcasts without actually suppressing EOIs).
+		 */
+		if ((kvm_lapic_get_reg(apic, APIC_SPIV) & APIC_SPIV_DIRECTED_EOI) &&
+		    apic->vcpu->kvm->arch.disable_ignore_suppress_eoi_broadcast_quirk)
+			return;
+
 		apic->vcpu->arch.pending_ioapic_eoi = vector;
 		kvm_make_request(KVM_REQ_IOAPIC_EOI_EXIT, apic->vcpu);
 		return;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c9c2aa6f4705..e1b6fe783615 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -121,8 +121,11 @@ static u64 __read_mostly efer_reserved_bits = ~((u64)EFER_SCE);
 
 #define KVM_CAP_PMU_VALID_MASK KVM_PMU_CAP_DISABLE
 
-#define KVM_X2APIC_API_VALID_FLAGS (KVM_X2APIC_API_USE_32BIT_IDS | \
-                                    KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK)
+#define KVM_X2APIC_API_VALID_FLAGS	\
+	(KVM_X2APIC_API_USE_32BIT_IDS |	\
+	KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK |	\
+	KVM_X2APIC_API_DISABLE_IGNORE_SUPPRESS_EOI_BROADCAST_QUIRK |	\
+	KVM_X2APIC_API_DISABLE_SUPPRESS_EOI_BROADCAST)
 
 static void update_cr8_intercept(struct kvm_vcpu *vcpu);
 static void process_nmi(struct kvm_vcpu *vcpu);
@@ -6782,7 +6785,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 			kvm->arch.x2apic_format = true;
 		if (cap->args[0] & KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK)
 			kvm->arch.x2apic_broadcast_quirk_disabled = true;
-
+		if (cap->args[0] & KVM_X2APIC_API_DISABLE_IGNORE_SUPPRESS_EOI_BROADCAST_QUIRK)
+			kvm->arch.disable_ignore_suppress_eoi_broadcast_quirk = true;
+		if (cap->args[0] & KVM_X2APIC_API_DISABLE_SUPPRESS_EOI_BROADCAST)
+			kvm->arch.x2apic_disable_suppress_eoi_broadcast = true;
 		r = 0;
 		break;
 	case KVM_CAP_X86_DISABLE_EXITS:
-- 
2.39.3


