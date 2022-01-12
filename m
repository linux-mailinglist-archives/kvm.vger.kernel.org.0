Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB4048C75B
	for <lists+kvm@lfdr.de>; Wed, 12 Jan 2022 16:39:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243685AbiALPjN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jan 2022 10:39:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234800AbiALPjL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jan 2022 10:39:11 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A904DC06173F
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 07:39:10 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id s30so9511911lfo.7
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 07:39:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4NHrrtVx/ROy3kyTlu3CE7Qr8R3mDdPRYahp1mG4kmY=;
        b=B3rgZ7TabV4LX9H6WnaYZZEmZ5pe9BI/soLu1GNchfDygG0BfByZZvt+R8JxgpSNny
         taj0E2QyqpUkIF3Nvnc+JJ+Oo/fhg0ptG4xvr4dQuzCDNhR2CTSV8fZcZB7iDbzSQ5FM
         WUlFpW8SgMvEtUmmJDtwJw5ERPVoY/mWvAeCemQTWpDRCZBrA4hdLwzlpHjjs8jzdEPu
         cLYG3C/4hEdnX2FvVl3StblDUOcZsMegX2fGX7kUcXdV7yHdfEjvq2XdwUHx6wtvgjZm
         V9Fl1mUK7AydBSYK0Tm9hKornS7+YwUU2eSVI1pRjkVy04JacmwPWXs6VGW4keCmYe9N
         ZfMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4NHrrtVx/ROy3kyTlu3CE7Qr8R3mDdPRYahp1mG4kmY=;
        b=n14bs9bXHn9wsvdVeRAIqchkEdheZvxCE254iKYGMufu2244nS5GvhL1vFCTT9NnUO
         D6bVyp25aSoKlKap63dokQGs0LsiiXVCvGUZdyr1pH05iFvrGmLCOLgeTKqozrtcpB8I
         eiqDbwOXMRn67jvwluc3vJJzvyVwaGvVYA0cPsVW6Opup3bZIl3urIkaSZBfQ/Bl9NII
         pLNIZLHD/HYglwtrCqFz2SX42pn36tvwgd/a2DcvvJXuDojsmoxkVzcG4YFrZ+B7plH1
         jnI6Rha/hb6SqDgP2y47bANE64/jRJeKMimoMkK6XRaS6dKNaI3zGmZ4WWvsvi/itXSj
         r++w==
X-Gm-Message-State: AOAM532oMvWDaeu6TenNFiPunw/0lcC2re4hu/g0j8SPDLeZzIa8r2vC
        sEDN5OgcjX/wVOssdVF4ScF2ABFeO3EvBQ0FIiIF9Q==
X-Google-Smtp-Source: ABdhPJyZcAf6iXBV+8nq0HU9ppkAPT2/aEbylm9rx5FMjJZsnQSALWFPMZ6r3jb0Q7/zqxxt8c25XqedkVk6grCm3Uo=
X-Received: by 2002:a05:651c:334:: with SMTP id b20mr58189ljp.275.1642001948722;
 Wed, 12 Jan 2022 07:39:08 -0800 (PST)
MIME-Version: 1.0
References: <20220112152155.2600645-1-ricarkol@google.com>
In-Reply-To: <20220112152155.2600645-1-ricarkol@google.com>
From:   Oliver Upton <oupton@google.com>
Date:   Wed, 12 Jan 2022 09:38:57 -0600
Message-ID: <CAOQ_QshBSJTR2aH4nDNnXD9ZsmU0uE+7Bh_SUHOBZEpNWGnfUA@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v2] arm64: debug: mark test_[bp,wp,ss] as noinline
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, Paolo Bonzini <pbonzini@redhat.com>,
        maz@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 12, 2022 at 9:22 AM Ricardo Koller <ricarkol@google.com> wrote:
>
> Clang inlines some functions (like test_ss) which define global labels
> in inline assembly (e.g., ss_start). This results in:
>
>     arm/debug.c:382:15: error: invalid symbol redefinition
>             asm volatile("ss_start:\n"
>                          ^
>     <inline asm>:1:2: note: instantiated into assembly here
>             ss_start:
>             ^
>     1 error generated.
>
> Fix these functions by marking them as "noinline".
>
> Cc: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>

Reviewed-by: Oliver Upton <oupton@google.com>
