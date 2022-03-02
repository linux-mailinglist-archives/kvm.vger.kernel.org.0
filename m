Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 710FA4CB048
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 21:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235068AbiCBUwa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 15:52:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234662AbiCBUw3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 15:52:29 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB0BF3E0FE
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 12:51:45 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id u2so1364437ioc.11
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 12:51:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Zz1k9oH8mFHiJIMEzJ1vo2mSkbzvRBePF7Ce4Qa2dJc=;
        b=a+HfOgTyq7RRojBM13qcb7TiYG0xVbmU3GzGur3FzPfb8ZNMXz0wjUKeaJ1WCkf5W8
         xhwl6ZGfNs1cnV5CGV2zzqn4m43l/yPDH/pTM/CdWTAHA78+Tptq87qtYMoeVDvcEpoB
         Ev9uPjJFVuqfsiIStIqW8xHS/Dh/uRkA39GICJRb6lnIb4Rgl9NT+InAUWz3uf08DtT+
         wup/Hs5kAzUsc8MzyF+u7o5hMwlSKdDo3T3E6choKO4Pj1kM+WJU6j31ioeijGwmwIRl
         Yl+XaRmwXnTFX5dsLHQij7I7ouu3rKY5LkXSiE25f2AlmUd4x3D6l9rvnh4tPCm/IuQT
         tXkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Zz1k9oH8mFHiJIMEzJ1vo2mSkbzvRBePF7Ce4Qa2dJc=;
        b=NPn/bqhx4cllkLTaceA8nDJDFWwavY/IgomWtbWV5tAS4vHI7aaOzt4yCQupbWRFu5
         AtHeeIH+G/S1NADsKyF5pCSmcfOE3+VCOjsHZMv8V9k1i9IQgHNGeQ/h2crDe6Eypn8x
         7z1lRVcGGi4/E+pduvKVSSXMEGy/pOD/UBZOnuIy9lKLshTrtWn45MjV+ykGw+9lGSzH
         iK4Y7k1YcsI5b7mC2txhprF3sgT2PpU9VCyPF6Pvd3iCgtKQmJWWtflgyQGI5lHleIun
         5ckuGFc2jtYAh8oakqcA4UHGeOaHI9sP+n+J5If0cImTshIQaN7UthNyE/cacKQM7IFj
         weog==
X-Gm-Message-State: AOAM530mIAPoSnIrwBWEi73UN3R3q3wPBtWX+D3mNUl6kJJn8yzO3xNN
        l/bNTXpypCYCkBA4OQLp/5iXHw==
X-Google-Smtp-Source: ABdhPJxIwFyIV/FTJqIFStrggCBzE8hF7CY9rTE5A33f4hicVMk+EqT0sq132kEFwTIhzLF4ie7Mbg==
X-Received: by 2002:a5e:c648:0:b0:640:bc31:cbec with SMTP id s8-20020a5ec648000000b00640bc31cbecmr23969173ioo.79.1646254304882;
        Wed, 02 Mar 2022 12:51:44 -0800 (PST)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id f20-20020a056e0212b400b002c1a5b9d202sm61758ilr.32.2022.03.02.12.51.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 12:51:44 -0800 (PST)
Date:   Wed, 2 Mar 2022 20:51:40 +0000
From:   Oliver Upton <oupton@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Dunn <daviddunn@google.com>
Subject: Re: [PATCH v4 1/8] KVM: nVMX: Keep KVM updates to BNDCFGS ctrl bits
 across MSR write
Message-ID: <Yh/Y3E4NTfSa4I/g@google.com>
References: <20220301060351.442881-1-oupton@google.com>
 <20220301060351.442881-2-oupton@google.com>
 <4e678b4f-4093-fa67-2c4e-e25ec2ced6d5@redhat.com>
 <Yh5pYhDQbzWQOdIx@google.com>
 <b839fa78-c8ec-7996-dba7-685ea48ca33d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b839fa78-c8ec-7996-dba7-685ea48ca33d@redhat.com>
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 02, 2022 at 01:21:23PM +0100, Paolo Bonzini wrote:
> On 3/1/22 19:43, Oliver Upton wrote:
> > Right, a 1-setting of '{load,clear} IA32_BNDCFGS' should really be the
> > responsibility of userspace. My issue is that the commit message in
> > commit 5f76f6f5ff96 ("KVM: nVMX: Do not expose MPX VMX controls when
> > guest MPX disabled") suggests that userspace can expect these bits to be
> > configured based on guest CPUID. Furthermore, before commit aedbaf4f6afd
> > ("KVM: x86: Extract kvm_update_cpuid_runtime() from
> > kvm_update_cpuid()"), if userspace clears these bits, KVM will continue
> > to set them based on CPUID.
> > 
> > What is the userspace expectation here? If we are saying that changes to
> > IA32_VMX_TRUE_{ENTRY,EXIT}_CTLS after userspace writes these MSRs is a
> > bug, then I agree aedbaf4f6afd is in fact a bugfix. But, the commit
> > message in 5f76f6f5ff96 seems to indicate that userspace wants KVM to
> > configure these bits based on guest CPUID.
> 
> Yes, but I think it's reasonable that userspace wants to override them.  It
> has to do that after KVM_SET_CPUID2, but that's okay too.
> 

In that case, I can rework the tests at the end of this series to ensure
userspace's ability to override w/o a quirk. Sorry for the toil,
aedbaf4f6afd caused some breakage for us internally, but really is just
a userspace bug.

Is it possible to pick up patch 4/8 "KVM: x86: Introduce
KVM_CAP_DISABLE_QUIRKS2" independent of the rest of this series?

--
Thanks,
Oliver
