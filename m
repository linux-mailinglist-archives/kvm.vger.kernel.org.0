Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F29EE055D
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 15:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731334AbfJVNmk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 09:42:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34188 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726142AbfJVNmk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Oct 2019 09:42:40 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BDBD1C053B26
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2019 13:42:39 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id l4so6529174wru.10
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2019 06:42:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=05dJAtGauU0iv5NowbhOU9V3c7+LulyhjnirlWXm1KU=;
        b=lyzIQ842n/XP8pfxZvKTuaux3eOwU8zQa4ueuN2qu4FcFq9tRkGhiUbTlepClmC2Dn
         OhxqtB47PwRe6BM9VVpgQ5n/aZ0eTJH8fKvfgVEXwJrh00VTpaI4/4NZYasj7FzhHaRr
         7PUCCG+AEZhF7oEk99AgaCXVF/G0E7r+8GNTz8YVWFaKkrlx8ZiZbm80+IMOqx5M4BcL
         d6fOjLtoVK1Cw0JFoq19zQIJO0DIDhYLefT90N32sgMd9l7cZ9sB9diKCeYuePv7SHR1
         1Knb+ciUswqEe0MtGvuwpuek+eSI23JZDgK7n475ZZ9ZKAIO09pVc4tfucdd1qvn6BZR
         jQaA==
X-Gm-Message-State: APjAAAVVbxw5V2gCbnJl07b14zftu9IBq+HC3XH8u1IsFRv7MSpbHwMK
        BeZsRBI8fwvjji0qZXm3Eh5IFv/I7AFJDk3raT64mj8WdI6IGJ4izmAUjtJET1EBRUcork9Ucg8
        IyF9gzbU+To3p
X-Received: by 2002:a05:600c:1107:: with SMTP id b7mr3339163wma.151.1571751758406;
        Tue, 22 Oct 2019 06:42:38 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzMh5FUqHuanmjm92TrlNFZyUpguRk5xXpG2bL4t+/5nKpwjNbkxF5tNwPtsN6voB8mSIllyw==
X-Received: by 2002:a05:600c:1107:: with SMTP id b7mr3339133wma.151.1571751758104;
        Tue, 22 Oct 2019 06:42:38 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c0e4:dcf4:b543:ce19? ([2001:b07:6468:f312:c0e4:dcf4:b543:ce19])
        by smtp.gmail.com with ESMTPSA id p20sm14205910wmc.23.2019.10.22.06.42.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Oct 2019 06:42:37 -0700 (PDT)
Subject: Re: [PATCH v3 0/4] Minor cleanup and refactor about vmcs
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20191020091101.125516-1-xiaoyao.li@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <1dcf5ad8-bca9-c797-e0f8-3fd25c8ea5ca@redhat.com>
Date:   Tue, 22 Oct 2019 15:42:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191020091101.125516-1-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/10/19 11:10, Xiaoyao Li wrote:
> There is no functional changs, just some cleanup and renaming to increase
> readability.
> 
> Patch 1 is newly added from v2.
> Patcd 2 and 3 is seperated from Patch 4.
> 
> Xiaoyao Li (4):
>   KVM: VMX: Write VPID to vmcs when creating vcpu
>   KVM: VMX: Remove vmx->hv_deadline_tsc initialization from
>     vmx_vcpu_setup()
>   KVM: VMX: Initialize vmx->guest_msrs[] right after allocation
>   KVM: VMX: Rename {vmx,nested_vmx}_vcpu_setup()
> 
>  arch/x86/kvm/vmx/nested.c |  2 +-
>  arch/x86/kvm/vmx/nested.h |  2 +-
>  arch/x86/kvm/vmx/vmx.c    | 50 +++++++++++++++++++--------------------
>  3 files changed, 26 insertions(+), 28 deletions(-)
> 

Queued, thanks.

Paolo
