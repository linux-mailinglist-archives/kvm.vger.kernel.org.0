Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9725852A86D
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 18:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233094AbiEQQqO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 12:46:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351172AbiEQQqK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 12:46:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7BBB5433B2
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 09:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652805968;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=piCMWieXRym8M3zo/TuxzKtv65hW1PNViz8fSNfFTmE=;
        b=OWo0Me9vyMxFpxUumyQdkIDdJy5JUQisLWwrL9HOaThPqSDSRba7Lx4UbAbo92WAwne2EO
        6ES5X7S78UNpAofKlh4Kza0MgskG4RWPZzFV0WXs7AH77cS9u1X863f8GlGswVPWihGqv8
        dspKs1WLhfWjDMxiFMz4V35YEMtIuiQ=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-131-5AYoCJk5MXC3dJVBkNwRug-1; Tue, 17 May 2022 12:46:07 -0400
X-MC-Unique: 5AYoCJk5MXC3dJVBkNwRug-1
Received: by mail-ed1-f72.google.com with SMTP id w14-20020a50fa8e000000b0042ab142d677so4396162edr.11
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 09:46:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=piCMWieXRym8M3zo/TuxzKtv65hW1PNViz8fSNfFTmE=;
        b=fwqBvhCMxIQzOOr/e+qUDk15eYd242Xd9LF/AWEdjmWkjXQO0u5aYfwJBQzrxAj/nK
         IasbjyTPYY611E507BvLR3afYhgDKldlXIF0WclYgy/DMzX6BmDVn+ck9FLc0H0IpX+Y
         zfORurANZs+eaPjuOyvAjiBOz/ae/wIhTkLEyisM3ZgImOJwogJ9Yt97uM4xgI7ezls5
         wFYcJtbu3sGb/o88/bbZwF2dE7bXyj6SfzGaiSNZDNctFcD/2DiYcMgouaSeobV477qY
         j/fsXIn6HpUSBsAz4oqePcN2stGT0nFYqEpecA//n4m067vcT6cDI/cUl7FOfJkBgenG
         BF3A==
X-Gm-Message-State: AOAM531qKs+nynvHKrdb0VEekyeFIxvBjtogemNQGdLIFUm4A83SRwpZ
        LIhCw/HvsbZiY4KYQQg01xqFfNnpAJDMigK+Gdz89o3oZ9M2PIB0DoJ2qyZ5aeuHGqQamMfOA8z
        2i9LUZwtMiU0s
X-Received: by 2002:aa7:c314:0:b0:42a:bb52:59d2 with SMTP id l20-20020aa7c314000000b0042abb5259d2mr8688560edq.167.1652805965971;
        Tue, 17 May 2022 09:46:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwdpNy//rc+0zCDq+88azenWdk1g2HDX29DoBlZaF7VmRSOmP5jdpEqhfA2htmZlmyKst9s8g==
X-Received: by 2002:aa7:c314:0:b0:42a:bb52:59d2 with SMTP id l20-20020aa7c314000000b0042abb5259d2mr8688532edq.167.1652805965735;
        Tue, 17 May 2022 09:46:05 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id 6-20020a170906024600b006f3ef214e5dsm1187928ejl.195.2022.05.17.09.46.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 May 2022 09:46:05 -0700 (PDT)
Message-ID: <4a7ff020-fe50-be46-0077-3ff3168a303b@redhat.com>
Date:   Tue, 17 May 2022 18:46:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v3 00/12] KVM: SVM: Fix soft int/ex re-injection
Content-Language: en-US
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
References: <cover.1651440202.git.maciej.szmigiero@oracle.com>
 <952cdf59-6abd-f67f-46c6-67d394b98380@maciej.szmigiero.name>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <952cdf59-6abd-f67f-46c6-67d394b98380@maciej.szmigiero.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/17/22 14:28, Maciej S. Szmigiero wrote:
> On 2.05.2022 00:07, Maciej S. Szmigiero wrote:
>> This series is an updated version of Sean's SVM soft interrupt/exception
>> re-injection fixes patch set, which in turn extended and generalized my
>> nSVM L1 -> L2 event injection fixes series.
> 
> @Paolo:
> Can't see this series in kvm/queue, do you plan to merge it for 5.19?

Yes, FWIW my list right now is (from most likely to less likely but 
still doable):

* deadlock (5.18)

* PMU filter patches from alewis (5.18?)

* architectural LBR

* Like's perf HW_EVENT series

* cache refresh

* this one

* nested dirty-log selftest

* x2AVIC

* dirty quota

* CMCI

* pfn functions

* Vitaly's Hyper-V TLB

