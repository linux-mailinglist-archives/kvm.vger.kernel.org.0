Return-Path: <kvm+bounces-15722-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 24A288AF821
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 22:44:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 47C601C220C2
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 20:44:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95B6E142E8A;
	Tue, 23 Apr 2024 20:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZnckUDGD";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="BfVb5/hH"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C751313E02C;
	Tue, 23 Apr 2024 20:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713905047; cv=fail; b=em1v8A8biTprCkamri+4MI6Xz5ZSFb6CLe4UdBYh88GaRMcOY6JZDGwDKpKRfKVx4CFh1hc4vvQRIEC5kY6tLEoh47o4Xr2jAZ46X1I0Z7zm22sq/rAsPP2SBzmPbRvlA0Dh0RM9mTIr0TnLhPQG0IBsifutQmRVoLETmCK/xcI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713905047; c=relaxed/simple;
	bh=CA687IsR+MFjSwh3aZnQ+p01WrLm1ZMMcdcACOjsjJg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KSXXIDLl3mXcpMFILOL6oxXnzp7lC3bKxEdtr2seiOizJ7E27prVZBIoYr80hMLZCNTBfb3oEtHYCbheGIHyQu0qE7FEJLa0noXAY5ZuYmePMMOrA0QuDFq6VPuWfPMdxemHqxCVcn5FKmTFdPTJdPuSOxDZa8Lf+0GvuSeEAX4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZnckUDGD; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=BfVb5/hH; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43NJd52v019325;
	Tue, 23 Apr 2024 20:43:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=U2WtTRWTo1N7s6FIEfEm1M9gG/0oo9W/j4eE1+PfG4A=;
 b=ZnckUDGDpOiKshd4tStho+kJsfttC+sw7g+/GN8beYSxcwstUEY7OdnFJeMgDKMxe1PV
 qTKi9sz68JsQeYldNjnlZy4xIU5Ew8KHmxRVqfjR9A1hM16/itgBJPOD8emtZanfyuLs
 wOtwxGrr7cbFv5mxgBjgwTz+wAEnZ6CJmjuItmyk062nnU7c4X3KRXKwlfXdsnRcyNrZ
 nJRFDvEWVZinM2cZDZEemg8MAZmg1TypJ+xziEXUxvOnHi3rvSNn0MOWDfMAWeqeljn2
 33PBTtB+PZP7TOzZZbt9oLdI8+Zo1bHSeaAgoKLjG8QsUG0ck08008AlExRLgibbup02 qg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xm68vexku-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Apr 2024 20:43:58 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43NJhaUv025412;
	Tue, 23 Apr 2024 20:43:56 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2173.outbound.protection.outlook.com [104.47.58.173])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xm45e4cj6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Apr 2024 20:43:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dic2jSco+avYWmttKFSScSgkWGy87xSPRqMhV/SwlAvtsKWRYHGjjaZ4cYfBjIsnZmzCA5t4RasFpwU7GbKnLGWZCFQLeOSx8najEch4UJUcGSTvZWw6SVh/6176WqF1BUcHrRuMSf8ay9iL6fpXthGo4LP73Swy49xgjxaYKQatB8PfKrWaQrP1iG23l8fpuZfVotFX+NAOpv8KPgEJGb0AQmhxkxf1o+OJHkR3Hn40kMSgq3r033NRqy5I2BNDKSV903tjq9eccsqdehoD0o82hvd2CmsS1pEP+kRGlaIWuOOnSIlrHOAtwvdvz0mH26qz1XbfwXTcIg6KzUDSfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U2WtTRWTo1N7s6FIEfEm1M9gG/0oo9W/j4eE1+PfG4A=;
 b=i1ZO4uJBmv2DBZnVmU/ZceDdHVCZwR4ttUzx8pI1fhxGNiJPHnNzOfG2QirEDciYpV7SPvYlem301wKFxNNyNqweXGDHObw2hQRoKkPXOd6q2f+vtjwBgNCzO5TKZvnbpVu07sVcfWKH/QdWy4Tb3QLLZD2xaOFgUuqz/ajwlul7pRr/z0Jt17gWYu0NYhcrqFJNcs6s+vOKGYPq3Msn1503kdNd25OtVyAa7iNqAKKy90UnSjiRuZqKP43LBWexOzOOf/MTGeaYKkVhWZa0ScDufZgVxh0wo0hAx8lSypDebZBnlqG2lwgtoczoAt/kZiPjlmfmBExwoRJYltcxNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U2WtTRWTo1N7s6FIEfEm1M9gG/0oo9W/j4eE1+PfG4A=;
 b=BfVb5/hHEojtHFFAu3P8Fy+ttIHnbg6Oq+jCwcxmocxi45zW1C+NVqsfbMqnN2rR9x5ZwaZtrmdE08ZGbHqnn1AsP65FAfKroFzvtHDU06uIHXT3vJrgu/j6tTC/cHZ/aWq0jVjb0hs7tzu4TUdvlYGSMDT21/z07zD0QOGh3Y8=
Received: from DS7PR10MB5280.namprd10.prod.outlook.com (2603:10b6:5:3a7::5) by
 IA0PR10MB7372.namprd10.prod.outlook.com (2603:10b6:208:40f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Tue, 23 Apr
 2024 20:43:54 +0000
Received: from DS7PR10MB5280.namprd10.prod.outlook.com
 ([fe80::c7cc:f6b7:386e:fd5d]) by DS7PR10MB5280.namprd10.prod.outlook.com
 ([fe80::c7cc:f6b7:386e:fd5d%6]) with mapi id 15.20.7472.045; Tue, 23 Apr 2024
 20:43:52 +0000
Message-ID: <0c7f0f31-9824-4123-81e6-d7597c545026@oracle.com>
Date: Tue, 23 Apr 2024 16:43:50 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 0/3] Export APICv-related state via binary stats interface
To: Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        mark.kanda@oracle.com, suravee.suthikulpanit@amd.com,
        mlevitsk@redhat.com, Chao Gao <chao.gao@intel.com>,
        Dongli Zhang <dongli.zhang@oracle.com>,
        Vasant Hegde <vashegde@amd.com>
References: <20240215160136.1256084-1-alejandro.j.jimenez@oracle.com>
 <Zh6-h0lBCpYBahw7@google.com>
 <CABgObfZ4kqaXLaOAOj4aGB5GAe9GxOmJmOP+7kdke6OqA35HzA@mail.gmail.com>
 <Zh79D2BdtS0jKO6W@google.com>
 <CABgObfaSTa7pC0FBhx45NVGyLtBGceZJCZbjjko-tA-J8a1tiA@mail.gmail.com>
Content-Language: en-US
From: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
In-Reply-To: <CABgObfaSTa7pC0FBhx45NVGyLtBGceZJCZbjjko-tA-J8a1tiA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL6PEPF00016417.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1004:0:5) To DS7PR10MB5280.namprd10.prod.outlook.com
 (2603:10b6:5:3a7::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5280:EE_|IA0PR10MB7372:EE_
X-MS-Office365-Filtering-Correlation-Id: d26a404e-77c0-451b-e501-08dc63d61620
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?MGVZMkphWUpqekIrMzVGaUhPaFZTRUhVNkhkQ1dCandZaUdXQ056V0xDZDZZ?=
 =?utf-8?B?T3RlR2NFMy9lV1B0d3ZyUFNWN3VTS2FlaFI1cUFjaEpPSm9mZjNDdVZWTzRw?=
 =?utf-8?B?M2R1WU9wTU8vWEs5eXNPRnplaTlwYVRxd3Jabks0WE5QS3F0N2xERVhXMlo1?=
 =?utf-8?B?TERvNVpWa0UySkg3dGlSejZhWmY2bXZZbFdITXBrWTV0TGxBclpydVh3em5u?=
 =?utf-8?B?TWtSeXhYZHpia1kzY1UxV3pZdzZJMVJKbDB6OW8wVnBXSEVJRUJQZFY3cTdS?=
 =?utf-8?B?ZEJ2cUFlMHFDcTI1MkVxdEpJeWVTc3pwZXNYYXdVZWF4YlQ4SlMwRFNMeVJU?=
 =?utf-8?B?UWRHdkluY0dJb1VZR2l1R0ZIQm9uSHU1L1g5cEFiK1RlckVOYXZibW9LT085?=
 =?utf-8?B?WHhTQVF0SHhJM0pnR0hrRlhjL2x4MExiREZFTFZXdGtMVGRqSnl4Q0NscjJQ?=
 =?utf-8?B?Tm03N0JwY3VNOFB4R3NGSEVGZGRZRFFtMDB2VFlBcmpWMHpaNVlDL0ZUcmty?=
 =?utf-8?B?TVFRNjlMa3F3K2hZYitmSmFzK00yNzNQMUtkNHlTRG9EUEhkc3dkUEZ3Nm1h?=
 =?utf-8?B?eGpmK2hoOGpIY0w1WGorSDNyMmwvNVpkZ2NQZUN3Z0N5Z3BlQmVaOHoxZDk4?=
 =?utf-8?B?MUFOcmxETU01RnB6elhVbEw3dkZTTFhndWdnNXJBSHNCaFhNTWxraEgzV3A0?=
 =?utf-8?B?emRpOFhpVVNlazJUd3huUUlWak51SlVMeUhQM2hPb3ZjVGwzUEZTek1EaXdz?=
 =?utf-8?B?bVNkVGpPczB5MFpiaVdMeDlBenpteWpYci82b0d3UlF1UXI3K2xiRjZvNDU5?=
 =?utf-8?B?Nk02OUdLbTA5S1E0QUUxazd2VlRPTGdSekJqZXlveDFYR3NDRnhPbEpzc2xk?=
 =?utf-8?B?OHlSTk52SDJpemVtd0k2bG5IUG5QVzVqN0h0ZVBxeGxzYzkxT0Q1ejc4S0lP?=
 =?utf-8?B?Q0JhUnZKd0VWc1NITDYxakpyR0dxdTZZTmc1d2phUzY5NjdDWDYvcWcvRjFo?=
 =?utf-8?B?eG04OUI5QXJnTWtEVTFtRjBRNU5WWnZkRTRLYWVFTUY3K29NcThtWGtPU1Yy?=
 =?utf-8?B?dWlVTWpBc3I5VGFFcE1EU3p5K25pdkNKREdkeWVEUWZ4eEtEdldIOER4T3h5?=
 =?utf-8?B?SHVKU1VmY1FISlBxeHpWWnZjRU8vRzltVmt6NFU4NHF2dmZhVTk2Y1p3QnRr?=
 =?utf-8?B?SmM0bUpvbWtsejZrcW90aE1pQ2NCU2dwa3JEWUpwYVRYajUxcnRiZ1lWOGs1?=
 =?utf-8?B?N1ljQ2h6VkoxVkJuZTB4TFpUSHEzOE52NEJRK1dZRno1dklXaHNwdEo4bGVY?=
 =?utf-8?B?L085bHFCb2NKcEVreG9QYnR5eGQ5Zm8rLy81SUkzZHIwNUVaL0ZUTDZxT0U5?=
 =?utf-8?B?VGRXcktsVkNlbnViSjJoajVacDlGK0p3MEt6NzRDQTd1ODF1VXg1ZDBBWmdT?=
 =?utf-8?B?cVA4N1ozSVBoRUZCK210L2lXTS9tZXhJVTlqZndTaUFmZG9IYlByOVpZS2N0?=
 =?utf-8?B?VER0NkRuNFU5TEU0c0JRZ2k2c2FYWXh5Y0NnbG8xbGhUdmp1S3FWTTJpcjlM?=
 =?utf-8?B?aXZrNmc0SGMyWmx4SEZXUHNod1NaQ0VLeU51USs0cUpPb05XaFF4amtQWjJR?=
 =?utf-8?Q?xGp73+92q2RpJMnz0Xzl7u87mR5TZlTyAnHubWHHFIsQ=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5280.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?NHAzRmtHVkRGTWdyTWJ4RTZhSmJEd1kyL0UwRnVnVEpIU25SS2RxU0NvL2s0?=
 =?utf-8?B?NGFpNzk1L3VabWN5SUJIQ2t5U1hDU3hkUGlFTHRDUGMwSUxmV3ZsQU91dFYz?=
 =?utf-8?B?Ym1rVDRtUFZlT09idUhXS1JnaTRPUEZNUHBjaUh3M1dTVkh4NzJIZDV5Z2FJ?=
 =?utf-8?B?NFcwMFBkbm0wWUdIM0FnRDZneTFKRzRPQzR5YWg4TVFpUWh0dStlMHkzcDE1?=
 =?utf-8?B?SlFMUkdmWDNzWUNPcDRPdUNrSUl0dFMvSEJGbllhQjVpWlhiY1hGZU9udTVF?=
 =?utf-8?B?OW1Pck5EYlF0T0c4cTlLV2V2Sm5qOVZ1RkpSNjRzL1hRRWt1ME5pUjFqTWNF?=
 =?utf-8?B?UmVhZUdib0UyZWZSNkJVT1ZYL2g0Vk05bE5SSnlWQ3V5bXRxblV6UUdTaVdt?=
 =?utf-8?B?NHQ0bk55Vjg1RjJ3ektZZ0s2cHRHVzNUalI4clk3RkJCRUkrV1JQRTUzZVFE?=
 =?utf-8?B?K0R0bjJwU1ZPdW8xTllGa1RSVzlpMHgyTUpEM0xHWkhWZnhGbzNFRGxXOU1r?=
 =?utf-8?B?QlRvUitxczJjUTU2T0djS1VyVXZxN2NPbUtMdGFUR3RqTThGZm4yaytJd0Ry?=
 =?utf-8?B?TmdVTk42OXpZb2lSdVRnZTdIdXJnRzRKTVdaRjE1UDRJZGVXdjdFQ2RwSnY3?=
 =?utf-8?B?RENrL0YyaFpJa25pc2RnZHJlWGszMENuVWI2eW13NnBwVUdyVzlQaEJhbGt4?=
 =?utf-8?B?M1EzZjREKy9RRlZ6V1I0VGU0b0RKd0IvWG9nbWpHL0FlWm1od2dZeWM0eG0v?=
 =?utf-8?B?RkRzQ0lUck42Z0FjeGR1Z2IvcW9FV0lqVmc2d2RnYU8ybEhBZS90ekJybVFx?=
 =?utf-8?B?azlhUko2dVZYYnZSNFhOYUpZSkl5WGhTOUIvK0xUT1FBc1NwbGZVdHVzakdD?=
 =?utf-8?B?RVU0N1NhalJxYi9IUmhyeDEybXU3U0FDVGcvTjRwT1hwWEdvYzE0M2szdkZR?=
 =?utf-8?B?NndiQ3g0MHBtOVZTeHNkUlYyZURmSWJDYTRMeG5LUjF4S1ZjUlEwR0xudDJz?=
 =?utf-8?B?Vnp1Z2x1bTdKT2dTZ3NsL3B0WXEyUHhUdFBVT0lpYzZFOUVHeEhtWWRVOGV1?=
 =?utf-8?B?QW9hWElBSlFaeDFRNjRuQTIwblRqckVQM0pLN3FwdWE5ZTNKd1RYYkNJZzJz?=
 =?utf-8?B?SUNxMm1qUVdDTEQ4bVpLelE3NGhERlh1OTg1NmRzTjJ0cWoyMVVHU1Y4cHh3?=
 =?utf-8?B?QllRUHdYcEt4WWYwZUhjalExcE5SS1hSM0pBbFhaTUl1ZnFjcXhjZ1NCaXla?=
 =?utf-8?B?cFZDZ2VTd1lyRE1Db1NPZC9VNGNsQ0pRdEc4VHU5dWd4eHRkeXgrMHYweEp3?=
 =?utf-8?B?UzVUQzlOTlEwaStBRG5YekhibGI0MmM1WkhNTUhndm9oZEd3b1lQNFVIQ0VN?=
 =?utf-8?B?bWNmLzR3dnpVWmI1cGpwRmNxbVk0TlBodEFqaDh6ZDJPb2drcnByTnFRR21C?=
 =?utf-8?B?QjQzTFAxQjdMSWhNL2EyRDJuek5EYTRuLy9TWFVPWWt2eERvcFNDUmVkSDMr?=
 =?utf-8?B?SmlDNEZKNHI5Q0JWUW5xZlpuY0RxR0dMWWQ5eVVteGpsbmY4ZTExYWlzUzF6?=
 =?utf-8?B?Z0ZGaFJ5ZzFwSS92dlM5WjNLc1p3QVQ2eThsV0w2eFZkWVZhek8ydXdVd2Zu?=
 =?utf-8?B?ZHRHQW9LSU9aYjNRWStDOTM4bmJ2eDdpd09oSGI1bTZGczNnbnFNMGd4SHpQ?=
 =?utf-8?B?Ym9UWXc5N1RiOEVEdTFUZ1ZWcCt1NlFsMzZxWGxZcmlPeEVTWVFUVFFTbUxz?=
 =?utf-8?B?Zk1xQzU3ZU9NSWptUkRsK2hKRVM1NXhkWGhic2ljNU82alpteU9Sc21ScXll?=
 =?utf-8?B?STBaOGhWYTBFS3l3RTd0Z0FzWVZJa2tvNnFhc2FPbXgrOXlWYTNnc2tLbExS?=
 =?utf-8?B?T21INE9zSUhvZkFTSEtvbmFDRmVQUGtXdGpVTzRqeHYrTGd4VVdCRzJRd0J0?=
 =?utf-8?B?ek9TZ0VhQjN1MGtvWnB3UENjQ1l5emd2Lzk2WTV3Sk1mQXMybFVwallIMjdL?=
 =?utf-8?B?Vy9GcDJTQ0RjWkthWDdsQWtqSWJUYVd1VU9uUVJMVncvRE9JZ1pmVVcvNWwy?=
 =?utf-8?B?eU1QUnl2clVBZ2FLRnMwNUtXTVh5cHVtZnlqM3BvWExVbXRRSTZ0OEoxd25E?=
 =?utf-8?B?ZWlCclZOY1M3dGVwTCtCSTNRTkVUK3lSeHpzR1J5bUZkSTlFbmtZdHE5c1Ju?=
 =?utf-8?B?aUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	j9Crs9HZ2EnpUp+53KjyrAEMr+m4CgsPihgSix3Ds7PYWh6j7cQ86cxqN6PeV2j6NgtfH/05C0y5pJlUJcA5EEkAaZ0fF1v9tIHJa0CloH5SZLdZ2XXnn/j+rv7FSH0XnuM9SE2fcw7ryiSO87KeAFQGcAjEDJmCf5gYvklCHjPL3rBTP4nZXNv1Nb72vWUTvGpXafYXlLItrjHV5eQWvvX8xYctf2CCcXbXtoXIDPu03GHhkAQu69nYNmxIJM3whXsp04nMj6LzE/Kd5BXPWUQjdpb3JQ730QgVb3ZzTgCFedicHfsLfvorBA3RV5xStAIs/CAQAek61PkFmC2MbGNZNmXBEE+y7z6fAbpnonU3aqJZm1+D0QXnuQfXPMc8nRCstLb16BQi3srxfmsoQgPjFpqkxhT2d+7Cdai/VUy80XABEBfkN5fsDS//vcybdYyChxIWdDAvxSY0QVE+7dx901k8D3f7ccNFkywHntGUpKjmFBhdVeLpDM/cwrgTZGHICBzm4+rhw9h620aUwXQsQ0+k7OC365l2CTKGM3ZRVlH6YVCOkvd9o6NRCGgW+Tj7VdYD2HvdU3WafaRxJgIiYOpT2nlC7TKDXf/v3Ws=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d26a404e-77c0-451b-e501-08dc63d61620
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5280.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2024 20:43:52.6655
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ClFwSqHgr2ozL9+FWA2C6TgZPoK+r7ASJqxA5C3qWwCkhMdLWUn+PuXvBpDYF0TUpeW6T8D6pb4SPtZT4O95K3jo/skmdI/eAvdmAU9Xttw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7372
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-23_16,2024-04-23_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 phishscore=0 spamscore=0 malwarescore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404230050
X-Proofpoint-GUID: qBisNWD1MC5wgAgoQ26Rjag1SLpU0BVr
X-Proofpoint-ORIG-GUID: qBisNWD1MC5wgAgoQ26Rjag1SLpU0BVr



On 4/17/24 05:48, Paolo Bonzini wrote:
> On Wed, Apr 17, 2024 at 12:35 AM Sean Christopherson <seanjc@google.com> wrote:
>>>> The hiccup with stats are that they are ABI, e.g. we can't (easily) ditch stats
>>>> once they're added, and KVM needs to maintain the exact behavior.
>>>
>>> Stats are not ABI---why would they be?
>>
>> Because they exposed through an ioctl(), and userspace can and will use stats for
>> functional purposes?  Maybe I just had the wrong takeaway from an old thread about
>> adding a big pile of stats[1], where unfortunately (for me) you weighed in on
>> whether or not tracepoints are ABI, but not stats.
> 
> I think we can agree that:
> - you don't want hundreds of stats (Marc's point)
> - a large part of the stats are very stable, but just as many (while
> useful) depend on details which are very much implementation dependent
> - a subset of stats is pretty close to being ABI (e.g. guest_mode),
> but others can change meaning depending on processor model, guest
> configuration and/or guest type (e.g. all of them affect
> interrupt-related stats due to APICv inhibits).
> 
> While there are exceptions, the main consumer of stats (but indeed not
> the only one) is intended to be the user, not a program. This is the
> same as tracepoints, and it's why the introspection bits exist.
> (User-friendliness also means that bitmask stats are "ouch"; I guess
> we could add support for bit-sized boolean stats is things get out of
> control).
> 
> For many stats, using them for functional purposes would be
> wrong/dumb. You have to be ready for the exact behavior to change even
> if the stats remain the same. If userspace doesn't, it's being dumb.
> KVM can't be blocked from supporting new features just because they
> "break" stats, and shouldn't be blocked from adding useful debugging
> stats just because userspace could be dumb.

[ trim ]

> 
>> That said, I'm definitely not opposed to stats _not_ being ABI, because that would
>> give us a ton of flexibility.  E.g. we have a non-trivial number of internal stats
>> that are super useful _for us_, but are rather heavy and might not be desirable
>> for most environments.  If stats aren't considered ABI, then I'm pretty sure we
>> could land some of the more generally useful ones upstream, but off-by-default
>> and guarded by a Kconfig.  E.g. we have a pile of stats related to mmu_lock that
>> are very helpful in identifying performance issues, but they aren't things I would
>> want enabled by default.
> 
> That would be great indeed.
> 
>>> Not everything makes a good stat but, if in doubt and it's cheap
>>> enough to collect it, go ahead and add it.
>>
>> Marc raised the (IMO) valid concern that "if it's cheap, add it" will lead to
>> death by a thousand cuts.  E.g. add a few hundred vCPU stats and suddenly vCPUs
>> consumes an extra KiB or three of memory.
>>
>> A few APIC stats obviously aren't going to move the needle much, I'm just pointing
>> out that not everyone agrees that KVM should be hyper permissive when it comes to
>> adding new stats.
> 
> Yeah, that's why I made it conditional to "if in doubt". "Stats are
> not ABI" is not a free pass to add anything, also because the truth is
> closer than "Stats are generally not ABI but keeping them stable is a
> good idea". Many more stats are obviously bad to have upstream, than
> there are good ones; and when adding stats it makes sense to consider
> their stability but without making it an absolute criterion for
> inclusion.
> 
> So for this patch, I would weigh advantages to be substantial:
> + APICv inhibits at this point are relatively stable
> + the performance impact is large enough that APICv/AVIC stats _can_
> be useful, both boolean and cumulative ones; so for example I'd add an
> interrupt_injections stat for unaccelerated injections causing a
> vmexit or otherwise hitting lapic.c.

So far it seems there is support for using the stats interface to expose:

- APICv status: (apicv_enabled, boolean, per-vCPU)
- Windows guest using SynIC's AutoEOI: (synic_auto_eoi_used, boolean, per-VM)
- KVM PIT in reinject mode inhibits AVIC: (pit_reinject_mode, boolean, per-VM)
- APICv unaccelerated injections causing a vmexit (i.e. AVIC_INCOMPLETE_IPI,
   AVIC_UNACCELERATED_ACCESS, APIC_WRITE): (apicv_unaccelerated_inj, counter,
   per-vCPU)

You'll noticed that I framed the AutoEOI usage and PIT reinject mode as their
own stats, as opposed to linking them to APICv inhibits, so it requires a
certain level of knowledge about the APICv limitations to make the connection.
Is this the preferred approach or would we want to associate them more
explicitly to APICv inhibitions?

Alternatively...

> 
> But absolutely would not go with a raw bitmask because:
> - the exact set of inhibits is subject to change
> - super high detail into niche APICv inhibits is unlikely to be useful
> - many if not most inhibits are trivially derived from VM configuration


I wasn't able to fully make my case during the last PUCK meeting, so I'll try
here again. I'd like to insist on the opportunity to provide visibility into
APICv state with minimal change by exposing the current inhibit reasons. I am
aware that Sean and Paolo have expressed opposition to it, so I'll only insist
one more time:

Putting aside valid concerns about setting a precedent for exposing a bitmask
via stats, I'd argue in this case the apicv_inhibit_reasons is essentially a
tri-state variable. i.e. we can have a per-vCPU stat with possible values:

0	--> APICv is enabled and active
1	--> APICv is disabled (either by module parameter or lack of HW support)
>1	--> APICv is disabled due to other reason(s)

The >1 values must be decoded using the kvm_host.h header, same as we are forced
to do for tracepoints until (shameless plug):
https://lore.kernel.org/all/20240214223554.1033154-1-alejandro.j.jimenez@oracle.com/
is hopefully merged.

So as long as the method for decoding is documented in KVM docs (which would I
add as a patch in the series), a single stat can fully expose the APICv state
and be useful for debugging too. It could replace three of the stats proposed:
apicv_enabled, synic_auto_eoi_used, pit_reinject_mode.

Cons:
- The exact set of inhibits is subject ot change / detail into niche APICv
   inhibits is unlikely to be useful.

The state described by 0 and 1 values of the stat are unlikely to change, and it
costs nothing to provide additional meaning in the remaining bits. The fact that
inhibits are likely to change/grow makes this approach better, since we avoid
creating stats to describe scenarios that become obsolete e.g. Synic AutoEOI is
fully deprecated, or split irqchip becomes the default..

- many if not most inhibits are trivially derived from VM configuration

This assumes non-trivial and implementation specific knowledge about VMM/guest
defaults, and limitations of the AVIC/APICv host hardware, which have also been
known to change e.g. Milan (unofficially) supports AVIC, but not x2AVIC.

Some inhibits will be set by default currently e.g. QEMU uses in-kernel irqchip
by default since pc-q35-4.0.1, and KVM defaults to reinject mode when creating a
PIT.

ExtINT can be inferred via IRQ window exits which are rare, but on the reverse,
noticing that AVIC is inhibited due to an IRQ window request can draw attention
to problems in that unlikely code path, as I recently found while debugging an
issue on OVMF + Secure Boot. (anecdotal)

VMMs other than QEMU and/or guests other than Linux can be inhibited due to
"less common" reasons than the ones we see today. (hypothetical)

--

I understand concerns about overloading the stats interface, but seems a lost
opportunity and a handicap to usability if we provide a boolean for APICv,
but no information about the reasons why it was not be enabled, specially
since in some real scenarios (e.g. hosts enabling kernel lockdown in
confidentiality mode, normally paired with Secure Boot) that information will
not be accessible via other mechanisms like tracepoints or BPF.

If the idea of exposing the inhibit reasons is still a NACK, then please let me
know if you agree with the 4 proposed stats mentioned at the beginning and I'll
send a v2 that implements them.

Thank you,
Alejandro


> 
> Paolo
> 

