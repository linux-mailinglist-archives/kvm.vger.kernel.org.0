Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11CF56AD3AF
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 02:04:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbjCGBE3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 20:04:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbjCGBE2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 20:04:28 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC09B4741F
        for <kvm@vger.kernel.org>; Mon,  6 Mar 2023 17:04:27 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id e21so8546226oie.1
        for <kvm@vger.kernel.org>; Mon, 06 Mar 2023 17:04:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678151067;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TwNOBz5cHclDTneIIBsBs0gZjoQhRh5NPATMEM3PAnk=;
        b=LpJcgSLD0tT69e9lRlce9T9OgurQ2lZyqvRUGeYcs2VAKq+q/sxDd+iNx18Ue8sRSM
         oork3vWFhg+480AwWtL6Wxfp9EM/COjoxssLNDxTMqmTHGnItVfg4Dk9qmxU0IpKktjO
         SEMBHVruAy74UMT4APsP62woNsBtji8tTLRZkAHrGinn/bUur+DLnYzohqdf6JpofgS1
         sGHWDtmEskTmeCGt+S0dr+vg+ZFpSNO6xIHuucBai9rthsapyLG3y1iOT8UnQG9FtjVV
         HgSbO2qGJVMwSIPCLcdvMDrOITgDAuCVAfmkxPGr+jaN8EsBcXhRF0uXigOJU2vRiRzA
         xMsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678151067;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TwNOBz5cHclDTneIIBsBs0gZjoQhRh5NPATMEM3PAnk=;
        b=jxhuyM8MI311B6gD26/Q7++bz27TFK326Uf5cDcxqsJHwNfA6T6YKqlWjaFwVk+YVt
         csgUJaZ0t2KQD1AZn9s5sNr/BfQagzskQR9X/xTVO+TO9dhwawy6Qcnm31FSKVtZndIU
         iRMtmINam+78skbVNTd/8OK5Lz0xo4NdimEM0TipTWxaK9vGc9Gq8V9KRuj6vSsJX0oB
         NmJvJTP+qzQeORXaVvQQa19yZ2h4/ZxYAzyfBZxEk76Y5E4feueacTsELR9dV4m96wjA
         UInHzvWiMYAIPPg3E2DQm56OMo6EDilsm9YcaRXwuUWCsCy1Fcluubg0oxEO458PJQpd
         kwDA==
X-Gm-Message-State: AO0yUKUrGOp9rxhBqs5Xuq1zRTRJOfFicjSJpboNdyBQHw48YZsmnbgK
        UorW3JuGnuLi3zS9p/jjWieg33490pMyhOIPEoaVNw==
X-Google-Smtp-Source: AK7set8GhL4eLE9iEbKqGXNNBtn7FjvVAB5h6qKrGrldD1MBIj7QSGYWA/dEMs5gA2FeukXGtICseW3U+vp0IqQknEM=
X-Received: by 2002:a54:450a:0:b0:384:2fe1:39c with SMTP id
 l10-20020a54450a000000b003842fe1039cmr4102041oil.5.1678151066824; Mon, 06 Mar
 2023 17:04:26 -0800 (PST)
MIME-Version: 1.0
References: <20230307005547.607353-1-dmatlack@google.com> <20230307005547.607353-3-dmatlack@google.com>
In-Reply-To: <20230307005547.607353-3-dmatlack@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 6 Mar 2023 17:04:15 -0800
Message-ID: <CALMp9eSWmW810V5kzYDkgXyEyLapEUbQPZmA4655a03_eSJDig@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 2/2] x86: Mark RDPID asm volatile to avoid
 dropping instructions
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Greg Thelen <gthelen@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Mon, Mar 6, 2023 at 4:56=E2=80=AFPM David Matlack <dmatlack@google.com> =
wrote:
>
> Mark the asm statement that generates the RDPID instruction volatile.
> The compiler within its rights to drop subsequent RDPID asm statements
> (after the first) since the inputs never change.
>
> This fixes the tsc test on hardware that supports rdpid when built with
> the latest Clang compiler.
>
> Fixes: 10631a5bebd8 ("x86: tsc: add rdpid test")
> Reported-by: Greg Thelen <gthelen@google.com>
> Suggested-by: Greg Thelen <gthelen@google.com>
> Signed-off-by: David Matlack <dmatlack@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
