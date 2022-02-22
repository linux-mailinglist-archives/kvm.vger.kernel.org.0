Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6FA4BFA7D
	for <lists+kvm@lfdr.de>; Tue, 22 Feb 2022 15:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232753AbiBVOLl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 09:11:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232720AbiBVOLj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 09:11:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 85CC315FC80
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 06:11:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645539073;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lnCQY82//h+7hOXmxejXJs5Zu5Mwgiv01JTXqpBbWA8=;
        b=YnHCAA321JsPwY2bv1NPejunjDdUuNUULxc+J+ilD8M61HgEgG3EIoxECdT/MMHHBIA8vL
        ZXWLnWPtvncXv2m2za6Sgsjfi71zthEB/Cx7ZVJa2gAJ9PH4d34PkP5soq4LEzoj32chF8
        jO51dpOEjz/ajer9E3olLmAEkpZaX/0=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-79-TzhpkxSsNvutU6COp5sgSw-1; Tue, 22 Feb 2022 09:11:12 -0500
X-MC-Unique: TzhpkxSsNvutU6COp5sgSw-1
Received: by mail-ed1-f70.google.com with SMTP id r11-20020a508d8b000000b00410a4fa4768so11910406edh.9
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 06:11:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=lnCQY82//h+7hOXmxejXJs5Zu5Mwgiv01JTXqpBbWA8=;
        b=Y7JfnfrA6NmmlEBOjcYxQaGWcCpU1kqJz52kIQ9X2HjH40pzwxrX7+TDCziHLAN/+/
         q7/dJ1Qfrq08dFDTGJAkQeh5dM51qFSvU2LKdhBN6jg9LvzaAbmuQ314PEZCKDQCEwZB
         dl+d407tVE8/oQ9d00heCCJ/35AR/g0l7wUXD4zDGEkTDPO1+8YdmZMeqx1AhBytyKLf
         qCsu5AuFgNGL2wCmK1AWNpg7+4YzMBSguq3E7auJLNuMfxH0CkcPNZjipfhDNw5nxnbO
         +GzFQf5QQNvUk3osLXe4xWWXlcvzG/M+hQ1wB2T8ytGQo/4izlfycB9iTMqgFIh/1GlF
         LcOA==
X-Gm-Message-State: AOAM530b/zL5VJAN+NPeYIdNUCs0xd+k6a/OvNdTYHhw8w5M3LjRotHT
        BGT8J2OJO5r8Uazu+EuFHK8OGG5Q7X4YAGWKM7u+7xFdT1g4o7kiC1jUF38fCWvq6p/T35jbKp8
        sspfIOIPV0roi
X-Received: by 2002:a05:6402:17d9:b0:410:aaaf:6467 with SMTP id s25-20020a05640217d900b00410aaaf6467mr27476713edy.38.1645539067388;
        Tue, 22 Feb 2022 06:11:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwLmmut1NqVLLa4YqtgbhxFtdrQeMpDiZdJ2gg+2/N4SxmRmGgIj4l8Z/ZjKKNWQQifTNO7gg==
X-Received: by 2002:a05:6402:17d9:b0:410:aaaf:6467 with SMTP id s25-20020a05640217d900b00410aaaf6467mr27476692edy.38.1645539067212;
        Tue, 22 Feb 2022 06:11:07 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id 16sm6283189eji.94.2022.02.22.06.11.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Feb 2022 06:11:06 -0800 (PST)
Message-ID: <bf6cf0d0-31bd-5751-4fbe-8193dbd716a9@redhat.com>
Date:   Tue, 22 Feb 2022 15:11:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v4 0/3] KVM: PPC: Book3S PR: Fixes for AIL and SCV
Content-Language: en-US
To:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Cc:     kvm@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>
References: <20220222064727.2314380-1-npiggin@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220222064727.2314380-1-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/22/22 07:47, Nicholas Piggin wrote:
> Patch 3 requires a KVM_CAP_PPC number allocated. QEMU maintainers are
> happy with it (link in changelog) just waiting on KVM upstreaming. Do
> you have objections to the series going to ppc/kvm tree first, or
> another option is you could take patch 3 alone first (it's relatively
> independent of the other 2) and ppc/kvm gets it from you?

Hi Nick,

I have pushed a topic branch kvm-cap-ppc-210 to kvm.git with just the 
definition and documentation of the capability.  ppc/kvm can apply your 
patch based on it (and drop the relevant parts of patch 3).  I'll send 
it to Linus this week.

Paolo

