Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C99776F63E
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 01:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231738AbjHCXnM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 19:43:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjHCXnL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 19:43:11 -0400
Received: from mail-oo1-xc30.google.com (mail-oo1-xc30.google.com [IPv6:2607:f8b0:4864:20::c30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A591716
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 16:43:10 -0700 (PDT)
Received: by mail-oo1-xc30.google.com with SMTP id 006d021491bc7-55e1a9ff9d4so1644478eaf.1
        for <kvm@vger.kernel.org>; Thu, 03 Aug 2023 16:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691106189; x=1691710989;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O7+T5OtzOt0JkmxCZ3JKOD3dXL81QvqZ18on5E407Iw=;
        b=WXz/PEsrmzilAWytxUhX96+gxnGeQR72NpzCfxl6OC1hYZfRci7qNy+zPfmKITnuVA
         9MrlQ879zobsOls+slxsR4lPU7xVLeiXE3DH+TKIIPNnqcUxHi7EM9yZ4hoR3SU5kN8+
         OXHA7IOWJNPNwhsnDAJ3xpZNarLgZpQrxTe9GRsGmA0zS48Ftb2EDTFalLJA0vdIX4zc
         +Iqp0ufUPWufB7HCOUHcnlSYh8B5BPvUlcu0uNeUODoJaYr25Q2Xn6WKRKVWnuuCPiBV
         waFmkCo2HUFd0YxXiIwGdQwrXJ2v8ZVlvfAnIqLLADGd/SWEA41AscJopxhnx5gUb5LK
         UiSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691106189; x=1691710989;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O7+T5OtzOt0JkmxCZ3JKOD3dXL81QvqZ18on5E407Iw=;
        b=Qq0mkbDfKfXY2NJfDeH+MfzsICZhC887npXLlCa572I3MHCmvXjZmIefI8axijV0Ez
         pQalLpOMV4LDVUy14CQ9bZye0w/OGl4udzjLpHI+RUrbPdAdh3fHApFBPZOYHOLd75nK
         DLyDo4dRlvJxX9oqx+HQZBAQscZvBFheJECwNpAG6uqlm8mx6TBFN9p/lM+nlsEMfTw4
         HlWA2v4gaCAt5tWFmXeHc7zYQnovI08vuvY4Zv0QfH1tHbMvI/2teXrmlLNwvtLh9iwu
         N/RSZP9aP3/uhP6C3Te1BTqdxODrvgy/FpWVp2IO9hszztCJtMfigfTwQoCdEPHeiIUO
         u6Ag==
X-Gm-Message-State: AOJu0YxzcJJXNMBaKhhG6Al5nAureOVT5AdeWn9B6DF8wphhJJlf05iv
        Lt2xE5/H0Vn+9e/Hqnd2Q9QWq8U+QOKkv3c7eZVQwQ==
X-Google-Smtp-Source: AGHT+IE8EFiGXpLyt+I/OTRAPgx9UftqLbrYi//2dfgHbp2F0UderK+0htYSrMFvcH7I82ud9+Ruoa3h/aZ+lWV/A6Y=
X-Received: by 2002:a05:6871:58d:b0:1bb:860d:8106 with SMTP id
 u13-20020a056871058d00b001bb860d8106mr165777oan.22.1691106189458; Thu, 03 Aug
 2023 16:43:09 -0700 (PDT)
MIME-Version: 1.0
References: <20230726044652.2169513-1-jingzhangos@google.com>
 <871qgvrwbi.wl-maz@kernel.org> <CAAdAUthi6oZ6oRQDFLeOFVwm2dtcTK2ERJm316x0bdn5TQObYw@mail.gmail.com>
 <ZMq5zDJ16xav7NPa@linux.dev>
In-Reply-To: <ZMq5zDJ16xav7NPa@linux.dev>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Thu, 3 Aug 2023 16:42:57 -0700
Message-ID: <CAAdAUtgjZEbp_uwT2WuNVn3Ko7d0yty1hpkUyYfhotk-f0a1Wg@mail.gmail.com>
Subject: Re: [PATCH v1] KVM: arm64: selftests: Test pointer authentication
 support in KVM guest
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Marc Zyngier <maz@kernel.org>, KVM <kvm@vger.kernel.org>,
        KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Oliver,

On Wed, Aug 2, 2023 at 1:17=E2=80=AFPM Oliver Upton <oliver.upton@linux.dev=
> wrote:
>
> Hi Jing,
>
> Nothing serious, but when you're replying on a thread can you add a
> leading and trailing line of whitespace between the quotation and your
> reply? Otherwise threads get really dense and hard to read.

Will do. Thanks for the suggestion.

>
> On Wed, Aug 02, 2023 at 10:19:30AM -0700, Jing Zhang wrote:
> > > > +                     case FAIL_KVM:
> > > > +                             TEST_FAIL("KVM doesn't support guest =
PAuth!\n");
> > >
> > > Why is that a hard failure? The vast majority of the HW out there
> > > doesn't support PAuth...
> > Since previous TEST_REQUIRES have passed, KVM should be able to
> > support guest PAuth. The test will be skipped on those HW without
> > PAuth.
>
> So then what is the purpose of this failure mode? The only case where
> this would happen is if KVM is if KVM screwed up the emulation somehow,
> took a trap on a PAC instruction or register and reflected that back
> into the guest as an UNDEF.

You are right about the purpose of this test case.

>
> That's a perfectly valid thing to test for, but the naming and failure
> messages should indicate what actually happened.

Sure. Will use more sensible messages.

>
> > > As I mentioned above, another thing I'd like to see is a set of
> > > reference results for a given set of keys and architected algorithm
> > > (QARMA3, QARMA5) so that we can compare between implementations
> > > (excluding the IMPDEF implementations, of course).
> > Sure. Will do.
>
> I was initially hesitant towards testing PAC like this since it is
> entirely a hardware issue besides KVM context switching, but you could
> spin this off as a way to test if vCPU save/restore works correctly by
> priming the vCPU from userspace.
>
> Marc, is there something else here you're interested in exercising I
> may've missed?
>
> --
> Thanks,
> Oliver

Thanks,
Jing
