Return-Path: <kvm+bounces-70727-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IPeZCC9Ni2mWTwAAu9opvQ
	(envelope-from <kvm+bounces-70727-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:22:23 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CC4611C6CB
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:22:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 737DE3039807
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 15:22:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E25633BBAF;
	Tue, 10 Feb 2026 15:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NLAYXqqn";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="EtO932pm"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61E1026ED48
	for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 15:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770736931; cv=none; b=TNdApQrpV4QlOBkzQeie2IyfJMmWqjw9wKgQXOFiK9vs/n3pLTKOmjZapwNHt+zYgMrTCjSx8Mu4ZMZTqT7H93WscdBA3lKoqUk9dct0kN8kOhzXWdlFpGDLyvQ6O1l67EnxxNPsMhqlGrryPIqR8nzG2BtSJS+X1mqq6gBXQNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770736931; c=relaxed/simple;
	bh=u2OVsxHAXcG11SANG9Xt/uSYpel3jn4TmPAUQpcFijc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Cl1Gx8NyYhDgtFW4M4v9Ncw0ODVikQWy/cC+xZY5wq1fUtCDpAC3xYpYOkHvSqUxYTnW+tHBXJ/bP6cryj9X12PfeXlNo+2aFCUMKwY3UvES1K/wSniQbWW3P9P3/9qVcrRnHWgA2IKlKCgLAqa075pSB8MuPdqY+78L7v5rKrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NLAYXqqn; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=EtO932pm; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770736929;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OBEga/U7sWndeK3K709LiSG0w7JQZvu6UkLvuItg/zk=;
	b=NLAYXqqn6yHJ3xFqX/O4LscVdqogmf9yQxb1zDw9CKaO5QWD6OlYEGqDS5KGRb+FgfZJfH
	8Mp+M7QOTMNyjRlDTt3Tb9uxIXVisYQ+byABFINlpl+IY2zZWN2W3ZnRYqWsNZfJZrZs7u
	hLCIEgDwblBUrtBBwCaIkQn/J/HPV10=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-159-NaRl99Z5MNSFsULyv6jOrQ-1; Tue, 10 Feb 2026 10:22:08 -0500
X-MC-Unique: NaRl99Z5MNSFsULyv6jOrQ-1
X-Mimecast-MFC-AGG-ID: NaRl99Z5MNSFsULyv6jOrQ_1770736928
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-89700915423so87910036d6.2
        for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 07:22:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770736926; x=1771341726; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=OBEga/U7sWndeK3K709LiSG0w7JQZvu6UkLvuItg/zk=;
        b=EtO932pmCEEFMtm88DKbq4OWA8YBjNTqAF+ylm5XtD5R4ncjTk3b8rq0j1f39L7u6b
         EnBCAUPqWjs1v4J7gu/0uDT8MRZMXD5msIEmhjreUErdeBXDB4bzO+S6nlMzRM9SIg9c
         j+4fZj8LvgNAJAPX3eBpAFVisrluGiXbzPpcXKhIzp5CPWP7v/V7ly77T/5fsFCddXKT
         pskjB1vR/0j0DhxsWTDgXcxtStVkFA0PjeDWUIIBqDxpRD6+dVN9zaPy3o7rgeFsd/Tr
         JFyG0YCVPHUf2e3iUVK3cm2vduaYwOxM5whGTB02bvLt1RD9QWp4ZTl3QG+/eUYzxubl
         CVcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770736926; x=1771341726;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OBEga/U7sWndeK3K709LiSG0w7JQZvu6UkLvuItg/zk=;
        b=mDKBJ3LFS7+PK8miO8Bg6W7uQ7Z4pS4Yb40GNHK3To5IXwz8NChTi+PYJm5rMjkwUw
         vJIqOF4P9uEyM4L+pANQFm7UH2+e96JuZ+iy4TxLojrAHjqSjbPzkGw6MEsEmuwIbSjg
         rnuNE5cVPAgzprqQ/dZc5OtSAxA4t0yexJaSe9YppG1WVT0ibD6hXJf5Mgt6WEzJ2l5i
         p+mZfuJf05T0gXJFFKZN/IbJfrnJHESwHMW/2KMuauKINZn6pvLtcbS/Ca5gsYlSh1C3
         7fGcTuVOkHldO66p+p5zRiEGDVV8gqNILu6z4+iuIWWWyvl0aBXch7yaMcscJxGruw9U
         1dcQ==
X-Gm-Message-State: AOJu0YxgA1hFynY0WzrwmPPoXnz59yu20ZkyBZzJ1ldT6UVyDM/zX12J
	LOWbc8veJ6RvUg7GstBiGO4izAu18Is+WXIyA1jEmMDfRHwdIdlI5Auo2Mmap5EhczNV9PKGmvK
	Kmcu6+MSsoxdVcPfISaJsdtFZ8WGJ+/ep0V3amDudq/A+2jWBwtPqYlxQPk706llOBNb17eXT72
	9VVjGAIlxqYdSSsCAg/r2LBdb2ABJmTszGPFD8iA==
X-Gm-Gg: AZuq6aIhofdzGmDzp01RnQO+Db/vCdWhvOx1PLzGwpuBFFdJXhyqMKVb60QtwYtmrBV
	8eOah3Ohyq/WJTIUEyDz7mpD0djPlu102HMLwGw0j5cz6t9GajNHigmPID55K7qVgSQeKSPPisV
	Yg+6DK9N7f7jkfp+9QUF2Nsz+BeRmdlo72VeLA8U5KPKkFHu3zZ43RED7ALKtSG6qtCNEQ3LfZa
	sblm03wDmviiB6Rxb9lAPUlyRUDDN0GC+uX7BgI9iIwIOmVWYAa9Wd71T1yzfbHsL+N5Y0fXOTp
	IVxE3xZ6m1oZrotJf+cIAWvLwz39dG9mI+kp7NhXDOcscZF4rw6q66vv1LUX0wEk8zg/cwXDdE4
	my6gfLEg65n20n/v6ZM2xLQOfXiZZ
X-Received: by 2002:ad4:596f:0:b0:894:7852:9bd3 with SMTP id 6a1803df08f44-8953ca7bb89mr205998846d6.42.1770736926393;
        Tue, 10 Feb 2026 07:22:06 -0800 (PST)
X-Received: by 2002:ad4:596f:0:b0:894:7852:9bd3 with SMTP id 6a1803df08f44-8953ca7bb89mr205998446d6.42.1770736925986;
        Tue, 10 Feb 2026 07:22:05 -0800 (PST)
Received: from intellaptop.lan ([2607:fea8:fc01:88aa:f1de:f35:7935:804f])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-506392f2e5csm100035561cf.33.2026.02.10.07.22.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Feb 2026 07:22:04 -0800 (PST)
Message-ID: <8ffd86d8fc000da72a7607a810cae30fe3c9f6c6.camel@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] Skip PMU portion of vmware_backdoors
 test if PMU is not enabled.
From: mlevitsk@redhat.com
To: kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>
Date: Tue, 10 Feb 2026 10:22:03 -0500
In-Reply-To: <20251208233910.1000465-1-mlevitsk@redhat.com>
References: <20251208233910.1000465-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 (3.52.4-2.fc40) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	TAGGED_FROM(0.00)[bounces-70727-lists,kvm=lfdr.de];
	FROM_NEQ_ENVFROM(0.00)[mlevitsk@redhat.com,kvm@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_THREE(0.00)[3];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FROM_NO_DN(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,oracle.com:email]
X-Rspamd-Queue-Id: 8CC4611C6CB
X-Rspamd-Action: no action

On Mon, 2025-12-08 at 18:39 -0500, Maxim Levitsky wrote:
> Since 2019, KVM has an explicit check that if guest's PMC is disabled,
> then VMware backdoor via RDPCM is disabled as well.
>=20
> =C2=A0commit 672ff6cff80ca43bf3258410d2b887036969df5f
> =C2=A0Author: Liran Alon <liran.alon@oracle.com>
> =C2=A0Date:=C2=A0=C2=A0 Mon Mar 25 21:10:17 2019 +0200
> =C2=A0KVM: x86: Raise #GP when guest vCPU do not support PMU
>=20
> Fix the test failure by checking if PMU is enabled first.
>=20
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>


Hi,
Any update?

Best regards,
	Maxim Levitsky


> ---
> =C2=A0x86/vmware_backdoors.c | 18 +++++++++++++++---
> =C2=A01 file changed, 15 insertions(+), 3 deletions(-)
>=20
> diff --git a/x86/vmware_backdoors.c b/x86/vmware_backdoors.c
> index f8cf7ecb150b..c18f0bf86356 100644
> --- a/x86/vmware_backdoors.c
> +++ b/x86/vmware_backdoors.c
> @@ -1,5 +1,6 @@
> =C2=A0
> =C2=A0#include "x86/msr.h"
> +#include "x86/pmu.h"
> =C2=A0#include "x86/processor.h"
> =C2=A0#include "x86/apic-defs.h"
> =C2=A0#include "x86/apic.h"
> @@ -101,7 +102,7 @@ static uint64_t vmware_backdoor_port(uint64_t vmport,=
 uint64_t vmport_magic,
> =C2=A0		PORT_ARG(a, b, c, m, sf))
> =C2=A0
> =C2=A0
> -struct fault_test vmware_backdoor_tests[] =3D {
> +struct fault_test vmware_backdoor_tests_rdpcm[] =3D {
> =C2=A0	RDPMC_TEST("HOST_TSC kernel", VMWARE_BACKDOOR_PMC_HOST_TSC,
> =C2=A0			KERNEL_MODE, NO_FAULT),
> =C2=A0	RDPMC_TEST("REAL_TIME kernel", VMWARE_BACKDOOR_PMC_REAL_TIME,
> @@ -116,6 +117,10 @@ struct fault_test vmware_backdoor_tests[] =3D {
> =C2=A0			USER_MODE, NO_FAULT),
> =C2=A0	RDPMC_TEST("RANDOM PMC user", 0xfff, USER_MODE, FAULT),
> =C2=A0
> +	{ NULL },
> +};
> +
> +struct fault_test vmware_backdoor_tests_ioport[] =3D {
> =C2=A0	PORT_TEST("CMD_GETVERSION user", VMWARE_BACKDOOR_PORT, VMWARE_MAGI=
C,
> =C2=A0			VMPORT_CMD_GETVERSION, USER_MODE, NO_FAULT),
> =C2=A0	PORT_TEST("CMD_GETVERSION kernel", VMWARE_BACKDOOR_PORT, VMWARE_MA=
GIC,
> @@ -165,8 +170,15 @@ static void check_vmware_backdoors(void)
> =C2=A0
> =C2=A0	report_prefix_push("vmware_backdoors");
> =C2=A0
> -	for (i =3D 0; vmware_backdoor_tests[i].name !=3D NULL; i++)
> -		test_run(&vmware_backdoor_tests[i]);
> +	if (this_cpu_has_pmu()) {
> +		for (i =3D 0; vmware_backdoor_tests_rdpcm[i].name !=3D NULL; i++)
> +			test_run(&vmware_backdoor_tests_rdpcm[i]);
> +	} else {
> +		report_skip("Skipping VMWARE pseudo RDPCM tests, PMU not enabled");
> +	}
> +
> +	for (i =3D 0; vmware_backdoor_tests_ioport[i].name !=3D NULL; i++)
> +		test_run(&vmware_backdoor_tests_ioport[i]);
> =C2=A0
> =C2=A0	report_prefix_pop();
> =C2=A0}


