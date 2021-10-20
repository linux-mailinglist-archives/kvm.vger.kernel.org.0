Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D58E8435535
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 23:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231279AbhJTVVB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 17:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbhJTVVA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 17:21:00 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36529C06161C
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 14:18:46 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id j190so16915590pgd.0
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 14:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Bll2W98XN7W5K0WkO1mSX7ws9ecQGVFlpJLv71xA1jc=;
        b=ZOGRU53/QldS5l5egQnUfHLy/8NWRG3hIhHXk989m8Lc3vBZ9O3J5SUl16B8UqVgWd
         KJxTPmrJi9OPla3OEnyWCeIAzmi3II9dtlEI8fYpQ3pdkEi9hBN/ei1Qzshiz98T6QIv
         26pwhsKG8cMDZKk/3pGO5T2xU2JMKDzxNqD4Q02yO+K09K9Ak/idqaG2B6UeUUVGquse
         st8ttXtIG0PJRLdqOT14RF6n88SY0H75lfPkqZ5DdOzBpVCaHaXQdXc2gyFmlPc5jq3s
         QwVwqdrsLiM8K709CBi1XWJGWb8h5p5aeIz8d1nCR2eRnxLMzAEsQW8/ltBQ7wAJ0zPX
         FaCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Bll2W98XN7W5K0WkO1mSX7ws9ecQGVFlpJLv71xA1jc=;
        b=2NpELCQpSoCVblf28KfxTGOQh/wO4n6i10KgNOo9UWdgLaZZk6l7R5PjGX9rsST9Lp
         WhjOJBM/lXIku30Y2sAMwrh6xrsIn9nGdaK9VtAINNtkDNSp8eJrOCTR0htberOldvFt
         8OettankWUEswmFoM6KdeGO1raGwwZ74aSqBBymPpk/sHHPF8daZqESIw/7mAyF+KbJg
         RoNc5g8Kdc4dVAhh+Orev2s1LlS3Vz11ERjjeVo9lHkBz17j17Xte/mlVqsGcc3XGQqb
         tDHVCrM0spRelMmpmvLQeDf+het87WkEzDyzAzZ2whS1QZtRNARlHF0Ym9nVAKBLlDzw
         IxLw==
X-Gm-Message-State: AOAM5327tuRrJVXGJrYYBzLuJHXgp7Khsir1GnUmtGMgc7kfw1ee8PGj
        uw5WNfLauAvoz0Oug5/FPez2xGTrardInT2l14QTGQ==
X-Google-Smtp-Source: ABdhPJyR+h61QuQNvO9ZPsWT0LVwK7Ze3BPtj7W4ux6rdm8C9fCRjrByIWxx/DrS3KILxvbGWjQ1Q7rAYntzsExYMCI=
X-Received: by 2002:a05:6a00:214d:b0:44d:35e9:4ce2 with SMTP id
 o13-20020a056a00214d00b0044d35e94ce2mr1186749pfk.13.1634764725459; Wed, 20
 Oct 2021 14:18:45 -0700 (PDT)
MIME-Version: 1.0
References: <20211020192732.960782-1-pbonzini@redhat.com> <20211020192732.960782-3-pbonzini@redhat.com>
 <CALMp9eTbehPFGb2UTDiV8Q7zo6O9_Dq39=V_DdcQKG3-ev1_8w@mail.gmail.com> <0a87132a-f7ea-5483-dd9d-cb8c377af535@redhat.com>
In-Reply-To: <0a87132a-f7ea-5483-dd9d-cb8c377af535@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 20 Oct 2021 14:18:34 -0700
Message-ID: <CALMp9eRY_YYozTv0EZb5rbr27TJihaW3SpxV-Be=JJt2HYaTYQ@mail.gmail.com>
Subject: Re: [PATCH v2 kvm-unit-tests 2/2] replace tss_descr global with a function
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, zxwang42@gmail.com, marcorr@google.com,
        seanjc@google.com, jroedel@suse.de, varad.gautam@suse.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 20, 2021 at 2:12 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 20/10/21 22:46, Jim Mattson wrote:
> >> -       vmcs_write(GUEST_LIMIT_TR, tss_descr.limit);
> >> +       vmcs_write(GUEST_LIMIT_TR, 0x67);
> > Isn't the limit still set to 0xFFFF in {cstart,cstart64}.S? And
> > doesn't the VMware backdoor test assume there's room for an I/O
> > permission bitmap?
> >
>
> Yes, but this is just for L2.  The host TR limit is restored to 0x67 on
> every vmexit, and it seemed weird to run L1 and L2 with different limits.

Perhaps you could change the limits in the GDT entries to match?
