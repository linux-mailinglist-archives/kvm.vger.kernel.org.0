Return-Path: <kvm+bounces-5220-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 51B8E81E0E2
	for <lists+kvm@lfdr.de>; Mon, 25 Dec 2023 14:28:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8E94EB21572
	for <lists+kvm@lfdr.de>; Mon, 25 Dec 2023 13:28:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3519452F69;
	Mon, 25 Dec 2023 13:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hz4ITuRU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9BB524A0
	for <kvm@vger.kernel.org>; Mon, 25 Dec 2023 13:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703510875;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=eQrFSUCYGMhy2SsSQLQNb28k56c6BCyeTM61vN0o41o=;
	b=hz4ITuRU6RGq5BzUM8bED7SIdQ9NiciQdQ5nBF7nQnwpqzwbjp9ee/C2N7xJAHYV/21dNr
	yYp8CEaYhUa9AkunYoF690KagtHt28Lef5FG00dQ2gI3HK8D/dStaXHUhRVJ6gv254kX9Z
	AKXYUvMsz20HbD+s/aBwZnFfcLV5ffg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-631-938zpCNEOuSL94ooqX59Cg-1; Mon, 25 Dec 2023 08:27:54 -0500
X-MC-Unique: 938zpCNEOuSL94ooqX59Cg-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3367c893deeso2827720f8f.2
        for <kvm@vger.kernel.org>; Mon, 25 Dec 2023 05:27:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703510872; x=1704115672;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eQrFSUCYGMhy2SsSQLQNb28k56c6BCyeTM61vN0o41o=;
        b=CyjWqOXGUCVjwlu+XkDcr9cvYe37pkJRqUNcwEgz+p8P3PMqTx9XaErt9Drc12iz8Z
         KkXCiQzfpjF66ljoq9Rc/lTL57bE4kQ04CqdlmIKwy+QG/1PLT7na4iprtknugcPkpya
         vllm4w1zw51cIUsJcWEu5HoLv0yc/kb574aElDVO06ZQlombbD/UKpk0eznQFbNp1vdL
         ukKzcm9IKifw3HhmWNYM9xkUIb1eTlFDicsA1HiZkv6TKycbEXBXP3SdFL6mD3o87GGV
         7cH7HGP7HIb3EcM1j5SQi8RKVCT+MXk07GGbLKibND46kPS/iO5dL23S21ESbaSBF12M
         L58w==
X-Gm-Message-State: AOJu0YzpaO/vj1dmieU8ZLBAtxYyfOE0gGXz5SFDMnA3dAtwdqR0g5Sq
	s6URLFMxXbgnQToOpSyEPEwHUrF8/k8vKXBecw3gYKx6m2/UT0X4oAEnhX2N8yDOmZWOlioKUm9
	oSZafoEoUr6dLnH/mon7YI7wU2At+
X-Received: by 2002:adf:efc3:0:b0:336:6413:682 with SMTP id i3-20020adfefc3000000b0033664130682mr2892623wrp.42.1703510872089;
        Mon, 25 Dec 2023 05:27:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFADLrFfKMHOhtA8f351FSOXWF1tCR+mhRQi9Bja66IW8vKteZ/pT7INfLkesHcwbnd7uOsEA==
X-Received: by 2002:adf:efc3:0:b0:336:6413:682 with SMTP id i3-20020adfefc3000000b0033664130682mr2892612wrp.42.1703510871682;
        Mon, 25 Dec 2023 05:27:51 -0800 (PST)
Received: from redhat.com ([2a06:c701:73ef:4100:2cf6:9475:f85:181e])
        by smtp.gmail.com with ESMTPSA id t16-20020adfe450000000b0033666ec47b7sm10354728wrm.99.2023.12.25.05.27.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Dec 2023 05:27:51 -0800 (PST)
Date: Mon, 25 Dec 2023 08:27:49 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	hongyu.ning@linux.intel.com, jasowang@redhat.com, lkp@intel.com,
	mst@redhat.com, stefanha@redhat.com, suwan.kim027@gmail.com,
	xuanzhuo@linux.alibaba.com
Subject: [GIT PULL] virtio: bugfixes
Message-ID: <20231225082749-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent

The following changes since commit cefc9ba6aed48a3aa085888e3262ac2aa975714b:

  pds_vdpa: set features order (2023-12-01 09:55:01 -0500)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to b8e0792449928943c15d1af9f63816911d139267:

  virtio_blk: fix snprintf truncation compiler warning (2023-12-04 09:43:53 -0500)

----------------------------------------------------------------
virtio: bugfixes

A couple of bugfixes: one for a regression.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Stefan Hajnoczi (1):
      virtio_blk: fix snprintf truncation compiler warning

Xuan Zhuo (1):
      virtio_ring: fix syncs DMA memory with different direction

 drivers/block/virtio_blk.c   | 8 ++++----
 drivers/virtio/virtio_ring.c | 6 ++----
 2 files changed, 6 insertions(+), 8 deletions(-)


