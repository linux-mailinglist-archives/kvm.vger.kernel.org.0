Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15D34662B11
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 17:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232803AbjAIQWH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 11:22:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbjAIQWF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 11:22:05 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B1EC231
        for <kvm@vger.kernel.org>; Mon,  9 Jan 2023 08:22:04 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 309GLSY8026649;
        Mon, 9 Jan 2023 16:21:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=ZvI8iRuKVXqkoM7jG3y0smAQ2FdoNotuFrr5iGevB6s=;
 b=DkW2enW5XPDKt49ddppphKA2Q3d+Zyx8+k8HHjFxh4W/RGCUJ4pWQp7qRi/dsjWtmcZr
 xNPAtwysRCCgSH2KRNjKiauNuIhUqwlWEARKuxfZijz4b6wpp7alIuXCN7n2sQz2yadg
 NBbbnKR631NfCLqy9jQQ0tGQ3igXUxdqiBzqMygFbJF2C6EzGzmvcfLNh9oFSVVPas/j
 N/dOr+SRZabWvw8cipA2rEbCCqvYd/GJtOS93iT4a4hb3c86MSMyHg5x3aqB3tnl9NYf
 cFsvd8Iq0i2+Uf5OyMmROOI2SzNKK/UG6Xbjtx/0SBGssXP2Q1caSqDxyz5v5ana7Fw1 mA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mycxbahdd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Jan 2023 16:21:49 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 309FQxR6035336;
        Mon, 9 Jan 2023 16:21:49 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n0h8ubsad-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Jan 2023 16:21:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J+QNzqfPKrRwK36SyMMgmkmrBpcq89KetnJnFyrMSiKcLBISWalLCR9RSQaDWEgtnimPkL7F3tge6w0ZzP4LKi88jXCACJfbOWllP/uh23d+GfDUh+tJm6XvHQtunBTxDfqvM/O59zG+rZOOvWbQWDzSBRmSCrhzUetGMa3HiHyLbMLxy+xGvt93wqlOe1GWk4bbIaiilys/ytSPY4Q/LaNBEfCxNYwBlWa4vz648WwuBnWgY6alhLamB/xreGUM3ETg3O1FJBSiaIBiYF9nR6lBAY4FxgIZg0cb4Fyrv3KRyTekg+M9WQEHNb+eTL2eO5djfuJ4WzB6NlnuKN+hQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZvI8iRuKVXqkoM7jG3y0smAQ2FdoNotuFrr5iGevB6s=;
 b=ZBi3YMefpJEWmkzunqlQ84QtIRYpDGxrAE9M25ZfswUkQbl2JY9VFRLQ46rBIlUQrcNbXyipGfRDLVPb/ht5PZEjDU8Gm5vVTEYBHyveboe215ZVIe2W5A3GKKTffDAbU50zFIKkOM1p1csshTPryTigIc7aJ4ndkxD3pWnkVHGCj8/Qyp76Nlfn9w9vQt1hkxN43LIH3QvvrJUonV63R0AKrDd1hBT7hrIiQDwEiCo47GZPmaFZc61wHIi1dYSIJBgmDSJ/AnBw9Wk9AxDXIcuMCgtIYrH35l84urg0zc2mnfk5P2oYodL5CxYv4U3VP80lrxjN6cCtKp90d6/yTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZvI8iRuKVXqkoM7jG3y0smAQ2FdoNotuFrr5iGevB6s=;
 b=rHbGviI508hW4oXdGqYQneilHBther+r+xfwL2UDSnsKfQ+1+c+CG7bc7omSo5zzRg3xlhM5KmR6dMBsUF2iTIyu9zG91hTLued9WLhSbC0vtBI1N0VWU/PYD37q7p8yZn9qLBSl/UWeuGStkdeVBWvbixemlmWbNE8j394o4Ic=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BL3PR10MB6017.namprd10.prod.outlook.com (2603:10b6:208:3b0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.9; Mon, 9 Jan
 2023 16:21:47 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b6bd:f4a8:b96f:cf5]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b6bd:f4a8:b96f:cf5%7]) with mapi id 15.20.6002.011; Mon, 9 Jan 2023
 16:21:47 +0000
Message-ID: <30453465-5e90-f8cb-cbe3-4228624816c4@oracle.com>
Date:   Mon, 9 Jan 2023 16:21:33 +0000
Subject: Re: [PATCH V1 vfio 3/6] vfio: Use GFP_KERNEL_ACCOUNT for userspace
 persistent allocations
Content-Language: en-US
To:     Yishai Hadas <yishaih@nvidia.com>, jgg@nvidia.com
Cc:     kvm@vger.kernel.org, kevin.tian@intel.com, leonro@nvidia.com,
        diana.craciun@oss.nxp.com, eric.auger@redhat.com, maorg@nvidia.com,
        cohuck@redhat.com, shameerali.kolothum.thodi@huawei.com,
        alex.williamson@redhat.com
References: <20230108154427.32609-1-yishaih@nvidia.com>
 <20230108154427.32609-4-yishaih@nvidia.com>
 <c413089e-d7b9-8a56-6fe9-73e5b2ef4aa0@oracle.com>
 <adf3f241-0287-25f9-d124-da8f41a4106d@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <adf3f241-0287-25f9-d124-da8f41a4106d@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR02CA0006.apcprd02.prod.outlook.com
 (2603:1096:4:194::8) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|BL3PR10MB6017:EE_
X-MS-Office365-Filtering-Correlation-Id: a6c59848-c5a1-4171-a8fe-08daf25d9a98
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YjODHpzAbxnqHy3FBPeI7AyDcDSRCAC3bcStKZPdBLGumeSVIBRWazWe2lVRG7uyxwRmL7fdZiwshNnVnvm2dBADy3CsT1SpRbo/XcyfX0B8kqskf3utf+FyKTMLhHgYdeYqhka7H+NoRYoGXyCwGGbTVvbP7aw00Nd3oRDV2POIWc20xZkU5CtcnY+rmrGogzX88U6R3Z4Q3PUcR5sz/NMdmYVK96G1XESirp8oZ6M7XtG3xOk/GUH5uOuUGLbCa8fixo36PVQ7iEhaF65gYOm3fblryqXerBgiWHV3N6w3WlGoxrxOSjdS8Qx9SqK1HVLemzdjLAKQAmd2+G6gX3WF4vzBArHO6He13+8+AUctEIVZ6rEj7/iJ1wtzsQ8X9PypLFsClp5e/R62gUjvDYXksJe7+DflY2/6Ayt/btErC1qjBzDYzu+z4Kup8HBsHaB7kqcRk1cSN0Fa+YtVKLpfpX/QYNcq0RSGoxuT+q2SqveePSECkyzSRgO8vE8dm9RULj8DQA4LWXHIf6SeXDATBiYGNEh4NKfhR79WpItw689Qsh4yqEmTPWYX9lJ6SarG4kgvCEmyqzB9c7ewsHRzkdkfmD0mPRHhV5f6vxoWwDnqpZZ2DloKY5ct2yYSv23tJurBw/Q+GEttJ+vf//HnMqTaNTvBM73H21QBKKWX3+X67/gzCXzJgbLApk4O
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(136003)(376002)(396003)(366004)(451199015)(66946007)(8676002)(66556008)(4326008)(7416002)(66476007)(6506007)(53546011)(38100700002)(2616005)(31696002)(41300700001)(478600001)(6486002)(8936002)(316002)(86362001)(26005)(6512007)(2906002)(186003)(5660300002)(6666004)(31686004)(83380400001)(36756003)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bXNmbnZpcXFKaW80L1I0QXRqenp3N2J0UUs2eFBuU0VQOEZuYVBtaDFWdnNS?=
 =?utf-8?B?VTJSMDltbWZtUElOam1PbmZJQzFTNm9vam9oaHNQM1RydzBhWHZ6VTIwdzA1?=
 =?utf-8?B?Umo5ajdaaS9XZDFVN3E4Nkp3bzVid0lrWkRib2V3SUY4Smp6bU5hbjJtMlRT?=
 =?utf-8?B?WE1OUEJkV2ZkaExSTXlzNndkR3l5TFNzdmhzbEN0VjdHckhtL0lyQnZ1N3Zx?=
 =?utf-8?B?cmU5enVZc0o4bHZoenN4L2xjRzd2Q3lxR2xPaDBHQllya3E5c2dXVHo1VTly?=
 =?utf-8?B?OTNONzVXTEdxZWxqb3JKUmJ1U3VkN3Jad0VzdnV0WWNPWnVmT3ROSGpzcEk2?=
 =?utf-8?B?Qm8wVzVBaHBXQVAzNTcwbEpYNTBQYkMwN3JqaTNGYmtnQkU0cDZVQ3F3dG5y?=
 =?utf-8?B?WUNaU1NYUC9ZMllzUFB5VXlrWkNSVTVpcm9FTkpQUy81a0N2QjdHZG5iMVFY?=
 =?utf-8?B?dnZrTGVDdDNOSkJlY0RNcnFWMFNmajFYWjlpL29xcHZKaTg4WWhpRFQ2bGY4?=
 =?utf-8?B?cmEyNnRqbzJ4dWtlUW5NajN2L1RPQ0c2QjhNbUxOY3FZVjJuMmNJWnI4Y3lt?=
 =?utf-8?B?SVBZNmlvOHcxcDg1eUhzN211RFRsaEhhbytQWHdLVEQ0N1NSVG1FQzFFUEpm?=
 =?utf-8?B?TzIyeURHekZham4xQ0toTHZYQVcxc3lpSThjTitXaGdGRHdWTDBNdzlzdjRx?=
 =?utf-8?B?czd6bm1hUEkxZnRiWExJd2ZIMzFPNmpYL3BVUVZ1WG9kaHhaZHNLditwbEdB?=
 =?utf-8?B?djhxRGd1dEFob1BVWFkra05QT21kZDFTc3ZwV2dyUEdva3MvVGlsb2N1RWo2?=
 =?utf-8?B?NWpjQlBQZlcwQU1NQUVRcGRCS3NmNDN5ZHBDL1FiM29WTU1Td2IwSkVzK3d3?=
 =?utf-8?B?VytGalZZMXlCMnBQNFVXWmFaTmQ0UXdwd0pCZnhHNkxrZkdrSlcyUEVWRmI2?=
 =?utf-8?B?cFBRREtjSDJnUnh6eFF6NDF0VTVlOVZNa3h5WDhtd0MvU0FJYysyRjZCVjhZ?=
 =?utf-8?B?NHB2UVZBbkgrOWFSejUwbEtYc0FNMjZ3MHZCTjBWWlhtR3c3SWdVeWw5R1Jz?=
 =?utf-8?B?alFIN3JnMW9Eamxrb2EwZ25yY3pPTjEvL0hNTTMwZ1ZCbktycjRoZU9BQjlV?=
 =?utf-8?B?Q1orRUo5dU02QXBCTE5MM29VdkZGUDlWdnVSbkZhQ2d2di9vamxNb0FLeFFm?=
 =?utf-8?B?azhtL0Q4Y0JNVzlKbGFzS1J2WnBiZFIwL01JcGlvSGRtejhBNXRySHhBYUtx?=
 =?utf-8?B?ekFwTEVEM3FXYng4bklNTTBST3N1OFhqZTh4cUZtZjF5QTh2QjFMVFRmeXhD?=
 =?utf-8?B?T1dYQnl2dWJ1cmJhTjU5TUVtaUh1OVMyWXBSWjNFV0x1YS8rZmZwUnNlMXY3?=
 =?utf-8?B?amxWMWRvZjl2Y0NRaGx1WTdydU9abjFSSGNzZHZ0Q2RlSnRDcnJUSVRYdEhp?=
 =?utf-8?B?Q0xMM1FETXpjMXM1ejJHK3NmaTBzT3M3N2ZXdk03STRkaGp4Ukt5ZEJnRDJs?=
 =?utf-8?B?M0pFUFZ6ZkVuMVVydi9FZS8yWTdmeWc3L3l0K0Fkb0JTUmxLOUNNby9DV09x?=
 =?utf-8?B?Nk8vQjkxcTdzZU93ajNYdStZZnhJUFVlK0I1QVdzM2J1VHEyVzlQRHBDNlBk?=
 =?utf-8?B?eVFhMjlSSndrdlZRMThZbGl3Yk1VclAwbStzdUV3UDNwL25jclpGVGhHbURD?=
 =?utf-8?B?bjVWNkZTQnZYdk5lT1dwMHp1a3c1d3BXekY5RlNPUTg5bG5pRStGMlBuV0Iz?=
 =?utf-8?B?M0FIbkZnODZZYmYvZnl4eUUxN255Q0ZEdmowaEF6dzJkcmFBalNUQ0Y2TWt0?=
 =?utf-8?B?bGFNOS9rTndrQW9FR1lvQ2xCS0xwYUhvUFdvWFBtRGREYjZsM0xFandoOEhI?=
 =?utf-8?B?V3JwWjRZa25wbGszS0xEZm5CWDRDZzhnbFV2elFXb0JrdWFJNGZFS0lLNVJt?=
 =?utf-8?B?Ynk5RUgwWjNNZGtmQkZOa1RYcXpaMGRpOWRWa1ZLSG5rdHNyR3BoZExHNDhk?=
 =?utf-8?B?djNoQTg5ZE83RGtIYjYrT3JZMTRJVjJyU1ozOU1WcHRLaFFQRzJjZjR2OTNX?=
 =?utf-8?B?Vmo0dlppQjlDN1FvVmlyY2tPejJNNnpXTXZ3MFI1RWZYR1RxcVRHaTNGVXh1?=
 =?utf-8?B?c25UVGUvcU9ReEVnSmIzclNlTS84Ryt3c1FZa3JyVkRiYW1DZUw0bTZoVG5Y?=
 =?utf-8?B?Q0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: ZvBKAXzNwxWXXwR4z03mjVh62zrOivQPjiu3yhgeTTlYhBdNLuoOtZWyPXGfj5PrcHthzEJibIjePOIhN5PyUY5v691W3iJnYHJOBwBr7DDrFH0LBPwYIcQ8ft1S47tmQBDymOz02/7/mTnpop4wfKT1Pvvyf4EsHiS3X+yZsHyUnjmmXQewVorq5Nv6jWSNJ6+qO+Wjefq9lQoFp1cI4ANq1ueypp5rGcoychhs/JJuq48GOwVaofdSO6VJY/MjKar9gtwUhCya5E45qDDnnYEssG0pEgZ7k8n0gS7rRTcKfhoKRdMZtMa7bGEfvWefr+AEzhkXIsmUsS7SuDrHlJvpOHM0YossFWdYId5EsV5NudMMOTmL6NGKJckLCMBsRcx3tV0SIRy7T+q9yq1eFFYyD2D9S54Pme4rhpgOnBUUHtuAZ+NJ35N9G52XgAwQLJr3VI7Gsm32hT6WsOjwilGrouUu+sLUZ80L+8G0ECKJouYB+oqR4J9kRYJhu4yzxYCOvgPOT6g7CZ74RspGWfNdoLeNbw+KCDhCR81CawtPV6eoac4DSkxOMkBhholClcX5mos58S0OYh1zOBBZpGch2spSS/qmM5o8jBi0eUue0McFgF5M4aaOzMvSRND2h0fs2VILr9YydO3d4d16VlAhehQOY7N1S9z+4xmTex8CqgQ185HKqmrOTftfFsOktPjwjWPTdzpzVNwIrcSilkqLCzPmA0R39thXOkHIAIBGXKIi309BohVYp3sVWyuH3mOrBYP5nrw76OKxfJlbigk8eKMv5DxB5qfcOnbKjWSjfdP5C+2hWDU+/MPG3zufz0MWXIXLiAz886r1qIPfGIMzca2/q8MJ11bUtcnUlvF0DZWGQHYMIVdb/5fPn02jg0zwy07fg17ngxl7eIOxjA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6c59848-c5a1-4171-a8fe-08daf25d9a98
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2023 16:21:47.0922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hLDhy4YlIf8O74ezkbEwbsTXXVsAWQm8PB/05ZsUi5aMTDTh4FAX2Re7zY0Dy3TgiTP2Ulsa4yFugQ0y2x4IMolhzM/7yLJHY+Vaq9PfZng=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6017
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-09_10,2023-01-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 bulkscore=0 adultscore=0 mlxlogscore=999 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301090118
X-Proofpoint-GUID: 51Vzz6wicURC14wpEgLKlq5j0FkE0ead
X-Proofpoint-ORIG-GUID: 51Vzz6wicURC14wpEgLKlq5j0FkE0ead
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 09/01/2023 16:09, Yishai Hadas wrote:
> On 09/01/2023 17:56, Joao Martins wrote:
>> On 08/01/2023 15:44, Yishai Hadas wrote:
>>> From: Jason Gunthorpe <jgg@nvidia.com>
>>>
>>> Use GFP_KERNEL_ACCOUNT for userspace persistent allocations.
>>>
>>> The GFP_KERNEL_ACCOUNT option lets the memory allocator know that this
>>> is untrusted allocation triggered from userspace and should be a subject
>>> of kmem accountingis, and as such it is controlled by the cgroup
>>> mechanism.
>>>
>>> The way to find the relevant allocations was for example to look at the
>>> close_device function and trace back all the kfrees to their
>>> allocations.
>>>
>>> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>>> ---
>>>   drivers/vfio/container.c           |  2 +-
>>>   drivers/vfio/pci/vfio_pci_config.c |  6 +++---
>>>   drivers/vfio/pci/vfio_pci_core.c   |  7 ++++---
>>>   drivers/vfio/pci/vfio_pci_igd.c    |  2 +-
>>>   drivers/vfio/pci/vfio_pci_intrs.c  | 10 ++++++----
>>>   drivers/vfio/pci/vfio_pci_rdwr.c   |  2 +-
>>>   drivers/vfio/virqfd.c              |  2 +-
>>>   7 files changed, 17 insertions(+), 14 deletions(-)
>>>
>> I am not sure, but should we add the call in the kzalloc done in
>> iova_bitmap_init() too ? It is called from DMA_LOGGING_REPORT | FEATURE_GET. It
>> is not persistent though, but userspace triggerable.
>>
>>     Joao
> 
> You referred to the allocation inside iova_bitmap_alloc() I assume, right ?
> 
Yes.

> In any case, we count persistent allocations, so there is no need.

OK
