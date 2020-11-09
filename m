Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D15A22AB562
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 11:50:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729049AbgKIKuL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 05:50:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22015 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727183AbgKIKuL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Nov 2020 05:50:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604919010;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1JkKnqwVg26tdRfbOTNiNdCvhxKi+BcdeTFW1kdQQK0=;
        b=PRFeppw+P88Q23mogow9C1QgjwGBuvqUjC5G52NRTROSk0JcuhyyCg+yGJjqJYKgP8Zvu6
        B0koZu2r28RAx3WxNUHSLfsoTvDsLdaMijrpu/MS5Vw+5yBiu0zN3R+i9FIdKaZdZOjiuH
        eb0YENpJzVjDy8LCHVwtTIsOFTEUpwM=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-149-8sebPPJ3OTKktICURC2Kqw-1; Mon, 09 Nov 2020 05:50:05 -0500
X-MC-Unique: 8sebPPJ3OTKktICURC2Kqw-1
Received: by mail-ej1-f71.google.com with SMTP id nt22so3274498ejb.17
        for <kvm@vger.kernel.org>; Mon, 09 Nov 2020 02:50:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1JkKnqwVg26tdRfbOTNiNdCvhxKi+BcdeTFW1kdQQK0=;
        b=ZTf1ZtsQ4Rv30v8BxJWAqf+wWDXxn7EKDiiS66YsV4lcIjYuQonBi9HpYQuxKp0xiQ
         aDwdUbXvBj+EzxoRRrhVOunn8n3l2l1FfzWJ7KNN/1/HcKduIJvvJPJtif+xKY/98KaQ
         Gy4EJTJUth3Y8mr9K2P1aOtosqAAh4OJuOrOjnsxodE6FvPNBsaTyFSIRL+nBMON94Sj
         J7++gwsmCh59cYB+i90CmhjANeM+erjsAd5gdBstqwHZb/HFIMSTKX8HP4VgVc3YzsUv
         t6ZbgIfowwWzPTE3PposlxRa0sl+obsAQGvjHiMvPp8Ec2UGCyO8xrcRuTkln+p0O/m7
         VsNA==
X-Gm-Message-State: AOAM530Q/AmGzFIWltWzs2C2VrbjfaqmvoKnBTLYVZpz+nagpQZMv5cL
        FjrYhDmT1VN2DhPc0cYhc4NPqvjLKDOvePXyEoxP7u4TBfTMeYDxdrfBxoGSBrwtjoF/cnSw1iK
        cyhZfncj2oL5V
X-Received: by 2002:aa7:d8c4:: with SMTP id k4mr12872978eds.248.1604919004325;
        Mon, 09 Nov 2020 02:50:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxj4ZnBg84h5mUpIlStBaF/pAYCu+53RGnsC/exeSfkxuckPXhhLjS5t1Q+tLs1FfD9SaCeFA==
X-Received: by 2002:aa7:d8c4:: with SMTP id k4mr12872973eds.248.1604919004160;
        Mon, 09 Nov 2020 02:50:04 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id e1sm8477571edy.8.2020.11.09.02.50.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2020 02:50:03 -0800 (PST)
Subject: Re: [PATCH 0/3] accel: Remove system-mode stubs from user-mode builds
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Laurent Vivier <laurent@vivier.eu>, kvm@vger.kernel.org
References: <20201109094547.2456385-1-f4bug@amsat.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c5d2bedf-20f7-c5ae-4c64-5ac8e4706949@redhat.com>
Date:   Mon, 9 Nov 2020 11:50:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201109094547.2456385-1-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/11/20 10:45, Philippe Mathieu-Daudé wrote:
> It is pointless to build/link these stubs into user-mode binaries.
> 
> Philippe Mathieu-Daudé (3):
>    accel: Only include TCG stubs in user-mode only builds
>    accel/stubs: Restrict system-mode emulation stubs
>    accel/stubs: Simplify kvm-stub.c
> 
>   accel/stubs/kvm-stub.c  |  5 -----
>   accel/meson.build       | 10 ++++++----
>   accel/stubs/meson.build | 12 ++++++++----
>   3 files changed, 14 insertions(+), 13 deletions(-)
> 

The series makes sense.  It probably also shows that it makes sense to 
have a "specific_softmmu_ss" sourceset in meson.build.  Let's review 
Alex Bennée's patches and then get back to this one.

Paolo

