Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 891E0689530
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 11:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233337AbjBCKRp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 05:17:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233043AbjBCKRi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 05:17:38 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BBBF93AED;
        Fri,  3 Feb 2023 02:16:55 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id cq16-20020a17090af99000b0022c9791ac39so8340453pjb.4;
        Fri, 03 Feb 2023 02:16:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0ZbAUGn0r6doN6zThP1Zquzlxw14avp8efmj05+Io/4=;
        b=Ywh4mnPVN3Y4k0f4DuulkG2miIzAXD2MOag6AoE9aqI4lk2/oCohsrtf8Gr8EPviVM
         w5YHMEJEeyxv4Kxv5i6v3b/lUpqXFNx1osYHGwcvd5Y6A4ASt/XYopzNc7ULMCnsOI6d
         IrSWoKHqFH3ZA9JFOpulvON/sgxK8lIDCGcFdofh7TQct/4Basch9lONK7Jz9jH6b2l5
         lG9ZdPMIFHQYLtBy4nRdrdwKqfTKG98jS03kSpv/G7uTjB62apnvK8P8uUgwZxEBoWt6
         TcPvwy+n7no1gkpCj3JC/uJM6ahYRPgSN0IO8wEZNDBK6v4Lg/AjhsnsKmGHKgxXIauL
         JR8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0ZbAUGn0r6doN6zThP1Zquzlxw14avp8efmj05+Io/4=;
        b=UKRh5nSOnH5IZFXq5wKE4wJRxfxAhR9KvbcrJtOvIzAuTzb0UkpeLv9R4gDWEgr57d
         EYg7GHHxE/mFoW4/mtnxyRZ3dHCsUxHeAPUIPwIwFGAGSR24MFC+oyvmHLjywQeUQQZw
         nlu3cWw7vtorl5QXg3p/dNmTxYxYvciuqfiK41LdEkWDx4/gRW9f/JUMG3c4zyt2/Gfn
         A/hp9zTCnfvI8AkPn7EOHn6OWcALSh1VHwX2eNv5IHzM0SYUu6PVYrbxlgcvI4+kqP3S
         IrrCkf1uGN3r438thPqCZQS+PP1Jqpzhh8cFZoFPPJLu+c/m9kW3P9S2fn/dU/8oOlgP
         WaWQ==
X-Gm-Message-State: AO0yUKX/Oj3wgb2+KLy925JB9ZJ2HSjgNI1StGrqq3hidGUDSlZr8BHk
        XxqafPT2d2uH74VGlRnIkYM=
X-Google-Smtp-Source: AK7set8WbQ1iPrN5HSlN4f706F1IqNht5RVf+MEFDgPYm7h/efSiL2BKY4uYWAK+N6jAmo/6Qh0viw==
X-Received: by 2002:a17:902:da92:b0:196:5839:b36a with SMTP id j18-20020a170902da9200b001965839b36amr11622683plx.8.1675419414829;
        Fri, 03 Feb 2023 02:16:54 -0800 (PST)
Received: from localhost (193-116-117-77.tpgi.com.au. [193.116.117.77])
        by smtp.gmail.com with ESMTPSA id n19-20020a170902969300b00198e03c3ad4sm1002403plp.278.2023.02.03.02.16.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 02:16:54 -0800 (PST)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 03 Feb 2023 20:16:45 +1000
Message-Id: <CQ8UM1FTPEUZ.3F2RONR3AJ5YP@bobo>
From:   "Nicholas Piggin" <npiggin@gmail.com>
To:     "Thomas Huth" <thuth@redhat.com>, <kvm@vger.kernel.org>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Sean Christopherson" <seanjc@google.com>
Cc:     "Claudio Imbrenda" <imbrenda@linux.ibm.com>,
        "Janosch Frank" <frankja@linux.ibm.com>,
        "Suzuki K Poulose" <suzuki.poulose@arm.com>,
        "Marc Zyngier" <maz@kernel.org>,
        "David Hildenbrand" <david@redhat.com>,
        <linux-kernel@vger.kernel.org>,
        "Oliver Upton" <oliver.upton@linux.dev>,
        "Zenghui Yu" <yuzenghui@huawei.com>,
        "James Morse" <james.morse@arm.com>,
        <kvm-riscv@lists.infradead.org>, <kvmarm@lists.linux.dev>,
        "Christian Borntraeger" <borntraeger@linux.ibm.com>,
        <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH 3/7] KVM: Move KVM_GET_NR_MMU_PAGES into the deprecation
 section
X-Mailer: aerc 0.13.0
References: <20230203094230.266952-1-thuth@redhat.com>
 <20230203094230.266952-4-thuth@redhat.com>
In-Reply-To: <20230203094230.266952-4-thuth@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri Feb 3, 2023 at 7:42 PM AEST, Thomas Huth wrote:
> The KVM_GET_NR_MMU_PAGES ioctl is quite questionable on 64-bit hosts
> since it fails to return the full 64 bits of the value that can be
> set with the corresponding KVM_SET_NR_MMU_PAGES call. This ioctl
> likely has also never really been used by userspace applications
> (at least not by QEMU and kvmtool which I checked), so it's better
> to move it to the deprecation section in kvm.h to make it clear for
> developers that this also should not be used in new code in the
> future anymore.

Did this get included in the series inadvertently?

Thanks,
Nick

>
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  include/uapi/linux/kvm.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 55155e262646..f55965a4cec7 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -83,6 +83,8 @@ struct kvm_debug_guest {
> =20
>  #define __KVM_DEPRECATED_VCPU_W_0x87 _IOW(KVMIO, 0x87, struct kvm_debug_=
guest)
> =20
> +#define KVM_GET_NR_MMU_PAGES _IO(KVMIO, 0x45)
> +
>  /* *** End of deprecated interfaces *** */
> =20
> =20
> @@ -1442,7 +1444,6 @@ struct kvm_vfio_spapr_tce {
>  #define KVM_CREATE_VCPU           _IO(KVMIO,   0x41)
>  #define KVM_GET_DIRTY_LOG         _IOW(KVMIO,  0x42, struct kvm_dirty_lo=
g)
>  #define KVM_SET_NR_MMU_PAGES      _IO(KVMIO,   0x44)
> -#define KVM_GET_NR_MMU_PAGES      _IO(KVMIO,   0x45)
>  #define KVM_SET_USER_MEMORY_REGION _IOW(KVMIO, 0x46, \
>  					struct kvm_userspace_memory_region)
>  #define KVM_SET_TSS_ADDR          _IO(KVMIO,   0x47)
> --=20
> 2.31.1

