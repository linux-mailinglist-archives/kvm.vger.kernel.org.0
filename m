Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26EB837ABBA
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 18:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231269AbhEKQVK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 12:21:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24246 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230401AbhEKQVJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 12:21:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620750002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9JrHJdAcyv7yqLJl8HN4hjhCTQ8i/jpwoFL4/ryqiE0=;
        b=HemvlL3pcEnt6p3xlcfo8XYeiuSnI957575e1xDaBI5xxABWzra2UFbS0WPPcEo45WW9dQ
        8DhTh1cntkwFDAC5qaq+xjn4uA/Em8MU3ckxOBT44DIssnD0CQUzK5J0Ao2Jjwcpp/+AOy
        tCHnKfD5ePQpoZldDSrGMdQ53cepOI4=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-521-kUVwQ1NUOqu9GQYIMH7mJw-1; Tue, 11 May 2021 12:19:59 -0400
X-MC-Unique: kUVwQ1NUOqu9GQYIMH7mJw-1
Received: by mail-qt1-f199.google.com with SMTP id d16-20020ac811900000b02901bbebf64663so13291165qtj.14
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 09:19:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9JrHJdAcyv7yqLJl8HN4hjhCTQ8i/jpwoFL4/ryqiE0=;
        b=uXThSZE4xY5NzmUTYVGXt2+whpxrhtSJteWMJzr9KLbElmVJx12ODFIzqgmlXb9moA
         9gl24pIw/ToVTLfvehIS0j9jQtZMrrlwKksTD88urvW4S+7Aus1qv++fMB7tnRHZ2pbt
         uURoFyGPpOmpp6ZUP9LTkFXxRbE0iSd7zzIykJoY4tN2iY4KvEoFoJCMTkOcKjGeHyAf
         8b6HnK2KsD6VkUmplDEkHJoNpgaErwHxIqOhlIswsglImyMZbMgGuidRzBFDonqGFKRW
         CPV0tk1W4O5a6i+YY0B8Vz31+wBxyWBksNF7RX6VQeudAimkyXe3eurHRoiFSLmfuw22
         zhvQ==
X-Gm-Message-State: AOAM532NjfbcqohJqxfOCCKY4dxkFt9k1HJDXIQY7ufpmr9y85+yGyis
        KyJsczM3YeDn0Tj0/i7Rwpsnn1qt1nQFgzAHW+kVjA6Zqcy+/rwH8wSQPZQrgt8QSCub9tYwXQU
        VzWSMGDiiwrUo
X-Received: by 2002:a37:9a44:: with SMTP id c65mr27983595qke.368.1620749998218;
        Tue, 11 May 2021 09:19:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwHxJOSf2pte2GRWxSXUVe4R7zrGddJ2+eibRHE4e7jxTptmfPOfEePfEoXtpbFYa4J1r3t3g==
X-Received: by 2002:a37:9a44:: with SMTP id c65mr27983562qke.368.1620749997821;
        Tue, 11 May 2021 09:19:57 -0700 (PDT)
Received: from t490s (bras-base-toroon474qw-grc-72-184-145-4-219.dsl.bell.ca. [184.145.4.219])
        by smtp.gmail.com with ESMTPSA id a195sm13963318qkg.101.2021.05.11.09.19.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 09:19:57 -0700 (PDT)
Date:   Tue, 11 May 2021 12:19:56 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Pei Zhang <pezhang@redhat.com>
Subject: Re: [patch 4/4] KVM: VMX: update vcpu posted-interrupt descriptor
 when assigning device
Message-ID: <YJqurM+LiyAY+MPO@t490s>
References: <20210507130609.269153197@redhat.com>
 <20210507130923.528132061@redhat.com>
 <YJV3P4mFA7pITziM@google.com>
 <YJWVAcIsvCaD7U0C@t490s>
 <20210507220831.GA449495@fuller.cnet>
 <YJqXD5gQCfzO4rT5@t490s>
 <20210511145157.GC124427@fuller.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210511145157.GC124427@fuller.cnet>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 11, 2021 at 11:51:57AM -0300, Marcelo Tosatti wrote:
> On Tue, May 11, 2021 at 10:39:11AM -0400, Peter Xu wrote:
> > On Fri, May 07, 2021 at 07:08:31PM -0300, Marcelo Tosatti wrote:
> > > > Wondering whether we should add a pi_test_on() check in kvm_vcpu_has_events()
> > > > somehow, so that even without customized ->vcpu_check_block we should be able
> > > > to break the block loop (as kvm_arch_vcpu_runnable will return true properly)?
> > > 
> > > static int kvm_vcpu_check_block(struct kvm_vcpu *vcpu)
> > > {
> > >         int ret = -EINTR;
> > >         int idx = srcu_read_lock(&vcpu->kvm->srcu);
> > > 
> > >         if (kvm_arch_vcpu_runnable(vcpu)) {
> > >                 kvm_make_request(KVM_REQ_UNHALT, vcpu); <---
> > >                 goto out;
> > >         }
> > > 
> > > Don't want to unhalt the vcpu.
> > 
> > Could you elaborate?  It's not obvious to me why we can't do that if
> > pi_test_on() returns true..  we have pending post interrupts anyways, so
> > shouldn't we stop halting?  Thanks!
> 
> pi_test_on() only returns true when an interrupt is signalled by the
> device. But the sequence of events is:
> 
> 
> 1. pCPU idles without notification vector configured to wakeup vector.
> 
> 2. PCI device is hotplugged, assigned device count increases from 0 to 1.
> 
> <arbitrary amount of time>
> 
> 3. device generates interrupt, sets ON bit to true in the posted
> interrupt descriptor.
> 
> We want to exit kvm_vcpu_block after 2, but before 3 (where ON bit
> is not set).

Ah yes.. thanks.

Besides the current approach, I'm thinking maybe it'll be cleaner/less LOC to
define a KVM_REQ_UNBLOCK to replace the pre_block hook (in x86's kvm_host.h):

#define KVM_REQ_UNBLOCK			KVM_ARCH_REQ(31)

We can set it in vmx_pi_start_assignment(), then check+clear it in
kvm_vcpu_has_events() (or make it a bool in kvm_vcpu struct?).

The thing is current vmx_vcpu_check_block() is mostly a sanity check and
copy-paste of the pi checks on a few items, so maybe cleaner to use
KVM_REQ_UNBLOCK, as it might be reused in the future for re-evaluating of
pre-block for similar purpose?

No strong opinion, though.

-- 
Peter Xu

