Return-Path: <kvm+bounces-10205-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BA0886A7AB
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 05:44:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8CB6C1F27B07
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 04:44:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42C1421101;
	Wed, 28 Feb 2024 04:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Pf9f/6Eq";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tZx4Rea7"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 834EB210E6;
	Wed, 28 Feb 2024 04:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709095464; cv=fail; b=o5sWhs63xrRLS5HAPM2YJImCYWPw5ln7eY3oqswTLuF3+XhRwvPqGEscY4yIcdALZUvAGrX26T26B0SZ0uiMpWbwyXxn89LsLhvsTPV3tgVbZ4mTTBYDVsJYONMeyZfEtnsLkX3YDD3UQp6ToGmn7rHR+QstZ4Z+sipykOf/h6k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709095464; c=relaxed/simple;
	bh=pciBbbvtrym6YzO3K+4PbwIjUhE3f7K2ULVeTdV73xk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NHN+UoP7+NUhDzln0611wL+ttp9GoJbBWbUxcqVnU6R7a+ON6hZaJsKP/J6DlopeHeh1A1GxJXDxtpfvh3rVPwTY4XnjpqSgHXGN3ND5DDEqQjnmZuJF/OSEFl27AKSbzXov86Os86YNeCRRb41V16O9oNCx3bC8ZxXZbdiz5/o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Pf9f/6Eq; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tZx4Rea7; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41S3ihMO017811;
	Wed, 28 Feb 2024 04:44:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=gm9Vt8avca/utdJCsVcozPGApHR9PY5QmcnUKf1/JUg=;
 b=Pf9f/6EqlBhfhHnQ+4WUW4TiBMlyA6URXKtYbQ3ZVY5Cp7us7Z84PTyYCVH3+Q7dwq+4
 pgJdpY3oZCDAEj3Lq/sgl5EUz+9HZBCYcxyh9DniK2upDCDDQgJSrXOJGMOjvzBg4aME
 DrVvvpS/C+zENW+P9RypqItYouXx+PdhYZeGAFzSKa4GfVwutIT6CQ+elQmvc+SErFzQ
 CTjwGvlqppDJX5S6E+pddPUejLXUUlpuM6CFXPrM4mYaDLHlZtD58Ti55SNiUuiBmJxZ
 8aEmPMWi//GSZaEDIy9LMcI3EnDad1DAXp9/JAL2wWD7TvgcqADqSw5JtBXWmqdMmCBh IQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wf6ve1a8s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Feb 2024 04:44:14 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41S2pD5O001694;
	Wed, 28 Feb 2024 04:44:13 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3wf6w8b70b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Feb 2024 04:44:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xdu1BS+2QVS+lKXM/NCUq9J7f6gzZf3SJP4M6FXoZRVhbRxHrvXxhdl7akcSKFwoYe6O0rBOamrU8t29d0LjnHWDXCVVWyJnXXOdN7kNr3FSyJJnbSs8G7a/kxKr4+iUIw4YzhT7aIsqDadPolCIouKGEQAMto1b2nVlDWlH1nWNJolRQn/XluiRh76UL73vG4qNmKaq4yE3Ql3xD2WhKACr/7V75/7s4iBtVqgGYKI/aVq2leetRxnCKOQwWX3CW3rHTLph6+YYv1h9KnzWNVu6ER0eI89hZ3aHnAgkKWVxir9b/jji5zEkygT2wjasdxCO3K42/7DT/1R3n1t/7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gm9Vt8avca/utdJCsVcozPGApHR9PY5QmcnUKf1/JUg=;
 b=D3Wgy1T64bczfzsUTh2C/EdGP/tkvYklq7Sr/64mupL3lojfi1MTDKLCwzuZsEqKl5z8n0kiMBKfTzbeUeTKqibDHlkQl/4tYgN4vyn0Jr4vpvljw6RB83nsYOp3CZDjYPRNxci0LEBLwZqBMRYEiVUeNOUk5DqqQYNEpJoktV7aEkDsJwAQcBVlZ75jdFWROEuAT0neyO3CmmZZof6GCwd81WI+u0/AWUBALCPac2DPdU8okFMkqiZKtJZZMZhdCj4nNzKDLsWO2c3DN/8oAKOMvB5u8KwZjVp5AkkEEc8d7ZBjMe+REOg6Qt/EZVsbP2+SOQ6zCICWN4A1CcuBcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gm9Vt8avca/utdJCsVcozPGApHR9PY5QmcnUKf1/JUg=;
 b=tZx4Rea7X3+JANWw8geK6pQtdkflh6/JuIFcvai2+6EuVhRZbxRk6NU7gWk1PRS7gufvQMGaMW7qQlmjWU3gENMX3HQhWmmnTNTQuDpYT+femgteZS49cX9V2ZfoTizzlRS8w9fBTecZ2E6oqYPZQS9pLPlKE935kR84WUsYAJI=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by CO1PR10MB4769.namprd10.prod.outlook.com (2603:10b6:303:98::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.36; Wed, 28 Feb
 2024 04:43:09 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::8156:346:504:7c6f]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::8156:346:504:7c6f%6]) with mapi id 15.20.7316.037; Wed, 28 Feb 2024
 04:43:09 +0000
Message-ID: <12f0b643-e2e8-8a9a-b264-5c7c460f1a24@oracle.com>
Date: Tue, 27 Feb 2024 20:43:03 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 03/16] KVM: x86: Define more SEV+ page fault error
 bits/flags for #NPF
To: Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yan Zhao <yan.y.zhao@intel.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Michael Roth <michael.roth@amd.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>,
        David Matlack <dmatlack@google.com>
References: <20240228024147.41573-1-seanjc@google.com>
 <20240228024147.41573-4-seanjc@google.com>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <20240228024147.41573-4-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1PR13CA0156.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::11) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|CO1PR10MB4769:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b40e7a9-6dc2-4042-e7b0-08dc3817c33c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	Persh4oAhFugaTvRIn5L0gYPQkH5dWGYD99ZCsIB3/3ACtnKxN8NSLkOtWHs570ktpGkX7ug3FFB0tiv+IiaLNVFrclgfAIxRfr0cvkWgWNy5XKrwhmWr6L37LlozcTQyUPrCixtZFlQ+PRlBwiv3yRHbt+k07J+tqk66mV1BRbj37E/N5Kl/DwtRJ+1ZM907ohUaWnYLC0jZsLWvgLwu3KZUAusspeCbFN5yLG+G5p7tEwWc5oSpi5r+RXKRY4IWFyqP3vLQZ991RG+Olg8Q5ikqtcuZZft81DRiMPJ8We6tRVWx3nJ5u5/4QONou+9wcpKwLGKufcEN9Gp3G1QCcpl/VzeMhodr85xFAlIlS7KBH60WAK69VTrVfLwKnaUj6SNi4BnGj0pMs3WK4ybSCchFb5b4evyZno9LGib0NtnBgM/L4nsHnGXXJp86+7LnwfNmd3Ml4ag7MTqR4ty554I4Ft4uMfSgRTJwy2eVzJ6xFvbP2sTH+cwPe1W27FuDqypiFQYhmWDmEXyTugncZ1+L2kYdzRi/27x+ZZkmVfQCz+FzJOQt7kWSEiuTCkgvRpIwSMeNRqOOzh6xm21Yus4xGUo/80dIRfDPcdgukmkBjkyEzZo7hvSQ79TKAJUwXIsENvT4oasoOW3iO+O5w==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?QVl2Y1RERXNlNXVyMEl1UmRMVEprQUlCcm5tK1J3RUloTTJNM2V6OWtMSUVL?=
 =?utf-8?B?am41MnRyUW1Td2t1U2dBaktGbDZtakdOR3JKZ2hMLzBSeUd5aHUraHUvVFJV?=
 =?utf-8?B?cTlBaWxpbFdvckZOMlJXMGV3NnRrbjBaVEgvOGFpOFZ1V3Zjb0RMdVNpWVhl?=
 =?utf-8?B?UkNuNGJlcUpuWHFnanFocDJpbjNiNWlUY3JOaFRISU91eWhxWnhsNFdHMDFG?=
 =?utf-8?B?cnJVVUdseEJscjRlMGhsUzE0SXdUaGtGSDlIR0FKRk51eXl2VkNvS1FHSmZn?=
 =?utf-8?B?NzBNSkNoSU1BOWEzZFpTUWdPQVpEV3JIMjc5dWpFT2cyaVljMXMrR1Zyb1pi?=
 =?utf-8?B?ZXFqeDMyRjU4T0lDSXpFU1hsMUlpZHZzTmFwTHNCTzZ2V1NYbFhORmN5NVVp?=
 =?utf-8?B?aHBibmxBU1ZqTnNnbXR3VklGRnoyd2tQYkJUaStRZitqMVVXYlh3NFBIeVNp?=
 =?utf-8?B?VjVFR1dPOWNrQUl6RVMvV2o2TktWZEJOZUEveFM4U1R5V0hWcU0xUEF5a0Nu?=
 =?utf-8?B?ZXZuU3lySGh4b21JVDlUbE1BOGhOYTJlNUorNDI0SU5sZjloUmcwZ2dDTVNl?=
 =?utf-8?B?cmZ6aForNHZSOU1PcElaQXBvNVl3bVdqd2tlR0NuMzhmSnpDZUNoS1U5MHY5?=
 =?utf-8?B?b0NHeEUzMElNVHI0amxvWlF1UCtyMmtpMUdXR0gyZE9rSWt1OTgzbGl1ZHFt?=
 =?utf-8?B?dVpDc2FHM2hhVW1ybG1HNzkwSTVvd0prVThiZTBNRWdPUkVaRGJKWitQcDZZ?=
 =?utf-8?B?OUdKd3IwRUp1blUxZEFuS3lFNGd3Q21iMzJ5REwxa2h3cEtMbG50eUdmeDkv?=
 =?utf-8?B?eUhSaDNxWFgzZHFNUzZhQzNGLzR2TVBnMWlVL1dJM2VsS2N1ajVTUUpsUURr?=
 =?utf-8?B?bVVJZDhTV3g3ZDNMZWc4Wko1Nm92NTVDYUdtOEMzbGZQNldaeHpEVGF6aklQ?=
 =?utf-8?B?cHk0N2NnRWhWcU9sSmViZ0VMSEdTanBrSmY0SDRwNnBPcE1uZzdpTWhKYzVB?=
 =?utf-8?B?VnJIMktremlrdlhYK2VveXYyQTlrZ0oyWnEwdGI3V21taEJNZTMvUytNbHp6?=
 =?utf-8?B?SDFrcmV1R3ZNZWxXNFRvaWpWVzFucmJIa3JPM21CZjN4VlJTWmZRWmV0SWov?=
 =?utf-8?B?a3IyOVBQb2YwWXNlekF2eDdEWFlUZ21FaXBHM1pCS3ZEU05FeTVvVkVoWnFM?=
 =?utf-8?B?U0d3TE1IL0RSVkdKUWJ6S2hYMzFoTzE1OE5sTERlMWhKaVpMKzZXTThsQS92?=
 =?utf-8?B?QS9YSHViY0JCeUpqcmRCWGdhY2h5N0dIZnhyUEVPR0RJZzg5N21JbmYrbzRw?=
 =?utf-8?B?dHpQNUJ3WndXOHZsWi9qc1BBa0JGRFRZUkFpQVQ5RHJPWGhEUVBnZGViYXZ2?=
 =?utf-8?B?dlgxSGFxNm5YejR5eDQ2elZNLzJJcHNoamRTcFlYMzVhN0kwTGxNMWlneWR4?=
 =?utf-8?B?a2VRNlc0R2dOZXVFaVhPa1pYeFdJKzA5YzRoL0RyNjNRMVJGVktWb0JvMXR6?=
 =?utf-8?B?eWNrc0MxMU5VdzNtREtSWlF6WkVPelM4QnN1aHlUMnI3Mktoc1RlQW9FaVk4?=
 =?utf-8?B?cFN6YmI3SU9OTDhRdFhFTU9KVTdZTGhaSU0zMENXQytidElWVEhwUmRlYkZa?=
 =?utf-8?B?SUs5dGJPNGt5ZU04Nk9adVcrcllyRFA5U0FNcnRpYnRpZE1mall0aXFjaDBm?=
 =?utf-8?B?dVFEbkZjQVM5dEtTbExPNlhKL0x0QXNQYUVGUUlwNnUzbFFialhaVTFXTWNM?=
 =?utf-8?B?dTJ5dlIzdmdiaDZBRzRQc3N0MjFJdFZ5N0x0SklZUFdlblh0OEMzdjJTUTZs?=
 =?utf-8?B?SVJNaW5CbXZVRmNLVlpSZnl0eGl2MXkxNWE2VnZFc2lWZm1sMGxLT1NBM0hR?=
 =?utf-8?B?REJKVUdxZmRxV0xYd015ZG55R1FBTGlBNFZDUCtSNFJ3R2ZhbURNYjBuOFR5?=
 =?utf-8?B?QU9EOWlHenMyTjJnMVlQV0NUcjJ6OXZ1UkpKL1RTTStTQ1RTeWxxK2xidXR5?=
 =?utf-8?B?SEpTcVZTSnMza244MWV1MkJEc3R0bWJoenpjRTIzVGdvaC9Ec3lETWw5N29h?=
 =?utf-8?B?R0Z3V3AvTTBiTXU1ZU4wSUZ0N3JBUHE5OC9EZ1RvYXdEMlJZSU0xRnM2TG5T?=
 =?utf-8?Q?VTVjaAAzuTaViYiyBVVgNNjE4?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	yVVEL1Qh8wVzZ/4Y4Pih3WDQUZov7EMNkOTxiQm+roC1h0wySVXky7qFhgUzWfhbZ19sBBn4Q3bsyng2d2fM0w/O36hU1l6v4q8VIah5eZvpfaCyv8hCwNTj1Uqp6WyLCcckTuMEeHslM1Ru+BOSRu1nbRUiGZlSF57GVaURYGztT9jGST8oeR8kEcyNOoTunOL+VtiUYywY9ZcIBQo4ziZybPWIxkg0rCys0LGQQ6tYq+5+N1kq4+sSxabaxktdkf7mU5BtGtvBKdBlNF73UzX1SrznRKgIa/oNkLx47MFm4ccZbbAOCoVmdA3qrGd9tJTfC30ExEihpKFs2UL/+3zkLzP/8FKjEhYJVjSC30nq3niVmTt7Mp65iw0vazS5wDBA5wmVxUl/x1TOfUB6TTv5ZNiNzNU1edhfmnE1g4zUwBEvgC01t4uAJjvmBwSPOPANuoM1R2iQxjmj1lx5ZHYdG6mCtwQ/4It59ubL+PyVQpq8crgMlN1f+tIRS5HZ0RLTemxbwNQfjuC7I09YfGCjKR+X4Z9RnHF1Qm2BlTrBhUYGBSVroHNwiKU7jxdSxkcZkVK4xkBsVyMXWUv+jFhWT5lSyfdj9xCxeE0wQR8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b40e7a9-6dc2-4042-e7b0-08dc3817c33c
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2024 04:43:09.3730
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kbmMGcPAYR0uQPHPfbgOpqlifjPyy8xH55rmGisvV0Qf0Cxo8OZpEx8z0hDXpjC4u0VKlx1l4NSQMA73dLKMHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4769
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-28_04,2024-02-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 adultscore=0
 mlxscore=0 mlxlogscore=999 phishscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402280034
X-Proofpoint-ORIG-GUID: VOvepnwTbSXC2XPqeqIogtq7aOEpsAZU
X-Proofpoint-GUID: VOvepnwTbSXC2XPqeqIogtq7aOEpsAZU



On 2/27/24 18:41, Sean Christopherson wrote:
> Define more #NPF error code flags that are relevant to SEV+ (mostly SNP)
> guests, as specified by the APM:
> 
>  * Bit 34 (ENC):   Set to 1 if the guest’s effective C-bit was 1, 0 otherwise.
>  * Bit 35 (SIZEM): Set to 1 if the fault was caused by a size mismatch between
>                    PVALIDATE or RMPADJUST and the RMP, 0 otherwise.
>  * Bit 36 (VMPL):  Set to 1 if the fault was caused by a VMPL permission
>                    check failure, 0 otherwise.
>  * Bit 37 (SSS):   Set to VMPL permission mask SSS (bit 4) value if VmplSSS is
>                    enabled.

The above bits 34-37 do not match with the bits 31,34-36 in the patch.

Dongli Zhang

> 
> Note, the APM is *extremely* misleading, and strongly implies that the
> above flags can _only_ be set for #NPF exits from SNP guests.  That is a
> lie, as bit 34 (C-bit=1, i.e. was encrypted) can be set when running _any_
> flavor of SEV guest on SNP capable hardware.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 88cc523bafa8..1e69743ef0fb 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -261,8 +261,12 @@ enum x86_intercept_stage;
>  #define PFERR_FETCH_MASK	BIT(4)
>  #define PFERR_PK_MASK		BIT(5)
>  #define PFERR_SGX_MASK		BIT(15)
> +#define PFERR_GUEST_RMP_MASK	BIT_ULL(31)
>  #define PFERR_GUEST_FINAL_MASK	BIT_ULL(32)
>  #define PFERR_GUEST_PAGE_MASK	BIT_ULL(33)
> +#define PFERR_GUEST_ENC_MASK	BIT_ULL(34)
> +#define PFERR_GUEST_SIZEM_MASK	BIT_ULL(35)
> +#define PFERR_GUEST_VMPL_MASK	BIT_ULL(36)
>  #define PFERR_IMPLICIT_ACCESS	BIT_ULL(48)
>  
>  #define PFERR_NESTED_GUEST_PAGE (PFERR_GUEST_PAGE_MASK |	\

