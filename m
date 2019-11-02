Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4ECECDE2
	for <lists+kvm@lfdr.de>; Sat,  2 Nov 2019 10:51:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727500AbfKBJvb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 Nov 2019 05:51:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48052 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727091AbfKBJvb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 2 Nov 2019 05:51:31 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id ADD088665A
        for <kvm@vger.kernel.org>; Sat,  2 Nov 2019 09:51:30 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id s9so7021439wrw.23
        for <kvm@vger.kernel.org>; Sat, 02 Nov 2019 02:51:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=l8qAdWRObZ9diNurmyFj32RwamTbc6O7HnqjMAubn+g=;
        b=uZoVkhuU0ZqdBj+y0I5He1wrz2vMEWAGNPJqDPjXf+Do0VRQPdgYSZ8in/XUEqgVy+
         gkVs95bqlW87sNGmZE91/zfgHk7f8FDJIMkb6YSlv8yHuIvPaoAsj/c+crMx/iJWOQPS
         8ASSS+iMnz4FsaANRoUgGgs/aHXkeWy0ccLbkov7ULcWsQjIW04uQMfyKObhF5jx7TSw
         sG13Rx6u94Cjl1cB340V3o0ncbshssUU1H9l2/U71IIA10vrIzziyAgNDGvVszDsgpj+
         uEphT9GOTjz+FzXazXZ+dc5pudQVtp55lnVX4injYJDqUnebcUudbC/35ae57g32i+xP
         5XmA==
X-Gm-Message-State: APjAAAVybZE73yQE+erAp2bj7q+0wo6Y2q6kwj4PnVHboqYjyuTF/PYK
        t9NhIMX/MGuwkRN/63yN2EBs32y6JGVzFZueF11hCrs5D6MB15P4kTWNJZtVph0BM20v/TJ6aQb
        Ke/qmfK22SliO
X-Received: by 2002:a5d:69c8:: with SMTP id s8mr14694477wrw.167.1572688289338;
        Sat, 02 Nov 2019 02:51:29 -0700 (PDT)
X-Google-Smtp-Source: APXvYqw2zf793oOTw8eZP9mFlJz05v9GK0WJFS03MxDK0c2oafYGNsvzIm/OUePbHZdoEfHUhIp0ag==
X-Received: by 2002:a5d:69c8:: with SMTP id s8mr14694452wrw.167.1572688289015;
        Sat, 02 Nov 2019 02:51:29 -0700 (PDT)
Received: from [192.168.42.35] (mob-31-159-163-247.net.vodafone.it. [31.159.163.247])
        by smtp.gmail.com with ESMTPSA id d20sm14673270wra.4.2019.11.02.02.51.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 Nov 2019 02:51:28 -0700 (PDT)
Subject: Re: [PATCH v4 03/17] kvm: x86: Introduce APICv deactivate bits
To:     "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "rkagan@virtuozzo.com" <rkagan@virtuozzo.com>,
        "graf@amazon.com" <graf@amazon.com>,
        "jschoenh@amazon.de" <jschoenh@amazon.de>,
        "karahmed@amazon.de" <karahmed@amazon.de>,
        "rimasluk@amazon.com" <rimasluk@amazon.com>,
        "Grimm, Jon" <Jon.Grimm@amd.com>
References: <1572648072-84536-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1572648072-84536-4-git-send-email-suravee.suthikulpanit@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <d947359d-0eb8-1e6f-ef53-54bcec0410c7@redhat.com>
Date:   Sat, 2 Nov 2019 10:51:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1572648072-84536-4-git-send-email-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/11/19 23:41, Suthikulpanit, Suravee wrote:
> +	unsigned long apicv_deact_msk;

No abbrev fld names. :)  I can change this to something like
apicv_inhibit_reasons if there are no other issues (and likewise
s/APICV_DEACT_BIT_/APICV_INHIBIT_REASON_/).

> 
> +bool kvm_apicv_activated(struct kvm *kvm)
> +{
> +	return (READ_ONCE(kvm->arch.apicv_deact_msk) == 0);
> +}

Using READ_ONCE introduces a risk of races.  I'll check during a more
thorough review if it's worth introducing separate kvm_apicv_active and
kvm_apicv_active_nolock functions.

Paolo
