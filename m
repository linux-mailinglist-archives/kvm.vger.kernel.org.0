Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19CE5255D7E
	for <lists+kvm@lfdr.de>; Fri, 28 Aug 2020 17:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbgH1PJy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Aug 2020 11:09:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbgH1PJf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Aug 2020 11:09:35 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9A7DC061264;
        Fri, 28 Aug 2020 08:09:34 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id o12so1205822qki.13;
        Fri, 28 Aug 2020 08:09:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=W7kRTit/NoWCrV6s0X1OousX0dNQ2oe81sw0mMzwiVI=;
        b=HSnWUujveg28vCj8uX2R+iiQq4k/5RDX/XgGqrmN9R/zNCTuyrRG1J0ms852pLywu8
         lFqJ/BPTgfN0uGT9yMjeui+9d0az0yQ/8GBSYXbgXFjRAESD4TgKm/TWozU3jZhx0VV6
         14LAQjW2igCplnEnQxePMQh3A0HyYqMMVOZ0cSReYqtKaPQMFMVMkQopL/BLOrCthcOM
         MUG/vdrbZnbSR2JPm/mSTli0wwQ5RW1Rnb2QkBdSQFn5eWM+AraW9W6WPnhzkJDMyTEZ
         +E8leqfNv+TU/gPyFFo7vQjDxadNKQDIxSpEgzgT45xPgDxiiHiR1ZXFXoVLt2FA+mn4
         ubuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=W7kRTit/NoWCrV6s0X1OousX0dNQ2oe81sw0mMzwiVI=;
        b=lHLcqgyZLQ4kiCkjyD6jwcs+Kgw5miXpwkr7LNTTzKCJRxu6lta7mZVkLA2qiG+pGD
         wxf2obMdQR4lwA+V3t+FRLIH2nrA8ewFCIRIYaw65nid5l3XZMxPNf6C8MsFb8dO5Jlx
         lR2VZi04HAFyW4ndC9KP0Wf+/7/O2tHDvBMw3PozCnN56Ke75f5Z5X5bd8uKbyY9XbGd
         5Dc5ILC2dICM7e/9ree2GTq+WzxZYcgTaNHyEZW6v2aBGupBLqrIgrxLlCLFfyrJhORH
         KBT9ozfKOE+JrLpvn63Er8uEKLBFVXTcvxu2f0yPymxXFsNcKZArbhEskXWhilTAyTys
         WR5Q==
X-Gm-Message-State: AOAM531kmvKPKOhqTq9eh3IMuKdJpRkvnt1C5Ad7bg/qFJAfnRbe7BLF
        fp8M/nKD1yiDztEbbsNtnjk=
X-Google-Smtp-Source: ABdhPJzaqcYvGe3mmd+w2AvU76ady8UcKUmdn3DKwbjE+FvWDr6fLzH7sMY//enSc5x5fZp+ZMBmSQ==
X-Received: by 2002:a37:ec6:: with SMTP id 189mr1686250qko.38.1598627371481;
        Fri, 28 Aug 2020 08:09:31 -0700 (PDT)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id x31sm1276971qtx.97.2020.08.28.08.09.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2020 08:09:30 -0700 (PDT)
From:   Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date:   Fri, 28 Aug 2020 11:09:28 -0400
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Arvind Sankar <nivedita@alum.mit.edu>, x86@kernel.org,
        Joerg Roedel <jroedel@suse.de>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v6 13/76] x86/boot/compressed/64: Add IDT Infrastructure
Message-ID: <20200828150928.GA1203097@rani.riverdale.lan>
References: <20200824085511.7553-1-joro@8bytes.org>
 <20200824085511.7553-14-joro@8bytes.org>
 <20200827152657.GA669574@rani.riverdale.lan>
 <20200828121226.GC13881@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200828121226.GC13881@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 28, 2020 at 02:12:26PM +0200, Joerg Roedel wrote:
> Hi Arvind,
> 
> On Thu, Aug 27, 2020 at 11:26:57AM -0400, Arvind Sankar wrote:
> > On Mon, Aug 24, 2020 at 10:54:08AM +0200, Joerg Roedel wrote:
> > > +	pushq	%rsi
> > > +	call	load_stage1_idt
> > > +	popq	%rsi
> > > +
> > 
> > Do we need the functions later in the series or could this just use lidt
> > directly?
> 
> The function also sets up the actual IDT entries in the table before
> doing the lidt, so this needs to be a call to a C function. Setting up
> IDT entries in assembly does not result in readable code.
> 

Ah ok, I missed that in the later patches.

Thanks.
