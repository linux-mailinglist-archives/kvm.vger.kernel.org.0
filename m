Return-Path: <kvm+bounces-51388-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D519AF6C74
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 10:10:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8163C3B7E05
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 08:10:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0F602C08A1;
	Thu,  3 Jul 2025 08:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=stratzo.pl header.i=@stratzo.pl header.b="gTmTelrX"
X-Original-To: kvm@vger.kernel.org
Received: from mail.stratzo.pl (mail.stratzo.pl [217.61.16.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CBB94C7F
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 08:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.61.16.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751530222; cv=none; b=C3FjpF6hwDdKX0B6eFSw5T1zs6fFB7FFjFUwIGQmbWr2hrIVAoggx0beK/DBPMVCN+zgsuIJ92f/Nak8EXbz0TfhHAuDmXK+2u01XChR/eY6ygmpc5KRMevqsNBP38S/lu0nOhsZqD5FJBmDSuKAgSoCTHh6aktQn17y5b5aYv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751530222; c=relaxed/simple;
	bh=XkLiuw2ccZ39/zggVt86AWdDg6D/HA/iSUo8ZV8h+sk=;
	h=Message-ID:Date:From:To:Subject:MIME-Version:Content-Type; b=brH5nJYWIPb2gK7SByNnI2e7hEXJs0NlDS5I/fmADW/cDKCnewWueFWO1GyHRskZB3BBrbkAO5nWLVCWm9StGlKaxyV9fbIperP02eV4MJd1JNkLBVRSH9xHLvJrfRIPHxB+VvyyP0Rh52Dm/XPEuI1dSteUhkDZCS6yl9mgFr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=stratzo.pl; spf=pass smtp.mailfrom=stratzo.pl; dkim=pass (2048-bit key) header.d=stratzo.pl header.i=@stratzo.pl header.b=gTmTelrX; arc=none smtp.client-ip=217.61.16.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=stratzo.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stratzo.pl
Received: by mail.stratzo.pl (Postfix, from userid 1002)
	id E3BB586B0F; Thu,  3 Jul 2025 09:56:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stratzo.pl; s=mail;
	t=1751529443; bh=XkLiuw2ccZ39/zggVt86AWdDg6D/HA/iSUo8ZV8h+sk=;
	h=Date:From:To:Subject:From;
	b=gTmTelrXNrR0jbiqbr/H7YVgW5SBNQSVtZnw7es3CFG6o3G5dGczEZLCDX5qacA92
	 c2gseGwHl9S41XO1+tG6hCl+cZ+tf2yxrE7ajNBKebfabJToi5FmtIAPztlKxnFq+o
	 2xZ2BSQA+wZ7xz47XfacXK+cpmYdhhn2Iwrz8rWH1WtxBq1/Z73QYNE2RhXAE+ufBZ
	 CviKIOvqFjwohNjTfoT4qsZS1qvYCH8vCSDIac2GuIkYdZhYufM+I8Dx/yS9JuyfPh
	 ocMVEVsy0PQlXxOXJIQGZb33PWsv3bXPj07tS81rdo+3vXb9NPaMZcjrSYg69qofww
	 i5T+jNH7aIQug==
Received: by mail.stratzo.pl for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 07:56:10 GMT
Message-ID: <20250703084501-0.1.27.cxsm.0.0ld7c96skg@stratzo.pl>
Date: Thu,  3 Jul 2025 07:56:10 GMT
From: "Kamil Brunatowski" <kamil.brunatowski@stratzo.pl>
To: <kvm@vger.kernel.org>
Subject: IT bez rekrutacji
X-Mailer: mail.stratzo.pl
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Cze=C5=9B=C4=87,

wiem, =C5=BCe rozw=C3=B3j oprogramowania to dzi=C5=9B nie tylko kwestia t=
echnologii, ale tempa i dost=C4=99pno=C5=9Bci odpowiednich ludzi.=20

Je=C5=9Bli temat dotyczy r=C3=B3wnie=C5=BC Pa=C5=84stwa zespo=C5=82u, by=C4=
=87 mo=C5=BCe warto porozmawia=C4=87 o wsp=C3=B3=C5=82pracy, w kt=C3=B3re=
j to my przejmujemy ca=C5=82y proces tworzenia oprogramowania =E2=80=93 o=
d analizy po utrzymanie. Pracujemy elastycznie, dostosowuj=C4=85c si=C4=99=
 do wewn=C4=99trznych procedur i Waszego stacku technologicznego.

Dzia=C5=82amy tak, jakby=C5=9Bmy byli cz=C4=99=C5=9Bci=C4=85 zespo=C5=82u=
, ale bez operacyjnego ci=C4=99=C5=BCaru, ryzyka kosztownych rekrutacji, =
z elastycznym podej=C5=9Bciem i transparentnym modelem rozlicze=C5=84.

Czy jeste=C5=9Bcie Pa=C5=84stwo zainteresowani pog=C5=82=C4=99bieniem tem=
atu?


Pozdrawiam
Kamil Brunatowski

