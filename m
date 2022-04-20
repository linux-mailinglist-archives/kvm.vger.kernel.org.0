Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1F55092B9
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 00:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382774AbiDTW2d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 18:28:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382772AbiDTW21 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 18:28:27 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1647440A3B;
        Wed, 20 Apr 2022 15:25:31 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id j6so2339063qkp.9;
        Wed, 20 Apr 2022 15:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zSf1GL9eubeAu2SSHZoa9QHUnjXkUaWTs3jcrLRRG7o=;
        b=IB+Ao/Wwsh2cprgs+BXA24MhK96+Zox6WxUF2ehNrx1BFrzPZV7JAWu4EFvsOtu7Iu
         YxETq/bn/pHm/OAmmR4pyblkfRLBRX8FmmvfAvteqDSXZL2/mewEl8dHQACtpk0T1/fS
         Vd1eFmxiEsSX7RvV81/urQwV88aFxIfIG3XXxIZ54tl2/mtxMUGMMLmg4dc9qATOEBIn
         9WhBmDfcIIaBAq+YgjhMWR8ulSAmcGjL9UGImfIiNr2FuS8tVNm000as9rZP7eeW/oIo
         J5Wqs9orX0mO1wldiSLWfIexV0XiT9wjHjbGM2KyEUgvv+G24T2ouN/DUf6y7tB03/C7
         7qtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zSf1GL9eubeAu2SSHZoa9QHUnjXkUaWTs3jcrLRRG7o=;
        b=ttRwI8ioIONIWxBLWEtriIugWOub4dQIDd3nnl0pipZrL7TMVi8Ii0ApnyAh1KxqlD
         jtoA9UuLSkV2WJ8x46nNw/9BEjqrH8HDAgiLJ8Z9tO9PWGjBRk+XAaIBXGv9FZQkzGOm
         aU19d8OIi3eF6wMrDzLZ44mY+elSkqS/EYqpmVtBV11EE1Cl0iHjxI5xgHieV/BJbQgH
         8smhDeUHfAgzafHQy3tG9W7SJ9QwJPPLKXVj34YJi+Rw7ve+hCjcWOerbnboc1BT06rz
         pRtt2VXAInQ2O5v4CHejEMGdIgohP+P3ZabEBzTWlash3Vzt4sBh7e2wyZKl10odvFZh
         Pfkg==
X-Gm-Message-State: AOAM532a5twKv/Ik9mosCzeFfhBzd/q5EwN5Xf/rQJLGt+rMr09Zxbye
        naq//IjG2Q0NTc1zlYX2GHBtLkX5dw8=
X-Google-Smtp-Source: ABdhPJwZK35fAiaLQ+j7TJ3EfZjXWxZdeKrrNFVTBDOtXlzg189KMCbYhzpcTl5qhDxdOMWY5Qur+A==
X-Received: by 2002:a37:f519:0:b0:69c:29e0:f740 with SMTP id l25-20020a37f519000000b0069c29e0f740mr14135823qkk.652.1650493529925;
        Wed, 20 Apr 2022 15:25:29 -0700 (PDT)
Received: from localhost ([2601:c4:c432:60a:188a:94a5:4e52:4f76])
        by smtp.gmail.com with ESMTPSA id d18-20020a05622a05d200b002f07ed88a54sm2806618qtb.46.2022.04.20.15.25.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 15:25:29 -0700 (PDT)
From:   Yury Norov <yury.norov@gmail.com>
To:     linux-kernel@vger.kernel.org,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Yury Norov <yury.norov@gmail.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH 0/4] bitmap: fix conversion from/to fix-sized arrays
Date:   Wed, 20 Apr 2022 15:25:26 -0700
Message-Id: <20220420222530.910125-1-yury.norov@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In the kernel codebase we have functions that call bitmap_copy()
to convert bitmaps to and from fix-sized 32 or 64-bit arrays. It
works well for LE architectures when size of long is equal to the
size of fixed type.

If the system is BE and/or size of long is not equal to the size of
fixed type of the array, bitmap_copy() may produce wrong result either
because of endianness issue, or because of out-of-bound access.

To address this problem we already have bitmap_{from,to}_arr32().
In recent discussion it was spotted that we also need 64-bit
analogue of it:
https://lore.kernel.org/all/YiCWNdWd+AsLbDkp@smile.fi.intel.com/T/#m754da92acb0003e12b99293d07ddcd46dbe04ada

This series takes care of it.

Yury Norov (4):
  lib/bitmap: extend comment for bitmap_(from,to)_arr32()
  lib: add bitmap_{from,to}_arr64
  KVM: s390: replace bitmap_copy with bitmap_{from,to}_arr64 where
    appropriate
  drm/amd/pm: use bitmap_{from,to}_arr32 where appropriate

 arch/s390/kvm/kvm-s390.c                      | 10 ++--
 .../gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c    |  2 +-
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c    |  2 +-
 include/linux/bitmap.h                        | 31 +++++++++---
 lib/bitmap.c                                  | 47 +++++++++++++++++++
 5 files changed, 77 insertions(+), 15 deletions(-)

-- 
2.32.0

