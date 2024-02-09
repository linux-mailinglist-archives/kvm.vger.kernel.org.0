Return-Path: <kvm+bounces-8412-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C41B84F1D7
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 10:02:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0943F1F2616F
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 09:02:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41785443F;
	Fri,  9 Feb 2024 09:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="F2aPQfq/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DAumhDaV"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E49031103;
	Fri,  9 Feb 2024 09:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707469312; cv=fail; b=thWpUYwdrFommmav5lpiBWnUBkFOqGTtEOjW3GThMYFyZ6L/lqQJa6AR51Sctqdr/w52E2z4NV9M9ZNI/ZWy7tUnTO/VBW30bEFzhH5y9eBlbKhr9CG8NW6/ZIRzkB2/NStDt4UpcSQ1OiTla5exYrTVyTRC60euvKulsw13RE4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707469312; c=relaxed/simple;
	bh=8gug4kZzlFB7y6qrm3lYphrKRf6rLbKCaHZE2EvV+xI=;
	h=Message-ID:Date:Subject:To:References:Cc:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Pd6LQySHeerPbf1hFhbE2yNXfxYYiZSPi7jvfmYkoSJydj8RVKaZpkDoC9mlb916XkFYnSnVrvUaQbyFfj755PkaktuHDfvSuI7jMhTHJVNUQEZZ5os8llj7a+ldDxX3Bulh24vgLwVInRqnUFUAA3Ylq0QORpKj1HLszsgYl1A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=F2aPQfq/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DAumhDaV; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4194wvxZ006144;
	Fri, 9 Feb 2024 09:00:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : cc : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=STpvGFltLYtB7lmjqzIl1f5JqoQRJURUz5ZVWTxRWDw=;
 b=F2aPQfq/TpCXjB20x+NV9/UehqWaeGfUp4240a9I2Mir4RsA7616rfXvEXXXbqnWurYu
 2NdMNjsKj30eyuvu5iObxQCQn4uybecHkONVLn/HH2i0DvZAtkzMnh+X1V4vEuwibI+B
 aNK+g60K76SPYvtpOWPfJ0ZluUTSgWjvaPtMezHVdRJACdBc92ZnosYOnpzP5N9G+Tkt
 dZWbsBWz8hftGe1K6XfH6iS4zLAN6mh3pQurzqY5VxcLWICgbI3AfKjc7+u9Are4Dis9
 d2ukLjoWQusXOlZTBFsKOuFGwXRR46JYV7JYRdyBiSjvap+5QrEawJwpybeAplpwwckU Ag== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w1bwexn2j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 09 Feb 2024 09:00:12 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4198AhKD019741;
	Fri, 9 Feb 2024 09:00:11 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2040.outbound.protection.outlook.com [104.47.73.40])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3w1bxj698c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 09 Feb 2024 09:00:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bu7sRmfKIR3x9DZMX9IAuu/LQIcEnOsw0AAV9uneXAZbdhk1GwzUx/a0H794PLCU02SvrAlC2XhU54J3LZkYoeSpqUSA65ZB/Tww0wCIO51kEpQ8QjxUxeu+kNqje3U6Po6wVzKWJwXvS2ht+1XRz10MOcUZEuHg8uOz8wugWAkLdjdnajSquxS67gIElXl3QClgczBPOtuqcspZBH1XeXNXPQ4INEOD7ewyRMH0MRQYF/UHacUWBARJlprI0Ii40aq2Lu6Tbic1jjkyGgVIP+0bJG9Cj7lSyt2iIvD/oi1qj1bDU0ofBWfGb+5GOuDLnJK6X2BsCvEjbZm/LbzcqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=STpvGFltLYtB7lmjqzIl1f5JqoQRJURUz5ZVWTxRWDw=;
 b=UJg7Vd9psj4yIIqys+Zq6xO1et4ZExPxgyevLvKOfSrbPhpFuWP3gNAPk/ng3jwSXKogO7jjTPuYBxMwuxNrgqkURrB5uM4PjM+cpiuaS9gu7TGPPyecJ9FV1lDieZ8FkTepkgMici2x9/t7GhDmA3QRzYPLC9zeoCBkZi6zu7WrKksxSiYygB2DWpxFGz+Q/vQtXHIflFwcnZgWJFNJk4AUHGSbb9tDJRUjGACp9Yz0l2V26C7vIjc1TdK5su1ak9278UvSInAL5W8vllKMh0Go6hcU1V5VypDg/EX0FmAwow0iOA83foZu2V2uP74fBxxikW9c4Gjce2DEqeWsgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=STpvGFltLYtB7lmjqzIl1f5JqoQRJURUz5ZVWTxRWDw=;
 b=DAumhDaV4XUZLO3VaXwjeaM+HA2iR6G93mVZfcz+Y/iROjFsbZ/o4eJKUOiHAHjK3EEb7v9RtIPiOigYh7fbXLstj92Uf4mGerZx6HMtCbpeBXH+jlYtizkQ6DIheJw9z2FuSPMcqKpG/7WtIS4ZcJCPzKSGcR29FBFe0QfkzCQ=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by MN2PR10MB4237.namprd10.prod.outlook.com (2603:10b6:208:1dc::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.38; Fri, 9 Feb
 2024 09:00:09 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a1c5:b1ad:2955:e7a6]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a1c5:b1ad:2955:e7a6%5]) with mapi id 15.20.7249.038; Fri, 9 Feb 2024
 09:00:09 +0000
Message-ID: <02fe988e-2b42-9610-6ab5-bd17b0d9fb80@oracle.com>
Date: Fri, 9 Feb 2024 01:00:07 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [v3 0/3] KVM: irqchip: synchronize srcu only if needed
To: Yi Wang <up2wing@gmail.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, foxywang@tencent.com
References: <20240124113446.2977003-1-foxywang@tencent.com>
Content-Language: en-US
Cc: seanjc@google.com, pbonzini@redhat.com, mingo@redhat.com,
        tglx@linutronix.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        bp@alien8.de, wanpengli@tencent.com, oliver.upton@linux.dev,
        anup@brainfault.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        maz@kernel.org, atishp@atishpatra.org, borntraeger@linux.ibm.com
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <20240124113446.2977003-1-foxywang@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0P220CA0012.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::24) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|MN2PR10MB4237:EE_
X-MS-Office365-Filtering-Correlation-Id: beae8848-5d9c-43cb-771d-08dc294d846a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	CeROQHiehHMRs/Rq+ugzIid4jt/nkVPhb3K0e9wx3TIFk4ugDOkkazfmj1XaGVWQMb6Y6TNmj9mLv1DWc3ef98xKqB7M/JLaVuSznZuOQxdoka7YJpOgDPSu9rZdK+1VObo7hr579qmKJFEXq44biBhcqc7iB4MEL8+bDp7VJeayfDxXqUuFzstIVSOcVv7M2/vFhYNOW9BWs5hYxl/TFtrw+uVgM4tH7RFhIYqOoedA671oj1jM/gEupOOAai+vf7cpBLqko4521BOg6ZArQVaIrNmZyRqAuuqiETtU1m7SAvMwBnK9Dm78+EzKs8yu6a+nyn9F0Lb9Z9hAXDK/i+YPrSTwwbMDf9yba1UzdgF1hnp9/QI+wTbVwAT4k1iWIb2I/N9qqIA/3qWA9e+KcrsChP/wu4SRphB6o56+ExRWCdwzA2kpCdrLWBcwj/WQX5OomgfBYtAHjhnoQedR4sLwtlN8w129mHNs9JWJxIi1T5DFFIfx7YPWuNHNxql7x186PNzC6Af6WDWiLXo/8Qcx6q/+UZOEdwfTTcX2LTXP11fBCoFudRBSRPby7edgtcMpMb1UueYv+nO4nouWgw==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(366004)(396003)(346002)(39860400002)(230922051799003)(1800799012)(64100799003)(451199024)(186009)(36756003)(41300700001)(31686004)(316002)(66946007)(66476007)(66556008)(966005)(5660300002)(8936002)(6486002)(86362001)(478600001)(8676002)(31696002)(4326008)(44832011)(7416002)(2906002)(38100700002)(6506007)(83380400001)(26005)(53546011)(2616005)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?RzBIQTZmTS9GZTZrSThHeXlsT1EzdzRhWThyOXFRVTR6VzV6aFZTSVRpLzl5?=
 =?utf-8?B?MG5USVhiS1ZzczYrRWNuVXE3bEFoVHNpZWNBN2VjSjRzOGQ0M2lVZS81RUsr?=
 =?utf-8?B?clliTDhoWkhacVhYU2pTMHRaZDNqeEhCcXl0aEx2U05ZNkRiSGYvMTRkTlZS?=
 =?utf-8?B?LzRmRllBZ0VuWXpWN3JKTnJlVFFVUW8yM29EMFVCYTAxSTV3Q0ZueDZSdUpW?=
 =?utf-8?B?S0hPMmpoZnR3WXhPeXNKK2xyRGlRdHNHbTcvL2pVbHBTekwrbmo5RnlXWHo5?=
 =?utf-8?B?Y1YrRjBuUXI2Kzlnd0d2T1JaTGY3ZkVOZVdsQWdyYlhmRmg4ZERDcEtPQmp0?=
 =?utf-8?B?VmFlZ2ZHZk5yOUMvMEpQYzVrdUVwZ3duZ0NWNjVYbjlPc1U5QlV6cFFTZ0hn?=
 =?utf-8?B?bURqNkFVa0hjSE1iUnBvK3JYT3VrckU4NEhjZlB5anIzYWRMSHllbkJTZnhm?=
 =?utf-8?B?SmliQnRBVFdyVW95eUFraDBwSkc0YTM4THhWUHQzZm04cDJvZUhwU1lVeGpm?=
 =?utf-8?B?eFdud2JtQ2VydE1JbFRSWXpYSDN4N1hjMUVsUlBWb29OdCs2bmFXL0FBalQ2?=
 =?utf-8?B?N3VsYWJEaHh3dk1ueUxLejFqZ3pkMHpqaWV3MmtpNjlUYVA5R0dmTFc1ZzMw?=
 =?utf-8?B?eHIxeURCcmoxaU9WQ05saExvUURmQ3d6RzlScHRwNUlMUlEwS09aU1VIWGNk?=
 =?utf-8?B?Y0JIVWlmRkUwMm1NNXhha1lndmVUNCt3Skp5dWhrdnprbFA1ckpVK0JjVVhv?=
 =?utf-8?B?Mk1mVHlkYUVnR0cvNFBCMmZEWVNOUkpVUXowMWZqUlRneDdMU091SWtGTkFw?=
 =?utf-8?B?a3NMNHlnMERrMVlWNTZXS2J4cHl5QVQyZjkxQ0xvK3MwN215U3N5K1ltMzdw?=
 =?utf-8?B?VXBBNDVUcFcvSVYzYjR4L0pEMnRVYm01OVB0aWRYaEo0ZjcvSE53MnI4ODFC?=
 =?utf-8?B?UFdtZWp6Sk9qMDJEY0lmUUs5dm9iK0dkK3lsVEM4YUN4U2ZPMkdNTTVsdG9m?=
 =?utf-8?B?cjBYRmVrNjFMcE9PdTcyVGhhTC9EUVFiMUlHVlYrdk5aL3g1d3Z4TzN2OHpQ?=
 =?utf-8?B?Y0NQbStMVkdRM3dKVVFVZUh0NUdMQ0ZnbFh0a1duYmVEWG9YcU1vcC9vVFE2?=
 =?utf-8?B?WU53MEFQamxOcFlPQW53UTA4WVJob09ObnQrSWpRY0tOR0xjZHdGOFVhQmpP?=
 =?utf-8?B?TWVQaFBTNnp2ek9ndGw0UGxtcGNubjFoV1FzY2NkVUZTekloUzBnZnFFaDBk?=
 =?utf-8?B?TWVZd2p2WVFXN0FnNUI3Q1NnSy81Y2F6eStxV0JsMjFpcWhRMHRnLzlPRERP?=
 =?utf-8?B?cm56SXArQ1pCMW5rTHQ5QTBWSWpsRzQ5SkRhMGFtN2tEd3ltc202UnRzUm56?=
 =?utf-8?B?S205bW03d1RDc0ZKV2VMd2k2Y0FrT3FscE04MGpyU0VwOU5HekxCazhMR1RI?=
 =?utf-8?B?MjF5NlRaeFR5ZjVXR2lUK0twbVczdkZjTGpUSTc3dHE4ZmdsYWszMHZjWlZr?=
 =?utf-8?B?OXIxejl4ZHRzMXQrYjdtMlAwMU9reTNKUlRBTDJEdzBMMkhZaFBsMDVVRmRV?=
 =?utf-8?B?cVRqS2MyVGhWdTJyVTVjcTBSa1hnZnNkSHpscGtmeXFXeUZQS3FrZkpKV1ky?=
 =?utf-8?B?NXVLRmFzRGJwMHRqeUNFR0doVFM4REFIakxoU2REYjNlVzVKVGM3eHZ1aEty?=
 =?utf-8?B?VHQvSHdac3luTFh1R2FIazdiY2hEelJYREdXcDhiOTRTb29WV3BVbStadVFQ?=
 =?utf-8?B?bnozZ1lQY1NRblZSS3lCb1c2ejhxdEgrT0F6dXB5RktIaldHSlBXVmlxbGcz?=
 =?utf-8?B?R2I0bUdmelBUeUx2QWI1OUh1NW9WM3V2RHdQZXdKdkFFRktEWGlqcGlidDVH?=
 =?utf-8?B?M3lTVk9yV0lQbmVENk43RjhLNE9Md2EwT1N0aEs4dTdFenhzSXpZa2JsSWRx?=
 =?utf-8?B?eEpzcnpYZSs3Sk5JWmNNQ3ExaVQxdDZVaXZDRXkxMlU2NmViVVlzWmJGT084?=
 =?utf-8?B?d29KdmxEZUpWS2VTTUNYVFdwNVhTbEVzckRraThpRHUzRjFQdm9vV01yMEJ6?=
 =?utf-8?B?UkZKNXY2bERxeW82TWZQKytuUEFXOEIzN25ENUozaWVUUGtROHhnSGFHZnZX?=
 =?utf-8?B?c2RJMENwQnJaR1hubzBnMUZlNmgzVUZPeXo1cm15N3YyZE1sQ2crWFpOSHNN?=
 =?utf-8?B?UGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	FEvv7HPHHIfUGE7T7aO68LRyZYmmugSfJYz5yt2CJ0jN0Rb5riDju7WGwjANK+GhyS7i5eNtpeaY4j5jrqSYXhfkKNzDHo0EzKvyRkZSkND92KUCHrENGzF9m9E2dP7v/E3crU45uK5AXD9p7jw0FikX520bFR1RCKbY9LhsTafd1GoG8foGfXQPBWb/SdK+Otu8QMeAlb+M46kfVU0gRH2izhsMiObdlAp2XVZmJbmRq4CxdKRR1iTxAfTNz/o+cjQ4av3dLOuVUhI6iXK9wb0WYsQc7RJwKaIAyKNi4qlEr7hlKnXyakKqrhFBCj9/9flEZ4E60bWUjTjioeuVuGkDZnERnMtL681ErqVy35UYBvjeBYVKBiGFXMc5sHzznR8F1GlJbSx3xXHyTxJ3nBtlfvABA0Xhx4t6HMyCCiXuaGl0dAZpvoVB6rM6M5Q7f5JNQ6UdMQLX9z5Ra4POGNu0/8W48UtK8Dq6jopHdSj9lTnvZtYamCmPc14UKEbsKVCR6zrVrT0sxz+/pahChOcMnySDscAi2g5sabZuFnn1yENSBNLhCkJx3R1nDvjTuQqmjUXF0te5SEL66TigT9KZs9HY7/CK/fCrkEyqusc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: beae8848-5d9c-43cb-771d-08dc294d846a
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2024 09:00:09.1678
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wlr0Sj/vdFc2i3zLAqDJ1Tbiym6dQl+bwVvSc7AOcOkiaRu3s0hGOMr7rZOC8lznHHvmJU3YBTujgoak+wuevQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4237
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-09_06,2024-02-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 mlxscore=0
 adultscore=0 spamscore=0 malwarescore=0 mlxlogscore=857 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402090063
X-Proofpoint-ORIG-GUID: cjgBRf6kHdfuyJ7Faw6nbpDZy7Wwp2lc
X-Proofpoint-GUID: cjgBRf6kHdfuyJ7Faw6nbpDZy7Wwp2lc

Hi Yi,

On 1/24/24 03:34, Yi Wang wrote:
> From: Yi Wang <foxywang@tencent.com>
> 
> We found that it may cost more than 20 milliseconds very accidentally
> to enable cap of KVM_CAP_SPLIT_IRQCHIP on a host which has many vms
> already.

Would you mind explaining the reason that the *number of VMs* matters, as
KVM_CAP_SPLIT_IRQCHIP is a per-VM cap?

Or it meant it is more likely to have some VM workload impacted by the
synchronize_srcu_expedited() as in prior discussion?

https://lore.kernel.org/kvm/CAN35MuSkQf0XmBZ5ZXGhcpUCGD-kKoyTv9G7ya4QVD1xiqOxLg@mail.gmail.com/

Thank you very much!

Dongli Zhang

> 
> The reason is that when vmm(qemu/CloudHypervisor) invokes
> KVM_CAP_SPLIT_IRQCHIP kvm will call synchronize_srcu_expedited() and
> might_sleep and kworker of srcu may cost some delay during this period.
> One way makes sence is setup empty irq routing when creating vm and
> so that x86/s390 don't need to setup empty/dummy irq routing.
> 
> Note: I have no s390 machine so the s390 patch has not been tested.
> 
> Changelog:
> ----------
> v3:
>   - squash setup empty routing function and use of that into one commit
>   - drop the comment in s390 part
> 
> v2:
>   - setup empty irq routing in kvm_create_vm
>   - don't setup irq routing in x86 KVM_CAP_SPLIT_IRQCHIP
>   - don't setup irq routing in s390 KVM_CREATE_IRQCHIP
> 
> v1: https://urldefense.com/v3/__https://lore.kernel.org/kvm/20240112091128.3868059-1-foxywang@tencent.com/__;!!ACWV5N9M2RV99hQ!LjwKfBaGVl3u1l9YQSskg_1RU6278h2-fYnYLsoihF9i43aq73eIDqolGzOmeRvO8UlPreQHLqXEL1bAuw$ 
> 
> Yi Wang (3):
>   KVM: setup empty irq routing when create vm
>   KVM: x86: don't setup empty irq routing when KVM_CAP_SPLIT_IRQCHIP
>   KVM: s390: don't setup dummy routing when KVM_CREATE_IRQCHIP
> 
>  arch/s390/kvm/kvm-s390.c |  9 +--------
>  arch/x86/kvm/irq.h       |  1 -
>  arch/x86/kvm/irq_comm.c  |  5 -----
>  arch/x86/kvm/x86.c       |  3 ---
>  include/linux/kvm_host.h |  1 +
>  virt/kvm/irqchip.c       | 19 +++++++++++++++++++
>  virt/kvm/kvm_main.c      |  4 ++++
>  7 files changed, 25 insertions(+), 17 deletions(-)
> 

