Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4294237B0C2
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 23:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbhEKV2V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 17:28:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbhEKV2U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 May 2021 17:28:20 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99CB7C061574
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 14:27:13 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id l6so20403751oii.1
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 14:27:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=raiVLCfAf9/vKVvJ2xvj7dS2xaKxdBfJtG6OeEt6BAQ=;
        b=BuqhpT5l4aweACDZWAf2oKzGbgVpt5hOHCVDjYMe2t0VcTjq62XMrxi6QKwzKkbh0Y
         BacM/dqOeyTmpKydRpQvQW9aFltkc5UKr/LQHyipuqog8lZ1tBKn8p93bg6/WcZGXjGh
         SyWHxWmu8V5TfMvPAyrGYrm13u8RPNnD/MaFYQ4ClKqvTeNVnj2Bnhy2MSMR1IIzzU2b
         3Ws1eNa6EbSBJPQ055r50ReoFpB6nbiO3c1wwnwrTQk1HFJo+BCEMv4JWLkb4CMfS7XI
         KA1UoopzGZQfwICXaHrroJpMRJTyN5haqQdwTeBUniRcc26DJB1v/TobkB6njIQOGFFi
         xw+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=raiVLCfAf9/vKVvJ2xvj7dS2xaKxdBfJtG6OeEt6BAQ=;
        b=sHCMADK91l+76Nw6KIkyfTBASKEiYnXnSSSt5AlMtopod4Gyfzo/mG0745sL3FPn+C
         xcqCFE5lFqo8a/OcX7KwCCjVy2YwjHmdCvEtrXtVgi0q8gyNF6RuFJ/USKZpBqnP/0V1
         1L5uytYeH45FjBwDDTIXVdy9l/lPv+k2xJ/ffgw0JRIok9AWc+dsuttyyFplSlF9Ekye
         goeG2MNCq/ewjSCiSpIGNuToouN1UmDXwI5NTiFOvDwxOY/fKz3q2aCZtaPvFdDh8AhI
         EuC/DoR6BZF1A/ROW5T4T6hRK32u3erYVHPieUG+YM0lxUgfhqjSqj/iqZxS3wTCTXfW
         qb2Q==
X-Gm-Message-State: AOAM531tk04jci94QiC8AAwbc911ZknfMALooBAStIzLeTJP22P0+hlX
        nvKDGyfpWuXAut06Csxa6lq4p7gyxh5v6UjdKZs4+Q==
X-Google-Smtp-Source: ABdhPJyzXaF1u80lP4DgHIw8/uR4ku0znI0wQFSkXveZodKfKY25fkNxFTdAONMzv/xzrlydDKgFP2vfU3qn9xKaCKs=
X-Received: by 2002:aca:5358:: with SMTP id h85mr5180044oib.6.1620768432575;
 Tue, 11 May 2021 14:27:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200529074347.124619-1-like.xu@linux.intel.com> <20200529074347.124619-4-like.xu@linux.intel.com>
In-Reply-To: <20200529074347.124619-4-like.xu@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 11 May 2021 14:27:01 -0700
Message-ID: <CALMp9eQNZsk-odGHNkLkkakk+Y01qqY5Mzm3x8n0A3YizfUJ7Q@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86: pmu: Test full-width counter writes support
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 29, 2020 at 12:44 AM Like Xu <like.xu@linux.intel.com> wrote:
>
> When the full-width writes capability is set, use the alternative MSR
> range to write larger sign counter values (up to GP counter width).
>
> Signed-off-by: Like Xu <like.xu@linux.intel.com>
> ---

> +       /*
> +        * MSR_IA32_PMCn supports writing values =C3=A2=E2=82=AC=E2=80=B9=
=C3=A2=E2=82=AC=E2=80=B9up to GP counter width,
> +        * and only the lowest bits of GP counter width are valid.
> +        */

Could you rewrite this comment in ASCII, please? I would do it, but
I'm not sure what the correct translation is.
