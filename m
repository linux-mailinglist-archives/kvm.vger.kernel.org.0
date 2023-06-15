Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9753F730D66
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 05:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237774AbjFODCo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 23:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237188AbjFODCm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 23:02:42 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22E0926A0
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 20:02:41 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1b506a66882so7690845ad.2
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 20:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686798160; x=1689390160;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6G4IXwGpoUdWL3Jj26QlGSDuiNxEjCjHlS4hHitS9FY=;
        b=GOg+ZPxRGBheX5NiFnwchnIk6F9ucBIBZkHECyciq1u+1Lbw73d3KXyMNOJ5K7EGsa
         DLKZNF6jBpC3ZnlkfQwAvDq7EjlkHz9J82xuBaIavB3mlD2Pi0bfyASTRcL7Joz1+9Pi
         Nch/MQnKGvYv5fT+9VUMYDZUwHGL3gg+YCzN4NoY0K0QrTX5ppT4+x9waNF+QDmVliJV
         YmCmrICVINR5cNM2tmXppwHAmwYspROGTazQG4swifGWdQE5UU1Lw9tMf2n3DMm70PDH
         MO+lReBH35ycVa9ao6mhLkOcWmJebpodOPTgpxYjZ21Mxdx0iak2X4OFZyLtHtIpa9oB
         CjbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686798160; x=1689390160;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6G4IXwGpoUdWL3Jj26QlGSDuiNxEjCjHlS4hHitS9FY=;
        b=iSpMdHaTdOwE6H6RGf1F9YXv5u4Rs6cyG4/wt+/MmNiDaZSwwJqtOMndT3uQRTlqUZ
         vvPU+TUm02jV1moJ09cxrzzOQLvn2M8mvBFnez1Qbc6flnXIG4gZfl/drYCOEam8pV1D
         KhrVMZOrTZvD2b49nHzFsWBX52qknn1LBp/7MbBkIfVCBD8kjkVc9QG5QIrG7IYLI/dC
         31NpR07iurF8zJ1amSBBeF6+s7vDereuvftKojLQabZ4NfvJ9EW2reEs50skCu46g8JH
         rSChLTvlOpS9it9HDwZyrcWRACYp6t3FbTqeeotnYCZhcZP0qW5JGyi8zYyReX42krl/
         9IIg==
X-Gm-Message-State: AC+VfDwPlCWe7k2oNBNEyh+IFwuQUljRbHKWS4rCu1jC+LY0jSnS+yms
        MjOhkowrBCdBr10b5GaB3bo=
X-Google-Smtp-Source: ACHHUZ6lgjIPBI0Tymldtf6QR27S0ioLRgoC0GF43wVBjXefXq1as6jZvCfbw6Hn4lMDb5hFgodfSA==
X-Received: by 2002:a17:902:e314:b0:1af:fe12:4e18 with SMTP id q20-20020a170902e31400b001affe124e18mr11243125plc.20.1686798160453;
        Wed, 14 Jun 2023 20:02:40 -0700 (PDT)
Received: from localhost (14-203-144-223.static.tpgi.com.au. [14.203.144.223])
        by smtp.gmail.com with ESMTPSA id w5-20020a170902d70500b001ac94b33ab1sm4164815ply.304.2023.06.14.20.02.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jun 2023 20:02:40 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Thu, 15 Jun 2023 13:02:34 +1000
Message-Id: <CTCW1ILCXTMA.24T7LU9PQBTDA@wheely>
From:   "Nicholas Piggin" <npiggin@gmail.com>
To:     "Joel Stanley" <joel@jms.id.au>
Cc:     <kvm@vger.kernel.org>, "Laurent Vivier" <lvivier@redhat.com>,
        "Thomas Huth" <thuth@redhat.com>, <linuxppc-dev@lists.ozlabs.org>,
        <qemu-ppc@nongnu.org>, <qemu-devel@nongnu.org>
Subject: Re: [kvm-unit-tests v4 00/12] powerpc: updates, P10, PNV support
X-Mailer: aerc 0.14.0
References: <20230608075826.86217-1-npiggin@gmail.com>
 <CACPK8XdpAxjvP+bFNFJzQQzBYvEwsE69QkbNWRumZtUW2wOrrA@mail.gmail.com>
In-Reply-To: <CACPK8XdpAxjvP+bFNFJzQQzBYvEwsE69QkbNWRumZtUW2wOrrA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed Jun 14, 2023 at 11:09 AM AEST, Joel Stanley wrote:
> On Thu, 8 Jun 2023 at 07:58, Nicholas Piggin <npiggin@gmail.com> wrote:
> >
> > Posting again, a couple of patches were merged and accounted for review
> > comments from last time.
>
> I saw some failures in the spr tests running on a power9 powernv system:
>
> $ TESTNAME=3Dsprs TIMEOUT=3D90s ACCEL=3D ./powerpc/run powerpc/sprs.elf -=
smp
> 1 |grep FAIL
> FAIL: WORT      ( 895):    0x00000000c0deba80 <=3D=3D> 0x0000000000000000

This is just TCG machine? I'm not sure why WORT fails, AFAIKS it's the
same on POWER8 and doesn't do anything just a simple register. I think
on real hardware WORT may not have any bits implemented on POWER9
though.

> $ MIGRATION=3Dyes TESTNAME=3Dsprs-migration TIMEOUT=3D90s ACCEL=3D
> ./powerpc/run powerpc/sprs.elf -smp 1 -append '-w' | grep FAIL
> FAIL: SRR0      (  26):    0xcafefacec0debabc <=3D=3D> 0x0000000000402244
> FAIL: SRR1      (  27):    0xc0000006409ebab6 <=3D=3D> 0x8000000000001001
> FAIL: CTRL      ( 136):            0x00000000 <=3D=3D>         0x00008001
> FAIL: WORT      ( 895):    0x00000000c0deba80 <=3D=3D> 0x0000000000000000
> FAIL: PIR       (1023):            0x00000010 <=3D=3D>         0x00000049
>
> Linux 6.2.0-20-generic
> QEMU emulator version 7.2.0 (Debian 1:7.2+dfsg-5ubuntu2)
>
> On a power8 powernv:
>
> MIGRATION=3Dyes TESTNAME=3Dsprs-migration TIMEOUT=3D90s ACCEL=3D ./powerp=
c/run
> powerpc/sprs.elf -smp 1 -append '-w' |grep FAIL
> FAIL: SRR0      (  26):    0xcafefacec0debabc <=3D=3D> 0x0000000000402234
> FAIL: SRR1      (  27):    0xc0000006409ebab6 <=3D=3D> 0x8000000000001000
> FAIL: CTRL      ( 136):            0x00000000 <=3D=3D>         0x00008001
> FAIL: PIR       (1023):            0x00000060 <=3D=3D>         0x00000030

Hmm, seems we take some interrupt over migration test that is not
accounted for (could check the address in SRR0 to see where it is).
Either need to prevent that interrupt or avoid failing on SRR0/1 on
this test.

Interesting about CTRL, I wonder if that not migrating correctly.
PIR looks like a migration issue as well, it can't be changed so
destination CPU has got a different PIR. I would be inclined to
leave those as failing to remind us to look into them.

I'll take a look at the others though.

Thanks,
Nick
