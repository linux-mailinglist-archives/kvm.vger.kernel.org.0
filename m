Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDD4658F344
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 21:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233111AbiHJTio (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 15:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232870AbiHJTin (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 15:38:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2D4517A53D
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 12:38:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660160320;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qLEsjHSARBGbFLDoXqq+JW70Tie/allHI9QzL0wkk40=;
        b=X0SybXjh9H/xYLkH+aGXhdWYwedJhNfSfG0PkAiKNDg9rjxZvauruusC3Tm12loN7+I58u
        +55QhlVJwRVZhmVk9AApSMkf0B1YiLskLpPUH7e3INBoAk5NH4srAGp+dIHIFHjBaXEd67
        daYr8IljSC5w10TazyoDCSA8hknPMWs=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-84-Ig5QL8jbMpyNGbCjQT9KIA-1; Wed, 10 Aug 2022 15:38:39 -0400
X-MC-Unique: Ig5QL8jbMpyNGbCjQT9KIA-1
Received: by mail-il1-f199.google.com with SMTP id 15-20020a056e0220cf00b002e1d24dcb7cso805831ilq.0
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 12:38:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=qLEsjHSARBGbFLDoXqq+JW70Tie/allHI9QzL0wkk40=;
        b=V3ZUPzTwVBV47+CumQNS74MUwm+zI0Ns4xRx4fdUcBNvtb6QxNH922Nd81lZOS/kDr
         Qyn7rZe8gBNN/fVtbso4TrVakpaZM1nv8WHpPTQZOFU8sh6LZXR7i1uUk1G/Vf0wDrd/
         +oN1TrJKNXCWbUB3TO76X+mdlVhbzBX4Wo9EZvF7k5Pi2BQnVoRSeew1DRea6MhXVFAQ
         BvibwCxaWhqoDx18ojM7y/90dew+XT68lx11COkqSaMOZnJLY7AAx28Xk7i7xCmldQ/x
         6CI6ZK2Rcujyb0T2hNu8wujcBa0j514EbckYy4LSpLfMOlUp+jVLXUuI9cgkZWh2ZOit
         9Ing==
X-Gm-Message-State: ACgBeo3n7TwbaTGoIlGcKzGPXRjbrLdF7kYiS83LC5jkA8Uxehikr02L
        8/i92MSBgGXXNUoYqn4AnWw5Vko/i7iI1Qw3fN/0oNsA1Pv+BPxGctaEyzRhVr9yG2p3svS0h4T
        hr3qNimvLB/vt
X-Received: by 2002:a05:6638:328e:b0:33f:c7e8:7bc5 with SMTP id f14-20020a056638328e00b0033fc7e87bc5mr13100951jav.48.1660160318478;
        Wed, 10 Aug 2022 12:38:38 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6vtEo0DS2o1w+N3uEfFxGn2l0a2rD+/lrgID6TOcI3dfRSX4cLxjbixKKH8HJHCpnm+BVG4A==
X-Received: by 2002:a05:6638:328e:b0:33f:c7e8:7bc5 with SMTP id f14-20020a056638328e00b0033fc7e87bc5mr13100939jav.48.1660160318303;
        Wed, 10 Aug 2022 12:38:38 -0700 (PDT)
Received: from xz-m1.local (bras-base-aurron9127w-grc-35-70-27-3-10.dsl.bell.ca. [70.27.3.10])
        by smtp.gmail.com with ESMTPSA id c37-20020a029628000000b003429303cb32sm7858183jai.54.2022.08.10.12.38.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 12:38:37 -0700 (PDT)
Date:   Wed, 10 Aug 2022 15:38:35 -0400
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     David Hildenbrand <david@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Sean Christopherson <seanjc@google.com>,
        Linux MM Mailing List <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v2 0/3] kvm/mm: Allow GUP to respond to non fatal signals
Message-ID: <YvQJO7qK2e5WU1Eg@xz-m1.local>
References: <20220721000318.93522-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220721000318.93522-1-peterx@redhat.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Any further comments?  Thanks,

On Wed, Jul 20, 2022 at 08:03:15PM -0400, Peter Xu wrote:
> v2:
> - Added r-b
> - Rewrite the comment in faultin_page() for FOLL_INTERRUPTIBLE [John]
> - Dropped the controversial patch to introduce a flag for
>   __gfn_to_pfn_memslot(), instead used a boolean for now [Sean]
> - Rename s/is_sigpending_pfn/KVM_PFN_ERR_SIGPENDING/ [Sean]
> - Change comment in kvm_faultin_pfn() mentioning fatal signals [Sean]
> 
> rfc: https://lore.kernel.org/kvm/20220617014147.7299-1-peterx@redhat.com
> v1:  https://lore.kernel.org/kvm/20220622213656.81546-1-peterx@redhat.com
> 
> One issue was reported that libvirt won't be able to stop the virtual
> machine using QMP command "stop" during a paused postcopy migration [1].
> 
> It won't work because "stop the VM" operation requires the hypervisor to
> kick all the vcpu threads out using SIG_IPI in QEMU (which is translated to
> a SIGUSR1).  However since during a paused postcopy, the vcpu threads are
> hang death at handle_userfault() so there're simply not responding to the
> kicks.  Further, the "stop" command will further hang the QMP channel.
> 
> The mm has facility to process generic signal (FAULT_FLAG_INTERRUPTIBLE),
> however it's only used in the PF handlers only, not in GUP. Unluckily, KVM
> is a heavy GUP user on guest page faults.  It means we won't be able to
> interrupt a long page fault for KVM fetching guest pages with what we have
> right now.
> 
> I think it's reasonable for GUP to only listen to fatal signals, as most of
> the GUP users are not really ready to handle such case.  But actually KVM
> is not such an user, and KVM actually has rich infrastructure to handle
> even generic signals, and properly deliver the signal to the userspace.
> Then the page fault can be retried in the next KVM_RUN.
> 
> This patchset added FOLL_INTERRUPTIBLE to enable FAULT_FLAG_INTERRUPTIBLE,
> and let KVM be the first one to use it.  KVM and mm/gup can always be able
> to respond to fatal signals, but not non-fatal ones until this patchset.
> 
> One thing to mention is that this is not allowing all KVM paths to be able
> to respond to non fatal signals, but only on x86 slow page faults.  In the
> future when more code is ready for handling signal interruptions, we can
> explore possibility to have more gup callers using FOLL_INTERRUPTIBLE.
> 
> Tests
> =====
> 
> I created a postcopy environment, pause the migration by shutting down the
> network to emulate a network failure (so the handle_userfault() will stuck
> for a long time), then I tried three things:
> 
>   (1) Sending QMP command "stop" to QEMU monitor,
>   (2) Hitting Ctrl-C from QEMU cmdline,
>   (3) GDB attach to the dest QEMU process.
> 
> Before this patchset, all three use case hang.  After the patchset, all
> work just like when there's not network failure at all.
> 
> Please have a look, thanks.
> 
> [1] https://gitlab.com/qemu-project/qemu/-/issues/1052

-- 
Peter Xu

