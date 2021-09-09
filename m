Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC77405CF6
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 20:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237544AbhIISqw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 14:46:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238207AbhIISqu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 14:46:50 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D401C061574
        for <kvm@vger.kernel.org>; Thu,  9 Sep 2021 11:45:40 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id c19-20020a9d6153000000b0051829acbfc7so3731288otk.9
        for <kvm@vger.kernel.org>; Thu, 09 Sep 2021 11:45:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JSvIYNgKGMNxMRSqnMX2dPpowkm/XFedXnjl+cNoaAU=;
        b=cze72DPssS4q2CqVPvQCDfJCLo7Mmu4l01HFPBK4AJai7a4KdTKyXDzFl86K4SWJP4
         HDLbxe9TVCtkmuWjTjgtJjMxmTFMLJhrlrD3g0A4XnAGv/L6CxJEZ8dc7wpQXf56AghH
         tTixkDfBLiGzRuT45fsxc8W2gfgBlCZwTSmAG13Ml0X2e/HXKRy+H+avcz9lSXTRAqvu
         TAWCivHLvmWA0TBXcWc46hc5fB0wac48DnvDkLq8J+AuWRsTmmaOTK5rt3pjC2hHZWTh
         1bAv5758JuSN09peiuhOXA9ralxencOPdSIeIp4T/l0hSpoIGz8ZK5Al9GrNyqAryyAI
         dP/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JSvIYNgKGMNxMRSqnMX2dPpowkm/XFedXnjl+cNoaAU=;
        b=OX40qS8GXquSYA5hXMQ2elQH27gofi68tJ9BTEWANMHu6l7qevPVarm3VHoqt46i/F
         e3PWIksAehyDUCOv+8nnbXpFCPSbVh/jVUP0yaYYodg6kHLD4e9WqIdjcXXCxFMgXCLX
         9d2HDbfe450T33x854WVKYfUmHu24+No8Rc2JuX5PnnMsRtRfrWhkmO/XqAW0bdpcc4y
         6f4L0oWngSkRBP8CcKBEPZG3DM9Iwi0SdxA/ffCU0DKZpKv2M4KWoeWhFvfs6TmU1Hax
         BoSdLHZJnPMPnrynnV1xiRO+BoThMWWsY81A9x4J9cuque6js/x6O1fWgu8JAUX0CdHu
         /xhg==
X-Gm-Message-State: AOAM5334H16U5FkxY6RS6gs6FG2fK5taBkYUERL59aMIJ3jESXhBTs4L
        sSHXB9RMpfh5iPvFAEIjf5lKZ1KwW4Jm+cQqn9JfCw==
X-Google-Smtp-Source: ABdhPJyKR/+pNlwJrZETvaeyMYQXrb1pcplatS6NgiwnKwOE1tL7lRU3twekkzKreQd/0Te9bD6aI+22djs06pXMgNA=
X-Received: by 2002:a9d:5a89:: with SMTP id w9mr1104407oth.91.1631213139571;
 Thu, 09 Sep 2021 11:45:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210909183207.2228273-1-seanjc@google.com> <20210909183207.2228273-5-seanjc@google.com>
In-Reply-To: <20210909183207.2228273-5-seanjc@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 9 Sep 2021 11:45:28 -0700
Message-ID: <CALMp9eQiv+NbYzYFo_c21YoXxjUUH4YmPTPqxCy3U8c=u4ZEdw@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v3 4/7] x86: realmode: mark
 exec_in_big_real_mode as noinline
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 9, 2021 at 11:32 AM Sean Christopherson <seanjc@google.com> wrote:
>
> From: Bill Wendling <morbo@google.com>
>
> exec_in_big_real_mode() uses inline asm that defines labels that are
> globally. Clang decides that it can inline this function, which causes the
globally *visible*?
> assembler to complain about duplicate symbols. Mark the function as
> "noinline" to prevent this.
>
> Signed-off-by: Bill Wendling <morbo@google.com>
> [sean: use noinline from compiler.h, call out the globally visible aspect]
> Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
