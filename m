Return-Path: <kvm+bounces-4089-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 22BC280D470
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 18:49:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 54CD91C2178E
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 17:49:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2695F4EB46;
	Mon, 11 Dec 2023 17:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LoVl64DK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8127FC3
	for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 09:49:40 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-dbcad3c1b70so522887276.0
        for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 09:49:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702316979; x=1702921779; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PD4uUBn0YrczoWxlhIt/RaQw+8ZUjArWaAoFtxYQibs=;
        b=LoVl64DKL/uLggQXwWKmK5BOSOGk1xBpRBZsdQ+6bL5OW1U136GD5QZjuN+N7Dqybr
         n+Gh+IPjUV/6LYaspAEBa70k3BFpM0xLw1KhGdw86LEhLTgKylkm636a0oFEzv81UXu0
         AmIzm5OGmwzEfOIzjWJNbJF4EcNPTmxy2pHVBlmNJ8XxAtmxV7dlNkVGTtpV6z+kqNyh
         vAmk8bGkqiESIjLRvZoUxzQUwR74xBy1g83tecDx/AyrAZsA5IInAyrOO+N/A8cG77KI
         3wUN0OVro4Xsiku9bESV/bVEajIwKV1AOUlnjqGpY4dCyis0oIA7Az4L6RnT3CSm/VaV
         cPPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702316979; x=1702921779;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PD4uUBn0YrczoWxlhIt/RaQw+8ZUjArWaAoFtxYQibs=;
        b=e1I2Gag3+mles1mRxEQrMEDzQrTLxdzcydW2Ba7SfEyt/N5eY6NXywKiuF3ClXnC5z
         x0SUc/YszZXmUDmQlawvDaYCxMmLUvIkxeJ2Ov/Xv6i+d826dEhK28So6Fnkf0ymPBLD
         Eml/SBpsQ5dXMFJVov3LrjfYKojTez1vV+GJhYySdtwwPholtDRx6hvDJSh1OU0qomeZ
         ccBsfuFCh90KNfBcTM73BuhE67vRXBGvOyXntd00Xj+i2CQwJSjQ3kOJy6Uvu1+qdV5+
         /hiFiD3RNpCZ9BRLcEHXi1M0nfqy+HqcCN6RU0bztbNlGqYEAW+9EybbVvo+lxrxTxta
         nKbg==
X-Gm-Message-State: AOJu0YzNwPvGQ2tP4VGki6u2V4aiRbL//R6kkXK/kG4DpMLIFqcqSEOV
	wt5oDKLyTIn8GPGEiDSE5dKKey2LWz8=
X-Google-Smtp-Source: AGHT+IFKl2rS1vD/lL3s8aIyMZ058IVAAiNTpwfw4dqckX0k3J8fVvuHgdqmRgVwbCkxi+5PiutTudxK29M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a5b:f08:0:b0:dae:49a3:ae23 with SMTP id
 x8-20020a5b0f08000000b00dae49a3ae23mr36764ybr.7.1702316979721; Mon, 11 Dec
 2023 09:49:39 -0800 (PST)
Date: Mon, 11 Dec 2023 09:49:38 -0800
In-Reply-To: <20231211085956.25bedfe4@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231211085956.25bedfe4@canb.auug.org.au>
Message-ID: <ZXdLsg1tN4DfBBSy@google.com>
Subject: Re: linux-next: duplicate patches in the kvm tree
From: Sean Christopherson <seanjc@google.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	Linux Next Mailing List <linux-next@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Mon, Dec 11, 2023, Stephen Rothwell wrote:
> Hi all,
> 
> The following commits are also in Linus Torvalds' tree as different
> commits (but the same patches):
> 
>   3b99d46a1170 ("KVM: selftests: Actually print out magic token in NX hugepages skip message")
>   fc6543bb55d4 ("KVM: selftests: add -MP to CFLAGS")
> 
> These are commits
> 
>   4a073e813477 ("KVM: selftests: Actually print out magic token in NX hugepages skip message")
>   96f124015f82 ("KVM: selftests: add -MP to CFLAGS")
> 
> in Linus' tree.

This is my bad, I used the wrong base for a selftests branch.  My understanding
is that we're just going to eat the duplicate commits.

