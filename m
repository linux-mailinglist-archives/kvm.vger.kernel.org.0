Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 886E62CF468
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 19:56:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730149AbgLDSzX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 13:55:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729780AbgLDSzX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Dec 2020 13:55:23 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D1DCC0613D1
        for <kvm@vger.kernel.org>; Fri,  4 Dec 2020 10:54:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Message-ID:From:CC:To:Subject:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:
        Date:Sender:Reply-To:Content-ID:Content-Description;
        bh=ol8U9VZl11WHkAZF0EQdPMGmhxdZk+IYql06LKOcH3k=; b=gjeUHW3eruh+h56C/CcNmhXMcz
        GADF/7fQqxhlh5fhRjGv1mzGXQw3A5zDcpYETjWzBehi8h2QvQPZ9ZGLbm3AEh7Z1HHzv7J0xUndt
        PvrBQlqpcwnJnhw8st66sTQ2/vWtnceydkz80aLDjZepXYPofSBfMxfGp4u5QuEFGy2aMeS5EbTWK
        rpiXcGfVR+6JsIgGKKRU5+2UnCVbxnG2NcCUXxZiO6S7FY7wHoX+omlYbDoxt64AbNJUFf9q05Thn
        30S8fAhva15tL67FCy+8u/t4tFbujVXnptQGVaNnfK/UV2kPw1m1dIFzc7kCKBmlW41epGAbu7nkd
        Y/qJ6MZQ==;
Received: from [2001:8b0:10b:1:782d:346f:3c1:eeee]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1klGE3-0000bg-T9; Fri, 04 Dec 2020 18:54:40 +0000
Date:   Fri, 04 Dec 2020 18:54:37 +0000
User-Agent: K-9 Mail for Android
In-Reply-To: <a7eff397-4b2b-6644-8425-88bc33b3a050@amazon.com>
References: <20201204011848.2967588-1-dwmw2@infradead.org> <20201204011848.2967588-3-dwmw2@infradead.org> <a7eff397-4b2b-6644-8425-88bc33b3a050@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 02/15] KVM: x86/xen: fix Xen hypercall page msr handling
To:     Alexander Graf <graf@amazon.com>, kvm@vger.kernel.org
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>
From:   David Woodhouse <dwmw2@infradead.org>
Message-ID: <40E6426A-A23F-48E8-A20F-798FE870ED51@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4 December 2020 18:26:36 GMT, Alexander Graf <graf@amazon=2Ecom> wrote:
>How much of this can we handle with the MSR allow listing and MSR=20
>trapping in user space?

We resisted that trapping for a long time but have it now, and both the ex=
isting Xen and Hyper-V support =E2=80=94 as well as a bunch of other things=
 that KVM has historically done in-kernel on trapping MSRs =E2=80=94 could =
*theoretically* be done in userspace=2E

But they all already exist in the kernel=2E This is just a bug fix because=
 the Hyper-V support broke it for Xen due to the conflict=2E

--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
