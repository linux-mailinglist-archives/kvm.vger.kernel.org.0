Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9ACE4D3814
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 18:46:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234612AbiCIQhB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 11:37:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235490AbiCIQdx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 11:33:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A91498F637
        for <kvm@vger.kernel.org>; Wed,  9 Mar 2022 08:29:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646843285;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IOMfFTAcAUEU/l66+l/GXpSMtR5htCBxaoT0uvUiZ5o=;
        b=XrZZrVPjiDof5SkRYO5wdakIqwaAl3vi6ounfSfF6RZHckI/2SUFC4MUUB/cgpy+oqka78
        Ivpvt0URQ4FAQNqI4zERuqf29pMUUbIpST1KdnxaqgThySnebgeE2CzSQSHFr+FImwX6OY
        SWsntWCLe/LEyo0HAY4UMEDjvY5m334=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-135-ynleHFJqNqeypKjcdBunlg-1; Wed, 09 Mar 2022 11:28:04 -0500
X-MC-Unique: ynleHFJqNqeypKjcdBunlg-1
Received: by mail-ed1-f71.google.com with SMTP id cm27-20020a0564020c9b00b004137effc24bso1559857edb.10
        for <kvm@vger.kernel.org>; Wed, 09 Mar 2022 08:28:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=IOMfFTAcAUEU/l66+l/GXpSMtR5htCBxaoT0uvUiZ5o=;
        b=0LIyWEZQKxQjgmYWtTya3+Zk5r16aAbBGipnfLWKOMwb6jbzRoxiQEWCw5qqf5XfgS
         FApogVDpKENGQhvoiZ+eqfSgVQ+PmEcevF6vRTHBqBLGzUv6viE4EtZ1AMt7U4UomoGW
         tZy9RWED33UK85y8h/nj2c3CXMVdiYJEPglAHMM5KOWefjBVery02fo9Hfg4jiD+DnH5
         Na2nbX7FNAYeyRgSgIQok5jCshJdx43gTyrJ4A4BvELbbD6SsXQTY/ZClK6Vg1u1MseF
         dW1qlooQANaES/JwM8kBPpCeC7nz0B0Q9AyoDUszWd10fkNM4ghdGCeFT2Y0qbXY1Iq/
         LMKQ==
X-Gm-Message-State: AOAM531USg3K6i6vPrbhGtC0l9sG6y9U0kGCvx6eKl8p+t3ZHz2Lz0EU
        POPhicSRSKQRgmvscEHWz/rnODW734G7wu/Pa5PEJsyCloUdGxspx9R1vSFkR/AmuaE9k0p0+Vo
        MxviY61Fx7nHq
X-Received: by 2002:a17:907:3f93:b0:6da:b5e2:f325 with SMTP id hr19-20020a1709073f9300b006dab5e2f325mr545332ejc.120.1646843282988;
        Wed, 09 Mar 2022 08:28:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxOf1WX54K8Rflxo8/kXpzhXslF5nYZ95vCpoX7VLJYpQ3i7RVEagnr3w6ePsJa8xu1FZSUag==
X-Received: by 2002:a17:907:3f93:b0:6da:b5e2:f325 with SMTP id hr19-20020a1709073f9300b006dab5e2f325mr545308ejc.120.1646843282696;
        Wed, 09 Mar 2022 08:28:02 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id qt22-20020a170906ecf600b006da6ef9b820sm930352ejb.112.2022.03.09.08.28.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 08:28:01 -0800 (PST)
Message-ID: <baa1d8da-fd9d-39f4-269e-4af50936e042@redhat.com>
Date:   Wed, 9 Mar 2022 17:28:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 1/2] KVM: x86/xen: PV oneshot timer fixes
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Metin Kaya <metikaya@amazon.co.uk>,
        Paul Durrant <pdurrant@amazon.co.uk>
References: <20220309143835.253911-1-dwmw2@infradead.org>
 <20220309143835.253911-2-dwmw2@infradead.org>
 <846caa99-2e42-4443-1070-84e49d2f11d2@redhat.com>
 <4f1b299dd989640b5c9e8f23a9b90de357581b62.camel@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <4f1b299dd989640b5c9e8f23a9b90de357581b62.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/9/22 17:11, David Woodhouse wrote:
> That's OK, as the pending events are in the shared_info and vcpu_info
> regions which we have explicitly declared exempt from dirty tracking.
> Userspace must always consider them dirty any time an interrupt (which
> includes timers) might be delivered, so it has to migrate that memory
> in the final sync, after serializing the vCPU state.
>
> In the local APIC delivery mode, the actual interrupt is injected as an
> MSI, so userspace needs to read the timer state before the local APIC
> state.

Please document this.  It's not obvious from the fact that they're not 
dirty-tracked.

Paolo

