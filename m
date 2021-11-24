Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DCFF45CD54
	for <lists+kvm@lfdr.de>; Wed, 24 Nov 2021 20:35:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343564AbhKXTiv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 14:38:51 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:36820 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244374AbhKXTit (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 14:38:49 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 1236921941;
        Wed, 24 Nov 2021 19:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1637782538; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9aE3EhkO73udWwtqxOb92KxXE9U0rU8t4YmlonhA+V8=;
        b=miE5FQ0EmpLG7PCHR31uA10N/ZFm2mNsSBywv0kaSPjh7QYid6lV4IojRLs+VlKK81Kcz3
        HP/QQoDZuLCY0jea6eF66Twomiem2IgB0bWUCwsD6qaOAyDg31WYutGa3kYCBgatlx0+RL
        v96Rbmyn4X0VdcSQqUWxHquX7swquLU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1637782538;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9aE3EhkO73udWwtqxOb92KxXE9U0rU8t4YmlonhA+V8=;
        b=v/TlsoC9ZbCs9hGeb1ub5z4ev4ke8hB4iEfUxgP8y1NmHSRRbJHHAWZuaaFi2hxNXnDEfW
        a6gKhCuWtiHulsDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4C44513F3D;
        Wed, 24 Nov 2021 19:35:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id IELGEAmUnmELdwAAMHmgww
        (envelope-from <vbabka@suse.cz>); Wed, 24 Nov 2021 19:35:37 +0000
Message-ID: <cabdf9d2-0ecf-5ec7-368e-83fea66ef39f@suse.cz>
Date:   Wed, 24 Nov 2021 20:34:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH Part2 v5 00/45] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
Content-Language: en-US
To:     Dave Hansen <dave.hansen@intel.com>, Joerg Roedel <jroedel@suse.de>
Cc:     Brijesh Singh <brijesh.singh@amd.com>,
        Peter Gonda <pgonda@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
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
 <38282b0c-7eb5-6a91-df19-2f4cfa8549ce@intel.com> <YZ5iWJuxjSCmZL5l@suse.de>
 <bd31abd4-c8a2-bdda-ea74-1c24b29beda7@intel.com>
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <bd31abd4-c8a2-bdda-ea74-1c24b29beda7@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/24/21 18:48, Dave Hansen wrote:
> On 11/24/21 8:03 AM, Joerg Roedel wrote:
>> On Mon, Nov 22, 2021 at 02:51:35PM -0800, Dave Hansen wrote:
>>> My preference would be that we never have SEV-SNP code in the kernel
>>> that can panic() the host from guest userspace.  If that means waiting
>>> until there's common guest unmapping infrastructure around, then I think
>>> we should wait.
>> Can you elaborate how to crash host kernel from guest user-space? If I
>> understood correctly it was about crashing host kernel from _host_
>> user-space.
> 
> Sorry, I misspoke there.
> 
> My concern is about crashing the host kernel.  It appears that *host*
> userspace can do that quite easily by inducing the host kernel to access
> some guest private memory via a kernel mapping.

I thought some of the scenarios discussed here also went along "guest
(doesn't matter if userspace or kernel) shares a page with host, invokes
some host kernel operation and in parallel makes the page private again".

>> I think the RMP-fault path in the page-fault handler needs to take the
>> uaccess exception tables into account before actually causing a panic.
>> This should solve most of the problems discussed here.
> 
> That covers things like copy_from_user().  It does not account for
> things where kernel mappings are used, like where a
> get_user_pages()/kmap() is in play.
> 

