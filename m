Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AEAE6BF19D
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 20:24:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbjCQTYI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 15:24:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbjCQTYH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 15:24:07 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D5B42F7AB
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 12:24:05 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-54476ef9caeso55612417b3.6
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 12:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679081045;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MDlPOFjKF3Ap6Ru4zlrR9vOwwBWY5bsgi6apMR43Vu8=;
        b=R0ZgA7wApNC8Qrn6FCeqZ/pCx+xfBRKhfOrivsghwPTvJwIBd+mOs5Ml3G1GtBIK91
         R1Nyg0uyvcXdWGGBEfyQDoCDP+uRSdy0Yjcxs965ttKo23G2DGrprGCuT4h0Amiwi3Tt
         msNRKHbKuSWEc6vRbfsKz5lSqWppQM99R4HHA0Ga7OCr8sB8dlWDaNRyk3mdlaBp8AZG
         tU5+tlmTA2AvbWY5Haou/qnZH5LOKki/C7kw2RqX4M3LHcdKZoEdrwA5m0CTPG/VggrH
         yxulwLGtZyA6RH0hVurQQCwsf2XBx4JF+lPVzBaIcLz3OGVsdqerZplBd3AESe9nS4xz
         5qHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679081045;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MDlPOFjKF3Ap6Ru4zlrR9vOwwBWY5bsgi6apMR43Vu8=;
        b=W8NG+6cLqXCy3Aba9E8xCuWHQR62iVt6DHwbRRFBm39nqbz4EMorhWObwKAJATzGuB
         h1Y8K3ZrFJ5r5PGBAl7s7MMHiQHgnCCL1UQ5S/xz74ZncC3AT79kBjCKKnwKpFRsXW4J
         qG8HlLY4O4yXPBrY0uCpW7aqHqgXpExIa3DLUHoyK4/76vSOeB9EF2PkBbzAmjyhRZqA
         4Zgzhu5TbwryLkR4qpCocPj/FZeDdfTNoq8Uumk3l5ine27AHyqWJlaD7GJpbHUIKpBR
         ij564NDk4OVzrVObQzPwUMW/0w2kkgI5lmK+MObNuu6pnqSV8BZr8JF/7ri605CGAMyT
         ieAA==
X-Gm-Message-State: AO0yUKWcFzE/6tCtJE7yTfHO4UgX1FVc7YcfNgV+Pfu7WypA/kMe8KzI
        ycwbbCBwLHu6+0glWGjNqCiYqJ2fGRw=
X-Google-Smtp-Source: AK7set+DJPSxxoHsmdFVRd9+lxdkjDUwtC1IfAXZa/x65QJrHHdMQRS+6hwwu/aXkQ7SOlk5H/j5sPBTcZY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1023:b0:b17:294f:fb30 with SMTP id
 x3-20020a056902102300b00b17294ffb30mr512580ybt.2.1679081045101; Fri, 17 Mar
 2023 12:24:05 -0700 (PDT)
Date:   Fri, 17 Mar 2023 12:24:03 -0700
In-Reply-To: <CAF7b7mrG_jmrUohr9rXLBXS-uzJCwK6=BC5pyxE8O=Ov77WZ3w@mail.gmail.com>
Mime-Version: 1.0
References: <20230315021738.1151386-1-amoorthy@google.com> <20230315021738.1151386-13-amoorthy@google.com>
 <ZBSw/jh/WfAwu3ga@linux.dev> <CAF7b7mrG_jmrUohr9rXLBXS-uzJCwK6=BC5pyxE8O=Ov77WZ3w@mail.gmail.com>
Message-ID: <ZBS+U19LdYG5kYo/@google.com>
Subject: Re: [WIP Patch v2 12/14] KVM: arm64: Implement KVM_CAP_MEMORY_FAULT_NOWAIT
From:   Sean Christopherson <seanjc@google.com>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>, jthoughton@google.com,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 17, 2023, Anish Moorthy wrote:
> On Fri, Mar 17, 2023 at 11:27=E2=80=AFAM Oliver Upton <oliver.upton@linux=
.dev> wrote:
>=20
> > > +     pfn =3D __gfn_to_pfn_memslot(
> > > +             memslot, gfn, exit_on_memory_fault, false, NULL,
> > > +             write_fault, &writable, NULL);
> >
> > As stated before [*], this google3-esque style does not match the kerne=
l style
> > guide. You may want to check if your work machine is setting up a G3-sp=
ecific
> > editor configuration behind your back.
> >
> > [*] https://lore.kernel.org/kvm/Y+0QRsZ4yWyUdpnc@google.com/
>=20
> If you're referring to the indentation, then that was definitely me.

The two issues are (1) don't put newlines immediately after an opening '(',=
 and
(2) align indentation relative to the direct parent '(' that encapsulates t=
he code.

Concretely, the above should be:

	pfn =3D __gfn_to_pfn_memslot(memslot, gfn, exit_on_memory_fault, false,
				   NULL, write_fault, &writable, NULL);

> I'll give the style guide another readthrough before I submit the next
> version then, since checkpatch.pl doesn't seem to complain here.

I don't think checkpatch looks for these particular style issues.  FWIW, yo=
u
really shouldn't need to read through the formal documentation for these "b=
asic"
rules, just spend time poking around the code base.  If your code looks dif=
ferent
than everything else, then you're likely doing it wrong.
