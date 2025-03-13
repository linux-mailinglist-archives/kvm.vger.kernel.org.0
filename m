Return-Path: <kvm+bounces-40993-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 04494A6021A
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 21:13:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BFC7219C3C36
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 20:13:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D26FD1F8BC9;
	Thu, 13 Mar 2025 20:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="hRpfYNAV";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="PplxefNz"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD0E1F5608;
	Thu, 13 Mar 2025 20:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741896642; cv=fail; b=PsB4PTjI1zFLsE+dRPBmI/eiazoWqJQHDQs0YejiKjNsY2OhnwHZ1nZgjcnyg2hDhS6PyvrlkPqSKqTjp932TPEpfpLILTQzCFeVxnrcqKcF5jj/lIObSIBs+YtMqM0Gx+h9WEyLFKabUiaybKvNYRyxZE+UI7vCUF+DCG9g1r0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741896642; c=relaxed/simple;
	bh=Q2rLyrJUBViZyGVQGJzwp+qy9r6E5e6tWVsOJqe+7tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZL+cPTaM5e7IGriQY3q2RWClQPqYlNM6K03p0bGyg0S9Wc3gyUshHkf2ehoqp+QwgyXYyYTNXBwbMgsbJ14v0rjKIAhptKUr8uxi5W7NAaveTZHkBZHlwiD4jV4Q7L7TwaD6C1Wm9JHu4EL3ozO5G8vtnBkCzcKsKGSqAvmcDHo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=hRpfYNAV; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=PplxefNz; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52DFXACm011270;
	Thu, 13 Mar 2025 13:10:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=2qzHKAcGadSq/KNxuKnDK/3CPRkt+gOoqN3LM0NkI
	xI=; b=hRpfYNAVxFx3NOgHSnK+4yYKDGRKDncAuYRBVfux+IUiL4QRZKLWbwHPF
	NJmAKk9Jfp8N7XUSuCpEKU+92MA96TrjHS/LGmT2un5XmJaSKDogfl99y10L9oyc
	ZsmYtE00051LzQLJwbVV/aV5PgCw957CAuRH7MJY7AaPBLBxhHTU5LKVXPbAjK9y
	Mj7lKvLEkGFrf2fz6CZMHW1VTgv02F+Fo2+wroRvdg52bE03qdnzmPZkMJiLeXEw
	Igr/F/aVivLHHRIqRuEeZzxkGmV76sducFNz3WEVih7Ah0zeGiPLwveNBDdtQ+/3
	T7qYVwzQMHumogAp4G8tPgrOWL1Gw==
Received: from sj2pr03cu002.outbound.protection.outlook.com (mail-westusazlp17013077.outbound.protection.outlook.com [40.93.1.77])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 45au9ge76x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Mar 2025 13:10:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a4zq8vIqFmccV03pLL9nYGFmzyI6DfXvbO290+zX8xH1Yx0oh9vZ6KwA8MaiOIbsOYOzw0+kti1rBe+8LYJLKMXcRVPmtmuugi8v59SsFT+Y9xczDBBPBHNJTjbLswP0zyK7oPEzcCVMKdv9kuJTeIjoIh05LBQ3IWdKlwyYCChJjhQr3/QR8sM5upmRKJxWPbJvBP//ys7zVnMhrEN7fFjPUJBmsvbYB1MkJjN0gLk+mnISvsjfPweWgf7xFiDb+bO4hbvulgTuCageEEIwZn8oDw7wUpJ5B1rOFlos52CuNbOKO0fmekGnqL9883PYhywCe9skw5bfpc5EwM84/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2qzHKAcGadSq/KNxuKnDK/3CPRkt+gOoqN3LM0NkIxI=;
 b=LFC569cxTCpKH01rAyHHpx88joqXj5wRv7OVKYfa74Hczgz7Vs48/IflMdehDsadMDvejXQ1i4vKuJuCgzagDQzGUYVH2S2/R2jf1kNMuMrsgGsq35hSA2N/T2n7FkPXr3wtaY9/xCR1K1nPNU5vRAgcooyKnnk53CBq+TxlRjIHy1vwxah+AVlkZYgLEvs8G7H6ufWX0Mb5NkCRQ1zkSp7UGi+cT4IYFcYjcYcBLOOPAVCHxnlwy2YLcXaK7lSoWkiTko+NowMqo8juTPL0xM8BW7D8RpNC/TJESwFVxdn9bNEP1kVKC6Tg+AO8zD83rrusbklibiqaeKIrEQo3Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2qzHKAcGadSq/KNxuKnDK/3CPRkt+gOoqN3LM0NkIxI=;
 b=PplxefNzVYiysTC/pQKwKCivOJkTvu69lnDEUPNqGq+dznx4ZbCnRa+etSllnsbRwBuKkTQWQ/WsKKSSQJ6ddKHwgsS/tOIxeZWHgrCt8R43nH1lgU1w/Ug34e7z5noMxNJ0e1B8JrKfO6/iILGZGk8nbalZt53vetJtYn48f0HmmCc8NYKo7xz0C3m1kYzGquDtil7UKa/CjlhwR+Xz0oFtpmTlk40yYBg7JFBE0k9xzSgnh+P0noIWlgh0rf2woqaQOrBnWBic8nyCvLRpDa9wOOx02p5Gl2f7d/jVesi5KKnRvLL9NdcZapKrala7eoZ8BkassTO4cTJ+pF+TMQ==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by PH0PR02MB9384.namprd02.prod.outlook.com
 (2603:10b6:510:280::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.28; Thu, 13 Mar
 2025 20:10:22 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%4]) with mapi id 15.20.8534.028; Thu, 13 Mar 2025
 20:10:22 +0000
From: Jon Kohler <jon@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
        Jon Kohler <jon@nutanix.com>,
        Sergey Dyasli <sergey.dyasli@nutanix.com>
Subject: [RFC PATCH 09/18] KVM: x86/mmu: Extend access bitfield in kvm_mmu_page_role
Date: Thu, 13 Mar 2025 13:36:48 -0700
Message-ID: <20250313203702.575156-10-jon@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: 95008581-aa87-4318-0059-08dd626b15ef
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|1800799024|376014|7416014|366016|921020|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?M1FxQjEyVXJDUUcxRVludDNKL1Arb3dsWGpLOE9zUFFscGZOMHcrS2RCRndz?=
 =?utf-8?B?UElPcjhkRzR3YkdVdjEwcmVSNnRBY2MveUJDN2ZFZmIwRFU0aEFZWjdTV21a?=
 =?utf-8?B?eHltS1hpWjIrZWR5L3BjcjRTZXRTUXZFLzlvaGRXS0REOUJsQmRsbVZCTjdx?=
 =?utf-8?B?RHBkSjZybi9pdkllUFBSc1J0d01ENG95am9oWmkra3FIMm1Kb0E4RDRPUExh?=
 =?utf-8?B?dDNuYk1TUndhOXNXeFV1RlgzaEdrV2xIa1NYYTY1ck02Tm1qT1gxTWdxblZ1?=
 =?utf-8?B?aUlXcjhDQlVtM0d4K0paRGpKSXZXYVl1T2xNSitGOHYvVm9ha2hPanJ0L3Qy?=
 =?utf-8?B?OFVnSUpFTXQxOHlFanVReWNXclJFdDhrRkJFWE1xVnhkUGtHZ1c3MUZqb3VR?=
 =?utf-8?B?TG9kMVA3WlJkbk1Yc01NN2xLRmM5VVU1eG1XZk12VkpXbm9GZmwzdk5rMEhK?=
 =?utf-8?B?ajFSa0FSbFE2WUI4ckdzek05SHV3S2haMmhVZnREY1k5V3V1UDNHaFkyY2JS?=
 =?utf-8?B?d0FRbitVSnFwMld6bXdXVFIvSGJmbHcxa2ZDSEhDc0VsTmNaNmRIN0gvcUhJ?=
 =?utf-8?B?VWdJZm8rSUswL1JGZFd2dWxUWnIxSDFHY2pBaW1TYysrVUhsa28vNGRhVklw?=
 =?utf-8?B?NHluSWs5a3Vta1dzVXRNVmJURVc4TEIwT0p2enZZRkhTM1JDSXhXcUZpR0JD?=
 =?utf-8?B?YWVjUjBmMTBWVE4zR3ZnZ1FBamZzSnFHWXUzMVc5K2tQaGZvL3htcXlqUWs3?=
 =?utf-8?B?SnpUTWF4b0tmaWpPVCs4Z29ibTVoU1U5enFSTTlYNkpXLzBPZ2svSXB2R1dk?=
 =?utf-8?B?QVMwdXduUk5mcVlPeVNnM1U4RDArMGpORjJGWFBwb3IxYjhSaDdWd1ZkSW1u?=
 =?utf-8?B?OXZRSUkxek5nZEo2TFFUZXJvRTNaS0NicUx2UHN6L005c004TWpCa2hZZVp1?=
 =?utf-8?B?eFZQbThhNHdrMXB5Sys4QzhDZWpHYUNpenJmSUxNaFM5K29veFJwNEp6cXN6?=
 =?utf-8?B?Rk1aczhOc2VMOWxWdFcxdE1aSldWa2RkV0diZTZIcmI1U3JJL2lPRWtacmhw?=
 =?utf-8?B?eitoclhpNVNTMDFqMUorWVIzYUJzeVJibW5IQ0R4L0w3djJqZStuMTR3aXZq?=
 =?utf-8?B?ZUJGV25VMCtjS1hRc2p3dHdoR0lvQ1JON1FKSzROTi9vL2RUKytGKzk2MjJr?=
 =?utf-8?B?Y1FCZk12Ti96UG1jTWcyZ2Z1b0FvZzJ5VXY5b2hxRk1mTGJqUHVvZ01tRmZY?=
 =?utf-8?B?VU8rZW1ZekRoOE9HdjlzODFkSGJDQlF5THEyVE1NZHlFQ0RlSldtb3l0RlJW?=
 =?utf-8?B?S21lQ1VabDJNN0ZwUFV1UzhUa0J0dVdJNjY5cXozMU1RMUZ5dEJ5SmRDMG10?=
 =?utf-8?B?VnVQd1IyemlUby9lSXF2WEc1aGtiZGk5QVFINkRWVHV2N2QyWFFPZE5rd29B?=
 =?utf-8?B?Y0pwWk9lMWtBdEl5SXI1d3hNUXhleE9oQ3FtVldGU2hNZlNtRFBicktSUkla?=
 =?utf-8?B?N1NTbE1QUlZMTnNjTFNrRmdra0lhK0s3SkhWeXRZZlBwZXZRajVFL2FFZEx2?=
 =?utf-8?B?ZFJCSjA3SEpTNTNwMGM2cUtvKzY3a3dzdzQ0Y3RsQXFrM2RQdlJ5RWxWZldB?=
 =?utf-8?B?WnpjYmJiNFk0T0FpYU4yR3FNL1NaSEdCbW9RLy9oUlp1bUF2TVdxd2NQaHBQ?=
 =?utf-8?B?TnFzZVFTN08wR0I5c3dEbE4zSlQ0eThGeEUzQitPUE5wRExlUm83cUQrcU1O?=
 =?utf-8?B?b3VLWlZUODROWTFQbTA3Z2JaakkrZE1HRTQvRmV1L1pIYzJvckJ0cXhOb05Q?=
 =?utf-8?B?bkxzd2NqcjlVeVFiMk4wb1VuUkdIeVpQeUJOOTM5UU1vdDU3cjEzdDFYcU9F?=
 =?utf-8?B?a0dpMWJhVVZKWnlIc3UxSDZtM0RiYXhqeHB6c1h6SGdTTGFHSGoyT3FTN3RG?=
 =?utf-8?Q?bro+q8dNnCgNxA+OdHM2GkxNJ82L/lic?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(1800799024)(376014)(7416014)(366016)(921020)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bFM2cU45VjhVWGxPdkpJbVhEMDdmNko1czh4Nm5XZ2EvWEVjOFhXU3gxQlJY?=
 =?utf-8?B?K1RtaWdhclNHcXhPQTFXaGlNeGFZTUpUdFJLV1dMbk5iMEJGb295SzBoVWVG?=
 =?utf-8?B?a1hhRkJqUk85YkNPaFdTUnU3OUxnbzZiVlRiRmJKYUFBM1h0RlFuODZwRnd4?=
 =?utf-8?B?MHowVnZBM2R1Tm1CYkdnazVwL2VjUHdhNVh3V0FIOWxBK05aNHFRbkd6Vysx?=
 =?utf-8?B?QTgwYWhzb3R6WUpweE80UEJ3OVY5MWc4YSsrb1ZSV0hxVEEyZHppU29meVZo?=
 =?utf-8?B?NXV1S2Q0U0lURlVNdmx4OFdRV1ZqSU1HWVhaK0tDM0Y1VTZnMEp6Rjk2OGNW?=
 =?utf-8?B?T0ZZSHpwNTl5ZG5QNkdSdXM0dDJLSFU1MEhsZG04RnEvbFhLLzFxelBLdE8z?=
 =?utf-8?B?VlhldVRoYkFQd0t2RGZxS2x6UVdpR0xsUmdubW1wSGhPeWxnWW9tZWpsQ2tO?=
 =?utf-8?B?Slh5M3QzbnIvWmc4Qit4azgyOEovaGFuM2Iyc2pxQ2NhS1VwOWEwNzJxWE9L?=
 =?utf-8?B?QVJIVHExUXZlRFFmbTJzb1JzYTRlS2l3cW8vREQ4YlNQNUhWOXplZmpQWjh3?=
 =?utf-8?B?Z3VSdU5Qc29Cc3d3c09YbHZQcGt4VjJNbSthT3Myb015a2xHc2xNQTYyYnlj?=
 =?utf-8?B?K0QrY0h1QTQ3NXoxTTFLOUI5S2hOU29SNVZyOXo0SldOZmhxWDdYN1ovbFB5?=
 =?utf-8?B?cXRNdTk2azR6OVMvWjVGM2l3cVdUQzloWXU3Z3JzbHE5RGpXR0U1dnlSSnp0?=
 =?utf-8?B?YXBvMTNnaHU3dzdpWFVxbXdDOEZyd1RlN0NaYlB3UmsySUFWZjRYQnNWUFJk?=
 =?utf-8?B?VTZrRzNTUmNzMnVXdDJrQlFxczMwM0ZDSzRiNlJSdkoxRlc4WlduYURoakJy?=
 =?utf-8?B?NFh4WVpVU0NsUXZUWDdPSjJJNHdIdEtja0MrSWJndlM2MUhhbjZvUHFvakp0?=
 =?utf-8?B?VmZtQ095WUQ5aUl0dmJTRWh2d0RkNDJIV0U1Ly9JVjZ0bFRacWNwSkZYc29t?=
 =?utf-8?B?MGRjT0VsZDVMejJzYVVseEU2bUowckNxOGU0Ni9WNHBqMy85MW10dWZSRDVr?=
 =?utf-8?B?NnZVTlFOcE9IdzY1SnFuSUY5T0VkOGYxUmh5N3dVaDZkRlRrbEdxTVExSzBF?=
 =?utf-8?B?eURrZnVTaDhqOGxHdi9wSFE5b2x3ZEtWeHYwL1M5cTB4MHRKa2ZCMkhTWmJk?=
 =?utf-8?B?Vm52QzhsOE11dE9mc0dlT1IwYXkyN0p0ZGRZWlBVZndrOTZDVjJFQ0dBRmlh?=
 =?utf-8?B?SUFvWThBV1RETUJpL0lkbW1GejRBdTh3UDFqQWV3aG5vajFQVkowc01MeW9s?=
 =?utf-8?B?ZHlEMVRTUkNORXdBdUx3azA5WGdLbTNWaWc3WWNzcEYrbmxoT3BNZHArZXlp?=
 =?utf-8?B?TUwyWFZ6blRFQkJRMUcwRHlYbnU5bHZ6Vm1jWmxRQUxuZkF5L1NNV2RxUXB5?=
 =?utf-8?B?V0lOSUhVK1pucGY0Smc3RTMwcEhVRlFXSXFOSzFjT251a1JqdmhuTVFybEdQ?=
 =?utf-8?B?RDZXYWQvT0NIMjF5Q2VMc2ZKWnRrcnVrOXNnWGFNSHZyLzVqNVdyNnM4a0Zu?=
 =?utf-8?B?NTBvSFJzRTN3d1BuZjZ2ZjBZQkx5VTZmU2xMc1FBTmxDeFB2UDh1MlB5YW92?=
 =?utf-8?B?MVloSEJOZ1BQQnlMUFlEWUJQY0xLT3FsTHpoM29SVWJKQUtPeklEUW91bVlP?=
 =?utf-8?B?Mk4zUkx1UCtxMXBSTHRCY1g3emhQR3RheDZwQkhtNzQ3Ukhib000Y2hPNTd2?=
 =?utf-8?B?Rm1JRVRrVzh4UEJ2T0RjL3BJdStqTno0WUJLRTFIVVhiN3M0VHFCSE8rclNX?=
 =?utf-8?B?MzNMS0JLclRVSlAzMTcwVVBRdmNESGMyejVQZE1pNmMyRmgvb09vOE5wWmRt?=
 =?utf-8?B?OEZvTkFrdC9FZk1USHp4WEJuYzRQbllJQjhKMWhWc2hldTM4VUhuVit3RkRS?=
 =?utf-8?B?dmxacFVtNFkxODh3dVZQSER2Q1owazNNZHR1ejdiMkZveG1UbGtXWTVRL09U?=
 =?utf-8?B?ZHp0NEVabXh4bmcyMTB4V2V3dlhFdmZJNDlNU09iei8xWEpHZnFqRjdTaHRw?=
 =?utf-8?B?V0ZscnR3QWRyQ2N3VFBSem5zcHIwRENNZGJZTnZrY0pZV2xBejRjTUl3LzFl?=
 =?utf-8?B?RkpZYmVENVNFU1BUZHMvNTdodFBvYXV0eStEMFNIOCtNZDQ0clZoR29ZRDhv?=
 =?utf-8?B?N0E9PQ==?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95008581-aa87-4318-0059-08dd626b15ef
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2025 20:10:22.7723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OF/utC9wDtlJROFj5kpDMu8z3novROYW5hbOwB9+bx2vzKo372t38ik/tpv87kkqTIA+JBpVauQiXw1TfMOVJIXsacWQYqk0YoHnutwRuZE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR02MB9384
X-Proofpoint-GUID: aQMvmBddV32wZtvNCKEj2oK1q7xEt4jp
X-Proofpoint-ORIG-GUID: aQMvmBddV32wZtvNCKEj2oK1q7xEt4jp
X-Authority-Analysis: v=2.4 cv=P8U6hjAu c=1 sm=1 tr=0 ts=67d33bb0 cx=c_pps a=1Ha7URm6ceckcZ/uwdfrUQ==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Vs1iUdzkB0EA:10 a=H5OGdu5hBBwA:10 a=0kUYKlekyDsA:10 a=edGIuiaXAAAA:8 a=64Cc0HZtAAAA:8 a=uyyFwX4jvXRPhS2kFJ0A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=4kyDAASA-Eebq_PzFVE6:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-13_09,2025-03-13_01,2024-11-22_01
X-Proofpoint-Spam-Reason: safe

From: Mickaël Salaün <mic@digikod.net>

Extend access bitfield from 3 to 4 in kvm_mmu_page_role, where the 4th
bit will be used to track user executable pages with Intel MBEC.

Signed-off-by: Mickaël Salaün <mic@digikod.net>
Co-developed-by: Jon Kohler <jon@nutanix.com>
Signed-off-by: Jon Kohler <jon@nutanix.com>
Co-developed-by: Sergey Dyasli <sergey.dyasli@nutanix.com>
Signed-off-by: Sergey Dyasli <sergey.dyasli@nutanix.com>

---
 arch/x86/include/asm/kvm_host.h | 10 +++++-----
 arch/x86/kvm/mmu/mmu.c          |  2 +-
 arch/x86/kvm/mmu/mmutrace.h     |  8 +++++++-
 arch/x86/kvm/mmu/spte.h         |  4 +++-
 4 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 192233eb557a..e8193de802a7 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -312,10 +312,10 @@ struct kvm_kernel_irq_routing_entry;
  * the number of unique SPs that can theoretically be created is 2^n, where n
  * is the number of bits that are used to compute the role.
  *
- * But, even though there are 19 bits in the mask below, not all combinations
+ * But, even though there are 20 bits in the mask below, not all combinations
  * of modes and flags are possible:
  *
- *   - invalid shadow pages are not accounted, so the bits are effectively 18
+ *   - invalid shadow pages are not accounted, so the bits are effectively 19
  *
  *   - quadrant will only be used if has_4_byte_gpte=1 (non-PAE paging);
  *     execonly and ad_disabled are only used for nested EPT which has
@@ -330,7 +330,7 @@ struct kvm_kernel_irq_routing_entry;
  *     cr0_wp=0, therefore these three bits only give rise to 5 possibilities.
  *
  * Therefore, the maximum number of possible upper-level shadow pages for a
- * single gfn is a bit less than 2^13.
+ * single gfn is a bit less than 2^14.
  */
 union kvm_mmu_page_role {
 	u32 word;
@@ -339,7 +339,7 @@ union kvm_mmu_page_role {
 		unsigned has_4_byte_gpte:1;
 		unsigned quadrant:2;
 		unsigned direct:1;
-		unsigned access:3;
+		unsigned access:4;
 		unsigned invalid:1;
 		unsigned efer_nx:1;
 		unsigned cr0_wp:1;
@@ -348,7 +348,7 @@ union kvm_mmu_page_role {
 		unsigned ad_disabled:1;
 		unsigned guest_mode:1;
 		unsigned passthrough:1;
-		unsigned :5;
+		unsigned:4;
 
 		/*
 		 * This is left at the top of the word so that
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8e853a5fc867..791413b93589 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1915,7 +1915,7 @@ static bool kvm_sync_page_check(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 	 */
 	const union kvm_mmu_page_role sync_role_ign = {
 		.level = 0xf,
-		.access = 0x7,
+		.access = 0xf,
 		.quadrant = 0x3,
 		.passthrough = 0x1,
 	};
diff --git a/arch/x86/kvm/mmu/mmutrace.h b/arch/x86/kvm/mmu/mmutrace.h
index f35a830ce469..2511fe64ca01 100644
--- a/arch/x86/kvm/mmu/mmutrace.h
+++ b/arch/x86/kvm/mmu/mmutrace.h
@@ -22,10 +22,16 @@
 	__entry->root_count = sp->root_count;		\
 	__entry->unsync = sp->unsync;
 
+/*
+ * X == ACC_EXEC_MASK: executable without guest_exec_control and only
+ *                     supervisor execute with guest exec control
+ * x == ACC_USER_EXEC_MASK: user execute with guest exec control
+ */
 #define KVM_MMU_PAGE_PRINTK() ({				        \
 	const char *saved_ptr = trace_seq_buffer_ptr(p);		\
 	static const char *access_str[] = {			        \
-		"---", "--x", "w--", "w-x", "-u-", "-ux", "wu-", "wux"  \
+		"----", "---X", "-w--", "-w-X", "--u-", "--uX", "-wu-", "-wuX", \
+		"x---", "x--X", "xw--", "xw-X", "xu--", "x-uX", "xwu-", "xwuX"	\
 	};							        \
 	union kvm_mmu_page_role role;				        \
 								        \
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 71d6fe28fafc..d9e22133b6d0 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -45,7 +45,9 @@ static_assert(SPTE_TDP_AD_ENABLED == 0);
 #define ACC_EXEC_MASK    1
 #define ACC_WRITE_MASK   PT_WRITABLE_MASK
 #define ACC_USER_MASK    PT_USER_MASK
-#define ACC_ALL          (ACC_EXEC_MASK | ACC_WRITE_MASK | ACC_USER_MASK)
+#define ACC_USER_EXEC_MASK (1ULL << 3)
+#define ACC_ALL          (ACC_EXEC_MASK | ACC_WRITE_MASK | ACC_USER_MASK | \
+			  ACC_USER_EXEC_MASK)
 
 /* The mask for the R/X bits in EPT PTEs */
 #define SPTE_EPT_READABLE_MASK			0x1ull
-- 
2.43.0


