Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92A8F7AF57C
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 22:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235920AbjIZUpf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 16:45:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235740AbjIZUpd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 16:45:33 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB2EEE4
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 13:45:26 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d814634fe4bso15020055276.1
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 13:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695761126; x=1696365926; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ROv2x1zWSpDfcX0AQ/L6efzTyiFS98bYosPPnaeL0Gk=;
        b=I5frxT98K5JXkDGNAEL+Qomv4HSowKMhLVMni+++OYuzKtNipdwcIgt2FsF2mPMRcd
         ll27vbEb7vMzRtA/Bx76QXiLmUDwVEIh670rhEib2geC6CN3KQq8cuyACTRcE+tnMMVK
         VuPC3WbIYixTgH6Dz/v7Hl2MAheqv9cYS/DkGzclNmwXZ3MZ4pDea5ScxO8vp5pTxd4U
         46TSIpITqgR7meq83Eh1mG1TwZb8VlN321I7G7bVG0eT+aeee8PpC0tt0CBgMON2uMFQ
         R9VzmNq9o/ktnIY/BRsCQPGh3vomyEI2iWrH/fozMzTrsVoOwEs65YGj0RZZOlghFEk2
         3d6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695761126; x=1696365926;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ROv2x1zWSpDfcX0AQ/L6efzTyiFS98bYosPPnaeL0Gk=;
        b=jt0LKyU9F8AHrk3SolRLrLnkm0kwTrHVgh/Zf9hyQ4xuZcu/9ytDw75npYBywdwx2M
         LEgIpwSiFKH+tDpxTFqY/4E/KQREU+E8euaITquSYc3gLmuCkyOqwEjZE6j+3YJ54QpY
         fnYY9uabd/YcENx+7f6tAyaaX4nAqg41wKkw59Ji3hKIy01rWNY5cz6pUrlwtde7NScS
         mW4b45zQI/lLl7u6c2mpv2x3fZ7GVeRUl5LUz3I09Sec7OWsT3XERqWVtSPo5605hUCN
         8qarAdGP7j/hdaiaXy7LU/nHyj358vl3H6LTeC+UOF406Vu+nwVG5LO1O7IXqyu5SiZe
         MTBQ==
X-Gm-Message-State: AOJu0Yyz0IvTzM0SzNYiF8lqW+/mCEr85IeArz1sMaCR2CmFlhOTn7VN
        nv1LsyXqWew9vDBgKC9bbneY+KvyLm0=
X-Google-Smtp-Source: AGHT+IHEKMxK4ayOPeX079O2Pm0dA84rNJovPXxPtJHHeTxCAV3mGCIZvXoxDJwbU4+MRDDDE4x9JeA1LJ0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ced0:0:b0:d80:eb4:9ca with SMTP id
 x199-20020a25ced0000000b00d800eb409camr429ybe.0.1695761125912; Tue, 26 Sep
 2023 13:45:25 -0700 (PDT)
Date:   Tue, 26 Sep 2023 13:45:24 -0700
In-Reply-To: <ef6a0ebf-cb5f-0bb0-f453-0e9e0fdc87d5@redhat.com>
Mime-Version: 1.0
References: <20230924124410.897646-1-mlevitsk@redhat.com> <ZRIf1OPjKV66Y17/@google.com>
 <abd13162f106c5ce86c211fc9d32d901ab34500b.camel@redhat.com> <ef6a0ebf-cb5f-0bb0-f453-0e9e0fdc87d5@redhat.com>
Message-ID: <ZRNC5IKXDq1yv0v3@google.com>
Subject: Re: [PATCH v2 0/4] KVM: x86: tracepoint updates
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>
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

On Tue, Sep 26, 2023, Paolo Bonzini wrote:
> On 9/26/23 10:28, Maxim Levitsky wrote:
> > > trace_kvm_exit is good example, where despite all of the information that is captured
> > > by KVM, it's borderline worthless for CPUID and MSR exits because their interesting
> > > information is held in registers and not captured in the VMCS or VMCB.
> > > 
> > > There are some on BTF type info issues that I've encountered, but I suspect that's
> > > as much a PEBKAC problem as anything.
> > > 
> > While eBPF has its use cases, none of the extra tracepoints were added solely because of
> > the monitoring tool and I do understand that tracepoints are a limited resource.
> > 
> > Each added tracepoint/info was added only when it was also found to be useful for regular
> > kvm tracing.
> 
> I am not sure about _all_ of them, but I agree with both of you.
> 
> On one hand, it would be pretty cool to have eBPF access to registers. On
> the other hand, the specific info you're adding is generic and I think there
> are only a couple exceptions where I am not sure it belongs in the generic
> KVM tracepoints.

I'm not saying this information isn't useful, *sometimes*.  What I'm saying is
that I don't think it's sustainable/maintainble to keep expanding KVM's tracepoints.
E.g. why trace req_immediate_exit and not mmu_invalidate_seq[*]?

It's practically impossible to predict exactly what information will be useful in
the field.  And for something like kvmon, IMO the onus is on userspace to do the
heavy lifting.

Rather than hardcode mounds of information in KVM's tracepoints, I think we should
refactor KVM to make it as easy as possible to use BPF to piggyback tracepoints
and get at data that *might* be interesting, and then add a variety of BPF programs
(e.g. using bpftrace for simplicity) somewhere in tools/ to provide equivalent
functionality to select existing tracepoints.

E.g. if we rework kvm_vcpu to place "struct kvm_vcpu_arch arch" at offset '0',
then we get at all the GPRs and pseudo-registers by hardcoding offsets into the
struct, i.e. without needing BTF type info.  More elaborate trace programs would
likely need BTF, or maybe some clever shenanigans, but it seems very doable.

[*] https://lore.kernel.org/all/ZOaUdP46f8XjQvio@google.com
