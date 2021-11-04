Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6E59444E24
	for <lists+kvm@lfdr.de>; Thu,  4 Nov 2021 06:19:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbhKDFUn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Nov 2021 01:20:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbhKDFUm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Nov 2021 01:20:42 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC693C061714
        for <kvm@vger.kernel.org>; Wed,  3 Nov 2021 22:18:04 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id a10so67735ljk.13
        for <kvm@vger.kernel.org>; Wed, 03 Nov 2021 22:18:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1i2ArK/DuUH+8zzvoUDR5kWhCGaxJs+6ozvmTXq3KK8=;
        b=UHIbzIzQ1BtxF5gJfTpEOGoz5NyoOTK6Ll+Tu1A5W4GCmzV2IKgvn53W9V0mG2Uap5
         PoDvCYiy4SsEZkkADAiH4AwUgZ2J3tv8y09mTPK3nk4gRy4yreS9YE8RcGXNs6h44LGZ
         jKvtMxAoE0x3RBpBKTj+1v17lGc4Drx8Oc8v0gVSjiYM+x6EuE/4IEKNPCcog6eeyDHe
         cv/5PEZ8ERI8lOiPS/waDl1su7Rmy3LVo3vLz5l39vot+RwJneQ6saFjzl6zTSHQrr4a
         dsD/3BVbAE5nk8fKATtycJODmWyHcLmGz8qZUkjrq0EsjT7eZMNHG3MBCFnitxvIinoL
         xjmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1i2ArK/DuUH+8zzvoUDR5kWhCGaxJs+6ozvmTXq3KK8=;
        b=mj/NZ2PXd/AfyzRn7KPmM1ee5FuF0WRuuwDcjGj3HbrtQxv29lUZHIXcH+Zy16/5KH
         StRpwGkHNwuo8RdAWdjVKr9xqAhOhZo088F5ijLY+eiDxJR+BL6lWiRSnFd629kyxCqW
         baTpZDcDyefL1DWWuaIWdPBF/P7EGgDCWTqld8l0Xq39ZX6Z6yslt5Ul4kQCmAAfqWp/
         N+NnXyLvxrpdFTxVi4KLm9K1zLErX46y9Yli7n0ElBpnkXBFtXCEB9j/JyKcxoGLeu8D
         ZToT3qzKiM6Vf30yKW0RMfY5qyiDHVB6Av5dPMsTyJxGklQizfPZLeZiqEcoXUjb0sZ2
         srhw==
X-Gm-Message-State: AOAM530eRcwkaC5BANcigmduWEV1qHi3R+FWtu4tijujOfWL3/oQQos7
        Xn9JpJgiYhXt9U6cC3Xo8SGIlcA8Q/o0P5oI4kntTA==
X-Google-Smtp-Source: ABdhPJzQZSoC4A3NWrvzR7sdaoKUiV/q5Xy3qUQi0/b+nqASUfy2A97b28r0pC9HLcxKCyMSUDkX8eI3sOT/96BONDc=
X-Received: by 2002:a2e:bf06:: with SMTP id c6mr50574945ljr.405.1636003082804;
 Wed, 03 Nov 2021 22:18:02 -0700 (PDT)
MIME-Version: 1.0
References: <20211103205911.1253463-1-vipinsh@google.com> <20211103205911.1253463-3-vipinsh@google.com>
 <YYMZPKPkk5dVJ6nZ@google.com>
In-Reply-To: <YYMZPKPkk5dVJ6nZ@google.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Wed, 3 Nov 2021 22:17:26 -0700
Message-ID: <CAHVum0eFwgM-Pj6xHt0gkFCf1OZGjYD7K0xttswbAaGMo6zpJQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] KVM: Move INVPCID type check from vmx and svm to
 the common kvm_handle_invpcid()
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, jmattson@google.com, dmatlack@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 3, 2021 at 4:20 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Nov 03, 2021, Vipin Sharma wrote:
> > Handle #GP on INVPCID due to an invalid type in the common switch
> > statement instead of relying on the callers (VMX and SVM) to manually
> > validate the type.
> >
> > Unlike INVVPID and INVEPT, INVPCID is not explicitly documented to check
> > the type before reading the operand from memory, so deferring the
> > type validity check until after that point is architecturally allowed.
> >
> > Signed-off-by: Vipin Sharma <vipinsh@google.com>
> > ---
>
> For future reference, a R-b that comes with qualifiers can be carried so long as
> the issues raised by the reviewer are addressed.  Obviously it can be somewhat
> subjective, but common sense usually goes a long ways, and most reviewers won't
> be too grumpy about mistakes so long as you had good intentions and remedy any
> mistakes.  And if you're in doubt, you can always add a blurb in the cover letter
> or ignored part of the patch to explicitly confirm that it was ok to add the tag,
> e.g. "Sean, I added your Reviewed-by in patch 02 after fixing the changelog, let
> me know if that's not what you intended".
>
> Thanks!
>
> Reviewed-by: Sean Christopherson <seanjc@google.com>

I was not sure if I can add R-b as it was only for the code and not
changelog. Good to know that I can ask such things in the cover letter
or the ignored part of the patch.

Thanks
Vipin
