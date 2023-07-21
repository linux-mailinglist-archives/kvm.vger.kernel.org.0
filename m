Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0AFA75D17A
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 20:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbjGUSns (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 14:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjGUSnr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 14:43:47 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E2E9E62;
        Fri, 21 Jul 2023 11:43:46 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1b9cdef8619so15444115ad.0;
        Fri, 21 Jul 2023 11:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689965026; x=1690569826;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4nnFaTg0IEjUdqid4XZGgfvzwMzdJISJ9KdbrEVQTkc=;
        b=gN5kqHrGUQ7n9A2IeKWEWJ79xju2TNQX6vnpuKuZ1IIfSnrVMexOaclUCgl5XYI9UC
         OWPJHMSRSLPOGuaQWwrdrDQpOz4lZbiGO4EDZEZFsRy2fKyNf1F4NSOoFAT9F++Z5YSb
         u7LZC4s4ZsvhlVum6sFEBuyYQhvICSQiXffsFPFg6/JGW8VM7U3sSg04VvRy6I/EO+3P
         t34xJxkkxkqevGIeHS3k27dcjQk6GOZUsQmCoPUquHRxofwbxHd+jJVs3J4Kw8dEU/Gt
         q3MgPq8O7i2YnhPyD/3i/vJhyisTQ/eGAqbmO+WEfT8YSL9kAWHbe56GP5DC6qpaA/FQ
         cVJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689965026; x=1690569826;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4nnFaTg0IEjUdqid4XZGgfvzwMzdJISJ9KdbrEVQTkc=;
        b=jKZnQhbR2domw4MFtO1zhrGjOGqXTlwOB7gMmDVnEtkGC0/9XdzEimCVdzrhXV+DoS
         Fk1XYQ7nNBFHUt7f/U6Q784hv6p96Sk3HKR3VX9dVstPX7I6/cWBQR67eznqw0ykWocg
         lWyS44jC0MQQdadUoF/8GbZvJeeB3nYulhkufvqyK5sDbjZeXsaFqrQx8LcwM9G/z1ke
         8+bTjMfDBrEcAiUank0VvXqUwuWV0wxnnllZ/yn+o0k8dtC8G+2aavKeGgYUVaqvLMny
         0iWuH7yCmD0oxSt3OXJnOpAY4on7XjtKreqKZBxQvXF3hhmKea5Fgt9PNEJSdsgeVIC4
         OF9A==
X-Gm-Message-State: ABy/qLYUcoMhxQcxCQ0a2wpC/vywaI7SrPbZ78Rfuz/PBxZiatjFW6s1
        fd7++RKBGwSeN/cTjeWHLX4=
X-Google-Smtp-Source: APBJJlHWZaBoDL8lz8FffqgAybCoIF1obzSq2tHKJzpNUhRlifDbg57zIVf8dPuxHagjKCnBWSip6w==
X-Received: by 2002:a17:902:7c85:b0:1b7:c166:f197 with SMTP id y5-20020a1709027c8500b001b7c166f197mr2272527pll.29.1689965025944;
        Fri, 21 Jul 2023 11:43:45 -0700 (PDT)
Received: from localhost ([192.55.54.50])
        by smtp.gmail.com with ESMTPSA id l1-20020a170903244100b001b3fb2f0296sm3848573pls.120.2023.07.21.11.43.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jul 2023 11:43:45 -0700 (PDT)
Date:   Fri, 21 Jul 2023 11:43:43 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Michael Roth <michael.roth@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Yuan Yao <yuan.yao@linux.intel.com>
Subject: Re: [RFC PATCH v4 09/10] KVM: x86: Make struct sev_cmd common for
 KVM_MEM_ENC_OP
Message-ID: <20230721184343.GI25699@ls.amr.corp.intel.com>
References: <cover.1689893403.git.isaku.yamahata@intel.com>
 <8c0b7babbdd777a33acd4f6b0f831ae838037806.1689893403.git.isaku.yamahata@intel.com>
 <ZLqbWFnm7jyB8JuY@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZLqbWFnm7jyB8JuY@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 21, 2023 at 07:51:04AM -0700,
Sean Christopherson <seanjc@google.com> wrote:

> On Thu, Jul 20, 2023, isaku.yamahata@intel.com wrote:
> > diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> > index aa7a56a47564..32883e520b00 100644
> > --- a/arch/x86/include/uapi/asm/kvm.h
> > +++ b/arch/x86/include/uapi/asm/kvm.h
> > @@ -562,6 +562,39 @@ struct kvm_pmu_event_filter {
> >  /* x86-specific KVM_EXIT_HYPERCALL flags. */
> >  #define KVM_EXIT_HYPERCALL_LONG_MODE	BIT(0)
> >  
> > +struct kvm_mem_enc_cmd {
> > +	/* sub-command id of KVM_MEM_ENC_OP. */
> > +	__u32 id;
> > +	/*
> > +	 * Auxiliary flags for sub-command.  If sub-command doesn't use it,
> > +	 * set zero.
> > +	 */
> > +	__u32 flags;
> > +	/*
> > +	 * Data for sub-command.  An immediate or a pointer to the actual
> > +	 * data in process virtual address.  If sub-command doesn't use it,
> > +	 * set zero.
> > +	 */
> > +	__u64 data;
> > +	/*
> > +	 * Supplemental error code in the case of error.
> > +	 * SEV error code from the PSP or TDX SEAMCALL status code.
> > +	 * The caller should set zero.
> > +	 */
> > +	union {
> > +		struct {
> > +			__u32 error;
> > +			/*
> > +			 * KVM_SEV_LAUNCH_START and KVM_SEV_RECEIVE_START
> > +			 * require extra data. Not included in struct
> > +			 * kvm_sev_launch_start or struct kvm_sev_receive_start.
> > +			 */
> > +			__u32 sev_fd;
> > +		};
> > +		__u64 error64;
> > +	};
> > +};
> 
> Eww.  Why not just use an entirely different struct for TDX?  I don't see what
> benefit this provides other than a warm fuzzy feeling that TDX and SEV share a
> struct.  Practically speaking, KVM will likely take on more work to forcefully
> smush the two together than if they're separate things.

Ok, let's drop this patch. Keep the ABI different for now.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
