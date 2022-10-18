Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCAC66034F9
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 23:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbiJRVaP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Oct 2022 17:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230243AbiJRVaM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Oct 2022 17:30:12 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23D7D27FDA;
        Tue, 18 Oct 2022 14:30:10 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29IKwrmC015084;
        Tue, 18 Oct 2022 21:29:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=o3RnHSK2M0n4Rwg/sT42VEyWMg08BeI0LMllX4eVJnE=;
 b=pNUc4rpgYLloDpW6Nngqed1XeArGxiW0NO7+esIcVvzmFrITrUAF9dBcGY3COH7f94i8
 EYtYm0QuDrXIdSPCvcbCvPB6XP5tC4LaU5Do6YbNKPPycSxlmuIgWc9xnSFUCQCHP1y9
 Za6rGf6nCfJ1EqwHWBpwRJxgK5wcwVK8/Rz+4y7njLVMo0WyZG1KzQaQJB56JwwxmRou
 J9yx9HwKEr7KCtwUrfFSnre26mZje6+e6fofPg2LyWFNTuDE0D6MEWx0UmlGWpTLymcD
 p+0ytd8pvgLtFgkaw6JRBu2K1/vZd93M3Uz1VYGLO5Tm9hVcPDZU5EkDbtv5bdE9+qEb jQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k7mw3g323-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Oct 2022 21:29:21 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29IJrBI5016642;
        Tue, 18 Oct 2022 21:29:20 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3k8htgmtsj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Oct 2022 21:29:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UpkMg3CDb5vdaCXQyUq+ThfNXmwE8UpVjiP88WlaIXrogt79cIPFC2OfxZFY08JvRfnQ+H2g/mbkXcHzinz/6kgOuJhOi3IpceMANJANgm8Kx3TMtWWEDwNGp0gUglpEYlu5bGsqF2CDrEnyKNEKe7Po/tsDoLy3S8Yfy2E1yiahueydFR9rq0yaG8lABapjyuyaCEW+mEMD68UAtMFyUjWFMx9Kz+i3xYsPbwooMmsVmFHLH46pTWXnMvjOvy7JICKzVqub8kt5SThhlRQEfYjQ1WBC55Gm23VnOthUVniG3wKz/aLocPnOlJgeRQXQEU8LMfVMOHzP56CRbmzsxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o3RnHSK2M0n4Rwg/sT42VEyWMg08BeI0LMllX4eVJnE=;
 b=J6y4FvE5BYi9tm+YCrq1ttsrFa/les+OBHwLXFErFAXfYEkD48LtfW4k5wZizmfdhLln7OYfSxK33T8jvynxpOq8F2yakpq9KJC1xdGlNa7IV1XjR0wZROPXiU5hjxrblvPPOTCiaQ8H6DIJNCKb8ZCSnvP6abX7n6EsmNV3c1zk0TKsO/d7x4zgHeAqGr5JtOQEdxeTtqk5gsa+Xn4ft6imATAKsBleR6kTWMGjcKzrIEMGcAYc1yFRCT7AtXriEnkbKTPHDi0kOrH83qAjO+sryMeoPMjHKiIp4Q9SVsaxfBTT1Q12YAOL84e5MB+rH5sR3Fh6iOGoSlDaGFcYWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o3RnHSK2M0n4Rwg/sT42VEyWMg08BeI0LMllX4eVJnE=;
 b=tEkzr5WDgHixc4DixWAQhmcy5/TqsR5drSL7eEteYHI3OmoDovf9G/P3zG6CY0EjLH9xIg3EKwBRz6H8YkhWR5pVM0n0Sjs8msPgmyqrpYy1rx2bNIunGRGaGU76xOP1j/+Q9TAB0Jr/h42tg20FSz8Cl2NKxRbDx/Ac09Aejt8=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by SA2PR10MB4713.namprd10.prod.outlook.com (2603:10b6:806:11d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.30; Tue, 18 Oct
 2022 21:29:18 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::acd:f6fb:e646:9ff2]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::acd:f6fb:e646:9ff2%7]) with mapi id 15.20.5723.033; Tue, 18 Oct 2022
 21:29:18 +0000
Message-ID: <db44de92-381c-96fb-20d8-883305c214f8@oracle.com>
Date:   Tue, 18 Oct 2022 14:29:16 -0700
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
        Like Xu <likexu@tencent.com>
References: <20220922071017.17398-1-dongli.zhang@oracle.com>
 <CAM9d7cj8z+ryyzUHR+P1Dcpot2jjW+Qcc4CPQpfafTXN=LEU0Q@mail.gmail.com>
From:   Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <CAM9d7cj8z+ryyzUHR+P1Dcpot2jjW+Qcc4CPQpfafTXN=LEU0Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0114.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::29) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|SA2PR10MB4713:EE_
X-MS-Office365-Filtering-Correlation-Id: 85808ee9-b50c-48e7-03f2-08dab14fd02a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e61CpcfyMTbn46byWDUjbe6mazAozikXQW59wpTv7y8JFt5v7aihzCwH0UwjEt5mV9g4McH+F+xpx0auURYezQgL9dFNKxUzQHb6kEuIZaVX6jHPpe2+Ct6dyHfP8LMa/QWSPu8p4+jSrkQEj2r5cuv8BgrERaWAgKZz71oNFPxq+0vG5N9CwFOYA3KwAWCV2TUeXobr5psJzQvX9HyduCHENViSTc52KGTvUu9f+E0RWtcKOgQWvG1/aLA/yJpAcd8jHXfTvJzHboT+mperYHUlNf/tOeiB5zKuStP5GDljHQvsxTuVPzZCNAGzRBXen3Ve7THOWOIu8fBwz3J/sDLjeggbse989xdwgbrNKMZMeWE1tadzPNKVv8d768VQE2IRnK7HmkJREkoW3mVsayxXsc0y2Q7Y+vlbEr3xzIh9ss7U123/xGIak+dSMAjfvE6P0Ee20nfmfNi+J8KyuPeXaAz7hfmrOR0wC+7jKKYVjuFaEFxrhwaoDqtBQSpI0hd44bnAyAK4j2G7vENrjCyLwjxe95rqAxjOQxtNVhnt3IFOGMYOdJvynsyE5vF+Om6Jpw7ozR1msp7fnXmYB8xO2FNEgU8rZJP0+Zrf13yOzRun6oIYmMNRGVggREig8z1te8LNGQaQU61SKZbK1UVHi//vqrE0qtF6pNkVeAPL7R94kwG/DgzMbXAHvEoKli87Z2JLCzLSbEOOP7aOIbN5m5EgbEj6TpE/Qjk5f5oTVMhH8gTGg+QBC4lbpE29+G6wUEDzGC6TVy1U60wg2hGtP8Rlk86gTlSug3It0SU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(376002)(366004)(346002)(396003)(451199015)(41300700001)(6512007)(2616005)(66946007)(478600001)(44832011)(186003)(36756003)(2906002)(6506007)(7416002)(4326008)(8936002)(5660300002)(31696002)(86362001)(53546011)(38100700002)(6916009)(316002)(19627235002)(54906003)(6486002)(8676002)(66476007)(83380400001)(66556008)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dUhRc1VaSUdDRHFhTUJncE9Mb3ZHQ0tDVTVTdUxnZFNVazVoWmhOOUJTWlVC?=
 =?utf-8?B?Um9rK0NFRG84eGJvbmhPTlU4Z3haL0Iwc0luRVBqMGc0ODQxWE9FbUp2b0lK?=
 =?utf-8?B?L05iZG84QVlBYUcybyt1VWV1RTMwYTZ6cWtaRTNrby9ULzFsRXgyOEJDZUxm?=
 =?utf-8?B?eGNhWFJkV0tmd2VzaE9wSUpvc05SclZoKysreGVuUkVPWWtibDlDTVUwWFlz?=
 =?utf-8?B?OExQZWpjMHJKWDc2ejRHOFIxdWJleGRKOXJvSUlBdXlRbmdTNURPWUNHTGhu?=
 =?utf-8?B?UHVwMHpLcW92SmExWFhCRm5DbUxJZVRGQU1pWXNmd0djdEk5V3lSbk02b05t?=
 =?utf-8?B?aFphak04Q01IUFBUNDc3QXlQVGpOYkk5SG9UVmo4M1JpK2ZSSllZVW5peDg5?=
 =?utf-8?B?Q25objdxbVJFNUVTekJEeDd6eU1yN2Z0bVN2QUs0WnFtR3hKNWhkamRjVWZV?=
 =?utf-8?B?ZTZmUDIyWlh2ampESE5NdU5WSzdVUFN2ZjBZaUl1ejdHZ2Z4RDBNWTE0WUhr?=
 =?utf-8?B?TllCWjJNNVVIdERFNHUvSHE4Z3BXMDY0Y1lnMXVRdE0zSFZJZXdvYW5CUEps?=
 =?utf-8?B?eWxvUVRvbFhteG1vU3BPbG1WSGVuazc3aDVpSy9wVlN4WFlyblNwQS91VnBh?=
 =?utf-8?B?Z1kxTFJYQ2VUMnJjWFRoM3djc1RVc3ZaMHpkLzZ0QW1Yd0psSFJmeERxNVhI?=
 =?utf-8?B?SzFXM001N0lPSS9iZUhvODB0K3lwaHF1WHFibWVVeEovbWFpYjF4WGRTZGg1?=
 =?utf-8?B?ck9UNWplbDIzRlAwdlREOW1mbUNCeS8xTFBod0Fvend5aVU3emNHb0doNytv?=
 =?utf-8?B?alp2UzhZaHA3NGlzRDNNd2lYQ1RFRXgyVUVOMUJ2blA1ZmkwVUdPNzZTcU1X?=
 =?utf-8?B?VzFSMy9BQ2xBL1Y2cndieWhBWTBPUXNMckRoRlZGdlUrbnNvdjJrODBTZzk2?=
 =?utf-8?B?Q1dhUFo1UEo3eTd1ZkxJREhWTUJKQ0N2dllrdHRMUmJ0K1NGMnQ5WVlIeWtm?=
 =?utf-8?B?RENYUkhleFRWNVlHRWxDZEZuNTlxUE1JK3lNZkk4S3pGRUh5Q09RdXMxREIz?=
 =?utf-8?B?azFwdUhSTjd3ZEJLOXBoS0VGck9HWkZmUGFjcVRGLzdrbi9sRkwzQTZNYmlq?=
 =?utf-8?B?TDJ2UGF0YkJWeUlmZ2lXSHFEbmVQclBxZlNBbER6QUJWSEs1Z3hRemxLQlV5?=
 =?utf-8?B?akxiT3M5N3ZrUURRT1VkYVZ2UnoxeGdhT1pXdGordXYxa0NNOG56VUZGTXJz?=
 =?utf-8?B?eDlPVzJOMVh6OTB1c1BpQ3pjTTVlUXA0eTJ0cURSTm1DS3ppZnIvajNpZVdK?=
 =?utf-8?B?cTU3OW1IMm15VmVqS2dtWXN3WFZxTXF3TWJhSlZ3U3liR2lLTUtvODFHYVVv?=
 =?utf-8?B?d2J4SUtpN3puSVM2U2x6TWh2UEFUN1RLeGpCUEZVaTRxcGc2aVE3MnUzVmVo?=
 =?utf-8?B?Ymo3K2JoeDduVzEvMkNUbTRFd1pOS2VSZENBa3dZTFRxRVU5L000UUFqMTZX?=
 =?utf-8?B?RjMzR0d0TlhWbmFZTllmUmMwUG9TY1l4MERHS0p1N0JkTjJnZWZXeVBld2tx?=
 =?utf-8?B?ZkJXTTR3STBuQkpTbHoySWpSd0VlTllsTmF5eWFiRXJoZHpnNDhOelNTMisy?=
 =?utf-8?B?ajhvRFdkZ2tKdmpod2lxS0JhVHpSa1BKK3FTZEk5b2djWG0ySzMvYWkvYU5E?=
 =?utf-8?B?VG1OdFc1bUZEd0tQMWJjRWlrUlV5cVh0cWFwZ0E4Y0dpMU9Wd3JGS1kwa1RJ?=
 =?utf-8?B?U1pZYXRMdlNSRXJWTUpCUHZEalhDZXhFSFZQVE9URldscy9rMmZQbTZXekFP?=
 =?utf-8?B?bnZoTmVsL29HMThKQWpKSUN5MVgwbGdNVnV4UVRoMU5ha005anVKUE1YMjkr?=
 =?utf-8?B?YUdrTjFkdnN5QWg1c1d1VHdkQWtHRE1WZEJGeXJCMThiUG83ZlZFZXNxWVpC?=
 =?utf-8?B?MWljR21QM2FBZG1zUC9DWExQcW9qVXJIc3R5dWhKTittbXg5bVArRGo0Wmds?=
 =?utf-8?B?Q0xEMGJLc0txTXNpUkp4Q3c4WU1jZ25zekJHTDZyWk9IWWhFb1pnN2ZxZzYz?=
 =?utf-8?B?aThBQkFrOGtUWlZ1UDlrOGlMNXJFQ0pjaXZ2NWo3ZThRaUhIWXRuaWJJQUlQ?=
 =?utf-8?B?SzMrdzk5S082R3VhTDVPMUZZa0tQQmRPdEhmWE9Bb2tUQW9qNUpDcGhpOWU0?=
 =?utf-8?Q?nW4yVDHvDahXeW+UCB3GFSU=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85808ee9-b50c-48e7-03f2-08dab14fd02a
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2022 21:29:18.1324
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1MI+/ZLipOz5dfddhMwZxmiDXLJi6eR9u9wSVA0WVoW0x+4AODL21teB1zYjG0qVBDkveEa2Xv0XCbEk50wGsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4713
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-18_07,2022-10-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210180120
X-Proofpoint-ORIG-GUID: 4J_M-k6zwtEz0_viNy6QpQL7whIBYCDS
X-Proofpoint-GUID: 4J_M-k6zwtEz0_viNy6QpQL7whIBYCDS
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



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
