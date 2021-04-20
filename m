Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B723365458
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 10:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231133AbhDTIlU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 04:41:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23297 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230395AbhDTIlT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Apr 2021 04:41:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618908048;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zB438UsN4r9986PE2xEGkDVIweUkvDdpBp47AfbjynM=;
        b=bei4g08qL7FL1WCCniujyQSbFO+Ayow4K377cRJq2y5vWNMFj2UHlVA96gadEVHbRnwsTl
        GytxwnHRJ3bvqfWvVtDEA64eLmBUDhjwcAy9ThSInI2mfb4y4gYisgyjYtq4OwhSSqxqNb
        0JllmMKIApq7u6sQ1KcyEnipu9pEoBY=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-555-r-FhUuRbP9eDMgqXjq9_lg-1; Tue, 20 Apr 2021 04:40:46 -0400
X-MC-Unique: r-FhUuRbP9eDMgqXjq9_lg-1
Received: by mail-ed1-f70.google.com with SMTP id w14-20020aa7da4e0000b02903834aeed684so10965346eds.13
        for <kvm@vger.kernel.org>; Tue, 20 Apr 2021 01:40:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zB438UsN4r9986PE2xEGkDVIweUkvDdpBp47AfbjynM=;
        b=ZCMUjIMSawLGDjk84vKdMZJkwD9F9YC/Y+ULvPTlCmQGk6WCK6mo+5w+pNUHTDIO3M
         TXxauaWbi5E45/b5GddgoEXKov/cwOyQohfxBFzvqcrQcqQbE7Pi86SCA6ADK6f/eLgQ
         o+IpPaJOqTCF3dS+WIZgVKsVYW3GtfQATUiwiLiGNLbSWytqvGtgKxvL50Bo3nkWsi2h
         awr+Tg1M8ohfgMu3zMtkFwQwGreDMEo2R25qpGFXEdSDsfNHmFvlAe4uxYyjgRrhO4dh
         pLxkuYHnq/TluP0+uDlB8YuNGfKN7bqP71tq1mmdi9l9AuVX0EUy815eVlmKs7Nqe5sF
         3cMA==
X-Gm-Message-State: AOAM532xi7uTcRLhzGTC2VMP4l0Ylf+wdaR54/4tw7Kda29ilaDmaMeH
        ZL3qSjOHjzDGZ622ORnAJkp5DzacFdGkQIMQa/uRYf1rMaJQpajBK/MPdzhG8bTEKvo/XofqYgN
        jHw89RTRHpKI8
X-Received: by 2002:a17:906:8a79:: with SMTP id hy25mr26634057ejc.461.1618908045440;
        Tue, 20 Apr 2021 01:40:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx/ILxTwqgMLmyPwiD0e4MVWECB2Ha6lNaMT8x9NpakkGaBMmEIL306sPzWycnszm1yervXzg==
X-Received: by 2002:a17:906:8a79:: with SMTP id hy25mr26634034ejc.461.1618908045217;
        Tue, 20 Apr 2021 01:40:45 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id n15sm5177405eje.118.2021.04.20.01.40.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Apr 2021 01:40:44 -0700 (PDT)
Subject: Re: [PATCH v13 05/12] KVM: SVM: Add KVM_SEV_RECEIVE_UPDATE_DATA
 command
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
References: <cover.1618498113.git.ashish.kalra@amd.com>
 <c5d0e3e719db7bb37ea85d79ed4db52e9da06257.1618498113.git.ashish.kalra@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d4488123-daac-3687-6f8d-fb54d6bd4019@redhat.com>
Date:   Tue, 20 Apr 2021 10:40:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <c5d0e3e719db7bb37ea85d79ed4db52e9da06257.1618498113.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/04/21 17:55, Ashish Kalra wrote:
> +	if (!guest_page)
> +		goto e_free;
> +

Missing unpin on error (but it won't be needed with Sean's patches that 
move the data block to the stack, so I can fix this too).

Paolo

