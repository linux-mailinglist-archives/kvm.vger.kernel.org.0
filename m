Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6BDC405CF9
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 20:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239045AbhIISsJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 14:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237208AbhIISsJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 14:48:09 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CD6FC061574
        for <kvm@vger.kernel.org>; Thu,  9 Sep 2021 11:46:59 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id v33-20020a0568300921b0290517cd06302dso3737937ott.13
        for <kvm@vger.kernel.org>; Thu, 09 Sep 2021 11:46:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2r9KTj1VBqaSmKTR7jqsPpz5r8nkNeZgvS4kggIVOv0=;
        b=a4gJACXU0kkRTkM42yerNd4e6Du8CF0dnieL69OSqE/AwYQTAsDJE0+lyUnXxiDjeM
         rtAdH3NDUpA01wm3uWln6Tbpy7MG1JPFbI1AnaU2PWqD0aqf6aYbRL13dOyADK6Hl9w4
         QiThrRmJ+XPR9domgzyJWpE2tTwkItF3MsRupdm+4JNV8cFCD5elWBVCDjiV0haA7grN
         O7DGVbs7hFHjE6+jFQD5fmu962VdUEOi4WahkvzuPikrNnPRbfIzr88hZe9vNQ6+A4S6
         toUcK+Y7cz8NnEasbH+b1zNee3eZRssf0zcg/NUIzhhQmBt1PXZL3eJlgTwPf3o1aaRG
         uJpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2r9KTj1VBqaSmKTR7jqsPpz5r8nkNeZgvS4kggIVOv0=;
        b=iWzlbT88SaqIDDMGGTVM7kzlwX6vfPnhA58LVkiiqqjKeDUp7ZLTxrsRN9l+3SFojM
         9Gl5KURQ/yYzM4ptz3xQ7UHMBh5ssUmylDWQRv3n4WtTQ62LN9fBbTCiFHh1OK//65mG
         3I1IXhSmmAxCGVb7PnfpOmQIg4WP05L6j5a9GEL4jA+yoKSGP1T3SMFwiVKre/hxlj+b
         IukPa7xh69WDloiWmrDWgmS8WQyrGdpwAPFmMadVgXmiT8gvnm3toPDGUJK3PoY3XSTK
         tmtiBTmjuIEoyK0tDostdzZt3Y/2DtgqMy/K7TsgnMmDzEvbOzIowRu5SbXMaJS11goP
         Wg/A==
X-Gm-Message-State: AOAM533bTtVbEEo4Cy4VsJL50KcQU2Gm1UXAuhn+FpoKzQxkimUdTqAg
        ZMyUFqJWVDtzMNL0f00Cn85Q4gdvuwS1xoihkfHG5A==
X-Google-Smtp-Source: ABdhPJyxLvrVWeI1ew3eiTibVHS1zFIQlZAn9F68/pqw8/WLTRIdq+5VS+gdRSnFMHD4fjzu1p3SN2GXHhR6fL2FCvU=
X-Received: by 2002:a9d:5a89:: with SMTP id w9mr1108800oth.91.1631213218490;
 Thu, 09 Sep 2021 11:46:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210909183207.2228273-1-seanjc@google.com> <20210909183207.2228273-6-seanjc@google.com>
In-Reply-To: <20210909183207.2228273-6-seanjc@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 9 Sep 2021 11:46:47 -0700
Message-ID: <CALMp9eTXTuQ8LJiuH7W8L=4DdoS+p7gTJDRfENOyJJcc5yLuNA@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v3 5/7] x86: svm: mark test_run as noinline
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 9, 2021 at 11:33 AM Sean Christopherson <seanjc@google.com> wrote:
>
> From: Bill Wendling <morbo@google.com>
>
> test_run uses inline asm that defines globally visible labels. Clang
> decides that it can inline this function, which causes the assembler to
> complain about duplicate symbols. Mark the function as "noinline" to
> prevent this.
>
> Signed-off-by: Bill Wendling <morbo@google.com>
> [sean: call out the globally visible aspect]
> Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
