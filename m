Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E80CC3A311F
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 18:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231857AbhFJQo4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 12:44:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36399 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231879AbhFJQoJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Jun 2021 12:44:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623343331;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FTYsk+3ZrtMDgibB9knYQRxYmGEpuIUf1VdElxSCW6k=;
        b=TrMQDsKp+FKHxX4nb0ERe0QpfAZo046yyVth6XhXZarsIKikOxe2S4GuwEE4mHX8KJm5Dl
        R0b7PJQ5LXGxbyXL+DLdbs65laG56d1Sq+pM+SZEBBBKmUnoyC72EXFFILSHrXk6rwnVxm
        HAsklXT37ERwhPDBTzggcxIgBGi4SWc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-209-Q-eGBzA-Of2zDPS0hAF33w-1; Thu, 10 Jun 2021 12:42:10 -0400
X-MC-Unique: Q-eGBzA-Of2zDPS0hAF33w-1
Received: by mail-wm1-f71.google.com with SMTP id r4-20020a7bc0840000b02901b7cb5713ecso1441230wmh.1
        for <kvm@vger.kernel.org>; Thu, 10 Jun 2021 09:42:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FTYsk+3ZrtMDgibB9knYQRxYmGEpuIUf1VdElxSCW6k=;
        b=hc1hxRbQNlKoM36AWGbR+KmJcpFlZv7jyTSWbN61RzQfdswI9yu+i0RJ2nhYnVixOv
         Py+2w9dtUYb4yVpmZWC8ywPZ/4vjPJ2n2w0jTV+ZrfHwuenNURO74DOn+vFM5c5g/+TH
         nLMCa3690rBv0zV3tXccYrfFJ260f8UvqCk84XRy8RI9fRFaHrOlNS7gIKET4nvK43pg
         tu5QP14nr4cJ489/MKVjZ8vmXt7WPEymV4yqk34HDci0a5NzZ7C1ssfyTFCJwOYAMjVy
         Eir/XizODO9QSl6OYTcYKGXFo0vJmqEJr9cLQmKPZlyLqpM/xvM0m10A6GY6V2QJZ5XT
         TpZw==
X-Gm-Message-State: AOAM533Ipohojz3XWiNF57QCeJ/LawjOm1+VrCdGiaDs6hBRYFpXMpDa
        8IAg/uwUHaKd+14H1LGexcE1Y2rFEHIhslSRLeXyiFepmls0rsNgKSPuXsDlKDLdlBSSdmXO1dI
        ODv+LAhuf5aT0
X-Received: by 2002:adf:ab49:: with SMTP id r9mr6556025wrc.237.1623343329060;
        Thu, 10 Jun 2021 09:42:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwT8GKTcc6CtIM2Omfzfm3HSpY3IDEVA0VZ0HkqF8YvTQlmVrTL+SEqxKoSDnFCTA+GbV+zog==
X-Received: by 2002:adf:ab49:: with SMTP id r9mr6556002wrc.237.1623343328880;
        Thu, 10 Jun 2021 09:42:08 -0700 (PDT)
Received: from ?IPv6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.gmail.com with ESMTPSA id f13sm4050941wrt.86.2021.06.10.09.42.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jun 2021 09:42:08 -0700 (PDT)
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
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
References: <20210603211426.790093-1-jingzhangos@google.com>
 <20210603211426.790093-3-jingzhangos@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v7 2/4] KVM: stats: Add fd-based API to read binary stats
 data
Message-ID: <345170fd-636c-f1be-7dc3-69467e51d872@redhat.com>
Date:   Thu, 10 Jun 2021 18:42:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210603211426.790093-3-jingzhangos@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/06/21 23:14, Jing Zhang wrote:
> +struct _kvm_stats_header {
> +	__u32 name_size;
> +	__u32 count;
> +	__u32 desc_offset;
> +	__u32 data_offset;
> +};
> +

Keeping this struct in sync with kvm_stats_header is a bit messy.  If 
you move the id at the end of the header, however, you can use the same 
trick with the zero-sized array that you used for _kvm_stats_desc.

> +struct kvm_vm_stats_data {
> +	unsigned long value[0];
> +};
> +

I posted the patch to switch the VM statistics to 64-bit; you can rebase 
on top of it.

> +#define KVM_GET_STATS_FD  _IOR(KVMIO,  0xcc, struct kvm_stats_header)

This should be _IO(KVMIO, 0xcc) since it does not have an argument.

> +#define STATS_DESC(stat, type, unit, scale, exp)			       \
> +	{								       \
> +		{							       \
> +			.flags = type | unit | scale,			       \
> +			.exponent = exp,				       \
> +			.size = 1					       \
> +		},							       \
> +		.name = stat,						       \

Here you can use

	type | BUILD_BUG_ON_ZERO(type & ~KVM_STATS_TYPE_MASK) |
	unit | BUILD_BUG_ON_ZERO(unit & ~KVM_STATS_UNIT_MASK) |
	scale | BUILD_BUG_ON_ZERO(scale & ~KVM_STATS_SCALE_MASK) |

to get a little bit of type checking.

Paolo

