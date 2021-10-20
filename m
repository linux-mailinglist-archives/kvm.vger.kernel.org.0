Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C14C14355A8
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 00:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbhJTWDt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 18:03:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbhJTWDs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 18:03:48 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7409CC06161C
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 15:01:33 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id g125so11374833oif.9
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 15:01:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gcyALk5zVepRZxSWJAVnLRXnay+k2bDPuj2AKrn2YQI=;
        b=JSkGk38iMrIpqwqYDwTm3nxTEQ1S5kwjkCR3dNSEwoysrxgW/3XEDz0CXmhQ+DSBmc
         hbXtvl85lNZmlhJeFiX1aUEC/x0y/Kwmll6/A58osTtQ+LcD2aEf/JUCOUXEPwR5Jw0m
         Mv4tT5L5ClJG8XDP1PtTQeqOe4vq39bUanmuWNGdSj5IXbP82ZT6VXeVpRPMOQPEFdkH
         E/FzWicpW9Jrqnbj1WEOwxcbLPFNRFCG/Atr3ZHpjwhwTqvQL2SC3T9mwS+DntCHqZnk
         JHvnj1o+sJY39xzmOIpRNGGKHZlCM1bpXu8E/RX0ncJJgqp8ei5VhqvTqAKmO5I9vjJQ
         gUPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gcyALk5zVepRZxSWJAVnLRXnay+k2bDPuj2AKrn2YQI=;
        b=BVq+7TXJkHpsgYTrLRHlpT47pqmfgR0j3M5IdEVbu72GWPJ/bHUea/pmnfNhsYxf6x
         wZNsjAtLX3KZ7ulQ5RueysZYC/mQFI2Xkq8fJRaHtNFshnjMTLoPqnvMniI7DYTXxY/X
         fAPjxoCVRso3gBJWsS6R2dE/BAedoZGYt2UJf6O1vm9FhFrjOL7xkCurkZuYwBUftJhm
         ponK894f4ejN4o3p8ySvt8yfw42NosHYQnjIfeoDufJyBU0s25GTFsHNuuxlYxmGd9em
         WQqklXM53keXBT+p+tNyyqmQ8G8UllwK2g8hrk6P67SOpDHnN9B/1a8dZqF8QM1vlSbT
         ZOLw==
X-Gm-Message-State: AOAM533LEbjKIMV1NkW0SMkAnT8oQc35QlCRVF1ijHdDf975oE+z9OWv
        YLKi/v/SNwqFLax7oRGU6QeK3sDG64OfcakL1b2Hxw==
X-Google-Smtp-Source: ABdhPJy3Zgxr3goL6y95JyQ3EAm2H28IEv/cAiuUN/X8GBECBt3ASEjJk5wSXrmcJ2LzdCE7KXCbQwycN4tMvFaDU+E=
X-Received: by 2002:aca:b686:: with SMTP id g128mr1632030oif.38.1634767292605;
 Wed, 20 Oct 2021 15:01:32 -0700 (PDT)
MIME-Version: 1.0
References: <20211020192732.960782-1-pbonzini@redhat.com> <20211020192732.960782-3-pbonzini@redhat.com>
 <CALMp9eTbehPFGb2UTDiV8Q7zo6O9_Dq39=V_DdcQKG3-ev1_8w@mail.gmail.com>
 <0a87132a-f7ea-5483-dd9d-cb8c377af535@redhat.com> <CALMp9eRY_YYozTv0EZb5rbr27TJihaW3SpxV-Be=JJt2HYaTYQ@mail.gmail.com>
 <9f5e4bae-1400-3c49-d889-66de805bc1c2@redhat.com>
In-Reply-To: <9f5e4bae-1400-3c49-d889-66de805bc1c2@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 20 Oct 2021 15:01:21 -0700
Message-ID: <CALMp9eTjE1zbrun-bMSZTTodo1AnUpPvfhYgMoTkbfdAQz7mZg@mail.gmail.com>
Subject: Re: [PATCH v2 kvm-unit-tests 2/2] replace tss_descr global with a function
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, zxwang42@gmail.com, marcorr@google.com,
        seanjc@google.com, jroedel@suse.de, varad.gautam@suse.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 20, 2021 at 2:31 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 20/10/21 23:18, Jim Mattson wrote:
> >>>> -       vmcs_write(GUEST_LIMIT_TR, tss_descr.limit);
> >>>> +       vmcs_write(GUEST_LIMIT_TR, 0x67);
> >>> Isn't the limit still set to 0xFFFF in {cstart,cstart64}.S? And
> >>> doesn't the VMware backdoor test assume there's room for an I/O
> >>> permission bitmap?
> >>>
> >> Yes, but this is just for L2.  The host TR limit is restored to 0x67 on
> >> every vmexit, and it seemed weird to run L1 and L2 with different limits.
> > Perhaps you could change the limits in the GDT entries to match?
>
> So keep it 0x67 and adjust it to the size of the IOPM in the VMware
> backdoor test?

Right. That would seem to achieve the greatest consistency.
