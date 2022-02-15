Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 304BE4B7604
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 21:48:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242584AbiBORe4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Feb 2022 12:34:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236515AbiBORez (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Feb 2022 12:34:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6653B2A278
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 09:34:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644946484;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EATGU/7YAapc555lnSueuN80ws9V784SEL6YzWxX/WU=;
        b=CPoDnfaLXxWnuYtKe29QQrZ71O6b/M9i8MUpQgBIIWPCNtb59/rGqIcnENflLwrP51hMzR
        wOnt77Aydqoa9nJSbO4LYuA+GM1w4xRo7f5OGfcGKbAe+aUGqvnvnmVvuftMqnwkcXoTyQ
        F/EV2xL8Pxl0pYR9WqMt7S7H2NCRQeA=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-465-0T7gKpT-O96xYN-9lJ4puQ-1; Tue, 15 Feb 2022 12:34:42 -0500
X-MC-Unique: 0T7gKpT-O96xYN-9lJ4puQ-1
Received: by mail-ej1-f71.google.com with SMTP id hc39-20020a17090716a700b006ce88cf89dfso2739277ejc.10
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 09:34:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=EATGU/7YAapc555lnSueuN80ws9V784SEL6YzWxX/WU=;
        b=jiSAluqp395fr7R+AQbEThPMfmcw6N0no28dgY3B6cdD9/OyOO2urWGkGO5kBlawuW
         rqPJ/3xcbD8Vo9tfa8+8kJJmR1YjpQcM+1AQkTtZQ2zSSMS0GYlk1PavvSXVIQmVefSe
         +dLmg9+dEcVbqifJYlox8jT1sajyDo/2pGovvPkBegSrcTPpavdkDnCnZLiGt8A3F1SH
         KA5cEVjWrsT684pMr8boKVYX/17E73irM6TmMYrA6KBV8qBrFNeeXgcjENIFzKoAyBVg
         BndfFfQvhjNhz1uvQUO17p7nNDFBGSnOqKw7a/zBhrL5wGasLOrlsZHIGZrQzSL9h61W
         cgmA==
X-Gm-Message-State: AOAM533qeoy2N4FHEdPfQpsLvVatpSdeC0EQqNldpRi8e56IId+i3Qwl
        4H+06fP7TRbkgbj8l+3Z2I/iPJtbRbGyMuTH5KcYPnqSIyo7GTFU6XaZGTSYC8uaAmI9cRYxIPZ
        srGqpsCZ4hPzR
X-Received: by 2002:a17:906:19c:: with SMTP id 28mr92182ejb.673.1644946481539;
        Tue, 15 Feb 2022 09:34:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzppiyQR9mZFXPazxdi7sW1472+OgaclBGwSuTLDKOHj4BUcJRz75Z8bpchz7RbIwYNJQQWdQ==
X-Received: by 2002:a17:906:19c:: with SMTP id 28mr92168ejb.673.1644946481352;
        Tue, 15 Feb 2022 09:34:41 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id z4sm11866947ejd.39.2022.02.15.09.34.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Feb 2022 09:34:40 -0800 (PST)
Message-ID: <c7b39109-d5f9-a35a-3fe3-6265f811480c@redhat.com>
Date:   Tue, 15 Feb 2022 18:34:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] KVM: Fix lockdep false negative during host resume
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1644920142-81249-1-git-send-email-wanpengli@tencent.com>
 <YgvUSCjukIxvpDlf@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YgvUSCjukIxvpDlf@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/15/22 17:26, Sean Christopherson wrote:
> Reviewed-by: Sean Christopherson<seanjc@google.com>

Queued with the #ifdef removed, thanks.

Paolo

