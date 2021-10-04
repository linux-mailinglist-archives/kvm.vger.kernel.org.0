Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 548564218CF
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 22:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231892AbhJDU5Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 16:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbhJDU5P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Oct 2021 16:57:15 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31915C061745
        for <kvm@vger.kernel.org>; Mon,  4 Oct 2021 13:55:26 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id y26so77508272lfa.11
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 13:55:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BVOz2ywn4vgcwaf5UpRzFG/fZKtTZbqhgLrCpaXRKEM=;
        b=TVKyp6Tv9ambqGLvur0aPYgw8c3HlSH5GFdpsWHyowA1SRXgMCdD7y5oZDsLsQFF0b
         qc+HP0+mxR2cyyk1zo/4udtj7zQrGlU8GIvmBcAKEcdkz84B60fBOvr+6GW9ce3Dr/Tn
         xnNb9lVb8YR46zhIjJPIWD/0FP2SPRWRLuFMTP9hirYlwv3Psubg9q2Z8F7sGuGMKIVF
         wYlfithiyyirg8+FoIWqob6VCfcYPyhnh7oFE2vAS7E2bxKRYYqk6qq4KuNeSf0MA1i0
         uJAvZvXX+7jurbCL06sjZ38PREuoUHFImYe8Bs62rcyVWASxRcO4orpEuN2GLRxovVZO
         REOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BVOz2ywn4vgcwaf5UpRzFG/fZKtTZbqhgLrCpaXRKEM=;
        b=aDwmdcErsgdL3QnhoDUzpCr2vJzwcQvG+nRncDBv5uEHzr9bb4husGJ0t0+FRJ62fM
         Mpb57F2lyFm4g1s7B2zy8vKb/PGTv2gZmamweE1GLCONErMzucwKwgZgTup4OGPM382K
         lNz/+2s8Pw0j9NntLUgzLBgB2gzv0Tit9V+zKs3Z/SDFPAtRJA5VTnEDYxDtcPSm2Rbj
         qMOZ082iQlpbVdxk8A1lLedWXBV+hGw4NQkt5156zh2LDILPQbkqNBAgiIDz42a1kR6n
         dQ1dF+0pMb72K3dZldKfNjSDyOjTBNOa+Ab7BMOi+kPfEcKf7GiFdgR41Wcffw8rJdH7
         H2Wg==
X-Gm-Message-State: AOAM531m9Vjur2bKjfwTQyY3UmhcbR4jjbJXyHxEhVQRB9j/XD4S4ztn
        X1GzYe4SD+Z4hzv4w4tuYJUe+0mTQbbeXA6mA02D87pWXz/qRyxN
X-Google-Smtp-Source: ABdhPJy6rUnxX+s97dwJi5TDBFy5jVdrD8qZvFETYhAPzaJkfDLt/Odpt2q9Ze/PZccL/gMzIs5awX6iRYfHl0l+j/k=
X-Received: by 2002:a19:c10d:: with SMTP id r13mr16601428lff.339.1633380924627;
 Mon, 04 Oct 2021 13:55:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210827031222.2778522-1-zixuanwang@google.com> <20211004132720.i77d2knwl7gxi3mx@gator>
In-Reply-To: <20211004132720.i77d2knwl7gxi3mx@gator>
From:   Zixuan Wang <zxwang42@gmail.com>
Date:   Mon, 4 Oct 2021 13:54:50 -0700
Message-ID: <CAEDJ5ZR6KSLYHmH-4oGi-_D9qNXwnTt1+vNKW0sWnTMLHcV-3w@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v2 00/17] x86_64 UEFI and AMD SEV/SEV-ES support
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Marc Orr <marcorr@google.com>,
        "Hyunwook (Wooky) Baek" <baekhw@google.com>,
        Tom Roeder <tmroeder@google.com>, erdemaktas@google.com,
        rientjes@google.com, seanjc@google.com, brijesh.singh@amd.com,
        Thomas.Lendacky@amd.com, varad.gautam@suse.com, jroedel@suse.de,
        bp@suse.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 4, 2021 at 6:27 AM Andrew Jones <drjones@redhat.com> wrote:
>
> On Fri, Aug 27, 2021 at 03:12:05AM +0000, Zixuan Wang wrote:
> >  create mode 100644 x86/efi/reloc_x86_64.c
> >  create mode 100755 x86/efi/run
> >
> > --
> > 2.33.0.259.gc128427fd7-goog
> >
>
> Hi Zixuan,
>
> If you still intend to work on this series, please send a new posting from
> your personal mail address to avoid mail bounces on reviews.
>
> Thanks,
> drew
>

Hi Andrew,

I just sent out the V3 patchset [1] (from my personal email) that
applies the comments up to the last weekend. I will apply the latest
review comments in the next version.

[1] https://lore.kernel.org/kvm/20211004204931.1537823-1-zxwang42@gmail.com

Best regards,
Zixuan
