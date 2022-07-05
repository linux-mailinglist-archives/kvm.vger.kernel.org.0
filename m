Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA6A8567018
	for <lists+kvm@lfdr.de>; Tue,  5 Jul 2022 15:58:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbiGEN6F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jul 2022 09:58:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232814AbiGEN5Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jul 2022 09:57:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6541F1A38F
        for <kvm@vger.kernel.org>; Tue,  5 Jul 2022 06:40:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657028420;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y21vIIappxvjeYgEzXDVagkcbBuiUGzrS1YtS/nblTA=;
        b=R3o3fGXgqZYXbC3azpMnEBLhnEWGREqKvn1ZqAG6lRyL2eqMPQ8Nv0rI2t3Duui+VUkVPU
        47+aobvTUue2IcHSGd1ZJcZG3g7sPN3rBeQv8rmiFVLNrmTX59TRbAzcRKpFQZarTqmVYu
        uxi73f6QIAg6lCikoCfR1AdtJCm2EKE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-443-ccy8g-_5P4GJHWogm1ZnEQ-1; Tue, 05 Jul 2022 09:40:19 -0400
X-MC-Unique: ccy8g-_5P4GJHWogm1ZnEQ-1
Received: by mail-wr1-f71.google.com with SMTP id g9-20020adfa489000000b0021d6e786099so681386wrb.7
        for <kvm@vger.kernel.org>; Tue, 05 Jul 2022 06:40:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=y21vIIappxvjeYgEzXDVagkcbBuiUGzrS1YtS/nblTA=;
        b=HTjloUvIg+AXJLpcg/78a3r+MtuXMZn1BboG0i4Ak4YXJ7mfx7GKIMtWlPRK9cDbjF
         l6tncz10/8xNwyEY/pjy/k6ecbbmK0vaWskAY42dh79zZvHLxoSvLNpOvZTVMk7Gc8Ei
         uboYZANOMgsYmiC1yfNNkhjB3iOOHITF+psv+9j73Lkd67YJtVH2hLY5g9wAkqG8laYg
         uNxF7bwsPne92KblwQMwg0sfqrm+nL6q6+okRmt5jacIqpuHVkz9uxP+kQmVxL5VgaHD
         nm9d7fJpGD8YsXkEj1dmbOmfeU1PPZtpM08YPusaZWlp9xxtE31HiuBYKaqkJLh5oCqU
         HOxA==
X-Gm-Message-State: AJIora+ulOiZ61AMFYlHCFmV25cyw64tCXenYUL93tLXQRwaNBsNxvSH
        esxHUo24LpaM30Lf37Io8YhFauMZYxsNATShT9TFVhplCRni8YBCa/5OHan1Hoa/KvbLJF6vIjU
        Qt7iL7/PxL1d6
X-Received: by 2002:adf:9d92:0:b0:21d:66c4:e311 with SMTP id p18-20020adf9d92000000b0021d66c4e311mr12870361wre.575.1657028418172;
        Tue, 05 Jul 2022 06:40:18 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sNmjhPtCdTZFof/1VcwqTqHd1KWScVVm4b5wzUunc8cyMu2pUZPka75+2kUVmM3KCzUB6+pA==
X-Received: by 2002:adf:9d92:0:b0:21d:66c4:e311 with SMTP id p18-20020adf9d92000000b0021d66c4e311mr12870330wre.575.1657028417952;
        Tue, 05 Jul 2022 06:40:17 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id f4-20020adfe904000000b0021d639e3daasm8888774wrm.30.2022.07.05.06.40.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 06:40:17 -0700 (PDT)
Message-ID: <646d2f04bbc7530339ca02dcf5eeb3b5e298a1c2.camel@redhat.com>
Subject: Re: [PATCH v2 11/11] KVM: x86: emulator/smm: preserve interrupt
 shadow in SMRAM
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        x86@kernel.org, Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>
Date:   Tue, 05 Jul 2022 16:40:15 +0300
In-Reply-To: <289c2dd941ecbc3c32514fc0603148972524b22d.camel@redhat.com>
References: <20220621150902.46126-1-mlevitsk@redhat.com>
         <20220621150902.46126-12-mlevitsk@redhat.com>
         <CALMp9eSe5jtvmOPWLYCcrMmqyVBeBkg90RwtR4bwxay99NAF3g@mail.gmail.com>
         <42da1631c8cdd282e5d9cfd0698b6df7deed2daf.camel@redhat.com>
         <CALMp9eRNZ8D5aRyUEkc7CORz-=bqzfVCSf6nOGZhqQfWfte0dw@mail.gmail.com>
         <289c2dd941ecbc3c32514fc0603148972524b22d.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-07-05 at 16:38 +0300, Maxim Levitsky wrote:
> On Thu, 2022-06-30 at 09:00 -0700, Jim Mattson wrote:
> > On Wed, Jun 29, 2022 at 11:00 PM Maxim Levitsky <mlevitsk@redhat.com> wrote:
> > > 
> > > On Wed, 2022-06-29 at 09:31 -0700, Jim Mattson wrote:
> > > > On Tue, Jun 21, 2022 at 8:09 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:
> > > > > When #SMI is asserted, the CPU can be in interrupt shadow
> > > > > due to sti or mov ss.
> > > > > 
> > > > > It is not mandatory in  Intel/AMD prm to have the #SMI
> > > > > blocked during the shadow, and on top of
> > > > > that, since neither SVM nor VMX has true support for SMI
> > > > > window, waiting for one instruction would mean single stepping
> > > > > the guest.
> > > > > 
> > > > > Instead, allow #SMI in this case, but both reset the interrupt
> > > > > window and stash its value in SMRAM to restore it on exit
> > > > > from SMM.
> > > > > 
> > > > > This fixes rare failures seen mostly on windows guests on VMX,
> > > > > when #SMI falls on the sti instruction which mainfest in
> > > > > VM entry failure due to EFLAGS.IF not being set, but STI interrupt
> > > > > window still being set in the VMCS.
> > > > 
> > > > I think you're just making stuff up! See Note #5 at
> > > > https://sandpile.org/x86/inter.htm.
> > > > 
> > > > Can you reference the vendors' documentation that supports this change?
> > > > 
> > > 
> > > First of all, just to note that the actual issue here was that
> > > we don't clear the shadow bits in the guest interruptability field
> > > in the vmcb on SMM entry, that triggered a consistency check because
> > > we do clear EFLAGS.IF.
> > > Preserving the interrupt shadow is just nice to have.
> > > 
> > > 
> > > That what Intel's spec says for the 'STI':
> > > 
> > > "The IF flag and the STI and CLI instructions do not prohibit the generation of exceptions and nonmaskable inter-
> > > rupts (NMIs). However, NMIs (and system-management interrupts) may be inhibited on the instruction boundary
> > > following an execution of STI that begins with IF = 0."
> > > 
> > > Thus it is likely that #SMI are just blocked when in shadow, but it is easier to implement
> > > it this way (avoids single stepping the guest) and without any user visable difference,
> > > which I noted in the patch description, I noted that there are two ways to solve this,
> > > and preserving the int shadow in SMRAM is just more simple way.
> > 
> > It's not true that there is no user-visible difference. In your
> > implementation, the SMI handler can see that the interrupt was
> > delivered in the interrupt shadow.
> 
> Most of the SMI save state area is reserved, and the handler has no way of knowing
> what CPU stored there, it can only access the fields that are reserved in the spec.
I mean fields that are not reserved in the spec.

Best regards,
	Maxim Levitsky
> 
> Yes, if the SMI handler really insists it can see that the saved RIP points to an
> instruction that follows the STI, but does that really matter? It is allowed by the
> spec explicitly anyway.
> 
> Plus our SMI layout (at least for 32 bit) doesn't confirm to the X86 spec anyway,
> we as I found out flat out write over the fields that have other meaning in the X86 spec.
> 
> Also I proposed to preserve the int shadow in internal kvm state and migrate
> it in upper 4 bits of the 'shadow' field of struct kvm_vcpu_events.
> Both Paolo and Sean proposed to store the int shadow in the SMRAM instead,
> and you didn't object to this, and now after I refactored and implemented
> the whole thing you suddently do.
> 
> BTW, just FYI, I found out that qemu doesn't migrate the 'shadow' field,
> this needs to be fixed (not related to the issue, just FYI).
> 
> > 
> > The right fix for this problem is to block SMI in an interrupt shadow,
> > as is likely the case for all modern CPUs.
> 
> Yes, I agree that this is the most correct fix. 
> 
> However AMD just recently posted a VNMI patch series to avoid
> single stepping the CPU when NMI is blocked due to the same reason, because
> it is fragile.
> 
> Do you really want KVM to single step the guest in this case, to deliver the #SMI?
> I can do it, but it is bound to cause lot of trouble.
> 
> Note that I will have to do it on both Intel and AMD, as neither has support for SMI
> window, unless I were to use MTF, which is broken on nested virt as you know,
> so a nested hypervisor running a guest with SMI will now have to cope with broken MTF.
> 
> Note that I can't use the VIRQ hack we use for interrupt window, because there
> is no guarantee that the guest's EFLAGS.IF is on.
> 
> Best regards,   
>         Maxim Levitsky
> 
> > 
> > > 
> > > As for CPUS that neither block SMI nor preserve the int shadaw, in theory they can, but that would
> > > break things, as noted in this mail
> > > 
> > > https://lore.kernel.org/lkml/1284913699-14986-1-git-send-email-avi@redhat.com/
> > > 
> > > It is possible though that real cpu supports HLT restart flag, which makes this a non issue,
> > > still. I can't rule out that a real cpu doesn't preserve the interrupt shadow on SMI, but
> > > I don't see why we can't do this to make things more robust.
> > 
> > Because, as I said, I think you're just making stuff up...unless, of
> > course, you have documentation to back this up.
> > 
> 


