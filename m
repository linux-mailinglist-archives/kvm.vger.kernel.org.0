Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7041C467B01
	for <lists+kvm@lfdr.de>; Fri,  3 Dec 2021 17:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236459AbhLCQN6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Dec 2021 11:13:58 -0500
Received: from foss.arm.com ([217.140.110.172]:50998 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230370AbhLCQN5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Dec 2021 11:13:57 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B02A81435;
        Fri,  3 Dec 2021 08:10:33 -0800 (PST)
Received: from [10.1.38.15] (e122027.cambridge.arm.com [10.1.38.15])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 783AC3F73B;
        Fri,  3 Dec 2021 08:10:32 -0800 (PST)
Subject: Re: [PATCH v3] MAINTAINERS: Update Atish's email address
To:     Atish Patra <atishp@atishpatra.org>, linux-kernel@vger.kernel.org
Cc:     anup.patel@wdc.com, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org
References: <20211202235823.1926970-1-atishp@atishpatra.org>
From:   Steven Price <steven.price@arm.com>
Message-ID: <f63e9f1b-4b8e-6c3e-8e21-f9a5f97ca17d@arm.com>
Date:   Fri, 3 Dec 2021 16:10:30 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211202235823.1926970-1-atishp@atishpatra.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/12/2021 23:58, Atish Patra wrote:
> I am no longer employed by western digital. Update my email address to
> personal one and add entries to .mailmap as well.
> 
> Signed-off-by: Atish Patra <atishp@atishpatra.org>
> ---
>  .mailmap    | 1 +
>  MAINTAINERS | 2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/.mailmap b/.mailmap
> index 6277bb27b4bf..23f6b0a60adf 100644
> --- a/.mailmap
> +++ b/.mailmap
> @@ -50,6 +50,7 @@ Archit Taneja <archit@ti.com>
>  Ard Biesheuvel <ardb@kernel.org> <ard.biesheuvel@linaro.org>
>  Arnaud Patard <arnaud.patard@rtp-net.org>
>  Arnd Bergmann <arnd@arndb.de>
> +Atish Patra <atishp@atishpatra.org> <atish.patra@wdc.com> <atishp@rivosinc.com>

I don't think this does what you expect. You can't list more than one
email address to replace on the same line. You can use the command "git
check-mailmap" to test what happens, e.g. with this change applied:

  $ git check-mailmap "<atishp@rivosinc.com>"
  <atishp@rivosinc.com>
  $ git check-mailmap "<atish.patra@wdc.com>"
  Atish Patra <atishp@atishpatra.org>
  $ git check-mailmap "<atishp@atishpatra.org>"
  <atishp@atishpatra.org>

So only your @wdc.com address is translated. If you want to translate
the @rivosinc.com address as well you need a second line. As the file says:

# For format details, see "MAPPING AUTHORS" in "man git-shortlog".

Steve

>  Axel Dyks <xl@xlsigned.net>
>  Axel Lin <axel.lin@gmail.com>
>  Bart Van Assche <bvanassche@acm.org> <bart.vanassche@sandisk.com>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 5250298d2817..6c2a34da0314 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -10434,7 +10434,7 @@ F:	arch/powerpc/kvm/
>  
>  KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)
>  M:	Anup Patel <anup.patel@wdc.com>
> -R:	Atish Patra <atish.patra@wdc.com>
> +R:	Atish Patra <atishp@atishpatra.org>
>  L:	kvm@vger.kernel.org
>  L:	kvm-riscv@lists.infradead.org
>  L:	linux-riscv@lists.infradead.org
> 

