Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4556B7CF493
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 12:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345154AbjJSKCF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 06:02:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345098AbjJSKCD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 06:02:03 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ACB911B
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 03:02:00 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39J7NxFS011487;
        Thu, 19 Oct 2023 10:01:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=P5oyu5EaxIcQiPqzUhIABMuFW6NBcqQruTOGtgeeG9Y=;
 b=msV8PgzTaKupEABZSrVJguGaSo5WfDUVFID3+EkyMxnqYgcbOtFN4LJsMwVXyAUaC/el
 ZfWtwGsIBLtuf5tYc3vebUfrcqQJ7wcpj2vLoVDMKZ3eBI3LODXSamTxuHnFUoRxkmMK
 F+aRH4e9Xz+AnxDf7SEtft3XEWdiR6gQDWTFatMzl2s0EZg1/giCRX7/kNcrX8I49/lA
 JYJ0Rn13LZe+tuVIJNv8zlN7Blnou0PkOJqE3ARMx5ypwBLDwHEQN7M4XV5JhGwm9KoP
 5ODW6i7QDKYPzKuSZ5HauDlOZ+Vcgjyp7rF/+49JDQ1vN4fl18GvsdOKYOx4eBvoZoQd TQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqk1bt51b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Oct 2023 10:01:39 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39J8HxW1040584;
        Thu, 19 Oct 2023 10:01:39 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2041.outbound.protection.outlook.com [104.47.57.41])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3trfyq0gx9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Oct 2023 10:01:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OxoQX7SV253WfanViEGI4tNiDd6BqZzv8yI3KZC0yRX6j4F3z+iXg3Jm2tMmfHa1KjN6Y3PK2iqJgrQ+ZYwLk4D/RV838CW/o1wSlgWnb5GVtXe9gf6rRwEm1iOsOwBpf4WjxNC9dLK42Tx5i3NsgvltsKL/YFZynMcN/8GGySGGKUtms7P4j0YKAxLBSpV7dDE/IJbzl5H32MkDtgiAtycwUhvmH/8SlPG1/fZDuJEop/pVrABx0oQG8Pl+a5mqeh1PHC1vXkcw9iG2djO9tb6aukx79p4DtQ2kOytlhPm3DR1pbezAM1+bJSfnI3oEjnH8+3KaI2Dsf+yZqHlVtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P5oyu5EaxIcQiPqzUhIABMuFW6NBcqQruTOGtgeeG9Y=;
 b=YGQZBny83iuPLRr0Xc9JruCuQ1bZq2aAcI5n/Xb/jrHDZYbkuVrthB5QQDbbw/N1/RWU25muFPappazb0rEMBok8xI3mVAfUgwdvoGykX81VQXUMKIwFwuLix5ynqjFs0eeo9tVTTTBw5528+CpPyj/Ia8mJeZIlBIiNffnvCqce/oDCckuSBxLUPR37MvjkjCUYV5ztFFk+apyZwo8/me/6d01qGfMaRLACsFA/xiiedZVqM26TBmV9fCZ+rPiXYXLPCZUGtwXQtzfWOAEz1UzBhReywPqXSDSdT5CNT5PV9GYBgd8orXR81rjZx9UXu+7lIwOUJGBYidHtr+pgSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P5oyu5EaxIcQiPqzUhIABMuFW6NBcqQruTOGtgeeG9Y=;
 b=f3AQpxpUwNcMZ8KcIaCnOJ74xlycw8P+CRuURo00T+C+bTTyzjsMrsTTVeESOgDOvxWsXSXEvEFKMVko/MMaL9Xo5/Z6Pqyl4KIAW7GBoqb14BMW7o0zNiNZ/AAdFF/UtMSL5VHQNO2gMc3GQo5cSb/Fh4oORiOrUsMDVgvcUsI=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by CY8PR10MB6467.namprd10.prod.outlook.com (2603:10b6:930:61::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.21; Thu, 19 Oct
 2023 10:01:37 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6907.025; Thu, 19 Oct 2023
 10:01:36 +0000
Message-ID: <e1e771da-631f-4f45-bdbf-96a4259eb037@oracle.com>
Date:   Thu, 19 Oct 2023 11:01:31 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/18] iommufd: Add IOMMU_HWPT_GET_DIRTY_IOVA
Content-Language: en-US
To:     iommu@lists.linux.dev
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
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
 <20231018202715.69734-8-joao.m.martins@oracle.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20231018202715.69734-8-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0185.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a::29) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|CY8PR10MB6467:EE_
X-MS-Office365-Filtering-Correlation-Id: ea473a0c-3846-4cd1-22a5-08dbd08a619f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lQRqZXSGhEyzRQq13m1zwfuyVX9t+GQwEEr19xu7poGL6ojZiqtEhoo0NZzx3sFyY6BIqFYIS2qIRS0ytpFXZZa7/QoICA3ekhTqODdLhtJ8pP82bFm9G+Q62G94UNXVgWpFQuigfc+O+A4EQrjb01z7dNyAhtY5LH/fJnzMVroyZyyu+zlgiUENlAuekiFcblhuoApcTdmQvh0ytE4Zkde/IR2lb3H2AuojTy6/e5gjMIjVjFMw/dwNKvzXVNpcmF1v8oYTpxXtJjpdMNu+l+KFAN1l7B5dKOYKUh1+LxXhT90wKqJ3+DuPfqVYJIkYXytsoAS7A8VFzQb8w8xg0NGEQPGgOSnujySIkKQkNJ8r9owWzUzlqWzmQQdPdbj0m8posS3mXedyr9xR10ehL7A7Hb0iM/lGwHsmFr6hqvG4pdUrOWvTxQoku441VA4PuH8CLCM71E2k+duZ8cslXQ7tTSkbPCSx6sVGNIkFckOARgo7RAML4USE7AhB+HyTVW2/mOeT8H7+UIRgr8/nSmEY3JeyQ6URShg/XmKAZMMQSggK+2RpkQAOYfvfiyYYx5toW8vaOKtOsLiX/R/gqOMOf/dPvejTkLS6SOSzHkMWPyd/CyvXYJYYIoLFKWbu0B1vBm8lGJ78bwQkl+RXEYG/9DntDTZc0iGnYuMWX+0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(136003)(396003)(376002)(366004)(230922051799003)(451199024)(186009)(64100799003)(1800799009)(6512007)(38100700002)(66556008)(6506007)(6666004)(53546011)(6916009)(41300700001)(7416002)(2906002)(2616005)(26005)(36756003)(316002)(4326008)(8936002)(31696002)(54906003)(66946007)(31686004)(66476007)(5660300002)(86362001)(6486002)(8676002)(478600001)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OXdJMlNPc3NFYzhtMzI2ZkVaaE03aHc2b3E2ODh1TTZjQWJYc0JOV1RZTzN4?=
 =?utf-8?B?N1hWamZOMkhuKzhLN3NWY3B6NG9LVk1wRWR4WEducHd2citTeisrKzB0dmp5?=
 =?utf-8?B?bkFIZlRTc3VEZ3NsN2d1Yk1JdHBxY2RHQlU4MGJNQ1JsdjNUU2gxZ0lKbi9N?=
 =?utf-8?B?TlcvZ1MvU3ZwU0w0K1d2bjNTVXRtMFU1cjBNUEQxeG9RQTdzUkgwSFBObGps?=
 =?utf-8?B?bjQwb21EVlRKN3BRbUN1TkV4OEZ4UUs5YWxMZnVpbzBjckQySnVQWjhUQXdm?=
 =?utf-8?B?MnpJT1JiamVtWHRyYnM0KzlPNlIzODJoVTlWbUNqcDh1NklqR1cyV05Sanp4?=
 =?utf-8?B?aWtYUk9XVk9ONXR4WmtjakNuQ2JuS2FMYmpPekZLUm16YitPb2ZOWDA0VW5L?=
 =?utf-8?B?NlJwbCtNSjJ3MGIxZjlTa0paZTVMaFdHNTFCVXB3dVlLNlUzRFljdnl3SUdz?=
 =?utf-8?B?QURtNlRDTHJrclAvN3JtMSs4d3d6YWhjSlhHMWlDSVE1WVdZWnJMNU5GL2xI?=
 =?utf-8?B?eGEvTHFmU3k4U1hNVkgxMWNEMG1jY2g2am12YUJRSzcreDlCU01mN2REeVZw?=
 =?utf-8?B?SndlSVZIMlg2UjhrNTZjWXFiMDdFaGo0ekRlNTkreTBWNm1ObTRLOTRBMy9a?=
 =?utf-8?B?Mlh1dFFnL0pWbFZjUlF5UUhCclRNMWRPU3pJdTBSQkF0L1hLbHNxUTRuc0h4?=
 =?utf-8?B?UXVCVWZzV1JldGF6bXpvRnBvOWJhVjR5N1NjZm9TR2N6K1pGN0prdFczTEoy?=
 =?utf-8?B?Y2U4T01md05qTy9NVER6b2N6ckNXWlFNY0ZRNmRUOFVycSs2dTZpU3FhU3po?=
 =?utf-8?B?VVhPLzVabXBia3BBTlQ1NEMzSldVN0NSb3ZVTGtzZ2lrc3Y3RkFXZ2RwRWJM?=
 =?utf-8?B?QlNobDdWMFJ6Y3UwbmhEcldVUmNYM1JhSk5Ya2QwbEdRZDVkcTRVRG5mU0cr?=
 =?utf-8?B?bjBhMGZ4U3ltY280bGVEeWJCbll0dHlkZmdZb3QxblhGdVMvN1FhRk4yajQ4?=
 =?utf-8?B?ZUJNYmsxWFQvT0dPMnZqL0pSZExnc21TRnVRT3FJTGNnbU5rVHJqSXczNWt0?=
 =?utf-8?B?NzhtelJPUnNudk50enZmZ1NhQTAyMVRVWXcwM255eklZMURFdnRTTlZYRmMz?=
 =?utf-8?B?aU92dmNxUE1URDE0NFRBMndUcGRqZ0VTa29BL052bEk2ckUrcUg1UUdpbmJV?=
 =?utf-8?B?ZXdFR1FsRUpETEthWEdOQnp6OXFhY1F5QUY2V1djTGNCcXd1QkhlWDZCTFBM?=
 =?utf-8?B?N2tIZkxqNjB4N0oxTjE2UHg4SlprL1ZKSlZSQnZGNU9DVkljUWYrbENOWStr?=
 =?utf-8?B?cW1iNE9saElwTFluZFRDbUJZbDVaM3luY3lwVFdLVmtuM003aWFMMFAwejRD?=
 =?utf-8?B?dW5Ia3B1TEx1MU5UcDVsRUJZRzBUNnNlbVdvMG50bjQwSkNZZDlZUGM2UXlm?=
 =?utf-8?B?WUIySXY1SkhBTXp4S2FGZnhVWjJCOGNDZExrVGowV2dNUzVGZ0IwYXFEZXNX?=
 =?utf-8?B?cDA5ZmZBb1BxZit4RE93bXpxdzhGeDNpNTVDa1ducEVDeE9lQktveEl2Wjcz?=
 =?utf-8?B?L3JmWHlaVzBSb2dsWFVKc010YnorRklJcXpUVldmTWJ2ZnMxcG5IOHJFWnd1?=
 =?utf-8?B?TGt6MGxjdGpTZzVUUDA5L3oyQzE0eDE3YVhabWFHemdWaW9vTVczTlgvOFU1?=
 =?utf-8?B?WDhIRmFYNGFFSkt1T1pqWDBYazNwbFp3amhvU1ZndmZsOEdJU3IvWkEyeXVX?=
 =?utf-8?B?aGVIb1ozc2VQWmVCckRvdWJveEdDRHNFd0x0cmV0V2hWUW5NdnNtM09kTm5O?=
 =?utf-8?B?WWlhVnRIa2ZhNHpTUndIZE5FU1dSd2hGU3MweXdSdVNVekEwOXVhditNZWEy?=
 =?utf-8?B?dlJid29najFlc01mQmpuZTdnM0U1V09ENWptTlRuTmcwbi9MNWVWUmhsVGFx?=
 =?utf-8?B?VlplQ3JHWEhBZmxhNTFtaXNmK2J6L0ZDcXlkVTl6S1NydmZBM2drc1ZWZm00?=
 =?utf-8?B?UjVLbU1UVnF4ZE4vclZ0c1FBQUlMM3JGMUxWM3pzTWkzMktKWlErMXN0SkVo?=
 =?utf-8?B?VFBmZVpFZXA3OEZGRytWZ1lMUnRSNHFueFN5N29tbHRRNDRQUmpFWmRCWVo0?=
 =?utf-8?B?YjJqM2NwbmRBSjdjV2ltSWVCUG9UR0U0bG94RWZHeG1uUnZWWlVtNDNsSktM?=
 =?utf-8?B?Y3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?MkFXajlYQmYyaUx0enBQOUpkbVNONzJaM0ZmNFA5dEg4QXI3WmxLOHBEaHoz?=
 =?utf-8?B?S0pYNXRqaUd0dU9sdHd5OEhFaEZ4SW5mUThMMzF4YU1NMFhrR0VlUS8ySjRD?=
 =?utf-8?B?TWpsVlJ2Zld1SEp4aUt0Q0oySzFUb3czTWFicnFrS3Q1cERHVmlEK09nNXps?=
 =?utf-8?B?ZFVtaVhQWTI5NHNJL1I2WldaTU8zdm9pSENYTXBQREQ0NlJ6b0xqZ0lNR1Iz?=
 =?utf-8?B?UnRwajVLMWF5SzRQa3ZmTlFoeFp0aE02eHgrRWlFYVoyRG5xU01BcUxhYnBV?=
 =?utf-8?B?bjhuN3JiVGh4blJHMm9OZmUvZGhCb2hybkUxc0F5TWthYVpPTG5DZkx3UDFp?=
 =?utf-8?B?Z3kyUGE2UTZrUDdlNTd5bHRhS3htVEdLYVk4UlZxMlJML3JaVkFUQ1ExQ3dP?=
 =?utf-8?B?ZHZyNUtESklSU3VMTUdnVUM2UGVkWVc1ajN3SWo1MjNpQ1BpZk94S1NScC9j?=
 =?utf-8?B?MUcwZksweC9EY2xzYU9tWVMya3g4SHJDaFZMVkNhbHlxZmJTTzFsdW1nT2RL?=
 =?utf-8?B?Ykk2VityL2NJcWdSQjFYbE9rQUxpemRMdG40WEZ5UHluWFZ1eGlwMGN3VmtZ?=
 =?utf-8?B?YjhXallKbkFUL0hhTUtldVpIRER3dTBNQkpWam1MSFI0clBIZ21UbVJBK0xY?=
 =?utf-8?B?TitQak5CSGI3OUs3VlBycnJCZmVNZ1ZUOVpGSHJpT01vM2xWVGNVT2NjV09v?=
 =?utf-8?B?bmVQeERGWWFka0xoZUZQWW80OVlMdEQ1YTU3bDg0VVFmNHl3aCt6Mi84eHdp?=
 =?utf-8?B?OG80Q1lqRXZPQzVVV0NyOFh1ZWdJWE52bm5lVDByNGE4SHhKNWd4aFFrOWE4?=
 =?utf-8?B?WnhXZlMvT2FabHdBNVNXZE4wVHk2eWJmWjVBMzJmVi9nallQY0I0Mk41SEVJ?=
 =?utf-8?B?L1RlcVdZclBjS1RWYUtzU2s1dUp3YWVScHR0V3E5dUZrUDF2Zmh1TmlNS3Na?=
 =?utf-8?B?cEMyampYZ1VveXhYLzc0QTd3R0hFY05lbWVLODN3YVluZEJLREZORTdJTVpJ?=
 =?utf-8?B?OUoxN2hOWGI4TTl1cVFTaCtXOUdkK0hpeG5hU0xqbEwrQndyTnAyQjNNVldm?=
 =?utf-8?B?VDFVUjY5L2tndnZNT1hXVnN6UnJFUmFCVFZUL2pQRXkrNGNZZFRvRElTRENq?=
 =?utf-8?B?c2NGMHRvRjV6R1lTTjlYSXIrRjRpcE16YUhsUXduY1JtSGFiSWhPOHlpak00?=
 =?utf-8?B?MlNENHRGZUNZVzE2b0hwOHVZTi9wdlZPcGVYckVTNzhDRmdOTFF0N0x3aUIv?=
 =?utf-8?B?aExHRVloQ0g1aUI4N0toUVhGeEEwMk11OGFRZHhaZFZQSWUwa0pSZDM2dm9Z?=
 =?utf-8?B?QWpndVhKWUtib3E3bE5JT3RkTWhnaGNNTUo3RHhIN2E1NVFjcWZnbzE2YkRQ?=
 =?utf-8?B?dHhyR1Rnb1NDc0hCNWw2MWZ3M1hhVXRoTWdBeC9CYmx1Q0FtTUhJREtsenZj?=
 =?utf-8?Q?YhdTVXbC?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea473a0c-3846-4cd1-22a5-08dbd08a619f
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2023 10:01:36.8677
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OGjD6SIZD7m4EiDYwYLqD+Hw7PD1AOBWDeZNsyaCRV6Q/TadQIXf+khiVJ1+K3jC6FnJbXkhA9JlMgFx5HRkBqBdHqz/icFU33ezbYy5dWA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6467
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-19_08,2023-10-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310190084
X-Proofpoint-GUID: PSeFpR4otK8d5X--YV6AgUes35D_-2L-
X-Proofpoint-ORIG-GUID: PSeFpR4otK8d5X--YV6AgUes35D_-2L-
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/10/2023 21:27, Joao Martins wrote:
> diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
> index 9e1721e38819..efeb12c1aaeb 100644
> --- a/include/uapi/linux/iommufd.h
> +++ b/include/uapi/linux/iommufd.h
> @@ -48,6 +48,7 @@ enum {
>  	IOMMUFD_CMD_HWPT_ALLOC,
>  	IOMMUFD_CMD_GET_HW_INFO,
>  	IOMMUFD_CMD_HWPT_SET_DIRTY,
> +	IOMMUFD_CMD_HWPT_GET_DIRTY_IOVA,
>  };
>  
>  /**
> @@ -479,4 +480,31 @@ struct iommu_hwpt_set_dirty {
>  	__u32 __reserved;
>  };
>  #define IOMMU_HWPT_SET_DIRTY _IO(IOMMUFD_TYPE, IOMMUFD_CMD_HWPT_SET_DIRTY)
> +
> +/**
> + * struct iommu_hwpt_get_dirty_iova - ioctl(IOMMU_HWPT_GET_DIRTY_IOVA)
> + * @size: sizeof(struct iommu_hwpt_get_dirty_iova)
> + * @hwpt_id: HW pagetable ID that represents the IOMMU domain.
> + * @flags: Flags to control dirty tracking status.
> + * @iova: base IOVA of the bitmap first bit
> + * @length: IOVA range size
> + * @page_size: page size granularity of each bit in the bitmap
> + * @data: bitmap where to set the dirty bits. The bitmap bits each
> + * represent a page_size which you deviate from an arbitrary iova.
> + * Checking a given IOVA is dirty:
> + *
> + *  data[(iova / page_size) / 64] & (1ULL << (iova % 64))
> + */
> +struct iommu_hwpt_get_dirty_iova {
> +	__u32 size;
> +	__u32 hwpt_id;
> +	__u32 flags;
> +	__u32 __reserved;
> +	__aligned_u64 iova;
> +	__aligned_u64 length;
> +	__aligned_u64 page_size;
> +	__aligned_u64 *data;
> +};
> +#define IOMMU_HWPT_GET_DIRTY_IOVA _IO(IOMMUFD_TYPE, IOMMUFD_CMD_HWPT_GET_DIRTY_IOVA)
> +
>  #endif

I added this extra chunk:

diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index 6b26045f6577..3349347cb766 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -502,7 +502,7 @@ struct iommu_hwpt_set_dirty {
  * struct iommu_hwpt_get_dirty_iova - ioctl(IOMMU_HWPT_GET_DIRTY_IOVA)
  * @size: sizeof(struct iommu_hwpt_get_dirty_iova)
  * @hwpt_id: HW pagetable ID that represents the IOMMU domain.
- * @flags: Flags to control dirty tracking status.
+ * @flags: Flags to control the fetching of dirty IOVAs.
  * @iova: base IOVA of the bitmap first bit
  * @length: IOVA range size
  * @page_size: page size granularity of each bit in the bitmap
@@ -511,6 +511,10 @@ struct iommu_hwpt_set_dirty {
  * Checking a given IOVA is dirty:
  *
  *  data[(iova / page_size) / 64] & (1ULL << (iova % 64))
+ *
+ * Walk the IOMMU pagetables for a given IOVA range to return a bitmap
+ * with the dirty IOVAs. In doing so it will also by default clear any
+ * dirty bit metadata set in the IOPTE.
  */
 struct iommu_hwpt_get_dirty_iova {
        __u32 size;
