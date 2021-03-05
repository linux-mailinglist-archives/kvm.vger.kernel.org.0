Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79CB732F1DE
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 18:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229465AbhCERxK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Mar 2021 12:53:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45270 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229783AbhCERwu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Mar 2021 12:52:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614966769;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iwTUMCcDk00xNetkHK1hGOt7MdI+EmpsAycWvHQG5xE=;
        b=R7ZxebugkABt1ONG23MHUByX6t7Z3jAwhijo/0eI5p+5EWoTxettUU22Q0Zd3DAbGFTRke
        H5sxuc6Gw0Imec+fJtFjnSuyHI2bzPinJyzb1ePosQRoJ1LvIzS/8AaE8bNMvfmOxlrT4/
        oth9K38dhlmVtwLMFoBRGzQs3Y+yZ6k=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-561-HEFb98HhNmyneJ2wvtA5-Q-1; Fri, 05 Mar 2021 12:52:48 -0500
X-MC-Unique: HEFb98HhNmyneJ2wvtA5-Q-1
Received: by mail-wr1-f72.google.com with SMTP id g5so1348976wrd.22
        for <kvm@vger.kernel.org>; Fri, 05 Mar 2021 09:52:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iwTUMCcDk00xNetkHK1hGOt7MdI+EmpsAycWvHQG5xE=;
        b=ZrPB4ezxjjddlFNfPW/rw7QzadgzOaxZf33pLzlJ/2CHS6I/pJAUyJQ2d20RjM2PTZ
         gUrstQ1EQtD4o9ydI4gmhkuAuIei3R+/utBeb+nyFyWmFK7dWl8/mzVZsBuzPvUjzh0E
         w/rG9d7VsxtT+O3CJaRk6C5UssPcqhkBH4+IA3XkwXIi+CXhzT4IpDWpM6K5GuT2YqrQ
         /P+WmuPHaqwL0AOZtvduXl57E/+re0LqGH31GEyv8E7VcYpuQYknjPlmZIxNMgcA8qOU
         YAO4U42o5tfAnkd7+NiUeMmf7tIApIeMWBzo3cfbm39GvOczB3mq06aM5hk6U7Y3Kjb5
         Vhow==
X-Gm-Message-State: AOAM532SC0Xg0uev0ra/jQkMJBGlrQ+ABaqSbcrygQ4jd+apH+96j0qc
        njnABRhtO5vlvWMHBWnxtdY2EM5GmH0Ksrb0WTN97iyqU/OYwHALVYSi1lFX9Izsmqgtj7///R3
        uUgfsCmYllA/L
X-Received: by 2002:adf:e412:: with SMTP id g18mr10832920wrm.159.1614966766373;
        Fri, 05 Mar 2021 09:52:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJztT0w4Di9/TF3GU88h8n5kTz6vIOB4/z08cfkSJ5CRd8Qk58FwubiiaShGjTbCmT7i5nN8EA==
X-Received: by 2002:adf:e412:: with SMTP id g18mr10832908wrm.159.1614966766186;
        Fri, 05 Mar 2021 09:52:46 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id c26sm5938195wrb.87.2021.03.05.09.52.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Mar 2021 09:52:45 -0800 (PST)
Subject: Re: [PATCH v2 09/17] KVM: x86/mmu: Use '0' as the one and only value
 for an invalid PAE root
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
References: <20210305011101.3597423-1-seanjc@google.com>
 <20210305011101.3597423-10-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <63d2a610-f897-805c-23a7-488a65485f36@redhat.com>
Date:   Fri, 5 Mar 2021 18:52:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210305011101.3597423-10-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/03/21 02:10, Sean Christopherson wrote:
> Use '0' to denote an invalid pae_root instead of '0' or INVALID_PAGE.
> Unlike root_hpa, the pae_roots hold permission bits and thus are
> guaranteed to be non-zero.  Having to deal with both values leads to
> bugs, e.g. failing to set back to INVALID_PAGE, warning on the wrong
> value, etc...

I don't dispute this is a good idea, but it deserves one or more comments.

Paolo

