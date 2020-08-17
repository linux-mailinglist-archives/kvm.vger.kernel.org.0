Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8512124737A
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 20:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731761AbgHQS4w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Aug 2020 14:56:52 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:56855 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731575AbgHQS42 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Aug 2020 14:56:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597690585;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P+SWVW+pjg81S9WWqotQ3smvkOJqzR+CExLaQMZK0Pw=;
        b=Q/hsqM8I1IA1A2Csj8E/CJWcCySYokbi0wnDz4vVjX7E2sELmz+D/v38jTOu6NpFPTl6pw
        +Dsl++ULV1dc1WSoAzHbNHxmIuWR1SpFVN4ylqR5qLWRzOWgvrRfAnq5Uvz2M2dmfeo10t
        XF7UYGArExM3gghVBStvbB6zK9q6HLg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-504-QjsY_CspNCm6KqmeWugVog-1; Mon, 17 Aug 2020 14:56:23 -0400
X-MC-Unique: QjsY_CspNCm6KqmeWugVog-1
Received: by mail-wm1-f70.google.com with SMTP id u144so6347197wmu.3
        for <kvm@vger.kernel.org>; Mon, 17 Aug 2020 11:56:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=P+SWVW+pjg81S9WWqotQ3smvkOJqzR+CExLaQMZK0Pw=;
        b=AmSTinJsxJ6eKoIK4plJVL+aSKqJD+w+zOgAv656jyDmTI6ERxK9ccfTq6y8d1TKr8
         hT9n5D5RGBiKODHmwoSvg4n+fIWYxWe3eSTp/TWfNKnsBnrGjvcsHhiU7P43q3Wl8a8x
         zcIYXrSYd29GP8OXLQe1mHbSbdYNkYLQjO1Tlk5EKeJx39WpxKK5RZAucxd/DVP/0j7R
         /tllPFlgIO4YU2zJPazLFdo12YEDMQr7Nszed5+wbViJ+nbLx9ZP4LY73HsVlhA06HM0
         mLsHn74Qm+2rBIPTaDTUCCihj7KZkUhH2Dr/7SFEn0Ta/KvwWdrzGotSPVOvRpt/ns2z
         fPAw==
X-Gm-Message-State: AOAM530z7HzBc/ErB/xV44tKwuXW0S7qrSA1Is51rpRIa/D1sS3cF3Je
        h9y/WKpZnKgNmGthAYsptUX4hu0HS+CipC1EwlYDoys6X3o5Tk90JJAzCZ+yilKhN05DUz80c+l
        WIyc48kYazYgi
X-Received: by 2002:a1c:7705:: with SMTP id t5mr16436383wmi.112.1597690582494;
        Mon, 17 Aug 2020 11:56:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxV6kFCk0mELAK5UYZBHElUrR6OjmsPsIgsjsuvWmke05COroSNIAs3VHHaBHPOCPA2bimU5A==
X-Received: by 2002:a1c:7705:: with SMTP id t5mr16436367wmi.112.1597690582208;
        Mon, 17 Aug 2020 11:56:22 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:a0d1:fc42:c610:f977? ([2001:b07:6468:f312:a0d1:fc42:c610:f977])
        by smtp.gmail.com with ESMTPSA id r3sm29893163wro.1.2020.08.17.11.56.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2020 11:56:21 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86: fix access code passed to gva_to_gpa
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20200817180042.32264-1-pbonzini@redhat.com>
 <20200817184226.GJ22407@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <77e46758-4b00-9db9-13ab-329c6dad66f3@redhat.com>
Date:   Mon, 17 Aug 2020 20:56:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200817184226.GJ22407@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/08/20 20:42, Sean Christopherson wrote:
> 
> Don't suppose you'd be in the mood to kill the bare 'unsigned'?
> 
>   WARNING: Prefer 'unsigned int' to bare use of 'unsigned'

u32 is even better.

> Alternatively, what about capturing the result in a new variable (instead of
> defining the mask) to make the wrap suck less (or just overflow like the
> current code), e.g.:
> 
>         u32 access = error_code &
>                      (PFERR_WRITE_MASK | PFERR_FETCH_MASK | PFERR_USER_MASK);
> 
>         if (!(error_code & PFERR_PRESENT_MASK) ||
>             vcpu->arch.walk_mmu->gva_to_gpa(vcpu, gva, access, &fault) != UNMAPPED_GVA) {

Sure, that's better.

Paolo

