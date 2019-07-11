Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05160657FB
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 15:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728715AbfGKNkX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 09:40:23 -0400
Received: from mail-wr1-f41.google.com ([209.85.221.41]:37091 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728505AbfGKNkX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 09:40:23 -0400
Received: by mail-wr1-f41.google.com with SMTP id n9so6370599wrr.4
        for <kvm@vger.kernel.org>; Thu, 11 Jul 2019 06:40:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FnSXGXReWdj1dwt4PqYkheiL50PJemd4VIlhtbzAQt8=;
        b=T7hwRznGhogyo4K3RGwAAt6MNlh31i3gHIt3QCn6D3h37pN9Tr47UI3as6QLawbvRR
         sFifKHuxULqbrSOqnONYbF57zqf7Wn4G4x0sd1yfImBE4FQkdMa8lkHswPXWFnxjKByx
         j5m8yneWbEAgtdNBiN2gObEcsAFpRXlI733fTbGh5LkGpIZlMkAi9HQKLOMXXb188U04
         KdrSg6MYqFfqiorzC4DISoeFtPivebi/9VyWd7GVEDF7zLUHNtQiBDa6CtK5ggyiLnc3
         +PLWL8D0I9OmOl6N68lG0ee1zVZnBlS6hTIkd0ZXJfxLt/OPEX1QtOwTbXqbMcd1Iv4T
         C6Rw==
X-Gm-Message-State: APjAAAVVEkbTPfSQcocei/S1UQFaYwMB6x7E2o9PS0gXusDJo5QPylcO
        pd9TMrC+b7CNSOO+vcAEVlmyFyvjwCJTJA==
X-Google-Smtp-Source: APXvYqyShV9fbckDIWGQ0EkgfblduUbng9/MP66ZdhXZaEdrkN9dkmEju62XgU7X98NYyExpOgwWZA==
X-Received: by 2002:adf:e843:: with SMTP id d3mr5517125wrn.249.1562852421455;
        Thu, 11 Jul 2019 06:40:21 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d066:6881:ec69:75ab? ([2001:b07:6468:f312:d066:6881:ec69:75ab])
        by smtp.gmail.com with ESMTPSA id e3sm5300954wrt.93.2019.07.11.06.40.19
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 06:40:20 -0700 (PDT)
Subject: Re: [GIT PULL] KVM/arm updates for Linux 5.3
To:     Marc Zyngier <marc.zyngier@arm.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry@arm.com>,
        Steven Price <steven.price@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <20190709122507.214494-1-marc.zyngier@arm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <7f0bdfc0-d450-5466-ba0f-34c52d872e91@redhat.com>
Date:   Thu, 11 Jul 2019 15:40:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190709122507.214494-1-marc.zyngier@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/07/19 14:24, Marc Zyngier wrote:
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvm-arm-for-5.3

Pulled, thanks!

Paolo
