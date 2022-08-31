Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 985605A84AB
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 19:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbiHaRrR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 13:47:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiHaRrL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 13:47:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 719C6C1226
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 10:47:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661968028;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cjaWnDUuxi7FimnJS6wS+o0UPUIXMMd9GW1k9/00SrY=;
        b=CndTTVAN94hxgjfMQQNJ2uIWjOUWe4vgticrBYLiQA+UqlMTMCDLJWHPsLY1o3frQNRQXq
        X+PclpM2eT3DiFEemx4sFP9lmXHpmBtAYsGMPPXyt7trkCBFIjMttin5U1m6klPnN/UlM2
        MHCd2O9HeQXzf6dmS9dEQqa8uDn+tG4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-609-zH0cGgFyPj6fDjJu6Ckhqw-1; Wed, 31 Aug 2022 13:46:58 -0400
X-MC-Unique: zH0cGgFyPj6fDjJu6Ckhqw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 06966964081;
        Wed, 31 Aug 2022 17:46:58 +0000 (UTC)
Received: from starship (unknown [10.40.194.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6443A4011A58;
        Wed, 31 Aug 2022 17:46:56 +0000 (UTC)
Message-ID: <59206c01da236c836c58ff96c5b4123d18a28b2b.camel@redhat.com>
Subject: Re: [PATCH 03/19] Revert "KVM: SVM: Introduce hybrid-AVIC mode"
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Date:   Wed, 31 Aug 2022 20:46:55 +0300
In-Reply-To: <Yw+MYLyVXvxmbIRY@google.com>
References: <20220831003506.4117148-1-seanjc@google.com>
         <20220831003506.4117148-4-seanjc@google.com>
         <17e776dccf01e03bce1356beb8db0741e2a13d9a.camel@redhat.com>
         <84c2e836d6ba4eae9fa20329bcbc1d19f8134b0f.camel@redhat.com>
         <Yw+MYLyVXvxmbIRY@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-08-31 at 16:29 +0000, Sean Christopherson wrote:
> On Wed, Aug 31, 2022, Maxim Levitsky wrote:
> > On Wed, 2022-08-31 at 08:59 +0300, Maxim Levitsky wrote:
> > > On Wed, 2022-08-31 at 00:34 +0000, Sean Christopherson wrote:
> > > > Remove SVM's so called "hybrid-AVIC mode" and reinstate the restriction
> > > > where AVIC is disabled if x2APIC is enabled.  The argument that the
> > > > "guest is not supposed to access xAPIC mmio when uses x2APIC" is flat out
> > > > wrong.  Activating x2APIC completely disables the xAPIC MMIO region,
> > > > there is nothing that says the guest must not access that address.
> > > > 
> > > > Concretely, KVM-Unit-Test's existing "apic" test fails the subtests that
> > > > expect accesses to the APIC base region to not be emulated when x2APIC is
> > > > enabled.
> > > > 
> > > > Furthermore, allowing the guest to trigger MMIO emulation in a mode where
> > > > KVM doesn't expect such emulation to occur is all kinds of dangerous.
> > 
> > Also, unless I misunderstood you, the above statement is wrong.
> > 
> > Leaving AVIC on, when vCPU is in x2apic mode cannot trigger extra MMIO emulation,
> > in fact the opposite - because AVIC is on, writes to 0xFEE00xxx might *not* trigger
> > MMIO emulation and instead be emulated by AVIC.
> 
> That's even worse, because KVM is allowing the guest to exercise hardware logic
> that I highly doubt AMD has thoroughly tested.

Harware logic is exactly the same regarless of if KVM uses x2apic mode or not,
and it is better to be prepared for all kind of garbage coming from the guest.

Software logic, I can understand you, there could be registers that trap differently
in avic and x2avic mode, but it should be *very* easy to deal with it, the list
of registers that trap is very short.

> 
> > Yes, some of these writes can trigger AVIC specific emulation vm exits, but they
> > are literaly the same as those used by x2avic, and it is really hard to see
> > why this would be dangerous (assuming that x2avic code works, and avic code
> > is aware of this 'hybrid' mode).
> 
> The APIC_RRR thing triggered the KVM_BUG_ON() in kvm_apic_write_nodecode()
> precisely because of the AVIC trap.  At best, this gives a way for the guest to
> trigger a WARN_ON_ONCE() and thus panic the host if panic_on_warn=1.  I fixed
> the APIC_RRR case because that will be problematic for x2AVIC, but there are
> other APIC registers that are unsupported in x2APIC that can trigger the KVM_BUG_ON().
> 
> > From the guest point of view, unless the guest pokes at random MMIO area,
> > the only case when this matters is if the guest maps RAM over the 0xFEE00xxx
> > (which it of course can, the spec explictly state as you say that when x2apic
> > is enabled, the mmio is disabled), and then instead of functioning as RAM,
> > the range will still function as APIC.
> 
> There is no wiggle room here though, KVM is blatantly breaking the architectural
> specification.  When x2APIC is enabled, the xAPIC MMIO does not exist.

In this case I say that there is no wiggle room for KVM to not allow different APIC bases
on each CPU - the spec 100% allows it, but in KVM it is broken.

If you are really hell bent on not having that MMIO exposed, 
then I say we can just disable the AVIC memslot, and keep AVIC enabled in this case - 
this should make us both happy.


This discussion really makes me feel that you want just to force your opinion on others,
and its not the first time this happens. It is really frustrating to work like that.
It might sound harsh but this is how I feel. Hopefully I am wrong.


Best regards,
	Maxim Levisky


> 


