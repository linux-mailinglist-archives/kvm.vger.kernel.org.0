Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 147AF59B310
	for <lists+kvm@lfdr.de>; Sun, 21 Aug 2022 12:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbiHUKLw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 21 Aug 2022 06:11:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiHUKLv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 21 Aug 2022 06:11:51 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9286FFD3E;
        Sun, 21 Aug 2022 03:11:49 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id ce26so476817ejb.11;
        Sun, 21 Aug 2022 03:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=8ith3DKWqelfwAhl4fXB2Zj3+XrRanGIkq2gbaZNWZg=;
        b=BVQpXwpBZgmCcpri72t9UYGSUWNIWbGX+mvKI914QY8tRVzJe+eeIW6Qh/v466eoXH
         fqtZ9qkt9kzrgFQw4vvsffJYWvxDWABGWdj72gGBl+UQVV0nFx/FqLnPInnnqSkwvZiz
         QAx3e/fFprENPZEkS4XD1h1f1dkIll6fgX8OBhc6HyYzEUEfBsScjnLGiqwELqIQJfdE
         CXpkfkItL/NTWXet387ZBCBynIWBmmn5KciXvLRb/KXwolyGql54ceQ8n2zKycvV0r3S
         RNr8UB6ykcmIvdBDzec7uUOA0eGooPOq6M9o5dvWGS520weyqQRDNqRik0CYBOTV/P1m
         j0ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=8ith3DKWqelfwAhl4fXB2Zj3+XrRanGIkq2gbaZNWZg=;
        b=6VsinoZI2o3WE51q0ZzibGqafmGtJq02mwLNQywbJm+VUjt0yNrScWZcsyDsOfvoWj
         j6ix5Nd+cLmbxPaltGMe7etCbXNKy0hVA02ln0UgNxX17og17Y4Ct3RcXrHnH82TkUXW
         0Nvxk1BBsgyWfiQcN4ISJx3z6A/1jciNY+w1pUhonzpstzTHwXW+uen/TbvIkRGfzxgG
         H3W73OFfjBLHy7Fs4faqSX5ZbkpdGQW+1WjbRvkU/3afnqh5Ya08hHZSZVdGzrV9k5ze
         Qrn1wqWhq251bQeMvptyjUCDRgKY5iu+rBABkTcYUnh/idVEWuY4x0mmQVrGaPvbU8vS
         hKvQ==
X-Gm-Message-State: ACgBeo04Z8gv5Oi5EtlvtKCDP1zBTIIJap2BnkK7JO02zg9BaX0b8Kqr
        nDuwggEs0jxr1VBDmom0xLc=
X-Google-Smtp-Source: AA6agR4kTu9YlV5YYbUUlwVhkyNFi6XbWVbAuGGc7J+qELenLCeL3rXs3jHQa/zJy5NHEabc6B1vAQ==
X-Received: by 2002:a17:907:288a:b0:730:7f77:9550 with SMTP id em10-20020a170907288a00b007307f779550mr9534282ejc.216.1661076708009;
        Sun, 21 Aug 2022 03:11:48 -0700 (PDT)
Received: from gmail.com (195-38-113-151.pool.digikabel.hu. [195.38.113.151])
        by smtp.gmail.com with ESMTPSA id j15-20020aa7c0cf000000b0043bbc9503ddsm6251027edp.76.2022.08.21.03.11.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Aug 2022 03:11:47 -0700 (PDT)
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date:   Sun, 21 Aug 2022 12:11:45 +0200
From:   Ingo Molnar <mingo@kernel.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, x86@kernel.org,
        linux-kbuild@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-um@lists.infradead.org,
        kvm@vger.kernel.org, llvm@lists.linux.dev,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Borislav Petkov <bp@suse.de>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH v2] asm goto: eradicate CC_HAS_ASM_GOTO
Message-ID: <YwIE4WDJXWK/LOR6@gmail.com>
References: <CAADnVQJFc9AnH_9CW+bSRotkKvOmkO9jq-RF6dmyPYOpq691Yg@mail.gmail.com>
 <20220819190640.2763586-1-ndesaulniers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220819190640.2763586-1-ndesaulniers@google.com>
X-Spam-Status: No, score=1.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


* Nick Desaulniers <ndesaulniers@google.com> wrote:

> GCC has supported asm goto since 4.5, and Clang has since version 9.0.0.
> The minimum supported versions of these tools for the build according to
> Documentation/process/changes.rst are 5.1 and 11.0.0 respectively.
> 
> Remove the feature detection script, Kconfig option, and clean up some
> fallback code that is no longer supported.
> 
> The removed script was also testing for a GCC specific bug that was
> fixed in the 4.7 release.
> 
> Also remove workarounds for bpftrace using clang older than 9.0.0, since
> other BPF backend fixes are required at this point.
> 
> Link: https://lore.kernel.org/lkml/CAK7LNATSr=BXKfkdW8f-H5VT_w=xBpT2ZQcZ7rm6JfkdE+QnmA@mail.gmail.com/
> Link: http://gcc.gnu.org/bugzilla/show_bug.cgi?id=48637
> Acked-by: Borislav Petkov <bp@suse.de>
> Suggested-by: Masahiro Yamada <masahiroy@kernel.org>
> Suggested-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>

Reviewed-by: Ingo Molnar <mingo@kernel.org>

Good riddance.

Thanks,

	Ingo
