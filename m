Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02C9A1D3FD7
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 23:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727777AbgENVRf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 17:17:35 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46865 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726027AbgENVRf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 17:17:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589491053;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rTyJ9EfkIQ5Fgx9dMoJiOVLyFSNRnN5iUonulkVQTmQ=;
        b=dLNqHXhAPQWY8LHoBjCU4jmouwpmFUTFgIJRq3Aac2wo6LmU5IA6eXmRUUTShpkGl/pwpy
        bdcIxuvJKuPahdmzS+2025btHnhsvp0R7a7Vc8frKyRvb9V9v1ODMkFDm66eta0Uivu4I0
        NqPccDl/2XtmzBesJ/a4OCD8AExres0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-10-G4yM1MFsNVm7KtUAC1NgzA-1; Thu, 14 May 2020 17:17:32 -0400
X-MC-Unique: G4yM1MFsNVm7KtUAC1NgzA-1
Received: by mail-wr1-f69.google.com with SMTP id 90so41440wrg.23
        for <kvm@vger.kernel.org>; Thu, 14 May 2020 14:17:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rTyJ9EfkIQ5Fgx9dMoJiOVLyFSNRnN5iUonulkVQTmQ=;
        b=tAtbyoxhS6FqXMstNKx6bR1hTew35t2ssy4ejMniiWuJZV0QFNNpqm+6LXpwq22/ZK
         rSvwFlIvHPn+MpwM6e3ovwMrcNU0moy4JNRZ9ib2eEdluZ3whb3Hqmgrj22kivHjuQog
         OJMpOu4GLcgyjjJqopEKpvcxsv9zIuofz6gNEusC4WXZmf7gDk9t+nZnHhvbpxUr3VLu
         Qbm4YHHKCo1BB5NdSpY49OM/l1SsY4QwyeXRsuJNGxonPsUHLu8VMJt5LUQYKWiYrL3H
         GT4V1N40b16wpjdycWhlkTKPnhJkGV4zbEnlgdXhSMZK/T4D6r1XukB6IZVg+0My1dc1
         VRpQ==
X-Gm-Message-State: AOAM533oFahkqBXmqxWs2hqD2YOVP2oLs4kMRBgLznwBBoRVhTpImXio
        TmlbPhqnbQ57FYuhtelyr2aIcoeJwSTXyuIMBmqX9ZHglpTjOr4ehP+elSFS3lD2Hi4wvKDobiz
        TCPvYfrV1PuWQ
X-Received: by 2002:adf:82c1:: with SMTP id 59mr355460wrc.377.1589491050989;
        Thu, 14 May 2020 14:17:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxi0teq9r39kCA3vrZqGGaNR8WRAo0xPpomi+j9opFrTWhGhKrVSrcgRhHupp/F8cV+SmHIBg==
X-Received: by 2002:adf:82c1:: with SMTP id 59mr355438wrc.377.1589491050754;
        Thu, 14 May 2020 14:17:30 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:bdd8:ac77:1ff4:62c6? ([2001:b07:6468:f312:bdd8:ac77:1ff4:62c6])
        by smtp.gmail.com with ESMTPSA id y3sm266623wrt.87.2020.05.14.14.17.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 May 2020 14:17:30 -0700 (PDT)
Subject: Re: [RFC PATCH] KVM: Add module for IRQ forwarding
To:     Micah Morton <mortonm@chromium.org>,
        Auger Eric <eric.auger@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        jmattson@google.com
References: <20200511220046.120206-1-mortonm@chromium.org>
 <20200512111440.15caaca2@w520.home>
 <92fd66eb-68e7-596f-7dd1-f1c190833be4@redhat.com>
 <20200513083401.11e761a7@x1.home>
 <8c0bfeb7-0d08-db74-3a23-7a850f301a2a@redhat.com>
 <CAJ-EccPjU0Lh5gEnr0L9AhuuJTad1yHX-BzzWq21m+e-vY-ELA@mail.gmail.com>
 <0fdb5d54-e4d6-8f2f-69fe-1b157999d6cd@redhat.com>
 <CAJ-EccP6GNmyCGJZFfXUo2_8KEN_sJZ3=88f+3E-8SJ=JT8Pcg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9d5d7eec-77dd-bca9-949f-8f39fcd7d8d7@redhat.com>
Date:   Thu, 14 May 2020 23:17:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CAJ-EccP6GNmyCGJZFfXUo2_8KEN_sJZ3=88f+3E-8SJ=JT8Pcg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/05/20 19:44, Micah Morton wrote:
> I realize this may seem like an over-use of VFIO, but I'm actually
> coming from the angle of wanting to assign _most_ of the important
> hardware on my device to a VM guest, and I'm looking to avoid
> emulation wherever possible. Of course there will be devices like the
> IOAPIC for which emulation is unavoidable, but I think emulation is
> avoidable here for the busses we've mentioned if there is a way to
> forward arbitrary interrupts into the guest.
> 
> Since all these use cases are so close to working with vfio-pci right
> out of the box, I was really hoping to come up with a simple and
> generic solution to the arbitrary interrupt problem that can be used
> for multiple bus types.

I shall defer to Alex on this, but I think the main issue here is that
these interrupts are not visible to Linux as pertaining to the pci-stub
device.  Is this correct?

Paolo

