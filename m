Return-Path: <kvm+bounces-69532-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ADV9ApA7e2mNCgIAu9opvQ
	(envelope-from <kvm+bounces-69532-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 11:50:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 709A5AF251
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 11:50:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3AD47304EA69
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 10:46:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 273A73793DD;
	Thu, 29 Jan 2026 10:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b="lHUWIZmG"
X-Original-To: kvm@vger.kernel.org
Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 090113816EA
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 10:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769683589; cv=none; b=YI+u5aBcTc+HYPjx0XBQtmAdnrhAw6uGfXxlTc8w7wwJtI/w4kwbbZA+CqS/9D3hF5jHlz2x4hmW8qJAhCI+gKa0Bjd7XhzMMCIfY8x0lLkKsQscUNdWKRlViRa8HlIwqVQGVqwhu7CPTZqk9tFc6MRgYqe47QsT49+tokcPyN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769683589; c=relaxed/simple;
	bh=j5JwmiDsttfzg19wCJAsVxjUAiPWxASKMp4aK2rACgg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TJZI1s1ahKya4+fDrIh2Q/pJjwso0noom1Hj8r2q8c5OJ2HVlkwJ5lQDIhqb/z2ckpPPIU0tyE3JbA4QcsjPO7CoFtUWZmFUBgkTuRkxputYEZBX1bTvHS0HHNqsExp6lRf8TD1YkBOyxqBaCN5YnEMNWqdCT8Dn+5Jeh4FCwME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b=lHUWIZmG; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Received: from 8bytes.org (p4ffe051a.dip0.t-ipconnect.de [79.254.5.26])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 64E6C1C0A37;
	Thu, 29 Jan 2026 11:46:25 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
	s=default; t=1769683585;
	bh=j5JwmiDsttfzg19wCJAsVxjUAiPWxASKMp4aK2rACgg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lHUWIZmGbkJdGY95uAJNREsTcSd1VTFZuKTx1drhJYbhKzzspYZxOWvoi/R4Tdjm3
	 LGrqb3p0JEkufGXBTP5rm2tBm9RD/EvwOd6adbioszBz0Uo00Kb0YQqNRYuAC+5l2l
	 1uNi2X8hFrLJm8HK7XGQle12gALM6HHP8DHDi9ieQIh54ib+WjDyo/Tz/SS+poUbOG
	 IKef6TbsgsTk9cThlj0rrLfAWuUoWNUKxJdeAaH6qHwBmocgFF6s33v4w0n44frv85
	 04MGS270dLrYLq/sYar+E0QooNSHZeX5cWg+Xp0tGvMUVGgWUTSGqWkHtE38NMmm5Y
	 kz8bjgfFxOQsA==
Date: Thu, 29 Jan 2026 11:46:24 +0100
From: =?utf-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>, 
	Helge Deller <deller@gmx.de>, Oliver Steffen <osteffen@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, Matias Ezequiel Vara Larsen <mvaralar@redhat.com>, 
	Kevin Wolf <kwolf@redhat.com>, German Maglione <gmaglione@redhat.com>, 
	Hanna Reitz <hreitz@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>, =?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>, 
	Thomas Huth <thuth@redhat.com>, danpb@redhat.com, 
	Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>, Alex Bennee <alex.bennee@linaro.org>, 
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: COCONUT-SVSM project ideas for GSoC 2026
Message-ID: <h4uue2ekbnlh26rylj4ilsqzyxdrfzrq7czleysrkbowlgp4q2@wtbm7zi4kev5>
References: <CAJSP0QVXXX7GV5W4nj7kP35x_4gbF2nG1G1jdh9Q=XgSx=nX3A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJSP0QVXXX7GV5W4nj7kP35x_4gbF2nG1G1jdh9Q=XgSx=nX3A@mail.gmail.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MIXED_CHARSET(1.00)[subject];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[8bytes.org:s=default];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DMARC_NA(0.00)[8bytes.org: no valid DMARC record];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[18];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-69532-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[8bytes.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joro@8bytes.org,kvm@vger.kernel.org];
	FREEMAIL_CC(0.00)[nongnu.org,vger.kernel.org,gmx.de,redhat.com,linaro.org,ilande.co.uk];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[8bytes.org:dkim,amd.com:url,amd.com:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,coconut-svsm.github.io:url]
X-Rspamd-Queue-Id: 709A5AF251
X-Rspamd-Action: no action

Hi Stefan,

Thanks a lot for running this and allowing the COCONUT-SVSM project to submit
ideas under the QEMU/KVM umbrella!

After some discussions in the community we came up with these two project ideas:

=== Observability Support for COCONUT-SVSM ===

'''Summary:''' Implement Support for COCONUT-SVSM Observability within the TEE

COCONUT-SVSM is a Secure Virtual machine Service Module that runs at a
privileged level within a Confidential Virtual Machine (CVM) to provide trusted
services, such as a virtual TPM, to the guest operating system, independent of
the host hypervisor.

The goal of the project is to implement support for observability of
COCONUT-SVSM from the guest OS. When finished the guest OS has a way to
fetch runtime metrics and data from the COCONUT-SVSM running within the same
TEE. Runtime data includes the log buffer, services logs, memory usage, and
possible future extensions.

The project consists of several parts:

1. Design an experimental SVSM observability protocol for exchanging metrics
   and data between COCONUT-SVSM and the Linux kernel. This protocol will be an
   extension of the SVSM protocol specification.
2. Implement a handler for the protocol within COCONUT-SVSM following the other
   protocols COCONUT-SVSM already implements.
3. Implement a Linux device driver which uses this protocol to get
   observability data from COCONUT-SVSM and make it accessible to Linux user-mode
   via a device file.
4. Implement a Linux user-space utility to fetch and save the observability
   data using the device driver.

'''Links:'''

* COCONUT-SVSM Repository: https://github.com/coconut-svsm/svsm/
* Development plan: https://coconut-svsm.github.io/svsm/developer/DEVELOPMENT-PLAN/#observability
* SVSM protocol specification: https://docs.amd.com/v/u/en-US/58019

'''Details:'''
Skill level: Intermediate
Language: Rust and C
Mentors: Stefano Garzarella <sgarzare@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>, Joerg Roedel <joerg.roedel@amd.com>

--->8---

=== Support X86 Process Context Identifiers (PCID) in COCONUT-SVSM ===

COCONUT-SVSM is a Secure Virtual machine Service Module that runs at a
privileged level within a Confidential Virtual Machine (CVM) to provide trusted
services, such as a virtual TPM, to the guest operating system, independent of
the host hypervisor.

The goal of the project is to enhance the COCONUT-SVSM kernel to make use of
the PCID feature on X86 to reduce the number of runtime TLB misses. The work
consists of several steps:

1. Implement generic CPUID feature enumeration support by building a code
   generator which automatically creates a Rust crate from the data provided by
   the X86-CPUID project. Use that generated crate in COCONUT-SVSM for
   detecting the PCID feature and clean up all the open coded CPUID checks.
2. Design and implement a PCID assignment strategy for tasks and threads in the
   COCONUT kernel.
3. Apply the PCIDs in the COCONUT page-tables and adapt the TLB flushing code
   to take PCIDs into account.

'''Links:'''
* AMD64 APM 2 (PCIDs, Section 5.5.1.): https://docs.amd.com/v/u/en-US/24593_3.43 
* X86 cpuid project: https://x86-cpuid.org/
* COCONUT-SVSM: https://github.com/coconut-svsm/svsm/

'''Details:'''
* Skill level: Intermediate
* Languages: Rust
* Mentors: Joerg Roedel <joerg.roedel@amd.com>, Luigi Leonardi <leonardi@redhat.com>

--->8---

Thanks,

	Joerg

