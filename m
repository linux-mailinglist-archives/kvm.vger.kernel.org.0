Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 791F577FC5A
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 18:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351737AbjHQQxv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 12:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351992AbjHQQxb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 12:53:31 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1680B1FF3
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 09:53:30 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d71f505d21dso71906276.3
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 09:53:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692291209; x=1692896009;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=I7rXeOmhjPgxKDblBxPwExmctn5hjyWOkPZnPOO6tEA=;
        b=QCg2g5rmwWj+zLcHzdHJ1+EJZ/K1e3el0bmzR4K6W+/DqLyCnaEB2jXi4RVnUxQ7HA
         zNntzNGgwdhZjtyukJHm343Kpt+depwFg3XKmq0qQTaH8fG6GomRgbFX7T3OaQ3kiejv
         4cew6icSeaNsJFajQi2bq7r85j6lcf+8hvHK6vE3Hb82p6Zmf9kdx20OXvzC15Fw1r4t
         bZ4fZdpX8HJ/64uTMFZCCYNw9oliMO+ovSVkPZDFo0wr3ZDbhRXieruuCaXcrMBLr55E
         nqLc5YdgtvdoEvgz1FmuZQ36lahtcY0IiPDW2fRzLMJlOYKnkDtew0uJkPfCWNV+SxF5
         Q7fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692291209; x=1692896009;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I7rXeOmhjPgxKDblBxPwExmctn5hjyWOkPZnPOO6tEA=;
        b=VtcQkO9cwGIelfm22kTmdW/hyXyGQUJe5vxt6vxQKZp9EJEVCXcoeE2Zk1HkCrVwFy
         08NZT7hdLUVtBXlyMXgow9WxUvfavfr6JhJi7lqD/QbKvEbcMe/jL2K23KGlxhLfCFme
         nwUjM/SqV58Sc/KNdbUXoNOuQeHTT5K9UJ0qhA1YuUQCAZN2Lr3BfrFhvw4thifBcFD4
         pk4IIH7ZXtEGQtu3uVE9eJyisleiaTrvhflo/SaZEA0evde/ooPNPV2dAbUzY6TH4xyl
         CMiQP7/arMT8n+9SRezrxhfqEuBst2uPeJpijqzBLF8z0wI7hHMXMV1nm+nOCptMm/AZ
         9/Ww==
X-Gm-Message-State: AOJu0YwpXa7vnZ3GgGq3VURQsL2hhVrbCiUuG82Szg8QwSRhgH6QSLWA
        yXDhlzPExyUMcowZcf+tDV25YsMpxRa3jmHdtg==
X-Google-Smtp-Source: AGHT+IEBX+yMZkeBzDlPXRL1+LjipK2s6Ler1D8A2V7HQdX1BXDLPWihauoUm2Na2jqlBWq8P0DlEOIoOk9EtRDR3w==
X-Received: from ackerleytng-ctop.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:13f8])
 (user=ackerleytng job=sendgmr) by 2002:a25:bed0:0:b0:d4d:5407:3710 with SMTP
 id k16-20020a25bed0000000b00d4d54073710mr963ybm.4.1692291209254; Thu, 17 Aug
 2023 09:53:29 -0700 (PDT)
Date:   Thu, 17 Aug 2023 16:53:27 +0000
In-Reply-To: <d6858d5c-7db6-6e4c-7f07-92ff3340e02b@redhat.com> (message from
 Paolo Bonzini on Thu, 10 Aug 2023 16:03:16 +0200)
Mime-Version: 1.0
Message-ID: <diqz5y5dvce0.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [RFC PATCH 08/11] KVM: x86: Let moving encryption context be configurable
From:   Ackerley Tng <ackerleytng@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     seanjc@google.com, tglx@linutronix.de, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, shuah@kernel.org,
        andrew.jones@linux.dev, ricarkol@google.com,
        chao.p.peng@linux.intel.com, tabba@google.com, jarkko@kernel.org,
        yu.c.zhang@linux.intel.com, vannapurve@google.com,
        erdemaktas@google.com, mail@maciej.szmigiero.name, vbabka@suse.cz,
        david@redhat.com, qperret@google.com, michael.roth@amd.com,
        wei.w.wang@intel.com, liam.merwick@oracle.com,
        isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 8/8/23 01:01, Ackerley Tng wrote:
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 75d48379d94d..a1a28dd77b94 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -6351,7 +6351,14 @@ static int kvm_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
>>   	if (r)
>>   		goto out_mark_migration_done;
>>   
>> -	r = static_call(kvm_x86_vm_move_enc_context_from)(kvm, source_kvm);
>> +	/*
>> +	 * Different types of VMs will allow userspace to define if moving
>> +	 * encryption context should be supported.
>> +	 */
>> +	if (kvm->arch.vm_move_enc_ctxt_supported &&
>> +	    kvm_x86_ops.vm_move_enc_context_from) {
>> +		r = static_call(kvm_x86_vm_move_enc_context_from)(kvm, source_kvm);
>> +	}
>
> Rather than "supported" this is more "required".  So  perhaps 
> kvm->arch.use_vm_enc_ctxt_op?
>
> Paolo

Thanks, that is a great suggestion, I'll incorporate this in the next
revision!
