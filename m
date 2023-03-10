Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB9F6B3284
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 01:05:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbjCJAF4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Mar 2023 19:05:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230256AbjCJAFx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Mar 2023 19:05:53 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15899E9F19
        for <kvm@vger.kernel.org>; Thu,  9 Mar 2023 16:05:53 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id cp12so2621882pfb.5
        for <kvm@vger.kernel.org>; Thu, 09 Mar 2023 16:05:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678406752;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9aSVopXmzdyMEhX6IIPLT4NxTdb+HTb9nQOMVZ44VEg=;
        b=Ofzc4gShxzQy/EDquHrDkXHpHnGhQdGhks0EOCbG18bsImerigPQgcVTNa0YYc7D3i
         1nbW0w06z3tw70LC03lbe7dY3lc3nnufHfkwmYeP5JXXCHT0cvn+tP+/K6/llcnBan7b
         WYD+Nn1q7j85ySxeaZQI0vUgfH5/do/UPnN73wafAn1meKBxNla7bRNwYQgD9fPbzuM1
         vXN47BufFaGnsrikj5yYTXBWYLcQvt/Rc7UFm0zI/UrSmDYeyQ2G28QOzzBh7cHY1n2Q
         QdnWAGhoTUKDAdrDMG6JwhW+bFZbBq3P9udyus9V++1B66n59IWS+46FzkYrMvYKaB9d
         myZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678406752;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9aSVopXmzdyMEhX6IIPLT4NxTdb+HTb9nQOMVZ44VEg=;
        b=TUvQNgLOMoRrltu7hvNLDbaCUKEHzysR+r4LaZYfNr5Y5JQvV5ydHMjHyY35HTrF93
         XgdOkorZq6i5lnCXei2YmZ6s63jCAIhZtNlIY/wy/XJOiNV9xAsCARD++orue3XAc+dR
         tCa5JevGQxzcd6xA7NX2Xok51x2RqeTYjO2dKYjsxKbkcZ/4hCePuMv7XyoPUiubCbZ7
         LZ41TZJPLx4j9fr4zQTfej3JoMOnI7BaIHo3JnDekvaw8wdGJ4n8xPsRR0An2vnX/T7/
         04urgTdzmjLl1ABj1K7G0VGkO0sgiJCPNIsHNWv8jSSZdIGi55fAmJpFOgeJKG3rRPFj
         vXJg==
X-Gm-Message-State: AO0yUKW1+D1waKZy5mw/u3aNO7h3NYIWWLEEb8cGjsIxc/Ie48RxzmDA
        aiBQQJGt4RGjo7JpW3T8adcMCQ==
X-Google-Smtp-Source: AK7set+Nh/kVuKaMFXwv+p31KUlgkHoOI5VenHcfch/NNQy7DrPSIoxl8IFHfqYLA0B1VKF86Tc5bA==
X-Received: by 2002:aa7:9798:0:b0:5a8:5424:d13b with SMTP id o24-20020aa79798000000b005a85424d13bmr20503972pfp.21.1678406752364;
        Thu, 09 Mar 2023 16:05:52 -0800 (PST)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id j13-20020aa7800d000000b005d22639b577sm129651pfi.165.2023.03.09.16.05.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 16:05:51 -0800 (PST)
Date:   Thu, 9 Mar 2023 16:05:47 -0800
From:   David Matlack <dmatlack@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     Zhi Wang <zhi.wang.linux@gmail.com>, seanjc@google.com,
        pbonzini@redhat.com, bgardon@google.com, jmattson@google.com,
        mizhang@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch v4 05/18] KVM: x86/mmu: Add split_shadow_page_cache pages
 to global count of MMU cache pages
Message-ID: <ZAp0W9eH6XbWhiap@google.com>
References: <20230306224127.1689967-1-vipinsh@google.com>
 <20230306224127.1689967-6-vipinsh@google.com>
 <20230309175849.0000565e@gmail.com>
 <CAHVum0fhU2PAQEerG5t92R1ropoh1-ML4Yv1CzwGThRtbbvWHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHVum0fhU2PAQEerG5t92R1ropoh1-ML4Yv1CzwGThRtbbvWHg@mail.gmail.com>
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

On Thu, Mar 09, 2023 at 11:59:00AM -0800, Vipin Sharma wrote:
> On Thu, Mar 9, 2023 at 7:58 AM Zhi Wang <zhi.wang.linux@gmail.com> wrote:
> >
> > On Mon,  6 Mar 2023 14:41:14 -0800
> > Vipin Sharma <vipinsh@google.com> wrote:
> >
> > > Add pages in split_shadow_page_cache to the global counter
> > > kvm_total_unused_cached_pages. These pages will be freed by MMU shrinker
> > > in future commit.
> > >
> > > Signed-off-by: Vipin Sharma <vipinsh@google.com>
> > > ---
> > >  arch/x86/kvm/mmu/mmu.c | 7 +++++--
> > >  1 file changed, 5 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index df8dcb7e5de7..0ebb8a2eaf47 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -6149,7 +6149,9 @@ static void mmu_free_vm_memory_caches(struct kvm *kvm)
> > >  {
> > >       kvm_mmu_free_memory_cache(&kvm->arch.split_desc_cache);
> > >       kvm_mmu_free_memory_cache(&kvm->arch.split_page_header_cache);
> > > -     kvm_mmu_free_memory_cache(&kvm->arch.split_shadow_page_cache);
> > > +     mutex_lock(&kvm->slots_lock);
> > > +     mmu_free_sp_memory_cache(&kvm->arch.split_shadow_page_cache);
> > > +     mutex_unlock(&kvm->slots_lock);
> >
> > Taking the lock of the calling path in the layer of cache topping/free layer
> > seems off.
> >
> > My vote goes to have a lock for each cache and take the lock of the cache when
> > topping/free the cache. It is more self-contained and architecturally nice.
> >
> 
> Yeah, this can be one way. However, in future patches when I am adding
> per NUMA node cache, it will add up a lot of locks for the same code
> path before a topup. In split huge page case we know what NUMA node we
> need to allocate from so we can fine tune which lock to take but  in
> fault path code we don't know what NUMA node the page will be coming
> from so we need to topup all of the NUMA caches. Having a single lock
> simplifies code a little bit.
> 
> I agree with you on being more self-contained. I will wait for others
> to also chime in on this and go from there.

As a general rule, please only added locking when it's needed. Adding
the lock in this commit is just confusing.

But that aside, I don't think acquiring the slots lock is even needed in
this commit.  mmu_free_vm_memory_caches() is never called while the the
VM is on vm_list. i.e. This can never race with the shrinker.

If you want to be paranoid you can add a WARN to ensure that stays true
going forward:

  /* ... comment ... */
  WARN_ON_ONCE(!list_empty(&kvm->vm_list));
