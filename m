Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AECEA28CBED
	for <lists+kvm@lfdr.de>; Tue, 13 Oct 2020 12:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387607AbgJMKrA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Oct 2020 06:47:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726412AbgJMKq7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Oct 2020 06:46:59 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9CB5C0613D0;
        Tue, 13 Oct 2020 03:46:58 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602586017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=L+OfWoaK03FtOJLT+uBBHRaOGqBz4mcpxwupRnAXoXE=;
        b=tCh84zN+6UDWqo7DX76iYBQrV+et2EduKa8m+ZF7jVCB8mTgk7Rero/WVa4z4J1CHx8eiU
        kMbN8TaW4kQyCmDnQC1spnPT7MxhSiyDw413wr9HnMZnWwJbH79zuMc8jzUyNH25NVL/G7
        gdf0GdundekIuI3pb5i5K/n8EPmehRShHUIKoov8b/yEVTq3vhVWaSqeEU7QwUzvvv6Gac
        X90QZkRlIfLxwBpG4109x0PZzfKGhlYNVMdrO4I1NOBdGRY03P0K0g2UGEwL39CuvoVBSq
        Byi+iNuOVioYl5MwzbD/IDLRNb/3zc0fqcFxBc8673xy7wAjzCuur9wHwm8JPw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602586017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=L+OfWoaK03FtOJLT+uBBHRaOGqBz4mcpxwupRnAXoXE=;
        b=RUfO1mQTFwjO9Z9aKbadAx+rldtBYeDNU/vQKZ94FKoU3yj9B5OkHPanBvEq9Ve5zigCYJ
        +EgKv/XNi4mklYCQ==
To:     David Woodhouse <dwmw2@infradead.org>, x86@kernel.org,
        Marc Zyngier <maz@kernel.org>
Cc:     kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] x86/kvm: Add KVM_FEATURE_MSI_EXT_DEST_ID
In-Reply-To: <87zh4qo4o5.fsf@nanos.tec.linutronix.de>
References: <803bb6b2212e65c568c84ff6882c2aa8a0ee03d5.camel@infradead.org>
 <20201007122046.1113577-1-dwmw2@infradead.org>
 <20201007122046.1113577-5-dwmw2@infradead.org>
 <87blhcx6qz.fsf@nanos.tec.linutronix.de>
 <f27b17cf4ab64fdb4f14a056bd8c6a93795d9a85.camel@infradead.org>
 <95625dfce360756b99641c31212634c1bf80a69a.camel@infradead.org>
 <87362owhcb.fsf@nanos.tec.linutronix.de>
 <c6f21628733cac23fd28679842c20423df2dd423.camel@infradead.org>
 <87tuv4uwmt.fsf@nanos.tec.linutronix.de>
 <958f0d5c9844f94f2ce47a762c5453329b9e737e.camel@infradead.org>
 <874kn2s3ud.fsf@nanos.tec.linutronix.de>
 <0E51DAB1-5973-4226-B127-65D77DC46CB5@infradead.org>
 <87pn5or8k7.fsf@nanos.tec.linutronix.de>
 <F0F0A646-8DBA-4448-933F-993A3335BD59@infradead.org>
 <87ft6jrdpk.fsf@nanos.tec.linutronix.de>
 <25c54f8e5da1fd5cf3b01ad2fdc1640c5d86baa1.camel@infradead.org>
 <87362jqoh3.fsf@nanos.tec.linutronix.de>
 <1abc2a34c894c32eb474a868671577f6991579df.camel@infradead.org>
 <87eem3ozxd.fsf@nanos.tec.linutronix.de>
 <0de733f6384874d68afba2606119d0d9b1e8b34e.camel@infradead.org>
 <87zh4qo4o5.fsf@nanos.tec.linutronix.de>
Date:   Tue, 13 Oct 2020 12:46:56 +0200
Message-ID: <87wnzuo127.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 13 2020 at 11:28, Thomas Gleixner wrote:
> On Tue, Oct 13 2020 at 08:52, David Woodhouse wrote:
>> On Tue, 2020-10-13 at 00:13 +0200, Thomas Gleixner wrote:
>> +       dom = irq_find_matching_fwspec(fwspec, DOMAIN_BUS_IR);
>> +       if (dom)
>> +               return IS_ERR(dom) ? NULL : dom;
>> +
>> +       return x86_vector_domain;
>> +}
>>
>> Ick. There's no need for that.
>>
>> Eliminating that awful "if not found then slip the x86_vector_domain in
>> as a special case" was the whole *point* of using
>> irq_find_matching_fwspec() in the first place.
>
> The point was to get rid of irq_remapping_get_irq_domain().
>
> And TBH,
>
>         if (apicid_valid(32768))
>
> is just another way to slip the vector domain in. It's just differently
> awful.
>
> Having an explicit answer from the search for IR:
>
>     - Here is the domain
>     - Your device is not registered properly
>     - IR not enabled or not supported
>
> is way more obvious than the above disguised is_remapping_enabled()
> check.

And after becoming more awake, that wont work anyway because there is
more than one IR domain, so there is no way to return an error "You
forgot to register" obviously.

But the APIC id (32768) valid check is also broken because IR can be
enabled even without X2APIC.

Thanks,

        tglx
