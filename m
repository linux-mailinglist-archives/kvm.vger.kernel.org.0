Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5A5573E93
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 23:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231409AbiGMVLl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 17:11:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236931AbiGMVLk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 17:11:40 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0BAA33371
        for <kvm@vger.kernel.org>; Wed, 13 Jul 2022 14:11:39 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 23so11543245pgc.8
        for <kvm@vger.kernel.org>; Wed, 13 Jul 2022 14:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Gm6WM9hDERFO+8ASfgwNqGJkZQjABrHSoY+dp8PEOqA=;
        b=A0tW7cBYVTBbk4/OGxo7p7TX9vbmu3nihl3xRQxabibyWP8JCSwapJDOv0U5ez/B7q
         9ZpqLuxj222EyJrfebfx83YvFysxF3AVeuBHvPoeneEz/dTgdIO78Ap47jLgPAJ1C2u0
         C68Ct0nJvS/dKmykmI5xJMtsvxiG6MkYcMz5U+Hrpm6KCK/7kNFuBKnvG9/u0M3U9QDb
         a9bHLWC1DOgGxxnPa7Gl5ygccxj6S3DKTjsKmGQqRdg/F6+wDEFTMfJVzwx+WgvUzLj7
         PsD+5WvkpayUOB/XoYR/kHDArYhHqmfv3m71jkg88AIbOYpkZJHQy+0W+8y/Gjbr6Pb5
         ttAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Gm6WM9hDERFO+8ASfgwNqGJkZQjABrHSoY+dp8PEOqA=;
        b=wFiQMyy8vX3tcUzYP6O/HyOSM/aYfb2qEOlit3ZTbID3TeSPZYmyshGCQYgvNLWM0R
         jrJqHYwzuI/6fjd3u2hClZeBMBaZWh+j6uBi+eAF9RWF9ZI/2OwKbNoA/tsv0NX6nAmp
         Us39zS8kZiyzOHegXgcdy/ynUdBWAC+cqT/OM6YoszIYwuGuTUygT8J1X62TgRKA+7mG
         yov5NpPrnPK+IEDCKIIZmMx9C9CAbHM0coIPuJZwcxg6M3aG0Wl02EuaSZu0p2+fuZad
         FDxGsNcNFEgMN9jqhqFUqjhLFIgAjvR54AwjYO32sPl+50X7OtZ3IRA5beKkaHM6HCd3
         BClw==
X-Gm-Message-State: AJIora+XyW9p/Toz63qqEoaXa7ILHhlH6PsT78HCTX1jDZ0FJe25xMR0
        Jh/wHjijwoa+cjgx2PzRg2V9LA==
X-Google-Smtp-Source: AGRyM1vnNMUj1Yojr03HQ23q3BKKyDBLNwlrE0ptf5QVzHWvINAz08pbCRuFm0bnJQpWgleIKveIiQ==
X-Received: by 2002:a63:854a:0:b0:419:64c6:5f9e with SMTP id u71-20020a63854a000000b0041964c65f9emr4628625pgd.139.1657746698979;
        Wed, 13 Jul 2022 14:11:38 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id z9-20020aa79e49000000b005253bf1e4d0sm9303668pfq.24.2022.07.13.14.11.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 14:11:38 -0700 (PDT)
Date:   Wed, 13 Jul 2022 21:11:34 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jinpu Wang <jinpu.wang@ionos.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>,
        kvm@vger.kernel.org
Subject: Re: 5.10.131-rc1 crash with int3: RIP 0010:xaddw_ax_dx+0x9/0x10 [kvm]
Message-ID: <Ys81Bor99YlUrM0k@google.com>
References: <CAMGffEm9y0wnn8LNS9Qo3obPhs0GD5iJZ0WejFzC4baGPDsYTw@mail.gmail.com>
 <CAMGffEnTobhKvwKcRTnSz1JgNBVeTTtbOvP2OtAMgceqOOhN4A@mail.gmail.com>
 <Ys7CFYqA62YcIFiT@kroah.com>
 <CAMGffEmdqz-ggqkHOwddu7bTPBs47tY-5cSi58qvYwPmxrYumg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMGffEmdqz-ggqkHOwddu7bTPBs47tY-5cSi58qvYwPmxrYumg@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 13, 2022, Jinpu Wang wrote:
> On Wed, Jul 13, 2022 at 3:01 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Wed, Jul 13, 2022 at 02:26:44PM +0200, Jinpu Wang wrote:
> > > On Wed, Jul 13, 2022 at 12:49 PM Jinpu Wang <jinpu.wang@ionos.com> wrote:
> > > > #5.10.131-1+feature+linux+5.10.y+20220712.1850+30f4172c~deb11

...

> > > > [ 1895.979325] Call Trace:
> > > > [ 1895.979325]  ? fastop+0x59/0xa0 [kvm]
> > > > [ 1895.979326]  ? x86_emulate_insn+0x73a/0xe00 [kvm]
> > > > [ 1895.979326]  ? x86_emulate_instruction+0x2d0/0x750 [kvm]
> > > > [ 1895.979326]  ? vmx_vcpu_load+0x21/0x70 [kvm_intel]
> > > > [ 1895.979327]  ? complete_emulated_mmio+0x236/0x310 [kvm]
> > > > [ 1895.979327]  ? kvm_arch_vcpu_ioctl_run+0x1744/0x1920 [kvm]
> > > > [ 1895.979327]  ? kvm_vcpu_ioctl+0x211/0x5a0 [kvm]
> > > > [ 1895.979328]  ? __fget_files+0x79/0xb0
> > > > [ 1895.979328]  ? __fget_files+0x79/0xb0
> > > > [ 1895.979328]  ? __x64_sys_ioctl+0x8b/0xc0
> > > > [ 1895.979329]  ? do_syscall_64+0x33/0x40
> > > > [ 1895.979329]  ? entry_SYSCALL_64_after_hwframe+0x61/0xc6

...

> > > > Is this bug known, any hint how to fix it?
> > > I did more tests on different Servers, so far all the machine
> > > checked(Skylake/Icelake/Haswell/Broadwell/EPYC) crash immediately
> > > except AMD Opteron.
> > > kvm-unit-tests succeeded without regression.
> >
> > Same issue on Linus's tree right now as well?  Or does that pass just
> > fine?
> 
> Hi Greg,
> 
> I haven't try linus tree, but just tried 5.15.55-rc1 on Intel Skylake,
> it crashed the same.
> 
> I will give Linus tree a try.

Looks like fastop() got broken by the retbleed mitigations, i.e. this isn't unique
to stable trees.

https://lore.kernel.org/all/20220713171241.184026-1-cascardo@canonical.com
