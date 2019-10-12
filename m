Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B646D535B
	for <lists+kvm@lfdr.de>; Sun, 13 Oct 2019 02:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727594AbfJLX7G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Oct 2019 19:59:06 -0400
Received: from mail-yw1-f73.google.com ([209.85.161.73]:36316 "EHLO
        mail-yw1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727184AbfJLX7G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Oct 2019 19:59:06 -0400
Received: by mail-yw1-f73.google.com with SMTP id r64so10835133ywb.3
        for <kvm@vger.kernel.org>; Sat, 12 Oct 2019 16:59:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=aOQjX7ivHZVJvY12QmszZabAXqFM60K3GeOwoYpyLWk=;
        b=RnLlKUAZDLFZ5sXrZnEYN0POh19B4IBAeWyp9zXjUa8n8htlUyDDiMkiFMgXuMVc/K
         UvcFPmRLiA8F52twk163TzldJ/TxqjYBebUE5zfzZCfs5QPPHg8juAiERKaoupQkksh/
         MzwLy1/xxTF5U4J/lFQOA/uarQrZFm73+U86alnkcgyUTS64JBsdW2RMQZmxLwwD3N/m
         QqFhCNvznz+tJ1sZPwaQGjLeFbvkrOrG8KVSZPD6Y9xSsnA2p3/WRO0NL3DY6ODrDtDd
         KYBTcXFmtEAaxMTtRZ636jTKtEMq/FQ915wCzMpXTOqjqjp5qv85oY4rEutPN5qIzBwk
         8wlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=aOQjX7ivHZVJvY12QmszZabAXqFM60K3GeOwoYpyLWk=;
        b=rFuxl1J5pupu6YOClJXSMZ3pnUn6pdvSX+tGVctl9x2Jn6B7NkM2qB1rwv/bP2UVh5
         KNbDcz1arLyEigvKhK5ixgKcOHeL835W8VYWw5JD+uNx4L3ouBPymPauwgWG2WEHE/Oy
         2GkaISAjK9AgRyhCb2AoxSbP1vx/oUmitAkXvx/D8RBqB30HAtGrTtaKGXKwHD9/jU9c
         PCwbla40jzHtIKN//5m7v9T6C/U8ZAL4AFFdtKtGxnE0EdT77tPI/LaZH8ZK1OyuXG54
         1KVw7AKPGMK9axWKGB9e8lKfvjO8r1ZdqXJYYezV6140wp6vyoX/AX3qTE/a9xtdYj9h
         WFxg==
X-Gm-Message-State: APjAAAX+01tZLZzHek4QhR/opBmUpFVTZ25v+8gZjLrHGem58j3pOLX5
        KNaA5IjQTzp9JIauPzSdEBSBwazaOK/NA2EAIa8oKtYnGS2j8od3vOtsDd1KBiimNoxn8NSA8gV
        fKo0spZCbVFvulucA35E3tSaEh3/3zd0h9/izg1fwvfO0U3mxn6L7Vg==
X-Google-Smtp-Source: APXvYqyJTaepZzAig0ng8Dc1RuW6ZW2xh0ydXoLU6b+KYAZQc80F60TYKJJhLlhebLfP6s4iDu2Hc38n8A==
X-Received: by 2002:a81:1b49:: with SMTP id b70mr7769656ywb.229.1570924744878;
 Sat, 12 Oct 2019 16:59:04 -0700 (PDT)
Date:   Sat, 12 Oct 2019 16:58:57 -0700
Message-Id: <20191012235859.238387-1-morbo@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
Subject: [kvm-unit-tests PATCH 0/2] realmode test fixes for clang
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, alexandru.elisei@arm.com
Cc:     jmattson@google.com, Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following patches fix some realmode test compatibility issues
between gcc and clang.

Please look at the "x86: realmode: use inline asm to get stack pointer"
patch closely. I'm fairly certain it's the correct fix, but would like
confirmation.

Thanks!

Bill Wendling (2):
  x86: realmode: explicitly copy structure to avoid memcpy
  x86: realmode: use inline asm to get stack pointer

 x86/realmode.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

-- 
2.23.0.700.g56cf767bdb-goog

