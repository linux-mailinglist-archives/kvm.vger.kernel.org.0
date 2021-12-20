Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D683147B19D
	for <lists+kvm@lfdr.de>; Mon, 20 Dec 2021 17:49:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239636AbhLTQtl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Dec 2021 11:49:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233029AbhLTQtk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Dec 2021 11:49:40 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 007D9C061574;
        Mon, 20 Dec 2021 08:49:39 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id m21so13650665edc.0;
        Mon, 20 Dec 2021 08:49:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=TG1LEPWtaaPRCPeEzeIT2S9JXmc0iaJFfOGr+6PnaV4=;
        b=n4hqllNd8obLpuYuuJsVcwkuDxzJT0GZKENe6Z81wJGyE9DJl4FlbJTOYdD5NwHZFR
         z8dSUxHrfBtxBHvhd/47XsRGtCPxKVZ9HSgh1+HqmuZhbvwAg+tZoVSeudEyIdJUGXzh
         fNG8M28mvxRjDVJyI9cELly0DkFJvj4m2cX9qzPSN++uyTb5gDVY7zNJ3tbIB0mrNMmr
         aD7XWs+zEM+jvEu4WndmIxo8r3U/5IoQCc3BIcduy76HelDBcMFBe2qOOhVt84fk/C2y
         VSWrMc+vgZyBsZiBo0tKGLAAfl4B4i5m2oZWihJNqdEqWppb7dqyHzcrEtrNk1TB4GQf
         vlKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=TG1LEPWtaaPRCPeEzeIT2S9JXmc0iaJFfOGr+6PnaV4=;
        b=dBBYsB/ObXb30gLBsHRbBq2Gt3uSfI6rDBoErs4fbz1q4DmV/tCV6J/Mz8wWn0liUx
         d2A/5TN1DeSgLStxUZvZSySMClOX4QXY0dYqkz5P5Ytfpx8nZLiK1m66EjXZ4YtwHJSc
         nuWGglwVcfTZrIlF6OIyWaII1D6BiCSv6Cj3jF3jSu2aY4yuM4z5uym7ZplGlFpZAmvn
         7JfLHuMI8BY8KrTkH4YqlqVhMLpjGSGNIxkvERVBIJXQaw9k1EiXcq8IwHjqkAOgTBOo
         IYMyXBHD/pD7LAEESoIbgneJ4ceD63EqSEdOz5STF+znYrQ23/D7oWea8Rq0AMKycGZz
         yetQ==
X-Gm-Message-State: AOAM531gIE5wkqFQxiCfu6pGDbbjFLasmeK5yEi0QQmIo7u+ztq4e3GB
        /jXNd050+hgVQFw3484VtGJSrhRSpuw=
X-Google-Smtp-Source: ABdhPJzG2S9Hbt5W3Fsjel0vTvmo0qaWxikssjVxy1XG1B9hKMRdF2pmkf/wkdP8cAaEIAfX6KbTHQ==
X-Received: by 2002:a17:906:6802:: with SMTP id k2mr13687771ejr.454.1640018978580;
        Mon, 20 Dec 2021 08:49:38 -0800 (PST)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id v19sm5042147edx.75.2021.12.20.08.49.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Dec 2021 08:49:38 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <7fc9348d-5bee-b5b6-4457-6bde1e749422@redhat.com>
Date:   Mon, 20 Dec 2021 17:49:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 0/3] KVM: x86: Fixes for kvm/queue
Content-Language: en-US
To:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>
References: <20211216021938.11752-1-jiangshanlai@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211216021938.11752-1-jiangshanlai@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/16/21 03:19, Lai Jiangshan wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
> 
> Patch 1 and patch 2 are updated version of the original patches with
> the same title.  The original patches need to be dequeued.  (Paolo has
> sent the reverting patches to the mail list and done the work, but I
> haven't seen the original patches dequeued or reverted in the public
> kvm tree.  I need to learn a bit more how patches are managed in kvm
> tree.)

This cycle has been a bit more disorganized than usual, due to me taking 
some time off and a very unusual amount of patches sent for -rc. 
Usually kvm/queue is updated about once a week and kvm/next once every 
1-2 weeks.

> Patch 3 fixes for commit c62c7bd4f95b ("KVM: VMX: Update vmcs.GUEST_CR3
> only when the guest CR3 is dirty").  Patch 3 is better to be reordered
> to before the commit since the commit has not yet into Linus' tree.
> 
> 
> Lai Jiangshan (3):
>    KVM: VMX: Save HOST_CR3 in vmx_prepare_switch_to_guest()
>    KVM: X86: Ensure pae_root to be reconstructed for shadow paging if the
>      guest PDPTEs is changed
>    KVM: VMX: Mark VCPU_EXREG_CR3 dirty when !CR0_PG -> CR0_PG if EPT +
>      !URG
> 
>   arch/x86/kvm/vmx/nested.c | 11 +++--------
>   arch/x86/kvm/vmx/vmx.c    | 28 ++++++++++++++++++----------
>   arch/x86/kvm/vmx/vmx.h    |  5 +++--
>   arch/x86/kvm/x86.c        |  7 +++++++
>   4 files changed, 31 insertions(+), 20 deletions(-)
> 

Queued, thanks.

Paolo
