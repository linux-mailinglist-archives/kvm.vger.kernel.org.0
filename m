Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE8F501EF7
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 01:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347513AbiDNXYR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 19:24:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242046AbiDNXYP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 19:24:15 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12486B8985
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 16:21:49 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id u29so2418613pfg.7
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 16:21:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=eZSMaHVoqT9ySfaPjWWUxErMqhnAV6RP7Xt22+7qSpE=;
        b=GwTHI0whS+GudzUXxDlT7R/rxGG7MLjsPzDcXeVAAbRy2Ov99jrtHy8huKZ78fb6M4
         bZlbprkalqPEAcBACLxDC561QYmrqVH/dCWoynsAnm7TaXLwf4eby5RKleM2Gx1zAF5v
         8aoNoypEVrWmTSLDR1ezsJXzMVo5pcKiI1m8i0jV6l4dqJ9PuphPTp/5fMROBOD8Z8Sh
         7OonSlkOf2P/kDcZMP2rQr3kbg06Km8Hl0KmBAlPIG91i7G+caRpGeTsb2PEFOV08D/H
         uWXz16B6NkEO9YulnnRdyBbxvyw/9Gq2oYtLZIX/Y+DBrwREoKDcAJiM5iJY0iqfLmCc
         MVeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=eZSMaHVoqT9ySfaPjWWUxErMqhnAV6RP7Xt22+7qSpE=;
        b=HQ6jS4Qb3d8pXgg4Xx6/IJ4+RATGsxkrIbTB2Bbs7LpZC1oWQ30rI9Lh7cSLTL2urK
         K5fbDbdRLhern++1uwsiEM5SnIwjIncHMFaEVaymQsq0MEQGbfVCeMj9f9NV6gKqMAzU
         JtVN8Qkgw/Ar2V7sE78+sglsssYAjuqvy5xG1vnWK0KWr8Dv0cmfGoDEPoNP2IhGHO3P
         Iw9XYa23FuNHYSNtz0lTU1xWpD9inFtgrK2cJDqNwQ5/9+zuOhDslYxizVZcRVmM8VxX
         zRHQE7VtGsvQvIPBr6vyBS4iW+0vb8FBZm1CX4PKyrBpH3J4wjQIFQ9Cd6pYPl/z7Igr
         tvIw==
X-Gm-Message-State: AOAM531H0fNd3pI1MzfIBUQ6DOytB958r59PMyJBbAGr/UcBSztT0FTz
        A/yCRkm8CvSc0ChE6yfeGSaFTQ==
X-Google-Smtp-Source: ABdhPJz2SQdvJSpca+DnY5qvEoTN2B3E4/fHSw7/pl7LTz8w1R5u7xjJ5gFdJDh8LbkpXlvqd6C+ow==
X-Received: by 2002:a63:c144:0:b0:399:3e75:1d55 with SMTP id p4-20020a63c144000000b003993e751d55mr4121743pgi.199.1649978508429;
        Thu, 14 Apr 2022 16:21:48 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id d139-20020a621d91000000b00505aa0d10desm921742pfd.0.2022.04.14.16.21.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 16:21:47 -0700 (PDT)
Date:   Thu, 14 Apr 2022 23:21:44 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Will Deacon <will@kernel.org>, Peter Gonda <pgonda@google.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Anup Patel <anup@brainfault.org>, maz@kernel.org,
        Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v4.1] KVM, SEV: Add KVM_EXIT_SHUTDOWN metadata for SEV-ES
Message-ID: <YlisiF4BU6Uxe+iU@google.com>
References: <20220407210233.782250-1-pgonda@google.com>
 <Yk+kNqJjzoJ9TWVH@google.com>
 <CAMkAt6oc=SOYryXu+_w+WZR+VkMZfLR3_nd=hDvMU_cmOjJ0Xg@mail.gmail.com>
 <YlBqYcXFiwur3zmo@google.com>
 <20220411091213.GA2120@willie-the-truck>
 <YlQ0LZyAgjGr7qX7@e121798.cambridge.arm.com>
 <YlREEillLRjevKA2@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YlREEillLRjevKA2@google.com>
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

PAOLO!!!!!!

Or maybe I need to try the Beetlejuice trick...

Paolo, Paolo, Paolo.

This is now sitting in kvm/next, which makes RISC-V and arm64 unhappy.  Thoughts
on how to proceed?

arch/riscv/kvm/vcpu_sbi.c: In function ‘kvm_riscv_vcpu_sbi_system_reset’:
arch/riscv/kvm/vcpu_sbi.c:97:26: error: ‘struct <anonymous>’ has no member named ‘flags’
   97 |         run->system_event.flags = flags;
      |                          ^


On Mon, Apr 11, 2022, Sean Christopherson wrote:
> On Mon, Apr 11, 2022, Alexandru Elisei wrote:
> > Hi,
> >
> > On Mon, Apr 11, 2022 at 10:12:13AM +0100, Will Deacon wrote:
> > > Hi Sean,
> > >
> > > Cheers for the heads-up.
> > >
> > > [+Marc and Alex as this looks similar to [1]]
> > >
> > > On Fri, Apr 08, 2022 at 05:01:21PM +0000, Sean Christopherson wrote:
> > > > system_event.flags is broken (at least on x86) due to the prior 'type' field not
> > > > being propery padded, e.g. userspace will read/write garbage if the userspace
> > > > and kernel compilers pad structs differently.
> > > >
> > > >           struct {
> > > >                   __u32 type;
> > > >                   __u64 flags;
> > > >           } system_event;
> > >
> > > On arm64, I think the compiler is required to put the padding between type
> > > and flags so that both the struct and 'flags' are 64-bit aligned [2]. Does
> > > x86 not offer any guarantees on the overall structure alignment?
> >
> > This is also my understanding. The "Procedure Call Standard for the Arm
> > 64-bit Architecture" [1] has these rules for structs (called "aggregates"):
> 
> AFAIK, all x86 compilers will pad structures accordingly, but a 32-bit userspace
> running against a 64-bit kernel will have different alignment requirements, i.e.
> won't pad, and x86 supports CONFIG_KVM_COMPAT=y.  And I have no idea what x86's
> bizarre x32 ABI does.
> 
> > > > Our plan to unhose this is to change the struct as follows and use bit 31 in the
> > > > 'type' to indicate that ndata+data are valid.
> > > >
> > > >           struct {
> > > >                         __u32 type;
> > > >                   __u32 ndata;
> > > >                   __u64 data[16];
> > > >                 } system_event;
> > > >
> > > > Any objection to updating your architectures to use a helper to set the bit and
> > > > populate ndata+data accordingly?  It'll require a userspace update, but v5.18
> > > > hasn't officially released yet so it's not kinda sort not ABI breakage.
> > >
> > > It's a bit annoying, as we're using the current structure in Android 13 :/
> > > Obviously, if there's no choice then upstream shouldn't worry, but it means
> > > we'll have to carry a delta in crosvm. Specifically, the new 'ndata' field
> > > is going to be unusable for us because it coincides with the padding.
> 
> Yeah, it'd be unusuable for existing types.  One idea is that we could define the
> ABI to be that the RESET and SHUTDOWN types have an implicit ndata=1 on arm64 and
> RISC-V.  That would allow keeping the flags interpretation and so long as crosvm
> doesn't do something stupid like compile with "pragma pack" (does clang even support
> that?), there's no delta necessary for Android.
> 
> > Just a thought, but wouldn't such a drastical change be better implemented
> > as a new exit_reason and a new associated struct?
> 
> Maybe?  I wasn't aware that arm64/RISC-V picked up usage of "flags" when I
> suggested this, but I'm not sure it would have changed anything.  We could add
> SYSTEM_EVENT2 or whatever, but since there's no official usage of flags, it seems
> a bit gratutious.
