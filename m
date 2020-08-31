Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8AD2583C9
	for <lists+kvm@lfdr.de>; Mon, 31 Aug 2020 23:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726493AbgHaVzi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Aug 2020 17:55:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbgHaVzi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Aug 2020 17:55:38 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05232C061573
        for <kvm@vger.kernel.org>; Mon, 31 Aug 2020 14:55:37 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id x19so2351062oix.3
        for <kvm@vger.kernel.org>; Mon, 31 Aug 2020 14:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=84DMeqLWMZLXgq8dKERsXS1jBRc2KzOHHMEa8pMDmp8=;
        b=I60XwX5CKyxuBUqABV55icGnOQTbIcdX264Ip18psbunR5m8GztOn0Bc0TcNIqi9QC
         S+BLZTmA0K38YfIxoIxUkIMaz7bzNkT1GgZlXj4UL1GTY6HVjwA+sRUTNMtwqNkAZKdc
         WFFD7yGtmR09g8X9Wvf0SdYtkb3OzXa0UyFlfrn2pEOULv5hLm9Gy1dgpafiSRdC5vHB
         LG+GfV+4QwsohzyA1xKRF+gQxeZMXcVrWVk7W3BI5Qn2Jsy0Kdi5admwpzKwZ7v09qoT
         a/2izpIdM00uuc3/VEjS0QKA0LPcBVJgneB1rOU2XziOhA0uOgoVJ6oYlCdppnxgl+BS
         p7/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=84DMeqLWMZLXgq8dKERsXS1jBRc2KzOHHMEa8pMDmp8=;
        b=h3YQgf8D1TJBUcvesdIJeY8nttVbY0feu3p6MnnlWDaH9ABEnSsQUjAKnnQp6K6DF3
         bKh4LfzsuHdsfGABScV/eaBQ9Ka9PmjSDKBKKM1jNav9/yDJK2CuTyw95L52dEnlEB8B
         sUvn18Y/PmcIfQd4gJJxC3LlCzFnm+eSfkDXTxmSZXJtQtAaGreMVagv5/BJtv8ZnLdH
         NCnLYtl29MZSFT/9XVCCV5b9Yb6aGETWwD+/8T+g65LSHCVd6TWjs501vqRFM7+M1qVd
         l7qvDxJy6uOv7BC1N3rz7brF3JWc1rovscz8yF/m/UhHVobrmfc2iajz/GSYAlDi6HI6
         wwWQ==
X-Gm-Message-State: AOAM532srtkc1LVz6hQdb8yyPgt2NiYmgrlOdwO5sG4vTc8lF0LdbAY0
        WmPZhfHu7pzKTQUb/t/pQsXk0WbgzOYjZtP7oYfeiQ==
X-Google-Smtp-Source: ABdhPJxPi5Mlp39kLKvQBqniuDyh4lo2ib9Csmail2Y/Ku44A8ciRFnoUMai0GccKzV4qSniqzbvcvske7TeObxrPhg=
X-Received: by 2002:aca:670b:: with SMTP id z11mr831918oix.6.1598910936624;
 Mon, 31 Aug 2020 14:55:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200829005720.5325-1-krish.sadhukhan@oracle.com>
In-Reply-To: <20200829005720.5325-1-krish.sadhukhan@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 31 Aug 2020 14:55:25 -0700
Message-ID: <CALMp9eSiB=NkuZJV+m-j-KcxqVzkqTf5fUS7r9vBSaY8TyK_Rg@mail.gmail.com>
Subject: Re: [PATCH] nSVM: Add a test for the P (present) bit in NPT entry
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm list <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 28, 2020 at 5:57 PM Krish Sadhukhan
<krish.sadhukhan@oracle.com> wrote:
>
> If the P (present) bit in an NPT entry is cleared, VMRUN will fail and the
> guest will exit to the host with an exit code of 0x400 (#NPF). The following
> bits of importance in EXITINFO1 will be set/cleared to indicate the failure:
>
>         bit# 0: cleared
>         bit# 32: set

This seems like a terrible commit description. First, the P bit can be
cleared in a plethora of NPT entries without having any effect on
guest execution. It's only if the guest tries to access a GPA whose
translation uses the non-present NPT entry that there is an issue.
Second, the VMRUN does not fail. If the VM-exit code is anything other
than -1, the VMRUN has succeeded. Third, the bits in EXITINFO that get
set/cleared depend very much on the actual access. Yes, if the nested
page walk terminates due to a non-present page, bit 0 will be cleared.
However, bit 32 will only be set if the non-present page was
encountered while translating the final guest physical address (not
the guest physical address of a page table page encountered during the
 walk). Moreover, older AMD hardware never sets bits 32 or 33 at all.
Bit 1 will be set if the access was a write (or a page table walk).
Bit 2 will be set for a user access. Bit 4 will be set for a code read
(while translating the final guest physical address).
