Return-Path: <kvm+bounces-69549-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qEeAHIdse2mMEgIAu9opvQ
	(envelope-from <kvm+bounces-69549-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 15:19:51 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EBDF4B0DA6
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 15:19:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 157DE3045218
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 14:18:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA0AB1F9F70;
	Thu, 29 Jan 2026 14:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UVwacV6Z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E335205E02
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 14:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769696311; cv=pass; b=dvic+ha50DP/6Rf+riBC3ECDUpS8GOMLs3sjxZCbmtUzjChEC0rXXDadmKvkx3qhqG0lxefX2x58cjhjnzuwGgWSg+IsrDLGuWzyojKZbo9cZZgTLZCbz8ENWecJSLCqjzmOFeK5Ww7SFhFrPkwNl58eN6FwJf/Rzohlk4zF7Hw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769696311; c=relaxed/simple;
	bh=vce4dqLjXlqAl9DXU/EqxyIWo+CV5wfg5arvnfD0Df0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XuGfNeTmQUmsTUnb5zu0inwRCCZtlful6W1B4O3lGo6ZseE/js7O8+ljolhYxJ+/NPgM5aD/DL8LEXMKHAtvle2Du/Lnqc4p2SRPNLUDfpuMftuAoBJZ4Hh5q9pa/19oe5gif/m1OjZ9cUtfMcblawWxMJRshY5z4CpQsbqOD/0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UVwacV6Z; arc=pass smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b8d7f22d405so176068366b.0
        for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 06:18:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769696307; cv=none;
        d=google.com; s=arc-20240605;
        b=T2Depx9VFcjgLXbqZALqp5j55ie6/LqDDuplnHtkX8h9u4D+x/ujewJ4OXBApTxP8c
         Mmi5Xf3v1SbL9iun3G1yFxp7JXzibFu73WZMzYDZp1eX88Vs8OuPtXu6cv2XP6wva7m6
         4GOpTrkq3p19sxvfdVbx2R+rbAT7RjuVAfhrpSTcaQFEFS4TXbbe0C2RAjH3MAtiP96C
         3y/8ER5SxSNbk7YBjuxIvBBoxCsQJDDEXUyq9euj4ye60znf31kQZrbGt+vKzFE0iOs0
         IU0yGFYL/7A71aFOv0H45XlUdfGu6p/GM1laSW11Ou8y+N15J/L4mj/o0vHrhLxSuLQg
         gA+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UEKVTrz8YDzYQ5uy4I6bYgzbq3mb2bYtUnu63D5lJFw=;
        fh=UA29p/A5d8jNyGrAwZ72Of9bcziLiouh0sPv2DP0uZ8=;
        b=lbbAeZZ1W0AtFe91VUbECBmH7hrvL7qe27Mkjg9on0WPv0X+1T4E/i3IXWO/wQwehs
         wwzEr0EI7/PvweFcMsk3MZh6tShck2w6MIHmPYO+BXgGRQOEeqlHp6wuc/ys0Lo2nSBo
         3CrozuOItuSwSZA+gFoxBi8nENBF7KL8S0tPI3UGICAC6MqQaTH58kHqZto7MKP0CyOt
         dAKHbMBOzVsp091BZt5hScSOnYMaPpuXaYHYjyfsc89haSp/HJsitJFeFRfVeIsAWFpp
         wllxyOKhhDpfTRCB/x/BPKXnuYG3F+LDYUQUzCcMaM/c+w1XfnEXHrmMrsksmAFLRkum
         IyIg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769696307; x=1770301107; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UEKVTrz8YDzYQ5uy4I6bYgzbq3mb2bYtUnu63D5lJFw=;
        b=UVwacV6ZtRZTB/jNIkKQ9miQohXHs1cS+yTm5n0B8ZLS4GIouetOgjy28a/FFsnxgo
         vtJfXtbAjfsNElsKg07cWXne/QBi2D6odyvMrjE93Z9ArFz3TinwK4YW9FJ0k8tmvKhe
         v3fVoxjxsGkEYoWELKnFatxaagpADMC0TSigjC0I6UnqtOQHay2BYgbHXwYhbA+NQ7bw
         Ivx4GGC4zz7oNeeFtxeKFQkxvYkA3gi6JSJrhM5EcaPJ57xSM0AH85v6YaH1DjNsjuV8
         VRsKLQLounr3isPh+RF8b8yrEcEbwUUYElXLLWsbrbGUdY/esQjUJjv1ERA30JDsVGC4
         dTrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769696307; x=1770301107;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UEKVTrz8YDzYQ5uy4I6bYgzbq3mb2bYtUnu63D5lJFw=;
        b=Xr9uQtMgVESZdg7hUOcNYAtESUUEkP/E9qlkD9KrYBzspAuZKLoNBnA3iAaN2POiNA
         pOctuEN08BDhcJ4lPG80USuxH+Z8HWRn6uIy8WD9p50BEtgaBt2bee9gLoGA6NVjRnmk
         R0gAjzUjsNb6bKIb3Yy++sGjgXK5goyy5N3V5r2R/IFt6LhormKnVf6fGWLXgowo65ak
         TnbGelqjc84RPXOtNmiZuY8jwdCWTrzDjH5kJk3VZG9stGi0wqMgclpQqWHjfwse1Lkp
         /7721K3eGhfcmU27VA0bL1C1KNNFi+wHao47byu4lNZpm0qivbVDQ0exd6kQPuSo/YWe
         ZKWg==
X-Forwarded-Encrypted: i=1; AJvYcCUqX79zPCgGt5NbCnvgZnNoH3THW0ou48xwLayGYyDlvTLf/NB60VlxgJmf/nq1MjHk+z0=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywz9AqhGm+1iekKhw+a3MaIv63F6AiXG8rq1zSNcfdfsE4CzEyr
	2zMTYLyA7k3T1MIKB5lthY+iiLGMocVqUpxWAG6eoUTIs733DGVdUDiWz2N+qbQrOqP8pTM87K8
	Co3dE1sNTSkGvM/j90EF/uPCoawk3iGk=
X-Gm-Gg: AZuq6aL/i4GU7xcjxkp6H4IxC0psqTs84ZrnYMcyUFQkgTh98EooABMqxpwWneQNyue
	ifIo4xueD0WqMMSYfSml4JsdjXXMWjfUauwYY9pWPHzITQedYtecCwK+ejktS/S/9uyzPVWf24B
	acndSnGl0Tk7P+4l4+aQopHU3CV1BDrVWJ5ChZAMX4wu0FBwznoXKyk2D/TAiMB+694nCiUr4S0
	IBuyrwj/hXkwdAoUPYewIhjkwMxCdQt/j8fnsFVGCkPql/ku32sfnO4TYV/9ZhbV9i4og==
X-Received: by 2002:a17:907:e10d:b0:b8d:bf4d:7463 with SMTP id
 a640c23a62f3a-b8dbf4d7744mr381360466b.31.1769696307330; Thu, 29 Jan 2026
 06:18:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJSP0QVXXX7GV5W4nj7kP35x_4gbF2nG1G1jdh9Q=XgSx=nX3A@mail.gmail.com>
 <h4uue2ekbnlh26rylj4ilsqzyxdrfzrq7czleysrkbowlgp4q2@wtbm7zi4kev5>
In-Reply-To: <h4uue2ekbnlh26rylj4ilsqzyxdrfzrq7czleysrkbowlgp4q2@wtbm7zi4kev5>
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Thu, 29 Jan 2026 09:18:15 -0500
X-Gm-Features: AZwV_QhexZCjxjmezZkXhv3H1W9i2wH_EGc7JcvsAPFpTbcdb_piPNOES6YaEUo
Message-ID: <CAJSP0QXu+fmKuOKLw=OXL0GqTQS58pM_-REtnnOCiSaZJp9=LQ@mail.gmail.com>
Subject: Re: COCONUT-SVSM project ideas for GSoC 2026
To: =?UTF-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>
Cc: qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>, 
	Helge Deller <deller@gmx.de>, Oliver Steffen <osteffen@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, Matias Ezequiel Vara Larsen <mvaralar@redhat.com>, Kevin Wolf <kwolf@redhat.com>, 
	German Maglione <gmaglione@redhat.com>, Hanna Reitz <hreitz@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	=?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, 
	Thomas Huth <thuth@redhat.com>, danpb@redhat.com, 
	Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>, Alex Bennee <alex.bennee@linaro.org>, 
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69549-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[nongnu.org,vger.kernel.org,gmx.de,redhat.com,linaro.org,ilande.co.uk];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[18];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[stefanha@gmail.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[8bytes.org:email,amd.com:url,amd.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,coconut-svsm.github.io:url,mail.gmail.com:mid,x86-cpuid.org:url]
X-Rspamd-Queue-Id: EBDF4B0DA6
X-Rspamd-Action: no action

On Thu, Jan 29, 2026 at 5:46=E2=80=AFAM J=C3=B6rg R=C3=B6del <joro@8bytes.o=
rg> wrote:
>
> Hi Stefan,
>
> Thanks a lot for running this and allowing the COCONUT-SVSM project to su=
bmit
> ideas under the QEMU/KVM umbrella!
>

Welcome!

> After some discussions in the community we came up with these two project=
 ideas:
>
> =3D=3D=3D Observability Support for COCONUT-SVSM =3D=3D=3D
>
> '''Summary:''' Implement Support for COCONUT-SVSM Observability within th=
e TEE
>
> COCONUT-SVSM is a Secure Virtual machine Service Module that runs at a
> privileged level within a Confidential Virtual Machine (CVM) to provide t=
rusted
> services, such as a virtual TPM, to the guest operating system, independe=
nt of
> the host hypervisor.
>
> The goal of the project is to implement support for observability of
> COCONUT-SVSM from the guest OS. When finished the guest OS has a way to
> fetch runtime metrics and data from the COCONUT-SVSM running within the s=
ame
> TEE. Runtime data includes the log buffer, services logs, memory usage, a=
nd
> possible future extensions.
>
> The project consists of several parts:
>
> 1. Design an experimental SVSM observability protocol for exchanging metr=
ics
>    and data between COCONUT-SVSM and the Linux kernel. This protocol will=
 be an
>    extension of the SVSM protocol specification.

Interns have 12 weeks for the project. Usually this does not leave
enough time for the intern to propose a design and reach consensus
with the community. Keep in mind they may not have much background in
COCONUT-SVSM, so it will be challenging for them to come up with a
design.

I think the mentors should provide the extension to the SVSM protocol
specification. That way the intern can start the coding period by
diving straight into the implementation and there is no risk that the
project is held up because the community does not like the design.

> 2. Implement a handler for the protocol within COCONUT-SVSM following the=
 other
>    protocols COCONUT-SVSM already implements.
> 3. Implement a Linux device driver which uses this protocol to get
>    observability data from COCONUT-SVSM and make it accessible to Linux u=
ser-mode
>    via a device file.
> 4. Implement a Linux user-space utility to fetch and save the observabili=
ty
>    data using the device driver.

2, 3, and 4 together are a significant amount of work. I think it
would help to provide more details on what the interfaces look like.
Sketch out the command-line interface for the Linux user-space
utility, a Linux chardev (ioctl?) or sysfs interface that you would
like to see, etc. These details should probably go in the development
plan linked below on the COCONUT-SVSM website.

>
> '''Links:'''
>
> * COCONUT-SVSM Repository: https://github.com/coconut-svsm/svsm/
> * Development plan: https://coconut-svsm.github.io/svsm/developer/DEVELOP=
MENT-PLAN/#observability
> * SVSM protocol specification: https://docs.amd.com/v/u/en-US/58019
>
> '''Details:'''
> Skill level: Intermediate
> Language: Rust and C
> Mentors: Stefano Garzarella <sgarzare@redhat.com>, Gerd Hoffmann <kraxel@=
redhat.com>, Joerg Roedel <joerg.roedel@amd.com>

Nice project idea. It's large but incremental, so even if the intern
doesn't complete everything, it will be possible to merge the finished
parts.

>
> --->8---
>
> =3D=3D=3D Support X86 Process Context Identifiers (PCID) in COCONUT-SVSM =
=3D=3D=3D
>
> COCONUT-SVSM is a Secure Virtual machine Service Module that runs at a
> privileged level within a Confidential Virtual Machine (CVM) to provide t=
rusted
> services, such as a virtual TPM, to the guest operating system, independe=
nt of
> the host hypervisor.
>
> The goal of the project is to enhance the COCONUT-SVSM kernel to make use=
 of
> the PCID feature on X86 to reduce the number of runtime TLB misses. The w=
ork
> consists of several steps:
>
> 1. Implement generic CPUID feature enumeration support by building a code
>    generator which automatically creates a Rust crate from the data provi=
ded by
>    the X86-CPUID project. Use that generated crate in COCONUT-SVSM for
>    detecting the PCID feature and clean up all the open coded CPUID check=
s.
> 2. Design and implement a PCID assignment strategy for tasks and threads =
in the
>    COCONUT kernel.
> 3. Apply the PCIDs in the COCONUT page-tables and adapt the TLB flushing =
code
>    to take PCIDs into account.
>
> '''Links:'''
> * AMD64 APM 2 (PCIDs, Section 5.5.1.): https://docs.amd.com/v/u/en-US/245=
93_3.43
> * X86 cpuid project: https://x86-cpuid.org/
> * COCONUT-SVSM: https://github.com/coconut-svsm/svsm/
>
> '''Details:'''
> * Skill level: Intermediate
> * Languages: Rust
> * Mentors: Joerg Roedel <joerg.roedel@amd.com>, Luigi Leonardi <leonardi@=
redhat.com>

I have added this one to the wiki. Thank you!

https://wiki.qemu.org/Google_Summer_of_Code_2026#Support_X86_Process_Contex=
t_Identifiers_(PCID)_in_COCONUT-SVSM

Stefan

