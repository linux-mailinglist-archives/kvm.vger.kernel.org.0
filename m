Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD6FF7243A9
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 15:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237734AbjFFNFr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 09:05:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237944AbjFFNFX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 09:05:23 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6C52E7A
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 06:05:20 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id ffacd0b85a97d-3094910b150so6210501f8f.0
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 06:05:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686056719; x=1688648719;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1xpIC4oCXJDkpNBSRGuPaqdbC+Y8smCgQBRBUHbLH5A=;
        b=xWcr8ck4TNtllrbLTeWyVNsVA1b4dC+0tDFN4rYR0epv0GgHPoL9Dkkkiu92UiLwGn
         YFjPUNVrLdoXylstYOmYYtL23vYHZQ/ZdXefo86faKGxjlQPfalnJYbnQJQD8VJAWli/
         cHxZC1hrBlxcWncULYJFrRmSxwmAQKf0HyhP4gyfH5Yk3ArDrFRtvO4xJ/v+cNqPEmdI
         HE2ztPFS/GocQ3BeQG2Di17wyWlgbwKIu8vmke1ZQU2pF0DS+X74tHt0jxi7HpjEnQB4
         psoSQts74GPMkNYQKeNWYMpt/64uq+BSnMa0NEOgpmNk991mqMK/FSEg7XpC43HP9z2c
         lzew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686056719; x=1688648719;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1xpIC4oCXJDkpNBSRGuPaqdbC+Y8smCgQBRBUHbLH5A=;
        b=AAfoE7bfoVJBVYlRg2iy0Np1FVdNxSqwD2wYEUKezMUIT96usaWpnqMHr5FAmQfZI6
         yDhTomKotonhl4jN6xprUO26mVUrqwZ0Rcs9L2HUuIsQFqOrJIvwdJq1iDKGkxs/adfT
         cxuhzGbSmFxxivNiTSuPJUN8gHnjhjQRSkoXjJbcwUsE+ep6Ile4A6mpYvVLfdSawd07
         LlGfWw4/pRttL5niNUdPTuGsz/ZrzNLMUx2XhOIZ090UaqHjtUXEru21YpY/+6ltFd73
         6j0nVvrr37h4bKM1bmqUgxzynjlw8Z+xryZCm8yjXMYxoJM4QSRoVtTx/gee45xMODUb
         Z1Zw==
X-Gm-Message-State: AC+VfDwiY2IPJjNuKloe4NO3gCZBNdUWoEQV6AAlSpP4VLL5fpz4LARk
        8VyKt1dsToBMCWpOyGdUROW+dBteAWqXh+LxKvABgA==
X-Google-Smtp-Source: ACHHUZ71AqW0WvB300VnsIpwY+J+p1jlc3EJ9yWD0lIfADoeMywG5DIw6EvE9/nYyz/lCA9OATNrHg==
X-Received: by 2002:adf:d083:0:b0:30e:46d4:64ee with SMTP id y3-20020adfd083000000b0030e46d464eemr2042105wrh.29.1686056719384;
        Tue, 06 Jun 2023 06:05:19 -0700 (PDT)
Received: from localhost.localdomain (5750a5b3.skybroadband.com. [87.80.165.179])
        by smtp.gmail.com with ESMTPSA id h14-20020a5d504e000000b00300aee6c9cesm12636125wrt.20.2023.06.06.06.05.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 06:05:19 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     kvm@vger.kernel.org, will@kernel.org
Cc:     andre.przywara@arm.com,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH kvmtool v2 12/17] virtio: Document how to test the devices
Date:   Tue,  6 Jun 2023 14:04:21 +0100
Message-Id: <20230606130426.978945-13-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230606130426.978945-1-jean-philippe@linaro.org>
References: <20230606130426.978945-1-jean-philippe@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a few instructions for testing the devices. Testing devices like
vhost-scsi or vsock may seem daunting but is relatively easy.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 Documentation/io-testing.txt | 141 +++++++++++++++++++++++++++++++++++
 1 file changed, 141 insertions(+)
 create mode 100644 Documentation/io-testing.txt

diff --git a/Documentation/io-testing.txt b/Documentation/io-testing.txt
new file mode 100644
index 00000000..c2e41902
--- /dev/null
+++ b/Documentation/io-testing.txt
@@ -0,0 +1,141 @@
+This document describes how to test each device, which is required when
+modifying the common I/O infrastructure.
+
+
+9P
+--
+
+  CONFIG_NET_9P_VIRTIO
+
+Without a --disk parameter, kvmtool shares part of the host filesystem
+with the guest using 9p. Otherwise, use the `--9p <directory>,<tag>`
+parameter to share a directory with the guest, and mount it in the guest
+with:
+
+	$ mount -t 9p <tag> <mountpoint>
+
+
+BALLOON
+-------
+
+  CONFIG_VIRTIO_BALLOON
+
+	$ lkvm run ... --balloon
+
+Display memory statistics:
+
+	$ lkvm stat -a -m
+		*** Guest memory statistics ***
+		...
+
+Remove 20MB of memory from the guest:
+
+	$ lkvm balloon -n guest-$(pidof lkvm) -i 20
+
+
+BLOCK
+-----
+
+  CONFIG_VIRTIO_BLK
+
+	$ lkvm run ... --disk <raw or qcow2 image>
+
+
+CONSOLE
+-------
+
+	$ lkvm run ... --console virtio
+
+See also virtio-console.txt
+
+
+NET
+---
+
+  CONFIG_VIRTIO_NET	(guest)
+  CONFIG_VHOST_NET	(host)
+
+By default kvmtool instantiates a user network device. In order to test
+both tap and vhost, setup a tap interface on a local network.
+
+In the host:
+
+	# ip tuntap add tap0 mode tap user $USER
+	# ip link set tap0 up
+	# ip link add br0 type bridge
+	# ip link set tap0 master br0
+	# ip link set br0 up
+	# ip addr add 192.168.3.1/24 dev br0
+
+	$ lkvm run ... -n mode=tap,tapif=tap0,vhost=1
+
+In the guest:
+
+	# ip link set eth0 up
+	# ip addr add 192.168.3.12/24 dev eth0
+	$ ping -c 1 192.168.3.1
+	64 bytes from 192.168.3.1: seq=0 ttl=64 time=0.303 ms
+
+
+RNG
+---
+
+  CONFIG_HW_RANDOM_VIRTIO
+
+	$ lkvm run ... --rng
+
+In the guest:
+
+	$ cat /sys/devices/virtual/misc/hw_random/rng_available
+	virtio_rng.0
+
+
+SCSI
+----
+
+  CONFIG_SCSI_VIRTIO	(guest)
+  CONFIG_TCM_FILEIO	(host)
+  CONFIG_VHOST_SCSI	(host)
+
+In the host, create a fileio backstore and a target:
+
+	# targetcli (https://github.com/open-iscsi/targetcli-fb)
+	/> cd backstores/fileio
+	/backstores/fileio> create kvmtool_1 /srv/kvmtool_1 2M
+	Created fileio kvmtool_1 with size 2097152
+	/backstores/fileio> cd /vhost
+	/vhost> create
+	Created target naa.500140571c9308aa.
+	Created TPG 1.
+	/vhost> cd naa.500140571c9308aa/tpg1/luns
+	/vhost/naa.50...8aa/tpg1/luns> create /backstores/fileio/kvmtool_1
+	Created LUN 0.
+
+	$ lkvm run ... --disk scsi:naa.500140571c9308aa
+	[    0.479644] scsi host0: Virtio SCSI HBA
+	[    0.483009] scsi 0:0:1:0: Direct-Access     LIO-ORG  kvmtool_1        4.0  PQ: 0 ANSI: 6
+
+	[    1.242833] sd 0:0:1:0: [sda] 4096 512-byte logical blocks: (2.10 MB/2.00 MiB)
+
+
+VSOCK
+-----
+
+  CONFIG_VSOCKETS
+  CONFIG_VIRTIO_VSOCKETS	(guest)
+  CONFIG_VHOST_VSOCK		(host)
+
+In the host, start a vsock server:
+
+	$ socat - VSOCK-LISTEN:1234
+
+We pick 12 as the guest ID. 0 and 1 are reserved, and the host has default
+ID 2.
+
+	$ lkvm run ... --vsock 12
+
+In the guest, send a message to the host:
+
+	$ echo Hello | socat - VSOCK-CONNECT:2:1234
+
+The host server should display "Hello".
-- 
2.40.1

