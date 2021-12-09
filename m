Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE9F546E225
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 06:48:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232443AbhLIFwT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 00:52:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232371AbhLIFwS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 00:52:18 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E44DC0617A1
        for <kvm@vger.kernel.org>; Wed,  8 Dec 2021 21:48:45 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id p18so3066834plf.13
        for <kvm@vger.kernel.org>; Wed, 08 Dec 2021 21:48:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FzhXQ1DXqGpAK74xOecr+4scScmoJYLSnvomuB1FD0U=;
        b=BADIb+O6VlmOsH2ot7sr8I/LgM+/1Erp3VzO0L62CYAvfDpT39oYOost1vDELWjJkO
         PwrZRhUtG5nmMk6DjpXKteDDN6Z1s8gLn95F4wrhK7En/nFNyovupc81mAafHEsI0c6E
         xuWTxL4eEtG09r7g3exKTtKq9p53nQ2U1OlG0uyAIGqPvwPFKs+toAf1poNNtpZAZ2bH
         JiGvyZC0n0eztlzps8kQVa6p9f6lrS4Avbd4muNdFg2sG79OJmMkx135z19M52COBoxr
         6Cep8skFNqrLj43uW0vAApP5/itd8eNd6i97yBErigcPxACewEwlLn+bI1qsPvzkTD1P
         Je/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FzhXQ1DXqGpAK74xOecr+4scScmoJYLSnvomuB1FD0U=;
        b=DL+sbVnjfiVAnQ92rGyh8RpdzxyRqTC+ZFgerVg8Si+CjSfpsxSK6yWilEnLlcWzNe
         AZThYfs32440MeyLjw8VhLRlUgGBeb4Ue9GCC5sZ0p6zB15uh7+4AevUTeZXapkokorX
         b18j2r3tfdG/YSA0fiG5RfazqKm2OvpoUym1B31Pdp53tAxgKBYrpmr+UkDkiFWWif6/
         GzlC5/xyJqujCgBsWvkeNqLiz+7huRcPV24yu+ZmeX+g61r/cUl/P4YN1QZd62fz69hE
         MZVpKsjHuIA8A7HXfluiwnl9ez9gtcQlK1qfhaFOb0My1IiqDW20WeKhqjclxOwUDWNr
         J+CA==
X-Gm-Message-State: AOAM532Dbc681ytxBt13KqOYRohq/CzC74GYI1qMpO/WAqFGropUPYZ9
        heZzDCUlUFBROI2Iq5vn69qGzg==
X-Google-Smtp-Source: ABdhPJz+5oR8X4Gf87uVbWD+Y+QqoIGVsmUwPwjIfHJuMEPDQXLKvLOtsSRCXJIBGBW14OrfMxdazQ==
X-Received: by 2002:a17:90a:b015:: with SMTP id x21mr13176095pjq.84.1639028924871;
        Wed, 08 Dec 2021 21:48:44 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id f4sm5229428pfg.34.2021.12.08.21.48.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 21:48:44 -0800 (PST)
Date:   Thu, 9 Dec 2021 05:48:40 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] KVM: x86: Rep string I/O WARN removal and test
Message-ID: <YbGYuDgaqcRH/CZo@google.com>
References: <20211025201311.1881846-1-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211025201311.1881846-1-seanjc@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 25, 2021, Sean Christopherson wrote:
> Remove a WARN that was added as part of the recent I/O overhaul to play
> nice with SEV-ES string I/O.
> 
> For the record, my FIXME in lieu of a WARN was deliberate, as I suspected
> userspace could trigger a WARN ;-)
> 
> Based on kvm/master, commit 95e16b4792b0 ("KVM: SEV-ES: go over the
> sev_pio_data buffer in multiple passes if needed").
> 
> Sean Christopherson (2):
>   KVM: x86: Don't WARN if userspace mucks with RCX during string I/O
>     exit
>   KVM: selftests: Add test to verify KVM doesn't explode on "bad" I/O
> 
>  arch/x86/kvm/x86.c                            |   9 +-
>  tools/testing/selftests/kvm/.gitignore        |   1 +
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../selftests/kvm/x86_64/userspace_io_test.c  | 114 ++++++++++++++++++
>  4 files changed, 123 insertions(+), 2 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/x86_64/userspace_io_test.c

Ping.  I completely forgot about this too, until I unintentionally ran a
userspace_io_test that was lying around.
