Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50865496847
	for <lists+kvm@lfdr.de>; Sat, 22 Jan 2022 00:36:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbiAUXgY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jan 2022 18:36:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiAUXgX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jan 2022 18:36:23 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46E80C06173B
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 15:36:23 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id f21so2355025ljc.2
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 15:36:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=S3JtR5HtN5TgHtZRkOpXh8ju3yrdK90cRx1M8SbEib4=;
        b=iGQ1kx8Lv1xOc0A/Y+ulC6dX+YtjkCNidSlBMzPiPvNFEUrYfQ1iP104N/UXFD/DM3
         YrS5izMn4m5LdNaq5g57NV8w6AfaAJWyU0smS+00gGjJZBzwxkSstuB2a6D2v1PuvAvD
         +GinzefERioagtI+CFtF/NcHlmLYjUUJrZk738qYad7lsn9rIt6OTrclJvFaGmLdlkMX
         07YgWk6mbMtLQpHDkbz6fjoaGQ2MYgjQquaU0jRN//ed48WsAyxtjKZxfLX8ttFC6RXg
         e4x4GFr3gKznJId7yCn7noawDntbu5YLo3lDrrrNuVR5TUCfeGK/ye5OGMxo/zlVUNvc
         YBjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=S3JtR5HtN5TgHtZRkOpXh8ju3yrdK90cRx1M8SbEib4=;
        b=p6hZirHTX4XLgK3+wlgju2zHh4tTET78SGe7yuJsDXuMmnWMa0qJINsU9ykc4ZWnWf
         zfA0irkZ+qBk26pnY7xs8pvAMRKzG3XNf8bZt7ZaYdaqmXjHWbSa4TJ2GWJKUQv1Wcam
         VmdgCzlp8ePOtt5dvINBSir3vZRCFBu/ySXMOV3bSTQjLPuGghZBsrbdD7lfd2jJ+KJ2
         0/exOnbVmtg36/V9FW/khESEjWheoh+kb8DF4PIiEh9Yl9P5Uk2PxBBjfskcHY693YlE
         w9euNKh5Rirfn9kexdn7UFNXsTNO3g3mo4CWxLdpJYZQ4VUcN/vl1ENukzlWujzCRAZm
         CJbQ==
X-Gm-Message-State: AOAM531A4iZ0JD+QTMDQbR5Wc4M3anGCTN5x4NMrDwrZCPcVorPdeDrG
        1ocKl4FiJdhohcqp5W1YMt2CUFSohBgI4Mq8m1s=
X-Google-Smtp-Source: ABdhPJzpxOqXpnh86UqXsZ4IZN+ucScq/nxHVGRulldQRBATQFPKxjwJM5KHuoQXL3SZTlrZG0Ni7DczR/U1lICGrRo=
X-Received: by 2002:a2e:a5c9:: with SMTP id n9mr4677998ljp.220.1642808181566;
 Fri, 21 Jan 2022 15:36:21 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a2e:aa14:0:0:0:0:0 with HTTP; Fri, 21 Jan 2022 15:36:20
 -0800 (PST)
Reply-To: fionahill.usa@outlook.com
From:   Fiona Hill <xaviergbesse.2020@gmail.com>
Date:   Fri, 21 Jan 2022 15:36:20 -0800
Message-ID: <CABEvWU+mNJEkh+44FWtp3Ra50zE=vStCUAopGD8X1yyPBUyQsA@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

-- 
Please with honesty did you receive my message i send to you?
