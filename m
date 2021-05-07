Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D75D63769CB
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 20:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbhEGSEC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 14:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbhEGSEB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 May 2021 14:04:01 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78F73C061574
        for <kvm@vger.kernel.org>; Fri,  7 May 2021 11:03:01 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id q15so3455326pgg.12
        for <kvm@vger.kernel.org>; Fri, 07 May 2021 11:03:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Dq/nINI3Bkq3Ln7MVhdaZDOVulBPxVkutw7EPDzvvRA=;
        b=ZPY2n2/Ast/W4mvecQPl0YwBiFsiuZARNymcVwARZlvAMPOzc5FQkn2lPrL8XjarlK
         BiiHSu2Hgn6Qt/cxYc+slTD7EE/JIffcf9L1zPQ4l//9+7sZ6mvLnG6N4Zjknj6UWyZL
         Bk+P8M4YaMZYRa3f7+VZTOXzu1dbppTHdBY2fIMngbOjruUILoQyTdVEcddGI9VEiPuO
         4joqX7FP832VEhpKnL+aWHO5FNUIaw3UeGkvB6i+Ad44v6qdFFEoYmRM6zCM1PfoIHoV
         qxbdpnTLvai3purYBTL7Mx2Ha2bZ8tIBbTzzH6s4RLdkpABOgDjDTY3BaNwfHshZMvRY
         bp2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Dq/nINI3Bkq3Ln7MVhdaZDOVulBPxVkutw7EPDzvvRA=;
        b=S/54MzPha4K91ZyADIyR+giK0Ydk360TWbRd1J/wKPVY25nozBmTF9W+EzthRqw/Ox
         2t0W3Vo7NsixE1hjNCiIqTpH3Yjdp3ZWxZFYuLpd6Y5J+Cnh4JZCV5EQhgmB7CL/vb+6
         RUUIKr/nr9h7a84rgXAw67qWn3V4tCrlUyK67HpIiYXR+dx4p64U9u/RTfIyutv0yGPq
         +ytUUekuho9uu+HQcQe+nyuJ40We5W9Jftx1Ex23qeUy9pWxej22ZOllZbJb2tZj+CoJ
         m3/oD3dNDm2W8xfr6Iym0R/p7rS3rTtu71LDvjFMZBbsJAWJJ8H0QHmceC9wOCGVjP4m
         eilg==
X-Gm-Message-State: AOAM530uXYLIg4G5/KzFZOM/g5HCE5e5Q7IGvDJxzwDJSCyZWaCdsh81
        KwPEuk0pKQXvpHwkq6ffa7VY/g==
X-Google-Smtp-Source: ABdhPJyImt4qEMYR4Ckxhjx1Vymo5/pd2g19btogktByhjv/2TAqJV5kodRh9+WMe+f5Dp3S08CYdw==
X-Received: by 2002:a65:5088:: with SMTP id r8mr10849349pgp.12.1620410580840;
        Fri, 07 May 2021 11:03:00 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id d132sm5262385pfd.136.2021.05.07.11.02.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 11:02:59 -0700 (PDT)
Date:   Fri, 7 May 2021 11:02:56 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, drjones@redhat.com, alexandru.elisei@arm.com,
        eric.auger@redhat.com
Subject: Re: [PATCH v2 4/5] KVM: selftests: Add exception handling support
 for aarch64
Message-ID: <YJWA0Moczi2kYSjd@google.com>
References: <20210430232408.2707420-1-ricarkol@google.com>
 <20210430232408.2707420-5-ricarkol@google.com>
 <87a6pcumyg.wl-maz@kernel.org>
 <YJBLFVoRmsehRJ1N@google.com>
 <877dkapqcj.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877dkapqcj.wl-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 07, 2021 at 03:31:56PM +0100, Marc Zyngier wrote:
> On Mon, 03 May 2021 20:12:21 +0100,
> Ricardo Koller <ricarkol@google.com> wrote:
> > 
> > On Mon, May 03, 2021 at 11:32:39AM +0100, Marc Zyngier wrote:
> > > On Sat, 01 May 2021 00:24:06 +0100,
> > > Ricardo Koller <ricarkol@google.com> wrote:
> 
> [...]
> 
> > > > +	.if \vector >= 8
> > > > +	mrs	x1, sp_el0
> > > 
> > > I'm still a bit perplexed by this. SP_EL0 is never changed, since you
> > > always run in handler mode. Therefore, saving/restoring it is only
> > > overhead. If an exception handler wants to introspect it, it is
> > > already available in the relevant system register.
> > > 
> > > Or did you have something else in mind for it?
> > > 
> > 
> > Not really. The reason for saving sp_el0 in there was just for
> > consistency, so that handlers for both el0 and el1 exceptions could
> > get the sp at regs->sp.
> 
> We already have sp_el0 consistency by virtue of having it stored in in
> a sysreg.
> 
> > Restoring sp_el0 might be too much. So, what do you think of this
> > v3: we keep the saving of sp_el0 into regs->sp (to keep things the
> > same between el0 and el1) and delete the restoring of sp_el0?
> 
> To me, the whole purpose of saving some some context is to allow the
> exception handling code to run C code and introspect the interrupted
> state. But saving things that are not affected by the context change
> seems a bit pointless.
> 
> One thing I'd like to see though is to save sp_el1 as it was at the
> point of the exception (because that is meaningful to get the
> exception context -- think of an unaligned EL1 stack for example),
> which means correcting the value that gets saved.

Got it. Replacing:
	mov     x1, sp
with:
	add     x1, sp, #16 * 17

> 
> So I would suggest to *only* save sp_el1, to always save it
> (irrespective of the exception coming from EL0 or EL1), and to save a
> retro-corrected value so that the handler can directly know where the
> previous stack pointer was.

Sounds good, will send a V3 accordingly.

Thanks!
Ricardo

> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
