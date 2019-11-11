Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBF28F74C1
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 14:26:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbfKKNZq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 08:25:46 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33847 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726832AbfKKNZq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Nov 2019 08:25:46 -0500
Received: by mail-wr1-f66.google.com with SMTP id e6so14695008wrw.1;
        Mon, 11 Nov 2019 05:25:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=u3CoHNh7IQCIJE14gCTOqxD+2t322eDV5uttrHyFEEY=;
        b=hYC+6N6M3p+UrmV46pZp15EqE7ogI53gVUeIQYy5+mSy+6/NjQU8Wd22/93cgbSOX+
         g5r08+bZRKbZQKbh2ZDTJzDQBIC9jYw25vWe3jueG7uTr17CVlC4NApXErk79qe2Vk/t
         NJCQnXHzbEok6QExXsbv38gqrEnNN/pxwqStN+diUypV5+7nhucjXkD39Js4HdMBQdiB
         /k2lWTB+8Bqq8YtJHWeSZSlxliDhDZ3nJe08HUAt02DhJYvBO/HmdyZ/IVJAk52AmGVe
         sbsb9Vs74Ap20wnfTpYxP15LjIErAkEUzWK9YPtK3CnFrhq204CGYltrQzfAaPuTKIKy
         HA2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=u3CoHNh7IQCIJE14gCTOqxD+2t322eDV5uttrHyFEEY=;
        b=mzNP6LjSOPnHQnU47PuWDcgFsmF2gPrUlmZuIRUo5g+mfQQ5K6rPqcgfh+S+SeqB5E
         baoc/gUzwR06ERgrEu1n1skmQLKk6nGlHBuZ25PEVUsSu3+qWNXmVMw+0hKWh+ZfaznS
         UnDjAT8iUhfHJAtBhlEetn779Qe20aunFO/GR4zY25zJO9Tj3iW58PKM9ygjVcHQ9Gjq
         MAjtVhw822Jk0EvzThNA6/78Man4Xt5UFH0SE+QBWp7HKN80tEW4+xhCngLBHPBNj6SP
         UusVWWNtg0dEUD4ykZTzs9aan7RP7kEtIGnh9h+ISjPA/xg59dM2la7Qtzear3O4CMbN
         Hiew==
X-Gm-Message-State: APjAAAUUFaeHzzFXsovpTKPHoRDo1sDjfQbB0l1c0d5HDnRRva5XGFml
        NkmRKq6MuOJfOxcsQzdgmkZnEb46
X-Google-Smtp-Source: APXvYqyYD5tlz0OKY7P7QPLnJdMFBRyGMNUxDmoYTOS3E5u1KN9QRFMlpwTiWRH2nTR0/eg7YzoM4Q==
X-Received: by 2002:adf:f547:: with SMTP id j7mr21725532wrp.69.1573478743660;
        Mon, 11 Nov 2019 05:25:43 -0800 (PST)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id p1sm7555131wmc.38.2019.11.11.05.25.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Nov 2019 05:25:42 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     jmattson@google.com, wanpengli@tencent.com,
        Junaid Shahid <junaids@google.com>
Subject: [PATCH 0/2] KVM: fix issues with kvm_create_vm failures
Date:   Mon, 11 Nov 2019 14:25:39 +0100
Message-Id: <1573478741-30959-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix problems with the recent introduction of kvm_arch_destroy_vm
on VM creation failure.  An updated version of the patches already
sent by Wanpeng.

Paolo

Paolo Bonzini (2):
  KVM: Fix NULL-ptr defer after kvm_create_vm fails
  KVM: fix placement of refcount initialization

 virt/kvm/kvm_main.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

-- 
1.8.3.1

