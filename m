Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAE9C30E9D3
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 03:02:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234520AbhBDCCa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 21:02:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234515AbhBDCC2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 21:02:28 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16976C0613ED
        for <kvm@vger.kernel.org>; Wed,  3 Feb 2021 18:01:48 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id j12so1075349pfj.12
        for <kvm@vger.kernel.org>; Wed, 03 Feb 2021 18:01:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=DtUPzvdSOR9fjDAlTd/uhz2q5QjDz0FBQNRxgqXFivo=;
        b=qqw4X6b0a4Fbc9brS/xTZMzHjRYlADZzcFubyadKSrWUFh+04aY85Ru9jt6bx5eWGx
         OTPUOKqNbPRqGQylm8aqmu8bSQKUZ0JPK/u8ZpGHvY2+Vx5z0ixQjBrJT9PLdOLZza6w
         TKjkPdlvfCq4a7/ERJnOMKMV95SGvUshi92xifEWiFh2YgFNvGQwzMXl/1+zxaHlLKDb
         IdLk0sgeTHV3dMbr01rf2CTdmCnwB1Uhc4Gr8QIj09+Wmf1RZezXRkbGfmiUXvOCMIfq
         B3ibvFCl+BPzMYw3+GM9nW6giT7tbRISRMm1UGet2/n5qgyrHcY60Z5HvhTahW6LRva2
         0eiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=DtUPzvdSOR9fjDAlTd/uhz2q5QjDz0FBQNRxgqXFivo=;
        b=pOublfd20SEmMSYoCRiQOMa6x7YjqQ3nkhUZ4sXdWTrcEUbvHVOgGLXoBqPzriLew3
         I74xK1tA85SR+0WZ+gy7SdN2XidnX99HVmfTNNKfijUqzyqhWXmveUR7WhngE68wdyBj
         wVYx+ETkW1yTF/E88dnBfzGSlxiWSKJnpncjJb5QRq0x8OgmNFhBFKbCdpMosvby9Cnh
         SJaFGzdb3XnNAQEhP1Uf8GRod0xwlL5aEL313J7nl0osLzjJCPOxaIASmE9Me8+doBDq
         Rabnph182PuzoDI1VqM4pTzFhc5kSg1B9I8jyqhLFkwMYxMAIBHiRaAekVWoNozlairh
         Xd6A==
X-Gm-Message-State: AOAM533fIHFISNLm0stKTQzDWZhZsD4yaro2AwUuuslQlBeyprIkTNTZ
        SP1HlRnhSZZXhXW1q6rcBoSSHw==
X-Google-Smtp-Source: ABdhPJyYWhJ/dbpr9l922PPdzUOxnxCHY8Yx62KtczzPdOuik54gXupFekv2+lQ3u3chZoPVvr+8Xw==
X-Received: by 2002:a65:6409:: with SMTP id a9mr6591303pgv.171.1612404107310;
        Wed, 03 Feb 2021 18:01:47 -0800 (PST)
Received: from google.com ([2620:15c:f:10:a9a0:e924:d161:b6cb])
        by smtp.gmail.com with ESMTPSA id p17sm358770pgn.38.2021.02.03.18.01.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 18:01:46 -0800 (PST)
Date:   Wed, 3 Feb 2021 18:01:39 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>
Subject: Re: [RFC PATCH v3 23/27] KVM: VMX: Add SGX ENCLS[ECREATE] handler to
 enforce CPUID restrictions
Message-ID: <YBtVg6VzU+Wn85ph@google.com>
References: <cover.1611634586.git.kai.huang@intel.com>
 <d68c01baed78f859ac5fce4519646fc8a356c77d.1611634586.git.kai.huang@intel.com>
 <c235e9ca6fae38ae3a6828218cb1a68f2a0c3912.camel@intel.com>
 <YBr7R0ns79HB74XD@google.com>
 <b8b57360a1b4c0fa4486cd4c3892c7138e972fff.camel@intel.com>
 <YBszcbHsIlo4I8WC@google.com>
 <d5dd889484f6b8c3786ffe75c1505beb944275b3.camel@intel.com>
 <YBs4zeRxudvNem44@google.com>
 <ef5186430822cf849fd65a660517730d7ecd60fd.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ef5186430822cf849fd65a660517730d7ecd60fd.camel@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 04, 2021, Kai Huang wrote:
> On Wed, 2021-02-03 at 15:59 -0800, Sean Christopherson wrote:
> > On Thu, Feb 04, 2021, Kai Huang wrote:
> > > On Wed, 2021-02-03 at 15:36 -0800, Sean Christopherson wrote:
> > > > On Thu, Feb 04, 2021, Kai Huang wrote:
> > > > > On Wed, 2021-02-03 at 11:36 -0800, Sean Christopherson wrote:
> > > > > > On Wed, Feb 03, 2021, Edgecombe, Rick P wrote:
> > > > > > > On Tue, 2021-01-26 at 22:31 +1300, Kai Huang wrote:
> > > > > > > Don't you need to deep copy the pageinfo.contents struct as well?
> > > > > > > Otherwise the guest could change these after they were checked.
> > > > > > > 
> > > > > > > But it seems it is checked by the HW and something is caught that would
> > > > > > > inject a GP anyway? Can you elaborate on the importance of these
> > > > > > > checks?
> > > > > > 
> > > > > > Argh, yes.  These checks are to allow migration between systems with different
> > > > > > SGX capabilities, and more importantly to prevent userspace from doing an end
> > > > > > around on the restricted access to PROVISIONKEY.
> > > > > > 
> > > > > > IIRC, earlier versions did do a deep copy, but then I got clever.  Anyways, yeah,
> > > > > > sadly the entire pageinfo.contents page will need to be copied.
> > > > > 
> > > > > I don't fully understand the problem. Are you worried about contents being updated by
> > > > > other vcpus during the trap? 
> > > > > 
> > > > > And I don't see how copy can avoid this problem. Even you do copy, the content can
> > > > > still be modified afterwards, correct? So what's the point of copying?
> > > > 
> > > > The goal isn't correctness, it's to prevent a TOCTOU bug.  E.g. the guest could
> > > > do ECREATE w/ SECS.SGX_ATTR_PROVISIONKEY=0, and simultaneously set
> > > > SGX_ATTR_PROVISIONKEY to bypass the above check.
> > > 
> > > Oh ok. Agreed.
> > > 
> > > However, such attack would require precise timing. Not sure whether it is feasible in
> > > practice.
> > 
> > It's very feasible.  XOR the bit in a tight loop, build the enclave on a
> > separate thread.  Do that until EINIT succeeds.  Compared to other timing
> > attacks, I doubt it'd take all that long to get a successful result.
> 
> How does it work? The setting PROVISION bit needs to be set after KVM checks SECS's
> attribute, and before KVM actually does ECREATE, right?

Yep.  More precisely, toggled between KVM's read into its local copy and final
execution of ECREATE.  It's actually a huge window when you consider how many
uops ENCLS has to churn through before it reads 'contents'.  The success rate
would probaby be 25%: 50% chance KVM's read sees the 'good' value, 50% chance
the CPU sees the 'bad' value in the same exit.
