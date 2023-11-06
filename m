Return-Path: <kvm+bounces-660-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 67D797E1EE7
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 11:51:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 222292813EB
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 10:51:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1ED418037;
	Mon,  6 Nov 2023 10:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jEv0fObb"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF661772F
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 10:50:56 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1643A1
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 02:50:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699267853;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sGKHksPd501hQHA9eLNxN+ry44710hoCv07MExLKHVs=;
	b=jEv0fObbHlVFMAvg7ifuCVz1MGnRQnGcWsqsUP/WnTT4/uSBv69dEaomPo+EVsrJfw6bQH
	UcAEMD9aIX4q1zMGm0+oOpaDa7X5X68GVrUwoCe/CkUbYpVseeYNolNok/H8AyElgYvZlx
	pcFy/P4mDSDZobpFVPz1C2GJWZjR68o=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-149-dZxbJopzNB-25YGH-epJ7A-1; Mon, 06 Nov 2023 05:50:52 -0500
X-MC-Unique: dZxbJopzNB-25YGH-epJ7A-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-7788fb069abso656689185a.0
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 02:50:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699267852; x=1699872652;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sGKHksPd501hQHA9eLNxN+ry44710hoCv07MExLKHVs=;
        b=JGV8JHvaYxSDk8xgkyaG9yAm3AlP3ByG0P4o3sqJiBadWRF+sFhZKlK0pKJY4aZByR
         zGROKREMVW8qYuJNFJ8RqzEQQPybdf0fhgg/uRFlzn5PJWQBZZNHcJx56xL+dSh2Gveu
         VXGynbyR++vkv66PxomCH3Tva2xsM0cEQl85RMXAdWoacnQnTjPaCnl/j1ObbzqaeEyO
         1bxtMgAKN13fsVRNPVwhrlc+ix6xZiCjD4i29+CrvVmEtPPduJ6K5dUde+fs0zW93abN
         eF0A2Mafjjm1lVZYujDvmuHNErm713soiznrpUbnyYysXYXinXDBE+pghTh557MJhBh+
         m35A==
X-Gm-Message-State: AOJu0Yz/mqrIDds7hqL54o0bL4CybRF+2Hhz6ut46AqiJSVlfNu65UJe
	5EEfH21T1RzqWk0BeRKl6NB2l8IrebDJW7wrJnn606FrfZFRIthgN6djxU8eBGUL/yRRU47zrdB
	yb9kLcYsxeCzb
X-Received: by 2002:a05:620a:4891:b0:774:21d8:b0bb with SMTP id ea17-20020a05620a489100b0077421d8b0bbmr12492213qkb.24.1699267852267;
        Mon, 06 Nov 2023 02:50:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHJ0WMQS53FSstaaqoM5HU6Y+QSQp08ZUPiU8X5BKecLqp2Qc+R6PUnmsWzejkhzBiVviTEyQ==
X-Received: by 2002:a05:620a:4891:b0:774:21d8:b0bb with SMTP id ea17-20020a05620a489100b0077421d8b0bbmr12492204qkb.24.1699267852003;
        Mon, 06 Nov 2023 02:50:52 -0800 (PST)
Received: from sgarzare-redhat ([5.179.191.143])
        by smtp.gmail.com with ESMTPSA id a26-20020a05620a125a00b0077892023fc5sm3168522qkl.120.2023.11.06.02.50.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Nov 2023 02:50:51 -0800 (PST)
Date: Mon, 6 Nov 2023 11:50:43 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: f.storniolo95@gmail.com
Cc: luigi.leonardi@outlook.com, kvm@vger.kernel.org, davem@davemloft.net, 
	edumazet@google.com, mst@redhat.com, imbrenda@linux.vnet.ibm.com, kuba@kernel.org, 
	asias@redhat.com, stefanha@redhat.com, pabeni@redhat.com, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH net 0/4] vsock: fix server prevents clients from
 reconnecting
Message-ID: <arbypnxtolin6jhz5wqguh4mnqlejtorgx5gvicwbuqdivjpds@lvitwxxfgy2g>
References: <20231103175551.41025-1-f.storniolo95@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20231103175551.41025-1-f.storniolo95@gmail.com>

On Fri, Nov 03, 2023 at 06:55:47PM +0100, f.storniolo95@gmail.com wrote:
>From: Filippo Storniolo <f.storniolo95@gmail.com>
>
>This patch series introduce fix and tests for the following vsock bug:
>If the same remote peer, using the same port, tries to connect
>to a server on a listening port more than once, the server will
>reject the connection, causing a "connection reset by peer"
>error on the remote peer. This is due to the presence of a
>dangling socket from a previous connection in both the connected
>and bound socket lists.
>The inconsistency of the above lists only occurs when the remote
>peer disconnects and the server remains active.
>This bug does not occur when the server socket is closed.
>
>More details on the first patch changelog.
>The remaining patches are refactoring and test.

Thanks for the fix and the test!

I only left a small comment in patch 2 which I don't think justifies a
v2 by itself though. If for some other reason you have to send a v2,
then maybe I would fix it.

I reviewed the series and ran the tests. Everything seems to be fine.

Thanks,
Stefano


