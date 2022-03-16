Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82C0C4DBA35
	for <lists+kvm@lfdr.de>; Wed, 16 Mar 2022 22:37:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240653AbiCPViS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Mar 2022 17:38:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234842AbiCPVhv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Mar 2022 17:37:51 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F269DC2F;
        Wed, 16 Mar 2022 14:36:35 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22GLE96W030868;
        Wed, 16 Mar 2022 21:34:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=tyK6ULs57zlMValD0RLgemd3SNA81VXIDC4ESlZpx5E=;
 b=0Ev7N8vDZ0tOunuaxIKO9eRR6o+Iml/qe3m+3tMTAuWV6MZ/4ZgTgBbtQ7CaBACFalgp
 BK9bAqKpU8ZK3qsy/3rVrUnpv0/OT5u7z3VkqpyoeqbWZzfpsjcA/xLuAYgn/hfx+6c9
 mGhGcSGEGjASK+ffvG/uBTmO4T8d7uJOF788vfofR3MHH5Luv8QEjQVAp+YcbLD3Avak
 ZfSiAkoCtx5gW91DUyTQ086rWY9H7p5r4UUtytkN+CjFCt2duj1mYHyR9NFKgcpfDT+F
 uJzMdHLI8tUvs7qzKW/beHJk3uBho6GSA5FTLdb3VHbZIWh4b317kGoXfaTJw6eN6nO2 Lw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3et5s6qnek-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Mar 2022 21:34:56 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22GLG37Q069290;
        Wed, 16 Mar 2022 21:34:56 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2171.outbound.protection.outlook.com [104.47.73.171])
        by aserp3020.oracle.com with ESMTP id 3et64kxsxt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Mar 2022 21:34:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FT1Cn1yWZ1DYFmagwhF+TXy6bw+MYvJ9J7qK/Yk1gAS+ucJdp1B+eDmanHE5c6W1c1q+MGoLpohqcZ1PhKFzOano5+5qQVgUV0TO+UzxBRmgX8kOOVCmZnmEN/vYpjz6Yp3dXcA6Q8Fmbn+cJOWnTiwyR6QZy6spBZPBrG0SIkr9A+y9D8K8/lhlcfK/iGYayYVf7hFszV6wSfFajaXE8vwTLUJVGMl2JN8NclaE3FNYv4CtW+UCwbVm4e/UG4LkwikhxSlrlGHKaB+8X5TtpWs/XkY4gUFfwSQC4/Zu/AUhk9lOz6EjVFy20+/BopE0PGjgIM6Prd2VhBlB6cofsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tyK6ULs57zlMValD0RLgemd3SNA81VXIDC4ESlZpx5E=;
 b=lp0WRh/aCRLw5KwZ0R0Iehbx+gS3L/S+H4us9eu3zozZo5hsEun3U97Q8lSz6ZM7FO8t9lf2qXzQ+NZLMfNgCtW7ro2/iKOIUoj/+JCvz3SSxbtvrENeF48DXrUBxRTINzd2uMwt43ol8tzBjNxgMfYAxCNWUwkcVXFevFyPt8yBJx8Xp9rXT5FPSbIxaV4tJWER82ySP+eKBN0wZiTehYNMXWK579jDNOQuFL9rjfESwXuZ7NlcekPcR3wUHfy4/Ycn4/ryvPcjWsxesntO8l5mLhGyGPonyo2rPJhK4NG/6CyPWvgsqhikWb1gH3X0dEBvSi3O6u/8yjsvUPZmIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tyK6ULs57zlMValD0RLgemd3SNA81VXIDC4ESlZpx5E=;
 b=iODbxx89MvYw2hr6VIZkOrzFX9276+d+50V576umY2dfSz88WBgQSUDEG+JPeMUe0UkhT4Jcrh1l6fFjVvDsx8qUt2W07OJIuCO+ld4k03newAVJB5Uwi82nBdWG/r9w75LaJAetch7+Dixs/8sI4baA+K3rXjxXi/qW9Humnjw=
Received: from SN4PR10MB5622.namprd10.prod.outlook.com (2603:10b6:806:209::18)
 by MWHPR10MB1279.namprd10.prod.outlook.com (2603:10b6:301:7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.15; Wed, 16 Mar
 2022 21:34:53 +0000
Received: from SN4PR10MB5622.namprd10.prod.outlook.com
 ([fe80::4524:5537:c56e:8924]) by SN4PR10MB5622.namprd10.prod.outlook.com
 ([fe80::4524:5537:c56e:8924%3]) with mapi id 15.20.5038.031; Wed, 16 Mar 2022
 21:34:53 +0000
Message-ID: <91dd5f0a-61da-074d-42ed-bf0886f617d9@oracle.com>
Date:   Wed, 16 Mar 2022 22:34:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH 00/47] Address Space Isolation for KVM
Content-Language: en-US
To:     Junaid Shahid <junaids@google.com>, linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        pjt@google.com, oweisse@google.com, rppt@linux.ibm.com,
        dave.hansen@linux.intel.com, peterz@infradead.org,
        tglx@linutronix.de, luto@kernel.org, linux-mm@kvack.org,
        alexandre.chartre@oracle.com
References: <20220223052223.1202152-1-junaids@google.com>
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
In-Reply-To: <20220223052223.1202152-1-junaids@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR2P264CA0011.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::23)
 To SN4PR10MB5622.namprd10.prod.outlook.com (2603:10b6:806:209::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 783e9f7a-7ca6-409c-dc48-08da0794ce9a
X-MS-TrafficTypeDiagnostic: MWHPR10MB1279:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB12795737911D1315D696D5189A119@MWHPR10MB1279.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yD9/ugH5huNvXQ2yE6wFCtFhDGeONhGvTxEXCNYUQN3EOG1EFB/o+C3qRzOm4IfmJbDTXiNaWziLOEIjb0e3rFvfLbp/BELV5ThLfwsoeoUN6K8lGvtQjIkicRswp0TftEBZ+WvvAiB7Ik7mof9kc0ZGiLXFq6yXTYwr7M+hhq5/Zsiy8IhJNEl/u96JwL1qJduNddcoTd39vGIpq7Ftwp7Qe6/4tCm5q0rB0PFxeZtly4j/bC7v6F/jsvgpe1p6wCK8lmpUNZtFcfhLgyadhpzSF/H09gfz/8ejGrKj+8puULUbwZXonjLgYHlRUIdaWbUwHGN3LBexPxjvBL9MN95LJViBy9E76cYmPG9CgYzfAqDkFCFEGSCfHL5IQVSVy2BSe7eNmp0bw3IoC2r/GfxbWPBl7/FBOXmx0vBXJcZoAfL7DMeZgPZOpcZUmbqwy6rc1gKDcQLx6Fp61hS+21A2sZzC7chIMs/2suTWcSwp4fCApsIL/wVehhQ7mzP0iB/J2zZKK5dWcbWDaUSL6IxtK5GZz/k4YC0x2CyxVOs39w4gt4TSYyd96pzhJUxrfeOF1WevuEu0NBcdXNmaWfgeENe8+1XlL4VNkrLIhLkAZpB037JbtYSguQ2NmQyA7UH8Gm1ZZH0gP9kp+ZgNo5Tnb/vsd/LqwvjTRPenQJXG7zU3C+ysHBylMalgaeY2rV/P8N4zYV30PX6Uqo7WNz3d3FKufiHnQTPr9YmMRHLU5cA9ibEdfD41F3zFw7k2A3BR1vJmB2NN4H6lNfyVClQjn0Rf+awtC+iLzao3XbpCQxWASDQd+ZoVN40zPuG3D/hFa6w988gFwKH+lD8i3p+unzUhWmjTTrRrLLcAc6g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR10MB5622.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(31696002)(66946007)(8676002)(53546011)(107886003)(6666004)(26005)(186003)(66556008)(66476007)(2906002)(8936002)(30864003)(966005)(6486002)(5660300002)(508600001)(38100700002)(7416002)(6506007)(4326008)(2616005)(31686004)(83380400001)(6512007)(36756003)(44832011)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bm1Ta3p5cnpWdnpDRnM5OEJEZGpyYWt3QzM0cFNjNEU2MHZKWjM1aFZtWCtr?=
 =?utf-8?B?OVNwTGlFTkdmNFIwL2luVXRoOHpzZnY5VjRlRWZCQkNDeXdoSVhtQzluek1E?=
 =?utf-8?B?Rk1nVWpubEpmSjd1a1BDNHVuSDl4RktibUp1bk5uMzNYUGdvMEw4YTJZNGJa?=
 =?utf-8?B?TzlaODdLS3VkMjlqSC9lUmhHN01xcFBWc2NHUWpHTmZmaU9SRFNSakFENFVW?=
 =?utf-8?B?Snd5enFWbnFyRHRER1UvN3BZcEtkOGtub1pjWFFuZkFsa3ZVRHdYcFlkVTRX?=
 =?utf-8?B?bmpWUU5pSDJPTFlReDBYSVJnK1hpYWVMTGhHTG1zOTZGT1piRFNVK29SUUl4?=
 =?utf-8?B?TGZ5ZGoxR01UYk1zbzZmVmFaTXlxNWhlRjhPUmtpVTR0TlduNUVGRWRZamM4?=
 =?utf-8?B?T0RlL1VWVjFXYmY1Z2tHUFhyL0w4K2s2a3RBNVJKalc5UmtpSDBZUno4MEE1?=
 =?utf-8?B?TWZHaEptMDJLcGtVSXhDbXhLTE93Nkk0QWkrYU9scWQ5dGIxOVVLL0krSlRQ?=
 =?utf-8?B?U21od0pnOTI5cFlnZDhnZU90bTRub2w2OW9LUGJhRTl6bUhtWUw0cE0yclpM?=
 =?utf-8?B?VWY4cGROWTdKSVpDQ0I1d2lIVFk0OTFpU1owNVp0K1preXNkTTRMZkM1YmRW?=
 =?utf-8?B?Umg5OHFZMHJVM1U2Sjcrbll5U0tlSCtvZTVNRlRkaWdwS3dlNTFBV3RZSHcw?=
 =?utf-8?B?ZmFrMXB0WlNRY0ZRSzdSOFppUTd2dnNQQjBka2VOeGwyZDVuQ3ZmczhqK2x5?=
 =?utf-8?B?ZlJCMVphdE1DY1A5d1NvUXAwNnJaNlJXMFJVSTJtbEl4NEU5Zis3elJQRDhV?=
 =?utf-8?B?SEFkQ04yTnZNUy9qVkZQM0VCS3JocWU0RDdQVHVtVDQ2d2g3dm5mcnNKMGxP?=
 =?utf-8?B?L3JYUHpNZDRackptS0dHYzVKWmlWdXdMeXpRVVBja3FJeVBabjhNL1NEUUxu?=
 =?utf-8?B?NDI5Q1JtMFFkVlRTcHo2d0FuRC9WdG5rT2s2d3dKOFBGTWpmVy9GTGtEcHhT?=
 =?utf-8?B?T2lnOUw4b3JkN0lQOHhXK05BN3hxWUJaLzlKcm1wQkpHUWljdGgyOUUyaXBm?=
 =?utf-8?B?eVNUSXo0bGY4V2J6ajIxYVkrWDV1RlBRSiswdEdMS0M2VmZGRHpYR2RuYzJv?=
 =?utf-8?B?OXJJNFJ2Qm82MWU5WlpDRmlRSzZEd2pIQnBtcE9ueVI0SkNKcHYwRjRzLzN1?=
 =?utf-8?B?Vk9aTzJWTENJcFhRUjJVb3JtOG0vU2NFbDBxR3ZKNzRsM2RnREsrRjdxOXNY?=
 =?utf-8?B?b0JiMWlrNHNRelFWMkp0QmZGV0luUkJ4b3NrTytYdDJDY1lUVGRJc2x1cDVq?=
 =?utf-8?B?elowSmp6ZmRHOTBXQ2dsejBzaVVnN0xSUEhuL1ZSNDVOL0tNVHFXUTdackJE?=
 =?utf-8?B?MEJ2OE01VnByeE5wNkZoamc1ZnZTcW0xOEFJZUgzQUFNR2tTcUlZRC9MSXhU?=
 =?utf-8?B?eW5zdXpqY3cwL1gzMytpUXc5dkZzTmRLa2FiTzZSSmY3ZVFUQi9zc0ZVbTVa?=
 =?utf-8?B?ZFY2Z1l5YkhIeUxXcnZjeHg2dmJUUVNXaFFVNGVBd2hqUHNOa2ZrdTdvd2xH?=
 =?utf-8?B?T2lnMzVaTUZnMFU3SWFPSVRHMzhTS01wYXJLTDVsdVZZd3FHY2Fna1hyYkVK?=
 =?utf-8?B?aHMwUVJpeDdXM096NlcvWGUvZTlGM1QrR1BZaHFHcE1lTVhWK21BbC9aeDdu?=
 =?utf-8?B?bk80YmRuK2tOTFA0dmlwdmdYQk44bEhJQ1J6K1JTUUI2UDQ3U3VRczNzcmxv?=
 =?utf-8?B?N3JRTGdKYXNqTDUvaXJsVG0zbFE1NTd3SjROdjAxVWM5cytoSFhaeGdGZTZZ?=
 =?utf-8?B?c2hjcm1VVWNTazMvMFl4MW41SXMxcFlveXEvK1NueFUrTHJwcitpdmY0andE?=
 =?utf-8?B?V2RtTURnNEJGNTVtY0dnU2xlT0RTVWRRRmRyRHdKZitWSkVWVGJNZ2JNZVNJ?=
 =?utf-8?B?ZGd0QjR2Mzc2NDNtTlQySXB2bThxOGFURjZaNEw4VDJxVkk4STRDdWFnaWV6?=
 =?utf-8?B?clAraFdEYVNnPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 783e9f7a-7ca6-409c-dc48-08da0794ce9a
X-MS-Exchange-CrossTenant-AuthSource: SN4PR10MB5622.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2022 21:34:53.0405
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zn8IjfiwZKlDv8SK7N53cIjKGTcW8BGhpUD6Ae9nn8x4Fvju3CkFo703aWcuhHBMxhHL6JEcfHCYmT7Ys1rMc3K8GgTT6j83eJY3Kde9Nyg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1279
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10288 signatures=693715
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203160128
X-Proofpoint-GUID: JrIC0Cf74PBWsRFYrz0jSl5HafnxMcts
X-Proofpoint-ORIG-GUID: JrIC0Cf74PBWsRFYrz0jSl5HafnxMcts
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Hi Junaid,

On 2/23/22 06:21, Junaid Shahid wrote:
> This patch series is a proof-of-concept RFC for an end-to-end implementation of
> Address Space Isolation for KVM. It has similar goals and a somewhat similar
> high-level design as the original ASI patches from Alexandre Chartre
> ([1],[2],[3],[4]), but with a different underlying implementation. This also
> includes several memory management changes to help with differentiating between
> sensitive and non-sensitive memory and mapping of non-sensitive memory into the
> ASI restricted address spaces.
> 
> This RFC is intended as a demonstration of what a full ASI implementation for
> KVM could look like, not necessarily as a direct proposal for what might
> eventually be merged. In particular, these patches do not yet implement KPTI on
> top of ASI, although the framework is generic enough to be able to support it.
> Similarly, these patches do not include non-sensitive annotations for data
> structures that did not get frequently accessed during execution of our test
> workloads, but the framework is designed such that new non-sensitive memory
> annotations can be added trivially.
> 
> The patches apply on top of Linux v5.16. These patches are also available via
> gerrit at https://linux-review.googlesource.com/q/topic:asi-rfc.
>
Sorry for the late answer, and thanks for investigating possible ASI
implementations. I have to admit I put ASI on the back-burner for
a while because I am more and more wondering if the complexity of
ASI is worth the benefit, especially given challenges to effectively
exploit flaws that ASI is expected to mitigate, in particular when VMs
are running on dedicated cpu cores, or when core scheduling is used.
So I have been looking at a more simplistic approach (see below, A
Possible Alternative to ASI).

But first, your implementation confirms that KVM-ASI can be broken up
into different parts: pagetable management, ASI core and sibling cpus
synchronization.

Pagetable Management
====================
For ASI, we need to build a pagetable with a subset of the kernel
pagetable mappings. Your solution is interesting as it is provides
a broad solution and also works well with dynamic allocations (while
my approach to copy mappings had several limitations). The drawback
is the extend of your changes which spread over all the mm code
(while the simple solution to copy mappings can be done with a few
self-contained independent functions).

ASI Core
========

KPTI
----
Implementing KPTI with ASI is possible but this is not straight forward.
This requires some special handling in particular in the assembly kernel
entry/exit code for syscall, interrupt and exception (see ASI RFC v4 [4]
as an example) because we are also switching privilege level in addition
of switching the pagetable. So this might be something to consider early
in your implementation to ensure it is effectively compatible with KPTI.

Going beyond KPTI (with a KPTI-next) and trying to execute most
syscalls/interrupts without switching to the full kernel address space
is more challenging, because it would require much more kernel mapping
in the user pagetable, and this would basically defeat the purpose of
KPTI. You can refer to discussions about the RFC to defer CR3 switch
to C code [7] which was an attempt to just reach the kernel entry C
code with a KPTI pagetable.

Interrupts/Exceptions
---------------------
As long as interrupts/exceptions are not expected to be processed with
ASI, it is probably better to explicitly exit ASI before processing an
interrupt/exception, otherwise you will have an extra overhead on each
interrupt/exception to take a page fault and then exit ASI.

This is particularily true if you have want to have KPTI use ASI, and
in that case the ASI exit will need to be done early in the interrupt
and exception assembly entry code.

ASI Hooks
---------
ASI hooks are certainly a good idea to perform specific actions on ASI
enter or exit. However, I am not sure they are appropriate places for cpus
stunning with KVM-ASI. That's because cpus stunning doesn't need to be
done precisely when entering and exiting ASI, and it probably shouldn't be
done there: it should be done right before VMEnter and right after VMExit
(see below).

Sibling CPUs Synchronization
============================
KVM-ASI requires the synchronization of sibling CPUs from the same CPU
core so that when a VM is running then sibling CPUs are running with the
ASI associated with this VM (or an ASI compatible with the VM, depending
on how ASI is defined). That way the VM can only spy on data from ASI
and won't be able to access any sensitive data.

So, right before entering a VM, KVM should ensures that sibling CPUs are
using ASI. If a sibling CPU is not using ASI then KVM can either wait for
that sibling to run ASI, or force it to use ASI (or to become idle).
This behavior should be enforced as long as any sibling is running the
VM. When all siblings are not running the VM then other siblings can run
any code (using ASI or not).

I would be interesting to see the code you use to achieve this, because
I don't get how this is achieved from the description of your sibling
hyperthread stun and unstun mechanism.

Note that this synchronization is critical for ASI to work, in particular
when entering the VM, we need to be absolutely sure that sibling CPUs are
effectively using ASI. The core scheduling sibling stunning code you
referenced [6] uses a mechanism which is fine for userspace synchronization
(the delivery of the IPI forces the sibling to immediately enter the kernel)
but this won't work for ASI as the delivery of the IPI won't guarantee that
the sibling as enter ASI yet. I did some experiments that show that data
will leak if siblings are not perfectly synchronized.

A Possible Alternative to ASI?
=============================
ASI prevents access to sensitive data by unmapping them. On the other
hand, the KVM code somewhat already identifies access to sensitive data
as part of the L1TF/MDS mitigation, and when KVM is about to access
sensitive data then it sets l1tf_flush_l1d to true (so that L1D gets
flushed before VMEnter).

With KVM knowing when it accesses sensitive data, I think we can provide
the same mitigation as ASI by simply allowing KVM code which doesn't
access sensitive data to be run concurrently with a VM. This can be done
by tagging the kernel thread when it enters KVM code which doesn't
access sensitive data, and untagging the thread right before it accesses
sensitive data. And when KVM is about to do a VMEnter then we synchronize
siblings CPUs so that they run threads with the same tag. Sounds familar?
Yes, because that's similar to core scheduling but inside the kernel
(let's call it "kernel core scheduling").

I think the benefit of this approach would be that it should be much
simpler to implement and less invasive than ASI, and it doesn't preclude
to later do ASI: ASI can be done in addition and provide an extra level
of mitigation in case some sensitive is still accessed by KVM. Also it
would provide the critical sibling CPU synchronization mechanism that
we also need with ASI.

I did some prototyping to implement this kernel core scheduling a while
ago (and then get diverted on other stuff) but so far performances have
been abyssal especially when doing a strict synchronization between
sibling CPUs. I am planning go back and do more investigations when I
have cycles but probably not that soon.


alex.

[4] https://lore.kernel.org/lkml/20200504144939.11318-1-alexandre.chartre@oracle.com
[6] https://lore.kernel.org/lkml/20200815031908.1015049-1-joel@joelfernandes.org
[7] https://lore.kernel.org/lkml/20201109144425.270789-1-alexandre.chartre@oracle.com


> Background
> ==========
> Address Space Isolation is a comprehensive security mitigation for several types
> of speculative execution attacks. Even though the kernel already has several
> speculative execution vulnerability mitigations, some of them can be quite
> expensive if enabled fully e.g. to fully mitigate L1TF using the existing
> mechanisms requires doing an L1 cache flush on every single VM entry as well as
> disabling hyperthreading altogether. (Although core scheduling can provide some
> protection when hyperthreading is enabled, it is not sufficient by itself to
> protect against all leaks unless sibling hyperthread stunning is also performed
> on every VM exit.) ASI provides a much less expensive mitigation for such
> vulnerabilities while still providing an almost similar level of protection.
> 
> There are a couple of basic insights/assumptions behind ASI:
> 
> 1. Most execution paths in the kernel (especially during virtual machine
> execution) access only memory that is not particularly sensitive even if it were
> to get leaked to the executing process/VM (setting aside for a moment what
> exactly should be considered sensitive or non-sensitive).
> 2. Even when executing speculatively, the CPU can generally only bring memory
> that is mapped in the current page tables into its various caches and internal
> buffers.
> 
> Given these, the idea of using ASI to thwart speculative attacks is that we can
> execute the kernel using a restricted set of page tables most of the time and
> switch to the full unrestricted kernel address space only when the kernel needs
> to access something that is not mapped in the restricted address space. And we
> keep track of when a switch to the full kernel address space is done, so that
> before returning back to the process/VM, we can switch back to the restricted
> address space. In the paths where the kernel is able to execute entirely while
> remaining in the restricted address space, we can skip other mitigations for
> speculative execution attacks (such as L1 cache / micro-arch buffer flushes,
> sibling hyperthread stunning etc.). Only in the cases where we do end up
> switching the page tables, we perform these more expensive mitigations. Assuming
> that happens relatively infrequently, the performance can be significantly
> better compared to performing these mitigations all the time.
> 
> Please note that although we do have a sibling hyperthread stunning
> implementation internally, which is fully integrated with KVM-ASI, it is not
> included in this RFC for the time being. The earlier upstream proposal for
> sibling stunning [6] could potentially be integrated into an upstream ASI
> implementation.
> 
> Basic concepts
> ==============
> Different types of restricted address spaces are represented by different ASI
> classes. For instance, KVM-ASI is an ASI class used during VM execution. KPTI
> would be another ASI class. An ASI instance (struct asi) represents a single
> restricted address space. There is a separate ASI instance for each untrusted
> context (e.g. a userspace process, a VM, or even a single VCPU etc.) Note that
> there can be multiple untrusted security contexts (and thus multiple restricted
> address spaces) within a single process e.g. in the case of VMs, the userspace
> process is a different security context than the guest VM, and in principle,
> even each VCPU could be considered a separate security context (That would be
> primarily useful for securing nested virtualization).
> 
> In this RFC, a process can have at most one ASI instance of each class, though
> this is not an inherent limitation and multiple instances of the same class
> should eventually be supported. (A process can still have ASI instances of
> different classes e.g. KVM-ASI and KPTI.) In fact, in principle, it is not even
> entirely necessary to tie an ASI instance to a process. That is just a
> simplification for the initial implementation.
> 
> An asi_enter operation switches into the restricted address space represented by
> the given ASI instance. An asi_exit operation switches to the full unrestricted
> kernel address space. Each ASI class can provide hooks to be executed during
> these operations, which can be used to perform speculative attack mitigations
> relevant to that class. For instance, the KVM-ASI hooks would perform a
> sibling-hyperthread-stun operation in the asi_exit hook, and L1-flush/MDS-clear
> and sibling-hyperthread-unstun operations in the asi_enter hook. On the other
> hand, the hooks for the KPTI class would be NO-OP, since the switching of the
> page tables is enough mitigation in that case.
> 
> If the kernel attempts to access memory that is not mapped in the currently
> active ASI instance, the page fault handler automatically performs an asi_exit
> operation. This means that except for a few critical pieces of memory, leaving
> something out of an unrestricted address space will result in only a performance
> hit, rather than a catastrophic failure. The kernel can also perform explicit
> asi_exit operations in some paths as needed.
> 
> Apart from the page fault handler, other exceptions and interrupts (even NMIs)
> do not automatically cause an asi_exit and could potentially be executed
> completely within a restricted address space if they don't end up accessing any
> sensitive piece of memory.
> 
> The mappings within a restricted address space are always a subset of the full
> kernel address space and each mapping is always the same as the corresponding
> mapping in the full kernel address space. This is necessary because we could
> potentially end up performing an asi_exit at any point.
> 
> Although this RFC only includes an implementation of the KVM-ASI class, a KPTI
> class could also be implemented on top of the same infrastructure. Furthermore,
> in the future we could also implement a KPTI-Next class that actually uses the
> ASI model for userspace processes i.e. mapping non-sensitive kernel memory in
> the restricted address space and trying to execute most syscalls/interrupts
> without switching to the full kernel address space, as opposed to the current
> KPTI which requires an address space switch on every kernel/user mode
> transition.
> 
> Memory classification
> =====================
> We divide memory into three categories.
> 
> 1. Sensitive memory
> This is memory that should never get leaked to any process or VM. Sensitive
> memory is only mapped in the unrestricted kernel page tables. By default, all
> memory is considered sensitive unless specifically categorized otherwise.
> 
> 2. Globally non-sensitive memory
> This is memory that does not present a substantial security threat even if it
> were to get leaked to any process or VM in the system. Globally non-sensitive
> memory is mapped in the restricted address spaces for all processes.
> 
> 3. Locally non-sensitive memory
> This is memory that does not present a substantial security threat if it were to
> get leaked to the currently running process or VM, but would present a security
> issue if it were to get leaked to any other process or VM in the system.
> Examples include userspace memory (or guest memory in the case of VMs) or kernel
> structures containing userspace/guest register context etc. Locally
> non-sensitive memory is mapped only in the restricted address space of a single
> process.
> 
> Various mechanisms are provided to annotate different types of memory (static,
> buddy allocator, slab, vmalloc etc.) as globally or locally non-sensitive. In
> addition, the ASI infrastructure takes care to ensure that different classes of
> memory do not share the same physical page. This includes separation of
> sensitive, globally non-sensitive and locally non-sensitive memory into
> different pages and also separation of locally non-sensitive memory for
> different processes into different pages as well.
> 
> What exactly should be considered non-sensitive (either globally or locally) is
> somewhat open-ended. Some things are clearly sensitive or non-sensitive, but
> many things also fall into a gray area, depending on how paranoid one wants to
> be. For this proof of concept, we have generally treated such things as
> non-sensitive, though that may not necessarily be the ideal classification in
> each case. Similarly, there is also a gray area between globally and locally
> non-sensitive classifications in some cases, and in those cases this RFC has
> mostly erred on the side of marking them as locally non-sensitive, even though
> many of those cases could likely be safely classified as globally non-sensitive.
> 
> Although this implementation includes fairly extensive support for marking most
> types of dynamically allocated memory as locally non-sensitive, it is possibly
> feasible, at least for KVM-ASI, to get away with a simpler implementation (such
> as [5]), if we are very selective about what memory we treat as locally
> non-sensitive (as opposed to globally non-sensitive). Nevertheless, the more
> general mechanism is included in this proof of concept as an illustration for
> what could be done if we really needed to treat any arbitrary kernel memory as
> locally non-sensitive.
> 
> It is also possible to have ASI classes that do not utilize the above described
> infrastructure and instead manage all the memory mappings inside the restricted
> address space on their own.
> 
> 
> References
> ==========
> [1] https://lore.kernel.org/lkml/1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com
> [2] https://lore.kernel.org/lkml/1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com
> [3] https://lore.kernel.org/lkml/1582734120-26757-1-git-send-email-alexandre.chartre@oracle.com
> [4] https://lore.kernel.org/lkml/20200504144939.11318-1-alexandre.chartre@oracle.com
> [5] https://lore.kernel.org/lkml/20190612170834.14855-1-mhillenb@amazon.de
> [6] https://lore.kernel.org/lkml/20200815031908.1015049-1-joel@joelfernandes.org
> 
