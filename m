Return-Path: <kvm+bounces-67203-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 660ADCFC83B
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 09:08:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 594ED307BE4D
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 08:06:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4C1B2848BA;
	Wed,  7 Jan 2026 08:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="djYRwbLk";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wZclHDr9"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DECD3BB4A
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 08:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767773169; cv=fail; b=oTPsCjZASgWRZW4VgVu5FxE/pkWvpszefGxcO+bdtGewvLiXQ+iGM9HFYwFQKM1oUPhZhSW4ReBjQyFatnue1cviiv0WN9RFJqZLaU5H3u2kr1auhR8+rWjGO2QPLvmL7Tt9JKy2M7z8en5AHA/6yOH3gfDk6opQTvNAZ0rUlsg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767773169; c=relaxed/simple;
	bh=6cA4OpH7tv6GN5kUu1dMxPrGhBAjVeZf4m8icOtCuQE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GcSwDP4n9V2s7404+Wjm3RHbf1FubC9DOQrJ29CCj5hzC2JQ6wzRlblaDIqF5oSsTHqSytK31QdSVlPNiXE6Vfda0EuYltNNJ1t+pNG8B5MlatkknKNiKiZpU3fsghaYGainW/2O2xVXxRm/gs+pW0YW7R17UD96ZW80e1+at7Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=djYRwbLk; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wZclHDr9; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60776Fwx1162664;
	Wed, 7 Jan 2026 08:05:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=jFvkQwNjWbQoSBlB5+Y2E9JBAft6gignLbIBqP4VQ48=; b=
	djYRwbLk85SFFj6tpAwzJIei7hFQeTrRbRLzGLo8qDQmTfZ4R816Vr9CYaVo16Mw
	fF0fg7SqWnqRtvecDhi+mBCAz8U1U9RyvLfMRgQGrDq9iRU13msB2TwIkymu+V3d
	+LTUDXtBHSDqRmkRRZ+PCX4YMJ9iqCvUzeuyAQ0CWn53ygNKqRXFP5AK6oqOtCNL
	5gShEdKuZCLYXvfrgP4Cyy2/e5WKklxAe5xDiexF9Y8mw9Y6roTbV51EV3oP/nNG
	XchM6+vSi3iHduvfM8FGy6LvlH1P8V1T3OHqqwdkoon/Z+p1aC0099ViPehe2DSw
	psCCUd8Hj+ZSYBm/Q0b/kQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bhjt1r1nt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Jan 2026 08:05:28 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6077gJqK027432;
	Wed, 7 Jan 2026 08:05:27 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011067.outbound.protection.outlook.com [52.101.62.67])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4besj9amqg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Jan 2026 08:05:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nXFBxGVjKUr5aD2EwXwC4/ks3Gx/bo7Oe+FepO9n2A1iSHCkCcp+EzLy9dzefFWtek5vlXa6gb3e9Y2fAo1OC0nmDep0mc1WbOCRHesl9s5BNNKDyMaeaY8vDLOYoTKejSCv9ya0a3RmZIUgJugxArNj/ryYzXTadtBllSGyP/RoQ8Jd6ENIFYZfRvB/WAMxh50Kt+QirtZlLgrgVxELEfcwJSNpBPNuP+Ubj3SYe3OIs/LnY+jOQXVj9oVOipyrA3D2L+xz0HMi4m5AZttr5El741wINt3wWO55ir22awJV+CitBfBbMWH9272hwtJMukURtUDJb67nnG5Ewp90zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jFvkQwNjWbQoSBlB5+Y2E9JBAft6gignLbIBqP4VQ48=;
 b=GClhk2NvXn927u9knmEqBFvUCI+8aB8Q6tWeRYeCUW6kwg2sH6UwulxBugmC+B4WjbbCYMyPfBdI/wUnt5DwwcmmbqdWK6DgVH5FuHBBVbXv90SewHNQVgfwlihN3B1//LLXw2+0TslQbZkW1Rjw9cBOR/k7ILFa6GHQw8rgbZzSuqq9/MZzvyfx93x4k17zjk4Iuq76M/XFXNNm9BQtQvkyWxjupGZV6OqpfQxB0s+1DgBacpLltNrSEH2LKyIjeHL4o3vIPNSHt3rhST0N//ojOlSQ6kZvWJMcbSUNy1Lvcfq8ofKbNJUZaLEYBRN1gAd4KCXrmVtM5sfLNXV1iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jFvkQwNjWbQoSBlB5+Y2E9JBAft6gignLbIBqP4VQ48=;
 b=wZclHDr9hA3KGXH0Iu9s5w/jTq2TM74eyPEfNTj05Wp7/dV4Q/LHHY2BbtfGyn1/L5DSizqLCGMffOx21+o98FHN3FJtjKKY1IFNzCoAmTnhGN5MH6VVfJkxYgNWwqJLladCrU/uAeFTM+XfKNURERFMkQFTDWXeuqN9pIP74Fg=
Received: from DS7PR10MB7129.namprd10.prod.outlook.com (2603:10b6:8:e6::5) by
 BLAPR10MB4850.namprd10.prod.outlook.com (2603:10b6:208:324::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Wed, 7 Jan
 2026 08:05:24 +0000
Received: from DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::721c:7e49:d8c5:799c]) by DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::721c:7e49:d8c5:799c%3]) with mapi id 15.20.9499.002; Wed, 7 Jan 2026
 08:05:24 +0000
Message-ID: <1a5e1552-0e61-4829-b6db-99914184eb7a@oracle.com>
Date: Wed, 7 Jan 2026 00:05:19 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 4/7] target/i386/kvm: query kvm.enable_pmu parameter
To: "Chen, Zide" <zide.chen@intel.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com,
        sandipan.das@amd.com, babu.moger@amd.com, likexu@tencent.com,
        like.xu.linux@gmail.com, groug@kaod.org, khorenko@virtuozzo.com,
        alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
        davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
        dapeng1.mi@linux.intel.com, joe.jin@oracle.com, ewanhai-oc@zhaoxin.com,
        ewanhai@zhaoxin.com
References: <20251230074354.88958-1-dongli.zhang@oracle.com>
 <20251230074354.88958-5-dongli.zhang@oracle.com>
 <b6c531d4-328d-48a7-856b-051c918c24ae@intel.com>
 <29969c2f-d71f-4952-9ab4-4ba8f69e1514@oracle.com>
 <e9762b91-175e-444d-b64c-dcded943b312@intel.com>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <e9762b91-175e-444d-b64c-dcded943b312@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR07CA0015.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::25) To DS7PR10MB7129.namprd10.prod.outlook.com
 (2603:10b6:8:e6::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB7129:EE_|BLAPR10MB4850:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a0e955c-fe47-4ca0-0284-08de4dc382ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WFhwbDZ2SU5Mb0JZd1Q0bU1PbUVHa25odUMxdWYwUVU0SjNpY1gybG13N0NU?=
 =?utf-8?B?ZDFPNWlNdUtmTjBiVUJ0MVpMRmk2UUp6U1ZYdUJOQUdFNWJBbzZrWXR5RW9S?=
 =?utf-8?B?N2NaTnlod3hEQkNUNjZHWTJjUU8xc2h3UXYwWWozektORTlrMlJrVUVoa2J6?=
 =?utf-8?B?UkF4WmdLSTNqYmNPOVY2ZGk4cU55WkEwOWVPbnZPVnVFMWhMWFhpSE5ZcER0?=
 =?utf-8?B?dkt3bTZkSmJoNUhReWQ5b09HK1V5MGRBYWZ0WnlMc2MrNzczb2lHcUp1cXM3?=
 =?utf-8?B?VE9JYk5GampUNkV1RUlZaHJVWkpwVzlKcGhud3hwUVIzUVROT05Sc1d3K1dG?=
 =?utf-8?B?bEZtK3ZKSStKelBYUWVaNklrUXMxM1NqQlNqNkl1eVlhRHJ3UG1CYzltdzI1?=
 =?utf-8?B?NlJCU2xmVHloUWxMU3VIZlVYZklmUXBxbXYxQm5pbStQKzYzYzRFSjJZN251?=
 =?utf-8?B?am1ERHliWnFzdlppNnVKdk9HWHpTZXBKZ2NOTENsb0tiTTRVaGhkaGVkdFAr?=
 =?utf-8?B?S1dxSEtSYjdCUG4xUHFicWw3eCtZYkNZYnh4blpNSWlGaVd6TCtXZEhHYzdz?=
 =?utf-8?B?aWJBNzNZVHV0cE84VlA4dTNQT09rajdScUVTUnJncElJTHN2OGtKZm45cGZV?=
 =?utf-8?B?RzVwSE85M0FNMlN1aTRzcWtPb003aDc2VUIyUHVwWC9XOVR5Q0tkZFlhemFX?=
 =?utf-8?B?OXZiVEdjM0x5T0N4U2I3akNRTURyYWFuSm9yRjlVc3NjYTRpUzd5RkVIakZE?=
 =?utf-8?B?REdiNExJbUxlbVdZeFVtdUE5akEvOFpuWm9GZkxjYU9iQjRkU1hmUHBFREhO?=
 =?utf-8?B?WEVVcTI2WnFCbDZvL2U5WTRESFZMNjd4TS9lRS83SjVOSFBNa3g5aEdza2Q4?=
 =?utf-8?B?NTVNem1QektPUXdCU0lSMDJrMWdWdFlxdkhtRVFYdkszbElLc0xyMkU0cnUz?=
 =?utf-8?B?aitaMmlYZHQwdlc3Vkk1Slp0bXM4RnNXOUJJaXVPT1dDMzM3dTNLL3NMWXlW?=
 =?utf-8?B?aWE0dXpGVkRsQzhMVDZ5TnYxQ1IvNzhsSDJpLzBuZ3BrQjdWejFkVkhpamFY?=
 =?utf-8?B?dmxCY1dQUERvWUwvRlU3aVhLajVFSnJtVDZ2elVwMEN6dk92NnhOWnkrTVFC?=
 =?utf-8?B?dHlqOGZFbVJhMHJ6ellOTXJlTzJma2YyYlk1R1dJMVJ1NENOa2tiTW5CV3Ja?=
 =?utf-8?B?bnFrVFZtdUt2eHZmNHFuSlVqb01QQmR1dkUxQXEzQjUzL1JwczJycDErQmFQ?=
 =?utf-8?B?T0tJOFhqSjluSnhCWGJJVEtoUU5BRGlkTlBETEdJV2pvUkl4QzRHSHpCaGR3?=
 =?utf-8?B?S0E0K0RwUmhwL25wVHpmbmdsOUxIazBjV3NybzJrMTRqcWZaVGZzeElrR1pq?=
 =?utf-8?B?S2tQRTduSXBaMGYxTGxKdnhTeVM0Zng5MTI3a2dXNnh3VzFVbEhLa0NVTXdC?=
 =?utf-8?B?UjRWQmxLQS9iRTlQNmhkZmI3cEluUmcramQrWjd4akd6SkNZM1loZ3VRNmZ4?=
 =?utf-8?B?T1hzNWJtY1plZ3QvaC9nU1VQNk5JZmErV0Foa2VUM3FQWWl2L1U5dnhma0lW?=
 =?utf-8?B?Nml2SmR0SzI5dUR6eDJxMThaUTdUbm5qQmtvdE9qd3A4V3k5b1ExY1R6NU1y?=
 =?utf-8?B?ZVFuSGJiVWxyNndxeFBaYU14UmxkSFRtZjZZMGUyRkVINkJ6OEFGMExpb00x?=
 =?utf-8?B?amlpelVMdGtORDJwdnlldDRkdVNVK0l0UjFMQVZqRGNZQ2ltWDg0V201YnU1?=
 =?utf-8?B?VnpIU3A3NnIrUjM0bDRKTm1uRkNNZlZXbmFVRjY4aGZXUDRnTmM2SEtOaHdx?=
 =?utf-8?B?NXg4MmY1K1IrWnBtY0FvNHA5NlAyU1NqQTlzY2dKeG5MVnVGeEdqNWY5U2pY?=
 =?utf-8?B?VnVwOUczaEhGT0RYeHBUQlRBd2YxN3o0MW9TbVVWaHNaRmdBUCtsTnJVK3VF?=
 =?utf-8?B?TDZ4eVkwdGZXVG1teWk5alZCY09TbXRYeVNlLzNMS2QrYWRIM1Y3MWVuQjNy?=
 =?utf-8?B?S050blA5WmJRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB7129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Vkw5UXZQR3l6aGsxV1NpQTZDckFUdWJ2dkJ3Y3ZlRGZJNXhFZU92TVZhM2JQ?=
 =?utf-8?B?VmdobHJpY1BoR1VJODdZMUYySlJoc1VFejlRSlFHcTArOGgwUUpsMGZXM1ZQ?=
 =?utf-8?B?L2hGVE83RzEwQ0huWGRoSGR3M0ZkZFpUaVM4ZjdYK3V6TXplSUNHaDBlaUdT?=
 =?utf-8?B?SXg1TVpQSjlzUTdIaTVhV0hVYU9LUmxGV0x0TVVpelVGbklSenN6b01ZOXV4?=
 =?utf-8?B?NTVab3ZraldSMmVyUEJCdkxMQ2FVU2VCeUMrd2dydjNsTWI1UnR2aGVLbXJq?=
 =?utf-8?B?cEQvUkFMTTdaSHBXbkpVMml5LzBxdnRXekdhWnBOMDZVUFpaSFRjcWlOV0h1?=
 =?utf-8?B?UTZYR3VESGVJaDlHUXFNcTRTa3pXVFc2ZzhwNS9TQkJTZ2FKK3BOZTRTMVdw?=
 =?utf-8?B?YjZ5cXcyeWRtMk4wUG1SUm1zSUp5cmFtMXFkSGZscmRiRDZrQTlLb0xHYUZB?=
 =?utf-8?B?R29mbitmOFF3Y3J0ZXZnOUJ6bUNGTFVhSzVkVG95MGs4aFZzWXdFdnJoaW1F?=
 =?utf-8?B?OXRHVTdKRWcxWVhCYndsNHVUMTRIMS9sUlgzMStlcCtzUG9OZHJyNk9LT3ND?=
 =?utf-8?B?bnRrV0k4RVJJcmxQa204K3YzR3NIQ3owMStPNU9nVmZLRldlaC9XYW92RXJH?=
 =?utf-8?B?ZGI2Q3ZMWWxFNURzQzJHRUQ4MU85Tld0TitFVHFzT2ZKbWRIREFoSW1rdmFB?=
 =?utf-8?B?SFpxbVoxRUR2czJBUXI4SXd6QjZlTnZOdDVBTkJTTGh3VEQ4aklwZWl0RkVS?=
 =?utf-8?B?TmJBaGtsYVNlNS8xcHd3bStBblBPOCtlSjZTclJScFZBSWJnemNmL1ZrNWhK?=
 =?utf-8?B?TVZLaWxjUUJsNkVxZWZOcFp4U0FFbm5xZEF3TTZZNGdOUFZCQ2t3cXI3TEpB?=
 =?utf-8?B?SUUyWjM1Y0xJU3BpNnVZNGRpOHRJQlAraWJBZEpDWE11OVc2bUtCSTBQa2JM?=
 =?utf-8?B?ZTVBSEp0endMY0V0eWlyREVNZ1pwU0dlNjVpYTVlOW00V0hLdVoxajgxOHdN?=
 =?utf-8?B?a05aR2xwYUdyTmdENkN0WUcwcjBZd1JPM1pqaGZMZkZsc3EwendKWlM5d0ww?=
 =?utf-8?B?dGVwOG9maDlUN040K1pZKzUrd210VFN4WGlmK0hZRXRKajdhYURrNFFXTTBp?=
 =?utf-8?B?RXlLT1VYQXZXd2FZQktGWTFYWnFERUNtUE00cHhpU2NTbldsaHpia1FOemps?=
 =?utf-8?B?ZzEvUCtPTnd3Slc5QXZJeitFWlpVbmhtMjhoQXozcXJEY0pockN0VmZRckcv?=
 =?utf-8?B?UjhrZ251R1lQVHYyTDNPbTB5YVhqVHg1ZDZTSHA4emMzVnhzOFVUbCs1eTl1?=
 =?utf-8?B?WEdHK0dQcmpOZEtMMElydU1tUXV5d3ZGNzhhaWlPbkpnb3Y1ajhwRDRkbXRi?=
 =?utf-8?B?RFgrbGlITHY4KzZKTDNwU3Q3MG1hS3gxenhlL255ZzFTOWtlY21mTlNPTUlV?=
 =?utf-8?B?TGJhb05iTDUwNzJaT1NHMG9oL3hMV3FJekdPY1NaZjM1VnZwWE93MUFJYWNy?=
 =?utf-8?B?cUJXc3c3VnlVMkNLNFdlREYrS2RicXlhRGtoNXdtVDQ2Umw2VWQ0emVwbGdp?=
 =?utf-8?B?SzZPMExTVXBqTi8xbDg3TWdUL2hVdVAvNkZNNHEzenNyU1hUMWtIb0lsODFq?=
 =?utf-8?B?TXIyeENnK1IvSTN1STBxbDQydXIxUm84TU5iejRINmdMdWE4RXRrYnlDd3dV?=
 =?utf-8?B?UUdTa2IyeU91Vm53VVQ3RjhjeGMyZDhOdHlSZjgrL3dUVWY0OHZ4S3N1VHdZ?=
 =?utf-8?B?MWFvbmNGcTZCMHhLZXJkK0hMd2ZRdnFmQ3ZsbVp5K01OZHQwcmYwTjU4SEhC?=
 =?utf-8?B?SHFsRW1nOTBFZFVzUEgveHBqblNBWnB6dHZVRTRvTkJYNXp1bmQ5M1RZWnN4?=
 =?utf-8?B?SFVPM2F0NE1HV2g4cU83RDJEdnlkOGJXUHBxZlIrUjd3QmVvQnVJMkJQcnpG?=
 =?utf-8?B?ODV4Zk5LTVNFOUtvYU1VRXhJT2lYQXNJaWd1VlpZSnk3ZUhqaDNXOTV2OFlk?=
 =?utf-8?B?WjUreWU1ODBoU1JYcEZrM0tZb2pOT3BuUG40ZVdqLzB4bC9xQTdua3RQRVRx?=
 =?utf-8?B?cUxTTUVwZ3UvajVudHVsbVJkRmhiR085c3N3ckQ2VGx0WUdYcTh0OEhrWHJk?=
 =?utf-8?B?djhLbFNMOXYzZlQ1WjNUaUNxVUk4c2RYa1hnbHNkNnVGWG1BMVNFdlhUSlVG?=
 =?utf-8?B?SGthbWZJK0NaVkxJWTg3U05YdEtzU1Vuci9LSVYydTJJaW5wUE02YzdSQmZP?=
 =?utf-8?B?QTRBN2d5bEIzbXVodnlQeGVkQ1VCZks4Zlp5SXBIYytiQ2hyUGk2N012SjRL?=
 =?utf-8?B?M2Njc3dFNGREQURlRXl4TjdUVjg1b296RGtmYmJtNUM2dmFqUW94UT09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wLscsn7k3SNQJIIRhjqmoU4yzbXWj81ESFaARkDDGjWmTvWqJWFNTiiCuU3tqZCZ/IC0OmTKzLp1MyBQ2Vtn+vWxM89g+P2LRcoQAAVsQ/Zgz60SWgNNn1RkfglAZePcfMNHl2E7dacBmpi+61FypRG8jxp51DrrPILXw1K/ohqHxJ+It+uW0U7ozlt+2JsOyamkA84FM7OAczmcsGmxLoWj5IiDynCfT6UNWzDEiKtmAkaBPdHZYgVAMBXubxHNIbOKgNGUH0DjL57SBBESWdIq5d33CL+KG53fPyo/cufZSggce8Jlu71/Hb5/TcgFAwY/jrIo8fXkVvi8wwkxgRtsHkg3ojU21L+SThel35RW/5tslVXDxZXpzMZeP42Wx09/0jBLiXkbvXUA0JU+hX99vOJyPOv+brA+7MpOJ/iPmpLgVPYf1PpqLmRJ6yfa3NUFZRTHSf9s1FyzulRSfZE20e4p/GEcNOuasbuRG7dW6bN1glBD/wHogvDOQ+VxRyYwqCzc5YGkccUZLB45ahqagAMA6y6n6HFK1wApWBoa3IkJNFfbkQsnvRC0rC7pzlZvrDVU5zTtchSLWwIS5CD61FSjAXj5lrcWey3+3DU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a0e955c-fe47-4ca0-0284-08de4dc382ab
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB7129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2026 08:05:24.0887
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kupXYl+qtq6PyCugToPcFVCkAfajLaAHghdNNNwIqpYo6EOFB4iEV1zwVRdzZa2Sya8mLwiW2xSVQyFTrUkyPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4850
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_03,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 spamscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601070064
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA3MDA2NCBTYWx0ZWRfXwzOaTU48gjLd
 L+/hkLofkgs0g8C8eijn8hEoYCy+8LRFPyq0A5oe3D+IfYRfl8TveYIzafPM0Pi5l0GcJMRWYnh
 FPUCcPDOi8hi4SiX+VPxrlHUazMfBBOG6H8GR2svSDkrIRoKEC8UVo0/bCFo9wRac0WECpS7yax
 ClImCV6P+PTsw56249fdz4nvUxJAQCiOlpfT8J5XJQhOFBYX9A1Qhl+JTQhoK6wbkfKlUPwqZSC
 ozmiTSLeO0NcaCVZ6zDyO8x8+vxAR5sYuI4ufbZgxAAeazLqhdNK5BqraH0jszYO8pOFWmYMPka
 a1vYJ/76jb3c42pycFxieRntbtzGB8gxtwk/qTknKs/vyRTkeKJKhgnSH3TOCwSxmQ6dDUu4pAl
 Empk27PXBJTMIFpHt6uTneCY0abo0EGiVZvTl79d4NudDwrsLXZrYmyr9WzWXpqJ3ZFypRIQdfV
 48fXxUkGn5ZgUzvPLgg==
X-Proofpoint-ORIG-GUID: dYgP1t2BGb05iPeojJEdZH-YlAmIfkVN
X-Authority-Analysis: v=2.4 cv=ZbQQ98VA c=1 sm=1 tr=0 ts=695e13c8 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=6R7veym_AAAA:8 a=1XWaLZrsAAAA:8 a=Ph7Nkl7nynDjECrrM8QA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=ILCOIF4F_8SzUMnO7jNM:22
X-Proofpoint-GUID: dYgP1t2BGb05iPeojJEdZH-YlAmIfkVN

Hi Zide,

On 1/6/26 1:03 PM, Chen, Zide wrote:
> 
> 
> On 1/5/2026 12:21 PM, Dongli Zhang wrote:
>> Hi Zide,
>>
>> On 1/2/26 2:59 PM, Chen, Zide wrote:
>>>
>>>
>>> On 12/29/2025 11:42 PM, Dongli Zhang wrote:
>>
>> [snip]
>>
>>>>  
>>>>  static struct kvm_cpuid2 *cpuid_cache;
>>>>  static struct kvm_cpuid2 *hv_cpuid_cache;
>>>> @@ -2068,23 +2072,30 @@ int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp)
>>>>      if (first) {
>>>>          first = false;
>>>>  
>>>> -        /*
>>>> -         * Since Linux v5.18, KVM provides a VM-level capability to easily
>>>> -         * disable PMUs; however, QEMU has been providing PMU property per
>>>> -         * CPU since v1.6. In order to accommodate both, have to configure
>>>> -         * the VM-level capability here.
>>>> -         *
>>>> -         * KVM_PMU_CAP_DISABLE doesn't change the PMU
>>>> -         * behavior on Intel platform because current "pmu" property works
>>>> -         * as expected.
>>>> -         */
>>>> -        if ((pmu_cap & KVM_PMU_CAP_DISABLE) && !X86_CPU(cpu)->enable_pmu) {
>>>> -            ret = kvm_vm_enable_cap(kvm_state, KVM_CAP_PMU_CAPABILITY, 0,
>>>> -                                    KVM_PMU_CAP_DISABLE);
>>>> -            if (ret < 0) {
>>>> -                error_setg_errno(errp, -ret,
>>>> -                                 "Failed to set KVM_PMU_CAP_DISABLE");
>>>> -                return ret;
>>>> +        if (X86_CPU(cpu)->enable_pmu) {
>>>> +            if (kvm_pmu_disabled) {
>>>> +                warn_report("Failed to enable PMU since "
>>>> +                            "KVM's enable_pmu parameter is disabled");
>>>
>>> I'm wondering about the intended value of this patch?
>>>
>>> If enable_pmu is true in QEMU but the corresponding KVM parameter is
>>> false, then KVM_GET_SUPPORTED_CPUID or KVM_GET_MSRS should be able to
>>> tell that the PMU feature is not supported by host.
>>>
>>> The logic implemented in this patch seems somewhat redundant.
>>
>> For Intel, the QEMU userspace can determine if the vPMU is disabled by KVM
>> through the use of KVM_GET_SUPPORTED_CPUID.
>>
>> However, this approach does not apply to AMD. Unlike Intel, AMD does not rely on
>> CPUID to detect whether PMU is supported. By default, we can assume that PMU is
>> always available, except for the recent PerfMonV2 feature.
>>
>> The main objective of this PATCH 4/7 is to introduce the variable
>> 'kvm_pmu_disabled', which will be reused in PATCH 5/7 to skip any PMU
>> initialization if the parameter is set to 'N'.
>>
>> +static void kvm_init_pmu_info(struct kvm_cpuid2 *cpuid, X86CPU *cpu)
>> +{
>> +    CPUX86State *env = &cpu->env;
>> +
>> +    /*
>> +     * The PMU virtualization is disabled by kvm.enable_pmu=N.
>> +     */
>> +    if (kvm_pmu_disabled) {
>> +        return;
>> +    }
> 
> Thanks for explanation.
> 
>> The 'kvm_pmu_disabled' variable is used to differentiate between the following
>> two scenarios on AMD:
>>
>> (1) A newer KVM with KVM_PMU_CAP_DISABLE support, but explicitly disabled via
>> the KVM parameter ('N').
>>
>> (2) An older KVM without KVM_CAP_PMU_CAPABILITY support.
>>
>> In both cases, the call to KVM_CAP_PMU_CAPABILITY extension support check may
>> return 0.
>>
>> By reading the file "/sys/module/kvm/parameters/enable_pmu", we can distinguish
>> between these two scenarios.
> 
> As described in PATCH 1/7, without issuing KVM_PMU_CAP_DISABLE, KVM has
> no way to know that userspace does not intend to enable vPMU in AMD
> platforms, and therefore does not fault guest accesses to PMU MSRs.
> 
> My understanding is that the issue being addressed here is basically the
> opposite: QEMU does not know that vPMU is disabled by KVM.

Exactly.

Otherwise, QEMU issues unwanted MSR writes for every vCPU during QEMU reset.

> 
> IIUC, one difference between Intel and AMD is that AMD lacks a CPUID
> leaf to indicate the availability of PMU version 1. But Intel
> potentially could be in the same situation that KVM advertises PMU
> availability but it's not actually supported. (e.g. kvm->arch.enable_pmu
> is false while modules parameter enable_pmu is true).
> 
> From the guest’s point of view, it probes PMU MSRs to determine whether
> PMU support is present and it's fine in this situation.
> 
> In userspace, QEMU may issue KVM_SET_MSRS / KVM_GET_MSRS to KVM without
> knowing that vPMU has been disabled by KVM.  I think these IOCTLs should
> not fail, since KVM states that “Userspace is allowed to read MSRs, and
> write ‘0’ to MSRs, that KVM advertises to userspace, even if an MSR
> isn’t fully supported.”
> 
> My current understanding is that AMD should be fine even without
> kvm_pmu_disabled, but I may be missing some context here.
> 
> The bottom line is this patch doesn't handle the cases that KVM still
> could disable vPMU support even if enable_pmu is true.

Yes. There are still unwanted PMU MSR writes from QEMU. This just seems odd.

The concern with unwanted MSR writes was initially raised by Maksim Davydov:

https://lore.kernel.org/qemu-devel/a7f9c3c9-09af-4941-b137-2cb83ef8ceb3@yandex-team.ru/

As shown below on the v6.0 KVM hypervisor (AMD), while there are no errors from
QEMU, numerous annoying warnings are generated. (If I recall correctly, this can
also be triggered from the VM itself.)

However, here the logs are not only due to vcpu0, but indeed every vcpu.

[  280.802976] kvm_set_msr_common: 1910 callbacks suppressed
[  280.802981] kvm [18411]: vcpu0, guest rIP: 0xffffffffa4c97844 disabled
perfctr wrmsr: 0xc0010007 data 0xffff
[  295.345747] kvm [18411]: vcpu0, guest rIP: 0xfff0 disabled perfctr wrmsr:
0xc0010004 data 0x0
[  295.355379] kvm [18411]: vcpu0, guest rIP: 0xfff0 disabled perfctr wrmsr:
0xc0010005 data 0x0
[  295.364997] kvm [18411]: vcpu0, guest rIP: 0xfff0 disabled perfctr wrmsr:
0xc0010006 data 0x0
[  295.374618] kvm [18411]: vcpu0, guest rIP: 0xfff0 disabled perfctr wrmsr:
0xc0010007 data 0x0
[  295.385048] kvm [18411]: vcpu1, guest rIP: 0xfff0 disabled perfctr wrmsr:
0xc0010004 data 0x0
[  295.394694] kvm [18411]: vcpu1, guest rIP: 0xfff0 disabled perfctr wrmsr:
0xc0010005 data 0x0
[  295.404317] kvm [18411]: vcpu1, guest rIP: 0xfff0 disabled perfctr wrmsr:
0xc0010006 data 0x0
[  295.413928] kvm [18411]: vcpu1, guest rIP: 0xfff0 disabled perfctr wrmsr:
0xc0010007 data 0x0
[  295.424319] kvm [18411]: vcpu2, guest rIP: 0xfff0 disabled perfctr wrmsr:
0xc0010004 data 0x0
[  295.433963] kvm [18411]: vcpu2, guest rIP: 0xfff0 disabled perfctr wrmsr:
0xc0010005 data 0x0
[  301.966571] kvm_set_msr_common: 1910 callbacks suppressed
[  301.966577] kvm [18411]: vcpu0, guest rIP: 0xffffffff8ac97844 disabled
perfctr wrmsr: 0xc0010007 data 0xffff

> 
> 
>> As you mentioned, another approach would be to use KVM_GET_MSRS to specifically
>> probe for AMD during QEMU initialization. In this case, we can set
>> 'kvm_pmu_disabled' to true if reading the AMD PMU MSR registers fails.
>>
>> To implement this, we may need to:
>>
>> 1. Turn this patch to be AMD specific by probing the AMD PMU registers during
>> initialization. We may need go create a new function in QEMU to use KVM_GET_MSRS
>> for probing only, or we may re-use kvm_arch_get_supported_msr_feature() or
>> kvm_get_one_msr(). I may change in the next version.
>>
>> 2. Limit the usage of 'kvm_pmu_disabled' to be AMD specific in PATCH 5/7.
> 
> I guess this might make things more complicated.
> 
>>>
>>> Additionally, in this scenario — where the user intends to enable a
>>> feature but the host cannot support it — normally no warning is emitted
>>> by QEMU.
>>
>> According to the usage of QEMU, may I assume QEMU already prints warning logs
>> for unsupported features? The below is an example.
>>
>> QEMU 10.2.50 monitor - type 'help' for more information
>> qemu-system-x86_64: warning: host doesn't support requested feature:
>> CPUID[eax=07h,ecx=00h].EBX.hle [bit 4]
>> qemu-system-x86_64: warning: host doesn't support requested feature:
>> CPUID[eax=07h,ecx=00h].EBX.rtm [bit 11]
>>
>>>
>>>> +            }
>>>> +        } else {
>>>> +            /*
>>>> +             * Since Linux v5.18, KVM provides a VM-level capability to easily
>>>> +             * disable PMUs; however, QEMU has been providing PMU property per
>>>> +             * CPU since v1.6. In order to accommodate both, have to configure
>>>> +             * the VM-level capability here.
>>>> +             *
>>>> +             * KVM_PMU_CAP_DISABLE doesn't change the PMU
>>>> +             * behavior on Intel platform because current "pmu" property works
>>>> +             * as expected.
>>>> +             */
>>>> +            if (pmu_cap & KVM_PMU_CAP_DISABLE) {
>>>> +                ret = kvm_vm_enable_cap(kvm_state, KVM_CAP_PMU_CAPABILITY, 0,
>>>> +                                        KVM_PMU_CAP_DISABLE);
>>>> +                if (ret < 0) {
>>>> +                    error_setg_errno(errp, -ret,
>>>> +                                     "Failed to set KVM_PMU_CAP_DISABLE");
>>>> +                    return ret;
>>>> +                }
>>>>              }
>>>>          }
>>>>      }
>>>> @@ -3302,6 +3313,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>>>>      int ret;
>>>>      struct utsname utsname;
>>>>      Error *local_err = NULL;
>>>> +    g_autofree char *kvm_enable_pmu;
>>>>  
>>>>      /*
>>>>       * Initialize confidential guest (SEV/TDX) context, if required
>>>> @@ -3437,6 +3449,21 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>>>>  
>>>>      pmu_cap = kvm_check_extension(s, KVM_CAP_PMU_CAPABILITY);
>>>>  
>>>> +    /*
>>>> +     * The enable_pmu parameter is introduced since Linux v5.17,
>>>> +     * give a chance to provide more information about vPMU
>>>> +     * enablement.
>>>> +     *
>>>> +     * The kvm.enable_pmu's permission is 0444. It does not change
>>>> +     * until a reload of the KVM module.
>>>> +     */
>>>> +    if (g_file_get_contents("/sys/module/kvm/parameters/enable_pmu",
>>>> +                            &kvm_enable_pmu, NULL, NULL)) {
>>>> +        if (*kvm_enable_pmu == 'N') {
>>>> +            kvm_pmu_disabled = true;
>>>
>>> It’s generally better not to rely on KVM’s internal implementation
>>> unless really necessary.
>>>
>>> For example, in the new mediated vPMU framework, even if the KVM module
>>> parameter enable_pmu is set, the per-guest kvm->arch.enable_pmu could
>>> still be cleared.
>>>
>>> In such a case, the logic here might not be correct.
>>
>> Would the Mediated vPMU set KVM_PMU_CAP_DISABLE to clear per-VM enable_pmu even
>> when the global KVM parameter enable_pmu=N is set?
>>
>> In this scenario, we plan to rely on KVM_PMU_CAP_DISABLE only when the value of
>> "/sys/module/kvm/parameters/enable_pmu" is not equal to N.
>>
>> Can I assume that this will work with Mediated vPMU?
>>
>>
>> Is there any possibility to follow the current approach before Mediated vPMU is
>> finalized for mainline, and later introduce an incremental change using
>> KVM_GET_MSRS probing? The current approach is straightforward and can work with
>> existing Linux kernel source code.
> 
> Apologies for the incorrect statement I made earlier regarding mediated
> vPMU.
> 
> According to the mediated vPMU v6, the only behavior specific to
> mediated vPMU is that kvm->arch.enable_pmu may be cleared when
> irqchip_in_kernel() is not true:
> https://urldefense.com/v3/__https://lore.kernel.org/all/20251206001720.468579-17-seanjc@google.com/__;!!ACWV5N9M2RV99hQ!IS8XQG3Zx84utP2QScNlxp-0H5JAgr89lBb1j2oGVJJop3WMyK6X2I5mlerMPA06wkJy8VFd1x6XGEHc6kWn$ 
> 
> However, this does not imply that mediated vPMU requires any special
> handling here. In theory, KVM could clear kvm->arch.enable_pmu in the
> future for other reasons.
> 

While "KVM could clear kvm->arch.enable_pmu in the future," I don't think KVM
may set kvm->arch.enable_pmu if the global enable_pmu is set to 'N'.

Taking Intel VMX EPT as an example, once "/sys/module/kvm_intel/parameters/ept"
is globally disabled, there's no way within KVM software to enable it for any
guest VM **after** 'ept' is set to N.

Similarly, "/sys/module/kvm/parameters/enable_pmu=N" indicates that this KVM
host will not support PMU virtualization in any way. Therefore, there should be
no way to enable vPMU for any guest VM if the global parameter is set to 'N'.
Here we read from ths parameter only during QEMU initialization.

That's why I believe it's reliable to trust the setting when
"/sys/module/kvm/parameters/enable_pmu=N".

In this way, we can avoid many unnecessary MSR writes, especially in cases where
a VM has 300+ vCPUs, even though these may be equivalent to NOPs with
optimizations in more recent KVM versions.

The objective isn't to improve performance. Minimizing the number of unwanted
MSR writes from QEMU reduces the chances of failure (e.g., due to any QEMU
software bug). We can simply avoid those unwanted MSR/NOPs by reading from a KVM
parameter.

From a user's perspective, this just seems odd.
"/sys/module/kvm/parameters/enable_pmu=N" is a reliable setting. If there's a
configuration mismatch between QEMU and KVM, a warning could alert the user.

I can remove this patch, along with the 'kvm_pmu_disabled' variable.

Thank you very much!

Dongli Zhang

