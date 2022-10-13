Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3215FE5B5
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 00:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbiJMW5I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 18:57:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiJMW5F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 18:57:05 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E89FC895A
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 15:57:00 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id e62so3734418yba.6
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 15:57:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IwDbrf5ua3RWGH1fA//O2Bd73yrfFtMaKuUjb0t9zHY=;
        b=TQo376WVarzDfY+FIslbpljS+Enb8HqJGI6ZbCoj7OuMguUd9Udc73hl2/MauE4A3R
         JrPFqNtosNMk/wtvFU9JPZjAlUohc1nWu2qJQQ/vpjOLVmoK2Ut6/msjIPUsjUAhsKbv
         ilZIKPpgYvSc7ql/YSsXpHbHwiz06axKI1nPZIo55atA8EYq9w/WRLEcsjr6YSdgWwJW
         9+bUgoGT9UR2F+AId6Q7VHcjvksyuSdJ+xMQBND/E1anfnsiTKf3rqtgHvhIsnE/qwa7
         MGkDEN7ecLxBk/6ppahFMLyajjSOUl2/3z8LrnP+RxfAYdHSU9ovSqLOjTBGu0nF26sv
         tHSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IwDbrf5ua3RWGH1fA//O2Bd73yrfFtMaKuUjb0t9zHY=;
        b=40OEuUslk6oit60vg9sY5lA0ev4MoMWzdvrLPBJYDbJvOPc3BQ61j7F5zxbi4n/QUX
         yBCKdsWn2QGQrPDeLmY8iGdGpc2vYOIkvwKd+ytxm2PiAW3ehf0i2CiTUJe9/i0siW5x
         kvYczGxJ3WdKhDI8+PC86HHnNdyJZXb60F0PXNaMPAYnp/kTEIwwcXyJ/4+bOXfLA4hr
         3HOrwSSsN5QxJ4dKOekgys0OeTJtZWVQ3nigLOkgoYMOwfQT1bFsO/xgO4pc290bs1Yg
         Rid1EQxKk1YhD7FAvuhpKWrbgL8yM926cQq/q6WHDYiZEnE9ImX5LT9K+6Cq1YDQl3L4
         OmyQ==
X-Gm-Message-State: ACrzQf3TYy3Ge+24dwa3jcP5YWVunVFbfw5IjFveLravLtNxpUdHWJcq
        W1t9QXjmG8ANRVoF0FIjNNUAt3c2QF8PIAhovmKLiA==
X-Google-Smtp-Source: AMsMyM4ifIx9yTJ+LffARvuiPa+t/B7kLOUFHZninyQNoMn2l8Wji/QsMAcDHyksAfMFzGsgmchSMC6tfKUQr2r30SA=
X-Received: by 2002:a5b:10c:0:b0:6be:28ee:2b86 with SMTP id
 12-20020a5b010c000000b006be28ee2b86mr1993858ybx.582.1665701819235; Thu, 13
 Oct 2022 15:56:59 -0700 (PDT)
MIME-Version: 1.0
References: <20221012181702.3663607-1-seanjc@google.com> <CALzav=fZvNttbXSZfCCaFym8cNHYmFZX7286CW_zTZA1CTr3kA@mail.gmail.com>
 <Y0hxFF6ai3cX8uA+@google.com>
In-Reply-To: <Y0hxFF6ai3cX8uA+@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Thu, 13 Oct 2022 15:56:31 -0700
Message-ID: <CALzav=d_UEEAvy6NcOLNWByuRzRqV=y2BWVXzyFMsS4zZwcZkA@mail.gmail.com>
Subject: Re: [PATCH v4 00/11] KVM: x86/mmu: Make tdp_mmu a read-only parameter
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
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

On Thu, Oct 13, 2022 at 1:12 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Oct 13, 2022, David Matlack wrote:
> > On Wed, Oct 12, 2022 at 11:17 AM Sean Christopherson <seanjc@google.com> wrote:
> > > I'm not dead set against having a dedicated TDP MMU page fault handler, but
> > > IMO it's not really better once the TDP MMU vs. shadow MMU is reduced to a
> > > static branch, just different.  The read vs. write mmu_lock is the most
> > > visible ugliness, and that can be buried in helpers if we really want to
> > > make the page fault handler easier on the eyes, e.g.
>
> ...
>
> > My preference is still separate handlers. When I am reading this code,
> > I only care about one path (TDP MMU or Shadow MMU, usually TDP MMU).
> > Having separate handlers makes it easy to read since I don't have to
> > care about the implementation details of the other MMU.
> >
> > And more importantly (but less certain), the TDP MMU fault handler is
> > going to diverge further from the Shadow MMU fault handler in the near
> > future. i.e. There will be more and more branches in a common fault
> > handler, and the value of having a common fault handler diminishes.
> > Specifically, to support moving the TDP MMU to common code, the TDP
> > MMU is no longer going to topup the same mem caches as the Shadow MMU
> > (TDP MMU is not going to use struct kvm_mmu_page), and the TDP MMU
> > will probably have its own fast_page_fault() handler eventually.
>
> What if we hold off on the split for the moment, and then revisit the handler when
> a common MMU is closer to reality?  I agree that a separate handler makes sense
> once things start diverging, but until that happens, supporting two flows instead
> of one seems like it would add (minor) maintenance cost without much benefit.

Sure thing. I'll do the split as part of my series to split out the
TDP MMU to common code and we can revisit the discussion then.

>
> > If we do go the common handler route, I don't prefer the
> > direct_page_fault_mmu_lock/unlock() wrapper since it further obscures
> > the differences between the 2 MMUs.
>
> Yeah, I don't like the wrappers either.
