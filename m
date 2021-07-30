Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA0B3DB482
	for <lists+kvm@lfdr.de>; Fri, 30 Jul 2021 09:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237616AbhG3HaF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jul 2021 03:30:05 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:33407 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230337AbhG3HaF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 30 Jul 2021 03:30:05 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.west.internal (Postfix) with ESMTP id CB48D1AC0033;
        Fri, 30 Jul 2021 03:29:58 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Fri, 30 Jul 2021 03:29:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=dEzoO3
        e5Gf3/WxsXdgCVKNFItf3m4OWNnkjH5aZyCb8=; b=TGFFDRvqsUHtG8TmZTiDri
        TRx628qViMWRHtLWzvUBrH6qQu7HAOVWfCv8bMiXj/U2KIPmBfclXIuBc3DvvGbs
        wY7zLPy0f34Q7IZ0DjLTVv4FTwSrl+KStZoKOzJZHjVwD1BHZc8AcaBs85jSXThc
        v5f0oniZOrFxBMcFYD9nbJdXoM14CPwo1CGKDbK0Fen63pPg5dpXnvhZJ++ezgcQ
        /NPgxegdbEUwD+XKL1U6AmPPaJcOo2esL5Tuyq/sPhvgk4t0R675fYcZvYyoFDWS
        IqMhVUSuqECyH48mDeOtlUgHdIHpk/oGTr4dFdwCe+Y8aPgz4JFkn9fmd6f65deg
        ==
X-ME-Sender: <xms:dKoDYY_hsbCZBSV7lomj82SZhW9uk3sQDDRNYAj6SU_lhoh-5oWOBQ>
    <xme:dKoDYQugLUZV-Sd5xPn6YYL9y2-iVUBjgP8o6DRgYzXMK2BypbON5eB-81ldZBxD-
    kmEUwp702lj-EAioKA>
X-ME-Received: <xmr:dKoDYeBeu-r_IA2oKPCyxwwOMN0kxZeCrn_N0Z8o7gWznraeYnyr6Io2kyA28Mdm-U_04wfVQdb5GFvpLvy9PwEy1lRJI2OpeThk9s3-FN8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrheeggddutddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepvffujghfhfffkfggtgesthdtredttddttdenucfhrhhomhepffgrvhhiugcu
    gfgumhhonhgushhonhcuoegumhgvsegumhgvrdhorhhgqeenucggtffrrghtthgvrhhnpe
    fhkeeguedtvdegffffteehjedvjeeitefgfefgffdugeffffegudehgeetgeelkeenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegumhgvsegumh
    gvrdhorhhg
X-ME-Proxy: <xmx:dKoDYYcRaEQh_lnu_ii9Q1dNQ5UVBQfUaQ6qZvRbOsEjpyBt9hIvQw>
    <xmx:dKoDYdOExhZ2PaEzpsQQbM1mj4rwXfa2L3x9c-wFrp_86sg9pb3ljA>
    <xmx:dKoDYSm8RvtdQe2cUePJKqN61xGu_XkeBDjPO0_R77DyIN_zLW0odw>
    <xmx:dqoDYUkyVJdx73gLiAHEA4JYCnxsU09V6LdHrgz5cPFerDNqYTXaa3yalhzi9pQY>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 30 Jul 2021 03:29:54 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 26d30f0b;
        Fri, 30 Jul 2021 07:29:53 +0000 (UTC)
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>,
        David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH v3 1/3] KVM: x86: kvm_x86_ops.get_exit_info should
 include the exit reason
In-Reply-To: <YQMrUOjZMD1eiIeE@google.com>
References: <20210729133931.1129696-1-david.edmondson@oracle.com>
 <20210729133931.1129696-2-david.edmondson@oracle.com>
 <YQMrUOjZMD1eiIeE@google.com>
From:   David Edmondson <dme@dme.org>
Date:   Fri, 30 Jul 2021 08:29:53 +0100
Message-ID: <cunsfzwmf7y.fsf@dme.org>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thursday, 2021-07-29 at 22:27:28 GMT, Sean Christopherson wrote:

> Shortlog is a bit odd, "should" is subjective and makes this sound like a bug fix.
>
>   KVM: x86: Get exit_reason as part of kvm_x86_ops.get_exit_info

Okay.

> On Thu, Jul 29, 2021, David Edmondson wrote:
>> Extend the get_exit_info static call to provide the reason for the VM
>> exit. Modify relevant trace points to use this rather than extracting
>> the reason in the caller.
>> 
>> Signed-off-by: David Edmondson <david.edmondson@oracle.com>
>> ---
>> -static void svm_get_exit_info(struct kvm_vcpu *vcpu, u64 *info1, u64 *info2,
>> +static void svm_get_exit_info(struct kvm_vcpu *vcpu, u64 *reason,
>> +			      u64 *info1, u64 *info2,
>>  			      u32 *intr_info, u32 *error_code)
>>  {
>>  	struct vmcb_control_area *control = &to_svm(vcpu)->vmcb->control;
>>  
>> +	*reason = control->exit_code;
>>  	*info1 = control->exit_info_1;
>>  	*info2 = control->exit_info_2;
>>  	*intr_info = control->exit_int_info;
>
> ...
>
>> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
>> index b484141ea15b..2228565beda2 100644
>> --- a/arch/x86/kvm/trace.h
>> +++ b/arch/x86/kvm/trace.h
>> @@ -273,11 +273,11 @@ TRACE_EVENT(kvm_apic,
>>  
>>  #define TRACE_EVENT_KVM_EXIT(name)					     \
>>  TRACE_EVENT(name,							     \
>> -	TP_PROTO(unsigned int exit_reason, struct kvm_vcpu *vcpu, u32 isa),  \
>> -	TP_ARGS(exit_reason, vcpu, isa),				     \
>> +	TP_PROTO(struct kvm_vcpu *vcpu, u32 isa),			     \
>> +	TP_ARGS(vcpu, isa),						     \
>>  									     \
>>  	TP_STRUCT__entry(						     \
>> -		__field(	unsigned int,	exit_reason	)	     \
>> +		__field(	u64,		exit_reason	)	     \
>
> Converting to a u64 is unnecessary and misleading.  vmcs.EXIT_REASON and
> vmcb.EXIT_CODE are both u32s, a.k.a. unsigned ints.  There is vmcb.EXIT_CODE_HI,
> but that's not being included, and AFAICT isn't even sanity checked by KVM.

Thanks for pointing this out, I can only blame brain fade.

>>  		__field(	unsigned long,	guest_rip	)	     \
>>  		__field(	u32,	        isa             )	     \
>>  		__field(	u64,	        info1           )	     \
