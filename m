Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23E28730D4F
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 04:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242189AbjFOCl2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 22:41:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235116AbjFOCl0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 22:41:26 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF20E213B
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 19:41:24 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d2e1a72fcca58-666a25afc81so18650b3a.0
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 19:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686796884; x=1689388884;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=H0KWirj61OciDiKkuJb2kcKl5riA4zYenELsrCoOXwc=;
        b=g0x4Kk5QVrYK6g3XrklRcZ2chcFjE/ajQ+magWolwg5VZcTZdwXKxBIyHwi7EQsr72
         cWCzFXhpyM7eUudHMqc/JmeuNptP6gmufrlD/Eqf1Op677rlYm517hhuz9Grxm11ZvIz
         7cvG0dDawb5JGYrOWdVkZPH25y0daOLmtmd2cCPEtXBg7sPz+5+Hi7I0Nesn6VKcj/mK
         qHI4Lc13Um0e98ruYJOdmfSxQwIIVnusO8EsjQM5mTe1TRf2UoHhk+h4OiqRboEa1RlY
         8D1GitmfKqO64qhL8VDf5bM5YGiJpl1PikeNpOGJXXbVNn6Kb43CeBqZwm5FIX+VI2aY
         5wug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686796884; x=1689388884;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H0KWirj61OciDiKkuJb2kcKl5riA4zYenELsrCoOXwc=;
        b=SBtba858/z4QUplB29K4lVlIVM8tPV8AC7a2qLK9SMU5JzALxh1D4GXrAu98sBX3Mq
         9KFPNS2RDRZVG3+9D17tTCVdCiPLNn1Mo9nOj0BknObND5gFHe9bEy4KCmpiVyDkiYFW
         T37ej321GMH+yBTBrhTZgX4U3JviYgQnyj9wM/Bzjk41l8KRF10J8lys5hpJm458PT1m
         l0n3mNQE51TKqMXSWExR38m3P1ogWDIocV/ioCP2h/XWdSCgaUO7JkKBQOKTK5AL6Fnh
         k4sgeod6aHxvxOLj8KQjPfD1QQJjopH032JnwTTdT23LBSVs0Oo4CRGNhfSK6xlrvVmk
         6uDg==
X-Gm-Message-State: AC+VfDwj3A8L5fT0HYrbADR1fINHSFfway2RAdYGyrG2V1Ppb1E43ylV
        cAlIiPm8U07D3q5WmJgYLPo=
X-Google-Smtp-Source: ACHHUZ5bcWotQvDPkVXRNgOwhiD4egWOFQz0n0Qy54KMeekV8MW45E7iLjrggEVf+3fljnRbnXrp7A==
X-Received: by 2002:a05:6a00:1901:b0:666:7eb0:12d8 with SMTP id y1-20020a056a00190100b006667eb012d8mr2667177pfi.12.1686796884275;
        Wed, 14 Jun 2023 19:41:24 -0700 (PDT)
Received: from [172.27.232.119] (ec2-16-163-40-128.ap-east-1.compute.amazonaws.com. [16.163.40.128])
        by smtp.gmail.com with ESMTPSA id b24-20020aa78718000000b006666699be98sm1703746pfo.34.2023.06.14.19.41.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jun 2023 19:41:23 -0700 (PDT)
Message-ID: <d5ebb72d-393d-f61b-6a6f-760c6a5d7469@gmail.com>
Date:   Thu, 15 Jun 2023 10:41:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
From:   Robert Hoo <robert.hoo.linux@gmail.com>
Subject: Re: [PATCH v4 04/16] KVM: Add docstrings to __kvm_write_guest_page()
 and __kvm_read_guest_page()
To:     Anish Moorthy <amoorthy@google.com>, seanjc@google.com,
        oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, jthoughton@google.com,
        bgardon@google.com, dmatlack@google.com, ricarkol@google.com,
        axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com,
        isaku.yamahata@gmail.com
References: <20230602161921.208564-1-amoorthy@google.com>
 <20230602161921.208564-5-amoorthy@google.com>
Content-Language: en-US
In-Reply-To: <20230602161921.208564-5-amoorthy@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/3/2023 12:19 AM, Anish Moorthy wrote:
> The order of parameters in these function signature is a little strange,
> with "offset" actually applying to "gfn" rather than to "data". Add
> short comments to make things perfectly clear.
> 
> Signed-off-by: Anish Moorthy <amoorthy@google.com>
> ---
>   virt/kvm/kvm_main.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 09d4d85691e1..d9c0fa7c907f 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2984,6 +2984,9 @@ static int next_segment(unsigned long len, int offset)
>   		return len;
>   }
>   
> +/*
> + * Copy 'len' bytes from guest memory at '(gfn * PAGE_SIZE) + offset' to 'data'
> + */
>   static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t gfn,
>   				 void *data, int offset, int len)
>   {
> @@ -3085,6 +3088,9 @@ int kvm_vcpu_read_guest_atomic(struct kvm_vcpu *vcpu, gpa_t gpa,
>   }
>   EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_atomic);
>   
> +/*
> + * Copy 'len' bytes from 'data' into guest memory at '(gfn * PAGE_SIZE) + offset'
> + */
>   static int __kvm_write_guest_page(struct kvm *kvm,
>   				  struct kvm_memory_slot *memslot, gfn_t gfn,
>   			          const void *data, int offset, int len)

Agree, and how about one step further, i.e. adjust the param's sequence.

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2c276d4d0821..db2bc5d3e2c2 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2992,7 +2992,7 @@ static int next_segment(unsigned long len, int offset)
   */
  static int __kvm_read_guest_page(struct kvm_memory_slot *slot,
                                  struct kvm_vcpu *vcpu,
-                                gfn_t gfn, void *data, int offset, int len)
+                                gfn_t gfn, int offset, void *data, int len)
  {
         int r;
         unsigned long addr;
@@ -3015,7 +3015,7 @@ int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void 
*data, int offset,
  {
         struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);

-       return __kvm_read_guest_page(slot, NULL, gfn, data, offset, len);
+       return __kvm_read_guest_page(slot, NULL, gfn, offset, data, len);
  }
  EXPORT_SYMBOL_GPL(kvm_read_guest_page);

@@ -3024,7 +3024,7 @@ int kvm_vcpu_read_guest_page(struct kvm_vcpu *vcpu, gfn_t 
gfn, void *data,
  {
         struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);

-       return __kvm_read_guest_page(slot, vcpu, gfn, data, offset, len);
+       return __kvm_read_guest_page(slot, vcpu, gfn, offset, data, len);
  }
  EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_page);

@@ -3103,7 +3103,7 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_atomic);
   */
  static int __kvm_write_guest_page(struct kvm *kvm, struct kvm_vcpu *vcpu,
                                   struct kvm_memory_slot *memslot, gfn_t gfn,
-                                 const void *data, int offset, int len)
+                                 int offset, const void *data, int len)
  {
         int r;
         unsigned long addr;
@@ -3128,7 +3128,7 @@ int kvm_write_guest_page(struct kvm *kvm, gfn_t gfn,
  {
         struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);

-       return __kvm_write_guest_page(kvm, NULL, slot, gfn, data, offset, len);
+       return __kvm_write_guest_page(kvm, NULL, slot, gfn, offset, data, len);
  }
  EXPORT_SYMBOL_GPL(kvm_write_guest_page);

@@ -3136,8 +3136,8 @@ int kvm_vcpu_write_guest_page(struct kvm_vcpu *vcpu, gfn_t 
gfn,
                               const void *data, int offset, int len)
  {
         struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
-       return __kvm_write_guest_page(vcpu->kvm, vcpu, slot, gfn, data,
-                                     offset, len);
+       return __kvm_write_guest_page(vcpu->kvm, vcpu, slot, gfn, offset,
+                                     data, len);
  }
  EXPORT_SYMBOL_GPL(kvm_vcpu_write_guest_page);

