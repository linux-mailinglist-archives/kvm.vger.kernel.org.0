Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 540E0596C5E
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 11:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235728AbiHQJyT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 05:54:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233672AbiHQJyS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 05:54:18 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6269E5B795;
        Wed, 17 Aug 2022 02:54:16 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id q16so11557187pgq.6;
        Wed, 17 Aug 2022 02:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=4Y9Yj+WJAQVg1oq+iKnulf5PBZYdg82V2ciINSldoo8=;
        b=XIBizSV3Mo0WdnY9xWQW/9McM92TR3s7xuLUxAmjRlyK6X29gje8VLezR1wTVsDSTb
         Yug52nsVtfkZHPXi48alcITcRovhMxDZfbTTvDJMr1o2LaH7MlXdKXnmf+HOx+JNsqwT
         A2jUEzNjlgrLUian6E+6458QIZGIWJLzuFSWYvoYqeRRC2SvUq/qrmxQApREm3ShlRUx
         4iJJWWV02Pf/DjEP23eI9NqBsu1Sr1T9wbcp6fLbWtz9uQ6z0h/M/e5CJ5XkvSfYxkJ2
         Gc7mlxlobaSuirXNlejMnyYkHAnGF6KQiMoQflinBhM3xS95+vTnYgqpQEMNPhzIxQhE
         sfiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=4Y9Yj+WJAQVg1oq+iKnulf5PBZYdg82V2ciINSldoo8=;
        b=4US85SZ/pHquFTH1KTndhjimhB0D0wGxSO/OXu8JeKNtniQ0Gjz4dnHv1aof0ydhY9
         DtKBe0wAz2C7UnFMH2dcrxCAIT31MzVZalVLLWqPnvS/BSBWs/EWzOf7QpuT7SVAI5eZ
         HHVv7pU7wxEo06EkyvU4csRuNNkBYXjzm9UWM9JWrxlHW29O0HOxrYN+Sr9pY2LregG5
         Ss03WpxylfcsBDl874RbG9gQSiKRV6VPzFK7oR2dn+vPe3hrnh6G9f3d3jiuYeIKgX8Z
         MisttcWnwuuJKEJya+h8+EWL22/+61Z6qkAiTpXxTniZwosTcpympYXYtpj0a8chJqXR
         q57w==
X-Gm-Message-State: ACgBeo35voubE6CajRxV8CxzIUvUuYK74RywSfYdmmk6wegg4KUJGgFd
        WKtEJ4RoTshlWj5/Fet3y/nuCF/CUmo=
X-Google-Smtp-Source: AA6agR7Sr8WSnKJ2EFUWjkDRJIV/qHBjLkQUY+D+TR+E3P2+nqe/gtak8eMCSAE1NCVH9D1+y3E75Q==
X-Received: by 2002:a63:e906:0:b0:41b:eba0:8b6d with SMTP id i6-20020a63e906000000b0041beba08b6dmr20670492pgh.501.1660730055739;
        Wed, 17 Aug 2022 02:54:15 -0700 (PDT)
Received: from debian.. (subs03-180-214-233-18.three.co.id. [180.214.233.18])
        by smtp.gmail.com with ESMTPSA id l8-20020a170903120800b0016dbce87aecsm1066486plh.182.2022.08.17.02.54.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 02:54:15 -0700 (PDT)
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     linux-doc@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>
Subject: [PATCH 0/3] Documentation fixes for kvm-upstream-workaround
Date:   Wed, 17 Aug 2022 16:54:02 +0700
Message-Id: <20220817095405.199662-1-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=667; i=bagasdotme@gmail.com; h=from:subject; bh=/zFAEutciCM4CQX9VLhJ8crrgOuHqdZgYTGfc8hF22E=; b=owGbwMvMwCH2bWenZ2ig32LG02pJDEl/dm1mbjzRelPr6J2DE0rESnjuz8y2fztF++xW3WQpvYWq C9T6OkpZGMQ4GGTFFFkmJfI1nd5lJHKhfa0jzBxWJpAhDFycAjCRpesY/tkf+l5hf6giRnHti/hjX/ YI1b1co8vVcSDr+8X7Jn8Kem0Z/krJf9a7H9aT3xodcdEpnGfR36lNslLXPOaWPb5zYtJSf2YA
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Here is documentation fixes for kvm-upstream-workaround branch of TDX
tree [1]. The fixes below should be self-explanatory.

[1]: https://github.com/intel/tdx.git

Bagas Sanjaya (3):
  Documentation: ABI: tdx: fix formatting in ABI documentation
  Documentation: ABI: tdx: grammar improv
  Documentation: kvm: enclose the final closing brace in code block

 Documentation/ABI/testing/sysfs-firmware-tdx | 61 ++++++++++----------
 Documentation/virt/kvm/api.rst               |  2 +-
 2 files changed, 32 insertions(+), 31 deletions(-)


base-commit: 85c097fdd1667a842a9e75d8f658fc16bd72981a
-- 
An old man doll... just what I always wanted! - Clara

