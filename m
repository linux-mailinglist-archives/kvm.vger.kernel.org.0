Return-Path: <kvm+bounces-5135-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 10E8E81C827
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 11:32:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C1709284778
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 10:32:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E240B156F8;
	Fri, 22 Dec 2023 10:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lvYt20gI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 056F6156C3
	for <kvm@vger.kernel.org>; Fri, 22 Dec 2023 10:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-5bdb0be3591so1307765a12.2
        for <kvm@vger.kernel.org>; Fri, 22 Dec 2023 02:32:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703241149; x=1703845949; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D4giY87NampDkKxolYu5WR6Es2kMV091Z+lpYToWl+c=;
        b=lvYt20gIBM5IfGg6vdGt4mhXBd62SsVt7RddSHzJQ88LvDBOXXdSOL6Ut3I5y87wLu
         UiyPtFmgNaYdG6Uuecv7t52LmFlIXmygMcHTA+iP2E+4JwK2RN8pC5D44div5bpDzpHD
         tcW2wLpP8R2e/UqZlsbObHE92sLVgBvqNYV8wgLfdoqFG7+3rCqoer79xCU+v/s619S0
         JHEzvXEqdqAcFWNdtJf3n4w0n1jT91jc0ZCjdxmj76VHeq0FoEZpJH/TlKV8wIIpc6vs
         WFsDMZ4IxZEXVFx+RLBhwS4l9QVz5VUAODhxO+aYP3DfMalfxmWW+7SiBlBSlKdHIzbB
         WUzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703241149; x=1703845949;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=D4giY87NampDkKxolYu5WR6Es2kMV091Z+lpYToWl+c=;
        b=NbaP8QAr5UBMC5JAJg0CQzXeAIbFNhc5UIxquU/PJrQvBpZX2SnBGabdTx3Ar2fj5F
         6CZaVmrnz9kR2xM5Gfng/JCqF7qEZ5ArP1ljXC8wPG3s+62tLaDic9aYqA1rplqmd0kg
         BNlbgQxBbox6EdgOMIxNAPpcrrQsU/MrVkMrNIRFyz2sYoZKNK36hlPpYNb2ktgd6rEB
         KhdsGByNsZZgroq1OE+uHPNhDvEd4ZHLHIQo+goZVk9ELJMtfWEBMPWet9gok/eOUBcj
         HuT3ox2KQXH2J5FepR8eWHftBtpoIwXNbWckV0ntsGHGqD4nPdTNo4SbtyREntCHTd71
         DNKQ==
X-Gm-Message-State: AOJu0YwxdHctEPU2PgHA9U5PpRCLhJXXMCpQbvGl9jrBNQlQ4So+csB3
	mYVP8qe8PTN/tDqGg3MuiWM=
X-Google-Smtp-Source: AGHT+IG8gauL9m6tvCBin+loqKrUACbeqn9zdF0tDnVTHbZLb1FZCFS/jgN4fKubeLgzSx/LljX2xA==
X-Received: by 2002:a17:903:2311:b0:1d3:a2b6:82aa with SMTP id d17-20020a170903231100b001d3a2b682aamr1317329plh.120.1703241149197;
        Fri, 22 Dec 2023 02:32:29 -0800 (PST)
Received: from localhost ([203.220.145.68])
        by smtp.gmail.com with ESMTPSA id bh10-20020a170902a98a00b001d4160c4f97sm1346880plb.188.2023.12.22.02.32.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Dec 2023 02:32:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 22 Dec 2023 20:32:23 +1000
Message-Id: <CXUSLF9OFLV3.3UD92Q4VTWN9G@wheely>
Cc: <linuxppc-dev@lists.ozlabs.org>, "Laurent Vivier" <lvivier@redhat.com>,
 "Shaoqin Huang" <shahuang@redhat.com>, "Andrew Jones"
 <andrew.jones@linux.dev>, "Nico Boehr" <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v5 07/29] powerpc: Add a migration stress
 tester
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Thomas Huth" <thuth@redhat.com>, <kvm@vger.kernel.org>
X-Mailer: aerc 0.15.2
References: <20231216134257.1743345-1-npiggin@gmail.com>
 <20231216134257.1743345-8-npiggin@gmail.com>
 <7cfe96f8-b483-476c-8d15-746fcdfb23a6@redhat.com>
In-Reply-To: <7cfe96f8-b483-476c-8d15-746fcdfb23a6@redhat.com>

On Tue Dec 19, 2023 at 3:58 PM AEST, Thomas Huth wrote:
> On 16/12/2023 14.42, Nicholas Piggin wrote:
> > This performs 1000 migrations a tight loop to flush out simple issues
> > in the multiple-migration code.
> >=20
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > ---
> >   powerpc/Makefile.common |  1 +
> >   powerpc/migrate.c       | 64 ++++++++++++++++++++++++++++++++++++++++=
+
> >   2 files changed, 65 insertions(+)
> >   create mode 100644 powerpc/migrate.c
>
> You should likely add an entry to powerpc/unittests.cfg ...
> also, wouldn't it be better to extend the sprs.elf test for this, so that=
 it=20
> e.g. changes some stuff for each migration?

It was supposed to be kind of a dumb stress tester for the harness
that just runs as quickly as possible for a long time :) I'll see if
it can be massaged into something more useful.

sprs (and others) probably should get better migration stressing
when multi-migration support lands in the harness, but I was
thinking that could be follow up patches.

Thanks,
Nick

