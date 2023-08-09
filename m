Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E360877628F
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 16:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233394AbjHIOds (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 10:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233390AbjHIOdr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 10:33:47 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E7F71FCC
        for <kvm@vger.kernel.org>; Wed,  9 Aug 2023 07:33:47 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1bbb34b0abaso88665495ad.1
        for <kvm@vger.kernel.org>; Wed, 09 Aug 2023 07:33:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691591626; x=1692196426;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jZmbaKKKm3CHbI/QJJpHHXp/km2ij6zusR5ThdOY8EE=;
        b=DUi7yCKZeHIQOn9Fthn5OjHUhJCT5ipdMgkg2xVzFQPT+Dno1JgMSzuaGqJnec7h2e
         k+Z7kpr+D6ku5ye4Y6Eo7mDbKoNBW9n6UpATdPMSt2qu7OS+JRrwoR8Bnl03vE6oqRed
         IdDFcMCZspBAGdgCY0gFnYb8aKK0+wCIjcoCRQhWqa5loj4vewG+g6iwkycBJQSMkLjj
         F3MgG8WkunnGIX9Tntelx5mF9rV8NItN1nwrgI3NHer6l3ddA7FkQSXwfAflMybwce6F
         EdaQfPWL6IZPj1YAXH1asOjn4XATl8RQIyRiPv89SVJFee5ERZGSewxIkqk4Plzps/v2
         kuwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691591626; x=1692196426;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jZmbaKKKm3CHbI/QJJpHHXp/km2ij6zusR5ThdOY8EE=;
        b=b24lkcFNsoYdgEKSXewpTaPr2lKxrYrV92y9JaGLyQQOt/1XJlk4QF6gKW8std07Gj
         1tBPv3hfHEwIYHORmdocLMDE/uZz58yL9Lmf27PVvrDGYxNctIs5kaJPV3b4+JJoX//u
         uH5kvdFb0onUtr4bKe66STPmx+VGUR+X0qyoqiyALBjcI1//STWsNZPIyG9OicBvmFPW
         a0QEt6Ntawfj0h3MO7Qwz0gaJ6+N4crtFUmIlRw4o5NomzNhk68tEWGSU+jibA7CIqbU
         eYWdxA+HUkoJg71m5tx6JSUhrFXG1k2AQ0vwCHV6h/ZLHQw0m+EjhFdjmQgOka1VZzGt
         kevg==
X-Gm-Message-State: AOJu0YzOIduEfKl8mqXk7xXvrthQgwcQURoOT/p9/ZZyMJb17FaitIdW
        BC1lPBwywzk/Z6x905qisK9xeaIr9xk=
X-Google-Smtp-Source: AGHT+IFTcanp2PgeUlsBe6acnCorL6mrsLeGVUyMlUhGhob9bR6LKZlVBrq9Y6Q4E1OFc7EkekhTTOPkt/g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e542:b0:1b8:5541:9d3e with SMTP id
 n2-20020a170902e54200b001b855419d3emr300692plf.6.1691591626649; Wed, 09 Aug
 2023 07:33:46 -0700 (PDT)
Date:   Wed, 9 Aug 2023 07:33:45 -0700
In-Reply-To: <ZNLlseYag5DniUg3@yzhao56-desk.sh.intel.com>
Mime-Version: 1.0
References: <20221223005739.1295925-1-seanjc@google.com> <20221223005739.1295925-20-seanjc@google.com>
 <5581418b-2e1c-6011-f0a4-580df7e00b44@gmail.com> <ZNEni2XZuwiPgqaC@google.com>
 <ZNLlseYag5DniUg3@yzhao56-desk.sh.intel.com>
Message-ID: <ZNOjyf2OHQZYfMEJ@google.com>
Subject: Re: [PATCH 19/27] KVM: x86/mmu: Use page-track notifiers iff there
 are external users
From:   Sean Christopherson <seanjc@google.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     Like Xu <like.xu.linux@gmail.com>, kvm@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Ben Gardon <bgardon@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        intel-gvt-dev@lists.freedesktop.org,
        Zhi Wang <zhi.a.wang@intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 09, 2023, Yan Zhao wrote:
> On Mon, Aug 07, 2023 at 10:19:07AM -0700, Sean Christopherson wrote:
> > On Mon, Aug 07, 2023, Like Xu wrote:
> > > On 23/12/2022 8:57 am, Sean Christopherson wrote:
> > > > +static inline void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa,
> > > > +					const u8 *new, int bytes)
> > > > +{
> > > > +	__kvm_page_track_write(vcpu, gpa, new, bytes);
> > > > +
> > > > +	kvm_mmu_track_write(vcpu, gpa, new, bytes);
> > > > +}
> > > 
> > > The kvm_mmu_track_write() is only used for x86, where the incoming parameter
> > > "u8 *new" has not been required since 0e0fee5c539b ("kvm: mmu: Fix race in
> > > emulated page table writes"), please help confirm if it's still needed ? Thanks.
> > > A minor clean up is proposed.
> > 
> > Hmm, unless I'm misreading things, KVMGT ultimately doesn't consume @new either.
> > So I think we can remove @new from kvm_page_track_write() entirely.
> Sorry for the late reply.
> Yes, KVMGT does not consume @new and it reads the guest PTE again in the
> page track write handler.
> 
> But I have a couple of questions related to the memtioned commit as
> below:
> 
> (1) If "re-reading the current value of the guest PTE after the MMU lock has
> been acquired", then should KVMGT also acquire the MMU lock too?

No.  If applicable, KVMGT should read the new/current value after acquiring
whatever lock protects the generation (or update) of the shadow entries.  I
suspect KVMGT already does this, but I don't have time to confirm that at this
exact memory.

The race that was fixed in KVM was:

  vCPU0         vCPU1   
  write X
                 write Y
                 sync SPTE w/ Y
  sync SPTE w/ X

Reading the value after acquiring mmu_lock ensures that both vCPUs will see whatever
value "loses" the race, i.e. whatever written value is processed second ('Y' in the
above sequence).

> If so, could we move the MMU lock and unlock into kvm_page_track_write()
> as it's common.
> 
> (2) Even if KVMGT consumes @new,
> will kvm_page_track_write() be called for once or twice if there are two
> concurent emulated write?

Twice, kvm_page_track_write() is wired up directly to the emulation of the write,
i.e. there is no batching.
