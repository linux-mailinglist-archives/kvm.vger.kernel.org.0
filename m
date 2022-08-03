Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 278C6588C6F
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 14:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236071AbiHCMv4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 08:51:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233507AbiHCMvz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 08:51:55 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8215132D94
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 05:51:53 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F16D911FB;
        Wed,  3 Aug 2022 05:51:53 -0700 (PDT)
Received: from [10.57.44.101] (unknown [10.57.44.101])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B29103F70D;
        Wed,  3 Aug 2022 05:51:51 -0700 (PDT)
Message-ID: <e5b4a607-c600-c34e-8ef4-874c8e2c45b9@arm.com>
Date:   Wed, 3 Aug 2022 13:51:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [kvm-unit-tests PATCH v3 00/27] EFI and ACPI support for arm64
Content-Language: en-GB
To:     Andrew Jones <andrew.jones@linux.dev>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jade.alglave@arm.com,
        ricarkol@google.com
References: <20220630100324.3153655-1-nikos.nikoleris@arm.com>
 <YtbNin3VTyIT/yYF@monolith.localdoman>
 <86e94983-0c69-88c8-f37f-c772ab6a4847@arm.com>
 <Ytq3Lxwa4fKG63GM@monolith.localdoman>
 <a2b33f4d-aad6-1239-465d-118e4f30e509@arm.com>
 <Yuj6FOidO6b9wkTQ@monolith.localdoman>
 <20220802104618.giks3ogrdhe2gcvw@kamzik>
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
In-Reply-To: <20220802104618.giks3ogrdhe2gcvw@kamzik>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/08/2022 11:46, Andrew Jones wrote:
> On Tue, Aug 02, 2022 at 11:19:00AM +0100, Alexandru Elisei wrote:
>> Hi,
>>
>> Doubling the number of memory regions worked, thanks. Like you've said,
>> that's just a band-aid, as there could be platforms out there for which
>> UEFI reports more regions than the static value that kvm-unit-tests
>> assumes.
>>
>> If you don't mind a suggestion, you could run two passes on the UEFI memory
>> map: the first pass finds the largest available memory region and uses that
>> for initializing the memory allocators (could also count the number of
>> memory regions that it finds, for example), the second pass creates the
>> mem_regions array by allocating it dynamically (the allocators have been
>> initialized in the previous pass). The same approach could be used when
>> booting without UEFI.
>>
>> Or you can just set NR_EXTRA_MEM_REGIONS to something very large and call
>> it a day :)
> 
> Yeah, let's just bump it to something large. We should also ensure it's
> easy to debug when we hit the limit though. We have an assert() in
> mem_region_add() already, but maybe we don't have an assert() in the
> EFI code paths?
> 
> Thanks,
> drew
> 

Thank you both. I'll make these two changes in the next revision of the 
series. By the way, I'm tracking changes on top of v3 here: 
https://github.com/relokin/kvm-unit-tests/tree/target-efi-upstream-v3-fixups

Thanks,

Nikos
