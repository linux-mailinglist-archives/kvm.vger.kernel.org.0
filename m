Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3130365C5D5
	for <lists+kvm@lfdr.de>; Tue,  3 Jan 2023 19:13:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238779AbjACSNe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Jan 2023 13:13:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233595AbjACSNV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Jan 2023 13:13:21 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA6AF10FC5
        for <kvm@vger.kernel.org>; Tue,  3 Jan 2023 10:13:20 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 303G4HkL002359;
        Tue, 3 Jan 2023 18:13:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=zHLbs33CfePVP6OYQZILA3OkkB6FXtWnQrldjFI99RQ=;
 b=BmOiGfsPC/0LKUlXBdqotAhSd96808LDhSR+CjLhvGdFKKCeNVaXHb7A1TRwVR6km5Yu
 nX1ymQ6lNZuCDiyzdxubDEfvGpiVO9Ib+iYDj8bARqRHoKlE6hCviBRmHalhiw3eW343
 DvrjYsqtWf9k198J2a5uirS3OScGQuDiSy32ChsNmjxYya8wJDpTzCPDYa22Ow5hZFEu
 jKo/K5h9daFGdjNFLM3YdG3RhjuSFJlxO2ozPTbLAT4Z54FSHixMOtR8XYHWMJCiyvhR
 bqg/n3BHG2Fheh3O3nZXQainUkGhKOqfYRv8mUN3AUb/JeyXUQ89tj7xC3XnnIirIQv1 UQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mtdmtmne9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Jan 2023 18:13:16 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 303GeCco000442;
        Tue, 3 Jan 2023 18:13:16 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mtbrcdqbv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Jan 2023 18:13:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GdVPH+Fnm+98r4gruKzOu2STqiz1YY6vtV7METJEOCi/rZ8yhJRzqog3s1Xi/OxUtX2eLar/Tiw/RQPBhxqoDvwptsvIRZIvfEVCAK9iJBS/yBdqEayzGcEq4QMrXurob9nuDFEK+tJuNMIwmdxo38XPBB7CeSrfPaNcoQElmRJCY5u3TxD5gMvQkodblzH2aVKuZY+5oRquJgx7dagDaRmpdn78CDS/Sslkp2Vx0As8SoFhnU4+lHxcBNPcjj5B5rmEtrs2oHmCeWm4ZDFId8oQ504IYqy+4yWsjcs9Bl3O0jcp1jtbssue04dbOwoTsmI9NM5pHBNPMaZ6HCLylg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zHLbs33CfePVP6OYQZILA3OkkB6FXtWnQrldjFI99RQ=;
 b=IJfazm0axxAOx293hFNlOdFfR65i6B1DVm7YTh/WvnpmxIPqfIzRLLvoJB9bsJH+aZPvN/h1Qgy4xaCkKY62uorUBFOVzyICHb6ZGlc5TSF6C+ysyaZ8IEIhNhIFVMxC7l4OaobJIQQGz7RFmusAgeoUYCZyiSYtn9DizptmQkAyUAcpW0vnm5+PhBnfafoDQ82J3T1rM8M8R4qMHFLS6mmEqXnboy6bfWi+Ke3JxLaAdXaXUyToJQS1t+8TorDS8YtSlNJ39HEaVK/Xb+knMqnbCKUsXefWjvMfrbE/3ceqsDDVCvDVdsZ7tOg5OhJ55SJVf9RHSMkYWrJKXqf7PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zHLbs33CfePVP6OYQZILA3OkkB6FXtWnQrldjFI99RQ=;
 b=mokPRvztuP1Yj1qCWX0VLpd1ykxxJbzXmTDj7qfnS92XX4WpPrDxeyAQxz8VHXi224R7gfOmXmYdq9E7oC34wBC0pTMM2xTQgtB/3R0d9jvYvld96TtvtWaio2F5IgYx5GNyiHTCOjRCwNEIqFMtCcQzNcQaLDL+F+qdAN2SPL4=
Received: from SA2PR10MB4684.namprd10.prod.outlook.com (2603:10b6:806:119::14)
 by DS0PR10MB6946.namprd10.prod.outlook.com (2603:10b6:8:140::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Tue, 3 Jan
 2023 18:13:12 +0000
Received: from SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::3667:7f89:cdc7:9cca]) by SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::3667:7f89:cdc7:9cca%3]) with mapi id 15.20.5944.019; Tue, 3 Jan 2023
 18:13:12 +0000
Message-ID: <74b67580-7b4f-560d-19dd-95b376122595@oracle.com>
Date:   Tue, 3 Jan 2023 13:13:10 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH V7 3/7] vfio/type1: track locked_vm per dma
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     kvm@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>
References: <1671568765-297322-1-git-send-email-steven.sistare@oracle.com>
 <1671568765-297322-4-git-send-email-steven.sistare@oracle.com>
 <Y7RIEeQW5L+qFt9a@nvidia.com>
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <Y7RIEeQW5L+qFt9a@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0169.namprd13.prod.outlook.com
 (2603:10b6:806:28::24) To SA2PR10MB4684.namprd10.prod.outlook.com
 (2603:10b6:806:119::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR10MB4684:EE_|DS0PR10MB6946:EE_
X-MS-Office365-Filtering-Correlation-Id: b5c8e996-958f-4e83-a9e5-08daedb62d65
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sJZvebZaaehA2e2ZJWj3h0GOVIa96RFoTxYoCXgBh/voYkc6jqHSAiPexGSOim+Akt49vIsujNrKZPTaiEcJXiHTdkNj/NG/vUC0YQBRPcOpOtyFTCfn8VC1DgzXGfaIrKcj17yJqCTabfSSP/yNT2fr96+1swy1l/18PLC8QzYtYRCv0DRdn+C0Qmnw2Es5NILL3+om+DOMLWYYplPBtcCEzi6U56a675FJ2ZQu3mOIGF16giPkK7Od2HIQ2hN4lAim1QgJWf46anuvfo61sCooUmi0XKv9gMNkpO5gjEmbvznQ4VC6aHn7N0BLjyckyaG6hazklqfSJXkjyXfqhslB3V/zl1Dd5/BxWp4NuBcskSGlocowItoKe26UMgM+K/SwEo/mwnw+QTgBADHljTebg4jL3GA1LLF5J5Cs51akBlyv9TK6+ikJThWkkYOvJO1bFZxM5rOTTewckZA255nUiHYofinzC+pEB8Bd/SWYbktnHO9zBhXctoEig5ENk4SyQ0JKczYqAKX6i2AfvRYYO+9n0t8lKQqtUffpEXfw8dpcq0mUeHvU7CNnS9vzArWcvAqNXl55fYRpfGZqozNRP+CCCrMFLMdhmEojZjFwddwVXwuqCe9+KrMoZJPy27SjG3TCeu8i+BrHSnYk/Mxley/N28HLaG9+mjToHr1evkq2OkV/x4TREn9fytOAih6TPUKq01/Sj4U6i9lHrCw+5bnDntu2+Aq5oY9mnMsn1hGFLA3IA53zfJnpHXw8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4684.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(136003)(39860400002)(376002)(366004)(451199015)(38100700002)(478600001)(36756003)(86362001)(31696002)(6916009)(54906003)(316002)(31686004)(6486002)(2906002)(2616005)(44832011)(6506007)(26005)(66476007)(83380400001)(41300700001)(4326008)(66946007)(8676002)(53546011)(66556008)(8936002)(6512007)(186003)(5660300002)(36916002)(22166006)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OU5jRG56cG1BUjBrbjJiQzIzYXdtekNyV1ZXNVgwRVdBeHBERzdkRjc4Tm8r?=
 =?utf-8?B?aU1lQzc3SEgzaTIwYmUxd0tEV0hIRXRLRm9iQ3hLRGtnZFZURkZrSHFLZHVp?=
 =?utf-8?B?YVoxMnQ4UzVmcFd3VlZ6QXkwVGRCM1JFMno3alRtNEdpdjVyN1JzbkNzTEpw?=
 =?utf-8?B?QjlDazJXbWF0UjZ0SnUwclZlZklkcHk5dEhDQjNJeGhJWFVoUVFsY3FBb0Ry?=
 =?utf-8?B?L1lTVm04NVVsb3B5Q3JueGlIY2t0eTJMYS9ZdWpuS1JxMFJOZ0ZUdVBnNjVH?=
 =?utf-8?B?cFpsNHBOWHJDSGFWNld0YkRzOVJtcXhvcWl2cFY2MjZFQXVnbm9aUFZPQUpi?=
 =?utf-8?B?dXhLRFhuM1RiWmxXUUM3cVhrWTRTM1RjTXJ6Mk1hL0hzZnhoMXprR2xZeVJL?=
 =?utf-8?B?UlNWdzcwZktWT0owbTFFRC9YMTdwNlRNSWVvYXVxS0hpMTVCNHBpVlFmQy83?=
 =?utf-8?B?b0RkQTlyWXNUaTNWT1gwZFlkVlVWZDF0YWVqdWtENkdxQm1kVCtzNkZTd2hx?=
 =?utf-8?B?emc2YjVVaG1tWXFESnlDL2NaRFF5MWd4cERteHk1ODV6ZlJPNUI0cTJ6Y0JE?=
 =?utf-8?B?eDkzWUE5NGFCUytramFhOWpaWEo5NXhNbHc5SWZQOUZNRGxUOUNaQ0huRTFn?=
 =?utf-8?B?Q3RCREI5WXJraVdtTXUrSGwvb3RlbjBqdUhvWndMYlJUU2Vad2NiZkRxeC9h?=
 =?utf-8?B?VWcwd3M1eVZHSm0xd2ZHV2pFZUVqQkw0NmcwSitGL0x3b3h2amRKa253MUpx?=
 =?utf-8?B?b3JHZ3dWN1NvTGlDdzk0bXdaUVdBc09mcGp3RTFXb1lZZ3NpMkJEajk5emhC?=
 =?utf-8?B?eFAvcmFDaDJOckRYQjV2RGZkVk41ZzlTOG9DTGRvMXJVQ2NqSmRUeEg4MU1W?=
 =?utf-8?B?a0J3SXZ1dVljQWFIREZVRjkwTmtIQ0VMeDcraW1VM1dyUkdrMWs1NSt6M2Zu?=
 =?utf-8?B?N0dPKzZWNkhkN1dSN0JyUDZZa1FBRDRabWtmRDdNWUNUL2VKcDQ1a09sdnFE?=
 =?utf-8?B?cWZxZzNUOHgreEtYZXFwYUFUL2dlZUhRU09KbUR0Z3Y1REdpRDZ2eFNFbzR6?=
 =?utf-8?B?UGNlWE5NRFVxeHV0U0kyTFliS3lyaEUrelM5UDFJVUlubC85ZTZWRFRRU1Rh?=
 =?utf-8?B?WlNQTWszdWR5eW9lQTM2RnE0K1RyOVFCbTNJRzJZWmYrNktWanlDcGtRU0ps?=
 =?utf-8?B?cGpNZUtZdVVLbTNvazdiN3VUTmpvbGdCQkhJV1RTRTVYc2N0ZUIwQmhFbWho?=
 =?utf-8?B?dUJyTlpEZWdJMTRnNkJ3bUoxd1M1VDhCUE5mazNicVVNVUpya2lYellLODVM?=
 =?utf-8?B?RDE1eGlEZkF5WE9aWmI0UDFCQTBKbVd2RW1USWlXSkgwK3g0Y3lwZkJGdXBB?=
 =?utf-8?B?S2ozdDN1bzBKcXFxdEg0bFd2UTFTZXN6Z2V1MExQQXVKRmtvTWQ4QUtDNEZp?=
 =?utf-8?B?NVVpTjkybUVZK3RUUk85dW5NWkZENno0dVVWc0xxU2R2MkNsS29aS0ZIRS9M?=
 =?utf-8?B?NGYxU1loNG1XRUxXb0NCV2MreUk4aER3SHZiaXh4SFMwT3JtK0hKNXVCZTJi?=
 =?utf-8?B?eW1rYWNPQXpQcloyWTRNSlZZZG1XU0hCWWl5TjV1YXhTUUl2UzVhWXRqRGtv?=
 =?utf-8?B?YUJieXZLYjNHTkRiK1M4UEFnR0ZQWDVDcmVGdWNpcUROZVozZDNIalNMckI5?=
 =?utf-8?B?TnR6b3FiN24yRzBsT2w5VlJSRkN1a1ZtTkFteEZ4QlNkZ1J1REVsbW9EZW05?=
 =?utf-8?B?YTlLREZPbSt4dUxoK0xrdUhNQzZ3RVFmb0ZvNzhwSVZSY2xJVDUvTXJpdm81?=
 =?utf-8?B?UUoxaWdVdTYxdFM4b2twQkxrdzByaSt3Y0NENEdoUFJKTklSbmMwTWhtOWdG?=
 =?utf-8?B?SDhLT0FLZzJENzJ3MndKZWxkYkRZZ3preTRMbkZtZGM2SDhBOW84WEZHZk1S?=
 =?utf-8?B?cHUrRXdUTkZZWXhHZlJ3bThaeWlRaXRZbVVVclFzaDduWC9oNjJuNEZnckdV?=
 =?utf-8?B?VGZGNHNYamxrQVBjNUFVUms4clk2eUJuTVYweWZzNGg3eURBVmZ3d08yemZ1?=
 =?utf-8?B?MEVzenZOWDBJaFFiME5ITGc1cE1xbmUvQXBRU01uVWdmNEtrc2dQdWJzSC9O?=
 =?utf-8?B?MUZRYjVmNkxvR3lWZm1NZG53MnBVeEEzYVM1Y09zWjJXLzVMcE05V3pWRCtw?=
 =?utf-8?B?eFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: tLauCUGMkHMlMl3MihFk/i3/0zFYdG1+6Sn/zcnTDPpIKhzO6bqR2yrBrmDeS0yteY6i7YaW/R2s6tAYex9fJvTTu1yIVpSCFyFWyO7jhg91nX6alrf31v8gAjkdH/rLEdUQRqASawrjilCLuOlEEHrW/2VaLnZDVXP57AehIc7QtmDUyzWpDgJ5XUmNYhYZVoUzPR+s1sHyNSwboztuc7Zyy+LlHG5YD9tDyra9k2cu7fWm4BS9RXn+UkEjlMOA14BPzf06woqMTKuoa2X7G8tViYuDkT+Em9zcVtCA/PMkqABkqQ9J/ZJGglMRqSI9YVJZc5OMEmBffJKb2OebHbhWj0bBKVOFNUEgP/UZ6JVd2Ulao3uEFwZvl8d6gznnSpqkzVipAlIDoWHbgv9ZBcIIyw3uvxBwaNbIl3O3QNeV0poL3C9jQS6/kGToTmv5BwIRqEStXM/SRfI+qyFrRZtp3zF9iW0fKeo+tVOFLUPqfot28zz04MGcdeKvG8odiyE2FVQHz7oTbQuWogcs6By1HcOnUycvite7vwH7RTzCiuooYT8ADX0K/AikIAiy5BmbG7YIr7CmoMNdYF/1lUlP5IYm445/mzgOJ2wv5tXm8PbG5ho6xfAiWZb0YVF3AQqwv2MNQfQqH/ShZ1kDGa0V89H0luFt5jrBW/ooCeiHhlV2SND/uiQasN13UrdaqiTPUz2E98JnrdAm6fZBvv3wYcaQopWBnyYpkzjZWkC6JAQ2rBXLg3sVbOR4gjYUMbtNwixkcLbaTNrI+Y7jD/2VL67XcymZiE+yLhtP3I20ftcFffW9asKjN7xCcsBgcbA4NynqGHvnxe4AGr4oUQo3sUUIBpEgaI4SkAe5KBEmTyRSy8tY7b/5cCBB+MaJ
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5c8e996-958f-4e83-a9e5-08daedb62d65
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4684.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2023 18:13:12.8751
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sQGVFkMF5o02Fc7ZhjRF3qp5lVcbx5HcJmbqLQ85PaIXzaczWOuPCPpAeEO8fGzDuKoE8E9GOh62dc812Xef2Qxaq5UkzGbAXW0Fmo2jQk0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6946
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-03_07,2023-01-03_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301030156
X-Proofpoint-GUID: ZamLj3OisJifuwpbmVWPGkgTxqA4U2ts
X-Proofpoint-ORIG-GUID: ZamLj3OisJifuwpbmVWPGkgTxqA4U2ts
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/3/2023 10:21 AM, Jason Gunthorpe wrote:
> On Tue, Dec 20, 2022 at 12:39:21PM -0800, Steve Sistare wrote:
>> Track locked_vm per dma struct, and create a new subroutine, both for use
>> in a subsequent patch.  No functional change.
>>
>> Fixes: c3cbab24db38 ("vfio/type1: implement interfaces to update vaddr")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
>> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
>> ---
>>  drivers/vfio/vfio_iommu_type1.c | 20 +++++++++++++++-----
>>  1 file changed, 15 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index 71f980b..588d690 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -101,6 +101,7 @@ struct vfio_dma {
>>  	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
>>  	unsigned long		*bitmap;
>>  	struct mm_struct	*mm;
>> +	long			locked_vm;
> 
> Why is it long? Can it be negative?

The existing code uses both long and uint64_t for page counts, and I picked one.
I'll use size_t instead to match vfio_dma size.

>>  };
>>  
>>  struct vfio_batch {
>> @@ -413,22 +414,21 @@ static int vfio_iova_put_vfio_pfn(struct vfio_dma *dma, struct vfio_pfn *vpfn)
>>  	return ret;
>>  }
>>  
>> -static int vfio_lock_acct(struct vfio_dma *dma, long npage, bool async)
>> +static int mm_lock_acct(struct task_struct *task, struct mm_struct *mm,
>> +			bool lock_cap, long npage, bool async)
>>  {
> 
> Now async is even more confusing, the caller really should have a
> valid handle on the mm before using it as an argument like this.

The caller holds a grab reference on mm, and mm_lock_acct does mmget_not_zero to 
validate the mm.  IMO this is a close analog of the original vfio_lock_acct code
where the caller holds a get reference on task, and does get_task_mm to validate
the mm.

However, I can hoist the mmget_not_zero from mm_lock_acct to its callsites in
vfio_lock_acct and vfio_change_dma_owner.

- Steve
