Return-Path: <kvm+bounces-71653-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EOZHHDzunWncSgQAu9opvQ
	(envelope-from <kvm+bounces-71653-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 19:30:20 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E95118B65C
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 19:30:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 1E4A330711D7
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 18:28:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D58DD3A9DB1;
	Tue, 24 Feb 2026 18:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xYxOtapm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3CD63783BE
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 18:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771957647; cv=pass; b=R1mchXVfUcwIW/dO1UUFcf0nnnubWxRv1Wq4UicvZfVN4I+F58VMsFQ7UouZxJYEkhgnG2VZQyQuTk3FkUOJN0SaNJrgsgq6wjf6Y4id0QI2JpR1B0+p9jJKt3Xr6kAPYeHY6K6BhQxv7YDFXU3Ljk2YZ8ZlH1pVCH+Ro9RFSqA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771957647; c=relaxed/simple;
	bh=HAuh6hNvn+rO1WP+txWihpv8KlXSbQuFrLSY44tLtFk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RrTia+Qsc5jJiDXtWTkiAPcUK7QflawxgMlwd30aiKS+DdmkMTZt2vimH37vYvG875IdpMHzIrLY904z4YZnB+tj0ettcIDDzEmuHAo6lIK8RwgVLFXvxqUpTqEl7PIqbZQv8o3mMQsJXny5bQ6+AI4ALdCE3roRdJ07ZeYWYTM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xYxOtapm; arc=pass smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-5033b64256dso35941cf.0
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 10:27:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771957645; cv=none;
        d=google.com; s=arc-20240605;
        b=e6NXjmuQ//wI80YXE4ojM/26D9Ra3VNxnCVEY/cK9AaKjc+Rh9503/oKIXxhrpFw1w
         9B5LdoGVHvZyB/3DTJgENM8YHgrcElQewG+0La8D6WiSVh3v1BdZXK8+Oeq1P+RkZbW7
         PjHilYF8rxIDPja2eNjk42jfbeW7riMlBwJkF7RXZ2w44zBqU4SAx4qkfG3XjrfSurhG
         /W7Cb3k0ZESr1iOJo1e42MzLGdICswJUgZp53POHXFnTTu2eRz4NJTN909L+3OmIqFhD
         NdDTuAXD50c8e7EmXaMcQMyCju89/Cfe1B50uqJdh+ASni+lFD4s6IFGkXy3ph9swzyD
         wIvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=j5mvX/eKCN1YDbVafCQL9PUCJRghx9s2J+P+m1PrlTo=;
        fh=EvJukL1cS4vpaWdFGBp/+mAQn55JATHvZQTbTZAxJkU=;
        b=PA9O8KAjuyqm8ldY6/Li3bS4yd+3jSk1ZLUFL+rlrrZGU8QYWyEAmb0H47d4qBYO3l
         Et52hjaacz+NWbBc01xnEgZSqy6JrEHXAvXj3LfK/HUSWzTcF4xr7CznhQKy4We2Q90Q
         Y36F8zrfJntS3AqNy4PDJ6K4fvWSeQHPjCPSJvIanvpre8sjfxW+fnv2mnOTPBTufuGL
         FCvNdOYhmD/LYguYZ/2ewJt/+DuE2xYRNU1n4xo1vafSYFcaB1/UeHUbI3QD9ZNDElFA
         qLmRnmU1IMGYz5zZLX69HyrY/x3vMpYErlTrsOKjWc3fhbmNwQWuR19/dBMLNxjzLn09
         V+bA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771957645; x=1772562445; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j5mvX/eKCN1YDbVafCQL9PUCJRghx9s2J+P+m1PrlTo=;
        b=xYxOtapmuZqo/l2WgbOKATwKDAYvgaBSu0vkt8w3Bs547aXR6xwSTrFVvJ93iuCpQ4
         Jqt9dHzu4dj6ZU/bYe1pMw3TpuX/PHs3L+5LdPCdvQLTZsnVVXUpevTYtO8X26VCL2B7
         uVzsrjH/s5MQcPHYXdKng/IAC/gxegIIyzp6bwePEcd+uoY/NcFIcRjKQh9EPDTudrtz
         T5CMW/SYJ8V0dN8i/u6gdXHZiNp67lijfEnqMunWw5vke4CJ+kF66eMXTaOiFctHzS0C
         t2ckObKto4uKx5EZ92FJCcPPgrJhZq/ByvVVEl3WZtT8c3B1eXSP+oNRNyhhFVxUtctN
         Hz8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771957645; x=1772562445;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=j5mvX/eKCN1YDbVafCQL9PUCJRghx9s2J+P+m1PrlTo=;
        b=VIaPpZS4kEJk6L5LdGSpfmRA2WA+s/VGER11NIMVkBV/ShaWGJYe9Y6ZfyqAt3h3l1
         R/3nfx2N8sJmAy5zB/u/RA0IofnZ8gfGF3wqU6oR94EoxtnELL4ZXw9yeKgs8336CmQl
         xzeqxXjpQJawIn8e4cg++RuB3zGtUCOXTZupMLIk92sYPhGMlF/ZOwY1lSRViuZAVvst
         7LJXljr0k3WCx0yTk8l4TEAd8LzznMTdX4PVakIXX7VZLsuE1aGTkXTa4+B1jorTfmoD
         4qydoOATLxZuGDliKllslsMma66sOjY/Ad6ku8SWZVtTusT9S1XXy+60uH+a18v4+6t3
         z2pw==
X-Forwarded-Encrypted: i=1; AJvYcCUL2DNYwJGv8A6TYAAj7UU+iUFxX30Gr6WuRBPQEXgLPAtYCRdw++TYbJ3Yn2hiLcBW5k8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzLDMU1FT/hcVRbf+L4vtPVBDoqudeCQUYx6hSs8Kg76fH4tpea
	V6ETpkxcFK5EMHgnXG9KNriHm52j5zldAhjew9ATDRAA4GGRwCyStXKhEuq444TlCnSzSjG9UP8
	z9EIOkH/5cwRaGt48yqZb7D3a4cAcU33aXhySKZU0
X-Gm-Gg: AZuq6aJeX+gcqfZmlrV9+1oMitBWPjKP4OQ1lyJ6q2s4cVhnP1/YEgxbUdGw/AFty+T
	kS8Vz+CHqX1lfYvfz00yh2qzqd+u38iztw5AjWd67allb0U7gtGaNeIjzgaeeBdwBYhghAEzPqJ
	OMgMRAOUt7PD6thMZae+7f08CyEWpXuBvIDCjgigIR3CVDD2itbQbcXgeXm8+wxrm5+/omCOrhR
	geELZU146ZmBJlA3GdTzI8uChYfKvbAhjozO1w1vbcfMxSBWk9n8KXAamKmVH+j27R/kKG2WY21
	krGbeyIT
X-Received: by 2002:a05:622a:513:b0:4e8:aa24:80ec with SMTP id
 d75a77b69052e-50738e097bamr475151cf.14.1771957644132; Tue, 24 Feb 2026
 10:27:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260204010057.1079647-1-rananta@google.com> <20260204010057.1079647-4-rananta@google.com>
 <20260206134843.4ab04ee2@shazbot.org>
In-Reply-To: <20260206134843.4ab04ee2@shazbot.org>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Tue, 24 Feb 2026 10:27:12 -0800
X-Gm-Features: AaiRm523akUbQj0hhfOUz7eXlQUQclt5zCwmh0QozGos6LhdSjTp8wVD9p70XOc
Message-ID: <CAJHc60xMC84zzeTVXj8kbKkNvNpy1_TUajht7Sn=KGfgsto7oA@mail.gmail.com>
Subject: Re: [PATCH v3 3/8] vfio: selftests: Introduce a sysfs lib
To: Alex Williamson <alex@shazbot.org>
Cc: David Matlack <dmatlack@google.com>, Alex Williamson <alex.williamson@redhat.com>, 
	Vipin Sharma <vipinsh@google.com>, Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71653-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rananta@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[7];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,mail.gmail.com:mid,shazbot.org:email]
X-Rspamd-Queue-Id: 0E95118B65C
X-Rspamd-Action: no action

On Fri, Feb 6, 2026 at 12:48=E2=80=AFPM Alex Williamson <alex@shazbot.org> =
wrote:
>
> On Wed,  4 Feb 2026 01:00:52 +0000
> Raghavendra Rao Ananta <rananta@google.com> wrote:
>
> > Introduce a sysfs library to handle the common reads/writes to the
> > PCI sysfs files, for example, getting the total number of VFs supported
> > by the device via /sys/bus/pci/devices/$BDF/sriov_totalvfs. The library
> > will be used in the upcoming test patch to configure the VFs for a give=
n
> > PF device.
> >
> > Opportunistically, move vfio_pci_get_group_from_dev() to this library a=
s
> > it falls under the same bucket. Rename it to sysfs_iommu_group_get() to
> > align with other function names.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  .../selftests/vfio/lib/include/libvfio.h      |   1 +
> >  .../vfio/lib/include/libvfio/sysfs.h          |  12 ++
> >  tools/testing/selftests/vfio/lib/libvfio.mk   |   1 +
> >  tools/testing/selftests/vfio/lib/sysfs.c      | 136 ++++++++++++++++++
> >  .../selftests/vfio/lib/vfio_pci_device.c      |  22 +--
> >  5 files changed, 151 insertions(+), 21 deletions(-)
> >  create mode 100644 tools/testing/selftests/vfio/lib/include/libvfio/sy=
sfs.h
> >  create mode 100644 tools/testing/selftests/vfio/lib/sysfs.c
> >
> > diff --git a/tools/testing/selftests/vfio/lib/include/libvfio.h b/tools=
/testing/selftests/vfio/lib/include/libvfio.h
> > index 279ddcd70194..bbe1d7616a64 100644
> > --- a/tools/testing/selftests/vfio/lib/include/libvfio.h
> > +++ b/tools/testing/selftests/vfio/lib/include/libvfio.h
> > @@ -5,6 +5,7 @@
> >  #include <libvfio/assert.h>
> >  #include <libvfio/iommu.h>
> >  #include <libvfio/iova_allocator.h>
> > +#include <libvfio/sysfs.h>
> >  #include <libvfio/vfio_pci_device.h>
> >  #include <libvfio/vfio_pci_driver.h>
> >
> > diff --git a/tools/testing/selftests/vfio/lib/include/libvfio/sysfs.h b=
/tools/testing/selftests/vfio/lib/include/libvfio/sysfs.h
> > new file mode 100644
> > index 000000000000..c48d5ef00ba6
> > --- /dev/null
> > +++ b/tools/testing/selftests/vfio/lib/include/libvfio/sysfs.h
> > @@ -0,0 +1,12 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +#ifndef SELFTESTS_VFIO_LIB_INCLUDE_LIBVFIO_SYSFS_H
> > +#define SELFTESTS_VFIO_LIB_INCLUDE_LIBVFIO_SYSFS_H
> > +
> > +int sysfs_sriov_totalvfs_get(const char *bdf);
> > +int sysfs_sriov_numvfs_get(const char *bdf);
> > +void sysfs_sriov_numvfs_set(const char *bdfs, int numvfs);
> > +char *sysfs_sriov_vf_bdf_get(const char *pf_bdf, int i);
> > +unsigned int sysfs_iommu_group_get(const char *bdf);
> > +char *sysfs_driver_get(const char *bdf);
> > +
> > +#endif /* SELFTESTS_VFIO_LIB_INCLUDE_LIBVFIO_SYSFS_H */
> > diff --git a/tools/testing/selftests/vfio/lib/libvfio.mk b/tools/testin=
g/selftests/vfio/lib/libvfio.mk
> > index 9f47bceed16f..b7857319c3f1 100644
> > --- a/tools/testing/selftests/vfio/lib/libvfio.mk
> > +++ b/tools/testing/selftests/vfio/lib/libvfio.mk
> > @@ -6,6 +6,7 @@ LIBVFIO_SRCDIR :=3D $(selfdir)/vfio/lib
> >  LIBVFIO_C :=3D iommu.c
> >  LIBVFIO_C +=3D iova_allocator.c
> >  LIBVFIO_C +=3D libvfio.c
> > +LIBVFIO_C +=3D sysfs.c
> >  LIBVFIO_C +=3D vfio_pci_device.c
> >  LIBVFIO_C +=3D vfio_pci_driver.c
> >
> > diff --git a/tools/testing/selftests/vfio/lib/sysfs.c b/tools/testing/s=
elftests/vfio/lib/sysfs.c
> > new file mode 100644
> > index 000000000000..f01598ff15d7
> > --- /dev/null
> > +++ b/tools/testing/selftests/vfio/lib/sysfs.c
> > @@ -0,0 +1,136 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +#include <fcntl.h>
> > +#include <unistd.h>
> > +#include <stdlib.h>
> > +#include <string.h>
> > +#include <linux/limits.h>
> > +
> > +#include <libvfio.h>
> > +
> > +static int sysfs_val_get(const char *component, const char *name,
> > +                      const char *file)
> > +{
> > +     char path[PATH_MAX];
> > +     char buf[32];
> > +     int fd;
> > +
> > +     snprintf_assert(path, PATH_MAX, "/sys/bus/pci/%s/%s/%s", componen=
t, name, file);
> > +     fd =3D open(path, O_RDONLY);
> > +     if (fd < 0)
> > +             return fd;
> > +
> > +     VFIO_ASSERT_GT(read(fd, buf, ARRAY_SIZE(buf)), 0);
> > +     VFIO_ASSERT_EQ(close(fd), 0);
> > +
> > +     return strtol(buf, NULL, 0);
>
> I'm surprised we're not sanitizing the strtol() here, ie.
>
>         errno =3D 0;
>         ret =3D strtol(buf, NULL, 0);
>         VFIO_ASSERT_EQ(errno, 0, "sysfs path \"%s\" is not an integer: \"=
%s\"\n", path, buf);
>
>         return ret;
>
Thanks for the suggestion. I've applied this in v4 and renamed the
function to sysfs_val_get_int() to make things clear.

- Raghavendra

