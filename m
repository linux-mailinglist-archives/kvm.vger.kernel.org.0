Return-Path: <kvm+bounces-14974-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A39818A857E
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 16:01:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A9F4EB28753
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 13:59:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60D431411C2;
	Wed, 17 Apr 2024 13:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Th25mdmJ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="IBh97gk3"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B45963A;
	Wed, 17 Apr 2024 13:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713362348; cv=fail; b=slo8w/UvEgJRh7MqqAuL/U05eftHs6mGFnu+neKkCvEpBxJCGW5X90bRgINdjA3MRq7o7ewfoSyPS2XX9y700BYvqTG6XZ//TK0LYv31V8x0fic8JD0Wu1VMfMEN5neijKMaUuPA2wMjeqgNVxfjDkoPyyjQZAK0R3JZWtwrn/o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713362348; c=relaxed/simple;
	bh=zRgl5b2TW9sN4WuAFQuV/hY4bwl2Sa3cqh8rztN6MNE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KiT4gDRg44Ll6AQsdCZbYeIwI6933mpsP8r2YlWvYw8lH+WyTg25pifhILgkX/6DUk/SEAJnZheMTg8VTGj2H3gHd/59G3x7QYh5zdEBwd82jq4XJJXBReUcoCt/9EMx/DC3xayemVbTaggDpVtchuKiju8k1TgIJLGf9RtBvcA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Th25mdmJ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=IBh97gk3; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43HDT1Mc019756;
	Wed, 17 Apr 2024 13:59:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=++CvWlwnA/rSZRDXYWsC9pOKkuUxaoaWHUyJ6qiaXk8=;
 b=Th25mdmJyK/3IwwgnqmV3GpvRTg9c+phLYz/aB5FhC1qLxFVUmtB5meafuqoGCpk4NyT
 KAvDdH2t0h4n0NEmAkrO3DPeSLdhQeMnU/AbPdC2wI2dH9nLHnPj3O8zrfISqk6nhrQ4
 RurSDYpJpJouznl3ooUwkcK7yglM3uvMxvAH+CqfKeTOkWpPODNGQWBV1r+PdR7w8P1S
 mhIUdYvQeOb73aaliPouMr7xovxlxnBYMMM9wlV6Y7RI4EnJFhokPh4rIJw8z1lXwre6
 5chZckLJK785obIbOLX2BcBAoYWmxan3E74NnXZ1v98caWx73uyDqU9YfAVMPLreCoQb 5g== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xfgujr2jp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Apr 2024 13:59:02 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43HDOtJt021593;
	Wed, 17 Apr 2024 13:58:57 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xfggf5ju4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Apr 2024 13:58:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fStxra4W4X91JFgwEc/cRO/Wf7/1wxLCf6uLknyrFYoEUfc3xO1gMZhc7kUoGFvf6O/MQ0MYJOnQtnvPnEZO0x3oTIZCgwj3QB5yWybJebJ3iJ0mPiQQczuOr5xg1PJv/FcIk4G8+Sn8XseSeOCCMSqMMI64wFLyjtlJjJu6efEAv5MXThyhppFspkrPU2CxXqy8MH7UzK8d+EhU8hms3BJq/TnSCYik9xc2oPP1SUtTXn39k5V4AIgSOdvDd32no5ZKRr3hDn4r1cCztuc3jfb4FFVsNZeeHqZDfF/HIOLPzya+jaFLNgXSKbM7+kbmJ4q97XHmD+ONKn0GxBF8gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=++CvWlwnA/rSZRDXYWsC9pOKkuUxaoaWHUyJ6qiaXk8=;
 b=F+DMJri/XOAblh6uq+ZZ1YMmdJ7md0nEh9WHAO2LLpsNhiQtOAiqu2N1q6wKN1y7WVFl9+x+BxQPfHPmGebR6Xen73b93EWbxMJXJOunFoIAPBDl8McdZkmKyGwtjVqE+64ONZKU7nchGpTh99CyKJq2a1o6CGNqrQSbehCcnRcm5h2dSoFjbcdcK8bJn4UYN6uBFLIHdDEWKi+C0unmPrIDlNG985rJLFZgSwLjxB2l+AezSWu3WkB4s1GO+qH88JK7sTL9tq7cFBc2pUIbIt090t6x7MuWCUvTebMU2MjgHYPdh/BbkONlQ3Kt684NWWpr/xbh0aALmTcpndChzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=++CvWlwnA/rSZRDXYWsC9pOKkuUxaoaWHUyJ6qiaXk8=;
 b=IBh97gk3Qm2MNs2oj6eDs8IIxZZ7BCrI/jIIdoyAPFTVtIlDjtDr2kIjZCXYx7pV1T7txi+iUphLPbzDA/VWWSO7dEF5AotiGVDmp+MScsZRFR9FBY2bY7S5UcE5VH3L1Hpe9w5xoAgayJ37hWJ4Pd7tDyq6RzGFLUyNGvZma2I=
Received: from BLAPR10MB5009.namprd10.prod.outlook.com (2603:10b6:208:321::10)
 by MW4PR10MB6583.namprd10.prod.outlook.com (2603:10b6:303:228::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.37; Wed, 17 Apr
 2024 13:58:54 +0000
Received: from BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::a088:b5e0:2c1:78a0]) by BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::a088:b5e0:2c1:78a0%5]) with mapi id 15.20.7452.049; Wed, 17 Apr 2024
 13:58:54 +0000
Message-ID: <cdbd1e4e-a5a3-4c3f-92e5-deee8d26280b@oracle.com>
Date: Wed, 17 Apr 2024 09:58:50 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM/x86: Do not clear SIPI while in SMM
To: Igor Mammedov <imammedo@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20240416204729.2541743-1-boris.ostrovsky@oracle.com>
 <c7091688-8af5-4e70-b2d7-6d0a7134dbbe@redhat.com>
 <66cc2113-3417-42d0-bf47-d707816cbb53@oracle.com>
 <CABgObfZ-dFnWK46pyvuaO8TKEKC5pntqa1nXm-7Cwr0rpg5a3w@mail.gmail.com>
 <77fe7722-cbe9-4880-8096-e2c197c5b757@oracle.com>
 <Zh8G-AKzu0lvW2xb@google.com>
 <77f30c15-9cae-46c2-ba2c-121712479b1c@oracle.com>
 <20240417144041.1a493235@imammedo.users.ipa.redhat.com>
Content-Language: en-US
From: boris.ostrovsky@oracle.com
In-Reply-To: <20240417144041.1a493235@imammedo.users.ipa.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR03CA0005.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::15) To BLAPR10MB5009.namprd10.prod.outlook.com
 (2603:10b6:208:321::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5009:EE_|MW4PR10MB6583:EE_
X-MS-Office365-Filtering-Correlation-Id: 978ff25f-3257-426a-f846-08dc5ee684c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	DB4/c7Omh26FBMwxDHOj70RvobBHrCvGj/AK7D2KSJ9zPhC20CF1JF3ch7QfCHxlqu4cUMD27XzSdbjSHStEkMAwLEBgIdThTfF9yD73irLhuXebN9Nyd/lrOkxYNVZSmnp4wA0dQrHjcgWEo3jBuzdCp5EiIcI0gHgrheheoGSc3OlTCjnTefJIcWRcX5J1DBCFXQiSNDzeKGmrqJ81w1CwweoSZOP5jaok/XCMPcXd920t/qbDJhmCXpFFcX4GUT3YOzmPxkjobBrx+Oo0Y4Ykcq2GORih+aM9Cu417zVlmaJqnf+40hMbVhT9tFo8Pgbqf7z7QX3cMvPWG+ifWvL8JFSd+puBLfI63rBrtp7klxQ6b0qAWOE+E8F+/AwmFz4QqgwRCYeB0d873RMt/wmAaiN34z6ZAGr3RTozz9kfn7+7q+/jUjW3x1HjEB/CMlGIG7B5dNJ/nmJ9C8conXFG2lInX55V7i3xm+XNRskLrlv/XRYbX145Txm4DVisg3IuwxqsrDWYGRVQqkkTvbn6OnUWS+OoNj8lodqPGpMxhdnREVHBOo1yMpP/C8uoyIkLJsakr4z/b82XFqDvVw33R7Fz3dh6A30a/qNlexc=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5009.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?d2daNXRXbWhTV2JIRzdrYmY0bnczcm5XMHFEdUFmazlDSEdHN3h1R0l1V3JG?=
 =?utf-8?B?ejZILy82Zk1xaDBTNDJBbTFNd3Y1Y0xialRXL1NNSWR0RjRqN0ZVeHhnT1dV?=
 =?utf-8?B?WURTWXJNVm45OG51eWdNblgxZlhhdloxei93c0Z1MjFIWnYxdzBxTm5QRjA0?=
 =?utf-8?B?ZmpNaEl2cVE4dXZMNWxvdUNQT081Q05yUFMwS0w5MnV3ZlBha29LbXdFL3JD?=
 =?utf-8?B?T3NVRlpBVXZJaEIyOUVwSFpRR3N2VkJOa2lsWnA4YnFvRXkwZGxEZndHcjFm?=
 =?utf-8?B?RzdMbHJPRDBTZi9SVkEzRFJBOWdwS29raDc4TFo3TU1ORC9xamxUN2RpQ0U5?=
 =?utf-8?B?L09SdjkvWmlncmd6aExwQlZDWHRBMS9tbWk2cWdDeDBnTm1OQ2J0NTFmOE5n?=
 =?utf-8?B?QWNING5EYVNhNGovK2JMVFJzN3NKY1BrR08yNkFJYUxibG5odWFiUHhFUkRP?=
 =?utf-8?B?NzBSUTZtYVlRa2lRL1JXbjZFdzFvRjJ4KytXblp6dHJuLzJXaEJ1RTB0bVMy?=
 =?utf-8?B?WTQzL3c3Uy9DendyMXQyV2dveEdueDRTbC9BYnZJVkV1YnlsL2VWbndJNlkr?=
 =?utf-8?B?Vy8zU09kcjN0YjByMGxJUDZFMHkzM2pyakFuYVZxSVhOcVpuVThid2Mwblhs?=
 =?utf-8?B?cE5wQmI5MFhDNFpHUENZbjF5anVKWk9ZQWJsNGp5ZTMrVWw5dFl5WE5rT0sz?=
 =?utf-8?B?SWEvVW8xS3UzelNQdnAvMjN2eVZlWjBZUEE3WmludzNTWXRTa0dCL0J6MGd1?=
 =?utf-8?B?Z2N3WW9Wc1RpQlUyZ3F2a0VqSklyMG9LM0c0RUl4VGRPQzFTbXlrMHZ6bnRn?=
 =?utf-8?B?NGhZQk9TTkVNUm1VRkNpL09Scm9lZmpDc09pTjZjZm5YZjNzRmpjMnNncU1n?=
 =?utf-8?B?a2VNQ0ZaTUJ2UXFzWUUycncrSnZrbkluWWJQczZuaFdCTmlCSXRCZE53SWVC?=
 =?utf-8?B?SGJ1M3hyM3U2aGVNVk9FVXJGZmoyVlZLL3dzWG9rSGUrOElHUVI4WWEyY3Rj?=
 =?utf-8?B?c2VVOGFGOWQvNUNtVVlMbWlJenRVa0FkSUo0TXdyaEhOZ2dPL1l0NjRrc3U4?=
 =?utf-8?B?SUIveUxhbm4yYzFrdHNvVEhWbVIzNlR0dCt3d05wU1YrZkNDMmpvVzJ1QmFv?=
 =?utf-8?B?WWh5OW1RYldIM1QyL0FFdVR3V0ZsRmkwWFFFenhzUDYwSGtNdS90c2k4SU13?=
 =?utf-8?B?aG4yUFFBUHQyNFd0bEdUdEdFV3BTdGxNb2loS091SXM0V2hKRktPNVlBblVH?=
 =?utf-8?B?a2p6bjJyMGZya01mT2g4QkJ5ZkREOVZiSnp0b09GaEFXQmFWOEhRQk9aSUJG?=
 =?utf-8?B?eVh2WGJjWGxOeXpyNk9oeWk2Nmh5a2JWaTZsU29BUjdUNmpSb0twbEpCK3A4?=
 =?utf-8?B?d2gvUVhGL1JIbEZveEVzWndKSlZYVkdEcmhkSFVCM2J2U1FEdWN3Rzd2ZU1p?=
 =?utf-8?B?aC9relRSVWQ3VHVhMDdvQTZnNEg3NnJHUmpKUXE0M2YzTzFzbEtmTU5wVjNG?=
 =?utf-8?B?ZVpEeXdGUTZYT3FmRmxKMGQyM3ZVQ2dnODVKQnhOMXc5R2Rxd1IrMTJleFJk?=
 =?utf-8?B?S2NtZ3RJVHBsczJ4d0ZvU0N3TFl5Tk16MTF6em1mdE5wYlpOQnVtQVZhY3g3?=
 =?utf-8?B?dG8wbXJjMnp5R3FQV1ZWeHNjeWV1aENTWFNqRFhOT1VWMXNTWm1kL0JRYmFx?=
 =?utf-8?B?Y3lhKzQ4U1lGaEtTQ3p2NFBybzNZQTc5dlJKakhUZnp3WklRMUNBZU8zMTJ2?=
 =?utf-8?B?cDNuYm1JT21FVnZpeTcwN0tZZm1IZWRoZUVBR1pjb05aQjkxKytSMGpOVm9u?=
 =?utf-8?B?SlVrNjVkNllyeUZva214QVFvTFdxcUNwYWtwNU5rQkRqd0dEQVdjYmJ4SEVJ?=
 =?utf-8?B?RHhVUGU4d2J4RWFsNjhJZklqT0xHSlhvNmh1bDVMdzVKMlJCeS9ZTlZISGxt?=
 =?utf-8?B?NUVCenRpY1Yva2RGSHd0eDE0VmQwaXRoRmFWTUhCZXdQU3pVbmJNYWh4elB1?=
 =?utf-8?B?RGlsZmpNL0xYejM5d2tvWS9FV1cyaWFCNjZKbDY4U28yUFFhbDhoYmc5Z2tK?=
 =?utf-8?B?cjRrOHVFMmZkMHl3bEgvR2hNMGhrcytIbnJmUTBXYjAzYlBzQmMyRy9zZlRX?=
 =?utf-8?B?MGhJMmR1WS8xL21ZbU9jQTRTUCtLMmlNZGEwcTBpNUJNTGsrSHpEV3hZTktt?=
 =?utf-8?B?ZEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	YqzwI6Ie9lHlrm8A4PVOH0N8PJZrIWegnIsQ6YDi3dXGcqHSWGNhU3Llw+119QZIBo8KZuLAfTlH4Wltnq3ovvVxSCWz/BTNf4g+MG7zciUwtwF9S+duDpQkC0PaQlJhVziFRrR/nNPHqqP3UpBvJsShLyKjv0QCUwQ0uH1bcrUMgfcBNSum6m4Va2DK4P68vKlu+wmrgVhzL5SwZ7c8naBOscWJNVskesXSJvg+QaO2Pap006Jg1CDDKZjd2dYcJ74lGopgWXN26DshQF8TtJRPH763h2X5IC2B7DGxluN0VHpi0vkZMhyevMhVwnJN6NAQHnYsJKroPUaWDrSZLeka8J2ejtw+GxrnF5/PMju+Dq9LlnHffTEhrwYHsKxBuOhr6LIDe+vpfWn9FoGhBI5Bq5kNG/1sIOYoqDTLGKTADwjrlq4BmZ/EgBO3AyK4fFN10PhtVedJG6pafziN/nVVK0HGFSUtigyb5zgJDUV8sLxeT9Q9UFKHeG9Vmc3stx0UkHM/EYhY2lKNDJjcJqysdLk7fFMbtuQiPTe94P+mcR+DliIeAHJg3zpFgFJNxa3aK1kwq/E9JRvZokVzOMC9ljAuRI26J/vJPqhfOm8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 978ff25f-3257-426a-f846-08dc5ee684c8
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5009.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2024 13:58:54.4730
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /ZYI3tkNZkG/IZzw6u3QTvyuKOTzExWNrLGvDsIduEIZAZCiB+tts/mIugG/B5IVL7CwSA1EY8iutiAt/8tnJFgr80cJTcxHWCtTBEQKcOQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6583
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-17_11,2024-04-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 phishscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2404170096
X-Proofpoint-ORIG-GUID: _p-l6ZTD_nkunlDyumZ3h2tyDXXIVSLG
X-Proofpoint-GUID: _p-l6ZTD_nkunlDyumZ3h2tyDXXIVSLG



On 4/17/24 8:40 AM, Igor Mammedov wrote:
> On Tue, 16 Apr 2024 19:37:09 -0400
> boris.ostrovsky@oracle.com wrote:
> 
>> On 4/16/24 7:17 PM, Sean Christopherson wrote:
>>> On Tue, Apr 16, 2024, boris.ostrovsky@oracle.com wrote:
>>>> (Sorry, need to resend)
>>>>
>>>> On 4/16/24 6:03 PM, Paolo Bonzini wrote:
>>>>> On Tue, Apr 16, 2024 at 10:57 PM <boris.ostrovsky@oracle.com> wrote:
>>>>>> On 4/16/24 4:53 PM, Paolo Bonzini wrote:
>>>>>>> On 4/16/24 22:47, Boris Ostrovsky wrote:
>>>>>>>> Keeping the SIPI pending avoids this scenario.
>>>>>>>
>>>>>>> This is incorrect - it's yet another ugly legacy facet of x86, but we
>>>>>>> have to live with it.  SIPI is discarded because the code is supposed
>>>>>>> to retry it if needed ("INIT-SIPI-SIPI").
>>>>>>
>>>>>> I couldn't find in the SDM/APM a definitive statement about whether SIPI
>>>>>> is supposed to be dropped.
>>>>>
>>>>> I think the manual is pretty consistent that SIPIs are never latched,
>>>>> they're only ever used in wait-for-SIPI state.
>>>>>   
>>>>>>> The sender should set a flag as early as possible in the SIPI code so
>>>>>>> that it's clear that it was not received; and an extra SIPI is not a
>>>>>>> problem, it will be ignored anyway and will not cause trouble if
>>>>>>> there's a race.
>>>>>>>
>>>>>>> What is the reproducer for this?
>>>>>>
>>>>>> Hotplugging/unplugging cpus in a loop, especially if you oversubscribe
>>>>>> the guest, will get you there in 10-15 minutes.
>>>>>>
>>>>>> Typically (although I think not always) this is happening when OVMF if
>>>>>> trying to rendezvous and a processor is missing and is sent an extra SMI.
>>>>>
>>>>> Can you go into more detail? I wasn't even aware that OVMF's SMM
>>>>> supported hotplug - on real hardware I think there's extra work from
>>>>> the BMC to coordinate all SMIs across both existing and hotplugged
>>>>> packages(*)
>>>>
>>>>
>>>> It's been supported by OVMF for a couple of years (in fact, IIRC you were
>>>> part of at least initial conversations about this, at least for the unplug
>>>> part).
>>>>
>>>> During hotplug QEMU gathers all cpus in OVMF from (I think)
>>>> ich9_apm_ctrl_changed() and they are all waited for in
>>>> SmmCpuRendezvous()->SmmWaitForApArrival(). Occasionally it may so happen
>>>> that the SMI from QEMU is not delivered to a processor that was *just*
>>>> successfully hotplugged and so it is pinged again (https://github.com/tianocore/edk2/blob/fcfdbe29874320e9f876baa7afebc3fca8f4a7df/UefiCpuPkg/PiSmmCpuDxeSmm/MpService.c#L304).
>>>>
>>>>
>>>> At the same time this processor is now being brought up by kernel and is
>>>> being sent INIT-SIPI-SIPI. If these (or at least the SIPIs) arrive after the
>>>> SMI reaches the processor then that processor is not going to have a good
>>>> day.
> 
> Do you use qemu/firmware combo that negotiated ICH9_LPC_SMI_F_CPU_HOTPLUG_BIT/
> ICH9_LPC_SMI_F_CPU_HOT_UNPLUG_BIT features?

Yes.

> 
>>>
>>> It's specifically SIPI that's problematic.  INIT is blocked by SMM, but latched,
>>> and SMIs are blocked by WFS, but latched.  And AFAICT, KVM emulates all of those
>>> combinations correctly.
>>>
>>> Why is the SMI from QEMU not delivered?  That seems like the smoking gun.
>>
>> I haven't actually traced this but it seems that what happens is that cv
>> the newly-added processor is about to leave SMM and the count of in-SMM
>> processors is decremented. At the same time, since the processor is
>> still in SMM the QEMU's SMM is not taken.
>>
>> And so when the count is looked at again in SmmWaitForApArrival() one
>> processor is missing.
> 
> Current QEMU CPU hotplug workflow with SMM enabled, should be following:
> 
>    1. OSPM gets list(N) of hotplugged cpus
>    2. OSPM hands over control to firmware (SMM callback leading to SMI broadcast)
>    3. Firmware at this point shall initialize all new CPUs (incl. relocating SMBASE for new ones)
>       it shall pull in all CPUs that are present at the moment
>    4. Firmware returns control to OSPM
>    5. OSPM sends Notify to the list(N) CPUs triggering INIT-SIPI-SIPI _only_ on
>       those CPUs that it collected in step 1
> 
> above steps will repeat until all hotplugged CPUs are handled.
> 
> In nutshell INIT-SIPI-SIPI shall not be sent to a freshly hotplugged CPU
> that OSPM haven't seen (1) yet _and_ firmware should have initialized (3).
> 
> CPUs enumerated at (3) at least shall include CPUs present at (1)
> and may include newer CPU arrived in between (1-3).
> 
> CPUs collected at (1) shall all get SMM, if it doesn't happen
> then hotplug workflow won't work as expected.
> In which case we need to figure out why SMM is not delivered
> or why firmware isn't waiting for hotplugged CPU.

I noticed that I was using a few months old qemu bits and now I am 
having trouble reproducing this on latest bits. Let me see if I can get 
this to fail with latest first and then try to trace why the processor 
is in this unexpected state.

-boris

