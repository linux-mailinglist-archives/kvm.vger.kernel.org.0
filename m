Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB8A1A647E
	for <lists+kvm@lfdr.de>; Mon, 13 Apr 2020 11:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbgDMJNx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Apr 2020 05:13:53 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58259 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727791AbgDMJNw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Apr 2020 05:13:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586769230;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ushgHlBusXZ5xLnyH3insFe724nmN2oRiWHOqt2DcZI=;
        b=KY56YPuYQn+otfiKZ5HFdOg3VLEzAKmOdb72GEne6LBguiYDscUMmaBc0N6Bk7TK8nHdxO
        LFKLJ7RvFuZ7FNLofQ0FTmoH4ERYYi9cDSqG4L6hnFvbbNlcXdkB3PAIILghWtZT3/yn9T
        9VgLG0rA7nv10ILq8v41B3OEg4gr3Aw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-302-2leSb2I7OZOeO3BrV5dywA-1; Mon, 13 Apr 2020 05:13:48 -0400
X-MC-Unique: 2leSb2I7OZOeO3BrV5dywA-1
Received: by mail-wm1-f69.google.com with SMTP id f8so2475728wmh.4
        for <kvm@vger.kernel.org>; Mon, 13 Apr 2020 02:13:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ushgHlBusXZ5xLnyH3insFe724nmN2oRiWHOqt2DcZI=;
        b=SlIKrwnwog+m1sIMyw5OVnGk7K8UajrKRHm+jv0t1Qwa3I63WVhkYNupBDmE8/8ZJf
         Yq0TN0BaRIaaZMHzoVZCHr2yMLQ4/h6sS4LLSouxSFvz3frg/Aaq/bIri4LZIh4w43yr
         GTk6fzyyasZnVDKf6zve0nw/7Tg8pfXPqzO246UxoYCwqPsyMDzT8Axl8idHdNYHFrG+
         STJIkfQz2Zf8NYFRL6SGAuv6H1RdLmJ2WWCpcTgM7vzBAfF92Ef4OzJveVi0Juydr/wN
         kSfFye27d45DzEooysS9Twh4Ar5QCuYudG83rq8eOHX6pFIm9rT/aoOBNqIcYdFJ99Sn
         Vpmw==
X-Gm-Message-State: AGi0PuZfMVvMnMCZu60dcnPiJZZiJDcGxrRuGtSth5JvIQzee4vxxzZK
        VcEYlGhe7eVUhHjKBC/a29uDDN//APkk7BPXzXjh2o4HziELX/W3OoZbmTwTsE5GflEmzBToks1
        TyOsahD7wUPhP
X-Received: by 2002:a7b:c959:: with SMTP id i25mr17437767wml.20.1586769226825;
        Mon, 13 Apr 2020 02:13:46 -0700 (PDT)
X-Google-Smtp-Source: APiQypIffcw9nxIKvrpcNgjxV7Ji1hEM66g5Yl/JVJewO14MkPUY3DVlBtE0CycNOSBmc3hIcKgFpw==
X-Received: by 2002:a7b:c959:: with SMTP id i25mr17437745wml.20.1586769226632;
        Mon, 13 Apr 2020 02:13:46 -0700 (PDT)
Received: from [192.168.8.101] ([194.230.155.239])
        by smtp.gmail.com with ESMTPSA id f23sm2536891wml.4.2020.04.13.02.13.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Apr 2020 02:13:46 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86: move kvm_create_vcpu_debugfs after last failure
 point
To:     Paolo Bonzini <pbonzini@redhat.com>
References: <20200331224222.393439-1-pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
Message-ID: <c66a8be9-c27c-9824-f287-f87e0d4edc35@redhat.com>
Date:   Mon, 13 Apr 2020 11:13:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200331224222.393439-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 01/04/2020 00:42, Paolo Bonzini wrote:
> The placement of kvm_create_vcpu_debugfs is more or less irrelevant, since
> it cannot fail and userspace should not care about the debugfs entries until
> it knows the vcpu has been created.  Moving it after the last failure
> point removes the need to remove the directory when unwinding the creation.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>

> ---
>   virt/kvm/kvm_main.c | 4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 027259af883e..0a78e1d874ed 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2823,8 +2823,6 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
>   	if (r)
>   		goto vcpu_free_run_page;
>   
> -	kvm_create_vcpu_debugfs(vcpu);
> -
>   	mutex_lock(&kvm->lock);
>   	if (kvm_get_vcpu_by_id(kvm, id)) {
>   		r = -EEXIST;
> @@ -2853,11 +2851,11 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
>   
>   	mutex_unlock(&kvm->lock);
>   	kvm_arch_vcpu_postcreate(vcpu);
> +	kvm_create_vcpu_debugfs(vcpu);
>   	return r;
>   
>   unlock_vcpu_destroy:
>   	mutex_unlock(&kvm->lock);
> -	debugfs_remove_recursive(vcpu->debugfs_dentry);
>   	kvm_arch_vcpu_destroy(vcpu);
>   vcpu_free_run_page:
>   	free_page((unsigned long)vcpu->run);
> 

