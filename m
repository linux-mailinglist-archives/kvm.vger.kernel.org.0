Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4BA416AE91
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 19:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbgBXSVb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 13:21:31 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:34252 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726208AbgBXSVb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 13:21:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582568490;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=22uVNHaiuWfKHhhBJTGhF6H/dSMMZVH5DUi8EL/UkUc=;
        b=InkPsN90LF05O2JMeF5cJlV2PX75qBg0oIeLw/qlVQ8QPiMEs8KoAMfC2faE+uZvSYwp/O
        uRlqTqfAmVGkrvyphuvxunlO3dLQ0E7eRbcbTQ4ZZatQxtKpQKXTvc1eC8HanYbYc4nPli
        bmcLj6Ah4asCWhnwRIy7Kq6K7Qe/xZ8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-425-ohLfkrSNNHep5bDcl6Ap8g-1; Mon, 24 Feb 2020 13:21:28 -0500
X-MC-Unique: ohLfkrSNNHep5bDcl6Ap8g-1
Received: by mail-wm1-f72.google.com with SMTP id q125so61011wme.1
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2020 10:21:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=22uVNHaiuWfKHhhBJTGhF6H/dSMMZVH5DUi8EL/UkUc=;
        b=KHkXjF0q2vakVcc7RZbpML7aaTxwylqfYlDuLd7simTr05azF03hqWDc1gB4bkkBFa
         KMwLI9j3pnBKPp+hl9n3zJvOUrYZMJ9Mhc3thEy1HvIf1iBSCPtITuTbz57wPKnLyDf4
         YEuIrP8+4gbrXDgDZ4LC/WrQIRMtccVlvjRr+2//K6WLFBhfOZ4Gn/jxK0jNRLzQpztD
         cHmzmBA9vewBKxCrDva/XHFbNZJaz133QDO43h4eXc5cTkvb9brm725cHl7i2w5pt9B0
         VlgQccvsWMsWNyxdIzuuY+kJ5y6GesBRs0MwFDFF3EZfbdzEufetm9tqxVUTWkXGh2OC
         YdcA==
X-Gm-Message-State: APjAAAXAvbSHnFNJvFD0o14lvEx6nuOIB60QuihdGcK5EAhlZGmtEmdn
        NTo6srRxWxOjf608HRHpk/NDq3uHa53piQ8dafn796bK63WcM3VdRici5WstRPcPP2MjF1zxoJx
        G8tkvdrzVYyrg
X-Received: by 2002:a5d:4443:: with SMTP id x3mr8111013wrr.379.1582568487744;
        Mon, 24 Feb 2020 10:21:27 -0800 (PST)
X-Google-Smtp-Source: APXvYqxwUb4YPWt2bhIfMZjR+E3L/6ZIAGSXq4ZuCvQsFLbX+N/YQ4OUc3JnmFjkCIcuGWCrqk5bsQ==
X-Received: by 2002:a5d:4443:: with SMTP id x3mr8111004wrr.379.1582568487502;
        Mon, 24 Feb 2020 10:21:27 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:60c6:7e02:8eeb:a041? ([2001:b07:6468:f312:60c6:7e02:8eeb:a041])
        by smtp.gmail.com with ESMTPSA id h2sm19964314wrt.45.2020.02.24.10.21.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 10:21:27 -0800 (PST)
Subject: Re: [PATCH 1/1] KVM: s390: rstify new ioctls in api.rst
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>
References: <20200224101559.27405-1-borntraeger@de.ibm.com>
 <20200224101559.27405-2-borntraeger@de.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d17d7aa2-c472-1efb-79eb-fdbe3af0fccc@redhat.com>
Date:   Mon, 24 Feb 2020 19:21:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200224101559.27405-2-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/02/20 11:15, Christian Borntraeger wrote:
> We also need to rstify the new ioctls that we added in parallel to the
> rstification of the kvm docs.
> 
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  Documentation/virt/kvm/api.rst | 33 ++++++++++++++++++---------------
>  1 file changed, 18 insertions(+), 15 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 97a72a53fa4b..ebd383fba939 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -4611,35 +4611,38 @@ unpins the VPA pages and releases all the device pages that are used to
>  track the secure pages by hypervisor.
>  
>  4.122 KVM_S390_NORMAL_RESET
> +---------------------------
>  
> -Capability: KVM_CAP_S390_VCPU_RESETS
> -Architectures: s390
> -Type: vcpu ioctl
> -Parameters: none
> -Returns: 0
> +:Capability: KVM_CAP_S390_VCPU_RESETS
> +:Architectures: s390
> +:Type: vcpu ioctl
> +:Parameters: none
> +:Returns: 0
>  
>  This ioctl resets VCPU registers and control structures according to
>  the cpu reset definition in the POP (Principles Of Operation).
>  
>  4.123 KVM_S390_INITIAL_RESET
> +----------------------------
>  
> -Capability: none
> -Architectures: s390
> -Type: vcpu ioctl
> -Parameters: none
> -Returns: 0
> +:Capability: none
> +:Architectures: s390
> +:Type: vcpu ioctl
> +:Parameters: none
> +:Returns: 0
>  
>  This ioctl resets VCPU registers and control structures according to
>  the initial cpu reset definition in the POP. However, the cpu is not
>  put into ESA mode. This reset is a superset of the normal reset.
>  
>  4.124 KVM_S390_CLEAR_RESET
> +--------------------------
>  
> -Capability: KVM_CAP_S390_VCPU_RESETS
> -Architectures: s390
> -Type: vcpu ioctl
> -Parameters: none
> -Returns: 0
> +:Capability: KVM_CAP_S390_VCPU_RESETS
> +:Architectures: s390
> +:Type: vcpu ioctl
> +:Parameters: none
> +:Returns: 0
>  
>  This ioctl resets VCPU registers and control structures according to
>  the clear cpu reset definition in the POP. However, the cpu is not put
> 

Applied, thanks.

Paolo

