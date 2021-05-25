Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B15E938F6E8
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 02:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbhEYARa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 20:17:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbhEYAR3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 20:17:29 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F443C061574
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 17:16:01 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id 69-20020a9d0a4b0000b02902ed42f141e1so26933429otg.2
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 17:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1QLVvyqxVOa/mtzZxUM6jA3sXjNPTa5b5e6kLiT/T9U=;
        b=cRUPv9f8BvBWYi60DTkohK+SNsGnDVtcWSqmn5XqynRjNtg2NstnYwWGobFZJa2gIl
         LXy51yaGKBtDDJqs2c49YNtBzCiIRmVSTKItXAzIyUior671QWhIRoEQ++On4APsoPVP
         qD1hEeNb+jqODJkJHt/Xtkdk4r1/+VvzLwMmA0tIPQFIGoRkEY0caKNhwQjZUfFqEyLs
         ugp1mnIFb8lXqDEq6AMiMq0HTEnAfYICUW4sP9oaTFJf7PJyKjfvgYE6objvw385ACaL
         084F+VMlOT5Hf6AkDuZNW+WH5lP+nXqR/vl1tnM7ewBh+lABFn4g9G9jNCR1tNNV5Ygu
         2tKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1QLVvyqxVOa/mtzZxUM6jA3sXjNPTa5b5e6kLiT/T9U=;
        b=EVf8f24W0WUB0YXHfSVmxxd5atKbMFbwbwQzB1R691XOf14tMim+FevOK8E4U+xYU8
         fsg6YZ9/xIMMnKKtK4AVEJ8DOplZo9poNy6wH1MgpesqDpLIa789N+7JSni63lwEysfK
         uAJE5Ifa3jNSIUpSE4Xq2DCSDrjkabu2HT/J+U4RzqwGT1yH7XVy3DufAKEzwW5/gL3N
         Z0VG55otcv2O+KxWSL82eOwcC3RNq6rOI2NsA1zMlDfJXLqFFuTRBH3/owgEb8+SN5ca
         /CAAKgG6lnDW0MX+cAUczgbAu992Bipv5entbNhPCzpOnbNErN8C6HMEn/woD54oVQHC
         D4zw==
X-Gm-Message-State: AOAM532gFudwTs1nSnEuBfFZsas4ohjimRFB+jn/9PWv98EVEfWIFVDO
        eZKD5MS/5igliMzP3k54LyJDhH9P+fD0hb9JczP7Cw==
X-Google-Smtp-Source: ABdhPJxYfaPRPvsbsdMA6+gait8XjTeknj+6xDfj123jodCoKcFiLuZkxAc9fCqPjT8noAp65fnaz5PinpQm3Y9D1p4=
X-Received: by 2002:a9d:684e:: with SMTP id c14mr20959920oto.295.1621901760391;
 Mon, 24 May 2021 17:16:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210520230339.267445-1-jmattson@google.com> <20210520230339.267445-8-jmattson@google.com>
 <YKw1FGuq5YzSiael@google.com> <CALMp9eQikiZRzX+UtdTW4rHO+jT2uo5xmrtGGs1V96kEZAHh_A@mail.gmail.com>
 <YKw6mpWe3UFY2Gnp@google.com> <CALMp9eQy=JhQDzk_LYwrOpbv3hhhi_BT=5rwjHpfTuTQShzkww@mail.gmail.com>
 <YKxAsZzO1uQx7sf8@google.com>
In-Reply-To: <YKxAsZzO1uQx7sf8@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 24 May 2021 17:15:49 -0700
Message-ID: <CALMp9eSae040kCsHApTdTgh0wKYiB9kRzgsyQVU7p_FaqwXwGg@mail.gmail.com>
Subject: Re: [PATCH 07/12] KVM: nVMX: Disable vmcs02 posted interrupts if
 vmcs12 PID isn't mappable
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 24, 2021 at 5:11 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Can we instead word it along the lines of:
>
>   Defer the KVM_INTERNAL_EXIT until KVM actually attempts to consume the posted
>   interrupt descriptor on behalf of the vCPU.  Note, KVM may process posted
>   interrupts when it architecturally should not.  Bugs aside, userspace can at
>   least rely on KVM to not process posted interrupts if there is no (posted?)
>   interrupt activity whatsoever.

How about:

Defer the KVM_INTERNAL_EXIT until KVM tries to access the contents of
the VMCS12 posted interrupt descriptor. (Note that KVM may do this
when it should not, per the architectural specification.)
