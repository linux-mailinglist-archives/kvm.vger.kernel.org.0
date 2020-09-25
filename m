Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3C682792E8
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 23:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726849AbgIYVFz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 17:05:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39787 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726309AbgIYVFz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Sep 2020 17:05:55 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601067954;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KYytt9bssGAEWyPGrn3z2bXHN59vb0kbWX+R/SRNIRg=;
        b=TX7Q8T6sVFtwfq78r5EdF1L6EAL5m2Ke41+zAPZwzoxR0m4WpRFYhas+kBqagLvVsWRvwY
        HD36eduovl4FT+XFgGAjsMf7tDQnkus2V0Fti6u0r5yJ23m935yDatrxMAMMZUx1YsyJiG
        0rDG6ZT7TMBHP8BkZgFMQmKEDXD3gWY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-6-BSrT7m8zMH6eD8QZGwIIqQ-1; Fri, 25 Sep 2020 17:05:52 -0400
X-MC-Unique: BSrT7m8zMH6eD8QZGwIIqQ-1
Received: by mail-wr1-f71.google.com with SMTP id 33so1548372wrk.12
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 14:05:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KYytt9bssGAEWyPGrn3z2bXHN59vb0kbWX+R/SRNIRg=;
        b=nV6FmVzOenJTT+L0w8K2tfbQgU7dSqO+JHCc2tGVr3RF3nb11SMCga1NXz7Ri2Iarg
         IvEfRn3PKsqoTiuLEFPK/O7JAdAO57HlZTW0FGY8fC/Pc3MFjpQ4YAkXbiZMKEk9JaH3
         OSjAOgcx2AEaagVkCX4OUxtUQT2xyVnNftuv1EZvW54fFUQkHrYmU9c5jhW5uUpaWuvG
         69ytzJfkZCND+p2HV2va3vUOMkcnsmW+KdXaomt69S+GR0RkOoks3+criXst3ZhucnrM
         xaAm9EVOd1tE2db2yEw/kU6FTgQsMXJ8gwdKOHuo8pLSaGZQjjMXdYqg7ZGOc/J0YMHc
         /rXg==
X-Gm-Message-State: AOAM532cYBVVP1pvmH9fQRXYgjn2M5QqkGhvIRU3oAf/fiBnzEid017T
        BqUObXOyIiQ+OBMN4u64reW/PKYTkvDg4hW5HXxLBcXLhvJw8ykJzmH0XQmxWDNn3IY1AS0qJQ9
        SbbrBVVHRWDRq
X-Received: by 2002:a05:600c:228e:: with SMTP id 14mr457093wmf.17.1601067950963;
        Fri, 25 Sep 2020 14:05:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyXVvhHeab8ly63BYQtucuJlTvz3AS/Mr+Hmurwb2UpVZ7QkUFAEARwgGqla0VJ1OcRKIUZ6A==
X-Received: by 2002:a05:600c:228e:: with SMTP id 14mr457065wmf.17.1601067950750;
        Fri, 25 Sep 2020 14:05:50 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ec9b:111a:97e3:4baf? ([2001:b07:6468:f312:ec9b:111a:97e3:4baf])
        by smtp.gmail.com with ESMTPSA id a15sm4540071wrn.3.2020.09.25.14.05.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2020 14:05:50 -0700 (PDT)
Subject: Re: [RFC PATCH 0/3] KVM: Introduce "VM bugged" concept
To:     Marc Zyngier <maz@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Huacai Chen <chenhc@lemote.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        linux-mips@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        kvm-ppc@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
References: <20200923224530.17735-1-sean.j.christopherson@intel.com>
 <874knlrf4a.wl-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <100a603f-193c-5a46-d428-cfc0ce0a8fe4@redhat.com>
Date:   Fri, 25 Sep 2020 23:05:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <874knlrf4a.wl-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/09/20 18:32, Marc Zyngier wrote:
> I'm quite like the idea. However, I wonder whether preventing the
> vcpus from re-entering the guest is enough. When something goes really
> wrong, is it safe to allow the userspace process to terminate normally
> and free the associated memory? And is it still safe to allow new VMs
> to be started?

For something that bad, where e.g. you can't rule out future memory
corruptions via use-after-free bugs or similar, you're probably entering
BUG_ON territory.

Paolo

