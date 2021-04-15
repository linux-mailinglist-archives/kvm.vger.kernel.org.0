Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78313360F0E
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 17:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233704AbhDOPdq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 11:33:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24238 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233389AbhDOPdp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 15 Apr 2021 11:33:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618500801;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PFoMUqnt3mOjMRdu3Djb36BE1EcblkSzBE9itczAV+o=;
        b=gYvlmp6seeRBWhXOGShXgS54c3SQXyBrC2kA+iEK6GwaZzilUHo3J2cS6sT4/mqIyNFdPX
        x/2mUHNIWt1BCxmPouIXPUqfpnhL5bEja8CeL7JbENLPRhgBquWmoBIprIlhAv5kYLr1tZ
        ORTWxel6Tqypv7qru1SMq/Dacu55kwc=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-11-cLlp5jz5OwWkOi_aqJ34Kg-1; Thu, 15 Apr 2021 11:33:19 -0400
X-MC-Unique: cLlp5jz5OwWkOi_aqJ34Kg-1
Received: by mail-ej1-f69.google.com with SMTP id ho12-20020a1709070e8cb029037000abbb92so1075038ejc.2
        for <kvm@vger.kernel.org>; Thu, 15 Apr 2021 08:33:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=PFoMUqnt3mOjMRdu3Djb36BE1EcblkSzBE9itczAV+o=;
        b=AZlDEiVOxDyRBSNLKwOiOhJkMeSMxeYvwHq/GTWJ7j0qcbY50DtxhSLxdwgYUk3mAY
         AUDkZadzlucqDTYOmxADBBp1MDamJG4Dt46uL9eE9jxaHRkD1gL4b5I0SkbG2XcBuxEG
         MGuYiIwyGQdTxfGWAxX/d6GEejEidaPvqGXYIXdW6iJwUd0W8VYHo/MbUCcak5eYsTYG
         U3iFUSxqQogMfjwksvMkknzTi/J/FLBkqhzYIURXfVABwmzdStW97zfmfUaLycyq0qIN
         C6qs6vV3Lx+ZaZoJ+IMGWJLWFlK8IKaKgJDZSKZfhzMJS+h+4WL8JLRzkeDntyI6Htuh
         3RPg==
X-Gm-Message-State: AOAM532c0WeaJkUuf+w1weVxFOpuv5KNGxYwzGEglXFXPG0C27y47ZMZ
        Gwl8SYjBW/4HKAmGq3WyXKcbdjUKDF12Ixg387qItzcYAqSPoLrjVCiLsV/XYYtsFoeW542puNs
        fGviwJwDb42L/
X-Received: by 2002:a05:6402:716:: with SMTP id w22mr4922501edx.206.1618500798639;
        Thu, 15 Apr 2021 08:33:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw5dlqpKiMIeMmhJa3cFY+v+vwEa6uAJTB0yWnK6BtDfDPjvCLf8E71Hb7GL1RrJXfQ0gi+Jw==
X-Received: by 2002:a05:6402:716:: with SMTP id w22mr4922473edx.206.1618500798440;
        Thu, 15 Apr 2021 08:33:18 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id w13sm1951107edx.80.2021.04.15.08.33.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 08:33:17 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Wei Liu <wei.liu@kernel.org>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        Wei Liu <wei.liu@kernel.org>
Subject: Re: [PATCH RFC 01/22] asm-generic/hyperv: add
 HV_STATUS_ACCESS_DENIED definition
In-Reply-To: <20210415141403.hftsza3ucrf262tq@liuwe-devbox-debian-v2>
References: <20210413122630.975617-1-vkuznets@redhat.com>
 <20210413122630.975617-2-vkuznets@redhat.com>
 <20210415141403.hftsza3ucrf262tq@liuwe-devbox-debian-v2>
Date:   Thu, 15 Apr 2021 17:33:17 +0200
Message-ID: <877dl38sw2.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wei Liu <wei.liu@kernel.org> writes:

> On Tue, Apr 13, 2021 at 02:26:09PM +0200, Vitaly Kuznetsov wrote:
>> From TLFSv6.0b, this status means: "The caller did not possess sufficient
>> access rights to perform the requested operation."
>> 
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>
> This can be applied to hyperv-next right away. Let me know what you
> think.
>

In case there's no immediate need for this constant outside of KVM, I'd
suggest you just give Paolo your 'Acked-by' so I can carry the patch in
the series for the time being. This will eliminate the need to track
dependencies between hyperv-next and kvm-next.

Thanks!

-- 
Vitaly

