Return-Path: <kvm+bounces-5951-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2763382916F
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 01:31:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AD1081F2193D
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 00:31:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A076BDF5A;
	Wed, 10 Jan 2024 00:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Fs+/wHzk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B74DF43
	for <kvm@vger.kernel.org>; Wed, 10 Jan 2024 00:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-59891129fadso251063eaf.0
        for <kvm@vger.kernel.org>; Tue, 09 Jan 2024 16:30:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1704846635; x=1705451435; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=hydUMmuVdsM+xqnQN7tr5qDIW845G9/kDGXr3I1q0uA=;
        b=Fs+/wHzkEp6B5xScZUi1zopWGXYbMnbzZyVhHT6xdhgnLMkdaMSUPtt8sHwW3Ybc7Y
         +l1GySinFdoXArEAEQ8fhFLxGBQCISQ8bUsQO2JYgHMgkmHp2Um83T9Udrq1EanHjJ04
         h/eVifJhG/LGFWWbP28EyOYPlqyALM/3r5a/Glo9zr6KcsBeOiW9KhRtFZlaHmrmnt5T
         JQnAbESw1PvXG/64URrWwE903Hr+CsJlD+QFUybu35TY1pGdF9pRVd+dUmKrsYhPCgbh
         9sM62ZqDWuIlms4+imvy7Tt6aJr22rNHPew2UYS+yGV8NtpcMDE5YgUcJop41GTCNC6+
         ZNhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704846635; x=1705451435;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hydUMmuVdsM+xqnQN7tr5qDIW845G9/kDGXr3I1q0uA=;
        b=GY3/V+wACgzyYH+gIR7l0E2jeknra9m7kDW+0MrKVjnTYS/RzJWrACv66kw5dcmPXx
         d0T/5jmrT0MkVsGUb1solGb4WGBX6+gm3adWWiBLlp0/Ws8lEVFDINcckoPs3F4k/swh
         Bqalfnay4bnGxYds+BHp6L2vdvLpKJITs+C0Z419CppMTEwOqtsVFIuDiVFQHwKs9m+W
         5D59FLMWGfzmqJYtb7FfGWpd/OeGCP4Fp8oyN6lNiAj8KKAOvnu/A8MqojKOXpH97T8T
         JAw9PIQz2CineSO9T2vg/A0tfs7jWXfmRDLzMBSi79lvlL/FoTiTQkbuuWt+bJk3C5MY
         vhWw==
X-Gm-Message-State: AOJu0YwViUz3L3ZS2upEYDyoFa4QmLBgw0WsPg7n4FKCZxj5aHsJRXDI
	VZ60yeisl1CCrTPDS0jio5dC6j08dJtU6A==
X-Google-Smtp-Source: AGHT+IGd3/cM7ZrFhiVYvwfc0Y76IaBSzRqPp92itBTH6fQc7rmHNMmxSWmkA8xyVc6ek4bMpmPsBw==
X-Received: by 2002:a05:6358:338c:b0:170:c91a:b466 with SMTP id i12-20020a056358338c00b00170c91ab466mr196482rwd.23.1704846634679;
        Tue, 09 Jan 2024 16:30:34 -0800 (PST)
Received: from dev-mattc2.dev.purestorage.com ([208.88.159.128])
        by smtp.googlemail.com with ESMTPSA id ln15-20020a056a003ccf00b006db0907e696sm2165649pfb.6.2024.01.09.16.30.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jan 2024 16:30:34 -0800 (PST)
From: Matthew W Carlis <mattc@purestorage.com>
To: alex.williamson@redhat.com
Cc: jgg@nvidia.com,
	kvm@vger.kernel.org,
	mattc@purestorage.com
Subject: [PATCH 1/1] vfio/pci: Log/indicate devices being bound & unbound.
Date: Tue,  9 Jan 2024 17:30:28 -0700
Message-Id: <20240110003028.2428-1-mattc@purestorage.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20231223163802.4098b07a.alex.williamson@redhat.com>
References: <20231223163802.4098b07a.alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

In my case I was interested in something that would allow a human to triage
it after the fact and potentially many reboots later. In our use cases we assume
the correct things will have been bound & its really the exception when they haven't
been, but stil it was desireable information. In one sense it was just easier to
add the logging to the kernel than it would be to get from udev. I think the kernel
log must also be a more familiar source to most than udev.

