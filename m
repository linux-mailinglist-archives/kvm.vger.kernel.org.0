Return-Path: <kvm+bounces-70194-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +KNZFIBJg2m0kwMAu9opvQ
	(envelope-from <kvm+bounces-70194-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 14:28:32 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C108FE66AB
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 14:28:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A8DED30B06AF
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 13:24:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FC92374730;
	Wed,  4 Feb 2026 13:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b="c0t50Wdx"
X-Original-To: kvm@vger.kernel.org
Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBECE279334
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 13:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770211458; cv=none; b=kZ52+XO9qobXWyDIQ0n0rZPavi1/GzlFOpIdWibyYfsFkspG6gphwDgs1ywbssQmbVM4Tuqo+HvLxUUd/HBd+/dKfMUow4243zDECA+t4nYgdih84Ys+ywwKeiQ9gPtjL/o0EUxa2SPg8EhMm8bipEOeqVVMAiD2C5fO2B05xZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770211458; c=relaxed/simple;
	bh=FRKH0TLps0vsonu18O4EdSXiGx0M2rPwGxjmyx3YpLY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EU87vyAecdxCVTrUwrjiyV58lk7gEkcqQd/3NAn+BDApgK6nn98B6F7tj1bU6hudAaWfkTN5cOAp0kn1cr8TKOIeZIFl31H59/9xdfytlA7/1bUwVJSLX50dj+zB2qTGIgZND68O798IMRuutFLkGZ51VHPSqPK0Iku0DFeBNwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b=c0t50Wdx; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Received: from 8bytes.org (p200300f6af1d9600edf6ea9beaf0756d.dip0.t-ipconnect.de [IPv6:2003:f6:af1d:9600:edf6:ea9b:eaf0:756d])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 7127B1C1208;
	Wed,  4 Feb 2026 14:24:16 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
	s=default; t=1770211456;
	bh=FRKH0TLps0vsonu18O4EdSXiGx0M2rPwGxjmyx3YpLY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=c0t50Wdx+9Eff+RmrWSboFZgXTttpCbKcOhMi3Yw4V3/l9vLxpqnEx+5t3YREBu4C
	 KnGDqmPHF6kJO1eR38kEaUx2Ah7BjEfHmknAGdONc1t4ZSTp2ps00JNHbXsH1Php7z
	 uIdhxGTFS8YCG4R8HodUxzwXWLtd5BHfHpTj/to0iE3z2O4nrf8sxlM9kcjujDdC8v
	 1Gqxq0xYQdJF4JiE7QrSnKqqRb7RxTpKb3x6yOzPR1cSWbrzu3mRgyx0UGhlG/bxgx
	 khPWQtbFYvGlyCrosrMaWfW3lU3j26F59MNU8Ivm8kFFOtIqAExCGGhblJC9YPDy4j
	 e0rJM4+FZbx7A==
Date: Wed, 4 Feb 2026 14:24:15 +0100
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
Subject: Re: COCONUT-SVSM project ideas for GSoC 2026
Message-ID: <2dzs6ukw6gwndluqlzarsmrueug5t7vtic6toxs74k2zewrzwe@337u533iprja>
References: <CAJSP0QVXXX7GV5W4nj7kP35x_4gbF2nG1G1jdh9Q=XgSx=nX3A@mail.gmail.com>
 <h4uue2ekbnlh26rylj4ilsqzyxdrfzrq7czleysrkbowlgp4q2@wtbm7zi4kev5>
 <CAJSP0QXu+fmKuOKLw=OXL0GqTQS58pM_-REtnnOCiSaZJp9=LQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJSP0QXu+fmKuOKLw=OXL0GqTQS58pM_-REtnnOCiSaZJp9=LQ@mail.gmail.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.25 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MIXED_CHARSET(0.91)[subject];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
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
	TAGGED_FROM(0.00)[bounces-70194-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[8bytes.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joro@8bytes.org,kvm@vger.kernel.org];
	FREEMAIL_CC(0.00)[nongnu.org,vger.kernel.org,gmx.de,redhat.com,linaro.org,ilande.co.uk];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[8bytes.org:dkim,coconut-svsm.github.io:url,amd.com:url,amd.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C108FE66AB
X-Rspamd-Action: no action

Hi Stefan,

On Thu, Jan 29, 2026 at 09:18:15AM -0500, Stefan Hajnoczi wrote:
> I think the mentors should provide the extension to the SVSM protocol
> specification. That way the intern can start the coding period by
> diving straight into the implementation and there is no risk that the
> project is held up because the community does not like the design.

Thanks a lot for your feedback. You are right the the project as described is
too big for GSoC.

So we settled on defining the protocol on our own before GSoC starts and
provide it to the student. Updated proposal below:

--->8---
=== Observability Support for COCONUT-SVSM ===

'''Summary:''' Implement Support for COCONUT-SVSM Observability within the TEE

COCONUT-SVSM is a Secure Virtual machine Service Module that runs at a
privileged level within a Confidential Virtual Machine (CVM) to provide trusted
services, such as a virtual TPM, to the guest operating system, independent of
the host hypervisor.

The goal of the project is to implement basic support for observability
of COCONUT-SVSM from the guest OS. When finished the guest OS has a way
to fetch runtime metrics and data from the COCONUT-SVSM running within
the same TEE. Runtime data includes the log buffer, memory usage, and
possible future extensions.

The project consists of several parts:

1. Implement a handler for the pre-defined SVSM observability protocol
   within COCONUT-SVSM following the other protocols COCONUT-SVSM
   already implements.
2. Implement a Linux device driver which uses this protocol to get
   observability data from COCONUT-SVSM and make it accessible to Linux user-mode
   via a device file.
3. Implement a Linux user-space utility to fetch and save the observability
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

-Joerg

