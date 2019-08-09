Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFE7387E66
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 17:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436806AbfHIPrN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 11:47:13 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38278 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbfHIPrN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Aug 2019 11:47:13 -0400
Received: by mail-wr1-f67.google.com with SMTP id g17so98672067wrr.5
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2019 08:47:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=//yT3qJ8WuM03AEopdit51IEjFSTwNzla/34blwGVms=;
        b=FdXIGvlKzyGthrwX0vDyQIMM3AzhQ7/jxiRIfeoYVxywwBWb71LeLdm/slpxs5bHoT
         1exJ/9yGPChEFKjQYDN99oAfQXeAVhzghSH5IzXyhgAA4ZObZaurSlzZPaq8MaNciF/I
         3bptJBNXR+6CzpFX1kMm0hFEJVwedIDCy2aYFEWvObRveG3aw4r9m68ZV+HKWTm5t8lW
         mYEYd3GXSO6XAvqaY3o9taNkgI4QAj6aCg1uhJ55tYOD+o43RPbVrqogzTTFrn1Dbms6
         7EV7kjgihXcvA8OFRPkInuc91FBMmOm8CdbRK9k2QZvtNQdPXUtrXNEKaT1/aBemZk/F
         hwnw==
X-Gm-Message-State: APjAAAXlrm1oEkqFSLIg8EjWLLUKh4xIiKeMzW9Ap8TWBLpTOxcnElVd
        rsAu9LCz6pKjl2Zu2VcALOf5qdywpQc=
X-Google-Smtp-Source: APXvYqwMa058GcHnbYlQie7XSJJGnWJhLkCr/dR0jJdaNszGDMBL8D3HgdiIM/Wds/e4MYbYyG3u/w==
X-Received: by 2002:adf:dd0f:: with SMTP id a15mr7416971wrm.265.1565365630847;
        Fri, 09 Aug 2019 08:47:10 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9418:b1e8:9e8b:8c2f? ([2001:b07:6468:f312:9418:b1e8:9e8b:8c2f])
        by smtp.gmail.com with ESMTPSA id w13sm19709449wre.44.2019.08.09.08.47.09
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Aug 2019 08:47:10 -0700 (PDT)
Subject: Re: [GIT PULL] KVM/arm updates for 5.3-rc4
To:     Marc Zyngier <maz@kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
References: <20190809074832.13283-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <9a6b90f4-7583-e002-76ba-a54525879469@redhat.com>
Date:   Fri, 9 Aug 2019 17:47:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190809074832.13283-1-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/08/19 09:48, Marc Zyngier wrote:
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-for-5.3
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-for-5.3-2

Pulled both.  Thank you for including the lore link to the 5.3-rc3 pull
request.

Paolo
