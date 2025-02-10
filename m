Return-Path: <kvm+bounces-37729-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 95A78A2F9C0
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 21:12:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2EC62168579
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 20:12:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA11B24E4AF;
	Mon, 10 Feb 2025 20:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dzoZ67Pb";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tUOFcWpp"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C1AC25C6EE;
	Mon, 10 Feb 2025 20:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739218329; cv=fail; b=fVsZy7DNIuY0lrMjBS3snmyELbKTpgSlBF0SKSN1kE4PHUzFjyWnO8quP8rXGIwJG8NJpKBo5+7npJzmRTWi9opRFxcOWjP+lBcCOl7hwPWObEwme43EYxczPToqO8D0VX37zWTU7FCTItrn5zs2oYhDyos7qOtRxBnzsD7kT38=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739218329; c=relaxed/simple;
	bh=SknWFNJspmiMNDWVDCZtW6LyKgEMKWHQv4RoayHYeGw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=g+DC6QvtrFe2lm+TS7/uK6fezIuw4E2RdZea+X1HY1dGHHwsrg0PvaEJuSanICcIeXjJ81T8+Ja4PtYyq4ZTLCkacq+ytL67Ai27JnOox1E5fwMXYs8m7KSKFGHx9UvAIPPlparR/ODrq5gPds6459JSunzg7MRADZ1DdzgCDWc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dzoZ67Pb; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tUOFcWpp; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51AJtcgZ023526;
	Mon, 10 Feb 2025 20:12:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=RQmk7FnFqimuJ3fsvuuHFO40Kp0tB+48uph1BxJDMP4=; b=
	dzoZ67PbYRozt1s63sDVAAgglgXAG48vnA3G8vyYzgJoVNT5IVIceYIIOWnFqPzx
	pDRf3O9VnWybXJHsTEoN5iSW9R0mdINP3N3BxrdFqCzpIIwnbT5+lrXPiMwAoD5m
	vbUOyvPYqRsAI3iBGz+sLZR2sFMMjgIQYbfzANk54k25xL514zTxD2byxK5sN0lV
	Fuy8Pu2OJp+PpMJ46utR2M+jPrkSdiGdVxdMDhmRwiQXoVwKvTy0VKnfqylPtM+O
	sEmKm+K6yOs8pJpxrfIJObue/WdwHFm/OY6qctZOE1nS3jci/I7ujaiDo9vZqDYL
	hSmynQtsIWuYnBwLXBVUQw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44p0s3utqv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Feb 2025 20:12:02 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51AIX8GJ002299;
	Mon, 10 Feb 2025 20:12:01 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44nwqecp25-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Feb 2025 20:12:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NPNidsb+4lHkLI39+b+3ciRNxpnc/d121p8U6+BiLgzjW6udui1l4SUqLWoQ6A1dBgUgRR+OX5gwB16KJ3l24wcCNeGPGcY0EwlDIyhUKYtR15JAr+Is2KtNInukqEVO0Txqae24eNF1sr2Oyx2xFjuUOwnwtLVes6/dzDFDQxHMnOx5Ik/+li19Uzw2yYm16WNM1p0VJ74KkMyWC0fVBZo1iLvb4uIoR6pq0yZL2yi7Mu1PrPoIIUZSH2N/WzHk2j1wvKfgoDIZxgQLl6aoY3+JzIERjtrbWc7JHETGwJf+QgwObt0H+A5gRuktwfRxyK3DB7DnxVJS6i/TppRPiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RQmk7FnFqimuJ3fsvuuHFO40Kp0tB+48uph1BxJDMP4=;
 b=PRoEgSyO+0KgyGGtwV/M+Z0xcmteetv1qLPXPNpUFRCF614wRDgsrB7hyEiErJEg9z4pfR+um4xDcgcwIaCMvRpajAwTf4EYYJG5JQruZPhGvoaWbwPFra21KDjUOhstWH3sVEDPQwev7pF3H9HR6c3PTew8nA7lsTqJJfXnFiAodeKTfSp8U1c5MMybaILC4DimgW7dHqMIH0XX0s3ebweNhjlMyZ/hXxrHiTlauaSSn9s5UJ2iVR9RcRAk3UKzFFRDeJgkTZ0WK1pStJnZqi+/I5lzFMnaiPZ83RAwX77GRhGNqzUjFv04Gg/nMR9P3eQqWoL5paxKAqa6/mTezg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RQmk7FnFqimuJ3fsvuuHFO40Kp0tB+48uph1BxJDMP4=;
 b=tUOFcWppqSW+DRmQD7vYuDYrsgc6tmIPDADXDTrjLRZf7va1MB+HALw4wiM/CLTHS1sMYPP66USjp4mAhd7kGVbnRZb08HB8DoWezePSE9/fmszxW3vXPLELfLxxJ4NnkIpSaGuZlpP4GaO38dizGanEWD96KoSI+cFFIUIF/P8=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DS0PR10MB6248.namprd10.prod.outlook.com (2603:10b6:8:d0::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.18; Mon, 10 Feb
 2025 20:11:58 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%4]) with mapi id 15.20.8422.015; Mon, 10 Feb 2025
 20:11:58 +0000
Message-ID: <b058d4c6-f8cf-456b-aa60-8a8ccedb277e@oracle.com>
Date: Mon, 10 Feb 2025 14:11:56 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/9] vhost-scsi: cache log buffer in I/O queue
 vhost_scsi_cmd
To: Dongli Zhang <dongli.zhang@oracle.com>, virtualization@lists.linux.dev,
        netdev@vger.kernel.org, kvm@vger.kernel.org
Cc: mst@redhat.com, jasowang@redhat.com, eperezma@redhat.com,
        pbonzini@redhat.com, stefanha@redhat.com, joao.m.martins@oracle.com,
        joe.jin@oracle.com, si-wei.liu@oracle.com,
        linux-kernel@vger.kernel.org
References: <20250207184212.20831-1-dongli.zhang@oracle.com>
 <20250207184212.20831-4-dongli.zhang@oracle.com>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20250207184212.20831-4-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0055.namprd03.prod.outlook.com
 (2603:10b6:610:b3::30) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DS0PR10MB6248:EE_
X-MS-Office365-Filtering-Correlation-Id: 540045ea-aeef-4e3b-c095-08dd4a0f2bdc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cjdFME1SUzhtSEdzZlpOVHA1TVQwVnZWUXRTVVFCMjd1WkJhRnREV2ZlcUN4?=
 =?utf-8?B?Ni9EWjI1THpRblROcmFIR2M2RFIyZk5aYU15eGtOWU85dXQ3UWNDS1orbU9C?=
 =?utf-8?B?OGNuZXRVcHBvUUg4eUNZVGt4bG95dGlmRkwxT1VSVXZadUxKNTVqbXdZbU9v?=
 =?utf-8?B?ZkEvaUN1Qm5NYi9hdzNXT3diZVRjTkpkcVZhSlp0elJoOUo0dEd1V1ovblVt?=
 =?utf-8?B?Uy9BaHRpMVBxU3JiT0xISUtIMGZXQzNackN2M0JRa0RlWHQzVllSZklLRVFF?=
 =?utf-8?B?OVV2bmtEaXJMQ25tbzNhM0tFZmR2NmNUWUdQRXNGTU9lNnRqTE5Ud1lPcTgv?=
 =?utf-8?B?L1Bic2ZsblJ5NnNraVNHSjhuRlpDNmphT0lRMFIvNnBvdVlKM1FNaGhFZzg4?=
 =?utf-8?B?RHpkUTJIaWxrMEhZTVFiaDY5clNkVHVUZTZ6WXl6U1hXcFJ3OVluMzlUdm9Z?=
 =?utf-8?B?eTBhZkk0V3JpSERWRGpkY05oVmlCRklBOFhZTWVsTEtsenNRaVRORkIvUkRH?=
 =?utf-8?B?OUU4ckFML0lYaERUcEJ5NFpsbXdHcTROcTBHcVVuSGx1eE9XRkxqSWpIb0hY?=
 =?utf-8?B?MWt2UXZJUFpWZk5ENnRmOVJzSERQaUhIckEzMTdaRUZ5Q09BQzFTNmJtNTlp?=
 =?utf-8?B?ZWw4M0hXb2FsOFRBc3I1S2dzVEZ2OVlxTTBLZE9qTHF4Sy9QVEZib3F0NkJv?=
 =?utf-8?B?dlNXd3JMVFZnREVYSGE2QVRNUjZCMms4VVFYUXFhdEN5VkR5d2x5WVEzN0RI?=
 =?utf-8?B?WHFtd2NjSnZOdzY0ZVROMlljYktEeWJlNjhyRE54U0kxSWNpcTI1eUV1VjU0?=
 =?utf-8?B?emlURkFNQjA4MVlsaU1CWDE0Zit6eThsbWF5TUF1VFRpTldZa1d5SmMrZm1i?=
 =?utf-8?B?YkR1MXl2NnhRRDFwYXhmLzBYWVNpR09yT0tlemZzSWYrMm5tM0VNc3pSUW9V?=
 =?utf-8?B?Z3BlZE9zb21nNlphaUJXY1I5L3RVWWFKMUpvclREL05HN3QyM280RVljUkU5?=
 =?utf-8?B?M1AyTnJqQnhUSVkwMENaNGxXQzJrTldTa2oxYm1ycXVWZ3NKSmNoREhaNzNi?=
 =?utf-8?B?V01jcWN2Qk5iTlVCaE9HdThrMlhJcDBnSURHMk5xL1FNa2tTeEE5RHFreHpa?=
 =?utf-8?B?SlEzUmdOR292T3RuNUNSQ2lmRkt6QXRPcms4SUlZbkRONkNJYWp1STUvNXpL?=
 =?utf-8?B?OVlSMHFFMVlLSk40Q082NEREZUM1TDJnbmlBbEtJeXpFNXVUZEpNMWtQdHlt?=
 =?utf-8?B?ZFkxQVdrZ3NvWlFjckx3ZVpnZnNZTm5UZDFkTmFvRUFiQXQ0MGMxUnJ6SkhP?=
 =?utf-8?B?YUtsRlpPMVh4SG9uMVFRNjJUVm9yczFvMnVxZjJlZStiaDNMSFZaeWorR09P?=
 =?utf-8?B?OEg2SDJRMUFjOUpRVDRoR3gwZlRYTVVPa3hQSllsSEtDODZvMmsyUWEvV1hY?=
 =?utf-8?B?WHlEWHZLWHo4dTNUVlRMZEdlZmdGZ2pqTW5CbHcrU203d1FRT003ak5BZHZv?=
 =?utf-8?B?RG0vNHkzTElWcXhJQ3gweXp4SU5xQi96SHRNTGd4dlRZWE5jK1FyMjZYVjNC?=
 =?utf-8?B?cng5S2FPVGFXd1JFaGZ3RHZhNzNUa29keTVkUnpoVkZIOG9yQ1JHdmFHdjZq?=
 =?utf-8?B?OXlRa3FhenJGSWtwNDZwUW56QkxyNFVQVlJhdFlRUnp0djU1b09TMnJCL2ZE?=
 =?utf-8?B?RC9wTGVXYlk0bHg5OW9HZjVHa1ZxeC9rdisxR2ErbWJrOXlDekRNQVB2TVh5?=
 =?utf-8?B?eSs3UzJsZzBHOUJBamsybDhhUkFRWm1DTG9Ucmo4MmkxdHNMVE9xNGpZUXBL?=
 =?utf-8?B?SjNDK2x1ZnNjdWY2cXRjV282MkZ6V290M2NVYWJVMTRDdlFOOTNSVWcrNys3?=
 =?utf-8?Q?Xz2Mets3WSXDi?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NkJaRkVaeG1kQnZmSGU3R0x3aWtFT0tlL0ZuVzJ3Q0ZjZkdkZm1xWjY2TmNX?=
 =?utf-8?B?d24zK1Znd05ZZVA1UGp5ZEJXOU92dm9MWkp1b1BEVDA1OVp6cUtTMHFZWGZn?=
 =?utf-8?B?OEY0cHdQQ1BYdmtNenBNSXJxQ21UUWIvZEdFdFpkZk0yQWJSQ1VSWmkrOEZx?=
 =?utf-8?B?YSt2Ym1IdjZTQXlKdGJDTmFBbTF5YnV4RWNqNmYyUCtlNzJVeEhFRiszNlh5?=
 =?utf-8?B?cVVWbERCay8zQi8yOGJnZlM2YXVTaW9XUk5tdTM0WjBsZTB3R3VGWXFNOVNG?=
 =?utf-8?B?Y0FySGlNOER0VnpQbG9ZcjhzNEtnTEpaTGU2UjB5N2xqb21LU3JRZ0NRSmd5?=
 =?utf-8?B?WDNTbVNNQmlkSURlWG53RFBDNUduZzlBcS9zY2ZPbnNyZmQ5cUhXZUlSVm9l?=
 =?utf-8?B?bTJsYlZ5Q04vUCt2R2RkRGVOakZZajExTEEwWjBveDFBU3cyZHg2VDFyNXJz?=
 =?utf-8?B?elEyR1lDckNmWlZUN25XWkZYYmdWWDc3VjBsZ0luVUg1Ri9yZFF1K1cwRWRS?=
 =?utf-8?B?OS9ST2ZkVDRIbHZ1c3JHMGJya2QvUklla2I5S2ZYY09ocHkrMTNVOTFBWUNs?=
 =?utf-8?B?VWljb1VPMENnZEVYNWtHQzEvOHZ3WCs0YnhqSUg1UER6cGZPdHdNZy81aEFZ?=
 =?utf-8?B?N0VzVkpkeHA5STFLOWRidzZ0aFM2MkMvR0ZhWlhsVDBab3c0NXhtbC9VOEps?=
 =?utf-8?B?Y1pCUVA5aXpNMmUwVUR2UlpiSkx4K0VXc2lwS0JBWjRJaEZPSmpiSGxnSXNG?=
 =?utf-8?B?QXZZT1k5ZGpKRVdORk52b3FIbklhektoOXZDQURhZFBwWW94NWlrNUdnRDZa?=
 =?utf-8?B?aUVFZ0QwWmZVaGVhdEZmUHk2OGdnYU5ZSGZWM0xsVW83YktNdWRZZHQ5VGs4?=
 =?utf-8?B?VnVXRHk2Q1E3d0VuSkg1TmVVMEpmYVpHZ3dZM2VGMHAySTdaLzZDcXdqN29C?=
 =?utf-8?B?Y0J5eURwZ01ZQi9XLy9TYmEvQ2VwUEVTbXFPMXFQOXlZMjZxaUlDY0hDdGhO?=
 =?utf-8?B?c0I3MWxxeWZvdUw4dGpGcFdjSFpXRW1UTWlCWXd4VlJPSEgzOGk4NkJrdWZD?=
 =?utf-8?B?aU1XQkN2dHduQ1hNeUcrNjJYdDJ3MnFJbS9YUExjV3lneU5WblRCOWcyWEZj?=
 =?utf-8?B?NVFOWWZRZFRLN0liSDllaUxRdzF0MlY4QXR6cDBlSG5oMG85TnRrWGhUYUhZ?=
 =?utf-8?B?WGpaYUVGS1pMZHJRa3FYSEhtazFteCtQZXRqdFphcWNwU1JCTDhTdlpubVNh?=
 =?utf-8?B?bGJ2RkRyV0ptSWpUaWY5OTRVSjdLdE5uQndMbUZuRy9Zb0IrMU15QjBuNnlL?=
 =?utf-8?B?b0VkK0wzZ08rYytla0c1U0xXamt0RmN5QWN3WmlVcmNLYWhFb3BZQnJ5ZG14?=
 =?utf-8?B?TmlUc3RLWlZKMndzSE5zbVVpL2ZMUlIrSWNUSnZiaXdpeXBOME8zYlE2eVB5?=
 =?utf-8?B?WmRIcE12aUhPZUJjYkppODBkWHlRdVJRSnFVeFgyaDJINmVRbWFWdUJJTGo3?=
 =?utf-8?B?ZWFEa2d2TENLTEh6WnZILzArdnhKRDNtQnp3c2V4UHoxK0Jxc2hyRW84Y2FT?=
 =?utf-8?B?ZUFzNjk4Nm9NRlZMZ0NyMG5LYWlSR3luSUNSbXF0ZUd5M1JpTGpWY2owcWpu?=
 =?utf-8?B?VjBUYUt0Yyt0WkQrOHRqQ3lvcWVROGp2eVkxUExEeCszUDd1Mkx6TmVPcFZV?=
 =?utf-8?B?bEUxMWd2cEhlazhITXpTTmpCOFMvRVpocnozN2diQWhXbHdqd0l2Y1crZFp5?=
 =?utf-8?B?c3RmM2RIdW5iWTc1SWVkaEwwWEV6Z25MTzJaV2JRMVVNb0toSXRjZmdsRC9m?=
 =?utf-8?B?SUVBTEJlK1N0MVJrYmhPMEpUVGZObFJJNCtXMU45VkxWaTFEL1hqdzVoa2hv?=
 =?utf-8?B?S3gvNHo0aCtrWXBmL0Z6UGR5d2JxT09kY0dFOUdxekx1WmFFZW9QWlU5V1VE?=
 =?utf-8?B?THFiQnhMZ2Y0bDZFVlJnYTZGMndycFA2cTlvbFlndFl3K1lMMTA4NjFRc2JM?=
 =?utf-8?B?aTYyWTF4Y0VxRXBRVm9KZDYxeEdMNllIYjNtWVZrRWFleXJsYW1vZk1FVTQv?=
 =?utf-8?B?YXdSelhWTGsrZDNvOHRxWnhlaDlyMzVma1BPUFRiaXh1cG9lRTY0SUpCVis2?=
 =?utf-8?B?MUVncno5NnRCRnkrZm5CcURFSytlYmxVcnluWE9YMkVVcEhJWGlkSjFtQUZj?=
 =?utf-8?B?Wnc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	owxhYcsl4kxb9udlCB2zFviLyCekApSiwrWwNQuQpHWWZ9PBAWXyKwx+q6pWmaVlYIKJz7giFrjjx0KFZ6vdQ/eSvzVmzAqssbYZgi/26xA4pOh0ZMQ3rQm3okE7oHitwTE/YOpXUJrV9UReV7PZB6wapvsQQ17VmdzilsrovmtWDdQb12NNxNeZzJyWg9fOoCS7TmB/gwXM2j+BOg6/AcncGfZp25OcpJ37pjQXGdvU51ji2dDoKXeYSkAR7JH+UMoiIzllCCgKHuhP3Ics5xAEOOwbCJYPatWctapIODTrFDjiWoN4jymffNG2pvY86LAy/BbaBCxKe694pbhFpR+G6KH6nRoUqiBn6gKF/LaE6mFqxDVxSUjaQ6ySIBCN1KvMNIfqNsoAtgeh5RLy2Y3DhBffmsYG2v7EsJ9SS2zIKxxrUWvRy4mSxiJ+t1WL5GjXAQ+EL93Gvw0exJr2GAgU+uXPPFsbU3Z5sNtpH5WPYYiAl63B2imkchYAyh9oUrbONEeC1KQToZ0/Qe6bJHwGhTenmK5wnUSCndNA345xLgvLWCNoJ1Jm4SWEsWWDE/CalONHuSLptxbBkc70iKs2uO2cgMqFAJ7FYJLQao8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 540045ea-aeef-4e3b-c095-08dd4a0f2bdc
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2025 20:11:57.9717
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EsO1TkCG3nCt16Wnl6MA6JigJjpaAIcNkNDC3FIdo9/54EBH6MtaLcPasIn9qIWp1gdJ24ye0S2/G4h2hysxSn/DXyug1xExhLY2bzCbGVE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6248
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-10_10,2025-02-10_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2501170000 definitions=main-2502100161
X-Proofpoint-GUID: sQHOpbC9b85vixMcwAUrg6ZIxHRL5mlZ
X-Proofpoint-ORIG-GUID: sQHOpbC9b85vixMcwAUrg6ZIxHRL5mlZ

On 2/7/25 12:41 PM, Dongli Zhang wrote:
> The vhost-scsi I/O queue uses vhost_scsi_cmd. Pre-allocate the log buffer
> during vhost_scsi_cmd allocation, and free it when vhost_scsi_cmd is
> reclaimed.
> 
> The cached log buffer will be uses in upcoming patches to log write
> descriptors for the I/O queue. The core idea is to cache the log in the
> per-command log buffer in the submission path, and use them to log write
> descriptors in the completion path.
> 
> Suggested-by: Joao Martins <joao.m.martins@oracle.com>
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> ---
>  drivers/vhost/scsi.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
> index ee2310555740..5e6221cbbe9e 100644
> --- a/drivers/vhost/scsi.c
> +++ b/drivers/vhost/scsi.c
> @@ -98,6 +98,11 @@ struct vhost_scsi_cmd {
>  	unsigned char tvc_cdb[VHOST_SCSI_MAX_CDB_SIZE];
>  	/* Sense buffer that will be mapped into outgoing status */
>  	unsigned char tvc_sense_buf[TRANSPORT_SENSE_BUFFER];
> +	/*
> +	 * Dirty write descriptors of this command.
> +	 */
> +	struct vhost_log *tvc_log;
> +	unsigned int tvc_log_num;
>  	/* Completed commands list, serviced from vhost worker thread */
>  	struct llist_node tvc_completion_list;
>  	/* Used to track inflight cmd */
> @@ -619,6 +624,7 @@ vhost_scsi_get_cmd(struct vhost_virtqueue *vq, struct vhost_scsi_tpg *tpg,
>  	struct vhost_scsi_nexus *tv_nexus;
>  	struct scatterlist *sg, *prot_sg;
>  	struct iovec *tvc_resp_iov;
> +	struct vhost_log *log;
>  	struct page **pages;
>  	int tag;
>  
> @@ -639,6 +645,7 @@ vhost_scsi_get_cmd(struct vhost_virtqueue *vq, struct vhost_scsi_tpg *tpg,
>  	prot_sg = cmd->tvc_prot_sgl;
>  	pages = cmd->tvc_upages;
>  	tvc_resp_iov = cmd->tvc_resp_iov;
> +	log = cmd->tvc_log;
>  	memset(cmd, 0, sizeof(*cmd));
>  	cmd->tvc_sgl = sg;
>  	cmd->tvc_prot_sgl = prot_sg;
> @@ -652,6 +659,7 @@ vhost_scsi_get_cmd(struct vhost_virtqueue *vq, struct vhost_scsi_tpg *tpg,
>  	cmd->tvc_nexus = tv_nexus;
>  	cmd->inflight = vhost_scsi_get_inflight(vq);
>  	cmd->tvc_resp_iov = tvc_resp_iov;
> +	cmd->tvc_log = log;
>  
>  	memcpy(cmd->tvc_cdb, cdb, VHOST_SCSI_MAX_CDB_SIZE);
>  
> @@ -1604,6 +1612,7 @@ static void vhost_scsi_destroy_vq_cmds(struct vhost_virtqueue *vq)
>  		kfree(tv_cmd->tvc_prot_sgl);
>  		kfree(tv_cmd->tvc_upages);
>  		kfree(tv_cmd->tvc_resp_iov);
> +		kfree(tv_cmd->tvc_log);
>  	}
>  
>  	sbitmap_free(&svq->scsi_tags);
> @@ -1666,6 +1675,18 @@ static int vhost_scsi_setup_vq_cmds(struct vhost_virtqueue *vq, int max_cmds)
>  			pr_err("Unable to allocate tv_cmd->tvc_prot_sgl\n");
>  			goto out;
>  		}
> +
> +		/*
> +		 * tv_cmd->tvc_log and vq->log need to have the same max
> +		 * length.
> +		 */
> +		tv_cmd->tvc_log = kcalloc(vq->dev->iov_limit,
> +					  sizeof(struct vhost_log),
> +					  GFP_KERNEL);

VHOST_F_LOG_ALL is normally set when the migration starts right?

I mean it's done before the initial setup when the above code is run so
is it possible to do the allocation when vhost_scsi_set_features is passed
VHOST_F_LOG_ALL? We then don't allocate a bunch of mem for a feature that
may never be used.

