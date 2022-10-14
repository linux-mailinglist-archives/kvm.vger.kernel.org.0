Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D08C85FF70B
	for <lists+kvm@lfdr.de>; Sat, 15 Oct 2022 01:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiJNXsr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 19:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiJNXsq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 19:48:46 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9496E9A2A3;
        Fri, 14 Oct 2022 16:48:44 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29EMcxmX014742;
        Fri, 14 Oct 2022 23:48:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=XSJlY+6m7hnf9fJ6U6SEGhSDwYSw2RdYgXYwRb71sGk=;
 b=v2nsmk7C3HVUXd1oBKDzkVsZN7yTle7PAwKyCPiLuPeHpKf+5bKryxjwMj8LqSuVfILY
 sK4qKwSYXavFepGnQkQgpaL76cmRPWqsXbMC4ibcSURbVOj2dvX/8e4rXaZbQ4XNDCZ4
 hXBxhTpoz9N4Jysg8TMkTXdfXGxtW+3sIUCLXHsUcYD/sDawBdWv3EycV2Jqr4OpQOC7
 inIIsFMHhAqbM/ZO76/fFIEyDLPMMXajhK4UHhx6BqBtlAez5ZrWT0ehBM3mtybSunoE
 b71kmLysEC/KPam2vM2COQ4xJdltFMCm0gaBnVwu2RBI5tpzGP1FQfSX8Hl0wEMv2UtZ pw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k7c5e8mmq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Oct 2022 23:48:00 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29EKBr6J034182;
        Fri, 14 Oct 2022 23:47:59 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3k2yn7qc1h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Oct 2022 23:47:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JK8lhIQI8ULRz/YGn7wHJhK114pxcvLWBS6LiF7sFQHj6vILz6MZY9F25MvijtznPMaQw/ZKixVA3zR5laq9jd6t0KRJY17qQ2gvocEh2RLmkAoyn6hIVgUvm1n5l13angeSpXfl3SMyH6KzzyVNJgM6k310jJ1Ngxh0+LNnTRrQQGLF0V5twCkqevUFamHO8QJ7zLkGtbwq3MNCNf5u/MV/Qzkof7jwZrG/NoQmGWa2VA8exXUkZBp7Vavopq3S7+Gpovs3U3GCgoYA8aAAVOspx8ogLOF8hriaMmEcfXqy2sd59dhDOmghkxnawmsD9ADC56xcJa2wckzIDOjp+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XSJlY+6m7hnf9fJ6U6SEGhSDwYSw2RdYgXYwRb71sGk=;
 b=IPFrJA0XqQT1+5f61bxmqfLLGM35HbUMwqoO+zDctkV1AaHugpvwjR+TdCRkriwcoFB0Qhgf8fNywKZvVz7wyNXOzJsTto99OC0BwBHCXz5boMvU8UasF80HKi/PgGcZ3tlbBbBpOJDd6jMsSIlCSfrhhOxDoXV2TBGmgZFxwlnOpmkHlYAy0T2pPU2IVojfGL7UozIQJFw10UhJcdp1tFWTFCJxvqcELx6s1HUWQ3zCOQ1AoXPDItMcna4IQUrDGJTRBfAvDK05PHBcqULMO+6BZ3mxyp9NL/D+cHgQqn+3tLx2UC/8yJqVieQTSGwDy/4A6oqWzd4c8nlh0uNFkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XSJlY+6m7hnf9fJ6U6SEGhSDwYSw2RdYgXYwRb71sGk=;
 b=uFStM8tG83LA4WK+coFJNRLioT5PUQSWTJVxOCraGP/bBBn37LkJ1xqek1P2e2e3O7kkHh3vLS9vbpMSTnhFiyGfuUzjSmOqB0nGTaXNTtfdG0FSrPB0rFiPf2nF5k4dRYB0lq+T0ozWXGG0WdBw92+6sXPsNmV8x+IxIndNLIo=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by CH0PR10MB5177.namprd10.prod.outlook.com (2603:10b6:610:df::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.29; Fri, 14 Oct
 2022 23:47:56 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::9ff7:d3a3:77ee:6344]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::9ff7:d3a3:77ee:6344%6]) with mapi id 15.20.5723.022; Fri, 14 Oct 2022
 23:47:55 +0000
Message-ID: <c4d56a1c-3880-3ec4-17e7-91d2d428a94a@oracle.com>
Date:   Fri, 14 Oct 2022 16:47:52 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH RFC 1/1] perf stat: do not fatal if the leader is errored
Content-Language: en-US
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
        Like Xu <likexu@tencent.com>, kan.liang@linux.intel.com
References: <20220922071017.17398-1-dongli.zhang@oracle.com>
 <CAM9d7cj8z+ryyzUHR+P1Dcpot2jjW+Qcc4CPQpfafTXN=LEU0Q@mail.gmail.com>
From:   Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <CAM9d7cj8z+ryyzUHR+P1Dcpot2jjW+Qcc4CPQpfafTXN=LEU0Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0198.namprd03.prod.outlook.com
 (2603:10b6:5:3b6::23) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|CH0PR10MB5177:EE_
X-MS-Office365-Filtering-Correlation-Id: fdea3f24-0b88-4183-85ce-08daae3e8429
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Wfl8pxCyJbqsRQOFY3p//To07k9ic3ehWXiCAZvD14nVljrwGHtUv4YQxx0bZFRcAUoGHj/Nz+JZSNEOKjLp9hZTja2I3aiJ4gmISci4jk1vVcYqB7fogYoA+bJNLC9B9+0EEG+UJTw1eu3gCyypnPyFFg1KcheQaQYni7pLoKgzzSLPHIgE8B7CHewntBnrbMSlKmeH/qk2wU7f1dQZpLnPvqMdStl8ZzBLnjBTq864z4+bDN1vrYvoKp8nbbpCuoibeswVUVgRn+UbluikIR4xl3draiCidK2oYK7JLaFjbcdjgQTmlMzl8EsBPKAlaBcF+HEfs+8fa/l84K+FSmYs7KWGwNNYUpXR9+qJ0YNBuvciDed8CXUl7gBqGgYeVMs8+nARMl2J7fU+TOR+T2mzNjGCzInBLOwQQk0XA74U+o6VMvQ3pAfiwON70Ua1gZImaaFQ8k/RqOcQhADabaJYXY+Hnx6kfb3+xmOB+5ZEkwGSQ427qXW+lCcoAPRN7yZsvcs6khv7C9Nnrr+VzlKTovEhfFGKrao0frTE01LqLPRnHXE0ue9meCGAFl/Nm1awis4tUzS3BxHU8RErfLVqxFPGfxB2/W/XTc4cWo01AXlZXr19lHvP+FseSm8Xez9PV1FtRoDLTkLaZIh0R4EMssWVWSOBdQdbZ5y8EIWidULYAsWQeq0AXAElbkW0g332mpTiDGbUpvayW+lIZMxlsjM/zkAZN5UqSHNZZn0xFiTYsapdFMmzFXEMnSYB02BivpMNWAoHXcWS7lAa8giY1B0ko3CadCMfjyLh6r0GshDa5p0Bg7QZPYDP2z3WZ5jTChkMlzpvDE4cED2c6YoUs1yo2BHq+CHqSg1mEEuhpG4tPehXdh14MuV/j7dS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(376002)(136003)(396003)(39860400002)(346002)(451199015)(966005)(66946007)(31686004)(6486002)(478600001)(83380400001)(54906003)(6916009)(7416002)(19627235002)(86362001)(316002)(4326008)(6666004)(8676002)(66556008)(66476007)(41300700001)(31696002)(6506007)(6512007)(5660300002)(36756003)(53546011)(44832011)(38100700002)(186003)(8936002)(2616005)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cExQR1pibjg1T0hReVVFdk55dmo2YjNpZE9tUS9nc1gxWTdFZEhHUkRlWXk2?=
 =?utf-8?B?eThSQmtOM3ppZm9iTXY2UkVqczVsWmordTFsRklhZ1kva3pmY1ZzUVFtVHBX?=
 =?utf-8?B?Ykxwd01MLzdYYnl1V1U1TUEvZEFheFpEOEFnNTRSVzBMS2ltbEc2VW5XOWlL?=
 =?utf-8?B?UlhrM2UzU2ROZytLRGFNNWpvMkIrc1MycEJWcDB4d0xPUTRzVEd4ZXM5QS9U?=
 =?utf-8?B?RGtua0RKODFwaG1ERFhPWmt3ajBoOEI1andiRWdveDhPd2plZ1FuK1BPcWhh?=
 =?utf-8?B?YlQxdWhuQkFhOGkvVzR0dWZTRzhXeXZjcXQ5eVJyUERqRUtKcUp3aGpXQU1K?=
 =?utf-8?B?VUNtRlovZW1zQkxyclkrK0MycjB2ZEFWM3U4NUk4NHA2dk5iZFJwV2tCTEh2?=
 =?utf-8?B?Wm1DdnZ5NHk2Yk9MTURwZERBcy9yaDdzbDZOM1phK2Npd09udUMrTWExNTZF?=
 =?utf-8?B?ZmlObG8vTWMrMHFMOCs1NjVmTHRLUEpUTGhHQmRpcjNBMXYzNVVFTzBEbm1N?=
 =?utf-8?B?UFk0UWZ0SGlpNUlIamtqekc5M0ZYdHVmV2ExVXNxNlZKS01mY01HdUhJQWJ1?=
 =?utf-8?B?dnZYQzgxcXZ0NllJamIrUWYzcEJiQThNanlmZlZxRmhGakFNYUdQMVFpRmdt?=
 =?utf-8?B?NGpzMkpuWklqa0NMVFkwNHJMYVFSNThzR3kxTW4wZk01ZnJodEZFQXRZRXIv?=
 =?utf-8?B?UEdxc1B4VGQyTXlsZXVrY29VbHFwV2R5V1JYL1VBM0dIWnNWaUpVMzVxa2hD?=
 =?utf-8?B?ZUY3NEZGNExwVkpLN2lkZHI2c3dNckxRd0pUUUhRdXNZVStoU2VDcXhGalNq?=
 =?utf-8?B?U2Mvc2t2OXpDUU1HYmdIcmI1ZFJUQ2Q0UXp3SVNNVk9sSkFpMDkxbWozS3BS?=
 =?utf-8?B?YS85UkNpTVFVR3Z4OGJkWnhpSmVjOHdJNnk1ZVFiVHZ2aTJlTTB5KzNlRFVK?=
 =?utf-8?B?Vm1WM0VvTkxVT3V6MlI1QzBUNUp6WFV4SVRndDkyYm9lRVRGRThZSlFZdDNt?=
 =?utf-8?B?cE9CTHd0L0wra2FSOWhiNTNFbTNWL2g4TmI3NDJxOUc4NzNkQVNRdCt2b1JW?=
 =?utf-8?B?N25vZzlSNk5ESXYwQ01TSWVxaWhRejB0NE9JU1VBNStSb0s2dTNqclc1ZzN3?=
 =?utf-8?B?bERtc3U1eERXZkh0WFY0UEVieWZuTGFUSVhtclFmcHI1VTlCeGExRzQyT0t3?=
 =?utf-8?B?TGRXVk9XTGxaV3dEMVdDSnZlbVE4WWJMN3RGelZrNVZBaFEwelovQnNnL1kr?=
 =?utf-8?B?WmtUbUROM2ZHVlZHeWdrbU9nUzNTSGFpZWZOVTNJaFNlelZrSjJVdXR4azBF?=
 =?utf-8?B?REwvaUhab21HbGhwT0d3djFZcmlKa0kvNGhYVU1xZHh1ZG5SaDZ5OXpYNW90?=
 =?utf-8?B?bjFDemI0dlNMOWh2QndTbEhnV29DSkI2ZTFqOWJhVmJmN01CREJFTXFrK0R1?=
 =?utf-8?B?ZTc3KzhrUGlNL2J3K2Y5NDRTa2V0bTROQzR3Lzk4US9aTkptVXU2d3p0ZFZG?=
 =?utf-8?B?NHNqZ0I0SUdRN0pYWjZTcEF2Znd6eFpvaGpaNTJRVnd6WktJM0F2eGNHUk9m?=
 =?utf-8?B?Ymtpd0VTSHlhZGtzbmJJZ25CUnpwRmpHV1B3eC8zK0d4dnBlZmozVEFpRjZv?=
 =?utf-8?B?bnBpOEczWVNVT3cxTE1VeUxPWHRBYXdMRFlKdnp4R1F3OE1MdkE3M3B6L2w2?=
 =?utf-8?B?b1NJcDhSdFdVNWRyRzhrM05VN0lrQzRyaC9DNVNjQW9ZaWRzVnllV3V5dFNB?=
 =?utf-8?B?cVVlU0QxZ3pWZjZvR0ZMUDBOSlgxWEUvRnJLSjh0a1RIR3BwZE1tbklVL25v?=
 =?utf-8?B?QS9TbnhOS21lMXZGU2dOSUpzUmFDNnBRQnZmL0d0SGFONXNOOGIyZzI5YSta?=
 =?utf-8?B?emNIOVRSR3FRcFpCemtscjFhOUhTSExKZmVyRDAza2RkWXRVYytWeVpIVjh6?=
 =?utf-8?B?VFhJcXJQNVBCT20yWGU0KzQ0RzhEQkV1V00wdFBpWjU2cHdYN1lkTEVSM1lw?=
 =?utf-8?B?UnJydmZ6bjNTaUdDVm9mSzdPK3FmODRKcVdBSmhmQkg2L2hNRmNDem1BblBu?=
 =?utf-8?B?V1ZaNmtoOTYxVjRoVjlWTnJoU2xXbXgxWjVlQ0xPMEtsNGlrNTZUN013NzFK?=
 =?utf-8?B?NE9FcHpoWmxMOXd4UW5zV29vTG5kbGtNRkJuYStURGlxeE03a3VOdHIwREU5?=
 =?utf-8?Q?DjQ1oL6IpNdIbmhZXwNOyhk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdea3f24-0b88-4183-85ce-08daae3e8429
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2022 23:47:55.6740
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yucb38GZ8gK48VFPnlgUKVjgKcYN5RfkQSr8AL1S0qOV0K9/cWtOG7FiZ1Vxfk6JsssvimVHUXrsE88sxFKpdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5177
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-14_12,2022-10-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 malwarescore=0 phishscore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210140131
X-Proofpoint-GUID: gT_g0fVXfIhm_Y8VlBYG_UdEw0hkeea6
X-Proofpoint-ORIG-GUID: gT_g0fVXfIhm_Y8VlBYG_UdEw0hkeea6
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Namhyung,

On 10/14/22 3:16 PM, Namhyung Kim wrote:
> Hello,
> 
> On Thu, Sep 22, 2022 at 12:10 AM Dongli Zhang <dongli.zhang@oracle.com> wrote:
>>
>> Add kvm@vger.kernel.org as this issue is in virtualization env.
>>
>> The topdown metrics events became default since
>> commit 42641d6f4d15 ("perf stat: Add Topdown metrics events as default
>> events"). The perf will use 'slots' if the
>> /sys/bus/event_source/devices/cpu/events/slots is available.
>>
>> Unfortunately, the 'slots' may not be supported in the virualization
>> environment. The hypervisor may not expose the 'slots' counter to the VM
>> in cpuid. As a result, the kernel may disable topdown slots and metrics
>> events in intel_pmu_init() if slots event is not in CPUID. E.g., both
>> c->weight and c->idxmsk64 are set to 0.
>>
>> There will be below error on Icelake VM since 'slots' is the leader:
>>
>> $ perf stat
>> Error:
>> The sys_perf_event_open() syscall returned with 22 (Invalid argument) for event (slots).
>> /bin/dmesg | grep -i perf may provide additional information.
>>
>> This is because the stat_handle_error() returns COUNTER_FATAL when the
>> 'slots' is used as leader of events.
>>
>> There are three options to fix the issue.
>>
>> 1. Do not expose /sys/bus/event_source/devices/cpu/events/slots to
>> userspace so that pmu_have_event(pmu->name, "slots") returns false.
>>
>> 2. Run cpuid at perf userspace and avoid using 'slots' if it is not
>> supported in cpuid.
>>
>> 3. Do not fatal perf if the leader is failed. Do not create events for an
>> evsel if its leader is already failed.
>>
>> This RFC patch is with the 3rd option. Would you mind suggesting which
>> option is better?
> 
> Sorry for the late reply but I think option 1 is the way to go.
> 
> The option 3 would be a transient workaround and it would affect
> other events too.  If it's really needed, I think option 2 is slightly better
> than option 3.  Or, we can add --force option to skip non-supported
> events explicitly.

About option 2 and 3, I will wait for more comments if anyone still prefers the
change at userspace, e.g., the "--force" option to avoid failure but just to
report non-supported.

I have already sent a version that may impact other events. Please ignore as you
think option 1 is enough.

https://lore.kernel.org/all/20221010050113.13050-1-dongli.zhang@oracle.com/


About option 1, there is a bugfix from Ken pending for review.

https://lore.kernel.org/all/20220922201505.2721654-1-kan.liang@linux.intel.com/

Thank you very much!

Dongli Zhang

> 
> Thanks,
> Namhyung
> 
>>
>> Here is the output of patch.
>>
>> $ perf stat -v
>> Using CPUID GenuineIntel-6-6A-6
>> slots -> cpu/event=0,umask=0x4/
>> topdown-retiring -> cpu/event=0,umask=0x80/
>> topdown-bad-spec -> cpu/event=0,umask=0x81/
>> topdown-fe-bound -> cpu/event=0,umask=0x82/
>> topdown-be-bound -> cpu/event=0,umask=0x83/
>> Control descriptor is not initialized
>> Warning:
>> slots event is not supported by the kernel.
>> ^Ccpu-clock: 62021481051 62021480237 62021480237
>> context-switches: 437 62021478064 62021478064
>> cpu-migrations: 17 62021475294 62021475294
>> page-faults: 12 62021471925 62021471925
>> cycles: 15662273 62020909141 62020909141
>> instructions: 6580385 62008944246 62008944246
>> branches: 1446119 62008855550 62008855550
>> branch-misses: 30970 62008643255 62008643255
>> failed to read counter slots
>> failed to read counter topdown-retiring
>> failed to read counter topdown-bad-spec
>> failed to read counter topdown-fe-bound
>> failed to read counter topdown-be-bound
>>
>>  Performance counter stats for 'system wide':
>>
>>          62,021.48 msec cpu-clock                        #   16.006 CPUs utilized
>>                437      context-switches                 #    7.046 /sec
>>                 17      cpu-migrations                   #    0.274 /sec
>>                 12      page-faults                      #    0.193 /sec
>>         15,662,273      cycles                           #    0.000 GHz
>>          6,580,385      instructions                     #    0.42  insn per cycle
>>          1,446,119      branches                         #   23.316 K/sec
>>             30,970      branch-misses                    #    2.14% of all branches
>>    <not supported>      slots
>>    <not supported>      topdown-retiring
>>    <not supported>      topdown-bad-spec
>>    <not supported>      topdown-fe-bound
>>    <not supported>      topdown-be-bound
>>
>>        3.874991326 seconds time elapsed
>>
>> Thank you very much!
>>
>> Cc: Joe Jin <joe.jin@oracle.com>
>> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
>> ---
>>  tools/perf/builtin-stat.c | 8 +++++---
>>  1 file changed, 5 insertions(+), 3 deletions(-)
>>
>> diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
>> index 0b4a62e4ff67..1053cf0886c0 100644
>> --- a/tools/perf/builtin-stat.c
>> +++ b/tools/perf/builtin-stat.c
>> @@ -762,9 +762,7 @@ static enum counter_recovery stat_handle_error(struct evsel *counter)
>>                  */
>>                 counter->errored = true;
>>
>> -               if ((evsel__leader(counter) != counter) ||
>> -                   !(counter->core.leader->nr_members > 1))
>> -                       return COUNTER_SKIP;
>> +               return COUNTER_SKIP;
>>         } else if (evsel__fallback(counter, errno, msg, sizeof(msg))) {
>>                 if (verbose > 0)
>>                         ui__warning("%s\n", msg);
>> @@ -843,6 +841,8 @@ static int __run_perf_stat(int argc, const char **argv, int run_idx)
>>                 if (target.use_bpf)
>>                         break;
>>
>> +               if (evsel__leader(counter)->errored)
>> +                       continue;
>>                 if (counter->reset_group || counter->errored)
>>                         continue;
>>                 if (evsel__is_bpf(counter))
>> @@ -901,6 +901,8 @@ static int __run_perf_stat(int argc, const char **argv, int run_idx)
>>                 evlist__for_each_cpu(evlist_cpu_itr, evsel_list, affinity) {
>>                         counter = evlist_cpu_itr.evsel;
>>
>> +                       if (evsel__leader(counter)->errored)
>> +                               continue;
>>                         if (!counter->reset_group && !counter->errored)
>>                                 continue;
>>                         if (!counter->reset_group)
>> --
>> 2.17.1
>>
