Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 537226D68FF
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 18:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233656AbjDDQgT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 12:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233721AbjDDQgS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 12:36:18 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3735A3C3D
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 09:36:15 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id m10-20020a17090a4d8a00b0023fa854ec76so15997548pjh.9
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 09:36:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680626174;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oNRBlvN0u0G9tyMlVigl/3J1bezeDHnWSng1sE6joE4=;
        b=hSP43CIyZHT+OrWLOKa4cLSRmgU4hJRkDyq7PN+T/X29gtAxl8rX62zv0m+fu4MoiS
         sYDzD+fQtfszvWMdD5zs3dGoAfSodOkPFEYPda7QgR83hVvjxhZtq6Ix4iTds0Ozy32E
         YdZ4pscYnJcIibU4nD9k4vmStnVYbeGB8q6Fp4bSmaHmqwEDj9k3W38siZj8414RaOfL
         E6RVWLHlYw14dwcdj8Q0Dj2DtIqRaGdgfBWO7AooOgnZw+I1ZWSCj75R/Ovp+egcx48n
         M6SAIxa7W0xKifkMtxX6upXdExAgTWL2TXSu2Nn5BAA0iVyijyV09cL2UsOrWkXfIwKn
         Dtcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680626174;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oNRBlvN0u0G9tyMlVigl/3J1bezeDHnWSng1sE6joE4=;
        b=tRhreZmf27Id8cSEEeYuqDdUyPmgNBcZ9muCKQFWuA+KUx+uloHYCrCWaOeHjqKThH
         5WjKTH7PcDgHNF0gknRDOyXdMbTVq/Uf76vpfXfrUU68AZQYRRW9GhFawibf6t83kfiA
         wPhATE5ywPLRIUx8ykOVn7Ea6Peq83P3PTuApiIHlEQPloDxHDzc8j/K0xPp6tF1vd/e
         M2Mi+lxdzxQfHdA+coCKNsCFFr7PIX3Fmb7HAxFntwtE0QOFJkIJEt7PZ3pFvqnQA3ra
         blEIg61FcVmhP8cNebKq4daKOe5kgSGgQwrKIOM0WrdGtEYG0TdFbBPGZSqv2Rw6jon7
         hufg==
X-Gm-Message-State: AAQBX9c9RFDFR4vHHyVOgziXIsEFChXO5yYsvNLvJBjDs+L1SPgxdQHw
        MdTkQXpBiDy3efRuSrhRpUlhcMvf6E0=
X-Google-Smtp-Source: AKy350ZH7B7JOGnAXTMbS96lE7FJhtgc+aB2oXKUlL+zE2+zviCC+ztgMIhBEH/FL6djR+zKWnpKK1u33ao=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:4344:0:b0:514:1e2c:4a3b with SMTP id
 k4-20020a654344000000b005141e2c4a3bmr668246pgq.10.1680626174743; Tue, 04 Apr
 2023 09:36:14 -0700 (PDT)
Date:   Tue, 4 Apr 2023 09:36:13 -0700
In-Reply-To: <ddadeb78-52ff-4120-499e-e2bdac31a036@grsecurity.net>
Mime-Version: 1.0
References: <20230403105618.41118-1-minipli@grsecurity.net>
 <20230403105618.41118-4-minipli@grsecurity.net> <ZCtpgGaRN+B91B3G@google.com> <ddadeb78-52ff-4120-499e-e2bdac31a036@grsecurity.net>
Message-ID: <ZCxR/Q2VwDWd/fzt@google.com>
Subject: Re: [kvm-unit-tests PATCH v3 3/4] x86/access: Forced emulation support
From:   Sean Christopherson <seanjc@google.com>
To:     Mathias Krause <minipli@grsecurity.net>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 04, 2023, Mathias Krause wrote:
> On 04.04.23 02:04, Sean Christopherson wrote:
> > On Mon, Apr 03, 2023, Mathias Krause wrote:
> >> Add support to enforce access tests to be handled by the emulator, if
> >> supported by KVM. Exclude it from the ac_test_exec() test, though, to
> >> not slow it down too much.
> > 
> > IMO, the slowdown is nowhere near bad enought to warrant exclusion.  On bare metal
> > without KASAN and other debug gunk, the total runtime with EPT enabled is <6s.
> > With EPT disabled, it's <8s.  In a VM, they times are <16s and <26s respectively.
> > Those are perfectly reasonable, and forcing emulation actually makes the EPT case,
> > interesting.  And the KASAN/debug builds are so horrendously slow that I think we
> > should figure out a way to special case those kernels anyways.
> 
> You must have a more beefy machine than I do.

I doubt it, my numbers are from a Haswell with a whopping 6 cores (and the core
count should be irrelevant).

> Testing bare metal on a NUC12 (i7-1260P) with kvm.ko loaded with
> force_emulation_prefix=1 and not excluding AC_FEP_BIT from ac_test_bump()
> gives me a runtime of little over 41s with EPT enabled and, funnily, only 9s
> with EPT disabled, as that implicitly excludes the CR4.PKE tests, reducing
> the number of tests to run by a factor of 10 (~38 million tests down do 3.8
> million).

Ah, right, fancy new features.  Running on an Icelake, i.e. with 5-level paging
and PKRU support, is indeed quite painful.

After much fiddling, I think the best option is to add a separate config entry
to enable FEP, and have that entry be nodefault, i.e. a "manual" testcase.  Ditto
for the nVMX #PF variant.  That will allow CI and other runners to enable the
test for compatible configs, e.g. when running on bare metal, without causing
problems for existing setups.  Well, unless there are setups that do a generic
"-g nodefault", but x86 doesn't currently have any nodefault tests so that's
quite unlikely.

The only downside is that the CR0.WP testcase will also become manual only.  We
could obviously have it ignore the opt-in flag, but there's value is containing
it to the opt-in testcase, e.g. it becomes very obvious that emulation is relevant
to the failure when the FEP version fails but the non-FEP version does not.  And
I also think we should mark the VPID-based variants nodefault, as they have 4+
minute runtimes in VMs, i.e. we should encourage use of "-g nodefault" in CI when
appropriate.

I'll post a v4, there are other cleanups needed in the access test, e.g. the darn
thing doesn't use report_summary() and so actually getting it to report a SKIP is
impossible.
