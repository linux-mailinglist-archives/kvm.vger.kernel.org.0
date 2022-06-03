Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0A6A53CC03
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 17:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245271AbiFCPJP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 11:09:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230486AbiFCPJN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 11:09:13 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0735439166
        for <kvm@vger.kernel.org>; Fri,  3 Jun 2022 08:09:11 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id d129so7412140pgc.9
        for <kvm@vger.kernel.org>; Fri, 03 Jun 2022 08:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=sBL/0rQQBb7O/sTBfOZODaiGwQhp0A4CY9aIVrOB0Ik=;
        b=Aaz9aQ3GJ7xmch25U7TYusyYt+2Ax1Lk286uuSHaOOMEuTJOGjgYHSW0EKECGPkbX6
         M6AhPEdhp6h6j8zDZOUJ7kXxNJ1Zz/073FzXDRzn/9xaK3hRheb6S5AMCRVI1qqKgajI
         JFcYjceBNThgdmnMjTAP9fibbbNauSUVfcm+vUlTQWu+zgBK2P++94Ovewf8gtsImOv+
         5i6e044xu/ql5/hRola0OTvxotSQKG2DNZuV17t2BCOsbgkF2Rvq582f7RDfbqh4kYZJ
         3F+3buSMIJGQ7/9LJfMq6q03K+JCkSN+e9X19EWhhdg/xtdT1puhlnP1xoiku3xh/nKA
         r/LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=sBL/0rQQBb7O/sTBfOZODaiGwQhp0A4CY9aIVrOB0Ik=;
        b=r1de9SHOX/LPw1leFJMIOdmggUsezF4GcJQXsIdXtzWacSjG0phEt7/ifSfl95XI4P
         tz3J3SY84CXFSMJk9M/NxR1u8QXk9noJIw0GfOSd7wOcPmYhBHG+7O4zw+em7V8vdkzC
         Or9/s1ld+4TfdaMR+VEgrphVvLFSdYFTPd0p8CxvAsYyvTg/ZUajcAcGp+GEmTi0L0Q4
         axKy1RAGtOPVBnvsP7Sx8IrgG2ig0W0lHwe591QXukQCR9azQ+/7qJdinnHUe3xkRT6W
         n1503dgRaAbbdTopSiJW7IViGEYzgHArUlpFwVqfmK1xyeUwsuJSbqx2LKmuBdPblkcT
         r6Tw==
X-Gm-Message-State: AOAM531XiCh8KV+U6lYKpXdFBJ64d21JKRSX3Zxh8Yz9bKtPlYqfKKKW
        Y+tU6sSLip7US/yZkUW0tUixoQ==
X-Google-Smtp-Source: ABdhPJwYsbQ8SyzN94v/bwt30In4IHIR9TJhof+vTHEZAKOl8jvN+mtWCZw9YZNLpRpaQymcdYrC3Q==
X-Received: by 2002:a05:6a00:1902:b0:4f7:8813:b2cb with SMTP id y2-20020a056a00190200b004f78813b2cbmr10772775pfi.54.1654268950280;
        Fri, 03 Jun 2022 08:09:10 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id jc20-20020a17090325d400b0015e8d4eb20dsm5463303plb.87.2022.06.03.08.09.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 08:09:09 -0700 (PDT)
Date:   Fri, 3 Jun 2022 15:09:06 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     mike tancsa <mike@sentex.net>
Cc:     Igor Mammedov <imammedo@redhat.com>, kvm@vger.kernel.org,
        Leonardo Bras <leobras@redhat.com>
Subject: Re: Guest migration between different Ryzen CPU generations
Message-ID: <YpokEm84nqVXuOCA@google.com>
References: <48353e0d-e771-8a97-21d4-c65ff3bc4192@sentex.net>
 <20220602144200.1228b7bb@redhat.com>
 <489ddcdf-e38f-ea51-6f90-8c17358da61d@sentex.net>
 <Ypkvu6l5sxyuP6iM@google.com>
 <ce81de90-3dd1-1e8a-6a8f-b1c18310cb08@sentex.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ce81de90-3dd1-1e8a-6a8f-b1c18310cb08@sentex.net>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 03, 2022, mike tancsa wrote:
> On 6/2/2022 5:46 PM, Sean Christopherson wrote:
> > On Thu, Jun 02, 2022, mike tancsa wrote:
> > > On 6/2/2022 8:42 AM, Igor Mammedov wrote:
> > > > On Tue, 31 May 2022 13:00:07 -0400
> > > > mike tancsa <mike@sentex.net> wrote:
> > > > 
> > > > > Hello,
> > > > > 
> > > > >        I have been using kvm since the Ubuntu 18 and 20.x LTS series of
> > > > > kernels and distributions without any issues on a whole range of Guests
> > > > > up until now. Recently, we spun up an Ubuntu LTS 22 hypervisor to add to
> > > > > the mix and eventually upgrade to. Hardware is a series of Ryzen 7 CPUs
> > > > > (3700x).  Migrations back and forth without issue for Ubuntu 20.x
> > > > > kernels.  The first Ubuntu 22 machine was on identical hardware and all
> > > > > was good with that too. The second Ubuntu 22 based machine was spun up
> > > > > with a newer gen Ryzen, a 5800x.  On the initial kernel version that
> > > > > came with that release back in April, migrations worked as expected
> > > > > between hardware as well as different kernel versions and qemu / KVM
> > > > > versions that come default with the distribution. Not sure if migrations
> > > > > between kernel and KVM versions "accidentally" worked all these years,
> > > > > but they did.  However, we ran into an issue with the kernel
> > > > > 5.15.0-33-generic (possibly with 5.15.0-30 as well) thats part of
> > > > > Ubuntu.  Migrations no longer worked to older generation CPUs.  I could
> > > > > send a guest TO the box and all was fine, but upon sending the guest to
> > > > > another hypervisor, the sender would see it as successfully migrated,
> > > > > but the VM would typically just hang, with 100% CPU utilization, or
> > > > > sometimes crash.  I tried a 5.18 kernel from May 22nd and again the
> > > > > behavior is different. If I specify the CPU as EPYC or EPYC-IBPB, I can
> > > > > migrate back and forth.
> > > > perhaps you are hitting issue fixed by:
> > > > https://lore.kernel.org/lkml/CAJ6HWG66HZ7raAa+YK0UOGLF+4O3JnzbZ+a-0j8GNixOhLk9dA@mail.gmail.com/T/
> > > > 
> > > Thanks for the response. I am not sure.
> > I suspect Igor is right.  PKRU/PKU, the offending XSAVE feature in that bug, is
> > in the "new in 5800" list below, and that bug fix went into v5.17, i.e. should
> > also be fixed in v5.18.
> > 
> > Unfortunately, there's no Fixes: provided and I'm having a hell of a time trying
> > to figure out when the bug was actually introduced.  The v5.15 code base is quite
> > different due to a rather massive FPU rework in v5.16.  That fix definitely would
> > not apply cleanly, but it doesn't mean that the underlying root cause is different,
> > e.g. the buggy code could easily have been lurking for multiple kernel versions
> > before the rework in v5.16.
> > > That patch is from Feb. Would the bug have been introduced sometime in May to
> > > the 5.15 kernel than Ubuntu 22 would have tracked ?
> > Dates don't necessarily mean a whole lot when it comes to stable kernels, e.g.
> > it's not uncommon for a change to be backported to a stable kernel weeks/months
> > after it initially landed in the upstream tree.
> > 
> > Is moving to v5.17 or later an option for you?  If not, what was the "original"
> > Ubuntu 22 kernel version that worked?  Ideally, assuming it's the same FPU/PKU bug,
> > the fix would be backported to v5.15, but that's likely going to be quite difficult,
> > especially without knowing exactly which commit introduced the bug.
> 
> Thanks Sean, I can, but it just means adjusting our work flow a bit. For our
> hypervisors we like to just track LTS and be conservative in what software
> we install and stick with apps and kernels designed specifically to work
> with that release / distribution.

Yeah, tracking LTS is the right thing to do.  I'll try to verify and bisect the bug,
and then get the fix backported to v5.15.y, but it may be a week or two before that
happens.

> The Ubuntu 22 kernel that worked back in April was 5.15.0-25-generic.  TBH,
> if I am told we were just lucky things worked with different hardware and
> different kernels and KVM versions (ie.  migrating bidirectionally from
> ubuntu 20.x to 22.x) I would be fine with that too.  But I was a little
> surprised that a kernel version bump from 5.15 would break what was working.

Migrating between kernel/KVM versions is absolutely supposed to work, this is
firmly a kernel bug.
