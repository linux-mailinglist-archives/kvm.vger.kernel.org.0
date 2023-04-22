Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4313C6EB7CB
	for <lists+kvm@lfdr.de>; Sat, 22 Apr 2023 09:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbjDVHan (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Apr 2023 03:30:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDVHam (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Apr 2023 03:30:42 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE43E1BC6
        for <kvm@vger.kernel.org>; Sat, 22 Apr 2023 00:30:40 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-94f7a7a3351so430084766b.2
        for <kvm@vger.kernel.org>; Sat, 22 Apr 2023 00:30:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20221208.gappssmtp.com; s=20221208; t=1682148639; x=1684740639;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bnbhem9cFhqB68iCoIpDzvQnT3W5aSkuuvVIymFb3Ww=;
        b=L8oPZJAc2pg6voMstV+pRjkJXH9m+UOMujNQ8PeoGo3cN/C0tV0sHIv1mPeOCJggZg
         8tqDdycmQkmRiisSOHkusO1Yp7zhM4rHN/VWkN9wT4o5qsFQBYvAFB3lAtZQAE8jnKxk
         CNt7em/G2wIfu3fe81oziM3yIoNm/JwiGbr1NW8PvQrmmqwJoitIGlQUHumvOLOyGTNr
         zFQ/0g5/e7LMfiVS7W3DHi6QgzZaOG+zaS1GcFONxjxvMO/kX5YxrdOT3GXCEmPbM8yv
         uhbUaTyomhzn2SLhahl1XxLnzwZY77y+BAUzXrdRnu+IlmjXm/JtHnNc8FXhAIv2q3WL
         Zw6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682148639; x=1684740639;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Bnbhem9cFhqB68iCoIpDzvQnT3W5aSkuuvVIymFb3Ww=;
        b=l4M95oSKhbWCXdebqiOdiryZOKrxobYJq3OXOw8pKjDbavYE498nRDLr22ld3kU1Sd
         2VPyY7ijamR6qYSSLd341TPrfaTvtG/vNUbgQO83ItkPjqZVvtnqnSgXQpIlTYVRr0+Q
         ev6UjTbjWxwnv0supROYWhzQkD3UEcVxuhXY3em5WEUmbXU7c0c2TmoGnvcB/x1QcJar
         4n6jVfWhx6wgxV1mJxUuWfdzLXjf43zdqOsUSK3PK30rDXS2tIEX5gFekb0gvOcOSLh6
         FHweRneYYFsyhN/SV/1vxqDeluVETuRnc6Xyod3mNIE5/m+8VZEW6rons5QiykJN9U8U
         Rntg==
X-Gm-Message-State: AAQBX9e10QfRtQKDhX5RZCyQfcxAglCvXSu0QCzuVj4HYsbSGibv1+2S
        ytjeJenYrP80CjTC/OHG19GNFjeOZOeW8R4BMBTrLg==
X-Google-Smtp-Source: AKy350aiBujT8SMlUPPdZnbPxz+23d43fdy0gzPnmTSoIvo6NHSrKV0ahRpMlR1Mrj5H/aOWd6JK7y76hId53LPxRqg=
X-Received: by 2002:a17:906:ce37:b0:94e:d97e:7a5d with SMTP id
 sd23-20020a170906ce3700b0094ed97e7a5dmr4158790ejb.47.1682148639153; Sat, 22
 Apr 2023 00:30:39 -0700 (PDT)
MIME-Version: 1.0
References: <ZELftWeNUF1Dqs3f@linux.dev> <100c4e47-9d8d-8b3a-b70b-c0498febf23c@redhat.com>
In-Reply-To: <100c4e47-9d8d-8b3a-b70b-c0498febf23c@redhat.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Sat, 22 Apr 2023 13:00:27 +0530
Message-ID: <CAAhSdy0JNtkhCGmXQpnf8Qp2Jus7tk_sJGpbq2xj5AeC+jQppw@mail.gmail.com>
Subject: Re: Getting the kvm-riscv tree in next
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Apr 22, 2023 at 5:18=E2=80=AFAM Paolo Bonzini <pbonzini@redhat.com>=
 wrote:
>
> On 4/21/23 21:10, Oliver Upton wrote:
> > I've also noticed that for the past few kernel release cycles you've
> > used an extremely late rc (i.e. -rc7 or -rc8), which I fear only
> > draws more scrutiny.
>
> Heh, I just wrote the same thing to Anup.  In particular, having
> kvm-riscv in next (either directly or by sending early pull requests to
> me) would have helped me understand the conflicts between the core and
> KVM trees for RISC-V, because Stephen Rothwell would have alerted me
> about them.

I think it is better to have patches sit in linux-next for at least a week
before sending pull requests. I will request Stephen to include KVM
RISC-V tree in linux-next.

Thanks,
Anup

>
> Paolo
>
