Return-Path: <kvm+bounces-71621-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OCoiF2nAnWnzRgQAu9opvQ
	(envelope-from <kvm+bounces-71621-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 16:14:49 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id CC998188DEA
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 16:14:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2F1A831ADE9E
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 15:11:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 380653A1CFA;
	Tue, 24 Feb 2026 15:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MX/IrIVq";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="btAvDqr7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB5F1EBFE0
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 15:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771945858; cv=none; b=ZBDjqlk4QTBetF79+w0QdSjBh4SNOQnCgnuSMP3LFs6022v5BqAgg67l6SGWxzxAoGkZaEqLdqFSbqjwMIIvSxet92M87hzhMQ4JBZLIHRB9DU9JZ13S4aByRrJMdbOXbrhgTNMcA4Ght1Md0KLmyXTXHcKomNvx80ggWeGOVmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771945858; c=relaxed/simple;
	bh=Yw++ySpwmZARZwDkHxFtsIMZXrLfykb7FK8NOCCtc9o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U0Hj/bHiE2smSeBXvC/nV2V0Q/XS/xoi0hyDlnRKLLtsZLuWDZd6hPHQMgJXwQp4ikpy4XfvlBawfvoAgN1m+2VJxMZ3p/BYOwZtkSpnqHzSoG1vCyqn364XOnVENk9e2LwZ6ouyvV6xltkRxx7ZD3zq39b6W2YPGT9EuCZO94Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MX/IrIVq; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=btAvDqr7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771945856;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CWBmRFKI0tFktXtE/HuJ4+L1Im2+ihdnnfM72IEIXjQ=;
	b=MX/IrIVqMkw86AOkR8JyYlL19npBfM4zm7yXdMs4NwkOblUvTcvDbNoEzlS2qImjydCluq
	oa42RfzJ5ZjJAQ7jkzqEaRjqGEk0R5YWGqL0UGWlwUwc6jLUydjDyDZtue+fh9iEKX03P1
	4S95+WykCQpY0liUWTIuYKPh0v43PJQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-153-zP1o9dYBNwuSztmFMraKyA-1; Tue, 24 Feb 2026 10:10:54 -0500
X-MC-Unique: zP1o9dYBNwuSztmFMraKyA-1
X-Mimecast-MFC-AGG-ID: zP1o9dYBNwuSztmFMraKyA_1771945853
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-43591aacca2so5059045f8f.1
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 07:10:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771945853; x=1772550653; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CWBmRFKI0tFktXtE/HuJ4+L1Im2+ihdnnfM72IEIXjQ=;
        b=btAvDqr7vvNnFS4194jqRw4VC3ROpgBO6TygWYlhe6ZG9pJOhGvuaAIxz6x/RIaFM4
         vfNUYADX7F4j+MDVdCRlXREZacwsIs5eeHNvPyRJtaoo/3h9U8pEFBU7rhjHsH2p/bDG
         1swDCn9xmuN5nk4W19vrnQLSnQK9mJweJXsQwmj2kgltLdR2zoBvRI/qGy25NabkkUcP
         GsCJWJz/GMgqtphXCbaFuJhoq1vKao9HOwXcuqCIoPTERYrlXArwZPgRAnlJfp9arWg6
         wWhMkLwalVmuhL3Q8MBjP2VpNLkx1mSR6LSqlkddtGLGKOzTqMvTlarl7YcgRUox6o8K
         h3rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771945853; x=1772550653;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CWBmRFKI0tFktXtE/HuJ4+L1Im2+ihdnnfM72IEIXjQ=;
        b=HoMWB8tI5eiQ4K2DqKuCkt0kTD3lda2eFFD0e0a4N7C8rtO36rD+3z6Q0c2ZfOI+cH
         k/M4WNXpIkcVLbp5uKQzUvalLeiBDC6S4TgTPBD9FIvPslkrtzPPbiQIg8Ixs3e254/f
         DV2+oTI5kHv0IOhpNuuWHMcQcsj6LxfDeMqoCRwbgSrr431Mr5d34rc0+qJvTkoh8Ckh
         Yk+tLXWuh35fBONGF0Tk/9qSasWIh684i6nvwAR3a0smhicsi74SAsqf7xHfVCwfwoAS
         lFC5377dBvfNRJ2Vmfvk0I8rRuslMxdIpa5yK/Rocj2LrsMSXpq/QFAqUCmAUwqi5QkN
         +Fow==
X-Forwarded-Encrypted: i=1; AJvYcCX4IIJujhKKLGiStqUbnyuJ4r7AH2XMvKklFnoHwU1u99k8jM8UR0BWy6mxSmZwQPgcce8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwyArssiRizEIub9ye5lMG3oJQziJDW4SzS65Y3rrvA6i/8PUbb
	CBtt8egWf1zyg0qGuF/WjVlWO88mSgjfJxWeBQwrT/kvTDkUvLoUdGgRErQsTdqPHn9qAr6kHHC
	aiUXsKNbkKn8zL8QJrDste2bYJKeHK+aeU5bj4JQotN5xdJ81WQX1Eg==
X-Gm-Gg: AZuq6aLBerrZqBXST6+smIepn1wtEHM+/oIyo/uI2Z7K0gYa4ytq4MrkVqQtQezi1HT
	K5TV5ZxJXocjIVpraSlW2on3CCZ+2iIfJFgEp6oxDfRBSMQtboa+9wygF3r/xmTORHn353eLUkH
	yegBOtXTX9Uz85MJsQtpckZxQkuN4b7axfoUo6H2JxhEqHIZiRpn7VGGCXxFUEbk7Sxsgv03s0w
	z3DL+uA2U3PDjgXfhB9H6mnHpWaYM9geIUgKX68MbSgnYRGpqU3EnO4tHhQxrAzJsQyiLQclWn1
	EoQVD149HMB3up/DXlXs4wCJoJvO0jgHnz9ObLuvzCaZmbYznafIIqalxXFWDxXWbB0ct6KFobM
	ruOIB/JC4XwgEVeGXyHe7FuESNBH/Pp7iCbejqS8i3JDjNnjjeA+/dpVj3Qo5c5Zp2UU4E9g=
X-Received: by 2002:a05:600c:1e1d:b0:480:f27c:6335 with SMTP id 5b1f17b1804b1-483a9637a55mr225647215e9.25.1771945853039;
        Tue, 24 Feb 2026 07:10:53 -0800 (PST)
X-Received: by 2002:a05:600c:1e1d:b0:480:f27c:6335 with SMTP id 5b1f17b1804b1-483a9637a55mr225646485e9.25.1771945852482;
        Tue, 24 Feb 2026 07:10:52 -0800 (PST)
Received: from sgarzare-redhat (host-82-53-134-58.retail.telecomitalia.it. [82.53.134.58])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483bd68826asm9484475e9.0.2026.02.24.07.10.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 07:10:51 -0800 (PST)
Date: Tue, 24 Feb 2026 16:10:49 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Bobby Eshleman <bobbyeshleman@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	Bobby Eshleman <bobbyeshleman@meta.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
	kuniyu@google.com, ncardwell@google.com
Subject: Re: [PATCH net v3 3/3] vsock: document write-once behavior of the
 child_ns_mode sysctl
Message-ID: <aZ2_cPL2zCYQznBI@sgarzare-redhat>
References: <20260223-vsock-ns-write-once-v3-0-c0cde6959923@meta.com>
 <20260223-vsock-ns-write-once-v3-3-c0cde6959923@meta.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260223-vsock-ns-write-once-v3-3-c0cde6959923@meta.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71621-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	DKIM_TRACE(0.00)[redhat.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sgarzare@redhat.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,meta.com:email]
X-Rspamd-Queue-Id: CC998188DEA
X-Rspamd-Action: no action

On Mon, Feb 23, 2026 at 02:38:34PM -0800, Bobby Eshleman wrote:
>From: Bobby Eshleman <bobbyeshleman@meta.com>
>
>Update the vsock child_ns_mode documentation to include the new
>write-once semantics of setting child_ns_mode. The semantics are
>implemented in a preceding patch in this series.
>
>Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
>---
>Changes in v3:
>- update language to clarify language that first value is locked, but subsequent
>  writes succeed.
>---
> Documentation/admin-guide/sysctl/net.rst | 3 +++
> 1 file changed, 3 insertions(+)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/admin-guide/sysctl/net.rst
>index c10530624f1e..3b2ad61995d4 100644
>--- a/Documentation/admin-guide/sysctl/net.rst
>+++ b/Documentation/admin-guide/sysctl/net.rst
>@@ -594,6 +594,9 @@ Values:
> 	  their sockets will only be able to connect within their own
> 	  namespace.
>
>+The first write to ``child_ns_mode`` locks its value. Subsequent writes of the
>+same value succeed, but writing a different value returns ``-EBUSY``.
>+
> Changing ``child_ns_mode`` only affects namespaces created after the change;
> it does not modify the current namespace or any existing children.
>
>
>-- 
>2.47.3
>


