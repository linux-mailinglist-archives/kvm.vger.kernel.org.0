Return-Path: <kvm+bounces-40990-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 80AF4A60215
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 21:12:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 262FA7A69B3
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 20:11:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7D961F758F;
	Thu, 13 Mar 2025 20:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="HfAUgFUy";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="f0IdOpHT"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E1B1F4739;
	Thu, 13 Mar 2025 20:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741896640; cv=fail; b=YfAnhQrVTs7DlfSkM2GBoDPOg7bIsgn/Gav9gX3vt0e8JWyziTer7BU1bXXv44WxGLwck152DhraoPgGLC3F/vnpyo6wtDOrObmC43dKY2lEqNgXwJoo/g/sJXmv/0w4/l1dYYc8lVDaikmoKAw77TCi7QNYbH3luhuuamioCnY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741896640; c=relaxed/simple;
	bh=ZXsol5LUDHQVpoZ/tg1QbTpg3HhlIRhRv5L4cdSbyLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NZF/KR3xBOS2VWR+Vnr/6/8gMp9YzJgP6jSpliHfD4Mg1YqxPkP3y0HFjwEKyVjlKAOtHtef3fdEks9sDFLAEygMuDGV/QiSmYlNcOkI72R1mrk5A7jx30DrZ25hUDAYxqF+EWThZAfRW15GUOYS5JkJi8jDXcy4c+DCyC0gm+8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=HfAUgFUy; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=f0IdOpHT; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52DFGSCF016569;
	Thu, 13 Mar 2025 13:10:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=cVGV/cYLTAYqHVOGX4jqc4sOgAOA4+xNP5Zry7tf8
	HA=; b=HfAUgFUy0sjteKw4nEAGIE9RLOdzv+m02zWc5AlUIcKVxdO4sYsGYGonx
	VOujRc65WsIHgFcCK0UPrsoENpi2rsLWpbhlHjBXSWYOodoAAs9kE70FeQApndM/
	ffjagmlT+zY2jy1f/N/dcCcncifvI5Qv9H63o2UeP/3TDTB3PYDqdZu60pTm1T55
	gYAt+Y3BlQebEGJ///VCs0LgZHTtdi3N6lBSU1tZin4kyDtVwUaEVmzmkTG5Fm5M
	Rh9yNiH4MwE/BmMxUMTOJashV2A1j2R/AMCoAC6xEdKNsbVt21NUGOHiJSLeJVC2
	PccA6XWXtEYXX8BeSFg33WEU8l+Nw==
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazlp17010002.outbound.protection.outlook.com [40.93.13.2])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 45au9ep6tf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Mar 2025 13:10:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Lx/Bey/Ffv/NTbBB8V6wFy+rCe0go/y4taSrisx88JFh9c/zfMB9JBs+mKrh0eJNCTGgWo3HTpWXd4JU6+Q/jbG6312oUo5FgiVV9kZ/yqwG/ThiYuDAMR7ruhK5gcMJuwTPhRAj0etb5w5jMTNhhCupE5Amx5L+n5ghOj+rh5orG6usaDzC/UJh8oIQem5Thk51hMsbr+tlW0m/udhD6Q8AMjQ4yUEhpBBYFWp0YTty0gFj5y0hp6eYqWvPlQYxg2LRsLipeSyYmlIQYvIWfQW/2B8iCvFs/oZX5NR53IUVE+IZunCwcsUAR9YyLyiQiZBBfy/lmm1z3ZcK9ind+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cVGV/cYLTAYqHVOGX4jqc4sOgAOA4+xNP5Zry7tf8HA=;
 b=VgZcQnWHFFYuF7DAN1vYoT/UeergM/pmludptk6rbN7awo20NFdU1+GUJg5jKa2zzadSFyJBhO73F+RboTHh9hkunzxpTt0cZmxBZUkHzhgkgvyCg2P642Dcuy6HkVEuxpqi26zY8Y4hV1fJY4Kp0h7XdJJUPcqCNUT1EmA+z8l5y4Au1ldeJ6B5xf/+j8fKiLvbYdug1J1KYjJpVVjLmHp+L9NIUeaDsOp/nbxdibfyXAhAYNYY/wsIrmAsXneNkI0wzpZj4TeSZdQ59Zia28IWXl2rGjJZR0rsqQLAV8WgO4t0IxXeEPqwCvFO3jcL0Kih1PTdPjnXdkM5/sA7lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cVGV/cYLTAYqHVOGX4jqc4sOgAOA4+xNP5Zry7tf8HA=;
 b=f0IdOpHTiTtNJ5hUVZJ9nexiTY5s+EfnR1opvqfIbQV6kelXo7BU2auOmmHiH2yXrdk8LezLkSxAE7bEHVB9c9rBaN99fDyG7zIS6oGL6vzaKoCaPO3GWHlaWNpi/H6XIlbEaq5qyxESv9EHbFjIlnCiJphgP41rob36tmeq0Sis9nbb9klorIeofxX20oukphzoMxxSBd2UaH5foM4x6QQOgLxNY+9LJFIRcnqfH5QtBzk4KE/fhScb281Z0/3lcy+sNiC3BN2k0jvdiV6C9pIMWrUuj4fCqGo+xRmfWCWhKHL7VU7I7+Y8nTNsJ1+OfQdkSyZJLBwYfn95tVM6bA==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by PH0PR02MB9384.namprd02.prod.outlook.com
 (2603:10b6:510:280::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.28; Thu, 13 Mar
 2025 20:10:17 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%4]) with mapi id 15.20.8534.028; Thu, 13 Mar 2025
 20:10:17 +0000
From: Jon Kohler <jon@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
        Jon Kohler <jon@nutanix.com>
Subject: [RFC PATCH 07/18] KVM: VMX: Define VMX_EPT_USER_EXECUTABLE_MASK
Date: Thu, 13 Mar 2025 13:36:46 -0700
Message-ID: <20250313203702.575156-8-jon@nutanix.com>
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
X-MS-TrafficTypeDiagnostic: LV8PR02MB10287:EE_|PH0PR02MB9384:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c575bfe-cd7d-4925-e8cb-08dd626b12b3
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|1800799024|376014|7416014|366016|921020|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aE9wWi9DNTJIR0lRWkgzVGZYdU9XUU9XNW9EYllyS0dPdWZMeHp6SVpaNjY5?=
 =?utf-8?B?OUxHbkgzQzhEUzcxbE8vVHIyQmJYRlhqZFpDWFBwVHZJTUhwQkRrSFFjaWI3?=
 =?utf-8?B?TFc2clpTK3Z5YjBkTktwVHpMN1paN2tLU1pSeVJ2YnFtK3hGL3d0U0JERGJX?=
 =?utf-8?B?R3dTYVJYUzdKZjYzNk40aytwOEVRMURvQXZmQ0t4NG5aYnpIZCs2YVpzUlJK?=
 =?utf-8?B?aXhXdThIWTZKNnpvcUl1cGp0am9ZRkRUWGpaUTZPRGJZSUxPZ0ZJbENGL3Zq?=
 =?utf-8?B?T1FlV3JRb1B0ZWJ4ZU14NXVLUzdnRyttdlRoYzVWYjl0VnNvWmJmaHorUndR?=
 =?utf-8?B?VmJiK0FnYWRFOG9PTW10OVhvRDEzU1FvaDFyekkyeWpCb2RVcFYxdGRycTd3?=
 =?utf-8?B?Zk5zbDJ5YmJPeHBCNk9HZ1l2T1MzTGZDT05WTm5NQlRWOEZ1R0d3NEJYaDI5?=
 =?utf-8?B?VHo1OS9KQzdiU0JMdkJFN0FtcmI0a21TSnZVQlJJdDgva0JobGc2V29EeXNC?=
 =?utf-8?B?cnEwTWkwMG04UWovWmFKTDFWWFVuanNERytCWUpWSStDMzNKTFVLcEhYWmtB?=
 =?utf-8?B?UmFWUFJURXZnc1hSQnYrb3BpbzcrWnI1VURwMnJZMHp1TzdmU3orL3FBRUhm?=
 =?utf-8?B?WVRUSXowb1AvaFN5Y282UzRLK2dKTEIyMzJEOWNNbTQ3dG9NT0F3YWw2V3I3?=
 =?utf-8?B?WFdzZE56VittT3JQdXRwUk9mSnF6YTlRUThxTURDYklPTDdJdGRLQUw1cVpR?=
 =?utf-8?B?bjB4MGZOb1ZLVHZLV0ZxL2R5MExyQWJuWVo3TmZPMWtwS2hYYVd2NFl0QjBI?=
 =?utf-8?B?M2REM2Erc05uRmJZTVRkSTZ0bUxWWU9UNHFUT3dPL09RZ2pUVDFmd1crUkFi?=
 =?utf-8?B?ZVc3QTJkRWRzR0E4VXV0Nlg0Y2w2ZTB5YWh1K3NrS1Q2Tm11LzkvYUM4M0xR?=
 =?utf-8?B?cnovdEFsSUJ0NEg0YjBUYWFzSWo2VFovbUREYWFKd2Q1aitoQzZnVzZXczJZ?=
 =?utf-8?B?U1VvbjBQaE5xNU1nNW51M0JHL2ZVdDFSUTdRMlJVK25hZ1Y4dlZyTnZhUUNR?=
 =?utf-8?B?SFpXL2tkRWFZcW93N3BicEpMWlFDZkNmeXZBRDdvRnJzbHBkY1pTVW00U25M?=
 =?utf-8?B?RzM1WDFWbC8yTC85dnE4RkNkd0MyWkZFdlRjdWdRQUhybWswL2xaMCtMM1l6?=
 =?utf-8?B?NytWajkzTi9NUGRNcUtGejJZeXB6cDZMWnFBQkpNcDU2a2ZJWk8vVnh6TEdh?=
 =?utf-8?B?bGk1VWZBMTQ0WHo0Z09FdUdWeHJNU04xL0FqZDVhTVF3UjNtdmYrU2xydkJp?=
 =?utf-8?B?bGd6c0d4cTRxWTgybGs1aGNiWmRzR0w1VUtWc0dvc0hNUkI1dEtIUXJGWlho?=
 =?utf-8?B?VjRWU0gvb0FNKy96dU1hRVhxditqU2NKdDBhK01WQ29adlVQeE9FYjBJV0RF?=
 =?utf-8?B?d0t1dWc1MzE5MUY3Qnd5SWJRbnFVWjlJUFl3VkVXTlFIWXI0eVlZRWdoQTBu?=
 =?utf-8?B?UjFMNE1FY21RNmExOVVWMFBueUZQMUNlRk11VzFGZDJUbG1wSWdTcGZoN2pI?=
 =?utf-8?B?VTFJSWZlWGQzenZRekdGMGZNbklDd004Mld0cDN5b1ZhSzYrKzdxWUc0Sk5I?=
 =?utf-8?B?blE0SmVudzU5NURQNUFGaHBsTmU0NzJJVnZEYzRtanZGTFYycTg1TFdmZmdC?=
 =?utf-8?B?eFNrVllRRGNtb0lkQUtoTklnN0lZS0xzOUtaeUFGVmszSjFUNE80TlJYWE1L?=
 =?utf-8?B?QzBHaDEvR3lDdFErazk4M0h2RXp1dnYvNThGckcxRGpNMlZBS0lhdk1vaHg3?=
 =?utf-8?B?cVArZkpYT0pHREgwWGZObytTS2pjSDVUNmxkY0RaMm9TNmxJSitocll5ajl5?=
 =?utf-8?B?ZWVxb2V3TS9QdFR2MUQ1REJQNGEyaG85THNUSVNPMU9jMkNoUXVDWnBPam1s?=
 =?utf-8?B?STZuRzhaYTV4Z1VqU0xFSkFUZU5wVFAvVFVpSTc2ZVp6aitIQW9nSW5ueFFa?=
 =?utf-8?B?Mk5GTlE1WG9RPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(1800799024)(376014)(7416014)(366016)(921020)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MXJlVU02V1cxNzdFYXJLV3R6dHRRQmIxenMyWnJWc0J5Mk94Mk9zV0t1dGx0?=
 =?utf-8?B?NnZFV1BWdnQ2YndtQ0tUTWpEdTA2Q2xMQitqZXFzOGpmV2VSYTh3aklqWitR?=
 =?utf-8?B?MHlFVlZBMk4rSWliNzlrYStWRXNlY2EzUUdIZzZSU3RQb3o3VmZvS2d1T3RB?=
 =?utf-8?B?emRmMnFLL2g4S3kzdFhIOUhGMzJkbmhwV2RVdXo5T0pEc2RRakMyLzJUazNC?=
 =?utf-8?B?ZzZNQ2pFaks2R29Scm03M3ErYmpnMWU1c3dua1ZhYkpFVVFydHA5UnFxelB2?=
 =?utf-8?B?SUVTaUREV01OWUMvRkZ6Z1oyL0tuTlRvODZlMUlISXZINmprcW43d2NMejYr?=
 =?utf-8?B?RVc1RDFnVE16VFY5TFFQYncwT0RsMFVaUXJLUU93VTltZ1N1dG0zR2RLZThL?=
 =?utf-8?B?aUhBb0VQekFYTEdIalZQVE9FbU54dU5WN3pGK2Vtd25UNXlvUGlWaEY1anh3?=
 =?utf-8?B?VWp2YWJHVG9VcThxeGtWU2s1ekYrWG5SdVpyUC9jR3d2MnV5TWV2bWNMQmxY?=
 =?utf-8?B?TXNqZXpmT3BkMUtrQmhHSUFYVEl5VmNGekxNVjIzRTNKVWp0alYxbUxKd3lT?=
 =?utf-8?B?RkpVc1BHcXoxNU5zMmxBcjg4d3NkRG8yN3kyZEVmV3R1NEFtTmZIWmxOVzhB?=
 =?utf-8?B?ZnBZdVlRTDFyY2g3ck1TMm94NUx3SHBHaEdwVEhWS1dLbGpUSzMxb0hGTnB6?=
 =?utf-8?B?eURUd01xcDlSMDZwbmJ0Wm90Vkk3WTl6OGkxRmxwM0RpTlpMYllXcXBrWFZy?=
 =?utf-8?B?bFJyUm9XZEY3TmZTeU1BODZzNmkvb0ZMQWZPT1NjMkF2dC9UVUwvM2J2TFQy?=
 =?utf-8?B?WVFLZGNZNElBNjJaTUJSZ1RsRXpucXlFZEVESHJkTE92dUgzSkVvanFsRVBt?=
 =?utf-8?B?Z1JFRGZUY2pWOXhvTEh6a1VYbHJwd0RYL1BTYkRoWWk0d2tIWElDOHlNQ2p2?=
 =?utf-8?B?clNnVjdYNDJ4dU8vVmhKTFJJdTRpcnROd3hITzF0WFZKbFY0QWtzVndjT2Y0?=
 =?utf-8?B?bFJLbnVCSVcvY0dYa0FaZTV6M3JJR0pmY1hLUk9VK2pqNWpxTGRQWGZ5SjRp?=
 =?utf-8?B?VUlSNlp1RmZaZzhHMVZzYVQxV2c2OUNUUXlqU1RXSVZmUTMxdmJCb1o1a0dl?=
 =?utf-8?B?Z1FBUXlkWXpyVTh6UmFiK3EvY1hPN2dTeXBURlNWaHhoQ01BZzYycER1S3ph?=
 =?utf-8?B?Z1ZXckJrYjdHcWVpN0pmWml6YWZjemNVaDFXN0daTXpIZFVvVXVwMit2R080?=
 =?utf-8?B?QnVxK2RvR1VRYkpENHM3ZXdxWnBoSnYxcmlydUlIZkFaQ21uWE91aEt6VlNl?=
 =?utf-8?B?N3Y0TXlFam54Z2ZudmdxYmhUbXRjUnlVdUFydFVRT2xJMENrWWtBbWhad3dW?=
 =?utf-8?B?S0Fma2VjRFI5ZDR2SjZoaG9SeHgydmJSc1hNb2R5QnpwWHlwV0tCTzJNYU9p?=
 =?utf-8?B?U0tOdXFseDc5clVucEJYZk1OK0dyaDBpandnOEJITkJtNTlZSkUxdUlvWEtW?=
 =?utf-8?B?QnlaSHVXbWNyTFJBNkJUa3RHVG1JTU9Lamdrc05NSFpDL0QyZEpORERSNGp0?=
 =?utf-8?B?dXFyMjhXc3dNMWwrd3ArL2R5YlNxQWh6Vmt4UmRxOGdBTUpBRkpUVEVicHl1?=
 =?utf-8?B?cHprbVdiUDJhdzNXckFwOG5TUkl2V3ZicGFhRHp4eTU3UVlxSHB4eVYrbEFC?=
 =?utf-8?B?VzZ5N0RIM0NJeWlkQ2tranZxeldRREhSbGlrUlg0aHArQksrZ3F2UE5TS0ZU?=
 =?utf-8?B?VXVrK2NPUDViWjRpaE44WDMvUHZzVW5FV1FGYk5kNFhDWENIb1hYNG85UldS?=
 =?utf-8?B?R1F3azZ4SCs5NzZzSFczSWZtb2ZyWnJPS21lYjdHSGdJY3pyTm1jSTBFaHJD?=
 =?utf-8?B?ZWhUTmhZZzdCVFFZSEw2MWpVNW4yNzZXd0hiaEtGNmRYeXNTR1pXbC9wMjBU?=
 =?utf-8?B?V0VIWWYyYjlwZHMxS1lDdGQ2ZnVBNlBKZ3JyZUUyUGtxMDNqTUdRNUVZLzZD?=
 =?utf-8?B?MG1KMjd2elZWcEhOSVJqSmlDbkhMNXppSFVLajNHSWZUWEZZcXNBNnRxcEVC?=
 =?utf-8?B?cWJnZnd2ZklXMC9URlZiLyttejYra3RKOGZHOG1WbW9Na0trWlIxZEZKS0Uy?=
 =?utf-8?B?c0t3aHhUU1hiY1ZWNStkeWpJZlNEeVNBNlQwVThmeTdDWTQrVlJFSElCek0v?=
 =?utf-8?B?eWc9PQ==?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c575bfe-cd7d-4925-e8cb-08dd626b12b3
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2025 20:10:17.3067
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gX+1hthIkKVFWvMeX9o0Jdu7FZm+a8CZgIcTOdJozFbFl9gEML3jxpfM8pKKf8O733RJT0JGwEIHSCYwhFouCXokjO0OFy389mTzMdtFhoY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR02MB9384
X-Authority-Analysis: v=2.4 cv=NL3V+16g c=1 sm=1 tr=0 ts=67d33bab cx=c_pps a=rknZK0v7KRh+kGA6vhtu4g==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Vs1iUdzkB0EA:10 a=H5OGdu5hBBwA:10 a=0kUYKlekyDsA:10 a=edGIuiaXAAAA:8 a=64Cc0HZtAAAA:8 a=PjzdzBBxZVh0jiqMALQA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=4kyDAASA-Eebq_PzFVE6:22
X-Proofpoint-GUID: neU_T1Lv5JU6DILmYL6f4j8DLkDL4Lwe
X-Proofpoint-ORIG-GUID: neU_T1Lv5JU6DILmYL6f4j8DLkDL4Lwe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-13_09,2025-03-13_01,2024-11-22_01
X-Proofpoint-Spam-Reason: safe

From: Mickaël Salaün <mic@digikod.net>

EPT bit 10 is used to denote user executable pages, for use with Intel
MBEC.

Signed-off-by: Mickaël Salaün <mic@digikod.net>
Co-developed-by: Jon Kohler <jon@nutanix.com>
Signed-off-by: Jon Kohler <jon@nutanix.com>

---
 arch/x86/include/asm/vmx.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 8707361b24da..d7ab0ad63be6 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -537,6 +537,7 @@ enum vmcs_field {
 #define VMX_EPT_IPAT_BIT    			(1ull << 6)
 #define VMX_EPT_ACCESS_BIT			(1ull << 8)
 #define VMX_EPT_DIRTY_BIT			(1ull << 9)
+#define VMX_EPT_USER_EXECUTABLE_MASK		(1ull << 10)
 #define VMX_EPT_SUPPRESS_VE_BIT			(1ull << 63)
 #define VMX_EPT_RWX_MASK                        (VMX_EPT_READABLE_MASK |       \
 						 VMX_EPT_WRITABLE_MASK |       \
-- 
2.43.0


