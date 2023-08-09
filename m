Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3977A77571E
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 12:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231757AbjHIKau (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 06:30:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230352AbjHIKat (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 06:30:49 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A3C51BDA;
        Wed,  9 Aug 2023 03:30:48 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3794NBf4027038;
        Wed, 9 Aug 2023 10:30:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=RpG1TFen5Ykw6cpcLvODUASdB/ipOJhcIJEaAHH5Qf4=;
 b=UxYSw7CQL93JZJmHdkiInhjfAp5CloUAiv5M0dbrXZZrXy+JSWO6hCo5xDyEXO4BxDzA
 KdI6iXonMx982KSjc/m/v2IuMgANHV3nFFmEgr0J3degSQkmfArPudpzpqbx6km9T3LM
 PWnjlIyFA+gt2gYWI+Nf2gGkQM2PTBm9I6liOKj0B2O/RpWQeQTYJf5QV7xSfnnVLg1U
 Ac1aUBBOHyiehp0mXMdbtGizVvpswYFhMIYNJwq2TKuTGXw41cfECOQtd734UCAis2Xx
 enSwGFibYujmdqJlraz1+NMM55JKs8ICSdBijeEe9e7JyClO0kT0UdMJ4KB6Lzlid5mN Jg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s9eaarbfr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Aug 2023 10:30:12 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3798MV6U021403;
        Wed, 9 Aug 2023 10:30:12 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2046.outbound.protection.outlook.com [104.47.73.46])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s9cvdu19h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Aug 2023 10:30:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iMawUwLJINVRRIewg/7uq1rUuSIn6rPhT41zf8I+eeSf3WPMAPb2U7m8O8yb2jYa322U95nPiVcjdmPtMq8WvF/Wcp/ypHTVSyin/+HKQlnkkYP/yxV+uoLGjgQIkbFiAX8NjsJgnxCUEPmK16i0hjN4CPMBp4atM6gKJRbX+eBXwU2m7n+d5Icu5+qo7HAX3QvoPA0MBT8vMqSyucBbO5yjFU+oEfDjaf7/Jn2uMmMsFDnHvCYVseEmGBlsl2llXSJa7h5krcfaWiT3yg3o0rbwYFeydVQ/GMS5JA71yddwz1gN20d1COjH6p7oosXC9KLwdb/u7+FIUv8ZcUMLVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RpG1TFen5Ykw6cpcLvODUASdB/ipOJhcIJEaAHH5Qf4=;
 b=d2mJIQ61ZC6XW2Qcdng5s/kQZ9STW6wIzMDPo58uHee0lFECONil6TTtnzy7mi6tRR1xZXEGjY+KthTqe0Rp1nRNBRH3a2zDqllO9zltT/RjmQUfVbS3F+9F+2cljIa2iTsMtC4BpMBooxJIoaYVJs3OXef7tUPXb9fC0z+j9/a3Z/ZTPS0zQHrglc5lpF8WkzhLt/b+ZS/HDQCZG+wKPQ2ckccPNAYomJM4Blih7uxwTd0Wud8G/CiGCK/C7j3SLa/Qdf8ACvxnSNCjMv8Swb7ikPbSOYPzS4QiKxPXusWhQEAaurqR1ympneMMBE/MiSCRZuhUPuoyZ7HJhdI00g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RpG1TFen5Ykw6cpcLvODUASdB/ipOJhcIJEaAHH5Qf4=;
 b=PHhTov+yTKweLxs7wNK3oW26QQrPVZH2gMrV1BcQyB2F0hCAWhAFAiWBv1/YiTXJelD7UhoSDLaBEMVbVeElYVjRc21DFNZGfXqRaJTb8gREVkXxCKz6HoavHxQS3II2s4TFnSwBnGT9ds6PXR9lHYRp1GsPimEGR3lvKvlrNCg=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by CH3PR10MB7503.namprd10.prod.outlook.com (2603:10b6:610:15f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.47; Wed, 9 Aug
 2023 10:30:09 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::2867:4d71:252b:7a67]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::2867:4d71:252b:7a67%7]) with mapi id 15.20.6652.028; Wed, 9 Aug 2023
 10:30:09 +0000
Message-ID: <c9a1a5cc-7e84-e887-f4e3-8396cc8ce494@oracle.com>
Date:   Wed, 9 Aug 2023 11:30:03 +0100
Subject: Re: [PATCH 0/2] KVM: SVM: Set pCPU during IRTE update if vCPU is
 running
Content-Language: en-US
To:     Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "dengqiao . joey" <dengqiao.joey@bytedance.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20230808233132.2499764-1-seanjc@google.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20230808233132.2499764-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR04CA0092.eurprd04.prod.outlook.com
 (2603:10a6:208:be::33) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|CH3PR10MB7503:EE_
X-MS-Office365-Filtering-Correlation-Id: 412c98d1-c7a0-48f0-4c8e-08db98c39b22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vdyyPJfSzQlFYzQ9YTyg8u3rYQjx5e6U9oWCJ8x7CU9iY3mROHRvqdAkTRkP6yl3wa5vOLN7KqxitstFbBVpc0cleeFRZhNUznCZQa2NvQfJfwBYlDVUr2fkiHA8GeKm3WrT+WeTJk9y6FTqt+s3PnnfyHBrsDZ1ryVUL67TwWLcFuq7WROIo1+jGu+VCgmLMFW0sKYfvhXbBkpmsWH9m9S/B/tsLKR1y50Rc3M4MBEV9rF6eiXbym8Z7fKtbYN4BM0LTv0NM3C0AhKi/Ns9OKEt5NXZDuZna8O84Gr1JZkfX4sQ0ljdqEBCAtaRbnt6Pw8vJ2lnhJL6sFiImxbDui8tWpLdzwLB6XvqkDqeMkN+3SSkN1G+sY8jZtyf7IGm0fBha+Jx+GFh40NVgYlQomYhhXUmRlr8En9h5Xdcdz48Okqb7WRCt9pBBG3dn/LtUkNki1sbvV1BgNjhZW4RvFHsNuouk4x3RKiyIndeCKkve2NulS8/h02ArzxpNKxaViCDIIsxSCJ0PAQ0jxqzHJU+4L9Eolyqie2qPSdVLYWeZpWlK5W/hDoEsDowsCb8Kp4vru5bJejBZUglaHn/G5MYKndha7/JdCihL92sDOk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(136003)(396003)(346002)(376002)(186006)(1800799006)(451199021)(83380400001)(31686004)(2616005)(54906003)(110136005)(4326008)(38100700002)(316002)(5660300002)(8676002)(66556008)(8936002)(66476007)(66946007)(6666004)(478600001)(966005)(31696002)(6486002)(41300700001)(2906002)(53546011)(26005)(36756003)(6512007)(6506007)(86362001)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TzYvUzFudC9KRS9KVzR4c0RQT3VQL0QyMERBd0ozRHprOGdFS0FOMEY0M2FM?=
 =?utf-8?B?emZEQzFQQVFiaFdyZEpPQ3Z3WE8weURiWXpRRlRqZHdCVjRVbWcvaDJpZG1n?=
 =?utf-8?B?ZHlGd3FURmE2MytsaTJGZUlsbVhJVi9IbnNoQmpxRDQ4amtuQmNFZy93SUsw?=
 =?utf-8?B?SXAvSlVqQURDVkttNjN5M25tYlQrU0wvQnU0WkNVdlgvRS81eGZDNU0vSlFB?=
 =?utf-8?B?bXhPSXJCaXZCbGxaSTVnWTgybllKMWZST1VQRE5uRC9YS1hyVlAyNzJtVkhx?=
 =?utf-8?B?dDc3L24wcVFZdHN3dDVaRDMyL0gzZnoxRVM4WVA3RXNoY2ZPeEhseEtXaUx5?=
 =?utf-8?B?TDFEL2Joc0svNG5HWkN2MU9aSS9wZjJacm0xV0w4SjBCUTFuQ1hiS0lhQnBp?=
 =?utf-8?B?dUxLYVIwTHdRUXRpcno1RHJHNDBGWkZkYXkvWTN3dG9rT3BlQWZWYTZEbWN1?=
 =?utf-8?B?endpdy9LTEg0QUpLY0JLbEtwMllVaWNYRG52VUl4NUFHVzM2QytkQWdNNldM?=
 =?utf-8?B?Ry9IN0gwSHRSV2JBNXI1RlpSLyswVHJwTjUwbmdSSklMRDlNUkp2cWNBMWdR?=
 =?utf-8?B?V3loYUpBcmthUEYxaDR1NWsvOEdsTWhXWEVOUm9OUTBJYlB3TVlCbUhoWG5q?=
 =?utf-8?B?dXo1Q1J3ay9ZaTFYR3E1cXg1VEo0UXlkS2t6cnNGdEplaFFtOVBQZnR6NG4z?=
 =?utf-8?B?ZlZLemhXL0pBOWFPeTZENHFNZG9RMy8wUWpUS0k0bEFhZFdxQTg2T1ZDMFJ3?=
 =?utf-8?B?RTQ1N200R2N0M1dEUWZjOUg4Y0xVWTZ3empTdTNCTmpRTUlRWmhjcXA3OERJ?=
 =?utf-8?B?dTZDV1hkMjRMdi9za3ZEcDlSTW5zL2lZajFrSmVJMHNuejV6aUY0NXVTNjBC?=
 =?utf-8?B?b2dtSzFIVjFITEFRcUNDV2VEWkNpcHNuU2JvY2ZHaWZSRG9nVzhRNTVhV0tQ?=
 =?utf-8?B?Nm9wY2hQaWZsNElYOU9nZ2VTYVc2Q0lzOTNRRFBiV2lDMTNuT3k4UkhJSTdD?=
 =?utf-8?B?TUdDNmwycG9laHo0dlQvZ1lTWm04V3dINmFOSXV6QVB3enRGN2ZrcUtqN1Np?=
 =?utf-8?B?a3ZVQU96enAzRnZxckMrRWgxcGhSZDJKcXZjenpsaGg2NkRmdCs4KzRXZXNj?=
 =?utf-8?B?S3VsNlgyamljemd3U0N3U2hLRkpXdllYdkNWTjVhdkVxaHZOZzdyV0ZhaC9K?=
 =?utf-8?B?bk8xNnVTd1crVnc3blRSNG5aN211TjBsRHJ6b0lTbERWd0htcm9zV1htTHFC?=
 =?utf-8?B?bktjd1p3NGpVaE5CUUpCbnlRZDkvNVZ3aGZ6YVhiaVZsK21xNzh0QkkrNUlk?=
 =?utf-8?B?SE9DNUNOV1JjK2RMUFJwZ2pFb0RmRFRjckRnSlBtekoydDNVQlhLUUcvbmJN?=
 =?utf-8?B?Qk1BeUVvN0JYNzY5YWxUYnM2Q0tiL0hXRXlwNWo0ZGg5MkJFc1VHQ3pndStt?=
 =?utf-8?B?T3gvQ2ErVWVFdGlaOGVEcDBQNUdzNC8wdFRTWW55ckZsdEVwOFdpaTN4ajJX?=
 =?utf-8?B?WWRWTDZSRnBPNHpKdzhPS0pLWWtPTTBZbitqSUlXRjA2bzlSaXo3d25PZUQv?=
 =?utf-8?B?RVRiTHBzdUVkMkFydEJ4T212eStJcTdhTW9WUHlPaHBjUGp2Zmg1bCtycGlH?=
 =?utf-8?B?Z3Q2U3VwUXNhYittbGFzVHZpQWVqU0p0R0xid2x5djgrNGpBWjEza3RsWG5N?=
 =?utf-8?B?V1h3L0xBM0RTQjdPVTZtMkRIbnZPbEtZelFmRFVtUVRvZWllUEIyM05oT21I?=
 =?utf-8?B?aGgrMDFVZnNFOEo1bUNpWXFuVmNLM3ZETzVXUzM2d2FzTlg3TzdpeWtzd0c0?=
 =?utf-8?B?VnhuVmZTMmRmY2pGdkIrYUlLZE9XZnJFdUp6NTJLcEE1VFQ4VTNWejV0Tk56?=
 =?utf-8?B?ZHdsa05yZXpudnJDRTIxOEtVcHVRS1E2d2ZxTG5qRVhkMnNjYWtaOElsaG5L?=
 =?utf-8?B?YUFQVW85RVNsT1BnaHpTYVBkT2xtVDRmendhZ1Fmb1VBbWlMV0x2SjZsR3dT?=
 =?utf-8?B?VEZTM29nK0Zqd2xObVZta0NxQ2UzcnNwOGR2NjRDMVZtcmF6ekp5RE41cHlW?=
 =?utf-8?B?dGtLeXpLRXh6bjdLQStIcEo5VU5lcUdCREozaEoxVWRodkpTRUZXMGVUTjlp?=
 =?utf-8?B?bC9RcndCcGpKQUtLSXl2bHB4ZC95ckhrT2dZVWxHckpYcGVkcSt5UkdOdHda?=
 =?utf-8?B?L2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 5BjTwZC8L2/AVyNAHeeFBz2XzNxN3JFQponRWSkBkPbVEasVpw1amIwG3e7UmrBvdIfArRpd8zWPtbLcY2EYq8GQmRMp8ppclp7CyIwwuIMVg0riOAoWEgKOUSfhO13GgEAvGCcwqw3sAw1Zt1mOzMDQbyFm8bMh3XOZimTtxL6IcBFJmW4gvutwFiHDSYlY9Ie2YXL0RVF5bKV/bzCa8EqI0ZkUb0I8lK4L0Og/w/Z7lp3RuNkpAwW5XYf+pl8EvkevLWNo2/dj2AEv5z8fPjlJtq0HZysC9nKDEsN/TCuXfVgUpQXCfulEhGPQIzluIu9nkaaotqH3CwBwFizPj8iZgjGYbSMTkgN/dfA2fHgMs0evixSjMk3tmECTQFZ44XPze1CaUJlnr+gibmGT+DVzHxKCHlkLe0Ou/tT/Wn2iCHlNXFZIXSX3VayOB6D3wJcAFlayN2erTkHE0/W39jsMTbJZ4DaCUTh5TPhWqPHSsjiriLIpiPgkQ50JsiPy4HnX6xt5jgjWMr7vVSJblUL1SIOPKkQflxjfasEVV1Ec3FUOCoNEZYU2EwhUxu4PlQ69x5gMFIEQP0tGHU9kLlZ59gK4ZhOEbwI7d+o8RcrZikU4sluDagPallm6KfH3ISoy3RSfQagr62jQ38HorfFMuxnoqDRYQ35nb3grLJF+HfhKW3wwMN+J/Cqj5EymhFchdXcC45efHaHRJybelfCXP+3zw34ECw34p3Wir5kTr/NzF8dUEs3ujMUlDT2mD3ZEe5dyZyUksNIZKLfr/stnVHlpDIsSjeYurDnvxHvCNtsMVCCV2kf0VHVdWEb0OqXvq7ODpCR0FV02aBYliGykxdQ5SLX7/EZnEiYBfC0Mi+sREY28UUTrTVAn8HJi
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 412c98d1-c7a0-48f0-4c8e-08db98c39b22
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2023 10:30:09.5237
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 05Y97sTXFp6qPUTqK2r6DTtUVVXinewi/GO2b3Qex9ek1ZSgJWOG2WUYaWxH0jbe0YBZ2HsyFpIsR9WFSEj5Gkb3BZPJPPqhuy7b5Dyt1B4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7503
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-09_09,2023-08-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 adultscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308090092
X-Proofpoint-ORIG-GUID: 3LWPceFn4I8PDjH1IN0772NSw8e7XaKC
X-Proofpoint-GUID: 3LWPceFn4I8PDjH1IN0772NSw8e7XaKC
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/08/2023 00:31, Sean Christopherson wrote:
> Fix a bug where KVM doesn't set the pCPU affinity for running vCPUs when
> updating IRTE routing.  Not setting the pCPU means the IOMMU will signal
> the wrong pCPU's doorbell until the vCPU goes through a put+load cycle.
> 

Or also framed as an inefficiency that we depend on the GALog (for a running
vCPU) for interrupt delivery until the put+load cycle happens. I don't think I
ever reproduced the missed interrupt case in our stress testing.

> I waffled for far too long between making this one patch or two.  Moving
> the lock doesn't make all that much sense as a standalone patch, but in the
> end, I decided that isolating the locking change would be useful in the
> unlikely event that it breaks something.  If anyone feels strongly about
> making this a single patch, I have no objection to squashing these together.
> 
IMHO, as two patches looks better;

For what is worth:

	Reviewed-by: Joao Martins <joao.m.martins@oracle.com>

I think Alejandro had reported his testing as successful here:

https://lore.kernel.org/kvm/caefe41b-2736-3df9-b5cd-b81fc4c30ff0@oracle.com/

OTOH, he didn't give the Tested-by explicitly
