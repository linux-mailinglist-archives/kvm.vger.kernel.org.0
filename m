Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 542B3D1B4D
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 23:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731155AbfJIV6R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Oct 2019 17:58:17 -0400
Received: from mail-io1-f44.google.com ([209.85.166.44]:39363 "EHLO
        mail-io1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730809AbfJIV6R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Oct 2019 17:58:17 -0400
Received: by mail-io1-f44.google.com with SMTP id a1so8959890ioc.6
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2019 14:58:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gzBYOvNgy3z7BPU6I6KZ4ksIvxWAfhs9HM+Yo4vRGz4=;
        b=f5SSlwPMoXvmmAVETZPh2nk2tpM46NefQN8IKzDNpIqwti0zXtvtRp5SiwT2TsvaZ/
         mCGL3dTPMVIEHK2oy4FZUxwaDDMfIiFkuSa70AVFVj5HdXhFjAZbr7mdX+pcEwUPfCUy
         rtTgjGTj9XfspHKkNHShd+xjw63XOtTmE6WxQlxEYylwF0XL84MuuTUDJdekp31qnSbX
         d/vqvHnJsiJlP05Fd3kDz3dv0C/Lffj93hbbLzjLlXkl+mi8kzjQtEXZ1z7lMb9IckQe
         wyGV9vJV3O6o1BRtLN0/cgkcs3xTrS64dP1SfZuF6US9dAcZjZ5nFT5NpL/Pa+S+D16L
         CjBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gzBYOvNgy3z7BPU6I6KZ4ksIvxWAfhs9HM+Yo4vRGz4=;
        b=qnoSZe78XUZ1ocsc6WMTXfoO9EFhWHc/XPKyK/6tlDQKVKrf70cBGhTZbNbfIm11Yu
         sbC91v+RGEcpfCkYRbq+qgPjxjWwac2enMKTwQr/9hpm7k+etlSm/vo6wv4s6gNKgnmq
         S2m+/qTLcUh2M6tjKJegkomk4hpSf9ahSmMG18NmzmkAifBlZzKgS4F/0pzvXJ4dlJOq
         3I9AgVo158cLpQGqrQvHkrhhiQnmfipzgrVjrqEqETf57Ue+7yG7RyPDCXpIBR6+psxk
         MLlwpQ014Vr+JjBmkVUJigmX13j8XKxPflsoVMr4gsMP8cE6I//pjZr6vDlhPb4OlJTM
         Z4Ag==
X-Gm-Message-State: APjAAAXhkLRvWzjGugrhpPBLdHZ2VB1H5EAdpcxZ+1tUMnJoKeAMGQ8Z
        qaKsM6BY05O+U/z9XdktTnffGl9+vSzPFSd9hk9teQ==
X-Google-Smtp-Source: APXvYqzwxeZMapNzaqarOUXXhEf/yRmoC5t+83izz7vaQGu60lPEjq6ZuCUESkF3vIIs8FWooOKAD09Agf/UZnum7Xo=
X-Received: by 2002:a5d:8d8f:: with SMTP id b15mr6262526ioj.296.1570658296182;
 Wed, 09 Oct 2019 14:58:16 -0700 (PDT)
MIME-Version: 1.0
References: <20191009004142.225377-1-aaronlewis@google.com>
 <20191009004142.225377-3-aaronlewis@google.com> <56cf7ca1-d488-fc6e-1c20-b477dd855d84@redhat.com>
 <CALMp9eRNdLdb7zR=wwx2tTc8n-ewCKuhrw9pxXGVQVUBjNpRow@mail.gmail.com> <9335c3c7-e2dd-cb2d-454a-c41143c94b63@redhat.com>
In-Reply-To: <9335c3c7-e2dd-cb2d-454a-c41143c94b63@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 9 Oct 2019 14:58:05 -0700
Message-ID: <CALMp9eTW56TDny5MehuW-wS8dHWwfVEdzEvZQkOfVumEwcMWAA@mail.gmail.com>
Subject: Re: [Patch 3/6] kvm: svm: Add support for XSAVES on AMD
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Aaron Lewis <aaronlewis@google.com>,
        Babu Moger <Babu.Moger@amd.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        kvm list <kvm@vger.kernel.org>,
        Luwei Kang <luwei.kang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 9, 2019 at 2:40 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 09/10/19 23:29, Jim Mattson wrote:
> > On Wed, Oct 9, 2019 at 12:02 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >>
> >> On 09/10/19 02:41, Aaron Lewis wrote:
> >>> -             /*
> >>> -              * The only supported bit as of Skylake is bit 8, but
> >>> -              * it is not supported on KVM.
> >>> -              */
> >>> -             if (data != 0)
> >>> -                     return 1;
> >>
> >> This comment is actually not true anymore; Intel supports PT (bit 8) on
> >> Cascade Lake, so it could be changed to something like
> >>
> >>         /*
> >>          * We do support PT (bit 8) if kvm_x86_ops->pt_supported(), but
> >>          * guests will have to configure it using WRMSR rather than
> >>          * XSAVES.
> >>          */
> >>
> >> Paolo
> >
> > Isn't it necessary for the host to set IA32_XSS to a superset of the
> > guest IA32_XSS for proper host-level context-switching?
>
> Yes, this is why we cannot allow the guest to set bit 8.  But the
> comment is obsolete:
>
> 1) of course Skylake is not the newest model
>
> 2) processor tracing was not supported at all when the comment was
> written; but on CascadeLake, guest PT is now supported---just not the
> processor tracing XSAVES component.

I think we're on the same page. I was just confused by your wording;
it sounded like you were saying that KVM supported bit 8.

How about:

/*
 * We do support PT if kvm_x86_ops->pt_supported(), but we do not
 * support IA32_XSS[bit 8]. Guests will have to use WRMSR rather than
 * XSAVES/XRSTORS to save/restore PT MSRs.
 */
