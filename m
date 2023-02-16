Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6964D699F0B
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 22:38:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbjBPVio (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 16:38:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjBPVim (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 16:38:42 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BAAD37B7D
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 13:38:41 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id jp14-20020a17090ae44e00b0022a03158ec6so1551604pjb.9
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 13:38:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qISKjtUmN2cEwBwW4xMI8exQ5WKRK627PpvklIdcOFI=;
        b=sfgAZ70dHjZIDt2LlS8uAAFtM3WGXWas6Swe1KZGm/7LwDUPrvMw5IjA6K+Yl5nXbx
         l/JB29YObSepeKdZS8KpaqLUbqar3WIXxLvjBNSO96gvv7lCvdc/UTNctCXfluTUiMYz
         Ze4SCZJXt0odf2R2vwiDjLSl0J/bAg1QM5eY7RDp4vkIDfBHXziFmXKfYb5dK3phQa2S
         mM/putTXr102FYkQcAnBu0KotBNtkF0xWASreyKGWqf+uTodfTKsBUiLeINHWNXWl6Nb
         BqvMUPpXzNV4b4HthNEdF7E94IrsUXUBoDepSs5mnkZgW50d/oK8LHUoYtZfL3CUK9pm
         M21w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qISKjtUmN2cEwBwW4xMI8exQ5WKRK627PpvklIdcOFI=;
        b=yU7+/QLfFUw0KyTFu4AZm5RPsxd1KTUuWjIS74/VDCa8YDk0hjuYDZnMEV4n/IMeLd
         LDVnCFvriF7grr5OMJpfjuMt57Wu38G87Zy4b/JNIblgfjpIwLlhPP2imepBCrwutlty
         3Lk00cdleXIN8xqDJS62fIzjSju6qqI8hV9yw1lyyzBY/mO7h82L8YAPK+Lsf9yeWzLy
         gHY+SMy05oi4J/Gb3wvLsSW5V2N+mo2aulXcPW3rQigdG1ql4B0D8ur0y54K5QO77Opz
         feg4d0syEohwlQa+D18B1jdqum+GgzHCF+JVOHnfNbluMf1Vw+GZh6zD8jL78xItRKww
         UdVA==
X-Gm-Message-State: AO0yUKXalFlo+vyjKaKzUXbm58tQuZnrzntm1lmojvbZ+xi2dsg3FFVD
        eabH822g4S6SVcHmNgSr2OqI7PSms4M=
X-Google-Smtp-Source: AK7set8GdCvk4jCPWiRNB0CEkjUTMbp8EH1MVnNVK571C5L6Vx7G9LuGyMCqRh3cyi5QWEywqdmID/9uzYs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:f508:0:b0:4fb:a28e:fa50 with SMTP id
 w8-20020a63f508000000b004fba28efa50mr1086612pgh.8.1676583520915; Thu, 16 Feb
 2023 13:38:40 -0800 (PST)
Date:   Thu, 16 Feb 2023 13:38:39 -0800
In-Reply-To: <CAF7b7mr3iDBYWvX+ZPA1JeZgezX-BDo8VArwnjuzHUeWJmO32Q@mail.gmail.com>
Mime-Version: 1.0
References: <20230215011614.725983-1-amoorthy@google.com> <20230215011614.725983-6-amoorthy@google.com>
 <87mt5fz5g6.wl-maz@kernel.org> <CAF7b7mr3iDBYWvX+ZPA1JeZgezX-BDo8VArwnjuzHUeWJmO32Q@mail.gmail.com>
Message-ID: <Y+6iX6a22+GEuH1b@google.com>
Subject: Re: [PATCH 5/8] kvm: Add cap/kvm_run field for memory fault exits
From:   Sean Christopherson <seanjc@google.com>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        James Houghton <jthoughton@google.com>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, peterx@redhat.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 16, 2023, Anish Moorthy wrote:
> On Wed, Feb 15, 2023 at 12:59 AM Oliver Upton <oliver.upton@linux.dev> wrote:
> > > > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > > > index 109b18e2789c4..9352e7f8480fb 100644
> > > > --- a/include/linux/kvm_host.h
> > > > +++ b/include/linux/kvm_host.h
> > > > @@ -801,6 +801,9 @@ struct kvm {
> > > >     bool vm_bugged;
> > > >     bool vm_dead;
> > > >
> > > > +   rwlock_t mem_fault_nowait_lock;
> > > > +   bool mem_fault_nowait;
> > >
> > > A full-fat rwlock to protect a single bool? What benefits do you
> > > expect from a rwlock? Why is it preferable to an atomic access, or a
> > > simple bitop?
> >
> > There's no need to have any kind off dedicated atomicity.  The only readers are
> > in vCPU context, just disallow KVM_CAP_MEM_FAULT_NOWAIT after vCPUs are created.
> 
> I think we do need atomicity here.

Atomicity, yes.  Mutually exclusivity, no.  AFAICT, nothing will break if userspace
has multiple in-flight calls to toggled the flag.  And if we do want to guarantee
there's only one writer, then kvm->lock or kvm->slots_lock will suffice.

> When KVM_CAP_MEM_FAULT_NOWAIT is enabled async page faults are essentially
> disabled: so userspace will likely want to disable the cap at some point
> (such as the end of live migration post-copy).

Ah, this is a dynamic thing and not a set-and-forget thing.

> Since we want to support this without having to pause vCPUs, there's an
> atomicity requirement.

Ensuring that vCPUs "see" the new value and not corrupting memory are two very
different things.  Making the flag an atomic, wrapping with a rwlock, etc... do
nothing to ensure vCPUs observe the new value.  And for non-crazy usage of bools,
they're not even necessary to avoid memory corruption, e.g. the result of concurrent
writes to a bool is non-deterministic, but so is the order of two tasks contending
for a lock, so it's a moot point.

I think what you really want to achieve is that vCPUs observe the NOWAIT flag
before KVM returns to userspace.  There are a variety of ways to make that happen,
but since this all about accessing guest memory, the simplest is likely to
"protect" the flag with kvm->srcu, i.e. require SRCU be held by readers and then
do a synchronize_srcu() to ensure all vCPUs have picked up the new value.

Speaking of SRCU (which protect memslots), why not make this a memslot flag?  If
the goal is to be able to turn the behavior on/off dynamically, wouldn't it be
beneficial to turn off the NOWAIT behavior when a memslot is fully transfered?

A memslot flag would likely be simpler to implement as it would piggyback all of
the existing infrastructure to handle memslot updates.
