Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A117D64BBC8
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 19:18:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235505AbiLMSSN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 13:18:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236444AbiLMSRt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 13:17:49 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D67461FFA5
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 10:17:47 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDGECsh020563;
        Tue, 13 Dec 2022 18:17:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=j8dKstXWubPZvwOMnkT+YEuqT4wpTJ7B3szzyy1c4Vo=;
 b=nCfH8G38WipimC3nw+D8fEOOKuqmBy5QVEZF+UqT2gD2h5fPgYL4bM+LkpdlgW5vm8dO
 +YYx9p3Fjrn7dgTYGfxjhwTPJQppmHRsf2CchNPNPDH4z4vWb1xbpqntz3jDPYF6dh1P
 ShZqIhxpCrdcVzEnQefqAB1w0FcpKOEz+asFEaBjD6PDEJfcJPLlyIoUdSote707+0fD
 lT1/KfUU0fCu9si+brH890Zty6DArMHlHy3+K4W+o/t7iDfHX+9iSYnwrCDKpuhQu1DV
 NlJ9hwgxJ6CPBJg2oXYAkGWevp+rFU7oZSn7LGDeE6AIg9m5EC8OcTKkC9fnHIdEiHTn Og== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mcjnsx208-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 18:17:44 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BDI4S3J011768;
        Tue, 13 Dec 2022 18:17:44 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2040.outbound.protection.outlook.com [104.47.57.40])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mcgj67d5n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 18:17:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L6POsNVqmJCE+UyvpVZgf0zJXEpAvJ8I81gJvOfVTHvLoiu6KRLAFFm6l2NDltJKc9UGxG71s4KX63znN1mUR8SWLKPbc5L0VohSv39wzJ9Bzsh9L21ykzWH+Q1SQxFooq8S0bshljBFZlnZypxeEPZJvyODDVRsI8yqupZovFzLZo404g8ofa0CII6DVxlrnamwmHuZwFqTUzs54zIJk7VWbYTkw/MNBMJHRRBelSAqe9DLfJPD70vB7GYELlS8TOv8IZv3ERhUKl5EcD5ZxpTTaCwSEsPGtpgU5yR0qtvnx1Szbfkdzfa7Uu7cNtzDBwCxPvEIIP+7N8S54NVMEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j8dKstXWubPZvwOMnkT+YEuqT4wpTJ7B3szzyy1c4Vo=;
 b=VnAbqGCo5bYx5wkpVc+ms3ZokWb/Mo8gjpywasZx3zQn6BFCQg/YEemUtJQEn2cNjzx/doWsTadIhifAIz3BDFkrKI6Y7DJIhYUPCrK3yxSVL4H2jzRzxdarUmc6eLskazUDOlwvIueMZpexfnc7SePRh6kjjTzMiQxULGJIivhJO2ZTDx+Tx9eR8gj+klAR+G6NDfWsxFaKDkQJNPc6BZWFnfN3ZxJhwNP/izn/XWKFRCudF1c3yYVcvV+7iwTxYl5gg5rylCBuonWK4v3EWKt4hNYYZiUtMTDSMq+YryHtnttH0Qh4mHvALXgHKzPqq7gxPnnCDhQUPHLj4ttFpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j8dKstXWubPZvwOMnkT+YEuqT4wpTJ7B3szzyy1c4Vo=;
 b=CjtU0e7+mI2uB8y2BXqUCnM6+O6jw/ZtexBWlae1Ilp7FEzFIdFFHbSFv0I/TGZ3LS67DG3KOcHCmq1/S+5dASy+fY4uClooMlk1MuNEi9mEyt+sHatqWZYioAgqJkK1dBoHHp55bnwxVdydz8rJiYX3kIMIIi4FIkK+etl/9gM=
Received: from SA2PR10MB4684.namprd10.prod.outlook.com (2603:10b6:806:119::14)
 by IA1PR10MB7312.namprd10.prod.outlook.com (2603:10b6:208:3fc::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Tue, 13 Dec
 2022 18:17:41 +0000
Received: from SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::4056:9f2c:6171:c37e]) by SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::4056:9f2c:6171:c37e%4]) with mapi id 15.20.5880.019; Tue, 13 Dec 2022
 18:17:41 +0000
Message-ID: <69e68902-eed9-748a-887a-549c717ebe01@oracle.com>
Date:   Tue, 13 Dec 2022 13:17:38 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH V1 2/2] vfio/type1: prevent locked_vm underflow
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
References: <1670946416-155307-1-git-send-email-steven.sistare@oracle.com>
 <1670946416-155307-3-git-send-email-steven.sistare@oracle.com>
 <20221213110252.7bcebb97.alex.williamson@redhat.com>
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20221213110252.7bcebb97.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7P220CA0007.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:806:123::12) To SA2PR10MB4684.namprd10.prod.outlook.com
 (2603:10b6:806:119::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR10MB4684:EE_|IA1PR10MB7312:EE_
X-MS-Office365-Filtering-Correlation-Id: 82b2f110-28e2-4543-2691-08dadd365224
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kHbaPcjOAmwBndkhEvz/+rxQ0K5hOY2kxJgyZQmzEAVQh0eVmwMYOWKrtEM4bBu2hx6vpjmku9pILSp4r4txa4e36Hfv0mmgLSlnBDBN1YHpOzpo/3/0IIEVKKBqdlvf7o9Agq/xBm7HQah5D2BJlbEJhFs8WKJtRG/tL+syhiLt01J3QyZuL8B3WE8tj9/JghuurNwEhBlzZdjWYaRkcQpySVixMMMNjGb6AYvxlsTFHDYxmZ1aBjmWZty4ELZj35qGRam2cgYO1wA7FmsDidhozm6C2Xm1vedKSdkBYhqAVwDBFYk9NahswouReeIiWnhofbC2Mw8Ul8SRMOe8YRCrepeNYXNBtSuZ6ivcWWvLWuucX4IVVuS3j1Y+ZTClWKyt6GlW4To2G6la6i/ycO3wGK0/e8JCSrZgXlheS1fQ/NmP7z/x38edTk5c+zV0vKRm8R3od5BjNW8UNSTSyjhjvKAVOo9km2hN0LQienu3N9IdM7k99Epq2IgneqNj0FV09gzT+whe74woCYD2rV8lKeLMdYnomGMN4hiJg+yaInTWS3jnHaYtDes7pRUpLVSRxasdGaQkVAXtytn6uxhc2pO5khQztQU+ES93dPbdTzLJjdDRvWBlLWA5UXz8uUD7I+w4vZ5uEKCny5hd5utgH1Tba9iGs9ujDUdyyeibXH5zIUfAKmuCp4kNOso1fEynWRpmSACE5bMpHi0k4iVZx3sKRXAOgk6VxaTUu/I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4684.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(376002)(346002)(366004)(396003)(451199015)(2906002)(316002)(31686004)(86362001)(36916002)(186003)(31696002)(36756003)(44832011)(5660300002)(8936002)(38100700002)(4326008)(66556008)(41300700001)(66946007)(6916009)(66476007)(478600001)(26005)(6506007)(53546011)(83380400001)(2616005)(8676002)(6486002)(6512007)(6666004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UVVyOCtaYUVhTmNyZ1FpOGxVbG95OFdBSTNiOXZsRkVjRmxxOGx2ZXhLWXVk?=
 =?utf-8?B?REE4dXNKL2hqOU9WRjVPNk8vTXhmMFRFRHFrSlE3emc4Q0JCYTBtU1YwNDNw?=
 =?utf-8?B?N1pDOExPL1MyVHQvNEJtaHpBMURGcTgva2RVNFZFcmp6M2g3UzNhOFJyTFE5?=
 =?utf-8?B?Q2JLeWJIWnVZdTBua0ZYNDVhUzVESDlpVlhwTnFNTTFuWkdNQTJWWXlxakp6?=
 =?utf-8?B?VUFKUUtzaGNudGFJQTQ1c3N3SWtMRm1uVmtMbUF3NkZRR1FoU0hXeU5xdXBy?=
 =?utf-8?B?dUoycTc3TFVXNmdleFU4OGRsbXZhWk9uVWp4cU5nUVdTS1ppWkRRRk5xd2tW?=
 =?utf-8?B?L2JpMWVjck5OL1ZZTXF0UjFOMHdxWlU3NVByemtZY1MzQnZrdUw3eWVpeEFC?=
 =?utf-8?B?YXdURmMrWFhIZm01MnFPUlRrc1hSVnl1MENjOE1Na0VUYnFHVHd2ejk0YitG?=
 =?utf-8?B?WDVTOUhVTmdqLzFsRDRMMVF3WmxlRlVnK3FCV0JUeVpha0N6Tng5M010cFFC?=
 =?utf-8?B?UHYvekRMMXVUYjhRNEhydGNCWlRGblplL2d1ZFhLZWoxdk0rSnIvQ0liT3Vj?=
 =?utf-8?B?L3A4OXJoZ08xeExjNFlnK29rZU5oYnE2eDRndWlmdzlqVTlVaElVYkxZSW5j?=
 =?utf-8?B?ZDV5MFgrUW5LQUFaOG9FODVpWFhZUFdwemxzU2hSUEt5ZkdBSmRHek5KUkpa?=
 =?utf-8?B?cTVyOHNsSmxUb1R0bFNRMEsxa2tqZ0N6elFaZEd1MWREYXRIUU1pZUh1dlpS?=
 =?utf-8?B?SEcvb1E4cnhZU0R1QktkL2xvdVFEWi9zTzA0UVBvTk5GV1NMWUFMNnRzZGMz?=
 =?utf-8?B?cEE1dUNRTkFPWG5EUGI4ZEdnaThRd0l0eTJ0d3pYVHI3SFRrWUhkbXdvSGZ1?=
 =?utf-8?B?NVloZnA0WFJNYkVuOXc5dUtRbkFlQ0hXUXZxUUxKWTdsOStKVlVhTVJGeXVE?=
 =?utf-8?B?SHovRnRkV1pEamhjbDRLYUdocGp0T0JsQXBGTHdnUURyRnNFQXRTVTVNK3JJ?=
 =?utf-8?B?RnZreXdwSk9tdEJTZWtQVUNJT3E0UE9XV3I2ZUw4OEVtelZMNEtmdlZrYith?=
 =?utf-8?B?b2VUZEY1MGNONzJHYTlRZ0toTklKY1BxTjA4RmJHM21lblZUSEEzQ0d4WWdS?=
 =?utf-8?B?UUVEQzdnRnJRMHB4RmRzeEZrUzN0bXVRMFlTVk5mRG5wL3llY2R6YTR4Z2tI?=
 =?utf-8?B?bjNSNUphTmsvN3hmZG9zb09EUmpIS1N4L3hRaFR1WEZTTEM5a1dDRExYMWdZ?=
 =?utf-8?B?bEhoSEJXM0x1UGowRXRhajlyenZuQXhoYjQzcG9DT2x0cENvZ0t1RjlJWmNp?=
 =?utf-8?B?Ymp4VTZKTWRKWW43T3dwRW84WStpT1FoMkFzdmZ5c2hrbFVSL1dzZ2l6Mkw4?=
 =?utf-8?B?NEt2QTFJM293YTcwL0hqUTlvTitWYkpDTlhvSW54VytwYk9UbG8xVXI5MU1v?=
 =?utf-8?B?UXdyY2lPK09VOHBlbGZBaE1ETkpKd2FiNnR4TU1nV3M1dzl2Z2p1ZVdpSHZp?=
 =?utf-8?B?MVF1RnQxdnNqNDZWUzNDUVYzRUc1VDNjUHg4akRsdTRnREJudGtlQkRaMEx1?=
 =?utf-8?B?UnN6UEQzUHJDUTk5d1YvbmNCN0RsRGZKMXVXbm13bW1DK0poMVNsQUZnTXRM?=
 =?utf-8?B?YUlrb253SjdMdWdSUVlKb3psRUxlMjZmbFkvRzZub3AybGl3cnNZOFFGZ3Jh?=
 =?utf-8?B?OFZmNjU1M1NwTjRvdXlWSHowcVc4SG15QmpBelh6Q1FndFlaaDQ3ZzVoTHZl?=
 =?utf-8?B?WXIrY0RKY01pQXVsN3U4dHNKMDB1b0JSd3E1Y1dnbllFUFI5aWJscDJ1UWx6?=
 =?utf-8?B?c3FiZC8zdld0cUdic1krZjBHeHB3djJUUVJMN2JnNjNIVnpKSG9Nc0V5b1k0?=
 =?utf-8?B?dEcraUtudXFkZUhoa0RrajNCMzR4V1UzcmlmVzRKZEdvMEVaa2RBSnpweFMr?=
 =?utf-8?B?czNXd0h0SlUzN0o5eDNNWnJXRVIzOU5YalgwaW1SMjB1OWh6Q2pZaWVRSm1H?=
 =?utf-8?B?VVZnN1RwcUlwUzlCa0NBdVF1VHpHbVM5cFJlTnIzNlRsMS96REd3bDd0N3Nn?=
 =?utf-8?B?V3UrZkdIMVJkdnZWbWVxaFZldk5oeFZ3ZjRiSnJZOFQvV210SUV2TSt4Zk9Y?=
 =?utf-8?B?TGtqRlNYSUx2SElzSUU4emlySFRBVzFYOGdMNHppRU9ZWEE4YjdUMVRjZ0pU?=
 =?utf-8?B?dFE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82b2f110-28e2-4543-2691-08dadd365224
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4684.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2022 18:17:41.5229
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /ks17tqkpT4OXu+8G8sQ+HXWDPhPTE7CJveUXHIJWzbWAN7jMKxMQrdGRo+cHjfWcpRorYU/DSMzEwyL2wgwYXKEgvxM+69yfksO4xYM/fI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7312
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-13_03,2022-12-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 adultscore=0 bulkscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212130160
X-Proofpoint-GUID: zuo-wT0E4xUVwqtVZyro-eexZMKXBg1_
X-Proofpoint-ORIG-GUID: zuo-wT0E4xUVwqtVZyro-eexZMKXBg1_
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/13/2022 1:02 PM, Alex Williamson wrote:
> On Tue, 13 Dec 2022 07:46:56 -0800
> Steve Sistare <steven.sistare@oracle.com> wrote:
> 
>> When a vfio container is preserved across exec using the VFIO_UPDATE_VADDR
>> interfaces, locked_vm of the new mm becomes 0.  If the user later unmaps a
>> dma mapping, locked_vm underflows to a large unsigned value, and a
>> subsequent dma map request fails with ENOMEM in __account_locked_vm.
>>
>> To fix, when VFIO_DMA_MAP_FLAG_VADDR is used and the dma's mm has changed,
>> add the mapping's pinned page count to the new mm->locked_vm, subject to
>> the rlimit.  Now that mediated devices are excluded when using
>> VFIO_UPDATE_VADDR, the amount of pinned memory equals the size of the
>> mapping.
>>
>> Underflow will not occur when all dma mappings are invalidated before exec.
>> An attempt to unmap before updating the vaddr with VFIO_DMA_MAP_FLAG_VADDR
>> will fail with EINVAL because the mapping is in the vaddr_invalid state.
> 
> Where is this enforced?

In vfio_dma_do_unmap:
        if (invalidate_vaddr) {
                if (dma->vaddr_invalid) {
                        ...
                        ret = -EINVAL;

>> Underflow may still occur in a buggy application that fails to invalidate
>> all before exec.
>>
>> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
>> ---
>>  drivers/vfio/vfio_iommu_type1.c | 11 +++++++++++
>>  1 file changed, 11 insertions(+)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index f81e925..e5a02f8 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -100,6 +100,7 @@ struct vfio_dma {
>>  	struct task_struct	*task;
>>  	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
>>  	unsigned long		*bitmap;
>> +	struct mm_struct	*mm;
>>  };
>>  
>>  struct vfio_batch {
>> @@ -1174,6 +1175,7 @@ static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
>>  	vfio_unmap_unpin(iommu, dma, true);
>>  	vfio_unlink_dma(iommu, dma);
>>  	put_task_struct(dma->task);
>> +	mmdrop(dma->mm);
>>  	vfio_dma_bitmap_free(dma);
>>  	if (dma->vaddr_invalid) {
>>  		iommu->vaddr_invalid_count--;
>> @@ -1622,6 +1624,13 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
>>  			dma->vaddr = vaddr;
>>  			dma->vaddr_invalid = false;
>>  			iommu->vaddr_invalid_count--;
>> +			if (current->mm != dma->mm) {
>> +				mmdrop(dma->mm);
>> +				dma->mm = current->mm;
>> +				mmgrab(dma->mm);
>> +				ret = vfio_lock_acct(dma, size >> PAGE_SHIFT,
>> +						     0);
> 
> What does it actually mean if this fails?  The pages are still pinned.
> lock_vm doesn't get updated.  Underflow can still occur.  Thanks,

If this fails, the user has locked additional memory after exec and before making
this call -- more than was locked before exec -- and the rlimit is exceeded.
A misbehaving application, which will only hurt itself.

However, I should reorder these, and check ret before changing the other state.

- Steve

>> +			}
>>  			wake_up_all(&iommu->vaddr_wait);
>>  		}
>>  		goto out_unlock;
>> @@ -1679,6 +1688,8 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
>>  	get_task_struct(current->group_leader);
>>  	dma->task = current->group_leader;
>>  	dma->lock_cap = capable(CAP_IPC_LOCK);
>> +	dma->mm = dma->task->mm;
>> +	mmgrab(dma->mm);
>>  
>>  	dma->pfn_list = RB_ROOT;
>>  
> 
