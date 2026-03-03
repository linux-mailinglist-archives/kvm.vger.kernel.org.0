Return-Path: <kvm+bounces-72565-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +NGSJWEwp2mbfgAAu9opvQ
	(envelope-from <kvm+bounces-72565-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 20:02:57 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 127B01F5996
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 20:02:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D0A363068DA8
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 18:59:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 180F9372698;
	Tue,  3 Mar 2026 18:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EfOvcmLF";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="YwwvzRgK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ACD0372660
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 18:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772564388; cv=none; b=QFuaqFL9SAjYm52uVWNdyeNoK58QmLfRCQ2c11wktLpZCxS868xpCubwIMyLZjIpNlm+hr2P/MRilSMvGEcES37KFxIPn000NBrjakdvbB7DJwf5D9Mpxj8o729crmeTMmqtIqHmo8+32gwgg1Yuv0G3S0aVTk80uRhJdkVvb3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772564388; c=relaxed/simple;
	bh=V68vqXbDYm4fNL3Yt8aGQEXOY+w6Yj328pNkcNLY2d4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XFVfIF6WJGrWu4sjkepva3h+y4mJO6Qc4MIOcQhLRx7raB+SZzkUJrVlgHwfP2+S8Gg339ZjIxpuYx2B0mreaIAM0Gx9PMVROzt9qfh8P8VQPgMaM3ur4iUdntCHukQVaSwB5Nyi9ThLrF851yAMbK/V2CqHNg/I24+UhFrttzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EfOvcmLF; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=YwwvzRgK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772564386;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ldkqWhKG/pViPGOuQtoZh0XEluH/KUMdKjz5oPW4qRY=;
	b=EfOvcmLFlaWMK7KhS4Gl5uQ7EBppoFu5GMfWKcWyKFUf3MulX4UpS9lCFu4UnqDxPN7AU6
	1v/Lvg16HpjX71AJqWXscR6GpRr6KXatzolk3Eh/I6skXrJwVUwJqcULKmRf4xfo4QGqtu
	EVj1wR/TWlS00u3OVuu1LAbnnTzCZ+0=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-536-XssGoBeKNHKRDQvuZacaZw-1; Tue, 03 Mar 2026 13:59:45 -0500
X-MC-Unique: XssGoBeKNHKRDQvuZacaZw-1
X-Mimecast-MFC-AGG-ID: XssGoBeKNHKRDQvuZacaZw_1772564384
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-5033b4d599eso531860841cf.2
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 10:59:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1772564384; x=1773169184; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ldkqWhKG/pViPGOuQtoZh0XEluH/KUMdKjz5oPW4qRY=;
        b=YwwvzRgKy4BcpBpu6smMuwe/DjMrxKKYMm8zlFL7djXp4/5QoR8SwT/oSbGGU9mjmn
         iBSOYLrwBxv5/Ovdeu/L9nrbXZo6Yiii3sIKSAHz6AnAOIKFC7uZBnczmMB06iZ32JHr
         iSd7edjUClSmJHOqrGIFWJBAzAInnFskCowdGpud54603n+r9cBGYOlqg2lgowI+UzuO
         TWjBgYNHcbuY2RHk8lUMyvdu8VKUuRtFx3o1C6it/zrVztEYEkXVU0iPKfZmqF5Mgw6Z
         zZsyubhLSEjOntLGg9pBOHyWqpyRWL4vngYtxK04BhCV9WgFXMgrKHG6FsRsEIRuPveB
         sOsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772564384; x=1773169184;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ldkqWhKG/pViPGOuQtoZh0XEluH/KUMdKjz5oPW4qRY=;
        b=huz/OWXy4lgySOXNWstkNAvR6JEQbO6XkGWwwg+LbzVaGhgvLYpRBesWGQd3n5UAn6
         gGhWxhZAkP8lgYGkA3AHwxnnbSqA/s5p6Ei7A1AATXAyQE+jIkoW1dYyERDJIa4Beu5O
         Ho/WlJx6ox04Hiih17W8O/5eWnxHGrVMmDjG8wtIzQlfDX8zsF2up2BQeZNx+BHbG7aP
         8cBppSV1+/NloBO1JUgveCE0CwvyalicD/et16k4ffS6/AwvmL/R2P5syNyOuH2uLUia
         4Pk8V6nRmli4fH40eqjQpts10EnlNabWQ/704DDDkcqHSKz35ueaht1GH9UkuZvkxAJW
         fU4w==
X-Forwarded-Encrypted: i=1; AJvYcCW3eRWKiDDigy6gyUQeujU6Fm8OAOIv6VHve1nS4IjyHbqMNddMUlg5/9MGXwmFhAatT08=@vger.kernel.org
X-Gm-Message-State: AOJu0YzmFePi1ODZOHNVA6cENgVoSa/VtTzZi9VveJKeS3TW8KnXh+tK
	QPLXt9DdkWraXPPUm/PNO/+LQheHFCuZD/n1tYJvv0PcLervNd4NQcmLDYpqX9ez2iht2Orngwc
	rfVr6g2WH//3Q/pIeQGkQlV6H+xIx2wVnf40zUb4td9WsUqdTR2V0Yg==
X-Gm-Gg: ATEYQzwRxzryV1oLJoUmoNIPcAKCzLRehJ/8F7rwy9ZgD4Yevjcz1JxAA9ECw6fD0av
	wQH64jPnr5GyThXClFFmvFCP9vPMnu7aRkVexADgz2p6hYmqp3Voi/i0cT64lL9UVIc0gOjeMsJ
	QwSwHsNpDII/tDtHmnwXy9M2Zd2n1ZpRWgd0pWZKP9vUxZCz8D3DJdtbWAMEKTGqWjLWpAVPB5A
	k/yvYqTETck4yxjOoW1aBHpVCe9frNrewYgBhvBrZVxrH8uZfj8Mch4BLU+eInsuw4kKp8E7U8Z
	8mw6/LFVfdxi9YYUABLtTm03ezf4B97LamroRyUHITA1JN3qX/5YPHbNSOobonVahtnJDokdwxR
	zyU99IwN54d2zAg==
X-Received: by 2002:ac8:7d0d:0:b0:506:bfa3:55cf with SMTP id d75a77b69052e-507528822b1mr229496241cf.6.1772564384367;
        Tue, 03 Mar 2026 10:59:44 -0800 (PST)
X-Received: by 2002:ac8:7d0d:0:b0:506:bfa3:55cf with SMTP id d75a77b69052e-507528822b1mr229495751cf.6.1772564383736;
        Tue, 03 Mar 2026 10:59:43 -0800 (PST)
Received: from x1.local ([174.91.117.149])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cbbf6869f5sm1629087185a.20.2026.03.03.10.59.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 10:59:43 -0800 (PST)
Date: Tue, 3 Mar 2026 13:59:32 -0500
From: Peter Xu <peterx@redhat.com>
To: marcandre.lureau@redhat.com
Cc: qemu-devel@nongnu.org, Ben Chaney <bchaney@akamai.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	=?utf-8?Q?C=C3=A9dric?= Le Goater <clg@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alex Williamson <alex@shazbot.org>, Fabiano Rosas <farosas@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org, Mark Kanda <mark.kanda@oracle.com>
Subject: Re: [PATCH v3 04/15] system/memory: minor doc fix
Message-ID: <aacvlHgJtwOL1QE0@x1.local>
References: <20260226140001.3622334-1-marcandre.lureau@redhat.com>
 <20260226140001.3622334-5-marcandre.lureau@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260226140001.3622334-5-marcandre.lureau@redhat.com>
X-Rspamd-Queue-Id: 127B01F5996
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72565-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[peterx@redhat.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[x1.local:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Thu, Feb 26, 2026 at 02:59:49PM +0100, marcandre.lureau@redhat.com wrote:
> From: Marc-André Lureau <marcandre.lureau@redhat.com>
> 
> Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
> Reviewed-by: Cédric Le Goater <clg@redhat.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu


