Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9A70707C6F
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 11:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbjERJC2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 05:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbjERJC1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 05:02:27 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CAA91BD4;
        Thu, 18 May 2023 02:02:25 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34I6IrWP028533;
        Thu, 18 May 2023 09:02:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=NmPb5ObfN6v3CL5xI81nMKxqbzyV3NDshUY1dQUJsFE=;
 b=hphEKEwcUZKSneiock8sxi4DyGIgdN1xo6qLbLr5PQZvDTcmu9Ieu6QBdRr+M49FO42R
 h2iSNlADqZu3pC68dvqeQU2/y+mcRQZbALPlm0zTVhE7o/Fz9y4UXDpj1Yh+w2rM95+B
 /lgY0mToBiU+OB7xYO/bNfrrmp5pe3HEnl2ZwEpyhUQHlItA4L4aioyaTL7IJoh0EFft
 EGi2txEnDzmN5H1TAvl8D07RxxVBW07N5/6UTFF8XzQN/EbmJJDYIanDSm+kRdeEsPW6
 nits7NU3AVdYQ4Jm1swREP640Nn9P9gApPVBLNqCMk43+6rVs67YWeXuo3ALvqEVo3dT xQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qj1fc7tvp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 May 2023 09:02:10 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34I826QG036172;
        Thu, 18 May 2023 09:02:09 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qmm03hgxm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 May 2023 09:02:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UAPmYKWzSIGxoHcINKMNDde+NCp6cknE4RqWnR4toPcRstdGQclt10x4ArLP7exesoay9zBtrAJY4pvUkhVtcsUYrX6i19KgS0RIX5+gz50qXlX9ZbEsFagxc/nENbc+RB9Pl90LrxfATGZ/I3JzuDmVyoOq43S0GUPaog245TWBpbvPjqaxM/a3Jyy7QjZ1v7QrxSucD4Q3ocJJHbkSoED/XwDJ7n95kk9x1ZwkjeORpNGfYmY3LvEN6eRqNmfTKuKIDegxVsd+vSUqCZTs2aWcLnAG8/MQ+xGDs+o/S1Q10eHfTJTs2P1bL/6B0/r8sAvhuc3SE0OVW6jxt1GY8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NmPb5ObfN6v3CL5xI81nMKxqbzyV3NDshUY1dQUJsFE=;
 b=HWLkIyPwvw3AJqnjPzw9M/S8f/S2VbF1wbQxBJChws6x6RIP9UU6d8UmXRujTNuBFoUkrcdZlXw8sqE/EkhUjl+XOPCuQclmvtFmcflecLzeH8WaTSZkW3X63oFeCepXKvSNTYcLD26rVmOkYF+/DLcfQyBL325z4j9JmtsegOL++U2WcfaVaTISb2urnx29DJIZWsm+2K4Xy5ps5RqnlAKqyuQxj+fs+aoLnEIMkiYY/t+4DSlKVkAYtm+HuJaTQwalnZKEzuu1slQQP2HJqKi2o/cb5AkWLjaN6cdQEYjefYpuX86ChmLliFYh3WnUggyT3IAg0uf+f/4ybfKdvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NmPb5ObfN6v3CL5xI81nMKxqbzyV3NDshUY1dQUJsFE=;
 b=snigon6s3LELL944rbj7hP6liZN8SOw4AZU+wg+7z8a1iEvE6k3SOW+AHmFFLRWHkl/tTp7esT8PGpzHezjeqnNUDfhT8Hyq8xFPdJEeEXN+pBD7Ow3u/+txteQ6YPA6pPvYtnQK4HHITrCblrGss9XLKuJ+DgtKpL2MEmODH50=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by IA1PR10MB6243.namprd10.prod.outlook.com (2603:10b6:208:3a1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.33; Thu, 18 May
 2023 09:02:07 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b176:d5b0:55e9:1c2b]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b176:d5b0:55e9:1c2b%3]) with mapi id 15.20.6411.019; Thu, 18 May 2023
 09:02:06 +0000
Message-ID: <36295675-2139-266d-4b07-9e029ac88fef@oracle.com>
Date:   Thu, 18 May 2023 10:02:00 +0100
Subject: Re: [PATCH] KVM: SVM: Update destination when updating pi irte
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        "dengqiao.joey" <dengqiao.joey@bytedance.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, seanjc@google.com
References: <3d05fcf1-dad3-826e-03e9-599ced7524b4@oracle.com>
 <20230518035806.938517-1-dengqiao.joey@bytedance.com>
 <2f6210acca81090146bc1decf61996aae2a0bfcf.camel@redhat.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <2f6210acca81090146bc1decf61996aae2a0bfcf.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO6P123CA0022.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:313::15) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|IA1PR10MB6243:EE_
X-MS-Office365-Filtering-Correlation-Id: b9a34e37-1b76-4551-05ef-08db577e8d93
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MuJVfxEPRUnJtwnaRPDm1aoHfKmCv/0IaChaWz4nC9E57lLJArooc5NcVHfc/h7zxwj7K/Y5k8hJG34Cymby0gD6SeQEYERsw1PnWFhMQV0qDvR3N0yUScaX4hcOL8dwQTsJIT4f64hud/DeO978u7SbXd5Rlt78rOv+7HvyYxy5aQI6X+LKimo9pYXH8nydaIdmpl/BlPzK57rz0LBZ72Y9d8niLZYkQ2ckqKKQkF4G1AOJFxoXpR980JwEa8iFs1RNu4Ce4Ox51nguPNMciS1RVRGjNWm2IDWu5gCLDEQKaVCF8P50poDaBZEPex79J28r0PY+xP1rU6uhv8yaiMFOFvL+2iilVBfdKejswpX5stkK72BMmWclL3WbOMO91SXkloGG9KRgVjVNCuMwzPlnjirjT2FoHtOl9WUU0fjz/jxNxoZMy3D2ZIeKxECWGpfha5NCw4xRonoIs6kM1w3QzcjUISltYOYcw5CNa5VPeVbDUTDVHQbm+qegtZT7IIbeh9akDkGSdrtPgvTYGSra0cHmYInxLPKtTISQHimGRWTthB/sc4WbH/R/KEd6hC4OwrWq7qukuNUPF57/hRwlNSAIkh6aq4oQFvYsVCgLkxM8ayLXftsf7gXeNV58
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(396003)(39860400002)(366004)(136003)(451199021)(5660300002)(8676002)(8936002)(6506007)(53546011)(186003)(6512007)(26005)(38100700002)(2616005)(83380400001)(31696002)(110136005)(66556008)(6666004)(478600001)(6486002)(316002)(66476007)(41300700001)(86362001)(66946007)(36756003)(4326008)(30864003)(2906002)(31686004)(15650500001)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cGRUMWZCaG5INVo0c2MwTldGM242eisvbUdCRU80QktiQ3huVHppNGx0a2xP?=
 =?utf-8?B?dkJlbzh3YmhQY0twcUk1b2ZIeEdQeWVtR2hHdys2a1QvUVQ2N21Td25BcjA0?=
 =?utf-8?B?WG9GRlFGdk5PZ0NwQXc1SHoyM3c5NHNGb2tncEN4d3lsVGFvd1MwTjIxK2l4?=
 =?utf-8?B?blVhWVlwMzExaUFvcUROT1NCRGdCRzZnZzcza29PMGx4NXVXc0lROC9ibHhq?=
 =?utf-8?B?QXc1RHZBaVVNMVJuSDhVUlRWTm4xM21UTTFyeERFWkFOYkVNZkpSYldHeExD?=
 =?utf-8?B?Sm9XRXl0cDFtamlIajdwZktjMTBuQ0ZTUkkwbmdaWllxZEVKNU9Na09pUjJ2?=
 =?utf-8?B?Sk9QNGlJSjZVVXJ3K29KMDR6MUFkejlBZURSYWRRRFdpRFphbUwzRktOL3FX?=
 =?utf-8?B?WStRVjc4d2tSaFdVVUlYUXE4b0c5TWxoM25md2RQYkNLWk85RXZCdG1KS0pX?=
 =?utf-8?B?NDBLU1J0NGxxY09ha3JGMlJ5Uk96a0ZZbTZsSEFhTWdCK1dxZktUeG9EVkdL?=
 =?utf-8?B?bnFJR0hNb2pydU5vQVRHUXhxamdWeWpXUGNKVEh3TDBqL3Y0MWloV09JVVJD?=
 =?utf-8?B?ZFEvNXVDclVZQXJ1aGhEZHBBR2RKL2EyazdqYUdIaE9Sb0tIdGpjOG9kRVZI?=
 =?utf-8?B?VmsrZVg3NnNCdS9sNFBJQ01hMUlHbDFBT2xidnV0bGxQWmxJaWpqOTBHU3lH?=
 =?utf-8?B?YlhHMi9kRlFBMUwybnpjMFRPOTZNaGo5WVpJVUExZ096NE12WmJjcTNoNHlt?=
 =?utf-8?B?bEpQWWprbEoxcWJZRXQ4SUdyVzM4ZU1LOFZJZ2ZjNzNCMjd4bERLR3lhMlh5?=
 =?utf-8?B?Z2YzRk16TGJkbU5BRVRleW1vTGR6NGZDRFhtanRPcWtJbmx2aVRFSzIzM0RQ?=
 =?utf-8?B?QVhONkJVdjFuelRhUVFrMWZIUzZnSlAxOUUxbitpZGJMU0NXelpwUVFiZkRX?=
 =?utf-8?B?U3hqY0twOTROM1pLVVhlM1ZsVHA2dXVpZ3BUdEt2TWMwT2ZSbGJob3ovc2ty?=
 =?utf-8?B?Y3EwWmVnbkFZMDBDMlRiTHBhVlFyTWVGY2Y3VVRmb2NKYU1yaEtmUG5ESXN0?=
 =?utf-8?B?YlNNSjU2eW45dXJ6WjdXZE1iS0p0Y2NORTBuZEJWOWlrUFBxbGxaU2RRdXJL?=
 =?utf-8?B?R3paT1VwQzcyN0hUeFZFeUtDczJjdXpibnlvUTBWeTEwM2dJdmRSZ3NHcUFE?=
 =?utf-8?B?MElVL3JDbDJUSWx0SFg5WmNQR1BaYk5SQkNmZnNOYktHd3ZzeWJVYnpOWE13?=
 =?utf-8?B?OWZub2sxa0U3c2h0bCtGYnhycy95czFLd2l0TjRXMDhpM0lSQkFudHRraDQw?=
 =?utf-8?B?eGNkRFNublRINjFsV3NHa1JlWVllMFc4TmdFNy9acXJSNVlwSksvM29PTUFt?=
 =?utf-8?B?WmNkekdkQ2c1M05GamVOb2xqZEUxbm43VlJ1VDlMTkRiSFAySTBXbVBzczJk?=
 =?utf-8?B?TkdlUU41dmZRL3JBL3daRmhheE5RNFBhdFlQWUw5d2RleXIyYzNlV09sa04y?=
 =?utf-8?B?Um9BZ1RWdFFsRjE4RjVUTDJnSGNLU0dMaDNWQWZ2SXNIY083K1RJVzZtR0pu?=
 =?utf-8?B?bmt2dHRIZzNGVklSdUpsd2k2dC9Da3hhTGloQ3dGK2tkdVhoZHNIS2ZNTG1u?=
 =?utf-8?B?WmV1M1VkWUNuYXpKY2tOOVlNaXVRc2RBMjVxbHZLMDVVUVQwcnlJbHpPWno2?=
 =?utf-8?B?WHV2UUZpS0pwV0RuS0NiZTRqSVA3dnd1aENTdUFEbUowU2ljSjlIVENZOExu?=
 =?utf-8?B?UnNXU2lRK0pYd2NlN1R3SGNZbkxnYmI5cUhEZitjcmtlOXF5RjlFNWxMOXg4?=
 =?utf-8?B?WkRSUXhXOU9YN3FNVUE5SWFoNzNGdmVUYS8xTDJtY1ptUFk3UWl0RTA5M0hC?=
 =?utf-8?B?Ym5ySzZBWkJUWkVzenAxWENoSFNsdklMMlBFOUQ5T2Rmb2ZITGhwMDFEOExP?=
 =?utf-8?B?NjNJNktwQzY1RElzK1hZTXkzZzR1UzdETFdWSUcwMjJYT25sb01wR1RvenQ1?=
 =?utf-8?B?czR1MWtJcVAwOHN1K2dFamtleVY1UTYwUkJmM3NKSjM4WkNhWWFTM0ZUckw2?=
 =?utf-8?B?NTIzcGswZlY1TVdOd3IyNjJoODNHSXRMdHFMUm91MlBFWGxCQXJHdDdBK05p?=
 =?utf-8?B?VC8vclZtQkVCN0JpSzZsaS9GMElvbnJpZHRtV0dYbkRnUHMyeXk0Ri9SWUFS?=
 =?utf-8?B?NkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: uKf7XvaOpjzqqFZ0LbSyE5ALdR7IuHsoKXrZg6GDKJsxuifWMmzU4D4scklqXZjAt2h25xYJFJlAUdBlGD8achAHPtdXgqL2gjerfkjhDiaBFAF491WEqAazomvUqgmkksfSJo6dvSvxs2RtxFhVEJnwFZkzxR05tWdqV64oVoMIoHfNSCsZMo8JSZAwfTJy6I7IPM/4rBH333r2eP/wM/SJ3e+x8pDFnHYBO3kpGrRlYK2/0Epn4GrRRAYZusA5RNqPcvnsCMU9hHwSYW1FJxsetazyinfFraGQ1QOBh8etNNNfDchLoPra5vixJh11X7qQl78a34bUnTFcP25tWe44wDyPXwNEYJi/dsA84znqkHD0jplo7wbhEvdaabf2/1OafyJ/XnXuyPPbouoxz2ppj2tvIJRAsVJeCHkhO0Cyq8e9VaIPcWeQmT+gtH5LtSIxI1Nox9qmJ8ZI7fqFGv3p7icWHaarA+xF6Hd3SDG7T77Ls1d5J03hrYVFjGNL2qXEhV6eMZHVEHRjCBOLB/ZXdu48VRA9J9iYhMz9sfFZmIuQDcKfyWoZvdElU8KQDvfnzuqh3yi3FoDor5260Y49kdCa7PDymyK45ShuRYcZ8uvPPn+CUNDOcK9bsXbwthobOBWbqe13n8iMdlkCpa/zh8AqPrMCGTFYT4PT/GmO+WXNfxnPhik/eflVbLUzdx9uQlw1L8IOi42PXVWrZMnb10tri6mFOs9CBnGQsMeyIu9VpWVcylJ1MXpeBHXhubJvxsmROYAFzMy+AoXS3+kHYRJlTVCXyyEycj+6u+rq8sZpNRVmsXevGGqdIKsVFJkOAvLKLGFimx6j08L6PwjkSYL7AFygdG7rypTQjDo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9a34e37-1b76-4551-05ef-08db577e8d93
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2023 09:02:05.8396
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0DuuxcEff010ZaUCpE1u43qUMbj+EFEqtLmHYtuS4g8m4GGeHkihkeRjHlbgjY4VNNrtZRSV3ZXwbW72yrIqAfuOWYjCAefpfgmdF2Hnt+4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6243
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-18_06,2023-05-17_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305180067
X-Proofpoint-ORIG-GUID: 1PxHoqhJKRyfpI_a9rN2aueaF6wvL61U
X-Proofpoint-GUID: 1PxHoqhJKRyfpI_a9rN2aueaF6wvL61U
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 18/05/2023 09:19, Maxim Levitsky wrote:
> У чт, 2023-05-18 у 11:58 +0800, dengqiao.joey пише:
>> On Wed, May 17, 2023 at 11:32 PM Joao Martins <joao.m.martins@oracle.com> wrote:
>>> On 17/05/2023 13:04, dengqiao.joey wrote:
>>>> This seems to be a different issue. Joao's patch tries to fix the issue
>>>> that IRTE is not changed. The problem I encountered is that IRTE does
>>>> get changed, thus the destination field is also cleared by
>>>> amd_iommu_activate_guest_mode().
>>>
>>> Whether the amd_iommu_activate_guest_mode() clears the destination field or not
>>> doesn't change the situation I think. So I don't think that is the problem
>>> you're having. amd_iommu_activate_guest_mode() will always make IRTEs with
>>> isRun=0. Which means your VF interrupts get injected via GALog events and the
>>> DestID is meaningless there :/ Even if you leave the old affinity there with
>>> isRun=1 bit it's still wrong as by the time you run the vcpu, the wrong affinity
>>> will be used by the VF. More fundamentally I am not sure that on IRTE routing
>>> updates in the VM that you can look on vcpu->cpu the way you are using it could
>>> be potentially invalid when vcpus are blocked/preempted. You're changing IRTEs
>>> in the whole VM in pi_update_irte()
>>>
>>> My changes essentially handle the fact where IRTEs will be always updated with
>>> the right GATag set in the IRTE ... and then when the vCPU migrates, wakes or
>>> block+unblocks it will change IRTE[DestID] with the new pcpu (which the vcpu is
>>> running on) via amd_iommu_update_ga(). So there's a good chance my changes fixes
>>> your affinity issue.
>>>
>>>         Joao
>>
>> Sorry I forgot to mention before that in my application scenario, the vcpu runs on
>> a dedicated isolated cpu and uses "mwait" instead of "halt". So it will not be migrated,
>> blocked/wake and rarely get preempted by other threads. I think your patch can not fix
>> my issue because the vcpu rarely gets the opportunity to execute amd_iommu_update_ga()
>> from vcpu_load().
>>
>> So each time the interrupt affinity is updated I can observe the loss of VF interrupt.
>> After applying my patch, the problem is solved.
>>
> 
> Just to see if I understand the issue correctly:
> > vcpu 'affinity' of hardware interrupt to a guest vCPU
> (which is in AMD case pretty much address of apic backing page + vector)
> 
> changes in these cases:
> 
> 1. when new VFIO device is attached to the VM and the guest enables MSI,
> which triggers attachment of irqfd which is matched with eventfd from the
> hardware device and irq bypass is created.
> 
> 2. when the guest changes the MSI/MSI-X settings - this is similar to 1,
> and can happen any time
> 
> 3. When the vCPU is migrated.
> 
> As I understand the case 1 and 2, the avic_pi_update_irte is called and indeed,
> if the vCPU is already running and in MWAIT/HLT state especially, then
> it will no longer receive doorbell kicks, and the GA log handler won't do anything
> to this vCPU either since it is running (it just does kvm_vcpu_wake_up)
> 
That's by design I think, as the IOMMU will still update the APIC table in the
specified vector of the table. The problem is that it is more inneficient, but
it will still inject the interrupt correctly as activate_guest_mode will also
update the vector and the new descriptor data representing the new vCPU APIC.
The only thing that gets invalidated by vcpu affinity is the doorbell isn't
right as VCPU affinity has changed, and thus we need to update it next vmentry.

> 
> In case 3, the vCPU is loaded again eventually and that calls the 
> avic_update_iommu_vcpu_affinity which calls into iommu 'amd_iommu_update_ga'
> to update target vCPU in the iommu remap entry.
> 
Correct.

I think the issue here is that affinity updates invalidate the current affinity,
and that makes it depend on vcpus wakeups, but if the vCPU never exits the IRTE
is never marked as Running until the next vcpu_load().

> 
> Now it is possible that usually the MSI/MSI-x config space updates don't happen often
> (e.g if guest doesn't migrate interrupts often, or device has per cpu interrupts (e.g nvme)),
> and also vcpu loads/puts mask this, especially since MSI config space update itself is done
> via userspace vmexit (e.g qemu machine model) which also triggers vcpu load/puts.
>
Yeap.

> I think that we do need to a flag indicating if the vCPU is currently running and if yes,
> then use svm->vcpu.cpu (or put -1 to it when it not running or something)
> (currently the vcpu->cpu remains set when vCPU is put)
> 
> In other words if a vCPU is running, then avic_pi_update_irte should put correct pCPU number,
> and if it raced with vCPU put/load, then later should win and put the correct value.
> This can be done either with a lock or barriers.
> 
If this could be done, it could remove cost from other places and avoid this
little dance of the galog (and avoid its usage as it's not the greatest design
aspect of the IOMMU). We anyways already need to do IRT flushes in all these
things with regards to updating any piece of the IRTE, but we need some care
there two to avoid invalidating too much (which is just as expensive and per-VCPU).

> In the current form, this patch is wrong since if the target is sleeping, then it will tell iommu
> to send doorbells to last pCPU the target was running on.
> 
Exactly my point.

> FYI, I had the same issue with my nested avic implementation - when we have a nested vCPU run,
> I need to translate the shadow physid table with the pCPU numbers, and in the same time,
> vCPU migration also triggers update to the same table. I used a lock in the first implementation
> but it can be improved.
>

Interesting.

> As for varibale I used a private svm variable, 'nested_avic_active' which were true only when
> the vCPU is loaded and its nested avic activated.
> 
I had a different take on it largelly based on how we do other things (e.g.
pfncache updates). By the time we update vCPUs affinity we will inevitably
enable GALog with today's semantics, until IRTEs/VCPUs are marked as isRunning
again So what I was doing was asking the vCPUs to go out of guest mode (but not
those that are blocked as that is covered) and request that the individual vCPUs
to update their affinity. This would be another way.

But still quite expensive (as many IPIs as vCPUs updated), but it works as
intended and guest will immediately see the right vcpu affinity. But I honestly
prefer going towards your suggestion (via vcpu.pcpu) if we can have some
insurance that vcpu.cpu is safe to use in pi_update_irte if protected against
preemption/blocking of the VCPU. I would suggest we would get some smarts in
changing affinity, such that the update of the GATag/GAVector/GARootPtr happens
we also has a pcpu in there. Perhaps we could even remove activate_guest_mode()
and just batch all these updates. If you have some changes on the vcpu::cpu I am
happy to try it out on the AMD IOMMU side on top of it.

The snippet below isn't exactly a formal RFC patch (it's better splitted in my
local branch), but I am attaching it anyhow the diffs for discussions purposes.

------------------------------->8----------------------------------
Subject: KVM: SVM: Avoid GALog when updating IRTE affinity

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index fb9d1f2d6136..2dd41dbb51cb 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -113,6 +113,8 @@
        KVM_ARCH_REQ_FLAGS(31, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_HV_TLB_FLUSH \
        KVM_ARCH_REQ_FLAGS(32, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
+#define KVM_REQ_APICV_AFFINITY_UPDATE \
+       KVM_ARCH_REQ_FLAGS(33, KVM_REQUEST_WAIT)

 #define CR0_RESERVED_BITS                                               \
        (~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
@@ -1731,6 +1733,8 @@ struct kvm_x86_ops {
         * Returns vCPU specific APICv inhibit reasons
         */
        unsigned long (*vcpu_get_apicv_inhibit_reasons)(struct kvm_vcpu *vcpu);
+
+       void (*update_apicv_affinity)(struct kvm_vcpu *vcpu);
 };
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index cfc8ab773025..535619a94770 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -39,6 +39,7 @@
  * as far as hardware is concerned.
  */
 #define AVIC_VCPU_ID_MASK              AVIC_PHYSICAL_MAX_INDEX_MASK
+#define AVIC_VCPU_ID_NR                        (AVIC_PHYSICAL_MAX_INDEX_MASK + 1)

 #define AVIC_VM_ID_SHIFT               HWEIGHT32(AVIC_PHYSICAL_MAX_INDEX_MASK)
 #define AVIC_VM_ID_MASK                        (GENMASK(31, AVIC_VM_ID_SHIFT)
>> AVIC_VM_ID_SHIFT)
@@ -878,8 +879,10 @@ get_pi_vcpu_info(struct kvm *kvm, struct
kvm_kernel_irq_routing_entry *e,
 int avic_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
                        uint32_t guest_irq, bool set)
 {
+       DECLARE_BITMAP(vcpu_bitmap, AVIC_VCPU_ID_NR);
        struct kvm_kernel_irq_routing_entry *e;
        struct kvm_irq_routing_table *irq_rt;
+       bool update_affinity = false;
        int idx, ret = 0;

        if (!kvm_arch_has_assigned_device(kvm) ||
@@ -933,8 +936,16 @@ int avic_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
                         * we can reference to them directly when we update vcpu
                         * scheduling information in IOMMU irte.
                         */
-                       if (!ret && pi.is_guest_mode)
+                       if (!ret && pi.is_guest_mode) {
                                svm_ir_list_add(svm, &pi);
+                               if (!update_affinity) {
+                                       bitmap_zero(vcpu_bitmap,
+                                                   AVIC_VCPU_ID_NR);
+                                       update_affinity = true;
+                               }
+                               __set_bit(svm->vcpu.vcpu_id,
+                                         vcpu_bitmap);
+                       }
                } else {
                        /* Use legacy mode in IRTE */
                        struct amd_iommu_pi_data pi;
@@ -979,6 +990,14 @@ int avic_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
        ret = 0;
 out:
        srcu_read_unlock(&kvm->irq_srcu, idx);
+       if (update_affinity) {
+               preempt_disable();
+               local_irq_enable();
+               kvm_make_vcpus_request_mask(kvm, KVM_REQ_APICV_AFFINITY_UPDATE,
+                                           vcpu_bitmap);
+               local_irq_disable();
+               preempt_enable();
+       }
        return ret;
 }

@@ -1012,6 +1031,21 @@ avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu,
int cpu, bool r)
        return ret;
 }

+void avic_update_affinity(struct kvm_vcpu *vcpu)
+{
+       int h_physical_id = kvm_cpu_get_apicid(vcpu->cpu);
+       struct vcpu_svm *svm = to_svm(vcpu);
+       u64 entry;
+
+       entry = READ_ONCE(*(svm->avic_physical_id_cache));
+
+       /* Nothing to do if IsRunning == '0' due to vCPU blocking. */
+       if (!(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK))
+               return;
+
+       avic_update_iommu_vcpu_affinity(vcpu, h_physical_id, true);
+}
+
 void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
        u64 entry;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ca32389f3c36..2f3eb13ac248 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4935,6 +4935,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {

        .vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
        .vcpu_get_apicv_inhibit_reasons = avic_vcpu_get_apicv_inhibit_reasons,
+       .update_apicv_affinity = avic_update_affinity,
 };

 /*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index f44751dd8d5d..c6c47c5c7ad8 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -706,6 +706,7 @@ void avic_vcpu_unblocking(struct kvm_vcpu *vcpu);
 void avic_ring_doorbell(struct kvm_vcpu *vcpu);
 unsigned long avic_vcpu_get_apicv_inhibit_reasons(struct kvm_vcpu *vcpu);
 void avic_refresh_virtual_apic_mode(struct kvm_vcpu *vcpu);
+void avic_update_affinity(struct kvm_vcpu *vcpu);


 /* sev.c */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ceb7c5e9cf9e..62fe938ea1c2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10458,6 +10458,18 @@ static void kvm_vcpu_reload_apic_access_page(struct
kvm_vcpu *vcpu)
        static_call_cond(kvm_x86_set_apic_access_page_addr)(vcpu);
 }

+void kvm_vcpu_update_apicv_affinity(struct kvm_vcpu *vcpu)
+{
+       if (!lapic_in_kernel(vcpu))
+               return;
+
+       if (!kvm_x86_ops.update_apicv_affinity)
+               return;
+
+       kvm_x86_ops.update_apicv_affinity(vcpu);
+}
+EXPORT_SYMBOL_GPL(kvm_vcpu_update_apicv_affinity);
+
 void __kvm_request_immediate_exit(struct kvm_vcpu *vcpu)
 {
        smp_send_reschedule(vcpu->cpu);
@@ -10586,6 +10598,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
                        vcpu_load_eoi_exitmap(vcpu);
                if (kvm_check_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu))
                        kvm_vcpu_reload_apic_access_page(vcpu);
+               if (kvm_check_request(KVM_REQ_APICV_AFFINITY_UPDATE, vcpu))
+                       kvm_vcpu_update_apicv_affinity(vcpu);
                if (kvm_check_request(KVM_REQ_HV_CRASH, vcpu)) {
                        vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
                        vcpu->run->system_event.type = KVM_SYSTEM_EVENT_CRASH;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index cb5c13eee193..cd28aabd28f3 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -317,6 +317,7 @@ bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned
int req,

        return called;
 }
+EXPORT_SYMBOL_GPL(kvm_make_vcpus_request_mask);

 bool kvm_make_all_cpus_request_except(struct kvm *kvm, unsigned int req,
                                      struct kvm_vcpu *except)
