Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 799E62EEA9D
	for <lists+kvm@lfdr.de>; Fri,  8 Jan 2021 01:58:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729734AbhAHA4c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 19:56:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729726AbhAHA4b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 19:56:31 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 978FFC0612F9
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 16:55:51 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id t3so4545376ilh.9
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 16:55:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YFEuVUC8aA7NY7eBZYfyGxeTh/eqcKZZ4JvsuQQiSyE=;
        b=p/OG6jEu5ut6T7CABzrHvQr8IvhK9OHCHolTHtDS+7trzI0kxcQ9wVzHHeaFLEHxMc
         sHWcen7E+eTdA/lhCjNXKQ6UbiaXlQhukFOEI1EV32xBGhm38jAhqjzA9HOIffCWSxsI
         WW8hJ21NYlcP0OTlFcAyvgZInKY03hfrT5coh/Taoe4upoZ8th+1xgcDWJhDxqEVY4P0
         2l4ya0VuiHYUBTUEtCaklKBbptGVifAQ9n6NZi47VUKP2e3+IQIQpl5f+UoHaSh2hfi+
         GWCSQakGjOASBDdXB0F3ZFBAK7PcPz++56IkdzsbM1XBb174EeFDTdd1ayBeQewVnF4L
         TL7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YFEuVUC8aA7NY7eBZYfyGxeTh/eqcKZZ4JvsuQQiSyE=;
        b=gJi065VB1a8CYKKL8nJPCQfDUz8MqKG7bpykOgb4qOue9rHF2sikPSciAu3Z3ijw3q
         b0f6Wu0D98toYrShfinRwFiZTyayJUkc0RDPqS+eJY+IglmJFZYP+1o0dFuALVmfheXx
         YacQYHKLU15dIZO/pl5bmQIaQjFYPZzIi2jXZidumuDrFRD0WJvQPuGo9csrShVgX+TD
         Auanx6Ix91AcyCgwJZob+SA2ddbF/wKsSvMCCftWVU/Wt95Odx0Eezg/3OtH6ivVy/DJ
         BdH0ppKIwxN1C3CIevuekYpcXoiEuChyG6s6zaKy94ZR1Oi3448R0VpV7KsPTUOhlnkC
         yVOg==
X-Gm-Message-State: AOAM532HenauvqTLmG+s2giFhfC/XvLdh9CxKQp/iM6A2MDDK4VhV5Md
        Pehovv8CKl4UyLcKxTHjOYNMAqxW3xOs43nYnQpgyQ==
X-Google-Smtp-Source: ABdhPJzy4C4d9f+tFdhBVZvmQqT6xWaAhi+BR7yk23ezp0pUkQCTI2zRtDXXZ97ugJvcW5JLMT2E2kP4AefQOvSOm6I=
X-Received: by 2002:a92:d2ce:: with SMTP id w14mr1628816ilg.182.1610067350828;
 Thu, 07 Jan 2021 16:55:50 -0800 (PST)
MIME-Version: 1.0
References: <765f86ae-7c68-6722-c6e0-c6150ce69e59@amd.com> <20201211225542.GA30409@ashkalra_ubuntu_server>
 <20201212045603.GA27415@ashkalra_ubuntu_server> <20201218193956.GJ2956@work-vm>
 <E79E09A2-F314-4B59-B7AE-07B1D422DF2B@amd.com> <20201218195641.GL2956@work-vm>
 <20210106230555.GA13999@ashkalra_ubuntu_server> <CABayD+dQwaeCnr5_+DUpvbQ42O6cZBMO79pEEzi5WXPO=NH3iA@mail.gmail.com>
 <20210107013414.GA14098@ashkalra_ubuntu_server> <20210107080513.GA16781@ashkalra_ubuntu_server>
 <20210108004756.GA17895@ashkalra_ubuntu_server>
In-Reply-To: <20210108004756.GA17895@ashkalra_ubuntu_server>
From:   Steve Rutherford <srutherford@google.com>
Date:   Thu, 7 Jan 2021 16:55:14 -0800
Message-ID: <CABayD+euSYint8H7pvwV7JFF6FonfZkdmFfbZ_kiKfYjiZTSYA@mail.gmail.com>
Subject: Re: [PATCH v2 1/9] KVM: x86: Add AMD SEV specific Hypercall3
To:     Ashish Kalra <ashish.kalra@amd.com>
Cc:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@suse.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "dovmurik@linux.vnet.ibm.com" <dovmurik@linux.vnet.ibm.com>,
        "tobin@ibm.com" <tobin@ibm.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "frankeh@us.ibm.com" <frankeh@us.ibm.com>,
        "Grimm, Jon" <jon.grimm@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 7, 2021 at 4:48 PM Ashish Kalra <ashish.kalra@amd.com> wrote:
>
> > On Thu, Jan 07, 2021 at 01:34:14AM +0000, Ashish Kalra wrote:
> > > Hello Steve,
> > >
> > > My thoughts here ...
> > >
> > > On Wed, Jan 06, 2021 at 05:01:33PM -0800, Steve Rutherford wrote:
> > > > Avoiding an rbtree for such a small (but unstable) list seems correct.
> > > >
> > >
> > > I agree.
> > >
> > > > For the unencrypted region list strategy, the only questions that I
> > > > have are fairly secondary.
> > > > - How should the kernel upper bound the size of the list in the face
> > > > of malicious guests, but still support large guests? (Something
> > > > similar to the size provided in the bitmap API would work).
> > > > - What serialization format should be used for the ioctl API?
> > > > (Usermode could send down a pointer to a user region and a size. The
> > > > kernel could then populate that with an array of structs containing
> > > > bases and limits for unencrypted regions.)
> > > > - How will the kernel tag a guest as having exceeded its maximum list
> > > > size, in order to indicate that the list is now incomplete? (Track a
> > > > poison bit, and send it up when getting the serialized list of
> > > > regions).
> > > >
> > > > In my view, there are two main competitors to this strategy:
> > > > - (Existing) Bitmap API
> > > > - A guest memory donation based model
> > > >
> > > > The existing bitmap API avoids any issues with growing too large,
> > > > since it's size is predictable.
> > > >
> > > > To elaborate on the memory donation based model, the guest could put
> > > > an encryption status data structure into unencrypted guest memory, and
> > > > then use a hypercall to inform the host where the base of that
> > > > structure is located. The main advantage of this is that it side steps
> > > > any issues around malicious guests causing large allocations.
> > > >
> > > > The unencrypted region list seems very practical. It's biggest
> > > > advantage over the bitmap is how cheap it will be to pass the
> > > > structure up from the kernel. A memory donation based model could
> > > > achieve similar performance, but with some additional complexity.
> > > >
> > > > Does anyone view the memory donation model as worth the complexity?
> > > > Does anyone think the simplicity of the bitmap is a better tradeoff
> > > > compared to an unencrypted region list?
> > >
> > > One advantage in sticking with the bitmap is that it maps very nicely to
> > > the dirty bitmap page tracking logic in KVM/Qemu. The way Brijesh
> > > designed and implemented it is very similar to dirty page bitmap tracking
> > > and syncing between KVM and Qemu. The same logic is re-used for the page
> > > encryption bitmap which means quite mininal changes and code resuse in
> > > Qemu.
> > >
> > > Any changes to the backing data structure, will require additional
> > > mapping logic to be added to Qemu.
> > >
> > > This is one advantage in keeping the bitmap logic.
> > >
>
> So if nobody is in favor of keeping the (current) bitmap logic, we will
> move to the unencrypted region list approach.
Sounds good to me.

>
> Thanks,
> Ashish
