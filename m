Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF4B6E7E1D
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 17:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233317AbjDSPUt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 11:20:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233601AbjDSPUr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 11:20:47 -0400
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8070C3C06
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 08:20:02 -0700 (PDT)
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-63d30b08700so10237593b3a.1
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 08:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681917475; x=1684509475;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6fQnCBxw12Xt5wZfbwURYR+FhSl9JVV/o/yOu7nJlu8=;
        b=T3fhgUYszeF2sRb1jkK11JGi4VpyiJFN6nO0oRFERVr08trK+vlYtZt04gbyg74v8w
         DGWEWf89o5SUkAFDuUpZkakufY+/xgvzAk0/+eSOr0qGGWITYvNopIuS1u0gly3/5gQ6
         HLGYuoV/hckpTMkCVj6bh5li0TnhYmhT63adORJ0nPJzEdnXKU08BuvjIyzSAD3UWPxi
         XKKwtsuexs9O17y5Yj07GzNzLY6S9Oss5605IIDXhCaO/gLHNmPTWG0W0zZuJLRj7VBP
         irRixzRnDohE2CZ4qH53nu4rBrPowZDp8cyqYebGLtopOFkls6xMF+vZmc1qlR6oIxKd
         mvnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681917475; x=1684509475;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6fQnCBxw12Xt5wZfbwURYR+FhSl9JVV/o/yOu7nJlu8=;
        b=WqG+mLYA9paAmuehBNoFRXiYHhZhmLebd7tAkx1w6dREMuf8CF4pwySAkObwnHC8nf
         1VZTcWaL/CuAPcsohT+oMpDZ2dpZaqkTR5fzEuxNjezL8h8d4+lxxVVy2jTN7F6KCQPL
         ETQpOBLZv1pW2DAf/SOpnPMZmJDYcdzb8DNWAFSATXxThOzbglKhO4w2LhZohaZzxbqA
         wCyQ/T9HXK7/y/zVIpiB5I5U2II7QrX2K3fu5/NFEhNQlqUz8wR6yFhjYFKHn6OlTcSx
         hMpxeq1Xs6ur/65ZXfiN7RgD33x8Hjn2bVwIMB4vYAIp6RkztiyeS2JqBetr+3eaOQ8Z
         4UKQ==
X-Gm-Message-State: AAQBX9cxxvzS1pEdbWFLg12dvEQ97f+JB1fbSu8IUpmK6LGxVwrTLkB4
        xtk0PMh+gOgV0ckh4JaT1SjTO4cxM6s=
X-Google-Smtp-Source: AKy350Yu0+fC6M2hGh6InBAoVQjubHOxGVVBJENYRw54o5G/sN6eigw9tREh/a1F3bt8USXDh9s+J/ikD5Y=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:201:b0:23d:30a:692b with SMTP id
 c1-20020a17090a020100b0023d030a692bmr704922pjc.4.1681917475285; Wed, 19 Apr
 2023 08:17:55 -0700 (PDT)
Date:   Wed, 19 Apr 2023 08:17:53 -0700
In-Reply-To: <5869f50f-0858-ab0c-9049-4345abcf5641@redhat.com>
Mime-Version: 1.0
References: <20221202061347.1070246-1-chao.p.peng@linux.intel.com>
 <ZD1oevE8iHsi66T2@google.com> <658018f9-581c-7786-795a-85227c712be0@redhat.com>
 <ZD12htq6dWg0tg2e@google.com> <1ed06a62-05a1-ebe6-7ac4-5b35ba272d13@redhat.com>
 <ZD2bBB00eKP6F8kz@google.com> <9efef45f-e9f4-18d1-0120-f0fc0961761c@redhat.com>
 <ZD86E23gyzF6Q7AF@google.com> <5869f50f-0858-ab0c-9049-4345abcf5641@redhat.com>
Message-ID: <ZEAGIe7m4lWW5mV+@google.com>
Subject: Re: Rename restrictedmem => guardedmem? (was: Re: [PATCH v10 0/9]
 KVM: mm: fd-based approach for supporting KVM)
From:   Sean Christopherson <seanjc@google.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Chao Peng <chao.p.peng@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        Vlastimil Babka <vbabka@suse.cz>,
        Vishal Annapurve <vannapurve@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        dhildenb@redhat.com, Quentin Perret <qperret@google.com>,
        tabba@google.com, Michael Roth <michael.roth@amd.com>,
        wei.w.wang@intel.com, Mike Rapoport <rppt@kernel.org>,
        Liam Merwick <liam.merwick@oracle.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Ackerley Tng <ackerleytng@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 19, 2023, David Hildenbrand wrote:
> On 19.04.23 02:47, Sean Christopherson wrote:
> > On Tue, Apr 18, 2023, David Hildenbrand wrote:
> > > "memfd_vm" / "vm_mem" would be sooo (feel free to add some more o's here)
> > > much easier to get. It's a special fd to be used to back VM memory. Depending
> > > on the VM type (encrypted/protected/whatever), restrictions might apply (not
> > > able to mmap, not able to read/write ...). For example, there really is no
> > > need to disallow mmap/read/write when using that memory to back a simple VM
> > > where all we want to do is avoid user-space page tables.
> > 
> > In seriousness, I do agree with Jason's very explicit objection[2] against naming
> > a non-KVM uAPI "guest", or any variation thereof.
> 
> While I agree, it's all better than the naming we use right now ...
> 
> 
> Let me throw "tee_mem" / "memfd_tee" into the picture. That could eventually
> catch what we want to have.
> 
> Or "coco_mem" / "memfd_coco".
> 
> Of course, both expect that people know the terminology (just like what "vm"
> stands for), but it's IMHO significantly better than
> restricted/guarded/opaque/whatsoever.
> 
> Again, expresses what it's used for, not why it behaves in weird ways.

I don't want to explicitly tie this to trusted execution or confidential compute,
as there is value in backing "normal" guests with memory that cannot be accessed
by the host userspace without jumping through a few extra hoops, e.g. to add a
layer of protection against data corruption due to host userspace bugs.

> > (b) if another use case comes along, e.g. the Gunyah hypervisor[4][5], we risk
> > someone reinventing a similar solution.
> 
> I agree. But if it's as simple as providing an ioctl for that hypervisor
> that simply wires up the existing implementation, it's not too bad.

Yeah, my mind was wandering in this direction too.  The absolute worst case
scenario seems to be that we do end up creating a generic syscall that is a
superset of KVM's functionality, in which case KVM would end up with an ioctl()
that is just a redirect/wrapper.
