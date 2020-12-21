Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B27132E00DD
	for <lists+kvm@lfdr.de>; Mon, 21 Dec 2020 20:21:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbgLUTU3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Dec 2020 14:20:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbgLUTU2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Dec 2020 14:20:28 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABFE7C0613D3
        for <kvm@vger.kernel.org>; Mon, 21 Dec 2020 11:19:48 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id t6so6126734plq.1
        for <kvm@vger.kernel.org>; Mon, 21 Dec 2020 11:19:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WtizPFqIUsbgTk5ZUrZ8KiSKXylfonEzY0kSBt4n3QA=;
        b=Mt22q0LphIerpJ6ZPHpk+kXQKlq3p1GmAfA+r40ZSGd7rnEuT8VLNOXxtJ9a/omgg/
         R9T6PxUFmSoFgiDAden/8ODlmo3pKOTmbVWEgtCK/qZ6snnwrB7bL8W3DW76tZtYWj0K
         ichq0UXkyD9uWbsTWGZLC22/+TxRSSrcxHjWAfk8mMM6Kual/FQY5yfOX4q9LGCtyvv5
         /DUlf+NCH0B4FRqxulAz/zIh4Ptv4V0i/awZSORItek+ZaO0pcqTRzxPW+XfQ+X+Sn39
         uqoyh+2GQCthU3kIDA4tPlO1zNd69Sf4ntY6X3hzZs9Vf6+dn+nSYtW/EcWEhLUkKYcK
         hYPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WtizPFqIUsbgTk5ZUrZ8KiSKXylfonEzY0kSBt4n3QA=;
        b=szh4YKwZOh5yh5zrnmyppA2LPKEAGowLSgJx+ZM0Odl03WGInp0L1ssZxRdNAy+SwF
         PusdzFafJ6i8NlgOqbygmERnopwDoX8pXLa+/ob8SfFkUSSvHdsUx/1rLGgG3Zin2hWJ
         5ZMTQKE/YjP24FPa+FQOJEG6ot7n2ikOMlNqMBV5uUDtPRu4Ns9jBNonz16xx4aHFn/Q
         3CxkJrbpDViIA5qolvfb4MY6naXAimIjYJ20zbZ26n/tgwxC9Ra8su1WwfYuKwBldvBu
         JJOcRfvxi7iqfdKupIuCIiW6hIonVWao7xaqXvt4E44uLsM6DWGruGlj21SVrV1BHe5h
         Jv3g==
X-Gm-Message-State: AOAM532cMkQThajPBTNI/mKxcFx1h9KDh5vO9BBZo3jHIHav4UHEIbwq
        eWWLb5arRIWHFUkuCjGTVY6vCw==
X-Google-Smtp-Source: ABdhPJz0Sv4gY1tNUjJc/rLJljNUCFgw6jCNcjw5sVpEbSnS2EZNzHrVAqkGoC1cfC+satTVKgeOgA==
X-Received: by 2002:a17:902:854b:b029:db:c725:edcd with SMTP id d11-20020a170902854bb02900dbc725edcdmr17972443plo.64.1608578388081;
        Mon, 21 Dec 2020 11:19:48 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id cu4sm16848943pjb.18.2020.12.21.11.19.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Dec 2020 11:19:47 -0800 (PST)
Date:   Mon, 21 Dec 2020 11:19:40 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Uros Bizjak <ubizjak@gmail.com>
Cc:     kvm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: Re: [PATCH v2] KVM/x86: Move definition of __ex to x86.h
Message-ID: <X+D1TPXRuTggnvHv@google.com>
References: <20201220211109.129946-1-ubizjak@gmail.com>
 <X+DnRcYVNdkkgI3j@google.com>
 <CAFULd4aBWqQmwYNo74_zmP22Lu79jnRJVu5+PrKkOD2Dbp6-FQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFULd4aBWqQmwYNo74_zmP22Lu79jnRJVu5+PrKkOD2Dbp6-FQ@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 21, 2020, Uros Bizjak wrote:
> On Mon, Dec 21, 2020 at 7:19 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Sun, Dec 20, 2020, Uros Bizjak wrote:
> > > Merge __kvm_handle_fault_on_reboot with its sole user
> >
> > There's also a comment in vmx.c above kvm_cpu_vmxoff() that should be updated.
> > Alternatively, and probably preferably for me, what about keeping the long
> > __kvm_handle_fault_on_reboot() name for the macro itself and simply moving the
> > __ex() macro?
> >
> > That would also allow keeping kvm_spurious_fault() and
> > __kvm_handle_fault_on_reboot() where they are (for no reason other than to avoid
> > code churn).  Though I'm also ok if folks would prefer to move everything to
> > x86.h.
> 
> The new patch is vaguely based on our correspondence on the prototype patch:
> 
> --q--
> Moving this to asm/kvm_host.h is a bit sketchy as __ex() isn't exactly the
> most unique name.  arch/x86/kvm/x86.h would probably be a better
> destination as it's "private".  __ex() is only used in vmx.c, nested.c and
> svm.c, all of which already include x86.h.
> --/q--
> 
> where you mentioned that x86.h would be a better destination for
> __ex().

Ya, thankfully I still agree with my past self on this one :-)

> IMO, __kvm_handle_fault_on_reboot also belongs in x86.h, as it
> deals with a low-level access to the processor, and there is really no
> reason for this #define to be available for the whole x86 architecture
> directory. I remember looking for the __kvm_handle_falult_on_reboot,
> and was surprised to find it in a global x86 include directory.

Works for me.  If you have a strong preference for moving everything to x86.h,
then let's do that.

> I tried to keep __ex as a redefine to __kvm_hanlde_fault_on_reboot in
> x86.h, but it just looked weird, since __ex is the only user and the
> introductory document explains in detail, what
> __kvm_hanlde_fault_on_reboot (aka __ex) does.

I like the verbose name because it very quickly reminds what the macro does; I
somehow manage to forget every few months.  I agree it's a bit superfluous since
the comment explains exactly what goes on.  And I can see how
__kvm_handle_fault_on_reboot() would be misleading as it also "handles" faults
at all other times as well.

What if we add a one-line synopsis in the comment to state the (very) high-level
purpose of the function?  We could also opportunistically clean up the
formatting in the existing comment to save a line, e.g.:

/*
 * Handle a fault on a hardware virtualization (VMX or SVM) instruction.
 *
 * Hardware virtualization extension instructions may fault if a reboot turns
 * off virtualization while processes are running.  Usually after catching the
 * fault we just panic; during reboot instead the instruction is ignored.
 */
