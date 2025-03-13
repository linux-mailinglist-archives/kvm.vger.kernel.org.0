Return-Path: <kvm+bounces-41001-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 40F8BA60235
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 21:15:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B344D7AF8F1
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 20:14:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4F651FE455;
	Thu, 13 Mar 2025 20:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="y9s/4fJi";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="PFKFePre"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF5271FDA86;
	Thu, 13 Mar 2025 20:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741896659; cv=fail; b=SwB7qCucv7X87SSYNv5mI4YjG+YiClbixZzLp8JW0gJwc8Eby4LTm0Npej0CT3QsDXMkkP1KNMP6kZf0pZQUr+OBg3BXVGCUsJjh0TBYJcRFtpLJ8Dkq4M23i8ui8xYy08+YIJj9iVxSKOYoVGFw++OnDJd92zC0foq8LynFi/0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741896659; c=relaxed/simple;
	bh=lqLd5v3SauxqxU5QEpUvPuOFCTFAhjDknUCwV55XK+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gk8U6JGrWTY3GkxsViLXbeJVyHp0c4LIg/3p7tUTAtuLalj7b4kp3TGWNYrOcTP4qjCv/0pHiQngZreamoUmMKZx9923T8uech1+yXAy7X3dbNbjY77jBgllgocm2CTvLWkTN0v+BEHJ0hHO/zV6pJglKUW+U23cs/0jExt56KE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=y9s/4fJi; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=PFKFePre; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52DGRKvu016613;
	Thu, 13 Mar 2025 13:10:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=BUUGo+tvUFuiziFovb0RuaPH9wVU9pcsmddoCaWaK
	l4=; b=y9s/4fJiDUK+3Ld8XqwIUhG+AJUHuHQeAsD9H5eq64iQciqPr9VHbCqMV
	GFZ0Tax+WK572FL+wBtx8wOVzAwn19wN/S0FvdtZOkeIkvAWZJ1iCg0pQPQtAweI
	z0io3wplPkZWZHA1OxX3FFOJOr4LJchSPQZDAaiMGzozqq/xuGTgN7so0TqvFHwh
	oOjhI00nJglOc2BTpOJQe4G8R1HNFbru9j5hHGiLwO0+tlurz8Uv4tNPorS0PB+q
	3Kw9q3ThzzGT6gKHVg2QsRIPtMEw1UPXnt8whMsZiDPN4jzmW+R6SKZRUxH/N56b
	GQkcqNS9IcwSZWtNy4A4kXpRLu4nA==
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 45au9ep6u7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Mar 2025 13:10:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WQoR+QWbFiFh739EADmmFt5L6YSYNxieP5ySM67taNISSc+Uss1peXMFzSkft7dB5VEgUU4FrKo++z+FK0Hy3pKTV0aTNEnaXgvAewdLetQtWjDmxfW0RjLcwOMUfLJm6zzMT3QXdHZbTIU8TCFySTlfiZl/46W+28g8D/G/K+7ohrXOVcUEaC9ots0+L01zpOyvPnTz6DXnwAqH1S5S7N0hJvJutxLTVD13C5sBvJ3cOQipHU+eWJWNopCmBKgQ7p10fZi8OAcP9J7vXOmodmHZBLb4kvNsWO3/RhWq84N3e5iE8Mf0/gVv4CqSp3v/CcdAM4KwRuPHnPDXFrYRQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BUUGo+tvUFuiziFovb0RuaPH9wVU9pcsmddoCaWaKl4=;
 b=CwKvzgSIFhuZpCZxQv+VVV8fZHjIfSwOY6gfQIolcgzkqz5bIQk9nAA1y4W9mv0HH6JW122jtH1eimvU4ykzLp4OMh/50hlkGZ6ZHVpb3YxvguMIy5IGvB1oqzAIgnJcxFOr4tV+9ygenFIs0cUakCrfPZYs214FI7a9Z33buA+uJwWSGhxR0L10EKk2XYagy/86CDL982ZPgdJrIUiC9a97eKI8cOh58xe3ZhEFapN8vu0A3X5pzTLOSnvbknByceYiXE35Ftz3V0J1/VVxLPxL6PEnKovJ8JAXi/31P8kbFMTBCcMQ2a39SfnqwY9P29/0VDMMBF9XRV9oekelpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BUUGo+tvUFuiziFovb0RuaPH9wVU9pcsmddoCaWaKl4=;
 b=PFKFePreI6hIvNn01ngDyVrKIGGqnbCpQSz1+RORJxWqnJDpV5VhxE3VI8udBIxaNCWhI6pdLAd4R8i0Y4v8WJI3X8b6xGmEqVVZKVuHtIHOXLWcYx/oFaAbpcsxeYN6i1UIF2MYNp+RN7FgplreDXKJelC6WP7hkr/gS+dCFzjpdtUZaj+42jyeo9sTsFMijCGavvDsmyjhkiLYLvwR3Ztpwq4s/gs/y6AGf0KcBdI91xyp+f3oG4dhABjcDb6ALDmRLv3GOQQvZugBalnu1MCpE8/MrPe86W2cPn4OvWZGpN8OoA3wCsR37RmXCRih+2/zJH9czP3R1mIQlrY+ZQ==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by SJ2PR02MB10313.namprd02.prod.outlook.com
 (2603:10b6:a03:56a::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.28; Thu, 13 Mar
 2025 20:10:36 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%4]) with mapi id 15.20.8534.028; Thu, 13 Mar 2025
 20:10:36 +0000
From: Jon Kohler <jon@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
        Jon Kohler <jon@nutanix.com>
Subject: [RFC PATCH 14/18] KVM: x86/mmu: Extend is_executable_pte to understand MBEC
Date: Thu, 13 Mar 2025 13:36:53 -0700
Message-ID: <20250313203702.575156-15-jon@nutanix.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250313203702.575156-1-jon@nutanix.com>
References: <20250313203702.575156-1-jon@nutanix.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PH8PR02CA0007.namprd02.prod.outlook.com
 (2603:10b6:510:2d0::18) To LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR02MB10287:EE_|SJ2PR02MB10313:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f560913-6595-4697-71e5-08dd626b1dfa
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|52116014|376014|38350700014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?d1JZNkRLMG1CdWJwVDBBTnNUaXM3bldXcXV4d2FGSHZHaDBDd2RkSlI3TW5P?=
 =?utf-8?B?Smp2a2ZwRTdxVVRaMWFDeVVCUFFFK0lKQXczNXJtWVFJSnFHdTk2eVNSRUZI?=
 =?utf-8?B?ZzJhemNRbUZvcy9RdDlWblY4dEtGbERKL3hHRFZLYjkvaGtZd1gwSkluN2Nl?=
 =?utf-8?B?WUcwemxkcXhJdHdRNDBSQnV1bTkwcjdzcm40R1cwTVFORWhicnpPSHpIUGVw?=
 =?utf-8?B?cVVmWUk1LzJDSGhHWTdrS2dwZnI2bjJ0cjdHQStPcy9kMXRDZDg1Z1ZxaURZ?=
 =?utf-8?B?TjJaN2xpbUo3MmFYL2xQR2pVc3RpY29WRTJvQ2ZDWTRUdGc3RTlCejFYSmo4?=
 =?utf-8?B?cU83aXUrYXBuaW91Qm1jQ3loNFk1RytxdU1EZEY0UkdsWElpSU5ja2JkMEVI?=
 =?utf-8?B?SXRJOE9EcC9MUW92VjI2S0RJUUlDTUdhQThXc1JSZXJCWitoRHo0bk43NGhU?=
 =?utf-8?B?SVNzMUpOM2V3SVAvVjFPSnRhRDJWMGQ4aTJ4SXkySGNqU0JZMFc1TnUxb29T?=
 =?utf-8?B?dXRGZFRSRTBRTXpHN2JOdWoxckRVclpQVDVyTVhEelVBMVM4RFZYdU9ZcDNG?=
 =?utf-8?B?NXVadlROTUh1TGE2OS9kKzJrbkNHQ0JVcEdnbk9sdThBSHNEMnZKTWRLWWdR?=
 =?utf-8?B?UnYrclNlOWZsMDNSNnRYbTVPVFMyQ2hSTCtwMXJYZlVrYkxGZEtUek1jcFls?=
 =?utf-8?B?TUNKRjhtZzVyaDc5c1hQWFh2TWJ3WW94c2JSeTVzN1NZM2YxZm1CdHFpK1lG?=
 =?utf-8?B?Mzhjcy9hdjZqRkNEQWVoeTROR1dZL2p3MjhWSzZZb1VMQW5QK3h2US9PNHEv?=
 =?utf-8?B?a2owWGdSQ25RQ1lGclRrR1hGVFN2cHFINHBlSVM4QjVQVStIZXBmem9OeE44?=
 =?utf-8?B?L1dXV1N3OHd5c2p0c0IwcVlQREMvbHB3TW1vNlB5Q2s4bndZd2JITDl1T0VP?=
 =?utf-8?B?c2hNWjBMV3pIRGNYakFhd0Y4VzRRcVA3U3dxdkptWEVhQm1md3doT3haTHZ5?=
 =?utf-8?B?WWZnNHJBOHVhOXlVS1B1ZDNPNmVDVFlYakZ2KytkOVBpS3A4b29CZTBnWk5a?=
 =?utf-8?B?S2RFdFlkTldab3lBeXkxYUJBN3NzVEMwVmk2Znh6UkNXYzNnTHphTy9uT01w?=
 =?utf-8?B?NHBITUNMT1hVSUgwZlVGVUxHM1dTVkdjcStHRTByN1hlL0pCRXAzNEU2elA3?=
 =?utf-8?B?blFrK2xjbGE1ZjdCSjRINUlqNGU2RXVXUzJlOWgwT1ErMzlMTE1XZDB2Tkp3?=
 =?utf-8?B?RTVNSmZDWFhJQ25vWHhxV0pUR0pxTytFVjhsNkI2UXJCUjVVb0Z1MTdrbnQx?=
 =?utf-8?B?aHllclZmcFNaQm51Q01RcWRVMHdEazg3dVBLeTVHL3NDNk5wWGR2eDhjZnU3?=
 =?utf-8?B?eU5UbE9KT1FXazVDQlZVSlZMS1hJOGN5TldYOC9rWFNRQ2tTR2VBMUd4RS8y?=
 =?utf-8?B?QTVHOHNxMmM4VEkxKzdzVUtWdWhHeEVwOFFTUEpPaDQ0QXFHa0QxbU9VaU91?=
 =?utf-8?B?eDQwd3dhdTNnd3dtRXR0MW01VkU4Qm1uMlhyU3l4c2VHdEpzaDBKYnY5bkov?=
 =?utf-8?B?TnR3ZXFWUDV6dk9IQTJER280L0ZFb3BNc1phYnpDaDB1OTVaRGQ4OC9YbUMr?=
 =?utf-8?B?UWxlTjZVeW1NL3pCYklBR2JyR25JRE8yd3J6cnZuZUZpZFlMQjFGWndqSm5j?=
 =?utf-8?B?SEVnamQ0aDlwVFFwYlRxZkU5Y1FXR01pRVE5TFI1QjFDeUJ2QzFCRkIxMjhK?=
 =?utf-8?B?ZHB3dHhLVHJWUVgzTWJucVh2bHpTTGU3aHpDQmVydlZYbGZGTkFIVUZRWTdi?=
 =?utf-8?B?dklaaTB5K0tQQVZXa0w3eThjdms0cDJ3RFNNNjNBUzhjV2pha2YraDB2WnVQ?=
 =?utf-8?B?MzhZemFoYTIxR0NMMVZQOVJzVVFoVWVRR3BmSlg5Z1pQU1hjZkdkZld4clV5?=
 =?utf-8?B?cnFsY3YrR3FUdDBDK0tMVkliR0R6dGMzdmg4VVNjblRFSndGT1VQQlNJQWdU?=
 =?utf-8?B?QnZ6QXRXOS9RPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(52116014)(376014)(38350700014)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c2N4SmdJQUlwOERWUmkyQ3hNSjYrMldOUkJ2YUdDMkdTQnYvdjg4NkVodXA4?=
 =?utf-8?B?UE9YTlkzWU1Xc1JKR2g4a2Ixbkl1eGZ1MzYxVnNGbWprSmM0a0ROcEpCM2FV?=
 =?utf-8?B?R1dwenV5MzRGVnh5M3JMS2s0QWczdk4vdi9MbHZsV2Z4WnZvd04wL2phMVlU?=
 =?utf-8?B?UUpZWDB2ckMxeXFzMklCdENZVGJrQmJwRFEvaFhVUk5xcVFaaEY0cnZVdmgy?=
 =?utf-8?B?UFdMT0RCckhqYlNuYTNYOHBsb0VVYmdrU2hnVGVMam5vOGttaGw2aFYrSkxR?=
 =?utf-8?B?elJhd0NiT1FtejJvUE8waUtha25RYlJKY3oyOVlpNVZyQTMrNGVkUi91TUNM?=
 =?utf-8?B?dXdpK1V1azgrZm5CVkVOdkljOEVQbnpLdnJyYWtscjVsaGd1cDVPMFlMQ0N3?=
 =?utf-8?B?dWduWFdqbEEvWTlaZTczc1dDck1YQURRakFhdnd5NWxFN3J1Z1pCbmF6aWdK?=
 =?utf-8?B?TEt0YUpBUlpxTUZGcWptNmc4TVY3dW9YRVliQUowWndFRHRxa2NReTJMVDRR?=
 =?utf-8?B?akJvQmNvdFMrSytxdFMvbTJyTDBtVnJ3VjVNaHgvb1F3RFJVRHlhK1RaV3Rv?=
 =?utf-8?B?ZUxwRlRaSlczZjg0a2RJdWQwMlUzNEtNaitTM005bHprUHFwcTEwWEFrM0Vy?=
 =?utf-8?B?SzZVQ2N0NisrRXdWbmVlZ1FrRVArVkFpQktKNnJsdzZIYjVxZ0JpWkc4LzNl?=
 =?utf-8?B?Sk9zeGhEVnNTV05ZN3N5SjdhNnNTOTc5d3NzbVg0THpZQ3pUSzNxWDBmeTJW?=
 =?utf-8?B?ZTFEMjlRNGhoUVdEN0NkaXV2dlVnd2tSQ3FYbzdHWXkvOGo0Y2hST0FMREZw?=
 =?utf-8?B?U3lFbDZaZml6Q1pOcXlCQnVvWmdUVkpmVDU1alF1ZUg5dmcvRlhFdzRBZ2li?=
 =?utf-8?B?c0Nsd25RNW5jYVJBM2VhSWRKdURVM2hIbzgyNVJTUUlxOEx2MU9lc0NqdVFm?=
 =?utf-8?B?dUw5bm5QOHM4L1ZKL0E3VWxOb3ZkOEthNWg3RThNVExGbGR3ZnhQN3hFSmpp?=
 =?utf-8?B?NUhzWTk0MlVFblBubTVUUG5EbU93MElhbHBLNXJ0b1lxNkRkbTd0R0QzZDdj?=
 =?utf-8?B?UDJqT3RmUlk5U0J6OHdYMGtzL2t5UnVxV0lNeU1sd0NjbHJFaSt1aVVrNzA4?=
 =?utf-8?B?SW9tRjBVYVA2c21henk5WnZySWM4cWgvaFNlQnhYbytoZ1lZakQxVm1Ubktm?=
 =?utf-8?B?QnpiTjQ3V0FiclhxTDZWOVdsNjlwbkg3dXA1REpPa3VqaUJha29WVkwxRjdZ?=
 =?utf-8?B?Y292YjhrVGw4VEk1OWZabURTYit2bXo2aVhCSDBoZitsamhzOFFYb2gydlAw?=
 =?utf-8?B?elZOOTJieE45blJXU3ppL0tqNmlxYWJOV3BqN0dlUDY2eVA4N3FjcHJTSWRE?=
 =?utf-8?B?VmhTT24xRFNoQWkxWlJQSnRJZjJZeWhWblp2cW5KSFN2NzY2WjFkZHBCQ0kw?=
 =?utf-8?B?bU90YmZxbm51UUprdXJMMTRuMDBmTE80a2pSYjEzM0h6TDk4QUJ0NmxmdGVH?=
 =?utf-8?B?NFREb202Qll3NW4wVHdDNzJzZmxRYTRZTVAzZ2NPY3dZdHowWnVhUnA4UUlV?=
 =?utf-8?B?bHY5ZXVjWVZpVVBxYmNUMjZ5OGUxWG1qQUxaaVliNzhYM0xtN20xZktHVHBW?=
 =?utf-8?B?dmh1UEpnbHpLdWk3cTJjMmFRdGlRUXV6R3QwZW1YNDVFUEhuNzVsM280ZjRC?=
 =?utf-8?B?RGhLUUNxd3M2SC83UVd3WElJeGVNMTNvanpzd08vT2g1eXp4aUEzM3hCTzNx?=
 =?utf-8?B?Y3F4RmVBUkxwNkJGRVJwNzErdEFIRGNHOVFuNDdqdk9Xam9EQmFuR2lTU1B0?=
 =?utf-8?B?a1V5N2JXY0xmSVF4Rkc2b21Nalo4WWswU0pDVzBRaVhDR3FHNzRBK2VVSXNw?=
 =?utf-8?B?SXhXU1FCeXFyYTZmeHJMRm1CQTBqbkhXOUlhY2R2cko0eGRLTFpyTXVIcWx1?=
 =?utf-8?B?aWtmVHRtR0E0U2twSDNqOHFHdGR6MVB4NUZRZGxRcDBUYUh5amRZM0JMeEZu?=
 =?utf-8?B?ZWk3NmZIb2ZXSUZidGwxRldmbk0zV3F4SWsrVCtMYU4zUXpLcjZaL0lJT3pV?=
 =?utf-8?B?ekxxOStGaTJINGJrV2pNT1RsSWc5dGVjcWF6WDBDNFFaSUxyb000WTdSSlFh?=
 =?utf-8?B?a2RUdjgyRGhyZ1E2Z3U3TTFDTzNNNTQ0YWZiVEZUQWpaRnBLeUZleEpHekNx?=
 =?utf-8?B?S1E9PQ==?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f560913-6595-4697-71e5-08dd626b1dfa
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2025 20:10:36.1730
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GTrTeYrNKZr1LbIITDgb79GYpaTLSj981ji7OpKhdhIvt9cQWQLwR3Mnzbph+WQwIkr1X4QyrqO+w9ziMvVBha8kVFYgCK+cL57A2Na/Oyo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR02MB10313
X-Authority-Analysis: v=2.4 cv=NL3V+16g c=1 sm=1 tr=0 ts=67d33bbe cx=c_pps a=tyvwN2z/Y66O58r8mq/nTQ==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Vs1iUdzkB0EA:10 a=H5OGdu5hBBwA:10 a=0kUYKlekyDsA:10 a=edGIuiaXAAAA:8 a=64Cc0HZtAAAA:8 a=d9BMwJKdUS1y6B2Gi2EA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=4kyDAASA-Eebq_PzFVE6:22
X-Proofpoint-GUID: FAx-jJun03di8Cwpt8mfNjxlEkTk4OJi
X-Proofpoint-ORIG-GUID: FAx-jJun03di8Cwpt8mfNjxlEkTk4OJi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-13_09,2025-03-13_01,2024-11-22_01
X-Proofpoint-Spam-Reason: safe

From: Mickaël Salaün <mic@digikod.net>

Extend is_executable_pte to understand user vs kernel executable
pages and plumb in kvm_vcpu into kvm_mmu_set_spte so that tracepoints
can tell the right execute permissions.

Signed-off-by: Mickaël Salaün <mic@digikod.net>
Co-developed-by: Jon Kohler <jon@nutanix.com>
Signed-off-by: Jon Kohler <jon@nutanix.com>

---
 arch/x86/kvm/mmu/mmu.c      | 11 ++++++-----
 arch/x86/kvm/mmu/mmutrace.h | 15 +++++++++------
 arch/x86/kvm/mmu/spte.h     | 15 +++++++++++++--
 arch/x86/kvm/mmu/tdp_mmu.c  |  2 +-
 4 files changed, 29 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 791413b93589..5127520f01d2 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2951,7 +2951,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 		ret = RET_PF_SPURIOUS;
 	} else {
 		flush |= mmu_spte_update(sptep, spte);
-		trace_kvm_mmu_set_spte(level, gfn, sptep);
+		trace_kvm_mmu_set_spte(vcpu, level, gfn, sptep);
 	}
 
 	if (wrprot && write_fault)
@@ -3430,10 +3430,11 @@ static bool fast_pf_fix_direct_spte(struct kvm_vcpu *vcpu,
 	return true;
 }
 
-static bool is_access_allowed(struct kvm_page_fault *fault, u64 spte)
+static bool is_access_allowed(struct kvm_page_fault *fault, u64 spte,
+			      struct kvm_vcpu *vcpu)
 {
 	if (fault->exec)
-		return is_executable_pte(spte);
+		return is_executable_pte(spte, !fault->user, vcpu);
 
 	if (fault->write)
 		return is_writable_pte(spte);
@@ -3514,7 +3515,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		 * Need not check the access of upper level table entries since
 		 * they are always ACC_ALL.
 		 */
-		if (is_access_allowed(fault, spte)) {
+		if (is_access_allowed(fault, spte, vcpu)) {
 			ret = RET_PF_SPURIOUS;
 			break;
 		}
@@ -3561,7 +3562,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 
 		/* Verify that the fault can be handled in the fast path */
 		if (new_spte == spte ||
-		    !is_access_allowed(fault, new_spte))
+		    !is_access_allowed(fault, new_spte, vcpu))
 			break;
 
 		/*
diff --git a/arch/x86/kvm/mmu/mmutrace.h b/arch/x86/kvm/mmu/mmutrace.h
index 2511fe64ca01..1067fb7ecd55 100644
--- a/arch/x86/kvm/mmu/mmutrace.h
+++ b/arch/x86/kvm/mmu/mmutrace.h
@@ -339,8 +339,8 @@ TRACE_EVENT(
 
 TRACE_EVENT(
 	kvm_mmu_set_spte,
-	TP_PROTO(int level, gfn_t gfn, u64 *sptep),
-	TP_ARGS(level, gfn, sptep),
+	TP_PROTO(struct kvm_vcpu *vcpu, int level, gfn_t gfn, u64 *sptep),
+	TP_ARGS(vcpu, level, gfn, sptep),
 
 	TP_STRUCT__entry(
 		__field(u64, gfn)
@@ -349,7 +349,8 @@ TRACE_EVENT(
 		__field(u8, level)
 		/* These depend on page entry type, so compute them now.  */
 		__field(bool, r)
-		__field(bool, x)
+		__field(bool, kx)
+		__field(bool, ux)
 		__field(signed char, u)
 	),
 
@@ -359,15 +360,17 @@ TRACE_EVENT(
 		__entry->sptep = virt_to_phys(sptep);
 		__entry->level = level;
 		__entry->r = shadow_present_mask || (__entry->spte & PT_PRESENT_MASK);
-		__entry->x = is_executable_pte(__entry->spte);
+		__entry->kx = is_executable_pte(__entry->spte, true, vcpu);
+		__entry->ux = is_executable_pte(__entry->spte, false, vcpu);
 		__entry->u = shadow_user_mask ? !!(__entry->spte & shadow_user_mask) : -1;
 	),
 
-	TP_printk("gfn %llx spte %llx (%s%s%s%s) level %d at %llx",
+	TP_printk("gfn %llx spte %llx (%s%s%s%s%s) level %d at %llx",
 		  __entry->gfn, __entry->spte,
 		  __entry->r ? "r" : "-",
 		  __entry->spte & PT_WRITABLE_MASK ? "w" : "-",
-		  __entry->x ? "x" : "-",
+		  __entry->kx ? "X" : "-",
+		  __entry->ux ? "x" : "-",
 		  __entry->u == -1 ? "" : (__entry->u ? "u" : "-"),
 		  __entry->level, __entry->sptep
 	)
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 1f7b388a56aa..fd7e29a0a567 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -346,9 +346,20 @@ static inline bool is_last_spte(u64 pte, int level)
 	return (level == PG_LEVEL_4K) || is_large_pte(pte);
 }
 
-static inline bool is_executable_pte(u64 spte)
+static inline bool is_executable_pte(u64 spte, bool for_kernel_mode,
+				     struct kvm_vcpu *vcpu)
 {
-	return (spte & (shadow_x_mask | shadow_nx_mask)) == shadow_x_mask;
+	u64 x_mask = shadow_x_mask;
+
+	if (vcpu->arch.pt_guest_exec_control) {
+		x_mask |= shadow_ux_mask;
+		if (for_kernel_mode)
+			x_mask &= ~VMX_EPT_USER_EXECUTABLE_MASK;
+		else
+			x_mask &= ~VMX_EPT_EXECUTABLE_MASK;
+	}
+
+	return (spte & (x_mask | shadow_nx_mask)) == x_mask;
 }
 
 static inline kvm_pfn_t spte_to_pfn(u64 pte)
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 3b996c1fdaab..6a799ab42687 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1056,7 +1056,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 				     new_spte);
 		ret = RET_PF_EMULATE;
 	} else {
-		trace_kvm_mmu_set_spte(iter->level, iter->gfn,
+		trace_kvm_mmu_set_spte(vcpu, iter->level, iter->gfn,
 				       rcu_dereference(iter->sptep));
 	}
 
-- 
2.43.0


