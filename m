Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6802DA2BE
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 22:47:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503591AbgLNVqq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 16:46:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503603AbgLNVqm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 16:46:42 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76114C0613D6
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 13:46:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Message-ID:From:CC:To:Subject:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:
        Date:Sender:Reply-To:Content-ID:Content-Description;
        bh=SPHPbTIEXCVeC+xpSEWc6jY8uyuw7I8G9y2OycRgCAA=; b=eto2qS8wlkLDT8loT6agWLRC/R
        MbgIBU1QhNY6mVSqkmj4hLA1fabbfBgq5OHw45mHVhjMKtV+nJCggFsrmdfX2IJqjZgfvg7hyTvG5
        5U7Q5iQRjT1ZTMKfpVYgFNmNNgqNENIsP1ysDD4sq4M6hbmZz7EXqtm93XA21FFY6FeBAz1yisfLb
        t6PP5c24Qcow1//XYKDUyPtnT+wfgJz3RXZDQD0iPzHF34Xz3sLf7ORkHS95vZS2iZOcWkV2m6m6b
        UVpn0R9tuQCI4MK9fjkZlsjJ0pIe1JglQOsL+L5xVH42sWGqYMzdoz5gXNQHxQB0AEsHGz6kYBlIg
        mW+P2c2A==;
Received: from [2001:8b0:10b:1:4d32:84d8:690e:d301]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kovfM-0001sq-BD; Mon, 14 Dec 2020 21:46:00 +0000
Date:   Mon, 14 Dec 2020 21:45:58 +0000
User-Agent: K-9 Mail for Android
In-Reply-To: <87a6ugvzek.fsf@vitty.brq.redhat.com>
References: <20201214083905.2017260-1-dwmw2@infradead.org> <20201214083905.2017260-2-dwmw2@infradead.org> <87ft48w0or.fsf@vitty.brq.redhat.com> <6E8FD19B-7ABD-4BF1-84C5-26EDD327F01D@infradead.org> <87a6ugvzek.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v3 01/17] KVM: Fix arguments to kvm_{un,}map_gfn()
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com
From:   David Woodhouse <dwmw2@infradead.org>
Message-ID: <3E601C94-B52B-43AF-9D13-FD8CB24DED20@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 14 December 2020 21:41:23 GMT, Vitaly Kuznetsov <vkuznets@redhat=2Ecom>=
 wrote:
>>Your change is correct but I'm not sure that it's entirely clear that
>kvm_map_gfn() implicitly uses 'as_id=3D0' and I don't even see a comment
>about the fact :-(

Isn't that true of all the kvm_read_guest and kvm_write_guest functions an=
d indeed of kvm_memslots() itself?

--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
