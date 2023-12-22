Return-Path: <kvm+bounces-5133-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA69981C7AA
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 10:56:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2A075B23595
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 09:56:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B73D812E7B;
	Fri, 22 Dec 2023 09:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VBbjX+o0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5BD41171B
	for <kvm@vger.kernel.org>; Fri, 22 Dec 2023 09:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1d3e6c86868so13783715ad.1
        for <kvm@vger.kernel.org>; Fri, 22 Dec 2023 01:55:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703238959; x=1703843759; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+OLFd2ztkNVgmb3arj+SalK3eRAnUUPZiYspaCp+2ZI=;
        b=VBbjX+o0MxT8bbybDlcvbvSkWDd1pVaBphkWIMRcCJ4+aX/FdNM4Bon3la4+1SnsYf
         eOnOwr0Pjb7dkP44MTcHgu3wOtzbC2vDA/pHmT5gUDNIWNETLqB8qjqrdJ16iPrCk9Zv
         zDe17O1PEWhyCITiDSLcXlXBwRbuo4+3q8fPuQWSPgV7RHTJpf0eNZ7qyp/QXAk6TKw0
         c74eireXqHadoZ0/xJmhP8/3sgRwvVRiu8ZLLh64lLRXTeV/vaYotBGvMrvigkUzGtsf
         iCda5bLrX0M+B1hRcH7NL22MTG1OYuMLi16QxPlU75Jw9rh+typQG+3vAVehcQphiBFz
         tFXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703238959; x=1703843759;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+OLFd2ztkNVgmb3arj+SalK3eRAnUUPZiYspaCp+2ZI=;
        b=CK3aTYNVd9DHE91rx8hTqLOSDxT5SQaX6ArhvfX7p5aT4ZXDjF+NcVNiKazMQ2YFdZ
         vA1orl0dOf5zAp/+dH5t8B1NRxEmBvZF6UYcUMeWEwY6/fXv+ZGghmKsI1B5bGTri76J
         jTPweR46xT3aWAEyqHpP4Fv/LV6MbYh5HBWfdQr/FTcH078E3fW3nC2gEkgtJ/4skdC8
         dUeq0Kl5Sx/2f2ywq1WWIBkfhwq0w9Fu1NiPqDaZf86aAne/fZCto6GExUYxk3WjhpVV
         +FgpA6YsEwO20PyGIHJaMTHC61DEWbwwBmkPVPIAF9CksQrVJsEYHsGxsbnbbSjX0t2S
         X8GQ==
X-Gm-Message-State: AOJu0YxkbiqQnmdFjgJd7Bx5xgCJtqeDCoS6qRA+gHnahRm9rz6Ca7eo
	6GCuhOH4sCiGTrsi+eCxzFQ=
X-Google-Smtp-Source: AGHT+IHGXJeA4Z9CHTuglBHWWMDbE1zDQFmX5Q6sHzAuyhKWSEdBaEczbg674wDAG3DdC6OjcLGP3Q==
X-Received: by 2002:a17:902:db02:b0:1d3:bc96:6c13 with SMTP id m2-20020a170902db0200b001d3bc966c13mr1173424plx.35.1703238958957;
        Fri, 22 Dec 2023 01:55:58 -0800 (PST)
Received: from localhost ([203.220.145.68])
        by smtp.gmail.com with ESMTPSA id be10-20020a170902aa0a00b001d3c3d486bfsm3036465plb.163.2023.12.22.01.55.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Dec 2023 01:55:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 22 Dec 2023 19:55:53 +1000
Message-Id: <CXURTH5YQKXS.36M3EIM30WDMC@wheely>
Cc: <linuxppc-dev@lists.ozlabs.org>, "Laurent Vivier" <lvivier@redhat.com>,
 "Shaoqin Huang" <shahuang@redhat.com>, "Andrew Jones"
 <andrew.jones@linux.dev>, "Nico Boehr" <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v5 18/29] powerpc: Fix stack backtrace
 termination
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Thomas Huth" <thuth@redhat.com>, <kvm@vger.kernel.org>
X-Mailer: aerc 0.15.2
References: <20231216134257.1743345-1-npiggin@gmail.com>
 <20231216134257.1743345-19-npiggin@gmail.com>
 <464fccfc-b375-4458-b718-de606e50c61c@redhat.com>
In-Reply-To: <464fccfc-b375-4458-b718-de606e50c61c@redhat.com>

On Tue Dec 19, 2023 at 10:22 PM AEST, Thomas Huth wrote:
> On 16/12/2023 14.42, Nicholas Piggin wrote:
> > The backtrace handler terminates when it sees a NULL caller address,
> > but the powerpc stack setup does not keep such a NULL caller frame
> > at the start of the stack.
> >=20
> > This happens to work on pseries because the memory at 0 is mapped and
> > it contains 0 at the location of the return address pointer if it
> > were a stack frame. But this is fragile, and does not work with powernv
> > where address 0 contains firmware instructions.
> >=20
> > Use the existing dummy frame on stack as the NULL caller, and create a
> > new frame on stack for the entry code.
> >=20
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > ---
> >   powerpc/cstart64.S | 12 ++++++++++--
> >   1 file changed, 10 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/powerpc/cstart64.S b/powerpc/cstart64.S
> > index e18ae9a2..14ab0c6c 100644
> > --- a/powerpc/cstart64.S
> > +++ b/powerpc/cstart64.S
> > @@ -46,8 +46,16 @@ start:
> >   	add	r1, r1, r31
> >   	add	r2, r2, r31
> >  =20
> > +	/* Zero backpointers in initial stack frame so backtrace() stops */
> > +	li	r0,0
> > +	std	r0,0(r1)
> > +	std	r0,16(r1)
> > +
> > +	/* Create entry frame */
> > +	stdu	r1,-INT_FRAME_SIZE(r1)
>
> Shouldn't that rather be STACK_FRAME_OVERHEAD instead of INT_FRAME_SIZE..=
.
>
> >   	/* save DTB pointer */
> > -	std	r3, 56(r1)
> > +	SAVE_GPR(3,r1)
>
> ... since SAVE_GPR uses STACK_FRAME_OVERHEAD (via GPR0), too?

No I think it's correct. INT_FRAME_SIZE has STACK_FRAME_OVERHEAD and
struct pt_regs. The STACK_FRAME_OVERHEAD in GPR offsets is just to skip
that and get to pt_regs.gpr[].

Thanks,
Nick

