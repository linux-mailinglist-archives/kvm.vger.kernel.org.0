Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF4E3DDE7B
	for <lists+kvm@lfdr.de>; Mon,  2 Aug 2021 19:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbhHBR0D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 13:26:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbhHBR0A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Aug 2021 13:26:00 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59C65C06175F
        for <kvm@vger.kernel.org>; Mon,  2 Aug 2021 10:25:50 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id g76so29688304ybf.4
        for <kvm@vger.kernel.org>; Mon, 02 Aug 2021 10:25:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q/q31t5T+36bS3/wvpT+OMFWaL1ftp/gRKotikKNdQw=;
        b=LhIAyiQ4DGJkN4/4LQ5fm3YGNPZdmEJzhy4txTg+V+8Zw+iHAkHNaGHWYKeM38WhGn
         7QaBiepaSP1JBqwB6VoBuL5StJZ8FPCt+zqDICi8hH1hGP9QkQxWHCgbfdN8niuBLPGz
         izjhivh6jzxNtq8gsLezGYQW8Vh9K9iFzkhXwcw/TtB9heltkVYRGc8qXQT1fQIBTra7
         bMzWWdLbxxn5SA55g6pb9ZsHloCXQ4QVaEe+uGIOmBrzwfflbfzSoOkd67ptugrOV0Oj
         uHA5LGlO3WHZyZ183S63juyO3D0VcmSwzWOy9snmvYxVgiND41QnhPuS1c9R5/sZigC5
         SpEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q/q31t5T+36bS3/wvpT+OMFWaL1ftp/gRKotikKNdQw=;
        b=lpbyRqIpFcdVnIToExB9vnytCZfm0YLX2G1e5n3dO7HIaIBXPplSAVRsOGMDv/hupb
         Jg1c6PgjSir9oJIfAQYfglCPTx2QxypW7C/Hd/EVO+WpT6zBx6iBn7hXDuYewPCe+fBW
         t+2n5AUvolj2yJENBd4+nFTYlamBATcuOiOCrc07IU454VzydBW1JtEWBWZlWdkCabss
         G1/SnGg5rNinWW/1G2uayoBWdc47wYkYyREg/Co1ZLL2gqYhmvr2cwYWCO9hDFilbSpm
         FJTgmzSM1Z3SyVaalFNmhVR7tsrUqxBU8iby6r8A3G+Nq7DwfztFS5JbAYdd8Ow5QMC5
         ranw==
X-Gm-Message-State: AOAM530yN33yyZ4J78J8Ya/PwaXbA61YW7fJI5x2pOvtsEUD+jFf1oqZ
        eVmqFQif+W893h+QF0dhzbc7D5HTmaop3Mm2fXEDUQ==
X-Google-Smtp-Source: ABdhPJw+a5aBgfV8UBGn5AEsMNJKdy9IHEJXHYJYV3cTfaKSyFzVTE1Rud/ZY6q5S1wRi0imigf/Yv+MY28MQqrZwRs=
X-Received: by 2002:a25:ab54:: with SMTP id u78mr8592843ybi.139.1627925149434;
 Mon, 02 Aug 2021 10:25:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210731011304.3868795-1-mizhang@google.com> <YQgamDDn6TVY/BoV@google.com>
 <71a905a1-0a6f-0d7a-f8fe-237b9e5af05c@redhat.com>
In-Reply-To: <71a905a1-0a6f-0d7a-f8fe-237b9e5af05c@redhat.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Mon, 2 Aug 2021 10:25:38 -0700
Message-ID: <CAL715WKVZqHG0sJhTn-ebJKjdj5pUQedL9kJjVRWMWoZGbzHFg@mail.gmail.com>
Subject: Re: [PATCH] KVM: SEV: improve the code readability for ASID management
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Marc Orr <marcorr@google.com>,
        David Rientjes <rientjes@google.com>,
        Alper Gun <alpergun@google.com>,
        Dionna Glaze <dionnaglaze@google.com>,
        Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

Thanks. I think Sean's suggestion makes sense. I will update it with
that one and remove the 'fixes' line.

Regards
-Mingwei

On Mon, Aug 2, 2021 at 9:53 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 02/08/21 18:17, Sean Christopherson wrote:
> >
> > Rather than adjusting the bitmap index, what about simply umping the bitmap size?
> > IIRC, current CPUs have 512 ASIDs, counting ASID 0, i.e. bumping the size won't
> > consume any additional memory.  And if it does, the cost is 8 bytes...
> >
> > It'd be a bigger refactoring, but it should completely eliminate the mod-by-1
> > shenanigans, e.g. a partial patch could look like
>
> This is also okay by me if Mingwei agrees, of course.  I have already
> queued his patch, but I can replace it with one using a nr_asids-sized
> bitmap too.
>
> Paolo
>
