Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8E63616C8
	for <lists+kvm@lfdr.de>; Fri, 16 Apr 2021 02:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236434AbhDPA3m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 20:29:42 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:58246 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234716AbhDPA3l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Apr 2021 20:29:41 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1lXCLu-0002FG-QG; Fri, 16 Apr 2021 10:28:55 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 16 Apr 2021 10:28:54 +1000
Date:   Fri, 16 Apr 2021 10:28:54 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        John Allen <john.allen@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@suse.de>,
        Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: Re: [PATCH v2 0/8] ccp: KVM: SVM: Use stack for SEV command buffers
Message-ID: <20210416002854.GA28389@gondor.apana.org.au>
References: <20210406224952.4177376-1-seanjc@google.com>
 <3d4ae355-1fc9-4333-643f-f163d32fbe17@amd.com>
 <88eef561-6fd8-a495-0d60-ff688070cc9e@redhat.com>
 <967c3477-f680-2b49-0286-0d3418597d89@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <967c3477-f680-2b49-0286-0d3418597d89@amd.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 15, 2021 at 01:15:59PM -0500, Tom Lendacky wrote:
> On 4/15/21 11:09 AM, Paolo Bonzini wrote:
> > On 07/04/21 20:00, Tom Lendacky wrote:
> >> For the series:
> >>
> >> Acked-by: Tom Lendacky<thomas.lendacky@amd.com>
> > 
> > Shall I take this as a request (or permission, whatever :)) to merge it
> > through the KVM tree?
> 
> Adding Herbert. Here's a link to the series:
> 
> https://lore.kernel.org/kvm/88eef561-6fd8-a495-0d60-ff688070cc9e@redhat.com/T/#m2bbdd12452970d3bd7d0b1464c22bf2f0227a9f1
> 
> I'm not sure how you typically do the cross-tree stuff. Patch 8 has a
> requirement on patches 1-7. The arch/x86/kvm/svm/sev.c file tends to have
> more activity/changes than drivers/crypto/ccp/sev-dev.{c,h}, so it would
> make sense to take it through the KVM tree. But I think you need to verify
> that with Herbert.

I don't mind at all.  Paolo you can take this through your tree.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
