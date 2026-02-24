Return-Path: <kvm+bounces-71552-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gE+2OMLvnGkaMQQAu9opvQ
	(envelope-from <kvm+bounces-71552-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 01:24:34 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FCB118033A
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 01:24:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F037F30D912C
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 00:24:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FC12221265;
	Tue, 24 Feb 2026 00:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GpogB9XA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4410F213E89
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 00:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771892652; cv=none; b=shYL8Ejl/DLm6T77qkfd/aG4shFzomO0NiM919NFQ+XzCROKpLjuf4YVYyt2sa8KjJye6W2zsrOyPriyQt3iiuZHraA+lcMpMnw2bYOVQ30ybkCUAFP8AQXJlzQ57HGV9RJLLG1A8b7CaNGLUuQpbSAZfIlXnHUlpswLnpL0XI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771892652; c=relaxed/simple;
	bh=jKHWyDAu0xJvzI3WO6+meQgDEHUikzp88qy14INmcPk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AELyE3R25UET3xLveCEFaZausIZQ2wNjsRXPty+gm9DIcUOet5n/a2j1oP1KYxHvlDCx8TNHF07biMZZpdUWqFCM/dDl8mZ3kRqE3onm8VV5/6UzZQ4w+VBdJUBZ9aw0Y8OFVaw3LxzbkUMPpyVsUKvbuoQPxatVyW6aHlM4VE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GpogB9XA; arc=none smtp.client-ip=209.85.128.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-79801df3e21so47597887b3.2
        for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 16:24:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771892650; x=1772497450; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=u1akxnV01TuuqkqVdn8oJReBwARp0bMrNePNSdt98A4=;
        b=GpogB9XAYZVLqYAmNIO3FrVFQhmoujs+FpP+4b4mJiQxMSpUhpo8OwTsalI1EAz5ur
         FDKD6SSIPbopYVEceVSXKj3gzfrTiKdP0+3Ub6uiMB1ddrs1Fu+cK0zFxTWqfA1p8xWC
         txJfEn33rZ6JzxMxxuA6/QrDQqfcZRaNXpgcgCSmInhIkhcmYhgtfgA8Gid0msMlNcXz
         JKBczHy9aVSGRKZKrxwgLCBLNbVUrbZHlQHqRTPyxUdV3UJi+dkZe8fwFoAsw3Jk/4Oz
         UTt8OAJtk/+0IWTu2oGeGp+fgfSqocrq5h519eM/4FaHGro3RfgStDuRzcEsOwR0S3oc
         hl+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771892650; x=1772497450;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u1akxnV01TuuqkqVdn8oJReBwARp0bMrNePNSdt98A4=;
        b=VViRJ0kYGOemx1u2OC7zRNRIxUl9DgUM/X/mZ9kP30T/9KWDp+UtycgT/K47Oj2Z9P
         BO1xHdmO/4ezchVYA+w8E+WOKoIhOPazAv42rbqLMWGef6hi1PgMnSQF90mxCVNQenq1
         rwSbCk1vVydtvib+Pc5YwWNCtgYsBMpegsQieljIE1VfRf5DMjZ1SpaySjWPpFnpIUbW
         lQ0bvKOCvoHFmWGkM0Muos6e1RAtd8la2fAm8x4tKApFgzV2DJYmBh+vDZsfhSeHMzCM
         w0AUiV849INpgG+ocUtHE3VVTRpe7KeIJgRG0rF0g/VwWHKwEaIOh5ek+VcdHEFtmfZr
         yZ9w==
X-Forwarded-Encrypted: i=1; AJvYcCUTRsTMNYteZhkR3YSc5lWkg2uznSg6V3nEL8g3E10CAGds9m/exJuM8QJhQ3MJKuLvzow=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZl8Jxms9/8FkSt+Ii5dSxWvEbDkISAnzG3U92l4F6v09NlBfz
	bRVIu8tvkWNImTlSLi0kzV+RvIrS3bPHmozsd30yeVQ9AopT4OjipktK
X-Gm-Gg: ATEYQzxhtwbLXl3jkXzSra/bpSI1bPRXTDw+bA+xLikHAREwORate267CfKqWcB5Rp4
	LtJ0KAjjGYGZuvau6GmWrubdE5SJkHgetZBep5KiqQJBhNeHFKf54tuS7UFPUm+YTM0rsTZgvph
	d5xyWahLcGmpcI/uRJ8/tzn5Ckma94AfL+9DgJi0YAc4OC7PHxs300E7ZYVRY6f0gszRdBKuYUk
	DGs27Vli/QVd5MBXABzeQ39S2V0+iUDYO/Iw2HoHb3tuGtl0vMPJAfPT99W5hroBKcSu4qA5p37
	MNGqVoprdse5GIttml+PCgz3AYQcQ6/RFssb3qZfs2afKEnUCjlKLZEXDcs+0gtNNuU713eNut4
	G45df/D68x+Hsn3eQHmKSBgoVfcDwMVBKRCwLfEWK+cbcV5EgECfAAv1RINjV6usnB0efO0KRwq
	2mZgvSGYEUL8Xclfu0MeG45Q1gD7yKs965uvPv+zy9WjDZLDU=
X-Received: by 2002:a05:690e:4149:b0:649:4906:770a with SMTP id 956f58d0204a3-64c788d2821mr7812527d50.8.1771892650119;
        Mon, 23 Feb 2026 16:24:10 -0800 (PST)
Received: from devvm11784.nha0.facebook.com ([2a03:2880:25ff:41::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-64c7a35d839sm3891935d50.13.2026.02.23.16.24.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 16:24:09 -0800 (PST)
Date: Mon, 23 Feb 2026 16:24:07 -0800
From: Bobby Eshleman <bobbyeshleman@gmail.com>
To: Stefano Garzarella <sgarzare@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Bobby Eshleman <bobbyeshleman@meta.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>
Cc: virtualization@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
	kuniyu@google.com, ncardwell@google.com,
	Daan De Meyer <daan.j.demeyer@gmail.com>
Subject: Re: [PATCH net v3 2/3] vsock: lock down child_ns_mode as write-once
Message-ID: <aZzvp52L4smGF7cM@devvm11784.nha0.facebook.com>
References: <20260223-vsock-ns-write-once-v3-0-c0cde6959923@meta.com>
 <20260223-vsock-ns-write-once-v3-2-c0cde6959923@meta.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260223-vsock-ns-write-once-v3-2-c0cde6959923@meta.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71552-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[lists.linux.dev,vger.kernel.org,google.com,gmail.com];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[21];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bobbyeshleman@gmail.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[meta.com:email,devvm11784.nha0.facebook.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 8FCB118033A
X-Rspamd-Action: no action

On Mon, Feb 23, 2026 at 02:38:33PM -0800, Bobby Eshleman wrote:
> From: Bobby Eshleman <bobbyeshleman@meta.com>
> 
> Two administrator processes may race when setting child_ns_mode as one
> process sets child_ns_mode to "local" and then creates a namespace, but
> another process changes child_ns_mode to "global" between the write and
> the namespace creation. The first process ends up with a namespace in
> "global" mode instead of "local". While this can be detected after the
> fact by reading ns_mode and retrying, it is fragile and error-prone.
> 
> Make child_ns_mode write-once so that a namespace manager can set it
> once and be sure it won't change. Writing a different value after the
> first write returns -EBUSY. This applies to all namespaces, including
> init_net, where an init process can write "local" to lock all future
> namespaces into local mode.
> 
> Fixes: eafb64f40ca4 ("vsock: add netns to vsock core")
> Suggested-by: Daan De Meyer <daan.j.demeyer@gmail.com>
> Suggested-by: Stefano Garzarella <sgarzare@redhat.com>
> Co-developed-by: Stefano Garzarella <sgarzare@redhat.com>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>

Stefano, I wasn't sure if you wanted the Co-developed-by and S-o-b on
this iteration, but I added it just in case. Please let me know, if that
wasn't what you intended.

Best,
Bobby

