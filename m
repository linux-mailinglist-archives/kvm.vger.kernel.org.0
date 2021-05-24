Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82F2C38E89E
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 16:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233064AbhEXOXT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 10:23:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56384 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232953AbhEXOXS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 May 2021 10:23:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621866110;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FtLNrgQat4DaBKnFc4cMDPsloHXGjUgm3sQMwDpqAR8=;
        b=b/3BOzkQeW+ifTNuPANOjVomyb6rV93TdIIQQrD9ZO3IPbPVDAnvJKMIu4yfjoOoBW4g7F
        2oAyFaxYvVol+oh/yvgOdChti3Zi5LsrAM08+ve182T6f638ZXliVvkTME+pjfYnm70a8M
        e6PBogR9n80XvxvRLVcesl/lnTyzmlc=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-540-4k_lgJyuMl256k3SQDDdKw-1; Mon, 24 May 2021 10:21:46 -0400
X-MC-Unique: 4k_lgJyuMl256k3SQDDdKw-1
Received: by mail-ej1-f71.google.com with SMTP id p5-20020a17090653c5b02903db1cfa514dso4408320ejo.13
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 07:21:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FtLNrgQat4DaBKnFc4cMDPsloHXGjUgm3sQMwDpqAR8=;
        b=UfIwahLvap3Gv3Q9F7+fN/6UKIFBZo1sFTOmYcBvXNhuRVgRg2WRE9VmawrjVARGWk
         QBwmpg+0hWA2G19Nzc+Vb0bKco6MECbRlRIpCdymXMdNQoETekkQOeCbtjTfnDBSdM/l
         hac6KeKNM+AK2B/HORt7GS/VOwO0GFVv/9rJyEo/XR70PLrSZnbxiX+TRti1xmEeHoMz
         0MCIGKnxOPR+xKTu74mso5GQRCrTOT4CB5RcElxBDPiVvLoHv5EwHgchbiI84Cjt/YV+
         SswKUDuahGXSSoxrzCiH8uWxKA0xzelmuAi2p0j5jNHEjAocwaf6/y4IcZFZNcegbc3T
         7L4Q==
X-Gm-Message-State: AOAM533ucCNRgK2JczFF9D3q06wmnoRV58X9y+Fe7BYhWS4ELuXuBAzL
        bHuIG1BPY+rdp/4W+r5oP/j2GLowHJPFRc51rXIyetW1jxLuSPpTzcjNkIkZeceEEaK/3qgrygq
        UJIO3KEZgA63L
X-Received: by 2002:a05:6402:40d0:: with SMTP id z16mr26423827edb.104.1621866105378;
        Mon, 24 May 2021 07:21:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyR+0p1k427GO9oANu1bLB4B/yZb4L+zyt2tto7xC4xcyev462iXNyMH0CSe+gUpYh24wZbTA==
X-Received: by 2002:a05:6402:40d0:: with SMTP id z16mr26423806edb.104.1621866105252;
        Mon, 24 May 2021 07:21:45 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id k21sm8006593ejp.23.2021.05.24.07.21.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 May 2021 07:21:44 -0700 (PDT)
Subject: Re: [PATCH v3 03/12] KVM: X86: Rename kvm_compute_tsc_offset() to
 kvm_compute_tsc_offset_l1()
To:     Ilias Stamatis <ilstam@amazon.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     mlevitsk@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        zamsden@gmail.com, mtosatti@redhat.com, dwmw@amazon.co.uk
References: <20210521102449.21505-1-ilstam@amazon.com>
 <20210521102449.21505-4-ilstam@amazon.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4526ec66-c531-262d-9661-13d134e2a84a@redhat.com>
Date:   Mon, 24 May 2021 16:21:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210521102449.21505-4-ilstam@amazon.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/05/21 12:24, Ilias Stamatis wrote:
> +			u64 adj = kvm_compute_tsc_offset_l1(vcpu, data) - vcpu->arch.l1_tsc_offset;

Better: kvm_compute_l1_tsc_offset.  So far anyway I can adjust this myself.

Paolo

