Return-Path: <kvm+bounces-72598-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wAhYDKtEp2kNgAAAu9opvQ
	(envelope-from <kvm+bounces-72598-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 21:29:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 870B91F6C8B
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 21:29:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EE65C30E32D0
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 20:27:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7093E3A5E65;
	Tue,  3 Mar 2026 20:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OQGvLbsa";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="dodztUJ+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A334386450
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 20:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772569636; cv=none; b=OpUytVfIFD66+K3e1pVxdGd2vqHqhPXIsEEihblPMpDD/273gTjo5SfJ3qnfEgPWtgzGCwb8KZjC4sFUYbBMudJkB8B0W2qnDDnAe0V42MKJbbSoiiJ2uBZXE5PiIUWeqoRJdcb8+P4rFjIq7IE00ZP6r5yapcz5/sa8Mdoo2aE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772569636; c=relaxed/simple;
	bh=0hZDqraNSVzilZsLq/b9BPmTLhO/Ka/AAdCfL3qPwHk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=STWRr7vXWr1H8LXlwRl2S0vIn7KrQpeiitGsRWV9FdvvnwuB4rG4I4g/ghPNSX3eBctzPtqPETTPN5IeKgugsps5uaiWBl1rB8gFMyS6K8FBy4I89j5F7N8yQ1u4wwaILj4BBlxB1Pt9tuh9rJQg2OIKpf9/9kHRBon3ErUXTQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OQGvLbsa; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=dodztUJ+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772569634;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KhHWeIHx6PBaZnfFcmqNEOBqnPdBYa4kH3IQHIX7oZo=;
	b=OQGvLbsaqB+teaqQo7TGCRjJ3Blff8vHzaBHZgeL+kp+W5EhoRt9bUqS5OhJxXvlJBfnq5
	rJHQTXnAUeHsdQxYHhxZzS8Eu/yI/MOWEO2AeWc0/jsJZyBeqgpLPw/BKkCAwPXausR35R
	MJSV1GfrMZckft1zRIU28NA0BWYZMHM=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-587-Bp4duMXkMHiVG1LHaHlqIw-1; Tue, 03 Mar 2026 15:27:13 -0500
X-MC-Unique: Bp4duMXkMHiVG1LHaHlqIw-1
X-Mimecast-MFC-AGG-ID: Bp4duMXkMHiVG1LHaHlqIw_1772569633
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-8c70ed6c849so703466685a.1
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 12:27:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1772569633; x=1773174433; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=KhHWeIHx6PBaZnfFcmqNEOBqnPdBYa4kH3IQHIX7oZo=;
        b=dodztUJ+U5pZoxqaeDQNHuoLTB+7VtJKdEZd/mx1suh+sC/rCgu5Vswc03ZBlZ7ljE
         8tHrL1SMzgvskqv6+UD+/P22SThn47C560DpcRt07wWROcwpLdJEQHfvTV/utR/N4jAU
         oocOIMm2wIEOdeJK1IPTtiScqYQQQuCw/ucBA46AUhfpCf5DQhS3NLd7z+75F5TcpwMi
         8iWS2whV4wcM3JdxcHP+0O6+D/MYLJkfSGkuKaxuj+yQTcynM53dL2PNlUoy5opECQoz
         1YXK/X2n97uXI76BaBMiIdZD40CgQ5SSBKd5s4D7yDxqD+9qFgVU3K9xW7oyn6OhXc7j
         52rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772569633; x=1773174433;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KhHWeIHx6PBaZnfFcmqNEOBqnPdBYa4kH3IQHIX7oZo=;
        b=QdUCGuaKFn2exH1Fa3vwmZCv67vwsMxDyglanPWrAsqPKRbaL8fLefgw4DLnKiH8Us
         yXJc4rkmcljjI+g+AXj011s4r+au7F0gbdl4ZJW9z8VgmwgtvSqMthCFmOrFdm+CETn3
         w0jAWbryHyDKVuTDCp7AzPiVShXfUIfG5DkwOdn1NossKvHgBtfhzVJM0sB+ICM1LIxU
         jtv22zu4CWj50kpjm5UrXTC9TVdSoPtu22xaCduQdzLMqBkCYB6kDFzkzoeoYyhnPy8C
         F/ffv2zC7R5VdJDm1Cr1yVobZ3dfzF5lrpEIRmpv/40mgZX/BvodTCeMBrve1Vc+1pME
         k/aA==
X-Forwarded-Encrypted: i=1; AJvYcCWpo6EONaZMKvuoUUcqEjlz5EgIZXNLTV2wNAmRQzXu85FmEeZentS70/s1f7HTNJ304So=@vger.kernel.org
X-Gm-Message-State: AOJu0YypCX78u3BARQ7DCfkOrtzJ9STfbbUtflwLMG/LmN37cx/SXsPI
	zgN1IU/H5e+yRUcTurXK6k+T5hUJ40HsZdq4qk6kCJifYn3tQE7srHsLwjOEznNEFAd3joPQ2Js
	708rufexEK8FOP/ieIZUQnVtycHGGUFhC4rvugbIkileE0CysEYanow==
X-Gm-Gg: ATEYQzwG6cWs9bHWcl3K/iZoyuTfj9jXjPsq406qCEUgIETbYd4RIDtZtynBL8Y+/+n
	2eWLV8K6FwVVri4SU9ndOG8vcNIJUTjQeoqIyyWeFfhzcAVYWv/hGvTQdjRLH9yIUJywZLoqtzN
	lUBkk0eyO7vDErlplAiZVIOnpMC/Zc+pHrhyBpZWOi0RtlVVr9x15mW7SJvNwIPAvwVzQ7Q0lqR
	NbmB2VDOaM44df9/T49BI4IVaxEdkVwUqXWsSmB8v+hUb1pA6gFxEn8wdm0ezzmatnYMf5F5AEc
	eth4pJZlkJH8RhMg9ZlWL+yMRNFL0osUFA51+HUS3ZSVytakM7xD8eFMHTShWczve8m91aXTlEl
	iTAVjAgM3phu6xg==
X-Received: by 2002:a05:620a:711a:b0:8cb:3a1d:79fa with SMTP id af79cd13be357-8cbc8e1fc02mr2326811085a.58.1772569632635;
        Tue, 03 Mar 2026 12:27:12 -0800 (PST)
X-Received: by 2002:a05:620a:711a:b0:8cb:3a1d:79fa with SMTP id af79cd13be357-8cbc8e1fc02mr2326806485a.58.1772569632083;
        Tue, 03 Mar 2026 12:27:12 -0800 (PST)
Received: from x1.local ([174.91.117.149])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cbbf6592desm1466684585a.2.2026.03.03.12.27.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 12:27:11 -0800 (PST)
Date: Tue, 3 Mar 2026 15:27:00 -0500
From: Peter Xu <peterx@redhat.com>
To: =?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>
Cc: David Hildenbrand <david@kernel.org>, qemu-devel@nongnu.org,
	Ben Chaney <bchaney@akamai.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	=?utf-8?Q?C=C3=A9dric?= Le Goater <clg@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alex Williamson <alex@shazbot.org>, Fabiano Rosas <farosas@suse.de>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org, Mark Kanda <mark.kanda@oracle.com>
Subject: Re: [PATCH v3 09/15] system/ram-discard-manager: implement replay
 via is_populated iteration
Message-ID: <aadEFOLPsRjWTcfX@x1.local>
References: <20260226140001.3622334-1-marcandre.lureau@redhat.com>
 <20260226140001.3622334-10-marcandre.lureau@redhat.com>
 <99b0ab59-c1dc-4d23-addc-7bf4b87bfa03@kernel.org>
 <CAMxuvazwmjjpnpsWpOd_=HcS-6ynpVjAw2u3R=VuE=Lhg=AnKw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMxuvazwmjjpnpsWpOd_=HcS-6ynpVjAw2u3R=VuE=Lhg=AnKw@mail.gmail.com>
X-Rspamd-Queue-Id: 870B91F6C8B
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72598-lists,kvm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,x1.local:mid]
X-Rspamd-Action: no action

On Tue, Mar 03, 2026 at 11:47:52AM +0100, Marc-André Lureau wrote:
> We can still iterate with 2M granularity after this patch. However, it
> may be less effective than iterating using find_next_bit(). Whether
> this is noticeable remains to be seen.

IIUC when in extreme scattered cases the results should be similar, say,
when the bitmap (2M for each bit) is 10101010....10101b. OTOH the worst
case scenario here is when e.g. the whole region is fully populated.

So.. if we have any concern, maybe we could run a VFIO population test on
non-CoCo, before or after this patch, having the whole region requested
available (so a bitmap with 111111111....111111b).

Thanks,

-- 
Peter Xu


