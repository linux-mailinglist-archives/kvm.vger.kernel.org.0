Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20AAE28C491
	for <lists+kvm@lfdr.de>; Tue, 13 Oct 2020 00:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388396AbgJLWNx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Oct 2020 18:13:53 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:47930 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387733AbgJLWNx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Oct 2020 18:13:53 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602540831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LuiKu4qr/sT1tM7wle0aIn/VQDgFeNpFMEoWuMgq9Fs=;
        b=Swq70ficp5nunBRP5X2A6FLq098EjwfYTQtuaBpRYnXjc1abFV9/ExegjZkqZdk3fMbxzQ
        F1OJsyirPPneL/Gz7gq+Po/BoQ3L/8HAzFgW0aT6kJdOANW4byXESFe2H0SENuJukDC1eK
        2lFMCnvUvXBW98+d7SFOFWqYJKujuStLl3Vo7Rw9SOYOdui4gNIienlqOpGIfT8e9ZvVJJ
        +cM56y0ICJmLOIAhgwLJPts0xdJNwKpHWNtUQPH78w4M5mQX5yPaCbcohFdEi5jqXPM4SG
        PUYaiCK6ByUuBxB48LlZX3hp/piYUutjI6lwPfqnIEK2uniREnnvAYivhxPQKQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602540831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LuiKu4qr/sT1tM7wle0aIn/VQDgFeNpFMEoWuMgq9Fs=;
        b=Kz1uTZ9sNJBMyiiE/iFwfedMCVUQjfTK8euM5Ear6BX/epQsfx6cE+l7Vm823o+7stsMIo
        E3fwvFsFQ09scyCw==
To:     David Woodhouse <dwmw2@infradead.org>, x86@kernel.org,
        Marc Zyngier <maz@kernel.org>
Cc:     kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] x86/kvm: Add KVM_FEATURE_MSI_EXT_DEST_ID
In-Reply-To: <1abc2a34c894c32eb474a868671577f6991579df.camel@infradead.org>
References: <803bb6b2212e65c568c84ff6882c2aa8a0ee03d5.camel@infradead.org> <20201007122046.1113577-1-dwmw2@infradead.org> <20201007122046.1113577-5-dwmw2@infradead.org> <87blhcx6qz.fsf@nanos.tec.linutronix.de> <f27b17cf4ab64fdb4f14a056bd8c6a93795d9a85.camel@infradead.org> <95625dfce360756b99641c31212634c1bf80a69a.camel@infradead.org> <87362owhcb.fsf@nanos.tec.linutronix.de> <c6f21628733cac23fd28679842c20423df2dd423.camel@infradead.org> <87tuv4uwmt.fsf@nanos.tec.linutronix.de> <958f0d5c9844f94f2ce47a762c5453329b9e737e.camel@infradead.org> <874kn2s3ud.fsf@nanos.tec.linutronix.de> <0E51DAB1-5973-4226-B127-65D77DC46CB5@infradead.org> <87pn5or8k7.fsf@nanos.tec.linutronix.de> <F0F0A646-8DBA-4448-933F-993A3335BD59@infradead.org> <87ft6jrdpk.fsf@nanos.tec.linutronix.de> <25c54f8e5da1fd5cf3b01ad2fdc1640c5d86baa1.camel@infradead.org> <87362jqoh3.fsf@nanos.tec.linutronix.de> <1abc2a34c894c32eb474a868671577f6991579df.camel@infradead.org>
Date:   Tue, 13 Oct 2020 00:13:50 +0200
Message-ID: <87eem3ozxd.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 12 2020 at 21:20, David Woodhouse wrote:
> On Mon, 2020-10-12 at 20:38 +0200, Thomas Gleixner wrote:
>> Nasty, but way better than what we have now. 
>
> Want me to send that out in email or is the git tree enough for now?
>
> I've cleaned it up a little and fixed a bug in the I/OAPIC error path.

Mail would be nice once you are confident with the pile.

> Still not entirely convinced about the apic->apic_id_valid(32768) thing
> but it should work well enough, and doesn't require exporting any extra
> state from apic.c that way.

Yeah, that part is odd.

I really dislike the way how irq_find_matching_fwspec() works. The 'rc'
value is actually boolean despite being type 'int' and if 'rc' is not 0
then it returns the domain even if 'rc' is an error code.

But that does not allow to return error codes from a domain match() /
select() callback which is what we really want to express that there is
something fishy.

Something like the below perhaps? Needs more thought obviously.

Marc, any opinion ?

Thanks,

        tglx

8<-------------

arch/x86/kernel/apic/vector.c |   18 ++++++++++++++++++
 include/linux/irqdomain.h     |    1 +
 kernel/irq/irqdomain.c        |    2 +-
 3 files changed, 20 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -593,6 +593,24 @@ static int x86_vector_alloc_irqs(struct
 	return err;
 }
 
+struct irq_domain *x86_select_parent_domain(struct irq_fwspec *fwspec)
+{
+	struct irq_domain *dom;
+
+	/*
+	 * If Interrupt Remapping is enabled then the match function
+	 * returns either the remapping domain or an error code if the
+	 * device is not registered with the remapping unit.
+	 *
+	 * If remapping is not enabled, then the function returns NULL.
+	 */
+	dom = irq_find_matching_fwspec(fwspec, DOMAIN_BUS_IR);
+	if (dom)
+		return IS_ERR(dom) ? NULL : dom;
+
+	return x86_vector_domain;
+}
+
 #ifdef CONFIG_GENERIC_IRQ_DEBUGFS
 static void x86_vector_debug_show(struct seq_file *m, struct irq_domain *d,
 				  struct irq_data *irqd, int ind)
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -85,6 +85,7 @@ enum irq_domain_bus_token {
 	DOMAIN_BUS_TI_SCI_INTA_MSI,
 	DOMAIN_BUS_WAKEUP,
 	DOMAIN_BUS_VMD_MSI,
+	DOMAIN_BUS_IR,
 };
 
 /**
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -395,7 +395,7 @@ struct irq_domain *irq_find_matching_fws
 			       (h->bus_token == bus_token)));
 
 		if (rc) {
-			found = h;
+			found = rc < 0 ? ERR_PTR(rc) : h;
 			break;
 		}
 	}



