Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 491AA3AA232
	for <lists+kvm@lfdr.de>; Wed, 16 Jun 2021 19:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbhFPROn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Jun 2021 13:14:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59338 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230490AbhFPROm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 16 Jun 2021 13:14:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623863555;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9dwXJG+e2J+zj861tULnfcQYsx7+UyssMsGTwpLEmFo=;
        b=F9cKU2KFrGBw6EawNPfBo7T/xWCp4t7qiVVzKKLaFquZWs5IBFo8kMsseFKnLRqDqnTBH7
        wEe1edPqJUnKytGn8hUQvFU9MsbW3CvsTrp/QzL90yTZ1gzG8awNRXo6iLMM069L4+eC+n
        VsBzQVtgGgh7oiYMRnCHkh8lDA4gNp8=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-111-LJkUSZCTNRGMOU43VJoc0Q-1; Wed, 16 Jun 2021 13:12:23 -0400
X-MC-Unique: LJkUSZCTNRGMOU43VJoc0Q-1
Received: by mail-ej1-f70.google.com with SMTP id k1-20020a17090666c1b029041c273a883dso1239130ejp.3
        for <kvm@vger.kernel.org>; Wed, 16 Jun 2021 10:12:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9dwXJG+e2J+zj861tULnfcQYsx7+UyssMsGTwpLEmFo=;
        b=bprYeH9BGVfdwvb5pR/pxTuKC4DfsV7tlxNW9N5lt+sdlgGsa2tg862banI4exxHsF
         ZTHsmFGengsx+VDjRcM3e8pbVO/hayAb0S1a9Nsk9/poLyhC8X4j+AULATUcXkXECiw9
         US00yxoP1VcHDQwve7F7/pHCEyMQu1UdXx8JD7V0WJx42rwGZU/FGizPc4hXhjfBatxB
         kjc+6arHKilE1FUEWClpNnojQSX0gaGY/WdxT6RykGTUBbP0vAeOzFqAmjc3MK+AkOp+
         Rm+YxV5et5HUkD5kGEfp2P6YU1zXqqjugbUCHa5F0kQeJtm8nMNhy0hVNwdBhk1mm8zW
         2CJg==
X-Gm-Message-State: AOAM5313cQYBJFN4PlUT5ppX58qJ3Pxyd2NqKUptjSXuFmHbJtnlzaKP
        XtUrHF3UDGuy2Qkczt1fVaJrztOl9GLu7e4t+xS2RAErsYQoAckQkVkKYtIAQDdpcDeLlwEXVae
        eu623IsWGaBRJ
X-Received: by 2002:a17:906:63d2:: with SMTP id u18mr605556ejk.186.1623863541221;
        Wed, 16 Jun 2021 10:12:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzTKt1qnrMXcwrhxVgt67u44Y8CuaXLcDbu0P6sbQSAbP+DQ5wAsoiwPjVbuTt+umuJCe/+bA==
X-Received: by 2002:a17:906:63d2:: with SMTP id u18mr604976ejk.186.1623863534799;
        Wed, 16 Jun 2021 10:12:14 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id n2sm2261519edi.32.2021.06.16.10.12.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Jun 2021 10:12:13 -0700 (PDT)
To:     Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
        KVMARM <kvmarm@lists.cs.columbia.edu>,
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
 <20210614212155.1670777-3-jingzhangos@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v9 2/5] KVM: stats: Add fd-based API to read binary stats
 data
Message-ID: <60b0d569-e484-f424-722b-eb7ba415e19b@redhat.com>
Date:   Wed, 16 Jun 2021 19:12:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210614212155.1670777-3-jingzhangos@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/06/21 23:21, Jing Zhang wrote:
> +	/* Copy kvm stats values */
> +	copylen = header->header.data_offset + size_stats - pos;
> +	copylen = min(copylen, remain);
> +	if (copylen > 0) {
> +		src = stats + pos - header->header.data_offset;
> +		if (copy_to_user(dest, src, copylen))
> +			return -EFAULT;
> +		remain -= copylen;
> +		pos += copylen;
> +		dest += copylen;
> +	}

Hi Jing,

this code is causing usercopy warnings because the statistics are not 
part of the vcpu slab's usercopy region.  You need to move struct 
kvm_vcpu_stat next to struct kvm_vcpu_arch, and adjust the call to 
kmem_cache_create_usercopy in kvm_init.

Can you post a new version of the series, and while you are at it 
explain the rationale for binary stats in the commit message for this 
patch?  This should include:

- the problem statement (e.g. frequency of the accesses)

- what are the benefits compared to debugfs

- why the schema is included in the file descriptor as well

You can probably find a lot or all of the information in my emails from 
the last couple days, but you might also have other breadcrumbs from 
Google's internal implementation of binary stats.

Thanks,

Paolo

