Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC7CF1B9D
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 17:49:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732169AbfKFQtI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 11:49:08 -0500
Received: from foss.arm.com ([217.140.110.172]:43058 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728462AbfKFQtI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 11:49:08 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6080D46A;
        Wed,  6 Nov 2019 08:49:07 -0800 (PST)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 786DD3F719;
        Wed,  6 Nov 2019 08:49:06 -0800 (PST)
Date:   Wed, 6 Nov 2019 16:49:04 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Marc Zyngier <maz@kernel.org>,
        Suzuki Poulose <suzuki.poulose@arm.com>,
        Julien Grall <julien.grall.oss@gmail.com>
Subject: Re: [PATCH kvmtool 05/16] kvmtool: Use MB consistently
Message-ID: <20191106164904.23ed2e76@donnerap.cambridge.arm.com>
In-Reply-To: <1569245722-23375-6-git-send-email-alexandru.elisei@arm.com>
References: <1569245722-23375-1-git-send-email-alexandru.elisei@arm.com>
        <1569245722-23375-6-git-send-email-alexandru.elisei@arm.com>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 23 Sep 2019 14:35:11 +0100
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

> The help text for the -m/--mem argument states that the guest memory size
> is in MiB (mebibyte). We all know that MB (megabyte) is the same thing as
> MiB, and indeed this is how MB is used throughout kvmtool.
> 
> So replace MiB with MB, so people don't get the wrong idea and start
> believing that for kvmtool a MB is 10^6 bytes, because it isn't.
>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre

> ---
>  Documentation/kvmtool.1 | 4 ++--
>  builtin-run.c           | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/kvmtool.1 b/Documentation/kvmtool.1
> index 2b8c274dc3ff..25d46f8f51f9 100644
> --- a/Documentation/kvmtool.1
> +++ b/Documentation/kvmtool.1
> @@ -10,7 +10,7 @@ kvmtool is a userland tool for creating and controlling KVM guests.
>  .SH "KVMTOOL COMMANDS"
>  .sp
>  .PP
> -.B run -k <kernel\-image> [\-c <cores>] [\-m <MiB>] [\-p <command line>]
> +.B run -k <kernel\-image> [\-c <cores>] [\-m <MB>] [\-p <command line>]
>  .br
>  .B [\-i <initrd>] [\-d <image file>] [\-\-console serial|virtio|hv]
>  .br
> @@ -30,7 +30,7 @@ The number of virtual CPUs to run.
>  .sp
>  .B \-m, \-\-mem <n>
>  .RS 4
> -Virtual machine memory size in MiB.
> +Virtual machine memory size in MB.
>  .RE
>  .sp
>  .B \-p, \-\-params <parameters>
> diff --git a/builtin-run.c b/builtin-run.c
> index 532c06f90ba0..cff44047bb1c 100644
> --- a/builtin-run.c
> +++ b/builtin-run.c
> @@ -98,7 +98,7 @@ void kvm_run_set_wrapper_sandbox(void)
>  			"A name for the guest"),			\
>  	OPT_INTEGER('c', "cpus", &(cfg)->nrcpus, "Number of CPUs"),	\
>  	OPT_U64('m', "mem", &(cfg)->ram_size, "Virtual machine memory"	\
> -		" size in MiB."),					\
> +		" size in MB."),					\
>  	OPT_CALLBACK('\0', "shmem", NULL,				\
>  		     "[pci:]<addr>:<size>[:handle=<handle>][:create]",	\
>  		     "Share host shmem with guest via pci device",	\

