Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B68AC5F6CEB
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 19:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbiJFR1E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Oct 2022 13:27:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiJFR1B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Oct 2022 13:27:01 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D6169FFC
        for <kvm@vger.kernel.org>; Thu,  6 Oct 2022 10:26:59 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id a10so3049338ljq.0
        for <kvm@vger.kernel.org>; Thu, 06 Oct 2022 10:26:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WRcVY/P3TNQqvqXdHDNlUC3IFQ9xWsVPZt3gbUvQeIQ=;
        b=sdIF/b93GsqQ8//o/Xw6I3jsGdP6BitWx8BgljFSi1iFQxJnIDXhadYXY8VQZEGdQp
         XPeUqgf4ec8rKP9Eub+YX5UtCpouJRPlW2YDCdOAriXz48hzG0Vk3ITG5ALWoGo2KrcN
         LcCL0NYXwLLfQ6ZD/S21cfEbB6NuNpdro805+ermZgKbJFGa2QthTAsjpbccPSE+AHXW
         SQqGS9Y+rwJRndls6h/wHb3zsv3tP60WTTwPXQyBTAE2Vj0LnmV07lVg3TIQv90pZv4K
         RzkSziUMzGTzLq+cyMadsq8ZLh8Wrs5epjKXcuJD5fU7dScWlGJ3snpZhFqGy+uc/jJo
         xVUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WRcVY/P3TNQqvqXdHDNlUC3IFQ9xWsVPZt3gbUvQeIQ=;
        b=S1beGnsOj0cOiq1qlsz0QabGLvvfifPdVJrPDqcPNNVycjn1m+dvTqpEGuy/mT1mGJ
         9cbW7VautzZCRSeYJmn5wys9Fz+Bxfqiu1LtDav3JZwECW7fcYFrm1GMdwM96pn9kGds
         YZZfdYh1rzVdWn6y73XTqoCa8BoumdoLeWWdnQYaMomYXkh0WshNtcUKygrIkfHaXwwG
         oqB8+zI2bOGhP3z1rGtx4uUK4hBxFp45JCgPzVGeAB/0gxS2eNo1tHNt7r5rDkyRsGv7
         NrmlPgMmP4hR2K88cMGU5ASzHdxYy31++OX/g5XIqiAFUx0IvnfeR/H/1RbOvd/Q47Y1
         Qt4g==
X-Gm-Message-State: ACrzQf1iWu5+RwVfRUBNEwQ6th5WlVfpNUi3HKmxbfxGTCEZukJ/J5uy
        CtXVoTyNFJGbj2hN+BI2aSv1SpIVuyvQZpiki1brVQ==
X-Google-Smtp-Source: AMsMyM4gKjiVotUUTEw6cVIgaeoEeSkvPyy3e6OcT7TREiftBFLOkv8FnVmHPtLNHJDd2rEp8WDYd1Y2NcEsDzWIVPI=
X-Received: by 2002:a2e:bf04:0:b0:26d:8fbf:5cb6 with SMTP id
 c4-20020a2ebf04000000b0026d8fbf5cb6mr280666ljr.246.1665077217430; Thu, 06 Oct
 2022 10:26:57 -0700 (PDT)
MIME-Version: 1.0
References: <CAHVum0cbWBXUnJ4s32Yn=TfPXLypv_RRT6LmA_QoBHw3Y+kA7w@mail.gmail.com>
 <877d1d9w0i.fsf@redhat.com>
In-Reply-To: <877d1d9w0i.fsf@redhat.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Thu, 6 Oct 2022 10:26:21 -0700
Message-ID: <CAHVum0eGri=Ro1uZMoN=bb61=tJwStcwV8rZAfgLk1w86bz7sA@mail.gmail.com>
Subject: Re: HvExtCallQueryCapabilities and HvExtCallGetBootZeroedMemory
 implementation in KVM for Windows guest
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, David Matlack <dmatlack@google.com>,
        Shujun Xue <shujunxue@google.com>,
        "yury.norov@gmail.com" <yury.norov@gmail.com>,
        sunilmut@microsoft.com, tianyu.lan@microsoft.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 6, 2022 at 1:49 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> Vipin Sharma <vipinsh@google.com> writes:
>
> > Hi Vitaly, Yury, Sunil, Tianyu
>
> Hi Vipin!
>
> >
> > Before I work on a patch series and send it out to the KVM mailing
> > list, I wanted to check with you a potential Windows VM optimization
> > and see if you have worked on it or if you know about some obvious
> > known blockers regarding this feature.
> >
> > Hypervisor Top-Level Functional Specification v6.0b mentions a hypercall:
> >
> >     HvExtCallGetBootZeroedMemory
> >     Call Code = 0x8002
> >
> > This hypercall can be used by Windows guest to know which pages are
> > already zeroed and then guest can avoid zeroing them again during the
> > boot, resulting in Windows VM faster boot time and less memory usage.
> >
> > KVM currently doesn't implement this feature. I am thinking of
> > implementing it, here is a rough code flow:
> > 1. KVM will set bit 20 in EBX of CPUID leaf 0x40000003 to let the
> > Windows guest know that it can use the extended hypercall interface.
> > 2. Guest during the boot will use hypercall HvExtCallQueryCapabilities
> > (Call Code = 0x8001) to see which extended calls are available.
> > 3. KVM will respond to guest that the hypercall
> > HvExtCallGetBootZeroedMemory is available.
> > 4. Guest will issue the hypercall HvExtCallGetBootZeroedMemory to know
> > which pages are zeroed.
> > 5. KVM or userspace VMM will respond with GPA and page count to guest.
>
> I think it's VMM's responsibility. How would KVM know if the memory
> allocated to the guest was zeroed or not?
>
> The easiest solution would be to just pass through this hypercall to the
> VMM and let it respond. Alternatively, we can probably add a flag to
> KVM_SET_USER_MEMORY_REGION to either indicate that the memory is zeroed
> or to actually ask KVM to zero it. This way we will have the required
> information in KVM. I'm not sure if it's worth it, Windows probably
> calls HvExtCallGetBootZeroedMemory just once upon boot so handling it in
> the VMM is totally fine.

I agree with you. Since, it is probably only upon boot time, handling
in VMM should be okay.

>
> > 6. Guest will skip zeroing these pages, resulting in faster boot and
> > less memory utilization of guest.
> >
> > This seems like a very easy win for KVM to increase Windows guest boot
> > performance but I am not sure if I am overlooking something. If you
> > are aware of any potential side effects of enabling these hypercalls
> > or some other issue I am not thinking about please let me know,
> > otherwise, I can start working on this feature and send RFC patches to
> > the mailing list.
>
> I dug through my git archives and found that I've actually tried
> HvExtCallQueryCapabilities back in 2018 but for some reason Windows
> versions I was testing didn't use it (hope it wasn't some silly mistake
> like forgotten CPUID bit on my part :-) so I put it aside and never got
> back to it. Thanks for picking this up!

Keeping my fingers crossed!

Thanks for the feedback.

>
> --
> Vitaly
>
