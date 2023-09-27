Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6797AF7BC
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 03:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234783AbjI0BoH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 21:44:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234999AbjI0BmG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 21:42:06 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 886C78A71;
        Tue, 26 Sep 2023 17:47:13 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38QLTOqU017891;
        Wed, 27 Sep 2023 00:46:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=sU7Xvbfkav64gv6ohrL9PpwVzD5XL7/m/S4c5oJy1eQ=;
 b=e1ujdi5VfjhLQ07IheW14Q1Zm4NW1NgDrLP40cslGwsls8tR+TZz8RyriHbWdUyJrIae
 gksJjgpomBni3PohPt1J6G0gDIpqXkY3WRrr7pE3NJm9mbBkJkD9JFv1KLmlu2ir+Twn
 Rax1jMusUXzOc7KCC07DJcauJg3UyFBlL/vOkSEPlaPGRzJ2S/XqrezeHuPp0tVGNBZM
 inoIj41/uXXpvrp+qY77HTEX7xPDtAui762u1mpgTFsZFr/i4P0lJBw5S81/u1knYBTy
 QQa93KNQXUQN67oHOLeWUzhe1wsZ+srbDLV1YqjHeKztPv04E/PK5yCK5DDQoJ25vswR Tg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t9pee84jh-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Sep 2023 00:46:54 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38QN3eRv030574;
        Wed, 27 Sep 2023 00:36:52 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3t9pf6v08m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Sep 2023 00:36:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EVMgfTq0WdqFwyeOA3ALj9Xe+DnoJ8CDXmHYFBtz1I6rPvKuPm5+7eqdTm0uYFRGcDxBwG5HUdacTIoDJHsLQOaVoGnc8ktzuLDgl8N4r3EyY7ZR6XFFsqVe3u7r2ppbHUJm+hesUHY44IKwqYVP6pNJxr4Dvb8SEvapX7vJcbG1Vd/SLF7Yn5cwuiLQbkuruH5V46Ie2ecC4YzhQjUCcjDr5HwRVKvaOAHHA1iXeE0MYAeh/XPI/QgODbFI90d4+ABh+Vx0Heh82o+HT09p1sNh57SrWCp4m5FSjN4h4YfVtwUeJCLHbab4eapWMW01fi/IfQ2lLVXkXZqQjY6YaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sU7Xvbfkav64gv6ohrL9PpwVzD5XL7/m/S4c5oJy1eQ=;
 b=hvVph4j3N/jMOdF1ozGyOaw+C/izpZ0WgI83yFf10Kj+Tx6CQ01dWvzvkZexQ0NRGIbo5EevhEVzLwpvvLMDfiHYrZdu0U0iXX03v9nyV2maY2C7ePmhxkl3LHjUxhLV+7ZE3EfY+zP8qPUEmY3B3yp0St2kDZ5fFh96vUWWpC9VFeI97A5nvZlauyGYQvy71lFc7rzMMcEjlxmDO0XpDumzXHInfutVd5QuWgFbd7dbFqe6v65+JqBPgfoVj9wEQc1e/W+YRY8hrWuGLn6cqEbwYIcZ6VoMKChJ/fPBeKMGcbvhqmQ/5yGTmLCLUPfGM4Uan/cmll6ZwMIbmxVpqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sU7Xvbfkav64gv6ohrL9PpwVzD5XL7/m/S4c5oJy1eQ=;
 b=vJXTFzgIvVidE9h/eYSh9dfDhYf0YL5jsUUtbUQ1yvB6o7AeYAdjsziaBR/WlRKSBg7EaQpKuDtqyE7aFPdmvBz/7sjgiE1ErL+f5VhLWxEc+pDdJKPrAhcsbz/kGZbbG62uD8FLrL3LWqCYFviJiviqUZThb7Oe1n8j3p5OABE=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by SA1PR10MB5887.namprd10.prod.outlook.com (2603:10b6:806:23e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.21; Wed, 27 Sep
 2023 00:36:50 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::7e3d:f3b3:7964:87c3]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::7e3d:f3b3:7964:87c3%7]) with mapi id 15.20.6813.027; Wed, 27 Sep 2023
 00:36:49 +0000
Message-ID: <36f3dbb1-61d7-e90a-02cf-9f151a1a3d35@oracle.com>
Date:   Tue, 26 Sep 2023 17:36:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH RFC 1/1] KVM: x86: add param to update master clock
 periodically
To:     Joe Jin <joe.jin@oracle.com>, x86@kernel.org, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, seanjc@google.com,
        pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com
References: <20230926230649.67852-1-dongli.zhang@oracle.com>
 <377d9706-cc10-dfb8-5326-96c83c47338d@oracle.com>
Content-Language: en-US
From:   Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <377d9706-cc10-dfb8-5326-96c83c47338d@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0158.namprd04.prod.outlook.com
 (2603:10b6:806:125::13) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|SA1PR10MB5887:EE_
X-MS-Office365-Filtering-Correlation-Id: a967c92d-228a-48ac-d00b-08dbbef1d62c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N6Vf4Mlj+V4WQ7IdvSdHJU8BCb+OWM9g7ceZmmD7FtGzX+hnDfPioqammKGD9c7881Wsvb71iKEum0JtSR2dItgmllICC8PRf8qt5wz0o5r46TRcmXABQT9d0mINGUetaEqkFULsaUtP7aVmP0FC+w3zYVzNuOVBE+wwLNCx+kF+V9f6W+xyOVnw0VhEW2ORsubZ1eqEALSSRjTnk8Og2AgOtTP/YZ8T2SVRW90nNN0/6TzKuwwEUwTfMRaojEl70myCs/jc3NARVW10LGBGmPnor4CCT7uuAkBvp++Xiu0J5oTEXYh46+ZN+lE4rw6dYjWvM7i5qCCA/1fwqwKYwZWmrkh6PZ9uVZqiJqA4C0hcErsAJIUDmVnyfrwCirHDJOybtSfpB2bbSHD55ZFTqrBwrLEeTqB0AP3uttvqyCI2lHX2CdYMwNaTgQgRrQI12rnd2BHkumWNkMhJAL19dofwUW7UzErpenLvsBto9FBODIpXB6VqLh7b2elN0rPcJ6yVto6yfMV3PVfDhY+8tGB3E/uE5Eq2XFQLsDF/rbGeA5erwCXPR0NteiwpnL8iJMR869ta3RgH2Lf5EQDSfXZPOneu8FL4AHmiTIs9dEGQ3Te4NTU2ANdcjcE2RxYWaMS9zhoM3Xf3fROHyDlFWg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(396003)(366004)(39860400002)(376002)(346002)(230922051799003)(451199024)(186009)(1800799009)(38100700002)(478600001)(6666004)(66946007)(66556008)(66476007)(41300700001)(5660300002)(316002)(6506007)(6512007)(6486002)(26005)(53546011)(66899024)(2616005)(86362001)(44832011)(31696002)(2906002)(8936002)(8676002)(4326008)(83380400001)(31686004)(15650500001)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cWw1Kzl3MWtBSlZrakxQdkVYWTNCZXZPK2tRUHVWalNqTzBjd2drbXVlbW50?=
 =?utf-8?B?am4rQWpCY1JNZzArNnBVVjhqTzM5UGtRMVZaUkVLOW9MQWlLdk1WYTFmUk1h?=
 =?utf-8?B?MEhReWxnaVM4blZwdTJaNjBQK0Y5QklDTGRvbjF1ek5yWGtxclNpTVd0WEtG?=
 =?utf-8?B?RGZsdmwrZ0lQSnNwWlpSa1dyZmxONmRqTkpRcjZXQ3JkTUgzaTUvT2xsVk9y?=
 =?utf-8?B?dGJLMnVvNlAwZDNIV2pHekY5MTlUYi9zVjA3STVSUWE5bEgzVVNpb1hqVHJv?=
 =?utf-8?B?b0pqNWN6dzRpYkJGYUJUbmg3T2lac1pTaElUbHRnTm90SGhRb1drY0ZlSmJj?=
 =?utf-8?B?LzE2bEo0VEVEays1ck1ReU1ZRTl6clRWWnFwbTJtcXNBY2ord0RBK1ZOQXZT?=
 =?utf-8?B?TzJFREdtRzZ5S3pOSmxlL1V1NDV3N1FzdVVjM3d6VXJwRnpUcHlHWURPdVpn?=
 =?utf-8?B?RzBCZzdMMmY4SXEzU0pHVDU5a0ZKMjBwa0I2S29IWEkrSmtPbGpnQUNDV3hj?=
 =?utf-8?B?LzBlVmlUMFBsMlRPdGJQc1hIeG81d0lLUlR6RERCZncwclJaV3NLRktramo4?=
 =?utf-8?B?REsxTzBCb1g5UUxsdnp5TXBvbEhodW1hYjJlbm12TFRVemZoYThVeUttaHlE?=
 =?utf-8?B?R0hQSXl1SGwwd3lSWC9nSDRmRWMrRmsvSkZMRkRWMkNscU9mSnRpc1VxaFox?=
 =?utf-8?B?WHQzc2RIdS9vZmdCeXpDTk0zMUpSVGVtaXo0Q0lsdVpNUjMvSGdkU1h1NlE1?=
 =?utf-8?B?eHpVSlZ1YVltOGk2VXp1Q3NtNXBtcXA3WGZQbWJOenVCNk53WVZpZjdWUDcz?=
 =?utf-8?B?bHNQcHlIWE9pMHhCTDdUVFdLMWtweFVLYW96V1N0U20vc3liZVI0UFc1TUVL?=
 =?utf-8?B?SjdQUXZlUURvM1JPWUJGaFl2WWxsc0NOK09LWmhYcHBaR0tmVmh5U2dmS3oz?=
 =?utf-8?B?Ly95Y2JMSEljRVF3blFYa05FL3lUcVBEcE41dEVYaWNaK1ZjMXJud0JobWEw?=
 =?utf-8?B?T0YxYmpUNEhWcWdhRmNEYnN5eVY3eHIxaElYK1ZJM2w1c1NlUWt5OU51RjhH?=
 =?utf-8?B?WU9IRkhDa3IyZmE3YURDdEM0MkJnYWsxWGsxSE1VbEhneVFXVWp1WGtQTHdQ?=
 =?utf-8?B?dGI3VnpXTGh2TE54OWJTVWx2RXFEL3NjeldxT2NxRjRXMU91R3g2Vm4yMm0x?=
 =?utf-8?B?aVFpL3UxSFhrT3ZheXljRk85c0tEcjRlUy9ILy9iaWdJNDFoZG41UkVoZUsv?=
 =?utf-8?B?QlZSdnlRTVc4TEl2UkFnb2tqN0hSS2lKYmRZcTJ2QmlpRFhqR2djWU1Qbm5O?=
 =?utf-8?B?SkdrRVVmc2dpVmNxUVdNMmo3eHlZcnY3Zm9LM3AwMzNmTnRpWm5mM1R0ZE9P?=
 =?utf-8?B?NXlLSGxHeWk1K1pKdi9nT2FUQ2lKYlE3YUpFRk5pRXdkekhIMml1d2kxQUlk?=
 =?utf-8?B?NTkwK1lLRFRCRVlSU2xJelZrL3BzS0thcXlTakRxdmRGc213eFBLSS8xY2RK?=
 =?utf-8?B?bjI3dEpSNFJ4dDZMRzFFWEFBdGNKYVh1bEwvaGIySUlkejRlVkk2UjV6Ti9N?=
 =?utf-8?B?cFlGMmtzOWVEZEVCZlZOQWRMWTg3aFlsTDVrYW1ZNnJYbTVabDlhUW4wbWFL?=
 =?utf-8?B?UHUxOFMwRzV5ZDZzYTlUeVZRbm5wRnJaTzZYc2NWUTNzZFJhSlJQaWpmT1dB?=
 =?utf-8?B?YWR6S0N3WldTenVkWEFVZGovNHdrRkhFa1Npd0FscHo4R0h3V1RuWTVraUM5?=
 =?utf-8?B?QTY2NUlvemFCT1BFcUNCbGpJckNYNGUvK2VLQm9lMjVXS1Z2blUycHNFbEpU?=
 =?utf-8?B?S3JBRkdCVDFtSnFhVENSZkZiNXZCME5sbXZwMGFNNHlPeTFtRXhNcTJ6WVQw?=
 =?utf-8?B?RnFVOWVuMEMwU0lKVTBYQS9RYmg0WE1KZXV4UHBUdGp6bitnVHRZZnBHWVRk?=
 =?utf-8?B?Y0NEbVM4N2dNQUlhTTAwQTk4ZGZLbkpKNnd0cXIralArVElGZlBWQld6bU8y?=
 =?utf-8?B?cFV1bW50ZVhTUHM2NEhiRk9ZUkFMYjcrOFZ6TVNWeDNsbE5mNUo1LzhLS0lL?=
 =?utf-8?B?c3UxZXhZYUlCUFZOOUNJK2d6YWw4enluZW9LRnlxY0VSenZyc0pXYmFzWjh1?=
 =?utf-8?Q?5f8nBlfbL4d9NUhV3XAigh5id?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?M0U1RkZSV2xYdTlQYjZYQnp3c2xqMmRtZGRadzNZQnRLRjdKdnJRY2hRdHZZ?=
 =?utf-8?B?UlVKelNhNXBrUldDU0pNdTdpWGozNTFwakpMcGxKbUxiVXB5TW1sLzE5WXEr?=
 =?utf-8?B?K2hRTlhKWE9pVkFGa2REMk04bW1qZmpRVXAyQVI2YzM0WGtRMzE3K2c1V1Fw?=
 =?utf-8?B?VGdKUDFZNzNTT1d6RUM4d2VHb09QT3VxYVA3ZVRSK2lxaUNWeExPMXZzZjN4?=
 =?utf-8?B?bkpudVc4OEJGVG9xU3BzY2tKQTJ0Tm0wM09UZ2tvL2RwOWJMeTFlVFI1STI1?=
 =?utf-8?B?V2JTVUZzdVVQVFBORU4ycERoOEJlcHJ2VDh5Ums0cTduTU1GUWxVeTZiK2I5?=
 =?utf-8?B?OHBSMWJBaFR3VU8yOVhNWFhBYzNoMTVMWEV5RXY3QWJLZzRBdjc2MjFrM3ZK?=
 =?utf-8?B?ZkxyU2pqVWI3Zk9kSW5qdlc5eWc5RExZNGhBL05qTFRQRXUzZEwyanJSQVd1?=
 =?utf-8?B?cXNSc2pBK2kzV0RZVVVZWTZzbldYZzhyakxmRHN3allZMVMrSVJRYjVsU2Ey?=
 =?utf-8?B?QktPbkIvMHlPWXprcGF2cm1pWlVhRlpVUzhxbkxwL04rT3RQNDdGc0tlWVJp?=
 =?utf-8?B?K1FuYmtmZ0VsanlCRDZzdWowTENoZTBJMktVZmJyMlMvbWpXcS9pZ0l6Vmpp?=
 =?utf-8?B?SnowQ1IzWGMycXVuQy9hb3UyclBGTmxSbktSZlA1bEcrSnllUkpNVGwxalMr?=
 =?utf-8?B?ZkthTzNpQlRmZ0lMNkNTK1hmcjBycG1haXFyVlQ5eWRFSHpLVUd1Q2JnTXpx?=
 =?utf-8?B?d1JjeFJUc29xQTR2b2VjU0JMa0NFV1VaSTNKWklpcldsYVp0MDk0NzdaNDc0?=
 =?utf-8?B?eGFiV3pNN0REMURtQnZXVUdjRmlPVlcxeDZ1SHRkZnpGMHVoUlhHY0FKVjMr?=
 =?utf-8?B?ZkV3T3hFVUp0WjRuRFRzU0JRVy80VXRBOWRpWVdTZUNUdTFyWE5ROWk1VFZq?=
 =?utf-8?B?bFZHclBGQVdSbmR6a240TVlMU080THdEclNRWlhBZmdQSm56MFdZN2kwYXJD?=
 =?utf-8?B?Vm5vTEFqaGcxaWpNeU92NmtQeHNpamZKa1hKNE0wUmUxN0RjMDhuVjFYY1NV?=
 =?utf-8?B?TUpFTWtCNHA0U0NkZlpmRm5TbkxsUUpWYnovaTE3dEJZY1Rsci9Rc3lkM29w?=
 =?utf-8?B?bm1XLy9sdXhLbXE5MzVLUkk0ZW5FZExVU04xMU5XN2VsVFJ3YW9oOW9vbGEy?=
 =?utf-8?B?Q05oT1NQM0YrS2FoZVBpSzkzSTgwSVlOV3pqOXBkUW5TaVpwUjNjdENRLzhm?=
 =?utf-8?B?M2ZoRHpTc0RlVkwzUGtqVEFHenZkampuWGpHRWNjS2xNc1ZWQT09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a967c92d-228a-48ac-d00b-08dbbef1d62c
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2023 00:36:49.8928
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P6V/Kqu1TvtLTSu8+ohVz6nCTKXSsobYYZgMSFX1P3l0OHfUtqGxEkmtAExFRyN7MszCbJIv2aPYlx6Xd1lV5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5887
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-26_18,2023-09-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2309270003
X-Proofpoint-ORIG-GUID: xDs59LpFaMgjBYfY5J0Sy5FMMjhp2Z-6
X-Proofpoint-GUID: xDs59LpFaMgjBYfY5J0Sy5FMMjhp2Z-6
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Joe,

On 9/26/23 17:29, Joe Jin wrote:
> On 9/26/23 4:06 PM, Dongli Zhang wrote:
>> This is to minimize the kvmclock drift during CPU hotplug (or when the
>> master clock and pvclock_vcpu_time_info are updated). The drift is
>> because kvmclock and raw monotonic (tsc) use different
>> equation/mult/shift to calculate that how many nanoseconds (given the tsc
>> as input) has passed.
>>
>> The calculation of the kvmclock is based on the pvclock_vcpu_time_info
>> provided by the host side.
>>
>> struct pvclock_vcpu_time_info {
>> 	u32   version;
>> 	u32   pad0;
>> 	u64   tsc_timestamp;     --> by host raw monotonic
>> 	u64   system_time;       --> by host raw monotonic
>> 	u32   tsc_to_system_mul; --> by host KVM
>> 	s8    tsc_shift;         --> by host KVM
>> 	u8    flags;
>> 	u8    pad[2];
>> } __attribute__((__packed__));
>>
>> To calculate the current guest kvmclock:
>>
>> 1. Obtain the tsc = rdtsc() of guest.
>>
>> 2. If shift < 0:
>>     tmp = tsc >> tsc_shift
>>    if shift > 0:
>>     tmp = tsc << tsc_shift
>>
>> 3. The kvmclock value will be: (tmp * tsc_to_system_mul) >> 32
>>
>> Therefore, the current kvmclock will be either:
>>
>> (rdtsc() >> tsc_shift) * tsc_to_system_mul >> 32
>>
>> ... or ...
>>
>> (rdtsc() << tsc_shift) * tsc_to_system_mul >> 32
>>
>> The 'tsc_to_system_mul' and 'tsc_shift' are calculated by the host KVM.
>>
>> When the master clock is actively used, the 'tsc_timestamp' and
>> 'system_time' are derived from the host raw monotonic time, which is
>> calculated based on the 'mult' and 'shift' of clocksource_tsc:
>>
>> elapsed_time = (tsc * mult) >> shift
>>
>> Since kvmclock and raw monotonic (clocksource_tsc) use different
>> equation/mult/shift to convert the tsc to nanosecond, there may be clock
>> drift issue during CPU hotplug (when the master clock is updated).
>>
>> 1. The guest boots and all vcpus have the same 'pvclock_vcpu_time_info'
>> (suppose the master clock is used).
>>
>> 2. Since the master clock is never updated, the periodic kvmclock_sync_work
>> does not update the values in 'pvclock_vcpu_time_info'.
>>
>> 3. Suppose a very long period has passed (e.g., 30-day).
>>
>> 4. The user adds another vcpu. Both master clock and
>> 'pvclock_vcpu_time_info' are updated, based on the raw monotonic.
>>
>> (Ideally, we expect the update is based on 'tsc_to_system_mul' and
>> 'tsc_shift' from kvmclock).
>>
>>
>> Because kvmclock and raw monotonic (clocksource_tsc) use different
>> equation/mult/shift to convert the tsc to nanosecond, there will be drift
>> between:
>>
>> (1) kvmclock based on current rdtsc and old 'pvclock_vcpu_time_info'
>> (2) kvmclock based on current rdtsc and new 'pvclock_vcpu_time_info'
>>
>> According to the test, there is a drift of 4502145ns between (1) and (2)
>> after about 40 hours. The longer the time, the large the drift.
>>
>> This is to add a module param to allow the user to configure for how often
>> to refresh the master clock, in order to reduce the kvmclock drift based on
>> user requirement (e.g., every 5-min to every day). The more often that the
>> master clock is refreshed, the smaller the kvmclock drift during the vcpu
>> hotplug.
>>
>> Cc: Joe Jin <joe.jin@oracle.com>
>> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
>> ---
>> Other options are to update the masterclock in:
>> - kvmclock_sync_work, or
>> - pvclock_gtod_notify()
>>
>>  arch/x86/include/asm/kvm_host.h |  1 +
>>  arch/x86/kvm/x86.c              | 34 +++++++++++++++++++++++++++++++++
>>  2 files changed, 35 insertions(+)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 17715cb8731d..57409dce5d73 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -1331,6 +1331,7 @@ struct kvm_arch {
>>  	u64 master_cycle_now;
>>  	struct delayed_work kvmclock_update_work;
>>  	struct delayed_work kvmclock_sync_work;
>> +	struct delayed_work masterclock_sync_work;
>>  
>>  	struct kvm_xen_hvm_config xen_hvm_config;
>>  
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 9f18b06bbda6..0b71dc3785eb 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -157,6 +157,9 @@ module_param(min_timer_period_us, uint, S_IRUGO | S_IWUSR);
>>  static bool __read_mostly kvmclock_periodic_sync = true;
>>  module_param(kvmclock_periodic_sync, bool, S_IRUGO);
>>  
>> +unsigned int __read_mostly masterclock_sync_period;
>> +module_param(masterclock_sync_period, uint, 0444);
> 
> Can the mode be 0644 and allow it be changed at runtime?

It can be RW.

So far I just copy from kvmclock_periodic_sync as most code are from the
mechanism of kvmclock_periodic_sync.


static bool __read_mostly kvmclock_periodic_sync = true;
module_param(kvmclock_periodic_sync, bool, S_IRUGO);


Thank you very much!

Dongli Zhang

> 
> Thanks,
> Joe
>> +
>>  /* tsc tolerance in parts per million - default to 1/2 of the NTP threshold */
>>  static u32 __read_mostly tsc_tolerance_ppm = 250;
>>  module_param(tsc_tolerance_ppm, uint, S_IRUGO | S_IWUSR);
>> @@ -3298,6 +3301,31 @@ static void kvmclock_sync_fn(struct work_struct *work)
>>  					KVMCLOCK_SYNC_PERIOD);
>>  }
>>  
>> +static void masterclock_sync_fn(struct work_struct *work)
>> +{
>> +	unsigned long i;
>> +	struct delayed_work *dwork = to_delayed_work(work);
>> +	struct kvm_arch *ka = container_of(dwork, struct kvm_arch,
>> +					   masterclock_sync_work);
>> +	struct kvm *kvm = container_of(ka, struct kvm, arch);
>> +	struct kvm_vcpu *vcpu;
>> +
>> +	if (!masterclock_sync_period)
>> +		return;
>> +
>> +	kvm_for_each_vcpu(i, vcpu, kvm) {
>> +		/*
>> +		 * It is not required to kick the vcpu because it is not
>> +		 * expected to update the master clock immediately.
>> +		 */
>> +		kvm_make_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu);
>> +	}
>> +
>> +	schedule_delayed_work(&ka->masterclock_sync_work,
>> +			      masterclock_sync_period * HZ);
>> +}
>> +
>> +
>>  /* These helpers are safe iff @msr is known to be an MCx bank MSR. */
>>  static bool is_mci_control_msr(u32 msr)
>>  {
>> @@ -11970,6 +11998,10 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
>>  	if (kvmclock_periodic_sync && vcpu->vcpu_idx == 0)
>>  		schedule_delayed_work(&kvm->arch.kvmclock_sync_work,
>>  						KVMCLOCK_SYNC_PERIOD);
>> +
>> +	if (masterclock_sync_period && vcpu->vcpu_idx == 0)
>> +		schedule_delayed_work(&kvm->arch.masterclock_sync_work,
>> +				      masterclock_sync_period * HZ);
>>  }
>>  
>>  void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>> @@ -12344,6 +12376,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>>  
>>  	INIT_DELAYED_WORK(&kvm->arch.kvmclock_update_work, kvmclock_update_fn);
>>  	INIT_DELAYED_WORK(&kvm->arch.kvmclock_sync_work, kvmclock_sync_fn);
>> +	INIT_DELAYED_WORK(&kvm->arch.masterclock_sync_work, masterclock_sync_fn);
>>  
>>  	kvm_apicv_init(kvm);
>>  	kvm_hv_init_vm(kvm);
>> @@ -12383,6 +12416,7 @@ static void kvm_unload_vcpu_mmus(struct kvm *kvm)
>>  
>>  void kvm_arch_sync_events(struct kvm *kvm)
>>  {
>> +	cancel_delayed_work_sync(&kvm->arch.masterclock_sync_work);
>>  	cancel_delayed_work_sync(&kvm->arch.kvmclock_sync_work);
>>  	cancel_delayed_work_sync(&kvm->arch.kvmclock_update_work);
>>  	kvm_free_pit(kvm);
> 
