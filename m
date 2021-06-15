Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D39863A779D
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 09:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbhFOHIy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 03:08:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54088 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229488AbhFOHIx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 15 Jun 2021 03:08:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623740809;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1bptQkqZVqAajaLHu25xIp56mYAPhq5K+DznNXOGR0E=;
        b=ih96Qtb+AugWtRO4zjNU0hlO0tGSglXwuR1o6G2h/++c+KLXiodeJ2qfomtOc/fKAqWgHl
        Vkjc8gMaggYDZv1q2aHNPa5RQs5se8q6vW8dGMdEt8UscyCLg0k6RgAuxAf7yRIdw35csR
        Bacjc9b6YQT8TPpEAPyB7Ewrb7XFN4k=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-474-bOeb6Za2Nt-piPbjdeE4mw-1; Tue, 15 Jun 2021 03:06:48 -0400
X-MC-Unique: bOeb6Za2Nt-piPbjdeE4mw-1
Received: by mail-ed1-f72.google.com with SMTP id f12-20020a056402150cb029038fdcfb6ea2so21570555edw.14
        for <kvm@vger.kernel.org>; Tue, 15 Jun 2021 00:06:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1bptQkqZVqAajaLHu25xIp56mYAPhq5K+DznNXOGR0E=;
        b=qgDP2gwFJsHuXCDrZDbkymDN0HYcCXGduS8K8Abzsp7INdI3aQvmqYnTtPGsEY62oi
         Ee5ub1fwusDw/XAj28zEIWckW8JQliyfDPwF9iUJ7ItnskeCEOo50A+H3WJcCWZ7u7fg
         Cwfb+OeQ7AzQTxr3oMyvJHxSR3Rz5QM1Vm/0uqjkM/V0UWdP0Fc0axse1gC++ZUMefYI
         Q948qNy7TV6srGwt042O22l9Lp1hDjjDY3WyIYA9+5pv6tz8Rm47WE/4uDe77fAVXP6a
         cE8k6ME1b6W3t6m3a/UhMoJuzQvT7l+xf3dRF8RMmrAPKJL5RIB0+oq6TXdMo/hqaRaz
         t86w==
X-Gm-Message-State: AOAM5330BoSNFTIHyIT9EtVM3e0VMhAwq6c833q+a5bDdB4+NDdDuvl8
        BO2FcPthEGmEnctIweGrejXRRfgPyYVbNX12hBF5W16QSnTydu3kV3W1V1n8IaShYRBSd7hQtHu
        T4GEPe2x6jzIO
X-Received: by 2002:a05:6402:1e8b:: with SMTP id f11mr21756467edf.86.1623740807164;
        Tue, 15 Jun 2021 00:06:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzjr2XSQSGkPxI3dJja1mbqx7MqydkJIqxXPBC64kHnxRq+99yMj0rlssdO/n6Q7TVjtTbx4g==
X-Received: by 2002:a05:6402:1e8b:: with SMTP id f11mr21756454edf.86.1623740806968;
        Tue, 15 Jun 2021 00:06:46 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id d4sm9179485ejo.98.2021.06.15.00.06.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jun 2021 00:06:46 -0700 (PDT)
To:     Leon Romanovsky <leon@kernel.org>,
        Jing Zhang <jingzhangos@google.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>,
        LinuxMIPS <linux-mips@vger.kernel.org>,
        KVMPPC <kvm-ppc@vger.kernel.org>,
        LinuxS390 <linux-s390@vger.kernel.org>,
        Linuxkselftest <linux-kselftest@vger.kernel.org>,
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
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Fuad Tabba <tabba@google.com>
References: <20210614212155.1670777-1-jingzhangos@google.com>
 <YMg5xPbmK3myjIX8@unreal>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v9 0/5] KVM statistics data fd-based binary interface
Message-ID: <15875c41-e1e7-3bf2-a85c-21384684d279@redhat.com>
Date:   Tue, 15 Jun 2021 09:06:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YMg5xPbmK3myjIX8@unreal>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/06/21 07:25, Leon Romanovsky wrote:
> Sorry for my naive questions, but how does telemetry get statistics
> for hypervisors? Why is KVM different from hypervisors or NIC's statistics
> or any other high speed devices (RDMA) that generate tons of data?

Right now, the only way is debugfs but it's slow, and it's disabled when 
using lockdown mode; this series is a way to fix this.

I sense that there is another question in there; are you wondering if 
another mechanism should be used, for example netlink?  The main issue 
there is how to identify a VM, since KVM file descriptors don't have a 
name.  Using a pid works (sort of) for debugfs, but pids are not 
appropriate for a stable API.  Using a file descriptor as in this series 
requires collaboration from the userspace program; howver, once the file 
descriptor has been transmitted via SCM_RIGHTS, telemetry can read it 
forever without further IPC, and there is proper privilege separation.

Paolo

