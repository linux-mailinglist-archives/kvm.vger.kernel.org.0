Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2C6013111F
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2020 12:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbgAFLEC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jan 2020 06:04:02 -0500
Received: from foss.arm.com ([217.140.110.172]:42932 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726080AbgAFLEC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jan 2020 06:04:02 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7916F328;
        Mon,  6 Jan 2020 03:04:01 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8B22D3F534;
        Mon,  6 Jan 2020 03:04:00 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH v3 10/18] arm/arm64: selftest: Add prefetch
 abort test
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        andre.przywara@arm.com, vladimir.murzin@arm.com,
        mark.rutland@arm.com
References: <1577808589-31892-1-git-send-email-alexandru.elisei@arm.com>
 <1577808589-31892-11-git-send-email-alexandru.elisei@arm.com>
 <20200106092412.xbluliqpemim6swj@kamzik.brq.redhat.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <67be2257-a449-2534-d7f9-36bac82e1a7e@arm.com>
Date:   Mon, 6 Jan 2020 11:03:59 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200106092412.xbluliqpemim6swj@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 1/6/20 9:24 AM, Andrew Jones wrote:
> On Tue, Dec 31, 2019 at 04:09:41PM +0000, Alexandru Elisei wrote:
>> When a guest tries to execute code from MMIO memory, KVM injects an
>> external abort into that guest. We have now fixed the psci test to not
>> fetch instructions from the I/O region, and it's not that often that a
>> guest misbehaves in such a way. Let's expand our coverage by adding a
>> proper test targetting this corner case.
>>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>>  lib/arm64/asm/esr.h |   3 ++
>>  arm/selftest.c      | 112 +++++++++++++++++++++++++++++++++++++++++++++++++++-
>>  2 files changed, 113 insertions(+), 2 deletions(-)
>>
> I like this test, but I have a few idea on how to make it more robust.
> I'll send something out for review soon.

Great, looking forward to your ideas :)

Thanks,
Alex
> Thanks,
> drew 
>
