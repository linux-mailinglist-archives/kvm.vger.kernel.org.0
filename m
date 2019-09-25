Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3935EBD9FB
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 10:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442801AbfIYIhT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 04:37:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43232 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405350AbfIYIhS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 04:37:18 -0400
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9E4422A09A1
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 08:37:18 +0000 (UTC)
Received: by mail-wm1-f69.google.com with SMTP id o8so1684814wmc.2
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 01:37:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3VhPkSl2uf/qmkqWM+G9FNiQnG+Cpv4Ltq7GILMPAkM=;
        b=ivXYQYk6lOnkb45uNryYrxRGMz0/WGV93aD5BDQH9WdCz0OtSxgT053WoPFLpMZIE+
         jyesIdwM/In6TYFnt/zoXtTUZVCiKyjr2ez1nBql4Z0f2Pi36SNN82yG/LTTLNJgGLYk
         u5AH2iz6AT6jbt7AvnDe8pCCfjbagKJUCPa/WFuqvY26lsWF1msZxXzzT7MfONNRFn7R
         ZIu5NiA/zvsBOAvctYyv4xT4B7+W5HMy7A7l2RTA2sQGPbB2GWsvrfhUgVts5XsGlQrK
         gMH4SkcebXRN8TYXeQ4rJhX6IxpiQgqCssNBZWhYtNK7Y86JM/eFjBhda1q1ESoAtxys
         lerA==
X-Gm-Message-State: APjAAAUHgJP3ck8EQAILt3WxD0e5Nc6OrbTGi15EOjMmO1DUL/3dQDxv
        CFxmyyjQ2deWG51FQr7TaJYLFygjz0lp2/xnIupYH5Rv7nto+hCjI9HRC6FatT4kOFQNZm3n+Qi
        8muhAPnZ0cLmH
X-Received: by 2002:a5d:43c6:: with SMTP id v6mr7812245wrr.159.1569400637244;
        Wed, 25 Sep 2019 01:37:17 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwpj8cZJO2WvbUNnAXQ6C5iaWnzdtKwZyC6kwcAoMuIyKyefQiOYUWdQIC6jIlpQBayN5GhhA==
X-Received: by 2002:a5d:43c6:: with SMTP id v6mr7812222wrr.159.1569400636993;
        Wed, 25 Sep 2019 01:37:16 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id t13sm11450667wra.70.2019.09.25.01.37.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Sep 2019 01:37:16 -0700 (PDT)
Subject: Re: [kvm:queue 4/47] arch/x86/kvm/vmx/vmx.c:503:10: warning: cast
 from pointer to integer of different size
To:     Tianyu Lan <Tianyu.Lan@microsoft.com>,
        vkuznets <vkuznets@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     "kbuild-all@01.org" <kbuild-all@01.org>,
        kbuild test robot <lkp@intel.com>,
        Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>
References: <201909250244.efVzzpnN%lkp@intel.com>
 <874l1093ra.fsf@vitty.brq.redhat.com>
 <KL1P15301MB0261174BE76F9F00BCEF68EB92870@KL1P15301MB0261.APCP153.PROD.OUTLOOK.COM>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <6037ab4f-70e7-2fcf-84ae-e6b9ac41ad7d@redhat.com>
Date:   Wed, 25 Sep 2019 10:37:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <KL1P15301MB0261174BE76F9F00BCEF68EB92870@KL1P15301MB0261.APCP153.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/09/19 10:35, Tianyu Lan wrote:
> -----Original Message-----
> From: Vitaly Kuznetsov <vkuznets@redhat.com> 
> Sent: Wednesday, September 25, 2019 4:31 PM
> To: kvm@vger.kernel.org
> Cc: kbuild-all@01.org; kbuild test robot <lkp@intel.com>; Robert Hu <robert.hu@intel.com>; Farrah Chen <farrah.chen@intel.com>; Danmei Wei <danmei.wei@intel.com>; Paolo Bonzini <pbonzini@redhat.com>; Tianyu Lan <Tianyu.Lan@microsoft.com>
> Subject: Re: [kvm:queue 4/47] arch/x86/kvm/vmx/vmx.c:503:10: warning: cast from pointer to integer of different size
> 
> kbuild test robot <lkp@intel.com> writes:
> 
>>  > 502			pr_debug("KVM: Hyper-V: allocated PA_PG for %llx\n",
>>  > 503			       (u64)&vcpu->kvm);
> 
> (as a matter of fact, this wasn't in my original patch :-)
> 
> I'm not quite sure what this info is useful for, let's just remove it. I'll send a patch.

Removing all pr_debug is better indeed.

Paolo
