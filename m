Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F8A115E9B4
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 18:08:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404067AbgBNRIt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 12:08:49 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:38385 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391876AbgBNRIr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Feb 2020 12:08:47 -0500
Received: by mail-qk1-f194.google.com with SMTP id z19so9874946qkj.5
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2020 09:08:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fXvyu0kZf5A1U63q/YhyFfRXYuCW/78tH+0468+IS98=;
        b=YFJ/kMLjchBhiT8aNq0VrtM4AcJeWee2US4hluINe65IunCXS3vJuj4Bkbt4gqrlc9
         xSK8WM66btieYfHnX95r5cKhvH7E17po1pg7gSr6OevWFmVmk8Cql8RHZFeuHCv08hwf
         3/sxsLR7FFiN7OKwP0erO9lLPFlmPWzw4WIgrDmrtzTYg3Eav+OtYw0SPSr59xFJ5kcq
         teKwvCq9AEwvlyWG0mAayZa01tij9LomvrQ+gp5Wr2P3JSgZAUqg2qTZPUv8OPkhrrNf
         kGV8o4do/4/KGXvJrd/ylkT265lwoafDkZa+Ox1SowWFpDIen1G/c3gxYprXLAOJ/fLX
         gJ/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fXvyu0kZf5A1U63q/YhyFfRXYuCW/78tH+0468+IS98=;
        b=pjOTrSeEiKw1IY2Uoau2Ii2r3/bL9xJuTJzpzZiPaX/laMrXCgY45sr9cJmT567KwF
         WY4VNI9zPrN/VYROJk2yLGa5Q9nsJ4msyU6l5XhafOPCPzvEtu3IQKdiyorXZBfvYqzS
         fl5zwRmvDeJM+87V4bOSwuMhPmhEmPQAc9Fdow/Q14AvkjA6yirQDJA0NonoDqXZTEhu
         jygkAD8WtXat8FgW+9zgBqIlHsDfS1AQNbWcbTslsXAobA3b1qlwi1crVFAD4Lgf6dWJ
         gBxwceqiNkgiFHHzqqfGz4LArp0vDtva1XHZiklWPP+X34Hn26tIk2Z0jAPGkuXpI5LY
         yUIQ==
X-Gm-Message-State: APjAAAXwv/emin+fYrECWLG1e6T0M/VFNyVaQu1s0cVHaXBrqPNdC0QP
        UZR37RyquAywVhboXgDmZS4K1w==
X-Google-Smtp-Source: APXvYqyT/rOWJB967/ihSOHGw7VRvxvP2mM5AosTsnw/AhWVTsl2iZIE1fPQw2Z1aaAiOiJtR9sAQg==
X-Received: by 2002:a05:620a:13a9:: with SMTP id m9mr3571942qki.359.1581700126842;
        Fri, 14 Feb 2020 09:08:46 -0800 (PST)
Received: from dhcp-41-57.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id r1sm3538113qtu.83.2020.02.14.09.08.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Feb 2020 09:08:46 -0800 (PST)
Message-ID: <1581700124.7365.70.camel@lca.pw>
Subject: Re: [PATCH] kvm/emulate: fix a -Werror=cast-function-type
From:   Qian Cai <cai@lca.pw>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 14 Feb 2020 12:08:44 -0500
In-Reply-To: <20200214165923.GA20690@linux.intel.com>
References: <1581695768-6123-1-git-send-email-cai@lca.pw>
         <20200214165923.GA20690@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.22.6 (3.22.6-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2020-02-14 at 08:59 -0800, Sean Christopherson wrote:
> On Fri, Feb 14, 2020 at 10:56:08AM -0500, Qian Cai wrote:
> > arch/x86/kvm/emulate.c: In function 'x86_emulate_insn':
> > arch/x86/kvm/emulate.c:5686:22: error: cast between incompatible
> > function types from 'int (*)(struct x86_emulate_ctxt *)' to 'void
> > (*)(struct fastop *)' [-Werror=cast-function-type]
> >     rc = fastop(ctxt, (fastop_t)ctxt->execute);
> > 
> > Fixes: 3009afc6e39e ("KVM: x86: Use a typedef for fastop functions")
> > Signed-off-by: Qian Cai <cai@lca.pw>
> > ---
> >  arch/x86/kvm/emulate.c | 8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> > index ddbc61984227..17ae820cf59d 100644
> > --- a/arch/x86/kvm/emulate.c
> > +++ b/arch/x86/kvm/emulate.c
> > @@ -5682,10 +5682,12 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
> >  		ctxt->eflags &= ~X86_EFLAGS_RF;
> >  
> >  	if (ctxt->execute) {
> > -		if (ctxt->d & Fastop)
> > -			rc = fastop(ctxt, (fastop_t)ctxt->execute);
> 
> Alternatively, can we do -Wno-cast-function-type?  That's a silly warning
> IMO.

I am doing W=1 on linux-next where some of the warnings might be silly but the
recent commit changes all warnings to errors forces me having to silence those
somehow.

> 
> If not, will either of these work?
> 
> 			rc = fastop(ctxt, (void *)ctxt->execute);
> 
> or
> 			rc = fastop(ctxt, (fastop_t)(void *)ctxt->execute);

I have no strong preference. I originally thought just to go back the previous
code style where might be more acceptable, but it is up to maintainers.

> 
> > -		else
> > +		if (ctxt->d & Fastop) {
> > +			fastop_t fop = (void *)ctxt->execute;
> > +			rc = fastop(ctxt, fop);
> > +		} else {
> >  			rc = ctxt->execute(ctxt);
> > +		}
> >  		if (rc != X86EMUL_CONTINUE)
> >  			goto done;
> >  		goto writeback;
> > -- 
> > 1.8.3.1
> > 
