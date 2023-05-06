Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 177FB6F904F
	for <lists+kvm@lfdr.de>; Sat,  6 May 2023 09:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231354AbjEFHo4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 May 2023 03:44:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231444AbjEFHoy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 May 2023 03:44:54 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3551E46;
        Sat,  6 May 2023 00:44:52 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 5B82A22316;
        Sat,  6 May 2023 07:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1683359091; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fIDvcIp0irJ9nejo79mAMo8eZX7vhyfnB/9sV4I6BVc=;
        b=UZV+c3hiyyOkfV/XezlgAfmyyo/QUMnJEhP4WzWXfiaKANzoCNt5LA/dQb5h/oPNdB+r0r
        0+6pGoMUr5MZYrNQL4dHdFXmTco0B5rROt1idt3GO+qquSE4iH/ByLsUIbjKHjlIMmJ27m
        rjTkGLuTXK8Zg03go7YkM99O+IvuUiY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1683359091;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fIDvcIp0irJ9nejo79mAMo8eZX7vhyfnB/9sV4I6BVc=;
        b=dQGIBY9s2MYs2o/JzZcBaikk819IihoO+S/GdXDCBW824SyAsNLgrFKK+HdzfcAnGbZOBO
        OR27gVT3dPS8+WCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0C252134FB;
        Sat,  6 May 2023 07:44:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id KSY+AnMFVmRHXgAAMHmgww
        (envelope-from <vbabka@suse.cz>); Sat, 06 May 2023 07:44:51 +0000
Message-ID: <3b0ec3da-ba18-7b9f-4e84-1cc30e78aed7@suse.cz>
Date:   Sat, 6 May 2023 09:44:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: Rename restrictedmem => guardedmem? (was: Re: [PATCH v10 0/9]
 KVM: mm: fd-based approach for supporting KVM)
To:     David Hildenbrand <david@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Chao Peng <chao.p.peng@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        Vishal Annapurve <vannapurve@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        dhildenb@redhat.com, Quentin Perret <qperret@google.com>,
        tabba@google.com, Michael Roth <michael.roth@amd.com>,
        wei.w.wang@intel.com, Mike Rapoport <rppt@kernel.org>,
        Liam Merwick <liam.merwick@oracle.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Ackerley Tng <ackerleytng@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221202061347.1070246-1-chao.p.peng@linux.intel.com>
 <ZD1oevE8iHsi66T2@google.com>
 <658018f9-581c-7786-795a-85227c712be0@redhat.com>
 <CS465PQZS77J.J1RP6AJX1CWZ@suppilovahvero>
 <6db68140-0612-a7a3-2cec-c583b2ed3a61@redhat.com>
Content-Language: en-US
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <6db68140-0612-a7a3-2cec-c583b2ed3a61@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/5/23 22:00, David Hildenbrand wrote:
> On 23.04.23 15:28, Jarkko Sakkinen wrote:
>> On Mon Apr 17, 2023 at 6:48 PM EEST, David Hildenbrand wrote:
>>> On 17.04.23 17:40, Sean Christopherson wrote:
>>>> What do y'all think about renaming "restrictedmem" to "guardedmem"?
>>>
>>> Yeay, let's add more confusion :D
>>>
>>> If we're at renaming, I'd appreciate if we could find a terminology that
>>> does look/sound less horrible.
>>>
>>>>
>>>> I want to start referring to the code/patches by its syscall/implementation name
>>>> instead of "UPM", as "UPM" is (a) very KVM centric, (b) refers to the broader effort
>>>> and not just the non-KVM code, and (c) will likely be confusing for future reviewers
>>>> since there's nothing in the code that mentions "UPM" in any way.
>>>>
>>>> But typing out restrictedmem is quite tedious, and git grep shows that "rmem" is
>>>> already used to refer to "reserved memory".
>>>>
>>>> Renaming the syscall to "guardedmem"...
>>>
>>> restrictedmem, guardedmem, ... all fairly "suboptimal" if you'd ask me ...
>> 
>> In the world of TEE's and confidential computing it is fairly common to
>> call memory areas enclaves, even outside SGX context. So in that sense
>> enclave memory would be the most correct terminology.
> 
> I was also thinking along the lines of isolated_mem or imem ... 
> essentially, isolated from (unprivileged) user space.
> 
> ... if we still want to have a common syscall for it.

I'm fan of the ioctl, if it has a chance of working out.

