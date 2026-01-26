Return-Path: <kvm+bounces-69176-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4Lo0K8Lqd2nSmQEAu9opvQ
	(envelope-from <kvm+bounces-69176-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 23:29:22 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C3638DEF2
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 23:29:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0EEB7302797A
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 22:29:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76D58306B21;
	Mon, 26 Jan 2026 22:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gBJMJYOg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 520BF258EDB
	for <kvm@vger.kernel.org>; Mon, 26 Jan 2026 22:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769466555; cv=pass; b=MwJCvwGuU1XFtEyNFkQfSQpXCAooZ7ufpLk+RtPKBPucZGlm86zECDPcVayoB7GqYXylf49UT5/U/8yE4S/O+7CNTNMFomFs/n3rLqT2QWx3iyppvRr1HOE6HzV/v70Iqoem2G3jyYfB4t2i1vugrihswlFGaiQhpWCpCtJyBUA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769466555; c=relaxed/simple;
	bh=pZbdeT1pWT2TN4VkrBX4R8t3vE9qLa6Bt2GMpVsv/LY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=miWISy2cg6CpE2RrKLXHMEAbnoKHCiblEEkORVsmPl2UUGYaj77WqFXVeigyrRhg8guqoiD9Q9cyxlJQeRGCI2I00DOFXfTkZqMvMK30ZoxfPvEIoclLVtwUmowoS2RyxDZUhe+q/+HlfszE6zzgjgbqAXMgm/ZMjAFz/uj3bP4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gBJMJYOg; arc=pass smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-65819e75691so8742324a12.3
        for <kvm@vger.kernel.org>; Mon, 26 Jan 2026 14:29:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769466553; cv=none;
        d=google.com; s=arc-20240605;
        b=MJp2GOdhBas+h2JvzjY8L/qk5rqHT8m+r/dr+y+Jyb7vgxPNb52Z7Ti8MONN8OOJY/
         8hEns9SxZd6dh1hHszzr/Hc6kyXA2PaU/DiHRWG/jF22YDfIQYvVvAlKQZo3OmrLYzvf
         mT0J50QWwPpcC9O5D+GPq9RTnzBsYIrtlYxMev3OFHhrx++4tnEvwzwkTUmUwt3a7+jc
         ycTZhC8n5S/c0HsoyUECgZjP/4esEEmUaMu/LBNZmeRU9/AFpnw02/5RacFqyGy1U1tx
         V+pci2t4YVXvw+1YyujpEs3TuWpsrNmHK7H+/cfaBcOhH03nUSgaElI2eju5aCSl4dnw
         MHXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pZbdeT1pWT2TN4VkrBX4R8t3vE9qLa6Bt2GMpVsv/LY=;
        fh=2kYYSjs940XmnsVkD8u/OLSfu7Wgk9mVX6av8bem1Co=;
        b=ku5XqsXvMWatSNGSWbUcPobzKIVGbb6SeofKD9kGhFHN7hFLJPA5/hxMX44pcK5Q1p
         EdKh7NlhrThR/ijts+OQNfZkQ1pvcKwDUn1wXnWw6oxXUVaCZOFiE544MCt9p+34bBta
         ilt2hHUB3eSGCuUsWDB98Sjt1slzIILRehbJMXYUR7XLrUma/DrpWZLQcb5kYRAS35x6
         rHdRP3sHtXthv3YfwO8BWJNRFMoSIbwl7jCL8vGwYPvu+dggl3SstwPsL57xzebGFFnX
         xtA8lBxhp+FdghA1PhojjUHCEskU+WEweHS/fXqkeEmRMcGrQeSC5tRXjaQ45arMwEhm
         +TRg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769466553; x=1770071353; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pZbdeT1pWT2TN4VkrBX4R8t3vE9qLa6Bt2GMpVsv/LY=;
        b=gBJMJYOg/pMzu6RgmXKcNmAZFIur9V1Gn2qgQYWhbRn026brXiqAuB6qhxcgaPDjfe
         1z2dR5zaRkmU/3YwkIAYzVuuqgUY3lsUlHFRJmysSlVCfGM+CxOxQt3Hyk8Pp9Y1jgfB
         oqNPZjwEpsXZDKHI9PDnep4HRQT25usumK8L2UMWAbTPEeuB+wUETxwkKTLA3pGzp/fM
         lXOe84tilQBK2zwWrwBmHU2WA6flKHfARmWu6TeJ/U+LLJJhYliNWbe9827CgY2T05c2
         icYTXzQeVmQfJ9bcTlkxuU/vv9x6g5M+bfmDhcd7wq9jYuFnIf197r3n6O+mFYVPirVF
         g9Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769466553; x=1770071353;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pZbdeT1pWT2TN4VkrBX4R8t3vE9qLa6Bt2GMpVsv/LY=;
        b=oiEXYUcHBw5Ocyuu48kbyKgy9VDUGLvhZWia/hKjQ8+++yeNvp3hovkFNw2Ot/Ob0Q
         6Ur6Vd4ARD1bKD9EECb5CVo9RtpYGkJdwDEImZ4b7tmhNJ0diH+sXzhGywenpRXscGpx
         uSQFVKv8s7R2iUkcM1gWhIQASQlqdxw1yPWex860RYIpHbV0a6GAjxZtzKtlhSruW+wH
         qMJsl4HXEnii4Sh1wOj+XRNrvCC7rJCDIQS/dsB1NH6swY9/+nKNBXjaDmqG/OV+SRge
         FBVes/SJa078u3WxfnhKfL4hrCZ2Mtfs6UB06Whw00u4l5G7xdeT8jzPYwLky9GwTBLm
         O4sg==
X-Forwarded-Encrypted: i=1; AJvYcCWF70M9K6hUgi2dztKKwmgNSdcS5g5MwRkMx73fUcC8q4FA5VyRGwVeXOmlRWKIJ8xscW8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxACpApsWsm1ipRS7OLUo/tvoxo0CR5FkY5VVSPVWVXu3PH0o06
	zXmTTobTVeO3LchTM+9VfwEIVMvXvJv3aqy2yDMm6tUMc+/q2ziLK7W8rgOhC7srrfwdEVl+R4t
	DddL+E38rO3FD9dr6LcZU+Bd8i40rRyM=
X-Gm-Gg: AZuq6aItDiXF24kjgZny0EQGh2GcXTfVxvtdUMDSkkdc7yQZ4LhKn7N4wVEbG/101S+
	EKkdzLrGBG4YNaLeTX1ul8WBY5L/A7GeYrAn583eVz+YBHaSqPbTvyjr5Mrnw2TnsUm8D3AjX7g
	QumjP+4nkbTnVjFVANt05i1MBXpsQCPiOXEipgNwt0ilV2/P40n9E2jiaZ8Y/xKPrFO9z4dIiBc
	0zPoJzx867mIEhZxoP2euWQrkA90QWe3h8wJi6Cu8S5Gv9ryp2iuMyipDvqH3I+wqhMy9ZnxiwJ
	BRIM
X-Received: by 2002:a05:6402:510e:b0:658:1689:3f66 with SMTP id
 4fb4d7f45d1cf-658706aa5cemr4017010a12.11.1769466552605; Mon, 26 Jan 2026
 14:29:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJSP0QVXXX7GV5W4nj7kP35x_4gbF2nG1G1jdh9Q=XgSx=nX3A@mail.gmail.com>
 <CAMxuvaz8hm1dc6XdsbK99Ng5sOBNxwWg_-UJdBhyptwgUYjcrw@mail.gmail.com>
 <CAJSP0QVQNExn01ipcu4KTQJrmnXGVmvFyKzXe5m9P3_jQwJ6cA@mail.gmail.com>
 <CAJSP0QW4bMO8-iYODO_6oaDn44efPeV6e00AfD5A42pQ9d+REQ@mail.gmail.com>
 <aXH4PpkC4AtccsOE@redhat.com> <CAMxuvaw04pDNzHyw5+Qcv_KfrhDTiyp+MNxpECp+HfTa5iLOGw@mail.gmail.com>
 <aXH-TlzxZ1gDvPH2@redhat.com> <CAFEAcA_u6QUhs+6-cyYm_qttsDiV2zHbsc-_FbTb8QzWXk6+tw@mail.gmail.com>
 <aXICpFZuNM9GG4Kv@redhat.com> <CAMxuvawgOvQbwoyCzFBLw++JqR0vFbVUhbv1AJWU6VqK1MM_Og@mail.gmail.com>
 <82f74c82-c572-4ab9-b527-11ea287056d1@linaro.org> <CAJ+F1CJtrv9YgDbiekVmDD2yT+6nUe39nLwLsKxvFOtMc1kUGA@mail.gmail.com>
In-Reply-To: <CAJ+F1CJtrv9YgDbiekVmDD2yT+6nUe39nLwLsKxvFOtMc1kUGA@mail.gmail.com>
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Mon, 26 Jan 2026 17:29:00 -0500
X-Gm-Features: AZwV_QjeiSGE9qOfd4lomdCKhHJfL1YgEOBHoSe8fPGKDAlY3x6Z0UbEfLbcn0M
Message-ID: <CAJSP0QUCQ8LkHEPNPb75XZmo46xxvP3uA373fzAZTwn=bo_bdg@mail.gmail.com>
Subject: Re: Call for GSoC internship project ideas
To: =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@gmail.com>
Cc: Pierrick Bouvier <pierrick.bouvier@linaro.org>, 
	=?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
	Peter Maydell <peter.maydell@linaro.org>, Thomas Huth <thuth@redhat.com>, 
	qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>, 
	Helge Deller <deller@gmx.de>, Oliver Steffen <osteffen@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, Matias Ezequiel Vara Larsen <mvaralar@redhat.com>, Kevin Wolf <kwolf@redhat.com>, 
	German Maglione <gmaglione@redhat.com>, Hanna Reitz <hreitz@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>, Alex Bennee <alex.bennee@linaro.org>, 
	John Levon <john.levon@nutanix.com>, Thanos Makatos <thanos.makatos@nutanix.com>, 
	=?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69176-lists,kvm=lfdr.de];
	TO_DN_ALL(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[21];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	FREEMAIL_FROM(0.00)[gmail.com];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[stefanha@gmail.com,kvm@vger.kernel.org];
	FREEMAIL_CC(0.00)[linaro.org,redhat.com,nongnu.org,vger.kernel.org,gmx.de,ilande.co.uk,nutanix.com];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[qemu.org:url,linaro.org:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 0C3638DEF2
X-Rspamd-Action: no action

On Fri, Jan 23, 2026 at 3:44=E2=80=AFAM Marc-Andr=C3=A9 Lureau
<marcandre.lureau@gmail.com> wrote:
>
> Hi
>
> On Thu, Jan 22, 2026 at 7:46=E2=80=AFPM Pierrick Bouvier
> <pierrick.bouvier@linaro.org> wrote:
> >
> > On 1/22/26 3:28 AM, Marc-Andr=C3=A9 Lureau wrote:
> > > Hi
> > >
> > > On Thu, Jan 22, 2026 at 2:57=E2=80=AFPM Daniel P. Berrang=C3=A9 <berr=
ange@redhat.com> wrote:
> > >>
> > >> On Thu, Jan 22, 2026 at 10:54:42AM +0000, Peter Maydell wrote:
> > >>> On Thu, 22 Jan 2026 at 10:40, Daniel P. Berrang=C3=A9 <berrange@red=
hat.com> wrote:
> > >>>> Once we have written some scripts that can build gcc, binutils, li=
nux,
> > >>>> busybox we've opened the door to be able to support every machine =
type
> > >>>> on every target, provided there has been a gcc/binutils/linux port=
 at
> > >>>> some time (which covers practically everything). Adding new machin=
es
> > >>>> becomes cheap then - just a matter of identifying the Linux Kconfi=
g
> > >>>> settings, and everything else stays the same. Adding new targets m=
eans
> > >>>> adding a new binutils build target, which should again we relative=
ly
> > >>>> cheap, and also infrequent. This has potential to be massively mor=
e
> > >>>> sustainable than a reliance on distros, and should put us on a pat=
hway
> > >>>> that would let us cover almost everything we ship.
> > >>>
> > >>> Isn't that essentially reimplementing half of buildroot, or the
> > >>> system image builder that Rob Landley uses to produce toybox
> > >>> test images ?
> > >>
> > >> If we can use existing tools to achieve this, that's fine.
> > >>
> > >
> > > Imho, both approaches are complementary. Building images from scratch=
,
> > > like toybox, to cover esoteric minimal systems. And more complete and
> > > common OSes with mkosi which allows you to have things like python,
> > > mesa, networking, systemd, tpm tools, etc for testing.. We don't want
> > > to build that from scratch, do we?
> > >
> >
> > I ran into this need recently, and simply used podman (or docker) for
> > this purpose.
> >
> > $ podman build -t rootfs - < Dockerfile
> > $ container=3D$(podman create rootfs)
> > $ podman export -o /dev/stdout $container |
> > /sbin/mke2fs -t ext4 -d - out.ext4 10g
> > $ podman rm -f $container
> >
> > It allows to create image for any distro (used it for alpine and
> > debian), as long as they publish a docker container. As well, it gives
> > flexibility to have a custom init, skipping a lengthy emulated boot wit=
h
> > a full system. As a bonus, it's quick to build, and does not require
> > recompiling the world to get something.
> >
> > You can debug things too by running the container on your host machine,
> > which is convenient.
> >
>
> Very nice! I didn't realize you could export and reuse a container that w=
ay.
>
> I wonder how this workflow can be extended and compare to mkosi
> (beside the limitation to produce tar/fs image)
>
> For qemu VM testing, it would fit better along with our Dockerfile &
> lcitool usage.
>
> I wish a tool would help to (cross) create & boot such (reproducible)
> images & vm easily.

Hi Marc-Andr=C3=A9,
I would like to submit QEMU's GSoC application in the next day or two.
A minimum of 4 project ideas is mentioned in the latest guidelines
from Google and we're currently at 3 ideas. Do you want to update the
project idea based on the feedback so we can add it to the list?
https://wiki.qemu.org/Internships/ProjectIdeas/mkosiTestAssets

Thanks,
Stefan

