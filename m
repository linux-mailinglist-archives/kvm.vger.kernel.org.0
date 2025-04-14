Return-Path: <kvm+bounces-43281-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 87B3AA88D6C
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 22:54:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DC63A16A91C
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 20:54:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A8AB1F0E58;
	Mon, 14 Apr 2025 20:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="R/I66txM";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="NDnR/lKm"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2631EDA04;
	Mon, 14 Apr 2025 20:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744663990; cv=fail; b=gwoFq+NG2z62V/snIDraf6kIZGFytCP9YsWiPWKCxpGAptyzrJSiKDYVY5TXdlyQotvxXACngOYJvF3ZVEa5oYjGkbdk4fjyh3D3lE6jq+BqnQj0H0ueHcWl1dI+tTLHI3lMV4y3h9zeNsHjnsMwGdaRiOUY97I2TC0drUeJA3U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744663990; c=relaxed/simple;
	bh=gEzFNqPblSxNomUAnu1GIXb5N4O0IeiPsTFJx0EJjXo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=c2bULUgESdrBK+t7Ay9fA6YujQcTB7W+fwvqiHSPg3LPBKKRS/rZQmeB9oT109+R6W7QFun/cI978dpEKSsI7mYX6VPf4dQyQfJ9MEd3qtCwpPOg4ogOJEGLp2Xx3WFUYcaUs9+n0NjYwG+EnUIcfEHg3mFqE/hV9KN7PrJOnZQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=R/I66txM; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=NDnR/lKm; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53EKodpX032240;
	Mon, 14 Apr 2025 20:53:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=PE3WmDVCTck5OUumrx130mMle7/FVSLefYIA7andqL4=; b=
	R/I66txM13tNUyc1LnSn4wtzU7ZSX7a+raGxCeWbwiBBnO16JSdEleM3T5bjCdtW
	hY2fdeq83mnY4IcHSGNGpmKPMEZq+hrE+38hz/lx9wKz4nFrKOkL5n96cdXxSsZQ
	u7/MHC4V8AUE4Dr4eEVumSaNiVy5hXlmrNw0z7end4DtUIoZanRTDzPoAvFfSo/G
	aYpUuinSTUsYQywHPPGu8mKivgnbmOFLs9GcmPeNpaRJG4HgkBpX4iKFkfe9W72Z
	f6Q0xvHmQF5oK9L8ZFnrvqXnFmFWDdMoXcJ/hoQnEWd4FgMZ+JGAaQYP/ffcu0uA
	vCwO/dDE7Q9m7/jnjQwpjA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4617ju89vn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Apr 2025 20:53:03 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53EJ0XnA038821;
	Mon, 14 Apr 2025 20:53:03 GMT
Received: from sj2pr03cu002.outbound.protection.outlook.com (mail-westusazlp17013075.outbound.protection.outlook.com [40.93.1.75])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 460d4qa9w4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Apr 2025 20:53:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wczLPT9yPqDV0qgzgj5MPGFfH3M1GSUeZ/2ln/M7dsXQUmlCMXX6Cl8IyIKoQHqXNhuycw7+KDoHyy+9Br3bs+KS8sXsELVsjUB57MYsLkHryfQFIqzTGhJz+R/DS/sr0sMwFYWiQcna82hIXl07xc2CNWb1OdmEglSI+QQvuKs7BG2wdVlim4UsEYJPSCBQeYOJKf/6dr/8JsNxVVfiZ5dH+rF7lpv0avz7YCOjWJvdIyTQcDiaTEOPU+4j+JCT7K3IGHgzzONiuWc/m7AtjIYcobQEfVS36nFMn5iL+4pCAOiZTBGi7KHtkypzfvfrBTIcCTLEnkINlo+DOLJ4TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PE3WmDVCTck5OUumrx130mMle7/FVSLefYIA7andqL4=;
 b=lUJpYbcrQ7Jtcv7OHnRpiSYMmOE00yzzFgybXz0oNgRlkVh6FWoJ7omNTYgCy5ih19xwIqIKIsFK4pLcUjwaMEaXKm4qxq8O6y6nOeaNhEfGuQ2Hh/qND+irUJDK/J+miPz5/6lOLfDbZnFELDQM706Y7NN6uGLo1X/SArZt1NUKDhHDcNopI/iJdUG/XYmOBqnpm41VLVwRvy33naHKrjMv+FO2Dh6A85+PYRxs6Z23MJsDaDSFpqrfWVeFyYdwVsjoU6okV5wYTO4R8Mp1ULzdBvkxXYJV/qOUmj+BCguINutMcfFXM+7AfIUaGz4QJl6umrTxUGn0++BSPl/RfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PE3WmDVCTck5OUumrx130mMle7/FVSLefYIA7andqL4=;
 b=NDnR/lKmv0FilbhqJr5sFLaaodVq64Qa5uEeBp8zIjyFJVNnKWrc1rSSUJLkd1Hy3ANmpcnXZC/QEUU/1IHSH1rmrKthVzdHgqw462YOwJZhHGjOUcc5pSmWpUsJKbMoMaMhFCjVRLZe0TpYyJwKXPmQFkLRcp7FRr2PBPko36E=
Received: from DS7PR10MB7129.namprd10.prod.outlook.com (2603:10b6:8:e6::5) by
 PH8PR10MB6526.namprd10.prod.outlook.com (2603:10b6:510:22a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8583.50; Mon, 14 Apr
 2025 20:53:00 +0000
Received: from DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::721c:7e49:d8c5:799c]) by DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::721c:7e49:d8c5:799c%5]) with mapi id 15.20.8632.030; Mon, 14 Apr 2025
 20:52:59 +0000
Message-ID: <c096c9d6-98f2-41f1-be9a-49ab9b2d5398@oracle.com>
Date: Mon, 14 Apr 2025 13:52:56 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 9/9] vhost: add WARNING if log_num is more than limit
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: virtualization@lists.linux.dev, kvm@vger.kernel.org,
        netdev@vger.kernel.org, jasowang@redhat.com,
        michael.christie@oracle.com, pbonzini@redhat.com, stefanha@redhat.com,
        eperezma@redhat.com, joao.m.martins@oracle.com, joe.jin@oracle.com,
        si-wei.liu@oracle.com, linux-kernel@vger.kernel.org
References: <20250403063028.16045-1-dongli.zhang@oracle.com>
 <20250403063028.16045-10-dongli.zhang@oracle.com>
 <20250414123119-mutt-send-email-mst@kernel.org>
 <e00d882e-9ce7-48b0-bc2f-bf937ff6b9c3@oracle.com>
 <20250414143039-mutt-send-email-mst@kernel.org>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <20250414143039-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1P223CA0024.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::29) To DS7PR10MB7129.namprd10.prod.outlook.com
 (2603:10b6:8:e6::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB7129:EE_|PH8PR10MB6526:EE_
X-MS-Office365-Filtering-Correlation-Id: 334138c2-e164-4351-78e7-08dd7b965719
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UkM2cVppRTJSYkhEbXZEOEhxNnk5K2JGQzkxeW5IV3JwZ1RzczA3RVIyWmtI?=
 =?utf-8?B?Z0k4RHd0MjlhOGdORituN0J6MzVmYm9pS2NjUlRERG5MQ1AxcWVXaDBYZmJC?=
 =?utf-8?B?QkxiZ0VMYmJrbXJZYWRUdzVWRDJwTzNWcityMkEzdjFGdlV5ZExtSGcwVS9C?=
 =?utf-8?B?K3hRWGZJUzZCakcxQUROTzJVMkE5QXNFTmxOV3VqcUVmL2E4WWxJVUVOOUxB?=
 =?utf-8?B?bmdxS0hUYUd2WDM1ZTBnTUIzcWZ5VHV5RW9tenF5V2Nvb1JrTlR6VCs3blNL?=
 =?utf-8?B?WnBCODZWaWZ1RWprU0lQVG1sRlNkZDVuU0J6SzBrUi9vNVUzcmY4SUFYS3Q2?=
 =?utf-8?B?a2ptSGxEb2Y4RWU3T3RjNk9wUmxNK3R4VDBIMmg0NE9vRzBCMHpVSlJKeFZR?=
 =?utf-8?B?QnF4REx6bjRBR0tUelY0U3dwSmlwWTdROTRXa2phZU9VNTFVb2NVb3c5bGtC?=
 =?utf-8?B?M3lJeDNQS2dKL1VmR2NQQytZMEtrc1F0Wmp0MTF5NEsvcmRBL2xSUUQ0ajFP?=
 =?utf-8?B?Q3I1c1o1L0lQSkVrcGt4N0RHN00zcFJ1d25VRWFCOGk4NXZ4djhhaC85ZTFW?=
 =?utf-8?B?SDhuM0V2Z2d6VndQeUpEUXQzUHBKUkpCQ1dEUzRFcmtSNEFOdU9DVlFHWFUy?=
 =?utf-8?B?dVdURG00U3hJWlJHUnBZbWxWbjBUdHBuS01KbjNSRDB6eEE2TnpBOXM5K3lO?=
 =?utf-8?B?bzRtL3BvRVk4bW1Gc2lncGVxdmwxUk9ROVAzaFk5MW1sWVgyZDhHSVV0Rit0?=
 =?utf-8?B?aHNiaTU1ZmhGT2g3NnlYQTk0TWpIa2tjeUdmZThxSlpPdDZUSXRRd21FSy9D?=
 =?utf-8?B?T2xXTXl6RWlYZjNOVGxRdE1DZktnbU14cllLamRZNmVXT2V6SHUwOUw2Uzdw?=
 =?utf-8?B?SG53enlGTWN0b3IzWG5OdEZJSzF2cW5zMzJtam5UaFFCN2hWUWpMbDRMOTQ4?=
 =?utf-8?B?NnRnc3I4QjdmSFdUdmYrazlaSjl6TGxNZnU0K1JCOStPT2hWV1lPNmdMcVll?=
 =?utf-8?B?aE1mU040THoxZytIUXFrQXVORE1iaDVzY2hMeHVmSnA5QUpqVW9HL0dEd2or?=
 =?utf-8?B?a3RsZGVXYXNrUGNqK1NkNlVUaXNSaDc3QlhJWWhhSGEydkdBb1RGYU1BK3hN?=
 =?utf-8?B?ZHNCMldOU04zcllhdzExRDQzVUpGUHpFWkh0UTYwdHdzaE10RzBYbURjTFJ5?=
 =?utf-8?B?MXMzNVdTOWFoU0oyb2hxTHhkY2NORHY1U2hKak1SZ3VWaVJsZk53Z1ZEUDMr?=
 =?utf-8?B?dURtY2FuQVh2cW45ZTFiTFB0czRPQnpncVFET3Fsa2l3NG5FZDkyL3Rsc2lk?=
 =?utf-8?B?TXFUak5nRDhyaU5pcGFMNTdKS0dFamlTcDNXOTFTRmRjV1gvM2lCYkFDR0NP?=
 =?utf-8?B?N2czSXNvdGx6WXVjYTVTWE9OdTJCa0pPTlBqbXNsUWh3dFlpZnRNcEFrcUF4?=
 =?utf-8?B?bEI0cGhGekt1czAvUEFyMXlXdkg0OTdoaHVHaHgzWU1ISFRTT1NpVUtnN3J0?=
 =?utf-8?B?cjF3UWwzUW0rQ0lPSEkvMVB0T1E4YnB1eWF6NmpqOFVuNVlYLytzNWZQbVRB?=
 =?utf-8?B?OUVYUVRPN1BGYWNaM3UvaXI0VmZPY0F4STN2blNZUEFhZTJjbEVYVEpBTVFa?=
 =?utf-8?B?NEJpU0xsZjM0YUhha2FWV3h6UFVneTh3M2V2ODF0VmdSYURoS3JZQUZWd05v?=
 =?utf-8?B?cjQ5K3ZrYW1TbmtoSzUrMGc5ODBkVGo1b0hNTXg1UFp0cjZpTnViTVd0N1VM?=
 =?utf-8?B?aXAzTXZsR1BCbjdDSXY1T2MybW53cElkMkF5aGduVHg4RGdmbWVHUHpla1Rr?=
 =?utf-8?B?SFIzdmlFbHI3MDhGemR0bWhYUi9JUnZYWDY2cTJNTmZReU1MNHpXZDJyYVI2?=
 =?utf-8?B?K3ZrVjBXSTdaai8rTE02NURWMldjeDlPdDJiTFhSeExaUGxiL2hMaGptbzNs?=
 =?utf-8?Q?oOzWZBhHWnA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB7129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Vk80UVA0Wk1JcDd5dkNrcHRIU3pFekdLbzZmclBqem5wNVZNMDlFd3dwTmdB?=
 =?utf-8?B?NTVTdlZXZG5NMUdaNCtlQ2pxMnJTa05zRjdxODZkZG1uSXJ6L0NDL09zcHkv?=
 =?utf-8?B?ZTV5T2FYT3ZJNTJXcVl4dUp2Y1B2N1ByWElUVFFaOUM3V3RkdUs4UFljYmlF?=
 =?utf-8?B?b3NZNzNqZVVJSjV0SXQyYnFHb1Yvc2xlMTJON3RWWkpOcS9sYjJRcDNhQ0gz?=
 =?utf-8?B?b3UwWjB6UFY0SUVDUi93RDdLUXVHbHBPUFFiNnR5eGZQSlZjaWl6akUrSnA1?=
 =?utf-8?B?M1NFYXZkRERSdVJmS1A5cCtvNjQ2YSt6R3FxdzVYS053QUMwenY0aWtjMVhl?=
 =?utf-8?B?UitiZWs1dnZhcTdraGQ4dDcyZkpFdGNjVDRvU1Y5WnBsUnhiMXI5NUhaek84?=
 =?utf-8?B?ZWJPY3kwbHY2NENoenRDeGtNWXUxWm1ZRlhDbE9RR1ZyT0E2Uy9DTFZ5UjFQ?=
 =?utf-8?B?YmMvQ0FHekI5MWlGYmFpTEgyYnI0S1dJQ3k5cG1MUW96MmRKdVdlU0tYR2xk?=
 =?utf-8?B?SUp4U0xuT3diUVQxRUhCSnhVaUtwRjMzY0dKblQ0WVQ2UVZOakduVE1tcGZM?=
 =?utf-8?B?WG96QldJcWZOcU1iVG05WWUybExzeUUwdy8wOTA0Tk02eVZBSVJxdGhMSTRG?=
 =?utf-8?B?akhTd0Y5d1RSWnZrWkhEYjBnYjlnWThlZHQxMW83QlFrU3htalFZYmpXUHdl?=
 =?utf-8?B?V3R6R1l3UXlhS0hsSnQyQWpYNUhkNVhqMGVqaGJzVGQzbkZIbU9KTS9zenFl?=
 =?utf-8?B?TC82OVNUZFJEeFF5UnBZbEdwR1l5RW5INmN3VDNDYnliVXJ1N1NqUGEzS3hk?=
 =?utf-8?B?aFpFbEkxd2V0K3Avd3FtQnROamQrZGR3aEdtNG1nelN1S3JCRFF5T3k5V003?=
 =?utf-8?B?NWU1Zk1TNjdNbE5yaTBuTzdjRk9VUTg1TlhNMCtyakNkdjJOS29FOG95QU8z?=
 =?utf-8?B?dzFNSEFCQmhqYzF4MVMrYjdUdGkreHhIM0VOak9aL0lTTFNhN3dCRHZjVVJn?=
 =?utf-8?B?NXpCVjlXMUZrdUY0Z2NrNVdnWlBDdnFhMUZnQVdiaU03azZvazZ0bmJvQmhx?=
 =?utf-8?B?b0hFQThoMWd2WU0wVmRRUUd0R3FVQzBhcmNFcE1hcVBvSXRkeDhSUVFUYU1o?=
 =?utf-8?B?NVpwTUdMQ0lJeHBqSkJxOVdNQ3FuNmxGNEZDaldiT3owWXk4Y2hwNXptMUlF?=
 =?utf-8?B?aW5hRVJOamN2amV6OE03NG5HM1dMdHBNTGorUU01K1kyTFhvZVJDVmpodjZX?=
 =?utf-8?B?ZERwUHFaeXJmTlNkak10ZjZjTFdNa0loRGx6cUFQNVdWS1BUM3dCaUFpdmNU?=
 =?utf-8?B?S2RNUW0yYnlBdGFTTjBqaGF2U1liYmlmcFkvTE9IMC9GbVRpMXVwR3J3TDB6?=
 =?utf-8?B?SWNyTUpIUlBaODRwM0NzZWduOXMrU3RUYXBQcmtxdytPNUJUOWliZk40YStk?=
 =?utf-8?B?SmFUaGtCN2F3QUtlbm83VEhYSGtJdjEyb1Fxd0JKcXl4N1NJN2pOSjNnM3FI?=
 =?utf-8?B?ZitaUnlrL09RYUsrSG9ZNDJVZjBDMXQzMUdRcW9qRGI1RVFRU3dhY3VEakdY?=
 =?utf-8?B?eGl2REVMVjhRRkI0bG50c1VGd2R1aldkMjVVY1d0TlhyMklNZnNvVU0rck1E?=
 =?utf-8?B?M2FjNVkwK2tmSWNNMHJXajRwaFd5YUw2T3h2aWJuUmpsTG1DZC9CUUdLd0pk?=
 =?utf-8?B?cGQ0cFRWNzVVQjd0QlVmeVE1bkthbU5ENUIwd2FMWXdqSk9OUVRnZXJSK3pV?=
 =?utf-8?B?ci9ScU03YWN2WlEva2V4bDdoR0s4OEFLS0hmVDkrbFdCcGs2aFJ5VTB2UWw5?=
 =?utf-8?B?R3RBOFNWTmx6bFJsMk1VQ0EwMytwdEc1c3o3a0MrbCtWNWVOTTRBcDNuWU1R?=
 =?utf-8?B?dVhKb1Y3enpHNk16RllteTZmU0hDOEVDdVlNN2t1RW1zQTgwUEZVQXd3cEFy?=
 =?utf-8?B?dGd2NitOZzQwc3lzTG44RHNwdm5ZbXZPRUEzeG5XYmpmb3djMmJvMFlkcFRH?=
 =?utf-8?B?eW5PR0JJa0pZYThNZ3JzUFlzdDRDbzFDWm8rNHRmb2RKSlp2MzZSeWZlcVpG?=
 =?utf-8?B?UENYOUtJSU5CWTJPa01DV0VwNUtkL1Nrb1diMlNnZkw3WDRzSmdPN2piVTJS?=
 =?utf-8?B?T1RLdXJ3UUNNdnYxTllwT1JFNW5OWG03by9EUlpKMXRlYzNjZkRaQVd5ZTBn?=
 =?utf-8?B?NGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GWdGQLDsJT1v7fxNfyPLHjhJUZBKt8acrvI/RtDEtZniF/7cDMafU/n4aqagB+tKnWHyBnroXjrNPJPcOOhjk6PjlNCeB0K9VgvtwZ9HAAVl2GMeuLdHwjkW7Y/EKzEwlourWHsBVlhI3UKwjZjzGSgI+LMCrHLA/ni/tj6oQuIFeBJrDo+RnBJPJWY6YcNU9cYigcQEKgDcQU+yA1DMGPhrw6MgyQTyZwqWjqu0KlV89oVR1999OrldYu6ZPtGY8x8eT1Qbhq2VtYBnqJQubJ2J9uXmwAJklE06eZbkaP+B4M+RkuFt9GtY4jShyGpBU5U568vW1LAMoOd/Dvvrj74l3eQp3AJFpv3SlD9fvYqDuyXQf0iyA0HIDjofdd5OKthp+AvYIFzoY8U6ulmAikEIiPWAVQTgqyYRITlIA+HGSrpd0SpnnRSEAsgjkbVmKEYUAq2dXXYPFhO1uOjTD1OSow8jtE09L+mtb7bDFAICQppqwhOEdUymclJ4CNbxw5mZy2Y74s6vzA5b+giZkz8YBRftJ9SVr8Uob9/zuFI7FsSn/KHeNzu/RUSkviGBY2ifLtjezNWy/CkNR2/93zM5iRqshyyv/MRzsOnh3xE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 334138c2-e164-4351-78e7-08dd7b965719
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB7129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2025 20:52:59.5236
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 72abmlB73OPgeHkCXZSY7slpkuB1W+ROkjX3EcRCmt+u5NjOlU83uWKFm1SJns/DFDV4BR7NPJmI/eSdFuJwKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6526
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-14_07,2025-04-10_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 bulkscore=0 mlxscore=0 phishscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2504140152
X-Proofpoint-GUID: qh5AJsON1eoiVtRODXbYr2L8I80UZRc8
X-Proofpoint-ORIG-GUID: qh5AJsON1eoiVtRODXbYr2L8I80UZRc8

Hi Michael,

On 4/14/25 11:39 AM, Michael S. Tsirkin wrote:
> On Mon, Apr 14, 2025 at 09:52:04AM -0700, Dongli Zhang wrote:
>> Hi Michael,
>>
>> On 4/14/25 9:32 AM, Michael S. Tsirkin wrote:
>>> On Wed, Apr 02, 2025 at 11:29:54PM -0700, Dongli Zhang wrote:
>>>> Since long time ago, the only user of vq->log is vhost-net. The concern is
>>>> to add support for more devices (i.e. vhost-scsi or vsock) may reveals
>>>> unknown issue in the vhost API. Add a WARNING.
>>>>
>>>> Suggested-by: Joao Martins <joao.m.martins@oracle.com>
>>>> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
>>>
>>>
>>> Userspace can trigger this I think, this is a problem since
>>> people run with reboot on warn.
>>
>> I think it will be a severe kernel bug (page fault) if userspace can trigger this.
>>
>> If (*log_num >= vq->dev->iov_limit), the next line will lead to an out-of-bound
>> memory access:
>>
>>     log[*log_num].addr = vhost64_to_cpu(vq, desc.addr);
>>
>> I could not propose a case to trigger the WARNING from userspace. Would you mind
>> helping explain if that can happen?
> 
> Oh I see. the commit log made me think this is an actual issue,
> not a debugging aid just in case.
> 
> 
>>> Pls grammar issues in comments... I don't think so.
>>
>> I did an analysis of code and so far I could not identify any case to trigger
>> (*log_num >= vq->dev->iov_limit).
>>
>> The objective of the patch is to add a WARNING to double confirm the case won't
>> happen.
>>
>> Regarding "I don't think so", would you mean we don't need this patch/WARNING
>> because the code is robust enough?
>>
>> Thank you very much!
>>
>> Dongli Zhang
> 
> 
> Let me clarify the comment is misleading.
> All it has to say is:
> 
> 	/* Let's make sure we are not out of bounds. */
> 	BUG_ON(*log_num >= vq->dev->iov_limit);

This is a critical path only during Live Migration is in progress. So far I
didn't encounter any issue for either vhost-net or vhost-scsi. That's why I used
WARN_ON_ONCE() instead of a BUG_ON().

I agree with your point on "unnecessary pointer chasing on critical path", I am
going to remove this patch in the next version.

Thank you very much for feedback and suggestion!

Dongli Zhang

> 
> at the same time, this is unnecessary pointer chasing
> on critical path, and I don't much like it that we are
> making an assumption about array size here.
> 
> If you strongly want to do it, you must document it near
> get_indirect: 
> @log - array of size at least vq->dev->iov_limit
> 

