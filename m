Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 343097D5B11
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 21:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344126AbjJXTFX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 15:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234846AbjJXTFW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 15:05:22 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D788A10C9
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 12:05:20 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id 4fb4d7f45d1cf-53eeb28e8e5so2532a12.1
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 12:05:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698174319; x=1698779119; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gOkuHsAfrJFLE7fNlHS5Cbl0lv5GMVYVvk6+mbHAbI0=;
        b=HaPNVzu8gbXV2P7omR8+m8RQwtv5ckAcUdxrCuDU2Nd26ceftp6mCYlyG4HxIbrEHr
         Qvm4MKD2BIf1Tt4b8lqZXY26QJlrqqFwH3I69hTieh3Z0FT2wQXIOtPZLTqcAzG9TRLa
         ZFzfa6l0datRvhvJAkRqysgKQ0OkKPCckfe+j3U/uowxxF/lHwUOg3yfUYv95ICVcz64
         pl6hi26QeHmZK4IgNLB/qltvsiCet5IfNxOCcrehQ3gNDepCGGgH32u3tWvP7HXDbs2o
         uQcjNxFm6PFJ90p+brO3nFzNiavh+ZJLJf/TYpyUHqpDp46ko2ZBTawLb8292O8MteGN
         D+5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698174319; x=1698779119;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gOkuHsAfrJFLE7fNlHS5Cbl0lv5GMVYVvk6+mbHAbI0=;
        b=ZHwJf/3myfqZpL2Q9AqnkDXw6ZiHIO82T2QljXkFtdT2tBSxuqm7QRrrumP6aeN2cR
         6LDLxXedru/eggg1ghv8tHZn7SA/6oCiJ35cxISKP2VMFXi+ssayMsa25n00ZPg0cRnl
         XYMfXC0+8i9aoug+5FdA3j36i20NbB3Mjy2Yx44f3+dCnUcFPb8+E9j0zb18n0/fX5oB
         UCiBh31TPe7DJ2ZrdVyKfQJDePMDcMvF2Ub+5bONzAwTXjeWCjsW5R7WkPDZXmQOlPhW
         dpvDlKCGDhqf5QL0PB0i18qCGyWrO1YCTYBTQURlXTTHKnVSgKf7u3LUsZ042APClX2d
         KDIw==
X-Gm-Message-State: AOJu0Ywjv3TrdAz+QWX6FJg+zEWM21V1ia6JHcxTf/01gC3g6yt8P7gW
        Bz2Eq2rFmArDvGMWX46OJB3KXTKVubxUA456ZTrp8eMfbOR7rm7lvVQ=
X-Google-Smtp-Source: AGHT+IEKCztwuOSHPsxHskXbwb/oYow4gdN8mVsjBdpn0DhVfa2NBxjgBQKluWcfdl36axseIhrFgRywb7dX+zDvSL8=
X-Received: by 2002:a05:6402:288e:b0:540:9e44:483f with SMTP id
 eg14-20020a056402288e00b005409e44483fmr120416edb.4.1698174318634; Tue, 24 Oct
 2023 12:05:18 -0700 (PDT)
MIME-Version: 1.0
References: <20231024075748.1675382-1-dapeng1.mi@linux.intel.com> <20231024075748.1675382-5-dapeng1.mi@linux.intel.com>
In-Reply-To: <20231024075748.1675382-5-dapeng1.mi@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 24 Oct 2023 12:05:06 -0700
Message-ID: <CALMp9eSQyyihzEz+xpB0QCZ4=WqQ9TGiSwMYiFob0D_Z7OY7mg@mail.gmail.com>
Subject: Re: [kvm-unit-tests Patch 4/5] x86: pmu: Support validation for Intel
 PMU fixed counter 3
To:     Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhang Xiong <xiong.y.zhang@intel.com>,
        Mingwei Zhang <mizhang@google.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Dapeng Mi <dapeng1.mi@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 24, 2023 at 12:51=E2=80=AFAM Dapeng Mi <dapeng1.mi@linux.intel.=
com> wrote:
>
> Intel CPUs, like Sapphire Rapids, introduces a new fixed counter
> (fixed counter 3) to counter/sample topdown.slots event, but current
> code still doesn't cover this new fixed counter.
>
> So add code to validate this new fixed counter.

Can you explain how this "validates" anything?

> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> ---
>  x86/pmu.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/x86/pmu.c b/x86/pmu.c
> index 1bebf493d4a4..41165e168d8e 100644
> --- a/x86/pmu.c
> +++ b/x86/pmu.c
> @@ -46,7 +46,8 @@ struct pmu_event {
>  }, fixed_events[] =3D {
>         {"fixed 1", MSR_CORE_PERF_FIXED_CTR0, 10*N, 10.2*N},
>         {"fixed 2", MSR_CORE_PERF_FIXED_CTR0 + 1, 1*N, 30*N},
> -       {"fixed 3", MSR_CORE_PERF_FIXED_CTR0 + 2, 0.1*N, 30*N}
> +       {"fixed 3", MSR_CORE_PERF_FIXED_CTR0 + 2, 0.1*N, 30*N},
> +       {"fixed 4", MSR_CORE_PERF_FIXED_CTR0 + 3, 1*N, 100*N}
>  };
>
>  char *buf;
> --
> 2.34.1
>
