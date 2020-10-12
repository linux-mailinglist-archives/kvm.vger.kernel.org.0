Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF9BE28BFDB
	for <lists+kvm@lfdr.de>; Mon, 12 Oct 2020 20:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387909AbgJLSiS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Oct 2020 14:38:18 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:46842 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbgJLSiS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Oct 2020 14:38:18 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602527896;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AIJJxrRTYI7/G4jUBhTF1PuYkEEiQEXkfOYIuChW94Q=;
        b=2CnO3irtn1TPs1W8K6cSo8Fi1B+04BiL4p9scFJK6PxfDb+QaQB/hafstqIZkSTTC6DT0Z
        7QaBIzeajNCjTYW8SVApOK4QCF69OgumOFBSHEKvmmTKyPG/i7Uewpd38oFZvLg0pRq6z8
        DP8tjNKtawl/XmzvL5fUtdUCB+ixK9kzXmFfIeLHmNgOiKhbD0q4chsFEl6NORV1iUOcko
        Odt6p/FEg/sTf+xx20g8+9zzY2Jqf453TDglxP6Z/hGlj4qDzdDDMqNJqTc0LQD74Y8xOR
        bpFK3WX1p45yer6mwbif+rt4sJXaj0q7cq/88GxhIfUQu6K7C8F6NtC6Ft14Xw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602527896;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AIJJxrRTYI7/G4jUBhTF1PuYkEEiQEXkfOYIuChW94Q=;
        b=RzhatGEc49jSWbj2iqK6QoIQCvLwtYoyESzglE8MeZ4Ni8Nyy++ScWap8ts92tTHnIBl27
        BZqR/wNVniffCUAQ==
To:     David Woodhouse <dwmw2@infradead.org>, x86@kernel.org,
        Marc Zyngier <maz@kernel.org>
Cc:     kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] x86/kvm: Add KVM_FEATURE_MSI_EXT_DEST_ID
In-Reply-To: <25c54f8e5da1fd5cf3b01ad2fdc1640c5d86baa1.camel@infradead.org>
References: <803bb6b2212e65c568c84ff6882c2aa8a0ee03d5.camel@infradead.org> <20201007122046.1113577-1-dwmw2@infradead.org> <20201007122046.1113577-5-dwmw2@infradead.org> <87blhcx6qz.fsf@nanos.tec.linutronix.de> <f27b17cf4ab64fdb4f14a056bd8c6a93795d9a85.camel@infradead.org> <95625dfce360756b99641c31212634c1bf80a69a.camel@infradead.org> <87362owhcb.fsf@nanos.tec.linutronix.de> <c6f21628733cac23fd28679842c20423df2dd423.camel@infradead.org> <87tuv4uwmt.fsf@nanos.tec.linutronix.de> <958f0d5c9844f94f2ce47a762c5453329b9e737e.camel@infradead.org> <874kn2s3ud.fsf@nanos.tec.linutronix.de> <0E51DAB1-5973-4226-B127-65D77DC46CB5@infradead.org> <87pn5or8k7.fsf@nanos.tec.linutronix.de> <F0F0A646-8DBA-4448-933F-993A3335BD59@infradead.org> <87ft6jrdpk.fsf@nanos.tec.linutronix.de> <25c54f8e5da1fd5cf3b01ad2fdc1640c5d86baa1.camel@infradead.org>
Date:   Mon, 12 Oct 2020 20:38:16 +0200
Message-ID: <87362jqoh3.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 12 2020 at 17:06, David Woodhouse wrote:
> On Mon, 2020-10-12 at 11:33 +0200, Thomas Gleixner wrote:
>> You might want to look into using irq_find_matching_fwspec() instead for
>> both HPET and IOAPIC. That needs a select() callback implemented in the
>> remapping domains.
>
> That works.

:)

Nasty, but way better than what we have now. Now I start to wonder
whether we can get rid of a few other things as well especially the
non-standard alloc_info thingy.

Thanks,

        tglx
