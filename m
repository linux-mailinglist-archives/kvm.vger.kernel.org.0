Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7EC6CB7D1
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 09:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbjC1HPb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 03:15:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230228AbjC1HP2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 03:15:28 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B70330F1
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 00:15:27 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id u20so7288350pfk.12
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 00:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679987727;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SiQMQ2XCzDmv/eu0m0m2aUXUlJzPfX9pnKmES6IuxC4=;
        b=pgti5pX68H00wcMydHaWgi7FtBwV+bsuhgq+7Ahks1PJ/jNKmVYvtsP58fyN37/u2O
         KnTTE7TnpG4YChbx6pcHwKf09/zf32YGEgymoKroRHaoRspOjnEk0VKBMGpfv87YwnBP
         jpOpPVbqrj/UoXxWLquQ4OABVnN2SWOgFfc/PzW0TNiiYMsBST3xdY1qeJwhsdh1efa1
         a5ygjCAV6JXTH1flLjrsaYezygdBqTxqja1pvZC6Y9DIyGqKJzIBLoP4C/jmMVjP5qUq
         PlqqdEAP/W+lQKjzSomDL/BxLEsXBOAKYFNzkJt3Fv0xAdYCtND/ci93YvPU0+UPSa7u
         xBPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679987727;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=SiQMQ2XCzDmv/eu0m0m2aUXUlJzPfX9pnKmES6IuxC4=;
        b=HA9z6REPp7QoHbbR0lOuji0dLTsjWvIes4LSd9A+T7Mp8x6k7b5etJ3SVXS+HdguXr
         jAYlfe2/fKxOKT4V8BUaMJd9q+4aJFQmOll/F9/od44Q+bgQJ/K1j55kQvsiRNM4Dygp
         oNi5z6j9lpUOkHLPxCzJjnUffM+oYtyV5mpXN5kaBubTdTeBaf97shdcg+Sv8mdb8bTR
         AT5O+AYpz4we4hZmCk8ZSi6vBdOuAF/750mlsPDXrgmoCGr8jaP4faPLDAwuu8iKfR0F
         pNpFzwPfTbp/Hsj0krYUYaIz4UthnWejdTdNMf6AfJepwEHGJEdVe2UHb6+/+wy9dlai
         v/pg==
X-Gm-Message-State: AAQBX9dA6Hz0VTPyhMMpahPZPsTTV7R2pa1vFOWes2GymRoy8D61bmzp
        62Pnx2VZsPmJ6jFUAosJESznelG8JJ8=
X-Google-Smtp-Source: AKy350bM7EyA8ugscjz3rbNrkZy7EsBR3kG3B18yj0jYJMbnWE440HLAe0kwKxeh4j6JL20VMbQeKQ==
X-Received: by 2002:a05:6a00:4e:b0:626:cc72:51ac with SMTP id i14-20020a056a00004e00b00626cc7251acmr14222944pfk.30.1679987726736;
        Tue, 28 Mar 2023 00:15:26 -0700 (PDT)
Received: from localhost (118-211-28-230.tpgi.com.au. [118.211.28.230])
        by smtp.gmail.com with ESMTPSA id i10-20020aa78d8a000000b006281bc04392sm12616676pfr.191.2023.03.28.00.15.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Mar 2023 00:15:25 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 28 Mar 2023 17:15:21 +1000
Message-Id: <CRHTY0VSZ8LW.18YSL5NHOOO2A@bobo>
Cc:     <linuxppc-dev@lists.ozlabs.org>,
        "Laurent Vivier" <lvivier@redhat.com>,
        "Thomas Huth" <thuth@redhat.com>
Subject: Re: [kvm-unit-tests v3 00/13] powerpc: updates, P10, PNV support
From:   "Nicholas Piggin" <npiggin@gmail.com>
To:     =?utf-8?q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>,
        <kvm@vger.kernel.org>
X-Mailer: aerc 0.13.0
References: <20230327124520.2707537-1-npiggin@gmail.com>
 <bdc241df-d9b8-a742-982b-21a5b4feb2a4@kaod.org>
In-Reply-To: <bdc241df-d9b8-a742-982b-21a5b4feb2a4@kaod.org>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue Mar 28, 2023 at 2:09 AM AEST, C=C3=A9dric Le Goater wrote:
> On 3/27/23 14:45, Nicholas Piggin wrote:
> > This series is growing a bit I'm sorry. v2 series added extra interrupt
> > vectors support which was actually wrong because interrupt handling
> > code can only cope with 0x100-size vectors and new ones are 0x80 and
> > 0x20. It managed to work because those alias to the 0x100 boundary, but
> > if more than one handler were installed in the same 0x100-aligned
> > block it would crash. So a couple of patches added to cope with that.
> >=20
>
> I gave them a try on P9 box

Thanks!

>
> $ ./run_tests.sh
> PASS selftest-setup (2 tests)
> PASS spapr_hcall (9 tests, 1 skipped)
> PASS spapr_vpa (13 tests)
> PASS rtas-get-time-of-day (10 tests)
> PASS rtas-get-time-of-day-base (10 tests)
> PASS rtas-set-time-of-day (5 tests)
> PASS emulator (4 tests)
> PASS h_cede_tm (2 tests)
> FAIL sprs (75 tests, 1 unexpected failures)

Oh you have a SPR failure too? I'll check that on a P9.

> FAIL sprs-migration (75 tests, 5 unexpected failures)
>
> And with TCG:
>
> $ ACCEL=3Dtcg ./run_tests.sh
> PASS selftest-setup (2 tests)
> PASS spapr_hcall (9 tests, 1 skipped)
> FAIL spapr_vpa (13 tests, 1 unexpected failures)
>
> The dispatch count seems bogus after unregister

Yeah, that dispatch count after unregister test may be bogus actually.
PAPR doesn't specify what should happen in that case. It was working
here for me though so interesting it's different for you. I'll
investigate it and maybe just remove that test for now.

>
> PASS rtas-get-time-of-day (10 tests)
> PASS rtas-get-time-of-day-base (10 tests)
> PASS rtas-set-time-of-day (5 tests)
> PASS emulator (4 tests)
> SKIP h_cede_tm (qemu-system-ppc64: TCG cannot support more than 1 thread/=
core on a pseries machine)
> FAIL sprs (75 tests, 16 unexpected failures)

These should be TCG errors. I have it passing them all with patches
posted to qemu lists. Very simple but effective way to catch a few
classes of errors.

Thanks,
Nick
