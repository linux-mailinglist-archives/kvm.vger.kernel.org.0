Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D08D28BE63
	for <lists+kvm@lfdr.de>; Mon, 12 Oct 2020 18:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403905AbgJLQrF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Oct 2020 12:47:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390630AbgJLQrE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Oct 2020 12:47:04 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFD7BC0613D0
        for <kvm@vger.kernel.org>; Mon, 12 Oct 2020 09:47:04 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id y14so13992116pfp.13
        for <kvm@vger.kernel.org>; Mon, 12 Oct 2020 09:47:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=SFBC4Vmd/pl1oRs2gO53yjyBa6WiiY8svm4c3NRg6ks=;
        b=G3pRT0h1R5cst5k67KH0mnTg8kFNo/aXCFVzCkFxE+yAPb4VJwjefAPEue0SdvA4jU
         591zgWWkDIFBmKWMKGAgGaSAYGn31Ucry96GaiIxIXZJcSCvfQGZ2C3dHOW9KhX14gqV
         CB5cSn1oilLW/hnEw2Vd7f7C+tYskfYRoNPVc3kEpi1HWvy3um/n1Jq0qE6/Ke2ER/0Q
         yzqBXeSz2RacT+/tiQbeWlesmoedUbJnyrnJtX4F5Di3iqSbS0fPEbrY5jbmBmcShSut
         PNIfMKNlUiqM5L1q7dwk51eQQtpmXxSAQnUiJdsLXReD/6HMeGnOtvBCTwLs46WVfD6+
         qd7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=SFBC4Vmd/pl1oRs2gO53yjyBa6WiiY8svm4c3NRg6ks=;
        b=Z1PQJfrx6nIgOHDHEvYfPc+xi13i7Za1mHD0Ju9XB5+TG5gSlrQhoWOj2qCx3rMeDY
         eDVz9ioNfZG51PosJhHgLhe1NfcCR72MjD7KnqbcF9/FPJ+yXxQ0spIxfMIPw9e/t1VQ
         sRzMkZ+3UqZvwrE8N7ih8aJWjMcb6oru+904bsH3nRlG/02i4CzvVP1366IJF12EmS+7
         KauX64mg0ueub6E/RXkTI+VeqnXiWWodVBgqKFYmftBw8+5yA07N0j+jZ61jM3+5UaNd
         1rKsR1Aa2E5wIiyRsGc54i/SPGvcX2HzAThwzEOykVUC8Kcg+pBAzTcy3hJ6WEGMmTvd
         OgWw==
X-Gm-Message-State: AOAM531VeWYUUoP+zQY5R96U49g+rRYPN3gxJD6VjyaXtk2gLmfcBYJi
        TQaPe1vZ7WEbN/j5tMLPPrg=
X-Google-Smtp-Source: ABdhPJyTVkcmIcE5MnMLc0OtUnagPjWttR5tMUtE28IjUCOENtLAk84uvAuwLw66DN16EasbJep5yg==
X-Received: by 2002:a63:1449:: with SMTP id 9mr14247357pgu.260.1602521224234;
        Mon, 12 Oct 2020 09:47:04 -0700 (PDT)
Received: from ?IPv6:2601:647:4700:9b2:8cd7:a47f:78d6:7975? ([2601:647:4700:9b2:8cd7:a47f:78d6:7975])
        by smtp.gmail.com with ESMTPSA id y126sm19740591pgb.40.2020.10.12.09.47.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Oct 2020 09:47:02 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [kvm-unit-tests PATCH] x86: VMX: Add a VMX-preemption timer
 expiration test
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20201012163219.GC26135@linux.intel.com>
Date:   Mon, 12 Oct 2020 09:47:00 -0700
Cc:     Jim Mattson <jmattson@google.com>, KVM <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <5A0776F7-7314-408C-8C58-7C4727823906@gmail.com>
References: <20200508203938.88508-1-jmattson@google.com>
 <D121A03E-6861-4736-8070-5D1E4FEE1D32@gmail.com>
 <20201012163219.GC26135@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Oct 12, 2020, at 9:32 AM, Sean Christopherson =
<sean.j.christopherson@intel.com> wrote:
>=20
> On Sat, Oct 10, 2020 at 01:42:26AM -0700, Nadav Amit wrote:
>>> On May 8, 2020, at 1:39 PM, Jim Mattson <jmattson@google.com> wrote:
>>>=20
>>> When the VMX-preemption timer is activated, code executing in VMX
>>> non-root operation should never be able to record a TSC value beyond
>>> the deadline imposed by adding the scaled VMX-preemption timer value
>>> to the first TSC value observed by the guest after VM-entry.
>>>=20
>>> Signed-off-by: Jim Mattson <jmattson@google.com>
>>> Reviewed-by: Peter Shier <pshier@google.com>
>>=20
>> This test failed on my bare-metal machine (Broadwell):
>>=20
>> Test suite: vmx_preemption_timer_expiry_test
>> FAIL: Last stored guest TSC (44435478250637180) < TSC deadline =
(44435478250419552)
>>=20
>> Any hints why, perhaps based on the motivation for the test?
>=20
> This test also fails intermittently on my Haswell and Coffee Lake =
systems when
> running on KVM.  I haven't done any "debug" beyond a quick glance at =
the test.
>=20
> The intent of the test is to verify that KVM injects preemption timer =
VM-Exits
> without violating the architectural guarantees of the timer, e.g. that =
the exit
> isn't delayed by something else happening in the system.

Thanks for testing it. I was wondering how come KVM does not experience =
such
failures.

I figured the basic motivation of the patch, but I was wondering whether
there is some errata that the test is supposed to check.

