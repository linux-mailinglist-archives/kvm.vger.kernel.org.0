Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A1C27D8A62
	for <lists+kvm@lfdr.de>; Thu, 26 Oct 2023 23:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232027AbjJZVda (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Oct 2023 17:33:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230271AbjJZVd2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Oct 2023 17:33:28 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CACECDC
        for <kvm@vger.kernel.org>; Thu, 26 Oct 2023 14:33:26 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39QJsTj2023251;
        Thu, 26 Oct 2023 21:33:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=TTIjonb82ipyb178dI/df25fSx/Ewk6TGBps3nLg1LQ=;
 b=bt8yk9RMJc7FhT5Ytv4xXrt47NCCk+9asJT1BFuRFD1ZJaOAj5mHeqrkbp9DNMoSNrIF
 cNgkCgfwdT9/mZY3CUc0c/afFLEOp2xm37IjTwyHVQ2hDnpBRE6R+XEtVqKk39+2S02V
 E8x0aSo23+CB6MCv48QhHLGn35dDUQ86tLXLuOA4+8mUqeCXUhWy7mQEvZyeg2pEeQf5
 biIf5JOg2PtncgfzzbZx122zEy8WxCD6ITycn3pR0dmd1XrfA6eIH8KbweZsgZpsM4dK
 otk3dD6uFnMOQIwUL1bXA86/pLUHstKF+LK2xxS7grmK5KiJE0yE90RoCd4vjxGiMXTh +w== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tywtb89ta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Oct 2023 21:33:13 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39QKmLWG038116;
        Thu, 26 Oct 2023 21:33:12 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tywqs5cq2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Oct 2023 21:33:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c4qYbcEhvCMUsQ49lFjXUonmRjTFlzCsz7P0YXr9W8WqSMBInrZ3NaDe6YdE76f4kblPtnLU7vqDb94XgLzIveskkMcejNlsGj70x/ZxKuse/ibyJICL7xRMugZUy0OPu8ya5AQcKj2RNSlcNwkd/4mqszcqdC/nBOXhVUujC6yWMxxKjqNOencIdxg9I7d67G2A2WIVRCoRf4Lyq3Cq6N3dcWZebfj6FMFQ/Br1hzxLGO8eg8pE1tFZ8Pm9Wp1PNPBk6J7dVBbELVIgayv6mWSRcTx72itpaU9WTiTQdKTtdmCVCNqI0rDwM/g+ZiJaZIAMLi5KKQry1IvoZuxRjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TTIjonb82ipyb178dI/df25fSx/Ewk6TGBps3nLg1LQ=;
 b=Y6wri+mORgVD43ORjF2IiBGMHLFXuZtuVDL1h8Gb2G9jamUGKv/9rEZHEbBM1wxdqQpwBXtFqX0GKXq6z04MyjVu/gpZ/CvOwKtcoxSejjfpLrCwgqTc9JBWFi8FoLhvFoSvwNVLSPrsKB4OrjHyXLpS5xKLliL1qWJ0Ungkt2Ygey7MMzblfoSe6A1ooCMOPa3g6r4vTnIMp0mIBPqz5gduxDsDVZMkfGjncRTsECBZWcJdM8aZvb+3pNf3SV+eN3zSMZifPh8J4xTE/dz1SxtbwhFd7kmpknADoDD0gSWfLCq7bUeo+81mkVzO14QpPnZfktEnWvolC/zaUrrgug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TTIjonb82ipyb178dI/df25fSx/Ewk6TGBps3nLg1LQ=;
 b=VYS4If0W/YF0bzCwLoL38roPJqHoszkj/IVqH2t6pP4ESRljn1G+TZ2Yr+5e5ipO2gCRtkzKvehslhiVvIs/d4mY5+mJrxAqGVh7P9FKwNbIV2Ketm2T3rZVYtdSRrIhOpnJnY2OG0T/L+ehcqAD5Qg4VkWjy3fuoyAeZdyfkHo=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by CH3PR10MB7354.namprd10.prod.outlook.com (2603:10b6:610:12f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.33; Thu, 26 Oct
 2023 21:33:11 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::afac:25ec:c0ba:643]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::afac:25ec:c0ba:643%4]) with mapi id 15.20.6933.019; Thu, 26 Oct 2023
 21:33:10 +0000
Message-ID: <a474776b-74ac-07c3-95ab-8438aae7de4a@oracle.com>
Date:   Thu, 26 Oct 2023 14:33:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] target/i386/monitor: synchronize cpu before printing
 lapic state
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     David Woodhouse <dwmw2@infradead.org>,
        qemu-devel <qemu-devel@nongnu.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Thomas Huth <thuth@redhat.com>
References: <870c998c450ba7e2bc2a72c12066f1af75e507d0.camel@infradead.org>
 <b6b24f07-e63b-cb07-ab74-f9a178bde91f@oracle.com>
Content-Language: en-US
In-Reply-To: <b6b24f07-e63b-cb07-ab74-f9a178bde91f@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0020.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::33) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|CH3PR10MB7354:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a82c237-69ad-498a-64ae-08dbd66b26f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bTdqY6Jbha9FOrJX5b7HDke5nsEQVqKvmGGlCHue1ydPZhFqUlmqXWVhtdi8UwhJJk8KxUsznI1zisKoBMZYFWmk/Dt77I24IsexQnxLOdmCeHEJMPsMjOfTOHcnzidpwZOq2YWOXBzsQACQBhr64WqM1TYptHM49+gREPD4zQXXctdF1VKcOKf5VHcamWQduzSM1Yf/lJMh7evNuSPqIVK6zhVsd+F8J55Be+/Q+HMFtAB8ZuphmlXzqYrZiGy9Dq1kJLcEPYpkgc4OuiZwqzFD/5zv0TpgnHWOTg6cCHzifDKyIgEjOd24EE8qdmaD3xlA9b3KeX/dahk47KpquIVvgGcHxtdmuiFIKAL4n0dpc/ZbsrhRw2hAKULh2xaB08b/QERHKfVHwE7zO5O4lpswq7tiP32tVK5sLfIo7NXc4jHjoz/Mi1jDc/CKmUCp231Bqqr/6DLPsGrzQcEFkViZN49dAM0aRPpS+u/p1P2+eyDhc92ryERmR4mu/ql/083V7+FfH9RlXYijUibiOTFBnNQJDx6YQr680zIGxg327yKdoiU55UA2ROaQ1ssyjSSxYNOQhed+85LCgF118/Q8hyxgfqr9AgpuExhASXPUtDIUusTaYVat213Jbsl4Xkv7zToqU3zU7obOkkcS5CjjKE6PRhEZ2uswflAfMUaH7tB3a9hFVV1O/S37DRPj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(396003)(346002)(376002)(136003)(230922051799003)(1800799009)(186009)(451199024)(64100799003)(31686004)(8936002)(44832011)(4326008)(8676002)(31696002)(5660300002)(26005)(86362001)(110136005)(6486002)(41300700001)(2616005)(2906002)(36756003)(316002)(66476007)(66556008)(66946007)(38100700002)(54906003)(478600001)(6512007)(6506007)(966005)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M0pSeXFTWjRoVEVYTWl0ZmJFR24xbU9DMCs5ZWFsL3g0TGYwbFVMUGdRWWg4?=
 =?utf-8?B?Y1BvS0hHMURtaTRpbENUeElWN3lZSE9Bc3dXSExlNVI5YTF1MXF6TkJrcFJT?=
 =?utf-8?B?MWNyMzJ4VWpCTWo2SEkzVEpUS09LOEJBa3NCQWp2akdIRlVTK2poQSt2c2Fj?=
 =?utf-8?B?SW1HSVFUdUU5QnFkeEFUNXRQdXZBbFFQMk9PUHIydkd6aTRYclAzZ0c5cjB4?=
 =?utf-8?B?NVdCZVNtNG4xNmpJZi9uZVdZMEczM2VQMnF4ZkJxejQ3MmpFNHJkc2FlcDR6?=
 =?utf-8?B?bis5VlVDOE5rSHU0L1lGYkxuMUpqSXYwYTNDakpreG1FcEgycmZvWmVhK2g4?=
 =?utf-8?B?K1pOSTBUdHd6WDR6N3dlc2xIZHlnRGVHZ3JoNW9mOE1PZkRDdmVFeWpFZ25l?=
 =?utf-8?B?b1A5bm82N3k5WU9FOUZnMGtUS0NyTVJsaUl6bHdBKzhaNXVNYXFRUlBJREJz?=
 =?utf-8?B?a0ZBMFVSWmZ0RjhqODFDTFdhdjZXRGIybHZ3bXRQK0c3eXB6VHJYdThIVG5O?=
 =?utf-8?B?c2NNSGUwOGhVSzZJWE1ZdUtwL01VN2ZjZmlBQjVHaEQwRXZicm1ja2NaMVNo?=
 =?utf-8?B?ZTNvNnBwUTBhRngyVk1pbVpwTU05QS91SndGeUhLaENob3JIaU1leWdrV0w1?=
 =?utf-8?B?MUtZa242ektsd0xzQUdsUnI1bUNSWDBRb1pTUEhyS0JPMXpKdmNsYUkzTW8r?=
 =?utf-8?B?MndQRFRtR2xhMWVSYVBpSUZ6SURUM1QyemRwU2phRXhCenNTVXN0YU8xK3U5?=
 =?utf-8?B?LzFqNVFHd003TUwrY0pjdnh1TGJ6cEdTQVZ4eVM2RkFVSnBhTG5DRHdSYjBQ?=
 =?utf-8?B?cCtLWDcrT2JNeWFWS0RhQmpTOGtYN0E3K0NiTjdPQzM4dDRtTmROQU9JNjh2?=
 =?utf-8?B?WW5kYWNoZFZVbldwaEh4RngydGgxTDF2WnZheGZzZXU1NFdLZTVGOThzK3Nk?=
 =?utf-8?B?Nlo5OE1NRTJYNGhEa2RTMlo4dTNTSzNFYlRDM0VsUURiWXJzZ2RVUzZtM0Rh?=
 =?utf-8?B?aU5hdnVxaVBmQi9HVVpRZ0w2emJwYmpFZTcxNHQvRWF5bEFOeWNUTXdwcGNC?=
 =?utf-8?B?OTNLZkhrSnp5OFk1UUZCeHZwNndXZTZDVHhaQ0E3TkVQZy93d0doZCs3bnVv?=
 =?utf-8?B?bGoyQTMvWmdZUEIxa2VRU3hZMkJmdHF5V3h4Y0l0c0JpWlRDNEpPYWlNcVFL?=
 =?utf-8?B?ank4TkxHalB2NUMxb3lzVjJJWDRzRnJoRXVsNERkMFBoTmdiNG4xbkFJNUgz?=
 =?utf-8?B?U21TVzBqZmVBMVMxdWxVSHZjdWlaM1JEc0lXZ3FqNW1meUlRcjQ4U0IxcUxG?=
 =?utf-8?B?NWJxbllERTJ6VGE2T0ZyU1VTZXR2VWxMMCtsekhCbThNMnFLUTZxTnBBbmM2?=
 =?utf-8?B?SGxYN21wVUZ5Y0FXU1UwQXNWeHZVdFU3c1Q2RWMzZnpJa2R1cjRTd1QvZWxx?=
 =?utf-8?B?RHVuTzRIZVVYaFJXTTBkY2FjOWM5WFBkeUF2YUFiRWRVUGphV05FUnd0VUxt?=
 =?utf-8?B?Vm1FSDNLNnQ2Q2t4dllwMkJoMDBPNXR5VW5Vb3A4WnpwRURLbXRreVRILzVp?=
 =?utf-8?B?cU5SN2V5L0tkSTBmNjVzME1rZElRUXZzbnlWZ1Nacy9Rd0RSN25INDhFNDVO?=
 =?utf-8?B?V0ZiSUlMc0pYbE8zUUJmL3lLSWd2SU94YlZjZnB6d21SREZRVSs1alJIdkIv?=
 =?utf-8?B?dVFLWG1vMEhsaytmR0tOaDFCaVBHY3d0c2J1U3dVUTZ3cmhGZ3h3aWxONHl1?=
 =?utf-8?B?cGRUS1N0TGxMUExGRmNxcDNGVlJpVTFqbVF2YXNzNUM0NHFaV2gvNWR4VUpD?=
 =?utf-8?B?NHg3QmxuOFlLdm9xdmlYbnMvRVViOG1uczBhUmt2cytDN20vbExFODc4RHRM?=
 =?utf-8?B?cnZpeHN0L25idEZHQ3gwVDN0Tnk4b0tHaVFtNTU5UUdiSkpZSnpOVzJKWUVG?=
 =?utf-8?B?NjUyMXh3eFA4RlFnYk5CYzVWUGJDK2hBMGV3dzlqN2VXaEt3M0c4ZmR6NVVC?=
 =?utf-8?B?TTlwcTRJMEU1eVhXK1c0bnYrVUNrd01keTBpdWRab2xKY2kxOEpEeHkrMnUx?=
 =?utf-8?B?b09ZMElxd3luZ0hLTGZGNGZGU1psOU5CTURHektWcHRqUXV2eERtbDcvTEIr?=
 =?utf-8?Q?n3qGJSwxy8l8A2nEaW72QYroW?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 4VqLhypQ4AsD6Py6T7USwYxW6AFBRYVb3zDTiC3Eq0A6c7lth92zjOg+1O3XM15JYzTG3CMXsn1OiTl6BIbU0NrX6+geMyDTrS3P2JKOq8aclvi9cGMRgGCe0MXzHEgKjzBz/cvACHklCL5j63+bcXwCRRXBf/MrQDDy0l8jVESlFtAKJ6/RDkFq4nKDW/k5jteYeo9bFrf7j86pCkZpORDyuPVEpsEK85wNdQD/DJDyk1eio93xRWHTsFm/LNV1eCnMgT+Qk5ohWJkC0F7iXi0CQCFwP7NmLo/8c9dZUzZQXx1pJhZY4aoqjNGcdGppnZ0FOWX1XL1w776/Z0Qv3hWm/wzzBtUFGg6I4JY7guazGUBzuHyNzjo7cHHZQJ89sqhzBGx9cHj1T83cASm7wCBGySxogzJEFuxahdp4S6famfY6A58NWiQmF3YfGhH2vCxGZcrE+lBCfJNil3JcvqJpHKLkj0IGnqVXolN6X2OXeInD/2xSqmdqlmeWa3Fd85D9bfyRBkGGQLmOzl416b8opMY2Ep8HwNqQ7zd84OwdY55frf9HWpk4MptIZOaQz/EGnADifKmOfybRPrGueLaIG1JcK7VN8TPPGyUhDXR29BOY7QpnXpaNWx64s45Ock9EdBk5GruygH4B1KTM2gGf2U7EPaL1Hgs5EzFfAOVAi4q1HmFqHiBf3wbEmKJYAxNTRcSCnjAolYxiJfN4Jc5M3ZprBpRmIuQKVJE7L99dXgXj/5ZTVYF90933f0ugK96YzNYX5A8AXl18FxLbByy9Ni6/DKSjw075dA8RLCKQ6eaiNn3qhoMv9FOHQiDQ5vuGYO6RtruHlwUQvlH78DUuUjQaEdxQxYsnFr3zNLnW6OL/lhsl3kRLeCkDfim2Op6kCfHa2pGPMts1eidTSg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a82c237-69ad-498a-64ae-08dbd66b26f2
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2023 21:33:10.7948
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tMSY6ay2HHXegtzuw13hIwHI6WieMz8zNrU/iMUJmL/hwuhtB9NXVu9C2EbNdzYEhCmm7IlBWhsGQh+1NUH/bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7354
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-26_20,2023-10-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 adultscore=0 phishscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2310260187
X-Proofpoint-ORIG-GUID: YxYxhs3_kJTgN_CHwE8lhehCwo3zRG4U
X-Proofpoint-GUID: YxYxhs3_kJTgN_CHwE8lhehCwo3zRG4U
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi David,

Thank you very much for the Reviewed-by in another thread.

I have re-based the patch and sent again.

https://lore.kernel.org/all/20231026211938.162815-1-dongli.zhang@oracle.com/

Dongli Zhang

On 10/26/23 09:39, Dongli Zhang wrote:
> Hi David,
> 
> On 10/26/23 08:39, David Woodhouse wrote:
>> From: David Woodhouse <dwmw@amazon.co.uk>
>>
>> Where the local APIC is emulated by KVM, we need kvm_get_apic() to pull
>> the current state into userspace before it's printed. Otherwise we get
>> stale values.
>>
>> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
>> ---
>>  target/i386/monitor.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/target/i386/monitor.c b/target/i386/monitor.c
>> index 6512846327..0754d699ba 100644
>> --- a/target/i386/monitor.c
>> +++ b/target/i386/monitor.c
>> @@ -29,6 +29,7 @@
>>  #include "monitor/hmp.h"
>>  #include "qapi/qmp/qdict.h"
>>  #include "sysemu/kvm.h"
>> +#include "sysemu/hw_accel.h"
>>  #include "qapi/error.h"
>>  #include "qapi/qapi-commands-misc-target.h"
>>  #include "qapi/qapi-commands-misc.h"
>> @@ -655,6 +656,7 @@ void hmp_info_local_apic(Monitor *mon, const QDict *qdict)
>>      if (qdict_haskey(qdict, "apic-id")) {
>>          int id = qdict_get_try_int(qdict, "apic-id", 0);
>>          cs = cpu_by_arch_id(id);
>> +        cpu_synchronize_state(cs);
> 
> AFAIR, there is a case that cs may be NULL here when I was sending the similar
> bugfix long time ago.
> 
> https://lore.kernel.org/qemu-devel/20210701214051.1588-1-dongli.zhang@oracle.com/
> 
> ... and resend:
> 
> https://lore.kernel.org/qemu-devel/20210908143803.29191-1-dongli.zhang@oracle.com/
> 
> ... and resent by Daniel as part of another patchset (after review):
> 
> https://lore.kernel.org/qemu-devel/20211028155457.967291-19-berrange@redhat.com/
> 
> 
> This utility is helpful for the diagnostic of loss of interrupt issue.
> 
> Dongli Zhang
> 
>>      } else {
>>          cs = mon_get_cpu(mon);
>>      }
