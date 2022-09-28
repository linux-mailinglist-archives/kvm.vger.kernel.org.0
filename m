Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62A2C5EE1EA
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 18:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233695AbiI1QdL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 12:33:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233049AbiI1QdJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 12:33:09 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75D3853D38
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 09:33:07 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id s26so12678064pgv.7
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 09:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=SAXhtOlw8ktsiTWcfNjq2uJhAEPOzK9zBrtlir+HUsQ=;
        b=mmds/8U+Gfot3tLkv0sZ71BY9GtNlOEAKcUYByNqN+A2rtUad7yJaN2GuTiAWzR/Rx
         Ss/ZZypzlC0fnxQDL/j1hXeWt7/1/NViMi7Oi9xy5OO28g7dMNTkd8bjl1ZDQbad1b3m
         JJbU2TLqisOVWQmrhvYlVBgIqw+PZgJK1ESl6YbA6MrgK6cS0H+MT4aSS3MuaJGF8qhE
         /lFU98ebEG2YLNoTwD8+rmF/9QZJeJho9BohcL9lbY2/2ZUYvutG3FOpWysGKuwgYeD2
         64KcBhJscjDWmXqnCqmmPROXINecCfnepvKYKGUW8a8st2nmfzffRLTTBY5vsIrMI7pm
         0zeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=SAXhtOlw8ktsiTWcfNjq2uJhAEPOzK9zBrtlir+HUsQ=;
        b=m9SkZ6tt236MmK2SqcVWL+iXLZGUKRD9w/iotAqpv7HO/3mkey4LV1mSFWLHevLQRs
         7lDUl86YerUtK12AmbBfOSAIyfeDPvVrPZylr2KUmHEVJmEsqeL7b3jEbksepv72aET9
         maAyvybYOF03DQwXwdwoIbPCz7h+bJabcPU+knAr0HsVVwznOHAlJPwIe5FZMPfjsP2H
         qT1TyqeQQn7qd46/uMYSxC+RWbvLSBTzBIt0Q/i+F1A0tXTBiymwkivBGlUEDftxtue1
         LJ6D0LpoBeXGwIrvn0vn9tn3JjDnb2VHNw03s7Ivlv7Kyj2m9eBvRMkARcSU1HZmal3W
         jC8A==
X-Gm-Message-State: ACrzQf3obgY2MHh0i6oZwP44W4um+hSVpaZyuZQ476Cf6uppwhymUJdt
        4HPxbrhaGQFOPUZ2Q1nGKMYPyw==
X-Google-Smtp-Source: AMsMyM7xHke4wbETucXZGu7h8dGGZB1s+ztiXRwI5luOckWmVLT8/uQDQje6n6T2PnvBd6+CFacZ7Q==
X-Received: by 2002:a05:6a00:2906:b0:52a:bc7f:f801 with SMTP id cg6-20020a056a00290600b0052abc7ff801mr36158254pfb.49.1664382786825;
        Wed, 28 Sep 2022 09:33:06 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id l6-20020a622506000000b00543a098a6ffsm4205281pfl.212.2022.09.28.09.33.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 09:33:05 -0700 (PDT)
Date:   Wed, 28 Sep 2022 16:33:02 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Subject: Re: [PATCH v3 07/28] KVM: x86: Inhibit APIC memslot if x2APIC and
 AVIC are enabled
Message-ID: <YzR3PaZokwIPDoXb@google.com>
References: <20220920233134.940511-1-seanjc@google.com>
 <20220920233134.940511-8-seanjc@google.com>
 <e84ebf0a7ac9322bd0cfa742ef6dd2bbfdac0df9.camel@redhat.com>
 <YzHawRN8vpEzP7XD@google.com>
 <bcc3c67abc3b2c3d896b800c5f8f7295b7238271.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bcc3c67abc3b2c3d896b800c5f8f7295b7238271.camel@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 28, 2022, Maxim Levitsky wrote:
> On Mon, 2022-09-26 at 17:00 +0000, Sean Christopherson wrote:
> > Given the SRCU problem, I'd prefer to keep the management of the memslot in common
> > code, even though I agree it's a bit silly.  And KVM_REQ_UNBLOCK is a perfect fit
> > for dealing with the SRCU issue, i.e. handling this in AVIC code would require
> > another hook on top of spreading the memslot management across x86 and SVM code.
> 
> OK, I am not going to argue about this. But what about at least not using an inhibit
> bit for that but something else like a boolean, or maybe really add 'I am AVIC bit'
> or rather something like vcpu->arch.apicv_type enum?
> 
> Or we can make SVM code just call a common function - just put these in a
> function and call it from avic_set_virtual_apic_mode?

The issue is that kvm_vcpu_update_apicv() is called from kvm_lapic_set_base(),
which is the one that may or may not hold SRCU.

> > > You are about to remove the KVM_REQ_UNBLOCK in other patch series.
> > 
> > No, KVM_REQ_UNHALT is being removed.  KVM_REQ_UNBLOCK needs to stay, although it
> > has a rather weird name, e.g. KVM_REQ_WORK would probably be better.
> 
> Roger that!
> And I guess lets rename it while we are at it.

I'll prep a patch.

> > > How about just raising KVM_REQ_APICV_UPDATE on current vCPU
> > > and having a special case in kvm_vcpu_update_apicv of 
> > > 
> > > if (apic_access_memslot_enabled == false && apic_access_memslot_allocaed == true) {
> > > 	drop srcu lock
> > 
> > This was my initial thought as well, but the issue is that SRCU may or may not be
> > held, and so the unlock+lock would need to be conditional.  That's technically a
> > solvable problem, as it's possible to detect if SRCU is held, but I really don't
> > want to rely on kvm_vcpu.srcu_depth for anything other than proving that KVM doesn't
> > screw up SRCU.
> 
> Why though? the KVM_REQ_APICV_UPDATE is only handled AFAIK in vcpu_enter_guest
> which drops the srcu lock few lines afterwards, and therefore the
> kvm_vcpu_update_apicv is always called with the lock held and it means that it
> can drop it for the duration of slot update.
> 
> The original issue we had was that we tried to drop the srcu lock in 
> 'kvm_set_apicv_inhibit' which indeed is called from various places,
> with, or without the lock held.
> 
> Moving the memslot disable code to kvm_vcpu_update_apicv would actually solve
> that, but it was not possible because kvm_vcpu_update_apicv is called
> simultaneously on all vCPUs, and created various races, including toggling
> the memslot twice.

As above, kvm_vcpu_update_apicv() can be called without SRCU held.  Oh, but that
was a recent addition, commit 8fc9c7a3079e ("KVM: x86: Deactivate APICv on vCPU
with APIC disabled").  I was wary of using KVM_REQ_APICV_UPDATE in kvm_lapic_set_base(),
e.g. in case there was some dependency on updating _immediately, but since that's
such a new addition I have no objection to switching to the request.

Similarly, is there a good reason for having nested_svm_vmexit() invoke
kvm_vcpu_update_apicv() directly?  I'm confused by the "so that other vCPUs can
start to benefit from it right away".  The nested inhibit is per-vCPU and so
should only affect the current vCPU, no?  I.e. for all intents and purposes, using
a request should be functionally equivalent.

	/*
	 * Un-inhibit the AVIC right away, so that other vCPUs can start
	 * to benefit from it right away.
	 */
	if (kvm_apicv_activated(vcpu->kvm))
		kvm_vcpu_update_apicv(vcpu);
