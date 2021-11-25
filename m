Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E65645D66A
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 09:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350013AbhKYItE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Nov 2021 03:49:04 -0500
Received: from mx0a-002c1b01.pphosted.com ([148.163.151.68]:20904 "EHLO
        mx0a-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235403AbhKYIrD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Nov 2021 03:47:03 -0500
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1AP74pdD013291;
        Thu, 25 Nov 2021 00:43:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=/HituqRzfT0/F3HI0lq/u84GmBICjugM0YWKwYJycX4=;
 b=DfjerGNLaRjk9mPNBEn5XQvWkWG0OUD6sQZDXCEE+00GlZeAiugIfxyyGiYmnMChvy35
 3HWMEecKre3TB9kBVmrbb+vgxYrDUIshBn00lTqeYCz6VAI/oqZKpoYog/IKeqDAdrG2
 v2L4Wo5AFFhj9H5Jhn5yDT08W28I9MkGKZ0MtlaZr0jJhQ8G03nphTWxjkRKITVBltkF
 FTgVsDMBkeBkPRqQy30jgaCxPgPkiNOku7Bhc5duCgzMPuAYXgY0DMHKciTGoCd5smYk
 nocfh15M1NnXUtOuEfl3BNGHpjp62+8SZVm08tJp5iShFkh0PEpnrZ6PGLaULjQTjXm5 eA== 
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2169.outbound.protection.outlook.com [104.47.73.169])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3chjvet6eq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Nov 2021 00:43:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bCX9M2JmXRILYMU6IZsv4hARMIOSe6R7YOOfLBNWjrAc7t7BQBsKYaTvtgpsz9kVyzHFOoN6Io0PLsdHVu+QdJT3P+uCkl2LqBHfDQ4rZ1Qak8chZCv9MISBkBdMUqsxp87h0do7ebt8B+f0sJ3SWQv7z4m2gw6eFtggae2eZxA7e0vR8WCpe6ld9cgudOY8B21ML6QRkcRFxg65Id6ggdrvYOh3SlckIb8+NZY87xg6cmFO1Yx+eNClurbg54U6BiJUjg3TJ99otC+fqiQMJnLm4OsUT/AhRwWUcUOvWehkN5Hvmkf/kaBB5BSyzfOXv4qYegMVAlSCaZJth6TBYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/HituqRzfT0/F3HI0lq/u84GmBICjugM0YWKwYJycX4=;
 b=O1eYDYSMR6tiCYuY4gX2sWjRe+mG+kauWEP+qYgHs1GDS2QKLTyLP9hlmtFCWDSdoPEKANWwoHUCMP3VcSS1u9Xs1AhbcEeQz/U77nMQQk4bgtiek/U6FaY8fyEQKJB5xf3hsGwK1UIx53eIOoJL7lpdWi+1Im8AMUeC4zqMpCtdBjBYGdC/Gzs48WNQqkz+aun5pEtdganNjudLLka8FcOye5/aKSlsWXFHs+zbFRrdBG3rhk+rriBFeXRUfFF0RhG3foPRQTM/et+g2dFset7d+Bg2BAC7sBSWDFjud0TKDkBM9z5kMQnO02ixTZNoAMTSujtyXkCywSa1uBo7ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by CO1PR02MB8618.namprd02.prod.outlook.com (2603:10b6:303:15d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.19; Thu, 25 Nov
 2021 08:43:47 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::8d99:ba07:279:25c3]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::8d99:ba07:279:25c3%9]) with mapi id 15.20.4734.022; Thu, 25 Nov 2021
 08:43:47 +0000
Message-ID: <d9129cda-ebd9-aec3-3f04-bb989c509ac1@nutanix.com>
Date:   Thu, 25 Nov 2021 14:13:36 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH 3/6] Add KVM_CAP_DIRTY_QUOTA_MIGRATION and handle vCPU
 page faults.
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        Anurag Madnawat <anurag.madnawat@nutanix.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>
References: <20211114145721.209219-1-shivam.kumar1@nutanix.com>
 <20211114145721.209219-4-shivam.kumar1@nutanix.com>
 <YZaUENi0ZyQi/9M0@google.com>
 <02b8fa86-a86b-969e-2137-1953639cb6d2@nutanix.com>
 <YZgD0D4536s2DMem@google.com>
 <2a329e03-1b44-1cb3-f00c-1ee138bb74de@nutanix.com>
In-Reply-To: <2a329e03-1b44-1cb3-f00c-1ee138bb74de@nutanix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MA1PR01CA0146.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:71::16) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
Received: from [192.168.1.6] (117.200.233.202) by MA1PR01CA0146.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:71::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20 via Frontend Transport; Thu, 25 Nov 2021 08:43:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d68a800-cc17-4e68-1360-08d9afefb232
X-MS-TrafficTypeDiagnostic: CO1PR02MB8618:
X-Microsoft-Antispam-PRVS: <CO1PR02MB8618C0CCED55001FDE9029CBB3629@CO1PR02MB8618.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H60yYqYoYeRl70BPq+NY3cheNQ6CyF5IZAqvM+ifqAm4PmotPKc9LA4Vlw11+iMNoFK4Zgg10Z2ppEpliY8LZXco+EHo+ERdg1J79MdSBedFIhzx8W/AlOCfWT5YY9hvxHeVEmcp3eVz+ruo7P/qq8jrq3vfG7fv9ZitcYfluNnpUiXUUOKlDxEJFsv4nhlUIwR9o9Hv9zqUBOuGU3NpYmzqeqciUlfklwTQ6OVxVkC2Wq/75XCQNa6CKWueTLIksjJPkO/MwPUt/gYlBz+hYkaTLXC+XjSY4auk2DVS0x86bORuws9jO6BXH7ZxdruvnQxnw15Jzl7QgeP5p0mlI3D6AEnFcYfJTnOQkDUv3L2PFxaGVHJLxVb+B3ON2SBAPY9yZKxPwWQcoDi6QJFIFE/YJvR17vWSeAa1P43DIe/iqhFTjQWd3GNZDWagqo+EYuPIOprKAjY7T5W0EyIL3aIuBptz/S3ahB/bj0R7wfCbO3wjtBcHvMWgaVgm6bJbB3dQaitgO67ltmPpYW8Rn8lNMdzHvepVeJBdr24F+ZXf9dHENx/HQ8E7DnpiH9LQMn1OKG653DUlVszkLVhZBO0yKvzZpCRr3r12BMEWu0Fb/4AiiobQGN5jE5+CEgF4KsWfpc8X6QUW1bgLHoFD5H2QhbcOCSXN6CmO99IzWwrDXLLxG3hW/ony0FX/5XakUj78sMV3LhVaDT2nozXRHp4Al5SwYhoGcQuZiHB3/EIITvldXLv7t8XsOZEKZG6A
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(508600001)(956004)(8676002)(31696002)(4326008)(107886003)(5660300002)(66476007)(66946007)(6666004)(38100700002)(31686004)(66556008)(6486002)(54906003)(36756003)(2906002)(8936002)(6916009)(86362001)(316002)(16576012)(55236004)(186003)(26005)(53546011)(83380400001)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NFN3WXl2VnZlcGJ3RTgwUjAyWTdJY2pjNkhqZWxTREUvdnBYWkFFTjNaSE4x?=
 =?utf-8?B?dGNXMzBzQ0lNb1A2Qk5RTGNkRjZFOTRTbVVybTBnR2ZNUjhWa3NzM2hXaGho?=
 =?utf-8?B?aXFacTZJTHZvbzNlbVJ0U0kyU1pnTkNkY0JucUdXM3ErS08wcXVqMkZPb01k?=
 =?utf-8?B?Q05JSlVnUGtlclhDWjcwUThjejlYdThJWU5VZGhhVGMwbE9uUVpHSW53VGpj?=
 =?utf-8?B?Rjl0Q1JYUmlWTjh3L2h0bEtOQnRFY1NEb2lKd0ZXM3lJVFd6djBaY08yWE92?=
 =?utf-8?B?RHFxbVhtRW9kcnE1c1VMbS9BNVZOZUFiVWVJaFZKWnFHbWpHZUZlWlprc0RC?=
 =?utf-8?B?ZlVBR3J1TVFnWFhoaW1FYW9UZUhlQXRIaVJybVIxdTIzRTRUT2VtZzNsSGNW?=
 =?utf-8?B?N2xlUVJuN2pSWWwxdXNVMFNQNVRVR2tQOVMrTHlITDRMZDBhVnFNZXNVelVq?=
 =?utf-8?B?cUpsQ1dYWDQxRTgzd1hsSHlzNWUvTmdqYXdYL1NrWGd2ZEN5dnp3S3VOMUNL?=
 =?utf-8?B?cjJiR2QyYWhmdjUxdFhXNG1aMEZ3ckQ3aitKTnQ3dDIxbXNCUWxOcHNjUUdx?=
 =?utf-8?B?b1ZweTB0UFpXSDIrcSthU2xEM242V0tmRDU5cTh0SHFOM0JicWIyL0IxU3BF?=
 =?utf-8?B?QUhveG41VkszWEEvaVFxZzFVVVJzZ2tNTk81bTlnbVhvK3h2SXNhS3UyOGRL?=
 =?utf-8?B?Y1ZCZysya05KMXpUb0k1anJMUEFTWWc3NmhWQ1c1blFDVTBGd09SV0g3bnZZ?=
 =?utf-8?B?NDl5dlN5bHZrVTRtanZDbklMNVBBYXljcEdzQk1KaHQ2SC95YTFFZC94eGMx?=
 =?utf-8?B?SGNJNWwxb0hDMDVGNG5Qc0c0YTFScFp2UTFhYUxJeXlRaHJPbjNBaEJRai80?=
 =?utf-8?B?WnE2THRKV3lNMmQwUGNyd2MvZDcxUWs2cEtXdU9Wc2ZuTUIzWmZvYW5LZ2lS?=
 =?utf-8?B?N2U0eWhSaGVkejAyeWRhUmxjbnVHYTB0clR2a3VYeEZva0lUNWV4YXFaUmdP?=
 =?utf-8?B?VWFPeUh5Tmg1NlBDa1JtUmNXaEFWQUc2dy9rNXh3OEFLSEQ5ZzFMOXNkR3Z4?=
 =?utf-8?B?aVU3ckxpa1ZJYktkVlVjQWFJUy9Cem5CNU1YSFQ1eTducU5TTlk3U2NvdUo4?=
 =?utf-8?B?RVZkcDJoUzJ5YlVxNm9NQlJMRzBFSVpMWnk5WG1HS2dIS0FHM0xhN1NzaVcx?=
 =?utf-8?B?QnBpbDVxam9OdFZtT2RobDlyR3pLaTVIZmVNOFlVVlBCNWFnRmpwMU9SZkx3?=
 =?utf-8?B?OWUxK2YyS3BvVjlvMTAxWVlOM25YbklvTTBoS0ZjZ0FTaTkxWU1sNi9YZU9y?=
 =?utf-8?B?UGcwNmxiZFE1a3BlVkxZbnRxdW12WStRK1BGVjZYNnhIOS9pTGFTa2x4dlhu?=
 =?utf-8?B?dVRjcER0M3RMazlKcDllSUJqLzViQlJPYXJOOWRaV2FNdGFEZGFVeVlQeUFx?=
 =?utf-8?B?eXNCQ3U4Y2lJMWNpRTRiZlVGb0VMK1hCWHpjQWhZaXNZOXIyMGp3aU02ejJH?=
 =?utf-8?B?N1BLeVRTMzBTckt5M0RVcW8xREpPL1VGdkI1dDZHaWh5SG5RRGVjRUg5RGUx?=
 =?utf-8?B?UC8yc09aUWd4UldEME1LODRoNTZCMGpGU3V1Vk5YeEFNdHJYTU0yeExJNkJJ?=
 =?utf-8?B?UEY2RUxhVUJWTVVHaEFjWnZuNENHbFp2YVNXK2Fmb0NUbG5EM0NnajBJNVlH?=
 =?utf-8?B?R3NTdjdZR1FiRWFwc3U2T1daNHFaZHdrVUN0NEpmSEZGaldyeVc2ajEyY2Nv?=
 =?utf-8?B?UWI2WUhKK2NSTDJTSTI0N3lMOWRDM3A0azRXTFBUcWZ3QW9MbWN3b3h3MElD?=
 =?utf-8?B?bWplZDNEQU5jRVJhcm5hQzRtbzYzbUlSS0VvY1l2WjdYSTlwVnh2SkUvbldR?=
 =?utf-8?B?YitETjMrSnlQd2pOK2c2TnRQdWlaSi9ZRTV0S2tRc2dJeldBSjFPZ1hkd3Zi?=
 =?utf-8?B?S25VejZZQjhWQTJQK3orSFo1VmNVSVd5dzFFZTgvNDJqbzJEWWJ2UjdCODVi?=
 =?utf-8?B?dTdWZFExQUx1MVZwSzg3VTd5YWhGWXVXNFZ0VytZT2xEOEVuM3dZZGZGbUt4?=
 =?utf-8?B?dEZCM2NoQkxYUWdKalZjaVQzSEVRVDRJYlNCY3NaYXNxazdjNzk1RkQrQnRy?=
 =?utf-8?B?U2pGL2JOYXZZMldEVjhiTklub3Y1ZERTVzUyQ3B5V0NYNTJjMitmYk5WRFFJ?=
 =?utf-8?B?bGxhYmlGV29GdDhGSmZEVUJLRElmUFFSczlGb0RGSnI1bTFXVFBTaHpPaXAv?=
 =?utf-8?Q?1wtd8IXzycKwPqCr3KwtkNr+vYyG4CkbJJ6hzOagTE=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d68a800-cc17-4e68-1360-08d9afefb232
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2021 08:43:47.3536
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ozoYaaaK4WRs7Kz8Ua9ou9oVioXd/k5bntPiOmwIorIAtZtv6Au+OXyhGb9guddagLxF5s7Uo/8fw7Rnx5ccXOEFx2FnR6iZ//p2hydWLmU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR02MB8618
X-Proofpoint-GUID: he7zKD-_7PvqihTPAoV3IOzOa1xK1Gg8
X-Proofpoint-ORIG-GUID: he7zKD-_7PvqihTPAoV3IOzOa1xK1Gg8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-25_04,2021-11-24_01,2020-04-07_01
X-Proofpoint-Spam-Reason: safe
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 20/11/21 1:51 am, Shivam Kumar wrote:
>
> On 20/11/21 1:36 am, Sean Christopherson wrote:
>> On Sat, Nov 20, 2021, Shivam Kumar wrote:
>>> On 18/11/21 11:27 pm, Sean Christopherson wrote:
>>>>> +        return -EINVAL;
>>>> Probably more idiomatic to return 0 if the desired value is the 
>>>> current value.
>>> Keeping the case in mind when the userspace is trying to enable it 
>>> while the
>>> migration is already going on(which shouldn't happen), we are returning
>>> -EINVAL. Please let me know if 0 still makes more sense.
>> If the semantics are not "enable/disable", but rather "(re)set the 
>> quota",
>> then it makes sense to allow changing the quota arbitrarily.
> I agree that the semantics are not apt. Will modify it. Thanks.
>>
>>>>> +    mutex_lock(&kvm->lock);
>>>>> +    kvm->dirty_quota_migration_enabled = enabled;
>>>> Needs to check vCPU creation.
>>> In our current implementation, we are using the
>>> KVM_CAP_DIRTY_QUOTA_MIGRATION ioctl to start dirty logging (through 
>>> dirty
>>> counter) on the kernel side. This ioctl is called each time a new 
>>> migration
>>> starts and ends.
>> Ah, and from the cover letter discussion, you want the count and 
>> quota to be
>> reset when a new migration occurs.  That makes sense.
>>
>> Actually, if we go the route of using kvm_run to report and update 
>> the count/quota,
>> we don't even need a capability.  Userspace can signal each vCPU to 
>> induce an exit
>> to userspace, e.g. at the start of migration, then set the desired 
>> quota/count in
>> vcpu->kvm_run and stuff exit_reason so that KVM updates the 
>> quota/count on the
>> subsequent KVM_RUN.  No locking or requests needed, and userspace can 
>> reset the
>> count at will, it just requires a signal.
>>
>> It's a little weird to overload exit_reason like that, but if that's 
>> a sticking
>> point we could add a flag in kvm_run somewhere.  Requiring an exit to 
>> userspace
>> at the start of migration doesn't seem too onerous.
> Yes, this path looks flaw-free. We will explore the complexity and how 
> we can simplify its implementation.
Is it okay to define the per-vcpu dirty quota and dirty count in the 
kvm_run structure itself? It can save space and reduce the complexity of 
the implemenation by large margin.
