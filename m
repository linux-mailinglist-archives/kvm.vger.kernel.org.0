Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C106627290
	for <lists+kvm@lfdr.de>; Sun, 13 Nov 2022 21:34:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235571AbiKMUex (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Nov 2022 15:34:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235555AbiKMUe1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Nov 2022 15:34:27 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2A7B13F6C;
        Sun, 13 Nov 2022 12:34:10 -0800 (PST)
Message-ID: <20221113202428.826924043@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1668371649;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=9n3aIAM3i/w/SWEjCKVqCRgG7FqJkpwLV1zA3Yc4Jjk=;
        b=XllPcCvHYkUtYdS6IY20VT8wSpYOoIokgtXoFFj2b5WbHZOuL0JzBL+v9VCJ7uLfp+2VsY
        MsPNVyIwwBsILmxj0up9OGFwhEAkjmD+y2pcSOnAklxZ6hOOyGElbXsD4CpPImux31dzi/
        fwFE4pR1ztD7vRhsEwUxnSkst0qBoC8yPHgzybc5B8iweeLHKXia8JRKce99oaGTmLK/uP
        B95oNtjG7BBRAQpkbpj3M0T9X2+aTQmxD0QQ6jJ8KH7Z33rCM5mp1IeJek8lgpuoVdf81V
        3fQBMoV7WBEzdhm+nC5DRaTn7HOJYH2QI8Ypifm3OA7553oE5AvmIf7FTJQcPw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1668371649;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=9n3aIAM3i/w/SWEjCKVqCRgG7FqJkpwLV1zA3Yc4Jjk=;
        b=Rv6HGPSvDl+ttirH4Ch5mj3V1YDn+38YK7JDr2dvho0KeLyIbG5hbU+u8M8bOXqmGBMYtC
        B+qV0YjzkVNW9hCQ==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Marc Zyngier <maz@kernel.org>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: [patch 09/10] vfio/fsl-mc: Remove linux/msi.h include
References: <20221113201935.776707081@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Sun, 13 Nov 2022 21:34:08 +0100 (CET)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nothing in this file needs anything from linux/msi.h

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Diana Craciun <diana.craciun@oss.nxp.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Cornelia Huck <cohuck@redhat.com>
Cc: kvm@vger.kernel.org
---
 drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
@@ -8,7 +8,6 @@
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/eventfd.h>
-#include <linux/msi.h>
 
 #include "linux/fsl/mc.h"
 #include "vfio_fsl_mc_private.h"

