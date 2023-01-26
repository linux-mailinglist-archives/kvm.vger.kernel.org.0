Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4F3767D7AA
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 22:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232955AbjAZV1E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 16:27:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231824AbjAZV1D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 16:27:03 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBEAFCA
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 13:27:01 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id fl11-20020a05600c0b8b00b003daf72fc844so4160661wmb.0
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 13:27:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:subject:to:from:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sJ6Mfr0BAuDTuaNEu397fFLI8asfpDDww1agUQinN58=;
        b=PBHLcd1L1pmOgPNUoXVndhD79Id7lHPIcsGq/ci0SieSVVOXle8XlMr4eyopO71mDz
         nHLbBox6iQFg2wHaSOQMrB753nYeJXwYztvQJSflH75cDFei6DXtRdHRAcJ+b0iiBl/u
         gkr7+NQJ55UsouhOUefuPKqEhOEqRVwpW7K1lHCaznQETnRwXQoqrcTRtGq2GmZsZb0a
         j5zq7KkO3rRWoux1m7AKWORISN1xPFQSYoJClWA60kvF5IjQSxBzd9I3QEhsqlrPfoYK
         rLDLDwS0M+H/Y/SgqC6hIludoNY50nHxnWQZYPnWaL/ri3KbQIismoylIO2BxzPywBH8
         wkLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:subject:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sJ6Mfr0BAuDTuaNEu397fFLI8asfpDDww1agUQinN58=;
        b=CCfuH/ReeFYBaElmohG6HMfQ/Dj2ONAHzN4mjOT9lZ4DGgg0OlQ9fJ7kK4maTvaaVU
         sRVdr16YCfYnR36rSHlb5ty5m4RZRv8LJd/OyAwpTIM1V6/50EdHpao59GMAls9capZB
         arrXBhDLUZAn7uzZHTknzxiWPUMC4tTGB0AVnkcTWQsv/WU/7DAz5xX8Lg3Tl5TXlH1s
         EmK0aQBqMXLjJyX+3yezax1CqWLnRfsVIgdPAvcjEQIvLZwZTmNeWzxucGQBwSfjwn9L
         EclGiazyf5t8TMCE+9K4CjGXY87ACgoE4vcMx0u/X1DJB2+t0zuO+iA2sRBy/XECuEl1
         WssQ==
X-Gm-Message-State: AFqh2krYej7bSkzAJ6oBNbRbPcgGS7d1JK9x5DMjZfjgySkfep6YNWxj
        yumAlT87lfyF7mB+noXoW45U9iGwcj0wEQ==
X-Google-Smtp-Source: AMrXdXvrA85488ToBimagoGsNFqp53vyasOT1zKm8Nt4Y/+khBKYrG5KwXpR/IxHQSWHgzso/d4CXA==
X-Received: by 2002:a05:600c:1c02:b0:3d2:3b8d:21e5 with SMTP id j2-20020a05600c1c0200b003d23b8d21e5mr37065077wms.14.1674768420495;
        Thu, 26 Jan 2023 13:27:00 -0800 (PST)
Received: from ?IPv6:::1? (p200300faaf0bb2004c1ba1824932b7f6.dip0.t-ipconnect.de. [2003:fa:af0b:b200:4c1b:a182:4932:b7f6])
        by smtp.gmail.com with ESMTPSA id ay6-20020a05600c1e0600b003db00747fdesm5786477wmb.15.2023.01.26.13.26.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Jan 2023 13:27:00 -0800 (PST)
Date:   Thu, 26 Jan 2023 21:26:53 +0000
From:   Bernhard Beschow <shentey@gmail.com>
To:     quintela@redhat.com, Juan Quintela <quintela@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>, qemu-devel@nongnu.org
Subject: Re: Fortnightly KVM call minutes for 2023-01-24
In-Reply-To: <87zga8f0c0.fsf@secure.mitica>
References: <87zga8f0c0.fsf@secure.mitica>
Message-ID: <09D128C9-6633-4315-B312-827C875C20DB@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 24=2E Januar 2023 14:56:15 UTC schrieb Juan Quintela <quintela@redhat=
=2Ecom>:
>
>
>
>
>First part stolen from: https://etherpad=2Eopendev=2Eorg/p/qemu-emulation=
-bof%402023-01-24
>      thanks Phillippe
>
>Single QEMU-system binary and Dynamic Machine Models
>
>Meeting link: https://meet=2Ejit=2Esi/kvmcallmeeting
>Just want to dial in on your phone? Dial-in: +1=2E512=2E647=2E1431 PIN: 1=
518845548#
>Click this link to see the dial in phone numbers for this meeting https:/=
/meet=2Ejit=2Esi/static/dialInInfo=2Ehtml?room=3Dkvmcallmeeting
>
>What needs to be done?
>
>    TCG
>
>    How to use different page sizes
>
>    -> convert to page-vary (already used by ARM/MIPS)
>
>    ref: https://lore=2Ekernel=2Eorg/qemu-devel/20221228171617=2E059750c3=
@orange/
>
>
>    HW models / machine
>
>
>    How to create/realize 2 QOM objects which depend on each other?
>
>    what (properties) need to be wired? IRQ, reset lines, MR?
>
>
>    Sysbus: Demote it to plain qdev?
>
>    con:
>
>    sysbus helpful to remove qdev boilerplace/verbose code
>
>    sysbus tree does the resets [currently blocking qdev conversion]
>
>    pro:
>
>    sysbus IRQ API
>
>    too abstract, not very helpful, "named gpios" API is clearer
>
>    sysbus MMIO API
>
>    also kinda abstract, MRs indexed=2E No qdev equivalent
>
>    sysbus IO API:
>
>    not very used=2E first we need to get rid of ISA bus singleton

I've just submitted v2 of my patch series removing the ISA bus singleton: =
https://lore=2Ekernel=2Eorg/qemu-devel/20230126211740=2E66874-1-shentey@gma=
il=2Ecom

Best regards,
Bernhard

>
>
>    Single 32/64 *targets* binary
>
>    Which 32-bit hosts are still used? OK to deprecate them?
>
>    Some targets need special care i=2Ee=2E KVM 32-bit ARM vCPU on 64-bit=
 Aarch64 host
>
>
>Previous notes:
>    https://etherpad=2Eopendev=2Eorg/p/qemu-emulation-bof%402022-12-13
>    https://etherpad=2Eopendev=2Eorg/p/qemu-emulation-bof%402022-11-29
>
>
>Do we care about this?
>
>64 bits guests on 32 bits hosts: OK to deprecate
>32 bits hosts: still in (some) use
>
>Creating and realizing two objects than need to be linked together=2E
>
>We can't do it with realize, perhaps we need an intermediate state to
>do the link, and then realize=2E
>
>Can we get Peter or Markus or Paolo for the next call?
>waiting to get some patches into the list for discussing=2E
>
>Problem for Phillipe is that he has to do changes to the API's and
>want to be sure that they are agreed before he changes all
>devices/targets, a multi month task=2E
>
>For removing sysbus, we need to wait for reset rework from Peter?
>
>Expose the memory API to external processes=2E
>
>Under what circumstances you should be able to create/destroy a memory
>region?
>
>
>
>Later, Juan=2E
>
>
