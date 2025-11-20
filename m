Return-Path: <kvm+bounces-63759-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 996A0C718B2
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 01:23:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id 5E9E328D59
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 00:22:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C9C01D5147;
	Thu, 20 Nov 2025 00:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cPb4PbSG";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="WleO+hRC"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AB2019047A
	for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 00:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763598165; cv=fail; b=KQK8VYnS4Rh9OZ/p0RZIEov+Vr4aCy09oKajCwI4vB1hamM0Lqk/fmU/ADvLo4IoQwbQ07LMJkTz93MRLw7bmf1ecdxeMYj0XlodtIJEHRiawIWDr82+zoM1J///43mA6ayWrQV+3rbmA/h9v3cH5Hvwlrd01bo9E55pCIN0pDk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763598165; c=relaxed/simple;
	bh=r7B/K9S8bMx5cL70pYWNok5OcbaCq1nA3qXSDFHB4Pg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nuRgbN00OjmXSnPBZ1P42yE6n94wB90ammPkiRKH6ecZK0wTsL4bBLe7J7H0g5Dbwr3DbFb77MT0rXG/0/0f0NNUqexupo9mf3oYulOMmXoVz702Ms/6oU9ybjaa0mJvpPvdzrtwnCMn8Bq9cGdnsWusqqpc8qctoKGVChvhA/I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cPb4PbSG; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=WleO+hRC; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJLPXNK008800;
	Thu, 20 Nov 2025 00:22:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=HGw32/wa7p/zlAUJGdyhHUfNPoYZMO19ExTqVJvKxQI=; b=
	cPb4PbSGa5HbG1pyHNk+WOMH+RbJNPkZ+w4NgqK1kF6M3w3ahQp+9Ijg5EtrShF2
	gQPx31BN0bbVnOi/CJsVOQEyx9WmvlLPDO60ASFHU2huDyua5oZc4JNLpEkdpSHG
	8TBSPWQynUVKAvPZ5j7Eecg4YBlKrKkU78EE4iXGc61w9gBmrtOtLIb7zUu/WGy4
	ZxGZ9svEWOwWBnPfpBg58vXTLbf2tZuRQaX9+s5DkeGY0rDFDzA0qndOsyUA4YdM
	czMsvF0fbOl1XmQo86mFwCbrJ2UBus6/S27K8Qw5X3Cx2cNpI5vB3eyImrHFCjzB
	XW3KCO+rHi9ucgbcySUWwA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aejd1g413-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 00:22:16 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJN4Tpr039826;
	Thu, 20 Nov 2025 00:22:15 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011036.outbound.protection.outlook.com [52.101.62.36])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4aefynnex4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 00:22:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C+dJDi9Ct7Gwr1grhoOGRSTaejdsrfSGb2e6jidEf+PSMBhxzowiXqozj2Edwtn11Cu1HbdL1LmHCEjQN/TEbCkwn6rH6aGB1HoZdbQtdPCVnjfKJ2rBWFG0xFlAU3WcOMzFMRpQ3hyoWMgixG6MJ8bf6i1vchHlRblcHn+pM4DWx0aig4y+6AE+xKggSEojb55p2YcLj9OJLJ+WoKvM3ixSOsTgc2+Pe6JLwi/6Ad69+m6bwM4oPeQherBz7A9DYfMlJsNfqFM1N2EMl87Ng6S++y84oHS1kbzmanrcilA0uYlnMGsgZ6WHUddbF7sD4pKMoDcbo4/BGRxoiA4KBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HGw32/wa7p/zlAUJGdyhHUfNPoYZMO19ExTqVJvKxQI=;
 b=OzsCmK3XADiZkOe3gJwB//p2D5WqBzdbxVREwvL0QtFhv/ENJQht9aBl5Tl0dVikLM+GylsESzcPgrD76NU9DMuyVC+7OpLUEXWABj5bkhZ+Zc/YnDvSQEKdXd6Gg1WMWvv4BSGD3SFIAu9RqOjLBwAtUTnAncxWFS95qrkU/I8OgA7hcoaOYwNpHrG3v2vUUnDkmzgjea51xAEbH61ufmwjPUuvRSvmJXGn0+Nml4QTHV0Wp3XZLadD24cziOUZU1+uT5J6kcxFnHdGOTNbAHH2LieUZYzMn9rjbbOcXrGTvXLF6tbvWarfo/i9J4mQPemORpPBBawCtlcRsC1c/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HGw32/wa7p/zlAUJGdyhHUfNPoYZMO19ExTqVJvKxQI=;
 b=WleO+hRC2Z0H6F+/p80uiTJcEcLJzyZnZw6FfZDBEPSV+t8Z4y6UAR/qF38I2Lu4ZBBrNCtZhTPfusP7jXdK95T1eMVYmMcR6jiiuo6B4x/ZSiu5r2XttJ4UQ98Y/s46z3IftP4e0KWUDf40EW7hPCHR1qnFlBUf/ZJGw2rpvXU=
Received: from DS7PR10MB7129.namprd10.prod.outlook.com (2603:10b6:8:e6::5) by
 DS4PPFAE15A2261.namprd10.prod.outlook.com (2603:10b6:f:fc00::d3f) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Thu, 20 Nov
 2025 00:22:13 +0000
Received: from DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::721c:7e49:d8c5:799c]) by DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::721c:7e49:d8c5:799c%3]) with mapi id 15.20.9343.009; Thu, 20 Nov 2025
 00:22:12 +0000
Message-ID: <077866b9-eaa2-4671-bb96-6c6776d0f72b@oracle.com>
Date: Wed, 19 Nov 2025 16:22:10 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 2/9] target/i386: disable PERFCORE when "-pmu" is
 configured
To: Zhao Liu <zhao1.liu@intel.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, pbonzini@redhat.com,
        mtosatti@redhat.com, sandipan.das@amd.com, babu.moger@amd.com,
        likexu@tencent.com, like.xu.linux@gmail.com, groug@kaod.org,
        khorenko@virtuozzo.com, alexander.ivanov@virtuozzo.com,
        den@virtuozzo.com, davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
        dapeng1.mi@linux.intel.com, joe.jin@oracle.com, ewanhai-oc@zhaoxin.com,
        ewanhai@zhaoxin.com
References: <20251111061532.36702-1-dongli.zhang@oracle.com>
 <20251111061532.36702-3-dongli.zhang@oracle.com> <aR2ky5WU8CqH8+lS@intel.com>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <aR2ky5WU8CqH8+lS@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY1P220CA0004.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:59d::15) To DS7PR10MB7129.namprd10.prod.outlook.com
 (2603:10b6:8:e6::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB7129:EE_|DS4PPFAE15A2261:EE_
X-MS-Office365-Filtering-Correlation-Id: c209bbfa-f049-42f0-2f36-08de27cad9f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?a0lEam5pM2kxa2R5NzJodi8zWUdNeG1qbWRQSllnR05TOUp6am9IdHdhVEhF?=
 =?utf-8?B?ZkVjOTZ0SjBtb05BaVluaFNMK0E3ZUw0bC90eU1RaituaTUvRDdpV1BMQ3hU?=
 =?utf-8?B?RFR4UHFnSEZGNEdoV3RYT1VpTkVUeFFtTkRsUEoydmN4Q3dWamhHQWJHc1VF?=
 =?utf-8?B?Y3dwRUNkVXpQYjRjeENjMnk0MmVLYmZ3N1E4R25ZVTd2NldsT3RxbEVFQTIw?=
 =?utf-8?B?aUt6QjJkU0hQTEo1Vi9rYmhNS0Mra0duNjhJYnRMT1dlZUdqcUVKQStzeXBu?=
 =?utf-8?B?dWRaOEFWT3M1UmFjSlExOE1XK2txeUpNOXBoem9CQ3AxdFV0bGxLbm0wSnEw?=
 =?utf-8?B?REFzeUtaTTFtbmswTWc1RkxtUzZadXdQOHlvc0RPV2orYk01ejdzNHRtbFNH?=
 =?utf-8?B?eWxHMGtYeXp0VmdIVUVJUEgrczVkM3o4SnB5bzA2YTV3Y0ZUQXo4Q3l6MU12?=
 =?utf-8?B?Uml2bVVHRTQvVzUvOEVFejUvbEF2NVB0d25QVk1jb0FMQWgrbnVkRFpTTHRF?=
 =?utf-8?B?VGIrVjR3MmNHeVYyVUoxSmdoVFc1MUdGQldNbFlxdEpUcEVjTzVNNFpUNVlM?=
 =?utf-8?B?bWJQVWdickJ6bzQvUndhellhaDlhQTBxWGY3RlFySWlEUVE4UTY3NytvSSt6?=
 =?utf-8?B?Ry9LUzc1V29WNXF1ek82aXJmeENJNGVjN0c0NFRVenhDTFJvYW92TUZvRUZ6?=
 =?utf-8?B?ekF3TERCb3lYWlJFeWduaGU0WURmVk1aK1JFK2V1b1BZWVFXTzJJK1NGWDVB?=
 =?utf-8?B?OWlDekJiSzE0V2ovZW5na3hWSTJ0aDAvMVZxT1VQb1Rrd2xqM3c0eXY5WGky?=
 =?utf-8?B?YTN5YnU3aVdxcG9vNnFkeE9HanJXOVhPdkZIakhiaUlsWWhCODhaMWxsOGZD?=
 =?utf-8?B?RitaVGhBOGJadjM4YS8wc1EwS2NNZ0tGRGRMK1czY210eFdiR0VCa0UxZUhT?=
 =?utf-8?B?M25sWG1rYy9BZWl0MmJQR3g4RjJvejhINjkvcHk4a3dtTy9HYWtrWXh6YW5p?=
 =?utf-8?B?SVJsTFlHWXZTdkNqbnFwQXhmMnJYdTdsZGVJSmM0RGo3cUwvd1JOVEROWE1p?=
 =?utf-8?B?M3BXTk9JT0JaZktXU0pBMGt0bExNMnNzQ2krdnVIaXZnU3o2dmhxTlFXSklj?=
 =?utf-8?B?T01yQ2xKRjg4eDFBZnBTM2gzbVFoc01xd0ZLR2VOcWtHQ2hXaUxFWHRkV25D?=
 =?utf-8?B?SmtBd3B4QnhMTnlJRldidHZCTGtlQlFZeHE4b0IwVHZyRmhBR1ltdnpTOCs4?=
 =?utf-8?B?SVZtWnhkNS9XcEphR2ZlbVFiVFdaeFRDOWxOREhTVk9MMnpyYkNSbjV0SEUz?=
 =?utf-8?B?elFEeWtvV1VURklSTnhmZW5kRnRLRTlDaGNuS2tvQlBsaktZSEYzR25WYmQ1?=
 =?utf-8?B?SW54ZkgxL1RwL1I4MmpKT1JYVDBvRmZCV1RheUk1cWEzcEQ2QjdXWnFlcWFJ?=
 =?utf-8?B?b1FnVEE1VmYxeFFablZ6SEtNWDVUSWc1eFgvZ0NRblF6WEdZQnp2UnlESWxv?=
 =?utf-8?B?VHJ3amFLWVVMcUpkbDNncWJ1cEVMVE05U29ibHhSdWJNS0I4MnpkcFl0RmFa?=
 =?utf-8?B?WG5sSTFXSUcwWEc5SzlSQVhoV2ZITkRNRm1KWDNvYTVJTjlIUys3UHZTR3p4?=
 =?utf-8?B?YlRqY2EwWlNRSk0yMW82QXJ1OGl0OW4vWHRSMDFIVWd6OExYc3BMSDNNZmN6?=
 =?utf-8?B?dEd4ZDRJK3pmUERMaEJjbTBKNEk4bitmdDZUcGJ6YkpBTlhVY1ZjY2syUWtp?=
 =?utf-8?B?VURKUWtxNURnOFVoWmlYQ21FQUtMVnloeVo3SWpJOEZKenl4b0NTVmVoWDFm?=
 =?utf-8?B?VFF3dlRuSzRkS0lvSEFGSkgxNmtaSC96QXlEU2ZFbDhPcjk3NnlKdmxIQkNi?=
 =?utf-8?B?VHMxVnJxc0xNVUtoNzBDQUZ3cWpXYmNuaXJKNnMxUmZ2ZS9Pc0F2YUN6Y3ZY?=
 =?utf-8?B?VEJNakNWMzJ6K0xPVFI3Y1hFaHU4MDVlS1JYZ2FOeUs0aUhQbDA2WHkyK05o?=
 =?utf-8?B?aVEwOFh3WjlRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB7129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bUQ1MGhIV3ArU3VyTTQ1b3BOZnM4clA4Ui8zUkpCN1BrYk9LYmI4V3ZtcW1X?=
 =?utf-8?B?ak5CL0ZlSEszeWIvQlM5aEloeFNoTjFvK1FEY01USzZQWkJVbFEyZ0xmbU43?=
 =?utf-8?B?aE04MmJhV3lneThjdEJzL0NTeStnS2lxbGMyRTNsckRPK21GRWg0ZzIwdm5q?=
 =?utf-8?B?d2xjOHdPeGg4Qzlhc3c2Rk41YnMrM28yKzJML3JKK1lFMGs5NUV6My8xU3hR?=
 =?utf-8?B?Z3o3aG1KNnFWVjErK21JNHMyUFR5SjAyWDJsYUJoT0VXUmgrdTJCMWVqR3dS?=
 =?utf-8?B?N2l6c09hTmNXU2hQWkNGQTh5WGZSSWtJMXRjYWxCZ2licXBHREg5eFlIYzVx?=
 =?utf-8?B?YVJIOURkdUxaMEZhbzhUV1N4aEFCbXBhZUVCSFJVZDFUMllaMW5RN2N0TFZv?=
 =?utf-8?B?UUoxKy9xOXQwWktKdjJKeUF0aVVXVVNMZGdxN1hYWS9IQlk5b3Jnd0sveUtN?=
 =?utf-8?B?cEV5QzFVRVE5QjNlVGo1Z2w3VDBUczU2YUw3NzdreTZ6S1ZxaGVMT2tjanZZ?=
 =?utf-8?B?UGlkR2pWUThqYkRROEpiRGNBaGdYY1cxSk1sbHp1YmxsWHdVRVl3ZWVPaXFC?=
 =?utf-8?B?NG43MUdheFJGamhkNytrZ3dvTzBuZlVrSE9MTmVUQlVBeUJUc2k1cElQbGxl?=
 =?utf-8?B?U0d0V0dTS21tWEdNVmkvUkZYRXYxYU8wZ0RPaFJOc3pmSGlldjdPMDhoOVBy?=
 =?utf-8?B?U1Z1d2VrcWdpckJCYkZjYmszRVpnUEs3NXU4TUZVM0tEQnFSc3RPcDdhTFA0?=
 =?utf-8?B?SUFpK05WUWs5WDJoU0VJaVlJeTczeUJUc0N2aDB3WlhRWkRZRmhvblFSVG9o?=
 =?utf-8?B?aEFGcWttcCtUcVN2TGlsbmdhK3Q4ZW4yZ1paM2hvMEJrVTI2dTBndzlheEVC?=
 =?utf-8?B?Y3dxcVVpQUxaYll2dU5ZdTl5akZTVHo0cUFES2ZHYlBiby9iYkxQSlltbDJp?=
 =?utf-8?B?djNqOEZOUHVTdDUrMllQWmJ4M3lZRlB6RXR3ZUVZUmEyeG9Jcmp5L0FaMHlx?=
 =?utf-8?B?RjlKUEZMZitrU1lvME9uNE5pRzNNOXB0c0Jzb3F5MWlxTUsyWVMvSW81VGcr?=
 =?utf-8?B?TUNmcURzdHJ2cmY1ekFIUnNidU5KSlZ3ZTRVQjR4MWtndlNwcStoTFVQRklV?=
 =?utf-8?B?aHVSS1FCUEdkVlBUMjNCNGdhTDg5V3h1Zk8zc0RNeFg1OFRIcFpUb09DUEdL?=
 =?utf-8?B?Ti95c0NjRVBqL0hha2REWTdtNjlRa0RlOXZ6NXo4QTdiOTVlOWdEL3NJNWNl?=
 =?utf-8?B?aVFKQVRuckxwM0MydUVabVRnRWMzcG5iZWs2WHdoaGREcklrZm1HZFlyYkoz?=
 =?utf-8?B?cVM0Sm9FMGVBMXZqdDdyZWVhcWVRbkxQTDc0bjNBRWtISzF1OWZtaXNVTjBB?=
 =?utf-8?B?ekdrRUM3M2pzQ1d5M2VmdFZBbzg4K0tlUDNPUDdmdldWUXpFdnF1TlV5U3FZ?=
 =?utf-8?B?ZlhxdE5zSU5VSnRkeTVjOGhSN3F2L3Vwa1laOFJIQXZvQnJ5cThHdHVlYU5Y?=
 =?utf-8?B?Yjhzc1ovK2xSdHRFZ0JYdk1OODk3d2llZVJ5b2YrNWZ0U2w0NjdBYk5hRloy?=
 =?utf-8?B?YUJIb3JXQm1KMjZnemFOZkcrRENtcDNsOEhPRjdFM2UrRUN1aVR6aUFmb3pZ?=
 =?utf-8?B?MXRRZG42RUUvdHo4UjRKZ051dzNNOE9WclF0ejA0Zm1DWHlpTG8yMWwrbkVI?=
 =?utf-8?B?U2lOVHNOVFYrSGZwYkZIOWNQRVFSV2pyNG1CVVptQUdIMzVmdmRKNERFRUxF?=
 =?utf-8?B?aFQxa214bWEwRzJyNW90TURiclFBR1plMEdWSmZIR3RiNDBTMmRzWmlMa016?=
 =?utf-8?B?aWtTeEE0TG5LRTRSeFFqNVF6UkEyQ1o4SXFIVUZPdkd0L2dEMlhQZEN0Visr?=
 =?utf-8?B?TSs5Z2dUdzFNTEk0SENSNWFnU05XajJuU1dKeEVhYS95bzNkMTA2cXhsc0FC?=
 =?utf-8?B?cy8vaFNDb2o1dVNPdHdCM0EvZ1hGS3RtWERVOTcwMXM0cU9VTWkzaGJCMkR6?=
 =?utf-8?B?cm1JWldPbnpWUG1CN1VNRFM1aHlxZ2FQbXlidGtiWWR0OTJScURFRkRySGNB?=
 =?utf-8?B?ZFVrazlZWUtxZmloZDR1YTcxNWU2VjdqSUFCYzc5Z2NTa0xlYjIvOVdaaGMv?=
 =?utf-8?B?ZTNJSHZzNmI4QzFDelFPMEhhYlgwRy82WWtvRm1PcW5sTE1ubmxpOG9VMXE4?=
 =?utf-8?B?a2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WpX3a7HosDj5UdlK61rcWsqQC2u3Rz00NJ/WQMUIDUsgxe5RwiM72fOeMiouOqQSa/RcGnRc0YvT/yAtCzL2Wy7lXDjD/v7RgGnX7IFy7klAoRhDpetvuTXwWTPmFKj7Lesykny9vZtkjavyvEdN1tGIWJaXvuzeQwhoOxzV3URKvNSkNwvhO8YrEbY1bLgM7mHu1GwXcmrZByUsnnE/9WVoyUAvJ8M4xJ/iH/Tf6Xel+CjKEomAusagzR/iBI1WP4QPkOdivUm/mWurQMaBrcrjefHVt1YJtHRX/O+u/xRCvEvUzFADmh1gvJ/Ft2jh6DtraUPLgUrHjK+w2iPB8LPxfsADZjetaGcn87Z+tuKFDcTfgQtM20MckVU9VXwjepy5omSz6VIsknt0r0ly+DcpL/6wt9LLrX96jzoTvGfiPVgPY+XVPQ+Zpygiu0lgAYyziKMS0bVPYUsqrg44neBWPJlFy0ZHfBPTytoiJ5tfOGSZJONmnokTHap6zzTYnTmZkq7QOhZ2bSEin27V7c4VspnQTa63MGHIJpC/JxnNEdU73MYACg1APSPaxjNWmylVi5N+MBXtCxLe+uYwbnxWVQWYECkZsehZekiEV80=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c209bbfa-f049-42f0-2f36-08de27cad9f8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB7129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 00:22:12.8735
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2csG6fH7swuwhwiB676tU0Yklfrag0vAeM1w0mK6xn2ZhO0Elr5HoM3o16i00yLos16VJ0OFgp5FkWgGZOZJpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPFAE15A2261
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-19_07,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 spamscore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511200000
X-Proofpoint-GUID: ug8i98BHnGC6U9vsq_C6NEj82659A8kO
X-Authority-Analysis: v=2.4 cv=Z/jh3XRA c=1 sm=1 tr=0 ts=691e5f38 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=hxA2MIy6UfcDuIezLwsA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12099
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMSBTYWx0ZWRfX5azGKfY0blal
 1wlCdCwn+GyXvpOcdGQrgkzKOpePzwKmmIJfznR7IcHqdujc6fjkPJ2qr5AK8rN9Z4tHMjDqm//
 nsK7Gv2OKzS401Zi6cpyVGCQEvQUPxn9W5cUz7ytJOkiST48eiVGhvVkTa6SAUO3078ftWJ7gHU
 tZ2K/sg6aY5WdSDhzL5YsESJrJp6TqTkgHMH77kNdl+S/2RBeLkHE/pOyq1z1pgIuNhAVzdh6Wt
 4whRC/Pu9ZZyJ8AeD9W7aHtJokVpO3prhGGWLRAlpRp8+bmPpAWMyD39U5f7g/HGtc7MfQFT/4+
 /MS84KFjNLJiSnvG7r24QOHj6+hTlapsr0b1fXCsQRbTIuhx1UYKMqDouZAZhmG8OPEFWYOScw7
 YLqBGywLy+keKmHUhf4I+UJBdxchxvTirJ14RBlIzh/hB+GpWME=
X-Proofpoint-ORIG-GUID: ug8i98BHnGC6U9vsq_C6NEj82659A8kO

Hi Zhao,

On 11/19/25 3:06 AM, Zhao Liu wrote:
> Hi Dongli,
> 
>> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
>> index 3653f8953e..4fcade89bc 100644
>> --- a/target/i386/cpu.c
>> +++ b/target/i386/cpu.c
>> @@ -8360,6 +8360,10 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>>              !(env->hflags & HF_LMA_MASK)) {
>>              *edx &= ~CPUID_EXT2_SYSCALL;
>>          }
>> +
>> +        if (!cpu->enable_pmu) {
>> +            *ecx &= ~CPUID_EXT3_PERFCORE;
>> +        }
> 
> Learned the lessons from PDCM [*]:
> 
> [*] https://urldefense.com/v3/__https://lore.kernel.org/qemu-devel/20250923104136.133875-3-pbonzini@redhat.com/__;!!ACWV5N9M2RV99hQ!IGoeOCDjD7razBgwrJ-A9SjI1XIwq5kxmkPA5_NLOucYzMbsbCOQFe3jc7YyN0Ks1bNpP70F77klp0_--kV1$ 
> 
> Directly masking CPUID bit off is not a good idea... modifying the
> CPUID, even when fixing or adding dependencies, can easily break
> migration.
> 
> So a safe way is to add a compat option. And I think it would be better
> if patch 1 also has a compat option. A single compat option could cover
> patch 1 & 2.
> 
> I have these thoughts:
> 
> * For "-pmu" dependency, it can be checked as [*] did.
> * For normal feature bit dependency (patch 1), it seems possible to add
>   compat_prop condition in feature_dependencies[].
> 
> I attached a draft for discussion (which is on the top of the whole
> series).
> 
> Note, we are currently in the RC phase for v10.2, and the
> pc_compat_10_2[] array is not yet added, which will be added before the
> release of v10.2. Therefore, we have enough time for discussion I think.

Thank you very much for feedback!

It is very important to maintain live migration compatibility.

> 
> If you think it's fine, I'll post compat_prop support separately as an

I think it's fine. I don’t have a better idea. Please send the patch for further
discussion.

> RFC. The specific compat option can be left to this series.

Please let me know whether you would like to include Patch 2 on
"amd_perfmon_always_on" as part of the "compat_prop" patch, or if you'd prefer
that I re-create Patch 2 with your Suggested-by.

Either option works for me.


It seems the Patches 3 - 9 are not impacted by this Live Migration issue.
Perhaps they may be accepted (or as well as Patch 2 "amd_perfmon_always_on")
without "compat_prop" patch? They are independent with each other.

Another concern is Patch 3. Something unexpected may occur when live migrating
from a KVM host without KVM_PMU_CAP_DISABLE to one that has it enabled. The
migration will succeed, but the perceived perf/vPMU support could change.
Can we assume it is the user's responsibility to ensure compatibility between
KVM hosts when "-pmu" is specified?

> 
> Although wait for a while, in a way, it is lucky :) - there's an
> opportunity to avoid making mistakes for us.
> 

Thank you very much!

Dongli Zhang

