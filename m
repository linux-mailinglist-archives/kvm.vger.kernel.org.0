Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC44376AB2
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 21:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbhEGTaL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 15:30:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49074 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229606AbhEGTaK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 May 2021 15:30:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620415749;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qyIjKZnTeZa3K2pYiqFi6j8BuT347880sUP/h0+cRxU=;
        b=bhFRibebNOqc+cRzYyKVQANQ3cX9o9vGAOXvD4Qr35HWE7E1GnInyIt7rDx1+O4TeCca4E
        VwD1qai+CDMknN9DF0EFblnC7UkFQ7DJA4kyIg22+I2ROdIzFq1KqqPagkHFWcdDuLsOEj
        gNSzGi7/0rN0QbtYPB/6Bz2MYYBFMwk=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-564-28AhyqHqODGgf1olxXNLPg-1; Fri, 07 May 2021 15:29:08 -0400
X-MC-Unique: 28AhyqHqODGgf1olxXNLPg-1
Received: by mail-qk1-f200.google.com with SMTP id p17-20020a05620a1131b02902e45c6e4d33so7025607qkk.0
        for <kvm@vger.kernel.org>; Fri, 07 May 2021 12:29:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qyIjKZnTeZa3K2pYiqFi6j8BuT347880sUP/h0+cRxU=;
        b=Qt7qi2Tr+MEEouCU3+4qpFxb9sthg8pwoJ/bNQAI7CnzBx/US5DhtYfFxgJpA2yYmE
         ZYXpwBQeFl1Lg4UXbmH0KgjiVvLOKTobQPRsYZVAreqwF416TMUT3dyebw3jE2HBi5YQ
         YHJBSTI4ZRG0DzfJXvsDbcTseJtKi+U3EfTL4pIhnyTp3KWgSefwHDladNRteYtbxMUW
         jHC5OerSDDX+EVB20WhgcGr3EIO8QET1wkHKJDtUwhRIvNS9XtuGAnDSArY3tMtX6Zvy
         EjEq0xL0Tk2Yz83Lok24Q2gqrKmsOEBxQoyLcKXlzuFE3SXXciokf0U1ZOdnTTKrXe1H
         IKSQ==
X-Gm-Message-State: AOAM533/Q6IaLJwOaCsBgGK9Fq4hbEr/Bh5UJdcImsxY/Gi6ad2GZJvj
        uia9h9GMMaj00N2RnbOWe++hs1YErZhR0he0mzPePSc6Hya6eqqTfRjWfIePL+cCGavx5yr906m
        yUkMHeyl2sfGe
X-Received: by 2002:a37:7147:: with SMTP id m68mr11085632qkc.286.1620415747755;
        Fri, 07 May 2021 12:29:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwEJ4VxdM4wG7CA3z2tdxYc01S9+df8ATDqyxs2U/T3KLAa616GuBlIwk96vN5sifwwDXWV2Q==
X-Received: by 2002:a37:7147:: with SMTP id m68mr11085613qkc.286.1620415747538;
        Fri, 07 May 2021 12:29:07 -0700 (PDT)
Received: from t490s (bras-base-toroon474qw-grc-72-184-145-4-219.dsl.bell.ca. [184.145.4.219])
        by smtp.gmail.com with ESMTPSA id e15sm5743850qtp.1.2021.05.07.12.29.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 12:29:06 -0700 (PDT)
Date:   Fri, 7 May 2021 15:29:05 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Pei Zhang <pezhang@redhat.com>
Subject: Re: [patch 4/4] KVM: VMX: update vcpu posted-interrupt descriptor
 when assigning device
Message-ID: <YJWVAcIsvCaD7U0C@t490s>
References: <20210507130609.269153197@redhat.com>
 <20210507130923.528132061@redhat.com>
 <YJV3P4mFA7pITziM@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YJV3P4mFA7pITziM@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 07, 2021 at 05:22:07PM +0000, Sean Christopherson wrote:
> On Fri, May 07, 2021, Marcelo Tosatti wrote:
> > Index: kvm/arch/x86/kvm/vmx/posted_intr.c
> > ===================================================================
> > --- kvm.orig/arch/x86/kvm/vmx/posted_intr.c
> > +++ kvm/arch/x86/kvm/vmx/posted_intr.c
> > @@ -203,6 +203,25 @@ void pi_post_block(struct kvm_vcpu *vcpu
> >  	local_irq_enable();
> >  }
> >  
> > +int vmx_vcpu_check_block(struct kvm_vcpu *vcpu)
> > +{
> > +	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
> > +
> > +	if (!irq_remapping_cap(IRQ_POSTING_CAP))
> > +		return 0;
> > +
> > +	if (!kvm_vcpu_apicv_active(vcpu))
> > +		return 0;
> > +
> > +	if (!kvm_arch_has_assigned_device(vcpu->kvm))
> > +		return 0;
> > +
> > +	if (pi_desc->nv == POSTED_INTR_WAKEUP_VECTOR)
> > +		return 0;
> > +
> > +	return 1;
> 
> IIUC, the logic is to bail out of the block loop if the VM has an assigned
> device, but the blocking vCPU didn't reconfigure the PI.NV to the wakeup vector,
> i.e. the assigned device came along after the initial check in vcpu_block().
> That makes sense, but you can add a comment somewhere in/above this function?

Wondering whether we should add a pi_test_on() check in kvm_vcpu_has_events()
somehow, so that even without customized ->vcpu_check_block we should be able
to break the block loop (as kvm_arch_vcpu_runnable will return true properly)?

-- 
Peter Xu

