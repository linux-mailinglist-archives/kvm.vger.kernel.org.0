Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6E50482C5D
	for <lists+kvm@lfdr.de>; Sun,  2 Jan 2022 18:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbiABRb7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 2 Jan 2022 12:31:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:22981 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229529AbiABRb7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 2 Jan 2022 12:31:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641144718;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xx53ITjWAFhyNMijkvxtQDoUWUdkY09dXfOKBGXfymQ=;
        b=Ko7VExloArW8w60lthNj0G3A1U1sENa6GrXOsafDYgofxBqbhKJ3WRDWYMzubg/ASo+tPr
        M4IJjEKYcSoCdmopGl+o4UpnNo3MhZl3bTlt+2RBSmrsAA+X1glA0SxJMVbWNWViSvIaKr
        xrDY1aOqt/sRVvRLj2Lbv0ofH4Z9dcg=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-295-okt6zHqYNBWTXfAx4imjZw-1; Sun, 02 Jan 2022 12:31:57 -0500
X-MC-Unique: okt6zHqYNBWTXfAx4imjZw-1
Received: by mail-ed1-f70.google.com with SMTP id ay24-20020a056402203800b003f8491e499eso21487784edb.21
        for <kvm@vger.kernel.org>; Sun, 02 Jan 2022 09:31:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Xx53ITjWAFhyNMijkvxtQDoUWUdkY09dXfOKBGXfymQ=;
        b=cVVfpVCDwlOEFcw9UB+1TKy8VajJ7D7uBz5Y2SzSC6QJtAqVTLdFtq7YAU8/WcBsla
         YbCTZFIIeplCo+e9QC2ZrrsG+XVsfT3LUOpPKUda0H0ZXupXX/QeBiR0WuKZJGPdop0x
         tn5+tA7BUE/p6Jjv6xbkaWKacPXLo37IX8T0tsuw+/Kwvokebxay3DFT5ymvFz7cJ8qz
         H6Te0pnZzhnrH+AvN3cjcC+ZN0q9raagn5UYrdtbfH3WGLa1wYXUd/Rl0VAwrUCfwY35
         ko2DwbAJrW8j3p0UuTh0dPAK5V0+7zP7/m+2aW8B4vGfyz8Znpusubqmz4UeC6l1vm3L
         4gvg==
X-Gm-Message-State: AOAM532Fs6QLr5xKwOSW/ZZ5ypLnp1PHsMHfQHy3RV/0A4xItvaH4lkm
        Vv30XlJ6Y2uMeU0P1MrGUWHhyJUhAkwzVOJQW6KcxAvOP1CElAmTqw61WebWICRiQ7EpJrMHdHB
        +vVTMyR1GD37g
X-Received: by 2002:a17:906:3e09:: with SMTP id k9mr35418896eji.104.1641144716131;
        Sun, 02 Jan 2022 09:31:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzEQrTX0mLlJOs6HtUvWNyvJ5ZzPfG+dPZnuAx1kq+NyBboQlJA1+kSzghmTAFrtlhkLZLi8w==
X-Received: by 2002:a17:906:3e09:: with SMTP id k9mr35418885eji.104.1641144715920;
        Sun, 02 Jan 2022 09:31:55 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id o10sm5093507ejm.127.2022.01.02.09.31.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Jan 2022 09:31:55 -0800 (PST)
Message-ID: <61325b2b-dc93-5db2-2d0a-dd0900d947f2@redhat.com>
Date:   Sun, 2 Jan 2022 18:31:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 2/2] KVM: x86: Forbid KVM_SET_CPUID{,2} after KVM_RUN
Content-Language: en-US
To:     Igor Mammedov <imammedo@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
References: <20211122175818.608220-1-vkuznets@redhat.com>
 <20211122175818.608220-3-vkuznets@redhat.com>
 <16368a89-99ea-e52c-47b6-bd006933ec1f@redhat.com>
 <20211227183253.45a03ca2@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211227183253.45a03ca2@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/27/21 18:32, Igor Mammedov wrote:
>> Tweaked and queued nevertheless, thanks.
> it seems this patch breaks VCPU hotplug, in scenario:
> 
>    1. hotunplug existing VCPU (QEMU stores VCPU file descriptor in parked cpus list)
>    2. hotplug it again (unsuspecting QEMU reuses stored file descriptor when recreating VCPU)
> 
> RHBZ:https://bugzilla.redhat.com/show_bug.cgi?id=2028337#c11
> 

The fix here would be (in QEMU) to not call KVM_SET_CPUID2 again. 
However, we need to work around it in KVM, and allow KVM_SET_CPUID2 if 
the data passed to the ioctl is the same that was set before.

Paolo

