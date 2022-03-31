Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 332424ED0F7
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 02:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbiCaAmJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 20:42:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiCaAmH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 20:42:07 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA91433A8
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 17:40:18 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id i11so10702981plg.12
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 17:40:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vO4TlzgQDknteDeXgTuRAhnWN0Uyi8HLZ9Ej10tKjQw=;
        b=KqeTRTxhuYbLJJdm2H164P/2b4lfpSbC/SpEorn7Ek2i9yF7yfyRYbkYqJcGav2ye+
         fY0e9C5dRh2YmVrZfQrlXWQS/QlHTlNIDZCIrJI8SWx3sZ6/0b9pDOh2IvrRKJLySQXa
         b+gzAiTBrdj+7jp5xKxKAvuShqsAGBMyKajz/tJzxOufYOk0rAe05LWEMqPyaDnGwH/p
         PJp481cxcRUnNQXBYWSnr4R+7ggtYRDx88mefZqP2oqanDRU9QTPiq1/cIFqWb3mAI8T
         P5ELz4mduVlvHKINCkjuBjvHYmb1+3wEi6FGZ+TcikBheGL+SZlr8LIS+NJWe78iRDbo
         UJUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vO4TlzgQDknteDeXgTuRAhnWN0Uyi8HLZ9Ej10tKjQw=;
        b=oZClnY+aUsjzmWuJ1BbF8EbhdrHVLebLgttTX/4DHdDUpliz7gp6MR8w2ldm4E/aFZ
         0flpZMGW0mVg9tiH5x0/xUkZ0+C2pyufxtul//uOb2sHvhib6WdrHZfuERy+BafHImzv
         PaBVfMuJTrzTo9eCvMLR97UzOH33MHtE4vS2I07FaLkSldLJkseq3zkbFBzECCnleO0t
         s7LfvC9qn1JI9PRwaPCyJkvkVGvWLyU9X9tCwHdLkiBRCiszctpHfrrZhPYNggln+2VF
         l/TsdofDOFGLw6uktdAlX/t1A64Ts+vAaK7066T5mnwG2OspkCCatlqbDPpmrpfrFq+J
         3klQ==
X-Gm-Message-State: AOAM531ThYxqYqySHxtRolCEt4v/ndEE8Ml9PWeE7RMYoUaxiQvz3G25
        oVdomCSkgAZO2l/2jJExphALzQ==
X-Google-Smtp-Source: ABdhPJymB1xTf0WvWc26SHBnJyho9kjFNoVuVYzPqmw3cSEx4VfAE7bkWXTukQGwE9YryBIxoGOqXg==
X-Received: by 2002:a17:902:7615:b0:156:1859:2d00 with SMTP id k21-20020a170902761500b0015618592d00mr2546820pll.126.1648687218126;
        Wed, 30 Mar 2022 17:40:18 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j7-20020a056a00130700b004b9f7cd94a4sm24511007pfu.56.2022.03.30.17.40.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 17:40:17 -0700 (PDT)
Date:   Thu, 31 Mar 2022 00:40:14 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Shivam Kumar <shivam.kumar1@nutanix.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: Re: [PATCH v3 2/3] KVM: Documentation: Update kvm_run structure for
 dirty quota
Message-ID: <YkT4bvK+tbsVDAvt@google.com>
References: <20220306220849.215358-1-shivam.kumar1@nutanix.com>
 <20220306220849.215358-3-shivam.kumar1@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220306220849.215358-3-shivam.kumar1@nutanix.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Mar 06, 2022, Shivam Kumar wrote:
> Update the kvm_run structure with a brief description of dirty
> quota members and how dirty quota throttling works.

This should be squashed with patch 1.  I actually had to look ahead to this patch
because I forgot the details since I last reviewed this :-)

> Suggested-by: Shaju Abraham <shaju.abraham@nutanix.com>
> Suggested-by: Manish Mishra <manish.mishra@nutanix.com>
> Co-developed-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
> Signed-off-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
> Signed-off-by: Shivam Kumar <shivam.kumar1@nutanix.com>
> ---
>  Documentation/virt/kvm/api.rst | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 9f3172376ec3..50e001473b1f 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6125,6 +6125,23 @@ array field represents return values. The userspace should update the return
>  values of SBI call before resuming the VCPU. For more details on RISC-V SBI
>  spec refer, https://github.com/riscv/riscv-sbi-doc.
>  
> +::
> +
> +		/* KVM_EXIT_DIRTY_QUOTA_EXHAUSTED */
> +		struct {
> +			__u64 count;
> +			__u64 quota;
> +		} dirty_quota_exit;
> +If exit reason is KVM_EXIT_DIRTY_QUOTA_EXHAUSTED, it indicates that the VCPU has
> +exhausted its dirty quota. The 'dirty_quota_exit' member of kvm_run structure
> +makes the following information available to the userspace:
> +	'count' field: the current count of pages dirtied by the VCPU,
> +	'quota' field: the observed dirty quota just before the exit to userspace.
> +The userspace can design a strategy to allocate the overall scope of dirtying
> +for the VM among the vcpus. Based on the strategy and the current state of dirty
> +quota throttling, the userspace can make a decision to either update (increase)
> +the quota or to put the VCPU to sleep for some time.
> +
>  ::
>  
>  		/* Fix the size of the union. */
> @@ -6159,6 +6176,17 @@ values in kvm_run even if the corresponding bit in kvm_dirty_regs is not set.
>  
>  ::
>  
> +	/*
> +	 * Number of pages the vCPU is allowed to have dirtied over its entire
> +	 * lifetime.  KVM_RUN exits with KVM_EXIT_DIRTY_QUOTA_EXHAUSTED if the quota
> +	 * is reached/exceeded.
> +	 */
> +	__u64 dirty_quota;
> +Please note that this quota cannot be strictly enforced if PML is enabled, and
> +the VCPU may end up dirtying pages more than its quota. The difference however
> +is bounded by the PML buffer size.

If you want to be pedantic, I doubt KVM can strictly enforce the quota even if PML
is disabled.  E.g. I can all but guarantee that it's possible to dirty multiple
pages during a single exit.  Probably also worth spelling out PML and genericizing
things.  Maybe

  Please note that enforcing the quota is best effort, as the guest may dirty
  multiple pages before KVM can recheck the quota.  However, unless KVM is using
  a hardware-based dirty ring buffer, e.g. Intel's Page Modification Logging,
  KVM will detect quota exhaustion within a handful of dirtied page.  If a
  hardware ring buffer is used, the overrun is bounded by the size of the buffer
  (512 entries for PML).
