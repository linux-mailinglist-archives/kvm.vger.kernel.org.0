Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 430F7EAACC
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2019 07:58:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726902AbfJaG6H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Oct 2019 02:58:07 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:37732 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726535AbfJaG6H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Oct 2019 02:58:07 -0400
Received: by mail-pg1-f196.google.com with SMTP id p1so3372855pgi.4;
        Wed, 30 Oct 2019 23:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=NmnhD1to1Woi7ihYlHRdgXP2wlf0dt1fnEvkIoQefGg=;
        b=i7tl43NBp7HV2+Lect4+izVaM4ZFfjEEUUFLBPHNangyYnKgDy6V9NSIpC9RTMaMnj
         72cdc2nZ5+JQKoZ/YE1kezXQ+QOeO5D1x0A9gzibvHv0mqMH/YMF/obyULsKayxFfDpK
         t/LOKhDMYOj8VvrJO7kqzFHRuz2+PXTuS7gcceJdvG4e7+jfG7mQUZB+eXOkwmrg3eHA
         kuYoTur4jHTQCLolaok4nh7y9INAtFrJyDPHUp7DoLvQ3tNu3rq6U8tLZSOFFnVjWIH7
         ZSKW1m5+KSm95FfSvAEfu3YqK7SqTIZwhX/vEA4RCQsNkG5MFdCZrckdXntk/cEBYluB
         W80g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=NmnhD1to1Woi7ihYlHRdgXP2wlf0dt1fnEvkIoQefGg=;
        b=PdoPFPDXIGl/U9RspkZ2JYvoa+GnxWG2gd60buw1qefAynNVVXnizZobd7GZ9aCMoE
         susyM00cEa34kJf1sVV23GA32akCDsJwSUiHSmgAxu8u3FNNGgb0xfiv9S7Y1pmlghVg
         1jUL0FIaq8+F8d0ixd11Nm9QGnGthpDDxkr9xKvn/5XIEuo9YZTkx6uhWsl2I4KSDEtV
         RT1tLCmc1KzHCfFBOinWLwjidb2lMt8wBVH6Yt9gHreNl5f0Ie+83dbPawmEK/Ss/3RU
         0MfBaB0J487O/CtKvDy2ycdexkhj7BAE+/sgToe0qKhAd/Ct/0Cbj77wP0k9cUmxPegR
         qMRw==
X-Gm-Message-State: APjAAAUyHMN+LcJIgxPAU1EF7hexPh6LTMSkopAAkjRqztdBqh/L8g8r
        DrO0ac0zhBSCZRibai15PJw=
X-Google-Smtp-Source: APXvYqx3ohK9qzdxCFYj/QovBzUqdlh8eL41UpL2vV5oEM3eVK6A4tMBbiYb19POacp1DQH5oHI4xg==
X-Received: by 2002:a17:90a:de0c:: with SMTP id m12mr5001820pjv.34.1572505085060;
        Wed, 30 Oct 2019 23:58:05 -0700 (PDT)
Received: from saurav ([27.62.165.177])
        by smtp.gmail.com with ESMTPSA id 66sm1963658pgi.49.2019.10.30.23.57.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Oct 2019 23:58:04 -0700 (PDT)
Date:   Thu, 31 Oct 2019 12:27:39 +0530
From:   SAURAV GIREPUNJE <saurav.girepunje@gmail.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        saurav.girepunje@hotmail.com
Subject: Re: [PATCH] arch: x86: kvm: mmu.c: use true/false for bool type
Message-ID: <20191031065739.GA5969@saurav>
References: <20191029094104.GA11220@saurav>
 <20191029101300.GK4114@hirez.programming.kicks-ass.net>
 <20191029134246.GA4943@saurav>
 <20191029154423.GN4131@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191029154423.GN4131@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 29, 2019 at 04:44:23PM +0100, Peter Zijlstra wrote:
> On Tue, Oct 29, 2019 at 07:12:46PM +0530, SAURAV GIREPUNJE wrote:
> > On Tue, Oct 29, 2019 at 11:13:00AM +0100, Peter Zijlstra wrote:
> > > On Tue, Oct 29, 2019 at 03:11:04PM +0530, Saurav Girepunje wrote:
> > > > Use true/false for bool type "dbg" in mmu.c
> > > > 
> > > > Signed-off-by: Saurav Girepunje <saurav.girepunje@gmail.com>
> > > > ---
> > > >  arch/x86/kvm/mmu.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > 
> > > > diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> > > > index 24c23c66b226..c0b1df69ce0f 100644
> > > > --- a/arch/x86/kvm/mmu.c
> > > > +++ b/arch/x86/kvm/mmu.c
> > > > @@ -68,7 +68,7 @@ enum {
> > > >  #undef MMU_DEBUG
> > > >  
> > > >  #ifdef MMU_DEBUG
> > > > -static bool dbg = 0;
> > > > +static bool dbg = true;
> > > 
> > > You're actually changing the value from false to true. Please, if you
> > > don't know C, don't touch things.
> > Hi,
> > 
> > Thanks for your review.
> > I accept that I have given wrong value "true" to debug variable. It's my bad my typo mistake.  
> > I will make sure that I will not touch your exclusive C code where we can assign 0/1 to a bool variable,
> > As you have given me a free advice, I also request you to please don't review such small patches from newbie to discourage them.
> 
> I will most certainly review whatever I want, and clearly it is needed.
Do you want me to discard this patch or resend ?
