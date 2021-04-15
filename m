Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0A235FF12
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 02:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbhDOAuM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Apr 2021 20:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbhDOAuJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Apr 2021 20:50:09 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4B20C061574
        for <kvm@vger.kernel.org>; Wed, 14 Apr 2021 17:49:46 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id kb13-20020a17090ae7cdb02901503d67f0beso527223pjb.0
        for <kvm@vger.kernel.org>; Wed, 14 Apr 2021 17:49:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fOJI4hThVgEOLJyImgusGGiOxy9mpTSNJ/Mrm5n5Wk0=;
        b=lEI57So+mLNKqR8MOcAK5p3MZw4vqrkk9etbelECfBcXuY5eDWQoby3QMZLzSfY8Ld
         RvK2vdibjbtjGeqLJkWkmBpcWbieDeicodh6t61TVGzdFOeCO2Tfi3KhnWWSjua3I+7/
         zjdNxm+qgvPvgZ9WsJ9ZUeZ5YYiuAJh6XbZ6tEsTahjj4Zht3bVEskNbzX1vDUHFjevH
         xvzIDu3EKHqfEu4p4n1g3O6vhoUbUZUSS7b6TvAcCczNn3L241mIvi8mFqtGd8FZSgLw
         Yy8ROdcJrDJ/TYNZnks+IkY99l1c7xmHX3Jt5yK9PVXmr+doXnNzkHsWhkATfYP4LBZn
         OCgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fOJI4hThVgEOLJyImgusGGiOxy9mpTSNJ/Mrm5n5Wk0=;
        b=cbGKkPJyhN1GRf6+QxjlNeTchJz1jf5hmuQE6Kq5ulLOeCJeO70QwxeANvMnVqsxTg
         LBIAladwtUGckg4mcdFgKoU0Zr+c/PYf454qLj++AM+z41OuXT6EFi7zGHOQ0WFWDN4P
         0JXCk5mQKODf2eYfUlGbbU/s1MiXZTD7pimlPXUzndzuelApbbpRviDq5I589fDahrb9
         A2f36iaSeZS8DXeCnKzjQZL6FGaqgzPkA2KK9xhUDBN3nTMv8Yt2JxKUTiaZyeInKOK0
         8LzaUYbKl/IxxKOekTATHL8ZPX+Go9HCm378HhU9JOHzt+U5xMfDMLXpaNwJtkXnuo4S
         hfLw==
X-Gm-Message-State: AOAM532utsjn02pMerQslWQYwz8vojMS18GlvWh5Mxyj4PIDH8jtCWxX
        cb8wAvmnpcFINqHiAYFoBOp11s59kIVP/w==
X-Google-Smtp-Source: ABdhPJxRBMrjNapa9s3nteduAiJXZXONsLdWBJOaAaq7bl/eTin1t4vjjR9fsQXFfqGsZoPswRvjvQ==
X-Received: by 2002:a17:90a:fa0c:: with SMTP id cm12mr915481pjb.54.1618447785825;
        Wed, 14 Apr 2021 17:49:45 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id z29sm589556pga.52.2021.04.14.17.49.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 17:49:45 -0700 (PDT)
Date:   Thu, 15 Apr 2021 00:49:41 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: [PATCH v2 0/3] KVM: Properly account for guest CPU time
Message-ID: <YHeNpUd1ZO1JVaAf@google.com>
References: <1618298169-3831-1-git-send-email-wanpengli@tencent.com>
 <YHXUFJuLXY8VZw3B@google.com>
 <CANRm+CzDW_5SPM0131OvRn3UPBp1nahxCykCP61XWeUpYeHU5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANRm+CzDW_5SPM0131OvRn3UPBp1nahxCykCP61XWeUpYeHU5Q@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 14, 2021, Wanpeng Li wrote:
> On Wed, 14 Apr 2021 at 01:25, Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Tue, Apr 13, 2021, Wanpeng Li wrote:
> > > The bugzilla https://bugzilla.kernel.org/show_bug.cgi?id=209831
> > > reported that the guest time remains 0 when running a while true
> > > loop in the guest.
> > >
> > > The commit 87fa7f3e98a131 ("x86/kvm: Move context tracking where it
> > > belongs") moves guest_exit_irqoff() close to vmexit breaks the
> > > tick-based time accouting when the ticks that happen after IRQs are
> > > disabled are incorrectly accounted to the host/system time. This is
> > > because we exit the guest state too early.
> > >
> > > This patchset splits both context tracking logic and the time accounting
> > > logic from guest_enter/exit_irqoff(), keep context tracking around the
> > > actual vmentry/exit code, have the virt time specific helpers which
> > > can be placed at the proper spots in kvm. In addition, it will not
> > > break the world outside of x86.
> >
> > IMO, this is going in the wrong direction.  Rather than separate context tracking,
> > vtime accounting, and KVM logic, this further intertwines the three.  E.g. the
> > context tracking code has even more vtime accounting NATIVE vs. GEN vs. TICK
> > logic baked into it.
> >
> > Rather than smush everything into context_tracking.h, I think we can cleanly
> > split the context tracking and vtime accounting code into separate pieces, which
> > will in turn allow moving the wrapping logic to linux/kvm_host.h.  Once that is
> > done, splitting the context tracking and time accounting logic for KVM x86
> > becomes a KVM detail as opposed to requiring dedicated logic in the context
> > tracking code.
> >
> > I have untested code that compiles on x86, I'll send an RFC shortly.
> 
> We need an easy to backport fix and then we might have some further
> cleanups on top.

I fiddled with this a bit today, I think I have something workable that will be
a relatively clean and short backport.  With luck, I'll get it posted tomorrow.
