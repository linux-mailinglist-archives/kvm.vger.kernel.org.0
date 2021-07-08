Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA493C1A6D
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 22:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbhGHUQ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jul 2021 16:16:26 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:35277 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230239AbhGHUQZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 8 Jul 2021 16:16:25 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 1D1221940B08;
        Thu,  8 Jul 2021 16:13:43 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 08 Jul 2021 16:13:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=v7Mhv2
        0tqwA+ddyA1A6miAqF55bHNcU/gkJ0lkJi8QA=; b=TctT0ds65J/2rqPGkiBmr6
        Ii2sn32vbdG0Eo0bzcMIl2yTV3KkYot0czTO1hxAgED62HhDHb6adTmrLA0oR3xX
        vyoS3k6mQ19ildBOgcgPc9EbILcZOlVKPexYtincTdmxnaMxwEMrO2JmoO5GXn8m
        7RT80Tx64rZtXqI8AA+fq7zod0sYv1YWqxAhjbLv+NJ7dLmVHdv8ZzPB7fmgj6ff
        sm/RDM2hy5Fc7A1NSxFQc0UWKY4sx9kfv7TihsgVqFZp3IDvmahFMnyim1TIOMk2
        GS1WSSw+G8zfhOKFxapGnI63LQF0yCQkZOXQq0p+NA2ipGYJcI7LXRp6t380Xd8Q
        ==
X-ME-Sender: <xms:dVznYGIzgEnnIljyH6vGmxfOwLOWyekCggu8OqbfJ5Q_AVUT8tjZDg>
    <xme:dVznYOIIDhwuXlm32G4DeydCE6EqXgOQZutBRJE3Mrq_ftjEDN-it5rtzrKs3X3Fb
    Cs_unLhipTuZYyo9Ko>
X-ME-Received: <xmr:dVznYGssrbFVKBseRD4DbFh7a2sgyYTxNN2TAjHR-rBDolFu3EOQZOvssD3iLFaX1GSqrCwk0xO49626EMxuM4q0BIme9oj3glDE-eFSXFM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrtdeggddugeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepvffujghfhfffkfggtgesthdtredttddttdenucfhrhhomhepffgrvhhiugcu
    gfgumhhonhgushhonhcuoegumhgvsegumhgvrdhorhhgqeenucggtffrrghtthgvrhhnpe
    fhkeeguedtvdegffffteehjedvjeeitefgfefgffdugeffffegudehgeetgeelkeenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegumhgvsegumh
    gvrdhorhhg
X-ME-Proxy: <xmx:dVznYLZ3Kz40S7RTSSd9fReQ0sHL0Ikq5cHZYkt2Va2O52GFWyNO8Q>
    <xmx:dVznYNZAG_JxGeZJ9fbolUZvxzNlqIxHPfjjU3qDapfR4JiicJryQA>
    <xmx:dVznYHB7CWzxKgn_EyFHw-tkQtguI91p5OGF1fTFjzcGpmT98MEpcQ>
    <xmx:d1znYDx-8qfim1PqIuZgoLZfYZEpnWBxOEgrODGOzQXMdnuAbt7fhUWmwNw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 8 Jul 2021 16:13:40 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id c2b634fb;
        Thu, 8 Jul 2021 20:13:38 +0000 (UTC)
To:     David Matlack <dmatlack@google.com>
Cc:     linux-kernel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v2 0/2] kvm: x86: Convey the exit reason to user-space
 on emulation failure
In-Reply-To: <YOdGGuk2trw0h95x@google.com>
References: <20210706101207.2993686-1-david.edmondson@oracle.com>
 <YOY2pLoXQ8ePXu0W@google.com> <m28s2g51q3.fsf@dme.org>
 <YOdGGuk2trw0h95x@google.com>
X-HGTTG: heart-of-gold
From:   David Edmondson <dme@dme.org>
Date:   Thu, 08 Jul 2021 21:13:38 +0100
Message-ID: <m2y2ag36od.fsf@dme.org>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thursday, 2021-07-08 at 18:38:18 UTC, David Matlack wrote:

> On Thu, Jul 08, 2021 at 03:17:40PM +0100, David Edmondson wrote:
>> Apologies if you see two of these - I had some email problems earlier.
>
> I only got one! :)

Phew!

>> On Wednesday, 2021-07-07 at 23:20:04 UTC, David Matlack wrote:
>> 
>> > On Tue, Jul 06, 2021 at 11:12:05AM +0100, David Edmondson wrote:
>> >> To help when debugging failures in the field, if instruction emulation
>> >> fails, report the VM exit reason to userspace in order that it can be
>> >> recorded.
>> >
>> > What is the benefit of seeing the VM-exit reason that led to an
>> > emulation failure?
>> 
>> I can't cite an example of where this has definitively led in a
>> direction that helped solve a problem, but we do sometimes see emulation
>> failures reported in situations where we are not able to reproduce the
>> failures on demand and the existing information provided at the time of
>> failure is either insufficient or suspect.
>> 
>> Given that, I'm left casting about for data that can be made available
>> to assist in postmortem analysis of the failures.
>
> Understood, thanks for the context. My only concern would be that
> userspace APIs are difficult to change once they exist.

Agreed.

> If it turns out knowing the exit reason does not help with debugging
> emulation failures we'd still be stuck with exporting it on every
> emulation failure.

We could stop setting the flag and never export it, but this would waste
space in the structure and be odd, without doubt.

> My intuition is that the instruction bytes (which are now available with
> Aaron's patch) and the guest register state (which is queryable through
> other ioctls) should be sufficient to set up a reproduction of the
> emulation failure in a kvm-unit-test and the exit reason should not
> really matter. I'm curious if that's not the case?

The instruction bytes around the reported EIP are all zeroes - the
register dump looks suspect, and doesn't correspond with the reported
behaviour of the VM at the time of the failure.

It's possible that Aaron's changes will help, indeed, given that they
report state from within the instruction emulator itself. So far I don't
have a sufficiently reproducible case to be able to see if that is the
case.

> I'm really not opposed to exporting the exit reason if it is useful, I'm
> just not sure it will help.

In the emulation failure case we are not in something I would consider a
fast path, and the overhead of acquiring and reporting the exit reason
is low.

Do you anticipate a case where it would be inappropriate or expensive to
report the reason?

>> 
>> >> I'm unsure whether sgx_handle_emulation_failure() needs to be adapted
>> >> to use the emulation_failure part of the exit union in struct kvm_run
>> >> - advice welcomed.
>> >> 
>> >> v2:
>> >> - Improve patch comments (dmatlack)
>> >> - Intel should provide the full exit reason (dmatlack)
>> >> - Pass a boolean rather than flags (dmatlack)
>> >> - Use the helper in kvm_task_switch() and kvm_handle_memory_failure()
>> >>   (dmatlack)
>> >> - Describe the exit_reason field of the emulation_failure structure
>> >>   (dmatlack)
>> >> 
>> >> David Edmondson (2):
>> >>   KVM: x86: Add kvm_x86_ops.get_exit_reason
>> >>   KVM: x86: On emulation failure, convey the exit reason to userspace
>> >> 
>> >>  arch/x86/include/asm/kvm-x86-ops.h |  1 +
>> >>  arch/x86/include/asm/kvm_host.h    |  3 +++
>> >>  arch/x86/kvm/svm/svm.c             |  6 ++++++
>> >>  arch/x86/kvm/vmx/vmx.c             | 11 +++++++----
>> >>  arch/x86/kvm/x86.c                 | 22 +++++++++++++---------
>> >>  include/uapi/linux/kvm.h           |  7 +++++++
>> >>  6 files changed, 37 insertions(+), 13 deletions(-)
>> >> 
>> >> -- 
>> >> 2.30.2
>> >> 
>> 
>> dme.
>> -- 
>> It's gettin', it's gettin', it's gettin' kinda hectic.

dme.
-- 
Please forgive me if I act a little strange, for I know not what I do.
