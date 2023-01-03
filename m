Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A889765C5D1
	for <lists+kvm@lfdr.de>; Tue,  3 Jan 2023 19:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238116AbjACSMp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Jan 2023 13:12:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233243AbjACSMn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Jan 2023 13:12:43 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F289A10B0
        for <kvm@vger.kernel.org>; Tue,  3 Jan 2023 10:12:36 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 303G3cra017723;
        Tue, 3 Jan 2023 18:12:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=bWqQ+qNkBIB/x0C744YJyNX89dZILpVkVlHf4LUgfMs=;
 b=pD3AMkD4h8mNfMoLUeb4k1hT728AtRI8lvcbPIdmSZ2ScQglEdTNOOmzPwqUkTxno9ik
 oSKNBkSWUyYBsLWBYg8jqWkClcxWFBJWFUZFT4NZc3IwsEACHFESMwlkyiyt/G+nOjG3
 YwQ6YLLnmx2Q1Z9Wju2dzM1px8vboj9nFgwIjjZpb9YIB7tsZgk4wc3BRiVnN6IBUVO0
 bLZI/kiRYyYiDjXeiZ5zAQLjKphT8D86xJ6fTjWPuGbipkvspjzLluKSZ4GutvUjE36z
 hzNcGObUtaLi54yVdkNH0ADGr/5mv+ND1FVHQQ37ZJCsygqnAYnmY65UK74cr2xMkrjW zw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mtbv2vs52-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Jan 2023 18:12:32 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 303GdAm3014734;
        Tue, 3 Jan 2023 18:12:31 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mtbhbfn5g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Jan 2023 18:12:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZI85SCg1nnwHbk/cfpagwjHA6ng34WILctxoF+CPWevuRViFvbg+qSDthJpguSLcJC3yWJAoyq4dlaZT0bGmVDv+hWvwb3CaV3nfxo174a2D4rH4HZIRtgOTffqnQV+wJsCbsZ/UuBayOw2uaJqWYSkt6sbdqt2Vq12eXRN4HjSpELBSqsEVH7PE6DnAoTpO1pLBQIOpeVLnF+kBzPfU/Pqf+8eLgXxi6nBCicI3WIgX98Otz94KfWtV5MuB5INljd7bWaGbKHZBj8FtoshIQsy+e+o0P1s8sKlWf/mEcCNapKJhIbDrJmFLPQ4ucJgVc5pQqOlgX2Kfi2GguxvSzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bWqQ+qNkBIB/x0C744YJyNX89dZILpVkVlHf4LUgfMs=;
 b=kpcPe57Edrwb5xbB+nRs+3y4xQ53K9EiCqLROoiIf6CkzFvdBkSPkIeGkuyr7VAVZZxBX6Q3M/CgigiaiGLosQ4c0hEu5nq9XcqjVLDwDcn42fHtXLeER3YZdgfZ1gipBvX0sILj2lbSLqwlKcmsPV64Y0hLgNz6bpdjOis4mF8d6VmhKz2Wp0rncp5gemy9skUhIBOMgIrd+3mieU2moqhvEpxc0CzMncZ39QHHy2hj8UvV7cvccaMJgfNXEHl+yOFBhgFyyxZ/5kE71Oh/9oOC0KMyQSPmj5VWiFRokwNX+LI0Nwim99OgIy5Rsv35wTRXUo4dY6VTnyJ/I9VoAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bWqQ+qNkBIB/x0C744YJyNX89dZILpVkVlHf4LUgfMs=;
 b=B7yi4kLWC4jrEzN2eFxIYUGZtQuX0B5o3EOSnEXCit8naDC+lK6+upKQlLowOTxSH4szfYFpe+unWIUsn2cW+dnq1QRAxMSML65ElijY5/vgl7+nTsqIs1QmSJyJlkptLDjyUA1qb4c9aXHcZl0A9jTE7ALYfV2FphmZm2jAIoI=
Received: from SA2PR10MB4684.namprd10.prod.outlook.com (2603:10b6:806:119::14)
 by DM4PR10MB7428.namprd10.prod.outlook.com (2603:10b6:8:190::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Tue, 3 Jan
 2023 18:12:29 +0000
Received: from SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::3667:7f89:cdc7:9cca]) by SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::3667:7f89:cdc7:9cca%3]) with mapi id 15.20.5944.019; Tue, 3 Jan 2023
 18:12:29 +0000
Message-ID: <db86aa79-2807-39af-074b-aefcd57b22ab@oracle.com>
Date:   Tue, 3 Jan 2023 13:12:26 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH V7 4/7] vfio/type1: restore locked_vm
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     kvm@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>
References: <1671568765-297322-1-git-send-email-steven.sistare@oracle.com>
 <1671568765-297322-5-git-send-email-steven.sistare@oracle.com>
 <Y7RISZXrvjzIyktd@nvidia.com>
Content-Language: en-US
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <Y7RISZXrvjzIyktd@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR12CA0006.namprd12.prod.outlook.com
 (2603:10b6:5:1c0::19) To SA2PR10MB4684.namprd10.prod.outlook.com
 (2603:10b6:806:119::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR10MB4684:EE_|DM4PR10MB7428:EE_
X-MS-Office365-Filtering-Correlation-Id: 3707e7f2-e150-4be9-d9b8-08daedb61392
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r6I+zF/vmXhA8DZBYwsWmjHn3817nkCD8BOfKxYjkxGOylB4DxsWst8jdrkRDLEGCE2tW3tsTLVj9jM2H2IeKp6MXwxSzCJxWS+c0iqM4s9jL9eIAVdDtWVV60kzE4Jk4vHZWkIca/AURBaZAE9dk8YZGnaxMbJ9TKNibn9Q/ztK9qyLbqb3srilEm0BSlwfZGFquhH2MPPoi5Wbk2jcXD5DXIQmaY70j2WnzEYpk5SEmmjvoSoYzzKn8Ireto0bTOCTwAAS1VQY4CywpMn0Q8oWUlevauhGmcdcbVEi6+h8n0LN1q1agyVzX7cokXtIjdHLs9qk5cPBkF5YtjKgBt/ruIulSDjMhRvwdJ53AOb7VJ58Njp/jYpP83hxi9vA/j5yfpAHc1h2WEIMCx/z/Lpkjd4dkTopdLkL/CHcwVr3fF3t2EgGE7JCVIAILgmATFbW3ULBSBr5MY8WAIkJvhdypaGt47hf/Vl0yWeeKBiDBRm81KCEZkE8ou2N6i/icAoDY99RZa3bHvDsCmmCni4YWLY9mLlYK07BqWL1PU5aZq5PcbfX9HVkN5HZUbeNMIwUfvpC+Zk0Z4kJt8ED8/R8Eb/xTKoarMu85trc0BQwN9ZExyodYHJTuH8wWjDenbtyMlR6UsYriKxWvxv2pnUiG34Ec1kLaWI6dVnFJY1BwzXJF37IGGZfzA45QYMPx1Ok2756j/KwEalPamt1lbNSFNNL6Bmt4uUCluQXEXhmsi8F+qWaJ3IyHKmfB8ea
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4684.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(136003)(346002)(366004)(376002)(451199015)(8676002)(66476007)(66556008)(66946007)(8936002)(4326008)(5660300002)(31686004)(2906002)(44832011)(54906003)(6916009)(316002)(6506007)(478600001)(36916002)(6486002)(6666004)(41300700001)(53546011)(6512007)(26005)(186003)(83380400001)(2616005)(38100700002)(36756003)(86362001)(31696002)(22166006)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dGNRVGJtRzl3L3ZYcEM0bWVEUURrQjMzeU80L2kyK2N1UnhvVXIwV2Jzb1pD?=
 =?utf-8?B?emVScUZ3M3ZYNUJmbWh0UUdlTS96c2hJM0lmL3d1Z0xtUXJ1UnhHdlJBdDRZ?=
 =?utf-8?B?UUw4VjlMUU5PTi81VmhMK2JhY09NRmRwb242NXZ3UjRueTRPem5xalNUMHdM?=
 =?utf-8?B?MEJzUDZwTThmZjQrUjNjV1BlTHZLQUJ6WjBvZjJJUlo0QjJ0NGlrSmJGZUxI?=
 =?utf-8?B?d1BSK01xQjBjN2FmREJFQ2tBZzFLcjA3LzJMRHVTVXMvK0NWVGNpN01ONkhC?=
 =?utf-8?B?NDRIajM4THUxQkhIcUZrVXpVQ1pHUkRZUGtzOUx5S0cwbjRVZzlST0tXdzRC?=
 =?utf-8?B?dTU3ZVRrTnZUUjVFY1JOb1VraE9qazBtSGJRa0Y4MVp4K081NFJETm12UndM?=
 =?utf-8?B?VjNXemx2ZlYyQ05GZ1ZrOTRvZDd4d3d3eUR3eFZVRldGd0p0emZBRWY4a25v?=
 =?utf-8?B?NGVHZkp6cE9vZlZLSTIyYWx3R0FJUXBnMWJPNlNjRjF2U2J2VzdHSlR2RUw2?=
 =?utf-8?B?ZUFEejF4b0pSMVd3blFxQ1orVjY2ZXNDV09laWJGUkQwNUNlY1NndHhoY0k2?=
 =?utf-8?B?alg2NU55T0dKTXBMNjdsRFJDSzJOSVVLVjdkOExITjFnVEZlV1QrSWVBcFhG?=
 =?utf-8?B?K2VVWXRkM3A0VkhJSlNPZ2Z0c01zbTErS0JjQ1daTk9RY1lHWkkwT2thbDNa?=
 =?utf-8?B?UVNENDRxV3lzMEFqK0VJWVFRcHZsa2tQSFIxTGhvaEh4cnVGWEV1dHQ2bzVT?=
 =?utf-8?B?NEt2bE9QRUhxMDN2NjEyK2g3MnpxT25xdytVcUhQZjNlaVJhd2Z3VWJJNkpB?=
 =?utf-8?B?VWR0OXV2ZTU5WGE1dzFqWHVuclVsU1VHaTcrVWN2ZHZqTWhwR1FMWG1MWkNh?=
 =?utf-8?B?REZaVGVJTzRldXRUci95c0c2VDd1bVBxNXQvbnRGQmlBY25WTkJneVl0bHY0?=
 =?utf-8?B?UWRGN2dEbXFWS0hCK1kxT0h0eUlrdU5ndERWVjF2aVR2WEh6QTlWNUl1SFpu?=
 =?utf-8?B?MENoYnExaklTT0pxRWJNVlpTbEZnTy95OUxScTQxb3VYVXVFQUdDMmJEQUV4?=
 =?utf-8?B?QlJ0MWltdTZuZE9pR1V3d2VET09NaEYyWDllMkJITmF3UkpKYk1ZaVRsS0hM?=
 =?utf-8?B?WTVvK3phQTFsS3NaNzFMTXJQNlFFQ2ZYeERWWXpEOWZuMTMxdEtzTWhIQlhm?=
 =?utf-8?B?WTh4Sk4wYThUVmoxYXBaRVJaazZwT1JHUG44MS9YSVlnWmJIajdtKzlrYk5v?=
 =?utf-8?B?UzkzNkpKazdhOWN0aWFUYlVpQkNhcUJXeXhSMUFENUNVdm81UmxuRmR5RTNR?=
 =?utf-8?B?ZXY5d1pZZ2hKN2R0SXR4cW5VM1dndVR2WWhGQ2NlbE84QUgreGFvRmRyT0Jx?=
 =?utf-8?B?ckpLVFdFNERPVkxUSjVoeU1oUFNNRDBLSkRwekJxcWt1WHlTSnJhVkZ5MHNp?=
 =?utf-8?B?dkRTaVBMYUdsRXgveDlIVnhWMFI2QjRYejRjcGtBRU01R2NsZk9ZT1ZBemNW?=
 =?utf-8?B?MWpRdVZPbmxmaXJrOFc3cUFRREJxcVRTT1J2RCtMUmNqcjRuV01xc1VTWXNW?=
 =?utf-8?B?RHovM2kvTjQxemFNQ3ZheGhOSmphbVFtVFZVaXV0bmNCSW85ald2MUgwWHRQ?=
 =?utf-8?B?WHBTeERiRWRzRkYvWFJpcFc1Y05icisvNjE3VkpLTm1lakxscjk0VkxaYVBl?=
 =?utf-8?B?c0xEdlpIeHJtS1RpSjUwWTdGdnc1M09VdGJFb2pRM0tWS1o4SDJ2bjFSTlpm?=
 =?utf-8?B?UkFyVXVHVTViVXpidUZOTndja29MbjA5VFdtcVRtQmVnYTRLWWJvUUhXSm1w?=
 =?utf-8?B?Z3U2L29nZndCUExvRGxKYmh5ZGhqdjBjUkdCSUFYL1hLK3c5NUttUUVTQ2Fi?=
 =?utf-8?B?MzlQVFM3eGd1RjEzUTNUWHY4YTJSV3hMb2dpUDQwK0pacWtFeGFzcEpoZWxy?=
 =?utf-8?B?d1Eyb3EvNDczQ3NqNERnWGdtRWdjdWpadDdEOGVKalBaRnptUHVteUdVNGVr?=
 =?utf-8?B?elFUR0dtTUpXcHlSNkN2Y3lQYWxBOW0vczFKWlV3QzlENFB6NnRUTHc1eHhS?=
 =?utf-8?B?ZGdjMXBTSFlJb2RzUWVnUGRpbTVKNEhOL1N3cUw3bzFLWTNocGJHQnZBcGs4?=
 =?utf-8?B?R2VsSVpHZ0FVc0RMRjFVSVYweEJnVzdmRitKVHZnNStJdENMbkNwRWRybzIr?=
 =?utf-8?B?eGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 0sPc95Wccx8xISgd5De1Qx2m86RqbskHUkkvQTRXxOteC3DCWCLOC4Lve+sQjstS4GqxyUK4u8NNKBs5qQiNWCmPJwh6c5afi5MmCAOH1vL4dRBb03ieemBFhe6uJrIDv1Pu39SlI2ahJfZrUFCqfu6Q+r2gx+WT3Cax/TfCHpEVZe5sPEFfxxNFO9iPZj8cSgLmDlNsLNT6gZ5qCQabSo/O7wfMfAjFvHSNaX/9xUleTAog9UwZViw1bgvFW6ArmbtWwSm4a5IIJpa+LS13c3IS+xcgceumBfaU740uYx8R3oG5ecIdcKC9jZDDZIx9KDpmJmu1quaYCroLxCZ77k87qnA9A++1b0YiqjVEpGISia3SpP5t0ECusDbtIGdgy0vXKVr4kHYuDGqkJ3QtD6U5CBhVI4tzdqw/6mY32UBBFeSdoCyC/1Xy5KlimHrGONMnzMCCt8ZQhRHP4of2b3pBDDSi0rdBcEM/2CNGQ2x34eC/6n6j2QADoDH5nJpatdKxVOHNB7bgtnXmJVyYjl1dS4z7vx5Dd9jZn4IyL63P32YzL9/ilAdayg2azMzZXiTdVqoafaIkFkZ5F6I3Hgc5IZQhPeNaKGMCiwntAQ2g3dUO2cZBgwQOv5aCJcPUzYC68L89hiHnPF/QIlBP5m8iiK/sQCDIceIdoLZk++n2Dch9HbXBMec0p0rdSj2KQg1br/33r9fKdiAI6zDgo3cqmK3mKuAlln8BsiupXUDbb3EUaBhzVQTiyFO7kqiK6p/pXU3E1exNOHj8KNWkj2+ZFFAG00Di6cYissw7VErVHeTok2EEoxAKbw3wiVopTi42eTZnR0Zya3CVfz3i3Lwqo4Ku3hN0uFd+2D5/OcbdQqkZ0tlJDISBtRg9YhZb
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3707e7f2-e150-4be9-d9b8-08daedb61392
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4684.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2023 18:12:29.5974
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V4p9N/Xts/HXye21z/Jad3b18uF3uQc89LZi3c057YuNdhYMM4AFQEL4QrjInfnYp0MQ7a1BnPu0YoU0OMPNnBYB3awOJr14QEdpvq09ryA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB7428
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-03_07,2023-01-03_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 bulkscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301030155
X-Proofpoint-GUID: mPTVWLBxXYTHtZT2qqi0ZUvryz9GZwpB
X-Proofpoint-ORIG-GUID: mPTVWLBxXYTHtZT2qqi0ZUvryz9GZwpB
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/3/2023 10:22 AM, Jason Gunthorpe wrote:
> On Tue, Dec 20, 2022 at 12:39:22PM -0800, Steve Sistare wrote:
>> When a vfio container is preserved across exec or fork-exec, the new
>> task's mm has a locked_vm count of 0.  After a dma vaddr is updated using
>> VFIO_DMA_MAP_FLAG_VADDR, locked_vm remains 0, and the pinned memory does
>> not count against the task's RLIMIT_MEMLOCK.
>>
>> To restore the correct locked_vm count, when VFIO_DMA_MAP_FLAG_VADDR is
>> used and the dma's mm has changed, add the dma's locked_vm count to
>> the new mm->locked_vm, subject to the rlimit.
>>
>> Fixes: c3cbab24db38 ("vfio/type1: implement interfaces to update vaddr")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
>> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
>> ---
>>  drivers/vfio/vfio_iommu_type1.c | 32 ++++++++++++++++++++++++++++++++
>>  1 file changed, 32 insertions(+)
> 
> But you should subtract it from the old one as well?

Yes, as implemented.  I'll add that to the commit message.

- Steve
