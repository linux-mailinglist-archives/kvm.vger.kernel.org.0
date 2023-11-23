Return-Path: <kvm+bounces-2360-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A7CD7F5D2C
	for <lists+kvm@lfdr.de>; Thu, 23 Nov 2023 12:02:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BC1E41C20DD7
	for <lists+kvm@lfdr.de>; Thu, 23 Nov 2023 11:02:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8ABCA22EEA;
	Thu, 23 Nov 2023 11:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bshr63yz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBB191BE
	for <kvm@vger.kernel.org>; Thu, 23 Nov 2023 03:02:19 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id 2adb3069b0e04-507c5249d55so1016866e87.3
        for <kvm@vger.kernel.org>; Thu, 23 Nov 2023 03:02:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700737338; x=1701342138; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Gfb2pyY7+Jik+eLg1IQMwWMIiYixPrkdudSTWdU3l4s=;
        b=Bshr63yzxSTEZ2P0+pUhvt7brKfoqaaab7/7zPrvzYxTYX9UNpOdk1QLhNjOxC1fYj
         Rw9rSrJQU6Sbwg5rnbcWZOQRbgO89ppjzTdP85Fclo/5PCWcmuJ1KhzIqvdZSZlgdJZ7
         ShtvqF3FLDyKsWYXMJ3GoaFqtPkUgqmDISM9he8XnHSniSz6AmM551qBdAX5RcxG/5to
         OmAkItRo+TFwLqehZsd2FYKSFa4EY1yTDn9/1BSD7aVDSdOA15zK7r/GYXuO6GVU9FV4
         KFTvmW2AePA0nRMh4eWAnxyo6DyPiiOBMp7LzawB7nrUu6Pciswj+OsQT4PelhhAL4LZ
         OX3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700737338; x=1701342138;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Gfb2pyY7+Jik+eLg1IQMwWMIiYixPrkdudSTWdU3l4s=;
        b=Scfj6x2u5bH3JqN9jJc4MvPdsn1I2Hs1NOr76arCcOeZsXh9L6LhzaHD5Mf1GtMmKB
         14fgQxY1ay5uN5X8NxuTwuNTCUpBowVksU8eNxZrTNKJLcc0at+kC6Cs0m+cdGOICvNC
         lKkvxpsgF29LMdELTkiCc83Joxl+6e8yx2UpDU24x3LmtfSGTxNBoNiCJ2CqKh12os/Y
         qlazLGeF8Vq3K9M3wxttv///gvc8NR05fYDgHRytX+7pkBfolN8GtBihL+xI3w0XfAlv
         5P8Lba/juF4b5yidq0rmYHjwOqlNMG70pGLZrZef/l4PJmXr060biethp/XcA9F5nLcI
         xgwA==
X-Gm-Message-State: AOJu0YwHGKDdJL4h8yVwztIr8Qpbq/P0s1FRce5Z/cwQyQX7DhS6BSWx
	mkxR634mRWFaHVYjvPMCoThvVXoYZIUYAJfRNWxuDecJ
X-Google-Smtp-Source: AGHT+IEzSVSKSwMJTnyWITZ2bdkETAAfNN/3Vp7tZVFSEX2j7dZcMmW8RjkjyEnBHt1dg6Sgatz0DI17xj9bwgMFpjk=
X-Received: by 2002:ac2:4469:0:b0:4fe:1681:9377 with SMTP id
 y9-20020ac24469000000b004fe16819377mr1967480lfl.44.1700737337752; Thu, 23 Nov
 2023 03:02:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: "Y.G Kumar" <ygkumar17@gmail.com>
Date: Thu, 23 Nov 2023 16:32:05 +0530
Message-ID: <CAD4ZjH0DUZ786FoRNSfXG7sBKZSXnOi+WC+ZABxzD01MMY=cgA@mail.gmail.com>
Subject: Cpu steal
To: kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi All,

This is just a one-off query. Is there a way in kvm hypervisor as of
now, to find the cpu steal time of a virtual machine from outside it
as opposed to from within the vm ? Please give me your opinions ..


Thanks
Kumar

