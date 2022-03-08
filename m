Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 076604D1DC1
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 17:50:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237545AbiCHQu7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 11:50:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231637AbiCHQu5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 11:50:57 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20A524924F
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 08:50:01 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id bg10so40624984ejb.4
        for <kvm@vger.kernel.org>; Tue, 08 Mar 2022 08:50:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ED351dHlsOTEDVr6K25lYC9Ef6ipOfRlBtu/ru3/8RA=;
        b=Qh5YV6qpIfakIMuD7Cl1xXzYKqV16yvA2ZzWZdmDTA2+mfau4998V9UPgnH47rRmHP
         GGFnpvLp4kEIdCsMeK8rLZRJuBIAg7nXPDKXuzMSbh+ip2vPQRW4JEx9L2SxZuQwEKlR
         u3VeypXDlPR7ga4lc11Fyarm5qlDzjuSVq+cbwIdsJBqt4xte5RxJV0l26+dTA01uit4
         LQ9z7ANoylWiiiq7DCV4XEPtPPMSd/DloqZdRGgG3tV5JstvLRMVEJLOufRPgqb2CBRG
         hNJPUH4mzPnQgMw9vvcuEJ+b7sptEa9HNb0ySvCAL3IlsFR0rRO3vuVxHel8axnoQg0O
         JCDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ED351dHlsOTEDVr6K25lYC9Ef6ipOfRlBtu/ru3/8RA=;
        b=n8XnVPP8+8p+YFufSEpqxTlqayDt8ODfnG/ETvnlm7X7tJuml/x8gBpdgWeh/9arM5
         cMF4S4MgVG6hQCj5PAXinD3Quj8Yu3bhRpFvo8pW5iY+58hC82e0R8mZnJf+LWb8KTsO
         2a5evxJa0w6TKGc1oi0tGoYZc+873EF+dSxGJdOps0azaPVd6ITtfYextt2IcpTy8mG1
         jOFR7upb61tP65G4ZA8N4vzyw8HA2p4muEBr/4mi/gEuBXz4pOC2LIYiCIY85REeI20q
         KeBJJ/RNBV4xgtsYPmW+PWFPwlQK+K8qJMFv1RETAtaZRPfzT0iJhShvxV3m1o2+tqCk
         MSfw==
X-Gm-Message-State: AOAM5306vK8lu+PPHoVL5Ism+soMfgpTQ5QMuWpDv5EcdE7D8Ag7kzhN
        dw3LzaYeSbvFqme98NjveDk=
X-Google-Smtp-Source: ABdhPJzoRKgDfpH/rR1m/Hzbo0977lUfTL2mbPf50EDoHhmt1SXHlKc8ymiljrLz/T5mQIqooVOeUA==
X-Received: by 2002:a17:906:fb1b:b0:6da:9e7d:1390 with SMTP id lz27-20020a170906fb1b00b006da9e7d1390mr13696232ejb.644.1646758199690;
        Tue, 08 Mar 2022 08:49:59 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id o23-20020a170906861700b006da745f7233sm6032162ejx.5.2022.03.08.08.49.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Mar 2022 08:49:59 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <adbaebac-19ed-e8b7-a79c-9831d2ac055f@redhat.com>
Date:   Tue, 8 Mar 2022 17:49:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 00/17] KVM: Add Xen event channel acceleration
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
References: <20220303154127.202856-1-dwmw2@infradead.org>
 <db8515e4-3668-51d2-d9af-711ebd48ad9b@redhat.com>
 <ec930edc27998dcfe8135a01e368d89747f03c41.camel@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <ec930edc27998dcfe8135a01e368d89747f03c41.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/8/22 17:41, David Woodhouse wrote:
> Thanks. I've literally just a couple of minutes ago finished diagnosing
> a sporadic live migration / live update bug which seems to happen
> because adding an hrtimer in the past*sometimes*  seems not to work,
> although it always worked in my dev testing.
> 
> Incremental diff to the 'oneshot timers' patch looks like the first
> hunk of this. I'm also pondering the second hunk which actively
> *cancels*  the pending timer on serialization.

Hmm, why so?

> Do you want a repost, or a proper incremental patch on top of kvm/queue
> when it becomes visible?

kvm/queue is rebased routinely, so I'll just squash (only the first 
hunk, methinks).  Got a testcase, though?  That might be better as a 
separate patch.

Paolo
