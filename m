Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0EBD534C8D
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 11:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346874AbiEZJdf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 05:33:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346118AbiEZJdd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 05:33:33 -0400
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19EA3C8BDD
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 02:33:31 -0700 (PDT)
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24Q4HUmk013139;
        Thu, 26 May 2022 02:33:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=JVZLDpGRuddHW/7j/mX5WABwIvYs89rZufv6I99J3Xk=;
 b=VcdPWiwTGktShCgTfqGoKCgDZ5foCKXtbH1nVHAeRR983lbEzN6L9RbCxaOMRE+ZPgji
 WNt2pZZnKOyX6fp/seruclxAELBdQHs2StqldKekg61wfKvFnLuSrBVhtw5bB0V6vNfD
 E/LkCQIam8XxYo/z32HSl2W+/j2gksBXEguvlYG1X5CCnPIAGrPVWdI0t9MogolBps5y
 JDP0xTbE3M4IDhJD5StRwFJEgsLWXxALu4R+FAxsCRIzpJ5Z0EoUI4C5OKnSpaheXnYF
 6LxR87mD8970U4mNZHKIkLE74kruolpEAP+KKAV+H1XyCJk3moYrEpflReUFDI+EQrbd 0w== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3g93uwm4ec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 May 2022 02:33:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=myM1LClKCqFOfgmjRW7RTEkJvWmxsBxcAnIFfm3qZv72PsvFs/BpKU5GBTZthGRRn6Ki4iwBC1Fmd6nuFqKK6/oSxT3V3ep69vYMYMqb/4yqnwsaLuHLmpksosNE4hOWth3O3OHqJmT5Eq/NjOhsEWxNspaDXP6t9I0SdtZ8/GgxAfi4R56RwwXHys6rLoPor853+l0uQ47yLs2e1CYkKTCZHp+eUJNIH2QlI2zRLJauZVPP+5s/E55JKtkcmCXDC+e7XDx4CABaE1wT6/jg/l8pb2T+hRNosDqVctR3VnaejvqMtWQo1vod+/Vrjvylkfgoddp0BibcsnyGUg+ArA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JVZLDpGRuddHW/7j/mX5WABwIvYs89rZufv6I99J3Xk=;
 b=Ork3dMV2KnLTgRWrLD9NtDZ885Ja29zoauZhr/YygT9nQ9KnNWXAEF/5opDkNtAEtXwJGU7SV93a6sSkvkwVIyhCghNM6Ulj7UKYURiaingj/kFH37I4vEg20eU2k4H+rANNwCVlO2p3U1XIl3G/wflLVLI2offBWtr/taNwKVQbRYT82OaHROWobXFwxvJSy87DxyQ31w2Azq5XFTdu8vH6kkhfxaUIbQoS7o8bhlzOP0hhQ1Px6E+bLjX6vj4rClVL8b/DpIwanqlG6RiZ5nCulArQ8rzDARQEgmW5G99A4Ffgy0YRictw91qnYxJv4avpu3r8BvgJ2k67A99WgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by BYAPR02MB5095.namprd02.prod.outlook.com (2603:10b6:a03:70::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.16; Thu, 26 May
 2022 09:33:16 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::6819:797c:706f:9a01]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::6819:797c:706f:9a01%6]) with mapi id 15.20.5293.013; Thu, 26 May 2022
 09:33:16 +0000
Message-ID: <bf24e007-23fd-2582-ec0c-5e79ab0c7d56@nutanix.com>
Date:   Thu, 26 May 2022 15:03:04 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH v4 1/4] KVM: Implement dirty quota-based throttling of
 vcpus
To:     Marc Zyngier <maz@kernel.org>
Cc:     pbonzini@redhat.com, seanjc@google.com, james.morse@arm.com,
        borntraeger@linux.ibm.com, david@redhat.com, kvm@vger.kernel.org,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
References: <20220521202937.184189-1-shivam.kumar1@nutanix.com>
 <20220521202937.184189-2-shivam.kumar1@nutanix.com>
 <87h75fmmkj.wl-maz@kernel.org>
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
In-Reply-To: <87h75fmmkj.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA1PR0101CA0061.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::23) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0f441662-1ebb-4bd6-c769-08da3efac302
X-MS-TrafficTypeDiagnostic: BYAPR02MB5095:EE_
X-Microsoft-Antispam-PRVS: <BYAPR02MB5095632CF0DBA7F7A7B48923B3D99@BYAPR02MB5095.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F8OhjgaazkGKhes9jsNlQMvVGqjFdBuXwCfOfkaiSaWdWyLpPBTeOr5XwOnnAZkd7T0LZFbWfHS4TqYNtICt9nwblKZ5h2xkzPwiXRK864X3q3jKBWQuLQx/NiaBBhql9lMbmH3+Kcc8JC9nH5iQEueP0SqODVh9qbFbNVCtoTL6TC1S4xQnQ6fRmIKxuZR+D4vp+Syi+f5gPFSAISGyXdIy4NH4NVtejJUJGe7BNxfZmPrqKV85m7aAVgwGBR0uLECVVmK4MLuOku31j8sqQSLfRCIlzhpEKdop0Mm9/QrVkKMPXrVdQ9M6/8+TtpUvZQfoP29J4Vaq7h3joxzFE7deBDFlK3dl/VIC5MB3HtMCXqOgEeG9v9PmwLwwRVjPyJQcnkbTkeH+8cFuEEelfi4pMLvfR58dw3hyYLZKdtRrX/rQV1neDFt30gloH2SioQ5BtW9A99idsgyvDZZCh9kZUYn5GXKuyC6Aahv0BKTyFk3rl59wIeAglY3ef2zQcevage8Yf/EBJTQP6S8Vze+xNDBuaQJ6V1o90dIg++YKytrxCKQQZjsR8bu0fth+bIAHXT7uFlARqPAUK9TjQUcq7SZMK06zY+xN8jll8SoquKpwCn6Xyei1fgmAf1M4+pUaiidaRaH+Sqs74hiFGRnTiVAJFJiwj5ehwjSgLzoZG7RHkpY3EX7iPIN6IDgu2hbpD1caU8KKQSCfb/kuYGGTOd0zleoNGEfw+t4NoNi2zD1K7Rs6B7qtcmV8N5xZdmw9Rj6PWRdRI5koRxW4LNividfMM2iCeRKZIUyXgwQ3mxhhcW70n26TB5O+MXD47+bDwOjWZJlkJcpTJrG4FQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2616005)(6916009)(316002)(54906003)(26005)(83380400001)(107886003)(6506007)(55236004)(186003)(53546011)(31686004)(36756003)(6486002)(966005)(508600001)(8936002)(8676002)(86362001)(5660300002)(4326008)(66476007)(66556008)(66946007)(2906002)(38100700002)(6666004)(15650500001)(31696002)(6512007)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bms4M2IzbXFwWkl5bVZuWi9nTVJHYXVha1dKVlIzbFNERWFQVnRucnphZVhV?=
 =?utf-8?B?LzBENjZYd2JQbVZaWjhrL0VybGxGTUswazBTYTVDZmRkVTNabzZyL0haUmtW?=
 =?utf-8?B?blR2NUJ6aERObk0waXhmbDlpWExmbnhtZzB3S3A3eSsrMGdSUE9xSVRSaXFN?=
 =?utf-8?B?RHZDdGIyLytkc2lFRm5FTFNCYXlwR3FaQVhXb2NDQVJYYkliRENLNlAzM2xS?=
 =?utf-8?B?TEIxR2hpYk1JaGhzemwyaWNuR0hrMmx2UHNQV2xEOHgxWHg4Ukt3ZVp3M24w?=
 =?utf-8?B?ZlZwZHFhS0lDTUNISTdlSmVlblRNTVFCZ0tGbmxqeTMweXJnbHZIdkNHL3RZ?=
 =?utf-8?B?WWhBdy9DOVUxQlhiSnpFSFgxaGkvc2x5dk1IbkxWMVNkR2wrNXNlYzJ1VGx6?=
 =?utf-8?B?VXFqY0pWQms2TldmaEF3V0FVWmdYaGZOU29UMUpJeHR6TDFkc1JmbStFWGY1?=
 =?utf-8?B?MHZjbVB3YnNxbk50K3k1aG5BYkZUTkhuNXZoVU4vUEtXYlJxNWQwZXdlN3la?=
 =?utf-8?B?S1hQUXJBV0RnYVRaV1hDMGhNamVkLzRicXFtb2MreUN1R2M5cDE3VUxKbk1P?=
 =?utf-8?B?Q1FlanhXYms2R3FKeUY0dXQ3VGhKNzQzeU1mSTc3Vi9JZCtiZHNIVUVndEpQ?=
 =?utf-8?B?VmhwazhlS0J4TXl3TXl0cnhWOFNyR1NFY2xIM3gwM2hRcGZtckh5VDhoN2tZ?=
 =?utf-8?B?SmRidmxSVVJWYVFZblZnZkkvWVQ0dnhtM2ovYjc1b2xrayt1L0gwNkp5d2Ju?=
 =?utf-8?B?K3hiRVlqSEkrcW9zK2VpU3BsMTVvS0pLN1grWWRBWUZVUE43OGMzSUs0alJJ?=
 =?utf-8?B?ZWFoNi9YYWpRN3lSMUJHL1B2QXhnT3hqSEV2OGRBc1lYS2VROGxvQ3greWJk?=
 =?utf-8?B?Y1lJTUFSSHYzTnBiWXJSM0ZXVXk0OThuRXhPcytNMkh1MFNQV2VTZmNkOEg0?=
 =?utf-8?B?d2VETGpnOHBmNTJoY3d2MkZuUzAxV1RjM1E5RmpHRlo1eks5RHhxaHBKYzdG?=
 =?utf-8?B?M0ZOWFdPQ2F4eHpGWDc1Zlh2UG9DU0h0VlVHMjJFa21QS1FkcWNkSTN0STJP?=
 =?utf-8?B?VXBmRUkvZkpocjZBcnhEd0RyVndEVzB4RDBHSkxtSkZNa3JNRTBxVTUzWGJ5?=
 =?utf-8?B?NjMreXkyVWp1R1E5WnJnQ2pabldTaGtpNi9RUi9xR0dVTkFrVWUrc2tiZkxV?=
 =?utf-8?B?MXlwM2xMR0gzOFBQWUlncVRrWmZ4V3J3cHUzQmVGa1N2d0QvRG8yUm1yajdV?=
 =?utf-8?B?eUFpYUZhd3J3K0hRQzRoR2J3Q1lRcHJOblR4V0FXNGhIZDV4VUNIS0VaempM?=
 =?utf-8?B?NjVlNUx0WGpKV0ZWQzdERnViWXhkYTFFSzBvY0NCaE1OZyt3SWhSWUtwMHd3?=
 =?utf-8?B?T0tURjRwNVUvYVhaL2E3ajZJMHhPVkMxZXV0UGs5SGdwZUU0UTZSR3BYb0FK?=
 =?utf-8?B?emhVSWtMMEdTTXlaazBnMmhob012R1pacy9LazdiaHF6QjNTR2JXMzhoUGVq?=
 =?utf-8?B?MUgvSXZQS3lWN28xemxjbEtsb25BZDFRN2xzOFdqaDNkWWJhVEVGNmRTcTly?=
 =?utf-8?B?OGtoVFBoeGFKbENCQitrUWdYajY2YjE5T2VraUF0Ujlzd0NCUGJqdWlsVEpp?=
 =?utf-8?B?emNWREdiQnR1YzZRdTEwNXZVbEEva3lMdVpQNUlMc09OTFoxVXJibVlJbUlU?=
 =?utf-8?B?MXN3RlZzOTd0UkFjYXRCRHVjZ2JCY0lveXFjdU5qSHRBbllkOEpvWGp3THpz?=
 =?utf-8?B?NVpkOGJUS1c5OG9GWGJIWTQ4aDZIV0loUmprTmV5VzRqZzNLNzUwblVsbXhr?=
 =?utf-8?B?d0kwSDVBTVJ3RGdEZzR5N0d3dVFibWp0SjhEZ2JUZzRIUFJhZzh1cTZQRTVF?=
 =?utf-8?B?YU9qWnVxRVFmZ0had3Y2Q0laYWVERE1JMjl4UUpFcHRyZVFyTmJjMHNGOHor?=
 =?utf-8?B?Mk1zVXlqczJzK0NuZDJoS2pMWXFzeTBhTTJHMkhTZjRoVjB0RzN0djZ0UTBC?=
 =?utf-8?B?TmV3eWxqS2ErMjROWDN5UGNnYWdJMmJqMVlnYVExZXBWeFdLeVV0T1VDcFVI?=
 =?utf-8?B?N1FqWWpNcVA3NlEreGdlUVZrQmVmTTZzQWNIV28wbFFxMmNFaDRRbjV2bXhD?=
 =?utf-8?B?Z3h3VFZEQzQ4UDZWdFFDZEVXbFJJditjQkJjekliUi9mRlVEQnE5WURwTkM4?=
 =?utf-8?B?dWRpT0xlVXlkc3p4a05kc3FIa3RYMDlhdWNXczNpNG56Y2FVRmozbldEY1Bt?=
 =?utf-8?B?a3FsRkN1NlF5a0Q4WTVVV0t5Y0VzdmlFU3l3ODJuZEJNRWxMZWRrb3QwQy9v?=
 =?utf-8?B?a0g5djdJL1BPNlJWN0U3d1pPM2tCakkyQVF2K3ZBREZvaFNtN0hrd2xoQ1ov?=
 =?utf-8?Q?/Ah+L3t4IOORF3kk=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f441662-1ebb-4bd6-c769-08da3efac302
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2022 09:33:16.2394
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y46k7WPtUvxhNqoh5XHeSiAklOhEf2hqwcm5MIJCqA+Itz12vnlF/5uqVlBpW9mo//j7u6ZnWb5ptcUBb6eiCNSpvlmR4OoUiR+jVLBZ+ic=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB5095
X-Proofpoint-GUID: uDjpC0zA5l_UwtKqkLViG7ynUsA8mUme
X-Proofpoint-ORIG-GUID: uDjpC0zA5l_UwtKqkLViG7ynUsA8mUme
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-26_03,2022-05-25_02,2022-02-23_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 24/05/22 12:41 pm, Marc Zyngier wrote:
> On Sat, 21 May 2022 21:29:36 +0100,
> Shivam Kumar <shivam.kumar1@nutanix.com> wrote:
>> Define variables to track and throttle memory dirtying for every vcpu.
>>
>> dirty_count:    Number of pages the vcpu has dirtied since its creation,
>>                  while dirty logging is enabled.
>> dirty_quota:    Number of pages the vcpu is allowed to dirty. To dirty
>>                  more, it needs to request more quota by exiting to
>>                  userspace.
>>
>> Implement the flow for throttling based on dirty quota.
>>
>> i) Increment dirty_count for the vcpu whenever it dirties a page.
>> ii) Exit to userspace whenever the dirty quota is exhausted (i.e. dirty
>> count equals/exceeds dirty quota) to request more dirty quota.
>>
>> Suggested-by: Shaju Abraham <shaju.abraham@nutanix.com>
>> Suggested-by: Manish Mishra <manish.mishra@nutanix.com>
>> Co-developed-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
>> Signed-off-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
>> Signed-off-by: Shivam Kumar <shivam.kumar1@nutanix.com>
>> ---
>>   Documentation/virt/kvm/api.rst | 32 ++++++++++++++++++++++++++++++++
>>   arch/x86/kvm/mmu/spte.c        |  4 ++--
>>   arch/x86/kvm/vmx/vmx.c         |  3 +++
>>   arch/x86/kvm/x86.c             |  4 ++++
> Please split the x86 support in its own patch.
I'd merged the changes into one commit based on the feedback received on 
previous patchsets (as the change is very simple). I hadn't received any 
review from arm and s390 maintainers, so I separated those changes in 
different commits. Thanks.
>
>>   include/linux/kvm_host.h       | 15 +++++++++++++++
>>   include/linux/kvm_types.h      |  1 +
>>   include/uapi/linux/kvm.h       | 12 ++++++++++++
>>   virt/kvm/kvm_main.c            |  7 ++++++-
>>   8 files changed, 75 insertions(+), 3 deletions(-)
>>
>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>> index 9f3172376ec3..a9317ed31d06 100644
>> --- a/Documentation/virt/kvm/api.rst
>> +++ b/Documentation/virt/kvm/api.rst
>> @@ -6125,6 +6125,24 @@ array field represents return values. The userspace should update the return
>>   values of SBI call before resuming the VCPU. For more details on RISC-V SBI
>>   spec refer, https://urldefense.proofpoint.com/v2/url?u=https-3A__github.com_riscv_riscv-2Dsbi-2Ddoc&d=DwIBAg&c=s883GpUCOChKOHiocYtGcg&r=4hVFP4-J13xyn-OcN0apTCh8iKZRosf5OJTQePXBMB8&m=gKJrc6bbnHvyaBs-J8ysjBmGRkXneAgEgVCMrWtZO4xdbqfmX-zF2y68oOWbuSuA&s=YkC-KO05Du0_A2-m3nWatY5ZPzMYoDbcWjI3k95obPQ&e= .
>>   
>> +::
>> +
>> +		/* KVM_EXIT_DIRTY_QUOTA_EXHAUSTED */
>> +		struct {
>> +			__u64 count;
>> +			__u64 quota;
>> +		} dirty_quota_exit;
>> +If exit reason is KVM_EXIT_DIRTY_QUOTA_EXHAUSTED, it indicates that the VCPU has
>> +exhausted its dirty quota. The 'dirty_quota_exit' member of kvm_run structure
>> +makes the following information available to the userspace:
>> +	'count' field: the current count of pages dirtied by the VCPU, can be
>> +        skewed based on the size of the pages accessed by each vCPU.
>> +	'quota' field: the observed dirty quota just before the exit to userspace.
>> +The userspace can design a strategy to allocate the overall scope of dirtying
>> +for the VM among the vcpus. Based on the strategy and the current state of dirty
>> +quota throttling, the userspace can make a decision to either update (increase)
>> +the quota or to put the VCPU to sleep for some time.
>> +
>>   ::
>>   
>>   		/* Fix the size of the union. */
>> @@ -6159,6 +6177,20 @@ values in kvm_run even if the corresponding bit in kvm_dirty_regs is not set.
>>   
>>   ::
>>   
>> +	/*
>> +	 * Number of pages the vCPU is allowed to have dirtied over its entire
>> +	 * lifetime.  KVM_RUN exits with KVM_EXIT_DIRTY_QUOTA_EXHAUSTED if the quota
>> +	 * is reached/exceeded.
>> +	 */
>> +	__u64 dirty_quota;
>> +Please note that enforcing the quota is best effort, as the guest may dirty
>> +multiple pages before KVM can recheck the quota.  However, unless KVM is using
>> +a hardware-based dirty ring buffer, e.g. Intel's Page Modification Logging,
>> +KVM will detect quota exhaustion within a handful of dirtied page.  If a
>> +hardware ring buffer is used, the overrun is bounded by the size of the buffer
>> +(512 entries for PML).
>> +
>> +::
>>     };
>>   
>>   
>> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
>> index 73cfe62fdad1..01f0d2a04796 100644
>> --- a/arch/x86/kvm/mmu/spte.c
>> +++ b/arch/x86/kvm/mmu/spte.c
>> @@ -182,9 +182,9 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>>   		  "spte = 0x%llx, level = %d, rsvd bits = 0x%llx", spte, level,
>>   		  get_rsvd_bits(&vcpu->arch.mmu->shadow_zero_check, spte, level));
>>   
>> -	if ((spte & PT_WRITABLE_MASK) && kvm_slot_dirty_track_enabled(slot)) {
>> +	if (spte & PT_WRITABLE_MASK) {
>>   		/* Enforced by kvm_mmu_hugepage_adjust. */
>> -		WARN_ON(level > PG_LEVEL_4K);
>> +		WARN_ON(level > PG_LEVEL_4K && kvm_slot_dirty_track_enabled(slot));
>>   		mark_page_dirty_in_slot(vcpu->kvm, slot, gfn);
>>   	}
>>   
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index b730d799c26e..5cbe4992692a 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -5507,6 +5507,9 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
>>   		 */
>>   		if (__xfer_to_guest_mode_work_pending())
>>   			return 1;
>> +
>> +		if (!kvm_vcpu_check_dirty_quota(vcpu))
>> +			return 0;
>>   	}
>>   
>>   	return 1;
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index eb4029660bd9..0b35b8cc0274 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -10257,6 +10257,10 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
>>   	vcpu->arch.l1tf_flush_l1d = true;
>>   
>>   	for (;;) {
>> +		r = kvm_vcpu_check_dirty_quota(vcpu);
> I really wonder why this has to be checked on each and every run. Why
> isn't this a request set by the core code instead?
Ack. Thanks.
>
>> +		if (!r)
>> +			break;
>> +
>>   		if (kvm_vcpu_running(vcpu)) {
>>   			r = vcpu_enter_guest(vcpu);
>>   		} else {
>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>> index f11039944c08..ca1ac970a6cf 100644
>> --- a/include/linux/kvm_host.h
>> +++ b/include/linux/kvm_host.h
>> @@ -530,6 +530,21 @@ static inline int kvm_vcpu_exiting_guest_mode(struct kvm_vcpu *vcpu)
>>   	return cmpxchg(&vcpu->mode, IN_GUEST_MODE, EXITING_GUEST_MODE);
>>   }
>>   
>> +static inline int kvm_vcpu_check_dirty_quota(struct kvm_vcpu *vcpu)
> Why is this inline instead of a normal call?
It's a lightweight function and I found similar functions marked inline 
in the code. Thanks.
>> +{
>> +	struct kvm_run *run = vcpu->run;
>> +	u64 dirty_quota = READ_ONCE(run->dirty_quota);
>> +	u64 pages_dirtied = vcpu->stat.generic.pages_dirtied;
>> +
>> +	if (!dirty_quota || (pages_dirtied < dirty_quota))
>> +		return 1;
> What happens when page_dirtied becomes large and dirty_quota has to
> wrap to allow further progress?
Every time the quota is exhausted, userspace is expected to set it to 
pages_dirtied + new quota. So, pages_dirtied will always follow dirty 
quota. I'll be sending the qemu patches soon. Thanks.
>
>> +
>> +	run->exit_reason = KVM_EXIT_DIRTY_QUOTA_EXHAUSTED;
>> +	run->dirty_quota_exit.count = pages_dirtied;
>> +	run->dirty_quota_exit.quota = dirty_quota;
>> +	return 0;
>> +}
>> +
>>   /*
>>    * Some of the bitops functions do not support too long bitmaps.
>>    * This number must be determined not to exceed such limits.
>> diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
>> index dceac12c1ce5..7f42486b0405 100644
>> --- a/include/linux/kvm_types.h
>> +++ b/include/linux/kvm_types.h
>> @@ -106,6 +106,7 @@ struct kvm_vcpu_stat_generic {
>>   	u64 halt_poll_fail_hist[HALT_POLL_HIST_COUNT];
>>   	u64 halt_wait_hist[HALT_POLL_HIST_COUNT];
>>   	u64 blocking;
>> +	u64 pages_dirtied;
>>   };
>>   
>>   #define KVM_STATS_NAME_SIZE	48
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index 507ee1f2aa96..1d9531efe1fb 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -270,6 +270,7 @@ struct kvm_xen_exit {
>>   #define KVM_EXIT_X86_BUS_LOCK     33
>>   #define KVM_EXIT_XEN              34
>>   #define KVM_EXIT_RISCV_SBI        35
>> +#define KVM_EXIT_DIRTY_QUOTA_EXHAUSTED 36
>>   
>>   /* For KVM_EXIT_INTERNAL_ERROR */
>>   /* Emulate instruction failed. */
>> @@ -487,6 +488,11 @@ struct kvm_run {
>>   			unsigned long args[6];
>>   			unsigned long ret[2];
>>   		} riscv_sbi;
>> +		/* KVM_EXIT_DIRTY_QUOTA_EXHAUSTED */
>> +		struct {
>> +			__u64 count;
>> +			__u64 quota;
>> +		} dirty_quota_exit;
>>   		/* Fix the size of the union. */
>>   		char padding[256];
>>   	};
>> @@ -508,6 +514,12 @@ struct kvm_run {
>>   		struct kvm_sync_regs regs;
>>   		char padding[SYNC_REGS_SIZE_BYTES];
>>   	} s;
>> +	/*
>> +	 * Number of pages the vCPU is allowed to have dirtied over its entire
>> +	 * liftime.  KVM_RUN exits with KVM_EXIT_DIRTY_QUOTA_EXHAUSTED if the
> lifetime
Ack. Thanks.
>> +	 * quota is reached/exceeded.
>> +	 */
>> +	__u64 dirty_quota;
> How is the feature detected from userspace? I don't see how it can
> make use of it without knowing about it the first place.
I hope changing the kernel headers would suffice. We had started the 
patch series with a KVM CAP for dirty quota but dropped it as per the 
feedback recieved. Thanks.
>>   };
>>   
>>   /* for KVM_REGISTER_COALESCED_MMIO / KVM_UNREGISTER_COALESCED_MMIO */
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index 0afc016cc54d..041ab464405d 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -3163,7 +3163,12 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
>>   		return;
>>   #endif
>>   
>> -	if (memslot && kvm_slot_dirty_track_enabled(memslot)) {
>> +	if (!memslot)
>> +		return;
>> +
>> +	vcpu->stat.generic.pages_dirtied++;
>> +
>> +	if (kvm_slot_dirty_track_enabled(memslot)) {
>>   		unsigned long rel_gfn = gfn - memslot->base_gfn;
>>   		u32 slot = (memslot->as_id << 16) | memslot->id;
>>   
> Thanks,
>
> 	M.
Thank you so much for the review. Looking forward to further feedback 
and suggestions.

