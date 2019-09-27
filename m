Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3492AC0937
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 18:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727518AbfI0QK2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 12:10:28 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:33989 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727349AbfI0QK2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 12:10:28 -0400
Received: by mail-io1-f67.google.com with SMTP id q1so17784430ion.1
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2019 09:10:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UXV2Hn7JKmMTn9c+5xFmZirCbni1J6jzVcsI4Rgm4oA=;
        b=k509PsPnpBgE5LT5/2e0zXjZ2xzfP/dBGvSqDj1ohAgZT7g3/6hvznBQ9Q4Fvows0m
         bN0sHv7b9i/p/scqGZkzpL9TimYHpTERpy7ZiQu98pqwA8NhFo+StnjP70vM7XK4AXyc
         mm8HhwTdzOIlAne9pq2n+YeT9mneNzWjCy5OEr+Uq7JPOrUvGvhH8FsaZRdZKxVAjtXz
         PHlO0AmHYklf0bxWCtMdlPTIA2dt4wlNGvsO3P3KtsCWDQAXp2WT3lqTBtz0dlueHD6u
         1/Z/dHz93Ou+R7tCEeOdhKDS4IAgJ2ZKPRP/UnE/mb4YCFIHX9pAsF0z88iwGB43nbOp
         KPkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UXV2Hn7JKmMTn9c+5xFmZirCbni1J6jzVcsI4Rgm4oA=;
        b=JkvmXQSZD97Ze/P74AF+BswvMTJHqj2iTqKmK9C4vI+ycpDuadRk6y/nVLfsIH+Cej
         wF7tEKWpd02W6ehuILpJEpAbSjbpgfeQKTYU0POfy4i0y6sbQh8GCG/GiHSQFWFnBHeV
         7i+k54PNcFEYCMUQ2afeCLqjg5eAu50hPreOGEBd7uZu+A13eqzexbyoTSIrH+ATUJD/
         AyVGA5sC/6LuNSIquOkbLZlZVc4YQ9sKMmNcNzWPOv6BOmz2z3aJBCVbledryGrI3740
         Wi2zoqTluc8whxSvWj+2zGoqZdD7V/CC9p14NACaLoRqpo/wQunAOkzzzX6MX+LCyUF+
         TNpw==
X-Gm-Message-State: APjAAAXNbUi4CcYgLC1xJsrs8XDTeF7VwCIZL20IWXffpRMZAq6eaBin
        05OZwnMChK0ZFR1n4tWojCdokxfOxnZUt+4tFD1r9d9qlZM=
X-Google-Smtp-Source: APXvYqyx23W9hvvIXxt0d9BGBS112UBS3vxsnUDx0fH7KHF8uZYw2MNK2DujNah/KOKs8haEy4LLyq2luAfoBPZlsjk=
X-Received: by 2002:a05:6638:3:: with SMTP id z3mr3536305jao.54.1569600626086;
 Fri, 27 Sep 2019 09:10:26 -0700 (PDT)
MIME-Version: 1.0
References: <8907173e-9f27-6769-09fc-0b82c22d6352@oracle.com>
 <CALMp9eSkognb2hJSuENK+5PSgE8sYzQP=4ioERge6ZaFg1=PEA@mail.gmail.com>
 <cb7c570c-389c-2e96-ba46-555218ba60ed@oracle.com> <CALMp9eQULvr5wKt1Aw3MR+tbeNgvA_4p__6n1YTkWjMHCaEmLw@mail.gmail.com>
 <CALMp9eS1fUVcnVHhty60fUgk3-NuvELMOUFqQmqPLE-Nqy0dFQ@mail.gmail.com>
 <56e7fad0-d577-41db-0b81-363975dc2ca7@redhat.com> <87ftkh6e19.fsf@vitty.brq.redhat.com>
 <6e6f46fe-6e11-c5e3-d80c-327f77b91907@redhat.com> <87d0fl6bv4.fsf@vitty.brq.redhat.com>
 <19db28c0-375a-7bc0-7151-db566ae85de6@redhat.com> <20190927152608.GC25513@linux.intel.com>
 <87a7ap68st.fsf@vitty.brq.redhat.com> <59934fa75540d493dabade5a3e66b7ed159c4aae.camel@intel.com>
 <e4a17cfb-8172-9ad8-7010-ee860c4898bf@redhat.com>
In-Reply-To: <e4a17cfb-8172-9ad8-7010-ee860c4898bf@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 27 Sep 2019 09:10:14 -0700
Message-ID: <CALMp9eQcHbm6nLAQ_o8dS4B+2k6B0eHxuGvv6Ls_-HL9PC4mhQ@mail.gmail.com>
Subject: Re: [PATCH] kvm: x86: Add Intel PMU MSRs to msrs_to_save[]
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm list <kvm@vger.kernel.org>,
        Eric Hankland <ehankland@google.com>,
        Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 27, 2019 at 9:06 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 27/09/19 17:58, Xiaoyao Li wrote:
> > Indeed, "KVM_GET_MSR_INDEX_LIST" returns the guest msrs that KVM supports and
> > they are free from different guest configuration since they're initialized when
> > kvm module is loaded.
> >
> > Even though some MSRs are not exposed to guest by clear their related cpuid
> > bits, they are still saved/restored by QEMU in the same fashion.
> >
> > I wonder should we change "KVM_GET_MSR_INDEX_LIST" per VM?
>
> We can add a per-VM version too, yes.

Should the system-wide version continue to list *some* supported MSRs
and *some* unsupported MSRs, with no rhyme or reason? Or should we
codify what that list contains?
