Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3455ABDE13
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 14:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405533AbfIYMcI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 08:32:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44904 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405285AbfIYMcI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 08:32:08 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2E8C28831E
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 12:32:08 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id z1so2294859wrw.21
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 05:32:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kyLMJ3IhBQ/KpFze3QzLZB6SEbGnQdB46N0jJl2qPwg=;
        b=J/Huos0ZbPGKuMeEPYsPGDxj/+eYIPeQs+/t/REV9ir0ASWhjXIzx8lNkQf1DVlIhm
         lUzY9jcasisD5Kjc+d0ghErFr0dBa05kdo/T3xxEL00YAckGvWXYYJxxiiGLBWoYLy03
         D5B7V9brW/YU9LB7GR15RYtX4xLDoI2jCgme2E+Jtp/+ajR60SIWX4Bk2uXxmhN73e4h
         VnyNdxjcUcdHTpLXen67khAtoxcVU5VkVl4QDqHJcDYa8ZbBTb9t60hkiBsDIpFbc+Mv
         Fv5J8De4UjvNdAZuPM8ZQkdUiGYJlzzX+1EXi8Uy+wn75oxmRaKNraycpl3Jl2HdnGNy
         hqRQ==
X-Gm-Message-State: APjAAAXN0jHuuZXxLHezl3lGJ2m08ZLqnFDQQcn53JBbK/q45eR3y6iA
        Xt+sATS9lnfrYH1VDWev2FolbXos+OWyqtKyQ34aNOgF7GSLq7tofNltxipPEBH9WaqBmEGmknV
        1rHxTrdDJYC+T
X-Received: by 2002:a7b:ce0a:: with SMTP id m10mr7859785wmc.167.1569414726841;
        Wed, 25 Sep 2019 05:32:06 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwKjlR2ia1Y9ZKlmqsbyOzcgRtrJABz/Vgz4TcIr3R6RRJx/MZeMRO0KhB+sAIvQka1CSaz2Q==
X-Received: by 2002:a7b:ce0a:: with SMTP id m10mr7859752wmc.167.1569414726561;
        Wed, 25 Sep 2019 05:32:06 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id d4sm3814633wrq.22.2019.09.25.05.32.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Sep 2019 05:32:05 -0700 (PDT)
Subject: Re: [PATCH 07/17] KVM: monolithic: x86: adjust the section prefixes
To:     Andrea Arcangeli <aarcange@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190920212509.2578-1-aarcange@redhat.com>
 <20190920212509.2578-8-aarcange@redhat.com>
 <2171e409-487f-6408-e037-3abc0b9aa312@redhat.com>
 <20190925121330.GA13637@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <d621c8d7-ffc0-5d92-eacc-5af2d296b810@redhat.com>
Date:   Wed, 25 Sep 2019 14:32:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190925121330.GA13637@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/09/19 14:13, Andrea Arcangeli wrote:
> 
> The __exit removed from unsetup is because kvm_arch_hardware_unsetup
> is called by kvm_init, so unless somehow kvm_init can go in the exit
> section and be dropped too during the final kernel link (which would
> prevent KVM to initialize in the first place at kernel boot), it's not
> feasible to call a function located in the exit section and dropped
> during the kernel link from there.
> 
> As far as I can tell with upstream KVM if you hit the
> kvm_arch_hardware_unsetup function during kvm_init error path it'll
> crash the kernel at boot because of it.
> 
> Removing __exit fixes that potential upstream crash and upstream bug.

You're right.

> The comment header was short, I'll add more commentary to the commit
> header to reduce the confusion about why removing __exit is needed.

Yes, thanks!

Paolo
