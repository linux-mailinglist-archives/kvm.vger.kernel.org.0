Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3A5B175687
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 10:02:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727323AbgCBJB7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 04:01:59 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:20422 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726887AbgCBJB6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Mar 2020 04:01:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583139717;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+cKCStZlaFnACnF/GtwjtjakSchn0Oxyd9JsHfbu4KE=;
        b=U/RIHTHig8TV28Wf4XusLYqjL+taYlIwFQZOiOC1BLXrHm/u8V8yfvPB5rgWDButAQvo/7
        IqhN87tZWq3VifN+LYZ/L0XcCpq2tHZXIgG/iJ0JZywfo0CE1bQgWsbL2dDlqmeKNGsp3o
        pbzpxt7LAXuQhw3Wh++hTfGNRFQ1lBU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-278-_p1OvF1SOZaD_ZqhYdeViA-1; Mon, 02 Mar 2020 04:01:55 -0500
X-MC-Unique: _p1OvF1SOZaD_ZqhYdeViA-1
Received: by mail-wm1-f69.google.com with SMTP id d129so2646037wmd.2
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2020 01:01:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=+cKCStZlaFnACnF/GtwjtjakSchn0Oxyd9JsHfbu4KE=;
        b=m0uoiInDMBBVuKWDN5khYO7B/m9LqUXBUKBFrZoEr3phzZNtdvi/NKvkOTHpyIP6gy
         OmF3TxUDt9qXJr0h3OXm3K+X3F5Na+zDhjcAnxiN3y4EERXZVKXM+c1aoI76gcqekveP
         2mQVKKIdLEbR/KXvqdznWmP1mS/cFFV++pitIHZD80Oy0SQlo4DT8o0ZrRYMAuWqMqXj
         wOoU7xeN75aBPlIZW3ui40KtrPzdNFKCNDeDCNF5owiM473ejGLjaQHBh7icqLE5zy5F
         e8uDkEI5isTDASBLxG1xQS3UW27YYs/srEnJN70mMHngV3fB7rB8IkBJEbNAZgY9i9m/
         GSbA==
X-Gm-Message-State: ANhLgQ03OXgkRYkqgZowIqH+doD8nE0b9n/A69VPoO2oy+/3xSnX5LH2
        n6Oi+KXloehq+VQgkWdzU4ZKUwQ+KDAoQ21MsjooaGMfMx7/OIiLQXK8MZMGuIIvRBNimb8PUvK
        16U6LJSq26j5F
X-Received: by 2002:a5d:538e:: with SMTP id d14mr10266205wrv.62.1583139714030;
        Mon, 02 Mar 2020 01:01:54 -0800 (PST)
X-Google-Smtp-Source: ADFU+vugaTJBFeQrMq8aQNmO8wrOwb5Q1L0SrJJuYOv3anP+L+JfncyGZAAgaay46uJHvS+mTnXzHQ==
X-Received: by 2002:a5d:538e:: with SMTP id d14mr10266175wrv.62.1583139713721;
        Mon, 02 Mar 2020 01:01:53 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id a7sm13794928wmj.12.2020.03.02.01.01.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2020 01:01:52 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v2] KVM: x86: Remove unnecessary brackets in kvm_arch_dev_ioctl()
In-Reply-To: <20200229025212.156388-1-xiaoyao.li@intel.com>
References: <20200229025212.156388-1-xiaoyao.li@intel.com>
Date:   Mon, 02 Mar 2020 10:01:52 +0100
Message-ID: <875zfni0zj.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Xiaoyao Li <xiaoyao.li@intel.com> writes:

> In kvm_arch_dev_ioctl(), the brackets of case KVM_X86_GET_MCE_CAP_SUPPORTED
> accidently encapsulates case KVM_GET_MSR_FEATURE_INDEX_LIST and case
> KVM_GET_MSRS. It doesn't affect functionality but it's misleading.
>
> Remove unnecessary brackets and opportunistically add a "break" in the
> default path.
>
> Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  arch/x86/kvm/x86.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 5de200663f51..e49f3e735f77 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3464,7 +3464,7 @@ long kvm_arch_dev_ioctl(struct file *filp,
>  		r = 0;
>  		break;
>  	}
> -	case KVM_X86_GET_MCE_CAP_SUPPORTED: {
> +	case KVM_X86_GET_MCE_CAP_SUPPORTED:
>  		r = -EFAULT;
>  		if (copy_to_user(argp, &kvm_mce_cap_supported,
>  				 sizeof(kvm_mce_cap_supported)))
> @@ -3496,9 +3496,9 @@ long kvm_arch_dev_ioctl(struct file *filp,
>  	case KVM_GET_MSRS:
>  		r = msr_io(NULL, argp, do_get_msr_feature, 1);
>  		break;
> -	}
>  	default:
>  		r = -EINVAL;
> +		break;
>  	}
>  out:
>  	return r;

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

