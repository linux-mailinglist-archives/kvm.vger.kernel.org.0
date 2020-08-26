Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11525253575
	for <lists+kvm@lfdr.de>; Wed, 26 Aug 2020 18:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbgHZQwi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Aug 2020 12:52:38 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:60794 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726739AbgHZQw3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Aug 2020 12:52:29 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id F3AB757516;
        Wed, 26 Aug 2020 16:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1598460736;
         x=1600275137; bh=i99MIP9MUcyxXBxy+VjBvjNwuYnvlahI7EoiTWJZp0Y=; b=
        uYiTsfW/tP45enGN0RS4Sb92Hr4hAiLXZ0xH+dRAczCmcNPNaPD9aufqUnzhDtFe
        GLduaml5o0z4Cuhp7I1ZNZhzuNaXkgU+Laxb1LSuKHhgPvbrq+HNFF/wAfhsPtyw
        eDLAkZkQHhfqAX0mwlByOvgwNCNuVqRO43SURqjp8fc=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ulN_RArD99Qg; Wed, 26 Aug 2020 19:52:16 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id E42CC574F6;
        Wed, 26 Aug 2020 19:52:16 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Wed, 26
 Aug 2020 19:52:16 +0300
Date:   Wed, 26 Aug 2020 19:52:15 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH 0/7] Add support for generic ELF
 cross-compiler
Message-ID: <20200826165215.GA16356@SPB-NB-133.local>
References: <20200810130618.16066-1-r.bolshakov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200810130618.16066-1-r.bolshakov@yadro.com>
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 10, 2020 at 04:06:11PM +0300, Roman Bolshakov wrote:
> The series introduces a way to build the tests with generic i686-pc-elf
> and x86_64-pc-elf GCC target. It also fixes build on macOS and
> introduces a way to specify enhanced getopt. Build instructions for macOS
> have been updated to reflect the changes.
> 
> Roman Bolshakov (7):
>   x86: Makefile: Allow division on x86_64-elf binutils
>   x86: Replace instruction prefixes with spaces
>   x86: Makefile: Fix linkage of realmode on x86_64-elf binutils
>   lib: Bundle debugreg.h from the kernel
>   lib: x86: Use portable format macros for uint32_t
>   configure: Add an option to specify getopt
>   README: Update build instructions for macOS
> 
>  README.macOS.md        | 71 +++++++++++++++++++++++++-----------
>  configure              | 13 +++++++
>  lib/pci.c              |  2 +-
>  lib/x86/asm/debugreg.h | 81 ++++++++++++++++++++++++++++++++++++++++++
>  run_tests.sh           |  2 +-
>  x86/Makefile           |  2 ++
>  x86/Makefile.common    |  3 +-
>  x86/asyncpf.c          |  2 +-
>  x86/cstart.S           |  4 +--
>  x86/cstart64.S         |  4 +--
>  x86/emulator.c         | 38 ++++++++++----------
>  x86/msr.c              |  3 +-
>  x86/s3.c               |  2 +-
>  13 files changed, 178 insertions(+), 49 deletions(-)
>  create mode 100644 lib/x86/asm/debugreg.h
> 
> -- 
> 2.26.1
> 

Hi Paolo,

could you please take a look?

Best Regards,
Roman
