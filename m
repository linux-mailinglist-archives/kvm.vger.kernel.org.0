Return-Path: <kvm+bounces-73337-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sExaIVkEr2knLwIAu9opvQ
	(envelope-from <kvm+bounces-73337-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 18:33:13 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B7C723DAAC
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 18:33:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BDBEE3013875
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 17:33:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C8022F12A1;
	Mon,  9 Mar 2026 17:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BOqnSEKX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFD292BDC2C
	for <kvm@vger.kernel.org>; Mon,  9 Mar 2026 17:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773077577; cv=pass; b=a6FFbRanrmBFA1NaX1jWU9+JaKkzE81zXbvVZqUJ2cHuVS/uUCxXHIRNQqfXatr4plEtX7IUnuwFICQperfy8FJbTJkfsYr+qXWtPYq7kzT26hofToWMaHMTCe8rX0mVuWO4U5FkwKq2zsFCfw/I1RMqCwkj6Yhe2SvKtHIFYdI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773077577; c=relaxed/simple;
	bh=UzbVfxnpIrUZlx5xzEFDYneUs+jd4yOAM+H/ydSkGnk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HWkV0m9kUdwQB45yrcesu9mBrkzsIC7tOnRtl0Y0BQP5gZtvdZT8aWEstWDR4zdy7KWOJl19+j9pOfORJdiNNX0gjZgcsc6Wh5Eh++bBZVnJGjGkS2ZhBxMAgqPo/DhqGDBaWP8KJ54OJ8keQzdc05ueGDAbohFt93KV/7pv1iM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BOqnSEKX; arc=pass smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5a0fc5e2c59so7900183e87.1
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2026 10:32:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773077574; cv=none;
        d=google.com; s=arc-20240605;
        b=AXSGsurKDumg9jnHqQUWtHLh8LBWzIveXnoS7giWbX/gPv3fVE+5NBYpcms1iE0Rqm
         /A6NBbfZw0KT+pSubqLO+pPpjzNv2W+tfeqb25W7NrBAv8Wx/dJmB+1Xlfwy8hqMXB6Z
         +CLr4pdBnL9NK93OY+J3ff/z3HOxIVY49ZE+cygaUZW08gQqZJ5DVijbIkgpWA93bdpt
         bA0wL2/cxSY7UPxoRayufvtSAHTWMeu8zk6DKacde71vulkdeRE5T5iVfdjMu8LUyuJ0
         vA4FgoxK1XyyO7fVEBnfaH6YrDr7X+BLXXZHn6DxLqLBCXV7J6ACq2RmDqSsDkzTObB0
         726A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mL+d40KjyhuL+4bMpXUsYaQzeUUDZaEOQ6AdzLVzNPg=;
        fh=X0s6vBZ2hSOFbzr0JTrNSEv+QR/70dQ4nr7w8bME/LI=;
        b=EFU6LN7ypjBgmaYz7LumiFDGUE5Iqpd2Zyty3+AcaD4vgpOi501f/qzKrBXT883juz
         6erhyj0m9m4jIkqiwyyl1h5CcPqbyei9UA8trgarBpizKM/iYfxnS+dqofDoglT6rjog
         ciTz52FmdfMZJ/mVZWi+ZAqiyIRVus7r2q+R/5DJ1tWFoiCTK6qTHLQAiWBgfKpz84BW
         hm9WoV06GHymCv1XgiTgP7iWVOu5U89PpTUxCQhFbIpLkXRg3Tn8T9sRoju6bSMNrs9M
         CGxLIAv1RICulwaafG36QqHtfZBGJxgvgYCV8JA7C2t/JQkP6xpV+nWKR1trsDc5rRUt
         8vaA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773077574; x=1773682374; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mL+d40KjyhuL+4bMpXUsYaQzeUUDZaEOQ6AdzLVzNPg=;
        b=BOqnSEKXUTbxSDH9TGikZ9vPUeq1YbVH2M4vnF6ofADIMO3AXxAhideB7H2xb8DqCd
         nW/+X93/6a4U2mz8iJEiRMNYSfA1UtCJCn5e5M7hm+yRTZHkT7HgVL5W98GrqnT4URxi
         kWpClKHjsRtCTfXVRdKyIsn3LMAC/6oNbcCMmt6NZd6q8/aF8OBKgaLSGGfZHI2Falg8
         SwbNG7WNM0Unw4TFKK3ZaRZgklVCY9rMocJJ17TrGshvEC2WJk9ZsUStHJH6hOEQieaQ
         CRXOGIvCsGgXQ4PRx4gvuJbqcAF6ruDgGXBMVYgRrofZqpMrF/VMbezUX+TvRBLpjWNq
         Q5pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773077574; x=1773682374;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mL+d40KjyhuL+4bMpXUsYaQzeUUDZaEOQ6AdzLVzNPg=;
        b=Jp+m/gGtWrZ4vI2s8tSZCylL0OEDiUr9h+uGSMdekwg8KdRAFB6QZUeEE/mUCbGznk
         /ncjvDzkrj1/51SZDmXUWAlzFZenC2Gd3OcWuT3eNOlsiBIGOb1WLRCjr8vKZ8StDT9B
         H3oITok0MHNBiYk6x013Efl8kRLzXPMzLyZJTsLKi5d6GnIEjcOercubDQ8wx23GyL/1
         4e43dIre4IJ2fbZRnT3RsMRWOf8qDbVwN+f1Aq3VUIsmjKGkxmTEe3LsepHm9hQUHE3P
         RLxRUCtWPbfTokeIDh+8hmcGr9gWruF2xNKL+OokM+SelFjahiRNV0zIwolK8e6l2FnW
         JnLg==
X-Forwarded-Encrypted: i=1; AJvYcCX+h+fVjX/rcRnYDnQW6ZX7InHFb53SvGklFhlCx2lBBmct4yfdnJC2tKPSlltS5XR1QHE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzexEhCRItPLkBnS9M7+fOgICPStiafHMmAB18sdpdW7z1B/VJb
	dIF/zxEtH7Ja0EQ8Mz3cyCm5cLN4JlQ/Gc1521reiznMqK9weQhRogxCKAL2NZYt1gsLIPbdk+n
	YHVPo4ZozX+CXlgApDe6Oqdz9gAZesi/N35JRXJKQ
X-Gm-Gg: ATEYQzxkxZmoZsjVVFaKmDba5IG9HOxyTSFIZygM26Hn1dC5rnUiHqSabAw0iHBGe2e
	wR1KoFHWORlKRVo9pkzH17nIP/mbUWCW2Yk2Ph/JCK21kVU919dDiHC/9uCdK4QSZSUmX/KjMmJ
	XisFPWATe5SuA09BrpFWsgJfV4BBzPaHRqjs3XROSdYKXhnkYxW6n0DFl8FsE3epxlSJ3q3nsxp
	4u2vMFVM3vLxqen7uTEdo+ToOLbvjPsgBIGjY3fuPTeiq1shO6xPL/w0FKTlAbOuzL1bJqEYRwI
	6Gm+hzyl
X-Received: by 2002:a2e:9e89:0:b0:389:fc6b:943f with SMTP id
 38308e7fff4ca-38a40b72dbbmr31791631fa.11.1773077573745; Mon, 09 Mar 2026
 10:32:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com> <20260129212510.967611-11-dmatlack@google.com>
 <20260226170030.5a938c74@shazbot.org> <aaDqhjdLyf1qSTSh@google.com>
 <20260227084658.3767d801@shazbot.org> <CALzav=fHy23RAzhgkdaL+JA5T2tL9FT6aPgRfXUh7i9zvYCGPA@mail.gmail.com>
 <20260227105720.522ca97f@shazbot.org>
In-Reply-To: <20260227105720.522ca97f@shazbot.org>
From: David Matlack <dmatlack@google.com>
Date: Mon, 9 Mar 2026 10:32:25 -0700
X-Gm-Features: AaiRm51UQkPGi_THgF8Q61sl9tHSSk61beTImuWL9a-lckj5dJAcnYvj7LG9bmc
Message-ID: <CALzav=fjRPa_ZbXu7iFXyemcf_8Kq_dZTWT6c-A0bc6czF_Rdw@mail.gmail.com>
Subject: Re: [PATCH v2 10/22] vfio/pci: Skip reset of preserved device after
 Live Update
To: Alex Williamson <alex@shazbot.org>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Mastro <amastro@fb.com>, Alistair Popple <apopple@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Ankit Agrawal <ankita@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Rientjes <rientjes@google.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Hilke <jrhilke@google.com>, Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org, 
	kvm@vger.kernel.org, Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, 
	=?UTF-8?Q?Micha=C5=82_Winiarski?= <michal.winiarski@intel.com>, 
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>, 
	Rodrigo Vivi <rodrigo.vivi@intel.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	=?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
	Tomita Moeko <tomitamoeko@gmail.com>, Vipin Sharma <vipinsh@google.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 2B7C723DAAC
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73337-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[nvidia.com,amazon.com,fb.com,linux-foundation.org,google.com,kernel.org,linux.microsoft.com,ziepe.ca,lwn.net,intel.com,lists.infradead.org,vger.kernel.org,kvack.org,wunner.de,soleen.com,linuxfoundation.org,linux.intel.com,gmail.com,linux.dev];
	RCPT_COUNT_TWELVE(0.00)[44];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dmatlack@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,shazbot.org:email]
X-Rspamd-Action: no action

On Fri, Feb 27, 2026 at 9:57=E2=80=AFAM Alex Williamson <alex@shazbot.org> =
wrote:
>
> On Fri, 27 Feb 2026 09:07:48 -0800
> David Matlack <dmatlack@google.com> wrote:
>
> > On Fri, Feb 27, 2026 at 7:47=E2=80=AFAM Alex Williamson <alex@shazbot.o=
rg> wrote:
> > >
> > > On Fri, 27 Feb 2026 00:51:18 +0000
> > > David Matlack <dmatlack@google.com> wrote:
> > >
> > > > On 2026-02-26 05:00 PM, Alex Williamson wrote:
> > > > > On Thu, 29 Jan 2026 21:24:57 +0000
> > > > > David Matlack <dmatlack@google.com> wrote:
> > > > > >
> > > > > > - vdev->reset_works =3D !ret;
> > > > > >   pci_save_state(pdev);
> > > > > >   vdev->pci_saved_state =3D pci_store_saved_state(pdev);
> > > > >
> > > > > Isn't this a problem too?  In the first kernel we store the initi=
al,
> > > > > post reset state of the device, now we're storing some arbitrary =
state.
> > > > > This is the state we're restore when the device is closed.
> > > >
> > > > The previous kernel resets the device and restores it back to its
> > > > post reset state in vfio_pci_liveupdate_freeze() before handing off
> > > > control to the next kernel. So my intention here is that VFIO will
> > > > receive the device in that state, allowing it to call
> > > > pci_store_saved_state() here to capture the post reset state of the
> > > > device again.
> > > >
> > > > Eventually we want to drop the reset in vfio_pci_liveupdate_freeze(=
) and
> > > > preserve vdev->pci_saved_state across the Live Update. But I was ho=
ping
> > > > to add that in a follow up series to avoid this one getting too lon=
g.
> > >
> > > I appreciate reviewing this in smaller chunks, but how does userspace
> > > know whether the kernel contains a stub implementation of liveupdate =
or
> > > behaves according to the end goal?
> >
> > Would a new VFIO_DEVICE_INFO_CAP be a good way to communicate this
> > information to userspace?
>
> Sorry if I don't have the whole model in my head yet, but is exposing
> the restriction to the vfio user of the device sufficient to manage the
> liveupdate orchestration?  For example, a VFIO_DEVICE_INFO_CAP pushes
> the knowledge to QEMU... what does QEMU do with that knowledge?  Who
> imposes the policy decision to decide what support is sufficient?

Hm.. good questions. I don't think we want userspace inspecting bits
exposed by the kernel and trying to infer exactly what's being
preserved and whether it's "good enough" to use. And such a UAPI would
become tech debt once we finish development, I suspect.

A better approach would be to hide this support from userspace until
we decide it is ready for production use-cases.

To enable development and testing, we can add an opt-in mechanism,
such as CONFIG_EXPERIMENTAL or a kernel parameter. For example, adding
something like this to vfio_pci_liveupdate_preserve():

if (!IS_ENABLED(CONFIG_EXPERIMENTAL)) {
        pr_warn("vfio-pci file preservation requires
CONFIG_EXPERIMENTAL to enable!\n");
        return -EOPNOTSUPP;
}

Once we feel the support is ready, we can just submit a patch to
delete those lines, and there will be no left-over UAPI.

