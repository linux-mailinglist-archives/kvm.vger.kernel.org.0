Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 017D138F50D
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 23:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233936AbhEXVog (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 17:44:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233826AbhEXVof (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 17:44:35 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A82A3C061574
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 14:43:05 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id c12so10346543pfl.3
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 14:43:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lfftMmJm9tuvTykxsaiC5x+KQRUJrTAxoeeFR+VObs0=;
        b=T8Egf3tz7QWX7637yfEHPh325jFcbZ2ZmuDaXWDryojJ1B05uyZCWyM9us7h2/ykI1
         GvTfQbBIB09OaPIZyQ+w8qXp5RzxARbvvaoWZeWjUfWD1jo2kE0U/wP3L3x9InEy1sEZ
         gpsLjGofRIW5SONfb/rCnPnJtqQE8luO3oIs6VEqt7d99Detxn0mEkcoX5jVZOlj08+y
         iHpkYHyNlEFb3yhhUclSmGZaV847rTGIKpYEUgkcE1gS7sK9g0UlxjtuIqV6CIXZMb6N
         IIh2dvkvcFECUQzAqUemfrustuHJDff9vBUP7JCF6uEjWS4EGBuVHNunVh/81CrtCag3
         zOqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lfftMmJm9tuvTykxsaiC5x+KQRUJrTAxoeeFR+VObs0=;
        b=JiCek+5G43zC1J31MCUKw8A18AuXr6KBPRzNKAYlaqUVBgMTRGgW7NkX7Qm3qTzYIB
         7xatLJURHwMlQwEsErOMq0Ilg0J2M3ejLK18w55d9xAJBKoiL4qLFDnHOCxtecBi7EUC
         ZsZ3fwqZfCfJsGRfhelpBGe2GZn92TyOcqi0lkwkwZLU5wP4Me8nHMCTjihIF6jiZ1wS
         K2IqKHjwppJFZv6zqMt7OJR0Id4CrbA+qVkWHMWxQp1EKBPFImm/twu0vwRPyDm9XCzY
         lPV8wHhLqLXOR+qg1sKqSvJPl6r2x8CRw2Pxk/CUIEho8Ho6Q5qKbTSwzaPBykfQp2Ik
         IBLA==
X-Gm-Message-State: AOAM533Z0gNfvdX8VnB0ubKu7WFb7zCZQ3BBkExONLKy5vGNcc2ofBl/
        IsiCkBm8IqF7Vmc51ZcFIFfMfQ==
X-Google-Smtp-Source: ABdhPJwZJK/Hm/PkKpz6Ejit2JtZyXnl8T4Pt5vknor47K6z8fQc1g7/83fUsS0E5zccng6f8buqGw==
X-Received: by 2002:a63:581c:: with SMTP id m28mr15367289pgb.353.1621892585061;
        Mon, 24 May 2021 14:43:05 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id a15sm11249185pff.128.2021.05.24.14.43.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 14:43:04 -0700 (PDT)
Date:   Mon, 24 May 2021 21:43:00 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jing Liu <jing2.liu@linux.intel.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jing2.liu@intel.com
Subject: Re: [PATCH RFC 2/7] kvm: x86: Introduce XFD MSRs as passthrough to
 guest
Message-ID: <YKwd5OTXr97Fxfok@google.com>
References: <20210207154256.52850-1-jing2.liu@linux.intel.com>
 <20210207154256.52850-3-jing2.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210207154256.52850-3-jing2.liu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Feb 07, 2021, Jing Liu wrote:
> Passthrough both MSRs to let guest access and write without vmexit.

Why?  Except for read-only MSRs, e.g. MSR_CORE_C1_RES, passthrough MSRs are
costly to support because KVM must context switch the MSR (which, by the by, is
completely missing from the patch).

In other words, if these MSRs are full RW passthrough, guests with XFD enabled
will need to load the guest value on entry, save the guest value on exit, and
load the host value on exit.  That's in the neighborhood of a 40% increase in
latency for a single VM-Enter/VM-Exit roundtrip (~1500 cycles => >2000 cycles).

I'm not saying these can't be passhthrough, but there needs to be strong
justification for letting the guest read/write them directly.

