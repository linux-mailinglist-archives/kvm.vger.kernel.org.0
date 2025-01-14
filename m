Return-Path: <kvm+bounces-35403-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F06CA10E10
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 18:44:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 460F2188918F
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 17:44:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A20BD1FA24C;
	Tue, 14 Jan 2025 17:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="k0JFTVDg";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="AoY//lak"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E0B1CEAC9;
	Tue, 14 Jan 2025 17:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736876683; cv=fail; b=bXg+Oa3B7ORRT7VQTERUV8Pqy9e9O7d1Vr3ISOLuBOd+42wa6lpk80Inag/J3nIXvqErNuiiOYNW04urYYj0ZjdZuWM1jDESFQoFu2/6pr4XsFTTS8ASI+RhZX3qM19WUHbU0ATvvyWLqBPcMd+aFgM1s9ncGpUBEGz6eO3DQAY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736876683; c=relaxed/simple;
	bh=KY0xRAYJAM2dRAy3jiwDkvFEymCkNHBwve+RyUHdPwY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lbCrTPD/jmjD3th/8wre0z4c5DTKC+BI6ud026ASwcNpmTaw8agwu3dptXUpkD1WLqG7u3nLb0DIw71lpP1K7leIT8sKDggHmw05e8VvaEIVB1VNBUSVBnxOZwgu9DoYKHfqMbVnW+ZnqONkY53CombBl7lJ877zeNoMV/3wOHA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=k0JFTVDg; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=AoY//lak; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50EHfsOd000929;
	Tue, 14 Jan 2025 17:44:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=x63auyXnSn0R3o0IXKh09/08urw9BWPQDXNWQV14Rhs=; b=
	k0JFTVDgaCOetHxSJAgvx+oo0guhs89XMp3+IKgdZlpKOYUmi6UYtyhIO4zsbSNF
	qaGiBRwlVk87JLg8PqM22agskZN8wBketDdgzseVxYhtdovHvP8uJXuZjEwowhzC
	FXv74szAQTgQGIRvX7u9iaDuHNRRN95+09xhMVSmjC6MlDCjFFnRIHrlzPvShlG2
	Pdk3URbFRiCEY1S8nj9RarnVwSlTmCgduqQNLFagF3VyFXjH3XGEe5Id5VztPHBJ
	+xNZLZvSSRkNWVXv8OHD8NZ88fmJGHtmE4vg8Lhp+adpv8JcZfK5SknT6WWkGwMI
	6nNsFkp5M1oQ0pilYq2m2A==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 443f2bx9te-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Jan 2025 17:44:36 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50EG5khT039232;
	Tue, 14 Jan 2025 17:44:36 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 443f38ean7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Jan 2025 17:44:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gWFeOxMfrNdv/k17fWMYUjYziyH7eMk54jVARzRz46v6OE210HQxQycdZH6m0iG12TMHDtqwUGL1JNhnIud3sOY/CdMMKbqog/L0WWtoA35XZrSDjLHkO69DNt8ERWd4wKhoOFVn3QDNCuloKJ1lWagQgpdnxDqPs3/HON7kcMTeu9rdyCRLsuyHUvSFCQFBcw+2DZv/coVrhATolTRx0OdO9HJn+sGbNJZMOCerBpc0OS1aJ0s9CgGUJSn4pv7j55tDPkcDSXZ3PjFs4h0T+VT0ezxDLz7R4zvrENYonV+oB3dfMmdU5ikIc4RMR3U0vtI4XfrvlJwErVueDRwrxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x63auyXnSn0R3o0IXKh09/08urw9BWPQDXNWQV14Rhs=;
 b=Qmo8JvooXOLLyxDTubVJXs/yXKHfwusiiEbAb4P3Rzfk3xoWrFxY/Y3sHopZLFQgXUZzBWG2P93reLmukoewv3U5rvxtX0FlJETgO3+krMJ6VMWhAFUB6juc58pBQBE6bovxIQQJoKjJPddOaPz4YTbYNuW9gvB4J6KZunr60FYm9WCsq8aSXMcyMtZEQQGQ+kNZUqaGIsPICIPDgc9exEtEhRYnanviWNGQ6s4g8JU7syhaNadssn0y78/RiLfdVyp/xV4HFlV61y30IMGTfL4QneNaUZms67PtBirt5meqOUhUPvjXo8yDrd8NrkmeKvuLkgphlHBIpvez4NHFcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x63auyXnSn0R3o0IXKh09/08urw9BWPQDXNWQV14Rhs=;
 b=AoY//lakjz+UFY5mjTcN3qQVqjXxmuDcZ7d7ItCgAx5kAxYdw6sTMtv5Z89IuSiPp2mwjSe7C74jSWWVdKJrFwLxfEPFqhZsWOi9mS2Mcyi/BWUYYMNXKqG1eIxvDIDs+LTYHRNrCV4BqdDK3hU0zVewvi79eY9is9hX63iWX30=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH3PR10MB7863.namprd10.prod.outlook.com (2603:10b6:610:1bd::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.18; Tue, 14 Jan
 2025 17:44:33 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%3]) with mapi id 15.20.8335.017; Tue, 14 Jan 2025
 17:44:33 +0000
Message-ID: <e418a5ee-45ca-4d18-9b5d-6f8b6b1add8e@oracle.com>
Date: Tue, 14 Jan 2025 11:44:32 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vhost/scsi: Fix improper cleanup in
 vhost_scsi_set_endpoint()
To: =?UTF-8?B?5byg5rWp54S2?= <wh1sper@zju.edu.cn>
Cc: mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com,
        stefanha@redhat.com, eperezma@redhat.com,
        virtualization@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20250111033454.26596-1-wh1sper@zju.edu.cn>
 <bae5ca72-c6ff-4412-a317-4649f2d09cdf@oracle.com>
 <77e61a56.24e04.19463c158e1.Coremail.wh1sper@zju.edu.cn>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <77e61a56.24e04.19463c158e1.Coremail.wh1sper@zju.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR14CA0038.namprd14.prod.outlook.com
 (2603:10b6:5:18f::15) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH3PR10MB7863:EE_
X-MS-Office365-Filtering-Correlation-Id: a2b5fec8-c666-47d7-2c3f-08dd34c31b2c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dzBvYUUwcUhlVmhQd2Y0M01jcmRkRWFIN1dXVGlTTVdWZUJjdE1JMmw1NXRo?=
 =?utf-8?B?Q2x6WmhOWE94TkhBdnVPK25yM28yNlg1dkFqYS9JQU9jZGY0dGlkQVdUT0lG?=
 =?utf-8?B?MFZjKzhibGFibFdVOEd2OTl4aHMvL0lEU0ZiaWVzbUJVU1V1Mm9uTUFKcU81?=
 =?utf-8?B?Q092QWY2ZWRacktRdTExTkdFdkcvcWUwQ3NjY2VGSXpicTQvQkFEa2ZpN1pJ?=
 =?utf-8?B?ZlpjZmN0UnlKWHBxY1MzQXFVWFpUeEhTcTdKU3g5UDVyVTcrdmtzSk56aUJo?=
 =?utf-8?B?RUgreFNRTTF6US9wcmNUWkoxOFpSSGN3Z2ZmUWtxV3hvNXBQcGUyVmRuVHkz?=
 =?utf-8?B?VG8wRUMwQUFSTkJQUFZpdUN6alNSSGgxeGthaEk4N0VYb2tnRzRhamZiNEVW?=
 =?utf-8?B?UEZrSFJVd2taNXlPZkZFQ0dRYXIvS010clRvV0tVK2wyUm9FaGNDOWF5bEl6?=
 =?utf-8?B?WDkwZjBmLzJGbzd4WWhSVmRabTh2VndiSkZDUVlJeFBtcmlhOURxNkN6cmdN?=
 =?utf-8?B?Y0dTN24xYnc4cDEyYkpnWkJ3aGF6Y1ZDTTNDZFpobndIYWd1ZmllamsxbEhk?=
 =?utf-8?B?RzJXaHdlOGlyUlVDdkl0Y3lrMTJmUHNyM3R0TUY4SG1HV0NLNG1CL0ZEWW5m?=
 =?utf-8?B?Si8wc2hYWVBmK0JTeFFySHFDMVg5Q1NLc0syUjFHbkxMV1daUEtpOUxCdmR4?=
 =?utf-8?B?RmFjUXFETjcxTk1CN09CQVRndlF3bGNpdUN2Y2pjRXpYaFFRcEp3N2RkdGN4?=
 =?utf-8?B?aVhmU0wrNG5ERi9PTS9mUURZVlNaS1BmZGM0TVFPdFh4UGlvR0l2cnV6bmNJ?=
 =?utf-8?B?b1FyMWgrMmZGMElvYXpjZlhQcWNvSCtDa1NXQTJPK0xORldkbGt5bXZOOWlV?=
 =?utf-8?B?UW40M1U2SFVIenpRcnBwaSs0TGFPUGwrK1A1Q3YyNE9Dd1RGSVR1c3dxQm1r?=
 =?utf-8?B?YnRJeEFQN3FXOWdrT3pEamtCZy9vVjYvODZJK1ZTSU5Tb0NhMGtRSGJXUko5?=
 =?utf-8?B?QXp2eThhclF3QUpjU3FYM1RkYVc1RXFkTnJmYUdhZEVtMENneTJ0dXJ5Y3o0?=
 =?utf-8?B?Mk0zNU52UkNYK0huL04zLzlEdngrZElJNDY0SitoK0o1czBrODNWQUZyRzNz?=
 =?utf-8?B?Yys2SStTT1JvTXdudEZMRFRnMGo1V1ZidDBjd0tQSFc5ZEJjTXd0dkxvTnhw?=
 =?utf-8?B?Rm1FdEk3bDh2VEV0cFRnNzNWVGMycENWYjJUWFJOaXViRXJTblFkK2lNS3c0?=
 =?utf-8?B?QjdMWFUzTFozM1hoMHpZNWFEczkvWEJDckZaRkhUODVsSlhUcitqRVhNMHhw?=
 =?utf-8?B?a0tvUzI5d243OWZYUSs3cWNHbnVDblhwNEFkaUU1Q0V1OHhNbnNGeDF5VEpx?=
 =?utf-8?B?YWpWQTlsZ1duMUJRT3pmRUVkMkRmWEJidXZJL1lrVTkwMlVIdUlJYmlma3Y2?=
 =?utf-8?B?WFJDZ2pMRCtaZHhOVWM0UjBxV2pkZStadGhCTVZOMlFKckdoTWs4amg2UEc3?=
 =?utf-8?B?VEM5aTBGcDZqWkNldCt5SXhVd0gweTY2b3NpRzNrVGhabmhmY0FhcXR3c2lT?=
 =?utf-8?B?Q1Z3MXV1U0orMHJTVC9hQ3hxZWNEMW8wRjFSUEdsM0xPckxaTFN1N1VDMDVn?=
 =?utf-8?B?MXd5dmxUVTBTMEZqNE5rNENmSXpreGc4Tks2bm84dDlMNFFlMDNkUlppZEIw?=
 =?utf-8?B?WGIzM3R6aFc5aFIvYWxiMXBNSjR2RzNYQ0NTeDZOdEx3a1ppMjRDYkFjaVZJ?=
 =?utf-8?B?RjJKdEw4YktxVUZOdkhUdGVqdlhzRjZjYlkzY0tFdFNvQStmNGszV3hzYVN3?=
 =?utf-8?B?YWJGT0swQkJLVWRJWjA4S25aR1I0Q0xadE1zNmQzbU5ySTJ3NHM4SUJGMFRM?=
 =?utf-8?Q?GY3GdstKNIpx5?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RlIra0FOOStsVmpSK1ZZYktYUWR2NVhETmkvRHMyZ0ZxZlFSdStBT252aGUx?=
 =?utf-8?B?TkROVU1OWWpDbU1wMTU2QWN5SHBFcHNqS21HMlgwa2tNRnkzVnZXc013Wmpp?=
 =?utf-8?B?TkFnSTRZOEx0WWlraVZ2VGxHOWYzbUkza1FSbHBpSC9FaFJvMkpOR1NXL3Uz?=
 =?utf-8?B?U0xRQVlHMmgwamRSSDN4M2NaakhpMGJtMUFuR2FXUEdQUG03QVVYVkxHdllr?=
 =?utf-8?B?UTM5bm5QU2cxcHBTUmtITXc2UGp6eWhJMmNJejY5ZjFFVEovUkNCekVUVlVW?=
 =?utf-8?B?Tm92cE9uWUJuamR3cHd3L05ERlJnMmxiRlgwS0N2cTYzYzZlSUx0VDhTK0Mr?=
 =?utf-8?B?WnltY3h4R3FTTjVnYUdwWWFyQkJPaHhRSnVWRzlZWDhmZFd4ZkI1UUROamZn?=
 =?utf-8?B?Yy9tbE85aHdWQVFHTDlWeGw4YlluSis0MVpqTlpVcFc4YzBKTGE5MXN0M3Vz?=
 =?utf-8?B?Mm5TVElGNXFUYWIzcFlGYzZGUW9CbHdPT0RMVTFpbnV4SVV5aWVhSlE5R1BT?=
 =?utf-8?B?SGgxaGduTGlLbGVlL2VuTmlCRnRJY1JlSHVuL1pHY3h0WnBjVlRYT3Qrc0FW?=
 =?utf-8?B?K1hNemJyTHd4RTg3bkw0MXF1Yzh6UWxCK20rb2NxYlQ0a0dTMnV5UHpIOTlm?=
 =?utf-8?B?RWRHNTNiMHFTcVQwL0xtTGN0alBUemRKdDlnSkx5ckFwSVlzTFZBTFNLdlRT?=
 =?utf-8?B?bkVUMC95STR1T2VzbE9pV2FMVmJ0M0plcG5yWWw3bC80cEhpV2FjbVptT2FV?=
 =?utf-8?B?U0ZFckh4eUtzc1ExNlFRWDRoUGg1S1JPeDAzenZGaytEcG1oZVBlOVhiUGNE?=
 =?utf-8?B?RE1LblFDeDJPT0gwaVFhWmJUWmhvU2xZRWZBT0JlQVRGRlVVVE8rendpc1cx?=
 =?utf-8?B?ZXVXOFpwVFUyNUwvYno2UnlaV0xVU2tnZlUwTHlFaXpLd0M5bUc3dDY1bVph?=
 =?utf-8?B?dVUvOEU2OEpvVVQ0SDhTQnhyVmtUSkJZaUJ5Z2MzcCtVZjJzTEcwNjI2RnJ6?=
 =?utf-8?B?bGJWdnZFMjY3Wm5oN3Z1SFcrMjVySnVId0F2eTBIajQydmwvL3hkUmd5WUdB?=
 =?utf-8?B?NkloNXIybGcwQUhwUUpwUGN4dm8yWWV6bVF2c1RsVTVyRUJBdXpMd0YxY01B?=
 =?utf-8?B?UkNPcWdJdDBXTkRNK1BLMlJ1ZHZEeS9aeithVkxXNDNtZ1dpWmpzMzFxUks1?=
 =?utf-8?B?MnI0UHNHbEc4TkZhM3QrZHYxelZMdVZCVzd1aXJ2QWNzT3FjTFZTNTQ3SmUw?=
 =?utf-8?B?b1dwcnFVYjFBTmlRdkpXSHBoQzU1L2ZrcjQrTFBITFdvNm5NcjVwUVFzRmlq?=
 =?utf-8?B?aDMrV0xiQ0JVZFcraG0yUlRkaXQvZzFlMm5PTm4ya3JDczNITTFDS0Z3cVl5?=
 =?utf-8?B?dGJjUkxFU0pUN0c2RXg5QVBPTmF5VVhiSjYya3BEZzNmbFR2REVzbXZkbkN2?=
 =?utf-8?B?SXpGMDNSVVFDU3M1U3Iwc3Y0ZExsTzdPY0dtMnJ1WDlFSllRUU83VEpEOEVB?=
 =?utf-8?B?OUVIY3EzT3QwZzdsK3U1STNUbjZtdDdEbTZPN1BpWEF5VEsyQ2tLRlBmSS9L?=
 =?utf-8?B?UHJKa3VSdWlvcnFSeEYvNXByeDZJZDZhWlVRVU8wWTcvcmEyL2hwM3JqOGFX?=
 =?utf-8?B?SCtqdWpBc3E2dG9SeUE5S2VFelE5WWJlbG5QMlQzNFY2NElUYjAvb1A4TmVN?=
 =?utf-8?B?UnlVL3l4V0tMa1krVHhjZ0RVMnRWSlAzbkErNFdVNlFmaVQwcUdFQzB1Y09i?=
 =?utf-8?B?a0g4OTZYaTBKSzliL3JBSklXWnNsYmNNZ2dUWnlVWXdncktLZTBoUGNuZndk?=
 =?utf-8?B?RmRYeEt1V2RMVzhES2FwMnZpSWV5eUVtSndqT3JpVEpXU01GeU1RaTd1eFJ1?=
 =?utf-8?B?V1R1VGhudHFmcmtDZUNHTldvWnVnRys5Vk5LM2N1WjhyWktvNWMwY3lDZGlM?=
 =?utf-8?B?eTc3dDEva1l3QkRUejI4S28rYkFDdE53MU5YNW1WdUdaOVYxVytqVmhRVTcy?=
 =?utf-8?B?dG1ZY2tYbzlvZ2tWWC93SHJaU2Q0ZmZ2T2hsbWRzWVdVbnpqenNLeTh3NGxl?=
 =?utf-8?B?VXdINHQ3VnR3QUVsN3hzcURNTldXY2Y0Mk1CenhNd3NiRUdFYnVmV2MzU2pP?=
 =?utf-8?B?TzF0azE0U2F6d1RkaDV4RUVDMGpiOUM4OVRaU2tJWTJmYlhNTVhGbnZMZ3I0?=
 =?utf-8?B?R3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jKB3IVdkdrY4PnYQBxGCi0VkQgOAXfRr/mJaFlK/DYy1JNLc9eChPqjvgl1KKk1VP1T9t4sD95XpIn+2DjpfN/WQG5vkocCWq60U18IJmEhRee3eH7/bZy3rWniBVAibPtfFHUds/A2nWLaJXu0X9YLEOy1QS1rvY5b21xWrE589aIyupH8dGKRYDpXPElzzJlaCY4moNwBoIIrCIHBIXfC5jIQc039wR2FdOWWaXWagktuxUH1QP857EH6rRHcqyPW82YV/S/HaKWAGjz82Kl20RGuy2qnDByvyXZOTSrnznqn3MGB655/hmM/vO1pqypP98e7kxQqiL78P4oTeCwfNVpu38UujARTCKS7fgLIcQyBczIg/qP0WXHcC+4h0rxiDjA6Mmn1JpdeldwLMNSxDdjJoHQGxYqMi7wOJ8Dr3pfgSlPwgIF83fbrsYdqMaQRWjxTpL6K1zClJHzWfk9SN7BBl4P90HSW09nHWmwtCbdRBt4pA//bbSZRjHwL33q2HibKKYWl3NrQcrc4QNIs+Mm0FGjDW2Xs7Ds2ITOt+rnqr0PK9U9DRY+LQUaYhaFSTLOQjKkhlywrYKZlnKIWJemYQeJEkTaRkZCSLbwE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2b5fec8-c666-47d7-2c3f-08dd34c31b2c
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2025 17:44:33.6825
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kVXjZKxWl/dueLdU/OP/3LIbOf4uVR7lP0CaLOL1p1a0o15Lqtg/UXRhsNLBoCL7BeOcu8+NKG7slDlB5p9QNgATp5f0hwL5R+VAkEuUiI0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7863
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-14_06,2025-01-13_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 phishscore=0 bulkscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2501140135
X-Proofpoint-ORIG-GUID: zQEy3IKdHhNqVZcrgrsoH3XGxMcZfE8f
X-Proofpoint-GUID: zQEy3IKdHhNqVZcrgrsoH3XGxMcZfE8f

On 1/14/25 1:40 AM, 张浩然 wrote:
> After reevaluating the PoC, I realized that my initial claim was incorrect. The target WWN in the second vhost_scsi_set_endpoint() call is not the same as in the first one. Below is my targetcli status:
> 
> o- vhost ......................................... [Targets: 3]
>   | o- naa.500140501e23be28 ......................... [TPGs: 1]
>   | | o- tpg1 ............. [naa.50014058f7da10b7, no-gen-acls]
>   | |   o- acls ..................................... [ACLs: 0]
>   | |   o- luns ..................................... [LUNs: 0]
>   | o- naa.500140562c8936fa ......................... [TPGs: 2]
>   | | o- tpg1 ............. [naa.50014058d133f962, no-gen-acls]
>   | | | o- acls ..................................... [ACLs: 0]
>   | | | o- luns ..................................... [LUNs: 3]
>   | | |   o- lun0 ... [block/disk0 (/dev/disk/...) (default_tg_pt_gp)]
>   | | |   o- lun1 .... [fileio/vhost-fileio (/root/fileio-vhost) (default_tg_pt_gp)]
>   | | |   o- lun2 ............. [ramdisk/rd (default_tg_pt_gp)]
>   | | o- tpg2 ............. [naa.50014055c6fb4182, no-gen-acls]
>   | |   o- acls ..................................... [ACLs: 0]
>   | |   o- luns ..................................... [LUNs: 0]
> 
> The bug occurs when `naa.500140562c8936fa` has already been set as an endpoint, and I send a VHOST_SCSI_SET_ENDPOINT ioctl command with `naa.500140501e23be28`. The ioctl returns -1 EEXIST (File exists), and the kernel logs a BUG message in dmesg.

I see now and can replicate it. I think there is a 2nd bug in
vhost_scsi_set_endpoint related to all this where we need to
prevent switching targets like this or else we'll leak some
other refcounts. If 500140501e23be28's tpg number was 3 then
we would overwrite the existing vs->vs_vhost_wwpn and never
be able to release the refounts on the tpgs from 500140562c8936fa.
 
I'll send a patchset to fix everything and cc you.

Thanks for all the work you did testing and debugging this
issue.

