Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49C2D48E9C8
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 13:25:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241014AbiANMZQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 07:25:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:53553 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234801AbiANMZP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 07:25:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642163114;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hBh0G3PaFCWJV1sufbCQzEoGiZiKhsRfTLAPWCryd98=;
        b=Q8cMp8kl5QMmluEv2feQMUw6WnN5NrLo6YLPZo8ZaqdyASVrjERuSzwE+spOOLc52i2s8h
        feXAKzcBFOAKb3vHiCWWzVa98C8JeUA3yI2JnuSXW71p7t0v0sMdQqOphzkO0wy5+2xWgm
        2TGV4lKxeRi8VL1VWIgPagVnQyfTzyw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-205-EaA7L9DiNqiKA6n6gOFEUg-1; Fri, 14 Jan 2022 07:25:13 -0500
X-MC-Unique: EaA7L9DiNqiKA6n6gOFEUg-1
Received: by mail-wr1-f70.google.com with SMTP id a11-20020adffb8b000000b001a0b0f4afe9so1716190wrr.13
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 04:25:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=hBh0G3PaFCWJV1sufbCQzEoGiZiKhsRfTLAPWCryd98=;
        b=L2XSUy4h6zyHNWI5wYpHUMk8Qzg1C9p2dsi1QEvo22wW1/NVtjkLWckVy7pMCzZGRR
         ilO+VQXUWjYUk3zEl61sYxNlDNCZdEbp/dmmHlR0NOM8Y9zSlusHQuuahyeW/6ddUmZb
         MzjqnoPvpE+av1nWoBjDtmpJAT5/XROK0GJ0G2yt7J8wZVZhHXO+ylngSrsVmDQxBT8k
         HP6m4rXvR8WTqfW+0F9jz+UIMavX+H+CJiqU4wUWgG+6f1FfoYm51obgQDeVVMacijgH
         TMOHZ+VY9fQngCD1cyCVHhrazy4YcLtP47aLfKODDthsOYWjlTNImFc2QOu53bnYRmoU
         nqtQ==
X-Gm-Message-State: AOAM530tpdkB5sTkHSvoKoI/ujZMbNBOvTNmDjJaeI6wPhFdqYWXHJ9g
        cagXhI0DljdkY+MAts9/iUZ6a4v2EqV0fgU76XssvDYxe+PcFQPbfHq4C1TsH/NAbe2LwRfvNI9
        1J8z0HJdMd2Bg
X-Received: by 2002:adf:dfcb:: with SMTP id q11mr8088552wrn.181.1642163112407;
        Fri, 14 Jan 2022 04:25:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJytUF1b2SbzKOsKta4a5pVQxU/2110KFAo5J35XHdXJ85Ys1js7Hdv0X5E6eJ5VN6A5fa2AWw==
X-Received: by 2002:adf:dfcb:: with SMTP id q11mr8088537wrn.181.1642163112185;
        Fri, 14 Jan 2022 04:25:12 -0800 (PST)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id g2sm5042986wro.41.2022.01.14.04.25.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 04:25:11 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Igor Mammedov <imammedo@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 2/2] KVM: x86: Forbid KVM_SET_CPUID{,2} after KVM_RUN
In-Reply-To: <20220114122237.54fa8c91@redhat.com>
References: <20211122175818.608220-1-vkuznets@redhat.com>
 <20211122175818.608220-3-vkuznets@redhat.com>
 <16368a89-99ea-e52c-47b6-bd006933ec1f@redhat.com>
 <20211227183253.45a03ca2@redhat.com>
 <61325b2b-dc93-5db2-2d0a-dd0900d947f2@redhat.com>
 <87mtkdqm7m.fsf@redhat.com> <20220103104057.4dcf7948@redhat.com>
 <YeCowpPBEHC6GJ59@google.com> <20220114095535.0f498707@redhat.com>
 <87ilummznd.fsf@redhat.com> <20220114122237.54fa8c91@redhat.com>
Date:   Fri, 14 Jan 2022 13:25:10 +0100
Message-ID: <87ee5amrmh.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Igor Mammedov <imammedo@redhat.com> writes:

> On Fri, 14 Jan 2022 10:31:50 +0100
> Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
>> Igor Mammedov <imammedo@redhat.com> writes:
>> 
>> 
>> > However, a problem of failing KVM_SET_CPUID2 during VCPU re-plug
>> > is still there and re-plug will fail if KVM rejects repeated KVM_SET_CPUID2
>> > even if ioctl called with exactly the same CPUID leafs as the 1st call.
>> >  
>> 
>> Assuming APIC id change doesn not need to be supported, I can send v2
>> here with an empty allowlist.
> As you mentioned in another thread black list would be better
> to address Sean's concerns or just revert problematic commit.
>

Personally, I'm leaning towards the blocklist approach even if just for
'documenting' the fact that KVM doesn't correctly handle the
change. Compared to a comment in the code, such approach could help
someone save tons of debugging time (if anyone ever decides do something
weird, like changing MAXPHYADDR on the fly).

-- 
Vitaly

