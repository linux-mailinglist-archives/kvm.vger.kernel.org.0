Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9F753C5F59
	for <lists+kvm@lfdr.de>; Mon, 12 Jul 2021 17:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235544AbhGLPhY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jul 2021 11:37:24 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:55359 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232203AbhGLPhX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 12 Jul 2021 11:37:23 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id 1260319406BA;
        Mon, 12 Jul 2021 11:34:35 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 12 Jul 2021 11:34:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=hgaeow
        vD5YYnNfnHdGdhp3KwY7X+hWI4Kx7Q+UzNECU=; b=dg+b1FTlWz9KAyECRyLoGM
        nP7PbKf3a1fKO0urd7hHw9OSQIrVz/4Bwz+s/357wgFvM+o+ewVyuYMAA5KeW7Sj
        Gj+n1v9POiZg9Hu7Ety/LH0fvvQ++BJ++h9peK51X3ML9Pk4vZSTmNcGxZlv+tE6
        +JUVKh2eFylW8DkDuvox4q/L6DtGFWgntUS3DyDzkcgH9LbJbMI2xvsQYt7qj7U0
        h8l80UYZ0vAReizLHTZhW9XVDYCZ5EKure9zV8lSq4IAPYqtHnzMR+f2w26Q7UW0
        /IhE86nyHB0noK2W89KN320HonQesT9UM1VC4ikM137K9moBuNEZ+ANv85B1M6zg
        ==
X-ME-Sender: <xms:AWHsYEIqMFj65Qep5BZc-1XMDKHKIWG8sqby99bmMQWCdNni8c2NvA>
    <xme:AWHsYEJmR0vDZ7wwGKRzDjrybvIgi_FwCApjrlAw9Peb-C0_VuuDhpT1smVNMaDEP
    D8V7SXb9AMsjMtSz7o>
X-ME-Received: <xmr:AWHsYEsufqsG-vDfT3S5297WA87xHyEhDMQAcbfJzZqVtWqfUiNDwLnj1QEIeBf6jAnvphzupYyjpslkgkDVkoLODxlfEJje2BSr3RvBFO8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddvgdekkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefvufgjfhfhfffkgggtsehttdertddttddtnecuhfhrohhmpeffrghvihguucfg
    ughmohhnughsohhnuceouggrvhhiugdrvggumhhonhgushhonhesohhrrggtlhgvrdgtoh
    hmqeenucggtffrrghtthgvrhhnpeehleeffeduiedugedulefgteegteekleevueeitedu
    leehjeekieelkeevueektdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpegurghvihgurdgvughmohhnughsohhnsehorhgrtghlvgdrtghomh
X-ME-Proxy: <xmx:AWHsYBaEWF6QPzj2Bv_3hnZvUcPe3aYa03-tbqJSYyCUliYlyj1lxg>
    <xmx:AWHsYLbF58Z4MEBsDnmJrNaRyXSoxQYSvVylhi_Bii17LbiHp9ht3Q>
    <xmx:AWHsYNBO_4Rw2PRcWWxoO7RoN97AafGqyC7ARkGepiL6c7zdkipvDg>
    <xmx:C2HsYBxfjeoAFkM7Cx8wRw3QSkvrbkDbMxwsi-lNtZsZUIjXp4wFMvFZevU>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 12 Jul 2021 11:34:24 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 156d48ed;
        Mon, 12 Jul 2021 15:34:23 +0000 (UTC)
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Joao Martins <joao.m.martins@oracle.com>
Subject: Re: [PATCH v2 2/2] KVM: x86: On emulation failure, convey the exit
 reason to userspace
In-Reply-To: <YOhvfDfqypLCRZuO@google.com>
References: <20210706101207.2993686-1-david.edmondson@oracle.com>
 <20210706101207.2993686-3-david.edmondson@oracle.com>
 <YOhvfDfqypLCRZuO@google.com>
X-HGTTG: heart-of-gold
From:   David Edmondson <david.edmondson@oracle.com>
Date:   Mon, 12 Jul 2021 16:34:22 +0100
Message-ID: <m2pmvn35s1.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Friday, 2021-07-09 at 15:47:08 UTC, Sean Christopherson wrote:

> On Tue, Jul 06, 2021, David Edmondson wrote:
>> Should instruction emulation fail, include the VM exit reason in the
>> emulation_failure data passed to userspace, in order that the VMM can
>> report it as a debugging aid when describing the failure.
>
> ...
>
>> @@ -7473,7 +7474,14 @@ static void prepare_emulation_failure_exit(struct kvm_vcpu *vcpu)
>>  		memcpy(run->emulation_failure.insn_bytes,
>>  		       ctxt->fetch.data, insn_size);
>>  	}
>> +
>> +	run->emulation_failure.ndata = 4;
>> +	run->emulation_failure.flags |=
>> +		KVM_INTERNAL_ERROR_EMULATION_FLAG_EXIT_REASON;
>> +	run->emulation_failure.exit_reason =
>> +		static_call(kvm_x86_get_exit_reason)(vcpu);
>>  }
>
> ...
>
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index d9e4aabcb31a..863195371272 100644
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
>> @@ -404,6 +405,12 @@ struct kvm_run {
>>  			__u64 flags;
>>  			__u8  insn_size;
>>  			__u8  insn_bytes[15];
>> +			/*
>> +			 * The "exit reason" extracted from the
>> +			 * VMCS/VMCB that was the cause of attempted
>> +			 * emulation.
>> +			 */
>> +			__u64 exit_reason;
>
> Rather than providing just the exit reason and adding another kvm_x86_ops hook,
> I would prefer to extend kvm_x86_get_exit_info() to also provide the exit reason
> and use that.  E.g. on VMX, all exceptions funnel through a single exit reason.
> Dumping exit_info_{1,2} and error_code in addition to intr_info might not be all
> that useful, but I can't see in harm either, and more info is generally a good
> thing.
>
> The only other user of kvm_x86_get_exit_info() is for tracepoints, those could
> be modified to not pass in the exit reason.

Okay.

>>  		} emulation_failure;
>>  		/* KVM_EXIT_OSI */
>>  		struct {
>> -- 
>> 2.30.2
>> 

dme.
-- 
What did you learn today? I learnt nothing.
