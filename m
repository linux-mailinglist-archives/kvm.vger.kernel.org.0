Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5B12104FF6
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2019 11:04:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727106AbfKUKD5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Nov 2019 05:03:57 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:39674 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726614AbfKUKD5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Nov 2019 05:03:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574330635;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CYOAB7bV5ap3IHHQiJdevHwX5dASFlE1sJd2aJRoNcU=;
        b=BdHNzmOw6HHksJgH3m15kls5hG218gmhMXosH9dj82OqjRgY3TwlOaO8dT2qWLUDpy0PJa
        U9hWJLIIDfOPgMjD/lTESBlfM+3L31BoVEgUk3JJ1JutuQQah7+FRyCpv2gRtbVRL6MrQs
        mvip+6gCgp3cl/g+M9Q2l/UxWqJCvM8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-69-3gaGas13OJm8H_M7-bXUbA-1; Thu, 21 Nov 2019 05:03:54 -0500
Received: by mail-wr1-f70.google.com with SMTP id w4so1791480wro.10
        for <kvm@vger.kernel.org>; Thu, 21 Nov 2019 02:03:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gUJQbhj/e5tGevDSbtGQG/RunMX4COKzOc4f2GEZTdM=;
        b=HCAx6L4oDi+aOho3cBZ/kyxhFrmZScqrjSk15q0LNph9VS/ykp8MLFfnbTcjYiy7Cs
         L832gIgbwv/qj6z23rbesgVSv+bBq9GvyE4pJ8i14KKC0UlCsNMvNkNT7ANir3JF/bCl
         mc1gwS6C78sqC5CFXT9KX/1SFfi0UKSVXpaiEQbSDOy/LbtzJKzkuof33QxxTXDzNKd7
         dMusRNkzrNH2k+UKWsGG//5lyHHv/P2ZQgmJB3jAIVL8oaWg8uSPeobDKg3A1kjum6ZJ
         FZFLtnSwoEXdGKJAIButxID1ozuFuaRn3AKpLV0pBiaAAapVeUspq48gvQzxJ9BtH9MZ
         UlKQ==
X-Gm-Message-State: APjAAAWGDBbskJOj5hIhCw8feEZpu9gmtQUU3nQlP3pR4C3tTCBjkMx9
        FnN8Y+ZIT0J2M/gfxmMLwTrUkcNAXFwlkpzQAdWnGnpVOH96im5O4ph1yVx/+orlOXJxlSEeZxN
        o7gvUlG5E8z1n
X-Received: by 2002:a1c:6854:: with SMTP id d81mr9192486wmc.75.1574330633487;
        Thu, 21 Nov 2019 02:03:53 -0800 (PST)
X-Google-Smtp-Source: APXvYqxQZVVYwUMQnwyyspkBy0Yv+aj/pMZsjBnKogboxTJ33w5oRqIEJS2hl8TAWVFzYZQl+7zUJw==
X-Received: by 2002:a1c:6854:: with SMTP id d81mr9192459wmc.75.1574330633198;
        Thu, 21 Nov 2019 02:03:53 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:71a5:6e:f854:d744? ([2001:b07:6468:f312:71a5:6e:f854:d744])
        by smtp.gmail.com with ESMTPSA id b15sm2587300wrx.77.2019.11.21.02.03.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Nov 2019 02:03:52 -0800 (PST)
Subject: Re: [PATCH v7 5/9] x86: spp: Introduce user-space SPP IOCTLs
To:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jmattson@google.com,
        sean.j.christopherson@intel.com
Cc:     yu.c.zhang@linux.intel.com, alazar@bitdefender.com,
        edwin.zhai@intel.com
References: <20191119084949.15471-1-weijiang.yang@intel.com>
 <20191119084949.15471-6-weijiang.yang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f8cd7d7c-7ffd-3ee4-bf5f-203f9a030fef@redhat.com>
Date:   Thu, 21 Nov 2019 11:03:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191119084949.15471-6-weijiang.yang@intel.com>
Content-Language: en-US
X-MC-Unique: 3gaGas13OJm8H_M7-bXUbA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/11/19 09:49, Yang Weijiang wrote:
> +=09case KVM_INIT_SPP: {
> +=09=09r =3D kvm_vm_ioctl_init_spp(kvm);
> +=09=09break;
> +=09}
>  =09default:
>  =09=09r =3D -ENOTTY;
>  =09}
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 9460830de536..700f0825336d 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1257,6 +1257,9 @@ struct kvm_vfio_spapr_tce {
>  =09=09=09=09=09struct kvm_userspace_memory_region)
>  #define KVM_SET_TSS_ADDR          _IO(KVMIO,   0x47)
>  #define KVM_SET_IDENTITY_MAP_ADDR _IOW(KVMIO,  0x48, __u64)
> +#define KVM_SUBPAGES_GET_ACCESS   _IOR(KVMIO,  0x49, __u64)
> +#define KVM_SUBPAGES_SET_ACCESS   _IOW(KVMIO,  0x4a, __u64)
> +#define KVM_INIT_SPP              _IOW(KVMIO,  0x4b, __u64)

You also need to define a capability and return a value for it in
kvm_vm_ioctl_check_extension.  We could return SUBPAGE_MAX_BITMAP (now
KVM_SUBPAGE_MAX_PAGES).  And instead of introducing KVM_INIT_SPP, you
can then use KVM_ENABLE_CAP on the new capability.

Paolo

