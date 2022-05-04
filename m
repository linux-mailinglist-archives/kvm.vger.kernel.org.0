Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F028519769
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 08:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344977AbiEDGhx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 02:37:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238996AbiEDGhw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 02:37:52 -0400
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 982D1B7C0
        for <kvm@vger.kernel.org>; Tue,  3 May 2022 23:34:17 -0700 (PDT)
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2443BOA0024101;
        Tue, 3 May 2022 23:34:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=Ovy2STo2Q3Qjy+vhF5PYuWDsyOhKr8KHfo6lbllXaHg=;
 b=q1QihmsYS9qfB2MICOk2HpEq4B5xz2Gmh/fAc/gmxr3nvgLL4VkoOYZlSTIcTh7xTgJX
 lkDu/NEL3BgtznXqzmnDM2ilIiuwg1jnabl2Av01b99E3P6bR/0U7RW0DHnNvOLZ7qEc
 xFwV+ydnKLhdr5BNQPkWa9laHo0WLKJ60Xy/lNmyoRPEOxQUjNcuPjCaWDWcUzj59wVA
 cPlYDt5kCYJqZM3V2sSUgi0U3NAw2sRpbiR6boRIxVyYyrH7NdQPWIGSWWxT8UjEx0Pu
 tYfhl/c8wIf7BGUwKNCNHU0XhBsnLk2z1hDcbcvEWlmKaTNity+I9OS433NQPRVpfk+O fg== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3fs37h79c1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 May 2022 23:34:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GYJpaPoDjjMXm6XXCmlAVH8HcGIGJaSKnwLahg302KMBvXvE7nCO1768DM0yY1rMY24F4pJ+VbelGOS7VXdEBfT0w8QwGXhGztfHx4PSXhOMXcFWYK7YtSHjFDKRpxsZbx06o0/JyV+5m6AAOq0VkQ+IE3awzIfuJVoqm+2KdAQqPjzlBGectSpkLfCi7XjDTbhu2LUYKke9NEitbRegnZKXXiIMh02KBBLQ+FGGFR9eB0oQDK9l7tecrFO5q7F1GuGeWpqzRVUZikbjv2Ft90CybzsLe1enQpdvjO35VVslN/lXpli/BuLuBuaAKj6oKCjmynkvcL+jLKlxdU35ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ovy2STo2Q3Qjy+vhF5PYuWDsyOhKr8KHfo6lbllXaHg=;
 b=Z1ya4ILto53JkWLOKrWPJTCuxJL3EY/Gy4OWuC60Shz+nZ1qurXjZHxc8ZumcOS6NCQBYKXK5DvFgYsMCrnkxl8fOM3LkK3QyMdJ6jtiqOcAPZGLDo8vnpwCtKNuiv1619BgMvECriXWEEVRG/OuPeNGAMj0SO/r3FdDN56cJXVO5/rsVhyeES8cMCXIIAHMe25OoJy0Bq7GMr/QUkm/sWD5jz5fpSmvonikty0IOEaoryDs5esP7BPO7q5FaT1Brlof4e4GsZkFOfNsm/F/6oUUOOKr60bwmIm7iNgvQVJffgUa2zhhDc+KaA1j73szVIu3O6Td/OUBm0XGdTCDLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by PH0PR02MB7814.namprd02.prod.outlook.com (2603:10b6:510:58::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.14; Wed, 4 May
 2022 06:34:10 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::6819:797c:706f:9a01]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::6819:797c:706f:9a01%5]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 06:34:10 +0000
Message-ID: <25888a8f-ef44-ec69-071c-609ddd7661dc@nutanix.com>
Date:   Wed, 4 May 2022 12:03:57 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCH v3 1/3] KVM: Implement dirty quota-based throttling of
 vcpus
To:     Peter Xu <peterx@redhat.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
References: <20220306220849.215358-1-shivam.kumar1@nutanix.com>
 <20220306220849.215358-2-shivam.kumar1@nutanix.com>
 <YnBXuXTcX2OC6fQU@xz-m1.local>
 <8433df8b-fd88-1166-f27b-a87cfc08c50c@nutanix.com>
 <YnExg/3McGZK3YdR@xz-m1.local>
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
In-Reply-To: <YnExg/3McGZK3YdR@xz-m1.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA1PR0101CA0037.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:22::23) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: adf9fe06-c591-4c69-5865-08da2d981923
X-MS-TrafficTypeDiagnostic: PH0PR02MB7814:EE_
X-Microsoft-Antispam-PRVS: <PH0PR02MB7814B9C66349744C86E2D296B3C39@PH0PR02MB7814.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jJ76UyBNj+kSLKB9nXwLAzq21JYpyPblRtpQXMtA8U/d/dpHhwKCJqH0EvDGl5N5utn9SpYD6quUp48FJ+VuYI2hrqRhIqutuB3hR5uz9S4PCtyURnb9dkFKj2zpNkxBkK8Xzb3opLAM6RRfzB6EJE2AlEWqrrIwLr/lGLD7zln/epMVgH3cHaIBeBtb0+CFnYU8ajBWnVdutC9feMHeVtFCAUiFSX5PQAYDnI3U/1uqyS6gqP9cH9t0HwxUbQ7xiieLQNaxu3NwH7wbrZovNrvm1PlHD3a8B2kqmVna8YHrPeopY1PjfJ1EJtjvRDUbcvYM1aSX9X94oNdHY+rBOCm6dnKb9X67+pw7kty1Ev5r/5uLNyiWbVHSqYhMWpAj35cUfwCsvXrSLtFMEhtZbxtEC94DJq4SaHr/Rt7bKsSJopBlBMiOpSX/K2XAX5mBKuhS9iIuVddx8XAPRQdsihaxDbnd5KRoPaqn123nUNQ2t63ex3qnCUDNhTHVkDEslakMZNsg5Yn0IJj224wAa/siYZWgxUEIAvK93ep4oAvXojLZv9XK4qtmsm76Ftx7Nt1lGwEy9a424WQx5s31zNXU3963lhUt/ZbgyEKcZ1yrANyI+UITQZGcsnjYeZ/NT+k1jcl3rym453OI5FPQuQixcZRlRHE7K1ikeNUi79e6RDV/IGI3GJ3xEd60D3oKYzWj5EUirR+gTL2rpB2gjYd7eHGliBwaZqpuWS9bp+bmBOGZG2sKbB2hacFYVS/WFWqTAAcTHBYNbRJJ7RiV5ZGXTcnamjY8WAqm669Fhp0zXVd/gcytkwBarNB6XtnqrJSBipt+oOR3cLQqp2x9tQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(508600001)(8936002)(8676002)(54906003)(5660300002)(38100700002)(107886003)(66946007)(2616005)(66476007)(66556008)(36756003)(186003)(6916009)(316002)(31686004)(4326008)(26005)(31696002)(6512007)(86362001)(15650500001)(6486002)(966005)(6666004)(6506007)(2906002)(53546011)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WDhzOTFlRDkyWkdmWXdCeC9GZUJWMmhzL3N3dmFvc0FiOUVvRTFtQ2VQWWRs?=
 =?utf-8?B?WkxwdENQdm9xb01jZXFrdlNOcEx4UWpKKzlUak1SNjRqWXBwcXA0VlNsSHRE?=
 =?utf-8?B?ZGk2dzNvWnF4ZFdocmtPRHRaZk93MUg0S01XSzFnNkpNTll1SkZZK1BDVWJH?=
 =?utf-8?B?UHJGSjFZaFpNR01pNGVIVzF3K0tOeGd6VGlRUGE1dVFaU2REcW0wSmJMYTFp?=
 =?utf-8?B?VXVVaXlHNGl3UHZvT0J3YXVjVmkxYnBDSituNEZibXRqT3FCSEFDdkJzZytw?=
 =?utf-8?B?Qy9BTzNoeVNXNkVGSWxoTmxXeTRURFR2aVIrc1Y4TGZ1Q0NIcmN3UmNBb2pj?=
 =?utf-8?B?NVhsYlMrZDNVcjNaM2hHclpZMVMreDdYNnkrTkpzMW9aU2svdFhxTVpWMHJJ?=
 =?utf-8?B?UThYeVFabDFWTHZ5UzZudk8vRWEvbE9oUUhtK2lqeWV2WW0vd1VpR1lFWTFn?=
 =?utf-8?B?Wkc2YlZ4NSsxOUQ5WWZIdFc0MkRvY05rMUE2SXFwNFlRS2V3THFxbS9nME1C?=
 =?utf-8?B?c1lUWW53elVDcXpJRklYNVhuVGVXdWFIUkJSUHdjbkgreEdpbVFDVlpNZUUv?=
 =?utf-8?B?QVhGSkE4angyeU5udm9tSmdPVFdXRGNycWhYbU85cUNPVE1ReVkyM01ZUE5T?=
 =?utf-8?B?ZXdUYmZwZTYyYlVCbmJOYjlTbEZ3dUdNWWlNWk5DZGw1WUZOczhzZmdTd2Nm?=
 =?utf-8?B?TERDYi8wWjBzcWVjdktwUlhOd0puZ1ZVKzMxYUYwcHhmNkRMUzcxTkR6OXJE?=
 =?utf-8?B?V3EvSjl3c0h0OW5vZWhWNytYdzN4clo4a20zYlhyZk0wUzA3YmV0Y2h3Zzgw?=
 =?utf-8?B?VkY5TDNSTVJFclprZCtsSGFkK29QbU1KSWo3cGVTSUVrUXVncGc2U3N1SENy?=
 =?utf-8?B?UzlhSmRqTWVhcDhkWU04QzBkWDBpQmQ1dVY4aEg0RWhuMzZXMFpkRjNwckFU?=
 =?utf-8?B?Vm9pN3gwNVJ1SGxJRERMV2dBU201UnQzSkVZQ1FNNVcycS83ckthY3NYbWhh?=
 =?utf-8?B?bjVtYVBtUE5QRVVvc0s3S01lZHBGeVpESFRPajBuUng3UjRHU3VDRUUxOUN6?=
 =?utf-8?B?UWNYZzZpWDN2RjlMeHRSK1VJM2ZZWC9yMXR2QjQ3S0IvSy80OTVrckdGNzA0?=
 =?utf-8?B?d0VWNzVUMmhHQTdocEowZTJYNkppV1JHdmlsRVhnRTErNU51QnY1ak5tUDFH?=
 =?utf-8?B?a1k3a3BqakkxVDVuc2VteVVVMW1WQlluMFFRTkgzb3dXTWFBeUF0U3BaRU9S?=
 =?utf-8?B?TjBya2UrU3BKWEVGSFhiTi8wemlmQTMxZGZPbXFzWG82S2FFS2tnSjNyTXlQ?=
 =?utf-8?B?SEJpT0g0dlcwSmR3R0VaQkE3bmtldDBFNS9sM0RyMzlsK1F0QTFuRGFSMlBZ?=
 =?utf-8?B?Q09VcFBWaStvUkJGNmdMK2MwOEpYK1BYbVpHSFRVRGtSVEpPWXpUdmtWYmov?=
 =?utf-8?B?T0hyQTVwMUoyeEJuWHNxU0ltTFdGbUtRYWRLZ1VpbzF0d0FqTHlyTFNHSTg0?=
 =?utf-8?B?NkpsdjhETnJjeUFIVVlBTFJvQVQwa3lnNXpLZ1ExMkowaDh2WjErZGVFYWJX?=
 =?utf-8?B?dk4yMk9TSjQ1UWVabEpIWkJGYTM2ZjgrYVRJTHVwWmE2d0s2eHlqQ1hsZG9h?=
 =?utf-8?B?V3hmT0FwWndVY1dnUUNsMzdCVVgrR0p3WFZPbDUvUHRUb3B1cUh4N25nWVMz?=
 =?utf-8?B?c1NoTitNUjVxWTZzU0dxMDY0Yk0xWmtSQWV1amY3RDN4c3Rqb1BEaG9hOXFC?=
 =?utf-8?B?VmZ1SkRTYkRjVGVEZVhFM295dUZYV1hZQ2hFOEtwLzdyQmtTRW4yclFjRVVH?=
 =?utf-8?B?eXBBc0lFbHpJRkltTG5FNHVIUnJ4amp1ZnZMOERwL0NMalBXT3lmRVlEc240?=
 =?utf-8?B?Nm12OWRFZnN1LzVNRzRkbitlWlNsWko3QjJYZFA0b0NoUUQ0U0hCcnAyWEEz?=
 =?utf-8?B?SHRxZDdHQS9xMzZtbjVuNldYbHF4QmFyZVQ2VVJraWFBd2hUMUtvRkM0cVc2?=
 =?utf-8?B?TW5ZMFlCMWF4MHNid0UwbXJJdTB3S1UxbUlLdktFbUNPY3c0emVjaExiSlJC?=
 =?utf-8?B?QjBtQU9qZDZBUzE1VUlpdTVhY2FFTVJXQ3hwdkNXYWZuUW4yUUIyLzJmeEJw?=
 =?utf-8?B?V1EycEN4ZU5wVFF0N28xSnFiZ2tlc01xdW8zU3dkdFIvNUUzNVVjYkgrRzhX?=
 =?utf-8?B?ZUJhclJVN2dFUFVjcHh4WmNueCt2OE1hVmtEazM3UUZzeHBBWk9PVnpUZDRi?=
 =?utf-8?B?UTUyYzNLTDlxN2tRMFBEWHlFN1B0SWhsU0FLY0tNR1kvZGxSbDZwSTRueC9B?=
 =?utf-8?B?VkIyVGtCNGYzSDAyRjN0V09PQUVMMWpPNlQrOFZQS29DWGNzeHMxOFp1U2lG?=
 =?utf-8?Q?0li2DYCuF5s5/I30=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adf9fe06-c591-4c69-5865-08da2d981923
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 06:34:10.8091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0irFbHIIdOT4piRTuFun7JRhgGcPW9WY8bdG/LQ0qG79hSiGJ1uS0Vnw/t/TfNs2vg4AP12Xg9lfqH2eOlLZPGSL/75nZxVqBfUTeKe2uoU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR02MB7814
X-Proofpoint-ORIG-GUID: VXvJfXyPLV_LUzBzykn0bWX-c_WOOXlW
X-Proofpoint-GUID: VXvJfXyPLV_LUzBzykn0bWX-c_WOOXlW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-04_02,2022-05-02_03,2022-02-23_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 03/05/22 7:13 pm, Peter Xu wrote:
> On Tue, May 03, 2022 at 12:52:26PM +0530, Shivam Kumar wrote:
>> On 03/05/22 3:44 am, Peter Xu wrote:
>>> Hi, Shivam,
>>>
>>> On Sun, Mar 06, 2022 at 10:08:48PM +0000, Shivam Kumar wrote:
>>>> +static inline int kvm_vcpu_check_dirty_quota(struct kvm_vcpu *vcpu)
>>>> +{
>>>> +	u64 dirty_quota = READ_ONCE(vcpu->run->dirty_quota);
>>>> +	u64 pages_dirtied = vcpu->stat.generic.pages_dirtied;
>>>> +	struct kvm_run *run = vcpu->run;
>>>> +
>>>> +	if (!dirty_quota || (pages_dirtied < dirty_quota))
>>>> +		return 1;
>>>> +
>>>> +	run->exit_reason = KVM_EXIT_DIRTY_QUOTA_EXHAUSTED;
>>>> +	run->dirty_quota_exit.count = pages_dirtied;
>>>> +	run->dirty_quota_exit.quota = dirty_quota;
>>> Pure question: why this needs to be returned to userspace?  Is this value
>>> set from userspace?
>>>
>> 1) The quota needs to be replenished once exhasuted.
>> 2) The vcpu should be made to sleep if it has consumed its quota pretty
>> quick.
>>
>> Both these actions are performed on the userspace side, where we expect a
>> thread calculating the quota at very small regular intervals based on
>> network bandwith information. This can enable us to micro-stun the vcpus
>> (steal their runtime just the moment they were dirtying heavily).
>>
>> We have implemented a "common quota" approach, i.e. transfering any unused
>> quota to a common pool so that it can be consumed by any vcpu in the next
>> interval on FCFS basis.
>>
>> It seemed fit to implement all this logic on the userspace side and just
>> keep the "dirty count" and the "logic to exit to userspace whenever the vcpu
>> has consumed its quota" on the kernel side. The count is required on the
>> userspace side because there are cases where a vcpu can actually dirty more
>> than its quota (e.g. if PML is enabled). Hence, this information can be
>> useful on the userspace side and can be used to re-adjust the next quotas.
> I agree this information is useful.  Though my question was that if the
> userspace should have a copy (per-vcpu) of that already then it's not
> needed to pass it over to it anymore?
This is how we started but then based on the feedback from Sean, we 
moved 'pages_dirtied' to vcpu stats as it can be a useful stat. The 
'dirty_quota' variable is already shared with userspace as it is in the 
vcpu run struct and hence the quota can be modified by userspace on the 
go. So, it made sense to pass both the variables at the time of exit 
(the vcpu might be exiting with an old copy of dirty quota, which the 
userspace needs to know).

Thanks.
>> Thank you for the question. Please let me know if you have further concerns.
>>
>>>> +	return 0;
>>>> +}
>>> The other high level question is whether you have considered using the ring
>>> full event to achieve similar goal?
>>>
>>> Right now KVM_EXIT_DIRTY_RING_FULL event is generated when per-vcpu ring
>>> gets full.  I think there's a problem that the ring size can not be
>>> randomly set but must be a power of 2.  Also, there is a maximum size of
>>> ring allowed at least.
>>>
>>> However since the ring size can be fairly small (e.g. 4096 entries) it can
>>> still achieve some kind of accuracy.  For example, the userspace can
>>> quickly kick the vcpu back to VM_RUN only until it sees that it reaches
>>> some quota (and actually that's how dirty-limit is implemented on QEMU,
>>> contributed by China Telecom):
>>>
>>> https://urldefense.proofpoint.com/v2/url?u=https-3A__lore.kernel.org_qemu-2Ddevel_cover.1646243252.git.huangy81-40chinatelecom.cn_&d=DwIBaQ&c=s883GpUCOChKOHiocYtGcg&r=4hVFP4-J13xyn-OcN0apTCh8iKZRosf5OJTQePXBMB8&m=y6cIruIsp50rH6ImgUi28etki9RTCTHLhRic4IzAtLa62j9PqDMsKGmePy8wGIy8&s=tAZZzTjg74UGxGVzhlREaLYpxBpsDaNV4X_DNdOcUJ8&e=
>>>
>>> Is there perhaps some explicit reason that dirty ring cannot be used?
>>>
>>> Thanks!
>> When we started this series, AFAIK it was not possible to set the dirty ring
>> size once the vcpus are created. So, we couldn't dynamically set dirty ring
>> size.
> Agreed.  The ring size can only be set when startup and can't be changed.
>
>> Also, since we are going for micro-stunning and the allowed dirties in
>> such small intervals can be pretty low, it can cause issues if we can
>> only use a dirty quota which is a power of 2. For instance, if the dirty
>> quota is to be set to 9, we can only set it to 16 (if we round up) and if
>> dirty quota is to be set to 15 we can only set it to 8 (if we round
>> down). I hope you'd agree that this can make a huge difference.
> Yes. As discussed above, I didn't expect the ring size to be the quota
> per-se, so what I'm wondering is whether we can leverage a small and
> constant sized ring to emulate the behavior of a quota with any size, but
> with a minimum granule of the dirty ring size.
This would be an interesting thing to try. I've already planned efforts 
to optimise it for dirty ring interface. Thank you for this suggestion.

Side question: Is there any plan to make it possible to dynamically 
update the dirty ring size?
>> Also, this approach works for both dirty bitmap and dirty ring interface
>> which can help in extending this solution to other architectures.
> Is there any specific arch that you're interested outside x86?
x86 is the first priority but this patchset targets s390 and arm as well.
>
> Logically we can also think about extending dirty ring to other archs, but
> there were indeed challenges where some pages can be dirtied without a vcpu
> context, and that's why it was only supported initially on x86.
This is an interesting problem and we are aware of it. We have a couple 
of ideas but they are very raw as of now.
>
> I think it should not be a problem for the quota solution, because it's
> backed up by the dirty bitmap so no dirty page will be overlooked for
> migration purpose, which is definitely a benefit.  But I'm still curious
> whether you looked into any specific archs already (x86 doesn't have such
> problem) so that maybe there's some quota you still want to apply elsewhere
> where there's no vcpu context.
Yes, this is kind of similar to one of the ideas we have thought. 
Though, there are many things which need a lot of brainstorming, e.g. 
the ratio in which we can split the overall quota to accomodate for 
dirties with no vcpu context.
> Thanks,
Thanks again for these invaluable comments, Peter.
