Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 381655630BD
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 11:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235400AbiGAJwi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 05:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231613AbiGAJwh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 05:52:37 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0348476969
        for <kvm@vger.kernel.org>; Fri,  1 Jul 2022 02:52:36 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0D047113E;
        Fri,  1 Jul 2022 02:52:36 -0700 (PDT)
Received: from [192.168.6.40] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 655123F66F;
        Fri,  1 Jul 2022 02:52:34 -0700 (PDT)
Message-ID: <8c1c4e1b-6723-b7b2-065b-20959e9cc5cd@arm.com>
Date:   Fri, 1 Jul 2022 10:52:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [kvm-unit-tests PATCH v3 01/27] lib: Fix style for acpi.{c,h}
Content-Language: en-GB
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     kvm@vger.kernel.org, drjones@redhat.com, pbonzini@redhat.com,
        jade.alglave@arm.com, alexandru.elisei@arm.com, ricarkol@google.com
References: <20220630100324.3153655-1-nikos.nikoleris@arm.com>
 <20220630100324.3153655-2-nikos.nikoleris@arm.com>
 <20220701092719.63g4kv6co65dnpnd@kamzik>
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
In-Reply-To: <20220701092719.63g4kv6co65dnpnd@kamzik>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Drew

Thanks for the review!

On 01/07/2022 10:27, Andrew Jones wrote:
> Hi Nikos,
> 
> I guess you used Linux's scripts/Lindent or something for this
> conversion. Can you please specify what you used/did in the
> commit message?
> 

I fixed the style by hand but happy to use Lindent in the next iteration.

> On Thu, Jun 30, 2022 at 11:02:58AM +0100, Nikos Nikoleris wrote:
>> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
>> ---
>>   lib/acpi.h | 148 ++++++++++++++++++++++++++---------------------------
>>   lib/acpi.c |  70 ++++++++++++-------------
>>   2 files changed, 108 insertions(+), 110 deletions(-)
> 
> It looks like the series is missing the file move patch. Latest master
> still doesn't have lib/acpi.*
> 

I am sorry, I missed the first patch. The missing patch is doing a move 
of acpi.{h,c} [1].

FWIW, I tried combining the patches in one but I ended up with a big 
diff. I found it much easier to check that everything looks ok when the 
overall change was split in two patches.

[1]: 
https://github.com/relokin/kvm-unit-tests/commit/959ca08c23dbaa490b936303b94b006352a29d43

Thanks,

Nikos

> Thanks,
> drew
