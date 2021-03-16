Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2747133DB99
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 18:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239385AbhCPRzZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 13:55:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57448 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239413AbhCPRy5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Mar 2021 13:54:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615917296;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q+nIYLcJsbNrOQJXNJzvpf/dZa2SR4YCfI1fCwdaCUY=;
        b=WsvcAM/DVZVN+35RQG4SU18F0p3n/dpdLxLxWAAmKFjaqnh3e65gERW6qfIO7IqkCxJQ8q
        qGH3g4UIkk5SlcSS6KQOmSYkXOMz25ctOFCeD3iIaRz7PMkb+aczhGLtHdL3gNhmH9DLcY
        LB0dVH2+spXH+ePpC9hSAz8ozFvlNls=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270-DJ1QQ5jcNHqT7cngnYUcbA-1; Tue, 16 Mar 2021 13:54:54 -0400
X-MC-Unique: DJ1QQ5jcNHqT7cngnYUcbA-1
Received: by mail-wr1-f70.google.com with SMTP id r12so17073612wro.15
        for <kvm@vger.kernel.org>; Tue, 16 Mar 2021 10:54:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=q+nIYLcJsbNrOQJXNJzvpf/dZa2SR4YCfI1fCwdaCUY=;
        b=tXScWpu63z0147DfPN6WlwXWJ0Lv0noQxEK/xCrefzapI35YWgwRQ//ER0I4qyZxdO
         zr45P2FMidHEhOhrlVPH/8evGyQW9htw4FBzwOrNaVEa0Ukn0g6n/tqTA9SAWN18DzCX
         7U9K2mhQRR+pY5tBuyZRaMB3BWqdlHniju/s9pJiBmXB4iXtkwBjXQ0hzf0RJEeIOZ/2
         ldLdqdCYNF7XalTN6NzTeix0PB8h6ZI/HhmDloXZdnNh3zXS+YikCLH74VsJnzTfdy4O
         gztruzGosskPeFTnm2oWn7kVSue2o6fK39XaGuuUqR/ZmX4ouKpSe/29PCvf7O9ldcOn
         YjMg==
X-Gm-Message-State: AOAM530xsy7IQLb6M+boSq9R6YBiceauT+INI0aKZ57nkHq6tWdgdpol
        D0Ndzi2MmKvDofCL4LJdW5Ui53nhOhPbu9a5E4IAfGtaVDrb4z3JDCmgn0KPgiDKEKa5qqfDLAH
        /3xfKiZXEgxJX
X-Received: by 2002:a7b:c2f7:: with SMTP id e23mr100837wmk.30.1615917293665;
        Tue, 16 Mar 2021 10:54:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyhx2jdBpeYlHU1yJBLoi471Tl00503kY5ZdmFFXsMHSMA2gpxqqBKYhTriICrO+/ourTLAQg==
X-Received: by 2002:a7b:c2f7:: with SMTP id e23mr100818wmk.30.1615917293485;
        Tue, 16 Mar 2021 10:54:53 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id s83sm7994wms.16.2021.03.16.10.54.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Mar 2021 10:54:52 -0700 (PDT)
To:     Jing Zhang <jingzhangos@google.com>
Cc:     KVM <kvm@vger.kernel.org>, KVM ARM <kvmarm@lists.cs.columbia.edu>,
        Linux MIPS <linux-mips@vger.kernel.org>,
        KVM PPC <kvm-ppc@vger.kernel.org>,
        Linux S390 <linux-s390@vger.kernel.org>,
        Linux kselftest <linux-kselftest@vger.kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        David Rientjes <rientjes@google.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>
References: <20210310003024.2026253-1-jingzhangos@google.com>
 <20210310003024.2026253-4-jingzhangos@google.com>
 <bb03107c-a413-50da-e228-d338dd471fb3@redhat.com>
 <CAAdAUth0J6z7fFpOkkmzKc83Bj+MST-jhsZ0uU0iYdRcE_-gMA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH 3/4] KVM: stats: Add ioctl commands to pull statistics
 in binary format
Message-ID: <26035a80-3cce-9872-ab1d-b25b5817d512@redhat.com>
Date:   Tue, 16 Mar 2021 18:54:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <CAAdAUth0J6z7fFpOkkmzKc83Bj+MST-jhsZ0uU0iYdRcE_-gMA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/03/21 23:31, Jing Zhang wrote:
> We are considering about how to create the file descriptor. It might be risky
> to create an extra fd for every vCPU. It will easily hit the fd limit for the
> process or the system for machines running a ton of small VMs.

You already have a file descriptor for every vCPU, but I agree that 
having twice as many is not very good.

> Looks like creating an extra file descriptor for every VM is a better option.
> And then we can check per vCPU stats through Ioctl of this VM fd by
> passing the vCPU index.

The file descriptor idea is not really infeasible I think (not just 
because the # of file descriptors is "only" doubled, but also because 
most of the time I think you'd only care of per-VM stats).

If you really believe it's not usable for you, you can use two ioctls to 
fill the description and the data respectively (i.e. ioctl(fd, 
KVM_GET_STATS_{DESCRIPTION,VALUES}, pdata) using the same layout as 
below.  If called with NULL argument, the ioctl returns how much data 
they will fill in.

The (always zero) global flags can be replaced by the value returned by 
KVM_CHECK_EXTENSION.

The number of statistics can be obtained by ioctl(fd, 
KVM_GET_STATS_VALUES, NULL), just divide the returned value by 8.

Paolo

>> 4 bytes flags (always zero)
>> 4 bytes number of statistics
>> 4 bytes offset of the first stat description
>> 4 bytes offset of the first stat value
>> stat descriptions:
>>     - 4 bytes for the type (for now always zero: uint64_t)
>>     - 4 bytes for the flags (for now always zero)
>>     - length of name
>>     - name
>> statistics in 64-bit format

