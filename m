Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC825BEA7B
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 17:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbiITPrG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 11:47:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbiITPrF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 11:47:05 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4672961B1A
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 08:47:04 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id l10so2779415plb.10
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 08:47:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date;
        bh=cfeYRDbG1IwqxDDwCZ/PUhlAPjZzrLd37QWr6A2RCdE=;
        b=qb+EI07Lm41KNZTnKWMqAKU2cZUOLNd8Pe+Hofo4HsKJA/i0Se7uhmq/j91oNyb/St
         9yiN6awGrXDUxbCMQk53q8eeACZ3cCW/smwKpB0CX06xhQGa1ySRaL/WZLjWSpU1qxgT
         VaCDlvjLpyCByRXDwSIFixOa6/f7g6htEG49xwX1NCG87V8UYN3c0JKrlURIRBGt0lh6
         6HJoF8XxG6Nx5UIsL1MpW8VAZm6peenajwu5hghDhmcQ1gcEcdwX4l60GgqKWZlLEsnv
         Yy4H0zhEVMVC6n5wx7VxpX9bD16I7A1XlgY329qap8SlPUc3E5zq0Y667AhASHe3mt1b
         I8Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=cfeYRDbG1IwqxDDwCZ/PUhlAPjZzrLd37QWr6A2RCdE=;
        b=5VYcqA2KpNmAF4c1kv05iYpogS/teQBdhsjKIza+qnkMPJD0kegwQx9l1MwRwIkmMD
         mwZpoZ9AnD86Ce4uRzJu+LjTbtHwY90qJsHs7M7AVpTuLmMIcAZAZbpbj2ppchaFIEh+
         4ujVERxYr+6O/1+8XR/Bg2VLONJAZ0FRnVA1QWn4xa6RqLPt3szYHPXX9fJEU6f4NWNA
         Bmz/36s/mxv04DSBD6JTASxhk0970UYD4eEt6SxwupfBNzR5p+Jo0aBp0QzAQdHC+kpu
         Yaip8Sjkll/dGPHqchhpcXd48EcAPKOVqUz3xxXRPfgAt6MRdagB7pytqCSOL87LQZcn
         smlA==
X-Gm-Message-State: ACrzQf3wad6IRW3EaQOoLy22tsHY7KCTyJxm0EQ9ZK//MPP8nU4jE7sN
        1jOsLqEYQqJWCxp1668YAnMHkA==
X-Google-Smtp-Source: AMsMyM7nHUW6LZIxqYazx0vmROaMh9fzefg2755WV6Haotjq/IEXF/lVT1xdW+lJJaqZPHS7kUvV2g==
X-Received: by 2002:a17:902:b20a:b0:178:6f5b:f903 with SMTP id t10-20020a170902b20a00b001786f5bf903mr320666plr.39.1663688823605;
        Tue, 20 Sep 2022 08:47:03 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id h16-20020aa796d0000000b00540d75197f2sm32072pfq.143.2022.09.20.08.47.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 08:47:03 -0700 (PDT)
Date:   Tue, 20 Sep 2022 15:46:58 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Subject: Re: [PATCH v2 04/23] KVM: x86: Inhibit AVIC SPTEs if any vCPU
 enables x2APIC
Message-ID: <Yyngcg3ainoD0fNc@google.com>
References: <20220903002254.2411750-1-seanjc@google.com>
 <20220903002254.2411750-5-seanjc@google.com>
 <8a24c36efebfa4fb302587a74e3bc1e088e17be8.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8a24c36efebfa4fb302587a74e3bc1e088e17be8.camel@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 20, 2022, Maxim Levitsky wrote:
> On Sat, 2022-09-03 at 00:22 +0000, Sean Christopherson wrote:
> > Reintroduce APICV_INHIBIT_REASON_X2APIC as a "partial" inhibit for AMD
> > to fix a bug where the APIC access page is visible to vCPUs that have
> > x2APIC enabled, i.e. shouldn't be able to "see" the xAPIC MMIO region.
> > 
> > On AMD, due to its "hybrid" mode where AVIC is enabled when x2APIC is
> > enabled even without x2AVIC support, the bug occurs any time AVIC is
> > enabled as x2APIC is fully emulated by KVM.  I.e. hardware isn't aware
> > that the guest is operating in x2APIC mode.
> > 
> > Opportunistically drop the "can" while updating avic_activate_vmcb()'s
> > comment, i.e. to state that KVM _does_ support the hybrid mode.  Move
> > the "Note:" down a line to conform to preferred kernel/KVM multi-line
> > comment style.
> > 
> > Leave Intel as-is for now to avoid a subtle performance regression, even
> > though Intel likely suffers from the same bug.  On Intel, in theory the
> > bug rears its head only when vCPUs share host page tables (extremely
> > likely) and x2APIC enabling is not consistent within the guest, i.e. if
> > some vCPUs have x2APIC enabled and other does do not (unlikely to occur
> > except in certain situations, e.g. bringing up APs).
> 
> Are you sure about this?

Ah, no.  The key on Intel is the separate VMCS control for virtualizing xAPIC
accesses.  As you note below, KVM will provide memory semantics, which is technically
wrong.

> This is what I am thinking will happen, I might be wrong but I am not sure:

...

> 3. guest accesses the 0xfee00xxx, assuming APICv/x2avic, the hardware won't redirect
> the access to apic backing page, but will instead just use that SPTE and let the guest
> read/write the private page that we mapped in the range, which is wrong.
> 
> Am I missing something?

No, I don't believe so.  I'm still hesitant to add the effetive inhibit to Intel,
though that's probably just pure paranoia at this point.  Probably makes sense to
just do it and verify that x2APIC virtualization still works.

> Also I somewhat doen't like the partial inhibit - it is to some extent
> misleading.  I don't have a very strong option on using the inhibit, but its
> meaning just feels a bit overloaded.
> 
> So why not to do it this way:
> 
> 1. zap the SPTE always when switching apic mode (e.g move the code in 
> __kvm_set_or_clear_apicv_inhibit to a common funtion)
> 
> 2. make kvm_faultin_pfn check a flag 'any vcpu enabled x2apic' and refuse
> to re-install that spte?
> 
> Something like that (only compile tested, and likely misses memory barriers):

Actually, since this is "sticky", we can go even further and just delete the
memslot.  Deleting the memslot is slightly complicated by the need to drop SRCU
if kvm_lapic_set_base() enables x2APIC during KVM_RUN, but that's enough enough
to handled by putting the disabling logic in vcpu_run() and using KVM_REQ_UNBLOCK
to ensure the memslot is deleted before the vCPU re-enters the guest.

Testing now...
