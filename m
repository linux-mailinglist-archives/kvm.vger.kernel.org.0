Return-Path: <kvm+bounces-40998-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 87775A60225
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 21:14:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 311517AF341
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 20:13:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D7341FCFD8;
	Thu, 13 Mar 2025 20:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="H5fJqBMU";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="Y5DOks34"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE8691FCCE2;
	Thu, 13 Mar 2025 20:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741896653; cv=fail; b=IEN0kXSGt9IwfHO6Mvm7vIBKGk5PfewESvQiiRAfNvYB3bhTmQc1Mt7/NceCDADnGHOD91tiaUYEa0cM2qdBPMBSbyz1QnF3Jl9FNj3W1cznEdEutLl91mc3Nq78R4CEG0TJeOFOKGEpyXT4hbbzrVzXfD8rNUTqhSDDFYvjWWg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741896653; c=relaxed/simple;
	bh=cYaEIHGcBEWpdxnS81jAGRPB/SOFmRVNJL33W9malkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UAV8UhKGH/B1kw/5uXmCAbZuOmURIoLypH2O36RQne9UB35EX2vk2atEsnygITGIFjdwFzg8UjLsHeXIAmTaHJVFVxKkzQivcLypkdqi+YFIr3dlCayM9+w2nWl9pq03Kwl3fTzRh8mBJRkpR6n9ZnvhD76tvf1IfLhDVEEF+ng=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=H5fJqBMU; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=Y5DOks34; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52DF7uSx011175;
	Thu, 13 Mar 2025 13:10:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=PrAVqs36O6dyyCUvUmLOZKFg9f+e0nHxePbA47obL
	4c=; b=H5fJqBMU+DlAFw5LquCIS9k6OXDeIkvTQ+eAjb8JEoF8nOp15b5dn0iyg
	NtSHHZuZqWTCOJQg2s6AoGvycYF0adaMg2X6oEEvd7TVCkVV+hTsjWbNJ2XAm3N8
	cJKbrUqzEUb7xyHYYfNEVpUl133dkLYtSSVMF/Ht2jKusBewkQTiXHHh6otB0zQR
	6avHTqvlkyUOV4hWCHgPcxtK86GGzRtFlucWtk4H38Ui29eM4BDEvPH0usVCq9zL
	XbZSEezRTUHxpauwpKPp6u8svq+a0Tjeh3E0GLRYqfu9xGbqEykgGLCfhPoFDp3G
	H4KC0y+7yCdI1ma6oo78QEwbpWT9A==
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 45au9ge77b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Mar 2025 13:10:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bSbEZdJjdOU91UCPxHB87oYCErSrMYdx8Oi6zdZUxV6mr2VudG6GS1Z+P5L49oTCp44X91vM7qEd+bIo/WUHejFbEY1YKU1CaN8Jg4EoEhVdzcMOcgpNhws/Ss39Yv4ZA9aOGeDBN8Lx6SOIVCTb23A7n7I5GLEWWHfR8PkcqqFpmWavYRpZR5K5DQcOJBzeltWx5XSY5VYJccT5QcPd7nLfixQnICoYLlu7zZjpfGHUzPZB200fJBHwv9mAGFHpfMmHLd4l8YJHnbIsIk7Tvr9o5sdeWxUt1rTzvu0BKRmL2yAbzUPIujTVETFcAx/kkp+vVFK/3nCgY2L42nFzhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PrAVqs36O6dyyCUvUmLOZKFg9f+e0nHxePbA47obL4c=;
 b=DsegKk46AtXkFVmkarw0xiIRODCmqU5xOHVugi/+5mrbffHVC7KSnfIKr7E7lbrPBVSjgjDvnD1yJ21X+zgMEoew1WEOwP2L4548X4vGFe7jZY2Y246RkJDN38PdxL3Xiom04Wh8sW170ax16DcXCkFLTeziZuoB0RmdiJRDyu18BXAGD8NadixpEBIojXPLYNs/eiK0aKiJ+an3M7EGpxY9kI1drKAGuAX5Epl3yGNpSQsnqUpqV7gKOBCd7kGDEKVlJGo4AuMv/yH51HGO2tLlpdeDHwjeUxuIzzl7BBLW1eHs1cN3bm7My9BvOAsc8KlSI+PO3/J6lWwBIRCqZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PrAVqs36O6dyyCUvUmLOZKFg9f+e0nHxePbA47obL4c=;
 b=Y5DOks34BMQ/FxK+tnzdD/s38zO7evf42ULjiYPplEKbLN3yo+6Hl5sxqFlkbk7Q6lBvDfqIw5uoTcRslbmC0rS0Pg/BuIdDzs4G0rXvXK/MxmjXaFVE+076a20+IhJq8s4sOF3i1esJPDRUMAFZbpBKv466GYZHuHmeTMrXUKsMQdjU2+1tBhhZMD2YaORC30psb2X42/vMkrDKnfqN/5VUul0L1rJ/8C6HOpmzTCZLt5+mVMdmqjTKt9ptOM5uE5LFt0suuNZvN/JnXT73sAFNnNVIAgEtyrKG80DL+Z0EUPOwZJitVneO9ibHyyFI8o5gbQpXh3wYoKd4ZqtGoA==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by SJ2PR02MB10313.namprd02.prod.outlook.com
 (2603:10b6:a03:56a::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.28; Thu, 13 Mar
 2025 20:10:33 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%4]) with mapi id 15.20.8534.028; Thu, 13 Mar 2025
 20:10:33 +0000
From: Jon Kohler <jon@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jon Kohler <jon@nutanix.com>
Subject: [RFC PATCH 13/18] KVM: x86/mmu: Adjust SPTE_MMIO_ALLOWED_MASK to understand MBEC
Date: Thu, 13 Mar 2025 13:36:52 -0700
Message-ID: <20250313203702.575156-14-jon@nutanix.com>
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
X-MS-Office365-Filtering-Correlation-Id: c5dbff10-a3a3-4449-bf07-08dd626b1c62
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|52116014|376014|38350700014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aThiSHFwU0dzSTFaNE81T0sxVXFjWWdiSkU3R0lSVHVDZVJQN3NqdTB0MFh4?=
 =?utf-8?B?RWFJRlIrcnZGU1BYOFp6SVNpL3lTNkpJd0s4K2cvYjRpeVdlQVJwd2JXVnNq?=
 =?utf-8?B?dkw3aFpZZmdtTUxTRC9INzVqWVhDcFVkWTNIUzgzeEZ6TFJ6VSswNG9kbmNQ?=
 =?utf-8?B?aUFQZG5xcEtlc0xwTlFRVk03ZGpDYmhPVVpHQ0M0b1Q4T21YYVNLL09FamRD?=
 =?utf-8?B?ZVlXZU9KUGlQN3laVU9HMlc2T0JlVXVjMCtwZERVMDgwNTlhdVZqRGlacklC?=
 =?utf-8?B?QStUYUFDU1pxMEttcVhqQkJZaGlFazBld1hxWTFDWmpLVUFFWlR5ZExlT0JO?=
 =?utf-8?B?MFBKUVZrZ204UkljTUczN29aY2RucTBva1hDNUdyeWJpbkdiWGNiZG9YT0Rr?=
 =?utf-8?B?Qng5VkFQQ3Q4YUYxa0gvTERuVVpLUWs4cVdLalkzVWdaWGtFSjNCRVZYaGtn?=
 =?utf-8?B?eGxpeEhCeXRkNFNIcytyZUlCVEpXTmZyUmZ1Tmw0aVVTa1V1WVpXZENyNENl?=
 =?utf-8?B?ZExzNHpmV0svcFdaVDFYQjJRbkdwbG9HeFIrSDlEbnY1WHp5V0tHdkU3OUFq?=
 =?utf-8?B?WndOaG8rMkkxQ1VueFd6RjVzaUNjU0FuazdUVWJPTHg4QU1WaW85U1lVZXVv?=
 =?utf-8?B?bnZwWU8zYnZob2FDREcrZjlqZmZGTjdmKzV2NFF5WmY0NDcvdzErbzg0VTBo?=
 =?utf-8?B?YUNQc0MvMFV3NmJjUVgzMXRxL1MySld3NlpSdkl1ZDJhVko5WHZKemU3d08z?=
 =?utf-8?B?WEw0VjU4L0tzaGZuVjh6b1NvWDRQL3dCY1pQM1lSWFhYY3BvZ0h1ZEhjVUw0?=
 =?utf-8?B?VnJocGNrdlMwVDJGOXZlYmZFT1d3Rnd3bHpKQTZCM3VPYVBZNEtWTElEcERw?=
 =?utf-8?B?b1RnU2hheS9qYWE4Rml5SHhkWlhZNjhjOGxhWEhVaDdaOHlSenVONVZxTEU3?=
 =?utf-8?B?VkVTUFpZMFNPREVjeHRFL0ZEdTlkQzJHcVdPeDhTS1hlQy9CUzVwZzN3cjBG?=
 =?utf-8?B?OUYxclgyN3E3SnBTVDhjRkE3R3FNbFZwTEdvSlp4V21qVVZ6T0k4c1psY29a?=
 =?utf-8?B?ZSs5ZGVPQWE5Y3lmM0hZblF1OHdCWTg1ckxmeHVSN3NsNHk2K3dkZUxKK0dX?=
 =?utf-8?B?ZXdxUElSQlZxb3B3Tm1ydGNKbnRwY3JDOVVyakpFclpPRTUrNi9BTVpSSkUz?=
 =?utf-8?B?aWJSYm9OTnRLd3l4VVN4aXExNVVLZVhBWW93ZlloZVZsR0lUYVd5akY5WG9j?=
 =?utf-8?B?SXNZWldVZEE1a0gwcTArNlhFRnQ2Qy85WktSd0xWUTdpT3RiYXFMcWZIalpa?=
 =?utf-8?B?emxqWUlXUFM3U08yTzZ1b2dsR2h6WUE3dnArMCtNWk5BeEo1TjFmMjFrbjVC?=
 =?utf-8?B?bnpMenBDTGpwUkF1dnRGejQrY0lQUC9acUFBQTZaOGMvMXRYMG56dzFReHBX?=
 =?utf-8?B?STBQKy9tSWxFN0hqeGxNV3Q1VW41OWxtbWpNZzFPMnBkYlhUMnBRcHJ6UkR5?=
 =?utf-8?B?UE5MMktlaUNaZDVtdmNLUkQxb0RoakxCY0xWb3VyOURSMVJhMzdKaVV3YTcw?=
 =?utf-8?B?MlpiTjZnbXprRG9TOVdvV1VxMFBZajFxVWk5cHE0T0FTT1pzVFhTR0UvRkRq?=
 =?utf-8?B?ZUdVK2NYZzFrcTM1dDdsZzhwYW9SdUIwTlhGN2RvQU4rYWgzaWduVUM2TXQv?=
 =?utf-8?B?WEd4YUlIbWkxM2ovOVhJdXV3dEwydnpHOTdrL0oyM3o2TjQ4RFY2eS82Q2NM?=
 =?utf-8?B?NmFkNXBNcTI0WitKWERtb2hINXNvYW9nVEtwNFllYmFmS0dQUFJBNWhxRlJL?=
 =?utf-8?B?ZnJLQ09oYUJ6K2c2a0kxbEFuQU5pM0xYcjZ0bTJ3Q2dLU1hhelBhUnFEcXFq?=
 =?utf-8?B?Z1FlNGZKU0RJenJId3c0VDBsUmp3Wmd6dURZV2lKMzltcHpycEk2cDVmMHlE?=
 =?utf-8?Q?9Dyc37N9d1pRCkdXDBSXohsu2nJdgVGg?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(52116014)(376014)(38350700014)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VFBweHRPUFU5Y1pNZlNQLzY0cGh6UjMrM2w4d1lXc3pHQzN3RThMU3ZqcXBW?=
 =?utf-8?B?M1dCQXhkYnlicFBYbmM5Z3dRTGV0Q2ZHdWpBenNucmdQN0J5RkowbkRRQU12?=
 =?utf-8?B?TXp5VXBTd0IyTGh6R24zVERzTFU3cjdFczZRbnQzZ3IvQlh3eFVFcloxOG9k?=
 =?utf-8?B?Z09ucnF5VHBDVU9VWWgwZUdxNFFtN3lTOFIyc05CQUFiU3YxTG03RWQ2SmdN?=
 =?utf-8?B?M2JSS0JCS0VFUEdmMFFwbEV2TXVnZzRlZDVRRkFiZlpNRm0veFI3dXVscEZ5?=
 =?utf-8?B?RkRieG1YZ29LK2N5d0VZWUJZTHRDVHdlVUNxWTVwL0JvN1ZFOFl4MFVMZGJw?=
 =?utf-8?B?T2U4eXBNb0RScGpsN2xsRjFudUNXeE9WdXZRWTNkeWtGUTF0bXF1bDRWZTRY?=
 =?utf-8?B?YlV0OTJMeDdkZ3ZjVnY2WFNBaEdaWUFXczJsUExDcWpZYVNaaWF3dnVlSjdT?=
 =?utf-8?B?bGpScFI1MHZZTmhQOWQ3ejJ4clZoSXJPOXFmc205MUJTSlVtU0RGREd1S29S?=
 =?utf-8?B?ZmlZSzRaNy9JK3pvcEhuNkNFOVdKNyt4TlJpcHFsc0pvOGQrSkY4bkRzeDRM?=
 =?utf-8?B?UEE3VmZ2YTllTEdqU3c5eVlDM3dIWUFWbkttakVDM3RDaG9ocDJTZ0YrMXNR?=
 =?utf-8?B?N0cwd1JSbk5RQ3d0cDZVcFd0ZUFxNUZ1VVZST080d3R4b3NodytKWWYzZlYw?=
 =?utf-8?B?Y3BidmpDSkhaZ3Z3Mmp2V3h4MUxxUXJXVU56SUFnK1JHSCs3elNuNzU5dHg5?=
 =?utf-8?B?V2VNTW1wVnBNS3NKM2JncVoyYmNPTExXV1NSWFR4OERUa3Bsb2JLdGZ5emtT?=
 =?utf-8?B?WHZPclJYZlJuQWxxOUUyelFUYzhOaXdGbSs2TTJMRFV5RDJwSzlrUkdDVEpR?=
 =?utf-8?B?d2VESVZyTkRjdlQ0aWFSbG9ROCtVbHcvQmd0VGlWcDBNcUpQS1VSRTJnZmhp?=
 =?utf-8?B?aEpDRFJMTisyNW1hTndReGNrV1FremNNajNQZStld1BHbmRGSDdtNVlKd3pw?=
 =?utf-8?B?akNVQXF6MEU4dWFQUDZqNFpydkpoYTVSRm5XZDNmSU1qbkkzdlAyS2dOallZ?=
 =?utf-8?B?NThDZDBJTklmVWx3dGkwSmxHT21GK3drbW4yajQzQzl4S2lvaDZveVNmYWF6?=
 =?utf-8?B?L00xYW1PN1J3WUhJTkZzMi9wT2FCeGdGRW45WDFNcDYxa1M5aE16K3pXQ2NY?=
 =?utf-8?B?S2RNSVZvNzZaZFZQcUJrMEpXOE12aVV6c0pWSnRWZFI5UkFKZ3hmNVVPZWYy?=
 =?utf-8?B?K0g4MEhOcnBzWi8vcGdNbWl5Nm1nc1ZjWTBqSUpETDNBSitkc0lteFdhNGFt?=
 =?utf-8?B?UXJoN2lLK3pVb1JCNnpwMWJtOEExWVQyMlZzMjkwbkllR1BIZmhIZTFWaTZL?=
 =?utf-8?B?S0tiUXBMR1dYOU1YSXJuL0RxSlhOVWV0U3ZCMERiUC81d2hpZ3l1ZUxWaVN2?=
 =?utf-8?B?QXNPQ1JuODg1UmsxcEtHejVzaUtuRDFZWHBEWDFINDNUdGJBc21hZFpOMVJK?=
 =?utf-8?B?Ylpqbm55eHhmNHNZZkhxbFd3WFl6Z3I2WFgxZEUyanpZeGRUU2I2Wm44SzlC?=
 =?utf-8?B?TjV0RzBhRER0WVpvU1Y5NkVYbkVUcXAwTlVvTjRhdWV2ZlNvTHU5UTJPaWh5?=
 =?utf-8?B?WGw5cnlad0hnN000eDQyWndjN3lDTmQzbmwrcGRVTTFyQllXMEc0cThhbDI2?=
 =?utf-8?B?a0o0TVI0WXJZdTNpejNEaEJXNW1lemplRlZHMDRJbkd4MmlxcVhFODA0L3hs?=
 =?utf-8?B?UENzOHVhTjhJQ29GWEdVdW1nOGZVWVF2cnlQQS9TQkdiU282bGRMdjNjc3N4?=
 =?utf-8?B?WEJ4RGdDTFBGUnd4aWkxcnUxRHlZYjgzN0tkTUVYTGxhdm5tTU9OQWRwTmly?=
 =?utf-8?B?MWJHZkh4Sk1leml5UUxUdytFYkU5TTNsZjhzZmFYWTJZU0phR01LQ1Jtb3F3?=
 =?utf-8?B?dldZRVlMU3owMGE2aklGSHFkNGdlRHY4andyc1haNkw5ZmZjYUtHeGZQdm01?=
 =?utf-8?B?R0VwZnhXSkw2SC9TaFZPSnFRNXpEYVRMYlE2NGs0b0VKdUxLVnZDT01FVFli?=
 =?utf-8?B?cEZJLzFFS0NaSi9qUEJkUGREZEF4emdQbThtN2pYZWExL0dyZkEzNVJYdHpJ?=
 =?utf-8?B?V3VOTERTUStxWFlhbmJDL3hkR1VRblVpZnV4akF5Sk5MS0hncmtaaHRWRE1r?=
 =?utf-8?B?WEE9PQ==?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5dbff10-a3a3-4449-bf07-08dd626b1c62
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2025 20:10:33.5075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vrZNUWCPhbFkitC3ZPFGi9F3HLriBrGsXfxxTERrVuu4e7WLSZM2vMMyWHiH0JqU4KqcOgvzyM+dPvvxGQVJkOEfvpGmEsASAPnn2kEKJlU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR02MB10313
X-Proofpoint-GUID: zNsu_94UoCkRBKeJ6mGG-_pnoTdmZuL6
X-Proofpoint-ORIG-GUID: zNsu_94UoCkRBKeJ6mGG-_pnoTdmZuL6
X-Authority-Analysis: v=2.4 cv=P8U6hjAu c=1 sm=1 tr=0 ts=67d33bbb cx=c_pps a=nskeBUqQUen4dZUz4TdP1w==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Vs1iUdzkB0EA:10 a=H5OGdu5hBBwA:10 a=0kUYKlekyDsA:10 a=64Cc0HZtAAAA:8 a=nzs-3BIrxdw4r6tGY40A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-13_09,2025-03-13_01,2024-11-22_01
X-Proofpoint-Spam-Reason: safe

Adjust the SPTE_MMIO_ALLOWED_MASK and associated values to make these
masks aware of PTE Bit 10, to be used by Intel MBEC.

Intel SDM 30.3.3.1 EPT Misconfigurations states:
  An EPT misconfiguration occurs if translation of a guest-physical
  address encounters an EPT paging-structure entry that meets any of
  the following conditions:
   - Bit 0 of the entry is clear (indicating that data reads are not
     allowed) and any of the following hold:
     — Bit 1 is set (indicating that data writes are allowed).
     — The processor does not support execute-only translations and
       either of the following hold:
       - Bit 2 is set (indicating that instruction fetches are allowed)
         Note: If the “mode-based execute control for EPT” VM-execution
         control is 1, setting bit 2 indicates that instruction fetches
         are allowed from supervisor-mode linear addresses.
       - The “mode-based execute control for EPT” VM-execution control
         is 1 and bit 10 is set (indicating that instruction fetches
         are allowed from user-mode linear addresses).

For LKML Review:
SDM 30.3.3.1 also states that "Software should read the VMX capability
MSR IA32_VMX_EPT_VPID_CAP to determine whether execute-only
translations are supported (see Appendix A.10)." A.10 indicates that
this is specified by bit 0; if bit 0 is 1, then the processor supports
execute-only transactions by EPT.

Searching around a bit, it looks like this bit is checked by
vmx/capabilities.h:cpu_has_vmx_ept_execute_only(), which is used only
in kvm/vmx/vmx.c:vmx_hardware_setup(), passed as the has_exec_only
argument to kvm_mmu_set_ept_masks(), which uses it to set
shadow_present_mask.

I'm not sure if this actually matters for this change(?), but thought
it was at least worth surfacing for others to consider.

Signed-off-by: Jon Kohler <jon@nutanix.com>

---
 arch/x86/include/asm/vmx.h |  6 ++++--
 arch/x86/kvm/mmu/spte.h    | 13 +++++++------
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 84c5be416f5c..961d37e108b5 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -541,7 +541,8 @@ enum vmcs_field {
 #define VMX_EPT_SUPPRESS_VE_BIT			(1ull << 63)
 #define VMX_EPT_RWX_MASK                        (VMX_EPT_READABLE_MASK |       \
 						 VMX_EPT_WRITABLE_MASK |       \
-						 VMX_EPT_EXECUTABLE_MASK)
+						 VMX_EPT_EXECUTABLE_MASK |     \
+						 VMX_EPT_USER_EXECUTABLE_MASK)
 #define VMX_EPT_MT_MASK				(7ull << VMX_EPT_MT_EPTE_SHIFT)
 
 static inline u8 vmx_eptp_page_walk_level(u64 eptp)
@@ -558,7 +559,8 @@ static inline u8 vmx_eptp_page_walk_level(u64 eptp)
 
 /* The mask to use to trigger an EPT Misconfiguration in order to track MMIO */
 #define VMX_EPT_MISCONFIG_WX_VALUE		(VMX_EPT_WRITABLE_MASK |       \
-						 VMX_EPT_EXECUTABLE_MASK)
+						 VMX_EPT_EXECUTABLE_MASK |     \
+						 VMX_EPT_USER_EXECUTABLE_MASK)
 
 #define VMX_EPT_IDENTITY_PAGETABLE_ADDR		0xfffbc000ul
 
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index dc2f0dc9c46e..1f7b388a56aa 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -98,11 +98,11 @@ static_assert(!(EPT_SPTE_MMU_WRITABLE & SHADOW_ACC_TRACK_SAVED_MASK));
 #undef SHADOW_ACC_TRACK_SAVED_MASK
 
 /*
- * Due to limited space in PTEs, the MMIO generation is a 19 bit subset of
+ * Due to limited space in PTEs, the MMIO generation is a 18 bit subset of
  * the memslots generation and is derived as follows:
  *
- * Bits 0-7 of the MMIO generation are propagated to spte bits 3-10
- * Bits 8-18 of the MMIO generation are propagated to spte bits 52-62
+ * Bits 0-6 of the MMIO generation are propagated to spte bits 3-9
+ * Bits 7-17 of the MMIO generation are propagated to spte bits 52-62
  *
  * The KVM_MEMSLOT_GEN_UPDATE_IN_PROGRESS flag is intentionally not included in
  * the MMIO generation number, as doing so would require stealing a bit from
@@ -113,7 +113,7 @@ static_assert(!(EPT_SPTE_MMU_WRITABLE & SHADOW_ACC_TRACK_SAVED_MASK));
  */
 
 #define MMIO_SPTE_GEN_LOW_START		3
-#define MMIO_SPTE_GEN_LOW_END		10
+#define MMIO_SPTE_GEN_LOW_END		9
 
 #define MMIO_SPTE_GEN_HIGH_START	52
 #define MMIO_SPTE_GEN_HIGH_END		62
@@ -135,7 +135,8 @@ static_assert(!(SPTE_MMU_PRESENT_MASK &
  * and so they're off-limits for generation; additional checks ensure the mask
  * doesn't overlap legal PA bits), and bit 63 (carved out for future usage).
  */
-#define SPTE_MMIO_ALLOWED_MASK (BIT_ULL(63) | GENMASK_ULL(51, 12) | GENMASK_ULL(2, 0))
+#define SPTE_MMIO_ALLOWED_MASK (BIT_ULL(63) | GENMASK_ULL(51, 12) | \
+				BIT_ULL(10) | GENMASK_ULL(2, 0))
 static_assert(!(SPTE_MMIO_ALLOWED_MASK &
 		(SPTE_MMU_PRESENT_MASK | MMIO_SPTE_GEN_LOW_MASK | MMIO_SPTE_GEN_HIGH_MASK)));
 
@@ -143,7 +144,7 @@ static_assert(!(SPTE_MMIO_ALLOWED_MASK &
 #define MMIO_SPTE_GEN_HIGH_BITS		(MMIO_SPTE_GEN_HIGH_END - MMIO_SPTE_GEN_HIGH_START + 1)
 
 /* remember to adjust the comment above as well if you change these */
-static_assert(MMIO_SPTE_GEN_LOW_BITS == 8 && MMIO_SPTE_GEN_HIGH_BITS == 11);
+static_assert(MMIO_SPTE_GEN_LOW_BITS == 7 && MMIO_SPTE_GEN_HIGH_BITS == 11);
 
 #define MMIO_SPTE_GEN_LOW_SHIFT		(MMIO_SPTE_GEN_LOW_START - 0)
 #define MMIO_SPTE_GEN_HIGH_SHIFT	(MMIO_SPTE_GEN_HIGH_START - MMIO_SPTE_GEN_LOW_BITS)
-- 
2.43.0


