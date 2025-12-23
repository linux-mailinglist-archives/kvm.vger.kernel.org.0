Return-Path: <kvm+bounces-66587-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6072CCD816F
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 06:05:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 7FE0F300253E
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 05:05:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B1342D4B40;
	Tue, 23 Dec 2025 05:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="LQIGunz8";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="j5lQ+etX"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E292F1FCF;
	Tue, 23 Dec 2025 05:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766466302; cv=fail; b=kS2aSQpNoq10H6WVS7M1Ik+UogwSpQjNiRlMXKQNue2JvPovwFE3RAp4Af7BPBiEmZj2LtiJ52hptJ+IxOBsq3UIFkZiHNT1zWQyEWW2sm22AfSuVtAnq8oE5Pq82g8Ff7sVDigax5Y5RVJ4s5KnQ8x3VxvmlsZwt4yNWXfUHEA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766466302; c=relaxed/simple;
	bh=O+TJauhmiDvBb/AdskaIKsaUGXcBDHHrTPVl2iwtngA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ic/az3gKgaYzjseB51xh9asohst1rnkydxfiyDPZC0RqlSczmT2T48Ax1xyrnh+kx5FPPC3608WUV1oWePzDJhEelLbXtm8BPYsTiJFRj7+l6rWlkH32jTWSzxlidpdQSV2pBcJ3P+Ck6J8Q1Iu14oXLBIEIflD4N0GXNKFtyx0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=LQIGunz8; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=j5lQ+etX; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BML6cWZ337983;
	Mon, 22 Dec 2025 21:04:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=dkmdxlJeuUsM5Mtq3lgtmZun3n9ayAcH5IqpIh773
	L8=; b=LQIGunz8XUVC+lT3aUHy6d1e9ShKgE+O11U7te8MeSmq5tckoWbnmCHmC
	VY/8T+mbIa80CbMb9qEQ/OAKCtAFzNzmi3fpNhjQX8MiRjrBPezz2macahKjTPj3
	oygEs4E5Es68JA9nNKpY2oQ2Co/BDQy8mVORGkAW+5MSGaSIk4SrOw+y+68x4YiO
	I6JVljMJgZ79tNgnnefOQstO52CYdXnMhPpemYwtzOUYQNvFgD2NQhSoTpiAL5kt
	BOq8UGpppZ1M5A5AzxEHV5xiQhEaiGFtrg+fVuhST3DIxws8MFHHH4+mjXNm9xRn
	ymNul06Ts3xf6dbGVii5LcBS9Cadw==
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11020103.outbound.protection.outlook.com [52.101.61.103])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4b5t77cxph-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 21:04:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dohIJW5H2QVEOO0I6I1EWWtDYqi8CKl2762CttgFcLHWC3hCfBtCjSPROlwvdt/mBpKRFZhIvqlEBgREnq7hGbA/kk+KNJqatnhLZWAF/aDF53QS666NDAm+XLTQqNLyJGvV8tsQ29fnuVcHLlE6X7lly08TrvBmgRxuoP66NjocLvCL7gxdCmem98Q/u8jQEsSUxDCik5wOZ71+9qWN2wsaDtsgAcGBtEV0y7pSfsh39AHqwmV6pXHPuOkQLCiuWW0tk8CrEhJ0vBJTJTWYIoCo8Oz6SPU3zLrfn3Ehb7mLRM2kOsSRfoNMwHmHtb36xiG1Fbo4SC6mHdHAeYnNBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dkmdxlJeuUsM5Mtq3lgtmZun3n9ayAcH5IqpIh773L8=;
 b=h3707/LwqpRZ9seOiLo+jIOkuYAJ5o2Y6jIz0d+l4Sba39meuXfvWbIglsz9kFA2H1pWq3hEDdvNSbDuQIOUA2ifKXWvcFYrJ5ystmvB0aO5l2l55B0l8knFYRnyfLytU4SFviBXK3o/hY9vB67B6j0Eu/wuqH1ccQDm/2fRR9McSUB0uJSxrVisK6tATjSpzhzbhm0Dfd8xwwF2nLLYVhaM5a3FvsNuuV8Q2TY1Psmw5etLuLin4Yt+pNHRSQNSJkKULYAw61V9juTn0ZdqSqxizifqfbCgJW9nmxupHF5P0Osdc8aP+Awv6z4jKsbFLN4uKqDXJfr1IM9S9roFig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dkmdxlJeuUsM5Mtq3lgtmZun3n9ayAcH5IqpIh773L8=;
 b=j5lQ+etXYh4NzmqM8rjJNZLjufXYzS47fg3Si12YFY4fKBTRegmf3pgzvD+qCYz8XIkgoLlYgov/RblLtwWrP5PQcfIAez+uIH3wKwCIpz2pEt00QeZX3fppsIwPafWxVnOKTQpy5i+xy69CfDCzKVe0VpoQ6iMMhDuZmOKbhIedfGprd2f8GCwB/g1iB0uziRhSF5B+YeAzaHTmYt2I8qHcDFv2cwQDPVlWgZoGEKbU5XZTMrQtwxkrVn7O8bZ316Ev7IH5IV1ikx7K4EBr71QrdmSpJCSYxzO/xrCohy+bmLUt0anGVKB7GtARpHHdMzRuMk0siGaPeUoirSfoRQ==
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18) by SA1PR02MB8560.namprd02.prod.outlook.com
 (2603:10b6:806:1fb::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.11; Tue, 23 Dec
 2025 05:04:24 +0000
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc]) by LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc%4]) with mapi id 15.20.9434.009; Tue, 23 Dec 2025
 05:04:24 +0000
From: Jon Kohler <jon@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kiryl Shutsemau <kas@kernel.org>,
        Rick Edgecombe <rick.p.edgecombe@intel.com>,
        linux-coco@lists.linux.dev (open list:X86 TRUST DOMAIN EXTENSIONS (TDX))
Cc: ken@codelabs.ch, Alexander.Grest@microsoft.com, chao.gao@intel.com,
        madvenka@linux.microsoft.com, mic@digikod.net, nsaenz@amazon.es,
        tao1.su@linux.intel.com, xiaoyao.li@intel.com, zhao1.liu@intel.com,
        Jon Kohler <jon@nutanix.com>
Subject: [PATCH 1/8] KVM: TDX/VMX: rework EPT_VIOLATION_EXEC_FOR_RING3_LIN into PROT_MASK
Date: Mon, 22 Dec 2025 22:47:54 -0700
Message-ID: <20251223054806.1611168-2-jon@nutanix.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251223054806.1611168-1-jon@nutanix.com>
References: <20251223054806.1611168-1-jon@nutanix.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PH0P220CA0016.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:d3::19) To LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV0PR02MB11133:EE_|SA1PR02MB8560:EE_
X-MS-Office365-Filtering-Correlation-Id: 863e5641-9079-4401-8a68-08de41e0bd5c
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|1800799024|376014|7416014|366016|7053199007|921020|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NVpUcmMwZ3BJa3lpQi9sWFpOM1VZbTRDSCt6aVZFb3k1MGNjWU55R0M1VTdW?=
 =?utf-8?B?U0hYWXRhQlc0ekhUNDc1bzhaS1o5VkVuL053ZDNVanBEUnRUdkc4QXlSNUR0?=
 =?utf-8?B?WURlRjNaRVdTbHJFTVVMNnViaTNMdkpGZURHbVRQZkVOV2I0M3Fvay9oeHhy?=
 =?utf-8?B?bks2ZkZRWXNUOFN3L05zaHZlM3plck8xL3V4dmloQ2FsQy81R3pUc2ticDJa?=
 =?utf-8?B?M0xGTVRBbTZ1eDRLVTBSejFJSzM2Q2ZWbW51NExNQlRaY0hINW53ejRLMFRr?=
 =?utf-8?B?ZnpxcjFnbW52ODJtdytZRmRRcURXM2xQbllsZ1lmTC9RY1YwZnJ2ampJdVNj?=
 =?utf-8?B?QTZIR2VuaVdhVWJXQ2JxRGtFbTV2ZnZ3Q2FQcmw4VEpDeUpOR1p6dTNxRXRB?=
 =?utf-8?B?SVpTQlhnUy9rVXNKWUlVOEZld0JGT3lBZ2dNZm9pOXdBelh3S0hiN3pGc0dW?=
 =?utf-8?B?WVVtYVloVHoyS093b1QvUzZBa0JOQk9JWmkrWm4vWWZjSWJpT0ZxbThZY0dX?=
 =?utf-8?B?RnFsNDU3ckloVU1wZ2pHOGEyWFJDcERGdkxJYVBTajRkWkNBWWFZRUU5M0tx?=
 =?utf-8?B?V0l3dEpsbFNhSFhjdkpKTEJhRGwyMk9sNzUrVXZpckdlNWpZRGhrUXNaSHA3?=
 =?utf-8?B?bWpvSzhXTkwxbmVNdHZmeER5aEZnVzNHY1hiNklaWlNIN3hzNlQ4azlYZkRo?=
 =?utf-8?B?OU1qcFdrd0VhQUt5RnRkazhjdEtFa24wbThDRVdBVkFqZmxYbitCNG1EVktW?=
 =?utf-8?B?K25kUnJ1bFBuQW9TOUVqQnhSQ2lSbzVqRVZsd29yYnRrN0VpeHF2N25CRjI5?=
 =?utf-8?B?Zy95M2dLU1lpMGZOSXVZbndiSkdmR2F6YmRxTUp1OTdmajZ4UlJnSVA1c3RU?=
 =?utf-8?B?NVZRcWFtSytGUTc5TFcyQ2JuVHFYWWpGelZMNDVjNURlWXRJVXkvYlcwVDl3?=
 =?utf-8?B?cGZILzBXMEtKTnZFcjROOUxKU0FBbWVRWVhqU3lPampja2llVktBZnRGSDFY?=
 =?utf-8?B?NzQ3S0tsL1N1c2s2WkFqeUptZ0twaGQ5bjZWN0xEbVl3bGxOK3JaeHdVK2xh?=
 =?utf-8?B?UXZQb2JubEczK0lCRmRDbitCQmQwa2szUEZPd3Fhb1dlNjJkWFZVeXRtUTg2?=
 =?utf-8?B?bVBNN2NxLzdGdlVUM3lvTE52WUZEVVN6cG9QVkN0YnJSNmw3S3RRdjdmQ1hE?=
 =?utf-8?B?eWIxaDdSd0ZFUWd2MlFkVHFhSHh2cGpwcC9jNFVKOHJBSHpUQzRYeGFhTzNw?=
 =?utf-8?B?WllEYXBPbmJyVk1neWg4cmxLUGQ0ZjFEUjZLOCtYQzNWcmNvMTZkUm1naEEv?=
 =?utf-8?B?QWdPVkVDMERPNng1dnZiWU1ZdEM2cmhya256ZWZSNXY2azl3bXMwOFBFc0h4?=
 =?utf-8?B?cUJtK1lWa0UvU2E5T0UwdUd5WXhnUGxIdWhLQzlFUmw2eTl4dytVZWV0YXcz?=
 =?utf-8?B?OTNIR2J6bkRaY29vYTYzR3FJeFR4RU8rV1J4QnhzL3RXYUNaVnV3QmRsck5a?=
 =?utf-8?B?cHZWalVGSjY0NW43VGM5L28zY0hPWS8rVEN1VTQ1QTE2Tmc4c3ZYaDI1VDg1?=
 =?utf-8?B?R1Q5dGthcWhJbjFONThHNG93TU43RXJ5VTF3TkxNd2s1S01qaDdPQzFtbWRV?=
 =?utf-8?B?a3JXWEdSM2VBS25zOHUwVUN5NVhrdHVHemhwUkw1dW9xWW80QXUrYzRVK1hI?=
 =?utf-8?B?N1Q3V0YxM2lRdE51NWhWamdheFY0WXRUQytRcldNZFpJaFVUUWlpQzVrRFk3?=
 =?utf-8?B?RDdpZ3NaOGRMTEJRR1ZyWTVyc1NkTHg1anpXQlJiVEdLY3o2VTM2bW4zWUNq?=
 =?utf-8?B?aWdKaWs3SUcybzVyZzJrM0dRRjFLblVad0MyVjFRWFlyVk1vR01Qd3BhNjkx?=
 =?utf-8?B?amNFNFlQSzB1VXNkUTdTbHhGLzR3cnBTYUZLb1lXbHNQSERIeTQ2QXFrL3p2?=
 =?utf-8?B?bWVPcHhWSldjYUlab1g0YlkwNGowMmx0MlpSU0JNVTd2YlN0Tk52VlJjbTNq?=
 =?utf-8?B?ZXBhZWRZOVZCVVNaUURDb2FpVTlYR3RyNWNSeDhyQ2NaS2g1NmdsRWlTNzFZ?=
 =?utf-8?B?QzAvR3JyNDhHSGFyK3EyalgwWHhYZ0kzL2Yrdz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0PR02MB11133.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(1800799024)(376014)(7416014)(366016)(7053199007)(921020)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZkNPNUFJMEE0TFUwRURzQzNWMFpXL3ZYOWl6azRNUDNsMnFyUlVwSjl3RjMw?=
 =?utf-8?B?SkxnRDlRRnJBeEV1cjUvMWhFTFNzUFIzU3NMbld2TzlHSE5vWFBiYjhtcmwx?=
 =?utf-8?B?WG40c2tYeUh0RW50TEN4TTdJbllwSnpsUmJjbzRDTlR2bVM4Njc1TnA4UmxE?=
 =?utf-8?B?b1YzK2xwQUpYRDhjODZIVk55WkxlZDhlSW5qM0E1QXIrWmJWTVRkZWl0OUYv?=
 =?utf-8?B?bFBhYkRKajBRNk1tZCtsVEU5dHlsMXVvR1puTTRMSG9DRUQzNWhIcno5azVQ?=
 =?utf-8?B?R0xDdnBFQUVHczBmZm9WaVNvdDdTNWdIak5lNzVETk00bzBvRnhKU0E4U3JI?=
 =?utf-8?B?K1FYbmNGZ3pDeEhGTU9BTEJlVUtZVXlYZDhOV0hCUms5d2RNU0Z0eHExRW5D?=
 =?utf-8?B?aVVIUFhKVWJWa2Y0TEJxN25hOG1JanhIMU1hYTlPTGhRYW5lclVWQ3hiVWJK?=
 =?utf-8?B?MWUrVEQxZE9BWlJlaXAzc3RoSUZqTy9HODZ1ZjF6cVl0RHdJUWxTa0w3WDRu?=
 =?utf-8?B?a3dTYmlNY2MwbmI0MkhlTWo5V09pT0IvVTQ2bTRZRTlrd0h0RGlHY2I5NGt2?=
 =?utf-8?B?UzlZVkJ2Sy9nT2lQei9uOHBaMUJrc3R6UnQvUEVuTHJLVzlXWUVFTXZzU25L?=
 =?utf-8?B?ZUozUVhsMFNTMzVRTGY4c2RqYzdZWDJwOW5HNVg0eW9qRUFuY1dNZkpPTVBs?=
 =?utf-8?B?SWZPeEYyWmpweHBYT3A5OXdPQlFtTVEwaVl6TDNoNG5RVitPWlIyQkM0VWUy?=
 =?utf-8?B?MkUxQVd5MDFRL0VneVF0azNvMThOa2JOaU1ab3hVc1ZOQW5HUXJ5UXNEcWpp?=
 =?utf-8?B?NHBJdkhKMXhQaFZGeGJBMm5tZExPdm9adUhBbEJkWU55RE1iT0ZQQ1JneU9n?=
 =?utf-8?B?NWpiNnBhZ2JWckg4SkwrLzh1dyttVzR0b2dBOFZOZnNpNURNUXl6UTNKTVdH?=
 =?utf-8?B?V0prd3pSa1FyL0RseWZ3RHdUUjFwbm9mSTUvVUdleHcrZ2hKdFZZTU9OaS91?=
 =?utf-8?B?dERXRHJRKzJRNmFFanB0SGFOOVBDRE5kSVZiUGRJZUJsdDhwenhSaXVlTnEz?=
 =?utf-8?B?UHYzL29GTWdhcHRocytZRXEzck1qVXVHbzZDM3hOSmpCNHU2RTdxTjV5WWs5?=
 =?utf-8?B?azBXeEJGVUQ0elVYdXVzNER0UmZuRDBpZXZ1WVNzN0gvd0o0cDZUbGZYYXZx?=
 =?utf-8?B?U2dZdXZWa2dVQUwrRzFSZnZ4VkNZd0MvMlFuSmlpd0YwZ1JneU9SRkpVOVRH?=
 =?utf-8?B?OWNYZmRYeEFPRzBMeDZyd1NpaGhQTGtNMzRVT29tYVJ2aHVRdTA0dUtpWERU?=
 =?utf-8?B?dUVCM0l6QmxzZTNMZFgreTBtNDlVd3pEbkpJb3ZvQlJ2ZlpKWnBhNklyaHR2?=
 =?utf-8?B?Wmk2M1EySWhLbXE0b2RtYzlPYXJTWGQ2bkM2Q1VvYnlDUVl3Si9rZEQ5Rmg0?=
 =?utf-8?B?YUt1dXJ2WWtQNFFnaU9udDRFUHdqSWJ5WEJIT0oxSm9qb3lLZG1xUmMyNTlw?=
 =?utf-8?B?a2E3YWozcTdYTzlQdTZRUlYwajNMby9vN3BKZTl0d3ZjZHpMK1Z6L3NHTlY1?=
 =?utf-8?B?Zi92bjh0TWwyOGhuenNuQWhZVTJpbDJCaGVPOCtTNFJYU2RpM0hpSllOczli?=
 =?utf-8?B?QnJyK3RiU0QzQjFpQ2VPcys0a2pVemFYdU1Ibjkwdm5OUGtsa1RuMDJ0ZGty?=
 =?utf-8?B?TkNlTnloTHhEVGxuMnRvOGNPeFhhb05SMlBnMnFRWGR1MlkxWE1tN3hhVmpP?=
 =?utf-8?B?cU1pMnpIUEhRT1liM2FNWFpjU3lYNldISDJ2VU9PS3JIQ3ZVTStKWWR0ZFht?=
 =?utf-8?B?N010ak82U08xQjBTR1N2bXpkUkcwSVlHVkc0R0JKaTVBdVdzZHc3eUNzQi8z?=
 =?utf-8?B?TVg2U0FPb2dmVGFob1hqbko1RWJLSE1lQk52d3J6cjFVYWwyWVMvamJqYzYy?=
 =?utf-8?B?c2VGakhpQ1YzOHIzNW9lL0dLaEpYc0EyT3BOYncvMXg2T3NQbFUwWVRVVW54?=
 =?utf-8?B?VFJiR0xTVmgvMzlBdkNYMWdNNklNcDVvZTExMGNDTFNkcThDOGZadjErZWN5?=
 =?utf-8?B?eCtlTkdnaDRkTHRTZEt5N2pvejVyc2VET0gyRnVMVGplL1Voc05PTEQ5Z2g3?=
 =?utf-8?B?NWhwSkRkWTdxNzU1dm1tMEtORWwrZmtFYnBzK0haU0MzVVN5YlRsWlBNaW82?=
 =?utf-8?B?dlRDV29Mb1A3aXEyQTh5a3l4aTBldFR0eXlTVUtuc1J0bTZIN0xaYmxzTkp4?=
 =?utf-8?B?U0xSU3k2cG02dEhFLzNiYk1pVHMzaHZ4TUpPbFpiYTZESlBHNTFNUzJWWWFm?=
 =?utf-8?B?RE5mK2V4RHdnVUdjalJSNWllVmo4THlxNXkweWtNZFFSUWpKb3ljaWxmalkz?=
 =?utf-8?Q?zYDl7hkbF/qgxWgg=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 863e5641-9079-4401-8a68-08de41e0bd5c
X-MS-Exchange-CrossTenant-AuthSource: LV0PR02MB11133.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2025 05:04:23.9456
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oGZwPZwqHXP3n8FF/GEk0W5R4W3gZZaSq0U+o/xkXiYzBB66gmUhF99quTehGaAgi05E//QfZhRApk1V209HA4v9/UehX5o9N1xV4yKm2HA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR02MB8560
X-Proofpoint-ORIG-GUID: EPiZaNsWSEjumacwys0aC-hv0WkMMkV8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIzMDA0MCBTYWx0ZWRfX3aYB1pr76E20
 tTGdShz5LRTZZIlL588h2EXC3MAS1TM+hzpxH8bw1Vmkh248xrgUcfUKfuGkrn+6nZIA5ZBtN3i
 LjtT+1ishJ1kCT2ktoI0Hrr2F+5QaYzbpZ/3JHGXyxn2BZybF1nvrGPFwtkdHczUXRvFv0RxvZ1
 W0OBJxo4PHxG4cXIoTiuZj7NOGK5baKxuYPxAQpKREBIJm/Rx5dW7S47LtqJmM1Ezxy+aMVBngI
 Unax1y0a5MEbFvodJRmi83rTtlWOAUIlnYYCDUphnG2T2mY4TQ7b/o1DVUpzS6imWUJXAfemO9i
 vPLtG15bPBRPLbrRmI4qnDtcAMPgMPr3bv4/48VVnudtPV0LXc97C1aSv7S0XZw5F2XCr+xfNeU
 KHpjO7jG6HiBFChDH5wyc7WRdI02EqBFR6zPVASB57yQ+aHI9yrQKKpGohpojbqETBeOIHHy2km
 r2bJ2HH37E/IyJpw/mw==
X-Proofpoint-GUID: EPiZaNsWSEjumacwys0aC-hv0WkMMkV8
X-Authority-Analysis: v=2.4 cv=MrxfKmae c=1 sm=1 tr=0 ts=694a22d9 cx=c_pps
 a=l0LO6K05DF9RfVVG1F5aEQ==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=64Cc0HZtAAAA:8
 a=FQUYTHRx7rOHAEkxlYsA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-23_01,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

EPT exit qualification bit 6 is used when mode-based execute control
is enabled, and reflects user executable addresses. Rework name to
reflect the intention and add to EPT_VIOLATION_PROT_MASK, which allows
simplifying the return evaluation in
tdx_is_sept_violation_unexpected_pending a pinch.

Rework handling in __vmx_handle_ept_violation to unconditionally clear
EPT_VIOLATION_PROT_USER_EXEC until MBEC is implemented, as suggested by
Sean [1].

Note: Intel SDM Table 29-7 defines bit 6 as:
  If the “mode-based execute control” VM-execution control is 0, the
  value of this bit is undefined. If that control is 1, this bit is the
  logical-AND of bit 10 in the EPT paging-structure entries used to
  translate the guest-physical address of the access causing the EPT
  violation. In this case, it indicates whether the guest-physical
  address was executable for user-mode linear addresses.

[1] https://lore.kernel.org/all/aCJDzU1p_SFNRIJd@google.com/

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Jon Kohler <jon@nutanix.com>
---
 arch/x86/include/asm/vmx.h | 5 +++--
 arch/x86/kvm/vmx/common.h  | 9 +++++++--
 arch/x86/kvm/vmx/tdx.c     | 2 +-
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index c85c50019523..de3abec84fe5 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -596,10 +596,11 @@ enum vm_entry_failure_code {
 #define EPT_VIOLATION_PROT_READ		BIT(3)
 #define EPT_VIOLATION_PROT_WRITE	BIT(4)
 #define EPT_VIOLATION_PROT_EXEC		BIT(5)
-#define EPT_VIOLATION_EXEC_FOR_RING3_LIN BIT(6)
+#define EPT_VIOLATION_PROT_USER_EXEC	BIT(6)
 #define EPT_VIOLATION_PROT_MASK		(EPT_VIOLATION_PROT_READ  | \
 					 EPT_VIOLATION_PROT_WRITE | \
-					 EPT_VIOLATION_PROT_EXEC)
+					 EPT_VIOLATION_PROT_EXEC  | \
+					 EPT_VIOLATION_PROT_USER_EXEC)
 #define EPT_VIOLATION_GVA_IS_VALID	BIT(7)
 #define EPT_VIOLATION_GVA_TRANSLATED	BIT(8)
 
diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
index 412d0829d7a2..adf925500b9e 100644
--- a/arch/x86/kvm/vmx/common.h
+++ b/arch/x86/kvm/vmx/common.h
@@ -94,8 +94,13 @@ static inline int __vmx_handle_ept_violation(struct kvm_vcpu *vcpu, gpa_t gpa,
 	/* Is it a fetch fault? */
 	error_code |= (exit_qualification & EPT_VIOLATION_ACC_INSTR)
 		      ? PFERR_FETCH_MASK : 0;
-	/* ept page table entry is present? */
-	error_code |= (exit_qualification & EPT_VIOLATION_PROT_MASK)
+	/*
+	 * ept page table entry is present?
+	 * note: unconditionally clear USER_EXEC until mode-based
+	 * execute control is implemented
+	 */
+	error_code |= (exit_qualification &
+		       (EPT_VIOLATION_PROT_MASK & ~EPT_VIOLATION_PROT_USER_EXEC))
 		      ? PFERR_PRESENT_MASK : 0;
 
 	if (exit_qualification & EPT_VIOLATION_GVA_IS_VALID)
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 0a49c863c811..61185c30a40e 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1922,7 +1922,7 @@ static inline bool tdx_is_sept_violation_unexpected_pending(struct kvm_vcpu *vcp
 	if (eeq_type != TDX_EXT_EXIT_QUAL_TYPE_PENDING_EPT_VIOLATION)
 		return false;
 
-	return !(eq & EPT_VIOLATION_PROT_MASK) && !(eq & EPT_VIOLATION_EXEC_FOR_RING3_LIN);
+	return !(eq & EPT_VIOLATION_PROT_MASK);
 }
 
 static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
-- 
2.43.0


