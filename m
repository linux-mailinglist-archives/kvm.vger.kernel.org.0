Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0326D59B90D
	for <lists+kvm@lfdr.de>; Mon, 22 Aug 2022 08:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232784AbiHVGMX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Aug 2022 02:12:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbiHVGMV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Aug 2022 02:12:21 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A92A26AD2;
        Sun, 21 Aug 2022 23:12:21 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id h20-20020a056830165400b00638ac7ddba5so7064090otr.4;
        Sun, 21 Aug 2022 23:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:reply-to:in-reply-to:references
         :mime-version:from:to:cc;
        bh=xRBPID2afPJAp96OqaGvBdjqx78UAxNzgaJTyGjabr8=;
        b=fAsoPJBfZm1Q3Pe+7+Kgk49YdcBBzb5wbtHRNl3NBQ8lbJi6wNFGOyGP+hoP0LKlyB
         VYzze1ue1TiTDDgBtSEp6kziMzbSiH5Fii+zpt7cBoV90iAQvRLmQHESUpqo3Y2Wp0tT
         txhLSz77VhTqtxhPw3vHrTEWUE1Rg3dXr9mmw80FeRscTk39kroT1YD6ySvLqCPXYB/M
         jKGtS5Jkl9M0Xr8BvbyheUI4MSQ3LYilhkgfoy9UPRCTcOE8FZLGdRPd5ma1WAVAWUHJ
         rX8xGUAGM5/iqMLz3tWKZo8+A29cJCX4/zNpzemWmun70fPvCnhrk/oSR+OdcQSW3niU
         7edw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:reply-to:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=xRBPID2afPJAp96OqaGvBdjqx78UAxNzgaJTyGjabr8=;
        b=GDmbLoeM4H5ljqQY3FvjqMmqus7MvH38CTOUOPYK/hVR0rHUS/gPlm7r4CyiGTrqQ5
         /ZTKHs+8YZ36SCBnWFwSqhDkxLG1crLaZYt0aEK970mw0INpvChvkJ70dZcH5FJmWz+H
         C5Uk3n2VoNABbWQH9F+lYrNjVErQIw6cdBwHfCTEc77oF+wqzeMWAFrUEvyQVMDSE2eO
         6lRCrhKS665f71bmOyW2TskDwbxTJ+2ZIBMyO3kd6hNu1Q8OsVfpyYEu1/quV0m+Njed
         WdSOOW8K0BZrS+Qtot7+8glD2hdO5s0btaY/owzzjLuwfZCuztxN8MgDfiDh6QXIddyi
         gR3A==
X-Gm-Message-State: ACgBeo33geumml56BpLk6OmlwwStbg+amnqz+fn3iAGnHDoD0GG6ZkU9
        se3DDVr3YyHYjyEvA0jfVJJVuV2m6h2kgYHrKR4=
X-Google-Smtp-Source: AA6agR5/3lpDfPcI8hjqmqqJiTVbPVyi0UuVROvgrbHtJM/EtFwkEW7IgrfmM3wwNBrbhTG/o1jOsrLr57VaSHZoKMc=
X-Received: by 2002:a05:6830:2a8e:b0:638:c41c:d5a1 with SMTP id
 s14-20020a0568302a8e00b00638c41cd5a1mr7455068otu.367.1661148740694; Sun, 21
 Aug 2022 23:12:20 -0700 (PDT)
MIME-Version: 1.0
References: <CAADnVQJFc9AnH_9CW+bSRotkKvOmkO9jq-RF6dmyPYOpq691Yg@mail.gmail.com>
 <20220819190640.2763586-1-ndesaulniers@google.com> <CAHk-=whLcuvDDS3rZfEgDrwbdJrTx8HCRNiZ5cDc80-_gzHCxw@mail.gmail.com>
In-Reply-To: <CAHk-=whLcuvDDS3rZfEgDrwbdJrTx8HCRNiZ5cDc80-_gzHCxw@mail.gmail.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Mon, 22 Aug 2022 08:11:44 +0200
Message-ID: <CA+icZUUX1gPvnExa=zyVqB8xYOTai+nfHp6E7+qRE2mXXa2M=A@mail.gmail.com>
Subject: Re: [PATCH v2] asm goto: eradicate CC_HAS_ASM_GOTO
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, x86@kernel.org,
        linux-kbuild@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-um@lists.infradead.org,
        kvm@vger.kernel.org, llvm@lists.linux.dev,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Borislav Petkov <bp@suse.de>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Aug 21, 2022 at 7:13 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Applied directly, just because I love seeing old nasty stuff like this go away.
>
>              Linus

Hi,

Small nitpick:

--- a/arch/x86/include/asm/rmwcc.h
+++ b/arch/x86/include/asm/rmwcc.h
...
-#if !defined(__GCC_ASM_FLAG_OUTPUTS__) && defined(CONFIG_CC_HAS_ASM_GOTO)
+#ifndef __GCC_ASM_FLAG_OUTPUTS__
...
-#else /* defined(__GCC_ASM_FLAG_OUTPUTS__) ||
!defined(CONFIG_CC_HAS_ASM_GOTO) */
+#else /* defined(__GCC_ASM_FLAG_OUTPUTS__) */
...
-#endif /* defined(__GCC_ASM_FLAG_OUTPUTS__) ||
!defined(CONFIG_CC_HAS_ASM_GOTO) */
+#endif /* defined(__GCC_ASM_FLAG_OUTPUTS__) */

Shouldn't that be...

#if !defined(__GCC_ASM_FLAG_OUTPUTS__)

...to fit the 2 comments?

Best regards,
-Sedat-
