Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D902E363067
	for <lists+kvm@lfdr.de>; Sat, 17 Apr 2021 15:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236058AbhDQNkP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Apr 2021 09:40:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20323 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236092AbhDQNkN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 17 Apr 2021 09:40:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618666787;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Vl5fT45qmNUBaYknifrhJQO3g3agY4f1Yqsmx8Sy+5Y=;
        b=SXCdJDLTgdEMdB2c2WMrGVnuka4OIT5BhAnTeHK5ulkg4aGbIO/2DWD/LE+wndIRF0IzZc
        DLav+lZ4Dsv564LenQNSRjdHsBak6xRXcdK22zXBgzBkeKXmdpjaBxVXiE4hRip7swbI+C
        txMD0+X0MKdBQSYU3/LtfIjmyibiZfw=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-343-6CfxRv9SNLisEUVGycbHnQ-1; Sat, 17 Apr 2021 09:39:46 -0400
X-MC-Unique: 6CfxRv9SNLisEUVGycbHnQ-1
Received: by mail-ed1-f71.google.com with SMTP id l22-20020a0564021256b0290384ebfba68cso4815940edw.2
        for <kvm@vger.kernel.org>; Sat, 17 Apr 2021 06:39:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Vl5fT45qmNUBaYknifrhJQO3g3agY4f1Yqsmx8Sy+5Y=;
        b=dZ6/N1JU8hFrfm/wNUMuVC6ai2jSC8C1L7Cho2NYh9pvCCGq5nV7O15hsrGTJqGT4k
         +ZRRvbnBYNwTQaq6KJJXM3X+22265YF++t22cVpJcQw+FKN02D/FBNPoWTnizG2heMMM
         z8SATVWA0wNqGcXbO3U0IElHYk540UQE+1h988vF9UxVQehBWxmymoQgcIC0o3SC9CJn
         ZwHMZhVFKt34wdcuaK+NK9Xj4WItG9q6RhAZjKh4DaIulsaAlP/8yqLAurP1q5gDeDQ/
         UvdzQ21SJQwsZhgIKewnhptAjV/3EUCwIpHDDr0aBgTLcd8xVJP00vGQ1RrQ0Y0zs3ad
         YuNQ==
X-Gm-Message-State: AOAM531SBljvSYlFod/gidKukxDy8+wXLTcQZEa72rC/sxSzyxOcqLq+
        iD/rSu/+umhx0Upwv5tjS+aIatZ44QT9zIhFjzHBqGGOv9BMcrLY07DQUvC5m37EpKDqrDTcvwB
        ljAqKSfQ2DW1x
X-Received: by 2002:a05:6402:34c8:: with SMTP id w8mr16306158edc.235.1618666784645;
        Sat, 17 Apr 2021 06:39:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzR9R4cU944IIgU8B3fJdUEocoEuj0CXFfF2muB+7EaJv4fMyvTv3uAp0s0i/UKukmgnBrwlg==
X-Received: by 2002:a05:6402:34c8:: with SMTP id w8mr16306144edc.235.1618666784528;
        Sat, 17 Apr 2021 06:39:44 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id ga28sm6200588ejc.82.2021.04.17.06.39.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Apr 2021 06:39:43 -0700 (PDT)
Subject: Re: [PATCH v5 04/11] KVM: x86: Add reverse-CPUID lookup support for
 scattered SGX features
To:     Kai Huang <kai.huang@intel.com>, kvm@vger.kernel.org,
        linux-sgx@vger.kernel.org
Cc:     seanjc@google.com, bp@alien8.de, jarkko@kernel.org,
        dave.hansen@intel.com, luto@kernel.org, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com
References: <cover.1618196135.git.kai.huang@intel.com>
 <e797c533f4c71ae89265bbb15a02aef86b67cbec.1618196135.git.kai.huang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9bd47d7a-79cb-43fc-0f74-b13512ede0d2@redhat.com>
Date:   Sat, 17 Apr 2021 15:39:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <e797c533f4c71ae89265bbb15a02aef86b67cbec.1618196135.git.kai.huang@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/04/21 06:21, Kai Huang wrote:
>   #define X86_KVM_FEATURE(w, f)		((w)*32 + (f))
>   
> +/* Intel-defined SGX sub-features, CPUID level 0x12 (EAX). */
> +#define __X86_FEATURE_SGX1		X86_KVM_FEATURE(CPUID_12_EAX, 0)
> +#define __X86_FEATURE_SGX2		X86_KVM_FEATURE(CPUID_12_EAX, 1)

And these to KVM_X86_FEATURE and KVM_X86_FEATURE_SGX{1,2}.

Paolo

