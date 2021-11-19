Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47DD34577AD
	for <lists+kvm@lfdr.de>; Fri, 19 Nov 2021 21:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234784AbhKSUZE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 15:25:04 -0500
Received: from mx0a-002c1b01.pphosted.com ([148.163.151.68]:55938 "EHLO
        mx0a-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230474AbhKSUZD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Nov 2021 15:25:03 -0500
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1AJH6hGU012510;
        Fri, 19 Nov 2021 12:21:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=message-id : date :
 subject : to : references : cc : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=YJae4B07q0CaTXgy+EX+V1S5ZWEYenWtekVUqZVk6Jk=;
 b=Ayn163lkH9IkwaTuhJIl+EisIU6y8lYoMchGPhp7nk6TZ/X7OrMwRx7NJrDeWgonyqgA
 Ywcris7QvqkqRl9mv8uOUiwV1xLKw4L9uTuBh5EQrwtVEIEIlY8FgSMJq+XUN/FR/Ay2
 IHkkAudx089QDlxDOJeHy4cRqhRlF7FUd7AWAb+BT345jj3l/vShDbcxxgba73Vvjmws
 rv1AGYGLmFedbCK/4G3ZdcKDR+LfzDfBbuyiWbZtZKmWhIawM4oFHEdl0tUiKXR0mQyF
 2Fs2Tw8lB5Sga7Mbs1PawS5IenzOSAQ2YqNHdlNLzjKK3MbsvmUCxNbkZ8GkDh8+P9rm TA== 
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2040.outbound.protection.outlook.com [104.47.56.40])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3ce950s7pj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Nov 2021 12:21:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VdLG4g/UgG3JelGtfM/6LQ9F3c0YkuM5Cx1Z1z3AxnjoZFh/0loKZO41+o6C3HFEsUQxRRPn2MGD1Dw7GgOkxFe9+1MIpibXjxnQBI39/65Zdk0Gx2EZv5eXRUilMaMG2vtPfX4+p+ssYz3xggIVBBxVYvXeHBuVZBqI1P9mTnqWsljSDL7fdeOjybUl7Q1JPZEks2SmUy3K6lwteMTdU7YLyNGg6N/7pd7WcTt8w1GCjfgXRCXGPJ/CflzcpsxYhJGUOoGilHwpL0VSWSRDGO7Ta7xDymA/K0nVfR0gfiUzVoVMDYCABZmZn/LchlR2wEkBpZvMa2n8O7lozuJcug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YJae4B07q0CaTXgy+EX+V1S5ZWEYenWtekVUqZVk6Jk=;
 b=AuC5WAxQvUeP6hy7yuK4YvLuy+kvosW4dTJTfisAXDDzeXWdRq9PlJ6t9JlWav0svG7HunQXkLeHBb0UI0P6xdd9Oqx1ti0pDP8+Kn73iq//50svzxRefK/4tO+9+RPvsr+QysURDeqmRHKpLgcp3nqtdxznaOiMJwQ7fGZm5WCnAJBAhr7t9yzElb4ZOAfR4NEVgWguge1xz/+8Il3zI+7+ieM6EnimGy0S3Cqbqk5Z4Ct347Fle+ENTWSJ55aneeAULnTLa+QSjLT+P/6F11NEeU/EQR3AZlQvSIAQOLuNBfVfrff9cNSi1kB4HzTrq85HLrkbYsctFlhhM+8+Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by MWHPR02MB2525.namprd02.prod.outlook.com (2603:10b6:300:42::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Fri, 19 Nov
 2021 20:21:54 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::8d99:ba07:279:25c3]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::8d99:ba07:279:25c3%8]) with mapi id 15.20.4713.022; Fri, 19 Nov 2021
 20:21:53 +0000
Message-ID: <2a329e03-1b44-1cb3-f00c-1ee138bb74de@nutanix.com>
Date:   Sat, 20 Nov 2021 01:51:39 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH 3/6] Add KVM_CAP_DIRTY_QUOTA_MIGRATION and handle vCPU
 page faults.
To:     Sean Christopherson <seanjc@google.com>
References: <20211114145721.209219-1-shivam.kumar1@nutanix.com>
 <20211114145721.209219-4-shivam.kumar1@nutanix.com>
 <YZaUENi0ZyQi/9M0@google.com>
 <02b8fa86-a86b-969e-2137-1953639cb6d2@nutanix.com>
 <YZgD0D4536s2DMem@google.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        Anurag Madnawat <anurag.madnawat@nutanix.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
In-Reply-To: <YZgD0D4536s2DMem@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SYYP282CA0012.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:b4::22) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
Received: from [192.168.1.4] (117.194.217.157) by SYYP282CA0012.AUSP282.PROD.OUTLOOK.COM (2603:10c6:10:b4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22 via Frontend Transport; Fri, 19 Nov 2021 20:21:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8fd58deb-798d-4c7a-102f-08d9ab9a39e0
X-MS-TrafficTypeDiagnostic: MWHPR02MB2525:
X-Microsoft-Antispam-PRVS: <MWHPR02MB25256CA6E6B242B4DF012BDCB39C9@MWHPR02MB2525.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0TTfiAt0KpMpnCmCkaXWcgOhG3N6TXkQtD7PkSM6A8Ci9D+99aXzu8YkaMjVpf/+drwqffA/j0MMY8ZFbE0JesBIyBHRrsTqm7KSqVd2G6fs/sYhXmHm5gnV6fpKD5Dn2I4oSqQIuG6qc/dbRHhB1XQdABQUQl+gNuwVaAg+74wLDtkYhpw2OmLc8Pjj/L3rV9s3sp8txZKx/+iV9RQL72u8/49guPiTWtcIWt/sd3g5xdyBUyXpDU9Alzr9GfpQQoB5IaJ/Sb0bKxOKswjJ121oTtecHi6c43H8av4fF1GxW/aeokSWZFVg9mf1555Ix0reRqoIguqrUmGg2ONOYrFVa1HOl1GY4z1EDp9F8w/zevwKu1FAGecc2kLJAniomZGAtzK1BGoFza6aSDMQ9ilzqZvQvVE15n+Ea8Sir/ua4uswRH4yfq/tzCTARcwCCGYuIstDcjv03Ov4Dd5VR0ytncwjK1KDANVdRNA2GotuYhs6nrNOpJh3HrCIUfDzqTWjxTrRyRuY58SEEE0SYBHeXBhuyx/h/SltJeWlC/2mYjNcJJ6XiNuwIzPcsVKmOgvZdieSnaN/H6wbqMGYAItpKjGW2RSskpxCAOwuaYjP67G+pRk52jtvLAERVz0kmAD99tLXBIrRkmXcQ0XDX+COZfM8XmH2PVYuySLAT4kwsXdi6KMmm4hwtqH7mxOTmv2Ln0e5CMpdnoMsGbIxzxt+u9lkh6FJeao2o2hP7AW9E5S5jubINHApNs1anAau8dXy3Q9nNMYPjCB3NKwVSg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(316002)(66476007)(66556008)(2906002)(83380400001)(66946007)(38100700002)(8936002)(53546011)(6486002)(55236004)(107886003)(36756003)(6916009)(31686004)(186003)(4326008)(16576012)(2616005)(54906003)(6666004)(5660300002)(8676002)(508600001)(31696002)(26005)(956004)(86362001)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UjNZSzR3QXRlUGtLRWcwMmxMWTVCSDdnTzJwOGNpa1YwMkErK1ROU2NjVEQ1?=
 =?utf-8?B?THRnWit5Zy9mSE5pc3VOR1c1R3pNL1IzaXYwclBJVTl3NCtqdklQTTNEeDZS?=
 =?utf-8?B?dEU5ZUV0NXZNV1ViOThOU0p5ejk2YmxKMUpSYi9lVG84WTVDL0d4RndVSS9Y?=
 =?utf-8?B?Y1JHRHBBNERNVHVTdE5qYWljUmh2blVHUUZpdjZJbHZ3b2RheFNvd0s0MVZJ?=
 =?utf-8?B?OWFReklzOThMTmxIT2FadWJnNHErak9HTG4rS2w5WDhtUDRYRDlZWFJzNUdB?=
 =?utf-8?B?UnQ1QXZYUjJraUgweTFGYWZSZWxzRDUzZWhwTEc3cnhoa0VsKzY3WVpJMGZH?=
 =?utf-8?B?KzNCYXRaV1daQVUyRC9YeGZZdThDTG52RExvT0k5WlFXbTJUNVgxaUVQZE9T?=
 =?utf-8?B?U3pZaHoweDBZYTN2K2VGdlFZUzhrM0g4TkEyQ1ZhVDYyVzkvRTJ6MzhtalNu?=
 =?utf-8?B?elJWMW9TUko4dm5TTEdYN1lQRTZodS9Wc0ZNUEZ3cUF5aXpBa2dMVGtRQlJW?=
 =?utf-8?B?amJsc2xrZmUzc3ZPbVAxTlB5V2RqRjVXRUlwdnBCOTltOER0N0JYZlFZZ3Qy?=
 =?utf-8?B?UjNSZ1J1eThoSkVDM3cyc1N1TThjZUFyZkxCS1g5cktUZWZ3Ym5ZQS9tc3FO?=
 =?utf-8?B?Z0E5b0M2ZURKRXFjdjljcDRkWnFRcENvL0xjNmJYRjlJczZqVTcvWUcrTDdC?=
 =?utf-8?B?UTczakhaOFppYzhZWmJhWCtYZmpIL28rOTEyQk02T3hOend3SUk0UGs3STc5?=
 =?utf-8?B?QjRLdkYvSnRsc3hxQ2l1dk1XTjVsQTExVlFnVnVIUmVhbTNyWTNtNmJnUk1m?=
 =?utf-8?B?Q2EzZDJ6SDBvdHB3MjAyMmYwdm1PWmJ4MG5Qcjc0WU04Z0JDbHB3SDd2dDIw?=
 =?utf-8?B?a1JTbmUrNEhsMjlpNVgrUzZFWk1hYy9ERmd0b3pTWjdyR1o3NkMvSlZRdGRK?=
 =?utf-8?B?SkFaNjllODk0cGh4RWcxSzRUZjVRbW10RUlIc2pVZlFFYmdkdW1lVlk1YkpH?=
 =?utf-8?B?SStiMUlCRTM2Tyt0MHN2ZG5MSGF1REZrcEx6SnRvZjdzZndrMFpuSmtNL1RC?=
 =?utf-8?B?MWdWSU1uYjQrMWJPamZSKzhiRmU5aGJuZEdDUGhlWnpXL0ZxTi9OOHhuVXJv?=
 =?utf-8?B?cm9vbWpmZlJ3SkVIMytwQTBFRkVvWnFYaUxQT09URTMvVkE3cFJ2L1d0Z1Za?=
 =?utf-8?B?aXg0aTJWMnl1Q2x5U0o0MDJqd0tLTXEwalA3MnRpVi9lU3lwak1Jc0dndzR5?=
 =?utf-8?B?N0RMNlN5WFZDQ20zOHNNZzk4dGNUSFIzUjllbFJqbC9UbjZlcVJYem81NCtG?=
 =?utf-8?B?bHZ0cVRQWUFYWEdiMjNLUE9UM2pUY0hQYlF2VGRhdkVOek5LUmQ1cS9OYjY4?=
 =?utf-8?B?OFZtN3BDcm1pdEV5UlVSWlY2OVVZRG1TYmZad3hXMFc3ZmwycEV4YTVxemRm?=
 =?utf-8?B?U0RKOG05eUxxeDVJL1hxZjJPSkRUMjQ4YWhNb3BlYldPVU8vakV3STl3UEk3?=
 =?utf-8?B?SDVramF4aHNwajJpUi9NcVJiZWxoNnRJakV0Z3lPV0pJM09SK0xTMDh6Mm1U?=
 =?utf-8?B?UzJXYXlJVWMrYXZaV3J6U2lWUmNFMkFUUGgwVGJLMFdoN2dRZzlnc0VsbUNa?=
 =?utf-8?B?ZS84dHd2MlNMdXVwZUt6L1plOHMwS0pKY2w1NVZmejYrR0xyZExVb2thTm9z?=
 =?utf-8?B?Qm1yTkp1UENocTRYRVpGd0NFTTRUZThZTEVwK2ZNYldlbGpCbWZhQlRsK0Z5?=
 =?utf-8?B?QTFUbEYzTE1RTVNZTktkVnllS2R3VHJSRDdENkxlanFXTDlVNkJpZ3VqSTBC?=
 =?utf-8?B?aHpUVnlzYWxPVUdwd2twTGNEdGhaSFF3YVdTSnNKZGdWSU9yd1FVS1k4TWRt?=
 =?utf-8?B?R2xQSFJwb1VONFFKVDFRUTdUVGVkWHlzaGl0cFhoeDl1OWRjblovSnZ0bS9z?=
 =?utf-8?B?OGFYUW16SWwrWkFOditPVGJad3NsWXR5UWh3anZsVHBGRkp2cjg1b0Q4bVk2?=
 =?utf-8?B?ZVRGR3VobmkrM1pzQUgvUmF4N1Jjb0c1V1h6YTJqQ0dkZUlOUm14TW85RFJE?=
 =?utf-8?B?VFNyMlJYeEEycnNiOUJoYjRlVitCSGxIMDEyYUpWWEJmTnJWc0ZUMGNtTytS?=
 =?utf-8?B?ZTJxS1pldDhXL3dJRlVsbnR3MEE1eGJzVzhUcnp0VklYYS91b05VK083bk1u?=
 =?utf-8?B?dzFKL3lVZXREVXJHQnF5WXJxb2ZPMTFFN3RkWitsVVQvbTI3bGEvdGF0cUl1?=
 =?utf-8?Q?k0iiX+e+3S9dM46wkYsKfUv11yha9y5hDPO80I7XTI=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fd58deb-798d-4c7a-102f-08d9ab9a39e0
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2021 20:21:53.6075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9HzEZYoWTudbtEJpxxOs+zL9BBuPFpuN7cZVyQV39hlZmvZksVWn4eQnqKh7rZyV+iqFCJ/x61l3A/BkSr4TFpHlbr3Kl7oEPDt1s1cQYgI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR02MB2525
X-Proofpoint-GUID: 79gsEDv8R1GftXXZME9Knkm4KUMfHGO4
X-Proofpoint-ORIG-GUID: 79gsEDv8R1GftXXZME9Knkm4KUMfHGO4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-19_15,2021-11-17_01,2020-04-07_01
X-Proofpoint-Spam-Reason: safe
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 20/11/21 1:36 am, Sean Christopherson wrote:
> On Sat, Nov 20, 2021, Shivam Kumar wrote:
>> On 18/11/21 11:27 pm, Sean Christopherson wrote:
>>>> +		return -EINVAL;
>>> Probably more idiomatic to return 0 if the desired value is the current value.
>> Keeping the case in mind when the userspace is trying to enable it while the
>> migration is already going on(which shouldn't happen), we are returning
>> -EINVAL. Please let me know if 0 still makes more sense.
> If the semantics are not "enable/disable", but rather "(re)set the quota",
> then it makes sense to allow changing the quota arbitrarily.
I agree that the semantics are not apt. Will modify it. Thanks.
>
>>>> +	mutex_lock(&kvm->lock);
>>>> +	kvm->dirty_quota_migration_enabled = enabled;
>>> Needs to check vCPU creation.
>> In our current implementation, we are using the
>> KVM_CAP_DIRTY_QUOTA_MIGRATION ioctl to start dirty logging (through dirty
>> counter) on the kernel side. This ioctl is called each time a new migration
>> starts and ends.
> Ah, and from the cover letter discussion, you want the count and quota to be
> reset when a new migration occurs.  That makes sense.
>
> Actually, if we go the route of using kvm_run to report and update the count/quota,
> we don't even need a capability.  Userspace can signal each vCPU to induce an exit
> to userspace, e.g. at the start of migration, then set the desired quota/count in
> vcpu->kvm_run and stuff exit_reason so that KVM updates the quota/count on the
> subsequent KVM_RUN.  No locking or requests needed, and userspace can reset the
> count at will, it just requires a signal.
>
> It's a little weird to overload exit_reason like that, but if that's a sticking
> point we could add a flag in kvm_run somewhere.  Requiring an exit to userspace
> at the start of migration doesn't seem too onerous.
Yes, this path looks flaw-free. We will explore the complexity and how 
we can simplify its implementation.
