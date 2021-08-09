Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B58E3E4859
	for <lists+kvm@lfdr.de>; Mon,  9 Aug 2021 17:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235452AbhHIPJB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 11:09:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235365AbhHIPJA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Aug 2021 11:09:00 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BD95C0613D3
        for <kvm@vger.kernel.org>; Mon,  9 Aug 2021 08:08:40 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id lw7-20020a17090b1807b029017881cc80b7so9032680pjb.3
        for <kvm@vger.kernel.org>; Mon, 09 Aug 2021 08:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GxPf+PJ9uPiWBgqJeRfB1gbBmulxVC9qhyEnT2/QSFs=;
        b=YL4YMqDB4dFWVBSjmi7vQMy17STRsuMNn6w9Z5unBeYltViqi3qlLYjuRg4BQtcRYt
         eqI/GPtDROa4pxvwo8kVVTaMXIsJs/1aM1zM3BU3KOrSD6VgZ7RBW9WUBje3uUI+dhk/
         ASUPRXfkY0dZZfgQ3TTX8B49479aY+m2Dv8jg/GklwKP2nG3LzMTjz/7wLfdokvLmzdQ
         Sja03hEcCuuosgUwTJFYcfltgjOCH5xFW4aXBN0l3t/hbnQUN4jmwqA6pbODL+gX2rBu
         2Ap6dKrz26G26epieQrJOO3gNbR87N+KDC9tYG/OxmwiYTYYzgIkCfoYrJNzR0EWjrjV
         5zgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GxPf+PJ9uPiWBgqJeRfB1gbBmulxVC9qhyEnT2/QSFs=;
        b=mBV5E4PQ5I8JRa1kKvu6/t5WrTN0n8eWJlBisQJvbw8spQgvTHHTHgaRah3/uXUXzK
         tTzlYrzBYd/dK/8gQ6p7rdIxz3u+vgS9f8pJH7w2aNi3nashGlKggb1EKugafAo0XisM
         LcCtaa+bDV+i6ByFpPzB7TBFL/sE4gXyeAwGP/Hixjpl1xtHBXAzwbL4N5HK9qQcFYsm
         U026YNqanfsYCad+jpTwNZrtEXaBuy1KMNE29Ix5fh4YT5I6W8pqs1yhhAvlGPOCsjSK
         +YEpRr/Rf4DLBvKaYtaC8FE8qIOef78kA/68Epu8KLCWFQyX0QyL74cf6lTEIc7r/dvC
         WHeg==
X-Gm-Message-State: AOAM533ULu8SV6FxR6U7CH7t52I8OkH+Z5tl1/2WBF70pG3GCwHIsCZW
        1t+6EQ0vKOcA+yyYiyj7AE7N6A==
X-Google-Smtp-Source: ABdhPJyAJf39mUhFmkTBZAOzAOLgL4pjwIl0elxQpmyJU6cl/ljto5YQ8CYmZFFDwSRLso5nebowIQ==
X-Received: by 2002:a17:903:2448:b029:12c:cbce:8f86 with SMTP id l8-20020a1709032448b029012ccbce8f86mr3137905pls.72.1628521719705;
        Mon, 09 Aug 2021 08:08:39 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id n35sm24046071pgb.90.2021.08.09.08.08.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 08:08:39 -0700 (PDT)
Date:   Mon, 9 Aug 2021 15:08:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] KVM: x86: Clean up redundant macro definitions
Message-ID: <YRFE8y24+5P31RjK@google.com>
References: <20210809093410.59304-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210809093410.59304-1-likexu@tencent.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 09, 2021, Like Xu wrote:
> In KVM/x86 code, there are macros with the same name that are
> defined and used separately in the evolving code, and if the scope
> of the code review is only on iterations of the patch set, it can be
> difficult to spot these fragmented macros being defined repeatedly.
> 
> IMO, it's necessary to clean this up to improve the consistency and

Please use more specific shortlogs.  "Clean up" is too ambiguous, e.g. I would
expect it to mean "clean up the macro itself".

> readability of the code, and it also helps to avoid software defects
> caused by inconsistencies in the scope of influence of macros.
> 
> Like Xu (5):

>   KVM: x86: Clean up redundant mod_64(x, y) macro definition

Feels like we should find a home outside of KVM for mod_64(), it's a full generic
and straightforward macro.

>   KVM: x86: Clean up redundant CC macro definition

CC() should be kept where it is.  It should never be used outside of nested code
and is far too generic of a name to be exposed to the world at large.  It was
deliberately defined only in the nested.c files.

>   KVM: x86: Clean up redundant ROL16(val, n) macro definition

Moving ROL16 seems ok, though it scares me a bit that someone went through the
trouble of #undef'ing the macros.

>   KVM: x86: Clean up redundant __ex(x) macro definition

__ex() and __kvm_handle_fault_on_reboot() were supposed to have been removed.
The last two patches [8][9] of this series[*] got lost; I'll repost them as they
no longer apply cleanly.

>   KVM: x86: Clean up redundant pr_fmt(fmt) macro definition for svm

NAK, this breaks sev.c's formatting.  Arguably, nested.c and avic.c should use
more specific print messages, though that gets tricky with nested code as it's
not wholly contained in nested.c.
