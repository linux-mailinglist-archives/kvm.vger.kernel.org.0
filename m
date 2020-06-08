Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0091F1929
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 14:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729180AbgFHMw7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 08:52:59 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29632 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728245AbgFHMw6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jun 2020 08:52:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591620776;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=gjI/Xc/cqqYk/lSVknmdrxtI4JosdROOwhqNKTqv88I=;
        b=NN+up0NcCTUYLGSto74dqIaj288wsdjwMReMgxuG5xHIC6uKe+pm2l+F2uEzqtTaZGQPtx
        8lnBaH4juCamqVOBunK/5J1j5ZPFD3xsTFOF0kSH2fsYwn6exM3U6/OjdZxBNQNeCR+8mL
        KmeQZKvR/AF+SbMqgCMEEIv+6vXfP+s=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-118-0XukzesxPYaj3BgPXm0wiw-1; Mon, 08 Jun 2020 08:52:55 -0400
X-MC-Unique: 0XukzesxPYaj3BgPXm0wiw-1
Received: by mail-wm1-f71.google.com with SMTP id g84so5214970wmf.4
        for <kvm@vger.kernel.org>; Mon, 08 Jun 2020 05:52:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=gjI/Xc/cqqYk/lSVknmdrxtI4JosdROOwhqNKTqv88I=;
        b=B/yzb0vI4iRr4QNhESMqYBKeWj5jgM8OXTDw8TWJQ7w9u+Ew35FKMjdC391lZSgd9K
         xfKbxAiNfVuu/UNtuNogJylPouF9uxkfo2/J2aW9yyts2KcFJHJFJZWmgT1rEpwPpIES
         slNLEZl7ppeij/QgZDHmp/z8MTAajhjq9nglySUKJnibTjSoOOPuLaGtAw9U0N+PFARq
         2JUhKTMDonL09dx6pqaqu1eJoQblYO9b3OlWdyNR0xEXwr4DxYw57WtQBW5fpeIsXdel
         94I+vqGdmiw1eI5j8D3WiRoe6ntWQmQ3HlqWELqFNno7+G2Hre++CIN2A16vnvMBuvjn
         nvrA==
X-Gm-Message-State: AOAM532aSqowdpcH55wAFDzPyoHOrLPf69gopxUIRXWXxB0Fd2mus8dj
        BOkv6nkIMmVvKeLc5cG8g7mTwCIK0ZNa64w+ZR1Mfqq6EQNSHhn12KYOaWJQJQ54ep2Vju6OnEN
        kb/aa2ilkWmcb
X-Received: by 2002:a05:6000:1ce:: with SMTP id t14mr23504279wrx.300.1591620773840;
        Mon, 08 Jun 2020 05:52:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwDSI+/ZbdtAMbTo/u8TmLBd4nOMtF+iSAUbirR2p1aEeZspsKsHQ+oW3THKUaNWxC1PVL/dQ==
X-Received: by 2002:a05:6000:1ce:: with SMTP id t14mr23504259wrx.300.1591620773666;
        Mon, 08 Jun 2020 05:52:53 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id y19sm21769323wmi.6.2020.06.08.05.52.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2020 05:52:52 -0700 (PDT)
Date:   Mon, 8 Jun 2020 08:52:51 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        eperezma@redhat.com
Subject: [PATCH RFC v6 00/11] vhost: ring format independence
Message-ID: <20200608125238.728563-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 2.24.1.751.gd10ce2899c
X-Mutt-Fcc: =sent
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



This adds infrastructure required for supporting
multiple ring formats.

The idea is as follows: we convert descriptors to an
independent format first, and process that converting to
iov later.

Used ring is similar: we fetch into an independent struct first,
convert that to IOV later.

The point is that we have a tight loop that fetches
descriptors, which is good for cache utilization.
This will also allow all kind of batching tricks -
e.g. it seems possible to keep SMAP disabled while
we are fetching multiple descriptors.

For used descriptors, this allows keeping track of the buffer length
without need to rescan IOV.

This seems to perform exactly the same as the original
code based on a microbenchmark.
Lightly tested.
More testing would be very much appreciated.

changes from v5:
	- addressed comments by Jason: squashed API changes, fixed up discard

changes from v4:
	- added used descriptor format independence
	- addressed comments by jason
	- fixed a crash detected by the lkp robot.

changes from v3:
        - fixed error handling in case of indirect descriptors
        - add BUG_ON to detect buffer overflow in case of bugs
                in response to comment by Jason Wang
        - minor code tweaks

Changes from v2:
	- fixed indirect descriptor batching
                reported by Jason Wang

Changes from v1:
	- typo fixes


Michael S. Tsirkin (11):
  vhost: option to fetch descriptors through an independent struct
  vhost: use batched get_vq_desc version
  vhost/net: pass net specific struct pointer
  vhost: reorder functions
  vhost: format-independent API for used buffers
  vhost/net: convert to new API: heads->bufs
  vhost/net: avoid iov length math
  vhost/test: convert to the buf API
  vhost/scsi: switch to buf APIs
  vhost/vsock: switch to the buf API
  vhost: drop head based APIs

 drivers/vhost/net.c   | 174 ++++++++++---------
 drivers/vhost/scsi.c  |  73 ++++----
 drivers/vhost/test.c  |  22 +--
 drivers/vhost/vhost.c | 382 +++++++++++++++++++++++++++---------------
 drivers/vhost/vhost.h |  44 +++--
 drivers/vhost/vsock.c |  30 ++--
 6 files changed, 443 insertions(+), 282 deletions(-)

-- 
MST

