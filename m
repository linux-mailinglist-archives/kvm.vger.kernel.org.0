Return-Path: <kvm+bounces-37667-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D0219A2E05A
	for <lists+kvm@lfdr.de>; Sun,  9 Feb 2025 21:13:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0C2F57A2A67
	for <lists+kvm@lfdr.de>; Sun,  9 Feb 2025 20:12:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45CE71E283C;
	Sun,  9 Feb 2025 20:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Oa9xc5mo";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="YasoG/9n"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419DD4C79
	for <kvm@vger.kernel.org>; Sun,  9 Feb 2025 20:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739131976; cv=fail; b=rqTrZAMlygWjjHCehMyKckI3NlNU/sven4p3qW0Cd/NnKS26dIGuBcrfiqxRyXSNthMcPHfiBTOYpBl4gw7PeGqvjvS2PYqe4zqY26aVRS0rnsTK/ZgBOBylRKqHuapWygU2DiaQt3O9CDmgfyNcxtL65YHAZNm5Cp9VRTfV8V4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739131976; c=relaxed/simple;
	bh=brqJN0rAprBxN3lmXh7L0AxLUF+2LEi+4ITirXNVpAY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZiImjOU04pfTN7EOaiUxNf5p748hax5AH5aTBzl/vpii6wwtJrNQ+caEi5AmtbaIlZB/Y53wRju3EKTy5cZBmxSdz2FjcJx7oiB89yFiem8tl8G552M24qFtSEwRXJrqydCxwo8XBla0K2EcOxPIMaXmu3GvosBNkiz3OewFLvo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Oa9xc5mo; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=YasoG/9n; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 519FDISm022310;
	Sun, 9 Feb 2025 20:12:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=KvDlOQFk58/Kqx6ti9V1jEyYlMT61/bMX72KmAPWv84=; b=
	Oa9xc5mo6dx4HrhnLImDBRJqPp+cLpwmdTmAWWWLOWcLu3I68KrjSPPY8i2g4rTb
	7zgUS0A2ECiwgzMekQW6D9E1EAhChWGG5pNwGIYnETsxFVBgRzdTnUdTirJA6dyd
	/BW0bUMXUzGU5VxVKs5Ur71KOd4GIvuH7QLLQUqPBEvnT5vpNmLyuhh5sGVGoduO
	u965g4gVf64aGzpV8CSJXBoikF34rn4atI2d+ajBohTVNjy/72JsFaeD4j4xD2jh
	8DDb8OkMZx7SEsM6no7EU3VwC9vBt0bNfaBaYKjiLmHQ/TpBiKUDDp617VfmHaDS
	T+5kaYMsz66pHWEtpyMW8A==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44p0q29vcq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 09 Feb 2025 20:12:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 519IOQiF030586;
	Sun, 9 Feb 2025 20:12:19 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2048.outbound.protection.outlook.com [104.47.58.48])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44p62w4uj0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 09 Feb 2025 20:12:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c0Xg6Sgjsmy9turbo39SaW+JvxBuoHHp+mQXibcz2EETtsD3cUYCXpxLXrGecsix1QTdttYUYSza1xAvOMExGY9PnOHd4lP95+oAjc8swv2Layi9/5QvBLDEz4JMX+nAw4zjA7f/sZ1nB9jm9E1ch6epTocP7CkDnFNpXUcXm+MMYkXoyRtiYbZpjC2PjDo8S4rlpapeWK3NmT/LfUSc4nl4IPUIaQDj+x/EtCYOyiPxP3z1qYRyIj8stKPBgAu0mS5+XLyMgIsFY3YCF4NHwt8n9IISeBG9nGO+i3DqBaj+4K5Vd6EroU5DE7nLsGl9aIcdlL1stLiWTCPIpT1+7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KvDlOQFk58/Kqx6ti9V1jEyYlMT61/bMX72KmAPWv84=;
 b=Ybvjmxp0ru2OHEzAJ2teBlHpvjcfCk2B4xV+XcS3FVOx72iyPp8jQ+YZEgDGyUxo9RhGVaDsMedjHpZHwDIFy6Bc6Vw4fWTxRLN7Wuv2jQxkFaBwmYbSKPGlRNrKJ6eIPfeNmTodPTVxb5k7BHDbxtsQ5boU7y/t+hm5v4GKpAytdyEla7wxVTrgUwbEGNU6zV5jxzT4aYQjiYJwRjL9nMqOT4sLM+xR5XyW9bE9Jt5JyxE3Hro9gG43IOdYC0MqoCkG3H3CQWPEGjTxGXpyVFRFCy/7HieeHmMfFjvC+FvpuadDOhdz1dFaofDA/r5ysVjMJABKifjnsFpB0Yi74Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KvDlOQFk58/Kqx6ti9V1jEyYlMT61/bMX72KmAPWv84=;
 b=YasoG/9nG229eKCgFIsTJbAj3bPpp4u82Gmb7BKopusxnPybsJfjbjCP41uUoOE9c+B0pIJN/IPm6MLn9J0192a6N6YDnpyHFYhZyuAmpy+L7Y1rWajMEZOIwBCp8CHrYuC6BeewZdhpxGStgOoj46Nb3WUpVCYmyaRFaVYOkcM=
Received: from BN6PR1001MB2068.namprd10.prod.outlook.com
 (2603:10b6:405:2b::35) by BLAPR10MB5105.namprd10.prod.outlook.com
 (2603:10b6:208:325::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.17; Sun, 9 Feb
 2025 20:12:16 +0000
Received: from BN6PR1001MB2068.namprd10.prod.outlook.com
 ([fe80::c9b4:7351:3a7d:942f]) by BN6PR1001MB2068.namprd10.prod.outlook.com
 ([fe80::c9b4:7351:3a7d:942f%4]) with mapi id 15.20.8422.012; Sun, 9 Feb 2025
 20:12:14 +0000
Message-ID: <bf41c97a-b5e2-4cfd-90ef-89f12f1b384a@oracle.com>
Date: Sun, 9 Feb 2025 12:12:10 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] target/i386/kvm: introduce 'pmu-cap-disabled' to set
 KVM_PMU_CAP_DISABLE
To: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>, Zhao Liu <zhao1.liu@intel.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, pbonzini@redhat.com,
        mtosatti@redhat.com, sandipan.das@amd.com, babu.moger@amd.com,
        likexu@tencent.com, like.xu.linux@gmail.com, zhenyuw@linux.intel.com,
        groug@kaod.org, lyan@digitalocean.com, khorenko@virtuozzo.com,
        alexander.ivanov@virtuozzo.com, den@virtuozzo.com, joe.jin@oracle.com,
        davydov-max@yandex-team.ru, zide.chen@intel.com
References: <20241104094119.4131-1-dongli.zhang@oracle.com>
 <20241104094119.4131-3-dongli.zhang@oracle.com> <ZyxxygVaufOntpZJ@intel.com>
 <57b4b74d-67d2-4fcf-aa59-c788afc93619@oracle.com>
 <f4a2f801-9f82-424e-aee4-8b18add34aa6@linux.intel.com>
 <6aefa9df-10e3-4001-a509-a4bc3850d65a@linux.intel.com>
Content-Language: en-US
From: dongli.zhang@oracle.com
In-Reply-To: <6aefa9df-10e3-4001-a509-a4bc3850d65a@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR01CA0015.prod.exchangelabs.com (2603:10b6:a02:80::28)
 To BN6PR1001MB2068.namprd10.prod.outlook.com (2603:10b6:405:2b::35)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN6PR1001MB2068:EE_|BLAPR10MB5105:EE_
X-MS-Office365-Filtering-Correlation-Id: 305a385f-5a66-4f72-fa9b-08dd49460b02
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MXZNbXJtRVNXY0tMRVlvamJyYkwvUGpIVDZJdHJCdmtZZ1hSc3VKekYyTjNC?=
 =?utf-8?B?WWZianArLzJiNGRNQnNCSnBMNmZnZDliR0JzcExIbXdYcE5HWnE0RWxscE9Q?=
 =?utf-8?B?SU9QZTc0RFRFZmFNTEpwTExaSzV2cmZsZGx6YlNJU2psc0RmWTZlQi9pOVRs?=
 =?utf-8?B?UDNwSDBndmtWcDlvQmR6TTFrblcrVTU5R1JMUHZXQWx3R0tQck1ZWnhVNFlS?=
 =?utf-8?B?Tkx5ekxwbzNLK28vb2M3MG9RdTE1MVRvSzRkQzFkaW8zczRzVG5wdkxEQ1hV?=
 =?utf-8?B?MTFYMStyYjFtQ1FBd2ZzNU11OFNSd1daQUMzOTZjeFVhdVFqRUkxRXNHUVF4?=
 =?utf-8?B?bVgxNDd4bEhEMEVVaXZQY3N2R0J6ckZuSTV5d0VTTDRyMEVEbURxR1BiMDFZ?=
 =?utf-8?B?eFE1VGxSUjBlMnJ1QXIxbk83ZXcydDJJck9pU2pUb0JaUzl5TjFFNDNFSisw?=
 =?utf-8?B?dWVzSnF5Yy9SQWE0NzlTbWF4alBSSkFPakM5eHRVeURoWXlTMGhmcU9Fd0Rq?=
 =?utf-8?B?bDd3bGlUYStDVzAxT0RPQ1NqOE9GdVN5OVBXZ2xSKzNRNGZxVW1rK1BSSTJ1?=
 =?utf-8?B?RU9BajZTM2ljZGc5K3lCaE5BMzZqNjM2UVZVY3lBbmJ0VjJYbEo3WjArcloz?=
 =?utf-8?B?Tkp5UXJyb1VvZ2xEN0J4M21aNEMxRjJuY2VLOUJGamR5OGE5OXBMTXNYMTh0?=
 =?utf-8?B?QVgyb3JvNjIxVlcwQ016ZWZkT3pDMjV1YXlTNkx6NzQ3aTNpa2tJSkxDR01J?=
 =?utf-8?B?RkhOdWlNaHgvTDd0amJJNlFPY3hKVFd0OW1hQVdYdU1IcFREUXlJS1VSKzlq?=
 =?utf-8?B?Nzd6Qzg1WkZON3NzS2FzUHc3YnVhTTU5UkU5MTFpR3B1STM4TmxGWXVoOGJ6?=
 =?utf-8?B?eDRkZldyVDJkdUp5bVRYNTF2SDNqc25nU1FxZ25KV3dieFZCUERaeU1WajBL?=
 =?utf-8?B?MUNnSC9YMzhrbzRQNXJLSkJkdlkyVWJHYm1wc2E1bmtOeTQxUHdJZjhKWEl4?=
 =?utf-8?B?Mk9ZMCtUNmxIRGRQNDBVV1hWQjZBQjd1YVRkSGx4TEdiUllrQUhTQUc0M3Vt?=
 =?utf-8?B?ZWVwQ1hNQXhTZVA3SFZqdDhLVGhNdDVFaFJ6U3pNNTNvd0FVa3ZhME9ZcTM0?=
 =?utf-8?B?V0xPVEZBNmtwczdrZUh0UGRWS2NQbjNnZk1XKzN1L0xZa0dGQ08yNWFzWXUz?=
 =?utf-8?B?ekh1V2dONUFqNzBMTFh0cHB5bUppaEJTV0I4aFVuME1IWW5HVTNlaWxNZ3pS?=
 =?utf-8?B?Y3h4ZFY1RDRtdXhKOC9KeVZoQzNYY2R4dDJVZUxRK3BTamxIcEZCTFpoUWwx?=
 =?utf-8?B?cVA3MXJPVGxzRkpwbmpDMkF1U1hBcHFYc0N6OXZneHk5dEpsOEZSaFJURTJZ?=
 =?utf-8?B?OVRiT0Q2MG1RaDByOERCM0c3NThjUEZCd3pLOFpBRWlESWo4c3R2b2t5NlJQ?=
 =?utf-8?B?eEVTRUtMTFdyRVdjQlB5dWlsYlJZWlRJZzlhaXRZenlLK0dhampiWWxTSm8y?=
 =?utf-8?B?ZWM0VEJrOHRGRHhqemNyNysyWjJQN2loNlRVdTMyNjMxZy9mblhjUlhUN1RV?=
 =?utf-8?B?WUljSGUxbkdMR2VXV0FnaVd0Wlg4blJ3STZsdzN4WXluSFZvZlFiZE16bkxC?=
 =?utf-8?B?WXhFVHl1TlR2TkRUYjF2VUJSUXJ5VkVKaGlFRFNtM0N5VUQvcExlNDlzV1ph?=
 =?utf-8?B?TzVOVkZXZU5pcVoxNzdKdnBaWWFWM04zekRWZ1hITzJCS1FNUkVtYlVIVENU?=
 =?utf-8?B?b3UvKzFoRkVSTTQ3ajZjMVc1cWM2RjNrOStFcmVOVkpZTjJ2QXFJU0hvUnM0?=
 =?utf-8?B?TFlBUmJWa1dlaW0wUlYyMm9mV2gvTmJTeUJGMnZYcHhEUGdxUE11blRGRFNJ?=
 =?utf-8?B?TmlqeFJ2QURVc1FHdXA4QUZWcEVlanpDb09Ib0x1S1Qxb2c9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1001MB2068.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZzNORElKTWZvckdyOGhtRW9kZTdHdGMwam93RVFZZUd6NlZLZDBUU21Kem5Q?=
 =?utf-8?B?TU82MHNpamJkUGxOeHVaS1hlYldQVmpiakFGQktJOHRpS1ZwU0JhS2ZyV0RW?=
 =?utf-8?B?a2piT1AvclhBUG5YMlF1cGlJbzlnK3VidThOdERHVlM0UHJtbHdmQnlLN0lJ?=
 =?utf-8?B?UzBjeEF5NVBCUFozMVhicmQwQWJPb0RkRlVNZm5CZGJUZWIyVjFKWjNmWmNN?=
 =?utf-8?B?MmRsenRNcXpER1pHa1MvSGNVaGZjMXRsQWk4aXFRT0VDRSswamVWNS8wTkFW?=
 =?utf-8?B?QnlVWHBaZ1lCaGlzbFJxbG8vSVJ4Nm90Z200U2gwczVGV0l1QVBGSHZCT2RE?=
 =?utf-8?B?VVhpZHUvRzFneFZWNGtMSlRTWG1CclhrYUl6VTlTWlNIOW1qby9rYjF0UlRO?=
 =?utf-8?B?WSs0dEFBUEdud2JoK3lEWXZ1bFBVUUpnR0lTTGVOTzlZaVJmc21JK2ZqQ3VD?=
 =?utf-8?B?aitzdlZ5Vk5VT2JaWGQvT0g2UTZudEJQT3NyNXN6S0RaaVozZW42Rmk2TUJx?=
 =?utf-8?B?ZHB5blJsRTZSSlFSSElJcTE0VmYvZWF0a2Y1V2p2bkZnNWxUbDFkTEtwQklX?=
 =?utf-8?B?aVFrak5rSGs3NXBzSEpzeXFmMy9XRE81WHpncytMM1p2Y0tBcllJVk9tZGZm?=
 =?utf-8?B?V1A3N2VCMmhOTHNOVlBkeGpTc3FlL0xuN3V4SktFKzdGNXdjb1ZNN1lkay8w?=
 =?utf-8?B?ZHVxbjd2anp6ZFl4REROKzlMVDJlcEhLbGR2RHhteElOM2I3U1N0dkt6TkZk?=
 =?utf-8?B?djBWV2d5UWI4Vk5nWVFlV3BHTmZ4UjYwVXBsLzVrMkRDN2tKcUZ2ZnpFbGt4?=
 =?utf-8?B?TFA2Zy92V2VJMnd3SjEvc0tmQk80dmo1VWJhVGlKMEV0ZHBIa3hjNDl1UFJk?=
 =?utf-8?B?SHFSRDNjRThwWUdLZ3pxUjYvSTk4RkgvZFpaakEyNXJTeTFYaXFWbEdKSEx4?=
 =?utf-8?B?UFg1VDhwclprcVdaTEV6anR3U01jdFNFaVFidWNaNEFHSHQ2YnFDcnRabWF2?=
 =?utf-8?B?bndXdXMvVkx1SkFmcENKMzJXVkhDSGozeE5HaGg0eGJMc3FXQVZVVTdMS1F5?=
 =?utf-8?B?ZExlcGhOYzNRdXhyWWhGTHc0bFQ0d3BGSytnVEkvV3RQWFpINU9sNUsyM1VL?=
 =?utf-8?B?eHZqcXRick5BZW5CajRuOUhEeUU4THRnc21yZ0M4bWlLbWJMQkt6RVhadEJ5?=
 =?utf-8?B?ZmdxdlZKczBJOWJLdGxONEVKeFhFQ1Rka0NUS280dUVnTzhMc0diREZzR05D?=
 =?utf-8?B?NWk5bCtrV1BPMyt5NWtRL1g4VitpVElUbUVJT2NCV2N1VnBYWTNleUlqZWFo?=
 =?utf-8?B?UGx2NkF0cmNPV2JabXA2Q1pDWmVTZDhjYzV6Qkd2YmZ2ZE9LRWhseDhkS1dZ?=
 =?utf-8?B?QlpzZkxvS1FrYk1abVI3RXdpK0tCWVhPQ0QyeFdjQ0JCdGRlYlhOd0ZGZ3d3?=
 =?utf-8?B?blJyVFdrUmhzYWNiQjFtZ053T3BQdjlLSVFRN2J4bjFlTVhyNlorcHMzVDll?=
 =?utf-8?B?Z0RVNU5ONGpQRktCaW9Mams3ZVErY0VvWGk1TG4vUjVmVlpMbTE5cnJOR1ox?=
 =?utf-8?B?TzdWSjRwNlNORDB1bmhCMlBoc1l0MlFFa1FkY0lZZ0NsR2NxalFNc3Fjbm9Y?=
 =?utf-8?B?RXhlMUhCNEozNU5VTkNHMEJreUc1MDEvMmpOSFJBQ004b2RDT3l1ZkRQalJ0?=
 =?utf-8?B?OTkyckR2SkFlSjIrdm1uRWtKN2hQVWpIb3VpYktkVUxNQ2JDWDE1RmJLTll2?=
 =?utf-8?B?Y0dJcVNVd0k2aStLU0E5WjA1VEFFQjJtdVRQOXN6OXFsWkRDbU9SYjAvdGRx?=
 =?utf-8?B?MG5hbHZHc2duWnlOUCs2SlhmR1NFcjN0eHhrTTUvaVk1QTBIN0tycTMvbU14?=
 =?utf-8?B?dmd3NGpPMFVTZDZHZ0J3amsrajVESVUwUmE0TGVvUEo0aEszU0dlYU9KMnFk?=
 =?utf-8?B?cWJhZmNzSG9JZk5KMWZ0QlVpTE8vNGM1YUN1RTNKYlRyWEdIam9mZUQ0R3BK?=
 =?utf-8?B?K2wreUVhZjFobUZNVHpjdUt2V3AxOC91NEtCQTVrYkh4aGtkYnVVQXlsenh3?=
 =?utf-8?B?NFVYK3ZObVNYWlJkVzVxWktWMXNwNlFFYWZWR25rZWpCOW5WWW1WTXJMS2hS?=
 =?utf-8?Q?tJhhlx0ehn+ibWNxfQeltnc0J?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HQ3dwriZEVVh7zDQlGj2PdmFwIEixMWzfBnbLUIJMppQhJmG8To6XBQ28TPr3sM5+55eOq/h/FzMhSSxLs/NZp1A2WV0amfvzdqFOTL9UZi3BBBdxZj8pW9szaTvJ8g7BQJ+IgE4rFS+H9W3wRvKct0TIGwCPC+E4NemOuql2AqZF39zp+heCzGbGGKx+HRQtF52s6nv8ZH2bUbednr7Cnzhibrxjvssb1ubxxjN5/FBKR9boFFPIg3Ch734CGhfzaPB/rg6/ASj4MblKBZFqeAqsSFgpAmJphZiKGF8D3UZUi6xJec6jxuKTln7+EtqX+eQVld47nhjpat2wScwPal+EEQSobcXcsz+fgGeFEv9633HctAVQ7KW7cfbfQZKlnMOObO2BmkTBbS//0kCLvS0rAKD/Me5p5AkwX83eVkR36opU5bfrXTj5TuJ4oKpz06n17Ogu1yg4IB+Ib2Y+F+BeNhbNuPV3fNj0NWNB2rMOIMOZTgNadrqI3yDeVgDxxaWPSFnKZhIfgh6LgAnMfS9GPC778OrNfOKsF1f16cmKjeL8EEdJ73eAmiYAmf2xY6mre/OOq40sr5rgataIKdAdBa3Mqk4dzNRtuDkbCs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 305a385f-5a66-4f72-fa9b-08dd49460b02
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1001MB2068.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2025 20:12:14.0079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GqimMWrvhn2R9llfBe1uPq84oHmlz5fjjTrQiL9HPWe5AkkBF/jIHQhqZXDdOVHhUJgWLqlVckmbUAD8gPIhBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5105
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-09_09,2025-02-07_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 phishscore=0 spamscore=0 adultscore=0 suspectscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2501170000 definitions=main-2502090179
X-Proofpoint-GUID: xYI5RVTGLV7ygmG7vZ7TWxQKUY7cdPYN
X-Proofpoint-ORIG-GUID: xYI5RVTGLV7ygmG7vZ7TWxQKUY7cdPYN

Hi Dapeng,

On 2/7/25 1:52 AM, Mi, Dapeng wrote:
> 
> On 11/21/2024 6:06 PM, Mi, Dapeng wrote:
>> On 11/8/2024 7:44 AM, dongli.zhang@oracle.com wrote:
>>> Hi Zhao,
>>>
>>>
>>> On 11/6/24 11:52 PM, Zhao Liu wrote:
>>>> (+Dapang & Zide)
>>>>
>>>> Hi Dongli,
>>>>
>>>> On Mon, Nov 04, 2024 at 01:40:17AM -0800, Dongli Zhang wrote:
>>>>> Date: Mon,  4 Nov 2024 01:40:17 -0800
>>>>> From: Dongli Zhang <dongli.zhang@oracle.com>
>>>>> Subject: [PATCH 2/7] target/i386/kvm: introduce 'pmu-cap-disabled' to set
>>>>>  KVM_PMU_CAP_DISABLE
>>>>> X-Mailer: git-send-email 2.43.5
>>>>>
>>>>> The AMD PMU virtualization is not disabled when configuring
>>>>> "-cpu host,-pmu" in the QEMU command line on an AMD server. Neither
>>>>> "-cpu host,-pmu" nor "-cpu EPYC" effectively disables AMD PMU
>>>>> virtualization in such an environment.
>>>>>
>>>>> As a result, VM logs typically show:
>>>>>
>>>>> [    0.510611] Performance Events: Fam17h+ core perfctr, AMD PMU driver.
>>>>>
>>>>> whereas the expected logs should be:
>>>>>
>>>>> [    0.596381] Performance Events: PMU not available due to virtualization, using software events only.
>>>>> [    0.600972] NMI watchdog: Perf NMI watchdog permanently disabled
>>>>>
>>>>> This discrepancy occurs because AMD PMU does not use CPUID to determine
>>>>> whether PMU virtualization is supported.
>>>> Intel platform doesn't have this issue since Linux kernel fails to check
>>>> the CPU family & model when "-cpu *,-pmu" option clears PMU version.
>>>>
>>>> The difference between Intel and AMD platforms, however, is that it seems
>>>> Intel hardly ever reaches the “...due virtualization” message, but
>>>> instead reports an error because it recognizes a mismatched family/model.
>>>>
>>>> This may be a drawback of the PMU driver's print message, but the result
>>>> is the same, it prevents the PMU driver from enabling.
>>>>
>>>> So, please mention that KVM_PMU_CAP_DISABLE doesn't change the PMU
>>>> behavior on Intel platform because current "pmu" property works as
>>>> expected.
>>> Sure. I will mention this in v2.
>>>
>>>>> To address this, we introduce a new property, 'pmu-cap-disabled', for KVM
>>>>> acceleration. This property sets KVM_PMU_CAP_DISABLE if
>>>>> KVM_CAP_PMU_CAPABILITY is supported. Note that this feature currently
>>>>> supports only x86 hosts, as KVM_CAP_PMU_CAPABILITY is used exclusively for
>>>>> x86 systems.
>>>>>
>>>>> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
>>>>> ---
>>>>> Another previous solution to re-use '-cpu host,-pmu':
>>>>> https://urldefense.com/v3/__https://lore.kernel.org/all/20221119122901.2469-1-dongli.zhang@oracle.com/__;!!ACWV5N9M2RV99hQ!Nm8Db-mwBoMIwKkRqzC9kgNi5uZ7SCIf43zUBn92Ar_NEbLXq-ZkrDDvpvDQ4cnS2i4VyKAp6CRVE12bRkMF$ 
>>>> IMO, I prefer the previous version. This VM-level KVM property is
>>>> difficult to integrate with the existing CPU properties. Pls refer later
>>>> comments for reasons.
>>>>
>>>>>  accel/kvm/kvm-all.c        |  1 +
>>>>>  include/sysemu/kvm_int.h   |  1 +
>>>>>  qemu-options.hx            |  9 ++++++-
>>>>>  target/i386/cpu.c          |  2 +-
>>>>>  target/i386/kvm/kvm.c      | 52 ++++++++++++++++++++++++++++++++++++++
>>>>>  target/i386/kvm/kvm_i386.h |  2 ++
>>>>>  6 files changed, 65 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
>>>>> index 801cff16a5..8b5ba45cf7 100644
>>>>> --- a/accel/kvm/kvm-all.c
>>>>> +++ b/accel/kvm/kvm-all.c
>>>>> @@ -3933,6 +3933,7 @@ static void kvm_accel_instance_init(Object *obj)
>>>>>      s->xen_evtchn_max_pirq = 256;
>>>>>      s->device = NULL;
>>>>>      s->msr_energy.enable = false;
>>>>> +    s->pmu_cap_disabled = false;
>>>>>  }
>>>> The CPU property "pmu" also defaults to "false"...but:
>>>>
>>>>  * max CPU would override this and try to enable PMU by default in
>>>>    max_x86_cpu_initfn().
>>>>
>>>>  * Other named CPU models keep the default setting to avoid affecting
>>>>    the migration.
>>>>
>>>> The pmu_cap_disabled and “pmu” property look unbound and unassociated,
>>>> so this can cause the conflict when they are not synchronized. For
>>>> example,
>>>>
>>>> -cpu host -accel kvm,pmu-cap-disabled=on
>>>>
>>>> The above options will fail to launch a VM (on Intel platform).
>>>>
>>>> Ideally, the “pmu” property and pmu-cap-disabled should be bound to each
>>>> other and be consistent. But it's not easy because:
>>>>  - There is no proper way to have pmu_cap_disabled set different default
>>>>    values (e.g., "false" for max CPU and "true" for named CPU models)
>>>>    based on different CPU models.
>>>>  - And, no proper place to check the consistency of pmu_cap_disabled and
>>>>    enable_pmu.
>>>>
>>>> Therefore, I prefer your previous approach, to reuse current CPU "pmu"
>>>> property.
>>> Thank you very much for the suggestion and reasons.
>>>
>>> I am going to follow your suggestion to switch back to the previous solution in v2.
>> +1.
>>
>>  I also prefer to leverage current exist "+/-pmu" option instead of adding
>> a new option. More options, more complexity. When they are not
>> inconsistent, which has higher priority? all these are issues.
>>
>> Although KVM_CAP_PMU_CAPABILITY is a VM-level PMU capability, but all CPUs
>> in a same VM should always share same PMU configuration (Don't consider
>> hybrid platforms which have many issues need to be handled specifically).
>>
>>
>>>> Further, considering that this is currently the only case that needs to
>>>> to set the VM level's capability in the CPU context, there is no need to
>>>> introduce a new kvm interface (in your previous patch), which can instead
>>>> be set in kvm_cpu_realizefn(), like:
>>>>
>>>>
>>>> diff --git a/target/i386/kvm/kvm-cpu.c b/target/i386/kvm/kvm-cpu.c
>>>> index 99d1941cf51c..05e9c9a1a0cf 100644
>>>> --- a/target/i386/kvm/kvm-cpu.c
>>>> +++ b/target/i386/kvm/kvm-cpu.c
>>>> @@ -42,6 +42,8 @@ static bool kvm_cpu_realizefn(CPUState *cs, Error **errp)
>>>>  {
>>>>      X86CPU *cpu = X86_CPU(cs);
>>>>      CPUX86State *env = &cpu->env;
>>>> +    KVMState *s = kvm_state;
>>>> +    static bool first = true;
>>>>      bool ret;
>>>>
>>>>      /*
>>>> @@ -63,6 +65,29 @@ static bool kvm_cpu_realizefn(CPUState *cs, Error **errp)
>>>>       *   check/update ucode_rev, phys_bits, guest_phys_bits, mwait
>>>>       *   cpu_common_realizefn() (via xcc->parent_realize)
>>>>       */
>>>> +
>>>> +    if (first) {
>>>> +        first = false;
>>>> +
>>>> +        /*
>>>> +         * Since Linux v5.18, KVM provides a VM-level capability to easily
>>>> +         * disable PMUs; however, QEMU has been providing PMU property per
>>>> +         * CPU since v1.6. In order to accommodate both, have to configure
>>>> +         * the VM-level capability here.
>>>> +         */
>>>> +        if (!cpu->enable_pmu &&
>>>> +            kvm_check_extension(s, KVM_CAP_PMU_CAPABILITY)) {
>>>> +            int r = kvm_vm_enable_cap(s, KVM_CAP_PMU_CAPABILITY, 0,
>>>> +                                      KVM_PMU_CAP_DISABLE);
>>>> +
>>>> +            if (r < 0) {
>>>> +                error_setg(errp, "kvm: Failed to disable pmu cap: %s",
>>>> +                           strerror(-r));
>>>> +                return false;
>>>> +            }
>>>> +        }
>> It seems KVM_CAP_PMU_CAPABILITY is called to only disable PMU here. From
>> point view of logic completeness,  KVM_CAP_PMU_CAPABILITY should be called
>> to enabled PMU as well when user wants to enable PMU.
>>
>> I know currently we only need to disable PMU, but we may need to enable PMU
>> via KVM_CAP_PMU_CAPABILITY soon.
>>
>> We are working on the new KVM mediated vPMU framework, Sean suggest to
>> leverage KVM_CAP_PMU_CAPABILITY to enable mediated vPMU dynamically
>> (https://urldefense.com/v3/__https://lore.kernel.org/all/Zz4uhmuPcZl9vJVr@google.com/__;!!ACWV5N9M2RV99hQ!JQx8CdjEI-J6WbzbvB7vHcZ0nJPkzUhvl6TvWvDorAal1XAC17dwpRa6b6Xlva--pK-4ej3Ota0k9SJl3BUWXKTew70$ ). So It would be
>> better if the enable logic can be added here as well.
>>
>> Thanks.
> 
> Hi Dongli,
> 
> May I know if you have plan to continue to update this patch recently? As
> previous comment said, our KVM mediated vPMU solution needs qemu to
> explicitly call KVM_CAP_PMU_CAPABILITY to enable mediated vPMU as well. If
> you have no plan to update this patch recently, would you mind me to pick
> up this patch
> (https://urldefense.com/v3/__https://lore.kernel.org/all/20221119122901.2469-2-dongli.zhang@oracle.com/__;!!ACWV5N9M2RV99hQ!JQx8CdjEI-J6WbzbvB7vHcZ0nJPkzUhvl6TvWvDorAal1XAC17dwpRa6b6Xlva--pK-4ej3Ota0k9SJl3BUWzQmZ_yA$ )
> and post with other our mediated vPMU related patches to enable mediated vPMU?
> 
> Thanks!
> 
> Dapeng Mi


Sorry for the delay — it took some effort to learn about mediated vPMU (as
you suggested) to adapt this patch accordingly.

Yes, feel free to pick up this patch for mediated vPMU, as I don’t want to
block your work, although, I do plan to continue updating it.

I am continuing working on it, but my primary objective is to reset the AMD
PMU during QEMU reset, which depends on KVM_PMU_CAP_DISABLE.

[PATCH 5/7] target/i386/kvm: Reset AMD PMU registers during VM reset
[PATCH 6/7] target/i386/kvm: Support perfmon-v2 for reset

Would you mind keeping me updated on any changes/discussions you make to
QEMU on KVM_PMU_CAP_DISABLE for mediated vPMU? That way, I can adjust my
code accordingly once your QEMU patch for KVM_PMU_CAP_DISABLE is finalized.

In the meantime, I am continuing working on the entire patchset and I can
change the code when you post the relevant QEMU changes on
KVM_PMU_CAP_DISABLE soon.

Would that work for you?

Thank you very much!

Dongli Zhang

