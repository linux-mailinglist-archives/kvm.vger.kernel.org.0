Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C578268644
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 11:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729512AbfGOJZE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 05:25:04 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35700 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729376AbfGOJZE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jul 2019 05:25:04 -0400
Received: by mail-wm1-f68.google.com with SMTP id l2so14412265wmg.0
        for <kvm@vger.kernel.org>; Mon, 15 Jul 2019 02:25:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sboa60kAGx4FM7+ZdR/J+yo2KeEdT1Mg8k+K0kVN7+8=;
        b=DlMcjiEqn5bDGrfR5HHRuaPMtSzCnHqkkXb/fOfnpFShdlF6yBnFr2oxYmyKUIGlvS
         1VJXq/0hA/AJK9awPT4UG/83nDXdoioVguXcesg1pCQhGYf/NyZ5sCfTQ7H3ng89WRQI
         uJkQGtZgVNFMQD/vXk7nAsKCNZUtDYfCyRDDVvr9pO3b+rv9H2L5CfPSFmZ1XA9XBDiv
         4a1JfQbVeiUac7iwFOYS9alZNmxoGBXw/rsDf2I6PlI1J0Mq90QM53xhI0YdxyZoL+R4
         GS4rifOQWGESj5BtQzcPFjAGR3ItacfMKoWWwOfC5/RZUfauVHtX74PyNEaLRjd6qcAS
         dGrQ==
X-Gm-Message-State: APjAAAUKXVuSvO6N8Qi+9wIVnonrj5A9tWur9oSeuTsnsE1v4i7jztkG
        W9yo5vnz9jVrOxNJ789XrfDofA==
X-Google-Smtp-Source: APXvYqxAtgnMbAOfPsZD6XPwZuy6QtYj9Aqb5hpyt5zQD9vzvm25PhbKiephOvksBnge8FUjjh8WBg==
X-Received: by 2002:a05:600c:212:: with SMTP id 18mr23010974wmi.88.1563182702251;
        Mon, 15 Jul 2019 02:25:02 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e983:8394:d6:a612? ([2001:b07:6468:f312:e983:8394:d6:a612])
        by smtp.gmail.com with ESMTPSA id c11sm28105171wrq.45.2019.07.15.02.25.01
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Jul 2019 02:25:01 -0700 (PDT)
Subject: Re: [PATCH 4/4] target/i386: kvm: Demand nested migration kernel
 capabilities only when vCPU may have enabled VMX
To:     Liran Alon <liran.alon@oracle.com>, qemu-devel@nongnu.org
Cc:     ehabkost@redhat.com, kvm@vger.kernel.org,
        Joao Martins <joao.m.martins@oracle.com>
References: <20190705210636.3095-1-liran.alon@oracle.com>
 <20190705210636.3095-5-liran.alon@oracle.com>
 <8423C5FD-2F44-48B8-8E1F-A2E8D62E8F2B@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <e1e48ece-b571-5229-589d-3525f505887f@redhat.com>
Date:   Mon, 15 Jul 2019 11:25:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <8423C5FD-2F44-48B8-8E1F-A2E8D62E8F2B@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/07/19 11:20, Liran Alon wrote:
> Gentle ping.
> 
> Should this be considered to be merged into QEMU even though QEMU is now in hard freeze?
> As it touches a mechanism which is already merged but too restricted.

Yes, I have it queued and will send the pull request later today.

Paolo

> Anyway, I would like this to be reviewed even if it’s merged is delayed for early feedback.
> 
> Thanks,
> -Liran

