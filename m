Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F43C31FC6C
	for <lists+kvm@lfdr.de>; Fri, 19 Feb 2021 16:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbhBSPxi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Feb 2021 10:53:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbhBSPxh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Feb 2021 10:53:37 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD74FC061574
        for <kvm@vger.kernel.org>; Fri, 19 Feb 2021 07:52:55 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id a4so6969934wro.8
        for <kvm@vger.kernel.org>; Fri, 19 Feb 2021 07:52:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nuviainc-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=WhPUHSs4T9cXX97zhzREpOXd4KMBJQv/1Ai9SXBR/QA=;
        b=bRWIM05mSfw2r8r3Plqwee0BmlXL6QnwXDyT+vYt8o4VKmGgLGJaSIRF+AP4Hziibr
         QPJTBeynsLtcOI+/IZ91a3RFBrPnC1WlyzDWvPx+psXudkn7oh6clx4DKYGO6CBGJA9c
         siP6l5pC2TFJFmEcB+oCZQPZpmMGbg1t2fNNNFgSVe4J/+mMNNhQHJOGgDXuzsfr07wk
         FpKdyUmhUAJVmC2CrIItaE4pQsknituVZ+2ixWxLB07XGQ3RoY+UdV0bwpuLQm+sDVuD
         vMoCdTotWu7WF7te3A0lEMdB8bYmm+0+5lea8bstHxl30dghAyu6h2e0V2Sv2hOzLX+K
         iTXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=WhPUHSs4T9cXX97zhzREpOXd4KMBJQv/1Ai9SXBR/QA=;
        b=ccAc6HGiV7aA1owl+3sm8YR+djCss4Z8oj9vok9GFP12yLAzRoxVkOfWXwXpGjWGUk
         4mO9sZ5jsDqsWLmyVvngcJTJrci/Sq0ZIKbcbOMVOYb/50RCpErt0F2NJHNuqu1VYIBL
         UIANN8iwyZ7QZGKH1YcrHQyDrIY4Yd+LQLPgVjfSTIyGUbWcj6kBqrhYTWDqyPZkyG7+
         q1VuCP1/y13pq6Yr0ngpYNXv2uIVy6lb7aSfUn6XLO7XbbLiunBzlpS0r3P+dJrSlvOV
         qY8of8Pfg0/ZFUNUJfRfAAVYo0CvvLmjzOAUSqAVlzNpL2oY6Y8Udawbe4ECZ+4ESJL/
         ABxQ==
X-Gm-Message-State: AOAM532zdiJFBvENQZCHNHST3PMZytRylapB9aTQtAZksfNEhWAOz84z
        hCsUr1h6GzWic9lJQ3NVVQjKuQ==
X-Google-Smtp-Source: ABdhPJwnWhNhoDaxHqROe4roZNOGcCHVsI4jwjNi+CQIRRgeH8Nl1IWOlIH26JAAV86IirRJ71O3SQ==
X-Received: by 2002:a5d:4b84:: with SMTP id b4mr9943957wrt.50.1613749974441;
        Fri, 19 Feb 2021 07:52:54 -0800 (PST)
Received: from vanye (cpc1-cmbg19-2-0-cust915.5-4.cable.virginm.net. [82.27.183.148])
        by smtp.gmail.com with ESMTPSA id l17sm2265039wmq.46.2021.02.19.07.52.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 07:52:53 -0800 (PST)
Date:   Fri, 19 Feb 2021 15:52:51 +0000
From:   Leif Lindholm <leif@nuviainc.com>
To:     Peter Maydell <peter.maydell@linaro.org>
Cc:     Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@redhat.com>,
        QEMU Developers <qemu-devel@nongnu.org>,
        Radoslaw Biernacki <rad@semihalf.com>,
        kvm-devel <kvm@vger.kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Thomas Huth <thuth@redhat.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        =?iso-8859-1?Q?Herv=E9?= Poussineau <hpoussin@reactos.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Alistair Francis <alistair@alistair23.me>,
        Richard Henderson <richard.henderson@linaro.org>,
        Greg Kurz <groug@kaod.org>, qemu-s390x <qemu-s390x@nongnu.org>,
        qemu-arm <qemu-arm@nongnu.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Cornelia Huck <cohuck@redhat.com>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <f4bug@amsat.org>,
        qemu-ppc <qemu-ppc@nongnu.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>
Subject: Re: [PATCH 2/7] hw/boards: Introduce 'kvm_supported' field to
 MachineClass
Message-ID: <20210219155251.GI1664@vanye>
References: <20210219114428.1936109-1-philmd@redhat.com>
 <20210219114428.1936109-3-philmd@redhat.com>
 <YC+nxWnB+eaiq736@redhat.com>
 <CAFEAcA-A=TG43w2yNfrDwCgYYNZBEa25cM_yYgREfQyKa=PZEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFEAcA-A=TG43w2yNfrDwCgYYNZBEa25cM_yYgREfQyKa=PZEQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 19, 2021 at 12:08:05 +0000, Peter Maydell wrote:
> On Fri, 19 Feb 2021 at 11:58, Daniel P. Berrangé <berrange@redhat.com> wrote:
> > Is the behaviour reported really related to KVM specifically, as opposed
> > to all hardware based virt backends ?
> >
> > eg is it actually a case of some machine types being  "tcg_only" ?
> 
> Interesting question. At least for Arm the major items are:
>  * does the accelerator support emulation of EL3/TrustZone?
>    (KVM doesn't; this is the proximate cause of the assertion
>    failure if you try to enable KVM for the raspi boards.)
>  * does the board type require a particular CPU type which
>    KVM doesn't/can't support?
> Non-KVM accelerators could at least in theory have different answers
> to those questions, though in practice I think they do not.
> 
> I think my take is that we probably should mark the boards
> as 'tcg-only' vs 'not-tcg-only', because in practice that's
> the interesting distinction. Specifically, our security policy
> https://qemu.readthedocs.io/en/latest/system/security.html
> draws a boundary between "virtualization use case" and
> "emulated", so it's really helpful to be able to say clearly
> "this board model does not support virtualization, and therefore
> any bugs in it or its devices are simply outside the realm of
> being security issues" when doing analysis of the codebase or
> when writing or reviewing new code.

Yes. This applies to sbsa-ref, for example.
We explicitly want to start in EL3, so no KVM for us.

/
    Leif

> If we ever have support for some new accelerator type where there's
> a board type distinction between KVM and that new accelerator and
> it makes sense to try to say "this board is supported by the new
> thing even though it won't work with KVM", the folks interested in
> adding that new accelerator will have the motivation to look
> into exactly which boards they want to enable support for and
> can add a funky_accelerator_supported flag or whatever at that time.
> 
> Summary: we should name this machine class field
> "virtualization_supported" and check it in all the virtualization
> accelerators (kvm, hvf, whpx, xen).
> 
> thanks
> -- PMM
