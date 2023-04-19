Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE96B6E7AB7
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 15:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233465AbjDSN2G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 09:28:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233400AbjDSN16 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 09:27:58 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2446549D6
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 06:27:51 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id d8-20020a05600c3ac800b003ee6e324b19so1438776wms.1
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 06:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681910869; x=1684502869;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=81uxyuscrQ/gZcha8TPra4ym0kBDH5BwVhM3rEYE4OE=;
        b=BmEK08wxnMyw5wJ7AXb8roz4nE0XWgAHlCBiI3EmhYmL4tC+lIN46PnjSqJuH4psX8
         3K+NYmS79qtjR3rtTUOb6TR7XferYjrCjzeX5QUyqPIXwRKPvTXtuTfnLe9QXRKbUC9O
         OSmDgV0U2e29FKOQVUe7Da31pvNcBbOmiT5zxm5Yc+FfN6H1iGLKaKS1Gf1yA/y2ImxL
         7cjcLx0f4xn/UysjRaEmHUaSE2bsW4PUUMguXMUb+OSIexfw+VVbKr+FewDWipRvImJd
         FZhnLSD5zPy9cC1fkY2DmogspuXDNvGayic8Xq+r5AC14rihNdSxyiMZt4vQPa+jrODZ
         w5kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681910869; x=1684502869;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=81uxyuscrQ/gZcha8TPra4ym0kBDH5BwVhM3rEYE4OE=;
        b=TsparuUwfnSow5TYo8QXfXacV6atOZAzDxrUt/PG5AGrGbTX5WseSv/0mCZg2OzJfb
         uX3V03W8XJVY4fLBA1hoXD3jAbtZysTlYmZ96qplYvr7Iu9hwy1cZJJBHTG4SawykzXj
         TKCQiCc0DVMEmfwHcP1sBGnHyH0ZT4+iWTIU0bw7GsxfFfUivL3DpgTa8e3EkjrFhtf1
         STX/uz8SFihv6g+HzOHTavXXOPocZVzEocgn3HNkdHqsDYjYCOA9a+u4encXmN/nRxJk
         CJsPD7R75sFEkmAinekZaadTY4dLKp+e/t4alRVZoHiXprlAo0+kDK3rjyYfnuRMu3iE
         klBA==
X-Gm-Message-State: AAQBX9engND7Gd7viYjiXGDVZw57M0/zTTV4IL7hRiQRGNqMNMy337rc
        MWM++HRDHaMLqMy7Tm/E3fz5o4SwV8EVEl1Z4Fw=
X-Google-Smtp-Source: AKy350YBYC3Ha1Ay0Ic7WVctSKxvpf84VjLWo5nH1f41gd0zO6gDQynARD+QU/bPCysdbo8xRtvMyg==
X-Received: by 2002:a05:600c:b49:b0:3f1:7123:5f82 with SMTP id k9-20020a05600c0b4900b003f171235f82mr9813529wmr.12.1681910869602;
        Wed, 19 Apr 2023 06:27:49 -0700 (PDT)
Received: from localhost.localdomain (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id p8-20020a05600c358800b003f1738d0d13sm3497017wmq.1.2023.04.19.06.27.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 06:27:49 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     kvm@vger.kernel.org, will@kernel.org
Cc:     suzuki.poulose@arm.com,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH kvmtool 12/16] virtio: Document how to test the devices
Date:   Wed, 19 Apr 2023 14:21:16 +0100
Message-Id: <20230419132119.124457-13-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230419132119.124457-1-jean-philippe@linaro.org>
References: <20230419132119.124457-1-jean-philippe@linaro.org>
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
2.40.0

