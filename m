Return-Path: <kvm+bounces-67079-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 201E7CF5811
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 21:22:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 570DD30341F3
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 20:22:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A498339863;
	Mon,  5 Jan 2026 20:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="okg8Lu33";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="uX/njnoR"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B16320A2C
	for <kvm@vger.kernel.org>; Mon,  5 Jan 2026 20:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767644564; cv=fail; b=lwakQh+wkr15fyw30BPq47VKIsysNNvMQ/DW4zJVvAlL+uxC+ShAwYaEKX7KuiQ+adbz/OExO4HVNaUwOOXyiZMxiF7TpaICKK/+loWUVBP2DrLxCbUwxj7gAtjkZRZRivyzfGfpEP40hJB9ksAGrpmmIm+UNNCNb5s6on9xwqA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767644564; c=relaxed/simple;
	bh=K2hloW/0qoSwLteMmm8FHOa/KGRlZ5ZJmyMn1pDMs4c=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Ne0AGIcemi4z/fJKnN4DKjevgE0himv6wn1jIAXIXk8HFYYNR3I3rQNX+IJ7OzHDQNw2hyjXin9XPNLy+tQQbDclVrZYS+e8D3CVYDrLsWixhb89Byk5V70s30hTyVJ78rQSlOWmyB7dUPPr+HyPQbR46VaQZoV9Lrw9jrmHT88=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=okg8Lu33; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=uX/njnoR; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 605Jpnd01920789;
	Mon, 5 Jan 2026 20:22:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=0MJfsduEPCEF9d35eF0jgBR+GC9Ja5w+J2YABrw6pf8=; b=
	okg8Lu33nw19pedgtqO1HU3cfPc9RLRsTMOevdJMz84HJTVxsL7nHjq+K9AvLuT4
	bn+SPntSPouzqAxUangCwZrrHSo3Eq5jG7rmQfyPN3aVDzk5Btj/nWx9iCXvVkux
	YUOJLVaJ9tHrhqAk6egbSL2Xn+GCmibtLV+1sohzcK/63O0RY3OM/7GHxxgKYqm8
	FV6VjMK3oVZygE2cDh0shaAN2LpFU7aAZEpIuNERrB78idwHf2Qh9IhBaQekF+5P
	C1+lCvCL2e073SEIXevEuEcmiku0u8RTPInO3Vt3qJnmcyZLFIELS8zfvZaM0sLg
	qomYDCZmhWZZSl+WmQTAyA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bgktm81as-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Jan 2026 20:22:09 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 605Ix0qZ020375;
	Mon, 5 Jan 2026 20:22:08 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010035.outbound.protection.outlook.com [52.101.46.35])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjht2sr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Jan 2026 20:22:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gX2KuRy/9g4FHwDaHLQ/MKCHZVdtqNmlWSYgJ7ISry2gAUMQDsngrA4DSXhLOSWCXrYtPnV/sfRHnl7bDEzFPLz6DTexArn/EzUmzFvV4csW95A6xcSDwPl3cEn07PWu2NSEBciv6V4S7aRpD/5+3zbH+hmcFtbFORzkjcK3Z0uiATiIxfB8eVpSVHD2zkcv6hL5nZAffsufB95ZSSzRg5NAyjzd8CRngtx4K82i76zbagC126iJ750Or4EPrmb+kW/FYlqlHujaa9yyWqinQZKAQxUl323B+hBQv5545fuZ7UTbjx9obATkgpPieL124DlNuUyW8s+2g5ol0YB6bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0MJfsduEPCEF9d35eF0jgBR+GC9Ja5w+J2YABrw6pf8=;
 b=FZ4w67Qxda2EvZXjoYM3q8XuaKO9P6ah8yZtZwsSkUklOozxuuFr1bnaNbDablpsxgtKxGDgCpwAGBtw8/WD96T4agQ0sBep344xZO82mCW/odGnIIYvXwTTL4AWH+P0S3M3fewaclB7vj8NVn45k6o0BpUINeuJtRLHm2gkszKNaCX/2Eni1+sYrsuGpaHMOzPCO0kHS1K47WeLoTWbL5aCVlQiDcsnBZ3r+orooen1zFCD80GnwU1cs3mEn4CssmxRSmjHrIrxvAsUQZJn/5h9AONuYLMb/IFnILluPzMcKwj5HeOls93HGgY8YFR0o4vmbCwVbucan3dHHSGsDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0MJfsduEPCEF9d35eF0jgBR+GC9Ja5w+J2YABrw6pf8=;
 b=uX/njnoROORYweqlfoJ7ywiLaCVb6QMfBgr99kboOV6xs4jfYwD1eyvqC9ieUMfASjGgABfB5enTChgm0k8bbLevimLAdIRdGH9Uq0jDx0SOvmYU6qahvmdR14febHMt29TQr0NL94Au6XYe0dGmzqHMIRIjugjpks8tG4k9Ym0=
Received: from DS7PR10MB7129.namprd10.prod.outlook.com (2603:10b6:8:e6::5) by
 CYYPR10MB7627.namprd10.prod.outlook.com (2603:10b6:930:be::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9478.4; Mon, 5 Jan 2026 20:22:02 +0000
Received: from DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::721c:7e49:d8c5:799c]) by DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::721c:7e49:d8c5:799c%3]) with mapi id 15.20.9478.004; Mon, 5 Jan 2026
 20:22:01 +0000
Message-ID: <29969c2f-d71f-4952-9ab4-4ba8f69e1514@oracle.com>
Date: Mon, 5 Jan 2026 12:21:59 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 4/7] target/i386/kvm: query kvm.enable_pmu parameter
To: "Chen, Zide" <zide.chen@intel.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com,
        sandipan.das@amd.com, babu.moger@amd.com, likexu@tencent.com,
        like.xu.linux@gmail.com, groug@kaod.org, khorenko@virtuozzo.com,
        alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
        davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
        dapeng1.mi@linux.intel.com, joe.jin@oracle.com, ewanhai-oc@zhaoxin.com,
        ewanhai@zhaoxin.com
References: <20251230074354.88958-1-dongli.zhang@oracle.com>
 <20251230074354.88958-5-dongli.zhang@oracle.com>
 <b6c531d4-328d-48a7-856b-051c918c24ae@intel.com>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <b6c531d4-328d-48a7-856b-051c918c24ae@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PH8PR20CA0023.namprd20.prod.outlook.com
 (2603:10b6:510:23c::29) To DS7PR10MB7129.namprd10.prod.outlook.com
 (2603:10b6:8:e6::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB7129:EE_|CYYPR10MB7627:EE_
X-MS-Office365-Filtering-Correlation-Id: bd366d0a-0978-481f-35e3-08de4c9815bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SUthVGk1KzZJbmdoa1A5VzgzbkNHcFRVTjBaSktyd1VEcm1ieHl1UllOMEZp?=
 =?utf-8?B?UnlzZUI1MHlCZ0J0WHdtUEoxVHpLQzEyd211cUczOE4wWkozb3lTTFR0Yy9U?=
 =?utf-8?B?d01zZGNONWtuWVdSbHY3U0NvR0ZEM1I2YUphUCsrVlVZK0lpa0UzbUY0SVkw?=
 =?utf-8?B?eTI4anBVT0JlUEllYUlDSlpHYXFhUTlDSUF5UDNzRUlReHdpUFU3QU5KSGgy?=
 =?utf-8?B?WUlCWElUOS9IWUpBQUNrb1g1bXVTYk85cDZGUjFoNm1jUEdFL1krZW11Rks0?=
 =?utf-8?B?Vm9OZ3liSGtNSjVyMmliUVdhMVowUEJSOFZUZEpDenZ3NEdMR2V5cHpIQTgw?=
 =?utf-8?B?RGhFdDVHWlNSVmhFMFZubUVvZzd3Y0JUbFBIRHRqKzJUNElDNVFDTThnL2Vo?=
 =?utf-8?B?UjJzN2wzd0ZkaktPRkhFZ0k1RG1pSkdhVW0vb0I5c0Y5dUlXSWFlN05RaDB5?=
 =?utf-8?B?THU0OUMva3FMTThQNkJ3ZnF0c0lUQmpxZlBwRFVsTm4rT3NTZ29OeHF6K1Ex?=
 =?utf-8?B?LzlqSyt6Vmw3QXQ1bnd0RUJUaUdoc213UVMzWDlKTWRHaWFXdGhoUTJnaTBZ?=
 =?utf-8?B?STV1MXlQbDNVR1ZkWUl0b3hQNlNVUnFhTWlNWnQ2clBQOXhvTC9idUpNQzRO?=
 =?utf-8?B?UEh4bjBCVjVLL1VsSEZWcXAwdG1IUXhlUGtiaXBVM2xkVjhCMVpJckZzUVdx?=
 =?utf-8?B?M082bTJ6cVlqcmRFeWxYOUkyaTdhSU1XcGVveFVMREgyMjNxSTBGdG44Y3hn?=
 =?utf-8?B?NUxrTVp6QlI3bktYL2hmY2RXU1FtQ2ozR20yOFo4MDJkckNuUDJaRmpyamlV?=
 =?utf-8?B?aU1IR0NGRkc1STJ5Q2RBS2ZhcXh3L1dxU21rS3VZdkx5Z2Y0b3AvOUJ2YndU?=
 =?utf-8?B?YUpzbXdNNEVTUldWK3VYWnprdGZXeXl5WCtJcHcwdW14ald3Sk9yNjM0MDNk?=
 =?utf-8?B?WjRLU1h5UmVDUjhDR2RuQVBpczVMRjZ2NllVZGlpbEZoVEtNaXVMOUNYMStz?=
 =?utf-8?B?dnFvS2thVGRuVUZlVlllVXVQZG5LWVl1VUF6WHdhNTZKYkJhWU1qQWhVWXp3?=
 =?utf-8?B?TVB2SmE0c3VSbzhwcGlFSWRidjMzR2lwTFNwZHpjUVFSWDJ1VW1QMVlKTnB1?=
 =?utf-8?B?NXZmdnF3VTU3NjlUMzhZQzFHTlBraFUrQTZzQnU5Ymg3VlZNWG9tWHNNNWNh?=
 =?utf-8?B?WERFb0hBMkhMdEU0NjdpMW44czF4Z3RFMmRUNi9oVGxLaXRMVFl4L1VKZEFG?=
 =?utf-8?B?c3Myb1c0RFN6bHA0TXp0WDdKR0d1b25QdWpBbTFIQmlCTUR1bDJQKzdpVE9z?=
 =?utf-8?B?Y2U1QnBFbjdFQVBjQU9GUkI5dGd5akRmSlhYbU9tekJGMm9FZy95WDVoS3RF?=
 =?utf-8?B?dEhNMVFtNzROcnF0UjdKVlZUbENUcy93ZWM0RkpzelMxZXRNWC9HN3hLMlpZ?=
 =?utf-8?B?RjBxKzEzL2VvRkNmdzdobzEvYkJCOHQ1WE1xN2VDS2xiTmQyTFJoZFZvem5C?=
 =?utf-8?B?Z3drMGxjM0ViUTFqdkl4YlRwRktSZ1VYL2h0V0pUV25WMmlBamR6b1dWUzlT?=
 =?utf-8?B?SEpLdGo5cTUrM3BsTWVkd2NaWlJRVm5nL3NRNUZvY1ZZNmV4bXdaanBXMWpU?=
 =?utf-8?B?Nko5dThmOEdtVk9FbU9KY1pXNVg2WEU3dk10amJjYmhFbWhIbk55SVhlMEUx?=
 =?utf-8?B?UlBSNEtvQmRnYzJXNkcyL0drSGdneGpGUlFkWUpTWE02UHk3NmhNc2gxQjc1?=
 =?utf-8?B?emdOOEVyU1FLR2VWZmk3OTNqSWNUSVZ5SXV2TW5aSkZGVEhjbDlOUU03RjJa?=
 =?utf-8?B?dWhpZkhtTHExZUtXSnh2M0xCT0tEZlBiWWNNZlVmNWhzamtSRGIrQzljelVk?=
 =?utf-8?B?dm0xNXlHbXZVUFJ5anhFeCtRK0szSG8yYXhvbm1KcDdnbndUUFpkNE43TXpP?=
 =?utf-8?Q?w/kxN0+BoBDyZnyYO/5F6STV+gMGXJ6p?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB7129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YmNNOTdyN2RzVE5MdWJkT28zUjVTUlNTb2tkaWEwMmNHczNleHJMUkduTjJK?=
 =?utf-8?B?WmVlaTN1MzlsYVpZQUFQTE9sSTBMMk5WWVVFS1VCeHp1OTlwWHV4Q2I0eVZv?=
 =?utf-8?B?RUYxWTEzbSthNk9iZmN2bWk4bnZSY2U2V3RnZFlpZDZnNUY3ZW5yTlpWVU5B?=
 =?utf-8?B?NVE5bnFSbTVITEhac2Fab2hXRDNoQUxzN2FEeGRlV2ZOR3hqQ0Z1SnFhUWN2?=
 =?utf-8?B?dGs1UVY5bkVDaHdjcmJ1d284eW5sYmRMSDBKeVpBN1pDT3c4aWpLYUl4VW9B?=
 =?utf-8?B?ME10UGYxY0J4VkpPelBFVmJCNWI1SjVUS0JrVlg5VHRVVHRmbmdiV1FvWGN3?=
 =?utf-8?B?RHJmNDN3L2pxekRNZlAvYjkyN3F6aVJ4dUozbkFXMFpaekFSeThiYlNmbmpk?=
 =?utf-8?B?S1pXT2xHamhSRXZtbXhBYjJpWElyaEtGUEZDTW9wdmN5MjYyM2hhZTh1ZlFl?=
 =?utf-8?B?d1dFWEV0NlRpcmcxOVptT01MK2xsZUMxMThJRnBBVDZrUkpJUzdXdkNwMlNO?=
 =?utf-8?B?MU9UN0V4TXN0UDhNeHhHSnF0ZDVCM3RxS0tVSC9lcnBRTVdCb1RSTkFLemQr?=
 =?utf-8?B?Zkh4cjliRWQxTm1sMy95OW9US2VPSGpRUHU4SGdGblJXd3dhQ3BTOVJRbjNS?=
 =?utf-8?B?RWZGM3p1NitlaWx1Y2JxOVY3dFpRRlpkbjhaUDlsajMyckFZdHU0aSs3NC94?=
 =?utf-8?B?bXRTakltK3MyY3NVSzB2RE9VdGlJNU5GQnZEN3dnUG5JN3lDUzJRaGRlZ0Np?=
 =?utf-8?B?bTBoZXhOKytRZ3orWDluZ1hzenZHSzJXaTE1WHdEeTlOQ0hxYjFuMHJaU0Y1?=
 =?utf-8?B?TE0yN1dVbEpKMzdXV1ZNcGJhMSsxUE84TFh4amxhZXZRdUVFencySVBRcU1y?=
 =?utf-8?B?MktrVW5pN3VLdkxsYTk0WWJ3N3RiNWxkZ1pvM3pKcVAwVWFpc0pPNWgxMnll?=
 =?utf-8?B?Y3BPRDRvRTBxU0NKS09VNzRuT2FDUHo3dDR4TnZFYkRDL1JzMVF6aTZNUVBv?=
 =?utf-8?B?bldJNHdWODJ4VjFQVVM1Y0JvbEFOQWM5YkZFUjhKZWt0RTFIRWNFbWtaSVY4?=
 =?utf-8?B?QzFlSnM5YVZBSW15R3FNVmhVSkl1QzJMNDVtMlNFR2NTYTFGbklXUmNqWFdj?=
 =?utf-8?B?WGxjNzlCSnpEYVFLSGZ6WEFXVjM2MWovSFVydHdOOXRPUmxUY29FM3E1bTFK?=
 =?utf-8?B?eXFHRUhqWmxMNS9BTWE4S2s5MUZlQStxSWJGZm5mbnJSUDlyNlZtTTRmWXB5?=
 =?utf-8?B?Q1JGWTdwc0U2WThqSnMveVJybC8wWWFYNWRxaXdFVE5xYitGdWhvM0MvejZr?=
 =?utf-8?B?NnBWYlI2TW9wVDR1YitOZFpUMzNFN1VvRldFL3pCSXYwVDV4UTN0d25EeStQ?=
 =?utf-8?B?ZWo5cEl5ZzhjV3BJR2tYdGRTTXA1S2dFdnZpRXlzcTRpcHllbUNzNWxmYnVu?=
 =?utf-8?B?cHYrYlJuRDliUHNIeGZzWkJ6TTBPNll3TE5FeVZyL0ZRQnJITTM0Mzc0TUpl?=
 =?utf-8?B?M2MvZGx1U3R6V1NDQjhjbkdhVllhMm5iQ0MxWURMZEdVcEY3MTlFS1B3a1d2?=
 =?utf-8?B?Vk5ja0NFZWhvS3RkVGtYQWtvbzcxTlJRY3VKSnNwMjhkRTVNRUt5bk5EM0Vx?=
 =?utf-8?B?YStGdEpuVmdRaHFGeExNd1lOV3NDWXBsK2h4ZHR3SUhpUDlueTlieFF4bml1?=
 =?utf-8?B?L1BoOWl2MksrbWRZNVFmbUZoTWkzZC9RVGh0QzQ1MXJjRkxra3ZuVk0rUEpl?=
 =?utf-8?B?OUEzaUNNSGVGZXRPNEpJVGNHeWpDYVcyZXpTUjRRdTNZU3FUMkhNVEFJR1I4?=
 =?utf-8?B?RitveUkxcVlnb3NrV0pyck5zM1Zib2MyU0pjSHhHN0lJaXU2K0JOVWNOSVg0?=
 =?utf-8?B?b1RiU20wbW1EZnBQT3ljVmFIZnZEQXNkQXpoako0RzdqMXY0ZklIM3UrYWVW?=
 =?utf-8?B?b2RlR3JXY0RNck1SQU8wZSs0SmFPMHd1Tzh1TFE1cy9DQ25zRUw4MTh2ZGN5?=
 =?utf-8?B?WXBjcVRuV3FKRW5YSU5kRm1aTmNhQjkyQ3FRVDMvSkdqbnlXNGpiWlFrV3VR?=
 =?utf-8?B?b29HRS9Zb3RpSVczTFVkd2doSUIyL2VrQ29ydDdEQUVYV3MrekxmRDlCWjUv?=
 =?utf-8?B?YTA0M2xCZXo4UWhXODNaTmxaZHJUMGRndFRDakxiMXhPeE9VMVJmOVlmUUNu?=
 =?utf-8?B?cG9lT1ZtRUk3RWFRTzlvaEkxYk1EOHUrTHhCeWxzU3ZCUVlnNXBIYUt3aWRj?=
 =?utf-8?B?VkFKaWJXNGRTa3QwNS9maGhRYmp2M2tIQWx2T0U2L0J2U2I1N0NybERlMkdJ?=
 =?utf-8?B?SXVjVElzM1M3R0dWeXVtQVdvbkloalNpd1hzeVBqQXZ0aFE0QTl4cTJ6YVN5?=
 =?utf-8?Q?xxRvoXscCGK5WkV8=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	UqEtmh3clZ6BSSfL2b6aTEXcjPXTZQnCBfEkMFJpLV/E6cAwtvAO4K8Y4EApRWj5k3Ydbw1huMto4kbkUD2LvSmnLg5EN0gVQNtbUAC447sijXj+htNF/7CmXfbsdkNQCqlsP5OA1bs1mkYz8w+jhNidqWnveWEjT+aT8RjJEZw0man9k/qSTN7VQFLr4//ZEeFfDVeEn/6Utn5hzB4daYo2quJCD4DUWdyd6IEmUdO4jPZsEBq3D+rMuNhwEwEDcIJt6d56sQBg5kE9bAlmnlBL/BApEHbhggVWpNznxwYumOweosesBF7ygHteJtw4ItD7oj+xHuTD2OJyYUO20ipDYrK162LdXzYHyXhjfQogLjVhaEdFEHEJfQsKRZdNSRMSEjnMTLlt89bR/h33bg8ghSBzFsFGy42BVaPaobZZlXTXDVYjuKWbTa2VcKQ3jA0EgD7xt8hY14kVi6I0J+45GYXali51+ZoDKJ+QRZ5gkqpJV0xlJ4PjyJuLtuKNM0c9IEhafENOakgtp8bvcw2VVK8gPw3094xRCl+A7zbHBOvheabdmjVwjP/zhySSNzkBkgzj8qq7yWqDceUYaeX1j1o0w566vWwkyJTPgsk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd366d0a-0978-481f-35e3-08de4c9815bc
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB7129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2026 20:22:01.8542
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PUOr376WejvKxZ79N45yjTg9gD3MfiwUKCavl1Re+FOz61KqbCk07PuN8nP4E6MXqjnzUPjJJM+gbJdUd2u9iw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR10MB7627
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-05_02,2026-01-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601050177
X-Authority-Analysis: v=2.4 cv=RoPI7SmK c=1 sm=1 tr=0 ts=695c1d71 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=njHRMiezt9t7bhJxbFcA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12109
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA1MDE3NyBTYWx0ZWRfX9sCUxW71IFOE
 5ukWk1k8omjTcrI0Rpz6dEQqIiZMmCs/6xT6BQbww762KEiNv5v85XGkQO2arLfozDAcFkSnmtZ
 LxX+n1FTFR+oYClN2Xj0hIR8qw49RjjoPqx8eFYix4xb8I2phV/nWPxoKhDb97IstYkNflZI8vr
 yq019ZfnCaoCHtOTMqSh1zw4jRV4QE0cshdWBgeUbjFcS+AoB9fyKNqX0gFQ+Mi/TIrXVwLSky/
 T5iRxsjoZAZyllU1PP4plduQJnbzTmsT3nCImdymJlvh0qNNEdmwe5VCYgtww2Siv5ludKz28fE
 wakbuXKGYYUmV808ZvoodK2N44ouTxe6VjRlNomNV/M1mER9YLNNjSIC5h5P9VlaA2dxGbnaE5N
 VCJidrtNx/9/0soSijpXeOTEvTGwXQHSFK2UpHUbf5+JFLdlLTXv53x4K9+DU4c4DRfWwXDFNSs
 AOvppOMx2YPZotqs1Kz/o5zLgR8d1/0KALrenbbw=
X-Proofpoint-ORIG-GUID: p3Va8ASRYVg3tO_yrcq-7P-M9kaic7_c
X-Proofpoint-GUID: p3Va8ASRYVg3tO_yrcq-7P-M9kaic7_c

Hi Zide,

On 1/2/26 2:59 PM, Chen, Zide wrote:
> 
> 
> On 12/29/2025 11:42 PM, Dongli Zhang wrote:

[snip]

>>  
>>  static struct kvm_cpuid2 *cpuid_cache;
>>  static struct kvm_cpuid2 *hv_cpuid_cache;
>> @@ -2068,23 +2072,30 @@ int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp)
>>      if (first) {
>>          first = false;
>>  
>> -        /*
>> -         * Since Linux v5.18, KVM provides a VM-level capability to easily
>> -         * disable PMUs; however, QEMU has been providing PMU property per
>> -         * CPU since v1.6. In order to accommodate both, have to configure
>> -         * the VM-level capability here.
>> -         *
>> -         * KVM_PMU_CAP_DISABLE doesn't change the PMU
>> -         * behavior on Intel platform because current "pmu" property works
>> -         * as expected.
>> -         */
>> -        if ((pmu_cap & KVM_PMU_CAP_DISABLE) && !X86_CPU(cpu)->enable_pmu) {
>> -            ret = kvm_vm_enable_cap(kvm_state, KVM_CAP_PMU_CAPABILITY, 0,
>> -                                    KVM_PMU_CAP_DISABLE);
>> -            if (ret < 0) {
>> -                error_setg_errno(errp, -ret,
>> -                                 "Failed to set KVM_PMU_CAP_DISABLE");
>> -                return ret;
>> +        if (X86_CPU(cpu)->enable_pmu) {
>> +            if (kvm_pmu_disabled) {
>> +                warn_report("Failed to enable PMU since "
>> +                            "KVM's enable_pmu parameter is disabled");
> 
> I'm wondering about the intended value of this patch?
> 
> If enable_pmu is true in QEMU but the corresponding KVM parameter is
> false, then KVM_GET_SUPPORTED_CPUID or KVM_GET_MSRS should be able to
> tell that the PMU feature is not supported by host.
> 
> The logic implemented in this patch seems somewhat redundant.

For Intel, the QEMU userspace can determine if the vPMU is disabled by KVM
through the use of KVM_GET_SUPPORTED_CPUID.

However, this approach does not apply to AMD. Unlike Intel, AMD does not rely on
CPUID to detect whether PMU is supported. By default, we can assume that PMU is
always available, except for the recent PerfMonV2 feature.

The main objective of this PATCH 4/7 is to introduce the variable
'kvm_pmu_disabled', which will be reused in PATCH 5/7 to skip any PMU
initialization if the parameter is set to 'N'.

+static void kvm_init_pmu_info(struct kvm_cpuid2 *cpuid, X86CPU *cpu)
+{
+    CPUX86State *env = &cpu->env;
+
+    /*
+     * The PMU virtualization is disabled by kvm.enable_pmu=N.
+     */
+    if (kvm_pmu_disabled) {
+        return;
+    }

The 'kvm_pmu_disabled' variable is used to differentiate between the following
two scenarios on AMD:

(1) A newer KVM with KVM_PMU_CAP_DISABLE support, but explicitly disabled via
the KVM parameter ('N').

(2) An older KVM without KVM_CAP_PMU_CAPABILITY support.

In both cases, the call to KVM_CAP_PMU_CAPABILITY extension support check may
return 0.

By reading the file "/sys/module/kvm/parameters/enable_pmu", we can distinguish
between these two scenarios.

As you mentioned, another approach would be to use KVM_GET_MSRS to specifically
probe for AMD during QEMU initialization. In this case, we can set
'kvm_pmu_disabled' to true if reading the AMD PMU MSR registers fails.

To implement this, we may need to:

1. Turn this patch to be AMD specific by probing the AMD PMU registers during
initialization. We may need go create a new function in QEMU to use KVM_GET_MSRS
for probing only, or we may re-use kvm_arch_get_supported_msr_feature() or
kvm_get_one_msr(). I may change in the next version.

2. Limit the usage of 'kvm_pmu_disabled' to be AMD specific in PATCH 5/7.

> 
> Additionally, in this scenario — where the user intends to enable a
> feature but the host cannot support it — normally no warning is emitted
> by QEMU.

According to the usage of QEMU, may I assume QEMU already prints warning logs
for unsupported features? The below is an example.

QEMU 10.2.50 monitor - type 'help' for more information
qemu-system-x86_64: warning: host doesn't support requested feature:
CPUID[eax=07h,ecx=00h].EBX.hle [bit 4]
qemu-system-x86_64: warning: host doesn't support requested feature:
CPUID[eax=07h,ecx=00h].EBX.rtm [bit 11]

> 
>> +            }
>> +        } else {
>> +            /*
>> +             * Since Linux v5.18, KVM provides a VM-level capability to easily
>> +             * disable PMUs; however, QEMU has been providing PMU property per
>> +             * CPU since v1.6. In order to accommodate both, have to configure
>> +             * the VM-level capability here.
>> +             *
>> +             * KVM_PMU_CAP_DISABLE doesn't change the PMU
>> +             * behavior on Intel platform because current "pmu" property works
>> +             * as expected.
>> +             */
>> +            if (pmu_cap & KVM_PMU_CAP_DISABLE) {
>> +                ret = kvm_vm_enable_cap(kvm_state, KVM_CAP_PMU_CAPABILITY, 0,
>> +                                        KVM_PMU_CAP_DISABLE);
>> +                if (ret < 0) {
>> +                    error_setg_errno(errp, -ret,
>> +                                     "Failed to set KVM_PMU_CAP_DISABLE");
>> +                    return ret;
>> +                }
>>              }
>>          }
>>      }
>> @@ -3302,6 +3313,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>>      int ret;
>>      struct utsname utsname;
>>      Error *local_err = NULL;
>> +    g_autofree char *kvm_enable_pmu;
>>  
>>      /*
>>       * Initialize confidential guest (SEV/TDX) context, if required
>> @@ -3437,6 +3449,21 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>>  
>>      pmu_cap = kvm_check_extension(s, KVM_CAP_PMU_CAPABILITY);
>>  
>> +    /*
>> +     * The enable_pmu parameter is introduced since Linux v5.17,
>> +     * give a chance to provide more information about vPMU
>> +     * enablement.
>> +     *
>> +     * The kvm.enable_pmu's permission is 0444. It does not change
>> +     * until a reload of the KVM module.
>> +     */
>> +    if (g_file_get_contents("/sys/module/kvm/parameters/enable_pmu",
>> +                            &kvm_enable_pmu, NULL, NULL)) {
>> +        if (*kvm_enable_pmu == 'N') {
>> +            kvm_pmu_disabled = true;
> 
> It’s generally better not to rely on KVM’s internal implementation
> unless really necessary.
> 
> For example, in the new mediated vPMU framework, even if the KVM module
> parameter enable_pmu is set, the per-guest kvm->arch.enable_pmu could
> still be cleared.
> 
> In such a case, the logic here might not be correct.

Would the Mediated vPMU set KVM_PMU_CAP_DISABLE to clear per-VM enable_pmu even
when the global KVM parameter enable_pmu=N is set?

In this scenario, we plan to rely on KVM_PMU_CAP_DISABLE only when the value of
"/sys/module/kvm/parameters/enable_pmu" is not equal to N.

Can I assume that this will work with Mediated vPMU?


Is there any possibility to follow the current approach before Mediated vPMU is
finalized for mainline, and later introduce an incremental change using
KVM_GET_MSRS probing? The current approach is straightforward and can work with
existing Linux kernel source code.

For quite some time, QEMU has lacked support for disabling or resetting AMD PMU
registers. If we could add this feature before Mediated vPMU is finalized, it
would benefit many existing kernel versions. This patchset solves production bugs.


Feel free to let me know your thought, while I would starting working on next
version now.

Thank you very much!

Dongli Zhang



