Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 209E56632CB
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 22:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237669AbjAIVZQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 16:25:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238036AbjAIVYu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 16:24:50 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64CE8F03E
        for <kvm@vger.kernel.org>; Mon,  9 Jan 2023 13:24:15 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 309L1ana011918;
        Mon, 9 Jan 2023 21:24:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=eQcg7Hs2h2z7yB2IuSZj76nKnWEHmmHuZ53d0B4w814=;
 b=pykSVgOWoLDCGKQ7aQpbFuEref1WtmqCpb9qMi2OUdTSzhk20HpZAPov2oWzdct5RQvm
 Za9ozLePVIPWYyjWf2cUdCo14mMeXPqpdS5yZUDkiJBlCYNg7nDPtw6hrlC5dZK3cFFN
 m+9zMXFtZ/ppQc+AXZ/XkpL/JQ5j7EVPbbKlodzD7EO9WvddTl/lRrgfZ2S2NXWuX/oR
 4HAxsSCIaMIUwuo17AxAG6NxTkD06b1ZNol2NpMc4vlaKzn3EA+T8q8LTxY6l/EdcKKh
 01JTTuyS5ilxZCK9KMmgnRUqXJBlgLNf4uRCp9Ud1sdRinPnCYRjYKWv/a0y5vpEIjtZ YA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n0s898687-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Jan 2023 21:24:10 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 309JctKZ007733;
        Mon, 9 Jan 2023 21:24:09 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mxy64hbak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Jan 2023 21:24:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LXlQVXcXsYRDfhKjxzc+kJqcTDHeu1fDfTVAKJr71NiZDnVmLYL+q1xqZS6YFcVIRRY4MUmeFql0BDnDGCc41A4UFJaut4dLp+qBmr99waIPc3E1uhAHtAux47Xb/FzUp4NMqg5V53YiHGlyt1F3YzCdm1drR6tQ25aJmZ42k9y4UQvtWSoPRrQcqORaOZRuFSy8cCCRrEuR+uoHmm++AdmLJJdJbXU/5w6HSr5E1HH2AUo6whip5BkCN6xYBMZwmHBR28iCTopPxwqOiRlzurcDcgb/7Atv+Doc6xBWQDs8IXkghIzz+SBZ8CEj3fGZVIXtRoQONCURYeSm1xH8aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eQcg7Hs2h2z7yB2IuSZj76nKnWEHmmHuZ53d0B4w814=;
 b=cOdBlZsaygeQXy9h7s9xPfsnot2VN/+oqmQi/jC0v0aJFg0q2WYGL3Nxf/Y1K2pGOlOwR0MZGfNg9/+PnSACtpeQ8whhQEpt0uCB5+84dZxXkFW8lXKh0Xp1gsJRi+qpzyVHgb6EInRCWG11unOPwSVOvJncToFbryb9621s7xg9EgUa0q2ByNQoruqqBhJNSjhw5jqyBg+RaLWrfZBcrYq6q3L+UuZHgxIpeRwNtN+7aMev7CWzEkVHrBkxIJNeCr6KgsN+WVYjLUP8QBjIzc/Ay1Es5v1jcbSE1HvqXH3NdEqt34zpOisupYOGLWNF2FgGtcBTxTCv9bWjkM5QHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eQcg7Hs2h2z7yB2IuSZj76nKnWEHmmHuZ53d0B4w814=;
 b=zWyHyCr4pempX6+9M8msRXWMQ4YRC13U6OvdiKGX79X6SUiLiMM0BB56JAfiGlBwmpENjHrCjQv7NExDXZ8vceUlwc9EKK+LTpGyLE0jH+wpfTSTSnU5ioqbC04uNPXD2hDDxWft+ffjkEsFIacGg51iFDQd7qV1kwRyR0jjl7E=
Received: from SA2PR10MB4684.namprd10.prod.outlook.com (2603:10b6:806:119::14)
 by BN0PR10MB5096.namprd10.prod.outlook.com (2603:10b6:408:117::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.10; Mon, 9 Jan
 2023 21:24:07 +0000
Received: from SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::3667:7f89:cdc7:9cca]) by SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::3667:7f89:cdc7:9cca%3]) with mapi id 15.20.5944.019; Mon, 9 Jan 2023
 21:24:07 +0000
Message-ID: <1d5fd387-3e4d-77a5-dc6d-04cc4c9ed3cb@oracle.com>
Date:   Mon, 9 Jan 2023 16:24:03 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH V7 3/7] vfio/type1: track locked_vm per dma
Content-Language: en-US
From:   Steven Sistare <steven.sistare@oracle.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     kvm@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>
References: <1671568765-297322-1-git-send-email-steven.sistare@oracle.com>
 <1671568765-297322-4-git-send-email-steven.sistare@oracle.com>
 <Y7RIEeQW5L+qFt9a@nvidia.com>
 <74b67580-7b4f-560d-19dd-95b376122595@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <74b67580-7b4f-560d-19dd-95b376122595@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR08CA0048.namprd08.prod.outlook.com
 (2603:10b6:4:60::37) To SA2PR10MB4684.namprd10.prod.outlook.com
 (2603:10b6:806:119::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR10MB4684:EE_|BN0PR10MB5096:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b6e06ba-0c22-49fc-df62-08daf287d711
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1oLrG+yWknoGRjR+JThIlxs32nOPs0T3rXOSboeA7NGK4aArGGxK3fXl5pKdCWHwPQSWJdjimkc9iqq5iMfHnX5I7hLmbGJUPZx0Adwu0bCTYRzV0gyxCNJE7ya2ZDqfKKTs1fo601QxMnld3wKCD2arznyG/GYaH/4G1BBnUdjmczDD+eX098qn4mrDeyz8zTe0fuWp/Nq1Ptopie64mCKk+HnWWpwxlAQcIP7ry8TArF6mP2c38vdTpWNYBnIUfIO+b1CektnR+npkKY/zzOMm+4LBNLtWD0wk6rG4hPS1fTIDF7dzo/wjQudsS8w67YsNgA3zDQY6iaVc/3y8Fv0Mb4EejTBaUODjlnlrLTw3tTuAZGgz5H9p4xAkeRZXwF5PJk/u0sZij1zbFF12UogW3PbOBeHvUq8ofawT9tFfgB4i+q2qWpZ0bj3tUWyz3pgfs3si9URjLSgFIRTj5do/07RiPsAy2aH9zWnMJmzNm5/HoOxh05y0EI/+9xIX+QD64cMOMm0GKmXW31V2OceCIDgLaa+tCpP+Vbu8ZgTsAKcy2tCgFNUNhViwxvdmV9rpAf25uweBeLF7KSOlmHCUPTC5mRQU/Z3QXeL0lxR+HVMCkLx/y2gI5FAankElxUTmX8qXJSkneqXEYHTOOnBcufELJspHf9gtNz4YkPfh+L5GlZoy+sP7uDisU7Oj9ddSCyWfwF9sqZMOCYf4bkwMZCWI1j3HR6e1zi98Yes=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4684.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(376002)(39860400002)(396003)(346002)(451199015)(36756003)(31686004)(86362001)(83380400001)(6916009)(54906003)(66476007)(8676002)(31696002)(66946007)(4326008)(41300700001)(66556008)(38100700002)(6666004)(53546011)(36916002)(478600001)(6486002)(26005)(186003)(6506007)(2906002)(8936002)(5660300002)(316002)(44832011)(2616005)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WEQwYWdNY3ZCRk5mN3pveTlNVkIvQlNoZlQ1VFREU0Jyc0tGemhHd1NCTGg1?=
 =?utf-8?B?VEFBWVpJQ2I4WXVvellSQVdVMUJpRm03ZnY5bXVJZUM2MUxTTXBVQW9XVGNI?=
 =?utf-8?B?bVdYWWtaN3lUNnZjSEE2ODRyRGlmcVNrMmNYY3lnc1ViUTFNWC90cHZQS1RT?=
 =?utf-8?B?TUZ2cTBSNGtaWFVZL2g5MmxZQ3pnTWNSRU8vNmFmdVlJcGFOVU1JLys5Ujhi?=
 =?utf-8?B?Y3RadWowaUVIMHdleGQ2c3AyK2pqdFdmV01aNFN6WW4weUZkSHdXZXVBMHlN?=
 =?utf-8?B?YnkxRFU1Nk1YNmNvOG5oZUZzY01IYTNzSElwTzJrUU12ZHF2MGdkRlA4Q3Bt?=
 =?utf-8?B?SGFpbldpenQ3ZVowT0U1VmJFdHo5S3FkRGc4MVZaWmE3aHoxVEF1S1ZBajEz?=
 =?utf-8?B?WTBscmpwWWtEajRpenFsWnRJeVdEQzMzUnFNUVlrbnd1VGlZWUs2blVtSkhW?=
 =?utf-8?B?dHo0eTh5WXVmOWlpWFo4OVByWVMrQmdHTHdGc2FmMWRuM1poblRBVlNlQ0Rp?=
 =?utf-8?B?NlFYeldsRW1XTGErTHdyd0huZHg0UkZ3STBoMTFiTHpvNCtKTjZRYUU4QWpz?=
 =?utf-8?B?OFM4ditRSnZ0TjJtdDMydUpITHRzbHFteXExOGR2UGp3dDFwRWh3TloyVXZJ?=
 =?utf-8?B?NHRiVlNReXVXaFFFeDFGdFo1b25VQmF1K3NrVFFWTUx2cWtLU25sUCt5WEli?=
 =?utf-8?B?ODltTUlKRThIUlpnL1E1ekUxZ3RWOHZYVE1ORFBPdmhPaW5FV01BZk5LbVA4?=
 =?utf-8?B?YThhVWgvbkpZanUySGt2dUhieTB1UEcwd3BHS2JMQWtEcm1tUnROS0lFdG1a?=
 =?utf-8?B?RituaEZuTWYrVTJnamFuUW5KTVhmY2xiU08zTVJwMHNySU5pSXVQdUxFcVRa?=
 =?utf-8?B?SHRrRkxUUm9iOG5VQWsxMmh1TndYeUdrRHVUMldlcDdKTTJCSkZ0NFZOWW1Z?=
 =?utf-8?B?REpPNC81SnFzcHYyMUNrcGFmL05IOGR5VUljWEF4Z21lbnRPeUZGdnpmU2JU?=
 =?utf-8?B?VGg3S2RRNEtzbVhTdW9TZTlKdXdFZGt3SEN5YlNZemt6bitBMERML0pPU00z?=
 =?utf-8?B?ZndueXRvZmNPaXhHeWJyZ0FYMHRoNmN1N0dlTCtkWWUzRHQvSTF6OTRDclpH?=
 =?utf-8?B?RURzY1BxUXpKVitDeWJpK2QyZmc0b0ZjN1ZUYWx2YXZmUFpleTY1ei9kaWc0?=
 =?utf-8?B?ZG5Sd2dCYlM2SE1nRlFESktTelU5eVlYRTNVUEZDMDM5aVUreGpQT0paV3hP?=
 =?utf-8?B?MFhlZy9oNUtzQVNJaXFxa1hQUUgydkZ1YTVQUzlLREtkd24zQmtEYitkMkk5?=
 =?utf-8?B?MmNHUVY5S1VUaVJoRUpkRTZWWnhmcFVDVXZjbDAxbHN2Mm04VDE2Sm4wdm5W?=
 =?utf-8?B?Qzh2ZHZJT2tDQ1UydklxYVRwcmxQMDU3NDY2bnFwQkdJcTArTG9PNTJRVmJ2?=
 =?utf-8?B?WUx4QVJwMVhNVDNqK3ZxaHN4RkFGakVuY2ZnRXd5U0FvWlNmckFyVWtTTldx?=
 =?utf-8?B?VzRNWVQvQTZDeDNDd3BTQldNcGoyT0lZTnB3ZUtiK3paMmlaa2ZvVlJINk1B?=
 =?utf-8?B?Mmwxa3pVWUZCczVpVUFnRG5TckJ6Q0d5cmxtb2FQNFhUejV6UDNVUW9rSmJF?=
 =?utf-8?B?cEh2UzBGa28rc01ZRUk3VjJPUEo4bVFJNGVPMVBESk1yNnV2SXFzQkhiZ2xL?=
 =?utf-8?B?QUFNUEErU0Y4TitaV2NOMWpBNDE5TnlZbTR5a2czN2laR0p4SURDT2ZoSGFh?=
 =?utf-8?B?UGExOFFlVDlZT3FrL0t0UTFtNzIvMWUwNHFPRHpjNjVKenhhYkRDalJ5VVB5?=
 =?utf-8?B?VEh5RWJBSVVZNFBWdGgrRWxUN1FLdEFyWlBReWdCTFNHc0dLRnhRWmNBNE9x?=
 =?utf-8?B?L3V0V0Z5cVkvbzg3N3ZuZDVhdS9Da0hFaVJRdE0rNUFBQXMzN0ZRU2tyS1cx?=
 =?utf-8?B?L0JlaFprOWlQdnpCSDl5KzNkNCt1a1lzZzYyWTlKdGhXTmYzU0tnZWVmcE12?=
 =?utf-8?B?d1lQTm8rT2t2cnphYVY1UmtqclBNcTB2ZkNENW15YkNaZmFQLytFZWVYS21Y?=
 =?utf-8?B?WnBUaVFQTEJrQ3NmblBOOGlOVXRvbGJZZDlIazNxbnh3R0xJdzJVUENLOVdw?=
 =?utf-8?B?YW1hTUROczF5T3NCczY1aVVOd3AvMHRkVVFlRXFXelNPUVN6dFlMazlPV3N2?=
 =?utf-8?B?c3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: zVVOvg3+VU6MBs6Bi2KQMnRxVABftdJannTQeL6hoqFGctbdlKtN2tFEX//bZghct2sv4Y5OY0V6c33sknbFVpwa/kgGzvJPhmeXJ1yoyqmWi3nZ24IVEa+fS+Vf9wUF4Emk69TE6MI31Vbo/ouRzxLLp9oyw4v1w2Rx2ta9d3KRfxGssuirw/0bpsgckNPqVQCYXyQ/Nct5+2wx+/qLatdwbhfkSXm4z+QngNuFGMw6T+ZlrVE5AOT13kJBGnl8BEAhMK3SayJUGM5FjPxOqA+i14+Jd4m21XZ+mtluZNiT7vDuk3uIvyB/pLMINVV/O8eK5XrJASSbowboCntU6QxKC0KXaH1c+zfD4rZlqk/T0wX2zMb2Iwx1mBp55LemlfBIS3EtGf7nrjZAXcY61ETK2p0tciMeuQie3B8wRW+QIZU+NnzLk2v88SaOXVsob0c6pflixhxI3z0H0Fv+PtuNdruvGGWIi/L4bceZ+4OYenYrGJ6Z9ptN5RrxY3AAfWi7em04Dv7X6JEKRQ/JZyUWliyzClA8cdogfLd+qh1yy5CCrmhrGeoR3E9WSu++ZymiTh31+3IPZIwZCcsNqRewJtYIvObH4J51NDeN245qjaaCIhddR4SY6nltaVRzwVUpDhEzu4K4AWP3Y2IfvpZWdh6KqZTHcKPcBUifEGHKoZXwBDWNbzBFapCkPCBwsdVzpy9XPjsEBQaGdUZ1EcTSg8mcrkdqHIJfZSUA13u1NneRqeB87kIqe5e5zp35DBo6FIIV3HlaGQIQrB7jjiYacomfoB3tRUc1zo/4BOnU2uh6D2EbZFeVG6aktb64L/z89wV0b+SiQ1OncKT2Hw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b6e06ba-0c22-49fc-df62-08daf287d711
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4684.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2023 21:24:07.0063
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VprfUc1qkS8QJgP8iPrxMDGujJe8K42+rDEI+HzboLmFANWj+mZzfVSnZoxLmzYiJnD5pVLsS1Cj1rwUN0+HkfYqHY+xJhWnm/9vMNRM1NU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5096
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-09_14,2023-01-09_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 malwarescore=0 mlxscore=0 adultscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301090149
X-Proofpoint-GUID: CCkEfKzSy9dF_lEJfQCTNXNxnRZEb7AF
X-Proofpoint-ORIG-GUID: CCkEfKzSy9dF_lEJfQCTNXNxnRZEb7AF
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/3/2023 1:13 PM, Steven Sistare wrote:
> On 1/3/2023 10:21 AM, Jason Gunthorpe wrote:
>> On Tue, Dec 20, 2022 at 12:39:21PM -0800, Steve Sistare wrote:
>>> Track locked_vm per dma struct, and create a new subroutine, both for use
>>> in a subsequent patch.  No functional change.
>>>
>>> Fixes: c3cbab24db38 ("vfio/type1: implement interfaces to update vaddr")
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
>>> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
>>> ---
>>>  drivers/vfio/vfio_iommu_type1.c | 20 +++++++++++++++-----
>>>  1 file changed, 15 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>>> index 71f980b..588d690 100644
>>> --- a/drivers/vfio/vfio_iommu_type1.c
>>> +++ b/drivers/vfio/vfio_iommu_type1.c
>>> @@ -101,6 +101,7 @@ struct vfio_dma {
>>>  	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
>>>  	unsigned long		*bitmap;
>>>  	struct mm_struct	*mm;
>>> +	long			locked_vm;
>>
>> Why is it long? Can it be negative?
> 
> The existing code uses both long and uint64_t for page counts, and I picked one.
> I'll use size_t instead to match vfio_dma size.
> 
>>>  };
>>>  
>>>  struct vfio_batch {
>>> @@ -413,22 +414,21 @@ static int vfio_iova_put_vfio_pfn(struct vfio_dma *dma, struct vfio_pfn *vpfn)
>>>  	return ret;
>>>  }
>>>  
>>> -static int vfio_lock_acct(struct vfio_dma *dma, long npage, bool async)
>>> +static int mm_lock_acct(struct task_struct *task, struct mm_struct *mm,
>>> +			bool lock_cap, long npage, bool async)
>>>  {
>>
>> Now async is even more confusing, the caller really should have a
>> valid handle on the mm before using it as an argument like this.
> 
> The caller holds a grab reference on mm, and mm_lock_acct does mmget_not_zero to 
> validate the mm.  IMO this is a close analog of the original vfio_lock_acct code
> where the caller holds a get reference on task, and does get_task_mm to validate
> the mm.
> 
> However, I can hoist the mmget_not_zero from mm_lock_acct to its callsites in
> vfio_lock_acct and vfio_change_dma_owner.

Yielding:

static int mm_lock_acct(struct task_struct *task, struct mm_struct *mm,
                        bool lock_cap, long npage)
{
        int ret = mmap_write_lock_killable(mm);

        if (!ret) {
                ret = __account_locked_vm(mm, abs(npage), npage > 0, task,
                                          lock_cap);
                mmap_write_unlock(mm);
        }

        return ret;
}

static int vfio_lock_acct(struct vfio_dma *dma, long npage, bool async)
{
        struct mm_struct *mm = dma->mm;
        int ret;

        if (!npage)
                return 0;

        if (async && !mmget_not_zero(mm))
                return -ESRCH; /* process exited */

        ret = mm_lock_acct(dma->task, mm, dma->lock_cap, npage);
        if (!ret)
                dma->locked_vm += npage;

        if (async)
                mmput(mm);

        return ret;
}

static int vfio_change_dma_owner(struct vfio_dma *dma)
{
...
                ret = mm_lock_acct(task, mm, lock_cap, npage);
                if (ret)
                        return ret;

                if (mmget_not_zero(dma->mm)) {
                        mm_lock_acct(dma->task, dma->mm, dma->lock_cap, -npage);
                        mmput(dma->mm);
                }
...

- Steve
