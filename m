Return-Path: <kvm+bounces-72595-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4Og0B/c6p2npfwAAu9opvQ
	(envelope-from <kvm+bounces-72595-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 20:48:07 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 777E81F6537
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 20:48:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 86EDA306C456
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 19:47:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8989A377EAB;
	Tue,  3 Mar 2026 19:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="da1WQBw0";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="EXtv3gXr"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B6337C92F
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 19:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772567264; cv=none; b=oN5wPhxKjDG9GIyuN2ZK41DH+YANOOA8oY1dPtMXO8YSnIObGFbMWRLmatu2J7Q9SeC8LwACWanDfvdYYdVLbn1nsnFxEqssjQBdow0MUpMBbN0DYQ+nx3s6MKbDD2l/bj4rQw02C6X0a5JDvqEScXPqiF5mwgI/1H3Vrt5d6js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772567264; c=relaxed/simple;
	bh=Anbxc//peAMvcxQcgkmKHCZtgNkVswIIFg91YgOU3ew=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fjQBmO66nqxUh/oYEBMc0zCFMNsXrF6iLJ0nKjFmk2NyKkNx/9JJ/hBwj+s2e/SzRV8mDtVahUzF/qWimOQn2WoNqag9uUfxei7Zqv1L6aL1C1N+ZbM6s1AZisiLIqWXv7wN0RbgjG6e/tE4wKKracXuAeA+CJ1dRFco5BrywPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=da1WQBw0; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=EXtv3gXr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772567261;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hZ5mwgUAG7XwfmuP1U/gK7vblRqb85qDjOlUL7FdzpY=;
	b=da1WQBw0M6QpkcmGpTaVHxXvMdCFM7Wh6AaCxcRDzAXgjjs74IEc9YWWk8i2pJKHCt6qYM
	spy5Ee1Ae9PpWU3s2Eh3YKBLZbRZg7Nuofpo6nuIqjzc+1Gb9X9Xl4G8E0KiJVEtOPHbFm
	OBBS7BpD58GsjARjX5u9ms8ECsDJS8s=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-393-oI6mO4i4NcC-RshPGa7JPQ-1; Tue, 03 Mar 2026 14:47:40 -0500
X-MC-Unique: oI6mO4i4NcC-RshPGa7JPQ-1
X-Mimecast-MFC-AGG-ID: oI6mO4i4NcC-RshPGa7JPQ_1772567260
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-503342386c7so86733361cf.0
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 11:47:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1772567260; x=1773172060; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=hZ5mwgUAG7XwfmuP1U/gK7vblRqb85qDjOlUL7FdzpY=;
        b=EXtv3gXrNWct7Ev47GCr55YeFYFG92rVzfNlaFZbFIwDsE3s+kvhsN5jW3NVfXgdsp
         qzAhH3bzXVGuFWxHelC8uBGurm8u+nSTFjraiVhalf3hnqdR02JIOg7VahlDS5ku0S+f
         E3dhF8FvNrZ1rdwATc6YJvmRO/v9l0sE1EZjVzvI2ui+kyAmpHUt4C8Nq0IePzaYUCH+
         QaUJIQsbATnT7ZIl1lUZ5eGfzjjtG+R9krZnx389Id20z88heZRPidA/6rw7WvAxZ8TL
         a4Xx4GaRn/kKb2o+qTGzMWfblgTvAwY+oExsAeAMA+H1KHGcdOm/4zhfghYEfShg/c9S
         AM4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772567260; x=1773172060;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hZ5mwgUAG7XwfmuP1U/gK7vblRqb85qDjOlUL7FdzpY=;
        b=pPzOtF69vmKMLNQKGxf/SMbJ5cACN/M0Z+j5yHI1JrphvhhImpBVMtM879zhJNBrZO
         3/DoLN6OCfy+RDMXxJhwEraP7iMSNfpBDor5RCjVzLp9w00y94e2wwPgSmz8GuUNAP2Q
         u8Hc6B1jKU57yZnbSgEAhMoylQPNbdG34L5NTEhSBPwDVLXuDyQvW/53l2Muntakqu6h
         oyDWOP9R2jrLCK6yEuYPWU7WE4BytFUCsGPuzTdt6gPtb39e0sQFfllC+FeYZ92nPgX6
         0hwWP1St3GTGN/vQ1MNGOtwS3yK3Nmkn1Ck+dDR4tKSEWaYpcuSdda8n4BcEeE03eAYz
         unTw==
X-Forwarded-Encrypted: i=1; AJvYcCUm5DPiRH161d2TNsvh0aIzkPu+X6YhCbGyTya4N8fa9GTvqSa6UoP8GkdonPfoybAhVT8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyItVm6SC8zH1gEJIF8BHvbLSENVE5WbajHchnUNN4Ney968Rss
	7/W0l9XAtw+Qu8vhtaPsbzvX1lPdbdFCnFiyw2Oc97sRDhJWBsvA0sKk5V6O6N/04bHxYFf4PuA
	9lyt6M75KCQVLfYraGokAQHct6iONIvh/TUusr3xymLpmGbgZDlVIwA==
X-Gm-Gg: ATEYQzwqSPM7bs+IlV728ejl0/bheqzwAMj98o+PsVUfDViUWELgvsgWrKj2JrbRGYF
	vD9o0Kam+wZFGPHpZYHnowaL3wmK2sub3SGtbv1BwvF54Kt4RUVd5+q8uMG335rMON+ykCNojx0
	jUiUrJFNJN9FX1wJepBf+XqJ5FLT5WKLWSx+QoWjLo8Ypo/QytSX8GrWiFgPcwP1si3qE2fOPAM
	mt7eoAL0yUVPmsQ0JzlHiEzYxXf1nav/H3pvrJmdchxJDQbUqIcG2AZRtNCxjoIOi4waqpqKcmF
	hUbhdp/9u0AfofkB/pGGja6uoxmXO1EhUPOlVyY+znevqBZe2imyPixHP2sxZG7wePvxEh9lqR7
	U8uYbcce0/TxZhw==
X-Received: by 2002:a05:620a:d85:b0:8b2:f102:b904 with SMTP id af79cd13be357-8cbc8d834ccmr2332141185a.12.1772567259757;
        Tue, 03 Mar 2026 11:47:39 -0800 (PST)
X-Received: by 2002:a05:620a:d85:b0:8b2:f102:b904 with SMTP id af79cd13be357-8cbc8d834ccmr2332137785a.12.1772567259303;
        Tue, 03 Mar 2026 11:47:39 -0800 (PST)
Received: from x1.local ([174.91.117.149])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cbbf6f948dsm1454211385a.30.2026.03.03.11.47.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 11:47:38 -0800 (PST)
Date: Tue, 3 Mar 2026 14:47:27 -0500
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
Subject: Re: [PATCH v3 07/15] system/memory: move RamDiscardManager to
 separate compilation unit
Message-ID: <aac6z557C4oVU5ej@x1.local>
References: <20260226140001.3622334-1-marcandre.lureau@redhat.com>
 <20260226140001.3622334-8-marcandre.lureau@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260226140001.3622334-8-marcandre.lureau@redhat.com>
X-Rspamd-Queue-Id: 777E81F6537
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72595-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
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

On Thu, Feb 26, 2026 at 02:59:52PM +0100, marcandre.lureau@redhat.com wrote:
> From: Marc-André Lureau <marcandre.lureau@redhat.com>
> 
> Extract RamDiscardManager and RamDiscardSource from system/memory.c into
> dedicated a unit.
> 
> This reduces coupling and allows code that only needs the
> RamDiscardManager interface to avoid pulling in all of memory.h
> dependencies.
> 
> Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu


