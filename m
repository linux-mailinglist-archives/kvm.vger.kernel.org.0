Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D074D255693
	for <lists+kvm@lfdr.de>; Fri, 28 Aug 2020 10:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728627AbgH1IiB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Aug 2020 04:38:01 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:42654 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726643AbgH1Ih7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Aug 2020 04:37:59 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 1976E5754D;
        Fri, 28 Aug 2020 08:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1598603876;
         x=1600418277; bh=Gjgx/ioVZb4BVqvQc8JDV4h/qFHzsMoK5ss0j4FzE6U=; b=
        gffdWNUWCEkucUQ8m7xnz5S7w3B0jkyAugdZ7BiI8XODzf/DsZiecMiLXY+pS5pO
        uAE4NkPAtsKUduhA54GrmVXUSYUV5MZmT673ng96ZeKBEBDrzQINYPtgaE6/4NHe
        pnwWNrLpb/OkauTvbSIHDefvU10ZhQWa5/rSUOJa30E=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 0AH6hwVikZEX; Fri, 28 Aug 2020 11:37:56 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 1E90A5754A;
        Fri, 28 Aug 2020 11:37:55 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Fri, 28
 Aug 2020 11:37:54 +0300
Date:   Fri, 28 Aug 2020 11:37:54 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     Thomas Huth <thuth@redhat.com>
CC:     <kvm@vger.kernel.org>, Cameron Esfahani <dirty@apple.com>
Subject: Re: [kvm-unit-tests PATCH 1/7] x86: Makefile: Allow division on
 x86_64-elf binutils
Message-ID: <20200828083754.GE54274@SPB-NB-133.local>
References: <20200810130618.16066-1-r.bolshakov@yadro.com>
 <20200810130618.16066-2-r.bolshakov@yadro.com>
 <ee81540c-9064-4650-8784-d4531eec042c@redhat.com>
 <20200828065417.GA54274@SPB-NB-133.local>
 <e3589b43-df3f-b413-a3b9-1f032da48571@redhat.com>
 <20200828074745.GC54274@SPB-NB-133.local>
 <ec1e66df-21bc-4d85-05fc-1b54b5a2bf1f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ec1e66df-21bc-4d85-05fc-1b54b5a2bf1f@redhat.com>
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 28, 2020 at 09:56:28AM +0200, Thomas Huth wrote:
> On 28/08/2020 09.47, Roman Bolshakov wrote:
> > On Fri, Aug 28, 2020 at 09:24:10AM +0200, Thomas Huth wrote:
> >> On 28/08/2020 08.54, Roman Bolshakov wrote:
> >>> On Fri, Aug 28, 2020 at 07:00:19AM +0200, Thomas Huth wrote:
> >>>> On 10/08/2020 15.06, Roman Bolshakov wrote:
> >>>>> For compatibility with other SVR4 assemblers, '/' starts a comment on
> >>>>> *-elf binutils target and thus division operator is not allowed [1][2].
> >>>>> That breaks cstart64.S build:
> >>>>>
> >>>>>   x86/cstart64.S: Assembler messages:
> >>>>>   x86/cstart64.S:294: Error: unbalanced parenthesis in operand 1.
> >>>>>
> >>>>> The option is ignored on the Linux target of GNU binutils.
> >>>>>
> >>>>> 1. https://sourceware.org/binutils/docs/as/i386_002dChars.html
> >>>>> 2. https://sourceware.org/binutils/docs/as/i386_002dOptions.html#index-_002d_002ddivide-option_002c-i386
> >>>>>
> >>>>> Cc: Cameron Esfahani <dirty@apple.com>
> >>>>> Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
> >>>>> ---
> >>>>>  x86/Makefile | 2 ++
> >>>>>  1 file changed, 2 insertions(+)
> >>>>>
> >>>>> diff --git a/x86/Makefile b/x86/Makefile
> >>>>> index 8a007ab..22afbb9 100644
> >>>>> --- a/x86/Makefile
> >>>>> +++ b/x86/Makefile
> >>>>> @@ -1 +1,3 @@
> >>>>>  include $(SRCDIR)/$(TEST_DIR)/Makefile.$(ARCH)
> >>>>> +
> >>>>> +COMMON_CFLAGS += -Wa,--divide
> >>>>
> >>>> Some weeks ago, I also played with an elf cross compiler and came to the
> >>>> same conclusion, that we need this option there. Unfortunately, it does
> >>>> not work with clang:
> >>>>
> >>>>  https://gitlab.com/huth/kvm-unit-tests/-/jobs/707986800#L1629
> >>>>
> >>>> You could try to wrap it with "cc-option" instead ... or use a proper
> >>>> check in the configure script to detect whether it's needed or not.
> >>>>
> >>>
> >>> Hi Thomas,
> >>>
> >>> Thanks for reviewing the series. I'll look into both options and will
> >>> test with both gcc and clang afterwards. I can also update .travis.yml
> >>> in a new patch to test the build on macOS.
> >>
> >> That would be great, thanks! Note that you need at least Clang v10 (the
> >> one from Fedora 32 is fine) to compile the kvm-unit-tests.
> >>
> >> And if it's of any help, this was the stuff that I used in .travis.yml
> >> for my experiments (might still be incomplete, though):
> >>
> >>     - os: osx
> >>       osx_image: xcode12
> >>       addons:
> >>         homebrew:
> >>           packages:
> >>             - bash
> >>             - coreutils
> >>             - qemu
> >>             - x86_64-elf-gcc
> >>       env:
> >>       - CONFIG="--cross-prefix=x86_64-elf-"
> >>       - BUILD_DIR="build"
> >>       - TESTS="umip"
> >>       - ACCEL="tcg"
> >>
> >>     - os: osx
> >>       osx_image: xcode12
> >>       addons:
> >>         homebrew:
> >>           packages:
> >>             - bash
> >>             - coreutils
> >>             - qemu
> >>             - i386-elf-gcc
> > 
> > It's going to be i686-elf-gcc.
> 
> Ah, there are two flavours? Ok, good to know.
> 

i386-elf-gcc package was configured as x86_64-pc-elf target and then was
renamed to x86_64-elf-gcc to match GCC target name (last December or in
January).

x86_64_elf-gcc can't properly link 32-bit ELF binaries because of GCC
PR16470
(https://gcc.gnu.org/bugzilla/show_bug.cgi?id=16470), PR32044
(https://gcc.gnu.org/bugzilla/show_bug.cgi?id=32044). A cross-compiler
is needed for that, that's why i686-elf-gcc was added in June/May:

https://github.com/Homebrew/homebrew-core/pull/54946/commits/94ee559e6c6284539f74662a85ec20c174436677

But as far as I understand i686-pc-elf target is the same as i386-pc-elf
in GCC/binutils (according to code inspection and a following discussion
freenode's #gcc channel).

FWIW, i686-elf-gcc can be installed in parallel with x86_64-elf-gcc.

Thanks,
Roman
