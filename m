Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3836621AF4
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 18:45:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234373AbiKHRpQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 12:45:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234116AbiKHRpP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 12:45:15 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E7E254B10
        for <kvm@vger.kernel.org>; Tue,  8 Nov 2022 09:45:14 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id o70so18206142yba.7
        for <kvm@vger.kernel.org>; Tue, 08 Nov 2022 09:45:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=yA7pydEspZBBPyifImk/4u2PUu7iL2nAKzA6SsMSd3g=;
        b=PCIny41ekZYub1NRysqPw75m0nSrvinWBYMDPYLhb6QP25vd+sqG7N76sHdkIIJpT/
         mA4kxxhGjyBpbF8TBFmO+VunUKcQOti/p8ywIpBtqST/Rk5C+D3xUKH2yDOyIRc9DJG3
         pl0GEllrCugPbgkwYla5dglp5AIOFqltQhTPxjaLePOnpTJTkK0O/BtlJqdVCaMbcCgT
         SuzqzoIAa3n/tG/gxONUKaK8e40q24porCgvV/I5FrMookkxTu2O/OkzXjQA9DvMv2GP
         KDwSAEZdTycnVNx+KRhChCZ7vofOzB3Srj/yzWusDjhTVyCSNilt36hTGJkbkG8dHTyG
         y17w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yA7pydEspZBBPyifImk/4u2PUu7iL2nAKzA6SsMSd3g=;
        b=bdqA2ZNoHr2q9hXAlzPGa4pwhJ6PzouTsw88l2YiAye1xMjvQ2SsmptnTvuAnoYR2X
         E/j9Iy5ucqjToTvInRsoPJstbdcftdL+hI3Mn4Yd9DAQYJMN+A5fgoEIaEXWces5mKAg
         k99xuXK4K6C2aUD1FA0UsJhLFKdX/r0wiMH5U7yVV39anwzVp9hHqrzmNHp/WyL140sQ
         PdsBvNHH8q+e2in+DP+aH7sqQJFTj3IC6DX103cziPLO8+uk5kcrml67m52HbWB9S98g
         qIE7fJKbNsg8OY7zGaA8bLfTcvD87l7avIP9k/9+p77XMm6wA94WyGID82P1+GkMVizC
         awtA==
X-Gm-Message-State: ANoB5pkV+G5ZJAjm7XNhqLgsYsMp2h+mxcZFpYXsWZSWrULGJ+pKq9Ow
        u1ly9ol6th4TYDFSLWC8yK52gJVNrL+2KdYGicd1QA==
X-Google-Smtp-Source: AA0mqf75YC0vo4yMSgplwTnddN900v/f0fIN3IfLu2e0EEe7HWMrqG/ATUNoG5ybO/rv99RE/NpuccYE+TYbea+TXMA=
X-Received: by 2002:a25:2458:0:b0:6d5:d9bd:3a20 with SMTP id
 k85-20020a252458000000b006d5d9bd3a20mr14557762ybk.582.1667929513560; Tue, 08
 Nov 2022 09:45:13 -0800 (PST)
MIME-Version: 1.0
References: <20221105045704.2315186-1-vipinsh@google.com> <20221105045704.2315186-7-vipinsh@google.com>
 <Y2lWG7wV+UvzX5jm@google.com> <CAHVum0eM7NtBDRFhXa9pk9DAEere1q4XVTUti2TFZuKPiGK6LQ@mail.gmail.com>
In-Reply-To: <CAHVum0eM7NtBDRFhXa9pk9DAEere1q4XVTUti2TFZuKPiGK6LQ@mail.gmail.com>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 8 Nov 2022 09:44:46 -0800
Message-ID: <CALzav=eX=kCtrRJhVwSJbE9yJm3pi1srf+rd6iX5uSShBzYVPQ@mail.gmail.com>
Subject: Re: [PATCH 6/6] KVM: selftests: Test Hyper-V extended hypercall exit
 to userspace
To:     Vipin Sharma <vipinsh@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, vkuznets@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
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

On Mon, Nov 7, 2022 at 6:05 PM Vipin Sharma <vipinsh@google.com> wrote:
>
> On Mon, Nov 7, 2022 at 11:01 AM David Matlack <dmatlack@google.com> wrote:
> >
> > On Fri, Nov 04, 2022 at 09:57:04PM -0700, Vipin Sharma wrote:
> > > +
> > > +     TEST_ASSERT((run->exit_reason == KVM_EXIT_IO),
> > > +                 "unexpected exit reason: %u (%s)", run->exit_reason,
> > > +                 exit_reason_str(run->exit_reason));
> >
> > Optional: Asserting a specific exit reason is a pretty common pattern in
> > the x86 selftests. It'd be nice to create a common macro for it. e.g.
> >
> >         ASSERT_EXIT_REASON(vcpu, KVM_EXIT_IO);
> >
>
> This is much better. I can add a patch which creates this API.
>
> Should it be run or vcpu? Seems like everything needed is in struct kvm_run{}.

Either one but I suspect vcpu will produce a cleaner final result
since all tests pass around struct kvm_vcpu and only use kvm_run to
check the exit reason. i.e. I suspect you'll be able to delete several
struct kvm_run local variables as part of adding ASSERT_EXIT_REASON().
