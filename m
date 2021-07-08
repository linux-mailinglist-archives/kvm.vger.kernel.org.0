Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 592023C1524
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 16:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231964AbhGHO2v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jul 2021 10:28:51 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:56781 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231756AbhGHO2u (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 8 Jul 2021 10:28:50 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 5DEA21AC1121;
        Thu,  8 Jul 2021 10:17:45 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 08 Jul 2021 10:17:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=KMgRIE
        ryP5GBUNqve801kcFjmD/qbfxjGon5OIpBqtg=; b=hLbnxrl0LKK0xuB8TuxAWN
        6hFoy6RU4c4no21f3Anwcoo8RcNdMEmkFz5izxIYsy9vBOVHT0yA+EALDpJw7xqG
        gqNbN3lC2xhmzwB4oW0TFqZ2NYBkfRKwZiBAV4g0IuRAWERM3Hv8uwdU8rhybmuo
        PVDGpjBlyoUaBcSYXVw7ap8j7sH4dDOTpHqjhFm2h0wdILuaupeT3Nx9+FMwe/7D
        R7mJ74oWTEXtW/Z/0Lwm+KinHtFfKrV+SCXzwaGl9mrOGI9YUNcNpI9le5rSJwjE
        cmrqrZREk8OxN0hO03Nwy9Q6ArUlF/ZOSWqWE2DcHLqa01Bgt6BKkoMBWa8VK5MQ
        ==
X-ME-Sender: <xms:BwnnYHzuxtKDz2pOitFGwf2OITRbHm0ODhgEQU9nBbCx46X1KCX6hg>
    <xme:BwnnYPQOPSOXwAN57jUGch6mgPuQR26XwtVIL_UiTS4ARF7J-RfoFxoh561rtWRUi
    Mh8GjaQt_KcN31VQEI>
X-ME-Received: <xmr:BwnnYBXuvjTfmY_FR41XyiVoW3Z3Yxs8BI29Z8AzDPNds9cFGgGNe1KVo1VyE-UI5ANVeHaTsRSoTHbr0nW8cR5C_1_lbCabQV0PltuBBkE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrtdeggdejfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefvufgjfhfhfffkgggtsehttdertddttddtnecuhfhrohhmpeffrghvihguucfg
    ughmohhnughsohhnuceoughmvgesughmvgdrohhrgheqnecuggftrfgrthhtvghrnhephf
    ekgeeutddvgeffffetheejvdejieetgfefgfffudegffffgeduheegteegleeknecuvehl
    uhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepughmvgesughmvg
    drohhrgh
X-ME-Proxy: <xmx:BwnnYBipcfX-3vUSmI1uSXUmT1TyHQ-zI5mGM1FYTnmDrVkkrfIcnQ>
    <xmx:BwnnYJBTtI0fRQDsftFora7jLw_Z9izUQucJ3jF6hTmD_GYJyB2n7w>
    <xmx:BwnnYKKQgcJJYnch00QLEtZic9QgzU9Cxgp58_QYEPIXLGFyjVPGjw>
    <xmx:CQnnYBaNqaHlbwLXaxIXHOn5UqQxrI2WsBQmEzuJrLL4PWMhtg2eGhSuKkXBpgdk>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 8 Jul 2021 10:17:42 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id d69a583e;
        Thu, 8 Jul 2021 14:17:40 +0000 (UTC)
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
In-Reply-To: <YOY2pLoXQ8ePXu0W@google.com>
References: <20210706101207.2993686-1-david.edmondson@oracle.com>
 <YOY2pLoXQ8ePXu0W@google.com>
X-HGTTG: heart-of-gold
From:   David Edmondson <dme@dme.org>
Date:   Thu, 08 Jul 2021 15:17:40 +0100
Message-ID: <m28s2g51q3.fsf@dme.org>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Apologies if you see two of these - I had some email problems earlier.

On Wednesday, 2021-07-07 at 23:20:04 UTC, David Matlack wrote:

> On Tue, Jul 06, 2021 at 11:12:05AM +0100, David Edmondson wrote:
>> To help when debugging failures in the field, if instruction emulation
>> fails, report the VM exit reason to userspace in order that it can be
>> recorded.
>
> What is the benefit of seeing the VM-exit reason that led to an
> emulation failure?

I can't cite an example of where this has definitively led in a
direction that helped solve a problem, but we do sometimes see emulation
failures reported in situations where we are not able to reproduce the
failures on demand and the existing information provided at the time of
failure is either insufficient or suspect.

Given that, I'm left casting about for data that can be made available
to assist in postmortem analysis of the failures.

>> I'm unsure whether sgx_handle_emulation_failure() needs to be adapted
>> to use the emulation_failure part of the exit union in struct kvm_run
>> - advice welcomed.
>> 
>> v2:
>> - Improve patch comments (dmatlack)
>> - Intel should provide the full exit reason (dmatlack)
>> - Pass a boolean rather than flags (dmatlack)
>> - Use the helper in kvm_task_switch() and kvm_handle_memory_failure()
>>   (dmatlack)
>> - Describe the exit_reason field of the emulation_failure structure
>>   (dmatlack)
>> 
>> David Edmondson (2):
>>   KVM: x86: Add kvm_x86_ops.get_exit_reason
>>   KVM: x86: On emulation failure, convey the exit reason to userspace
>> 
>>  arch/x86/include/asm/kvm-x86-ops.h |  1 +
>>  arch/x86/include/asm/kvm_host.h    |  3 +++
>>  arch/x86/kvm/svm/svm.c             |  6 ++++++
>>  arch/x86/kvm/vmx/vmx.c             | 11 +++++++----
>>  arch/x86/kvm/x86.c                 | 22 +++++++++++++---------
>>  include/uapi/linux/kvm.h           |  7 +++++++
>>  6 files changed, 37 insertions(+), 13 deletions(-)
>> 
>> -- 
>> 2.30.2
>> 

dme.
-- 
It's gettin', it's gettin', it's gettin' kinda hectic.
