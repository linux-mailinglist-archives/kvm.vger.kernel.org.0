Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D23355C542
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 14:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345690AbiF1Mgp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 08:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344475AbiF1Mgn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 08:36:43 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2086.outbound.protection.outlook.com [40.107.100.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBED82ED77;
        Tue, 28 Jun 2022 05:36:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j87dWeDva/s5PRpyujOgMCFDIlLXLVQaF2K03zkR8ULNBovyVVQzBz0fbXjLF+VI59LIAatg7PwNngFIm9r2D3sUzCY0RKDzxrgVYiiyoQXA/PvZl4I/X4RwKNwlHXpqOCiklyW9vCc6EV49BwEDQmmgRK0JWbgJKPzzNaZfP72E8cZFwSmDYSnwFt/uUYOnlk5A9rc6KNIdFnb3OWuc6WKEJ8gJt0ovi3+9lFepCglMt5ayOJ/0tenBUPC3T3PbTpKABfS6CkU2REAZRlLK79SZ9xo+52eKWXWnT6MqFzCkRSm1DI6cD55/KK21/7IgtibPGr4lKvV+FTp3xTdLjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ioZl0KlUmX4EChRuNQt0lApDauffr4UW0PT0RvcKVEU=;
 b=A6qaY0NSoO245oZzf99sNYzzG7JlBFtOFSn1k2mbZBw7MGzRyKmkImSxSliDWQcJ+DSOiGabV/lEF/vxtu7eLi8BlN5COnXoRELqxa8wRIZfQ2GJ10+VUSx+TQAmjoAtVy07g23eEc/0XMPvPrOaCxRtct4dyYhMNkRIryX8HjmNzJTjruiCYRcf6q64OcOPNwVesKnE5GAT+/OERCMGxDvUtaCP0//Cm0wB7Qvrf0fQLiccWbGnZzy7Kf+KJB5/LcG+kEVqL/kTMxHxbl1hSaybasXhgSvEYDeRiKiNOyUpoT3U89H3VDiDPzJh6HKovSybPQ+BFR2vczZIKjGfuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ioZl0KlUmX4EChRuNQt0lApDauffr4UW0PT0RvcKVEU=;
 b=vZJ4C/v6dy76TnwV6mNzM69nZ05TznSFe9ZTFjzAjy24vDVIryfsbL+SHHKt7yPTFTWU4Kv4BgJQb8EaxEuy5GpeKEymaybQEyIfD804kHpaaNEPLn0Hc0gkmsuVmeG7PCVp6IvVPP3DjW1+S8JEbNqTCvLBKgsCmKw0jfjSGzw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 DM8PR12MB5494.namprd12.prod.outlook.com (2603:10b6:8:24::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5373.17; Tue, 28 Jun 2022 12:36:38 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::14b:372d:338c:a594]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::14b:372d:338c:a594%9]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 12:36:38 +0000
Message-ID: <cc77d885-fdf2-bac8-65d4-ab0994272548@amd.com>
Date:   Tue, 28 Jun 2022 19:36:27 +0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v6 15/17] KVM: SVM: Use target APIC ID to complete x2AVIC
 IRQs when possible
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, joro@8bytes.org, jon.grimm@amd.com,
        wei.huang2@amd.com, terry.bowman@amd.com
References: <20220519102709.24125-1-suravee.suthikulpanit@amd.com>
 <20220519102709.24125-16-suravee.suthikulpanit@amd.com>
 <b8610296-6fb7-e110-900f-4616e1e39bb4@redhat.com>
 <d761ef283bc91002322f3cd66c124d329c25f04f.camel@redhat.com>
 <9f3ffe16-2516-d4ec-528e-6347ef884ad5@amd.com>
 <df464fd9b3c66059d7065acc52594d27dfe52448.camel@redhat.com>
From:   "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
In-Reply-To: <df464fd9b3c66059d7065acc52594d27dfe52448.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2P153CA0007.APCP153.PROD.OUTLOOK.COM (2603:1096::17) To
 DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ad48c2e6-987b-4aee-22e9-08da5902d81a
X-MS-TrafficTypeDiagnostic: DM8PR12MB5494:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pYy1Zhemud8tL0xWwy3KiWkXhlrb3fONme4dj6y4X+qXTUTX8X/BzU/41evtAi/qzxJs4ejRrJlQhJD4NA2wge9Y627Ixfx4/BT0G+POidPM+XPnHF5hOA/1RoyPf+AEs9l5O3Vn+ghhvKQgzCKWhNP1Cc6UGwV9lmj1WSuTpBsC+lP6UJTMazbxcTVM6sZ5RVjDSEh0OZa0kF8fXZwh/lreskyT1U5l//GaJw9/EoVy8NaS40L9AYG7MPHWfnASW47sFI6zZtu33Z3kBNARQ7oc3w93gxLFuf8dsji4KjI/h55h5+Y+zcQPxrDhl7M/03GUoV3tbSceDhxOIKdYlx1H0McMBpMK5JU8uuisYYMNmJ0uFi9ygm3uncpKxLlxuev1pBnJOwnPwd3pOIYfrXCnUh576UHaEVdz3ZFnqFBEAMVXmwb1ixedsioT7x8XJ5fHsrNQv5Spi02BKkB/teUkVcTqtdMYidUyFaMy1ArSb0e778jfP2zljSOyVfz/d9gJX5gsGRK/zfy7HYAyKX6xZaHCU5+VslLDKLEb6fGh0vnIqALIFw1xpvVeYre6+D2HgVfNozSTtyOAvSxATpGz8A8BWkff5GTk/pKkHkC64j7TP+tXyxHY3tj+ydk4FbvfEDVZP4CSadqSKFcirbzR/ws8f69343lki3FCChlURWMS8Wtk/aFF1bZSb3TVLzloZ9/r1E2Fo1mVnLH9kUSyjt560q73xdJ+Z05oToQvIRNuSjy8AqIcFGtZDjcNwwqF/SLeJfVi70YSh59RsMptlsyFd2SYlWBfoW9k/m6pvstCM+iHlj3ehKepY7sTw6fV+khwJI+Rj8/6D70zJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(346002)(136003)(39860400002)(396003)(376002)(66476007)(8676002)(4326008)(38100700002)(66556008)(6486002)(41300700001)(5660300002)(478600001)(186003)(66946007)(8936002)(2616005)(83380400001)(53546011)(2906002)(316002)(36756003)(86362001)(26005)(6506007)(6512007)(31696002)(110136005)(31686004)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OWZRVXJTN3BQNnBNbG90TCtmM3RGRkVLREhmUnRDWHFJK0FTd1dUNmRFeE12?=
 =?utf-8?B?NG8rQ2RXVndFc3lwajdmV0s0a1BJNm1tb0hrL1F6SnQ2ZHhUM3VXTDVWOGNN?=
 =?utf-8?B?SXErQStOaHFHazFzQkJ0ek9KSXFTeGFBZEluSmlzbERESGNxdkhUV2Q0ZUFp?=
 =?utf-8?B?UW5lNVNzVHlVazJxZUNiS2t2YUJyWHJsQW9jbVNYdFRWN21uN2ZxVzlXeUY2?=
 =?utf-8?B?elFVM0kvRnQ1QUZ4amxHR3p5Vk1pQ2RGY2lQamxoQ3R6a3FvdzlpMG80ZDJr?=
 =?utf-8?B?TnpoMTVHcVVyZTdROG1Sb1lZTUNuMFQzZHJwVE5XamlCV0NrRXNNL2xzQWRs?=
 =?utf-8?B?dWF2cnIyb0NkMWdZS1NIdEpHQytlTFBTSC9aQllFT0xMNW5NL0EzY0ZkSk5T?=
 =?utf-8?B?cVkveCtYRFVvWHZOT2xIYUluY0wvazJtR3RuQ0o4ZVpUek8xR0doYkhhRzMw?=
 =?utf-8?B?ODNOQS9ldmVoeU9BMGxhc1E3blR6WTd6NEdqZ1Q3ZWZ4UVo0Ym9qRUJEL1Za?=
 =?utf-8?B?UEtJZ2VCWm9EU09sY1ZGVW5haklnVm81V2hKNmI0RURLcFF0UFkyYXM5Rk0z?=
 =?utf-8?B?K2kzTU5Xci8vTVYxcGJGVSs4NEYxNGFlYklabUJGMFNlbHpOMVoxMVJFcHRh?=
 =?utf-8?B?dEFTajB4Y0tpSEJ0QTBHR2d0aEJ0MlVqZFpEVjhUZ0hlQjVYc2hmWjBOR1hG?=
 =?utf-8?B?N2d2aGZTblNRY1BwUWJGdlA1VktJVWxPUE5sYWlPWGE3b1hIZG16UGptU1dC?=
 =?utf-8?B?cXRzdTl0MVpaeUVWUkU0bFFNN2VEa3QvUDlmQ1lkVE5BUmM5SC9QMFF0OTRm?=
 =?utf-8?B?MkRqNDN2WUNON3JtYURudDg5dzFhOERacjNwRDhoSzZBdThscW1iZkxTWTdR?=
 =?utf-8?B?cURsdUtEUFMweW55ZGEzTTBPZ2Z6L3FwL1JZTGp4U2JKSnJqZGJ3dWQrV0gv?=
 =?utf-8?B?bUtBVXB1NkxZaVppczljNGxUUHJhN3RIRG1sWDFEL3RTRjl1MzJYdGdOYlM1?=
 =?utf-8?B?MUpTaUtocEFkU255N3pEcVl5VGYzUUdiczltVlUyT1ZtSmRrb1ROVDdMcW5W?=
 =?utf-8?B?QUIyYTQwcVpialF1enc1YVV3RTNaVDViclBWYlJXTVh6eXJJell1VDdnTGxV?=
 =?utf-8?B?M1ZiVkJiNmtwU1NVU3JWZHdwRzdKQUxYOXdjQWlzOEdVSFVrVnRLL2hrMXlX?=
 =?utf-8?B?NzlwUFI3bHZnbFdTeXlFc29RV05ncGxUNVN5N1FvM3R0M1lpNlVzWjM5UWFR?=
 =?utf-8?B?Sy9YTm5xVk5ZcE90NDl5blVRcjM1QS9KelRhVWs1bEJYZC9keGlGa21XbzBo?=
 =?utf-8?B?N1pWdjZ3dWhMdWtadnNkOWdLZThnM1hJUkhXQ1pLS1ovMTdBQ005dlFaQVRY?=
 =?utf-8?B?MldjRlJnUm9wdktodkZJZkI3Q1poZXZKZVcrdk1UZ0FrMWdkaUxMd2pZc2t6?=
 =?utf-8?B?WFdmZytqVll1QTBXalNVSEs3YWgvNGdEZEFBeGkrODNJM2hONGxvZFJZSTAw?=
 =?utf-8?B?WXI1S0IxQzJlQ3VQcEFkY3hhUytMNFgvNFBQUXQ1cFFSQno2WmtIVVNYU2lu?=
 =?utf-8?B?bEoyalFxd1UwbXNINGY4WGdzdzlYdFcrRGZ4TVdhQXBvK3lta2RzZEx3NndU?=
 =?utf-8?B?U2swanp4YnFDTVI2RGh1V3VxbE5lU2dvMG93bjhpMHBld3JnTmQ5QTRmYlln?=
 =?utf-8?B?N29ocWhib08xdEdQU2RibEN4QUU2V0tzb3ZsR0gydzh0MDBaN3JOaE8vZnZD?=
 =?utf-8?B?WVNBSEtnU1cxRzlRbmJFTjFWdkNSV1RCMDdZTVB5Q3RNcDkxTFhNcmhBMmlx?=
 =?utf-8?B?d25xN2gzL0FvVXFmNzl1TGNtcEw3WGRyRFdFdDlHb0FiSS9MZ0YyblBUUkd2?=
 =?utf-8?B?QUkyOG9XRXFPWXdFQXZ5WXpYMEhjNU5jVkNaYzN3UnhGWlRndEZmZlVaMEFZ?=
 =?utf-8?B?TEg5SGY3V0JyWGVWMlh4QmhleFROQUJDMDREQng1dXozTHJnWU1mT0ppR0lX?=
 =?utf-8?B?MUp3NFg0Mk15NVBwaWVSZkxnRW13Zk0wNGJoK2o5T2dYdVJpbThiam5nRFpv?=
 =?utf-8?B?VVlUaUFIcTRvTTlnbTRzbk83WllCUlo1NEdlMnUyMWV6TG83bnA0MzNqbVJ1?=
 =?utf-8?Q?kO/D7D3W5g+I8BI443iqPC12g?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad48c2e6-987b-4aee-22e9-08da5902d81a
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 12:36:38.0505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CdzkG5HfDAEyTej0MnlxtPC3PapAaVTwKycv8aTWtRhba+PzkaBgmVWcqIE5Trr+03jO6N1AjBxBCwXzkcyHbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5494
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo / Maxim

On 6/28/2022 3:59 PM, Maxim Levitsky wrote:
>>> Hi Paolo and Suravee Suthikulpanit!
>>>
>>> Note that this patch is not needed anymore, I fixed the avic_kick_target_vcpus_fast function,
>>> and added the support for x2apic because it was very easy to do
>>> (I already needed to parse logical id for flat and cluser modes)
>>>
>>> Best regards,
>>> 	Maxim Levitsky
>>>
>> Understood. I was about to send v7 to remove this patch from the series, but too late. I'll test the current queue branch and provide update.
> Also this really needs a KVM unit test, to avoid breaking corner cases like
> sending IPI to 0xFF address, which was the reason I had to fix the
> avic_kick_target_vcpus_fast.
> 
> We do have 'apic' test in kvm unit tests,
> and I was already looking to extend it to cover more cases and to run it with AVIC's
> compatible settings. I hope I will be able to do this this week.

Thanks. Would you please CC me as well once ready?

> 
> Best regards,
> 	Maxim Levitsky

I have also submitted a patch to fix the 603ccef42ce9 ("KVM: x86: SVM: fix avic_kick_target_vcpus_fast"),
which was queued previously.

Best Regards,
Suravee Suthikulpanit
