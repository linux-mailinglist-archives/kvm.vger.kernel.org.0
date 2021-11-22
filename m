Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71840459397
	for <lists+kvm@lfdr.de>; Mon, 22 Nov 2021 18:03:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235300AbhKVRGt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 12:06:49 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:39444 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234435AbhKVRGt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Nov 2021 12:06:49 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 5444221709;
        Mon, 22 Nov 2021 17:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1637600621; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4rRkvJNhAxWx1zyxF3tUb1zr1nvSxZ9nWkvMm51WNrQ=;
        b=cKEZqdfqMr3kLw1vFZhwmecn+FJayjamhLA9XKKumc4O5xj1x5AWqQ7f9UJlwxi0ST9Ja3
        dMifHwzdNrvmUA+5IUc45aw0vgZ6z8l/SV11lEuU/MjptXYlAU6jSQgZpsQgFLREMaj7sx
        k2mcCM5Doj/4X41chTeiRZ0ENf7wXR4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1637600621;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4rRkvJNhAxWx1zyxF3tUb1zr1nvSxZ9nWkvMm51WNrQ=;
        b=H3f6ATUtgp03kEO0DJKZkjPwUUL6XgXB+JBO7QX9kELJzZDpaa1Cb11GOOX+s/Z/vkD2M2
        HKhNCExz+g0iSWAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C349113B44;
        Mon, 22 Nov 2021 17:03:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id gnD3LmzNm2F6QQAAMHmgww
        (envelope-from <vbabka@suse.cz>); Mon, 22 Nov 2021 17:03:40 +0000
Message-ID: <6e67f74a-fb4e-fda4-9583-dad28f14ed3a@suse.cz>
Date:   Mon, 22 Nov 2021 18:03:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH Part2 v5 00/45] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
Content-Language: en-US
To:     Brijesh Singh <brijesh.singh@amd.com>,
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
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <daf5066b-e89b-d377-ed8a-9338f1a04c0d@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/22/21 16:23, Brijesh Singh wrote:
> Hi Peter,
> 
> On 11/12/21 9:43 AM, Peter Gonda wrote:
>> Hi Brijesh,,
>>
>> One high level discussion I'd like to have on these SNP KVM patches.
>>
>> In these patches (V5) if a host userspace process writes a guest
>> private page a SIGBUS is issued to that process. If the kernel writes
>> a guest private page then the kernel panics due to the unhandled RMP
>> fault page fault. This is an issue because not all writes into guest
>> memory may come from a bug in the host. For instance a malicious or
>> even buggy guest could easily point the host to writing a private page
>> during the emulation of many virtual devices (virtio, NVMe, etc). For
>> example if a well behaved guests behavior is to: start up a driver,
>> select some pages to share with the guest, ask the host to convert
>> them to shared, then use those pages for virtual device DMA, if a
>> buggy guest forget the step to request the pages be converted to
>> shared its easy to see how the host could rightfully write to private
>> memory. I think we can better guarantee host reliability when running
>> SNP guests without changing SNP’s security properties.
>>
>> Here is an alternative to the current approach: On RMP violation (host
>> or userspace) the page fault handler converts the page from private to
>> shared to allow the write to continue. This pulls from s390’s error
>> handling which does exactly this. See ‘arch_make_page_accessible()’.
>> Additionally it adds less complexity to the SNP kernel patches, and
>> requires no new ABI.
>>
>> In the current (V5) KVM implementation if a userspace process
>> generates an RMP violation (writes to guest private memory) the
>> process receives a SIGBUS. At first glance, it would appear that
>> user-space shouldn’t write to private memory. However, guaranteeing
>> this in a generic fashion requires locking the RMP entries (via locks
>> external to the RMP). Otherwise, a user-space process emulating a
>> guest device IO may be vulnerable to having the guest memory
>> (maliciously or by guest bug) converted to private while user-space
>> emulation is happening. This results in a well behaved userspace
>> process receiving a SIGBUS.
>>
>> This proposal allows buggy and malicious guests to run under SNP
>> without jeopardizing the reliability / safety of host processes. This
>> is very important to a cloud service provider (CSP) since it’s common
>> to have host wide daemons that write/read all guests, i.e. a single
>> process could manage the networking for all VMs on the host. Crashing
>> that singleton process kills networking for all VMs on the system.
>>
> Thank you for starting the thread; based on the discussion, I am keeping the
> current implementation as-is and *not* going with the auto conversion from
> private to shared. To summarize what we are doing in the current SNP series:
> 
> - If userspace accesses guest private memory, it gets SIGBUS.

So, is there anything protecting host userspace processes from malicious guests?

> - If kernel accesses[*] guest private memory, it does panic.
> 
> [*] Kernel consults the RMP table for the page ownership before the access.
> If the page is shared, then it uses the locking mechanism to ensure that a
> guest will not be able to change the page ownership while kernel has it mapped.
> 
> thanks
> 
