Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 917A217DB3E
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 09:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbgCIIkN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 04:40:13 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27574 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726383AbgCIIkN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Mar 2020 04:40:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583743212;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zJSpyr7luHC5gmOgZtB7q0gqS7e3sos2ucW8TuRhnqw=;
        b=KusXA8ZO1MKGhzEEykL09XneeOA96SgbSujOx91WvKnqVW5/kD7Ld6ctZZmtifCHhfKREz
        kAqiPcT4j80pWCCMiMv+LIFfNNb6oZ/wMzyOs3LiRyJhaxcho2gJKC91qGDuRAAtOtzxR2
        2EQBKXX7fmgccQ25MYy5uZUGSXh+LQg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-292-Z-welltNM3uiCHN6uZoysg-1; Mon, 09 Mar 2020 04:40:10 -0400
X-MC-Unique: Z-welltNM3uiCHN6uZoysg-1
Received: by mail-wm1-f72.google.com with SMTP id t8so1827573wmd.1
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2020 01:40:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zJSpyr7luHC5gmOgZtB7q0gqS7e3sos2ucW8TuRhnqw=;
        b=P7m/dWvewNrLXsQoQwtBU2Ixe69Y+Iw2A5uosyAAHsqxlwLLqTsZVKa3VNSNlPAJgq
         WJDLlaw4ZTGn3C9EDrAxXpOyFeDfumCejIeU0DZx1APeMAGMfa1D0wEwaL1TDnFo/h/0
         73++9DmZ4HCJN40NGFCElYTVnDISR/BMoFr8o9knTFbaoCgW4f6gyhdV6JqEQcqr39An
         B8GNojNUK6zdXNMjFIipyLhFumnzjv+sb28RsUutxFfWuA3GycgANME2DOpIy3tO4H/a
         Nt3UuHtNfEs6FYYW3gwv6WE6w5YiOsIUxkd9Zsm0dn8ihz42jZSFC1nVkVfAfuMHtKT6
         VHGQ==
X-Gm-Message-State: ANhLgQ2n/QIFL40InTdZmcBP26fsgiZSqU/ekYM+AWX5HQCTTwwXuBP+
        JqBbuWqFOdS34owh1PGoG8owMDSlnHVLGrwBlLPYvUd9OOofOsYYM7fAvhXJ18NlghxwJE7zILA
        MLV27+yLnabpE
X-Received: by 2002:a1c:a9d5:: with SMTP id s204mr15876274wme.172.1583743209082;
        Mon, 09 Mar 2020 01:40:09 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsXM2dy9yL7nesp7zcPCTzXD1JQsxvHew299Rlk430F8GQGQJUvV3VoV5en67YytjGcWtt50A==
X-Received: by 2002:a1c:a9d5:: with SMTP id s204mr15876245wme.172.1583743208779;
        Mon, 09 Mar 2020 01:40:08 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:4887:2313:c0bc:e3a8? ([2001:b07:6468:f312:4887:2313:c0bc:e3a8])
        by smtp.gmail.com with ESMTPSA id k2sm29528088wrn.57.2020.03.09.01.40.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2020 01:40:08 -0700 (PDT)
Subject: Re: [PATCH v2] x86/kvm: Disable KVM_ASYNC_PF_SEND_ALWAYS
To:     Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>, stable <stable@vger.kernel.org>
References: <ed71d0967113a35f670a9625a058b8e6e0b2f104.1583547991.git.luto@kernel.org>
 <CALCETrVmsF9JSMLSd44-3GGWEz6siJQxudeaYiVnvv__YDT1BQ@mail.gmail.com>
 <87ftek9ngq.fsf@nanos.tec.linutronix.de>
 <CALCETrVsc-t=tDRPbCg5dWHDY0NFv2zjz12ahD-vnGPn8T+RXA@mail.gmail.com>
 <87a74s9ehb.fsf@nanos.tec.linutronix.de>
 <87wo7v8g4j.fsf@nanos.tec.linutronix.de>
 <877dzu8178.fsf@nanos.tec.linutronix.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <37440ade-1657-648b-bf72-2b8ca4ac21ce@redhat.com>
Date:   Mon, 9 Mar 2020 09:40:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <877dzu8178.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/03/20 07:57, Thomas Gleixner wrote:
> Thomas Gleixner <tglx@linutronix.de> writes:
>> Thomas Gleixner <tglx@linutronix.de> writes:
>>> Andy Lutomirski <luto@kernel.org> writes:
>>>> On Sat, Mar 7, 2020 at 7:47 AM Thomas Gleixner <tglx@linutronix.de> wrote:
>>>>> If MCE, NMI trigger a real pagefault then the #PF injection needs to
>>>>> clear apf_reason and set the correct CR2. When that #PF returns then the
>>>>> old CR2 and apf_reason need to be restored.
>>>>
>>> The host does not care about the IRET. It solely has to check whether
>>> apf_reason is 0 or not. That way it knows that the guest has read CR2
>>> and apf_reason.
> 
> Some hours or sleep and not staring at this meess later and while
> reading the leaves of my morning tea:
> 
> guest side:
> 
>    nmi()/mce() ...
>    
>         stash_crs();
> 
> +       stash_and_clear_apf_reason();
> 
>         ....
> 
> +       restore_apf_reason();
> 
> 	restore_cr2();
> 
> Too obvious, isn't it?

Yes, this works but Andy was not happy about adding more
save-and-restore to NMIs.  If you do not want to do that, I'm okay with
disabling async page fault support for now.

Storing the page fault reason in memory was not a good idea.  Better
options would be to co-opt the page fault error code (e.g. store the
reason in bits 31:16, mark bits 15:0 with the invalid error code
RSVD=1/P=0), or to use the virtualization exception area.

Paolo

