Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9584036DFFD
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 21:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241739AbhD1T5u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 15:57:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232291AbhD1T5t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Apr 2021 15:57:49 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0A13C061574
        for <kvm@vger.kernel.org>; Wed, 28 Apr 2021 12:57:03 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id z23so27155150lji.4
        for <kvm@vger.kernel.org>; Wed, 28 Apr 2021 12:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VZgp1adEz9KJlJ3oJ5kLJbN7WPtmYsA6YapY9DMHwWU=;
        b=Iz54qD+kKfPO2PcFkG2ZI4iTD0Qi5YGf77KBVhdRLOpBNlaAfEuwWHyphPOjSDozh2
         1dMAt42ImNhZR5GGOciu7WEqcHYdoCr9dbEIrEFK0yjF5cr9qVpPPD4yZ0M/gUoaBMk1
         ILoWtnTh7u7JhKXq6VOJlInl0krz9qP0S/xg+uGLa8S72XNvgxSTJnlO2oo1WDbvaiKd
         hQsHzsEBWUG/mmLRiUsnkeHIAMCbu7xbO7aVQw5HwO0GVX0Z+m876z6YQ4JYIaRqFW3o
         opfXGG//T4BmEBxz0sfOKLCrdMiHPftmIDPGyMqn+QXqkwY2TkeN28Rh+ETuzRNSWspF
         Q1BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VZgp1adEz9KJlJ3oJ5kLJbN7WPtmYsA6YapY9DMHwWU=;
        b=OKQ/V44VwyXI/1SMsXCTrr5zIVs4k3majW8MjOuWr+yA5wxxTXfz27F8rWrijbbPE9
         ZH/9h1k9RURG0RBOkC7X/jyXTrO38H0m7T5tA8Bs9foRHlLidjgLhsSz6qHL2OcNdMUp
         F6gG5wrshoIPvqdE5YPMN6hqw5UG6POW72pLwaihZ72xBdzYyXJcXgzn4cdI1FF8TeDw
         KeMKmdi0Qxs26KXnRFvaAs7wBEMPz1um044tZcBODKF5Stcc8o1guf0onfym0jfpQtuA
         7YpAD7vjNnUysWXxQ7loyTB1YbYw2mVdupqRLvLdaRx9zQzmoEUFFCl5WIpo4Ecur8JP
         EGGQ==
X-Gm-Message-State: AOAM5333xDZ71zQQ3+80n/avznaT46O2fM0gnZMYUEE6mon8pOIRRn56
        3sc0iDLbL3P48QoqG5KBi3dIfhsEb19F+8v2hgX26w==
X-Google-Smtp-Source: ABdhPJyIMs9er4bTaeKrhXCa0B8Comuk9ocQKVa3i92in2sI+G9I6NvUnUtGTMH6JYgzGl9UeTtVxPTJs1/YwqY8yWY=
X-Received: by 2002:a2e:97d2:: with SMTP id m18mr22006341ljj.13.1619639815715;
 Wed, 28 Apr 2021 12:56:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210421173716.1577745-1-pbonzini@redhat.com> <20210421173716.1577745-3-pbonzini@redhat.com>
 <YIiMrWS60NuesU63@google.com>
In-Reply-To: <YIiMrWS60NuesU63@google.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Wed, 28 Apr 2021 12:56:19 -0700
Message-ID: <CABayD+dKLTx5kQTaKASQkcam4OiHJueuL1Vf32soiLq=torg+w@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] KVM: x86: add MSR_KVM_MIGRATION_CONTROL
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Venu Busireddy <venu.busireddy@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 27, 2021 at 3:14 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Apr 21, 2021, Paolo Bonzini wrote:
> > Add a new MSR that can be used to communicate whether the page
> > encryption status bitmap is up to date and therefore whether live
> > migration of an encrypted guest is possible.
> >
> > The MSR should be processed by userspace if it is going to live
> > migrate the guest; the default implementation does nothing.
> >
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
>
> ...
>
> > @@ -91,6 +93,8 @@ struct kvm_clock_pairing {
> >  /* MSR_KVM_ASYNC_PF_INT */
> >  #define KVM_ASYNC_PF_VEC_MASK                        GENMASK(7, 0)
> >
> > +/* MSR_KVM_MIGRATION_CONTROL */
> > +#define KVM_PAGE_ENC_STATUS_UPTODATE         (1 << 0)
>
> Why explicitly tie this to encryption status?  AFAICT, doing so serves no real
> purpose and can only hurt us in the long run.  E.g. if a new use case for
> "disabling" migration comes along and it has nothing to do with encryption, then
> it has the choice of either using a different bit or bastardizing the existing
> control.
>
> I've no idea if such a use case is remotely likely to pop up, but allowing for
> such a possibility costs us nothing.
Using a different bit sounds fine to me. It would allow us to avoid
stuffing multiple meanings into a single bit, which would still happen
even if we had a better name.
