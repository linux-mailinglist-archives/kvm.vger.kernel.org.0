Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01D2F4985BF
	for <lists+kvm@lfdr.de>; Mon, 24 Jan 2022 18:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244206AbiAXRFC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 12:05:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241329AbiAXRE5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jan 2022 12:04:57 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63143C061401
        for <kvm@vger.kernel.org>; Mon, 24 Jan 2022 09:04:57 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id u130so12286263pfc.2
        for <kvm@vger.kernel.org>; Mon, 24 Jan 2022 09:04:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/sOriIScpqGqSMCpSL1XXoMzsikUflsoN818peCbauo=;
        b=EelhhQ9FcRKTtaBSm9pIMg4gtPxg/0gsXW9D+HaCQelJT26SuHAZetCKYG5cT6FhYn
         Bqrk78GOZxDpOSNWNMMvtCmkZ4o4Gs1Nb4DY060KbmRIHOyip0eDBZ5722zcoCuc2oiA
         8pHFK9xlfK+DaU6zRvKMeFgA5FpraD96TUQu47uIs60xuE6sv7OXy/RV4jUH/xqL6qPO
         2U272nDy8NejYpdCOhYzANkaoox0ubPU9gAFRp77VoEnwV4eJTWHN0dGZy89MAHfqtGJ
         8enb9j/wnL/s6B51l6e0r7sL4OCV8n3thJho3i1k4A3R0SUg3Xe/28S3ZqKrIrvPvp6D
         X+5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/sOriIScpqGqSMCpSL1XXoMzsikUflsoN818peCbauo=;
        b=hMBoU0mzxcj4tJsML5g2nwudtzqawKLoFM28HWQcovyh3b4wq7p66CLrVDRm3EPBga
         kA6QsDeCSmJtbnr1o/aLDLSUWRBjaboMd/9Vlt0waD06gvN8jNK6A7Ac+xXaSsuzafNI
         p+qjgqr4hXYgQqATTCVOufX4AddgQarWMKUjOPZRwFO9jXIBe+6/gYwn4lU/O5H/Wc1M
         CNKOBRlGxTAHmtOcNvH9TU5/O2LkSqJHKA0Zxwj6AGJriWK85a1jajURg3Fxv7MzcR80
         WygsTyDVOlAWcVwRicLFYKxrcPnGl9PW1iWt9v8KrTc7O0CNe5hzzeVSnUQH2g5uMZCU
         6IoQ==
X-Gm-Message-State: AOAM531o4piXwkIBVBmeQnFR0YCDqKweoEj3rn16KtoHzPv+A9cOpxRx
        B8hHlpp0NjGum6Kz++LPdPbOkQ==
X-Google-Smtp-Source: ABdhPJzT0TczX4PYWrLVO38a96EyIar2HRyjGSuZpjo/m0cD2kMtPhw8hrOw/xoNFw2R+soXcTz7Jg==
X-Received: by 2002:a63:45:: with SMTP id 66mr12481383pga.607.1643043896594;
        Mon, 24 Jan 2022 09:04:56 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id z6sm12670970pgh.1.2022.01.24.09.04.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 09:04:55 -0800 (PST)
Date:   Mon, 24 Jan 2022 17:04:52 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ayush Ranjan <ayushranjan@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ben Gardon <bgardon@google.com>,
        Jim Mattson <jmattson@google.com>,
        Andrei Vagin <avagin@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Davidson <md@google.com>
Subject: Re: [PATCH] gvisor: add some missing definitions to vmx.h
Message-ID: <Ye7cNMZku7jlRHa+@google.com>
References: <20220123195337.509882-1-ayushranjan@google.com>
 <45a6395e-63f3-12b2-e6d1-52ccf00272e7@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45a6395e-63f3-12b2-e6d1-52ccf00272e7@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 24, 2022, Paolo Bonzini wrote:
> On 1/23/22 20:53, Ayush Ranjan wrote:
> > From: Michael Davidson <md@google.com>
> > 
> > gvisor needs definitions for some additional secondary exec controls.
> > 
> > Tested: builds
> > Signed-off-by: Ayush Ranjan <ayushranjan@google.com>
> > Signed-off-by: Michael Davidson <md@google.com>
> 
> Incorrect order of the Signed-off-by header (author goes first, submitter
> goes last).
> 
> > ---
> >   arch/x86/include/asm/vmx.h | 1 +
> >   1 file changed, 1 insertion(+)
> > 
> > diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> > index c77ad687cdf7..df40dc568eb9 100644
> > --- a/arch/x86/include/asm/vmx.h
> > +++ b/arch/x86/include/asm/vmx.h
> > @@ -67,6 +67,7 @@
> >   #define SECONDARY_EXEC_ENCLS_EXITING		VMCS_CONTROL_BIT(ENCLS_EXITING)
> >   #define SECONDARY_EXEC_RDSEED_EXITING		VMCS_CONTROL_BIT(RDSEED_EXITING)
> >   #define SECONDARY_EXEC_ENABLE_PML               VMCS_CONTROL_BIT(PAGE_MOD_LOGGING)
> > +#define SECONDARY_EXEC_EPT_VE			VMCS_CONTROL_BIT(EPT_VIOLATION_VE)
> >   #define SECONDARY_EXEC_PT_CONCEAL_VMX		VMCS_CONTROL_BIT(PT_CONCEAL_VMX)
> >   #define SECONDARY_EXEC_XSAVES			VMCS_CONTROL_BIT(XSAVES)
> >   #define SECONDARY_EXEC_MODE_BASED_EPT_EXEC	VMCS_CONTROL_BIT(MODE_BASED_EPT_EXEC)
> 
> I'm not sure why gvisor would care about an internal Linux header. gvisor
> should only use arch/x86/include/uapi headers.

It's Google-internal kernel crud, this patch should not be merged.  Though with a
bit of patience, an equivalent patch will come with TDX support.  If we do merge
something before TDX, I'd strongly prefer to take that "complete" version with a
rewritten changelog.

[*] https://lore.kernel.org/all/e519d6ae1e75a4bea494bb3940e1272e935ead18.1625186503.git.isaku.yamahata@intel.com
