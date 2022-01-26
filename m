Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB6B649C707
	for <lists+kvm@lfdr.de>; Wed, 26 Jan 2022 11:04:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239563AbiAZKEA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 05:04:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32358 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233188AbiAZKD7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 Jan 2022 05:03:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643191439;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XrFLYJ9cry+WM5T0ZEL1s3Cr9YcXnG7PMN9SDbX6/ww=;
        b=OOK0kTTiqqPmQM2ACobTrTs3ejLh1gCFFy0tTBMNssqoDQEh7g/ig4mXcQcM7SH0OyXTl1
        q7p4e86VzU4wVIvz9yWwKrsWEND/R7uBQ8jytmngBEfT5tT44/kfjobrMDQodJscFZUfOB
        1vIRdp7Pbxwv+I2rXz7eHVVLUkR4CeI=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-298-9TeAOIgaNPyq7PTYMoJnNw-1; Wed, 26 Jan 2022 05:03:57 -0500
X-MC-Unique: 9TeAOIgaNPyq7PTYMoJnNw-1
Received: by mail-ej1-f69.google.com with SMTP id 13-20020a170906328d00b006982d0888a4so4627409ejw.9
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 02:03:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=XrFLYJ9cry+WM5T0ZEL1s3Cr9YcXnG7PMN9SDbX6/ww=;
        b=T2CgsqzPndtnvG3txjkllTfFLpfsry42K3YfhVACpeqHCDmmCh0c5QDlgnUqgwgqbP
         Abi9LgcsCRM/yY3mhOn5Hvuj8amsne5149Wxaq5oQ4/TP5OMJNJ8Z80RDEQPc0jvp3jq
         Ek3z2npI0GDjiAYhjv4CrE7IQNLI33/IMy+wQGK2oYfbpT9JPH7bTEgwfh6Kr9MugQCc
         CN01JZR7c/+DBIYjIowzj6H9qYEguiHNk3OGULbm7Oame1zWu4GFRQpld4Vp8aV3du1j
         o9ZdnaGHa/O9xtWRDDNj69wrJiLru39c9z2i2ocY/bJgi8onh7juiyjzIzaVTSwwRb9J
         o9UA==
X-Gm-Message-State: AOAM531d/g66snH6HB+d36iKq1zrwh3tLQSBymyVnNcPEfSGV7AWgEVV
        KYBI45dm2Y2BLH8c8O8uSmd7wtn4M6Yt8DxKHBkMH709fvzrQw4Hm8Tm8OPZOsgnjtrV/DNUs/V
        nBVDL7Vma9JBI
X-Received: by 2002:a17:906:cc84:: with SMTP id oq4mr20750939ejb.736.1643191436681;
        Wed, 26 Jan 2022 02:03:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyRQ+0XLF4POUmxWH8EJJr77JEz8GW0+2DZNmA1meDp2yb7dCZHSIEtz1s7LpmPIel02UXIsg==
X-Received: by 2002:a17:906:cc84:: with SMTP id oq4mr20750919ejb.736.1643191436473;
        Wed, 26 Jan 2022 02:03:56 -0800 (PST)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id rv9sm7151085ejb.216.2022.01.26.02.03.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 02:03:55 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Joe Perches <joe@perches.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 2/2] KVM: x86: Use memcmp in kvm_cpuid_check_equal()
In-Reply-To: <864dfbfdc44e288e99cf7baa3aa8f7c8568db507.camel@perches.com>
References: <20220124103606.2630588-1-vkuznets@redhat.com>
 <20220124103606.2630588-3-vkuznets@redhat.com>
 <864dfbfdc44e288e99cf7baa3aa8f7c8568db507.camel@perches.com>
Date:   Wed, 26 Jan 2022 11:03:54 +0100
Message-ID: <878rv2izjp.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Joe Perches <joe@perches.com> writes:

> On Mon, 2022-01-24 at 11:36 +0100, Vitaly Kuznetsov wrote:
>> kvm_cpuid_check_equal() should also check .flags equality but instead
>> of adding it to the existing check, just switch to using memcmp() for
>> the whole 'struct kvm_cpuid_entry2'.
>
> Is the struct padding guaranteed to be identical ?
>

Well, yes (or we're all doomeed):
- 'struct kvm_cpuid_entry2' is part of KVM userspace ABI, it is supposed
to be stable.
- Here we compare structs which come from the same userspace during one
session (vCPU fd stays open), I can't imagine how structure layout can
change on-the-fly.

-- 
Vitaly

