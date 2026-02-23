Return-Path: <kvm+bounces-71523-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8KrEGFWjnGnqJgQAu9opvQ
	(envelope-from <kvm+bounces-71523-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 19:58:29 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9108517BEB8
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 19:58:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 1265C3026BE7
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 18:57:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B712B369986;
	Mon, 23 Feb 2026 18:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KkN7aB0L"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9815757EA
	for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 18:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771873070; cv=pass; b=c0TVmE/iBbfJvXN8HmyzJfKZ0VrRlYeAg8ZxQgzATfn6FFi0F+xjdx7MgCkh5jpl3oBckStBAkr/fsZ3FXBx0UadSS1VNoY9eXm6uE6Ukt754Moey+3+SP5QBer+RYgOcuj+wZIsYI6X9jtqRn/PRO3tHqVdyds8DBonXuHY4Lg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771873070; c=relaxed/simple;
	bh=OFD6NUQfqB5lbYiIMDtP4O+JDI3QL0PIMq1HidCRagY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=L58CZIIfzdWrQnSSGLhMh15BX/mu9PDXM5YYkFRSJE6PEm156thL4W7RgOEDc558BpOGHzV8iZBN7gVLqahiXSz9vTFLDqrV76SgF7dbHC5/aHsPX1XivKO4G1hhnALXwaBPYNqBKt7ztdbWSYi8iWpsIZNg9RCatoD4akDFrZc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KkN7aB0L; arc=pass smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-387090ae5b1so38480391fa.0
        for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 10:57:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771873067; cv=none;
        d=google.com; s=arc-20240605;
        b=a8U3daYAeM8pGqBiDTXroMF2Oeh3fAuB3gkcGysyi6dzFaGIeDO2itmxtq65AG3vsI
         Jmwo9xjNnne4BlG0lIScOejO9wn0wwnCYLaCLkBE2fcgTTs1S7gsBA+jL4IhysP6ndBp
         5x2tvJk6uBpamxGPhPCyroozEC4ToycXxiKvaymOItDCfbw3z/5lPUqVQ60Zv7jK+Yeh
         XghBEl+HHiPM9OEhzp3qoAGKoGVY43fOqI/vwH6SZYfAdizrv/R35IQU77RbBhtwqeo5
         ig0rZwqtGoUAdOUirzvhvIs3bMjcmKY5Xd354pbZatQZZetHg5kCi7nnf92evdKVJnYs
         0rNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=f/DOHd9CpHSCbT+LNTCI9j3eLuodht0W+GmwsJ9Rdho=;
        fh=taucWeXNrpHP8w3rz8uV/tgRcLevKdP43Y42YElpY0c=;
        b=Tjvuv1ZVZX9hSfmk4aZcZKzanNUiPZKuk0j6XtrrQRqrbnuQjom8KlBBSAjTVPupQi
         OgxTOqcrsvoEXbFAIquzWW7zM0g8TAzji3kYauOBNatRsmHsnFdwI2q3vTWioZhblbOl
         tokk/ioVQokW175UCzmbvy2icTaf0wcdg8NxSPgSW2Mhrv9wYgx3xLw8m8GKRhtc2gP8
         jYrbs/jXLDiXNXYK9TmM4BnyYP5XGZSdWFFFNb2IvKy+dVaMjwvQ2duxc4R5KwtpgXJj
         I7DXxrcebLBcl3u1RJQhRhZtgfFH2AfmyzAyYrtqWQcsA3Iwv0S9zWXY5nhm/3aBvifn
         So2g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771873067; x=1772477867; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f/DOHd9CpHSCbT+LNTCI9j3eLuodht0W+GmwsJ9Rdho=;
        b=KkN7aB0Lm3o5t+ZSRyBfZCwkma3MzZHGLYKLC36yHNQfJiI5wpk1Ebkyz9jk+gK2MQ
         Qf1jGp0KESdGIUmpXX4nzYyHJt8wNbTeckQKRSOHwIEXpjI7zJFIkkWWVudo49IaawY1
         /pdlkJQiytGHkPIWQ5kW/H76sAnLRFyR8J2tmBcCLJ/5JUdA9CUxiB0uhlDnRl0tcDxs
         80x0uy358sFit2bPsyblqtxmS03qFlpXXBoHyaCVYuis5P1C2Vt2KaXbXmcwTXs+q4Az
         rzXo43SEALJz2uwCR2vfeFOz9zPDshzzJ4MKOHKdREsfqEZ+5GBoiY0JBijA/gKn6ot4
         p4Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771873067; x=1772477867;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=f/DOHd9CpHSCbT+LNTCI9j3eLuodht0W+GmwsJ9Rdho=;
        b=EpLgNqHj5g5pqKtCZ1KovJg5OZKHGMdhnX87GJFFgns2NdY+kDsajfD96ExAJBqIoF
         iQTDOOk2jm6IYtgbGYblaLgRZMun8O773gCvHuudibGYEebTRGur4oWUh1tmxaHpVQLf
         VIQuw/HVdNYQ4S+uKRuUpYCi3vcBxt1517vfhS9c77dIpw9i+NqGNJZhDlaNRsculEyd
         911qBvqj/gcpTVXCO4NyEPyufa9dRhStyscOMo7OFSZdwSigOf1asQdWxALZxhjhuBIc
         iQX7KoBxsWGiYu7Ku/ZZ5wraJZqql7FCW2Bnowd23lXgGE4KSimjEh7jIVl+tuX5rb7B
         bqLw==
X-Forwarded-Encrypted: i=1; AJvYcCUc1ezEtLgafuZaF9XJ47MpsSi3fyDekAWg9mHgCf4pp7rIgVPyXPuEqjz+a5hw5rvsK+g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7I67TXoAOtbj6EkONj8qDpm2+GOTE8zIdzLDBWqNUuzAGkl6l
	vxzO13L5osPlIUr+YpsCRhkVPmTmvWK+XPIh9tPI/G0ALuw/5afEMtPWbOl+IV9zDIbbJMb90jv
	FOVYvhAJmLL0hYmfo0xPatCHU3UqqubyKyelq2Nt+
X-Gm-Gg: ATEYQzwUQMfAMljFAZ1QVSI9UgkRa91clTTRJfDveXrUZJOcEhXEhz1C5cPNlnp1pp8
	dYzjZwPUMMIl5JhaBD8tvyzRmacDKe5KqajzGSG14bpKQsd40BOGgJwmcndPz+SL4yjoRB9Lja3
	9s9WwANf/yoViMhtUb8pTUfPqM3XPyKHoFufFJYhkV8/GRxftweneo9P60FF/tEhpAM7yMttsel
	Bqdh6v0MQI+ODXUHBq3z4Tut0hCfO2klG+ebOhcTLEiajWls8O2+new4xv+iLNNF7Dh85rLJlLY
	fPqOtSiAPX2b9wQUIg==
X-Received: by 2002:a05:651c:41c7:b0:383:1b4b:c2c8 with SMTP id
 38308e7fff4ca-389a5e8e30bmr24927701fa.41.1771873066594; Mon, 23 Feb 2026
 10:57:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251210181417.3677674-1-rananta@google.com> <20251210181417.3677674-7-rananta@google.com>
 <aUSNoBzvybi24SUD@google.com> <CAJHc60zAB8pyc7=ca=eOf+SEEvnZ3JxVEnZoOtgj+mX1GQiALw@mail.gmail.com>
 <aYUQ_HkDJU9kjsUl@google.com>
In-Reply-To: <aYUQ_HkDJU9kjsUl@google.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 23 Feb 2026 10:57:18 -0800
X-Gm-Features: AaiRm51xsX0sj5UKMqLZlpyRZUJezvA_WLsNNCIJwPOLAaI4oJzjAEfrZMVWw2o
Message-ID: <CALzav=fBjW5zN+oOc61ZB69N1dRPFEuYJH=YsD9jYmqwXkKeAA@mail.gmail.com>
Subject: Re: [PATCH v2 6/6] vfio: selftests: Add tests to validate SR-IOV UAPI
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Alex Williamson <alex@shazbot.org>, Alex Williamson <alex.williamson@redhat.com>, 
	Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	iommu@lists.linux.dev, Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org, 
	David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
	Samiullah Khawaja <skhawaja@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71523-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dmatlack@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 9108517BEB8
X-Rspamd-Action: no action

On Thu, Feb 5, 2026 at 1:52=E2=80=AFPM David Matlack <dmatlack@google.com> =
wrote:
> On 2026-01-06 11:47 AM, Raghavendra Rao Ananta wrote:
> > On Thu, Dec 18, 2025 at 3:26=E2=80=AFPM David Matlack <dmatlack@google.=
com> wrote:
> > > [  574.857650][T27935] BUG: kernel NULL pointer dereference, address:=
 0000000000000008
...
> > > [  575.009753][T27935] Call Trace:
> > > [  575.012919][T27935]  <TASK>
> > > [  575.015730][T27935]  intel_iommu_probe_device+0x4c9/0x7b0
> > > [  575.021153][T27935]  __iommu_probe_device+0x101/0x4c0
> > > [  575.026231][T27935]  iommu_bus_notifier+0x37/0x100
> > > [  575.031046][T27935]  blocking_notifier_call_chain+0x53/0xd0
> > > [  575.036634][T27935]  bus_notify+0x99/0xc0
> > > [  575.040666][T27935]  device_add+0x252/0x470
> > > [  575.044872][T27935]  pci_device_add+0x414/0x5c0
> > > [  575.049429][T27935]  pci_iov_add_virtfn+0x2f2/0x3e0
> > > [  575.054326][T27935]  sriov_add_vfs+0x33/0x70
> > > [  575.058613][T27935]  sriov_enable+0x2fc/0x490
> > > [  575.062992][T27935]  vfio_pci_core_sriov_configure+0x16c/0x210
> > > [  575.068843][T27935]  sriov_numvfs_store+0xc4/0x190
> > > [  575.073652][T27935]  kernfs_fop_write_iter+0xfe/0x180
> > > [  575.078724][T27935]  vfs_write+0x2d0/0x430
> > > [  575.082846][T27935]  ksys_write+0x7f/0x100
> > > [  575.086965][T27935]  do_syscall_64+0x6f/0x940
> > > [  575.091339][T27935]  ? arch_exit_to_user_mode_prepare+0x9/0xb0
> > > [  575.097193][T27935]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
>
> I think this is a use-after-free.

Fix proposed here:
https://lore.kernel.org/linux-pci/20260223184017.688212-1-dmatlack@google.c=
om/

