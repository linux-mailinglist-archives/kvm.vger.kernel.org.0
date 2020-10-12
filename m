Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5477B28BF80
	for <lists+kvm@lfdr.de>; Mon, 12 Oct 2020 20:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390828AbgJLSQh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Oct 2020 14:16:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389885AbgJLSQh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Oct 2020 14:16:37 -0400
Received: from mail-oo1-xc43.google.com (mail-oo1-xc43.google.com [IPv6:2607:f8b0:4864:20::c43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 880E3C0613D0
        for <kvm@vger.kernel.org>; Mon, 12 Oct 2020 11:16:37 -0700 (PDT)
Received: by mail-oo1-xc43.google.com with SMTP id o20so4277627ook.1
        for <kvm@vger.kernel.org>; Mon, 12 Oct 2020 11:16:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iUAJKW6hddojVyqh8dZ17EQuKVGjDKTcIVQSo3DvGY0=;
        b=jUGlRAHx9t4hlUWIl6vgZ9RvE7VQO7uW8YCiNz9p9v2A0p0YpOokDMj7gCd2Za1PaY
         gDvcSli7lnw04U3crAOsNSbz2XP4CprmhX7z3dan+H+B1etKiqTzWNFT/Zsm4D4YcWiC
         DoBTzCIcZynEuH6KwoiYNfWSjxFnEknZg7S7eCVeJHtDcbSirj9uf6zittl+YRRK2nIb
         9I7XJ1jxthtH5WjX4r9bw3HddhOQu5XP5yicgeUoMWxxju4KBRnR63nIr5JkHydXY6Zm
         6ULysluMwsw+l/HShjmkBtYvcE53Zly7zrSaVzzVIPXq/c0PLZG/UMwqJFlr94n9/rB6
         KbuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iUAJKW6hddojVyqh8dZ17EQuKVGjDKTcIVQSo3DvGY0=;
        b=fEVPi+cn6kd7qNl6kqbrAgLKaQiKi2Y8fCbrWEWd0dtWQTnS7ff2ehOSOJlg2MIXu9
         qpV7gtnmvCKRn/i/mWQPD1lNdNqpbMbooTRqGBf0mBtrwghlGpKLRNkIvTwXSwVQh3xC
         fMNvoTdRjIfnKPgtn0XtKWDVbXYWP1YYd4blIVJtsndwZxZAaAqMp3IF5wUqbmXakt6X
         PSdwnRrMfXcsEJEE7zYrm6t20oGFRmyhxryNvNtyCmj/Idp5i0oytsrZeopNx8IUQY7t
         nERVi35M127sRn0o2KIAHYGGzX5x7Bt8ZheFQQwgE5/q6AeNAzS0gWjJxPsoX+xgPF8Q
         eQQQ==
X-Gm-Message-State: AOAM530uMBl9MAGRm/iXAUyA4QMydxECHXU4faIsbnHPQwApbwf+Sxwj
        5mHWsBaA/B05+soW/rSDghImfWfzqPClfm3aMXASCpBsqsE=
X-Google-Smtp-Source: ABdhPJz/nCbxBgLQ8VfFTLChSymaXzsfNsbFUqJJSXeoKYczfE3SfLBMhhiMuPrqnDy3odDvLay70ThIS2k/DwdlYNM=
X-Received: by 2002:a4a:b811:: with SMTP id g17mr2897504oop.82.1602526596603;
 Mon, 12 Oct 2020 11:16:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200818002537.207910-1-pshier@google.com> <4A2666E9-2C3F-4216-9944-70AC3413C09B@gmail.com>
 <7C2513EE-5754-4F42-9700-7FE43C6A0805@gmail.com>
In-Reply-To: <7C2513EE-5754-4F42-9700-7FE43C6A0805@gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 12 Oct 2020 11:16:24 -0700
Message-ID: <CALMp9eQBgJwLLk-9in=v1wwrj2_p5T3aLfaj79Y6Yzh+CEE1SA@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86: vmx: Add test for MTF on a guest
 MOV-to-CR0 that enables PAE
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Peter Shier <pshier@google.com>, KVM <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Oct 10, 2020 at 2:52 AM Nadav Amit <nadav.amit@gmail.com> wrote:

> I guess that the test makes an assumption that there are no addresses
> greater than 4GB. When I reduce the size of the memory, the test passes.

Yes; the identity-mapped page used for real-address mode has to be
less than 4Gb.

I think this can be fixed with an entry in unittests.cfg that specifies -m 2048.
