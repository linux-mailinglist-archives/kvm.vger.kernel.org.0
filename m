Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAF4664BEFB
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 22:58:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237682AbiLMV6n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 16:58:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237629AbiLMV6Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 16:58:16 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7D7426AA8
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 13:57:00 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDLNq1C019993;
        Tue, 13 Dec 2022 21:56:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=kjN/b8MHZl5mkyPcenEefIXKbaoCChRq2ES+Qx+f2n8=;
 b=awMSo7AuKzRoZXHRm+rAR4UMxwqumHWzbABni30ptTPyDR0SziKrvhgC7txJAYpDADnl
 Kc3w1OKL3Y77GXUDBP3hUGLqaBNxhbnVBV+aKoWhV0gWQsbQQ78eSoOOcNQ1/gZ+e58g
 lx0ky5TB9NNWbtNgpAirvZPul1eRCz7za+lhX7h/HKGUZuJ7VUSmR4nKMlV/8qkQT1yt
 JepRuhAfCvq2TlBozts0wR78Nsb63EZgOzo8bY5Y53RicziKwF1mS7DmDk67C/VZb/oO
 h4cI2iEP9axbHHeXu4ZQzurw/oowoXRoNOCGu6jeGsa3+NjRVObUXQp4iex/XvpfHfb2 PQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyeu8d36-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 21:56:58 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BDLMFdw012243;
        Tue, 13 Dec 2022 21:56:57 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3meyeuykas-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 21:56:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ICr0uOfH75FQ6JStrA8nZw0gt/qEXGoBP9FAfQK30vka/8AYf4B6JL41Pf+LnZT2GoCyuRTzSDmtjB7G73WQWCEI9HDeN2xoNbbbJP8c7oEIXhqR+O1r6cQegO256rX7IelQoT2Z2hiAsJY9J+TPAY/zZdrhpsjYIJVfiloDkwhp+jFY4llrD3wG7Bu4sIpOvLqn4Nfs0rVSlhstwQCwyhUdwlT8+GBU6ktH7U9rHvfexpDWNH380lFdTajPhDprLNbPd9TnpnNLMhjfWb33YYrBHA5zKNiahcpX3bEIUtVw8PU8l46FUY8mmYDY3TYPUPI7EJZrNau8CAZE9CMYnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kjN/b8MHZl5mkyPcenEefIXKbaoCChRq2ES+Qx+f2n8=;
 b=alMxIJWVWBc1ba4EpUk0gMBbIe0ueDH4XK/JxSsoBTC5MCr8JosAxyVRubK2rKAo3HzQX+L508pgRJ13ptvcqGcYWUoDjzgm00kc2lnz2E+W5KMI+SLxJ9j6Wa+g1jvelWzwUh67nnMTC3WfeSTaLA7YegjxA8yCAjycErEVTOvfdGJHgeyhhf3IgXypUTiwUUSXxx+q05UB0SSShm8zQRPwY4QYd9VPJ62+oeWk//NKY7X53PWRUFeUH/yAA6Y02OnS1DDayc0dro7NTqV2t3FfrW8FrRmiaj/FIAWcGrcUfdPT0mWphXcBcnRmsncrjeAfFWWZ8GMfYK6HKdo3vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kjN/b8MHZl5mkyPcenEefIXKbaoCChRq2ES+Qx+f2n8=;
 b=l4dEfG89PS5XEs5eKKFOK2aPMIiT+qeXiuF+wbKQntRr32NyopJS7SbX4DA8jAEcHJHjxpvgr0CuI/NmdR1o2Dn8oNRpU4azzS24SSjb/jxUnHLsbnKH9VHQoghUM9jK4lMSyyWUo8hCQCRpN/YJzen2gBDKWeWDYmUyrsAQmUI=
Received: from SA2PR10MB4684.namprd10.prod.outlook.com (2603:10b6:806:119::14)
 by SN7PR10MB6305.namprd10.prod.outlook.com (2603:10b6:806:273::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Tue, 13 Dec
 2022 21:56:55 +0000
Received: from SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::4056:9f2c:6171:c37e]) by SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::4056:9f2c:6171:c37e%4]) with mapi id 15.20.5880.019; Tue, 13 Dec 2022
 21:56:55 +0000
Message-ID: <efea2082-708d-4cde-45e3-93e042b3596c@oracle.com>
Date:   Tue, 13 Dec 2022 16:56:52 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH V2 2/5] vfio/type1: prevent locked_vm underflow
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
References: <1670960459-415264-1-git-send-email-steven.sistare@oracle.com>
 <1670960459-415264-3-git-send-email-steven.sistare@oracle.com>
 <20221213132309.3e6903e8.alex.williamson@redhat.com>
 <ae08a80a-bac0-fbd2-2e8d-278c8609efe4@oracle.com>
 <20221213143116.33aab0b8.alex.williamson@redhat.com>
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20221213143116.33aab0b8.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR08CA0029.namprd08.prod.outlook.com
 (2603:10b6:a03:100::42) To SA2PR10MB4684.namprd10.prod.outlook.com
 (2603:10b6:806:119::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR10MB4684:EE_|SN7PR10MB6305:EE_
X-MS-Office365-Filtering-Correlation-Id: 482ede5e-5325-498d-f8a9-08dadd54f34a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Iw4lbq+q4270jgl5M1DELDl8yF8oI0wYCW7aT5SreNND6Kmu+rzi1oPwN5OBG4kNXFVcUpNd3bX8cvVm9mMYBIs7FMYq4Nf2EFvZVV5ifaGCDUBIg1FmXq/ulpyCOGLRIzDJaeCvzZWvtwRA0N4VKadeMd4Gf2ZD4+qLYYQeEhbI90/IbXRaeTFsmoXEJnD3DHtTOYgY2/dxtH6ol9SMeupqtE47Me44+ZySrdS8E/3w/e6/GTWwFJSA3Ih1B3zTdbASoqs33o6z1Ifp0GJPsseD2cvaAROJOUEx1eAZWkIEyn7oD8Wsub4D8QeUVpopT3N+qIvNCyMv9PkSmikurBU4wykqq6NiP+OEr4/aIJNNtr34tXEUC60tFISC/oIr7UdWdd9XTBH4jXmrwHPjLe+ATWUCug4N9vC3rCUZz8yhpVWbNCeA2Ed+s56nfuZZKYYIKoJK+2cKttj+pLMsm/Yzf5ey4Gy4YOUQMbgc7JnvuuCrJSaP3EKZuHQwfTy5S9OmmATkcYje9KUZ8vouzF9b1X7+H4xR1ymt0xiZdFYKF9OD370yq24OD4RV2m04VedFrAFH2xQfC7nfHZkPRqrjznZnDeAiK+60dOWVSeyI0nVp3ujIyK/vPQcz6i4X5Jk+MvFMrskEZfGJ0K+zPoBlTcOQj259lW1TlwJFBGRHm3qMsn4GySxaeV3dxmdNIdQuDXt9hQ2WwnW+597mqYisfkFlO67Rb06WAm2vVj8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4684.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(376002)(136003)(346002)(396003)(451199015)(31686004)(6512007)(26005)(36756003)(186003)(36916002)(66556008)(66476007)(6486002)(41300700001)(478600001)(2616005)(8936002)(66946007)(31696002)(86362001)(4326008)(2906002)(83380400001)(6916009)(316002)(5660300002)(8676002)(53546011)(6506007)(6666004)(44832011)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K3FseGxuV0dnaEkrRUF4ZCt6NTltWnNSM21VWk96VFlHYng5Z0dMZTZhRERG?=
 =?utf-8?B?QjR4UlY1eHlrMVRCVlBQT29GVWFUTXE3ZmFYNWVnbkNXeXVkQk9mbk9HS2U5?=
 =?utf-8?B?K2lXV25NcjY2U2FBT0kyT2pTbWVMMnRseVJsaXVjcHlHWkNLRXQ5RExYYVM1?=
 =?utf-8?B?UWZyNXVXSnFJVWR5d01wbGh6WlNpdG0xbzluK3RVam1HdDhQM1JSUlZNVk9m?=
 =?utf-8?B?b2M5a2xTY1JZSXdUMjk2MHZDd3ZHM2NIZmtwKzlzMzVHTVF0cFFaNEZUQmZa?=
 =?utf-8?B?VGdYRFRQMW11T1hBRGlNcWNhRzl5bzREUFJ0bWc0L2ZXWHVNVnRyaFFVY0Uz?=
 =?utf-8?B?YzlEL1dUendzWUp1bWJFTm13NkN5NlFzUkZWdER5cmhKY25hV0s3NW5jc3hk?=
 =?utf-8?B?YVgzS0pBa1VtaXdyeXB3amRtcXFhYU9qQWV6QUN2MStScmJpNytaUk4wcHlR?=
 =?utf-8?B?Rm1rUDNzVVBxcU4yQXlNOWswRndyb1V6cC9Hejl3S1kvb00rcng4MmsxRDZB?=
 =?utf-8?B?U1BRUzZGeFoySCtWdmNFbHdwanUrWVdKa052cVVZb0k5UW5adFBWN0xTOU1u?=
 =?utf-8?B?WjV4ZUJ0L3JDWUxRYUpoWWNld3I5bmVrYy8zOVljVERPSnllNndyNzF4YVY3?=
 =?utf-8?B?NVhBeXRNNFBoV0J6a05HSVlNR1FuejkxTTFtUzVMYnY5VG45Y0lvazBjME1U?=
 =?utf-8?B?dGRWV0VNaDk5akJSMHZuQ2RYWEpXRHZkeG1kQnYvUDE2dVNxTW1ib200b2ly?=
 =?utf-8?B?U05XT1VNYVRUK0lvRi9VWnNBWTlhSnN6cDg2azdEcm43enFXQ1ZMK2lpVE9a?=
 =?utf-8?B?VmZmS2FwVzdxY1V2Y0wydWRKVllYcG0rSlorMU9NYmpGNnl5d1V2VkJzV3Va?=
 =?utf-8?B?amtXdU1QeUl5YW5jNzJDOHNVZXBFUThHTk83RktKUExNb0syQWpDVzVBZE5m?=
 =?utf-8?B?L01sY1BEcGovd1N0dzNMT25Sd3ZjNHJBRUlhaFBCWlBwcU9yWHZDcnN4T2Jx?=
 =?utf-8?B?dU1iYlJiN1M4WU5HbjJXTWlXU3lBR1NnWVNVNFczdGZVWG40OHE5VG5Od2dz?=
 =?utf-8?B?NW5rM2Y3YUY2UUJDRXVac0crdWRGN0VWMmVZbFRqMUJDMTJhYzdxUUNQUzc4?=
 =?utf-8?B?dUh4cEUyZHBUYnJVZjlUcGdaU0pnWndxdWE0MU1MYStQNnRrbmZRTG5qblpj?=
 =?utf-8?B?QXBlNHJDUCtGMk5POFlBODBkRjNoR2RPVzdvVGtiRWlQMEZXWDlydFM4V2VQ?=
 =?utf-8?B?U0dWL21hcjkxVk9vSE45RHhsdjNGWmVQSHBFTXVZRTlQa2V3KytGdDFLYWVw?=
 =?utf-8?B?ZDd1Z1lWY2Z2UGVnRVVHZWh0RTRYZWZMTFJTaEZrUVE3UllEUktwQ216WVdm?=
 =?utf-8?B?dUFpWC9vYzFiWnBwMjVjSDF5VS9WTURwMWtNWkE3WUxxbTFDc1VNbFhRVzFL?=
 =?utf-8?B?Ymh2WXlmbTYrU0Q5TVAybTY3d3ZuMzJGYWNVMm95c3VqT2JKUUUyU2M2ck9I?=
 =?utf-8?B?UEI2SjZkdHFpL1g3TFdkK1E5aU1IdmFScUI1TWZBQndLOWp5eGhGTnB4M2dJ?=
 =?utf-8?B?V29KZXJISE41dUVNM2g1T1FNZFYzSzNMdE9La0x2bloraFJ2cUJkNEQxQnZB?=
 =?utf-8?B?TlBzWjQ2WkRZWGxva0VWVDZNU2hvT25HMEMzYXpnemtjOTlEN2E2MEVRbVQx?=
 =?utf-8?B?VFE2dkNpZ05qdm54MEN4RVVVcFVwcWNJdTIyRUZhcnhGMVdKR3ptUjFxcDcw?=
 =?utf-8?B?Wm11QVJNQWtCRlhvVHlKazVRVzg5dEN1WXhFWkdPUlM0QUhnczVMazI2Q01Y?=
 =?utf-8?B?Y2JmcmI3MzdBSDhEd3dBZmJqeVNEbGFEVGZWa0hwcms1UXlDVDZZVDUvc0Q2?=
 =?utf-8?B?cktKQ1BNUWw3bFdIK255VEl6ajhiNGNCVUNzb3JZbjl6b2h4ZExXTkFwNnY1?=
 =?utf-8?B?eEIxTWFoMU9BZ1RDUmhNTWhrSi82WjJ5bnZrZ0tEVmlndndwUjhiNm92T1Q1?=
 =?utf-8?B?VXRzb1dtOGczMXBOUHp5R1U0cDNyTVMzRHpvdHVra1krQ3pCUE11YVhhSmpJ?=
 =?utf-8?B?MEMrc1ZkMkhnbitVMFV3bmtaNW1URDlpM25KcSs2N0gybUx0aXJodXRLUzdH?=
 =?utf-8?B?OERqU0xNUkI5aHJFYWduUnVteWVHVXJPYWdwZTJ6Y01BYVBINEd5TzBmZUFP?=
 =?utf-8?B?R0E9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 482ede5e-5325-498d-f8a9-08dadd54f34a
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4684.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2022 21:56:55.6520
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GGP19BTTA50wT2Ffnv6baByCNFaPq8uGM9Y4KQf5Q6mjrj2YNUHi29aAVtN2amni8sZHRtm8aTfXE/c3oDgGb3PbygUitcxqm6eyfyUoHwo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6305
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-13_03,2022-12-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 bulkscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212130190
X-Proofpoint-ORIG-GUID: awgY4xYEDrgkxDUWkAdEnseJlQRO0zeO
X-Proofpoint-GUID: awgY4xYEDrgkxDUWkAdEnseJlQRO0zeO
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/13/2022 4:31 PM, Alex Williamson wrote:
> On Tue, 13 Dec 2022 16:01:21 -0500
> Steven Sistare <steven.sistare@oracle.com> wrote:
>> On 12/13/2022 3:23 PM, Alex Williamson wrote:
>>> On Tue, 13 Dec 2022 11:40:56 -0800
>>> Steve Sistare <steven.sistare@oracle.com> wrote:
>>>   
>>>> When a vfio container is preserved across exec using the VFIO_UPDATE_VADDR
>>>> interfaces, locked_vm of the new mm becomes 0.  If the user later unmaps a
>>>> dma mapping, locked_vm underflows to a large unsigned value, and a
>>>> subsequent dma map request fails with ENOMEM in __account_locked_vm.
>>>>
>>>> To avoid underflow, do not decrement locked_vm during unmap if the
>>>> dma's mm has changed.  To restore the correct locked_vm count, when
>>>> VFIO_DMA_MAP_FLAG_VADDR is used and the dma's mm has changed, add
>>>> the mapping's pinned page count to the new mm->locked_vm, subject
>>>> to the rlimit.  Now that mediated devices are excluded when using
>>>> VFIO_UPDATE_VADDR, the amount of pinned memory equals the size of
>>>> the mapping.  
>>>
>>> Fixes: c3cbab24db38 ("vfio/type1: implement interfaces to update vaddr")
>>>
>>>   
>>>> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
>>>> ---
>>>>  drivers/vfio/vfio_iommu_type1.c | 23 +++++++++++++++++++----
>>>>  1 file changed, 19 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>>>> index 80bdb4d..35a1a52 100644
>>>> --- a/drivers/vfio/vfio_iommu_type1.c
>>>> +++ b/drivers/vfio/vfio_iommu_type1.c
>>>> @@ -100,6 +100,7 @@ struct vfio_dma {
>>>>  	struct task_struct	*task;
>>>>  	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
>>>>  	unsigned long		*bitmap;
>>>> +	struct mm_struct	*mm;
>>>>  };
>>>>  
>>>>  struct vfio_batch {
>>>> @@ -1165,7 +1166,7 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
>>>>  					    &iotlb_gather);
>>>>  	}
>>>>  
>>>> -	if (do_accounting) {
>>>> +	if (do_accounting && current->mm == dma->mm) {  
>>>
>>>
>>> This seems incompatible with ffed0518d871 ("vfio: remove useless
>>> judgement") where we no longer assume that the unmap mm is the same as
>>> the mapping mm.  
>>
>> They are compatible.  My fix allows another task to unmap, but only decreases
>> locked_vm if the current mm matches the original mm that locked it.  And the
>> "original" mm is updated by MAP_FLAG_VADDR.
> 
> It seems like there's either a bug fix or behavioral change to
> ffed0518d871 then.  What mm were we previously accounting in their
> fork/exec scenario that we're not with this change?

locked_vm is broken in their fork/exec scenario.  They must have some other
patch or work around for it.  Or, they have not tested enough to hit underflow.
If after exec, you first dma map something new, then dma unmap something smaller,
locked_vm does not underflow.

>>> Does this need to get_task_mm(dma->task) and compare that mm to dma->mm
>>> to determine whether an exec w/o vaddr remapping has occurred?  That's
>>> the only use case I can figure out where grabbing the mm for dma->mm
>>> actually makes any sense at all.  
>>
>> The mm grab does detect an exec.  Before exec, at map time, we get task and grab
>> its mm.  During exec, task gets a new mm.  The old mm becomes defunct, but we
>> still hold it and can examine its pointer address.
> 
> This is describing exactly the test I'm asking about, if dma->task->mm
> no longer matches dma->mm then an exec has occurred w/o a subsequent
> vaddr remap.  So why are we bringing current->mm into the equation?

Sorry, memories of my "redo" series are leaking in.  You are correct,
vfio_lock_acct modifies dma->task->mm, and dma->task may differ from current,
so I do need to check get_task_mm(dma->task).

- Steve

>> The new code does not require that current == dma->task.
>>
>>>>  		vfio_lock_acct(dma, -unlocked, true);
>>>>  		return 0;
>>>>  	}
>>>> @@ -1178,6 +1179,7 @@ static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
>>>>  	vfio_unmap_unpin(iommu, dma, true);
>>>>  	vfio_unlink_dma(iommu, dma);
>>>>  	put_task_struct(dma->task);
>>>> +	mmdrop(dma->mm);
>>>>  	vfio_dma_bitmap_free(dma);
>>>>  	if (dma->vaddr_invalid) {
>>>>  		iommu->vaddr_invalid_count--;
>>>> @@ -1623,9 +1625,20 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
>>>>  			   dma->size != size) {
>>>>  			ret = -EINVAL;
>>>>  		} else {
>>>> -			dma->vaddr = vaddr;
>>>> -			dma->vaddr_invalid = false;
>>>> -			iommu->vaddr_invalid_count--;
>>>> +			if (current->mm != dma->mm) {
>>>> +				ret = vfio_lock_acct(dma, size >> PAGE_SHIFT,
>>>> +						     0);
>>>> +				if (!ret) {
>>>> +					mmdrop(dma->mm);
>>>> +					dma->mm = current->mm;
>>>> +					mmgrab(dma->mm);
>>>> +				}
>>>> +			}
>>>> +			if (!ret) {
>>>> +				dma->vaddr = vaddr;
>>>> +				dma->vaddr_invalid = false;
>>>> +				iommu->vaddr_invalid_count--;
>>>> +			}  
>>>
>>> Poor flow, shouldn't this be:
>>>
>>> 			if (current->mm != dma->mm) {
>>> 				ret = vfio_lock_acct(dma,
>>> 						     size >> PAGE_SHIFT, 0);
>>> 				if (ret)
>>> 					goto out_unlock;
>>>
>>> 				mmdrop(dma->mm);
>>> 				dma->mm = current->mm;
>>> 				mmgrab(dma->mm);
>>> 			}
>>> 			dma->vaddr = vaddr;
>>> 			dma->vaddr_invalid = false;
>>> 			iommu->vaddr_invalid_count--;  
>>
>> Better, will do, thanks.
>>
>> - Steve
>>
>>>>  			wake_up_all(&iommu->vaddr_wait);
>>>>  		}
>>>>  		goto out_unlock;
>>>> @@ -1683,6 +1696,8 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
>>>>  	get_task_struct(current->group_leader);
>>>>  	dma->task = current->group_leader;
>>>>  	dma->lock_cap = capable(CAP_IPC_LOCK);
>>>> +	dma->mm = dma->task->mm;
>>>> +	mmgrab(dma->mm);
>>>>  
>>>>  	dma->pfn_list = RB_ROOT;
>>>>    
>>>   
>>
> 
