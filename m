Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A93DA2928A5
	for <lists+kvm@lfdr.de>; Mon, 19 Oct 2020 15:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728846AbgJSNzg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Oct 2020 09:55:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32382 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728822AbgJSNzg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 19 Oct 2020 09:55:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603115735;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aA0jzX7tNzrOCsglzpY68FA44pdLyDgBMIHShZjPs74=;
        b=Xk6We0TiSrGq+Uwl4IMsnlabjNnyl0GuSVgvFw8WiPWYXoAIELkzuU9tnf8CTVFcbVVmvT
        Axyxe7RP7K5cerY9SDzmcXAm7a/lqJr0jELIb64EbeR45Le5M1m6Gq5vbGVwQ4WRjva2B8
        Hj/VIWVd1YzTe3PKNuubZPIT9mB/rE0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-169-wBb9Pjh9PBWhWY5htjGIOQ-1; Mon, 19 Oct 2020 09:55:33 -0400
X-MC-Unique: wBb9Pjh9PBWhWY5htjGIOQ-1
Received: by mail-wr1-f72.google.com with SMTP id 31so7423618wrg.12
        for <kvm@vger.kernel.org>; Mon, 19 Oct 2020 06:55:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aA0jzX7tNzrOCsglzpY68FA44pdLyDgBMIHShZjPs74=;
        b=W7b8QIlvHfh/bWVCdDH58q0nkHnH72klvVAUnfKIil4bzxePcI3cSjNPUsdqxwJjWu
         hykum/toIg7w5KGuq6uVpmw3jhyPWL9Qb8TiKPXar6++j1ipfv0vXgmYXNPBVJJhszQj
         TLopAoeesmE1WeMvReIBa58AqWNUVu2wYJEi8MyFpRlv+Asuqs6xs42vnB3a/S8FkhhK
         MwJsj3YxEqQfbMbm1r/WWVB6Sw9LMawZG0ugTL8oVDsEQqPX9E9jMLXareUip24cVZ/I
         dfd146zbnCyqq5ES8I8Z5+OEypTVHoYNh8JK2HIVhfuj2ZoES4ZNOKXLnb/JR4F/nggX
         +BqQ==
X-Gm-Message-State: AOAM531eKCd/5dXc+MtcihGXUbYwhOGwBFXvC5+Bt/Zyv++rNZ+hbYaN
        wnv+84LhPU6PSJp8kJjOrPs3u7XPrudOsJj4U/PiHbiWatUi8F/JX+uQ+GiW1daBsFIFJGctPLh
        hzOeOzn0S2wWz
X-Received: by 2002:adf:f10e:: with SMTP id r14mr18970887wro.337.1603115732134;
        Mon, 19 Oct 2020 06:55:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxThESsJoi239e9/wo4+PpzQyWs7tEmNFUk8fsE0BzcnY7xEuDvrNLTIUXfAXGRSux2+9+wJg==
X-Received: by 2002:adf:f10e:: with SMTP id r14mr18970872wro.337.1603115731912;
        Mon, 19 Oct 2020 06:55:31 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id e11sm13243853wrj.75.2020.10.19.06.55.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Oct 2020 06:55:31 -0700 (PDT)
Subject: Re: [PATCH] target/i386: Support up to 32768 CPUs without IRQ
 remapping
To:     David Woodhouse <dwmw2@infradead.org>,
        qemu-devel <qemu-devel@nongnu.org>
Cc:     x86 <x86@kernel.org>, kvm <kvm@vger.kernel.org>
References: <78097f9218300e63e751e077a0a5ca029b56ba46.camel@infradead.org>
 <6f8704bf-f832-9fcc-5d98-d8e8b562fe2f@redhat.com>
 <698c8ab6783a3113d90d8435d07a2dce6a2e2ec9.camel@infradead.org>
 <7b9c8ca4-e89e-e140-d591-76dcb2cad485@redhat.com>
 <c337e15dec18e291399b294823dccbdb63976a38.camel@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4d820db0-be0d-d47d-7a8a-874fb481a2ce@redhat.com>
Date:   Mon, 19 Oct 2020 15:55:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <c337e15dec18e291399b294823dccbdb63976a38.camel@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/10/20 14:21, David Woodhouse wrote:
> On Thu, 2020-10-08 at 09:53 +0200, Paolo Bonzini wrote:
>> I think you're not
>> handling that correctly for CPUs >255, so after all we _do_ need some
>> kernel support.
> 
> I think that works out OK.
> 
> In QEMU's ioapic_update_kvm_routes() it calls ioapic_entry_parse()
> which generates the actual "bus" MSI with the extended dest ID in bits
> 11-5 of the address.
> 
> That MSI message is passed to kvm_irqchip_update_msi_route() which
> passes it through translation —  which does interrupt remapping and
> shifting the ext bits up into ->address_hi as the KVM X2APIC API
> expects.
> 
> So when the kernel's kvm_scan_ioapic_routes() goes looking,
> kvm_set_msi_irq() fills 'irq' in with the correct dest_id, and
> kvm_apic_match_dest() does the right thing.
> 
> No?

Yeah, that seems fine.

> As far as I can tell, we *do* have a QEMU bug — not related to the ext
> dest ID — because for MSIs of assigned devices we don't update the KVM
> IRQ routing table when the Interrupt Remapping IEC cache is flushed.

> So... it'll hit the tip.git tree and thus linux-next as soon as Linus
> releases 5.10-rc1, and it'll then get merged into 5.11-rc1 and be in
> the 5.11 release.
> 
> At which of those three points in time would you be happy to merge it
> to QEMU? If it's either of the latter two, maybe it *is* worth doing a
> patch which *only* reserves the feature bit, and trying to slip it into
> 5.10?

It would be 5.11-rc1 because of the KVM_FEATURE_MSI_EXT_DEST_ID
definition which would not be in your patch but rather synchronized from
the Linux tree by scripts/update-linux-headers.sh.

If you send me the doc patch any time before 5.10-rc7, it will be in 5.10.

Paolo

