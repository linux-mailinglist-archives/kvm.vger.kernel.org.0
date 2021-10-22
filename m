Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8E043728C
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 09:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232002AbhJVHQb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Oct 2021 03:16:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52905 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231773AbhJVHQa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 Oct 2021 03:16:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634886853;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oV5i5voiy3Imk+s4Dg9nNxLfsORlDwNjfDlexw2766M=;
        b=isyuHfty0cn8iW+3EP4lueg1zrJOLCzEaQBqJs/MA02rdYWKQ+LkgQLmvLjxClnWsIn6Kw
        lUgSLOsj4z3Vj8qFUwE2czOE/vry8HqCJUJK+pWiHvBQ7I2eJBOY2+fCORT5pn5WngNl18
        +nReyMc5x8OPjFBSKUsam2EVA1x2fgE=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-520-rifSQAIcOFGbNj-XITDY2A-1; Fri, 22 Oct 2021 03:14:11 -0400
X-MC-Unique: rifSQAIcOFGbNj-XITDY2A-1
Received: by mail-ed1-f69.google.com with SMTP id d3-20020a056402516300b003db863a248eso2770700ede.16
        for <kvm@vger.kernel.org>; Fri, 22 Oct 2021 00:14:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=oV5i5voiy3Imk+s4Dg9nNxLfsORlDwNjfDlexw2766M=;
        b=2+nEkyyz4Y8uIWl4nbpxZzbwrtcJsxXnXw4oTrvWL4QP9FnZE3BlDxJrtM+vy6F+GV
         8dHh/7QDzdjAd8lDjj4d/01Ipf8DKYtr7Jx0tr8VqqC/NeYVlTgS09Xp04LUAUmS3rQF
         UwY10GPF5Amjt1L7YNNeYsPANp7ngDaYFXsCMeotEUS6TsycqqWqUwwkk0gofKgxD8Rw
         nsZIONIaweGKw9Ff9g3r3oxOjuur6SVQXzf5OV/y8/HuDLA7XBqA/sSsUySlILaK40so
         3kN5MukVqXeQhks7oB1aq3lNWJ4NpkgJQveWDAjgRqdz0/W1ZqY4AAoOUn1/X43Uargl
         FpeA==
X-Gm-Message-State: AOAM532MFC8epUVgsfk2VacCSGDJhk7QL9HrqcInHUKVqt8WkZz1NOJS
        0/84EFwDIgA8GJrgjC3nPz/JgblF7mWC9s09qvXyNtIx0bNcCi9d23lUQQ/yqgS2Ief5YmjUaWB
        yuHQO21YTM5qy
X-Received: by 2002:aa7:c650:: with SMTP id z16mr14844631edr.54.1634886850470;
        Fri, 22 Oct 2021 00:14:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwqUZHn7yRUdny+ATjDDvgaeLq/ldSODVR22HdNwc2fe9x4BGa+STkcDGXCJnPCg5XJo8l5rw==
X-Received: by 2002:aa7:c650:: with SMTP id z16mr14844610edr.54.1634886850252;
        Fri, 22 Oct 2021 00:14:10 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id z18sm3396225ejl.67.2021.10.22.00.14.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Oct 2021 00:14:09 -0700 (PDT)
Message-ID: <419f25f5-41ef-1389-1103-3bbe4aa4ddd3@redhat.com>
Date:   Fri, 22 Oct 2021 09:14:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v3 7/8] nSVM: use vmcb_ctrl_area_cached instead of
 vmcb_control_area in struct svm_nested_state
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
References: <20211011143702.1786568-1-eesposit@redhat.com>
 <20211011143702.1786568-8-eesposit@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211011143702.1786568-8-eesposit@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/10/21 16:37, Emanuele Giuseppe Esposito wrote:
> ZE))
>   		return -EFAULT;
> -	if (copy_to_user(&user_vmcb->control, &svm->nested.ctl,
> +	nested_copy_vmcb_cache_to_control(&ctl_temp, &svm->nested.ctl);
> +	if (copy_to_user(&user_vmcb->control, &ctl_temp,
>   			 sizeof(user_vmcb->control)))
>   		return -EFAULT;

This needs a memset of ctl_temp so that kernel memory contents are not
leaked to userspace.  However, it's also better to avoid large structs
on the stack, and do a quick kzalloc/kfree instead:

-	nested_copy_vmcb_cache_to_control(&ctl_temp, &svm->nested.ctl);
-	if (copy_to_user(&user_vmcb->control, &ctl_temp,
-			 sizeof(user_vmcb->control)))
+
+	ctl = kzalloc(sizeof(*ctl), GFP_KERNEL);
+	if (!ctl)
+		return -ENOMEM;
+	nested_copy_vmcb_cache_to_control(ctl, &svm->nested.ctl);
+	r = copy_to_user(&user_vmcb->control, ctl,
+			 sizeof(user_vmcb->control));
+	kfree(ctl);
+	if (r)
  		return -EFAULT;

I can do this change when committing too.

Paolo

