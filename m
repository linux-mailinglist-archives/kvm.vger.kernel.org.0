Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5648B1E11FA
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 17:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404221AbgEYPmz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 11:42:55 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:56908 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404122AbgEYPmz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 May 2020 11:42:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590421373;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3vYHKDvyAIo7f+4+8rStf8JenmWg3cFq5KE9Yy8/9hM=;
        b=IqD+ho9ta7sHOQnLac2ohsmVtZUVTtGp/pW1Alopt4ZOwc8Chnk8MG4MtGGXdFodJESxY/
        2N/x7mXdlOiGnFEmekqjh8aJ34rqqS/OXp0YO4su1UQWR4Pfk+oOh9nOD73f5yv7azLtuQ
        KP2RiC5YLZMrv7sACSU6teHZcJm5QR4=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-503-CG2QRVzhOHCkLH1keL28BQ-1; Mon, 25 May 2020 11:42:52 -0400
X-MC-Unique: CG2QRVzhOHCkLH1keL28BQ-1
Received: by mail-ej1-f69.google.com with SMTP id pw1so6418141ejb.8
        for <kvm@vger.kernel.org>; Mon, 25 May 2020 08:42:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=3vYHKDvyAIo7f+4+8rStf8JenmWg3cFq5KE9Yy8/9hM=;
        b=GTQ2XFT0/ucpy/hH+Y3tR+l4eMX5pM1pV24rnZCwvh8kCji7ZrY38pwJgMwzdN6Osj
         YqDYIi9wr3PCxQhNWJV+tcnnW9Vq1tpqj3TTaIg1NqYhALzauaEHisOKAfQuPrD2WWh6
         hrFvAep0FS+zrkaTVhGE3/5qJV+D7fcdhxHx3FFG4mWM9tV0XeUeD7BTpfFT8yhRz814
         /YkG++/joqhKu5LvUHTADt3fh3IN311RU5pHpdTtY8sJ8LxZhtnb/yiOEa5nardCGhFd
         ab4rF4t1hpoluwBPn1u6yXQzHVrDchvJL1rB1+LjfDb7YcLa8upahsikOSSpXbHsrM0D
         g/rA==
X-Gm-Message-State: AOAM5309KI/WyZVMwMBduR2+Pu1RNyKj3w5eqhsV66r64AAmexgvhPRg
        eJYfZdc43PlbNa7yKV6lY7MrTeMUwQMmh5t/RPRG08Jge7h/5Y3vtFJ6MrcGtEwHKHDehlHq30Z
        17tmhiliOnzeb
X-Received: by 2002:a50:8165:: with SMTP id 92mr16085665edc.263.1590421370954;
        Mon, 25 May 2020 08:42:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzGSWgO76QR2V0LyE7qteEGb8bQaL/pDvG4rJS4OeAKgPxt9awtw5ua1zb/U6iY5ijx4zHUBg==
X-Received: by 2002:a50:8165:: with SMTP id 92mr16085655edc.263.1590421370763;
        Mon, 25 May 2020 08:42:50 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id b27sm15514775ejd.6.2020.05.25.08.42.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2020 08:42:50 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     "Kirill A. Shutemov" <kirill@shutemov.name>
Cc:     David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe\, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen\, Andi" <andi.kleen@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [RFC 13/16] x86/kvmclock: Share hvclock memory with the host
In-Reply-To: <20200525152527.7g57us6imlh62x7i@box>
References: <20200522125214.31348-1-kirill.shutemov@linux.intel.com> <20200522125214.31348-14-kirill.shutemov@linux.intel.com> <875zck82fx.fsf@vitty.brq.redhat.com> <20200525152527.7g57us6imlh62x7i@box>
Date:   Mon, 25 May 2020 17:42:48 +0200
Message-ID: <87v9kk6mx3.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

"Kirill A. Shutemov" <kirill@shutemov.name> writes:

> On Mon, May 25, 2020 at 05:22:10PM +0200, Vitaly Kuznetsov wrote:
>> "Kirill A. Shutemov" <kirill@shutemov.name> writes:
>> 
>> > hvclock is shared between the guest and the hypervisor. It has to be
>> > accessible by host.
>> >
>> > Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
>> > ---
>> >  arch/x86/kernel/kvmclock.c | 2 +-
>> >  1 file changed, 1 insertion(+), 1 deletion(-)
>> >
>> > diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
>> > index 34b18f6eeb2c..ac6c2abe0d0f 100644
>> > --- a/arch/x86/kernel/kvmclock.c
>> > +++ b/arch/x86/kernel/kvmclock.c
>> > @@ -253,7 +253,7 @@ static void __init kvmclock_init_mem(void)
>> >  	 * hvclock is shared between the guest and the hypervisor, must
>> >  	 * be mapped decrypted.
>> >  	 */
>> > -	if (sev_active()) {
>> > +	if (sev_active() || kvm_mem_protected()) {
>> >  		r = set_memory_decrypted((unsigned long) hvclock_mem,
>> >  					 1UL << order);
>> >  		if (r) {
>> 
>> Sorry if I missed something but we have other structures which KVM guest
>> share with the host,
>> 
>> sev_map_percpu_data():
>> ...
>> 	for_each_possible_cpu(cpu) {
>> 		__set_percpu_decrypted(&per_cpu(apf_reason, cpu), sizeof(apf_reason));
>> 		__set_percpu_decrypted(&per_cpu(steal_time, cpu), sizeof(steal_time));
>> 		__set_percpu_decrypted(&per_cpu(kvm_apic_eoi, cpu), sizeof(kvm_apic_eoi));
>> 	}
>> ...
>> 
>> Do you handle them somehow in the patchset? (I'm probably just blind
>> failing to see how 'early_set_memory_decrypted()' is wired up)
>
> I don't handle them yet: I've seen the function, but have not modified it.
> I want to understand first why it doesn't blow up for me without the
> change. Any clues?

(if I got the idea of the patchset right) these features are kernel-only
(e.g. QEMU doesn't need to access these areas). E.g. for APF KVM will do
kvm_write_guest_cached() and this will use FOLL_KVM. Guests should not
rely on that and mark all shared areas as unprotected.

-- 
Vitaly

