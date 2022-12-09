Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 762CA648938
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 20:53:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbiLITxB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 14:53:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiLITw7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 14:52:59 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A876B9BD
        for <kvm@vger.kernel.org>; Fri,  9 Dec 2022 11:52:58 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B9IwoM6027506;
        Fri, 9 Dec 2022 19:52:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=hdR9vFFrA8AQGKlT3AS9YlMptmD7UT7gKFh6+2EFW/g=;
 b=Uy7qM6HT2JgEAyP2Zv7JrjoYVv/deO0TdyQFyeqKt7QOhJ9b78z6m/7aqCydPvxoxjWT
 sQtJeSfF/palh//1H/qf6JFKkhCEA+MONmRoQncA8m/4SO0Tjy3lPq1Ics03gakajl6X
 sitm3TtgwwCE0CAdciHxko/MRCkM5aNumkgAuGfmVoG2SWQwz5f87fbFpaqZZs+smDM+
 v5sCvGFepuzYzPVj8YoF/ovFPahp7L2au9LaDuv5ccWH4WaOz+fnN/1UITUPkSNcXLcj
 btLaI+KuVWdditqRbcJD7Hb00ZRjRH+UwGe7cEQQTSFJXde76UdjDeTZnvCrX7Cz4+1D 2g== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mauduwud5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 19:52:54 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B9Jjm1l039786;
        Fri, 9 Dec 2022 19:52:53 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3maa8m1d24-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 19:52:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m58wez3nVB7lyu7kkz+yXgceQF38RzDtDzHdYvUSFvNVpryo82daCIS6EzKOKXGYau30JdFsumlAp9QjPzef12FPjEo75eXsR1/9xnVLZE5KxHcGUGu82IwBUZz7Aw2M6L1+A00UJv34czAyzK2Vl4qswd/ShASbEXdCljoARasd1OjRMgD//sYY4PBFhPG+njCVQ9Y2wmEiL3QHcjHpRQJP44M/4Cn5VFOdMjaxq/YcF8NToblq72h/3/Iian96fmaoEcI/S86w5UrcwCwUbeXQoX3qG0TIufbwD7DEgL7VQ889Q647n3880QpzhO23MRtPLvTi/ipzrDZLvLfRkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hdR9vFFrA8AQGKlT3AS9YlMptmD7UT7gKFh6+2EFW/g=;
 b=Fp03TsquNRQA0O/BTgk5p9gre/GYELrp+bEq9808j8fDOZ94NsUK/zmQbu2LudqH0hSL7xU7LUNX+DIkNnrDPpELlsOZehXbH63j5k5C9Vqh4svbpgOzd8GPwRSoxojbt2iTHz95IUTaCfjZLbLYqKHPaMI24MHCybYFRadcsGW2fRq1tzHby2KT3pQ2e+G4At1eGqP0e/+BC3jFCe9TSHmY21jTQp0D3t3OCqzJuNJKCi0JOH8uZM76R5KQFpa0iWzTZof081c8N2VZeZkEGLuMyVfPA1bl8hF5wKfV+Zr4w8GdBsmNbTf1kfr+aQBwmM1tH9b5vay6PVelWdmplw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hdR9vFFrA8AQGKlT3AS9YlMptmD7UT7gKFh6+2EFW/g=;
 b=ZtRc2bYnWHqN5nzQQg9Uxre7hAt5ZpIrai1FDp1au/WSeqrH65R+co/ZGFJJMrsWUhT12KMJqEcZDJ9wjY85npamq4xi3SNTmI1Btk1tZYy80WqNU9tnRvTtFNakZDTMUcZaYkLmkMJH5bQTGciHn6O+Y6t5JCNt9rl10euBpJw=
Received: from SA2PR10MB4684.namprd10.prod.outlook.com (2603:10b6:806:119::14)
 by IA0PR10MB7301.namprd10.prod.outlook.com (2603:10b6:208:404::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Fri, 9 Dec
 2022 19:52:51 +0000
Received: from SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::4056:9f2c:6171:c37e]) by SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::4056:9f2c:6171:c37e%5]) with mapi id 15.20.5880.018; Fri, 9 Dec 2022
 19:52:51 +0000
Message-ID: <5f494e1f-536d-7225-e2c7-5ec9c993f13a@oracle.com>
Date:   Fri, 9 Dec 2022 14:52:49 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH] vfio/type1: Cleanup remaining vaddr removal/update
 fragments
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>
References: <167044909523.3885870.619291306425395938.stgit@omen>
 <BN9PR11MB5276222DAE8343BBEC9A79E98C1D9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20221208094008.1b79dd59.alex.williamson@redhat.com>
 <b265b4ae-b178-0682-66b8-ef74a1489a8e@oracle.com>
 <20221209124212.672b7a9c.alex.williamson@redhat.com>
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20221209124212.672b7a9c.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR13CA0003.namprd13.prod.outlook.com
 (2603:10b6:806:130::8) To SA2PR10MB4684.namprd10.prod.outlook.com
 (2603:10b6:806:119::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR10MB4684:EE_|IA0PR10MB7301:EE_
X-MS-Office365-Filtering-Correlation-Id: 5be88906-93da-4008-8a2d-08dada1ef48e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8VQ9zMX2RSL09lYSsF1lvGG4bsXZcS8hzTwRiq44Lw8AT2zMQytK8M4Sb2Av+dkL0ELHVZcIkxgZOaN1s8F0eO1GB097WnUFANDAp6AcJBXpaslJbBjlfNcTE39z7KKaygkdN+u/+rzzL8wszPn2XoGuHY3TtV93QAJC9BA/wgM1si1NSvb3jFTpM20rqu3rlbXRBqugls920w3qS1LerZnSeQ2p2+h8xMZLnPFoG0MvRYKb0V4M0Yfj8b/wom3YQdXCzUySnWNvGekqiSmoWo/v221clylnlUNhDSxzwbDjlIhTeSRPkb6TuSrRiyNpNmwPd7uExaS7I+9L1TPnsmu8VxlsOXCzUYeN4jWTzjmAkOgD3BYlw5zdS396JQdE40pIuYcTq9YHsLRBHa+Yjp8/FYiaysZAGVmzEI50Y/0dWa3uhpepi1aYiS7YcbBtjt0gN9jpTed1/H0FaVeEqoEzNayHIbiIXXHrNFemMvil6FIsu9+efPQWY79VR8hTgw6XKYX84WUaP+x0nhlZ2WntBFdLRU3aRYbag5/DdBe1BZ5aM8whvqBh0BXv4VCsOiqPvfApIvPmYK0BHOUBYj6eVMFPy6/6HpuytRkRi2/bh3AAMYXCT1mry1CdlFhM7q0mqbQgql7Dl/rCto/SUkzcKGLmmjgO7WJogSJmL7Cs+YD3+YisBfnQu+W+vPqKSWnD4Rbzl/29fFUAYOTOp5JH5J1TmpchUuhQ2Nhz695VaN8kw5Tv/It7yvdEUmP7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4684.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(346002)(396003)(136003)(376002)(451199015)(66556008)(66476007)(66946007)(36916002)(2616005)(478600001)(8676002)(316002)(54906003)(6486002)(6916009)(36756003)(15650500001)(31696002)(86362001)(83380400001)(2906002)(38100700002)(53546011)(5660300002)(31686004)(8936002)(4326008)(6506007)(6512007)(41300700001)(44832011)(26005)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VG8yZ0lWWG1kaXV1K0hxSFhwdkxZaE8vdXFXV2pCaVlqd01lVmJBWDAvTzNY?=
 =?utf-8?B?NGc3azlDNW16YlF6elNBSDFxeVFaTFNvTUtZcU1DbnRhR2c0cHloWWdpbmVE?=
 =?utf-8?B?TXBtSDd0WUFyaW9CWVhmQnVtWStjYmJSYWl2VWZJb04rSk0zRm13U1BFbFQ1?=
 =?utf-8?B?UENhc2FOVmVxbXBJL3dEQkl0Y3J0UFhoUzJsOWE5R3VFaGRWVk0wdHBJd1Fw?=
 =?utf-8?B?bWVIN0svc2pWQ3pQSWx2L0tHSHk1YURjN2JZSDBVRDVNZWNWT0hTbTVvMzNJ?=
 =?utf-8?B?cnpiOEI1MUc5V1dGMVBtZFUyRklGOUdRM1NKUXlqUkVwOGtuM21WSm8rQU1R?=
 =?utf-8?B?TVJqUUQyandSQlMreVFsUjFTYXkwamFkLzB0ZXlML0FVT3NVN2ZkOHNjUmFJ?=
 =?utf-8?B?Y2srM2xJckRLTVpwZTNvNFhjWURxUUljdGtuUVYvOUdWeVpaVnR6eUhpMkZk?=
 =?utf-8?B?Z0NHN2pCRUsvZUVWa1A1MGpRT1E3dmh2MmswUVdnSkt0SFNDVXhEcjYwcWdI?=
 =?utf-8?B?dGlQYmNqa0dCQXN5a2hvVkNkSTNZTno0YkZrc1VSLzhONEJqN1Y4bDFXVVNC?=
 =?utf-8?B?ODFTMmt5eDkzeTdIYjhFRzl2N0RjN1BqVStRaTkrTU9hRklHalkwbW1LTnRV?=
 =?utf-8?B?TytNSXlzMUZra2xlOWJ6VVlsNGI5c0dUOEk3dGN5V0lncHlQQ3ZhK09mV0I4?=
 =?utf-8?B?ZHhmd3E1OHc1MktlMmVLSE92N0JnVUxna3ovalAwaDdkRVFBYzRYSURBNFNk?=
 =?utf-8?B?V2NuQ2ozYzZsUDJsTFZaeFJDYy9ORW1NeUtDWklRTnp5Q3FMQmxNMGsyLzlJ?=
 =?utf-8?B?eHRqZjB0V0gyZXREVkU3akF3bkJ3TkM0MEpxUWYzR3VhamZ5dUIrVHpIdmNQ?=
 =?utf-8?B?V2VOMHZ6bURtZmx6Y3FzVnB6RWR6cUloUWpzMFc2RXRtKzd2bGNLZm9ML1pz?=
 =?utf-8?B?bTZIOTRJVWNUU3psS0ZpcEdoZ0Z1anl4cW43UmNhaVBsVVFoalhMZFQ3bWM2?=
 =?utf-8?B?UUJ5UmhBQmRVbnJaZkZVTXc4alNRRlZjSjVYRmx0bDdESkM2M0hQaXg1Rnli?=
 =?utf-8?B?R1JlL3dNWmRjR250cXE0R01PNHViMVJJSk91Nkt0WEs2cEVjUU9YUEw5eHlD?=
 =?utf-8?B?aE9DT0N5SlhhZVE2a1ozY0RGaUlDU3V3OEtHK2Z6eEc4YUtoWCtVS2x3VG9C?=
 =?utf-8?B?OHRQNGVoOFUvV3ZtdkFhdUN2MWNqcFZLMGpHRlFBZ0prMVY0L3NaTndOdWhQ?=
 =?utf-8?B?ZG4vNjcxUUJPSTlqeTlHUHJzRG9PRTd4RlUvODhTSkkra1Nmb0pRa3E4TFhU?=
 =?utf-8?B?ajhuakxIb2RlK2t5elduUmcvMXh0Y2ZpeU40UVNQUlh0R0Zja2FKaW0yU0l1?=
 =?utf-8?B?V2FINmxBemVYOEFKajJNZHBORWtMWStEQ2RxTm1iWDZQOW9jZ0VFTUFIL2M1?=
 =?utf-8?B?NmtQM2hURDJzQkY5UVAvYWxudUJGZWppZWt6RkF3aUFOMThHdEk2ZXhmUEZx?=
 =?utf-8?B?bVBRKy9LV016YTB3YWR5eS81Y2E3bksxTC9DY1luUXlCNUlPeXJ2TkRrS2x2?=
 =?utf-8?B?Q2E2d1k2Tmh1MFc0K3BKOXFwNmNVVHJtekExYWQrQjBPbXc0RlNHSkR6emZx?=
 =?utf-8?B?aXFUTlpXQUtFNVRoTUpKM3lScUJrRkJlMm0zNjRXY045OFN2dVRaUWdydkVz?=
 =?utf-8?B?bTJzT1BDVVVvZlZJZGdSVFhxUjZqMHE4TUNPbXo4RzgrQkR4SWNQdnhQTDJQ?=
 =?utf-8?B?eTY4bUpLRnVpeW9pbm91MERZQ0pCNGRDM01FdHB4MFVoR3hDTXRQdTZCL2Jt?=
 =?utf-8?B?eUVLNkVaNW8vY1kxdDRVbEludHlCZitPaTEzRmd5d0Yva1hUN3I5ZXAzQTJ4?=
 =?utf-8?B?V3Zmc3h1bzg1U09LS3E3dTBqSC9HZmdiUHlIcjF5Sk5OaWJ4NU1ZblRGNW1w?=
 =?utf-8?B?ZnkzYjZnbGVQYjFvYkg0OXhnVnVrbzcxS3NMeEpBbjg4RldtWGJURHliUmps?=
 =?utf-8?B?N2R1QzZWd1o2YkNLNktqampRL0ZDQnh1N2dCc1JkMkpWbEgyNGxuZENTUlBW?=
 =?utf-8?B?cVRFKzdhTUxuZld0QWFZL3JOT01KSUQ2Q2dHeDUycmxxbzdtVk9kK2o0NDho?=
 =?utf-8?B?TkZJbzloT0NGelU2NnBvalV0TE0yWTVyN000dGNIRGtOUUsvWm15Z1krYVV3?=
 =?utf-8?B?WHc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5be88906-93da-4008-8a2d-08dada1ef48e
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4684.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 19:52:51.4921
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v3RiyU2/dqDDZYhzQeMB6YxOiL+7KRwPoLKPrOjfYlsJfvgHgpOEDFljtfI8PEaJsy9O9spSj1kHmYf1Qojmqt11eBRUE2DV9HC9xImrV8g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7301
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-09_11,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212090162
X-Proofpoint-ORIG-GUID: tbn147yR7W0bxAb8A-8IIQqF86gX-rLy
X-Proofpoint-GUID: tbn147yR7W0bxAb8A-8IIQqF86gX-rLy
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/9/2022 2:42 PM, Alex Williamson wrote:
> On Fri, 9 Dec 2022 13:40:29 -0500
> Steven Sistare <steven.sistare@oracle.com> wrote:
> 
>> On 12/8/2022 11:40 AM, Alex Williamson wrote:
>>> On Thu, 8 Dec 2022 07:56:30 +0000
>>> "Tian, Kevin" <kevin.tian@intel.com> wrote:
>>>   
>>>>> From: Alex Williamson <alex.williamson@redhat.com>
>>>>> Sent: Thursday, December 8, 2022 5:45 AM
>>>>>
>>>>> Fix several loose ends relative to reverting support for vaddr removal
>>>>> and update.  Mark feature and ioctl flags as deprecated, restore local
>>>>> variable scope in pin pages, remove remaining support in the mapping
>>>>> code.
>>>>>
>>>>> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
>>>>> ---
>>>>>
>>>>> This applies on top of Steve's patch[1] to fully remove and deprecate
>>>>> this feature in the short term, following the same methodology we used
>>>>> for the v1 migration interface removal.  The intention would be to pick
>>>>> Steve's patch and this follow-on for v6.2 given that existing support
>>>>> exposes vulnerabilities and no known upstream userspaces make use of
>>>>> this feature.
>>>>>
>>>>> [1]https://lore.kernel.org/all/1670363753-249738-2-git-send-email-
>>>>> steven.sistare@oracle.com/
>>>>>     
>>>>
>>>> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
>>>>
>>>> btw given the exposure and no known upstream usage should this be
>>>> also pushed to stable kernels?  
>>>
>>> I'll add to both:
>>>
>>> Cc: stable@vger.kernel.org # v5.12+  
>>
>> We maintain and use a version of qemu that contains the live update patches,
>> and requires these kernel interfaces. Other companies are also experimenting 
>> with it.  Please do not remove it from stable.
> 
> The interface has been determined to have vulnerabilities and the
> proposal to resolve those vulnerabilities is to implement a new API.
> If we think it's worthwhile to remove the existing, vulnerable interface
> in the current kernel, what makes it safe to keep it for stable kernels?

I do not think it's worth while, but I have stopped fighting for 6.2.

> Existing users that could choose not to accept the revert in their
> downstream kernel and allowing users evaluating the interface more time
> before they know it's been removed upstream, are not terribly
> compelling reasons to keep it in upstream stable kernels.  Thanks,

The compelling reason is that stable is supposed to be stable and maintain
existing interfaces, and now I will need to re-merge the interfaces at
regular intervals when we update UEK from stable. Oracle is a current user 
of these interfaces in our business. Do we count?

- Steve
