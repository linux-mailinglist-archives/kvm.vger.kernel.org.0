Return-Path: <kvm+bounces-1118-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 740797E4E45
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 01:51:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E03428159E
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 00:51:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97D26641;
	Wed,  8 Nov 2023 00:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="B8vWVlrX"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2033F634
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 00:51:07 +0000 (UTC)
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 898E810FE
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 16:51:06 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5be6d0a23beso1328337b3.1
        for <kvm@vger.kernel.org>; Tue, 07 Nov 2023 16:51:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699404666; x=1700009466; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MAswuKJcd6AlQMRzBy2s9uqCImq2rSuUz85xbiYFFFE=;
        b=B8vWVlrXRaXCQUJ27IvE8OA30ivGjhelEWD+cmu0zbbzdb1tjAG2Goe5Rahdz5GGKz
         wVafIONj6ocguiP/EC4qMDshy9nhAzX6Qm8jEUyYedpv7x9Z0k87+xnaHwA0X/jyC1Bl
         6UGiP2oNGlwQcy8qJNkkcWTIBJaF9DxwXr7oWtjbhiLvT7J1hLdOUlPzoaBa9XnB8siX
         ISgKpcD0ZtFFiNR8XnwC30bVYZhx4uDmhLc6kkBc36QQ+1GKRqxhXSMY+M/9To19N+lY
         u+LFvv4EGBinWiSAgBK3KtMlSO6oAj052VQCUkhKK6T7FWhuXooBYD8EgB6MlDpRqByj
         CXMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699404666; x=1700009466;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MAswuKJcd6AlQMRzBy2s9uqCImq2rSuUz85xbiYFFFE=;
        b=AIepmzpUTZ3iRd1EQq714JFll+eMb1OMAp3GPO9izvT0w5gDVxH3NPVj37jnwxtNy6
         ajl8YCFzWOZuUmuQ41v6q9Q1DL9Y9WXq1T/RngfUrNTkZHDPepL6C4W8tT/lavBA6urr
         UdRlacS2k0sqTWHfLzFcuL+bG43wALqO+w9L8luckqVkHbmqR5PYwYrXt/ZR9rsvX2k0
         dgygCyl9D8vPqQzC58JrP25Zpeh9xVU5HRbJihmW4InfN7HF3wu0FyODwKXggMWfPD07
         50QITjycpa4bHA/61uwguZju39/RCOqmL5wNrdOnP6mi6uV7jBnbe7b7EVYyUqIIlnzM
         F5nw==
X-Gm-Message-State: AOJu0YzkInqO8B7kZbqeR2KBhpoS2PPZE+KjKP0zC3kiUdOsdRsOI8JA
	SSLIPk3dBQ5y4EaTR7//RDxCD6Tw2wo=
X-Google-Smtp-Source: AGHT+IGKJr5DObBJmipJMinpzOP1HKYoNosAsft8sFHuxt2lp8/YQ/OIVwc55JA720d1mQ34cqOsEEBdzek=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:88f:b0:5a7:d45d:1223 with SMTP id
 cd15-20020a05690c088f00b005a7d45d1223mr107627ywb.3.1699404665831; Tue, 07 Nov
 2023 16:51:05 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  7 Nov 2023 16:51:03 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231108005103.554718-1-seanjc@google.com>
Subject: [ANNOUNCE] PUCK Agenda - 2023.11.08 - No topic, but still a go
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

No official topic, but I'll be online.

Note!  Daylight savings, a.k.a. the worst idea ever, ended this past weekend for
me, so my 6am might be a different than your usual time depending on where you are.

Note #2, PUCK is canceled for the next two weeks, 11.15 and 11.22, as I'll be at
LPC next week and OOO the week after.

