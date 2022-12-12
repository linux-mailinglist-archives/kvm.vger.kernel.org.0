Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AACF64A90F
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 22:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233518AbiLLU76 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 15:59:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233443AbiLLU7r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 15:59:47 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 957B018E2C
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 12:59:20 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BCGwdCX004053;
        Mon, 12 Dec 2022 20:59:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=qLE4mbUXJFqUudgxNjEmX9YDBhPpWxfoPsLVtWotNvM=;
 b=hUtRXCXAHYrLyC06FKhTrwOeWdDYWCdMipKyhQWFbYbFJ2o/fCt588SK5ZyLyaub4CDF
 AfEtcB9Ri/wF1Cu0YbkHlUUH5dzeYVoeLwxhgBieOkXm8IcRTl6Jwxjq7XX8K4g4gy17
 VEuGnWf4QUnaU/sX9K/JqvtAP8sEkA2hWfS6kJBN0IVLvGT2Zelt4ZhBBYhpN3xHUWoR
 Z8DQPLzucABeJNejYWyIlS7WvlTeN9n5i/jl7T5+Pzhg2ke/9xmloZJ69n1RkaiRmQal
 bdGXX0eEofC3xUYGoHNl9ZuOQDbYQfHksZ3oFX5mmNPsh81m1TZvKK0UTwnZKV2WiV7Q vg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mcgw2bw47-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Dec 2022 20:59:17 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BCKR1Vn018714;
        Mon, 12 Dec 2022 20:59:17 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mcgjb50kc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Dec 2022 20:59:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eCMatLfAsLB3vl0J7ft7wt9u67N4nKzQf4hKTus/1JApQZsFU2LHsG5BdR2Dx8m3kcd4Lemkpeuf7aEKl3//A9Kckr80YCRwrL93sFTcjLMfLhvgtBE7bqOdkt2LOtebzRbOSiuKEIruDTR0XO/a6FMHs82F9WvhShMvV165cVF54WE1TXSmP1IIoD+qWbJj4UjwFMsk8h1b4hhIa2hUNiqhHUq/ie6srLJh8eVftc2yqkb/Z8Amr1oIOZaghgIQ2lQ9j686EJ+b70Nf90EPSkp3Tk9Ts9x7t0RxMDxg+selSuY3+KOa28kXfdlqBD3gT4Mx6XvonAnWtmtRIzX8Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qLE4mbUXJFqUudgxNjEmX9YDBhPpWxfoPsLVtWotNvM=;
 b=MEIpMVeffI5yUQQuEenALnreYbT159e0Vj2OwVmp1cg0AnEDJlbSh825YWGbF6nZwMvgLnfyUz2nxvKdCUqHaGCZPswoe8vjYVdbdfQ0NmR0KoFCs2IRwuDteU9v67cCxyZC4FdqrxaTqObkK5EzMKQQrYWbsEJzGMtgUMCcQfY3LhAQpM2r8d8Vx+I5kylotkDZLUVbnh011xaita1k9a+t1GVXZlAaBsdKV12url+RohJQnxW1WayHl7aKooW0XOUpNmXsx9QP5QDHlyo1i26zhaRttX8fKHWxhTkW1kMPnu/b9V4OffnJjMjht03mLY/Xx/cSGNeenqN/gMAY4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qLE4mbUXJFqUudgxNjEmX9YDBhPpWxfoPsLVtWotNvM=;
 b=frdWFK4/sx0WpfQGEzXFPqEK9lAiFQHmVyJ/TxAlgfWplPpiAZGkrjSi8MBlj6RRsR72yWXRn+07MeUt9jf/xrivuIeET3mx925vflKGiXG/iGpJ2u+H8AbfVyzD1SgSk3T22rXFN+LqCBMpWOCfkjwQI15bQHpD9tJd7zrrUt0=
Received: from SA2PR10MB4684.namprd10.prod.outlook.com (2603:10b6:806:119::14)
 by BL3PR10MB6017.namprd10.prod.outlook.com (2603:10b6:208:3b0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Mon, 12 Dec
 2022 20:59:15 +0000
Received: from SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::4056:9f2c:6171:c37e]) by SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::4056:9f2c:6171:c37e%4]) with mapi id 15.20.5880.019; Mon, 12 Dec 2022
 20:59:15 +0000
Message-ID: <8f29aad0-7378-ef7a-9ac5-f98b3054d5eb@oracle.com>
Date:   Mon, 12 Dec 2022 15:59:11 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH] vfio/type1: Cleanup remaining vaddr removal/update
 fragments
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <167044909523.3885870.619291306425395938.stgit@omen>
 <BN9PR11MB5276222DAE8343BBEC9A79E98C1D9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20221208094008.1b79dd59.alex.williamson@redhat.com>
 <b265b4ae-b178-0682-66b8-ef74a1489a8e@oracle.com>
 <20221209124212.672b7a9c.alex.williamson@redhat.com>
 <5f494e1f-536d-7225-e2c7-5ec9c993f13a@oracle.com>
 <20221209140120.667cb658.alex.williamson@redhat.com>
 <6914b4eb-cd82-0c3e-6637-c7922092ef11@oracle.com> <Y5cqAk1/6ayzmTjg@ziepe.ca>
 <20221212085823.5d760656.alex.williamson@redhat.com>
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20221212085823.5d760656.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR07CA0111.namprd07.prod.outlook.com
 (2603:10b6:4:ae::40) To SA2PR10MB4684.namprd10.prod.outlook.com
 (2603:10b6:806:119::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR10MB4684:EE_|BL3PR10MB6017:EE_
X-MS-Office365-Filtering-Correlation-Id: 25df7f48-edf4-4ff3-19bc-08dadc83ba6d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oMO62hSL+FAtHG+OibFGXGCle5ASHSTdXIGfR3ae67O/QPCMZ4qKfGr3uUCheIKndscQIwdNqfVfDUd+BtVaV3wLUw2zuyNpZfh4WLnt5vqq7qNQF4WLztbvqDs2qXCcFiH25QIFoKZV8NKIqgY4m0cYH9wqTfKWk98ix3lRJ+uzCMTyx78AeLGEbtisXiyp3q7jCtgD03/mvwPQ+11aXajwC75B2gsFqTs66whtLbiwHWTIFdIfDNvki4tdLzOByjpb3OjvIGn0U7zqwjeeRMIIfeM+7AM/lAro8cYKJgwcI7REYGz+7D/hAVLpldj1tpNAXonEKhbTlipAiXXog55IHQ9Qzlw24vvYYglai92aXnAw/x+3INiF64ZoGyDfdRxQJS594lTApzH/0VPeBa21UKZ3BIXCcFke9bCV6ajunNyfaIDd4sTncIb/60JAV+rqynimaJtiDVRCKLPyvHq+WxaZ1F6xDeDrNX0PfgK1lCLuj6uDN6N3NNn4Wi5xSZKOOwkm4i91aOeSC+wov0rfbMc3uNwc5vcu0Lc25u3xp4A3EbX/wQ96uosrsup5gU7Ta9Bq5iseF/Ty9+h4JJTCe2Tjnf1S5uCt0n5zMgHH1Hk7KR+QON8JaP8jap6iXAPY/20d95+GJ2yKM+akCPSUXm6B3glOneziQscQLIViFWjRmlhwzC4+qzOBQTSwicKxNTviW8v7zULceAIUWa+IHcirIELjVlC/YUgUrgI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4684.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(136003)(346002)(39860400002)(376002)(451199015)(31686004)(83380400001)(31696002)(6486002)(478600001)(2906002)(36916002)(86362001)(36756003)(186003)(2616005)(5660300002)(8676002)(44832011)(66556008)(6512007)(6506007)(38100700002)(41300700001)(53546011)(26005)(316002)(8936002)(4326008)(66476007)(6666004)(54906003)(110136005)(15650500001)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VXQwMEh2V0xFVDZkcjRKWDkyTEw0WnREK1U3aVFEUjhZTDhCbk9ncjBIdXJF?=
 =?utf-8?B?cUhHRFlvcTlNVERLNDUxMUFiUUxidnVyT2hQcjRQMkQ4NlpSMzVvVHZ4OGpO?=
 =?utf-8?B?MDFLUTdPc1dHZFhDamo2VGphUEd3WWtqd0lQOUpLMGVhall1VnNjUHRoek1s?=
 =?utf-8?B?OU1yNUZseFpiNUQ2T1dKMEVZdVhINWZEOGJPWVBRUjdoNEd6eDZneEFuZmZ3?=
 =?utf-8?B?b3B2Yzhzay9WWk42NHo1Z3pDbVB2cTBtemw1MTNWYyt5bnB6WjRzblU3M1pR?=
 =?utf-8?B?eVRNSmlqOEsrdXV0Q1poSk00dnNuN0tTb2NGZUd1Y1dLTTVYbTdzb3haRGhT?=
 =?utf-8?B?NXBoOUFBVGJkK29DWXFwbng3S21zQk1tTThwOFJJWENQYnFYV25kTVNHTng2?=
 =?utf-8?B?NDRLUkxQWkxnN256TkRtYTgxRVBSNmhvR1c1UkFuQVdMeDlDaWE0TXB4VlRZ?=
 =?utf-8?B?Ums5UDR5dmVxMXBZYUUybVFEMmNLR0EvUERYTXduY0FlTkJLbnVzVUVpM3lt?=
 =?utf-8?B?N2cyUUtMWlg5eTFiY05DdkttbTFNdGt0aHpOWkpYamRzbFNyWG5tS0t2ZlBj?=
 =?utf-8?B?aVdkWWNrenlYSmRNMDA5YXNhUEFCSFJMcGF2dGZweEovTFcwYnhSMGpjMTlB?=
 =?utf-8?B?YjUzQVVEWHYvQ0Z6ZFNSNDRrUkZmNklpV09wQndmRVdObHo1d05rVGNTZnNG?=
 =?utf-8?B?eVREeFkwYm02QTJZc3VyV28reTBYTHBCZGxJYTd2QUl3OHVZbGhldDR6dHkw?=
 =?utf-8?B?WUl0ZS9wenNkRTFtWFQ1R1NWanRRdlFrbXNLQlNxenV2c2hDbHR4V0FZbWRp?=
 =?utf-8?B?ekk2azhFYVdYd0JsNk5wdnBYY3B6UFZPdUh0NHM1T1RuTVpjZk1CNEFKcWdk?=
 =?utf-8?B?OTF1YWVqdUdhVDgxaFZyU09jUnJLUmhQZ1E0WktVSVkrWklnUm1zd1NBSTZY?=
 =?utf-8?B?eE9JUkRSSG9sY1pBbUJZamF3aStxbnZaOVpHVUEwQVlHK3ZuNFloSUkvUVFT?=
 =?utf-8?B?SXRWbXc5MmF2bjA3eXdMejlZekdwL2JDMGlFeFljdUM1NU5rZjZQdDNIT0Qr?=
 =?utf-8?B?dFRNSk9nTGNQMWJyc3Z0cGcvUlBxTDdHV0dtZHBZdkQrVXZUTWFPMWxYVnhs?=
 =?utf-8?B?bHRMdHNRVExrcmRRMG5USUNNdXdHWXpVOTNPTlBoY2liZGJZbHZBakozZjlU?=
 =?utf-8?B?Z09CUVBYNkxZVkY4RGJTenlPc2VQbVFzSnpXQU9RcFF4dDRYaUl0OXNDdExY?=
 =?utf-8?B?U3g2elNQVUg3RUVmWDFDREM5dEN2TGxVb2xpNkhrREM4MTZ4aFMzU3plTXFp?=
 =?utf-8?B?SkxVczNGNHJkL2RZditxanhlcHFjKzZEMFlPaTJSUUYvb2EyelhvS0hId0RQ?=
 =?utf-8?B?K00yVFZnc2NlVjc2QnJERkVKdW9KRno5VGdDaTIxVGY1YXUrallSSkxTRm5D?=
 =?utf-8?B?TGxDZDNQanpiWkFXSjJZOHJnUHA4ODhXbkgvWlNUb3MrbGFSYjJEK0FlS1Jt?=
 =?utf-8?B?N0xTNXMyUHc3YnNZVFFxbitBdkMyanE0RE5Ic3phYTVzRXE0NzZXa3libGQ4?=
 =?utf-8?B?ZFpPR1dBYmRYVHVvSU5OaDh4WlJneXBzNENYRlZHNnZZa2dQOE82R0ROS2pT?=
 =?utf-8?B?OVFqc21JUjBuYmZiYUxzVXl0bXc4V0NYUGFxM1UyWnVyd2lSL3R3RURhV0Ux?=
 =?utf-8?B?ODkxMXFkaklodGR4Q3g3U29nTzBheGFBS2VYQjVVNjJSZ0RJTUJWLzhIdkJz?=
 =?utf-8?B?TUcrM0k5Qzdwc1J4S3Yyc0pTUmZEV0ZoRDFOY1poQll3ZmU2RTR1YnVXYmlU?=
 =?utf-8?B?VXdlVklZK1pTZUlNZFp0c1F2dzdXVGJlWHk1eWhSMHpDT0JyN0wyck1xSHhZ?=
 =?utf-8?B?c29GNWc3TitqTkFCdDhaczRFWjlPZ0ZpOHNJY0JSU1YwemZ6RURXeEFDKzlo?=
 =?utf-8?B?ckUrTlhKcjh3VTBaUXAzaC9GUnVxY3VGdldwbkd2Mm9GYTA3TUFTYWZlbVVm?=
 =?utf-8?B?a1ZwTTNFVFBEWkFqRzVheTBGZXdBekUxZWhvdTNrSWFraEVVcGhiWVhiamhr?=
 =?utf-8?B?bUxTNHIweWYwSkJsbDRMdGIvQk9UYTY3UUN5Y2VveGJlTkYrajZ6Wk5lK29S?=
 =?utf-8?B?YmUwMkxMc1pLS2x2QWhyanowYWxVM1pxVzd6dVdvVTU0eTRCQUhmdjVac2tR?=
 =?utf-8?B?WEE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25df7f48-edf4-4ff3-19bc-08dadc83ba6d
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4684.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2022 20:59:15.4603
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0HfDItNL5s0jSZuQuSS1jgmZDIMQWCriv+7H8PSqicR7/RRkmOq25OQozZWOkXqArQGXZaZZu4yOduhvmJqQ7E+N6PMW2tNgZz/7wG+yeA4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6017
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-12_02,2022-12-12_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 mlxlogscore=996 malwarescore=0 spamscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2212120182
X-Proofpoint-ORIG-GUID: cmlwePXNSDMX-UTZIiy0KW0PWPlNRPFx
X-Proofpoint-GUID: cmlwePXNSDMX-UTZIiy0KW0PWPlNRPFx
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/12/2022 10:58 AM, Alex Williamson wrote:
> On Mon, 12 Dec 2022 09:17:54 -0400
> Jason Gunthorpe <jgg@ziepe.ca> wrote:
> 
>> On Sat, Dec 10, 2022 at 09:14:06AM -0500, Steven Sistare wrote:
>>
>>> Thank you for your thoughtful response.  Rather than debate the degree of
>>> of vulnerability, I propose an alternate solution.  The technical crux of
>>> the matter is support for mediated devices.    
>>
>> I'm not sure I'm convinced about that. It is easy to make problematic
>> situations with mdevs, but that doesn't mean other cases don't exist
>> too eg what happens if userspace suspends and then immediately does
>> something to trigger a domain attachment? Doesn't it still deadlock
>> the kernel?
> 
> The opportunity for that to deadlock isn't obvious to me, a replay
> would be stalled waiting for invalid vaddrs, but this is essentially
> the user deadlocking themselves.  There's also code there to handle the
> process getting killed while waiting, making it interruptible.  Thanks,

I will submit new patches tomorrow to exclude mdevs.  Almost done.

- Steve

