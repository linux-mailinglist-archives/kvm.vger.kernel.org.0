Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38C306CB569
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 06:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbjC1E2c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 00:28:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjC1E23 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 00:28:29 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF0171BFB
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 21:28:27 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id d5-20020a17090ac24500b0023cb04ec86fso2877670pjx.7
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 21:28:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679977707;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7VdwT79UuaADqtXDMGaAq7GhU3rXRk0QHo6zjVqpfD8=;
        b=f+KPe4SzxVMlwSJxfOEZG4yErZtkE0UvPQO8f5OgNSUl3blDgqqJ7iTsZANblygVyo
         0lHManobEF2D70iqG4htB+Thqi8wwPD4StxohrxDFUDAol8T5F1CSOhF3J6Rp0cPAXLH
         CnVAPQTQqQr3mE24KXiSHwWEJVVrRUgxybkfhWvFwCjaGSqa+KmXJ2Viz9d78KsSdXvD
         7gg9L1ImFEUOPOwzBYPLqXpug/cd81lXbBlzrAgFQpjK3vSQ3xLj8LDHji8VMJgv3FAy
         tKnn3NsO6jx+ZZnmbZmuE+ZexSUkWumnDp1OzKyZrYkZMu+D1XNtQZA5PnTWJgEql4a7
         4hzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679977707;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7VdwT79UuaADqtXDMGaAq7GhU3rXRk0QHo6zjVqpfD8=;
        b=FQbjB1raDSFFn0kd+WPXvkmlXT5Bq/gzSebwU/hnaRXLK5FmFPYLYyP9mAv8V2v3ce
         sQ8Jh/Xt1EbPQzI62OVVYjnMsrUh4gY0Yb7Ne42BGQtrmGM+r5M+kda3Bq0VMCZuq9fP
         T9N8EpWh3MkCaOPPBpbmyoRaW+TgKuOn+4ecxY1znvXusVQCTzKvwk/qQhchTXGQs8Pk
         /BisEowK4uwJgz6OY8EMAFdWsPdSFZZgDqKQT6OtFmzXDLOfgacZUnd3iIMTDRpXKrK9
         8YJq27nbQZzkoF3Z3Id/du7JlXu0QFNS7rKyARpvpfgE+bXPzhmA5yn2z0pZG9Lu4+CH
         pePQ==
X-Gm-Message-State: AAQBX9fRx6MKU1QDy3vWYPX/ClNbG0d5tNUGvYC+i7edRHZr9oapRMIA
        H2dYlZEh3kyhKStMH7uqwGS3LYK27rk=
X-Google-Smtp-Source: AKy350bcL/7WcNEo7o4hRC6bGvT0i8QGHjAOAldOKDPoVE9JuzvwubW9JZDWrYrsZSE6A4+EiIY/9weV5Lw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:d318:b0:23f:6c5:8af2 with SMTP id
 p24-20020a17090ad31800b0023f06c58af2mr4113148pju.2.1679977707456; Mon, 27 Mar
 2023 21:28:27 -0700 (PDT)
Date:   Mon, 27 Mar 2023 21:28:26 -0700
In-Reply-To: <da0dd5e9-9a86-b981-e783-3fd9b15150d3@rbox.co>
Mime-Version: 1.0
References: <20230126013405.2967156-1-mhal@rbox.co> <Y9K5gahXK4kWdton@google.com>
 <da0dd5e9-9a86-b981-e783-3fd9b15150d3@rbox.co>
Message-ID: <ZCJs6lOJ90oQ377T@google.com>
Subject: Re: [PATCH 0/3] KVM: x86/emulator: Segment load fixes
From:   Sean Christopherson <seanjc@google.com>
To:     Michal Luczaj <mhal@rbox.co>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 27, 2023, Michal Luczaj wrote:
> On 1/26/23 18:33, Sean Christopherson wrote:
> > On Thu, Jan 26, 2023, Michal Luczaj wrote:
> >> Two small fixes for __load_segment_descriptor(), along with a KUT
> >> x86/emulator test.
> >>
> >> And a question to maintainers: is it ok to send patches for two repos in
> >> one series?
> > 
> > No, in the future please send two separate series (no need to do so for this case).
> > Us humans can easily figure out what's going on, but b4[*] gets confused, e.g.
> > `b4 am` will fail.
> > 
> > What I usually do to connect the KVM-unit-test change to the kernel/KVM change is
> > to post the kernel patches first, and then update the KVM-unit-test patch(es) to
> > provide the lore link to the kernel patches.
> > 
> > Thanks for asking, and a _huge_ thanks for writing tests!
> > ...
> 
> My pleasure ;) I've noticed two months have passed, but the test was not
> merged. Is there something I should improve?

Nope, KUT x86 is simply lagging badly on maintenance.  I am planning on putting
together a pull request this week, I'll make sure your patch is included.
