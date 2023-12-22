Return-Path: <kvm+bounces-5131-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AD28681C79A
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 10:51:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 42DCFB23767
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 09:51:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F96CFBF5;
	Fri, 22 Dec 2023 09:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PvDTeqCL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B3EFBE2
	for <kvm@vger.kernel.org>; Fri, 22 Dec 2023 09:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-58d18c224c7so1041762eaf.2
        for <kvm@vger.kernel.org>; Fri, 22 Dec 2023 01:51:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703238675; x=1703843475; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p4YI5mRve5b7UFT1Vit4+6CH1n36vTPiU2vKButTctA=;
        b=PvDTeqCLXiQRhgmqjfbjDqQpySGHalw2lSPnUag5IMa3ol6TyQqL9ZolkKQ9Z0/pqv
         vlfx3lTBzhRGZgYK7/t+cC185GjX02pJFBwp3LX+WO9/AfNjnbpMux9eyMy3yGY1TZ4Q
         Zl5PIZr/ZsxbtwbIuBU+EpLbTH6zDIgGnd56OaleYd766T5oRjlh5ZA/wTU9S/6PdMA+
         Axv3ePYV1oRD1XDEGIS1P4Gtafem0mbp4Al+I0nL0zWBbND6LBYenA9ax2Az1+qUs7/1
         9o3j2F+/9wyJxPtSaaZhAtyeDjjJpkcJxD2wcI2Z+v/t98Qglkz7WQ6JCgOUuUgGd6w2
         VsEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703238675; x=1703843475;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=p4YI5mRve5b7UFT1Vit4+6CH1n36vTPiU2vKButTctA=;
        b=GjfjbI2HRbu4zEZHy+j6nONEHKPORyFYOaZYFvWKwSSwEK9HlyjkYwneN43Ji1aIlC
         HoMGcQ3a2lZf77+FET0Lc1Ps9AUg3m1lN13IRvAxH2ja5w2+moCddRl7dNZleUnxZxE+
         WA7kjrBU9MRs/0CQm9aGGHK/kANayhK33zSgCYUTWffl3HNmq0SLOTD/CM8TkJYlD4qv
         IDB1t1ZJg0XT4UxuMkm2g6HLq5M2wQ232BMYbof3ddzeTLaBIU9CNfJtzrKjOt0l8U6B
         cYvwprR4tFal6LEB5JC7RQgfZY27L15+RTRXZz9u9R1o/FVMwv/RIn4ByTFkmoDE4g9g
         cVtg==
X-Gm-Message-State: AOJu0YxBO6cj1oJa+rStt4x88s8p2f6FqdZbRFOtxI0gPlJRIq8I1Nrm
	PjAQ4eqyZvoi3dJJrrtuNOc=
X-Google-Smtp-Source: AGHT+IHG6OAPhLmKdJyuxRxSs98+wvwcYe2giZb8jFHhi+9eJXd/lJmK2C1FgP+tbG2sIIza/S3pYw==
X-Received: by 2002:a05:6359:209:b0:172:e164:93f9 with SMTP id ej9-20020a056359020900b00172e16493f9mr841223rwb.31.1703238675349;
        Fri, 22 Dec 2023 01:51:15 -0800 (PST)
Received: from localhost ([203.220.145.68])
        by smtp.gmail.com with ESMTPSA id z2-20020a62d102000000b006d9762f2725sm2650927pfg.45.2023.12.22.01.51.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Dec 2023 01:51:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 22 Dec 2023 19:51:09 +1000
Message-Id: <CXURPUMH8EKD.3GZ7EISK22JLA@wheely>
Cc: <linuxppc-dev@lists.ozlabs.org>, "Laurent Vivier" <lvivier@redhat.com>,
 "Shaoqin Huang" <shahuang@redhat.com>, "Andrew Jones"
 <andrew.jones@linux.dev>, "Nico Boehr" <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v5 12/29] powerpc/sprs: Avoid taking
 async interrupts caused by register fuzzing
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Thomas Huth" <thuth@redhat.com>, <kvm@vger.kernel.org>
X-Mailer: aerc 0.15.2
References: <20231216134257.1743345-1-npiggin@gmail.com>
 <20231216134257.1743345-13-npiggin@gmail.com>
 <c06b1cec-8a39-41ff-91e6-ad7bb99b3341@redhat.com>
In-Reply-To: <c06b1cec-8a39-41ff-91e6-ad7bb99b3341@redhat.com>

On Tue Dec 19, 2023 at 9:47 PM AEST, Thomas Huth wrote:
> On 16/12/2023 14.42, Nicholas Piggin wrote:
> > Storing certain values in some registers can cause asynchronous
> > interrupts that can crash the test case, for example decrementer
> > or PMU interrupts.
> >=20
> > Change the msleep to mdelay which does not enable MSR[EE] and so
> > avoids the problem. This allows removing some of the SPR special
> > casing.
> >=20
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > ---
> >   powerpc/sprs.c | 14 ++------------
> >   1 file changed, 2 insertions(+), 12 deletions(-)
> >=20
> > diff --git a/powerpc/sprs.c b/powerpc/sprs.c
> > index 01041912..313698e0 100644
> > --- a/powerpc/sprs.c
> > +++ b/powerpc/sprs.c
> > @@ -481,12 +481,7 @@ static void set_sprs(uint64_t val)
> >   			continue;
> >   		if (sprs[i].type & SPR_HARNESS)
> >   			continue;
> > -		if (!strcmp(sprs[i].name, "MMCR0")) {
> > -			/* XXX: could use a comment or better abstraction! */
> > -			__mtspr(i, (val & 0xfffffffffbab3fffULL) | 0xfa0b2070);
> > -		} else {
> > -			__mtspr(i, val);
> > -		}
> > +		__mtspr(i, val);
> >   	}
> >   }
> >  =20
> > @@ -536,12 +531,7 @@ int main(int argc, char **argv)
> >   	if (pause) {
> >   		migrate_once();
> >   	} else {
> > -		msleep(2000);
> > -
> > -		/* Taking a dec updates SRR0, SRR1, SPRG1, so don't fail. */
> > -		sprs[26].type |=3D SPR_ASYNC;
> > -		sprs[27].type |=3D SPR_ASYNC;
> > -		sprs[273].type |=3D SPR_ASYNC;
> > +		mdelay(2000);
> >   	}
>
> IIRC I used the H_CEDE stuff here on purpose to increase the possibility=
=20
> that the guest gets rescheduled onto another CPU core on the host, and th=
us=20
> that it uncovers sprs that are not saved and restored on the host more=20
> easily. So I'd rather keep the msleep() here.

Ah. Not a bad idea. I'll see about making it deal with H_CEDE
instead.

I wonder if there would be a way to stress host CPU migration
in the test harness. Instead of waiting for QEMU to exit, the
script could run taskset in a loop to bounce it around.
Conceptually easy, probably fiddly to wire things up nicely.

I may try to take a look at adding that... but after this
series so it doesn't get any bigger :/

Thanks,
Nick

