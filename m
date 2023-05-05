Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF3896F851C
	for <lists+kvm@lfdr.de>; Fri,  5 May 2023 16:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232021AbjEEOzv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 May 2023 10:55:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231852AbjEEOzu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 May 2023 10:55:50 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 463B015EE1
        for <kvm@vger.kernel.org>; Fri,  5 May 2023 07:55:49 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5EBCD2F4;
        Fri,  5 May 2023 07:56:33 -0700 (PDT)
Received: from [10.57.56.190] (unknown [10.57.56.190])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EA19B3F5A1;
        Fri,  5 May 2023 07:55:47 -0700 (PDT)
Message-ID: <c0917543-104d-1fe2-4602-c556f168226f@arm.com>
Date:   Fri, 5 May 2023 15:55:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.1
Subject: Re: [kvm-unit-tests PATCH v5 00/29] EFI and ACPI support for arm64
Content-Language: en-GB
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com,
        alexandru.elisei@arm.com, ricarkol@google.com, seanjc@google.com,
        Shaoqin Huang <shahuang@redhat.com>
References: <20230428120405.3770496-1-nikos.nikoleris@arm.com>
 <20230429-6da987552a8d15281f8444c9@orel>
 <20230429-342c8a26e5db45474631a307@orel>
 <6857da77-8d1e-ebcb-1571-6419d463fa53@arm.com>
 <20230501-85b5dca6ed2d86d8bb0e55b6@orel>
 <658590ba-1c73-87cd-b1b1-bcbf3e556f29@arm.com>
 <20230502-7c550b68838ce47572260bd1@orel>
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
In-Reply-To: <20230502-7c550b68838ce47572260bd1@orel>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/05/2023 08:32, Andrew Jones wrote:
> On Mon, May 01, 2023 at 11:27:23PM +0100, Nikos Nikoleris wrote:
>> On 01/05/2023 12:21, Andrew Jones wrote:
...
> 
> I'm also anxious to get this merged, but I'm a little reluctant to
> take it without DT, since we may find other issues once we boot the
> tests with DT. I also know how it's easy, at least for me, to let
> stuff get dropped when their priorities reduce. If you have time now,
> how about we poke at it until the end of the week? With some luck,
> it'll be sorted out and we'll also have the x86 ack, which I'd like
> to get, by then.
>

Thanks Drew!

I've now implemented support for using an fdt when running tests as EFI 
apps. You can find the two additional commits here:

https://gitlab.com/nnikoleris/kvm-unit-tests/-/tree/target-efi-upstream-v6-pre

But I suppose, at some point, I should also send the new version of this 
series to the mailing list? What do you think?

Thanks,

Nikos
