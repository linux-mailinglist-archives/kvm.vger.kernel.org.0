Return-Path: <kvm+bounces-14408-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C2DFA8A2920
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 10:20:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 77F53283143
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 08:20:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8339450279;
	Fri, 12 Apr 2024 08:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Cyg4Xte2";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="NlGvhtRP"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 270684D9F4;
	Fri, 12 Apr 2024 08:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712910005; cv=fail; b=ep9kXfkGt5aMH6eyaNU2MBaKZcTLK5BaV6OO5rEfyy0XybcoW7RB4FBk6vbZShOk+FpF6vaUImBid0Y1GEh4bPVRmHL3kr+7PVgBykpsGn+e0rAecmMHVRdpShprNGqvlJUaBwapUxCaA2OZkSrq44uIlOvErv5Zmlp9YX7IEFo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712910005; c=relaxed/simple;
	bh=Du7aDArnvLFDX/Vnx5TMX/PULgTni8SbRaJMPpb1o00=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eJZ3AzPy6b6zdI64Y4a59lRBOu4mm366inXVTZeTQP+EnzBt9UaJoFJ9VzOKXSs+GawpqVUW4LtI8nawIFLGfLzhl0dNYTdn6Kutqv6lmK6zkIddsWkfmsHzYtPlvBSHkcfA8PH05CwL/30TH+vrwt0FDSTnyUfPUUmAx8RO2NI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Cyg4Xte2; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=NlGvhtRP; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43C2nhEh020792;
	Fri, 12 Apr 2024 08:19:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=/4FBB/aRhUdYnKofxaS5mIHGoMhDi1sGewWyCRqE3jw=;
 b=Cyg4Xte2Z52B2F3G1wH9RqrnS2t9nyNam9N1FJw690izQCh40Y4/dPmylI/8yUOr9IKw
 19liooyVQHRaOg1f2wPmU6QD/UQESd+rKQB57mnnk3gbUT7DemIDzfnKZ3MR8rNPeEfn
 FROiJSzaLK6EW6Esie1YQ8g7BXCxazBbfZUIe6hjHUPIXpr0xS4iyCCwxgUQ0V9wbLn8
 RnzkwFDCthiRhv15mkgfmE0nE260V7Q8bp7Fy5x0bf+ac0NT8+BltOKunksfXfaoarpL
 1zcWCUhq/J+ZuOmRsXcoP4btFYbx8yQEPplylDTcvbVmfPIZp7ljZPnd++JOr4Yuzxxr gw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xavtfb4ed-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Apr 2024 08:19:26 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43C7IOTA002879;
	Fri, 12 Apr 2024 08:19:25 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xavugxsgj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Apr 2024 08:19:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gPgQgvZSQ5V9hvkHutBgIFGmwsr1MG386u6rpqaedWm7hAQkqYCZ6qVww2YPpV4l0P1pVpXAh8qfFUssKemqMgtaarZHDOPNMWHnd5o8yr+f+S6+WDrXPzRZse0sMuXbeFKXfoA86zKwlaY6RXK0J86Oz51xZeRJA1VzuZdC/YpgOG3A+lq8xcx+bPfrJP9IgC9fJZF37NAMEwVNC3sSCFsYqF8oDYFIyQLj5dy6HCru3Z772LyC6blZoHB2v7uv9qQ166clC9k6ogkkGyV1b9k9Z3cDsfJRwbSOBsCydTYJFynQBlFrF1W3608Tg1qyD6mEi7Ykk3YbPUkWcrd6LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/4FBB/aRhUdYnKofxaS5mIHGoMhDi1sGewWyCRqE3jw=;
 b=DKx9B7zLNvPY/SWTWsurnTuDCysTFHJbvj6e1AThvdW4kdoAmJtQHU5LrQRp2i6gJZpm9Y7JUsBNP+WXyj2xICv4DT2x7Cwlc+hyJipGfmu5q/Kf2BaLWxWnvG3GXbMVRGWmyycBmTCFN1Y+QK7TxYcEPEfsbq5rMPVtq4iJuMQbGM5fJkChwoS6FvtlonxIe0ijau0ru5TlOp48Uf5WEeOIiBjfZdqt0Xcvh3hY7UH3s2mPNGnktYi9Pj3JlY/anolXGUvhIbGyHMVlVh7+xupSHRq2eoFzlalzqUTjRx3sZL10/GufWZFoUamC3HRcaPRCf8q6XlrLcmQA5fHd4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/4FBB/aRhUdYnKofxaS5mIHGoMhDi1sGewWyCRqE3jw=;
 b=NlGvhtRPMIWhONKUwESR4BmSJX0HTul1/rIFosMOMVLCoPt9qezK/CR5RdYCeRjUu/oD+XBFR0d0XQojMIiOKKtCv2cH5dKUBQFB9DymQ0b+rOVBTjL1UE/K4F4hrU9QwAxA0XXsa+W2Us39Ie9KGO5lfl23R0FT2oUwp9TpJBs=
Received: from SA0PR10MB6425.namprd10.prod.outlook.com (2603:10b6:806:2c0::8)
 by CY8PR10MB7172.namprd10.prod.outlook.com (2603:10b6:930:71::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Fri, 12 Apr
 2024 08:19:22 +0000
Received: from SA0PR10MB6425.namprd10.prod.outlook.com
 ([fe80::894:70b7:573e:da46]) by SA0PR10MB6425.namprd10.prod.outlook.com
 ([fe80::894:70b7:573e:da46%5]) with mapi id 15.20.7409.042; Fri, 12 Apr 2024
 08:19:22 +0000
Message-ID: <7a56f2ad-4b3e-e861-5dc5-23e0efa47540@oracle.com>
Date: Fri, 12 Apr 2024 01:19:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v2 2/2] KVM: selftests: Add KVM/PV clock selftest to prove
 timer correction
To: Jack Allister <jalliste@amazon.com>
Cc: bp@alien8.de, corbet@lwn.net, dave.hansen@linux.intel.com,
        dwmw2@infradead.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, paul@xen.org, pbonzini@redhat.com, seanjc@google.com,
        tglx@linutronix.de, x86@kernel.org
References: <20240408220705.7637-1-jalliste@amazon.com>
 <20240410095244.77109-1-jalliste@amazon.com>
 <20240410095244.77109-3-jalliste@amazon.com>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <20240410095244.77109-3-jalliste@amazon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0098.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bc::15) To SA0PR10MB6425.namprd10.prod.outlook.com
 (2603:10b6:806:2c0::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA0PR10MB6425:EE_|CY8PR10MB7172:EE_
X-MS-Office365-Filtering-Correlation-Id: 11150ea3-6a49-4259-8351-08dc5ac9423b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	l9xkPrzewmGpbfYemfOn2LpWlJDp9nhAhXiQibEjYN1TRHQSkYDEmLQ+rVPNtcQ21M2PBQ5s2PiHQKnYTogttWQh6a2EwOpLdce0QxPhWlpztNmdIODvmSDtv34hh8kbAj9jhaDbUphoL7O101n+NVoBq862ZT3v+/P5BD+YVXPAMLAiVBSFpG0/e3LUYRYmmwX3p/U5rtFl5LLp3oyVXSxKsodXkK2pPswY2UZplEGdHj43glm1khKBwYGA2jU4ZpMoXL8OQhnlA9o1903pWeSO6ak2uDaafSBuPjT5/yvBesfnH+3kVs+r5MOrUY+KJ06Cv0fpqJBeAhUtunvoiaQ7KaMc/clp7HKnzv4NqYYq2hOp+d9WIiSvfPljXph8FDZ7JaJwXSmUC+TxmiVMOWJbktx4CATMOqFrg96/r21mztTPpdmnF6ugpmZJGhXJHfUVqrSRedi/K4oz97vUO07V1MBKSdnPO1kmlb340lkowucgb6mhdPsjdhXWt5Iu/YP1ewskBvOqTkQ88dR/B2S4LDwp6oYnsAw+IL6GFf7FExJGwoa+StHaI4JVjMcgkwOj7qqBgDcdJS0cCMYU0/8EI83cjdSvEPTnukO7lKFluN9SgEAOJyWMZPsSaz1TSpFHzL+2jkr2o5SZeCO3MqmmiftNpZC06ckXbPpoWgI=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR10MB6425.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?QmtjamNmSUJYaU5ROGYyOVkzWHZQeEpNSjBhNE1NbzhsUUR1blJtdGRBUFFw?=
 =?utf-8?B?QVNYZEd3aUVwTlVmdzVrQXEwNGhob0pzOXlkRUxyaHl6QW5HZm94QnRvZTlS?=
 =?utf-8?B?Szc0eU9Wb1ZzcnJyR0wvb28xTFNpQ016V3N6dW0zd3hNYXM5ZnFOeHBhQ3hD?=
 =?utf-8?B?YjMzRHdIVGhWUkdQd1ZLSW94R2RMeXpmY0w4TkRMVHJFSmxYR2NDNkZ6OC9G?=
 =?utf-8?B?Z2VsdHJxcGZZYkw4eVRqSWlHZHorelBFZ3Q0bWJGZWtycDhsSC9iaFBGYTU3?=
 =?utf-8?B?L3MyY1I1ajNYMzVpWDQvZHQ5MXJBZ2tEalBoMjBFUXZhRXJZeklRTHp5OUZr?=
 =?utf-8?B?YUJuaXBSS0oxTURDZEFGeVFEYmlMMmJnNTZENG4zVlROcjZWQm5KTkxuMEpQ?=
 =?utf-8?B?dFlGQU0wZ09UQmpVMWVTaUZwMGR4ZDg3WU52Sjl3ajFLODRqMkVuU3h0bVc3?=
 =?utf-8?B?aTIvTUFSVFhRQ0NWM05RYWNDU1FpaWJHZlkxQkloc1M1VXFsUUMwUFlRUVFK?=
 =?utf-8?B?dUwzcTkyMkRiOVdRand2Q3FoZ3BMd25UKy9xWjdWblhJWWpzWmFtWklucHRQ?=
 =?utf-8?B?K0s3M0IrckcvT2JZVWFXN1lXRDd1djN6Rlkzd0lGdERyOEFaRDF6RFZTMUNF?=
 =?utf-8?B?V3JYSW5KLzJjcituSS9yYVJJRkJBMG5EN1RWSVViVytjSVFSSHlQOFNOTHZB?=
 =?utf-8?B?ZTBwYXlpTGFUWmxCU09uck9RcWxjOTZXZHFlN0lQeG1GZmd1K0NiR252R05O?=
 =?utf-8?B?OWlVajFISmtFZTNLY0tOUHhZTXd0bzFGRk9MeWtVbDlBS0FmVFZWbEhvNnRW?=
 =?utf-8?B?Q05VeUhpMlFlT1gvSVpyRkNrdHM0QW1uZU9odnRhYnZ4akErU1RzcGlvYWZa?=
 =?utf-8?B?b0wvbW4zZnhNY1oyMms0Nmp0TnRDTURXb1dBcnI4V0krQ09sTE9hdHRvMC90?=
 =?utf-8?B?WDViOW1NZlVmczB6anJWTTRtUHZUalUvSG1sWHA4cmRoZU1KQ3hJSnNTRHcw?=
 =?utf-8?B?d1NubWg3RjdNV0toU1RoTDgxd1hIQjZMRldhYmxuSmpnbWJXZEF3L1h6S2o1?=
 =?utf-8?B?RnlPL1UrcS9YWEdTYTFkeHFKa3ZsbllZVThESUFSVlBJbnVPQWZiWWxpMHg4?=
 =?utf-8?B?RHRoV1gvemZoU3NyN0k3c1ltbXpybHIzT0xrVnh5RnFFOWdFdUpCcGgwMGpE?=
 =?utf-8?B?WGNTMXNQYW0xcURPTWQvUlFjSlFXWHFaVlltZ2dtQWpqMVpLOXF1WjR0ZWJQ?=
 =?utf-8?B?cjBmcmtlSk5IME5hMjI2WVRhOGx0OWsrSHExb0Vad01oL3lvMWtkYXNqcUxS?=
 =?utf-8?B?NEFTNjJoMFB6aFJqaERadzJFWFFIc2xZcnpMenJSQUpyYTlsTWdNMzkxYXV0?=
 =?utf-8?B?YktLSmZqWk9mQWdYN0pMbEJxak13NjdlVDdOc3drZVdyR3Q0b01Bc1VQY0tU?=
 =?utf-8?B?R0FqVy9KT2RhaHlIKzhYb3hsZTJiaWdUbUh1dnlwc0t4blhzaVZSU2VCMXFU?=
 =?utf-8?B?WHUvMG8zK3hndUNQSVBXZDhVeDVDbHNpWXNZUzVLQ2V2UWkvRjBLUU5IUFpa?=
 =?utf-8?B?UnplMEpzQkIvN0JkaHExeFViM2VIMVMraFNpOVJCL0ZocXhHcGFjQkd1SVBp?=
 =?utf-8?B?cVZqUnlqTU1GZkVYNE1lMkN3UWlOd2h6Tmt4RVU0TVlvdVVhNG9hSUZrL0Uv?=
 =?utf-8?B?ZjJWUjhPMmcrK1NhTkZEaEdoalN2OGhWUmFTa2JmanpXQzlWN2p2bE5peDBh?=
 =?utf-8?B?T3U5N0Q0Ym5SZzhqdWdMNnh5Mlo3enZyUnJETVBzeDI1dGt3T2I1eFNrMERu?=
 =?utf-8?B?K3RkTWlGWjg5QWY3dkd1amZTeldSbGJUSWdFVXcvVmJDRDRSZ1NDRW04azYw?=
 =?utf-8?B?dFM0bWtYU2trRDc3TWNDd3JGN3BjckNxMGJISzlKTFZjRUVHM2lST1pYU3FO?=
 =?utf-8?B?YThib1JHS3lmUHY0Wk5naGVNWGN0akVZbkRib250R1NjUkdBaTlJV3NhVnV0?=
 =?utf-8?B?MzdoYWUvTG1NRXluSXlHN241ZnhWUXRLWkpKZGJZSExPUndNVG11d09PU202?=
 =?utf-8?B?a3ZsVnVMQ1NkTkZ6T0ZoRWdYVXV0MFk0RWE2SDZ6WERFcFhud1RtNGVxak9y?=
 =?utf-8?Q?NJ4dSMEOFog5yR0pTtX3OFu9f?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	/bjYFOjXA2iB+v1fUZ4BFVVOsfGhv9TsZMwGG66dM/23LuE28SfKnM/FiX/6WZfO78IPo4xNgXU6ByxCztFSBhjvFeAPItGn+YCfVsovOBT/9gWrIhW5bwIWFP/STHznSN+vf2C3gJsp6sDcMnJEtMT/hof4Ggk7VDuLR4GgMXEQ2oAm10OxEgFtfIWMS8nsDtx9xuK6MA56xmgyYcz+xJoHd/JJAVLVW8ZmqQXJtSQK7pGsqb9/D9o93eKzsYN2i/RxzLcWPC1Am8TGQYMI3sAVdv7/L2Hz6MfSbJbBti7uqBYTTKSKwt3d0ChqZjAUkmVXrb+7KShHuk/8urOCwrdUH+T6qW/tQNJDLiDui6Prw0OjZaG/SB4BPKTj1gzyxl05a3pS41gkyRG3VCGIHtlvGLJIBbcewojeGJD2rGHl/L2tNK126SSvh/F2tZtbowwmuP+TEGY9Z6UaEqgpeqPoPg2wpIrMTZNI5tuNxXmzXGpf2vp31kbz1hvhbyQ5wNvJ9PfOMjGGX4xTMShAQvmc83g2r8OukhEmjmHxP6U+GPAHweuS5bZygTuAKn+lbnjSlPjdSuz+opmcL+wylc1xoMHn9yyNJeIm7iEyH00=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11150ea3-6a49-4259-8351-08dc5ac9423b
X-MS-Exchange-CrossTenant-AuthSource: SA0PR10MB6425.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2024 08:19:22.7946
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6gXBrZhHZnArVOKd1tcfCOmMD6VGo6B/xGJ4BR0ywGsJRrvPDGGlRQy58b+b4yLHpd9r7pjJwpNZecjd883hmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7172
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-12_04,2024-04-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404120058
X-Proofpoint-GUID: -w8lICLVWbpRrn216iPQNO8YkqPycglq
X-Proofpoint-ORIG-GUID: -w8lICLVWbpRrn216iPQNO8YkqPycglq



On 4/10/24 02:52, Jack Allister wrote:
> A VM's KVM/PV clock has an inherent relationship to it's TSC (guest). When
> either the host system live-updates or the VM is live-migrated this pairing
> of the two clock sources should stay the same.
> 

[snip]

> +
> +int main(int argc, char *argv[])
> +{
> +	struct kvm_vcpu *vcpu;
> +	struct kvm_vm *vm;
> +	bool scale_tsc;
> +
> +	scale_tsc = argc > 1 && (!strncmp(argv[1], "-s", 3) ||
> +				 !strncmp(argv[1], "--scale-tsc", 10));
> +
> +	TEST_REQUIRE(sys_clocksource_is_based_on_tsc());
> +
> +	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
> +
> +	configure_pvclock(vm, vcpu);
> +
> +	if (scale_tsc)
> +		configure_scaled_tsc(vcpu);
> +
> +	run_test(vm, vcpu);
> +
> +	return 0;
> +}

David suggested make the scale_tsc automatically based on the availability of
the feature.

Therefore, if there is going to be v3, I suggest add kvm_vm_free() explicitly
(similar to close(fd)).

Thank you very much!

Dongli Zhang

