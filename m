Return-Path: <kvm+bounces-31048-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0924E9BFAC4
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 01:30:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4ECD8B225E5
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 00:30:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 473354400;
	Thu,  7 Nov 2024 00:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CkBjwNNa";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="kQHrvYzA"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D7E4C8F
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 00:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730939406; cv=fail; b=jmDz2CcVv2WcTvZmpNltguqI6+IUSJ2GMtDNI5wMejz6clAVzgSfjnzPahaONkDR3GtKhUnUKefwG712ekOCaMIkkfyKVeTCNeKzYqIcqkMHeY5Pn8y6VR0Na1HswQ46y30fLYgNJhv2Ll5bLqfULo5glzX1UJdbv/QM0uAQDdw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730939406; c=relaxed/simple;
	bh=fNDGiyX//hRjeSNQidcRjRnjvgXAeh/VmkCUzbruEdU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=INgCgHePKiZFSSaHBb7qU5y8QRsEJj54NGZcbDrihUre5Bwul7jDeW/L7ckQJS4YuIq2ZT68esi/0q3cQDFuE3HMlZmwHaoFIEi47SVO1U5XFs9kcTtzEkkrqh9B0jPLVMUUNgYgSpgwdvBz73IRqWAYzKyNq8EcVYyoZpzUBnw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CkBjwNNa; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=kQHrvYzA; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A6MSgSG002665;
	Thu, 7 Nov 2024 00:29:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=Ei7sKwgaxKaU3/YPAq2XBvFAfKi7TDt8fdI/pJ70k0A=; b=
	CkBjwNNaNSqNaNAVgq9Xy7oXV/KFwVDf2vVxxwk/adQQ3OwtrxRx86xxGZ1/FvB+
	UE6cpYn7mmIycgab7Zn7kiklhoxp9rTecjcRenz53RLL8VL2kGNRZOXRPF+qBlXq
	sWj6t8i7qF2i2I3VG2b3utvyekbtRil3tD9ZQiLApxHl1X32RJ7ttcmXP2ir78be
	0XkIGhQhy+3aQ6Q4kSnZnEQ8d2AnbrhhaNWGUndUnBG0oChElTcuiT6UBKwd4vCt
	jh+uVfwnBsww4muNqK4Sf0PEb8O00GOctSoQl+sSU1BsL3AaPDe/efc6KFWZiMIF
	rIBhAkaugA31DEljya8ELQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42nc4c1fgm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Nov 2024 00:29:37 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A6MJRmT036180;
	Thu, 7 Nov 2024 00:29:36 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42nahfkq6b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Nov 2024 00:29:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XpHFHn+sKpgujCow0UNabes7n6jKCP/JUsIImOVRu/KgqsFPya7tuu157+HmsRpBUWpQQqL26eClEoJ9XRqJK/QgQ01mo1GR8fXFkd9mWPBh4BQm2UOAN5WbpR0Tc6usMs1DlXpF3xZD4DOL3Qi9zU+CSgYRfk0ZXn1h/ogzra2G6w44LBkteP3IH6FCMGKbmVv0Ue4+cehQv33tqeg/lPGt+RXzdlarYmeZI49ixUca01avm+lm6QpJkTFgPHuhbu+ve88U38iBiC9tL5cIL5RPrihjA1JMFtKBJXtBR1x+xqY+nr+iPOV9fercpnD8N+occ0lVx68r5xlJ9k9Umw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ei7sKwgaxKaU3/YPAq2XBvFAfKi7TDt8fdI/pJ70k0A=;
 b=rTIBfufwfdX59ZIHvbZUnzm4vrWhGOviAdT096ue2DMs6A4dXzGFV5IbzYxUVrXf/RYWd8nMesttzHilP0aNR+LRsbSP4s2MsQ6xOyjUqVqWebSmzpNps1FEd271rw1mGUY+GlqiDaVALRsgW1JDcoFl1EUa/0a0K85UECPeW+4WO5hp+nys7wL1zILlClosItjsZAZDh4tGSTA4AEEdmy/PhCAkCzGsEIyHpxHoXNmgkoZYM10aQev56eM33pqI6oJrmchTL+WtSIem+lj/OnglOACexfFM5zU7KRGF4D9h9RhryWU3PGjEhV+OSqEIkUX/vM50pPf6HBBLE4/4Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ei7sKwgaxKaU3/YPAq2XBvFAfKi7TDt8fdI/pJ70k0A=;
 b=kQHrvYzAtcyi7o3NH6Wgt047/mS5XbqQia9Yg9yq+P08yPyZtI0Re/4Id29IuuLiZY+kHQ6luZvHVOWTq/zilnxI5mA71v6q2DYzJNbHw9N7aBnt3Ec9W3qNobeLhjEUHgSqtfAH3+jnjVsehjJY9qh5yqhAYpUodpStCtRTF4o=
Received: from SJ0PR10MB6430.namprd10.prod.outlook.com (2603:10b6:a03:486::20)
 by BY5PR10MB4131.namprd10.prod.outlook.com (2603:10b6:a03:206::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.18; Thu, 7 Nov
 2024 00:29:33 +0000
Received: from SJ0PR10MB6430.namprd10.prod.outlook.com
 ([fe80::e879:90c:8ea8:63a9]) by SJ0PR10MB6430.namprd10.prod.outlook.com
 ([fe80::e879:90c:8ea8:63a9%5]) with mapi id 15.20.8137.018; Thu, 7 Nov 2024
 00:29:33 +0000
Message-ID: <7497ade9-de05-49a9-9419-83e015646ebd@oracle.com>
Date: Wed, 6 Nov 2024 16:29:23 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/7] target/i386: disable PerfMonV2 when PERFCORE
 unavailable
To: Zhao Liu <zhao1.liu@intel.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, pbonzini@redhat.com,
        mtosatti@redhat.com, sandipan.das@amd.com, babu.moger@amd.com,
        likexu@tencent.com, like.xu.linux@gmail.com, zhenyuw@linux.intel.com,
        groug@kaod.org, lyan@digitalocean.com, khorenko@virtuozzo.com,
        alexander.ivanov@virtuozzo.com, den@virtuozzo.com, joe.jin@oracle.com,
        davydov-max@yandex-team.ru
References: <20241104094119.4131-1-dongli.zhang@oracle.com>
 <20241104094119.4131-2-dongli.zhang@oracle.com> <ZyroXEOsRPonKD7x@intel.com>
Content-Language: en-US
From: dongli.zhang@oracle.com
In-Reply-To: <ZyroXEOsRPonKD7x@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P265CA0021.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ff::14) To SA0PR10MB6425.namprd10.prod.outlook.com
 (2603:10b6:806:2c0::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB6430:EE_|BY5PR10MB4131:EE_
X-MS-Office365-Filtering-Correlation-Id: e8bac379-46e6-4ee7-2402-08dcfec33f8f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eTZvU255K0hob2FUQzMxSXRTdWVBcWdXSy9rYmVidkUwbXA0cDRqTGQwK3hJ?=
 =?utf-8?B?Wk1aZmZjYWR5VGZ3UnFPWnZtQ1k0Smc1d2MwamVqQXZHUHZ5Z3kwMjVQa2pE?=
 =?utf-8?B?RHdWSDRESDJBd0t2SW1BOE1qT0NCTW9PVndOaXhTb252UXRPdThmcjVBREp6?=
 =?utf-8?B?L2t2dXRQTVdmVFFrdmo0Yzd3cWpxWHJSK0dCZ3czUjJBdWFhWTBBcXJjMUJr?=
 =?utf-8?B?cW1hV1FOU2F4ZkdUNnUxcnRmNUlZVEZBb2kvZk0zVTNxMGM3VTlwMlJnNW4x?=
 =?utf-8?B?c0ZZVDZobWdNcEhkK1B6TWxjOE1kUHhDMDUwL2xBbE5mSHpPUVozUXZXd1Br?=
 =?utf-8?B?ZThtQ1I2eHR3NVlwMVI5UzRBV01CeDR2RE5nOVczdVJ5TlBPQmxXaEdRR1VC?=
 =?utf-8?B?bDdnZGNJRytYNHp6YlczLytRbXIzZDZZSHY5TFNoQjNrZVYyaE9rM3JmTUd4?=
 =?utf-8?B?Q3ZPNUUyN2MwMUFNVXdxbzdybzE5Mnh6c2dnTlZ1SG1sUUl4RDUwSjlLVGsw?=
 =?utf-8?B?ejdwdWRDUU5hb21LdmhLclYrTXhJKzhQMG9WVTdyUHBRb000VUtacUhmb2RI?=
 =?utf-8?B?dk1KcEQ0Nmh4cWtXcG85SDd0ZmtZbHhHWUk3OVpaSm9Vb0tTM3M5RG8zcXFB?=
 =?utf-8?B?ekhieEZkUXFXdWhlZXpqV01aVjFHTTNvWW84bVY2ZlcwZzFENzdMK01xa1Yz?=
 =?utf-8?B?elpEaXIvQitDdTlYQ1ZtV1JBdGw4d0hMdUs2Qy9xNlRLYmYvUjduWnFDQUhF?=
 =?utf-8?B?czlOdks4R0o5L0V2bmRjKzZURUdoNTBqbU1qUVAydWdRaFFIS0YxcmRpK3dp?=
 =?utf-8?B?N0taRGxKazBBTWZaTUg3eUk2Z3E4THE5N1dLVmdJZ0lUSlpMWHNndUFxSnVG?=
 =?utf-8?B?UWc1RG54cW1yaVNOYkFlaCtMVjF5MEVYNkFKekVZTXBmbEdWNVorcVV5eUtv?=
 =?utf-8?B?OXY2MXdOeDZocUMwbExOVXoxZDhhWHN0L1psSnB1cEk2UVRQSWU4WlNwcUFX?=
 =?utf-8?B?MCtFajh1SEpLUllaWXIwMXZFL3hYT2ZZV0Y2NFVaNnduTHBZd0FuMGd1NXZh?=
 =?utf-8?B?N01CdUxkWjZTa0xRUDZJcTVjc1pjcDY2NkVNWnA4R0VXUGdRRmhlNFBVVXdS?=
 =?utf-8?B?blJYOTh5T3U5Wkx4aTAzcDgrTDBMdXJRME45ZGJIN2dERGt0OW9DZ0M3OHRh?=
 =?utf-8?B?dFB2aHliMzltLzA5UjNxTmJubnBTZ0Y5S0txazMvWjFnaWFOLzFTd2VZdlBi?=
 =?utf-8?B?YzB2cUdrN1VlbVBCWUdHL0F0bitodUs4Z2xFRCsyZEx4ZWFnaXltTmZHa1Fv?=
 =?utf-8?B?TTduaGdza3RnT2FUbEhVMitrNGR2R0xzcjF4V2srZEtlaTg0ekpaUk9LUnR6?=
 =?utf-8?B?MloxOVhHYkVya0FsTlovU3JZWWtuWC9UTXkva2tUKytUWWlaUDhUTUdER2JI?=
 =?utf-8?B?elJacklENW40eXBudCtHZ3N3NmZsUHpEcUlIZG1QeDAvdTFockd3N2ZvdEll?=
 =?utf-8?B?dmJkdUNvMG9FZlZtSnlyNndmbHp2YXhlSFFseCt2RllvNGhtMzZ3NkJYazFa?=
 =?utf-8?B?RWVSZlRtMnhmWlNIUkJ2U1p4UG5ORGk4MTBiR1RHZURBODQ5RWZqOEk4aXpB?=
 =?utf-8?B?UW9ZSmR6MTFBL1RqY2tIell4WXZhdHc5V0MxQ1ZFbWNjWFlwT3RmaUhLTCtT?=
 =?utf-8?B?eXFjY0ZnYWM5dUxFMS9NZ3FnRUJuSG9icnhIT2JDNjVYeHQrczF4OG12cVNI?=
 =?utf-8?Q?jH1fY9PgwpO3Ky9S9QGeY3hwHYYTkuykOqSzWpa?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB6430.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZHJBMlhJMDFjcERSY3Y4dUZ3SU1uYTZhVGxQeHlYYzZ1ZE5ndlBvWFY3alRM?=
 =?utf-8?B?U01INzVTSjJFY2lDZHVSNmg4MkNab0phSGhZNlpvQ2Zpa01EWWppWktMMzcy?=
 =?utf-8?B?aUZtMlJZSWpQK1ZZNjI2ZXNteC9pWVVBUHN2MVNGenVGSnJQQzRTR2w5eWRz?=
 =?utf-8?B?T2VWNWthSThWcmNCeXFiMlBaQU1tQWNVbTVqa2JaU0FNblkzV3VlRnVubEhI?=
 =?utf-8?B?eno4TEJ4VHVmckdNdlJENWFLYVhlRHJwamszRWNEU2NMVmI5QzJxaDhaZmU3?=
 =?utf-8?B?bU9iK0tTZ2Z4M0hIS3J2NStVY3ZJalEvMXkzZXQvSmEzT3VFdWhzUDkxYWln?=
 =?utf-8?B?cVRuTVEwcUVIRlM3NWNQN3g4T0hlMXBqclo3OFRZVmltR1p6aXhnVlRYTEND?=
 =?utf-8?B?VXFlNndtLys1Z1FiZGEwWVR0QTlxYVc4RnA3YzdmTmovWHFXR3NCL04yY2JJ?=
 =?utf-8?B?R2ZLVnJIck9lbmpLV3U0ajZBNTVVYnBUWENESldDZDFVNDVvRGZ4UkM2V3I4?=
 =?utf-8?B?RllyNzhHclFUQzhIVWwyS1M2KzI1VUdyQUw4bm8vUlNhUTc0MUJpUnpOKy9s?=
 =?utf-8?B?VlFENWZ0azQxV0FFVUNVVjNFd1dKTXF1OHAwZThvUHVscU9GbkVNRzlmV0NX?=
 =?utf-8?B?a2xNRzJBblY5ZTFKTitrTDVIL0pmd2t4SG9IVDgxaXlaU0dPcXh2V0JEM3U4?=
 =?utf-8?B?Q0tQclBEZXBKc2VZVkorWHRXRFp6Q3orMzZHOUk3ZytrUWp6UVExTFpQWDJH?=
 =?utf-8?B?clAwWGw5RVpyR3RoZnk2dlpJQktkcGhLSEt5K01XbEZwOEZuMmxDc0w3dDlZ?=
 =?utf-8?B?eUVydkpKa3pvci9Oa1A0SHVPVEowMEhFY3JzWFMzWmVkd1AwaEhEVlZSRkVi?=
 =?utf-8?B?emZzRDBudHJkZ1g4VHdpNTFuUHMrbXllV0JOZytLaEhodlhQOEhuTkFBK3lX?=
 =?utf-8?B?OWk0L0ttNEhTT0tNbjM2bjY0cHNpZ0dPOHBQbU1JYjhzS3lscldMRGIyWFho?=
 =?utf-8?B?c1IvVkhDT3VzR254M2lKcjVsVmlGSEQyVDdCTDJZSVNHTXRyczFjUEJBQmln?=
 =?utf-8?B?VUxmZ1czMXZ3OFlzczQxRlB0NCtFUWdMRGF1RFdoaWVqbGtXMUNzendCeEdm?=
 =?utf-8?B?Rm1vQUtxK3pEZS8vVEdaUWJSbGlVZWdKeGJ0TTRpbnhTWnl4YTdNOGxLamgz?=
 =?utf-8?B?SHBLNDlSS3pMY0V1eXJ6UlJRN0RwWVpmREhRbXBucnJFRGRHa01pY3M5UGdO?=
 =?utf-8?B?bzhSbjloeEVZR1BWRyt5empVRWRqczFpREtsRjNUYUNaR3VrZnZjckZZcXE4?=
 =?utf-8?B?QVV0K3pmS3JLUXlkVG9sdURubWJIYnU2dkJpaFpFTFA1QlNFSXpJZXBVYzhj?=
 =?utf-8?B?eVE1RUNRczVoTHpzcGpHbzN6K3BPK0xxZzl2NUJsbFJXNk9acjdwTW4rVENM?=
 =?utf-8?B?RGUxLy81M3EzdE43Z1VRYXhYV2JoRzQ4T1VEdVAwV2Ewc09lUXB1bzdPaGdJ?=
 =?utf-8?B?QS94VDFSM2ZZTXNxWG03TFFiU0RVVW1pVkxyeGNpc05XYVRWYm5ERldwcW9K?=
 =?utf-8?B?VnVBdXFpTUlMc1ora050Ny95d2RHL0MwTitsV3JFbjdVN2NHS0ovWks2U1My?=
 =?utf-8?B?ZlV0d01KN2c0OVpLS3gycWg4TUJxVGp6Y0xLMDBGdlUwbFFLYzQybzErQlo0?=
 =?utf-8?B?TWFaZ0pMckVCMnpTREVLZDNzV2MyVzc0OG1FYzVOamZpQmQyWWFJTzZ4akhr?=
 =?utf-8?B?aGdvREU1WXFCYU1zT3ZKYWdxZHVUL2lpam95aWI3S2s3ajVhTUFrQlZOZDNC?=
 =?utf-8?B?VXl0T3ZLWVM1MTVwUTdJdE0wc3h5T1Z6OEUrYWR2Ym9nSjExbm9MWFFyMXQ4?=
 =?utf-8?B?OG9lVGN4THZadnV3bkRoK3ZsbUtVTitKbEZwQ0VSSlJaWkJNbGFTdUp5MWwr?=
 =?utf-8?B?WS84Um8wcnVDSjAxRXZXbkRleHhRb0FLSlNWQmtuTFYwQ21tck80WGpyTUxY?=
 =?utf-8?B?YnQrNnBsd1pjcHpoS0IwY2l3c09XTmFmK3Avd1BVTVlwYkJRQ2pwZTJVay9U?=
 =?utf-8?B?alZaTEtacVVYU25BVVYvbEJGT3RhSFRFSlU1RTJKeEdWTnNkNDR0ZE1EYmRs?=
 =?utf-8?Q?nDkhMv3tyVBylYStjeF8KCk9p?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	srn+VoaQD7UuKXWyEjQYjJo5hCUOa7VN1WmgXSkkXDNRxLUQmTLWtg4FHvLYdh+QgGMNsrMWBWsxRaPZakkCT07M0wtMB4nyrUJMQ+XqIeBNxdrI/qF4C+n58CQQMZ84ecZB31bzZs5venkayl3y5ph3DPTFHrvRslc/qzYpAQ8rFt+Lybk25A70zioCzvyKOdUQkcXmoF7xULqXcf7CyS7nfw0S43yoYf5U/46YrOH1Gaz4+LF5MV07UbO8pIJlAyfHDncfeJYek6s/jdydWN1qn0PC3qyjKVDdiSbNjkrSE24oJlgRzBZC4t5uwXfmDFXSBVmeWYMFXiuFr6+nKhb/djcKnFBMIOme3/M4rqkj1Av7tspkZU7o/CmbaUwm/AA+dkr6yne1vxCzehfndgL+jlXOP2XHcC8ofg349RayW6rAWEAq6EctODvGs/5m0O2LO8iQrD+NgIZKZx0m2/3wIVXciCvUvy5oiWDpQ57ED3hZL7dEF2Kw36lDSi51aZE8CKR3tM9M/5ZjhUnojopik+8VyTRVYxZZap5jYzWva82b0lxU1KX2N/c8pgXffy/qDXVJQPY1b9R1O34sVFgf+kWEH3B7279zYqE2TeE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8bac379-46e6-4ee7-2402-08dcfec33f8f
X-MS-Exchange-CrossTenant-AuthSource: SA0PR10MB6425.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2024 00:29:33.6066
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YhRLLYi1la+3pQckIoF/NzJGm6W6yAWE/L10cn7R85mIFpFkiOIFZBzBErnhVzEG1HnFueUzQ/3y3FiC7VCxlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4131
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-06_19,2024-11-06_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 spamscore=0 mlxlogscore=999 mlxscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411070002
X-Proofpoint-ORIG-GUID: Vlw-LlzlOvSxwquoDstscXeP13hYL_iN
X-Proofpoint-GUID: Vlw-LlzlOvSxwquoDstscXeP13hYL_iN

Hi Zhao,


> 
> You can define dependency like this:
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 3baa95481fbc..99c69ec9f369 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -1803,6 +1803,10 @@ static FeatureDep feature_dependencies[] = {
>          .from = { FEAT_7_1_EDX,             CPUID_7_1_EDX_AVX10 },
>          .to = { FEAT_24_0_EBX,              ~0ull },
>      },
> +    {
> +        .from = { FEAT_8000_0001_ECX,       CPUID_EXT3_PERFCORE },
> +        .to = { FEAT_8000_0022_EAX,         CPUID_8000_0022_EAX_PERFMON_V2 }
> +    }
>  };
> 
>  typedef struct X86RegisterInfo32 {
> 
> ---
> Does this meet your needs?
> 

Thank you very much for the suggestion.

Yes, this works. The PERFCORE is a prerequisite of PERFMON_V2 (according to
Linux kernel source code).

1403 static int __init amd_core_pmu_init(void)
1404 {
1405         union cpuid_0x80000022_ebx ebx;
1406         u64 even_ctr_mask = 0ULL;
1407         int i;
1408
1409         if (!boot_cpu_has(X86_FEATURE_PERFCTR_CORE))
1410                 return 0;


If you don't mind, I will send the v2 with your Suggested-by.

Thank you very much!

Dongli Zhang

