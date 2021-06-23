Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0C803B1F39
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 19:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbhFWRJU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 13:09:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25870 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229688AbhFWRJQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Jun 2021 13:09:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624468018;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nPVt+K/jMh/0Kfe0YLtFKBFaxz7RZ0N0HZlRqVxmqDs=;
        b=HOD6gvLpMMeWQ7nP6RTr6zBHUu9QOjn2ThnKtddJGw+VHTfrMKp52MabyxLCZfwtbsC8+F
        xkoiOpFamfPZLzv7wAq/99O7yjOEdKWtrDggI0rbz87CQTgYBImhfxFf+2LK6mt9U2n5Fz
        lTjwzHhfGZqg2VxWTARizKgQAuu+q40=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-329-1WTeBDB2MSGw7FzurWtAvw-1; Wed, 23 Jun 2021 13:06:57 -0400
X-MC-Unique: 1WTeBDB2MSGw7FzurWtAvw-1
Received: by mail-ed1-f72.google.com with SMTP id t11-20020a056402524bb029038ffacf1cafso1688972edd.5
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 10:06:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nPVt+K/jMh/0Kfe0YLtFKBFaxz7RZ0N0HZlRqVxmqDs=;
        b=fk4VUdYfnf2kjqj4okDrG76g0kDwV7O4HAP65FtCsMxX10H3fcToJwPQfHmAQwf6lb
         40WqB1VZpoqdUchn8yfCFAI+jqDsttrfP8o1hQGDHbRBtyNMBMQSXuD8XRUV1l5shU4C
         3wYXQ7++Jg6ZGEHy7llFRsqDjr6JbXf96xeUEGn0Y7laQ8hI0dK0Q0p+ZkKhGWxCevnR
         an45KIvZ1NHeLbsp2T43wedmIf9zQEEcAYIhzZMfo6RucuhYxiGwd8IMV/e1J9Rx8L0u
         OZ/vQLTB4VwDtDfXDGjNMqkPmAqXsamJAD05HW/aaMnl+L+zjWJkjdY8kEnOKrKKrvaj
         6PSQ==
X-Gm-Message-State: AOAM531mmYEIpYnYJczX1EJ9xzsQ3BDby1MboYb7MCtDztU7FeHDvhPR
        gj4RmYdiaYyqXGnNAuvmxd9Nx4cZ8eMCG0zmz/plY30vt+EGwr/IMYAmaLnqhzDFwPL68UjQjeR
        /fnVJ4fjIXKNu
X-Received: by 2002:a05:6402:b17:: with SMTP id bm23mr1038654edb.173.1624468016146;
        Wed, 23 Jun 2021 10:06:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyLFwygq5KyPf04IwpHKYc7htZRNliOVInK6MiB1I1WnqSCK5JY1zXrVoLimYgI18Y5jIgZ2w==
X-Received: by 2002:a05:6402:b17:: with SMTP id bm23mr1038619edb.173.1624468015958;
        Wed, 23 Jun 2021 10:06:55 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id yh11sm154201ejb.16.2021.06.23.10.06.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 10:06:55 -0700 (PDT)
Subject: Re: [PATCH 15/54] KVM: nSVM: Add a comment to document why nNPT uses
 vmcb01, not vCPU state
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
References: <20210622175739.3610207-1-seanjc@google.com>
 <20210622175739.3610207-16-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b759e31b-6269-a401-9fbb-49227b8be009@redhat.com>
Date:   Wed, 23 Jun 2021 19:06:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210622175739.3610207-16-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/06/21 19:57, Sean Christopherson wrote:
> +	/*
> +	 * L1's CR4 and EFER are stuffed into vmcb01 by the caller.  Note, when
> +	 * called via KVM_SET_NESTED_STATE, that state may_not_  match current
> +	 * vCPU state.  CR0.WP is explicitly ignored, while CR0.PG is required.
> +	 */

"stuffed into" doesn't really match reality of vmentry, though it works 
for KVM_SET_NESTED_STATE.  What about a more neutral "The NPT format 
depends on L1's CR4 and EFER, which is in vmcb01"?

Paolo

