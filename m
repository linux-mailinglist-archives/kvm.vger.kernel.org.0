Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8B974D2032
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 19:26:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349228AbiCHS00 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 13:26:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230406AbiCHS0L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 13:26:11 -0500
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAB3B58E55
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 10:23:31 -0800 (PST)
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 228C3J5i031625;
        Tue, 8 Mar 2022 10:22:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=2LYefh9NSfYnZwNGZILkyCnc/qejZmn7ScridznWr6U=;
 b=VyEy5AakJZAQEwOjyvNIkqxvS2jwmlv37EWDnSJhkTEB7Cx+fFo/uM+6hiBkbI2MtVEm
 KLJ2FqNjzvrEBNVrD3UwbY0DJizpo0mtQ2e3gfYv3six2UZ/16rfLohE3CvVRAQWEPWn
 jQ/9kEpbBGqSJ008d0GcRnwflYyDi5miz3NLgEM3lDYZeVi8LAFri1eYhCGwA7rPuXxr
 1MuND/ZLTs4zz/jzuhhBTRLxq239zUf4hX4Dj6q+sm+fklAm31q4+HMw7vYew4A9D6YQ
 Ns8cb2UYWz8++AnitfLClP1cgs33nhAz/dvIly8fGwPAXvJRwOvu3+57R21Xe5cknwQW 2g== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3em7tkpfjn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Mar 2022 10:22:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aAYHvf3ZCgm4scxOmHJkAYfK6qFsmZRedcbNSojErm5thDs4WWe7s0MQHnTIGL/kvkdMilpLu2wwos3q2LXSA3lw85xiMqNBGPKxpwEFN5ksni0jm0CEf/CZGADocPSw8x9eF0chNKIA6Vy+075XOVqi6IpU2txrJOKIvS9d7QVX2a+Z0BEHG/qRzyyuEUtMmoVDpFlpieClaC9butZO3/1bcmSP27KnjBQ/P8JF3oSYWEtKG8XQvdXwUqJsFIzm6bAnof2ODCsGKhvn9ElnAl4WyaGCnNa3Cy/gjNVeuWVprU6+/YCreW0t0kax6glCZoPGyI4cs8YQ5rknt1hqCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2LYefh9NSfYnZwNGZILkyCnc/qejZmn7ScridznWr6U=;
 b=e8OGL/2xLHWcuXBz2jVrWtNwUZ7NXj+j3rXUqi9Q7dyjWHXthcgI1QEQpXcJ5dSbEdqN8Vw28SgNefxvffoFUA+cwyJ8rVXfTlT0BhQPxDiPu6LBi+/kxeFqkHIG0TPMPIc+3jrPjleB3EG97pwBRiKy25LFYNH+MudbIgFrgbj0yU4Th+WRlkAFKTNYiWU/piOcwt6IirdksLJ0lwIRve8+9Z42ynH7pbERwQ5R7xJZ4EdSGq2tZWAQLUvT0MeDQv4V81fyx+gVeySkA0CVDNcw/NvwlbRPEdmnGkpWsB3scKvNqda62YbEqAAZf0MCM1aIKkL2trhAC+Ys9ThiXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by BL0PR02MB3666.namprd02.prod.outlook.com (2603:10b6:207:45::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Tue, 8 Mar
 2022 18:22:53 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::88fa:f43f:f4c7:6862]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::88fa:f43f:f4c7:6862%8]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 18:22:52 +0000
Message-ID: <ded94fba-fc4d-f3de-083a-3d90db3fe2d1@nutanix.com>
Date:   Tue, 8 Mar 2022 23:52:42 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH v2 0/1] KVM: Dirty quota-based throttling
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, agraf@csgraf.de
References: <20211220055722.204341-1-shivam.kumar1@nutanix.com>
 <f05cc9a6-f15b-77f8-7fad-72049648d16c@nutanix.com>
 <YdR9TSVgalKEfPIQ@google.com>
 <652f9222-45a8-ca89-a16b-0a12456e2afc@nutanix.com>
 <76606ce7-6bbf-dc92-af2c-ee3e54169ecd@redhat.com>
 <Yid74seFMjB49FIZ@google.com>
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
In-Reply-To: <Yid74seFMjB49FIZ@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MAXPR0101CA0055.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::17) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8651ae28-70b1-4830-1fd2-08da0130a894
X-MS-TrafficTypeDiagnostic: BL0PR02MB3666:EE_
X-Microsoft-Antispam-PRVS: <BL0PR02MB3666592AF92F5B50326A3092B3099@BL0PR02MB3666.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3uJbDErnXLao8ewV6+ZDEXEaYSTEid1ivQucxViKqVWPKcZyGYNJQu5F9S24QP3preGbIIr/ZqdG75kU+9loxRUuMwJj9zkfWrho8aCfnxuNiU1IeAdKOu/HzgcO/wmA4+BSWVwz2yFX3wWMc9wfmv1k/wlTbys9CSjVjeNGtCwX4GnPmNGnNIzZQeIJPIyZGNa2bB0haHfJJ/e8X0ajmanDdcUboFuXdM6J2dRIBGAMx5u5MqOnS+Jt+o3rdzZTq/kYBn12bZgkqybWrJIzOLGxQUE0+QUNXtVivyHL8gM2yaGcd3oIvr7qa1c6YHYGIV6ztKVZgDz7t+R87httPKgy4JZzW0r4s0ZKPVI/9PL5Hu/TXSvrXAi0e7HViNxFbf/2IUpSn9j8qNRlQxwQBMHy+wC3BoPmn/tKvA7j78uHgOuMUwABB/UZ3x80cp0flIBS/yopXYMTXSDYgrHHABB9bU4fmkn+MO8LD7aNxRQoVyDRS8n5f2cBvXKVYR4qZmeF9j+7IDCgBHAL9GnwtQ7Qo20tdvi7Fc1zYYm99yrhL80Q6B19hoTIRTxKDkmvwK61foy/vlaEC4hA7BPv4kSOTzq3MH/AHvnnkcTRiqd9BTCbD+BkHFsIre0fbtl9RtX4cOcpseTc7oinp+DxZ+t8J+tHGdwGJH6TIYDm6kZJNb8hkDcZvP1mDJkRoV0H5hmXRoZDGZW3HoVP/d4GGsCZTA+3vC80I7d7BFEmx+9ziUQZMKeEM3UMgwnU4p45Miv6sKMdIYMRp1HLuxbBxPMHqTmC2CJsLyTQivnm8APbHgzCciRLrLTv3QlWPZUTp8yEn9vkiWytkO/tCJiNMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66946007)(4744005)(66556008)(316002)(966005)(6512007)(5660300002)(8936002)(26005)(66476007)(110136005)(4326008)(508600001)(86362001)(186003)(31696002)(6486002)(8676002)(6666004)(53546011)(36756003)(38100700002)(6506007)(55236004)(2906002)(83380400001)(15650500001)(2616005)(31686004)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MHZHQmRHT0kwajU2QjhzZS9qejlnRVFlOUJqc1lMSUs4TGhWLzcxS3Uxc1Zs?=
 =?utf-8?B?bmczU3l3NndzZzFaTmI2QythRENwYVppanMxZTNGRGN1Qll5aDJ0M2k1SHJ5?=
 =?utf-8?B?TWNvSk5Ma2xKOXhOYlJadHA3SnJ5TCtCakRxY0ZaS2xLQVNIM2k0TnYyYjIy?=
 =?utf-8?B?SmFBeEp0d0hQR2hFc0RuUFFqNVFDamV6WFYrYm05U3hZdVRQbGRvOVU4bGhU?=
 =?utf-8?B?Rk9EL3JWNEpUUWxsVm94L1N0YkNuN2ZCRkY3NzNLZGoyblZNeXdGQ2cwTWxK?=
 =?utf-8?B?NllnSXQxUCtVa2tPVFhFa1o5bDhNckxPcWZhMG02ZHU1VUJrTEk1bGdNTFZF?=
 =?utf-8?B?LzkyY0RjVlJLdG01TjNJM2o1Ylk2N20xaGVaSEZaZjFMTVNBVE9ORjJEbDZi?=
 =?utf-8?B?VWoydnltYlBBY1NJZGI5ZlFURmh4WU9VdTFCbmhmbGloWmNKbkwxclhCT01F?=
 =?utf-8?B?YkpqV3JCTWJLSlVLUjcvMUNMaVZXS2tUMHpsZ1FpdG1zYmczS3ZXNFVRdSt5?=
 =?utf-8?B?UTdCMTh1R00vb29UL0d1R0hFazFJTFhUa2FxNFpWaUplek5UVmhvUlgzajRO?=
 =?utf-8?B?ekRrMUU4dHlFQTJ1YkI3UlJjeEtYdlVoWTkrRG1OZG1ub1dlRjdNeXppV2lS?=
 =?utf-8?B?ZklmV0Zxak1qWHV4SWlzZytmSno5dXJtM2pZamlMaWZpanI1LzY5UFBqMmdY?=
 =?utf-8?B?M0EyNVc3UlowSWo1NENCMzdqdUZjbVJOTW41MTZXVklOWFNMRDRzaEdUc0hw?=
 =?utf-8?B?WXl6K1JhbnJ0V0lNb2NxQkJ2TFdmQU0zN0E0WWduZ3IwTmg1LzQxeGtyNTZy?=
 =?utf-8?B?cTNqaktDK2V5Zld6SnIwbUF5cmR0azJVUFJOWisxTU4vcUM2ekkwWFM4WHF6?=
 =?utf-8?B?cU00OCtDZzhkek45SEV6WGMvL2dnTzN5cE0vU2xkOTUzS3JyMnVDd0Q0Q0Jl?=
 =?utf-8?B?UFpDeThnUVc0bEUyajRrMG9vOHJVOUFLVHBFeHpxTGxSYnNtYWF6cVdWOFU3?=
 =?utf-8?B?UWo5Qm82WURucEgyVmxKZkJqcWVwcTNMSGhWUUgySlZodXRwYWdLWmVLRUFJ?=
 =?utf-8?B?ZGZraExvQVlvMHB5d28rUTZydk9CNGRURTRGc0pSR05Rdm83RVZLRDNjai9t?=
 =?utf-8?B?d2xjNU5JT1BoVTZvc3NGSXJFbkY3TVhTZTFDNU50Y2RXcmRNSXhEaEV5bkt6?=
 =?utf-8?B?Uk95a3MyRGUrcXFkZHBnK096aGl5S1BqdjFmTDY2aFh4RUt3R0ExSmorSUlw?=
 =?utf-8?B?a3Ntc0hDb1JsbCtBWStEZ0tsaTBoUWZQV3BIUG52bVNJenNLOUtoajV5UzFo?=
 =?utf-8?B?RzJ1VTZZWFh5eEFpQkJtVmc3YkdrdHRtYjh5T0hoTHBiNDQ0amhMVUFUU2di?=
 =?utf-8?B?bWZ2NU0zQ2JEVDlMYmhMYnY5UVBIU0xuY3VWWUI2RUhnL1Y1Rysxa3Eyam5w?=
 =?utf-8?B?N0NWelBaWEd2RkwwNUNoYVduUDROQVNVVUxSMGZ2MEQ0THlZcmxXOTMrSnB6?=
 =?utf-8?B?K1JoMGtTa0RJVGd3TFFRd1FOOWNxc09ZQytHUWZxZjcyT0dGWU4xc1BGM2tZ?=
 =?utf-8?B?SUxqSmVHazZraWhUWVZXUTFFUkN2OHVhR3F1MUN1U1ZQQksyNDVZdXR5MGdR?=
 =?utf-8?B?MzVWQXc5OWRWRkRveGd1eFYwdWhsZ2xpLzdMSHhjVVFsTUJlaGtpV3ZlTmtV?=
 =?utf-8?B?SFpmSVlObFF0akpHMWdQL1YvU2UzN2pYcTg2Wm9PWVdzNmI4YXRnUUIycThq?=
 =?utf-8?B?Z2lYaHdsZ1lTb0lHT1BRUVVNazZPQVhKU2pXY21vUk5weDZEZ2xwVzZDVGdh?=
 =?utf-8?B?TUxSaHN2R2ZsVGkydzZNK1lRaCsvODg3UjhrTml0V0ZsS1pGb2RXYnNPNTVr?=
 =?utf-8?B?b1NJSktxeVhrUDFlbTlnTXNQTnVJQ2NqY3RHcGpUamlieFdMemlsekNxOTZV?=
 =?utf-8?B?dFZTb2VjTFltMGljUTdlYWJTRU1Gbzl0amNMWjF1THlPYmFBOGhVQWROZ1M2?=
 =?utf-8?B?UVV6RWsxU3g3dmRIKzlmLytyeGJTNE9FdDZ5TVRSV01NanFnQzJpQktCbjdi?=
 =?utf-8?B?bTdzRHNlVXNxNjkwMzJWRGVqK3hYWUNESnpJZlhaMXE5NkJRRVZ1OHhkSEFk?=
 =?utf-8?B?Slg4UmpBWVloQ1FrR3JWemI0d0JWZUxJUEJhVFVzRk9QWEdkUHFZNVhQUzh4?=
 =?utf-8?B?M0hIOHdubW5Bek9nNmpEcERjcXMyYlpwZXBGbUFCVlV6dGVmQ1JJUWp5Vi9z?=
 =?utf-8?B?ejBIVk5Bd2RGa1pHcHd3VDdiQXp3PT0=?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8651ae28-70b1-4830-1fd2-08da0130a894
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 18:22:52.8758
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aSL4K5udFFbPL+w1udrse7eAVC2T26DH2R9Pc14epAs7B7o4CylbtpawQu8lpfvUtWnet4FcVxIeUJnN6Fg/Y73TBpgEWqoxnWh4IUaiXDI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR02MB3666
X-Proofpoint-ORIG-GUID: lAy13OxIYU6MPAbDz-mBUxNbxSJWDE3f
X-Proofpoint-GUID: lAy13OxIYU6MPAbDz-mBUxNbxSJWDE3f
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-08_07,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SCC_BODY_URI_ONLY,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 08/03/22 9:23 pm, Sean Christopherson wrote:
> On Tue, Mar 08, 2022, Paolo Bonzini wrote:
>> On 1/5/22 16:39, Shivam Kumar wrote:
>>>> On Mon, Jan 03, 2022, Shivam Kumar wrote:
>>>>> I would be grateful if I could receive some feedback on the
>>>>> dirty quota v2
>>>>> patchset.
>>>>     'Twas the week before Christmas, when all through the list,
>>>>     not a reviewer was stirring, not even a twit.
>>>>
>>>> There's a reason I got into programming and not literature.
>>>> Anyways, your patch
>>>> is in the review queue, it'll just be a few days/weeks. :-)
>>> Thank you so much Sean for the update!
>> Hi, are you going to send v3?
> https://urldefense.proofpoint.com/v2/url?u=https-3A__lore.kernel.org_all_20220306220849.215358-2D1-2Dshivam.kumar1-40nutanix.com&d=DwIDAw&c=s883GpUCOChKOHiocYtGcg&r=4hVFP4-J13xyn-OcN0apTCh8iKZRosf5OJTQePXBMB8&m=dwu9ZtRoNex5VV6kcbNykq0dB4r0tjRRQiLgHMcBiyHTjgoS2eonSOhlafk-6d3d&s=vMO2laX5_STetWpbWSy3EpBlH0dt21Til_Mbw8Ek4Bw&e=
>
Thank you, Sean!
