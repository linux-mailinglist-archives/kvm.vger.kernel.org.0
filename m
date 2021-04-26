Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3812036B01A
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 10:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232541AbhDZJAE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 05:00:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52049 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232504AbhDZJAA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Apr 2021 05:00:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619427559;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Epl8ZIucjNRdHe1jXHsga/3GfhhLNjAVq6yo9ieGPXs=;
        b=EKwbwsJnBdHavtlyOnSQlEKPJMIWdkhgLCx4TaGoq3y6fQ5j8N9qTpk08gIv2KqKs/Qqy9
        krkAs7c04RRD5VTMfedXpoE63d4C9c0eHVV3VD7yNTDtCH3u+aU8BnbSeFws5E0CU7+rY0
        tdkduezBY9v6aL5sxg/W7Ond+YhgAY0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-135-5fNZhVfRMrOaNnv8w60eSQ-1; Mon, 26 Apr 2021 04:59:16 -0400
X-MC-Unique: 5fNZhVfRMrOaNnv8w60eSQ-1
Received: by mail-wr1-f71.google.com with SMTP id 88-20020adf95610000b029010758d8d7e2so7047503wrs.19
        for <kvm@vger.kernel.org>; Mon, 26 Apr 2021 01:59:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Epl8ZIucjNRdHe1jXHsga/3GfhhLNjAVq6yo9ieGPXs=;
        b=BEZlqZUazMMMCNa7yeAXnyCZL/66HaLrvQIspiIJfsJJ13RoKWmQgr/rpOC8N8KIYi
         YAiZhPnnVJi2qrNnvGek8cebC1abcAn81TF8YLUvQNgvGu8pXUyppLn3vmuWbfGuDXa1
         4vIUFtQNRQJLlVvyVt488leg/4AIEK86L0xeSlTqEcFNF7lUvtuUHWFDlhdAzpN/kXfL
         uA7iRdI2pSuS7hUEm+kbN3oeEUwnIDNMscVwaRt8NX6pK3wwwSRjLxTR270fiSB+g+ko
         0WaWDMMWNhF3jy5U8NUWtUUUdukPpB/iIBZxlzimHRmViP/UoRDpaXbV9zXpprkva63B
         Vm7Q==
X-Gm-Message-State: AOAM530dQKoJxCxqlnH+DoptU9N+bGHpEvghLHTZQvXTI+hFi0LJPb98
        tevX3bxRWD9xPUQZWBiuYFdvOpS9ZcWYK/VWQPQ3EneLumjPG6f0mS3bGqV6F5NzP59bk+9nO9i
        K8SvTL7GepKmc
X-Received: by 2002:a5d:47af:: with SMTP id 15mr21796272wrb.234.1619427555462;
        Mon, 26 Apr 2021 01:59:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJziTF4KtWLs4Sczh807QMr4lICITI2JNXavL1dzS9Q/EKccrdm/nMG2NDnJnY4RG1uKoqwDnA==
X-Received: by 2002:a5d:47af:: with SMTP id 15mr21796257wrb.234.1619427555235;
        Mon, 26 Apr 2021 01:59:15 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id j7sm3404625wmi.21.2021.04.26.01.59.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 01:59:14 -0700 (PDT)
Date:   Mon, 26 Apr 2021 10:59:11 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com
Subject: Re: [kvm-unit-tests RFC PATCH 0/1] configure: arm: Replace --vmm
 with --target
Message-ID: <20210426085911.jkkuj53jsajbjmi5@gator>
References: <20210420161338.70914-1-alexandru.elisei@arm.com>
 <20210420165101.irbx2upgqbazkvlt@gator.home>
 <ed3ba802-fee7-4c58-9d73-d33dfbd44d7f@arm.com>
 <20210422155757.t4pvv6blkvoyi2oy@gator>
 <854c2d33-0b20-b7e3-c522-b01a53fcbbb3@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <854c2d33-0b20-b7e3-c522-b01a53fcbbb3@arm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 23, 2021 at 04:43:14PM +0100, Alexandru Elisei wrote:
> Hi Drew,
> 
> On 4/22/21 4:57 PM, Andrew Jones wrote:
> > On Thu, Apr 22, 2021 at 04:17:27PM +0100, Alexandru Elisei wrote:
> >> Hi Drew,
> >>
> >> On 4/20/21 5:51 PM, Andrew Jones wrote:
> >>> Hi Alex,
> >>>
> >>> On Tue, Apr 20, 2021 at 05:13:37PM +0100, Alexandru Elisei wrote:
> >>>> This is an RFC because it's not exactly clear to me that this is the best
> >>>> approach. I'm also open to using a different name for the new option, maybe
> >>>> something like --platform if it makes more sense.
> >>> I like 'target'.
> >>>
> >>>> I see two use cases for the patch:
> >>>>
> >>>> 1. Using different files when compiling kvm-unit-tests to run as an EFI app
> >>>> as opposed to a KVM guest (described in the commit message).
> >>>>
> >>>> 2. This is speculation on my part, but I can see extending
> >>>> arm/unittests.cfg with a "target" test option which can be used to decide
> >>>> which tests need to be run based on the configure --target value. For
> >>>> example, migration tests don't make much sense on kvmtool, which doesn't
> >>>> have migration support. Similarly, the micro-bench test doesn't make much
> >>>> sense (to me, at least) as an EFI app. Of course, this is only useful if
> >>>> there are automated scripts to run the tests under kvmtool or EFI, which
> >>>> doesn't look likely at the moment, so I left it out of the commit message.
> >>> Sounds like a good idea. unittests.cfg could get a new option 'targets'
> >>> where a list of targets is given. If targets is not present, then the
> >>> test assumes it's for all targets. Might be nice to also accept !<target>
> >>> syntax. E.g.
> >>>
> >>> # builds/runs for all targets
> >>> [mytest]
> >>> file = mytest.flat
> >>>
> >>> # builds/runs for given targets
> >>> [mytest2]
> >>> file = mytest2.flat
> >>> targets = qemu,kvmtool
> >>>
> >>> # builds/runs for all targets except disabled targets
> >>> [mytest3]
> >>> file = mytest3.flat
> >>> targets = !kvmtool
> >> That's sounds like a good idea, but to be honest, I would wait until someone
> >> actually needs it before implementing it. That way we don't risk not taking a use
> >> case into account and then having to rework it.
> > Don't we have a usecase? Above you said that kvmtool should at least skip
> > the migration tests.
> 
> Sorry for not making myself clear, when I was talking about adding a "targets"
> parameter to a test, I was thinking that it will only be used by the run scripts.
> All the tests can run under qemu, and run_tests.sh only knows about qemu, so, from
> that point of view, that's why I think the "targets" argument is not useful at the
> moment.
> 
> As for the migration test specifically, the VM migration is implemented in the run
> scripts, not in the test itself; the test waits for the UART to signal that
> migration is complete. That test runs just fine under kvmtool, but no migration is
> taking place:
> 
> $ ./vm run --irqchip=gicv3-its -c6 -m128 -f arm/gic.flat --params its-migration
>   # lkvm run --firmware arm/gic.flat -m 128 -c 6 --name guest-1440
>   Info: Placing fdt at 0x80200000 - 0x80210000
> chr_testdev_init: chr-testdev: can't find a virtio-console
> ITS: MAPD devid=2 size = 0x8 itt=0x801e0000 valid=1
> ITS: MAPD devid=7 size = 0x8 itt=0x801f0000 valid=1
> MAPC col_id=3 target_addr = 0x30000 valid=1
> MAPC col_id=2 target_addr = 0x20000 valid=1
> INVALL col_id=2
> INVALL col_id=3
> MAPTI dev_id=2 event_id=20 -> phys_id=8195, col_id=3
> MAPTI dev_id=7 event_id=255 -> phys_id=8196, col_id=2
> Now migrate the VM, then press a key to continue...
> INFO: gicv3: its-migration: Migration complete
> INT dev_id=2 event_id=20
> PASS: gicv3: its-migration: dev2/eventid=20 triggers LPI 8195 on PE #3 after migration
> INT dev_id=7 event_id=255
> PASS: gicv3: its-migration: dev7/eventid=255 triggers LPI 8196 on PE #2 after
> migration
> SUMMARY: 2 tests
> 
> Even the pci-test works under kvmtool, even though it targets qemu's pci-testdev:
> 
> $ ./vm run --irqchip=gicv3-its -c6 -m128 -f arm/pci-test.flat
>   # lkvm run --firmware arm/pci-test.flat -m 128 -c 6 --name guest-1468
>   Info: Placing fdt at 0x80200000 - 0x80210000
> chr_testdev_init: chr-testdev: can't find a virtio-console
> No PCIe ECAM compatible controller found
> PCI bus probing failed, skipping tests...
> SUMMARY: 0 tests
> 
> The test is still useful for kvmtool, because it tests that the PCI node in the
> DTB is generated as expected. And after kvmtool gets support for PCIE (work in
> progress), it will test PCI device probing, which makes it even more useful than
> it is today.
> 
> So I guess the question is, do what should "targets" represent, how should it be
> used and do we need it now?

I'll leave that up to you, since you're the one driving support for
kvmtool and, hopefully soon, bare-metal AArch64. BTW, I think we're long
overdue for adding kvmtool runner functionality, either by adapting what
we have (possibly by applying a TARGET variable :-) or by simply adding
new runner scripts. I personally would like to easily run kvmtool when
I'm testing arm/queue, and I don't want to have my own personal kvmtool
runner script to do that.

> 
> >
> >>> And it wouldn't bother me to have special logic for kvmtool's lack of
> >>> migration put directly in scripts/runtime.bash
> >> Good to keep in mind when support is added.
> >>
> >>> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> >>> index 132389c7dd59..0d5cb51df4f4 100644
> >>> --- a/scripts/runtime.bash
> >>> +++ b/scripts/runtime.bash
> >>> @@ -132,7 +132,7 @@ function run()
> >>>      }
> >>>  
> >>>      cmdline=$(get_cmdline $kernel)
> >>> -    if grep -qw "migration" <<<$groups ; then
> >>> +    if grep -qw "migration" <<<$groups && [ "$TARGET" != "kvmtool" ]; then
> >>>          cmdline="MIGRATION=yes $cmdline"
> >>>      fi
> >>>      if [ "$verbose" = "yes" ]; then
> >>>
> >>>> Using --vmm will trigger a warning. I was thinking about removing it entirely in
> >>>> a about a year's time, but that's not set in stone. Note that qemu users
> >>>> (probably the vast majority of people) will not be affected by this change as
> >>>> long as they weren't setting --vmm explicitely to its default value of "qemu".
> >>>>
> >>> While we'd risk automated configure+build tools, like git{hub,lab} CI,
> >>> failing, I think the risk is pretty low right now that anybody is using
> >>> the option. Also, we might as well make them change sooner than later by
> >>> failing configure. IOW, I'd just do s/vmm/target/g to rename it now. If
> >>> we are concerned about the disruption, then I'd just make vmm an alias
> >>> for target and not bother deprecating it ever.
> >> I also think it will not be too bad if we make the change now, but I'm not sure
> >> what you mean by making vmm an alias of target. The patch ignores --vmm is it's
> >> not specified, and if it is specified on the configure command line, then it must
> >> match the value of --target, otherwise configure fails.
> >>
> > The current patch does both things; it says don't use --vmm and it says
> > the new --vmm is --target. I'm saying do one or the other. Either
> > completely rename vmm to target, which will then error out when vmm is
> > specified as an unknown option or allow the user to use either --vmm or
> > --target with no error and where both mean to do the same thing, which is
> > to set the TARGET variable.
> 
> I'm sorry, but it's still not clear to me what you are trying to say.
> 
> The current behaviour:
> 
> $ ./configure --arch=arm64 --cross-prefix=aarch64-linux-gnu- --vmm=qemu
> INFO: --vmm is deprecated and will be removed in future versions
> $ ./configure --arch=arm64 --cross-prefix=aarch64-linux-gnu- --vmm=qemu --target=qemu
> INFO: --vmm is deprecated and will be removed in future versions
> $ ./configure --arch=arm64 --cross-prefix=aarch64-linux-gnu- --vmm=kvmtool
> --target=qemu
> INFO: --vmm is deprecated and will be removed in future versions
> --vmm must have the same value as --target (qemu)
> Usage: ./configure [options]
> [..]
> $ ./configure --arch=arm64 --cross-prefix=aarch64-linux-gnu- --vmm=kvmtool
> --target=kvmtool
> INFO: --vmm is deprecated and will be removed in future versions
> 
> Can you point out what makes you think that the patch tries to do two things at once?

Deprecation requires you do two things at once; add a warning to the old
and add the new. I'm saying we don't need to deprecate --vmm. Either just
do the new (s/vmm/target/g) or always allow the old (s/vmm/target/g plus
make --vmm an alias for --target without any warning). I'd prefer the
first one, since I'm not too worried about a few users having to figure
out how to change their muscle memory and CI scripts when they start
getting unknown option errors at configure time.

Thanks,
drew

