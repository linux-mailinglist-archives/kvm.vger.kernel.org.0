Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4BF2596EBB
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 14:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236316AbiHQMsv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 08:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236069AbiHQMst (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 08:48:49 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76650275F6;
        Wed, 17 Aug 2022 05:48:48 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id 2so719011pll.0;
        Wed, 17 Aug 2022 05:48:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=Pw2ziCBFjdMNwfRTVesA2FVzIM/meYRxXgqNG8+h8SQ=;
        b=UdLeytDilvtK7TE7wnHoUDKLLRMT7ZiDF+8QX8ffknaPuUN0gzXB+je8GTgR70gmLm
         3YE77vveQSVP07fbRlkx6Oyp4ZWUvWeW2wccqmiSammcZfieOIN9mDBggm12dUGO4vuq
         M/3ePBd0xV894up0sEkHYtAR0qqnd6hGK6/iboNn5HRp6f0PbjJGuuBs+CrCCPAoy2UZ
         C/pkdy/gz3/8lQUJqpsFj+JbFpoOQS3ypdpDeBCADSP0HbQcxUy4WrMyeAvjwhv0Z0Ja
         ucsMKfMeVep9jzxKxgAsHgm4EO96Xbp94C/7EFsCB1TiSdsM7NuCJe8wKvGwW0qhGlu8
         0UGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=Pw2ziCBFjdMNwfRTVesA2FVzIM/meYRxXgqNG8+h8SQ=;
        b=i4RAYLF48UUGIfICDrnHC5BL2kvNPhRljMNP1+/Tx1NdO7ArGginwwxJosyvwJ0e+S
         pt+Rmt17uNmBXzLQZmHrenhm5XWqP+HYCSyHuxWca3E4C9kYJyMGuI8uTEaCPtuTeGEP
         HXHKYL3CGQJRcCf7W37ylQeaDFXxvcttl5NJSP9KO0P3xx+cg2nQ3VaTpIZ9a0e5GwdQ
         9VMTJzhBY/AENjshtZstINFWMgtsF2x/T6ryZSe7nA6ovrOTYEz4j0gpZxsLz9SLQzS1
         7n0ZcW2DYknzqRyWOcEfFBLH+n7IsBHYjIUTjkuE03UWtsHYeuOVsXV2sCB12AzOXfgX
         alOQ==
X-Gm-Message-State: ACgBeo1XAPtDps6WKcPzcF643rgisrdPkr/fetcR4ENO/m4SA33+SLCQ
        7oM/P1/Lnzzpm6H5JXqTS70+CDx2oqwSdQ==
X-Google-Smtp-Source: AA6agR45UKDdWzy5UCX7iUJcxqu1XUyLmfy2IvukBqEKWZHd6RCGTpfdyNcapyAyNw28ZwBeTS1cHQ==
X-Received: by 2002:a17:902:ce84:b0:16f:81d2:60c with SMTP id f4-20020a170902ce8400b0016f81d2060cmr26025594plg.57.1660740527758;
        Wed, 17 Aug 2022 05:48:47 -0700 (PDT)
Received: from debian.. (subs32-116-206-28-37.three.co.id. [116.206.28.37])
        by smtp.gmail.com with ESMTPSA id q5-20020a170902a3c500b0016a4db13429sm1386962plb.192.2022.08.17.05.48.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 05:48:47 -0700 (PDT)
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
Subject: [PATCH v2 0/3] Documentation fixes for kvm-upstream-workaround
Date:   Wed, 17 Aug 2022 19:48:34 +0700
Message-Id: <20220817124837.422695-1-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=882; i=bagasdotme@gmail.com; h=from:subject; bh=7mMszb66lOIr4IPwkedLbsrMRPhp6frLMXsPoXcvrPU=; b=owGbwMvMwCH2bWenZ2ig32LG02pJDEl/Hi/RyY7I3uK58/ph11D/Lcob+I72KzP0H9ScsU9hluKN 45GJHaUsDGIcDLJiiiyTEvmaTu8yErnQvtYRZg4rE8gQBi5OAZiIkhHD/9grGS3RTzWy3cXn/drCf9 ioexn/lZcTFqhfXvEpTMhm3weGPzz3Pv9kfcMTfd5zFaeqW+sGkyoL5pm+Nk8eWHwX4d7NwwQA
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

Changes since v1 [2]:
  - Wrap description of "shutdown" status to fit the table
  - Add Reported-by from kernel test robot

[1]: https://github.com/intel/tdx.git
[2]: https://lore.kernel.org/linux-doc/20220817095405.199662-1-bagasdotme@gmail.com/

Bagas Sanjaya (3):
  Documentation: ABI: tdx: fix formatting in ABI documentation
  Documentation: ABI: tdx: grammar improv
  Documentation: kvm: enclose the final closing brace in code block

 Documentation/ABI/testing/sysfs-firmware-tdx | 62 ++++++++++----------
 Documentation/virt/kvm/api.rst               |  2 +-
 2 files changed, 33 insertions(+), 31 deletions(-)


base-commit: 85c097fdd1667a842a9e75d8f658fc16bd72981a
-- 
An old man doll... just what I always wanted! - Clara

