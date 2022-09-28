Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90FA65ED890
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 11:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233713AbiI1JNe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 05:13:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233157AbiI1JND (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 05:13:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4733A9DB79
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 02:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664356317;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SjXbYfMWOARgPLnJVm0HUfIT2NbdzQpXSk3guhrMF7w=;
        b=DbzUot5H9xrYsNtFBUZ+hOtzNSZC8eUwafc+onua3mKxvHY5FcUvTn8PR315vNla0AvxHj
        p62MV/VHufyKa23OSYpPtXkf9JofaevyhbgjfHBdUihIgh3ytHcu2QjeGN4EA93+MoAJuG
        H68zOXK3DMmVZchpQe+9m/edTa+lvTM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-513-Kua8K0GzMRuvWSknR_I9Gg-1; Wed, 28 Sep 2022 05:11:55 -0400
X-MC-Unique: Kua8K0GzMRuvWSknR_I9Gg-1
Received: by mail-wr1-f70.google.com with SMTP id l5-20020adfa385000000b0022a482f8285so2783706wrb.5
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 02:11:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=SjXbYfMWOARgPLnJVm0HUfIT2NbdzQpXSk3guhrMF7w=;
        b=S9fdI7rg35oJrBo4HCEl378NA2qKNMddFsp4v+u7bN6a+vAJIp9U7n5NIku6NB9v5Q
         iSBl5NYmCE/pO6a0z6hG4BfrAnMBl/D8mOZZwxicQIh/wzTZ0o7/7YVqnfednsgQ9vOe
         keFgYWl8OLTC34CXzMy6PU5Wc3DsoUIqf7cN7m1HLeH3fZluQ5Y9jeE7yfsdlye/NxjC
         +uSaFScXb6VND/xr6dKwqHRnAY1plFvuqnAYrAez9yULLdAXzt+yx4He5z1+YXKyGyZo
         DthmOsFReBvova0TD5cqqrm+RU4fYL4GWHC2tlz2dnmTgu0GlmnXhKZS2ElICFg7PDpZ
         AinA==
X-Gm-Message-State: ACrzQf0BU+JzxNfmQnk+2qtDAPypduZ+PLbTgLXlpGlX0brWVUxSF5II
        eyTObaUERA5FBK96521jehXcOyKWFmrrgadvlq6LUsvGyWWo3LkQrVlZMQiDLMBNcVyD8EpfLtL
        9RNQC/BxQesh8
X-Received: by 2002:adf:e4cc:0:b0:22a:d755:aaf7 with SMTP id v12-20020adfe4cc000000b0022ad755aaf7mr19972042wrm.692.1664356312894;
        Wed, 28 Sep 2022 02:11:52 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM62/cSJB64UxoPCyu0hOQRIrWQO1IOKLqQURKbRPZawdCzDmdfOR/7kd4hq4oMWNgZVqzS7aQ==
X-Received: by 2002:adf:e4cc:0:b0:22a:d755:aaf7 with SMTP id v12-20020adfe4cc000000b0022ad755aaf7mr19972017wrm.692.1664356312605;
        Wed, 28 Sep 2022 02:11:52 -0700 (PDT)
Received: from [192.168.149.123] (58.254.164.109.static.wline.lns.sme.cust.swisscom.ch. [109.164.254.58])
        by smtp.gmail.com with ESMTPSA id n22-20020a05600c4f9600b003b4cba4ef71sm1211783wmq.41.2022.09.28.02.11.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Sep 2022 02:11:51 -0700 (PDT)
Message-ID: <b3dc9505-9a5c-a631-065a-85bf86b1d071@redhat.com>
Date:   Wed, 28 Sep 2022 11:11:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [RFC PATCH 0/9] kvm: implement atomic memslot updates
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Like Xu <like.xu.linux@gmail.com>
References: <YxtOEgJhe4EcAJsE@google.com>
 <5f0345d2-d4d1-f4fe-86ba-6e22561cb6bd@redhat.com>
 <37b3162e-7b3a-919f-80e2-f96eca7d4b4c@redhat.com>
 <dfcbdf1d-b078-ec6c-7706-6af578f79ec2@redhat.com>
 <55d7f0bd-ace1-506b-ea5b-105a86290114@redhat.com>
 <f753391e-7bdc-bada-856a-87344e75bd74@redhat.com>
 <111a46c1-7082-62e3-4f3a-860a95cd560a@redhat.com>
 <14d5b8f2-7cb6-ce24-c7a7-32aa9117c953@redhat.com>
 <YzIZhn47brWBfQah@google.com>
 <3b04db9d-0177-7e6e-a54c-a28ada8b1d36@redhat.com>
 <YzMdjSkKaJ8HyWXh@google.com>
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
In-Reply-To: <YzMdjSkKaJ8HyWXh@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 27/09/2022 um 17:58 schrieb Sean Christopherson:
> On Tue, Sep 27, 2022, Emanuele Giuseppe Esposito wrote:
>>
>> Am 26/09/2022 um 23:28 schrieb Sean Christopherson:
>>> On Mon, Sep 26, 2022, David Hildenbrand wrote:
>>>> As Sean said "This is an awful lot of a complexity to take on for something
>>>> that appears to be solvable in userspace."
>>>
>>> And if the userspace solution is unpalatable for whatever reason, I'd like to
>>> understand exactly what KVM behavior is problematic for userspace.  E.g. the
>>> above RHBZ bug should no longer be an issue as the buggy commit has since been
>>> reverted.
>>
>> It still is because I can reproduce the bug, as also pointed out in
>> multiple comments below.
> 
> You can reproduce _a_ bug, but it's obviously not the original bug, because the
> last comment says:
> 
>   Second, indeed the patch was reverted and somehow accepted without generating
>   too much noise:
> 
>   ...
> 
>   The underlying issue of course as we both know is still there.
> 
>   You might have luck reproducing it with this bug
> 
>   https://bugzilla.redhat.com/show_bug.cgi?id=1855298
> 
>   But for me it looks like it is 'working' as well, so you might have
>   to write a unit test to trigger the issue.
> 
>>> If the issue is KVM doing something nonsensical on a code fetch to MMIO, then I'd
>>> much rather fix _that_ bug and improve KVM's user exit ABI to let userspace handle
>>> the race _if_ userspace chooses not to pause vCPUs.
>>>
>>
>> Also on the BZ they all seem (Paolo included) to agree that the issue is
>> non-atomic memslots update.
> 
> Yes, non-atomic memslot likely results in the guest fetching from a GPA without a
> memslot.  I'm asking for an explanation of exactly what happens when that occurs,
> because it should be possible to adjust KVM and/or QEMU to play nice with the
> fetch, e.g. to resume the guest until the new memslot is installed, in which case
> an atomic update isn't needed.
> 
> I assume the issue is that KVM exits with KVM_EXIT_INTERNAL_ERROR because the
> guest is running at CPL=0, and QEMU kills the guest in response.  If that's correct,
> then that problem can be solved by exiting to userspace with KVM_EXIT_MMIO instead
> of KVM_EXIT_INTERNAL_ERROR so that userspace can do something sane in response to
> the MMIO code fetch.
> 
> I'm pretty sure this patch will Just Work for QEMU, because QEMU simply resumes
> the vCPU if mmio.len==0.  It's a bit of a hack, but I don't think it violates KVM's
> ABI in any way, and it can even become "official" behavior since KVM x86 doesn't
> otherwise exit with mmio.len==0.
> 
> Compile tested only...

So basically you are just making KVM catch the failed
kvm_vcpu_read_guest_page() by retuning mmio.len = 0 to QEMU which
basically ends up in doing nothing and retry again executing the
instruction?

I wonder if there are some performance implications in this, but it's
definitely simpler than what I did.

Tested on the same failing machine used for the BZ, fixes the bug.

Do you want me to re-send the patch on your behalf (and add probably a
small documentation on Documentation/virt/kvm/api.rst)?

Emanuele
> 
> ---
> From: Sean Christopherson <seanjc@google.com>
> Date: Tue, 27 Sep 2022 08:16:03 -0700
> Subject: [PATCH] KVM: x86: Exit to userspace with zero-length MMIO "read" on
>  MMIO fetch
> 
> Exit to userspace with KVM_EXIT_MMIO if emulation fails due to not being
> able to fetch instruction bytes, e.g. if the resolved GPA isn't backed by
> a memslot.  If userspace is manipulating memslots without pausing vCPUs,
> e.g. to emulate BIOS relocation, then a vCPU may fetch while there is no
> valid memslot installed.  Depending on guest context, KVM will either
> exit to userspace with KVM_EXIT_INTERNAL_ERROR (L1, CPL=0) or simply
> resume the guest (L2 or CPL>0), neither of which is desirable as exiting
> with "emulation error" effectively kills the VM, and resuming the guest
> doesn't provide userspace an opportunity to react the to fetch.
> 
> Use "mmio.len == 0" to indicate "fetch".  This is a bit of a hack, but
> there is no other way to communicate "fetch" to userspace without
> defining an entirely new exit reason, e.g. "mmio.is_write" is a boolean
> and not a flag, and there is no known use case for actually supporting
> code fetches from MMIO, i.e. there's no need to allow userspace to fill
> in the instruction bytes.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/emulate.c     | 2 ++
>  arch/x86/kvm/kvm_emulate.h | 1 +
>  arch/x86/kvm/x86.c         | 9 ++++++++-
>  3 files changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index f092c54d1a2f..e141238d93b0 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -5353,6 +5353,8 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
>  done:
>  	if (rc == X86EMUL_PROPAGATE_FAULT)
>  		ctxt->have_exception = true;
> +	if (rc == X86EMUL_IO_NEEDED)
> +		return EMULATION_IO_FETCH;
>  	return (rc != X86EMUL_CONTINUE) ? EMULATION_FAILED : EMULATION_OK;
>  }
>  
> diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
> index 89246446d6aa..3cb2e321fcd2 100644
> --- a/arch/x86/kvm/kvm_emulate.h
> +++ b/arch/x86/kvm/kvm_emulate.h
> @@ -516,6 +516,7 @@ bool x86_page_table_writing_insn(struct x86_emulate_ctxt *ctxt);
>  #define EMULATION_OK 0
>  #define EMULATION_RESTART 1
>  #define EMULATION_INTERCEPTED 2
> +#define EMULATION_IO_FETCH 3
>  void init_decode_cache(struct x86_emulate_ctxt *ctxt);
>  int x86_emulate_insn(struct x86_emulate_ctxt *ctxt);
>  int emulator_task_switch(struct x86_emulate_ctxt *ctxt,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index aa5ab0c620de..7eb72694c601 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7129,8 +7129,13 @@ static int kvm_fetch_guest_virt(struct x86_emulate_ctxt *ctxt,
>  		bytes = (unsigned)PAGE_SIZE - offset;
>  	ret = kvm_vcpu_read_guest_page(vcpu, gpa >> PAGE_SHIFT, val,
>  				       offset, bytes);
> -	if (unlikely(ret < 0))
> +	if (unlikely(ret < 0)) {
> +		vcpu->run->mmio.phys_addr = gpa;
> +		vcpu->run->mmio.len = 0;
> +		vcpu->run->mmio.is_write = 0;
> +		vcpu->run->exit_reason = KVM_EXIT_MMIO;
>  		return X86EMUL_IO_NEEDED;
> +	}
>  
>  	return X86EMUL_CONTINUE;
>  }
> @@ -8665,6 +8670,8 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  		r = x86_decode_emulated_instruction(vcpu, emulation_type,
>  						    insn, insn_len);
>  		if (r != EMULATION_OK)  {
> +			if (r == EMULATION_IO_FETCH)
> +				return 0;
>  			if ((emulation_type & EMULTYPE_TRAP_UD) ||
>  			    (emulation_type & EMULTYPE_TRAP_UD_FORCED)) {
>  				kvm_queue_exception(vcpu, UD_VECTOR);
> 
> base-commit: 39d9b48cc777bdf6d67d01ed24f1f89b13f5fbb2
> 

