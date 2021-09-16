Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4794A40EA46
	for <lists+kvm@lfdr.de>; Thu, 16 Sep 2021 20:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245464AbhIPSz1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Sep 2021 14:55:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245451AbhIPSzW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Sep 2021 14:55:22 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 296B2C0A88C4;
        Thu, 16 Sep 2021 10:53:09 -0700 (PDT)
Received: from zn.tnic (p200300ec2f11c6001e49ea6afe1054f5.dip0.t-ipconnect.de [IPv6:2003:ec:2f11:c600:1e49:ea6a:fe10:54f5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 975A31EC0277;
        Thu, 16 Sep 2021 19:53:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1631814783;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=EEkuSQCOMaoXJOs3sjBNoQG569101MNKKDHKzzaH6BA=;
        b=gB9bssBwKtntsSk6SjyASK0fEoVxVOrTA+b7MYDuZ2k3mhJVVa90o3dHzqyz+RqjVwvJtG
        XyztbHk0mwKTHy3MdPB1mOJzitX4JtNoAHIiHlfIY9T4piwATl9/TQfhZVOlj86N2wHwlh
        iTcoSBJhW5WBSs1UjcH8NL/7xda00nE=
Date:   Thu, 16 Sep 2021 19:52:57 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <seanjc@google.com>
Cc:     David Edmondson <dme@dme.org>, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jim Mattson <jmattson@google.com>,
        David Edmondson <david.edmondson@oracle.com>
Subject: Re: [PATCH v5 1/4] KVM: x86: Clarify the kvm_run.emulation_failure
 structure layout
Message-ID: <YUOEeceHJFI6JJaJ@zn.tnic>
References: <20210916083239.2168281-1-david.edmondson@oracle.com>
 <20210916083239.2168281-2-david.edmondson@oracle.com>
 <YUNu2npJv2LPBRop@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YUNu2npJv2LPBRop@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 16, 2021 at 04:20:42PM +0000, Sean Christopherson wrote:
> On Thu, Sep 16, 2021, David Edmondson wrote:
> 
> For all these patches, assuming you want the Author credit to go to your @oracle.com
> email, they need an explicit
> 
>   From: David Edmondson <david.edmondson@oracle.com>
> 
> otherwise git will default to the "From" email header and make the Author
> "David Edmondson <dme@dme.org>".  And then checkpatch will rightly complain that
> the SOB does not match the Author.
> 
> Adding From: can be handled automatically by "git format-patch" via "--from", e.g.
> 
>   git format-patch --from="David Edmondson <dme@dme.org>" ...

Or you can put

[user]
        name = David Edmondson
        email = david.edmondson@oracle.com

in .git/config and then it'll use that as the author and you can send
from any random mail service using git send-email it'll slap the From:
correctly.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
