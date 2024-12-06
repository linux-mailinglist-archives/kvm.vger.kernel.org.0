Return-Path: <kvm+bounces-33226-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B57C59E780D
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 19:26:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7228C2828ED
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 18:26:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 728C5203D56;
	Fri,  6 Dec 2024 18:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JfAZ+SBz";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="gIPbwCcp"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B73761FFC67
	for <kvm@vger.kernel.org>; Fri,  6 Dec 2024 18:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733509588; cv=fail; b=Fy98ZUgn70LTuaFmlgZoM39TspFAO7/dTEXbcqAwkOOoB1KAARKW2JARHO98S8Pu/IuEUeTt6bomh90zRHjG99f6fun31SvD0gDc1m8NL0Gxh9gaspmIdnWobXJ4DKsfYkMw0k/oeRXrad3A1O4Nv8UNj/hX9Ii15jkZzUwrcBQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733509588; c=relaxed/simple;
	bh=IOCHEjBziKIwCrkMmP4hFDHf+/mPICK244jlzpx3Q10=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rtxuctzLvii0AVSfSXniO+JSO30pHUxwhDxP11tuDFPYyHbuzm2iQSN3ESuK47r3FGBuWB7MXtIsjPtobgNgtQgEZqzJ9epzLT9nEmNwstxLAc5FRYXFZJeSRtTKm29IrBWrrKtDFzS4oENGxfHcNcPfLhoHDsgltxTRT3gzl20=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JfAZ+SBz; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=gIPbwCcp; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B6HtumI002582;
	Fri, 6 Dec 2024 18:26:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=JiIg/j1Lt+Gr2DDXgGVKxjXjUaBBK28d1OEvdInkV0k=; b=
	JfAZ+SBzUntNYR9GwzZwVVKmDT/tzHukR1mYFiVpSPVcYEMLaGtqq0O4r86qxrU1
	Dd8pA6da0y7iChD/dfeWtYbgrsXvDvUuJ9uJOT6HxTUI/0fu7bsee/utsaOjKI/M
	x/NipqC/JmMQlMmXhXTOeU3MJnHlxE6dy2/Oaowp+yeDWGBXXQwr+J5cBYh+Lrac
	MtPTMame/vpIHr2gpQ4JUu5CvzAFEtAsUAB7XwQOtKJwliiwV/RonRuXt2Kl9aae
	aFmqODcmPg3JM+S6jno01lau7JbnDSzNWDJHlX+tLtQyQWCJ1gv9gj37gO08CnSn
	j6XzenY7FFdswRYsqHznDQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 437smap5xy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Dec 2024 18:26:09 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4B6ICnMN001373;
	Fri, 6 Dec 2024 18:26:08 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 437s5ck1eg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Dec 2024 18:26:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LSviE4DRFHqqYjrE7RrZyn4U/o/OQYAzBj0l9+8XUnJhirG98pZPghkXDud541yo37oO6MAlo0Ve9awAdQ8E7Phf4sILSjEK4aXhwdc4x4IEjQVyz4+5Q2rlK2ySux08P6enUbWVsE7qYVK1hf0XWOnusjKSe4qBsANSb98Yd6Zca/jueMSvrYvDw/VIK40P6r5skhl40FSefKV/UXYTmjv1rt/IqWfzRjA5uOoD8jksfXl+cBzzpL8gTVKEk2rfhDZeUnzlCM8AG8yiI3EGogZzuK1w/5fAcdfBUdv29jBdXF3Q6a8g9S2uAwz81wtE9jDoo588GSrSwsdzw27Q5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JiIg/j1Lt+Gr2DDXgGVKxjXjUaBBK28d1OEvdInkV0k=;
 b=GFj+wpfiRZhP7okCCnTXvxr12MLQ22u7EunL6xzMSWP8dDuK24p+U/NATDPbOFQ63yIzURixqToblJCBuffpwct+KvwBECapjqNLjSnOrrTXS2GYTq++znqzfUcdI52GxxSSge2P8Q6UICHOeYrI/WECLbMLauBVoxrGl+PeqvYY6dkLY6TRb89VNHnBDaWD1Yf5/QQ3a7u5cDmnUoIf3mZ7NR9QC0y5zszlC2f+b72lmNOFjXT3Xjbai0t/y8wrv3rCXqZNNl9Gboen/W6flYpjtmzsql5K23+poR1GHQdB4sM4qKirg8SMT3jGVXZD+4p4Wimqlf4TTYesZ0t+ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JiIg/j1Lt+Gr2DDXgGVKxjXjUaBBK28d1OEvdInkV0k=;
 b=gIPbwCcpapMzCFOSFIWEuYylU9fXuNdIiXZ0wAEC3GSIXiPNAZOOqir20g0n1xvZ/0tKpMIL+0hHyS+7GPmOUopMjxi9NFIz7Z9a9MUVtR5bPLvQMUNHfkJyL+UMFrqE0UWK7ZeWVtqtYsSfSpE4P0VbHEnGORovYypRj5nxmpw=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CY8PR10MB6803.namprd10.prod.outlook.com (2603:10b6:930:9a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.11; Fri, 6 Dec
 2024 18:26:05 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%4]) with mapi id 15.20.8207.017; Fri, 6 Dec 2024
 18:26:05 +0000
Message-ID: <c5789e2c-e4e1-4203-8b0a-d7aba461497d@oracle.com>
Date: Fri, 6 Dec 2024 19:26:01 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/7] hugetlbfs memory HW error fixes
To: David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: peterx@redhat.com, pbonzini@redhat.com, richard.henderson@linaro.org,
        philmd@linaro.org, peter.maydell@linaro.org, mtosatti@redhat.com,
        imammedo@redhat.com, eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
References: <cf587c8b-3894-4589-bfea-be5db70e81f3@redhat.com>
 <20241125142718.3373203-1-william.roche@oracle.com>
 <48b09647-d2ba-43e5-8e73-16fb4ace6da5@oracle.com>
 <874e2625-b5e7-4247-994a-9b341abbdceb@redhat.com>
 <e09204a4-1570-4d39-afc7-e839a0a492d8@oracle.com>
 <753a033c-7341-4a3a-8546-c31a50d35aff@redhat.com>
 <31693f78-dbef-4465-9c8e-a68a25cb4af2@oracle.com>
 <fcf373b2-cb33-4764-a2bc-c95a0d76710b@redhat.com>
Content-Language: en-US
From: William Roche <william.roche@oracle.com>
In-Reply-To: <fcf373b2-cb33-4764-a2bc-c95a0d76710b@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4P192CA0017.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e1::12) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CY8PR10MB6803:EE_
X-MS-Office365-Filtering-Correlation-Id: a5cc75a9-7d43-4356-3f5a-08dd16237212
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UytuMEFjYlFYbVB4Q3NlUG12SW5ZajdveEVocnhqWitWUG5FMSt1c3lsZEFP?=
 =?utf-8?B?VUNxaFp4aFhobUJGK3l0VXRIN2hscm9tZnp6RmtrUmJKWVVXVGZ0ZnFOMXMx?=
 =?utf-8?B?enh5K0hJYXV0eXlzWXdQQ1ZIMGVHZ3JwaU1yZWl0NzJKR0xHRXYzWU91Skxi?=
 =?utf-8?B?bHhwek1NT2ZxbTk0S3RPS3l3ZEpmSVBZT25rVlJianlEV2JkejF4VXY4R2gv?=
 =?utf-8?B?ak5DSGZieEgvNlFRWkpSK3d6aUdFaXpvSVozNmxpOWdtVnFEV1A5emlXRnJY?=
 =?utf-8?B?bE5qaS9BNHBYREJWN0pvU2xIVXpLVjFpNk4wZEVLbVlVNytIWE1nWWxtcGI4?=
 =?utf-8?B?ZHVFWkZrWU5XY3Jhb0MzTkloa0pWbGFpRHhZamdGekRybTI2M3VaZzhVa2ZI?=
 =?utf-8?B?RzlCaEZmM3I3aDYxdGlFL01pSXkzWlVSUDFiSytKSXZiYnBqSFpyTjQycWxU?=
 =?utf-8?B?S0dzcEptcnpHRkNrbmc3clNpQzFKQUZER0IxUlpHWFNzR1Q4R1d0NXRDeC9I?=
 =?utf-8?B?VkFocEJnRTFkVEUrc3hIVUViSW1ZL1BPb0F2N2ZqRnRzNCtnR3ZicjJtaWl2?=
 =?utf-8?B?MTBZR0tTQy83YVVPempXN1pVNmFzM2RyUHdTLzZ1eUM4ZGhFRmVpeFhybWlh?=
 =?utf-8?B?WHc3cmU4bXkrbmVZOUZsUzlYeDR4NTRraVVYQTRPUHZJem4yUC83K21oR3FZ?=
 =?utf-8?B?Ynl4QmJIZHhIbXUrdkhzTTlCZDVhRFFOYU1JcDdGd3RXelQ4aEZXd3hCZE9j?=
 =?utf-8?B?T0lyeU8vUHhYWnRKZExlV3h5VlJBbkpZbDl2aWFTeTNDYjVvcGRaQlpBZXpR?=
 =?utf-8?B?QjBjL1ZWd2pTZExOY0V2T1BramVZRmFzZlZhUkJLWWJCdmhDWUhEUHYvcDhl?=
 =?utf-8?B?Zmt3cGdNWXl6TktTV2dVSXd3eVU4NEh2bmJ2NVJSWWNmWmVseVd0ZUhqZEk3?=
 =?utf-8?B?ZmZ3ZnRyUkF4SncxR3BTQWVHdXJvNms3SW1wT0JGZDU0VXdtakUweEx0SE0r?=
 =?utf-8?B?U3NtTUVlSklqR3FZRUdDTllFdTg2SkxOZzJ6ajRpNzRFMVRxaXE4TlJaeGYr?=
 =?utf-8?B?KzVNU25wYjJ2NG9vbXdZcXBRMGJ0QjRzREJqQUhoeXpmbXBNU0k0MFErMTg5?=
 =?utf-8?B?am4rVXBvSHJzUWdMQUY1YUlQSXpOMmtVTHY2QmprK21vQ1NEVlFEUDlpUEZ5?=
 =?utf-8?B?NytEdEhTbmRHN3J3aEVoeEJPNUx6WktHNW4rMGNXMzN5V21VNm9ELytsT2pw?=
 =?utf-8?B?elhMT0NCVzYrRnlMcVRxZFR6N21SbHhHaEY4Q0s3d0FHVzFudFp1ZndnS0Vt?=
 =?utf-8?B?YUtNNmkvb0ppNTVkR0xURFFLd1JWcW15bnJsTDZTeEFPd1VJTnovclZNT3NK?=
 =?utf-8?B?OVZuaHNPOUVORWJRbVo2Vm9qYUpIWnd6Nm9YOExIYTVGbzZ1SXFxVlN1eWYy?=
 =?utf-8?B?SEJVb0liVjlXUWFTclZPeVhpQkphZVMvMU8rR0l6WEpxd2VsVXNMbng4eWpS?=
 =?utf-8?B?a1RIMndtYWNsVTZtTDFBZmU1cG9zalRxckwyU1IrUG1UL3FQRXpjV0JmVzYy?=
 =?utf-8?B?Y2lHRGpXcUwwKyt4Tlczdk9ZWFd4VHNaTC80bUZRd2hGcmZkdEt4Q0hkZ3Y5?=
 =?utf-8?B?V3htdVV1NDZKQ3VXbUZmWWF6RUpJV25LS3ltang2SGVDME1QQTJ0cWJHekhu?=
 =?utf-8?B?Vmp1L1RxQlBoN2UxSUgvYjJ5amFVby94QXBNMUY3dTErYmZ6eCtqVXN2MlFY?=
 =?utf-8?B?ZDk4N1BnQTc4NTF1b296OFp3WW94WGh2Y2xPSitPSGJVNmRydVY2RUc2cFRh?=
 =?utf-8?B?bG5JakwvVUxXOVZLemFTdz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dHZteWxYbXdvOXdlZlFvRWxTK0grQWYvci84bWo2WTJwaHVXRWlEUWtjTGR0?=
 =?utf-8?B?dEU1MlY4VzVtc3VWemRhZG5GWk1MZ0NEOHRTTzdlK1g1eGpRZS9TOGxMOWlZ?=
 =?utf-8?B?ZGwranVKTWFsaXFpK29aQU9jN0FJSVhPOHhmZjJGZkJFK2Q3Sy9NblErcU1M?=
 =?utf-8?B?aStKckRQOGxIR25SY2dTcEl3WDA4L28wc0lmNEJjRlpBSnhmYWNYaEdsR2xl?=
 =?utf-8?B?SVV5U05yL05PdEVZRlZUUy9pOS81K3NqS2YzK2J0bDNWcExmYUNzTHNnLzZJ?=
 =?utf-8?B?Nmw4Z3JwTVRKY2JvMUk5MWo0ZURaZnRLbFNJMWhkZ2JzVzl3UTZuU1RnVFF0?=
 =?utf-8?B?QVhneVR6MHFtZHBtYlBQeXJxRm5nMXIvbDJCOHFySUlvSzZGYUJwK3VqdEdD?=
 =?utf-8?B?dU0vblNIYXhqa012UU51dEV2dVBxLzU1cWo2OGxQem5OMkVTaFgwT0Zodi9n?=
 =?utf-8?B?RlE0SjJqRlBjSTJYVGRJZHBMMmlsOHpxZTBMeHphbHg1bUhTdksvWlVNVXk1?=
 =?utf-8?B?dHpQTEV1TVNZZFJna1dOWkpuZ1k1c1NGM1F5bWVIdWpwVEwxSnpWQSt6Rlh3?=
 =?utf-8?B?aWVlODk5WlBIcHVJTkpuQ0RHcjZUVkZneUtQcnBObzlmNHZtK3VBaG02T0V6?=
 =?utf-8?B?bWtnZWtwejNUdEJrUDVWVk1SdkZpNTgvOFpjckZ4WnZMUXdPZnhyUnJocUho?=
 =?utf-8?B?UXVESjd6VnFRYzdQczZZK2R6RytPR3dEMzFEMlZIMG5sWndRb1hCcGh2V0dv?=
 =?utf-8?B?UTlWNHZxc1JqOFhXWktDQ05ZNUVLSEpKb1ZrNXpaWjY3SUlBbXFtSDIrL3hX?=
 =?utf-8?B?c01sVXBDRkowRUpXSmdPU0V5c2tDUnBtR3ZCbGppQXBtM2xDazg2bmg0Zkl3?=
 =?utf-8?B?ZTJGdGxMNmhETkFFekZzTlA3dDQyeHdRdDhMYy9rbE1oY3c4emNBdGVEbVUr?=
 =?utf-8?B?ZVVIWUljSklIQmlqR1VaYm5lTXhDTEdpWXhOVzVlL3EzMTRuQzdKTTluYmtT?=
 =?utf-8?B?a3NBRE5vS3Z4a0dUUnpPQWFEbldDNnNwZ3VmUzlVMXVhdHFTTDEvMGMrd0RE?=
 =?utf-8?B?bVJiTTFFcFBxRWE3SS9FSVJVdzRpZDdyWU0zSUdibDVoem1nV0p3d0RXM3hp?=
 =?utf-8?B?VE9xRkpyU0VvNWlvcVFKVWorOUp1eWpJQjJsRU5nTUt3WXJvTEJsRWV3TXBs?=
 =?utf-8?B?bm9aVTZ2bEQ0Tjl4MG1acmpVMW9zTTdPWW1lMVZnNzJTMjUzUXB1a2JsNGIx?=
 =?utf-8?B?d0FKY1RKbUZGMVRwMk9SSTdKYU5mTUZ0aGgvWnpmUzEveWxtMDNGSmFJdVVX?=
 =?utf-8?B?cStCWUprdkhNa1JZdGtZWmpneC8rTXhkTDM3TE1WL1FEbHZ4NXRUY2VYNldN?=
 =?utf-8?B?ckxiRDNUOUQxenNkdzF6aTl3R1oyRGwrV2MyeTRyaGM5emk0ZjhCQWFCNE01?=
 =?utf-8?B?VkxEVWJUYzVsZ3lwYjJHSGhBK1NEOC8wWkZaa29ubmpKcTU4ZVBacXo4RmZZ?=
 =?utf-8?B?NEc3cnFyNXgwQVRyVy91ZjJHaFdtdld1ay85MzhHM29jTGtqVDBObXFtaitt?=
 =?utf-8?B?VWVsK3J0MXVoT2JSWUM0eEo0NXNwYTBmcmp4ZXJFL0NZWDhLbnJ4dndmVzQ2?=
 =?utf-8?B?K1RONE53YzZWSGNZcTFHNUxIeWFFaVgrclNmK2dkQ014aGsxOSt5VnFUUWV2?=
 =?utf-8?B?ejJxdUMvN2tuUnRwR3E1cWNzZmZydFc0VEZvQkIrdGZXQVFMVFpnblVVWlkv?=
 =?utf-8?B?L2NLVmpVTnpYbzd2Y0dhRzVXS3FPWmtwYmd4OWhxNitscHRnRkxxd21XUGp4?=
 =?utf-8?B?K1J3U1hFdlNheWc4d1FYZFNIbmxJenNkME82Ym04eHpWL0pVWHNWYVpKb3Vi?=
 =?utf-8?B?VkducE5rVTdFdUNkNVVJdVFQbE5TSWpZSWlrNExDUjFadFRleExPdnBLd0pD?=
 =?utf-8?B?dzN1dmZ0bXQvQ0YyQjhKd2haMlZ0WnlVaU4rZks2ZisyOU1KWTZnSkZHcTNn?=
 =?utf-8?B?OWZPclpVSWw2N1lpQTR0UTllNi9vOExMNjEyUG80UHgrODFoNWVzZTlRYzgv?=
 =?utf-8?B?ckQ3UStOU2VvSkQ5dXRVVHpuY3hRbllUUkswbWNVK2tuRFNuR1JBZkFYUm9x?=
 =?utf-8?B?RU92SWF3L0RDWThIVE51bXRzbGI0c3NxNHg2all6b1B0WjhVMHJlSTRxTENm?=
 =?utf-8?B?cGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	en4ZEgDL/UQJetFv5C0RC7KUB3DK+/U7bUkYfNMQBqjTkQ/t3jCQ6BcYJhYGGD7ghz6B3JHADbVx8bYVKWonFobzmI6Hk11JhcV/3XMPKnqfrHVLSFxXzn30P9U5klCblwXfJv4T3RWiyhZl54pX/juJAPO+bEIyDyjWItMj3x2Z6Nn+pZJ8U4D3g7R2/3zkk2A7EoAEn1qM4lKCz6beYmXmTW7CMnVP1bgEoCDhU3jYEATeaGdDLnvuGG1KzlwCWMySR5coD3AKHuATvXccqMLp8bKSarODtNuq95qr/f2mrXCTsS7QiCE7fE7ixkGQ603IHEmLsQ/D96UCT1lyx4sWW56DckjXCvywkyVSipf0t1DxQDNINyhMaw0VIZjqVDQNwUy35p+8FGNPAQ2s0cg/Ynhf/OPIEm171dJeH/9ZSvlVyg4lyckcJ8DS+BkbGoeM/GPMpRUGqyJiWKrZIUmqhZroNzroByp7Y5mpNUx9HZdITrpPy7AVFNPkT/xI3Mehia0OreZSGkU7GFn/x01UTRog9YpQs4aJTZYx6eBR3odnXble8uKk1fKRAKtEwP2BGi88d4/5VXLOw3tWV5MhwqCBxBJ4aA87ZrDYer8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5cc75a9-7d43-4356-3f5a-08dd16237212
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2024 18:26:05.2989
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fNydzpzn/TWaW0clp4mW9Z5HzSc38B+8zvZbjpinLoSc3Vtg5VVoAENsQPeujwLP6aIfp277iCyshYZjTWFYzWN2DZa//TjCQzKmIcBvpQc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6803
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-06_12,2024-12-06_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 bulkscore=0 phishscore=0 malwarescore=0 mlxscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2412060138
X-Proofpoint-ORIG-GUID: E_cUd-zTRvEG7cp94-ncXUQWFGqwx6Gd
X-Proofpoint-GUID: E_cUd-zTRvEG7cp94-ncXUQWFGqwx6Gd

On 12/3/24 16:00, David Hildenbrand wrote:
> On 03.12.24 15:39, William Roche wrote:
>> [...]
>> Our new Qemu code is testing first the fallocate+MADV_DONTNEED procedure
>> for standard sized pages (in ram_block_discard_range()) and only folds
>> back to the mmap() use if it fails. So maybe my proposal to implement:
>>
>> +                    /*
>> +                     * Fold back to using mmap(), but it should not
>> repair a
>> +                     * shared file memory region. In this case we fail.
>> +                     */
>> +                    if (block->fd >= 0 && qemu_ram_is_shared(block)) {
>> +                        error_report("Shared memory poison recovery
>> failure addr: "
>> +                                     RAM_ADDR_FMT "@" RAM_ADDR_FMT "",
>> +                                     length, addr);
>> +                        exit(1);
>> +                    }
>>
>> Could be the right choice.
> 
> Right. But then, what about a mmap(MAP_PRIVATE, shmem), where the 
> pagecache page is poisoned and needs an explicit fallocate? :)
> 
> It's all tricky. I wonder if we should just say "if it's backed by a 
> file, and we cannot discard, then mmap() can't fix it reliably".
> 
> if (block->fd >= 0) {
>      ...
> }
> 
> After all, we don't even expect the fallocate/MADV_DONTNEED to ever 
> fail :) So I was also wondering if we could get rid of the 
> mmap(MAP_FIXED) completely ... but who knows what older Linux kernels do.

I agree that we expect the ram_block_discard_range() function to be 
working on recent kernels, and to do what's necessary to reuse the 
poisoned memory area.

The case where older kernels could be a problem is where fallocate() 
would not work on a given file, or madvice(MADV_DONTNEED or MADV_REMOVE) 
would not work on standard sized pages. As ram_block_discard_range() 
currently avoids using madvise on huge pages.

In this case, the generic/minimal way to make the memory usable again 
(in all cases) would be to:
- fallocate/PUNCH_HOLE the given file (if any)
- and remap the area
even if it's not _mandatory_ in all cases.

Would you like me to add an fallocate(PUNCH_HOLE) call in the helper 
function qemu_ram_remap_mmap() when a file descriptor is provided 
(before remapping the area) ?

This way, we don't need to know if ram_block_discard_range() failed on 
the fallocate() or the madvise(); in the worst case scenario, we would 
PUNCH twice. If fallocate fails or mmap fails, we exit.
I haven't seen a problem punching a file twice - do you see any problem ?

Do you find this possibility acceptable ? Or should I just go for the 
immediate failure when ram_block_discard_range() fails on a case with a 
file descriptor as you suggest ?

Please let me know if you find any problem with this approach, as it 
could help to have this poison recovery scenario to work on more kernels.

Thanks in advance for your feedback.
William.


