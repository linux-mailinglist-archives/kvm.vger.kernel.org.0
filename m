Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 001386E6CB0
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 21:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232795AbjDRTJ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 15:09:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232748AbjDRTJX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 15:09:23 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CB516A4E
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 12:09:07 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id c64-20020a254e43000000b00b92530ded91so5311489ybb.17
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 12:09:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681844946; x=1684436946;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iNinZ/xtW0ZVHNrwkVxIEbNSe13fqzLdKKr8yvRoE6Q=;
        b=5KSRwCuwMyrWMDBBcG/2qLwTpPHtKAMowKCiYtJuWD677A0UXbzGo0q/j1L9X2nkwT
         /hhHbfJnm7Hqc+akjWuhWRfRa9Di+SCcPtKhuNFFSh05wLVH16h4SPITGgjk/DNdCSav
         lDRw53gtqwSId6DXnuqEewZ1QZWZ/+ev5ui6QrZ5DX3dQiis0PHO2QaM9DoOAhSFWT2n
         97KqM+M6HutWEDT3mcSJj+RhKc+hH7HL76NKsWUUidq7mkr7yfKaWBWGKGRKm9w8lxeP
         cYc2zt9hH+9Iug0bGJn4nX08OFaWQREGVYhcO+nHeVZenJS4Tqxuz6zoajfhTyCE7bW2
         vwYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681844946; x=1684436946;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iNinZ/xtW0ZVHNrwkVxIEbNSe13fqzLdKKr8yvRoE6Q=;
        b=hMI1Vb0MPwAMRXECpDk0QKdiDrmpa0R6/N6+Ya0HbvHs3ZCw1V23KL+N953Zhzf/Qg
         o5bBADrXpziQYXCySpHCbgBnj7jXt18yhMYZLUH1c1jX4s7Jfs2ycMK40JRQKAT7k1Ts
         qwjnQy2Bj9OVXNYFX1UscQldJneJGEwhU8EXrjmZAfBaGsqzzqYurMY7p3Rq+8ob3CAF
         s8CYmmAhiC1im8vQX7LlvdGwgyGXspYY8QSTAVqyYHjZm+smnxf2UsFeR2W2u876eifb
         +sxR4wZ4eFwMqES7J7n3EAG20T/QXi9TmjteQUTaoAPYnrzL9PYbxz4DFlumxzOuSAP8
         RTUA==
X-Gm-Message-State: AAQBX9ek10f1X9JNRwhB9QtgdtUOOcZ7tSJsfogv3GPUHhyyq5GWcph8
        Muud7+EJRsJUxHXBVMsX6LMa+EoKae7aI5mD
X-Google-Smtp-Source: AKy350YWGJFweuXeHcx9cUcke+9jMuVzygNWAx4ledq3nz33xrIMBM/epux3EmdAsS26KjKWBxYShjH22qlzY9nD
X-Received: from vannapurve2.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:41f8])
 (user=vannapurve job=sendgmr) by 2002:a25:cf4c:0:b0:b8f:47c4:58ed with SMTP
 id f73-20020a25cf4c000000b00b8f47c458edmr12907520ybg.9.1681844946790; Tue, 18
 Apr 2023 12:09:06 -0700 (PDT)
Date:   Tue, 18 Apr 2023 19:09:04 +0000
In-Reply-To: <c49aa7b7bbc016b6c8b698ac2ce3b9d866b551f9.1678643052.git.isaku.yamahata@intel.com>
Mime-Version: 1.0
References: <c49aa7b7bbc016b6c8b698ac2ce3b9d866b551f9.1678643052.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230418190904.1111011-1-vannapurve@google.com>
Subject: Re: [PATCH v13 098/113] KVM: TDX: Handle TDX PV map_gpa hypercall
From:   Vishal Annapurve <vannapurve@google.com>
To:     isaku.yamahata@intel.com
Cc:     dmatlack@google.com, erdemaktas@google.com,
        isaku.yamahata@gmail.com, kai.huang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        sagis@google.com, seanjc@google.com, zhi.wang.linux@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> +static int tdx_map_gpa(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	gpa_t gpa = tdvmcall_a0_read(vcpu);
> +	gpa_t size = tdvmcall_a1_read(vcpu);
> +	gpa_t end = gpa + size;
> +
> +	if (!IS_ALIGNED(gpa, PAGE_SIZE) || !IS_ALIGNED(size, PAGE_SIZE) ||
> +	    end < gpa ||
> +	    end > kvm_gfn_shared_mask(kvm) << (PAGE_SHIFT + 1) ||
> +	    kvm_is_private_gpa(kvm, gpa) != kvm_is_private_gpa(kvm, end)) {
> +		tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_INVALID_OPERAND);
> +		return 1;
> +	}
> +
> +	return tdx_vp_vmcall_to_user(vcpu);

This will result into exits to userspace for MMIO regions as well. Does it make
sense to only exit to userspace for guest physical memory regions backed by
memslots?

> +}
> +
