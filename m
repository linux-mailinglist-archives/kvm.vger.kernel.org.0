Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D474028738D
	for <lists+kvm@lfdr.de>; Thu,  8 Oct 2020 13:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbgJHLqV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Oct 2020 07:46:21 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:50154 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbgJHLqV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Oct 2020 07:46:21 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602157579;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=h1dGwhxZkX9OEIlw0SsxzP80R1mGJUc+Ts41ZnjNcUE=;
        b=i8qsVqbOdwU7+HKO33og+K0bVjVnPcnBKK2r5IGkfYWgO21i8C2PSvEhC1zg4OzQUEpzwt
        91lLkmY5IJVWxdH8Ch3NeXrMhQQ1ETXon/X2J5PwIfWwoEkLn1huw6qwd7ax4dr30n+2km
        8kOxsbwC8iJ1BEuIKoBlZOWBdpDm8TEwAM4fupsbeeXaD3eSlffLWh80hi3JNIn0nfLT04
        n3CkoqXd766p7JeNS8NgOr8Vwdk+eI0KTPNliYDKmhTY0fLKOp5g+tiLiGf1LRoaZbGrw/
        cf+cWYWISFMr5+6BeILNU/tQ+X0+EfBtSMKQs9MoYUTjfPnTAadMTg0kYJ2OIA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602157579;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=h1dGwhxZkX9OEIlw0SsxzP80R1mGJUc+Ts41ZnjNcUE=;
        b=+Be62cwXDuaOcTNG0If2a4nNjRPSCBMAOiNW6XuSePnlrZPmSp3f9Kl/kOk6bOmeh8zm//
        DFqXJUF7PKc73bBQ==
To:     David Woodhouse <dwmw2@infradead.org>, x86@kernel.org
Cc:     kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] x86/apic: Fix x2apic enablement without interrupt remapping
In-Reply-To: <20201007122046.1113577-1-dwmw2@infradead.org>
References: <803bb6b2212e65c568c84ff6882c2aa8a0ee03d5.camel@infradead.org> <20201007122046.1113577-1-dwmw2@infradead.org>
Date:   Thu, 08 Oct 2020 13:46:18 +0200
Message-ID: <87lfghvt2t.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 07 2020 at 13:20, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
>  
>  static struct apic apic_x2apic_phys;
> +static u32 x2apic_max_apicid;

__ro_after_init?

Thanks,

        tglx
