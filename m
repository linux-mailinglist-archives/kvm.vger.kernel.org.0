Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 969327CEC63
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 01:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230477AbjJRXy4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 19:54:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbjJRXyy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 19:54:54 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33E24112
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 16:54:53 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39IIn0p5011250;
        Wed, 18 Oct 2023 23:54:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=Ze4alsPPghqKvWEBmqrqmA4EqA3y+/qTJ4VXR+0OXEI=;
 b=yd5xnCDP6voEHC4Qm5Ak9skH0LF7aDb/pdC1ub1eM+pUnBQtsqirn4OIOFCtNjzW0eWe
 NQDvY+RFThkbiFeOAAM+C7apDwrZBnwAel2u5KASxmlmufX4VFGm2S+sGAy6htppq/6u
 UO4xoVxFderL4J5gfp+rKiNzJOFOvvFwemaAAVA6rjdIJ8YpFVA1avGCikg5y2X1qCt5
 zEYJNuw+9VLk2ZRa0mkulFO6SfksBchJBiKHYljteO9WbV2juyO2fzkB3HkklUxtoxjJ
 LzQ6Lu4siCKNkNC5EmVvhPzj6//4cBRPfvct5eK92L88TN/6ubks6OtYV4vU59JH6del JQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqk1ch0kf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Oct 2023 23:54:29 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39IN09Di010606;
        Wed, 18 Oct 2023 23:54:28 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2040.outbound.protection.outlook.com [104.47.73.40])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3trg0py0pn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Oct 2023 23:54:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YPrTUhWYCxOtfqUi4t55iFIk5ilGaId4QTKIp/nKPJhnDCrZwRfQDUkzXNJKVwZneQ3XqmTB5XVZayrHTYeTR1bM1xZytYLR+96FVYQnUy7AGR0+odWkG2TOTWd4703wv38YWOllu+GXT/NFtOgEJHufWLQPSEBDGz2OG2XMIjBgyMhpQwM8brYthc8HccwZ8AB320hNgiXc2FN5ah+Rd1jn0Rsqw2wcfsBz/PQ9itRaFl4brZVF6/+Q4xof79P9dx5sV7wCBWjoTRezGJ2EBq14w9KE67P/Ya7+7+BHLyfxvKjtsJAHyEQ3vVTyOqraz1UDfG6pLAolZJqi2CEccA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ze4alsPPghqKvWEBmqrqmA4EqA3y+/qTJ4VXR+0OXEI=;
 b=TVwz7vwjtHWfG1ynGZ8IvkpNN5ugCHJ6SI5bfciz4g01VdUvqblW2jOfn/eT+N392GGdLB+hySGc84KGz4tRcyQYR9FSYCfxQsr0kj1Pcs2NCbzE5L7PV0yrm6oOlxeqt3MZ1zJUIdYwEJzJtCE26E46eQBV8FviTqH2lrpZaaPoiR+4PzH7u4P+w3FraV6CFB4sndj9YdSBlhjXG8PkAEEKN64/srqMt9yGotNfDQLOTUQDgk+DN5vWE2TdorOXAQ/Rvynf15jmnZGDYoVDjYMt+yD5rd2yB8hUb1D5UKkWKGoDDsPaQ9tiRLf1nazJvqrfJ3NC5FoRc9SuTlllqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ze4alsPPghqKvWEBmqrqmA4EqA3y+/qTJ4VXR+0OXEI=;
 b=pZMk/GTGrTC9eYrqM2JnN5U9xggMWvSe0cbf6mxd2mMAtCgrgyaRODDyhwOUbj7QKL1tSZiZaOCtvCU0lLlw2/uS8y8jRGL61DJPmt6J/IRAdC7vTma/OxxRU00px1KWqlBKiNdyuuIcaUaH/AFxEHhm2heBFEcQXvuUu0r533A=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by CH0PR10MB5018.namprd10.prod.outlook.com (2603:10b6:610:d8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.23; Wed, 18 Oct
 2023 23:54:26 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6907.022; Wed, 18 Oct 2023
 23:54:26 +0000
Message-ID: <b0d2de6a-9e91-48e4-b188-612eee2012ce@oracle.com>
Date:   Thu, 19 Oct 2023 00:54:20 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 10/18] iommu/amd: Add domain_alloc_user based domain
 allocation
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
 <20231018202715.69734-11-joao.m.martins@oracle.com>
 <20231018225847.GO3952@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20231018225847.GO3952@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR3P195CA0021.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:102:b6::26) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|CH0PR10MB5018:EE_
X-MS-Office365-Filtering-Correlation-Id: 6871e544-86c4-4338-93c1-08dbd0358f61
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X+Iqj4CougefIQsFGBd06YrKjwkaJ/rEu6nY9t2kN+co793HTo8/xlU6LlH8/v5grA9c5QiwHl1tKgB2yAUyWON199jJ6m/iJNnA6z/ihHU5+dTnK1JTl46zmcdOKYSLEIkIckVlyYjYjwaJr6F8pdD7msIRQXaOkbWtEOIe2TqRKOFaU0stPrUXkDvpO5mAzdIjB+chfAcLgPldYNbm+Ugz6Du6wRfQaM5H9o2+ULX7d7216NXibH4zr3VXX7j4AjGPIUf50ibEJHLh9W78VAovq9zsGUOcsOzL23OYjSUjiHPoXVz/ytMee8PQtl8iG+Eqpz9wH/vn+cyHQtKAIzxGNODcoJqoaiG+/2w9EefK8fO44IJ1re9vfmCm0O/f12Gb1B4neHsIwFg5hyYRP3cCbLmdz8CG5oGd01gZtBNjxZ4jlhuI6aDMHSAIoR5JTlUNa4zvAflZO19cpJtndi0gNJFDHIMDK+xYcsVQEZC//l+/MEqtk5X/eNR+UWBRDsLfGyBwEpNgdUEnrCnB0e3w4mb3MazyQmibB2j9mYAgOmXb2+ua41n8vvFlIVFc6q6iEOCQ+LHCzeAlPXlv1D8ikmqy1HV2liPw1HSHGz2VWEEztaag6x0sX9j/BBG/yEVB7lF3g1vlPhs6LwyGjA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(396003)(376002)(136003)(346002)(230922051799003)(186009)(451199024)(64100799003)(1800799009)(4326008)(478600001)(8936002)(6486002)(8676002)(2616005)(7416002)(31696002)(86362001)(6506007)(26005)(2906002)(6666004)(41300700001)(36756003)(6512007)(53546011)(38100700002)(5660300002)(66946007)(316002)(6916009)(66476007)(66556008)(54906003)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YWxoa1pqSUV4TlVhM24xa3k1ZW9TQU5RM1VxTVdPWkhxeTdEQmczL2ZZc2dU?=
 =?utf-8?B?MkpidS8wdW1mY0sxcHhYWS9ubE5vUUh1aGNnMVF0L1grMnZaZFVoZEkvRk1p?=
 =?utf-8?B?OXhHZ3BrSFhmSnh5SCtaeStqL2NJemkzeHp5d1Z5ZDhxeXFtQ3NWSEV3RHhZ?=
 =?utf-8?B?WVB0a2lUUG03Smd4WndvZ0IvZjdOcVhEWlAvSUVpdGErRjgwZitxWjBPRVB0?=
 =?utf-8?B?a1RpS1NtTnpTUDdMakIrbmZUZStxZVV1ZHVlaFh0NE9BSTBTSkUzYm9Bc3RL?=
 =?utf-8?B?SWhDVHBKRHI0QTE4R0JLc0N3RVRrYTJCdDI4em0yNWswaHpMN0M5S0xlWEV3?=
 =?utf-8?B?T3h0ZmQrUzRLM3NIemtXL2xoSzBOZHRDVXhsa3Y0NFlPTkxPQml5SlZHcHFS?=
 =?utf-8?B?ZGtGdTZHbUhNZmE3WG4wWkpHbFVLclViUnNzQ29FdzM3TDJNTUozWnlBbUdt?=
 =?utf-8?B?bmdEUy9iS0lmdFBscHMyU2RWb3hlOFkrT2xNbG9LMzZ3cjNoNGwzTU9tN2FU?=
 =?utf-8?B?d1pITWpVL1NtTFZmN28yR1EzMzRTL05HMDF6ZjVKYS9lUGVuQW1HYzl3OUVi?=
 =?utf-8?B?OVFIai9FQmhWZGlDSEhoL2pjbHZ1dWo4ejl5UDNER2x3anNZeldkL1VHQ3hz?=
 =?utf-8?B?NEwvdXN6OXRhVWVsNHJNTW82NkdMeDJ5QW1aL0RBMW1wZmRKU2lwUFQ1M09P?=
 =?utf-8?B?aDAvSjN1eEZpdEFyZi9zZ3FqQjl4L1lVZ2N3M1NhMWZSNHFGK0FRRVNGVWM0?=
 =?utf-8?B?VVBjNlJtT29HVkJwRVp0emxucXFha1pPeEFTVXRBVHpLUk5lSmsxL1BxU0pT?=
 =?utf-8?B?dnBDRE1mUlR4K2J1L0FBRVFoVURTU3pXNnZUV0twRkczVlBwZlg4czRWZUtM?=
 =?utf-8?B?bC9SZzRnQXR4ZGUxOTlCSGNVT1MzRzVGQXQ0bldwUklPYTdvazQ5NXQxUlhX?=
 =?utf-8?B?OVI3bjV0YkMxbWFXMmkvQjMzSDh0bnBCVmRwS0gxTnF6Tk43NUhuRFQzOVBn?=
 =?utf-8?B?SmYyQkJZUlMrNUlFY0dOZDlseVQyOHd3ZE92WFBDcUNwcXIxS2Z1dmxOc3V0?=
 =?utf-8?B?OWZFNi9zMVBHTTZuSHpmTWtiaDZnYUJjZ0hqT25hZnFTVFNUWDlRM3FmU3ND?=
 =?utf-8?B?cEZ0U3d4aVllU1h1eGV2U0w2bG1pN1EwZXl3eUxBVnJac2ZxUnVYZ29QT0l4?=
 =?utf-8?B?eS9DaVlMS3h0MFlBSzZPakJkWFUrZmIvd1BTVEhkcUViM2dmYWhLMVd2cVZ5?=
 =?utf-8?B?bDFOY0JzdW82ZXJxMnpSa2ZxL2lBZ0puQmY3WDJIQUZUWUVNeitlcUdxYkRL?=
 =?utf-8?B?a205OWthSjRqdXh3TVVqcXZvbDdQaXR4d3Bsd2p2ajhXM0hVTzRJZk5DMnhn?=
 =?utf-8?B?UmxCdnhabnQrYTdzc1NITm85Ump1YkVzZFpXUkc1b0ZJdmgzU2htTllZR2NZ?=
 =?utf-8?B?SWJJNlRiUzRDbEd3ajlCaTNqTnFnNStLRlgvM2xUTm5DRlNBc3FmNXU0Y2E0?=
 =?utf-8?B?MnVyWmVNQ1hZZVUzUXdJYnNGenpBZEN3N0tNaU4vSnRQZnVqbmtOVEtTSit6?=
 =?utf-8?B?YWhnRVlZcWpWN3RzaW9qL2YyOFlmQXVCN1BibXZ4bDRKR2YvOE5QaG4yOVpC?=
 =?utf-8?B?YmJ1RXY1OXd6RHprSmxVNnRPTndQTFlWM0o0SUdUdkpxUEZUbm1hU0tsUGVX?=
 =?utf-8?B?SmNYMjZPaVp0WnErY3J3bUZhRk1mS1pIZS8xRW9tcVovdnd2cGE3Q3prQzNo?=
 =?utf-8?B?TW5QbEVIaVZvUGxEUHZTcWlXMEQxd0ZMN0NiZjlHaWlZN1g5S1NNeExDOUE5?=
 =?utf-8?B?SklUWk1pTWJvcVJXVXJINHZhOTJEbjMzR1AzS24vbVR0eTNFMTJkWVJlV1dx?=
 =?utf-8?B?eEhqY3I5VCtTSDhJeEl6cTJuTjlPbkJEOUtPYTdmTHM3d2FvcndrbVllTEI2?=
 =?utf-8?B?SmVUN1Btdm5PbVNWWHh0ekliZlRZVkpRNW4wbTJCc0t5WTBReHVZaHVsdUla?=
 =?utf-8?B?bjRoSlQ0Y05NNEk2bnJLZUZmR3l5d0NKQkhXTUhGTVErZVBYMTBHY2wwbUo0?=
 =?utf-8?B?M3cxc3NXMzhoSXoxb1MrVVN4dzVXbnkvcnVwcUtEbE9Tb3B5WUFvZGJ6Y0dG?=
 =?utf-8?B?OE0xTGdac3A5ZDh4K2QvUit5K3I0ZksxbjVSeExYY3lzOUZZdG1zWVhmMWox?=
 =?utf-8?B?L1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?bHFhcU5YamlDK3A2eElIaGhDekhiQ1VEYllnS3ZrQ2NUL1FXc3Q5MlJudlpZ?=
 =?utf-8?B?VTFZUVl6cHdUbzkrTm1jd1NzV0Q5dHJaSnZpUmsvZ2VkalVrc2tnUitKVHNV?=
 =?utf-8?B?cmdUVmJYQ2xOMENEdmNHVnNKQjcvZzNncDhTbmthQU9ZKzFsNStKWTJ3QnQ5?=
 =?utf-8?B?Nm8reCt2OFV1NUpyOW8vL0IxVXhwRVo2bHF6WXpNZjBHYTJwdzE2RTlaUUxW?=
 =?utf-8?B?ekx2Yks1eWZtNFFVWENFS2c4Mm1HeU5ibGd2cDdqRkZ5TDF2dWhnUU91WEQ3?=
 =?utf-8?B?b0RneE1PZjg4VGdXNE54V3piOUNkZ0d1N1IzbUhYT2FFL1pLQU9Xbkt5N3cv?=
 =?utf-8?B?b1B3cTRpTGxBQTdvM0pWSlBISnJHbE5CRUxNTXlqT2hWd3JPMWYyOFJyYlk5?=
 =?utf-8?B?dkY2YVN6R2ZIbUVNTVRWVGdzZWwzN1NuTE5WclNCZzM4cUZrMFlCdUVqQ01D?=
 =?utf-8?B?U1l1Z2lSU1lFTE9tbUw2Zk9SR1FWbUZQT0ZhdjdnKy9hVG9VZDlTZnl0RzZH?=
 =?utf-8?B?Y1RCNlN5SUlua0VKZitUU0JNZXpqZ21TVVJOV25CSk9YZHNhTG5xams4cUhj?=
 =?utf-8?B?SVNxL2xSQ1FQQ0UrL3hocDhTOVhzeC9USkgrS1REcmtUT0NLZDRYbW1IRWhW?=
 =?utf-8?B?Q01TQmRtVkx2NmY3Y1BxK3pvSk9Ld2JBdU1MTWM4aGcvaEJXU0g3YUZwMno3?=
 =?utf-8?B?YWthMVltdDhlZVR6NXd0TDg3WWNYcGFQZ1I4dlAramN5SVZVNHVSMSs1czdD?=
 =?utf-8?B?OU56TjdIT1VlamRQU3dGZE5HL1lHTllvS1d5OXVRNGcwQVF0bUtOdkNDcDN0?=
 =?utf-8?B?cTdYOE1rMHJLcXdYalVaUldWcXhwZWJJZ1h2TGNydnpBNHJWMzlhUnFrckF2?=
 =?utf-8?B?QU9LRjhwbitxcFVtdWpENnluTGxqYzBNbDk5MU92cDhQR3pOQUFYMDBGckpN?=
 =?utf-8?B?S1ZkckwwcDNCTnhpT2h1ZVc0YmlwYmY2VzBVc3g0MGw2WTF2bEN1TDNRY1Vm?=
 =?utf-8?B?eTM4RWRwd3RwakxFSFZNc3JlZDgyQmtPZ2xxMnBHQXkyZkt3SzJGMG9GbUIx?=
 =?utf-8?B?Z2FrZTJRMTRIOWxBMEFSM2h0MyttcWMzQStoT3lsRDVPWnFpclF5QXNFdUdT?=
 =?utf-8?B?MzdvWVZOeEtiVitVQ09kVjJxK0lva1MvZDY4YkNmSlZCM2J2aWs4NGd3V1lI?=
 =?utf-8?B?K1htNHdzeU5waGZsL0RCMXN3ODRCYWRMYTkyQXhBRWNaTjJGbWd6Y0ZyZGRs?=
 =?utf-8?B?UDBIQUdlVlY0YmZJcTVYNm8yWVZkNXhIRVRPM1pGSTdTTHpaNUFMdG0zek9x?=
 =?utf-8?B?aUVrbG56K041THpZYnpCSW94dE9nZHMxaTFxY0tJcDE0OVZVajg5WU1EdWVm?=
 =?utf-8?B?bzVRbWcveGlQaXBIcGRNUncreE85S0czR2ZWMlZPL3EwMVhHd3NIakpWaUo0?=
 =?utf-8?Q?gzIdYZlg?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6871e544-86c4-4338-93c1-08dbd0358f61
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 23:54:26.2550
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uAPS6k+em8bMkPnhH4yNxL9X1hXtuuKSY0eEgZiHZHLYWAj3GKLaIMysJIjB3VWThr/A1iy2zXesr+3J5H67Di6jmOVyVhwn+0Jdj06G9vY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5018
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-18_18,2023-10-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310180198
X-Proofpoint-ORIG-GUID: -w2ubdPwXdGOxGL3r5CBLj8S1pe_00nP
X-Proofpoint-GUID: -w2ubdPwXdGOxGL3r5CBLj8S1pe_00nP
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/10/2023 23:58, Jason Gunthorpe wrote:
> On Wed, Oct 18, 2023 at 09:27:07PM +0100, Joao Martins wrote:
>> -static struct iommu_domain *amd_iommu_domain_alloc(unsigned type)
>> +static struct iommu_domain *do_iommu_domain_alloc(unsigned int type,
>> +						  struct device *dev,
>> +						  u32 flags)
>>  {
>>  	struct protection_domain *domain;
>> +	struct amd_iommu *iommu = NULL;
>> +
>> +	if (dev) {
>> +		iommu = rlookup_amd_iommu(dev);
>> +		if (!iommu)
>> +			return ERR_PTR(-ENODEV);
>> +	}
>>  
>>  	/*
>>  	 * Since DTE[Mode]=0 is prohibited on SNP-enabled system,
>>  	 * default to use IOMMU_DOMAIN_DMA[_FQ].
>>  	 */
>>  	if (amd_iommu_snp_en && (type == IOMMU_DOMAIN_IDENTITY))
>> -		return NULL;
>> +		return ERR_PTR(-EINVAL);
>>  
>>  	domain = protection_domain_alloc(type);
>>  	if (!domain)
>> -		return NULL;
>> +		return ERR_PTR(-ENOMEM);
>>  
>>  	domain->domain.geometry.aperture_start = 0;
>>  	domain->domain.geometry.aperture_end   = dma_max_address();
>>  	domain->domain.geometry.force_aperture = true;
>>  
>> +	if (iommu) {
>> +		domain->domain.type = type;
>> +		domain->domain.pgsize_bitmap =
>> +			iommu->iommu.ops->pgsize_bitmap;
>> +		domain->domain.ops =
>> +			iommu->iommu.ops->default_domain_ops;
>> +	}
>> +
>>  	return &domain->domain;
>>  }
> 
> In the end this is probably not enough refactoring, but this driver
> needs so much work we should just wait till the already written series
> get merged.
> 

That is quite a road ahead :(( -- and AMD IOMMU hardware is the only thing I am
best equipped to test this.

But I understand if we end up going this way

> eg domain_alloc_paging should just invoke domain_alloc_user with some
> null arguments if the driver is constructed this way
> 
>> +static struct iommu_domain *amd_iommu_domain_alloc_user(struct device *dev,
>> +							u32 flags)
>> +{
>> +	unsigned int type = IOMMU_DOMAIN_UNMANAGED;
>> +
>> +	if (flags & IOMMU_HWPT_ALLOC_NEST_PARENT)
>> +		return ERR_PTR(-EOPNOTSUPP);
> 
> This should be written as a list of flags the driver *supports* not
> that it rejects
> 
> if (flags)
> 	return ERR_PTR(-EOPNOTSUPP);

Will fix (this was a silly mistake, as I'm doing the right thing on Intel).
