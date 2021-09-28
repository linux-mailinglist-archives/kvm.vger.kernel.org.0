Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4B0141B471
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 18:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241882AbhI1Qx1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 12:53:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47842 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241876AbhI1Qx1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Sep 2021 12:53:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632847907;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K0U/aUim/4LHhbhUv9UEUbwD6KDK/YSTUb8tP/0dO0Y=;
        b=aKJjB+ZemIaTE+lVG9Ekv3vuFZcQafL32p4kRc1sAA+JwK9S3gAwIclrYwbIjnVamyw96J
        kGs00AXRqk7uufBQng6sxO3bvGJq72sFFn3Eg5C0/HuXQPpLr/wzQssHcbKr845IjI5unO
        xXR8MZmuiUsSsNS11NPElx70dg8NZrs=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-459-M7L_uYmoPvqR8st_KhXKhA-1; Tue, 28 Sep 2021 12:51:46 -0400
X-MC-Unique: M7L_uYmoPvqR8st_KhXKhA-1
Received: by mail-ed1-f71.google.com with SMTP id e21-20020a50a695000000b003daa0f84db2so10289edc.23
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 09:51:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=K0U/aUim/4LHhbhUv9UEUbwD6KDK/YSTUb8tP/0dO0Y=;
        b=CH96bYIR9QX0//GzBEoGxjn7N7kF/zZR7R1b0A6SKpGPFIZZPMswlsd01IXcIxCJPA
         QaMgwB4pVMqilYArmlNRNUM9cNRHnER6nuOADqK3t+mf9xnI2uZWfIrFnlwyetYlnnsJ
         a0qKF5QK+7xbQIjjO9Ny5WBJ4TSTEiMa+DrzinYYMstMO4tw2jZ7PkNYqhxf4GLdzZ+F
         W5/xRDKZvBSBhsXOo+XgM4RYX/Te6qiaL1VPRmANUNdMimpn2I3WCHKTdWdJD0603zSB
         9eWRDj2MwXfDgS04C5b1v6O0rQ4/p7Krp0RJXh5cAG8IwGz5Odj8Pdjof49ToTkmvJRw
         c3bw==
X-Gm-Message-State: AOAM531apFnls7qUAS8iw/y2FJsAVYYnj5r1Vk8WngoMGi3amqaTXex/
        Gk0NV+LF0fZnVvhPQ0NAQGC2SVZytSUlNhUh9viWalEzkUxwthD+Pv9QkM3rBNjdJemgZejYCC+
        gmKALlug0xjbf
X-Received: by 2002:a17:906:bfe7:: with SMTP id vr7mr7845983ejb.32.1632847904920;
        Tue, 28 Sep 2021 09:51:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxrgO30G5UqckzSQL/S2GTFgTozWvqhmKmQoBR4II1OCTVmjMnRsHAH/sjMzvRkHvA+3JbhaQ==
X-Received: by 2002:a17:906:bfe7:: with SMTP id vr7mr7845959ejb.32.1632847904757;
        Tue, 28 Sep 2021 09:51:44 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id u18sm5378579ejc.26.2021.09.28.09.51.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Sep 2021 09:51:43 -0700 (PDT)
Message-ID: <46b08118-b5a2-ee9b-f0fa-49f830465243@redhat.com>
Date:   Tue, 28 Sep 2021 18:51:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2 2/4] nSVM: introduce smv->nested.save to cache save
 area fields
Content-Language: en-US
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        kvm@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
References: <20210917120329.2013766-1-eesposit@redhat.com>
 <20210917120329.2013766-3-eesposit@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20210917120329.2013766-3-eesposit@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/09/21 14:03, Emanuele Giuseppe Esposito wrote:
> +static void copy_vmcb_save_area(struct vmcb_save_area_cached *dst,
> +				struct vmcb_save_area *from)
> +{
> +	/*
> +	 * Copy only necessary fields, as we need them

"Copy only fields that are validated" etc.

Paolo

> +	 * to avoid TOC/TOU races.
> +	 */

