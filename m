Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75D4964E38A
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 22:56:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbiLOV4j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 16:56:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbiLOV4f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 16:56:35 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A49C2A417
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 13:56:34 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BFL3u1g026530;
        Thu, 15 Dec 2022 21:56:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=BauQYOB29J9qppk69y+DDnh214uT1UOkOyeiinyIpoI=;
 b=wKmfbt80pk8MBlR9rccyEpGEgH9UqqBg1/ysKXgkwgFsPbtsq0VeIUN8CyGW4KzvzVAq
 bnaznTYN0neU0IXhEM1m4RnWEsGiClKur0FMA8ZDGHbBTk9MTVVGwDLWh+FGtdr8GRnZ
 i0AQSYW7zaspvABi/ue8tsqttyY5RwGb/1xpLWJyahf9u33BNasqbzREvwDgSxRh2sNQ
 ndrXfnnEQmbDgo5T3of3IuGBdSG1pgR5WGGxPWwJPa76+tyYFX/0kZnSSACIYGy2xkwc
 pW4PDqFhctUBHfxfuP+3qBjUyxHNsN5p6fKuIWpUzNVZtOXIofFyQgGym+RDYjx10gVD IQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyerxb0a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 21:56:28 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BFKVP15032945;
        Thu, 15 Dec 2022 21:56:27 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3meyerdefp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 21:56:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RXlvsK0ogIBXjcrX/vWyN70Z+EgSSAMhCEJIuhPkwUIgAXZbw5Iv3mkPbSarL3cvSC9Te2DMsIj/rZkC+R5Al9hjv5GPVbGLNvtuCh2hjMrEvOO5UXk9A4zyN+mn2zS+VUDCaBAVYX8UlxTI3YOO0fk003/K3KQmUEbRzSIWltSAw6jS8Jj1XPLnR5AsTKN5jStGMwa9jZYIQxXz73AZNIUbsrpozh3lEMaqxFa4VvT+TE1CWwNGHh+Qdhc540v0oCe+c+gcrYXc4vcNP5v0jrWgMBXaku3bSYmhsnAZL0c/nhmJxSuAAXdteE8b5zZgJg9XQvDF6alqvo8NDepYjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BauQYOB29J9qppk69y+DDnh214uT1UOkOyeiinyIpoI=;
 b=CJZukgccYOhRzsDqUu9w0/aaWxqach5WAaqn1zGCB+BkF1Att7dozna98uRfWwDGA9xVmaHohmPYWZtqL0c8kXnMu8GuegP7ZTlq83yju5pB6I34y5+EhOXhC/a1dLoO86MHdvBRLa2Q0F0RjJyjCtya+RTyNtp2lK4F7tkChYyw9BRie87ovo+71SD0BUfXHrq7Xn0riyEeRRj32zSAApcNnQ8wCXp/bdu/zBB7wGJnQGSJLyhFBfe2i4sesqJUk4UkVRCyJepYp/CB+OugRzh2bu6aLGqpPxBSyLBfoUlm9QyXUfRKF78+iix95OI1nZV1wcyYUTavLe/xZaUk9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BauQYOB29J9qppk69y+DDnh214uT1UOkOyeiinyIpoI=;
 b=C2m1a7UhQfkfVWaJwmdsUp5XUVeB8hxQGeiBcimqYtoqfK4qQk1WBIWTFkeLFDsKcjGdHO57JlTorQZpkBoF7836DvYCOlvLBz14Av2ZZ42WcDV1xx3fSg7SymBkyjOI2J900G5yemEVKY1b4CHSENk9exVkS5NXoA81fiYvHiU=
Received: from SA2PR10MB4684.namprd10.prod.outlook.com (2603:10b6:806:119::14)
 by PH8PR10MB6289.namprd10.prod.outlook.com (2603:10b6:510:1c0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11; Thu, 15 Dec
 2022 21:56:25 +0000
Received: from SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::3667:7f89:cdc7:9cca]) by SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::3667:7f89:cdc7:9cca%7]) with mapi id 15.20.5924.012; Thu, 15 Dec 2022
 21:56:25 +0000
Message-ID: <5317ae54-924b-d517-7497-613906e1789e@oracle.com>
Date:   Thu, 15 Dec 2022 16:56:22 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH V4 0/5] fixes for virtual address update
Content-Language: en-US
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>
References: <1671141232-81814-1-git-send-email-steven.sistare@oracle.com>
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <1671141232-81814-1-git-send-email-steven.sistare@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR06CA0003.namprd06.prod.outlook.com
 (2603:10b6:8:2a::27) To SA2PR10MB4684.namprd10.prod.outlook.com
 (2603:10b6:806:119::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR10MB4684:EE_|PH8PR10MB6289:EE_
X-MS-Office365-Filtering-Correlation-Id: 727bae72-000c-41f8-7d3a-08dadee73652
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b1JD4nqRnfgqS0sqjM0pSi0v9VlqbXl5BFB5zQq8KRdvZTDP7hkj6KtgBCK6JVldNTEpOhHiyLSKGuY97ja32AEvN3aXt5hd/hoG5/SVwnvjpx5o9ptNW/zwGPwtJzZvzblZ+LxSDM6uy511wWfaFf30ib6j/0onShTu2UlEdzUX/dAn9EGG2nZNaCGi7XHCxlAGhv9Nq1AR9HI4BGmxRt8ZzBgPoloYIVVkngjW/5i8EwU4UMCEC3/La22ykplDvVL5FzBgF/KOfQaXQQvPvr8GS9Mnufe4+dF6Jgg3W52SAMyYkJyO5YLYM0L7HXi4Y5uHgyiyhqrh76OZxb/g2bYRWI//AiepBJIOAkupnGriiSvzPYdN/heBZbeOgVSw8fbeFPGVDjW3gium8sMWRa6ucuc4GEhG+TeS6nAk8Jp/HWbn+NV2+5lXSXgzbiDLlnfWuw7hENd5maukS/+ahFm8Emu/a/Jsx5OdPGX7UNppxikkwu7+SMq5o4e/pgIuJmGAFpBr/PspI06QUS95A8MVcOs2Zvgq3kEYUrtKoBYzQDZtNHDRqjy1V5sVoQivk+H11xK8xwU4ZR6CskqQJfGj41u7/0CdjWI5LFGg6lOeogDnhcvtsV9TPhTTB5LT7cXb0jjFu56SIwoeu/EFmIn0HgXU2DsFQYeKJmWVmGeW1RGFcdbwp3xS1YLskbKVCA8SWuVZWMVIS025rBgOf1Gx5/VKYuCUj+f8GK07CeI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4684.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(366004)(136003)(396003)(376002)(451199015)(66476007)(6512007)(66556008)(86362001)(41300700001)(4326008)(31696002)(26005)(8676002)(186003)(66946007)(2616005)(478600001)(36916002)(6486002)(5660300002)(6916009)(316002)(53546011)(6666004)(38100700002)(54906003)(8936002)(83380400001)(6506007)(44832011)(15650500001)(2906002)(31686004)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZG5NVFRXRE1lOXR1T2RaODdOV1ZOL3BrNHdOMy84cDNBSEZkSmdlS01oRTEx?=
 =?utf-8?B?YUdvVUowRUtYNnJKRmJ5azFURGpEMW1aY0FXMEoxRW9pRjZObmtGOEw1ZG8z?=
 =?utf-8?B?QzJ1TWJsNWxzSW9UTHVKYWRzd28zdTdxTkFWc0N3MnFCbjAvTm1rOGhHSVlt?=
 =?utf-8?B?VXVDbHU1Q3lVaVY3MnRxUk51QTNZRGttRzlqb2FCREthSzFneGgybzRiWjE3?=
 =?utf-8?B?djJ2ME9QNGNLRkhCTVFYaWFsVlZxT1o4UExvVzdhQk9WY2YzYTlzK3EvODhn?=
 =?utf-8?B?VUlEaWJWUzlQbnRzQno3RWhheitXR0NNM1hidlFHcjNvSGZLNWRtWDNnZXBW?=
 =?utf-8?B?NUhyNWl4aW9GNWNrZklxSnNsREgwTWt1d0tKQTM0SnZabDBkNnBRZTZPY2tM?=
 =?utf-8?B?WGtHY25ocG9PaDZRMFlPMkNTOGR4dkJKdi93bllBV2J2dmNMeUY5b2NqVFVo?=
 =?utf-8?B?SHI1cmhCdW8wTHpyL3lNUUpVWkRscUgySGZGWXdyQmlHdnhsMWRBc2M2d1Rr?=
 =?utf-8?B?NGlBNFUvTVh3dE9yTldmOXJ5dVR4TjN4Ym1sK3d6ZWJTTndGNkpFTlZnWXhU?=
 =?utf-8?B?VHZTNEY4MGVHWURLbDRyZ1hNaVBHOGQ0OXBuS240NlVyS2VSTjRQaWRvWHkv?=
 =?utf-8?B?VEx3bnhBK0ZyVXZwTDJWWEMwT2Z2NEpBNkYvaTREMFN1eG1KMjBLZmhSeU1a?=
 =?utf-8?B?bVB3NXpudnNObEE5Q1VBZ2t0VnpzQUdQOW5iSnhMN0Q1ZHBTbGFmMUVWa2tz?=
 =?utf-8?B?ak9sKytDbGJDOEFpR3BPemhzTWl2Q0tQRmpQNlc3TzdMSTFKQ3lWSGQxVnBq?=
 =?utf-8?B?Q293aEdyYXFjVFJMeVh1Y1o3Ung0TWVvckgzQ3hDZGhvdEw3aEY1dHBFaThy?=
 =?utf-8?B?MjRuaFdtS3JoQXE3bmtublQ4bURjQmw0VFhWM0VHVGxhSUZTaVdqeUNBQW80?=
 =?utf-8?B?TlFzQnlGckxXVEpzT3I4dm5xTENZMnBDU2ZLZnNXMTJlekdTTXpYRE9taFhz?=
 =?utf-8?B?Tkk5aGZqaHNSc0dGSHc2RU8vRzN1RWVRV2wxWEZHaWNIajBxakh2em1YWk5H?=
 =?utf-8?B?NFZaYnRUYUx3TEhEUlFFU2RFNnhSbVdOU0NkeWFyZm9NT3RHY2dzbEtXMkQz?=
 =?utf-8?B?L0cxK29kYy9RWXdqMFdGZGh4LytRREVlOGNXSzVJS1lENWZ0cEFpNUlNTDFo?=
 =?utf-8?B?N0hFOC9RTS83Zzd6VHR6MCtpejZ2enlWKzJxZW1mMG9yNEJvYzV1cm5uWmt0?=
 =?utf-8?B?cGt2YTduMlRYMFdVR3N1bDd3S2VaUWtPQ1BsS3VGMkNyMmlGOTdNOHJlZ1o4?=
 =?utf-8?B?R3N1QlZpSEdpQmd6YXlCSVVnZXZRWC9hVmcxSkpMUGhqU1ZJWEd0RTRKdVU1?=
 =?utf-8?B?NVNybkxUMDRoK2ZuRmxycWNjRmZBY1E3Y3dyVkxRNEtXRnA1TFNTRStZZHlr?=
 =?utf-8?B?TjRDcTF4eHpqeGlKTEJaWWRMK0NrVUo2MnM5YWJVOStob0tnUlVURFJuWHBh?=
 =?utf-8?B?NHJsZGZUTHkwSzF1TE9BQVNsRFd4cDlsUlhieTdDbVJqSjl2VVdYUHd4aHUy?=
 =?utf-8?B?UzJjbXZCMFNpQXE3ODZsQ0lyRHQ1RTAvS3FvZHAxS3g5NFlVdVdjYk51L0FJ?=
 =?utf-8?B?WGZFREMrWWFWTkc0aTczNUI2QlZXcldJdlBoY25XN2NOQ00vaER6WnN5UUx1?=
 =?utf-8?B?eXJhNzVaM2JqTUU0eU5uZ2s1alVxTHJEWDhodm5PQWJwZldpVVJRL1pCekFH?=
 =?utf-8?B?bUI4ZUhaOFI0aUh2bldnaDNJeEEyeXp1RG4vNGNocWJTWk5UOE1tYnFLRExs?=
 =?utf-8?B?dSt1UHkzSWRHSXcxUGtFSHRFTVBNNXJqOXVqcXdycFp4UzRKOVpaRVNMTC9P?=
 =?utf-8?B?emwvczN4aUlGN1FyRzNIa0t2Y2tJTUNSNzV2WjJwSGdFblhlc2p6eUVCQ3l0?=
 =?utf-8?B?YnFWSDNHNW50V3o2bDFxYndsSEFvcnNiVTYyMStxTzRybnlUR29rV0ROZU1y?=
 =?utf-8?B?RkxVbVFjNTNhUEZpRnZhM0ZzbnRrY1hWcnBYRENtYzYxc3ZZd1VnYUFlUzlZ?=
 =?utf-8?B?V2dqNjBEaUcwMEVjc0RNME1mT3BOdmVtVDdQblJ1c3plUkZUcVF2OGZUK3dm?=
 =?utf-8?B?OHAxTmNXekk2YUdKSDMxRG9xVW01MUsrN010Qnhra2lYMVhPeEh1S3RrTGtj?=
 =?utf-8?B?WEE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 727bae72-000c-41f8-7d3a-08dadee73652
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4684.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2022 21:56:25.7627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uHk8WH58ropJhJmRwOqtau3LAdIiRMhJIrfHVw05pfEOSjq7dh65R0I+vlY0flX1mRUJkolOTBY09pi+5qvYviJoAsleZ0bMWAad6eZ8Pyc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6289
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-15_11,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 phishscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212150182
X-Proofpoint-ORIG-GUID: QxmTyqYAj7zzeo8KPkuI-hO673tLjhgm
X-Proofpoint-GUID: QxmTyqYAj7zzeo8KPkuI-hO673tLjhgm
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PLEASE IGNORE this resend of V4, I sent the wrong directory - steve

On 12/15/2022 4:53 PM, Steve Sistare wrote:
> Fix bugs in the interfaces that allow the underlying memory object of an
> iova range to be mapped in a new address space.  They allow userland to
> indefinitely block vfio mediated device kernel threads, and do not
> propagate the locked_vm count to a new mm.
> 
> The fixes impose restrictions that eliminate waiting conditions, so
> revert the dead code:
>   commit 898b9eaeb3fe ("vfio/type1: block on invalid vaddr")
>   commit 487ace134053 ("vfio/type1: implement notify callback")
>   commit ec5e32940cc9 ("vfio: iommu driver notify callback")
> 
> Changes in V2 (thanks Alex):
>   * do not allow group attach while vaddrs are invalid
>   * add patches to delete dead code
>   * add WARN_ON for never-should-happen conditions
>   * check for changed mm in unmap.
>   * check for vfio_lock_acct failure in remap
> 
> Changes in V3 (ditto!):
>   * return errno at WARN_ON sites, and make it unique
>   * correctly check for dma task mm change
>   * change dma owner to current when vaddr is updated
>   * add Fixes to commit messages
>   * refactored new code in vfio_dma_do_map
> 
> Changes in V4:
>   * misc cosmetic changes
> 
> Steve Sistare (5):
>   vfio/type1: exclude mdevs from VFIO_UPDATE_VADDR
>   vfio/type1: prevent locked_vm underflow
>   vfio/type1: revert "block on invalid vaddr"
>   vfio/type1: revert "implement notify callback"
>   vfio: revert "iommu driver notify callback"
> 
>  drivers/vfio/container.c        |   5 -
>  drivers/vfio/vfio.h             |   7 --
>  drivers/vfio/vfio_iommu_type1.c | 199 +++++++++++++++++++---------------------
>  include/uapi/linux/vfio.h       |  15 +--
>  4 files changed, 103 insertions(+), 123 deletions(-)
> 
