Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 415CD5E83FB
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 22:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233259AbiIWUfM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Sep 2022 16:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232950AbiIWUdp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Sep 2022 16:33:45 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEF7414D307
        for <kvm@vger.kernel.org>; Fri, 23 Sep 2022 13:28:40 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id fv3so1114016pjb.0
        for <kvm@vger.kernel.org>; Fri, 23 Sep 2022 13:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=uHzKBVTjEHdcyxBK/e9a9aAi8Q9V4sIUcMdI9R+NeBw=;
        b=jBye91GcJQpuPM4eGpC1kN+s6wjUWqJyd/v7aTXGIRUnvrWux7XpJSTzfPNIqoJyf/
         pMGFjdgFAwJgoiWOA2c87VkOJrEq9UrR6eF7rfeUvysqGBQ29Hn46KFQuYrECrQx3mfB
         P+ik2svTHcyq3xMw+1ZNMITx6akxpdQwuEOp4n8vE7AUDEMnhiVQZkmLvtB1pEiiARi6
         aOwW1Sb9j+BYeDkSmSxkjFnHqZtxRG8fvPcOM2z+5pBdYhY00wWVMYq65WN7KZO/Gb2t
         kFDgwVXjgKklRkGH2rKro9uPOrjVTTNfME1BGgHsA33x35b11E1KmBQGSSxqTPDeogcc
         fPNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=uHzKBVTjEHdcyxBK/e9a9aAi8Q9V4sIUcMdI9R+NeBw=;
        b=RY62aCrQd/pMmrAvu3kQ9kM+Te3liURnAyWpOhKH94igxrSO/Lp+Zu43I+DzTJ8ah+
         +1nLMQO0rmAGxHJFXg3D9xffWa+9T72oU+RPS8NapNIz3Y717ylOL75mA59/xuZ8qXIq
         E5MkH5uyfW3IhTMuSdQzZept0IWS7SUXPTvT3co5038KBF1O53tPNUic2u6//InyyPLP
         0JOL68ZlW0OsqvgB5kw3YDvoa0NVEXcV6mo8voYeCQmm6yMiedDrfZFptxYTPomxHD3I
         9Wq6jx8gT+pgY+ULlRaGBX5w5bwBjjYF7XoZ+88QCZHe8o4KajU5C7h7JWqWsTbWQCZF
         si+A==
X-Gm-Message-State: ACrzQf20B0oo+8Pp9Uqd+Qmfn2GxWbYg4x4IDoYUpIWQDvaPempOePhE
        gIQR+WjnI3ZNEhh5fnWOFPo5CA==
X-Google-Smtp-Source: AMsMyM7t4qHFld3zzoNO7/9jFvEv+SqU6/d9JqvrRQbm1VPCqer3MTjhooRHzu9ktvjs5vn0RrOU6w==
X-Received: by 2002:a17:90b:4b03:b0:202:eab3:e174 with SMTP id lx3-20020a17090b4b0300b00202eab3e174mr22407036pjb.12.1663964920411;
        Fri, 23 Sep 2022 13:28:40 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id b67-20020a621b46000000b0053e22c7f135sm6922461pfb.141.2022.09.23.13.28.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 13:28:39 -0700 (PDT)
Date:   Fri, 23 Sep 2022 13:28:35 -0700
From:   David Matlack <dmatlack@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vladimir Davydov <vdavydov.dev@gmail.com>, linux-mm@kvack.org,
        Sean Christopherson <seanjc@google.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>
Subject: Re: The root cause of failure of access_tracking_perf_test in a
 nested guest
Message-ID: <Yy4W86qofpjoh2LA@google.com>
References: <50dfe81bf95db91e6148b421740490c35c33233e.camel@redhat.com>
 <CALMp9eSJbb6sSmv4c8c3ebCtfgdAARgryq5jHXdRmhxm6fYQsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eSJbb6sSmv4c8c3ebCtfgdAARgryq5jHXdRmhxm6fYQsw@mail.gmail.com>
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

On Fri, Sep 23, 2022 at 12:25:00PM -0700, Jim Mattson wrote:
> On Fri, Sep 23, 2022 at 3:16 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:
> >
> > Because of this, when the guest clears the accessed bit in its nested EPT entries, KVM doesn't
> > notice/intercept it and corresponding EPT sptes remain the same, thus later the guest access to
> > the memory is not intercepted and because of this doesn't turn back
> > the accessed bit in the guest EPT tables.
> 
> Does the guest execute an INVEPT after clearing the accessed bit?

No, that's the problem. In L1, access_tracking_perf_test is using
page_idle to mark guest memory as idle, which results in clear_young()
notifiers being sent to KVM clear access bits. clear_young() is
explicitly allowed to omit flushes, so KVM happily obliges.

	/*
	 * clear_young is a lightweight version of clear_flush_young. Like the
	 * latter, it is supposed to test-and-clear the young/accessed bitflag
	 * in the secondary pte, but it may omit flushing the secondary tlb.
	 */
	int (*clear_young)(struct mmu_notifier *subscription,
			   struct mm_struct *mm,
			   unsigned long start,
			   unsigned long end);

We could modify page_idle so that KVM performs TLB flushes. For example,
add a mechanism for userspace to trigger a TLB flush. Or change
page_idle to use clear_flush_young() (although that would be incredibly
expensive since page_idle only allows clearing one pfn at a time). But
I'm not sure creating a new userspace API just for this test is really
worth it, especially with multigen LRU coming soon.
