Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D97503C1523
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 16:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231893AbhGHO2v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jul 2021 10:28:51 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:56953 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231515AbhGHO2u (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 8 Jul 2021 10:28:50 -0400
X-Greylist: delayed 502 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Jul 2021 10:28:50 EDT
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 066A81AC113D;
        Thu,  8 Jul 2021 10:20:39 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Thu, 08 Jul 2021 10:20:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Yqh2Rk
        /EnXX8FjCxTuM+fz8dQ08W31Xk+fWV3bz7X2o=; b=Naw6UoMKdIP2Eq8U4jkoCi
        VbaiA5vQCG6GFwj1fT7Cxq8D4r5Qm0AD+RMXUI5SbZhZaeCkPdqmTfuDXW9fnVjv
        uQ2gfu6y7O1j6icpaphqdd0xpIkVUtshbN2kM6ZgVLdHGOzJJX63WZvvp3/jj96+
        OGFrmBkHi/vJRiG0zvTh1bxQPH0XnneoaSr+CXt62ydcmIYrV0WsgtKLr+gZe22N
        wSw3iwBsk5JGbqdG8WQtG9JgQUsNfrXeUmXx3ZOvefMf4gnQWC8JhKtuYZzmDG4p
        +Hck9hiiOqa7mxo+mqOecpOt0DipWlSCleo5OdZXLi7mrulogwU/s0Dd9GaMpYHQ
        ==
X-ME-Sender: <xms:tQnnYF3ScVQt_LsomezzwN5iVlGLYkjYv7HAIT1IL1Y4374mSIfOWg>
    <xme:tQnnYME7KBMAkrmgSWwHLnyuMWXeffwpMNsvNG89HNCKHK0z_A1fNhjLUcWBjcI7C
    UgMCAFitPEW_zuvhyc>
X-ME-Received: <xmr:tQnnYF4vHbnL13VgWEgREYejMAvJUrBwuFEfHTh_pyWkjk42Kachol3Tf7et3LvtFNt08dV925Wg3NEaqbdViLxd8cMf03aMOa0mJAWdVv8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrtdeggdejfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefvufgjfhfhfffkgggtsehttdertddttddtnecuhfhrohhmpeffrghvihguucfg
    ughmohhnughsohhnuceoughmvgesughmvgdrohhrgheqnecuggftrfgrthhtvghrnhephf
    ekgeeutddvgeffffetheejvdejieetgfefgfffudegffffgeduheegteegleeknecuvehl
    uhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepughmvgesughmvg
    drohhrgh
X-ME-Proxy: <xmx:tQnnYC0Lh30NTb4AmblgwrV3MWcrstAYM6Z_rrU21O4RbelhnQP6pg>
    <xmx:tQnnYIH0SVaIQBPIUtzkks17n4ecj-IHWXh_oj0VoNSGE9-f8j_Jgw>
    <xmx:tQnnYD-d-_ReNw5JyJfAe7MM6Sofp4FVwpD4oMiZ_MaFJbLAucocdQ>
    <xmx:twnnYFduuAZlBHwWv01D7Yr5m1Qp4uZY4tRHNFLxE4DDcVYq5VROo9tt5woKEWgx>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 8 Jul 2021 10:20:35 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id f82794d4;
        Thu, 8 Jul 2021 14:20:35 +0000 (UTC)
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
In-Reply-To: <YOY3RP8iLuWl1Zwh@google.com>
References: <20210706101207.2993686-1-david.edmondson@oracle.com>
 <YOY3RP8iLuWl1Zwh@google.com>
X-HGTTG: heart-of-gold
From:   David Edmondson <dme@dme.org>
Date:   Thu, 08 Jul 2021 15:20:35 +0100
Message-ID: <m25yxk51l8.fsf@dme.org>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wednesday, 2021-07-07 at 23:22:44 UTC, David Matlack wrote:

> On Tue, Jul 06, 2021 at 11:12:05AM +0100, David Edmondson wrote:
>> To help when debugging failures in the field, if instruction emulation
>> fails, report the VM exit reason to userspace in order that it can be
>> recorded.
>> 
>> I'm unsure whether sgx_handle_emulation_failure() needs to be adapted
>> to use the emulation_failure part of the exit union in struct kvm_run
>> - advice welcomed.
>> 
>> v2:
>> - Improve patch comments (dmatlack)
>> - Intel should provide the full exit reason (dmatlack)
>
> I just asked if Intel should provide the full exit reason, I do not have
> an opinion either way. It really comes down to your usecase for wanting
> the exit reason. Would the full exit reason be useful or do you just
> need the basic exit number?

Given that this is intended as a debug aid, having the full exit reason
makes sense.

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
You know it's not the twilight zone.
