Return-Path: <kvm+bounces-386-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 42C437DF3CE
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 14:30:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 72FDF1C20C59
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 13:30:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29B9318E2E;
	Thu,  2 Nov 2023 13:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cemRQJcm"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CB8B17740
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 13:30:22 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1E5D19D
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 06:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698931819;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G4kaapn3liY1zTPGQnPDgzqDOBnuNLhFYbLOwMSHOTc=;
	b=cemRQJcmSU/O1TEzWgrFVE/i/+g6PgNDlBfQa0/soaKCx3T3pT/UM3TqmgR1aUVzOgOHxx
	PuXl3SfFoYNRMqOmQ4OJcEtVBYpq74fz9lS4wNB7eDoo5evbegvtdpD1qyNqQhfdWbumrO
	jE17R+tiQgrMytTWMPw6FJo5Aa2reuI=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-404-JqCSvjEKPXaeHO68JdqZSQ-1; Thu, 02 Nov 2023 09:30:14 -0400
X-MC-Unique: JqCSvjEKPXaeHO68JdqZSQ-1
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-1cc70f8a58fso8377865ad.3
        for <kvm@vger.kernel.org>; Thu, 02 Nov 2023 06:30:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698931813; x=1699536613;
        h=content-transfer-encoding:mime-version:references:in-reply-to:from
         :subject:cc:to:message-id:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=G4kaapn3liY1zTPGQnPDgzqDOBnuNLhFYbLOwMSHOTc=;
        b=nUxsuX9Hl9He9j9SUGKeKuquT2tM494KgmbnKR5ihlMwJ0E7P+x6mw4X5IYmjaBIal
         eCrWXqgDgn20oHk5Kkyn9TtOUnqbbXYDj36rh0Yfpy3iNMlHnnJKCRrqZTK6T3dGJaMT
         wY3nfZdo8JEGzIXkIIlAMjOWMn9hky3AatQ117Q06vvfAv0uezF4/s4k8ODf+kNmWfNf
         gWyeaXKxvES/237qhBZFru8tbClOcR+MmWWmlgS/fkgVTb4Qyy129XYEfXOTuV+GIDnL
         UXftkoge7BV13kHaZH/ONzaplqbo908pTZlTJ97ft9GIKlrnxDuVQe/wFJo24hYxAkmD
         Fvag==
X-Gm-Message-State: AOJu0Yzp6sb3mVyg4NYAvpeke9yrqXdv8i4V7doKdCMGo5I6NL1yhq3a
	ImBKmiTSUzF2HGlhEw4br3E51emhEVpZnbQt9ziN5UXSjTFgrR3JgZv4IARuC/H5MOxnQGyddzJ
	ap6Nz5ZPIS0xs
X-Received: by 2002:a17:902:f943:b0:1cc:449b:689e with SMTP id kx3-20020a170902f94300b001cc449b689emr11958469plb.20.1698931813245;
        Thu, 02 Nov 2023 06:30:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEpaf34EgGKqQhxqqvUP6ThPV7LvGkD3nyVPIKABjoFRGOKKdsCUmtWGPXXtO+YRCkk5SfLBA==
X-Received: by 2002:a17:902:f943:b0:1cc:449b:689e with SMTP id kx3-20020a170902f94300b001cc449b689emr11958445plb.20.1698931812829;
        Thu, 02 Nov 2023 06:30:12 -0700 (PDT)
Received: from localhost ([240d:1a:c0d:9f00:91ec:2f0b:ae2b:204a])
        by smtp.gmail.com with ESMTPSA id a7-20020a170902ecc700b001c877f27d1fsm1940634plh.11.2023.11.02.06.30.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Nov 2023 06:30:12 -0700 (PDT)
Date: Thu, 02 Nov 2023 22:30:08 +0900 (JST)
Message-Id: <20231102.223008.2284405204869772112.syoshida@redhat.com>
To: kuba@kernel.org
Cc: stefanha@redhat.com, sgarzare@redhat.com, davem@davemloft.net,
 edumazet@google.com, pabeni@redhat.com, kvm@vger.kernel.org,
 virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] virtio/vsock: Fix uninit-value in
 virtio_transport_recv_pkt()
From: Shigeru Yoshida <syoshida@redhat.com>
In-Reply-To: <20231101222045.5f7cca01@kernel.org>
References: <20231026150154.3536433-1-syoshida@redhat.com>
	<20231101222045.5f7cca01@kernel.org>
X-Mailer: Mew version 6.9 on Emacs 28.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

On Wed, 1 Nov 2023 22:20:45 -0700, Jakub Kicinski wrote:
> On Fri, 27 Oct 2023 00:01:54 +0900 Shigeru Yoshida wrote:
>> This issue occurs because the `buf_alloc` and `fwd_cnt` fields of the
>> `struct virtio_vsock_hdr` are not initialized when a new skb is allocated
>> in `virtio_transport_alloc_skb()`. This patch resolves the issue by
>> initializing these fields during allocation.
> 
> We didn't manage to apply this before the merge window, and now the
> trees have converged. Patch no longer applies cleanly to net.
> Please rebase & repost.

I got it. I'll rebase the patch to the latest net tree and resend it.

Thanks,
Shigeru


