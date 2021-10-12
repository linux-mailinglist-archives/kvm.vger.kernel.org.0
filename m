Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDB4E429CD9
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 06:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232353AbhJLFAX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 01:00:23 -0400
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:48492
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232163AbhJLFAW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Oct 2021 01:00:22 -0400
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id E7D113FFDE
        for <kvm@vger.kernel.org>; Tue, 12 Oct 2021 04:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1634014700;
        bh=hvBTot48oWN512AikNK68C7U8Xt/2q1mSyxksTEkWiA=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=eJ95XAtiVp3K49Mo4LMDt+zZ+M0gXkoXQQPoEZhHrUN9u09uQliv9Qlh1FSaksde6
         X6ETptOaKch0FxAZ/3YFPSxP+Wf0GY1io8Ts2yk9/2CktAh1+koYe2FLU5ESmeE+VR
         ubVmmSL2GjjWB2sFJmjZGvuNVAJr1fvYIbqche4MfiP2YRwEpur0JvJrQyRwPR4Hsu
         FLDfcb9QkbyyCdIldw7qHMKYS6wuZpGSgAI4EpWkHTd8Y63IsKoIIkmwodcOAkdSot
         Fzy9BNTygdahcl8cNXgSwoviuufCOwKm5Rf+5Da0ZpUPte0a8b6PIopEjmHUFOg3zc
         DZd51+MCYGKcg==
Received: by mail-pj1-f72.google.com with SMTP id l10-20020a17090ac58a00b001a04b92a5d4so7642695pjt.8
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 21:58:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hvBTot48oWN512AikNK68C7U8Xt/2q1mSyxksTEkWiA=;
        b=3B4CNG2lTpaHRD7X6yJD+s1fXxUa21W6K6HbT1MEF9Tn2CAaM9yX+B1L/FDQLHBvaX
         hTu1N+bu6ZSXvmCkoaBg8H4zVGpUgRq04BBstzqpZ9IjNkTiB1Zhtwd4q0A6DlNTZKxc
         MoQ+1wOXVkeGwsg3juG11rqS8IYEj43OsSFmlMuyyp/1qmoEfJ3yKiRxpfGjadOkJ2aD
         XCEMumUtPyrTtob5CeCXwsJ6JeJY97C9aj1aB3qt8HwqvF/rWif/PB7suuBe8mURB6CE
         hzhDRAQLS5SxsgS1S4cnHHqqfb5jnG4fuX69qtzi0TByojbkZAySwO3iAv0NOe4nwdg8
         WUPg==
X-Gm-Message-State: AOAM532dHw6odMqeeM7CXJJOeUccuckwyyNIU6Kpq+/b8fqzDvO+c9t5
        r9gXo3inroETfh8PoX0SWIAufThOKEwepHbPX21jTSuZOhS3rBRkPIyOLq9+at3e7zxTYzke7SC
        JSocaE+P7BvWFODkfb/xfDxh9jckgsEmbjZaHLdtw4VoT9w==
X-Received: by 2002:a62:760f:0:b0:44c:eb65:8574 with SMTP id r15-20020a62760f000000b0044ceb658574mr19290930pfc.37.1634014699457;
        Mon, 11 Oct 2021 21:58:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyhWTbwH0aw/QoZPzqYWbrR6IdqBpR2Ij/uqi1u/uEp7r5mQIt3Na/tiV2gkOrOdj+hh8+IuEDCmJ0sTSzqlhs=
X-Received: by 2002:a62:760f:0:b0:44c:eb65:8574 with SMTP id
 r15-20020a62760f000000b0044ceb658574mr19290903pfc.37.1634014699112; Mon, 11
 Oct 2021 21:58:19 -0700 (PDT)
MIME-Version: 1.0
References: <d4084296-9d36-64ec-8a79-77d82ac6d31c@canonical.com>
 <20210914104301.48270518.alex.williamson@redhat.com> <9e8d0e9e-1d94-35e8-be1f-cf66916c24b2@canonical.com>
 <20210915103235.097202d2.alex.williamson@redhat.com> <2fadf33d-8487-94c2-4460-2a20fdb2ea12@canonical.com>
 <20211005171326.3f25a43a.alex.williamson@redhat.com>
In-Reply-To: <20211005171326.3f25a43a.alex.williamson@redhat.com>
From:   Matthew Ruffell <matthew.ruffell@canonical.com>
Date:   Tue, 12 Oct 2021 17:58:07 +1300
Message-ID: <CAKAwkKtJQ1mE3=iaDA1B_Dkn1+ZbN0jTSWrQon0=SAszRv5xFw@mail.gmail.com>
Subject: Re: [PROBLEM] Frequently get "irq 31: nobody cared" when passing
 through 2x GPUs that share same pci switch via vfio
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     linux-pci@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, nathan.langford@xcelesunifiedtechnologies.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

On Wed, Oct 6, 2021 at 12:13 PM Alex Williamson
<alex.williamson@redhat.com> wrote:
> With both of these together, I'm so far able to prevent an interrupt
> storm for these cards.  I'd say the patch below is still extremely
> experimental, and I'm not sure how to get around the really hacky bit,
> but it would be interesting to see if it resolves the original issue.
> I've not yet tested this on a variety of devices, so YMMV.  Thanks,

Thank you very much for your analysis and for the experimental patch, and we
have excellent news to report.

I sent Nathan a test kernel built on 5.14.0, and he has been running the
reproducer for a few days now.

Nathan writes:

> I've been testing heavily with the reproducer for a few days using all 8 GPUs
> and with the MSI fix for the audio devices in the guest disabled, i.e. a pretty
> much worst case scenario. As a control with kernel 5.14 (unpatched), the system
> locked up in 2,2,6,1, and 4 VM reset iterations, all in less than 10 minutes
> each time. With the patched kernel I'm currently at 1226 iterations running for
> 2 days 10 hours with no failures. This is excellent. FYI, I have disabled the
> dyndbg setting.

The system is stable, and your patch sounds very promising.

Nathan does have a small side effect to report:

> The only thing close to an issue that I have is that I still get frequent
> "irq 112: nobody cared" and "Disabling IRQ #112" errors. They just no longer
> lockup the system. If I watch the reproducer time between VM resets, I've
> noticed that it takes longer for the VM to startup after one of these
> "nobody cared" errors, and thus it takes longer until I can reset the VM again.
> I believe slow guest behavior in this disabled IRQ scenario is expected though?

Full dmesg:
https://paste.ubuntu.com/p/hz8WdPZmNZ/

I had a look at all the lspci Nathan has provided me in the past, but 112 isn't
listed. I will ask Nathan for a fresh lspci so we can see what device it is.
The interesting thing is that we still hit __report_bad_irq() for 112 when we
have previously disabled it, typically after 1000+ seconds has gone by.

We think your patch fixes the interrupt storm issues. We are happy to continue
testing for as much as you need, and we are happy to test any followup patch
revisions.

Is there anything you can do to feel more comfortable about the
PCI_DEV_FLAGS_MSI_INTX_DISABLE_BUG dev flag hack? While it works, I can see why
you might not want to land it in mainline.

Thanks,
Matthew
