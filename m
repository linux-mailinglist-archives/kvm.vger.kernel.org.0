Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A1C7309536
	for <lists+kvm@lfdr.de>; Sat, 30 Jan 2021 14:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbhA3NCa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 Jan 2021 08:02:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbhA3NCX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 30 Jan 2021 08:02:23 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A787DC061573
        for <kvm@vger.kernel.org>; Sat, 30 Jan 2021 05:01:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Message-ID:From:CC:To:Subject:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:
        Date:Sender:Reply-To:Content-ID:Content-Description;
        bh=TT3BZQRQ1cHpmmpOKyBvkQDt8EvT/KI8Q0TH1wg3Dkw=; b=cMdCe9N8mWPasPwSljaEqTTQq2
        TPPxiHE//1qEO14Jur8P/PbmBIPSHRMOljq+Tf+RJ3x/Ath8er6jGr/V0twNWOwKseDcWFHTTOBfL
        KK3KsPaEonFT1SvAnBNHwgr4wley5eMbiiBtohF195jQY9zJd3dnrEVV/TGVnObCIcV7/9EHcLKeW
        2KReta6qUPRwee8ynTzefTkLSebxnaLsIocbjoQ8tn1ReQTqn5pVwE0vwAPxb9MzvMSF5tv/mTcfn
        SK54s16Man+QCjrUi2gUFpT7jIQ9KK042It9YwL5pYb+4x9O9q21nxQcR4FXM6Q4jjDEaJhBxHxPI
        fU24q9yA==;
Received: from host86-187-227-52.range86-187.btcentralplus.com ([86.187.227.52] helo=[10.220.150.68])
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l5psg-00B7Bw-Uu; Sat, 30 Jan 2021 13:01:39 +0000
Date:   Sat, 30 Jan 2021 13:01:36 +0000
User-Agent: K-9 Mail for Android
In-Reply-To: <97fef86f-fef3-3ee8-9ae9-2144d19fc2a5@redhat.com>
References: <20210111195725.4601-1-dwmw2@infradead.org> <20210111195725.4601-17-dwmw2@infradead.org> <3b66ee62-bf12-c6ab-a954-a66e5f31f109@redhat.com> <529a1e82a0c83f82e0079359b0b8ba74ac670e89.camel@infradead.org> <97fef86f-fef3-3ee8-9ae9-2144d19fc2a5@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v5 16/16] KVM: x86/xen: Add event channel interrupt vector upcall
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
CC:     Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com, hch@infradead.org
From:   David Woodhouse <dwmw2@infradead.org>
Message-ID: <42324D06-519A-4DBB-83D7-D5D6ABF8C063@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 29 January 2021 19:19:55 GMT, Paolo Bonzini <pbonzini@redhat=2Ecom> wro=
te:
>On 29/01/21 18:33, David Woodhouse wrote:
>> On Thu, 2021-01-28 at 13:43 +0100, Paolo Bonzini wrote:
>>> Independent of the answer to the above, this is really the only
>place
>>> where you're adding Xen code to a hot path=2E  Can you please use a
>>> STATIC_KEY_FALSE kvm_has_xen_vcpu (and a static inline function) to
>>> quickly return from kvm_xen_has_interrupt() if no vCPU has a shared
>info
>>> set up?
>>=20
>> Something like this, then?
>>=20
>
>Yes, that was the idea=2E  Thanks!

Ok, I'll take a look at the get/set ioctls, maybe post an incremental patc=
h for those to get confirmation, then rework it all into the series and rep=
ost based on kvm/next=2E

Thanks=2E


--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
