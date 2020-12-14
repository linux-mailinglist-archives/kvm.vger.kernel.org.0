Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 047592DA2CF
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 22:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502043AbgLNVt1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 16:49:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439420AbgLNVtZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 16:49:25 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E48D1C061793
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 13:48:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Message-ID:From:CC:To:Subject:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:
        Date:Sender:Reply-To:Content-ID:Content-Description;
        bh=qwA5jB1FrUb6DX2ORDsxgyEEqY5RxQMwtel2ZowAAtw=; b=Pz8ijnScdFCNUBNCc97qN1phfC
        8F1DygJIEoyiSldTN3skOgBqQ3gW7kvifm8/1fs+hf3zqu2sAS/pVb/W5LRWk7BaJITjwmegC53qi
        DHOj9v2V5c0CEh7R4BeCFu6c8r+YjAvosyNqU8Xk6NTRcal9g5m9qG1oShlY9rJ/RfZ7lWpionwPg
        Ndlvd5DrCamFmNWyh51+vgoFQ64fXhybS5ZhbG5yyDY8U/nYhgogLYcjSdXstkLEOnTmVBQAAZasO
        LcMzDQoeuXLeew31gwpl8hcOVowK/uEZ/uan8jQ9/KRM1FXKYE4nxGDz3WxJIS3r196VYnJ1v3wOd
        LQYVmVXw==;
Received: from [2001:8b0:10b:1:4d32:84d8:690e:d301]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kovhx-00023M-Es; Mon, 14 Dec 2020 21:48:41 +0000
Date:   Mon, 14 Dec 2020 21:48:36 +0000
User-Agent: K-9 Mail for Android
In-Reply-To: <877dpkvz8w.fsf@vitty.brq.redhat.com>
References: <20201214083905.2017260-1-dwmw2@infradead.org> <20201214083905.2017260-3-dwmw2@infradead.org> <87czzcw020.fsf@vitty.brq.redhat.com> <58AC82A4-ADE4-4A8F-9522-16B8A4B9CBDD@infradead.org> <877dpkvz8w.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v3 02/17] KVM: x86/xen: fix Xen hypercall page msr handling
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com
From:   David Woodhouse <dwmw2@infradead.org>
Message-ID: <432C977E-0E29-4FFC-86FF-9958601DAB40@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 14 December 2020 21:44:47 GMT, Vitaly Kuznetsov <vkuznets@redhat=2Ecom>=
 wrote:
>This actually looks more or less like hypercall distinction from after
>PATCH3:
>
>	if (kvm_xen_hypercall_enabled(vcpu->kvm))
>		return kvm_xen_hypercall(vcpu);
>
>        if (kvm_hv_hypercall_enabled(vcpu->kvm))
>  	        return kvm_hv_hypercall(vcpu);
>
>=2E=2E=2E=2E
>
>so my idea was why not do the same for MSRs?

Can you define kvm_hv_msr_enabled()?

Note kvm_hv_hypercall_enabled() is based on a value that gets written thro=
ugh the MSR, so it can't be that=2E

--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
