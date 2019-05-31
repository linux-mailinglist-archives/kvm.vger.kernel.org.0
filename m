Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 654723128A
	for <lists+kvm@lfdr.de>; Fri, 31 May 2019 18:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbfEaQiH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 May 2019 12:38:07 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:41933 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726601AbfEaQiG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 May 2019 12:38:06 -0400
Received: by mail-lj1-f195.google.com with SMTP id q16so10224215ljj.8
        for <kvm@vger.kernel.org>; Fri, 31 May 2019 09:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=wc9G8njv4up6ynVqohLgbm2HutlynxnJF5OdXG6ExVk=;
        b=ceAuwm96uCsLKsKWlS88yHyO1Y89Ww0dilR19m/HwbKWtnjHT16OT9FTEU/n9zgpmE
         VVLWyjPlbjT5xzxbRxHadNZYaxSnAXIa4b0m1EAh+7Tm47dA2GgGX5n/KJX9aCcSw38g
         e1sAypk7az4BmyMoZrllwH6yh36LsYBARf+q4bk9l4YYXmhL+Ot8PToat5wUL/Vbdja+
         vzc0AVqnuuNKlgqBNErJUQWBAKpuocMM0vRf1JJXhtqCGECmV8GLgugeJYr+l23kFXtI
         wL+YO4d/N3a8x/HnP99nsXFP5aAnM1/f1btTcemZaeA70pZt8TthyNFw4tYt00j6ANRU
         WFvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=wc9G8njv4up6ynVqohLgbm2HutlynxnJF5OdXG6ExVk=;
        b=tfnBN3R0ww59BfuqLGW6KDc9xnP7jntxt76DJ+S7iQ76ZQ9C2QZUrcPxG8C4nRP1xA
         FULGz0IUsza35dh/RBPpXw1IF/IrzH81CKC6vri5zALlFMJN1HnZxBd4X3NK0gdSg4bj
         G9YYCHtle/JFUG6WQKY7bZ67kxV6wIuynvlSmUWOtoklVIdmE4X2PGwcbeCUErnlMH0f
         bvI+XbGuZSmuZqjk2q5DbRi572a8xWH56N4Gj0TehWtGmhSSuoa/YjXWS1oljadF6iNx
         IyLVi8Y/YcUsy8uS6JpcN0BjVlPXJ9AmP6ySTbT+oYxc9L/YX1AcnzBINlQEiy110YSR
         LzJQ==
X-Gm-Message-State: APjAAAWx2HGpLuUbMMQHO2UIKUL5vayUhu3tkjFd8tASuHJAjVpnIsAY
        2xFQ+Mu5oV6aZwuxFKxUGi6stwHlGbMh2rMpC7Zg9sQVsdo=
X-Google-Smtp-Source: APXvYqwqLLMzSG0117Ocs6Kz9B+9kbL228fgw9kuXaKNKkrWvFeJ4R0gUH+Hs4A7RgyD4vMGYCfud8459oR3D9AIKRc=
X-Received: by 2002:a2e:9a4f:: with SMTP id k15mr6431679ljj.159.1559320684360;
 Fri, 31 May 2019 09:38:04 -0700 (PDT)
MIME-Version: 1.0
References: <20190521171358.158429-1-aaronlewis@google.com>
In-Reply-To: <20190521171358.158429-1-aaronlewis@google.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Fri, 31 May 2019 09:37:52 -0700
Message-ID: <CAAAPnDH1eiZf-HkT2T8aDBBU_TKV7Md=EBQymq9FDMZ7e4__6g@mail.gmail.com>
Subject: Re: [PATCH] kvm: tests: Sort tests in the Makefile alphabetically
To:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>,
        Marc Orr <marcorr@google.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 21, 2019 at 10:14 AM Aaron Lewis <aaronlewis@google.com> wrote:
>
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> ---
>  tools/testing/selftests/kvm/Makefile | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 79c524395ebe..234f679fa5ad 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -10,23 +10,23 @@ LIBKVM = lib/assert.c lib/elf.c lib/io.c lib/kvm_util.c lib/ucall.c lib/sparsebi
>  LIBKVM_x86_64 = lib/x86_64/processor.c lib/x86_64/vmx.c
>  LIBKVM_aarch64 = lib/aarch64/processor.c
>
> -TEST_GEN_PROGS_x86_64 = x86_64/platform_info_test
> -TEST_GEN_PROGS_x86_64 += x86_64/set_sregs_test
> -TEST_GEN_PROGS_x86_64 += x86_64/sync_regs_test
> -TEST_GEN_PROGS_x86_64 += x86_64/vmx_tsc_adjust_test
> -TEST_GEN_PROGS_x86_64 += x86_64/cr4_cpuid_sync_test
> -TEST_GEN_PROGS_x86_64 += x86_64/state_test
> +TEST_GEN_PROGS_x86_64 = x86_64/cr4_cpuid_sync_test
>  TEST_GEN_PROGS_x86_64 += x86_64/evmcs_test
>  TEST_GEN_PROGS_x86_64 += x86_64/hyperv_cpuid
> -TEST_GEN_PROGS_x86_64 += x86_64/vmx_close_while_nested_test
> -TEST_GEN_PROGS_x86_64 += x86_64/smm_test
>  TEST_GEN_PROGS_x86_64 += x86_64/kvm_create_max_vcpus
> +TEST_GEN_PROGS_x86_64 += x86_64/platform_info_test
> +TEST_GEN_PROGS_x86_64 += x86_64/set_sregs_test
> +TEST_GEN_PROGS_x86_64 += x86_64/smm_test
> +TEST_GEN_PROGS_x86_64 += x86_64/state_test
> +TEST_GEN_PROGS_x86_64 += x86_64/sync_regs_test
> +TEST_GEN_PROGS_x86_64 += x86_64/vmx_close_while_nested_test
>  TEST_GEN_PROGS_x86_64 += x86_64/vmx_set_nested_state_test
> -TEST_GEN_PROGS_x86_64 += dirty_log_test
> +TEST_GEN_PROGS_x86_64 += x86_64/vmx_tsc_adjust_test
>  TEST_GEN_PROGS_x86_64 += clear_dirty_log_test
> +TEST_GEN_PROGS_x86_64 += dirty_log_test
>
> -TEST_GEN_PROGS_aarch64 += dirty_log_test
>  TEST_GEN_PROGS_aarch64 += clear_dirty_log_test
> +TEST_GEN_PROGS_aarch64 += dirty_log_test
>
>  TEST_GEN_PROGS += $(TEST_GEN_PROGS_$(UNAME_M))
>  LIBKVM += $(LIBKVM_$(UNAME_M))
> --
> 2.21.0.1020.gf2820cf01a-goog
>

Does this look okay?  It's just a simple reordering of the list.  It
helps when adding new tests.
