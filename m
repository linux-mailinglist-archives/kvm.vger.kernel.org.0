Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEEBE794614
	for <lists+kvm@lfdr.de>; Thu,  7 Sep 2023 00:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245018AbjIFWR5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Sep 2023 18:17:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244456AbjIFWRy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Sep 2023 18:17:54 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96DEB19BE
        for <kvm@vger.kernel.org>; Wed,  6 Sep 2023 15:17:46 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d7493fcd829so324837276.3
        for <kvm@vger.kernel.org>; Wed, 06 Sep 2023 15:17:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1694038666; x=1694643466; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KKvPqWseuv2Z5FP9TOZwPLsesqc5qAD7arxya6GFFMU=;
        b=Kkyx/5lHeBi6sj2K2wHBZl3q2LcqQDBGyx4FGTKauIWWOV2zfmSnBXInSqBWSX5wFv
         SVmgqEbBnCkpftG8pmeaddmKEMozH6ZtlqyVICpysLTYBBjnjD/A8XW7Rq577Vpr16W1
         eO5n02rtzYgmGBczL0JMUYdSoVjUhzBR+LfqvcDCypAIVDbvPos+8A44jaqIqC7eykFW
         tbrW6ZWQupDilJeCCwHrv2ewiBTf57+er/OJOjeRiY4hvo6ALMDVdbIihzehYsEp7kGz
         fnoXzu8UmC9YbCKkkyzD7aZbIx6PulqrXUtC3Wfb0Jb8831N9Goz0aRq7JUpjT4H8Gnf
         nNrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694038666; x=1694643466;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KKvPqWseuv2Z5FP9TOZwPLsesqc5qAD7arxya6GFFMU=;
        b=HtbRXv/AAyg8FZHGWXsxqFdWslDTJbEIi2WEyD9N2tbhpaEWjR07IMljeDrLlPA6F+
         QoKOnRYWVKVHUSskVO16OHn0ZXAVc1Tw4IvGuLkN6DPYSJ4a4YucR0fHCwy4LP3nKGx7
         yrw5+MNBDN/nvvzTge0wxoQJCyHNAQFmpRnj9C1MCIU33yY/DFPNAENaNGfyuWqPM60c
         R4JKp7AufGfEScDpKzy6LGm7Ulc1NfyzXQFOhaWuRbFOtuI06qjHg1DPmvZQprTNiiPY
         +ywikHUe42eOCZLX8Z95LqnAzVJk9YWunEm5KsbyycEBsofvyK3MZUrhi8zxiIgP+KsQ
         3sFQ==
X-Gm-Message-State: AOJu0YyZWsB/ef0hsp+18TkLOmUZbimg1I9ruMoggVzGzqAtKR899SvR
        D8USA+C8fEz53UpuoauiPp2E6QlbBM8=
X-Google-Smtp-Source: AGHT+IFHjyUphxJXs/NeiVsgwQMFXJdUhqtKuGV8ycKvNZeqIKAbSO0uAbRhh4SxlzfR4iyxcANxwd/s5aY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:b088:0:b0:d77:f7c3:37db with SMTP id
 f8-20020a25b088000000b00d77f7c337dbmr181313ybj.8.1694038665921; Wed, 06 Sep
 2023 15:17:45 -0700 (PDT)
Date:   Wed, 6 Sep 2023 15:17:44 -0700
In-Reply-To: <ZPgJDacP1LeO084Z@linux.bj.intel.com>
Mime-Version: 1.0
References: <20230904013555.725413-1-tao1.su@linux.intel.com>
 <20230904013555.725413-3-tao1.su@linux.intel.com> <ZPezyAyVbdZSqhzk@google.com>
 <ZPgJDacP1LeO084Z@linux.bj.intel.com>
Message-ID: <ZPj6iF0Q7iynn62p@google.com>
Subject: Re: [PATCH 2/2] KVM: x86: Clear X2APIC_ICR_UNUSED_12 after APIC-write VM-exit
From:   Sean Christopherson <seanjc@google.com>
To:     Tao Su <tao1.su@linux.intel.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, chao.gao@intel.com,
        guang.zeng@intel.com, yi1.lai@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 06, 2023, Tao Su wrote:
> On Tue, Sep 05, 2023 at 04:03:36PM -0700, Sean Christopherson wrote:
> > +Suravee
> > 
> > On Mon, Sep 04, 2023, Tao Su wrote:
> > > When IPI virtualization is enabled, a WARN is triggered if bit12 of ICR
> > > MSR is set after APIC-write VM-exit. The reason is kvm_apic_send_ipi()
> > > thinks the APIC_ICR_BUSY bit should be cleared because KVM has no delay,
> > > but kvm_apic_write_nodecode() doesn't clear the APIC_ICR_BUSY bit.
> > > 
> > > Since bit12 of ICR is no longer BUSY bit but UNUSED bit in x2APIC mode,
> > > and SDM has no detail about how hardware will handle the UNUSED bit12
> > > set, we tested on Intel CPU (SRF/GNR) with IPI virtualization and found
> > > the UNUSED bit12 was also cleared by hardware without #GP. Therefore,
> > > the clearing of bit12 should be still kept being consistent with the
> > > hardware behavior.
> > 
> > I'm confused.  If hardware clears the bit, then why is it set in the vAPIC page
> > after a trap-like APIC-write VM-Exit?  In other words, how is this not a ucode
> > or hardware bug?
> 
> Sorry, I didn't describe it clearly.
> 
> On bare-metal, bit12 of ICR MSR will be cleared after setting this bit.
> 
> If bit12 is set in guest, the bit is not cleared in the vAPIC page after APIC-write
> VM-Exit. So whether to clear bit12 in vAPIC page needs to be considered.

I got that, the behavior just seems odd to me.  And I'm grumpy that Intel punted
the problem to software.  But the SDM specifically calls out that this is the
correct behavior :-/

Specifically, in the context of IPI virtualization:

  If ECX contains 830H, a general-protection fault occurs if any of bits 31:20,
  17:16, or 13 of EAX is non-zero.

and

  If ECX contains 830H, the processor then checks the value of VICR to determine
  whether the following are all true:

  Bits 19:18 (destination shorthand) are 00B (no shorthand).
  Bit 15 (trigger mode) is 0 (edge).
  Bit 12 (unused) is 0.
  Bit 11 (destination mode) is 0 (physical).
  Bits 10:8 (delivery mode) are 000B (fixed).
  
  If all of the items above are true, the processor performs IPI virtualization
  using the 8-bit vector in byte 0 of VICR and the 32-bit APIC ID in VICR[63:32]
  (see Section 30.1.6). Otherwise, the logical processor causes an APIC-write VM
  exit (see Section 30.4.3.3).  If ECX contains 830H, the processor then checks
  the value of VICR to determine whether the following are all true:

I.e. the "unused" busy bit must be zero.  The part that makes me grumpy is that
hardware does check that other reserved bits are actually zero:

  If special processing applies, no general-protection exception is produced due
  to the fact that the local APIC is in xAPIC mode. However, WRMSR does perform
  the normal reserved-bit checking:
   - If ECX contains 808H or 83FH, a general-protection fault occurs if either EDX or EAX[31:8] is non-zero.
   - If ECX contains 80BH, a general-protection fault occurs if either EDX or EAX is non-zero.
   - If ECX contains 830H, a general-protection fault occurs if any of bits 31:20, 17:16, or 13 of EAX is non-zero.

Which implies that the hardware *does* enforce all the other reserved bits, but
punted bit 12 to the hypervisor :-(

That said, I think we have an "out".  Under the x2APIC section, regarding ICR,
the SDM also says:

  It remains readable only to aid in debugging; however, software should not
  assume the value returned by reading the ICR is the last written value.

I.e. KVM basically has free reign to do whatever it wants, so long as it doesn't
confuse userspace or break KVM's ABI.  As much as I want to say "do nothing",
clearing bit 12 so that it reads back as '0' is the safer approach.  Just please
don't add a new #define for, it's far easier to understand what's going on if we
just use APIC_ICR_BUSY, especially given that I highly doubt the bit will actually
be repurposed for something new.

FWIW, I also suspect that hardware isn't clearing the busy bit per se, I suspect
that hardware simply reads the bit as zero.

Side topic, unless I'm blind, KVM is missing the reserved bits #GP checks for ICR
bits bits 31:20, 17:16, and 13.
