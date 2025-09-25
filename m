Return-Path: <kvm+bounces-58819-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DA19BA13D6
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 21:42:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DF8C9327C78
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 19:42:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04C0531D39D;
	Thu, 25 Sep 2025 19:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZaIHgLgc";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="T7yFn6vv"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578BC54F81
	for <kvm@vger.kernel.org>; Thu, 25 Sep 2025 19:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758829356; cv=fail; b=iLF/XQdmXg73Yuzbb1W4hFxk3WUDQ2NfZcFJkn2BI51J+B6YfLVSp7QqqEGxHPSHvVbsB+qfKN4yN5KthEQpYGSDdvrYQ27L9L7vm+krVp78I7qoBteB/DkFj3plHhNNmL53lQD9ROxVyHS69l05fpEQmnxvLu8QldZAXEpodbs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758829356; c=relaxed/simple;
	bh=mfZFKNgdz2Ej8uk3k4womRtecgoE3TQj2/feveCIlbA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PIJu2U6Gjmlrha+tRjJnGRUutXhURE3baF/8JF/FgzoWfyCkRkNxrvz6kbfXZGP8Wd1Zi4S65mFH+niQH37LYR7uaq6x7I16T12OI2DLo4Om/QLvoXGqUeQRcY1F/JhnXKrGvbka7ayRp6vbt8kLJR5m3+4cwoWl4pNWgaKDLD8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZaIHgLgc; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=T7yFn6vv; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58PJ0d2P007598;
	Thu, 25 Sep 2025 19:42:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=zfL4UOVtHSWLvLdv7IjGHRvU+ZGZhtNDTn7/ZG/Fde4=; b=
	ZaIHgLgcRyDovi79+WXGXmET4y/1e/7fW8SSQk1OayrlHYxKuOciH7Oalf3JNRE6
	No2cwkKgq4QajdJqhXJlSt6mB1gQGWGaTQjvEXJdIC76du1P8W9LKYGBhFnUsTxg
	Hojp9HeOtjhHESsGgTRQlFWxmVhs6k1fqfad55H5jTC3PWYfBgX6tlqJLL2ExlAp
	V+oajVebtP6fS2IaKdSb0IUmLAaX9hjv01SVTXzZohST+lCadEMQHbD8nbaFx5Ii
	kGj+sZ+Pksj906MuFuZ7GFWzjIKz5tA2xCkYANdHX63XK1HxaRrXJJtTsMGqV1WI
	IQqHNNPs0jQV9chNriJP4w==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49db05g48p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Sep 2025 19:42:17 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58PIJ28K015486;
	Thu, 25 Sep 2025 19:42:16 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012027.outbound.protection.outlook.com [52.101.53.27])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49dawk2q9d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Sep 2025 19:42:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YqST8rRMLNxQG+1HyS6ePChhhhpvhR94FoZlBYjEtFcU9LEUH53E3VRoPy2HTB/Iaoot6Y2V3il1vVqCco3M3iTLl/Lx7I0h9mgshW7yEWdOsTvE3GZ6/KeV4R8DqdiA803Q15vrrL4Tau1TUWap5rJEp+w510ukit7e0gmEwQra2NS3+gJpW/8fLEEIlbBxWJXMslE87mdW6pc4XLGXhQrrhz/ka9LSsobhUvCabVxMKkXTRdixmkKY+OKkUYUMlYMxC6Kf8Tpa7FVuCo2mPssH8Qpsmuot4vOF6EY1maGXDtkm4vuCZ1wI8512eSaiEoqQOdYy7Jy/+NPsJYaXPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zfL4UOVtHSWLvLdv7IjGHRvU+ZGZhtNDTn7/ZG/Fde4=;
 b=iTJcY8iX/IUdPI+CeQ2xLGoa6+INr1pcSF1XRyJcx9o06vNGDU06m0N+e2BQdlUO0ygNYnrIS7oZErddEVYKcxSneY3TyYpdCkL1YCLdqMwgpXqfirDQ/VorUdinqBct2SPJy9m15qGFQHqTTrvPRCADKYVm/dkU+ydo7L1D6vmFavWjLqtmXDCPLIrFYtqsEKpzX0OCbEqtzrQY2DXlq47B+IBXuPqERqkQbUj8gykBMX8RhjGydQoKDlTdgwHJcB0VN+S6rbXFNQi6DlbwxBjK07PjgVElK2n8R/4r3wU5nhnj7Eps+CKSeYtFwW/nvBjayH1S4sMPaAOVNsksgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zfL4UOVtHSWLvLdv7IjGHRvU+ZGZhtNDTn7/ZG/Fde4=;
 b=T7yFn6vvEAHeA5dV9DliroM0xL6mwx+IVEPNZmlVpwLzTUkW71USF0SzDArLAnfDezbh+ZH5AXgwwf6Xd+XffyqRq+Vnl4CJ4tec0AQskR9OGhxbWCoGna4pHxYKt0ncuo5uI6PuqC4ZTLPuXJW4qXiE9UJdj7Gcnwfzu8kX4cQ=
Received: from DS7PR10MB7129.namprd10.prod.outlook.com (2603:10b6:8:e6::5) by
 PH0PR10MB7006.namprd10.prod.outlook.com (2603:10b6:510:285::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.10; Thu, 25 Sep
 2025 19:42:13 +0000
Received: from DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::721c:7e49:d8c5:799c]) by DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::721c:7e49:d8c5:799c%3]) with mapi id 15.20.9160.008; Thu, 25 Sep 2025
 19:42:12 +0000
Message-ID: <848f7a55-7c68-445c-86fd-29530837b8f3@oracle.com>
Date: Thu, 25 Sep 2025 12:42:10 -0700
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
 <2cf13be8-cd27-4bfb-af8e-ef33286d633b@oracle.com>
 <acca55a49bad023fad30625fc81e19ef1c3d0ed8.camel@infradead.org>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <acca55a49bad023fad30625fc81e19ef1c3d0ed8.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR01CA0058.prod.exchangelabs.com (2603:10b6:208:23f::27)
 To DS7PR10MB7129.namprd10.prod.outlook.com (2603:10b6:8:e6::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB7129:EE_|PH0PR10MB7006:EE_
X-MS-Office365-Filtering-Correlation-Id: 938d8cdd-9a64-4abf-e657-08ddfc6b9f3b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bmlZNjdYQUxRSlVKUWh0aTVmMXk0UnpRcUJNb2l1NTgwN3NRYXFleUpZQXEz?=
 =?utf-8?B?cG5Ka1labjR2MlN3YVFMeWZRb3VDeGpXeDMxWEZDY2grT2VzTUE0Q09EMU1C?=
 =?utf-8?B?bW11UkJJUEdlYnVvc001NzJrWGpaaThVMXY1dHljVHBEL3QzRG5UQitiTzgw?=
 =?utf-8?B?MEVEd1dwVTFJSm05NmEwb1BJZVpZZzhxeFRRa2YyQkR3aC9PZmNHVXdGNXhH?=
 =?utf-8?B?a3YxNk1nd3FBdk1pQ29wVzV2bVU0QTFHUU1FbWJONWVXQkpuNjUxRGNaemha?=
 =?utf-8?B?VEZJYjYyTWpMMXZEbGorRUNjSmxBMUFncVd5U1NjYkpKMy9GbU85OC9NeVhZ?=
 =?utf-8?B?WkVlTVhYMFhzaUpRaVNPdDRSMEo0dHQxZ0QvUStIRmFtTjNyYjNvNHJHc3BV?=
 =?utf-8?B?bUVYM2JkRVZWWmludW5qa2wwSTVqcXo1eHRlbFNCVXpJY1F0dmNIbWJaakd1?=
 =?utf-8?B?RkhhMEh2dEtFMWdIY24vTGRyM2FHcnY2OFViWGwrbzZZVThXUXhQenQzRS9P?=
 =?utf-8?B?cTB3QmhaUlBCWDg1QmhhQWlvdm5jT1FaMUlqMkdsU1pRSEx3bVdEU1gzYlp1?=
 =?utf-8?B?NzdhaWlvc3RaS0YrOWI3QjJ3SlprNW1EdmlwdVZ2UE13VEs3bDdlWWxJSjZ6?=
 =?utf-8?B?Mi9BQzA3d0JVNlZXSHVUeElqbTRoekpTd0dFSXFQYk1zSUlGQVJqczdtK08x?=
 =?utf-8?B?Q3hBNXlQanN3SG9VNFV2a3ZDSXJVdzZORGcwZDVNclR1STVlMG91elJMRldw?=
 =?utf-8?B?c29pcit2MlVuNFQ4QjZMTGQxd1ZJTi9UNkRCdys3emd3NUxZTGpSVTU0MG9m?=
 =?utf-8?B?RFF4SVZUZ2REa2lWU0dSZ3dZcTBoRnBVVFRKK0EvZkJBdEl2NXNuMnpmSjRa?=
 =?utf-8?B?Y3EzSTF4UzErOHdUQlpIa0lOMjZsWHozVnU3ZVZaZmdvU3l5YlovUHlWbmpQ?=
 =?utf-8?B?bFFDR0NDRE1VUFlwVVkrWU5GMEpPQlhsNEFzbG1LbUZySXZKQ2t1Q1lMYVlr?=
 =?utf-8?B?cTBKYTloeC9Samk3eHVzclkyTGd3bUJOOWF6cjc2dXNLV1ppRW9Oa3l6SVhS?=
 =?utf-8?B?RXdlK2FiWVlib3RDTEVaYzFYRzk5bmoyVUVXZkhIR2F3TzdQc28rbEFMVmNZ?=
 =?utf-8?B?a2s4Nk1Xc1hOQVQreFAyalNvOXVVRHhZQ0wzZDRYaVhJc0liSWxRVERBd0lC?=
 =?utf-8?B?REJ0UEVPVmpHSjRYMnBaL3RBc0lSbG9RVnd1dWpqWDZZOHFRakM2M3F3OVcr?=
 =?utf-8?B?Y1pLcVAyZHc4WGYwM1Y5S3FBNzY2bUFQazNqalJ1bHBHa1k4M0F1YldqOHZT?=
 =?utf-8?B?VnFveDNvUVpVaWw3WkFoKzA0N0pqTE5OZWErWlIxMUdpaEdpbkRBZnd4S2JL?=
 =?utf-8?B?N3BhZEkyQlJOZ21rTGhsQVUvQTZrSDM5c1B4ckhNZFhzL0ZWWUcrUVJjbFIy?=
 =?utf-8?B?aitMZDhscGdDMEI0T3FvMlFVQVBNbDNIWlNBRVNxcW4yR3g5MDVia29BMyt3?=
 =?utf-8?B?b1pETVlHZ21vdElXZEdXNG5ld3NobThsR3RBUzNreWY4N1FkbXZvcmFmejMv?=
 =?utf-8?B?QWg2bjM4My9LeHAvUDRQRlNDRXJMcUtMNUxzZ2duNFdObzA5QmFDR2Zabmdz?=
 =?utf-8?B?Y09XSHlvZ3d6VVJiT0hXRHhBWHRQR0krdDBhelkwdXVxalBnSC8vSU9FdS8w?=
 =?utf-8?B?UGw1VVJzNy9UL0RCMzM5R2oxZDl3VjBOS05lS0lFTjczL053TUxHMHpBcFpT?=
 =?utf-8?B?N1VheWpHR1BuNUZ2ZURwRUFzNVVCR01BNCt1SGlIVjZONHBOSzg2cEwrKzcz?=
 =?utf-8?B?aGdmcjA0M281RndXaHNVbWxic05aeURZOW14L0VuZ0JtWFN4dUJNa2NCaHcx?=
 =?utf-8?B?S2pTWm1RUEJnWWlWcmJZdllnWVFzVUNxOTF3TTFPNnp5MThZL1ZWUHlLY05Q?=
 =?utf-8?Q?KGjf4fJvn5jrWN0bA+PFilTJfo/QePnZ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB7129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T3dyZnFDVi9mV3I3T2FJQW5WN1Y2LzJVdGdsL2VpSGpmZ1pacWRlSXkyamRo?=
 =?utf-8?B?TmNNR0l2b0hNU25IZGZtdmtLZEpCMEFaeFM1S3hXcGJKTzlFWTI1U0tVTktz?=
 =?utf-8?B?Y3dPOTZzdXJBM2F6Qm5mQlpwNDlHSm53Q0l0eVBRV2hUTTlQUGY0NE5WQzhx?=
 =?utf-8?B?U1MwekRHZllsVFJnMG03WWsxa1hyK0djUXBxTXo2MHcwL0U0emVBU3ErSTJG?=
 =?utf-8?B?V2x0blY2THRGcDRqaXcwU0hOcy9PRlQzMmxtZjhkSTBIVCt5dGRGSDVPOGRk?=
 =?utf-8?B?d3cxb1ZndE1JbHRqQTFRdDRvbjdIODRmUGpkdjd5UUNoZmZIeXk3V0ZHYXVj?=
 =?utf-8?B?WEM3T2xZaXplNkQ0SDFtWHlaM0pxUnA1ZXJyVEZxcnZ6V3dxK1VPUHVaUTI4?=
 =?utf-8?B?UnBySllpbVA0WGF4bWlkUHdpWi8xdFJ1SFRpSGVFNU1nc2VWRVBhYzAwbFNo?=
 =?utf-8?B?VGVNdVl6VmFYTlRMTUhzOW0zVmxjcWRXOTUrb2Q1dDQ1YTJ5aG56d3VnQTNH?=
 =?utf-8?B?Uy8yUDhZN3h0M1FqNU1RVlVMcWVRVTEwTG9MbHUyc3RFbkNOZEgxK0Z0RDB5?=
 =?utf-8?B?TGRuVm40L2l0RUhKUExsTUVoVFlHRC9RTTQzMElVa1MxUFhRTzkwODRhSjk0?=
 =?utf-8?B?SUlJRE1qN2tOSTJZVEE4TXRURHVVM29HcldRYTRNV2o3M1NDZzhoQlZyTXBF?=
 =?utf-8?B?Qm8xMmdkU0N2RGtYSERjSjd0V0dlZWFCS2pVTU5qb1FPakNEdTZRU3owRHFy?=
 =?utf-8?B?MWdYWE9jNWR3YjlDSGpRRVpsWVdHWlpFKzY1L1BnUmMxMXA5b1VEb0tqVmJo?=
 =?utf-8?B?VGg4dGg1WkFJb0NKdFpaaEJlM3FEbXIxWHNBRW1EOHVlRml4MWFMSnArd2Fx?=
 =?utf-8?B?K3AwcisvZklaU2dqQ0N0SEZDcU8xZ20vSlRPYXpIZUlEVDhBS0VSUElmSUFT?=
 =?utf-8?B?Y0lmeWlBZmxIWG5vMU52QXdqUHZNZmJReWRpUVAwT3l4N1I5RkFsMHlHUVR4?=
 =?utf-8?B?NnRyMDliUisxdzk0dHh2OFFBM05pd0c3R0JYcFVGWXVFRFVsNmxuM2kvOWE1?=
 =?utf-8?B?djNlNkxUeUlDNTR4VUNlZ1dFOHp2cHdMZlI0M2k1UXRhOE5xb0NmY3hUUm15?=
 =?utf-8?B?US9UMDhaRzZzNnRaTWgyVVBwdEQ2QWR3b0l4U1ExQUc4VmxLQ2FvOVcrY2xn?=
 =?utf-8?B?M2xlOERIOXBVWERETkRTWHNvdCtKTXRBTkdPd01hLzVpZzhJSDN5cHdVL3pl?=
 =?utf-8?B?alUzbzQ3U1E0eXZQcDhQbUJqK2x3YWNGUDIwaW5iTWdsTHpZM2pmSWdQb2FJ?=
 =?utf-8?B?ZFV4eTFnUTFEdUpkeTJyQzJ0WCtIdWxnQms5ZitOQUQzZkVmTmYvZjVMSzhO?=
 =?utf-8?B?R3Z1c3JKREVvOU9uNzJXamJIWE40ZnlQMmVPNkEvN0RCMWpBNFhSN0ZPZEcw?=
 =?utf-8?B?dEkrdlVXbk1yQ0xJYnZZN1pBYlhxWko5dE01anBXdTJGc3hFa1lxSzZ2ekIw?=
 =?utf-8?B?NGtscjVPS3VQZ0hPYWw5QUZtVnV5M3VGanlUcXlnTTlhaXMvR1M2eWFWRUY1?=
 =?utf-8?B?Y2l5ZlRQOEM2R3QyRFBFRDB5bGtiZVJNWHRGenJQeDc2SmtPT29xaE9TWUZL?=
 =?utf-8?B?dlFJanAyMkpnVU1wb0svZjFTQjkzdTh6UGVuaG1jWHZ4R3htaExzSEVLNjZz?=
 =?utf-8?B?VXhzeldtS1VTc1dZdjIwMElPMWxkS3hjZzlha3Zndnk3Vk1mbEord1hvajV4?=
 =?utf-8?B?bjlrL1JSWDUwMzhFRjJXZUdjdjBvdHpDMkFWdUhTbWVnN1NveFBXRVdLaDVM?=
 =?utf-8?B?MkZLVVlwUTBJOU9SUHpmYkpoRWlBelZIb013bkdYNjgya1BzZU5DVWYvWVNL?=
 =?utf-8?B?M1JyQklTTFdKTDR3OCt1VnJxc0RFUlVmZ2lTMk16VnYzb04wRFB1ajlCZktR?=
 =?utf-8?B?RUJrM0RXYndrSXNiMFVxQWhkY2xSb0pNWlF6MGxxZmw4UloxZEMzM1lsY3Jt?=
 =?utf-8?B?dVhGVXBBd3FqaVEwZHZxVnRxZkJXTmxsQ1g3ZG14Q1JUZkVLU3IyN2JvZHdw?=
 =?utf-8?B?RVl2TTNrczNOV0lRVTVSZHJPeTgwaGNKY0tSQlZSb1YyYlF5YTltRTdtRXdO?=
 =?utf-8?B?cEpUOWN6RVdHRjZxSEIwMnA3dmMwUUR4QVRjREZQdXZ5bTcwMnRKUFI0Qmpo?=
 =?utf-8?B?SEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YqjhQkFJ7AgT8/+1A6DYZeNggRcAoHjeUsvg4VgTgbQuMNNvYKRIBKaKaZqGrYaTVzGV/BzZZ5o+zNkhMoUEY1LCvZGrvh0Hl5ZFgduQUiaNpGvELrXw0jFgO4Mgtlbl6Z/mKAsnZBqh1YbwTvlwu/FNRKtv+CgDLrS+AIiX0WJFF9qdFNtqkeH98g7GOaQkiR1AiazkUQ2Q4nmcsCwX3XpDK7z1sekdeyo4w31U7ZVagsN2zpMyxVetNlPD5v6Af2PEdl7jI+9vDwRZynxjmLk+EnbrPobgXlzzNGVbiBKldFr6OPx8u8YyObjwgEVaKlQwSMuyUl0uTXLzcA1ABDG1sJeF41IRgxY9gk9WiOVmKtOHAKyDOGhyGL3JD4hjtMdRkKHgs+ZCewJu9e9+7fJNk5GFSQOdjbPEcerT2JSaioZrwsrX8z3LWDJIXAzssJzIvle9Uyli0V5CpubDdGMNV6IcNed2QmkX+EtRw4ndrbfr5X/DpglPZeCSonGOP9clUZVOtL/iRetQ6Qsf52Co96WX19Nx/54U+e+Or04m2ZZCoqR91yMBlG3Scy8rw6LdTYyLeAkLG1BmvCDvnIP/cB1dntpvjPo9us4fP0I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 938d8cdd-9a64-4abf-e657-08ddfc6b9f3b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB7129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2025 19:42:12.1865
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ghSK0UwuYFkOJE+4fiCZIPxJpKTdCT9kZ4FuJ59WayOgDFr5UH0oxuE+7+PiAqQ5ptxSNi2E73kP3CTYmFU/fg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB7006
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-25_01,2025-09-25_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2509150000 definitions=main-2509250181
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI1MDE3MSBTYWx0ZWRfX1J6m6G2+JZr0
 ZrxCEJ0f8eA2p71z8d+VSGgnEggUE3ClD3+xaBJ3hCraYNHDey3KlSSZYudJIS6N6aVLnUBEd8A
 uAZdMcCb6EJZyyFD9gZrRoFa5dvfnj5KW5XPxYj3TG1MsCE6QOAQtveN7sp6YDAE0ywyTLqyb8B
 OYw8L1VLGFH5e4lWv4t8idhr9YCS+3tFbawcwx0aeUNhrdCHeeWH/PXNbvTQl3f5vpaS9wZ+hRT
 ZqC9ayn9KvixaaLgIcoXC37XIZPwOl5QBAdrsb5WgmBGPBbjHqUQbQPGKqPqdXyiMem59fSLq7I
 ZksyES7f5EDIzjW74wXnHZRVIokhV0+tf0UCk5eBBoJUUdOn7hyI2476FVtL0t1F/hNEMIC75ez
 E/n2KQKxkcdhAuC48MkdmRNKuGciduKUJ1oL+16XOC9hZk6nwKg=
X-Proofpoint-ORIG-GUID: 0XWttXwu1msExd5iVfkjx7YhIc9OdCW5
X-Proofpoint-GUID: 0XWttXwu1msExd5iVfkjx7YhIc9OdCW5
X-Authority-Analysis: v=2.4 cv=aIf9aL9m c=1 sm=1 tr=0 ts=68d59b19 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=_OGQN-4FZRlMtWEKrAsA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12090



On 9/25/25 1:44 AM, David Woodhouse wrote:
> On Wed, 2025-09-24 at 13:53 -0700, Dongli Zhang wrote:
>>
>>
>> On 9/23/25 10:47 AM, David Woodhouse wrote:
>>> On Tue, 2025-09-23 at 10:25 -0700, Dongli Zhang wrote:
>>>>
>>>>
>>>> On 9/23/25 9:26 AM, David Woodhouse wrote:
>>>>> On Mon, 2025-09-22 at 12:37 -0700, Dongli Zhang wrote:
>>>>>> On 9/22/25 11:16 AM, David Woodhouse wrote:
>>>>
>>>> [snip]
>>>>
>>>>>>>
>>>>>>>>
>>>>>>>> As demonstrated in my test, currently guest_tsc doesn't stop counting during
>>>>>>>> blackout because of the lack of "MSR_IA32_TSC put" at
>>>>>>>> kvmclock_vm_state_change(). Per my understanding, it is a bug and we may need to
>>>>>>>> fix it.
>>>>>>>>
>>>>>>>> BTW, kvmclock_vm_state_change() already utilizes KVM_SET_CLOCK to re-configure
>>>>>>>> kvm-clock before continuing the guest VM.
>>>>>
>>>>> Yeah, right now it's probably just introducing errors for a stop/start
>>>>> of the VM.
>>>>
>>>> But that help can meet the expectation?
>>>>
>>>> Thanks to KVM_GET_CLOCK and KVM_SET_CLOCK, QEMU saves the clock with
>>>> KVM_GET_CLOCK when the VM is stopped, and restores it with KVM_SET_CLOCK when
>>>> the VM is continued.
>>>
>>> It saves the actual *value* of the clock. I would prefer to phrase that
>>> as "it makes the clock jump backwards to the time at which the guest
>>> was paused".
>>>
>>>> This ensures that the clock value itself does not change between stop and cont.
>>>>
>>>> However, QEMU does not adjust the TSC offset via MSR_IA32_TSC during stop.
>>>>
>>>> As a result, when execution resumes, the guest TSC suddenly jumps forward.
>>>
>>> Oh wow, that seems really broken. If we're going to make it experience
>>> a time warp, we should at least be *consistent*.
>>>
>>> So a guest which uses the TSC for timekeeping should be mostly
>>> unaffected by this and its wallclock should still be accurate. A guest
>>> which uses the KVM clock will be hosed by it.
>>>
>>> I think we should fix this so that the KVM clock is unaffected too.
>>
>> From my understanding of your reply, the kvm-clock/tsc should always be adjusted
>> whenever a QEMU VM is paused and then resumed (i.e. via stop/cont).
> 
> I think I agree, except I still hate the way you use the word
> 'adjusted'.
> 
> If I look at my clock, and then go to sleep for a while and look at the
> clock again, nobody *adjusts* it. It just keeps running.
> 
> That's the effect we should always strive for, and that's how we should
> think about it and talk about it.
> 
> It's difficult to talk about clocks because what does it mean for a
> clock to be "unchanged"? Does it mean that it should return the same
> time value? Or that it should continue to count consistently? I would
> argue that we should *always* use language which assumes the latter.
> 
> Turning to physics for a clumsy analogy, it's about the frame of
> reference. We're all on a moving train. I look at you in the seat
> opposite me, I go to sleep for a while, and I wake up and you're still
> there. Nobody has "adjusted" your position to accommodate for the
> movement of the train while I was asleep.
> 

Thank you very much for explanation!

I will use something like "keeps running".

> 
> 
> 
>> This applies to:
>>
>> - stop / cont
>> - savevm / loadvm
>> - live migration
>> - cpr
>>
>> It is a bug if the clock jumps backwards to the time at which the guest was paused.
>>
>> The time elapsed while the VM is paused should always be accounted for and
>> reflected in kvm-clock/tsc once the VM resumes.
> 
> In particular, in *all* but the live migration case, there should be
> basically nothing to do. No addition, no subtraction. Only restoring
> the *existing* relationships, precisely as they were before. That is
> the TSC *offset* value, and the precise TSC→kvmclock parameters, all
> bitwise *exactly* the same as before.
> 
> And the only thing that changes on live migration is that you have to
> set the TSC offset such that the guest sees the values it *would* have
> seen on the original host at any given moment in time... and doesn't
> know it was kidnapped and moved onto a different train while it was
> sleeping...?
> 

I see. That means, only re-configure tsc_offset, while maintaining the
tsc->kvmclock PVTI. That's the reason you would like to remove
'kvm_arch->kvmclock_offset' entirely as future work.

Thank you very much!

Dongli Zhang

