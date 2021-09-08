Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8762F404046
	for <lists+kvm@lfdr.de>; Wed,  8 Sep 2021 22:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350652AbhIHUrI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Sep 2021 16:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350619AbhIHUrH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Sep 2021 16:47:07 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E119C061575
        for <kvm@vger.kernel.org>; Wed,  8 Sep 2021 13:45:59 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id c20-20020a05622a059400b002a0bb6f8d84so5678751qtb.15
        for <kvm@vger.kernel.org>; Wed, 08 Sep 2021 13:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=P/GJYxqr07Nzhwi/9OqTqQfXfVsHVusQaRdyE5TuiJM=;
        b=MHrrTE4z08wdSZIFiRUMtB0PxAECs0pFuVXXdlUtRS4MCIazSyuhsrh2+U+40hzqRG
         DgisBspNXZvfoKXUbAXndxaYk7PQGANOmlAU+A7XYcgd7j5w10nLugsQ6If4APUhV32B
         LVL58KFDAoyAVk42ckXxGazUpDiLVLmZSXYZGU2VcepwGRRojrBl+/zFTchkH7T8PHZs
         IDQus2XBD7R+CJdDrvo8RHSpMju2LFkozT3qjZcJ5YAPnKWbIstT6ewh5qbZhJLW4nW7
         M4o0NJTil95XkNN7tXHFtbdNcnEsMDTtf3AJVfsuexymUrbEB0vH84eyNNhQ2adj3NRN
         ID5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=P/GJYxqr07Nzhwi/9OqTqQfXfVsHVusQaRdyE5TuiJM=;
        b=wP8UnSouaHsOBatqJH2rWwz04cAjQLWQ0XCgtOKAmRyHGuoC2eDNWdKmuPTg3xmy2K
         bsC6T+/CXYlvGdcUnYmAAF480OX0l1x1voK8CJQIu6D9U6XD5arHvpZ0yecqKtO5HlV8
         V6w47+6hx6vu7ntMoSC1DuAy3Wjdgvm3uYh+pxYn3fkM8YZ+U8qsQgYt0/5dT4pIsbSt
         MK6ZJ4uZe9BGXd02Z0ZCbHIGmXtIqMN9l6bEzS/8eWtjP6BTGEKvtIL50dB2GcmNgCgJ
         7YhNP+u1iqCex4ZxGoSXQO9zBUnFy/6J60fG5jv8Cp9IVAWPQZ0fOAvUKqYVe75gZK6y
         mXjw==
X-Gm-Message-State: AOAM532LvvHF2MqN6tww6ojThTuOb7H9BhOForQTmh71mw8l38PgPTSH
        wdrLXeka7DQE4juWToHquHgHDwtd413lkpViNad99oIUN6IffZb3UwAMFQluyMwmHpWWNDWqkeC
        9LfC9xem0Sr/ZitpNLGUMncs0hvcPhIPZNduw1E9VHXgeqtQZFl3tWw==
X-Google-Smtp-Source: ABdhPJwfLC40B2zGAx7GtyRf5iwwg91FF+b34QOfCCoK/ADn5vIubOeEnzha4MCb6EiIzCyJiUNm1zP7qQ==
X-Received: from fawn.svl.corp.google.com ([2620:15c:2cd:202:2d44:9018:fc46:57b])
 (user=morbo job=sendgmr) by 2002:a05:6214:76c:: with SMTP id
 f12mr307574qvz.28.1631133958527; Wed, 08 Sep 2021 13:45:58 -0700 (PDT)
Date:   Wed,  8 Sep 2021 13:45:38 -0700
In-Reply-To: <20210908204541.3632269-1-morbo@google.com>
Message-Id: <20210908204541.3632269-3-morbo@google.com>
Mime-Version: 1.0
References: <20210825222604.2659360-1-morbo@google.com> <20210908204541.3632269-1-morbo@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [kvm-unit-tests PATCH v2 2/5] x86: realmode: mark exec_in_big_real_mode
 as noinline
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        David Matlack <dmatlack@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

exec_in_big_real_mode() uses inline asm that has labels. Clang decides
that it can inline this function, which causes the assembler to complain
about duplicate symbols. Mark the function as "noinline" to prevent
this.

Signed-off-by: Bill Wendling <morbo@google.com>
---
 x86/realmode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/realmode.c b/x86/realmode.c
index b4fa603..07a477f 100644
--- a/x86/realmode.c
+++ b/x86/realmode.c
@@ -178,7 +178,7 @@ static inline void init_inregs(struct regs *regs)
 		inregs.esp = (unsigned long)&tmp_stack.top;
 }
 
-static void exec_in_big_real_mode(struct insn_desc *insn)
+static __attribute__((noinline)) void exec_in_big_real_mode(struct insn_desc *insn)
 {
 	unsigned long tmp;
 	static struct regs save;
-- 
2.33.0.309.g3052b89438-goog

