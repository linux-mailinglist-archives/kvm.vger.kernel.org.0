Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 345B6590829
	for <lists+kvm@lfdr.de>; Thu, 11 Aug 2022 23:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233685AbiHKVgn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Aug 2022 17:36:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234385AbiHKVgk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Aug 2022 17:36:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A134B9F19C
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 14:36:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660253798;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=WZaycEP+nZLu18YDIzSaBPrfwBpX8nQzmEAF9yLISJU=;
        b=HpWzzgvG1o4EMKooZOrS8jPotklnuscc/e5DgX+LiK3x8+6SJQ/c6LCtO+hCdV5+fvFgdk
        7kA1QFRW0O0V3N57wmus1uoWrbZI1aij2a5zfp/am5URKv3jtoOOnGD2LPQuqBC+ih6V6E
        88JLwdSRuqurm/cDFwlWFRa12lrZnEc=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-512-mNnGnAxPP2az2BF9sPRfuA-1; Thu, 11 Aug 2022 17:36:36 -0400
X-MC-Unique: mNnGnAxPP2az2BF9sPRfuA-1
Received: by mail-il1-f197.google.com with SMTP id d6-20020a056e020c0600b002deca741bc2so13349921ile.18
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 14:36:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:message-id
         :subject:to:from:date:x-gm-message-state:from:to:cc;
        bh=WZaycEP+nZLu18YDIzSaBPrfwBpX8nQzmEAF9yLISJU=;
        b=VxapVW4MrTc0B/BwGpxMzLr6DHmIYyuBPJcFDkrDyKe7YY8A109AUDGabxaIGTqMSv
         ugc1r5cKDM3sTNeU48bcA0+3MQnzv5tRPG68y+0sLdLQZ4lJOhP+gz3DRIL//VOACs4Y
         xtDqw6bEi3Ee38hiBad4qVQbEOG/r5mz/yhQ/Sak3YhPsMeiMT49NNGHLXNLNZubQhpC
         SxPOMVxQC6p+HRg2PeUgWkTnZygbSxKeoH6cVDsocahSyfAPBU1VjcGBluj52pLPv4m9
         x/jnIv/a3LHJmqJjukcVOElswb0r9l+oS69QwloREisX7+/bNredMn6tbxIYsBdJotNt
         CutQ==
X-Gm-Message-State: ACgBeo2sW7MhZ9PQIcoc8P05Es8FyhlEGIQ2LZcc+v5GqZzaLm3tV6jW
        13rOW9RrtySQxcDuYqwMk16hUkL4y+6IkwMVI9ICgg+T0AT5lPwpRo+qTdT3NTqwNfIayhCNlTf
        sv5mxvR4Wm3Dn
X-Received: by 2002:a05:6638:e82:b0:343:4d92:616f with SMTP id p2-20020a0566380e8200b003434d92616fmr595763jas.166.1660253795906;
        Thu, 11 Aug 2022 14:36:35 -0700 (PDT)
X-Google-Smtp-Source: AA6agR50tuCMR24UpJfhk188DB8Xdy34VDTNqzsXG7dfF/SZhinsloUn7kB/WWc1sWNK8jFGJUw8qQ==
X-Received: by 2002:a05:6638:e82:b0:343:4d92:616f with SMTP id p2-20020a0566380e8200b003434d92616fmr595748jas.166.1660253795155;
        Thu, 11 Aug 2022 14:36:35 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id y7-20020a029507000000b00342a1021507sm245720jah.123.2022.08.11.14.36.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Aug 2022 14:36:34 -0700 (PDT)
Date:   Thu, 11 Aug 2022 15:36:32 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [GIT PULL] VFIO updates for v6.0-rc1 (part 2)
Message-ID: <20220811153632.0ce73f72.alex.williamson@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Linus,

We've had a request to get this into the current merge window to ease
re-bases in the next development cycle.  Thanks,

Alex

The following changes since commit c8a684e2e110376c58f0bfa30fb3855d1e319670:

  Merge tag 'leds-5.20-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/pavel/linux-leds (2022-08-08 11:36:21 -0700)

are available in the Git repository at:

  https://github.com/awilliam/linux-vfio.git tags/vfio-v6.0-rc1pt2

for you to fetch changes up to 0f3e72b5c8cfa0b57dc4fc7703a0a42dbc200ba9:

  vfio: Move vfio.c to vfio_main.c (2022-08-08 14:33:41 -0600)

----------------------------------------------------------------
VFIO updates for v6.0-rc1 (part 2)

 - Rename vfio source file to more easily allow additional source
   files in the upcoming development cycles (Jason Gunthorpe)

----------------------------------------------------------------
Jason Gunthorpe (1):
      vfio: Move vfio.c to vfio_main.c

 drivers/vfio/Makefile                | 2 ++
 drivers/vfio/{vfio.c => vfio_main.c} | 0
 2 files changed, 2 insertions(+)
 rename drivers/vfio/{vfio.c => vfio_main.c} (100%)

