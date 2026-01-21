Return-Path: <kvm+bounces-68712-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6H8HLFPKcGkNZwAAu9opvQ
	(envelope-from <kvm+bounces-68712-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 13:45:07 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 30AD356FE3
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 13:45:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 2297D9CBF0A
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 12:38:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBCCC48AE13;
	Wed, 21 Jan 2026 12:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QAmK8f+H";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="e2YJyP0e"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B5848A2D2
	for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 12:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768998964; cv=none; b=myKsS4UreGWFlpyvh1k/CBQITSdeFbXq7v0TQcnfjrxB7e+L9tzy8f83KK9rO72aaEVgvGFE80UZLxzO8yYXSWTDgPFlCeMBKgW3io4EgFim3Tco8CUx+Ak75PiTAzqx47+HNXrJmUWORn7EljKx1UjNPI34voTSx4Nw4V+E4Bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768998964; c=relaxed/simple;
	bh=mha0I0VeVP1yXEtwsIMyiWq7J0MEXEEXF4v+brwB7Ss=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GxCBKJo340VlHGQ+AwbltpzF3m/GWncKZPHkp9dyJDV38emTXE7Sy8w/5Oq+LhmIaz3yBL6EaQ0gqg0XXGHoxgjAOGodVJBeVrBU19Cv0z8nAMkR1vHhJEJ38Fs53CXi9/zZvUwyR8TpEpgrFIqaUegOln03QIvlz3OEf0pAm04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QAmK8f+H; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=e2YJyP0e; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768998962;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xnPI8AJirXqjwQZgXHxL6NbBtlFdMp2kOfgYwwE6c8I=;
	b=QAmK8f+HrvFPtnmAS3nkhCVx3spQKtb/bwJMHrh++5SxhAPlobiZUGNBIM2v6mPQktlpOS
	0IEjl4Wz3OvWCnwcrAhlbYX6qOwXPiZGPmnEjBAaGsLjCKy7Nucrj9VhUaJdLufsmAV2Tv
	KZkc9wXEyEN1Ubw3YEu5oZu6Pky7YAk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-685-Q7c_qFBRN46LMZUJjczftw-1; Wed, 21 Jan 2026 07:35:58 -0500
X-MC-Unique: Q7c_qFBRN46LMZUJjczftw-1
X-Mimecast-MFC-AGG-ID: Q7c_qFBRN46LMZUJjczftw_1768998958
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-47ee8808ffbso48397785e9.2
        for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 04:35:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768998958; x=1769603758; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xnPI8AJirXqjwQZgXHxL6NbBtlFdMp2kOfgYwwE6c8I=;
        b=e2YJyP0eTNS932V2wD03A9ExfaNr0MsBa0cSDjf0VDWECGqEuH2K52zFG9cwSlu+FG
         CUavymRALV6Zv71/tRFiTPuJm5ugs1xKqay7LK50HI+xxebSkQSSS5watxOyh6bLGYy4
         /m1bNIM69axgme56u3fghXKdOsxgJQIQdDDmIFuvYKubWCjKwnevysCszJNrOBTbj8p8
         y4B++MEFLAUAAPHxEkjgQ2amuKDeA2pw+gaxKkWWApvc7AjNN348EDXanAcdTaVntBsW
         YmTqT3TOv0dWDXMIwqawRXPldASbXoGgUjvrbyO4Nla6+kbiNT1oaZKt+W5HbT/4XSlg
         Erig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768998958; x=1769603758;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xnPI8AJirXqjwQZgXHxL6NbBtlFdMp2kOfgYwwE6c8I=;
        b=uvu1TPUgVo+os9qcNyrj2G2ub7TBvyMSKhcO3aNwWzv0Ba1iR/WUCJL0dkISX8gnMt
         L/4kBsNoRWSvbknSFvUVbnRVp5Kxk03u0TyHipn3LMt52UpRIegdMz6niex7gMRdnnLv
         CE7Bn+G1g692jtmtLHIRMC3wLIQ5Pcq+RihBCk5ndCmrjuHB5uJ3GlQtF5jeX+xoWdgv
         LLRkeGkDx8IhbKkoUP3xOTYen9oAL4zEeUIqK0+o4u/gymaC3jxcw9PtBoOJe9Yx11N3
         dEZcrE5fNyERooJX3LpqX9dN7V/J+Iu9Gi0ri4Okgy8Zd/xKQ9jT+wWhsOeyRblxFeHY
         mjxQ==
X-Forwarded-Encrypted: i=1; AJvYcCUPRNOkPwaseefpFzFkumMLXzq3PkFN+N8lXQXEvsSt6lxQv+LYl+2iVp2WgUpXQfaXVTI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwsMUay1Lbfx73HMVfLVz9tj9exCLh80HvPvFp+ABq05kkf1hS9
	EVqXbb9KFL6L0dgA7jxG3LEJZGxIT3FZVyd1pFFI6WPIXNNiu/txA6d6PiPPlCHHyR5hAbmCed9
	z6Y9lrKVdRdwUd/6RZumExo7FCbaHAF7DdRDYTz986kkdLAxYDcpo2g==
X-Gm-Gg: AZuq6aIyn7Yq1jlgN7U2tjNI5+HX3qYwXGQwX8xtNEExdHBXVpRHugWbjklaHJXhpPW
	tyDLEqzNF8i+VqRNuAAAb4tdnazIRR49Jqb/nKtWFmGKVG/P4BaoSo5zpArBcDJ60YXo3ZqblbZ
	V1CG98RjzX9fleVxZUzA6+hFvBdPU8M7u2QdMnSr15ksln/1qcXsNvza31VceDGdLwK1Wj/ali9
	hhdExiX+bnslW1nHkbZ+PsSEAbT0DWwyqkzyme5stTih9luLhjr8ceT5k/PM72MDnRzOiWJYOm2
	OuOtiOounq0ho5Jzs3jSYB7nroiICGToEunUcFXfvvKpBd95qIDGm/iI7oOzqOxVrRMsZRZr+dW
	S9izGnYP7R27VmRSuS1kvn/zWHX/MmEY=
X-Received: by 2002:a05:600c:3ba8:b0:479:35e7:a0e3 with SMTP id 5b1f17b1804b1-4801e34651dmr231392845e9.30.1768998957687;
        Wed, 21 Jan 2026 04:35:57 -0800 (PST)
X-Received: by 2002:a05:600c:3ba8:b0:479:35e7:a0e3 with SMTP id 5b1f17b1804b1-4801e34651dmr231392355e9.30.1768998957206;
        Wed, 21 Jan 2026 04:35:57 -0800 (PST)
Received: from redhat.com (IGLD-80-230-35-22.inter.net.il. [80.230.35.22])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47f4289b83csm362908205e9.3.2026.01.21.04.35.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 04:35:56 -0800 (PST)
Date: Wed, 21 Jan 2026 07:35:53 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: netdev@vger.kernel.org, Simon Horman <horms@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
	"David S. Miller" <davem@davemloft.net>,
	virtualization@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Claudio Imbrenda <imbrenda@linux.vnet.ibm.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Asias He <asias@redhat.com>
Subject: Re: [PATCH net v6 0/4] vsock/virtio: fix TX credit handling
Message-ID: <20260121073547-mutt-send-email-mst@kernel.org>
References: <20260121093628.9941-1-sgarzare@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260121093628.9941-1-sgarzare@redhat.com>
X-Spamd-Result: default: False [-1.96 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DMARC_POLICY_ALLOW(0.00)[redhat.com,quarantine];
	DKIM_TRACE(0.00)[redhat.com:+];
	TAGGED_FROM(0.00)[bounces-68712-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mst@redhat.com,kvm@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_FIVE(0.00)[6];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: 30AD356FE3
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Jan 21, 2026 at 10:36:24AM +0100, Stefano Garzarella wrote:
> The original series was posted by Melbin K Mathew <mlbnkm1@gmail.com> till v4.
> Since it's a real issue and the original author seems busy, I'm sending
> the new version fixing my comments but keeping the authorship (and restoring
> mine on patch 2 as reported on v4).


Acked-by: Michael S. Tsirkin <mst@redhat.com>

> v6:
> - Rebased on net tree since there was a conflict on patch 4 with another
>   test added.
> - No code changes.
> 
> v5: https://lore.kernel.org/netdev/20260116201517.273302-1-sgarzare@redhat.com/
> v4: https://lore.kernel.org/netdev/20251217181206.3681159-1-mlbnkm1@gmail.com/
> 
> >From Melbin K Mathew <mlbnkm1@gmail.com>:
> 
> This series fixes TX credit handling in virtio-vsock:
> 
> Patch 1: Fix potential underflow in get_credit() using s64 arithmetic
> Patch 2: Fix vsock_test seqpacket bounds test
> Patch 3: Cap TX credit to local buffer size (security hardening)
> Patch 4: Add stream TX credit bounds regression test
> 
> The core issue is that a malicious guest can advertise a huge buffer
> size via SO_VM_SOCKETS_BUFFER_SIZE, causing the host to allocate
> excessive sk_buff memory when sending data to that guest.
> 
> On an unpatched Ubuntu 22.04 host (~64 GiB RAM), running a PoC with
> 32 guest vsock connections advertising 2 GiB each and reading slowly
> drove Slab/SUnreclaim from ~0.5 GiB to ~57 GiB; the system only
> recovered after killing the QEMU process.
> 
> With this series applied, the same PoC shows only ~35 MiB increase in
> Slab/SUnreclaim, no host OOM, and the guest remains responsive.
> 
> Melbin K Mathew (3):
>   vsock/virtio: fix potential underflow in virtio_transport_get_credit()
>   vsock/virtio: cap TX credit to local buffer size
>   vsock/test: add stream TX credit bounds test
> 
> Stefano Garzarella (1):
>   vsock/test: fix seqpacket message bounds test
> 
>  net/vmw_vsock/virtio_transport_common.c |  30 +++++--
>  tools/testing/vsock/vsock_test.c        | 112 ++++++++++++++++++++++++
>  2 files changed, 133 insertions(+), 9 deletions(-)
> 
> -- 
> 2.52.0


