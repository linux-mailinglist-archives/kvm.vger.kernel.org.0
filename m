Return-Path: <kvm+bounces-657-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2462E7E1EC8
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 11:46:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 466FC1C20ADC
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 10:46:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40306179A1;
	Mon,  6 Nov 2023 10:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UXuvy783"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308F417751
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 10:46:44 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0044DAB
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 02:46:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699267602;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y6QcvY42P7J5f+1XN4Qoz7DTeNEAzvUSzxn7o+ZphKQ=;
	b=UXuvy783ljVnl/qQxSadI5dwB9V4aYW04zp8wUkYemb1HI/KQMZhXihLbBIUuCD580pkZi
	w0WJGLtJ3MwgNtZ4m0g8UH2DYBrASvIZbZg3aVpi7sjCMthmoLe4PCt5xufBrmCCvqU59d
	i7iDruZ0wUB9lZqd0+UtBY7Qrs9jVtQ=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-524-I4D59JCCP9-KvhaFtuUtzA-1; Mon, 06 Nov 2023 05:46:41 -0500
X-MC-Unique: I4D59JCCP9-KvhaFtuUtzA-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-778b5445527so793191585a.1
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 02:46:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699267600; x=1699872400;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y6QcvY42P7J5f+1XN4Qoz7DTeNEAzvUSzxn7o+ZphKQ=;
        b=bYAQ7XJ+RR7f0gw802rrALWZbHox78BTwCjUoc49BvYFy3GqNPxOBNj3owoOk2IKc6
         42fe96AHCYcFiHVGLmuYoh0WdmQO7Pi2vCDIvyAZCN3p4DWpkJtQKNRubUlDbno4uSAo
         yMQfVpktqGkag0xfjMu5ySjiXGRjtUhuSLWsURfwGp+GzkB4SjuM7HLBMzaVMkrFWbwh
         SHeQeUENG4gNCGkRc8l6xp/jyrA259bSr5r58XwsE7fSSja+GDSYG/46f3j0qgWi6tWP
         9iVdTDNrmAf+6M8JUgF23WrR6CM55rzAQoEHagopo4Qg21mi2gWLsvL7pSEfW3NniU6V
         x59A==
X-Gm-Message-State: AOJu0YzuAqZZgzakG1cFnoB0NHzs5PyQK6XykM9t17FEgMXynDd+HKyc
	cja26Sg8EhIzf5tIDKgENo0fLkYRUp3oY9fSuZVV6mlH3BvDx/lawGBzgzWZspCOMbhh7+neeP3
	OvF0RauPOgUZY
X-Received: by 2002:a05:620a:4622:b0:779:cf70:8495 with SMTP id br34-20020a05620a462200b00779cf708495mr13042335qkb.22.1699267600581;
        Mon, 06 Nov 2023 02:46:40 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE0MTPNegxkHg2EtjSBJdIkcLWvJeBZhkiYCgUyFVAeJU8p43NP4uMhUlLf+FYjn63g6E1jfw==
X-Received: by 2002:a05:620a:4622:b0:779:cf70:8495 with SMTP id br34-20020a05620a462200b00779cf708495mr13042320qkb.22.1699267600334;
        Mon, 06 Nov 2023 02:46:40 -0800 (PST)
Received: from sgarzare-redhat ([5.179.191.143])
        by smtp.gmail.com with ESMTPSA id ay18-20020a05622a229200b004181c32dcc3sm3258973qtb.16.2023.11.06.02.46.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Nov 2023 02:46:39 -0800 (PST)
Date: Mon, 6 Nov 2023 11:46:26 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: f.storniolo95@gmail.com
Cc: luigi.leonardi@outlook.com, kvm@vger.kernel.org, davem@davemloft.net, 
	edumazet@google.com, mst@redhat.com, imbrenda@linux.vnet.ibm.com, kuba@kernel.org, 
	asias@redhat.com, stefanha@redhat.com, pabeni@redhat.com, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH net 2/4] test/vsock fix: add missing check on socket
 creation
Message-ID: <dhech4poimv5fphsxpy4oxy5ks5kpki6kzboy6kpnfm65vz3tp@nm6hoicgj5ze>
References: <20231103175551.41025-1-f.storniolo95@gmail.com>
 <20231103175551.41025-3-f.storniolo95@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20231103175551.41025-3-f.storniolo95@gmail.com>

On Fri, Nov 03, 2023 at 06:55:49PM +0100, f.storniolo95@gmail.com wrote:
>From: Filippo Storniolo <f.storniolo95@gmail.com>
>
>Add check on socket() return value in vsock_listen()
>and vsock_connect()
>
>Co-developed-by: Luigi Leonardi <luigi.leonardi@outlook.com>
>Signed-off-by: Luigi Leonardi <luigi.leonardi@outlook.com>
>Signed-off-by: Filippo Storniolo <f.storniolo95@gmail.com>
>---
> tools/testing/vsock/util.c | 8 ++++++++
> 1 file changed, 8 insertions(+)

If you need to resend the entire series, maybe you can remove "fix"
from the commit title.

But it's a minor thing, so I would only change it if there's something
else that justifies sending a v2:

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/tools/testing/vsock/util.c b/tools/testing/vsock/util.c
>index 92336721321a..698b0b44a2ee 100644
>--- a/tools/testing/vsock/util.c
>+++ b/tools/testing/vsock/util.c
>@@ -104,6 +104,10 @@ static int vsock_connect(unsigned int cid, unsigned int port, int type)
> 	control_expectln("LISTENING");
>
> 	fd = socket(AF_VSOCK, type, 0);
>+	if (fd < 0) {
>+		perror("socket");
>+		exit(EXIT_FAILURE);
>+	}
>
> 	timeout_begin(TIMEOUT);
> 	do {
>@@ -158,6 +162,10 @@ static int vsock_accept(unsigned int cid, unsigned int port,
> 	int old_errno;
>
> 	fd = socket(AF_VSOCK, type, 0);
>+	if (fd < 0) {
>+		perror("socket");
>+		exit(EXIT_FAILURE);
>+	}
>
> 	if (bind(fd, &addr.sa, sizeof(addr.svm)) < 0) {
> 		perror("bind");
>-- 
>2.41.0
>


