Return-Path: <kvm+bounces-6267-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7208F82DDA7
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 17:33:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 20409282A77
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 16:33:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55E9017C6B;
	Mon, 15 Jan 2024 16:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l6qx4oFG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2D217C61
	for <kvm@vger.kernel.org>; Mon, 15 Jan 2024 16:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-595ac2b6c59so5283016eaf.2
        for <kvm@vger.kernel.org>; Mon, 15 Jan 2024 08:33:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705336391; x=1705941191; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=m507gAY0sa8GNq+MTSrkFdnXvyJZdKLbIGZHWnLl+GU=;
        b=l6qx4oFGd1pMArZUQagLwP1fWWTYrgPIGUVEWuDQmZBMusWJ+7sNB+RdbwUcH3vRS4
         5vRWdjPbuvQHOSuF+x+GO6WnUgkXQ6t4TsxOwiw0DFOkc8fIJZhuJizeSK0F8aZnwZrs
         iw7UBQvxjnHnAk308Wx+t/QbBlF11r1W6Uv3wwR2nNVgy23oiVjUEKv7CZ4fzpdHO/pu
         h5Z1X8iuv+iv/vq5lytEwvZuiCDDvlHuwjT2f0rSINLU2s/zcgE8tFJeW+WaUunUXwBD
         YpxlaTMIHUxWZkweRxd/+Ld8czLfrj8BHmoFF/LdFoSlkSKkyzbNlampnr/DN2MdoJqj
         IJkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705336391; x=1705941191;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=m507gAY0sa8GNq+MTSrkFdnXvyJZdKLbIGZHWnLl+GU=;
        b=Ka2aOGH0L8toO8YNR18VJjo2Nt+4CZINWPi1LuarTpQ2baiAlsoqlTr7rU+C52XrZc
         kEPl5ZjxIXgq6EVUopE4l9BHJEEGS4HJlG6Mz7Wlaen9oyRipXjqVwUUAg4w2L4YQaup
         M3ziYAQeyxpvqlrALjgjoAUbuOxMp1K2DhT9ZSDN04Jcb6OAqjell608Dtse/V6Hnfq8
         59MzLO83CVmVPUq8qo9sWPQoaLB/VlZPw2YrMAHm2N+3K4M3wkkFFq4K1R9rOGWENVPg
         lU8EdWjdaW28AOy99x0VxeycaI8KZJ662ztCu2Vunp5Y/2sRjoSVQ86GhtYhll/PyQaK
         ULhA==
X-Gm-Message-State: AOJu0Yz8BjShblItJ2Ufv3nbOhSQ0g1xP2fnYpl5uNFdpn/D8YTBYOdR
	3dNYhyTxwScCHXYYfqm2IXLRA85HcTXsXvWRcCE=
X-Google-Smtp-Source: AGHT+IF+y2lxeNbMNzsCPDpufaxEgmQZrcaYQtzGC301LkvfrCRNR8fmuVe0LUIujrhgFhgddydf7zgYHKXUpvsxwII=
X-Received: by 2002:a05:6820:220b:b0:598:a76d:e3b0 with SMTP id
 cj11-20020a056820220b00b00598a76de3b0mr2893196oob.19.1705336391001; Mon, 15
 Jan 2024 08:33:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Mon, 15 Jan 2024 11:32:59 -0500
Message-ID: <CAJSP0QX9TQ-=PD7apOamXvGW29VwJPfVNN2X5BsFLFoP2g6USg@mail.gmail.com>
Subject: Call for GSoC/Outreachy internship project ideas
To: qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>
Cc: Alberto Faria <afaria@redhat.com>, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	=?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	German Maglione <gmaglione@redhat.com>, =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, 
	"Richard W.M. Jones" <rjones@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>, Warner Losh <imp@bsdimp.com>, 
	=?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Huth <thuth@redhat.com>, 
	Daniel Henrique Barboza <danielhb413@gmail.com>, Song Gao <gaosong@loongson.cn>, 
	Akihiko Odaki <akihiko.odaki@daynix.com>, Bernhard Beschow <shentey@gmail.com>, 
	Nicholas Piggin <npiggin@gmail.com>, Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Dear QEMU and KVM communities,
QEMU will apply for the Google Summer of Code and Outreachy internship
programs again this year. Regular contributors can submit project
ideas that they'd like to mentor by replying to this email before
January 30th.

Internship programs
---------------------------
GSoC (https://summerofcode.withgoogle.com/) and Outreachy
(https://www.outreachy.org/) offer paid open source remote work
internships to eligible people wishing to participate in open source
development. QEMU has been part of these internship programs for many
years. Our mentors have enjoyed helping talented interns make their
first open source contributions and some former interns continue to
participate today.

Who can mentor
----------------------
Regular contributors to QEMU and KVM can participate as mentors.
Mentorship involves about 5 hours of time commitment per week to
communicate with the intern, review their patches, etc. Time is also
required during the intern selection phase to communicate with
applicants. Being a mentor is an opportunity to help someone get
started in open source development, will give you experience with
managing a project in a low-stakes environment, and a chance to
explore interesting technical ideas that you may not have time to
develop yourself.

How to propose your idea
----------------------------------
Reply to this email with the following project idea template filled in:

=== TITLE ===

'''Summary:''' Short description of the project

Detailed description of the project that explains the general idea,
including a list of high-level tasks that will be completed by the
project, and provides enough background for someone unfamiliar with
the codebase to do research. Typically 2 or 3 paragraphs.

'''Links:'''
* Wiki links to relevant material
* External links to mailing lists or web sites

'''Details:'''
* Skill level: beginner or intermediate or advanced
* Language: C/Python/Rust/etc

More information
----------------------
You can find out about the process we follow here:
Video: https://www.youtube.com/watch?v=xNVCX7YMUL8
Slides (PDF): https://vmsplice.net/~stefan/stefanha-kvm-forum-2016.pdf

The QEMU wiki page for GSoC 2024 is now available:
https://wiki.qemu.org/Google_Summer_of_Code_2024

Thanks,
Stefan

