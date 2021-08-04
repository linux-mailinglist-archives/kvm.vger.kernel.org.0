Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7EFC3DFF60
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 12:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237337AbhHDKYN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 06:24:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236722AbhHDKYL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Aug 2021 06:24:11 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F19F9C0613D5
        for <kvm@vger.kernel.org>; Wed,  4 Aug 2021 03:23:57 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id y200so1830828iof.1
        for <kvm@vger.kernel.org>; Wed, 04 Aug 2021 03:23:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NNl9131zYVD42v3QiBF6WyxgHAIJ7sUMTcfWdAq4NsQ=;
        b=B/twVzKMvEOxJFpFj/1p+8Y6wfE8tL4G8WYrLTCJM7lLhtqjiv2+XHKSclfcQWVOWw
         fkEcDPzQ0DyDeQyvr5B5ywdVpGDRBfVKHSXxj+IB3xQe/Df21W68qKApVeFzzanF3l8a
         d0pQL7H5DOMie/AhKCUo+nQCJQHiP02r7RRyqv9N36qyLfiVctT88OsgYYL5jqbSp6UX
         qm9uO5lAa+b+KbudycjXSq9gsyy4g1uglyjp+SSKxtg+yGSxQ0inFzCwVCOwN5I+iV+q
         J5H5dVGYKtyx+a30EGVDIYVlPrjGsbTQ3k7nuCwo+gkNhWNronaMxRkQMmVSAF2LK99c
         uAtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NNl9131zYVD42v3QiBF6WyxgHAIJ7sUMTcfWdAq4NsQ=;
        b=VhQ5aH2dGPbqhS1CW9A94IfH+qphdWwmwIpR1Quf+Tp+McZBFOx+Ur44SmBMfHBSsR
         FR/eBklZE9LdQa4lDlV/NFcA9X+aJgyz2RgC7ikZwfQnL3FJeZ40X69/7DEUkQ3/tv6j
         v86Bolor5qtiALTf3mo6u6p1te33ejwTmThqeDCiKraeksKg4hojf/GPtgpb8kP/W4y8
         WherGnXTmS/VmNPSR1N/l4x/F2Oahp2C3X2b2YuwaWRHVMOeCsv16ft+A6YkyYQQBXS4
         HtbWyaBRUIbpXX2g4Fr7behM9Hf8weccFwTFWCrAWyQkhAt604vwpv89k6ZMFDZbjpvq
         al0w==
X-Gm-Message-State: AOAM531zupqUTDlwQHoqXsXxmjua5XXPFRnScUeVH0L/FSDx+VwG4Hrn
        EZ2wJ4YuO5m7OeGyxerDqzAVVggI5c7iXmVOv/YOLvTkdB0=
X-Google-Smtp-Source: ABdhPJwq7EJy/AHpfqC7x2No0l2N91WEL/vKiA82yKFsB0PaWO1qhbHYKhclVkXEYhonz4TsopPJ/7XXk9xU0iRKtvM=
X-Received: by 2002:a02:cf31:: with SMTP id s17mr23583486jar.46.1628072637413;
 Wed, 04 Aug 2021 03:23:57 -0700 (PDT)
MIME-Version: 1.0
References: <YQlOeGxhor3wJM6i@stefanha-x1.localdomain> <CAM9Jb+jAx8uy0PerK6gN2GOykQpPXQbd9uoPkeyxZSbya==o5w@mail.gmail.com>
 <CAM9Jb+jNUrympkjUMnX3D0AMTfZOuHYbF+-VDb10AiXybW-e_A@mail.gmail.com> <bef63d3a-d8e5-03c9-521e-7b287247c626@redhat.com>
In-Reply-To: <bef63d3a-d8e5-03c9-521e-7b287247c626@redhat.com>
From:   Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date:   Wed, 4 Aug 2021 12:23:46 +0200
Message-ID: <CAM9Jb+g8W1iZ6JX=8_3M7htq=GAa3wJk5gy9_vNXnL7grv6N6w@mail.gmail.com>
Subject: Re: What does KVM_HINTS_REALTIME do?
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org,
        Jenifer Abrams <jhopper@redhat.com>, atheurer@redhat.com,
        jmario@redhat.com, "Michael S. Tsirkin" <mst@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> >> Do we need to mention "halt_poll_ns" at host side also will also be disabled?
> > with KVM_FEATURE_POLL_CONTROL
> >
> > Sorry, pressed enter quickly in previous email.
>
> That is done by the cpuidle-haltpoll driver, not just by the presence of
> the feature.

Okay.

Thanks,
Pankaj

>
> Paolo
>
