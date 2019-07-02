Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0179E5D58B
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2019 19:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbfGBRq3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jul 2019 13:46:29 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:43515 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726529AbfGBRq3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jul 2019 13:46:29 -0400
Received: by mail-ed1-f66.google.com with SMTP id e3so28078475edr.10
        for <kvm@vger.kernel.org>; Tue, 02 Jul 2019 10:46:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=62xeVPs21E5ReOKr0PeNYmMpHFedVY8IfymEZkh+FCQ=;
        b=S62756i4kfBhwvThdrp/bluvzbNlIQhGr2N54PhVXSt+bW0Fi/DqOASwTjFn0iK8pH
         O4scfXJPkY3GXcYQW2rzoHqJyot3S894FWcAdSIEqZk4YStXK4NAY1qtHaa05VSYEVQw
         ypFocTubeKx4UpSHTcIfHAVwLY+DfTPdFB/QPPA/6io5p/bC36vp16JpzDFaICzTEYpn
         pUnjF49M/4lXBLlpaUm/pUbCp3kS/HQu191UUJFGzCeemFPZg40bEiZ5sElzpVhhBUto
         Ii0pKGfpV/f83Cx6GZSfpDb78rXAwFs7DvSh+JbVnTg2ezwdco08A8C/48egMrQr6M2O
         knkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=62xeVPs21E5ReOKr0PeNYmMpHFedVY8IfymEZkh+FCQ=;
        b=qye4/AoynkeAIEHcBwLIgYP+sZuXMHqcUQpppIzI6P+RFppj5+4z5tHifUZdHNVCWw
         HNR/U8UJR96MNYNrDFVpY0lkkz2cBm9lkFVLEphZMntyKZfgLV2ehp/IHoHe26dOJWAM
         4oEzSkZ7YUk78+VWAB8QnY8El4Mvbuw5Abaeys3J4Ge7sh10YP8kM2ZCTgtV3jmxC6jS
         O+qKkBBM1qbMBhoReF8Fgfttd2dC44R4NZWL1AHXCz+NxeBIRQZIufzt9ehRfYoWgcH1
         byJozXAlbOwQOngeWNL3Pxn2i8X3qQOLLB9wn5IKwkjLQLtLPJ/pHMZSGJbTphLiBAS8
         h4ww==
X-Gm-Message-State: APjAAAWhTQtTN98s8aAmI/NcRkuITgFFSNaB+IOX+9eBpilwu0gL1p4w
        mQJHw3hyW6+KK8EASHe2T2LROGTD2aMizdkYmCTR+w==
X-Google-Smtp-Source: APXvYqx5heTU3G2wcqJHU6kEnhITccuBT2in9TxF+0f1OMcZoamtL9MEX0jLGTQHsk/kPYuoYfPBgiTBJt5KlB/HUw8=
X-Received: by 2002:aa7:d845:: with SMTP id f5mr37202330eds.78.1562089587822;
 Tue, 02 Jul 2019 10:46:27 -0700 (PDT)
MIME-Version: 1.0
References: <CAOyeoRWfPNmaWY6Lifdkdj3KPPM654vzDO+s3oduEMCJP+Asow@mail.gmail.com>
 <5D036843.2010607@intel.com> <CAOyeoRXr4gmbBPq1RsStoPguiZB8Jxod-irYd3Dm_AGVcQRGSQ@mail.gmail.com>
 <5D11E58B.1060306@intel.com>
In-Reply-To: <5D11E58B.1060306@intel.com>
From:   Eric Hankland <ehankland@google.com>
Date:   Tue, 2 Jul 2019 10:46:16 -0700
Message-ID: <CAOyeoRUy6R0YzcMajRAhzss321p6G=LMrR63oPQCYFwaK6SMvA@mail.gmail.com>
Subject: Re: [PATCH v1] KVM: x86: PMU Whitelist
To:     Wei Wang <wei.w.wang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, rkrcmar@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> Actually I have another thing to discuss:
> probably we could consider to make this filter list white/black configurable
> from userspace. For example, userspace option: filter-list=white/black

Works for me. I'll include this in the next version.

> Probably we don't need this field to be passed from userspace?
>
> We could directly use AMD64_RAW_EVENTMASK_NB, which includes bit[35:32].
> Since those bits are reserved on Intel CPUs, have them as mask should be
> fine.
>
> Alternatively, we could add this event_mask field to struct kvm_pmu, and
> initalize
> it in the vendor specific intel_pmu_init or amd_pmu_init.
>
> Both options above look good to me.

Sounds good. I'll go with the first suggestion for now since it's
simpler. If other reviewers prefer the second I can implement that.

> For the fixed counter, we could add a bitmap flag to kvm_arch,
> indicating which counter is whitelist-ed based on the
> "eventsel+umask" value passed from userspace. This flag is
> updated when updating the whitelist-ed events to kvm.
> For example, if userspace gives "00+01" (INST_RETIRED_ANY),
> then we enable fixed counter0 in the flag.
>
> When reprogram_fixed_counter, we check the flag and return
> if the related counter isn't whitelisted.

Sounds good to me.

If you don't have any more comments I'll send out the next version
with all the requested changes.

Eric
