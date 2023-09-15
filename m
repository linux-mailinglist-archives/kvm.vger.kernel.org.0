Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DBDC7A20F3
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 16:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235768AbjIOO3y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 10:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235773AbjIOO3v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 10:29:51 -0400
Received: from repost01.tmes.trendmicro.eu (repost01.tmes.trendmicro.eu [18.185.115.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB1382723
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 07:29:36 -0700 (PDT)
Received: from 104.47.7.169_.trendmicro.com (unknown [172.21.183.240])
        by repost01.tmes.trendmicro.eu (Postfix) with SMTP id BE46510000E28;
        Fri, 15 Sep 2023 14:29:33 +0000 (UTC)
X-TM-MAIL-RECEIVED-TIME: 1694788169.273000
X-TM-MAIL-UUID: 8f4fd181-6849-4294-b33e-008779efccb3
Received: from DEU01-BE0-obe.outbound.protection.outlook.com (unknown [104.47.7.169])
        by repre01.tmes.trendmicro.eu (Trend Micro Email Security) with ESMTPS id 42E5210000E23;
        Fri, 15 Sep 2023 14:29:29 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dRMq9BKUOCAGwDmC5ZFBDtYLHZjkvAzL9GtobZfCZnzB0o9jmxZWWkJ4ed27e2Oj0lhYzVSyKZUusrc6WYBnSUZzaLrwC6o2G52+wnwCAZf6zuv+sZEUHhM3J3+VGMsia38AZckqkVK9RJuB4KVLs/Wxzs3g9fVVo4wqXjXsbv7TeHtDGMfMns6mbjZArhIMZKD4RvCqn4wXEdDpAyLApOX33y12ksr4Cjc8tIGu9ZlHaLUv3dV2iWn/tzpu/C772kD5WqJCprBRPobe9HO3GS7iOvie9ZDe/UBt+qENywX6KFJ34LQDDgLEe6EWUI751HdxdbzTAfffCjhZpR653g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/YOCRr7Vd+idlokNwWHHhGMbBW3RYifZ0vKC9fNdBO8=;
 b=JCzGpC6IYsujWKD48bOg9OstYmjtxVxG3ppA46Yadly28m2Al8YcZ9SM0wE826gGIKpKujwZWjEX8MLZR1tXhL7rDK++yy/Ec7ZKQ6jYH5dHf6gTp8uVaMuKFkM0zYViuP6xfOU81l1ptUWZK96Ni/W9AfDg7Pogr8UD6jWoywmUbzuEHCl0wvkA+x90yo0HGihuQwuUvvFHstj6wMKgqtkEQGYHOUtObs9aHMlsst4HU+O4+8ApgwaYdDZ4ax2mDMg9I0txLS7EJz93S3xKmtt1/m68vd8tROsBNn0ubGkL3SKpvFnRemkdPg6so9g2UfK5fk28FtEFgI1daPR0AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=opensynergy.com; dmarc=pass action=none
 header.from=opensynergy.com; dkim=pass header.d=opensynergy.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=opensynergy.com;
Message-ID: <2d86145b-4b70-5f3b-cf54-a6994ce24783@opensynergy.com>
Date:   Fri, 15 Sep 2023 16:29:26 +0200
Content-Language: en-US
To:     Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Richard Cochran <richardcochran@gmail.com>,
        John Stultz <jstultz@google.com>,
        Stephen Boyd <sboyd@kernel.org>, netdev@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Sean Christopherson <seanjc@google.com>
References: <20230818011256.211078-1-peter.hilber@opensynergy.com>
 <20230818011256.211078-5-peter.hilber@opensynergy.com> <87cyyj1s40.ffs@tglx>
From:   Peter Hilber <peter.hilber@opensynergy.com>
Subject: Re: [RFC PATCH 4/4] treewide: Use clocksource id for struct
 system_counterval_t
In-Reply-To: <87cyyj1s40.ffs@tglx>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BE1P281CA0487.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7e::27) To BEZP281MB3267.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:77::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BEZP281MB3267:EE_|BEZP281MB1976:EE_
X-MS-Office365-Filtering-Correlation-Id: 79add923-b567-4374-cc51-08dbb5f82ad2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vDtebHjSf+RCddnWqaIei10EXI0io0tsYVEggXu+7LzIJ9F1XqeOuzLyEvp9sjpjG7NXlxiCV3Z6XLC4F28xKR1bvJtlskfUBEaHRWAf+0ZuDJNzvRL9dRNhMR7YGDoaHhp2rMHhBSLHvOYp50TeOO5ulKjOMdhOWua15NDRg4Re5XBdunPa9qO9o2YG/QenGma+0Nej2zNjC8O0WuBytnHrRRz6MIIw73U+6pUzb/jKAWl/X6KDKoNJAp5/Q5DolhKRZFkHDzqv/iwXHSXrbmRBDXIWTm1tATjaZ4IPY+SOeVg7lKDG1VEZuq1sIq9HWpuZO5tUIfO8WVd6ObQGzUrsyOrzB8GHN3apfET/XP+g6suKiTB/9uN8BwoEdDnQFuBWdvWeUDQqPAYEW1miuiur9h0OEpBOdRYsMqsNzuE4T2wRyYevwqgWx7MugRQeaHyrPEoJUv4MeV2WUXMY04Y2sYVVrX+ogoyJxbE4hRQSJk282eZ05T+MqSC1uUPhM7/zA88T8+RA4gLJRCqpRTIyJW7WWGmizLJ85RKCMVUEjERqnCeKrDWtcIG7O5vWv2qB47y8fsuI72AMFeGFyb8pMY0j+DYg/I0x0IGJVgs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BEZP281MB3267.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(366004)(376002)(136003)(39840400004)(451199024)(1800799009)(186009)(53546011)(2616005)(8676002)(44832011)(5660300002)(8936002)(4326008)(7416002)(86362001)(2906002)(31696002)(54906003)(66476007)(41300700001)(36756003)(316002)(42186006)(66946007)(66556008)(38100700002)(478600001)(83380400001)(31686004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZkU4THFTcmtCUE11R0U5QTVoSytQRy9IZFJEdmZ4aUVmOUhYT3YyK0xhUm9Z?=
 =?utf-8?B?Q1RmMC9oalUzazB4and4YXNrdjZqL0xyNGpTcmlXd1R3MVhQSHpBVUVsMHNG?=
 =?utf-8?B?djcyYVJucUJZVXQ3RUVvRXdBZ2tNbldCLzg0cUZvdHdZdnk3R25qYTBNS053?=
 =?utf-8?B?ZFVLV2ZvSDNLZWdyM2pkZUhnbFkwcHJDMGdmd3ZoeHlVMlQ0eTF4dkxaZThU?=
 =?utf-8?B?cklWS0EyUWJyd3docWpaSTFqNXZtQThFN0hyS0duMlRJejBtb1h3OVFBQVpJ?=
 =?utf-8?B?ZDloM0ZmbUtTTUhKR0lCRTlGZ2dGVEY5bjlRUWhqK2tOQWQzOEhabFdFNzFk?=
 =?utf-8?B?T1dUUGtVNHRMaFJsMTJBdlhabDRqN0dnT2h3K1hDR1dEeFBWMWNzS1Faa2xr?=
 =?utf-8?B?QjVVbDU3Tlo1bXhhYmtQMmh3ZUo0M2ZlaVArZ1N2eENVcTU2ZC94dHM4Zk9a?=
 =?utf-8?B?OFpCdEI3VEJVTnZDUFFVM3lJUGR3bGdYUzF4MDlLY1o5dE52SGkwNVNDZjVi?=
 =?utf-8?B?OUQ5ZFVFeHJSRkd3bDhpaVYyeFo3L2dQQ2F0SjU2OWZMOUhHdUxuRmRmbXdp?=
 =?utf-8?B?eTh4Rkd5dmlnNTBza3NISFFsM3JJMllCOE14TjFydUJ5U0d4cmZ5dlpqSUtV?=
 =?utf-8?B?RUlUZkNRZTlOc25TQTF3a3B4SEp0dGpKRVdzSUk4dGZJaXVVTXZxai9DdDM2?=
 =?utf-8?B?YVVHVUNmY1czM2UzbUhGU2t4M0d4eDhha0p0dWNUZERzQnNQYy9LcVgxblpx?=
 =?utf-8?B?YXdTVFpsdjRiejExdUprK3NYUm0rZWlTdWhtOUhXd2M3eVR3MEJoTnp3WWhU?=
 =?utf-8?B?dGtwbzZTODhnb2ZoVVVDZXkvZTZOR1hTVWdWWk55S0x4S0JCdWV5UWRhU1VB?=
 =?utf-8?B?UlEwNTRzRXpCMFVRQTdkNkU5RTZvR3p0b3pxaDRvQkYrUmlBbDZvbHJqMkNW?=
 =?utf-8?B?bmMzOTE1Z0dsYXpCc3RGUHZ5dW82RzNkWEpRYnlYM3VIc0FZYmhBZ3pyUHoz?=
 =?utf-8?B?M1ZGcThVdTk5QVFHYjlzY0RvOTAyeUE1SXRSZjFMZnM4L1ozUUl6T0JSWkVN?=
 =?utf-8?B?T1BTRm92STZ4MjBtWGcwVGxHTjZVMndvVjRyekJ0aGttMERJZFZ4SGNHdnhB?=
 =?utf-8?B?enJKT2hDalRZbUdvMzJhSWZoQVNqV1NhQVBLZ0ZLdmNJZkk5S1QrMXJVakpp?=
 =?utf-8?B?U0o5a1JxN0ZodEphZ1FZSnZ3REFMeGhsdnhpN2xsK091MUFzSTdHT3hSWUdU?=
 =?utf-8?B?K3hlQkFYb2R1eG0rMVJNVFl2ZjRTeDVKM2phVFM2ZWRSOUFCb2FZczRoZDhl?=
 =?utf-8?B?QzJadGVUVG5rQS9iYkhRZy96ZDVyaDhHMnZWOVpBTnJsOE1CSmlvdi9HZlZ6?=
 =?utf-8?B?amdOSFdjMGhESk0xYmpNNk83Wkw3SWRsVWFyLzRSTTk4OWsrQUFKeUZZc2VD?=
 =?utf-8?B?M0ZtbzBkSEpWaFFIVFFBOTZoWlI1ekVBUEhmSk1PWGpiY3V5UHc0UFZIUCtR?=
 =?utf-8?B?ZWdWNjZIMlJFVmI1VE1BeFU4WlBJTEVGdU16amlsaFBkV3dFTlFxNGt1MkZi?=
 =?utf-8?B?bVd2NEkrZGVxOXFyeWtXdndlTTFubWQ2SmJPdEVRWTlGMVNDemxidkFrMVZT?=
 =?utf-8?B?SzZGN3BLSUlHYTdGdGs5Q00zYmVxRHR3NEpEY1dHZW1IUmdMZTNTbmNXK3R6?=
 =?utf-8?B?ZnQ0KzJxNnB2UDVPYitTRmQxbDlQZ3NOZVRlNVkyWGtVcENoQ0dXbHZ3Qkk3?=
 =?utf-8?B?QjNRTWpFZFB4WGt3bGpuZ3dMSEJZUmdNTExQM0wzTFFPcGg0S0dmeXJRTlRV?=
 =?utf-8?B?UExXdU9wbEhUUjhabFRDK1JNSlY2QXhvcDdBdExHRWFRV1YwTS9FU2ZJYVpY?=
 =?utf-8?B?RVpzWmxQcmQxNlhjdXpnZUF1TFRCbnBkbHl2WStsT1pFeU95Y1g4WTZSWEY2?=
 =?utf-8?B?b0V4d3Z3cjY4bzZhckwxVXVFTER3RU5sWVl2TXhFNlJxNW1lTHZuMVRKdmV5?=
 =?utf-8?B?RFF0VW1ET3hsZTI0RFFUekVyZHI1cHF4YzNlZ1JlR0JTRVlxekRLektQb0dL?=
 =?utf-8?B?VjJPOVN1OHlOTHlROGRJOWJRekZVcXFtdzMxS25CelZrYldtR1Z0NkVuQTV1?=
 =?utf-8?B?Q0QwNXhqaU93ZjJkaGhaZ0Y1em1keFdaWWtYSGZFU3pEbnhwV2loeHBTZ2tI?=
 =?utf-8?Q?/Jj9Qx0eDk6HgcoXBO5HqNasbb/B6T0A7jXLO8BrEMwA?=
X-OriginatorOrg: opensynergy.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79add923-b567-4374-cc51-08dbb5f82ad2
X-MS-Exchange-CrossTenant-AuthSource: BEZP281MB3267.DEUP281.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2023 14:29:27.9372
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 800fae25-9b1b-4edc-993d-c939c4e84a64
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: piPY6vBj+xhgfuGZtR1jlFh7hQpFidvOls+z0Ukl9euOdVzj2o/h7k+zuU8NbMamYKZ72Zowre3i/LuPgDpjtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BEZP281MB1976
X-TM-AS-ERS: 104.47.7.169-0.0.0.0
X-TMASE-Version: StarCloud-1.3-9.1.1011-27878.000
X-TMASE-Result: 10--15.353700-4.000000
X-TMASE-MatchedRID: csPTYAMX1+FTzAVQ78TKJRhvdi92BBAuXpSxZKDDzFhozSUeriwd0u3B
        GET1km48XvqmpBh/VkRVOatUPwbcaGev59AGO8T0WZxYhPYYrMlHgZVDYg0zz+0uYq/7FwPV+HW
        h3/hSrx4Lj8mIVUZiRbKtBHeq5pynzuKOvR9s2zjrH5D64+wmqlzgM7hIcvnqq/k+vAuTa+9PQF
        Fk0j5jBsA2iDfbpfy+jX3M0aFmhUOwz/eb2SjfKA+CPtkLZ6dFoli4ZoiOHT9+ICquNi0WJNhhL
        hKeMa4TW2/AvJtiYk/OoZOD3i2Znm20G4HJBgf0ftwZ3X11IV0=
X-TMASE-XGENCLOUD: eae4d07b-d8b5-4360-9779-d75645508c42-0-0-200-0
X-TM-Deliver-Signature: 2042CD0A515A49FE44878FEA1CF583C2
X-TM-Addin-Auth: 7LJL1XfJVEiVW7PmHQol6NJqjD8hglERfJJ7PL8yUJzO+pKkIhLpcePRjVu
        dHGrlzH6cmIyHag9K9VLd37/eBB2XOD5gn0C0ErNeFUD4LXqrBt7BuDFKfFOWAOFnG1WppHhFM8
        qTx+xoFOlBReXi4a02450N2CDryZOdotaXKmEhzWun43mqdKp+M/U/dOUu4OdFfH0fRG0nr/m7p
        2mY6JdXzdRtXY3yhoND3p7qbQBYJD5u9HM5VEO9swA/5TUXPK2Lly3J546LZUpfx0VJH8Tskh8W
        UjjBmwWcj426PrQ=.B0ziTarGOqjtbKtS07UJvime+jT7nvwWMyGzvsZA2kLbizxxyMCaSbqNey
        9chc80ggmJnivWYwQqELwaxyotSaMn/Ztm5RJL5WmnQAhRxirjACRYm2NSEswgzPJmUHEnPupBF
        ettAJUvEamaeJILZwGZiLvNgr6Rp6nRYbjqxOer9RKR4TVXY9OwrdGo/WRUoqeIY9Auk6fcWWjF
        ctKw0XzubLAHWdAKbnIFGYtx9fgUO6SBAlQIq5qbkx+/1Ga7As0gQvN9baQPBMUQ/n7BrqMV1tE
        3kRxEDE2kVg3xQ5lMM1xB0BRDI+8CxXW64riBT0eEtVCDteJRj+PxaASH/A==
X-TM-Addin-ProductCode: EMS
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=opensynergy.com;
        s=TM-DKIM-20210503141657; t=1694788173;
        bh=oWVXkE/PcFjpXyxbGqStnoHaczkM5NrDB4ACbrFOKNs=; l=1603;
        h=Date:To:From;
        b=rWk+4Z9kpgCXl/lR51Qa+ZLX/RRmMOgqzpdhPhkIk4OavrLEEE5kksM3K0O8BnsBJ
         dMdKV0yTSRoHUVDVwJlXZbEzQomOHmsVL8mB9M42pp1VOZqmtS91AoJwIc0fij6Ago
         yosQD2aVv1ZXEXXJp+Qe+45fwkavv9Tm1UBjKKI104An1tjpApwyafKHjHuVuhMq8Y
         wq8xb02YMMVFr89u8SBR5Q0WAeDUAeZthw1UDEsXsj+GbybETyVrI03Jehz6EOGqzs
         di8DQDkHmPbfMTdlMre6ajF2sw+kRciLVIGPnF9v0g9NqXpZ0Xt7o6BDOhes1Rg4/k
         IpnOvL92O8Ytw==
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15.09.23 15:30, Thomas Gleixner wrote:
> Peter!
> 
> On Fri, Aug 18 2023 at 03:12, Peter Hilber wrote:
>> --- a/arch/x86/kernel/tsc.c
>> +++ b/arch/x86/kernel/tsc.c
>> @@ -1313,7 +1313,7 @@ struct system_counterval_t convert_art_to_tsc(u64 art)
>>  	res += tmp + art_to_tsc_offset;
>>  
>>  	return (struct system_counterval_t) {
>> -		.cs = have_art ? &clocksource_tsc : NULL,
>> +		.cs_id = have_art ? CSID_TSC : CSID_GENERIC,
>>  		.cycles = res
> 
> Can you please change all of this so that:
> 
>     patch 1:   Adds cs_id to struct system_counterval_t
>     patch 2-4: Add the clocksource ID and set the cs_id field
>     patch 5:   Switches the core to evaluate cs_id
>     patch 6:   Remove the cs field from system_counterval_t

OK. For 2-4, I assume split x86/tsc, x86/kvm, drivers/ptp (which
also handles the CSID_ARM_ARCH_COUNTER case).

>> --- a/include/linux/timekeeping.h
>> +++ b/include/linux/timekeeping.h
>> @@ -270,12 +270,12 @@ struct system_device_crosststamp {
>>   * struct system_counterval_t - system counter value with the pointer to the
>>   *				corresponding clocksource
>>   * @cycles:	System counter value
>> - * @cs:		Clocksource corresponding to system counter value. Used by
>> + * @cs_id:	Clocksource corresponding to system counter value. Used by
>>   *		timekeeping code to verify comparibility of two cycle values
> 
> That comment is inaccurate. It's not longer the clocksource itself. It's
> the ID which is used for validation.

I will change the comment to refer to "Clocksource ID".

Thanks for the advice!

Peter
