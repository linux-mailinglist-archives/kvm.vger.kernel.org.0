Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D18435F8DB8
	for <lists+kvm@lfdr.de>; Sun,  9 Oct 2022 21:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbiJITbG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 Oct 2022 15:31:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbiJITbE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 9 Oct 2022 15:31:04 -0400
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B68971C40E
        for <kvm@vger.kernel.org>; Sun,  9 Oct 2022 12:31:03 -0700 (PDT)
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 299Bainn004643;
        Sun, 9 Oct 2022 12:30:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=i1XBylVpYrzUSmG9+jLfRMSpLmjnySOFfcnaG2g3JUc=;
 b=pnH3cKqdUxqs7LsAfTRVKwo4sSg8MxCa4WFEMvK1utf5Nmof7t+5vh4PM41w+OCQ3WsM
 UyfM0n/2w21KaGTLduVylvfbDrsnDQFQZ0wxkJnxRk4fD2yV2IBIm/P3fTcyayFuKjgj
 YUFskVcEGidNWvnTvoPdk0YJkQeFRTYJvKlXXZwEarfGtjmCgTbUSIqL6L2E8QVGUt/H
 ZpkEjBE5zccJXpCwxPi5Gdzk5+sku+cSKLfK+NkUXOJpgarqUyRqry6T1dto16lMx8PT
 8JXuXayvYgjX/jYGdPToMZ9Jm/Hd2/n5koZQfUm29DYM2Nb3UjO+vomimi3Wtk/mJkY1 rw== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3k3546tdd5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 09 Oct 2022 12:30:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hIKqH/v6yztPcUalz7yLHqKR3F5Ki444v6sL1F961heC6nH9YyAURi1z+nZrpY9q/5zATO9B4giYn6fk0IjEdmY+fQtXTL1r+lZ5tWuo4/7POqHLoLCCHctupx3rv1bxBJ/w6KxobJBz8lvmeYACX0G6KlcZsmqGK1SjobcVNLc7EOW69fGxC759G0fptY/akcOckGg6B9AcgB/o0ht2VyxcihJ0YX7iiAm/u8PwXiKjWtU1hhq9+9KYV7b5J0Fiql2cK7ncpw4IMgfDilZ7rzjQPObPWoWUPmElJRxfVWR2CBIH6Vp7JxATRS9mM+HtFXxHS/gzr1N5bqhddPl73A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i1XBylVpYrzUSmG9+jLfRMSpLmjnySOFfcnaG2g3JUc=;
 b=jk5GJNNcUvDTQvd1Gjr0j9XnLQ0DgCEQhhJY4ztbRxsY8GdT+tIXuLkHVosOt5DLzJO+8grGxidviN2Znjzr/TP/4Vs9K0799GZPxQjiL03cPvtQIXyVq1fLu+VoxymyNssHAuFLWj5x+PS6M/z8jDrlvqNvBxnwJyxMErkSFC3nU/3D2N5glQhcegZ7CtE0znaaefPk7Z/8jmrl93xuUCBOa4JdkLtuFzovCTrk6MoGBvALKYyc4tIUasWLhrHU3YZcni2nc11XXZXu8C5pmn8LAdo4+ST0KrkSsexfZPjwWjlYgy171NPC/wl2QcpUdJgUzgelauiXqWrBRk1FJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by CY5PR02MB8894.namprd02.prod.outlook.com (2603:10b6:930:3e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.32; Sun, 9 Oct
 2022 19:30:42 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::c0a5:1300:e72c:46b2]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::c0a5:1300:e72c:46b2%5]) with mapi id 15.20.5709.015; Sun, 9 Oct 2022
 19:30:42 +0000
Message-ID: <2ed78bab-0d6e-3f1b-10b4-5a4cea502a43@nutanix.com>
Date:   Mon, 10 Oct 2022 01:00:31 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH v6 1/5] KVM: Implement dirty quota-based throttling of
 vcpus
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, james.morse@arm.com,
        borntraeger@linux.ibm.com, david@redhat.com, kvm@vger.kernel.org,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
References: <20220915101049.187325-1-shivam.kumar1@nutanix.com>
 <20220915101049.187325-2-shivam.kumar1@nutanix.com>
 <Y0B5RFI25TotwWHT@google.com>
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
In-Reply-To: <Y0B5RFI25TotwWHT@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0040.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:81::9) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR02MB7555:EE_|CY5PR02MB8894:EE_
X-MS-Office365-Filtering-Correlation-Id: d84eb5f2-04a5-428a-9d47-08daaa2cc12d
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t6rRtvrLvrF4lYs+kl8/zxd4Jw7KdRMGYiMXoDPLQYrodfrQlrgprPkcxdzAFcfCIc8TwKZluEwNEr76+bf+wxNZkMSP7h9gkp8CJ0DVnAblqlrcM7UIo1Gh1EQjG18EjpjLwgPWdcdh2ObNid8oO6uSacfiQi4jRSuirMe2cf6JFyW2rmR/j4aFZu7kBCowMv70MyVMakJwRpwVZGw2Iv3WZo5umECYzv5i/Cci21Ev0qivujvqc5YW2caLiO19nZJi4QVtLTlmi6E9SsojH/e1uS2Z+8ac9JcaPHx6hjmXAOHcwKnwAObzqpdfkZUlLGCt/ShL0Jwv5Tq7tqfWBBgY/bUcqr9Zmp7wnU5tzNRNco4+l2KmPYcCMYRwrNoqTzNFA39BO7M45yqGdjbuBa/h509rHYen0IBr9gknESD5mxGY+XdpyAZ2BggHsRC8nfnvHWh/7+QVpwI6dNZ2hZB6AUEpxUcC41R/X+FrwuBZ4lfC7bvBBwVyYwMjNzuLcN/aelqzfSIe7/JE6lBk2hXp5AAU6u9WUXoFvv8xVlA/PM8PykNmjRj+zm8JnvTvu9uN/n1KoHPE4eWGAN+X854lBRaY6hzXiDAAeWyFTv+L+fgUgZPrT4KKI4tWP0olDAr5+KkDetMAfYdXbOn8TOxCClzcsczGbNoNii76LSfgm/XbdwM1hhm8UQxNXE2/Gg9Jo+grO5DKHRRQywlULx7igwNNLc2TwzdoQI66HWczYgOZP1y7SGRgLWEuqokjt5r/Leo5gYpDc8PBV8nL7fgwo7xe/k9PqPZjMqfFYebVnigvOy4KqXrPrOwDNZJEslYtPYvUQZVn5riUTYzdaG+JaCyuWqzg0035lQmS21kqYj/il+fQIut1HVD4D66g1Vkfk7WK9iimByZvIaEFgLSEGi0QP7ltszd5it7hjWk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(366004)(136003)(39850400004)(346002)(451199015)(8936002)(8676002)(6666004)(2616005)(6512007)(186003)(26005)(966005)(36756003)(5660300002)(53546011)(2906002)(66946007)(66476007)(41300700001)(107886003)(66556008)(15650500001)(6506007)(4326008)(83380400001)(6486002)(6916009)(86362001)(316002)(38100700002)(31696002)(478600001)(31686004)(54906003)(14143004)(45980500001)(43740500002)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dHBUYnh2NXRkRGFvbWdEWGJXbTZTLzVZc0hLbFZoQis3K25xR3VLREdDa3Zk?=
 =?utf-8?B?YjdIUG9oMmsvYWNQN0NxUCtiZXN3N096OTdUS01LR2FqKzYybFVyb2JQNGUy?=
 =?utf-8?B?OUFPUHMwTzBsYjlRZDdrU3JUMi9MamJLK2gyUXVhRWhoVXVvNG9MSnc5UGhz?=
 =?utf-8?B?WFBzVkhER2Iva2d1U2NoWS9RbTA4WTNHdU8xZ1cyb0JKMHdpWkNCNk9KRW9X?=
 =?utf-8?B?UUxrMXJtUXZ6c3RkWDNYMkc5cUUyanVFeWxmeTFUTVVwUjRHalRLSXZteG12?=
 =?utf-8?B?QTh5TjVlWmpqVWV2WkpvcS9BK2tldWRRaFp5SzBPOW45SlRVa2JhQmhKTkts?=
 =?utf-8?B?VW92UytIZ0dSa1pzY0o0NWZLaW5kb2pjOE10WEE0a1VlL0g4eVFSMVJqV0U0?=
 =?utf-8?B?N3ZXUVdOVEk3TmJ1UThFU2FvaThJem5ISVF3RlcwTC9qMXVxTmVXNmNRUU1h?=
 =?utf-8?B?TSt2bk1UL0FsOVVMbnhSS2tyVlhLOTgraXZqczRIcTlFcUdiWkVqVy9mZGpW?=
 =?utf-8?B?MWZXMEpNeUYrZDdVcG0xMGQ4UStGZUIwVC95TC9yeE1tQ051Q3JGUk9lc0RR?=
 =?utf-8?B?ZGNjbS8xU3RFVVE4ZllYWHRrTDUxRDA4cGN1WlgrcjBTNGliTzJIVkFjT0E5?=
 =?utf-8?B?azd1SWh1ZmwwVjFCRnpSU3JqbmJudG93ZXBvMTYwZmVBS0JNRVpVRWhkM1Uy?=
 =?utf-8?B?RkY5enZGWjJ5enhNd21UYnVnSENseEFBd21XM0ZKV1JhbGpDcTB3dFAwR3Fs?=
 =?utf-8?B?U0llUmcwRlB3aW9UaW1GbEtNTmtndHVHRlp2TENzSTRlOG1MT3lodVBJWDV3?=
 =?utf-8?B?QXJJUUZ0andkOXdOY2RRbDFMS1pBWXJjNGY0QWZRWG9pZzdXYXZsT0tQUC9J?=
 =?utf-8?B?dmUzK051ekF6SGM3TEVMOXJQZ1dEMkd1YkI1VnNEQTlDT3AwNm9jWFRNblll?=
 =?utf-8?B?ZmhpQ1NEc3hTdkF1ZC9abWFGbzQ5eUdkMHF1MVNqRjV4WldVbGlhakpMVjVK?=
 =?utf-8?B?aXh5c2Vvci9JYmpCcmJKYm1kNElTaExwWWczZGlFUFNzZ292K1UwL2tlbDJK?=
 =?utf-8?B?ei9wWUFkdzF5a3ZxSjcxeG5GWG0vK0ZQV1cvQWdtbmpUd0JaTmx5LzJSZGRY?=
 =?utf-8?B?Y1ExazhFMEkxL25HNWpic0I1U25uQ1dkZUJOcURDd3JBNHJPcHYrSE1Tbzdz?=
 =?utf-8?B?NlJ0YjBOaEg4c0R4czI5b1dhSDc1bXlvQ2RmY1N4d0pER1JjdUJLQW9DOU9H?=
 =?utf-8?B?Uno2ZjFsM0VRaFBOc0dheDFsek1iRVpySWtnRFlzeFBpbDNuUlhrM21BTkFP?=
 =?utf-8?B?OEZBUkh3bUlmUWRvS0w3aFc0R1dmV1ZJTG1wSkVZN09GRkZoTjFuZ2NSS2xN?=
 =?utf-8?B?NTg5Tmx4VEJweWpDdjhDWTkvU2JwOTFCaXVVNy8zcElabWgrYUR3MHZvSHJn?=
 =?utf-8?B?dGx5cVNMZzVBY2JDckpWWDkvbENsLzFtR2J2WURoU3dNOHczU25OQzFQQi9a?=
 =?utf-8?B?UG5iem11WjhRUFc5T1ZGTm85YUFEaFZwQVMyZWU0OGF5dG1kT2JSbkJ1Nklp?=
 =?utf-8?B?RTRDeTFNTXBmTVlXYmxLUFpYY25PeFg5L1BtSCtLNWVKODR3cmF4bmp4Z3JR?=
 =?utf-8?B?MHVpY1dxZ1kzYkM1ZGZWK0FHeFM4bEo3NnZXMFQvMlprV1BYeWFmTEJzZDE2?=
 =?utf-8?B?UHl4eW9lRGF0b2xMRm5GZGs4VnZDUFB2dnN0cmdtdWcrSnJIUFZYUFB0Rk1k?=
 =?utf-8?B?U0xZUlF3OWQ1ZEtRQU4vbkkwY1VXa0x2RW9yL3VyVUpNOEJ5UkN2NmxPanF3?=
 =?utf-8?B?UGRBclNNTEkzVm00SU05NmhFZWp1ME1oZ2xWL1VNY3pJRDJLSXNJTXBnamc3?=
 =?utf-8?B?Q2JvOW1OamFFdDhPakZaVmV1ZDdQUEFCdFM5N3VLN1huVk15dHFkdmFQczNB?=
 =?utf-8?B?Z0ppbFBpckNoQktxN254KzNRQUMxSnorZElHQk90YzF1d0ZvalNOdW5UVU0w?=
 =?utf-8?B?UnB2QTF5bFVGQklOdk5YNGloKytHcUVBeDNyMG4wMDBLUzl2TGQ2bHFCUEE4?=
 =?utf-8?B?ZlMrZnJGbkdiaUkvRFRoSWJEUVFsNXZSRHpnV25pY2hCemhMcWFlcll6TnVv?=
 =?utf-8?B?eFB3OThvKzhPK3kwbjNuaVdTdlR6REo4RWFnYzVHdEU4S0hyWlJDcHM0MURD?=
 =?utf-8?B?Y0E9PQ==?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d84eb5f2-04a5-428a-9d47-08daaa2cc12d
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2022 19:30:42.6527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aZ0NYPgNvwdBJz0dfWStwHdwiTBDVVhorJqfBOdrzpvavc+hkGQJ8gkk4UCGhjNnE+aRLqH/CMwuRhUXRo4+moKdQ9nMQtWQ6LLDErSgAZM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR02MB8894
X-Proofpoint-ORIG-GUID: -LxeitC9wI1HVVfaF0TvVyzg7soU2q5n
X-Proofpoint-GUID: -LxeitC9wI1HVVfaF0TvVyzg7soU2q5n
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-07_04,2022-10-07_01,2022-06-22_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 08/10/22 12:38 am, Sean Christopherson wrote:
> On Thu, Sep 15, 2022, Shivam Kumar wrote:
>> @@ -542,6 +545,21 @@ static inline int kvm_vcpu_exiting_guest_mode(struct kvm_vcpu *vcpu)
>>   	return cmpxchg(&vcpu->mode, IN_GUEST_MODE, EXITING_GUEST_MODE);
>>   }
>>   
>> +static inline int kvm_vcpu_check_dirty_quota(struct kvm_vcpu *vcpu)
>> +{
>> +	struct kvm_run *run = vcpu->run;
>> +	u64 dirty_quota = READ_ONCE(run->dirty_quota);
>> +	u64 pages_dirtied = vcpu->stat.generic.pages_dirtied;
>> +
>> +	if (!dirty_quota || (pages_dirtied < dirty_quota))
>> +		return 1;
>> +
>> +	run->exit_reason = KVM_EXIT_DIRTY_QUOTA_EXHAUSTED;
>> +	run->dirty_quota_exit.count = pages_dirtied;
>> +	run->dirty_quota_exit.quota = dirty_quota;
>> +	return 0;
> 
> Dead code.
> 
>> +}
> 
> ...
> 
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index 584a5bab3af3..f315af50037d 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -3298,18 +3298,36 @@ int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len)
>>   }
>>   EXPORT_SYMBOL_GPL(kvm_clear_guest);
>>   
>> +static void kvm_vcpu_is_dirty_quota_exhausted(struct kvm_vcpu *vcpu)
> 
> Ouch, sorry.  I suspect you got this name from me[*].  That was a goof on my end,
> I'm 99% certain I copy-pasted stale code, i.e. didn't intended to suggest a
> rename.
> 
> Let's keep kvm_vcpu_check_dirty_quota(), IMO that's still the least awful name.
> 
> [*] https://urldefense.proofpoint.com/v2/url?u=https-3A__lore.kernel.org_all_Yo-2B82LjHSOdyxKzT-40google.com&d=DwIBAg&c=s883GpUCOChKOHiocYtGcg&r=4hVFP4-J13xyn-OcN0apTCh8iKZRosf5OJTQePXBMB8&m=IIED7C8bZGKU5CadTcY5IR4yLs79Rsv2HVHCn5FIL8TQpiAbpjEBs97euDE3FFZf&s=WyikNnoMe8QzP5dTKKectMN-uxc_fTby1FlKVAaS7zI&e=
> 
>> +{
>> +	u64 dirty_quota = READ_ONCE(vcpu->run->dirty_quota);
>> +
>> +	if (!dirty_quota || (vcpu->stat.generic.pages_dirtied < dirty_quota))
>> +		return;
>> +
>> +	/*
>> +	 * Snapshot the quota to report it to userspace.  The dirty count will be
>> +	 * captured when the request is processed.
>> +	 */
>> +	vcpu->dirty_quota = dirty_quota;
>> +	kvm_make_request(KVM_REQ_DIRTY_QUOTA_EXIT, vcpu);
> 
> Making the request needs to be guarded with an arch opt-in.  Pending requests
> prevent KVM from entering the guest, and so making a request that an arch isn't
> aware of will effectively hang the vCPU.  Obviously userspace would be shooting
> itself in the foot by setting run->dirty_quota in this case, but KVM shouldn't
> hand userspace a loaded gun and help them aim.
> 
> My suggestion from v1[*] about not forcing architectures to opt-in was in the
> context of a request-less implementation where dirty_quota was a nop until the
> arch took action.
> 
> And regardless of arch opt-in, I think this needs a capability so that userspace
> can detect KVM support.
> 
> I don't see any reason to wrap the request or vcpu_run field, e.g. something like
> this should suffice:
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index ea5847d22aff..93362441215b 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3298,8 +3298,9 @@ int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len)
>   }
>   EXPORT_SYMBOL_GPL(kvm_clear_guest);
>   
> -static void kvm_vcpu_is_dirty_quota_exhausted(struct kvm_vcpu *vcpu)
> +static void kvm_vcpu_check_dirty_quota(struct kvm_vcpu *vcpu)
>   {
> +#ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
>          u64 dirty_quota = READ_ONCE(vcpu->run->dirty_quota);
>   
>          if (!dirty_quota || (vcpu->stat.generic.pages_dirtied < dirty_quota))
> @@ -3311,6 +3312,7 @@ static void kvm_vcpu_is_dirty_quota_exhausted(struct kvm_vcpu *vcpu)
>           */
>          vcpu->dirty_quota = dirty_quota;
>          kvm_make_request(KVM_REQ_DIRTY_QUOTA_EXIT, vcpu);
> +#endif
>   }
>   
>   void mark_page_dirty_in_slot(struct kvm *kvm,
> @@ -4507,6 +4509,8 @@ static long kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
>          case KVM_CAP_BINARY_STATS_FD:
>          case KVM_CAP_SYSTEM_EVENT_DATA:
>                  return 1;
> +       case KVM_CAP_DIRTY_QUOTA:
> +               return !!IS_ENABLED(CONFIG_HAVE_KVM_DIRTY_QUOTA);
>          default:
>                  break;
>          }
> 
> 
> [*] https://urldefense.proofpoint.com/v2/url?u=https-3A__lore.kernel.org_all_YZaUENi0ZyQi-252F9M0-40google.com&d=DwIBAg&c=s883GpUCOChKOHiocYtGcg&r=4hVFP4-J13xyn-OcN0apTCh8iKZRosf5OJTQePXBMB8&m=IIED7C8bZGKU5CadTcY5IR4yLs79Rsv2HVHCn5FIL8TQpiAbpjEBs97euDE3FFZf&s=kbNeQcRDxAxx4SEPIe_tL-_1dYMa9zx-REEozKvO0w0&e=

Will add. Thank you so much for the comments.
