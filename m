Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44F31115772
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2019 19:53:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbfLFSxH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 13:53:07 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:46323 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726317AbfLFSxH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Dec 2019 13:53:07 -0500
Received: by mail-pf1-f196.google.com with SMTP id y14so3762962pfm.13
        for <kvm@vger.kernel.org>; Fri, 06 Dec 2019 10:53:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=K3ULS82TM5X3oy+N7bLM5wCXYGvU66vvX1ioV7TywQA=;
        b=ExSOppud6x7oyh7jQafYUvPvNOXeUGL6Tfs3axjJWXXEm7+DGmcpWm8uUuwQWjiKsw
         4DjGbjcvL1SBYWbmQpIom/13VK14MV/ANsxs/0s4iCCkZ76s1Sl18Vhfhtn8LX/WPqJ+
         n+fTieTyvg5PXprzNJYdOguIF8yOjsAf0CpvuVnXL7DPDYJDdxZ8a/exvEKNp86KhrhZ
         IIa6KnJ9KuGTdQ/XUGYiALS0YPjRRMxY8uRhKCjTf8aVs+sP4Kvk4gqza6tXGgtLX9tq
         esQx6v+KQw0qrhBwJb66uhgu1RgYTqWUK1wlICYCm3tCe3rBwm1OGllhwXUh9AcrGXA3
         7eyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=K3ULS82TM5X3oy+N7bLM5wCXYGvU66vvX1ioV7TywQA=;
        b=MwdTFt+2v2ujsMLvuVWhlzORghXRErG1aPCJjCP6+7tk1Ko4zcz5s4WK+wxGWDYS9L
         vBMzdUukDszh3J0xjSahpGC0XUadzLtwWR9QNLluFGIkZmf6wdYvWqe46bAvKDedgTQT
         PZLpzqYIrmcue2lWhG83P5M3vo1mnd/XYNdDIl+NGgT3wMg3hW6LUgA8eLKDXFroj+f2
         aSpgQX56YFFpiglaVAFjakjLoivqXOMJVh/rc9N5MpnCMwq2olOe9kTtP1dItIujcJRH
         nX9W2283eF4vOA82+N+EETHeSp8hBYgjhV63x8dW5axAwZWY+KbOPXhNgul1LmrPyxjE
         iIXg==
X-Gm-Message-State: APjAAAVg+9Q4ijwcosrhhyS+lUOqjokOfMIALWXzb7k4AyoClej1mITw
        XzQm5NYfq+NMkBgPxOc8tPBT/w==
X-Google-Smtp-Source: APXvYqxmgKQUom0IC5pFsT4lzSuFsQPzwlPTXfnMVHpgbstIu3U8KPunAzMuP13hE8dxBSRjmv7kqw==
X-Received: by 2002:a63:c12:: with SMTP id b18mr5041685pgl.156.1575658386217;
        Fri, 06 Dec 2019 10:53:06 -0800 (PST)
Received: from google.com ([2620:15c:100:202:d78:d09d:ec00:5fa7])
        by smtp.gmail.com with ESMTPSA id h14sm10333962pfn.174.2019.12.06.10.53.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Dec 2019 10:53:05 -0800 (PST)
Date:   Fri, 6 Dec 2019 10:53:01 -0800
From:   Oliver Upton <oupton@google.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: expose "load IA32_PERF_GLOBAL_CTRL" controls
Message-ID: <20191206185301.GA93531@google.com>
References: <1574346557-18344-1-git-send-email-pbonzini@redhat.com>
 <7fea1f06-9abb-cdd1-9cb9-8655fe207e96@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7fea1f06-9abb-cdd1-9cb9-8655fe207e96@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

Sorry I didn't see this earlier. Thank you for addressing this!

On Thu, Nov 21, 2019 at 10:42:18AM -0800, Krish Sadhukhan wrote:
> 
> On 11/21/19 6:29 AM, Paolo Bonzini wrote:
> > These controls were added by the recent commit 03a8871add95 ("KVM:
> > nVMX: Expose load IA32_PERF_GLOBAL_CTRL VM-{Entry,Exit} control",
> > 2019-11-13), so we should advertise them to userspace from
> > KVM_GET_MSR_FEATURE_INDEX_LIST, as well.
> > 
> > Cc: Oliver Upton <oupton@google.com>
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
> >   arch/x86/kvm/vmx/nested.c | 2 ++
> >   1 file changed, 2 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index 4aea7d304beb..4b4ce6a804ff 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -5982,6 +5982,7 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps,
> >   #ifdef CONFIG_X86_64
> >   		VM_EXIT_HOST_ADDR_SPACE_SIZE |
> >   #endif
> > +		VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |
> >   		VM_EXIT_LOAD_IA32_PAT | VM_EXIT_SAVE_IA32_PAT;
> >   	msrs->exit_ctls_high |=
> >   		VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR |
> > @@ -6001,6 +6002,7 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps,
> >   #ifdef CONFIG_X86_64
> >   		VM_ENTRY_IA32E_MODE |
> >   #endif
> > +		VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL |
> >   		VM_ENTRY_LOAD_IA32_PAT;
> >   	msrs->entry_ctls_high |=
> >   		(VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR | VM_ENTRY_LOAD_IA32_EFER);
> Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Reviewed-by: Oliver Upton <oupton@google.com>
