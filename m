Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA8EB422F3C
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 19:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234366AbhJERek (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 13:34:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231858AbhJERei (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Oct 2021 13:34:38 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD2A8C061749
        for <kvm@vger.kernel.org>; Tue,  5 Oct 2021 10:32:47 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id c26-20020a056830349a00b0054d96d25c1eso26807201otu.9
        for <kvm@vger.kernel.org>; Tue, 05 Oct 2021 10:32:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Mh3wEsS3oUGUjXPVcgwj7eWBIpN7QtfE09QQA3WRYfc=;
        b=TK4DPSLIC7KYaXbQg+WO/d90o0peCqUpLQEry75amXFSA4WpPwKDMSo8bI7rBrXfph
         xQe1ddFG+rzgPu3cEgwPy0+Pat7htTUpulMYPdvimTtMUljp84sqQ5sSah7p/PGVmHr/
         cZcoweILgM5ccHdSuY9x7fEWIR235oNW4hg/QK6hnrsbe3wZ6E4bjWNfcjO83D+9PdGv
         4zX8uJ8bqCMVRnAOvZW4A6qiTuMV8Tu3tfOzkuR+BAiVm1rewREdRohXzjB52SdJIHy+
         dfV0I2wow9Sz40dg/IvHSk+z8ujyd/Yn6p2elKyFlCs97eNhCFCSXuQZHFo68y7bZZD6
         zKFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Mh3wEsS3oUGUjXPVcgwj7eWBIpN7QtfE09QQA3WRYfc=;
        b=MljitgSL3QMrqUuGWYKawRqLHiZpBGzZxQ/Xr5f0xo64FzmkVuQPqZC/nyOxeWeJ0n
         QD7tiHCz72c67jhtb/KZjvCPW5EydlQ8KDOcpKejgJk+nlKV1ccdiOnvVcw8oytEiQN+
         9g0IWlXb54y9Yed8yaB+RS9ZEOHMaOH6HB6T6MLCLbFxM62nC+WOECKAvdeEj1+ZvCxQ
         FvWIadVdRDR7MuYDQIO0otzD0MZJPkRi+NpF+hlc2VUgZRdsOe8eX/fjwWZ2/ThsXgqY
         i6bU+iPLLZ/ciRJBoXyZNaLckfTUakoNMADTv9KSxBpVWSldqBGnSLGPoMZ7TPGZ4vvD
         MlVg==
X-Gm-Message-State: AOAM531+ifVYCVWSNcVCxHo2HmwqlUSZzw0LjerDyxedi9BCUpJ0ZQc3
        DovsUl9LHQm3zQXeF6lFoRNV9jur0TLbhoLZJy324A==
X-Google-Smtp-Source: ABdhPJw0FMI+8CYoPcZPce9O7l/OgCe23L/DDRyhVoFuX2OPf+/OvptcPO4fH9fpmNJFarCUUh0YL59Oc2KzWIekVfI=
X-Received: by 2002:a05:6830:31a7:: with SMTP id q7mr15328381ots.39.1633455166829;
 Tue, 05 Oct 2021 10:32:46 -0700 (PDT)
MIME-Version: 1.0
References: <1629192673-9911-1-git-send-email-robert.hu@linux.intel.com>
 <1629192673-9911-4-git-send-email-robert.hu@linux.intel.com>
 <YRvbvqhz6sknDEWe@google.com> <b2bf00a6a8f3f88555bebf65b35579968ea45e2a.camel@linux.intel.com>
 <YR2Tf9WPNEzrE7Xg@google.com> <3ac79d874fb32c6472151cf879edfb2f1b646abf.camel@linux.intel.com>
 <YS/lxNEKXLazkhc4@google.com> <0b94844844521fc0446e3df0aa02d4df183f8107.camel@linux.intel.com>
 <YTI7K9RozNIWXTyg@google.com> <64aad01b6bffd70fa3170cf262fe5d7c66f6b2d4.camel@linux.intel.com>
 <YVx6Oesi7X3jfnaM@google.com>
In-Reply-To: <YVx6Oesi7X3jfnaM@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 5 Oct 2021 10:32:35 -0700
Message-ID: <CALMp9eRyhAygfh1piNEDE+WGVzK1cTWJJR1aC_zqn=c2fy+c-A@mail.gmail.com>
Subject: Re: [PATCH v1 3/5] KVM: x86: nVMX: VMCS12 field's read/write respects
 field existence bitmap
To:     Sean Christopherson <seanjc@google.com>
Cc:     Robert Hoo <robert.hu@linux.intel.com>, pbonzini@redhat.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org,
        kvm@vger.kernel.org, yu.c.zhang@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 5, 2021 at 9:16 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Sep 28, 2021, Robert Hoo wrote:
> > On Fri, 2021-09-03 at 15:11 +0000, Sean Christopherson wrote:
> >       You also said, "This is quite the complicated mess for
> > something I'm guessing no one actually cares about.  At what point do
> > we chalk this up as a virtualization hole and sweep it under the rug?"
> > -- I couldn't agree more.
>
> ...
>
> > So, Sean, can you help converge our discussion and settle next step?
>
> Any objection to simply keeping KVM's current behavior, i.e. sweeping this under
> the proverbial rug?

Adding 8 KiB per vCPU seems like no big deal to me, but, on the other
hand, Paolo recently argued that slightly less than 1 KiB per vCPU was
unreasonable for VM-exit statistics, so maybe I've got a warped
perspective. I'm all for pedantic adherence to the specification, but
I have to admit that no actual hypervisor is likely to care (or ever
will).
