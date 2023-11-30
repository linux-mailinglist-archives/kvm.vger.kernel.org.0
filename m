Return-Path: <kvm+bounces-2833-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 020A67FE65D
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 02:44:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B14702821A9
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 01:44:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91890E541;
	Thu, 30 Nov 2023 01:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="reudPNSd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44D4C10F9
	for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 17:44:32 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5cf4696e202so7024387b3.2
        for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 17:44:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701308671; x=1701913471; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lIh510cpMHfh3TBI1frcYo4YiRPmPneVHA94hyn0mXc=;
        b=reudPNSdD+Y5u+i1xfvLIpmXjjjpu0mXb7sUbxg1gab/NxtdH8s+aLXp4IMr+QAPdw
         jOV7HjwoY/bGWO/DHZ6WE2f93CySxGq9JHn9kwMMZSOqZBOlTzp9rpBW57uAq5B2jtal
         z4Hr+CXinBclqFwP6XiFPKaTeFzuu2sz635Qb35+1S7hl+f+AOKxL6mdtGZrAj5h4kEc
         xW+lW0f16GDcYqmDPm+9rMjGjWIJb1+SejsiWj0KepMiUyUps3tcrWBETCugBrAePsHN
         c1dD6Zdg2N8DzaJjqAoPzhJQSZVg4+En6vGoBY/zO78el7eNVK1VqgqI8feqUDJp1IGx
         h1Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701308671; x=1701913471;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lIh510cpMHfh3TBI1frcYo4YiRPmPneVHA94hyn0mXc=;
        b=Oc2vRUU5OGRAMcwmc0ZDDYBoQXvj8+RFrErg196OOXA0zIk+YU0qtZs/jk3C2EHFfa
         BmdWbRrSL54K4yGYgw/VblkUDWmTM7oLZN/BpOxtnMcLMFPkmGMbON/p5Q/2AaPFbNmP
         UBcJASUSnD+TXgaDli7LDSXAyENs3BLsoCR8U9dgRxJC3kobwBotKRvKH2Ir+r7thfeh
         1TwBUZWYLfmgXc1hQKFbBc6990bKvkJTEZSyqAox4O5nQctT3UBWc0Eh9IiviJDBZW9s
         4b2LLBVU9KMNHX9bTXWspRgmd5RrFSZqVpCxDKsO0Z2T8t8tJAQNBx1Lfi6Nk2ZO1uZC
         6lQQ==
X-Gm-Message-State: AOJu0YzWp8K0dEnPO2OTRCMXYFaZGAIjsOs/SU9+Xx0sXb0cchBDrBXW
	yH+srLc1g2ez0WwrkLBHkjenEl4chMI=
X-Google-Smtp-Source: AGHT+IF0+6CDCMesMb0RO3PcrV94LZtjPZHEQAI+diEFrXVS+tB63G2kCA++hrLRPuC3DQA7tBO4x6A+Kg8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:2c05:b0:5bf:5b75:ff91 with SMTP id
 eo5-20020a05690c2c0500b005bf5b75ff91mr525978ywb.4.1701308671263; Wed, 29 Nov
 2023 17:44:31 -0800 (PST)
Date: Wed, 29 Nov 2023 17:44:11 -0800
In-Reply-To: <20230815220030.560372-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230815220030.560372-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.rc1.413.gea7ed67945-goog
Message-ID: <170129841796.533238.1884968868194664460.b4-ty@google.com>
Subject: Re: [PATCH] KVM: selftests: Remove x86's so called "MMIO warning" test
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Michal Luczaj <mhal@rbox.co>
Content-Type: text/plain; charset="utf-8"

On Tue, 15 Aug 2023 15:00:30 -0700, Sean Christopherson wrote:
> Remove x86's mmio_warning_test, as it is unnecessarily complex (there's no
> reason to fork, spawn threads, initialize srand(), etc..), unnecessarily
> restrictive (triggering triple fault is not unique to Intel CPUs without
> unrestricted guest), and provides no meaningful coverage beyond what
> basic fuzzing can achieve (running a vCPU with garbage is fuzzing's bread
> and butter).
> 
> [...]

Applied to kvm-x86 selftests, thanks!

[1/1] KVM: selftests: Remove x86's so called "MMIO warning" test
      https://github.com/kvm-x86/linux/commit/e29f5d0c3c7c

--
https://github.com/kvm-x86/linux/tree/next

