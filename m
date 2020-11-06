Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 489EC2A95DD
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 12:56:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727171AbgKFL4R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Nov 2020 06:56:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34266 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726692AbgKFL4Q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Nov 2020 06:56:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604663775;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OW+qpfnwmusZdBd4n0rGylOC9dvfR6PK3w8y9m68mNo=;
        b=E6j1jMglaiBjnhGsuTl+JCePZrmDW35ZRzZr2vwlM3sjCJvxDw74PA0RwL4U/R7lCQFerA
        eF1ThX0kMTQUGoQ7Kr7DUxzFQJYsTZKIa+pOq02EJkWPNQkPTcPYyB6D/8hT6E6aDVreeC
        t/qYHr4IafWPbIFPToFWSxw7FHj0kxs=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-25-ix_ABsjrM3GL-CnF8ROgyA-1; Fri, 06 Nov 2020 06:56:13 -0500
X-MC-Unique: ix_ABsjrM3GL-CnF8ROgyA-1
Received: by mail-wr1-f71.google.com with SMTP id e18so375148wrs.23
        for <kvm@vger.kernel.org>; Fri, 06 Nov 2020 03:56:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OW+qpfnwmusZdBd4n0rGylOC9dvfR6PK3w8y9m68mNo=;
        b=QBqq0Ex1OwHpOEe9DoIUnzse2FWHL+Sl4+VVMXeMhf3f93TYIW5QJHY9QqNZvN/bkZ
         TmPXfP/M30DW4WjFWKLPlndO2isv0KnVX9NQrPpQ5OB3144YmFyORFHss5JiBUOTZhhI
         HH018RMuurLqHXdHGn6aKnWqYgritd9imqGVM0JJgKUxQzZcitJCGbg7SOxEktZpTDDM
         wu5VMEtaxsi0zywGJaLBbeK82XiNx9Gl5Fp68yeW5lwH/8Ksj44Ugx0Je4hyd7T/AZog
         k0jJOZfL8lcIT71w9uhTWbL2emRnI4AUhrB1ryZSu115Jn8MM+vLurrtPUmMy6COvj8i
         8nug==
X-Gm-Message-State: AOAM532592NRJ+gJzuNrpuwM9U2XHVgNbGwAxKJ4TLsxWARxmJCotLAj
        5QWk1XtClZwob8xqVuPjV4VBdt2bq+Hb+MTMJxFOZE5tyV+zgsBGCGTqyoXsvXB92Kj8RMUppDO
        LFZ/B7UDYFrcK
X-Received: by 2002:a05:6000:104c:: with SMTP id c12mr2187907wrx.133.1604663772717;
        Fri, 06 Nov 2020 03:56:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy369cKIoJbsAe2M78hLDqCr2GfOHQrZgyjJNdPy4V2224Mtiksu/FvjsRjiIhTxm0IfJcnDA==
X-Received: by 2002:a05:6000:104c:: with SMTP id c12mr2187891wrx.133.1604663772494;
        Fri, 06 Nov 2020 03:56:12 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id j9sm1754764wrr.49.2020.11.06.03.56.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Nov 2020 03:56:11 -0800 (PST)
Subject: Re: [PATCH][v3] KVM: x86/mmu: fix counting of rmap entries in
 pte_list_add
To:     "Li,Rongqing" <lirongqing@baidu.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>
References: <1601196297-24104-1-git-send-email-lirongqing@baidu.com>
 <5acfbee6941e46118eb4479b79233368@baidu.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <63de4a41-04fe-0a2b-e20b-6381eaebc6f6@redhat.com>
Date:   Fri, 6 Nov 2020 12:56:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <5acfbee6941e46118eb4479b79233368@baidu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/10/20 03:57, Li,Rongqing wrote:
> 
> 
>> -----Original Message-----
>> From: Li,Rongqing
>> Sent: Sunday, September 27, 2020 4:45 PM
>> To: Li,Rongqing <lirongqing@baidu.com>; kvm@vger.kernel.org;
>> x86@kernel.org; sean.j.christopherson@intel.com
>> Subject: [PATCH][v3] KVM: x86/mmu: fix counting of rmap entries in
>> pte_list_add
>>
>> Fix an off-by-one style bug in pte_list_add() where it failed to account the last
>> full set of SPTEs, i.e. when desc->sptes is full and desc->more is NULL.
>>
>> Merge the two "PTE_LIST_EXT-1" checks as part of the fix to avoid an extra
>> comparison.
>>
>> Signed-off-by: Li RongQing <lirongqing@baidu.com>
>> Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> 
> Ping
> 
> 
> Thanks
> 
> -Li
> 

Queued, thanks.

Paolo

