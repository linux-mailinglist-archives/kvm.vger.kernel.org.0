Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 725B4586CAB
	for <lists+kvm@lfdr.de>; Mon,  1 Aug 2022 16:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232468AbiHAOPp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Aug 2022 10:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232388AbiHAOPn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Aug 2022 10:15:43 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73A11B4BD
        for <kvm@vger.kernel.org>; Mon,  1 Aug 2022 07:15:42 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id s5-20020a17090a13c500b001f4da9ffe5fso5304506pjf.5
        for <kvm@vger.kernel.org>; Mon, 01 Aug 2022 07:15:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=QuT4xFJ+H3I7bIvGWq2+zpolgZWgrD2J6nOy/da36hQ=;
        b=J7ljgbno6ufX7q9vaz65gRHInT23JXatr7SlSg0wjIY7+da5Wl0z2DnzNfO/LMrCU2
         OnOn+ftQQltgOPcWbDmbXaQEZvvrBmvAjRqsGguRPc/BXT2XrO6tTEIh8atVBYS6T1qQ
         u30q3SnBOEHWqGOoDTapiPbZgGp8KMc5IeoG6o+pc4YbpvufRhcFWcPVp21hl/p2nbT2
         n/EEKNfMzTBIHG/hAW3T3WkRJ/xJ8chiuxGYQVxPhHF7ZE1R541Fdbf7ve6MBj1OnJRZ
         n2qDeZ9DQESWdJJscL3fI+Lm5TrKAomBOrXrTOvrDVo4arqqCGeqi0S5NhHS/QXLaj14
         BnCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=QuT4xFJ+H3I7bIvGWq2+zpolgZWgrD2J6nOy/da36hQ=;
        b=edbk3fzFnCwe1/yfnr7OXA8YnNiGq77eqD8yRKz8FTOm126xUUIOlgcrhsSf0Nu6In
         PUznGIL9zRlVlRLM+Bfo4vTVw5A8y+ed0nsmMVKrUKDfDro1fDIM+rXAAAZ7rAHYbdZM
         2hKuSMEaSKF9lzzLflsuFADFJcgqnjSCXyE/gIV0uUuAb+32xZWNXrGyS3GWEySqwpWv
         a1H0gk5Ru9HIDnY6XoO1fcsaPRZnWLShgsONJGwKVzc9BAQ2FoiHNV5dpUah7Le42Tmd
         GU2sSWhnjs33aLNFl16NvXkDq0BRUlh1XDn/L8FEhLQdeflmDF0PEh9py7zqsw387UJN
         MwaA==
X-Gm-Message-State: ACgBeo0OOW8r9nebB7sImYy52zyu8lXsoPo9Khrueg2JoYnxxMjH2otL
        d8bSP/9UMxEUkYYefY21e1GXiw==
X-Google-Smtp-Source: AA6agR6GtXPwEy4J/MmFtBHlJsvIqQ+DC3eHBWMo5trq2cTHhnVFxVmRj39RS0cqKWnTAReTZ4C1/Q==
X-Received: by 2002:a17:90b:3d8:b0:1f4:d5c4:5d76 with SMTP id go24-20020a17090b03d800b001f4d5c45d76mr12665615pjb.219.1659363341834;
        Mon, 01 Aug 2022 07:15:41 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id n1-20020a17090a2bc100b001f2b0f8e047sm8946740pje.27.2022.08.01.07.15.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Aug 2022 07:15:41 -0700 (PDT)
Date:   Mon, 1 Aug 2022 14:15:37 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH 2/4] KVM: x86/mmu: Fully re-evaluate MMIO caching when
 SPTE masks change
Message-ID: <YufgCR9CpeoVWKF7@google.com>
References: <20220728221759.3492539-1-seanjc@google.com>
 <20220728221759.3492539-3-seanjc@google.com>
 <9104e22da628fef86a6e8a02d9d2e81814a9d598.camel@intel.com>
 <YuP3zGmpiALuXfW+@google.com>
 <f313c41ed50e187ae5de87b32325c6cd4cc17c79.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f313c41ed50e187ae5de87b32325c6cd4cc17c79.camel@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 01, 2022, Kai Huang wrote:
> On Fri, 2022-07-29 at 15:07 +0000, Sean Christopherson wrote:
> > Lastly, in prepration for TDX, enable_mmio_caching should be changed to key off
> > of the _mask_, not the value.  E.g. for TDX, the value will be '0', but the mask
> > should be SUPPRESS_VE | RWX.
> 
> Agreed.  But perhaps in another patch.  We need to re-define what does
> mask/value mean to enable_mmio_caching.

There's no need to redefine what they mean, the only change that needs to be made
is handle the scenario where desire value is '0'.  Maybe that's all you mean by
"redefine"?

Another thing to note is that only the value needs to be per-VM, the mask can be
KVM-wide, i.e. "mask = SUPPRESS_VE | RWX" will work for TDX and non-TDX VMs when
EPT is enabled.
