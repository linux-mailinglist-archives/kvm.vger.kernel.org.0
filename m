Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D72482CF47D
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 20:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728508AbgLDTDR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 14:03:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726405AbgLDTDR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Dec 2020 14:03:17 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42126C0613D1
        for <kvm@vger.kernel.org>; Fri,  4 Dec 2020 11:02:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Message-ID:From:CC:To:Subject:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:
        Date:Sender:Reply-To:Content-ID:Content-Description;
        bh=Revx27MO6J70SJkJZ1JRJSVzo6qv/w1PfI7FMLDGkQw=; b=ajXbM2RGhQ9FFpms5BbXtv4onc
        HZjlzYcHfRp1TAZZ6TOLd+igFEpAhr3lGzdq1LZlynwEkRlzBm3vxgKOYC2BYx1YF0EZlcO/cUF2y
        AuMHvKgi+9EiW/SPJN3n8dWhXuFfjtAgvZSkbTwVwyZpzqX/x4QlhXp7rBsMNzGstdv4ezp86pCEG
        laptZ0PeMwLtH0zvvR1RwOtKzVVjdTPQLAYI8+eUp/uRmYyPXYUy/UYU9IGi0kn8/2LtAG3iLL58j
        QQvsLxIGpl9CRofLfRiD2nqOFlpIh51F+2Fp3meeJLbl6+/M6d6CfArlveS071xHYdpD9lzfrSCpr
        712DlCtg==;
Received: from [2001:8b0:10b:1:782d:346f:3c1:eeee]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1klGLj-00016t-3X; Fri, 04 Dec 2020 19:02:35 +0000
Date:   Fri, 04 Dec 2020 19:02:35 +0000
User-Agent: K-9 Mail for Android
In-Reply-To: <cdee7797-b21b-2dad-0692-207dfe464980@amazon.com>
References: <20201204011848.2967588-1-dwmw2@infradead.org> <20201204011848.2967588-2-dwmw2@infradead.org> <cdee7797-b21b-2dad-0692-207dfe464980@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 01/15] KVM: Fix arguments to kvm_{un,}map_gfn()
To:     Alexander Graf <graf@amazon.com>, kvm@vger.kernel.org
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>
From:   David Woodhouse <dwmw2@infradead.org>
Message-ID: <90A4DD4E-6E35-484C-8BE9-A142BFB786D1@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4 December 2020 18:27:34 GMT, Alexander Graf <graf@amazon=2Ecom> wrote:
>On 04=2E12=2E20 02:18, David Woodhouse wrote:
>> From: David Woodhouse <dwmw@amazon=2Eco=2Euk>
>>=20
>> It shouldn't take a vcpu=2E
>
>This is not a patch description=2E Please provide an actual rationale=2E

What?

If you aren't familiar with the KVM function nomenclature=2E=2E=2E since t=
he function name is kvm_xxx() and it operates on the struct KVM, not kvm_vc=
pu_xxx() and it doesn't actually use the vCPU it's given except to get vcpu=
->kvm and operate on that=2E=2E=2E it shouldn't take a vcpu=2E

But most of those words are superfluous to anyone who's paying attention=
=2E

The rationale in the patch seems perfectly clear to me=2E
>
>
>
>Amazon Development Center Germany GmbH
>Krausenstr=2E 38
>10117 Berlin
>Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
>Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
>Sitz: Berlin
>Ust-ID: DE 289 237 879

--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
