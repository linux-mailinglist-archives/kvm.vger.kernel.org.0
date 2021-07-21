Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF0813D1908
	for <lists+kvm@lfdr.de>; Wed, 21 Jul 2021 23:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbhGUUry (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jul 2021 16:47:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbhGUUrx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jul 2021 16:47:53 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E73ABC061575
        for <kvm@vger.kernel.org>; Wed, 21 Jul 2021 14:28:27 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id cu14so3249315pjb.0
        for <kvm@vger.kernel.org>; Wed, 21 Jul 2021 14:28:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=m52PtSGS5i2ngVfsBQ5ZUPxnRYkxsgX69pi1tPp/x28=;
        b=EkRmTC23UJLa27xiqrDPH9e0nL/5dbsaIMYECtzNpfQdqxU0y++VvIo9t3iZOZasl4
         jYpw45BVN3QaRitxTs3cwM8dzEJ2XqP31EZxKQ7iA3MxjV5p229J+WehsDebrvcj7VG9
         IFHImvsX9TSaZrJekSbBMbLHBqoIUFhU5393LxtR0GoWKzmQz2HQdZq6/oQCP1/8P/Ui
         wvRREhKgvtgIRbz96NCsgk/6a24bn9bmZrob2IZzZY31nKdoscikPvIXNGvT2TOY3X5R
         jZkyiU86yysTbPsDId8Uw/VFPTacnJshMELqVIB/27u9v+L/DZgQAv6fZn0RfgfbXARd
         6M5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=m52PtSGS5i2ngVfsBQ5ZUPxnRYkxsgX69pi1tPp/x28=;
        b=ssNt2NTlUGHi9+AszU0it9Sh7Vc95PfbpsqDzyQc++OCHxuubZpwYNwB2kLuXGhYOT
         vgs7JbO9fwVA0T6Kc0RsVGfl0fT2xjn09JOGH/ae1C6kZONfljg9JJcdwU6qg65ucINv
         N3k2DVye0qqWFON+lrGrrIB1Zi4nvfeWgLA9bGU76MWRHQIxqkAMwfcWYXt39/W8Q6EM
         UljMHFPWRV+yqYxScNQwmKLo9alPkYBLIQRPJht3jKtnsTPeD/26scMy/aklHds3txRs
         9l58x8sYtIO+DDe53ZM6iZdE36+KCeyTpUcI1XMnWleKDpZmkqMI1aVCCy6HGdpejDjf
         CiwA==
X-Gm-Message-State: AOAM532wX2nCWRnzS0++2UUux2+MuZJAt3zNPadpkS1Tc2bQVO2x71Ji
        D/KScZCItTNyPNs1nh36vsJP7Q==
X-Google-Smtp-Source: ABdhPJzsoonsfnNjS3Ej+And/W99sgjoE8mLSxLOu98GqGpd3UXFs6LJBzdPMDQ7TgaGj3mTUb7RMA==
X-Received: by 2002:a65:6a0d:: with SMTP id m13mr38552756pgu.356.1626902907296;
        Wed, 21 Jul 2021 14:28:27 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id w18sm25716948pjg.50.2021.07.21.14.28.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 14:28:26 -0700 (PDT)
Date:   Wed, 21 Jul 2021 21:28:22 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "KVM: x86: WARN and reject loading KVM if NX is
 supported but not enabled"
Message-ID: <YPiRdiG0uFFNGtmN@google.com>
References: <20210625001853.318148-1-seanjc@google.com>
 <28ec9d07-756b-f546-dad1-0af751167838@redhat.com>
 <YOiFsB9vZgMcpJZu@google.com>
 <20210712075223.hqqoi4yp4fkkhrt5@linux.intel.com>
 <YOxThZrKeyONVe4i@google.com>
 <20210713035944.l7qa7q4qsmqywg6u@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210713035944.l7qa7q4qsmqywg6u@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 13, 2021, Yu Zhang wrote:
> On Mon, Jul 12, 2021 at 02:36:53PM +0000, Sean Christopherson wrote:
> > On Mon, Jul 12, 2021, Yu Zhang wrote:
> > > Why do we need EFER in that case? Thanks! :)
> > 
> > Because as you rightly remembered above, KVM always uses PAE paging for the guest,
> > even when the host is !PAE.  And KVM also requires EFER.NX=1 for the guest when
> > using shadow paging to handle a potential SMEP and !WP case.  
> 
> Just saw this in update_transition_efer(), which now enables efer.nx in shadow
> unconditionally. But I guess the host kernel still needs to set efer.nx for
> !PAE(e.g. in head_32.S),

Yep, and that's what I messed up.

> because the guest may not touch efer at all. Is this correct?

KVM doesn't require EFER.NX "because the guest may not touch efer at all", it
requires EFER.NX to handle scenarios where KVM needs to make a guest page
!EXECUTABLE even if EFER is not exposed to the guest (thanks to SMEP && !WP).
