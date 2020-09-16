Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DAE526CCB7
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 22:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbgIPUs2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Sep 2020 16:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726646AbgIPRBJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Sep 2020 13:01:09 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6CFFC0A3BFE;
        Wed, 16 Sep 2020 09:44:56 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id w5so7616117wrp.8;
        Wed, 16 Sep 2020 09:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6OX2minHfjzVyBOJQrdaqKGWzfqGpYJXESyQtwYpeWk=;
        b=vg08kYWwEgG9ogOjRr/AdZitt9N5LiQ10vULtfdvxOdX69uHN9II1K4DcctC6Eb2wQ
         T+NogkHfgFb45nSdjXp1AG61JthAH6C8Dbjqj3bZbClI98Amcr0HYjlJ/mi3psbBSsmX
         zuH9GDhzdQcQU30GiDImiqL4Z4/hyfvb6fU3k2tVQZPUVdF339jO3iV9PmrOwZT6J6rO
         bVBXmoFPLK14PIGdwz5ALriswLfb+QDTPfGf9zi7cMIUpkImIFtpmCt4kqHnCrv5r/Ts
         zP0X55D1uhehMrYj65lxPBgKxR2CLWlhxskNOMJEULSrJo0vu7116DwaLtPFwpvW7+so
         QZhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6OX2minHfjzVyBOJQrdaqKGWzfqGpYJXESyQtwYpeWk=;
        b=eJp3NiSP97KvCypGY8MTTJbHcGKpDabAMF+ISeLqoGaxDYdycP5qbqDrvce+ENxPzb
         ZgcyL1ndCQLE8I81ifIS60rbAVGiRtfg+buD3QWiWWLCumgVeRXsrir4DXgUd4XPAOiW
         EZI255nbQ0NcgF76te5p3RuZTwWPcSqIv/SFyMWpiwo4500lcXE0zge5i3z27X9/vn+O
         6NqYUrpGasPfgMY6tINmjVYTRdYWjJvhc2XTjXBtzHHENhrU8WSDVbVbnyd6DAvdA/nc
         HMZq9Gjl5KtpVJhmGKhBvGa9pU43ZcxQOxwdsvzjQpbjk2zXuTHPyW2kjq8x1jNJOFR9
         j/rg==
X-Gm-Message-State: AOAM530pw2tzYAvuWuuu3qCIL8a1YK+QDA/xRJWeIX23tqxIbjv2zonw
        eS/huLsQuBAenM2HTMPcen4=
X-Google-Smtp-Source: ABdhPJxy/iEoxf34SPNpIIcR4mWlacmmbZg4RILbV4q3lbSyWg57t9/5/HzCj/LDVuIbK3bS8ymTBQ==
X-Received: by 2002:adf:ff83:: with SMTP id j3mr28654393wrr.135.1600274695466;
        Wed, 16 Sep 2020 09:44:55 -0700 (PDT)
Received: from lenovo-laptop (cpc83661-brig20-2-0-cust443.3-3.cable.virginm.net. [82.28.105.188])
        by smtp.gmail.com with ESMTPSA id a13sm6326411wme.26.2020.09.16.09.44.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2020 09:44:54 -0700 (PDT)
From:   Alex Dewar <alex.dewar90@gmail.com>
X-Google-Original-From: Alex Dewar <alex.dewar@gmx.co.uk>
Date:   Wed, 16 Sep 2020 17:44:52 +0100
To:     Borislav Petkov <bp@alien8.de>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Alex Dewar <alex.dewar90@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SVM: nSVM: fix resource leak on error path
Message-ID: <20200916164452.5zg4bun3t6zdgpuc@lenovo-laptop>
References: <20200914194557.10158-1-alex.dewar90@gmail.com>
 <922e825c090892f22d40a469fef229d62f40af5e.camel@redhat.com>
 <20200915091502.GE14436@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200915091502.GE14436@zn.tnic>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 15, 2020 at 11:15:02AM +0200, Borislav Petkov wrote:
> On Tue, Sep 15, 2020 at 12:07:25PM +0300, Maxim Levitsky wrote:
> > I think that this patch is based on unmerged patch, since I don't see
> > any memory allocation in nested_svm_vmrun_msrpm, nor out_free label.
> > in nether kvm/master, kvm/queue nor in upstream/master
> 
> Paolo and I need to figure out first how to share the SEV-ES enablement
> work and the other patches touching that file and then pile more fixes
> ontop.

Sorry for the noise! I didn't realise this was a work in progress --
Coverity picked it up.

> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette
