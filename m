Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED678521536
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 14:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241690AbiEJM14 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 08:27:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241720AbiEJM1z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 08:27:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A76892218FB
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 05:23:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652185437;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=7m17XESO0G49jDg02rMzQLZSx70dw+GOL5ZFcuicuDo=;
        b=TBBLy/alubZ89OqlFfHTKaoMvRccKoY7J9H9itFODM3llr8WVpAJyg7XWWEKf+f+xu427D
        jBlcgLyJbTYvUxBaBeaiLPBka7j2CwOKMa0A5loUBl1WPkJUgOqb/HmXYUUKAGfu2gzt+R
        0Rx4tdOmV1GqxEczDMmXynTU5LhgtQU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-313-9gLe4v1XPEqO4KDz_TXNpw-1; Tue, 10 May 2022 08:23:56 -0400
X-MC-Unique: 9gLe4v1XPEqO4KDz_TXNpw-1
Received: by mail-wm1-f72.google.com with SMTP id k5-20020a05600c0b4500b003941ca130f9so5225367wmr.0
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 05:23:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=7m17XESO0G49jDg02rMzQLZSx70dw+GOL5ZFcuicuDo=;
        b=qqXDkVchbc6VWiVvL2W8B2Tl2elHdvlvseimlgUM+iQz55onO6G6PLovQskl//nVrn
         o8BcptxBycRKO9D/HlbzvB4qlUiu8pEjQTEU7KNoQ+Akx9pck3X6wvhiCS5x/Ng+8ZPV
         8THsHrd+VvAc4vOzXvZna+b5M1wkqxrq4Q1x37oHa4R4KPh6b6ISA1hqXmeNBvcnCRm0
         xuMzQcP6PuCQ4R+lgSFVfI0fEthfVh0B4FvpyL1OZGXRtfeEnu1FsDCFxSqdBsgCCCxq
         78YUv6oZ1ZRgLrPtQxYt91NIqsvrwrdN7w9iXtCwB98mvBQDdP5sf/9DK0deiPgaxHFO
         E/3A==
X-Gm-Message-State: AOAM533PGaIyGak4cym2ywIFvfpD4+6yLyuBHOqRP7+pFn8dGvJcrmWd
        DC/Xpip2Jdx74M8TjvFOb+NTfNoIrPktGFyecFQpt6vCr/hGW0hYiD5BddYBAh/kh3BcNCfmYaR
        Xt3BDN9QMZ30O
X-Received: by 2002:a05:600c:1552:b0:394:52a9:e48a with SMTP id f18-20020a05600c155200b0039452a9e48amr27849867wmg.45.1652185434975;
        Tue, 10 May 2022 05:23:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwsBADRFdiPYDIntIzaGZobSQWMrIRqRIfrtkXtgAgFq5t+PGvub34r/lKVUbvjx0CiBVRltA==
X-Received: by 2002:a05:600c:1552:b0:394:52a9:e48a with SMTP id f18-20020a05600c155200b0039452a9e48amr27849841wmg.45.1652185434656;
        Tue, 10 May 2022 05:23:54 -0700 (PDT)
Received: from redhat.com ([2.55.130.230])
        by smtp.gmail.com with ESMTPSA id n21-20020a1c7215000000b0039489e1bbd6sm2373609wmc.47.2022.05.10.05.23.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 05:23:54 -0700 (PDT)
Date:   Tue, 10 May 2022 08:23:51 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mie@igel.co.jp, mst@redhat.com
Subject: [GIT PULL] virtio: last minute fixup
Message-ID: <20220510082351-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit 1c80cf031e0204fde471558ee40183695773ce13:

  vdpa: mlx5: synchronize driver status with CVQ (2022-03-30 04:18:14 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 7ff960a6fe399fdcbca6159063684671ae57eee9:

  virtio: fix virtio transitional ids (2022-05-10 07:22:28 -0400)

----------------------------------------------------------------
virtio: last minute fixup

A last minute fixup of the transitional ID numbers.
Important to get these right - if users start to depend on the
wrong ones they are very hard to fix.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Shunsuke Mie (1):
      virtio: fix virtio transitional ids

 include/uapi/linux/virtio_ids.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

