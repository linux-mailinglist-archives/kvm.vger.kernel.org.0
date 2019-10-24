Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B749E3EFA
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 00:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730388AbfJXWSF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 18:18:05 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:40038 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730890AbfJXWSE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Oct 2019 18:18:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571955483;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=S5T3SACDgYsMyWdMvB+Axa39PeDk5Tdi7kLln/J1DFk=;
        b=G0AMSz4pdualQLp+IEr33XA5P9DkU21OeG+2eo6PzwHPiGObe4qp0d0w03u/xdVEx45OBP
        oBtWpcbGWh1onsaEmZqIgAMKmO2FPVPZnx0hGPfn+OGMMrpfADiWn7KS+Ap7ckYBfITNFz
        n3411e1VW9CYmR6d6fDcFl8xNloJN1o=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-316-NtSIC1OwOiSCL8d2CE41KQ-1; Thu, 24 Oct 2019 18:17:59 -0400
Received: by mail-wm1-f70.google.com with SMTP id x23so201301wmj.7
        for <kvm@vger.kernel.org>; Thu, 24 Oct 2019 15:17:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2IxEKDad2wxmQsINlVAKLFFPvON6bykz+bQBxVeDvH0=;
        b=CoqQzcVf0udknx8TmtnG/PzOnlw32uPdfujvq8RdbZ1JcteM4Kh/UWhEF6BCxinbek
         e1fWjrDwlaWnVgbDbpkLNvx2Z/J7cs5gmODDpUZhqbXgSKlao3qy6gSige4Ca1Vi34Dz
         fY053yLtA2WN7laci6+JTYVtwCjeFFnmOaqUM1udWetc7Ft+V+NxOCj6VyQQiDBvDQr4
         HlhBwrCK/WlwtGjKPX93LVVtKfjFYsTlOrM86pWqgXwvGGDQskXnhk8ysor9PIe/zNn4
         3MBDmD1sknhDL8sm+/vwlvwoHZhSLP/+kOT8+Dg/4td2pu0EI4JkSPVAIzLplh8JyZUu
         Fz8w==
X-Gm-Message-State: APjAAAXvyyVc2XF8oQfG++d2ko0f0IG39Wi9PDJgUPUgjGBCjbXymRug
        vdwCIaT0rJT/DZhS0yCEVHFFJWrzu9FWEE9JSD0AgbtPF7Ug52MIXJoLzchUX/QHerJtPAQoerz
        HMjFD2Vq3+UKk
X-Received: by 2002:a05:6000:34f:: with SMTP id e15mr6289764wre.232.1571955478510;
        Thu, 24 Oct 2019 15:17:58 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwr+LRRTX08P9gvDuFTHNA2fdDFaKy0n8M1+sziqYeVdoUEBgZ3dkWkj3/scHHQQRwEdeYwsQ==
X-Received: by 2002:a05:6000:34f:: with SMTP id e15mr6289749wre.232.1571955478261;
        Thu, 24 Oct 2019 15:17:58 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:6887:47f9:72a7:24e6? ([2001:b07:6468:f312:6887:47f9:72a7:24e6])
        by smtp.gmail.com with ESMTPSA id o4sm155314wre.91.2019.10.24.15.17.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2019 15:17:57 -0700 (PDT)
Subject: Re: [PATCH v2] kvm: x86: Add cr3 to struct kvm_debug_exit_arch
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Cc:     Ken Hofsass <hofsass@google.com>, Peter Shier <pshier@google.com>
References: <20191024195431.183667-1-jmattson@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <895ce968-7f70-000b-0510-c9040125f93a@redhat.com>
Date:   Fri, 25 Oct 2019 00:17:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191024195431.183667-1-jmattson@google.com>
Content-Language: en-US
X-MC-Unique: NtSIC1OwOiSCL8d2CE41KQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/10/19 21:54, Jim Mattson wrote:
> From: Ken Hofsass <hofsass@google.com>
>=20
> A userspace agent can use cr3 to quickly determine whether a
> KVM_EXIT_DEBUG is associated with a guest process of interest.
>=20
> KVM_CAP_DEBUG_EVENT_PDBR indicates support for the extension.
>=20
> Signed-off-by: Ken Hofsass <hofsass@google.com>
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Cc: Peter Shier <pshier@google.com>
> ---
> v1 -> v2: Changed KVM_CAP_DEBUG_EVENT_PG_BASE_ADDR to KVM_CAP_DEBUG_EVENT=
_PDBR
>           Set debug.arch.cr3 in kvm_vcpu_do_singlestep and
> =09                        kvm_vcpu_check_breakpoint
>           Added svm support

Perhaps you have already considered using KVM_CAP_SYNC_REGS instead,
since Google contributed it in the first place, but anyway...  would it
be enough for userspace to request KVM_SYNC_X86_SREGS when it enables
breakpoints or singlestep?

Thanks,

Paolo

