Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C73AD3A2E24
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 16:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231396AbhFJO3l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 10:29:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58043 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230329AbhFJO3l (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Jun 2021 10:29:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623335264;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N6DNMKLHT3A9Uw7dqIlSxdylUPtBFCElwrjN7kz134w=;
        b=gnDmrTcwT2BSt93GS2rJMR4zDjYwZjGIeOPO92vf1kboNlxv7d5kyXBrcS+9T+12V7T17G
        cuhkv+qMrdNfWHQubLfZslT1mrvQIOrf5irkxdaPN7WCg3AEw3ltv/F/BLwI7kTjy2igW4
        JzUs1JTXbLx179Nbqop7IevCTlbN920=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-558-MoAhGjR7MZ2EE_3LGOdJ3w-1; Thu, 10 Jun 2021 10:27:42 -0400
X-MC-Unique: MoAhGjR7MZ2EE_3LGOdJ3w-1
Received: by mail-wm1-f69.google.com with SMTP id z62-20020a1c65410000b0290179bd585ef9so1236123wmb.7
        for <kvm@vger.kernel.org>; Thu, 10 Jun 2021 07:27:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=N6DNMKLHT3A9Uw7dqIlSxdylUPtBFCElwrjN7kz134w=;
        b=g013Q2jHUNFZnc99bFpbgnrM7u903GWFNbbbPL1hG66A+iW1jMZmtpNubbwbjmAtal
         zbvtV8+aHbUZfjf+iAA4LzLe4ddyaD5r0wJBXD/xSXAJ2CeC4nLuWlmBpsVwxmG65vtJ
         jDiJ650DC7oF01aOsdI2KseJfimaqia3F7pkNK1Wq1bTkzom8dVUCh4+SxTTArPA8LQ6
         znDoNwiQtSHGWkk1bVpxNumWdETXf8GBA+veySze3qIwd20qZCRIyamI+8cQaCblhIik
         SVCMo9rFZlmABQDNtJmOunY5GixjZdWCT0FHEFsoDz51n2pwqYa7RmNbDohiwJmToY3f
         Lnmg==
X-Gm-Message-State: AOAM533LFDGtc+DIvn16riaYTqYOTRQVpRHwgnkoiEFvp+0PwHw6IM2M
        PrYqZlrZ4okjjZdV8iE0l1gBBJQxNb8wjVz8XH+Khbp4il141+9AbXxgMcGACT+Eo+pVZtRYhN5
        LZkkxtalTwzkW
X-Received: by 2002:a5d:48ce:: with SMTP id p14mr5937286wrs.170.1623335261088;
        Thu, 10 Jun 2021 07:27:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwxIqPf0gPTIm+AcRWPjCnrWSWI1chNUAiEqawShEhdigKy/ILvZ5JPOfHVT6xJZmeFwMXehA==
X-Received: by 2002:a5d:48ce:: with SMTP id p14mr5937265wrs.170.1623335260941;
        Thu, 10 Jun 2021 07:27:40 -0700 (PDT)
Received: from ?IPv6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.gmail.com with ESMTPSA id z12sm3710561wrw.97.2021.06.10.07.27.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jun 2021 07:27:40 -0700 (PDT)
Subject: Re: [PATCH 3/3 v4] KVM: x86: Add a new VM statistic to show number of
 VCPUs created in a given VM
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
Cc:     jmattson@google.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, joro@8bytes.org
References: <20210609180340.104248-1-krish.sadhukhan@oracle.com>
 <20210609180340.104248-4-krish.sadhukhan@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0b7e77b8-d4da-4d17-b77e-7e5933140077@redhat.com>
Date:   Thu, 10 Jun 2021 16:27:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210609180340.104248-4-krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/06/21 20:03, Krish Sadhukhan wrote:
> 'struct kvm' already has a member for tracking the number of VCPUs created
> in a given VM. Add this as a new VM statistic to KVM debugfs. This statistic
> can be a useful metric to track the usage of VCPUs on a host running
> customer VMs.
> 
> Reported-by: kernel test robot <lkp@intel.com>

Not sure why this "Reported-by", you can remove it.

Please add the statistic to all architectures, in order to avoid the #ifdef.

Paolo

