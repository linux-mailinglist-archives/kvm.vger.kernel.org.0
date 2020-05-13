Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C96B81D193E
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 17:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730465AbgEMPX0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 11:23:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36279 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729153AbgEMPXZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 May 2020 11:23:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589383404;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UehQAJSU4mDjbWE9zipTIpV0MCGuiC5EOgpt98xl5b0=;
        b=ho9p7wXKA0iV+iIUcNXUxXXezSl4AyL5kzb5IBBQHYrnhqPrN6jLdTDw8SHFCU6VXokcel
        PXnqVA/pWpy8UXJ17amTG+Co3+JvUymwlV00cqR6ARd6xX1dzl8wSkUEuQpU+ynjYmuxC2
        Y0+/B4rqEAVzy10qVeVi9TiqJcsQVlI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-484-88kem2QAMumRzRVkF_wWHQ-1; Wed, 13 May 2020 11:23:22 -0400
X-MC-Unique: 88kem2QAMumRzRVkF_wWHQ-1
Received: by mail-wr1-f72.google.com with SMTP id e14so8783733wrv.11
        for <kvm@vger.kernel.org>; Wed, 13 May 2020 08:23:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UehQAJSU4mDjbWE9zipTIpV0MCGuiC5EOgpt98xl5b0=;
        b=r6k3PH1EqQT9vmS2x7Nosn/upBUbu+sK/BgQ1f5vXQavhT1Eo2Ldgszfwh40qIWByp
         arx6UbW8Z/R08EhrP63oQzlgTNiTThaQjvwOAMt6DdKcZJefx4uiRtPt7p1HA2oQs/N1
         edof+f+uNYBlXACeXjj6m8p3aMkSS2t8nifjG9LA4KN+WKBvvYf5YuW8zOW206lFr9Lc
         3ptjWM/LtJ4EjK395E7bZ1vJvIkAQOsore6fIWBMOndwxp8vjPARTmCQQ52Z3Owa3/9t
         98WdLuLY+GU39R+sBM438Z3tyJvQauRTVVTLz4zTrvCqJJx5woA7gCNwSd5Rfc2rxklA
         ymMg==
X-Gm-Message-State: AGi0PuZUwNCqC5TlHkV/Cb5nfrYRQjwJK771jVUGbhExGRk5F8ILDWcM
        fYYAa1hjemJW2RmcvyuI34RsB25jbh7/ti5dWAQnuAh36dtWKlsn+dhyp1/LgYzCS9Ml2qG+McN
        C/3z2w53LtTGM
X-Received: by 2002:a1c:7513:: with SMTP id o19mr40802375wmc.9.1589383401114;
        Wed, 13 May 2020 08:23:21 -0700 (PDT)
X-Google-Smtp-Source: APiQypJnNsE4lazcED4ZrZTKZxFXKV+qBuOssabzx51M4Ar3pCWjJ4eHyqC4bHBx59/+xF2KfaTbyw==
X-Received: by 2002:a1c:7513:: with SMTP id o19mr40802358wmc.9.1589383400867;
        Wed, 13 May 2020 08:23:20 -0700 (PDT)
Received: from [192.168.178.58] ([151.30.85.171])
        by smtp.gmail.com with ESMTPSA id 37sm2024303wrk.61.2020.05.13.08.23.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2020 08:23:20 -0700 (PDT)
Subject: Re: [RFC PATCH] KVM: Add module for IRQ forwarding
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Micah Morton <mortonm@chromium.org>, kvm@vger.kernel.org,
        jmattson@google.com
References: <20200511220046.120206-1-mortonm@chromium.org>
 <20200512111440.15caaca2@w520.home>
 <92fd66eb-68e7-596f-7dd1-f1c190833be4@redhat.com>
 <20200513083401.11e761a7@x1.home>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8c0bfeb7-0d08-db74-3a23-7a850f301a2a@redhat.com>
Date:   Wed, 13 May 2020 17:23:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200513083401.11e761a7@x1.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/05/20 16:34, Alex Williamson wrote:
>> Alternatively, if you assign the i2c controller, I don't understand why
>> the guest doesn't discover interrupts on its own.  Of course you need to
>> tell the guest about the devices in the ACPI tables, but why is this new
>> concept necessary?
>
> the interrupt for this sub-device is unrelated to the PCI
> controller device, it's an entirely arbitrary (from our perspective)
> relationship described via ACPI.

Ok, that's what I was missing.

> We could potentially use device specific interrupts to expose this via
> the controller device, but then vfio-pci needs to learn how to
> essentially become an i2c controller to enumerate the sub-devices and
> collect external dependencies.  This is not an approach I've embraced
> versus the alternative of the host i2c driver claiming the PCI
> controller, enumerating the sub-devices, and binding the resulting
> device, complete with built-in interrupt support via vfio-platform.

I agree that's the way to go.

Perhaps adding arbitrary non-PCI interrupts, i.e. neither INTX nor
MSI(-X), to vfio-pci could be acceptable.  However, the device claim
must claim them, and that seems hard to do when you rebind the PCI
device to pci-stub.

Paolo

