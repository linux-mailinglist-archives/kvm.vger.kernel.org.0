Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78BB964BD67
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 20:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236454AbiLMTkf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 14:40:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234940AbiLMTke (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 14:40:34 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12A9820F74
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 11:40:33 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDJJNOw008134;
        Tue, 13 Dec 2022 19:40:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=opDPQBbPP4TL2EeerUkp5+go+BuKtrU7zVUzRupP9mU=;
 b=1mCa7gJxalys6Prn4UUE7yGlx0VeigWliQ84AgHxC3mcFdjWO73oMqD06HyX7vZ1aY5u
 TAEq8eUVkrpDVpOdR5MmgcQhze8LWpoQeyV4A+in3Gz0xCrewf2cZZDYljw9f/jiyxe9
 itmEGBFG8F4lysBcmSh3vLKsHdQMOopjwcXCtcdhEdJttxVYExzPJMgq3U8oD9Ar6VG9
 cDbKUQYvK6iQ6YxsMVnYxfGVtSX4mhmtdIo0UAqf8vVdbu55syG+3oTNNblx1o9l7wuC
 nz5uXnCfABCiQHlD8qmMEivGAWFT/FzW2aA9MtGSH4+ApaZ+/Mdb9es8IkfiV3FxBEcj Pg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyewr1xe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 19:40:31 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BDJIqOG029386;
        Tue, 13 Dec 2022 19:40:30 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2047.outbound.protection.outlook.com [104.47.56.47])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3meyemrspt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 19:40:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BHqH2c7kIeG+Clzm4BRhbJyfuzO3+KI39iVpRLLzXRp6R2ezKpMfDE/M3v9B15G2KUFPu0WIaAMQuzJj+kWEoZXf4rWJobTYojNbuRTUKM/ownGWnt3EtLT/SoxxX0UE69B1S/ByXuvG4yurAxr5qPwaeUJ2NDjYfPpwGu+cOt04Urn4xbz5arAD+XnRKakS0s5ss1DV1zWFpqyBDuj0g7lZzjvOJJ4iHtCchiv8A2m5TQv0iIwti80rVQWyR+n/Lu6/RiqGynDG1/b6pBqmD88J1+it9jez/vgrwiWlIsWi77CkMFrEHENSH1GavJXEbD+KEHIlqHcJtmIgaS55Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=opDPQBbPP4TL2EeerUkp5+go+BuKtrU7zVUzRupP9mU=;
 b=YjuhXhUlCIhyfEViTRx+PnRdH8H6L4Tm35wih5W2oTV1+f7P0h6MUEaAD48C/na+qQtxJXqJRBRfW8+lEakLvQqIWzBKhnkY70bloXTkXh0f3JPHaZcR5JMVAlyRZNPc3il/MXVEz5poJ/gv/C4wuSroeszeNZdS5YfFK/smr/55LDKRC6X9MdVQWjfon8gUGbPi8bKTde30hBLOm9Q+MyZJF5i+yW+9mp2HdB4qZnhQQaFwj7GNSZ+pP9fLlYQdtTHZnm9tMpuviUfrsbDxAQEqZu9J4LOap1p5S6IPc+fc26b1HJmr+xtc4aWUAKA1Cp1YIzbu/vSzMPQBV/VIFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=opDPQBbPP4TL2EeerUkp5+go+BuKtrU7zVUzRupP9mU=;
 b=CnyQopgSL39+elNWJJ0SnQYq7MLLAgSf4AOAetS+SExUQfwQhQ7qyMk2LZASmlsidCd9sN/ma98VGpiBbWIdp7z9lqwkbCwSj77zg45Oo+RfxRFvNgWBk0riZ6aYXb72SJ85bEy2EpdWAqWWYKHp1fmkWc17NxOAan5lq5fKmbs=
Received: from SA2PR10MB4684.namprd10.prod.outlook.com (2603:10b6:806:119::14)
 by PH0PR10MB5580.namprd10.prod.outlook.com (2603:10b6:510:ff::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Tue, 13 Dec
 2022 19:40:27 +0000
Received: from SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::4056:9f2c:6171:c37e]) by SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::4056:9f2c:6171:c37e%4]) with mapi id 15.20.5880.019; Tue, 13 Dec 2022
 19:40:27 +0000
Message-ID: <e8037fea-d4e6-4f51-165c-bb23d90e221f@oracle.com>
Date:   Tue, 13 Dec 2022 14:40:24 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH V1 2/2] vfio/type1: prevent locked_vm underflow
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
References: <1670946416-155307-1-git-send-email-steven.sistare@oracle.com>
 <1670946416-155307-3-git-send-email-steven.sistare@oracle.com>
 <20221213110252.7bcebb97.alex.williamson@redhat.com>
 <69e68902-eed9-748a-887a-549c717ebe01@oracle.com>
 <43ad3256-e485-b358-6445-35645d943b7b@oracle.com>
 <20221213122918.024f43c5.alex.williamson@redhat.com>
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20221213122918.024f43c5.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR08CA0072.namprd08.prod.outlook.com
 (2603:10b6:a03:117::49) To SA2PR10MB4684.namprd10.prod.outlook.com
 (2603:10b6:806:119::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR10MB4684:EE_|PH0PR10MB5580:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c6b90f3-d263-406d-9bd1-08dadd41e2ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6ySPvE0EMFdPlyJymzp7x/1Z1Wzh/d+ZeCHt4yk6RK9TXulZ8H9xBth7SgEhz+wlyrMyPy2GeYO4vG2bOTNx6/w22itva/rPYQnQOhfREkeWco41/r+E5f3zpvqDnJYm98VqTikm8cSfhhZS3uvBy9uYIZW942wjpD+rgxvVayulaVBSUCx+cXsu7ZVxmQ5UhtA7y9SbG9GjthMmWjNwjT4IhW/YYiAfqPC6k/f6I06Xukp9pcTzS32e34PdrqrKM5RSUOlH9wR7JwPpAbl0IR4f7HtcgjbPPlMlXz9OtwS8wVocE54551/W5nJFuw32Zs1hPH221eiPVMpYO8iZxaJ5PPGhr72ix4EJzrTRbxE2ldYs5tBQ+0n56EUi+f3HHcJ0+BQHRxz7hVtRXlrq4AlBTAQ3dpGnhSuYXcGAWYZHOZzy+AlZq8J2RuAQlfRFq/b344Q1/BfFxnEszNko8+jOfeCaZoyUhqbhA8fqeNV3V50kcDwBME7LePKkDcFf4ALeNd8cNk+m0Icb6GkW0JZ8MDgdze5+BwZ6/3zWKSFwZIL0YRnJuOmBIqJ6UUUptDMYXg4o0n9JDfMQbRvT6v1pGFwRBQsUIFUH8cKn9kl83OkbtGBWBc3hnMUR3WQGIoNy+2CedoKNy1lJTZLQ04btWR2ZrQCivPSwVi83I9DIc/weB84+YGQY4ZuSO+t3NfaX04MJe4+sNaymMid1UsSUlO8/gnPu4Q2ng/EEvkQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4684.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(376002)(39860400002)(346002)(136003)(396003)(451199015)(36756003)(6512007)(41300700001)(26005)(83380400001)(31696002)(186003)(6486002)(478600001)(36916002)(5660300002)(8936002)(6666004)(6916009)(316002)(66946007)(86362001)(66556008)(53546011)(8676002)(66476007)(4326008)(31686004)(6506007)(44832011)(38100700002)(2906002)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VHlJaUNrU3JqSnhkbENDL2J5azdqS1dQdENQZ2RybWNkdHBYbFJUZWk2dVJX?=
 =?utf-8?B?K21pRk5JV0xsT1lsYllsT29FbW1qeCs5bnFwcjdVNG93TXp1V01lTU45WWM1?=
 =?utf-8?B?SmFKOUovNWZyaHhZb1c2WkpRblBCN2o5WHN0LzdzNjJhci8zcmQ5MTlrSjhz?=
 =?utf-8?B?dFIrVWM1N3VNNjRDMDFORGhIM2xvWlplcHVuVUkydDNmNCtyWFlhejFnRGtq?=
 =?utf-8?B?SEg1U1RsdFd5M0RUQTFBZXlUTVZhc04rRDRMT3pGb2tsZDh0ejlrWFJzcDNJ?=
 =?utf-8?B?dW5qQ0xJdVZ4b2tNOGF4NWlPU3dxbWEzOGhmRGJmZ0xrandGYjJyYVYvM1Ir?=
 =?utf-8?B?QlRLNjBkRjVocU5HM2I3ZDQ2K3laSjFLSmgwcmh5REN0M1B0UVVKeFNXbFdn?=
 =?utf-8?B?K2NSczlTK082MGxGdUx1SG1QckRJekp6VU5pczkrbndUNlIzSG1OeGo2VlNX?=
 =?utf-8?B?a0tJTzlPWlhDNnBFOFk2ckd2UVhmeGZoUVduOXFsbWhGREJCTFJzeVNCVVVw?=
 =?utf-8?B?VVpURDV2cWFoVVNtVzVJbENhS01kcUd6dFJxREJkOEpGRFZicGw1R1NETlpw?=
 =?utf-8?B?YlFiY1N2WEtKekh0REF3Z0ZDT2l4ZzdhbW5oaGFOampGZFdHcmhITDRCQ09M?=
 =?utf-8?B?VEJSMXROaU4waWo5TUtJNlByNEtZaW9POGs1MWRGR2xuQm9pS2NZb2c2U2Yv?=
 =?utf-8?B?OWp6UDZuUGViRW5oZXJVTWtkRy9ob0ZEWjJTMTBQZlhNUU1tMXNGRjJEQ0I4?=
 =?utf-8?B?SXZ5Mmp2OElaKzdsdzh5eDFSM0hreXhETjVRbXBnejFSNWVBODhyQzR5T0E2?=
 =?utf-8?B?UjZiQTlSVzA0LzRmcEdzdzhmS08ybzAxVXVDeTZvMmQxYkNoZzJxNEx5bkNu?=
 =?utf-8?B?TUhDNEtNeUFnR0F0WGdrN1RNdkdrQmNWR1cwZy9QRnMyenB2MXNmSllkM2V4?=
 =?utf-8?B?ajRxRkVrUE5QZXdhZ2ExbkJ3UGxTS0hwOHlLWG9QYUx6NmVFWHk3T2dyREFF?=
 =?utf-8?B?cWdsNFV1OTBSQzdPcWgrYnlneEYvSXVudjFEcnVjYWtva0Y2WDB5d1prVGJG?=
 =?utf-8?B?bTRXeVJ6bHoyS2ZQQlRkS0t1STJseUtGOGNJWUdzeWpsUXp4emQ1QytHbnVv?=
 =?utf-8?B?a1k0bC9MVStCREFnbTBZQW1mUkdiL0o4bUJIUkRzZlpXRjEweFRibTFNdlp0?=
 =?utf-8?B?Z3k4NjAyOThHdmZuZmRzajJKQUJXK2RNKzh4Y1Q2VDZzNDd6R0VPcU55Tjh2?=
 =?utf-8?B?ZFhxUndlbkdQRDlobTVtRnF0VnVTN3pKSFFPUGlaUTB4bTJ2dy9jZzdnY1RD?=
 =?utf-8?B?U045YTNGTVBXUkVpTWhBM2swUWNQbzQ4RW9FdDYvd2M1em9SYzhmWi9jRCs4?=
 =?utf-8?B?MUQ4Mkx4QktlR0FIRWVubGlrVi82R241d3NuQlRXRU9VWnF2cGkrOXJYU2tC?=
 =?utf-8?B?WnBHU0hwanBsM0krMHNWRDRJeWlBc3MrUEwvYUg5QlJXYkhYWE9JelpjOWI5?=
 =?utf-8?B?OGRkUUc0Unp4SDJMeHlkclJLMHZ3UDhRVmZPN0NrLzNIOURXNFc0cVBaRUVl?=
 =?utf-8?B?N1RsQW9vR244UUpRL242Y2xyMkM1Z0lXZzB6d1A5eGs4c3QrQmpMVWUvbG1k?=
 =?utf-8?B?WDl1czVwRlFMeEw0ZlByMTJwUVY2SVVGZCt1SElYLy9iYTZwai9ITjhLZzhD?=
 =?utf-8?B?Um5ZRFRnS0tHOVBVZGh6ZlR1V1R0Y0IzOFlHbTgycWg0RHRrWDl0VVVpRmFT?=
 =?utf-8?B?dXpZaWRCSmdqK1JweXVKdzc0MytyVkQ1bUlRRXFtd053U01sT1NFK3F0YmJT?=
 =?utf-8?B?ZnhKTVFoWWtGUk5lVTRhTjdiUjRQNi9rMURrRllzQTk0b3o3YlJPT0dHdHdo?=
 =?utf-8?B?VlNMa3NDanhobGVxVy9FTVplN3VNeTRaUWh6dkVYbER4YURoaGVOTVNOSHJE?=
 =?utf-8?B?SDB4SXRnQ2JtSWxHWTk2cnhQdFo3MTJhZEU1T015ZGpIZGc2L25iZUVBbHNz?=
 =?utf-8?B?bHlpL2RuU1JERTVNNWVhZ2JGT083WGJmREZPOGdNc2RUU2xyTDJNVjVqUEFp?=
 =?utf-8?B?Ym1ERlhrckxXR2M1Tk04aHQrdTNjaDdqd1cyeGZyL3Q1UU9zTExZNGV4L1Nh?=
 =?utf-8?B?c0FsZjFYa01kd3hGWjRZQkJsbUJoQlpaWmtYTkkzMnV2STlTcnk2cE9pRE0x?=
 =?utf-8?B?VGc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c6b90f3-d263-406d-9bd1-08dadd41e2ab
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4684.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2022 19:40:27.3118
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uuUi4TKArns71onC3WPtc3FmlTkUh1NJU0NoEZpwoemdlffo28yj6M4f/VL+lktLOBUkHQpINMsS2pqvmA22mI67fd8W9aClU2TyBeIJFDU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5580
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-13_03,2022-12-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 phishscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212130171
X-Proofpoint-GUID: EYgVXt68pNYmGIyythqQH0Niof8kY2vx
X-Proofpoint-ORIG-GUID: EYgVXt68pNYmGIyythqQH0Niof8kY2vx
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/13/2022 2:29 PM, Alex Williamson wrote:
> On Tue, 13 Dec 2022 13:21:15 -0500
> Steven Sistare <steven.sistare@oracle.com> wrote:
> 
>> On 12/13/2022 1:17 PM, Steven Sistare wrote:
>>> On 12/13/2022 1:02 PM, Alex Williamson wrote:  
>>>> On Tue, 13 Dec 2022 07:46:56 -0800
>>>> Steve Sistare <steven.sistare@oracle.com> wrote:
>>>>  
>>>>> When a vfio container is preserved across exec using the VFIO_UPDATE_VADDR
>>>>> interfaces, locked_vm of the new mm becomes 0.  If the user later unmaps a
>>>>> dma mapping, locked_vm underflows to a large unsigned value, and a
>>>>> subsequent dma map request fails with ENOMEM in __account_locked_vm.
>>>>>
>>>>> To fix, when VFIO_DMA_MAP_FLAG_VADDR is used and the dma's mm has changed,
>>>>> add the mapping's pinned page count to the new mm->locked_vm, subject to
>>>>> the rlimit.  Now that mediated devices are excluded when using
>>>>> VFIO_UPDATE_VADDR, the amount of pinned memory equals the size of the
>>>>> mapping.
>>>>>
>>>>> Underflow will not occur when all dma mappings are invalidated before exec.
>>>>> An attempt to unmap before updating the vaddr with VFIO_DMA_MAP_FLAG_VADDR
>>>>> will fail with EINVAL because the mapping is in the vaddr_invalid state.  
>>>>
>>>> Where is this enforced?  
>>>
>>> In vfio_dma_do_unmap:
>>>         if (invalidate_vaddr) {
>>>                 if (dma->vaddr_invalid) {
>>>                         ...
>>>                         ret = -EINVAL;  
>>
>> My bad, this is a different case, and my comment in the commit message is
>> incorrect.  I should test mm != dma->mm during unmap as well, and suppress
>> the locked_vm deduction there.
> 
> I'm getting confused how this patch actually does anything.  We grab
> the mm of the task doing mappings, and we swap that grab when updating
> the vaddr, but vfio_lock_acct() uses the original dma->task mm for
> accounting.  Therefore how can an underflow occur?  It seems we're
> simply failing to adjust locked_vm for the new mm at all.

The old code saves dma->task, but not dma->task->mm.  The task's mm changes 
across exec.

>>>>> Underflow may still occur in a buggy application that fails to invalidate
>>>>> all before exec.
>>>>>
>>>>> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
>>>>> ---
>>>>>  drivers/vfio/vfio_iommu_type1.c | 11 +++++++++++
>>>>>  1 file changed, 11 insertions(+)
>>>>>
>>>>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>>>>> index f81e925..e5a02f8 100644
>>>>> --- a/drivers/vfio/vfio_iommu_type1.c
>>>>> +++ b/drivers/vfio/vfio_iommu_type1.c
>>>>> @@ -100,6 +100,7 @@ struct vfio_dma {
>>>>>  	struct task_struct	*task;
>>>>>  	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
>>>>>  	unsigned long		*bitmap;
>>>>> +	struct mm_struct	*mm;
>>>>>  };
>>>>>  
>>>>>  struct vfio_batch {
>>>>> @@ -1174,6 +1175,7 @@ static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
>>>>>  	vfio_unmap_unpin(iommu, dma, true);
>>>>>  	vfio_unlink_dma(iommu, dma);
>>>>>  	put_task_struct(dma->task);
>>>>> +	mmdrop(dma->mm);
>>>>>  	vfio_dma_bitmap_free(dma);
>>>>>  	if (dma->vaddr_invalid) {
>>>>>  		iommu->vaddr_invalid_count--;
>>>>> @@ -1622,6 +1624,13 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
>>>>>  			dma->vaddr = vaddr;
>>>>>  			dma->vaddr_invalid = false;
>>>>>  			iommu->vaddr_invalid_count--;
>>>>> +			if (current->mm != dma->mm) {
>>>>> +				mmdrop(dma->mm);
>>>>> +				dma->mm = current->mm;
>>>>> +				mmgrab(dma->mm);
>>>>> +				ret = vfio_lock_acct(dma, size >> PAGE_SHIFT,
>>>>> +						     0);  
>>>>
>>>> What does it actually mean if this fails?  The pages are still pinned.
>>>> lock_vm doesn't get updated.  Underflow can still occur.  Thanks,  
>>>
>>> If this fails, the user has locked additional memory after exec and before making
>>> this call -- more than was locked before exec -- and the rlimit is exceeded.
>>> A misbehaving application, which will only hurt itself.
>>>
>>> However, I should reorder these, and check ret before changing the other state.
> 
> The result would then be that the mapping remains with vaddr_invalid on
> error?  Thanks,

Correct.  In theory the app could recover by releasing the extra locked memory that
it grabbed, or increase its rlimit, and then try map_flag_vaddr again.

- Steve

>>>>> +			}
>>>>>  			wake_up_all(&iommu->vaddr_wait);
>>>>>  		}
>>>>>  		goto out_unlock;
>>>>> @@ -1679,6 +1688,8 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
>>>>>  	get_task_struct(current->group_leader);
>>>>>  	dma->task = current->group_leader;
>>>>>  	dma->lock_cap = capable(CAP_IPC_LOCK);
>>>>> +	dma->mm = dma->task->mm;
>>>>> +	mmgrab(dma->mm);
>>>>>  
>>>>>  	dma->pfn_list = RB_ROOT;
>>>>>    
>>>>  
>>
> 
