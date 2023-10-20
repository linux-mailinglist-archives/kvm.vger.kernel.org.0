Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97C267D11C0
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 16:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377529AbjJTOoq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 10:44:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377429AbjJTOop (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 10:44:45 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B88AC106
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 07:44:43 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39KD8Q2g008377;
        Fri, 20 Oct 2023 14:44:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=iGgfaouXfF0ZAQWeNYCjZnHQSfqjh8h7TjGhP3BWp/M=;
 b=1myGLTz9y+SSL/hlSW5lniQ1lIP+Z14p6qQ2z0Hf1mwi0yDwmzzKpCKZF5gg2Xa85nNI
 bCVBGPlM1HCFN7l3/7L/zRUUlUrdYUml40WgssmCrWR7AIpAGdJaIGqAd4rIYXkjMUyA
 Im3k8xLBA+K4zxGulmd+zO+lW4e5jI2ukECdXyN4dYGPT9vkMkbS67gQQMchqBADtqbs
 mhAlpwl6b/tDIcXu9VdItjazu2y/8UT01lIxt9WcGhHAWoEIyzawbSl3zDbb+t8KOAB6
 AIvOCXDkFu0adfVJmFrRjajHqcchoyuN4WnkV3aFMQadLTm0nBgLKjNar0nxekc8AjHq pg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tubwcj0gx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Oct 2023 14:44:20 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39KETBTZ031522;
        Fri, 20 Oct 2023 14:44:06 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tubwdw2xd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Oct 2023 14:44:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XaDfv/nFx/fFVYQcoD2ScOhvQyX33uhrXkFlRcshchR/5zKo/vW60h06u3PPTvYPOm2AnTNVPkGLWGSVxPu410O+r6pGzvK4atuC7DtI9XVKywOIICxujejGyrfM3lkYDzDWeTzFOhaYe37oizffGVID8EVqdldB+Qm9ExDbzHLTdJLKdMPXuENO7vvPzmBbU3Xtw3JwYm4HnHTf/B1yyrmsl3DLOYC7AC5o6vowLm8R43CFojVgEpYRwY0/obwwzX1vCo+LmR9RMmy7BdbHZpkvNkl57v30HUsM1bH8biPTYTSWCZnvv/qJ1ajFAXy38teeQXD334wWv1vDWlJWAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iGgfaouXfF0ZAQWeNYCjZnHQSfqjh8h7TjGhP3BWp/M=;
 b=C0EN+cSadPO59tWnlCXXMWbbykeAwmiaZUwBcCTo27li5sM5nMZ9fceYSsBsdX8p/4v0ejCMoCvke0NyuK7tiJd0+vLn0BJCWSveC7VPuxXQ4/a/13rdOLP5K1uXTQiyK5UoVaVsud6H7gyjCtBEZnIXvc7kjifLyRins4GlscNLS9tSqMASV/ckr6Xivr5j0BE8/Qov/nUBRioqd67I3lSmL4pID6hLoGlnj2vLX4cj0RhrAEkAxno4BW4FQp/RaT/bsZ971zczqX+H/+EiLVU7hTpdBDW/j54h6yiLLWDyPTc7601ST7kFiM1/YC+g586iy88I1e7BwlGn26/EFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iGgfaouXfF0ZAQWeNYCjZnHQSfqjh8h7TjGhP3BWp/M=;
 b=dtAlUn4DxVbWbW6hyUFN6TqfszA/MGYIdE3MvgkBggBfamu/Yqx+Wp0nlf4HNcFw//en7AHAToWgMCI9ZEyMsOU03hD3LtthTq9aB4wnoWQZOYecDsIZ0rIz6C+mY0S43kvCncVSvxtzxMW3fsYZINpiq2B6LrADN77XU5x1H0o=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BN0PR10MB4965.namprd10.prod.outlook.com (2603:10b6:408:126::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.26; Fri, 20 Oct
 2023 14:44:03 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6907.025; Fri, 20 Oct 2023
 14:44:03 +0000
Message-ID: <a8c478f1-209e-46b0-9b91-7cd8afccd7ca@oracle.com>
Date:   Fri, 20 Oct 2023 15:43:57 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 11/18] iommu/amd: Access/Dirty bit support in IOPTEs
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20231018202715.69734-1-joao.m.martins@oracle.com>
 <20231018202715.69734-12-joao.m.martins@oracle.com>
 <20231018231111.GP3952@nvidia.com>
 <2a8b0362-7185-4bca-ba06-e6a4f8de940b@oracle.com>
 <f2109ca9-b194-43f2-bed0-077d03242d1a@oracle.com>
 <20231019235933.GB3952@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20231019235933.GB3952@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR02CA0155.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::22) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|BN0PR10MB4965:EE_
X-MS-Office365-Filtering-Correlation-Id: b30a6a1c-d5c7-4fe8-14bb-08dbd17b00fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9bFfDvNdVwinpAXCbr7uQsfHeXd48ynJSylsKXwWzAc0XA0xUcl//T5c7jWyAulTGCG1i4GiW8giIJhHS1iHBxWkM+mBqJfabZSG3cufupwhwH0Dt1EGmoOzXt07ir12aEruNkOKPgBzB3eUmPgtwOMxQNh1yJ+JwlbZu3PaLB5JOYMPVJ6owzCou9bP5bd5GBimNLEkhZGPQTORmp4vctlN52BGLCAUhe2q1DtcQiwwEe8tviTeUuC3YV/9t7xdblwgzoufwRa7/iFFoz5WygnY0U5BEKFpW+waOv9isDqxo8WdteyQ5uJDBy2q+9pfkVuKaitlbCkirSkgkqVmiVmTnJrXsY03xNqCbrh6TMwqNGdxky6QNHcOGfBpE05q6ak+ZfKpfFuf8Rbdd3cadpwnn55IVcRl5966RyS+K7rPgnXsDflQYC8BEFOvdabVyJtlIRrVcxeZfrfAe5w0Ph2+74SW0a/l4zJIoz/6u+ydz+k4qOkv2wJQEwXgZsF/SoqtEtVQRglredYpw9nSzzYgxI0PxwnCvFiDDAscqrBCtNwgRr1eRxtl3GKNxNzFtrlKMNHPIqRik7dc1W1Kr9aGQ+GgFrCdq/WweW1SpQU0z+pY+f7f40tTRsQoWlkBB1ekDaCNyGCOZ+fgDSr0T+QxBPmNlEycNtWdgSvThQQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(346002)(376002)(136003)(396003)(230922051799003)(186009)(451199024)(1800799009)(64100799003)(31686004)(6486002)(2616005)(6512007)(478600001)(41300700001)(66556008)(6916009)(66946007)(66476007)(54906003)(53546011)(38100700002)(26005)(316002)(83380400001)(6506007)(6666004)(8936002)(8676002)(5660300002)(7416002)(2906002)(36756003)(4326008)(31696002)(86362001)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UTNQdzdRdXFBcldJNzdSTXJMY1p0NzQ3aWVGWll5WUNzdzFHSXdrYXR6OENS?=
 =?utf-8?B?VUNlb3p5S3pLdk94ajVNdlk2dktYOGllaU94MStOQml2T1VRdGRWU2c0WmQ1?=
 =?utf-8?B?Uy9XMW01T3h1eUxlVmpRYU9peGJvRk9zY0pDSEFUVTZjYnRvY2RXaTdmSjUz?=
 =?utf-8?B?TzA5Wk8remxWYzh2ZTNWRSs2bi92ZVlyejVCUnpPOEZUcURWSGMxNkZGMTUr?=
 =?utf-8?B?TUtrVGdCY3g5RlBaYktvUWU0K1oybGZhb0c0NER3VGFDTjF6U1VhVzIxdHpJ?=
 =?utf-8?B?eXhzZ3BQdGlWZ0p1RjlmUWRqajBSdkd0RUpLNENab2VzSU9nenNWcVQ5Mkth?=
 =?utf-8?B?SGF0S0VrZjFCOHhIamRYb1RZRG04dDR2citmcWh3dlFub2xVdFNqUEhndGEw?=
 =?utf-8?B?WllVb1RzVE96Unl0ek5FV2FkbG9vWUNxL0ZhOE9LTTY4dVkyQWovNC9NSU1W?=
 =?utf-8?B?T2xzN0FVTUVKNktRZWFCNXhaVkZlR2MralZBUTJKdUo0Z21jMkQyWUVpa0dG?=
 =?utf-8?B?MWZXV1V6eFdhbW0vREM1bVMycGlsM3FhUG0rVEtZYysxdWsxQ3c5OFlzbGtp?=
 =?utf-8?B?dFhOOFJrK1FMWTgxbXZOem9FbWhkNmZhN29iZlQvZjZSaEJIYTJkWmxILzg1?=
 =?utf-8?B?TUwxTCt0c2c0VDRrQ1VzN3lBbFV4d0F4WHJOZ2hMRDVlTmtEaVd1cjVRbm51?=
 =?utf-8?B?U3ExNzRBSzRXaXZncnRrWDhtclYvZ3h6ei9GYmdRSk02TmdzUTI1OXhHc3lv?=
 =?utf-8?B?UVZTWE1obHBnN04rQXV2L2Q4RG1CaW15UDAraFJwTWhvZDg5eWcvT2k1WlVm?=
 =?utf-8?B?bHppb1RZSjZPWGFxZUptWXF3VmR5aDRrYmNsRDVBZ3dlUjd4RnBWalFKaDlw?=
 =?utf-8?B?YWRLQmtvWlMrcDZKVlU1Zm9KNVErMjJDenhRakUwVVlzRzVYeVpJTDM5d2s3?=
 =?utf-8?B?VzJ2V2lBcUdyM3RqY0RnQVlTUW4zcUloQWN6UGxBZnBGRkFrRTNYWFdYMXFR?=
 =?utf-8?B?cUplUkttYmtRZ0V0cHBZNnhEMG1ueXRiRlo0eWFCY2hnQ01MR21UZStLeGd0?=
 =?utf-8?B?N2M0eGk0WVZMZkxraGVvLzIzaGNBVFdVYlNPOFdWWWswR0NyVUxGeXdSYmhq?=
 =?utf-8?B?bHJrTnpISHpxcS9RUFkrOGgzQzUyNkF0Q1FDRTZMU2FtM2FyZjZSaG9McGJE?=
 =?utf-8?B?WXdsOTZDTUdqeXIvbUF3cjdKVWNwanFMTFQxZlk0YmNSQldlMnd1MExHVmFk?=
 =?utf-8?B?UWU4Q2xCQUJVK1FZKzc1U0pUS2V6MVpSMGNRdjIzSVRvK2JUcTJ0ekNwZm5t?=
 =?utf-8?B?WklwZlBmaVh6aEZuRFZTZUcwYzdWNzJvUkd1UlZIVDllQ29tVDlGdVI5VUxy?=
 =?utf-8?B?Z0t2NkFKby9JbnpIWS9ySmhCMlpTbXNRanQxWnpXM2NyR1NKa1ZPM2FLbEZP?=
 =?utf-8?B?TUFuclRzSjlhSkFVVy9CN3QwMEg3V0xRQWZ1eTlvc2RVWDRyTEIwVkJEQ2h5?=
 =?utf-8?B?RXpwY1lkZ2dCdi9BZEJkZmpNdklEVUpmY044b2dXWTVZV2p4WHYyWkpaOGVB?=
 =?utf-8?B?cjMwZ0pBRmt3VUdkdUFKKy9qTzdKdU1oWjRQbmNZMTFHTzRJTnlJT3BRVTJ1?=
 =?utf-8?B?Zm9aSWx0SVNJcC9qTklKdWNFM3NJVWlSUHpwTnVZZFAzK3plWXBmVkREWGpn?=
 =?utf-8?B?dVAyamhldjlsQ0t0aGZ3WWRuRjBxN1NQOTI4NGxTZFg5R2FiWGlBdGdzNmVR?=
 =?utf-8?B?RjBHMFBJdWxZL1VrYXFNbnNPYUF5MUVxeWhCczdRcm1pbVF1QVd1b3RvOFpW?=
 =?utf-8?B?OGR6YUVNQmp5bnNxVGxYS3lmbEx0VWVJVGI3cEVBSVVYOGNrUzZWTCtHRnBK?=
 =?utf-8?B?eEh3OW5mZVZxUFhZTEE4d0x3SEF4M1FDQzY0cEFSZ0pKUXc1Q0t3Y0FOOEsy?=
 =?utf-8?B?RU81WEI5RlVEUGM1Mno4Smo5TjhIMG9ITEtsQ3d6eXF4d0pTTTJ2NnFJdlF6?=
 =?utf-8?B?MXpFYS9KbUltdUZOMnhSRG93MXprZEFkS3ppOWxVUldNa1NIMzlZRlVqSysy?=
 =?utf-8?B?dlN4OHgzTFF5bFFhYVgzNjZ6ZlM0NG40VjhYK1J6dytYeDZRN1lRbTZ5UXZo?=
 =?utf-8?B?bEpiT0VrQWxnQ1l2TkhYZXpNU09GNmVnbFRwai8yQzV2Tzl5Wk9HME9mS1Y0?=
 =?utf-8?B?Qmc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?L0xMSGM3OWVlMTFwRE1vbEJHSHErdWZKN1d0U2hGdHJmMVV5Nmg3NmlVSThs?=
 =?utf-8?B?TEJZVWlOOC9EalJWNHZaV3Q3em5rNjYvNU9Xdm9lZVNlNzN1eGZDRVBibjdo?=
 =?utf-8?B?RGsxMTRrVk1oSklHVkw0Y3ZGbFhEYnBDMXBublpVM3BBQjZiSEpTK0xwdElt?=
 =?utf-8?B?S0dpY2l2bzNRck9GZkJmcmdoNFdmemNtTkZuMGtuaDVIUE56d2tPMThXaWxG?=
 =?utf-8?B?UjBuQkNXQzkrNFY3NXpBYlU3VjNjMjFXUmRMYXRtMjU3TFZEbldISnN1Wm00?=
 =?utf-8?B?MXlQSTAxejdzMTcwMTMvNnhqMHBTTWFnY2NrQW1Yck52aHExd243WGxSN1dR?=
 =?utf-8?B?d1pYaE16TFNYV3hUVmg0L0ZjczA5S0owMTNUbkwxWlEzQmExUWRtbDROeC96?=
 =?utf-8?B?Y050VW1GN1NJWTBtNU5pL2tCK1Z4d3FiSXY3QjBLeFRCVmJKdnI0QVUyWHRn?=
 =?utf-8?B?RGd4cWs2bERhM0JLZzNXbnBMOVd4TENHdnJ4L2RNS3U2TVVmK1l3Y1FCWW1i?=
 =?utf-8?B?ODhabVlxMTA1OUN2K3FZcDVOTDArSG5ZSkdLS0FxYWdlRVd3blhOWlh4dEd0?=
 =?utf-8?B?Smd6S2ZvVW5aWWRxYnd2VkpEV2VBNE9rVWkrNkdhUXhMaHphSmhrMzhRTUli?=
 =?utf-8?B?Rk1EaDJKWjF5TVdCM2tyUnh5eTgvV1dFL1pUSlNMc1cxaTdKS0hYZ3hMQlBG?=
 =?utf-8?B?YVBxZ0t3NkloZGx3SURXMVFhV3o4cFAxUWZtbW5QbVRLN29xdHU0ZlMrandh?=
 =?utf-8?B?Wjl2SVFsYzgrNU95ak1nUmRxcG8xMzdTbSt4S0R2UFBFaXFhSTkzUUVpYlcr?=
 =?utf-8?B?T3JrOUpsNjAwcXBWSUhMYTNQSWpIVWdqQloyd00rNFA5Ui9jRythbnh5WkNu?=
 =?utf-8?B?ZkdmK1dacHZLR3lwQ2d3SnFTVDExRlJEM2Z6TCszb3U5UmV2aVhFME1oMldn?=
 =?utf-8?B?Qyt2OS9QZDR5U1IrcjFySTN4bFBleDl3Ym9mZk1COTNqUFZ5V2NpUG55Wmd4?=
 =?utf-8?B?QnB0UlVTRmE4akZ5Q3NNNXpoR3dRcGlVZi9LeEYwUEFTM3RzS2ZPUnBOR1VX?=
 =?utf-8?B?eURRUEJ1UC9HNFM5dFVCN3ZBcloyUitvWHMvUEFLZ0wxWHFScjMrZVhGL01v?=
 =?utf-8?B?eGpBSU1QNGNvZXpyTE9JZW5vM054YTIvV2REQjZnd0ZQOHVoV2E0MGVxc0Va?=
 =?utf-8?B?Q2pOUW1ha084Z3l3Z1ZxTHlQSmE2d2JnODVrMkFnNVBQeExHdjU5a2dIODZT?=
 =?utf-8?B?SmR1a011RUdSdWd6ckF2SUF6QnM5SkxRbUJwMVJ6VXJQV0NqTU5hUlNHRzBU?=
 =?utf-8?B?dEJKeEgwdVQzNFU2c1BUUDBnSjBYLzRHczcwSml2UWRWdWRVYzJZYXh2L2lL?=
 =?utf-8?B?eDFtL2pvMmx4RS9MQ3RGaG1mY0tPa2dPT2N2VXlyVW5PMVVuUVFtS2o3MkJF?=
 =?utf-8?Q?jBEDcxts?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b30a6a1c-d5c7-4fe8-14bb-08dbd17b00fc
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2023 14:44:03.3017
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2c80RCnZLSsYdaaXxMyw7Vfj/9CQH2DQoGwS1ZQ1KDVRZgA4PIGcli2ZpHqklXgirPkP1HZor5SvXKqT9Q/MRON+xBdnNB4DzdrxtEfzc0Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4965
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-20_10,2023-10-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 bulkscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310170001
 definitions=main-2310200121
X-Proofpoint-ORIG-GUID: uTkFD6e0uH3-lHEjLGssxblIL1HzmXfU
X-Proofpoint-GUID: uTkFD6e0uH3-lHEjLGssxblIL1HzmXfU
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/10/2023 00:59, Jason Gunthorpe wrote:
> On Thu, Oct 19, 2023 at 12:58:29PM +0100, Joao Martins wrote:
>> AMD has no such behaviour, though that driver per your earlier suggestion might
>> need to wait until -rc1 for some of the refactorings get merged. Hopefully we
>> don't need to wait for the last 3 series of AMD Driver refactoring (?) to be
>> done as that looks to be more SVA related; Unless there's something more
>> specific you are looking for prior to introducing AMD's domain_alloc_user().
> 
> I don't think we need to wait, it just needs to go on the cleaning list.
>

I am not sure I followed. This suggests an post-merge cleanups, which goes in
different direction of your original comment? But maybe I am just not parsing it
right (sorry, just confused)

>>> for themselves; so more and more I need to work on something like
>>> iommufd_log_perf tool under tools/testing that is similar to the gup_perf to make all
>>> performance work obvious and 'standardized'
> 
> We have a mlx5 vfio driver in rdma-core and I have been thinking it
> would be a nice basis for building an iommufd tester/benchmarker as it
> has a wide set of "easilly" triggered functionality.

Oh woah, that's quite awesome; I'll take a closer look; I thought rdma-core
support for mlx5-vfio was to do direct usage of the firmware interface, but it
appears to be for regular RDMA apps as well. I do use some RDMA to exercise
iommu dirty tracking; but it's more like a rudimentary test inside the guest,
not something self-contained.

I was thinking in something more basic (for starters) device-agnostic to
exercise the iommu side part -- I gave gup_test example as that's exactly what I
have in mind. Though having in-device knowledge is the ultimate tool to exercise
this free of migration problems/overheads/algorithm. Initially I was thinking a
DPDK app where you program the device itself, but it is a bit too complex. But
if rdma-core can still use mlx5-VFIO while retaining the same semantics of a
'normal' RDMA app (e.g. which registers some MRs and lets you rdma read/write)
then this is definitely good foundation.

	Joao
