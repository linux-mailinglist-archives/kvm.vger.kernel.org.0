Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F34F7BE2DB
	for <lists+kvm@lfdr.de>; Mon,  9 Oct 2023 16:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230345AbjJIOcu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 10:32:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbjJIOct (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 10:32:49 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACB0799
        for <kvm@vger.kernel.org>; Mon,  9 Oct 2023 07:32:48 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-5788445ac04so2843966a12.2
        for <kvm@vger.kernel.org>; Mon, 09 Oct 2023 07:32:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696861968; x=1697466768; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=c58kk/+pxIX/wrMYI0UdcO/2SV8ZUW4S1dCgLTiDEi4=;
        b=oIXGuLWNgIALv7bwptDx4vgtBF02AS/hY4Me/jy7GCA/z4H+w9yy8phvJDHzpOk1qN
         GjyAfs07Jsi2f/du72jYu7/le4I75MtuohSXdf/8pcgqiBXGvl4/BXW+/ghFYxs2rf/u
         gA7lAKqxPFLx0WMPhM5zSDY1G7EmOix/JSO03dW7zPgCdrLZMs1kK2vmf2zUTrl9As9F
         aBe00hSwM9LhLQiwofc15PObcfn+pfUdfpmKrDKixdsTi7o7X7a60B/Nic+oZIbtYzRf
         YcsxvnXoeTBDzhDEFsEOIX2mJmMFE5cWlwHP4+wF0rYUTIbw+Emh6fT/NzjRCFZ0ii1o
         dYNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696861968; x=1697466768;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c58kk/+pxIX/wrMYI0UdcO/2SV8ZUW4S1dCgLTiDEi4=;
        b=qAXnnVsNSulHNwmWQL2efRsBQZm/efEhftGn4HQmjCc8VSJ2Niz42y9CL3peDQVYzS
         njF3x5ot/D9OETVJszQR02514Lv0TbiN7QbauZLKex7+DO0UgBsFrE7O5aLvPyge9PxO
         5eHUH8gIHuUNECw8gr8sl45xYkQM85ZUP6LrMtpEZSEO+KxzlfEilP0rc6hlu7rffTHR
         8OQWvDyG4Nm8lZp6kS1JEgfMLc0EtY422P2fB3WRVdbwrh1lE0f3Uz+Ju5D0msbmvUXN
         dSEX9TKfx91cYQ1f2Qa0Wuefa52QdiNUuzxXII2HJVic/F+tTJTaUVgBDrFda37BP1zH
         FsoA==
X-Gm-Message-State: AOJu0YxeTm6AlfjwOWLODwohW1AulkyArbSQ+RStqWfriAw5nBwokr7z
        W3Te588+Cuf0emGcwd9njIvB3RRoKc0=
X-Google-Smtp-Source: AGHT+IEkG7CXmGWBJDEtRIxaHGoTJv25qNTnHKWgrrf4vzhbjG1MtDAFz9iFLuRr4aMIGPWlKlgzdh/YLxA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:4802:b0:274:6746:7ed with SMTP id
 a2-20020a17090a480200b00274674607edmr264620pjh.4.1696861968170; Mon, 09 Oct
 2023 07:32:48 -0700 (PDT)
Date:   Mon, 9 Oct 2023 07:32:48 -0700
In-Reply-To: <20231009022248.GD800259@ZenIV>
Mime-Version: 1.0
References: <20230928180651.1525674-1-pbonzini@redhat.com> <169595365500.1386813.6579237770749312873.b4-ty@google.com>
 <20231009022248.GD800259@ZenIV>
Message-ID: <ZSQO4fHaAxDkbGyz@google.com>
Subject: Re: [PATCH gmem FIXUP] kvm: guestmem: do not use a file system
From:   Sean Christopherson <seanjc@google.com>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 09, 2023, Al Viro wrote:
> On Thu, Sep 28, 2023 at 07:22:16PM -0700, Sean Christopherson wrote:
> > On Thu, 28 Sep 2023 14:06:51 -0400, Paolo Bonzini wrote:
> > > Use a run-of-the-mill anonymous inode, there is nothing useful
> > > being provided by kvm_gmem_fs.
> > > 
> > > 
> > 
> > Applied to kvm-x86 guest_memfd, thanks!
> > 
> > [1/1] kvm: guestmem: do not use a file system
> >       https://github.com/kvm-x86/linux/commit/0f7e60a5f42a
> 
> Please, revert; this is completely broken.  anon_inode_getfile()
> yields a file with the same ->f_inode every time it is called.
> 
> Again, ->f_inode of those things is shared to hell and back,
> very much by design.  You can't modify its ->i_op or anything
> other field, for that matter.  No information can be stored
> in that thing - you are only allowed to use the object you've
> passed via 'priv' argument.

Yeah, we found that out the hard way.  Is using the "secure" variant to get a
per-file inode a sane approach, or is that abuse that's going to bite us too?

	/*
	 * Use the so called "secure" variant, which creates a unique inode
	 * instead of reusing a single inode.  Each guest_memfd instance needs
	 * its own inode to track the size, flags, etc.
	 */
	file = anon_inode_getfile_secure(anon_name, &kvm_gmem_fops, gmem,
					 O_RDWR, NULL);
