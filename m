Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13D0A648C6E
	for <lists+kvm@lfdr.de>; Sat, 10 Dec 2022 02:48:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbiLJBsT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 20:48:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiLJBsR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 20:48:17 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39E7E2E9C5
        for <kvm@vger.kernel.org>; Fri,  9 Dec 2022 17:48:16 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id o1-20020a17090a678100b00219cf69e5f0so9967370pjj.2
        for <kvm@vger.kernel.org>; Fri, 09 Dec 2022 17:48:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=y+mZaxqrf16SOvU4T4amo68YYff+Aio6hmzF4Lq3mwk=;
        b=cPB1PRjIjqGXgaKo8CMFxdM4garoBeOIt12F0NkqM6Z58Pxof81vbzQCY3Nnhpi4ib
         CoRUuzTDKGWrQ/s1D5JZW+htpjp0EYoqufGG3ZiMU5e27xZA6tple3R6hJjKQf2KCcZu
         nGTxHHmw6CvIegvFKsg4CNaWPFUGWm0ANDZiybEuiVWPCGQ6ek2Q//9HjGCNEk29nTT8
         pzW33RxmGYtrQVnXPs6+dIsvba55W0v/toW8ypWrNPYIXJqjvCevsqBU006hysNRGCY3
         YQDPdvRv0+WkRBMs+prg0IbLHV/brZR/48Zvpt8e9/NhTwmp3bC0lANCvmzHAjyH2mti
         FKaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y+mZaxqrf16SOvU4T4amo68YYff+Aio6hmzF4Lq3mwk=;
        b=FeaiQIICJUKmhhzZkX2ZGZ9+6p1G6CdsF92Vwo8DaV1Sn/nHLilefT+SO9cjmb+y/X
         nr4EhZAmQeI+ANafxz1qrvrgUFVY0yaxsCGAUSsLAclr1aswCPZGucXYGOKDIpp9GZAk
         +y3cNW2NFFYjN3jzEDxIIe8qMBPIj8cY24CUB200dR+kN/f9M9GWB4NQ0n43rhsHK67O
         WyFAKzsx7ZxtN5H/wWdMFA76KPZ36Netfq/dpenKdMfFVbXyYSApEsCiqydQSHL07bFD
         lZffciT5SI2j9d3CNgqwPbdZSqc5XPMgSHM9x4otmYuoEZNeZrtoB1MdoiWX70NzVegG
         b+Ew==
X-Gm-Message-State: ANoB5pmutHzvGnmwkEZLR2aJpA7B5O8o33/3+D+PoqZRFRcCh7cHY2m3
        z5EyvCYjJ3Ae/jbNepOakuhdUw==
X-Google-Smtp-Source: AA0mqf4fMR39Ehk9JSfVhh0GjRlhI2XVjPC//spVAQ5AfeXItJD5XT7p+m66qSVhzJiA2L8HEoBuVA==
X-Received: by 2002:a17:903:40cd:b0:189:858f:b5c0 with SMTP id t13-20020a17090340cd00b00189858fb5c0mr109490pld.0.1670636895607;
        Fri, 09 Dec 2022 17:48:15 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id o14-20020a170902d4ce00b0018999a3dd7esm1925340plg.28.2022.12.09.17.48.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 17:48:15 -0800 (PST)
Date:   Sat, 10 Dec 2022 01:48:11 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Vipin Sharma <vipinsh@google.com>, pbonzini@redhat.com,
        vkuznets@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch v3 12/13] KVM: selftests: Make vCPU exit reason test
 assertion common.
Message-ID: <Y5PlW+U2MblIObHT@google.com>
References: <20221205191430.2455108-1-vipinsh@google.com>
 <20221205191430.2455108-13-vipinsh@google.com>
 <Y5OtpwM8ue8nZwG/@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5OtpwM8ue8nZwG/@google.com>
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

On Fri, Dec 09, 2022, David Matlack wrote:
> On Mon, Dec 05, 2022 at 11:14:29AM -0800, Vipin Sharma wrote:
> > Make ASSERT_EXIT_REASON() macro and replace all exit reason test assert
> > statements with it.
> > 
> > No functional changes intended.
> > 
> > Suggested-by: David Matlack <dmatlack@google.com>
> > Signed-off-by: Vipin Sharma <vipinsh@google.com>
> 
> Reviewed-by: David Matlack <dmatlack@google.com>
> 
> > ---
> >  .../testing/selftests/kvm/aarch64/psci_test.c |  4 +--
> >  .../testing/selftests/kvm/include/test_util.h | 10 ++++++++
> [...]
> >  .../selftests/kvm/x86_64/xapic_ipi_test.c     |  6 +----
> >  .../selftests/kvm/x86_64/xen_shinfo_test.c    |  7 +-----
> >  .../selftests/kvm/x86_64/xen_vmcall_test.c    |  5 +---
> >  44 files changed, 71 insertions(+), 293 deletions(-)
> 
> Nice diff stat :)

I like the diffstat too, but I think we need a slightly different name for the
macro.  "EXIT_REASON" can be interpreted as "hardware exit reason" or "KVM exit
(to userspace) reason".  Most usage will be fairly obvious, but I'd like to avoid
confusion when swapping between selftests and KVM-unit-tests (which often asserts
on the hardware exit reason).   The name will be a bit longer, but I don't think
line length with ever be a problem.  And most people will just copy+paste so finger
fatigue likeliy won't be an issue either.

I also vote to prefix it with TEST, i.e. TEST_ASSERT_KVM_EXIT_REASON(), for
consistency and to make it very clear it's a TEST_ASSERT() wrapper.  ASSERT_EQ()
makes me twitch every time I see it.  This is definitely a personal preference 
(or problem) I can survive with though :-)
