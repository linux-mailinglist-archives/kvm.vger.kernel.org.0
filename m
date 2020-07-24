Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01A0122CCAE
	for <lists+kvm@lfdr.de>; Fri, 24 Jul 2020 19:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727098AbgGXR4H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jul 2020 13:56:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726593AbgGXR4G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jul 2020 13:56:06 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1A86C0619D3
        for <kvm@vger.kernel.org>; Fri, 24 Jul 2020 10:56:06 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id b9so4897069plx.6
        for <kvm@vger.kernel.org>; Fri, 24 Jul 2020 10:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LPBr9y0mSQ0vEFDVd2yPcrY3mpjPcnCTz8oQxhRntWI=;
        b=eZoWliuezeOxys0b9UQOnD/o0lGyFr5fKeejVdFUARBWrlFx+qV4PZjxeb6W0f1v0q
         spduBP91FEopvvNX5ho4hKvodAgkrttgRK3rPTVXtOlImPSiICCvOps9A0ZVwkXhHHhW
         2aUmPdKVudVlnVPtPFeLyvUVR6CmhAVkjvfog=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LPBr9y0mSQ0vEFDVd2yPcrY3mpjPcnCTz8oQxhRntWI=;
        b=eXjjWK9BnMf/uKabVlW2oO3nJhpOk/kTosl5oJlS5ZJnFhrIu793tcSTfxNs6f9IpV
         vQcNLHx2Jx9D3w+nfypDMtcYTLGsCgg4sfB1+t3WlzXSwIyYCinn+7RfDuLOiB/CCQNh
         ocCI705UNIrMhljSHyHP4GrofrvSJ90gLE+dxWRaw/7LX9z9TV6LVXAP3ZdLFZ4gIxqO
         BJ0hixcV+m/psMDphzRgckZqe1OpKlTNaCbhtfS8zMjh9QoGXu9tLArB3Txq1QETW5z7
         UT2gP/OHqR8257Q0rOJ5SOQ4A7T4FFNW7kLv5uR8kAksGOrP/q6ydYX7F+NMzFFBkYEw
         mnRA==
X-Gm-Message-State: AOAM530g3OWpt1zj2SlSL/gE2GxpZ1GTtErjoQoFATsz87YipZOb/U+5
        WUaI+HKZzEai8XbZZ9Xn2qwwhw==
X-Google-Smtp-Source: ABdhPJyDax/qJPR4ZLz3NJokDK6V9QQCwKq9zwdj3ZJ38OEFknglmOqbh2MmPwVgkyNP/voUnR7jUA==
X-Received: by 2002:a17:90a:22ab:: with SMTP id s40mr6997041pjc.117.1595613366344;
        Fri, 24 Jul 2020 10:56:06 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id f207sm7271770pfa.107.2020.07.24.10.56.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2020 10:56:05 -0700 (PDT)
Date:   Fri, 24 Jul 2020 10:56:04 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, Joerg Roedel <jroedel@suse.de>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v5 71/75] x86/head/64: Rename start_cpu0
Message-ID: <202007241056.091E681@keescook>
References: <20200724160336.5435-1-joro@8bytes.org>
 <20200724160336.5435-72-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200724160336.5435-72-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 24, 2020 at 06:03:32PM +0200, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> For SEV-ES this entry point will be used for restarting APs after they
> have been offlined. Remove the '0' from the name to reflect that.
> 
> Signed-off-by: Joerg Roedel <jroedel@suse.de>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
