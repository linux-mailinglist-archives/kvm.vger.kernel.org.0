Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D94ED2422E9
	for <lists+kvm@lfdr.de>; Wed, 12 Aug 2020 01:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgHKXsa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Aug 2020 19:48:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726143AbgHKXs3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Aug 2020 19:48:29 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86473C06174A
        for <kvm@vger.kernel.org>; Tue, 11 Aug 2020 16:48:29 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id t7so576025otp.0
        for <kvm@vger.kernel.org>; Tue, 11 Aug 2020 16:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sPsMotHbZ2mAq8t842Nootr+VKSjqu0DocwTLDOmWVk=;
        b=ZaVxl0IfbJsW31WakBPpY8LTaSI/YLVOTBOn+WgLuyHnTD8nOc/esSfjOk1ektYhDZ
         dhbT7fugVxwMdMDlyDKc5n/IV6jH7eXEFztSAL3SXLofwDZ+oqCcVn0K5ESsA4Xt07wR
         ji3kfS6lf/H0uC5FswigGsEbIVun5Me5OKgQVWg8QK53OuDClYykLP4z4iDItkN4HsAq
         Sso4aXAkLzku4h30HYROZv7cHsFtLvN1FuWBB2+tz8Ko+fNnhYLOCHQdZaAY6tIIIxGc
         MwseO2hb5lCpe363CvEscuNxaducw87UdqcdTmvXljUkyu92l32rErXmaXXTxJ6Whpvt
         ZGag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sPsMotHbZ2mAq8t842Nootr+VKSjqu0DocwTLDOmWVk=;
        b=kc9KhBaUJr8kpVn8e9hcc264w4lSO3raUaGAMrY8OsVPk8hTnku6UlhjRfA16F14b0
         7kfCSan9nyA4g+ybEkH5V7IAD7nlxKAZcf5OFuC1hRxIhdn7L5ub9s7PeDJMrGKcbyEd
         ptXYtCwtNLdveg2Zuu+W48pbAccchkiu7eZUhLScEHORLCcFtOPBlADN9HGVAWIb2UYr
         AC3+bIleGkBRFYPytdht53But8mmMUUZwEZSVyOEMfp61w+Olt1Y4yJvqG/ylbnFJ2AF
         YlAyCPe+Tmh3jc9pqNnb2l0MGzrqMajU136sPDD+A4zot4+nAIOJ/omHsBFoXzm3Xahe
         vl6A==
X-Gm-Message-State: AOAM532SwlChPnPZMG9IraQNoVw6mVD6gpmUMAHfoLOzDvl7bUow4IMr
        5oN6NoSBn4A43FkySX+JddjJrnOruXZoFrPaOThGKIHBQW0=
X-Google-Smtp-Source: ABdhPJwN4wnGnYAjUOKC65tOSUsI88JVqL4O0MBeS5HXjoFCyOuXsLwGH/VSuiG03V/HUVaJ7vttC9Wyo5//JjNsJD8=
X-Received: by 2002:a9d:22ca:: with SMTP id y68mr6952612ota.56.1597189708246;
 Tue, 11 Aug 2020 16:48:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200811222353.41414-1-krish.sadhukhan@oracle.com> <20200811222353.41414-2-krish.sadhukhan@oracle.com>
In-Reply-To: <20200811222353.41414-2-krish.sadhukhan@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 11 Aug 2020 16:48:16 -0700
Message-ID: <CALMp9eTBOiJe8temqqVKjKUqEpcBzMYExzmZTGiyXM0_1fHPag@mail.gmail.com>
Subject: Re: [PATCH v2] kvm-unit-tests: nSVM: Test combination of EFER.LME,
 CR0.PG and CR4.PAE on VMRUN of nested guests
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm list <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 11, 2020 at 3:26 PM Krish Sadhukhan
<krish.sadhukhan@oracle.com> wrote:
>
> According to section "Canonicalization and Consistency Checks" in APM vol. 2
> the following guest state combinations are illegal:
>
>         * EFER.LME and CR0.PG are both set and CR4.PAE is zero.
>         * EFER.LME and CR0.PG are both non-zero and CR0.PE is zero.
>         * EFER.LME, CR0.PG, CR4.PAE, CS.L, and CS.D are all non-zero
>
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>

As Nadav will point out, these tests should run on bare metal. Also,
the repo is 'kvm-unit-tests', so maybe a better summary line is:
SVM: Test illegal combinations of EFER.LME, CR0.PG, CR0.PE, and CR4.PAE in VMCB


> @@ -1962,7 +1962,52 @@ static void test_efer(void)
>         SVM_TEST_REG_RESERVED_BITS(16, 63, 4, "EFER", vmcb->save.efer,
>             efer_saved, SVM_EFER_RESERVED_MASK);
>
> +       /*
> +        * EFER.LME and CR0.PG are both set and CR4.PAE is zero.
> +        */
> +       u64 cr0_saved = vmcb->save.cr0;
> +       u64 cr0;
> +       u64 cr4_saved = vmcb->save.cr4;
> +       u64 cr4;
> +
> +       efer = efer_saved | EFER_LME;
> +       vmcb->save.efer = efer;
> +       cr0 = cr0_saved | X86_CR0_PG;
> +       cr0 = cr0 | X86_CR0_PE;

Nit: Combine the two lines above.

Reviewed-by: Jim Mattson <jmattson@google.com>
