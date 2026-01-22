Return-Path: <kvm+bounces-68931-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WBm4ElN3cmn3lAAAu9opvQ
	(envelope-from <kvm+bounces-68931-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 20:15:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D3056CF02
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 20:15:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 521483016CA7
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 19:15:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF24133D50B;
	Thu, 22 Jan 2026 19:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LcobjIgx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D4D5372B32
	for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 19:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769109300; cv=pass; b=ujvPwY+LS4F7ZOG9m5npsqVVlMiVSVxd9HhEf96pC2J5z6OjSWJXyIX0uuHV0Q6fNqfFqjJCYVv0pCImt2Xh/zf2O+lNG8ts9NeVqS02aZQuq6BoCX6h+kIYGUTpJUe4iq4V7lT+y0JFbxEf7Ws3o6/11j6XVhhcarCjo0CGpbM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769109300; c=relaxed/simple;
	bh=IJ/sGHSNHA4btWTNxQgApXnTAKcFvCnphzdMReBDQ2I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N2TlHEgsK382xyx45T8p0Vn6i6CCXwjeRw54br0nAGbv0/OGxPAtebmksCG3g3VtD8cb/4hJM4nx8IZzusS5WmeULUP9Ws6Ob+DHOc5EKoHDxeUZ56lytOebe7OTHYU2yom6YHVwHAfK9z2DL6m5teFE0EohD4M3lin7r9xnz68=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LcobjIgx; arc=pass smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-65808d08423so2165976a12.1
        for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 11:14:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769109290; cv=none;
        d=google.com; s=arc-20240605;
        b=F/dLziV7iCJDznhTTqwDVXfLg2DtsRLqWHjv6VSyPgW47xxnLxKnADqKSIjnJ2v6UE
         nRd7g2iVQ9raSaRzm3HTTMn6ySMDlooZNkW5Vg1b/v1GlDYih7AWPL2mrViZ7JKeuWzF
         K0zMEru+9+qmlhiRfWBEkUzo6i7mLIcVQn8qhbHvb+GRpnYtwTdZl1Ck80CV1Kxc9DW8
         ikoDG1eP9ioVo44p81N0MRqyD8qmxh6qGzWvePXKr6FOW2fycWwgeKdWPeVCbbETrjJw
         FtQw2xXFaT1MX2ZKCRdfqe2zIJZoW58PiBhEyD+NijCdgNiY05tLbrrVfgvYALpe7bgS
         vQDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=IJ/sGHSNHA4btWTNxQgApXnTAKcFvCnphzdMReBDQ2I=;
        fh=y0qF3KbL3sN4vqRQVkXqb4QMsJYDQ82VyYF+JAo+cE8=;
        b=KBybPs1qbSKPb3ZG0a9XUY6TvSxngW5EZvpD6yLT1Fnk6DojRcSu91o0oQWzYfZFty
         XDwrGMJhID+GGKJhXa1aoTbbq0+jhjF19hrF+bt625TOizmp1u84RLEVR7EG0mbZrEDi
         hvLWuRH0C16YIvGzzhm7LGWtsfVXlQx6rPkemcYwhJXT43O3+o7EGUNm1GTG0thCa0VE
         wja8PPUVahYGgjYDzUx3AK3LInxcaGd9srccA/mtx8+rLuno0QVHAqwjm01PORZ80ncZ
         0GbZNiWysi8MPxoHtsZSuJmwZj13qnUeGriSqtE6llQwFFMckv7DjPUzHKlwvuYmJFxB
         YgDA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769109290; x=1769714090; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IJ/sGHSNHA4btWTNxQgApXnTAKcFvCnphzdMReBDQ2I=;
        b=LcobjIgxgGRyXz0LzDptdWNgF1q9J5tabG6mmX8+G6pruu8/e8KU+drov7/7XbZ0L1
         14sPLcs9Wneypuu6u0VenR8t1+oSVHdQmNkJu1ygR24E5jK/8Vjdux5grQFRyuv3ekE4
         ww/ZZ8iOX8BrYoizGZiaTgZ5ujw6We2lczEE/QDrfmzWT5ud9CVaeRp2HQPw70OmT6qS
         cldVL4LZ2o0/mr57joI/MKKjDx6oA+jFSUM2qfpYL6ZJfbBL1F7gkrF+m2fGNE6koXoK
         tb+OyXjnYaZhmFEuOZCKv14TwyZpYC7xPzmEMydxfkUKQBqf2mRtXAu1b9GWxnMo+0Ev
         5AfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769109290; x=1769714090;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IJ/sGHSNHA4btWTNxQgApXnTAKcFvCnphzdMReBDQ2I=;
        b=GRkV8eep2VNrHPr7enIjAv3yMmbUX/aUm5bY+edMxXtgf5a8fcD9IMa7w4+2o1EFJg
         e34LgNyZ2gwOgwMmcUgiR8r/STJ8f4LPCKHLabKZlj/BFFUJZUuzPTnTdZOCjL1N22vR
         B4raPsngOd7sz8P75aCmVtybIOXeVpw0PzB9AVlrtZ2MNlcNX8Rnd0D2+iXR6TSry2RG
         kALTJhg/8bk+4NRGzg4iGjNbMcWzknKYUF1QmSug4iXbe90UdQt1bl89rYoCSZ9QK0AO
         ZXre0DM4+DNryfaHkH/kHf6S9E6uKG9I+PuxdsWQmt8FGNJOrBuuqPz4l8gemPH5CT7/
         kgKg==
X-Forwarded-Encrypted: i=1; AJvYcCXV2bTswC7eL252b9NPG60FWxgeXg50k8/nq6nKBHVgL9rqrqGrz43lOc7pzT/a5FkLjsY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7hHBktW2gQhlH80+EkHMX+6hRoaDn4kamenX5LbB6nWnE7WVp
	E97AJgQf7uZd7J7a5RcL2UAAsOUCES9cq1Rfqc5AdycxjbQO6Mkzx82FTl7bA4RIW577ZIiNvrT
	+MZqsj5UkJnfT77KR8jpzgk5n3wZHtk3v3Q==
X-Gm-Gg: AZuq6aKG/Hopm0vDe713E7dvO0Sc5RCY/wPMqmqUqGb39YxfY9kOwZ/YjEwcuG5oTTU
	xFCc89fayqgjj9BlVGvRVrd0kkQ3xROvVESHxCOO7y2LOHb8WQw6RftLI8WWE0leX+MgsWNUepZ
	cJ1A1Q3RR/4G2+0FyOzfkZozmpmhHAgaGumSUkYF7CffQhifZlkKgvfjmgXzn53pinSj1yIVvR/
	3JkMyxT0wuJKkcU7GvNOte06+21TxWpoZRg2KqgYKV0pULu8qBhddwVMfInnLh7VQl3EQ==
X-Received: by 2002:a05:6402:3594:b0:658:370f:79e1 with SMTP id
 4fb4d7f45d1cf-6584875e33fmr397402a12.4.1769109290255; Thu, 22 Jan 2026
 11:14:50 -0800 (PST)
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
 <aXH4PpkC4AtccsOE@redhat.com> <130b8f26-2369-48f5-bbd6-e27210707b9f@redhat.com>
In-Reply-To: <130b8f26-2369-48f5-bbd6-e27210707b9f@redhat.com>
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Thu, 22 Jan 2026 14:14:36 -0500
X-Gm-Features: AZwV_QhUVsYAQme0MbqbFeqPikNKUWX_YeCbht9OywCS7cmGsV91TJnyqw7RgIg
Message-ID: <CAJSP0QWW4r6NrGyVowxf7X-1NkF9jNwZ70WQVNZB4Zdtv3QvUg@mail.gmail.com>
Subject: Re: Call for GSoC internship project ideas
To: Thomas Huth <thuth@redhat.com>
Cc: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
	=?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, 
	qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>, 
	Helge Deller <deller@gmx.de>, Oliver Steffen <osteffen@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, Matias Ezequiel Vara Larsen <mvaralar@redhat.com>, Kevin Wolf <kwolf@redhat.com>, 
	German Maglione <gmaglione@redhat.com>, Hanna Reitz <hreitz@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>, Alex Bennee <alex.bennee@linaro.org>, 
	Pierrick Bouvier <pierrick.bouvier@linaro.org>, John Levon <john.levon@nutanix.com>, 
	Thanos Makatos <thanos.makatos@nutanix.com>, =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
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
	TAGGED_FROM(0.00)[bounces-68931-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_ALL(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[redhat.com,nongnu.org,vger.kernel.org,gmx.de,linaro.org,ilande.co.uk,nutanix.com];
	RCPT_COUNT_TWELVE(0.00)[20];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[stefanha@gmail.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[qemu.org:url,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 9D3056CF02
X-Rspamd-Action: no action

On Thu, Jan 22, 2026 at 5:43=E2=80=AFAM Thomas Huth <thuth@redhat.com> wrot=
e:
>
> On 22/01/2026 11.14, Daniel P. Berrang=C3=A9 wrote:
> > On Tue, Jan 20, 2026 at 04:42:38PM -0500, Stefan Hajnoczi wrote:
> >> Hi Marc-Andr=C3=A9,
> >> I haven't seen discussion about the project ideas you posted, so I'll
> >> try to kick it off here for the mkosi idea here.
> >>
> >> Thomas: Would you like to co-mentor the following project with
> >> Marc-Andr=C3=A9? Also, do you have any concerns about the project idea=
 from
> >> the maintainer perspective?
>
> I'm fine with co-mentoring the project, but could you do me a favour and =
add
> some wording about AI tools to
> https://wiki.qemu.org/Google_Summer_of_Code_2026 to set the expectations
> right? Since we don't allow AI generated code in QEMU, I'd appreciate if =
we
> could state this in a prominent place here to avoid that some people thin=
k
> they could get some quick money here by using AI tools, just to finally
> discover that AI generated code is not allowed in the QEMU project. Thank=
s!

Yes. As part of our GSoC application I am going to combine the 3
statements about AI that are currently spread throughout the wiki page
into a single section.

Stefan

