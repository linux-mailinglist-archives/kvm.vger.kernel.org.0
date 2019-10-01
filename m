Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76EE5C35B5
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 15:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388509AbfJANag (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Oct 2019 09:30:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42496 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726710AbfJANag (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Oct 2019 09:30:36 -0400
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B9F272026F
        for <kvm@vger.kernel.org>; Tue,  1 Oct 2019 13:30:35 +0000 (UTC)
Received: by mail-wm1-f72.google.com with SMTP id q9so1412922wmj.9
        for <kvm@vger.kernel.org>; Tue, 01 Oct 2019 06:30:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BuheqY/f1O8hT7ejzmcdMbupLoR6grwp9uDRC8131O8=;
        b=ece7Dj+1gfzffO4oTNMWVBtmSandAJyW2hQqmXr1xJbLsyAGDGrH6zY8K1c64U89dB
         eZ1W5+d9eNHyf5C77Xo+prrXkHM4t/DVzpvoZTiy7BnnEQNQP8c8RIBv3ZaD3CNll8qD
         CQMjEAMxL6txtLb0EysIK9w09rI/SrdFjLTz41tImjzaNlvVHv0Cn/ETgqP1c4oVuwXV
         JWfgdqGwupPqQFGotfH5LI4giL2ARKyjbngzL3oEwkW8Z5IeSkCeupMubGNyW9JG1+Ld
         U46jeMQgusXcQq2ewxhUohuaDRF0OE7Zmsi9XEC+J8k0XXCEBarvklQZ5o7KIjgnVZiT
         iJjw==
X-Gm-Message-State: APjAAAU4ww7vK7hQELSjW0WZMnbEKf4SGL50P4hM5p0SyNX/O2c3WCLu
        ZX6wM77TCcDqqQJ4KcCthmi+wJLxdjGTP7VWL7bKP2QXVveuZy538GQtokrPDZBfqEJlFmEryZw
        1fM18tuotdu/E
X-Received: by 2002:adf:cf0c:: with SMTP id o12mr17650024wrj.30.1569936634180;
        Tue, 01 Oct 2019 06:30:34 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyLoU8SG3DZmYpn/Y9/DQvwMyh6yTzew4TWcr6TUqtstV6yqJctofHmHyf+BOjVolXCznTz8g==
X-Received: by 2002:adf:cf0c:: with SMTP id o12mr17649991wrj.30.1569936633924;
        Tue, 01 Oct 2019 06:30:33 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:dd94:29a5:6c08:c3b5? ([2001:b07:6468:f312:dd94:29a5:6c08:c3b5])
        by smtp.gmail.com with ESMTPSA id u22sm21010957wru.72.2019.10.01.06.30.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Oct 2019 06:30:33 -0700 (PDT)
Subject: Re: [PATCH 0/4] KVM/arm updates for 5.4-rc2
To:     Marc Zyngier <maz@kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     Andrew Jones <drjones@redhat.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
References: <20191001092038.17097-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <52252764-5dd5-38ff-bbde-9cf92abf6c05@redhat.com>
Date:   Tue, 1 Oct 2019 15:30:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191001092038.17097-1-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/10/19 11:20, Marc Zyngier wrote:
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.4-1

Pulled, thanks.

Paolo
