Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 731D97AB61A
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 18:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232215AbjIVQgG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 12:36:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbjIVQgE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 12:36:04 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A56EA122
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 09:35:58 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-59bdb9fe821so33129117b3.0
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 09:35:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695400558; x=1696005358; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Q0oE+/MaiDFgsp6iziho8X2Tgq3nTZtQM1PapiHujnw=;
        b=ZA4WLfBrxv/ARJ+poYYBkLIG5/ddO3BfpztDs7YRHfdXPg8wKb+NZkfdtepfWpJc+O
         54w0MPfn7qY0wRZKsIn9q9Uxiwptq904VDCJj0z3n/1aHFWwgT8wdlJoFzYq3BLhuA5n
         bMdgz3e7FuHTKdoN6EYIWfDiweJmo0Va7kq+H5o0nBwxfE42KhmbxKo6r2V0e96z4BaX
         cgHTZ7D/5XTQrOGhsJk1aHt7TsSXhxmaW6vNs5kCJ/9lccpAfpicyGlNWU0boTxS1v+T
         iJDhtBFHS9+e74oY3Eb5BY9hw9Lmk7dZxObw2gzxzYYBkbgSjNlH821Kk+6N/IozIGIh
         oMfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695400558; x=1696005358;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q0oE+/MaiDFgsp6iziho8X2Tgq3nTZtQM1PapiHujnw=;
        b=CMldb0b6IsdwToZwkKpYLp8yQisyhniJZgyuiYavR32lsAtn5XPuB57w/HJYVFZQo9
         0uCLf2WFwcMGgNcllx6oW9jDx92r/8uExzGrVjPqq2Q6yAwbwz88Gp/E5+LXDPuJCrP4
         6w6aN3iboTWQ29eiHolECc65qu6AthBxo+2wOOtXGhYF1g+qt0Qo9mZs3MgxWcIB6QVh
         Z0Vk5xZPFxOnpffF+WWoiD/QjXKaQDkuEXidh/uc1Ve491SDnl56id/Hx2g3pkOjjCww
         4xCN7NjoX5IhKSwILHbvJY/Q1Pvg2W5ej3/NQpAVNB/sfKgXL7CuBLbed9TI4ftqRFUS
         zu9Q==
X-Gm-Message-State: AOJu0Yz5XiwLNGBm5SaEDx4+ZAhYSAEyfuqdc0sDN8/h4fxIv/0zeYcj
        oaifjRXdwAorwJGGkKDa2wiSGyc9WzE=
X-Google-Smtp-Source: AGHT+IFLZDZ0yRx4G++/GeEF3wqTDfiWZKbL/SiNWKFZ+fbpe6OgP+5vRr+CDsxCgjuigYvaCRnJk470cKM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b148:0:b0:59b:f3a2:cd79 with SMTP id
 p69-20020a81b148000000b0059bf3a2cd79mr3289ywh.8.1695400557678; Fri, 22 Sep
 2023 09:35:57 -0700 (PDT)
Date:   Fri, 22 Sep 2023 09:35:55 -0700
In-Reply-To: <ZQ3AmLO2SYv3DszH@google.com>
Mime-Version: 1.0
References: <20230914015531.1419405-1-seanjc@google.com> <20230914015531.1419405-8-seanjc@google.com>
 <117db856-9aec-e91c-b1d4-db2b90ae563d@intel.com> <ZQ3AmLO2SYv3DszH@google.com>
Message-ID: <ZQ3CaxXY1uUETsI5@google.com>
Subject: Re: [RFC PATCH v12 07/33] KVM: Add KVM_EXIT_MEMORY_FAULT exit to
 report faults to userspace
From:   Sean Christopherson <seanjc@google.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Huacai Chen <chenhuacai@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Fuad Tabba <tabba@google.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Anish Moorthy <amoorthy@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Xu Yilun <yilun.xu@intel.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Vishal Annapurve <vannapurve@google.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Maciej Szmigiero <mail@maciej.szmigiero.name>,
        David Hildenbrand <david@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Wang <wei.w.wang@intel.com>,
        Liam Merwick <liam.merwick@oracle.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 22, 2023, Sean Christopherson wrote:
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 7c0e38752526..d13b646188e5 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4184,6 +4184,16 @@ static long kvm_vcpu_ioctl(struct file *filp,
>  				synchronize_rcu();
>  			put_pid(oldpid);
>  		}
> +
> +		/*
> +		 * Reset the exit reason if the previous userspace exit was due
> +		 * to a memory fault.  Not all -EFAULT exits are annotated, and
> +		 * so leaving exit_reason set to KVM_EXIT_MEMORY_FAULT could
> +		 * result in feeding userspace stale information.
> +		 */
> +		if (vcpu->run->exit_reason == KVM_EXIT_MEMORY_FAULT)
> +			vcpu->run->exit_reason = KVM_EXIT_UNKNOWN

Darn semicolons.  Doesn't look like I botched anything else though.

> +
>  		r = kvm_arch_vcpu_ioctl_run(vcpu);
>  		trace_kvm_userspace_exit(vcpu->run->exit_reason, r);
>  		break;
> 
> base-commit: 2358793cd9062b068ac25ac9c965c00d685eea92
> -- 
> 2.42.0.515.g380fc7ccd1-goog
> 

