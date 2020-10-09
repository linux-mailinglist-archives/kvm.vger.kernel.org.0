Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B22C42881F6
	for <lists+kvm@lfdr.de>; Fri,  9 Oct 2020 08:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729081AbgJIGHV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Oct 2020 02:07:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727313AbgJIGHV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Oct 2020 02:07:21 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E6A4C0613D2;
        Thu,  8 Oct 2020 23:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Message-ID:From:CC:To:Subject:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:
        Date:Sender:Reply-To:Content-ID:Content-Description;
        bh=2p54TBCV6IXlB1szJ2D6yALxADUV3N3loPFLFKdD3xk=; b=pn5UGAr5HAqsQpWLR4av2ytYWN
        TELUOkUz01XHHf2B6D+mLuxcmrAThFnkldCL2X7IaajhWHFWkgh1efUPyrogVMJysuBxNxnJhn2gN
        sTaUROJzHF5Y2ZQEF2ZAXVnpVhD1RpMheFiWGpPti5xCNkXY92CixDOivmf0QJpNKJP9wFuTp723z
        6P3iboa0stO8xE8myqJ+T0aALaukQkWIIjRqFCYz92lkMHBETCJGPjKr13z82+SDbLnWFIscrpUSy
        PtPqGkkjL+TRN6c/PI88uXflEISrzqPHgI0zNi8K1FoLdHIyfuRgRYM34nAhJPlh8L5l+knU/iNtJ
        cSZ/Anaw==;
Received: from [2001:8b0:10b:1:ad95:471b:fe64:9cc3]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kQlYi-0007za-0i; Fri, 09 Oct 2020 06:07:16 +0000
Date:   Fri, 09 Oct 2020 07:07:12 +0100
User-Agent: K-9 Mail for Android
In-Reply-To: <87tuv4uwmt.fsf@nanos.tec.linutronix.de>
References: <803bb6b2212e65c568c84ff6882c2aa8a0ee03d5.camel@infradead.org> <20201007122046.1113577-1-dwmw2@infradead.org> <20201007122046.1113577-5-dwmw2@infradead.org> <87blhcx6qz.fsf@nanos.tec.linutronix.de> <f27b17cf4ab64fdb4f14a056bd8c6a93795d9a85.camel@infradead.org> <95625dfce360756b99641c31212634c1bf80a69a.camel@infradead.org> <87362owhcb.fsf@nanos.tec.linutronix.de> <c6f21628733cac23fd28679842c20423df2dd423.camel@infradead.org> <87tuv4uwmt.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 5/5] x86/kvm: Add KVM_FEATURE_MSI_EXT_DEST_ID
To:     Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
CC:     kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
From:   David Woodhouse <dwmw2@infradead.org>
Message-ID: <770B6323-61CC-4D33-B2B2-797686BD9D56@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9 October 2020 00:27:06 BST, Thomas Gleixner <tglx@linutronix=2Ede> wro=
te:
>On Thu, Oct 08 2020 at 22:39, David Woodhouse wrote:
>> On Thu, 2020-10-08 at 23:14 +0200, Thomas Gleixner wrote:
>>> >=20
>>> > (We'd want the x86_vector_domain to actually have an MSI compose
>>> > function in the !CONFIG_PCI_MSI case if we did this, of course=2E)
>>>=20
>>> The compose function and the vector domain wrapper can simply move
>to
>>> vector=2Ec
>>
>> I ended up putting __irq_msi_compose_msg() into apic=2Ec and that way I
>> can make virt_ext_dest_id static in that file=2E
>>
>> And then I can move all the HPET-MSI support into hpet=2Ec too=2E
>
>Works for me=2E
>
>>
>https://git=2Einfradead=2Eorg/users/dwmw2/linux=2Egit/shortlog/refs/heads=
/ext_dest_id
>
>For the next submission, can you please
>
> - pick up the -ENODEV changes for HPET/IOAPIC which I posted earlier

Ack=2E

> - shuffle all that compose/IOAPIC cleanup around

I'd prefer the MSI swizzling bit to stay last in the series=2E I want to s=
tare hard at the hyperv-iommu part a bit more, and ideally even have it tes=
ted=2E I'd prefer the real functionality that I care about, not to depend o=
n that cleanup=2E

If it actually let me remove all mention of ext_dest_id from the IOAPIC co=
de and use *only* MSI swizzling, I'd be keener to reorder=2E But as noted, =
there are a couple of manual RTE constructions in there still anyway=2E

I can move __irq_compose_msi_msg() earlier in the series though, and then =
virt_ext_dest_id can be static in apic=2Ec from its inception=2E

OK?

--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
