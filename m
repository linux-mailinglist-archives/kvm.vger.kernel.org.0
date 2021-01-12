Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2C002F3AD6
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 20:47:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406787AbhALTnA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 14:43:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406619AbhALTnA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 14:43:00 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 582D8C0617A2
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 11:41:56 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id y23so3237084wmi.1
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 11:41:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=9oioH7fTimHXbwiOIluI6SOkD883+857JncYScStEP4=;
        b=JmO6IQKgjQY+7ho4ih3Bdmj0eRPnup/UlujCGZhO4AJhanp3QH0J71/SQjiI8RlftE
         LxVkn1U86G3tkyTL1V1ekzv7AG4aQUuBC1r0RvRBoERwudQRkTXIem4aavnr56WrANo8
         gOtBpR9pRxwKu1xDJhfk/82GSYbgzv2ibgNt5w0f4THTbGm6h2zSgqNsqz15NEjpA55j
         jhso19OBmu3jzIh6d8tb1TXJSzru4eS/fD3T3nWv1umUB8RNCOvvnnPdOKeCNLkCN3mh
         BIGrXTEThybGX1OaJSNIbNpsSW/dNQUVwxByoyviBmYkIkBVcUXJ03lrcjitMvDn4T//
         igkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=9oioH7fTimHXbwiOIluI6SOkD883+857JncYScStEP4=;
        b=rLxWvbhmCW6fzosECY/I3yKCnfPVHF7XdpPlMR/7I7Q5Z8zWUeEZcGjkRsTY+X3Zc9
         a06QrTb3DAE6viIcu+jtYdkC00RMayqpsvICoKwv2kc7cFWN1aFa5oPqeumyJ0iqEpp5
         ONYMiR30/jmaWXQ7DWMlYw/4q1/8eqdLNzwDTYoQp7JmROKF95fxn4sqQ3Scd2WobP4c
         BpP3gmTtgKj1bOnJ0Yu4zJOIhx1QWnGw2OCb/YnggraHBOeiMwlU4ynaTfud4trxbhBs
         PHQaXocJtweqYYrEXu0vrVnk00I6j/KO/De/catdnXKg1W8hiLyQUspJUsbAFX6cvqQe
         7GLA==
X-Gm-Message-State: AOAM533/NEvsQjeJZ82Ln6CzozEwrFCtLuLutmNw6fAlkvmDbSHiOkSg
        Ov4sjMfF1ALndslgQUaumFpMIg==
X-Google-Smtp-Source: ABdhPJxLSdWWpfIxaQGNHeFfQoIuyfHcKNbVYBL99mebz4m6+1+6/6514Is75EyggDSS6XrPJMXKGw==
X-Received: by 2002:a1c:b742:: with SMTP id h63mr780567wmf.122.1610480514861;
        Tue, 12 Jan 2021 11:41:54 -0800 (PST)
Received: from f2.redhat.com (bzq-79-183-72-147.red.bezeqint.net. [79.183.72.147])
        by smtp.gmail.com with ESMTPSA id z63sm4885315wme.8.2021.01.12.11.41.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 12 Jan 2021 11:41:54 -0800 (PST)
From:   Yuri Benditovich <yuri.benditovich@daynix.com>
To:     davem@davemloft.net, kuba@kernel.org, mst@redhat.com,
        jasowang@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        rdunlap@infradead.org, willemb@google.com, gustavoars@kernel.org,
        herbert@gondor.apana.org.au, steffen.klassert@secunet.com,
        nogikh@google.com, pablo@netfilter.org, decui@microsoft.com,
        cai@lca.pw, jakub@cloudflare.com, elver@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Cc:     yan@daynix.com
Subject: [RFC PATCH 0/7] Support for virtio-net hash reporting
Date:   Tue, 12 Jan 2021 21:41:36 +0200
Message-Id: <20210112194143.1494-1-yuri.benditovich@daynix.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Existing TUN module is able to use provided "steering eBPF" to
calculate per-packet hash and derive the destination queue to
place the packet to. The eBPF uses mapped configuration data
containing a key for hash calculation and indirection table
with array of queues' indices.

This series of patches adds support for virtio-net hash reporting
feature as defined in virtio specification. It extends the TUN module
and the "steering eBPF" as follows:

Extended steering eBPF calculates the hash value and hash type, keeps
hash value in the skb->hash and returns index of destination virtqueue
and the type of the hash. TUN module keeps returned hash type in
(currently unused) field of the skb. 
skb->__unused renamed to 'hash_report_type'.

When TUN module is called later to allocate and fill the virtio-net
header and push it to destination virtqueue it populates the hash
and the hash type into virtio-net header.

VHOST driver is made aware of respective virtio-net feature that
extends the virtio-net header to report the hash value and hash report
type.

Yuri Benditovich (7):
  skbuff: define field for hash report type
  vhost: support for hash report virtio-net feature
  tun: allow use of BPF_PROG_TYPE_SCHED_CLS program type
  tun: free bpf_program by bpf_prog_put instead of bpf_prog_destroy
  tun: add ioctl code TUNSETHASHPOPULATION
  tun: populate hash in virtio-net header when needed
  tun: report new tun feature IFF_HASH

 drivers/net/tun.c           | 43 +++++++++++++++++++++++++++++++------
 drivers/vhost/net.c         | 37 ++++++++++++++++++++++++-------
 include/linux/skbuff.h      |  7 +++++-
 include/uapi/linux/if_tun.h |  2 ++
 4 files changed, 74 insertions(+), 15 deletions(-)

-- 
2.17.1

