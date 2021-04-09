Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2B7835910B
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 02:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233122AbhDIAt5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 20:49:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232426AbhDIAt4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 20:49:56 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC01AC061760
        for <kvm@vger.kernel.org>; Thu,  8 Apr 2021 17:49:42 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id r193so4184243ior.9
        for <kvm@vger.kernel.org>; Thu, 08 Apr 2021 17:49:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qC3DsFQp9eza9W51XDdceHkd/83cTsDDXTbOAJ2cHK8=;
        b=gA6fWvlZ9g0kFHdw3sUl6sZ5HCwFuvplDoXb1X9MAxOoy2KevrNJL56W/XyAmFztfJ
         HwFikiUchh0N8FHDQBARJaIgVKH+mr8S/3RhQmNLYcwNtXILFpoJKLhBRZmkkJ2RPvZr
         PMlq78+0qgvQCq0ZrKxdpQlNzRHyVPlJYUUhCMzcQnfOcvwxkPdWl5wRTr3umy9vvNIj
         i6s3lUIB7JXrO50wvIkANmN0XNrgsDv0ejYn10xOZYdTwAPNhZuPovJD0SCg627z1KFF
         +fR5jvEq7yseIt/WYGPSFEgLVOYb04QW0XbmOiMheeRGSbGn7eX9IWtCtnTux1wsr4BT
         fXTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qC3DsFQp9eza9W51XDdceHkd/83cTsDDXTbOAJ2cHK8=;
        b=VmsQyVFJbXiGx8a1LLn2xouj9lLx+j3kNI++02bZN1yIBCFPMiDyB0QKmB+rcRiABm
         1HRoy6zJNqaOCAT26KRwt4N3wtoU5A4EmX7mJY/wEkQ9t7XzughGREWGhy002TCvw/qm
         D/DqXShFupm3YtQJKkH10Ziy8AKsmpePjbj9z8aC553zob4v+WIF6NSuV6gUj7y8Df5W
         RFUhHlads6vOzgsOLOo4d0JEa1XuhGDRjCAseJCHcy7HRYlnZZdxbdTo+iN7xsT/sx9B
         yiP/UMrVwstdfnzmsoo/F3RvskjIxRvzW3u/KjHS21Zf2iJbs2imj/GhyF0RrZOWobmC
         S0KA==
X-Gm-Message-State: AOAM530ZEW8AP/NpWi/iKoooVbea8+hNon233vDD2+PCgZt6bNDG+Khj
        g2vPzYE+e4fX057EcVTEWM7/DP+dIC2tNSOad8p2nw==
X-Google-Smtp-Source: ABdhPJzCalwDwg9TE14hNaIpwcTDIA0jJkJYUNT7QPQhc+EbmWpQVMp/HBrzERN2R3BkhM8vCNRucMh7R+giCeKnIVk=
X-Received: by 2002:a02:ca13:: with SMTP id i19mr11782983jak.47.1617929381986;
 Thu, 08 Apr 2021 17:49:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210402014438.1721086-1-srutherford@google.com> <18c68409-5fcf-2f2c-61f2-e8e52aab277e@amd.com>
In-Reply-To: <18c68409-5fcf-2f2c-61f2-e8e52aab277e@amd.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Thu, 8 Apr 2021 17:49:05 -0700
Message-ID: <CABayD+fi2Q4nqNGiL8nuO3HfqZbq5PoEgimwWtwjX_o0nANFEQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: SVM: Add support for KVM_SEV_SEND_CANCEL command
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Nathan Tempelman <natet@google.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 8, 2021 at 3:27 PM Brijesh Singh <brijesh.singh@amd.com> wrote:
>
>
> On 4/1/21 8:44 PM, Steve Rutherford wrote:
> > After completion of SEND_START, but before SEND_FINISH, the source VMM can
> > issue the SEND_CANCEL command to stop a migration. This is necessary so
> > that a cancelled migration can restart with a new target later.
> >
> > Signed-off-by: Steve Rutherford <srutherford@google.com>
> > ---
> >  .../virt/kvm/amd-memory-encryption.rst        |  9 +++++++
> >  arch/x86/kvm/svm/sev.c                        | 24 +++++++++++++++++++
> >  include/linux/psp-sev.h                       | 10 ++++++++
> >  include/uapi/linux/kvm.h                      |  2 ++
> >  4 files changed, 45 insertions(+)
>
>
> Can we add a new case statement in sev_cmd_buffer_len()
> [drivers/crypto/ccp/sev-dev.c] for this command ? I understand that the
> command just contains the handle. I have found dyndbg very helpful. If
> the command is not added in the sev_cmd_buffer_len() then we don't dump
> the command buffer.
>
> With that fixed.
>
> Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>

Nice catch, will follow-up shortly.


Steve
