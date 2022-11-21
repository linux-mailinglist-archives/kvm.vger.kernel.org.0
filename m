Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9A17632EE5
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 22:34:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbiKUVel (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 16:34:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbiKUVej (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 16:34:39 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ABEB2BEF
        for <kvm@vger.kernel.org>; Mon, 21 Nov 2022 13:34:35 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ALK6FVQ000908;
        Mon, 21 Nov 2022 21:33:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=4KVBZa1ZTdw+56Et9duF6rbxN+R09MqQciDfw3Oxa/Y=;
 b=NmSiV5XdeMWLllUpLoB+RsP0UCk1mcBD1G9Ar/7BskGffaHX2Pr1sg427mxofnPJTAMO
 1+b5QbZb1icp/Gv1Q3zmWPSM9zGU5OQxoQ7Wi4Q8wY0ybbYGxZPKw0zBMvwvFlJMCrmi
 pyTw5ap2cXc4xegFGo7045tjkm8pxP/T0LD1//priqXVJUx6jZe0vtkMklWX2G8+0ye5
 rSq1peBnip8RPW9VsDpDZUPJPx/ZyH7I81FUqq14DT1d91qTTR3UqmeKn1w9QC3htqox
 L3bVkvSGEbd7CqF9SkpJIKNBPP4vH87XKEbkpjSSlQI+vctL6AR43GyHPi5xGIXKeDkA Eg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m0edq0k6f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Nov 2022 21:33:18 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2ALKZllb038773;
        Mon, 21 Nov 2022 21:33:17 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2047.outbound.protection.outlook.com [104.47.51.47])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnk4bcwy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Nov 2022 21:33:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=epj+azXWxOd3Wum/VBVaDzSCeBRUAK0+V9z8FzgogVQTEeaL+mlYKopyI+p/Sytrdz7epXtPESTNpHGcWRAW5MLSE+cjcjRePPRVZcggqL33/gwgVjCog0lnw9GVYaXeqiKsRp/ISpjA+Dhz1nmCvUpCAbuHj2SqhSkXMTgoU6Wnc2QpzD0fzZrWguP/JBgth0i/WVIzdDrw/5KxjcBPCdb1sM5vUJ+iNEQCq2NsG47xh4nALM8tIb95xvSqFKAQ6U8btCKY/UIKhJwuTDuTunm9YALptWTdROrMXKnFs71tT3+EuqAzRvgJOMtGEPxmZEd9WPqMoQjClm10HUKDhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4KVBZa1ZTdw+56Et9duF6rbxN+R09MqQciDfw3Oxa/Y=;
 b=Dejx9q9pdQKOx67+uHsU4bLoscVu0KTDPqs2NNKXxdzr4mjq/LHP3cbpN5gHMGOT1TqbssIhOfuODr2PbxnvbUkxdRw+kcaBwhb/1J5s+V/ZiRCJH1aDCMEpzU/wyLHG+XQoe1vYMiddKTA/AWItfwiXPuc+c9pOzrqe/CJL44oUEXn1RqF40nwwhnnthMCIq0jGP6WYjHX59s5Q2mWk1EHmhEhe44wzqa8OKOPcihLVwZY24NfzdYwGfU0ignEU0UfFiM2/JJmO+FxmDE16UOHrhT7g6cTxdrwh5im+fhQMu7uMurxK4gLQ24kVkX9Q1muQ9bdkUBrMYe42yZAOfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4KVBZa1ZTdw+56Et9duF6rbxN+R09MqQciDfw3Oxa/Y=;
 b=zw+Hj3mGiX96ymqAvPUYWZH39rVdYW9EvnxdFRFFFkwbKK9ZtmgIvQbD7JHGI32ckJ9ue1Od9F/KgbYYHkPje/9bblHkYb+Va+gSBWQLsnYYraiNw0H2Tf1Ez25Q9RDWt950ieLMwwfFOmVesO6vp2ayk+/ek3ze/tLDPf8KDCM=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by SJ0PR10MB4605.namprd10.prod.outlook.com (2603:10b6:a03:2d9::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Mon, 21 Nov
 2022 21:33:11 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::cf3b:2176:14e5:d04d]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::cf3b:2176:14e5:d04d%4]) with mapi id 15.20.5834.015; Mon, 21 Nov 2022
 21:33:10 +0000
Message-ID: <8efac1e4-1671-1c2a-f21d-04ada3500af9@oracle.com>
Date:   Mon, 21 Nov 2022 13:33:05 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH 3/3] target/i386/kvm: get and put AMD pmu registers
Content-Language: en-US
To:     Liang Yan <lyan@digitalocean.com>
Cc:     pbonzini@redhat.com, peter.maydell@linaro.org, mtosatti@redhat.com,
        chenhuacai@kernel.org, philmd@linaro.org, aurelien@aurel32.net,
        jiaxun.yang@flygoat.com, aleksandar.rikalo@syrmia.com,
        danielhb413@gmail.com, clg@kaod.org, david@gibson.dropbear.id.au,
        groug@kaod.org, palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pasic@linux.ibm.com,
        borntraeger@linux.ibm.com, richard.henderson@linaro.org,
        david@redhat.com, iii@linux.ibm.com, thuth@redhat.com,
        joe.jin@oracle.com, likexu@tencent.com, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-ppc@nongnu.org, qemu-s390x@nongnu.org,
        qemu-arm@nongnu.org, qemu-riscv@nongnu.org
References: <20221119122901.2469-1-dongli.zhang@oracle.com>
 <20221119122901.2469-4-dongli.zhang@oracle.com>
 <8b197d19-a43a-3b29-3a05-c92a09e28d5f@digitalocean.com>
From:   Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <8b197d19-a43a-3b29-3a05-c92a09e28d5f@digitalocean.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9P223CA0011.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:806:26::16) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|SJ0PR10MB4605:EE_
X-MS-Office365-Filtering-Correlation-Id: 049ec59d-f023-4a4f-acdc-08dacc07fce0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ei7b0eKk0LJliTI1GcyQ8bUccTM38CtIBldSU8HbPEqaE+/WfQtl9N4su1cTdaVOkvQPJtRgMxohaXAO+Be+KqHLCOYAAPUBxB32Urk3uka+cDaTBKQnrFPpY1gC+GianpZBaOxhBsP0i8qDRdlVIS63is/L8tkQ8OvDpfapNhN96LbGa0l2q2bTOPXMkZMs8QrLNVwRtsp/i8Gwhu9O7McDuI6tp9vfoZSWXMMyTnI+k7fZjJBw7fM3kflERscwHkeFIJOj7Cl5IzLyu5cuQQKpk37o/N/p2zIhorZqY75pSBgRg2pduVLAntr8BV/pYOp5cczt+gx2CEt+/wxLR5ZuB3lOA99vBVOMTBByJTxOw0uOtGNgUJUfj7VSv/KQJKL1gQTQeTpqz0svjfxiklapu6WjmbUEaYvgb8CMXTRIp+5rKNdUjubIWfZVfgwlPfFsybRJX2E9IHNkI9ZtAhedleI7eTkfTGuahxkMyZ1FmWUT/bsMrNbAqf9O9S8R7j/fLvyJktRHyPoMJdxX4sa6z9Ri8Dtr1AsdQ5m1EZO8BhiU2i3kL7zzeaAYbCuTW0pUwrLwIiXlYuKI9aoBpfWGk7+B/KicVCMZkbNTVn95dLhQSLfwL6yuxm0KvR6AHZTX8FLg3LX85OEqpxpewmPfzF7VM1+Sda9jbefmEvoxhjeEUC11SK3B8LEZ8Z2eVjyVU63o+nRRlJ9Kbq/+mZ59qznuHsozR68tHE9mLVRUYF2vRkWqTnYOFIwXzyG9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(136003)(346002)(39860400002)(376002)(451199015)(6666004)(478600001)(6486002)(966005)(31686004)(66556008)(36756003)(66946007)(6512007)(41300700001)(8676002)(66476007)(4326008)(30864003)(186003)(2616005)(8936002)(44832011)(7416002)(5660300002)(316002)(53546011)(6506007)(6916009)(83380400001)(2906002)(86362001)(31696002)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YllJSGcrSzBnS0pMZ01PWktEdUUrZ2xwUGdwNTJNWGhUZDVrbjQwbkRJNXoy?=
 =?utf-8?B?L2JlYjFpa0xCc0RXemdNSEw4aDdSK0dwVDVzZkpGcDRKdEgzc0JwRGdSakh4?=
 =?utf-8?B?aENNVHR4SzJZZ3U1ek5ibWtrTWRGb29BcmJKZTNRbmUyUDB2cmtFVzA4TitU?=
 =?utf-8?B?TGVuTlhVbHlINGZleGVvMER3RWNEbmlNM1dQUXVrN2ZaNzM4Qmc0TmpyNWdk?=
 =?utf-8?B?UUhRMFFReWVKNnNnR1ZyQ3pZSzYwemRIUFVuUit2eEQ3bHI4QUIyVWNaY3NK?=
 =?utf-8?B?UEx2eThNWXFsa2N5M3dxdVZuOE5pRGZJQmxCTTgvRjdjenlGNHBVZ045bzVm?=
 =?utf-8?B?NWNpb1hFMEtwZ1JsMklHMFEzblRBNlNjalBURmU2S0pEL2srZnRvWmVaSlo4?=
 =?utf-8?B?VDY0Q05TaVVxTGVHQTlPZU15MmRtV1hSdGtTUDhib2gzRlZVck1hZkcyNmU3?=
 =?utf-8?B?S1dZbCtyUzBYVnYxejZ2ZW9DYmdueTZTMTBIWm9nN2FWY0NBSEhvN0xxT2Y4?=
 =?utf-8?B?d09VcUN3VDgzRjY4NlBOQVkrVnRUTkJLUHhPSHpSaE1nNStocVpka0RBdVRN?=
 =?utf-8?B?a3dPY2FMNVFjYndKdVp3cThSemU2ZTlENUsxNkpabDU3SlBCd0lwNXg5cmF3?=
 =?utf-8?B?UFBoTmVrMXUrc2xGenRCOUdYazFFTjIwWlVoMjZ3SVBCNVJXTmtFQXpLTS9R?=
 =?utf-8?B?dDlUREZEd0lNaXRLYTBoSjhCQlZYdUY4OWRNZFJ4VGpIL1ZtVzVWTUs1MGpP?=
 =?utf-8?B?QjFINU5WOHJHaVYyQVFKQmhwMWlhL1NFNkRjQWxWRTg0Ymd3aWtBSnVLcldY?=
 =?utf-8?B?SHI3MHNBN0FiMWR4Wm1JMDY5MHdjdm1aZUhiM2JLaGkrUUZDNEpxb0s2N1I5?=
 =?utf-8?B?SVEvS3NYVkthM1k4UlVUSVpIWW96ZG5BcGlOR2N3VUd4TDEwdzRIVlp0MjRM?=
 =?utf-8?B?dGFzVS9tdTNVV1NiZFByZE1vZTEyRkNKakp3bVpURzRhVGxQa0JFWGNPeWV6?=
 =?utf-8?B?cG1ORy9tbGl3UHg2NGg1V1EySVh3azl5NWlwd291NFlud09NUVdWdVluTG4v?=
 =?utf-8?B?N1RkdGxSTlpodTZEaS8rRG5CNHVIejg3UHRPRGdvL2N3elFOZHhxN1p1WHVt?=
 =?utf-8?B?L09YZm4zeHI4MG1xQWVWdXlXYWZSeTNUT2ZLTWFVYnZGRU1wOXZDZnFGRytV?=
 =?utf-8?B?NWdZRSs3ZlM2RkhDVnUyS3lhZjJVcHdJU0piTnlqeHc1bFhkL2tBWHlRV2Y3?=
 =?utf-8?B?T21IL2l5MWJlK1NBeEdUN1B0eGRObFBsUThObW0zV1VmNnlaUWpuWTZSNmxN?=
 =?utf-8?B?cjJQK1QwUHVyODQ1Qmh6UmVtUXZYUTVaY3d2WGNNUWhSTG1YTlFKbVRMSXhn?=
 =?utf-8?B?WEhHS0JMZml1eXRhM2tXY2hXL0liYW5oVE8zelJETTlWUFF1Z2R1cG9ldDBU?=
 =?utf-8?B?c3hRV0gxSGV4VlpEMUJXNlBJUEIwVjBwMWI3TktnK3daMXNIa2FaQjQ0Q1JX?=
 =?utf-8?B?TzRxNnBEOC82eFd4MkdJblJjcytPL2xaRkVYOTdYQ1pqNDMvbHplUjVvL2du?=
 =?utf-8?B?aXplUVdaS3BMSnE3a3NJZkxiYnpaMFlQaW9yd0NZYjEwTjNQS1dpSTl0bVNy?=
 =?utf-8?B?ZThkL3daTHdOQm80RGdmYWdzOUtuYkszZlZHZjU3MGZvUlRKbGR5NFZXZTQ2?=
 =?utf-8?B?L2U3UG94ZHVIVE5hMWdMdUpqaVBZbUhyWXppWG9uU1JGWnh1bnN1SUlGQjky?=
 =?utf-8?B?KzNWVGkrNGp1N2oxeWQwTUkzRUY5Z1VjMDhrZEdzRjFQQVBqb2I4Rjcza202?=
 =?utf-8?B?Nk1GTVlXWVhNUlQ1ODZaL0hhSTl5OTZWL1RFRExTOXNOUEQxcWp1TmJqcXVq?=
 =?utf-8?B?ckZxVEJIWFNCaG1iSVlGa2pER1RqTFU5WUhhSk5uV1F2c3NRQ0s2SHByblgv?=
 =?utf-8?B?OGpoUzQyS1BkVGFmN1FYdFc0QjRSS3lsTXE5SHN4NS9FK290VW92UERtVkN3?=
 =?utf-8?B?emNQbzNBVGt6R3RiSE0zdE9YbGNDaWZUSnN4akhlaSswdks2Q01uN0daa1k0?=
 =?utf-8?B?b3FaSnlwNjZZS3JDNmVKNUVVcEI5NWNXeTR4QUJlYjMzS1NibDJrS2ZyRDN3?=
 =?utf-8?B?azBrNndhaklTSUlSTzQrOUZJenlLWkFSR2JyQWdrVTZCOU1ma2FaeVRFYzJX?=
 =?utf-8?Q?z89sA9oqLgxcQne8djyC4jA=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?M2lqcnlaeEhrYllOMXlnYnVzcnF1OVhFV0I2UGxOS2U4L2VtaFgxWnlZTklL?=
 =?utf-8?B?WFk2Y1BtS1czaTlNdmdtYXhVaS92WUQxaExqTkJ3eDZvb1lsd3UyVTJxR2NP?=
 =?utf-8?B?NEdQVTVkbFZrazlMQ1l6NktoMktDY3JDK3ZQWlh5bHBlRmcvSVpmOWdwMkt0?=
 =?utf-8?B?UjZLNDhVTU5RWVRlWTcrMm1SSzBDZmMrbzJZY3JHUkErcGczTkloc2k2amhy?=
 =?utf-8?B?WndMTFY5K3RncVUreUxHU25GMTNqV0lYaU1lK1RVL3NTVjNlRW1XUTFHNHZB?=
 =?utf-8?B?NmVGMHhLRDFxWjU1UjZaTjJmSGh6UzNlS2tWMTZWSlFBUE0wdkFPWDJDanFp?=
 =?utf-8?B?L2g3NUcyMUdRbHFuTkFSbm1SNEwxVzI3K1RQU3FRaHgxYURXeWlWR2NrZ1Z4?=
 =?utf-8?B?RkplNzIwUEdvVkVlOFNvR0RicWdVSkZ6ai8yZHRRU3dwVjQzclhEVU5Ed0lJ?=
 =?utf-8?B?eE0ySTNYN3kvSTFNNkV4RWovY2VUalhpSlJiRFh3aUJQa1BNeHNOeE1xbFdl?=
 =?utf-8?B?ZlVGL0JMSEIveGJoUzJJUHVlenRiZWc0V3FwTGxlMEVVbkhvbU9zelFzV1FT?=
 =?utf-8?B?SVIzamtNeHhsVXl5UG53MGVuQWlncHNYWEQ5Z0ZERUd3RkRXOSs2ZksvZFNO?=
 =?utf-8?B?cUVRYkY1ZW0yWjRNV2dHMVRJMFg2bGVrelpES1NCc3Y5blJMb0lHZk85WTlr?=
 =?utf-8?B?blk4RUtDMFlieG9rL3JKYkhsaHFpRVNScXdBWkNybGZPTkFSVjlrZHVuazVB?=
 =?utf-8?B?T0JWTktaZE1FcC9HMkZ5Y2NhMWJQWUFpSlhlVEdLYWZsdjRYOWJxNEpidjBy?=
 =?utf-8?B?YjVNRHlsMFdKSllOWmNoMnE3cWNmN0pFUHI2cmh1R2ZHZTJubEllVWp1Y2RT?=
 =?utf-8?B?amhOamI3UnlCczk4Unk0YkhLclZnWlZaVjlvNTh0WHZEckZXTWo3U1Zuc0xW?=
 =?utf-8?B?VmNubEx2SmVUOW5HWmZRT1lGMWFhanNXc3lSbUFCRnFRQXJsZXFTUHU5ME5H?=
 =?utf-8?B?SGJDeUYwTFR1STRqcU9PaS9kaXR5WThWUms3Ykl3KzFyN24vWFpBdTRsci9M?=
 =?utf-8?B?ek9PNUxLWlZrQ1hVRHBQMHBHTytNVUJWNjhEVkFuN01XdnlEcVNQTENyemlL?=
 =?utf-8?B?T1g5aXpsRHF1QjhSelNjVG96ZDBrOW16SmFmQmUwSDMzZktFcFZoK2RXc1FE?=
 =?utf-8?B?b1FJcWt5UXpXRmZtYXBFMVNUbEdqOWJnWW44UzJ3WU54cFM1WSt5ZGxoNm5L?=
 =?utf-8?B?VEJmbG0rc0lheE5kQVRGNXRtOHdCQlBqT2pXYm5GeHdSci9XK3R0WiswakZo?=
 =?utf-8?B?UXJIRXBIRmtacjk1UTNlN3hMb0xmanNPYUZiVHBSUUNFUFJZaUgvb05EbWlk?=
 =?utf-8?B?Y3kxdTEyVy9VbW9tRWphdXVGU1A0VVhqZGVjOXhXdkk5aFh1ODYwa3dUYVcx?=
 =?utf-8?B?UnlJTlZLNWRTRkFCN3FzMWxydVdVTkJVNVJRUnFtV2tiS2hxcVBmMmFmcVVN?=
 =?utf-8?B?WlRuc0hTYVdMTXNzQkxaRDRhcm0zTG82WTV5WjRSbWo5M1ErQmErRnNMSDNE?=
 =?utf-8?B?TXBQd3NEaUJKUUhuTUxZUGlzWndPS3Y1Y2lBMW1qY3AyV1pEcjE1S0MwMmNy?=
 =?utf-8?B?MWNsQnBGeHpkclF3UHcwYW4zQzZVelQyQUxoOEZaNzZmYTF0SWtkWEpqNXpY?=
 =?utf-8?B?T3QreGI5REF2UXhoenlCQjkxR0QvZGtRaXYybldvMW9kS2ZyM2NHb2dKb28r?=
 =?utf-8?B?SzlIQUE5SFZGb3lMdjZ5N1JqWUdJT2x6TkJnaU8wRlg5QWVoQzlnaFI3ejRa?=
 =?utf-8?B?MjgrSHBJR09nazBzUFZuRlFSQ0FtL2xZYmVsUnl5V21oTVdzRVJNVXlPYU91?=
 =?utf-8?B?RFB6ZkZxNVQrd2Y3a2Y2YVdlb0pXUmprcUxsVndXN2hTaHF6Y3lSWU43L2dI?=
 =?utf-8?B?OXhMTmdzMzNxNm04cWZDbDd0QThKMTYzL1ZuOUxvSHcyaGVMcTlNR1Zpb1Zm?=
 =?utf-8?B?blVrNm9meEoveHFMcjhGZitiMFREZHphb1drZ1UwMENRR0FGREFxZGEzeVNS?=
 =?utf-8?B?bHNadm1GaytKTjdPMURKUENoSHpTbmZCdWVIYTdxdllraE03emlsZmExazR1?=
 =?utf-8?B?TTNhVitpVDZkYjVZUGVDYXRCSVFwbFcvdXJqNWZOb1pyRzM0VkxWS1ZTNkpC?=
 =?utf-8?Q?fSAe5KtW1R6KrHHPGSOwRXcNeOo9U7vdj+qe0LfmK4pf?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 049ec59d-f023-4a4f-acdc-08dacc07fce0
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2022 21:33:10.9047
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zf4PFcqcvInjyHoVjpiPBhWRoCelO+cCBHhx4NyiI4Hn9baLeALTgZOvFCdbshi5Q/orxIXsbyBDuEl0L6QRAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4605
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_18,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 spamscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211210162
X-Proofpoint-GUID: K3OTtntlbQqxB_xYMKJVvAhcsYzc5aNe
X-Proofpoint-ORIG-GUID: K3OTtntlbQqxB_xYMKJVvAhcsYzc5aNe
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Liang,

On 11/21/22 6:28 AM, Liang Yan wrote:
> A little bit more information from kernel perspective.
> 
> https://urldefense.com/v3/__https://lkml.org/lkml/2022/10/31/476__;!!ACWV5N9M2RV99hQ!NHxyuDAt7ZD4hlsoxPCIUSRsPzaii0kDx2DrS7umBMoKVD8Z6BH7IKvPu8p0EhBBTEqQkCMfTk1xoj-XzT0$
> 
> 
> I was kindly thinking of the same idea, but not sure if it is expected  from a
> bare-metal perspective, since the four legacy MSRs
> 
> are always there. Also not sure if they are used by other applications.
> 
> 
> ~Liang

Can I assume you were replying to the the patch ...

[PATCH 2/3] i386: kvm: disable KVM_CAP_PMU_CAPABILITY if "pmu" is disabled

... but not this one which is about to save/restore PMU registers?

[PATCH 3/3] target/i386/kvm: get and put AMD pmu registers


About the legacy registers, here is my understanding just based on the linux amd
source code.

The line 1450 indicates the PMU initialization is failed only when the family is
< 6. The amd_core_pmu_init() at line 1455 will decide whether to use PERFCTR_CORE.

1445 __init int amd_pmu_init(void)
1446 {
1447         int ret;
1448
1449         /* Performance-monitoring supported from K7 and later: */
1450         if (boot_cpu_data.x86 < 6)
1451                 return -ENODEV;
1452
1453         x86_pmu = amd_pmu;
1454
1455         ret = amd_core_pmu_init();
1456         if (ret)
1457                 return ret


By default (when family < 6), the below 4 legacy registers are used.

1270 static __initconst const struct x86_pmu amd_pmu = {
1271         .name                   = "AMD",
... ...
1279         .eventsel               = MSR_K7_EVNTSEL0,
1280         .perfctr                = MSR_K7_PERFCTR0,

#define MSR_K7_EVNTSEL0                 0xc0010000
#define MSR_K7_PERFCTR0                 0xc0010004
#define MSR_K7_EVNTSEL1                 0xc0010001
#define MSR_K7_PERFCTR1                 0xc0010005
#define MSR_K7_EVNTSEL2                 0xc0010002
#define MSR_K7_PERFCTR2                 0xc0010006
#define MSR_K7_EVNTSEL3                 0xc0010003
#define MSR_K7_PERFCTR3                 0xc0010007


If PERFCTR_CORE is supported, counters like below are used, as line 1368 and 1369.

1351 static int __init amd_core_pmu_init(void)
1352 {
1353         union cpuid_0x80000022_ebx ebx;
1354         u64 even_ctr_mask = 0ULL;
1355         int i;
1356
1357         if (!boot_cpu_has(X86_FEATURE_PERFCTR_CORE))
1358                 return 0;
1359
1360         /* Avoid calculating the value each time in the NMI handler */
1361         perf_nmi_window = msecs_to_jiffies(100);
1362
1363         /*
1364          * If core performance counter extensions exists, we must use
1365          * MSR_F15H_PERF_CTL/MSR_F15H_PERF_CTR msrs. See also
1366          * amd_pmu_addr_offset().
1367          */
1368         x86_pmu.eventsel        = MSR_F15H_PERF_CTL;
1369         x86_pmu.perfctr         = MSR_F15H_PERF_CTR;
1370         x86_pmu.num_counters    = AMD64_NUM_COUNTERS_CORE;

#define MSR_F15H_PERF_CTL               0xc0010200
#define MSR_F15H_PERF_CTL0              MSR_F15H_PERF_CTL
#define MSR_F15H_PERF_CTL1              (MSR_F15H_PERF_CTL + 2)
#define MSR_F15H_PERF_CTL2              (MSR_F15H_PERF_CTL + 4)
#define MSR_F15H_PERF_CTL3              (MSR_F15H_PERF_CTL + 6)
#define MSR_F15H_PERF_CTL4              (MSR_F15H_PERF_CTL + 8)
#define MSR_F15H_PERF_CTL5              (MSR_F15H_PERF_CTL + 10)

#define MSR_F15H_PERF_CTR               0xc0010201
#define MSR_F15H_PERF_CTR0              MSR_F15H_PERF_CTR
#define MSR_F15H_PERF_CTR1              (MSR_F15H_PERF_CTR + 2)
#define MSR_F15H_PERF_CTR2              (MSR_F15H_PERF_CTR + 4)
#define MSR_F15H_PERF_CTR3              (MSR_F15H_PERF_CTR + 6)
#define MSR_F15H_PERF_CTR4              (MSR_F15H_PERF_CTR + 8)
#define MSR_F15H_PERF_CTR5              (MSR_F15H_PERF_CTR + 10)

Unfortunately, I do not have access to machine with family < 6. It might be
interesting to use QEMU to emulate a machine with family < 6.

Thank you very much for suggestion!

Dongli Zhang


> 
> 
> On 11/19/22 07:29, Dongli Zhang wrote:
>> The QEMU side calls kvm_get_msrs() to save the pmu registers from the KVM
>> side to QEMU, and calls kvm_put_msrs() to store the pmu registers back to
>> the KVM side.
>>
>> However, only the Intel gp/fixed/global pmu registers are involved. There
>> is not any implementation for AMD pmu registers. The
>> 'has_architectural_pmu_version' and 'num_architectural_pmu_gp_counters' are
>> calculated at kvm_arch_init_vcpu() via cpuid(0xa). This does not work for
>> AMD. Before AMD PerfMonV2, the number of gp registers is decided based on
>> the CPU version.
>>
>> This patch is to add the support for AMD version=1 pmu, to get and put AMD
>> pmu registers. Otherwise, there will be a bug:
>>
>> 1. The VM resets (e.g., via QEMU system_reset or VM kdump/kexec) while it
>> is running "perf top". The pmu registers are not disabled gracefully.
>>
>> 2. Although the x86_cpu_reset() resets many registers to zero, the
>> kvm_put_msrs() does not puts AMD pmu registers to KVM side. As a result,
>> some pmu events are still enabled at the KVM side.
>>
>> 3. The KVM pmc_speculative_in_use() always returns true so that the events
>> will not be reclaimed. The kvm_pmc->perf_event is still active.
>>
>> 4. After the reboot, the VM kernel reports below error:
>>
>> [    0.092011] Performance Events: Fam17h+ core perfctr, Broken BIOS detected,
>> complain to your hardware vendor.
>> [    0.092023] [Firmware Bug]: the BIOS has corrupted hw-PMU resources (MSR
>> c0010200 is 530076)
>>
>> 5. In a worse case, the active kvm_pmc->perf_event is still able to
>> inject unknown NMIs randomly to the VM kernel.
>>
>> [...] Uhhuh. NMI received for unknown reason 30 on CPU 0.
>>
>> The patch is to fix the issue by resetting AMD pmu registers during the
>> reset.
>>
>> Cc: Joe Jin <joe.jin@oracle.com>
>> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
>> ---
>>   target/i386/cpu.h     |  5 +++
>>   target/i386/kvm/kvm.c | 83 +++++++++++++++++++++++++++++++++++++++++--
>>   2 files changed, 86 insertions(+), 2 deletions(-)
>>
>> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
>> index d4bc19577a..4cf0b98817 100644
>> --- a/target/i386/cpu.h
>> +++ b/target/i386/cpu.h
>> @@ -468,6 +468,11 @@ typedef enum X86Seg {
>>   #define MSR_CORE_PERF_GLOBAL_CTRL       0x38f
>>   #define MSR_CORE_PERF_GLOBAL_OVF_CTRL   0x390
>>   +#define MSR_K7_EVNTSEL0                 0xc0010000
>> +#define MSR_K7_PERFCTR0                 0xc0010004
>> +#define MSR_F15H_PERF_CTL0              0xc0010200
>> +#define MSR_F15H_PERF_CTR0              0xc0010201
>> +
>>   #define MSR_MC0_CTL                     0x400
>>   #define MSR_MC0_STATUS                  0x401
>>   #define MSR_MC0_ADDR                    0x402
>> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
>> index 0b1226ff7f..023fcbce48 100644
>> --- a/target/i386/kvm/kvm.c
>> +++ b/target/i386/kvm/kvm.c
>> @@ -2005,6 +2005,32 @@ int kvm_arch_init_vcpu(CPUState *cs)
>>           }
>>       }
>>   +    if (IS_AMD_CPU(env)) {
>> +        int64_t family;
>> +
>> +        family = (env->cpuid_version >> 8) & 0xf;
>> +        if (family == 0xf) {
>> +            family += (env->cpuid_version >> 20) & 0xff;
>> +        }
>> +
>> +        /*
>> +         * If KVM_CAP_PMU_CAPABILITY is not supported, there is no way to
>> +         * disable the AMD pmu virtualization.
>> +         *
>> +         * If KVM_CAP_PMU_CAPABILITY is supported, "!has_pmu_cap" indicates
>> +         * the KVM side has already disabled the pmu virtualization.
>> +         */
>> +        if (family >= 6 && (!has_pmu_cap || cpu->enable_pmu)) {
>> +            has_architectural_pmu_version = 1;
>> +
>> +            if (env->features[FEAT_8000_0001_ECX] & CPUID_EXT3_PERFCORE) {
>> +                num_architectural_pmu_gp_counters = 6;
>> +            } else {
>> +                num_architectural_pmu_gp_counters = 4;
>> +            }
>> +        }
>> +    }
>> +
>>       cpu_x86_cpuid(env, 0x80000000, 0, &limit, &unused, &unused, &unused);
>>         for (i = 0x80000000; i <= limit; i++) {
>> @@ -3326,7 +3352,7 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
>>               kvm_msr_entry_add(cpu, MSR_KVM_POLL_CONTROL,
>> env->poll_control_msr);
>>           }
>>   -        if (has_architectural_pmu_version > 0) {
>> +        if (has_architectural_pmu_version > 0 && IS_INTEL_CPU(env)) {
>>               if (has_architectural_pmu_version > 1) {
>>                   /* Stop the counter.  */
>>                   kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
>> @@ -3357,6 +3383,26 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
>>                                     env->msr_global_ctrl);
>>               }
>>           }
>> +
>> +        if (has_architectural_pmu_version > 0 && IS_AMD_CPU(env)) {
>> +            uint32_t sel_base = MSR_K7_EVNTSEL0;
>> +            uint32_t ctr_base = MSR_K7_PERFCTR0;
>> +            uint32_t step = 1;
>> +
>> +            if (num_architectural_pmu_gp_counters == 6) {
>> +                sel_base = MSR_F15H_PERF_CTL0;
>> +                ctr_base = MSR_F15H_PERF_CTR0;
>> +                step = 2;
>> +            }
>> +
>> +            for (i = 0; i < num_architectural_pmu_gp_counters; i++) {
>> +                kvm_msr_entry_add(cpu, ctr_base + i * step,
>> +                                  env->msr_gp_counters[i]);
>> +                kvm_msr_entry_add(cpu, sel_base + i * step,
>> +                                  env->msr_gp_evtsel[i]);
>> +            }
>> +        }
>> +
>>           /*
>>            * Hyper-V partition-wide MSRs: to avoid clearing them on cpu hot-add,
>>            * only sync them to KVM on the first cpu
>> @@ -3817,7 +3863,7 @@ static int kvm_get_msrs(X86CPU *cpu)
>>       if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_POLL_CONTROL)) {
>>           kvm_msr_entry_add(cpu, MSR_KVM_POLL_CONTROL, 1);
>>       }
>> -    if (has_architectural_pmu_version > 0) {
>> +    if (has_architectural_pmu_version > 0 && IS_INTEL_CPU(env)) {
>>           if (has_architectural_pmu_version > 1) {
>>               kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
>>               kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_CTRL, 0);
>> @@ -3833,6 +3879,25 @@ static int kvm_get_msrs(X86CPU *cpu)
>>           }
>>       }
>>   +    if (has_architectural_pmu_version > 0 && IS_AMD_CPU(env)) {
>> +        uint32_t sel_base = MSR_K7_EVNTSEL0;
>> +        uint32_t ctr_base = MSR_K7_PERFCTR0;
>> +        uint32_t step = 1;
>> +
>> +        if (num_architectural_pmu_gp_counters == 6) {
>> +            sel_base = MSR_F15H_PERF_CTL0;
>> +            ctr_base = MSR_F15H_PERF_CTR0;
>> +            step = 2;
>> +        }
>> +
>> +        for (i = 0; i < num_architectural_pmu_gp_counters; i++) {
>> +            kvm_msr_entry_add(cpu, ctr_base + i * step,
>> +                              env->msr_gp_counters[i]);
>> +            kvm_msr_entry_add(cpu, sel_base + i * step,
>> +                              env->msr_gp_evtsel[i]);
>> +        }
>> +    }
>> +
>>       if (env->mcg_cap) {
>>           kvm_msr_entry_add(cpu, MSR_MCG_STATUS, 0);
>>           kvm_msr_entry_add(cpu, MSR_MCG_CTL, 0);
>> @@ -4118,6 +4183,20 @@ static int kvm_get_msrs(X86CPU *cpu)
>>           case MSR_P6_EVNTSEL0 ... MSR_P6_EVNTSEL0 + MAX_GP_COUNTERS - 1:
>>               env->msr_gp_evtsel[index - MSR_P6_EVNTSEL0] = msrs[i].data;
>>               break;
>> +        case MSR_K7_EVNTSEL0 ... MSR_K7_EVNTSEL0 + 3:
>> +            env->msr_gp_evtsel[index - MSR_K7_EVNTSEL0] = msrs[i].data;
>> +            break;
>> +        case MSR_K7_PERFCTR0 ... MSR_K7_PERFCTR0 + 3:
>> +            env->msr_gp_counters[index - MSR_K7_PERFCTR0] = msrs[i].data;
>> +            break;
>> +        case MSR_F15H_PERF_CTL0 ... MSR_F15H_PERF_CTL0 + 0xb:
>> +            index = index - MSR_F15H_PERF_CTL0;
>> +            if (index & 0x1) {
>> +                env->msr_gp_counters[index] = msrs[i].data;
>> +            } else {
>> +                env->msr_gp_evtsel[index] = msrs[i].data;
>> +            }
>> +            break;
>>           case HV_X64_MSR_HYPERCALL:
>>               env->msr_hv_hypercall = msrs[i].data;
>>               break;
