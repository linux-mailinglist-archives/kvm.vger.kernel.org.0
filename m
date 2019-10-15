Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 733EBD6C58
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 02:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbfJOAER (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Oct 2019 20:04:17 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:45067 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726740AbfJOAER (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Oct 2019 20:04:17 -0400
Received: by mail-pf1-f202.google.com with SMTP id a2so14512547pfo.12
        for <kvm@vger.kernel.org>; Mon, 14 Oct 2019 17:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=SRhEAAU8/+3Mdz5PZ+SYtqxO9uMOiDzHiECPRjG6fk0=;
        b=kAQuyzHOfAQerpV9y4OXwjS1OCWE6791uDCtjizPZgKKT3Q5gwfkdAdOlAvsCvUPrf
         03m9EPozMrOWjy8ElECcl+EE62BWrzam7NjjpY6xOnkRNTQO8YDZKQZRB43N+J400Nnd
         NmXrD3I86h/SHCyrOJ31FHvq6WtbwIn2YVG0JnfRrrlVPDH5SrCMYsRe+SqxTGeg4nVM
         pIxN3Osy56dZG3bweeTL52XBpCPD5qg15xbhRolST2+19REVgQkcIY5Sh5StHUQgqBUK
         5ijuh807wdqtskaV1wEo/fXB1Mx2KcQSj92XmvISjtnCXOLshPx9BJUA0OZM5tNis+Nd
         ODpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=SRhEAAU8/+3Mdz5PZ+SYtqxO9uMOiDzHiECPRjG6fk0=;
        b=fpdh1vpgSu36LCmLFuflGJCv8OS/hOQYn4XkV7uSuMqdgOuLnMGggluyj9fByR4XTC
         b4Y06YrKp9nHZdsF3fte+zpXiIc9KYmj+jV+ZMGHrqsrnYf0ZK+t/cFQPI0nVn1R0jSH
         iw1gY3jE+QpqCoslbMIv20P6595opZdPdnpfkHggrq8jb5DRmWXPxqzg+MPscVoJEEjv
         ahsq6XPKEJa7LYirrARNOQF0s5CkUlUoYdAcZdcsXWOmKoGqazhlVTM0PLH2OzBifvcQ
         yheiXE8PE1fqU4U0u2vMhcRjFGzqrWffiyzp3FL2KAQAAQafDqomvN6qMbqiJzyxzsaF
         vCuA==
X-Gm-Message-State: APjAAAXg8NEMo8i2reWOD2vzgIUDLjMRqGpcUKVopnNYbolfJqQtOuSB
        r2f31QgN76mUhBUwlg7CcLrlGyHqtBYq3mbfc4qMhY4yv8UchduTS9Y3NWC1cMX5JUzAvuuDDzv
        t5WLwBb42QZs+aBZtnRfGdaCuiegwcv+ky/Qa9r2zSoFCpSf50EgYOQ==
X-Google-Smtp-Source: APXvYqz+WG+YGqvbWfd4R+p3KvLl4jSxenaPXWbh0VyD9Vni4lvT7Pw3u40bxLMKlLUnLVn9/QGD9Gba3A==
X-Received: by 2002:a65:638a:: with SMTP id h10mr34899856pgv.388.1571097855656;
 Mon, 14 Oct 2019 17:04:15 -0700 (PDT)
Date:   Mon, 14 Oct 2019 17:04:07 -0700
In-Reply-To: <20191010183506.129921-1-morbo@google.com>
Message-Id: <20191015000411.59740-1-morbo@google.com>
Mime-Version: 1.0
References: <20191010183506.129921-1-morbo@google.com>
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
Subject: [kvm-unit-tests PATCH v2 0/4] Patches for clang compilation
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     jmattson@google.com, sean.j.christopherson@intel.com,
        Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These four patches fix compilation issues that clang's encountering.

I ran the tests and there are no regressions with gcc.

Bill Wendling (4):
  x86: emulator: use "SSE2" for the target
  pci: cast the masks to the appropriate size
  Makefile: use "-Werror" in cc-option
  Makefile: add "cxx-option" for C++ builds

 Makefile       | 23 +++++++++++++++--------
 lib/pci.c      |  3 ++-
 x86/emulator.c |  2 +-
 3 files changed, 18 insertions(+), 10 deletions(-)

-- 
2.23.0.700.g56cf767bdb-goog

