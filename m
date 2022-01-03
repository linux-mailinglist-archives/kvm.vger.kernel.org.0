Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF04482F17
	for <lists+kvm@lfdr.de>; Mon,  3 Jan 2022 09:46:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232242AbiACIqm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jan 2022 03:46:42 -0500
Received: from mx0b-002c1b01.pphosted.com ([148.163.155.12]:36612 "EHLO
        mx0b-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232233AbiACIql (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 Jan 2022 03:46:41 -0500
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 2036sNDv011798;
        Mon, 3 Jan 2022 00:46:36 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=7EsRe6srmGPdATnDom57k6LqtW/6VrOMXmDDqtX90F8=;
 b=fWWyjwDnHIfCP8j8eu7A9Uh//sg6kEJEQRJBE3i++6Mh9+g6VOqGQ2S2rZxV9lnY+aB8
 kiaYQhQekpWbj8XNMKoqcHimTt6qTjuBQabrm+aObj0H3ZXoRD7VM24xNs2YxGYEpm94
 bXsHREbnvWMnGBecUT8r1YIavOdj4Y9X3+74cDy+EQrlGO4EiIlU3ks6EPq1E23Io4kM
 gBrjEzOmfl92B7emHpIhTKtrXt9sTRRpyYEj2PiZqev2Vd4FBUuAXAm5MzVhGNVN/Syc
 6i8jq+CpdoKNHqUYuEVK0QN1yHrdtNCShRHVBOdRG72DjIBarAbdfwmzjuHSiqWoYaU4 lQ== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3dbv9p055y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Jan 2022 00:46:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BOENGfk12ojkuIb63uwImbyxOd7xj78XCpFB3Q8p0NCF/lPSmUZztc6jbR+bcHZopCXUcjJx0IUy8KTc5edtCsEdY0lAavICzxR3W4DPRmW9+JTDtIvtoYn/N78ViuJlf8/9FEHCx/8IfIboS7547V6OX8Ghqy1ISt/w2wFHZUGkW+eVRG3nHS4vPR9x2v/Dj9lxhElhq0LZY43QWPXv6gltW7RVsdH3zyRRZdiD7F9noX3jL4h1E+Rgt2go3fnyeTOjn/npcpFMFgaTIFgW7ggpNbYqazvEB3mDL7EvPK+XxyVExbSbTJ+R08WkA1Tmx0hyeLAv+/MoIIlaNlhK3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7EsRe6srmGPdATnDom57k6LqtW/6VrOMXmDDqtX90F8=;
 b=fB/vYVwjLaYurPIuf9Kh/+CfPB2zhR5dvmtt3zSC4M1T4lZZ8BXPFim9wNCNnRsaVVTgHbSueefCUQQAUPfRt6LPLV0SNknVyUnQXlWDcfLIH6UMopo2vu7iwNnPas7vsVyuOBkkZ+B9SiYCzlg+rRbL3/j9ekYHT5reHvEU/uNHMYpHA9RUkFSAgA8w+qo9gs1h4M7SbjVXCENnhmIgmrpchOdi1kzcIv8KlzFwLeiVe82JyClprgGtz4jCqxLDSzjJi7D9+59aLZ6IvuhDJiZj40yxQhwdrTNlpUNMYyYPT8efQN+13VyLf6P9PCRtg8tc9pkWYpxpx8KiyIkFiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by MWHPR0201MB3514.namprd02.prod.outlook.com (2603:10b6:301:7c::37) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Mon, 3 Jan
 2022 08:46:34 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::586c:4e09:69dd:e117]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::586c:4e09:69dd:e117%8]) with mapi id 15.20.4844.016; Mon, 3 Jan 2022
 08:46:34 +0000
Message-ID: <f05cc9a6-f15b-77f8-7fad-72049648d16c@nutanix.com>
Date:   Mon, 3 Jan 2022 14:16:18 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH v2 0/1] KVM: Dirty quota-based throttling
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, agraf@csgraf.de, seanjc@google.com
References: <20211220055722.204341-1-shivam.kumar1@nutanix.com>
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
In-Reply-To: <20211220055722.204341-1-shivam.kumar1@nutanix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA1PR0101CA0068.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::30) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 406985ea-43f0-4db0-63b5-08d9ce958bc9
X-MS-TrafficTypeDiagnostic: MWHPR0201MB3514:EE_
X-Microsoft-Antispam-PRVS: <MWHPR0201MB351443858B565733C9528677B3499@MWHPR0201MB3514.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2rjgUciDxb/WcCFiIH38kvZucpTHXFM9MOpbpa/exGa3VH2TwGL8f+fhgOxkrXEBrDSrXLB3YyfZbfsELQTttcdaJx+1KB9/+xr9Htd/nKkwjoMMVH3wT1kUo+ovee47x6QSeEBykZ8+AYHXZuikMMrKt0knxX5v5jDa4S6ARQJzKuGQY14DeQuLDc7AYtynkGl7TFtZa4RyAyQop/8zH83We7h9aQtq+mclUUAPeh5xyZWktm1vjebYzLd/mKc157SToFY7JB887fobi/mdBc5IyAsIcdatXOLEAxs+2VWbEZVjq2cF7vtI8jivAVXPf6PIcsbNg2zQf8o0KkXEah/eWGjKu3REucW2QJ7FUPJuGrWhEbus9KRUMD8L7d97hel0PJvfI6MlOSO6mfKyMF9bhks425cuBuD6Di0QSrFjEHp3+oMStLEUcI1q9Ta7lZYPrtbII0flHmqFFLk2HxOlVGo2WifiX/77FLaDI7FxM732ddv8v8ABVMai21bVRYGYBpeeWIGV5aATZpHZAetQgvHpBCyyG9RE4XkP99GGlprNdZ2S20IKQANmqczAZAgLnuAfzTC1+MChbGIK2gtmTTdMq6R1N2ds40vgDycemAFcawmfdFHYDSZYuvv/2DaRAxgBnn9TdZ7tavNCK8g16ex0GBF3r2U0S2JWAEqUKAUBOeIGMRRtv4CWdgaxFF9hQPLrvpZGX9qvijK0WIEWwiINuG4KZ6IJt/4CpszJQiDUQkcOIG7AnyY63ENMEUbodS6Lcq1DyDj1C7XZQUP5atJN+ZVB8MToNyehEDWDymTFKrH1tRvD5yI6VjM+laj2ndsT2gS/l/g4YJXc/w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(5660300002)(86362001)(6666004)(8676002)(38100700002)(31686004)(316002)(508600001)(8936002)(4326008)(2616005)(966005)(15650500001)(66556008)(83380400001)(66946007)(66476007)(53546011)(26005)(31696002)(6506007)(6486002)(2906002)(186003)(6916009)(55236004)(6512007)(36756003)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SjdYVW1GNkNsdUtwb2xIU3Z4R2xJdHRHVG43RkxCWFBFT0NEYy90U0pKUUR2?=
 =?utf-8?B?WHQ0YjBjNkp5aHJZWEtiL2pkWUNEMlNRY045YlFaZmNBcEY4UnUxd0FoaUwy?=
 =?utf-8?B?bEE2Sml6b2tCVEwrQU1UL2hMY3FSTUN2V2dBQXdxUlNRbW1hdVJDWUpkNnNn?=
 =?utf-8?B?TkFOZy84bjNaT2l6NXlNWm5vWi8ySjlhdHhOMnJIYWhXRkZuU0lpdGVHR2JV?=
 =?utf-8?B?L3dwMGN0cFh3RjJjVU1mZUpmejlCaXNCcFZxN2hIRDhZSVJxR2xtbWRsdUEw?=
 =?utf-8?B?bUNnMUtCUHQyeEQ0OW1OWUlyRTZoUGJSRS94U21aNGlUb1RRa3JPdHI0Ynd1?=
 =?utf-8?B?cEdNeXJDRmJWQ0RYMi9qQUZkazQwMUw3dGR3T3RkaXRvMnJ3dUdtQlBRdEVY?=
 =?utf-8?B?UndrTW0rRHpMRisyOUdPNUVJMzVTbFRtVG8wZ0RuNVdTeHprMGVtaTBKSEZV?=
 =?utf-8?B?VGlpaHNxUTJYcGt2YWpMRzhLbDc5czdnK2lQMlZJeUpnVFNPalA1L2EraHc2?=
 =?utf-8?B?UFRWT3NYcEtMSjMxMExBeHN4SWNLb2VOVEFwYXI3dXVaMjVkbjE5YkE2R1Vr?=
 =?utf-8?B?cFgxOFg2YWlvcVR6VnQ0TThIeVNtZFdxTjNLWnROSTZwMlVmQ3pQbWlDMlkw?=
 =?utf-8?B?S3R0Z2pncmJYOWg3NEpJUG9qdTlqWTNzcit1bk9sOSsyRUFUM0g3Z3J2SHBo?=
 =?utf-8?B?eXAvaVVVR3VDNTRxZkF6bCt0Tmo5emh0QkhHeDVaZmVKMXRNUlNpU2NGdjBj?=
 =?utf-8?B?b2d6eDQ1SUd2RjNCZEZLR2RUendwYnhIaDhqWDBpbnNYdktNc3Vvb1dWZ09E?=
 =?utf-8?B?Q2FQWGF0RTAvM1FrU1ZHTVoweDIrOGdNNGFqbEFmVUQ5WTNnRFd4OXJ5OEZO?=
 =?utf-8?B?ZHpKZlJkajZVekpVMktpcnBKdTE0TjdybHo2SjIwWW5GSHprc2h4Qk9SMmdD?=
 =?utf-8?B?c2ZCd2FJTFhJVkFlZGZQN2ZERFk0azRHL2k1ZVhyUElEa1g5RVNFU1BoSm9s?=
 =?utf-8?B?N1BvU3RJdy9CUWd4cHA0WS9KL1hnd2xBUW9ERTIwRkN3dFZXKzZnc0lNdThC?=
 =?utf-8?B?TVJ6VXRqaXhhY1FKdG40clNIY043MHdqZm1JZ1Q0NVJOT3o2NnFKYUtTSmdI?=
 =?utf-8?B?bHhrWTBpRy9mUUs1QjJjWnZtMnlKK2NuZWY0SkVuMWREc1JhamQ5bGhMVFNm?=
 =?utf-8?B?eHE0N1RONXVYMWRRNlgycHcwT2x3RVdIMDZsUkdpYTd1b3FTMkZ2UVNnWktn?=
 =?utf-8?B?bnZnK1g4YkREeTdEWThyc1ZBYnN2bUlBSTZ2aHV6bDFOZFNxS1VvV1BKVWxz?=
 =?utf-8?B?VzhmWTlnVnRneHU1VFU2bnB0RW5pb1FuOUtpc3I2VTlNdmdxZW1vWTdld2xQ?=
 =?utf-8?B?RWVrQlhwbG8yK3FDWTNXcXN2QUN4YWZIY0VOZ2FUKy9jZ0JFK3l3WUxIaGNE?=
 =?utf-8?B?Tk44UDYyQ2k0TGpEQ1RNNXJMRHNEOEFMdGNqVVkrL29zWEJVMDh4SEg1NlVq?=
 =?utf-8?B?OXVaOE1EVHVJSDBLbXRRcmh6L1JEUDRIdEJJV29Wc0xiSlU2cU42c2dMa2ZG?=
 =?utf-8?B?NGtuRC9ja29tRlVoMnN3anlrMkdCYkJxUit0TjNxUURsRXl6UStUTlZ4cnFW?=
 =?utf-8?B?U1h4REo5WVI2NkN0NGxYc1NKcGFXNXN4QnJpNThGN0VsMGZyYTdZK1lPOWlJ?=
 =?utf-8?B?aE1Ec0FuN2ZZQ2MvRFRWWHBvUlQwS0sxZ28rMkdDWXpZSmh3Y0xVR0J0Nnhk?=
 =?utf-8?B?bGJoQXpGWU13Z3VWY1dFVkkrSk9HeTY4S2ZqeHdQVnQzcE52NWJtT0ZYNk9M?=
 =?utf-8?B?VU50WkNwaTVETEZQSjJVRUE1UDNIZmxOVXlJd0dwZVNIbjdOVklGTVR3MTYv?=
 =?utf-8?B?ZTZpSHhQNEY3cStuSFg0bCt2Tkk1OUlGVnZyZmc2cS84QnNpRVRlZGU2Mi9Z?=
 =?utf-8?B?MW1YWm5HdVBkaVFmVXM1ZzNoaUFaaXhnTlY1bFlteWFMMFFaZW5SOVBycnNH?=
 =?utf-8?B?WlhScEwyQ0hoRTlObVZ0Q2JJVXZmcGE5L3QxTFd1cWQrOWpFYWllb01oQ250?=
 =?utf-8?B?bHZqbjR3Z3Z2SmJvQ0lXeDhiNWRSY3U5dFl4MlU4cHZCZk1kemhrYzN4djNn?=
 =?utf-8?B?SmNSTWl0U1VBakZmTnJsM2E3MlU2a0xGS3MvM3loQ3Z2dDFPRW1rbTBvbjUw?=
 =?utf-8?B?QnM5SHV2MUtFUzEyc3ZqYWpwbnRKS0lzaWYvOEtGMXhHNUdJK2xicmdEMGph?=
 =?utf-8?B?RGNIQ2dQdGdqWEpJN25QVzJDNlFnPT0=?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 406985ea-43f0-4db0-63b5-08d9ce958bc9
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2022 08:46:34.1409
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: viltnBZFligsC12CvGt4vYx8CpC8/LSbj+IqIytdqSEGhdvEBVsZ0WyHdMjpJwkCHjZ0Cep7uBYjgrHuS/XWvHgnGgNvbmk6AQD/aJI+i/I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0201MB3514
X-Proofpoint-GUID: nwR_wJny3zlZOxHEkVrYRMYNPownKXel
X-Proofpoint-ORIG-GUID: nwR_wJny3zlZOxHEkVrYRMYNPownKXel
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-03_03,2022-01-01_01,2021-12-02_01
X-Proofpoint-Spam-Reason: safe
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I would be grateful if I could receive some feedback on the dirty quota 
v2 patchset.

On 20/12/21 11:27 am, Shivam Kumar wrote:
> This is v2 of the dirty quota series, with some fundamental changes in
> implementation based on the feedback received. The major changes are listed
> below:
>
>
> i) Squashed the changes into one commit.
>
> Previously, the patchset had six patches but there was a lack of
> completeness in individual patches. Also, v2 has much simpler
> implementation and so it made sense to squash the changes into just one
> commit:
>    KVM: Implement dirty quota-based throttling of vcpus
>
>
> ii) Unconditionally incrementing dirty count of vcpu.
>
> As per the discussion on previous patchset, dirty count can serve purposes
> other than just migration, e.g. can be used to estimate per-vcpu dirty
> rate. Also, incrementing the dirty count unconditionally can avoid
> acquiring and releasing kvm mutex lock in the VMEXIT path for every page
> write fault.
>
>
> iii) Sharing dirty quota and dirty count with the userspace through
> kvm_run.
>
> Previously, dirty quota and dirty count were defined in a struct which was
> mmaped so that these variables could be shared with userspace. Now, dirty
> quota is defined in the kvm_run structure and dirty count is also passed
> to the userspace through kvm_run only, to prevent memory wastage.
>
>
> iv) Organised the implementation to accommodate other architectures in
> upcoming patches.
>
> We have added the dirty count to the kvm_vcpu_stat_generic structure so
> that it can be used as a vcpu stat for all the architectures. For any new
> architecture, we now just need to add a conditional exit to userspace from
> the kvm run loop.
>
>
> v) Removed the ioctl to enable/disable dirty quota: Dirty quota throttling
> can be enabled/disabled based on the dirty quota value itself. If dirty
> quota is zero, throttling is disabled. For any non-zero value of dirty
> quota, the vcpu has to exit to userspace whenever dirty count equals/
> exceeds dirty quota. Thus, we don't need a separate flag to enable/disable
> dirty quota throttling and hence no ioctl is required.
>
>
> vi) Naming changes: "Dirty quota migration" has been replaced with a more
> reasonable term "dirty quota throttling".
>
>
> Here's a brief overview of how dirty quota throttling is expected to work:
>
> With dirty quota throttling, memory dirtying is throttled by setting a
> limit on the number of pages a vcpu can dirty in given fixed microscopic
> size time intervals (dirty quota intervals).
>
>
> Userspace                                 KVM
>
> [At the start of dirty logging]
> Initialize dirty quota to some
> non-zero value for each vcpu.    ----->   [When dirty logging starts]
>                                            Start incrementing dirty count
>                                            for every dirty by the vcpu.
>
>                                            [Dirty count equals/exceeds
>                                            dirty quota]
> If the vcpu has already claimed  <-----   Exit to userspace.
> its quota for the current dirty
> quota interval, sleep the vcpu
> until the next interval starts.
>
> Give the vcpu its share for the
> current dirty quota interval.    ----->   Continue dirtying with the newly
>                                            received quota.
>
> [At the end of dirty logging]
> Set dirty quota back to zero
> for every vcpu.                 ----->    Throttling disabled.
>
>
> The userspace can design a strategy to allocate the overall scope of
> dirtying for the VM (which it can estimate on the basis of available
> network bandwidth and degree of throttling) among the vcpus, e.g.
>
> Equally dividing the available scope of dirtying to all the vcpus can
> ensure fairness and selective throttling as the vcpu dirtying extensively
> will consume its share very soon and will have to wait for a new share to
> continue dirtying without affecting some other vcpu which might be running
> mostly-read-workload and thus might not consume its share soon enough.
> This ensures that only write workloads are penalised with little effect on
> read workloads.
>
> However, there can be skewed cases where a few vcpus might not be dirtying
> enough and might be sitting on a huge dirty quota pool. This unused dirty
> quota could be used by other vcpus. So, the share of a vcpu, if not
> claimed in a given interval, can be added to a common pool which can be
> served on a First-Come-First-Basis. This common pool can be claimed by any
> vcpu only after it has exhausted its individual share for the given time
> interval.
>
>
> Please find v1 of dirty quota series here:
> https://lore.kernel.org/kvm/20211114145721.209219-1-shivam.kumar1@nutanix.com/
>
> Please find the KVM Forum presentation on dirty quota-based throttling
> here: https://www.youtube.com/watch?v=ZBkkJf78zFA
>
>
> Shivam Kumar (1):
>    KVM: Implement dirty quota-based throttling of vcpus
>
>   arch/x86/kvm/x86.c        | 17 +++++++++++++++++
>   include/linux/kvm_types.h |  5 +++++
>   include/uapi/linux/kvm.h  | 12 ++++++++++++
>   virt/kvm/kvm_main.c       |  4 ++++
>   4 files changed, 38 insertions(+)
>
