Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3193E776323
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 16:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233468AbjHIO7e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 10:59:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231564AbjHIO7e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 10:59:34 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6937BDC;
        Wed,  9 Aug 2023 07:59:31 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 379Cxkv5021541;
        Wed, 9 Aug 2023 14:58:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=yJSUMtBmXFTpvJRYf42yYWpVCJF+BkfnRoorLbP7SGI=;
 b=gZSPDG9j8nzRq3eaMutimdpFz+ZlWeNQoUbLog3DnCpkPf9gBtKXTFTWMOC9ylqnjFi1
 nAtIa1bjLF60hEsRIxjCzLU2jBomt+HF6DCKET+6QIvDESFy8gaiAa4CjOqLrtpbZGwy
 ahwQFLYaAfD/CFhmOuT2iADhYC41ex8UTUpWpxu1hSe6hknH7Sdv6pztou0wMVULwyEp
 NoJIT9QFvPw4Q+Bmt8RVnb/mELixjf/nEo8CTBvDfv4Jm5oLlzH2ZLHoqitA2/dsHg0t
 CoTqmCZAYgjeWBjY6QQzcMuSPpunuaSqaKvHdSxT1bADSm3TtZdb3juC4FnVvQX2c2z5 2g== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s9dbc90c0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Aug 2023 14:58:35 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 379ERnK5018650;
        Wed, 9 Aug 2023 14:58:34 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s9cvdnsdc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Aug 2023 14:58:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bf3g4ya6k2NgOz2FoYopEdqcI6K9XHn13ArRAb3Gu+wMGUSxVD2OI3cSW6IexAiLJJ3Cbxp/HvRcLjZ1es/3tDTWdIHQgbfYF8yPFjlGIMyM7+d4duZ1LFPNqPBCw3tWYSd75U2xbLcblWNVaMV2emhQkNt7azlf2IPS0Xff3wKqPVhouAp9tgdctHAbr32agTrfrzNw+V18x6HXGBAps0VSVjpcnWQ+IKwFU3fM9fiCr6zCSkUGCy2sV/B6kvbKEcijrbIGLDbseMqTMeNBPtg122UOU2Q7bNEgwaK0nfjeKsfrdIvBAV/tzvryOzWqby6VyPZ8CS9B0jUBwWKy4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yJSUMtBmXFTpvJRYf42yYWpVCJF+BkfnRoorLbP7SGI=;
 b=CKwinJL+g6jU09SXJgwr3JncP0ADdcWHQvtReXCxLHVrA+GRfVbYJwzLQyyhlz19PI1vhaihrWnt20S8y57jAgkKhK6FulU8lfWPMk6hX2wNAchi6EqkoXFVgDx0DsAA95zpjIpowf9xBB68ZdbXTTSh2B/vQwdKxa4mv6aiqJQ/isNvbRRJKH3BMQ51W1etq80vYWi9eal4W+QnQ7bPxsk5ExNKm0Gv7lAhFDukQRDbkLiarRIo/HNSeM9cN2xCqWjw+VN43n+hjdpfCf+R+4RPvBJgJXv0WDxVsA0wm2QrvBWYMPoAblzm6Z14lk/jJy4mbbPtnExvSlOQV0qTZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yJSUMtBmXFTpvJRYf42yYWpVCJF+BkfnRoorLbP7SGI=;
 b=VHIVRWKWYH8DvQHKcMYTweMdtxQGXgHq62JYgPEKCSO86I+GG+aq+eBkpUYUzPmAU9TZ3cD9IIDVaWeJotQMAsM/L9KswEUi0WAROboJ3HUf5Hn8RXlFCM27jx82PLgp5jdTukWBhNqbgeUyzxZWu0jwXFf7RJR6G8ijxTGKvLg=
Received: from DS7PR10MB5280.namprd10.prod.outlook.com (2603:10b6:5:3a7::5) by
 BN0PR10MB5334.namprd10.prod.outlook.com (2603:10b6:408:12f::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.28; Wed, 9 Aug
 2023 14:58:32 +0000
Received: from DS7PR10MB5280.namprd10.prod.outlook.com
 ([fe80::26c8:9b4f:8cd0:817c]) by DS7PR10MB5280.namprd10.prod.outlook.com
 ([fe80::26c8:9b4f:8cd0:817c%7]) with mapi id 15.20.6652.029; Wed, 9 Aug 2023
 14:58:32 +0000
Message-ID: <60e216de-bdb0-00f8-e1f2-93de53c2227b@oracle.com>
Date:   Wed, 9 Aug 2023 10:58:26 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH 0/2] KVM: SVM: Set pCPU during IRTE update if vCPU is
 running
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Joao Martins <joao.m.martins@oracle.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "dengqiao . joey" <dengqiao.joey@bytedance.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20230808233132.2499764-1-seanjc@google.com>
 <c9a1a5cc-7e84-e887-f4e3-8396cc8ce494@oracle.com>
 <ZNOhfMgeBnRwwXDX@google.com>
From:   Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
In-Reply-To: <ZNOhfMgeBnRwwXDX@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0221.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a6::10) To DS7PR10MB5280.namprd10.prod.outlook.com
 (2603:10b6:5:3a7::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5280:EE_|BN0PR10MB5334:EE_
X-MS-Office365-Filtering-Correlation-Id: 111950d1-b8bc-42ac-28be-08db98e91903
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +JgVFhpfIiVDS4F+e7MXMFOoAfn7EqkQCjATUl6OuEr+5yjllyGNmgUvLNb/oP16ncpnS0eLDb7OvFyy6DVUoIbpgKx9Ph/IXi4nXVwgRPbP3t+/5e6xfz5HC+OnqpBIRTlznOy3aE16PT0uSO/p2mCD8FEBikQWMHK41FbH/rVXus+NKDV9gSACyhQ1L3Lhk5CDbRrg+CWmgLtZxS1m7zCv7wH9wE4uizSMCJYrB4IoIqWNXnKFi2sB5hEmnx6fXltWT2p7SAdkgaREzIi9J5Wy6lLAdom/MbHY1OSJyvDXFE4pnDVDak9pguFMFF+x2cUpS8IPtnBUzX1Zail0RmQqnJJaq8TDY9XJ0qDT3W3aGIwMMckEnBaLyK3D8K93STuH7mwu9wqj/jYGp1AP1McEYK02q69eQr5ChQU3BOOZ30atW/3WviEW0Na5ofIUQbZlujgp9IzElwQ1DlGTgJQPXG/vFGG75tBY9eaD+WjjDcXLn0/EZsuKtT+6bzPyMfVJm2VFL0eM88w3sgaE38L02KJoXSPBkupTNzHVycatmC1ukHOvTmAUudU/l2OD4bav6MNmHG1rjyaeiRoqHfERZcEqUhyq8wTwQTW+27DnVQCrefp94ORmO8Yo5TEIZy8BNyiIubQbsB5c6DS4hQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5280.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(376002)(396003)(366004)(346002)(186006)(451199021)(1800799006)(316002)(8936002)(8676002)(5660300002)(2906002)(6506007)(53546011)(38100700002)(26005)(83380400001)(2616005)(36756003)(41300700001)(966005)(6512007)(6666004)(86362001)(31696002)(6486002)(66556008)(66476007)(66946007)(6636002)(4326008)(478600001)(54906003)(110136005)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RUg2V0FzK0s2MndZMXkwN3pLSTM1S2xaR05DT0owVlNQUi8rYi9TcndiZ0gw?=
 =?utf-8?B?MytDbEk2VndXSkNDYXE2dVZpUDhhTitXOVljNFF3d0xGNTF2MmVXaUQ1WENZ?=
 =?utf-8?B?bG5EUmpvNHhNcDBZWUdMdDR2UUd1MkMvSEFENy8ycXBtN3NWd1hmL0NxdXEr?=
 =?utf-8?B?MWRYUFo3WXZLZ1VMc0srSDh2OTFRWlRyeitUZkNDZHlyd1owYjZNNk5IbFox?=
 =?utf-8?B?YXlMOFdIYkxGUHE0LzdmQXNYdWVLYTB3SHhrTFQzRVE3Skwxck9XMFpWTWR4?=
 =?utf-8?B?ZW82WC9SMXFKTkFUenNpWmsyZEhHdEZ1QmVoRUhocmNIZU96dEZlMEdDS1I3?=
 =?utf-8?B?WVBNWmdUb21heHFteS9CVG1MMnkyL0VpS25sWjBZUW5jaGFOaTlBTnFuMHE1?=
 =?utf-8?B?NmNZKzhBbjg3ejdJZnBEeXhMeGlGWXJBd1hNdVpxRWdSSUlQT3J2aVUvQTB6?=
 =?utf-8?B?ZnhDSm9ReVBHazVxdTlKb3laQWN2eEZGVklHb0VsenV5VHFaUXRPRmdnSFpE?=
 =?utf-8?B?Yy90Y3A1U0Rpdks4LzBLbEVmWTJJclU0VG01M0xTQk5ObDltR2R0ZkZXTUhz?=
 =?utf-8?B?eHZ4RkNtZndkbXNzM0N4Q0U5RldFVEZrRHJmeENZNVVzQ295WFNQTUpqVlU2?=
 =?utf-8?B?MlY1emVCL3BQb1VVY2RqaEN3bU9jZ3VQRWNXWnFxeGluc2M3NlNGRGlhbng2?=
 =?utf-8?B?cXQydHd0L1BoVkRRSE1lTnF6M080TUZvSzBpdzNYMmg4bDV5NHBOcEFpc01i?=
 =?utf-8?B?OFI4Nmp6SG51S0FQMUJxdHZJSTBEL0dpVGFrZGVJQWZWbEU4bzRLbjMvOXlm?=
 =?utf-8?B?NE9mM0dQcFI5dDlPS29uRCs5TmJHalVsUHNsWTEwaG5LZWtzSTRhczNSWm9N?=
 =?utf-8?B?Rjh0WmNsMXlJd1RQMEZDUlIxd1JXUjJWTExaUnZiY05rdm9WaTZrWG82N3Vr?=
 =?utf-8?B?alpXa05BbGQ1NFVWcGtiQWFUd1FVeStKd0pTQVRFYmxIRVJrMmdnWEdGL24r?=
 =?utf-8?B?NFBmSEdiRlNPbmQwbGdRVlFrYkM2OXk3aG9FT2MxeENEcm85S1g3S1FrNStY?=
 =?utf-8?B?TVMwQW9WUXo3dEs1ZmF2QXdCQWozdURORzNJUXQ3d25RemNQaGtJTXh3OGRu?=
 =?utf-8?B?Mm1aUDJtYVVPT2hiREhhazVvSlc5dmpWdUthVTBTQ3hsT1UzY1dUajdXOEVU?=
 =?utf-8?B?WUdNb2tQQ3hRbTAzZXdKSW9vRFFyS0tpYTUxYVpHZGRhNmdrZ0xMSHNmTnAv?=
 =?utf-8?B?Qy9QcjZ0b1dPdFpYV2g5VVFrYThXTE1YOVloM1JBWUZwN0RucE1FSWpTWldE?=
 =?utf-8?B?Rm54MjBOeFg0ekU0TWNqUFJIOVZNY2I2SUdrd0hJT0UrUkdrdG1yOXVvcmQ2?=
 =?utf-8?B?cHpqbUtKdk14Z3o2eThFeVJvNFZmQ1lIeVN5VWJ1YXJTMlMzc013Rm8rWjJJ?=
 =?utf-8?B?amVGMmFhakM1Znp2T0FNVGZRZUpDejd5UHd5aWNKNWgxcHc5T0dBcER1aDhT?=
 =?utf-8?B?cFhRRVdHMzg1b2VySlN6dHlsSks3ZEJWLzZ2ekpUZ2VlUXVkYzF6ZkE2cjZn?=
 =?utf-8?B?S0ZLeTZXVUJzWHhsT0w3TjZpcnBvZitjSUxkc0p6ZGNvSncxclFNcjhyOGtl?=
 =?utf-8?B?R3JmcWtBMGd0bGhxNkhrNWhGTE9uVUlNd1pjanVHSVdyTTVDRGJyZzd5RWZs?=
 =?utf-8?B?RVdWbHFmS1MyZ0NpUnM4dTFmV2xyOHZ6UmdEQ0JNS2c0VGNSaWQxZE5hQ0Fu?=
 =?utf-8?B?Ynd4OElMMC9TM3JWTHA5NCtCZVJSN1ZpN25Lem5jRkVVaHlyRHZWa3FuWG0x?=
 =?utf-8?B?V2Zqc0prclZ2V1MvQU84Z082bk1hbWpTUWp6TXU4NzVXbmgxUVgwRUVWejlN?=
 =?utf-8?B?NHhTenlTUlhlOGVVNCtxQkFPY2Nab2k0RnpxdnM5Q0lVK3hEL0svRXF6Rnhi?=
 =?utf-8?B?ZUVzQmdLTDVhbmROM2VWc3ZWQmpMZWwyQTdjZkdOaEdlSXZmdlFMdWtGQWdr?=
 =?utf-8?B?M1c3TkpadXVXL2xGYjdkQmkzZXV1dVhCWktoVENFR0R0cEdNU0ZMMExwWUJw?=
 =?utf-8?B?T0lWNkpHcUhaZW92dktaUENONXdBZEI0OW9XRlBUZ1gzK2twRlphWXlqNDYy?=
 =?utf-8?B?NHRLb25oTWJoVW1QZTRMTW1MWXpDb1daNWR6d0t2M21xZi80Sm16MXQvUmMw?=
 =?utf-8?B?VWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Ie1UEkpx02K/vorWcQIne6yql27D5j52u5LTa79ANql5dKQm4iUmBZqUoTIjOS3Tq+rIBFHugTCyCnPKGiuNFEiPLAXTmkCIb+YGGZqtECY3rMzXv25ELPd+XNpUPDW49nHcA6YekmwuPejJKLXuYAH3kcBBMezry+N+UnSqbACXf+OtYCrw3lz6kZhMWs0pC0fWk0Pq7aRedNQaEFQNZreyi6wGM7HRe2L7Q1rjuMjFZsZXhHtn/BQlcMxwfQghn94xpV6diqMb5XCCT0ruzy0wE1284w/N/TQDK7/1CP8UGZELqNQ9tOI/KGdHbm1anN2XTdPf//e9eTMkMppllBrAJbFN0kGAhj3MdNdc8FRanHxSrt8jnMh50WtEDYmf9Hh/9ZCi94mQaILuOVYtc9u/T4k2GGBhHKnsMzyOOdEotSChXkz1Jx0Krx5xIw6GzCNzEadtpLgu1gaYtXIqwtMtoPcJXHgCIcS9MZDU9fsr/RYGIHwTnb0XJcG/JjUWDVLy9u1yNllmb7LyXBCxXKuFrWgyNxVtg/Ma2wL1sJpXQ59LZj19ATNf22Yye9dLOyXtbNJI+khIHpIVUed42ezr+WuWI74WMxu8BCm0nMmCtv29LBpX4VWnuw571nixJJlOarBXty6aHx71XfbkD5AneFuJIS4oXQYMr7Aqvx5YpAI5G6xFWwPFaPlromgI/d6h4WgQHOPPNBw9ptitbAVcCL+UnGM3aUhbYjQvEatxhJ53DKyLODXoLE+LicanM5EJKYTP3KbwqwVJeu1JY5qEhfidDHEO+VhVJUAWoY5aIbdvu++h5d2H8QCNQwPGOHxwSpnlzv2hZ9ngWTw2/JFrGqWPPnzCNGWaoJl4eH/bnGg8jgdz5qaTmddp0t97
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 111950d1-b8bc-42ac-28be-08db98e91903
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5280.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2023 14:58:32.1678
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X5mwZWYpAoOwtUvNvW0ErP86wZDPoNeQK6b7/I0L32KFc8wb62E9CNkFBZ2EAQ9oAhCLjnL0ZvGlWzAdc0+Hwxx0lvC+DP3PZQPvw6UC+0g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5334
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-09_11,2023-08-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 adultscore=0
 phishscore=0 mlxscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308090131
X-Proofpoint-ORIG-GUID: k6m__LFZvC_6T8O6rMF0G178cJJvAcNP
X-Proofpoint-GUID: k6m__LFZvC_6T8O6rMF0G178cJJvAcNP
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/9/23 10:23, Sean Christopherson wrote:
> On Wed, Aug 09, 2023, Joao Martins wrote:
>> On 09/08/2023 00:31, Sean Christopherson wrote:
>>> Fix a bug where KVM doesn't set the pCPU affinity for running vCPUs when
>>> updating IRTE routing.  Not setting the pCPU means the IOMMU will signal
>>> the wrong pCPU's doorbell until the vCPU goes through a put+load cycle.
>>>
>>
>> Or also framed as an inefficiency that we depend on the GALog (for a running
>> vCPU) for interrupt delivery until the put+load cycle happens. I don't think I
>> ever reproduced the missed interrupt case in our stress testing.

Right, I was never able to see any dropped interrupts when testing the baseline host kernel with "idle=poll" on my guest.
Though I didn't reproduce Dengqiao's setup exactly e.g. they imply using isolcpus in the host kernel params.

> 
> Ah, I'll reword the changelog in patch 2 if this only delays the interrupt instead
> of dropping it entirely.
> 
>>> I waffled for far too long between making this one patch or two.  Moving
>>> the lock doesn't make all that much sense as a standalone patch, but in the
>>> end, I decided that isolating the locking change would be useful in the
>>> unlikely event that it breaks something.  If anyone feels strongly about
>>> making this a single patch, I have no objection to squashing these together.
>>>
>> IMHO, as two patches looks better;
>>
>> For what is worth:
>>
>> 	Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
>>
>> I think Alejandro had reported his testing as successful here:
>>
>> https://lore.kernel.org/kvm/caefe41b-2736-3df9-b5cd-b81fc4c30ff0@oracle.com/
>>
>> OTOH, he didn't give the Tested-by explicitly
> 
> Yeah, I almost asked for a Tested-by, but figured it would be just as easy to
> post the patches.

I was hoping to find more time to test with other configs (i.e. more closely matching the original environment).
That being said, besides the positive results from the validation script mentioned earlier, I have been using the
patched kernel to launch guests in my setup for quite some time now without encountering any issues. From my side:

Tested-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
