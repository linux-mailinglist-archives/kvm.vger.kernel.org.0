Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D190F14DFAF
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 18:13:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727328AbgA3RNd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 12:13:33 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43932 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726514AbgA3RNd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jan 2020 12:13:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580404412;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H4XSFE0E4Gksgq4colGF+ekKd22PBCuH+3lUMYjeKtA=;
        b=BM5WMasLx2xUJ/CyGjLMYLh0Ju4ae+H8xlrteV8xzdtpvqcQWyD/uXM5I6cPpVSEy87IFx
        4uWOhZtll2Vr6mKEpKacQX2mKbRqQiTbF2V2+D8SFpt4MJV4tadUE1vUz7Pq5rhbECfKqw
        bZgiT8ihk90SlkCG97kIafwXvIE2XC0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-200-DPezs3v6PzGibqNV-81wDw-1; Thu, 30 Jan 2020 12:13:30 -0500
X-MC-Unique: DPezs3v6PzGibqNV-81wDw-1
Received: by mail-wr1-f69.google.com with SMTP id z15so2042617wrw.0
        for <kvm@vger.kernel.org>; Thu, 30 Jan 2020 09:13:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=H4XSFE0E4Gksgq4colGF+ekKd22PBCuH+3lUMYjeKtA=;
        b=VMJBYHOfe9zFjqRad2ZkO+lmZvnOIqJqadszyHFOvBV/uBUhgVcK4YHys1ReeXUbPG
         AGpP2puV5bQThuGtHU0wBwJ+BjBugbVEJhht/kkOS8FUI7wmOgDXpijhKVv4EbKxtn6Q
         tIgOmVHnUnKLpuRz0X2i6yg8kGJLS//hM8UW+As0oJjToRYXwMHf05oMkm758NGe7Fcq
         FaDaZ+YGy7ZtGphWU+bvwS18PgjGLTCGQupfDp+4yjw3EAoGxVCIevM+w1UCUTHav2Wd
         puSPGtd5ZNe+NGM5jUsOqQfIn1i+HZc4PlKzjib6nVMGNouWNPyuKK24Z/eeyDDJy6eI
         EfSw==
X-Gm-Message-State: APjAAAWDu0PkB8/dU0u42HQL5Oa7bvn/Qvsu2q5OvpHA1rK9iHZttS9O
        lMoFoY2fxnP8P6RH6w+6BkFvkjbxkQMC7LgPdVkBXb/MZROb0SInNPMnS9EGQ27fAK0gEd+97h+
        u+B3Jkzk6OkUG
X-Received: by 2002:a5d:5273:: with SMTP id l19mr7085737wrc.175.1580404409501;
        Thu, 30 Jan 2020 09:13:29 -0800 (PST)
X-Google-Smtp-Source: APXvYqymVD4j3W000trrAp+yiZYezamOlUuLI2vEHpmo9N7lQFe0NfMAmfVgtniQBd5Sv2KEKg1xxw==
X-Received: by 2002:a5d:5273:: with SMTP id l19mr7085702wrc.175.1580404409282;
        Thu, 30 Jan 2020 09:13:29 -0800 (PST)
Received: from [10.200.153.153] ([213.175.37.12])
        by smtp.gmail.com with ESMTPSA id i2sm7353450wmb.28.2020.01.30.09.13.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jan 2020 09:13:28 -0800 (PST)
Subject: Re: [GIT PULL 00/23] KVM/arm updates for 5.6
To:     Marc Zyngier <maz@kernel.org>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Beata Michalska <beata.michalska@linaro.org>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Haibin Wang <wanghaibin.wang@huawei.com>,
        James Morse <james.morse@arm.com>,
        Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Shannon Zhao <shannon.zhao@linux.alibaba.com>,
        Steven Price <steven.price@arm.com>,
        Will Deacon <will@kernel.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
References: <20200130132558.10201-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b69fd046-1076-c197-7147-bd65f40ea9df@redhat.com>
Date:   Thu, 30 Jan 2020 18:13:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200130132558.10201-1-maz@kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/01/20 14:25, Marc Zyngier wrote:
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-5.6

Pulled, thanks!

Paolo

