Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46A7ABD9E7
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 10:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2634138AbfIYIax (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 04:30:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35008 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2634101AbfIYIax (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 04:30:53 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CE77CC053B32
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 08:30:52 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id t11so1953654wro.10
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 01:30:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=GVOKVl8Rbi28WLJIH/E8/D4/8rOj2+cSnTA2VagYct4=;
        b=FHy4REIjEnKRg7apCE5/DRF0KClKpFKHPrnipP3urVMfu4ofW/t99pnEfM/C1BWJj6
         PZI77aI89jh5iVAnPbxkNw3+7yK8L+rNbPrvCxFjXZltKWBKaDYgub3dNwmmIWLWR5Ow
         vUolOOHL96rPP6V3Pa6UsKmlsLWK2WeXRQ5gsdHXKNz36v2uQMOKUTGz4ihVtHLIbl4j
         cmcpNtynLNiMnZYcKpLqbC8BhGg9+1wPtV6uCEb1/HE/whFiYTflL2AuYG5DtzNulQD2
         Bn8cjKcmR+45zIqigQ1lxNmNZlRUoYIvQKqiqFhueYhqasY7lopQz1SsJtmzjusI+m90
         mQHg==
X-Gm-Message-State: APjAAAUtUogHK3X0F/SPTw4GkaxBTvNqpphU32YL91s4ssN6cj1VhEkL
        NSAFRTs+eVkAep13BBuD6WFCx25WrMYeS22TZnXx0fPsWXQInomlXbVXJedy51MtDUAZIEw12T6
        Z+Eu6RpQ002hf
X-Received: by 2002:adf:f708:: with SMTP id r8mr7746244wrp.187.1569400251434;
        Wed, 25 Sep 2019 01:30:51 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyVy94PfQ+PObW480X30CtQtp82Ya0oxe5YLuhyMF/a9VLK01bS9JTioqdelVJa62zWIZZwZw==
X-Received: by 2002:adf:f708:: with SMTP id r8mr7746221wrp.187.1569400251185;
        Wed, 25 Sep 2019 01:30:51 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id e3sm2300349wme.39.2019.09.25.01.30.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2019 01:30:50 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     kbuild-all@01.org, kbuild test robot <lkp@intel.com>,
        Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>
Subject: Re: [kvm:queue 4/47] arch/x86/kvm/vmx/vmx.c:503:10: warning: cast from pointer to integer of different size
In-Reply-To: <201909250244.efVzzpnN%lkp@intel.com>
References: <201909250244.efVzzpnN%lkp@intel.com>
Date:   Wed, 25 Sep 2019 10:30:49 +0200
Message-ID: <874l1093ra.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kbuild test robot <lkp@intel.com> writes:

>  > 502			pr_debug("KVM: Hyper-V: allocated PA_PG for %llx\n",
>  > 503			       (u64)&vcpu->kvm);

(as a matter of fact, this wasn't in my original patch :-)

I'm not quite sure what this info is useful for, let's just remove
it. I'll send a patch.

-- 
Vitaly
