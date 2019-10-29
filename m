Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3070E89D2
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2019 14:43:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388776AbfJ2Nm5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Oct 2019 09:42:57 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:38857 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388604AbfJ2Nm5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Oct 2019 09:42:57 -0400
Received: by mail-pl1-f196.google.com with SMTP id w8so7645659plq.5;
        Tue, 29 Oct 2019 06:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=T+RMrtgdfzjc/OGIdlXsvb0nZaqRH2vX18Kq3/3EKqI=;
        b=K4M0nuUJihJyyQpsNNz4+G+YgeMqV2CMO7m5ggIevT9pzlISKthVMk06p/lfmpZKCp
         hOv1TTfx5t0PxzPUGDHtVyKgN1maIi/lO9XpIj8q6yXgEDR6VZy31do0uNIOy5uj69Z/
         F8tG2p4k71wFYnclQ4IubmJQ6EaZ7C+myEKsZzwTJv0qbTMaN4kWLamUeqyOKwgrPvuf
         f1hayvI7E6slrD6OhzsFeFB9cj3MklSZqW+pJ23MAoyvvAKeQdpGOXI4jlf6fHnWmnak
         c7lcjMPg76BVrJzExuTfzsHhk7HB492Cszx30aG73En84YsC5BpJChnAN2dOJOgTXVQ4
         I2Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=T+RMrtgdfzjc/OGIdlXsvb0nZaqRH2vX18Kq3/3EKqI=;
        b=YIw/1K1jUJunehsqnAYT+FV7EdgkboeW9iaTo8rsLYcYARUX2Y3SuAV9ZCR9B+7U1j
         GkgDd8pTaYUnSwZIXk06BAyqrQ2RqqpryxozplHIBU9eT1CzlLe0WsmEHXcgaz7vA6q6
         MaVem+2aLjzfG1n5KhgSUb32h2GgzVYX+sTX6IIcStqwdtnsG2+fVXbzTpoJtt5WnKRl
         /l5DeWrKOv4ORAl35WuA4g7Nn9csdizu3aU6TIdvVyT0cd7RjhbyLdPJKEBmD7TNsdwn
         S1R6V7TZ1ZsBcdfd6A2+PIYBe1+XTHCOpTqqKGx8hmTVNgZ7f39Z22VkLqjw/4M0k9hK
         262Q==
X-Gm-Message-State: APjAAAXm1na/6ZlOsYFRsj3LpQAgM00HfdBwG19cYFA9hl4DgRYdqzsL
        wrOZNbDQilhlQwnX4iqyA+w=
X-Google-Smtp-Source: APXvYqzISKC6zYuLHAd4dzEdfNSDXywOe8ZEn/XaKi3G3T8f7QBnpfmyUrZJXX642UEsYFGZN+kaeA==
X-Received: by 2002:a17:902:6946:: with SMTP id k6mr4360425plt.60.1572356576161;
        Tue, 29 Oct 2019 06:42:56 -0700 (PDT)
Received: from saurav ([117.232.226.35])
        by smtp.gmail.com with ESMTPSA id m17sm8407635pfh.79.2019.10.29.06.42.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 06:42:54 -0700 (PDT)
Date:   Tue, 29 Oct 2019 19:12:46 +0530
From:   SAURAV GIREPUNJE <saurav.girepunje@gmail.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        saurav.girepunje@hotmail.com
Subject: Re: [PATCH] arch: x86: kvm: mmu.c: use true/false for bool type
Message-ID: <20191029134246.GA4943@saurav>
References: <20191029094104.GA11220@saurav>
 <20191029101300.GK4114@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191029101300.GK4114@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 29, 2019 at 11:13:00AM +0100, Peter Zijlstra wrote:
> On Tue, Oct 29, 2019 at 03:11:04PM +0530, Saurav Girepunje wrote:
> > Use true/false for bool type "dbg" in mmu.c
> > 
> > Signed-off-by: Saurav Girepunje <saurav.girepunje@gmail.com>
> > ---
> >  arch/x86/kvm/mmu.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> > index 24c23c66b226..c0b1df69ce0f 100644
> > --- a/arch/x86/kvm/mmu.c
> > +++ b/arch/x86/kvm/mmu.c
> > @@ -68,7 +68,7 @@ enum {
> >  #undef MMU_DEBUG
> >  
> >  #ifdef MMU_DEBUG
> > -static bool dbg = 0;
> > +static bool dbg = true;
> 
> You're actually changing the value from false to true. Please, if you
> don't know C, don't touch things.
Hi,

Thanks for your review.
I accept that I have given wrong value "true" to debug variable. It's my bad my typo mistake.  
I will make sure that I will not touch your exclusive C code where we can assign 0/1 to a bool variable,
As you have given me a free advice, I also request you to please don't review such small patches from newbie to discourage them.

Regards,
Saurav
