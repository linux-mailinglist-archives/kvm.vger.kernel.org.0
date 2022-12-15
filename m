Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9E464DCE7
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 15:33:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbiLOOdg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 09:33:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiLOOdd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 09:33:33 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F47B2E685
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 06:33:32 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BFDjTjb031229;
        Thu, 15 Dec 2022 14:32:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=nrdM9Oo3YAdE6FN4dPCiMdu0ZK64DUT/MC4UX8gxgM4=;
 b=P5SGzuhyyMbJIPw5ve5nbidNaXc7K1nezrGQ8jSHkK9DMGoQzkPocvqXs5p6sWhxPB5n
 HfzeWpTv7fdxpla//joTuCarxhmoYSaORhKj0c6zlDmLYDsR4mOu1kBNNOAt4dPJSrO1
 KtzKXnTTbNZI1K2KcomRgquJjBLAXgizTS+f4whyNaiT+WatrLkN2Tnbd4qiXVB6iX5x
 T0csUrKfaOTjXMy02uFVWZ1kw/Wb/2ZAtMo4Zclan09vYubV8vB2wTQ76YLeA1Blin6T
 Poyz6Trnq1SQR1MeBIxmS/hIK1Y7ao5klrl058SR+T99ESkKpLSXOzH9YS6Dg6K/578G YQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyeww6ag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 14:32:44 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BFD5whr000427;
        Thu, 15 Dec 2022 14:32:44 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2173.outbound.protection.outlook.com [104.47.73.173])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3meyerrdft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 14:32:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YQvbTeRDHEaiBBrepQOv5vfUgJobEblmE6p3DqGob4RxhW/i3pzAgmv/vYn7TVvw+vzgEyixE/25oJx7qkHaUSuwlHVxBav35cRLxPNaeeIjmmDBJ95MS1DeRqomNsIZJtWm56jHkJhcB2oj6+7qUxYfCDNDomLN67jIDdeLGM9OUkW4/+w0zlQkUTO7CyLaAYBJtrQyXUT7JHj40SRzgY0uZliXSCWMPTT71ENH3Zvq+nK6ZKnAzRVppCNqh46wZTVU5hFzkQdRcSzdhS4uzJqYb0Mauw8aN/vjlvDcoDCsrPcdZt931BhHJQR4t2h1jHsEKo9wOs6ec+qHlou2vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nrdM9Oo3YAdE6FN4dPCiMdu0ZK64DUT/MC4UX8gxgM4=;
 b=EJS6TD8hZEkSUDQ7m54Q++STEsvb5HRWA7QEM3bD0h52pkz6dJ9s4sT/nIzSFHM/w5Bi7tEK2p7H9k777IE8aQKA1ztLC03XuAa1rr+qu2tnqGQeBwXUZMfC5y4NEK6nz+v7YWITi/j87iUysb89fbSLKRo9ZkLt7wyG8Xz7yiLLHr3/TYwU2dhsvdqzm0V+oOekdk2OP5Tp9nyWGgqaqTeYo1DbgGyTr8sZxK5k1M41eBPULeWeB0dqxChfXxv72gzKFytJpoGWMn1yi033aQZICa59U5NAeF1nYEKwMHTprv6758FMH7ROucJdnpg5t2SivObzkCzYVgUlqbiU7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nrdM9Oo3YAdE6FN4dPCiMdu0ZK64DUT/MC4UX8gxgM4=;
 b=VYj5op1wYOmua5GCq0sk5TIP0SWAyadX4Rum4XwSvly7xIWkYsGRUhyaLl23+sqyTffNjmT6VjyoZsZnLOocyqlQw5WxtJh/Ntq+GhoA5mZoWrdXG6+hMJT7lJ+1kTPe8YOMloOlo+9FkEDLPM2HpTzmUL5xBZ7ndSu0atKMaus=
Received: from SA2PR10MB4684.namprd10.prod.outlook.com (2603:10b6:806:119::14)
 by PH8PR10MB6600.namprd10.prod.outlook.com (2603:10b6:510:223::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11; Thu, 15 Dec
 2022 14:32:42 +0000
Received: from SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::3667:7f89:cdc7:9cca]) by SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::3667:7f89:cdc7:9cca%7]) with mapi id 15.20.5924.012; Thu, 15 Dec 2022
 14:32:41 +0000
Message-ID: <44b07771-4b27-4c5b-7361-04eb8549dac6@oracle.com>
Date:   Thu, 15 Dec 2022 09:32:38 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH V4 1/5] vfio/type1: exclude mdevs from VFIO_UPDATE_VADDR
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
References: <1671053097-138498-1-git-send-email-steven.sistare@oracle.com>
 <1671053097-138498-2-git-send-email-steven.sistare@oracle.com>
 <BN9PR11MB5276350404E2B74837416E838CE19@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <BN9PR11MB5276350404E2B74837416E838CE19@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0046.namprd11.prod.outlook.com
 (2603:10b6:806:d0::21) To SA2PR10MB4684.namprd10.prod.outlook.com
 (2603:10b6:806:119::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR10MB4684:EE_|PH8PR10MB6600:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d3d8b9a-12fc-4e6a-a0a6-08dadea938fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6O95a/v+4bQ1abm19Zo6FImoRfb2xD5Ncs1lYJCAGtzao4eVXnUBZneHp3CebUVwtkHmz4M/TmHaqILYIh3Sxe7B9e8YkZwJpHlfrESo6LLZxCXS/n0voFTcGpU0y7fAruP/3f0cqhdBEIwsIoK3XUoVpxmp4dfdXf0+WJzsaLEi7q3e2JBN8/WSNgiNrbafEWSGUjl2NP360t20OFnCAs5oK+BTg8FCKqXmb3RxgxM2fjbxvGMfpfeg7GO2lEBmuSOXqsuEPtx7JXwTk1sUA1dTVxfoAV/o8Xu3Jct3NF9AK6AReBU2pQEvhcXKWQql+gTcmhelnUmTC34roTCDs4sowsa5gdecsWXPkVEVtIf/SDCH1D/MzYhixdQPBfbArg60wihZRHjOsyztqpHvAyBw2xdSq9F2Z50bDxDYgx7olRPDlj8ZkRvOZJDkvYfMcRYWhyjeK+mrdY6UCa+zsuzDemMlcCjZSgexdIN/oP/qKABuYszBYf6bQ5BOqKv5I+i35T4CDBtDtzlpiWudzyX7Fv6lmt3WvqCqek1g7C+86oVo5LHbSFLBiTqsVov9Wxtxwv4jnAHdIcbS8zAT7uJhSI1FU5GLj5FYD9lLJX3Wn3DqcndvfSYkcFs6h1hxb95YmHNlqV/TJmn7hYXs2tP+1p+O6hsipwV7C+2uqWEGFvKUFgvj5+LaXNskZj03aZTJCQZike7ye8/RGAJp7ypUfxhEItkkiQo8kZbR3uQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4684.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(39860400002)(376002)(346002)(396003)(451199015)(36916002)(4744005)(6506007)(2906002)(2616005)(38100700002)(31686004)(478600001)(6486002)(6666004)(5660300002)(8676002)(53546011)(66946007)(66556008)(6512007)(66476007)(54906003)(26005)(186003)(41300700001)(8936002)(110136005)(36756003)(83380400001)(44832011)(4326008)(31696002)(316002)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N0FkWmQrZ3RHRGpjYS9MU3lrY1hKUFFmQXYya1VwSE16R3F2ZmRMbFdWRG5k?=
 =?utf-8?B?OW9rK3dGckR1ZU5SS2pqd1pFVjh0V1R2SlNTOVJ1Z3dndnZ0V3dGaHc0ZnRW?=
 =?utf-8?B?MGxQZ0V0SWtweFYzcVR6VHJ1bGVxUHpjRTdaWTJBWm5RNDYwa1M1Wjg3eHE2?=
 =?utf-8?B?Sm1FUThMQkZENm10ZjBFSVM3Vm1La29rUXZ2ZFRNcFpSWXNkeFlKRmg4WHdB?=
 =?utf-8?B?bkJOVWE4c0FRSVBoc3cvdDczeWVJVkVhRDQvbUxUL2dxbkRUSGFJSTRwdVZp?=
 =?utf-8?B?Ukl6VHAzZTI0NXpWdGp0M0NlTHlVY0xMdFZBM21ieW93Q0p5cG5ZN3pKVUsx?=
 =?utf-8?B?K0VRQzU3Y2FwTXNxTndDZGxtT0tCSUFUUnRpbFB5cWhxY3oyZ1p6Rm5NaHNr?=
 =?utf-8?B?Q1ltSmt5WjBMWkxzcFVYbWNzWXh4UFRmdzBnV1dXejVHbEl6b1lzT0tFNXRB?=
 =?utf-8?B?UGRQNjZWSlQrcTVHdnBSR0g4VVN1REx3SXY2N3U0UTN3eDM4K0d0Wjl0eml0?=
 =?utf-8?B?M2lhelJNcDVVS3dsWStGTWtIZG1XWTkzMTV6cXhwclRJRmZSa3pSWVVjVm9j?=
 =?utf-8?B?V2dLMjNyRWtjSmNudU9HTmlZcTg3dWtqVURHenU5alE5Y1BIdDlNUGtRNWxk?=
 =?utf-8?B?RFBybHcwQ2VER3QzSzQ0clY3cXRMU2NURVd6MkpHSVpvaUw5bHZjOXh1cnA0?=
 =?utf-8?B?V3R3U2xSeEgrUGdYbFQ2UzA5U3gxM05jcTNXL1FOUWg3U2VzZU8wVDl1OUZv?=
 =?utf-8?B?ZFpmWHBOU3RjTXNLSjBaWXBEdGgvd3NGVzEwRjNnVEVyQzU4cTJFNWJGWmJh?=
 =?utf-8?B?MmVVNDVqeUowK1cydWNySWJrcDhJcDZYdXVzQ0FoYkZ6b2s1L0paZktidUFn?=
 =?utf-8?B?eU9HNHg1RjFsYTBZWEFLZjVpSEdOWWlocE5DbHhzQTVuRWFzZXlqMUZtOWJ1?=
 =?utf-8?B?bEtIMHdaS29DdXE0a0NSa0xBZXlJZnVGQ3lTbFVIM1ZjU2NHU3k1MndDNXB3?=
 =?utf-8?B?eVNRNEx2U24wWTFTMEZ1TGxEdUFVbG8vb1JuNm9yeGUxek1FanZHUlM2QitN?=
 =?utf-8?B?bE8yWVJGUmwxbE9RS2hpMkxNcndDSlM3M0JmSEV2elQvcmFoQ0t6WjUrclZr?=
 =?utf-8?B?Zno4Ykl6Sk0waUxManpMWFBGU3QyTnNCcXU0eGhGRU1qTm91cU1XaExVSDZ6?=
 =?utf-8?B?UTc5U0hVWVFlRlJCeFhGVUs4YlcxUGVva0ZHTVBQaGc1eEM1Q1c3R0xCOXJ4?=
 =?utf-8?B?aVYzT0hqRXJ1dUFCWHZTZFZ5cmxpc0VBZXkrVDA2dTY1N1J0aFZqY3lkUU5s?=
 =?utf-8?B?WkJkVm1HR0FmaE9zaGxQbkROdUtQNWxpdC9pSUMyOUJseHcxMVlVcGx4NmxY?=
 =?utf-8?B?cDRSUWJDck52b05LeS9kMGo5OUZVZDlkNzRPN1V3eVQ1K3h0OGFaUHVPTmUr?=
 =?utf-8?B?Skd0T1BTRlFiR0JMTjhKT0ZTTHVEZWNoUllYSjZiaXR2ZmVTc3EybmdrVGJy?=
 =?utf-8?B?eWpDdmtMT3F1RGZ3KzhPNXNscndCTUlDSExEQ3ZwTklWZXRucXNSanJ4T05K?=
 =?utf-8?B?Mlh4bGZSenVlNUpzSU1jUWwzazF2Zk9RL0xhWEdpM0JENXVWd3htbDdJTWU1?=
 =?utf-8?B?SjAzZ0xYaWNXQWk4ejlueUFLRHlmLzc0SjFJY3lZYUNnL1R6M1pUWENzQ3E1?=
 =?utf-8?B?UGtvMXQ1SXNIa09zR3JDN2wxMWdhN3R6dDF6V2ZwdlNueDRHRUxRczcvWEkr?=
 =?utf-8?B?a0l2cmU4emh1WWpHblpEZDVnWDhZdjVPNjVvTERGUjgwWmNKK2sweWEyY1ZX?=
 =?utf-8?B?QVJKOXp2YWY3Zzdkb3h5MWlQVFAxNkk1S1liWXpJZWZNNThSK0VMeldEWTB4?=
 =?utf-8?B?ZDFJMFhhbDlOU3JDUlNSQ29OQ3pBQnozN2pVYmpKcUZjVm9halFETmVyanpq?=
 =?utf-8?B?bEYxY0dTZGt2Y2NDdHNJYmJTZC9kZk1Fc0gwNHdVdVMxMTNENHF5azAwazha?=
 =?utf-8?B?b1BFRlpFeC9ybXk5SUtGcmVpSy9uZFFEQ1hUam02ZlpJNjN6ZVpEMTFGeGk2?=
 =?utf-8?B?QmxhaHFzb2xOVHRZLzBySXJKTlZtazJEcTE2VEVzTm5qMGVNSnI5M3A5TGlU?=
 =?utf-8?B?QVc0dzRvVHpSTThEaFVieXRRTXYwdnhXMitGWk4ybytXQkVadm5sTEs0QjBh?=
 =?utf-8?B?REE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d3d8b9a-12fc-4e6a-a0a6-08dadea938fc
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4684.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2022 14:32:41.4671
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xABT3ggaAGqfNGoOCavGVXUHMEEmqteLwjgG+KUaZiLGtxwz+mQAKLES1U88BEcw7w8ncujfPbNtZYNLtThJBGG1P95m0hMScK+3AOm3Dbo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6600
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-15_08,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 mlxscore=0
 phishscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212150117
X-Proofpoint-ORIG-GUID: kwsi9HCG0n4L4e3pZ0vZgqIXHZShuiVi
X-Proofpoint-GUID: kwsi9HCG0n4L4e3pZ0vZgqIXHZShuiVi
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/14/2022 11:34 PM, Tian, Kevin wrote:
>> From: Steve Sistare <steven.sistare@oracle.com>
>> Sent: Thursday, December 15, 2022 5:25 AM
>>
>> @@ -861,6 +861,12 @@ static int vfio_iommu_type1_pin_pages(void
>> *iommu_data,
>>
>>  	mutex_lock(&iommu->lock);
>>
>> +	if (WARN_ONCE(iommu->vaddr_invalid_count,
>> +		      "mdev not allowed with VFIO_UPDATE_VADDR\n")) {
> 
> let's be specific on the operation i.e. pin_pages not allowed...
> 
> same for the latter dma_rw.

Sure:
  "vfio_pin_pages not allowed with VFIO_UPDATE_VADDR"
  "vfio_dma_rw not allowed with VFIO_UPDATE_VADDR"

>> +	case VFIO_UPDATE_VADDR:
>> +		/*
>> +		 * Disable this feature if mdevs are present.  They cannot
>> +		 * safely pin/unpin while vaddrs are being updated.
> 
> only 'pin' is disallowed?

Will edit:
  pin/unpin -> pin/unpin/rw

> Except those nits:
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>

Thanks! - steve
