Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1168C54B14E
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 14:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231607AbiFNMhX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 08:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240457AbiFNMfs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 08:35:48 -0400
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7425E4E3B2
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 05:33:37 -0700 (PDT)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-f2a4c51c45so12246685fac.9
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 05:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=lBFrwc11MgcaK75qf3EwNhKoIfwLYz4Dn7scEjO7Hwc=;
        b=nvun95AWT6Pj/aAQ1POFbWnUxOJb96XM8RRYwAQGvMiIG2HNF/ffNXEyIEPdGi4pCe
         /pN4QUwuXi5liVQv0xelZoI0/d8nhCLwwfcp5x6D8Q0Zgi9qu3uHQ9K3r9inBtRGLNdm
         dJxbvltmX26tXEfTrLE775LA8PTWcHrHKTHZbj6ar2xuG+IBcKAxFc9feFw/rVjOinjM
         d2K0VixqXuUEF9sSZ1ncxBh/AIX9YwOS9SUbNTNBwY8LMzEvyWNOc2uqdII2PLM008hx
         OMKF8jhaewqRgXgXDzwF0Qz5jj312F1V/OsLXRKYF8Z807vrMyBioSzaW6JxLxpG56jM
         15ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=lBFrwc11MgcaK75qf3EwNhKoIfwLYz4Dn7scEjO7Hwc=;
        b=qcRJC1Bk537mOCQ9aLpevRw54ZNPNWfWFP1YH8pD1hQ3xWhBJ65SIuzC4isAkRgIVf
         DtAi2wmzur8/ticFGaLDtLhoafpwfAmh/vqO5xVbwIA9DXpTFCNA4WFAoDTGpS5tYETr
         zifKBzbN7RJsyViN0Tk3fpR6pwq9MQ9o94D5U9wGol0Bq5CdS8FPl9Ii+89PpLWKJ9qW
         chtfqxNAk4TOhIb3hfEpNlbIXRvL3iJko+SR6fB1WmQxiNXXZVBRhj90Uh05DTi2YPy3
         HT5s8cXIR3aujy4O4pJgd1xjmsA2G8LgQYKmHA03Tl8yaNfMqawu/DP6Xzw+iwBEsmh1
         FvUw==
X-Gm-Message-State: AJIora/kFT35goXmZZKU6IoBLiW42Ar/VCL3JCTt1M+cKxvKGnNLskWz
        r7TW82XiicBP7CAN+XD0ggGZZ6naQUO2WRl63EE=
X-Google-Smtp-Source: AGRyM1vqaYxoz8MaMagMgpi4PwyluR1vVSr7dFRb/3zybM4zHc5ux5HsJmFjCHUDUD+LxMrnaGzo6e2tftPV0bT14Y8=
X-Received: by 2002:a05:6870:d287:b0:f1:c50b:9dd1 with SMTP id
 d7-20020a056870d28700b000f1c50b9dd1mr2122959oae.45.1655210016739; Tue, 14 Jun
 2022 05:33:36 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:c46:0:b0:42d:ab20:ed24 with HTTP; Tue, 14 Jun 2022
 05:33:36 -0700 (PDT)
From:   Daniel Affum <danielaffum05@gmail.com>
Date:   Tue, 14 Jun 2022 15:33:36 +0300
Message-ID: <CAPkju_Os2kV1jKehak7CM1vB3n9J-evikeAet3ndoMWFYqtoAw@mail.gmail.com>
Subject: Confirm Receipt
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=1.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Dear,

I am Daniel Affum a retired civil servant i have a  business to
discuss with you from the Eastern part of Africa aimed at agreed
percentage upon your acceptance of my hand in business and friendship.
Kindly respond to me if you are interested to partner with me for an
update.Very important.

Yours Sincerely,
Daniel Affum.
Reply to:danielaffum005@yahoo.com
