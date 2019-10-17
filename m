Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2B9DA308
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2019 03:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405704AbfJQBZQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 21:25:16 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:40058 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404111AbfJQBZP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Oct 2019 21:25:15 -0400
Received: by mail-pf1-f201.google.com with SMTP id r19so420216pfh.7
        for <kvm@vger.kernel.org>; Wed, 16 Oct 2019 18:25:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=3zpaEGQT5nYlTpl6wba1fWX+9IJx5cUE67PkWsveMnI=;
        b=tlwpsPsSbFozrX6imGKPOZei0qoOozI4YHoP2/BcTIRg9f8u2raMCr7Jpm4wRpZnMV
         a7SR/RzykG/CHpJORSkjeB4SODCcT5v/e8oSuVJhXMYHp+3KxNVoxystw2K6JcoXXUtv
         Wfdwvvq6Dn2VvMhAjhpJZ649kOq2Q0IY7iabh2KcVGnGDVRmAAnrLRm93emzAmQUNDSE
         MSvxzpagpgGfEnQbhtmh06oZmBL08qdMxM0xElS/F6c7oy+l1OuNVjaBtaagDceB7Efw
         SS9LUECkuJo1OLZNwIkEot+qGf4QaSgHiXxaUsb76sJItt4zA81a646Fgv9dDCDCGv97
         Q8jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=3zpaEGQT5nYlTpl6wba1fWX+9IJx5cUE67PkWsveMnI=;
        b=n59PhNhv4f0EOzyyZEjciY4hceRseDIXlNC8BoV3VlWA0sM6gMH48/PeRR7yuX9Vh4
         020KqwbxQZUYPA9k757q972ePV7+em8nDZnMi2OwHsEE+8xxlD86pu2dJIuZff5XHxN1
         rLNl0YtvB3rUW58PJCMHugkUecV/PXQmvqcq+elr+iblC26pv6yRdohPoiKQ7PQHIntv
         Np7bWjBkPLVXMgULVqc4Vljjap25bFMsvrql39n9Rw5I3S8Yqy8WcstRUrAgNjKtgTVW
         JZAwOj2DairqGdP/j3w/2iq1UEM3txOEVnXouKk4uNNclEmpKnyeHfRYVz57RqfNrx3j
         Rptg==
X-Gm-Message-State: APjAAAVvo2X5CQduxnXB3PdJ9lI73t29fx8H6O3tYNBev175gsOl6EcW
        +1VhT+jsyBkZT0z1+jq4Fx/4GsxLJcj+f3jMAbGQDkqCgLMJrkA2gYrcMKG1/VqUvGVr3vBFKYG
        4bAKe77060lk4nJQNSo7qO8rU3t0Z+FlYFUf3oFEtW5nAKVfYBpj/gA==
X-Google-Smtp-Source: APXvYqzILPgJ5Gcjgfn7BxmNZpZCDZuVuv9e1oXGwlh4+vLvHNmmNLN+k7sbjw+7CHXU2JmsJBg3Qcrl+Q==
X-Received: by 2002:a63:5d06:: with SMTP id r6mr1222089pgb.216.1571275513053;
 Wed, 16 Oct 2019 18:25:13 -0700 (PDT)
Date:   Wed, 16 Oct 2019 18:25:00 -0700
In-Reply-To: <20191012235859.238387-1-morbo@google.com>
Message-Id: <20191017012502.186146-1-morbo@google.com>
Mime-Version: 1.0
References: <20191012235859.238387-1-morbo@google.com>
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
Subject: [kvm-unit-tests v2 PATCH 0/2] realmode test fixes for clang
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, alexandru.elisei@arm.com,
        thuth@redhat.com
Cc:     jmattson@google.com, Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following patches fix some realmode test compatibility issues
between gcc and clang.

This update should address the comments by Jim Mattson.

Re explicitly copying the regs structure, I tried to use the inline asm
code you suggested, but wasn't able to get it to work for me. It never
seemed to copy the structure correctly. Doing the loop explicitly solved
the issue.

Bill Wendling (2):
  x86: realmode: explicitly copy regs structure
  x86: realmode: fix esp in call test

 x86/realmode.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

-- 
2.23.0.700.g56cf767bdb-goog

