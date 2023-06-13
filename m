Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28E8872ED77
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 23:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235145AbjFMVAh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 17:00:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjFMVAf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 17:00:35 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F315D1713
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 14:00:34 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-25dbcf8ad37so106115a91.0
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 14:00:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686690034; x=1689282034;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jljGXauDfzGidSxj/4euSAvmhPCCW8TcgdZqUiedYic=;
        b=jFmx+rZ9eitGwJQIwT1AsAKbE6+BCjlKk7VvMgrMRN2Ii+PBms29co3ReDL/lmgo61
         a6Ng5xSjE6ipCE6+cJa0LzwBOuYCRVeh1vt0K+OayP1pgTiAEAzuldHF7BFcAi/F5agO
         IDVCysHYo5WtKOCR/y7fiXmCHx7tecUE7CjwStXqdc2zRAoOXTanobbwEd9U82qh8w5g
         vcLvrh6ucymQrdgFoEGLB8I6Q87vvsHJdgHGDvnlDQfdDWtOtKs6uDnMRxwRu/KtveUc
         qwqqks/07BSiAdu/df3HF2h+FL2bjnwAumhV1mzSiCV9i5cyTJ2JsKw9BohFxsH6YJqz
         BTdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686690034; x=1689282034;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jljGXauDfzGidSxj/4euSAvmhPCCW8TcgdZqUiedYic=;
        b=G4JysuJsvE2wTlUU2YzFKNAVRTKeWSXWMM4S4PKvb92NSegMYyNbrvoRcSHyANJYJE
         0XehO89hIN58Yxgmj3ktQmVRvw6akUqf7giiEeXbxmhP8QlztJciXmrw9AS/4T19bDfU
         p0o03SpZE1TVvcqERU8kdVHW5zZGVhWOMj2Q75M/8rgA+vDbxYpfa89jWcmvfDm1kZTj
         7cjb+E42YeUFJV4xIGeqdej1lHxKTa0TiwSUJDhj+APY+7P8m5Puk/PgJFQDuue7ThSp
         ADtgKhaiI5rdZus99GUTVmW2xaDNmlPZfK0S5MM+FmY36zDZfYOeEU9dF16r3eqxeoD+
         YYMA==
X-Gm-Message-State: AC+VfDwlrkbiGjZdr05oXRgLOXVKm5bAeqeTF7ucx5kXrCw89oGfiy0A
        HZoaeRu4nDmW182aVRhf+fGvTYXe5jk=
X-Google-Smtp-Source: ACHHUZ7YkYZOYY4IdbjPSlsjwJFscS7XLgngA0zVyfDSRGgMkzHs0vbVtuySp2N/tX90XdQlunekUaSOBYw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:897:b0:25b:809a:c7a with SMTP id
 bj23-20020a17090b089700b0025b809a0c7amr2319497pjb.3.1686690034516; Tue, 13
 Jun 2023 14:00:34 -0700 (PDT)
Date:   Tue, 13 Jun 2023 14:00:32 -0700
In-Reply-To: <4C71D912-E6D2-4391-9DCB-FB13AE1D74D3@baidu.com>
Mime-Version: 1.0
References: <20230602070224.92861-1-gaoshiyuan@baidu.com> <CALMp9eRWJ9H3oY9utMs5auTM-BSCer=XA+Lsr9QVBqkFFDCFQw@mail.gmail.com>
 <ZHpAFOw/RW/ZRpi2@google.com> <CALMp9eTPDcMT7NoEtBtutKWbvbLLX49tqWbfCB1Og62v56eCRQ@mail.gmail.com>
 <ZHpjrOcT4r+Wj+2D@google.com> <CALMp9eRLhNu-x24acfHvySf6K1EOFW_+rAqeLJ6bBbLp3kCc=Q@mail.gmail.com>
 <ZHpyn7GqM0O0QkwO@google.com> <CALMp9eQq8a=53WfoTUYdaPCZ_CO5KDUodzgw=0J2Y8erUirvag@mail.gmail.com>
 <4C71D912-E6D2-4391-9DCB-FB13AE1D74D3@baidu.com>
Message-ID: <ZIjY0vmsejATbbIG@google.com>
Subject: Re: [PATCH] KVM: x86/vPMU: ignore the check of IA32_PERF_GLOBAL_CTRL bit35
From:   Sean Christopherson <seanjc@google.com>
To:     Shiyuan Gao <gaoshiyuan@baidu.com>
Cc:     Jim Mattson <jmattson@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "likexu@tencent.com" <likexu@tencent.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 05, 2023, Gao,Shiyuan wrote:
> On Fri, Jun 3, 2023, Jim Mattson wrote:
> 
> > On Fri, Jun 2, 2023 at 3:52 PM Sean Christopherson <seanjc@google.com <mailto:seanjc@google.com>> wrote:
> > >
> > > On Fri, Jun 02, 2023, Jim Mattson wrote:
> > > > On Fri, Jun 2, 2023 at 2:48 PM Sean Christopherson <seanjc@google.com <mailto:seanjc@google.com>> wrote:
> > > > >
> > > > > On Fri, Jun 02, 2023, Jim Mattson wrote:
> > > > Um, yeah. Userspace can clear bit 35 from the saved
> > > > IA32_PERF_GLOBAL_CTRL MSR so that the migration will complete. But
> > > > what happens the next time the guest tries to set bit 35 in
> > > > IA32_PERF_GLOBAL_CTRL, which it will probably do, since it cached
> > > > CPUID.0AH at boot?
> > >
> > > Ah, right. Yeah, guest is hosed.
> > >
> > > I'm still not convinced this is KVM's problem to fix.
> >
> > One could argue that userspace should have known better than to
> > believe KVM_GET_SUPPORTED_CPUID in the first place. Or that it should
> > have known better than to blindly pass that through to KVM_SET_CPUID2.
> > I mean, *obviously* KVM didn't really support TOPDOWN.SLOTS. Right?
> >
> >
> > But if userspace can't trust KVM_GET_SUPPORTED_CPUID to tell it about
> > which fixed counters are supported, how is it supposed to find out?
> >
> >
> > Another way of solving this, which should make everyone happy, is to
> > add KVM support for TOPDOWN.SLOTS.
> >
> Yeah, this way may make everyone happly, but we need guarantee the VM that
> not support TOPDOWN.SLOTS migrate success. I think this also need be addressed
> with a quirk like this submmit.
> 
> I can't find an elegant solution...

I can't think of an elegant solution either.  That said, I still don't think we
should add a quirk to upstream KVM.  This is not a longstanding KVM goof that
userspace has come to rely on, it's a combination of bugs in KVM, QEMU, and the
deployment (for presumably not validating before pushing to production).  And the
issue affects a only relatively new CPUs.  Silently suppressing a known bad config
also makes me uncomfortable, even though it's unlikely that any deplyoment would
rather terminate VMs than run with a messed up vPMU.

I'm not dead set against a quirk, but unless the issue affects a broad set of
users, I would prefer to not carry anything in upstream, and instead have (the
(hopefully small set of) users carry an out-of-tree hack-a-fix until all their
affected VMs are rebooted on a fixed KVM and/or QEMU.
