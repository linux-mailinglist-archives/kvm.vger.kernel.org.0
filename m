Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3CBA30E18D
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 18:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232191AbhBCR4i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 12:56:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231484AbhBCR4e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 12:56:34 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A1A7C061573
        for <kvm@vger.kernel.org>; Wed,  3 Feb 2021 09:55:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Message-ID:From:CC:To:Subject:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:
        Date:Sender:Reply-To:Content-ID:Content-Description;
        bh=9bmbLAvoGw3CHN07nQZ3hFNOSIoEcLty6E2uEwPL7W0=; b=pq8c/s32h1Rl3XIC4LbuZ4pwCA
        cvDKw+lRKwdU0w9Uf+ToPwbEcNm3LkRVoC2IAS8c3Px2yYkjT5jp1bDllqs2M3MWlTdHUlOE0QAdD
        QOP7oUbBspHA+u9A6XWgMKMTSVIRwT8XzFAbWwBMQR3kgSRkmPNhvjSG/4hjjc4ttdhriOix0mp5j
        zypCWhT33tPQaF7drDKPRAixkM9g4p26CRV4SX7O9TNuPbgUOxA0eantBg4n1Km+IXv9iV2aQvIra
        dvQUmPQWbSwk6wpJRzrXkn/0YZmvVcIgRy1DrQts6HaKIdNk9mdzbjm0GFqsnGU5guZJYxRFl6z8J
        cvsyYsKg==;
Received: from mango.cardolan.com ([81.187.210.96] helo=[192.168.0.55])
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l7MNa-0002ia-H1; Wed, 03 Feb 2021 17:55:50 +0000
Date:   Wed, 03 Feb 2021 17:55:50 +0000
User-Agent: K-9 Mail for Android
In-Reply-To: <190ec822-6010-5060-a6e8-9a49696abd0c@redhat.com>
References: <20210203150114.920335-1-dwmw2@infradead.org> <20210203150114.920335-19-dwmw2@infradead.org> <190ec822-6010-5060-a6e8-9a49696abd0c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v6 18/19] KVM: x86: declare Xen HVM shared info capability and add test case
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
CC:     Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com, hch@infradead.org
From:   David Woodhouse <dwmw2@infradead.org>
Message-ID: <875A2092-9E75-473C-8E23-0A99B9178252@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by merlin.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3 February 2021 16:38:43 GMT, Paolo Bonzini <pbonzini@redhat=2Ecom> wro=
te:
>On 03/02/21 16:01, David Woodhouse wrote:
>>=20
>> +struct vcpu_runstate_info {
>> +    uint32_t state;
>> +    uint64_t state_entry_time;
>> +    uint64_t time[4];
>> +};
>> +
>> +static void guest_code(void)
>> +{
>> +	struct vcpu_runstate_info *rs =3D (void *)RUNSTATE_ADDR;
>> +
>> +	/* Scribble on the runstate, just to make sure that=2E=2E=2E */
>> +	rs->state =3D 0x5a;
>> +
>> +	GUEST_SYNC(1);
>> +
>> +	/* =2E=2E=2E it is being set to RUNSTATE_running */
>> +	GUEST_ASSERT(rs->state =3D=3D 0);
>> +	GUEST_DONE();
>> +}
>
>Leftovers?

Oops, yes sorry=2E That wants taking out too=2E It'll be a few hours or pe=
rhaps tomorrow before I can repost=2E=20

--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
