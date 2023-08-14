Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E78C77BEF9
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 19:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbjHNR33 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 13:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230407AbjHNR3R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 13:29:17 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65B7A10D0
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 10:29:16 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-584139b6b03so60605297b3.3
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 10:29:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692034155; x=1692638955;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wv/8nZ1yHk/BEJ8mg7HrVuvB2B7eWhaOZuiJd5a6KJw=;
        b=mPrZWtn0CT6WEMlpg3bX4t0s/n6EHWU3G1NN0gR+6/hKKVLWU1OKVYLkZDVkH8+iHW
         lRKj2/X/DTOA9b3cUJ2M2/naXih9B+9dWnxHYE6KocAspXH4aZ5F420C1diMzVuYXcgD
         I0rTrvwmSq9CfeN3FAnZvvzrzIt8HQPr9spgVKSbc/RRW4/N1ybgl2ztqJ0Ss5Rr6kbX
         R8z/8JN3a198UfMLqQdoHetFWQD4Z78eqOkLdwP+ySzXSwH8zZevl122OErvxSXvakTP
         nJS0Zytv+1vdkEldYIe5Z1iyRDWdNcm/1snj2os64yIGdE0Zh1Bp+CCim/j6kACZO4LU
         CdSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692034155; x=1692638955;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wv/8nZ1yHk/BEJ8mg7HrVuvB2B7eWhaOZuiJd5a6KJw=;
        b=kwU8rEJCKIyKPpVrsWexwyVtETCD4HDYf47KZXcJV74NQ5NUT8eGneLMcwiKKWprQk
         egf+i7OdnAPagZI7kszVMx6LaZLA+UhsT6duNCuHQZgQx48/v5UhK91HLVXLEH+bLJUx
         ZZYSwLjlYJ2tK4xDq1xA+P0HnZM9UVmnLPqxm9SajasMqC/iW+m77SLtPWRReZhJyPf0
         M2T3ANGpRohtDuvi5u5O9dMlWtGsz2fi9jnKisf0yQq99xV3c3tSLV3tO+iOkRqMrZsS
         +LwUXKCMLI81A7dS2lNs9dJ7SBlko4l2lYefc7aOX5UU87nVA2zX2vl6321V612rP67f
         y4Xw==
X-Gm-Message-State: AOJu0YxmrjpcFv6UYBd+gRjm6nHKHv/KVKUcqBhBNhyN/wAsBKrV2kb6
        M8a/RVoCZchUrehcG53lA/EeSq0BYvo=
X-Google-Smtp-Source: AGHT+IG/QHEENARZdqfI69HdIHl/KAJVTpkeGaNF1fIxiuiAozumleTNkhbSb7LBssCv6hM5/LrWweJxPzU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ad68:0:b0:560:d237:43dc with SMTP id
 l40-20020a81ad68000000b00560d23743dcmr158447ywk.3.1692034155642; Mon, 14 Aug
 2023 10:29:15 -0700 (PDT)
Date:   Mon, 14 Aug 2023 10:29:13 -0700
In-Reply-To: <68e7d342-bdeb-39bf-5233-ba1121f0afc@ewheeler.net>
Mime-Version: 1.0
References: <CAG+wEg2x-oGALCwKkHOxcrcdjP6ceU=K52UoQE2ht6ut1O46ug@mail.gmail.com>
 <ZMqX7TJavsx8WEY2@google.com> <CAG+wEg1d7xViMt3HDusmd=a6NArt_iMbxHwJHBcjyc=GntGK2g@mail.gmail.com>
 <ZNJ2V2vRXckMwPX2@google.com> <e21d306a-bed6-36e1-be99-7cdab6b36d11@ewheeler.net>
 <e1d2a8c-ff48-bc69-693-9fe75138632b@ewheeler.net> <ZNV5rrq1Ja7QgES5@google.com>
 <CAG+wEg1wio-0grasdwdfNHr7fHZkZWt2TF2LZtw65WZx42jkyQ@mail.gmail.com>
 <ZNZ3owRcRjGejWFn@google.com> <68e7d342-bdeb-39bf-5233-ba1121f0afc@ewheeler.net>
Message-ID: <ZNpkac8NDSbSnZ68@google.com>
Subject: Re: Deadlock due to EPT_VIOLATION
From:   Sean Christopherson <seanjc@google.com>
To:     Eric Wheeler <kvm@lists.ewheeler.net>
Cc:     Amaan Cheval <amaan.cheval@gmail.com>, brak@gameservers.com,
        kvm@vger.kernel.org
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

On Fri, Aug 11, 2023, Eric Wheeler wrote:
> On Fri, 11 Aug 2023, Sean Christopherson wrote:
> > What I suspect is happening is that the in-progress count gets left high, e.g.
> > because of a start() without a paired end(), and that causes KVM to refuse to
> > install mappings for the affected range of guest memory.  Or possibly that the
> > problematic host is generating an absolutely massive storm of invalidations and
> > unintentionally DoS's the guest.
> 
> 
> It would would be great to write a micro benchmark of sorts that generates 
> EPT page invalidation pressure, and run it on a test system inside a 
> virtual machine to see if we can get it to fault:
> 
> Can you suggest the type(s) of memory operations that could be written in 
> user space (or kernel space as a module) to, find a test case that forces 
> it to fail within a reasonable period of time?

Easiest thing would be to toggle PROT_EXEC via mprotect() on guest memory.  KVM
ignores PROT_EXEC so that guest memory doesn't need to be mapped executable in
the VMM, i.e. toggling PROT_EXEC won't cause spurious failures but it will still
trigger mmu_notifier invalidations.

Side topic, can you provide your host Kconfig?
