Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8052BA50E
	for <lists+kvm@lfdr.de>; Fri, 20 Nov 2020 09:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727338AbgKTIsd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Nov 2020 03:48:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36305 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727256AbgKTIsd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Nov 2020 03:48:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605862112;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A24NRq4kN591HRlf9DuAZ4RIC1dsLofoBVFRvzY36Co=;
        b=alJpRn2tHUrzNxWK5NFP4hOmNlJ6wZEi9w20BGOXis92ALIjAtKpNC3mUWfr/qgs5dKbJS
        AlF9KYn0pfJNVf0qi3Z+Opg5PeJ1Fy+KQtuNd5040DjQ/AKQGJticRAG1lz1IH6FCkJo3C
        SdsYjTShAdGKCnA5LFcIu1yJpvsnhkI=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-311-XBwYH-KjPI-Y3j0pkJ49QA-1; Fri, 20 Nov 2020 03:48:30 -0500
X-MC-Unique: XBwYH-KjPI-Y3j0pkJ49QA-1
Received: by mail-ed1-f71.google.com with SMTP id n25so3491598edr.20
        for <kvm@vger.kernel.org>; Fri, 20 Nov 2020 00:48:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=A24NRq4kN591HRlf9DuAZ4RIC1dsLofoBVFRvzY36Co=;
        b=PXo3QEGTgpGExFoipPncAUJPbWoFxxmMYVS1BLwQs0SrrEw0G0dK5LT28h1Ji7ni72
         DSXVX4mTOvPTkfk480yq/1L9zM44SPhtJ2OMigrHd8CEeNSvjtZnFOJILw6Ptzt16Dz3
         ikC9FQGd4z43HKptkV4SeuSi5mIDfsEkYqU9nXKo8JBjk4PwpaculEDIQx3oMx9BWyFd
         hGvBOFauQFgghuejDa//qHnr6R7escEra6tJFqPzwQocqzcyETPHI1eB8NA7wi3Drfdj
         rLVAzuE8HQfe6l81YbEYAqYpjxUZUAW0ozKsaPdk5tsC9bQeDSMbgJTK8qwQwzxet6T8
         hKLw==
X-Gm-Message-State: AOAM531PZPQIBw43NdAVB+AVPmbAmF+fhVFvkoS+iXG2NGwtRUAESxr6
        JHFhx6MHzu2tclHbt55EGF6yrC0hwlVsyn/Z9cxsMh2r2NfcIeI3P3G/DVEiCUovsZUj6PD80yP
        A3rIxi1w+rJSs
X-Received: by 2002:aa7:d787:: with SMTP id s7mr33272895edq.205.1605862109003;
        Fri, 20 Nov 2020 00:48:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyoR+fbsZRwbnSHfxD2OZlRlLT91wi8zkTEV9cRnD3Y1J4l4kzIGkCdE2WATZS329q/DZwrzQ==
X-Received: by 2002:aa7:d787:: with SMTP id s7mr33272886edq.205.1605862108822;
        Fri, 20 Nov 2020 00:48:28 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id j5sm851993eja.47.2020.11.20.00.48.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2020 00:48:28 -0800 (PST)
Subject: Re: [PATCH v3 0/4] KVM: selftests: Cleanups, take 2
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        bgardon@google.com, peterx@redhat.com
References: <20201116121942.55031-1-drjones@redhat.com>
 <902d4020-e295-b21f-cc7a-df5cdfc056ea@redhat.com>
 <20201120080556.2enu4ygvlnslmqiz@kamzik.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6c53eb4d-32ed-ed94-a3ef-dca139b0003d@redhat.com>
Date:   Fri, 20 Nov 2020 09:48:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201120080556.2enu4ygvlnslmqiz@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/11/20 09:05, Andrew Jones wrote:
> So I finally looked closely enough at the dirty-ring stuff to see that
> patch 2 was always a dumb idea. dirty_ring_create_vm_done() has a comment
> that says "Switch to dirty ring mode after VM creation but before any of
> the vcpu creation". I'd argue that that comment would be better served at
> the log_mode_create_vm_done() call, but that doesn't excuse my sloppiness
> here. Maybe someday we can add a patch that adds that comment and also
> tries to use common code for the number of pages calculation for the VM,
> but not today.
> 
> Regarding this series, if the other three patches look good, then we
> can just drop 2/4. 3/4 and 4/4 should still apply cleanly and work.

Yes, the rest is good.

Paolo

