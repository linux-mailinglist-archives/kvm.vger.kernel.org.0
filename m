Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC47C5BA936
	for <lists+kvm@lfdr.de>; Fri, 16 Sep 2022 11:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbiIPJRh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Sep 2022 05:17:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231312AbiIPJRM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Sep 2022 05:17:12 -0400
X-Greylist: delayed 927 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 16 Sep 2022 02:16:28 PDT
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41C5CA59A9;
        Fri, 16 Sep 2022 02:16:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=misterjones.org; s=dkim20211231; h=Content-Transfer-Encoding:Content-Type:
        Message-ID:References:In-Reply-To:Subject:Cc:To:From:Date:MIME-Version:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=WpOIYPFmZvX+Hf2mD/HENyssqGqbLDXFAm0gYQobp9o=; b=vw30vGqbyjYmaM3nKnskMxB/y+
        lw/jA0e/qsYeOLKWeB+M9pBy79w1bxVNFdGPnj1q7bDvJSGbFGE9g/6/s3WogeA7TOX1YXUyGg1x0
        pTlP11nDz1yB2tnWgOoUfZONTyL1unFVmhgDysLveBpkJ7DtJcohL8NqRL+bFBB7z/KUIt+Jg8S7L
        /g0VlHBwX0VvkVE6n9reRzOGt0hMoehxgxc6H3FCI/q3fovs9/b6nZbmWJpwad6zQ2KeRKuGadLzE
        9DCBQxYnOHWwYY4Gvcv0wEak1BiL7zsNN0+ZPOQ2niZSKo3HdGerEmF7aAZ8QPwNPdyuKP+AkoKqD
        y63NDfkw==;
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@misterjones.org>)
        id 1oZ7DJ-00AZwo-Lg;
        Fri, 16 Sep 2022 10:00:45 +0100
MIME-Version: 1.0
Date:   Fri, 16 Sep 2022 10:00:45 +0100
From:   Marc Zyngier <maz@misterjones.org>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>
Cc:     kvm-ppc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Fabiano Rosas <farosas@linux.ibm.com>,
        x86@kernel.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm-riscv@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>,
        linux-riscv@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH kernel] KVM: PPC: Make KVM_CAP_IRQFD_RESAMPLE platform
 dependent
In-Reply-To: <59dfb450-5a91-f27b-6edf-0adfa89729b7@ozlabs.ru>
References: <20220504074807.3616813-1-aik@ozlabs.ru>
 <0d4bb0fa-10c6-3f5a-34c8-293144b3fdbb@ozlabs.ru>
 <59dfb450-5a91-f27b-6edf-0adfa89729b7@ozlabs.ru>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <4884805567a0288ab1dbefb8aec819a2@misterjones.org>
X-Sender: maz@misterjones.org
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: aik@ozlabs.ru, kvm-ppc@vger.kernel.org, linux-s390@vger.kernel.org, kvm@vger.kernel.org, farosas@linux.ibm.com, x86@kernel.org, linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org, alex.williamson@redhat.com, kvm-riscv@lists.infradead.org, pbonzini@redhat.com, linux-riscv@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@misterjones.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022-09-13 13:50, Alexey Kardashevskiy wrote:
> Ping? It's been a while and probably got lost :-/
> 
> On 18/05/2022 16:27, Alexey Kardashevskiy wrote:
>> 
>> 
>> On 5/4/22 17:48, Alexey Kardashevskiy wrote:
>>> When introduced, IRQFD resampling worked on POWER8 with XICS. However
>>> KVM on POWER9 has never implemented it - the compatibility mode code
>>> ("XICS-on-XIVE") misses the kvm_notify_acked_irq() call and the 
>>> native
>>> XIVE mode does not handle INTx in KVM at all.
>>> 
>>> This moved the capability support advertising to platforms and stops
>>> advertising it on XIVE, i.e. POWER9 and later.
>>> 
>>> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
>>> ---
>>> 
>>> 
>>> Or I could move this one together with KVM_CAP_IRQFD. Thoughts?
>> 
>> 
>> Ping?
>> 
>>> 
>>> ---
>>>   arch/arm64/kvm/arm.c       | 3 +++
>>>   arch/mips/kvm/mips.c       | 3 +++
>>>   arch/powerpc/kvm/powerpc.c | 6 ++++++
>>>   arch/riscv/kvm/vm.c        | 3 +++
>>>   arch/s390/kvm/kvm-s390.c   | 3 +++
>>>   arch/x86/kvm/x86.c         | 3 +++
>>>   virt/kvm/kvm_main.c        | 1 -
>>>   7 files changed, 21 insertions(+), 1 deletion(-)
>>> 
>>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>>> index 523bc934fe2f..092f0614bae3 100644
>>> --- a/arch/arm64/kvm/arm.c
>>> +++ b/arch/arm64/kvm/arm.c
>>> @@ -210,6 +210,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, 
>>> long ext)
>>>       case KVM_CAP_SET_GUEST_DEBUG:
>>>       case KVM_CAP_VCPU_ATTRIBUTES:
>>>       case KVM_CAP_PTP_KVM:
>>> +#ifdef CONFIG_HAVE_KVM_IRQFD
>>> +    case KVM_CAP_IRQFD_RESAMPLE:
>>> +#endif

I don't mind moving this around, but I object to the #ifdefery.

This option is always selected on arm64, so it can safely be added
to the list without any condition.

Thanks,

         M.
-- 
Who you jivin' with that Cosmik Debris?
