Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 018B13B9DA9
	for <lists+kvm@lfdr.de>; Fri,  2 Jul 2021 10:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbhGBIrZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jul 2021 04:47:25 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:57215 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230166AbhGBIrX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 2 Jul 2021 04:47:23 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id D3C8F1940668;
        Fri,  2 Jul 2021 04:44:50 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 02 Jul 2021 04:44:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Jd0DgZ
        kYge3EvDll0XHFsWzoTH+0LIBOXTeQjkdl/MQ=; b=biniZq9WQsy44tGBrDs47O
        3Z6gWgPvxBQ0byj+RDNylrgv4OhOIIO9vSMocU8XthzKdmvPxnU0ZNRX06WcPDWP
        UhygN3u7NwqX3kZbN2SOpylPDh7iebsSt0u1iXKcYxmGt9vFOmu0RyXa3VTdrivW
        WJ2meiDgTINK173cn01gOiPjZqatsZv9Tb/QFUoCZOHdIGKNBUhe+7bwEOi3fkgY
        sqWwIdfF5q6HaDt96yR2Er21JSduNSXCt2qZKJkiNY+B33b22PnjwWenAk59RbAU
        F4gmK2QTlEQHV/R2c2QC55/BzvcXca6Z3LUQRX2OALT2A2XWr7cwzJ2mXO13BLLQ
        ==
X-ME-Sender: <xms:_dHeYKTO8ADXiBjfHqDs2mWc-GhCMOQrj5s8jA9ReAqrN4aORaxiHQ>
    <xme:_dHeYPxvVb8_UjSDQRkcg5RH8IYPWECcWcmIuje4bdQdVNOx90hnbjryDN-mAiBPw
    RG5EldfHOyXWl22n4A>
X-ME-Received: <xmr:_dHeYH1urfWTrTO5r4gCkoJYlSctP8lJ0Xmtokk0FQs-_oXmg_Yf8N2859T-YAyWphsYTAX8XjsWW1T7FhzN7b-z1RWNcKtDsmescS3hlWI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeeikedgtdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepvffujghfhfffkfggtgesthdtredttddttdenucfhrhhomhepffgrvhhiugcu
    gfgumhhonhgushhonhcuoegurghvihgurdgvughmohhnughsohhnsehorhgrtghlvgdrtg
    homheqnecuggftrfgrthhtvghrnhepheelfeefudeiudegudelgfetgeetkeelveeuieet
    udelheejkeeileekveeukedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepuggrvhhiugdrvggumhhonhgushhonhesohhrrggtlhgvrdgtohhm
X-ME-Proxy: <xmx:_dHeYGDFO_LqK1XPMSmxdeTvd2lJCXk2mi3SDIYarnohyBn5FNaNyA>
    <xmx:_dHeYDgOi0cjiStxfdwEy1ZlRBIrWoyVLNo-LXoNA6kqJMmKXxiE9Q>
    <xmx:_dHeYCr6gZF9amYkyGKzh3hEyR4oyWts1X4-Fsharo1Q1YumvZtLGg>
    <xmx:AtLeYMYcd5sCJAHZ7mYr8tIhNAJe02FWjjPulfVl_H25Tvr5b_2OwDH1atU>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 2 Jul 2021 04:44:44 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id c7b4aea2;
        Fri, 2 Jul 2021 08:44:43 +0000 (UTC)
To:     David Matlack <dmatlack@google.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
        Joao Martins <joao.m.martins@oracle.com>
Subject: Re: [PATCH 2/2] KVM: x86: On emulation failure, convey the exit
 reason to userspace
In-Reply-To: <YNygagjfTIuptxL8@google.com>
References: <20210628173152.2062988-1-david.edmondson@oracle.com>
 <20210628173152.2062988-3-david.edmondson@oracle.com>
 <YNygagjfTIuptxL8@google.com>
X-HGTTG: heart-of-gold
From:   David Edmondson <david.edmondson@oracle.com>
Date:   Fri, 02 Jul 2021 09:44:42 +0100
Message-ID: <m2pmw114w5.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wednesday, 2021-06-30 at 16:48:42 UTC, David Matlack wrote:

> On Mon, Jun 28, 2021 at 06:31:52PM +0100, David Edmondson wrote:
>> To aid in debugging.
>
> Please add more context to the commit message.

Okay.

>> 
>> Suggested-by: Joao Martins <joao.m.martins@oracle.com>
>> Signed-off-by: David Edmondson <david.edmondson@oracle.com>
>> ---
>>  arch/x86/kvm/x86.c       | 23 +++++++++++++++++------
>>  include/uapi/linux/kvm.h |  2 ++
>>  2 files changed, 19 insertions(+), 6 deletions(-)
>> 
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 8166ad113fb2..48ef0dc68faf 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -7455,7 +7455,7 @@ void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip)
>>  }
>>  EXPORT_SYMBOL_GPL(kvm_inject_realmode_interrupt);
>>  
>> -static void prepare_emulation_failure_exit(struct kvm_vcpu *vcpu)
>> +static void prepare_emulation_failure_exit(struct kvm_vcpu *vcpu, uint64_t flags)
>>  {
>>  	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
>>  	u32 insn_size = ctxt->fetch.end - ctxt->fetch.data;
>> @@ -7466,7 +7466,8 @@ static void prepare_emulation_failure_exit(struct kvm_vcpu *vcpu)
>>  	run->emulation_failure.ndata = 0;
>>  	run->emulation_failure.flags = 0;
>>  
>> -	if (insn_size) {
>> +	if (insn_size &&
>> +	    (flags & KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES)) {
>>  		run->emulation_failure.ndata = 3;
>>  		run->emulation_failure.flags |=
>>  			KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES;
>> @@ -7476,6 +7477,14 @@ static void prepare_emulation_failure_exit(struct kvm_vcpu *vcpu)
>>  		memcpy(run->emulation_failure.insn_bytes,
>>  		       ctxt->fetch.data, insn_size);
>>  	}
>> +
>> +	if (flags & KVM_INTERNAL_ERROR_EMULATION_FLAG_EXIT_REASON) {
>
> This flag is always passed so this check if superfluous. Perhaps change
> `int flags` to `bool instruction_bytes` and have it control only whether
> the instruction bytes are populated.

Okay.

>> +		run->emulation_failure.ndata = 4;
>> +		run->emulation_failure.flags |=
>> +			KVM_INTERNAL_ERROR_EMULATION_FLAG_EXIT_REASON;
>> +		run->emulation_failure.exit_reason =
>> +			static_call(kvm_x86_get_exit_reason)(vcpu);
>> +	}
>>  }
>>  
>>  static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
>> @@ -7492,16 +7501,18 @@ static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
>>  
>>  	if (kvm->arch.exit_on_emulation_error ||
>>  	    (emulation_type & EMULTYPE_SKIP)) {
>> -		prepare_emulation_failure_exit(vcpu);
>> +		prepare_emulation_failure_exit(
>> +			vcpu,
>> +			KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES |
>> +			KVM_INTERNAL_ERROR_EMULATION_FLAG_EXIT_REASON);
>>  		return 0;
>>  	}
>>  
>>  	kvm_queue_exception(vcpu, UD_VECTOR);
>>  
>>  	if (!is_guest_mode(vcpu) && static_call(kvm_x86_get_cpl)(vcpu) == 0) {
>> -		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
>> -		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
>> -		vcpu->run->internal.ndata = 0;
>> +		prepare_emulation_failure_exit(
>> +			vcpu, KVM_INTERNAL_ERROR_EMULATION_FLAG_EXIT_REASON);
>
> Should kvm_task_switch and kvm_handle_memory_failure also be updated
> like this?

Will do in v2.

sgx_handle_emulation_failure() seems like an existing user of
KVM_INTERNAL_ERROR_EMULATION that doesn't follow the new protocol (use
the emulation_failure part of the union).

Sean: If I add another flag for this case, what is the existing
user-level consumer?

>>  		return 0;
>>  	}
>>  
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index 68c9e6d8bbda..3e4126652a67 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -282,6 +282,7 @@ struct kvm_xen_exit {
>>  
>>  /* Flags that describe what fields in emulation_failure hold valid data. */
>>  #define KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES (1ULL << 0)
>> +#define KVM_INTERNAL_ERROR_EMULATION_FLAG_EXIT_REASON       (1ULL << 1)
>>  
>>  /* for KVM_RUN, returned by mmap(vcpu_fd, offset=0) */
>>  struct kvm_run {
>> @@ -404,6 +405,7 @@ struct kvm_run {
>>  			__u64 flags;
>>  			__u8  insn_size;
>>  			__u8  insn_bytes[15];
>> +			__u64 exit_reason;
>
> Please document what this field contains, especially since its contents
> depend on AMD versus Intel.

Okay.

>>  		} emulation_failure;
>>  		/* KVM_EXIT_OSI */
>>  		struct {
>> -- 
>> 2.30.2
>> 

dme.
-- 
Welcome to Conditioning.
