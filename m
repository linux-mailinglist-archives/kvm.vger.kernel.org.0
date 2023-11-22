Return-Path: <kvm+bounces-2335-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 657837F52A8
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 22:34:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8880A1C20BD4
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 21:34:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A6911CF98;
	Wed, 22 Nov 2023 21:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DGqWAqSp";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="snswto+W"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A15D81B3;
	Wed, 22 Nov 2023 13:34:32 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AMI1sCj024627;
	Wed, 22 Nov 2023 21:33:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=l00t4r4lDmeQromrVsFWao4+QKl0f1m370See9qT18o=;
 b=DGqWAqSpzOre83gHaWBpbk8G7rl0Ov5QZ43LZwocl1tkI6cK8lB6njO3pLNVMIRaYXVM
 SjhLgCL0OU7MJ4aow37Ucm7zN6y94ddLvGuAZRIprWH7x+vZIKGvHoa3HKGsaJ+eG4Ca
 PhrO48cmDLZuW9yUYMXWub0bPamaVsFARUel+3m3g04xqzjZrhLz4DbLMHvKJcWHqBgZ
 4H7PQBubP2VCn2KFlVroojMhEI3J1vr8i5uXA5kzYii5aOGmaShd82QQpjnbI/jRyqLb
 fBxZpUPmnBVgPmBfFjGKcKl+niSGYJ6uqd9AT6Li6gNsz50TlMEFxqf6n4bG/SOf+6zO Kg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3uen5bgd51-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Nov 2023 21:33:26 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3AMJaLxG002352;
	Wed, 22 Nov 2023 21:33:25 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2169.outbound.protection.outlook.com [104.47.73.169])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3uekq9bs3d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Nov 2023 21:33:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VNm9vYumoi42iTkbhRV2EbSI9swDlmEdg2DJ0Js4XUKa4htNWLOvUrXQLz4xYAA8agxoTSAWcR4p0Px6hIA4dVlwUe7NeKIEqgfHXa+Rns26gh9s6PFC1j7/9UBo3b+Um0qPReTJvztoDsJPhH/ydDtM/u3IoN1fNxdKoKv2ZKhed2B4uk2KD6IIiDoVJGRT7T0naDbtSVv0fYEmq14ts/10nydUefHBBJX2yWI3vzeB7N15dJG3FAjekteQSkTNOqcmchMiTvIGYoIoBje4n/yw05N8KtwuCD5z1VyrJaNsKBzPHxHhbbZkek5/NTogcB/HI9h0+Stosx6dD4QQTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l00t4r4lDmeQromrVsFWao4+QKl0f1m370See9qT18o=;
 b=VQ7l/dkV8FlQqiqpxaUx+47sBem9PFLWO4e70eXvCOG7CPB6/oVfujBmP0bxFVozrTwMlrrxbPsAFKabyax0obK6HmF69/PveWfioaxxmslqOuRuO9mRg0cAwxrzMVKoV5w9u4dBvFQ3QoUu6Q1+DaxZQnpEmXngn0KNvD7wfNNMFfCT9XTssRFPrY+/Mr8+uWOgfi8QvpAcNpVcpNNSGO9ERadrLEav+m6zEiZzqlwDxi0kwR4J7tBJkzwd3EYkbyOcLcNZeXVZ08794eIOK/VZ6KpBYICO7jBdr2YtnSWyeblMNq69VFHcI7guaxUkGwp4TkHZV3t7P9sTn7rgrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l00t4r4lDmeQromrVsFWao4+QKl0f1m370See9qT18o=;
 b=snswto+Ww9qxxIYdakcENNEshMlCaAwReM8uhPPy8aOet24DhvjgkVDJhS2Qc9y1Qse4AwkclRV4iz/+rNonWhvMy+3a6WheDjyJVJLJi98aw8+CRs3aG17Z51PfaO2B+mRlEHLmm+TMTvxUmIj+kUZxVNJ2d4EcAY5DqCJB2b0=
Received: from PH0PR10MB5894.namprd10.prod.outlook.com (2603:10b6:510:14b::22)
 by SA1PR10MB6567.namprd10.prod.outlook.com (2603:10b6:806:2bc::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.26; Wed, 22 Nov
 2023 21:33:22 +0000
Received: from PH0PR10MB5894.namprd10.prod.outlook.com
 ([fe80::77c7:78b0:ea43:e331]) by PH0PR10MB5894.namprd10.prod.outlook.com
 ([fe80::77c7:78b0:ea43:e331%3]) with mapi id 15.20.7025.019; Wed, 22 Nov 2023
 21:33:22 +0000
Message-ID: <724589ce-7656-4be0-aa37-f6edeb92e1c4@oracle.com>
Date: Wed, 22 Nov 2023 23:33:13 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/7] cpuidle/poll_state: replace cpu_relax with
 smp_cond_load_relaxed
Content-Language: ro
To: Christoph Lameter <cl@linux.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        catalin.marinas@arm.com, will@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        pbonzini@redhat.com, wanpengli@tencent.com, vkuznets@redhat.com,
        rafael@kernel.org, daniel.lezcano@linaro.org,
        akpm@linux-foundation.org, pmladek@suse.com, peterz@infradead.org,
        dianders@chromium.org, npiggin@gmail.com, rick.p.edgecombe@intel.com,
        joao.m.martins@oracle.com, juerg.haefliger@canonical.com,
        mic@digikod.net, arnd@arndb.de, ankur.a.arora@oracle.com
References: <1700488898-12431-1-git-send-email-mihai.carabas@oracle.com>
 <1700488898-12431-8-git-send-email-mihai.carabas@oracle.com>
 <6bd5fd43-552d-b020-1338-d89279f7a517@linux.com>
From: Mihai Carabas <mihai.carabas@oracle.com>
In-Reply-To: <6bd5fd43-552d-b020-1338-d89279f7a517@linux.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0054.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:152::23) To PH0PR10MB5894.namprd10.prod.outlook.com
 (2603:10b6:510:14b::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5894:EE_|SA1PR10MB6567:EE_
X-MS-Office365-Filtering-Correlation-Id: 3468d15c-56a4-412e-c63c-08dbeba2a6f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	KURMWA/LCMiVoleT10biQD3HLoCRfRF8YPClxEVs4ls/hu1PsNq1C1+QDojz0tdV8Ffamnk5pmgmbwxlfZI5v4DJFgPzUBJtUrGHeCwNqRPhpVplHwP51oJQBUErVGjdqJ1sB3PgAd51ss1IAKbe0+ggneUMa1IVo25B58wapX60o6O3pN+TFOFYSZkP9w6fU9oSwzY6eI5MYJtgDfPCr9md7KFkifu+b1Eq42rIsO+daUSwSNHAvun3mXl3mDkNUcvKwwqaSRLzJCRxjKvh/qm53F58GG2T7Gl0Kgp7iH3RamTUIVEtt69YBupw6BGEeD4AN67DhPyQlffHhYMcfkQhfc+aevi6rB6oVpMyOj3Oh4MTxOgh7lpTcFL5StTzfNrt3EMblMum3iZUWoVK+pEZLqQMpBBPV5sipmwGJR7EqJT6HssYvZaHnVRUID3QmZVzAVzR10uqAtBDktBQ4uyTCCujj0/jApIqasrAO+5tk/AO8cXRqG6mh//FYBfZglzZOdISC0e9KSULH+1IRxjxU7IXUIGqdjNS3fUza3F8JJhR3JxDDhoarBBxXUWG5TsRobvbTV5Qmx39WxdF6pxD1q3tf9/rGjanAxlI9xn4HicpeMXFWlcVg7JvGBDEMA5H39S7B1MdZiPZrEAJHQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5894.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(39860400002)(346002)(396003)(366004)(230922051799003)(451199024)(186009)(1800799012)(64100799003)(2906002)(31696002)(86362001)(7416002)(5660300002)(6916009)(316002)(66556008)(44832011)(4326008)(8676002)(8936002)(36756003)(66946007)(41300700001)(478600001)(6486002)(26005)(6506007)(66476007)(107886003)(38100700002)(6512007)(6666004)(2616005)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?Y3JxYkF5dHlKSjVJdmF6OXZWY3NLaVJxMW0xdzFLdnpCSmtTZURUYXoyQmUz?=
 =?utf-8?B?Q3BPUzhvSFNUdXVaZFVsSERwVXBCSTZQT0Q2TXhlVktJV0M0MGUxYzV5YndX?=
 =?utf-8?B?RXRaQytNaDJrMjh3SFkyZndNa1h0ZjNrcDIvc3JVVVpVcStVTGFtSnQwNlVj?=
 =?utf-8?B?dHNBTDAvbVVuUjRmZFk5U1VaRWRYejhsZ1ozeSsxeXl4ZzJZc0tjSWNsNEk0?=
 =?utf-8?B?N2RoaFBQOWZWa1NMRDU5cUM0NlVuM1FibUJ2N1BqcytGYkM5bW5VRmVXTjVu?=
 =?utf-8?B?SFVLVEZTajgyZEdyRGhRYzZtbmk3UndiWFFFRG85TExKRDJWOGpKd0hMalVF?=
 =?utf-8?B?eWZLV281ZG1xa0JxWEhWMXFnVnhkeEpVcWpSTzB0NGVjeVN0UW1DVHBpV1JD?=
 =?utf-8?B?ZGxiNEFndkswZUgwMCtXQnd6WTlFZmZYZkpzZDBJKzBQTXdNaWl5WXMwejlJ?=
 =?utf-8?B?NldhMEJiTEI5a2VxZ3FzUzdpRDJ5bUVNN0xwVUk3d3BDdnNUVzNwRTJZMUJy?=
 =?utf-8?B?dTM1Ny9XbVliR2ZYYS9YZ1JHVHBvRVVPY0lSTXYyc3pwL2VGUWZ4RUEvTmdp?=
 =?utf-8?B?dXBxMnFkNjdhRVlpejZZeVNBZUZ6RGI2a3BNYlhwTnVEbnB5cEhDSXlqbk5T?=
 =?utf-8?B?VjEzdlI5V0ZVc3ZkUmMrRVM2TnVCS05OT1NpVXpoTXR5c1VyQm1EWUZLek1B?=
 =?utf-8?B?QUVETFEvRlVWSlZPRHBuUTJHL0pTUFRKdW11Q0JFdkFzSFA4S0NqbDhxakF0?=
 =?utf-8?B?SHRPbGQ0c25obERFaGViZ1pod3MrOGtnaVdwanJQNzkzVWpjTTlLcjhObVdh?=
 =?utf-8?B?NkJxSDNGbzYxM2ZYQjUzV0RiN21rUm5sb3JFSXF6RHR3TXNIbUtNMWJaazBs?=
 =?utf-8?B?cHgwd0xlNE53SnRnd3BtSzZSc25MSHBUNkJxUDcwcjZ2cnJFblN1ZjMzOEYw?=
 =?utf-8?B?ajY0amN0Zjg5ZzNQWEd2aWhQbUY0ajhWTkZhZ2tUZys0N1YxdGRzanZjS3ZT?=
 =?utf-8?B?SnpSQm1aZ1o3bE9xQjZvTFU5cFV0MmpQdG5pR21Gb282VTNSdElNb3B1bHpJ?=
 =?utf-8?B?OC9FeEZUUXVxbDdPOUtZSUlFWllLeDZDRG82ZUV0Mm5VTDYrQitJQjZkNSs4?=
 =?utf-8?B?SU9BOVlhU1ZxUnpFRGhCREdHeXFTeldkdFR1b1YxL3lUdTVvdlJtUXVPSDdO?=
 =?utf-8?B?dEhUZVZrc0VFdFp1WUZHRzB4VDBNWlgzY29tNHhaY1V4enptNmhDai9URUNj?=
 =?utf-8?B?bmJib2ZwQ3pYck8xblB3Wm1MVERUNml4OWx3S2xUNWFYZ3hiVEhBTTdnZzZL?=
 =?utf-8?B?YVlndVM4aVhrK3B2bTJWOVFmb3FhNVJWbHo0Z2s0ZVBzOTMrTFNsOHNFQ0lt?=
 =?utf-8?B?aDM5MTUrRDBBOW5CTERTeG5xamh0VDB5OVVlRzdHT0tBS1g2clNJVzJYRnlO?=
 =?utf-8?B?dzBNL3UveG5FWVd1TzFyZzRxNXd1bkh6ZHdxY2VycGhNdHlqWHJ6SVFLb2Ux?=
 =?utf-8?B?cEdaSWRhczI0ejFpN1ZRNHk4VVpxY0FkajJBbzVzUldidjk1TS96UzhsVjVU?=
 =?utf-8?B?eFZ6K2FCUHFPNGlZRWRwSDJ3YjRJaDNhSUlBemlIVlRxWXB1TEJQektEZHlk?=
 =?utf-8?B?RFBYb1JFNHorWERWb1BjYmVaV3JVSWFCYXBGdkR1b2Qxa2dTa0VPNDZ2Ym9H?=
 =?utf-8?B?T1hUcDI0cU5XMW90N3JhRFJvUmo1MnFkc3RZTDFOckdrOWdtNHR1NVIrbk5j?=
 =?utf-8?B?ZlRxSFpXd1RDb3ZZeERNUFBaYm1tZTFIQW1DaDBvZUxvb0tFWStDdVlZNDBQ?=
 =?utf-8?B?WWN4a213QzFmUVMwejRLcVFudTd0VnlqTVR5c3EwVm51bjJTbGtzS0dxYTVk?=
 =?utf-8?B?U0F2OWMrSEhaY21xTWNleTRoRkVFeTMxbk50dDhKMlBnWVhua3p1NTBXbXRG?=
 =?utf-8?B?akFXVTNmNmdYUUY2eDJRTGIzbWlrQ09wSFNBeWlXYkZ3WTNGY0NBZVJPWlk3?=
 =?utf-8?B?VzZQNUs1QmVWTWZaWWc3L1ptd3ViSzgyK2lmYW50RSt6UCtsQWRFUmVLcGNQ?=
 =?utf-8?B?eDlCY0Z3cjYxMUZXeGtXSnovRW5tQ2llNHBKajJ6U29mL0ZpWDNWUWNMN2pY?=
 =?utf-8?B?UXFtTkJXc0IzVzA5YWt0ejZueEtTSHhJckF2a1dQN1RPbDV6QXJUcllDalZx?=
 =?utf-8?B?VVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?utf-8?B?UThDUTNsL1JiOXNWUWRVWHExRGI1d2NuWjh2VnlpSE05ekd3U3U5b3kwVDdK?=
 =?utf-8?B?bGZrUjhDcWdBcTRvb05sNzZ4dzBOK3cycnpjMGNCaXN5cGJNajBiTFp6azZu?=
 =?utf-8?B?VUp6UkVHaytIT0JZT0trbWp6VVZraE1TVm56UHpYZzNic1B6WEJRSE95U3hV?=
 =?utf-8?B?STl5bWw3RU5USTBGMmZwdW14LzlNUVRYdTFQUzZ5RlNqV21jMVJuVDdQUDZn?=
 =?utf-8?B?L3MvZzJKZENTVlZnWkxFbXRuemZnR3pzTkdOeFBkWkwwUWRTQ0M4aEYyU3h4?=
 =?utf-8?B?bFlhOXNXWjR0aS82dFdGVFJFdTRjSC9DT0ExRU9GWGRneXlzVGhwMWg2b3BB?=
 =?utf-8?B?YWJqZkFsODZRVDcvMnN0bVhqOW9ZamdVNzNvR0RUUU1KTS9pM3VnVFhkTHFJ?=
 =?utf-8?B?Yy9tY0l5WEtMTXA2YTFGQVRFRU00RHJoR1YzalBGWVQvOE9oQnFRQ3FDSHU3?=
 =?utf-8?B?dmh3TVBIN1k4WWNYM0xXWTRTaldGMUpmZ292RW5YbzJCWG4rVm1ua0kvNVdZ?=
 =?utf-8?B?YlNNNGZEeFFKS2JTL2xQN3QzWlFzaFdHaG04VmdPNUw4UUdTSFJDZSsyMFBU?=
 =?utf-8?B?SDhEa1l1RUFHZmVzR0Y1SVorcTlJaWxEY0NzTGx0dXA3dmpwSXJYazNnTUV0?=
 =?utf-8?B?ZWNudStDYWswNDlsamcvSzE2dVczdEh0VnBwajlwMG1tWE5QelBnNXVuM1lq?=
 =?utf-8?B?OXdzM2J1T2dvMVN5alhMNFdkVGtlYnAvQis3aGttb2R6UnpUcndWdHlBRHVB?=
 =?utf-8?B?bXBTN0VqZXJPME13UnZTTFlvQ0t1M1R2Vlo4aEN6bWdIdG9BdStTd1lmV1c3?=
 =?utf-8?B?NHROQTJGTUI0TTZibWhsUlBiZW1wSTJpaC9ydEc1TGhXVkZkRjlHSUdhclBw?=
 =?utf-8?B?T21MblZodFVuOXl2NkRmaW04NGozUzFURUJnakthOXhmWGtsL0FyKzJqeDI1?=
 =?utf-8?B?QWtSaWxDT2x5RS9EVG5Oc3Z2ck1XSXFOTldTYUNHM0lnZnNLTUdCRGpFb0Zm?=
 =?utf-8?B?bmJmSHJOcFM2SkNUdjUyRkNtV3hwZE1MbHZ0aDFWTFZrbWhERW0xSXR6OWc2?=
 =?utf-8?B?SnF6NG9NbHVKK1FSN3BVSU1VeFdjb0w3b21PNmhOOFFoRGdOaDBYU3h2SGhP?=
 =?utf-8?B?UlM2S2xhSlJaZDdhN1pkcGNnY3VsRkdOTEhwODBUN0V6UlhCVytkZDhxOThy?=
 =?utf-8?B?dnVFUm1VOGxRUmhLSk4rSzdFejFqM2dhMHBGcng5d1lNYkhUVGJVZlhwTFdI?=
 =?utf-8?B?R2JHSHJoaUl3cE5aUEZiZkh6L25zUDdOWk5lWDZzeGtzWStORGJjbDRvUGlv?=
 =?utf-8?B?NVBEYndNMjdiVWZJQlU4L2ZaU0F5citlYTdiQUNxb2hQVlQxbXJZcmNNUWhG?=
 =?utf-8?B?R2ltMXRUaXlYUklxNmNEZDYxRzFOR1hqMFFOOVdnNW9qdmp3YlhjUUZVOHBU?=
 =?utf-8?B?amdBZVFjZ1lMVUdBOE5SNUFWSmp2cHJDRXNJZTcxRVIrb1N0Z25wdWFFL1Ir?=
 =?utf-8?B?Um4rVmhuZlRYRnJjSFVkTkhNTTZCcnNUR2tHbUxwVVB6eHVIclFLQnRrMEpH?=
 =?utf-8?B?SjRzdkNwNnV3bXlDZHF0NXdxdGhxSTRZMWlSR2JySWhMRFFMVEl1aVQ5L2FN?=
 =?utf-8?B?SkkySWhMelZnMmxnZ1JNV1c4c1BUdTQ5M1o5WTlYb211UjUyMHJRVzVidmpE?=
 =?utf-8?B?bFBRNzN2VStBSi9uQmJlMkZUM3ppUDBmalNnVjJlUUNpSTNwbnRocXlORzAz?=
 =?utf-8?B?NnJNODhta3I5N3J0RmJ2ZUlyMTd3aUl1MTNiY0VReUtmeEhZYWJORTJkbGs4?=
 =?utf-8?Q?1aptGc6XJkjYS82Y3faONr6SY5vT/De0vhXOM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3468d15c-56a4-412e-c63c-08dbeba2a6f6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5894.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2023 21:33:22.4195
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hz/phF2K/y0Tu995DtTnD3iyBpchAWRO5avIVm4UW7p8SMBUHfGACby/UbcgeHYLkgFa2+pJGc5WVnNfg68cUBrAdIJZw1KodxgQK5koyd8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6567
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-22_16,2023-11-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 spamscore=0 bulkscore=0 phishscore=0 mlxlogscore=558 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311060000
 definitions=main-2311220159
X-Proofpoint-GUID: _PHetifthwSWIAxzEfgeW4fxNjr-7tw9
X-Proofpoint-ORIG-GUID: _PHetifthwSWIAxzEfgeW4fxNjr-7tw9

La 22.11.2023 22:51, Christoph Lameter a scris:
>
> On Mon, 20 Nov 2023, Mihai Carabas wrote:
>
>> cpu_relax on ARM64 does a simple "yield". Thus we replace it with
>> smp_cond_load_relaxed which basically does a "wfe".
>
> Well it clears events first (which requires the first WFE) and then 
> does a WFE waiting for any events if no events were pending.
>
> WFE does not cause a VMEXIT? Or does the inner loop of 
> smp_cond_load_relaxed now do 2x VMEXITS?
>
> KVM ARM64 code seems to indicate that WFE causes a VMEXIT. See 
> kvm_handle_wfx().

In KVM ARM64 the WFE traping is dynamic: it is enabled only if there are 
more tasks waiting on the same core (e.g. on an oversubscribed system).

In arch/arm64/kvm/arm.c:

  457 >-------if (single_task_running())
  458 >------->-------vcpu_clear_wfx_traps(vcpu);
  459 >-------else
  460 >------->-------vcpu_set_wfx_traps(vcpu);

This of course can be improved by having a knob where you can completly 
disable wfx traping by your needs, but I left this as another subject to 
tackle.


