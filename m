Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E09B479755C
	for <lists+kvm@lfdr.de>; Thu,  7 Sep 2023 17:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233953AbjIGPqr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Sep 2023 11:46:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245158AbjIGP3W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Sep 2023 11:29:22 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1875A1716;
        Thu,  7 Sep 2023 08:28:53 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 387AevlW031212;
        Thu, 7 Sep 2023 10:51:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=79SRXWXIsoIaRkfwpjMj2N6r28wODb6LYGFAgEGGF6E=;
 b=El0NEyVoTglT7CePVRwC66XidHwXbT9vtzjdEaDP91ER2RWztG9IPS82qS87gEnzflvW
 Z9JHI8YXB7BTyDjj6E1wFOOp1xf4Kd4MWtQVAoM9lENSUfBP2BCtiEe+vqewTurcIAGq
 NzJD7xbYuhJ3hAoXtPPRSIzfSXT9g67yNRt83SpnVaPGuxednCCHgbnM6tH7ESr4SBaf
 p2rqRZnaX1zSoQ95RQvFHR7xKK7c0k3e40a5ITT/b5bY1P++ThS4QfFVjRNjvxzAuRMd
 vaIomfmKf8VR1a8x/nYQBxAD/vQno3utLrEJFPxI7FOSH1uCY9PYG6B//8Kaq1x/Lv5J yw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sycyar0ku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Sep 2023 10:51:46 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3879kYrn010414;
        Thu, 7 Sep 2023 10:51:45 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3suugdsyva-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Sep 2023 10:51:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MHoveVXjSDMhl/r/ja1JsKgIEq5SgH7i94xL0CmGAGuIX/6l/fPpEEIEcr5H9ZEtpTpjZqiqrfGaZV+8ydYfDjw9vikGtIrtYUWeX8vP3Q2AtHkaQZTBR86xFmSanH3KDam5SWprHVkR7W8Iqv0QnOlIGpSLx3e4Gzircc+pH0REtrTxmTOneSMf7Yk1lrFOhehj9A3qlspAsANyh2r0XA7SoMDz7ZW6W1svlbn9dG8n3X8rjQKxDu6cIFnMH7jb4cnOLQv/+RjkIUg2aA24gRhoNrIA512JzcTRo7EGAw46VQorwSi2mej0jUoNMXCU5/JS/Z8iUPinbDvI6OS4iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=79SRXWXIsoIaRkfwpjMj2N6r28wODb6LYGFAgEGGF6E=;
 b=JyoLG0Kf1/Y793MYIuJPJuU1NoSPE8tLhU8uoJ2aZEdyOJ5vkp2gZLfYNHp9EfAfYAUp8AFgwb2FbSAUSsZyBGGEAJSPTdxnyEo8lGaDl0itHGkYM+xEiZP5kFFmVktKutHghjnV1UrnbNkt3QqIiYUThz7PoK6kRAjN4pFNWN0e+P8I7QOjt3Ft1ocsQeUGVRPfVMvLDDLB2tj12HB+DrVS6obqKrGZ/KhRGUkawVG8u8K46+9cJjQLNYlOvTCI09l86i3SHYeLf2L1OkO2mEk5H44FfhH/XaNHReQywtatgn9spxPxb/WHoJtetlzV3o2LHqQTy0qPgkN9JtT4VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=79SRXWXIsoIaRkfwpjMj2N6r28wODb6LYGFAgEGGF6E=;
 b=DUi4HAtEVFottjgnwBDk877G3B13M0nI77kyiwN/gSPH5isc5s2LsnzUlEv/hV4D/jdyuQnKhJAS/f/i2GiTqQMvurzU745DmsB6s6cfi2rk6vMoCYEjMomEKjg3qZMUmqdAea8eZNS7+UUEDEmUSbTO2vYZvX70cfO/OlBHuzs=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by IA0PR10MB7383.namprd10.prod.outlook.com (2603:10b6:208:43e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.30; Thu, 7 Sep
 2023 10:51:43 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::2867:4d71:252b:7a67]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::2867:4d71:252b:7a67%7]) with mapi id 15.20.6768.029; Thu, 7 Sep 2023
 10:51:43 +0000
Message-ID: <a8eceae4-84a5-06c4-29c3-5769d6f122ce@oracle.com>
Date:   Thu, 7 Sep 2023 11:51:36 +0100
Subject: Re: [PATCH V7 vfio 07/10] vfio/mlx5: Create and destroy page tracker
 object
Content-Language: en-US
To:     =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        saeedm@nvidia.com, kvm@vger.kernel.org, netdev@vger.kernel.org,
        kuba@kernel.org, kevin.tian@intel.com, leonro@nvidia.com,
        maorg@nvidia.com, cohuck@redhat.com,
        'Avihai Horon' <avihaih@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
References: <20220908183448.195262-1-yishaih@nvidia.com>
 <20220908183448.195262-8-yishaih@nvidia.com>
 <9a4ddb8c-a48a-67b0-b8ad-428ee936454e@kaod.org> <ZPhnvqmvdeBMzafd@nvidia.com>
 <97d88872-e3c8-74f8-d93c-4368393ad0a5@kaod.org>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <97d88872-e3c8-74f8-d93c-4368393ad0a5@kaod.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR05CA0089.eurprd05.prod.outlook.com
 (2603:10a6:208:136::29) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|IA0PR10MB7383:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ed94764-d3b2-471e-e2bf-08dbaf906c90
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NWrjBuAlXIivHct+ZeOvHgwb7QuHXzqAS9gfTUkP3Rfs8U47DA1wTqazoqguewYH2O4gU4NBFkfhppob/Rrf3i37y9/zobnr/ZDxWZPmDeLBpBeC9HXYzJmlY/JQlDWxMbupS3Bh9EiAAvHAfhKYwnQ8whYXaYcIP4ROrXtcgOvVin9Sw8MZbXI2iprpQTR7T15IoIXR2CQ8m6vXuSmvdGfsJ4Sz5fvx+rbNThjxYjEPnpzXWmW4ghF0fdnB/cN7RYGXaQwTnrOMNGifyGoLVkYddJ14oVuNx6F8Y8JH+IjMxcoK7DkVRDfPzDrcnFLYjxWXrLVJ2CQGtUVM3Rrvy0e2/yCbhu1rB27KJ2n6LbkO+CJ4hpUFx+nmSOxQdj3iEgdMnwsxOTOjUy37mVb+ITr3VQkc4uMhBq+LEiItX09AAhzxOQXrTASEIKmCCloopcmjjfrR1UTdJmhPaUD7wiN7ZpstlcOZ3QnwwjIXyPB+8jNzgpb7N6MUCc5oj4l0so7fHQQZZRt3zR5hjA++gsPYSTHW+zEuL83wAMQ11ObJWPr1lt1Jqt0tOTYoLcMxgFy5vduxpjMUwwSVrmrA7hg/58fMBCNZuNaxx8rbsvq0WFzsTCTzIJURVln0ELsG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(376002)(136003)(396003)(346002)(451199024)(186009)(1800799009)(31686004)(53546011)(6506007)(6486002)(6666004)(86362001)(31696002)(36756003)(38100700002)(2616005)(66574015)(2906002)(26005)(6512007)(83380400001)(478600001)(110136005)(4326008)(8936002)(8676002)(5660300002)(7416002)(316002)(66946007)(66556008)(66476007)(54906003)(41300700001)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NDNHMHU5Wjg4SUw5YkNEcGlEY3VaUFFxVVBwZkpVV09UYnFPSjJEL2NKaHFL?=
 =?utf-8?B?VDdBMzA1aUNQbFNtVXZpdmRMRk1ncXZmblNvUzY1Uml1ZTh6dGZ1SGY1TExB?=
 =?utf-8?B?ZVVwRGxBZ1pEWHZzTGNyMTNXa0d4blBDK0o3Nm96WktqalJmbWxZcXBXUTVo?=
 =?utf-8?B?aWpTVFJ1bVFReVhqdGs5Q1hyNDlDbjBHVTZRK1BxUjI2Q3AzN3JWNGlidGk3?=
 =?utf-8?B?eXI4K0RoKzl5dXh6TjR2eWdyWXZFQ25SS3AyMXhhS2JFaVJhcU44YXNzS0Uv?=
 =?utf-8?B?OGNzSXBIVFppQnhyaUprUGt4L2xZYlVvZDhzL2ZJUG53TU41dWU3QTVQUysx?=
 =?utf-8?B?cUtvelAyMnZ5WG1ZeFBqY0cxcEZZTCtlSjExWlFST1BJdUNINDcvMndRRmxY?=
 =?utf-8?B?RXNtU0p1VkxYang0SGVxRUxjdGlkc2tCME1lZCtkN0xvdVBORmY3YlBWYWFi?=
 =?utf-8?B?L3JYaDB6R2YvTHZiNW9VeHRtWHZIelZyam1TdUpCc3Q2bzZqTkw1ZllDWGNx?=
 =?utf-8?B?bGtUcXNXSmwwbTZ3QVF5aGlZS0hrZXhiQ2pzR0wyK1NrQjUwK0FaZFIzeG1P?=
 =?utf-8?B?RzVhZjVwRmRBVFVoM0ppNUdhMUJKazJBTUlvVTN5TDhtS0tiOXcyT0hUeUhK?=
 =?utf-8?B?UFZ1UlVxbzF3MHlPWUFhSFJKeXBsWUFTOXgxZ0dZbmdIa1h1Q0N1QjlNdk9P?=
 =?utf-8?B?RFVOZzFwaUNkU3QzMFVtcm5RTnE4RDdJMG53dk5UNFZRNU9ERGtqM0VaVjRz?=
 =?utf-8?B?WFNMU3VFV3MvenF5R2ZYQkRFYVY4c3VKZi9UMG4zeG1zTHNVWGRxamZOT0tz?=
 =?utf-8?B?T1Jjb3FkYVlWVWRzUjd3Z0ZkSUdPQjdJb3p5THFOY2U1WW5icEZQd0VVVDVM?=
 =?utf-8?B?WUd3aUZtd2hkd0Z1QnYxRStDN2RlWXhZRTZvSmpGWE5pWk5Xb1dKL2J1MGhY?=
 =?utf-8?B?djJpR1I1WHFYa1pGNWEyNGNPWUxIV1hzcnlqSmN1ZVRQR1JwaVRpWkxVQkhO?=
 =?utf-8?B?REFOOWI4MFRFY2VkVXdtNENPbG5FSUg4S0tJbno3c1Z4K2x0aEcwQ1dmS0Ja?=
 =?utf-8?B?WDJEYjJtNVJrZVhMZjdGVm5CeVZWdzdaMWR3U2VOaXpsUE92aVNsSG9kajly?=
 =?utf-8?B?M2t5STlwdmFTb2NQWlY4dUd0ckJteHlYa3pyYTRBVGlKaDAvUHNlYlpmdytP?=
 =?utf-8?B?NmRlUDNLaWpVdWNGQlZQVTczcmJJK0hpaVhoaXl0Qm1PVWlxL2lseVR4aEhW?=
 =?utf-8?B?UEphWXZaY1crMWlLQmpPQlJVVW1tL2JqT3dFOUVyazQ0RG1tODF2dFhJa21k?=
 =?utf-8?B?R09USE5md0FReDh3d0VoMU0xK1dsVVF0N0ZmZUFOVlhFSmx5YkVETnZkV01Q?=
 =?utf-8?B?NTVOY0JsYnR3UFNLN1B1QjhwdUxVRVlsbHRzNE1ZZGtES3FqRHRERlJPNWha?=
 =?utf-8?B?VTBnbU1EVCtPajc3bSt3NUM4YndFWjkxK2xXbnpYcVp0dlZjM2cydFZWYXdP?=
 =?utf-8?B?b1c0aTh6MjMwdFU2S1Y2OG44ODNGTjcvVDd2SzNybm5zMk4yYVVmNE03OGx5?=
 =?utf-8?B?SHBEaHlmRkRTOStKQ3RIeDB3R1cvUzg0ak9ja2g5SW1VWm8wQTVVSzd6U2xU?=
 =?utf-8?B?b1Vidm5OZnVDalhPSFZRdTlpZk84NGlOTVdtYjh3T0tXRUpKMEs4RWZqMTMy?=
 =?utf-8?B?UE9PR2JhK25kUDlHeU16aEdFUk5HMG5yY2R0VFVjOFZGMWFNZUJLMno1OS9N?=
 =?utf-8?B?Z0xkVG15TlQ5ck5WcSs4elQ1aGN2YklwdzAzNVBjd1plRjdXMHhYZTVUOTZq?=
 =?utf-8?B?YmUwN0pCRmJYREY3ckx1SmFMeEdKT0hYT1ZoVkNoU2U0eGdMeG9PUEZ5U09t?=
 =?utf-8?B?b1VMVWR1eEVJVUtreGQ4L1JSek9aWFpjTDltRmJxTjJRdVJwUXdObFNmRTN3?=
 =?utf-8?B?ZmlHSXRudU5qUGRNV3hHcXZMNC9NbjlVQldlaUpjQnl0emtncVVxMkRyeE16?=
 =?utf-8?B?aXU1K0xVcHNwQWMzTjlGc2VvZjVwODQxOU1WbVh1cFZBTnc1T2QrV3B4TG5Q?=
 =?utf-8?B?VklIZCtZazNra2xDenJ4cEd1Ty96Q2pqUmxsVy9Gc3VMYjcvZ0xtd0lxYVZK?=
 =?utf-8?B?MzVJdTZSaEI1TCttZ2xzNkg2V0ZwSWZ5dzc1c0NJd1RUT3ZudHF2NnBnS1h3?=
 =?utf-8?B?emc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: aas4LhzOLcAvxa337AAk9gCODkQJlUpA78Kq9J+sNTbJDVILZ1gG48s//+nerBSDusvlo8veVKX69QH6/9vmf9NMrNVUCUAK05QtiF//0YGdVtNGwx3br2F/uepNwUr2vRspM9BRetdGlVLLURVMMTtze8a0dj/6VJULi6RjmrTCi3594daTiFj5tJmH2rocwcmQXSiBHivLINaY75OxsEM+h3eYe0AHzmmc6z4rAhcekZ4kewgnamqwWZnwGS+PRwY4IYpxEHm9ubFa5GAIMd8y2os+DPxe2Iar0geM9MuaGFLukr+NJpVeVuSRRkWLTH2hiEbBR802CBMI5jHzceOIsd0GSJgWunR2HOq63U2Iln3C4LCPZzXwdhfLFR7gr81K28Ps4AYgyr2lHVfx3/wf3EaeHoItngm1yRcCRvd5KHr91f4aOl46u/oo9Ju9oonTixu8ifFgwtd8MFfsW6v/2J6Y/JeZnT3GEkjZoGSoXrLRuj2CI2mS4hf7Gc5kJjdVbbH80X3cQz8wXC0+ke6xUtwH1OAU3vDhP9vIwft8dt0GouYUbxk+AWtlZ/p1HL3BAUHgpOVpvvQGynignFEgFsLGcpplpzTnu3Xs3orL2NwwsVAxbsNzsfzAJdk2LeiuCp4N9ORCXGS9rrOLKuWmnw39AxRitAq6TFi0v53CHYMOE1AGLUIAXAXACKyZ7epuZwmICPqPgzxxldOZDPA4hyOEGWTuJrEf8tMhDGW/+3SkE56TWgdNpNGvgQELkLlplNvJJdqadffByPs5zk+VgZntedx0cyHLxM6IlR5lj27gAj3Oa+6mRzHFEfTLNoqcRVxnshJxm9Fz7BC83CfPBCCb6P4XlkiCOstNIzb1z11etF3IHhp514QK2WHWTJsHV4orr1/CNHOWrwQE7g==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ed94764-d3b2-471e-e2bf-08dbaf906c90
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2023 10:51:43.6534
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FQUo7rjI/eooEcsiXgz6144zaOOyh2jGI2IDpotywwS7u5/1Mq6cszqCFLQptzoNbAHKfJPvUVl7qz6W+ysMaosIMz4pVDmagcWVVmnQVEg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7383
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-07_03,2023-09-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309070096
X-Proofpoint-ORIG-GUID: jxxBMCDSCQKFir20ieqGb9pi8DvwEfUT
X-Proofpoint-GUID: jxxBMCDSCQKFir20ieqGb9pi8DvwEfUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/09/2023 10:56, Cédric Le Goater wrote:
> On 9/6/23 13:51, Jason Gunthorpe wrote:
>> On Wed, Sep 06, 2023 at 10:55:26AM +0200, Cédric Le Goater wrote:
>>
>>>> +    WARN_ON(node);
>>>> +    log_addr_space_size = ilog2(total_ranges_len);
>>>> +    if (log_addr_space_size <
>>>> +        (MLX5_CAP_ADV_VIRTUALIZATION(mdev, pg_track_log_min_addr_space)) ||
>>>> +        log_addr_space_size >
>>>> +        (MLX5_CAP_ADV_VIRTUALIZATION(mdev, pg_track_log_max_addr_space))) {
>>>> +        err = -EOPNOTSUPP;
>>>> +        goto out;
>>>> +    }
>>>
>>>
>>> We are seeing an issue with dirty page tracking when doing migration
>>> of an OVMF VM guest. The vfio-pci variant driver for the MLX5 VF
>>> device complains when dirty page tracking is initialized from QEMU :
>>>
>>>    qemu-kvm: 0000:b1:00.2: Failed to start DMA logging, err -95 (Operation
>>> not supported)
>>>
>>> The 64-bit computed range is  :
>>>
>>>    vfio_device_dirty_tracking_start nr_ranges 2 32:[0x0 - 0x807fffff],
>>> 64:[0x100000000 - 0x3838000fffff]
>>>
>>> which seems to be too large for the HW. AFAICT, the MLX5 HW has a 42
>>> bits address space limitation for dirty tracking (min is 12). Is it a
>>> FW tunable or a strict limitation ?
>>
>> It would be good to explain where this is coming from, all devices
>> need to make some decision on what address space ranges to track and I
>> would say 2^42 is already pretty generous limit..
> 
> 
> QEMU computes the DMA logging ranges for two predefined ranges: 32-bit
> and 64-bit. In the OVMF case, QEMU includes in the 64-bit range, RAM
> (at the lower part) and device RAM regions (at the top of the address
> space). The size of that range can be bigger than the 2^42 limit of
> the MLX5 HW for dirty tracking. QEMU is not making much effort to be
> smart. There is room for improvement.
>

Interesting, we haven't reproduced this in our testing with OVMF multi-TB
configs with these VFs. Could you share the OVMF base version you were using? or
maybe we didn't triggered it considering the total device RAM regions would be
small enough to fit the 32G PCI hole64 that is advertised that avoids a
hypothetical relocation.

We could use do more than 2 ranges (or going back to sharing all ranges), or add
a set of ranges that represents the device RAM without computing a min/max there
(not sure we can figure that out from within the memory listener does all this
logic); it would perhaps a bit too BIOS specific if we start looking at specific
parts of the address space (e.g. phys-bits-1) to compute these ranges.

	Joao
