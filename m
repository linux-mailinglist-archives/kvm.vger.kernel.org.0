Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB2C46034FF
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 23:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbiJRVcW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Oct 2022 17:32:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbiJRVcU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Oct 2022 17:32:20 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85FD1AC393;
        Tue, 18 Oct 2022 14:32:19 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29IKwxr9003418;
        Tue, 18 Oct 2022 21:31:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=MTKmDEQMgT1QBQjURuzrHNqaN4ojpag1KvSK9jKpfR8=;
 b=VN9bcaORrulasP9D61rxzpVxADJBwDevZ/ZYhj3qnSl8Yccyr413YEqnhB6o4Yk4AOB3
 dZJStn38mDOU3dcA/MjCsyb8O+yTR2i2M49ONt/Qr/Bgg49NK33ux3q+2OIwlvlVfwhr
 aiTd7gUNaSRtesxifxKsJ9f8fumvAvsaYvtb35l9ysbmgLwpbRfWnLyzHLeDeDYOL9Iy
 JnpnFPQ1hwft94EhxcojtESxubJ5aDA7v8AUkmgHzjyYMpEL1nfz3xZIa/2mV/b7YZbI
 Liagf+vXomy57h6jGVbYr7DPNmgjUP5+dV/qFmBUxXnZS0F5cBG/tiDK2/P5xnqqHnqe 4A== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k7mu00abb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Oct 2022 21:31:32 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29IJ00K7016750;
        Tue, 18 Oct 2022 21:31:31 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3k8htgmwkv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Oct 2022 21:31:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VRoVRS2XbOvu88v5cncykjqHwH7aB3LHDSQ1yMOUdnGg6qj4Uvi4uZ/c2U9WGaRpGNDoiQ7ngk9wH4xVbh2vOSbeW4aPQ030/SyvR3YwD3J+LaPta0lYa47pTpKLN9lsQPY0wRjj7yAhbA41pbAaMCTENuje8ud2NcGUYN/6q7Yz4wfeh/d+KL3jA4fEXp+A/CrnwY/LhjB7pT5H1AX2xY3za4ZwLtQaNTABBVc3hGmQ69u59ttAVQKIg+UlMckBCwy1LbrE0fgP5xNpB4dHIf4cGjIwFqezTcWwmjQ9gZorZ+BvBWB1QHxF6Dm5K7Hz6+lKoBPNObWZay/qzio6LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MTKmDEQMgT1QBQjURuzrHNqaN4ojpag1KvSK9jKpfR8=;
 b=TAIig1V+C2SU7NVj/RQ+y8S2sfO+uUxMB+ohShR+p03L0HNbrZeoZlucxuIj0qP1gswlWBJ+youF8Cro/2lYMPeCePjoNuMe1zcEqJbMCltOtSmq+4JVM+w1EAElM3kxMJIDk3w9WJzH5wBYkO+0F0QREgTj6Cxt0G4Dar1M4l1y/zVf4HLOz+SUdD7RjeflvSfOcOLuH9e5N5inz9PX85M504VE7xmIdgDYbRZtPgPYLmkrIN2qx+zkZCxTO1gMu58Ly6z+ZV0+n06mjaDYnZUGNLZeJD3NQc4v3BHgNlQxTxvprpF7If+f84/+ze4VjzKOfRqEt1+IZrCB3RFcNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MTKmDEQMgT1QBQjURuzrHNqaN4ojpag1KvSK9jKpfR8=;
 b=mh+znwV4JUJ1htNZKQHrS9bItYhDLSiTOGhtH3ZguxRxEBAucahNcDV+hdc19vJuvwy9BAyLJe0VUM9dzPy/hCI5NlstaHMGNkCAcI6EMxd5cuMt7YvUILwvX12dfhdnrgJ1jVONDrmaHkVX3jT6yDV4SaBAa8/Kz4dpxqtho0A=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by PH0PR10MB5820.namprd10.prod.outlook.com (2603:10b6:510:146::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.29; Tue, 18 Oct
 2022 21:31:29 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::acd:f6fb:e646:9ff2]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::acd:f6fb:e646:9ff2%7]) with mapi id 15.20.5723.033; Tue, 18 Oct 2022
 21:31:29 +0000
Message-ID: <0088a5f2-ec17-a967-27e5-342e97eafe11@oracle.com>
Date:   Tue, 18 Oct 2022 14:31:25 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH RFC 1/1] perf stat: do not fatal if the leader is errored
Content-Language: en-US
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     Namhyung Kim <namhyung@kernel.org>
Cc:     linux-perf-users <linux-perf-users@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>, joe.jin@oracle.com,
        Like Xu <likexu@tencent.com>
References: <20220922071017.17398-1-dongli.zhang@oracle.com>
 <CAM9d7cj8z+ryyzUHR+P1Dcpot2jjW+Qcc4CPQpfafTXN=LEU0Q@mail.gmail.com>
 <db44de92-381c-96fb-20d8-883305c214f8@oracle.com>
In-Reply-To: <db44de92-381c-96fb-20d8-883305c214f8@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0003.namprd03.prod.outlook.com
 (2603:10b6:5:3b8::8) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|PH0PR10MB5820:EE_
X-MS-Office365-Filtering-Correlation-Id: cae6089a-9a68-4572-ca48-08dab1501e82
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0hxipxVYCkCmZMOXW1ZwvLYPr+3xu68Q4rUrYlwlzW+aksMILgGCig3qylkQtTDNfMhRQmWT+N6oLL2I6fLYxhgWW/d47+yOvxAIax+Ozai7IL/yQbBAuK58Jsy7PbUlLej2VcJkqAIfEPWwHNiyvBOqwGKgaVpgTdYFgb+vwSnyasnXwsl4gy1Vr+Yzq2mx4S6buiLufiJgbkwBX8Odk+D4nqcJjUxnFXbswLjDzcMXDL0eWLXieqt0YFdLKvsNPIs0Rna+LRY+uyAmlihwow2Pr9YOvJYBUYfqfDkBEmjHxt1wDQx1v5xRgztrCbdnG1vfBzgbTR6pcTG8CsVARPdQ3/p/RBRRC58x+t11aLM7t4tQRP8jeQjUXyJmWiHYc6IRoUfkZfnezfmeerb60cyPeEEAcV+C0Jpg/36H17Pxjjr+mmsW6hT4YZym0flJ145R0Y4XeR6Tyd2NgYKaFwSoDWMkmGSDlFSH1TJ6zdKgF1f7yZ0wPf5+joBBc/z3VBf6ZmiY1vnuS3EChge0WlHjVsClglCGMnix1xXvV3s6KXJTp5MnopBCwZvbvezuWZ7GTnd6a7gkoK4MUlOJNqdBjFnsZWnGLPoosLhRizP2aFw7q7rkFvOhhMeJ6VDFubcUvteOKMoIAmgW/ks3JV/mwGDzEVCVp/os1loxp32fpsWq4HzTDT4hB3pQYOedh0W7EyXGCcrJFWNCd7adXXppw66BM4o7EdMHa+5lJutDCZUq70RagBRPEPtm7aX4sPd8P0oadngJND7lPm7EwxFNHEXUueim8d+NnQNEDtc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(366004)(396003)(346002)(39860400002)(451199015)(6512007)(478600001)(6666004)(6506007)(2616005)(53546011)(83380400001)(186003)(5660300002)(44832011)(7416002)(54906003)(6916009)(316002)(6486002)(19627235002)(4326008)(41300700001)(8936002)(66946007)(66556008)(66476007)(8676002)(31696002)(86362001)(36756003)(38100700002)(2906002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S1AzYVJUT3BKWnFnNVdzVU13OHFnN0RVSWhrT3lNRGdwWU1VeEJuU01QaUtJ?=
 =?utf-8?B?YTlrS0JGTjNZQzZ3LzNvYU52b1hXWXIra2FaNXlrS0VJVFk3R3J6Z3haeTht?=
 =?utf-8?B?c2NXYjIzdzJYVXVIUldwTXhzTmhFd3VOYUdlcnJYNUk2VUorUzYzOWVybmdF?=
 =?utf-8?B?OHY5VDNRSHZlSDZkRFhxVnJlYkJuUW9oZ0NpcW50bnpGVzd6QWVhTStsR3pk?=
 =?utf-8?B?Z2F4U3J2TnN3b0pLNWM3Nk9QVTFESkUwbXdCYkU3QXZ4RDlmOHNmNkhjbnh3?=
 =?utf-8?B?RWVCbDREWVVTQW5jclNDOHRrRTdMc1poNW4vQmVJa0xjS0c4dkkvaklEaFB2?=
 =?utf-8?B?L3JyKzloaWNFRzVIOVBZcmZQb25VZjhLUzVkeU9CbE94OVFCeUlOcGZqMUxq?=
 =?utf-8?B?bEhNc1cxMFY3amRLQTBRVS9UYlFjZEFZcTVZYWpSWHNPa0lqTXpQS3FOK05J?=
 =?utf-8?B?YlFTbXdHUTF6ejBKY2NpaS8xR2hhUGpzckx0RDAwb2xCK01WaTk4dkY3dGE5?=
 =?utf-8?B?WnZVRGIzN01yaFYwTGo4dzNyUWFKSzhLeDhNYnhnMDlsTmZ1RUhFTTFjcHdW?=
 =?utf-8?B?S1pzSjZjL1hGVkNaRzVVTCtNYy80RVZXUHZrNTh2a0hVQjJIM1BoZmZuOHlU?=
 =?utf-8?B?Z0hUTVVOcGlRSVk0Nnl6SmJGZGdXaktQVWczMkZYdExSTm1qQWRqZlBXYUZs?=
 =?utf-8?B?OXJDRVJGZnlRNGlqYkZOREU2K0s1dGRHN3dsRUhXYkZBTllMaFVFNngrcHlE?=
 =?utf-8?B?cVBZUng3dmptN0llSDE4L2M2dm9UK1hQam9PbzkwaVVGeDdOczlzS1k5N0lP?=
 =?utf-8?B?di9TcWRoaHdsR0tWR3Q2aFFKYUtZUmR2Wjl2SVVRcFJybUNJc1pEamRGUkNv?=
 =?utf-8?B?YVBQdVhQU2EyT2xHNnhCdE01N0dyWFNyRWhyZlBxSmhMUVlYMExZUlpQMjBi?=
 =?utf-8?B?TGhqdHZiQ251dGppZFVRb0pHY0lYZnlVZEhYOWcrY0ovOExtYmE1Q2h3R2lF?=
 =?utf-8?B?cHhPQUE4QkYzeHpWOGlzdTBQOUk2OEZWT293UWNUbXU0UzlxZGVmcUprZmx0?=
 =?utf-8?B?OXFTcjZvbTVIeXV6eEsxRE05VFZLbWw4ajlZSUhrdHFiU29QU0xSYkExY0NX?=
 =?utf-8?B?dGIzOUYzYncyMWcxblVUbEFUNmFjWExCU0dmLy9zRVhRbFE1TEdoUVA2Wjlr?=
 =?utf-8?B?OUh5SmJaalhrT2dSdStzcWMvQnRYT0VhUitNQkU4dHhRWEFORGRQSVV0NndU?=
 =?utf-8?B?TlY2eVJZWm9CU1RXTFNYeThlQ21RTThtVVhFR0tXMm0yS3RFQ3JRcjBkWWha?=
 =?utf-8?B?ZTI2K2txVGd6TEJ3bnRFRzgxeWFOV0VQM0xFZEdocDZJc1FWci9OMHhoY1ht?=
 =?utf-8?B?enpMdFY1WnROWlROK1RQTGE5N2xWL2hiSHR5QnpyVllRSGtTV3BtVGROZTRw?=
 =?utf-8?B?VTZJTTJ1Y3FTRTlOTCtiZXNFbWsyeUVkc2FWckZPL0JUQkF3TjRQS2JtaENu?=
 =?utf-8?B?VXlXdHVOR2h2cHhHMFZ4c2oxNFJrZ3R0MFcrWVVMZGpRcENWYUFUU3BRSUxl?=
 =?utf-8?B?MVVMaDZIVXlzVXdvSDJvNk9mUmYrWlZIaGlWZFRBVFovY3ZCWmJzb0RTdThO?=
 =?utf-8?B?N2hWMm96TTRTeWNpZVFvejhjRjZVWHVrdWpPamx0MGpJOXBDYUxXRjlkZzV4?=
 =?utf-8?B?R2RCemdjcEdMc1JTYTVleDJVb0h0K3ZBNVFQTEFObEgrNW4rTDM4TENlUVcw?=
 =?utf-8?B?U2ZLT3hrWkc1L0N4ZjZMY0dOM3dqaDF2SlJKM3NFZWs5MHluYnFoRUluYjd5?=
 =?utf-8?B?emZOWTg1WmhMMGt0YUk4VjNENmQ0d0RFV3hPemlYSHh4ZHpCNVpvV3IxOWQv?=
 =?utf-8?B?QkduamxxVG5EUTRyaSsweGVsTHZnY2EvZDJPSENFTG8xZVQ2Z2ZydnYrYllh?=
 =?utf-8?B?K0RJRTM5MXBJMDhaVVZicjNxWUZSTEhUczNWZUFtY1A1V05OcGRHdkhEclZR?=
 =?utf-8?B?dExVOC83alNBcDhJb3c1N2U0eFdJdlE1ZEQzNGdEZmwzdUN4aWN0NXlqdDlP?=
 =?utf-8?B?Nm8reEFRbE1jaE93OFBMaXZGa1NldXQxVGFGTHd2bzY1MGM0dUFRZHNFQ2U3?=
 =?utf-8?B?bE92bStnZEYvcS9kOHE1TjEwdFJiMkRFSUR2SDIvZnUxNnIzRVN6RW8waysw?=
 =?utf-8?Q?rBG0vHsarR5u4LCGcdJvuQg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cae6089a-9a68-4572-ca48-08dab1501e82
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2022 21:31:29.5609
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7UmPPnCiOtcuTYD4l7xHgZm69L51MRTNkB1X3P0rO76/hpBXVj/8LOO5x/rzIlIoeXvtZQQPGUhJ+cgURRpGFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5820
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-18_07,2022-10-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210180120
X-Proofpoint-ORIG-GUID: AezTlMb-Pk5YhgFM5X1NdRyx3JqVFPNL
X-Proofpoint-GUID: AezTlMb-Pk5YhgFM5X1NdRyx3JqVFPNL
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Please ignore this email. I carelessly clicked unwanted buttons on my
Thunderbird client.

Sorry for spamming.

Dongli Zhang

On 10/18/22 2:29 PM, Dongli Zhang wrote:
> 
> 
> On 10/14/22 3:16 PM, Namhyung Kim wrote:
>> Hello,
>>
>> On Thu, Sep 22, 2022 at 12:10 AM Dongli Zhang <dongli.zhang@oracle.com> wrote:
>>>
>>> Add kvm@vger.kernel.org as this issue is in virtualization env.
>>>
>>> The topdown metrics events became default since
>>> commit 42641d6f4d15 ("perf stat: Add Topdown metrics events as default
>>> events"). The perf will use 'slots' if the
>>> /sys/bus/event_source/devices/cpu/events/slots is available.
>>>
>>> Unfortunately, the 'slots' may not be supported in the virualization
>>> environment. The hypervisor may not expose the 'slots' counter to the VM
>>> in cpuid. As a result, the kernel may disable topdown slots and metrics
>>> events in intel_pmu_init() if slots event is not in CPUID. E.g., both
>>> c->weight and c->idxmsk64 are set to 0.
>>>
>>> There will be below error on Icelake VM since 'slots' is the leader:
>>>
>>> $ perf stat
>>> Error:
>>> The sys_perf_event_open() syscall returned with 22 (Invalid argument) for event (slots).
>>> /bin/dmesg | grep -i perf may provide additional information.
>>>
>>> This is because the stat_handle_error() returns COUNTER_FATAL when the
>>> 'slots' is used as leader of events.
>>>
>>> There are three options to fix the issue.
>>>
>>> 1. Do not expose /sys/bus/event_source/devices/cpu/events/slots to
>>> userspace so that pmu_have_event(pmu->name, "slots") returns false.
>>>
>>> 2. Run cpuid at perf userspace and avoid using 'slots' if it is not
>>> supported in cpuid.
>>>
>>> 3. Do not fatal perf if the leader is failed. Do not create events for an
>>> evsel if its leader is already failed.
>>>
>>> This RFC patch is with the 3rd option. Would you mind suggesting which
>>> option is better?
>>
>> Sorry for the late reply but I think option 1 is the way to go.
>>
>> The option 3 would be a transient workaround and it would affect
>> other events too.  If it's really needed, I think option 2 is slightly better
>> than option 3.  Or, we can add --force option to skip non-supported
>> events explicitly.
>>
>> Thanks,
>> Namhyung
>>
>>>
>>> Here is the output of patch.
>>>
>>> $ perf stat -v
>>> Using CPUID GenuineIntel-6-6A-6
>>> slots -> cpu/event=0,umask=0x4/
>>> topdown-retiring -> cpu/event=0,umask=0x80/
>>> topdown-bad-spec -> cpu/event=0,umask=0x81/
>>> topdown-fe-bound -> cpu/event=0,umask=0x82/
>>> topdown-be-bound -> cpu/event=0,umask=0x83/
>>> Control descriptor is not initialized
>>> Warning:
>>> slots event is not supported by the kernel.
>>> ^Ccpu-clock: 62021481051 62021480237 62021480237
>>> context-switches: 437 62021478064 62021478064
>>> cpu-migrations: 17 62021475294 62021475294
>>> page-faults: 12 62021471925 62021471925
>>> cycles: 15662273 62020909141 62020909141
>>> instructions: 6580385 62008944246 62008944246
>>> branches: 1446119 62008855550 62008855550
>>> branch-misses: 30970 62008643255 62008643255
>>> failed to read counter slots
>>> failed to read counter topdown-retiring
>>> failed to read counter topdown-bad-spec
>>> failed to read counter topdown-fe-bound
>>> failed to read counter topdown-be-bound
>>>
>>>  Performance counter stats for 'system wide':
>>>
>>>          62,021.48 msec cpu-clock                        #   16.006 CPUs utilized
>>>                437      context-switches                 #    7.046 /sec
>>>                 17      cpu-migrations                   #    0.274 /sec
>>>                 12      page-faults                      #    0.193 /sec
>>>         15,662,273      cycles                           #    0.000 GHz
>>>          6,580,385      instructions                     #    0.42  insn per cycle
>>>          1,446,119      branches                         #   23.316 K/sec
>>>             30,970      branch-misses                    #    2.14% of all branches
>>>    <not supported>      slots
>>>    <not supported>      topdown-retiring
>>>    <not supported>      topdown-bad-spec
>>>    <not supported>      topdown-fe-bound
>>>    <not supported>      topdown-be-bound
>>>
>>>        3.874991326 seconds time elapsed
>>>
>>> Thank you very much!
>>>
>>> Cc: Joe Jin <joe.jin@oracle.com>
>>> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
>>> ---
>>>  tools/perf/builtin-stat.c | 8 +++++---
>>>  1 file changed, 5 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
>>> index 0b4a62e4ff67..1053cf0886c0 100644
>>> --- a/tools/perf/builtin-stat.c
>>> +++ b/tools/perf/builtin-stat.c
>>> @@ -762,9 +762,7 @@ static enum counter_recovery stat_handle_error(struct evsel *counter)
>>>                  */
>>>                 counter->errored = true;
>>>
>>> -               if ((evsel__leader(counter) != counter) ||
>>> -                   !(counter->core.leader->nr_members > 1))
>>> -                       return COUNTER_SKIP;
>>> +               return COUNTER_SKIP;
>>>         } else if (evsel__fallback(counter, errno, msg, sizeof(msg))) {
>>>                 if (verbose > 0)
>>>                         ui__warning("%s\n", msg);
>>> @@ -843,6 +841,8 @@ static int __run_perf_stat(int argc, const char **argv, int run_idx)
>>>                 if (target.use_bpf)
>>>                         break;
>>>
>>> +               if (evsel__leader(counter)->errored)
>>> +                       continue;
>>>                 if (counter->reset_group || counter->errored)
>>>                         continue;
>>>                 if (evsel__is_bpf(counter))
>>> @@ -901,6 +901,8 @@ static int __run_perf_stat(int argc, const char **argv, int run_idx)
>>>                 evlist__for_each_cpu(evlist_cpu_itr, evsel_list, affinity) {
>>>                         counter = evlist_cpu_itr.evsel;
>>>
>>> +                       if (evsel__leader(counter)->errored)
>>> +                               continue;
>>>                         if (!counter->reset_group && !counter->errored)
>>>                                 continue;
>>>                         if (!counter->reset_group)
>>> --
>>> 2.17.1
>>>
