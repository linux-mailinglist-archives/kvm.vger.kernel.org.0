Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4D45805BF
	for <lists+kvm@lfdr.de>; Mon, 25 Jul 2022 22:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236973AbiGYUfV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jul 2022 16:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237244AbiGYUfO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jul 2022 16:35:14 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F026115F
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 13:35:11 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id e1so980355pjl.1
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 13:35:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oSbs4bLiLFRoDiEdwoSde6H1Z0IYhG08lZUF8/TBVx0=;
        b=Bh6KsA4MANApkZQcCv5PI1jyKjSXTtpArjwUaDuXE8570p2KFUo8i2Os/izOz4cswS
         owObzscuCn4t65SH5K/XHfdrs2fxRAN6sp8N2bcmo38wlZqlAFHciRzZwoPIweFyCc6H
         Hx00piazZJiv7qZxYuMm3JkHsYYiNKEMHTFTJwfm/Z6ZtmPNX6h3NIqTDNytIrTnz7Ey
         qLAd0cY/7GTpi72ej7NVrjS5f17Jo8OaDczpzfUTu/ux7gGhp4qpXJ51EH5+rhgNQFbd
         olhzCt9JeZMlskjQ5mn94oR3/GCZg3VpYoAYLdD2LxjQ+y7fTI4fN5WDjn1/vDiUGWTR
         VQSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oSbs4bLiLFRoDiEdwoSde6H1Z0IYhG08lZUF8/TBVx0=;
        b=ow80l2kaF2qAaWK+WKvVV2+y62aMi2fFd5DU1yDzQJHuEkfr8V1l/QlyFdWlsngjXA
         zfsEt9Tui1JpNRhkpXHJiVFtuN2zYb27p8AbVe4zYTtj6RgH9wrMgURAvQSKcy+PN43y
         1G+wybkMP2fXy7g6XWV88cKQ2LmW+xzX9NV/0sr0Y0rbIZpsCRemsLKbhvSPc4bv7b42
         1l7FH+a90Fcj9dUx5PKN78nVQL/PoKVoh6ZhymnpasmVCE71moJ+wpmQ7Zj9HgUrNWUq
         RU8XBpdHhSQiMc/gIBqV0Lm/dHw7Mjs7h67DVj6xNae6z3GEtIEll+NZIqLyl4J0vQ92
         ETJQ==
X-Gm-Message-State: AJIora9BSHNHuPiPzV3ILQUJIXB+qX41oddxbNu0pyMojW+P9c+AaZ+p
        d1/BACA6ItbsZEFKMf0/B3XcQw==
X-Google-Smtp-Source: AGRyM1s8L2Ck3bOdVVoh7FfCYNRThxdqd2Hc4lDp/jMpGPaf0gU0UePxPeNU6oSikTi74r98Mfo75Q==
X-Received: by 2002:a17:902:cf09:b0:16d:69ad:e496 with SMTP id i9-20020a170902cf0900b0016d69ade496mr8650520plg.6.1658781310824;
        Mon, 25 Jul 2022 13:35:10 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id r12-20020a17090a4dcc00b001ef81574355sm11375507pjl.12.2022.07.25.13.35.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 13:35:10 -0700 (PDT)
Date:   Mon, 25 Jul 2022 20:35:06 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Yang Weijiang <weijiang.yang@intel.com>,
        Manali Shukla <manali.shukla@amd.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [kvm-unit-tests GIT PULL] x86: Fixes, cleanups, and new sub-tests
Message-ID: <Yt7+epRAIL7EK2jj@google.com>
References: <YtnBbb1pleBpIl2J@google.com>
 <YttLhpaAwft0PnbI@google.com>
 <Yt7LJZpmF3ddJJnk@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yt7LJZpmF3ddJJnk@google.com>
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

On Mon, Jul 25, 2022, Sean Christopherson wrote:
> On Sat, Jul 23, 2022, Sean Christopherson wrote:
> > On Thu, Jul 21, 2022, Sean Christopherson wrote:
> > > Please pull/merge a pile of x86 cleanups and fixes, most of which have been
> > > waiting for review/merge for quite some time.  The only non-trivial changes that
> > > haven't been posted are the massaged version of the PMU cleanup patches.
> > > 
> > > Note, the very last commit will fail spectacularly on kvm/queue due to a KVM
> > > bug: https://lore.kernel.org/all/20220607213604.3346000-4-seanjc@google.com.
> > > 
> > > Other than that, tested on Intel and AMD, both 64-bit and 32-bit.
> > 
> > Argh, don't pull this.
> > 
> > Commit b89a09f ("x86: Provide a common 64-bit AP entrypoint for EFI and non-EFI")
> > broke the SVM tests on Rome.  I'll look into it next week and spin a new version.
> 
> The APIC needs to be "reset" to put it back into xAPIC, otherwise pre_boot_apic_id()
> will return garbage when `svm_init_startup_test` is run and x2APIC is supported.

And of course that breaks EFI.  Posted a small series to play nice with x2APIC and
provide a segue into the UEFI changes.
