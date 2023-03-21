Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0406C34C0
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 15:50:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbjCUOul (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 10:50:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231234AbjCUOuj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 10:50:39 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EC6210C5
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 07:50:38 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id e5-20020a17090301c500b001a1aa687e4bso6977281plh.17
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 07:50:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679410237;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=twoMY1fZd5Chrfyv1SuZ5THhsVFAjddPWo80EyFXDz0=;
        b=GkU9hZfIug2woFO0WB6paV3UBc12FLVwf3UZafsqJPfJ5ZGU6maz5hPA1tBkVqM4W2
         dPqY/NBb8bSS5mDDD8uZq0JB0wlwWydlOZkfjJuDPZxgDM2Z+nOOQkBk/3KVD5rgAmUo
         rzLEuzj9M4TJqtqdsq8ZjWpfHraVxjLbFO/v8vLsMZsNzgZwFcBnxb90q0Nqdz4KLFCG
         yhr/YSvo4tNvl+bTcjFlTGPOUSBlczDQ9QPWUbJB6FCBD/MvVd2noEPwJ4EVXR73dD/R
         hd+3llMKHa4NFztFM4a9Mjx2GXs5owr7MAsM1uDY1j98aUg85Rcbmkzow5z1ieT3gbhB
         275w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679410237;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=twoMY1fZd5Chrfyv1SuZ5THhsVFAjddPWo80EyFXDz0=;
        b=JMRDmotSUImkdNqBe7rcnaLwHgoALvRnOndyGjkJFKqNwE1aeptQxCOAzBRcOFG6Hn
         vt50luNmRki2q1bBwZYi39QUii2PTh7pNtxl5/4wKfJmbZxFeyI9iMhdOm7q9MjRccK/
         f3+w6fXEZrfmsar5zK076zRdf3XNA0xZ3Hm4TsDVsmqPuUfQggXi6vKpPCDzUj5lMAsH
         0MYZz0N8z3PXVmmDStHJ3JXwGHtnTev70hK4wFcwIbi0rKtQk+b4MfuuyEdeFk3YdbC/
         iU0K+blxkHPOPWd6EkZgBPmwdLdLanv6HKIGJS2LFV7VTWB+3e5F5ciEHQySXDBsdswW
         dfJg==
X-Gm-Message-State: AO0yUKVD6H09o4uGS2/DgL2kShOcd74yjpbV8OPNkqwwkOAMyLUdujqk
        qJOnC0QOEETaIj1rupUPlJKRzgezut0=
X-Google-Smtp-Source: AK7set+Gf/kRQn8q0ulmy8pmmMjdgwRSPfhMQIEFPjrCqNmUQ9bzdT8sqEZH6/AP9PDIYxxqJWUzc2/+oVk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:66d4:0:b0:50b:18ac:fbea with SMTP id
 c20-20020a6566d4000000b0050b18acfbeamr739039pgw.9.1679410237709; Tue, 21 Mar
 2023 07:50:37 -0700 (PDT)
Date:   Tue, 21 Mar 2023 07:50:35 -0700
In-Reply-To: <ZBjckKb6eWx2vSin@linux.dev>
Mime-Version: 1.0
References: <20230315021738.1151386-1-amoorthy@google.com> <20230315021738.1151386-10-amoorthy@google.com>
 <ZBS4o75PVHL4FQqw@linux.dev> <ZBTK0vzAoWqY1hDh@google.com> <ZBjckKb6eWx2vSin@linux.dev>
Message-ID: <ZBnEO5l7hZMlhi/1@google.com>
Subject: Re: [WIP Patch v2 09/14] KVM: Introduce KVM_CAP_MEMORY_FAULT_NOWAIT
 without implementation
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Anish Moorthy <amoorthy@google.com>, jthoughton@google.com,
        kvm@vger.kernel.org
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

On Mon, Mar 20, 2023, Oliver Upton wrote:
> On Fri, Mar 17, 2023 at 01:17:22PM -0700, Sean Christopherson wrote:
> > On Fri, Mar 17, 2023, Oliver Upton wrote:
> > > I'm not a fan of this architecture-specific dependency. Userspace is already
> > > explicitly opting in to this behavior by way of the memslot flag. These sort
> > > of exits are entirely orthogonal to the -EFAULT conversion earlier in the
> > > series.
> > 
> > Ya, yet another reason not to speculate on why KVM wasn't able to resolve a fault.
> 
> Regardless of what we name this memslot flag, we're already getting explicit
> opt-in from userspace for new behavior. There seems to be zero value in
> supporting memslot_flag && !MEMORY_FAULT_EXIT (i.e. returning EFAULT),
> so why even bother?

Because there are use cases for MEMORY_FAULT_EXIT beyond fast-only gup.  We could
have the memslot feature depend on the MEMORY_FAULT_EXIT capability, but I don't
see how that adds value for either KVM or userspace.

Filling MEMORY_FAULT_EXIT iff the memslot flag is set would also lead to a weird
ABI and/or funky KVM code.  E.g. if MEMORY_FAULT_EXIT is tied to the fast-only
memslot flag, what's the defined behavior if the gfn=>hva translation fails?  KVM
hasn't actually tried to gup() anything.  Obviously not the end of the world, but
I'd prefer not to avoid introduce more odditites into KVM, however minor.

> Requiring two levels of opt-in to have the intended outcome for a single
> architecture seems nauseating from a userspace perspective.

If we usurp -EFAULT, I don't think we'll actually need an opt-in for
MEMORY_FAULT_EXIT.  KVM will need to add a capability so that userspace can query
KVM support, but the actual filling of of kvm_run could be done unconditionally.

Even if we do end up making the behavior opt-in, I would expect them to be largely
orthogonal in userspace.  E.g. userspace would always enable MEMORY_FAULT_EXIT
during startup, and then toggle the memslot flag during postcopy.
