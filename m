Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECDEF27515E
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 08:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbgIWGYe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 02:24:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbgIWGYe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 02:24:34 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C6DEC061755;
        Tue, 22 Sep 2020 23:24:34 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id f2so13749644pgd.3;
        Tue, 22 Sep 2020 23:24:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ySPedNslPG3dkY7v4dApthW0w3KPGs63C9M/zo9R+Gg=;
        b=cMkYbqeTFzEMfQlDQXxvdNhcgkd+x2MJ+ysNycqzI1PMJysbspC3q+zJb/7Z+i6B4L
         s0PIYj2/GyTeYM71Y3PZs73TIhK2W0QWB+4J0Fa7IVXgj9TyIhPIJ1k6lSQV2Bsyg/7f
         JcDXFglrhj3SvaHcTE53p0CtjZI6f1SjuGGbogPoYWwWRFx3AiiUxTuhr383f/u+P2t1
         8v2jtIYx/fLi4S/Yd0X+0R9Hy3vpwzzEv+jYabvXSEeviWcNNyKfjPhMjFW8faJ7iPIL
         IDzyKdVxfcznpe2ScISBSPb/yxW2NS3N7uf7TXEIrRy1V+DbaKExFYNRgpjOIs8NEOaa
         vbOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ySPedNslPG3dkY7v4dApthW0w3KPGs63C9M/zo9R+Gg=;
        b=Fm4/a1M/pRh+Mkk/AWapIiH6HuLGKLQLA0arehUWgZT2PzMq3/imJnufE+JYpZ8EVQ
         Pqv0AZ2gLtHVmfxrTGhruE58zrFBOGfgcyqWDsndRMqIJ1R7k53MApfjFd9IuIiH0/IX
         dgu3glOHD5eP7He+asPQPZto2c4HkGy+a3pYQJpjUnpveES289NHiyTooA6M1EV4kd+3
         33SBHi9LPNLmIxfa1xT+Rz/iPFu7xyP92VzA/uY9Di6tCHOWk5HuSkgNQeLa7fKmFdWi
         sbsFXdAXfZh14n8E2qnXAiwM1rvN7XmKd0+viwot0Bx/Ps57KV1PzBpXp5zY1HuvjcwJ
         mKZQ==
X-Gm-Message-State: AOAM532N2Ct28Pq77BtaOuip9IZxYCKtQ0TdHjiFs7aOJSL3ZA8MBWJL
        W7NPS70NCrbvue0/GKGHaQ==
X-Google-Smtp-Source: ABdhPJxwlOdBatq9xkyrZVcqcasAWQbfLaVBMs6AIDYLsAP4MYhJLyl1ZuEtYlOTuK6OTIv5KnqXrQ==
X-Received: by 2002:a62:7c43:0:b029:139:858b:8033 with SMTP id x64-20020a627c430000b0290139858b8033mr7320759pfc.3.1600842274006;
        Tue, 22 Sep 2020 23:24:34 -0700 (PDT)
Received: from [127.0.0.1] ([103.7.29.6])
        by smtp.gmail.com with ESMTPSA id h31sm14846698pgh.71.2020.09.22.23.24.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2020 23:24:33 -0700 (PDT)
Subject: Re: [PATCH] KVM: SVM: Add tracepoint for cr_interception
From:   Haiwei Li <lihaiwei.kernel@gmail.com>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Cc:     "hpa@zytor.com" <hpa@zytor.com>, "bp@alien8.de" <bp@alien8.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>, joro@8bytes.org,
        "jmattson@google.com" <jmattson@google.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        vkuznets@redhat.com, sean.j.christopherson@intel.com,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
References: <f3031602-db3b-c4fe-b719-d402663b0a2b@gmail.com>
Message-ID: <040bf07b-dcc5-df99-d720-a2ed2298a2e3@gmail.com>
Date:   Wed, 23 Sep 2020 14:24:23 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <f3031602-db3b-c4fe-b719-d402663b0a2b@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Kindly ping. :)
On 20/9/4 19:25, Haiwei Li wrote:
> From: Haiwei Li <lihaiwei@tencent.com>
> 
> Add trace_kvm_cr_write and trace_kvm_cr_read for svm.
> 
> Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
> ---
>   arch/x86/kvm/svm/svm.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 03dd7bac8034..2c6dea48ba62 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2261,6 +2261,7 @@ static int cr_interception(struct vcpu_svm *svm)
>       if (cr >= 16) { /* mov to cr */
>           cr -= 16;
>           val = kvm_register_read(&svm->vcpu, reg);
> +        trace_kvm_cr_write(cr, val);
>           switch (cr) {
>           case 0:
>               if (!check_selective_cr0_intercepted(svm, val))
> @@ -2306,6 +2307,7 @@ static int cr_interception(struct vcpu_svm *svm)
>               return 1;
>           }
>           kvm_register_write(&svm->vcpu, reg, val);
> +        trace_kvm_cr_read(cr, val);
>       }
>       return kvm_complete_insn_gp(&svm->vcpu, err);
>   }
> -- 
> 2.18.4
