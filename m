Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5DBB228B07
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 23:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731194AbgGUVVM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 17:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731145AbgGUVVL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 17:21:11 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A89AC0619DC
        for <kvm@vger.kernel.org>; Tue, 21 Jul 2020 14:21:11 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id 1so53644pfn.9
        for <kvm@vger.kernel.org>; Tue, 21 Jul 2020 14:21:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Wo2KSkt2uKsTjaxUKUx/AXgKzZQLVgE9fv7oC1pgM9U=;
        b=fxicQTWxrU2WqFRihd/VZT/MbC0QG/JVXizq/OhLoM/dTFzG3ztptOTItob3McBPXl
         s/8rfUZi4yvPRDPzB4x1DM25Qk+bOwKx9ZxSOBscZuk4ExZ2eBtnhHe9rpBAjbWdJNu3
         j1RWLpTE+MfqYyimAtHkTaWYpckroafRcSc40=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Wo2KSkt2uKsTjaxUKUx/AXgKzZQLVgE9fv7oC1pgM9U=;
        b=C+Yxa3RlCybgoAK7ItYDyggZ5x8wW+9AMQqlbT506kn6PnbKoIBav5u7Yfms5k0duB
         AxBCOz745Ooamr0F3WbqJcDwkk4o7+GPEr8OAOCa9YpgERm+Nw4rvkQtHjNutcnlvX3D
         KinKDn7sikVZ5iesxVNb/WiKEmqWk/OSSG4wGxSc8pZZWb26+u1T5rbPZLZ7tXO9B6j4
         7NcaZxw47Kb285Hr1YDt0ainJlzcVu1vVn+1xRuq28AsI9MrIUqVLxTzPDw1B3SYA6od
         9VmWKBuGEv9xvw930ratQZJKg3SKwRzAGgC2AmqGjn2BwVsavu9jIDR7JGGOVIVxRNau
         HFTQ==
X-Gm-Message-State: AOAM531MPAyAOUOtwYXBZ6NLwEGfNCXRs960/ophNbw7WtMaRJyvlycX
        +A7nsEbQAEOn8UYxBbDihbB0yQ==
X-Google-Smtp-Source: ABdhPJxDDnyEVXIY4rLb+RsPBAy4yKWxQVpSGTnpY8gFur3vVyP2p27baBMA8SghPFnQbtOFo9/T2w==
X-Received: by 2002:a62:6305:: with SMTP id x5mr26195638pfb.81.1595366470930;
        Tue, 21 Jul 2020 14:21:10 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id 66sm21380770pfg.63.2020.07.21.14.21.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 14:21:10 -0700 (PDT)
Date:   Tue, 21 Jul 2020 14:21:09 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        linux-arch@vger.kernel.org, Will Deacon <will@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Mark Rutland <mark.rutland@arm.com>,
        Keno Fischer <keno@juliacomputing.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>
Subject: Re: [patch V4 01/15] seccomp: Provide stub for __secure_computing()
Message-ID: <202007211421.FE862FEE@keescook>
References: <20200721105706.030914876@linutronix.de>
 <20200721110808.348199175@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200721110808.348199175@linutronix.de>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 21, 2020 at 12:57:07PM +0200, Thomas Gleixner wrote:
> To avoid #ifdeffery in the upcoming generic syscall entry work code provide
> a stub for __secure_computing() as this is preferred over
> secure_computing() because the TIF flag is already evaluated.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Acked-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
