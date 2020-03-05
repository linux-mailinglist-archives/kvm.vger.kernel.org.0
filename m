Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2399A17A2E0
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 11:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbgCEKL2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 05:11:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:43900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726049AbgCEKL2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 05:11:28 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A64120848;
        Thu,  5 Mar 2020 10:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583403087;
        bh=VhcSG0+t6WlVkEBhrGpV+M/UFgLccIJ9/P7MZTSa6xk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CyIMrRa4c4dl44Pfg7aYaPPPtPbFne68bjNvIugCopp0cq0UPJbQF9m1jOFrRjm/v
         bQ+VZeUn2KI8C8P1uu8lpJw5uiMK4zTISaDaRRh5EzYiFq0bNdHjT/Gk0nYNCO3MvR
         W9Gfn7ZfFsUd+686TRtUOQ3G7BZp+J01cA1S/UJ8=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1j9nTR-00AFO9-8N; Thu, 05 Mar 2020 10:11:25 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 05 Mar 2020 10:11:25 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        kvm list <kvm@vger.kernel.org>, lkft-triage@lists.linaro.org,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>, yzt356@gmail.com,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, namit@vmware.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Basil Eljuse <Basil.Eljuse@arm.com>, kvm-owner@vger.kernel.org
Subject: Re: kvm-unit-tests : Kconfigs and extra kernel args for full coverage
In-Reply-To: <CA+G9fYt2UFv=i5Wg1cwM-hiHNRdkTUHjMZUfbWCY=CWVAoSwrQ@mail.gmail.com>
References: <CA+G9fYvx=WzyJqS4fUFLq8qXT8nbFQoFfXZoeL9kP-hvv549EA@mail.gmail.com>
 <c82f4386-702f-a2e9-a4d7-d5ebb1f335d1@arm.com>
 <20200224133818.gtxtrmzo4y4guk4z@kamzik.brq.redhat.com>
 <adf05c0d-6a19-da06-5e41-da63b0d0d8d8@arm.com>
 <20200224145936.mzpwveaoijjmb5ql@kamzik.brq.redhat.com>
 <CA+G9fYvt2LyqU5G2j_EFKzgPXzt8sDYYm8NxP+zD6Do07REsYw@mail.gmail.com>
 <7b9209be-f880-a791-a2b9-c7e98bf05ecd@arm.com>
 <CA+G9fYvjoeLV5B951yFb8fc7r+WAejz+0kHcFYTNzW6+HfouXw@mail.gmail.com>
 <CA+G9fYuEfrhW_7vLCdK4nKBhDv6aQkK_knUY7mbgeDcuaETLyQ@mail.gmail.com>
 <a1f51266-d735-402a-6273-8ae84d415881@arm.com>
 <CA+G9fYt2UFv=i5Wg1cwM-hiHNRdkTUHjMZUfbWCY=CWVAoSwrQ@mail.gmail.com>
Message-ID: <91cf9799db79b83fec4b3fc304969e16@misterjones.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: naresh.kamboju@linaro.org, alexandru.elisei@arm.com, drjones@redhat.com, kvm@vger.kernel.org, lkft-triage@lists.linaro.org, krish.sadhukhan@oracle.com, yzt356@gmail.com, jmattson@google.com, pbonzini@redhat.com, namit@vmware.com, sean.j.christopherson@intel.com, Basil.Eljuse@arm.com, kvm-owner@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-03-03 18:53, Naresh Kamboju wrote:
> On Tue, 3 Mar 2020 at 21:32, Alexandru Elisei 
> <alexandru.elisei@arm.com> wrote:
>> 
>> Hi,
>> 
>> On 2/25/20 8:20 AM, Naresh Kamboju wrote:
>> > Hi Alexandru,
>> >
>> > On Mon, 24 Feb 2020 at 23:14, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>> >>> I think this is because you are running it on one physical CPU (it's exactly the
>> >>> same message I am getting when I use taskset to run the tests). Can you try and
>> >>> run it without taskset and see if it solves your issue?
>> > We have a new problem when running [1] without taskset on Juno-r2.
>> > None of the test got pass [2] when running without taskset on Juno-r2.
>> >
>> I think I have an explanation for why all the tests fail. qemu creates 
>> a vcpu to
>> match the host cpu in kvm_arm_create_scratch_host_vcpu and it sets the 
>> target to
>> whatever the result of the KVM_ARM_PREFERRED_TARGET ioctl is. If it's 
>> run on the
>> little core, the target will be KVM_ARM_TARGET_CORTEX_A53. If it's run 
>> on the big
>> core, the target will be KVM_ARM_TARGET_GENERIC_V8. I tried it a few 
>> times, and
>> for me it has always been the big core.
>> 
>> The vcpu is created from a different thread by doing a 
>> KVM_ARM_VCPU_INIT ioctl and
>> KVM makes sure that the vcpu target matches the target corresponding 
>> to the
>> physical CPU the thread is running on. What is happening is that the 
>> vcpu thread
>> is run on a little core, so the target as far as KVM is concerned 
>> should be
>> KVM_ARM_TARGET_CORTEX_A53, but qemu (correctly) set it to
>> KVM_ARM_TARGET_GENERIC_V8. The ioctl return -EINVAL (-22) and qemu 
>> dies.
>> 
>> To get around this, I ran the tests either only on the big cores or on 
>> the little
>> cores.
> 
> Thanks for explaining in details.
> I have seen this scenario and defined my test to run only on CPU 0.
> The CPU 0 on my Juno-r2 devices found to be LITTLE CPU.

big-little? Just say no.

To be clear: this isn't a workaround. big-little is a fundamentally 
broken
paradigm when it comes to virtualization. If you let vcpus roam of 
different
u-archs, you will end-up with unpredictable results. So QEMU does the 
right
thing, and refuses to start a VM in these conditions.

I suggest you drop your Juno at the nearest museum, department of Bad 
Ideas,
and get yourself a sensible machine. Even a RPi4 (cough!) is marginally 
better.

>> I also managed to reliably trigger the PMU failures that you are 
>> seeing. They only
>> happen when kvm-unit-tests is run on the little cores (ran them 10 
>> times in a
>> loop). When run on  the big cores, everything is fine (also ran them 
>> 10 times in a
>> loop). Log output when it fails:
> 
> Thanks for reproducing this PMU failure.

This one is slightly more convoluted: Nothing in the KVM PMU code 
expects *two*
independent PMUs. What we need is a way to tie a physical PMU to the 
virtual PMU
that gets emulated with perf on the host. I'm working on something 
similar for SPE,
so maybe we can come up with a common approach.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
