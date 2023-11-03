Return-Path: <kvm+bounces-515-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D851B7E07CE
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 18:56:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1AE5FB2149C
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 17:56:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4294D2136F;
	Fri,  3 Nov 2023 17:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KcmXVTpK"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 991A22D625;
	Fri,  3 Nov 2023 17:55:56 +0000 (UTC)
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5DE7D44;
	Fri,  3 Nov 2023 10:55:54 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id 4fb4d7f45d1cf-54366784377so3785083a12.3;
        Fri, 03 Nov 2023 10:55:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699034153; x=1699638953; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SelOsO4e7GQx4YbT87ZuQxwsrQ0BMcUUcVqEb+J9ljQ=;
        b=KcmXVTpKamYccmaCVCqm2XmsgsbX9wCA88bH2cS+o+2rC8hxHo7kbMdZKWbpccEtuE
         M24Rqman/uZ2iucQMDiJ3LeMk+ju+08itQOSoXk2AUEXZYv+0VhjjO+ZxumfCjV2zm7W
         txYa1LHqjB1P+kfGStPLDohxSCJzBFmfA8HHuHUsQT/6ZzTxbvsIJPTdfKEUduBgqaSz
         UJCLGIdNRHvVy8gSUKlK056ZHCaju2scPRctU/WvGpkI9aj/5sRUuT+o3DwFVIbUeEIj
         Nzft2SA8+6KboxJzveO6uLPdIDjk+mgIV0Ge3Bzc3nDPJxRuyeaJRatTWmcme25V9P3h
         pRYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699034153; x=1699638953;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SelOsO4e7GQx4YbT87ZuQxwsrQ0BMcUUcVqEb+J9ljQ=;
        b=pe09NGcLED9mqI0vvk9srZJPpHR1bf42CaQ2M2qgskM2HzvyHv5KF5tJ3wRhuf/gCd
         ABJZ6gxKGt+OY5dnLhMBk4/qWIBMDfEigO+KNZxGbV6yYxDWIajMFJ13ConzTOSr4eiS
         lriedq7K82C8OEQ5ZWgyjENQ2AQP3yUPo+sf/0wjpQXEc3vdwNHFQ3dOXWEO7Y2AO2JU
         oXaklDyBLlX8QYo0aczfPVdfMMwHoEDz6dEUWXb72U1IW6ux7Yi8jw/WhWvgNF+muyye
         ecLIsfzhQxm8w4pSmjvEtLZaRx/HXFznlQxei40ESq6jjbNdXRiDKKWC23xgyNzvnSVL
         cBfw==
X-Gm-Message-State: AOJu0YwdOzTcI2U/K6j57Zsda6VjGOPH/S9jhvIhrvFGj4vGfYaKgxV8
	9TYPOjWAGFJXPJRVlWAgBlHewKbMQHhpfw==
X-Google-Smtp-Source: AGHT+IHtBfN5qqilHam3HPfW97af6GjBiqTqanKMhhWgWDVGR9JFL8UGu7zLUnI5jEJnj7wKSgSvCA==
X-Received: by 2002:a17:906:c14f:b0:9bd:f155:eb54 with SMTP id dp15-20020a170906c14f00b009bdf155eb54mr7760058ejc.6.1699034153179;
        Fri, 03 Nov 2023 10:55:53 -0700 (PDT)
Received: from fedora.. (host-62-211-113-16.retail.telecomitalia.it. [62.211.113.16])
        by smtp.gmail.com with ESMTPSA id wj6-20020a170907050600b009ddf1a84379sm80306ejb.51.2023.11.03.10.55.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Nov 2023 10:55:52 -0700 (PDT)
From: f.storniolo95@gmail.com
To: luigi.leonardi@outlook.com,
	kvm@vger.kernel.org
Cc: davem@davemloft.net,
	edumazet@google.com,
	mst@redhat.com,
	imbrenda@linux.vnet.ibm.com,
	kuba@kernel.org,
	asias@redhat.com,
	stefanha@redhat.com,
	pabeni@redhat.com,
	sgarzare@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	Filippo Storniolo <f.storniolo95@gmail.com>
Subject: [PATCH net 0/4] vsock: fix server prevents clients from reconnecting
Date: Fri,  3 Nov 2023 18:55:47 +0100
Message-ID: <20231103175551.41025-1-f.storniolo95@gmail.com>
X-Mailer: git-send-email 2.41.0
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filippo Storniolo <f.storniolo95@gmail.com>

This patch series introduce fix and tests for the following vsock bug:
If the same remote peer, using the same port, tries to connect
to a server on a listening port more than once, the server will
reject the connection, causing a "connection reset by peer"
error on the remote peer. This is due to the presence of a
dangling socket from a previous connection in both the connected
and bound socket lists.
The inconsistency of the above lists only occurs when the remote
peer disconnects and the server remains active.
This bug does not occur when the server socket is closed.

More details on the first patch changelog.
The remaining patches are refactoring and test.

Filippo Storniolo (4):
  vsock/virtio: remove socket from connected/bound list on shutdown
  test/vsock fix: add missing check on socket creation
  test/vsock: refactor vsock_accept
  test/vsock: add dobule bind connect test

 net/vmw_vsock/virtio_transport_common.c | 16 +++--
 tools/testing/vsock/util.c              | 87 +++++++++++++++++++++----
 tools/testing/vsock/util.h              |  3 +
 tools/testing/vsock/vsock_test.c        | 50 ++++++++++++++
 4 files changed, 139 insertions(+), 17 deletions(-)

-- 
2.41.0


