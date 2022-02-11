Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C26094B29A8
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 17:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350210AbiBKQGH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Feb 2022 11:06:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350104AbiBKQGG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Feb 2022 11:06:06 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7831721F;
        Fri, 11 Feb 2022 08:06:04 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id da4so17164383edb.4;
        Fri, 11 Feb 2022 08:06:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3Nvd1S4LyyfGcKGyWJQAtm0zoyG/g+vMhgrQ69JVjA8=;
        b=njXXlzotE3kdWn0eZuJWxBX9/ISQ28oiOEq8KWzpZXdAWMcrN6dktqQGGRmLFSYBEj
         3pA7Ew0SZXLdlfAWmj1CFmEbTHMVrbFHD+OveX5v1sZphHey/j8ylt17+eXV6phfTT06
         oNoGogx/rWmsNXhABo80DVMZxu909IC5kohBe/uhiqa+cbKEsc0s6LhL7mfqePwUSJSZ
         eHJBm/XPJ5DR+smLjh0G7b7dzJFAzBWxMwgzUPeIr9FgA9J8TQLoq0ThOaov6uDiKv8k
         zF4He85tn88tbGDjivGCG7f5Vq5Sb3K4DY2gy1fXToFdUUYVDH1sf8DEgvZk+9AiVbUD
         xlTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3Nvd1S4LyyfGcKGyWJQAtm0zoyG/g+vMhgrQ69JVjA8=;
        b=b/M3DJeX93zxXuQdxVi2hmKQbz6vQXjaWyeEVegfIWADi9Oa+nKszhk0lbk5e15I6+
         t8W6xJm+38FCzDwfpsabb4/MvHOiqIJLFhOtJ6F0m8bVG66tYI/Z2I1RH169jlVFL4eO
         cc64MpKEKcJX7nU7JLANsfyt4Xjph4oq0G3l9KZTH57OXUvc/Zd6ohG0hS84sfr0hC8s
         tZjfamw2yMhRG83IeDQi7wOVmAuN97qZa65NW6ht9ud37pICuqmfKidj8TPrrSpVke+v
         KaNk+2cjUiWLtyTzT4ccDmSM7tFw7DYCP3q+Gru8EFtirNXjA5k0aiMKP4gN4T8ZnE+f
         z/GA==
X-Gm-Message-State: AOAM532/Nsum5HkEli6hgUgjQ8fvLMuAoUlu6mdihX+hFOYrZrv/Ins9
        0CMRu0ql4bAtprzRBCXX2EU=
X-Google-Smtp-Source: ABdhPJyEDA1O7niJEvWoGb1/npjoAerKbkLOG7rwxIa/571ClMdTcO73hl7lyq5hDiyVfL4Y6YFL2w==
X-Received: by 2002:a05:6402:1e8b:: with SMTP id f11mr2755602edf.322.1644595562909;
        Fri, 11 Feb 2022 08:06:02 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id h16sm8097198ejj.56.2022.02.11.08.06.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Feb 2022 08:06:02 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <7ccb16e5-579e-b3d9-cedc-305152ef9b8f@redhat.com>
Date:   Fri, 11 Feb 2022 17:06:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC PATCH 4/6] KVM: X86: Introduce role.level_promoted
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20211210092508.7185-1-jiangshanlai@gmail.com>
 <20211210092508.7185-5-jiangshanlai@gmail.com> <YdTGuoh2vYPsRcu+@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YdTGuoh2vYPsRcu+@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/4/22 23:14, Sean Christopherson wrote:
> Alternatively, should we mark passthrough shadow pages as direct=1?  That would
> naturally handle this code, and for things like reexecute_instruction()'s usage
> of kvm_mmu_unprotect_page(), I don't think passthrough shadow pages should be
> considered indirect, e.g. zapping them won't help and the shadow page can't become
> unsync.

So the main difference between direct and passthrough shadow pages is that
passthrough pages can have indirect children.  A direct page maps the
page at sp->gfn, while a passthrough page maps the page _table_ at
sp->gfn.

Is this correct?

If so, I think there is a difference between a passthrough page that
maps a level-2 page from level-4, and a passthrough page that maps a
level-3 page from level-4.  This means that a single bit in the role
is not enough.

One way to handle this could be to have a single field "direct_levels"
that subsumes both "direct" and "passthrough".  direct && !passthrough
would correspond to "direct_levels == level", while !direct && !passthrough
would correspond to "direct_levels == 0".

Paolo
