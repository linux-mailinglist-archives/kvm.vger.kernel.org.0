Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2E5761D73
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 17:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230423AbjGYPgP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 11:36:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbjGYPgN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 11:36:13 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34333BB
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 08:36:12 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-569e7aec37bso61763827b3.2
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 08:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690299371; x=1690904171;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zJL188spEdf8jlBHFLQkEZlti0TXRFH+U5cu91h9YR8=;
        b=SQwtCbchLJBC6JVt0au7UKzD6DauTBO7Ht/6fLayaAtmMn1ddu11cTpSkwaJcaV44a
         NWDLUE0AHkMJ4OT/Wo7KKa/YKEmgrg0sjWJQN5tC7BKxnoeKzmpoqnaHQej2Uu5AZKaU
         MvfCkMQ/9S4mtrQujLRuCkTF6VGlYXZv0SHwd9+lehD/ByMW+ku5ouyZWo63QG79Jti3
         dL/iU2UqJCVbtC1Tx31JmqLDfUvOX+276nwpWwK0qsvBNUuQKVklM8KpdqkZ/6XnBUk1
         1RvPq2UqE4epZmu8AYwV6Qsx5xkIVtSB41MiB+RgQ3vXNb1HvKO7/DjgvM5UJNPUqDWt
         qGtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690299371; x=1690904171;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zJL188spEdf8jlBHFLQkEZlti0TXRFH+U5cu91h9YR8=;
        b=SE23euV8hXTtm7epM2BScxcXSLfhd8P0x8WmL0JbLaoV9+COqCnPCIEKsTlsyZNjz6
         Vs6fTzpMZERp7J4leN+9zcuc7G6tMQCYQ7x4WRtre1oDQ7ebqEpTt3+PQG03SCMo71nc
         KPgHPxLYOHkIPfSQ3SXJpbt2j0xIgVb+b6KWcKjDKpzHRAgpfRut95eumGk6WTDtE4nD
         87egh0CB2uEv2ThNSIRuZ+qz926QwLSOnIGsO6AfYUXkUhiICUe7pFPm+4sim5Z6iN+q
         8tI7gg6gFxc5PucSwkK6il5LfoTP8pV8U4pICM7zli04VxqeVLKwc/d/2PiU3+f/MZi2
         vRAA==
X-Gm-Message-State: ABy/qLaCncEQvKRnGykHFXA8i7eby9v7E+rw0ewLGWW/xJBKaZlVO6Vw
        6p4DH6pJ7z5r/4YHbObd2SQlNa990XA=
X-Google-Smtp-Source: APBJJlFhPr4toDReLY5Gy5S9qrHXSfoNM086H5vUdRAYxVSKWKJsBx2ZDiNmzQUckTY/qbAOmAb98eQVxVA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:af21:0:b0:56c:e585:8b17 with SMTP id
 n33-20020a81af21000000b0056ce5858b17mr89738ywh.5.1690299371207; Tue, 25 Jul
 2023 08:36:11 -0700 (PDT)
Date:   Tue, 25 Jul 2023 08:36:09 -0700
In-Reply-To: <9e8a98ad-1f8d-a09c-3173-71c5c3ab5ed4@intel.com>
Mime-Version: 1.0
References: <cover.1689893403.git.isaku.yamahata@intel.com>
 <8c0b7babbdd777a33acd4f6b0f831ae838037806.1689893403.git.isaku.yamahata@intel.com>
 <ZLqbWFnm7jyB8JuY@google.com> <9e8a98ad-1f8d-a09c-3173-71c5c3ab5ed4@intel.com>
Message-ID: <ZL/r6Vca8WkFVaic@google.com>
Subject: Re: [RFC PATCH v4 09/10] KVM: x86: Make struct sev_cmd common for KVM_MEM_ENC_OP
From:   Sean Christopherson <seanjc@google.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
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
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 25, 2023, Xiaoyao Li wrote:
> On 7/21/2023 10:51 PM, Sean Christopherson wrote:
> > On Thu, Jul 20, 2023, isaku.yamahata@intel.com wrote:
> > > diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> > > index aa7a56a47564..32883e520b00 100644
> > > --- a/arch/x86/include/uapi/asm/kvm.h
> > > +++ b/arch/x86/include/uapi/asm/kvm.h
> > > @@ -562,6 +562,39 @@ struct kvm_pmu_event_filter {
> > >   /* x86-specific KVM_EXIT_HYPERCALL flags. */
> > >   #define KVM_EXIT_HYPERCALL_LONG_MODE	BIT(0)
> > > +struct kvm_mem_enc_cmd {
> > > +	/* sub-command id of KVM_MEM_ENC_OP. */
> > > +	__u32 id;
> > > +	/*
> > > +	 * Auxiliary flags for sub-command.  If sub-command doesn't use it,
> > > +	 * set zero.
> > > +	 */
> > > +	__u32 flags;
> > > +	/*
> > > +	 * Data for sub-command.  An immediate or a pointer to the actual
> > > +	 * data in process virtual address.  If sub-command doesn't use it,
> > > +	 * set zero.
> > > +	 */
> > > +	__u64 data;
> > > +	/*
> > > +	 * Supplemental error code in the case of error.
> > > +	 * SEV error code from the PSP or TDX SEAMCALL status code.
> > > +	 * The caller should set zero.
> > > +	 */
> > > +	union {
> > > +		struct {
> > > +			__u32 error;
> > > +			/*
> > > +			 * KVM_SEV_LAUNCH_START and KVM_SEV_RECEIVE_START
> > > +			 * require extra data. Not included in struct
> > > +			 * kvm_sev_launch_start or struct kvm_sev_receive_start.
> > > +			 */
> > > +			__u32 sev_fd;
> > > +		};
> > > +		__u64 error64;
> > > +	};
> > > +};
> > 
> > Eww.  Why not just use an entirely different struct for TDX?  I don't see what
> > benefit this provides other than a warm fuzzy feeling that TDX and SEV share a
> > struct.  Practically speaking, KVM will likely take on more work to forcefully
> > smush the two together than if they're separate things.
> 
> generalizing the struct of KVM_MEM_ENC_OP should be the first step.

It's not just the one structure though.  The "data" field is a pointer to yet
another layer of commands, and SEV has a rather big pile of those.  Making
kvm_mem_enc_cmd common is just putting lipstick on a pig since the vast majority
of the structures associated with the ioctl() would still be vendor specific.

  struct kvm_sev_launch_start
  struct kvm_sev_launch_update_data
  struct kvm_sev_launch_secret
  struct kvm_sev_launch_measure
  struct kvm_sev_guest_status
  struct kvm_sev_dbg
  struct kvm_sev_attestation_report
  struct kvm_sev_send_start
  struct kvm_sev_send_update_data
  struct kvm_sev_receive_start
  struct kvm_sev_receive_update_data

FWIW, I really dislike KVM's uAPI for KVM_MEM_ENC_OP.  The above structures are
all basically copied verbatim from PSP firmware structures, i.e. the commands and
their payloads are tightly coupled to "hardware" and essentially have no abstraction
whatsoever.   But that ship has already sailed, and practically speaking trying to
provide a layer of abstraction might not of worked very well anyways.

In other words, unless there's an obvious and easy way path to convergence, I
recommend you don't spend much time/effort on trying to share code with TDX.
