Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 759CA6E6A62
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 19:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232204AbjDRRBb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 13:01:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232304AbjDRRB3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 13:01:29 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84A6B2710
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 10:01:27 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 8-20020a250f08000000b00b880000325bso2686381ybp.3
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 10:01:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681837286; x=1684429286;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Dyuu5wU7j8YU7zpj0pOZ8BO/c8tny2d3D8gekiPd7fA=;
        b=d8/Zb9YgCa8eVlBLTpV+NJ57rdS1xsLfkqIXEKvUHW2uAls6J+FJzlZN6Ji/4uRir/
         1zS+MdaFNxXGCzCFIaF1aqXoOXWg1iFKiZNpDvV9eSfZylaThYuxowhj3wxPLo7slf/4
         LHgnLU2DGCVx3/24VmikxziwoDQgW6WdB6Va8iTHc1Yg6NoxaE0GSi5sFvNhfyQ8EBlj
         Geyjaz/WvFCOZ3LFQBwGUhsO/cbtnHrGgBtiKMeYHxW+6m89BnzcmE/zONLKuZzIK3Zd
         WwjlA2lMQP53PxLKQnfqOnLmqIoOsiRGWzjBF4baNzHxGVTgYocW6PIPjpngll6Enuy7
         +yGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681837286; x=1684429286;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Dyuu5wU7j8YU7zpj0pOZ8BO/c8tny2d3D8gekiPd7fA=;
        b=D8LB0DaPWuTg8hH5awl3DQ1oaNxRcG9mJqKusiUUPnXSFs46uCSX6kMPpeq2lVXlYa
         y74l3SLxBrHzTj4oL+nBkQao4gS7+Sjk8qL5Wy4s6DID06ceRswdCN0vUuOqzEkarm0D
         hOKx4k4AhlD0NAL0qdtitotTkCUowNe7ahUbXAkuX/oxJfqaPOS8KflQ6XqoQ5/7HjKm
         UO1VkP+13oKlsNEzpcugK9UWSGEjo26pMLrYxoSuBNd7VOcVMOxTqqxKOtq9PegB2YMv
         GZVlT+OtUHdPP0Jse10LxG+qk2bCT4zN3TGwu+u31MCyQThb0HaNgi8x9lbrc6R3yDfT
         CQgA==
X-Gm-Message-State: AAQBX9fhjBlIuHi8mZqsYoaSicD9VV8hz065aYjv2Vsvkwfn8zyJcjte
        lz/Fl5Zs8ALRyzmY6WauOZVR5rLXgH5pnmZiXA==
X-Google-Smtp-Source: AKy350bfjObXL4Qf9+g1wZMUKUYGeLrkCLVYHghpYReFp8Cgnq9KYi/FOYW0J9unNXx/8e5Sa4DQgJWQeRCCTyyt3w==
X-Received: from ackerleytng-cloudtop.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1f5f])
 (user=ackerleytng job=sendgmr) by 2002:a25:d707:0:b0:b8f:578c:4e3a with SMTP
 id o7-20020a25d707000000b00b8f578c4e3amr9653508ybg.12.1681837286764; Tue, 18
 Apr 2023 10:01:26 -0700 (PDT)
Date:   Tue, 18 Apr 2023 17:01:25 +0000
In-Reply-To: <ZD12htq6dWg0tg2e@google.com> (message from Sean Christopherson
 on Mon, 17 Apr 2023 09:40:38 -0700)
Mime-Version: 1.0
Message-ID: <diqz5y9t86qi.fsf@ackerleytng-cloudtop.c.googlers.com>
Subject: Re: Rename restrictedmem => guardedmem? (was: Re: [PATCH v10 0/9]
 KVM: mm: fd-based approach for supporting KVM)
From:   Ackerley Tng <ackerleytng@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     david@redhat.com, chao.p.peng@linux.intel.com, pbonzini@redhat.com,
        vkuznets@redhat.com, jmattson@google.com, joro@8bytes.org,
        mail@maciej.szmigiero.name, vbabka@suse.cz, vannapurve@google.com,
        yu.c.zhang@linux.intel.com, kirill.shutemov@linux.intel.com,
        dhildenb@redhat.com, qperret@google.com, tabba@google.com,
        michael.roth@amd.com, wei.w.wang@intel.com, rppt@kernel.org,
        liam.merwick@oracle.com, isaku.yamahata@gmail.com,
        jarkko@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Mon, Apr 17, 2023, David Hildenbrand wrote:
>> On 17.04.23 17:40, Sean Christopherson wrote:
>> > I want to start referring to the code/patches by its  
>> syscall/implementation name
>> > instead of "UPM", as "UPM" is (a) very KVM centric, (b) refers to the  
>> broader effort
>> > and not just the non-KVM code, and (c) will likely be confusing for  
>> future reviewers
>> > since there's nothing in the code that mentions "UPM" in any way.
>> >
>> > But typing out restrictedmem is quite tedious, and git grep shows  
>> that "rmem" is
>> > already used to refer to "reserved memory".
>> >
>> > Renaming the syscall to "guardedmem"...

>> restrictedmem, guardedmem, ... all fairly "suboptimal" if you'd ask  
>> me ...

> I'm definitely open to other suggestions, but I suspect it's going to be  
> difficult
> to be more precise than something like "guarded".

> E.g. we discussed "unmappable" at one point, but the memory can still be  
> mapped,
> just not via mmap().  And it's not just about mappings, e.g. read() and  
> its many
> variants are all disallowed too, despite the kernel direct map still  
> being live
> (modulo SNP requirements).

How about "opaque"?

I think opaque captures the idea of enforced information hiding from the
user(space), and that the contents can only be manipulated via internal
(kernel) functions.
