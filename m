Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E86B7BEB79
	for <lists+kvm@lfdr.de>; Mon,  9 Oct 2023 22:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378580AbjJIUUM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 16:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232645AbjJIUUK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 16:20:10 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44966A3
        for <kvm@vger.kernel.org>; Mon,  9 Oct 2023 13:20:09 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d9a4a89ab5fso414881276.3
        for <kvm@vger.kernel.org>; Mon, 09 Oct 2023 13:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696882808; x=1697487608; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=X6+GJ5cI4z2TlJw5nJFvkv7FETWY362gjhrvcMB9XFc=;
        b=LYMPNRYaGtJ0B7jCpzJLOeAOt4N5rEjxApu3zMBe7oeVCCTl5ExTQEGkDjkQ2VquMi
         5JzYk5VrNtmkSZEbCJr7LuTLXgPgdswazaskUq4r/nb2MwvQlY/7bin9K4mSEOb1nh23
         aQGNHQR5OCxv8ouCA5FnKE6fg5l2yOVe8wE0MnBeOdtEv7qlv4UWIW+YwoP7fCYOmhM7
         IcxngCv54vmqWR2K7rpaTfwzdEBwnwv880xHoxJbZg5AP9sNmeXJ1XIbmh7dlza/cfMf
         uAMOiB3KSGkQK0ZsaI/eD8AuVIIoMseYxZAZliaW6DQNB32qGbBHGpSYxiTQAKR6ts1H
         BB/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696882808; x=1697487608;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X6+GJ5cI4z2TlJw5nJFvkv7FETWY362gjhrvcMB9XFc=;
        b=kdARCbZyVA4ymuNB7nDE6X98q/IrP7RSQcJvdc3EhR5mDS9V1hGmYnIC3mvdOUSy9k
         1Uk/0sDAnzUdyFA7jGebRUJ6BWePv8bu6ClJ0y2UrSJx6chvLRZ/Pt9RkaCkvEwwb28X
         Rho1WAkWXngzrSSaDzsTkRATPrvf3xADxi7qmdBQRGTv9bIN9JvNDgQjiMJVyAYl535j
         yuGU1UINbUQgySevS5cE9mPmQS+8s6rRofmsJVepyToV9emnUfpve9ekcH5NNqJnTjkI
         7PJTbeQmT0UvTfeawR/6mnSQfNchUMDP2Cde3WwaOvT5K9O5D1MQyCT+X/fkwnySyIHd
         Ylcw==
X-Gm-Message-State: AOJu0Yw+p5OtuOVXeonV8OMIroiejLiG0TFuIr1LSaI2o292TsJcS4Q7
        TlZ+qGFERG/bkxmap9X9nB3mNGXtf3c=
X-Google-Smtp-Source: AGHT+IFY1JX42tQvUiQbHjxHOd20j5m7plZ8L4JheDy574ZvKTNtyQEZK75VDZPRx5P3o6rzL4rbdqXGQyM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a5b:b50:0:b0:d80:904d:c211 with SMTP id
 b16-20020a5b0b50000000b00d80904dc211mr241176ybr.7.1696882808446; Mon, 09 Oct
 2023 13:20:08 -0700 (PDT)
Date:   Mon, 9 Oct 2023 13:20:06 -0700
In-Reply-To: <20231009200608.GJ800259@ZenIV>
Mime-Version: 1.0
References: <20230928180651.1525674-1-pbonzini@redhat.com> <169595365500.1386813.6579237770749312873.b4-ty@google.com>
 <20231009022248.GD800259@ZenIV> <ZSQO4fHaAxDkbGyz@google.com> <20231009200608.GJ800259@ZenIV>
Message-ID: <ZSRgdgQe3fseEQpf@google.com>
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
> On Mon, Oct 09, 2023 at 07:32:48AM -0700, Sean Christopherson wrote:
> 
> > Yeah, we found that out the hard way.  Is using the "secure" variant to get a
> > per-file inode a sane approach, or is that abuse that's going to bite us too?
> > 
> > 	/*
> > 	 * Use the so called "secure" variant, which creates a unique inode
> > 	 * instead of reusing a single inode.  Each guest_memfd instance needs
> > 	 * its own inode to track the size, flags, etc.
> > 	 */
> > 	file = anon_inode_getfile_secure(anon_name, &kvm_gmem_fops, gmem,
> > 					 O_RDWR, NULL);
> 
> Umm...  Is there any chance that your call site will ever be in a module?
> If not, you are probably OK with that variant.

Yes, this code can be compiled as a module.  I assume there issues with the inode
outliving the module?
