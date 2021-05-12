Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA0AF37BF2F
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 16:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbhELOEn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 10:04:43 -0400
Received: from foss.arm.com ([217.140.110.172]:39870 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230211AbhELOEk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 10:04:40 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1EC726D;
        Wed, 12 May 2021 07:03:31 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 66DB83F718;
        Wed, 12 May 2021 07:03:30 -0700 (PDT)
Subject: Re: [PATCH v2 kvm-unit-tests 0/2] fix long division routines for ARM
 eabi
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20210512105440.748153-1-pbonzini@redhat.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <6ae326a1-361c-0cbe-66f7-b02efd78cdb3@arm.com>
Date:   Wed, 12 May 2021 15:04:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210512105440.748153-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

On 5/12/21 11:54 AM, Paolo Bonzini wrote:

> As reported by Alexandru, ARM follows a different convention than
> x86 so it needs __aeabi_ldivmod and __aeabi_uldivmod.  Because
> it does not use __divdi3 and __moddi3, it also needs __divmoddi4
> to build the eabi function upon.
>
> Paolo
>
> v1->v2: fix __divmoddi4, make sure -DTEST covers it
>
> Paolo Bonzini (2):
>   libcflat: clean up and complete long division routines
>   arm: add eabi version of 64-bit division functions
>
>  arm/Makefile.arm  |  1 +
>  lib/arm/ldivmod.S | 32 ++++++++++++++++++++++++++++++++
>  lib/ldiv32.c      | 40 ++++++++++++++++++++++++----------------
>  3 files changed, 57 insertions(+), 16 deletions(-)
>  create mode 100644 lib/arm/ldivmod.S
>
I ran the arm (compiled with arm-none-eabi-gcc and arm-linux-gnu-gcc) and arm64
tests under QEMU TCG, and everything worked as expected.

I ran the arm (compiled with both toolchains) and arm64 tests under qemu and
kvmtool on a Rockpro64 dev board, again I didn't encounter any issues. So for the
entire series:

Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,

Alex

