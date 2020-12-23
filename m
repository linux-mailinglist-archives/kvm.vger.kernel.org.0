Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53C772E1B42
	for <lists+kvm@lfdr.de>; Wed, 23 Dec 2020 11:52:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728301AbgLWKvv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Dec 2020 05:51:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726022AbgLWKvv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Dec 2020 05:51:51 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80306C0613D3
        for <kvm@vger.kernel.org>; Wed, 23 Dec 2020 02:51:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Message-ID:From:CC:To:Subject:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:
        Date:Sender:Reply-To:Content-ID:Content-Description;
        bh=Lt09kCHgkUzbRMUDr+ddXdoZT19yUAB8i/xZm9rm+qg=; b=F/bdsJM7RiNIBeVhSTwWfCvHeF
        WeuJH8G7kEHpWs5/BtnezHiqbC3/19LBNJg1hddX4OYIExOoBYCjcmo4Gu/TaRRSvAGWENPzec0/h
        /apx/ZueAr/o6gPPpaMy+B8JbEYLzOO2FpzwGpIIwGJu4mHfupBEuw5lu3fygHrConpnIB1+dMaSX
        mCckB1YAde5+bCbGemCgZDqRvCYqyw3DcTJIvA8isJ4Wb0lCC2MhwjiI5pcdnAdsSGNIHqCNa7JKm
        84MhC5SGFCIo7e3qRB6ZcXzUvGmJ0aRWUmhlUnvr+p0aS+CR8XZFpKAafacqYRWuCd0H4Yr7Usozt
        62UkOWgw==;
Received: from [2a01:4c8:1070:1acd:89a9:a720:68b3:8621]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ks1jW-0007GB-N1; Wed, 23 Dec 2020 10:51:07 +0000
Date:   Wed, 23 Dec 2020 10:51:00 +0000
User-Agent: K-9 Mail for Android
In-Reply-To: <20201223083644.GC27350@infradead.org>
References: <20201214083905.2017260-1-dwmw2@infradead.org> <20201214083905.2017260-4-dwmw2@infradead.org> <20201223083644.GC27350@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v3 03/17] KVM: x86/xen: intercept xen hypercalls if enabled
To:     Christoph Hellwig <hch@infradead.org>
CC:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com
From:   David Woodhouse <dwmw2@infradead.org>
Message-ID: <90BDE706-0427-495C-AD34-F618B5D505DE@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by merlin.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 23 December 2020 08:36:44 GMT, Christoph Hellwig <hch@infradead=2Eorg> =
wrote:
>I think all the Xen support code should be conditional on a new config
>option so that normal configs don't have to build the code (and open
>potential attack vectors)=2E

None of this is usable by the guest (as an attack vector or otherwise) unl=
ess explicitly enabled by the VMM=2E And for clock stuff it's even using th=
e *same* functions that are used for native KVM guests, just parameterised =
a little for the different locations=2E

I saw the previous discussion but didn't really think it was worth adding =
yet another build time option for the kernel=2E

Even when I add event channel support I plan to use the same user_cmpxchg =
functionality to clean up the KVM steal time handling and even that part wo=
n't be Xen-specific=2E

--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
