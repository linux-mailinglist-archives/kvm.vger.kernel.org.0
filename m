Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 460CD2C8C8B
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 19:19:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387976AbgK3SSy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 13:18:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387960AbgK3SSy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Nov 2020 13:18:54 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 579C6C0613D2
        for <kvm@vger.kernel.org>; Mon, 30 Nov 2020 10:18:14 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id e8so10954293pfh.2
        for <kvm@vger.kernel.org>; Mon, 30 Nov 2020 10:18:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=xdIedazEfXXnCAeqOGlzEefkWkg8iQVFK6VAg0y1HPI=;
        b=QjpMwFKn9uAxSDuzuHZbkrtI966789Di/w6FPRS/lVvvqi73Bnf4hrsK0prfQyAdgt
         U4y0g3xJm0ujAOltTSk1oqdb27zs86c2DDsr977N1potUxpXnBUU6/pbB8eM+RQHprrE
         16u8gaF22DzW6tCfq6tnfKnykjGquX3jtCTXvPSpV+Wv6V1b0ImqhGCiTl+CSpzzd10/
         fJ1bSov9m+J6shoi7BuHiqRRmbK/5BNHqoHGVrsEkO//su9hpZ237sy+CsHkf1JeSl0R
         kVTvI6Jnn1gStqqFqZE8MznO5MGxhtU94lD5ZQXpbUzeCVVIZ5A2aU3AYcBZSykqnsUY
         hubQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=xdIedazEfXXnCAeqOGlzEefkWkg8iQVFK6VAg0y1HPI=;
        b=HAGX7zuazMcDN8n9rgR0mDPDXVZGXIOvgNzhd5wJ4SjcakwXZSqJdyVWh1KfRXCN8E
         QKzbMDdQLTAJKV77KJG8PHd1/K30W5LEKgFi8lO+pv8LETpxz5CpBZcRRsqJ4DyivvK7
         M1pbDE1BlGGaFxfkzZNlRqhHOeDtkAOVGilarJq/WSyZw1fQEr3qWe2YXDFWoZ6R3eme
         gJUCHOl1NdcuNFYJzxvXl+akcVngf9KoldetF4CkMg5M++EFs3W/n2aDUrPkYx3xDsTH
         lPANGHlbghRcPiYZMTyIzq2mNjDXHxrSgi8Ho/uqyxFIz9RK/HldCZkl+UEtpbYWlIGC
         85mw==
X-Gm-Message-State: AOAM530MbLgSCUjsWGvg+6UZhrI6llAPSf7YaGS5ER/C58vREpx6h9iE
        RXbge+aC3DXSifPXTwti6DDWzw==
X-Google-Smtp-Source: ABdhPJwOM4/nwZd+OBDC/6sXShLheOMgPtxBR2yspsPjbxNYytV6YvKpviVNw+fOKCM53vWE1L4wsQ==
X-Received: by 2002:a63:b1c:: with SMTP id 28mr19320876pgl.206.1606760293693;
        Mon, 30 Nov 2020 10:18:13 -0800 (PST)
Received: from google.com (242.67.247.35.bc.googleusercontent.com. [35.247.67.242])
        by smtp.gmail.com with ESMTPSA id s145sm17286194pfs.187.2020.11.30.10.18.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 10:18:13 -0800 (PST)
Date:   Mon, 30 Nov 2020 18:18:09 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [RFC PATCH 00/35] SEV-ES hypervisor support
Message-ID: <X8U3YeoIg1m2NW9x@google.com>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
 <20200914225951.GM7192@sjchrist-ice>
 <bee6fdda-d548-8af5-f029-25c22165bf84@amd.com>
 <20200916001925.GL8420@sjchrist-ice>
 <60cbddaf-50f3-72ca-f673-ff0b421db3ad@redhat.com>
 <38e89899-cf58-3a39-1d09-3ce963140a57@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <38e89899-cf58-3a39-1d09-3ce963140a57@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 30, 2020, Tom Lendacky wrote:
> On 11/30/20 9:31 AM, Paolo Bonzini wrote:
> > On 16/09/20 02:19, Sean Christopherson wrote:
> >>
> >> TDX also selectively blocks/skips portions of other ioctl()s so that the
> >> TDX code itself can yell loudly if e.g. .get_cpl() is invoked.  The event
> >> injection restrictions are due to direct injection not being allowed
> >> (except
> >> for NMIs); all IRQs have to be routed through APICv (posted interrupts) and
> >> exception injection is completely disallowed.
> >>
> >>    kvm_vcpu_ioctl_x86_get_vcpu_events:
> >>     if (!vcpu->kvm->arch.guest_state_protected)
> >>              events->interrupt.shadow =
> >> kvm_x86_ops.get_interrupt_shadow(vcpu);
> > 
> > Perhaps an alternative implementation can enter the vCPU with immediate
> > exit until no events are pending, and then return all zeroes?
> 
> SEV-SNP has support for restricting injections, but SEV-ES does not.
> Perhaps a new boolean, guest_restricted_injection, can be used instead of
> basing it on guest_state_protected.

Ya, that probably makes sense.  I suspect the easiest way to resolve these
conflicts will be to land the SEV-ES series and then tweak things as needed for
TDX.  Easiest in the sense that it should be fairly obvious what can be covered
by guest_state_protected and what needs a dedicated flag.
