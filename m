Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 457DF4A6ABD
	for <lists+kvm@lfdr.de>; Wed,  2 Feb 2022 05:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244239AbiBBEHd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 23:07:33 -0500
Received: from mail-dm6nam12on2082.outbound.protection.outlook.com ([40.107.243.82]:53344
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232069AbiBBEHc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Feb 2022 23:07:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F+HOmZKbEv1z5oSKdJ+lKN2R91vTG5LAzybo18YFE53HZcB0eeix9Cr4Q9p8djfOttI82YHE2Lc0+5ju3/ZePG9jBrBj/N5+lRScYQGixoYcSLOG06CR8xhUk56H39DBtNpiRYS5of2IqSA/NNk9RVOVysYXsl2ZZoaaBMv2Hj4gZy/RBcY1TbfsCV5HlMLt5TVw8qv7FRR10mVXekc6ks9cTa556w1cO+Q0lZS/iV749uRJ5Tr0fj1zHzDJ/TEbYhZP8JTXOV6nI9dVpIMEjq8ajnqcnNc3ctLRWSU57EYkere3k5sG521WvkIcjLA3pJwGjG7qNpC7QmL7f/9VnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5Ov4a2TRFO4bu9MrlW43ER2ww6T7yeCGuiqobebz3cc=;
 b=ZJv/aHTz8GX98azOGxHWAq0MuBrxVoKNXf4MX3xR2Wf1dk4MEaCkogEEOQohd8cem/28AeF/iuXytkJKnegVhTInVq1rBskyMLT3H18OTtBDl4Rquz3Tt9pVlF/wffVSYuT8CbtxmxwNjIwZ6BUs5wBd9JCkBD2IGXHQFR0gp1pMvyDL2l6K+junknA+SoTYDzcza5151ozlftq8NC8ac1Bcw8KRB0/llAvlQHwE7csC9sdfKtZKCvcJdUKGlbHLChasTA6oY6lKTzOq6KEXVEjDwetrmRYMFlHaGqVl/VTbW4JvDJkKuMQ5bZmEx7Kft8GYyEpvAnfCRatRW41lwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Ov4a2TRFO4bu9MrlW43ER2ww6T7yeCGuiqobebz3cc=;
 b=QpVF2hPasjparGiMY5ny+kOV7WqXLUYuzxACMVQnJuDlm1+oydkDNoGTHd5P2il/F9b0H3uKtZ9yao3NISlV72mCnK5DLpATmqAzIFg3dhRjjrSyW58gf9E1m0T7Le54P5UdksU4bhaGRAjJiCq8ikh7FojoXUf2+IrisDYmvVo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB5452.namprd12.prod.outlook.com (2603:10b6:510:d7::16)
 by DM6PR12MB2732.namprd12.prod.outlook.com (2603:10b6:5:4a::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Wed, 2 Feb
 2022 04:07:30 +0000
Received: from PH0PR12MB5452.namprd12.prod.outlook.com
 ([fe80::c071:3b53:4a01:8b91]) by PH0PR12MB5452.namprd12.prod.outlook.com
 ([fe80::c071:3b53:4a01:8b91%5]) with mapi id 15.20.4930.022; Wed, 2 Feb 2022
 04:07:30 +0000
Message-ID: <7108583e-d495-809f-9530-63dbd5e15179@amd.com>
Date:   Wed, 2 Feb 2022 11:07:17 +0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v3 3/3] KVM: SVM: Extend host physical APIC ID field to
 support more than 8-bit
Content-Language: en-US
From:   "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        pbonzini@redhat.com, joro@8bytes.org, mlevitsk@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        peterz@infradead.org, hpa@zytor.com, thomas.lendacky@amd.com,
        jon.grimm@amd.com
References: <20211213113110.12143-1-suravee.suthikulpanit@amd.com>
 <20211213113110.12143-4-suravee.suthikulpanit@amd.com>
 <Yc3qt/x1YPYKe4G0@google.com> <34a47847-d80d-e93d-a3fe-c22382977c1c@amd.com>
In-Reply-To: <34a47847-d80d-e93d-a3fe-c22382977c1c@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: HK2PR06CA0023.apcprd06.prod.outlook.com
 (2603:1096:202:2e::35) To PH0PR12MB5452.namprd12.prod.outlook.com
 (2603:10b6:510:d7::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1c56252c-0307-4478-c78f-08d9e60187ad
X-MS-TrafficTypeDiagnostic: DM6PR12MB2732:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB2732865EF457D506C73E9A78F3279@DM6PR12MB2732.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Kw8dYgc1kTfR2uZOs4kuMtWrReoo79kpwRPbBdsvSEC2vTHL/oBPT3mB4903/sXbtO+GoEcLvDI0A+Ka37s6ShMJQ3a1GjqB1N0gmizombEmN5z/Pu5GXMlGnwQ8Db3F8/oR058v42+ZsqvOYUu2eReCg3Mg5bbGl2/FKYWX+EsR36bM2vHe8wXZHjN6GK8gwqnMey2bxqr51XhcClKhflMhkhHXEqNYka3/SlouHK5aZaoZRDz7OvuUsdCptVyE1pRGisvTExnZXJw6ob2k757iuvE+/vlZGz8o3pYvCB4c2qvTxDK/WSrIHUeiWy/jHoqB71U05CEvsdHDgCaHrWnfOMEXCiZeEowAtxz7D5bNz8K4nTMRtdU56ZAWZxbZd/Wlmx8s+p6KL9xV+ZnC9EFdcyRiiKIdtyj2JlUSy3iC5TaSrCbofx+eKoibHk8AJUBAkeXYHFE2u/8J/3uUeBAuxc8L4NZG1xnMANqZNWpiGKCVCFpfxLCnXF57buHxsjUX+9z7x/p6jfK5kKcUgUtywif0xb0QGxHDwbhe1xrGZaEJiEtM+We2aCvyMQmjdQxOrOnyONloNJFUQFGcvq1GSum5mKVppvqYE2e3dyPGAKJ/1v7tD0MxpB0mqSQvLAFmamTUcZbK91f42zvh3n35OuOSJTA4Rt2Nc+Vs6/dF667ne+CyP5OuqsuT+rBi4RHJdmuc9qhdeAJ8Fg8z+muzYKssdj8va/Z2VTaTHmMYMeedFh6YY0W0vfNeg8pB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5452.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(7416002)(2616005)(5660300002)(186003)(26005)(6486002)(316002)(6666004)(53546011)(31686004)(6506007)(6512007)(6916009)(36756003)(2906002)(508600001)(8936002)(38100700002)(66556008)(4326008)(66476007)(8676002)(31696002)(86362001)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U2xGWkswNUhaK2t1T3dWbFNBU0dWQlBIWG1oVVRQT2NpbnNqdDUvZXZGTm1z?=
 =?utf-8?B?SkF1cWJQTFN5UUd1cjgzQTJ2TnpvWjNQYktZd1RZSW9lZXp1b2h3TUMwTDFa?=
 =?utf-8?B?TGJHbmpjTSs2UDJzTnlqOWV3Wm96bzUySlEreFQrbTY3SXJyZjNjRElpemRh?=
 =?utf-8?B?MUtvS0lNcVdEdmxRWmlXcXdlZTByWUVDOHFwS3BxS0lsb1JzeDUvdmZYZml3?=
 =?utf-8?B?dVZoVGpSRk53OWl6bHRGbXY1aVcydVlqR3VnMHFQN3MxU0NJUk5BTVkyOUN4?=
 =?utf-8?B?ays5M0pFREl4aUFjUU5CdkNvcWVaQmxkS3VLVWR3Z3N5U3JXV1lGZE9QdllL?=
 =?utf-8?B?b3RZQVdsSDVRVHhZcmo5cjRhd3FSbmtOL2tJWHVQY21VT3JNWm9DL0ZBOVQ1?=
 =?utf-8?B?NWlRSXFSUDBSeUxBRkdTaXI1MnlPMG90N3VRY2c1NUtFR01KL0hkMWI0MlNv?=
 =?utf-8?B?TVFIRzNCZWd2STAyYWFzVWFnR3J4V0pQQk1nR3VJMXNYZTJVY0JRZE5UaGtZ?=
 =?utf-8?B?cU42SHlpbGd2Y1ZmL0JrUDhUbk9QVUMrTktvaW12T0RKYVAwY2w2eURxMW5R?=
 =?utf-8?B?WHJVUTRHSjNONE9IbUxSQTh3aWlST0l5ZVpZOUhZUnBBZUxaRzJyQVhIZTVr?=
 =?utf-8?B?Zm0rNzdZeXFrZ1g0cXhqcjlsVEUyTTZCaitOejFTSWg1REZkUk1GQ3ozMXhC?=
 =?utf-8?B?TDFoTHJTY0hRUGpsYlJ0dUFrZlV4clB0U1o5ZGdPMVRtM0hmUlNJUzRoajhE?=
 =?utf-8?B?OUtETk5yWWZXK0tjdzJLRXNWVWZPejhRMjdJUitNa20yc2dkcnJIS3ZWSFRI?=
 =?utf-8?B?N0hqR3lJQ2dCVUtZdVVTbFFlUlhSUVJuRDA4YjFxZ0R5K0diZnpiY1ZOeDlC?=
 =?utf-8?B?d3BEVjUwQ1IrVy9RMjl0ZXZIdEF0bmloR3lMODIzZkJEbk0vWDJFY3hGWkxS?=
 =?utf-8?B?cWlseWlzam40NTcrejkvUWJOaU1wYUdydm51RHUxUW9scFBqdkJmSnYrOUdV?=
 =?utf-8?B?OXJ4Qk5HcjlONU1pcE40QUxIY0MxdWhMNlRkRGM5WUNFbnRpbWFWakQ1amZE?=
 =?utf-8?B?UVNzeUhoZU1Wc296SGFrWWJqOGh0cjRXU0VtS2hOUVZkaVF4bFFkaFE5S0Q2?=
 =?utf-8?B?MmFhQzZrMEY4T0V5bGFhcWk4T3p2VzNjRlZ0d2I2U05sNGFIZ24vSmJxMzZD?=
 =?utf-8?B?Q1NwMjliUk9XaFZhekNRbTVqS1kra05KaXhxZWJvZEdiWnFhSjJVMGxpTG1P?=
 =?utf-8?B?MGttUk9uSGNOelVFcjlwb2JoK3VkSkp2Nm8vNU0ybGx1Wm05eWpzbVhDcmJF?=
 =?utf-8?B?NG1mRDljQlVOZXFQam83ZUN3alhsTFNxZjk5OEdKRU1SbFlzZGlmOTJ6T0U1?=
 =?utf-8?B?NXpjNmtmWUVVcUxFcHl1SklaNW9EdXU1SnNrNytIRm9GWk9ycVFuaGRKaFFI?=
 =?utf-8?B?VU9scTRobW1GV3lQWTRHWXJ3OGdveVlLbDVuemx1NUhjakw4Vi9ocmJZbkpp?=
 =?utf-8?B?WUdTNXRPTnovMUxwRTFUTlp5M3hWRTlBZkQ1ZlF3bkNvUllzUGZwQ0l1M0M0?=
 =?utf-8?B?RlBZbVVxUzhBSmcvU2laem1ZV2ZTZFlkNlBEcE5ad3hHZkl1bVpoNmkvWjlD?=
 =?utf-8?B?TkhuWURpc2FKeFZORzZYQlB3M21iL2hsTnhTOGxQV1d3ejNUam53RTMwdlIw?=
 =?utf-8?B?Umh3MTB2V2tvR0VmdVJxMVZXZDBPc3dmKzQ1Mk1JZHBGY0R4bitZUWdQOE9M?=
 =?utf-8?B?QWFZK3FlcVMzbXdvdEhENFhjZXJHU1laQ3JGeGhHTXJYdStlR1JFemhvRHpn?=
 =?utf-8?B?TExSemY5SkxuVG5uMGtXVVBQRkd2ZFVsNy9ZdXA3bjdNUEc4TktwV0I0cWlY?=
 =?utf-8?B?OUhUWnVMdW5ZSWJzTmRML2tzRjUzZGdZR1VMZFhDZ2tjWGRmMnR2VVVBUHh4?=
 =?utf-8?B?bFR2cWhLNDIvL1dud2dsTXc5NTBvMWFvMVBKc3JUdnVvRGR2V0F0cTVlcnlV?=
 =?utf-8?B?aU5pdDhaWkFLWnNGb3dRbUdVRld3K2JVb0ExeTR6dlNWczhqUEIzTjBtUFRk?=
 =?utf-8?B?MllSZlBvdmtJaXV0NkdpL3IxNXlVdHFPVDc4aUxzOEZCS1R4am5nSU9PUmxo?=
 =?utf-8?B?NlcrdEtDZFhqZXdMN2pudFJUdUNOeUt2WW45TVVCS2c3YVh1a2JBaVBCTFhM?=
 =?utf-8?Q?87X/atauZoxgjZ+Va82ZF7M=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c56252c-0307-4478-c78f-08d9e60187ad
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5452.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2022 04:07:30.3595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sBDj5bO1u50Qk0hUJjlavwLtMmSd7rovM1nVdN3VxjU6KPC7xeGVIghshOtfKOu0tBPVU8w+UKzpI/zqDh1xTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2732
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/1/2022 7:58 PM, Suthikulpanit, Suravee wrote:
>> Anyways, for the new larger mask, IMO dynamically computing the mask based on what
>> APIC IDs were enumerated to the kernel is pointless.  If the AVIC doesn't support
>> using bits 11:0 to address APIC IDs then KVM is silently hosed no matter what if
>> any APIC ID is >255.
> 
> The reason for dynamic mask is to protect the reserved bits, which varies between
> the current platform (i.e 11:8) vs. newer platform (i.e. 11:10), in which
> there is no good way to tell except to check the max_physical_apicid (see below).
> 
>> Ideally, there would be a feature flag enumerating the larger AVIC support so we
>> could do:
>>
>>     if (!x2apic_mode || !boot_cpu_has(X86_FEATURE_FANCY_NEW_AVIC))
>>         avic_host_physical_id_mask = GENMASK(7:0);
>>     else
>>         avic_host_physical_id_mask = GENMASK(11:0);
>>
>> but since it sounds like that's not the case, and presumably hardware is smart
>> enough not to assign APIC IDs it can't address, this can simply be
>>
>>     if (!x2apic_mode)
>>         avic_host_physical_id_mask = GENMASK(7:0);
>>     else
>>         avic_host_physical_id_mask = GENMASK(11:0);
>>
>> and patch 01 to add+export apic_get_max_phys_apicid() goes away.
> 
> Unfortunately, we do not have the "X86_FEATURE_FANCY_NEW_AVIC" CPUID bit :(
> 
> Also, based on the previous comment, we can't use the x2APIC mode in the host
> to determine such condition. Hence, the need for dynamic mask based on
> the max_physical_apicid.

I recheck this part, and it should be safe to assume that AVIC HW can support
upto 8-bit (old platform) vs. 12-bit (new platform) depending on the maximum
host physical APIC ID available on the system.

I'll simplify this in v4.

Regards,
Suravee
