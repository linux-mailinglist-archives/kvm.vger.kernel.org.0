Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69FA4435222
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 19:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231147AbhJTSAR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 14:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230351AbhJTSAO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 14:00:14 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21A43C06161C
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 10:57:59 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id n7so197959ljp.5
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 10:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lDwqq4V7Sn+tnjuS5kw3rvWzmCQKIuYIQkYA2weruRQ=;
        b=cElocYEWXB8qPgApmmTyAN7cfkQVAaUBcgW9z4/JXYYQF4fgZnpYlmLoBzGPjwtonc
         UIVnTrFJ6gPRez2lTjw4NPuoC79ovsjnOs32Eyt64yl+V/wXEseON6ieXzZ+5QXPappb
         ySuiSBa5MSRnQtx+pkCSMoZZGGKAXdcl/h7ijr8MgadT+D0FrU8qyXIjOiEInOd7UxEA
         tKbJvlPwBtGkp2A6q1DcLh7jvxu4Y6vM9eocFA/RF5Ep1Pr6NtsY/vALT7RJqB7P4GH8
         0j7Hh4KUqy444dvxa4+U1Ge5np59P++6sg88/FNWDvMn0GDNmRTAgiS8yv/C5Q4sLcdp
         BNIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lDwqq4V7Sn+tnjuS5kw3rvWzmCQKIuYIQkYA2weruRQ=;
        b=D1QYY7vDAnTWqgXmTcgtGOmqbhq4+EhAbodwjDeVfxIex6oTh5e7yHnFgquGHAc0BY
         T7owxMSIBEs9LwI0t9D2/pdgQ2EK4LNZd80B9uyz7YaH8jBQgpuQMuaXfNQcwMBq/K5K
         7cCiSltoN+RlLoeymsR9q5/hms7n5MGKhTtNgY6SfaVTssmjgqgRz1hx/e5PW5oyBJkd
         MzYTS1A5QR2Cj62MX8uS27hcaRjrKcSBrSJRvhxhIdoGEpQ5iTdij7CTM/PEnkHBDdDJ
         zqnqTejryM8Latb8Uubger5Srg666mkeim5f7pBB1IYcuHTjYbScgXjeewf6M3GRQXyb
         oS5w==
X-Gm-Message-State: AOAM530p2vbKf3Iabb4l2Bjm6rK/G5iMq3Db4jCnrsPSlbtkBweoY/z/
        zot8LzLK0jcR6qohPj7ZAt7hulw1s4HFtXQ4bJQ=
X-Google-Smtp-Source: ABdhPJyhcJqdt3rtgeLJVElachY0SP6KudCATDPSzpm6LMf6hdGirfLmDj4gkk9ueiE2KnTwYu8DliTA3uRcyotj8i8=
X-Received: by 2002:a2e:a48d:: with SMTP id h13mr610850lji.36.1634752677394;
 Wed, 20 Oct 2021 10:57:57 -0700 (PDT)
MIME-Version: 1.0
References: <20211004204931.1537823-1-zxwang42@gmail.com> <20211004204931.1537823-2-zxwang42@gmail.com>
 <e1e6c07a-132d-ba11-cca2-282315b23eb3@redhat.com>
In-Reply-To: <e1e6c07a-132d-ba11-cca2-282315b23eb3@redhat.com>
From:   Zixuan Wang <zxwang42@gmail.com>
Date:   Wed, 20 Oct 2021 10:56:00 -0700
Message-ID: <CAEDJ5ZSZMdUC=B2y0ZsVe30G-xZUe+xW2dVhH5R9vdcVS45Ecg@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v3 01/17] x86: Move IDT, GDT and TSS to desc.c
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Andrew Jones <drjones@redhat.com>,
        Marc Orr <marcorr@google.com>,
        "Hyunwook (Wooky) Baek" <baekhw@google.com>,
        Tom Roeder <tmroeder@google.com>, erdemaktas@google.com,
        rientjes@google.com, seanjc@google.com,
        "Singh, Brijesh" <brijesh.singh@amd.com>, Thomas.Lendacky@amd.com,
        Varad Gautam <varad.gautam@suse.com>, jroedel@suse.de,
        bp@suse.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 20, 2021 at 8:26 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 04/10/21 22:49, Zixuan Wang wrote:
> > +/* In gdt64, there are 16 entries before TSS entries */
> > +#define GDT64_PRE_TSS_ENTRIES (16)
> > +#define GDT64_TSS_OFFSET (GDT64_PRE_TSS_ENTRIES)
>
> No need to have both; in fact the definition can also be changed to
> TSS_MAIN/8.

I did not realize there is a TSS_MAIN, I will update this part.

> tss_descr is completely broken in the current code, I'll send a patch to
> fix it so you don't have to deal with it.
>
> Paolo

I just noticed the new patchset to fix the tss_descr, I will build the
V4 patchset based on that fix.

Best regards,
Zixuan
