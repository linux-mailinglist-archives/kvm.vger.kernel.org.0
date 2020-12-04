Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D78732CF48E
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 20:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729911AbgLDTJT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 14:09:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727199AbgLDTJT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Dec 2020 14:09:19 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A42CC061A51
        for <kvm@vger.kernel.org>; Fri,  4 Dec 2020 11:08:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Message-ID:From:CC:To:Subject:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:
        Date:Sender:Reply-To:Content-ID:Content-Description;
        bh=HUPTtF8wXYWSI3hfsX2FAHCiMKqIk37efiR5qzWx6iQ=; b=neJKW9ecIbKYfrQ03tIIXXG8iF
        FcJmX9omShaTRwnyEnUBKejSLJOkD4hcj7N9Y9lc1JAJYijiTC72k+SmL9xWRbP8GvDV92CAoEAw/
        SkddKykvRUWeskAMvVjkRrLvgTlLfyR1ihdyRJ7dSgVxMFW8sUY9SpiZ02tyTewtI1vve02nmid/+
        BCtrbivkCCcj7xegFjo3R6g79JOfVlDxL2akR2Hstz6H5RnSYdK1Lj7PfHgb77WYiodjRo1AN4aVc
        Y3DNZZAAcTlKykZLDSI1UgUTMe3V+nD9MCXBrAhWamUTlPxRHJi51nZMQJ3Om+ho+f/FXD+PJjvsG
        4G3nllmw==;
Received: from [2001:8b0:10b:1:782d:346f:3c1:eeee]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1klGRZ-0001P6-5n; Fri, 04 Dec 2020 19:08:37 +0000
Date:   Fri, 04 Dec 2020 19:08:37 +0000
User-Agent: K-9 Mail for Android
In-Reply-To: <85442dac-7ed9-73d0-f8b3-2750dffa5278@amazon.com>
References: <20201204011848.2967588-1-dwmw2@infradead.org> <20201204011848.2967588-7-dwmw2@infradead.org> <85442dac-7ed9-73d0-f8b3-2750dffa5278@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 06/15] KVM: x86/xen: latch long_mode when hypercall page is set up
To:     Alexander Graf <graf@amazon.com>, kvm@vger.kernel.org
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>
From:   David Woodhouse <dwmw2@infradead.org>
Message-ID: <9485A1D3-D873-4CD0-B985-C1A4F453CDFD@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4 December 2020 18:38:05 GMT, Alexander Graf <graf@amazon=2Ecom> wrote:
>On 04=2E12=2E20 02:18, David Woodhouse wrote:
>> From: David Woodhouse <dwmw@amazon=2Eco=2Euk>
>
>If the shared_info page was maintained by user space, you wouldn't need
>
>any of this, right?

That may be the case=2E But what we put in the shared_info page and in the=
 vcpu_info is time keeping information which KVM has done for guests =E2=80=
=94 from the kernel =E2=80=94 for a very long time=2E

Again, you could make the argument that some of this stuff *could* be done=
 =E2=80=94 albeit less efficiently =E2=80=94 form userspace=2E

But again, that ship sailed years ago=2E
--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
