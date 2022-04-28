Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA1751286D
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 03:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236234AbiD1BFT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 21:05:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbiD1BFR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 21:05:17 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16B9213DC0
        for <kvm@vger.kernel.org>; Wed, 27 Apr 2022 18:02:05 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id u9so2384567plf.6
        for <kvm@vger.kernel.org>; Wed, 27 Apr 2022 18:02:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gGGuSc0LSBpuNtbaK3b654kpekt8+afyXub7g//oygQ=;
        b=lfN+Nhqc2aJ4rKKRp29t9F072aKzevhDma4KY5PS1Z/oIl/YgaJt1bXV+Qghxx6s0e
         dXntgAWGVNC6Y4bxz9ls0y/VdHGaZ9PgdmVNvcdsvCfWV4w4bV4pS43+dT3k6bq0N97q
         mn2BLHfNh93NYHcrOtUbs3g370CwDKhkNY0xqKp6HDoIMf0MohHESw8owRmF56Q1KJZl
         tKwh+sE3tnkwAPlIfglLpZZjQFx2vx+2GBqiLJqdln9Ji4yMbzZqIJ3Akk2OMeGLcJHg
         +0kHO5wjo5AlS2L0n6lBNDuccRTU0SzPLtNB7HBzNcvetMpbt+rN8Xsy+uwFbXD5Tkyc
         xBKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gGGuSc0LSBpuNtbaK3b654kpekt8+afyXub7g//oygQ=;
        b=FoGdCV1KyfPTJhxY3gVRPFy6gaUALlaaLB+xInCgrDsYKghoRuntsGsqDIGs5ORKeF
         1J05ZDdyKQQpMoklTnin/ta0irWdMNNGCmW/AvnPprhX/cQ0tL4KvnG53l4c3HPr9XhT
         ZWC3NGornIwaeGuNV0ubIkMXdt6KC2tUj4mNB/OlRlwNKWfYTIK1udubxMIp8HVsEV8c
         uj8447IZO5MizMQy3lWI/13sT5bkUeR00B9zRoq5XSPkEzy2sFxoSqie726+z9ffucTR
         maxwQT85AcXl9x7ugjSjgC1qFCkPTjt4eYPhgpClBzTohDJdRSL5/oi+gy44C7prclPB
         KtWg==
X-Gm-Message-State: AOAM533e++oXtbZ1pR6osdjRzg7gHvhP9WAlNaAs7OMNhe0in7cxHHe5
        mggf0Gz76XOdnzal0HATyHrDp062oAtUs+1GCYnzfw==
X-Google-Smtp-Source: ABdhPJzjke2ZEb+yF7GVfe3sX27nyy/kmsf+yglPd7alvwRgx2AoojnzZ+0Ix57E6s7+ew5bxxyRUl/ZtqkXCCwM560=
X-Received: by 2002:a17:902:da81:b0:15d:37b9:70df with SMTP id
 j1-20020a170902da8100b0015d37b970dfmr10897086plx.34.1651107724585; Wed, 27
 Apr 2022 18:02:04 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1649219184.git.kai.huang@intel.com> <522e37eb-68fc-35db-44d5-479d0088e43f@intel.com>
In-Reply-To: <522e37eb-68fc-35db-44d5-479d0088e43f@intel.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 27 Apr 2022 18:01:53 -0700
Message-ID: <CAPcyv4g5E_TOow=3pFJXyFr=KLV9pTSnDthgz6TuXvru4xDzaQ@mail.gmail.com>
Subject: Re: [PATCH v3 00/21] TDX host kernel support
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Kai Huang <kai.huang@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Rafael J Wysocki <rafael.j.wysocki@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <ak@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 26, 2022 at 1:10 PM Dave Hansen <dave.hansen@intel.com> wrote:
[..]
> > 3. Memory hotplug
> >
> > The first generation of TDX architecturally doesn't support memory
> > hotplug.  And the first generation of TDX-capable platforms don't support
> > physical memory hotplug.  Since it physically cannot happen, this series
> > doesn't add any check in ACPI memory hotplug code path to disable it.
> >
> > A special case of memory hotplug is adding NVDIMM as system RAM using

Saw "NVDIMM" mentioned while browsing this, so stopped to make a comment...

> > kmem driver.  However the first generation of TDX-capable platforms
> > cannot enable TDX and NVDIMM simultaneously, so in practice this cannot
> > happen either.
>
> What prevents this code from today's code being run on tomorrow's
> platforms and breaking these assumptions?

The assumption is already broken today with NVDIMM-N. The lack of
DDR-T support on TDX enabled platforms has zero effect on DDR-based
persistent memory solutions. In other words, please describe the
actual software and hardware conflicts at play here, and do not make
the mistake of assuming that "no DDR-T support on TDX platforms" ==
"no NVDIMM support".

> > Another case is admin can use 'memmap' kernel command line to create
> > legacy PMEMs and use them as TD guest memory, or theoretically, can use
> > kmem driver to add them as system RAM.  To avoid having to change memory
> > hotplug code to prevent this from happening, this series always include
> > legacy PMEMs when constructing TDMRs so they are also TDX memory.

I am not sure what you are trying to say here?

> > 4. CPU hotplug
> >
> > The first generation of TDX architecturally doesn't support ACPI CPU
> > hotplug.  All logical cpus are enabled by BIOS in MADT table.  Also, the
> > first generation of TDX-capable platforms don't support ACPI CPU hotplug
> > either.  Since this physically cannot happen, this series doesn't add any
> > check in ACPI CPU hotplug code path to disable it.

What are the actual challenges posed to TDX with respect to CPU hotplug?

> > Also, only TDX module initialization requires all BIOS-enabled cpus are

Please define "BIOS-enabled" cpus. There is no "BIOS-enabled" line in
/proc/cpuinfo for example.
