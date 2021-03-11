Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B520E3381F0
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 00:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbhCKXwm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Mar 2021 18:52:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231157AbhCKXwe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Mar 2021 18:52:34 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2EBFC061574;
        Thu, 11 Mar 2021 15:52:33 -0800 (PST)
Received: from zn.tnic (p200300ec2f0e1f00384fd57eec2a78d4.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:1f00:384f:d57e:ec2a:78d4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 44F9D1EC0253;
        Fri, 12 Mar 2021 00:52:31 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1615506751;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=ibyvykXU7vNizlMsrTK3SWaATQRAKIKcsQ59u3lJfYw=;
        b=O9i0wFxq+uXOrpl+TpyPHQEpNAslQC8Xc39WCHIVMaLpqi4YwJxE2a+JiX78dCsCIgQbYB
        N2iPC0+rd7GM5KBbMeYpYSPpOK4/Kca9oI2QmRDGY4YnYOJpt8KwTKl1KFjjM66uv3aOBM
        zbEtxZx2CvojMye+Zrfag1De0hE6hQ0=
Date:   Fri, 12 Mar 2021 00:52:15 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Babu Moger <babu.moger@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        kvm list <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Makarand Sonare <makarandsonare@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v6 00/12] SVM cleanup and INVPCID feature support
Message-ID: <20210311235215.GI5829@zn.tnic>
References: <3929a987-5d09-6a0c-5131-ff6ffe2ae425@amd.com>
 <7a7428f4-26b3-f704-d00b-16bcf399fd1b@amd.com>
 <78cc2dc7-a2ee-35ac-dd47-8f3f8b62f261@redhat.com>
 <d7c6211b-05d3-ec3f-111a-f69f09201681@amd.com>
 <20210311200755.GE5829@zn.tnic>
 <20210311203206.GF5829@zn.tnic>
 <2ca37e61-08db-3e47-f2b9-8a7de60757e6@amd.com>
 <20210311214013.GH5829@zn.tnic>
 <d3e9e091-0fc8-1e11-ab99-9c8be086f1dc@amd.com>
 <4a72f780-3797-229e-a938-6dc5b14bec8d@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4a72f780-3797-229e-a938-6dc5b14bec8d@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 11, 2021 at 04:15:37PM -0600, Babu Moger wrote:
> My host is
> # cat /etc/redhat-release
> Red Hat Enterprise Linux release 8.3 (Ootpa)
> # uname -r
> 5.12.0-rc2+

Please upload host and guest .config.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
