Return-Path: <kvm+bounces-70941-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ODg9IF+mjWkJ5wAAu9opvQ
	(envelope-from <kvm+bounces-70941-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 11:07:27 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 1359012C41B
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 11:07:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A78313053BFB
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 10:05:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D92B42D8387;
	Thu, 12 Feb 2026 10:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PNjwlmdB";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="VB0Djb2H"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02FEA770FE
	for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 10:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770890740; cv=pass; b=kVHNPTzF4mFMmyVGRM8QuzZv79xi4rFPBiM6Wap6vZbCGr4pL7lpHIJwU5yg7xd694vr4cNE7BghQfZqpOyLaWGCm3Ll5/Tu3C8wIACbs/JNOJk0SR7gD5FqUamrjBywHEAt3vAjtXOkWnt1oJyiW42Uafdpl0Fs2/iLEALUDaA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770890740; c=relaxed/simple;
	bh=Palnk57ns0jhkex/FuwqU16gNGoFQGjPHHww4SgSmY0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cidaRz+VCPmNG0XiaYVog+H1IHcB93SIUlIQbCezQVoGvd8w5e4kgrSG0Uvf0VUs7ksiZt73u5jKDNOn9wlGqVSCOcn6mUKY0sjvb3dum0f4pVzEJBXP12ENx3gSYGGb7uES8/lG2VxpdvjvihaE+PXylYPBk313PZJmnZUB878=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PNjwlmdB; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=VB0Djb2H; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770890737;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=evg6KQG7cR7Shh7gkq+/8mq53gSxY6rXD1fbSI+f62k=;
	b=PNjwlmdBh7pWsyIKmT1KcEKQQV2oZsOt8STcYeH6CQwBu1/wvHpO/Db0pG93rWWEYsDBK7
	4RHocOa8w/G6POxeqaiQXk7m6op7PAP1n7z/dGqn7WvjoPXuVZyTAWPkAIq46jhtVWDY4b
	sX/dKwcjepFYXP3JUUr2HzzECBfeB5g=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-580-1GLPkFRVNWiUZ4UzAMZPeg-1; Thu, 12 Feb 2026 05:05:36 -0500
X-MC-Unique: 1GLPkFRVNWiUZ4UzAMZPeg-1
X-Mimecast-MFC-AGG-ID: 1GLPkFRVNWiUZ4UzAMZPeg_1770890735
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4801bceb317so31422815e9.1
        for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 02:05:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770890735; cv=none;
        d=google.com; s=arc-20240605;
        b=EjmEqOIrpfDq43o4zk+Mquq3M4l0Z6nr2XHxRoS++9J0dLBn4WBxr8KbLcpOpQmh8k
         PEywkyAi3WEhPN6LRHboNlM4RYZiPrt3HejXXuUgmrHggVuc2q9R6dJgXhbnh9Qejf64
         Gn9ZTsp9NLZBL8h05x5bUyvL/kcARHfO88UVkh0B8DvaGiJ9QNm+O7EgguvP3q+uRB3Y
         z+HTpViMws/LwYNKojHWEKh7s4E7xSbigBWSGRBKShlx8ljMajLB6qRZSwGGEy2UqMLe
         dhmCk8SC5yCAvGU1sP6B5MWQKPYfASDTmAFvfepKDjwgdrWrGP3Dc5B9Ar6aSJNHr41w
         6znA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=evg6KQG7cR7Shh7gkq+/8mq53gSxY6rXD1fbSI+f62k=;
        fh=eFA0ojrjZMf4inzHQ6FwCnPuNxpg4hIgWlnOc0BaT9Q=;
        b=jlih2oInJ1Xf4Msn+tXHGJqOIKR+0DGgJ1w4kwXbhnh7AHwqvZBgM4vnlJdkwBL6mr
         yeUBu9ZhYyheEcfrx3totlPsNxTHGSywfwt7RFtuKYez2RJ+PZRnNGk14eM9+bBehkk7
         i2q1QACCjnQByxMta1jDWygbzqwhHff/MudlAgtq4dLYFRHz9xPs4SpiLmFk3NDwwyir
         pBbe7NPCdUTquBDbew/IcZO2HWBjwFjGIxMzsFgXuWdrjp3RoiL6pquOJp+UFTxq4WDs
         cS6H6JwxDP1xqjVugu+BeD0S2Fuky8ugQjHUZ/2UqUQa4tsgRLB9GhBasPXE2M0v/K7m
         Aktw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770890735; x=1771495535; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=evg6KQG7cR7Shh7gkq+/8mq53gSxY6rXD1fbSI+f62k=;
        b=VB0Djb2HyG/2M37Ms7H7DcBJVTPVNocPpnYrsS0m9q4JhkRI4AoO5P3xVj73ps70Qr
         GOUPTzlBtKVsp7nIoQdiTJea3BzxWhL9xWyHVWlXFNR0smSttjVTsRrfz/xFBvsOH5tQ
         WmR0c2iv2nm2zn1cF8BXtmvcocuM4VXxfAJoAEe/IlNk8pMgRBQNIrrs1c1DoOXi79Fw
         h41/SObkZRXWpKpz0EsImh3GYjoRNWm7oM1swvy3pyD05Lcm3TAMwdT2nSITvCZ3W7+O
         64wkvThSY3QGSB0ESIaErnrUJdCbSJkLWFDjwqvnHGcLGXu7pfOlb/+aQU3UB8kqNMUU
         ZHRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770890735; x=1771495535;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=evg6KQG7cR7Shh7gkq+/8mq53gSxY6rXD1fbSI+f62k=;
        b=PyGKl39DuLfysep5dHS9upKHBVo1VdjheptXuebcuegkom/y6cfaneGe6DIQuCn3fU
         h7cn0eaFMcQfFttPN4rH9MvXseI9AKl9ln1eS6zqRUhD8ntHfHHEzFqrGnMMOTtnY2E9
         IRr8BF0HTvDVpL2Tf78Kbsjfn9OHTC3iuVOIBMJbTrpVGlmJ2yrvz5XfqkabZmQWkS2q
         /imlJS1gOGBiDG5ApMVjt+xyEsnoHGcTmt7uU0sBfLnaoz3XOUg3yimgE+bzxP7Hi/3R
         I82UVaqU/8m55wJruyS/bwx8yIYjTh4TiWOjXh/ghvOcIXiHu4uRSA5xArpij1MJJ/98
         aRTg==
X-Forwarded-Encrypted: i=1; AJvYcCUslQQ/s14AWZtSaLNDYgeyKFOe6MrcZ15ugFlwRkhpGV9J8rUtRzOYvwtKzuvwQq+joiI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxNkZ/URM31rO4+NPXlK9Kl36+xQiuS+RN2EddbZnpIhSoRz+XT
	4hqQWtgxh8gQK9WvkqJQEfbKZ7aph6Fkmox8vqFHACA8A6yu8YPUF0WX9sQzMZIRGwozLctqJN7
	YyPeY9Hcd78dg1EAMBhwqjqzhY3AEox5SJL77JlKftkhx2HYdZFncm3eU7d5NOKRxPsu54o6ke3
	2xkLtd59F8h7D0Fk3JjupP2ouLm+0v
X-Gm-Gg: AZuq6aLu73GHXH9Ir2xaYRgivVQZGdJMyLhOYqBcx8pWqqcWCXhCJQHQxzPC2Wb6OXS
	D2Vt5efZxeqzyWfl5HgfvcF+tmPw8fI+ILSQn8lMBCO7VB45ma5AZlqc85lCzbLV8Qz2FFA/Htb
	GOugEJ0z0IzguBjQLbfTZB7rP4AUJQZMzMh/ZsAzjjTB3YoKxt+s2m2wVrdfv403d1YMAAtD+dO
	Fe6zMRQs6HgLT7cUoHY1/5h7y2/b49H2g+kZd8QjN1soYcLiu6FbpkJirOg2D5guxwT
X-Received: by 2002:a05:600c:870e:b0:477:7c7d:d9b2 with SMTP id 5b1f17b1804b1-4836716c208mr20934135e9.32.1770890735309;
        Thu, 12 Feb 2026 02:05:35 -0800 (PST)
X-Received: by 2002:a05:600c:870e:b0:477:7c7d:d9b2 with SMTP id
 5b1f17b1804b1-4836716c208mr20933705e9.32.1770890734867; Thu, 12 Feb 2026
 02:05:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260212062522.99565-1-anisinha@redhat.com> <20260212062522.99565-18-anisinha@redhat.com>
 <CAE8KmOwa1M_F9Qfs-XXRhaJZx7jiwQDfwDk7U2shJi8SLa+y9Q@mail.gmail.com> <6C39045F-DF1E-4E9A-8ECB-AE24C766F002@redhat.com>
In-Reply-To: <6C39045F-DF1E-4E9A-8ECB-AE24C766F002@redhat.com>
From: Prasad Pandit <ppandit@redhat.com>
Date: Thu, 12 Feb 2026 15:35:17 +0530
X-Gm-Features: AZwV_QjL_URuAFSIF6IyyIsLh7ty4PiS5HnaLtdQKyX1AS6TAldCbnyOE3xJRbs
Message-ID: <CAE8KmOxmw3nthEXDh2zQQEtKyeNN0mPnFRhzM1ZgCUCkZpTefg@mail.gmail.com>
Subject: Re: [PATCH v4 17/31] i386/sev: add migration blockers only once
To: Ani Sinha <anisinha@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>, 
	Zhao Liu <zhao1.liu@intel.com>, Gerd Hoffmann <kraxel@redhat.com>, kvm@vger.kernel.org, 
	qemu-devel <qemu-devel@nongnu.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,mail.gmail.com:mid];
	TO_DN_SOME(0.00)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ppandit@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_FROM(0.00)[bounces-70941-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+]
X-Rspamd-Queue-Id: 1359012C41B
X-Rspamd-Action: no action

On Thu, 12 Feb 2026 at 14:07, Ani Sinha <anisinha@redhat.com> wrote:
> Maybe we could do something like this (I have not tested it) but perhaps outside the scope of this change set:
>
> diff --git a/migration/migration.c b/migration/migration.c
> index b103a82fc0..7d85821315 100644
> --- a/migration/migration.c
> +++ b/migration/migration.c
> @@ -1696,8 +1696,11 @@ static int add_blockers(Error **reasonp, unsigned modes, Error **errp)
>  {
>      for (MigMode mode = 0; mode < MIG_MODE__MAX; mode++) {
>          if (modes & BIT(mode)) {
> -            migration_blockers[mode] = g_slist_prepend(migration_blockers[mode],
> -                                                       *reasonp);
> +            if (g_slist_index(migration_blockers[mode],
> +                                 *reasonp) == -1) {
> +                migration_blockers[mode] = g_slist_prepend(migration_blockers[mode],
> +                                                           *reasonp);
> +            }
>          }
>      }
>      return 0;

* Yes, and when g_slist_index() returns >= 0,  return -1 OR an
indication that the blocker (address) already exists in the list. That
way other such instances where the same blocker is added multiple
times will be caught.

* But let's make it a separate patch. Restrict current patch to
removing add_clocker calls from sev_*_launch_finish() calls.

Thank you.
---
  - Prasad


