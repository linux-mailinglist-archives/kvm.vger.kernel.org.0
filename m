Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CBF72DF755
	for <lists+kvm@lfdr.de>; Mon, 21 Dec 2020 01:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbgLUAzr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Dec 2020 19:55:47 -0500
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:45755 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726523AbgLUAzr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 20 Dec 2020 19:55:47 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 702CA580428;
        Sun, 20 Dec 2020 19:54:39 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 20 Dec 2020 19:54:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm1; bh=9UYdNJjXn4om7
        2WGzYzSS6tZtwVGabGeZphyZWQCWjs=; b=rn1ggbbJN37cNfK/YCKEM5yFWhFib
        GuoqhQiq1QPZzYVOj+qLbnx1WHrhxxHlaOj4Q76NvHCT3R2MwkLe73mqtLXAkMDO
        6kk6ncZprILgAeTEwMzaU+LREJF0ugJxjtuBESQ6wzX3NUBhpSUWV5bf8gL1XCRB
        n9OicS7dx8rX7Nzi2GG0vxG8Flq0M5KxfDiiSQRNEa98QsKdYFx+K9uuO0pNKXZg
        pmH0s0tJBZXQ6Yh4Wd0Trru5zuczr7Sz/+fGvqvSCGyZqR2s4EwmfOUJQ0MuaQS2
        +9CAAZB6j7+LleYGo4IOrG40vZqGVc2WXmOVT/IuMVBtlzcC9sRWJoD3g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=9UYdNJjXn4om72WGzYzSS6tZtwVGabGeZphyZWQCWjs=; b=Qck8JKGW
        KjvkXlimw4lkc5XfEauZhw9xUMeZ1Tcee5fP9ihndLqNH+luWEKcUzAAiiUeaGke
        /WEwXcxJjdgD5IuOL5eQhumFLZbHwxZX7pciwGYTZInt2fZ70B1/IWMwvUf8q5GM
        Wb/6fp/8xRNHyFth9X8blmsg8d0phiGuHQzcvtZZUgUuqKQ57RYTsE4qk8uh8IfV
        MfHSL6iJbquJb7FZjMjpfkrz58rK5vQz2EJwveCbtVLbSAaQ3tZlsDKue7fg1eDM
        7Ca09szp9L6O5a3llDMylhR5xTYccu0vCApW5gIQoW+ZgGs8Od8FT3qafpyJWMq+
        K35ZTmE75NH8lQ==
X-ME-Sender: <xms:T_LfXxOD7Y8P9JwLIAw4qUIeTmkJxkrKybKZXk-eNDTCFu_FSoJhpA>
    <xme:T_LfX9mT_NYfjiWb8SdLbJv-gvqNAI04ENHY6h_5ppag97NiZYMsohCvVBrZsXRh8
    b5wxdfpbFI6wbNPD_A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvddtuddgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeflihgrgihu
    nhcujggrnhhguceojhhirgiguhhnrdihrghnghesfhhlhihgohgrthdrtghomheqnecugg
    ftrfgrthhtvghrnheptdevhedvfeelgefhueevffejueffteffkefhveeiudejieeivedu
    vdeitdehffejnecuffhomhgrihhnpehophgvnhhgrhhouhhprdhorhhgnecukfhppeeghe
    drfeefrdehtddrvdehgeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehjihgrgihunhdrhigrnhhgsehflhihghhorghtrdgtohhm
X-ME-Proxy: <xmx:T_LfXwThPaIif8rJOFWDReO3aFagCuIJgyFpQ50yeEZ4IbgBHvvZvw>
    <xmx:T_LfXxBvsMiZDmgznC99QIL0SkTkLdlk-PMbCpzwePa3G_UcL5nUpw>
    <xmx:T_LfX3QtciIcMP1Z5x4manoGpDpGtztw-jW_1eafsiFQ4p62Y2YW2A>
    <xmx:T_LfXwyDQ8CX6wu0cCYg2rjrc1kXq9okzbRkxU7wpzom2GaddB7hiRa5AG0u4vxJ>
Received: from strike.U-LINK.com (li1000-254.members.linode.com [45.33.50.254])
        by mail.messagingengine.com (Postfix) with ESMTPA id AC5C4240057;
        Sun, 20 Dec 2020 19:54:29 -0500 (EST)
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
To:     qemu-devel@nongnu.org
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Viktor Prutyanov <viktor.prutyanov@phystech.edu>,
        Kevin Wolf <kwolf@redhat.com>, Max Reitz <mreitz@redhat.com>,
        Fam Zheng <fam@euphon.net>,
        Laurent Vivier <lvivier@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Greg Kurz <groug@kaod.org>,
        Alistair Francis <alistair@alistair23.me>, kvm@vger.kernel.org,
        qemu-block@nongnu.org, qemu-ppc@nongnu.org
Subject: [PATCH 7/9] accel/kvm: avoid using predefined PAGE_SIZE
Date:   Mon, 21 Dec 2020 08:53:16 +0800
Message-Id: <20201221005318.11866-8-jiaxun.yang@flygoat.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201221005318.11866-1-jiaxun.yang@flygoat.com>
References: <20201221005318.11866-1-jiaxun.yang@flygoat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As per POSIX specification of limits.h [1], OS libc may define
PAGE_SIZE in limits.h.

To prevent collosion of definition, we discard PAGE_SIZE from
defined by libc and take QEMU's variable.

[1]: https://pubs.opengroup.org/onlinepubs/7908799/xsh/limits.h.html

Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 accel/kvm/kvm-all.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 389eaace72..3feb17d965 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -58,6 +58,9 @@
 /* KVM uses PAGE_SIZE in its definition of KVM_COALESCED_MMIO_MAX. We
  * need to use the real host PAGE_SIZE, as that's what KVM will use.
  */
+#ifdef PAGE_SIZE
+#undef PAGE_SIZE
+#endif
 #define PAGE_SIZE qemu_real_host_page_size
 
 //#define DEBUG_KVM
-- 
2.29.2

