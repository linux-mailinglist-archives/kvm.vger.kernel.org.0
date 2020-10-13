Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39D7C28CE86
	for <lists+kvm@lfdr.de>; Tue, 13 Oct 2020 14:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbgJMMk6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Oct 2020 08:40:58 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:51748 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727114AbgJMMk5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Oct 2020 08:40:57 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602592856;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PtXsyiQpxCT6OGocoDV2xxYXmu++2jlzkrSoN+j9pRU=;
        b=ZOhokM3pscswWs/6L/+yp+pNzzbKR8c7jaCklmGODRNv2mGh7LTgmNcJF1kgPKaKPP+ksr
        uEHGxq9JgpE2/P1IDDG9/5nfdviWuSte26uh3HKiCx6Tm0Fmb3W/qvLWuC2LQfR1ccLXMH
        4tVYwoWAVXzXkkxyGlg+PBU4sIPlNJwxNgJcjD9OIDv6jsUTaHFJGmuFFTbEeC4TaOSX5R
        NCUUg36m0CJydtFo2o/uTABAnL3RiTFrVX+tILyri7ynuhNEJel+bt9y04AMjKRe/ySqBk
        SZ1C/1reHxc0mu5bM9DqROwiunnooF60MKgeRGq+Vu1+ijO7eCKAJkuWTOn6VQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602592856;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PtXsyiQpxCT6OGocoDV2xxYXmu++2jlzkrSoN+j9pRU=;
        b=lgLaza4y48L6oQOyRBy1XqLgy1HeZ9SOaSeFB0Jhx8gOY+Qc/KdONfuORVzmHeb7Wv/FQ2
        BFc4wukp3LfMQcDA==
To:     David Woodhouse <dwmw2@infradead.org>, x86@kernel.org,
        Marc Zyngier <maz@kernel.org>
Cc:     kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] x86/kvm: Add KVM_FEATURE_MSI_EXT_DEST_ID
In-Reply-To: <0ca196c0df5beb90b45457ac7ca5d8611d2a7a29.camel@infradead.org>
References: <803bb6b2212e65c568c84ff6882c2aa8a0ee03d5.camel@infradead.org>
 <f27b17cf4ab64fdb4f14a056bd8c6a93795d9a85.camel@infradead.org>
 <95625dfce360756b99641c31212634c1bf80a69a.camel@infradead.org>
 <87362owhcb.fsf@nanos.tec.linutronix.de>
 <c6f21628733cac23fd28679842c20423df2dd423.camel@infradead.org>
 <87tuv4uwmt.fsf@nanos.tec.linutronix.de>
 <958f0d5c9844f94f2ce47a762c5453329b9e737e.camel@infradead.org>
 <874kn2s3ud.fsf@nanos.tec.linutronix.de>
 <0E51DAB1-5973-4226-B127-65D77DC46CB5@infradead.org>
 <87pn5or8k7.fsf@nanos.tec.linutronix.de>
 <F0F0A646-8DBA-4448-933F-993A3335BD59@infradead.org>
 <87ft6jrdpk.fsf@nanos.tec.linutronix.de>
 <25c54f8e5da1fd5cf3b01ad2fdc1640c5d86baa1.camel@infradead.org>
 <87362jqoh3.fsf@nanos.tec.linutronix.de>
 <1abc2a34c894c32eb474a868671577f6991579df.camel@infradead.org>
 <87eem3ozxd.fsf@nanos.tec.linutronix.de>
 <0de733f6384874d68afba2606119d0d9b1e8b34e.camel@infradead.org>
 <87zh4qo4o5.fsf@nanos.tec.linutronix.de>
 <87wnzuo127.fsf@nanos.tec.linutronix.de>
 <832c2d4c11cd99382782474f51d15889ffa24407.camel@infradead.org>
 <0ca196c0df5beb90b45457ac7ca5d8611d2a7a29.camel@infradead.org>
Date:   Tue, 13 Oct 2020 14:40:55 +0200
Message-ID: <87tuuynvs8.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 13 2020 at 12:51, David Woodhouse wrote:
> With that realisation, I've fixed the comment in my ext_dest_id branch
> to remove all mention of IRQ remapping. It now looks like this:
>
> static int x86_vector_select(struct irq_domain *d, struct irq_fwspec *fws=
pec,
> 			     enum irq_domain_bus_token bus_token)
> {
> 	/*
> 	 * HPET and I/OAPIC drivers use irq_find_matching_irqdomain()
> 	 * to find their parent irqdomain. For x86_vector_domain to be
> 	 * suitable, all CPUs in the system must be reachable by its
> 	 * x86_vector_msi_compose_msg() function. Which is only true
> 	 * in !x2apic mode, or in x2apic physical mode if APIC IDs were
> 	 * restricted to 8 or 15 bits at boot time. In those cases,
> 	 * 1<<15 will *not* be a valid APIC ID.
> 	 */
> 	if (apic->apic_id_valid(1<<15))
> 		return 0;
>
> 	return x86_fwspec_is_ioapic(fwspec) || x86_fwspec_is_hpet(fwspec);
> }
>
> That makes it clearer that this isn't just some incestuous interaction
> with IRQ remapping =E2=80=94 that APIC ID limit really is the basis on wh=
ich
> this irqdomain, all by itself, makes the decision about whether it's
> capable of being the parent irqdomain to the requesting device.

Yes, that makes sense now.

Thanks,

        tglx
