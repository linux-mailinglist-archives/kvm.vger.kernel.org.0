Return-Path: <kvm+bounces-29987-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 866A29B59AC
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 02:56:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DC3E01F2063E
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 01:56:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 174AB1885A4;
	Wed, 30 Oct 2024 01:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BzPfV6sI";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ysXevslw"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D4851799F
	for <kvm@vger.kernel.org>; Wed, 30 Oct 2024 01:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730253384; cv=fail; b=CzS7/73MAh82XnNsAtohacgHpl/6vF1671Y7+0KQeL2YpoqNbNRGWh7Wz9+oqTzb/zFZdbjYf5+gWllAJmdvX+TA7vMwJiWJ3m5JcYijO9pk/M96YaYmhfeZHxE/lEkJOgJaVEKQhGGBSerc1JUBx/atiW9mLz4sXKEZ4rifB7k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730253384; c=relaxed/simple;
	bh=vC05eFKaxrAEcRp880yuF7/7cq2lnKnH4cLKGeLoG00=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=apvl6W7PIv1ALAIOD7eTm1lUG7tUNoOnMUyRFC4f10BxwWB3ar0jl5AcuD+JP5dk3wPjLtB6UJStsTb9F/eQLWOLN6MCeHnjDznpBzaSvlyBKSBAN7kQ07q4rOUtjCnB5HNBG3TSfroPHO6yfewuYVrNfElvaPNdQAlfSL5+g78=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BzPfV6sI; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ysXevslw; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49U1hZLi015134;
	Wed, 30 Oct 2024 01:56:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=SPTZ+j1EW+qy3TgjVevD42SfOmwpi0QzWUZMXtErEm0=; b=
	BzPfV6sIQb58d1putlG76yI4JVuCR7smpX44giCtkKNde7i4MClZ5vDJFKoL9LBe
	1gndhzCUkH2EcTbfaIvtAE88Th/2XeSNNgDstCSVALp0zj4dO+BkWHN6rHFpW3v+
	pdO+0xJDBaYOCpcVUsrsI7LmnY+FZAgOFcRQRzvrNOWCa72f9umpQ31QiX8XXC6z
	dJQdCPz6RzDpaS8/UsbS4FHaQaSSasMyRXfVCHJPYNzX+o21GAVOr0CmfK2ED7aE
	VK0chFf1XHzTn3Emec8oiCyygPaSzbTsLtIakhuCliem7FPBCAGL0zYKYk8KyXIm
	Xp07xAQHeBmSS+s2jhfTwA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42grys6xsy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Oct 2024 01:56:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49U1siQR010235;
	Wed, 30 Oct 2024 01:56:08 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42hn8xpp8t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Oct 2024 01:56:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rB8CbtvPrx8zJ1/kFzKB/A3wAP1PCGLP0jqWOg9mzzE9v0AraRmmcp+hkVa12QHxkDjZdZDL2c/o6o8cp8LZXeD03dZxjgQSf06M6lgu24n3iVFhPTjamzZOO8QKSHRTxQqE24kJdWqfoKQIV+IXsjbhcX+EKi2/JIavgTyYv/upS4mrtx9EmuPvFFf1QY+z+mbzYPhfJoOZ/1nJI/OqzOxDIlKDcCu0ZeB3Sg4l6V+bbSc0mRYaOdXbyb0C1rUCF1yqJ4Zm6ZDpaW+BIc3RUxJVkPPlwh0GDPH9K8HjEKKnkD1kzaq947Ui4272eamJXLA6WWQLwLNaEluo6dpvPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SPTZ+j1EW+qy3TgjVevD42SfOmwpi0QzWUZMXtErEm0=;
 b=fFMMe5K2kb5Y3fvFC0rrk1LzgwacrsvWMR4m06mK+oar/Pfg6LcJQSPdg6jssjZS9c8H66D0cahCGpZ/uQ9gaEbxIeYlO60ixHxkh2CkOgPzUQq8f6Q+Vo9plUPJ3BnHgFaR3H2iiPWnz10IeVMXAYRrD/WXvgc0f7eEDGuYMzQP/io8tmNBA9F5s33KJ71YKGUs+IKAw90nU6vnbcnz4juZ0Vl7XXoKXHcgsHkqZhpB9ULkSmUoU82U9wQ0Sl8Cip/FXb3u/IN5GGv0DouKRjL3RO8XbjgNDZa20k98ZLvUK8UwlPn3W1ODXQI9SGhCP7TJB5t6T8MDTvSAGskedg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SPTZ+j1EW+qy3TgjVevD42SfOmwpi0QzWUZMXtErEm0=;
 b=ysXevslwBiWEif91Jkx90kaNKwDDCZiLIdfpFUivlJ6GF4394NSDGumjAZ5+V2BB/PPItRH4JqUvBDDcf9EdKYuuwCAqoUxE2S//XSSqZuM7A5K8rekJkULfyPo2Tng/gi+7aqyLcNe5eo0HsTJlqZ0dx2MrKAq/WXPnuDMnr3I=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by DS0PR10MB6823.namprd10.prod.outlook.com (2603:10b6:8:11e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.24; Wed, 30 Oct
 2024 01:56:05 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%4]) with mapi id 15.20.8093.027; Wed, 30 Oct 2024
 01:56:05 +0000
Message-ID: <ea82558c-eef1-4af6-bb90-5902f04ce06c@oracle.com>
Date: Wed, 30 Oct 2024 02:56:01 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/4] accel/kvm: Keep track of the HWPoisonPage
 page_size
To: David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: peterx@redhat.com, pbonzini@redhat.com, richard.henderson@linaro.org,
        philmd@linaro.org, peter.maydell@linaro.org, mtosatti@redhat.com,
        joao.m.martins@oracle.com
References: <ZwalK7Dq_cf-EA_0@x1n>
 <20241022213503.1189954-1-william.roche@oracle.com>
 <20241022213503.1189954-3-william.roche@oracle.com>
 <a0fda9e7-d55b-455b-aeaa-27162b6cdc65@redhat.com>
 <9b17600d-4473-4bb6-841f-00f93d86f720@oracle.com>
 <9a49fc5f-bf9e-4e72-bd3e-13975d4913bd@redhat.com>
Content-Language: en-US, fr
From: William Roche <william.roche@oracle.com>
In-Reply-To: <9a49fc5f-bf9e-4e72-bd3e-13975d4913bd@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4P195CA0005.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e2::14) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|DS0PR10MB6823:EE_
X-MS-Office365-Filtering-Correlation-Id: f1e84f91-c187-4cd4-bcd4-08dcf886037c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dmlGYkFlRUo5QjdXYWo1dS9FNTIvZnRMVEtGdHpuLzMveDcvWXRDMmh4YjhZ?=
 =?utf-8?B?Q25qdW1TR0UyTjNSRmQ4bjdvM3pHcFZzMzNhdFFaUWViU0ZRVTlERHd0K2pI?=
 =?utf-8?B?NUpkakJOZW5jUnVDWUdsU2hZd1NPSXc3eHlObFJzZm5TNkwvYW51U1NDVHVn?=
 =?utf-8?B?VkFOWWlHeGl1Vnl3cTJiWDhZNEJBbGZWQVFrSTlkMUFtaDVkMFRJZFZFSmo1?=
 =?utf-8?B?TnJGcURwSitCUk9oZDR4U3g1dlprY0tuODRVM08rRExYOGZZQi91dnQ2Y2lw?=
 =?utf-8?B?RzFYbWJFQlZBYXVVSk92YnVYUFQ1d0NzTER5aXVlNVJtU0tFMVM2L2d6SWM1?=
 =?utf-8?B?amt4Q0lRRlhvQmUvbUNkTytzOThBWWZaR2Q0cUY4bXp3M3JnbUhHMHMrUmRB?=
 =?utf-8?B?ZzBFQ2trbnpKdGppQmpLYS9MZ1dOOGpvV3Y2a3l0V2R0OCtyaW0vVjVaQ0RK?=
 =?utf-8?B?bzBYOWxiKzIxREdFYXI2UmVScDdZbWpTWUFNTVhYaGpINThSSXdKOFVRb3lC?=
 =?utf-8?B?OE4wcG9WZjJqa2N5RExpT3pRWWsrWWFpNkJTVGo1cnBWcXlLRmxOWndqZEd3?=
 =?utf-8?B?QzFtZlNpUjZteG9qSUU2R2NtYmdjaHNJZ3I1WWJUMXFMeWhLV2NYRURtcDRh?=
 =?utf-8?B?T1lRR29RNnNaKzF5d0hTT0NCQXlSMnlrTEw0R3ZFZURqZElzUXNQcXdrdHZt?=
 =?utf-8?B?TWJ6emh6TU53NERVRCsyN0lvRm94QXpuRFhrMllqRGNDQ3FhSDIzVWJBZjA2?=
 =?utf-8?B?TGVMZHBFckNZcUk2b1pHZVB0SFhUTk1PYzdmZjJWaTJiUzE4amFXa2FzczBm?=
 =?utf-8?B?V2g4cTh5K3FBVEEwNlBjMHVOaVJoajE0SmtERjZ2enpxbE4rZ1ZkcnBvVlJP?=
 =?utf-8?B?WmIxSElKaGh2RnhJbUVsY3BKdHY2c3Y1NkFoMlhXMHg0ZU9BbFRqVXJqKzVB?=
 =?utf-8?B?TWRMcTNWMVFxc3dwWEVpQ0puRnZjU3BtZnJ2TDhYRUloNmJZOE5ib0ZhWjJj?=
 =?utf-8?B?TW15WEhTcWpVYjJlUktKb253bzhMMkN4L3ROaDAxVGZOQ3JWN000NkhzYUcr?=
 =?utf-8?B?WHh6Wjh4RVVCVi9Vc3NXaFZwY1pJenZhYm5Jd29EK0RZb2xvNGpqNm0xWUpk?=
 =?utf-8?B?b08wRzdTVXBXTDZHRUt5SERjRmIxUFhtdkoyVnNkamV3Z2kzREd0R016K2N6?=
 =?utf-8?B?VGNqWWI2V2hvOXBtWnR3QXBoUThtRkl1Q0ZOenlQeUM3TlJIT2hld1MzZkNE?=
 =?utf-8?B?OVBRUWJzb25tK3UzRVMvYjUyZFZkMFJYZXFsdVdQT1JkaW03RGErYTRhMmJq?=
 =?utf-8?B?OE52cjBhK1BENk1OZG1keCtqMFAvbkNseXNXMStwaVU3dnJkb2xxcXdvaW9F?=
 =?utf-8?B?L3FtRFJxSmwvY1ExWW94WTFsaXhURThyeXJtQzExdzR6VXgwVkpuM3ZPcTJk?=
 =?utf-8?B?L0pMMnpOZDZ2TnprNUZtTTdJcmlFWk90YTlLbFQ2cWZqOUE1Y0dCVHo4bGRr?=
 =?utf-8?B?ZzZrQ2taV20raEx2L3hrbHpaUzBENTRIeVZOK0ZkQzBUaXlTN0NhTDdNTHNw?=
 =?utf-8?B?TFMrcGMyU21BM3hNY2VKcVVhOWs3dTUzTCsyTi9aUVpUOFpya04zajF1NjZL?=
 =?utf-8?B?T0N6dHNkWStQdmVmYTl0STdFQXM3Y3k4RysyRUdhd29KWUhOcGlnTEVLRW1L?=
 =?utf-8?B?TWZ1L1pIS3YrNlRlVG9RdEVaN21Idy9QU0x2TjAwd3p1c2V4eGNsaGhDVTZB?=
 =?utf-8?Q?3oCsp951umNcZG6uERPFXKLGRDrHLaBLZcHNpT9?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NmRhT2hMTUZ4eUpsaHlrZHgzWTc1WDMwbWdVVXllS0E2M3oydnRHVTd6MnJ3?=
 =?utf-8?B?d2ZKd3hJVm5ibnVMZm9rVmg2NURzZjlqT1ZkNGJ0MWdFNzhpYjdwdHpJZG9C?=
 =?utf-8?B?bnBKQ3pZRXU3KzNUSWdpTWlld09lVTRGVVgwMVB2eFVhSndmMnc3ekgvVnl2?=
 =?utf-8?B?L2lja3BzVU4rcUZkYTNlcVRHV1hLVlNERE5rdU1OSmhUMktqMWY4MEZLZnVr?=
 =?utf-8?B?Y2tBS1RJNit3VkZBU00vdWYrc0thV3lESFZHMmZCdGhjUWFGeGFRM2VwM3ZP?=
 =?utf-8?B?NzBRTUdsR3dvOTRKSWsvcnk4TVJrODUyZGJlNHE3VHlnSmFsM1V3c2ZPUU0z?=
 =?utf-8?B?cTkwcFNSdUZES0tUSzhnd2RzU3AveS91M29iVk96VmdmQmp1dE8rVGpyN2ty?=
 =?utf-8?B?ellHSHcxbXkrdXl1bVBYOUhZNG9ZeGZObkdsVDF4MVBKVGozRE04a3JBeG8r?=
 =?utf-8?B?Q1RGTFFpVlVpSnR5WDZoS0tkcHVBVTlzMVRzKzlGWUNxK2VlZUxxYUdvaDh1?=
 =?utf-8?B?dXFlSi9ENU9oK0x5RWhrTUE5OVVqQWgvSFErbVg4a1VndUlXanJyRUZnTzho?=
 =?utf-8?B?cUUxdXlieFlWY0Vpa0toSnY3UnlXbER6VHU0cVNVeFovcXlnMDNvdmlUSnFW?=
 =?utf-8?B?bkJSdzhDdUN3N0M1NFpnUzFwSisxNFh6RnlEMGFQMmQ4MGJadnJtZzAwN0tx?=
 =?utf-8?B?MDhEUStQRFZUSnhVeUZETGtOM05Jc2EzODJRaVQ0ZElkd1JHZmozRWVTb3Jl?=
 =?utf-8?B?TmdmcFlhYlVpWHlmNS84RjlONnd4dmxBRy9CWEhEdDBNTEZmK0hhdkRJanAv?=
 =?utf-8?B?SGZzWVZVb1NGY2pRcVZ6aXVHbjhvVXJxcFFvM2Y0K28wOVpnajN5aXo3NVN6?=
 =?utf-8?B?WlNFK0RmNkx2MUN2WHg4amVIcEJPLy9Bd1hSTisyZHBlV2ZsdTVxZjBRSVR3?=
 =?utf-8?B?K044MkxNelpvUWptMWdpM0FFZHJXNUFrcStoQnpQejZ3ME5TYllIZ3liUStR?=
 =?utf-8?B?dlBEVVNFTUIwY0FRNFRCZVJ2d1UxWGZXdWVKSmNuSWF3Mm9pRms3bWZaTTJl?=
 =?utf-8?B?SzY5aVdvWDhweXlPbGlVbDRoQlRDMFh4Qk5kbW1LcFJvWUhLZmFta2RaTmF3?=
 =?utf-8?B?a0EvakZwTWFkaGpKSWdxZ0QzWEhYNGxNM2JiS2t2OU5KeHBKOHg2RDIzZDhB?=
 =?utf-8?B?RTQwbzVaWnpONHU5cEVlSmg1dUNodXpyTTJwVEo0TExGaHRzaVhkaytXaEJJ?=
 =?utf-8?B?Vjd4QjRzbXZFZzJLME5MZENvVkw2UnBLV3VkK25HVkQ1aDJoZUd3TE5ralI2?=
 =?utf-8?B?aktIWnV0YUNWeTMyYWUxRU1wR2hhTFBZdkl5c2h4Mit1K3A3aSttbDAxa0Zh?=
 =?utf-8?B?NU1UVk1WRVBJY0IrdU1FMkplenhWUWlYNUdBbHdRakgyeWJUQVYvS3pWYjAw?=
 =?utf-8?B?R3JHb0J1Y3A4emp0bVhGc3Z3eWVhc1lOMTlJNU9iRm91V0Y3cm9yS1VRQmlj?=
 =?utf-8?B?K1Fld1BGZmcxWVJiSWs0STdjR0NmeFZvU2ZPWVJwZDY1MkszaWZIbEJFVU5F?=
 =?utf-8?B?MFAyWE4vbktnYWpZWDdremFCM0ZKMUV6Q3VkYmd3eUZ5UStNcThobStwK2Fs?=
 =?utf-8?B?aW15blRLTElKdmhVVFBxTHRwSVhROHpMbnhBR0ZVVXBaaHM1bjlwbUNXamcy?=
 =?utf-8?B?bEVzTHhYUDlCRDVTU25NbTZBZmtUSW1aTEszOGI2dGszQWIxNGE1amJSYjhv?=
 =?utf-8?B?a2VaSm53MHFsVGxwTGRRVjkySEp4WlJHd2Z2TVRLZ0RkbGVFUUpTcmFFMkRn?=
 =?utf-8?B?cmdCT0dNekpWbTFSMWRXM1EzcVl1OHhMR2tkZUEzeWsydzVYWTJiNXVFdXd5?=
 =?utf-8?B?SVN2RmE2QUFoemFNS3c0aE9uY04yYzNZdk1La3RpUU4vTWJEYjRtR0cxSHps?=
 =?utf-8?B?Q1hLOWhQRVpYb3JsTFBXM3hnL1kyNzBQd0lqcVdwNjFVTUJOWkR5RDEvZEVZ?=
 =?utf-8?B?dytXSkpiRXRxM21pang5QmQwdzB4dFNYay9KYVhlSE5LU0cxdG1sODJmQXpa?=
 =?utf-8?B?MC9saHlibzQ5T2ZaYzdSZUxDSzJlNnFkRHBnTTR6a0l3QVFPL2F4aDNuZnQ5?=
 =?utf-8?B?Z2pPWWNTZnF5K0g0WWlQbnplSWtrc3lPUVJtYXg1TVZ0TWlDQXdjZUdURXF0?=
 =?utf-8?B?YlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	F/AXUIWKB9FyxkIUCP/3C3AuehaTmaIM4GrLhR6w91ymyy1No4Dq2oEz+ERhoS5gYAsbS/gNBM0IcNdxKUIoQoTRIyaSzUOA+aDb/xxxABR7VxYC5DEYg1j/XT6xa+jSbxbF353m00rhAPUxemcPejSoYpdNrQLUvtJ+kvpHk3zug2EF1iPvJj6VgVLjVN1oDt0b15fNOtCULkTCSvA677j4P0Mycj1SKLZuaQAjQGMj+kCT1AQG5q72sIcUF5P/agnYBYYnL5Dk6kCrkEHUTXEI/d6rUQNXDRhMbsPWdFwBMSI1i2BPjMyKbo5ldwVMwB/CZpqebvIeUVMQc7x23hzjimOQIMkE0tjVmB54+lgF8eNYUKblKLZxCS8WCwjvRByf4AR0fGkLWvLyGTe5RkulML+O2IyrLkkx3Oi/8NKjXDgVL5U9ZipvDKOZzqG4YaGDtJ+hUR/FOF1qI0uWF2+WQcVqxwxwBbb9MgiqW1raXzyQJqQ4MZ9cDyvBOmvpzJ/9VhVtTI18jl9t51DbWhglfan6fWrrgcpobwPgIikiFWKlMeUHaAgAqmJsZEWF4OvUyRZFjhY95AMPTUAUxY7IQq9pjvt4CRP3zM382hs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1e84f91-c187-4cd4-bcd4-08dcf886037c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2024 01:56:05.0904
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M5FZL8DRrn4w/S1D3Lu7IZJwQ2YcmMsBIF64QXtFUcqtwqIGhd8sljAIttnDmReWusODMRUAa4dVyzXdFQHBqqx6wVuAWligPnVurUxS19g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6823
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-29_20,2024-10-29_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 phishscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410300014
X-Proofpoint-ORIG-GUID: 84JdrWg-4v1isVyJKmWVm27rGqHKS0cj
X-Proofpoint-GUID: 84JdrWg-4v1isVyJKmWVm27rGqHKS0cj

On 10/28/24 17:42, David Hildenbrand wrote:
> On 26.10.24 01:27, William Roche wrote:
>> On 10/23/24 09:28, David Hildenbrand wrote:
>>
>>> On 22.10.24 23:35, “William Roche wrote:
>>>> From: William Roche <william.roche@oracle.com>
>>>>
>>>> Add the page size information to the hwpoison_page_list elements.
>>>> As the kernel doesn't always report the actual poisoned page size,
>>>> we adjust this size from the backend real page size.
>>>> We take into account the recorded page size to adjust the size
>>>> and location of the memory hole.
>>>>
>>>> Signed-off-by: William Roche <william.roche@oracle.com>
>>>> ---
>>>>   accel/kvm/kvm-all.c       | 14 ++++++++++----
>>>>   include/exec/cpu-common.h |  1 +
>>>>   include/sysemu/kvm.h      |  3 ++-
>>>>   include/sysemu/kvm_int.h  |  3 ++-
>>>>   system/physmem.c          | 20 ++++++++++++++++++++
>>>>   target/arm/kvm.c          |  8 ++++++--
>>>>   target/i386/kvm/kvm.c     |  8 ++++++--
>>>>   7 files changed, 47 insertions(+), 10 deletions(-)
>>>>
>>>> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
>>>> index 2adc4d9c24..40117eefa7 100644
>>>> --- a/accel/kvm/kvm-all.c
>>>> +++ b/accel/kvm/kvm-all.c
>>>> @@ -1266,6 +1266,7 @@ int kvm_vm_check_extension(KVMState *s, 
>>>> unsigned int extension)
>>>>    */
>>>>   typedef struct HWPoisonPage {
>>>>       ram_addr_t ram_addr;
>>>> +    size_t     page_size;
>>>>       QLIST_ENTRY(HWPoisonPage) list;
>>>>   } HWPoisonPage;
>>>>   @@ -1278,15 +1279,18 @@ static void kvm_unpoison_all(void *param)
>>>>         QLIST_FOREACH_SAFE(page, &hwpoison_page_list, list, 
>>>> next_page) {
>>>>           QLIST_REMOVE(page, list);
>>>> -        qemu_ram_remap(page->ram_addr, TARGET_PAGE_SIZE);
>>>> +        qemu_ram_remap(page->ram_addr, page->page_size);
>>>
>>> Can't we just use the page size from the RAMBlock in qemu_ram_remap? 
>>> There we lookup the RAMBlock, and all pages in a RAMBlock have the 
>>> same size.
>>
>>
>> Yes, we could use the page size from the RAMBlock in qemu_ram_remap() 
>> that is called when the VM is resetting. I think that knowing the 
>> information about the size of poisoned chunk of memory when the poison 
>> is created is useful to give a trace of what is going on, before 
>> seeing maybe other pages being reported as poisoned. That's the 4th 
>> patch goal to give an information as soon as we get it.
>> It also helps to filter the new errors reported and only create an 
>> entry in the hwpoison_page_list for new large pages.
>> Now we could delay the page size retrieval until we are resetting and 
>> present the information (post mortem). I do think that having the 
>> information earlier is better in this case.
> 
> If it is not required for this patch, then please move the other stuff 
> to patch #4.
> 
> Here, we really only have to discard a large page, which we can derive 
> from the QEMU RAMBlock page size.


Ok, I can remove the first patch that is created to track the kernel 
provided page size and pass it to the kvm_hwpoison_page_add() function, 
but we could deal with the page size at the kvm_hwpoison_page_add() 
function level as we don't rely on the kernel provided info, but just 
the RAMBlock page size.

I'll send a new version with this modification.


>>
>>
>>>
>>> I'll note that qemu_ram_remap() is rather stupid and optimized only 
>>> for private memory (not shmem etc).
>>>
>>> mmap(MAP_FIXED|MAP_SHARED, fd) will give you the same poisoned page 
>>> from the pagecache; you'd have to punch a hole instead.
>>>
>>> It might be better to use ram_block_discard_range() in the long run. 
>>> Memory preallocation + page pinning is tricky, but we could simply 
>>> bail out in these cases (preallocation failing, ram discard being 
>>> disabled).
>>
>>
>> I see that ram_block_discard_range() adds more control before 
>> discarding the RAM region and can also call madvise() in addition to 
>> the fallocate punch hole for standard sized memory pages. Now as the 
>> range is supposed to be recreated, I'm not convinced that these 
>> madvise calls are necessary.
> 
> They are the proper replacement for the mmap(MAP_FIXED) + fallocate.
> 
> That function handles all cases of properly discarding guest RAM.

In the case of hugetlbfs pages, ram_block_discard_range() does the 
punch-hole fallocate call (and prints out the warning messages).
The madvise call is only done when (rb->page_size == 
qemu_real_host_page_size()) which isn't true for hugetlbfs.
So need_madvise is false and neither QEMU_MADV_REMOVE nor 
QEMU_MADV_DONTNEED madvise calls is performed.


> 
>>
>> But we can also notice that this function will report the following 
>> warning in all cases of not shared file backends:
>> "ram_block_discard_range: Discarding RAM in private file mappings is 
>> possibly dangerous, because it will modify the underlying file and 
>> will affect other users of the file"
> 
> Yes, because it's a clear warning sign that something weird is 
> happening. You might be throwing away data that some other process might 
> be relying on.
> 
> How are you making QEMU consume hugetlbs?

A classical way to consume (not shared) hugetlbfs pages is done with the 
creation of a file that is opened, mmapped by the Qemu instance but we 
also delete the file system entry so that if the Qemu instance dies, the 
resources are released. This file is usually not shared.


> 
> We could suppress these warnings, but let's first see how you are able 
> to trigger it.

The warning is always displayed when such a hugetlbfs VM impacted by a 
memory error is rebooted.
I understand the reason why we have this message, but in the case of 
hugetlbfs classical use this (new) message on reboot is probably too 
worrying...  But loosing memory is already very worrying ;)


> 
>> Which means that hugetlbfs configurations do see this new cryptic 
>> warning message on reboot if it is impacted by a memory poisoning.
>> So I would prefer to leave the fallocate call in the qemu_ram_remap() 
>> function. Or would you prefer to enhance ram_block_discard_range()code 
>> to avoid the message in a reset situation (when called from 
>> qemu_ram_remap)?
> 
> Please try reusing the mechanism to discard guest RAM instead of open- 
> coding this. We still have to use mmap(MAP_FIXED) as a backup, but 
> otherwise this function should mostly do+check what you need.
> 
> (-warnings we might want to report differently / suppress)
> 
> If you want, I can start a quick prototype of what it could look like 
> when using ram_block_discard_range() + ram_block_discard_is_disabled() + 
> fallback to existing mmap(MAP_FIXED).

I just want to notice that the reason why need_madvise was used was 
because "DONTNEED fails for hugepages but fallocate works on hugepages 
and shmem". In fact, MADV_REMOVE support on hugetlbfs only appeared in 
kernel v4.3 and MADV_DONTNEED support only appeared 5.18

Our Qemu code avoids calling these madvise for hugepages, as we need to 
have:
(rb->page_size == qemu_real_host_page_size())

That's a reason why we have to remap the "hole-punched" section of the 
file when using hugepages.

>>
>>
>>>
>>> qemu_ram_remap() might be problematic with page pinning (vfio) as is 
>>> in any way :(
>>
>> I agree. If qemu_ram_remap() fails, Qemu is ended either abort() or 
>> exit(1). Do you say that memory pinning could be detected by 
>> ram_block_discard_range() or maybe mmap call for the impacted region 
>> and make one of them fail ? This would be an additional reason to call 
>> ram_block_discard_range() from qemu_ram_remap().   Is it what you are 
>> suggesting ?
> 
> ram_block_discard_is_disabled() might be the right test. If discarding 
> is disabled, then rebooting might create an inconsistency with 
> e.g.,vfio, resulting in the issues we know from memory ballooning where 
> the state vfio sees will be different from the state the guest kernel 
> sees. It's tricky ... and we much rather quit the VM early instead of 
> corrupting data later :/


Alright. we can verify if ram_block_discard_is_disabled() is true and we 
exit Qemu in this case with a message instead of trying to recreate the 
memory area (in the other case).



