Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C95201254E
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 02:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbfECACe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 May 2019 20:02:34 -0400
Received: from outprodmail01.cc.columbia.edu ([128.59.72.39]:54868 "EHLO
        outprodmail01.cc.columbia.edu" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726053AbfECACe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 May 2019 20:02:34 -0400
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
        by outprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id x43009FH008556
        for <kvm@vger.kernel.org>; Thu, 2 May 2019 20:02:31 -0400
Received: from hazelnut (localhost.localdomain [127.0.0.1])
        by hazelnut (Postfix) with ESMTP id A9D647E
        for <kvm@vger.kernel.org>; Thu,  2 May 2019 20:02:31 -0400 (EDT)
Received: from sendprodmail01.cc.columbia.edu (sendprodmail01.cc.columbia.edu [128.59.72.13])
        by hazelnut (Postfix) with ESMTP id 897347E
        for <kvm@vger.kernel.org>; Thu,  2 May 2019 20:02:31 -0400 (EDT)
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
        by sendprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id x4302U7N031837
        (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 2 May 2019 20:02:31 -0400
Received: by mail-ed1-f71.google.com with SMTP id g36so2033298edg.8
        for <kvm@vger.kernel.org>; Thu, 02 May 2019 17:02:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MIyVKDfjviNZzSdphqhrVE/rptmpWbhoQmSYbUYHJcc=;
        b=AVK2GeXqqMwc92RRWf/mo13BmcipnD2oC/zPSFoZcHhXXeId/PjXC6Ab6fqg0aDQyf
         xiTggba+mEDwYN+AEQqW6JNGaalpaAAKdSuU00OjA/CevdFUGfNY2kr8OsK9XHP0jjHV
         rFBdBs3vpaSlRo9sDNBKOzdERCBfruTbTjBHBhauwqIyTX1rCPWFGyivn6/QKWLoWuQW
         lYjYMDCsmZhQfJLlkh8/rUbUm3rx9VJipzogM7IVTq+JyyTeWG00wdWPuWG41540jJI0
         giJTYyWgKNbkJ4VIK3AP5klTo0bhN+dsCr85CV9h5v8bTGxUF2hbhho+u9KbdiF/ntSw
         CI+w==
X-Gm-Message-State: APjAAAWHy1IWo6+bfvxUyN2cORuBidxXlLlXd7RRMt/Cklu8ptSZBE2W
        zNHKCsGhkLMHFBsdy5dsYMzAm6beqkgN1CuXvH4tlSX9by6H1ch3YK7qtzKdIJ3XJqyTkOWCjdj
        GiMHTHlc7K+9ze8IDojNZ
X-Received: by 2002:a50:9490:: with SMTP id s16mr4948868eda.260.1556841750274;
        Thu, 02 May 2019 17:02:30 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxZ6FPmgWFzcdjhFgar6Bwnl/PVi0T3Qfnn3fS4mBYKTlafKFKDCJ3GfgeNR6wUI4yUWApUMQ==
X-Received: by 2002:a50:9490:: with SMTP id s16mr4948850eda.260.1556841750012;
        Thu, 02 May 2019 17:02:30 -0700 (PDT)
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com. [209.85.128.44])
        by smtp.gmail.com with ESMTPSA id e43sm155712edb.38.2019.05.02.17.02.29
        for <kvm@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 17:02:29 -0700 (PDT)
Received: by mail-wm1-f44.google.com with SMTP id h11so4681878wmb.5
        for <kvm@vger.kernel.org>; Thu, 02 May 2019 17:02:29 -0700 (PDT)
X-Received: by 2002:a1c:2045:: with SMTP id g66mr4200962wmg.16.1556841748598;
 Thu, 02 May 2019 17:02:28 -0700 (PDT)
MIME-Version: 1.0
References: <1556762959-31705-1-git-send-email-jintack@cs.columbia.edu>
 <20190502150315.GB26138@linux.intel.com> <CALMp9eQot5jqiN4ncLDCPt_ZiVvtmEb_zeMp=1gkOChTrgL+dg@mail.gmail.com>
 <20190502210645.GC26138@linux.intel.com>
In-Reply-To: <20190502210645.GC26138@linux.intel.com>
From:   Jintack Lim <jintack@cs.columbia.edu>
Date:   Thu, 2 May 2019 20:02:17 -0400
X-Gmail-Original-Message-ID: <CAHyh4ximS_MZ2uTuTkZZ886fDNTwRUEP3WgL59Xxv_hr3tbu2w@mail.gmail.com>
Message-ID: <CAHyh4ximS_MZ2uTuTkZZ886fDNTwRUEP3WgL59Xxv_hr3tbu2w@mail.gmail.com>
Subject: Re: [PATCH] KVM: nVMX: Set msr bitmap correctly for MSR_FS_BASE in vmcs02
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-No-Spam-Score: Local
X-Scanned-By: MIMEDefang 2.84 on 128.59.72.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 2, 2019 at 5:06 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Thu, May 02, 2019 at 10:59:16AM -0700, Jim Mattson wrote:
> > On Thu, May 2, 2019 at 8:03 AM Sean Christopherson
> > <sean.j.christopherson@intel.com> wrote:
> >
> > > That being said, I think there are other reasons why KVM doesn't pass
> > > through MSRs to L2.  Unfortunately, I'm struggling to recall what those
> > > reasons are.
> > >
> > > Jim, I'm pretty sure you've looked at this code a lot, do you happen to
> > > know off hand?  Is it purely a performance thing to avoid merging bitmaps
> > > on every nested entry, is there a subtle bug/security hole, or is it
> > > simply that no one has ever gotten around to writing the code?
> >
> > I'm not aware of any subtle bugs or security holes. If L1 changes the
> > VMCS12 MSR permission bitmaps while L2 is running, behavior is
> > unlikely to match hardware, but this is clearly in "undefined
> > behavior" territory anyway. IIRC, the posted interrupt structures are
> > the only thing hanging off of the VMCS that can legally be modified
> > while a logical processor with that VMCS active is in VMX non-root
> > operation.
>
> Cool, thanks!
>
> > I agree that FS_BASE, GS_BASE, and KERNEL_GS_BASE, at the very least,
> > are worthy of special treatment. Fortunately, their permission bits
> > are all in the same quadword. Some of the others, like the SYSENTER
> > and SYSCALL MSRs are rarely modified by a typical (non-hypervisor) OS.
> > For nested performance at levels deeper than L2, they might still
> > prove interesting.
>
> Agreed on the *_BASE MSRs.  Rarely written MSRs should be intercepted
> so that the nested VM-Exit path doesn't need to read them from vmcs02
> on every exit (WIP).

Ok, let me handle those three *_BASE MSRs in v2.

> I'm playing with the nested code right now and
> one of the things I'm realizing is that KVM spends an absurd amount of
> time copying data to/from VMCSes for fields that are almost never
> accessed by L0 or L1.
>
> > Basically, I think no one has gotten around to writing the code.
>

