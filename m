Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D11474806B4
	for <lists+kvm@lfdr.de>; Tue, 28 Dec 2021 07:21:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235085AbhL1GVR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Dec 2021 01:21:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235074AbhL1GVR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Dec 2021 01:21:17 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE268C061574
        for <kvm@vger.kernel.org>; Mon, 27 Dec 2021 22:21:16 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id d198-20020a1c1dcf000000b0034569cdd2a2so9465599wmd.5
        for <kvm@vger.kernel.org>; Mon, 27 Dec 2021 22:21:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fz/c6/4SGSYodrgD5AdFvdel0zxLs/yQs8FyjZNs4tQ=;
        b=g8BS2gkO3Z2Uowvmo4A8Ijgd4KkngqwKudZDouJ64O4ICZF4AftTAzILir3ldPIGRP
         2HtEyL5f891oVMB3m6gVXI8/xD1r9NhLBSZsFfQuUVHpX/86kWDNC++lz59nfmN9z/W0
         cMKGrJdmbUvqHhvU1uxqsv7X0U86JVXp0NZhYr17K0KjlFtwAJ0woa3kCEAcWHHRNp4Q
         35crBEvFtatsX2esBh7evM8EU1IF6zgU2G4YA4Bk2lfvnaVhgRO9jMGtIs/OuczxQIK4
         +HRFBI8MPTcGcGjwSaIrpk2xLO2TLW5r2PgSRa5rGLTK4duDOuLK22GrkaX9kuABwEbP
         H+tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fz/c6/4SGSYodrgD5AdFvdel0zxLs/yQs8FyjZNs4tQ=;
        b=YAK3ap0Kkryr7EzP8/7N9DGDfw9bP3sL1cnFTASTO5JjzNK+fCZNgZEuLdeE8qnRE7
         KcW0mUjpntdKfAtaO6rNkTFqNyNQRlae79vvH9yGShcle4OW3JJGSAxJTG5tM3w1Mhnz
         MXiHOyJaOGhtR4J9DpIZurR1mxcaaOwBNOVlkN4oOZpIFOkX3STqrP1Ld8XUQvwaXNOo
         5CLuRbkwolNheurp1i7yNgkQOc0o7U7KxIGLtK/49zUfGH0ScARs4TQdk0knER7AQxYs
         WOsfLjPh5SloObyCEikBr6wM3LxC5Av0CE61BqVSWA/0A1DmEgIkGPE3pKzDV/u6U+bH
         tfXA==
X-Gm-Message-State: AOAM531Ir/iOSdSD8RTAQxWzfDf3AvpzFbu3DiOQ/bmggRS/D8fiwEjL
        8aFTB07dAoYziGSq4CjoRC05b3c4bqoDWjBetAoS5g==
X-Google-Smtp-Source: ABdhPJzwphhcZ5/970ADxXH2bibdTOzzfkGmRBRlIOXuEZmGT+1EFTP2zwlDZkGJmzwPLY/AU7Qe3W3uiVvJgPUspkQ=
X-Received: by 2002:a05:600c:4f08:: with SMTP id l8mr16128758wmq.59.1640672475272;
 Mon, 27 Dec 2021 22:21:15 -0800 (PST)
MIME-Version: 1.0
References: <20211224073604.1085464-1-anup.patel@wdc.com> <20211224073604.1085464-4-anup.patel@wdc.com>
In-Reply-To: <20211224073604.1085464-4-anup.patel@wdc.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Tue, 28 Dec 2021 11:51:03 +0530
Message-ID: <CAAhSdy0jN-Nz_jWXgvrfRVzS5=vRPWjBp+hytU1fA0nyVsq20w@mail.gmail.com>
Subject: Re: [PATCH v4 3/4] KVM: selftests: Add EXTRA_CFLAGS in top-level Makefile
To:     Anup Patel <anup.patel@wdc.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        KVM General <kvm@vger.kernel.org>,
        kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org, Atish Patra <atishp@rivosinc.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 24, 2021 at 1:06 PM Anup Patel <anup.patel@wdc.com> wrote:
>
> We add EXTRA_CFLAGS to the common CFLAGS of top-level Makefile which will
> allow users to pass additional compile-time flags such as "-static".
>
> Signed-off-by: Anup Patel <anup.patel@wdc.com>
> Reviewed-and-tested-by: Atish Patra <atishp@rivosinc.com>
> Reviewed-and-tested-by: Sean Christopherson <seanjc@google.com>

Queued this patch for 5.17

Thanks,
Anup

> ---
>  tools/testing/selftests/kvm/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index f307c9f61981..3c839c01d4fd 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -132,7 +132,7 @@ endif
>  CFLAGS += -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
>         -fno-stack-protector -fno-PIE -I$(LINUX_TOOL_INCLUDE) \
>         -I$(LINUX_TOOL_ARCH_INCLUDE) -I$(LINUX_HDR_PATH) -Iinclude \
> -       -I$(<D) -Iinclude/$(UNAME_M) -I..
> +       -I$(<D) -Iinclude/$(UNAME_M) -I.. $(EXTRA_CFLAGS)
>
>  no-pie-option := $(call try-run, echo 'int main() { return 0; }' | \
>          $(CC) -Werror -no-pie -x c - -o "$$TMP", -no-pie)
> --
> 2.25.1
>
