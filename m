Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77CDB1D21B1
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 00:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730124AbgEMWFf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 18:05:35 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:44407 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730064AbgEMWFd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 May 2020 18:05:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589407532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pudxRAJGPX6gmBUPiP6A4BRweE0G4VayWPL9/a26Po4=;
        b=QKh/jrZIMX5fqA2g3GUBNVr5/Y4Kta+BEcvg4i28cghuFnETh+Kk3A2A1Gzu+qPUJkcZyI
        HxVGhEWugzmRd3F1C+wvrmE77Ak+TqtBEo76qTnwBtwUBn++b+poF+UknRvYPi+YlmwOpx
        /RbBNQgKt0rmBCdqitU3H6mVMZUvD9E=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-496-1GbfhlhoNtqozmED3m_Ysg-1; Wed, 13 May 2020 18:05:26 -0400
X-MC-Unique: 1GbfhlhoNtqozmED3m_Ysg-1
Received: by mail-wm1-f70.google.com with SMTP id a67so6188893wme.6
        for <kvm@vger.kernel.org>; Wed, 13 May 2020 15:05:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pudxRAJGPX6gmBUPiP6A4BRweE0G4VayWPL9/a26Po4=;
        b=e1sAoIpDkdoIYwmd7Sl/0vIIDMKVom1CYQXefqXGaQTnok5232VY0F/04g5+A+YLwy
         NiJxXU2F4V3PkmqUI9yrbojU2tnFK32mK1607xb6rE5T1/xgqSrudYWO3LYli7mpIktC
         +qOGcYkOda3FyOE59C1tbjd0Q2hQQYdDOoT6tIAMpQjrzp8A+wRq8mHVot4ZbV+vY+R6
         o/PjvEQTnk+eP/DbgOgBB4QZxr7Uzikamj9XRGc1OgbeYqNBaqpmZ8XFMiXEvXOpzmG3
         1n4s5Gnrgs/+B1lqrkEbQQaOpvxPM8Pq9LuiE26o6ju2kVT1XDpt0Kco/tQCut58wHdg
         CYLA==
X-Gm-Message-State: AOAM530ERDeS/B40X1Gk91eLQjzCzkJyEGWTVRcLoDqmTAVdAG299jJH
        jZj7vc5Ox/6ghli+X27pbTW2P9B/ofShzQC0qfTuHtD5HSWC6WKFizkYSwklIWWOUeRUgbVPXwP
        0F9aWdMkt2M5F
X-Received: by 2002:adf:ed8d:: with SMTP id c13mr1661568wro.154.1589407525526;
        Wed, 13 May 2020 15:05:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxWP7EaC2p0c0AIm6fYnEKM1JvyywpgfkI/IAPJxHvXme5J70f9z9fhiuiKRXBZqyW6eCYSCA==
X-Received: by 2002:adf:ed8d:: with SMTP id c13mr1661548wro.154.1589407525207;
        Wed, 13 May 2020 15:05:25 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:fc:9bb8:fff5:45b2? ([2001:b07:6468:f312:fc:9bb8:fff5:45b2])
        by smtp.gmail.com with ESMTPSA id d13sm37213488wmb.39.2020.05.13.15.05.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2020 15:05:24 -0700 (PDT)
Subject: Re: [RFC PATCH] KVM: Add module for IRQ forwarding
To:     Micah Morton <mortonm@chromium.org>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        jmattson@google.com
References: <20200511220046.120206-1-mortonm@chromium.org>
 <20200512111440.15caaca2@w520.home>
 <92fd66eb-68e7-596f-7dd1-f1c190833be4@redhat.com>
 <20200513083401.11e761a7@x1.home>
 <8c0bfeb7-0d08-db74-3a23-7a850f301a2a@redhat.com>
 <CAJ-EccPjU0Lh5gEnr0L9AhuuJTad1yHX-BzzWq21m+e-vY-ELA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0fdb5d54-e4d6-8f2f-69fe-1b157999d6cd@redhat.com>
Date:   Thu, 14 May 2020 00:05:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CAJ-EccPjU0Lh5gEnr0L9AhuuJTad1yHX-BzzWq21m+e-vY-ELA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/05/20 21:10, Micah Morton wrote:
> * If we only care about the bus controller existing (in an emulated
> fashion) enough for the guest to discover the device in question, this
> could work. I’m concerned that power management could be an issue here
> however. For instance, I have a touchscreen device assigned to the
> guest (irq forwarding done with this module) that in response to the
> screen being touched prepares the i2c controller for a transaction by
> calling into the PM system which end up writing to the PCI config
> space** (here https://elixir.bootlin.com/linux/v5.6.12/source/drivers/i2c/busses/i2c-designware-master.c#L435).
> It seems like this kind of scenario expands the scope of what would
> need to be supported by the emulated i2c controller, which is less
> ideal. The way I have it currently working, vfio-pci emulates the PCI
> config space so the guest can do power management by accessing that
> space.

This wouldn't be a problem.  When the emulated i2c controller starts a
transaction on th edevice, it will be performed by the host i2c
controller and this will lead to the same config space write.

I have another question: would it be possible to expose this IRQ through
/dev/i2c-* instead of messing with VFIO?

In fact, adding support for /dev/i2c passthrough to QEMU has long been a
pet idea of mine (my usecase was different though: the idea was to write
programs for a microcontroller on an ARM single board computer and run
them under QEMU in emulation mode).  It's not trivial, because there
could be some impedence mismatch between the guest (which might be
programmed against a low-level controller or might even do bit banging)
and the i2c-dev interface which is more high level.  Also QEMU cannot do
clock stretching right now.  However, it's certainly doable.

>> (Finally, in the past we were doing device assignment tasks within KVM
>> and it was a bad idea.  Anything you want to do within KVM with respect
>> to device assignment, someone else will want to do it from bare metal.
> 
> Are you saying people would want to use this in non-virtualized
> scenarios like running drivers in userspace without any VMM/guest? And
> they could do that if this was part of VFIO and not part of KVM?

Yes, see above for an example.

Paolo

