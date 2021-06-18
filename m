Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38C693AD400
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 22:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234307AbhFRU7h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Jun 2021 16:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234310AbhFRU7g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Jun 2021 16:59:36 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EE27C061760
        for <kvm@vger.kernel.org>; Fri, 18 Jun 2021 13:57:27 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id x196so11937366oif.10
        for <kvm@vger.kernel.org>; Fri, 18 Jun 2021 13:57:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DD2GAVQkoZQHyaa/X6JS/cvzxNBSW/U8mImYnLJWDS0=;
        b=ptBPdegoTpxFZL3hRqyoHkhcHHHZWlkRWd0gzrxCWkhD2Yb1oedkwGS9bJffqTKc3M
         FVPxkXRUpkJIdAEv0zXdYGme0UjQ/Udf7ECul7eK0UPqFrPIp1ZQ/zQQ+Eow8uM4VDrt
         96Gz0zuGPj2eIwzYYQy1EYN4ewU/emTLtwM8R+RrtI4tOO6tbc69r0O0oIw3mMpqILON
         Gl4+/+EwS/bdx0TRCEmRYaihLfwKghlRe8dcKUbItvY4GXz3HZLDSaGAzSAMVoHEVKpy
         5uPJ8ZK0NHnJjXS1hq324j+Y7zGYQ2ReyYD9TJdiwOh36ITLanoEJvRVGpP0A5HwQkhK
         FtPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DD2GAVQkoZQHyaa/X6JS/cvzxNBSW/U8mImYnLJWDS0=;
        b=TpEqHzvUQrij95OHCUuTzasWm0l7bCLIb1emg+lnCLI5z1ZycBMpfZ6Z67fywh+cN/
         TkyI8aHNHfw0Boa3T2LO2nxv1K7ReXzG85FB4nAvRSxzecVJKfAXIobbbyFpS4PnOGCa
         92Df0qWxAJTgH1aSQ6N9x7LqHzl0getAac6bfMAaqA06bJZnq+52ohWuSMEFP81izVkF
         8vClAACpxMmYiMxvx5S35avpHGOXVAZ+TXjt3bxbXebNoDTtikdul4WlhUgqTol6QWqs
         4840TAc4TNHa9Yv7Q4+MspHioLyLiDZAXpnXPQgcMYCatK/N0Zs8JX9DNVvVUUgFSxsd
         vbfg==
X-Gm-Message-State: AOAM533DnfOLVB3G/005AFO3NfxU5jWs51EK1ssSET9D2v4nDNEEHkVs
        F9+eUxM/ljBwUMMLQSugMzEZQZqvZb8gqzNoYnMPC+//Pgkb9g==
X-Google-Smtp-Source: ABdhPJxRB5c05EfPudE7eVPn1bY0E2Y68W2rPmh1RTx0OS0PaLG1sASXax99ETUdCZhBYj5NOi8AbtA+1j1FjdyeaeU=
X-Received: by 2002:aca:aa4e:: with SMTP id t75mr16238217oie.0.1624049846727;
 Fri, 18 Jun 2021 13:57:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210618113118.70621-1-laramglazier@gmail.com>
 <ca3ca9a0-f6be-be85-b2a1-5f80dd9dd693@oracle.com> <CANX1H+3LC1FrGaJ+eo-FQnjHr8-VYAQJVW0j5H33x-hBAemGDA@mail.gmail.com>
 <CALMp9eT+2kCSGb5=N5cc=OeH1uPFuxDtpjLn=av5DA3oTxqm9g@mail.gmail.com>
In-Reply-To: <CALMp9eT+2kCSGb5=N5cc=OeH1uPFuxDtpjLn=av5DA3oTxqm9g@mail.gmail.com>
From:   Lara Lazier <laramglazier@gmail.com>
Date:   Fri, 18 Jun 2021 22:57:15 +0200
Message-ID: <CANX1H+2YUt6wF7P=jNBpfzJEnjz7Yz=Y8K_hWTwvYYbNb-vV2A@mail.gmail.com>
Subject: Re: [PATCH kvm-unit-tests] svm: Updated cr4 in test_efer to fix
 report msg
To:     Jim Mattson <jmattson@google.com>
Cc:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am Fr., 18. Juni 2021 um 22:26 Uhr schrieb Jim Mattson <jmattson@google.com>:
>
> On Fri, Jun 18, 2021 at 12:59 PM Lara Lazier <laramglazier@gmail.com> wrote:
>
> > My understanding is as follows:
> > The "first" test should succeed with an SVM_EXIT_ERR when EFER.LME and
> > CR0.PG are both
> > non-zero and CR0.PE is zero (so I believe we do not really care
> > whether CR4.PAE is set or not though
> > I might be overlooking something here).
>
> You are overlooking the fact that the test will fail if CR4.PAE is
> clear. If CR4.PAE is 0 *and* CR0.PE is 0, then you can't be sure which
> one triggered the failure.
Oh, yes that makes sense! Thank you for the explanation.
I will move it back up.
