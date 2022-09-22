Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D657E5E6A3A
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 20:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232236AbiIVSBw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 14:01:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232295AbiIVSBR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 14:01:17 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF168C889A;
        Thu, 22 Sep 2022 11:01:06 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28MH4EpB008157;
        Thu, 22 Sep 2022 18:00:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=RhUyhQUwH8Ohwkqafe+v53SFSJKKDUvuPgJsZDvcmN0=;
 b=dxc3dKJHGhV7ocZnIZF/XaoWwpgU5FRhCMERjv+HcgjltufD1pvE744mu8tvyDpstS2i
 km5raYvOKpYv5TopySUapRmyF2nI83MEvYhCK6AfHv9HS2E+6jIAsPxzbMD9AwI6eA0u
 1wk2/c6wRtfu4eOnhVaBkfgEnONqeg6uk4KnsGE80c+Y4t/bHQ4jVgldng1hC5DgQQ4J
 DTgLu2n0lC8LX3Az8Mivx8pj4xJrjDQRnOFPqy7knQsYRypESXE73xRaAXMNhm2gMG8x
 3S7KkA247nTPnQE046LsA5GvBcae7KE5pL5+aGjb4j8zt79XHHW5Y3/StivDFH0z9CAc 1Q== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn6f0nx5v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 18:00:36 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28MGF3Ss005667;
        Thu, 22 Sep 2022 18:00:34 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jp3cqvsd2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 18:00:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QZziH+IKLtdeumpstngzN0gZ4sDA0qv9FsrrRAyONTM/GrKC2Z1EkVAT0Qx/pa4f0yY7bxn8QN7D/ZyylF/91860IM45/ucEjY2vWVSA7s97X3hYPcSOt3dwFYzV+u6yXKQU4GcG8Z3W/IKb12KqXYaKrhaojZ8GIK0sKdyWmuISaF3IFSyWhcC+MTO26A13CpTQzouu/HFYyu4VUG1sj16iyAoIxSlXOQg3A81ZVUDAuEHuS3FpMqcu28XUnoLO7+3R9Zayn2cf+xyT09HWp/N7SK65r9xko+Wn2Zk9iMVGiVuKXTp8+bpAtyYMLXv8nBkPJpvDeynI4/ek5SOsjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RhUyhQUwH8Ohwkqafe+v53SFSJKKDUvuPgJsZDvcmN0=;
 b=KhaInmVgdjKhqtiBdT2QFUNNskjNPdGwGcAcsZWBAaufgTgOi7fKUgeFBDWXooIXejsr7jH70OPOtkHaEcQ6Ik4NFigeeWcO6utUPAQpTbBevDR2WAzxQc28evroWudVci/ymrRyl+bLcQDvr1yDCn4s0nKqLKlxHFlTZHtEPsxg90lWLG/0K2Ev5Z8W6DFCu6ZG88bZrhGv/1ySEUvfFkmDWnjm6qJQ8VYjFfMNWjWod1/l1vu0Wp7Mij64YZjg/IvrA76ANmijo5liK6OGllqvQxLA6CpOJKmJw0uNfvgZEBxhP3ULEOW/+qp83xf845bK6vZi4gKo1hfgazlcBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RhUyhQUwH8Ohwkqafe+v53SFSJKKDUvuPgJsZDvcmN0=;
 b=vGQ5HlfpHOeCwhBSxBgBAomjIdOgUKHHk1zJFyKLmjx9cROgGdR6OI7YsnfDzkW1hghid3L61AcBt3RuI2RIwRkfHnSeubqlNAyUPhLPBdRGWW0HyYz5pE2NLYKDnobso4XtJH6492viDybUXntZqdqhcQppqu0ailAomhGLu/Y=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by MW4PR10MB6395.namprd10.prod.outlook.com (2603:10b6:303:1ea::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.17; Thu, 22 Sep
 2022 18:00:32 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::36d2:a229:987:a748]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::36d2:a229:987:a748%5]) with mapi id 15.20.5654.017; Thu, 22 Sep 2022
 18:00:32 +0000
Subject: Re: [PATCH RFC 1/1] perf stat: do not fatal if the leader is errored
To:     "Liang, Kan" <kan.liang@linux.intel.com>,
        Like Xu <like.xu.linux@gmail.com>
Cc:     linux-kernel@vger.kernel.org, peterz@infradead.org,
        mingo@redhat.com, acme@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        namhyung@kernel.org, joe.jin@oracle.com,
        linux-perf-users@vger.kernel.org, kvm list <kvm@vger.kernel.org>
References: <20220922071017.17398-1-dongli.zhang@oracle.com>
 <ad2572d0-06b5-7250-31f2-a5efa1048cc0@gmail.com>
 <27cb9747-8911-b3cc-25d9-9438521db832@linux.intel.com>
From:   Dongli Zhang <dongli.zhang@oracle.com>
Message-ID: <d03d8a07-a05a-f03e-189d-a07c6aecbb8a@oracle.com>
Date:   Thu, 22 Sep 2022 11:00:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <27cb9747-8911-b3cc-25d9-9438521db832@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR01CA0002.prod.exchangelabs.com (2603:10b6:5:296::7) To
 BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|MW4PR10MB6395:EE_
X-MS-Office365-Filtering-Correlation-Id: 34cc2b60-c520-4d04-7f2b-08da9cc457a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OsuJRhoAWAka/8lNM3PareEz0kYgtWvgMPQm/njlqF3UYA0PpiGNO/49EqrRNjK9qDeL+PC7w9Udv4QkWuIC+eMfhG809xX0E9qULfDSCBheQzF9U0sQTZoyoxLongDCuW225i7tTWBtRDXhXqXuo8Z4fskl617gc1PUGouAqj7jyxroT1F9iskW4sCA7ohsdpCJyN+/CeIlT2SjCaAUjZFBzPswdlKhb7v1NV3qHuJ8PI84Zmyg1f9MCpE0G1KpuH+YjqciAWOh6QwFMhfzgdtyT3RUG64+lrb8d0kAC4nAmUx87Bu6gVcIpIauzz+XlTyibmLNjjiTcaqoSlp30Yj0/DNQO2z1adAPGBBdpdPOZb6XkGb5Amuotjmvy/fnYGBEwr76lUoJFnKEEFpsQs4oPx7YnpeIRE+dZVQ/+5tUbVQN1eYolmR5hpxJTJbpJ6pTiGEB+YXHNVXguUsgqtB2KWY77OCIGXQHbgssZwhnD9lUBURaiXhL2VMnoJT+me3pXfcqnWhpT/9aqLcOb2lkb9zAaFZeBATXCCecjvk2Crb6C3Bs3HGJSoW+ppsXMrJG30ikmdwXbsyTLtFD8JUqbdJeIJ/LKBwQ826cV7SMJluMjuYXoPC7MlThsHSwy/C4H57X29zcdBBL5XddBO/NPcxkW2ZVv/tAQeRUsKx+ldqpZSdUvXUqJMxxOf+RvdEF+6ygCPv6JZpTgNUnxhQWKSk3O49toFTDsso3WiaU0NZ4obzvq5qDZuAp49tcpV6910GXOUNEtT2zZsHW1Te3VXJNeVt2eVBNaQOw1Q8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(366004)(376002)(39860400002)(396003)(451199015)(4326008)(66946007)(66476007)(31696002)(83380400001)(66556008)(7416002)(5660300002)(86362001)(2906002)(44832011)(38100700002)(36756003)(8936002)(478600001)(6486002)(31686004)(6512007)(186003)(2616005)(8676002)(41300700001)(6666004)(110136005)(53546011)(316002)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?anFNcWpqeXBDQ0RWZUN4ZTFZeUREMkRBSlhiOW5GOW5aUWU5QitZaS9GQ01p?=
 =?utf-8?B?UFVvM1Zvb2ZuYXo4Q254cTBYUDdHU201b1BHZXlBdThzN3pGbWErZTBOcjVv?=
 =?utf-8?B?dDM1TUc0dlFsWGlReVoxQnYzR2tnMkxGR2tOTUxQUTVZM0NNZnUxaFBVM1Fa?=
 =?utf-8?B?WEJ4Um54dTc0b2k0S3p6eWxaZlRzTVlBektBV3dqc1UxcU1LT1BmbnV6dTRN?=
 =?utf-8?B?SCs0eVMzT1duSXRGNTdsWWd1dmNSNTRac1V0SDJrOEFLY2tWSzVSOXhWZHBq?=
 =?utf-8?B?QncxeTd6VmkzWE1JK1BrWGtocWhIL2swRmJVV2J5c0NTUHlqUEhXZlIxZFdH?=
 =?utf-8?B?UyttTXF1UUk3ZWhRbkQrVmhudjJybXliNWR6YXFkOTR0ZTd1dFVGS3pmTW9Y?=
 =?utf-8?B?TjBnbXVrTjFmSnp3Mmo3NGlTQWRQbzJ3WUVoRVFFS0JaN2p5eENTZmhuVnJl?=
 =?utf-8?B?UFBQNGh2Zk9jMk9EanVMdzR2T2Z0cjVIYWFXdjVMcThrVk4vQkptY0lJS3Qz?=
 =?utf-8?B?anJWSXNFYWFOSjB1N1lGU2VjQ1ZPZWQrZzA4TVpnR1RtQjEzV09VOHRVUEhs?=
 =?utf-8?B?ZkJNejN1ZVZlTXp0R2VXYXQ2Z0pGNnAvNGhkeWtZK0Q4RWtMa21BM2xUb1lF?=
 =?utf-8?B?dEJBaTg1MlljbUxmb280Z3hHUjJUM0hDLzl0YzA1VExxbXY5T0xFa2s5Vm5M?=
 =?utf-8?B?RlRFL0YyaktURE90ZzJXR25JZkR2K2JqVk0zVnVqVVFYYk8zR3ppVU04dEp1?=
 =?utf-8?B?b3k5ZmtSRHFlYlEyM2RKOU5HNXFYVkpVS042Rkx1ZlkyZjVvenZmY1YzNTRW?=
 =?utf-8?B?ajVuQ2ZnWUw5M2xPU1RwSWhLTjN3akYyWnhGT3BBWFBRZVBsbDRqVW9va2xi?=
 =?utf-8?B?NDY5aGdHWEJQcTUyZnlxbXdBWTIyRFNPWjcyK09ZUXBIaExZdVYzcG1ZL2tU?=
 =?utf-8?B?L1BYcXdHMzRsdkFKUHYwVkpLcVdpbDVWaGQyT2JkS0k4K0RlcGc2QmNnR2gy?=
 =?utf-8?B?MEx3RFNCZFlUVDJvRkJMM29LUkRGVmdSQnQ0Z1RhVDVMK0dRbEZYNVhmMVZ4?=
 =?utf-8?B?ZG9yMXczRFNTNFNmb1AySHRVVDVYRjFOSlNtOXpQY3JNa250UmxmbkMvUTNi?=
 =?utf-8?B?UXM1WWxiSnNrUlhkYXRUbzlXb084YkF6UVp5Z0d5SXA2aUY1YXdQZ1lHYzZW?=
 =?utf-8?B?NXcxSHQwWHplanJ2aC9CV2l5ZUQ1ZUYwVXVoSjQ5a1NkVUtTUngzZmF2WnBp?=
 =?utf-8?B?QjhKL3dzbFRPSnhXR1RYaWMvSldMV3hrSFcvRjNKWmIxOE44VVVPYXZ3d29C?=
 =?utf-8?B?N2QrZkpwVWJDMVVsQWM3b0hGV0d2djk1cHp3TGcrcWpOVk5RZWJlVmVkRUFY?=
 =?utf-8?B?OXovcnhkaEpad0R5d3A1cUNUV0VpblZaMmpXeHBJcGVrb3Y5QlRITUt1YmZJ?=
 =?utf-8?B?SXFyUnAyQ25JWUZ3ZDBoZDdMak9tdkRYMmJSRlQvczltZ05CdFZaVDY1NlFi?=
 =?utf-8?B?V2hvWnFsdm9ZVHVuMjBQckdyakFsajBEenV2VGtwWU9WR0YzYy80cTF1NnJ3?=
 =?utf-8?B?c2MzYS9yZ2VMWXE2WXB4VmlUYWpRaEdRNFpEZVNDbnBUTFEvKzhBMXlRUzZV?=
 =?utf-8?B?WkFzbWlYTExReit4NUo2dUMwUDdMazRCQzhDMWFTczZ6UXlXaUtOT21sa0Nn?=
 =?utf-8?B?cFowY0NkNVdyUk1LNzVtQndRT0duVmJlZGVvQkw4UTBjWWFPY0Q4TkVVNzRu?=
 =?utf-8?B?elptWHl1Y3pKL3Z5ZHcwQkx2NURFa1NFUXpwRkRSemFNYy94dXFkKzREZEpV?=
 =?utf-8?B?Y094NkpRN3hnNVJ1clR4QlZVWEp6citERStqRlpOcEd1eit0SGNjVUxGcjhH?=
 =?utf-8?B?MGpBNDZpSTNsQkpUMk1UNVV0Tm5aaUlLOUVsaEtzenRLMjgzS1dQN2taN1VY?=
 =?utf-8?B?OStUQWxHWVkzZzVicmIweElFenFZWmZoWlZ6MGI3U2wvZUVLRXd0azlCV3lH?=
 =?utf-8?B?ZTgwK1ZZT2QzanJOUXhOV3NvaTJmdkJVR0hrWDIwOFJFaU9JMEVqZFRKeUx5?=
 =?utf-8?B?TklyVGhvM3dCZ0Nrdk0xT201ZHoxMWVNMEdJcWZlMnBtd3dCejVQRlEzNDlp?=
 =?utf-8?B?eGdSTGlXOWIwS2ZPTXJjWmd2RUp1bDFtdUNjTDBOWm5CM3dkbTREZTB4SzFu?=
 =?utf-8?Q?AG5mb1+lQ/Br/9A0clD6saY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34cc2b60-c520-4d04-7f2b-08da9cc457a0
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 18:00:32.5099
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jjPJgP5WndKq3fxo+v2NMH51sYMySNDKw710yVw+XDzhtMRsHGG5fzuTLrhTyggp2CxybwmgjAf7an7wET53WA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6395
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_12,2022-09-22_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 spamscore=0 adultscore=0 mlxscore=0 malwarescore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209220119
X-Proofpoint-GUID: VtAEvO76XeypFOpiNtd2Bi6Wx_G-shPb
X-Proofpoint-ORIG-GUID: VtAEvO76XeypFOpiNtd2Bi6Wx_G-shPb
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Kan,

I have tested that the patch works by hiding 'slots' sysfs entries.

# ll /sys/bus/event_source/devices/cpu/events/
total 0
-r--r--r--. 1 root root 4096 Sep 22 17:57 branch-instructions
-r--r--r--. 1 root root 4096 Sep 22 17:57 branch-misses
-r--r--r--. 1 root root 4096 Sep 22 17:57 bus-cycles
-r--r--r--. 1 root root 4096 Sep 22 17:57 cache-misses
-r--r--r--. 1 root root 4096 Sep 22 17:57 cache-references
-r--r--r--. 1 root root 4096 Sep 22 17:57 cpu-cycles
-r--r--r--. 1 root root 4096 Sep 22 17:57 instructions
-r--r--r--. 1 root root 4096 Sep 22 17:57 ref-cycles

# perf stat
^C
 Performance counter stats for 'system wide':

         19,256.20 msec cpu-clock                        #   16.025 CPUs
utilized
               179      context-switches                 #    9.296 /sec

                17      cpu-migrations                   #    0.883 /sec

                 3      page-faults                      #    0.156 /sec

         7,502,294      cycles                           #    0.000 GHz

         2,512,587      instructions                     #    0.33  insn per
cycle
           552,989      branches                         #   28.717 K/sec

            15,999      branch-misses                    #    2.89% of all
branches

       1.201628129 seconds time elapsed


Would you send this patch to fix at the kernel side?

Thank you very much!

Dongli Zhang

On 9/22/22 6:34 AM, Liang, Kan wrote:
> 
> 
> On 2022-09-22 4:07 a.m., Like Xu wrote:
>> On 22/9/2022 3:10 pm, Dongli Zhang wrote:
>>> There are three options to fix the issue.
>>>
>>> 1. Do not expose /sys/bus/event_source/devices/cpu/events/slots to
>>> userspace so that pmu_have_event(pmu->name, "slots") returns false.
>>
>> IMO, the guest PMU driver should be fixed
>> since it misrepresents emulated hardware capabilities in terms of slots.
> 
> Yes, we need to fix the kernel to hide the slots event if it's not
> available.
> 
> The patch as below should fix it. (Not tested yet)
> 
> diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
> index b20e646c8205..27ee43faba32 100644
> --- a/arch/x86/events/intel/core.c
> +++ b/arch/x86/events/intel/core.c
> @@ -5565,6 +5565,19 @@ static struct attribute *intel_pmu_attrs[] = {
>  	NULL,
>  };
> 
> +static umode_t
> +td_is_visible(struct kobject *kobj, struct attribute *attr, int i)
> +{
> +	/*
> +	 * Hide the perf metrics topdown events
> +	 * if the slots is not in CPUID.
> +	 */
> +	if (x86_pmu.num_topdown_events)
> +		return (x86_pmu.intel_ctrl & INTEL_PMC_MSK_FIXED_SLOTS) ? attr->mode : 0;
> +
> +	return attr->mode;
> +}
> +
>  static umode_t
>  tsx_is_visible(struct kobject *kobj, struct attribute *attr, int i)
>  {
> @@ -5600,6 +5613,7 @@ default_is_visible(struct kobject *kobj, struct
> attribute *attr, int i)
> 
>  static struct attribute_group group_events_td  = {
>  	.name = "events",
> +	.is_visible = td_is_visible,
>  };
> 
>  static struct attribute_group group_events_mem = {
> @@ -5758,6 +5772,23 @@ static inline int
> hybrid_find_supported_cpu(struct x86_hybrid_pmu *pmu)
>  	return (cpu >= nr_cpu_ids) ? -1 : cpu;
>  }
> 
> +static umode_t hybrid_td_is_visible(struct kobject *kobj,
> +					struct attribute *attr, int i)
> +{
> +	struct device *dev = kobj_to_dev(kobj);
> +	struct x86_hybrid_pmu *pmu =
> +		 container_of(dev_get_drvdata(dev), struct x86_hybrid_pmu, pmu);
> +
> +	if (!is_attr_for_this_pmu(kobj, attr))
> +		return 0;
> +
> +	/* Only check the big core which supports perf metrics */
> +	if (pmu->cpu_type == hybrid_big)
> +		return (pmu->intel_ctrl & INTEL_PMC_MSK_FIXED_SLOTS) ? attr->mode : 0;
> +
> +	return attr->mode;
> +}
> +
>  static umode_t hybrid_tsx_is_visible(struct kobject *kobj,
>  				     struct attribute *attr, int i)
>  {
> @@ -5784,7 +5815,7 @@ static umode_t hybrid_format_is_visible(struct
> kobject *kobj,
> 
>  static struct attribute_group hybrid_group_events_td  = {
>  	.name		= "events",
> -	.is_visible	= hybrid_events_is_visible,
> +	.is_visible	= hybrid_td_is_visible,
>  };
> 
>  static struct attribute_group hybrid_group_events_mem = {
> 
> 
> Thanks,
> Kan
> 
