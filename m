Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE89415136
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 22:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237535AbhIVUM6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 16:12:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237325AbhIVUM5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 16:12:57 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A7A8C061574
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 13:11:27 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id b15so16188822lfe.7
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 13:11:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dVTubL4Vzgwqf5bG5nXBsZsCrKLQu1xFmttf3pz2Rh4=;
        b=AInJtG0K9A1qcgpMhBYjzvczg/GeGNhYQSeJkhDqWeTQIauQOain412w7RTDWhdgPt
         Yikew3akNNEJ84PFmGQxR/RrMitWuGxtQ2vMKMyhKAWS6HzRaHcthRAAl1l6COhpOO6N
         vwC51R5I22nAcBcVfK2GuGqghn/9cxsveq3GKhhCL/ZgkqZnecywi10pf1AMF9FtW9jN
         qvhYv35/VGLRtRe1fKz1wMSoEl4A3MO7hZecLaPPC+p2FnpauNvve77/auSjUY7GSJgH
         Z7Cd6TEwh95p6NZAbOLGoSeboA1Ug2X0nCTwsaIrd2gcIennnwgDnpKyHbqg/llotpQE
         CwsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dVTubL4Vzgwqf5bG5nXBsZsCrKLQu1xFmttf3pz2Rh4=;
        b=HF/3oc37ZwHYG+/uLeZ/nt25nGRMJVxSUIi1+9UJx3vy8fSy9xxG/fzmHvGsFyBVEA
         5WZGQD9Hfyx8+0Q5ykdvcuzRby9fjCqmCaAzcyXl5HwM69BMf/YiKJJsr8QQoCG1wdhg
         9XgUKj5t35QDugzDa5ExbYF0uIqFJobOO6aP6KbfRrPh7M8r+AuybUJXOH6VmZQiYvOx
         TLw44un+8gdb0mYNPIgAf/3oiCUcf6guBba2lZd/c2/BvDR+YmMopfW9rfg4y16Igku6
         jJIrzsfXQ38SwJsgUWtqMdPvj/uIyTBWYC+YEbcGTCOHF1D8Rn9Z/YHNtMmQMe8zLju/
         PLtg==
X-Gm-Message-State: AOAM5302yfjHZlJPXDDlKAidHIKpRiKs8mwHHKiUQyBNe+tIWEXe4xOa
        LwA0kO6w4+QdfdHRgloWm32FdUimEX5kVvB/7sU=
X-Google-Smtp-Source: ABdhPJyP1zn22cj4nPsmYXdOLfFtQfirEl3asSQzrIaS0usstr2xKTAbNahSPAHJQNqc6wddGne/5ngP4geneNBRFhI=
X-Received: by 2002:a2e:a604:: with SMTP id v4mr1249400ljp.258.1632341485564;
 Wed, 22 Sep 2021 13:11:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210827031222.2778522-1-zixuanwang@google.com>
 <20210827031222.2778522-2-zixuanwang@google.com> <20210921163311.deya72m7z2dkmhgc@gator.home>
In-Reply-To: <20210921163311.deya72m7z2dkmhgc@gator.home>
From:   Zixuan Wang <zxwang42@gmail.com>
Date:   Wed, 22 Sep 2021 13:10:00 -0700
Message-ID: <CAEDJ5ZQ4ZP0SaTWZrW6wgFTQtcNJMjkns0cjPC1JX01Fp_RXBg@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v2 01/17] x86 UEFI: Copy code from Linux
To:     Andrew Jones <drjones@redhat.com>
Cc:     Zixuan Wang <zixuanwang@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Orr <marcorr@google.com>,
        "Hyunwook (Wooky) Baek" <baekhw@google.com>,
        Tom Roeder <tmroeder@google.com>, erdemaktas@google.com,
        rientjes@google.com, seanjc@google.com, brijesh.singh@amd.com,
        Thomas.Lendacky@amd.com, varad.gautam@suse.com, jroedel@suse.de,
        bp@suse.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 21, 2021 at 9:33 AM Andrew Jones <drjones@redhat.com> wrote:
>
> On Fri, Aug 27, 2021 at 03:12:06AM +0000, Zixuan Wang wrote:
> > From: Varad Gautam <varad.gautam@suse.com>
> >
> > Copy UEFI-related definitions from Linux, so the follow-up commits can
> > develop UEFI function calls based on these definitions, without relying
> > on GNU-EFI library.
> >
> > Signed-off-by: Varad Gautam <varad.gautam@suse.com>
> > ---
> >  lib/linux/uefi.h | 518 +++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 518 insertions(+)
> >  create mode 100644 lib/linux/uefi.h
> >
> > diff --git a/lib/linux/uefi.h b/lib/linux/uefi.h
> > new file mode 100644
> > index 0000000..567cddc
> > --- /dev/null
> > +++ b/lib/linux/uefi.h
>
> Any reason to rename this to uefi.h even though it's efi.h in Linux?

This file is from Varad's patch set [1]. I can rename the file to
efi.h in the next version if Varad is OK with it.

[1] https://lore.kernel.org/kvm/20210819113400.26516-1-varad.gautam@suse.com/

> Usually I'd suggest we take the whole file from Linux (but that would
> be a mess for this one, so no) or that we only take what we need, when
> we need it, rather than dumping a bunch of stuff up front which may or
> may not be needed. Skimming through though, it looks like we'll likely
> need most the stuff brought over. So I guess I'm OK with this approach.
>
> Thanks,
> drew

Thank you for the detailed explanation! Another reason to keep this a
separate commit is to preserve Varad's full authorship of these 2
commits. We already re-organized Varad's 6 patches into these 2, and
do not want to further reduce Varad's authorships.

Best regards,
Zixuan
