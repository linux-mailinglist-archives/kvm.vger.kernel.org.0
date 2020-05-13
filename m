Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD4F71D0965
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 09:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729752AbgEMHCX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 03:02:23 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:24324 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726020AbgEMHCX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 May 2020 03:02:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589353341;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J7KRmwRXIbgjEW7YYzqTesjvyTFc2bLYn5qkibqp0SQ=;
        b=aAL+KSyNclzye2m/IAZf3/WhzFjefnpLOB/CR9TcBDtp5RAxfQ4ZR7A1UMlq3fPJg09uYC
        GPOEqZCdMPPYtGqJY9h4JmEtkE96+1XXkAB3Yrgx1y+cjKl96LqWdReGlkLc3oOeYlu/DO
        6zbIzqJdIi7OAEfyTLgY1po9R/6+JaU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-453-GNunHl55ND6JNnK-ZUgNiw-1; Wed, 13 May 2020 03:02:19 -0400
X-MC-Unique: GNunHl55ND6JNnK-ZUgNiw-1
Received: by mail-wr1-f71.google.com with SMTP id 90so8105046wrg.23
        for <kvm@vger.kernel.org>; Wed, 13 May 2020 00:02:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=J7KRmwRXIbgjEW7YYzqTesjvyTFc2bLYn5qkibqp0SQ=;
        b=U55OdzSs+dS2MUMqmK65BZDKkNpgXvb/x3dDPjWaxYrPB8HEe6+D7/hTayyDWZRwPG
         EfBteEM2fVHtSHQ66AXu4XLQqxbGMIIRoTrArKiM5KgUQ9SA6MGmVxIrJ41nkEGIrU+/
         9bupzqWaLZkZZWo1+V1ThOw+kEeiA7ikypEjJHX8OBa/eNzBYllqstjl3l0ZA9DjVOcG
         BCrOPvhhsh/K3TMrvgCNMmbiFHAW2W+6+PxGNU4gJ2iO+T55/kJ85yUPAiCj+XTw8+5D
         rk45euriZ1D7pUg2c7o7ZNFsPPO5Cl+Ib0IynrQptTdzrpT4w9ah66GnWnS5Kf+f88aU
         eMQQ==
X-Gm-Message-State: AGi0PuaCissB/tx3bV25mzv7ytsNhRb61JNFPmTtxT4jYbs+ucENCZrB
        2lCULMA+RdnC6lVu7nlLh3nCuYLLmT34TapOkN+oHPwzCq4LEB3MS5oqNPBUWNxcb5TE5YXCS/Q
        umarnDK2w8dzr
X-Received: by 2002:a05:6000:1105:: with SMTP id z5mr29744520wrw.208.1589353338075;
        Wed, 13 May 2020 00:02:18 -0700 (PDT)
X-Google-Smtp-Source: APiQypJtT0Yn7zIjIaBr1dfYuf9o2ntG3X2Z9YB/iU+MY4Bn8o/7ChhIfw7X2yPFvSYYRrbB5lt5tw==
X-Received: by 2002:a05:6000:1105:: with SMTP id z5mr29744501wrw.208.1589353337822;
        Wed, 13 May 2020 00:02:17 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:6ced:5227:72a1:6b78? ([2001:b07:6468:f312:6ced:5227:72a1:6b78])
        by smtp.gmail.com with ESMTPSA id n9sm19173402wru.90.2020.05.13.00.02.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2020 00:02:17 -0700 (PDT)
Subject: Re: [RFC PATCH] KVM: Add module for IRQ forwarding
To:     Alex Williamson <alex.williamson@redhat.com>,
        Micah Morton <mortonm@chromium.org>
Cc:     kvm@vger.kernel.org, jmattson@google.com
References: <20200511220046.120206-1-mortonm@chromium.org>
 <20200512111440.15caaca2@w520.home>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <92fd66eb-68e7-596f-7dd1-f1c190833be4@redhat.com>
Date:   Wed, 13 May 2020 09:02:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200512111440.15caaca2@w520.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/05/20 19:14, Alex Williamson wrote:
> But why not assign the individual platform devices via vfio-platform
> rather than assign the i2c controller via vfio-pci and then assembling
> the interrupts from those sub-devices with this ad-hoc interface?  An
> emulated i2c controller in the guest could provide the same discovery
> mechanism as is available in the host.

I agree.  I read the whole discussion, but I still don't understand why
this is not using vfio-platform.

Alternatively, if you assign the i2c controller, I don't understand why
the guest doesn't discover interrupts on its own.  Of course you need to
tell the guest about the devices in the ACPI tables, but why is this new
concept necessary?

(Finally, in the past we were doing device assignment tasks within KVM
and it was a bad idea.  Anything you want to do within KVM with respect
to device assignment, someone else will want to do it from bare metal.
virt/lib/irqbypass.c is a special case because it's an IOMMU feature
that is designed to work in concert with VMX posted interrupts and SVM
AVIC, so in guest mode only).

Paolo

