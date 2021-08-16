Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 737763EDB3D
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 18:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbhHPQul (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 12:50:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37882 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229742AbhHPQuj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Aug 2021 12:50:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629132607;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cVl5XTBJvniKtudSQorw+bJQwZtfOhDJO1gRPc+AecI=;
        b=ga9brtHwa7bdx7Xrze/2TRfai3VznopCJDa8ZjuguCRk7UM38Nfq24wBcib784q0Yc4HeE
        VcgS/3q4+r6Jm3wXx/IaojiAdT/F3Zf2z2964BmkZ/JVKXOe40i1SFgnTum3g7BX/50d1b
        5ZGvx7gIGUfIoLkoWkb5gvvRhVljf7g=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-557-4CkQeItzO4Ca0itlHX4Yzg-1; Mon, 16 Aug 2021 12:50:05 -0400
X-MC-Unique: 4CkQeItzO4Ca0itlHX4Yzg-1
Received: by mail-ed1-f69.google.com with SMTP id j15-20020aa7c40f0000b02903be5fbe68a9so9142711edq.2
        for <kvm@vger.kernel.org>; Mon, 16 Aug 2021 09:50:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cVl5XTBJvniKtudSQorw+bJQwZtfOhDJO1gRPc+AecI=;
        b=U8hxNpMdBUba5gUlUPSVtoMFbr4lQiIjb9Qil5O6sOv+lbALM913vNo+cek1Yget7/
         RviocaGLvCLDk0YLdDI3eKgccvQ+NR/eEDQOdFvP0zFX8C+HAONdJZNq5uz4ny0aRDLF
         UyQ8wuHLYfMeiKaecBOglByG+mK9nP7mlPw7nl5URfrSQ4VOI4frV2LN5lCd2w4oKkwd
         aXwPFwyjldCCSlUmx1bp4ocYE7oS9EJUUsoKH/45h8vWDtVgtjDgX3uKRMocD9zgcTrj
         JE/DD2dmphoLqPoq0zHiE3WJ14imWJQCIvXnc12HIZs/35IaEiOIAL2zi3HjkSnlSNtg
         DG0w==
X-Gm-Message-State: AOAM531Ud40A+OpwdpvpfgURvDZGE0VLwXqfEEUsZDDuMciDp8MI2gBy
        w2NXt2/i1r5cr726F3BdfBLSJU+Ylc5fAs9NqG4+reTGszmF//d9xTZjXq5F5dqf97FrcCoU+Dx
        htf+IFuU8XBUs
X-Received: by 2002:aa7:dcd1:: with SMTP id w17mr20988761edu.322.1629132604558;
        Mon, 16 Aug 2021 09:50:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx8PCKQTS8AGUkKZdJCzvBNIrFQn0x+gxgg4UqVtPyx2E8oJqmu+zkAMgd11gRHp9CjqkbZ9g==
X-Received: by 2002:aa7:dcd1:: with SMTP id w17mr20988747edu.322.1629132604424;
        Mon, 16 Aug 2021 09:50:04 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id j29sm3061783ejo.10.2021.08.16.09.50.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Aug 2021 09:50:03 -0700 (PDT)
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
References: <332b6896f595282ea3d261095612fd31ce4cf14f.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: RFC: Proposal to create a new version of the SVM nested state
 migration blob
Message-ID: <1ff7a205-283d-d2b3-d130-e40066f59df0@redhat.com>
Date:   Mon, 16 Aug 2021 18:50:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <332b6896f595282ea3d261095612fd31ce4cf14f.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/08/21 14:54, Maxim Levitsky wrote:
> Then on nested VM exit,
> we would only restore the kvm's guest visible values (vcpu->arch.cr*/efer)
> from that 'somewhere else', and could do this without any checks/etc, since these already passed all checks.
>   
> This needs to save these values in the migration stream as well of course.

Note that there could be differences between the guest-visible values 
and the processor values of CRx.  In particular, say you have a 
hypervisor that uses PSE for its page tables.  The CR4 would have 
CR4.PSE=1 on a machine that uses NPT and CR4.PAE=1 on a machine that 
doesn't.

> Finally I propose that SVM nested state would be:
>  
> * L1 save area.
> * L1 guest visible CR*/EFER/etc values (vcpu->arch.cr* values)
> * Full VMCB12 (save and control area)

So your proposal would basically be to:

* do the equivalent of sync_vmcs02_to_vmcs12+sync_vmcs02_to_vmcs12_rare 
on KVM_GET_NESTED_STATE

* discard the current state on KVM_SET_NESTED_STATE.

That does make sense.  It wasn't done this way just because the "else" 
branch of

         if (is_guest_mode(vcpu)) {
                 sync_vmcs02_to_vmcs12(vcpu, vmcs12);
                 sync_vmcs02_to_vmcs12_rare(vcpu, vmcs12);
         } else  {
                 copy_vmcs02_to_vmcs12_rare(vcpu, get_vmcs12(vcpu));
                 if (!vmx->nested.need_vmcs12_to_shadow_sync) {
                         if (vmx->nested.hv_evmcs)
                                 copy_enlightened_to_vmcs12(vmx);
                         else if (enable_shadow_vmcs)
                                 copy_shadow_to_vmcs12(vmx);
                 }
         }

isn't needed on SVM and thus it seemed "obvious" to remove the "then" 
branch as well.  I just focused on enter_svm_guest_mode when refactoring 
the common bits of vmentry and KVM_SET_NESTED_STATE, so there is not 
even a function like sync_vmcb02_to_vmcb12 (instead it's just done in 
nested_svm_vmexit).

It does have some extra complications, for example with SREGS2 and the 
always more complicated ordering of KVM_SET_* ioctls.

On the other hand, issues like not migrating PDPTRs were not specific to 
nested SVM, and merely exposed by it.  The ordering issues with 
KVM_SET_VCPU_EVENTS and KVM_SET_MP_STATE's handling of INIT and SIPI are 
also not specific to nested SVM.  I am not sure that including the full 
VMCB12 in the SVM nested state would solve any of these.  Anything that 
would be solved, probably would be just because migrating a large blob 
is easier than juggling a dozen ioctls.

Thanks,

Paolo

