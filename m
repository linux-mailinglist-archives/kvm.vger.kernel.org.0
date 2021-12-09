Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD1B46E732
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 12:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233033AbhLILDs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 06:03:48 -0500
Received: from foss.arm.com ([217.140.110.172]:54196 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232628AbhLILDr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 06:03:47 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 82FD71FB;
        Thu,  9 Dec 2021 03:00:14 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7C6683F73B;
        Thu,  9 Dec 2021 03:00:13 -0800 (PST)
Date:   Thu, 9 Dec 2021 11:00:09 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     "haibiao.xiao" <haibiao.xiao@zstack.io>
Cc:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com,
        "haibiao.xiao" <xiaohaibiao331@outlook.com>
Subject: Re: [PATCH kvmtool] Makefile: 'lvm version' works incorrect. Because
 CFLAGS can not get sub-make variable $(KVMTOOLS_VERSION)
Message-ID: <YbHhuXwJFCGTBAPB@monolith.localdoman>
References: <20211204061436.36642-1-haibiao.xiao@zstack.io>
 <YbDfecTFlOfPIUs4@monolith.localdoman>
 <a6810407-e9b5-e377-a0bf-ee137d7e5638@zstack.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6810407-e9b5-e377-a0bf-ee137d7e5638@zstack.io>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Thu, Dec 09, 2021 at 11:31:58AM +0800, haibiao.xiao wrote:
> Hi,
> 
> Thanks for your reply. I'd like to changed the subject line 
> as you suggested. But I don't know how to deal with it, 
> should I send another patch mail?

Yes, please send version 2 of the patch. The subject line for the email
should changed to (notice the extra v2):

[PATCH v2 kvmtool] <your summary here>

You can put the Tested-by tag after your Signed-off.

Thanks,
Alex

> 
> Thanks,
> haibiao.xiao
> 
> On Wed, 8 Dec 2021 16:38:17 +0000, Alexandru Elisei wrote:
> > Hi,
> > 
> > On Sat, Dec 04, 2021 at 02:14:36PM +0800, haibiao.xiao wrote:
> >> From: "haibiao.xiao" <xiaohaibiao331@outlook.com>
> > 
> > The subject line should be a summary of what the patch does (and perhaps
> > why it does it), not a description of what is broken. How about this:
> > 
> > Makefile: Calculate the correct kvmtool version
> > 
> > or something else that you prefer. Tested the patch and it works as
> > advertised:
> > 
> > Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > 
> > Thanks,
> > Alex
> > 
> >>
> >> Command 'lvm version' works incorrect.
> >> It is expected to print:
> >>
> >>     # ./lvm version
> >>     # kvm tool [KVMTOOLS_VERSION]
> >>
> >> but the KVMTOOLS_VERSION is missed:
> >>
> >>     # ./lvm version
> >>     # kvm tool
> >>
> >> The KVMTOOLS_VERSION is defined in the KVMTOOLS-VERSION-FILE file which
> >> is included at the end of Makefile. Since the CFLAGS is a 'Simply
> >> expanded variables' which means CFLAGS is only scanned once. So the
> >> definetion of KVMTOOLS_VERSION at the end of Makefile would not scanned
> >> by CFLAGS. So the '-DKVMTOOLS_VERSION=' remains empty.
> >>
> >> I fixed the bug by moving the '-include $(OUTPUT)KVMTOOLS-VERSION-FILE'
> >> before the CFLAGS.
> >>
> >> Signed-off-by: haibiao.xiao <xiaohaibiao331@outlook.com>
> >> ---
> >>  Makefile | 4 ++--
> >>  1 file changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/Makefile b/Makefile
> >> index bb7ad3e..9afb5e3 100644
> >> --- a/Makefile
> >> +++ b/Makefile
> >> @@ -17,6 +17,7 @@ export E Q
> >>  
> >>  include config/utilities.mak
> >>  include config/feature-tests.mak
> >> +-include $(OUTPUT)KVMTOOLS-VERSION-FILE
> >>  
> >>  CC	:= $(CROSS_COMPILE)gcc
> >>  CFLAGS	:=
> >> @@ -559,5 +560,4 @@ ifneq ($(MAKECMDGOALS),clean)
> >>  
> >>  KVMTOOLS-VERSION-FILE:
> >>  	@$(SHELL_PATH) util/KVMTOOLS-VERSION-GEN $(OUTPUT)
> >> --include $(OUTPUT)KVMTOOLS-VERSION-FILE
> >> -endif
> >> +endif
> >> \ No newline at end of file
> >> -- 
> >> 2.32.0
> >>
