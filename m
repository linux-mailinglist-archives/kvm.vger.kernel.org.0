Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 576A477CF6B
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 17:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234097AbjHOPnH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 11:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238249AbjHOPmv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 11:42:51 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB2DCE61
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 08:42:44 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-589fae40913so25303967b3.0
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 08:42:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692114164; x=1692718964;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RKtpgnCrLH39ceT1K2i8+x/WwYGrtr3gREEHHBCUCew=;
        b=2IdDSzwKd4euPlKpjqtv72Tj4fyLnVBDZMptHpZQiwA9SnLB8e1v7ULYKrf91whAZu
         ZoyuvXSz30bjGI+B8ccl7W/pw8PjfuFRU1p4lUMUrg6JBggD7eMiWeeWxdV417R5EfnQ
         4bDzbhLI1zHHN7lMR/XrurRNEdZV/NBVr0wVZCfXjeOUPcNS0OfAi1aS0KC4USd1K/rg
         nvWCsMWP7v8cDGEkeI7M63GOw0uk9SQUNH6xZgN20Do7Db4XfF8qVz640jMWZxCOdG5W
         16evTBojCWivsMMKq7IGcfTzZ/6kZ+EN1PXv8b6AtTMaoG8CC2vk0HwCVy8WX73ykRQH
         Sblw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692114164; x=1692718964;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RKtpgnCrLH39ceT1K2i8+x/WwYGrtr3gREEHHBCUCew=;
        b=UcFqeICPZPspsVNZEieJKX7Bv6qkLFD3oAXdR8nBbn4LOSAAivTLMez8+XZflnjuC/
         F7HWKnTnk8OM/FjtQsP9iOu8UY074e56BT7s0m3Hk0D4DjSN/cQD+0sODJ/oKo2RZk/v
         89sLKZxBb2F2X+b8nrx4QXAKOvsQxctNhgX69DRuhGvJlynq/Np981gBwTuC5fGuPn2f
         tNqE/YZmoC7TTWhDMnxA8GPNAMf3fBnjPsoZVxahK5LtzLvXfYi0iwl+MjAEnWwvzLtc
         BPU56cso6vGX6E5flsLT/SbmAmnVRK3zBkkObjHf4LdmCLyqPv4gmvfGfMcAn2DCt5ei
         CQ7w==
X-Gm-Message-State: AOJu0YxmQE+hDaJS3/MtzaTqiszmsHACj0RUMdio/X0H3pNn9d1hkLHG
        /E8LjT3LPuP819JGJoc5im1JE9+7r3o=
X-Google-Smtp-Source: AGHT+IE2l6jHNjAvq0XFk/fxxS5+RBhrSACtH+PnKmnpyNeFxItuqLYErtN9a840sHzgs/u9NgD5ysng+CE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ac53:0:b0:579:fc33:b3a2 with SMTP id
 z19-20020a81ac53000000b00579fc33b3a2mr194340ywj.10.1692114164258; Tue, 15 Aug
 2023 08:42:44 -0700 (PDT)
Date:   Tue, 15 Aug 2023 08:42:42 -0700
In-Reply-To: <105d31d9-7e3d-c78d-6878-37d50376f6f5@grsecurity.net>
Mime-Version: 1.0
References: <20230622211440.2595272-1-seanjc@google.com> <105d31d9-7e3d-c78d-6878-37d50376f6f5@grsecurity.net>
Message-ID: <ZNuc8kq57/HhvBn6@google.com>
Subject: Re: [kvm-unit-tests GIT PULL] x86: Fixes, cleanups and new testscases
From:   Sean Christopherson <seanjc@google.com>
To:     Mathias Krause <minipli@grsecurity.net>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
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

On Tue, Aug 15, 2023, Mathias Krause wrote:
> On 22.06.23 23:14, Sean Christopherson wrote:
> > Please pull a variety of (mostly) x86 changes.  There's one non-x86 change to
> > fix a bug in processing "check" entries in unittests.cfg files.  The majority
> > of the x86 changes revolve around nSVM, PMU, and emulator tests.
> > 
> > The following changes since commit 02d8befe99f8205d4caea402d8b0800354255681:
> > 
> >   pretty_print_stacks: modify relative path calculation (2023-04-20 10:26:06 +0200)
> > 
> > are available in the Git repository at:
> > 
> >   https://github.com/kvm-x86/kvm-unit-tests.git tags/kvm-x86-2023.06.22
> > 
> > for you to fetch changes up to e3a9b2f5490e854dfcccdde4bcc712fe928b02b4:
> > 
> >   x86/emulator64: Test non-canonical memory access exceptions (2023-06-12 11:06:19 -0700)
> > 
> > ----------------------------------------------------------------
> > [...]
> 
> Ping! What happened to this one?

Got ignored for so long that it became stale[*] :-/

I'll work on generating a new pull request this week.

[*] https://lore.kernel.org/all/ff259694-eb1b-771a-faaf-b8119b899615@redhat.com
