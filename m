Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A374459EB9
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 09:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235113AbhKWI6U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 03:58:20 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:43532 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232328AbhKWI6S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Nov 2021 03:58:18 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id AB37E21709;
        Tue, 23 Nov 2021 08:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1637657708; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZLZuQ6koNaswA+CFy6l66aMDFMx1Xmt74WFtd9eJ/c0=;
        b=NZNB751fkQLisImTSn25U7tN26nqjh3/ICTqluWuMyK5oS5sqVIqIsjmwUAVw3NgKu78UV
        ELDic3N1var7dh+IvywCYg/Hm06/eN1ZCrjsXZxaaEV1ALPBn000An1xxVhWTyXdjqyDAI
        Nynx+GjM0dVOGH/yRwwTLspKGe1WQX0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1637657708;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZLZuQ6koNaswA+CFy6l66aMDFMx1Xmt74WFtd9eJ/c0=;
        b=GMq9ZhLzZfzykiNQfmW00d7KVJ9pBZnEpvpBjb//lcfh6djgw70wiuzCQPWeKA3ZYmUNIm
        wbTVDYxI/6fILgDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3C50613B58;
        Tue, 23 Nov 2021 08:55:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 8ZEGDmysnGEsBgAAMHmgww
        (envelope-from <vbabka@suse.cz>); Tue, 23 Nov 2021 08:55:08 +0000
Message-ID: <303c4bb7-ad0f-7686-d4e6-b0640823cbc9@suse.cz>
Date:   Tue, 23 Nov 2021 09:55:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH Part2 v5 00/45] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
Content-Language: en-US
To:     Dave Hansen <dave.hansen@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Peter Gonda <pgonda@google.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <CAMkAt6o0ySn1=iLYsH0LCnNARrUbfaS0cvtxB__y_d+Q6DUzfA@mail.gmail.com>
 <daf5066b-e89b-d377-ed8a-9338f1a04c0d@amd.com>
 <d673f082-9023-dafb-e42e-eab32a3ddd0c@intel.com>
 <f15597a0-e7e0-0a57-39fd-20715abddc7f@amd.com>
 <5f3b3aab-9ec2-c489-eefd-9136874762ee@intel.com>
 <d83e6668-bec4-8d1f-7f8a-085829146846@amd.com>
 <38282b0c-7eb5-6a91-df19-2f4cfa8549ce@intel.com>
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <38282b0c-7eb5-6a91-df19-2f4cfa8549ce@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/22/21 23:51, Dave Hansen wrote:
> On 11/22/21 12:33 PM, Brijesh Singh wrote:
>>> How do we, for example, prevent ptrace() from inducing a panic()?
>> 
>> In the current approach, this access will induce a panic(). 
> 
> That needs to get fixed before SEV-SNP is merged, IMNHO.  This behavior
> would effectively mean that any userspace given access to create SNP
> guests would panic the kernel.
> 
>> In general, supporting the ptrace() for the encrypted VM region is
>> going to be difficult.
> 
> By "supporting", do you mean doing something functional?  I don't really
> care if ptrace() to guest private memory returns -EINVAL or whatever.
> The most important thing is not crashing the host.
> 
> Also, as Sean mentioned, this isn't really about ptrace() itself.  It's
> really about ensuring that no kernel or devices accesses to guest
> private memory can induce bad behavior.

Then we need gup to block any changes from shared to guest private? I assume
there will be the usual issues of recognizing temporary elevated refcount vs
long-term gup, etc.

>> The upcoming TDX work to unmap the guest memory region from the
>> current process page table can easily extend for the SNP to cover the
>> current limitations.

By "current process page table" you mean userspace page tables?

> My preference would be that we never have SEV-SNP code in the kernel
> that can panic() the host from guest userspace.  If that means waiting
> until there's common guest unmapping infrastructure around, then I think
> we should wait.
> 

